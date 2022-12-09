#Include "RwMake.Ch"
User FuncTion SHCFLJ()
cTes := SB1->B1_TS
If Trim(Upper(Substr(cUsuario,7,15))) == "LOJA SP"
	cTes := "602"
EndIF	
DbSelectArea("SF4") ; DbSetOrder(1)
DbSeek(xFilial("SF4") +cTes ,.F.)
cCF := SF4->F4_CF	
Return(cCF)