#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Acerto()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

processa({||RunProc()},"Acerta Custos SD1/SD2/SD3")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> processa({||Execute(RunProc)},"Acerta Custos SD1/SD2/SD3")
return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> function runproc
Static function runproc()

dbselectarea("sd1")
DbgoTop()
procregua(lastrec())
while !eof()

    incproc("Arquivo: "+alias())

    reclock("sd1",.f.)
      SD1->D1_CUSTO  := 0
      SD1->D1_CUSTO2 := 0
      SD1->D1_CUSTO3 := 0
      SD1->D1_CUSTO4 := 0
      SD1->D1_CUSTO5 := 0
    msunlock()
    dbskip()
enddo

dbselectarea("sD2")
DbgoTop()
procregua(lastrec())
while !eof()

    incproc("Arquivo: "+alias())

    reclock("sD2",.f.)
      SD2->D2_CUSTO1 := 0
      SD2->D2_CUSTO2 := 0
      SD2->D2_CUSTO3 := 0
      SD2->D2_CUSTO4 := 0
      SD2->D2_CUSTO5 := 0
    msunlock()
    dbskip()
enddo

dbselectarea("sD3")
DbgoTop()
procregua(lastrec())
while !eof()

    incproc("Arquivo: "+alias())

    reclock("sD3",.f.)
      SD3->D3_CUSTO1 := 0
      SD3->D3_CUSTO2 := 0
      SD3->D3_CUSTO3 := 0
      SD3->D3_CUSTO4 := 0
      SD3->D3_CUSTO5 := 0
    msunlock()
    dbskip()
enddo

return
