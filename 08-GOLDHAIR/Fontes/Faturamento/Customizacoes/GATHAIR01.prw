#INCLUDE "Protheus.ch"
#Include "TOPCONN.CH"
#Include "RWMAKE.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GATHHAIR01�Autor  �Ricardo Lima        � Data �  01/28/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Galtilho responsavel para atulaizar o qtd do pedido         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP Analista do Sr. Nilton                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function GATHAIR01()

Local _nQtd		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local aArea 	:= GetArea()
Local aAreaSc5	:= SC5->(GETAREA())
Local aAreaSC6  := SC6->(GetAREA())
Private _nQtdT


_nQtdT := 0
FOR x:= 1 To Len(aCols)
	_nQtdT += aCols[x][_nQtd]	
NEXT

M->C5_X_TOTQT := _nQtdT

GetDRefresh()
RestArea(aArea)
RestArea(aAreaSc5)
REstArea(aAreaSc6)
Return .T.
