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

WSRESTFUL WSRFuncionario DESCRIPTION "Web Service de Integracao" FORMAT APPLICATION_JSON

WSDATA filial    AS string OPTIONAL

WSMETHOD GET DESCRIPTION "Retorna lista de funcionario ativos" WSSYNTAX "/funcionario || /funcionario/{filial}" //Não possibilita utilizar outro GET

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} GET
Get no modelo antigo WSSYNTAX que não valida agrupamentos e nem path

@author Vinicius Ledesma
@since 05/09/2018
/*/
//-------------------------------------------------------------------
WSMETHOD GET WSRECEIVE filial WSSERVICE WSRFuncionario
	// define o tipo de retorno do método
	::SetContentType("application/json")

	If Len(::filial) > 0
		::SetResponse( U_CSI00001(nTIPO_REQUISICAO_GET, ::filial) )
	EndIf
Return .T.
