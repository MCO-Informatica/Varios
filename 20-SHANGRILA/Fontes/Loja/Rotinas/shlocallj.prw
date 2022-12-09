#Include "RwMake.Ch"
User FuncTion SHLOCALLJ()

cLocal := SB1->B1_LOCPAD
If Trim(Upper(Substr(cUsuario,7,15))) == "LOJA SP"
	cLocal := "02"
//ElseIf Trim(Upper(Substr(cUsuario,7,15))) == "LOJA CP"
//	cLocal := "03"
EndIF	
	
Return(cLocal)