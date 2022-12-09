User Function M460IPI()


If Posicione('SC6', 1, xFilial('SC6')+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO, 'C6_FRTUNI') > 0
	nItem := val(Posicione('SC6', 1, xFilial('SC6')+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO, 'C6_ITEM'))
	MaFisAlt("IT_BASEIPI",Posicione('SC6', 1, xFilial('SC6')+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO, 'C6_VALOR')+Posicione('SC6', 1, xFilial('SC6')+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO, 'C6_FRTUNI'),nItem)
	BASEIPIFRETE := Posicione('SC6', 1, xFilial('SC6')+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO, 'C6_FRTUNI')	
	BASEIPI := MaFisRet(nItem,"IT_BASEIPI")
	Return MaFisRet(nItem,"IT_VALIPI")
EndIf                                 

Return


