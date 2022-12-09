#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "ApWebSrv.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "TopConn.ch"
#Include "Colors.ch"
#Include "RptDef.ch"
#Include "FwPrintSetup.ch"


//+--------------+---------+-------+-----------------------+------+-------------+
//| Programa:    |CSWPPDRV |Autor: |David Alves dos Santos |Data: |15/10/2018   |
//|--------------+---------+-------+-----------------------+------+-------------|
//| Descricao:   |Webservice para integração CRM x Pipedrive.                   |
//|--------------+--------------------------------------------------------------|
//| Nomenclatura |CS    = Certisign.                                            |
//| do codigo    |W     = Webservice.                                           |
//| fonte.       |PPDRV = PipeDrive.                                            |
//|--------------+--------------------------------------------------------------|
//| Docto. API   |https://developers.pipedrive.com/docs/api/v1/                 |
//|--------------+--------------------------------------------------------------|
//| Uso:         |Certisign - Certificadora Digital.                            |
//+--------------+--------------------------------------------------------------+
User Function CSWPPDRV() ; Return


//+------------------+--------------------+------------+---------------------+------------------+
//| FUNÇÃO: CSPDWD01 | MÉTODO: Add a Deal | TIPO: Post | AUTOR: David Santos | DATA: 19/10/2018 |
//|------------------+--------------------+------------+---------------------+------------------|
//| DESCRIÇÃO: Função para incluir um negócio (Deal) através do método POST.                    |
//|---------------------------------------------------------------------------------------------|
//|                             Certisign - Certificadora Digital.                              |
//+---------------------------------------------------------------------------------------------+
User Function CSPDWD01( lJob, cTitle, cValue, cCurrency, nUserID, nPersonID, nOrgIG, nStageID, cStatus, nProbabili, cLostReaso, cAddTime, cVisibleTo, aCustField )
	
	Local aHeader := {}

    Local cGetResult := ""
    Local cAPIDeal   := GetMv( 'MV_CCRMW01', .F., '/deals' )
    Local cResult    := ""
    
    Local lRet := .T.
    
    Local nX := 0
    
    Local oAdDealRes
    Local oResponse
    
    //+------------+-------------+------------+----------+
	//| PROTHEUS   | PIPEDRIVE   | TIPE 	  | REQUIRED |
	//+------------+-------------+------------+----------+
	//| cTitle     | title       | string     |   SIM    | 
	//| cValue     | value       | string     |   NÃO    |
	//| cCurrency  | currency    | string     |   NÃO    |
	//| nUserID    | user_id     | number     |   NÃO    |	
	//| nPersonID  | person_id   | number     |   NÃO    |
	//| nOrgIG     | org_id      | number     |   NÃO    |
	//| nStageID   | stage_id    | number     |   NÃO    |
	//| cStatus    | status      | enumerated |   NÃO    |
	//| nProbabili | probability | number     |   NÃO    |
	//| cLostReaso | lost_reason | string     |   NÃO    |
	//| cAddTime   | add_time    | string     |   NÃO    |
	//| cVisibleTo | visible_to  | enumerated |   NÃO    |
	//+------------+-------------+------------+----------+
    
    If !Empty( cTitle )
    
    	oResponse := JsonObject():New()

    	oResponse["title"] := cTitle
    	
    	If !Empty( cValue )
    		oResponse["value"] := cValue
    	EndIf
    	
    	If !Empty( cCurrency )
    		oResponse["currency"] := cCurrency
    	EndIf
    	
    	If !Empty( nUserID )
    		oResponse["user_id"] := nUserID
    	EndIf
    	
    	If !Empty( nPersonID )
    		oResponse["person_id"] := nPersonID
    	EndIf
    	
    	If !Empty( nOrgIG )
    		oResponse["org_id"] := nOrgIG
    	EndIf
    	
    	If !Empty( nStageID )
    		oResponse["stage_id"] := nStageID
    	EndIf
    	
    	If !Empty( cStatus )
    		oResponse["status"] := cStatus
    	EndIf
    	
    	If !Empty( nProbabili )
    		oResponse["probability"] := nProbabili
    	EndIf
    	
    	If !Empty( cLostReaso )
    		oResponse["lost_reason"] := cLostReaso
    	EndIf
    	
    	If !Empty( cAddTime )
    		oResponse["add_time"] := cAddTime
    	EndIf
    	
    	If !Empty( cVisibleTo )
    		oResponse["visible_to"] := cVisibleTo
    	EndIf
    	
    	//+--------------------------------------------+
    	//| Campos customizados no Detalhe do Negócio. |
    	//+--------------------------------------------+
    	If Len( aCustField ) > 0
    		For nX := 1 To Len(aCustField)
    			oResponse[aCustField[nX,1]] := aCustField[nX,2]
    		Next nX
    	EndIf
    	
    	//-> Serializa qualquer tipo de dado no formato JSON.
    	cBody := FWJsonSerialize(oResponse, .F., .F., .T.)
    	
    	//-> Montagem do cabeçalho.
    	AAdd( aHeader, "content-type: application/json" )
    	
    	//-> Construção do objeto.    	
    	oCRMWRst := Nil
    	oCRMWRst := FWRest():New( cURL )
    	
    	oCRMWRst:setPath( cAPIDeal + "?api_token=" + cToken )
    	oCRMWRst:SetPostParams( cBody )

    	//-> Executando o método POST.
    	If oCRMWRst:Post( aHeader )
    		cGetResult := oCRMWRst:GetResult()
    		If cGetResult <> '[ ]'
    			Conout( &(cDtHr) + "Oportunidade criada com sucesso dentro do PipeDrive.")
    		Else
    			cResult := "Retorno da autenticação vazia. Motivo: " + CRLF + cGetResult
    			Conout( &(cDtHr) + cResult)
    		Endif
    	Else
    		lRet := .F.
    		cResult := "Não foi possivel fazer o POST na autenticação. Motivo: " + CRLF + oCRMWRst:GetLastError()
    		Conout( &(cDtHr) + cResult)
    	EndIf
    	
    Else
    	Conout( &(cDtHr) + "Para inclusão da oportunidade é necessário informar um titulo.")
    	lRet := .F.
    EndIf
    
Return( lRet )


//+------------------+-----------------------+------------+---------------------+------------------+
//| FUNÇÃO: CSPDWD02 | MÉTODO: Get all deals | TIPO: Get  | AUTOR: David Santos | DATA: 19/10/2018 |
//|------------------+-----------------------+------------+---------------------+------------------|
//| DESCRIÇÃO: Função para incluir um negócio (Deal) através do método POST.                       |
//|------------------------------------------------------------------------------------------------|
//|                               Certisign - Certificadora Digital.                               |
//+------------------------------------------------------------------------------------------------+
User Function CSPDWD02( lJob, aPDParam, cFldOport )
	
	Local aHeader     := {}
	Local aOports     := {}
	Local xRet        := {}
	
    Local cGetResult  := ""
    Local cAPIDeal    := GetMv( 'MV_CCRMW01', .F., '/deals' )
    Local cResult     := ""
    Local cGetPar     := ""
    
    Private oPDWD02Re := jsonObject():new()
    
	//+-------------+--------------+------------+----------+
	//| PROTHEUS    | PIPEDRIVE    | TIPE 	    | REQUIRED |
	//+-------------+--------------+------------+----------+
	//| aPDParam[1] | user_id      | number     |   NÃO    | 
	//| aPDParam[2] | filter_id    | number     |   NÃO    |
	//| aPDParam[3] | stage_id     | number     |   NÃO    |
	//| aPDParam[4] | status       | enumerated |   NÃO    |	
	//| aPDParam[5] | start        | number     |   NÃO    |
	//| aPDParam[6] | limit        | number     |   NÃO    |
	//| aPDParam[7] | sort         | string     |   NÃO    |
	//| aPDParam[8] | owned_by_you | enumerated |   NÃO    |
	//+-------------+--------------+------------+----------+
    	
   	//-> Montagem do cabeçalho.
   	AAdd( aHeader, "content-type: application/json" )
    	
   	//-> Construção do objeto.    	
   	oCRMWRst := Nil
   	oCRMWRst := FWRest():New( cURL )
   	
   	For nX := 1 To Len(aPDParam)
   		cGetPar += aPDParam[nX,1] + "=" + aPDParam[nX,2] + "&"
   	Next nX
   	
   	If !Empty(cGetPar)
   		oCRMWRst:setPath( cAPIDeal + "?" + cGetPar + "api_token=" + cToken )
   	Else
   		oCRMWRst:setPath( cAPIDeal + "?api_token=" + cToken )
   	EndIf
   	
   	//-> Executando o método POST.
   	If oCRMWRst:Get( aHeader )
   		
   		cGetResult := oCRMWRst:GetResult()
   		
   		If cGetResult <> '[ ]'
   			
   			oPDWD02Re:fromJson( cGetResult )
  			If oPDWD02Re["success"]
  				If !Empty(oPDWD02Re['data'])
  					For nX := 1 To Len(oPDWD02Re['data'])
  						If oPDWD02Re['data'][nX]['active']
  							If !Empty(oPDWD02Re['data', nX, cFldOport])
  								AAdd(aOports,{StrZero(oPDWD02Re['data', nX, cFldOport],6), oPDWD02Re['data', nX, 'id']})
  							EndIf
  						EndIf
  					Next nX
  					Conout( &(cDtHr) + "Array carregado com as oportunidades do PipeDrive.")
  				Else
  					Conout( &(cDtHr) + "Estágio sem oportunidade")
  				EndIf
  				
  			Else
    			Conout( &(cDtHr) + "Não possivel capturar o retorno do PipeDrive.")
   			EndIf
    	Else
    		cResult := "Retorno da autenticação vazia. Motivo: " + CRLF + cGetResult
    		Conout( &(cDtHr) + cResult)
    	Endif
    Else
    	cResult := "Não foi possivel fazer o GET na autenticação. Motivo: " + CRLF + oCRMWRst:GetLastError()
    	Conout( &(cDtHr) + cResult)
    EndIf
    
    If Len( aOports ) > 0
    	xRet := aClone( aOports )
    Else
    	xRet := {}
    EndIf
       
Return( xRet )



//+------------------+--------------------+------------+---------------------+------------------+
//| FUNÇÃO: CSPDWD03 | MÉTODO: Add a Note | TIPO: Post | AUTOR: David Santos | DATA: 26/12/2018 |
//|------------------+--------------------+------------+---------------------+------------------|
//| DESCRIÇÃO: Função para incluir uma nota dentro de um negócio (Deal) através do método POST. |
//|---------------------------------------------------------------------------------------------|
//|                             Certisign - Certificadora Digital.                              |
//+---------------------------------------------------------------------------------------------+
User Function CSPDWD03( lJob, cContent, nDealID )
	
	Local aHeader := {}

    Local cGetResult := ""
    Local cAPIDeal   := GetMv( 'MV_CCRMW01', .F., '/notes' )
    Local cResult    := ""
    
    Local lRet := .T.
    
    Local nX := 0
    
    Local oAdDealRes
    Local oResponse
    
    
    
    If !Empty( cContent ) .And. !Empty( nDealID )
    
    	oResponse := JsonObject():New()

    	oResponse["content"] := cContent
    	
    	oResponse["deal_id"] := nDealID
    	
    	   	
    	//-> Serializa qualquer tipo de dado no formato JSON.
    	cBody := FWJsonSerialize(oResponse, .F., .F., .T.)
    	
    	//-> Montagem do cabeçalho.
    	AAdd( aHeader, "content-type: application/json" )
    	
    	//-> Construção do objeto.    	
    	oCRMWRst := Nil
    	oCRMWRst := FWRest():New( cURL )
    	
    	oCRMWRst:setPath( cAPIDeal + "?api_token=" + cToken )
    	oCRMWRst:SetPostParams( cBody )

    	//-> Executando o método POST.
    	If oCRMWRst:Post( aHeader )
    		cGetResult := oCRMWRst:GetResult()
    		If cGetResult <> '[ ]'
    			Conout( &(cDtHr) + "Oportunidade criada com sucesso dentro do PipeDrive.")
    		Else
    			cResult := "Retorno da autenticação vazia. Motivo: " + CRLF + cGetResult
    			Conout( &(cDtHr) + cResult)
    			lRet := .F.
    		Endif
    	Else
    		cResult := "Não foi possivel fazer o POST na autenticação. Motivo: " + CRLF + oCRMWRst:GetLastError()
    		Conout( &(cDtHr) + cResult)
    		lRet := .F.
    	EndIf
    	
    Else
    	Conout( &(cDtHr) + "Para inclusão da oportunidade é necessário informar um titulo.")
    EndIf
    
Return( lRet )