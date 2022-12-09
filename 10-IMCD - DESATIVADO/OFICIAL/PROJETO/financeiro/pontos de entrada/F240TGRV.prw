#include 'protheus.ch'

/*/{Protheus.doc} F240TGRV
Ponto de entrada que permite customizar regra após 
o término do processamento e gravação do arquivo 
de envio SISPAG.
@type function
@version 1.0
@author marcio.katsumata
@since 10/07/2020
@return return_type, return_description
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=6071692
/*/
user function F240TGRV ()

    local cBPath as character
    local cArqCNAB  as character
    local cExtCNAB  as character


    cBPath := "\STCP_move\backup_send"

    
    if type("cFA240NAR") == 'C'

        SplitPath ( cFA240NAR,,,@cArqCNAB, @cExtCNAB )
        cArqCNAB := cArqCNAB+cExtCNAB

        if !file(cBPath)
            makeDir(cBPath)
        endif

        __copyFile(cFA240NAR, cBPath+"\"+cArqCNAB)
    endif

return
