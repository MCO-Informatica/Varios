#include 'protheus.ch'


/*/{Protheus.doc} MA050BUT
Este ponto de entrada pertence � rotina de manuten��o do 
cadastro de transportadoras, MATA050(). 
Ele permite ao usu�rio adicionar bot�es � barra no topo da tela.
@type function
@version 1.0
@author marcio.katsumata
@since 18/06/2020
@return array, bot�es
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=6784257
/*/
user function MA050BUT ()

    local aBotoes as array
    aBotoes := {}


    aadd(aBotoes,{'BMPCPO'  ,{|| U_LOGAUDSHW()},"Log Auditoria"})


return aBotoes