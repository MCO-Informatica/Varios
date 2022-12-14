//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Vari?veis Est?ticas
Static cTitulo := 'Contratos Mensalistas'
 
/*/{Protheus.doc} CadCtr
Fun??o para cadastro de Grupo de Produtos (SZ1), exemplo de Modelo 1 em MVC
@author Atilio
@since 17/08/2015
@version 1.0
    @return Nil, Fun??o n?o tem retorno
    @example
    u_CadCtr()
    @obs N?o se pode executar fun??o MVC dentro do f?rmulas
/*/

User Function CadCtr()
    Local aArea   := GetArea()
    Local oBrowse
     
    //Inst?nciando FWMBrowse - Somente com dicion?rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("SZ1")
 
    //Setando a descri??o da rotina
    oBrowse:SetDescription(cTitulo)
     
	// A=Ativo;E=Encerrado;B=Bloqueado;P=Pausado;N=Em Negociacao;C=Cancelado                                                           
    
	//Legendas
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'A'", "GREEN"	,    "Contrato Ativo" )
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'E'", "RED"	,    "Contrato Encerrado" )
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'B'", "BLUE"	,    "Contrato Bloqueado" )
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'P'", "BLACK"	,    "Contrato Pausado" )
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'N'", "YELLOW",    "Contrato em Negocia??o" )
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'C'", "BROWN" ,    "Contrato Cancelado" )
     
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Cria??o do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRotina := {}
     
	ADD OPTION aRotina TITLE OemToAnsi("Visualizar") 	ACTION "VIEWDEF.CADCTR" OPERATION 2 ACCESS 0 //STR0001:Visualizar
	ADD OPTION aRotina TITLE OemToAnsi("Incluir") 		ACTION "VIEWDEF.CADCTR" OPERATION 3 ACCESS 0 //STR0002:Incluir
	ADD OPTION aRotina TITLE OemToAnsi("Alterar") 		ACTION "VIEWDEF.CADCTR" OPERATION 4 ACCESS 0 //STR0003:Alterar
	ADD OPTION aRotina TITLE OemToAnsi("Excluir") 		ACTION "VIEWDEF.CADCTR" OPERATION 5 ACCESS 0 //STR0004:Excluir	 
    ADD OPTION aRotina TITLE OemToAnsi("Legenda")    	ACTION 'u_CtrLeg'     	OPERATION 6 ACCESS 0 //OPERATION X
 
Return aRotina
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Cria??o do modelo de dados MVC                               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Cria??o do objeto do modelo de dados
    Local oModel := Nil
     
    //Cria??o da estrutura de dados utilizada na interface
    Local oStSZ1 := FWFormStruct(1, "SZ1")
     
    //Instanciando o modelo, n?o ? recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("CadCtrM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul?rios para o modelo
    oModel:AddFields("FORMSZ1",/*cOwner*/,oStSZ1)
     
    //Setando a chave prim?ria da rotina
    oModel:SetPrimaryKey({'Z1_FILIAL','Z1_NUMCTR'})
     
    //Adicionando descri??o ao modelo
    oModel:SetDescription("Contratos Mensalistas")
     
    //Setando a descri??o do formul?rio
    oModel:GetModel("FORMSZ1"):SetDescription("Contratos Mensalistas")
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Cria??o da vis?o MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    //Cria??o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("CadCtr")
     
    //Cria??o da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSZ1 := FWFormStruct(2, "SZ1")  //pode se usar um terceiro par?metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ1_NOME|SZ1_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que ser? o retorno da fun??o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul?rios para interface
    oView:AddField("VIEW_SZ1", oStSZ1, "FORMSZ1")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t?tulo do formul?rio
    oView:EnableTitleView('VIEW_SZ1', 'Contratos Mensalistas' )  
     
    //For?a o fechamento da janela na confirma??o
    oView:SetCloseOnOk({||.T.})
     
    //O formul?rio da interface ser? colocado dentro do container
    oView:SetOwnerView("VIEW_SZ1","TELA")
Return oView
 
/*/{Protheus.doc} DscRLeg
Fun??o para mostrar a legenda das rotinas MVC com grupo de produtos
@author Atilio
@since 17/08/2015
@version 1.0
    @example
    u_DscRLeg()
/*/
 
User Function CtrLeg()
    Local aLegenda := {}
     
	// A=Ativo;E=Encerrado;B=Bloqueado;P=Pausado;N=Em Negociacao;C=Cancelado                                                           

    //Monta as cores
    AADD(aLegenda,{"BR_VERDE"	,     "Contrato Ativo"  })
    AADD(aLegenda,{"BR_VERMELHO",     "Contrato Encerrado"})
    AADD(aLegenda,{"BR_AZUL"	,     "Contrato Bloqueado"})
    AADD(aLegenda,{"BR_PRETO"	,     "Contrato Pausado"})
    AADD(aLegenda,{"BR_AMARELO"	,     "Contrato em Negocia??o"})
    AADD(aLegenda,{"BR_MARROM"	,     "Contrato Cancelado"})

    BrwLegenda("Contratos Mensalistas", "Legenda", aLegenda)
Return

