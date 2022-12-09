#INCLUDE "PROTHEUS.CH"

User Function XFAT002()                 
            
	Local cAlias	:=	"SZ3"	//Tabela criada para armazenar a formacao de precos
	Private cCadastro	:= "Formação de Preços"
	Private aRotina	:= {}
	
	Aadd(aRotina, {"Pesquisar",	"AxPesqui",	0,	1}) 
	Aadd(aRotina, {"Visualizar",	"AxVisual",	0,	2})
	Aadd(aRotina, {"Incluir",			"AxInclui",		0,	3})	
	Aadd(aRotina, {"Alterar",			"AxAltera",	0,	4})
	Aadd(aRotina, {"Excluir",		"AxDeleta",	0,	5})		
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	mBrowse(6,1,22,75,cAlias)
                                       
Return()