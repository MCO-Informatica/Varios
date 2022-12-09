#INCLUDE "PROTHEUS.CH"

/**
* Classe responsável por mapear os campos necessários para utilização do
* Pedido de Compra no processo de Remuneração de Parceiros.
*
* @class    PedidoRemuneracao
* @version  1.0
* @date     11/08/2020
*
**/
Class PedidoRemuneracao

    Data cNumeroPedido
    Data dEmissao
    Data cFornecedor
    Data cLojaFornecedor
    Data cCondicaoPgto
    Data cContato
    Data cFilialEntrega

    Data cProduto
    Data nQuantidade
    Data nValorPedido
    Data nValorTotal
    Data cTES
    Data cLocalPadrao
    Data cAprovador
    Data cContaContabil

	Data cPeriodoRef 
	Data lAprovadoBudget
	Data lRecorrente 
	Data cCCustoAprova
	Data cDescCCustoAprova
	Data cCCustoDespesa
	Data cDescCCustoDespesa
	Data cCentroResultado
	Data cDescCResultado
	Data cCodigoProjeto
	Data cDescProjeto
	Data cContaCtbOrcada
	Data cDescCCtbOrcada
	Data cDescDespesaOrc
	Data cDescricao
	Data cJustificativa
	Data cObjetivo
	Data cInfoAdicional
	Data cFormaPgto
	Data dVencimento
	Data cDocFiscal

    Method New() Constructor
    Method getFromSC7(cNumPed)
    Method getFromMedicao(cMedicao)
    Method criaBaseConhecimento()
    Method geraPedido()
    Method getCabecArray()
    Method getItemsArray()
    Method rollback()

EndClass

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   New
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method New() Class PedidoRemuneracao
        ::cNumeroPedido         := ""
        ::dEmissao              := CTOD("//")
        ::cFornecedor           := ""
        ::cLojaFornecedor       := ""
        ::cCondicaoPgto         := ""
        ::cContato              := ""
        ::cFilialEntrega        := ""

        //Item - Para remuneração há apenas 1 item
        ::cProduto              := ""
        ::nQuantidade           := 0
        ::nValorPedido          := 0
        ::nValorTotal           := 0
        ::cTES                  := ""
        ::cLocalPadrao          := ""
        ::cAprovador            := ""
        ::cContaContabil        := ""

        //Informações de Capa de Despesa
        ::cPeriodoRef           := ""
        ::lAprovadoBudget       := .F.
        ::lRecorrente           := .F.
        ::cCCustoAprova         := ""
        ::cDescCCustoAprova     := ""
        ::cCCustoDespesa        := ""
        ::cDescCCustoDespesa    := ""
        ::cCentroResultado      := ""
        ::cDescCResultado       := ""
        ::cCodigoProjeto        := ""
        ::cDescProjeto          := ""
        ::cContaCtbOrcada       := ""
        ::cDescCCtbOrcada       := ""
        ::cDescDespesaOrc       := ""
        ::cDescricao            := ""
        ::cJustificativa        := ""
        ::cObjetivo             := ""
        ::cInfoAdicional        := ""
        ::cFormaPgto            := ""
        ::dVencimento           := CTOD("//")
        ::cDocFiscal            := ""
Return

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   getItemsArray
* @param    null
* @return   array Array com a estrutura [1] Campo SC7, [2] Valor SC7
* @version  1.0
* @date     11/08/2020
*
**/
Method getFromSC7(cNumPed) Class PedidoRemuneracao

    dbSelectArea("SC7")
    SC7->(dbSetOrder(1))
    If SC7->(dbSeek(xFilial("SC7") + cNumPed))

        //Cabeçalho
        ::cNumeroPedido         := SC7->C7_NUM
        ::dEmissao              := SC7->C7_EMISSAO
        ::cFornecedor           := SC7->C7_FORNECE
        ::cLojaFornecedor       := SC7->C7_LOJA	
        ::cCondicaoPgto         := SC7->C7_COND		
        ::cContato              := SC7->C7_CONTATO
        ::cFilialEntrega        := SC7->C7_FILENT

        //Item - Para remuneração há apenas 1 item
        ::cProduto              := SC7->C7_PRODUTO
        ::nQuantidade           := SC7->C7_QUANT
        ::nValorPedido          := SC7->C7_PRECO
        ::nValorTotal           := SC7->C7_TOTAL
        ::cTES                  := SC7->C7_TES
        ::cLocalPadrao          := SC7->C7_LOCAL
        ::cAprovador            := SC7->C7_APROV
        ::cContaContabil        := SC7->C7_CONTA

        //Informações de Capa de Despesa
        ::cPeriodoRef           := SC7->C7_XREFERE 
        ::lAprovadoBudget       := SC7->C7_APBUDGE
        ::lRecorrente           := SC7->C7_XRECORR
        ::cCCustoAprova         := SC7->C7_CCAPROV
        ::cDescCCustoAprova     := GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT") + SC7->C7_CCAPROV, 1, "")
        ::cCCustoDespesa        := SC7->C7_CC
        ::cDescCCustoDespesa    := GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT") + SC7->C7_CC, 1, "")
        ::cCentroResultado      := SC7->C7_ITEMCTA
        ::cDescCResultado       := GetAdvFVal("CTD","CTD_DESC01",xFilial("CTD") + SC7->C7_ITEMCTA, 1, "")
        ::cCodigoProjeto        := SC7->C7_CLVL
        ::cDescProjeto          := GetAdvFVal("CTH","CTH_DESC01",xFilial("CTH") + SC7->C7_CLVL, 1, "")
        ::cContaCtbOrcada       := SC7->C7_CTAORC
        ::cDescCCtbOrcada       := GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1") + SC7->C7_CTAORC, 1, "")
        ::cDescDespesaOrc       := SC7->C7_DDORC
        ::cDescricao            := GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT") + SC7->C7_DDORC, 1, "")
        ::cJustificativa        := SC7->C7_XJUST
        ::cObjetivo             := SC7->C7_XOBJ
        ::cInfoAdicional        := SC7->C7_XADICON
        ::cFormaPgto            := SC7->C7_FORMPG
        ::dVencimento           := SC7->C7_XVENCTO
        ::cDocFiscal            := SC7->C7_DOCFIS

    EndIf

Return !Empty(::cNumeroPedido)

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   getFromMedicao
* @param    cMedicao 
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method getFromMedicao(cMedicao) Class PedidoRemuneracao

    Local lRet := .F.

    dbSelectArea("SC7")
    SC7->(dbSetOrder(1)) //C7_FILIAL + C7_NUM
    
    dbSelectArea("CND")
    CND->(dbSetOrder(4)) //CND_FILIAL + CND_NUMMED
    If CND->(dbSeek(xFilial("CND") + cMedicao))

        If !Empty(CND->CND_PEDIDO) 

            lRet := ::getFromSC7(CND->CND_PEDIDO)

        EndIf
    EndIf

Return lRet

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   criaBaseConhecimento
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method criaBaseConhecimento() Class PedidoRemuneracao

    Local aArea		:= GetArea()
    Local cFile 	:= ""

    cFile := StrTran(AllTrim(NoAcento(AnsiToOem( ZZ6->ZZ6_PERIOD + " - " + ZZ6->ZZ6_CODENT + " - " + ZZ6->ZZ6_DESENT ))),"/","-")

    IncProc( "Gerando o arquivo e adicionando a Base de Conhecimento.")
    ProcessMessage()

    dbSelectArea("ACB")
    ACB->(dbSetOrder(2))
    ACB->(dbSeek(xFilial("ACB") + cFile + ".pdf" ))

    // Não faz copia do arquivo, apenas aponta o arquivo ja existente.
    // Inclui registro no banco de conhecimento e verifica se ja existe para não duplicar.
    RecLock("ACB",.T.)
        ACB->ACB_FILIAL := xFilial("ACB")
        ACB->ACB_CODOBJ := GetSxeNum("ACB","ACB_CODOBJ")
        ACB->ACB_OBJETO	:= cFile + ".pdf"
        ACB->ACB_DESCRI	:= cFile
    ACB->(MsUnLock())

    ConfirmSx8()
                    
    // Inclui amarração entre registro do banco e entidade
    dbSelectArea("AC9")
    RecLock("AC9",.T.)
        AC9->AC9_FILIAL	:= xFilial("AC9")
        AC9->AC9_FILENT	:= xFilial("SC7")
        AC9->AC9_ENTIDA	:= "SC7"
        AC9->AC9_CODENT	:= xFilial("SC7") + ::cNumeroPedido + "0001"
        AC9->AC9_CODOBJ	:= ACB->ACB_CODOBJ
    MsUnLock()         

    RestArea( aArea )

Return

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    aCabec Array contendo a estrutura do cabeçalho na SC7 para ExecAuto
* @param    aItens Array contendo a estrutura dos itens da SC7 para ExecAuto
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method geraPedido(aCabec, aItens) Class PedidoRemuneracao

    DEFAULT aCabec := ::getCabecArray()
    DEFAULT aItens := ::getItemsArray()

    MATA120(1, aCabec, aItens, 3)

Return

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   fromSZ6
* @param    null
* @return   array Array com a estrutura [1] Campo SC7, [2] Valor do campo
* @version  1.0
* @date     11/08/2020
*
**/
Method getCabecArray() Class PedidoRemuneracao

    Local aCabec := {}

    aAdd(aCabec,{"C7_NUM" 		, ::cNumeroPedido	})
    aAdd(aCabec,{"C7_EMISSAO" 	, ::dEmissao    	})
    aAdd(aCabec,{"C7_FORNECE" 	, ::cFornecedor	    })
    aAdd(aCabec,{"C7_LOJA" 		, ::cLojaFornecedor	})
    aAdd(aCabec,{"C7_COND" 		, ::cCondicaoPgto	})
    aAdd(aCabec,{"C7_CONTATO" 	, ::cContato		})
    aAdd(aCabec,{"C7_FILENT" 	, ::cFilialEntrega  })
		
Return aCabec

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   getItemsArray
* @param    null
* @return   array Array com a estrutura [1] Campo SC7, [2] Valor SC7
* @version  1.0
* @date     11/08/2020
*
**/
Method getItemsArray() Class PedidoRemuneracao
    
    Local aLinha := {}

    aLinha := {}
    aAdd(aLinha,{"C7_PRODUTO" 	, ::cProduto		,Nil})
    aAdd(aLinha,{"C7_QUANT" 	, ::nQuantidade 	,Nil})
    aAdd(aLinha,{"C7_PRECO" 	, ::nValorPedido 	,Nil})
    aAdd(aLinha,{"C7_TOTAL" 	, ::nValorTotal 	,Nil})
    aAdd(aLinha,{"C7_TES" 		, ::cTES            ,Nil})
    aAdd(aLinha,{"C7_LOCAL"		, ::cLocalPadrao 	,Nil})
    aAdd(aLinha,{"C7_APROV"		, ::cAprovador      ,Nil})
    aAdd(aLinha,{"C7_CONTA"		, ::cContaContabil	,Nil})
		
    //Campos da capa de despesa
    aAdd(aLinha,{"C7_XREFERE", ::cPeriodoRef					,Nil})     
    aAdd(aLinha,{"C7_APBUDGE", Iif(::lAprovadoBudget,"1","2")	,Nil})
    aAdd(aLinha,{"C7_XRECORR", Iif(::lRecorrente,"1","2")		,Nil})
    aAdd(aLinha,{"C7_CC" 	 , ::cCCustoDespesa					,Nil})
    aAdd(aLinha,{"C7_CCAPROV", ::cCCustoAprova  				,Nil})
    aAdd(aLinha,{"C7_ITEMCTA", ::cCentroResultado       		,Nil})
    aAdd(aLinha,{"C7_CLVL   ", ::cCodigoProjeto					,Nil})
    aAdd(aLinha,{"C7_CTAORC ", ::cContaCtbOrcada				,Nil})     
    aAdd(aLinha,{"C7_FORMPG ", ::cFormaPgto						,Nil})      
    aAdd(aLinha,{"C7_DOCFIS ", ::cDocFiscal	    				,Nil})
    aAdd(aLinha,{"C7_XVENCTO", ::dVencimento					,Nil})

Return aLinha

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   rollback
* @param    null
* @return   array Array com a estrutura [1] Campo SC7, [2] Valor SC7
* @version  1.0
* @date     11/08/2020
*
**/
Method rollback() Class PedidoRemuneracao

    dbSelectArea("SC7")
    SC7->(dbSetOrder(1))
    If SC7->(dbSeek(xFilial("SC7") + ::cNumeroPedido))
        
        SC7->(RecLock("SC7",.F.))
            SC7->(dbDelete())
        SC7->(MsUnLock())
        
        dbSelectArea("SCR")
        SCR->(dbSetOrder(1))
        If SCR->(dbSeek(xFilial("SCR") + "PC" + ::cNumeroPedido))
            
            While SCR->CR_NUM == ::cNumeroPedido .And. SCR->CR_TIPO == "PC"
                SCR->(RecLock("SCR",.F.))
                    SCR->(DbDelete())
                SCR->(MsUnLock())
                SCR->(DbSkip())
            Enddo				
        
        Endif
        
    Endif

Return
