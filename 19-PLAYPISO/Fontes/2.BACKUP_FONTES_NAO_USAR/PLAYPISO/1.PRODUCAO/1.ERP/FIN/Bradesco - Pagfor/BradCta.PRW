#include "rwmake.ch"   

User Function BRADCTA() 
//Pos. 195 - 204 //Referente ao valor do documento.

If !empty(SE2->E2_CODBAR)
  _Valor := SUBSTR(U_CBARRAS(),10,10)
  else
  _Valor := "0000000000"
Endif   

Return(_Valor)
