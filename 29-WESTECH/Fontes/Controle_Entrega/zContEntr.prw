//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Vari?veis Est?ticas
Static cTitulo := "Controle de Entrega de Material"
 
/*/{Protheus.doc} zModel1
Exemplo de Modelo 1 para cadastro de Artistas
@author Atilio
@since 31/07/2016
@version 1.0
    @return Nil, Fun??o n?o tem retorno
    @example
    u_zModel1()
/*/
 
User Function zContEntr()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
     
    SetFunName("zContEntr")
     
    //Inst?nciando FWMBrowse - Somente com dicion?rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("ZZO")
 
    //Setando a descri??o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    //oBrowse:AddLegend( "ZZ1->ZZ1_COD <= '000005'", "GREEN",    "Menor ou igual a 5" )
    //oBrowse:AddLegend( "ZZ1->ZZ1_COD >  '000005'", "RED",    "Maior que 5" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("ZZ1->ZZ1_COD >= '000000' .And. ZZ1->ZZ1_COD <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria??o do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando op??es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zContEntr' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMod1Leg'      OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zContEntr' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zContEntr' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zContEntr' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria??o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Cria??o do objeto do modelo de dados
    Local oModel := Nil
     
    //Cria??o da estrutura de dados utilizada na interface
    Local oStZZO := FWFormStruct(1, "ZZO")
     
    //Editando caracter?sticas do dicion?rio
    oStZZO:SetProperty('ZZO_IDENTR',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi??o
    oStZZO:SetProperty('ZZO_IDENTR',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZO", "ZZO_IDENTR")'))         //Ini Padr?o
    //oStZZ1:SetProperty('ZZ1_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZZ1_DESC), .F., .T.)'))   //Valida??o de Campo
    //;;oStZZ1:SetProperty('ZZ1_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigat?rio
     
    //Instanciando o modelo, n?o ? recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("zContEntrM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul?rios para o modelo
    oModel:AddFields("FORMZZO",/*cOwner*/,oStZZO)
     
    //Setando a chave prim?ria da rotina
    oModel:SetPrimaryKey({'ZZO_FILIAL','ZZO_IDENTR'})
     
    //Adicionando descri??o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descri??o do formul?rio
    oModel:GetModel("FORMZZO"):SetDescription("Formul?rio do Cadastro "+cTitulo)
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria??o da vis?o MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local aStruZZO    := ZZO->(DbStruct())
     
    //Cria??o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("zContEntr")
     
    //Cria??o da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStZZO := FWFormStruct(2, "ZZO")  //pode se usar um terceiro par?metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que ser? o retorno da fun??o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul?rios para interface
    oView:AddField("VIEW_ZZO", oStZZO, "FORMZZO")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t?tulo do formul?rio
    oView:EnableTitleView('VIEW_ZZO', 'Dados - '+cTitulo )  
     
    //For?a o fechamento da janela na confirma??o
    oView:SetCloseOnOk({||.T.})
     
    //O formul?rio da interface ser? colocado dentro do container
    oView:SetOwnerView("VIEW_ZZO","TELA")
     
    /*
    //Tratativa para remover campos da visualiza??o
    For nAtual := 1 To Len(aStruZZ1)
        cCampoAux := Alltrim(aStruZZ1[nAtual][01])
         
        //Se o campo atual n?o estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "ZZ1_COD;"
            oStZZ1:RemoveField(cCampoAux)
        EndIf
    Next
    */
Return oView
 
/*/{Protheus.doc} zMod1Leg
Fun??o para mostrar a legenda
@author Atilio
@since 31/07/2016
@version 1.0
    @example
    u_zMod1Leg()
/*/
 
User Function zMod1Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "Menor ou igual a 5"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Maior que 5"})
     
    BrwLegenda(cTitulo, "Status", aLegenda)
Return
