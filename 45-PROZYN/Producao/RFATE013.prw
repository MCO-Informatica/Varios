#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RFATE013 � Autor � Adriano Leonardo    � Data � 26/12/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para replicar a ordem de compra do cabe�alho do pedi-��
���          � do de venda para o campo pr�prio nos itens.                ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RFATE013()
	
	Local _aSavArea 	:= GetArea()
	Local _aSavSC6	 	:= SC6->(GetArea())
	Local _cRotina		:= "RFATE013"
	Local _vRet			:= &(ReadVar())
	Local _nCont		:= 1
	Local _nCont2		:= 1
	Local _nPosPedC		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMPCOM"})
	Local _lAltera		:= .T.
	
	For _nCont := 1 To Len(aCols)
		If !Empty(aCols[_nCont,_nPosPedC]) .And. aCols[_nCont,_nPosPedC]<>M->C5_NUMPCOM .And. !aCols[_nCont,Len(aCols[_nCont])]
			If !MsgYesNo("Deseja sobrepor o n�mero do pedido do cliente nos itens com base na ordem de compra do cabe�alho?")
				_lAltera := .F.
			EndIf
			
			Exit
		EndIf
	Next
	
	If _lAltera
		_nCont := 1
		
		For _nCont := 1 To Len(aCols)
			aCols[_nCont,_nPosPedC]	:= M->C5_NUMPCOM
		Next
	EndIf
	
	//For�o o refresh na tela             
	GETDREFRESH()
//	SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
//	oGetDad:Refresh()
	
	RestArea(_aSavSC6)
	RestArea(_aSavArea)
	
Return(_vRet)