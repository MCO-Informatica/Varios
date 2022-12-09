#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RFATE013 ³ Autor ³ Adriano Leonardo    ³ Data ³ 26/12/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para replicar a ordem de compra do cabeçalho do pedi-±±
±±º          ³ do de venda para o campo próprio nos itens.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

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
			If !MsgYesNo("Deseja sobrepor o número do pedido do cliente nos itens com base na ordem de compra do cabeçalho?")
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
	
	//Forço o refresh na tela             
	GETDREFRESH()
//	SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
//	oGetDad:Refresh()
	
	RestArea(_aSavSC6)
	RestArea(_aSavArea)
	
Return(_vRet)