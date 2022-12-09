#Include 'Protheus.ch'

User Function GatClientFornPV()
	
	Local _cRetorno 
	
	If   !INCLUI
	
		
		If ALLTRIM(SC5->C5_TIPO) = "N" .OR. ALLTRIM(SC5->C5_TIPO) = "C" .OR. ALLTRIM(SC5->C5_TIPO) = "P" .OR. ALLTRIM(SC5->C5_TIPO) = "I"
		
	     	_cRetorno := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE,"SA1->A1_NOME") 
	     
	    End if     
	     
	    If ALLTRIM(SC5->C5_TIPO) = "D" .OR. ALLTRIM(SC5->C5_TIPO) = "B"
	      
	      
	     	_cRetorno := Posicione("SA2",1,xFilial("SA2")+SC5->C5_CLIENTE,"SA2->A2_NOME")
	     
	    End if
	
	//End if
	    
	//If EMPTY(ALLTRIM(M->C5_CLIENTE)) 
	else
	
	    _cRetorno := ""
	      
	Endif 
     
Return nil //_cRetorno

