#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPCPC008  � Autor � Valdimari        � Data �  31/01/2017   ���
�������������������������������������������������������������������������͹��
���Descricao � Manuten��o de Composi��o de Produtos                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 12 - Espec�fico empresa Prozyn                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RPCPC008


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZO"

dbSelectArea("SZO")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Composi��o",cVldExc,cVldAlt)

Return
