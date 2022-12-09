#include "rwmake.ch"      

//Pos. 264 a 265 - Modalidade de Pagamento //
User Function BRADMOD()    

Do Case
 Case SEA->EA_MODELO == "01"
   _ModPag := "01"
 Case SEA->EA_MODELO == "02"
   _ModPag := "02"  
 Case SEA->EA_MODELO == "05"
    _ModPag := "05"
 Case SEA->EA_MODELO == "06"
    _ModPag := "01"
 Case SEA->EA_MODELO == "03"  
   _ModPag := "03"
 Case SEA->EA_MODELO $ "41/43"  
   _ModPag := "08"
 Case SEA->EA_MODELO == "30"  
   _ModPag := "31"
 Case SEA->EA_MODELO == "31"  
   _ModPag := "31"
EndCase   

Return(_ModPag)    