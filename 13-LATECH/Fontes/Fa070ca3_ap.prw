#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Fa070ca3()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_LRETURN,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FA070CA3 � Autor �                       � Data �16/02/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Usuario Marcos so podera Cancelar Baixa de Cheques         ���
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

_lReturn := .t.

If Subs(cUsuario,7,6) $"MARCOS" .and. !Alltrim(SE1->E1_TIPO) $"CH"
    MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,15))+ ", voce nao tem permissao para cancelar baixa de titulos diferentes de CHEQUE.","Validacao Cancelamento Baixa a Receber","Stop")
    _lReturn := .f.
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(_lReturn)
Return(_lReturn)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

