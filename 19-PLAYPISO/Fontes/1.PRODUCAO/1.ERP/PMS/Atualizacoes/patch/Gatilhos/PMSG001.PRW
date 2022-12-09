#include "topconn.ch"

User Function PMSG001()

If Altera
    If MsgYesNo("Confirma Alteração no Valor do Cust. Stand?","Confirma")

        M->AF3_CUSTD  := Posicione("SB1",1,xFilial("SB1")+aCols[n,2],"B1_CUSTD") 

    EndIf
EndIf    

Return M->AF3_CUSTD
