#include "rwmake.ch"
/*
============================================================================
|Funcao    | FA090SE5           | Rodrigo Correa        |6Data | 30/01/08  |
============================================================================
|Descricao | Gravação complementar - Baixa automática pagar                |
|          |                                                               |
============================================================================
|Observações: Utilizado para gravação de dados complementares da baixa a   |
|             pagar automática. Executado após a gavação do SE5            |
============================================================================
*/
//ExecBlock: 	FA090SE5
//Ponto:	Após a confirmação da baixa, depois da gravação do SE5 (Movimentação Bancária).
//Parâmetros Enviados: Histórico.
//Observações	   Utilizado para gravar dados complementares.
//Retorno Esperado:	Expressão Caracter (histórico da movimentação Bancária).

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
