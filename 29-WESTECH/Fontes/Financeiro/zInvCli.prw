#Include 'Protheus.ch'

User Function zInvCli()

Local _cRetornoC
	Local cClient := M->ZZC_CLIENT
	Local cPedido := M->ZZC_PEDIDO
	Local cTipo := ""

	dbSelectArea("SC5")
	SC5->( dbSetOrder(1) )
	If SC5->( dbSeek( xFilial("SC5")+cPedido) )
		cTipo  := ALLTRIM(SC5->C5_TIPO)
	END IF

	IF cTipo = "B"
		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		If SA2->( dbSeek( xFilial("SA2")+cClient) )

			_cRetornoC  := SA2->A2_NOME

		END IF
	ELSE
		dbSelectArea("SA1")
		SA1->( dbSetOrder(1) )
		If SA1->( dbSeek( xFilial("SA1")+cClient) )

			_cRetornoC  := SA1->A1_NOME

		END IF
	ENDIF

Return _cRetornoC

