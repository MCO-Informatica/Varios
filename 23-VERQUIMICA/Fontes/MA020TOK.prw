#include 'protheus.ch'
#include 'parmtype.ch'

User Function MA020TOK()
Local lExecuta := .T.// Validações do usuário para inclusão de fornecedor

If M->A2_TIPO <> "X" .AND. Empty(M->A2_CGC)
	lExecuta := .F.
	Alert("Não é possível deixar o campo CPF/CNPJ em branco para pessoa física ou jurídica, apenas Outros!")
EndIf

Return lExecuta	