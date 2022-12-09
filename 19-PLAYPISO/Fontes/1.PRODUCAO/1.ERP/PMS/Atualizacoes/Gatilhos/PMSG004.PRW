#include "topconn.ch"

User Function PMSG004()

If Altera
    If MsgYesNo("Confirma Atualização na Segunda Unidade de Medida do Produto?","Confirma")

        M->AF3_SEGUM   := Posicione("SB1",1,xFilial("SB1")+aCols[n,2],"B1_SEGUM")                                             

    EndIf
EndIf

Return M->AF3_SEGUM 
