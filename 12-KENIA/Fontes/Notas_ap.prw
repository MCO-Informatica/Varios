#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Notas()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CTES,")

Processa({||RunProc()},"Troca Tes das Notas Fiscais")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Troca Tes das Notas Fiscais")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SD2")
DbSetOrder(0)
DbGoTop()

ProcRegua(LastRec())

While Eof() == .f.

    IncProc("SD2 - Trocando Tes "+SD2->D2_DOC+" "+SD2->D2_ITEM)

    If SD2->D2_TES == "700"
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC6")
    DbSetOrder(1)
    If !DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)

        Alert("Pedido "+SD2->D2_PEDIDO+"/"+SD2->D2_ITEM+" nao encontrado.")

        DbSelectArea("SD2")
        DbSkip()
        Loop
    Else
        cTes := SC6->C6_TES

        DbSelectArea("SD2")
        RecLock("SD2",.f.)
          SD2->D2_TES := cTes
        MsUnLock()
    EndIf
    DbSelectArea("SD2")
    DbSkip()
EndDo

Return
