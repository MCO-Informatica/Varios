#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Ajustaa1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

PROCESSA({||RUNPROC()},"AJUSTA MEDIA DE ATRASO")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> PROCESSA({||EXECUTE(RUNPROC)},"AJUSTA MEDIA DE ATRASO")
RETURN

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION RUNPROC
Static FUNCTION RUNPROC()


DBSELECTAREA("sa1")
DBSETORDER(1)
DBGOTOP()
PROCREGUA(LASTREC())

WHILE !EOF()

        INCPROC(SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NREDUZ)

        RECLOCK("SA1",.F.)
        SA1->A1_METR    :=       0
        MSUNLOCK()

        DBSKIP()
ENDDO

RETURN
