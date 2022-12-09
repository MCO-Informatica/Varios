#INCLUDE "totvs.ch"
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

WSRESTFUL WSRFuncaoDIGTE DESCRIPTION "Web Service de Integracao" FORMAT APPLICATION_JSON

WSDATA id AS string OPTIONAL

WSMETHOD GET DESCRIPTION "Retorna lista de funcoes da folha de pagamento" WSSYNTAX "/WSRFuncaoDIGTE || /WSRFuncaoDIGTE/{id}" //Não possibilita utilizar outro GET

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} GET
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
WSMETHOD GET WSRECEIVE id WSSERVICE WSRFuncaoDIGTE
	// define o tipo de retorno do método
	::SetContentType("application/json")
	::SetResponse( U_CSI00006(nTIPO_REQUISICAO_GET, ::id ) )
Return .T.
