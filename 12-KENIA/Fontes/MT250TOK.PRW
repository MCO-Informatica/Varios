#include "rwmake.ch" 

User Function MT250TOK()
                        
Local _lRet	:=	.t.

//----> SE OP NAO ESTIVER APROVADA PELA DIRETORIA NAO DEIXA APONTAR
If !SC2->C2_X_BLOQU$"S"
	MsgBox("Ordem de Produ??o ainda n?o aprovada pelos respons?veis pela revis?o do produto. Favor encaminhar aos respons?veis para conseguir apontar.","OP n?o aprovada","Stop")
	_lRet := .f.
EndIf

Return(_lRet)

