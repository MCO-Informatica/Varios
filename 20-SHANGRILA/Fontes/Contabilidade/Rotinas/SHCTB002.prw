#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*
* Funcao		:	SHCTB001
* Autor			:	João Zabotto
* Data			: 	07/02/2014
* Descricao		:	Rotina responsável por gravar o item contábil cliente e fornecedor.
* Retorno		: 	SHCTB002(1)
*/	
User Function SHCTB002(nOpc)
	Local cAlias := ''
	Local cRotina:= ''

	Default nOpc := 0

	If nOpc == 1
		cRotina:= 'U_M030INC()'
		cAlias := 'SA1'
	ElseIf nOpc == 2
		cRotina:= 'U_M020INC()'
		cAlias := 'SA2'
	EndIf

	(cAlias)->(DbSetOrder(1))
	(cAlias)->(DbGotop())
	While !(cAlias)->(Eof())
	
		&cRotina
		
		(cAlias)->(DbSkip())
	Enddo


Return