
#include "protheus.ch"
#include "rwmake.ch"        //indica que houve conversao (ver p/ que serve isto)
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
APCIniciar - Esta função é responsável por iniciar a criação do processo e o envio da mensagem para o destinátario
*/

User Function APCIniciar()
    Local oProcess, oHtml
    Local cNumPed, cDestinatario, cShape, cArqHtml, cAssunto, cUsrCorrente
    Local cCodigoStatus, cDescricao, cValor
    Local aCond := {}
    Local nTotal := 0, nDias := 0, nHoras := 0, nMinutos := 10
    Local dDtEnt := ""
    Local dDtEmi := ""
    Local dDtRev := ""

    Local nTotalProd := 0	//Totalizando Valor do produto
	Local nTotalDesc := 0   //Totalizando Descontos
	Local nTotalDesp := 0   // Totalizando Despesas
	Local TotalSeg	 := 0   // Totalizando Seguro
	Local nTotalFrete := 0  // Totalizando Frete
	Local nTotalICMSRET := 0 // Totalizando ICMS Retido
	Local nTotalProd := 0	//Totalizando Valor do produto
	Local nTotalCom	:= 0    // Totalizando Valor do pedido de compras
	Local nTotalIPI := 0    // Totalizando IPI

    Private cIdUser  := AllTrim(RetCodUsr())
    Private cUsuario := AllTrim(UsrFullName(RetCodUsr()))

    // Obter Numero do Pedido
    cNumPed := SC7->C7_NUM

    // Monte uma descrição para o assunto
    cAssunto := "Aviso - Novo Pedido de Compra No.: " + cNumPed

    // Informe o caminho e aroquivo html que será usado
    cArqHtml := "\workflow\html\pedcom.html"

    // Obter nome do usuário corrente
    cUsrCorrente := AllTrim(RetCodUsr())

    // Informe a lista de destinatários, seprando-os entre ";"
    cDestinatario := "rvalerio@westech.com.br"

    // Incializar a classe de processo
    oProcess := TWFProcess():New("PEDCOM", cAssunto)

    // Criar uma nova tarefa, informando o html template a ser utilizado
    oProcess:NewTask("Aprovação do pedido", cArqHtml)

    // Informe o código do status do processo correspondente a este ponto do fluxo
    cCodigoStatus := "100100"
    cDestinatario := "Inciando processo..."

    // Repasse as informações para o método track() que restrará as informações para a rastreabilidade 
    oProcess:Track(cCodigoStatus, cDestinatario, cUsrCorrente)

    // Informe a função que deverá ser executada quando as respostas chegarem ao Workflow
    //oProcess:bReturn := "U_APCRetorno"
    //oProcess:cSubject := cAssunto

    // Determine o tempo necessário para executar o timeout. 5 minutos será
    // suficiente para respondermos o pedido. Caso contrário, será executado.
    //oProcess:bTimeOut := {{"U_APCTimeout(1)", nDias, nHoras, nMinutos }}


    // Informe qual usuário do Protheus será responsável por esta tarefa
    // Dessa forma, ele poderá ver a pendência na consulta por usuário
    oProcess:UserSiga := WFCodUser("Aprovador")
    oHtml := oProcess:oHtml

    // Crie novas informações a serem passadas para o método Track(), baseado no novo passo em que o fluxo se encontra
    cCodigoStatus := "100200"
    cDescricao := "Gerando solicitação de aprovação de pedido de compras..."
    oProcess:Track(cCodigoStatus, cDescricao, cUsrCorrente)

/*
    dbSetOrder(1)
    dbSelectArea("SC7")
    oHtml:ValByName("numped", cNumPed)
    cNum := cNumPed

    // Preencher campos contidos no html com as informações colhidas no banco de dados
    //dDtEmi := Substr(SC7->C7_EMISSAO,7,2) + "/" + Substr(SC7->C7_EMISSAO,5,2) + "/" + Substr(SC7->C7_EMISSAO,1,4)
    //oHtml:ValByName("dataemissao", dDtEmi)
    oHtml:ValByName("fornecedor", C7_FORNECE)
    oHtml:ValByName("nrevisao",C7_XXREV)
    //dDtRev := Substr(SC7->C7_XXDTREV,7,2) + "/" + Substr(SC7->C7_XXDTREV,5,2) + "/" + Substr(SC7->C7_XXDTREV,1,4)
    //oHtml:ValByName("datarev", dDtRev)

    dbSelectArea("SA2")
    dbSetOrder(1)
    dbSeek(xFilial("SA2")+SC7->C7_FORNECE)
    oHtml:ValByName("codigo", SC7->C7_FORNECE)
    oHtml:ValByName("fornecedor", SA2->A2_NOME)
    oHtml:ValByName("endereco", SA2->A2_END)
    oHtml:ValByName("nrend", SA2->A2_NR_END)
    oHtml:ValByName("bairro", SA2->A2_BAIRRO)
    oHtml:ValByName("cidade", SA2->A2_MUN)
    oHtml:ValByName("estado", SA2->A2_EST)
    oHtml:ValByName("cep", SA2->A2_CEP)
    oHtml:ValByName("cnpj", SA2->A2_CGC)
    oHtml:ValByName("increstadual", SA2->A2_INCR)
    oHtml:ValByName("incrmunicipal", SA2->A2_INCRM)
    oHtml:ValByName("email", SA2->A2_XXEMAIL)
    oHtml:ValByName("contato", SA2->A2_CONTATO)

    // Obter codiçoes de pagamento
    oHtml:ValByName("codpag", SC7->C7_COND)

    dbSelectArea("SE4")

    if dbSeek(xFilial("SE4"))
        while !Eof() .and. xFilial("SE4") == SE4->E4_FILIAL
            AAdd(aCond, "" + SE4->E4_DESCRI + "")
            dbSkip()
        end
    end

    dbSelectArea("SB1")
    dbSetOrder(1)
    dbSelectArea("SC7")
    oHtml:ValByName("numped", SC7->C7_NUM)
    cNum := SC7->C7_NUM

    dbSetOrder(1)
    dbSeek(xFilial("SC7")+cNum)

    // Preencher tabela do html chamada "produto" com seus respectivos campos 
    While !Eof .and. (C7_NUM == cNum)
        SB1->(dbSeek(xFilial("SB1")+SC7->C7_PRODUTO))
        nTotal := nTotal + C7_TOTAL
        AAdd((oHtml:ValByName("produto.item")),C7_ITEM)
        AAdd((oHtml:ValByName("produto.codigo")),C7_PRODUTO)
        AAdd((oHtml:ValByName("produto.descricao")),SB1->B1_DESC + C7_OBS + C7_XNOTAS)
        
        cValor := Transform(C7_QUANT,'@E 999,999.999999')
        AAdd((oHtml:ValByName("produto.qtd1")),cValor)
        AAdd((oHtml:ValByName("produto.un1")),C7_UM)

        cValor := Transform(C7_QTSEGUM,'@E 999,999.999999')
        AAdd((oHtml:ValByName("produto.qtd1")),cValor)
        AAdd((oHtml:ValByName("produto.un1")),C7_SEGUM)

        cValor := Transform(C7_PRECO,'@E 999,999,999.99')
        AAdd((oHtml:ValByName("produto.unitario")),cValor)

        cValor := Transform(C7_TOTAL,'@E 999,999,999.99')
        AAdd((oHtml:ValByName("produto.total")),cValor)

        cValor := Transform(C7_IPI,'@E 999.99')
        AAdd((oHtml:ValByName("produto.ipi")),cValor)

        cValor := Transform(C7_PCIM,'@E 999,999,999.99')
        AAdd((oHtml:ValByName("produto.cicms")),cValor)

        dDtEnt := Substr(C7_DATPRF,7,2) + "/" + Substr(C7_DATPRF,5,2) + "/" + Substr(C7_DATPRF,1,4)
        AAdd((oHtml:ValByName("produto.dataentrega")),dDtEnt)

        AAdd((oHtml:ValByName("produto.itemconta")),C7_ITEMCTA)

        nTotalProd	+= C7_TOTAL	//Totalizando Valor do produto
        nTotalSeg	+= C7_SEGURO // Totalizando Seguro
        nTotalFrete	+= C7_VALFRE // Totalizando Frete
		nTotalDesp  += C7_DESPESA // Totalizando Despesas
        nTotalIPI 	+= C7_VALIPI // Totalizando IPI

        nTotalDesc	+= C7_VLDESC  //Totalizando Descontos
		nTotalICMSRET += C7_ICMSRET // Totalizando ICMS Retido
		//nTotalAcre	+= aDados[nP,]  //Totalizando Acrescimo
		nTotalProd	+= C7_PRECO	//Totalizando Valor do produto
		nTotalCom	+= (C7_TOTAL + C7_VALIPI + C7_SEGURO + C7_DESPESA + C7_VALFRE) - (C7_VLDESC + C7_ICMSRET)  // Totalizando Valor do pedido de compras
		

    enddo

    nTotalProd := Transform(nTotalProd,'@E 999,999,999.99')
    AAdd((oHtml:ValByName("totalipi")),nTotalProd)

    nTotalSeg := Transform(nTotalSeg,'@E 999,999,999.99')
    AAdd((oHtml:ValByName("seguro")),nTotalSeg)

    nTotalFrete := Transform(nTotalFrete,'@E 999,999,999.99')
    AAdd((oHtml:ValByName("frete")),nTotalFrete)

    nTotalDesp := Transform(nTotalDesp,'@E 999,999,999.99')
    AAdd((oHtml:ValByName("despesas")),nTotalDesp)

    nTotalIPI := Transform(nTotalIPI,'@E 999,999,999.99')
    AAdd((oHtml:ValByName("totalipi")),nTotalIPI)

    nTotalDesc := Transform(nTotalDesc,'@E 999,999,999.99')
    AAdd((oHtml:ValByName("desconto")),nTotalDesc)

    nTotalICMSRET := Transform(nTotalICMSRET,'@E 999,999,999.99')
    AAdd((oHtml:ValByName("desconto")),nTotalICMSRET)

    nTotalCom := Transform(nTotalCom,'@E 999,999,999.99')
    AAdd((oHtml:ValByName("desconto")),nTotalCom)
*/
    cDestinatario := "rvalerio@westech.com.br"
    oProcess:cTo := cDestinatario

    // Finalize a primeira etapa do fluxo do processo, informando em que ponto e 
    // fluxo do processo foi executado e, posteriormente, repasse para o método
    
    cCodigoStatus := "100300"
    cDescricao := "Enviando pedido para " + cDestinatario
    oProcess:Track(cCodigoStatus, cDestinatario, cUsrCorrente)

    // Neste ponto, o processo será criado e será enviada uma mensagem para a lista de destinátarios
    oProcess:Start()
        
Return 
