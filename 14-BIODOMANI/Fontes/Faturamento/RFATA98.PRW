#include "totvs.ch"
#include "rwmake.ch"
#Include "Protheus.Ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

User Function RFATA98()

Processa({||RunProc()},"Ajusta Série dos Pedidos de Vendas Faturados")

return

Static Function RunProc()

dbSelectArea("SC6")
dbSetOrder(1)
dbGoTop()
ProcRegua(LastRec())
    While Eof() == .f.
    
        IncProc("Processando o Pedido "+SC6->C6_NUM)

        If !Empty(SC6->C6_SERIE)
            dbSelectArea("SC6")
            dbSkip()
            Loop
        EndIf

        dbSelectArea("SD2")
        dbSetOrder(8)
        If dbSeek(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM,.f.)

            If Empty(SC6->C6_SERIE)
                RecLock("SC6",.f.)
                SC6->C6_SERIE := SD2->D2_SERIE
                MsUnLock()
            EndIf    

        EndIf

        dbSelectArea("SC6")
        dbSkip()

    EndDo

MsgAlert("Atualização realizada com sucesso!!!")

Return nil
