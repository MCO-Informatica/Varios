#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx?wsdl
Gerado em        12/26/17 09:50:20
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _IWRTAVO ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNFeDistribuicaoDFe
------------------------------------------------------------------------------- */

WSCLIENT WSNFeDistribuicaoDFe

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeDistDFeInteresse

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSnfeDadosMsg            AS SCHEMA
	WSDATA   oWSnfeDistDFeInteresseResult AS SCHEMA

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNFeDistribuicaoDFe
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20171107 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNFeDistribuicaoDFe
	::oWSnfeDadosMsg     := NIL 
	::oWSnfeDistDFeInteresseResult := NIL 
Return

WSMETHOD RESET WSCLIENT WSNFeDistribuicaoDFe
	::oWSnfeDadosMsg     := NIL 
	::oWSnfeDistDFeInteresseResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNFeDistribuicaoDFe
Local oClone := WSNFeDistribuicaoDFe():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
Return oClone

// WSDL Method nfeDistDFeInteresse of Service WSNFeDistribuicaoDFe

WSMETHOD nfeDistDFeInteresse WSSEND oWSnfeDadosMsg WSRECEIVE oWSnfeDistDFeInteresseResult WSCLIENT WSNFeDistribuicaoDFe
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<nfeDistDFeInteresse xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe">'
cSoap += WSSoapValue("nfeDadosMsg", ::oWSnfeDadosMsg, oWSnfeDadosMsg , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</nfeDistDFeInteresse>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe/nfeDistDFeInteresse",; 
	"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe",,,; 
	"https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx")

::Init()
::oWSnfeDistDFeInteresseResult :=  WSAdvValue( oXmlRet,"_NFEDISTDFEINTERESSERESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



