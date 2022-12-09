
// ATRIBIU CÓDIGO "105" À _cPais, CASO O CAMPO A1_PESSOA SEJA PREENCHIDO COM "J" OU "F".// REGRA DO GATILHO: DOMINIO A1_PESSOA, CONTRA DOMINIO A1_PAIS
User Function RFATG05()

local _cPais := ""

   IF M->A1_PESSOA$"'J','F'"

     _cPais := "105"
   
   EndIf


   Return(_cPais)
