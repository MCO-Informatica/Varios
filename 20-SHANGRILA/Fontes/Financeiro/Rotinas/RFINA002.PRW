User Function RFINA002()

ALERT("RFINA002")

If Alltrim(FunName())$"FISA001"

	_cNaturez	:=	"PIS"
	
ElseIf Alltrim(FunName())$"FINA378"
		
	_cNaturez	:=	"30512"

ElseIf Alltrim(FunName())$"FINA050"
	
	_cNaturez	:=	"30512"

ElseIf Alltrim(FunName())$"MATA103"
	
	_cNaturez	:=	"30512"
	
ElseIf Alltrim(FunName())$"FINA080"
	
	_cNaturez	:=	"30512"

Else
	
	_cNaturez	:=	"PIS"
	
EndIf			

ALERT(_cNaturez)


Return(_cNaturez)