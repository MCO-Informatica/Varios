#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kpcp10m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_NQUANT,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KPCP10M  � Autor �                       � Data �11/02/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Trava Apontamento Op com Qtd Prod > Qtd Op - 3% Tolerancia ���
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

_nQuant := M->D3_QUANT

DbSelectArea("SC2")
DbSetOrder(1)
DbSeek(xFilial("SC2")+M->D3_OP,.F.)
   
If M->D3_QUANT > (( SC2->C2_QUANT * 2.00 ) - SC2->C2_QUJE )
   MsgBox("Quantidade Incompatibilizada com a OP. Esta acima de 3% de tolerancia","Alert","Producao")
   
   _nQuant := (( SC2->C2_QUANT * 2.00 ) - SC2->C2_QUJE )

EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(_nQuant)
Return(_nQuant)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
