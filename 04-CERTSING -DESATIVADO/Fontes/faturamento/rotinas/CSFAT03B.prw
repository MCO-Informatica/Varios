#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"

/*/{Protheus.doc} csfat03b
    (long_description)
    @type  Function
    @author user
    @since 09/09/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
user function csfat03b(aPVSD,i,aRet)

if SC5->(dbSeek(xFilial("SC5") + aPVSD[i],.T.))
    SC5->(RecLock("SC5",.F.))
    SC5->C5_VEND1 := aRET[2]
    SC5->(MsUnlock())
    lAlter := .T.
    nCont++
else
    lProbl := .T.
    cPVNF += aPVSD[i] + ", "
    nQuant++
endif

Return lAlter



