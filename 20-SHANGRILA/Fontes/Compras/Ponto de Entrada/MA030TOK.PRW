#Include 'Protheus.ch'

/*
* Funcao		:	MA030TOK
* Autor			:	João Zabotto
* Data			: 	27/05/2015
* Descricao		:	Valida CNPJ/CGC Cliente
* Retorno		:
*/
User Function MA030TOK()
Local lRet := .T.

If M->A1_EST != 'EX' .And. Empty(M->A1_CGC)                                                            
	lRet := .F.
	Aviso('Cnpj/Cpf Cliente','Não foi Informado o Cnpj/Cpf para o cliente, por favor informe!',{'OK'})
EndIf                                              	

Return lRet
