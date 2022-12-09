#Include "Protheus.CH"
#Include "RwMake.Ch"
#Include "TopConn.CH"
#include "TBICONN.CH" 

#DEFINE CRLF CHR(13) + CHR(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} M030Inc
Rotina para envio de e-mail aos responáveis pelo cadastro do cliente, parte contábil.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		13/10/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function M030Inc()

	Local _aEmail	:= Separa(GetMv("ES_HWCMAIL",,"000271,000318,000408,000358"),",")
	Local _nI := 0
	
	If PARAMIXB <> 3
		For _nI	:= 1 To Len(_aEmail)
			Begin Transaction 
				_cMsg := "<html>"
				_cMsg += "<head>"
				_cMsg += "<title>Untitled Document</title>"
				_cMsg += "</head> "
				_cMsg += "<body> "
				_cMsg += "  <p>&nbsp;</p>"
				_cMsg += "  <p>Prezado(a) " + AllTrim(UsrRetName(_aEmail[_nI])) + ", </p>"
				_cMsg += "  <p>Favor realizar analise dos campos contábeis para o cliente cadastrado: </p>" 
				_cMsg += "	<p>Empresa: " + SM0->M0_NOME
				_cMsg += "	<p>Cliente: " + SA1->A1_COD
				_cMsg += "	<p>Loja: " + SA1->A1_LOJA
				_cMsg += "	<p>Nome: " + SA1->A1_NOME
				_cMsg += "	<p>Usuário de Inclusão: " + UsrRetName(__cUserID)
				_cMsg += "	<p>Grato(a),"
				_cMsg += "</body>"
				_cMsg += "</html>"
				
				_cAssunto	:= "Cadastro de Cliente - " + SM0->M0_NOME
				_cPara		:= AllTrim(UsrRetMail(_aEmail[_nI]))
				
				MailDSC(_cPara, _cAssunto, _cMsg, "")
			End Transaction
		Next _nI
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
	Local cSMTPServer	:= Alltrim(SUBSTR(GetMV("MV_RELSERV"),1,AT(":", GetMV("MV_RELSERV"))-1)) //Alltrim(GetMV("MV_WFSMTP"))
	Local cSMTPUser		:= AllTrim(GetMV("MV_RELACNT")) //Alltrim(GetMV("MV_WFAUTUS"))
	Local cSMTPPass		:= AllTrim(GetMV("MV_RELPSW")) //Alltrim(GetMV("MV_WFAUTSE"))
	Local cMailFrom		:= cSMTPUser
	Local nPort	   		:= 587
	Local lUseAuth		:= .T.
	Local lSSL      	:= GetMV("MV_RELSSL")
	Local lTSL      	:= GetMV("MV_RELTLS")


	
	conout('Conectando com SMTP ['+cSMTPServer+'] ')
	oMail := TMailManager():New()
//	oMail:SetUseTLS(.t.)

	oMail:setUseSSL(lSSL)
	oMail:SetUseTLS(lTSL)

	conout('Inicializando SMTP')
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, /*0*/, nPort  )
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
