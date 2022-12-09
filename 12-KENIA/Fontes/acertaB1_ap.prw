#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function acertaB1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

processa({||RunProc()},"Acerta Processo Tingimento")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> processa({||Execute(RunProc)},"Acerta Processo Tingimento")
return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> function runproc
Static function runproc()

dbselectarea("SB1")
dbgotop()
procregua(lastrec())

while eof() == .f.

    incproc("Ajustando dados do produto "+SB1->B1_COD)

    if b1_TIPO #"PT"
        dbskip()
        loop
    endif

    reclock("SB1",.f.)
    SB1->B1_TIPO := "PI"
    msunlock()

    dbskip()
enddo

return
