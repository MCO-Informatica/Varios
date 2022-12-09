#Include 'Protheus.ch'

/*
* Funcao		:	PCOA1001
* Autor			:	João Zabotto
* Data			: 	24/03/2014
* Descricao		:	Executa a rotina de importção da planilha orçamentária
* Retorno		: 	
*/
User Function PCOA1001()
Local aRet :={}

aadd(aRet,{'Import. Plan','U_ZIMPPCOW()' , 0 , 3,0,NIL})

Return aRet
