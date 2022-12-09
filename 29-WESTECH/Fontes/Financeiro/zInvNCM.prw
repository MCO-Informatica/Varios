#Include 'Protheus.ch'

User Function zInvNCM()

	Local _cRetorno
	Local cCProd := M->ZZD_CPROD

	dbSelectArea("SB1")
	SB1->( dbSetOrder(1) )

	If SB1->( dbSeek( xFilial("SB1")+cCProd) )

		_cRetorno  := SB1->B1_POSIPI

	END IF

Return _cRetorno

