#include "rwmake.ch"       

User Function BBCtaDg()  

// BB - Posicoes( 042 - 042 ) - Detalhe Segmento A
Local _cConta
Local _cCnt
Local _cDg
Local _NumCta
Local _Conta


_cConta := AllTrim(SA2->A2_NUMCON)
_cCnt := SubStr(_cConta, 1, len(_cConta) - 2)
_cDg  := SubStr(_cConta, len(_cConta), 1)
_NumCta := _cCnt+_cDg

If !Empty(SA2->A2_NUMCON) 
  _Conta := STRZERO(VAL(_cDg),1,0)
EndIf

Return(_Conta)