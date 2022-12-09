#include 'protheus.ch'


/*/{Protheus.doc} MA050BUT
Este ponto de entrada pertence à rotina de manutenção do 
cadastro de transportadoras, MATA050(). 
Ele permite ao usuário adicionar botões à barra no topo da tela.
@type function
@version 1.0
@author marcio.katsumata
@since 18/06/2020
@return array, botões
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=6784257
/*/
user function MA050BUT ()

    local aBotoes as array
    aBotoes := {}


    aadd(aBotoes,{'BMPCPO'  ,{|| U_LOGAUDSHW()},"Log Auditoria"})


return aBotoes