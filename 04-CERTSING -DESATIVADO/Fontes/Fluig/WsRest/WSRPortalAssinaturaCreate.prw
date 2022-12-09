#INCLUDE 'totvs.ch'
#INCLUDE "restful.ch"

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

WSRESTFUL WSRPortalAssinaturaCreate DESCRIPTION "Web Service de Integracao" FORMAT APPLICATION_JSON

WSDATA token  AS string OPTIONAL

WSMETHOD GET  DESCRIPTION "Retorna lista de abonos" WSSYNTAX "/WSRPortalAssinaturaCreate || /WSRPortalAssinaturaCreate/"
WSMETHOD POST DESCRIPTION "Inclui pré abono" WSSYNTAX "/WSRPortalAssinaturaCreate/{id}"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} POST
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
WSMETHOD POST WSRECEIVE token WSSERVICE WSRPortalAssinaturaCreate
	CONOUT("")
	CONOUT("----------------------------------------------------------")
	CONOUT("# CSI00012: Iniciou o WSRPortalAssinaturaCreate - POST")
	::SetContentType("application/json") // define o tipo de retorno do método
	::SetResponse( U_CSI00012( nTIPO_REQUISICAO_POST, ::GetContent(), ::token ) )
	CONOUT("# CSI00012: Encerrou o WSRPortalAssinaturaCreate - POST")
Return .T.

WSMETHOD GET WSRECEIVE token WSSERVICE WSRPortalAssinaturaCreate
	CONOUT("# CSI00012: Iniciou o WSRPortalAssinaturaCreate - GET")
	::SetContentType("application/json") // define o tipo de retorno do método
	::SetResponse( "Ok" )
	CONOUT("# CSI00012: Encerrou o WSRPortalAssinaturaCreate - GET")
Return .T.