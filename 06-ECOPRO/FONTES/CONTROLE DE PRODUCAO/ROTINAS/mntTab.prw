#Include 'Protheus.ch'

User Function mntTab()		//Manutenção de tabelas (SX5)

	Local oBrowse
	Local aBrowse := {}
	Private oDlgA

				//Tab ,Descrição                     ,Tamanho campo x5_chave , se soma item
	Aadd(aBrowse,{'TR','CÓDIGOS DE RETRABALHO',TamSx3("Z1_CODRET")[1],.t.})

	DEFINE MSDIALOG oDlgA TITLE "Mnt de Tabelas (SX5)" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

	@ 000, 000 LISTBOX oBrowse Fields HEADER "Tabela","Descrição" SIZE 200, 150 OF oDlgA PIXEL ColSizes 30,50
	oBrowse:SetArray(aBrowse)
	oBrowse:bLine := {|| {;
		aBrowse[oBrowse:nAt,1],;
		aBrowse[oBrowse:nAt,2];
		}}
	//oBrowse:Align := CONTROL_ALIGN_TOP
	//oBrowse:Align := CONTROL_ALIGN_BOTTOM

	@ 010, 210 BUTTON oButton1 PROMPT "Manutenção" SIZE 037, 012 action u_MntSX5(aBrowse[oBrowse:nAt,1],aBrowse[oBrowse:nAt,2],aBrowse[oBrowse:nAt,3],aBrowse[oBrowse:nAt,4]) OF oDlgA PIXEL
	@ 030, 210 BUTTON oButton2 PROMPT "Fechar"     SIZE 037, 012 action oDlgA:End() OF oDlgA PIXEL
	ACTIVATE MSDIALOG oDlgA CENTERED

Return Nil


User Function mntSX5(cTabela,cDescrTab,nTamItem,lSItem)  // tabela SX5, descrição tab,Tamanho do x5_chave, se soma itens

	Local nId := 0
	Private aCabec := {}
	Private aColsEd := {}
	Private aColsEx := {}

	if lSItem
		Aadd(aCabec, {"Item"     ,"X5_CHAVE"   ,"@!",          nTamItem, 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	endif
	Aadd(aCabec, {"Descrição","X5_DESCRI","@!", TamSx3("X5_DESCRI")[1], 0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	if lSItem
		aColsEd := {"X5_DESCRI"}
	endif

	cSql := "select * from "+RetSQLName("SX5")+" x5 where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = '"+cTabela+"' and x5.d_e_l_e_t_ = ' '"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		nId += 1
		if lSItem
			Aadd(aColsEx, {  substr((ctrb)->x5_chave,1,nTamItem), (ctrb)->x5_descri, .f. })
		endif
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

	if len(aColsEx) == 0
		if lSItem
			Aadd(aColsEx, {  strzero(1,nTamItem), ' ', .f. })
		endif
	endif

	DEFINE MSDIALOG oDlgB TITLE cDescrTab FROM 400, 300 TO 700, 900 COLORS 0, 16777215 PIXEL
	//lin,col lin,col                                 Val da linha   Val todas linhas                                           Val coluna             Val exclusao linha
	oBrw:= MsNewGetDados():New( 001,001,150,250, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+X5_CHAVE", aColsEd,1, 99, "AllwaysTrue"     , "", "AllwaysTrue", oDlgB, aCabec, aColsEx)
	oBrw:SetArray(aColsEx,.t.)
	oBrw:Refresh()

	@ 025, 260 BUTTON oButton1 PROMPT "Fechar" SIZE 037, 012 action oDlgB:End() OF oDlgB PIXEL
	@ 040, 260 BUTTON oButton2 PROMPT "Confirmar" SIZE 037, 012 action iif(fazMnt(oBrw:aCols,cTabela,lSItem),oDlgB:End(),.f.) OF oDlgB PIXEL

	ACTIVATE MSDIALOG oDlgB //CENTERED

return nil

Static Function fazMnt(aCols,cTabela,lSItem)

	Local nId := 0

	for nId := 1 to len(aCols)
		if lSItem
			nCol := 1
		endif
		if !aCols[nId,len(aCols[nId])]
			if empty(aCols[nId,nCol]) .or. empty(aCols[nId,nCol+1])
				msginfo("Problema preenchimento de campos")
				return .f.
			endif
		else
			cSql := ""
			if cTabela $ "TR"
				cSql := "select * from "+RetSQLName("SZ1")+" z1 "
				cSql += "where z1_filial = '"+xFilial("SZ1")+"' and z1_numop >= ' ' and z1_codret = '"+aCols[nId,nCol]+"' and z1.d_e_l_e_t_ = ' '"
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
		if lSItem
			nCol := 1
		endif
		if sx5->(dbseek(xFilial()+cTabela+aCols[nId,nCol]))
			SX5->(RecLock("SX5",.f.))
			if !aCols[nId,len(aCols[nId])]
				SX5->X5_DESCRI := aCols[nId,nCol+1]
			else
				SX5->(DbDelete())
			endif
		else
			SX5->(RecLock("SX5",.t.))
			SX5->X5_FILIAL := xFilial("SX5")
			SX5->X5_TABELA := cTabela
			SX5->X5_CHAVE  := aCols[nId,nCol]
			SX5->X5_DESCRI := aCols[nId,nCol+1]
		endif
		SX5->(MsUnLock())
	Next

return(.t.)
