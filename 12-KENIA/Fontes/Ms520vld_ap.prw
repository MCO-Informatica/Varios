#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Ms520vld()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Ponto de Entrada para Exclusao da Nota

If (SF2->F2_SERIE == '12 ')
   MsgStop("A Nota Fiscal Selecionada Nao Pode Ser Excluida Devido a Serie 12, Favor Selecionar a Nota Original")
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    __Return(.f.)
Return(.f.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
   Return
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
Return
