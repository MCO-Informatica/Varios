#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A103BLOQ  �Autor  �Junior Carvalho     � Data �  22/08/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � PE Permite  o Bloqueio da Nota Fiscal de Entrada,          ���
���          � atendendo necessidades espec�ficas                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A103BLOQ()

Local lBloq	:= PARAMIXB[1]  // //.T. -> Bloqueia a Nota Fiscal de Entrada / .F. -> N�o bloqueia a Nota Fiscal de Entrada.
Local cProdServ := " "

if !(isincallstack("EICDI158"))
	
	If lBloq
		cProdServ := SuperGetMV("ES_PRDSERV", ,"SV9910010000003")
		
		cProd	:= Alltrim(aCols[n,GDFIELDPOS("D1_COD")])
		
		IF cProd $ cProdServ
			lBloq := .F.
		EndIf
		
	EndIf
Endif
Return(lBloq)