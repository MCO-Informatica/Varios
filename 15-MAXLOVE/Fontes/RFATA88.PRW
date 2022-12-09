#INCLUDE "PROTHEUS.CH"


User Function RFATA88()

    processa({||RunProc()},"Ajusta Descrição")

return

Static Function RunProc()


    dbSelectArea("ACV") 
    dbSetOrder(1)
    dbGoTop()
    ProcRegua(LastRec())
    While !Eof()

        IncProc("Processando")

            dbSelectArea("ACU")
            dbSetOrder(1)
            If dbSeek(xFilial("ACU")+ACV->ACV_CATEGO,.f.)
                dbSelectArea("ACV")
                Reclock("ACV",.F.)
                ACV->ACV_DESCAT				:=		ACU->ACU_DESC
                MsUnLock()
            EndIf

        dbSelectArea("ACV")
        dbSkip()
    EndDo

Return
