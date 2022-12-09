#include 'protheus.ch'


 /*/{Protheus.doc} M460DEL
APOS O ESTORNO DA LIBERACAO DO PV.
Este P.E. é executado apos o Estorno da Liberacao do Pedido de Vendas.
@type  Function
@author marcio.katsumata
@since 16/03/2020
@version 1.0
@return nil,nil
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784178
    /*/
user function M460DEL()
    local aAreasRst as array

    aAreasRst := {SC6->(getArea()), SC9->(getArea()),getArea()}
    //---------------------------------------------------------
    //Retira o conteúdo do campo de endereço do pedido de venda
    //----------------------------------------------------------
    retiraEnd()

    aEval(aAreasRst, {|aArea|restArea(aArea)})
    aSize(aAreasRst,0)
return 

/*/{Protheus.doc} retiraEnd
Retira o conteúdo do campo C6_LOCALIZ
@type function
@version 1.0
@author marcio.katsumata
@since 16/03/2020
@return nil, nil
/*/
static function retiraEnd()

    recLock("SC6", .F.)
	SC6->C6_LOTECTL := ""
	SC6->C6_NUMLOTE := ""
	SC6->C6_LOCALIZ := ""
	SC6->C6_DTVALID := stod("")
    SC6->(msUnlock())
return