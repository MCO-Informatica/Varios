#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kcom07m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCUSTO,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KEST04M  � Autor �Ricardo Correa de Souza� Data �15/10/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Volta Rastro dos Produtos                                  ���
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
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Grava Centro de Custo")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Grava Centro de Custo")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SE2")
DbSetOrder(1)
DbGoTop()

ProcRegua(RecCount())

Do While !Eof() 

    IncProc("Selecionando Titulo "+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA)

    DbSelectArea("SD1")
    DbSetOrder(1)
    If !DbSeek(xFilial("SD1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
    Else
        While SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA
            If !Empty(SD1->D1_CC)
                cCusto := SD1->D1_CC
                Exit
            EndIf
            DbSkip()
        Enddo

        DbSelectArea("SE2")
        RecLock("SE2",.f.)
          SE2->E2_CC    :=  cCusto
        MsUnLock()
    EndIf

    DbSelectArea("SE2")
    DbSkip()
EndDo

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
