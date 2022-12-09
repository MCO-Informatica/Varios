// ATRIBIU "EX" À _cEstado, CASO O CAMPO A1_PESSOA SEJA PREENCHIDO COM "E" (ESTRANGEIRA). REGRA DO GATILHO: DOMINIO A1_PESSOA, CONTRA DOMINIO A1_EST
User Function RFATG04()

local _cEstado := ""


   IF M->A1_PESSOA$"'E'"

     _cEstado := "EX"
   
   EndIf


   Return(_cEstado)
