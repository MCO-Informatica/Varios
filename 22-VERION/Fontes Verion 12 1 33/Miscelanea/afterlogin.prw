#include "protheus.ch"
#INCLUDE "TOPCONN.CH"


User Function AfterLogin()
	Local cSql:= ""

	cSql := "UPDATE "+RetSqlName("SD7")+" SET D7_QTSEGUM = D7_QTDE, D7_SALDO2 = D7_SALDO WHERE D7_QTSEGUM = 0 "
	TcSqlExec(cSql)

Return
