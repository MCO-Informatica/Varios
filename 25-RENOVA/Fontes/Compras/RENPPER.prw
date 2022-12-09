#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RENPER�Autor  �Wellington Mendes  � Data �  Fev/2015   ���
�������������������������������������������������������������������������͹��
���Desc.     � Utilizado na formula de relatorios personalizados     ���
�������������������������������������������������������������������������͹��
���Uso       � RENOVA                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RENPPER()  //utilizado no relatorio personalizado de pedido de compras

Local _nValdesc:=0

_nValdesc:= SC7->C7_TOTAL-SC7->C7_VLDESC
Transform((_nValdesc),"@E 999,999,999,999.99")

Return(_nValdesc)

/////////////////////////////////////////////////////////////////

User Function RENPPER2()//Utilizado no relatorio personalizado de rela��o de baixas

Local _nValsaldo:=0

_nValsaldo:= Posicione("SE2",1,xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),"SE2->E2_SALDO")

Transform((_nValsaldo),"@E 99,999,999,999,999.99")

Return(_nValsaldo)

