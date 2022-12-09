#Include 'Protheus.ch'

User Function UserCC()
	Local _cRetorno 
	Local cIDColab := M->Z2_IDCOLAB
	
	dbSelectArea("SRA")
	SRA->( dbSetOrder(1) ) 

	If SRA->( dbSeek( xFilial("SRA")+cIDColab) )
	
	     _cRetorno := SRA->RA_CC

	ENDIF
	                  
Return _cRetorno   

