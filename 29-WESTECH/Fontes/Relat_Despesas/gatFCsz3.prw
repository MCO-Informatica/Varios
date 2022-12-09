#Include 'Protheus.ch'

User Function gatFCsz3()
Local _cRetorno 
Local cTipo := M->Z3_TIPO

	
	If cTipo == "C"  
	  	_cRetorno := Posicione("SA1",1,xFilial("SA1")+M->Z3_CODFORN,"SA1->A1_NOME") 
	Else
	  	_cRetorno := Posicione("SA2",1,xFilial("SA2")+M->Z3_CODFORN,"SA2->A2_NOME")
	End if
    
Return ( _cRetorno )
