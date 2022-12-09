#include "rwmake.ch"
/*
============================================================================
|Funcao    | FA090SE5           | Rodrigo Correa        |6Data | 30/01/08  |
============================================================================
|Descricao | Grava��o complementar - Baixa autom�tica pagar                |
|          |                                                               |
============================================================================
|Observa��es: Utilizado para grava��o de dados complementares da baixa a   |
|             pagar autom�tica. Executado ap�s a gava��o do SE5            |
============================================================================
*/
//ExecBlock: 	FA090SE5
//Ponto:	Ap�s a confirma��o da baixa, depois da grava��o do SE5 (Movimenta��o Banc�ria).
//Par�metros Enviados: Hist�rico.
//Observa��es	   Utilizado para gravar dados complementares.
//Retorno Esperado:	Express�o Caracter (hist�rico da movimenta��o Banc�ria).

User Function FA090SE5()
_aArea := GetArea()

_cGrupo := SE2->E2_GRUPO
_cDescGrupo := SE2->E2_DESCGRU

RecLock("SE5",.F.)
   SE5->E5_GRUPO     := _cGrupo
   SE5->E5_DESCGRU   := _cDescGrupo
MsUnLock()

RestArea(_aArea)
Return
