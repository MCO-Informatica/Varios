
User Function MT161FIL
Local cFiltro	:= ""
Local aAreaSY1	:= SY1->(GetArea())

//Se for um aprovador, o mesmo possui acesso a todas as cota??es
If !AllTrim(RetCodUsr()) $ SuperGetMv("TW_SCAPROV")
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL, Y1_USER
	
	//Localiza o cadastro do Comprador e filtra para que somente visualize as SCs do seu grupo.
	If SY1->(DbSeek(xFilial("SY1")+RetCodUsr()))
		cFiltro := " C8_CODCOM = '"+SY1->Y1_COD+"' "
	Else
		//Se n?o for Comprador, nenhum registro ? exibido.
		Alert("Usu?rio sem permiss?o de acesso, somente Compradores e Aprovadores podem gerar cota??es.")
		cFiltro := " 1 <> 1 "
		
	EndIf 
EndIf
RestArea(aAreaSY1)
Return cFiltro
