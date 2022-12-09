#include 'Protheus.ch'
#include 'Parmtype.ch'
User Function RFATG0B()

local cMunicipio := ""

/* ARMAZENA "EXTERIOR" EM cMunicipio, CASO M->A1_PESSOA = "E".SERVE DE REGRA PARA O GATILHO DOMÍNIO: A1_PESSOA, CONTRA DOMÍNIO A1_MUNICIP*/  
   
IF M->A1_PESSOA$"'E'"

     cMunicipio := "EXTERIOR"
   
   EndIf


   Return(cMunicipio)
