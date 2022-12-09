#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "COLORS.CH"

User Function HCIDM001()

	Local lPyme			:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)
	Local _cFiltroTop	:= U_HCIDM010("Cliente")
	
	Private cCadastro	:= "Clientes"
	PRIVATE aRotina 	:= { 	{"Pesquisar"	,"PesqBrw"    	, 0 , 1},; 		// "Pesquisar"
								{"Visualizar"	,"A030Visual" 	, 0 , 2},;  	// "Visualizar"
								{"Incluir"		,"A030Inclui" 	, 0 , 3,81},;  	// "Incluir"
								{"Alterar"		,"A030Altera" 	, 0 , 4,82},;  	// "Alterar"
								{"Excluir"		,"A030Deleta" 	, 0 , 5,3},;	// "Excluir"
								{"Contatos"		,"FtContato"	, 0 , 4}}  		//"Contatos"
								
	If !lPyme
		Aadd(aRotina,{"Conhecimento","MsDocument", 0 , 4}) //"Conhecimento"
	EndIf
	
	If !Empty(_cFiltroTop)
		_cFiltroTop	:= "SA1->A1_COD+SA1->A1_LOJA $ '" + _cFiltroTop + "'"
	EndIf
	
	DbSelectarea("SA1")
	MBrowse(,,,,"SA1",,,,,,/*aCores*/,,,,,,,,_cFiltroTop)
	
Return()