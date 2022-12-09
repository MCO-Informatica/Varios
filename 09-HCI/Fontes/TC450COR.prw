#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TC450COR  �Autor  �Alexandre Circenis  � Data �  02/26/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE para alterar as cores da legenda na rotina de Ordem de  ���
���          � Servi�o                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function TC450COR()
Local aCores :={}  
Local nX
Local aCorAux := ParamIXB
Aadd(aCores, { "AB6_XPREOS=='1'" , 'BR_AZUL' })	
for nX := 1 to Len(aCorAux)
	Aadd(aCores , aCorAux[nX]) 
next
Return aCores