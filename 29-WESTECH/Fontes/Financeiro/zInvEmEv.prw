#Include 'Protheus.ch'

User Function zInvEmEv()

	Local cRetorno1
	Local _cRetorno2
	Local cPedido := M->ZZC_PEDIDO

	dbSelectArea("SC5")
	SC5->( dbSetOrder(1) )

	If SC5->( dbSeek( xFilial("SC5")+cPedido) )

	     cRetorno1 := SC5->C5_CLIENTE

	ENDIF

	IF SA1->( dbSeek( xFilial("SA1")+cRetorno1) )

		_cRetorno2 := SA1->A1_COD

	ENDIF

Return _cRetorno2

