#Include 'Protheus.ch'

User Function fornRD()
	Local _cRetorno 
	Local cCodForn := M->Z3_CODFORN
	
	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) ) 

	If SA2->( dbSeek( xFilial("SA2")+cCodForn) )
	
	     _cRetorno := SA2->A2_NOME

	ENDIF
	                  
Return _cRetorno
