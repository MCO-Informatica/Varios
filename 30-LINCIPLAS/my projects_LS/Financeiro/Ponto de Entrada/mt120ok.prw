#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

// Programa: mt120ok
// Autor...: Rodrigo Alexandre
// Data....: 15/03/11
// Funcao..: PE na valida��o de pedidos de compras
///////////////////////
// Confere o tipo de opera��o da condi��o de pagamento do PC e valida com o da TES ///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _MT120OK()
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Local _nQtdeItem := LEN(aCols) // Armazena a quantidade de itens do pedido
Local _cOPPC 	:= Posicione("SE4",1,xFilial("SE4") + CCONDICAO,"E4_OPERACA") 	// Assume o tipo de opera��o do Pedido de Compra
Local _cTES 		 	// Assume o tipo de opera��o da Condi��o de Pagamento
Local _cMsg := " " 		// Armazena as TES cadastradas de forma conflitantes

_lRet := .T.

For _nI := 1 to _nQtdeItem
	If !GDDeleted(_nI)
		_cTES := GDFieldGet("C7_TES", _nI)
		If Posicione("SF4",1,xFilial("SF4") + _cTES,"F4_OPERACA") <> _cOPPC
			_lRet := .F.
			
			_cMsg += "O tipo de opera��o do TES " + _cTES + " � diferente do da condi��o de pagamento." +_cEnter
			
		EndIf
		
	Endif
Next
If !_lRet
	MsgBox(_cMsg)
EndIf

Return (_lRet)
