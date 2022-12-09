#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

User Function AfterLogin()
Local cSql := ""

cSql := "UPDATE "+RetSqlName("SCJ")+ " SCJ SET CJ_STATUS = 'C' WHERE CAST(CJ_EMISSAO AS DATE) < GETDATE()+"+GetMv("MV_DTLIMIT")+" AND SCJ.D_E_L_E_T_=' ' AND CJ_STATUS = 'A' " 
 TcSqlExec(cSql)
   
Return
