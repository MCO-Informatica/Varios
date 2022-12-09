User Function RFINA001()

_cNaturez := ""


If Alltrim(FunName())$"FINA376"

	If SA2->A2_TIPO$"F"
		_cNaturez	:=	"30509"
	Else
		_cNaturez	:=	"30511"
	EndIf
	
ElseIf Alltrim(FunName())$"FINA378"
		
	_cNaturez	:=	"30512"

ElseIf Alltrim(FunName())$"FINA050"
	
	If SA2->A2_TIPO$"F"
		_cNaturez	:=	"30509"
	Else
		_cNaturez	:=	"30511"
	EndIf

ElseIf Alltrim(FunName())$"FINA740"
	
	If SA2->A2_TIPO$"F"
		_cNaturez	:=	"30509"
	Else
		_cNaturez	:=	"30511"
	EndIf
ElseIf Alltrim(FunName())$"MATA103"
	
	If SA2->A2_TIPO$"F"
		_cNaturez	:=	"30509"
	Else
		_cNaturez	:=	"30511"
	EndIf

Else
	
	_cNaturez	:=	"30507"
	
EndIf			


Return(_cNaturez)
