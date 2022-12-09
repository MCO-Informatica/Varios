#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Acertal()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Processa({||RunProc()},"Ajusta Numero do Lote")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Ajusta Numero do Lote")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC6")
ProcRegua(LastRec())
DbGoTop()
While Eof() == .f.
    IncProc("Selecionando Registros SC6")
    If !Empty(SC6->C6_LOTECTL)
        RecLock("SC6",.f.)
          SC6->C6_DTVALID   :=   Ctod("31/12/01")
        MsUnLock()
    EndIf
    DbSkip()
EndDo

DbSelectArea("SC9")
ProcRegua(LastRec())
DbGoTop()
While Eof() == .f.
    IncProc("Selecionando Registros SC9")
    If !Empty(SC9->C9_LOTECTL)
        RecLock("SC9",.f.)
          SC9->C9_DTVALID   :=   Ctod("31/12/01")
        MsUnLock()
    EndIf
    DbSkip()
EndDo

DbSelectArea("SD1")
ProcRegua(LastRec())
DbGoTop()
While Eof() == .f.
    IncProc("Selecionando Registros SD1")
    If !Empty(SD1->D1_LOTECTL)
        RecLock("SD1",.f.)
          SD1->D1_DTVALID   :=   Ctod("31/12/01")
        MsUnLock()
    EndIf
    DbSkip()
EndDo

DbSelectArea("SD2")
ProcRegua(LastRec())
DbGoTop()
While Eof() == .f.
    IncProc("Selecionando Registros SD2")
    If !Empty(SD2->D2_LOTECTL)
        RecLock("SD2",.f.)
          SD2->D2_DTVALID   :=   Ctod("31/12/01")
        MsUnLock()
    EndIf
    DbSkip()
EndDo

DbSelectArea("SD3")
ProcRegua(LastRec())
DbGoTop()
While Eof() == .f.
    IncProc("Selecionando Registros SD3")
    If !Empty(SD3->D3_LOTECTL)
        RecLock("SD3",.f.)
          SD3->D3_DTVALID   :=   Ctod("31/12/01")
        MsUnLock()
    EndIf
    DbSkip()
EndDo

DbSelectArea("SD4")
ProcRegua(LastRec())
DbGoTop()
While Eof() == .f.
    IncProc("Selecionando Registros SD4")
    If !Empty(SD4->D4_LOTECTL)
        RecLock("SD4",.f.)
          SD4->D4_DTVALID   :=   Ctod("31/12/01")
        MsUnLock()
    EndIf
    DbSkip()
EndDo

DbSelectArea("SD5")
ProcRegua(LastRec())
DbGoTop()
While Eof() == .f.
    IncProc("Selecionando Registros SD5")
    If !Empty(SD5->D5_LOTECTL)
        RecLock("SD5",.f.)
          SD5->D5_DTVALID   :=   Ctod("31/12/01")
        MsUnLock()
    EndIf
    DbSkip()
EndDo



Return
