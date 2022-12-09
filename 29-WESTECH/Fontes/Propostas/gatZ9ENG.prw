#Include 'Protheus.ch'

User Function gatZ9ENG()

	Local _cRetorno 
	Local cCliente 
	Local cIDENG := M->Z9_IDENG
	
	dbSelectArea("SA1")
	SA1->( dbSetOrder(1) )
	
	If SA1->( dbSeek( xFilial("SA1")+cIDENG) )
	
		_cRetorno  := SA1->A1_NOME
	
	END IF
      
Return _cRetorno

