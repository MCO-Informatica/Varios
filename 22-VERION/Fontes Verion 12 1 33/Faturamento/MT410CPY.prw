#include "rwmake.ch" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A175GRV   �Autor  �RICARDO CAVALINI    � Data �  29/09/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada usado apos a copia do pedido de vendas    ���
���Desc.     � para a limpeza de alguns campos conforme orienta��o do     ���
���Desc.     � cliente                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Verion                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT410CPY()
Public _cUser, _cLocal
                             
_cLocal  := GetArea()
M->C5_VRTIMER := TIME()
M->C5_EMISSAO := DDATABASE
M->C5_VRLIB   := ""

If SM0->M0_CODIGO == "02"
	//Executa validador para zerar alguns campos do pedido
	U_VAEMG02()
EndIf

RestArea(_cLocal)
Return
