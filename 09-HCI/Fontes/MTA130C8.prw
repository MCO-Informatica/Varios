#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MTA130C8
Rotina para preenchimento de campo especifico C8_XCOST

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		24/08/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
User Function MTA130C8()

	Private _nCost   := 0
	
	If SC8->(FieldPos("C8_XCOST")) != 0
	
		_nCost := _fGetCost()
		
		If _nCost == 0 //SC8->C8_XCOST == 0
			@ 067,020 To 169,312 Dialog _oDlgOrc Title OemToAnsi("R$ Orçado")
				@ 015,005 Say OemToAnsi("Informe o Cost do orçamento ?") Size 80,8
				@ 015,089 Get _nCost Valid _nCost > 0 Picture PesqPict("SC8","C8_XCOST") Size 50,10 
				@ 037,106 BmpButton Type 1 Action (fOK(),Close(_oDlgOrc))
				@ 037,055 BmpButton Type 2 Action Close(_oDlgOrc)
			Activate Dialog _oDlgOrc CENTERED
		Else
			If RecLock("SC8",.F.)
				SC8->C8_XCOST	:= _nCost
				SC8->(MsUnLock())
			EndIf
			fOK()
		EndIf
	EndIF

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} fOK
Função para gravar o valor do Cost e Saving da cotação.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		24/08/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function fOK()

	Local _nCMenor	:= _fGetMC()
	Local _nSaving	:= Iif(_nCMenor>0,((_nCMenor-_nCost)/_nCMenor)*100,0)

	If RecLock("SC8",.F.)
		SC8->C8_XCOST	:= _nCost
		If _nSaving > 0
			SC8->C8_XSAVING	:= _nSaving
		EndIf
		SC8->(MsUnLock())
	EndIf

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

	_cQuery := " SELECT SUM(C8_TOTAL) AS VALOR FROM " + RetSqlName("SC8") + " WHERE C8_FILIAL = '" + xFilial("SC8") + "' AND C8_NUM = '" + SC8->C8_NUM + "' AND D_E_L_E_T_ = ' '
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