#include "Protheus.ch"
#include "Totvs.ch"


/*/{Protheus.doc} User Function VLDC7BLK
    (long_description)
    @type  Function
    @author user
    @since 28/07/2021
    @version version
    @param param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function VLDC7BLK()
Local lRet  := .T.

IF POSICIONE("SC7",1,xFilial("SC7")+M->Z7_NUMPED,"C7_CONAPRO") == "B"
    lRet := .F.
    Alert("Pedido Bloqueado, escolha um pedido liberado","Atenção")
ENDIF

Return lRet
