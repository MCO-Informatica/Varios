User Function PMSG002()

If Altera
    If MsgYesNo("Confirma Atualização na Descrição do Produto?","Confirma")
        M->AF3_DESCRI  := Posicione("SB1",1,xFilial("SB1")+aCols[n,2],"B1_DESC")                                             
    Else
         M->AF3_DESCRI :=  aCols[n,4]           
    EndIf
EndIf

Return M->AF3_DESCRI
