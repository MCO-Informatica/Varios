
User Function RFING01()

Local _lRet		:=	.t.
Local _cTipo	:=	M->E1_TIPO

//PswOrder(1)
//_cGrupo := PSWRET()[1][10][1] //----> Retorna nome do Grupo de Usuário

               
//----> TIPO DO TITULO NO CONTAS A RECEBER
If Alltrim(M->E1_TIPO)$"NCC"

	If Alltrim(Subs(cUsuario,7,5))$"Karla"
		_lRet	:=	.t.
        _cTipo  :=  M->E1_TIPO
	Else
		MsgAlert("Usuário sem permissão para baixar por dação.","Atencao!")
		_lRet	:=	.f.
        _cTipo  :=  ""
	EndIf
EndIf

Return(_cTipo)
