<<<<<<< HEAD
#Include "Protheus.ch"
#Include "TopConn.ch"


User Function RetDesc(cAlias,cChave,cRet)
	Local aArea := GetArea()
	Local cSql := ""

	cSql := "SELECT TB."+cRet+ " RETORNO FROM "+RetSqlName(cAlias)+" TB WHERE "+ cChave + " AND TB.D_E_L_E_T_ <> '*' "
	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	TCQuery ChangeQuery(cSql) New Alias "QRY"

	cRet := QRY->RETORNO

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	RestArea(aArea)

Return cRet
=======
#Include "Protheus.ch"
#Include "TopConn.ch"


User Function RetDesc(cAlias,cChave,cRet)
	Local aArea := GetArea()
	Local cSql := ""

	cSql := "SELECT TB."+cRet+ " RETORNO FROM "+RetSqlName(cAlias)+" TB WHERE "+ cChave + " AND TB.D_E_L_E_T_ <> '*' "
	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	TCQuery ChangeQuery(cSql) New Alias "QRY"

	cRet := QRY->RETORNO

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	RestArea(aArea)

Return cRet
>>>>>>> 7a4c99425ff78b7337f6742b9e88dc093d40a424
