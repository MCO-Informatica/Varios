User Function MTA410T()

    Local _aArea    := GetArea()
 
    If  Empty(SC5->C5_BLQ) .AND. SC5->C5_XFRTDIG$"1" .AND. SC5->C5_TPFRETE$"C"
        dbSelectArea("SC5")
        RecLock("SC5",.f.)
        SC5->C5_BLQ := "1"
        MsUnLock()
    EndIf

    RestArea(_aArea)

Return()
