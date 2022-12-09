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

WSRESTFUL WSRPreAbono DESCRIPTION "Web Service de Integracao" FORMAT APPLICATION_JSON

WSDATA filial    AS string OPTIONAL
WSDATA matricula AS string OPTIONAL
WSDATA dIni 	 AS string OPTIONAL
WSDATA dFim 	 AS string OPTIONAL
WSDATA hIni  	 AS float  OPTIONAL
WSDATA hFim  	 AS float  OPTIONAL

//WSMETHOD GET  DESCRIPTION "Retorna lista de funcionario ativos" WSSYNTAX "/funcionario || /funcionario/{filial}"
WSMETHOD POST DESCRIPTION "Inclui pré abono" WSSYNTAX "/WSRPreAbono/{id}"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} POST
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
WSMETHOD POST WSRECEIVE filial, matricula, dIni, dFim, hIni, hFim WSSERVICE WSRPreAbono
	CONOUT("# CSI00002: Iniciou o WSRPreAbono - POST")
	::SetContentType("application/json") // define o tipo de retorno do método
	::SetResponse( U_CSI00002( nTIPO_REQUISICAO_POST, ::filial, ::matricula, ::dIni, ::dFim, ::hIni, ::hFim ) )
	CONOUT("# CSI00002: Encerrou o WSRPreAbono - POST")
Return .T.
