#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Cepcob()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("VOLTA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���ExecBlock � CEPCOB   � Autor � ALEXANDRE MIGUEL      � Data � 13/12/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cnab a Receber BANK BOSTON                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Exclusivo para Clientes Microsiga - Kenia                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Devido a falta de espaco no configurador para acomodar a expressao abaixo, 
// foi utilizado o ExecBlock abaixo. 

If !SA1->A1_CEPC == " "
   volta := SA1->A1_CEPC
Else 
   volta := SA1->A1_CEP
EndIf
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return( volta )
Return( volta )        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
