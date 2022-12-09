#Include 'Protheus.ch'

User Function zInvDesc()

	Local _cRetorno
	Local cCProd := M->ZZD_CPROD

	dbSelectArea("SB1")
	SB1->( dbSetOrder(1) )

	If SB1->( dbSeek( xFilial("SB1")+cCProd) )

		_cRetorno  := SB1->B1_XXDI
		IF EMPTY(_cRetorno)
			_cRetorno  := SB1->B1_DESC
		ENDIF

	END IF

Return _cRetorno

