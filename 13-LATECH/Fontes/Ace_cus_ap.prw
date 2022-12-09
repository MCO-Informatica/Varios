#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Ace_cus()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Processa({||RunProc()},"Zera Custo Siga")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Zera Custo Siga")
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SB9")
DbSetOrder(1)
DbGoTop()
ProcRegua(RecCount())

While Eof() == .f.

    IncProc("Ajustando Custo Produto SB9 "+SB9->B9_COD)

    RecLock("SB9",.f.)
      SB9->B9_VINI1 := 0
      SB9->B9_VINI2 := 0
      SB9->B9_VINI3 := 0
      SB9->B9_VINI4 := 0
      SB9->B9_VINI5 := 0
   MsUnLock()

   DbSkip()
EndDo

DbSelectArea("SB2")
DbSetOrder(1)
DbGoTop()
ProcRegua(RecCount())

While Eof() == .f.

    IncProc("Ajustando Custo Produto SB2 "+SB2->B2_COD)

    RecLock("SB2",.f.)
      SB2->B2_VATU1 := 0
      SB2->B2_VATU2 := 0
      SB2->B2_VATU3 := 0
      SB2->B2_VATU4 := 0
      SB2->B2_VATU5 := 0
      SB2->B2_VFIM1 := 0
      SB2->B2_VFIM2 := 0
      SB2->B2_VFIM3 := 0
      SB2->B2_VFIM4 := 0
      SB2->B2_VFIM5 := 0
      SB2->B2_CM1 := 0
      SB2->B2_CM2 := 0
      SB2->B2_CM3 := 0
      SB2->B2_CM4 := 0
      SB2->B2_CM5 := 0
   MsUnLock()

   DbSkip()
EndDo

DbSelectArea("SD1")
DbSetOrder(1)
DbGoTop()
ProcRegua(RecCount())

While Eof() == .f.

    IncProc("Ajustando Custo Produto SD1 "+SD1->D1_COD)

    RecLock("SD1",.f.)
      SD1->D1_CUSTO := 0
      SD1->D1_CUSTO2:= 0
      SD1->D1_CUSTO3:= 0
      SD1->D1_CUSTO4:= 0
      SD1->D1_CUSTO5:= 0
   MsUnLock()

   DbSkip()
EndDo

DbSelectArea("SD2")
DbSetOrder(1)
DbGoTop()
ProcRegua(RecCount())

While Eof() == .f.

    IncProc("Ajustando Custo Produto SD2 "+SD2->D2_COD)

    RecLock("SD2",.f.)
      SD2->D2_CUSTO1:= 0
      SD2->D2_CUSTO2:= 0
      SD2->D2_CUSTO3:= 0
      SD2->D2_CUSTO4:= 0
      SD2->D2_CUSTO5:= 0
   MsUnLock()

   DbSkip()
EndDo

DbSelectArea("SD3")
DbSetOrder(1)
DbGoTop()
ProcRegua(RecCount())

While Eof() == .f.

    IncProc("Ajustando Custo Produto SD3 "+SD3->D3_COD)

    RecLock("SD3",.f.)
      SD3->D3_CUSTO1:= 0
      SD3->D3_CUSTO2:= 0
      SD3->D3_CUSTO3:= 0
      SD3->D3_CUSTO4:= 0
      SD3->D3_CUSTO5:= 0
   MsUnLock()

   DbSkip()
EndDo

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
