#include "protheus.ch"

USER FUNCTION SF1DOC()
                           
If !Empty(CNFISCAL)
   CNFISCAL := Replicate("0",(9-Len(Alltrim(CNFISCAL))))+Alltrim(CNFISCAL)
Endif   

Return(.T.)