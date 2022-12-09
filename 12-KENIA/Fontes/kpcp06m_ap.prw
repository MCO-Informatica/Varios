#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function kpcp06m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("NQTDTOT,NQUANT,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KPCP06M  � Autor �Ricardo Correa de Souza� Data �29/11/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Valida Quantidades de Perda para Encolhimento              ���
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

nQtdTot := M->D3_QTDPER + M->D3_QTDENC + M->D3_QTDRET
nQuant  := M->D3_QTDENC

If M->D3_PERDA < nQtdTot
    MsgBox("Atencao "+Alltrim(Subs(cUsuario,7,14))+" revise as quantidades de perda por processo/encolhimento/retalho, pois a soma esta maior do que a perda total.","Validacao Total Perda","Stop")
    nQuant := 0
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(nQuant)
Return(nQuant)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

