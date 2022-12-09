#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Pedidos()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CTES,")

Processa({||RunProc()},"Troca Tes Pedidos de Venda")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Troca Tes Pedidos de Venda")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC6")
DbSetOrder(0)
DbGoTop()

ProcRegua(LastRec())

While Eof() == .f.

    IncProc("SC6 - Tes Pedidos")

    If !Alltrim(SC6->C6_CF) $"611/711"
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC5")
    DbSetOrder(1)
    If DbSeek(xFilial("SC5")+SC6->C6_NUM)
        If Alltrim(SC6->C6_CF) == "611"
            If Alltrim(C5_NATUREZ) == "0000"
                cTes := "501"
            ElseIf Alltrim(C5_NATUREZ) == "0020"
                cTes := "502"
            Else
                cTes := SC6->C6_TES
            EndIf
        Else
            cTes := "513"
        EndIf

        DbSelectArea("SC6")
        RecLock("SC6",.f.)
          SC6->C6_TES   :=  cTes
        MsUnLock()
    EndIf
    DbSelectArea("SC6")
    DbSkip()
EndDo

Return
