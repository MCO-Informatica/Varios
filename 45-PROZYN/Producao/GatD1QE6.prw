User Function GatD1Qe6()
    cRet := M->D1_COD

    If SB1->B1_TIPOCQ == 'Q'
        DbSelectArea("QE6")
        QE6->(DbSetOrder(1))
        If !QE6->(DbSeek(xFilial("QE6")+SB1->B1_COD))
            MsgAlert("Produto sem inspeção de entrada. Favor entrar em contato com o setor da Qualidade.","Atenção!")
            cRet := ""
        EndIf
    EndIf
Return cRet
