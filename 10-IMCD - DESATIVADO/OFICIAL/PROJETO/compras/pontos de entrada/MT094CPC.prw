#include 'protheus.ch'


/*/{Protheus.doc} MT094CPC
Ponto de entrada MATA094 - Exibe informações de 
outros campos do pedido de  compra no momento da 
liberação do documento.
@type function
@version 1.0
@author marcio.katsumata
@since 14/05/2020
@return character, campos divididos por pipe
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=286224513
/*/
user function MT094CPC()
    local cRetC7 as character

    cRetC7 := "C7_DATPRF|"

return cRetC7