#include "protheus.ch"

USER FUNCTION SF1SER()

    If !Empty(CSERIE)
        CSERIE := "0"+ALLTRIM(SUBS(CFILANT,3,2))
    Endif

Return(.T.)