#Include 'Protheus.ch'
#Include 'FwMvcDef.ch'

//Fonte criado para Construção da Tela de Estruturas de Produtos Pai x Filho.
//Autor = Lucas Baía
User Function xEstPr()

Local aArea   := GetArea()
Local oBrowse := FwmBrowse():New()

oBrowse:SetAlias("SZ9")
oBrowse:SetDescription("Estruturas de Produtos Pai x Filho")
oBrowse:Activate()

RestArea(aArea)

Return





Static Function MenuDef()
Local aRotina := FwMVCMenu("xEstPr")

Return aRotina





Static Function ModelDef()
Local oStCabec  := FWFormModelStruct():New() //Objeto responsável pela estrutura do cabeçalho
Local oStItens  := FWFormStruct(1,"SZ9") //Objeto responsável pela estrutura dos itens, //1 para Model, 2 para View
Local bVldCom   := {|| u_GrvSZ9()} //Chamada da User Function que validará a INCLUSÃO/ALTERAÇÃO/EXCLUSÃO dos Itens
Local oModel    := MPFormModel():New("ESTPROD",,,bVldCom,) //Objeto principal do Desenvolvimento em MVC MODELO 2, ele traz as características do dicionário de dados, bem como é o responsável pela estrutura de Tabelas, campos e registros.


//Criação da tabela temporária que será utilizada no Cabeçalho
oStCabec:AddTable("SZ9",{"Z9_FILIAL","Z9_CODPPAI","Z9_DESPPAI"},"Cabeçalho SZ9") 

//Criação dos campos da tabela temporária
oStCabec:AddField("Filial", "Filial", "Z9_FILIAL", "C", TamSX3("Z9_FILIAL")[1], 0, Nil, Nil, {}, .F., FwBuildFeature( STRUCT_FEATURE_INIPAD, "IIF(!INCLUI,SZ9->Z9_FILIAL,FWxFilial('SZ9'))"), .T., .F., .F.) 
oStCabec:AddField("Código Kit", "Código Kit", "Z9_CODPPAI"   , "C", TamSX3("Z9_CODPPAI")   [1], 0, Nil, Nil, {}, .T., FwBuildFeature( STRUCT_FEATURE_INIPAD, "IIF(!INCLUI,SZ9->Z9_CODPPAI,'')"), .T., .F., .F.) 
oStCabec:AddField("Descrição Kit", "Descrição Kit", "Z9_DESPPAI", "C", TamSX3("Z9_DESPPAI")[1], 0, Nil, Nil, {}, .T., FwBuildFeature( STRUCT_FEATURE_INIPAD, "IIF(!INCLUI,SZ9->Z9_DESPPAI,'')"),   .T., .F., .F.) 


//Agora vamos tratar a estrutura dos Itens, que serão utilizados no Grid da aplicação

//Modificando Inicializadores Padrão, para não dar mensagem de colunas vazias
oStItens:SetProperty("Z9_CODPPAI",     MODEL_FIELD_INIT,FwBuildFeature( STRUCT_FEATURE_INIPAD, '"*"')) //Modificando Inicializadores Padrão, para não dar mensagem de colunas vazias
oStItens:SetProperty("Z9_DESPPAI", MODEL_FIELD_INIT,FwBuildFeature( STRUCT_FEATURE_INIPAD, '"*"')) //Modificando Inicializadores Padrão, para não dar mensagem de colunas vazias

//Colocando para validar se existe o Registro ou não.
oStCabec:SetProperty("Z9_CODPPAI",MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, 'ExistCpo("SB1")'))

//oStCabec:SetProperty("Z9_CODPPAI",MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, 'ExistChav("SZ9",FwFldGet("Z9_CODPPAI"))'))

//Criando Gatilho para campo Nome Produto posicionando de acordo com Código(Z9_CODPPAI)
aTrigProd := FwStruTrigger("Z9_CODPPAI","Z9_DESPPAI",'Posicione("SB1",1,xFilial("SB1")+FwFldGet("Z9_CODPPAI"),"SB1->B1_DESC")',.F.)
//Adicionando o Gatilho para Estutura
oStCabec:AddTrigger(aTrigProd[1],aTrigProd[2],aTrigProd[3],aTrigProd[4])

//aTrigPro := FwStruTrigger("Z9_CODPPAI","Z9_CODPPAI",'ExistCpo("SZ9")',.F.)
//Adicionando o Gatilho para Estutura
//oStCabec:AddTrigger(aTrigPro[1],aTrigPro[2],aTrigPro[3],aTrigPro[4])


//A partir de agora, eu faço a união das estruturas, vinculando o cabeçalho com os itens, também faço a vinculação da Estrutura de dados dos itens, ao modelo.
oModel:AddFields("SZ9MASTER",,oStCabec) //Faço a vinculação com o oStCabec(Cabeçalho e Itens temporários)
oModel:AddGrid("SZ9DETAIL","SZ9MASTER",oStItens,,,,,)

//Seto a relação entre Cabeçalho e Item, neste ponto, eu digo através de qual/quais campo(s) o Grid está vinculado com o cabeçalho.
aRelations := {}
aAdd(aRelations,{"Z9_FILIAL",'IIF(!INCLUI,SZ9->Z9_FILIAL,FWxFilial("SZ9"))'})
aAdd(aRelations,{"Z9_CODPPAI","SZ9->Z9_CODPPAI"})
oModel:SetRelation("SZ9DETAIL",aRelations,SZ9->(IndexKey(2)))

oModel:SetPrimaryKey({})

oModel:GetModel("SZ9DETAIL"):SetUniqueline({"Z9_ITEM"}) //O intuito é que este campo não se repita.
oModel:GetModel("SZ9DETAIL"):SetUniqueline({"Z9_CPFILHO"}) //O intuito é que este campo não se repita.

oModel:SetDescription("Estruturas de Produtos Pai x Filho")

//Setamos a descrição/título que aparecerá no Cabeçalho.
oModel:GetModel("SZ9MASTER"):SetDescription("Cabeçalho das Estruturas de Produtos Pai x Filho")

//Setamos a descrição/título que aparecerá no GRID DE ITENS.
oModel:GetModel("SZ9DETAIL"):SetDescription("Itens das Estruturas de Produtos Pai x Filho")

//Finalizamos a função model
oModel:GetModel("SZ9DETAIL"):SetUseOldGrid(.T.) //Finalizo setando o modelo antigo de Grid, que permite pegar aHeader e aCols.

Return oModel



Static Function ViewDef()
Local oView     := Nil
Local oModel    := FwLoadModel("xEstPr")
Local oStCabec  := FwFormViewStruct():New() //Objeto encarregado de montar a estrutura temporária do cabeçalho da View.
Local oStItens  := FWFormStruct(2,"SZ9") //Objeto responsável por montar a parte de estutura dos Itens/Grid , //1 para Model, 2 para View
//Local oStTotais := FWCalcStruct(oModel:GetModel('CALCTOTAL'))

//Cri dentro da estrutura 
oStCabec:AddField("Z9_CODPPAI", "01", "Código Produto Pai", X3Descric('Z9_CODPPAI'), Nil, "C", X3Picture("Z9_CODPPAI"), Nil, "SB1", .T., Nil, Nil, Nil, Nil, Nil, Nil, Nil, Nil)
oStCabec:AddField("Z9_DESPPAI", "02", "Descrição Produto Pai", X3Descric('Z9_DESPPAI'), Nil, "C", X3Picture("Z9_DESPPAI"), Nil, Nil, .F., Nil, Nil, Nil, Nil, Nil, Nil, Nil, Nil)

oStItens:RemoveField("Z9_CODPPAI")
oStItens:RemoveField("Z9_DESPPAI")

oStItens:SetProperty("Z9_ITEM",MVC_VIEW_CANCHANGE,.F.)

/*Agora vamos para a segunda parte da ViewDef, onde nós amarramos as estuturas de dados, montadas acima
com o objeto oView, e passamos para a nossa aplicação todas as características visuais dos Projetos.
*/

//Instancio a classe FwFormView para o objeto View
oView := FwFormView():New()
oView:Refresh()
//Passo para objeto View o modelo de dados que quero atrelar à ele Modelo + Visualização
oView:SetModel(oModel)

//Monto a estrutura de Visualização do Master e do Detalhe (Cabeçalho e Itens)
oView:AddField("VIEW_SZ9M",oStCabec,"SZ9MASTER") //Cabeçalho
oView:AddGrid("VIEW_SZ9D",oStItens,"SZ9DETAIL") //Itens/Grid

oView:AddIncrementalField("SZ9DETAIL","Z9_ITEM") //Responsável por fazer incremental no campo Item na Grid.

//Criamos a telinha, dividindo proporcionalmente o tamanho do cabeçalho e o tamanho do Grid
oView:CreateHorizontalBox("CABEC",20)
oView:CreateHorizontalBox("GRID",70)

/*Abaixo, digo para onde vão cada View Criada, VIEW_SZ7M irá para a CABEC.
VIEW_SZ7D irá para GRID... Sendo assim, eu associo o View à cada Box criado.
*/
oView:SetOwnerView("VIEW_SZ9M","CABEC")
oView:SetOwnerView("VIEW_SZ9D","GRID")

//Ativar o títulos de cada VIEW/Box criado
oView:EnableTitleView("VIEW_SZ9M","Cabeçalho das Estruturas de Produtos Pai x Filho")
oView:EnableTitleView("VIEW_SZ9D","Itens das Estruturas de Produtos Pai x Filho")


//Metodo que seta um Bloco de Código para verificar se a Janela deve ou não ser fechada após a execução do botão OK.
oView:SetCloseOnOk({|| .T.})

Return oView


User Function GrvSZ9()

Local aArea     := GetArea()
Local lRet      := .T.
Local oModel    := FwModelActive() //Capturo o modelo ativo, no caso o objeto de modelo(oModel) que está sendo manipulado em nossa aplicação
Local oModelCabec := oModel:GetModel("SZ9MASTER") //Criar modelo de dados MASTER/CABEÇALHO com base no Model geral que foi capturado acima
Local oModelItem := oModel:GetModel("SZ9DETAIL") //Criar modelo de dados MASTER/CABEÇALHO com base no Model geral que foi capturado acima

//Carregar os dados do Cabeçalho, através do Método GetValue
Local cFilSZ9      := oModelCabec:GetValue("Z9_FILIAL")
Local cCodProdPai  := oModelCabec:GetValue("Z9_CODPPAI")
Local cDescProdPai := oModelCabec:GetValue("Z9_DESPPAI")


//Variáveis que farão a captura dos dados com base no aHeader e aCols
Local aHeaderAux   := oModelItem:aHeader
Local aColsAux     := oModelItem:aCols

//Precisamos agora pegar a posição de cada campo dentro do grid
Local nPosItem             := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z9_ITEM")})
Local nPosCodProdFilho     := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z9_CPFILHO")})
Local nPosDescProdFilho    := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z9_DESPFIL")})
Local nQuant               := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z9_QUANT")})


//Preciso pegar a linha atual que o usuário está posicionado, para isso usarei uma variável.
Local nLinAtu      := 0



//Preciso identificar qual o tipo de operação que o usuário está fazendo (INCLUSÃO/ALTERAÇÃO/EXCLUSÃO)
Local cOption      := oModelCabec:GetOperation()

//Fazemos a seleção da nossa área que será manipulada, ou seja, colocamos a tabela SZ7, em evidência juntamente com um índice de ordenação.
dbSelectArea("SZ9")
SZ9->(DbSetOrder(1))

//Se a operação que está sendo feita, for uma inserção, ele fará a inserção.
IF cOption == MODEL_OPERATION_INSERT

dbSelectArea("SG1")
DbSetOrder(1)
If DbSeek(xFilial("SG1")+cCodProdPai,.F.)
while !SG1->(Eof()) .And. AllTrim(SG1->G1_COD) == cCodProdPai
    Reclock("SG1",.F.)
    DbDelete()
    MsUnLock()
    SG1->(dbSkip())    
ENDDO
EndIf

    For nLinAtu := 1 to Len(aColsAux) //Mede o tamanho do aCols, ou seja, quantos itens existem no Grid.
    //Porém, antes de tentar inserir, eu devo verificar, se a Linha está deletada.
        IF !aColsAux[nLinAtu][Len(aHeaderAux)+1] //Expressão para verificar se uma linha está excluída no aCols.            
            Reclock("SZ9",.T.) //.T. para inclusão .F. para alteração/exclusão
                //DADOS DO CABEÇALHO
                Z9_FILIAL   := cFilSZ9
                Z9_CODPPAI  := cCodProdPai
                Z9_DESPPAI  := cDescProdPai
                
                //DADOS DO GRID
                Z9_ITEM     := aColsAux[nLinAtu,nPosItem]
                Z9_CPFILHO  := aColsAux[nLinAtu,nPosCodProdFilho]
                Z9_DESPFIL  := aColsAux[nLinAtu,nPosDescProdFilho]
                Z9_QUANT    := aColsAux[nLinAtu,nQuant]
            SZ9->(MSUNLOCK())
       

            dbSelectArea("SG1")
            DbSetOrder(1)
            If !DbSeek(xFilial("SG1")+cCodProdPai+aColsAux[nLinAtu,nPosCodProdFilho],.F.)
                Reclock("SG1",.T.)
                SG1->G1_FILIAL	:= xFilial("SG1")
                SG1->G1_COD	    := cCodProdPai
                SG1->G1_COMP    := aColsAux[nLinAtu,nPosCodProdFilho]
                SG1->G1_QUANT   := aColsAux[nLinAtu,nQuant]
                SG1->G1_INI     := dDataBase
                SG1->G1_FIM     := CTOD("31/12/2049")
                SG1->G1_FIXVAR  := "V"
                SG1->G1_REVFIM  := "ZZZ"
                SG1->G1_NIV     := "01"
                SG1->G1_NIVINV  := "99"
                SG1->G1_VLCOMPE :=  "N"
                SG1->G1_USAALT  :=  "1"
                SG1->(MsUnLock())
            Else
                Help(,,"CODKIT",,"Codigo de Kit já existe no cadastro de estruturas padrão.",1, 0,,,,,,{"Favor revisar o codigo do kit promocional."})
                //Help("Codigo de Kit já existe no cadastro de estruturas padrão. Favor revisar o codigo do kit promocional")
            EndIf
        ENDIF

    Next n //Incremento de Linha do For.

ELSEIF cOption == MODEL_OPERATION_UPDATE


dbSelectArea("SG1")
DbSetOrder(1)
If DbSeek(xFilial("SG1")+cCodProdPai,.F.)
while !SG1->(Eof()) .And. AllTrim(SG1->G1_COD) == cCodProdPai
    Reclock("SG1",.F.)
    DbDelete()
    MsUnLock()
    SG1->(dbSkip())    
ENDDO
EndIf


    For nLinAtu := 1 to Len(aColsAux) //Mede o tamanho do aCols, ou seja, quantos itens existem no Grid.
    //Porém, antes de tentar inserir, eu devo verificar, se a Linha está deletada.
        IF aColsAux[nLinAtu][Len(aHeaderAux)+1] //Expressão para verificar se uma linha está excluída no aCols.
            //Se a linha estiver deletada, eu ainda preciso verificar se a linha está incluso no sistema ou não.   
            SZ9->(DbSetOrder(2))//ÍNDICE FILIAL+NUMEROPEDIDO+ITEM
            IF SZ9->(DbSeek(cFilSZ9+cCodProdPai+aColsAux[nLinAtu,nPosItem])) //Faz a busca, se encontrar, ele deve deletar do banco
                Reclock("SZ9",.F.) //.T. para inclusão .F. para alteração/exclusão
                    DbDelete()
                SZ9->(MSUNLOCK())
            ENDIF
        ELSE //Se a linha não estiver excluída, faço a Alteração
        //Embora seja uma alteração, eu posso ter novos itens inclusos no meu pedido, sendo assim, preciso validar se estes itens existem no banco de dados ou não
        //caso eles não existam, eu faço uma INCLUSÃO RECLOCK("SZ7",.T.)
            SZ9->(DbSetOrder(2))//ÍNDICE FILIAL+NUMEROPEDIDO+ITEM
            IF SZ9->(DbSeek(cFilSZ9 + cCodProdPai + aColsAux[nLinAtu,nPosItem])) //Faz a busca, se encontrar, ele deve deletar do banco
                
                _cFilhoAnt := SZ9->Z9_CPFILHO
                
                Reclock("SZ9",.F.) //.T. para inclusão .F. para alteração/exclusão
                    //DADOS DO CABEÇALHO
                Z9_FILIAL   := cFilSZ9
                Z9_CODPPAI  := cCodProdPai
                Z9_DESPPAI  := cDescProdPai
                
                //DADOS DO GRID
                Z9_ITEM     := aColsAux[nLinAtu,nPosItem]
                Z9_CPFILHO  := aColsAux[nLinAtu,nPosCodProdFilho]
                Z9_DESPFIL  := aColsAux[nLinAtu,nPosDescProdFilho]
                Z9_QUANT    := aColsAux[nLinAtu,nQuant]
                SZ9->(MSUNLOCK())
        
        ELSE
                Reclock("SZ9",.T.) //.T. para inclusão .F. para alteração/exclusão
                   //DADOS DO CABEÇALHO
                Z9_FILIAL   := cFilSZ9
                Z9_CODPPAI  := cCodProdPai
                Z9_DESPPAI  := cDescProdPai
                
                //DADOS DO GRID
                Z9_ITEM     := aColsAux[nLinAtu,nPosItem]
                Z9_CPFILHO  := aColsAux[nLinAtu,nPosCodProdFilho]
                Z9_DESPFIL  := aColsAux[nLinAtu,nPosDescProdFilho]
                Z9_QUANT    := aColsAux[nLinAtu,nQuant]
                SZ9->(MSUNLOCK())
            ENDIF
        ENDIF
        Next n //Incremento de Linha do For.

        For nLinAtu := 1 to Len(aColsAux) //Mede o tamanho do aCols, ou seja, quantos itens existem no Grid.
        //Porém, antes de tentar inserir, eu devo verificar, se a Linha está deletada.
        IF aColsAux[nLinAtu][Len(aHeaderAux)+1] //Expressão para verificar se uma linha está excluída no aCols.
            dbSelectArea("SG1")
            SG1->(DbSetOrder(1))
            If SG1->(DbSeek(xFilial("SG1")+cCodProdPai+aColsAux[nLinAtu,nPosCodProdFilho]))
                Reclock("SG1",.F.)
                DbDelete()
                SG1->(MsUnLock())
            EndIf
         ELSE
         //--->Incluindo na tabela SG1 (Estruturas de Produtos)
            Reclock("SG1",.T.)
            SG1->G1_FILIAL	:= xFilial("SG1")
            SG1->G1_COD	    := cCodProdPai
            SG1->G1_COMP    := aColsAux[nLinAtu,nPosCodProdFilho]
            SG1->G1_QUANT   := aColsAux[nLinAtu,nQuant]
            SG1->G1_INI     := dDataBase
            SG1->G1_FIM     := CTOD("31/12/2049")
            SG1->G1_FIXVAR  := "V"
            SG1->G1_REVFIM  := "ZZZ"
            SG1->G1_NIV     := "01"
            SG1->G1_NIVINV  := "99"
            SG1->G1_VLCOMPE :=  "N"
            SG1->G1_USAALT  :=  "1"
            SG1->(MsUnLock())
            ENDIF
            Next n 


ELSEIF cOption == MODEL_OPERATION_DELETE
    SZ9->(DbSetOrder(1)) //FILIAL + NUMEROPEDIDO
    /*Ele vai percorrer todo arquivo, e enquanto a filial for igual a do pedido e o número do pedido for igual ao número que está posicionado para excluir(pedido que você quer excluir)
      ele fará a DELEÇÃO/EXCLUSÃO dos Registros.
    */
    WHILE !SZ9->(EOF()) .AND. SZ9->Z9_FILIAL = cFilSZ9 .AND. SZ9->Z9_CODPPAI = cCodProdPai
        RECLOCK("SZ9",.F.) // PARÂMETRO FALSE PORQUE É EXCLUSÃO
            DbDelete()
        SZ9->(MSUNLOCK())
    
        dbSelectArea("SG1")
        SG1->(DbSetOrder(1))
        If DbSeek(xFilial("SG1")+SZ9->Z9_CODPPAI+SZ9->Z9_CPFILHO,.F.)
            Reclock("SG1",.F.)
            DbDelete()
            SG1->(MSUNLOCK())
        ENDIF
  
    SZ9->(dbSkip())
    ENDDO

// RECUPERA A VIEW ATIVA E ATUALIZA (NECESSÁRIO PARA EXIBIÇÃO DO CONTEÚDO)
oView := FwViewActive()
oView:Refresh()

ENDIF


RestArea(aArea)

Return lRet


/*User Function VldSZ9()
Local lRet  := .T.
Local aArea := GetArea()
Local oModel    := FwModelActive() //Capturo o modelo ativo, no caso o objeto de modelo(oModel) que está sendo manipulado em nossa aplicação
Local oModelCabec := oModel:GetModel("SZ9MASTER") //Criar modelo de dados MASTER/CABEÇALHO com base no Model geral que foi capturado acima

//Carregar os dados do Cabeçalho, através do Método GetValue
Local cCodPai      := oModelCabec:GetValue("Z9_CODPPAI")

SZ9->(DbSetOrder(1))

IF SZ9->(DbSeek(xFilial("SZ9") + cCodPai))
    IF ExistChav("SZ9",FwFldGet("Z9_CODPPAI")) == .T.
        lRet    := .F.
        Help(NIL,NIL,"CODKIT",NIL,"Este Kit já existe em nosso sistema.",1, 0, NIL, NIL, NIL, NIL, NIL,{"Escolha outro número de Kit."})
    ELSEIF ExistCpo("SB1") == .F.
        lRet    := .F.
        Help(NIL,NIL,"CODPROD",NIL,"Este número não faz parte do Cadastro de Produto.",1, 0, NIL, NIL, NIL, NIL, NIL,{"Por Favor Cadastre o Produto."})
    ENDIF
ENDIF

RestArea(aArea)
Return lRet*/
