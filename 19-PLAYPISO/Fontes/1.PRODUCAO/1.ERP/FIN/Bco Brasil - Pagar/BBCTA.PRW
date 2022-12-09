#include "rwmake.ch" 

User Function BBCta()

// BB - Posicoes( 040 - 041 ) - Detalhe segmento A
Local _cConta
Local _cCnt
Local _Conta   

_cConta := AllTrim(SA2->A2_NUMCON)
_cCnt := SubStr(_cConta, 1, len(_cConta) - 1) //-2
//_cDg  := SubStr(_cConta, len(_cConta), 1)
//_NumCta := _cCnt+_cDg

If !Empty(SA2->A2_NUMCON) 
  _Conta := STRZERO(VAL(_cCnt),12,0)
EndIf

Return(_Conta)