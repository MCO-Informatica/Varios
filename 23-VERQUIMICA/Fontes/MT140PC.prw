#Include "Totvs.ch"

/*/{Protheus.doc} MT140PC
@description 	Ponto de entrada para nao validar Pedido de compra 
				quando a pre nota vier da Central XML
				(Central faz a validacao)
@author 		Amedeo D. Paoli filho
@version		1.0
@param			Nil
@return			ExpL1, L, Logico
@type 			Function
/*/
User Function MT140PC()
	Local lRetorno	:= .T.
	
	If IsInCallStack("U_CENTNFEXM")
		lRetorno	:= .F.
	EndIf
	
Return lRetorno