
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  GATTMK10 �Autor  �Felipe Valen�a      � Data �  01/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para replicar o pedido do cliente nos itens.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GATTMK10


Local _nPrcUnit := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_VRUNIT"})
Local _nPrcTab 	:= aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_PRCTAB"})
Local _nTabela	:= aCols[n,_nPrcTab]

If aCols[n,_nPrcUnit] > aCols[n,_nPrcTab]
	_nTabela := aCols[n,_nPrcUnit]
Endif

Return _nTabela
