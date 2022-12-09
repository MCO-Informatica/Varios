#Include 'Protheus.ch'

User Function CToJson(cChave, cValor)
	
	local cJson := ""
	
	cJson += '{'
	
	cJson += '"' + AllTrim(cChave) + '":'
	cJson += '"' + cValor + '"'
	
	cJson += '}'
	
Return cJson

