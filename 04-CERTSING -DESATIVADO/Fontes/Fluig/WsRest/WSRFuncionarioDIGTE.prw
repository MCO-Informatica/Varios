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

WSRESTFUL WSRFuncionarioDIGTE DESCRIPTION "Web Service de Integracao" FORMAT APPLICATION_JSON

WSDATA filial    	AS string OPTIONAL
WSDATA matricula    AS string OPTIONAL

WSMETHOD GET DESCRIPTION "Retorna lista de funcionario ativos" WSSYNTAX "/WSRFuncionarioDIGTE || /WSRFuncionarioDIGTE/{filial, matricula}" //Não possibilita utilizar outro GET

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} GET
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
WSMETHOD GET WSRECEIVE filial, matricula WSSERVICE WSRFuncionarioDIGTE
	// define o tipo de retorno do método
	::SetContentType("application/json")
	::SetResponse( U_CSI00004(nTIPO_REQUISICAO_GET, ::filial, ::matricula) )
Return .T.
