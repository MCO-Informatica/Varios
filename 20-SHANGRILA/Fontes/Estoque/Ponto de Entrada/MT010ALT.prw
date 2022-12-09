#include "rwmake.ch"

/*
* Funcao		:	MT010ALT
* Autor			:	João Zabotto
* Data			: 	03/12/2013
* Descricao		:	Ponto de entrada para atulizar a estrutura do produto caso o mesmo seja bloqueado.
* Retorno		: 	Logico
*/
User Function MT010ALT()
	If Altera .And. SB1->B1_MSBLQL == '1'
		U_SHEST001(.T.)
	EndIf
RETURN  .T.
