#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://homologacao.nfe.sefaz.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx?WSDL
Gerado em        05/03/12 16:04:34
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.110315
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function NfeConsultaDest ; Return 

WSCLIENT WSNfeConsultaDest

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeConsultaNFDest

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   oWS                       AS SCHEMA
	WSDATA   oWSHead                   AS SCHEMA

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNfeConsultaDest
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.101202A-20110330] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNfeConsultaDest
	::oWS                := NIL 
Return

WSMETHOD RESET WSCLIENT WSNfeConsultaDest
	::oWS                := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNfeConsultaDest
Local oClone := WSNfeConsultaDest():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
Return oClone

// WSDL Method nfeConsultaNFDest of Service WSNfeConsultaDest

WSMETHOD nfeConsultaNFDest WSSEND BYREF oWS, BYREF oWSHead WSRECEIVE NULLPARAM WSCLIENT WSNfeConsultaDest
Local cSoap := "" , cSoapHead := "" , oXmlRet
Local cSave := GetSrvProfString("SPED_SAVEWSDL"," ")
Local lGrava := "&" $ cSave .Or. "1" $ cSave

WSDLSaveXML(lGrava)

BEGIN WSMETHOD

cSoap += '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest">'
cSoap += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += "</nfeDadosMsg>"

cSoapHead += '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest">'
cSoapHead += WSSoapValue("", ::oWSHead, oWSHead , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoapHead += "</nfeCabecMsg>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest",; 
	"DOCUMENTSOAP12","http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest",cSoapHead,,; 
	"https://homologacao.nfe.sefaz.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx")

::Init()
::oWS                :=  WSAdvValue( oXmlRet,"_NFECONSULTANFDESTRESULT","SCHEMA",NIL,NIL,NIL,"O",@oWS,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



