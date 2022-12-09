#Include "Protheus.ch"

User Function MA030TOK()
	Local lRet := .T.

	If M->A1_PESSOA == 'J' .AND. Empty(M->A1_INSCR) .AND. M->A1_XPINSCR == '1'
		lRet := .F.
		MsgInfo("Inscri��o � obrigat�ria para Pessoa Jur�dica!","Aten��o")
	EndIf

	If M->A1_PESSOA <> 'E' .AND. Empty(M->A1_CGC)
		lRet := .F.
		MsgInfo("CNPJ/CPF � obrigat�rio!","Aten��o")
	EndIf

	If M->A1_PESSOA == 'J' .AND. Empty(M->A1_CNAE)
		lRet := .F.
		MsgInfo("CNAE � obrigat�rio para pessoa jur�dica!"+Chr(13)+Chr(10)+"Utilize o mashup da Receita Federal - CNPJ.","Aten��o")
	EndIf

	If lRet 
		U_ContatoTB(1)
	EndIf
Return lRet
