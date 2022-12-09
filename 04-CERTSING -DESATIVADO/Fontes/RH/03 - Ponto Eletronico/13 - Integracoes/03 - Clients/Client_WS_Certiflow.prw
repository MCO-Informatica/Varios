#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://172.22.4.161:205/WsCertiflow/FluxosExternos.asmx?WSDL
Gerado em        12/12/17 14:32:17
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _FGOWZKK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSFluxosExternos
------------------------------------------------------------------------------- */

WSCLIENT WSFluxosExternos

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD UserAuthenticate
	WSMETHOD StartFlowByHtml
	WSMETHOD StartFlowUploadingFile
	WSMETHOD FlowDetails
	WSMETHOD FlowStatus
	WSMETHOD ConsultReceivedExternalAction
	WSMETHOD FinalizeFlow

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cUserAuthenticateResult   AS string
	WSDATA   cexternalProcessCode      AS string
	WSDATA   cauthenticateToken        AS string
	WSDATA   cflowCode                 AS string
	WSDATA   cStartFlowByHtmlResult    AS string
	WSDATA   oWSparameters             AS FluxosExternos_ArrayOfString
	WSDATA   cStartFlowUploadingFileResult AS string
	WSDATA   cflowInstanceCode         AS string
	WSDATA   cFlowDetailsResult        AS string
	WSDATA   cFlowStatusResult         AS string
	WSDATA   cConsultReceivedExternalActionResult AS string
	WSDATA   cFinalizeFlowResult       AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSFluxosExternos
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20170519 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSFluxosExternos
	::oWSparameters      := FluxosExternos_ARRAYOFSTRING():New()
Return

WSMETHOD RESET WSCLIENT WSFluxosExternos
	::cUserAuthenticateResult := NIL 
	::cexternalProcessCode := NIL 
	::cauthenticateToken := NIL 
	::cflowCode          := NIL 
	::cStartFlowByHtmlResult := NIL 
	::oWSparameters      := NIL 
	::cStartFlowUploadingFileResult := NIL 
	::cflowInstanceCode  := NIL 
	::cFlowDetailsResult := NIL 
	::cFlowStatusResult  := NIL 
	::cConsultReceivedExternalActionResult := NIL 
	::cFinalizeFlowResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSFluxosExternos
Local oClone := WSFluxosExternos():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:cUserAuthenticateResult := ::cUserAuthenticateResult
	oClone:cexternalProcessCode := ::cexternalProcessCode
	oClone:cauthenticateToken := ::cauthenticateToken
	oClone:cflowCode     := ::cflowCode
	oClone:cStartFlowByHtmlResult := ::cStartFlowByHtmlResult
	oClone:oWSparameters :=  IIF(::oWSparameters = NIL , NIL ,::oWSparameters:Clone() )
	oClone:cStartFlowUploadingFileResult := ::cStartFlowUploadingFileResult
	oClone:cflowInstanceCode := ::cflowInstanceCode
	oClone:cFlowDetailsResult := ::cFlowDetailsResult
	oClone:cFlowStatusResult := ::cFlowStatusResult
	oClone:cConsultReceivedExternalActionResult := ::cConsultReceivedExternalActionResult
	oClone:cFinalizeFlowResult := ::cFinalizeFlowResult
Return oClone

// WSDL Method UserAuthenticate of Service WSFluxosExternos

WSMETHOD UserAuthenticate WSSEND NULLPARAM WSRECEIVE cUserAuthenticateResult WSCLIENT WSFluxosExternos
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD
conout("Inicio metodo UserAuthenticate certiflow")
cSoap += '<UserAuthenticate xmlns="http://tempuri.org/">'
cSoap += "</UserAuthenticate>"

conout("chamada do SvcSoapCall")
conout("link: https://172.22.4.161:205/WsCertiflow/FluxosExternos.asmx")
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UserAuthenticate",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://172.22.4.161:205/WsCertiflow/FluxosExternos.asmx")
	conout("fim da chamada  SvcSoapCall")
	varinfo("oXmlRet", oXmlRet)
::Init()
::cUserAuthenticateResult :=  WSAdvValue( oXmlRet,"_USERAUTHENTICATERESPONSE:_USERAUTHENTICATERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 
varinfo("self", self)
conout("fim metodo UserAuthenticate certiflow")
END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method StartFlowByHtml of Service WSFluxosExternos

WSMETHOD StartFlowByHtml WSSEND cexternalProcessCode,cauthenticateToken,cflowCode WSRECEIVE cStartFlowByHtmlResult WSCLIENT WSFluxosExternos
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<StartFlowByHtml xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("externalProcessCode", ::cexternalProcessCode, cexternalProcessCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("authenticateToken", ::cauthenticateToken, cauthenticateToken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("flowCode", ::cflowCode, cflowCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</StartFlowByHtml>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/StartFlowByHtml",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://172.22.4.161:205/WsCertiflow/FluxosExternos.asmx")

::Init()
::cStartFlowByHtmlResult :=  WSAdvValue( oXmlRet,"_STARTFLOWBYHTMLRESPONSE:_STARTFLOWBYHTMLRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method StartFlowUploadingFile of Service WSFluxosExternos

WSMETHOD StartFlowUploadingFile WSSEND cauthenticateToken,cflowCode,oWSparameters WSRECEIVE cStartFlowUploadingFileResult WSCLIENT WSFluxosExternos
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<StartFlowUploadingFile xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("authenticateToken", ::cauthenticateToken, cauthenticateToken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("flowCode", ::cflowCode, cflowCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("parameters", ::oWSparameters, oWSparameters , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</StartFlowUploadingFile>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/StartFlowUploadingFile",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://172.22.4.161:205/WsCertiflow/FluxosExternos.asmx")

::Init()
::cStartFlowUploadingFileResult :=  WSAdvValue( oXmlRet,"_STARTFLOWUPLOADINGFILERESPONSE:_STARTFLOWUPLOADINGFILERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FlowDetails of Service WSFluxosExternos

WSMETHOD FlowDetails WSSEND cauthenticateToken,cflowInstanceCode WSRECEIVE cFlowDetailsResult WSCLIENT WSFluxosExternos
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FlowDetails xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("authenticateToken", ::cauthenticateToken, cauthenticateToken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("flowInstanceCode", ::cflowInstanceCode, cflowInstanceCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FlowDetails>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/FlowDetails",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://172.22.4.161:205/WsCertiflow/FluxosExternos.asmx")

::Init()
::cFlowDetailsResult :=  WSAdvValue( oXmlRet,"_FLOWDETAILSRESPONSE:_FLOWDETAILSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FlowStatus of Service WSFluxosExternos

WSMETHOD FlowStatus WSSEND cauthenticateToken,cflowInstanceCode WSRECEIVE cFlowStatusResult WSCLIENT WSFluxosExternos
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FlowStatus xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("authenticateToken", ::cauthenticateToken, cauthenticateToken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("flowInstanceCode", ::cflowInstanceCode, cflowInstanceCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FlowStatus>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/FlowStatus",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://172.22.4.161:205/WsCertiflow/FluxosExternos.asmx")

::Init()
::cFlowStatusResult  :=  WSAdvValue( oXmlRet,"_FLOWSTATUSRESPONSE:_FLOWSTATUSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultReceivedExternalAction of Service WSFluxosExternos

WSMETHOD ConsultReceivedExternalAction WSSEND cauthenticateToken,cflowInstanceCode WSRECEIVE cConsultReceivedExternalActionResult WSCLIENT WSFluxosExternos
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultReceivedExternalAction xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("authenticateToken", ::cauthenticateToken, cauthenticateToken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("flowInstanceCode", ::cflowInstanceCode, cflowInstanceCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ConsultReceivedExternalAction>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ConsultReceivedExternalAction",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://172.22.4.161:205/WsCertiflow/FluxosExternos.asmx")

::Init()
::cConsultReceivedExternalActionResult :=  WSAdvValue( oXmlRet,"_CONSULTRECEIVEDEXTERNALACTIONRESPONSE:_CONSULTRECEIVEDEXTERNALACTIONRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FinalizeFlow of Service WSFluxosExternos

WSMETHOD FinalizeFlow WSSEND cauthenticateToken,cflowInstanceCode WSRECEIVE cFinalizeFlowResult WSCLIENT WSFluxosExternos
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FinalizeFlow xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("authenticateToken", ::cauthenticateToken, cauthenticateToken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("flowInstanceCode", ::cflowInstanceCode, cflowInstanceCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FinalizeFlow>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/FinalizeFlow",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://172.22.4.161:205/WsCertiflow/FluxosExternos.asmx")

::Init()
::cFinalizeFlowResult :=  WSAdvValue( oXmlRet,"_FINALIZEFLOWRESPONSE:_FINALIZEFLOWRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfString

WSSTRUCT FluxosExternos_ArrayOfString
	WSDATA   cstring                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FluxosExternos_ArrayOfString
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FluxosExternos_ArrayOfString
	::cstring              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT FluxosExternos_ArrayOfString
	Local oClone := FluxosExternos_ArrayOfString():NEW()
	oClone:cstring              := IIf(::cstring <> NIL , aClone(::cstring) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT FluxosExternos_ArrayOfString
	Local cSoap := ""
	aEval( ::cstring , {|x| cSoap := cSoap  +  WSSoapValue("string", x , x , "string", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap


