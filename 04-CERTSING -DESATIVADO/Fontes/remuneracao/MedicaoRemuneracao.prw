#include 'protheus.ch'

Class MedicaoRemuneracao

    Data cNumeroMedicao 
    Data cContrato
    Data cRevisao
    Data cNumero
    Data cParcela
    Data cCompetencia
    Data cFornecedor
    Data cLojaFornecedor
    Data cCondicaoPgto
    Data nValorTotal
    Data cAprovador
    Data cMoeda

    Data cItem
    Data cProduto
    Data nQuantidade
    Data nValorUnitario
    Data cTES
    Data dDataEntrega
    Data cCentroCusto
    Data cContaContabil

    Method New(cNumMed, cContrato, cRevisao, cCompet, cFornec, cLojaFor, cCondPgto, nVlrTotal, cAprov,cProduto, nVlrUnit, cTES, dDtEntrega, cCCusto, cCCtb) 
    Method getCabecArray() 
    Method getItensArray()

EndClass    

Method New(cNumMed, cContrato, cRevisao, cCompet, cFornec, cLojaFor, cCondPgto, nVlrTotal, cAprov,;
            cProduto, nVlrUnit, cTES, dDtEntrega, cCCusto, cCCtb) Class MedicaoRemuneracao
    
    ::cNumeroMedicao := cNumMed
    ::cContrato := cContrato
    ::cRevisao := cRevisao
    ::cNumero := "000001"
    ::cParcela := " "
    ::cCompetencia := cCompet
    ::cFornecedor := cFornec
    ::cLojaFornecedor := cLojaFor
    ::cCondicaoPgto := cCondPgto
    ::nValorTotal := nVlrTotal
    ::cAprovador := cAprov
    ::cMoeda := "1"

    ::cItem := "001"
    ::cProduto := cProduto
    ::nQuantidade := 1
    ::nValorUnitario := nVlrUnit
    ::cTES := cTES
    ::dDataEntrega := dDtEntrega
    ::cCentroCusto := cCCusto
    ::cContaContabil := cCCtb

Return

Method getCabecArray() Class MedicaoRemuneracao

    Local aCabec := {}

    aAdd(aCabec,{"CND_CONTRA"	, ::cContrato       	,NIL})
    aAdd(aCabec,{"CND_REVISA"	, ::cRevisao            ,NIL})
    aAdd(aCabec,{"CND_NUMERO"	, ::cNumero				,NIL})
    aAdd(aCabec,{"CND_PARCEL"	, ::cParcela			,NIL})
    aAdd(aCabec,{"CND_COMPET"	, ::cCompet				,NIL})
    aAdd(aCabec,{"CND_NUMMED"	, ::cNumeroMedicao		,NIL})
    aAdd(aCabec,{"CND_FORNEC"	, ::cFornecedor			,NIL})
    aAdd(aCabec,{"CND_LJFORN"	, ::cLojaFornecedor		,NIL})
    aAdd(aCabec,{"CND_CONDPG"	, ::cCondicaoPgto		,NIL})
    aAdd(aCabec,{"CND_VLTOT"	, ::nValorTotal			,NIL})
    aAdd(aCabec,{"CND_APROV"	, ::cAprovador 			,NIL})
    aAdd(aCabec,{"CND_MOEDA"	, ::cMoeda				,NIL})

Return aCabec

Method getItensArray() Class MedicaoRemuneracao

    Local aLinha := {}

    aLinha := {}
    aadd(aLinha,{"CNE_ITEM" 	, ::cItem			,NIL})
    aadd(aLinha,{"CNE_PRODUT" 	, ::cProduto		,NIL})
    aadd(aLinha,{"CNE_QUANT" 	, ::nQuantidade 	,NIL})
    aadd(aLinha,{"CNE_VLUNIT" 	, ::nValorTotal 	,NIL})
    aadd(aLinha,{"CNE_VLTOT" 	, ::nValorTotal 	,NIL})
    aadd(aLinha,{"CNE_TE" 		, ::cTES		    ,NIL})
    aadd(aLinha,{"CNE_DTENT"	, ::dDataEntrega	,NIL})
    aadd(aLinha,{"CNE_CC" 		, ::cCentroCusto  	,NIL})
    aadd(aLinha,{"CNE_CONTA"	, ::cContaContabil	,NIL})

Return aLinha
