#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT440FIL  �Autor  �Opvs (David)        � Data �  26/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto de Entrada para filtrar os tipos de Produto no browse   ���
���          �de liberacao de Pedidos de Venda                            ���
�������������������������������������������������������������������������͹��
���Uso       �CertiSign Certificados                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT440FIL() 

Local cQry2SC6	:= '' 
Local nI		:= 0

pergunte("CCP004", .F.)

cQry2Sc6 := "( " 
cQry2Sc6 += " U_FILPEDFT(SC6->C6_NUM,"+AllTrim(Str(MV_PAR01))+") "
If MV_PAR02 == 1 .OR. MV_PAR03 == 1
	cQry2Sc6 += "  .AND. ("
	If MV_PAR02 == 1
		cQry2Sc6 += ".OR. SC6->C6_XOPER == '51' "	
	EndIF
	
	If MV_PAR03 == 1
		cQry2Sc6 += ".OR. SC6->C6_XOPER == '52' "
	EndIF
	
	cQry2Sc6 += "  ) "
EndIf
cQry2Sc6 += " ) "

cQry2Sc6 := StrTran(cQry2Sc6,"(.OR. ","(")

pergunte("MTALIB", .F.)

Return(cQry2Sc6) 