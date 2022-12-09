#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXSZ6     �Autor  �Silverio Bastos     � Data �  05/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � AxCadastro da tabela SZ6 (Simulacoes do Fluxo de Caixa)    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Verion                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function AXSZ6()

Private cString := "SZ6"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Simulacoes do Fluxo de Caixa",".T.",".T.")

return