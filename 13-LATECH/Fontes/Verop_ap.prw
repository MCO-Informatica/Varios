#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Verop()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AAREA,_CINDSC2,_CREGSC2,")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Cliente   � Kenia Industrias Texteis Ltda.                             ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Programa:#� VEROP.prw                                                  ���
�������������������������������������������������������������������������Ĵ��
���Descricao:� Gatilho que verifica se a quantidade apontada na producao  ���
���          � esta maior do que a op.(CAMPO->D3_QUANT)                   ���
�������������������������������������������������������������������������Ĵ��
���Data:     � 31/08/00    � Implantacao: � 31/08/00                      ���
�������������������������������������������������������������������������Ĵ��
���Programad:� Sergio Oliveira                                            ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Arquivos :� SD3 e SC2.                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

_aArea    := GetArea()

DbSelectArea("SC2")
_cIndSC2 := IndexOrd()
_cRegSC2 := Recno()

DbSetOrder(1)
DbSeek(xFilial()+M->D3_OP,.F.)
   
If M->D3_QUANT > SC2->C2_QUANT 
      
   MsgBox("Quantidade Incompatibilizada com a O.P","ALERT","PRODUCAO")
      
   DbSelectArea("SC2")
   DbSetOrder(_cIndSC2)
   DbGoTo(_cRegSC2)

   RestArea(_aArea)
   
   Return(SC2->C2_QUANT)

EndIf

RestArea(_aArea)

Return(M->D3_QUANT)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

