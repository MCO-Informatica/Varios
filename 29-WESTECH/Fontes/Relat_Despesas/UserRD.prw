#Include 'Protheus.ch'

User Function UserRD()
	Local _cRetorno 
	Local cIDColab := M->Z2_IDCOLAB
	
	dbSelectArea("SRA")
	SRA->( dbSetOrder(1) ) 

	If SRA->( dbSeek( xFilial("SRA")+cIDColab) )
	
	     _cRetorno := SRA->RA_NOME

	ENDIF
	                  
Return _cRetorno


