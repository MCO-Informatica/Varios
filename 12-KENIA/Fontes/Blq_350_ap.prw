#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Blq_350()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

If SM0->M0_CODIGO=="01"
   MATA350()
Else
   MsgBox("Essa rotina somente pode ser executada na empresa MATRIZ")
EndIf

Return

