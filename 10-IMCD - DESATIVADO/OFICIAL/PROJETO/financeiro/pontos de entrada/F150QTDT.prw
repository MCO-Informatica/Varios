#include 'protheus.ch'



/*/{Protheus.doc} F150QTDT
Ponto de entrada na rotina FINA150 após a geração
do arquivo CNAB.
@type function
@version 1.0
@author marcio.katsumata
@since 10/07/2020
@return return_type, return_description
/*/
user function F150QTDT()
    local cBPath as character
    local cArqCNAB  as character
    local cExtCNAB  as character


    cBPath := "\STCP_move\backup_send"

    
    if type("cFA150ARQ") == 'C'

        SplitPath ( cFA150ARQ,,,@cArqCNAB, @cExtCNAB )
        cArqCNAB := cArqCNAB+cExtCNAB

        if !file(cBPath)
            makeDir(cBPath)
        endif

        __copyFile(cFA150ARQ, cBPath+"\"+cArqCNAB)
    endif


return
