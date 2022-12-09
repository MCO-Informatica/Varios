/*VERIFICA SE STRING EM MEMÓRIA DE A1_PESSOA CONTÉM 'J','F','E', SE SIM, ATRIBUI E RETORNA 'S' À  _cRecInss  */
//A1_PESSOA É DOMÍNIO, A1_RecInss CONTRA-DOMÍNIO

User Function RFATG48()

local _cRecInss := ""


   IF M->A1_PESSOA$"'J','F','E'"

     _cRecInss:= "S"
   
   EndIf


   Return(_cRecInss)
