#Include 'Protheus.ch'

User Function zInvTotal()

	Local cPedido 	:= M->ZZC_PEDIDO
	Local cCProd 	:= M->ZZD_CPROD
	Local nVlrTotal

	if !Empty(cPedido)

		dbSelectArea("SC5")
		SC5->( dbSetOrder(1) )

		If SC5->( dbSeek( xFilial("SC5")+cPedido) )
			nMoeda := SC5->C5_MOEDA
		Endif

		if nMoeda <> 1

			dbSelectArea("SC6")
			SC6->( dbSetOrder(2) )

			If SC6->( dbSeek( xFilial("SC6")+cCProd+cPedido) )

				nVlrTotal  := SC6->C6_VALOR

			END IF
		else
			nVlrTotal  := 0
		endif
	endif

Return nVlrTotal

