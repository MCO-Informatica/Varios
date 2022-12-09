#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Loteb1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

***  LOTEB1
***  PREENCHE OS CAMPOS DOS PA'S COM 'L' E A FORMULA COM '003'
***  AUTOR: SERGIO OLIVEIRA.

Processa( {|| ATUB1() }, "Atualizacao de SB1 - Kenia...")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa( {|| Execute(ATUB1) }, "Atualizacao de SB1 - Kenia...")
__RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION ATUB1
Static FUNCTION ATUB1()

If SM0->M0_CODIGO == "01"
   DbSelectArea("SB1")
   DbSetOrder(2)
   ProcRegua(LastRec())
   DbSeek(xFilial()+"PA",.T.)
   While !eof() .and. SB1->B1_FILIAL == xFilial() .and. SB1->B1_TIPO == "PA"
      IncProc("Aguarde...")
      If (SubStr(SB1->B1_COD,Len(AllTrim(SB1->B1_COD))-2,3) <> "000")
         RecLock("SB1",.F.)
         SB1->B1_RASTRO  := "L"
         SB1->B1_FORMLOT := "003"
      EndIf
      MsUnLock()
      DbSkip()
   End
EndIf
Return
