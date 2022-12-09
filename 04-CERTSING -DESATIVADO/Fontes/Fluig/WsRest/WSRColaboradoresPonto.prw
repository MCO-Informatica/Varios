#INCLUDE 'totvs.ch'
#INCLUDE "restful.ch"

#xtranslate @{Param <n>} => ::aURLParms\[ <n> \]

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

WSRESTFUL WSRColaboradoresPonto DESCRIPTION "Web Service de Integracao" FORMAT APPLICATION_JSON

//WSMETHOD GET  DESCRIPTION "Retorna lista de abonos" WSSYNTAX "/WSRColaboradoresPonto || /WSRColaboradoresPonto/"
WSMETHOD GET DESCRIPTION  "Lista de colaboradores que batem ponto"  WsSyntax "/GET/{method}"
//WSMETHOD POST DESCRIPTION "Inclui pré abono" WSSYNTAX "/WSRColaboradoresPonto/{id}"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} POST
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
/*
WSMETHOD POST WSRECEIVE filial, matricula, dBaseFerias, dIniGozo, dFimGozo, cAbonoPec, c13ParAnt WSSERVICE WSRColaboradoresPonto
	CONOUT("# CSI00008: Iniciou o WSRColaboradoresPonto - POST")
	::SetContentType("application/json") // define o tipo de retorno do método
	::SetResponse( U_CSI00008( nTIPO_REQUISICAO_POST, ::filial, ::matricula, ::dBaseFerias, ::dIniGozo, ::dFimGozo, ::cAbonoPec, ::c13ParAnt ) )
	CONOUT("# CSI00008: Encerrou o WSRColaboradoresPonto - POST")
Return .T.
*/

//-------------------------------------------------------------------
/*/{Protheus.doc} GET
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
WSMETHOD GET WSSERVICE WSRColaboradoresPonto
	CONOUT("# CSI00008: Iniciou o WSRColaboradoresPonto - GET")
	::SetContentType("application/json") // define o tipo de retorno do método
	::SetResponse( U_CSI00008( nTIPO_REQUISICAO_GET ) )
	CONOUT("# CSI00008: Encerrou o WSRColaboradoresPonto - GET")
Return .T.