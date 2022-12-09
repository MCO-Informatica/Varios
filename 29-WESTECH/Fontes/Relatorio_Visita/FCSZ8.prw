#Include 'Protheus.ch'

User Function FCSZ8()
Local _cRetorno 
Local cTipo := M->Z8_TIPOCF

	
	If cTipo == "C"  
	  	_cRetorno := Posicione("SA1",1,xFilial("SA1")+M->Z8_CODCF,"SA1->A1_NOME") 
	Else
	  	_cRetorno := Posicione("SA2",1,xFilial("SA2")+M->Z8_CODCF,"SA2->A2_NOME")
	End if
    
Return ( _cRetorno )

