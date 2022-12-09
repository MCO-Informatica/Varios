/*/{Protheus.doc} MT131FIL
//TODO Ponto de Entrada que permite adicionar dados ao fazer o filtro das Solicitações de Compra que deverão gerar cotação.
@author Pirolo
@since 30/06/2020
@version undefined
@return return, return_description
/*/
User Function MT131FIL()
Local aFiltroSC1	:= {"", ""}
Local aAreaSY1		:= SY1->(GetArea())

//Se for um aprovador, o mesmo possui acesso a todas as cotações
If !AllTrim(RetCodUsr()) $ SuperGetMv("TW_SCAPROV")
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL, Y1_USER
	
	//Localiza o cadastro do Comprador e filtra para que somente visualize as SCs do seu grupo.
	If SY1->(DbSeek(xFilial("SY1")+RetCodUsr()))
		aFiltroSC1[1] := " C1_CODCOMP = '"+SY1->Y1_COD+"' "
		aFiltroSC1[2] := " C1_CODCOMP = '"+SY1->Y1_COD+"' "
	Else
		//Se não for Comprador, nenhum registro é exibido.
		Alert("Usuário sem permissão de acesso, somente Compradores e Aprovadores podem gerar cotações.")
		aFiltroSC1[1] := " 1 <> 1 "
		aFiltroSC1[1] := " 1 <> 1 "
	EndIf 
EndIf
RestArea(aAreaSY1)
Return aFiltroSC1