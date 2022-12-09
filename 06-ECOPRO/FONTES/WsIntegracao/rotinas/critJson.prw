#include 'protheus.ch'

user Function critJson(cJson,cError)
	Local lRet := .t.
	Local oJson := JsonObject():New()

	if Empty(cJson)
		cError := "Corpo da estrutura Json é necessária !"
		lRet := .f.
	Else
		cError := oJson:fromJson(cJson)
		//Se vazio, significa que o parser ocorreu sem erros
		if Empty(cError)
			cError := ""
		else
			cError := "Falha ao transformar Json em objeto! Erro: "+cError
			lRet := .f.
		endif
	endif

return lRet
