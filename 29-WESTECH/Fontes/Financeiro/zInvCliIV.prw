#Include 'Protheus.ch'

User Function zInvCliIV()

	Local cRetorno1
	Local _cRetorno2
	Local cPedido := M->ZZC_PEDIDO
	Local cTipo := ""

	dbSelectArea("SC5")
	SC5->( dbSetOrder(1) )

	If SC5->( dbSeek( xFilial("SC5")+cPedido) )

	     cRetorno1 := SC5->C5_CLIENTE

	ENDIF

	dbSelectArea("SC5")
	SC5->( dbSetOrder(1) )
	If SC5->( dbSeek( xFilial("SC5")+cPedido) )
		cTipo  := ALLTRIM(SC5->C5_TIPO)
	END IF


	IF cTipo = "B"
		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		If SA2->( dbSeek( xFilial("SA2")+cRetorno1) )

			_cRetorno2  := SA2->A2_COD

		END IF
	ELSE
		dbSelectArea("SA1")
		SA1->( dbSetOrder(1) )
		If SA1->( dbSeek( xFilial("SA1")+cRetorno1) )

			_cRetorno2  := SA1->A1_COD

		END IF
	ENDIF


/*
	IF SA1->( dbSeek( xFilial("SA1")+cRetorno1) )

		_cRetorno2 := SA1->A1_COD

	ENDIF*/

Return _cRetorno2

