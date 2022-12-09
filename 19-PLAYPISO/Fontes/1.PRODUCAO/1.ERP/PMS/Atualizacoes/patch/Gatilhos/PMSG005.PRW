#include "topconn.ch"

User Function PMSG005()

If Altera
    If MsgYesNo("Confirma Atualização no Tipo de Produto?","Confirma")

        M->AF3_TIPO    := Posicione("SB1",1,xFilial("SB1")+aCols[n,2],"B1_TIPO")                                             

    EndIf
EndIf

Return M->AF3_TIPO  
