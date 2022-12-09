//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

#Define nFORM_STRUCT_MODEL  1
#Define nFORM_STRUCT_VIEW   2

//Variáveis Estáticas
Static cTitulo := "Lista de processamento das mensagens do HUB"

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

User Function VNDA770()
    Local aArea   := GetArea()
    Local oBrowse
    Local cVldErro := " ( PC3_ENPEGA == '0' .Or. PC3_STAVLD == '0' .Or. PC3_STAVER == '0' .Or. PC3_STAEMI == '0' ) "
    Local cVldFila := " ( PC3_ENPEGA == '2' .Or. PC3_STAVLD == '2' .Or. PC3_STAVER == '2' .Or. PC3_STAEMI == '2' ) "

    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()

    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("PC3")

    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)

    //Legendas
    oBrowse:AddLegend( cVldErro, "RED"   , "Erro"    )
    oBrowse:AddLegend( cVldFila, "YELLOW", "Em Fila" )
    oBrowse:AddLegend( "!" + cVldErro + " .And. " + "!" + cVldFila, "GREEN", "Processado" )

    //Ativa a Browse
    oBrowse:DisableDetails()

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
    Local aRot := {}

    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar'              ACTION 'VIEWDEF.VNDA770' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'                 ACTION 'VIEWDEF.VNDA770' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'                 ACTION 'VIEWDEF.VNDA770' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'                 ACTION 'VIEWDEF.VNDA770' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Reprocessar em Lote'     ACTION 'U_VNDA771'       OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4

Return aRot

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
    Local oStPC3 := FWFormStruct(nFORM_STRUCT_MODEL, "PC3")

    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("VNDA770M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/)

    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMPC3",/*cOwner*/,oStPC3)

    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'PC3_FILIAL','PC3_COD'})

    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)

    //Setando a descrição do formulário
    oModel:GetModel("FORMPC3"):SetDescription("Formulário do Cadastro "+cTitulo)
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
    Local oModel := FWLoadModel("VNDA770")

    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStPC3 := FWFormStruct(nFORM_STRUCT_VIEW, "PC3")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SBM_NOME|SBM_DTAFAL|'}

    //Criando oView como nulo
    Local oView := Nil

    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)

    //Atribuindo formulários para interface
    oView:AddField("VIEW_PC3", oStPC3, "FORMPC3")

    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)

    //Colocando título do formulário
    oView:EnableTitleView('VIEW_PC3', 'Dados do Grupo de Aprovadores' )

    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})

    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_PC3","TELA")
Return oView

/*
Static Function VldAlter( oModel )
Local nOperation := oModel:GetOperation()
Local lRet := .T.

If nOperation == MODEL_OPERATION_UPDATE .or. nOperation == MODEL_OPERATION_DELETE
   If Empty( oModel:GetValue( 'ZA0MASTER', 'ZA0_DTAFAL' ) )
      Help( ,, 'HELP',, 'Informe a data', 1, 0)
      lRet := .F.
   EndIf
EndIf

Return lRet
*/

User Function VNDA771()
    local oHUB := ProcessamentoHUB():New()
	oHUB:ProcessarVisual()
Return
