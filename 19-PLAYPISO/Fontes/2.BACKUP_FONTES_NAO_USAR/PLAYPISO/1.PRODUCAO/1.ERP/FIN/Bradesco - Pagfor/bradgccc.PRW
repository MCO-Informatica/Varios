#include "rwmake.ch" 

//Pos. 105-117 - Conta Corrente Fornecedor //

User function bradgccc()

DbSelectArea("SE2")
DbSelectArea("SEA")

//_bco := substr(SE2->E2_CODBAR,1,3)

If SEA->EA_MODELO $ "30" .AND. substr(SE2->E2_CODBAR,1,3)=="237"
   cCorrente := "000000"+SUBST(SE2->E2_LINDIG,24,7)   
Endif

If SEA->EA_MODELO == "31" .AND. substr(SE2->E2_CODBAR,1,3)<>"237"
   cCorrente := "0000000000000"
Endif             

If SEA->EA_MODELO $ "01/02/03/06/41/43"
   cCorrente := STRZERO(VAL(SUBSTR(SA2->A2_NUMCON,1,10)),13)
Endif


Return(cCorrente)
