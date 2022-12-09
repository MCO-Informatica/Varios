#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT241EST �Autor  � Junior Carvalho    � Data �  31/01/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � BLOQUEAR EXCLUSAO DE MOVIMENTACAO INTERNA  QUE GERARAM     ���
���          � CUSTOS do DOC. DE ENTRADA                                  ���
�������������������������������������������������������������������������͹��
���Uso       � IMCD                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT241EST()
Local nX := 0
	For nX = 1 to Len(aCols)
		cDocSd1 := GDFieldGet("D3_XIMPEIC", Nx,,aHeader, aCols )
		If !Empty(cDocSd1)
			cChvSF1 := Substr(cDocSd1,1,At("EIC",cDocSd1)-1)
			dbSelectArea("SD1")
			dbSetOrder(1)
			if MsSeek(cChvSF1)
				RecLock("SD1" , .F.)
				SD1->D1_XINTSD3 := ' '
				MsUnLock()
			Endif
		EndIf
	Next nx


Return Nil
