#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE POSROTINA 2


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ACD100M		�Autor  �Microsiga	     � Data �  03/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �PE antes do mbrowse, para altera��o do menu do arotina	  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACD100M()

Local aArea	:= GetArea()
Local nX	:= 0

For nX := 1 To Len(aRotina)
	If Alltrim(Upper(aRotina[nX][POSROTINA])) == "ACDA100GR"
		aRotina[nX][POSROTINA] := "U_PZCVACD2"//Altera a rotina para gera��o da ordem de separa��o. 
	EndIf 
Next

//aRotina[6,2] := "U_PZACDR100" //Altera rotina  padr�o para a rotina de relat�rio customizado.
Return .t.

RestArea(aArea)



//Return
