/*VERIFICA SE STRING EM MEMÓRIA DE A1_PESSOA CONTÉM 'J','F','E', SE SIM, ATRIBUI E RETORNA 'S' À  _cRecCofi  */
//A1_PESSOA É DOMÍNIO, A1_RecCofi CONTRA-DOMÍNIO


User Function RFATG49()

local _cRecCofi := ""


   IF M->A1_PESSOA$"'J','F','E'"

     _cRecCofi:= "S"
   
   EndIf


   Return(_cRecCofi)
