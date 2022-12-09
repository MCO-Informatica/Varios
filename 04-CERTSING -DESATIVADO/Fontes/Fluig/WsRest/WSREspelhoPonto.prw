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

WSRESTFUL WSREspelhoPonto DESCRIPTION "Web Service de Integracao" FORMAT APPLICATION_JSON

WSDATA filial    AS string OPTIONAL
WSDATA matricula AS string OPTIONAL
WSDATA periodo 	 AS string OPTIONAL

//WSMETHOD GET  DESCRIPTION "Retorna lista de abonos" WSSYNTAX "/WSREspelhoPonto || /WSREspelhoPonto/"
WSMETHOD GET DESCRIPTION  "Lista de aceite de banco de horas dos colaboradores"  WsSyntax "/WSREspelhoPonto || /WSREspelhoPonto/{filial, matricula, dIni, dFim}"
//WSMETHOD POST DESCRIPTION "Inclui pré abono" WSSYNTAX "/WSREspelhoPonto/{id}"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} POST
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
/*
WSMETHOD POST WSRECEIVE filial, matricula, dBaseFerias, dIniGozo, dFimGozo, cAbonoPec, c13ParAnt WSSERVICE WSREspelhoPonto
CONOUT("# CSI00009: Iniciou o WSREspelhoPonto - POST")
::SetContentType("application/json") // define o tipo de retorno do método
::SetResponse( U_CSI00009( nTIPO_REQUISICAO_POST, ::filial, ::matricula, ::dBaseFerias, ::dIniGozo, ::dFimGozo, ::cAbonoPec, ::c13ParAnt ) )
CONOUT("# CSI00009: Encerrou o WSREspelhoPonto - POST")
Return .T.
*/

//-------------------------------------------------------------------
/*/{Protheus.doc} GET
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
WSMETHOD GET WSRECEIVE filial, matricula, periodo WSSERVICE WSREspelhoPonto
	CONOUT("# CSI00009: Iniciou o WSREspelhoPonto - GET")
	::SetContentType("application/json") // define o tipo de retorno do método
	::SetResponse( U_CSI00009( nTIPO_REQUISICAO_GET, ::filial, ::matricula, ::periodo     ) )
	CONOUT("# CSI00009: Encerrou o WSREspelhoPonto - GET")
Return .T.