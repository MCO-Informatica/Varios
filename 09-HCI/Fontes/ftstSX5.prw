#Include "Protheus.CH"

User Function ftstSX5()

	Private cCadastro := "Cadastro de Unidade de Negocio"
	
	Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
	                     {"Visualizar","AxVisual",0,2},;
	                     {"Incluir","AxInclui",0,3},;
	                     {"Alterar","AxAltera",0,4},;
	                     {"Excluir","AxDeleta",0,5}}
	
	Private cString := "SX5"
	
	dbSelectArea(cString)
	dbSetOrder(1)
	dbSetFilter({|| X5_TABELA = 'AM'},"X5_TABELA = 'AM'") // filtrar apenas a tabela DJ (tipo de operacoes)
	
	mBrowse(6,1,22,75,cString)

Return()