#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Bloq()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("LRETORNA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���ExecBlock � BLOQ     � Autor � MARCOS GOMES          � Data � 03.04.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica a situacao do cliente.                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Exclusivo para Clientes Microsiga - Kenia                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek( xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI )

lRetorna := .t.

If SA1->A1_STATUS == "I" .OR. SA1->A1_STATUS == "C" 
   MsgBox ("Cliente Bloqueado ou Inativo","Aten��o","ALERT")
   lRetorna := .f.
EndIf

__RetProc(lRetorna)


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

