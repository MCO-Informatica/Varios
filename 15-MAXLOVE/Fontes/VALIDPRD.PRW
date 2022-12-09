#Include "TopConn.ch"
#Include "Protheus.ch"


User Function VALIDPRD()
	Local cSql 	:= ""
	_cTab       := "NF"


	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+CA120FORN+CA120LOJ,.f.))

	If SA2->A2_X_TABPR$"S"

		/*	dbSelectArea("AIA")
		dbSetOrder(1)
		If dbSeek(xFilial("AIA")+CA120FORN+CA120LOJ+"VL",.f.)
		
		If !AIA->AIA_X_APRO$"S"*/

		cSql := "SELECT * FROM "+RetSqlName("AIB")+" AIB WHERE AIB.D_E_L_E_T_=' ' AND AIB.AIB_CODFOR = '"+CA120FORN+"' AND AIB.AIB_LOJFOR = '"+CA120LOJ+"' AND AIB.AIB_CODPRO = '"+M->C7_PRODUTO+"' "
		
		If Select("QRY") > 0
			QRY->(DbCloseArea())
		EndIf

		TCQuery cSql New Alias "QRY"

		If Empty(QRY->AIB_XSTATS) .OR. QRY->AIB_XSTATS <> "S" 

		MsgAlert("Tabela de preço não aprovada pela diretoria. Não será permitido digitar o pedido de compra.")
		_cTab	:=	" "

		EndIf

		If Select("QRY") > 0
			QRY->(DbCloseArea())
		EndIf	
	
	Else

	MsgAlert("Fornecedor não controlado por tabela de preços")
	_cTab := " "

EndIf


Return(_cTab)
