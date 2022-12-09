#include "rwmake.ch" 

User Function ItauCC() 

// Itau - Posicoes( 024 - 043 )

Local _cConta
Local _cCnt
Local _Conta   
Local _cDig

_cConta := AllTrim(SA2->A2_NUMCON)
_cCnt := SUBSTR(_cConta, 1, LEN(_cConta))// - 1)//2 
//_cDig := STRZERO(VAL(_cConta),12)  
_cDig  := SubStr(_cConta, len(_cConta), 1)
//_NumCta := _cCnt+_cDg

If SA2->A2_BANCO =="341"
   _Conta :="0"+STRZERO(VAL(SA2->A2_AGENCIA),4)+" "+"0000000"+SUBSTR(_cConta,1,5)+" "+ STRZERO(VAL(SA2->A2_DIGCTA),1) //_cDig
  else  
  If SA2->A2_BANCO !="341"
     _Conta := STRZERO(VAL(SA2->A2_AGENCIA),5)+" "+"00"+STRZERO(VAL(_cCnt),10,0)+" "+ SA2->A2_DIGCTA //_cDig
  Endif
Endif
  
Return(_Conta)