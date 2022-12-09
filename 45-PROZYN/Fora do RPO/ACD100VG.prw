User Function ACD100VG()
Local lRet := .T.// Customização de usuário

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
If SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO))
    If SC5->C5_XBLQFIN == 'B'
        MsgAlert("Pedido com bloqueio financeiro!","Atenção!")
        lRet := .F.
    EndIf
    If SC5->C5_XBLQMRG == 'S'
        MsgAlert("Pedido com bloqueio de margem!","Atenção!")
        lRet := .F.
    EndIf
    // If SC5->C5_XBLQMIN == 'S'
    //     MsgAlert("Pedido com bloqueio de preço mínimo!","Atenção!")
    //     lRet := .F.
    // EndIf
EndIf

Return lRet
