#include 'protheus.ch'



/*/{Protheus.doc} MA110BUT
description
@type function
@version 
@author marcio.katsumata
@since 19/03/2020
@return return_type, return_description
/*/
user function MA110BUT()
    local nOpc110 as numeric
    local dDataPrf as date
    local aBut110 as array
    dDataPrf := &(GetSx3Cache("C1_DATPRF", "X3_RELACAO"))

    if type('cForn110') == 'U'
        public cForn110 as character
        public cLoj110 as character
        public cCodTb110 as character
        public lImport110 as logical
        public cVia110 as character
        public cInco110 as character
        public dDtPrf110 as date
    endif

    cForn110    := ""
    cLoj110     := ""
    cCodTb110   := ""
    lImport110  := .F.
    cVia110     := ""
    cInco110    := ""
    dDtPrf110   := dDataPrf
    nOpc110 := PARAMIXB[1]
    aBut110 := PARAMIXB[2]





return aBut110