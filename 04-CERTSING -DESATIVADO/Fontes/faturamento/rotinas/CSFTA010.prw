#Include 'Protheus.ch'


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFTC010 |Autor: |David Alves dos Santos |Data: |08/03/2016   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Rotina de cadastro de licitações.                             |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |CS  = Certisign.                                              |
//|do codigo    |FT  = Modulo faturamento SIGAFAT.                             |
//|fonte.       |A   = Atualizações.                                           |
//|             |999 = Numero sequencial.                                      |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFTA010()
 	
 	Local aCores := {	{ 'SZY->ZY_CATEG=="G"' , 'BR_AZUL'    },;	//-- Gestor.
                     { 'SZY->ZY_CATEG=="P"' , 'BR_LARANJA' },;	//-- Participante.
                     { 'SZY->ZY_CATEG=="A"' , 'BR_AMARELO' }}	//-- Aderente.
 	
	Private cCadastro := "Cadastro de Licitações"
	Private aRotina   := { }
 
 	//-- Itens do menu.
	AAdd(aRotina, { "Pesquisar"  , "AxPesqui"   , 0, 1 })
	AAdd(aRotina, { "Visualizar" , 'AxVisual'   , 0, 2 })
	AAdd(aRotina, { "Incluir"    , 'AxInclui'   , 0, 3 })
	AAdd(aRotina, { "Alterar"    , 'AxAltera'   , 0, 4 })
	AAdd(aRotina, { "Excluir"    , 'AxDeleta'   , 0, 5 })
 	AADD(aRotina, { "Legenda"    , 'U_FTLEG010' , 0, 3 })
 	
 	//-- Abertura da tabela SZY.
	dbSelectArea("SZY")
	dbSetOrder(1)
 
 	//-- Montagem da tela de cadastro.
	mBrowse(,,,,"SZY",,,,,,aCores)
 
Return( Nil )


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |FTLEG010 |Autor: |David Alves dos Santos |Data: |09/03/2016   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Apresenta tela legenda.                                       |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function FTLEG010()
	
	Local aLegenda := {}
	
	//-- Adiciona informacoes da legenda.
	AADD(aLegenda,{"BR_AZUL"    ,"Gestor"       })
	AADD(aLegenda,{"BR_LARANJA" ,"Participante" })
	AADD(aLegenda,{"BR_AMARELO" ,"Aderente"     })
	
	//-- Apresenta janela de legenda.
	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return
