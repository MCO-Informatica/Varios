#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.1.182:8080/HAWS/services/HAWSProviderService?wsdl
Gerado em        11/04/11 10:55:10
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.101007
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _IJTMQNE ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSHAWSProviderService
------------------------------------------------------------------------------- */

WSCLIENT WSHAWSProviderService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD atualizaProdutos
	WSMETHOD notificaFalhaPagamentoCartao
	WSMETHOD notificaStatusPedidos
	WSMETHOD atualizaVoucher

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   cxml                      AS string
	WSDATA   creturn                   AS string
	WSDATA   narray                    AS long

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSHAWSProviderService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.101202A-20110106] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSHAWSProviderService
Return

WSMETHOD RESET WSCLIENT WSHAWSProviderService
	::cxml               := NIL 
	::creturn            := NIL 
	::narray             := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSHAWSProviderService
Local oClone := WSHAWSProviderService():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:cxml          := ::cxml
	oClone:creturn       := ::creturn
	oClone:narray        := ::narray
Return oClone

// WSDL Method atualizaProdutos of Service WSHAWSProviderService

WSMETHOD atualizaProdutos WSSEND cxml WSRECEIVE creturn WSCLIENT WSHAWSProviderService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<atualizaProdutos xmlns="http://provider.haws.certisign.opvs.com.br">'
cSoap += WSSoapValue("xml", ::cxml, cxml , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += "</atualizaProdutos>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:atualizaProdutos",; 
	"DOCUMENT","http://provider.haws.certisign.opvs.com.br",,,; 
	"http://192.168.1.182:8080/HAWS/services/HAWSProviderService.HAWSProviderServiceHttpSoap11Endpoint/")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_ATUALIZAPRODUTOSRESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method notificaFalhaPagamentoCartao of Service WSHAWSProviderService

WSMETHOD notificaFalhaPagamentoCartao WSSEND narray WSRECEIVE creturn WSCLIENT WSHAWSProviderService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<notificaFalhaPagamentoCartao xmlns="http://provider.haws.certisign.opvs.com.br">'
cSoap += WSSoapValue("array", ::narray, narray , "long", .F. , .F., 0 , NIL, .T.) 
cSoap += "</notificaFalhaPagamentoCartao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:notificaFalhaPagamentoCartao",; 
	"DOCUMENT","http://provider.haws.certisign.opvs.com.br",,,; 
	"http://192.168.1.182:8080/HAWS/services/HAWSProviderService.HAWSProviderServiceHttpSoap11Endpoint/")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_NOTIFICAFALHAPAGAMENTOCARTAORESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method notificaStatusPedidos of Service WSHAWSProviderService

WSMETHOD notificaStatusPedidos WSSEND cxml WSRECEIVE creturn WSCLIENT WSHAWSProviderService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<notificaStatusPedidos xmlns="http://provider.haws.certisign.opvs.com.br">'
cSoap += WSSoapValue("xml", ::cxml, cxml , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += "</notificaStatusPedidos>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:notificaStatusPedidos",; 
	"DOCUMENT","http://provider.haws.certisign.opvs.com.br",,,; 
	"http://192.168.1.182:8080/HAWS/services/HAWSProviderService.HAWSProviderServiceHttpSoap11Endpoint/")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_NOTIFICASTATUSPEDIDOSRESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method atualizaVoucher of Service WSHAWSProviderService

WSMETHOD atualizaVoucher WSSEND cxml WSRECEIVE creturn WSCLIENT WSHAWSProviderService
Local cSoap		:= ""
Local oXmlRet
Local cXWSVEVA	:= GetNewPar("MV_XWSVEVA", "http://192.168.1.182:8080/HAWS/services/HAWSProviderService.HAWSProviderServiceHttpSoap11Endpoint/")

BEGIN WSMETHOD

cSoap += '<o:atualizaVoucher xmlns:o="http://provider.haws.certisign.opvs.com.br">'
cSoap += WSSoapValue("xml", ::cxml, cxml , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += "</o:atualizaVoucher>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:atualizaVoucher",; 
	"DOCUMENT","http://provider.haws.certisign.opvs.com.br",,,; 
	cXWSVEVA)

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_NS2_ATUALIZAVOUCHERRESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.
