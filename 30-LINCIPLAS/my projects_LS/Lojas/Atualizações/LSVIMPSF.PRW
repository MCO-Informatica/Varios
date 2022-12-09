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
User Function LSVIMPSF(aParam)

Local nHdlLock	:= 0
Local cArqLock 	:= "LSVIMPSF.lck"
Private _lJob	:= (aParam <> Nil .Or. ValType(aParam) == "A") // .t.
aparam   		:= {"01","01"}

If _lJob
	
	/*
	If File(cArqLock)
	Return()
	EndIf
	
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
	// Conout("Iniciando LSVIMPSF")
	// Conout(Replicate("_",50))
	
	Integra(cArqLock)
	
	// Conout("Finalizando LSVIMPSF")
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
	AtuDados(cArqLock)
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////
// ********************************************************************************** //
////////////////////////////////////////////////////////////////////////////////////////
Static Function AtuDados(cArqLock)

Local cCadastro    	:= "Importa Reducao Z - E-Connect x Protheus"
Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0
Local oDlg
Private oProcess

AADD(aSays,OemToAnsi("Esta rotina realiza a importacao da reducao Z gerada nos pdvs"))
AADD(aSays,OemToAnsi("do sistema legado Socim para a tabela SFI do Protheus."))

AADD(aButtons, { 1,.T.,{|o| nOpc:= 1,If(MsgYesNo(OemToAnsi("Confirma processamento?"),OemToAnsi("Atenção")),o:oWnd:End(),nOpc:=0) } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons,,200,405 )

If nOpc == 1
	Processa( {|lEnd| Integra(@lEnd)}, "Aguarde...","Executando rotina.", .T. )
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////
// ********************************************************************************** //
////////////////////////////////////////////////////////////////////////////////////////
Static Function Integra(cArqLock)

Local aArea		:= GetArea()
Local nTotRec	:= 0
Local _nReg		:= 0
Local _aCpoErr	:= {}
Local nNum		:= Space(6)
Local lGrava	:= .T.
Local cHoraI	:= Time()
Local cHoraF
/*
cQuery1 := " SELECT * "
cQuery1 += " FROM "+RetSqlName("PAI") +" PAI (NOLOCK)"
cQuery1 += " WHERE "
cQuery1 += " PAI_STATUS 	= '' AND "
cQuery1 += " PAI.D_E_L_E_T_ = '' "
cQuery1 += " ORDER BY PAI_FILIAL, PAI_DTMOVT "
*/

cQuery1 := " SELECT *
cQuery1 += " FROM "+RetSqlName("PAI") +" A (NOLOCK) "
cQuery1 += " LEFT JOIN "+RetSqlName("SFI") +" B WITH(NOLOCK) ON PAI_FILIAL 		= FI_FILIAL "
cQuery1 += " 												AND PAI_DTMOVT 		= FI_DTMOVTO "
cQuery1 += " 												AND PAI_PDV 		= FI_PDV "
cQuery1 += " 												AND PAI_NUMRED 		= FI_NUMREDZ "
cQuery1 += " 												AND B.D_E_L_E_T_	= '' "
cQuery1 += " WHERE FI_FILIAL 	IS NULL "
cQuery1 += " AND A.D_E_L_E_T_	= '' "

TcQuery cQuery1 NEW ALIAS "TMP"

Count To nTotRec
ProcRegua(nTotRec)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabela de orçamento PA1 -> SL1      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("TMP")
TMP->( DbGoTop() )
If TMP->( !Eof() )
	
	While TMP->( !Eof() )
		
		If _lJob
			// Conout("PAI -> SFI "+TMP->PAI_FILIAL +" "+TMP->PAI_NUMRED)
		Else
			IncProc("Processando...")
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tabela de resumo PAI -> SFI          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		Begin Transaction
		
		DbSelectArea("SFI")
		SFI->( DbSetOrder(1) )
		
		//If !SFI->( DbSeek( TMP->PAI_FILIAL+TMP->PAI_DTMOVT+StrZero(Val(TMP->PAI_PDV),10 ) ) )
		
		lGrava := !SFI->( DbSeek( TMP->PAI_FILIAL+TMP->PAI_DTMOVT+StrZero(Val(TMP->PAI_PDV),10 ) ) )
		
		RecLock("SFI",lGrava)
		
		SFI->FI_FILIAL 	:=  	 TMP->PAI_FILIAL
		SFI->FI_DTMOVTO	:=  	 STOD(TMP->PAI_DTMOVT)
		SFI->FI_PDV		:=  	 StrZero(Val(TMP->PAI_PDV),10)
		SFI->FI_VALCON	:=  	 TMP->PAI_VALCON
		SFI->FI_CANCEL 	:=  	 TMP->PAI_CANCEL
		SFI->FI_DESC 	:=  	 TMP->PAI_DESC
		SFI->FI_SUBTRIB	:=  	 TMP->PAI_SUBTRI
		SFI->FI_ISENTO	:=  	 TMP->PAI_ISENTO
		SFI->FI_NTRIB 	:=  	 TMP->PAI_NTRIB
		SFI->FI_NUMFIM 	:=  	 TMP->PAI_NUMFIM
		SFI->FI_NUMINI 	:=  	 TMP->PAI_NUMINI
		SFI->FI_NUMREDZ	:=  	 TMP->PAI_NUMRED
		SFI->FI_NUMERO	:=  	 TMP->PAI_NUMRED
		SFI->FI_GTINI 	:=  	 TMP->PAI_GTINI
		SFI->FI_GTFINAL	:=  	 TMP->PAI_GTFINA
		SFI->FI_BAS2 	:=  	 TMP->PAI_BAS2
		SFI->FI_BAS7 	:=  	 TMP->PAI_BAS7
		SFI->FI_BAS8 	:=  	 TMP->PAI_BAS8
		SFI->FI_BAS12 	:=  	 TMP->PAI_BAS12
		SFI->FI_BAS13 	:=  	 TMP->PAI_BAS13
		SFI->FI_BAS17 	:=  	 TMP->PAI_BAS17
		SFI->FI_BAS18 	:=  	 TMP->PAI_BAS18
		SFI->FI_BAS19 	:=  	 TMP->PAI_BAS19
		SFI->FI_BAS20 	:=  	 TMP->PAI_BAS20
		SFI->FI_BAS25 	:=  	 TMP->PAI_BAS25
		SFI->FI_BAS26 	:=  	 TMP->PAI_BAS26
		SFI->FI_BAS27 	:=  	 TMP->PAI_BAS27
		//SFI->FI_BAS29 	:=  	 TMP->PAI_BAS29
		SFI->FI_BAS30 	:=  	 TMP->PAI_BAS30
		SFI->FI_BAS37 	:=  	 TMP->PAI_BAS37
		SFI->FI_BAS38 	:=  	 TMP->PAI_BAS38
		SFI->FI_BAS320 	:=  	 TMP->PAI_BAS320
		SFI->FI_BAS420 	:=  	 TMP->PAI_BAS420
		
		//SFI->FI_COD7 	:=  	 TMP->PAI_COD7
		//SFI->FI_COD12	:=  	 TMP->PAI_COD12
		//SFI->FI_COD18	:=  	 TMP->PAI_COD18
		//SFI->FI_COD29	:=  	 TMP->PAI_COD29
		
		SFI->FI_ISS 	:=  	 TMP->PAI_ISS
		SFI->FI_IMPDEBT	:=  	 TMP->PAI_IMPDEB
		SFI->FI_OUTROSR	:=  	 TMP->PAI_OUTROS
		SFI->FI_COO 	:=  	 TMP->PAI_COO
		SFI->FI_CRO		:=  	 TMP->PAI_CRO
		SFI->FI_SERPDV  := 		 TMP->PAI_SERPDV
		SFI->FI_SITUA	:=  	 "00"
		
		SFI->( MsUnlock() )
		
		DbSelectArea("PAI")
		PAI->( DbSetOrder(1) )
		If PAI->( DbSeek(TMP->PAI_FILIAL+TMP->PAI_DTMOVT+StrZero(Val(TMP->PAI_PDV),10)) )
			RecLock("PAI",.F.)
			PAI->PAI_STATUS := "TX"
			PAI->( MsUnLock() )
			
			_nReg++
		EndIf
		
		//EndIf
		
		End Transaction
		
		If !_lJob
			If lEnd
				MsgInfo(cCancela,"Processo cancelado")
				Exit
			EndIf
		EndIf
		
		TMP->( DbSkip() )
		
	EndDo
	
	If _lJob
		If _nReg > 0
			// Conout("LSVIMPSF - Importacao realizada com sucesso!")
		Else
			// Conout("LSVIMPSF - Nao existem registros para processamento!")
		EndIf
	Else
		If _nReg > 0
			MsgInfo("Importacao realizada com sucesso!")
		Else
			MsgStop("Nao existem registros para processamento!")
		EndIf
	EndIf
Else
	If _lJob
		// Conout("LSVIMPSF - Nao ha registros para importacao!")
	Else
		Aviso("Importacao","Nao ha registros para importacao!",{"Ok"})
	EndIf
	
EndIf

DbSelectArea("TMP")
DbCloseArea("TMP")

RestArea(aArea)

Return


//////////////////////////////////////////////////////////////////
// EXECUTA A FUNÇÃO VIA JOB                                     //
//////////////////////////////////////////////////////////////////
User Function LSJSF()

U_LSVIMPSF({"01","01"})

RETURN
