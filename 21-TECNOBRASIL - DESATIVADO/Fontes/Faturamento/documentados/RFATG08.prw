// ATRIBIU � _cCep, O CONTE�DO DIGITADO NO CAMPO A1_CEP. REGRA DO GATILHO: DOMINIO A1_CEP, CONTRA DOMINIO A1_CEPE. 

User Function RFATG08()

local _cCep := ""



IF !Empty(A1_CEP)
 _cCep := M->A1_CEP
   
   EndIf


   Return(_cCep )
