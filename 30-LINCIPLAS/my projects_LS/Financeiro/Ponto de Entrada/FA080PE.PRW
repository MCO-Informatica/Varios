#include "rwmake.ch"

// Programa: FA080PE
// Autor...: Alexandre Dalpiaz
// Data....: 21/06/11
// Funcao..: Apos a gravação da baixa dos titulos A pagar
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
User Function FA080PE()
///////////////////////

RecLock('SE2',.f.)     
SE2->E2_CLASS := SA2->A2_CLASS
MsUnLock()

_cQuery := "UPDATE " + RetSqlName('SE5')
_cQuery += _cEnter + " SET E5_CLASS = '" + SA2->A2_CLASS + "'"
_cQuery += _cEnter + " WHERE E5_FILIAL = '" + xFilial('SE5') + "'"
_cQuery += _cEnter + " AND E5_PREFIXO = '" + SE2->E2_PREFIXO + "'"
_cQuery += _cEnter + " AND E5_NUMERO = '" + SE2->E2_NUM + "'"
_cQuery += _cEnter + " AND E5_TIPO = '" + SE2->E2_TIPO + "'"
_cQuery += _cEnter + " AND E5_PARCELA = '" + SE2->E2_PARCELA + "'"
_cQuery += _cEnter + " AND E5_FORNECE = '" + SE2->E2_FORNECE + "'"
_cQuery += _cEnter + " AND E5_LOJA = '" + SE2->E2_LOJA + "'"
TcSqlExec(_cQuery)

Return()
