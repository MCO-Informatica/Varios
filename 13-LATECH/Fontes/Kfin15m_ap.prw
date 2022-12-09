#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfin15m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_NSEQUEN,_CRETSEQ,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KFIN15M  � Autor �Ricardo Correa de Souza� Data �02/02/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna a Sequencia do Arquivo para Pagfor Bradesco        ���
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

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Processamento                                                              *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*


DbSelectArea("SEE")
DbSeek(xFilial("SEE")+"237") //----> Codigo do Banco Bradesco
_nSequen := Val(SEE->EE_FAXATU)
_nSequen := _nSequen + 1

_cRetSeq := StrZero(_nSequen,15)

RecLock("SEE",.F.)
  _field->EE_FAXATU := StrZero(_nSequen,10)
MsUnLock()

Return(_cRetSeq)

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Fim do Programa                                                            *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

