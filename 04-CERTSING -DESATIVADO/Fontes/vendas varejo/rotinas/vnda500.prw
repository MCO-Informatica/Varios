#INCLUDE "PROTHEUS.CH"
#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA500   ºAutor  ³OPVS (David)        º Data ³  27/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de exportacao de arquivo TXT em layout especifico º±±
±±º          ³ para importacao pelo sistema GAR de vouchers utilizados    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VNDA500(aParSch)
	Local cCategory := "ATUALIZA-VOUCHER"
	Local cError	:= ""
	Local cWarning	:= ""
	Local lOk		:= .T.
	Local oWsObj
	Local oWsRes
	Local lReturn	:= .T.
	Local cQrySZF	:= ""
	Local cData		:= ""
	Local cAno		:= ""
	Local cDia		:= ""
	Local cMes		:= ""
	Local aVouchers	:= {}
	Local aVouchersD:= {}
	Local nI		:= 0
	Local cXml		:= ""
	Local cFatura	:= ""
	Local cStatus	:= ""
	Local cTipFat	:= ""
	Local _lJob 	:= ( Select( "SX6" ) == 0 )
	Local cJobEmp	:= Iif( aParSch == NIL, '01' , aParSch[ 1 ] )
	Local cJobFil	:= Iif( aParSch == NIL, '02' , aParSch[ 2 ] )
	
	If _lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp, cJobFil)
	EndIf
	
	// Pego todos os voucher ativos e que nao foram enviados para o site
	cQrySZF := "SELECT ZF_COD, ZF_PRODEST, ZF_QTDVOUC, ZF_TPFATUR, ZF_DTVALID, ZF_OBS,  ZF_DESTIPO,  ZF_DESMOT, ZF_CODFLU, ZF_ATIVO, ZF_PDESGAR, ZF_TIPOVOU, ZF_GRPPROJ, ZF_CODREV, ZF_CPF, R_E_C_N_O_ RECSZF, D_E_L_E_T_ RECDEL "
	cQrySZF += "FROM " + RetSqlName("SZF") + " "
	cQrySZF	+= "WHERE ZF_FILIAL = '" + xFilial("SZF") + "' "
	cQrySZF += "  AND ZF_ATIVO = 'S' "
	cQrySZF += "  AND ZF_FLAGSIT = ' ' "
	cQrySZF += "  AND ZF_SALDO > 0 " 
	cQrySZF += "  AND ZF_PRODEST <> ' ' "
	cQrySZF += "  AND ZF_DTVALID >= '"+DtoS(Date())+"' "
	cQrySZF += "  AND ROWNUM <= 1000 "
	cQrySZF += "  AND D_E_L_E_T_ = ' ' "
	cQrySZF += "UNION ALL "
	cQrySZF += "SELECT ZF_COD, ZF_PRODEST, ZF_QTDVOUC, ZF_TPFATUR, ZF_DTVALID, ZF_OBS,  ZF_DESTIPO,  ZF_DESMOT, ZF_CODFLU, ZF_ATIVO, ZF_PDESGAR, ZF_TIPOVOU, ZF_GRPPROJ, ZF_CODREV, ZF_CPF, R_E_C_N_O_ RECSZF, D_E_L_E_T_ RECDEL "
	cQrySZF += "FROM " + RetSqlName("SZF") + " "
	cQrySZF	+= "WHERE ZF_FILIAL = '" + xFilial("SZF") + "' "
	cQrySZF += "  AND ZF_FLAGSIT = ' ' "
	cQrySZF += "  AND ROWNUM <= 500 "
	cQrySZF += "  AND D_E_L_E_T_ = '*' "
	cQrySZF := ChangeQuery(cQrySZF)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySZF),"QRYSZF",.F.,.T.)
	DbSelectArea("QRYSZF")
	
	QRYSZF->(DbGoTop())
	If QRYSZF->(!Eof())
		cXml := XML_VERSION + CRLF
		cXml += '<listVoucherType>' + CRLF
		cXml += '	<code>1</code>' + CRLF
		cXml += '	<msg>Consulta concluída com sucesso.</msg>' + CRLF
		cXml += '	<exception></exception>' + CRLF
		
		While QRYSZF->(!Eof())
			DbSelectArea("SZF")
			SZF->(DbGoTo(QRYSZF->RECSZF))

			If Empty(QRYSZF->RECDEL)
				aAdd(aVouchers, QRYSZF->RECSZF)
			Else
				aAdd(aVouchersD, QRYSZF->RECSZF)
			EndIf

			dbSelectArea('SZH')
			SZH->( dbSetOrder(1) )
			SZH->( dbSeek( xFilial('SZH') + AllTrim(QRYSZF->ZF_TIPOVOU) ) )
			
			IF Empty( SZH->ZH_EMNTVEN )
				cFatura := 'N'
			Else
				cFatura := AllTrim( SZH->ZH_EMNTVEN )
			EndIF

			If QRYSZF->ZF_TPFATUR == "P"
				cTipFat := 'Postecipado'
			ElseIf QRYSZF->ZF_TPFATUR == "A"
				cTipFat := 'Antecipado'
			Else
				cTipFat := ''
			EndIf

			cData	:= StoD(QRYSZF->ZF_DTVALID)
			cAno	:= StrZero(Year(cData),4)
			cMes	:= StrZero(Month(cData),2)
			cDia	:= StrZero(Day(cData),2)
			cData	:= cDia + "/" + cMes + "/" + cAno
			
			If QRYSZF->ZF_ATIVO == 'S' .AND. Empty(QRYSZF->RECDEL)
				cStatus := '1'
			Else
				cStatus := '2'
			EndIf

			cXml += '	<voucher>' + CRLF
			cXml += '		<codigo>' + AllTrim(QRYSZF->ZF_COD) + '</codigo>' + CRLF
			cXml += '		<fluxo>' + AllTrim(QRYSZF->ZF_CODFLU) + '</fluxo>' + CRLF
			cXml += '		<tipovoucher>' + AllTrim(QRYSZF->ZF_TIPOVOU) + '</tipovoucher>' + CRLF
			cXml += '		<descri>' + AllTrim( SZH->ZH_DESCRI ) + '</descri>' + CRLF
			cXml += '		<codProd>' + AllTrim(QRYSZF->ZF_PRODEST) + '</codProd>' + CRLF
			cXml += '		<codProdGar>' + AllTrim(QRYSZF->ZF_PDESGAR) + '</codProdGar>' + CRLF
			cXml += '		<qtd>' + AllTrim(Transform(QRYSZF->ZF_QTDVOUC,"999999999")) + '</qtd>' + CRLF
			cXml += '		<dtValid>' + cData + '</dtValid>' + CRLF
			cXml += '		<motivo>' + AllTrim(QRYSZF->ZF_DESMOT) + '</motivo>' + CRLF
			cXml += '		<obs>' + AllTrim(QRYSZF->ZF_OBS) + '</obs>' + CRLF
			cXml += '		<status>' + cStatus + '</status>' + CRLF
			cXml += '		<fatura>' + cFatura + '</fatura>' + CRLF
			cXml += '		<tipfat>' + cTipFat + '</tipfat>' + CRLF
			cXml += '		<grupo>' + AllTrim(QRYSZF->ZF_GRPPROJ) + '</grupo>' + CRLF
			cXml += '		<codrev>' + AllTrim(QRYSZF->ZF_CODREV) + '</codrev>' + CRLF
			cXml += '		<cpf>' + AllTrim(QRYSZF->ZF_CPF) + '</cpf>' + CRLF
			cXml += '	</voucher>' + CRLF
			
			QRYSZF->(DbSkip())
			
		End
		cXml += '</listVoucherType>' + CRLF
		
		oWsObj := WSVVHubServiceService():New()
	
		lOk := oWsObj:sendMessage(cCategory,cXml)
	
		cSvcError   := GetWSCError()  // Resumo do erro
		cSoapFCode  := GetWSCError(2)  // Soap Fault Code
		cSoapFDescr := GetWSCError(3)  // Soap Fault Description
		
		If !empty(cSoapFCode)
			//Caso a ocorrência de erro esteja com o fault_code preenchido ,
			//a mesma teve relação com a chamada do serviço . 
			Conout(cSoapFDescr + ' ' + cSoapFCode)
		ElseIf !Empty(cSvcError)
			//Caso a ocorrência não tenha o soap_code preenchido 
			//Ela está relacionada a uma outra falha , 
			//provavelmente local ou interna.
			Conout(cSvcError + ' FALHA INTERNA DE EXECUCAO DO SERVIÇO')
		Endif
	
		If lOk
			oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
	
			If "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
				If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
					lOk :=.T.
				Else
					Conout(oWsRes:_CONFIRMATYPE:_MSG:TEXT)
					lOk :=.F.
				EndIf
			Else
				lOk :=.F.
			EndIf
		Else
			lOk :=.F.
			Conout('Não foi possível comunicação com o HUB, então não foi possível notificar os pagamentos dos pedidos no site Vendas Varejo. Favor contatar o Administrador do sistema.')
		EndIf
		
		If lOk
			DbSelectArea("SZF")
			DbSetOrder(1)
			For nI := 1 To Len(aVouchers)
				SZF->(DbGoTo(aVouchers[nI]))
				RecLock("SZF", .F.)
					Replace SZF->ZF_FLAGSIT With "X"
				SZF->(MsUnLock())
			Next nI
			
			For nI := 1 To Len(aVouchersD)
				SZF->(DbGoTo(aVouchersD[nI]))
				cUpdate := "UPDATE "+RetSqlName("SZF")+" SET ZF_FLAGSIT = 'X' WHERE R_E_C_N_O_ = "+Alltrim(Str(aVouchersD[nI]))+"  "
				
				TcSqlExec(cUpdate)
			Next nI
		EndIf
		QRYSZF->(DbSkip())
	EndIf
	DbSelectArea("QRYSZF")
	QRYSZF->(DbCloseArea())
Return(lOk)
