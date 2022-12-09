#include "rwmake.ch"

User Function PAGVENC()

    SetPrvt("_VENCVAL")

// VERIFICACAO DO VENCIMENTO DO CODIGO DE BARRAS

    _VENC  :=  "00000000000000"

    If SEA->EA_MODELO =="30" .OR. SEA->EA_MODELO == "31"
        //_VENCVAL := SUBSTR(SE2->E2_CODBAR,6,14)
        _VENCVAL := SUBSTR(SE2->E2_CODBAR,33,4)
    Else
        _VENCVAL :=  Repl("0",4)
    EndIf

Return(_VENCVAL)
