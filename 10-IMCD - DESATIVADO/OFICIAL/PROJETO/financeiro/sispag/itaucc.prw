#include "rwmake.ch" 

// Itau - Posicoes( 024 - 043 )

// QDO BANCO IGUAL 341 OU 409////
//ZEROS COMPLEMENTO DE REGISTRO - 024 024 9(01)  // "0"
//AGÊNCIA NÚMERO AGÊNCIA CREDITADA - 025 028 9(04) // STRZERO(VAL(SA2->A2_AGENCIA),4)
//BRANCOS COMPLEMENTO DE REGISTRO - 029 029 x(01) //" "
//ZEROS COMPLEMENTO DE REGISTRO - 030 035 9(06) // 0000000
//CONTA NÚMERO DE C/C CREDITADA - 036 041 9(06) // SUBSTR(_cConta,1,5)
//BRANCOS COMPLEMENTO DE REGISTRO - 042 042 X(01) // " "
//DAC DAC DA AGÊNCIA/CONTA CREDITADA - 043 043 9(01) //_cDig

//QDO BANCO DIFERENTE DE 341 OU 409////
//Agência Número agência CREDITADA - 024 028 9(05)
//brancos Complemento de registro - 029 029 X(01)

User Function ItauCC() 

Local _cConta
Local _cCnt
Local _Conta   
Local _cDig

//_cConta := AllTrim(SA2->A2_NUMCON)
//_cCnt := SUBSTR(_cConta, 1, LEN(_cConta) - 1)//2 
//_cDig  := SubStr(_cConta, len(_cConta), 1)

_cConta := AllTrim(SA2->A2_NUMCON)
_cDig  := ALLTRIM(SA2->A2_DVCTA)



If SA2->A2_BANCO $ "341#409"  //CREDITO ITAU OU UNIBANCO
  //_Conta :="0"+STRZERO(VAL(SA2->A2_AGENCIA),4)+" "+"0000000"+SUBSTR(_cConta,1,5)+" "+ _cDig
  //_Conta :="0"+STRZERO(VAL(SA2->A2_AGENCIA),4)+" "+STRZERO(VAL(_cCnt),12,0)+" "+ _cDig
    _Conta := "0" + STRZERO(VAL(SA2->A2_AGENCIA),4)+" "+STRZERO(VAL(_cConta),12,0)+" "+ STRZERO(VAL(_cDig),1,0)

 else  
  If !(SA2->A2_BANCO)$"341#409" //OUTRO BANCO DIF ITAU/UNIBANCO
 // _Conta := STRZERO(VAL(SA2->A2_AGENCIA),5)+" "+STRZERO(VAL(_cCnt),12,0)+" "+ _cDig
    _Conta := STRZERO(VAL(SA2->A2_AGENCIA),5)+" "+STRZERO(VAL(_cConta),12,0)+" "+ STRZERO(VAL(_cDig),1,0)
  Endif

Endif
  
Return(_Conta)
