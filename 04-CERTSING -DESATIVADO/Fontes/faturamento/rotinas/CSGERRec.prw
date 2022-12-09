#INCLUDE "PROTHEUS.CH"
#DEFINE XML_VERSION '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

Static __Shop := {"ISHOPL_INDEFINIDO","ISHOPL_TEF","ISHOPL_BOLETO","ISHOPL_ITAUCARD","BB_INDEFINIDO","BB_TEF","ONEBUY"}
//+-------------------------------------------------------------------+
//| Rotina | CSGerRec | Autor | Rafael Beghini | Data | 31/07/2019 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para reenviar o recibo de pagamento
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSGerRec()
    Local aSAY  := {'Rotina para reenviar o Recibo de pagamento do pedido','Pesquisa efetuada pelo número PEDIDO SITE','','Clique em OK para prosseguir...'}
    Local aBTN  := {}
    Local aPAR  := {}
    Local aRET  := {}
    Local cMsg  := ''
    Local nOpc  := 0

    Private cTitulo := '[CSGerRec] - Reenvio de recibo'
    
    aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch( cTitulo, aSAY, aBTN )

    IF nOpc == 1
        aAdd( aPAR, {9, "Informe o pedido Site",200,7,.T.})
	    aAdd( aPAR, {1, "Número", Space(10), "","",""   ,"",0,.T.})

        IF ParamBox( aPAR, cTitulo, @aRET )
            DbSelectArea("SC5")
			DbOrderNickName("PEDSITE")
			IF SC5->( DbSeek( xFilial("SC5") + aRET[2] ) )
                cMsg := 'Re-envio Recibo via rotina manual CSGerRec'
                IF SC5->C5_TIPMOV <> '2'
                    FwMsgRun(, {|| U_VNDA481( { SC5->(RecNo()) }, NIL, cMsg ) },cTitulo,'Aguarde, reenviando o recibo...')
                Else
                    FwMsgRun(, {|| U_CSRecibo( aRET[2] ) },cTitulo,'Aguarde, reenviando o recibo...')
                EndIF
            Else
                MsgStop( 'Pedido Site' + aRET[2] + ' não localizado no ERP', cTitulo )
            EndIF
        Else
            MsgInfo('Processo cancelado',cTitulo)
        EndIF
    EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | CSRecibo | Autor | Rafael Beghini | Data | 31/07/2019 
//+-------------------------------------------------------------------+
//| Descr. | Monta o Xml e chama o VNDA262
//|        | Definida como User para ser chamada via JOB
//+-------------------------------------------------------------------+
User Function CSRecibo( cPedSite )
    Local cNumCart	:= ''
    Local cDocCar 	:= ''
    Local cDocAut 	:= ''
    Local cCodConf	:= ''
    Local cTipShop	:= ''
    Local cResponse := ''
    Local cXml      := ''
    Local cMsg      := ''
    Local aRet      := {}
    Local lRet      := .F.

    Private cError  := ''
    Private cWarning := ''

    DbSelectArea("SC5")
	DbOrderNickName("PEDSITE")
	IF SC5->( DbSeek( xFilial("SC5") + cPedSite ) )
        IF !Empty( SC5->C5_XTIDCC ) .And. !Empty( SC5->C5_XCODAUT )
        
            cNumCart := SC5->C5_XNUMCAR // Numero do cartao de credito
            cDocCar  := SC5->C5_XDOCUME // Docmumento
            cDocAut  := SC5->C5_XCODAUT // Autorizacao
            cCodConf := SC5->C5_XTIDCC  // Codigo de confirmacao ou TID
            cTipShop := SC5->C5_XITAUSP // Tipo itau ShopLine
            cTagTipo := '0'

            If Val(cTipShop)> 0 .and. Val(cTipShop) <= Len( __Shop )
                cTagTipo := __Shop[val(cTipShop)]
            Endif

            cXml :='<notificaProcessamentoCartao>'
            cXml +='  <pedido>'
            cXml +='    <numero>'+cPedSite+'</numero>'
            cXml +='  </pedido>'
            cXml +='  <confirmacao>'
            cXml +='    <tipo>'+cTagTipo+'</tipo>'
            cXml +='    <cartao>'+cNumCart+'</cartao>'
            cXml +='    <documento>'+cDocCar+'</documento>'
            cXml +='    <codigoConfirmacao>'+cCodConf+'</codigoConfirmacao>'
            cXml +='    <autorizacao>'+cDocAut+'</autorizacao>'
            cXml +='  </confirmacao>'
            cXml +='</notificaProcessamentoCartao>'

            //U_GTPutIN(cID,"A",cPedLog,.T.,{"updateFormaPag",cPedLog,SC5->C5_NUM, cXml},cXNPSite,{cNumCart,cLinDig,cNumvou},aXmlCC)

            aRet := U_Vnda262(cPedSite,cXml,@cResponse, @cError, @cWarning)
            lRet := aRet[1]
            cMsg := aRet[2]
            MsgInfo( cMsg, 'CSRecibo' )
        Else
            MsgAlert( 'O pedido ' + cPedSite + ' não possio código de autorização e número TIT, processo encerrado.', 'CSRecibo' )
        Endif
    EndIF
Return