#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function naturez()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Processa({||RunProc()},"Troca Naturezas Financeiras")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Troca Naturezas Financeiras")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SE5")
DbSetOrder(0)
DbGoTop()

ProcRegua(LastRec())

While Eof() == .f.

    IncProc("SE5 - Trocando Naturezas")

    If SE5->E5_RECPAG #"R"
        DbSkip()
        Loop
    Else
        DbSelectArea("SE1")
        DbSetOrder(1)
        If DbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
            DbSelectArea("SE5")
            RecLock("SE5",.f.)
              SE5->E5_NATUREZ   :=  SE1->E1_NATUREZ
            MsUnLock()
        EndIf
    EndIf
    DbSelectArea("SE5")
    DbSkip()
EndDo

Return
