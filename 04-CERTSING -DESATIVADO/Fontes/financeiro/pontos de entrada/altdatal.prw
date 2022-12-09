#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AltDatAl  �Autor  �Opvs (David)        � Data �  09/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para Altera��o da Data de Contabiliza��o   ���
���          �Referente aos Arquivos de Cartao de Credito                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AltDatAl

Local aArea		:= GetArea()
Local dDataCtb 	:= dDataLanc
Local cRotina 	:= funname()
Local dDatServ	:= MsDate() //Data do Servidor

If alltrim(cRotina) $ 'CTSA012|CTSA016' .and. Type("_dDtCtb") <> "U"               

	dDataCTB := _dDtCtb
	
ElseIf 	!VlDtCal(dDataCtb,dDataCtb,2,"01","234",.F.) .and.;
		VlDtCal(dDatServ,dDatServ,2,"01","234",.F.)

	dDataCTB :=  DataValida(CtoD("01/"+StrZero(Month(dDatServ),02)+"/"+Strzero(year(dDatServ),4)),.T.)
	
EndIf


RestArea(aArea)

Return(dDataCTB)



