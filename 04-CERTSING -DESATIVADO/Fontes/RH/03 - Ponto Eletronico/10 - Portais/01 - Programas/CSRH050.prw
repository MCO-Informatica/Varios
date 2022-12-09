//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

#Define nFORM_STRUCT_MODEL 1
#Define nFORM_STRUCT_VIEW  2

//Vari�veis Est�ticas
Static cTitulo := "Cadastro de Aprovadores - Portal do Ponto Eletr�nico"

/*/{Protheus.doc} zMVCMd1
Fun��o para cadastro de Grupo de Produtos (SBM), exemplo de Modelo 1 em MVC
@author Atilio
@since 17/08/2015
@version 1.0
    @return Nil, Fun��o n�o tem retorno
    @example
    u_zMVCMd1()
    @obs N�o se pode executar fun��o MVC dentro do f�rmulas
/*/

User Function CSRH050()
    Local aArea   := GetArea()
    Local oBrowse

    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()

    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("PB9")

    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)

    //Legendas
    //oBrowse:AddLegend( "SBM->BM_PROORI == '1'", "GREEN", "Original" )
    //oBrowse:AddLegend( "SBM->BM_PROORI == '0'", "RED",   "N�o Original" )

    //Ativa a Browse
    oBrowse:Activate()

    RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function MenuDef()
    Local aRot := {}

    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CSRH050' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.CSRH050' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.CSRH050' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.CSRH050' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Copiar'     ACTION 'VIEWDEF.CSRH030' OPERATION 9 					 ACCESS 0 //OPERATION 9

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
    Local oStPB9 := FWFormStruct(nFORM_STRUCT_MODEL, "PB9")

    //Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("CSRH050M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/)

    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMPB9",/*cOwner*/,oStPB9)

    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'PB9_FILIAL','PB9_COD'})

    //Adicionando descri��o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)

    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMPB9"):SetDescription("Formul�rio do Cadastro "+cTitulo)
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
    Local oModel := FWLoadModel("CSRH050")

    //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStPB9 := FWFormStruct(nFORM_STRUCT_VIEW, "PB9")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SBM_NOME|SBM_DTAFAL|'}

    //Criando oView como nulo
    Local oView := Nil

    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)

    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_PB9", oStPB9, "FORMPB9")

    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)

    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_PB9', 'Dados do Grupo de Aprovadores' )

    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})

    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_PB9","TELA")
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