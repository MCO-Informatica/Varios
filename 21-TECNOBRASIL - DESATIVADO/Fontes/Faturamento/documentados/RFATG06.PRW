// ATRIBIU "F" À _cTipoPessoa , CASO O CAMPO A1_PESSOA SEJA PREENCHIDO COM J','F','E'. REGRA DO GATILHO: DOMINIO A1_PESSOA, CONTRA DOMINIO A1_TIPO


User Function RFATG06()

local _cTipoPessoa := ""


   IF M->A1_PESSOA$"'J','F','E'"

     _cTipoPessoa := "F"
   
   EndIf


   Return(_cTipoPessoa )
