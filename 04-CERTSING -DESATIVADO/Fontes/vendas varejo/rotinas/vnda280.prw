#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA280 ºAutor  ³Darcio R. Sporl     º Data ³  03/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte criado para enviar todas as tabelas de preco para dar º±±
±±º          ³carga ao HUB.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA280(_lJob)

Local cXml		:= ""
Local cCodAnt	:= ""
Local cCodTbA	:= ""
Local cCodTab	:= ""
Local nQtdDe	:= 0
Local nQtdAt	:= 0
Local cQryDA	:= ""
Local cCategory := "ATUALIZA-PRODUTO"
Local cError	:= ""
Local cWarning	:= ""
Local cTabPrc	:= ""
Local lOk		:= .T.
Local aTabs		:= {}
Local oWsObj
Local oWsRes
Local cJobEmp	:= GETJOBPROFSTRING ("JOBEMP", "01")
Local cJobFil	:= GETJOBPROFSTRING ("JOBFIL", "02")

Default _lJob 	:= .T.

If _lJob
	RpcSetType(3)
	RpcSetEnv(cJobEmp, cJobFil)
EndIf

cTabPrc	:= GetMV("MV_XTABPRC",,"001,002")

cQryDA := " SELECT DA1_CODPRO, DA1_QTDLOT, DA1_PRCVEN, DA1_CODTAB, DA1_CODCOB, DA1_CODGAR, MAX(DA1.R_E_C_N_O_) RECDA1, SB1.B1_DESC, SB1.B1_PRV1, SB1.B1_PESBRU "
cQryDA += " FROM " + RetSqlName("DA1") + " DA1 "
cQryDA += " INNER JOIN " + RetSqlName("DA0") + " DA0 ON DA0.DA0_FILIAL = '" + xFilial("DA0") + "' AND DA0.D_E_L_E_T_ = ' ' AND DA0.DA0_CODTAB = DA1.DA1_CODTAB AND DA0.DA0_XFLGEN = ' ' "
cQryDA += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = DA1.DA1_CODPRO AND SB1.B1_PRV1 > 0 AND SB1.D_E_L_E_T_ = ' ' "
cQryDA += " WHERE DA1.DA1_FILIAL = '" + xFilial("DA1") + "' "
cQryDA += "   AND DA1.DA1_ATIVO = '1' "
cQryDA += "   AND DA1.DA1_PRCVEN > 0 "
cQryDA += "   AND DA1.D_E_L_E_T_ = ' ' "
cQryDA += " GROUP BY DA1_CODPRO, DA1_QTDLOT, DA1_PRCVEN, DA1_CODTAB, DA1_CODCOB, DA1_CODGAR, SB1.B1_DESC, SB1.B1_PRV1, SB1.B1_PESBRU "
cQryDA += " ORDER BY DA1_CODPRO, DA1_CODTAB "
	
cQryDA := ChangeQuery(cQryDA)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDA),"QRYDA",.F.,.T.)
DbSelectArea("QRYDA")
 
QRYDA->(DbGoTop())
If QRYDA->(!Eof())

	cXml := XML_VERSION + CRLF
	cXml += '<listProdutoType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">' + CRLF
	cXml += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro
	cXml += '    <msg>Solicitação das informações do(s) produto(s) ok.</msg>' + CRLF
	cXml += '    <exception></exception>' + CRLF
	cCodAnt := ""
	cCodTbA := ""
	cCodTab := ""

	While QRYDA->(!Eof())
		If !(QRYDA->DA1_CODTAB $ cTabPrc)
			QRYDA->(DbSkip())
			Loop
		EndIf
	
		If QRYDA->DA1_QTDLOT = 999999.99
			nQtdDe  := 1
			nQtdAt	:= 999999	
		Else
			nQtdDe++
			nQtdAt += IIF(QRYDA->DA1_QTDLOT > nQtdDe,QRYDA->DA1_QTDLOT,nQtdDe++  )
		EndIf
		
		If cCodTab <> QRYDA->DA1_CODTAB
			aAdd(aTabs, QRYDA->DA1_CODTAB)
			cCodTab := QRYDA->DA1_CODTAB
		EndIf
		
		If cCodAnt <> QRYDA->DA1_CODPRO
			cXml += '	<produto>' + CRLF
			cXml += '		<descricao>' + AllTrim(QRYDA->B1_DESC) + '</descricao>' + CRLF
			cXml += '		<codProd>' + AllTrim(QRYDA->DA1_CODPRO) + '</codProd>' + CRLF
			//cXml += '		<vlUnid>' + AllTrim(Transform(QRYDA->B1_PRV1,"999999.99")) + '</vlUnid>' + CRLF			
			cXml += '		<pesoKg>' + AllTrim(Transform(QRYDA->B1_PESBRU,"999999.99")) + '</pesoKg>' + CRLF
			DbSelectArea("SB5")
			SB5->(DbSetOrder(1))
			If SB5->(DbSeek(xFilial("SB5")+QRYDA->DA1_CODPRO))
				cXml += '		<comprimentoCm>' + AllTrim(Transform(SB5->B5_COMPR,"999999.99")) + '</comprimentoCm>' + CRLF
				cXml += '		<alturaCm>' + AllTrim(Transform(SB5->B5_ESPESS,"999999.99")) + '</alturaCm>' + CRLF
				cXml += '		<larguraCm>' + AllTrim(Transform(SB5->B5_LARG,"999999.99")) + '</larguraCm>' + CRLF
			EndIf
			cXml += '		<vlDeclarado>' + AllTrim(Transform(QRYDA->B1_PRV1,"999999.99")) + '</vlDeclarado>' + CRLF			
		EndIf
	
		cXml += '		<faixa>' + CRLF
		cXml += '			<minimo>' + AllTrim(Transform(nQtdDe,"999999999")) + '</minimo>' + CRLF
		cXml += '			<maximo>' + AllTrim(Transform(nQtdAt,"999999999")) + '</maximo>' + CRLF
		cXml += '			<valor>' + AllTrim(Transform(QRYDA->DA1_PRCVEN,"999999.99")) + '</valor>' + CRLF
		cXml += '			<tabelaPreco>' + AllTrim(QRYDA->DA1_CODTAB) + '</tabelaPreco>' + CRLF
		cXml += '			<codFaixa>' + AllTrim(Str(QRYDA->RECDA1)) + '</codFaixa>' + CRLF
		cXml += '			<codProdGAR>' + AllTrim(QRYDA->DA1_CODGAR) + '</codProdGAR>' + CRLF
		cXml += '			<codCombo>' + AllTrim(QRYDA->DA1_CODCOB) + '</codCombo>' + CRLF
		cXml += '		</faixa>' + CRLF
	
		nQtdDe 	:= nQtdAt
		cCodAnt	:= QRYDA->DA1_CODPRO
		cCodTbA	:= QRYDA->DA1_CODTAB
	
		QRYDA->(DbSkip())
	
		If cCodTbA <> QRYDA->DA1_CODTAB
			nQtdDe := 0
		EndIf
	
		If cCodAnt <> QRYDA->DA1_CODPRO .Or. QRYDA->(Eof())
			nQtdDe := 0
			cXml += '	</produto>' + CRLF
		EndIf
	End
	cXml += '</listProdutoType>' + CRLF

	DbSelectArea("QRYDA")
	QRYDA->(DbCloseArea())
	
	oWsObj := WSVVHubServiceService():New()
	
	lOk := oWsObj:sendMessage(cCategory,cXml)
	
	cSvcError   := GetWSCError()  // Resumo do erro
	cSoapFCode  := GetWSCError(2)  // Soap Fault Code
	cSoapFDescr := GetWSCError(3)  // Soap Fault Description
	
	If !empty(cSoapFCode)
		//Caso a ocorrência de erro esteja com o fault_code preenchido ,
		//a mesma teve relação com a chamada do serviço . 
		Conout(cSoapFDescr + " " + cSoapFCode)
		Return
	ElseIf !Empty(cSvcError)
		//Caso a ocorrência não tenha o soap_code preenchido 
		//Ela está relacionada a uma outra falha , 
		//provavelmente local ou interna.
		Conout('FALHA INTERNA DE EXECUCAO DO SERVIÇO ' + cSvcError)
		Return
	Endif
	
	If lOk
		oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
	
		If "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
			If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
				DbSelectArea("DA0")
				DbSetOrder(1)
				
				For nI := 1 To Len(aTabs)
					DbSeek(xFilial("DA0") + aTabs[nI])
					RecLock("DA0", .F.)
						Replace DA0->DA0_XFLGEN With "X"
					DA0->(MsUnLock())
				Next nI
				
				Conout(oWsRes:_CONFIRMATYPE:_MSG:TEXT)
			Else
				Conout(oWsRes:_CONFIRMATYPE:_MSG:TEXT)
			EndIf
		Else
			Conout('Não foi possível comunicação com o HUB, então não foi possível atualizar a tabela de preço no site Vendas Varejo. Favor contatar o Administrador do sistema.')
		EndIf
	Else
		Conout('Não foi possível comunicação com o HUB, então não foi possível atualizar a tabela de preço no site Vendas Varejo. Favor contatar o Administrador do sistema.')
	EndIf
EndIf

Return