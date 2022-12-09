#Include "Protheus.CH"
#Include "RwMake.Ch"
#Include "TopConn.CH"

User Function M415GRV()

	Local _aArea		:= GetArea()
	Local _cMsg			:= ""
	Local _cAssunto		:= "Aviso de Orçamento - Nº " + SCJ->CJ_NUM
	Local _cPara		:= ""
	Local _aCopy		:= Separa(GetMv("ES_HWCMORC",,"000148"),",")
	Local _cCopy		:= ""
	Local _cVend		:= ""
	Local _cUser		:= ""
	Local _cTarefa		:= ""
	Local _nI			:= 0
	Local _cQuery		:= ""
	Local _cAliasQry	:= ""
	Local _nValor		:= 0

	If INCLUI .Or. ALTERA
		If 0=1 //SCJ->CJ_XSTAORC == "F"
			_cAliasQry	:= GetNextAlias()
			
			_cQuery		:= "SELECT SUM(CK_PRCVEN) AS VALOR "
			_cQuery		+= " FROM " + RetSqlName("SCK")
			_cQuery		+= " WHERE CK_FILIAL = '" + XFILIAL("SCK") + "' "
			_cQuery		+= " AND CK_NUM = '" + SCJ->CJ_NUM + "'"
			_cQuery		+= " AND CK_CLIENTE	= '" + SCJ->CJ_CLIENTE + "'"
			_cQuery		+= " AND CK_LOJA = '" + SCJ->CJ_LOJA + "'"			
			TcQuery _cQuery	New Alias(_cAliasQry)
			If (_cAliasQry)->(!EOF())
				_nValor	:= (_cAliasQry)->VALOR
				(_cAliasQry)->(dbSkip())
			EndIf
			(_cAliasQry)->(dbCloseArea())
			
			dbSelectArea("SZQ")
			SZQ->(dbSetOrder(1))
			If SZQ->(dbSeek(xFilial("SZQ") + SCJ->CJ_NUM))
				If !Empty(SZQ->ZQ_CONTATO)
					_cVend	:= SU5->(GetAdvFVal("SU5","U5_VEND",xFilial("SU5") + SZQ->ZQ_CONTATO,1))
					If Empty(_cVend)
						_cVend	:= SU5->(GetAdvFVal("SU5","U5_VEND",xFilial("SU5") + SZQ->ZQ_CONTATO,2))
					EndIf
					If !Empty(_cVend)
						For _nI	:= 1 To Len(_aCopy)
							_cCopy	+= Iif(Empty(_cCopy),"",";") + AllTrim(UsrRetMail(_aCopy[_nI]))
						Next _nI
						_cPara	:= SA3->(GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3") + _cVend,1))
						_cVend	:= SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + _cVend,1))
						
						_cMsg	:= '<html>'+CRLF
						_cMsg	+= '	<head>'+CRLF
						_cMsg	+= '		<title>Orçamento</title>'+CRLF
						_cMsg	+= '	</head> '+CRLF
						_cMsg	+= '	<body> '+CRLF
						_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
						_cMsg	+= '		<FONT SIZE = "5" COLOR = "#238E23"><B><center>Orçamento - ' + Alltrim(SCJ->CJ_NUM) + '</center></B></FONT>'+CRLF
						_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
						_cMsg	+= '		<p>'+CRLF
						_cMsg	+= '		<FONT COLOR = "#238E23"><p>Prezado(a) ' + _cVend +',</p></FONT>'+CRLF
						_cMsg	+= '		<p>'+CRLF
						_cMsg	+= '		<FONT COLOR = "#238E23"><p>Foi finalizada a inclusão da proposta: </p></FONT>'+CRLF 
						_cMsg	+= '		<FONT COLOR = "#238E23"><p>Cliente: ' + POSICIONE("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_NOME") + '.</p></FONT>'+CRLF
						_cMsg	+= '		<FONT COLOR = "#238E23"><p>Contato: ' + POSICIONE("SU5",1,xFilial("SU5") + SCJ->CJ_CONTATO,"U5_CONTAT") + '.</p></FONT>'+CRLF
						_cMsg	+= '		<FONT COLOR = "#238E23"><p>Valor: ' + Transform(_nValor,"@E 9,999,999,999.99") + '.</p></FONT>'+CRLF
						If SCJ->(FieldPos("CJ_XDTPREV")) > 0
							If !Empty(SCJ->CJ_XDTPREV)
								_cMsg	+= '		<FONT COLOR = "#238E23"><p>Com data prevista de encerramento ' + SubStr(DtoS(SCJ->CJ_XDTPREV),7,2) + "/" + SubStr(DtoS(SCJ->CJ_XDTPREV),5,2) + "/" +SubStr(DtoS(SCJ->CJ_XDTPREV),1,4) + '.</p></FONT>'+CRLF
							EndIf
						EndIf
						_cMsg	+= '		<FONT COLOR = "#238E23"><p>** Acesse o portal do vendedor e nos posicione com o FOLLOW-UP sobre a conclusão da proposta.</p></FONT>'+CRLF
						_cMsg	+= '		<FONT COLOR = "#238E23"><p>Grato(a).</p></FONT>'+CRLF
						_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
						_cMsg	+= '	</body>'+CRLF
						_cMsg	+= '</html>'+CRLF
						
						MailDSC(_cPara, _cAssunto, _cMsg, _cCopy)
					EndIf
				EndIf
			EndIf
			If SCJ->CJ_CLASSI $ '1|2'
				_cUser		:= SA3->(GetAdvFVal("SA3","A3_CODUSR",xFilial("SA3") + SCJ->CJ_CONTATO,1))
				If !Empty(_cUser)
					_cTarefa	:= GetSx8Num("AD8","AD8_TAREFA") 
					If RecLock("AD8",.T.)
						AD8->AD8_FILIAL	:= xFilial("AD8")
						AD8->AD8_TAREFA := GetSx8Num("AD8","AD8_TAREFA")
						AD8->AD8_CODUSR	:= _cUser
						AD8->AD8_TOPICO := "Orçamento - " + SCJ->CJ_NUM
						AD8->AD8_DTINI	:= SCJ->CJ_XDTPREV
						AD8->AD8_STATUS	:= '1'
						AD8->AD8_PRIOR	:= '2'
						AD8->AD8_CODCLI	:= SCJ->CJ_CLIENTE
						AD8->AD8_LOJCLI	:= SCJ->CJ_LOJA
						AD8->(MsUnLock())
					EndIf
				EndIf
			EndIf
		EndIf
		
		If 0=1 //!Empty(SCJ->CJ_XDTPREV)
			dbSelectarea("SZQ")
			SZQ->(dbSetORder(1))
			If SZQ->(dbSeek(xFilial("SZQ")+SCJ->CJ_NUM))
				If RecLock("SZQ",.F.)
					SZQ->ZQ_D_FOLLO	:= SCJ->CJ_XDTPREV
					SZQ->(MsUnLock())
				EndIf
			EndIF
		EndIF
		
	EndIf

	RestArea(_aArea)
	
Return()


//-------------------------------------------------------------------
/*/{Protheus.doc} MailDSC
Funcao para envio de email em caso de conta SMTP usar criptografia TLS

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/10/2014
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function MailDSC(cPara, cAssunto, cMsg, cCC)

	Local oMail 
	Local oMessage
	Local nErro
	Local lRet 			:= .T.
	Local cSMTPServer	:= Alltrim(GetMV("MV_WFSMTP"))
	Local cSMTPUser		:= Alltrim(GetMV("MV_WFAUTUS"))
	Local cSMTPPass		:= Alltrim(GetMV("MV_WFAUTSE"))
	Local cMailFrom		:= cSMTPUser
	Local nPort	   		:= 587
	Local lUseAuth		:= .T.
	
	conout('Conectando com SMTP ['+cSMTPServer+'] ')
	oMail := TMailManager():New()
//	oMail:SetUseTLS(.t.)
	conout('Inicializando SMTP')
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )
	oMail:SetSmtpTimeOut( 30 )
	conout('Conectando com servidor...')
	nErro := oMail:SmtpConnect()
	
	If lUseAuth
		nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
		If nErro <> 0
			cMAilError := oMail:GetErrorString(nErro)
			DEFAULT cMailError := '***UNKNOW***'
			conout("Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')')
			lRet := .F.
		EndIf
	EndIf
	
	If nErro <> 0
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		conout(cMAilError)
		
		conout("Erro de Conexão SMTP "+str(nErro,4))
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
		lRet := .F.
	EndIf 
	
	If lRet
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom		:= cMailFrom
		oMessage:cTo		:= cPara
		oMessage:cCC		:= cCC
		oMessage:cSubject	:= cAssunto
		oMessage:cBody		:= cMsg
		
		conout('Enviando Mensagem para ['+cPara+'] ')
		nErro := oMessage:Send( oMail )
		
		If nErro <> 0
			xError := oMail:GetErrorString(nErro)
			conout("Erro de Envio SMTP "+str(nErro,4)+" ("+xError+")")
			lRet := .F.
		Else
			conout("Mensagem enviada com sucesso!")
		EndIf
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
	EndIf
Return lRet