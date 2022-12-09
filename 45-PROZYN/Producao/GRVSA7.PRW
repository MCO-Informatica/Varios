
User Function GRVSA7()

If SELECT("QryZA7")>0 
DbSelectArea("QryZA7")
DbCloseArea()
EndIF             

cQry := " SELECT * FROM ZA7010 Where D_E_L_E_T_ =''"
 
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),"QryZA7", .F., .T.)            

QryZA7->(DbGoTop()) 

DbSelectArea("SA7")
DbSetOrder(1)                         


While !QryZA7->(EOF()) 

If DbSeek(xFilial("SA7") + QryZA7->ZA7_CLIENT + QryZA7->ZA7_LOJA + QryZA7->ZA7_PRODUT)   
RecLock("SA7",.F.)
SA7->A7_XSEGMEN := QryZA7->ZA7_XSEGM 
msUnlock() 
EndIf          
                      

QryZA7->(DbSkip())    

EnDDo
 

AVISO("Termino", "Atualizaçao Finalizada", { "OK" }, 1)      

Return .T.