#include 'protheus.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVCN01		�Autor  �Microsiga	     � Data �  13/02/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotinas para retorno de dados no CNAB do ITAU				  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function PZCVCN01(nOpc)

Local aArea	:= GetArea()
Local xRet	:= Nil

Default nOpc := 1

If nOpc == 1//Retorna a taxa de juros
	xRet := GetJurMDia()
EndIf

RestArea(aArea)	
Return xRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetJurMDia	�Autor  �Microsiga	     � Data �  13/02/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a taxa de juros mora dia							  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetJurMDia()

Local aArea		:= GetArea()
Local cRet		:= ""
Local nTxJur	:= U_MyNewSX6("CV_TXJURE1",0.0666,"N","Taxa de juros padr�o para o contas a receber", "", "", .F. )
Local lTxJur	:= U_MyNewSX6("CV_HTXJUE1",.T.,"L","Habilita a taxa de juros padr�o sen�o for informado no campo E1_PORCJUR", "", "", .F. )

If !Empty(SE1->E1_PORCJUR)
	cRet := STRZERO((NoRound(SE1->(E1_VALOR-E1_SDDECRE+E1_SDACRES-(SE1->E1_VALOR * (SE1->E1_DESCFIN/100)))*((SE1->E1_PORCJUR/100)),2))*100,13) 
ElseIf lTxJur
	cRet := STRZERO((NoRound(SE1->(E1_VALOR-E1_SDDECRE+E1_SDACRES-(SE1->E1_VALOR * (SE1->E1_DESCFIN/100)))*((nTxJur/100)),2))*100,13)
Else
	cRet := STRZERO(0,13)
EndIf

RestArea(aArea)
Return cRet