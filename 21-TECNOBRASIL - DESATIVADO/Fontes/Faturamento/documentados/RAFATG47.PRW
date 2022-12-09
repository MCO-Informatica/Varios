
User Function RFATG47()
/*Atribui"S" à _cIssNoPreco caso o campo A1_PESSOA seja pessoa F, j ou e. Retorna _cIssNoPreco para o gatilhos preencher o campo A1_INCISS - ISS NO PREÇO*/

local _cIssNoPreco := ""


   IF M->A1_PESSOA$"'J','F','E'"

     _cIssNoPreco := "S"
   
   EndIf


   Return(_cIssNoPreco )
