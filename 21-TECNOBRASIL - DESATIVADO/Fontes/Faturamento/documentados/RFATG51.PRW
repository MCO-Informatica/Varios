/*VERIFICA SE STRING EM MEMÓRIA DE A1_PESSOA CONTÉM 'J','F','E', SE SIM, ATRIBUI E RETORNA 'S' À  _cRecPis */
//A1_PESSOA É DOMÍNIO, A1_cRecPis CONTRA-DOMÍNIO

User Function RFATG51()

local _cRecPis := ""


   IF M->A1_PESSOA$"'J','F','E'"

     _cRecPis:= "S"
   
   EndIf


   Return(_cRecPis)
