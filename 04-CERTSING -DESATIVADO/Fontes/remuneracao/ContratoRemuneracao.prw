#INCLUDE "PROTHEUS.CH"

//Situações de contrato definido em CN9_SITUAC
#DEFINE SITUACAO_CANCELADO      "01"
#DEFINE SITUACAO_ELABORACAO     "02"
#DEFINE SITUACAO_EMITIDO        "03"
#DEFINE SITUACAO_APROVACAO      "04"
#DEFINE SITUACAO_ATIVO          "05"
#DEFINE SITUACAO_PARALISADO     "06"
#DEFINE SITUACAO_PARA_FINALIZAR "07"
#DEFINE SITUACAO_FINALIZADO     "08"
#DEFINE SITUACAO_EM_REVISAO     "09"
#DEFINE SITUACAO_REVISADO       "10"

//Permissões de acesso ao contrato
#DEFINE CONTROLE_TOTAL          "001"
#DEFINE MEDICAO_TOTAL           "020"
#DEFINE MEDICAO_INCLUSAO        "021"
#DEFINE MEDICAO_EDICAO          "022"
#DEFINE MEDICAO_EXCLUSAO        "023"
#DEFINE MEDICAO_ENCERRAMENTO    "024"
#DEFINE MEDICAO_ESTORNO         "025"

/**
* Classe que opera como DTO para utilização dos dados do
* Contrato para geração das Medições para parceiros com Contratos.
*
* @class    ContratoRemuneracao
* @version  1.0
* @date     11/08/2020
*
**/
Class ContratoRemuneracao

    Data cNumero
    Data cFornecedor
    Data cLojaFornecedor
    Data cRevisao
    Data dDataInicio
    Data dDataFim
    Data cSituacao
    Data cDescricaoSituacao
    Data nSaldo
    Data cTipoContrato
    Data cDescrTipoContrato
    Data lMedicaoEventual
    Data lMedicaoAutomatica
    Data lContratoFixo

    Data aPlanilhas

    Data cMedicao
    Data nRecnoMedicao
    Data cPedido
    
    Data cErrorFind
    Data cErrorIssue
    Data cErrorEstorno

    Method New() Constructor
    Method find(cContrato, cRevisao, lAtivo)
    Method findByFornecedor(cFornecedor, cLojaFornecedor)
    Method getSituacao()
    Method canIssueOrder()
    Method canEstornarMedicao()
    Method getFornecedor()
    Method hasAccess(cPermissao)
    Method geraMedicao()
    Method estornaMedicao()
    Method encerraMedicao()
    Method rollbackMedicao()

EndClass

/**
* Método construtor para inicializar os valores da instância.
*
* @method   New
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method New() Class ContratoRemuneracao

    ::cNumero := ""
    ::cFornecedor := ""
    ::cLojaFornecedor := ""
    ::cRevisao := ""
    ::dDataInicio := CTOD("//")
    ::dDataFim := CTOD("//")
    ::cSituacao := ""
    ::cDescricaoSituacao := ""
    ::nSaldo := 0
    ::cTipoContrato := ""
    ::cDescrTipoContrato := ""
    ::lMedicaoEventual := .F.
    ::lMedicaoAutomatica := .F.
    ::lContratoFixo := .F.

    ::aPlanilhas := {}

    ::cMedicao := ""
    ::nRecnoMedicao := 0
    ::cPedido := ""

    ::cErrorFind := ""
    ::cErrorIssue := ""

Return

/**
* Método que tenta localizar e popular a instância com informações do Contrato
* cadastrado para o Parceiro.
*
* @method   find
* @param    cContrato Indica o número do contrato no Sistema
* @param    lAtivo Indica se deve retornar apenas o contrato ativo
* @return   boolean Retorna o contrato foi localizado
* @version  1.0
* @date     11/08/2020
*
**/
Method find(cContrato, cRevisao, lAtivo) Class ContratoRemuneracao

    Local cChaveCN9 := ""
    Local nIndex    := 0
    Local nTamCod   := TamSX3("A2_COD")[1]
    Local nTamLoja  := TamSX3("A2_LOJA")[1]
    
    DEFAULT lAtivo := .T.

    //O índice 1 posiciona no primeiro contrato localizado
    //enquanto que o índice 7 procura apenas contratos vigentes. 
    If lAtivo
        nIndex := 7  //CN9_FILIAL + CN9_NUMERO + CN9_SITUAC
        cChaveCN9 := xFilial("CN9") + cContrato + SITUACAO_ATIVO
    Else 
        nIndex := 1 //CN9_FILIAL + CN9_NUMERO + CN9_REVISA
        cChaveCN9 := xFilial("CN9") + cContrato + cRevisao
    EndIf

    //Busca o contrato na CN9 de acordo com a chave
    dbSelectArea("CN9")
    CN9->(dbSetOrder(nIndex)) 
    If CN9->(dbSeek(cChaveCN9))

        ::cNumero            := CN9->CN9_NUMERO
        ::cRevisao           := CN9->CN9_REVISA
        ::cFornecedor        := Substr(::getFornecedor(), 1, nTamCod)
        ::cLojaFornecedor    := Substr(::getFornecedor(), nTamCod + 1, nTamLoja)
        ::dDataInicio        := CN9->CN9_DTINIC
        ::dDataFim           := CN9->CN9_DTFIM
        ::cSituacao          := CN9->CN9_SITUAC
        ::cDescricaoSituacao := ::getSituacao()
        ::nSaldo             := CN9->CN9_SALDO
        ::cTipoContrato      := CN9->CN9_TPCTO

        //Busca o tipo de contrato para validar a geração de medição
        dbSelectArea("CN1")
        CN1->(dbSetOrder(1)) //CN1_FILIAL + CN1_CODIGO + CN1_ESPCTR
        If CN1->(dbSeek(xFilial("CN1") + CN9->CN9_TPCTO))
            ::cDescrTipoContrato := CN1->CN1_DESCRI
            ::lMedicaoEventual   := CN1->CN1_MEDEVE == "1" //Permite medições sem a necessidade de um cronograma financeiro
            ::lMedicaoAutomatica := CN1->CN1_MEDAUT == "1" //Para remuneração, não deve gerar medição automática
            ::lContratoFixo      := CN1->CN1_CTRFIX == "1" //Contrato fixo deve ter planilhas financeiras
        Else
            ::cDescrTipoContrato := "Tipo de contrato não encontrado."
        EndIf

        //Carrega as planilhas existentes para o contrato
        dbSelectArea("CNA")
        CNA->(dbSetOrder(1)) //CNA_FILIAL + CNA_CONTRA + CNA_REVISA + CNA_NUMERO
        If CNA->(dbSeek(xFilial("CNA") + ::cNumero + cRevisao))
            While CNA->(!EoF()) .And. CNA->CNA_CONTRA + CNA->CNA_REVISA == ::cNumero + ::cRevisao
                aAdd(::aPlanilhas, PlanilhaContratoRemuneracao():New(CNA->CNA_NUMERO, CNA->CNA_TIPPLA, CNA->CNA_SALDO))
                CNA->(dbSkip())
            EndDo
        Else
            ::cErrorFind := "O contrato não possui planilhas cadastradas. Contrato: " + ::cNumero
            Return .F.
        EndIf

    Else
        ::cErrorFind := "O contrato não foi encontrado. Ýndice: " + cValToChar(nIndex) + " Chave de busca: " + cChaveCN9
        Return .F.
    EndIf

Return .T.

/**
* Método que busca o contrato a partir do código e loja do Fornecedor 
* vinculado ao Parceiro. Caso o contrato seja localizado, o método chama
* o método find para carregar os dados do contrato na instância.
*
* @method   findByFornecedor
* @param    cFornecedor Código do Fornecedor, conforme SA2
* @param    cLojaFornecedor Loja do Fornecedor
* @return   boolean Retorna se encontrou o contrato vinculado ao fornecedor
* @version  1.0
* @date     11/08/2020
*
**/
Method findByFornecedor(cFornecedor, cLojaFornecedor) Class ContratoRemuneracao

    Local lRetMethod := .F.

    If Select("TMPCNC") > 0
        TMPCNC->(dbCloseArea())
    EndIf

    BeginSql Alias "TMPCNC"
        SELECT CNC_NUMERO CONTRATO, MAX(CNC_REVISA) REVISAO
        FROM %Table:CNC% CNC 
        WHERE   CNC_FILIAL = %xFilial:CNC%
            AND CNC_CODIGO = %Exp:cFornecedor%
            AND CNC_LOJA = %Exp:cLojaFornecedor%
            AND CNC.%NotDel% 
    EndSql

    If TMPCNC->(!EoF())
        lRetMethod := ::find(TMPCNC->CONTRATO, TMPCNC->REVISAO, .T.)
    Else
        ::cErrorFind := "Não foi encontrado contrato para o Fornecedor: " + cFornecedor + "/" + cLojaFornecedor
        lRetMethod := .F.
    EndIf

    TMPCNC->(dbCloseArea())

Return lRetMethod

/**
* Método que alimenta e devolve o conteúdo do atributo cDescricaoSituacao
* que indica em texto a situação atual do contrato.
*
* @method   getSituacao
* @param    null
* @return   string Retorna a descrição da situação do contrato.
* @version  1.0
* @date     11/08/2020
*
**/
Method getSituacao() Class ContratoRemuneracao
   
    Do Case
        Case ::cSituacao == SITUACAO_CANCELADO
            ::cDescricaoSituacao := "Contrato Cancelado"
        Case ::cSituacao == SITUACAO_ELABORACAO
            ::cDescricaoSituacao := "Contrato em Elaboração"
        Case ::cSituacao == SITUACAO_EMITIDO
            ::cDescricaoSituacao := "Contrato Emitido"
        Case ::cSituacao == SITUACAO_APROVACAO 
            ::cDescricaoSituacao := "Contrato em Aprovação"
        Case ::cSituacao == SITUACAO_ATIVO
            ::cDescricaoSituacao := "Contrato Vigente"
        Case ::cSituacao == SITUACAO_PARALISADO
            ::cDescricaoSituacao := "Contrato Paralisado"
        Case ::cSituacao == SITUACAO_PARA_FINALIZAR
            ::cDescricaoSituacao := "Contrato em Finalização"
        Case ::cSituacao == SITUACAO_FINALIZADO
            ::cDescricaoSituacao := "Contrato Finalizado"
        Case ::cSituacao == SITUACAO_EM_REVISAO
            ::cDescricaoSituacao := "Contrato em Revisão"
        Case ::cSituacao == SITUACAO_REVISADO
            ::cDescricaoSituacao := "Contrato Revisado"
    EndCase

Return ::cDescricaoSituacao

/**
* Método que valida se é possível gerar a Medição para o contrato carregado
* As verificações realizadas são:
* - Contrato em Situação Vigente
* - Contrato com data de vigência menor ou igual à Data Base.
* - Contrato permite medição eventual
* - Permissão de acesso do usuário ao contrato
* - Planilha do Contrato permite medição eventual
* - Planilha não é fixa ou realiza medição automática
*
* @method   canIssueOrder
* @param    null
* @return   boolean Retorna se a ação é permitida
* @version  1.0
* @date     11/08/2020
*
**/
Method canIssueOrder() Class ContratoRemuneracao

    Local Ni := 0

    If ::cSituacao != SITUACAO_ATIVO
        ::cErrorIssue := "A medição não pode ser gerada porque o contrato está com status " + ::getSituacao()
        Return .F.
    EndIf

    If ::dDataFim <= dDataBase
        ::cErrorIssue := "A medição não pode ser gerada porque a data de finalização do contrato expirou."
        Return .F.
    EndIf

    If !::lMedicaoEventual
        ::cErrorIssue := "A medição não pode ser gerada porque o contrato não permite geração de medições eventuais."
        Return .F.
    EndIf

    If !::hasAccess(CONTROLE_TOTAL) .And. !::hasAccess(MEDICAO_TOTAL) .And. !::hasAccess(MEDICAO_INCLUSAO)
        ::cErrorIssue := "O usuário não tem acesso para incluir novas medições."
        Return .F.
    EndIf

    For Ni := 1 To Len(::aPlanilhas)

        If !::aPlanilhas[Ni]:lPlanilhaMedicaoEventual
            ::cErrorIssue := "A planilha do contrato não permite medições eventuais."
            Return .F.
        EndIf

        If ::aPlanilhas[Ni]:lPlanilhaFixa .Or. ::aPlanilhas[Ni]:lPlanilhaMedicaoAutomatica
            ::cErrorIssue := "O tipo de planilha selecionado não permite geração de medições manuais."
            Return .F.
        EndIf       

    Next

    //Medição em aberto deve ser validada

Return .T.

/**
* Método que valida se o usuário tem acesso/permissão para realizar o estorno
* da Medição do Contrato.
*
* @method   canEstornarMedicao
* @param    null
* @return   boolean Retorna se a ação é permitida
* @version  1.0
* @date     11/08/2020
*
**/
Method canEstornarMedicao() Class ContratoRemuneracao

    If !::hasAccess(CONTROLE_TOTAL) .Or. !::hasAccess(MEDICAO_TOTAL) .Or. !::hasAccess(MEDICAO_ESTORNO)
        ::cErrorEstorno := "O usuário não tem permissão para estornar a medição gerada."
        Return .F.
    EndIf

Return .T.

/**
* Método que recupera o fornecedor do contrato cadastrado na tabela de 
* amarração Contrato x Fornecedor (CNC)
*
* @method   getFornecedor
* @param    null
* @return   string Retorna a composição código e loja cadastrados. Ex.: (CCCCCCLL)
* @version  1.0
* @date     11/08/2020
*
**/
Method getFornecedor() Class ContratoRemuneracao

    If Empty(::cFornecedor)
        dbSelectArea("CNC")
        CNC->(dbSetOrder(1)) //CNC_FILIAL + CNC_NUMERO + CNC_REVISA
        If CNC->(dbSeek(xFilial("CNC") + ::cNumero + ::cRevisao))
            ::cFornecedor := CNC->CNC_CODIGO
            ::cLojaFornecedor := CNC->CNC_LOJA
        Else
            ::cFornecedor := ""
            ::cLojaFornecedor := ""
        EndIf
    EndIf

Return ::cFornecedor + ::cLojaFornecedor

/**
* Método que valida se o usuário tem o acesso ou permissão indicada no parâmetro
* baseado nas constantes declaradas no início da classe, ou o código informado
* conforme cadastrado na tabela CNO.
*
* @method   hasAccess
* @param    cPermissao Indica qual permissão será testada do usuário
* @return   boolean Retorna se o usuário possui a permissão
* @version  1.0
* @date     11/08/2020
*
**/
Method hasAccess(cPermissao) Class ContratoRemuneracao

    Local lhasAccess    := .F.
    Local cNumero       := ::cNumero
    Local aRetVld       := {}

    aRetVld := CN300VldUsr()

    If Select("TMPCNN") > 0
        TMPCNN->(dbCloseArea())
    EndIf

    BeginSql Alias "TMPCNN"
        SELECT CNN_TRACOD 
        FROM CNN010 CNN 
        WHERE   CNN_FILIAL = %xFilial:CNN%
            AND CNN_USRCOD = %Exp:RetCodUsr()%
            AND CNN_TRACOD = %Exp:cPermissao%
            AND CNN_CONTRA = %Exp:cNumero%
            AND CNN.%NotDel%
    EndSql

    lhasAccess := TMPCNN->(!EoF())

    TMPCNN->(dbCloseArea())

    If !lhasAccess
        If Len(aRetVld) > 5
            If aRetVld[6][1][2] .Or. aRetVld[6][2][2]
                lhasAccess := .T.
            EndIf
        ElseIf aRetVld[1]
            lhasAccess := .T.
        EndIf
    EndIf



Return lhasAccess

/**
* Método responsável por gerar a Medição do Contrato para o Fornecedor
* e alimentar o atributo cMedicao com o código gerado. Alimenta, também, o
* número do pedido de compra gerado.
*
* @method   geraMedicao
* @param    aCabec Array contendo o cabeçalho da medição (CND)
* @param    aItens Array contendo os itens da medição (CNE)
* @return   boolean Retorna se a medição foi gerada corretamente
* @version  1.0
* @date     11/08/2020
*
**/
Method geraMedicao(aCabec, aItens) Class ContratoRemuneracao

    Local lGravou := .F.
    Local cNumCND := aCabec[aScan(aCabec, {|x| x[1] == "CND_NUMMED"})][2]

    ::cMedicao := cNumCND

    If ::canIssueOrder()

        //Executa rotina automatica para gerar as medicoes
		CNTA120(aCabec, aItens, 3, .F.)
        
        dbSelectArea("CND")
        CND->(dbSetOrder(4))
        lGravou := CND->(dbSeek(xFilial("CND") + ::cMedicao))
                    
    EndIf

Return lGravou

/**
* Método responsável pela realização do Estorno da Medição indicada
* pelo usuário.
*
* @method   estornaMedicao
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method estornaMedicao() Class ContratoRemuneracao

    If ::canEstornarMedicao()
    EndIf

Return

/**
* Método responsável pela realização do Estorno da Medição indicada
* pelo usuário.
*
* @method   estornaMedicao
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method encerraMedicao(aCabec, aItens) Class ContratoRemuneracao

    DEFAULT aCabec := ::getCabecMedicao()
    DEFAULT aItens := ::getItensMedicao()

    CND->(dbSetOrder(4))
    If CND->(dbSeek(xFilial("CND") + ::cMedicao))

        /*RecLock("CND",.F.)
            CND->CND_APROV := Posicione('CTT',1, xFilial('CTT')+"80000000",'CTT_GARVAR')
            CND->CND_ALCAPR := "B"
        CND->(MsUnlock())*/

        //Encerra medição
        CNTA120(aCabec, aItens, 6)
    
        ::cPedido := CND->CND_PEDIDO
    EndIf

Return !Empty(::cPedido)

/**
* Método responsável pela realização do Estorno da Medição indicada
* pelo usuário.
*
* @method   estornaMedicao
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method rollbackMedicao() Class ContratoRemuneracao  

    dbSelectArea("CND")
    CND->(dbSetOrder(1))
    If CND->(dbSeek(xFilial("CND") + ::cMedicao))
        CND->(RecLock("CND",.F.))
            CND->(dbDelete())
        CND->(MsUnLock())
    EndIf
    
    dbSelectArea("CNE")
    CNE->(dbSetOrder(4))
    If CNE->(dbSeek(xFilial("CNE") + ::cMedicao))
        CNE->(RecLock("CNE",.F.))
            CNE->(dbDelete())
        CNE->(MsUnLock())
    Endif

Return
