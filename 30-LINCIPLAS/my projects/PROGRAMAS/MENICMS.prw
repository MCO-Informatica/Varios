#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MENICMS   � Autor � Rodrigo Okamoto    � Data �  04/08/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro para grava��o da aliquota a dado o credito de     ���
���          � ICMS para empresa Simples Nacional                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MENICMS()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZA"

dbSelectArea("SZA")
dbSetOrder(1)

AxCadastro(cString,"Cadastro da Aliquota para calculo ICMS para impress�o da NF",cVldAlt,cVldExc)

Return
