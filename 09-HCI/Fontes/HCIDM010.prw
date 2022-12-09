#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"

User Function HCIDM010(_cOpc)

	Local _cFiltro	:= ""
	Local _cCodCli	:= ""
	Local _aFiltro	:= {}
	
	Do Case
		Case UPPER(ALLTRIM(_cOpc)) == "CLIENTE"
			_cFiltro 	:= _fGCCAC8(1)
		Case UPPER(ALLTRIM(_cOpc)) == "PEDIDO"
			_cFiltro 	:= _fGCCAC8(2)
		Case UPPER(ALLTRIM(_cOpc)) == "PRECLI"
			_cFiltro 	:= _fGCCAC8(3)
		Case UPPER(ALLTRIM(_cOpc)) == "SUSPEC"
			_aFiltro 	:= _fGCCAC8(4)
			Return(_aFiltro)
		Case UPPER(ALLTRIM(_cOpc)) == "PROSP"
			_cFiltro 	:= _fGCCAC8(5)
		Case UPPER(ALLTRIM(_cOpc)) == "FILTRO"
			_cFiltro 	:= _fGCCAC8(6)
		Case UPPER(ALLTRIM(_cOpc)) == "FOLLOW"
			_cFiltro 	:= _fGCCAC8(7)
	EndCase

Return(_cFiltro)

Static Function _fGCCAC8(_nOpc)
	
	Local _cRet			:= ""
	Local _cQuery		:= ""
	Local _cAliasSA3	:= GetNextAlias()
	Local _cAliasSU5	:= GetNextAlias()
	Local _cAliasAC8	:= GetNextAlias()
	Local _cAliasSA1	:= ""
	Local _cSA3COD		:= ""
	Local _cSU5COD		:= ""
	
	If _nOpc == 7
	
   		_cQuery	:= "SELECT DISTINCT AC8_CODCON "
		_cQuery += " FROM " + RetSqlName("AC8")
		_cQuery += " WHERE AC8_FILIAL = '" + xFilial("AC8") + "' "
		_cQuery += " AND AC8_ENTIDA = 'SA1' "
		_cQuery += " AND AC8_CODENT = '" + M->ZQ_CLIENTE + M->ZQ_LOJA + "'"
		_cQuery += " AND D_E_L_E_T_ = ' ' "
		_cQuery += " ORDER BY AC8_CODCON "
		TCQUERY _cQuery NEW ALIAS &(_cAliasAC8)
		
		If (_cAliasAC8)->(!EOF())
			While (_cAliasAC8)->(!EOF())
				_cRet	+= "'" + ALLTRIM((_cAliasAC8)->AC8_CODCON) + "',"
				(_cAliasAC8)->(dbSkip())
			EndDo
		EndIf
		(_cAliasAC8)->(dbCloseArea())

		If !Empty(_cRet) 
			_cRet	:= SUBSTRING(_cRet,1,LEN(_cRet)-1)
		EndIf

	Else
		_cQuery	:= "SELECT DISTINCT A3_COD "
		_cQuery += " FROM " + RetSqlName("SA3")
		_cQuery += " WHERE A3_FILIAL = '" + xFilial("SA3") + "' "
		_cQuery += " AND A3_CODUSR = '" + __cUserID + "'"
		_cQuery += " AND A3_MSBLQL <> '1' "
		_cQuery += " AND D_E_L_E_T_ = ' ' "
		_cQuery += " ORDER BY A3_COD "
		TCQUERY _cQuery NEW ALIAS &(_cAliasSA3)
		
		If (_cAliasSA3)->(!EOF())
			While (_cAliasSA3)->(!EOF())
				_cSA3COD	+= "'" + ALLTRIM((_cAliasSA3)->A3_COD) + "',"
				(_cAliasSA3)->(dbSkip())
			EndDo	
		EndIf
		(_cAliasSA3)->(dbCloseArea())
		
		If !Empty(_cSA3COD)	
			_cQuery	:= "SELECT DISTINCT U5_CODCONT "
			_cQuery += " FROM " + RetSqlName("SU5")
			_cQuery += " WHERE U5_FILIAL = '" + xFilial("SU5") + "' "
			_cQuery += " AND U5_VEND IN (" + SUBSTR(_cSA3COD,1,LEN(_cSA3COD)-1) + ")"
			_cQuery += " AND D_E_L_E_T_ = ' ' "
			_cQuery += " ORDER BY U5_CODCONT "
			TCQUERY _cQuery NEW ALIAS &(_cAliasSU5)
			
			If (_cAliasSU5)->(!EOF())
				While (_cAliasSU5)->(!EOF())
					_cSU5COD	+= "'" + ALLTRIM((_cAliasSU5)->U5_CODCONT) + "',"
					(_cAliasSU5)->(dbSkip())
				EndDo	
			EndIf		
			(_cAliasSU5)->(dbCloseArea())
		EndIf
		
		If _nOpc == 3
			_cRet	:= _cSU5COD
		Else
			If !Empty(_cSU5COD)
				_cQuery	:= "SELECT DISTINCT AC8_CODENT "
				_cQuery += " FROM " + RetSqlName("AC8")
				_cQuery += " WHERE AC8_FILIAL = '" + xFilial("AC8") + "' "
				If _nOpc == 4 
					_cQuery += " AND AC8_ENTIDA = 'ACH' "
				Else
					_cQuery += " AND AC8_ENTIDA = 'SA1' "
				EndIf
				_cQuery += " AND AC8_CODCON IN (" + SUBSTR(_cSU5COD,1,LEN(_cSU5COD)-1) + ")"
				_cQuery += " AND D_E_L_E_T_ = ' ' "
				_cQuery += " ORDER BY AC8_CODENT "
				TCQUERY _cQuery NEW ALIAS &(_cAliasAC8)
				
				If (_cAliasAC8)->(!EOF())
					While (_cAliasAC8)->(!EOF())
						If _nOpc == 6
							_cRet	+= ALLTRIM((_cAliasAC8)->AC8_CODENT) + "|"
						Else
							_cRet	+= "'" + ALLTRIM((_cAliasAC8)->AC8_CODENT) + "',"
						EndIf
						(_cAliasAC8)->(dbSkip())
					EndDo	
				EndIf
				(_cAliasAC8)->(dbCloseArea())
			EndIf
		EndIf
	
		If !Empty(_cRet) 
			_cRet	:= SUBSTRING(_cRet,1,LEN(_cRet)-1)
		EndIf
		
		If _nOpc == 4
			Return({_cSA3COD,_cRet})
		ElseIf _nOpc == 5
			If !Empty(_cRet)
				_cAliasSA1	:= GetNextAlias()
				
				_cQuery	:= "SELECT DISTINCT A1_CGC "
				_cQuery += " FROM " + RetSqlName("SA1")
				_cQuery += " WHERE A1_FILIAL = '" + xFilial("SA1") + "' "
				_cQuery += " AND A1_COD||A1_LOJA IN (" + _cRet + ")"
				_cQuery += " AND D_E_L_E_T_ = ' ' "
				_cQuery += " ORDER BY A1_CGC "
				TCQUERY _cQuery NEW ALIAS &(_cAliasSA1)
		
				_cRet	:= ""
		
				If (_cAliasSA1)->(!EOF())
					While (_cAliasSA1)->(!EOF())
						_cRet	+= "'" + ALLTRIM((_cAliasSA1)->A1_CGC) + "',"
						(_cAliasSA1)->(dbSkip())
					EndDo
					_cRet	:= SUBSTRING(_cRet,1,LEN(_cRet)-1)
				EndIF
				(_cAliasSA1)->(dbCloseArea())
			EndIf
			
		EndIf
	EndIf
	If _nOpc == 2
	   If !Empty(_cSA3COD)
	   	   _cRet:=SUBSTR(_cSA3COD,1,LEN(_cSA3COD)-1)
	   	Else
	   		_cRet = ""
	   	EndIf
	ENDIF  
Return(_cRet)

User Function _fVldECont(_cCGC)

	Local _cQuery	:= ""
	Local _cAliasUS	:= GetNextAlias()
	Local _cAliasA1	:= GetNextAlias()
	Local _cMsgA1	:= ""
	Local _cMsgUS	:= ""	
	Local _aArea	:= GetArea()
	
	_cQuery	:= "SELECT A1_NOME "
	_cQuery	+= " FROM " + RetSqlName("SA1")
	_cQuery	+= " WHERE A1_FILIAL = '" + xFilial("SA1") + "' "
	_cQuery	+= " AND A1_CGC = '" + _cCGC + "' "
	_cQuery	+= " AND D_E_L_E_T_ = '' "
	TcQuery _cQuery New Alias &(_cAliasA1)
	
	If (_cAliasA1)->(!EOF())
		While (_cAliasA1)->(!EOF())
			_cMsgA1	+= (_cAliasA1)->A1_NOME + CRLF
			(_cAliasA1)->(dbSkip())
		EndDo
	EndIF
	
	_cQuery	:= "SELECT US_NOME "
	_cQuery	+= " FROM " + RetSqlName("SUS")
	_cQuery	+= " WHERE US_FILIAL = '" + xFilial("SUS") + "' "
	_cQuery	+= " AND US_CGC = '" + _cCGC + "' "
	_cQuery	+= " AND D_E_L_E_T_ = '' "
	TcQuery _cQuery New Alias &(_cAliasUS)
	
	If (_cAliasUS)->(!EOF())
		While (_cAliasUS)->(!EOF())
			_cMsgUS	+= (_cAliasUS)->US_NOME + CRLF
			(_cAliasUS)->(dbSkip())
		EndDo
	EndIF
	
	If !Empty(_cMsgA1) .Or. !Empty(_cMsgUS)
		Aviso(OEMTOANSI("Atenção"),"Existem Clientes/Prospects cadastrados com esse CNPJ " + CRLF +;
									Iif(!Empty(_cMsgA1),("Clientes (SA1):" + CRLF + _cMsgA1),"") +;
									Iif(!Empty(_cMsgUS),("Prospects (SU5):" + CRLF + _cMsgUS),"") ,{"Ok"},3)
	EndIf
	
	RestArea(_aArea)

Return(.T.)