#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
+===================+======================+=========================+
|Programa: LSVIMPSL |Autor: Antonio Carlos |Data: 11/03/08           |
+===================+======================+=========================|
|Descricao: Este programa tem o objeivo de importar os registros     |
|das tabelas temporarias PA1/PA2/PA4 para as tabelas SL1/SL2/SL4 do  |
|Front-Loja (Protheus) para integracao do ERP.                       |
+====================================================================+
|Uso: Laselva                                                        |
+====================================================================+
*/

/*
+===========================================+
|Revisão para atualização do Protheus 10    |
+===========================================+
|Responsavel: Antonio Carlos |Data: 15/10/10|
+===========================================+
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSVIMPSL(aParam)
//////////////////////////////
Local cCadastro    	:= " Importacao Vendas PDV "
Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0
Local oDlg
Local cArqLock 		:= "LSVIMPSL.lck"

Private oProcess
Private _lJob	:= .F. //(aParam == Nil .Or. ValType(aParam) <> "A")

If !_lJob
	
	fErase(cArqLock)
	If !file(cArqLock)
		AtuDados(cArqLock)
		//U_LSVIMPSE()
		//U_LSVIMPSF()
		//U_ESTP019()
	EndIf

Else
	Aadd(aSays,OemToAnsi("Este programa tem o objetivo de importar os registros de vendas"))
	Aadd(aSays,OemToAnsi("PDV do E-Connect para o Protheus."))
	
	Aadd(aButtons, { 1,.T.,{|o| nOpc:= 1,If(MsgYesNo(OemToAnsi("Confirma processamento?"),OemToAnsi("Atenção")),o:oWnd:End(),nOpc:=0) } } )
	Aadd(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	
	FormBatch( cCadastro, aSays, aButtons,,200,405 )
	
	If nOpc == 1
		oProcess := MsNewProcess():New({|lEnd| AtuDados(@lEnd)},"Processando","Transferindo...",.T.)
		oProcess:Activate()
	EndIf
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AtuDados(cArqLock)
//////////////////////////////////

Local aparam   := {"01","01"}
Local nHdlLock := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua o Lock de gravacao da Rotina - Monousuario            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdlLock := MsFCreate(cArqLock)
If nHdlLock < 0
	Return(.T.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa ambiente.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RpcSetType(3)
IF FindFunction('WFPREPENV')
	WfPrepEnv( aParam[1], aParam[2])
Else
	Prepare Environment Empresa aParam[1] Filial aParam[2]
EndIF
ChkFile("SM0")

Integra()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha filial corrente.						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !_lJob .and. FunName() <> 'LSVIMPSL'
	Reset Environment
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cancela o Lock de gravacao da rotina                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FClose(nHdlLock)
FErase(cArqLock)

Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Integra()
/////////////////////////

Local aArea		:= GetArea()
Local _aCpoErr	:= {}
Local nNum		:= Space(6)
Local cCliPad	:= "999999" 	//Cliente padrao
Local lGrava	:= .T.
Local _cOperado	:= ""

DbSelectArea("SX5")
SX5->( DbSetOrder(1) )

//	Query alterada por Rodrigo Oliveira a pedido de Hélio Assis em 12/06/12: consiste registros na PA4

cQuery1 := " SELECT PA1.*  "
cQuery1 += " FROM " + RetSqlName("PA1") + " PA1 (NOLOCK)  "
cQuery1 += " INNER JOIN " + RetSqlName("PA4") + " PA4 (NOLOCK) "
cQuery1 += " 										ON PA1_FILIAL 	= PA4_FILIAL "
cQuery1 += " 										AND PA1_NUMCFI 	= PA4_NUMCFI "
cQuery1 += " 										AND PA1_EMISSA 	= PA4_DATA  "
cQuery1 += " 										AND PA1_PDV 	= PA4_PDV "
cQuery1 += " 										AND PA1_OPERAD 	= PA4_OPERAD "
cQuery1 += " WHERE  PA1_STATUS 		= ''  "
cQuery1 += " AND  PA1.D_E_L_E_T_ 	= ''  "
cQuery1 += " ORDER BY PA1.R_E_C_N_O_ "

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery1), "TMP", .F., .T.)

//=======================================//
// Tabela de orçamento PA1 -> SL1        //
//=======================================//

DbSelectArea("TMP")
Do While !Eof()
	
	Begin Transaction
	
	DbSelectArea('SL1')
	DbOrderNickName("LASL1") //Indice: L1_FILIAL+L1_EMISSAO+L1_PDV+L1_NUMCFIS
	
	lGrava := !SL1->( DbSeek(TMP->PA1_FILIAL+TMP->PA1_EMISSA+TMP->PA1_PDV+TMP->PA1_NUMCFI))
	
	If lGrava
		
		If !TMP->PA1_CLIENT $ cCliPad
			SA1->( dbSetOrder(3) )
			SA1->( DbSeek(xFilial("SA1")+TMP->PA1_CNPJ) )
		Else
			SA1->( dbSetOrder(1) )
			SA1->( DbSeek(xFilial("SA1")+cCliPad+TMP->PA1_FILIAL) )
		EndIf
		
		cQry := " SELECT MAX(L1_NUM) AS NUMORC "
		cQry += " FROM  "	+RetSqlName("SL1")+ " SL1 (NOLOCK) "
		cQry += " WHERE "
		cQry += " L1_FILIAL = '" + TMP->PA1_FILIAL + "' AND "
		cQry += " SL1.D_E_L_E_T_ = '' "
		dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "TRB", .F., .T.)
		
		DbSelectArea("TRB")
		nNum := Soma1(TRB->NUMORC)
		DbCloseArea()
		
		SX5->( DbSeek(Space(2)+'ZC'+Substr(TMP->PA1_FILIAL,1,2)+Substr(TMP->PA1_PDV,9,2)) )
		If SX5->( Found() )
			_serie := subst(SX5->X5_DESCRI,1,3)
		Else
			_serie := 'LSV'
		EndIf
		
		SX5->( DbSeek(Space(02)+"ZF"+Substr(TMP->PA1_FILIAL,1,2) ) )
		_cOperado := SX5->X5_DESCRI
		
		RecLock("SL1",lGrava)		
		SL1->L1_FILIAL  	:= TMP->PA1_FILIAL
		SL1->L1_EMISSAO		:= SToD(TMP->PA1_EMISSA)
		SL1->L1_SERIE		:= _serie  // Substr(TMP->PA1_PDV,8,3)
		SL1->L1_EMISNF		:= SToD(TMP->PA1_EMISSA)
		SL1->L1_DOC			:= TMP->PA1_NUMCFI
		SL1->L1_PDV			:= TMP->PA1_PDV
		SL1->L1_NUMCFIS		:= TMP->PA1_NUMCFI
		SL1->L1_NUM     	:= nNum
		SL1->L1_HORA	 	:= TMP->PA1_HORA
		SL1->L1_SITUA		:= TMP->PA1_SITUA
		SL1->L1_VLRLIQ		:= TMP->PA1_VLRTOT - TMP->PA1_DESCON
		SL1->L1_VALBRUT		:= TMP->PA1_VLRTOT
		SL1->L1_DESCONT		:= TMP->PA1_DESCON
		SL1->L1_VLRTOT		:= TMP->PA1_VLRTOT
		SL1->L1_VALMERC		:= TMP->PA1_VLRTOT - TMP->PA1_DESCON
		SL1->L1_OPERADO		:= _cOperado
		SL1->L1_CNPJ		:= SA1->A1_CGC
		SL1->L1_CHEQUES		:= TMP->PA1_CHEQUE
		SL1->L1_CONVENI		:= TMP->PA1_CONVEN
		SL1->L1_FINANC		:= TMP->PA1_FINANC
		SL1->L1_OUTROS		:= TMP->PA1_OUTROS
		SL1->L1_JUROS		:= TMP->PA1_JUROS
		SL1->L1_INTERV		:= TMP->PA1_INTERV
		SL1->L1_DINHEIR		:= TMP->PA1_DINHEI
		SL1->L1_CARTAO		:= TMP->PA1_CARTAO
		SL1->L1_VALES		:= TMP->PA1_VALES
		SL1->L1_VLRDEBI		:= TMP->PA1_VLRDEB
		SL1->L1_ENTRADA		:= TMP->PA1_ENTRAD
		If TMP->PA1_PARCEL = 0
			SL1->L1_PARCELA		:= 1
		Else
			SL1->L1_PARCELA		:= TMP->PA1_PARCEL
		EndIf
		SL1->L1_CLIENTE 	:= SA1->A1_COD
		SL1->L1_LOJA 		:= SA1->A1_LOJA
		SL1->L1_TIPOCLI 	:= SA1->A1_TIPO
		SL1->L1_VEND		:= SA1->A1_VEND
		SL1->L1_DTLIM		:= dDataBase + 5
		SL1->L1_ESTACAO 	:= TMP->PA1_PDV
		SL1->L1_CONDPG		:= "CN"
		SL1->L1_IMPRIME 	:=	"1S"
		SL1->L1_CONFVEN 	:=	"SSSSSSSSNSSS"
		SL1->L1_COMIS   	:=	0
		SL1->L1_TIPO   		:=	"V"
		SL1->L1_DESCNF 		:= 0
		SL1->L1_VENDTEF 	:=	"N"
		SL1->L1_TXDESC  	:=	0
		SL1->L1_CREDITO 	:=	0
		SL1->L1_CONDPG 		:=	"CN"		
		MsUnlock()
		
		//===========================================//
		// Tabela de item do orçamento PA2 -> SL2    //
		//===========================================//
		
		DbSelectArea("PA2")
		DbSetOrder(1) //Indice: PA2_FILIAL+PA2_EMISSA+PA2_PDV+PA2_NUMCFI+PA2_ITEM
		
		If DbSeek(TMP->PA1_FILIAL+TMP->PA1_EMISSA+TMP->PA1_PDV+TMP->PA1_NUMCFI)
			
			Do While !Eof() .And. TMP->PA1_FILIAL == PA2->PA2_FILIAL   .And. SToD(TMP->PA1_EMISSA) == PA2->PA2_EMISSA .And.;
				TMP->PA1_PDV == PA2->PA2_PDV .And. TMP->PA1_NUMCFI == PA2->PA2_NUMCFI 
				
				DbSelectArea("SL2")
				DbSetOrder(7) //Indice: L2_FILIAL+L2_SERIE+L2_DOC+L2_PRODUTO+L2_ITEM
				
				lGrava := !DbSeek(PA2->PA2_FILIAL+SL1->L1_SERIE+PA2->PA2_NUMCFI+PA2->PA2_ITEM+PA2->PA2_PRODUT)
				
				RecLock("SL2",lGrava)				
				SL2->L2_FILIAL		:= PA2->PA2_FILIAL
				SL2->L2_EMISSAO 	:= PA2->PA2_EMISSA
				SL2->L2_SERIE		:= SL1->L1_SERIE
				SL2->L2_DOC			:= PA2->PA2_NUMCFI
				SL2->L2_PDV   		:= PA2->PA2_PDV
				SL2->L2_NUMCFIS		:= PA2->PA2_NUMCFI
				SL2->L2_ITEM		:= PA2->PA2_ITEM 
				SL2->L2_NUM  		:= nNum
				SL2->L2_SITUA		:= PA2->PA2_SITUA
				SL2->L2_PRODUTO 	:= PA2->PA2_PRODUT
				SL2->L2_LOCAL		:= PA2->PA2_LOCAL
				SL2->L2_UM  		:= PA2->PA2_UM
				SL2->L2_TES   		:= PA2->PA2_TES
				SL2->L2_CF  		:= PA2->PA2_CF
				SL2->L2_TABELA		:= "1"
				SL2->L2_PRCTAB		:= PA2->PA2_VLRDIG
				SL2->L2_DESCRI		:= PA2->PA2_DESCRI
				SL2->L2_QUANT		:= PA2->PA2_QUANT
				SL2->L2_VRUNIT		:= PA2->PA2_VRUNIT
				SL2->L2_VALDESC		:= PA2->PA2_VALDES
				SL2->L2_VLRITEM		:= PA2->PA2_VLRITE
				SL2->L2_VEND		:= PA2->PA2_VEND
				SL2->L2_GRADE		:= "N"
				SL2->L2_ENTREGA		:= "2"
				SL2->L2_VENDIDO		:= "S"
				SL2->L2_CUSTO1      := Posicione('SB2',1, PA2->PA2_FILIAL + PA2->PA2_PRODUT + PA2->PA2_LOCAL,'B2_CM1')				
				MsUnlock()
				
				DbSelectArea('PA2')
				DbSkip()
				
			EndDo
			
		EndIf
		
		//==========================================================//
		// Tabela de movimento por forma de pagamento PA4 -> SL4    //
		//==========================================================//
		
		DbSelectArea("PA4")
		DbSetOrder(2) //Indice: PA4_FILIAL+PA4_DATA+PA4_OPERAD+PA4_PDV+PA4_NUMCFI
		
		If DbSeek(TMP->PA1_FILIAL+TMP->PA1_EMISSA+TMP->PA1_OPERAD+TMP->PA1_PDV+TMP->PA1_NUMCFI )
			
			Do While !Eof() .And. PA4->PA4_FILIAL == TMP->PA1_FILIAL  .And. PA4->PA4_DATA == SToD(TMP->PA1_EMISSA)  .And. PA4->PA4_OPERAD	 == TMP->PA1_OPERAD  .And.;
				PA4->PA4_PDV == TMP->PA1_PDV .And.	PA4->PA4_NUMCFI == TMP->PA1_NUMCFI
				
				RecLock("SL4",.T.)				
				SL4->L4_FILIAL    	:= PA4->PA4_FILIAL
				SL4->L4_DATA  		:= PA4->PA4_DATA
				SL4->L4_PDV	    	:= PA4->PA4_PDV
				SL4->L4_NUMCFIS  	:= PA4->PA4_NUMCFI
				SL4->L4_FORMA		:= PA4->PA4_FORMA
				SL4->L4_ADMINIS 	:= PA4->PA4_ADMINI
				SL4->L4_VALOR 		:= PA4->PA4_VALOR
				SL4->L4_TROCO 		:= PA4->PA4_TROCO
				SL4->L4_CONTA 		:= PA4->PA4_CONTA
				SL4->L4_NUMCART 	:= PA4->PA4_NUMCAR
				SL4->L4_AGENCIA 	:= PA4->PA4_AGENCI
				SL4->L4_CGC 		:= PA4->PA4_CGC
				SL4->L4_INSTITU		:= Posicione("SAE",1,xFilial("SAE")+PA4->PA4_ADMINI,"AE_DESC")
				SL4->L4_OPERADO	    := SL1->L1_OPERADO
				SL4->L4_NUM			:= nNum				
				MsUnlock()
				
				DbSelectArea('PA4')
				DbSkip()
				
			EndDo
			
		EndIf
		
		DbSelectArea("PA1")
		PA1->( DbSetOrder(1) )
		PA1->( DbSeek( TMP->PA1_FILIAL+TMP->PA1_EMISSA+TMP->PA1_OPERAD+TMP->PA1_PDV+TMP->PA1_NUMCFI ) )
		RecLock("PA1",.F.)
		PA1->PA1_STATUS := "TX"
		MsUnLock()
		
	EndIf
	
	End Transaction
	
	DbSelectArea('TMP')
	DbSkip()
	
EndDo

DbCloseArea()
RestArea(aArea)

Return
