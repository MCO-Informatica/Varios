#Include 'Protheus.ch'

User Function MT103INC()
	Local aArea := getarea()
	Local lRet  := .t.
	Local cSql  := ""
	Local cTrb  := ""

	if l103Class	//paramixb

		if cA100For == '001900' .and. cLoja == '01' .and. cEspecie == 'NFE  ' .and. cSerie == 'F03' .and. cTipo == 'N'
			cSql := "select d1_item,d1_quant,d1_lotectl,d1_dtvalid,coalesce(z5_qtdleit,0) z5_qtdleit,coalesce(z5_dtconta,' ') z5_dtconta from "+RetSQLName("SD1")+" d1 "
			cSql += "left join "+RetSQLName("SZ5")+" z5 on z5_filial = '"+xFilial("SZ5")+"' and z5_doc = d1_doc and z5_serie = d1_serie and z5_item = d1_item and z5.d_e_l_e_t_ = ' ' "
			cSql += "where d1_filial = '"+xFilial("SD1")+"' and d1_doc = '"+cNFiscal+"' and d1_serie = '"+cSerie+"' and d1_fornece = '"+cA100For+"' and d1_loja = '"+cLoja+"' "
			cSql += "and d1.d_e_l_e_t_ = ' ' order by d1_item"
			cSql := ChangeQuery( cSql )
			cTrb := GetNextAlias()
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),ctrb,.f.,.t.)
			while !(ctrb)->( Eof() )
				if (ctrb)->d1_quant != (ctrb)->z5_qtdleit
					lRet := .f.
				endif
				(ctrb)->( DbSkip() )
			End
			(ctrb)->( DbCloseArea() )
		endif

		if !lRet
			MessageBox("A classificação desta NFE só poderá ser feita após contagem dos produtos desta!","ATENÇÃO", 16)
		endif

	EndIf

	RestArea(aArea)

Return(lRet)
