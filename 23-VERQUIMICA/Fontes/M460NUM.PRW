#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "RWMAKE.CH"



User Function M460NUM()

Local aAreaAtu	:=	GetArea()
Local aPvNf		:= aClone(ParamIXB)
Local cPedido	:= aPvNf[1][1]
Local aAreaSC6	:=	SC6->(GetArea())
Local lOk		:= .f.

dbSelectArea("SC5")
dbSetOrder(1)
If dbseek(xFilial("SC5")+cPedido)
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbseek(xFilial("SC6")+cPedido)
		While !eof() .and. SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = cPedido
			
			//----> VERIFICA SE O PRODUTO VENDIDO É MATÉRIA-PRIMA
			If posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_TIPO") = "MP"
				lOk := .t.
				Exit
			EndIf
			
			dbSelectArea("SC6")
			dbskip()
			
		EndDo
	EndIf
	
	If lOk
		U_SC5MENSALT()	//----> GRAVAR INFORMACOES DE LACRE NO PEDIDO DE VENDA PARA PEDIDOS COM MATÉRIA-PRIMA
	EndIf
EndIf

RestArea(aAreaSC6)
RestArea(aAreaAtu)

Return()
