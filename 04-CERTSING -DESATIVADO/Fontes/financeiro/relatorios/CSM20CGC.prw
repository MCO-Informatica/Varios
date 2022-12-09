#Include 'Protheus.ch'

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSM10CGC |Autor: |David Alves dos Santos |Data: |27/08/2016   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Rotina de impotação de arquivo CSV.                           |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSM20CGC()
	
	Local cQuery   := ""
	Local cPfxCNPJ := ""
	Local cTmp     := GetNextAlias()
	Local cLoja    := ""
	Local cCodFor  := ""

	If !Empty(M->A2_CGC)
		cPfxCNPJ := SubStr(xSoNum(M->A2_CGC),1,8) + "%"
	
		cQuery := " SELECT * " 
		cQuery += " FROM   " + RetSqlName("SA2") + " " 
		cQuery += " WHERE  A2_FILIAL = '" + xFilial("SA2") + "' " 
		cQuery += "       AND A2_TIPO = 'J' " 
		cQuery += "       AND A2_CGC LIKE '" + cPfxCNPJ + "' " 
		cQuery += "       AND D_E_L_E_T_ = ' ' " 
	
		//-- Execucao da query.
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.F.,.T.)
	
		cCodFor := (cTmp)->A2_COD
	
		While (cTmp)->(!Eof())
			cLoja := (cTmp)->A2_LOJA
			(cTmp)->(dbSkip())
		EndDo	
	
		If !Empty(cLoja)
			If MsgYesNo( "Existe um fornecedor utilizando o mesmo prefixo de CNPJ." + CRLF + "PREFIXO: <b>" + SubStr(cPfxCNPJ,1,8) + "</b>" + CRLF + CRLF + ;
		             	 "Deseja utilizar o mesmo código deste fornecedor ?", "CSM20CGC" )
				M->A2_COD  := cCodFor
				M->A2_LOJA := Soma1(cLoja)
			EndIf
		EndIf

	EndIf
	
Return( .T. )

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |xSoNum   |Autor: |David Alves dos Santos |Data: |27/08/2016   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Tratamento do CNPJ.                                           |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function xSoNum( cVar )
    
   //-- Criação de variáveis.
    Local nI       := 0
    Local cAux     := ""
    Local cNumeros := "0123456789"

    //+---------------------------------------------+
    //| Varrer toda a variável e considerar somente | 
    //| o conteúdo contido na variável cNumeros     |
    //+---------------------------------------------+
    For nI := 1 To Len( cVar )
        If SubStr( cVar, nI, 1 ) $ cNumeros    
            cAux += SubStr( cVar, nI, 1 )
        Endif
    Next nI

Return( cAux )