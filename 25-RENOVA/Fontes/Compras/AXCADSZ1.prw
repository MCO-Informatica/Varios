#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXCADSZ1  � Autor � Pedro Augusto      � Data �  18/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Para uso na solicitacao de compra: ira buscar o grupo de   ���
���          � aprovacao para gerar alcadas de aprovacao da solic.compra  ���
�������������������������������������������������������������������������͹��
���Uso       � RENOVA                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXCADSZ1()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ1"

dbSelectArea("SZ1")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de usuarios x Grupo de Aprovacao",cVldExc,cVldAlt)

Return
