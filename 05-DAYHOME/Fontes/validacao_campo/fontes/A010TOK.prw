#Include "Protheus.ch"

User Function A010TOK()
	Local lExecuta := .T.// Valida��es do usu�rio para inclus�o ou altera��o do produto
/*
	If MsgYesNo("Foi feita a conferencia do campo de Ponto de Pedido?","Aten��o")
		lExecuta := .T.
	Else
		lExecuta := .F.
	EndIf
	*/
/*
	If M->B1_EMIN >= 0
		lExecuta := .T.
	Else
		lExecuta := .F.
	EndIf
*/
Return (lExecuta)
