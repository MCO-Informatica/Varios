#include "protheus.ch"

/*
___________________________________________________________________________________________________________
???????????????????????????????????????????????????????????????????????????????????????????????????????????
??+-----------------------------------------------------------------------------------------------------+??
???Fun??o    ? GHBROW ?         Autor  ? F?bio Carneiro                       ? Data ? 19/06/2013       ???
??+----------+------------------------------------------------------------------------------------------???
???Descri??o ? Browse para inicializa??o de tabelas                                                     ???
??+----------+------------------------------------------------------------------------------------------???
??? Uso      ? Gold Hair    								                                	        ???
?+------------------------------------------------------------------------------------------------------+??
???????????????????????????????????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????????????????????????????????????
*/

User Function GHBROW()

		Local cAlias:='Z01'
		Private cCadastro :='Componentes'
		Private aRotina :={}
		
		AADD(aRotina,{"Pesquisar",	"AxPesqui", 0,1})
		AADD(aRotina,{"Visualizar",	"AxVisual", 0,2})
		AADD(aRotina,{"Incluir",	"AxInclui", 0,3})
		AADD(aRotina,{"Alterar",    "AxAltera", 0,4})		
		AADD(aRotina,{"Excluir",    "AxDeleta", 0,5})     
		
		dbselectarea(cAlias)
		dbsetorder(1)	  
		mBrowse(6,1,22,75,cAlias)
Return
