#include "totvs.ch"
#include "rwmake.ch"
#Include "Protheus.Ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

User Function RFATA07()

Processa({||RunProc()},"Ajusta Pedidos de Vendas Faturados")

return

Static Function RunProc()

Local _nRecSa1 := 0

dbSelectArea("SC6")
dbSetOrder(1)
dbGoTop()
ProcRegua(LastRec())
    While Eof() == .f.
    
        IncProc("Processando o Pedido "+SC6->C6_NUM)

        If Empty(SC6->C6_NOTA) .Or. Empty(SC6->C6_SERIE)
            dbSelectArea("SC6")
            dbSkip()
            Loop
        EndIf

        dbSelectArea("SC5")
        dbSetOrder(1)
        If dbSeek(SC6->C6_FILIAL+SC6->C6_NUM,.f.)

            If Empty(SC5->C5_NOTA) .Or. Empty(SC5->C5_SERIE)
                RecLock("SC5",.f.)
                SC5->C5_NOTA    :=  SC6->C6_NOTA
                SC5->C5_SERIE   :=  SC6->C6_SERIE
                SC5->C5_LIBEROK :=  "S"
                SC5->C5_X_DATFA :=  SC6->C6_DATFAT
                MsUnLock()
            EndIf    

        EndIf

        dbSelectArea("SC6")
        dbSkip()

    EndDo

MsgAlert("Atualização realizada com sucesso!!!")

Return nil
