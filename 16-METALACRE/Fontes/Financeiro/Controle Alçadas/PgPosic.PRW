#include "rwmake.ch"
#include 'protheus.ch'
#include "Topconn.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} SACOMC01
Específico SAVIS:	Rotina responsável pela Consulta de Aprovações por Solicitação
@param			    
@return				
@author SI:407296 - EWERTON FERNANDES BRASILIANO
@since 	24/11/2016
@version 	1.0
@project	MAN0000001 - Savis
/*/
//-----------------------------------------------------------------------
user function PgPosic(cAlias,nReg,nOpcx,cTipoDoc,lStatus,lResid)

Local aArea		:= GetArea()
Local aSavCols  := {}
Local aSavHead  := {}
Local cHelpApv  := OemToAnsi("Este documento nao possui controle de aprovacao.") // 
Local cAliasSCR := "TMP"
Local cComprador:= ""
Local cSituaca  := ""
Local cNumDoc   := ""
Local cStatus   := ""
Local cTitle    := ""
Local cTitDoc   := ""
Local cAddHeader:= ""
Local cAprovador:= ""

Local lBloq     := .F.
Local lQuery    := .F.

Local nSavN		:= 0
Local nX   		:= 0
Local nY        := 0

Local oDlg
Local oGet
Local oBold        
Local lExAprov	:= SuperGetMV("MV_EXAPROV",.F.,.F.)
Local lAprPCEC	:= SuperGetMV("MV_APRPCEC",.F.,.F.)
Local lAprSAEC	:= SuperGetMV("MV_APRSAEC",.F.,.F.)
Local lAprSCEC	:= SuperGetMV("MV_APRSCEC",.F.,.F.)
Local lAprCTEC	:= SuperGetMV("MV_APRCTEC",.F.,0) <> 0
Local lAprMDEC	:= SuperGetMV("MV_APRMDEC",.F.,0) <> 0
Local cChave	:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)	// Chave Busca
Local nTamanho  := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + TamSX3("E2_TIPO")[1] + TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1]

Local cQuery   := ""
Local aStruSCR := {}


DEFAULT cTipoDoc := "PG"
DEFAULT lStatus  := .F.
DEFAULT lResid   := .F.
DEFAULT nOpcx    := 2                     
DEFAULT cAlias   := 'SE2'
DEFAULT nReg     := SE2->(Recno())

If lStatus
	aSavCols  := aClone(aCols)
	aSavHead  := aClone(aHeader)
	nSavN     := N
Else
	Private aCols   := {}
	Private aHeader := {}
	Private N       := 1
EndIf

dbSelectArea(cAlias)
MsGoto(nReg)

IF cTipoDoc == "PG"
    cTitle    := "Aprovacao Contas a Pagar" 
    cTitDoc   := "Pagar"  
    cHelpApv  := "Este titulo nao possui controle de aprovacao."  
	cNumDoc   := SE2->E2_NUM
	cComprador:= ''//UsrRetName(SC1->C1_USER)
	cStatus   := IIF(SE2->E2_XCONAP=="L",OemToAnsi("TITULO LIBERADO"),OemToAnsi("AGUARDANDO LIB.")) //#
EndIf

If !Empty(cNumDoc) 

	aHeader:= {}
	aCols  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem do aHeader com os campos fixos.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SCR")
	If lAprPCEC .Or. lAprSAEC .Or. lAprSCEC .Or. lAprCTEC .Or. lAprMDEC
		AADD(aHeader,{ "Item ","bCR_ITEM","",15,0,"","","C","",""} )
	Endif
	While !Eof() .And. (SX3->X3_ARQUIVO == "SCR")
		IF AllTrim(X3_CAMPO)$"CR_NIVEL/CR_OBS/CR_DATALIB/" + cAddHeader
			AADD(aHeader,{	TRIM(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )

			If AllTrim(x3_campo) == "CR_NIVEL"
				AADD(aHeader,{ OemToAnsi("Usuario"),"bCR_NOME",   "",15,0,"","","C","",""} ) // Usuario
				AADD(aHeader,{ OemToAnsi("Situacao"),"bCR_SITUACA","",20,0,"","","C","",""} ) //"Situacao"
				AADD(aHeader,{ OemToAnsi("Usuario Lib."),"bCR_NOMELIB","",15,0,"","","C","",""} ) //"Usuario Lib."
			EndIf

		Endif

		dbSelectArea("SX3")		
		dbSkip()
	EndDo

	ADHeadRec("SCR",aHeader)

	
	lQuery     := .T.

	IF cTipoDoc == "PG"
		aStruSCR := SCR->(dbStruct())
		cAliasSCR := GetNextAlias()
		cQuery    := "SELECT SCR.*,SCR.R_E_C_N_O_ SCRRECNO "
		cQuery	   += "FROM "+RetSqlName("SCR")+" SCR "
		cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
		cQuery    += "SCR.CR_NUM = '"+Padr(cChave,Len(SCR->CR_NUM))+"' AND "
		cQuery    += "SCR.CR_TIPO = 'PG' "
		If !lExAprov .Or. !Empty(SC1->C1_RESIDUO)
			cQuery    += "AND SCR.D_E_L_E_T_=' ' "
		EndIf	
	EndIf
	
	cQuery    += "ORDER BY "+SqlOrder(SCR->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)

	For nX := 1 To Len(aStruSCR)
		If aStruSCR[nX][2]<>"C"
			TcSetField(cAliasSCR,aStruSCR[nX][1],aStruSCR[nX][2],aStruSCR[nX][3],aStruSCR[nX][4])
		EndIf
	Next nX


	dbSelectArea(cAliasSCR)

	If cTipoDoc == "PG"
		nTamDoc := Len(SE2->E2_NUM)
	EndIf
	
	While !Eof() 
		aAdd(aCols,Array(Len(aHeader)+1))
		nY++
		For nX := 1 to Len(aHeader)
			If IsHeadRec(aHeader[nX][2])
				aCols[nY][nX] := (cAliasSCR)->SCRRECNO
			ElseIf IsHeadAlias(aHeader[nX][2])
				aCols[nY][nX] := "SCR"
			ElseIf aHeader[nX][02] == "bCR_NOME"
				aCols[nY][nX] := UsrRetName((cAliasSCR)->CR_USER)
			ElseIf aHeader[nX][02] == "bCR_ITEM"
				If lAprPCEC .Or. lAprSAEC .Or. lAprSCEC .Or. lAprCTEC .Or. lAprMDEC
					aCols[nY][nX] := Replicate("-",8)
				Endif	
			ElseIf aHeader[nX][02] == "bCR_SITUACA"
				Do Case
					Case (cAliasSCR)->CR_STATUS == "01"
						cSituaca := OemToAnsi("Nivel Bloqueado") //"Nivel Bloqueado"
					Case (cAliasSCR)->CR_STATUS == "02"
						cSituaca := OemToAnsi("Aguardando Liberacao") //"Aguardando Liberacao"
					Case (cAliasSCR)->CR_STATUS == "03"
						cSituaca := OemToAnsi("Aprovado") //"Solicitação Aprovada"
					Case (cAliasSCR)->CR_STATUS == "04"
						cSituaca :=OemToAnsi("Bloqueado") //"Solicitação Bloqueada"
						lBloq := .T.
					Case (cAliasSCR)->CR_STATUS == "05"
						cSituaca := OemToAnsi("Nivel Liberado") // "Nivel Liberado"
				EndCase
				aCols[nY][nX] := cSituaca
			ElseIf aHeader[nX][02] == "bCR_NOMELIB"
				aCols[nY][nX] := UsrRetName((cAliasSCR)->CR_USERLIB)
			ElseIf Alltrim(aHeader[nX][02]) == "CR_OBS"//Posicionar para ler
				SCR->(dbGoto((cAliasSCR)->SCRRECNO))
				aCols[nY][nX] := SCR->CR_OBS
			ElseIf ( aHeader[nX][10] != "V")
				aCols[nY][nX] := FieldGet(FieldPos(aHeader[nX][2]))
			EndIf
		Next nX
		aCols[nY][Len(aHeader)+1] := .F.
		dbSkip()
	EndDo

	If !Empty(aCols)
		If lBloq
			If cTipoDoc == "PG"
				cStatus:= OemToAnsi("Titulo Bloqueado")
			EndIf	
		EndIf
		n:=	 IIF(n > Len(aCols), Len(aCols), n)  // Feito isto p/evitar erro fatal(Array out of Bounds).
		DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
		DEFINE MSDIALOG oDlg TITLE cTitle From 109,095 To 400,600 OF oMainWnd PIXEL	 //"Aprovacao do Pedido de Compra // Contrato"
		@ 005,003 TO 032,250 LABEL "" OF oDlg PIXEL
		If !(cTipoDoc $ "MD|RV|CT|IC|IM")
			@ 015,007 SAY cTitDoc OF oDlg FONT oBold PIXEL SIZE 046,009 // "Pedido" / "Contrato" / "Nota Fiscal" 
			@ 014,041 MSGET cNumDoc PICTURE "" WHEN .F. PIXEL SIZE 150,009 OF oDlg FONT oBold
	        If cTipoDoc <> "NF"
				@ 015,095 SAY OemToAnsi("Comprador") OF oDlg PIXEL SIZE 045,009 FONT oBold //"Comprador"
				@ 014,138 MSGET cComprador PICTURE "" WHEN .F. of oDlg PIXEL SIZE 103,009 FONT oBold
	        EndIF   
	   	Else
			@ 015,007 SAY cTitDoc OF oDlg FONT oBold PIXEL SIZE 046,009 // "Medicao" 
			@ 014,035 MSGET cNumDoc PICTURE "" WHEN .F. PIXEL SIZE 50,009 OF oDlg FONT oBold

			@ 015,095 SAY cAprovador OF oDlg PIXEL SIZE 045,009 FONT oBold //"Aprovador"
			@ 014,138 MSGET cComprador PICTURE "" WHEN .F. of oDlg PIXEL SIZE 103,009 FONT oBold  	
	   	EndIf          
	   	
		@ 132,008 SAY 'Situacao :' OF oDlg PIXEL SIZE 052,009 //
		@ 132,038 SAY cStatus OF oDlg PIXEL SIZE 120,009 FONT oBold
		@ 132,205 BUTTON 'Fechar' SIZE 035 ,010  FONT oDlg:oFont ACTION (oDlg:End()) OF oDlg PIXEL  //'Fechar'
		oGet:= MSGetDados():New(038,003,120,250,nOpcx,,,"")
		oGet:Refresh()
		@ 126,002 TO 127,250 LABEL "" OF oDlg PIXEL	
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		Aviso("Atencao",cHelpApv,{"Voltar"}) //######
	EndIf

	dbSelectArea(cAliasSCR)
	dbCloseArea()

	If lStatus
		aHeader:= aClone(aSavHead)
		aCols  := aClone(aSavCols)
		N		:= nSavN
	EndIf
Else
	Aviso("Atencao",cHelpApv,{"Voltar"}) //######
EndIf

dbSelectArea(cAlias)
RestArea(aArea)

Return NIL

//--< fim de arquivo >----------------------------------------------------------------------
