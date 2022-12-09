#Include 'Protheus.ch'
#Include 'Colors.ch'

#Define ITEM     1
#Define DESCPRO  2
#Define CODIGO   3
#Define CODBAR   4
#Define LOTE     5
#Define VALIDADE 6
#Define QUANT    7
#Define CONTAGEM 8
#Define DTCONTA  9

#xtranslate bSetGet(<uVar>) => {|u| If(PCount()== 0, <uVar>,<uVar> := u)}

User Function resta10()

	Local cFilter     := ""
	Local aCores      := {}
	Private cCadastro := 'Contagem de produtos por NFE'
	Private cDelFunc  := '.t.'
	Private aRotina   := {}
	Private cAlias    := 'SF1'

	aAdd( aRotina, { 'Pesquisar'  , 'AxPesqui', 0, 1 } )
	aAdd( aRotina, { "Visualizar" , "AxVisual", 0, 2 })
	aAdd( aRotina, { 'Contagem'   , 'u_resta10a()', 0, 3 } )

	cFilter := "F1_FORNECE = '001900' AND F1_LOJA = '01' AND F1_ESPECIE = 'NFE  ' AND F1_SERIE = 'F03' AND F1_TIPO = 'N' AND F1_STATUS = ' '"
	//cFilter := "F1_FORNECE = '001900' AND F1_LOJA = '01' AND F1_ESPECIE = 'NFE  ' AND F1_TIPO = 'N'"

	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTop()
	mBrowse(10,10,60,120,cAlias,,,,,, aCores,,,,,,,,cFilter)

Return Nil

User Function resta10a()

	Local cSql := ""
	Local cTrb := ""

	Local oDlg
	Local oPnl1
	Local oPnl2
	Local oGet1,oGet2,oGet3,oGet4,oGet5,oGet6,oGet7
	Local oButton1
	Local oButton2

	Local oFont12N := tFont():New("Arial"          ,12,12,,.t.,,,,.t.,.f.)

	Local lHasButton := .f.
	Local lNoButton  := .t.
	Local cLabelText := ""    //indica o texto que será apresentado na Label.
	Local nLabelPos  := 2     //Indica a posição da label, sendo 1=Topo e 2=Esquerda
	Local bSetGet := {|| }
	Local bValid := {|| .t. }
	Local bWhen := {|| .t. }
	Local bChange := {|| }

	Local cCodBar := space(TamSX3("B1_CODBAR")[1])
	Local cLoteCtl:= space(TamSX3("B8_LOTECTL")[1])
	Local cDtVali := space(TamSX3("B8_DTVALID")[1])
	Local nQtCon  := 0

	Private oBrwIt
	Private aColsIt := {}

	if empty(sf1->f1_doc)
		MessageBox("Favor posisionar em alguma NFE para executar a contagem de produtos!","ATENÇÃO", 16)
		return
	endif

	DbSelectArea("SZ5")
	cDoc 	:= sf1->f1_doc
	cSerie	:= sf1->f1_serie
	cEmissão := dtoc(sf1->f1_emissao)

	cSql := "select d1_item,d1_quant,d1_lotectl,d1_dtvalid,b1_codbar,b1_desc,coalesce(z5_qtdleit,0) z5_qtdleit,coalesce(z5_dtconta,' ') z5_dtconta from "+RetSQLName("SD1")+" d1 "
	cSql += "inner join "+RetSQLName("SB1")+" b1 on b1_filial = '"+xFilial("SB1")+"' and b1_cod = d1_cod and b1.d_e_l_e_t_ = ' ' "
	cSql += "left join "+RetSQLName("SZ5")+" z5 on z5_filial = d1_filial and z5_doc = d1_doc and z5_serie = d1_serie and z5_item = d1_item and z5.d_e_l_e_t_ = ' ' "
	cSql += "where d1_filial = '"+xFilial("SD1")+"' and d1_doc = '"+cDoc+"' and d1_serie = '"+cSerie+"' and d1_fornece = '"+sf1->f1_fornece+"' and d1_loja = '"+sf1->f1_loja+"' "
	cSql += "and d1.d_e_l_e_t_ = ' ' order by d1_item"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),ctrb,.f.,.t.)
	while !(ctrb)->( Eof() )
		Aadd(aColsIt, { (ctrb)->d1_item, (ctrb)->b1_desc, (ctrb)->b1_cod, (ctrb)->b1_codbar, (ctrb)->d1_lotectl, stod((ctrb)->d1_dtvalid), (ctrb)->d1_quant, (ctrb)->z5_qtdleit, stod((ctrb)->z5_dtconta) } )
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

	DEFINE MSDIALOG oDlg TITLE "Itens NF para Contagem de produtos" FROM 000, 000  TO 580, 1150 COLORS 0, 16777215 PIXEL
	//					lin,col                     col,lin
	oPnl1:= tPanel():New(000,000,,oDlg,,,,,CLR_HCYAN,575,050)
	oPnl2:= tPanel():New(050,000,,oDlg,,,,,CLR_HGRAY,575,260)

	//@ 005, 420 BUTTON oButton2 PROMPT "Guardar Cont." SIZE 037, 012 action guarCon(oBrwIt)                     OF oPnl1 PIXEL
	@ 005, 465 BUTTON oButton2 PROMPT "Confirmar"     SIZE 037, 012 action iif(confCon(oBrwIt),oDlg:End(),.f.) OF oPnl1 PIXEL
	@ 005, 510 BUTTON oButton1 PROMPT "Sair"          SIZE 037, 012 action iif(sairCon(oBrwIt),oDlg:End(),.f.) OF oPnl1 PIXEL

	cLabelText := "NFE:"
	oGet1 := TGet():New(005,003,bSetGet(cDoc)    ,oPnl1,040,010,"@!" ,bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F.,,"cDoc"    ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	oGet1:lcangotfocus := .f.
	cLabelText := "Série:"
	oGet2 := TGet():New(005,090,bSetGet(cSerie)  ,oPnl1,030,010,"@!" ,bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F.,,"cSerie"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	oGet2:lcangotfocus := .f.
	cLabelText := "Emissão:"
	oGet3 := TGet():New(005,150,bSetGet(cEmissão),oPnl1,052,010,"@!" ,bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F.,,"cEmissão",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	oGet3:lcangotfocus := .f.

	nLabelPos  := 1
	cLabelText := "Cód.barra Prod.: "
	oGet4 := TGet():New(020,002,bSetGet(cCodBar),oPnl1,132,016,"@!"  ,bValid,,,oFont16N,   ,,.T.,,   ,bWhen,,,bChange,.F./*lReadOnly*/,.f./*lPassword*/,,"cCodBar" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, oFont12N,/*nLabelColor*/,,,.t./*lFocSel*/)
	oGet4:bGotFocus := {|| ( cCodBar := space(len(alltrim(aColsIt[oBrwIt:nAt,04]))), cLoteCtl:= space(len(alltrim(aColsIt[oBrwIt:nAt,05]))), cDtVali := space(TamSX3("B8_DTVALID")[1]) ) }

	bSetGet := { |u| If(PCount()==0,cLoteCtl, cLoteCtl:= u) }
	cLabelText := "Lote: "
	oGet5 := TGet():New(020,132,bSetGet         ,oPnl1,177,016,"@!"  ,bValid,,,oFont16N,   ,,.T.,,   ,bWhen,,,bChange,.F./*lReadOnly*/,.F./*lPassword*/,,"cLoteCtl" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, oFont12N,/*nLabelColor*/,,,.t./*lFocSel*/)

	cLabelText := "DtValid: "
	oGet6 := TGet():New(020,307,bSetGet(cDtVali),oPnl1,035,016,"@R 99/99/99"  ,bValid,,,oFont16N,,,.T.,,,bWhen,,,bChange,.F./*lReadOnly*/,.F./*lPassword*/,,"cDtVali",,,, lHasButton , lNoButton,, cLabelText, nLabelPos, oFont12N,/*nLabelColor*/,,,.t./*lFocSel*/)

	bSetGet := { |u| If(PCount()==0,nQtCon, nQtCon:= u) }
	bChange := {|| ( oBrwIt:oData:aArray[oBrwIt:nAt,CONTAGEM] := verCodBarra(cCodBar,cLoteCtl,cDtVali,nQtCon,oBrwIt), guarCon(oBrwIt:oData:aArray,oBrwIt:nAt), nQtCon := 0, oGet7:picture:= "", oGet7:cText := 0, oGet7:picture:= "@E 99,999,999", oBrwIt:Refresh(), oGet4:SetFocus() ) }
	cLabelText := "Contagem: "
	oGet7 := TGet():New(020,408,bSetGet         ,oPnl1,075,016,"@E 99,999,999",bValid,,,oFont16N,,,.T.,,,bWhen,,,bChange,.F./*lReadOnly*/,.F./*lPassword*/,,"nQtCon" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, oFont12N,/*nLabelColor*/,,,.t./*lFocSel*/)

	/*******************************************************/
	oBrwIt:=fwBrowse():New()
	oBrwIt:setOwner( oPnl2 )
	oBrwIt:setDataArray()
	oBrwIt:setArray( aColsIt )
	oBrwIt:disableConfig()
	oBrwIt:disableReport()
	oBrwIt:SetLocate() // Habilita a Localização de registros
	//oBrwIt:SetLineOk( {|| focaget4(oGet4) } )
	oBrwIt:SetChange( {|| focaget4(oGet4) } )
	//oBrwIt:SetDoubleClick( { || oBrwIt:oData:aArray[oBrwIt:nAt,CONTAGEM] := fazContagem(oBrwIt:oData:aArray[oBrwIt:nAt]) } )

	// Cria uma coluna de status
	//oBrwIt:AddStatusColumns({||Iif(!empty(aColsIt[oBrwIt:nAt,CONTAGEM]),'BR_VERDE','BR_VERMELHO')},{|oBrwIt|/*Função de DOUBLECLICK*/})

	// Adiciona legenda no Browse
	oBrwIt:AddLegend('aColsIt[oBrwIt:nAt,8] == 0',"RED","Sem Contagem")
	oBrwIt:AddLegend('aColsIt[oBrwIt:nAt,8] == aColsIt[oBrwIt:nAt,7]',"GREEN","Contagem finalizada")
	oBrwIt:AddLegend('aColsIt[oBrwIt:nAt,8] != 0 .and. aColsIt[oBrwIt:nAt,8] < aColsIt[oBrwIt:nAt,7]',"BLUE","Contagem Divergente à menor")
	oBrwIt:AddLegend('aColsIt[oBrwIt:nAt,8] != 0 .and. aColsIt[oBrwIt:nAt,8] > aColsIt[oBrwIt:nAt,7]',"YELLOW","Contagem Divergente à maior")

	oBrwIt:addColumn({"Item"      , {||aColsIt[oBrwIt:nAt,01]}, "C", "@!"            ,1 ,04 ,  , .F. , , .F.,, "aColsIt[oBrwIt:nAt,01]",, .F., .T.,  , "citem"  })
	oBrwIt:addColumn({"Descrição" , {||aColsIt[oBrwIt:nAt,02]}, "C", "@!"            ,1 ,40 ,  , .F. , , .F.,, "aColsIt[oBrwIt:nAt,02]",, .F., .T.,  , "cDesc"  })
	oBrwIt:addColumn({"Código"    , {||aColsIt[oBrwIt:nAt,03]}, "C", "@!"            ,1 ,15 ,  , .F. , , .F.,, "aColsIt[oBrwIt:nAt,03]",, .F., .T.,  , "cCod"   })
	oBrwIt:addColumn({"Cód. Barra", {||aColsIt[oBrwIt:nAt,09]}, "C", "@!"            ,1 ,15 ,  , .F. , , .F.,, "aColsIt[oBrwIt:nAt,09]",, .F., .T.,  , "cCodBar"})
	oBrwIt:addColumn({"Lote"      , {||aColsIt[oBrwIt:nAt,04]}, "C", "@!"            ,1 ,10 ,  , .F. , , .F.,, "aColsIt[oBrwIt:nAt,04]",, .F., .T.,  , "cLote"  })
	oBrwIt:addColumn({"Val.Lote"  , {||aColsIt[oBrwIt:nAt,05]}, "D", "@!"            ,1 ,08 ,  , .F. , , .F.,, "aColsIt[oBrwIt:nAt,05]",, .F., .T.,  , "dDtVal" })
	oBrwIt:addColumn({"Qtd"       , {||aColsIt[oBrwIt:nAt,06]}, "N", "@E 999,999.99" ,2 ,10 ,2 , .F. , , .F.,, "aColsIt[oBrwIt:nAt,06]",, .F., .T.,  , "nQutd"  })
	oBrwIt:addColumn({"Contagem"  , {||aColsIt[oBrwIt:nAt,07]}, "N", "@E 999,999"    ,1 ,10 ,  , .F. , , .F.,, "aColsIt[oBrwIt:nAt,07]",, .F., .T.,  , "nConta" })
	oBrwIt:addColumn({"D.Contagem", {||aColsIt[oBrwIt:nAt,08]}, "D", "@!"            ,1 ,08 ,  , .F. , , .F.,, "aColsIt[oBrwIt:nAt,08]",, .F., .T.,  , "dDtcon" })

	//oBrwIt:setEditCell( .t. , { || .t. } ) //activa edit and code block for validation

	oBrwIt:Activate(.t.)

	oGet4:SetFocus()

	ACTIVATE MSDIALOG oDlg CENTERED

return


Static Function focaget4(oGet4)

	oGet4:SetFocus()

Return .t.

Static Function guarCon(aObj,nAt)
	Local lRet := .f.
	Local cItDvL := ""
	Local dDtConta := dDatabase
	Local nI:= 0

	Default nAt := 0

	sz5->(DbSetOrder(1))
	for nI := 1 to len(aObj)

		if aObj[nI,QUANT] == aObj[nI,CONTAGEM] .and. (nAt == 0 .or. nI == nAt)

			lRet := .t.

			cItDvL := dtoc(aObj[nI,VALIDADE])
			cItDvL := substr(cItDvL, 1, 2)+'/'+ substr(cItDvL, 4, 2)+'/'+substr(cItDvL, 9, 2)
			dDtConta := dDatabase

			if sz5->(DbSeek(xFilial()+cDoc+cSerie+aObj[nI,ITEM]))
				if sz5->z5_qtdleit == aObj[nI,CONTAGEM]
					dDtConta := sz5->z5_dtconta
				endif
				SZ5->(RecLock("SZ5",.f.))
			else
				SZ5->(RecLock("SZ5",.t.))
			endif
			SZ5->Z5_FILIAL	:= xFilial("SZ5")
			SZ5->Z5_DOC		:= cDoc
			SZ5->Z5_SERIE	:= cSerie
			SZ5->Z5_ITEM	:= aObj[nI,ITEM]
			//SZ5->Z5_CODBAR	:= aObj[nI,CODBAR]
			//SZ5->Z5_LOTECTL	:= aObj[nI,LOTE]
			//SZ5->Z5_DTVALID	:= aObj[nI,VALIDADE]
			SZ5->Z5_CODBARR	:= alltrim(aObj[nI,CODBAR])+alltrim(aObj[nI,LOTE])+alltrim(cItDvL)
			SZ5->Z5_QTDLEIT	:= aObj[nI,CONTAGEM]
			SZ5->Z5_DTCONTA	:= dDtConta
			SZ5->(MsUnLock())

		endif
	next

	if lRet
		MessageBox("Contagem finalizada foi quardada!","ATENÇÃO", 16)
	else
		MessageBox("Contagem não foi finalizada!","ATENÇÃO", 16)
	endif

Return


Static Function confCon(oBrwIt)
	Local lRet := .f.
	Local aObj := oBrwIt:oData:aArray
	Local cItDvL := ""
	Local dDtConta := dDatabase
	Local nI:= 0

	for nI := 1 to len(aObj)
		if aObj[nI,CONTAGEM] > 0 .or. !empty(aObj[nI,DTCONTA])
			lRet := .t.
		endif
	next

	if lRet
		if MsgYesNo("Confirma a contagem dos produtos feitas ?" )
			sz5->(DbSetOrder(1))
			for nI := 1 to len(aObj)

				if aObj[nI,CONTAGEM] > 0 .or. !empty(aObj[nI,DTCONTA])

					cItDvL := dtoc(aObj[nI,VALIDADE])
					cItDvL := substr(cItDvL, 1, 2)+'/'+ substr(cItDvL, 4, 2)+'/'+substr(cItDvL, 9, 2)
					dDtConta := dDatabase

					if sz5->(DbSeek(xFilial()+cDoc+cSerie+aObj[nI,ITEM]))
						if sz5->z5_qtdleit == aObj[nI,CONTAGEM]
							dDtConta := sz5->z5_dtconta
						endif
						SZ5->(RecLock("SZ5",.f.))
					else
						SZ5->(RecLock("SZ5",.t.))
					endif
					SZ5->Z5_FILIAL	:= xFilial("SZ5")
					SZ5->Z5_DOC		:= cDoc
					SZ5->Z5_SERIE	:= cSerie
					SZ5->Z5_ITEM	:= aObj[nI,ITEM]
					//SZ5->Z5_CODBAR	:= aObj[nI,CODBAR]
					//SZ5->Z5_LOTECTL	:= aObj[nI,LOTE]
					//SZ5->Z5_DTVALID	:= aObj[nI,VALIDADE]
					SZ5->Z5_CODBARR	:= aObj[nI,CODBAR]+aObj[nI,LOTE]+cItDvL
					SZ5->Z5_QTDLEIT	:= aObj[nI,CONTAGEM]
					SZ5->Z5_DTCONTA	:= dDtConta
					SZ5->(MsUnLock())

				endif
			next
		endif
	else
		MessageBox("Nenhuma contagem foi realizada!","ATENÇÃO", 16)
	endif

Return(lRet)


Static Function sairCon(oBrwIt)
	Local lRet := .t.
	Local aObj := oBrwIt:oData:aArray
	Local nI:= 0

	for nI := 1 to len(aObj)
		if aObj[nI,QUANT] == aObj[nI,CONTAGEM] .and. empty(aObj[nI,DTCONTA])
			lRet := .f.
			exit
		endif
	next
	if !lRet
		nRet := MessageBox("Existe(m) contagen(s) Finalizada(s). Deseja sair sem confirmar a contagem?","ATENÇÃO", 04)
		if nRet == 6
			lRet := .t.
		else
			lRet := .f.
		endif
	endif
Return(lRet)


Static Function fazContagem(aObjIt)

	Local cItem := aObjIt[ITEM]
	Local cDesc := aObjIt[DESCPRO]
	Local cCod  := aObjIt[CODIGO]
	Local nQuant:= aObjIt[QUANT]
	//Local cLote := aObjIt[LOTE]
	//Local dVali := aObjIt[VALIDADE]
	Local nQtLei := aObjIt[CONTAGEM]
	Local nQtAnt := nQtLei
	//Local cCodBarra := space(nTamLei)
	Local nTamCBR := len(alltrim(aObjIt[CODBAR]))	//TamSX3("B1_CODBAR")[1]
	Local nTamLTE := len(alltrim(aObjIt[LOTE]))		//TamSX3("B8_LOTECTL")[1]
	Local nTamDTV := TamSX3("B8_DTVALID")[1]
	Local cCodBar := space(nTamCBR)
	Local cLoteCtl:= space(nTamLTE)
	Local cDtVali := space(nTamDTV)
	Local nTamLei := nTamCBR+nTamLTE+nTamDTV

	Local oDlg
	Local oPnl1
	Local oPnl2
	Local oGet1
	Local oGet2
	Local oGet3
	Local oGet4
	//Local oGet5
	Local oGet6
	Local oGet7
	Local oGet8

	Local oSay1
	Local oSay5

	Local oButton1
	Local oButton2

	Local lHasButton := .f.
	Local lNoButton  := .t.
	Local cLabelText := ""    //indica o texto que será apresentado na Label.
	Local nLabelPos  := 2     //Indica a posição da label, sendo 1=Topo e 2=Esquerda
	Local bSetGet := {|| }
	Local bValid := {|| .t. }
	Local bWhen := {|| .t. }
	Local bChange := {|| }

	Local oFont12Na:= tFont():New("Arial" , 12, 25,,.t.,,,,.t.,.f.)
	Local oFont12N := tFont():New("Arial" , 12, 12,,.t.,,,,.t.,.f.)
	Local oFont16N := tFont():New("Arial" , 16, 16,,.t.,,,,.t.,.f.)

	Private oBrwCo
	Private aColsCo := { {"","",stod("  "),"",""} }

	if nQtLei == nQuant
		MessageBox("Contagem deste item já foi finalizada!","ATENÇÃO", 16)
		Return(nQtLei)
	else
		nQtLei := 0
	endif

	DEFINE MSDIALOG oDlg TITLE "Contagem do Item" FROM 000, 000  TO 600, 1035 COLORS 0, 16777215 PIXEL
	//					lin,col                     col,lin
	oPnl1:= tPanel():New(000,000,,oDlg,,,,,CLR_HCYAN,520,050)
	oPnl2:= tPanel():New(050,000,,oDlg,,,,,CLR_HGRAY,520,250)

	cLabelText := "Item: "
	oGet1 := TGet():New(003,002,bSetGet(cItem) ,oPnl1,015,010,"@!"           ,bValid,,,        ,,,.T.,,,bWhen,,,bChange,.T./*lReadOnly*/,.F.,,"cItem" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos,         ,/*nLabelColor*/,,,.f./*lFocSel*/)
	oGet1:lcangotfocus := .f.
	cLabelText := "Código: "
	oGet2 := TGet():New(003,045,bSetGet(cCod)  ,oPnl1,045,010,"@!"           ,bValid,,,        ,,,.T.,,,bWhen,,,bChange,.T./*lReadOnly*/,.F.,,"cCod"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos,         ,/*nLabelColor*/,,,.f./*lFocSel*/)
	oGet2:lcangotfocus := .f.
	cLabelText := "Descrição: "
	oGet3 := TGet():New(003,120,bSetGet(cDesc) ,oPnl1,120,010,"@!"           ,bValid,,,        ,,,.T.,,,bWhen,,,bChange,.T./*lReadOnly*/,.F.,,"cDesc" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos,         ,/*nLabelColor*/,,,.f./*lFocSel*/)
	oGet3:lcangotfocus := .f.
	cLabelText := "Qtd NF: "
	oGet4 := TGet():New(003,275,bSetGet(nQuant),oPnl1,030,010,"@E 999,999.99",bValid,,,        ,,,.T.,,,bWhen,,,bChange,.T./*lReadOnly*/,.F.,,"mQuant",,,, lHasButton , lNoButton,, cLabelText, nLabelPos,         ,/*nLabelColor*/,,,.f./*lFocSel*/)
	oGet4:lcangotfocus := .f.
	//cLabelText := "Contagem: "
	//oGet5 := TGet():New(003,340,bSetGet(nQtLei),oPnl1,070,010,"@E 99,999,999",bValid,,,oFont16N,,,.T.,,,bWhen,,,bChange,.T./*lReadOnly*/,.F.,,"nQtLei",,,, lHasButton , lNoButton,, cLabelText, nLabelPos, oFont12N,/*nLabelColor*/,,,.f./*lFocSel*/)
	//oGet5:nClrText := CLR_BLUE
	//oGet5:nClrPane := CLR_BLUE
	//oGet5:Refresh()
	//oGet5:lcangotfocus := .f.
	oSay1 := TSay():New(005,340, { || "Contagem: " }, oPnl1,               ,oFont12Na,,,, .T.,         ,, 070, 020)
	oSay5 := TSay():New(005,405, { || nQtLei }      , oPnl1,"@E 99,999,999",oFont12Na,,,, .T.,CLR_BLACK,, 080, 020)

	oBrwCo:=fwBrowse():New()
	oBrwCo:setOwner( oPnl2 )
	oBrwCo:setDataArray()
	oBrwCo:setArray( aColsCo )
	oBrwCo:disableConfig()
	oBrwCo:disableReport()
	oBrwCo:SetLocate() // Habilita a Localização de registros

	oBrwCo:nAt := 1
	oBrwCo:addColumn({"Cód.Barra" , {||aColsCo[oBrwCo:nAt,01]}, "C", "@!",1 ,nTamCBR   ,  , .F. , , .F.,, "aColsCo[oBrwCo:nAt,01]", , .F., .T.,  , "cCodigo"   })
	oBrwCo:addColumn({"Lote"      , {||aColsCo[oBrwCo:nAt,02]}, "C", "@!",1 ,nTamLTE   ,  , .F. , , .F.,, "aColsCo[oBrwCo:nAt,02]", , .T., .F.,  , "cLote"     })
	oBrwCo:addColumn({"Val.Lote"  , {||aColsCo[oBrwCo:nAt,03]}, "D", "@D",1 ,nTamDTV   ,  , .F. , , .F.,, "aColsCo[oBrwCo:nAt,03]", , .T., .F.,  , "dDtVal"    })
	oBrwCo:addColumn({"Leitura"   , {||aColsCo[oBrwCo:nAt,04]}, "C", "@!",1 ,08        ,  , .F. , , .F.,, "aColsCo[oBrwCo:nAt,04]", , .F., .T.,  , "cLeitura"  })
	oBrwCo:addColumn({"Cód.Barra" , {||aColsCo[oBrwCo:nAt,05]}, "C", "@!",1 ,nTamLei+8 ,  , .F. , , .F.,, "aColsCo[oBrwCo:nAt,05]", , .F., .T.,  , "cCodBarra" })

	//oBrwCo:setEditCell( .t. , { || .t. } ) //activa edit and code block for validation

	oBrwCo:lcangotfocus := .f.
	oBrwCo:Activate(.t.)

	////bChange := {|| ( nQtLei += lerCodBarra(cCodBarra,oBrwCo,aObjIt,nQtLei), oGet5:lcangotfocus := .t., oGet5:lFocSel:=.t., oGet5:setFocus(), oGet5:nClrText := iif(nQtLei > nQuant,CLR_RED,CLR_BLUE), oGet5:Refresh(), oGet5:lcangotfocus := .f., oGet5:lFocSel:=.f., oGet6:SetFocus() ) }
	//bChange := {|| ( nQtLei += lerCodBarra(cCodBarra,oBrwCo,aObjIt,nQtLei), oGet1:lcangotfocus := .t., oGet1:lFocSel:=.t., oGet1:setFocus(), oGet1:lcangotfocus := .f., oGet1:lFocSel:=.f., oSay1:nClrText := iif(nQtLei > nQuant,CLR_HRED,CLR_BLACK), oSay5:nClrText := iif(nQtLei > nQuant,CLR_HRED,CLR_BLACK), oSay5:Refresh(), oGet6:SetFocus() ) }
	//cLabelText := "Código barras: "
	//oGet6 := TGet():New(020,002,bSetGet(cCodBarra),oPnl1,395,016,"@!"           ,bValid,,,oFont16N,,,.T.,,,bWhen,,,bChange,.F./*lReadOnly*/,.F.,,"cCodBarra" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, oFont12N,/*nLabelColor*/,,,.t./*lFocSel*/)
	//oGet6:bGotFocus := {|| cCodBarra := space(nTamLei) }

	nLabelPos  := 1
	cLabelText := "Cód.barra Prod.: "
	oGet6 := TGet():New(020,002,bSetGet(cCodBar),oPnl1,132,016,"@!"           ,bValid,,,oFont16N,,,.T.,,,bWhen,,,bChange,.F./*lReadOnly*/,.t./*lPassword*/,,"cCodBar"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, oFont12N,/*nLabelColor*/,,,.t./*lFocSel*/)
	oGet6:bGotFocus := {|| ( cCodBar := space(nTamCBR),	cLoteCtl:= space(nTamLTE), cDtVali := space(nTamDTV) ) }

	bSetGet := { |u| If(PCount()==0,cLoteCtl, cLoteCtl:= u) }
	//bSetGet := { |u| teste(PCount(),cLoteCtl,u,oGet8) }
	cLabelText := "Lote: "
	oGet7 := TGet():New(020,132,bSetGet                                   ,oPnl1,177,016,"@!"           ,bValid,,,oFont16N,,,.T.,,,bWhen,,,bChange,.F./*lReadOnly*/,.F.,,"cLoteCtl" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, oFont12N,/*nLabelColor*/,,,.t./*lFocSel*/)

	bChange := {|| ( nQtLei += lerCodBarra(cCodBar,cLoteCtl,cDtVali,oBrwCo,aObjIt,nQtLei), oGet1:lcangotfocus := .t., oGet1:lFocSel:=.t., oGet1:setFocus(), oGet1:lcangotfocus := .f., oGet1:lFocSel:=.f., oSay1:nClrText := iif(nQtLei > nQuant,CLR_HRED,CLR_BLACK), oSay5:nClrText := iif(nQtLei > nQuant,CLR_HRED,CLR_BLACK), oSay5:Refresh(), oGet6:SetFocus() ) }
	cLabelText := "DtValid: "
	oGet8 := TGet():New(020,307,bSetGet(cDtVali),oPnl1,035,016,"@!"           ,bValid,,,oFont16N,,,.T.,,,bWhen,,,bChange,.F./*lReadOnly*/,.F.,,"cDtVali"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, oFont12N,/*nLabelColor*/,,,.t./*lFocSel*/)

	@ 005, 470 BUTTON oButton1 PROMPT "Sair" SIZE 037, 012 action (nQtLei:=nQtAnt,oDlg:End()) OF oDlg PIXEL
	@ 025, 470 BUTTON oButton2 PROMPT "Confirmar" SIZE 037, 012 action oDlg:End() OF oDlg PIXEL
	oButton1:lcangotfocus := .f.
	oButton2:lcangotfocus := .f.

	oGet6:SetFocus()

	ACTIVATE MSDIALOG oDlg CENTERED

Return(nQtLei)

/*
Static Function teste(nPar,cCampo,u,oObj)
	Local cRet := ""
	if nPar == 0
		cRet := cCampo
	else
		cRet  := u
	endif
	//oObj:SetFocus()
Return cRet
*/

Static Function lerCodBarra(cCodBar,cLoteCtl,cDtVali,oObjCo,aObjIt,nTotLei)

	Local aObj := oObjCo:oData:aArray[oObjCo:nAt]
	Local nLin := 0
	Local cItDvL := ""
	Local nConta := 0
	Local cCodBarra := alltrim(cCodBar)+alltrim(cLoteCtl)+alltrim(cDtVali)

	if !empty(cCodBar) .and. !empty(cLoteCtl) .and. !empty(cDtVali)

		cItDvL := dtoc(aObjIt[VALIDADE])
		cItDvL := substr(cItDvL, 1, 2)+'/'+ substr(cItDvL, 4, 2)+'/'+substr(cItDvL, 9, 2)

		if cCodBar == alltrim(aObjIt[CODBAR]) .and. cLoteCtl == alltrim(aObjIt[LOTE]) .and. alltrim(cDtVali) == cItDvL

			oObjCo:GoBottom()
			nLin := oObjCo:nAt

			if !empty(aObj[1])
				oObjCo:AddLine()
				nLin += 1
			endif

			oObjCo:oData:aArray[nLin,1] := aObjIt[CODIGO]
			oObjCo:oData:aArray[nLin,2] := aObjIt[LOTE]
			oObjCo:oData:aArray[nLin,3] := aObjIt[VALIDADE]
			oObjCo:oData:aArray[nLin,4] := strzero(nTotLei+1,8)
			oObjCo:oData:aArray[nLin,5] := alltrim(cCodBarra)+strzero(nTotLei+1,8)

			if nLin > 14
				nLin := nLin - 14
			else
				nLin := 1
			endif
			oObjCo:GoTo(nLin)
			oObjCo:Refresh()

			nConta := 1
		else

			MessageBox("Problemas com leitura do código de barras!","ATENÇÃO", 16)

		endif

	else

		MessageBox("Problemas com leitura do código de barras!","ATENÇÃO", 16)

	endif

Return(nConta)

Static Function verCodBarra(cCodBar,cLoteCtl,cDtVali,nQtCon,oObjIt)

	Local aObj := oObjIt:oData:aArray[oObjIt:nAt]
	Local cItDvL := ""
	Local lRet := .t.
	Local nContagem := aObj[CONTAGEM]

	if !empty(cCodBar) .and. !empty(cLoteCtl) .and. !empty(cDtVali) .and. nQtCon != 0

		cItDvL := dtoc(aObj[VALIDADE])
		cItDvL := substr(cItDvL, 1, 2)+substr(cItDvL, 4, 2)+substr(cItDvL, 9, 2)

		if cCodBar != alltrim(aObj[CODBAR]) .or. cLoteCtl != alltrim(aObj[LOTE]) .or. alltrim(cDtVali) != cItDvL
			lRet := .f.
			MessageBox("Problemas com leitura do código de barras!","ATENÇÃO", 16)
		else
			nContagem := nQtCon
		endif

	else
		lRet := .f.
		MessageBox("Problemas com leitura do código de barras!","ATENÇÃO", 16)
	endif

Return(nContagem)
