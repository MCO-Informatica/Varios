#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE PEDIDO_GAR  1
#DEFINE PEDIDO_SITE 2
#DEFINE PEDIDO_ECOM 3

CLASS CheckoutRestClient 
	// Declaracao das propriedades da Classe
	DATA aHeadStr				as array
    DATA oCheckout              as object
    DATA cURL                   as string
    DATA cEndPoint              as string
    DATA lLoaded                as logical
    DATA nTipoPedido            as numeric
	
    METHOD New(cPedido, nTipoPedido) CONSTRUCTOR
	METHOD getPedSiteFromPedGar()
    METHOD carregaPedido(cPedido, nTipoPedido)
    METHOD getValorBruto()
    METHOD getVoucher()
    METHOD getActualPedGAR(cIdItemCheckout)
    METHOD getTipoVoucher()
    Method getChildrenItems(cIdItemPai)
ENDCLASS

METHOD New(cPedido, nTipoPedido) CLASS CheckoutRestClient

    	Local oChkOut   := checkoutParam():get()
        Local cUser     := ""
        Local cPassword := ""

        DEFAULT nTipoPedido := PEDIDO_GAR

		::cURL      := oChkOut:url
		::cEndPoint := oChkOut:endPoint
        ::aHeadStr  := {}

		cUser       := oChkOut:userCode
		cPassWord   := oChkOut:password
	
		AAdd( ::aHeadStr, "Content-Type: application/json" )
		AAdd( ::aHeadStr, "Accept: application/json" )
		AAdd( ::aHeadStr, "Authorization: Basic " + EnCode64( cUser + ":" + cPassword ) )
		
		// Host para consumo REST.
		::oCheckout := FWRest():New( ::cURL )

        ::carregaPedido(cPedido, nTipoPedido)

Return 

METHOD carregaPedido(cPedido, nTipoPedido) CLASS CheckoutRestClient

    Local cParam        := ""
    Local cGetResult    := ""
    Local oPSite        := ""
    Local lGet          := .F.
    Local lDeserialize  := .F.

    DEFAULT nTipoPedido := PEDIDO_GAR

    ::nTipoPedido := nTipoPedido

    Do Case
        Case nTipoPedido == PEDIDO_GAR
            cParam := "?pedido_gar="
        Case nTipoPedido == PEDIDO_SITE
            cParam := "/"
        Case nTipoPedido == PEDIDO_ECOM
            cParam := "/"
    EndCase

    // Primeiro path aonde será feito a requisição
    ::oCheckout:setPath( ::cEndPoint + cParam + cPedido)
		
	// Efetuar o GET para completar a conexão.
    lGet := ::oCheckout:Get( ::aHeadStr )
		
	cGetResult := ::oCheckout:GetResult()
		
    If FwJsonDeserialize(cGetResult,@oPSite) .AND. ValType(oPSite)=='A' .AND. Len(oPSite)==1 .AND. Type('oPSite[1]:codigo')=='N'
        If oPSite[ 1 ]:codigo == 500
            cGetResult := '[ ]'
        Endif
    Endif
		
    // Se conseguiu fazer o GET e houve retorno de dados.
    If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }'
        // Deserializar o retorno em objeto.
        lDeserialize := FWJsonDeserialize( cGetResult, @::oCheckout )
    Endif

    ::lLoaded := lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }' .AND. lDeserialize

Return 

METHOD getPedSiteFromPedGar() CLASS CheckoutRestClient

    Local cC5_XNPSITE := ""

    If ::lLoaded
        cC5_XNPSITE := cValToChar( ::oCheckout[1]:numero )
    EndIf

RETURN cC5_XNPSITE

METHOD getValorBruto() Class CheckoutRestClient

    Local nValorBruto   := 0

    If ::lLoaded
       nValorBruto := ::oCheckout[1]:valorBruto
    EndIf

Return nValorBruto

METHOD getVoucher() Class CheckoutRestClient

    Local cVoucher := ""

    If ::lLoaded

        If ::nTipoPedido == PEDIDO_GAR
            If AllTrim(::oCheckout[1]:pagamento:formaPagamento) == "VOUCHER"
                cVoucher := ::oCheckout[1]:pagamento:voucher:codigo
            EndIf
        ElseIf ::nTipoPedido == PEDIDO_SITE
            If AllTrim(::oCheckout:pagamento:formaPagamento) == "VOUCHER"
                cVoucher := ::oCheckout:pagamento:voucher:codigo
            EndIf
        EndIf
    EndIf

Return cVoucher

Method getActualPedGAR(cIdItemCheckout) Class CheckoutRestClient

    Local Ni := 0
    Local aItensPedido := ::oCheckout[1]:itens
    Local oItem
    Local oItemFilho
    Local aFilhos := {}
    Local cItem := ""

    For Ni := 1 To Len(aItensPedido)

        oItem := aItensPedido[Ni]

        //Identifica que é o mesmo item
        If AllTrim(cValToChar(oItem:id)) == AllTrim(cIdItemCheckout)
            
            //Se é item pai, tem que pegar dos filhos
            If !oItem:ultimoNivel
                aFilhos := ::getChildrenItems(AllTrim(cValToChar(oItem:id)))

                If Len(aFilhos) > 0
                    oItemFilho := aFilhos[1]
                    Return cValToChar(oItemFilho:numeroPedidoOrigem)
                EndIf

            Else
                if type( "oItem:numeroPedidoOrigem" ) != "U"
                    cItem := cValToChar(oItem:numeroPedidoOrigem)
                endif
                Return cItem
            EndIf

        EndIf

        oItem := Nil

    Next

Return ""

Method getTipoVoucher() Class CheckoutRestClient

    Local cVoucher   := ::getVoucher()
    Local cTpVoucher := ""

    dbSelectArea("SZF")
    SZF->(dbSetOrder(1))
    If SZF->(dbSeek(xFilial("SZF") + cVoucher))
        cTpVoucher := SZF->ZF_TIPOVOU
    EndIf

Return cTpVoucher

Method getChildrenItems(cIdItemPai) Class CheckoutRestClient

    Local Ni := 0
    Local aItensPedido := ::oCheckout[1]:itens
    Local oItem
    Local aChildren := {}

    For Ni := 1 To Len(aItensPedido)

        oItem := aItensPedido[Ni]

        If oItem:ultimoNivel
            If cValToChar(oItem:IdItemPai) == AllTrim(cIdItemPai)
                aAdd(aChildren, oItem)
            EndIf
        EndIf

        //FreeObj(oItem)
        oItem := Nil

    Next

Return aChildren
