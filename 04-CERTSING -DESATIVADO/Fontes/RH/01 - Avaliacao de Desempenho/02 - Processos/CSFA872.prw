#Include "Totvs.ch"
#Include "FwMvcDef.ch"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFA872  |Autor: |David Alves dos Santos |Data: |08/03/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Rotina de cadastro: Usuário x Atributo do domínio.            |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFA872()
	
	Private cDescr  := "Usuário x Atributo do domínio"
	Private aRotina := MenuDef()
	Private oBrowse := FwMBrowse():New() //-- Variavel de Browse
	
	//Alias do Browse
	oBrowse:SetAlias('ZZM')
	
	//Descrição da Parte Superior Esquerda do Browse
	oBrowse:SetDescripton(cDescr) 

	//Habilita os Botões Ambiente e WalkThru
	oBrowse:SetWalkThru(.T.)

	//Ativa o Browse
	oBrowse:Activate()

Return


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFA872  |Autor: |David Alves dos Santos |Data: |08/03/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Definição do menu.                                            |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function MenuDef()

	Local aRotina :=	{}
	
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'         OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CSFA872' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CSFA872' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CSFA872' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CSFA872' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.CSFA872' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CSFA872' OPERATION 9 ACCESS 0
	
Return( aRotina )


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |ModelDef |Autor: |David Alves dos Santos |Data: |08/03/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Definição do modelo de dados.                                 |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function ModelDef()

	//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local oStruct	:=	FWFormStruct(1,"ZZM") 
	Local oModel

	//Instancia do Objeto de Modelo de Dados
	oModel	:=	MpFormModel():New('PECFA872',/*Pre-Validacao*/,/*Pos-Validacao*/;
                                       ,/*Commit*/,/*Cancel*/)

	//Adiciona um modelo de Formulario de Cadastro Similar à Enchoice ou Msmget
	oModel:AddFields('ID_FLD_CSFA872', /*cOwner*/, oStruct, /*bPreValidacao*/;
                       , /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetPrimaryKey( {"ZZM_FILIAL", "ZZM_CPF"} )

	//Adiciona Descricao do Modelo de Dados
	oModel:SetDescription( cDescr )
	
	//Adiciona Descricao do Componente do Modelo de Dados      
	cTexto := 'Formulario de  Cadastro'
	oModel:GetModel( 'ID_FLD_CSFA872' ):SetDescription( cTexto )

Return( oModel )


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |ViewDef  |Autor: |David Alves dos Santos |Data: |08/03/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Definição da camada de visualização.                          |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function ViewDef()

	Local oStruct	:=	FWFormStruct(2,"ZZM") 	//Retorna a Estrutura do Alias passado
	Local oModel	:=	FwLoadModel('CSFA872')	//Retorna o Objeto do Modelo de Dados 
	Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualização

	//Define o Modelo sobre qual a Visualizacao sera utilizada
	oView:SetModel(oModel)	

	//Vincula o Objeto visual de Cadastro com o modelo 
	oView:AddField( 'ID_VIEW_CSFA872', oStruct, 'ID_FLD_CSFA872')

	//Define o Preenchimento da Janela
	oView:CreateHorizontalBox( 'ID_HTOP'  , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'ID_VIEW_CSFA872', 'ID_HTOP' )

Return( oView )