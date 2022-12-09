#INCLUDE 'totvs.ch'
#INCLUDE "restful.ch"

#DEFINE cKEY_ACCESS 'Ved_d3Ada&uHuwrU4OX3'
#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE 4
//-------------------------------------------------------------------
/*/{Protheus.doc} WSRESTFUL
Classe WS para testes genéricos com variedade de exempos de PATH

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------

WSRESTFUL WSRCallbackPortalAssinatura DESCRIPTION "Web Service de Integracao" FORMAT APPLICATION_JSON

WSDATA url    AS string OPTIONAL
WSDATA trigger AS string OPTIONAL
WSDATA headers AS string OPTIONAL

WSMETHOD POST DESCRIPTION "Inclui pré abono" WSSYNTAX "/WSRCallbackPortalAssinatura/"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} POST
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
WSMETHOD POST WSRECEIVE url, trigger WSSERVICE WSRCallbackPortalAssinatura
	CONOUT("# CSI00010: Iniciou o WSRCallbackPortalAssinatura - POST")
	::SetContentType("application/json") // define o tipo de retorno do método
	varinfo( "::url", ::url)
	varinfo( "::trigger", ::trigger)
	varinfo( "::GetContent()", ::GetContent()) 
	::SetResponse( U_CSI00010( nTIPO_REQUISICAO_POST, ::url, ::trigger, ::GetContent() ) )
	CONOUT("# CSI00010: Encerrou o WSRFeriasSolicitacao - POST")
Return .T.