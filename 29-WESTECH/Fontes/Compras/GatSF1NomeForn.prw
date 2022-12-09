#Include 'Protheus.ch'

User Function GatSF1NomeForn()

	Local _cRetorno 
	
	
	IF     !EMPTY(ALLTRIM(SF1->F1_FORNECE)) 
	
	     _cRetorno := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE,"SA2->A2_NOME")      
	      
	Else 
	
	    _cRetorno := SPACE(10)
	      
	Endif 

Return _cRetorno

