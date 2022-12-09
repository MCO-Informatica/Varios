#include 'protheus.ch'



/*/{Protheus.doc} MA050ROT
Adicionar op��es de menu da Mbrowse
LOCALIZA��O: Function MATA050 - Fun��o principal 
do programa de inclus�o, altera��o e exclus�o de 
Transportadoras.
EM QUE PONTO: No in�cio da Fun��o, antes da execu��o da 
Mbrowse de transportadoras, utilizado para adicionar mais 
op��es de menu da Mbrowse (no aRotina).
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