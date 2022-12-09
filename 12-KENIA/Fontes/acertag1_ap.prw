#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function acertag1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Processa({||RunProc()},"Ajusta Estrutura")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Ajusta Estrutura")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

dbselectarea("SG1")
dbsetorder(1)

ProcRegua(LastRec())
While Eof() == .f.
    IncProc("Ajustando data do artigo "+SG1->G1_COD)
    RecLock("SG1",.f.)
      SG1->G1_FIM := dDataBase + 3621
    MsUnLock()
    Dbskip()
EndDo

Return


