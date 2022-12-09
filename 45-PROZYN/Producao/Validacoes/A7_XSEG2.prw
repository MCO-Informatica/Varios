User Function A7_XSEG2()
    Local cSegment := SubStr(M->A7_XSEGMEN,1,1)
    Local cSeg2 := M->A7_XSEG2
    Local lRet := .T.
    Local aArea := GetArea()

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbSeek(xFilial("SB1")+M->A7_PRODUTO))

    DbSelectArea("ZA1")
    ZA1->(DbSetOrder(1))

    If Trim(M->A7_PRODUTO) == '010076'
        If cSeg2 != '0008'
            ZA1->(DbSeek(xFilial("ZA1")+"0008SEG"))
            MsgAlert("Segmentação do produto 010076 deve ser "+ZA1->ZA1_COD+" - "+ZA1->ZA1_DESC+".","Atenção!")
            M->A7_XSEG2 := ZA1->ZA1_COD
            return .F.
        Else
            return .T.
        EndIf
    EndIf

    If !(Trim(SB1->B1_TIPO) $ 'PA;ME')
        If cSeg2 != '0009'
            ZA1->(DbSeek(xFilial("ZA1")+"0009SEG"))
            MsgAlert("Segmentação de produtos do tipo "+Trim(SB1->B1_TIPO)+" deve ser "+ZA1->ZA1_COD+" - "+ZA1->ZA1_DESC+".","Atenção!")
            M->A7_XSEG2 := ZA1->ZA1_COD
            return .F.
        Else
            return .T.
        EndIf
    EndIf

    If cSegment == '1'
        If cSeg2 != '0001'
            ZA1->(DbSeek(xFilial("ZA1")+"0001SEG"))
            MsgAlert("Segmentação deve ser "+ZA1->ZA1_COD+" - "+ZA1->ZA1_DESC+".","Atenção!")
            M->A7_XSEG2 := ZA1->ZA1_COD
            return .F.
        Else
            return .T.
        EndIf
    EndIf

    If cSegment == '9'
        If cSeg2 != '0007'
            ZA1->(DbSeek(xFilial("ZA1")+"0007SEG"))
            MsgAlert("Segmentação deve ser "+ZA1->ZA1_COD+" - "+ZA1->ZA1_DESC+".","Atenção!")
            M->A7_XSEG2 := ZA1->ZA1_COD
            return .F.
        Else
            return .T.
        EndIf
    EndIf

    If cSegment == '3'
        If cSeg2 $ '0001;0008;0009'
            MsgAlert("Segmentação inválida.","Atenção!")
            M->A7_XSEG2 := ''
            return .F.
        Else
            return .T.
        EndIf
    EndIf
    
    If cSegment != '1'
        If cSeg2 == '0001'
            ZA1->(DbSeek(xFilial("ZA1")+"0001SEG"))
            MsgAlert("Segmentação NÃO pode ser "+ZA1->ZA1_COD+" - "+ZA1->ZA1_DESC+".","Atenção!")
            M->A7_XSEG2 := ''
            return .F.
        Else
            return .T.
        EndIf
    EndIf

    RestArea(aArea)

Return lRet
