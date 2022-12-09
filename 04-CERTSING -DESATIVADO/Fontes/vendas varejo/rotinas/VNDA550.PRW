#INCLUDE "PROTHEUS.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="utf-8"?>'

/*/{Protheus.doc} VNDA550

Funcao criada para solicitar novas etiquetas de rastreamento dos correios de acordo ponto de pedido parametrizado  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/

User Function VNDA550(aParSch)
	Local cCategory := "SOLICITA-ETIQUETAS-RASTREAMENTO"
	Local cDocument := ""
	Local cError	:= ""
	Local cWarning	:= ""
	Local cSvcError := ""
	Local cSoapFCode:= ""
	Local cSoapFDescr:= ""
	Local lOk		:= .T.
	Local oWsObj
	Local oWsRes
	Local cJobEmp	:= aParSch[1]
	Local cJobFil	:= aParSch[2]
	Local _lJob 	:= (Select('SX6')==0)
	Local cQtdEtq	:= ""
	Local cPtSol	:= 0
	Local cAlias	:= ""
	Local aEtq		:= {}
	Local nI		:= 0
	
	If _lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp, cJobFil)
	EndIf
	
	cQtdEtq := GetNewPar("MV_XQTDETQ", "200")
	cPtSol	:= GetNewPar("MV_XPTPETQ", "50")
	
	If Val(cQtdEtq) > 1000
		cQtdEtq := "1000"	
	EndIf
	
	cAlias := GetNextALias()
	
	BeginSql Alias cAlias
		SELECT
		  SA4.A4_COD,SA4.A4_XCODCOR, COUNT(PAG.PAG_CODRAS) QTDETQ
		FROM
		  %Table:SA4% SA4 LEFT OUTER JOIN %Table:PAG% PAG ON
		    SA4.A4_FILIAL = %xFilial:SA4% AND
		    PAG.PAG_FILIAL = %xFilial:PAG% AND
		    SA4.A4_COD = PAG.PAG_CODTRA AND
		    PAG.PAG_STATUS = '1' AND
		    SA4.%NotDel% AND
		    PAG.%NotDel%
		WHERE
		  SA4.A4_XCODCOR <> ' '
		GROUP BY 
		  SA4.A4_COD,SA4.A4_XCODCOR
		HAVING
		  COUNT(PAG.PAG_CODRAS) <= %Exp:cPtSol%
	EndSql

	While !(cAlias)->(EoF())
		cDocument := XML_VERSION + CRLF
		cDocument += '<SolicitaEtiquetas>'+ CRLF
		cDocument += '	<servico>'+(cAlias)->A4_XCODCOR+'</servico>'+ CRLF
		cDocument += '	<quantidade>'+cQtdEtq+'</quantidade>'+ CRLF
		cDocument += '</SolicitaEtiquetas>'+ CRLF
		
		oWsObj := WSVVHubServiceService():New()

		lOk := oWsObj:sendMessage(cCategory,cDocument)
		
		cSvcError   := GetWSCError()  // Resumo do erro
		cSoapFCode  := GetWSCError(2)  // Soap Fault Code
		cSoapFDescr := GetWSCError(3)  // Soap Fault Description
		
		If !empty(cSoapFCode)
			//Caso a ocorrência de erro esteja com o fault_code preenchido ,
			//a mesma teve relação com a chamada do serviço . 
			Conout('[VNDA550]'+cSoapFDescr + ' ' + cSoapFCode)
		ElseIf !Empty(cSvcError)
			//Caso a ocorrência não tenha o soap_code preenchido 
			//Ela está relacionada a uma outra falha , 
			//provavelmente local ou interna.
			Conout('[VNDA550] FALHA INTERNA DE EXECUCAO DO SERVIÇO'+cSvcError)
		Endif
		
		If lOk
			oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
			
			If oWsRes:_SOLICITAETIQUETASRESPONSE:_CODE:TEXT == "1" .AND. Empty(cError)
				aEtq := StrTokArr ( oWsRes:_SOLICITAETIQUETASRESPONSE:_ETIQUETAS:TEXT, ",")
				
				For nI:=1 to len(aEtq)
					RecLock("PAG", .T.)
						Replace PAG->PAG_FILIAL	With xFilial("PAG")
						Replace PAG->PAG_CODTRA	With (cAlias)->A4_COD
						Replace PAG->PAG_CODRAS	With aEtq[nI]
						Replace PAG->PAG_STATUS	With "1"
					PAG->(MsUnLock())
				Next
			ElseIf !Empty(cError)
				conout("[VNDA550] Erro no parser do xml enviado pelo HUB "+cError)	
			Else
				conout("[VNDA550] Erro no retorno do HUB "+oWsRes:_SOLICITAETIQUETASRESPONSE:_MSG:TEXT)
			EndIf
		EndIf	
		
		FreeObj(oWsObj)
		DelClassIntf()
		
		(cAlias)->(DbSkip())	
	EndDo
Return