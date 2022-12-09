#include 'protheus.ch'
#INCLUDE "TOTVS.CH"

#DEFINE SEPARADOR 			";"
#DEFINE PEDIDO_GAR           1
#DEFINE PEDIDO_SITE          2
#DEFINE PEDIDO_ECOM          3

#DEFINE SEM_ACENTO              .F. //Retira acento na funcao FwCutOff

//06/04/2021 - No metodo trataPostoGar foi alterado para retirar espacos de dados retornados pelo Parambox - bruno nunes


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CRPA081  |Autor: | Yuri Volpe            |Data: |09/11/2020   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Rotina de chamada do Menu para execução dos títulos de        |
//|             |adiantamentos de comissão realizados aos parceiros.           |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CRPA081()

    Private oVerde  	:= LoadBitmap( GetResources(), "BR_VERDE")    
    Private oAzul    	:= LoadBitmap( GetResources(), "BR_AZUL")
    Private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO")    
    Private oAmarelo    := LoadBitmap( GetResources(), "BR_AMARELO")    
    Private oPreto      := LoadBitmap( GetResources(), "BR_PRETO")    

    TroubleshootRemuneracao():New()

Return

/*/{Protheus.doc} processaArquivo
//Rotina responsável por processar o arquivo e realizar as devidas
//operações para gerar o título e o log final de processamento.
@author yuri.volpe
@since 16/07/2020
@version 1.0
@param cArquivo, characters, Caminho e nome do arquivo
@type function
/*/
Class TroubleshootRemuneracao

    Data aParam as Array

    Method New() Constructor
    Method abreTela()
    Method trataValorFat()
    Method deletaLancamento()
    Method trataKitCombo()
    Method trataHWAvulso()
    Method geraAdiantamento()
    Method trataSAGE()
    Method montaParambox()
    Method resetParam()
    Method zerarValores()
    Method alteraStatus()
    Method alteraLinkCampanha()
    Method verificaPedidos(aPedidos)
    Method reprocessar()
    Method forcaCalculo()
    Method importaPlanilhas()
    Method trataVerificacao(cArquivo)
    Method trataRenovacao(cArquivo)
    Method trataRevenda(cArquivo)
    Method recalcular(aPedidos, cPeriodo)
    Method reimportar(aPedidos)
    Method criaTelaGrid(aCabec, aDados)
    Method relProdutos()
    Method testeTela()
    Method getValorFaturamentoVoucher(aPedidos)
    Method getValorPedidoGar(aPedidos)
    Method getRecnoPGAR(cPedGAR)
    Method getRecnoPSite(cPedSite)
    Method getValorSZG(cPedidoGAR)
    Method trataPostoGar()
    Method reprocCampos()
    Method updDadosSZ6()
    Method hasVoucher(cPedidoGAR)
    Method alteraDescProduto()
    Method alteraDataEventos()
    Method verificaCampanha()
    Method geraRetificacao()
    Method corrigeFaixa()
    Method alteraPedidoGAR()
    Method fixSomethingUnusual()
    Method consultaTipoVoucher()
    Method reprocGTIN()
    Method getPedidoSite()

EndClass

/*/{Protheus.doc} processaArquivo
//Rotina responsável por processar o arquivo e realizar as devidas
//operações para gerar o título e o log final de processamento.
@author yuri.volpe
@since 16/07/2020
@version 1.0
@param cArquivo, characters, Caminho e nome do arquivo
@type function
/*/
Method New() Class TroubleshootRemuneracao

    ::abreTela()

Return

/*/{Protheus.doc} processaArquivo
//Rotina responsável por processar o arquivo e realizar as devidas
//operações para gerar o título e o log final de processamento.
@author yuri.volpe
@since 16/07/2020
@version 1.0
@param cArquivo, characters, Caminho e nome do arquivo
@type function
/*/
Method abreTela() Class TroubleshootRemuneracao

    Local nRadio     := 0
    Local aItems     := {}
    Local oRadio     := Nil
    Local oGroup     := Nil
    Local oBtOk      := Nil
    Local oBtCanc    := Nil
    Local nLimLeft   := 100
    Local nMaxHeight := 280
    Local nBotaoOk   := 01
    Local nBotaoCanc := 02
    Local nHeightTel := 768
    Local nWidthTela := 1080
    Local nGrpHeight := 265
    Local nGrpWidth  := 130

    private oDlg := nil

    dbSelectArea("SZ6")
    dbSelectArea("SZ5")
    dbSelectArea("SZ3")
    dbSelectArea("SZF")
    dbSelectArea("SZG")
    dbSelectArea("SC5")
    dbSelectArea("SC6")

    While nRadio != 99
        oDlg := TDialog():New(180,180, nHeightTel, nWidthTela, "Troubleshoot Remuneração",,,,,,,,,.T.)

            oGroup  := TGroup():New(02,02, nGrpHeight, nGrpWidth,'Remuneração',oDlg,/*nClrText*/,/*nClrPane*/,.T.)

            aItems  := {'01 - Reprocessamento',;             // 01
                        '02 - Pedido sem Valor Fat SW/HW',;  // 02
                        '03 - Deletar Lançamentos',;         // 03
                        '04 - Kit Combo Incorreto',;         // 04
                        '05 - HW Avulso',;                   // 05
                        '06 - Zerar Valores',;               // 06
                        '07 - Correção SAGE/Sintese NET',;   // 07
                        '08 - Ajusta Posto GAR',;            // 08
                        '09 - Altera Status pedidos',;       // 09
                        '10 - Altera link campanha',;        // 10
                        '11 - Verifica Pedidos',;            // 11
                        '12 - Força Cálculo Entidade',;      // 12
                        '13 - Ajusta Pedidos Renovação',;    // 13
                        '14 - Importa Planilhas BI',;        // 14
                        '15 - Reimporta campos',;            // 15
                        '16 - Atualiza dados SZ6',;          // 16
                        '17 - Relatório Produtos Específicos',;  // 17
                        '18 - Verifica Campanha',;           // 18
                        '19 - Altera data eventos',;         // 19
                        '20 - Gera Retificação',;            // 20
                        '21 - Corrige Faixa de Pedidos',;    // 21
                        '22 - Altera Pedido GAR SC6',;
                        '22 - Consulta Tipo de Voucher',;
                        '23 - Fix Something Unusual',;
                        '24 - Gera Adiantamento'}            // 12

            oRadio  := TRadMenu():New (13,05,aItems,,oDlg,,,,,,,,100,12,,,,.T.)
            oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}
            
            oBtOk   := SButton():New( nMaxHeight,nLimLeft - 30,nBotaoOk  ,{|| oDlg:End()               },oDlg,.T.,,)
            oBtCanc := SButton():New( nMaxHeight,nLimLeft     ,nBotaoCanc,{|| nRadio := 99, oDlg:End() },oDlg,.T.,,)        

        oDlg:Activate(,,,.T.,{||.T.},, )

        //Alert(cValToChar(nRadio))

        Do Case
            Case nRadio == 1
                Processa( {|| ::reprocessar()}, "Reprocessamento", "Processando pedidos...", .F.)
            Case nRadio == 2
                Processa( {|| ::trataValorFat()}, "Correção Valor de Faturamento", "Processando pedidos...", .F.)
            Case nRadio == 3
                ::deletaLancamento()
            Case nRadio == 4
                ::trataKitCombo()
            Case nRadio == 5
                ::trataHWAvulso()
            Case nRadio == 6
                ::zerarValores()
            Case nRadio == 7
                Processa( {|| ::trataSAGE()}, "Correção SAGE/Sintese NET", "Processando pedidos...", .F.)
            Case nRadio == 8
                Processa( {|| ::trataPostoGar()}, "Correção POSTO GAR", "Ajustando pedidos de Renovação", .F.)
            Case nRadio == 9
                ::alteraStatus()
            Case nRadio == 10
                ::alteraLinkCampanha()
            Case nRadio == 11
                ::verificaPedidos()
            Case nRadio == 12
                ::forcaCalculo()
            Case nRadio == 13
                ::trataRenovacao()      
            Case nRadio == 14 
                ::importaPlanilhas()          
            Case nRadio == 15
                Processa( {||::reprocCampos()}, "Reimportação de dados", "Reimportando dados do GAR", .F.)
            Case nRadio == 16
                ::updDadosSZ6()
            Case nRadio == 17
                ::relProdutos()                
            Case nRadio == 18
                ::verificaCampanha()
            Case nRadio == 19
                Processa( {|| ::alteraDataEventos()}, "Altera Datas Eventos", "Ajustando datas dos pedidos", .F.)
            Case nRadio == 20
                ::geraRetificacao()
            Case nRadio == 21
                ::corrigeFaixa()
            Case nRadio == 22
                ::alteraPedidoGAR()
            Case nRadio == 23
                Processa({|| ::consultaTipoVoucher()}, "Consulta Vouchers", "Localizando vouchers", .F.)
            Case nRadio == 24
                Processa( {|| ::fixSomethingUnusual()}, "Erros Pontuais", "Hardcoding valores", .F.)
            Case nRadio == 25
                ::geraAdiantamento()                
            Otherwise
                Alert("Rotina encerrada.")
                nRadio := 99
        EndCase

        If nRadio != 99
            nRadio := 0 
        EndIf

    EndDo

Return

/*/{Protheus.doc} reprocessar
// Método responsável por reprocessar os pedidos, realizando a importação dos dados do GAR
// para a tabela SZ5 e Forçando o Cálculo para gerar a tabela SZ6. 
// é utilizando um processo de SLEEP para evitar a sobreposição de execução, uma vez que as
// rotinas são executadas a partir do StartJob, cujo retorno não é tratado pelo Sistema.
@author yuri.volpe
@since 13/11/2020
@version 1.0
@param null
@type method
/*/
Method reprocessar() Class TroubleshootRemuneracao

    Local aProc     := {"1-Apenas recalcula","2-Reimporta e recalcula","3-Apenas reimporta"}
    Local aTpPed    := {"1-Pedido GAR","2-Pedido Site"}
    Local aPeriodo  := {"1-Corrente","2-Próximo"}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.},;
                        {2,"Tipo Pedido","1-Pedido GAR",aTpPed,75,"",.F.},;
                        {2,"Processamento","1-Apenas recalcula",aProc,75,"",.F.},;
                        {2,"Período","1-Corrente",aPeriodo,75,"",.T.},;
                        {5,"DEBUG",.F.,50,"",.F.},;
                        {5,"Skip Wait?",.F.,50,"",.F.}}
    Local Ni        := 1
    Local aPedidos  := {}
    Local aRecnos   := {}
    Local cPeriodo  := GetMV("MV_REMMES")
    Local cTpPedido := ""
    Local cProcesso := ""
    Local aCabec    := {}
    Local lDebug    := .F.
    Local lNoWait   := .F.

    // Cria Parambox para parametrização
    aRet := ::montaParambox(aPergs, "Reprocessamento de Pedidos")

    // Se Parambox foi cancelada, sai da rotina
    If Len(aRet) == 0
        Return .F.
    EndIf

    aAdd(aCabec, {"Valor Base"      ,"VALBAS","@E 999,999.99", TamSX3("Z5_VALOR")[1],TamSX3("Z5_VALOR")[2],"N",.F.})
    aAdd(aCabec, {"Valor comissão"  ,"VALCOM","@E 999,999.99", TamSX3("Z5_VALOR")[1],TamSX3("Z5_VALOR")[2],"N",.F.})
    aAdd(aCabec, {"Percentual"      ,"PERCEN","@E 999.99"    , TamSX3("Z5_COMSW")[1],TamSX3("Z5_COMSW")[2],"N",.F.})

    //Considera Período 1 - Corrente; 2 - Próximo.
    cPeriodo := Substr(aRet[4],1,1)
    //Tipo de Processamento 1 - Sé recalcula; 2 - Reimporta do GAR e Recalcula; 3 - Sé Reimporta do GAR
    cProcesso := Substr(aRet[3],1,1)
    //Tipo de Pedido 1 - Pedido GAR; 2 - Pedido Site
    cTpPedido := Substr(aRet[2],1,1)
    //Indica se deve debugar o CRPA020
    lDebug := aRet[5]
    lNoWait := aRet[6]

    dbSelectArea("SZ5")
    SZ5->(dbSetOrder(1))

    ProcRegua(Len(::aParam))
    
    //Atributo aParam é alimentado pelo Método montaParambox
    For Ni := 1 To Len(::aParam)

        nRecno := 0

        IncProc("Processando: " + ::aParam[Ni])
        ProcessMessage()

        //Pedido GAR
        If cTpPedido == "1"

            aAdd(aPedidos, {::aParam[Ni],0,""})
            
            nRecno := ::getRecnoPGAR(::aParam[Ni])
            If nRecno > 0
                //Utiliza o RECNO para recalculo e o némero do Pedido GAR para reimportação
                aAdd(aRecnos, {nRecno})
            EndIf

        Else
            //Força que o processo é sé Cálculo, uma vez que o Pedido Site não tem como reimportar para a SZ5
            cProcesso := "1"

            nRecno := ::getRecnoPSite(::aParam[Ni])

            If nRecno > 0
                aAdd(aRecnos, {nRecno})
            EndIf
        EndIf
    Next

    //Se hé algum pedido para reimportar ou recalcular
    If Len(aPedidos) > 0 

        //Trata qual é o processo para evitar que pedidos Site sejam reimportados
        //Apenas para Reimportação e recalculo (2) ou Sé Reimportação (3)
        If cProcesso == "2" .Or. cProcesso == "3"
            ::reimportar(aPedidos, lDebug, lNoWait)
        EndIf
    EndIf

    if Len(aRecnos) > 0
        //Apenas para Reimportação e recalculo (2) ou Sé recalculo (1)
        If cProcesso == "1" .Or. cProcesso == "2"
            ::recalcular(aRecnos, cPeriodo, lDebug, lNoWait)
        EndIf

    EndIf

Return

Method trataValorFat() Class TroubleshootRemuneracao

    Local aRet := {}
    Local aPeriodo  := {"1-Corrente","2-Próximo"}
    Local aForcaHw  := {"1-Sim","2-Não","3-Zerar"}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.},;
                        {2,"Período","1-Corrente",aPeriodo,100,"",.T.},;
                        {2,"Força HW?","2-Não",aForcaHw,100,"",.T.}}
    Local Ni        := 1
    Local aRecnos   := {}
    Local cPeriodo  := ""
    Local aCabec    := {}
    Local aDados    := {}
    Local lForcaHw  := .F.
    Local lTemHard  := .F.
    Local lZerarHW  := .F.

    //Motivos do pedido sem valor de faturamento:
    // SZ5 não atualizou valores
    // Voucher com problema
    // Pedido de Venda "quebrado"
    // Composiééo do Valor na SZ5 diferente do valor do checkout

    //1 - Analisar os pedidos
    //2 - Devolver em tela resultado de anélise
    //3 - Possibilitar aééo manual

    aRet := ::montaParambox(aPergs, "Pedidos sem Valor de Faturamento")

    If Len(aRet) == 0
        Return .F.
    EndIf

    ProcRegua(Len(::aParam))

    If Len(aRet) > 0

        cPeriodo := Substr(aRet[2],1,1)
        lForcaHw := Substr(aRet[3],1,1) == "1"
        lZerarHW := Substr(aRet[3],1,1) == "3"

        aAdd(aCabec, {"Vlr. Anterior","VALANT","@E 999,999.99", TamSX3("Z5_VALOR")[1],TamSX3("Z5_VALOR")[2],"N",.F.})
        aAdd(aCabec, {"Vlr. Novo"    ,"VALNEW","@E 999,999.99", TamSX3("Z5_VALOR")[1],TamSX3("Z5_VALOR")[2],"N",.F.})
        aAdd(aCabec, {"Vlr. SW"    ,"VALSW","@E 999,999.99", TamSX3("Z5_VALOR")[1],TamSX3("Z5_VALOR")[2],"N",.F.})
        aAdd(aCabec, {"Vlr. HW"    ,"VALHW","@E 999,999.99", TamSX3("Z5_VALOR")[1],TamSX3("Z5_VALOR")[2],"N",.F.})
        aAdd(aCabec, {"Mensagem"     ,"MENSAG","@!", 150, 0, "C", .F.})     
        
        For Ni := 1 To Len(::aParam)

            IncProc("Buscando Valor: " + ::aParam[Ni])
            ProcessMessage()

            dbSelectArea("SZ5")
            SZ5->(dbSetOrder(1))
            If SZ5->(dbSeek(xFilial("SZ5") + ::aParam[Ni]))

                If ::hasVoucher(::aParam[Ni])
                    aValores := ::getValorFaturamentoVoucher(::aParam[Ni])
                Else
                    aValores := ::getValorPedidoGar(::aParam[Ni])
                EndIf

                If Len(aValores) > 0

                    nValorTotal := aValores[1]
                    nValorSw    := aValores[2]
                    nValorHw    := aValores[3]
                    lTemHard    := aValores[4]
    
                    If (lTemHard .And. nValorHw == 0 .And. (nValorTotal - nValorSw != 0) ) .Or. lForcaHw
                        nValorHw := nValorTotal - nValorSw
                    EndIf

                    If nValorSw == 0 .And. (nValorTotal - nValorHw != 0)
                        nValorSw := nValorTotal - nValorHw
                    EndIf

                    nValAnt := SZ5->Z5_VALOR

                    RecLock("SZ5", .F.)
                        SZ5->Z5_VALOR    := Iif(SZ5->Z5_VALOR != nValorTotal .And. nValorTotal > 0, nValorTotal, SZ5->Z5_VALOR)
                        SZ5->Z5_VALORSW  := Iif(SZ5->Z5_VALORSW != nValorSw .And. nValorSw > 0, nValorSw, SZ5->Z5_VALORSW)
                        SZ5->Z5_VALORHW  := Iif(SZ5->Z5_VALORHW != nValorHw .And. Iif(lTemHard,nValorHw > 0,.T.), nValorHw, SZ5->Z5_VALORHW)
                        if lZerarHW
                            SZ5->Z5_VALOR    := nValorSw
                            SZ5->Z5_VALORHW  := 0
                        endif
                    SZ5->(MsUnlock())

                    aAdd(aDados, {oVerde, SZ5->Z5_PEDGAR, "", "", "", nValAnt, SZ5->Z5_VALOR, SZ5->Z5_VALORSW, SZ5->Z5_VALORHW, Iif(nValAnt != SZ5->Z5_VALOR, "Valor alterado.", "Pedido processado sem alteraééo."),.F.})
                    aAdd(aRecnos, {SZ5->(Recno())})
                Else
                    aAdd(aDados, {oVermelho, SZ5->Z5_PEDGAR, "", "", "", SZ5->Z5_VALOR, 0, 0, 0, "Falha na obtenééo dos valores do pedido.",.F.})
                EndIf
            EndIf
        Next

    EndIf

    If Len(aRecnos) > 0
        ::recalcular(aRecnos, cPeriodo)
    EndIf

    If Len(aDados) > 0
        ::criaTelaGrid(aCabec, aDados)
    EndIf

Return

Method hasVoucher(cPedidoGAR) Class TroubleshootRemuneracao

    Local cVoucher := ""

    If !Empty(SZ5->Z5_CODVOU)
        cVoucher := SZ5->Z5_CODVOU
    Else
        oChkOut := CheckoutRestClient():New(cPedidoGAR, PEDIDO_GAR)
        cVoucher := oChkOut:getVoucher()
        
        FreeObj(oChkOut)
        oChkOut := Nil
    EndIf

Return !Empty(cVoucher)

Method getValorFaturamentoVoucher(cPedido, nTipoPedido, cPedOrigem) Class TroubleshootRemuneracao

    Local oChkOut       := Nil
    //Local oVoucher      := Nil
    Local cVoucher      := ""
    Local aRet          := {}
    Local lPedGar       := .F.
    Local lPedSite      := .F.
    Local aAreaSZF      
    Local aAreaSZG
    Local aAreaSZ5

    DEFAULT nTipoPedido := PEDIDO_GAR
    DEFAULT cPedOrigem  := ""

    dbSelectArea("SZF")
    dbSelectArea("SZG")
    dbSelectArea("SZ5")
    dbSelectArea("SC6")

    If nTipoPedido == PEDIDO_GAR
        nRecno := ::getRecnoPGAR(cPedido) 
    ElseIf nTipoPedido == PEDIDO_SITE
        nRecno := ::getRecnoPSite(cPedido) 
    EndIf

    If nRecno == 0 .Or. Empty(SZ5->Z5_CODVOU)

        oChkOut := CheckoutRestClient():New(cPedido, nTipoPedido)
        cVoucher := oChkOut:getVoucher()
        
        FreeObj(oChkOut)
        oChkOut := Nil
    
    Else
        cVoucher := SZ5->Z5_CODVOU
    EndIf

    If !Empty(cVoucher)

        /*oVoucher := Voucher():New()
        oVoucher:find(cVoucher)*/

        SZF->(dbSetOrder(2))
        If SZF->(dbSeek(xFilial("SZF") + cVoucher)) 

            If AllTrim(SZF->ZF_TIPOVOU) $ "2/A/B/"

                lPedGAR := !Empty(SZF->ZF_PEDIDO) .And. !Empty(StrTran(SZF->ZF_PEDIDO, "*","")) .And. !Empty(StrTran(SZF->ZF_PEDIDO, ".",""))
                If !lPedGAR
                    //Pedido GAR Origem Inválido, indo pelo pedSite
                    lPedSite := !Empty(SZF->ZF_PEDSITE) .And. !Empty(StrTran(SZF->ZF_PEDSITE, "*","")) .And. !Empty(StrTran(SZF->ZF_PEDSITE, ".",""))
                    If !lPedSite
                        //Pedido Site Origem Inválido
                        //Encerra execução porque o tipo de voucher requer pedido origem vinculado
                        //Verifica se hé voucher no pedido origem, pelo Checkout
                    EndIf
                EndIf

                If lPedGar
                    cPedOrigem := cPedido
                    cPedido := SZF->ZF_PEDIDO
                    nTipoPedido := PEDIDO_GAR
                ElseIf lPedSite
                    cPedOrigem := cPedido
                    cPedido := SZF->ZF_PEDSITE
                    nTipoPedido := PEDIDO_SITE
                EndIf

                If lPedGar .Or. lPedSite
                    aAreaSZ5 := SZ5->(GetArea())
                    aAreaSZF := SZF->(GetArea())
                    aAreaSZG := SZG->(GetArea())
                    
                    aRet := ::getValorFaturamentoVoucher(cPedido, nTipoPedido, cPedOrigem)

                    RestArea(aAreaSZ5)
                    RestArea(aAreaSZF)
                    RestArea(aAreaSZG)
                EndIf

                If Len(aRet) == 0
                    If SZF->ZF_VALOR > 0 
                        aRet := {SZF->ZF_VALOR, SZF->ZF_VALOR, 0, .F.}
                    EndIf
                EndIf

            ElseIf AllTrim(SZF->ZF_TIPOVOU) == "F"
                aRet := ::getValorPedidoGar(SZ5->Z5_PEDGAR)
            ElseIf AllTrim(SZF->ZF_TIPOVOU) == "H"

                If Len(aRet) == 0 .And. !Empty(SZ5->Z5_PEDGANT)
                    aRet := ::getValorPedidoGar(SZG->ZG_PEDGANT, .F.)
                EndIf

                If Len(aRet) == 0 .And. !Empty(SZF->ZF_PEDIDO)
                    aRet := ::getValorPedidoGar(SZF->ZF_PEDIDO, .F.)
                EndIf

            Else
                aRet := {SZF->ZF_VALOR, SZF->ZF_VALORSW, SZF->ZF_VALORHW, .F.}
            EndIf

        EndIf
    Else

        If SZ5->Z5_VALOR > 0
            aRet := {SZ5->Z5_VALOR, SZ5->Z5_VALORSW, SZ5->Z5_VALORHW, .F.}
        Else
            aRet := ::getValorSZG(cPedOrigem)
        EndIf

    EndIf

Return aRet

Method getValorSZG(cPedidoGAR) Class TroubleshootRemuneracao

    Local aRet      := {}
    Local cPedOri   := ""
    Local nValSw    := 0
    Local nValHw    := 0
    Local lTemHard  := .F.

    dbSelectArea("SZG")
    SZG->(dbSetOrder(1))
    If SZG->(dbSeek(xFilial("SZG") + cPedidoGAR))

        SC6->(dbSetOrder(1))
        If SC6->(dbSeek(xFilial("SZ6") + SZG->ZG_PEDIDO))
            
            cPedOri := SC6->C6_XIDPEDO

            While SC6->(!EOF()) .And. SC6->C6_NUM == SZG->ZG_PEDIDO .And. SC6->C6_XIDPEDO == cPedOri
                
                If AllTrim(SC6->C6_XOPER) $ "51/61" .And. AllTrim(SC6->C6_PRODUTO) != "CC010060"
                    nValSW := SC6->C6_VALOR
                ElseIf AllTrim(SC6->C6_XOPER) $ "52/62"
                    nValHW := SC6->C6_VALOR
                    lTemHard := .T.
                EndIf

                SC6->(dbSkip())
            EndDo
            
            If nValSw + nValHw > 0
                aRet := {nValSW + nValHW, nValSW, nValHW, lTemHard}
            EndIf                
        EndIf
    EndIf

Return aRet

Method getValorPedidoGar(cPedidoGAR, lPosiciona) Class TroubleshootRemuneracao

    Local oChkOut   := Nil
    Local cPedSite  := ""
    Local cPedOri   := ""
    Local nValSW    := 0
    Local nValHW    := 0
    Local nValChk   := 0
    Local aRet      := {}
    Local lTemHard  := .F.

    DEFAULT lPosiciona := .T.

    oChkOut := CheckoutRestClient():New(cPedidoGAR)
    cPedSite := oChkOut:getPedSiteFromPedGar()
    nValChk := oChkOut:getValorBruto()

    If !Empty(cPedSite)
        dbSelectArea("SC5")
        dbSelectArea("SC6")

        SC5->(dbOrderNickName("PEDSITE"))
        SC6->(dbSetOrder(1))

        If SC5->(dbSeek(xFilial("SC5") + cPedSite))
            If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))

                cPedOri := SC6->C6_XIDPEDO
                nValSw := 0
                nValHw := 0

                While SC6->(!EOF()) .And. SC6->C6_NUM == SC5->C5_NUM .And. SC6->C6_XIDPEDO == cPedOri
                    
                    If AllTrim(SC6->C6_XOPER) $ "51/61"
                        nValSW += SC6->C6_VALOR
                    ElseIf AllTrim(SC6->C6_XOPER) $ "52/62"
                        nValHW += SC6->C6_VALOR
                        lTemHard := .T.
                    EndIf

                    SC6->(dbSkip())
                EndDo

                If nValChk != nValSw + nValHw
                    If nValSw == 0
                        nValSw := nValChk - nValHw
                    EndIf

                    If nValHw == 0 .And. lTemHard
                        nValHw := nValChk - nValSw
                    EndIf
                EndIf

                If nValSw + nValHw > 0
                    aRet := {nValSW + nValHW, nValSW, nValHW, lTemHard}
                    
                    If lPosiciona
                        ::getRecnoPGAR(cPedidoGAR)
                    EndIf
                EndIf

            EndIf
        EndIf
    EndIf

    FreeObj(oChkOut)
    oChkOut := Nil

Return aRet

Method trataHWAvulso() Class TroubleshootRemuneracao

    Local aEnt   := {"1-Código Protheus","2-Código GAR"}
    Local aPeri  := {"1-Atual","2-Próximo"}
    Local aPergs := {{11, "Pedidos", "", '.T.', '.T.', .T.},;
                    {1,"Código Parceiro",Space(6),"@!","","","",50,.F.},;
                    {2,"Tipo de Entidade","1-Código Protheus",aEnt,50,"",.F.},;
                    {2,"Período","1-Atual",aPeri,50,"",.F.}}
    Local Ni        := 1
    Local aRet      := {}
    Local aRecnos   := {}
    Local nIndex    := ""
    Local cCodPar   := ""
    Local cCodGAR   := ""
    Local cPeriodo  := ""
    Local aCabec    := {}
    Local aDados    := {}
    Local cMsgLog   := ""

    aRet := ::montaParambox(aPergs, "Trata HW Avulso")

    If Len(aRet) == 0
        Return .F.
    EndIf
        
    If Len(::aParam) > 0

        cCodPar := AllTrim(aRet[2])
        nIndex := Iif(Substr(aRet[3],1,1) == "1", 1, 4)
        cPeriodo := Substr(aRet[4],1,1)

        dbSelectArea("SZ3")

        If !Empty(cCodPar)
            
            SZ3->(dbSetOrder(nIndex))
            If SZ3->(dbSeek(xFilial("SZ3") + cCodPar))

                cCodGAR := SZ3->Z3_CODGAR

            Else
                Alert("Parceiro não localizado. Verifique com a érea de Negécio o Código correto.")
                Return .F.
            EndIf

       /* Else
            aAdd(aLog,{"O Código do parceiro está em branco."})
            Return .F.*/
        EndIf

        //If !Empty(cCodGAR)

            dbSelectArea("SC5")
            SC5->(dbOrderNickname("PEDSITE"))

            For Ni := 1 To Len(::aParam)

                If SC5->(dbSeek(xFilial("SC5") + ::aParam[Ni]))

                    If !Empty(SC5->C5_XPOSTO) .And. Empty(cCodGAR)
                        cCodGAR := SC5->C5_XPOSTO
                    EndIf

                    If Empty(cCodGar)
                        aAdd(aDados, {oVermelho, "", SZ5->Z5_PEDSITE, SC6->C6_XNPECOM, SC6->C6_NUM, "não hé posto de entrega de HW vinculado ao pedido.", .F.})
                        Loop
                    EndIf

                    dbSelectArea("SZ5")
                    SZ5->(dbSetOrder(3))
                    If SZ5->(dbSeek(xFilial("SZ5") + SC5->C5_NUM))
                        aAdd(aRecnos,{SZ5->(Recno())})
                        aAdd(aDados, {oVerde, "", SZ5->Z5_PEDSITE, SC6->C6_XNPECOM, SC6->C6_NUM, "Pedido jé criado na SZ5. Pedido recalculado", .F.})
                        Loop
                    EndIf
                    
                    If Empty(SC5->C5_XPOSTO) .Or. AllTrim(SC5->C5_XPOSTO) != cCodGAR
                        RecLock("SC5",.F.)
                            SC5->C5_XPOSTO := cCodGAR
                        SC5->(MsUnlock())

                        cMsgLog += "Posto vinculado: " + cCodGAR + ". "
                    EndIf

                    dbSelectArea("SC6")
                    SC6->(dbSetOrder(1))
                    If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))

                        While SC6->(!EoF()) .And. SC6->C6_NUM == SC5->C5_NUM
                            If (SC6->C6_XOPER == "53" .OR. SC6->C6_XOPER == "62" .Or. SC6->C6_XOPER == "01") .AND.;
                                 !Empty(SC5->C5_XPOSTO) .AND. !Empty(SC5->C5_XNPSITE)//Venda Avulsa
                                
                                //Campos adicionados para a gravação de informações perinentes a midia avulsa
                                SZ5->(DbselectArea("SZ5"))
                                
                                Reclock('SZ5',.T.)
                                SZ5->Z5_EMISSAO := GetAdvFVal("SF2", "F2_EMISSAO", xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE, 1)
                                SZ5->Z5_VALOR   := SC6->C6_VALOR
                                SZ5->Z5_PRODUTO := SC6->C6_PRODUTO
                                SZ5->Z5_DESPRO  := SC6->C6_DESCRI
                                SZ5->Z5_CODVOU  := SC6->C6_XNUMVOU
                                SZ5->Z5_PRODGAR := SC6->C6_PROGAR
                                SZ5->Z5_TIPO    := "ENTHAR"                           //REMUNERA O POSTO/AR PELA ENTREGA DA MéDIA
                                SZ5->Z5_TIPODES := "ENTREGA HARDWARE AVULSO"
                                SZ5->Z5_VALORHW := SC6->C6_VALOR
                                SZ5->Z5_PEDIDO  := SC6->C6_NUM
                                SZ5->Z5_ITEMPV  := SC6->C6_ITEM
                                SZ5->Z5_ROTINA  := "TRBLSHOOT"
                                SZ5->Z5_CODPOS  := SC5->C5_XPOSTO
                                SZ5->Z5_TIPMOV  := SC5->C5_TIPMOV
                                SZ5->Z5_TABELA  := SC5->C5_TABELA
                                SZ5->Z5_PEDSITE := SC5->C5_XNPSITE
                                
                                SZ3->(DbSetOrder(6))
                                If SZ3->(DbSeek(xFilial("SZ3") + "4" + SZ5->Z5_CODPOS))
                                    SZ5->Z5_DESPOS	:= SZ3->Z3_DESENT
                                    SZ5->Z5_REDE    := SZ3->Z3_REDE
                                    SZ5->Z5_DESCAR	:= SZ3->Z3_DESAR
                                EndIf
                                
                                SZ5->(MsUnlock())

                                cMsgLog += "Item PV: " + SC6->C6_ITEM + ". Registro incluédo. Recno: " + cValToChar(SZ5->(Recno())) + " | "

                                aAdd(aRecnos,{SZ5->(Recno())})
                            Else
                                cMsgLog += "Item PV: " + SC6->C6_ITEM + ". Não é Hardware Avulso | "               
                            EndIf
					
                        aAdd(aDados, {oVerde, "", SZ5->Z5_PEDSITE, SC6->C6_XNPECOM, SC6->C6_NUM, cMsgLog, .F.})
						SC6->(dbSkip())
                        EndDo

                        cMsgLog := ""
                    EndIf

                EndIf

            Next

            If Len(aRecnos) > 0
                ::recalcular(aRecnos, cPeriodo)
            EndIf

        //EndIf


    EndIf

    If Len(aDados) > 0 
        aAdd(aCabec, {"Mensagem","MSGLOG","",250,0,"C",.F.})
        ::criaTelaGrid(aCabec, aDados)
        ::verificaPedidos(aRecnos)
    EndIf


Return

/*/{Protheus.doc} deletaLancamento
// Método responsável por deletar os registros de Retificação do(s) pedido(s) indicados no Parambox.
@author yuri.volpe
@since 13/11/2020
@version 1.0
@param null
@type method
/*/
Method deletaLancamento() Class TroubleshootRemuneracao

    Local aEnt      := {"1-Canal","2-AC","4-Postos","5-ACBR","7-Campanha","8-Federação","9-Todos"}
    Local aTpPed    := {"1-Retificação","2-Reembolso","3-Extra","4-Desconto","5-Remuneração","6-Não Pago","7-Pago Anteriormente","8-Voucher Não Remunerado"}
    Local aTpLin    := {"1-Hardware","2-Software","3-Todos"}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.},;
                        {2,"Tipo de Entidade","9-Todos",aEnt,75,"",.F.},;
                        {2,"Tipo de Lanéamento","1-Retificação",aTpPed,75,"",.F.},;
                        {2,"Linha de Cálculo","1-Hardware",aTpLin,75,"",.F.},;
                        {1,"Cod. Parceiro",Space(6),"@!","","SZ3","",75,.F.},;
                        {1,"Período",AllTrim(GetMV("MV_REMMES")),"@!","","","",75,.F.}}
    Local nCount    := 0
    Local Ni        := 1
    Local aRet      := {}
    Local cTpEnt    := ""
    Local cCodEnt   := ""
    Local cPeriodo  := ""
    Local cTpLin    := ""

    aRet := ::montaParambox(aPergs, "Deleta Lançamentos")

    If Len(aRet) == 0
        Return .F.
    EndIf
        
    If Len(::aParam) > 0

        cTpEnt    := Substr(aRet[2],1,1)
        cTpLancto := Substr(aRet[3],1,1)
        cCodEnt   := AllTrim(aRet[4])
        cPeriodo  := AllTrim(aRet[5])
        cCodEnt   := AllTrim(aRet[5])
        cPeriodo  := AllTrim(aRet[6])
        cTpLin    := Substr(aRet[4],1,1)        

        Do Case 
            Case Substr(aRet[3],1,1) == "1"
                cTpLancto := "RETIFI"
            Case Substr(aRet[3],1,1) == "2"
                cTpLancto := "REEMBO"
            Case Substr(aRet[3],1,1) == "3"
                cTpLancto := "EXTRA"
            Case Substr(aRet[3],1,1) == "4"
                cTpLancto := "DESCON"
            Case Substr(aRet[3],1,1) == "5"
                cTpLancto := "VERIFI"
            Case Substr(aRet[3],1,1) == "6"
                cTpLancto := "NAOPAG"
            Case Substr(aRet[3],1,1) == "7"
                cTpLancto := "PAGANT"
            Case Substr(aRet[3],1,1) == "8"
                cTpLancto := "PNOPAG"
        EndCase

        dbSelectArea("SZ6")
        SZ6->(dbSetOrder(1))

        If cTpLancto $ "EXTRA/DESCON"

            BeginSql Alias "TMPEXTRA"
                SELECT R_E_C_N_O_ 
                FROM %Table:SZ6% 
                WHERE 
                    Z6_CODENT   = %Exp:cCodEnt%
                AND Z6_TIPO     = %Exp:cTpLancto%
                AND Z6_PERIODO  = %Exp:cPeriodo
                AND %NotDel%
            EndSql

            While TMPEXTRA->(!EoF())

                dbSelectArea("SZ6")
                SZ6->(dbGoTo(TMPEXTRA->R_E_C_N_O_))

                RecLock("SZ6",.F.)
                    SZ6->(dbDelete())
                SZ6->(MsUnlock())

                TMPEXTRA->(dbSkip())

            EndDo
                

        Else 
            For Ni := 1 To Len(::aParam)

                If SZ6->(dbSeek(xFilial("SZ6") + ::aParam[Ni]))
                    
                    While SZ6->(!EoF()) .And. AllTrim(SZ6->Z6_PEDGAR) == AllTrim(::aParam[Ni])

                        If SZ6->Z6_TIPO == cTpLancto .And. (AllTrim(SZ6->Z6_TPENTID) == cTpEnt .Or. cTpEnt == "9") .And. SZ6->Z6_PERIODO == cPeriodo .And.;
                            (AllTrim(SZ6->Z6_CATPROD) == cTpLin .Or. cTpLin == "3")

                            RecLock("SZ6",.F.)
                                SZ6->(dbDelete())
                            SZ6->(MsUnlock())
                            
                            nCount++
                        EndIf

                        SZ6->(dbSkip())
                    EndDo

                EndIf
            Next
        EndIf

        If nCount > 0
            Alert("Foram deletados " + cValToChar(nCount) + " registros de " + Substr(aRet[3],3) + " para " + Substr(aRet[2],3) + " entidades e " + Substr(aRet[4],3) + " linhas.")
        Else
            Alert("Nenhum registro de Retificação foi localizado.")
        EndIf

    Else
        Alert("Nenhum pedido foi informado.")
    EndIf

Return

/*/{Protheus.doc} trataSAGE
// Método responsável por ajustar os valores dos pedidos SAGE, de modo a considerar
// apenas o Certificado para Remuneração.
@author yuri.volpe
@since 13/11/2020
@version 1.0
@param null
@type method
/*/
Method trataSAGE() Class TroubleshootRemuneracao

    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.}}
    Local Ni        := 1
    Local nValor    := 0
    Local nValAnt   := 0
    Local cPedSite  := ""
    Local oChkout   := Nil
    Local aPedidos  := {}
    Local aDados    := {}
    Local aCabec    := {}
    Local lAlterou  := .F.

    aRet := ::montaParambox(aPergs, "Ajusta Valor Base SAGE/SinteseNET")

    If Len(aRet) == 0
        Return .F.
    EndIf

    ProcRegua(Len(::aParam))

    If Len(::aParam) > 0

        aAdd(aCabec, {"Vlr. Anterior","VALANT","@E 999,999.99", TamSX3("Z5_VALOR")[1],TamSX3("Z5_VALOR")[2],"N",.F.})
        aAdd(aCabec, {"Vlr. Novo"    ,"VALNEW","@E 999,999.99", TamSX3("Z5_VALOR")[1],TamSX3("Z5_VALOR")[2],"N",.F.})
        aAdd(aCabec, {"Mensagem"     ,"MENSAG","@!", 150, 0, "C", .F.})
        aAdd(aCabec, {"SC5"          ,"SC5OK","@BMP",  3, 0, "C", .F.})
        aAdd(aCabec, {"SC6"          ,"SC6OK","@BMP",  3, 0, "C", .F.})
        aAdd(aCabec, {"SZ5"          ,"SZ5OK","@BMP",  3, 0, "C", .F.})

        For Ni := 1 To Len(::aParam)

            nValor := 0
            nValAnt := 0
            lAlterou := .F.
            oChkout := CheckoutRestClient():New(::aParam[Ni], 1)
            cPedSite := oChkout:getPedSiteFromPedGar(::aParam[Ni])

            IncProc("Pedido: " + ::aParam[Ni])
            ProcessMessage()

            If !Empty(cPedSite)

                dbSelectArea("SC5")
                SC5->(dbOrderNickname("PEDSITE"))
                If SC5->(dbSeek(xFilial("SC5") + cPedSite))

                    dbSelectArea("SC6")
                    SC6->(dbSetOrder(1))
                    If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))

                        While SC6->(!EoF()) .And. SC6->C6_NUM == SC5->C5_NUM

                            If (AllTrim(SC6->C6_PROGAR) == "SRFA1PJEMISSORSAGEHV5" .Or. AllTrim(SC6->C6_PROGAR) == "OABA3PFISCIOB1AHV5")
                                If Empty(SC6->C6_PEDGAR) 
                                   RecLock("SC6",.F.)
                                    SC6->C6_PEDGAR := AllTrim(::aParam[Ni])
                                    SC6->(MsUnlock())
                                Elseif AllTrim(SC6->C6_PRODUTO) == "CC010060"
                                    RecLock("SC6",.F.)
                                    SC6->C6_PEDGAR := ""
                                    SC6->(MsUnlock())
                                EndIf
                            EndIf
                            
                            If (AllTrim(SC6->C6_PRODUTO) == "CC010004" .Or. AllTrim(SC6->C6_PRODUTO) == "CC010351") .And.;
                                 (AllTrim(SC6->C6_PROGAR) == "SRFA1PJEMISSORSAGEHV5" .Or. AllTrim(SC6->C6_PROGAR) == "OABA3PFISCIOB1AHV5") .And.;
                                 AllTrim(SC6->C6_PEDGAR) == ::aParam[Ni]

                                    nValor += SC6->C6_VALOR
                            EndIf
                            SC6->(dbSkip())
                        EndDo

                        dbSelectArea("SZ5")
                        SZ5->(dbSetOrder(1))
                        If SZ5->(dbSeek(xFilial("SC6") + ::aParam[Ni]))

                            nValAnt := SZ5->Z5_VALOR

                            RecLock("SZ5",.F.)
                                SZ5->Z5_VALOR   := nValor
                                SZ5->Z5_VALORSW := nValor
                                SZ5->Z5_VALORHW := 0
                                SZ5->Z5_PROCRET := "M"
                            SZ5->(MsUnlock())

                            lAlterou := .T.

                        EndIf
                        
                        aAdd(aDados, {oVerde, SZ5->Z5_PEDGAR, SC5->C5_XNPSITE, SC5->C5_XNPECOM, SC5->C5_NUM, nValAnt, SZ5->Z5_VALOR, Iif(nValAnt != SZ5->Z5_VALOR, "Valor alterado.", "Pedido processado sem alteraééo."), IIf(SC5->(Found()),oVerde,oVermelho), Iif(SC6->(Found()),oVerde,oVermelho), Iif(SZ5->(Found()),oVerde,oVermelho),.F.})
                        aAdd(aPedidos, {SZ5->(Recno())})

                    EndIf

                EndIf

            EndIf

            FreeObj(oChkout)
            oChkout := Nil

            If !lAlterou
                aAdd(aDados, {oVermelho, SZ5->Z5_PEDGAR, SC5->C5_XNPSITE, SC5->C5_XNPECOM, SC5->C5_NUM, nValAnt, SZ5->Z5_VALOR, "Falha no Processamento do Pedido.", IIf(SC5->(Found()),oVerde,oVermelho), Iif(SC6->(Found()),oVerde,oVermelho), Iif(SZ5->(Found()),oVerde,oVermelho),.F.})
            EndIf

        Next

        If Len(aPedidos) > 0
            FwMsgRun(, {|| ::recalcular(aPedidos) }, "Cálculo dos Pedidos", "Aguarde enquanto o Sistema calcula os pedidos")
            FwMsgRun(, {|| ::criaTelaGrid(aCabec, aDados)}, "Montando tela de log", "Montando tela de log")
        EndIf

    EndIf

Return

/*/{Protheus.doc} zerarValores
// Método responsável por zerar os valores dos pedidos indicados no Parambox.
@author yuri.volpe
@since 13/11/2020
@version 1.0
@param null
@type method
/*/
Method zerarValores() Class TroubleshootRemuneracao

    Local aTpVlr    := {"1-Valor de Faturamento", "2-Valor de comissão", "3-Todos"}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.},{2,"Zerar Valores","3-Todos",aTpVlr,50,"",.F.}}
    Local aRet      := {}
    Local cTpVlr    := ""
    Local Ni        := 0

    aRet := ::montaParambox(aPergs, "Zerar Valores")

    If Len(aRet) == 0
        Return .F.
    EndIf

    cTpVlr := Substr(aRet[2],1,1)

    dbSelectArea("SZ6")
    SZ6->(dbSetOrder(1))

    For Ni := 1 To Len(::aParam)

        If SZ6->(dbSeek(xFilial("SZ6") + ::aParam[Ni]))

            While SZ6->(!EoF()) .And. AllTrim(SZ6->Z6_PEDGAR) == AllTrim(::aParam[Ni])

                RecLock("SZ6", .F.)
                    If cTpVlr == "1" .Or. cTpVlr == "3"
                        SZ6->Z6_VLRPROD := 0
                        SZ6->Z6_BASECOM := 0
                    EndIf

                    If cTpVlr == "2" .Or. cTpVlr == "3"
                        SZ6->Z6_VALCOM := 0
                    EndIf
                SZ6->(MsUnlock())

                SZ6->(dbSkip())
            EndDo

        EndIf
    
    Next

Return

/*/{Protheus.doc} alteraStatus
// Método responsável por o status dos pedidos indicados no Parambox.
@author yuri.volpe
@since 13/11/2020
@version 1.0
@param null
@type method
/*/
Method alteraStatus() Class TroubleshootRemuneracao

    Local aStatus    := {"1-não Pago", "2-Voucher Origem não Remunerado", "3-Pago Anteriormente"}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.},{2,"Status","2-Voucher Origem não Remunerado",aStatus,75,"",.F.}}
    Local aRet      := {}
    Local cTpStatus := ""
    Local Ni        := 0
    Local cStatus   := ""

    aRet := ::montaParambox(aPergs, "Altera Status Pedidos")

    If Len(aRet) == 0
        Return .F.
    EndIf

    cTpStatus := Substr(aRet[2],1,1)

    dbSelectArea("SZ6")
    SZ6->(dbSetOrder(1))

    Do Case
        Case cTpStatus == "1"
            cStatus := "PNOPAG"
        Case cTpStatus == "2"
            cStatus := "NAOPAG"
        Case cTpStatus == "3"
            cStatus := "PAGANT"
        Otherwise 
            cStatus := ""
    EndCase

    If Empty(cStatus)
        Return .F.
    EndIf

    For Ni := 1 To Len(::aParam)
        If SZ6->(dbSeek(xFilial("SZ6") + ::aParam[Ni]))

            While SZ6->(!EoF()) .And. AllTrim(SZ6->Z6_PEDGAR) == AllTrim(::aParam[Ni])

                RecLock("SZ6", .F.)
                    SZ6->Z6_TIPO := cStatus
                SZ6->(MsUnlock())

                SZ6->(dbSkip())
            EndDo

        EndIf
    Next


Return

/*/{Protheus.doc} alteraLinkCampanha
// Método responsável por alterar o link de campanha dos pedidos indicados no Parambox.
@author yuri.volpe
@since 13/11/2020
@version 1.0
@param null
@type method
/*/
Method alteraLinkCampanha() Class TroubleshootRemuneracao

    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.},{1,"Link Campanha",Space(150),"@!","","","",70,.T.}}
    Local aRet      := {}
    Local cLink     := ""
    Local Ni        := 0
    Local aPedidos  := {}

    aRet := ::montaParambox(aPergs, "Altera Status Pedidos")

    If Len(aRet) == 0
        Return .F.
    EndIf

    cLink := aRet[2]

    For Ni := 1 To Len(::aParam)
        dbSelectArea("SZ5")
        SZ5->(dbSetOrder(1))
        If SZ5->(dbSeek(xFilial("SZ5") + ::aParam[Ni]))
            
            RecLock("SZ5", .F.)
                SZ5->Z5_DESREDE := AllTrim(cLink)
                SZ5->Z5_PROCRET := "M"
            SZ5->(MsUnlock())

            aAdd(aPedidos,{SZ5->(RECNO())})

        EndIf
    Next

    If Len(aPedidos) > 0
        ::recalcular(aPedidos)
    EndIf

Return

/*/{Protheus.doc} alteraLinkCampanha
// Método responsável por montar o Parambox e guardar o retorno no atributo aParam
@author yuri.volpe
@since 13/11/2020
@version 1.0
@param null
@type method
/*/
Method montaParambox(aParametros, cCabecalho) Class TroubleshootRemuneracao

    Local aRet := {}
    ::resetParam()

    If Parambox(aParametros, cCabecalho, @aRet)
        ::aParam := StrToArray(aRet[1], CHR(13) + CHR(10))
    EndIf

Return aRet

/*/{Protheus.doc} resetParam
// Método responsável por limpar o atributo aParam, que contem o retorno da funééo Parambox
@author yuri.volpe
@since 13/11/2020
@version 1.0
@param null
@type method
/*/
Method resetParam() Class TroubleshootRemuneracao
    ::aParam := {}
Return

/*/{Protheus.doc} reimportar
// Método responsável por Forçar a atualização dos dados do pedido conforme as informações disponéveis no GAR.
@author yuri.volpe
@since 13/11/2020
@version 1.0
@param aPedidos Array Relaééo de némeros de pedidos GAR que seréo reimportados
@type method
/*/
Method reimportar(aPedidos,lDebug,lNoWait) Class TroubleshootRemuneracao

    Local cRotImp   := "U_CRPA027B"
    Local cEmp      := "01"
    Local cFil      := "02"
    Local cForcar   := "2"
    Local nTime     := 1
    DEFAULT lDebug  := .F.
    DEFAULT lNoWait := .F.

    If !lDebug
        FwMsgRun(, {|| StartJob(cRotImp, GetEnvServer(), .F., cEmp, cFil, aPedidos, cForcar),;
                   Iif(!lNoWait,Sleep((nTime * 1000) * Len(aPedidos)),Nil) },;
                   "Atualizando Pedidos",;
                   "Aguarde enquanto o Sistema atualiza os pedidos GAR")     
    Else
        U_CRPA027B('01','02',aPedidos,cForcar)
    EndIf

Return

/*/{Protheus.doc} recalcular
// Método responsável por Forçar o recalculo dos pedidos informados
@author yuri.volpe
@since 13/11/2020
@version 1.0
@param aPedidos Array Relaééo de Recnos da SZ5 que deveréo ser recalculados
@param cPeriodo String Indica se o Cálculo deveré ser realizado para o Período atual (1) ou o Próximo Período (2). Default 1.
@type method
/*/
Method recalcular(aPedidos, cPeriodo, lDebug, lNoWait) Class TroubleshootRemuneracao

    Local cRotCalc  := "U_CRPA020B"
    Local cEmp      := "01"
    Local cFil      := "02"
    Local cRotina   := "TRBLSHOOT"
    Local cPerRem   := GetMv("MV_REMMES")
    Local nThread   := 0
    Local aUsers    := {}
    Local aPedAux   := {}
    Local nContador := 0
    Local nTotThread:= 0
    Local Ni        := 0
    DEFAULT lDebug  := .F.
    DEFAULT lNoWait := .F.

    DEFAULT cPeriodo := "1"

    If cPeriodo == "2"
        cPerRem := getNextPeriodo(cPerRem)
    EndIf

    If !lDebug

        For Ni := 1 To Len(aPedidos)
                        
            //Faz distribuiééo e monitora a quantidade de thread em execução
            BEGIN SEQUENCE 
            
            nThread := 0
            aUsers 	:= Getuserinfoarray()
            aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRPA020B",nThread++,nil )  })
            
            END SEQUENCE
            
            //Limita a quantidade de Threads.
            If nThread <= 10
                
                nContador := 1
                aPedAux   := {}
                
                //Envio para processamento de 10 em 10 pedidos.
                While Ni <= Len(aPedidos) .And. nContador <= 100

                    Aadd(aPedAux,aPedidos[Ni])
                    Ni++
                    nContador++
                    
                EndDo
                
                //Envio o conteúdo para Thread se o array for maior que um
                If Len(aPedAux) > 0
                    nTotThread += 1
                    FwMsgRun(, {|| StartJob(cRotCalc, GetEnvServer(), .F., cEmp, cFil, aPedAux, cRotina, cUserName, cPerRem) }, "Cálculo dos Pedidos", "Aguarde enquanto o Sistema calcula os pedidos")
                    aPedAux := {}
                EndIf
            Else
            
                While nThread > 10
                    
                    FwMsgRun(, {|| sleep(30000) }, "Cálculo dos Pedidos", "Aguardando liberaééo de Threads")
                    BEGIN SEQUENCE      
                    
                    nThread := 0
                    aUsers 	:= Getuserinfoarray()
                    aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRPA020B",nThread++,nil )  })
                            
                    END SEQUENCE
  
                EndDo
                
            EndIf
            
            If nTotThread > 10                           
                DelClassIntf()
                nTotThread := 0
            EndIf
            
            //Ajuste para Next não perder registros
            Ni--

        Next

        //Envio o conteúdo para Thread se o array for maior que zero
        If Len(aPedAux) > 0
            FwMsgRun(, {|| StartJob(cRotCalc, GetEnvServer(), .F., cEmp, cFil, aPedAux, cRotina, cUserName, cPerRem) }, "Cálculo dos Pedidos", "Aguarde enquanto o Sistema calcula os pedidos")
            aPedAux := {}
        EndIf


/*        FwMsgRun(, {|| StartJob(cRotCalc, GetEnvServer(), .F., cEmp, cFil, aPedidos, cRotina, cUserName, cPerRem),;
                   Iif(!lNoWait,Sleep((nTime * 1000) * Len(aPedidos)),NIL) },;
                   "Cálculo dos Pedidos",;
                   "Aguarde enquanto o Sistema calcula os pedidos")*/
    Else
        U_CRPA020B('01', '02', aPedidos, cRotina, cUserName, cPerRem) 
    EndIf
    
Return

Static Function getNextPeriodo(cPerAtu)

	Local cPeriodo 	:= ""
	Local cMesRemu 	:= Substr(cPerAtu,5,2)
	Local nNextRem 	:= 0
	
	nNextRem := Val(cMesRemu) + 1
	
	//Captura o último periodo fechado para calcular a antecipacao 
	//Se Fevereiro, o valor é zero, se Janeiro, -1.
	//Em Janeiro, considera Novembro do ano anterior como ultimo calculo valido
	If nNextRem == 13
		cPeriodo := cValToChar((Val(Substr(cPerAtu,1,4))) + 1) + "01"
	Else
		cPeriodo := Substr(cPerAtu,1,4) + StrZero(nNextRem, 2)
	EndIf

Return cPeriodo

Method criaTelaGrid(aCabec, aDados) Class TroubleshootRemuneracao

    Local oDlgGrid      := Nil
    Local oLista        := Nil
    Local aCabecalho    := {}
    Local aACampos      := {}
    Local aColsEx       := {}
    Local aBotoes       := {}

    TrataCabec(aCabec, @aCabecalho, @aACampos)
    //LoadData(aDados)
    aColsEx := aDados

    DEFINE MSDIALOG oDlgGrid TITLE "LOG DE PROCESSAMENTO" FROM 000, 000  TO 300, 700  PIXEL

        //Monta o browser com inclusão, remoção e atualização
        oLista := MsNewGetDados():New( 053, 078, 415, 775, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgGrid, aCabecalho, aColsEx)
        oLista:SetArray(aColsEx,.T.)

        //Alinho o grid para ocupar todo o meu formulário
        oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

        //Ao abrir a janela o cursor está posicionado no meu objeto
        oLista:oBrowse:SetFocus()

        //Crio o menu que irá aparece no botão Aéées relacionadas
        aadd(aBotoes,{"NG_ICO_LEGENDA", {||Alert("OK-Leg")},"Legenda","Legenda"})
        aadd(aBotoes,{"NG_ICO_LEGENDA", {|| Processa({||GeraCSV(oLista)},"Gerando arquivo.","Gerando arquivo") },"Imprime CSV","Imprime CSV"})

        EnchoiceBar(oDlgGrid, {|| oDlgGrid:End() }, {|| oDlgGrid:End() },,aBotoes)

    ACTIVATE MSDIALOG oDlgGrid CENTERED

Return

Static Function TrataCabec(aCabec, aCabecalho, aACampos)

    Local Ni := 0

    aAdd(aCabecalho,{""                 ,"IMAGEM"   ,"@BMP" ,3                      ,0                       ,".F.","","C","","V","","","","V"})
    aAdd(aCabecalho,{"Pedido GAR"       ,"PEDGAR"   ,"@!"   ,TamSX3("Z6_PEDGAR")[1] ,TamSX3("Z6_PEDGAR")[2]  ,".F.","","C","","R","","",""})
    aAdd(aCabecalho,{"Pedido Site"      ,"PEDSITE"  ,"@!"   ,TamSX3("C5_XNPSITE")[1],TamSX3("C5_XNPSITE")[2] ,".F.","","C","","R","","",""})
    aAdd(aCabecalho,{"Pedido eComm"     ,"PEDECOMM" ,"@!"   ,TamSX3("C6_XNPECOM")[1],TamSX3("C6_XNPECOM")[2] ,".F.","","C","","R","","",""})
    aAdd(aCabecalho,{"Pedido Protheus"  ,"PEDSC5"   ,"@!"   ,TamSX3("C5_NUM")[1]    ,TamSX3("C5_NUM")[2]     ,".F.","","C","","R","","",""})

    //{"Pedido","PEDIDOGAR","@!",TamSX3("Z6_PEDGAR")[1],TamSX3("Z6_PEDGAR")[2],"C",.F.}

    For Ni := 1 To Len(aCabec)

        If aCabec[Ni][Len(aCabec[Ni])] 
            aAdd(aACampos, aCabec[Ni][2])
        EndIf

        Aadd(aCabecalho, {;
                aCabec[Ni][1],;     //X3Titulo()
                aCabec[Ni][2],;     //X3_CAMPO
                aCabec[Ni][3],;	    //X3_PICTURE
                aCabec[Ni][4],;		//X3_TAMANHO
                aCabec[Ni][5],;		//X3_DECIMAL
                "",;		        //X3_VALID
                "",;		        //X3_USADO
                aCabec[Ni][6],;     //X3_TIPO
                "",; 		        //X3_F3
                "R",;		        //X3_CONTEXT
                "",;		        //X3_CBOX
                "",;		        //X3_RELACAO
                ""})		        //X3_WHEN
    Next

Return


Method verificaPedidos(aPedidos, lRecno, lPedGar) Class TroubleshootRemuneracao

    Local aCabec := {}
    Local aDados := {}
    Local Ni := 0
    Local aTpPed    := {"G-Pedido GAR","S-Pedido Site"}
    Local aTpVld    := {"1-Tudo","2-Regras Campanha","3-Cálculo Canal"}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.},{2,"Tipo Pedido","G-Pedido GAR",aTpPed,100,"",.F.},{2,"Tipo Verificaééo","1-Tudo",aTpVld,100,"",.F.}}
    Local aRet      := {}
    Local cTpValid  := ""
    Local oFarol    := oVerde

    DEFAULT aPedidos := {}
    DEFAULT lRecno := .F.
    DEFAULT lPedGar := .T.

    If Len(aPedidos) == 0
        aRet := ::montaParambox(aPergs, "Verifica Pedidos")
        aPedidos := ::aParam
        lPedGar := Substr(aRet[2],1,1) == "G"
        cTpValid := Substr(aRet[3],1,1)
    EndIf

    If cTpValid == "1"
        //{"Pedido","PEDIDOGAR","@!",TamSX3("Z6_PEDGAR")[1],TamSX3("Z6_PEDGAR")[2],"C",.F.}
        aAdd(aCabec,{"Posto"        ,"POSTO"    ,"@BMP",3,0,"C",.F.})
        aAdd(aCabec,{"AC"           ,"POSTO"    ,"@BMP",3,0,"C",.F.})
        aAdd(aCabec,{"Canal"        ,"POSTO"    ,"@BMP",3,0,"C",.F.})
        aAdd(aCabec,{"Campanha"     ,"POSTO"    ,"@BMP",3,0,"C",.F.})
        aAdd(aCabec,{"Federaééo"    ,"POSTO"    ,"@BMP",3,0,"C",.F.})
        aAdd(aCabec,{"Base Posto"   ,"BASPOSTO" ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"Vlr Posto"    ,"VALPOSTO" ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"% Posto"      ,"PERPOSTO" ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"Base AC"      ,"BASAC"    ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"Vlr AC"       ,"VALAC"    ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"% AC"         ,"PERAC"    ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"Base Canal"   ,"BASCANAL" ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"Vlr Canal"    ,"VALCANAL" ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"% Canal"      ,"PERCANAL" ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"Base Camp."   ,"BASCAMP"  ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"Vlr Camp."    ,"VALCAMP"  ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"% Camp."      ,"PERCAMP"  ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"Base Fed. "   ,"BASFED"   ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"Vlr Fed. "    ,"VALFED"   ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"% Fed. "      ,"PERFED"   ,"@E 99,999,999.99",TamSX3("Z6_VALCOM")[1],TamSX3("Z6_VALCOM")[2],"N",.F.})
        aAdd(aCabec,{"Observaééo"   ,"OBSPED"   ,"",250,0,"C",.F.})

        For Ni := 1 To Len(aPedidos)

            If lRecno
                SZ5->(dbGoTo(aPedidos[Ni]))
            Else
                If lPedGar
                    SZ5->(dbSetOrder(1))
                    SZ5->(dbSeek(xFilial("SZ5") + aPedidos[Ni]))
                Else
                    SC5->(dbOrderNickname("PEDSITE"))
                    SC5->(dbSeek(xFilial("SC5") + aPedidos[Ni]))
                EndIf
            EndIf

            If Empty(SZ5->Z5_PEDGAR)
                nOrder := 4
                SC5->(dbSetOrder(1))
                If SC5->(dbSeek(xFilial("SC5") + SZ5->Z5_PEDIDO))
                    SC6->(dbSetOrder(1))
                    SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
                    cPedido := SC5->C5_XNPSITE

                    If SZ5->(!Found())
                        SZ5->(dbSetOrder(3))
                        SZ5->(dbSeek(xFilial("SZ5") + SC5->C5_NUM))
                    EndIf

                EndIf
            ElseIf !Empty(SZ5->Z5_CODVOU) .And. AllTrim(SZ5->Z5_TIPOVOU) != "F"
                cPedido := SZ5->Z5_PEDGAR
            Else
                nOrder := 1
                SC6->(dbOrderNickname("NUMPEDGAR"))
                If SC6->(dbSeek(xFilial("SC6") + SZ5->Z5_PEDGAR))
                    SC5->(dbSetOrder(1))
                    SC5->(dbSeek(xFilial("SC5") + SC6->C6_NUM))
                    cPedido := SZ5->Z5_PEDGAR
                EndIf
            EndIf

            dbSelectArea("SZ6")
            SZ6->(dbSetOrder(nOrder))
            If SZ6->(dbSeek(xFilial("SZ6") + cPedido))

                aAdd(aDados,{oVerde, SZ6->Z6_PEDGAR, SC5->C5_XNPSITE, SC6->C6_XNPECOM, SC5->C5_NUM, oAzul, oAzul, oAzul, oAzul, oAzul, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, "Pedido Calculado.",.F.})

                While SZ6->(!EoF()) .And. SZ6->Z6_PEDGAR == cPedido .And. SZ6->Z6_TIPO != "REEMBO"

                    If AllTrim(SZ6->Z6_TPENTID) == "4"
                        nPosBase := 11
                        nPosRemu := 12
                        nPosPerc := 13
                        nPosStat := 6
                    EndIf

                    If AllTrim(SZ6->Z6_TPENTID) $ "2/5"
                        nPosBase := 14
                        nPosRemu := 15
                        nPosPerc := 16
                        nPosStat := 7
                    EndIf
                    
                    If AllTrim(SZ6->Z6_TPENTID) == "1"
                        nPosBase := 17
                        nPosRemu := 18
                        nPosPerc := 19
                        nPosStat := 8
                    EndIf                                

                    If AllTrim(SZ6->Z6_TPENTID) == "7"
                        nPosBase := 20
                        nPosRemu := 21
                        nPosPerc := 22
                        nPosStat := 9
                    EndIf                

                    If AllTrim(SZ6->Z6_TPENTID) == "8"
                        nPosBase := 23
                        nPosRemu := 24
                        nPosPerc := 25
                        nPosStat := 10
                    EndIf

                    aDados[Len(aDados)][11] := SZ6->Z6_BASECOM
                    aDados[Len(aDados)][12] := SZ6->Z6_VALCOM
                    aDados[Len(aDados)][13] := (SZ6->Z6_VALCOM * 100) / SZ6->Z6_BASECOM

                    If SZ6->Z6_VALCOM > 0 
                        aDados[Len(aDados)][6] := oVerde
                    Else
                        aDados[Len(aDados)][6] := oVermelho
                    EndIf

                    SZ6->(dbSkip())
                EndDo
            Else
                aAdd(aDados,{oVermelho, Iif(nOrder==1,cPedido,""), SC5->C5_XNPSITE, SC6->C6_XNPECOM, SC5->C5_NUM, oAzul, oAzul, oAzul, oAzul, oAzul, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, "Pedido não calculado.",.F.})
            EndIf
        Next
    ElseIf cTpValid == "2"

        //{"Pedido","PEDIDOGAR","@!",TamSX3("Z6_PEDGAR")[1],TamSX3("Z6_PEDGAR")[2],"C",.F.}
        aAdd(aCabec, {"%SW","PERCSW","@E 999.99",TamSX3("Z5_COMSW")[1],TamSX3("Z5_COMSW")[2],"N",.F.})
        aAdd(aCabec, {"%HW","PERCHW","@E 999.99",TamSX3("Z5_COMHW")[1],TamSX3("Z5_COMHW")[2],"N",.F.})
        aAdd(aCabec, {"Cod.Parceiro","CODPAR","@!",TamSX3("Z5_CODPAR")[1],TamSX3("Z5_CODPAR")[2],"C",.F.})
        aAdd(aCabec, {"Desc.Parceiro","DESPAR","@!",TamSX3("Z5_NOMPAR")[1],TamSX3("Z5_NOMPAR")[2],"C",.F.})
        aAdd(aCabec, {"Link Campanha","LINK","@!",TamSX3("Z5_DESREDE")[1],TamSX3("Z5_DESREDE")[2],"C",.F.})
        aAdd(aCabec, {"Base Calculo","BASE","@E 999,999,999.99", TamSX3("Z6_BASECOM")[1], TamSX3("Z6_BASECOM")[2],"N",.F. })
        aAdd(aCabec, {"Valor comissão","VALOR","@E 999,999,999.99", TamSX3("Z6_VALCOM")[1], TamSX3("Z6_VALCOM")[1],"N",.F. })
        aAdd(aCabec, {"% Camp","PERCAMP","@E 999.99",TamSX3("Z5_COMSW")[1],TamSX3("Z5_COMSW")[2],"N",.F.})
        aAdd(aCabec, {"Mensagem","MSG","@!",150,0,"C",.F.})

        cPedidosIn := "("
        For Ni := 1 To Len(aPedidos)
            cPedidosIn += "'" + aPedidos[Ni] + "'" + Iif(Ni < Len(aPedidos), ",", "")
        Next
        cPedidosIn += ")"

        cQuery := "SELECT Z5_PEDGAR, Z5_COMSW, Z5_COMHW, Z5_CODPOS, Z5_CODPAR, Z5_NOMPAR, Z5_DESREDE, Z5_PRODGAR, Z5_PEDGANT, Z5_TIPVOU FROM SZ5010 WHERE Z5_PEDGAR IN " + cPedidosIn + " AND D_E_L_E_T_ = ' ' "

        MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery), "TMPCAMP", .T., .T.)}, "Localizando pedidos", "Localizando pedidos e avaliando regras")

        While TMPCAMP->(!EoF())

            cMensagem := ""

            If TMPCAMP->Z5_COMSW + TMPCAMP->Z5_COMHW == 0
                cMensagem += " não hé percentual de campanha."
            EndIf

            If Empty(TMPCAMP->Z5_CODPAR)
                cMensagem += " Código do parceiro não preenchido."
            EndIf

            If !("CAMPANHA" $ upper(TMPCAMP->Z5_DESREDE))
                cMensagem += " não é link de campanha: " + AllTrim(TMPCAMP->Z5_DESREDE) + "."
            EndIf

            If "SIN" $ TMPCAMP->Z5_PRODGAR .And. !("SIN" $ UPPER(TMPCAMP->Z5_DESREDE))
                cMensagem := " Produto SINCOR fora da rede. "
            EndIf

            cLink := StaticCall(CRPA020, CRR20RD, TMPCAMP->Z5_DESREDE)

            If (!Empty(TMPCAMP->Z5_PEDGANT) .Or. AllTrim(TMPCAMP->Z5_TIPVOU) == "H" .Or. "RENOVA" $ UPPER(TMPCAMP->Z5_DESREDE)) .And.;
                 !(cLink $ "BR/BRC/SIN/NOT/SINRJ/FACES/FENCR")
                cMensagem := " Renovação fora das ACs que remuneram Renovação."
            EndIf

            If  (cLink $ "BV/FACES" .And. ("FACESP"$UPPER(SZ5->Z5_NOMPAR) .Or. "ACSP"$UPPER(SZ5->Z5_NOMPAR) .Or. "MOGIANA"$UPPER(SZ5->Z5_NOMPAR))) .OR. cLink == "FACES"
                cMensagem := " não remunera campanha FACESP."
            EndIf

            If Empty(TMPCAMP->Z5_CODPOS)
                cMensagem := " Pedido sem posto de verificaééo vinculado."
            EndIf

            If !Empty(cMensagem)
                cMensagem += " Campanha não seré calculada."
                oFarol := oVermelho
            Else
                cMensagem := "O pedido deve calcular campanha."
                oFarol := oVerde
            EndIf


            nValorBase  := 0
            nValorCom   := 0
            nPerCamp    := 0

            dbSelectArea("SZ6")
            SZ6->(dbSetOrder(1))
            If SZ6->(dbSeek(xFilial("SZ6") + TMPCAMP->Z5_PEDGAR))
                While SZ6->(!EoF()) .And. SZ6->Z6_PEDGAR == TMPCAMP->Z5_PEDGAR  
                    If AllTrim(SZ6->Z6_TPENTID) == "7"
                        nValorBase  := SZ6->Z6_BASECOM
                        nValorCom   := SZ6->Z6_VALCOM
                        nPerCamp    := (SZ6->Z6_VALCOM * 100) / SZ6->Z6_BASECOM
                        Exit
                    EndIf
                    SZ6->(dbSkip())
                EndDo
            EndIf

            If nValorCom > 0
                cMensagem += " O pedido teve campanha calculada."
            EndIf

            aAdd(aDados,{oFarol, TMPCAMP->Z5_PEDGAR, "", "", "", TMPCAMP->Z5_COMSW, TMPCAMP->Z5_COMHW, TMPCAMP->Z5_CODPAR, TMPCAMP->Z5_NOMPAR, TMPCAMP->Z5_DESREDE, nValorBase, nValorCom, nPerCamp, cMensagem,.F.})

            TMPCAMP->(dbSkip())
        EndDo

        TMPCAMP->(dbCloseArea())

    ElseIf cTpValid == "3"
    EndIf
    
    If Len(aDados) > 0
        ::criaTelaGrid(aCabec, aDados)    
    EndIf

Return

Static Function GeraCSV(oLista)
	local x 		:= 0
	local y 		:= 0
	local cLinha 	:= ''
	local cCaminho 	:= "C:\temp\query_"+dtos(date())+"_"+replace(time(),":","")+".csv"
	Local nHandle  := 0                 //Handle de onde com o arquivo texto
    Local aHeader   := oLista:aHeader
    Local aDados    := oLista:aCols

    ProcRegua(Len(aDados))

	//Verifica se o arquivo texto existe
	If !File( cCaminho )
		//Cria o arquivo texto
		nHandle := MsFCreate( cCaminho )
		If nHandle == -1
			//Caso de erro ao criar arquivo texto
			fClose(nHandle)
		EndIf
	Else
		//Posiciona na ultima linha do arquivo texto
		nHandle := fOpen( cCaminho, FO_WRITE )
		nTot := fSeek(nHandle, nDeslocamento, FS_END)
	EndIf

	for x := 1 to len(aHeader)
		if !empty(cLinha)
			cLinha += ';'
		endif
		cLinha += aHeader[x][1]
	next x
	//Linha do cabecalho
	fWrite( nHandle, cLinha+CRLF )

	for x := 1 to len(aDados)
		cLinha := ''
		for y := 1 to len(aDados[x])
            IncProc()
            ProcessMessage()
			if !empty(cLinha)
				cLinha += ';'
			endif
			cLinha += ConvText(aDados[x][y])
		next y
		//Linha do registro
		fWrite( nHandle, cLinha+CRLF )
	next x

	fClose( nHandle )

    MsgInfo("Arquivo " + cCaminho + " gerado com sucesso.")

Return

Static Function ConvText(oVariavel)
Local cRetorno 	:= ''
Local cAux 		:= ''
If ValType(oVariavel) == "C"
	cRetorno 	:= '"'+spednoacento(oVariavel)+'"'
ElseIf ValType(oVariavel) == "N"
	cRetorno 	:= cValToChar(oVariavel)
ElseIf ValType(oVariavel) == "D"
	cAux 		:= 	DTOS(oVariavel)
	cRetorno 	:= '"'+substr(cAux, 7, 2)+'/'+substr(cAux, 5, 2)+'/'+substr(cAux, 1, 4)+'"'
ElseIf ValType(oVariavel) == "L"
	cRetorno 	:= IF(oVariavel, '"true"' , '"false"')
ElseIf ValType(oVariavel) == "U"
	cRetorno 	:= '""'
EndIf
Return(cRetorno)

Method forcaCalculo() Class TroubleshootRemuneracao

    Local aTpEnt    := {"1-Posto","2-AC","3-Canal","4-Campanha","5-Federaééo"}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.},;
                        {2,"Tipo Entidade","3-Canal",aTpEnt,75,"",.F.},;
                        {1,"Entidade",Space(6),"@!","","","",70,.T.},;
                        {1,"Período",GetMv("MV_REMMES"),"@!","","","",70,.T.}}
    Local aRet      := {}
    Local cEntidade := ""
    Local cTpEnt    := ""
    Local cPeriodo  := ""
    Local cPedidos  := ""
    Local aValores  := {}
    Local Ni        := 0
    Local cQuery    := ""

    aRet := ::montaParambox(aPergs, "Altera Status Pedidos")

    If Len(aRet) == 0
        Return .F.
    EndIf

    cTpEnt := Substr(aRet[2],1,1)
    cEntidade := aRet[3]
    cPeriodo := aRet[4]

    cPedidos := "("
    For Ni := 1 To Len(::aParam)
        cPedidos += "'" + ::aParam[Ni] + "'" + Iif(Ni < Len(::aParam),",","")
    Next
    cPedidos += ")"

    //cPedidos := FormatIn(AllTrim(aRet[1]), CHR(13) + CHR(10))

    Do Case 
        Case cTpEnt == "3"

            cQuery := "SELECT" + CRLF
            cQuery += "    Z6_PEDGAR AS PEDIDO," + CRLF
            cQuery += "    Z4_PORSOFT AS PERCENTUAL_CANAL," + CRLF
            cQuery += "    Z4_IMPSOFT AS IMPOSTO_CANAL," + CRLF
            cQuery += "    ((Z6_BASECOM - Z6_VALCOM - (Z6_BASECOM * (Z4_IMPSOFT / 100))) * ( Z4_PORSOFT / 100)) AS COMISSAO_CANAL," + CRLF
            cQuery += "    Z6_BASECOM * (Z4_IMPSOFT / 100) AS IMPOSTO," + CRLF
            cQuery += "    Z6_VALCOM AS SOMA_REMUNERA," + CRLF
            cQuery += "    Z6_BASECOM AS BASE_REMUNERA," + CRLF
            cQuery += "    Z6_BASECOM - Z6_VALCOM - (Z6_BASECOM * (Z4_IMPSOFT / 100)) AS BASE_CANAL," + CRLF
            cQuery += "    Z6_VALCOM + (Z6_BASECOM * (Z4_IMPSOFT / 100)) AS VAL_ABATIMENTO " + CRLF
            cQuery += "FROM ( " + CRLF
            cQuery += "    SELECT Z6_PEDGAR, Z6_BASECOM, SUM(Z6_VALCOM) Z6_VALCOM, Z4_PORSOFT, Z4_IMPSOFT " + CRLF
            cQuery += "    FROM SZ6010 " + CRLF
            cQuery += "        INNER JOIN SZ4010 ON Z4_FILIAL = Z6_FILIAL AND Z4_CODENT = '" + cEntidade + "' AND Z4_CATPROD = '01' AND SZ4010.D_E_L_E_T_ = ' '" + CRLF
            cQuery += "    WHERE Z6_FILIAL = ' '" + CRLF
            cQuery += "        AND Z6_TPENTID NOT IN ('1','7','10')" + CRLF
            cQuery += "        AND Z6_CATPROD = '2'" + CRLF
            cQuery += "        AND Z6_PERIODO = '" + cPeriodo + "' " + CRLF
            cQuery += "        AND Z6_TIPO != 'REEMBO'" + CRLF
            cQuery += "        AND Z6_PEDGAR IN " + cPedidos + CRLF
            cQuery += "        AND SZ6010.D_E_L_E_T_ = ' ' " + CRLF
            cQuery += "    GROUP BY Z6_PEDGAR, Z6_BASECOM, Z4_PORSOFT,Z4_IMPSOFT " + CRLF
            cQuery += ") " + CRLF

            MemoWrite("C:\Data\ts_forcacalculo.sql",cQuery)
            
            dbUseArea(.T., "TOPCONN", tcGenQry(,,cQuery), "TMPCALC", .T., .T.)

            While TMPCALC->(!EoF())
                
                dbSelectArea("SZ6")
                SZ6->(dbSetOrder(1))
                If SZ6->(dbSeek(xFilial("SZ6") + TMPCALC->PEDIDO))

                    For Ni := 1 To SZ6->(FCount())
                        aAdd(aValores, {SZ6->(FieldName(Ni)), SZ6->(FieldGet(Ni))})
                    Next

                    aValores[aScan(aValores, {|x| x[1] == "Z6_CODENT"})][2]     := cEntidade
                    aValores[aScan(aValores, {|x| x[1] == "Z6_DESENT"})][2]     := AllTrim(GetAdvFVal("SZ3","Z3_DESENT",xFilial("SZ3") + cEntidade,1,""))
                    aValores[aScan(aValores, {|x| x[1] == "Z6_TPENTID"})][2]    := "1"
                    aValores[aScan(aValores, {|x| x[1] == "Z6_BASECOM"})][2]    := TMPCALC->BASE_CANAL
                    aValores[aScan(aValores, {|x| x[1] == "Z6_VALCOM"})][2]     := TMPCALC->COMISSAO_CANAL
                    aValores[aScan(aValores, {|x| x[1] == "Z6_VLRABT"})][2]     := TMPCALC->VAL_ABATIMENTO
                    aValores[aScan(aValores, {|x| x[1] == "Z6_CODAC"})][2]      := cEntidade
                    aValores[aScan(aValores, {|x| x[1] == "Z6_REGCOM"})][2]     := DTOC(dDataBase) + "-" + Time() + "-TROUBLESHOOTING-" + cUserName + "->>> (" + cEntidade + ") >>> (PERCENTUAL SOBRE SOFTWARE - CANAL)" 

                    While SZ6->(!EoF()) .And. AllTrim(SZ6->Z6_PEDGAR) == AllTrim(TMPCALC->PEDIDO)
                        If AllTrim(SZ6->Z6_TPENTID) == "1" .And. AllTrim(SZ6->Z6_CODENT) == cEntidade
                            RecLock("SZ6", .F.)
                                SZ6->(dbDelete())
                            SZ6->(MsUnlock())
                        EndIf
                        SZ6->(dbSkip())
                    EndDo

                    RecLock("SZ6",.T.)
                        For Ni := 1 To Len(aValores)
                            SZ6->(FieldPut(Ni, aValores[Ni][2]))
                        Next
                    SZ6->(MsUnlock())

                EndIf

                TMPCALC->(dbSkip())
            EndDo

            TMPCALC->(dbCloseArea())

        Otherwise
            Alert("não implementado.")
    EndCase

Return

Method importaPlanilhas() Class TroubleshootRemuneracao

    Local aPergs    := {{6,"Arquivo Verificaééo",Space(100),"","","",75,.F.,"Arquivo CSV Verificaééo |rel_verificacoes_sav_*.CSV"},;
                        {6,"Arquivo Renovação",Space(100),"","","",75,.F.,"Arquivo CSV Renovação |rel_pgto_cert_rrn_emi_*.CSV"},;
                        {6,"Arquivo Revendedores",Space(100),"","","",75,.F.,"Arquivo CSV Revendedor |rel_revendedor_*.CSV"}}
    Local aRet      := {}
    Local Nx        := 0

    aRet := ::montaParambox(aPergs, "Importa Planilhas")

    If Len(aRet) == 0
        Return .F.
    EndIf

    For Nx := 1 To Len(aRet)

        If !Empty(aRet[1])
            Processa( {|| ::trataVerificacao(aRet[1])}, "importação Arquivos BI", "Importando Arquivo de Verificaééo",.F.)
        EndIf

        If !Empty(aRet[2])
            Processa( {|| ::trataRenovacao(aRet[2])}, "importação Arquivos BI", "Importando Arquivo de Renovação",.F.)
        EndIf

        If !Empty(aRet[3])
            Processa( {|| ::trataRevenda(aRet[3])}, "importação Arquivos BI", "Importando Arquivo de Revenda",.F.)
        EndIf

    Next


Return

Method trataVerificacao(cArquivo) Class TroubleshootRemuneracao

    Local aPergs    := {6,"Arquivo Renovação",Space(100),"","","",75,.T.,"Arquivo CSV Renovação |rel_pgto_cert_rrn_emi_*.CSV"}
    Local aRet      := {}
    Local nHdl      := 0
    Local cLine     := ""
    Local nLine     := 0
    Local aLine     := {}
    Local nNumRec   := 0
    Local cPedGAR   := ""
    Local aPedidos  := {}
    Local aRecnos   := {}

    DEFAULT cArquivo := ""

    If Empty(cArquivo)
        aRet := ::montaParambox(aPergs, "Trata Verificaééo")

        If Len(aRet) > 0
            Return .F.
        EndIf
    Else
        aAdd(aRet, cArquivo)
    EndIf


    If File(aRet[1])
        nHdl := FT_FUse(aRet[1])

        If nHdl > -1

            FT_FGoTop()
            nNumRec := FT_FLastRec()
            ProcRegua(nNumRec)

            While !FT_FEOF()
                cLine := FT_FReadLn()
                nLine++
                IncProc()
                ProcessMessage()

                cPedGAR   := ""

                If Substr(cLine,1,18) != "CD_POSTO_VALIDACAO" .And. nLine == 1
                    nLine := 0
                    FT_FSKIP()
                    Loop
                EndIf

                If nLine == 1
                    aHeader := StrTokArr2(cLine, ";", .T.)
                    FT_FSKIP()
                Else

                    aLine := StrTokArr2(cLine, ";", .T.)

                    cPedGAR   := aLine[aScan(aHeader, {|x| AllTrim(x) == "CD_PEDIDO"})]

                    dbSelectArea("SZ5")
                    SZ5->(dbSetOrder(1))
                    If SZ5->(dbSeek(xFilial("SZ5") + cPedGAR))

                        aAdd(aPedidos,{SZ5->Z5_PEDGAR,0,""})
                        aAdd(aRecnos, {SZ5->(Recno())})

                    EndIf

                    FT_FSKIP()

                EndIf

            EndDo

            If Len(aRecnos) > 0
                ::reimportar(aPedidos)
                ::recalcular(aRecnos, "2")
            EndIf

            FT_FUSE()

        EndIf

    EndIf
Return

Method trataRenovacao(cArquivo) Class TroubleshootRemuneracao

    Local aPergs    := {6,"Arquivo Renovação",Space(100),"","","",75,.T.,"Arquivo CSV Renovação |rel_pgto_cert_rrn_emi_*.CSV"}
    Local aRet      := {}
    Local nHdl      := 0
    Local cLine     := ""
    Local nLine     := 0
    Local aLine     := {}
    Local nNumRec   := 0
    Local cCodPosto := ""
    Local cDesPosto := ""
    Local cPedGAR   := ""
    Local aRecnos   := {}
    Local aCabec    := {}
    Local aDados    := {}
    Local cMsgLog   := ""

    aAdd(aCabec, {"Linha","ARQLIN","",6,0,"N",.F.})
    aAdd(aCabec, {"Recno","RECSZ5","",9,0,"N",.F.})
    aAdd(aCabec, {"Mensagem","MSGLOG","",250,0,"C",.F.})

    DEFAULT cArquivo := ""

    If Empty(cArquivo)
        aRet := ::montaParambox(aPergs, "Trata Renovação")

        If Len(aRet) > 0
            Return .F.
        EndIf
    Else
        aAdd(aRet, cArquivo)
    EndIf


    If File(aRet[1])
        nHdl := FT_FUse(aRet[1])

        If nHdl > -1

            FT_FGoTop()
            nNumRec := FT_FLastRec()
            ProcRegua(nNumRec)

            While !FT_FEOF()
                cLine := FT_FReadLn()
                nLine++
                IncProc()
                ProcessMessage()
                
                cCodPosto := ""
                cDesPosto := ""
                cPedGAR   := ""
                cMsgLog   := ""

                If nLine == 1
                    aHeader := StrTokArr2(cLine, ";", .T.)
                    FT_FSKIP()
                    Loop
                Else

                    aLine := StrTokArr2(cLine, ";", .T.)

                    cCodPosto := aLine[aScan(aHeader, {|x| AllTrim(x) == "Posto"})]
                    cDesPosto := aLine[aScan(aHeader, {|x| AllTrim(x) == "Descricao do Posto"})]
                    cPedGAR   := aLine[aScan(aHeader, {|x| AllTrim(x) == "Pedido"})]

                    If Len(aLine) != Len(aHeader)
                        aAdd(aDados, {oVermelho, cPedGAR, "", "", "", nLine, 0, "Registro defeituoso.",.F.})
                        FT_FSKIP()
                        Loop
                    EndIf

                    dbSelectArea("SZ5")
                    SZ5->(dbSetOrder(1))
                    If SZ5->(dbSeek(xFilial("SZ5") + cPedGAR))

                        //::reimportar({SZ5->Z5_PEDGAR,0,""})
                        cMsgLog += "Pedido Reimportado | "
                        aAdd(aRecnos, {SZ5->(Recno())})
                        //sleep(5000)

                        If AllTrim(SZ5->Z5_CODPOS) != AllTrim(cCodPosto) 
                            /*RecLock("SZ5",.F.)
                                SZ5->Z5_CODPOS := cCodPosto
                                SZ5->Z5_DESPOS := cDesPosto
                            SZ5->(MsUnlock())*/
                            cMsgLog += "Código de Posto atualizado de [" + AllTrim(SZ5->Z5_CODPOS) + "[ para [" + AllTrim(cCodPosto) + "] | "
                        EndIf

                        aAdd(aDados, {oVerde, cPedGAR, "", "", "", nLine, SZ5->(Recno()), cMsgLog + "Registro Processado com sucesso.",.F.})
                    EndIf

                    FT_FSKIP()

                EndIf

            EndDo

            If Len(aRecnos) > 0
                //::recalcular(aRecnos, getNextPeriodo(GetMv("MV_REMMES")))
            EndIf

            FT_FUSE()

        EndIf

    EndIf

    If Len(aDados) > 0
        ::criaTelaGrid(aCabec, aDados)
    EndIf

Return


Method trataRevenda(cArquivo) Class TroubleshootRemuneracao

    Local aPergs    := {6,"Arquivo Revendas",Space(100),"","","",75,.T.,"Arquivo CSV Renovação |rel_revendedor_*.CSV"}
    Local aRet      := {}
    Local nHdl      := 0
    Local cLine     := ""
    Local nLine     := 0
    Local aLine     := {}
    Local nNumRec   := 0
    Local cPedGAR   := ""
    Local aPedidos  := {}
    Local aRecnos   := {}

    DEFAULT cArquivo := ""

    If Empty(cArquivo)
        aRet := ::montaParambox(aPergs, "Trata Revendedores")

        If Len(aRet) > 0
            Return .F.
        EndIf
    Else
        aAdd(aRet, cArquivo)
    EndIf


    If File(aRet[1])
        nHdl := FT_FUse(aRet[1])

        If nHdl > -1

            FT_FGoTop()
            nNumRec := FT_FLastRec()
            ProcRegua(nNumRec)

            While !FT_FEOF()
                cLine := FT_FReadLn()
                nLine++
                IncProc()
                ProcessMessage()
                
                cPedGAR   := ""

                If Substr(cLine,1,18) != "CD_PEDIDO" .And. nLine == 1
                    nLine := 0
                    FT_FSKIP()
                    Loop
                EndIf

                If nLine == 1
                    aHeader := StrTokArr2(cLine, ";", .T.)
                    FT_FSKIP()
                    Loop
                Else

                    aLine := StrTokArr2(cLine, ";", .T.)

                    cPedGAR   := aLine[aScan(aHeader, {|x| AllTrim(x) == "CD_PEDIDO"})]

                    dbSelectArea("SZ5")
                    SZ5->(dbSetOrder(1))
                    If SZ5->(dbSeek(xFilial("SZ5") + cPedGAR))

                        aAdd(aPedidos,{SZ5->Z5_PEDGAR,0,""})
                        aAdd(aRecnos, {SZ5->(Recno())})

                    EndIf

                    FT_FSKIP()

                EndIf

            EndDo

            If Len(aRecnos) > 0
                ::reimportar(aPedidos)
                ::recalcular(aRecnos, getNextPeriodo(GetMv("MV_REMMES")))
            EndIf

            FT_FUSE()

        EndIf

    EndIf
Return

Method testeTela() Class TroubleshootRemuneracao

    Local aDados := {}
    Local aCabec := {}

    aAdd(aCabec, {"Mensagem","MSGLOG","",250,0,"C",.F.})

    aAdd(aDados, {oAzul, "", "11321221", "CERTI00248488", "9HESRW", "Posto vinculado: 44536 . Item PV: 01. Registro incluédo. Recno: 11313511 | ",.F.})
    aAdd(aDados, {oAzul, "", "11321221", "CERTI00248488", "9HESRW", "Posto vinculado: 44536 . Item PV: 01. Registro incluédo. Recno: 11313511 | ",.F.})
    aAdd(aDados, {oAzul, "", "11321221", "CERTI00248488", "9HESRW", "Posto vinculado: 44536 . Item PV: 01. Registro incluédo. Recno: 11313511 | ",.F.})

    ::criaTelaGrid(aCabec, aDados)

Return

Method geraAdiantamento() Class TroubleshootRemuneracao

    Local aPar := {}

    aAdd( aPar,{ 1  ,"Periodo " 	 	,Space(6),"","","","",50,.F.})
    aAdd( aPar,{ 1  ,"Entidade De"	 	,Space(6),"","","","",50,.F.})
    aAdd( aPar,{ 1  ,"Entidade Ate"		,Space(6),"","","","",50,.F.})
    aAdd( aPar,{ 2  ,"Tipo Ent." 	 	,"TODAS" ,{"TODAS","POSTO","AC/CANAL","REVENDEDOR"}, 100,'.T.',.T.})

    aRet := ::montaParambox(aPar, "Gera Adiantamento de Remuneração")

    If Len(aRet) == 0
        Return .F.
    EndIf

    STATICCALL( CRPA067, CRPA67C, aRet, .T. )
    U_CRPA071()

Return

Method trataKitCombo() Class TroubleshootRemuneracao

    Local aPergs        := {}
    Local aRet          := {}
    Local aRecnos       := {}
    Local aPedidos      := {}
    Local lSAGE         := .F.
    Local lCombo        := .F.
    Local lKitCombo     := .F. 
    Local lisHardware   := .F.
	Local cC5_XNPSITE 	:= ""
	Local cC6_PEDGAR	:= ""
	Local cPedGarAnt	:= ""
	Local oChkOut		:= Nil
	Local Ni			:= 0

    aAdd(aPergs, {11, "Pedidos", "", '.T.', '.T.', .T.})
    aAdd(aPergs, {5,  "Combo SAGE?",.F.,50,"",.F.})

    aRet := ::montaParambox(aPergs, "Gera Adiantamento de Remuneração")

    If Len(aRet) == 0
        Alert("Processo interrompido.")
        Return
    EndIf

    lSAGE := aRet[2]

    If Len(aRet) > 0
        
        aPedidos := ::aParam

        For Ni := 1 To Len(aPedidos)

            oChkOut := CheckoutRestClient():New(aPedidos[Ni])
                 
            cC5_XNPSITE := oChkOut:getPedSiteFromPedGar()
                
            If !Empty(cC5_XNPSITE)
                //Tenta localizar na SC5 o Pedido do Checkout
                dbSelectArea("SC5")
                SC5->(dbOrderNickName("PEDSITE"))
                If SC5->(dbSeek(xFilial("SC5") + cC5_XNPSITE))
                    
                    dbSelectArea("SC6")
                    SC6->(dbSetOrder(1))
                    If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))                       

                        While SC6->(!EoF()) .And. SC6->C6_NUM == SC5->C5_NUM 

                            lCombo      := Substr(SC6->C6_XSKU,1,2) == "CB"
                            lKitCombo   := Substr(SC6->C6_XSKU,1,2) == "KT"
                            cC6_PEDGAR  := aPedidos[Ni]
                            cPedGarAnt  := SC6->C6_PEDGAR
                            lIsHardware := Substr(SC6->C6_PRODUTO,1,2) == "MR"

                            If (lCombo .Or. lSage) .And. !lIsHardware
                                cC6_PEDGAR := oChkOut:getActualPedGAR(SC6->C6_XIDPED)
                            EndIf

                            If (lCombo .Or. lKitCombo .Or. lSage) .And. (Empty(SC6->C6_PEDGAR) .Or. AllTrim(SC6->C6_PEDGAR) != AllTrim(cC6_PEDGAR)) .And. !lIsHardware
                            
                                RecLock("SC6",.F.)
                                    SC6->C6_PEDGAR := cC6_PEDGAR
                                SC6->(MsUnlock())

                                //Considera apenas os que foram alterados, pois os pedidos que estavam corretos
                                //ja haviam sido pagos.
                                aAdd(aPedidos,{SC6->C6_PEDGAR,0,""})
                                aAdd(aRecnos, {::getRecnoPGAR(cC6_PEDGAR)})    

                                // cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";" + SC6->C6_NUM + ";Alterar Pedgar:" + SC6->C6_PEDGAR
                            EndIf                            
                        
                            SC6->(dbSkip())
                        EndDo

                    Else
                        //cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";;não encontrado na SC6"
                    EndIf
                Else
                    //cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";;não encontrado na SC5"
                    
                    /*dbSelectArea("SZ5")
                    SZ5->(dbSetOrder(1))
                    If SZ5->(dbSeek(xFilial("SZ5") + aPedidos[Ni])) .And. !Empty(SZ5->Z5_CODVOU)
                        cCodVou := SZ5->Z5_CODVOU
                        cTipVou := SZ5->Z5_TIPVOU
                    Else
                        cCodVou := oChkOut:getVoucher()
                        cTipVou := oChkOut:getTipoVoucher()
                    EndIf
                    
                    cMsgLog := ""

                    cMsgVoucher := cCodVou + ";"
                    
                    If !Empty(cCodVou)		
                        If Select("TMPSZG") > 0
                            TMPSZG->(dbCloseArea())
                        EndIf
                        
                        cQuerySZG := "SELECT R_E_C_N_O_ FROM SZG010 WHERE ZG_NUMVOUC = '" + cCodVou + "' AND D_E_L_E_T_ = ' '"
                        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySZG),"TMPSZG",.T.,.T.)
                        
                        If TMPSZG->(!EOF())
                        
                            dbSelectArea("SZG")
                            SZG->(dbGoTo(TMPSZG->R_E_C_N_O_))
                        
                            If Empty(SZG->ZG_NUMPED)
                                cMsgVoucher += "Voucher não vinculado na SZG"
                            Else
                                dbSelectArea("SZF")
                                SZF->(dbSetOrder(2))
                                If SZF->(dbSeek(xFilial("SZF") + cCodVou))
                                    
                                    If SZF->ZF_TIPOVOU $ "A/B/2/H"
                                        cMsgVoucher += "Voucher com pedido anterior"
                                        
                                        dbSelectArea("SZ5")
                                        SZ5->(dbSetOrder(1))
                                        If !Empty(SZF->ZF_PEDIDO) .And. SZ5->(dbSeek(xFilial("SZ5") + SZF->ZF_PEDIDO))
                                            If !Empty(SZ5->Z5_CODVOU)
                                                cMsgVoucher += ";Ped Ori " + SZ5->Z5_PEDGAR + " Voucher sobre voucher"
                                            Else
                                                cMsgVoucher += ";Ped Ori " + SZF->ZF_PEDIDO + " Valores: " + cValToChar(SZ5->Z5_VALORSW) + ";" + cValToChar(SZ5->Z5_VALORHW)
                                            EndIf
                                        Else
                                            cMsgVoucher += ";Pedido Origem " + SZF->ZF_PEDIDO + " não encontrado ou em branco."
                                        EndIf

                                    Else
                                        cMsgVoucher += "Voucher cujo valor deve vir da SZF"
                                    EndIf
                                    
                                EndIf
                            EndIf
        
                        EndIf
                            
                    EndIf
                    */
                    
                    
                EndIf
                
                /*dbSelectArea("SZ5")
                SZ5->(dbSetOrder(1))
                If SZ5->(dbSeek(xFilial("SZ5") + aPedidos[Ni]))
                    //cMsg += " | Valor: " + cValToChar(SZ5->Z5_VALOR)
                    cMsgLog += ";" + cValToChar(SZ5->Z5_VALOR) + ";"
                
                    dbSelectArea("SZ6")
                    SZ6->(dbSetOrder(1))
                    If SZ6->(dbSeek(xFilial("SZ6") + SZ5->Z5_PEDGAR))
                        While SZ6->(!EoF()) .And. SZ6->Z6_PEDGAR == SZ5->Z5_PEDGAR
                            If AllTrim(SZ6->Z6_TPENTID) == "4"
                                //cMsg += " | Remunerado Posto: " + cValToChar(SZ6->Z6_VALCOM)
                                cMsgLog += cValToChar(SZ6->Z6_VALCOM) + ";"
                                Exit
                            EndIf
                            SZ6->(dbSkip())
                        EndDo
                    EndIf
                            
                EndIf*/
            
            EndIf	
                    
            cC5_XNPSITE := ""
            cC6_PEDGAR  := ""
            cCodVou		:= ""
            cPedGarAnt  := ""
            lCombo      := .F.
            lKitCombo   := .F.

            oChkOut   	:= Nil
            FreeObj(oChkOut)
            
        Next
    EndIf

    If Len(aRecnos) > 0
        ::reimportar(aPedidos)
        ::recalcular(aRecnos)
    EndIf

Return

Method getRecnoPGAR(cPedGAR, lLoop) Class TroubleshootRemuneracao

    Local nRecno := 0
    
    DEFAULT lLoop := .F.

    dbSelectArea("SZ5")
    SZ5->(dbSetOrder(1))
    If SZ5->(dbSeek(xFilial("SZ5") + cPedGAR))
        nRecno := SZ5->(Recno())
    Else
        ::reimportar({cPedGAR,0,""})

        //Chama recursivamente para otimizar Código
        //Passa flag de loop para evitar loop eterno
        //Se falhar no loop, retorna Recno 0
        If !lLoop
            nRecno := ::getRecnoPGAR(cPedGAR, .T.) 
        EndIf
    EndIf

Return nRecno

Method getRecnoPSite(cPedSite) Class TroubleshootRemuneracao

    Local nRecno := 0

    dbSelectArea("SC5")
    SC5->(dbOrderNickname("PEDSITE"))
    If SC5->(dbSeek(xFilial("SC5") + cPedSite))

        //Localiza o pedido na tabela SZ5
        dbSelectArea("SZ5")
        SZ5->(dbSetOrder(3)) //Z5_FILIAL + Z5_PEDIDO
        If SZ5->(dbSeek(xFilial("SZ5") + SC5->C5_NUM))
            
            nRecno := SZ5->(Recno())

        EndIf

    EndIf

Return nRecno

Method trataPostoGar() Class TroubleshootRemuneracao

    Local aPergs    := {}
    Local aRet      := {}
    Local aLinha    := {}
    Local cPedido   := ""
    Local cPosto    := ""
    Local cDesPosto := ""
    Local aRecnos   := {}
    Local Ni        := 0

    aAdd(aPergs, {11, "Pedidos", "", '.T.', '.T.', .T.})

    aRet := ::montaParambox(aPergs, "Ajusta Posto GAR para Renovação")

    If Len(aRet) == 0
        Alert("Processo interrompido.")
        Return
    EndIf

    ProcRegua(Len(::aParam))

    For Ni := 1 To Len(::aParam)

        aLinha := StrTokArr2(::aParam[Ni],";",.T.)

        cPedido     := FwCutOff( alltrim( aLinha[1] ), SEM_ACENTO )
        cPosto      := FwCutOff( alltrim( aLinha[2] ), SEM_ACENTO )
        cDesPosto   := FwCutOff( alltrim( aLinha[3] ), SEM_ACENTO )

        IncProc("Ajustando pedido " + cPedido)
        ProcessMessage()

        dbSelectArea("SZ5")
        SZ5->(dbSetOrder(1))
        If SZ5->(dbSeek(xFilial("SZ5") + cPedido))
            RecLock("SZ5" ,.F.)
                SZ5->Z5_CODPOS := cPosto
                SZ5->Z5_DESPOS := cDesPosto
            SZ5->(MsUnlock())

            aAdd(aRecnos, {SZ5->(Recno())})
        EndIf

    Next

    If Len(aRecnos) > 0
        FwMsgRun(, {|| ::recalcular(aRecnos) }, "Cálculo dos Pedidos", "Aguarde enquanto o Sistema calcula os pedidos")
    EndIf

Return

Method reprocCampos() Class TroubleshootRemuneracao

    Local aTpPed    := {"1-Pedido GAR","2-Pedido Site"}
    Local aFields   := {}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.},;
                        {2,"Campo","",aFields,75,"",.F.},;
                        {2,"Tipo Pedido","1-Pedido GAR",aTpPed,75,"",.F.}}
    Local Ni        := 1
    Local i         := 0
    Local aDadosAux := {}
    Local aRecnos   := {}
    Local aCabec    := {}
    Local aDados    := {}
    Local cCodAnt   := ""
    Local cDescAnt  := ""
    Local cCampo    := ""
    Local nCount    := 1

    dbSelectArea("SX3")
    SX3->(dbSetOrder(1))
    If SX3->(dbSeek("SZ5"))
        While SX3->(!EoF()) .And. AllTrim(SX3->X3_ARQUIVO) == "SZ5"
            aAdd(aFields, cValToChar(nCount) + "-" + SX3->X3_CAMPO)
            SX3->(dbSkip())
        EndDo
    EndIf

    // Cria Parambox para parametrização
    aRet := ::montaParambox(aPergs, "Reprocessamento de Pedidos")

    // Se Parambox foi cancelada, sai da rotina
    If Len(aRet) == 0
        Return .F.
    EndIf

    cCampo := AllTrim(Substr(aRet[2], at("-", aRet[2]) + 1))

    ProcRegua(Len(::aParam))

    aAdd(aCabec, {"Cod.Ant."     , "CODANT", "", TamSX3("Z5_CODPAR")[1], 0, "C", .T.})
    aAdd(aCabec, {"Desc.Anterior", "DESANT", "", TamSX3("Z5_NOMPAR")[1], 0, "C", .T.})
    aAdd(aCabec, {"Cod Novo"     , "CODATU", "", TamSX3("Z5_CODPAR")[1], 0, "C", .T.})
    aAdd(aCabec, {"Desc Nova"    , "DESATU", "", TamSX3("Z5_NOMPAR")[1], 0, "C", .T.})

    For Ni := 1 To Len(::aParam)

        IncProc("Processando registro: " + cValToChar(Ni) + " / Pedido: " + ::aParam[Ni])
        ProcessMessage()

        dbSelectArea("SZ5")
        SZ5->(dbSetOrder(1))
        If SZ5->(dbSeek(xFilial("SZ5") + ::aParam[Ni]))

            oWSObj := WSIntegracaoGARERPImplService():New()
            If oWSObj:findDadosPedido("erp","password123",Val(::aParam[Ni]))

                RecLock("SZ5",.F.)

                    Do Case
                        Case cCampo == "Z5_CODPAR" .Or. cCampo == "Z5_DESPAR"

                            //Codigo do Parceiro
                            If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO) <> "U"
                                cCodAnt := SZ5->Z5_CODPAR
                                SZ5->Z5_CODPAR := Iif(!Empty(AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO))),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO)),"")
                            EndIf
                            
                            //Codigo do Parceiro
                            If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO) <> "U"
                                cDescAnt := SZ5->Z5_NOMPAR
                                SZ5->Z5_NOMPAR := Iif(!Empty(AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO)),AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO),"")
                            EndIf

                        Case cCampo == "Z5_CODVEND" .Or. cCampo == "Z5_NOMVEND"

                       		If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR) <> "U"
                                cCodAnt := SZ5->Z5_CODVEND
			                    SZ5->Z5_CODVEND := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR))
		                    EndIf

                            //Nome do revendedor
                            If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR) <> "U" 
                                cDescAnt := SZ5->Z5_NOMVEND
                                SZ5->Z5_NOMVEND := AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR)
                            EndIf
                    EndCase
                    
                SZ5->(MsUnlock())

                aAdd(aDados, {oVerde, SZ5->Z5_PEDGAR, "", "", "", cCodAnt, cDescAnt, SZ5->Z5_CODPAR, SZ5->Z5_NOMPAR,.F.}) 

                aAdd(aRecnos, {SZ5->(Recno())})

            EndIf

            FreeObj(oWSObj)
            oWSObj := Nil
        EndIf
    Next

    
    For i := 1 To Len(aDados)
        aAdd(aDadosAux, aDados[i])       
        If i % 1000 == 0
            ::criaTelaGrid(aCabec, aDadosAux)
            aDadosAux := {}
        EndIf
    Next i

    ::criaTelaGrid(aCabec, aDadosAux)

    If Len(aRecnos) > 0
        ::recalcular(aRecnos)
        //::verificaCampanha(::aParam)
    EndIf

Return

Method updDadosSZ6() Class TroubleshootRemuneracao

    Local aFields   := {}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.},;
                        {2,"Campo","",aFields,75,"",.F.}}
    Local Ni        := 1
    Local nCount    := 1

    dbSelectArea("SX3")
    SX3->(dbSetOrder(1))
    If SX3->(dbSeek("SZ6"))
        While SX3->(!EoF()) .And. AllTrim(SX3->X3_ARQUIVO) == "SZ6"
            aAdd(aFields, cValToChar(nCount) + "-" + SX3->X3_CAMPO)
            SX3->(dbSkip())
        EndDo
    EndIf

    // Cria Parambox para parametrização
    aRet := ::montaParambox(aPergs, "Reprocessamento de Pedidos")

    // Se Parambox foi cancelada, sai da rotina
    If Len(aRet) == 0
        Return .F.
    EndIf

    For Ni := 1 To Len(::aParam)

        aLinha := StrTokArr2(::aParam[Ni],";",.T.)

        cPedido     := AllTrim(aLinha[1])
        cPosto      := aLinha[2]
        cDesPosto   := aLinha[3]
        cCampo      := AllTrim(Substr(aRet[2], at("-", aRet[2]) + 1))
                //&("SZ6->" + cCampo) := cPosto

        dbSelectArea("SZ6")
        SZ6->(dbSetOrder(1))
        If SZ6->(dbSeek(xFilial("SZ6") + cPedido))
            While SZ6->(!EoF()) .And. AllTrim(SZ6->Z6_PEDGAR) == cPedido
                RecLock("SZ6", .F.)
                    SZ6->Z6_CODVEND := cPosto
                    SZ6->Z6_NOMVEND := cDesPosto
                SZ6->(MsUnlock())
                SZ6->(dbSkip())
            EndDo
        EndIf

    Next

Return

Method relProdutos() Class TroubleshootRemuneracao
Return U_CRPR250()

Static Function NomeDoMes(cMes)

    If ValType(cMes) != "C"
        cMes := StrZero(cMes,2)
    ElseIf ValType(cMes) == "C" .And. Len(cMes) < 2
        cMes := PadL(cMes,2,"0")
    EndIf

    Do Case
        Case cMes == "01"
            Return "Janeiro"
        Case cMes == "02"
            Return "Fevereiro"
        Case cMes == "03"
            Return "Maréo"
        Case cMes == "04"
            Return "Abril"
        Case cMes == "05"
            Return "Maio"
        Case cMes == "06"
            Return "Junho"
        Case cMes == "07"
            Return "Julho"
        Case cMes == "08"
            Return "Agosto"
        Case cMes == "09"
            Return "Setembro"
        Case cMes == "10"
            Return "Outubro"
        Case cMes == "11"
            Return "Novembro"
        Case cMes == "12"
            Return "Dezembro"
    EndCase

Return ""

Method alteraDescProduto() Class TroubleshootRemuneracao

    Local aPergs    := {}
    Local aRet      := {}
    Local Ni        := 0

    aAdd(aPergs, {11, "Pedidos", "", '.T.', '.T.', .T.})

    aRet := ::montaParambox(aPergs, "Altera Descriééo do Produto")

    If Len(aRet) == 0
        Alert("Processo interrompido.")
        Return
    EndIf

    For Ni := 1 To Len(::aParam)

        //SRFA3PFSCRIDGCHV5


    Next

Return

Method alteraDataEventos() Class TroubleshootRemuneracao

    Local aRet      := {}
    Local aLinha    := {}
    Local aFields   := {}
    Local aPergs    := {}
    Local cPedido   := ""
    Local cCpoSZ5   := ""
    Local Ni        := 0
    Local aTpPedido := {}
    Local cPedidoSZ5 := ""
    Local cPedidoSZ6 := ""
    Local nIndexSZ5 := 1
    Local nIndexSZ6 := 1

    dbSelectArea("SX3")
    SX3->(dbSetOrder(1))
    If SX3->(dbSeek("SZ6"))
        While SX3->(!EoF()) .And. AllTrim(SX3->X3_ARQUIVO) == "SZ6"
            If SX3->X3_TIPO == "D"
                aAdd(aFields, SX3->X3_CAMPO)
            EndIf
            SX3->(dbSkip())
        EndDo
    EndIf

    aAdd(aTpPedido,"1 - Pedido GAR")
    aAdd(aTpPedido,"2 - Pedido Site")

    aAdd(aPergs, {11, "Pedidos", "", '.T.', '.T.', .T.})
    aAdd(aPergs, {2 , "Campo Data","",aFields,75,"",.F.})
    aAdd(aPergs, {2 , "Tipo Pedido","",aTpPedido,75,"",.T.})

    aRet := ::montaParambox(aPergs, "Gera Adiantamento de Remuneração")

    If Len(aRet) == 0
        Alert("Processo interrompido.")
        Return
    EndIf

    cCampo := AllTrim(aRet[2])
    cTpPedido := AllTrim(Substr(aRet[3],1,1))

    Do Case
        Case cCampo == "Z6_VERIFIC"
            cCpoSZ5 := "Z5_DATVER"
        Case cCampo == "Z6_VALIDA"
            cCpoSZ5 := "Z5_DATVAL"
        Case cCampo == "Z6_DTEMISS"
            cCpoSZ5 := "Z5_DATEMIS"
    EndCase

    ProcRegua(Len(::aParam))

    For Ni := 1 To Len(::aParam)

        aLinha := StrTokArr2(::aParam[Ni],";",.T.)

        cPedido     := AllTrim(aLinha[1])
        dData       := CTOD(aLinha[2])
        cPedidoSZ5  := ""
        cPedidoSZ6  := ""
        nIndexSZ5   := 1
        nIndexSZ6   := 1

        IncProc("Processando registro: " + cValToChar(Ni))
        ProcessMessage()
        
        dbSelectArea("SZ5")

        If !Empty(cCpoSZ5)

            If cTpPedido == "1"
                nIndexSZ5 := 1
                nIndexSZ6 := 1
                cPedidoSZ5 := cPedido
                cPedidoSZ6 := cPedido
            Else
                nIndexSZ5 := 3
                nIndexSZ6 := 4
                cPedidoSZ5 := ""
                cPedidoSZ6 := cPedido

                dbSelectArea("SC5")
                SC5->(dbOrderNickName("PEDSITE"))
                If SC5->(dbSeek(xFilial("SC5") + cPedido))
                    cPedidoSZ5 := SC5->C5_NUM
                EndIf

            EndIf
            
            SZ5->(dbSetOrder(nIndexSZ5))
            If SZ5->(dbSeek(xFilial("SZ5") + cPedidoSZ5))

                RecLock("SZ5",.F.)
                    &("SZ5->" + cCpoSZ5) := dData
                SZ5->(MsUnlock())

            EndIf

        EndIf

        dbSelectArea("SZ6")
        SZ6->(dbSetOrder(nIndexSZ6))
        If SZ6->(dbSeek(xFilial("SZ6") + cPedidoSZ6))
            While SZ6->(!EoF()) .And. Iif(nIndexSZ6 == 1, AllTrim(SZ6->Z6_PEDGAR) == cPedidoSZ6, Iif(nIndexSZ6 == 4, AllTrim(SZ6->Z6_PEDSITE) == cPedidoSZ6, .F.))

                RecLock("SZ6",.F.)
                    &("SZ6->" + cCampo) := dData
                SZ6->(MsUnlock())

                SZ6->(dbSkip())
            EndDo
        EndIf

    Next

Return

Method verificaCampanha(aPedPar) Class TroubleshootRemuneracao

    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.}}
    Local aRet      := {}
    Local cPedidos  := ""
    Local aCabec    := {}
    Local aDados    := {}
    Local Ni        := 0
    Local i         := 0
    Local aDadosAux := {}
    Local cQuery    := ""
    Local oColor    := Nil
    Local aPedidos  := {}
    Local aLista    := {}
    Local Nx        := 0
    Local nCount    := 0
    Local nLast     := 0
    Local nLimite   := 0

    DEFAULT aPedPar := {}

    If Len(aPedPar) == 0

        aRet := ::montaParambox(aPergs, "Verifica Cálculo Campanha")

        If Len(aRet) == 0
            Return .F.
        EndIf
    Else
        ::aParam := aPedPar
    EndIF

    aAdd(aCabec, {"Status Cadastral","STATS"    ,"",50 ,0                                           ,"C",.T.})
    aAdd(aCabec, {"Status Cálculo  ","STATC"    ,"",50 ,0                                           ,"C",.T.})
    aAdd(aCabec, {"%SW"             ,"PERSW"    ,"",TamSX3("Z5_COMSW")[1]   ,TamSX3("Z5_COMSW")[2]  ,"N",.T.})
    aAdd(aCabec, {"%HW"             ,"PERHW"    ,"",TamSX3("Z5_COMHW")[1]   ,TamSX3("Z5_COMHW")[2]  ,"N",.T.})
    aAdd(aCabec, {"Cod.Parc"        ,"CODPAR"   ,"",TamSX3("Z5_CODPAR")[1]  ,0                      ,"C",.T.})
    aAdd(aCabec, {"Nome Parceiro"   ,"NOMPAR"   ,"",TamSX3("Z5_NOMPAR")[1]  ,0                      ,"C",.T.})
    aAdd(aCabec, {"Link de Campanha","LINK"     ,"",TamSX3("Z5_DESREDE")[1] ,0                      ,"C",.T.})

    If Len(::aParam) >= 1000
        nCount := Len(::aParam)

        nLimite := Iif(nCount >= 1000, 999, nCount)

        While nCount > 0
            aLista := {}
            For Ni := 1 To nLimite
                aAdd(aLista, ::aParam[Ni + nLast])
            Next

            nLast += (Ni - 1)
            nCount -= (Ni - 1)
            nLimite := Iif(nCount >= 1000, 999, nCount)

            aAdd(aPedidos, aLista)
        EndDo
    Else
        aPedidos := {::aParam}
    EndIf

    For Nx := 1 To Len(aPedidos)

        cPedidos := "("
        For Ni := 1 To Len(aPedidos[Nx])
            cPedidos += "'" + aPedidos[Nx][Ni] + "'" + Iif(Ni < Len(aPedidos[Nx]),",","")
        Next
        cPedidos += ")"

        cQuery := " SELECT DISTINCT  Z5_PEDGAR, " + CHR(13) + CHR(10)																		
        cQuery += " 		Z5_COMSW,  " + CHR(13) + CHR(10)
        cQuery += " 		Z5_COMHW,  " + CHR(13) + CHR(10)
        cQuery += " 		Z5_CODPAR, " + CHR(13) + CHR(10)
        cQuery += " 		Z5_NOMPAR, " + CHR(13) + CHR(10)
        cQuery += " 		Z5_DESREDE," + CHR(13) + CHR(10)
        cQuery += " 		CASE " + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z5_COMSW = 0 	 AND Z5_COMHW = 0 	 THEN 'SEM PERCENTUAL DE CAMPANHA' " + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z5_CODPAR = ' ' AND Z5_NOMPAR = ' ' THEN 'SEM CODIGO PARCEIRO'" + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z5_DESREDE NOT LIKE '%CONTADOR%' 	 THEN 'SEM LINK DE CAMPANHA'" + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z5_DESREDE LIKE '%FACESP%' 	     THEN 'NAO CALCULA FACESP'" + CHR(13) + CHR(10)
        cQuery += " 			ELSE 'DEVE CALCULAR CAMPANHA'" + CHR(13) + CHR(10)
        cQuery += " 		END AS ANALISE," + CHR(13) + CHR(10)
        cQuery += " 		CASE " + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z5_COMSW = 0 	 AND Z5_COMHW = 0 	 THEN 'NOK' " + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z5_CODPAR = ' ' AND Z5_NOMPAR = ' ' THEN 'NOK'" + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z5_DESREDE NOT LIKE '%CONTADOR%' 	 THEN 'NOK'" + CHR(13) + CHR(10)
        cQuery += " 			ELSE 'OK'" + CHR(13) + CHR(10)
        cQuery += " 		END AS ANALISE_ST,                " + CHR(13) + CHR(10)
        cQuery += " 		CASE" + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z6_VALCOM IS NULL THEN 'CAMPANHA NAO CALCULADA'" + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z6_VALCOM > 0 THEN 'CAMPANHA CALCULADA'" + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z6_VALCOM = 0 THEN 'CALCULOU COM VALOR ZERADO'" + CHR(13) + CHR(10)
        cQuery += " 		END AS STATUS_CALCULO," + CHR(13) + CHR(10)
        cQuery += " 		CASE" + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z6_VALCOM IS NULL THEN 'NOK'" + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z6_VALCOM > 0 THEN 'OK'" + CHR(13) + CHR(10)
        cQuery += " 			WHEN Z6_VALCOM = 0 THEN 'OK?'" + CHR(13) + CHR(10)
        cQuery += " 		END AS CALC_ST" + CHR(13) + CHR(10)
        cQuery += " FROM SZ5010" + CHR(13) + CHR(10)
        cQuery += " LEFT OUTER JOIN SZ6010" + CHR(13) + CHR(10)
        cQuery += " 	ON Z6_FILIAL = Z5_FILIAL" + CHR(13) + CHR(10)
        cQuery += " 	AND Z6_PEDGAR = Z5_PEDGAR" + CHR(13) + CHR(10)
        cQuery += " 	AND Z6_TPENTID = '7'" + CHR(13) + CHR(10)
        cQuery += " 	AND SZ6010.D_E_L_E_T_ = ' '" + CHR(13) + CHR(10)
        cQuery += " WHERE Z5_FILIAL = ' ' " + CHR(13) + CHR(10)
        cQuery += " 	AND Z5_PEDGAR IN " + cPedidos + CHR(13) + CHR(10)
        cQuery += " 	AND SZ5010.D_E_L_E_T_ = ' '" + CHR(13) + CHR(10)

        dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TMPCAMP", .T., .T.)

        While TMPCAMP->(!EoF())

            oColor := Nil

            If TMPCAMP->ANALISE_ST == "NOK" .Or. TMPCAMP->CALC_ST == "NOK"
                oColor := oVermelho
            ElseIf TMPCAMP->ANALISE_ST == "OK" .And. TMPCAMP->CALC_ST == "OK"
                oColor := oVerde
            ElseIf TMPCAMP->ANALISE_ST == "OK" .And. TMPCAMP->CALC_ST != "OK"
                oColor := oAzul
            ElseIf TMPCAMP->CALC_ST == "OK?"
                oColor := oAmarelo
            else
                oColor := oPreto
            EndIf

            aAdd(aDados, {oColor, TMPCAMP->Z5_PEDGAR, ;
                                    "", ;
                                    "", ;
                                    "", ;
                                    TMPCAMP->ANALISE, ;
                                    TMPCAMP->STATUS_CALCULO, ; 
                                    TMPCAMP->Z5_COMSW, ;
                                    TMPCAMP->Z5_COMHW, ;
                                    TMPCAMP->Z5_CODPAR, ;
                                    TMPCAMP->Z5_NOMPAR, ;
                                    TMPCAMP->Z5_DESREDE, ;
                                    .F.} )
            
            TMPCAMP->(dbSkip())
        EndDo

        TMPCAMP->(dbCloseArea())
    Next

    For i := 1 To Len(aDados)
        aAdd(aDadosAux, aDados[i])       
        If i % 1000 == 0
            ::criaTelaGrid(aCabec, aDadosAux)
            aDadosAux := {}
        EndIf
    Next i

    ::criaTelaGrid(aCabec, aDadosAux)

Return

Method geraRetificacao() Class TroubleshootRemuneracao

    Local oDlgGrid  := Nil
    Local aColsEx   := {}
    Local aCabecalho:= {}
    Local Ni := 0

    aAdd(aCabecalho,{"Pedido GAR"    ,"PEDGAR"   ,"@!"   ,TamSX3("Z6_PEDGAR")[1]    ,TamSX3("Z6_PEDGAR")[2]  ,".F.","","C",/*F3*/"","R","","",""})
    aAdd(aCabecalho,{"Valor SW"      ,"VALSW"    ,"@!"   ,TamSX3("Z6_VLRPROD")[1]   ,TamSX3("Z6_VLRPROD")[2] ,".F.","","N",/*F3*/"","R","","",""})
    aAdd(aCabecalho,{"Valor HW"      ,"VALHW"    ,"@!"   ,TamSX3("Z6_VLRPROD")[1]   ,TamSX3("Z6_VLRPROD")[2] ,".F.","","C",/*F3*/"","R","","",""})
    aAdd(aCabecalho,{"Tipo"          ,"TIPO"     ,"@!"   ,1                         ,0                       ,".F.","","C",/*F3*/"","R","G=Pedido GAR;S=Pedido Site","",""})
    aAdd(aCabecalho,{"Entidade"      ,"ENTIDA"   ,"@!"   ,1                         ,0                       ,".F.","","C",/*F3*/"","R","A=AC;C=Canal;F=Federaééo;P=Posto;R=Clube;S=Campanha;B=AR","",""})
    aAdd(aCabecalho,{"Observaééo"    ,"OBS"      ,"@!"   ,TamSX3("Z5_DESREDE")[1]   ,TamSX3("Z5_DESREDE")[2] ,".F.","","C",/*F3*/"","R","","",""})
    aAdd(aCabecalho,{"% Parceiro"    ,"PERPAR"   ,"@!"   ,TamSX3("Z5_COMSW")[1]     ,TamSX3("Z5_COMSW")[2]   ,".F.","","C",/*F3*/"","R","","",""})
    aAdd(aCabecalho,{"Céd. Parc."    ,"CODPAR"   ,"@!"   ,TamSX3("Z5_CODPAR")[1]    ,TamSX3("Z5_CODPAR")[2]  ,".F.","","C",/*F3*/"","R","","",""})
    aAdd(aCabecalho,{"Desc. Parceiro","DESPAR"   ,"@!"   ,TamSX3("Z5_NOMPAR")[1]    ,TamSX3("Z5_NOMPAR")[2]  ,".F.","","C",/*F3*/"","R","","",""})
    aAdd(aCabecalho,{"Link Parceiro" ,"LINKPA"   ,"@!"   ,TamSX3("Z5_DESREDE")[1]   ,TamSX3("Z5_DESREDE")[2] ,".F.","","C",/*F3*/"","R","","",""})
    aAdd(aCabecalho,{"Cod. Vend."    ,"CODVEN"   ,"@!"   ,TamSX3("Z6_CODVEND")[1]   ,TamSX3("Z6_CODVEND")[2] ,".F.","","C",/*F3*/"","R","","",""})
    aAdd(aCabecalho,{"Nome Vendedor" ,"NOMVEN"   ,"@!"   ,TamSX3("Z6_NOMVEND")[1]   ,TamSX3("Z6_NOMVEND")[2] ,".F.","","C",/*F3*/"","R","","",""})

    aAdd(aColsEx, {Space(TamSX3("Z6_PEDGAR")[1]), 0, 0, "G","P", Space(TamSX3("Z5_DESREDE")[1]), 0, Space(TamSX3("Z5_CODPAR")[1]), Space(TamSX3("Z5_NOMPAR")[1]), Space(TamSX3("Z5_DESREDE")[1]), Space(TamSX3("Z6_CODVEND")[1]), Space(TamSX3("Z6_NOMVEND")[1]) })

    DEFINE MSDIALOG oDlgGrid TITLE "GERADOR DE Retificação" FROM 000, 000  TO 300, 700  PIXEL

        //Monta o browser com inclusão, remoção e atualização
        oLista := MsNewGetDados():New( 053, 078, 415, 775, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgGrid, aCabecalho, aColsEx)
        oLista:SetArray(aColsEx,.T.)

        //Alinho o grid para ocupar todo o meu formulário
        oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

        //Ao abrir a janela o cursor está posicionado no meu objeto
        oLista:oBrowse:SetFocus()

        //Crio o menu que irá aparece no botão Aéées relacionadas
        aadd(aBotoes,{"NG_ICO_LEGENDA", {||Alert("OK-Leg")},"Legenda","Legenda"})
        aadd(aBotoes,{"NG_ICO_LEGENDA", {|| Processa({||GeraCSV(oLista)},"Gerando arquivo.","Gerando arquivo") },"Imprime CSV","Imprime CSV"})

        EnchoiceBar(oDlgGrid, {|| oDlgGrid:End() }, {|| oDlgGrid:End() },,aBotoes)

    ACTIVATE MSDIALOG oDlgGrid CENTERED

    For Ni := 1 To Len(aColsEx)
        Alert(aColsEx[Ni][1])
    Next

Return


Method corrigeFaixa() Class TroubleshootRemuneracao

    Local aFaixas   := {"[]-Sem Faixa","RE-Recalcula"}
    Local aPergs    := {}
    Local aRet      := {}
    Local aCabec    := {}
    Local aDados    := {}
    Local aRecnos   := {}
    Local Ni        := 0
    Local cFaixa    := ""

    BeginSql Alias "TMPFX"
        SELECT DISTINCT Z4_CATPROD, Z4_CATDESC FROM SZ4010 WHERE SUBSTR(Z4_CATPROD,1,1) = 'F' ORDER BY Z4_CATPROD
    EndSql

    While TMPFX->(!EoF())
        aAdd(aFaixas, TMPFX->Z4_CATPROD + "-" + TMPFX->Z4_CATDESC)
        TMPFX->(dbSkip())
    EndDo

    TMPFX->(dbCloseArea())

    aAdd(aPergs, {11, "Pedidos", "", '.T.', '.T.', .T.})
    aAdd(aPergs, {2,  "Faixa","[]-Sem Faixa",aFaixas,75,"",.F.})

    aRet := ::montaParambox(aPergs, "Ajusta Faixa")

    If Len(aRet) == 0
        Return .F.
    EndIf

    aAdd(aCabec, {"Status", "STATS", "", 50, 0, "C", .T.})

    cFaixa := Substr(aRet[2],1,2)
    If cFaixa == "[]"
        cFaixa := Space(TamSX3("Z5_DESCST")[1])
    EndIf

    For Ni := 1 To Len(::aParam)

        If cFaixa != "RE"
            dbSelectArea("SZ5")
            SZ5->(dbSetOrder(1))
            If SZ5->(dbSeek(xFilial("SZ5") + ::aParam[Ni]))

                aAdd(aDados, {oVerde, SZ5->Z5_PEDGAR, "", "", "", "Valor antigo: [" + SZ5->Z5_DESCST + "] Novo Valor: [" + cFaixa + "]",.F.}) 
                RecLock("SZ5",.F.)
                    SZ5->Z5_DESCST := cFaixa
                SZ5->(MsUnlock())

                aAdd(aRecnos, {SZ5->(Recno())})

            EndIf
        Else
            //TODO recalculo de faixas de pedidos
        EndIf

    Next

    ::criaTelaGrid(aCabec, aDados)

    If Len(aRecnos) > 0
        ::recalcular(aRecnos)
    EndIf

Return

Method alteraPedidoGAR() Class TroubleshootRemuneracao

    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.}}
    Local Ni        := 1
    Local oChkOut   := Nil
    Local cPedSite  := ""

    // Cria Parambox para parametrização
    aRet := ::montaParambox(aPergs, "Reprocessamento de Pedidos")

    // Se Parambox foi cancelada, sai da rotina
    If Len(aRet) == 0
        Return .F.
    EndIf

    For Ni := 1 To Len(::aParam)

       dbSelectArea("SZ5")
        dbSelectArea("SZ6")
        dbSelectArea("SC5")
        dbSelectArea("SC6")
        dbSelectArea("PA8")

        oChkOut := CheckoutRestClient():New(::aParam[Ni], PEDIDO_GAR)
        cPedSite := oChkOut:getPedSiteFromPedGar()

        If !Empty(cPedSite)
            SC5->(dbOrderNickName("PEDSITE"))
            If SC5->(dbSeek(xFilial("SC5") + cPedSite))

                SC6->(dbSetOrder(1))
                If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))

                    While SC6->(!EoF()) .And. SC6->C6_NUM == SC5->C5_NUM
                        If Empty(SC6->C6_PEDGAR) .And. SC6->C6_XOPER $ "51/61"
                            RecLock("SC6",.F.)
                                SC6->C6_PEDGAR := ::aParam[Ni]
                            SC6->(MsUnlock())
                        EndIf

                        SC6->(dbSkip())
                    EndDo
                EndIf

            EndIf
        EndIf

    Next


Return

Method fixSomethingUnusual() Class TroubleshootRemuneracao

   // ::getPedidoSite()

//Correção aplicada para registros de entidades (SZ3) duplicados na base
 /*   Local aArray    := {{}}
    Local cCodAnt   := ""
    Local cDescAnt  := ""
    Local Ni        := 0
    Local cCodEnt   := GetMV("MV_TMPAJUS")
    Local aCabec    := {}
    Local aDados    := {}
    Local aRecno    := {}

    aAdd(aCabec, {"Status", "STATS", "", 100, 0, "C", .T.})
    aAdd(aCabec, {"Descriééo", "DESC", "", 70, 0, "C", .T.})

    BeginSql Alias "TMPFIX"
        SELECT Z3_CODENT,Z3_DESENT,R_E_C_N_O_ 
        FROM SZ3010 
        WHERE Z3_FILIAL = ' ' 
        AND Z3_CODENT IN (SELECT Z3_CODENT 
                            FROM SZ3010 
                           WHERE D_E_L_E_T_ = ' ' 
                             AND Z3_TIPENT = '4'
                          GROUP BY Z3_CODENT 
                          HAVING COUNT(*) > 1)
        ORDER BY Z3_CODENT, R_E_C_N_O_
    EndSql

    dbSelectArea("SZ3")
    SZ3->(dbSetOrder(1))

    While TMPFIX->(!EoF())
        cCodAnt := AllTrim(TMPFIX->Z3_CODENT)
        While AllTrim(TMPFIX->Z3_CODENT) == cCodAnt
            aAdd(aTail(aArray), TMPFIX->R_E_C_N_O_)
            TMPFIX->(dbSkip())
        EndDo
        aAdd(aArray, {})
    EndDo

    TMPFIX->(dbCloseArea())

    //aSort(aArray,,,{|x,y| x < y})

    ProcRegua(Len(aArray))

    For Ni := 1 To Len(aArray)

        IncProc("Processando item: " + cValToChar(Ni))

        SZ3->(dbGoTo(aArray[Ni][1]))
        cDescAnt := AllTrim(SZ3->Z3_DESENT)
        
        BeginSql Alias "TMPORDER"
            SELECT DISTINCT Z6_PEDGAR, SZ5010.R_E_C_N_O_ RECNOSZ5
            FROM SZ6010 
            INNER JOIN SZ5010 
            ON Z5_FILIAL = Z6_FILIAL
            AND Z5_PEDGAR = Z6_PEDGAR
            AND SZ5010.D_E_L_E_T_ = ' '
            WHERE Z6_FILIAL = ' ' 
            AND Z6_CODENT = %Exp:SZ3->Z3_CODENT% 
            AND Z6_TPENTID = '4' 
            AND SZ6010.D_E_L_E_T_ = ' ' 
            AND Z6_PERIODO = '202102'
        EndSql

        While TMPORDER->(!EoF())
            aAdd(aRecno,{TMPORDER->RECNOSZ5})
            TMPORDER->(dbSkip())
        EndDo

        TMPORDER->(dbCloseArea())

        SZ3->(dbGoTo(aArray[Ni][2]))
        If AllTrim(SZ3->Z3_DESENT) != cDescAnt
            cCodEnt := GetMV("MV_TMPAJUS")

            cCodAnt := SZ3->Z3_CODENT

            RecLock("SZ3",.F.)
                SZ3->Z3_CODENT := cCodEnt
            SZ3->(MsUnlock())
            
            PutMV("MV_TMPAJUS", Soma1(cCodEnt))

            aAdd(aDados, {oVerde, "", "", "", "", "Código de entidade alterado de [" + cCodAnt + "] para [" + cCodEnt + "]","Entidade: " + SZ3->Z3_DESENT,.F.}) 

        EndIf
    Next

    ::criaTelaGrid(aCabec, aDados)

    If Len(aRecno) > 0 
        ::recalcular(aRecno)
    EndIf*/

// TRATAMENTO PARA CCR DIFERENTE DO INFORMADO PELA USUÁRIA SIS-6112
/*
    Local Ni := 1
    Local aCabec := {}
    Local aDados := {}
    Local cCodAnt := ""
    Local cCodEnt := ""
    Local cTpLanc := ""

    oParambox := CSParambox():New()
    oParambox:addListaPedidos()
    oParambox:show()
    
    aAdd(aCabec, {"Status", "STATS", "", 100, 0, "C", .T.})
    aAdd(aCabec, {"Tipo Lcto", "TPLANC", "", 10, 0, "C", .T.})
    aAdd(aCabec, {"Descrição", "DESC", "", 70, 0, "C", .T.})

    dbSelectArea("SZ6")
    SZ6->(dbSetOrder(1))

    dbSelectArea("SZ3")
    SZ3->(dbSetOrder(1))
    SZ3->(dbSeek(xFilial("SZ3") + "091414"))
    
    For Ni := 1 To oParambox:nQtdPedidos

        cCodAnt := ""
        cCodEnt := ""
        cTpLanc := ""

        If SZ6->(dbSeek(xFilial("SZ6") + oParambox:aPedidos[Ni]))
            While SZ6->(!EoF()) .And. AllTrim(SZ6->Z6_PEDGAR) == oParambox:aPedidos[Ni]
                
                cCodAnt := AllTrim(SZ6->Z6_CODCCR) + " - " + AllTrim(SZ6->Z6_CCRCOM)
                
                RecLock("SZ6", .F.)
                    SZ6->Z6_CODCCR := SZ3->Z3_CODENT
                    SZ6->Z6_CCRCOM := SZ3->Z3_DESENT
                SZ6->(MsUnlock())

                cCodEnt := AllTrim(SZ6->Z6_CODCCR) + " - " + AllTrim(SZ6->Z6_CCRCOM)

                Do Case
                    Case SZ6->Z6_TPENTID == "4"
                        cTpLanc := "4 - Posto"
                    Case SZ6->Z6_TPENTID == "2"
                        cTpLanc := "2 - AC"
                    Otherwise
                        cTpLanc := SZ6->Z6_TPENTID
                EndCase                    
                
                aAdd(aDados, {oVerde, oParambox:aPedidos[Ni], "", "", "", "Código de entidade alterado de [" + cCodAnt + "] para [" + cCodEnt + "] Tipo: [" + SZ3->Z3_TIPENT + "]",cTpLanc,"Entidade: " + SZ3->Z3_DESENT,.F.}) 

                SZ6->(dbSkip())
            EndDo

        EndIf
    Next

    If Len(aDados) > 0
        ::criaTelaGrid(aCabec, aDados)
    EndIf
*/
Return

Method consultaTipoVoucher() Class TroubleshootRemuneracao

    Local aCabec := {}
    Local aDados := {}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.}}
    Local Ni        := 1
    Local oCheckout := Nil
    Local oVoucher  := Nil

    // Cria Parambox para parametrização
    aRet := ::montaParambox(aPergs, "Consulta Tipo de Voucher")
    
    aAdd(aCabec, {"Tp. Voucher", "TIPO", "", 1, 0, "C", .T.})
    aAdd(aCabec, {"Desc. Voucher", "DESC", "", 100, 0, "C", .T.})

    // Se Parambox foi cancelada, sai da rotina
    If Len(aRet) == 0
        Return .F.
    EndIf

    ProcRegua(Len(::aParam))

    For Ni := 1 To Len(::aParam)

        IncProc("Localizando voucher no pedido: " + ::aParam[Ni])
        ProcessMessage()

        oCheckout := CheckoutRestClient():New(::aParam[Ni], PEDIDO_GAR)
        cVoucher := oCheckout:getVoucher()

        oVoucher := Voucher():New()
        If oVoucher:find(cVoucher)
            aAdd(aDados, {oVerde, ::aParam[Ni], "", "", "", oVoucher:getTipo(), oVoucher:getDescricao(),.F.}) 
        Else
            aAdd(aDados, {oVermelho, ::aParam[Ni], "", "", "", "?", "não foi localizado voucher para o pedido.",.F.}) 
        EndIf
    Next

    ::criaTelaGrid(aCabec, aDados)
Return

Method reprocGTIN() Class TroubleshootRemuneracao

    Local aCabec := {}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.}}
    Local Ni        := 1
    Local oCheckout := Nil
    Local cPedSite  := ""

    // Cria Parambox para parametrização
    aRet := ::montaParambox(aPergs, "Reprocessa pedidos GTIN")
    
    aAdd(aCabec, {"Tp. Voucher", "TIPO", "", 1, 0, "C", .T.})

    // Se Parambox foi cancelada, sai da rotina
    If Len(aRet) == 0
        Return .F.
    EndIf

    For Ni := 1 To Len(::aParam)

        oCheckout := CheckoutRestClient():New(::aParam[Ni], PEDIDO_GAR)
        cPedSite := oCheckout:getPedSiteFromPedGar()

        cSql := " UPDATE GTIN SET GT_INPROC = 'F', GT_SEND = 'F', GT_DATE = '"+DTOS(Date())+"' WHERE GT_TYPE = 'F' AND GT_XNPSITE =  '"+AllTrim(cPedSite)+"' "
		TcSqlExec(cSql)
    Next

Return

Method getPedidoSite() Class TroubleshootRemuneracao

    Local aCabec := {}
    Local aDados := {}
    Local aPergs    := {{11, "Pedidos", "", '.T.', '.T.', .T.}}
    Local Ni        := 1
    Local oCheckout := Nil
    Local cPedSite  := ""

    // Cria Parambox para parametrização
    aRet := ::montaParambox(aPergs, "Retorna pedidos Site")

    // Se Parambox foi cancelada, sai da rotina
    If Len(aRet) == 0
        Return .F.
    EndIf

    For Ni := 1 To Len(::aParam)

        oCheckout := CheckoutRestClient():New(::aParam[Ni], PEDIDO_GAR)
        cPedSite := oCheckout:getPedSiteFromPedGar()

        aAdd(aDados,{oVerde, ::aParam[Ni], cPedSite, "", "",.F.}) 

        oCheckout := Nil
        cPedSite := ""

    Next

    ::criaTelaGrid(aCabec, aDados)

Return
