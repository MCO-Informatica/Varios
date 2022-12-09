#include "protheus.ch"
/* Executar Integra��o Protheus x E-Commerce */

User function ecop002(cObj,cOpc,oObj,cFilobj,cCodobj,cId,cError)
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
	//Local nSthttp := 0
	Local cDtoper := ''
	Local nO	:= 0

	Default cObj := 'P'        //M-Produto
	Default cOpc := 'C'        //C-Consulta;I-Inclus�o;B-Bloqueio;A-Altera��o;E-Exclus�o
	Default cId  := ''

	//DbSelectArea("SZC")
	//DbSelectArea("SZB")
	cError := ""

	cUrl := GetNewPar('MV_XURLEQM','https://api-datalake-dev.dolado.com.br')

	if cUrl == "error"
		cError := "Problemas em par�metro URL, para acessar o EQM!"
	else
		/*
		if empty(cId)
			szb->(DbSetOrder(1))
			if !empty(cCodobj) .and. szb->(dbseek(xfilial()+cFilobj+cObj+cCodobj))
				cId := alltrim(szb->zb_idreg)
			endif
		endif
		if cOpc == "I" .and. !empty(cId)
			cError := "N�o conformidade na chamada Webservice EQM. A entidade que se quer incluir j� esta registrada no SZB !"
		elseif cOpc $ "A|E" .and. empty(cId)
			cError := "N�o conformidade na chamada Webservice EQM. A entidade que se quer Alterar/Excluir n�o esta Registrada no SZB !"
		endif
		*/
	endif

	if !empty(cError)
		cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()	/*
		szc->(RecLock("SZC", .t.))
		szc->zc_filobj := cFilobj
		szc->zc_tipreg := cObj
		szc->zc_codobj := cCodobj
		szc->zc_oper   := cOpc
		szc->zc_local  := 'P'
		szc->zc_dtoper := cDtoper
		szc->zc_status := 'F'
		szc->zc_mensag := FwCutOff("Falha na opera��o com EQM. Erro: " + cError,.t.)
		szc->(MsUnlock())	*/
		Return oJson
	endif

	cAcesso := GetNewPar('MV_XAUTHOR','GYKDZwaZVXoHntUt$kq5y5reT0h6vM5eYz8PjCQS')

	aAdd(aHeader, 'Content-Type: application/json')
	aAdd(aHeader, 'Token: '+cAcesso )
	//aAdd(aHeader, 'User-Agent: Protheus 12')
	//aAdd(aHeader, 'Accept: */*')
	//aAdd(aHeader, 'Host: '+replace(cUrl,'http://',''))
	//aAdd(aHeader, 'Accept-Encoding: gzip, deflate, br')
	//aAdd(aHeader, 'Connection: keep-alive')

	aadd(aApp, {'P','/totvs-webhook-split/product'})

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
					endif	/*
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
					endif	*/
				endif
			else
				cError := "error"
			endIf

		endif

	endif
	/*
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
		cError := FwCutOff("Falha na opera��o com EQM. Erro: " + cError,.t.)
		szc->zc_status := 'F'
		szc->zc_mensag := cError
	else
		szc->zc_status := "R"
		szc->zc_mensag := oRest:oResponseH:cReason+iif(empty(cId),"",", idReg: "+ cId)
	endif
	szc->(MsUnlock())
	*/
	FreeObj(oRest)

Return oJson


Static Function FazJson(cObj,cOpc,oObj)

	Local oJson
	Local aObj := {}
	Local nI   := 0
	Local cDes := ""

	oJson := JsonObject():new()
	aObj := ClassDataArr(oObj)

	if cOpc $ "I|A|B|E"
		for nI := 1 to len(aObj)
			if &('oObj:'+aObj[nI,1]) != nil
				cDes := 'oJson["'+aObj[nI,1]+'"]'
				&cDes := u_atribJson(oObj,aObj[nI,1])
			endif
		next nI
	endif

Return oJson


User function prodOper(cEmp,cFil,cMod,cOpc,cCod,cCompl,cErro)
	Local lRet := .t.
	Local oProd
	Local lJob := ( Select( "SX6" ) == 0 )

	if lJob
		RpcSetType( 3 )
		lRet := RpcSetEnv( cEmp, cFil, , , cMod )
	endif
	if lRet
		oProd:=produto():new()
		oProd:busca(cCod,cCompl)
		u_ecop002("P",cOpc,oProd,sb1->(xfilial()),cCod,"",@cErro)
		FreeObj(oProd)
		if !empty(cErro)
			lRet := .f.
		endif
		if lJob
			RpcClearEnv()
		endif
	endif

Return lRet
