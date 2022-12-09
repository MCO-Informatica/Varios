#Include 'Protheus.ch'
#Include 'FwMvcDef.ch'

User Function LIBUSR()

Local aArea   := GetArea()
Local oBrowse := FwmBrowse():New()

oBrowse:SetAlias("SZ8")
oBrowse:SetDescription("Libera��o de Usu�rios para Faturamento")
oBrowse:Activate()

RestArea(aArea)

Return





Static Function MenuDef()
Local aRotina := FwMVCMenu("LIBUSR")

Return aRotina





Static Function ModelDef()
Local oStCabec  := FWFormModelStruct():New() //Objeto respons�vel pela estrutura do cabe�alho
Local oStItens  := FWFormStruct(1,"SZ8") //Objeto respons�vel pela estrutura dos itens, //1 para Model, 2 para View
Local bVldCom   := {|| u_GrvSZ8()} //Chamada da User Function que validar� a INCLUS�O/ALTERA��O/EXCLUS�O dos Itens
Local oModel    := MPFormModel():New("LIBUSRM",,,bVldCom,) //Objeto principal do Desenvolvimento em MVC MODELO 2, ele traz as caracter�sticas do dicion�rio de dados, bem como � o respons�vel pela estrutura de Tabelas, campos e registros.

//Cria��o da tabela tempor�ria que ser� utilizada no Cabe�alho
oStCabec:AddTable("SZ8",{"Z8_FILIAL","Z8_COD","Z8_DESC"},"Cabe�alho SZ8") 

//Cria��o dos campos da tabela tempor�ria
oStCabec:AddField("Filial", "Filial", "Z8_FILIAL", "C", TamSX3("Z8_FILIAL")[1], 0, Nil, Nil, {}, .F., FwBuildFeature( STRUCT_FEATURE_INIPAD, "IIF(!INCLUI,SZ8->Z8_FILIAL,FWxFilial('SZ8'))"), .T., .F., .F.) 
oStCabec:AddField("Grupo", "Grupo", "Z8_COD"   , "C", TamSX3("Z8_COD")   [1], 0, Nil, Nil, {}, .T., FwBuildFeature( STRUCT_FEATURE_INIPAD, "IIF(!INCLUI,SZ8->Z8_COD,'')"),                .T., .F., .F.) 
oStCabec:AddField("Descri��o", "Descri��o", "Z8_DESC", "C", TamSX3("Z8_DESC")[1], 0, Nil, Nil, {}, .T., FwBuildFeature( STRUCT_FEATURE_INIPAD, "IIF(!INCLUI,SZ8->Z8_DESC,'')"),   .T., .F., .F.) 


//Agora vamos tratar a estrutura dos Itens, que ser�o utilizados no Grid da aplica��o

//Modificando Inicializadores Padr�o, para n�o dar mensagem de colunas vazias
oStItens:SetProperty("Z8_COD",     MODEL_FIELD_INIT,FwBuildFeature( STRUCT_FEATURE_INIPAD, '"*"')) //Modificando Inicializadores Padr�o, para n�o dar mensagem de colunas vazias
oStItens:SetProperty("Z8_DESC", MODEL_FIELD_INIT,FwBuildFeature( STRUCT_FEATURE_INIPAD, '"*"')) //Modificando Inicializadores Padr�o, para n�o dar mensagem de colunas vazias

/*//Criando Gatilho para campo Nome Fornecedor posicionando de acordo com C�digo(Z7_FORNECE)
aTrigNUsr := FwStruTrigger("Z8_USUARIO","Z8_NOMUSR",'USRFULLNAME(M->Z8_USUARIO)',.F.)
//Adicionando o Gatilho para Estutura
oStCabec:AddTrigger(aTrigNUsr[1],aTrigNUsr[2],aTrigNUsr[3],aTrigNUsr[4])
//Criando Gatilho para campo Total pela Multiplica��o entre Quantidade e Total
aTrigTotal := FwStruTrigger("Z7_PRECO","Z7_TOTAL",'Z7_PRECO * Z7_QUANT',.F.)
//Adicionando o Gatilho para Estutura
oStItens:AddTrigger(aTrigTotal[1],aTrigTotal[2],aTrigTotal[3],aTrigTotal[4])
//Criando Gatilho para campo Total pela Multiplica��o entre Quantidade e Total
aTrigQuant := FwStruTrigger("Z7_QUANT","Z7_TOTAL",'Z7_PRECO * Z7_QUANT',.F.)
//Adicionando o Gatilho para Estutura
oStItens:AddTrigger(aTrigQuant[1],aTrigQuant[2],aTrigQuant[3],aTrigQuant[4])*/


//A partir de agora, eu fa�o a uni�o das estruturas, vinculando o cabe�alho com os itens, tamb�m fa�o a vincula��o da Estrutura de dados dos itens, ao modelo.
oModel:AddFields("SZ8MASTER",,oStCabec) //Fa�o a vincula��o com o oStCabec(Cabe�alho e Itens tempor�rios)
oModel:AddGrid("SZ8DETAIL","SZ8MASTER",oStItens,,,,,)

//Seto a rela��o entre Cabe�alho e Item, neste ponto, eu digo atrav�s de qual/quais campo(s) o Grid est� vinculado com o cabe�alho.
aRelations := {}
aAdd(aRelations,{"Z8_FILIAL",'IIF(!INCLUI,SZ8->Z8_FILIAL,FWxFilial("SZ8"))'})
aAdd(aRelations,{"Z8_COD","SZ8->Z8_COD"})
oModel:SetRelation("SZ8DETAIL",aRelations,SZ8->(IndexKey(1)))

oModel:SetPrimaryKey({})

oModel:GetModel("SZ8DETAIL"):SetUniqueline({"Z8_ITEM"}) //O intuito � que este campo n�o se repita.

oModel:SetDescription("Modelo 2")

//Setamos a descri��o/t�tulo que aparecer� no Cabe�alho.
oModel:GetModel("SZ8MASTER"):SetDescription("Cabe�alho da Libera��o de Usu�rios")

//Setamos a descri��o/t�tulo que aparecer� no GRID DE ITENS.
oModel:GetModel("SZ8DETAIL"):SetDescription("Itens da Libera��o de Usu�rios")

//Finalizamos a fun��o model
oModel:GetModel("SZ8DETAIL"):SetUseOldGrid(.T.) //Finalizo setando o modelo antigo de Grid, que permite pegar aHeader e aCols.

Return oModel



Static Function ViewDef()
Local oView     := Nil
Local oModel    := FwLoadModel("LIBUSR")
Local oStCabec  := FwFormViewStruct():New() //Objeto encarregado de montar a estrutura tempor�ria do cabe�alho da View.
Local oStItens  := FWFormStruct(2,"SZ8") //Objeto respons�vel por montar a parte de estutura dos Itens/Grid , //1 para Model, 2 para View
//Local oStTotais := FWCalcStruct(oModel:GetModel('CALCTOTAL'))

//Cri dentro da estrutura 
oStCabec:AddField("Z8_COD", "01", "Grupo", X3Descric('Z8_COD'), Nil, "C", X3Picture("Z8_COD"), Nil, Nil, IIF(INCLUI,.T.,.F.), Nil, Nil, Nil, Nil, Nil, Nil, Nil, Nil)
oStCabec:AddField("Z8_DESC", "02", "Descri��o", X3Descric('Z8_DESC'), Nil, "C", X3Picture("Z8_DESC"), Nil, Nil, IIF(INCLUI,.T.,.F.), Nil, Nil, Nil, Nil, Nil, Nil, Nil, Nil)

oStItens:RemoveField("Z8_COD")
oStItens:RemoveField("Z8_DESC")

oStItens:SetProperty("Z8_ITEM",MVC_VIEW_CANCHANGE,.F.)

/*Agora vamos para a segunda parte da ViewDef, onde n�s amarramos as estuturas de dados, montadas acima
com o objeto oView, e passamos para a nossa aplica��o todas as caracter�sticas visuais dos Projetos.
*/

//Instancio a classe FwFormView para o objeto View
oView := FwFormView():New()
//Passo para objeto View o modelo de dados que quero atrelar � ele Modelo + Visualiza��o
oView:SetModel(oModel)

//Monto a estrutura de Visualiza��o do Master e do Detalhe (Cabe�alho e Itens)
oView:AddField("VIEW_SZ8M",oStCabec,"SZ8MASTER") //Cabe�alho
oView:AddGrid("VIEW_SZ8D",oStItens,"SZ8DETAIL") //Itens/Grid

oView:AddIncrementalField("SZ8DETAIL","Z8_ITEM") //Respons�vel por fazer incremental no campo Item na Grid.

//Criamos a telinha, dividindo proporcionalmente o tamanho do cabe�alho e o tamanho do Grid
oView:CreateHorizontalBox("CABEC",20)
oView:CreateHorizontalBox("GRID",70)

/*Abaixo, digo para onde v�o cada View Criada, VIEW_SZ7M ir� para a CABEC.
VIEW_SZ7D ir� para GRID... Sendo assim, eu associo o View � cada Box criado.
*/
oView:SetOwnerView("VIEW_SZ8M","CABEC")
oView:SetOwnerView("VIEW_SZ8D","GRID")

//Ativar o t�tulos de cada VIEW/Box criado
oView:EnableTitleView("VIEW_SZ8M","Cabe�alho Libera��o de Usu�rios")
oView:EnableTitleView("VIEW_SZ8D","Itens Libera��o de Usu�rios")


//Metodo que seta um Bloco de C�digo para verificar se a Janela deve ou n�o ser fechada ap�s a execu��o do bot�o OK.
oView:SetCloseOnOk({|| .T.})

Return oView


User Function GrvSZ8()

Local aArea     := GetArea()
Local lRet      := .T.
Local oModel    := FwModelActive() //Capturo o modelo ativo, no caso o objeto de modelo(oModel) que est� sendo manipulado em nossa aplica��o
Local oModelCabec := oModel:GetModel("SZ8MASTER") //Criar modelo de dados MASTER/CABE�ALHO com base no Model geral que foi capturado acima
Local oModelItem := oModel:GetModel("SZ8DETAIL") //Criar modelo de dados MASTER/CABE�ALHO com base no Model geral que foi capturado acima

//Carregar os dados do Cabe�alho, atrav�s do M�todo GetValue
Local cFilSZ8      := oModelCabec:GetValue("Z8_FILIAL")
Local cNum         := oModelCabec:GetValue("Z8_COD")
Local cDesc        := oModelCabec:GetValue("Z8_DESC")


//Vari�veis que far�o a captura dos dados com base no aHeader e aCols
Local aHeaderAux   := oModelItem:aHeader
Local aColsAux     := oModelItem:aCols

//Precisamos agora pegar a posi��o de cada campo dentro do grid
Local nPosItem     := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z8_ITEM")})
Local nPosUsr      := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z8_USUARIO")})
Local nDesUsr      := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z8_NOMUSR")})


//Preciso pegar a linha atual que o usu�rio est� posicionado, para isso usarei uma vari�vel.
Local nLinAtu      := 0



//Preciso identificar qual o tipo de opera��o que o usu�rio est� fazendo (INCLUS�O/ALTERA��O/EXCLUS�O)
Local cOption      := oModelCabec:GetOperation()

//Fazemos a sele��o da nossa �rea que ser� manipulada, ou seja, colocamos a tabela SZ7, em evid�ncia juntamente com um �ndice de ordena��o.
dbSelectArea("SZ8")
SZ8->(DbSetOrder(1))

//Se a opera��o que est� sendo feita, for uma inser��o, ele far� a inser��o.
IF cOption == MODEL_OPERATION_INSERT
    For nLinAtu := 1 to Len(aColsAux) //Mede o tamanho do aCols, ou seja, quantos itens existem no Grid.
    //Por�m, antes de tentar inserir, eu devo verificar, se a Linha est� deletada.
        IF !aColsAux[nLinAtu][Len(aHeaderAux)+1] //Express�o para verificar se uma linha est� exclu�da no aCols.
            Reclock("SZ8",.T.) //.T. para inclus�o .F. para altera��o/exclus�o
                //DADOS DO CABE�ALHO
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
    //Por�m, antes de tentar inserir, eu devo verificar, se a Linha est� deletada.
        IF aColsAux[nLinAtu][Len(aHeaderAux)+1] //Express�o para verificar se uma linha est� exclu�da no aCols.
            //Se a linha estiver deletada, eu ainda preciso verificar se a linha est� incluso no sistema ou n�o.   
            SZ8->(DbSetOrder(2))//�NDICE FILIAL+NUMEROPEDIDO+ITEM
            IF SZ8->(DbSeek(cFilSZ8+cNum+aColsAux[nLinAtu,nPosItem])) //Faz a busca, se encontrar, ele deve deletar do banco
                Reclock("SZ8",.F.) //.T. para inclus�o .F. para altera��o/exclus�o
                    DbDelete()
                SZ8->(MSUNLOCK())
            ENDIF
        ELSE //Se a linha n�o estiver exclu�da, fa�o a Altera��o
        //Embora seja uma altera��o, eu posso ter novos itens inclusos no meu pedido, sendo assim, preciso validar se estes itens existem no banco de dados ou n�o
        //caso eles n�o existam, eu fa�o uma INCLUS�O RECLOCK("SZ7",.T.)
            SZ8->(DbSetOrder(2))//�NDICE FILIAL+NUMEROPEDIDO+ITEM
            IF SZ8->(DbSeek(cFilSZ8 + cNum + aColsAux[nLinAtu,nPosItem])) //Faz a busca, se encontrar, ele deve deletar do banco
                Reclock("SZ8",.F.) //.T. para inclus�o .F. para altera��o/exclus�o
                    //DADOS DO CABE�ALHO
                    Z8_FILIAL   := cFilSZ8
                    Z8_COD      := cNum
                    Z8_DESC     := cDesc

                    //DADOS DO GRID
                    Z8_ITEM     := aColsAux[nLinAtu,nPosItem]
                    Z8_USUARIO  := aColsAux[nLinAtu,nPosUsr]
                    Z8_NOMUSR   := aColsAux[nLinAtu,nDesUsr]
                SZ8->(MSUNLOCK())
            ELSE
                Reclock("SZ8",.T.) //.T. para inclus�o .F. para altera��o/exclus�o
                    //DADOS DO CABE�ALHO
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
    /*Ele vai percorrer todo arquivo, e enquanto a filial for igual a do pedido e o n�mero do pedido for igual ao n�mero que est� posicionado para excluir(pedido que voc� quer excluir)
      ele far� a DELE��O/EXCLUS�O dos Registros.
    */
    WHILE !SZ8->(EOF()) .AND. SZ8->Z8_FILIAL = cFilSZ8 .AND. SZ8->Z8_COD = cNum
        RECLOCK("SZ8",.F.) // PAR�METRO FALSE PORQUE � EXCLUS�O
            DbDelete()
        SZ8->(MSUNLOCK())
    
    SZ8->(dbSkip())
    ENDDO

ENDIF

RestArea(aArea)

Return lRet
