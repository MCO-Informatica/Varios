#include "protheus.ch"

/* Aguarda limite de execuções dos processos Mercos */
User function mercos99(oRest,aHeader,cJson,cVerbo,cError)

	Local lRet
	Local oJson
	Local nSthttp := 0
	Local nTemp := 0

	lRet := &cVerbo
	nSthttp := HTTPGetStatus(@cError)
	while !lRet .and. nSthttp == 429
		cError := FwCutOff( DecodeUTF8(oRest:GetResult(), "cp1252") ,.t.)
		oJson := JsonObject():New()
		cError := oJson:FromJson(cError)
		if empty(cError)
			nTemp := oJson["tempo_ate_permitir_novamente"]*1000
		else
			nTemp := 2000
		endif
		sleep(nTemp)
		lRet := &cVerbo
		nSthttp := HTTPGetStatus(@cError)
	end

Return lRet
