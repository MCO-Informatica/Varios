#include "protheus.ch"

User Function MA415END()

    RecLock("SCJ",.f.)
    SCJ->CJ_STATUS  :=  "A"
    MsUnLock()
 
Return
