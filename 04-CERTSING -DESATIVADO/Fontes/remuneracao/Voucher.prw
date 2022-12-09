#INCLUDE "TOTVS.CH"

Class Voucher

    Data cCodigo as String
    Data cTipo as String
    Data cDescTipo as String
    Data cPedSiteOrigem as String
    Data cPedSiteConsumo as String
    Data cPedGarOrigem as String
    Data cPedGarConsumo as String
    Data cPedProtConsumo as String
    Data cCodigoFluxo as String
    Data dDtConsumo as Date
    Data cProduto as String
    Data cSolicitante as String
    Data nValor as Numeric
    Data nVlrSoft as Numeric
    Data nVlrHard as Numeric
    Data nSaldo as Numeric
    Data nRecnoSZF as Numeric
    Data nRecnoSZG as Numeric
    Data lFound as Logical

    Method New(cCodVoucher) Constructor
    Method find(cCodVoucher)
    Method getValor()
    Method hasOrderVoucher(cVoucher)
    Method getTipo()
    Method getDescricao()

EndClass

Method New(cCodVoucher) Class Voucher

    DEFAULT cCodVoucher := ""

    If !Empty(cCodVoucher)
        ::cCodigo := cCodVoucher
        ::find(::cCodigo)
    Else
        ::cCodigo           := ""
        ::cTipo             := ""
        ::cDescTipo         := ""
        ::cPedSiteOrigem    := ""
        ::cPedSiteConsumo   := ""
        ::cPedGarOrigem     := ""
        ::cPedGarConsumo    := ""
        ::cPedProtConsumo   := ""
        ::cCodigoFluxo      := ""
        ::dDtConsumo        := CTOD("//")
        ::cProduto          := ""
        ::cSolicitante      := ""
        ::nValor            := 0
        ::nVlrSoft          := 0
        ::nVlrHard          := 0
        ::nSaldo            := 0
        ::lFound            := .F.
    EndIf

Return

Method find(cCodVoucher) Class Voucher

    DEFAULT cCodVoucher := ::cCodigo

    If Empty(cCodVoucher)
        Return .F.
    EndIf

    If !::lFound

        dbSelectArea("SZF")
        dbSelectArea("SZG")
        dbSelectArea("SZH")

        SZF->(dbSetOrder(2))
        SZG->(dbSetOrder(1))
        SZH->(dbSetOrder(1))

        If SZF->(dbSeek(xFilial("SZF") + cCodVoucher))

            SZH->(dbSeek(xFilial("SZH") + SZF->ZF_TIPOVOU))

            BeginSql Alias "TMPSZG"
                SELECT R_E_C_N_O_ FROM SZG010 WHERE ZG_FILIAL = %xFilial:SZG% AND ZG_NUMVOUC = %Exp:cCodVoucher%
            EndSql

            SZG->(dbGoTo(TMPSZG->R_E_C_N_O_))
            TMPSZG->(dbCloseArea())

            ::cCodigo           := AllTrim(SZF->ZF_COD)
            ::cTipo             := AllTrim(SZF->ZF_TIPOVOU)
            ::cDescTipo         := AllTrim(SZH->ZH_DESCRI)
            ::cPedSiteOrigem    := AllTrim(SZF->ZF_PEDSITE)
            ::cPedSiteConsumo   := AllTrim(SZG->ZG_PEDSITE)
            ::cPedGarOrigem     := AllTrim(SZF->ZF_PEDIDO)
            ::cPedGarConsumo    := AllTrim(SZG->ZG_NUMPED)
            ::cPedProtConsumo   := AllTrim(SZG->ZG_PEDIDO)
            ::cCodigoFluxo      := AllTrim(SZF->ZF_CODFLU)
            ::dDtConsumo        := AllTrim(SZG->ZG_DATAMOV)
            ::cProduto          := AllTrim(SZF->ZF_PRODUTO)
            ::cSolicitante      := AllTrim(SZF->ZF_USRSOL)
            ::nValor            := SZF->ZF_VALOR
            ::nVlrSoft          := SZF->ZF_VALORSW
            ::nVlrHard          := SZF->ZF_VALORHW
            ::nSaldo            := SZF->ZF_SALDO
            ::nRecnoSZF         := SZF->(RECNO())
            ::nRecnoSZG         := SZG->(RECNO())

            ::lFound := .T.

        EndIf
    EndIf

Return ::lFound

Method getValor() Class Voucher

    Local oChkOut       := Nil
    Local oVoucher      := Nil
    Local cVoucher      := ""
    Local aRet          := {}
    Local lPedGar       := .F.
    Local lPedSite      := .F.
    Local aAreaSZF      
    Local aAreaSZG
    Local aAreaSZ5

/*    If ::find()

        oChkOut := CheckoutRestClient():New(cPedidoGAR, PEDIDO_GAR)
        cVoucher := oChkOut:getVoucher()

        //Tipos que obrigatoriamente requerem um pedido Origem
        If ::cTipo $ "2/A/B/"

            lPedGAR := !Empty(::cPedGarOrigem) .And. !Empty(StrTran(::cPedGarOrigem, "*","")) .And. !Empty(StrTran(::cPedGarOrigem, ".",""))

            If !lPedGAR
                 //Pedido GAR Origem Inválido, indo pelo pedSite
                lPedSite := !Empty(::cPedSiteOrigem) .And. !Empty(StrTran(::cPedSiteOrigem, "*","")) .And. !Empty(StrTran(::cPedSiteOrigem, ".",""))
                If !lPedSite 
                EndIf
            EndIf

        ElseIf ::cTipo == "F"
        ElseIf ::cTipo == "H"
        ElseIf ::cValor > 0
        EndIf

                lPedGAR := !Empty(SZF->ZF_PEDIDO) .And. !Empty(StrTran(SZF->ZF_PEDIDO, "*","")) .And. !Empty(StrTran(SZF->ZF_PEDIDO, ".",""))
                If !lPedGAR
                    //Pedido GAR Origem Inválido, indo pelo pedSite
                    lPedSite := !Empty(SZF->ZF_PEDSITE) .And. !Empty(StrTran(SZF->ZF_PEDSITE, "*","")) .And. !Empty(StrTran(SZF->ZF_PEDSITE, ".",""))
                    If !lPedSite
                        //Pedido Site Origem Inválido
                        //Encerra execução porque o tipo de voucher requer pedido origem vinculado
                        //Verifica se há voucher no pedido origem, pelo Checkout
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

    EndIf*/

Return

Method hasOrderVoucher(cPedido) Class Voucher

    Local oCheckout := Nil
    Local cVoucher := ""

    oCheckout := CheckoutRestClient():New(cPedido, 1)
    cVoucher := oCheckout:getVoucher()
    If !Empty(cVoucher)
        ::find(cVoucher)
    EndIf

Return ::lFound

Method getTipo() Class Voucher
Return ::cTipo

Method getDescricao() Class Voucher
Return ::cDescTipo
