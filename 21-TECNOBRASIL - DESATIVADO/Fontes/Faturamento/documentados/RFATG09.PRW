// ATRIBIU "BRASIL" À _cDescPais, CASO O CAMPO A1_PESSOA SEJA PREENCHIDO COM 'J' OU 'F' . REGRA DO GATILHO: DOMINIO A1_PESSOA, CONTRA DOMINIO A1_PAISDES

User Function RFATG09()


local _cDescPais := ""



IF M->A1_PESSOA$"'J','F'"
 _cDescPais := "BRASIL"
   
   EndIf


   Return(_cDescPais )
