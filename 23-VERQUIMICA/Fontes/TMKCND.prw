#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: TMKCND   | Autor: Celso Ferrone Martins   | Data: 30/07/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | PE para Bloquear campo de condicao de pagamento na tela    |||
|||           | que gera a tabela SL4 - Funcao Tk273Pagamento              |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function TMKCND(	_cNumTlv,		_cCliente,		_cLoja,		_cCodCont,;
						_cCodOper,		_aParcelas,		_cCodPagto,	_oCodPagto,;
						_cDescPagto,	_oDescPagto,	_lHabilAux,	_cCodTransp)

_oCodPagto:LREADONLY := .T.


Return()