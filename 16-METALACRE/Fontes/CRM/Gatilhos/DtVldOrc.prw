#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DtVldOrc   �Autor  � Luiz Alberto     � Data �  14/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula 3 Dias Uteis para Validade do Or�amento e Sugere Data
�������������������������������������������������������������������������͹��
���Uso       � MetaLacre - Protheus 11                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DtVldOrc()
Local aArea := GetArea()
Local nDiasLim	:= SuperGetMV("MV_MTLDLIM", ,3)

xdData := dDataBase+1
nDiasLim--
While nDiasLim > 0
	If !GetNewPAR("MV_MTLEFDS",.T.)
		xdData := DataValida(xdData,.t.)
	Endif
	xdData++
	nDiasLim--
Enddo
xdData := DataValida(xdData,.t.)
Return xdData





