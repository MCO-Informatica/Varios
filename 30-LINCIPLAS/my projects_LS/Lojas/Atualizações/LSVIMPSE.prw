#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
+===================+======================+======================+
|Programa: LSVIMPSF |Autor: Antonio Carlos |Data: 04/05/08        |
+===================+======================+======================|
|Descricao: Rotina responsavel pela importacao da reducao Z (SFI) |
|gerada nas pdv's (Socim).                                        |
+=================================================================+
|Uso: Laselva                                                     |
+=================================================================+
*/

User Function LSVIMPSE(aParam)

Local nHdlLock	:= 0
Local cArqLock 	:= "LSVIMPSE.lck"
Private _lJob	:= .f. //(aParam == Nil .Or. ValType(aParam) <> "A")
aparam   		:= {"01","01"}

If !_lJob
	fErase(cArqLock)
	If file(cArqLock)
		return()
	EndIf
	
	/*
	If aParam == Nil .Or. ValType(aParam) <> "A"
	// Conout("Parametros nao recebidos => Empresa e Filial")
	Return
	Else
	// Conout("Parametros recebidos => Empresa "+aParam[1]+" Filial "+aParam[2])
	EndIf
	*/
	//====================================================//
	//Efetua o Lock de gravacao da Rotina - Monousuario   //
	//====================================================//
	
	FErase(cArqLock)
	nHdlLock := MsFCreate(cArqLock)
	If nHdlLock < 0
		// Conout("Rotina "+FunName()+" ja em execução.")
		Return(.T.)
	EndIf
	
	If FunName() <> 'LSVIMPSL'
		If FindFunction('WFPREPENV')
			// Conout("Preparando Environment")
			WfPrepENV(aParam[1], aParam[2])
		Else
			Prepare Environment Empresa aParam[1]Filial aParam[2] Tables "SFI"
		EndIf
	EndIf
	// Conout("Iniciando LSVIMPSE")
	// Conout(Replicate("_",50))
	
	Integra()
	
	// Conout("Finalizando LSVIMPSE")
	// Conout(Replicate("_",50))
	If FunName() <> 'LSVIMPSL'
		Reset Environment
	EndIf
	
	//==========================================//
	// Cancela o Lock de gravacao da rotina     //
	//==========================================//
	
	FClose(nHdlLock)
	FErase(cArqLock)
	
Else
	AtuDados()
EndIf

Return

Static Function AtuDados()

Local cCadastro    	:= "Importa Movimentacao Bancaria"
Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0
Local oDlg
Private oProcess

AADD(aSays,OemToAnsi("Esta rotina realiza a importacao dos registros de movimentacao"))
AADD(aSays,OemToAnsi("bancaria do Socim para a tabela SE5 do Protheus."))

AADD(aButtons, { 1,.T.,{|o| nOpc:= 1,If(MsgYesNo(OemToAnsi("Confirma processamento?"),OemToAnsi("Atenção")),o:oWnd:End(),nOpc:=0) } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons,,200,405 )

If nOpc == 1
	oProcess := MsNewProcess():New({|lEnd| Integra(@lEnd)},"Processando","Transferindo...",.T.)
	oProcess:Activate()
EndIf

Return

Static Function Integra()

Local aArea		   	 := GetArea()
Local _aCpoErr 		 := {}
Local nNum     		 := Space(6)
Local lGrava		 := .T.
Local cHoraI		 := Time()
Local cHoraF

cQuery1 := " SELECT * "
cQuery1 += " FROM "+RetSqlName("PA5") +" PA5 (NOLOCK) "
cQuery1 += " WHERE "
cQuery1 += " PA5_STATUS = '' AND "
cQuery1 += " PA5.D_E_L_E_T_ = '' "
cQuery1 += " ORDER BY PA5_FILIAL, PA5_DATA, PA5_NUMERO "

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery1), "TMP", .F., .T.)

//Inicio da integracao
DbSelectArea("SE5")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabela de orçamento PA1 -> SL1      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("TMP")
TMP->(DbGoTop())
If TMP->(!Eof())
	
	If _lJob
		oProcess:SetRegua1(TMP->(RecCount()) )
	EndIf
	
	While !TMP->(Eof())
		
		If _lJob
			oProcess:IncRegua1("PA5 -> SE5  : "+ TMP->PA5_FILIAL +" "+TMP->PA5_NUMERO)
		Else
			// Conout("PA5 -> SE5 "+TMP->PA5_FILIAL +" "+TMP->PA5_NUMERO)
		EndIf
		
		Begin Transaction
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tabela de resumo PAI -> SFI          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		SE5->(DbSetOrder(4))
		
		lGrava := !SE5->(DbSeek(TMP->PA5_FILIAL+;
		Iif(TMP->PA5_RECPAG=="P","SANGRIA","TROCO")+; //Natureza
		" "+; //Prefixo
		TMP->PA5_NUMERO+;
		" "+; //Parcela
		" "+; //Tipo
		TMP->PA5_DTDIGI+;
		TMP->PA5_RECPAG))
		
		RecLock("SE5",lGrava)
		
		SE5->E5_FILIAL 	    := TMP->PA5_FILIAL
		SE5->E5_NUMERO      := TMP->PA5_NUMERO
		SE5->E5_PARCELA	    :=	" "
		SE5->E5_DATA 		:= STOD(TMP->PA5_DATA)
		SE5->E5_DTDIGIT 	:= STOD(TMP->PA5_DATA)
		SE5->E5_DTDISPO 	:= STOD(TMP->PA5_DATA)
		SE5->E5_RECPAG   	:= TMP->PA5_RECPAG
		SE5->E5_MOEDA 		:= TMP->PA5_MOEDA
		SE5->E5_TIPO 		:= " "
		SE5->E5_VALOR 		:= TMP->PA5_VALOR
		SE5->E5_SITUA 		:= TMP->PA5_SITUA
		SE5->E5_PREFIXO 	:= "" //NAO PREENCHER POR ENQUANTO "If(_lAppend,_cSerie,_cSerieAnt)"})
		//SE5->E5_BANCO 		:= PA9->PA9_CODCXA
		//SE5->E5_AGENCIA 	:= SA6->A6_AGENCIA
		//SE5->E5_CONTA 		:= SA6->A6_NUMCON
		//SE5->E5_HISTOR   	:= Iif(SE5->E5_RECPAG=="P","SANGRIA DO CAIXA "+AllTrim(SA6->A6_COD),"ENTRADA DE TROCO NO CAIXA"+AllTrim(SA6->A6_COD))
		SE5->E5_TIPODOC 	:= "TR"
		SE5->E5_BENEF 		:= "LASELVA"
		SE5->E5_CLIFOR		:= "      "
		SE5->E5_LOJA		:= "  "
		SE5->E5_SEQ			:= "  "
		SE5->E5_NATUREZ 	:= Iif(SE5->E5_RECPAG=="P","SANGRIA","TROCO")
		
		SE5->(MsUnlock())
		
		If _lJob
			oProcess:IncRegua2("PA5 : "+ Str(TMP->(RecNo())))
			ProcessMessage()
		EndIf
		
		DbSelectArea("PA5")
		PA5->(DbSetOrder(1))
		
		//lGrava := !PA5->(DbSeek(TMP->PA5_FILIAL+TMP->PA5_DATA+TMP->PA5_OPERAD+TMP->PA5_PDV+Iif(TMP->PA5_RECPAG=="P","SANGRIA","TROCO")+TMP->PA5_NUMERO))
		lGrava := !PA5->(DbSeek(TMP->PA5_FILIAL+TMP->PA5_DATA+TMP->PA5_OPERAD+TMP->PA5_PDV+TMP->PA5_RECPAG+TMP->PA5_NUMERO))
		
		RecLock("PA5",lGrava)
		PA5->PA5_STATUS := "TX"
		MsUnLock()
		
		End Transaction
		
		If _lJob
			ProcessMessage()
			
			If lEnd
				MsgInfo(cCancela,"Processo cancelado")
				Exit
			EndIf
		EndIf
		
		If _lJob
			oProcess:IncRegua2("PA5 -> SE5  : "+ Str(TMP->(RecNo())))
		EndIf
		
		TMP->(DbSkip())
		
	EndDo
	
	
	cHoraF := Time()
	If _lJob
		Aviso("Importacao","Importacao realizada com sucesso!, Inicio: "+cHoraI+" Fim: "+cHoraF ,{"Ok"})
	Else
		// Conout("LSVIMPSF - Importacao realizada com sucesso!")
	EndIf
Else
	If _lJob
		Aviso("Importacao","Nao ha registros para importacao!",{"Ok"})
	Else
		// Conout("LSVIMPSF - Nao ha registros para importacao!")
	EndIf
	
EndIf

DbSelectArea("TMP")
DbCloseArea("TMP")

RestArea(aArea)

Return
