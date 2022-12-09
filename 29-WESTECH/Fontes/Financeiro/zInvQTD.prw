#Include 'Protheus.ch'
#include "rwmake.ch"
#Include 'topconn.ch'

User Function zInvQTD()

	Local cPedido 	:= M->ZZC_PEDIDO
	Local cCProd 	:= M->ZZD_CPROD
	Local nQuant

	if !Empty(cPedido)

		dbSelectArea("SC6")
		SC6->( dbSetOrder(2) )

		If SC6->( dbSeek( xFilial("SC6")+cCProd+cPedido) )

			nQuant  := SC6->C6_QTDVEN

		END IF
	else
			nQuant  := 0
	endif

Return nQuant
