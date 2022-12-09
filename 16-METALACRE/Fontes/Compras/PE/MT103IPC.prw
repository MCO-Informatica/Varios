#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103IPC  �Autor  � Luiz Alberto     � Data �  20/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para tratamento no Acols por item apos a  ���
���          � chamada dos pedidos no documento de entrada                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                                                                          
User Function MT103IPC
Local _nItem   := PARAMIXB[1]
Local _nPosCod := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
Local _nPosDes := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_DESCPRO"})
Local _nPosLot := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_LOTECTL"})
If _nPosCod > 0 .And. _nItem > 0 .And. _nPosDes > 0
    SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+aCols[_nItem,_nPosCod]))
    
	aCols[_nItem,_nPosDes] := SB1->B1_DESC
	If Rastro(SB1->B1_COD)
		aCols[_nItem,_nPosLot] := cNFiscal
	Endif
Endif
Return