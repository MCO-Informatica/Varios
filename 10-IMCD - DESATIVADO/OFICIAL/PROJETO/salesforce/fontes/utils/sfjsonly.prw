#include 'protheus.CH'
#include 'json.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} SFJSONLY
Classe auxiliar para montagem de JSON.
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFJSONLY

    method new() constructor
    method build()
    method Stringify()
    method destroy()

    data oJson as object

endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
M�todo construtor
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method new() class SFJSONLY
    self:oJson := JsonBld():new()
return

//-------------------------------------------------------------------
/*/{Protheus.doc} build
M�todo para montagem de JSON Object atrav�s de array coluna e array
dados.
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@param   aHeader, array, colunas
@param   aDados, array, dados
@return  nil, nil
/*/
//-------------------------------------------------------------------
method build(aHeader,aDados) class SFJSONLY
    local nTamHeader as numeric
    Local nIndH as numeric

    nTamHeader := len(aHeader)

    for nIndH := 1 to nTamHeader
        self:oJson[#aHeader[nIndH][3]] := aDados[nIndH]
    next nIndH

return

//-------------------------------------------------------------------
/*/{Protheus.doc} Stringify
M�todo que retorna string do json object armazenado.
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@return  character, json em string
/*/
//-------------------------------------------------------------------
method Stringify()  class SFJSONLY
    local cJson as character
    local oResult as object

    oResult := JSON():New( self:oJson )
    cJson := oResult:Stringify()

    freeObj(oResult)
return cJson
    

//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
M�todo que realiza limpeza de objetos
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy()  class SFJSONLY
    freeObj(self:oJson)
return

user function sfjsonly()

return