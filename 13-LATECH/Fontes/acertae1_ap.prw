#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function acertae1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Processa({||runproc()},"Acerta Titulos a Receber")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||execute(runproc)},"Acerta Titulos a Receber")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SE1")
DbSetOrder(1)
DbGoTop()
ProcRegua(Lastrec())

While Eof() == .f.
    IncProc("Processando Titulo "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA)

    If Empty(SE1->E1_VEND1)
        dbSelectArea("SA1")
        dbSetOrder(1)
        dbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),.F.)
        RecLock("SE1",.f.)
        SE1->E1_VEND1  :=  SA1->A1_VEND
        MsUnLock()
    EndIf

    DbSelectArea("SE1")
    DbSkip()
EndDo

Return

