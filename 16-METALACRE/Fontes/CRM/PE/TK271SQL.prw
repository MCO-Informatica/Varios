#include 'protheus.ch'
#include 'parmtype.ch'

User Function TK271SQL()
Local _cAlias  := ParamIxb[1]
Local _cFiltro := ""

If _cAlias == "SUA"
	If SA3->(dbSetOrder(7), dbSeek(xFilial("SA3")+__cUserID)) .And. SA3->A3_TIPO == 'E'	// Representantes
		_cFiltro := "UA_VEND == '" + SA3->A3_COD + "' "
	Endif
           
	//_cFiltro := "UA_CLIENTE = '111111' AND UA_OPERADO = '000004'"     //Expressão SQL
EndIf

Return _cFiltro
