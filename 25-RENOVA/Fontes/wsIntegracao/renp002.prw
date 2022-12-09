#include "protheus.ch"
/* Executar Integração Protheus x Cmms */

User function renp002(cObj,cOpc,oObj,cFilobj,cCodobj,cId,cError)
	Local cUrl    := ''
	Local aHeader := {}
	Local aApp    := {}
	Local nApp	  := 0
	Local cApp    := ''

	Local oRest
	Local cJson
	Local oJson
	Local cJsonR
	Local oJsonR
	Local nSthttp := 0
	Local cDtoper := ''
	Local nO	:= 0
	Local cAuth := ""

	Default cObj := 'M'        //M-Produto
	Default cOpc := 'C'        //C-Consulta;I-Inclusão;B-Bloqueio;A-Alteração;E-Exclusão
	Default cId  := ''

	DbSelectArea("SZC")
	DbSelectArea("SZB")
	cError := ""

	cUrl := GetNewPar('MV_XURLEQM','https://eqm-hmlg.informa.com.br:8425')

	if cUrl == "error"
		cError := "Problemas em parâmetro URL, para acessar o EQM!"
	else

		if empty(cId)
			szb->(DbSetOrder(1))
			if !empty(cCodobj) .and. szb->(dbseek(xfilial()+cFilobj+cObj+cCodobj))
				cId := alltrim(szb->zb_idreg)
			endif
		endif

		if cOpc == "I" .and. !empty(cId)
			cError := "Não conformidade na chamada Webservice EQM. A entidade que se quer incluir já esta registrada no SZB !"
		elseif cOpc $ "A|E" .and. empty(cId)
			cError := "Não conformidade na chamada Webservice EQM. A entidade que se quer Alterar/Excluir não esta Registrada no SZB !"
		endif

	endif

	if !empty(cError)
		cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()
		szc->(RecLock("SZC", .t.))
		szc->zc_filobj := cFilobj
		szc->zc_tipreg := cObj
		szc->zc_codobj := cCodobj
		szc->zc_oper   := cOpc
		szc->zc_local  := 'P'
		szc->zc_dtoper := cDtoper
		szc->zc_status := 'F'
		szc->zc_mensag := FwCutOff("Falha na operação com EQM. Erro: " + cError,.t.)
		szc->(MsUnlock())
		Return oJson
	endif

	cAuth := 'Basic '+Encode64( GetNewPar('MV_XAUTHOR','INTFPROTHEUS:60RweqZ6J6DLGnZxbC') )
	//cAuth := 'Basic '+GetNewPar('MV_XAUTHOR','INTFPROTHEUS:60RweqZ6J6DLGnZxbC')

	aAdd(aHeader, 'Content-Type: application/json')
	aAdd(aHeader, 'Authorization: '+cAuth )
	//aAdd(aHeader, 'User-Agent: Protheus 12')
	//aAdd(aHeader, 'Accept: */*')
	//aAdd(aHeader, 'Host: '+replace(cUrl,'http://',''))
	//aAdd(aHeader, 'Accept-Encoding: gzip, deflate, br')
	//aAdd(aHeader, 'Connection: keep-alive')

	aadd(aApp, {'M','/api/eqm/INTF_MATERIAL_WS/AtualizaMateriaisEQM'})
	aadd(aApp, {'A','/api/eqm/INTF_ATIVO_WS/AtualizaAtivosEQM'})

	nApp := Ascan(aApp,{|x| x[1]==cObj})
	cApp := aApp[nApp,2]

	oRest := FWRest():New(cUrl)
	if cOpc == "C"
		oRest:setPath(cApp+'/'+cId)
		cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()
		If oRest:Get(aHeader)
			cJson := oRest:GetResult()
			cJson := FwCutOff( DecodeUTF8(cJson, "cp1252") ,.t.)
			oJson := JsonObject():New()
			cError := oJson:FromJson(cJson)
		Else
			cError := "error"
		EndIf
	else
		if cOpc $ "I|A|B|E"
			oJson := FazJson(cObj,cOpc,oObj)
			cJson := FwCutOff(oJson:toJson(),.t.)
			//aAdd(aHeader, 'Content-Length: '+alltrim(str(len(cJson))))
			oRest:setPath(cApp)
			oRest:SetPostParams(cJson)
			cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()
			if oRest:Post(aHeader)
				cJsonR := FwCutOff( DecodeUTF8(oRest:GetResult(), "cp1252") ,.t.)
				oJsonR := JsonObject():New()
				cError := oJsonR:FromJson(cJsonR)
				if empty(cError)
					cError := ""
					if oJsonR["error"] != nil
						//oJsonR["error"]["code"]
						cError := oJsonR["error"]["message"]
					else
						oJsonR := oJsonR["result"]
						for nO := 1 to len(oJsonR)
							cOri := 'oJsonR['+str(nO)+']'
							cOri += iif(cObj == 'A','["CODG_EQUIPAMENTO"]','["NUMR_MATERIAL_EXTERNO"]')
							cId := &cOri
							cOri := 'oJsonR['+str(nO)+']["CODIGO"]'
							if &cOri != 1
								cOri := 'oJsonR['+str(nO)+']["MENSAGEM"]'
								cError += &cOri
							endif
						next nO
					endif
					if empty(cError)
						if cOpc == "I"
							szb->(RecLock("SZB", .t.))
							szb->zb_filobj := cFilobj
							szb->zb_tipreg := cObj
							szb->zb_codobj := cCodobj
							szb->zb_idreg  := cId
							szb->zb_ativo  := "1"
							szb->(MsUnlock())
						elseif cOpc $ "B|E"
							szb->(RecLock("SZB", .f.))
							szb->zb_ativo  := "0"
							szb->(MsUnlock())
						endif
					endif
				endif
			else
				cError := "error"
			endIf

		endif

	endif

	szc->(RecLock("SZC", .t.))
	szc->zc_filobj := cFilobj
	szc->zc_tipreg := cObj
	szc->zc_codobj := cCodobj
	szc->zc_oper   := cOpc
	szc->zc_local  := 'C'
	szc->zc_dtoper := cDtoper
	if !empty(cError)
		if cOpc == "C" .and. cError != "error"
			cError := "Problems com a estrutura do json. Erro: " + cError
		else
			nSthttp := HTTPGetStatus(@cError)
			cError := alltrim(cError)+iif(oRest:GetResult()==nil," - Sem Retorno",oRest:GetResult())
			cError := "Status Http: "+alltrim(str(nSthttp))+": "+alltrim(cError)+iif(empty(cId),"",", idReg: "+ cId)
			cError := DecodeUTF8(cError, "cp1252")
		endif
		cError := FwCutOff("Falha na operação com EQM. Erro: " + cError,.t.)
		szc->zc_status := 'F'
		szc->zc_mensag := cError
	else
		szc->zc_status := "R"
		szc->zc_mensag := oRest:oResponseH:cReason+iif(empty(cId),"",", idReg: "+ cId)
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

	if aObj[1,1] == "AMATERIAIS"
		aObj[1,1] := "aMateriais"
	elseif aObj[1,1] == "AATIVOS"
		aObj[1,1] := "aAtivos"
	endif

	if cOpc $ "I|A|B|E"
		for nI := 1 to len(aObj)
			if &('oObj:'+aObj[nI,1]) != nil
				cDes := 'oJson["'+aObj[nI,1]+'"]'
				&cDes := atribObj(oObj,aObj[nI,1])
			endif
		next nI
	endif

Return oJson


Static Function atribObj(oObj,cNomObj)

	Local oJson
	Local oJsoD
	Local oObD
	Local aObD := {}
	Local cObD := ''

	Local cOri := ''
	Local cDes := ''

	Local aJsoD := {}
	Local cOrD
	Local cDeD
	Local nP := 0
	Local nO := 0
	Local nI := 0

	oJson := JsonObject():new()
	oJsoD := JsonObject():new()
	cOri := 'oObj:'+cNomObj
	cDes := 'oJson["'+cNomObj+'"]'

	if ValType(&cOri) == "A"
		For nP := 1 to len(&cOri)
			Aadd(aJsoD,JsonObject():new())
			oObD := &(cOri+"["+str(nP)+"]")
			aObD := ClassDataArr(oObD)
			For nO := 1 to len(aObD)
				cOrD := 'oObD:'+aObD[nO,1]
				/* Inicio Ajuste nome do atributo para o nome da Tag Correta */
				cObD := aObD[nO,1]
				nI := 1
				while substr(aObD[nO,1],nI,1) == "_" .and. substr(aObD[nO,1],iif(nI>1,nI-1,nI),1) == "_"
					if at( '_', cObD ) == 1
						cObD := strtran(cObD,'_','',1,1)
					endif
					nI += 1
				end
				/* Fim Ajuste nome do atributo para o nome da Tag Correta */
				cDeD := 'aJsoD['+str(nP)+',"'+cObD+'"]'
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
