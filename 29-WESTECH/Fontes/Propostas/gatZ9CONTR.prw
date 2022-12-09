#Include 'Protheus.ch'

User Function gatZ9CONTR()

	Local _cRetorno 
	Local cCliente 
	Local cIDCONTR := M->Z9_IDCONTR
	
	dbSelectArea("SA1")
	SA1->( dbSetOrder(1) )
	
	If SA1->( dbSeek( xFilial("SA1")+cIDCONTR) )
	
		_cRetorno  := SA1->A1_NOME
	
	END IF
      
Return _cRetorno


