#Include 'Protheus.ch'

/*
* Funcao		:	
* Autor			:	Ricardo Souza
* Data			: 	21/10/2018
* Descricao		:	
* Retorno		: 	
*/
User Function SHLERVALOR()

Local _cString	:=	""
Local _cRet		:=	""

_cString := LerStr(37,14)+LerStr(52,2)
_cRet 	 := Val(_cString)/100

Return(_cRet)

