#Include "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#Include "TopConn.ch"
#include 'restful.ch'

// ----------------------------------------------------------------------
/*/{Protheus.doc} API - Gesto Consulta Saldo de Produto Consulta a API do 
Gestoq com Saldo de Produtos
@author Douglas Silva
@since 05/10/2021
@version 1.0
/*/
// ----------------------------------------------------------------------

User Function APIGTSLD(_cProduto as character, cURLGestoq as character, cPath as character)

	Local cError		:= "" as character
	Local cJSON			:= "" as character
	Local cAuthApi		:= GetMv("ES_GESTAUT",, "cHJvdGhldXM6cDEy")

	Local nStatus	:= 0 as numeric

	Local aHeader	:= {} as array

	Local oRest		:= Nil as object
	Local oJson		:= Nil as object
 
	Private aResposta := {} as array

	Default cURLGestoq	:= GetMv("ES_GESTURL",, "http://192.168.0.48:8081/")
	Default cPath		:= "ConsultaReservaSaldo?CODIGO=" + _cProduto

	aHeader := {}
	oRest := FWRest():New(cURLGestoq)

	//Endpoint
	oRest:setPath(cPath)

	//Cabeçalho de requisição
	aAdd(aHeader,"Authorization: Basic " + cAuthApi)

	//Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
	oJson := JsonObject():New()

	//oRest:SetPostParams(jBody:toJson())
	oRest:SetChkStatus(.F.)

	If oRest:Post(aHeader)
		cError := ""
		nStatus := HTTPGetStatus(@cError)

		If nStatus >= 200 .And. nStatus <= 299
			If Empty(oRest:getResult())
				MsgInfo(nStatus)
			Else

				//trantamento do JSON saldo dos produtos
				cJSON := decodeUtf8(oRest:getResult())

				If FWJsonDeserialize(cJSON,@oJson)
					Aadd(aResposta, {"CODIGO", oJson:CODIGO})
					Aadd(aResposta, {"ARMAZEM", oJson:ID_ARMAZEM})
					Aadd(aResposta, {"NOME_ARMAZEM", oJson:NOME_ARMAZEM})
					Aadd(aResposta, {"SALDO", oJson:SALDO})
					Aadd(aResposta, {"POSICAO", oJson:POSICAO})
					Aadd(aResposta, {"SUBPOSICAO", oJson:SUBPOSICAO})
				EndIf

			Endif
		Else
			MsgStop(cError)
		Endif
	Else
		MsgStop(oRest:getLastError() + CRLF + oRest:getResult())
	Endif

Return (aResposta)
