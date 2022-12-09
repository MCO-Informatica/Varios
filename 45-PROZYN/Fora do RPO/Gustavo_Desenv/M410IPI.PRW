/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÿ
//³Este ponto de entrada retorna o valor do IPI para ser demonstrado na planilha financeira do pedido de vendas.                                ³
//³                                                                                                                                             ³
//³Para realizar todo o processo corretamente deve utilizar em conjunto com o ponto de entrada M460IPI com o mesmo tratamento do ponto M410IPI. ³
//³                                                                                                                                             ³
//³Para que as informações do pedido de vendas e da nota fiscal de saída fiquem iguais.                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÿ
ENDDOC*/


User Function M410IPI()      

If SC6->C6_FRTUNI > 0 	
	nItem := val(SC6->C6_ITEM) 
	Conout("M410IPI")
	MaFisAlt("IT_BASEIPI",SC6->C6_VALOR+SC6->C6_FRTUNI,nItem)  
	BASEIPI := MaFisRet(nItem,"IT_BASEIPI")
	BASEIPIFRETE := SC6->C6_FRTUNI
	SC6->(DbSkip())
	Return MaFisRet(nItem,"IT_VALIPI")	   
Else       	
	SC6->(DbSkip())
 	Return	
EndIf 
