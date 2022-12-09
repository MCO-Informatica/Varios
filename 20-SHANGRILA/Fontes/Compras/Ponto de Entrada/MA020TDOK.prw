#Include 'Protheus.ch'

/*
* Funcao		:	MA020TDOK
* Autor			:	João Zabotto
* Data			: 	27/05/2015
* Descricao		:	Valida CNPJ/CGC Fornecedor
* Retorno		:
*/
User Function MA020TDOK()
Local lRet := .T.

If M->A2_EST != 'EX' .And. Empty(M->A2_CGC)   
	lRet := .F.
	Aviso('Cnpj/Cpf Fornecedor','Não foi Informado o Cnpj/Cpf para o fornecedor, por favor informe!',{'OK'})
EndIf

Return lRet
