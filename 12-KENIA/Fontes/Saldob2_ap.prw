#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Saldob2()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

***  SALDOB2
***  PREENCHE OS CAMPOS DOS PA'S COM 'L' E A FORMULA COM '003'
***  AUTOR: SERGIO OLIVEIRA.

Processa( {|| ATUB2() }, "Atualizacao de lotes Kenia...")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa( {|| Execute(ATUB2) }, "Atualizacao de lotes Kenia...")
__RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION ATUB2
Static FUNCTION ATUB2()

If SM0->M0_CODIGO == "01"
   DbSelectArea("SB1")
   DbSetOrder(2)
   ProcRegua(LastRec())
   DbSeek(xFilial()+"PA",.t.)
   While !eof() .and. SB1->B1_FILIAL == xFilial() .and. SB1->B1_TIPO == "PA"
      IncProc("Aguarde...")
      DbSelectArea("SB2")
      DbSetOrder(1)
      If DbSeek(xFilial()+SB1->B1_COD+SB1->B1_LOCPAD,.F.)
         RecLock("SB2",.F.)
         SB2->B2_QATU  := 999999
         MsUnLock()
         DbSelectArea("SB1")
         DbSkip()
         Loop
     EndIf
     DbSelectArea("SB1")
     DbSkip()
   End
EndIf
Return
