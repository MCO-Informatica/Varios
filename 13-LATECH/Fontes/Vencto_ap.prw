#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Vencto()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

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
���ExecBlock � VENCTO   � Autor � MARCOS GOMES          � Data � 13/10/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cnab a Receber BANCO DO BRASIL                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Exclusivo para Clientes Microsiga - Kenia                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Devido a falta de espaco no configurador para acomodar a expressao abaixo, 
// foi utilizado o ExecBlock abaixo. 

If Empty( SE1->E1_DESCFIN )
   volta := StrZero(0,6)
   Else
   volta := GravaData( SE1->E1_VENCREA, .F. )
EndIf
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return( volta )
Return( volta )        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
