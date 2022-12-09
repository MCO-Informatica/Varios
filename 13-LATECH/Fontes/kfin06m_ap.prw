#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function kfin06m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CESTCOB,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KFIN06M  � Autor �Ricardo Correa de Souza� Data �11/01/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o Estado de Cobranca nos Cnabs                     ���
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

If !Empty(SA1->A1_ESTC)
    _cEstCob := SA1->A1_ESTC
Else
    _cEstCob := SA1->A1_EST
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(_cEstCob)
Return(_cEstCob)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
