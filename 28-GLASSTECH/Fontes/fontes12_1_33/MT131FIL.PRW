/*/{Protheus.doc} MT131FIL
//TODO Ponto de Entrada que permite adicionar dados ao fazer o filtro das Solicita??es de Compra que dever?o gerar cota??o.
@author Pirolo
@since 30/06/2020
@version undefined
@return return, return_description
/*/
User Function MT131FIL()
Local aFiltroSC1	:= {"", ""}
Local aAreaSY1		:= SY1->(GetArea())

//Se for um aprovador, o mesmo possui acesso a todas as cota??es
If !AllTrim(RetCodUsr()) $ SuperGetMv("TW_SCAPROV")
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL, Y1_USER
	
	//Localiza o cadastro do Comprador e filtra para que somente visualize as SCs do seu grupo.
	If SY1->(DbSeek(xFilial("SY1")+RetCodUsr()))
		aFiltroSC1[1] := " C1_CODCOMP = '"+SY1->Y1_COD+"' "
		aFiltroSC1[2] := " C1_CODCOMP = '"+SY1->Y1_COD+"' "
	Else
		//Se n?o for Comprador, nenhum registro ? exibido.
		Alert("Usu?rio sem permiss?o de acesso, somente Compradores e Aprovadores podem gerar cota??es.")
		aFiltroSC1[1] := " 1 <> 1 "
		aFiltroSC1[1] := " 1 <> 1 "
	EndIf 
EndIf
RestArea(aAreaSY1)
Return aFiltroSC1