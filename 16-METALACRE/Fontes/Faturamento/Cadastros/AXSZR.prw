#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXSZ3     �Autor  �Marcos Zanetti GZ   � Data �  20/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � AxCadastro da tabela SZ3 (Simulacoes do Fluxo de Caixa)    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Presstecnica                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function AXSZR()

Private cString := "SZR"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Cadastro Capacidades Diarias por Grupo Mes/Ano",".T.",".T.")

return