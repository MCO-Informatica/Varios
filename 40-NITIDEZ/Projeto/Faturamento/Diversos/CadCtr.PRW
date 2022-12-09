//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := 'Contratos Mensalistas'
 
/*/{Protheus.doc} CadCtr
Função para cadastro de Grupo de Produtos (SZ1), exemplo de Modelo 1 em MVC
@author Atilio
@since 17/08/2015
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_CadCtr()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/

User Function CadCtr()
    Local aArea   := GetArea()
    Local oBrowse
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("SZ1")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
	// A=Ativo;E=Encerrado;B=Bloqueado;P=Pausado;N=Em Negociacao;C=Cancelado                                                           
    
	//Legendas
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'A'", "GREEN"	,    "Contrato Ativo" )
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'E'", "RED"	,    "Contrato Encerrado" )
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'B'", "BLUE"	,    "Contrato Bloqueado" )
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'P'", "BLACK"	,    "Contrato Pausado" )
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'N'", "YELLOW",    "Contrato em Negociação" )
    oBrowse:AddLegend( "SZ1->Z1_STATUS == 'C'", "BROWN" ,    "Contrato Cancelado" )
     
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação do menu MVC                                          |
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
 | Desc:  Criação do modelo de dados MVC                               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    Local oStSZ1 := FWFormStruct(1, "SZ1")
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("CadCtrM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMSZ1",/*cOwner*/,oStSZ1)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'Z1_FILIAL','Z1_NUMCTR'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Contratos Mensalistas")
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMSZ1"):SetDescription("Contratos Mensalistas")
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("CadCtr")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSZ1 := FWFormStruct(2, "SZ1")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ1_NOME|SZ1_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SZ1", oStSZ1, "FORMSZ1")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SZ1', 'Contratos Mensalistas' )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_SZ1","TELA")
Return oView
 
/*/{Protheus.doc} DscRLeg
Função para mostrar a legenda das rotinas MVC com grupo de produtos
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
    AADD(aLegenda,{"BR_AMARELO"	,     "Contrato em Negociação"})
    AADD(aLegenda,{"BR_MARROM"	,     "Contrato Cancelado"})

    BrwLegenda("Contratos Mensalistas", "Legenda", aLegenda)
Return

