#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02

User Function ItauCtaDg()        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02

// Itau - Posicaoes( 072 - 072 )
Local _cConta
Local _cCnt
Local _cDg
Local _NumCta
Local _Conta


_cConta := AllTrim(SEA->EA_NUMCON)
_cCnt := SubStr(_cConta, 1, len(_cConta) - 2)
_cDg  := SubStr(_cConta, len(_cConta), 1)
_NumCta := _cCnt+_cDg

If !Empty(SEA->EA_NUMCON) 
  _Conta := STRZERO(VAL(_cDg),1,0)
EndIf

Return(_Conta)