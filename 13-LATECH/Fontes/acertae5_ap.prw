#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function acertae5()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Processa({||runproc()},"Acerta Despesas Bancarias")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||execute(runproc)},"Acerta Despesas Bancarias")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SE5")
DbSetOrder(1)
DbSeek(xFilial("SE5")+"20030102",.t.)
ProcRegua(Lastrec())

While Eof() == .f.
    IncProc("Processando Registro "+Transform(Recno(),"@E 999999"))

    If SE5->E5_TIPODOC == "DB"
        RecLock("SE5",.f.)
        dbDelete()
        MsUnLock()
    EndIf

    DbSkip()
EndDo

Return

