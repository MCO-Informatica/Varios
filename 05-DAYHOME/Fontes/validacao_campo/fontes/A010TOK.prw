#Include "Protheus.ch"

User Function A010TOK()
	Local lExecuta := .T.// Validações do usuário para inclusão ou alteração do produto
/*
	If MsgYesNo("Foi feita a conferencia do campo de Ponto de Pedido?","Atenção")
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
