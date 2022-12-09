#Include "Protheus.ch"
#Include "TopConn.ch"





User Function CM010BUT()

	Local aButtons := {}

	If UPPER(Alltrim(UsrRetName(RetCodUsr())))$"KARLA/ADMIN/UPDUO01/UPDUO02/KARLA.BELTRAO" .OR. RETCODUSR() $ "000000/000061/0000060/000059/000017" .OR. UPPER(Alltrim(UsrRetName(RetCodUsr()))) == "KARLA.BELTRAO"
		// Botoes a adicionar
		aadd(aButtons,{'BUDGETY'   ,{|| U_LibPrdTb()},'Itens a Liberar' ,'Itens a Liberar'})
		aadd(aButtons,{ 'NOTE'     ,{|| U_BlqPrdTb()},'Bloquear Itens ' ,'Bloquear Itens ' } )
	EndIf

Return (aButtons )




User Function LibPrdTb()

	Local aArea := GetArea()
	Local cQry := ""
	Local i         := 0
	Local aStruct   := {}
	Local cArquivo  := ""
	Local oDlg
	Local aHeaTRB   := {}
	Local aCampos   := {}
	Local nOpc      := 0

	Private oMarPrd
	Private lInvPrd := .F.
	Private cMarPrd := GetMark()

	Private cAliasPrd := "TmpPrd"
	Private aTarefa := {}
	PRIVATE aHeadGrade	:= {}
	PRIVATE aColsGrade	:= {}

	Private ALTERA   := .F.
	Private INCLUI   := .T.
	Private lShowOpc := .T.

	Private aHeader  := {}
	Private aCols    := {}

	cQry := " SELECT * FROM "+RetSqlName("AIB")+" AIB "
	cQry += " JOIN "+RetSqlName("SB1")+" SB1 "
	cQry += " ON B1_COD = AIB_CODPRO "
	cQry += " AND B1_FILIAL = '"+xFilial("SB1")+"' "
	cQry += " AND SB1.D_E_L_E_T_<>'*' "
	cQry += " WHERE AIB.AIB_CODFOR = '"+AIA->AIA_CODFOR+"' "
	cQry += " AND AIB.AIB_LOJFOR = '"+AIA->AIA_LOJFOR+"' "
	cQry += " AND AIB.AIB_CODTAB = '"+AIA->AIA_CODTAB+"' "
	cQry += " AND AIB.AIB_XSTATS <> 'S' "
	cQry += " AND AIB.D_E_L_E_T_<>'*' "
	cQry += " ORDER BY B1_DESC "


	If (Select("QryPrd")<>0)
		QryPrd->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"QryPrd",.T.,.T.)

	//--------------------------+
	//Monta Arquivo de trabalho |
	//--------------------------+

	aStruct := {}
	aTam := {02, 00, "C"}            ; aAdd(aStruct,{"TR_OK"     ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_CODTAB")  	 ; aAdd(aStruct,{"TR_TAB" ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_ITEM")  	 ; aAdd(aStruct,{"TR_ITEM" ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_CODPRO")     ; aAdd(aStruct,{"TR_PRODUT"  ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("B1_DESC")        ; aAdd(aStruct,{"TR_DESC"  ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_PRCCOM") 	 ; aAdd(aStruct,{"TR_PRECO" ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_DATVIG")     ; aAdd(aStruct,{"TR_DATA" ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_CODFOR")     ; aAdd(aStruct,{"TR_CODFOR" ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_LOJFOR")     ; aAdd(aStruct,{"TR_LOJFOR" ,aTam[3],aTam[1],aTam[2]})


	cArquivo := CriaTrab(aStruct,.T.)

	If Select(cAliasPrd) != 0
		(cAliasPrd)->(dbCloseArea())
	End

	dbUseArea(.T.,"",cArquivo,cAliasPrd,.F.,.F.)

	IndRegua(cAliasPrd,cArquivo,"TR_TAB+TR_ITEM",,,"Criando Índice...")

	While QryPrd->(!Eof())


		RecLock(cAliasPrd,.T.)
		(cAliasPrd)->TR_OK     := ""
		(cAliasPrd)->TR_TAB    := QryPrd->AIB_CODTAB
		(cAliasPrd)->TR_ITEM   := QryPrd->AIB_ITEM
		(cAliasPrd)->TR_PRODUT := QryPrd->AIB_CODPRO
		(cAliasPrd)->TR_DESC   := QryPrd->B1_DESC
		(cAliasPrd)->TR_PRECO  := QryPrd->AIB_PRCCOM
		(cAliasPrd)->TR_DATA   := SToD(QryPrd->AIB_DATVIG)
		(cAliasPrd)->TR_CODFOR := QryPrd->AIB_CODFOR
		(cAliasPrd)->TR_LOJFOR := QryPrd->AIB_LOJFOR
		(cAliasPrd)->(MsUnLock())


		QryPrd->(DbSkip())
	EndDo

	(cAliasPrd)->(DbGotop())

	//---------------+
	//Monta aHeaTRB  |
	//---------------+

	aAdd(aCampos, {"AIB_CODTAB"	, "TR_TAB", .T.})
	aAdd(aCampos, {"AIB_ITEM"	, "TR_ITEM", .T.})
	aAdd(aCampos, {"AIB_CODPRO" , "TR_PRODUT", .T.})
	aAdd(aCampos, {"B1_DESC"    , "TR_DESC"  , .T.})
	aAdd(aCampos, {"AIB_PRCCOM" , "TR_PRECO" , .T.})
	aAdd(aCampos, {"AIB_DATVIG"	, "TR_DATA" , .T.})
	aAdd(aCampos, {"AIB_CODFOR"	, "TR_CODFOR" , .T.})
	aAdd(aCampos, {"AIB_LOJFOR"	, "TR_LOJFOR" , .T.})

	aAdd(aHeaTRB, {"TR_OK",,""})

	For i := 1 To Len(aCampos)
		SX3->(dbSetOrder(2)) //X3_CAMPO
		If SX3->(dbSeek(aCampos[i,1]))
			aAdd(aHeaTRB,{aCampos[i,2],,Trim(X3Titulo()),IIf(aCampos[i,3],SX3->X3_Picture,)})
		EndIf
	Next i

	//------------------------+
	//Monta tela com msselect |
	//------------------------+
	oMainWnd:ReadClientCoords()
	oDlg := MsDialog():New(100,100,600,1300,OemToAnsi("Itens a Liberar"),,,.F.,,,,,oMainWnd,.T.,,,.F.)

	oPnlClient := TPanel():New(1,1,,oDlg,,.T.,.F.,,,1,1,,)
	oPnlClient:Align := CONTROL_ALIGN_ALLCLIENT

	oMarPrd := MsSelect():New(cAliasPrd,"TR_OK","",aHeaTRB,lInvPrd,cMarPrd,{1,1,1,1},,,oPnlClient)
	oMarPrd:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oMarPrd:oBrowse:bAllMark := {|| fMarcCheck()}

	Activate MSDialog oDlg On Init EnchoiceBar(oDlg,{|| nOpc := 1,oDlg:End()},{|| nOpc := 0,oDlg:End()}) Centered

	If nOpc == 1

		//AIB->(dbSetOrder(2))
		(cAliasPrd)->(DbGotop())
		While (cAliasPrd)->(!Eof())
			If !Empty((cAliasPrd)->TR_OK)

				DbSelectArea("AIB")
				AIB->(DbSetOrder(1))
				AIB->(DbGoTop())

				If DbSeek(xFilial("AIB")+(cAliasPrd)->TR_CODFOR+(cAliasPrd)->TR_LOJFOR+(cAliasPrd)->TR_TAB+(cAliasPrd)->TR_ITEM)

					RecLock("AIB",.F.)

					AIB->AIB_XSTATS := 'S'

					AIB->(MsUnlock())

				EndIf

			EndIf

			(cAliasPrd)->(DbSkip())
		EndDo

	EndIf

	RestArea(aArea)

Return



User Function BlqPrdTb()

	Local aArea := GetArea()
	Local cQry := ""
	Local i         := 0
	Local aStruct   := {}
	Local cArquivo  := ""
	Local oDlg
	Local aHeaTRB   := {}
	Local aCampos   := {}
	Local nOpc      := 0

	Private oMarPrd
	Private lInvPrd := .F.
	Private cMarPrd := GetMark()

	Private cAliasPrd := "TmpPrd"
	Private aTarefa := {}
	PRIVATE aHeadGrade	:= {}
	PRIVATE aColsGrade	:= {}

	Private ALTERA   := .F.
	Private INCLUI   := .T.
	Private lShowOpc := .T.

	Private aHeader  := {}
	Private aCols    := {}

	cQry := " SELECT * FROM "+RetSqlName("AIB")+" AIB "
	cQry += " JOIN "+RetSqlName("SB1")+" SB1 "
	cQry += " ON B1_COD = AIB_CODPRO "
	cQry += " AND B1_FILIAL = '"+xFilial("SB1")+"' "
	cQry += " AND SB1.D_E_L_E_T_<>'*' "
	cQry += " WHERE AIB.AIB_CODFOR = '"+AIA->AIA_CODFOR+"' "
	cQry += " AND AIB.AIB_LOJFOR = '"+AIA->AIA_LOJFOR+"' "
	cQry += " AND AIB.AIB_CODTAB = '"+AIA->AIA_CODTAB+"' "
	cQry += " AND AIB.AIB_XSTATS = 'S' "
	cQry += " AND AIB.D_E_L_E_T_<>'*' "
	cQry += " ORDER BY B1_DESC "


	If (Select("QryPrd")<>0)
		QryPrd->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"QryPrd",.T.,.T.)

	//--------------------------+
	//Monta Arquivo de trabalho |
	//--------------------------+

	aStruct := {}
	aTam := {02, 00, "C"}            ; aAdd(aStruct,{"TR_OK"     ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_CODTAB")  	 ; aAdd(aStruct,{"TR_TAB" ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_ITEM")  	 ; aAdd(aStruct,{"TR_ITEM" ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_CODPRO")     ; aAdd(aStruct,{"TR_PRODUT"  ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("B1_DESC")        ; aAdd(aStruct,{"TR_DESC"  ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_PRCCOM") 	 ; aAdd(aStruct,{"TR_PRECO" ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_DATVIG")     ; aAdd(aStruct,{"TR_DATA" ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_CODFOR")     ; aAdd(aStruct,{"TR_CODFOR" ,aTam[3],aTam[1],aTam[2]})
	aTam := TamSX3("AIB_LOJFOR")     ; aAdd(aStruct,{"TR_LOJFOR" ,aTam[3],aTam[1],aTam[2]})


	cArquivo := CriaTrab(aStruct,.T.)

	If Select(cAliasPrd) != 0
		(cAliasPrd)->(dbCloseArea())
	End

	dbUseArea(.T.,"",cArquivo,cAliasPrd,.F.,.F.)

	IndRegua(cAliasPrd,cArquivo,"TR_TAB+TR_ITEM",,,"Criando Índice...")

	While QryPrd->(!Eof())


		RecLock(cAliasPrd,.T.)
		(cAliasPrd)->TR_OK     := ""
		(cAliasPrd)->TR_TAB    := QryPrd->AIB_CODTAB
		(cAliasPrd)->TR_ITEM   := QryPrd->AIB_ITEM
		(cAliasPrd)->TR_PRODUT := QryPrd->AIB_CODPRO
		(cAliasPrd)->TR_DESC   := QryPrd->B1_DESC
		(cAliasPrd)->TR_PRECO  := QryPrd->AIB_PRCCOM
		(cAliasPrd)->TR_DATA   := SToD(QryPrd->AIB_DATVIG)
		(cAliasPrd)->TR_CODFOR := QryPrd->AIB_CODFOR
		(cAliasPrd)->TR_LOJFOR := QryPrd->AIB_LOJFOR
		(cAliasPrd)->(MsUnLock())


		QryPrd->(DbSkip())
	EndDo

	(cAliasPrd)->(DbGotop())

	//---------------+
	//Monta aHeaTRB  |
	//---------------+

	aAdd(aCampos, {"AIB_CODTAB"	, "TR_TAB", .T.})
	aAdd(aCampos, {"AIB_ITEM"	, "TR_ITEM", .T.})
	aAdd(aCampos, {"AIB_CODPRO" , "TR_PRODUT", .T.})
	aAdd(aCampos, {"B1_DESC"    , "TR_DESC"  , .T.})
	aAdd(aCampos, {"AIB_PRCCOM" , "TR_PRECO" , .T.})
	aAdd(aCampos, {"AIB_DATVIG"	, "TR_DATA" , .T.})
	aAdd(aCampos, {"AIB_CODFOR"	, "TR_CODFOR" , .T.})
	aAdd(aCampos, {"AIB_LOJFOR"	, "TR_LOJFOR" , .T.})

	aAdd(aHeaTRB, {"TR_OK",,""})

	For i := 1 To Len(aCampos)
		SX3->(dbSetOrder(2)) //X3_CAMPO
		If SX3->(dbSeek(aCampos[i,1]))
			aAdd(aHeaTRB,{aCampos[i,2],,Trim(X3Titulo()),IIf(aCampos[i,3],SX3->X3_Picture,)})
		EndIf
	Next i

	//------------------------+
	//Monta tela com msselect |
	//------------------------+
	oMainWnd:ReadClientCoords()
	oDlg := MsDialog():New(100,100,600,1300,OemToAnsi("Itens a Bloquear"),,,.F.,,,,,oMainWnd,.T.,,,.F.)

	oPnlClient := TPanel():New(1,1,,oDlg,,.T.,.F.,,,1,1,,)
	oPnlClient:Align := CONTROL_ALIGN_ALLCLIENT

	oMarPrd := MsSelect():New(cAliasPrd,"TR_OK","",aHeaTRB,lInvPrd,cMarPrd,{1,1,1,1},,,oPnlClient)
	oMarPrd:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oMarPrd:oBrowse:bAllMark := {|| fMarcCheck()}

	Activate MSDialog oDlg On Init EnchoiceBar(oDlg,{|| nOpc := 1,oDlg:End()},{|| nOpc := 0,oDlg:End()}) Centered

	If nOpc == 1

		//AIB->(dbSetOrder(2))
		(cAliasPrd)->(DbGotop())
		While (cAliasPrd)->(!Eof())
			If !Empty((cAliasPrd)->TR_OK)

				DbSelectArea("AIB")
				AIB->(DbSetOrder(1))
				AIB->(DbGoTop())

				If DbSeek(xFilial("AIB")+(cAliasPrd)->TR_CODFOR+(cAliasPrd)->TR_LOJFOR+(cAliasPrd)->TR_TAB+(cAliasPrd)->TR_ITEM)

					RecLock("AIB",.F.)

					AIB->AIB_XSTATS := 'N'

					AIB->(MsUnlock())

				EndIf

			EndIf

			(cAliasPrd)->(DbSkip())
		EndDo

	EndIf

	RestArea(aArea)

Return


Static Function fMarcCheck()


	(cAliasPrd)->(dbGoTop())
	While (cAliasPrd)->(!Eof())
		If Empty((cAliasPrd)->TR_OK)
			RecLock(cAliasPrd)
			(cAliasPrd)->TR_Ok := cMarPrd
			msUnLock(cAliasPrd)
		Else
			RecLock(cAliasPrd)
			(cAliasPrd)->TR_Ok := Space(2)
			msUnLock(cAliasPrd)
		End
		(cAliasPrd)->(dbSkip())
	EndDo

	(cAliasPrd)->(dbGoTop())
	oMarPrd:oBrowse:Refresh()

Return .T.
