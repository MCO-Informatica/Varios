#INCLUDE "totvs.ch"

/*
* Funcao		:	MT160GRPC
* Autor			:	João Zabotto
* Data			: 	07/11/2014
* Descricao		:	Ponto de entrada responsável por atualizar os campos personalizado no pedido de compra 
* Retorno		: 	
*/
User Function MT160GRPC()
	Local aArea := GetArea()

	If RecLock("SC7",.F.)
		SC7->C7_TES := SC8->C8_TES
		SC7->(MsUnLock())
	EndIf
	
	RestArea(aArea)
Return