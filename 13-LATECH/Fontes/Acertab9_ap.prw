#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Acertab9()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Processa({||RunProc()},"Acerta Custo SB9")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Acerta Custo SB9")
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SB9")
DbSetOrder(1)
DbGoTop()
ProcRegua(RecCount())

While Eof() == .f.

    IncProc("Ajustando Custo Produto "+SB9->B9_COD)

    If Dtos(SB9->B9_DATA) #"20020331"
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SB1")
    DbSetOrder(1)
    DbSeek(xFilial("SB1")+SB9->B9_COD)

    DbSelectArea("SB9")
    RecLock("SB9",.f.)
      SB9->B9_VINI1 := Round(SB9->B9_QINI * SB1->B1_CUSTD,2)
      SB9->B9_VINI2 := 0
      SB9->B9_VINI3 := 0
      SB9->B9_VINI4 := 0
      SB9->B9_VINI5 := 0
   MsUnLock()

   DbSkip()
EndDo

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
