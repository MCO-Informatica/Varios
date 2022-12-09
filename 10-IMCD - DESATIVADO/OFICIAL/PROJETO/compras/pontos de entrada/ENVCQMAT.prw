#include 'protheus.ch'


/*/{Protheus.doc} ENVCQMAT
O Ponto de Entrada ENVCQMAT permite manipular o 
envio do material para o C.Q
Localização:Rotina de complemento de atualização 
dos dados do item do documento de entrada.
Ponto:Após efetuar a análise de envio para o C.Q
@type function
@version 1.0
@author marcio.katsumata
@since 17/08/2020
@return logical, envia para CQ?
@see    https://tdn.totvs.com/display/public/PROT/ENVCQMAT+-+Envio+de+Material+para+o+CQ
/*/
user function ENVCQMAT()
    local lEnviaCQMat as logical
    local cFabric     as character
    local cFabLoja    as character
    local cProdRef    as character
    local lAchou      as logical
    local lReferencia as logical
    local aArea       as array


    aArea       := getArea()
    lEnviaCQMat := PARAMIXB[1]
    cProdRef	:= SD1->D1_COD
    lReferencia	:= MatGrdPrrf(@cProdRef,.T.)

    //------------------------------------------------------------------------------------------------
    //Realiza a regra de avaliação do CQ direto da loja e fabricante da tabela SD1 para importações.
    //-------------------------------------------------------------------------------------------------
	if SD1->D1_TIPO == "N" .And. RetFldProd(SB1->B1_COD,"B1_TIPOCQ") $ " ,M" .and. !Empty(SD1->D1_CONHEC)

        cFabric  := SD1->D1_FABRIC
        cFabLoja := SD1->D1_LOJFABR
		
		dbSelectArea("SA5")
		SA5->(dbSetOrder(1))
		If !Empty(cFabric) .And. !Empty(cFabLoja)
			lAchou := SA5->(MsSeek(xFilial("SA5")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+cFabric+cFabLoja,.F.))
		Else
			lAchou := SA5->(MsSeek(xFilial("SA5")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD,.F.))
		EndIf

		If !lAchou .And. lReferencia
			SA5->(dbSetOrder(9))
			If !Empty(cFabric) .And. !Empty(cFabLoja)
				lAchou := SA5->(MsSeek(xFilial("SA5")+SD1->D1_FORNECE+SD1->D1_LOJA+cProdRef+cFabric+cFabLoja,.F.))
			Else
				lAchou := SA5->(MsSeek(xFilial("SA5")+SD1->D1_FORNECE+SD1->D1_LOJA+cProdRef,.F.))
			EndIf
		Endif

		If lAchou
			If SA5->A5_NOTA<SB1->B1_NOTAMIN .Or. SA5->A5_SKIPLOT>0
				If  SA5->A5_NOTA<SB1->B1_NOTAMIN .Or.  Mod(SA5->A5_ENTREGA,SA5->A5_SKIPLOT)==0
					lEnviaCQMat := .T.
				EndIf
				If SA5->A5_SKIPLOT > 0
					RecLock("SA5",.F.)
					SA5->A5_ENTREGA += 1
					SA5->(MsUnlock())
				EndIf
			EndIf
		EndIf

    endif
    
    restArea(aArea)
    aSize(aArea,0)

return lEnviaCQMat
