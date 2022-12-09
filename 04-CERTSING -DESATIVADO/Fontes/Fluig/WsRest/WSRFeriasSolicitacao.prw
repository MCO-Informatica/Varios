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

WSRESTFUL WSRFeriasSolicitacao DESCRIPTION "Web Service de Integracao" FORMAT APPLICATION_JSON

WSDATA filial    	 AS string  OPTIONAL
WSDATA matricula 	 AS string  OPTIONAL
WSDATA dBaseFerias 	 AS date    OPTIONAL
WSDATA dIniGozo 	 AS date    OPTIONAL
WSDATA dFimGozo 	 AS date    OPTIONAL
WSDATA cAbonoPec  	 AS string  OPTIONAL
WSDATA c13ParAnt  	 AS string  OPTIONAL

WSMETHOD GET  DESCRIPTION "Retorna lista de abonos" WSSYNTAX "/WSRFeriasSolicitacao || /WSRFeriasSolicitacao/"
WSMETHOD POST DESCRIPTION "Inclui pré abono" WSSYNTAX "/WSRFeriasSolicitacao/{id}"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} POST
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
WSMETHOD POST WSRECEIVE filial, matricula, dBaseFerias, dIniGozo, dFimGozo, cAbonoPec, c13ParAnt WSSERVICE WSRFeriasSolicitacao
	CONOUT("# CSI00007: Iniciou o WSRFeriasSolicitacao - POST")
	::SetContentType("application/json") // define o tipo de retorno do método
	::SetResponse( U_CSI00007( nTIPO_REQUISICAO_POST, ::filial, ::matricula, ::dBaseFerias, ::dIniGozo, ::dFimGozo, ::cAbonoPec, ::c13ParAnt ) )
	CONOUT("# CSI00007: Encerrou o WSRFeriasSolicitacao - POST")
Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} GET
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
WSMETHOD GET WSRECEIVE filial WSSERVICE WSRFeriasSolicitacao
	CONOUT("# CSI00007: Iniciou o WSRFeriasSolicitacao - GET")
	::SetContentType("application/json") // define o tipo de retorno do método
	::SetResponse( U_CSI00007( nTIPO_REQUISICAO_GET ) )
	CONOUT("# CSI00007: Encerrou o WSRFeriasSolicitacao - GET")
Return .T.