#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Carteira()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

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
���ExecBlock � CARTEIRA � Autor � ALEXANDRE MIGUEL      � Data � 20/11/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cnab a Receber BANCO DO BRASIL                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Exclusivo para Clientes Microsiga - Kenia                  ���
���          � Criado pois ha escolha de carteira a serem enviadas ao Bco ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Devido a falta de espaco no configurador para acomodar a expressao abaixo, 
// foi utilizado o ExecBlock abaixo. 

If SE1->E1_SITUACA == "2"
   volta := 51
Elseif SE1->E1_SITUACA == "4"
   volta := 31
Else
   volta := 11
EndIf
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return( volta )
Return( volta )        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
