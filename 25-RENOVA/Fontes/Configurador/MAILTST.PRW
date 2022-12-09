#Include "Protheus.Ch"  

/////////////
// MailDSC //
/////////////

User function MailTST()
	U_Mail("wmendes@renovaenergia.com.br;ronaldo.bicudo@totvs.com.br","Teste Mail","Teste Mail")  
	


User Function Mail(cPara, cAssunto, cMsg)
	Local oMail , oMessage , nErro
	Local lRet := .T.


Local cSMTPServer    := "smtp.office365.com"   
Local cSMTPUser      := "work_flow@renovaenergia.com.br"     
Local cSMTPPass      := "Rnwkl13#@"             
Local cMailFrom      := "work_flow@renovaenergia.com.br"                                               
Local nPort          := 587 
Local lUseAuth       := .T.	

	conout('Conectando com SMTP ['+cSMTPServer+'] ')
	oMail := TMailManager():New()
	oMail:SetUseTLS(.T.)
//	oMail:SetUseSSL(.T.)
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
			Conout("Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')')
			lRet := .F.
		Endif
	Endif
	
	if nErro <> 0
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		conout(cMAilError)
		
		Conout("Erro de Conexão SMTP "+str(nErro,4))
		
		conout('Desconectando do SMTP')                                                         
		
		oMail:SMTPDisconnect()
		lRet := .F.
	Endif
	If lRet
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom		:= cMailFrom
		oMessage:cTo		:= cPara
		oMessage:cSubject	:= cAssunto
		oMessage:cBody		:= cMsg
		
		conout('Enviando Mensagem para ['+cPara+'] ')
		conout('cAssunto:' + cAssunto)
		nErro := oMessage:Send( oMail )
		
		if nErro <> 0
			xError := oMail:GetErrorString(nErro)
			Conout("Erro de Envio SMTP "+str(nErro,4)+" ("+xError+")")
			lRet := .F.
		Else
			Conout("Mensagem enviada com sucesso!")
		Endif
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
	Endif
	
	Return(lRet)
	