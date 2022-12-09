#Include 'Protheus.ch'

User Function gatSD1FC()

	Local _cRetorno 
	
	If ALLTRIM(SD1->D1_XTIPO) = "B" .OR. ALLTRIM(SD1->D1_XTIPO) = "D" 
	  	_cRetorno := Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE,"SA1->A1_NREDUZ") 
	Else
	  	_cRetorno := Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE,"SA2->A2_NREDUZ")
	End if
    
Return ( _cRetorno )

