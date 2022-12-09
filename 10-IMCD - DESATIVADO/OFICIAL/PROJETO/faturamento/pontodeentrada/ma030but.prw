#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MA030BUT  ³ Autor ³  Daniel   Gondran     ³ Data ³19/11/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Adicionar botao no cad. cliente para controle               ³±±
±±³          ³Cliente x Produto controlado                                ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MA030BUT()
	Local aBotoes := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MA030BUT" , __cUserID )

	aadd(aBotoes,{'BMPCPO'  ,{|| U_CPC(3)},"Prod.Control"})
	aadd(aBotoes,{'BMPCPO'  ,{|| U_SFLOGSHW()},"Log Integ. SF"})
	aadd(aBotoes,{'BMPCPO'  ,{|| U_LOGAUDSHW()},"Log Auditoria"})
Return(aBotoes)


User Function CPC(nOpcX)

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

	U_MontaHead(@aHeadFor,@aColsFor)                         

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

	dbSelectArea("ZX5")
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Amarracao Cliente x Prod. Controlados") From 30,89 TO 600,600 Of oMainWnd PIXEL
	oGetDad := MsGetDados():New(31,5,275,120,nOpcX,"AllwaysTrue","AllwaysTrue",,.T.,,,,99)
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA := 1,If(oGetDad:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()}) CENTERED
	If nOpcA == 1
		aHeadFor := aClone(aHeader)
		aColsFor   := aClone(aCols)
	EndIf     
	// Grava informacao na tabela
	dbSelectArea("ZX5")
	dbSetOrder(1)
	
	For nX := 1 to Len (aCols)
		dbSeek(xFilial("ZX5") + SA1->A1_COD + SA1->A1_LOJA + aCols[nX,1])
		If Found() .and. aCols[nX,2] // Deleta produto
			RecLock("ZX5",.F.)
			dbDelete()
			msUnlock()
		Endif

		If !Found() .and. !aCols[Nx,2]
			RecLock("ZX5",.T.)
			ZX5->ZX5_FILIAL	:= xFilial("ZX5")
			ZX5->ZX5_CLI	:= SA1->A1_COD
			ZX5->ZX5_LOJA	:= SA1->A1_LOJA
			ZX5->ZX5_PROD	:= aCols[nX,1]
			msUnlock()
		Endif
	Next

	RestArea(aArea)
Return(.T.)




User Function MontaHead(aHeadFor,aColsFor,aRegSCV)

	Local cArqQry    := "ZX5"
	Local lQuery     := .F.
	Local nUsado     := 0
	Local nX         := 0
	Local nDic       := 0
	Local aSX3       := {}
	Local cAlias     := "ZX5"

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
	//dbSeek("ZX5")

	aSX3 := FWSX3Util():GetAllFields( cAlias , .F. )
	for nDic := 1 to len(aSx3)
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
			GetSx3Cache(aSx3[nDic],"X3_CONTEXT") } )
		EndIf
	next nDic
	If  !INCLUI
		SCV->(DbSetOrder(1))
		#IFDEF TOP
		If TcSrvType()<>"AS/400" .And. !InTransact()
			lQuery  := .T.
			cArqQry := "ZX5"
			aStruSCV:= ZX5->(dbStruct())

			cQuery := "SELECT ZX5.*,ZX5.R_E_C_N_O_ SCVRECNO "
			cQuery += "FROM "+RetSqlName("ZX5")+" ZX5 "
			cQuery += "WHERE "
			cQuery += "ZX5.ZX5_FILIAL='"+xFilial("ZX5")+"' AND "
			cQuery += "ZX5.ZX5_CLI='"+SA1->A1_COD+"' AND "
			cQuery += "ZX5.ZX5_LOJA='"+SA1->A1_LOJA+"' AND "
			cQuery += "ZX5.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(ZX5->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbSelectArea("ZX5")
			dbCloseArea()
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)

			For nX := 1 To Len(aStruSCV)
				If	aStruSCV[nX,2] <> "C"
					TcSetField(cArqQry,aStruSCV[nX,1],aStruSCV[nX,2],aStruSCV[nX,3],aStruSCV[nX,4])
				EndIf
			Next nX
		Else
			#ENDIF
			ZX5->(DbSeek(xFilial("ZX5")+SA1->A1_COD))
			#IFDEF TOP
		EndIf
		#ENDIF
		While (cArqQry)->(!Eof() .And. (cArqQry)->ZX5_FILIAL==xFilial("ZX5") .And.;
		(cArqQry)->ZX5_CLI==SA1->A1_COD .AND. (cArqQry)->ZX5_LOJA == SA1->A1_LOJA)
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
			ChkFile("ZX5",.F.)
			dbSelectArea("ZX5")
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
