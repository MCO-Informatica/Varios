/*VERIFICA SE STRING EM MEMÓRIA DE A1_PESSOA CONTÉM 'J','F','E', SE SIM, ATRIBUI E RETORNA 'S' À  _cRecCSLL */
//A1_PESSOA É DOMÍNIO, A1_RecCSLL CONTRA-DOMÍNIO

User Function RFATG50()

local _cRecCsll := ""


   IF M->A1_PESSOA$"'J','F','E'"

     _cRecCsll:= "S"
   
   EndIf


   Return(_cRecCsll)
