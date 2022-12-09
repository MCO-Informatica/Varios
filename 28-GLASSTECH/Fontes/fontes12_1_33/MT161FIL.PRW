
User Function MT161FIL
Local cFiltro	:= ""
Local aAreaSY1	:= SY1->(GetArea())

//Se for um aprovador, o mesmo possui acesso a todas as cotações
If !AllTrim(RetCodUsr()) $ SuperGetMv("TW_SCAPROV")
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL, Y1_USER
	
	//Localiza o cadastro do Comprador e filtra para que somente visualize as SCs do seu grupo.
	If SY1->(DbSeek(xFilial("SY1")+RetCodUsr()))
		cFiltro := " C8_CODCOM = '"+SY1->Y1_COD+"' "
	Else
		//Se não for Comprador, nenhum registro é exibido.
		Alert("Usuário sem permissão de acesso, somente Compradores e Aprovadores podem gerar cotações.")
		cFiltro := " 1 <> 1 "
		
	EndIf 
EndIf
RestArea(aAreaSY1)
Return cFiltro
