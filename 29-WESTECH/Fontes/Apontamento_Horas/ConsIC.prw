#Include 'Protheus.ch'

User Function ConsIC()
	
	Local _cRetorno 
	Local cItemCC := M->Z4_ITEMCTA
	
	dbSelectArea("SC5")
	SC5->( dbSetOrder(10) ) 

	If SC5->( dbSeek( xFilial("SC5")+cItemCC) )
	
	     _cRetorno := SC5->C5_XXCLVL
	     
	     if _cRetorno = "ADMINISTRACAO" .OR. _cRetorno = "PROPOSTA" .OR._cRetorno = "QUALIDADE" .OR. _cRetorno = "ENGENHARIA" .OR. _cRetorno = "ESTOQUE" .OR. M->Z4_ITEMCTA = "OPERACOES"
	     	
	     	_cRetorno := "BR0000001"
	     ENDIF 
	     	
	Else
	
		 _cRetorno := "BR0000001" 
		
	ENDIF

	

Return _cRetorno