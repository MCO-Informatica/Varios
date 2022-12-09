/*VERIFICA SE STRING EM MEMÓRIA DE A1_PESSOA CONTÉM 'J','F','E', SE SIM, ATRIBUI E RETORNA '1' À  _cRecolheInss  */
//A1_PESSOA É DOMÍNIO, A1_RECINSS CONTRA-DOMÍNIO
User Function RFATG46()

local _cRecolheInss := ""

//Recolhe ISS
   IF M->A1_PESSOA$"'J','F','E'"

     _cRecolheInss := "1"
   
   EndIf


   Return(_cRecolheInss)
