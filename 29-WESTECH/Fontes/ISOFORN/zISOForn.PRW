//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "rwmake.ch"
#INCLUDE 'TOPCONN.CH'
 
//Variáveis Estáticas
Static cTitulo := "ISO Fornecedores"
 

User Function zISOForn()
    Local aArea   := GetArea()
    Local oBrowse
     Local xCond
    Local xCond2
    Local xCond3
    
     
    xCond := "EMPTY(SA2->A2_XDTISO)" 
    xCond2 := "SA2->A2_XDTISO >= Date() .AND. !EMPTY(SA2->A2_XDTISO)"
    xCond3 := "SA2->A2_XDTISO < Date() .AND. !EMPTY(SA2->A2_XDTISO)"
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("SA2")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)

    oBrowse:AddFilter("Sem controle ISO",xCond)
    oBrowse:AddFilter("ISO Ok",xCond2)
    oBrowse:AddFilter("ISO Vencido",xCond3)
     
    //Legendas
    oBrowse:AddLegend( "EMPTY(SA2->A2_XDTISO)"                                   ,"BLUE"     ,"Sem controle ISO" )
    oBrowse:AddLegend( "SA2->A2_XDTISO >= Date() .AND. !EMPTY(SA2->A2_XDTISO)"   ,"GREEN"    ,"ISO Ok" )
    oBrowse:AddLegend( "SA2->A2_XDTISO < Date() .AND. !EMPTY(SA2->A2_XDTISO)"    ,"RED"      ,"ISO Vencido" )
    //oBrowse:AddLegend( "SBM->BM_PROORI == '0'", "RED",    "Não Original" )
     
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
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zISOFORN' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zISOLeg'     OPERATION 6                      ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zISOFORN' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zISOFORN' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCISO' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Relatorio'    ACTION 'u_FornRISO'     OPERATION 7                      ACCESS 0 //OPERATION X
 
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
    Local oStSA2 := FWFormStruct(1, "SA2")
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("zMVCISOM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMSA2",/*cOwner*/,oStSA2)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'A2_FILIAL','A2_COD'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Qualificacao "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMSA2"):SetDescription("Formulário do Cadastro "+cTitulo)
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
    Local oModel := FWLoadModel("zISOFORN")
    
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSA2 := FWFormStruct(2, "SA2")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SBM_NOME|SBM_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
    Local aStruSA2 	:= SA2->(DbStruct())
    Local cConsSA2  := "A2_COD;A2_LOJA;A2_NOME;A2_NREDUZ;A2_END;A2_BAIRRO;A2_EST;A2_COD_MUN;A2_MUN;A2_CEP;A2_TIP;A2_CGC;A2_PAIS;A2_XDTISO;A2_XCFABR;A2_XCDISTR;A2_XCREV;A2_XPMP;A2_XPIM;A2_XPIE;A2_XPINSTR;A2_XPSERV;A2_XPIDR;A2_XPMISCE;A2_XRGTISO;A2_XREQTE;A2_XREQCO;A2_XNRNCA;A2_XNRNCB;A2_XNRNCC;A2_XNRNCD;A2_XSTATUS"
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SA2", oStSA2, "FORMSA2")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SA2', 'Fornecedores' )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_SA2","TELA")

    //Percorrendo a estrutura da CTD
    For nAtual := 1 To Len(aStruSA2)
        //Se o campo atual n�o estiver nos que forem considerados
        If ! Alltrim(aStruSA2[nAtual][01]) $ cConsSA2
            oStSA2:RemoveField(aStruSA2[nAtual][01])
        EndIf
    Next
Return oView

User Function zISOLeg()
    Local aLegenda := {}
    AADD(aLegenda,{"BR_AZUL",        "Sem controle ISO"  })      
    AADD(aLegenda,{"BR_VERMELHO",    "ISO Vencido"})
    AADD(aLegenda,{"BR_VERDE",       "ISO Ok"})

     BrwLegenda("Controle ISO", "Status", aLegenda)
Return
