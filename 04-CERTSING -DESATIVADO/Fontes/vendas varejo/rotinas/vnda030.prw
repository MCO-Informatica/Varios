#Include 'Protheus.ch'

#DEFINE STRPROD	'Não foi possível comunicação com o HUB, então não foi possível atualizar a tabela de preço no site Vendas Varejo. Favor contatar o Administrador do sistema.'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA030  ºAutor  ³Darcio R. Sporl     º Data ³  20/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte criado para avisar ao HUB as alteracoes realizadas nasº±±
±±º          ³tabelas de preco do Protheus.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA030(cDocument, cCodTab)
Local aArea		:= GetArea()
Local cCategory := "ATUALIZA-TABELA-PRECO"
Local cError	:= ""
Local cWarning	:= ""
Local lOk		:= .T.
Local lRet		:= .T.
Local oWsObj
Local oWsRes
// Local cXWSHUB	:= GetNewPar("MV_XWSHUB", "http://192.168.1.184:8080/VVHub/VVHubService")

MsProcTxt("Comunicando HUB - ATUALIZA-TABELA-PRECO")
 
oWsObj := WSVVHubServiceService():New()
                    
lOk := oWsObj:sendMessage(cCategory,cDocument)

cSvcError   := GetWSCError()  // Resumo do erro
cSoapFCode  := GetWSCError(2)  // Soap Fault Code
cSoapFDescr := GetWSCError(3)  // Soap Fault Description

If lOk
	
	If empty(oWsObj:CSENDMESSAGERESPONSE)
		// esta tudo ok, mas o mssageresponse esta vazio ???
		// isto nao deveria acontecer ..... 
		lOk := .f.
		cSvcError   := "CS_ERROR_WS - Empty SendMEssageResponse on WSVVHubServiceService"
		cSoapFCode  := "000"  // Soap Fault Code
		cSoapFDescr := "CS_ERROR_WS - Empty SendMEssageResponse on WSVVHubServiceService"  // Soap Fault Description
		
	Endif
	
Endif


If !empty(cSoapFCode)
	//Caso a ocorrência de erro esteja com o fault_code preenchido ,
	//a mesma teve relação com a chamada do serviço . 
	MsgStop(cSoapFDescr,cSoapFCode)
	Conout(cSoapFDescr + " " + cSoapFCode)

	DbSelectArea("DA0")
	DbSetOrder(1)
	DbSeek(xFilial("DA0") + cCodTab)
	RecLock("DA0", .F.)
		Replace DA0->DA0_XFLGEN With " "
	DA0->(MsUnLock())
                                           	
	Return(.F.)
ElseIf !Empty(cSvcError)
	//Caso a ocorrência não tenha o soap_code preenchido 
	//Ela está relacionada a uma outra falha , 
	//provavelmente local ou interna.
	MsgStop(cSvcError,'FALHA INTERNA DE EXECUCAO DO SERVIÇO')
	Conout('FALHA INTERNA DE EXECUCAO DO SERVIÇO ' + cSvcError)

	DbSelectArea("DA0")
	DbSetOrder(1)
	DbSeek(xFilial("DA0") + cCodTab)
	RecLock("DA0", .F.)
		Replace DA0->DA0_XFLGEN With " "
	DA0->(MsUnLock())

	Return(.F.)
Endif

IF lOk

	oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )

	If "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
		If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
				
			Conout(oWsRes:_CONFIRMATYPE:_MSG:TEXT)
					
		Else
			lRet := .F.
			MsgStop(oWsRes:_CONFIRMATYPE:_MSG:TEXT)
			Conout(oWsRes:_CONFIRMATYPE:_MSG:TEXT)
			DbSelectArea("DA0")
			DbSetOrder(1)
			DbSeek(xFilial("DA0") + cCodTab)
			RecLock("DA0", .F.)
				Replace DA0->DA0_XFLGEN With " "
			DA0->(MsUnLock())
		EndIf
	Else
		lRet := .F.
		MsgStop(STRPROD)
		Conout(STRPROD)
		DbSelectArea("DA0")
		DbSetOrder(1)
		DbSeek(xFilial("DA0") + cCodTab)
		RecLock("DA0", .F.)
			Replace DA0->DA0_XFLGEN With " "
		DA0->(MsUnLock())
	EndIf
Else
	lRet := .F.
	MsgStop(STRPROD)
	Conout(STRPROD)
	DbSelectArea("DA0")
	DbSetOrder(1)
	DbSeek(xFilial("DA0") + cCodTab)
	RecLock("DA0", .F.)
		Replace DA0->DA0_XFLGEN With " "
	DA0->(MsUnLock())
EndIf

RestArea(aArea)
Return(lRet)