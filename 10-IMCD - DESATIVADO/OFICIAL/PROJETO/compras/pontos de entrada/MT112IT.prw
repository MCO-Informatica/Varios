#include 'protheus.ch'

/*/{Protheus.doc} MT112IT
Localizado na função que gera o arquivo de 
importações conforme ítens, este Ponto de Entrada 
é executado após a gravação de cada ítem depois 
da a Solicitação de Importação.
@type function
@version 1.0
@author marcio.katsumata
@since 19/03/2020
@return nil, nil
@see    https://tdn.totvs.com/display/public/PROT/MT112IT
/*/
user function MT112IT()
    local cCondPag as character

    cCondPag := ""

    
    reclock("SW1", .F.)
    SW1->W1_PRECO := SC1->C1_PRECO

    //----------------------------------------------
    //Verifica o código da condição de pagamento EIC
    //-----------------------------------------------
    cCondPag := SC1->C1_XCONPAG

    if !empty(cCondPag)
        SW1->W1_CONDPG := cCondPag
    endif

    SW1->(msUnlock())

return