#include "rwmake.ch"  

User Function BRADAGE()


SetPrvt("_Agen,")

///// indica agencia do favorecido
//// PAGFOR - POSICOES ( 99 - 103)

_CodBar := "0" + SubStr(SE2->E2_CODBAR,5,4)

If SEA->EA_MODELO $ "31/30" .and. substr(SE2->E2_CODBAR,1,3)=="237"
   _Agen := _CodBar
Endif             

If SEA->EA_MODELO $ "31/30" .and. substr(SE2->E2_CODBAR,1,3)<>"237"           
   _Agen := "00000"
Endif

If SEA->EA_MODELO $ "01/02/03/05/06/41/43"
   _Agen := STRZERO(VAL(SUBSTR(SA2->A2_AGENCIA,1,5)),5)
Endif


Return(_Agen)
