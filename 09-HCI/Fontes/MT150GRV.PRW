#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT150GRV
Rotina para preenchimento de campo especifico C8_XCOST

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		24/08/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
User Function MT150GRV()

	Local _nCost	:= 0
	Local _nCMenor	:= 0
	Local _nSaving	:= 0
	Local _cObs		:= AllTRim(SC8->C8_XOBSCOT) //AllTRim(MSMM(SC8->C8_XOBS))
	Local _cQuery	:= ""
	Local _oDlgOrc	:= Nil
	Local nOk		:= 0
    
    If SC8->(FieldPos("C8_XCOST")) != 0
	    _nCost   	:= _fGetCost()
		_nCMenor	:= _fGetMC()
		_nSaving	:= Iif(_nCMenor>0,((_nCMenor-_nCost)/_nCMenor)*100,0)

/*		If _nSaving <> 0
			If RecLock("SC8",.F.)
				SC8->C8_XSAVING	:= _nSaving
				SC8->(MsUnLock())
			EndIf
//		EndIf       */
		_cQuery	:= "UPDATE " + RetSqlName("SC8")
		_cQuery	+= " SET C8_XSAVING = " + ALLTRIM(STR(_nSaving))
		_cQuery	+= " WHERE C8_FILIAL = '" + xFilial("SC8") + "'"
		_cQuery	+= " AND C8_NUM	= '" + SC8->C8_NUM + "' "
		If TcSqlExec(_cQuery) >= 0
			DBCOMMIT()
		EndIf
	EndIf
	
	If SC8->(FieldPos("C8_XOBSCOT")) != 0 .And. !_lObsCot 
		nOk := Aviso(OEMTOANSI("Dados complementares"),"Deseja Incluir/Alterar a observação da cotação [" + SC8->C8_NUM + "]?",{"Sim","Nao"},2)
		
		If nOk == 1  // MsgBox("Deseja incluir ou alterar a observação da cotação [" + SC8->C8_NUM + "]?", OEMTOANSI("Dados complementares"), "YESNO")
			@ 067,020 To 269,412 Dialog _oDlgOrc Title OemToAnsi("Dados complementares")
				@ 005,005 Say OemToAnsi("Observação:") Size 80,8
				@ 015,005 Get _cObs MEMO SIZE 189,068  Pixel Of _oDlgOrc 
				@ 087,126 BmpButton Type 1 Action (_fOK(_cObs),Close(_oDlgOrc))
				@ 087,166 BmpButton Type 2 Action (_lObsCot	:= .T.,Close(_oDlgOrc))
			Activate Dialog _oDlgOrc CENTERED
		EndIf
		_lObsCot	:= .T.
	EndIf

Return()

Static Function _fOk(_cObs)

	Local _aArea	:= GetArea()
	Local _cNum		:= SC8->C8_NUM
	
	_lObsCot	:= .T.
	
	dbSelectArea("SC8")
	dbSetOrder(1)
	If SC8->(dbSeek(xFilial("SC8") + _cNum)) //C8_FILIAL+C8_NUM
		While SC8->(!EOF()) .And. SC8->C8_NUM == _cNum
			If Reclock("SC8",.F.)
				SC8->C8_XOBSCOT	:= _cObs
				SC8->(MsUnLock())
			EndIf
			SC8->(DbSkip())
		EndDo 
	EndIF
	
	RestArea(_aArea)

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fGetMC
Função para retorno do menor valor da cotação.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		24/08/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fGetMC()
	
	Local _cQuery	:= ""
	Local _cAliasMC	:= GetNextAlias()
	Local _nValor		:= 0

	_cQuery := " SELECT SUM(C8_TOTAL) AS VALOR, C8_FORNECE, C8_LOJA FROM " + RetSqlName("SC8") + " WHERE C8_FILIAL = '" + xFilial("SC8") + "' AND C8_NUM = '" + SC8->C8_NUM + "' AND D_E_L_E_T_ = ' '
	_cQuery += " GROUP BY C8_FORNECE, C8_LOJA "
	_cQuery += " ORDER BY 1 "
	TcQuery _cQuery New Alias &(_cAliasMC)
	
	If (_cAliasMC)->(!EOF())
		While (_cAliasMC)->(!EOF()) .And. _nValor == 0
			If (_cAliasMC)->VALOR > 0
				_nValor	:= (_cAliasMC)->VALOR
			EndIF
			(_cAliasMC)->(dbSkip())
		Enddo
	EndIf
	
Return(_nValor)

//-------------------------------------------------------------------
/*/{Protheus.doc} _fGetCost
Função para retorno do Cost da cotação.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		24/08/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fGetCost()

	Local _cQuery	:= ""
	Local _cAliasC	:= GetNextAlias()
	Local _nRet		:= 0
	
	_cQuery	:= "SELECT C8_XCOST "
	_cQuery	+= " FROM " + RetSqlName("SC8")
	_cQuery	+= " WHERE C8_FILIAL = '" + xFilial("SC8") + "' "
	_cQuery	+= " AND C8_NUM = '" + SC8->C8_NUM + "' "
	_cQuery += " AND D_E_L_E_T_ = ' '"
	TcQuery _cQuery New Alias &(_cAliasC)
	
	If (_cAliasC)->(!EOf())
		_nRet	:= (_cAliasC)->C8_XCOST
	EndIf

Return(_nRet)