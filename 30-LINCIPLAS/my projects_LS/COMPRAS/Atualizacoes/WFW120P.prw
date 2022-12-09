#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

// Programa.: wfw120p
// Fun��o...: PE WF ap�s a grava��o do PC. Altera o c�digo comprador original do pedido, userlgi, userlga. Busca informa��es das vari�veis p�blicas
//				criadas no PE mt120Alt (antes da altera��o do pedido)
//				somente para os administradores do sistema.
// Autor....: Alexandre Dalpiaz
// Data.....: 12/11/2010

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function WFW120P()
////////////////////////

If __cUserId $ GetMv('LA_PODER') .and. (altera .or. _lCopia)
	_cQuery := "UPDATE " + RetSqlname("SC7")
	_cQuery += " SET C7_USER = '" + _cCompOrig + "', C7_USERLGA = '" + _cUserLga +"' , C7_USERLGI = '" + _cUserLgi +"'"
	_cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "'"
	_cQuery += " AND C7_NUM = '" + cA120Num + "'"
	_cQuery += " AND D_E_L_E_T_ = '' "
	TcSqlExec(_cQuery)
EndIf

_cQuery := "UPDATE " + RetSqlname("SC7")
_cQuery += " SET C7_PRECO = C7_TOTAL / C7_QUANT"
_cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "'"
_cQuery += " AND C7_NUM = '" + cA120Num + "'"
_cQuery += " AND D_E_L_E_T_ = '' "
_cQuery += " AND C7_PRECO = 0 "
TcSqlExec(_cQuery)

Return

