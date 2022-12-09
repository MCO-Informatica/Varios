//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

#Define nFORM_STRUCT_MODEL 1
#Define nFORM_STRUCT_VIEW  2
 
//Variáveis Estáticas
Static cTitulo := "Cadastro de Grupo de Aprovadores - Portal do Ponto Eletrônico"
 
/*/{Protheus.doc} zMVCMd1
Função para cadastro de Grupo de Produtos (SBM), exemplo de Modelo 1 em MVC
@author Atilio
@since 17/08/2015
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_zMVCMd1()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/
 
User Function CSRH040()
    Local aArea   := GetArea()
    Local oBrowse
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("PBA")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    //oBrowse:AddLegend( "SBM->BM_PROORI == '1'", "GREEN", "Original" )
    //oBrowse:AddLegend( "SBM->BM_PROORI == '0'", "RED",   "Não Original" )
     
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
     
aAdd( aRotina, { 'Visualizar', 'VIEWDEF.CSRH040', 0, 2, 0, NIL } )
aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.CSRH040', 0, 3, 0, NIL } )
aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.CSRH040', 0, 4, 0, NIL } )
aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.CSRH040', 0, 5, 0, NIL } )
aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.CSRH040', 0, 8, 0, NIL } )
aAdd( aRotina, { 'Copiar'    , 'VIEWDEF.CSRH040', 0, 9, 0, NIL } )
  
 
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
    Local oStPBA := FWFormStruct(1, "PBA")
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("CSRH040M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMPBA",/*cOwner*/,oStPBA)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'PBA_FILIAL','PBA_COD'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMPBA"):SetDescription("Formulário do Cadastro "+cTitulo)
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
    Local oModel := FWLoadModel("CSRH040")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStPBA := FWFormStruct(2, "PBA")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SBM_NOME|SBM_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_PBA", oStPBA, "FORMPBA")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_PBA', 'Dados do Grupo de Aprovadores' )  
    
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_PBA","TELA")
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    
Return oView
 