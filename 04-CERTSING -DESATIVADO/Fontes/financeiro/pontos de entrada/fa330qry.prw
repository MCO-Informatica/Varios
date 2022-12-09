#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA330QRY  �Autor  �OPVSCA - David      � Data �  23/07/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA330QRY
Local _cQuery 	:= paramixb[1]
Local dEmissDe	:= CtoD("  /  /    ")
Local dEmissAt	:= CtoD("  /  /    ")
Local cPedGar	:= Space(TamSx3("E1_PEDGAR")[1])
Local nOpc		:= 2

	DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Intervalo de Emiss�o" PIXEL
	
	@ 10,10 SAY "Emiss�o De" OF oDlg PIXEL 
	@ 10,70 MSGET dEmissDe SIZE 40,5 OF oDlg PIXEL WHEN MV_PAR02 <> 1
	
	@ 010,140 SAY "Emiss�o At�" OF oDlg PIXEL
	@ 010,200 MSGET dEmissAt SIZE 40,5 OF oDlg PIXEL WHEN MV_PAR02 <> 1
	
	@ 25,10 SAY "Pedido GAR" OF oDlg PIXEL
	@ 25,70 MSGET cPedGar SIZE 40,5 OF oDlg PIXEL  

	@ 45,010 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
	@ 45,060 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
	

If nOpc <> 2

	Do Case
		Case MV_PAR02 == 1
			_cQuery := StrTran(_cQuery, "SA1.D_E_L_E_T_ = ' '", " SA1.D_E_L_E_T_ = ' ' AND E1_EMISSAO BETWEEN '"+DtoS(dEmissDe)+"' AND '"+DtoS(dEmissAt)+"' "+ IIF(Empty(cPedGar)," "," AND E1_PEDGAR =  '"+cPedGar+"' ") )	           
		Case MV_PAR02 == 2
			_cQuery := StrTran(_cQuery, "SA1.D_E_L_E_T_ = ' '", "  A1_COD <> '000485' AND SA1.D_E_L_E_T_ = ' ' AND E1_EMISSAO BETWEEN '"+DtoS(dEmissDe)+"' AND '"+DtoS(dEmissAt)+"' " + IIF(Empty(cPedGar)," "," AND E1_PEDGAR =  '"+cPedGar+"' "))	           
	EndCase

                     
Endif


Return(_cQuery)