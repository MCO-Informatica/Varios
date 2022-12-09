#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"

User Function TMK341GRV(nOpc,nRecno) 
    
	Local _cObs			:= ""
	Local _cMsg			:= ""
	Local _cAssunto		:= "Aviso de Supspect - Nº " + ACH->ACH_CODIGO + "/" + ACH->ACH_LOJA
	Local _cPara		:= ""
	Local _cCopy		:= "bzechetti@totalitsolutions.com.br"
	Local _nI			:= 0
	Local _aEmailHst	:= Separa(GetMV("ES_WFHSTPT",,"000076,000009,000254,000256,000515,000057,000148"),",")
	
	_cObs := "===========================================" +CRLF
	_cObs += "[" + SubStr(DtoS(dDataBase),7,2) + "/" + SubStr(DtoS(dDataBase),5,2) + "/" + SubStr(DtoS(dDataBase),1,4) + " - " + time() + "]"+CRLF
	_cObs += "[ Usuario - " + UsrFullName(__cUserID) + " ]" +CRLF
	_cObs += AllTrim(ACH->ACH_XOBSDI)+CRLF
	_cObs += "===========================================" +CRLF
	_cObs += AllTrim(ACH->ACH_XHISTO)
	
	If (nOpc == 1 .Or. nOpc == 2) .And. !Empty(ACH->ACH_XOBSDI)
		If RecLock("ACH",.F.)
			ACH->ACH_XHISTO	:= _cObs
			ACH->ACH_XOBSDI	:= ""
			ACH->(MsUnLock())
		EndIf
		
		For _nI	:= 1 To Len(_aEmailHst)
		
			_cMsg	:= '<html>'+CRLF
			_cMsg	+= '	<head>'+CRLF
			_cMsg	+= '		<title>Suspect</title>'+CRLF
			_cMsg	+= '	</head> '+CRLF
			_cMsg	+= '	<body> '+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<FONT SIZE = "5" COLOR = "#CD2626"><B><center>Suspect - ' + Alltrim(ACH->ACH_CODIGO) + "/Rev." + ACH->ACH_LOJA  + '</center></B></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Prezado(a) ' + UsrFullName(_aEmailHst[_nI]) +',</p></FONT>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Foi realizado a atualização do histórico do Suspect: </p></FONT>'+CRLF 
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Projeto: ' + ACH->ACH_XPROJE + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Sub Projeto: ' + ACH->ACH_XSPROJ + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Cliente: ' + ACH->ACH_RAZAO + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Contato: ' + ACH->ACH_XNCONT + " - Tel.: " + ACH->ACH_XTCONT + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Histórico: ' + ALLTRIM(ACH->X_XHISTO) + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Grato(a).</p></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '	</body>'+CRLF
			_cMsg	+= '</html>'+CRLF
			
			_cPara		:= AllTrim(UsrRetMail(_aEmailHst[_nI]))
			
			MailDSC(_cPara, _cAssunto, _cMsg, _cCopy)
			
		Next _nI
		
		If !Empty(ACH->ACH_VEND)
		
	   		_cMsg	:= '<html>'+CRLF
			_cMsg	+= '	<head>'+CRLF
			_cMsg	+= '		<title>Suspect</title>'+CRLF
			_cMsg	+= '	</head> '+CRLF
			_cMsg	+= '	<body> '+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<FONT SIZE = "5" COLOR = "#CD2626"><B><center>Suspect - ' + Alltrim(ACH->ACH_CODIGO) + "/Rev." + ACH->ACH_LOJA  + '</center></B></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Prezado(a) ' + SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + ACH->ACH_VEND,1)) +',</p></FONT>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Foi realizado a atualização do histórico do Suspect: </p></FONT>'+CRLF 
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Projeto: ' + ACH->ACH_XPROJE + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Sub Projeto: ' + ACH->ACH_XSPROJ + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Cliente: ' + ACH->ACH_RAZAO + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Contato 1: ' + ACH->ACH_XNCONT + " - Tel.: " + ACH->ACH_XTCONT + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Contato 2: ' + ACH->ACH_XNCON2 + " - Tel.: " + ACH->ACH_XTCON2 + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Contato 3: ' + ACH->ACH_XNCON3 + " - Tel.: " + ACH->ACH_XTCON3 + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Histórico: ' + ALLTRIM(ACH->X_XHISTO) + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Grato(a).</p></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '	</body>'+CRLF
			_cMsg	+= '</html>'+CRLF
	   		
			_cPara		:= SA3->(GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3") + ACH->ACH_VEND,1))
			
			MailDSC(_cPara, _cAssunto, _cMsg, _cCopy)
			
		EndIf
		
	EndIf

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