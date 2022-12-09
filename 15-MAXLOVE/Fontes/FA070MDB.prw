#include "protheus.ch"
#include "rwmake.ch"

User Function FA070MDB()

Local _lRet	:=	.t.

               
//----> BAIXA POR DACAO
If cMotBx$"DAC"

	If Subs(cUsuario,7,15)$"Karla/Valter"
		_lRet	:=	.t.
	Else
		MsgAlert("Usuario sem permiss�o para baixar por da��o.","Atencao!")
		_lRet	:=	.f.
	EndIf
EndIf

Return(_lRet)