#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://10.100.0.59:8080/VVHub/VVHubService?wsdl
Gerado em        06/14/12 21:06:07
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.110425
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _ZFHOSBQ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSVVHubServiceService
------------------------------------------------------------------------------- */

WSCLIENT WSVVHubServiceService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD consultaCartao
	WSMETHOD listCategories
	WSMETHOD sendMessage

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   nchave                    AS long
	WSDATA   ccartao                   AS string
	WSDATA   cvalid                    AS string
	WSDATA   ccodSeg                   AS string
	WSDATA   cConsultaCartaoResponse   AS string
	WSDATA   cListCategoriesResponse   AS string
	WSDATA   ccategory                 AS string
	WSDATA   cdocument                 AS string
	WSDATA   cSendMessageResponse      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSVVHubServiceService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.111010P-20111220] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSVVHubServiceService
Return

WSMETHOD RESET WSCLIENT WSVVHubServiceService
	::nchave             := NIL 
	::ccartao            := NIL 
	::cvalid             := NIL 
	::ccodSeg            := NIL 
	::cConsultaCartaoResponse := NIL 
	::cListCategoriesResponse := NIL 
	::ccategory          := NIL 
	::cdocument          := NIL 
	::cSendMessageResponse := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSVVHubServiceService
Local oClone := WSVVHubServiceService():New()
	oClone:_URL          := ::_URL 
	oClone:nchave        := ::nchave
	oClone:ccartao       := ::ccartao
	oClone:cvalid        := ::cvalid
	oClone:ccodSeg       := ::ccodSeg
	oClone:cConsultaCartaoResponse := ::cConsultaCartaoResponse
	oClone:cListCategoriesResponse := ::cListCategoriesResponse
	oClone:ccategory     := ::ccategory
	oClone:cdocument     := ::cdocument
	oClone:cSendMessageResponse := ::cSendMessageResponse
Return oClone

// WSDL Method consultaCartao of Service WSVVHubServiceService

WSMETHOD consultaCartao WSSEND nchave,ccartao,cvalid,ccodSeg WSRECEIVE cConsultaCartaoResponse WSCLIENT WSVVHubServiceService
Local cSoap := "" , oXmlRet
Local cXWSHUB	:= GetNewPar("MV_XWSHUB", "http://10.100.0.59:8080/VVHub/VVHubService")

BEGIN WSMETHOD

cSoap += '<consultaCartao xmlns="http://hub.certisign.opvs.com.br/vvhub">'
cSoap += WSSoapValue("chave", ::nchave, nchave , "long", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("cartao", ::ccartao, ccartao , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("valid", ::cvalid, cvalid , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("codSeg", ::ccodSeg, ccodSeg , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</consultaCartao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://hub.certisign.opvs.com.br/vvhub/consultaCartao",; 
	"DOCUMENT","http://hub.certisign.opvs.com.br/vvhub",,,; 
	cXWSHUB)

::Init()
::cConsultaCartaoResponse :=  WSAdvValue( oXmlRet,"_CONSULTACARTAORESPONSE:_CONSULTACARTAORESPONSE:TEXT","string",NIL,NIL,NIL,NIL,NIL,"tns") 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method listCategories of Service WSVVHubServiceService

WSMETHOD listCategories WSSEND NULLPARAM WSRECEIVE cListCategoriesResponse WSCLIENT WSVVHubServiceService
Local cSoap := "" , oXmlRet
Local cXWSHUB	:= GetNewPar("MV_XWSHUB", "http://10.100.0.59:8080/VVHub/VVHubService")

BEGIN WSMETHOD

cSoap += '<listCategories xmlns="http://hub.certisign.opvs.com.br/vvhub">'
cSoap += "</listCategories>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://hub.certisign.opvs.com.br/vvhub/listCategories",; 
	"DOCUMENT","http://hub.certisign.opvs.com.br/vvhub",,,; 
	cXWSHUB)

::Init()
::cListCategoriesResponse :=  WSAdvValue( oXmlRet,"_LISTCATEGORIESRESPONSE:_LISTCATEGORIESRESPONSE:TEXT","string",NIL,NIL,NIL,NIL,NIL,"tns") 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method sendMessage of Service WSVVHubServiceService

WSMETHOD sendMessage WSSEND ccategory,cdocument WSRECEIVE cSendMessageResponse WSCLIENT WSVVHubServiceService
Local cSoap := "" , oXmlRet
Local cXWSHUB	:= GetNewPar("MV_XWSHUB", "http://10.100.0.59:8080/VVHub/VVHubService")

BEGIN WSMETHOD

cSoap += '<o:sendMessage xmlns:o="http://hub.certisign.opvs.com.br/vvhub">'
cSoap += WSSoapValue("category", ::ccategory, ccategory , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("document", ::cdocument, cdocument , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</o:sendMessage>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://hub.certisign.opvs.com.br/vvhub/sendMessage",; 
	"DOCUMENT","http://hub.certisign.opvs.com.br/vvhub",,,; 
	cXWSHUB)

::Init()
::cSendMessageResponse :=  WSAdvValue( oXmlRet,"_NS2_SENDMESSAGERESPONSE:_SENDMESSAGERESPONSE:TEXT","string",NIL,NIL,NIL,NIL,NIL,"tns") 

END WSMETHOD

oXmlRet := NIL
Return .T.