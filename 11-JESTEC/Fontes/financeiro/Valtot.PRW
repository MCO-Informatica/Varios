#include "rwmake.ch"

User Function ValTot()

    Local _area   := GetArea()
    Local _Soma   := SOMAVALOR()
    local _Soma1  := 0
    Local _Desc   := 0

//_Desc := SOMAR("SE2","E2_NUMBOR=SEA->EA_NUMBOR ","E2_DECRESC")
//_DESC := VAL(STR(_Desc*100))
//_Soma1 := ((_Soma - _Desc))
//_SOMA1 := STR(_SOMA1)
//_SOMA1 := STRZERO(VAL(_SOMA1),17)
    _SOMA1 := STRZERO(_SOMA,17)

    RestArea(_area)

Return(_Soma1)