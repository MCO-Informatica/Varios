#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MA020BUT  ³ Autor ³  Daniel   Gondran     ³ Data ³19/11/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Adicionar botao no cad. fornecedores para controle          ³±±
±±³          ³Fornecedor x Produto controlado                             ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MA020BUT()
	Local aBotoes := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MA020BUT" , __cUserID )

	aadd(aBotoes,{'BMPCPO'  ,{|| U_FPC(3)},"Prod.Control"})
	aadd(aBotoes,{'BMPCPO'  ,{|| U_SFLOGSHW()},"Log Integ. SF"})
	aadd(aBotoes,{'BMPCPO'  ,{|| U_LOGAUDSHW()},"Log Auditoria"})
Return(aBotoes)


User Function FPC(nOpcX)

	Local aArea     := GetArea()
	Local aPosObj   := {}
	Local aObjects  := {}
	Local aSize     := MsAdvSize()
	Local nOpcA     := 0
	Local oDlg                                                                               
	Local oGetDad
	Local nX := 0 

	Private aHeadFor := {}
	Private aColsFor := {}

	U_Monta2(@aHeadFor,@aColsFor)                         

	N := 1
	aHeader := aClone(aHeadFor)
	aCols   := aClone(aColsFor)

	AAdd( aObjects, { 100, 100, .t., .t. } )

	aSize[ 3 ] -= 250
	aSize[ 4 ] -= 250 	

	aSize[ 5 ] -= 400
	aSize[ 6 ] -= 400

	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
	aPosObj := MsObjSize( aInfo, aObjects )

	dbSelectArea("ZX6")
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Amarracao Fornecedor x Prod. Controlados") From 30,89 TO 600,600 Of oMainWnd PIXEL
	oGetDad := MsGetDados():New(31,5,275,120,nOpcX,"AllwaysTrue","AllwaysTrue",,.T.,,,,99)
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA := 1,If(oGetDad:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()}) CENTERED
	If nOpcA == 1
		aHeadFor := aClone(aHeader)
		aColsFor   := aClone(aCols)
	EndIf     
	// Grava informacao na tabela
	dbSelectArea("ZX6")
	dbSetOrder(1)
	For nX := 1 to Len (aCols)
		dbSeek(xFilial("ZX6") + SA2->A2_COD + SA2->A2_LOJA + aCols[nX,1])
		If Found() .and. aCols[nX,2] // Deleta produto
			RecLock("ZX6",.F.)
			dbDelete()
			msUnlock()
		Endif

		If !Found() .and. !aCols[nX,2]
			RecLock("ZX6",.T.)
			ZX6->ZX6_FILIAL	:= xFilial("ZX6")
			ZX6->ZX6_FOR	:= SA2->A2_COD
			ZX6->ZX6_LOJA	:= SA2->A2_LOJA
			ZX6->ZX6_PROD	:= aCols[nX,1]
			msUnlock()
		Endif
	Next

	RestArea(aArea)
Return(.T.)




User Function Monta2(aHeadFor,aColsFor,aRegSCV)

	Local cArqQry    := "ZX6"
	Local lQuery     := .F.
	Local nUsado     := 0
	Local nX         := 0
	Local nDic       := 0
	Local aSX3       := {}
	Local cAlias     := "ZX6"

	#IFDEF TOP
	Local aStruSCV   := {}
	Local cQuery     := ""
	#ENDIF 	

	DEFAULT aRegSCV  := {}
	DEFAULT aHeadFor := {}
	DEFAULT aColsFor := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeadFor                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//dbSelectArea("SX3")
	//dbSetOrder(1)
	//dbSeek("ZX6")

	aSX3 := FWSX3Util():GetAllFields( cAlias , .F. )

	for nDic := 1 to len(aSX3)

		If X3Uso(GetSx3Cache(aSx3[nDic],"X3_USADO")) .And. cNivel >= GetSx3Cache(aSx3[nDic],"X3_NIVEL") .AND. "PROD" $ GetSx3Cache(aSx3[nDic],"X3_CAMPO") 
			nUsado++
			Aadd(aHeadFor, { AllTrim(X3Titulo()),;
			GetSx3Cache(aSx3[nDic],"X3_CAMPO"),;
			GetSx3Cache(aSx3[nDic],"X3_PICTURE"),;
			GetSx3Cache(aSx3[nDic],"X3_TAMANHO"),;
			GetSx3Cache(aSx3[nDic],"X3_DECIMAL"),;
			GetSx3Cache(aSx3[nDic],"X3_VALID"),;
			GetSx3Cache(aSx3[nDic],"X3_USADO"),;
			GetSx3Cache(aSx3[nDic],"X3_TIPO"),;
			GetSx3Cache(aSx3[nDic],"X3_ARQUIVO"),;
			GetSx3Cache(aSx3[nDic],"X3_CONTEXT" )})
		EndIf
	next nDic
	If  !INCLUI
		SCV->(DbSetOrder(1))
		#IFDEF TOP
		If TcSrvType()<>"AS/400" .And. !InTransact()
			lQuery  := .T.
			cArqQry := "ZX6"
			aStruSCV:= ZX6->(dbStruct())

			cQuery := "SELECT ZX6.*,ZX6.R_E_C_N_O_ SCVRECNO "
			cQuery += "FROM "+RetSqlName("ZX6")+" ZX6 "
			cQuery += "WHERE "
			cQuery += "ZX6.ZX6_FILIAL='"+xFilial("ZX6")+"' AND "
			cQuery += "ZX6.ZX6_FOR='"+SA2->A2_COD+"' AND "
			cQuery += "ZX6.ZX6_LOJA='"+SA2->A2_LOJA+"' AND "
			cQuery += "ZX6.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(ZX6->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbSelectArea("ZX6")
			dbCloseArea()
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)

			For nX := 1 To Len(aStruSCV)
				If	aStruSCV[nX,2] <> "C"
					TcSetField(cArqQry,aStruSCV[nX,1],aStruSCV[nX,2],aStruSCV[nX,3],aStruSCV[nX,4])
				EndIf
			Next nX
		Else
			#ENDIF
			ZX6->(DbSeek(xFilial("ZX6")+SA2->A2_COD))
			#IFDEF TOP
		EndIf
		#ENDIF
		While (cArqQry)->(!Eof() .And. (cArqQry)->ZX6_FILIAL==xFilial("ZX6") .And.;
		(cArqQry)->ZX6_FOR==SA2->A2_COD .AND. (cArqQry)->ZX6_LOJA == SA2->A2_LOJA)
			aadd(aColsFor,Array(nUsado+1))	
			For nX := 1 To nUsado
				If ( aHeadFor[nX][10] <> "V" )
					aColsFor[Len(aColsFor)][nX] := (cArqQry)->(FieldGet(FieldPos(aHeadFor[nX][2])))
				Else
					aColsFor[Len(aColsFor)][nX] := CriaVar(aHeadFor[nX,2])
				EndIf
			Next
			aColsFor[Len(aColsFor)][nUsado+1] := .F.

			aadd(aRegSCV,If(lQuery,(cArqQry)->SCVRECNO,(cArqQry)->(RecNo())))

			dbSelectArea(cArqQry)
			dbSkip()
		EndDo
		If lQuery
			dbSelectArea(cArqQry)
			dbCloseArea()
			ChkFile("ZX6",.F.)
			dbSelectArea("ZX6")
		EndIf
	Endif

	If Empty(aColsFor)
		aadd(aColsFor,Array(nUsado+1))

		For nX := 1 To nUsado
			aColsFor[1][nX] := CriaVar(aHeadFor[nX][2])
		Next nX
		aColsFor[Len(aColsFor)][nUsado+1] := .F.
	Endif

Return(.T.)
