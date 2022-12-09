#include "rwmake.ch"   
#INCLUDE "TOPCONN.CH"    

User Function ProxNum()      



Local aArea        := GetArea()
Local aAreaSUA     := SUA->(GetArea())
Local cCOD             := " "       


     cQuery := "SELECT to_char (MAX(UA_NUMSC5)+1,'000000') UA_NUMSC5 FROM "+ RetSQLName("SUA") +" WHERE"
     cQuery += " D_E_L_E_T_ = '*'"
     TcQuery cQuery Alias TSUA New
     
     cCOD := Alltrim(TSUA->UA_NUMSC5)
     
     TSC5->(dbCloseArea())
     
RestArea(aAreaSUA)
RestArea(aArea)

Return cCOD