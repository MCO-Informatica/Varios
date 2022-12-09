#include 'protheus.ch'

/*/{Protheus.doc} MT112IT
Localizado na fun��o que gera o arquivo de 
importa��es conforme �tens, este Ponto de Entrada 
� executado ap�s a grava��o de cada �tem depois 
da a Solicita��o de Importa��o.
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
    //Verifica o c�digo da condi��o de pagamento EIC
    //-----------------------------------------------
    cCondPag := SC1->C1_XCONPAG

    if !empty(cCondPag)
        SW1->W1_CONDPG := cCondPag
    endif

    SW1->(msUnlock())

return