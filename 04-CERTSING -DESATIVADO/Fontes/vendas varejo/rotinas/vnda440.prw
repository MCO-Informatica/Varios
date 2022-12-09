#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
#DEFINE STRMESSAGE		'Não foi possível comunicação com o site vendas varejo, então não será possível atualizar o Voucher. Favor contatar o Administrador do sistema.'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA440  ºAutor  ³Darcio R. Sporl     º Data ³  19/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para validar a utilizacao do Voucher via      º±±
±±º          ³WebService, para o projeto vendas varejo.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA440(cCodVou)
	Local aArea		:= GetArea()
	Local lRet		:= .T.
	Local cXml		:= ""
	Local cError	:= ""
	Local cWarning	:= ""
	Local cMsg		:= ""
	Local cAliasTab	:= ""
	Local cFatura	:= ""
	Local cStatus	:= ""
	Local cTipFat	:= ""
	Local lOk		:= .T.
	Local oWsObj
	Local oWsRes

	Default cCodVou := ""

	If !Empty(cCodVou)
		cAliasTab := "SZF"
		SZF->(DbSetOrder(2))
		SZF->(DbSeek(xFilial("SZF")+cCodVou))
	Else
		cAliasTab := "M"	
	EndIf

	dbSelectArea('SZH')
	SZH->( dbSetOrder(1) )
	SZH->( dbSeek( xFilial('SZH') + AllTrim(&(cAliasTab+"->ZF_TIPOVOU")) ) )
	
	IF Empty( SZH->ZH_EMNTVEN )
		cFatura := 'N'
	Else
		cFatura := AllTrim( SZH->ZH_EMNTVEN )
	EndIF
	
	If &(cAliasTab+"->ZF_TPFATUR") == "P"
		cTipFat := 'Postecipado'
	ElseIf &(cAliasTab+"->ZF_TPFATUR") == "A"
		cTipFat := 'Antecipado'			
	EndIF

	cAno	:= StrZero(Year(&(cAliasTab+"->ZF_DTVALID")),4)
	cMes	:= StrZero(Month(&(cAliasTab+"->ZF_DTVALID")),2)
	cDia	:= StrZero(Day(&(cAliasTab+"->ZF_DTVALID")),2)
	cData	:= cDia + "/" + cMes + "/" + cAno
	
	IF &(cAliasTab+"->ZF_ATIVO") == 'S'
		cStatus := '1'
	Else
		cStatus := '2'
	EndIF

	cXml := XML_VERSION + CRLF
	cXml += '<listVoucherType>' + CRLF
	cXml += '	<code>1</code>' + CRLF
	cXml += '	<msg>Consulta concluída com sucesso.</msg>' + CRLF
	cXml += '	<exception></exception>' + CRLF
	cXml += '	<voucher>' + CRLF
	cXml += '		<codigo>' + AllTrim(&(cAliasTab+"->ZF_COD")) + '</codigo>' + CRLF
	cXml += '		<fluxo>' + AllTrim(&(cAliasTab+"->ZF_CODFLU")) + '</fluxo>' + CRLF
	cXml += '		<tipovoucher>' + AllTrim(&(cAliasTab+"->ZF_TIPOVOU")) + '</tipovoucher>' + CRLF
	cXml += '		<descri>' + AllTrim( SZH->ZH_DESCRI ) + '</descri>' + CRLF
	cXml += '		<codProd>' + AllTrim(&(cAliasTab+"->ZF_PRODEST")) + '</codProd>' + CRLF
	cXml += '		<codProdGar>' + AllTrim(&(cAliasTab+"->ZF_PDESGAR")) + '</codProdGar>' + CRLF
	cXml += '		<qtd>' + AllTrim(Transform(&(cAliasTab+"->ZF_QTDVOUC"),"999999999")) + '</qtd>' + CRLF
	cXml += '		<dtValid>' + cData + '</dtValid>' + CRLF
	cXml += '		<motivo>' + AllTrim(&(cAliasTab+"->ZF_DESMOT")) + '</motivo>' + CRLF
	cXml += '		<obs>' + AllTrim(&(cAliasTab+"->ZF_OBS")) + '</obs>' + CRLF
	cXml += '		<status>' + cStatus + '</status>' + CRLF
	cXml += '		<fatura>' + cFatura + '</fatura>' + CRLF
	cXml += '		<tipfat>' + cTipFat + '</tipfat>' + CRLF
	cXml += '		<grupo>' + AllTrim(&(cAliasTab+"->ZF_GRPPROJ")) + '</grupo>' + CRLF
	cXml += '		<codrev>' + AllTrim(&(cAliasTab+"->ZF_CODREV")) + '</codrev>' + CRLF
	cXml += '		<cpf>' + AllTrim(&(cAliasTab+"->ZF_CPF")) + '</cpf>' + CRLF
	cXml += '	</voucher>' + CRLF
	cXml += '</listVoucherType>' + CRLF

	oWsObj := WSHAWSProviderService():New()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia XML com atualizacao do Voucher³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lOk := oWSObj:atualizaVoucher(cXml)

	cSvcError   := GetWSCError()  // Resumo do erro
	cSoapFCode  := GetWSCError(2)  // Soap Fault Code
	cSoapFDescr := GetWSCError(3)  // Soap Fault Description

	If !empty(cSoapFCode)
		//Caso a ocorrência de erro esteja com o fault_code preenchido ,
		//a mesma teve relação com a chamada do serviço .
		lRet := .F.
		cMsg := cSoapFDescr + " " + cSoapFCode
		Return({lRet, cMsg})
	ElseIf !Empty(cSvcError)
		//Caso a ocorrência não tenha o soap_code preenchido 
		//Ela está relacionada a uma outra falha , 
		//provavelmente local ou interna.
		lRet := .F.
		cMsg := cSvcError
		Return({lRet, cMsg})
	Endif

	If lOk
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pega retorno da atualizacao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oWsRes := XmlParser( oWSObj:CRETURN, "_", @cError, @cWarning )

		If "confirmaType" $ oWSObj:CRETURN
			If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
				cMsg := oWsRes:_CONFIRMATYPE:_MSG:TEXT
				Conout(oWsRes:_CONFIRMATYPE:_MSG:TEXT)
			Else
				lRet := .F.
				cMsg := oWsRes:_CONFIRMATYPE:_MSG:TEXT
				Conout(oWsRes:_CONFIRMATYPE:_MSG:TEXT)
			EndIf
		Else
			lRet := .F.
			cMsg := STRMESSAGE
			Conout(STRMESSAGE)
		EndIf
	Else
		lRet := .F.
		cMsg := STRMESSAGE
		Conout(STRMESSAGE)
	EndIf

	RestArea(aArea)              

Return({lRet, cMsg})