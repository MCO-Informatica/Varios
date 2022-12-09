#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

//---------------------------------------------------------------------------------
// Rotina | RCOMF01        | Autor | Lucas Baia          | Data |    26/04/2022	
//---------------------------------------------------------------------------------
// Descr. | Fonte Customizado em MVC para Cadastro de Fornecedor chamando a tabela
//        | SA2, a necessidade foi por causa da Inclusão de Legendas(Semáforos).
//---------------------------------------------------------------------------------
// Uso    | ADHESPACK COSMETICOS.
//---------------------------------------------------------------------------------


User Function RCOMF01()

Local aArea := GetNextAlias()
Local oBrowserSA2 //Objeto que receberá o instanciamento da Classe FwmBrowser

oBrowserSA2 := FwmBrowse():New()

oBrowserSA2:SetAlias("SA2")

oBrowserSA2:SetDescription("Cadastro de Fornecedor")

oBrowserSA2:AddLegend("SA2->A2_XSTATUS =='1'", "GREEN"     , "Fornecedor Aprovado")
oBrowserSA2:AddLegend("SA2->A2_XSTATUS =='2'", "RED"       , "Fornecedor Rejeitado")
oBrowserSA2:AddLegend("SA2->A2_XSTATUS =='3'", "BLUE"      , "Fornecedor em processo de Homologação")

oBrowserSA2:Activate()

//RestArea(aArea)

Return

Static Function ModelDef()

Local oModel := Nil
Local oStructSA2 := FwFormStruct(1,"SA2") //Traz a estrutura da SZ9(Tabela e Características dos campos), PARA O MODELO, por isso o Parâmetro 1 no início.
oModel := MpFormModel():New("RCOMF01M")
oModel:AddFields("FORMSA2",,oStructSA2) //Atribuindo formulário para o Modelo de Dados.
oModel:SetPrimaryKey({"A2_FILIAL","A2_COD","A2_LOJA"}) //Definindo chave primária para aplicação.
oModel:SetDescription("Cadastro do Fornecedor")

Return oModel


Static Function ViewDef()

Local oView := Nil
Local oModel := FwLoadModel("RCOMF01") //Função que retorna um objeto de Model de determinado Fonte.
Local oStructSA2 := FwFormStruct(2,"SA2") //Traz a Estrutura da tabela (1 - Model, 2 - View)
oView := FwFormView():New() //Construindo a parte de Visão dos Dados
oView:SetModel(oModel)
oView:AddField("VIEWSA2",oStructSA2,"FORMSA2") //Atribuição da estrutura de dados à camada de Visão
oView:CreateHorizontalBox("TELA",100) //Criando um contaner com o Identificador TELA
//oView:EnableTitleView("VIEWSA2","Visualização dos Protheuzeiros(as)") //Adicionando título ao Formulário
oView:SetCloseOnOk({|| .T.}) //Força o fechamento da Janela, PASSANDO O PARÂMETRO .T.
oView:SetOwnerView("VIEWSA2","TELA")

Return oView


Static Function MenuDef()

Local aRotina := {}
Local aSubMnuLiberacoes := {}

ADD OPTION aSubMnuLiberacoes TITLE 'Aprovar'        ACTION 'U_SA2APROV'    OPERATION 6 ACCESS 0 
ADD OPTION aSubMnuLiberacoes TITLE 'Rejeitar'       ACTION 'U_SA2REJEITA'  OPERATION 6 ACCESS 0
ADD OPTION aSubMnuLiberacoes TITLE 'Homologar'      ACTION 'U_SA2HOMOLOG'  OPERATION 6 ACCESS 0

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.RCOMF01' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.RCOMF01' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.RCOMF01' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.RCOMF01' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Legenda'    ACTION 'U_SA2LEG'        OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.RCOMF01' OPERATION 9 ACCESS 0
ADD OPTION aRotina TITLE 'Liberacoes' ACTION aSubMnuLiberacoes OPERATION 9 ACCESS 0

/*
1 - Pesquisar
2 - Visualizar
3 - Incluir
4 - Alterar 
5 - Excluir
6 - Outras Funções
9 - Copiar
*/

Return aRotina


User Function SA2LEG()

Local aLegenda := {}

aAdd(aLegenda,{"BR_VERDE"       ,"Fornecedor Aprovado"})
aAdd(aLegenda,{"BR_VERMELHO"    ,"Fornecedor Rejeitado"})
aAdd(aLegenda,{"BR_AZUL"        ,"Fornecedor em processo de Homologação"})

BrwLegenda("Legendas",,aLegenda)

Return aLegenda



User Function SA2APROV()

Local cUser         := RetCodUsr()
Local lRet          := .T.
Local aArea         := GetArea()

dbSelectArea("SA2")
SA2->(DbSetOrder(1))

IF !cUser $ "000016/000020/000013" //UPDUO01/BARBARA.MANZONI/RICARDO.CAMARGO
    lRet := .F.
    Help(NIL,NIL,"USRNOPEMISSION",NIL,"Usuário não permitido!.",1, 0, NIL, NIL, NIL, NIL, NIL,{"Apenas Usuários Responsáveis que podem Aprovar."})
ELSE
    IF MsgYesNo("Deseja aprovar o Fornecedor "+Alltrim(SA2->A2_NOME)+" ?", "ATENÇÃO")
        IF SA2->(DbSeek(xFilial("SA2")+SA2->A2_COD+SA2->A2_LOJA))
            RecLock("SA2", .F.)
                SA2->A2_XSTATUS := "1"
                SA2->A2_XDTAPRO := Date()
                SA2->A2_MSBLQL  := "2"
            SA2->(MsUnlock())
        ENDIF
        Help(NIL,NIL,"OPERATIONSUCCESS",NIL,"Fornecedor aprovado com sucesso!",1, 0, NIL, NIL, NIL, NIL, NIL,{""})
    ELSE
        Help(NIL,NIL,"OPERATIONCANCELED",NIL,"Operação Cancelada pelo Usuário!",1, 0, NIL, NIL, NIL, NIL, NIL,{""})
    ENDIF
ENDIF

RestArea(aArea)

Return



User Function SA2REJEITA()

Local cUser         := RetCodUsr()
Local lRet          := .T.
Local aArea         := GetArea()

dbSelectArea("SA2")
SA2->(DbSetOrder(1))

IF !cUser $ "000016/000020/000013" //UPDUO01/BARBARA.MANZONI/RICARDO.CAMARGO
    lRet := .F.
    Help(NIL,NIL,"USRNOPEMISSION",NIL,"Usuário não permitido!.",1, 0, NIL, NIL, NIL, NIL, NIL,{"Apenas Usuários Responsáveis que podem Rejeitar."})
ELSE
    IF MsgYesNo("Deseja rejeitar o Fornecedor "+Alltrim(SA2->A2_NOME)+" ?", "ATENÇÃO")
        IF SA2->(DbSeek(xFilial("SA2")+SA2->A2_COD+SA2->A2_LOJA))
            RecLock("SA2", .F.)
                SA2->A2_XSTATUS := "2"
                SA2->A2_XDTREJE := Date()
                SA2->A2_MSBLQL  := "1"
            SA2->(MsUnlock())
        ENDIF
        Help(NIL,NIL,"OPERATIONSUCCESS",NIL,"Fornecedor rejeitado com sucesso!",1, 0, NIL, NIL, NIL, NIL, NIL,{""})
    ELSE
        Help(NIL,NIL,"OPERATIONCANCELED",NIL,"Operação Cancelada pelo Usuário!",1, 0, NIL, NIL, NIL, NIL, NIL,{""})
    ENDIF
ENDIF

RestArea(aArea)

Return


User Function SA2HOMOLOG()

Local cUser         := RetCodUsr()
Local lRet          := .T.
Local aArea         := GetArea()

dbSelectArea("SA2")
SA2->(DbSetOrder(1))

IF !cUser $ "000016/000020/000013" //UPDUO01/BARBARA.MANZONI/RICARDO.CAMARGO
    lRet := .F.
    Help(NIL,NIL,"USRNOPEMISSION",NIL,"Usuário não permitido!.",1, 0, NIL, NIL, NIL, NIL, NIL,{"Apenas Usuários Responsáveis que podem Homologar."})
ELSE
    IF MsgYesNo("Deseja homologar o Fornecedor "+Alltrim(SA2->A2_NOME)+" ?", "ATENÇÃO")
        IF SA2->(DbSeek(xFilial("SA2")+SA2->A2_COD+SA2->A2_LOJA))
            RecLock("SA2", .F.)
                SA2->A2_XSTATUS := "3"
                SA2->A2_XDTHOMG := Date()
                SA2->A2_MSBLQL  := "1"
            SA2->(MsUnlock())
        ENDIF
        Help(NIL,NIL,"OPERATIONSUCCESS",NIL,"Fornecedor homologado com sucesso!",1, 0, NIL, NIL, NIL, NIL, NIL,{""})
    ELSE
        Help(NIL,NIL,"OPERATIONCANCELED",NIL,"Operação Cancelada pelo Usuário!",1, 0, NIL, NIL, NIL, NIL, NIL,{""})
    ENDIF
ENDIF

RestArea(aArea)

Return
