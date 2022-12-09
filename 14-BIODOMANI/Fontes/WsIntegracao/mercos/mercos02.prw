#include "protheus.ch"
/* Executar Integração Protheus x Mercos */

User function mercos02(cObj,cOpc,oObj,cCodigo,cIdMercos,cUlt,cError)
	Local cUrl    := ""
	Local aHeader := {}
	Local cApplicationToken := ""
	Local cCompanyToken := ""
	Local aApp    := {}
	Local nApp	  := 0
	Local cApp    := ""
	Local cParam  := ""

	Local oRest
	Local cJson
	//Local cRetJson
	Local oJson
	Local nSthttp := 0
	Local lOk := .t.

	Local cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()

	Default cObj := 'P'        //P-Produto;C-Cliente;V-Pedido
	Default cOpc := 'C'        //C-Consulta;I-Inclusão;A-Alteração;E-Exclusão
	Default cIdMercos := ""
	Default cUlt := '2022-01-01%2000:00:00'

	DbSelectArea("SX5")
	DbSelectArea("SZC")
	DbSelectArea("SZB")
	cError := ""

	cUrl := GetNewPar("MV_XURLMER","error")
	cApplicationToken := GetNewPar("MV_XATOMER","error")
	sx5->(DbSetOrder(1))
	if sx5->(dbseek(xfilial()+"ZK"))
		cCompanyToken := alltrim(sx5->x5_descri)
	else
		cCompanyToken := "error"
	endif
	//RETIRAR APÓS TESTES DE INCLUSÃO DE CLIENTES E PEDIDOS
	//cApplicationToken := '1413cea4-d18a-11e4-be31-f23c91df94d9'
	//cCompanyToken := 'a77da094-9443-11e5-be32-f23c91df94d9'

	if cUrl == "error" .or. cApplicationToken == "error" .or. cCompanyToken == "error"
		cError := "Problemas em parâmetros URL ou Aplication Token ou Company token, para acessar o Mercos!"
	else

		if empty(cIdMercos)
			szb->(DbSetOrder(1))
			if !empty(cCodigo) .and. szb->(dbseek(xfilial()+cFilAnt+cObj+cCodigo))
				cIdMercos := alltrim(szb->zb_idreg)
			endif
		endif

		if cOpc == "I" .and. !empty(cIdMercos)
			cError := "Não conformidade na chamada Webservice Mercos. A entidade que se quer incluir já esta registrada no SZB !"
		elseif cOpc $ "A|E" .and. empty(cIdMercos)
			cError := "Não conformidade na chamada Webservice Mercos. A entidade que se quer Alterar/Excluir não esta Registrada no SZB !"
		endif

	endif

	if !empty(cError)
		szc->(RecLock("SZC", .t.))
		szc->zc_filori := cFilAnt
		szc->zc_tipreg := cObj
		szc->zc_codigo := cCodigo
		szc->zc_oper   := cOpc
		szc->zc_local  := 'P'
		szc->zc_dtoper := cDtoper
		szc->zc_status := 'F'
		szc->zc_mensag := FwCutOff("Falha na operação com Mercos. Erro: " + cError,.t.)
		szc->(MsUnlock())
		Return oJson
	endif

	aAdd(aHeader, 'Content-Type: application/json')
	aAdd(aHeader, 'ApplicationToken: '+cApplicationToken )
	aAdd(aHeader, 'CompanyToken: '+cCompanyToken)

	aadd(aApp, {'P','/api/v1/produtos/'})
	aadd(aApp, {'C','/api/v1/clientes/'})
	aadd(aApp, {'T','/api/v1/categorias/'})
	aadd(aApp, {'E','/api/v1/ajustar_estoque/'})
	aadd(aApp, {'S','/api/v1/transportadoras/'})
	aadd(aApp, {'D','/api/v1/condicoes_pagamento/'})
	aadd(aApp, {'F','/api/v1/formas_pagamento/'})
	aadd(aApp, {'O','/api/v2/pedidos/'})
	aadd(aApp, {'B','/api/v1/tabelas_preco/'})
	aadd(aApp, {'R','/api/v1/produtos_tabela_preco/'})
	aadd(aApp, {'G','/api/v1/segmentos/'})
	aadd(aApp, {'U','/api/v1/usuarios/'})
	aadd(aApp, {'I','/api/v1/configuracoes_icms_st/'})

	nApp := Ascan(aApp,{|x| x[1]==cObj})
	cApp := aApp[nApp,2]

	oRest := FWRest():New(cUrl)
	if cOpc == "C"
		if !empty(cIdMercos)
			cParam  := cIdMercos
		else
			cParam  := '?alterado_apos='+cUlt
		endif
		oRest:setPath(cApp+cParam)
		cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()
		lOk := u_mercos99(@oRest,aHeader,cJson,"oRest:Get(aHeader)",@cError)
		if lOk
			cJson := oRest:GetResult()
			cJson := FwCutOff( DecodeUTF8(cJson, "cp1252") ,.t.)
			oJson := JsonObject():New()
			cError := oJson:FromJson(cJson)
		Else
			cError := "error"
		EndIf
		/*
		If oRest:Get(aHeader)
			cJson := oRest:GetResult()
			cJson := FwCutOff( DecodeUTF8(cJson, "cp1252") ,.t.)
			oJson := JsonObject():New()
			cError := oJson:FromJson(cJson)
		Else
			cError := "error"
		EndIf
		*/
	else
		if cOpc == "I"
			oJson := FazJson(cObj,cOpc,oObj)
			cJson := oJson:toJson()
			cJson := FwCutOff(cJson,.t.)
			oRest:setPath(cApp)
			oRest:SetPostParams(cJson)
			cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()
			lOk := u_mercos99(@oRest,aHeader,cJson,"oRest:Post(aHeader)",@cError)
			/*
			lOk := oRest:Post(aHeader)
			nSthttp := HTTPGetStatus(@cError)
			while !lOk .and. nSthttp == 429
				cError := FwCutOff( DecodeUTF8(oRest:GetResult(), "cp1252") ,.t.)
				oJson := JsonObject():New()
				cError := oJson:FromJson(cError)
				if empty(cError)
					nTemp := oJson["tempo_ate_permitir_novamente"]*1000
				else
					nTemp := 2000
				endif
				sleep(nTemp)
				lOk := oRest:Post(aHeader)
				nSthttp := HTTPGetStatus(@cError)
			end
			*/
			if lOk
				cError := ""
				cIdMercos := FwCutOff(oRest:oResponseH:aHeaderFields[6,2], .t.)
				//cRetJson := oRest:getResult()
				szb->(RecLock("SZB", .t.))
				szb->zb_filori := cFilAnt
				szb->zb_tipreg := cObj
				szb->zb_codigo := cCodigo
				szb->zb_idreg  := cIdMercos
				szb->zb_ativo  := "1"
				szb->(MsUnlock())
			else
				cError := "error"
			EndIf

		elseif cOpc $ "A|B|E"
			oJson := FazJson(cObj,cOpc,oObj)
			cJson := oJson:toJson()
			cJson := FwCutOff(cJson,.t.)
			oRest:setPath(cApp+cIdMercos)
			cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()
			lOk := u_mercos99(@oRest,aHeader,cJson,"oRest:Put(aHeader,cJson)",@cError)
			/*
			lOk := oRest:Put(aHeader,cJson)
			nSthttp := HTTPGetStatus(@cError)
			while cOpc == "A" .and. !lOk .and. nSthttp == 429
				cError := FwCutOff( DecodeUTF8(oRest:GetResult(), "cp1252") ,.t.)
				oJson := JsonObject():New()
				cError := oJson:FromJson(cError)
				if empty(cError)
					nTemp := oJson["tempo_ate_permitir_novamente"]*1000
				else
					nTemp := 2000
				endif
				sleep(nTemp)
				lOk := oRest:Put(aHeader,cJson)
				nSthttp := HTTPGetStatus(@cError)
			end
			*/
			if lOk
				cError := ""
				//cRetJson := oRest:getResult()
				if cOpc == "E"
					szb->(RecLock("SZB", .f.))
					szb->zb_ativo  := "0"
					szb->(MsUnlock())
				endif
			else
				cError := "error"
			endif

		endif

	endif

	szc->(RecLock("SZC", .t.))
	szc->zc_filori := cFilAnt
	szc->zc_tipreg := cObj
	szc->zc_codigo := cCodigo
	szc->zc_oper   := cOpc
	szc->zc_local  := 'M'
	szc->zc_dtoper := cDtoper
	if !empty(cError)
		if cOpc == "C" .and. cError != "error"
			cError := "Problems com a estrutura do json. Erro: " + cError
		else
			nSthttp := HTTPGetStatus(@cError)
			cError := "Status Http: "+alltrim(str(nSthttp))+": "+alltrim(cError)+" "+oRest:GetResult()+iif(empty(cIdMercos),"",", idReg: "+ cIdMercos)
			cError := DecodeUTF8(cError, "cp1252")
		endif
		cError := FwCutOff("Falha na operação com Mercos. Erro: " + cError,.t.)
		szc->zc_status := 'F'
		szc->zc_mensag := cError
	else
		szc->zc_status := "R"
		szc->zc_mensag := oRest:oResponseH:cReason+iif(empty(cIdMercos),"",", idReg: "+ cIdMercos)
	endif
	szc->(MsUnlock())

	FreeObj(oRest)

Return oJson


Static Function FazJson(cObj,cOpc,oObj)

	Local oJson
	Local aObj := {}
	Local nI   := 0
	Local cDes := ""

	oJson := JsonObject():new()
	aObj := ClassDataArr(oObj)

	if cOpc $ "I|A"
		for nI := 1 to len(aObj)
			//if !lower(aObj[nI,1]) $ "id||ultima_alteracao" .and. &('oObj:'+lower(aObj[nI,1])) != nil
			if &('oObj:'+lower(aObj[nI,1])) != nil
				cDes := 'oJson["'+lower(aObj[nI,1])+'"]'
				&cDes := atribObj(oObj,aObj[nI,1])
			endif
		next nI
	elseif cObj == 'P'
		if cOpc == "B"
			oJson["nome"] := oObj:nome
			oJson["preco_tabela"] := 0
			oJson["ativo"] := .f.
		elseif cOpc == "E"
			oJson["nome"] := oObj:nome
			oJson["preco_tabela"] := 0
			oJson["excluido"] := .t.
		endif
	else
		//if cOpc == "B"
		//	oJson["ativo"] := .f.
		//else
		if cOpc == "E"
			oJson["excluido"] := .t.
		endif
	endif

Return oJson


Static Function atribObj(oObj,cNomObj)

	Local oJson
	Local oJsoD
	Local oObD
	Local aObD := {}

	Local cOri := ''
	Local cDes := ''

	Local aJsoD := {}
	Local cOrD := ''
	Local cDeD := ''
	Local nP := 0
	Local nO := 0

	oJson := JsonObject():new()
	oJsoD := JsonObject():new()
	cOri := 'oObj:'+lower(cNomObj)
	cDes := 'oJson["'+lower(cNomObj)+'"]'

	if ValType(&cOri) == "A"
		For nP := 1 to len(&cOri)
			Aadd(aJsoD,JsonObject():new())
			oObD := &(cOri+"["+str(nP)+"][1]")
			aObD := ClassDataArr(oObD)
			For nO := 1 to len(aObD)
				cOrD := 'oObD:'+lower(aObD[nO,1])
				cDeD := 'aJsoD['+str(nP)+',"'+lower(aObD[nO,1])+'"]'
				&cDeD := &cOrD
			next nO
		Next nP
		if !empty(cDeD)
			&cDes := aJsoD
		else
			&cDes := &cOri
		endif
	else
		&cDes := &cOri
	endif

Return &cDes
