#Include 'Protheus.ch'
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="utf-8" standalone="yes" ?>'

/*/{Protheus.doc} VNDA620

Rotina para envio retorno de código de vouchers referente a renovação   

@author Totvs SM - David
@since 20/08/2014
@version P11

/*/

User Function vnda620(cXml)
	Local oXml
	Local oWsObj
	Local oWsRes
	Local oModel
	Local cCategory		:= "NOTIFICA-VOUCHER"
	Local cDocument		:= ""
	Local lOk			:= .T. 
	Local cSvcError		:= ""
	Local cSoapFCode	:= ""
	Local cSoapFDescr	:= ""
	Local cMsgRet		:= ""
	Local cXmlCat		:= ""
	Local cError		:= ""
	Local cWarning		:= ""
	Local cPedVou		:= ""
	Local cProdVou		:= ""
	Local cTipVou		:= ""
	Local cAliasSZF		:= "TRBSZF"
	Local cCodVou		:= ""	
	Local nI			:= 0
	Local nPedNot		:= 0
		
	oXml	:= XmlParser( cXml, "_", @cError, @cWarning )
		            
	If Empty(cError)
	
		If Valtype(oXml:_SOLICITAVOUCHER:_PEDIDO) <> "A"
			XmlNode2Arr( oXml:_SOLICITAVOUCHER:_PEDIDO, "_PEDIDO" )
		EndIf
		
		cTipVou	:= Alltrim(oXml:_SOLICITAVOUCHER:_TIPO:TEXT)
		
		For nI := 1 to Len(oXml:_SOLICITAVOUCHER:_PEDIDO)
			
			cPedVou		:= oXml:_SOLICITAVOUCHER:_PEDIDO[nI]:_NUMERO:TEXT
			cProdVou	:= oXml:_SOLICITAVOUCHER:_PEDIDO[nI]:_PRODUTO:TEXT
			
			U_GTPutIN(cPedVou,"R",cPedVou,.T.,{"VNDA620",cPedVou,"Solicitação de voucher para renovação",{"Tipo = "+cTipVou,"Pedido Gar = "+cPedVou,"Produto Gar = "+cProdVou}},cPedVou,{"","",""})
			
			BeginSql Alias cAliasSZF
				SELECT
					SZF.R_E_C_N_O_ SZFREC
				FROM
					%Table:SZF%	SZF
				WHERE
					SZF.ZF_FILIAL = %XFilial:SZF%	AND
					SZF.ZF_TIPOVOU = %Exp:cTipVou%	AND
					SZF.ZF_PEDIDO = %Exp:cPedVou%	AND
					SZF.ZF_PDESGAR = %Exp:cProdVou%	AND
					SZF.ZF_DTVALID > %Exp:DtoS(Date())%	AND
					SZF.%NotDel%
			EndSql
		
			If (cAliasSZF)->(Eof())
					
				oModel := FWLoadModel( 'VNDA060' )
				oModel:SetOperation( 3 )
				oModel:Activate()
				
				oModel:SetValue( 'SZFMASTER', "ZF_USRSOL"	, "AUTOMATICO" )
				oModel:SetValue( 'SZFMASTER', "ZF_TIPOVOU"	, cTipVou )
				oModel:SetValue( 'SZFMASTER', "ZF_PEDIDO"	, cPedVou )
				oModel:SetValue( 'SZFMASTER', "ZF_PDESGAR"	, cProdVou )
				
				If oModel:VldData()
  					
					oModel:CommitData()
					
					cMsgRet	:= "**EFETIVADO**"+CRLF+"Voucher código "+oModel:GetValue( 'SZFMASTER', 'ZF_COD' )+" gerado com sucesso para Pedido "+cPedVou+"!"
					cCodVou := oModel:GetValue( 'SZFMASTER', 'ZF_COD' )
					lOk	:= .T.

				Else
					aErro := oModel:GetErrorMessage()
					
					cMsgRet := "**NÃO EFETIVADO**"+CRLF+"Id do formulário de origem:" + ' [' + AllToChar( aErro[1] ) + ']'+CRLF 
					cMsgRet += "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']'+CRLF 
					cMsgRet += "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) + ']'+CRLF 
					cMsgRet += "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']'+CRLF 
					cMsgRet += "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']'+CRLF 
					cMsgRet += "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']'+CRLF 
					cMsgRet += "Mensagem da solução: " + ' [' + AllToChar( aErro[7] ) + ']'+CRLF 
					cMsgRet += "Valor atribuído: " + ' [' + AllToChar( aErro[8] ) + ']'+CRLF 
					cMsgRet += "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']'+CRLF 
					
					lOk		:= .F.
					cCodVou	:= ""

				EndIf
				
				oModel:DeActivate()
				
				If 	!lOk 				 	
					U_GTPutOUT(cPedVou,"R",cPedVou,{"VNDA620",{.F.,"E00002",cPedVou,"Falha ao Incluir Voucher "+cMsgRet}},cPedVou)
				EndIf
				
			Else
				SZF->(dBgoto((cAliasSZF)->SZFREC))
				cCodVou := SZF->ZF_COD
				cMsgRet	:= "**EFETIVADO**"+CRLF+"Voucher código "+cCodVou+" ja existe para Pedido "+cPedVou+"!"		
			EndIf
				
			If lOk
				nPedNot++
				If nPedNot == 1
					cXmlCat	:= XML_VERSION+CRLF
					cXmlCat	+= "<NotificaVoucher>"+CRLF
					cXmlCat	+= "<tipo>H</tipo>"+CRLF
				EndIf 
				cXmlCat	+= "<pedido>"+CRLF
				cXmlCat	+= "<numero>"+Alltrim(cPedVou)+"</numero>"+CRLF
				cXmlCat	+= "<produto>"+Alltrim(cProdVou)+"</produto>"+CRLF
				cXmlCat	+= "<voucher>"+Alltrim(cCodVou)+"</voucher>"+CRLF
				cXmlCat	+= "</pedido>"+CRLF
				
				U_GTPutOUT(cPedVou,"R",cPedVou,{"VNDA620",{.T.,"M00001",cPedVou,cMsgRet}},cPedVou)
			EndIf	
			
			(cAliasSZF)->(DbCloseArea())
		Next
		
		If nPedNot > 0
			
			cXmlCat	+= "</NotificaVoucher>"
	
			oWsObj := WSVVHubServiceService():New()
			
			lOk := oWsObj:sendMessage(cCategory,cXmlCat)
				
			cSvcError   := GetWSCError()  // Resumo do erro
			cSoapFCode  := GetWSCError(2)  // Soap Fault Code
			cSoapFDescr := GetWSCError(3)  // Soap Fault Description
				
			If !empty(cSoapFCode)
				//Caso a ocorrência de erro esteja com o fault_code preenchido ,
				//a mesma teve relação com a chamada do serviço . 
				Conout('[VNDA620]'+cSoapFDescr + ' ' + cSoapFCode)
				cMsgRet	:= cSoapFDescr + ' ' + cSoapFCode
				lOk 	:= .F.
			ElseIf !Empty(cSvcError)
				//Caso a ocorrência não tenha o soap_code preenchido 
				//Ela está relacionada a uma outra falha , 
				//provavelmente local ou interna.
				Conout('[VNDA620] FALHA INTERNA DE EXECUCAO DO SERVIÇO'+cSvcError)
				lOk := .F.
				cMsgRet	:= cSvcError
			Endif
				
			If lOk
			
				oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
				
				If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1" .AND. Empty(cError)
					lOk := .T.					
					
				ElseIf !Empty(cError)
					conout("[VNDA620] Erro no parser do xml enviado pelo HUB "+cError)
					lOk := .F.	
					cMsgRet	:= cError
				Else
					conout("[VNDA620] Erro no retorno do HUB "+oWsRes:_CONFIRMATYPE:_MSG:TEXT)
					lOk := .F.
					cMsgRet	:= oWsRes:_CONFIRMATYPE:_MSG:TEXT
				EndIf
				
				FreeObj(oWsRes)
				FreeObj(oWsObj)
				FreeObj(oXml)
				DelClassIntf()
			EndIf
		Else
			Conout("[VNDA620] ERRO GERAR VOUCHER "+cMsgRet)
		EndIf
	Else
		lOk := .F.
		cMsgRet	:= cError
	EndIf
Return({lOk,cMsgRet})