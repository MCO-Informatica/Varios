#include 'protheus.ch'
#include 'parmtype.ch'

User Function MA020TOK()
Local lExecuta := .T.// Valida??es do usu?rio para inclus?o de fornecedor

If M->A2_TIPO <> "X" .AND. Empty(M->A2_CGC)
	lExecuta := .F.
	Alert("N?o ? poss?vel deixar o campo CPF/CNPJ em branco para pessoa f?sica ou jur?dica, apenas Outros!")
EndIf

Return lExecuta	