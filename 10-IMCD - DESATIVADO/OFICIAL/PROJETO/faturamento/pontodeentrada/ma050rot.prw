#include 'protheus.ch'



/*/{Protheus.doc} MA050ROT
Adicionar opções de menu da Mbrowse
LOCALIZAÇÃO: Function MATA050 - Função principal 
do programa de inclusão, alteração e exclusão de 
Transportadoras.
EM QUE PONTO: No início da Função, antes da execução da 
Mbrowse de transportadoras, utilizado para adicionar mais 
opções de menu da Mbrowse (no aRotina).
@type function
@version 1.0
@author marcio.katsumata
@since 18/06/2020
@return array, rotinas a serem adicionados
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=6784258
/*/
user function MA050ROT()
    local aRet as array
    aRet := {}

    Aadd(aRet,{"Log auditoria","U_LOGAUDSHW", 0 , 4})  //"Log auditoria"

return aRet