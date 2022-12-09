#include "rwmake.ch"

User Function kfin27m()

_cCNPJ := Space(14)

If(Alltrim(SE1->E1_PREFIXO))$"UNI 12 1"
	_cCNPJ	:=	"50747674000122"
Else
	_cCNPJ	:=	"05567611000130"
EndIf

Return(_cCNPJ)