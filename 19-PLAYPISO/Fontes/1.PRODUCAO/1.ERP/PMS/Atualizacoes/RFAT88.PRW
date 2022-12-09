#INCLUDE "PROTHEUS.CH"

User Function RFATA88()
    processa({||RunProc()},"Ajusta Descrição")
return

Static Function RunProc()

    dbSelectArea("SB2") 
    dbSetOrder(1)
    dbGoTop()
    ProcRegua(LastRec())
    While !Eof()

        IncProc("Processando o título CP ")

            //dbSelectArea("SD1")
            dbSelectArea("SB1")
            dbSetOrder(1)
            //If dbSeek(xFilial("SD1")+SE2->E2_NUM,.f.)
            If dbSeek(xFilial("SB1")+SB2->B2_COD,.f.)
                //dbSelectArea("SE2")
                //Reclock("SE2",.F.)
                //dbSelectArea("ACV")
                //Reclock("ACV",.F.)
                dbSelectArea("SB2")
                Reclock("SB2",.F.)
                SB2->B2_DPROD				:=		SB1->B1_DESC
                MsUnLock()

            EndIf


        dbSelectArea("SB2")
        dbSkip()
    EndDo

Return
