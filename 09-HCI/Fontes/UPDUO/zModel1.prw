#Include 'Protheus.ch'
#Include "TopConn.ch"

#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := "Saldos de Ativos"


/*/{Protheus.doc} zModel1
Exemplo de Modelo 1 para cadastro de Artistas
@author Atilio
@since 31/07/2016
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_zModel1()
/*/
 
User Function zModel1()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
     
    SetFunName("ZMODEL1")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("SN3")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Filtrando
    //oBrowse:SetFilterDefault("SN3->SN3_COD >= '000000' .And. SN3->SN3_COD <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zModel1' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zModel1' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zModel1' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zModel1' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    Local oStSN3 := FWFormStruct(1, "SN3")
     /*
    //Editando características do dicionário
    oStSN3:SetProperty('SN3_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    oStSN3:SetProperty('SN3_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("SN3", "SN3_COD")'))         //Ini Padrão
    oStSN3:SetProperty('SN3_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->SN3_DESC), .F., .T.)'))   //Validação de Campo
    oStSN3:SetProperty('SN3_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     */
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("zModel1M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMSN3",/*cOwner*/,oStSN3)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'N3_FILIAL','N3_CBASE'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMSN3"):SetDescription("Formulário do Cadastro "+cTitulo)
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    //Local aStruSN3    := SN3->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("zModel1")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSN3 := FWFormStruct(2, "SN3")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SSN3_NOME|SSN3_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SN3", oStSN3, "FORMSN3")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SN3', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_SN3","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruSN3)
        cCampoAux := Alltrim(aStruSN3[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "SN3_COD;"
            oStSN3:RemoveField(cCampoAux)
        EndIf
    Next
    */
Return oView
 