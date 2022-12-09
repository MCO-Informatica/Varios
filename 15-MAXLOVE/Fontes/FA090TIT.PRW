#include "protheus.ch"
#include "rwmake.ch"

User Function FA090TIT()

Local _lRet		:=	.t.
Local _cGrupo	:=	""

//PswOrder(1)
//_cGrupo := PSWRET()[1][10][1] //----> Retorna nome do Grupo de Usuário

               
//----> BAIXA POR DACAO
If Alltrim(cMotBx)$"DACAO"

	If Alltrim(Subs(cUsuario,7,5))$"Karla"
		_lRet	:=	.t.
	Else
		MsgAlert("Usuário sem permissão para baixar por dação.","Atencao!")
		_lRet	:=	.f.
	EndIf
EndIf

Return(_lRet)