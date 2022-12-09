#Include "Protheus.ch"
#Include "TopConn.ch"


User Function VincPrin(lCod)
	Local cSql := ""
	Local cRet := ""

	Default lCod := .T.

	cSql := "SELECT * FROM "+RetSqlName("SZ0")+" SZ0 WHERE SZ0.Z0_CLIENTE = '"+SA1->(A1_COD+A1_LOJA)+"' AND SZ0.D_E_L_E_T_<> '*' ORDER BY SZ0.Z0_COD "

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	TCQuery ChangeQuery(cSql) New Alias "QRY"

	If !Empty(QRY->Z0_COD)
		If lCod
			cRet := QRY->Z0_COD
		Else
			cRet := QRY->Z0_NOME
		EndIF
	EndIf

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

Return cRet
