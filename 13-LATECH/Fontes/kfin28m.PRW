#include "rwmake.ch"

User Function kfin28m()

_cNome := Space(30)

If(Alltrim(SE1->E1_PREFIXO))$"UNI 12 1"
	_cNome	:=	"KENIA INDUSTRIAS TEXTEIS LTDA"
Else
	_cNome	:=	"ONITEX TINTURARIA LTDA - EPP "
EndIf

Return(_cNome)