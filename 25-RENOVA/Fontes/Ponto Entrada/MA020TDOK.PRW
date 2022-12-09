#include 'protheus.ch'
User Function MA020TDOK()  

	Local _lRet		:= .F.

	If 	M->A2_TIPO <> "X" .and. M->A2_EST <> "EX" .and. Alltrim(M->A2_CGC) == "" // Diferente de X (Estrangeiro)  e estado <> EX 
	   	Aviso('Cadastro de fornecedores','Para Fornecedor nacional é obrigatorio informar CNPJ ou CPF.', {" Ok "})   
	Else
		_lRet := .T. 
	Endif

	Return _lRet
	