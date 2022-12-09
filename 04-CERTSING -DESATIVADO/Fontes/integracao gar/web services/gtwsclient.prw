#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    \VTexServiceBus.txt 
Gerado em        12/21/09 22:30:29
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.090116
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _QXSJLRN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSServiceBus
------------------------------------------------------------------------------- */

WSCLIENT WSServiceBus

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD NotifyOrderEvent
	WSMETHOD GetUrisToInvoice
	WSMETHOD CapturePaymentRequest

	WSDATA   _URL                      AS String
	WSDATA   oWSorderEvent             AS ServiceBus_OrderEvent
	WSDATA   oWSNotifyOrderEventResult AS ServiceBus_SRMOfOrderERP81wDH
	WSDATA   corderId                  AS string
	WSDATA   cdocumentNumber           AS string
	WSDATA   oWSGetUrisToInvoiceResult AS ServiceBus_SRMOfInvoicesERP81wDH
	WSDATA   cnumPedido                AS string
	WSDATA   cstatus                   AS string
	WSDATA   ccodPagamento             AS string
	WSDATA   cCapturePaymentRequestResult AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSServiceBus
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20090121] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSServiceBus
	::oWSorderEvent      := ServiceBus_ORDEREVENT():New()
	::oWSNotifyOrderEventResult := ServiceBus_SRMOFORDERERP81WDH():New()
	::oWSGetUrisToInvoiceResult := ServiceBus_SRMOFINVOICESERP81WDH():New()
Return

WSMETHOD RESET WSCLIENT WSServiceBus
	::oWSorderEvent      := NIL 
	::oWSNotifyOrderEventResult := NIL 
	::corderId           := NIL 
	::cdocumentNumber    := NIL 
	::oWSGetUrisToInvoiceResult := NIL 
	::cnumPedido         := NIL 
	::cstatus            := NIL 
	::ccodPagamento      := NIL 
	::cCapturePaymentRequestResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSServiceBus
Local oClone := WSServiceBus():New()
	oClone:_URL          := ::_URL 
	oClone:oWSorderEvent :=  IIF(::oWSorderEvent = NIL , NIL ,::oWSorderEvent:Clone() )
	oClone:oWSNotifyOrderEventResult :=  IIF(::oWSNotifyOrderEventResult = NIL , NIL ,::oWSNotifyOrderEventResult:Clone() )
	oClone:corderId      := ::corderId
	oClone:cdocumentNumber := ::cdocumentNumber
	oClone:oWSGetUrisToInvoiceResult :=  IIF(::oWSGetUrisToInvoiceResult = NIL , NIL ,::oWSGetUrisToInvoiceResult:Clone() )
	oClone:cnumPedido    := ::cnumPedido
	oClone:cstatus       := ::cstatus
	oClone:ccodPagamento := ::ccodPagamento
	oClone:cCapturePaymentRequestResult := ::cCapturePaymentRequestResult
Return oClone

// WSDL Method NotifyOrderEvent of Service WSServiceBus

WSMETHOD NotifyOrderEvent WSSEND oWSorderEvent WSRECEIVE oWSNotifyOrderEventResult WSCLIENT WSServiceBus
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<NotifyOrderEvent xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("orderEvent", ::oWSorderEvent, oWSorderEvent , "OrderEvent", .F. , .F., 0 , NIL, .F.) 
cSoap += "</NotifyOrderEvent>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IServiceBus/NotifyOrderEvent",; 
	"DOCUMENT","http://schemas.datacontract.org/2004/07/Vtex.Practices.ServiceBus.ValueObjects",,,; 
	"http://10.100.0.11:8000/VTexServiceBus")

::Init()
::oWSNotifyOrderEventResult:SoapRecv( WSAdvValue( oXmlRet,"_NOTIFYORDEREVENTRESPONSE:_NOTIFYORDEREVENTRESULT","SRMOfOrderERP81wDH",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetUrisToInvoice of Service WSServiceBus

WSMETHOD GetUrisToInvoice WSSEND corderId,cdocumentNumber WSRECEIVE oWSGetUrisToInvoiceResult WSCLIENT WSServiceBus
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetUrisToInvoice xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("orderId", ::corderId, corderId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("documentNumber", ::cdocumentNumber, cdocumentNumber , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</GetUrisToInvoice>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IServiceBus/GetUrisToInvoice",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://10.100.0.11:8000/VTexServiceBus")

::Init()
::oWSGetUrisToInvoiceResult:SoapRecv( WSAdvValue( oXmlRet,"_GETURISTOINVOICERESPONSE:_GETURISTOINVOICERESULT","SRMOfInvoicesERP81wDH",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CapturePaymentRequest of Service WSServiceBus

WSMETHOD CapturePaymentRequest WSSEND cnumPedido,cstatus,ccodPagamento WSRECEIVE cCapturePaymentRequestResult WSCLIENT WSServiceBus
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CapturePaymentRequest xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("numPedido", ::cnumPedido, cnumPedido , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("status", ::cstatus, cstatus , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("codPagamento", ::ccodPagamento, ccodPagamento , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</CapturePaymentRequest>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IServiceBus/CapturePaymentRequest",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://10.100.0.11:8000/VTexServiceBus")

::Init()
::cCapturePaymentRequestResult :=  WSAdvValue( oXmlRet,"_CAPTUREPAYMENTREQUESTRESPONSE:_CAPTUREPAYMENTREQUESTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure OrderEvent

WSSTRUCT ServiceBus_OrderEvent
	WSDATA   oWSEventArgsService       AS ServiceBus_EventArgsService OPTIONAL
	WSDATA   oWSOrder                  AS ServiceBus_Order OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ServiceBus_OrderEvent
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ServiceBus_OrderEvent
Return

WSMETHOD CLONE WSCLIENT ServiceBus_OrderEvent
	Local oClone := ServiceBus_OrderEvent():NEW()
	oClone:oWSEventArgsService  := IIF(::oWSEventArgsService = NIL , NIL , ::oWSEventArgsService:Clone() )
	oClone:oWSOrder             := IIF(::oWSOrder = NIL , NIL , ::oWSOrder:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT ServiceBus_OrderEvent
	Local cSoap := ""
	cSoap += WSSoapValue("EventArgsService", ::oWSEventArgsService, ::oWSEventArgsService , "EventArgsService", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Order", ::oWSOrder, ::oWSOrder , "Order", .F. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure SRMOfOrderERP81wDH

WSSTRUCT ServiceBus_SRMOfOrderERP81wDH
	WSDATA   oWSDocument               AS ServiceBus_Order OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ServiceBus_SRMOfOrderERP81wDH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ServiceBus_SRMOfOrderERP81wDH
Return

WSMETHOD CLONE WSCLIENT ServiceBus_SRMOfOrderERP81wDH
	Local oClone := ServiceBus_SRMOfOrderERP81wDH():NEW()
	oClone:oWSDocument          := IIF(::oWSDocument = NIL , NIL , ::oWSDocument:Clone() )
Return oClone

//WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ServiceBus_SRMOfOrderERP81wDH
//	Local oNode1
//	::Init()
//	If oResponse = NIL ; Return ; Endif 
//	oNode1 :=  WSAdvValue( oResponse,"_DOCUMENT","Order",NIL,NIL,NIL,"O",NIL,NIL) 
//	If oNode1 != NIL
//		::oWSDocument := ServiceBus_Order():New()
//		::oWSDocument:SoapRecv(oNode1)
//	EndIf
//Return

// WSDL Data Structure SRMOfInvoicesERP81wDH

WSSTRUCT ServiceBus_SRMOfInvoicesERP81wDH
	WSDATA   oWSDocument               AS ServiceBus_Invoices OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ServiceBus_SRMOfInvoicesERP81wDH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ServiceBus_SRMOfInvoicesERP81wDH
Return

WSMETHOD CLONE WSCLIENT ServiceBus_SRMOfInvoicesERP81wDH
	Local oClone := ServiceBus_SRMOfInvoicesERP81wDH():NEW()
	oClone:oWSDocument          := IIF(::oWSDocument = NIL , NIL , ::oWSDocument:Clone() )
Return oClone

//WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ServiceBus_SRMOfInvoicesERP81wDH
//	Local oNode1
//	::Init()
//	If oResponse = NIL ; Return ; Endif 
//	oNode1 :=  WSAdvValue( oResponse,"_DOCUMENT","Invoices",NIL,NIL,NIL,"O",NIL,NIL) 
//	If oNode1 != NIL
//		::oWSDocument := ServiceBus_Invoices():New()
//		::oWSDocument:SoapRecv(oNode1)
//	EndIf
//Return

// WSDL Data Structure EventArgsService

WSSTRUCT ServiceBus_EventArgsService
	WSDATA   nAttemptsProcessing       AS int OPTIONAL
	WSDATA   cEvent                    AS string OPTIONAL
	WSDATA   cEventCode                AS string OPTIONAL
	WSDATA   cEventData                AS string OPTIONAL
	WSDATA   cEventDateTime            AS dateTime OPTIONAL
	WSDATA   cLastTry                  AS dateTime OPTIONAL
	WSDATA   cSender                   AS string OPTIONAL
	WSDATA   cTraceError               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ServiceBus_EventArgsService
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ServiceBus_EventArgsService
Return

WSMETHOD CLONE WSCLIENT ServiceBus_EventArgsService
	Local oClone := ServiceBus_EventArgsService():NEW()
	oClone:nAttemptsProcessing  := ::nAttemptsProcessing
	oClone:cEvent               := ::cEvent
	oClone:cEventCode           := ::cEventCode
	oClone:cEventData           := ::cEventData
	oClone:cEventDateTime       := ::cEventDateTime
	oClone:cLastTry             := ::cLastTry
	oClone:cSender              := ::cSender
	oClone:cTraceError          := ::cTraceError
Return oClone

WSMETHOD SOAPSEND WSCLIENT ServiceBus_EventArgsService
	Local cSoap := ""
	cSoap += WSSoapValue("AttemptsProcessing", ::nAttemptsProcessing, ::nAttemptsProcessing , "int", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Event", ::cEvent, ::cEvent , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("EventCode", ::cEventCode, ::cEventCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("EventData", ::cEventData, ::cEventData , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("EventDateTime", ::cEventDateTime, ::cEventDateTime , "dateTime", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("LastTry", ::cLastTry, ::cLastTry , "dateTime", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Sender", ::cSender, ::cSender , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("TraceError", ::cTraceError, ::cTraceError , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure Order

WSSTRUCT ServiceBus_Order
	WSDATA   cInvoices                 AS string OPTIONAL
	WSDATA   cOrderData                AS string OPTIONAL
	WSDATA   cOrderId                  AS string OPTIONAL
	WSDATA   cOrderItems               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ServiceBus_Order
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ServiceBus_Order
Return

WSMETHOD CLONE WSCLIENT ServiceBus_Order
	Local oClone := ServiceBus_Order():NEW()
	oClone:cInvoices            := ::cInvoices
	oClone:cOrderData           := ::cOrderData
	oClone:cOrderId             := ::cOrderId
	oClone:cOrderItems          := ::cOrderItems
Return oClone

WSMETHOD SOAPSEND WSCLIENT ServiceBus_Order
	Local cSoap := ""
	cSoap += WSSoapValue("Invoices", ::cInvoices, ::cInvoices , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("OrderData", ::cOrderData, ::cOrderData , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("OrderId", ::cOrderId, ::cOrderId , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("OrderItems", ::cOrderItems, ::cOrderItems , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap

//WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ServiceBus_Order
//	::Init()
//	If oResponse = NIL ; Return ; Endif 
//	::cInvoices          :=  WSAdvValue( oResponse,"_INVOICES","string",NIL,NIL,NIL,"S",NIL,NIL) 
//	::cOrderData         :=  WSAdvValue( oResponse,"_ORDERDATA","string",NIL,NIL,NIL,"S",NIL,NIL) 
//	::cOrderId           :=  WSAdvValue( oResponse,"_ORDERID","string",NIL,NIL,NIL,"S",NIL,NIL) 
//	::cOrderItems        :=  WSAdvValue( oResponse,"_ORDERITEMS","string",NIL,NIL,NIL,"S",NIL,NIL) 
//Return

// WSDL Data Structure Invoices

WSSTRUCT ServiceBus_Invoices
	WSDATA   cXmlInvoices              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ServiceBus_Invoices
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ServiceBus_Invoices
Return

WSMETHOD CLONE WSCLIENT ServiceBus_Invoices
	Local oClone := ServiceBus_Invoices():NEW()
	oClone:cXmlInvoices         := ::cXmlInvoices
Return oClone

//WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ServiceBus_Invoices
//	::Init()
//	If oResponse = NIL ; Return ; Endif 
//	::cXmlInvoices       :=  WSAdvValue( oResponse,"_XMLINVOICES","string",NIL,NIL,NIL,"S",NIL,NIL) 
//Return

	
