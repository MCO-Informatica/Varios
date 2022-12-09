User Function MT450FIM()

    Local _aArea := GetArea()

    dbSelectArea("SC9")
    dbSetOrder(1)
    If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.F.)

        While Eof() == .f. .And. SC9->(C9_FILIAL+C9_PEDIDO) == SC5->(C5_FILIAL+C5_NUM)
            //----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 21/09/2017 - RICARDO SOUZA - MCINFOTEC
            RecLock("SC9",.f.)
            SC9->C9_DF		:=	SC5->C5_DF
            MsUnLock()
            //----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 21/09/2017 - RICARDO SOUZA - MCINFOTEC
            dbSkip()
        EndDo
    EndIf

    RestArea(_aArea)


Return()