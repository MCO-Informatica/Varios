#include 'protheus.ch'


/*/{Protheus.doc} DL150OEX
Ponto de entrada para ordernar a DCF conforme numero de
sequencia para que realize corretamente a geração de serviços(SDB)
@type function
@version 1.0
@author marcio.katsumata
@since 28/05/2020
@return character, ordenação 
/*/
user function DL150OEX()
    local cOrder as character

    cOrder := SqlOrder(DCF->(IndexKey(IndexOrd())))+", DCF_NUMSEQ "

return cOrder