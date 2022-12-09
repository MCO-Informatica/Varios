#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103IPC  �Autor  �Junior Carvalho     � Data �  29/07/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza campos customizados no Documento                  ���
���          � de Entrada                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103IPC()
Local cCodEmp := FWCodEmp()

If cCodEmp <> "90"
	nTam :=Len(aCols)
	
	aCols[nTam,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_DESCRI" })]:=SC7->C7_DESCRI
	aCols[nTam,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_XITEMCT" })]:=SC7->C7_XITEMCT
endif

Return()
