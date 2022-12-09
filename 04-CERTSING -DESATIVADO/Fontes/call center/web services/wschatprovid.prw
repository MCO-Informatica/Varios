#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.16.10:9090/ChatProviderService/ChatProvider?wsdl
Gerado em        11/09/15 15:51:41
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _OQTNKWE ; Return  // "dummy" function - Internal Use

/* -------------------------------------------------------------------------------
WSDL Service WSChatProviderService
------------------------------------------------------------------------------- */

WSCLIENT WSChatProviderService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD tamanhoFila
	WSMETHOD enviaMensagem
	WSMETHOD encerraConversa
	WSMETHOD uploadArquivo
	WSMETHOD disponibilidadeOperador

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cgrupo                    AS string
	WSDATA   creturn                   AS string
	WSDATA   cidConversa               AS string
	WSDATA   cidGrupo                  AS string
	WSDATA   cnomeOperador             AS string
	WSDATA   cmensagem                 AS string
	WSDATA   ccodEncerramento          AS string
	WSDATA   cbase64Content            AS string
	WSDATA   cfilename                 AS string
	WSDATA   cdispOperador             AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSChatProviderService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150327] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSChatProviderService
Return

WSMETHOD RESET WSCLIENT WSChatProviderService
	::cgrupo             := NIL
	::creturn            := NIL
	::cidConversa        := NIL
	::cidGrupo			 := NIL
	::cnomeOperador      := NIL
	::cmensagem          := NIL
	::ccodEncerramento   := NIL
	::cbase64Content     := NIL
	::cfilename          := NIL
	::cdispOperador      := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSChatProviderService
Local oClone := WSChatProviderService():New()
	oClone:_URL          := ::_URL
	oClone:cgrupo        := ::cgrupo
	oClone:creturn       := ::creturn
	oClone:cidConversa   := ::cidConversa
	oClone:cidGrupo      := ::cidGrupo
	oClone:cnomeOperador := ::cnomeOperador
	oClone:cmensagem     := ::cmensagem
	oClone:ccodEncerramento := ::ccodEncerramento
	oClone:cbase64Content := ::cbase64Content
	oClone:cfilename     := ::cfilename
	oClone:cdispOperador := ::cdispOperador
Return oClone

// WSDL Method tamanhoFila of Service WSChatProviderService

WSMETHOD tamanhoFila WSSEND cgrupo WSRECEIVE creturn WSCLIENT WSChatProviderService
Local cSoap := "" , oXmlRet
Local cChatWs	:= GetNewPar("MV_CHATWS", "http://192.168.16.10:9090/ChatProviderService/ChatProvider")

BEGIN WSMETHOD

cSoap += '<tamanhoFila xmlns="http://webservice.chat.certisign.opvs.com.br/">'
cSoap += WSSoapValue("grupo", ::cgrupo, cgrupo , "string", .F. , .F., 0 , NIL, .F.)
cSoap += "</tamanhoFila>"

oXmlRet := SvcSoapCall(	Self,cSoap,;
	"",;
	"DOCUMENT","http://webservice.chat.certisign.opvs.com.br/",,,;
	cChatWs)

::Init()
//::creturn            :=  WSAdvValue( oXmlRet,"_TAMANHOFILARESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
::creturn            :=  oXmlRet:_NS2_TAMANHOFILARESPONSE:_RETURN:TEXT

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method enviaMensagem of Service WSChatProviderService

WSMETHOD enviaMensagem WSSEND cidConversa,cnomeOperador,cmensagem WSRECEIVE creturn WSCLIENT WSChatProviderService
Local cSoap := "" , oXmlRet
Local cChatWs	:= GetNewPar("MV_CHATWS", "http://192.168.16.10:9090/ChatProviderService/ChatProvider")

BEGIN WSMETHOD

cSoap += '<enviaMensagem xmlns="http://webservice.chat.certisign.opvs.com.br/">'
cSoap += WSSoapValue("idConversa", ::cidConversa, cidConversa , "string", .F. , .F., 0 , NIL, .F.)
cSoap += WSSoapValue("nomeOperador", ::cnomeOperador, cnomeOperador , "string", .F. , .F., 0 , NIL, .F.)
cSoap += WSSoapValue("mensagem", ::cmensagem, cmensagem , "string", .F. , .F., 0 , NIL, .F.)
cSoap += "</enviaMensagem>"

oXmlRet := SvcSoapCall(	Self,cSoap,;
	"",;
	"DOCUMENT","http://webservice.chat.certisign.opvs.com.br/",,,;
	cChatWs)

::Init()
//::creturn            :=  WSAdvValue( oXmlRet,"_ENVIAMENSAGEMRESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
::creturn            := oXmlRet:_NS2_ENVIAMENSAGEMRESPONSE:_RETURN:TEXT

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method encerraConversa of Service WSChatProviderService

WSMETHOD encerraConversa WSSEND cidConversa,cidGrupo,ccodEncerramento WSRECEIVE creturn WSCLIENT WSChatProviderService
Local cSoap := "" , oXmlRet
Local cChatWs	:= GetNewPar("MV_CHATWS", "http://192.168.16.10:9090/ChatProviderService/ChatProvider")

BEGIN WSMETHOD

cSoap += '<encerraConversa xmlns="http://webservice.chat.certisign.opvs.com.br/">'
cSoap += WSSoapValue("idConversa", ::cidConversa, cidConversa , "string", .F. , .F., 0 , NIL, .F.)
cSoap += WSSoapValue("idGrupo", ::cidGrupo, cidGrupo , "string", .F. , .F., 0 , NIL, .F.)
cSoap += WSSoapValue("codEncerramento", ::ccodEncerramento, ccodEncerramento , "string", .F. , .F., 0 , NIL, .F.)
cSoap += "</encerraConversa>"

oXmlRet := SvcSoapCall(	Self,cSoap,;
	"",;
	"DOCUMENT","http://webservice.chat.certisign.opvs.com.br/",,,;
	cChatWs)

::Init()
//::creturn            :=  WSAdvValue( oXmlRet,"_ENCERRACONVERSARESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
::creturn            :=  oXmlRet:_NS2_ENCERRACONVERSARESPONSE:_RETURN:TEXT

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method uploadArquivo of Service WSChatProviderService

WSMETHOD uploadArquivo WSSEND cidConversa,cbase64Content,cfilename WSRECEIVE creturn WSCLIENT WSChatProviderService
Local cSoap := "" , oXmlRet
Local cChatWs	:= GetNewPar("MV_CHATWS", "http://192.168.16.10:9090/ChatProviderService/ChatProvider")

BEGIN WSMETHOD

cSoap += '<uploadArquivo xmlns="http://webservice.chat.certisign.opvs.com.br/">'
cSoap += WSSoapValue("idConversa", ::cidConversa, cidConversa , "string", .F. , .F., 0 , NIL, .F.)
cSoap += WSSoapValue("base64Content", ::cbase64Content, cbase64Content , "string", .F. , .F., 0 , NIL, .F.)
cSoap += WSSoapValue("filename", ::cfilename, cfilename , "string", .F. , .F., 0 , NIL, .F.)
cSoap += "</uploadArquivo>"

oXmlRet := SvcSoapCall(	Self,cSoap,;
	"",;
	"DOCUMENT","http://webservice.chat.certisign.opvs.com.br/",,,;
	cChatWs)

::Init()
//::creturn            :=  WSAdvValue( oXmlRet,"_UPLOADARQUIVORESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
::creturn            :=  oXmlRet:_NS2_UPLOADARQUIVORESPONSE:_RETURN:TEXT

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method disponibilidadeOperador of Service WSChatProviderService

WSMETHOD disponibilidadeOperador WSSEND cdispOperador WSRECEIVE creturn WSCLIENT WSChatProviderService
Local cSoap := "" , oXmlRet
Local cChatWs	:= GetNewPar("MV_CHATWS", "http://192.168.16.10:9090/ChatProviderService/ChatProvider")

BEGIN WSMETHOD

cSoap += '<disponibilidadeOperador xmlns="http://webservice.chat.certisign.opvs.com.br/">'
cSoap += WSSoapValue("dispOperador", ::cdispOperador, cdispOperador , "string", .F. , .F., 0 , NIL, .F.)
cSoap += "</disponibilidadeOperador>"

oXmlRet := SvcSoapCall(	Self,cSoap,;
	"",;
	"DOCUMENT","http://webservice.chat.certisign.opvs.com.br/",,,;
	cChatWs)

::Init()
//::creturn            :=  WSAdvValue( oXmlRet,"_DISPONIBILIDADEOPERADORRESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
::creturn            :=  oXmlRet:_NS2_DISPONIBILIDADEOPERADORRESPONSE:_RETURN:TEXT

END WSMETHOD

oXmlRet := NIL
Return .T.