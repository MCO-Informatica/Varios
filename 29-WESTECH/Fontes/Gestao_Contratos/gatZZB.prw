#Include 'Protheus.ch'

User Function gatZZB()
	Local _cRetorno
	Local cID := M->CTD_XIDPM

	dbSelectArea("ZZB")
	ZZB->( dbSetOrder(1) )

	If ZZB->( dbSeek( xFilial("ZZB")+cID) )

		_cRetorno  := ZZB->ZZB_COORD

	END IF

Return _cRetorno

