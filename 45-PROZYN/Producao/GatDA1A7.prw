

User Function GetDa1A7()
    Local aArea := GetArea()
    Local lRet := .T.

    DbSelectArea("DA0")
    DA0->(DbSetOrder(1))
    If !DA0->(DbSeek(xFilial("DA0")+aCols[1,4]))
        return .T.
    EndIf
   
    
    DbSelectArea("SA7")
    SA7->(DbSetOrder(2))
    If !SA7->(DbSeek(xFilial("SA7")+M->DA1_CODPRO+DA0->DA0_YCODCL+DA0->DA0_YLJCLI))
        MsgAlert("Produto não encontrado na amarração Produto X Cliente.","Atenção!")
        lRet := .F.
    EndIf

    RestArea(aArea)

Return lRet
