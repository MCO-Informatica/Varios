User Function ACD100VG()
Local lRet := .T.// Customiza��o de usu�rio

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
If SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO))
    If SC5->C5_XBLQFIN == 'B'
        MsgAlert("Pedido com bloqueio financeiro!","Aten��o!")
        lRet := .F.
    EndIf
    If SC5->C5_XBLQMRG == 'S'
        MsgAlert("Pedido com bloqueio de margem!","Aten��o!")
        lRet := .F.
    EndIf
    // If SC5->C5_XBLQMIN == 'S'
    //     MsgAlert("Pedido com bloqueio de pre�o m�nimo!","Aten��o!")
    //     lRet := .F.
    // EndIf
EndIf

Return lRet
