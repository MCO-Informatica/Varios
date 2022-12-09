//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Relatorio de Visita"

User Function xMVCRVA()
	Local aArea   := GetArea()
	Local oBrowse
	
	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("SZ8")
	//Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Legendas
	//oBrowse:AddLegend( "SBM->BM_PROORI == '1'", "GREEN",	"Original" )
	//oBrowse:AddLegend( "SBM->BM_PROORI == '0'", "RED",	"N�o Original" )
	
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil


Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.xMVCRVA' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Imprimir'   ACTION 'u_RELAT060'      OPERATION 6                      ACCESS 0 //OPERATION X
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.xMVCRVA' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.xMVCRVA' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.xMVCRVA' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
	
Return aRot
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
	//Cria��o do objeto do modelo de dados
	Local oModel := Nil
	
	//Cria��o da estrutura de dados utilizada na interface
	Local oStSZ8 := FWFormStruct(1, "SZ8")
	
	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("xMVCRVAM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	
	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMSZ8",/*cOwner*/,oStSZ8)
	
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'Z8_FILIAL','Z8_IDRVA'})
	
	//Adicionando descri��o ao modelo
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
	
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMSZ8"):SetDescription("Formul�rio do Cadastro "+cTitulo)
Return oModel
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()
	//Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("xMVCRVA")
	
	//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStSZ8 := FWFormStruct(2, "SZ8")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SBM_NOME|SBM_DTAFAL|'}
	
	//Criando oView como nulo
	Local oView := Nil
	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formul�rios para interface
	oView:AddField("VIEW_SZ8", oStSZ8, "FORMSZ8")
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_SZ8', 'Dados da Visita' )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_SZ8","TELA")
	

Return oView
/*/{Protheus.doc} zMVC01Leg
Fun��o para mostrar a legenda das rotinas MVC com grupo de produtos
@author Atilio
@since 17/08/2015
@version 1.0
	@example
	u_zMVC01Leg()
/*/
User Function zMVCRVALeg()
	Local aLegenda := {}
	
	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",		"Original"  })
	AADD(aLegenda,{"BR_VERMELHO",	"Nao Original"})
	
	BrwLegenda("Grupo de Produtos", "Procedencia", aLegenda)
Return
