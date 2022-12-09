#Include 'Protheus.ch'
//---------------------------------------------------------------------------------
// Rotina | CSC5XBOX    | Autor | Rafael Beghini     | Data | 05.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina genérica para retornar as opções do campo da tabela SC5
//        | Chamada está sendo feita no campo na coluna X3_CBOX 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSC5XBOX(cTabela)
	Local cRET	:= ''
	Local cSQL	:= ''
	Local cTRB	:= ''
	Local aArea	:= GetArea()

	Default cTabela := 'Z4'
	
	IF Empty(cTabela)
		Return(cRET)
	EndIF

	cSQL += "SELECT X5_CHAVE," + CRLF
	cSQL += "       X5_DESCRI" + CRLF
	cSQL += "FROM " + RetSqlName('SX5') + " X5 " + CRLF
	cSQL += "WHERE  X5.D_E_L_E_T_ = ' '" + CRLF
	cSQL += "       AND X5_TABELA = '" + cTabela + "' " + CRLF
	cSQL += "ORDER  BY R_E_C_N_O_  " + CRLF
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
	
	IF .NOT. (cTRB)->( EOF() ) 
		While .NOT. (cTRB)->( EOF() )
			cRET += Alltrim( (cTRB)->X5_CHAVE ) + '=' + Alltrim( (cTRB)->X5_DESCRI ) + ';'
			(cTRB)->( dbSkip() )
		End
		cRET := SubString( cRet, 1, Len(cRet) - 1 )
	EndIF
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	RestArea( aArea )
	
Return(cRET)