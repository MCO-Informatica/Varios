#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kpcp03m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KPCP03M  � Autor �Ricardo Correa de Souza� Data �23/08/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ajuste dos Empenhos Cuja OP Ja Encerrada                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Kenia Industrias Texteis Ltda                              ���
�������������������������������������������������������������������������Ĵ��
���            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ���
�������������������������������������������������������������������������Ĵ��
���   Analista   �  Data  �             Motivo da Alteracao               ���
�������������������������������������������������������������������������Ĵ��
���              �        �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e indices utilizados no processamento                            *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SC2")     //----> Ordens de Producao
DbSetOrder(1)           //----> Numero + Item + Sequencia

DbSelectArea("SD4")     //----> Empenhos           
DbSetOrder(2)           //----> OP + Produto             

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Ajuste de Empenhos")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Ajuste de Empenhos")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SD4")
ProcRegua(LastRec())
DbGoTop()

While Eof() == .f.

    IncProc("Selecionando Empenho da OP "+SD4->D4_OP)

    DbSelectArea("SC2")
    If !DbSeek(xFilial("SC2")+SD4->D4_OP)
        DbSelectArea("SD4")
        RecLock("SD4",.f.)
          DbDelete()
        MsUnLock()
    Else
        If SC2->C2_QUJE == SC2->C2_QUANT
            DbSelectArea("SD4")
            RecLock("SD4",.f.)
              DbDelete()
            MsUnLock()
        /* esta etapa devera ser realizada na mao devido a estrutura
        Else
            DbSelectArea("SD4")
            RecLock("SD4",.f.)
              SD4->D4_QUANT := (SC2->C2_QUANT - SC2->C2_QUJE)
            MsUnLock()
        */
        EndIf
    EndIf

    DbSelectArea("SD4")
    DbSkip()
EndDo

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

