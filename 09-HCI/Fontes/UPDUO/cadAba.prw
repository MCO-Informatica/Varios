#Include 'Protheus.ch'

User Function CadAba()

	Local oBrowse
	Local aBrowse := {}
	Private oDlgA

	//Tab ,Descrição                                    ,Tamanho campo x5_chave , se soma item
	Aadd(aBrowse,{'TR','Tabela elementos químicos (TABELA PERIÓDICA)',TamSx3("ZT_SIMBOLO")[1],.f.})
	Aadd(aBrowse,{'ZF','Tabela critérios de avaliação da composição química',TamSx3("ZF_ELEMEN")[1],.t.})
	Aadd(aBrowse,{'TX','tratamenteo termico',TamSx3("ZE_ITEM")[1],.t.})
	Aadd(aBrowse,{'PM','Material de partida',TamSx3("ZE_ITEM")[1],.t.})
	Aadd(aBrowse,{'TO','Tipo Corpo de Prova',TamSx3("ZE_ITEM")[1],.t.})
	Aadd(aBrowse,{'SU','Sentido do Corpo de Prova',TamSx3("ZE_ITEM")[1],.t.})

	DEFINE MSDIALOG oDlgA TITLE "Abas da Norma Técnica" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

	@ 000, 000 LISTBOX oBrowse Fields HEADER "Tabela","Descrição" SIZE 200, 150 OF oDlgA PIXEL ColSizes 30,50
	oBrowse:SetArray(aBrowse)
	oBrowse:bLine := {|| {;
		aBrowse[oBrowse:nAt,1],;
		aBrowse[oBrowse:nAt,2];
		}}

	//oBrowse:Align := CONTROL_ALIGN_TOP
	//oBrowse:Align := CONTROL_ALIGN_BOTTOM

	@ 010, 210 BUTTON oButton1 PROMPT "Manutenção" SIZE 037, 012 action MntAba(aBrowse[oBrowse:nAt,1],aBrowse[oBrowse:nAt,2],aBrowse[oBrowse:nAt,3],aBrowse[oBrowse:nAt,4]) OF oDlgA PIXEL
	@ 030, 210 BUTTON oButton2 PROMPT "Fechar"     SIZE 037, 012 action oDlgA:End() OF oDlgA PIXEL
	ACTIVATE MSDIALOG oDlgA CENTERED

Return Nil


Static Function MntAba(cTabela,cDescrTab,nTamItem,lSItem)  // tabela SX5, descrição tab,Tamanho do x5_chave, se soma itens

	Local nId := 0
	Local cSequen := ""
	Local nPerc   := 0   //Percentual para aumentar a tela

	Private aCabec := {}
	Private aColsEd := {}
	Private aColsEx := {}

	if cTabela == 'ZF'

		cSequen := "+ZF_SEQUEN"
		nPerc   := 1+(50/100)

		Aadd(aCabec, {"Seq"        ,"ZF_SEQUEN" ,"@!",TamSx3("ZF_SEQUEN")[1], 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Elem"       ,"ZF_ELEMEN" ,"@!",TamSx3("ZF_ELEMEN")[1], 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Descrição"  ,"ZF_DESCRI" ,"@!",TamSx3("ZF_DESCRI")[1], 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Fórmula"    ,"ZF_FORMUL" ,"@!",TamSx3("ZF_FORMUL")[1], 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Comparação" ,"ZF_COMPAR" ,"@!",TamSx3("ZF_COMPAR")[1], 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Lim.Exceção","ZF_LIMEXC" ,"@!",TamSx3("ZF_LIMEXC")[1], 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
		aColsEd := {"ZF_ELEMEN","ZF_DESCRI","ZF_FORMUL","ZF_COMPAR","ZF_LIMEXC"}

		cSql := "select * from "+RetSQLName("SZF")+" zf where zf_filial = '"+xFilial("SZF")+"' and zf.d_e_l_e_t_ = ' ' order by zf_elemen,zf_sequen"
		cSql := ChangeQuery( cSql )
		cTrb := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
		while !(ctrb)->( Eof() )
			Aadd(aColsEx, {  (ctrb)->zf_sequen, (ctrb)->zf_elemen, (ctrb)->zf_descri, (ctrb)->zf_formul, (ctrb)->zf_compar, (ctrb)->zf_limexc, .f. })
			(ctrb)->( DbSkip() )
		End
		(ctrb)->( DbCloseArea() )

	else

		cSequen := "+X5_CHAVE"
		nPerc   := 1

		if lSItem
			Aadd(aCabec, {"Item"     ,"X5_CHAVE"   ,"@!",          nTamItem, 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
		else
			Aadd(aCabec, {"Item"     ,"X5_CHAVE"   ,"@!",                 3, 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
			Aadd(aCabec, {"Simbolo"  ,"X5_SIMBOLO" ,"@!",          nTamItem, 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
		endif
		Aadd(aCabec, {"Descrição","X5_DESCRI","@!", TamSx3("X5_DESCRI")[1], 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
		if lSItem
			aColsEd := {"X5_DESCRI"}
		else
			aColsEd := {"X5_SIMBOLO","X5_DESCRI"}
		endif

		cSql := "select * from "+RetSQLName("SX5")+" x5 where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = '"+cTabela+"' and x5.d_e_l_e_t_ = ' '"
		cSql := ChangeQuery( cSql )
		cTrb := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
		while !(ctrb)->( Eof() )
			nId += 1
			if lSItem
				Aadd(aColsEx, {  substr((ctrb)->x5_chave,1,nTamItem), (ctrb)->x5_descri, .f. })
			else
				Aadd(aColsEx, {  strzero(nId,3), substr((ctrb)->x5_chave,1,nTamItem), (ctrb)->x5_descri, .f. })
			endif
			(ctrb)->( DbSkip() )
		End
		(ctrb)->( DbCloseArea() )
	endif

	if len(aColsEx) == 0
		if cTabela == 'ZF'
			Aadd(aColsEx, {  "01", space(TamSx3("ZF_ELEMEN")[1]), space(TamSx3("ZF_DESCRI")[1]), space(TamSx3("ZF_FORMUL")[1]), space(TamSx3("ZF_COMPAR")[1]), space(TamSx3("ZF_LIMEXC")[1]), .f. })
		else
			if lSItem
				Aadd(aColsEx, {  strzero(1,nTamItem), ' ', .f. })
			else
				Aadd(aColsEx, {  '001' ,strzero(1,nTamItem), ' ', .f. })
			endif
		endif
	endif

	DEFINE MSDIALOG oDlgB TITLE cDescrTab FROM 400, 300 TO 700, 900*nPerc COLORS 0, 16777215 PIXEL
	//lin,col lin,col                                 Val da linha   Val todas linhas                                           Val coluna             Val exclusao linha
	oBrw:= MsNewGetDados():New( 001,001,150,(250*nPerc)+iif(nperc>1,80,0), GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", cSequen, aColsEd,1, 99, "AllwaysTrue"     , "", "AllwaysTrue", oDlgB, aCabec, aColsEx)
	oBrw:SetArray(aColsEx,.T.)
	oBrw:Refresh()

	@ 025, (260*nPerc)+iif(nperc>1,80,0) BUTTON oButton1 PROMPT "Fechar" SIZE 037, 012 action oDlgB:End() OF oDlgB PIXEL
	@ 040, (260*nPerc)+iif(nperc>1,80,0) BUTTON oButton2 PROMPT "Confirmar" SIZE 037, 012 action iif(fazAba(oBrw:aCols,cTabela,lSItem),oDlgB:End(),.f.) OF oDlgB PIXEL

	ACTIVATE MSDIALOG oDlgB //CENTERED

return nil

Static Function fazAba(aCols,cTabela,lSItem)

	Local nId := 0

	for nId := 1 to len(aCols)
		if lSItem
			nCol := 1
		else
			nCol := 2
		endif
		if !aCols[nId,len(aCols[nId])]

			if cTabela == 'ZF'
				//.and. !aCols[nId,nCol+2] $ '.F.|.T.'
				//msginfo("Problema preenchimento do campo Valor? Somente pode ser preenchido com .F. ou .T.")
				//return .f.
			else
				if empty(aCols[nId,nCol]) .or. empty(aCols[nId,nCol+1])
					msginfo("Problema preenchimento de campos")
					return .f.
				endif
			endif

		else
			cSql := ""
			if cTabSX5 $ "TR"  // SZT = Tabela elementos químicos da norma tecnica
				cSql := "select * from "+RetSQLName("SZT")+" zt "
				cSql += "where zt_filial = '"+xFilial("SZT")+"' and zt_idnorma >= ' ' and zt_simbolo = '"+aCols[nId,nCol]+"' zt.d_e_l_e_t_ = ' '"
			Elseif cTabSX5 $ "ZF"   // SZU = Tabela critérios de avaliação da composição química da Norma Técnica -> SX5 ZF
				cSql := "select * from "+RetSQLName("SZU")+" zu "
				cSql += "where zu_filial = '"+xFilial("SZU")+"' and zu_idnorma >= ' ' and zu_elemen = '"+aCols[nId,2]+" and zu_sequen = '"+aCols[nId,1]+"' and zu.d_e_l_e_t_ = ' '"
			Elseif cTabSX5 $ "TX|PM|TO|SU"  //SZE = Várias => TX-TRATAMENTO TERMICO|PM-MATERIAL DE PARTIDA|TO-CORPO DE PROVA TIPO|SU-CORPO DE PROVA SENTIDO
				cSql := "select * from "+RetSQLName("SZE")+" ze "
				cSql += "where ze_filial = '"+xFilial("SZE")+"' and ze_idnorma >= ' ' and ze_tabsx5 = '"+cTabSX5+"' and ze_item = '"+aCols[nId,nCol]+"' ze.d_e_l_e_t_ = ' '"
			endif
			if !empty(cSql)
				cSql := ChangeQuery( cSql )
				cTrb := GetNextAlias()
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
				if !(ctrb)->( Eof() )
					msginfo("Este item não pode ser excluido pois já foi utilizado !")
					return .f.
				endif
				(ctrb)->( DbCloseArea() )
			endif
		endif
	Next

	for nId := 1 to len(aCols)

		if cTabela == 'ZF'
			if szf->( dbseek( xFilial("SZF")+aCols[nId,2]+aCols[nId,1] ) )
				szf->(RecLock("SZF",.f.))
				if !aCols[nId,len(aCols[nId])]
					SZF->ZF_DESCRI := aCols[nId,3]
					SZF->ZF_FORMUL := aCols[nId,4]
					SZF->ZF_COMPAR := aCols[nId,5]
					SZF->ZF_LIMEXC := aCols[nId,6]
				else
					szf->(DbDelete())
				endif
			elseif !aCols[nId,len(aCols[nId])]
				szf->(RecLock("SZF",.t.))
				SZF->ZF_FILIAL := xFilial("SZF")
				SZF->ZF_ELEMEN := aCols[nId,2]
				SZF->ZF_SEQUEN := aCols[nId,1]
				SZF->ZF_DESCRI := aCols[nId,3]
				SZF->ZF_FORMUL := aCols[nId,4]
				SZF->ZF_COMPAR := aCols[nId,5]
				SZF->ZF_LIMEXC := aCols[nId,6]
			endif
			szf->(MsUnLock())
		else
			if lSItem
				nCol := 1
			else
				nCol := 2
			endif
			if sx5->(dbseek(xFilial("SX5")+cTabela+aCols[nId,nCol]))
				SX5->(RecLock("SX5",.f.))
				if !aCols[nId,len(aCols[nId])]
					SX5->X5_DESCRI := aCols[nId,nCol+1]
				else
					SX5->(DbDelete())
				endif
			elseif !aCols[nId,len(aCols[nId])]
				SX5->(RecLock("SX5",.t.))
				SX5->X5_FILIAL := xFilial("SX5")
				SX5->X5_TABELA := cTabela
				SX5->X5_CHAVE := aCols[nId,nCol]
				SX5->X5_DESCRI := aCols[nId,nCol+1]
			endif
			SX5->(MsUnLock())
		endif
	Next

return(.T.)
