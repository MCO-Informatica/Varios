#include "protheus.ch"
#include "rwmake.ch"

User Function FA070TIT()

Local _lRet		:=	.t.
Local _cGrupo	:=	""

//PswOrder(1)
//_cGrupo := PSWRET()[1][10][1] //----> Retorna nome do Grupo de Usu?rio

               
//----> BAIXA POR DACAO
If Alltrim(cMotBx)$"DACAO"

	If Alltrim(Subs(cUsuario,7,5))$"Karla"
		_lRet	:=	.t.
	Else
		MsgAlert("Usu?rio sem permiss?o para baixar por da??o.","Atencao!")
		_lRet	:=	.f.
	EndIf
EndIf

Return(_lRet)