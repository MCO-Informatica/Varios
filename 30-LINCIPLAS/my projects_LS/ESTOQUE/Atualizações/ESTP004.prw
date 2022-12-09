#include "Rwmake.ch"
#include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTP004   ºAutor  ³Antonio Carlos      º Data ³  05/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processa os registros da SZ8(Devolucao Venda PDV)           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ESTP004()

Private aSays		:= {}
Private aButtons	:= {}
Private	nOpca		:= 0   
Private lMsErroAuto := .F.
Private cCadastro	:= "Processa Devolucao de Vendas - PDV"

AADD(aSays,"Este programa tem o objetivo de processar os registros")
AADD(aSays,"referente as Devolucoes de Vendas - PDV das Lojas.")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )
	
If nOpcA == 1
 	Processa( {|lEnd| AtuDados(@lEnd)}, "Aguarde...","Processando registros...", .T. )		
EndIf	
		
Return
	
Static Function AtuDados()
	
Local aEmpFil  := {}
Local nHdlLock := 0
Local cArqLock := "estp004.lck"
Local aparam   := {"01","01"}
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua o Lock de gravacao da Rotina - Monousuario            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//FErase(cArqLock)
//nHdlLock := MsFCreate(cArqLock)
//If nHdlLock < 0
	//Conout("Rotina "+FunName()+" ja em execução.")
	//Return(.T.)
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona filiais.   						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SM0")
SM0->( DbSetOrder(1) )
SM0->( DbGoTop() )
While SM0->( !Eof() )
		
	AAdd(aEmpFil,{SM0->M0_CODIGO,SM0->M0_CODFIL,Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)})	
		
	SM0->( DbSkip() )
EndDo
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa rotinas por Empresa/filial.  			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len(aEmpFil)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Comando para nao comer licensas.     				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcSetType(3)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre a respectiva filial.            				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF FindFunction('WFPREPENV')
		WfPrepEnv( aEmpFil[nX,1], aEmpFil[nX,2])
	Else
		Prepare Environment Empresa aEmpFil[nX,1] Filial aEmpFil[nX,2]
	EndIF
	ChkFile("SM0")
		
	Processa( {|lEnd| ProcSD3(@lEnd)}, "Aguarde...","Processando registros...", .T. )
		
	Reset Environment
Next

Aviso("Devolucao de Vendas - PDV","Processamento efetuado com sucesso!",{"Ok"})		
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cancela o Lock de gravacao da rotina                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//FClose(nHdlLock)
//FErase(cArqLock)
	
Return(.T.)
	
Static Function ProcSD3(lEnd)

Local _nVlrUnit	:= 0
Local aVetor	:= {}
Local aArea		:= GetArea()  

MsgStop(xFilial("SZ8"))
	
cQry := " SELECT * "
cQry += " FROM "+RetSqlName("SZ8")+" SZ8 (NOLOCK)"
cQry += " WHERE "
cQry += " Z8_FILIAL = '"+xFilial("SZ8")+"' AND Z8_STATUS = 'RX' AND "
cQry += " SZ8.D_E_L_E_T_ = '' "
cQry += " ORDER BY Z8_FILIAL, Z8_DATA, Z8_PRODUTO "	
TcQuery cQry NEW ALIAS "TMP"
	
Count To nTotRec
ProcRegua(nTotRec)
	
DbSelectArea("TMP") 
TMP->( DbGoTop() )
If TMP->( !Eof() )
	While !TMP->( Eof() ) 
	
		IncProc("Processando...")		

		lMsErroAuto := .F.
		
		_nVlrUnit := Posicione("SB2",1,xFilial("SB2")+TMP->Z8_PRODUTO+"01","B2_CM1")
		
		If _nVlrUnit == 0
			_nVlrUnit := Posicione("SB1",1,xFilial("SB1")+TMP->Z8_PRODUTO,"B1_UPRC")
		EndIf
			
		If _nVlrUnit > 0	
			
			aVetor:={{"D3_TM"	,	"003"					,NIL	},;
			{"D3_COD"			,	TMP->Z8_PRODUTO			,NIL	},;
			{"D3_LOCAL"			,	"01"					,NIL	},;
			{"D3_EMISSAO"		,	StoD(TMP->Z8_DATA)		,NIL	},;
			{"D3_QUANT"			,	TMP->Z8_QUANT			,NIL	},;
			{"D3_CUSTO1"		,	Round(_nVlrUnit*TMP->Z8_QUANT,2),NIL}}
			
			MSExecAuto({|x,y| mata240(x,y)},aVetor,3) //Inclusao
				
			If lMsErroAuto
				Mostraerro()
			Else
				DbSelectArea("SZ8")
				SZ8->( DbSetOrder(2) )
				If DbSeek(xFilial("SZ8")+TMP->Z8_NUMCFI+TMP->Z8_PDV+"RX")
					RecLock("SZ8",.F.)
					SZ8->Z8_STATUS := "TX" 		
					MsUnLock()
				EndIf
			EndIf     
		
		EndIf	
			
		TMP->( DbSkip() )
	
	EndDo
		
EndIf   

DbSelectArea("TMP") 
DbCloseArea()

RestArea(aArea)
	
Return()