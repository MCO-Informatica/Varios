#include "topconn.ch"

User Function PMSG003()

If Altera
    If MsgYesNo("Confirma Atualização na Unidade de Medida do Produto?","Confirma")

        M->AF3_UM  := Posicione("SB1",1,xFilial("SB1")+aCols[n,2],"B1_UM")                                             

    EndIf
EndIf

Return M->AF3_UM
