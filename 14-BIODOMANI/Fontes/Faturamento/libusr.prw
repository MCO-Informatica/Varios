#Include 'Protheus.ch'
#Include 'FwMvcDef.ch'

User Function LIBUSR()

Local aArea   := GetArea()
Local oBrowse := FwmBrowse():New()

oBrowse:SetAlias("SZ8")
oBrowse:SetDescription("Liberação de Usuários para Faturamento")
oBrowse:Activate()

RestArea(aArea)

Return





Static Function MenuDef()
Local aRotina := FwMVCMenu("LIBUSR")

Return aRotina





Static Function ModelDef()
Local oStCabec  := FWFormModelStruct():New() //Objeto responsável pela estrutura do cabeçalho
Local oStItens  := FWFormStruct(1,"SZ8") //Objeto responsável pela estrutura dos itens, //1 para Model, 2 para View
Local bVldCom   := {|| u_GrvSZ8()} //Chamada da User Function que validará a INCLUSÃO/ALTERAÇÃO/EXCLUSÃO dos Itens
Local oModel    := MPFormModel():New("LIBUSRM",,,bVldCom,) //Objeto principal do Desenvolvimento em MVC MODELO 2, ele traz as características do dicionário de dados, bem como é o responsável pela estrutura de Tabelas, campos e registros.

//Criação da tabela temporária que será utilizada no Cabeçalho
oStCabec:AddTable("SZ8",{"Z8_FILIAL","Z8_COD","Z8_DESC"},"Cabeçalho SZ8") 

//Criação dos campos da tabela temporária
oStCabec:AddField("Filial", "Filial", "Z8_FILIAL", "C", TamSX3("Z8_FILIAL")[1], 0, Nil, Nil, {}, .F., FwBuildFeature( STRUCT_FEATURE_INIPAD, "IIF(!INCLUI,SZ8->Z8_FILIAL,FWxFilial('SZ8'))"), .T., .F., .F.) 
oStCabec:AddField("Grupo", "Grupo", "Z8_COD"   , "C", TamSX3("Z8_COD")   [1], 0, Nil, Nil, {}, .T., FwBuildFeature( STRUCT_FEATURE_INIPAD, "IIF(!INCLUI,SZ8->Z8_COD,'')"),                .T., .F., .F.) 
oStCabec:AddField("Descrição", "Descrição", "Z8_DESC", "C", TamSX3("Z8_DESC")[1], 0, Nil, Nil, {}, .T., FwBuildFeature( STRUCT_FEATURE_INIPAD, "IIF(!INCLUI,SZ8->Z8_DESC,'')"),   .T., .F., .F.) 


//Agora vamos tratar a estrutura dos Itens, que serão utilizados no Grid da aplicação

//Modificando Inicializadores Padrão, para não dar mensagem de colunas vazias
oStItens:SetProperty("Z8_COD",     MODEL_FIELD_INIT,FwBuildFeature( STRUCT_FEATURE_INIPAD, '"*"')) //Modificando Inicializadores Padrão, para não dar mensagem de colunas vazias
oStItens:SetProperty("Z8_DESC", MODEL_FIELD_INIT,FwBuildFeature( STRUCT_FEATURE_INIPAD, '"*"')) //Modificando Inicializadores Padrão, para não dar mensagem de colunas vazias

/*//Criando Gatilho para campo Nome Fornecedor posicionando de acordo com Código(Z7_FORNECE)
aTrigNUsr := FwStruTrigger("Z8_USUARIO","Z8_NOMUSR",'USRFULLNAME(M->Z8_USUARIO)',.F.)
//Adicionando o Gatilho para Estutura
oStCabec:AddTrigger(aTrigNUsr[1],aTrigNUsr[2],aTrigNUsr[3],aTrigNUsr[4])
//Criando Gatilho para campo Total pela Multiplicação entre Quantidade e Total
aTrigTotal := FwStruTrigger("Z7_PRECO","Z7_TOTAL",'Z7_PRECO * Z7_QUANT',.F.)
//Adicionando o Gatilho para Estutura
oStItens:AddTrigger(aTrigTotal[1],aTrigTotal[2],aTrigTotal[3],aTrigTotal[4])
//Criando Gatilho para campo Total pela Multiplicação entre Quantidade e Total
aTrigQuant := FwStruTrigger("Z7_QUANT","Z7_TOTAL",'Z7_PRECO * Z7_QUANT',.F.)
//Adicionando o Gatilho para Estutura
oStItens:AddTrigger(aTrigQuant[1],aTrigQuant[2],aTrigQuant[3],aTrigQuant[4])*/


//A partir de agora, eu faço a união das estruturas, vinculando o cabeçalho com os itens, também faço a vinculação da Estrutura de dados dos itens, ao modelo.
oModel:AddFields("SZ8MASTER",,oStCabec) //Faço a vinculação com o oStCabec(Cabeçalho e Itens temporários)
oModel:AddGrid("SZ8DETAIL","SZ8MASTER",oStItens,,,,,)

//Seto a relação entre Cabeçalho e Item, neste ponto, eu digo através de qual/quais campo(s) o Grid está vinculado com o cabeçalho.
aRelations := {}
aAdd(aRelations,{"Z8_FILIAL",'IIF(!INCLUI,SZ8->Z8_FILIAL,FWxFilial("SZ8"))'})
aAdd(aRelations,{"Z8_COD","SZ8->Z8_COD"})
oModel:SetRelation("SZ8DETAIL",aRelations,SZ8->(IndexKey(1)))

oModel:SetPrimaryKey({})

oModel:GetModel("SZ8DETAIL"):SetUniqueline({"Z8_ITEM"}) //O intuito é que este campo não se repita.

oModel:SetDescription("Modelo 2")

//Setamos a descrição/título que aparecerá no Cabeçalho.
oModel:GetModel("SZ8MASTER"):SetDescription("Cabeçalho da Liberação de Usuários")

//Setamos a descrição/título que aparecerá no GRID DE ITENS.
oModel:GetModel("SZ8DETAIL"):SetDescription("Itens da Liberação de Usuários")

//Finalizamos a função model
oModel:GetModel("SZ8DETAIL"):SetUseOldGrid(.T.) //Finalizo setando o modelo antigo de Grid, que permite pegar aHeader e aCols.

Return oModel



Static Function ViewDef()
Local oView     := Nil
Local oModel    := FwLoadModel("LIBUSR")
Local oStCabec  := FwFormViewStruct():New() //Objeto encarregado de montar a estrutura temporária do cabeçalho da View.
Local oStItens  := FWFormStruct(2,"SZ8") //Objeto responsável por montar a parte de estutura dos Itens/Grid , //1 para Model, 2 para View
//Local oStTotais := FWCalcStruct(oModel:GetModel('CALCTOTAL'))

//Cri dentro da estrutura 
oStCabec:AddField("Z8_COD", "01", "Grupo", X3Descric('Z8_COD'), Nil, "C", X3Picture("Z8_COD"), Nil, Nil, IIF(INCLUI,.T.,.F.), Nil, Nil, Nil, Nil, Nil, Nil, Nil, Nil)
oStCabec:AddField("Z8_DESC", "02", "Descrição", X3Descric('Z8_DESC'), Nil, "C", X3Picture("Z8_DESC"), Nil, Nil, IIF(INCLUI,.T.,.F.), Nil, Nil, Nil, Nil, Nil, Nil, Nil, Nil)

oStItens:RemoveField("Z8_COD")
oStItens:RemoveField("Z8_DESC")

oStItens:SetProperty("Z8_ITEM",MVC_VIEW_CANCHANGE,.F.)

/*Agora vamos para a segunda parte da ViewDef, onde nós amarramos as estuturas de dados, montadas acima
com o objeto oView, e passamos para a nossa aplicação todas as características visuais dos Projetos.
*/

//Instancio a classe FwFormView para o objeto View
oView := FwFormView():New()
//Passo para objeto View o modelo de dados que quero atrelar à ele Modelo + Visualização
oView:SetModel(oModel)

//Monto a estrutura de Visualização do Master e do Detalhe (Cabeçalho e Itens)
oView:AddField("VIEW_SZ8M",oStCabec,"SZ8MASTER") //Cabeçalho
oView:AddGrid("VIEW_SZ8D",oStItens,"SZ8DETAIL") //Itens/Grid

oView:AddIncrementalField("SZ8DETAIL","Z8_ITEM") //Responsável por fazer incremental no campo Item na Grid.

//Criamos a telinha, dividindo proporcionalmente o tamanho do cabeçalho e o tamanho do Grid
oView:CreateHorizontalBox("CABEC",20)
oView:CreateHorizontalBox("GRID",70)

/*Abaixo, digo para onde vão cada View Criada, VIEW_SZ7M irá para a CABEC.
VIEW_SZ7D irá para GRID... Sendo assim, eu associo o View à cada Box criado.
*/
oView:SetOwnerView("VIEW_SZ8M","CABEC")
oView:SetOwnerView("VIEW_SZ8D","GRID")

//Ativar o títulos de cada VIEW/Box criado
oView:EnableTitleView("VIEW_SZ8M","Cabeçalho Liberação de Usuários")
oView:EnableTitleView("VIEW_SZ8D","Itens Liberação de Usuários")


//Metodo que seta um Bloco de Código para verificar se a Janela deve ou não ser fechada após a execução do botão OK.
oView:SetCloseOnOk({|| .T.})

Return oView


User Function GrvSZ8()

Local aArea     := GetArea()
Local lRet      := .T.
Local oModel    := FwModelActive() //Capturo o modelo ativo, no caso o objeto de modelo(oModel) que está sendo manipulado em nossa aplicação
Local oModelCabec := oModel:GetModel("SZ8MASTER") //Criar modelo de dados MASTER/CABEÇALHO com base no Model geral que foi capturado acima
Local oModelItem := oModel:GetModel("SZ8DETAIL") //Criar modelo de dados MASTER/CABEÇALHO com base no Model geral que foi capturado acima

//Carregar os dados do Cabeçalho, através do Método GetValue
Local cFilSZ8      := oModelCabec:GetValue("Z8_FILIAL")
Local cNum         := oModelCabec:GetValue("Z8_COD")
Local cDesc        := oModelCabec:GetValue("Z8_DESC")


//Variáveis que farão a captura dos dados com base no aHeader e aCols
Local aHeaderAux   := oModelItem:aHeader
Local aColsAux     := oModelItem:aCols

//Precisamos agora pegar a posição de cada campo dentro do grid
Local nPosItem     := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z8_ITEM")})
Local nPosUsr      := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z8_USUARIO")})
Local nDesUsr      := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z8_NOMUSR")})


//Preciso pegar a linha atual que o usuário está posicionado, para isso usarei uma variável.
Local nLinAtu      := 0



//Preciso identificar qual o tipo de operação que o usuário está fazendo (INCLUSÃO/ALTERAÇÃO/EXCLUSÃO)
Local cOption      := oModelCabec:GetOperation()

//Fazemos a seleção da nossa área que será manipulada, ou seja, colocamos a tabela SZ7, em evidência juntamente com um índice de ordenação.
dbSelectArea("SZ8")
SZ8->(DbSetOrder(1))

//Se a operação que está sendo feita, for uma inserção, ele fará a inserção.
IF cOption == MODEL_OPERATION_INSERT
    For nLinAtu := 1 to Len(aColsAux) //Mede o tamanho do aCols, ou seja, quantos itens existem no Grid.
    //Porém, antes de tentar inserir, eu devo verificar, se a Linha está deletada.
        IF !aColsAux[nLinAtu][Len(aHeaderAux)+1] //Expressão para verificar se uma linha está excluída no aCols.
            Reclock("SZ8",.T.) //.T. para inclusão .F. para alteração/exclusão
                //DADOS DO CABEÇALHO
                Z8_FILIAL   := cFilSZ8
                Z8_COD      := cNum
                Z8_DESC     := cDesc
                
                //DADOS DO GRID
                Z8_ITEM     := aColsAux[nLinAtu,nPosItem]
                Z8_USUARIO  := aColsAux[nLinAtu,nPosUsr]
                Z8_NOMUSR   := aColsAux[nLinAtu,nDesUsr]
            SZ8->(MSUNLOCK())
        ENDIF
    Next n //Incremento de Linha do For.

ELSEIF cOption == MODEL_OPERATION_UPDATE

    For nLinAtu := 1 to Len(aColsAux) //Mede o tamanho do aCols, ou seja, quantos itens existem no Grid.
    //Porém, antes de tentar inserir, eu devo verificar, se a Linha está deletada.
        IF aColsAux[nLinAtu][Len(aHeaderAux)+1] //Expressão para verificar se uma linha está excluída no aCols.
            //Se a linha estiver deletada, eu ainda preciso verificar se a linha está incluso no sistema ou não.   
            SZ8->(DbSetOrder(2))//ÍNDICE FILIAL+NUMEROPEDIDO+ITEM
            IF SZ8->(DbSeek(cFilSZ8+cNum+aColsAux[nLinAtu,nPosItem])) //Faz a busca, se encontrar, ele deve deletar do banco
                Reclock("SZ8",.F.) //.T. para inclusão .F. para alteração/exclusão
                    DbDelete()
                SZ8->(MSUNLOCK())
            ENDIF
        ELSE //Se a linha não estiver excluída, faço a Alteração
        //Embora seja uma alteração, eu posso ter novos itens inclusos no meu pedido, sendo assim, preciso validar se estes itens existem no banco de dados ou não
        //caso eles não existam, eu faço uma INCLUSÃO RECLOCK("SZ7",.T.)
            SZ8->(DbSetOrder(2))//ÍNDICE FILIAL+NUMEROPEDIDO+ITEM
            IF SZ8->(DbSeek(cFilSZ8 + cNum + aColsAux[nLinAtu,nPosItem])) //Faz a busca, se encontrar, ele deve deletar do banco
                Reclock("SZ8",.F.) //.T. para inclusão .F. para alteração/exclusão
                    //DADOS DO CABEÇALHO
                    Z8_FILIAL   := cFilSZ8
                    Z8_COD      := cNum
                    Z8_DESC     := cDesc

                    //DADOS DO GRID
                    Z8_ITEM     := aColsAux[nLinAtu,nPosItem]
                    Z8_USUARIO  := aColsAux[nLinAtu,nPosUsr]
                    Z8_NOMUSR   := aColsAux[nLinAtu,nDesUsr]
                SZ8->(MSUNLOCK())
            ELSE
                Reclock("SZ8",.T.) //.T. para inclusão .F. para alteração/exclusão
                    //DADOS DO CABEÇALHO
                    Z8_FILIAL   := cFilSZ8
                    Z8_COD      := cNum
                    Z8_DESC     := cDesc

                    //DADOS DO GRID
                    Z8_ITEM     := aColsAux[nLinAtu,nPosItem]
                    Z8_USUARIO  := aColsAux[nLinAtu,nPosUsr]
                    Z8_NOMUSR   := aColsAux[nLinAtu,nDesUsr]
                SZ8->(MSUNLOCK())
            ENDIF
        ENDIF
    Next n //Incremento de Linha do For.

ELSEIF cOption == MODEL_OPERATION_DELETE
    SZ8->(DbSetOrder(1)) //FILIAL + NUMEROPEDIDO
    /*Ele vai percorrer todo arquivo, e enquanto a filial for igual a do pedido e o número do pedido for igual ao número que está posicionado para excluir(pedido que você quer excluir)
      ele fará a DELEÇÃO/EXCLUSÃO dos Registros.
    */
    WHILE !SZ8->(EOF()) .AND. SZ8->Z8_FILIAL = cFilSZ8 .AND. SZ8->Z8_COD = cNum
        RECLOCK("SZ8",.F.) // PARÂMETRO FALSE PORQUE É EXCLUSÃO
            DbDelete()
        SZ8->(MSUNLOCK())
    
    SZ8->(dbSkip())
    ENDDO

ENDIF

RestArea(aArea)

Return lRet
