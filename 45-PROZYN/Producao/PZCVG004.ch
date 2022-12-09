#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVG004		�Autor  �Microsiga	     � Data �  07/01/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicializador padr�o do mBrowse							  ���
���          �                											  ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function PZCVG004()

Local aArea	:= GetArea()
Local cRet	:= ""

cRet := POSICIONE("SZQ",1,xfilial("SZQ")+SD7->D7_PRODUTO+SD7->D7_LOTECTL,"ZQ_OBSERV")

RestArea(aArea)	
Return cRet
