USER FUNCTION RFATR103()

Local cQuery := ""

cQuery := "SELECT C6_PRODUTO, C6_DESCRI, C6_UM, C6_QTDVEN, COUNT(C6_PRODUTO) AS QTDVEZES "
cQuery += "FROM SC6010 "
cQuery += "WHERE D_E_L_E_T_ = ' ' AND C6_DATFAT BETWEEN '20110701' AND '20120229' "
cQuery += "GROUP BY C6_QTDVEN,C6_PRODUTO, C6_DESCRI, C6_UM "
cQuery += "ORDER BY C6_PRODUTO "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)
MemoWrite("QTDVENDAS.TXT",cQuery)

Return


