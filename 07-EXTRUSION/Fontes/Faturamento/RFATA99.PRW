#INCLUDE "PROTHEUS.CH"

User Function RFATA99()
    processa({||RunProc()},"Ajusta Classe Valor")
return

Static Function RunProc()

    dbSelectArea("SE1")
    dbSetOrder(1)
    dbGoTop()
    ProcRegua(LastRec())
    While !Eof()

        IncProc("Processando o título CR "+SE1->E1_PREFIXO+" - "+SE1->E1_NUM)

            dbSelectArea("SC5")
            dbSetOrder(1)
            If dbSeek(xFilial("SC5")+SE1->E1_PEDIDO,.f.)

                dbSelectArea("SE1")
                Reclock("SE1",.F.)
                SE1->E1_CLVLCR		:=	SC5->C5_X_CLVL
                MsUnLock()

            EndIf

        dbSelectArea("SE1")
        dbSkip()
    EndDo

    dbSelectArea("SE2")
    dbSetOrder(1)
    dbGoTop()
    ProcRegua(LastRec())
    While !Eof()

        IncProc("Processando o título CP "+SE2->E2_PREFIXO+" - "+SE2->E2_NUM)

            dbSelectArea("SD1")
            dbSetOrder(1)
            If dbSeek(xFilial("SD1")+SE2->E2_NUM,.f.)
                dbSelectArea("SE2")
                Reclock("SE2",.F.)
                SE2->E2_DEBITO				:=		SD1->D1_CONTA
                SE2->E2_CCD					:=		SD1->D1_CC
                SE2->E2_CLVLDB				:=		SD1->D1_CLVL
                SE2->E2_ITEMD               :=      SD1->D1_ITEMCTA
                MsUnLock()

            EndIf

        dbSelectArea("SE2")
        dbSkip()
    EndDo

Return
