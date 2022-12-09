User Function RFINA003()


ALERT("RFINA003")


If Alltrim(FunName())$"FISA001"

	_cNaturez	:=	"COFINS"
	
ElseIf Alltrim(FunName())$"FINA378"
		
	_cNaturez	:=	"30512"

ElseIf Alltrim(FunName())$"FINA050"
	
	_cNaturez	:=	"30512"

ElseIf Alltrim(FunName())$"MATA103"
	
	_cNaturez	:=	"30512"
	
ElseIf Alltrim(FunName())$"FINA080"
	
	_cNaturez	:=	"30512"

Else
	
	_cNaturez	:=	"COFINS"
	
EndIf			

ALERT(_cNaturez)


Return(_cNaturez)