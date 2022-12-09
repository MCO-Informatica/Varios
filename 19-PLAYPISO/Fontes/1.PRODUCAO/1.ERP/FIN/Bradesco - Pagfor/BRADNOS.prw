#include "rwmake.ch"        

//Pos 139 a 150 - Nosso Numero //
User Function BRADNOS()      

SetPrvt("_RETNOS,")

If SUBSTR(SE2->E2_CODBAR,1,3)!= "237"
   _RETNOS := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)
ELSE
  If !EMPTY(SE2->E2_CODBAR)
    _nossoNum  :=SUBSTR(SE2->E2_LINDIG,12,09)+SUBSTR(SE2->E2_LINDIG,22,2)
    _RETNOS := StrZero(Val(_nossoNum),12)
  Endif
Endif

Return(_RETNOS)