#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Ajquant()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AAREA,_CINDSC2,_CREGSC2,_NVOLTA,M->D3_QUANT,")

/*     
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Cliente   � Kenia Industrias Texteis Ltda.                             ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Programa:#� AJQUANT.prw                                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao:� Gatilho que ajusta a quantidade boa na producao a partir   ���
���          � da digitacao da perda. (CAMPO->D3_PERDA)                   ���
�������������������������������������������������������������������������Ĵ��
���Data:     � 08/09/00    � Implantacao: � 08/09/00                      ���
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

If SM0->M0_CODIGO != "90"

   RestArea(_aArea)

   __RetProc(M->D3_Perda)

EndIf

DbSelectArea("SC2")
_cIndSC2 := IndexOrd()
_cRegSC2 := Recno()

DbSetOrder(1)
DbSeek(xFilial()+M->D3_OP,.F.)
   
If M->D3_PERDA < SC2->C2_QUANT      
   
   _nVolta     := SC2->C2_QUANT - M->D3_PERDA
   
   M->D3_QUANT := _nVolta 

   RestArea(_aArea)

   DbSelectArea("SC2")
   DbSetOrder(_cIndSC2)
   DbGoTo(_cRegSC2)

   __RetProc(M->D3_PERDA)

EndIf

      


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

