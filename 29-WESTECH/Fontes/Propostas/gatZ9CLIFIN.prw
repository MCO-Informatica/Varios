#Include 'Protheus.ch'

User Function gatZ9CLIFIN()

	Local _cRetorno 
	Local cCliente 
	Local cIDCLFIN := M->Z9_IDCLFIN
	
	dbSelectArea("SA1")
	SA1->( dbSetOrder(1) )
	
	If SA1->( dbSeek( xFilial("SA1")+cIDCLFIN) )
	
		_cRetorno  := SA1->A1_NOME
	
	END IF
      
Return _cRetorno


