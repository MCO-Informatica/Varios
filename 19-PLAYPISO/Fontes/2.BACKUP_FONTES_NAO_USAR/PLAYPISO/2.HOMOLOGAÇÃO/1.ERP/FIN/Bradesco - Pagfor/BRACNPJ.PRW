#include "rwmake.ch"   

User Function BRACNPJ()

If Posicione("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_TIPO")="J"
   _CNPJ := STRZERO(VAL(SA2->A2_CGC),15)
Endif
If Posicione("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_TIPO")="F"  
   _CNPJ := SUBSTR(SA2->A2_CGC,1,9)+"0000"+SUBSTR(SA2->A2_CGC,10,2)
Endif   

Return(_CNPJ)
