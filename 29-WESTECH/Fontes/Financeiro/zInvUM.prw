#Include 'Protheus.ch'

User Function zInvUM()

	Local cPedido 	:= M->ZZC_PEDIDO
	Local cCProd 	:= M->ZZD_CPROD
	Local cUM

	if !Empty(cPedido)

		dbSelectArea("SC6")
		SC6->( dbSetOrder(2) )

		If SC6->( dbSeek( xFilial("SC6")+cCProd+cPedido) )

			cUM  := SC6->C6_UM

		END IF 
	else
		If SB1->( dbSeek( xFilial("SB1")+cCProd) )

			cUM  := SB1->B1_UM

		END IF 
	endif

Return cUM

