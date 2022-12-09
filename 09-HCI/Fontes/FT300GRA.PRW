#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} FT300GRA
Rotina para envio de e-mail aos responáveis, sobre o Projeto/Oportunidade.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		//
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function FT300GRA() 
    
	Local _cObs			:= ""
	Local nOpc			:= ParamIXB[1]
	Local _cMsg			:= ""
	Local _cAssunto		:= "Aviso de Projeto/Oportunidade - Nº " + AD1->AD1_NROPOR
	Local _cPara		:= ""
	Local _cCopy		:= "bzechetti@totalitsolutions.com.br"
	Local _nI			:= 0
	Local _aEmailHst	:= Separa(GetMV("ES_WFHSTPT",,"000076,000009,000254,000256,000515,000057,000148"),",")
	
	_cObs := "===========================================" +CRLF
	_cObs += "[" + SubStr(DtoS(dDataBase),7,2) + "/" + SubStr(DtoS(dDataBase),5,2) + "/" + SubStr(DtoS(dDataBase),1,4) + " - " + time() + "]"+CRLF
	_cObs += "[ Usuario - " + UsrFullName(__cUserID) + " ]" +CRLF
	_cObs += AllTrim(AD1->AD1_XOBSDI)+CRLF
	_cObs += "===========================================" +CRLF
	_cObs += AllTrim(AD1->AD1_XHISTO)
	
	If (nOpc == 1 .Or. nOpc == 2) .And. !Empty(AD1->AD1_XOBSDI)
		If RecLock("AD1",.F.)
			AD1->AD1_XHISTO	:= _cObs
			AD1->AD1_XOBSDI	:= ""
			AD1->(MsUnLock())
		EndIf
		
		For _nI	:= 1 To Len(_aEmailHst)
		
			_cMsg	:= '<html>'+CRLF
			_cMsg	+= '	<head>'+CRLF
			_cMsg	+= '		<title>Projetos</title>'+CRLF
			_cMsg	+= '	</head> '+CRLF
			_cMsg	+= '	<body> '+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<FONT SIZE = "5" COLOR = "#000000"><B><center>Projeto/Oportunidade - ' + Alltrim(AD1->AD1_NROPOR) + "/Rev." + AD1->AD1_REVISA  + '</center></B></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Prezado(a) ' + UsrFullName(_aEmailHst[_nI]) +',</p></FONT>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Foi realizado a atualização do histórico do Projeto/Oportunidade: </p></FONT>'+CRLF 
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Projeto: ' + AD1->AD1_XPROJE + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Sub Projeto: ' + AD1->AD1_XSUBPR + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Descrição do projeto: ' + AD1->AD1_XDESCP + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Cliente: ' + POSICIONE("SA1",1,xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI,"A1_NOME") + '.</p></FONT>'+CRLF
//			_cMsg	+= '		<FONT COLOR = "#000000"><p>Contato: ' + POSICIONE("SU5",1,xFilial("SU5") + AD1->AD1_XCONT,"U5_CONTAT") + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Dono: ' + AD1->AD1_XDONO + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Histórico: ' + ALLTRIM(AD1->AD1_XHISTO) + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Grato(a).</p></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '	</body>'+CRLF
			_cMsg	+= '</html>'+CRLF
			
			_cPara		:= AllTrim(UsrRetMail(_aEmailHst[_nI]))
			
			MailDSC(_cPara, _cAssunto, _cMsg, _cCopy)
			
		Next _nI
		
		If !Empty(AD1->AD1_VEND)
		
	   		_cMsg	:= '<html>'+CRLF
			_cMsg	+= '	<head>'+CRLF
			_cMsg	+= '		<title>Projetos</title>'+CRLF
			_cMsg	+= '	</head> '+CRLF
			_cMsg	+= '	<body> '+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<FONT SIZE = "5" COLOR = "#000000"><B><center>Projeto/Oportunidade - ' + Alltrim(AD1->AD1_NROPOR) + "/Rev." + AD1->AD1_REVISA  + '</center></B></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Prezado(a) ' + SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + AD1->AD1_VEND,1)) +',</p></FONT>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Foi realizado a atualização do histórico do Projeto/Oportunidade: </p></FONT>'+CRLF 
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Projeto: ' + AD1->AD1_XPROJE + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Sub Projeto: ' + AD1->AD1_XSUBPR + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Descrição do projeto: ' + AD1->AD1_XDESCP + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Cliente: ' + POSICIONE("SA1",1,xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI,"A1_NOME") + '.</p></FONT>'+CRLF
//			_cMsg	+= '		<FONT COLOR = "#000000"><p>Contato: ' + POSICIONE("SU5",1,xFilial("SU5") + AD1->AD1_XCONT,"U5_CONTAT") + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Dono: ' + AD1->AD1_XDONO + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Histórico: ' + ALLTRIM(AD1->AD1_XHISTO) + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000000"><p>Grato(a).</p></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '	</body>'+CRLF
			_cMsg	+= '</html>'+CRLF
			
			_cPara		:= SA3->(GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3") + AD1->AD1_VEND,1))
			
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
@obs    	Rotina Especifica HCI
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