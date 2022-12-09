#include "rwmake.ch" 

User Function MT250TOK()
                        
Local _lRet	:=	.t.

//----> SE OP NAO ESTIVER APROVADA PELA DIRETORIA NAO DEIXA APONTAR
If !SC2->C2_X_BLOQU$"S"
	MsgBox("Ordem de Produção ainda não aprovada pelos responsáveis pela revisão do produto. Favor encaminhar aos responsáveis para conseguir apontar.","OP não aprovada","Stop")
	_lRet := .f.
EndIf

Return(_lRet)

