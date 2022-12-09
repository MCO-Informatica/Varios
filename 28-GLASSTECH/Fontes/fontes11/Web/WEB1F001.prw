#Include 'Protheus.ch'
#Include 'Totvs.ch'
#Include 'APWEBEX.ch'

User Function WEB1F001()

	local cProdDescri := ""
	local cHtml := ""
	local cCodCatalogo := ""
	
	WEB EXTENDED INIT cHtml
	
		&& Pega get da página
		cCodCatalogo := HttpGet->Cod
	
		if AllTrim(cCodCatalogo) <>	 ""
			cCodCatalogo := "Vish"
		endif
		
		if type("cCodCatalogo") == "U"
			cCodCatalogo := "Sem COD 2"
		endif
		
		&& Prepara ambiente
		RPCSetEnv("01","0101",,,,,{"SB1", "SC2"}) 
		
		cProdDescri := U_GetPDesc("VWA-AR0530VFA")
		cHtml += U_CToJson("CodEcho", cCodCatalogo)
	
	WEB EXTENDED END

Return cHtml