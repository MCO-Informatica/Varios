/* ATRIBIU "EXTERIOR" À  _cMunicipio, CASO O CAMPO A1_PESSOA SEJA PREENCHIDO COM "E" (ESTRANGEIRA). REGRA DO GATILHO: DOMINIO A1_PESSOA, CONTRA DOMINIO A1_MUN*/

User Function RFATG07()

local _cMunicipio := ""


   IF M->A1_PESSOA$"'E'"

     _cMunicipio := "EXTERIOR"
   
   EndIf


   Return(_cMunicipio )
