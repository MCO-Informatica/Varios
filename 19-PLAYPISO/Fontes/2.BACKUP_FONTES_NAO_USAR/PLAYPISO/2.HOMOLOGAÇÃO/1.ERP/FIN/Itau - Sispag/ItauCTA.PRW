#include "rwmake.ch" 

User Function ItauCta()

// Itau - Posicaoes( 059 - 070 )
Local _cConta
Local _cCnt
Local _Conta   

_cConta := AllTrim(SEA->EA_NUMCON)
_cCnt := SubStr(_cConta, 1, len(_cConta) - 1) //-2
//_cDg  := SubStr(_cConta, len(_cConta), 1)
//_NumCta := _cCnt+_cDg

If !Empty(SEA->EA_NUMCON) 
  _Conta := STRZERO(VAL(_cCnt),12,0)
EndIf

Return(_Conta)