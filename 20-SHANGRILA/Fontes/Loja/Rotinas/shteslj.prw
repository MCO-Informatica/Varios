#Include "RwMake.Ch"
User FuncTion SHTESLJ()
cTes := Iif(Empty(SB1->B1_TS),GetMv("MV_TESSAI"),SB1->B1_TS)                     
If Trim(Upper(Substr(cUsuario,7,15))) == "LOJA SP"
	cTes := "616"
//ElseIf Trim(Upper(Substr(cUsuario,7,15))) == "LOJA CP"
//	cTes := "616"
EndIF	
	
Return(cTes)