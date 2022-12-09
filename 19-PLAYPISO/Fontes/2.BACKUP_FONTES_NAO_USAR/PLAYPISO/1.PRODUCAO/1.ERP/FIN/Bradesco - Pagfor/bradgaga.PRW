#include "rwmake.ch"  
 
//Pos 119 a 119
User function bradgaga()

SetPrvt("_bco,cDigito,")

If !empty(SE2->E2_CODBAR)   

_bco:= SubStr(SE2->E2_CODBAR,1,3)

 If  _bco =='237'
    cDigito := " "     
   else
    cDigito:= "0"
 Endif
Endif

If empty(SE2->E2_CODBAR)
   cDigito :=" "
Endif   

Return(cDigito)
