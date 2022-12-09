#include "rwmake.ch"  

User Function BRADDIG()

//POS 399-399// 
SetPrvt("_digverif,")  

_DigVerif := " "

IF !EMPTY(SE2->E2_CODBAR) .AND. SEA->EA_MODELO $ "30/31"
  _DigVerif:=  SUBSTR(SE2->E2_CODBAR,5,1)  
  ELSE
  _DigVerif := " "
Endif

Return(_DigVerif)
