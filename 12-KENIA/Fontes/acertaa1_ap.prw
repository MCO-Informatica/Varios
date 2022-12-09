#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function acertaa1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

processa({||RunProc()},"Acerta Risco Clientes")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> processa({||Execute(RunProc)},"Acerta Risco Clientes")
return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> function runproc
Static function runproc()

dbselectarea("SA1")
dbgotop()
procregua(lastrec())

while eof() == .f.

    incproc("Ajustando dados do cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+" "+ALLTRIM(SA1->A1_NREDUZ))

    reclock("sa1",.f.)
    SA1->A1_RISCO := "A"
    msunlock()

    dbskip()
enddo

return
