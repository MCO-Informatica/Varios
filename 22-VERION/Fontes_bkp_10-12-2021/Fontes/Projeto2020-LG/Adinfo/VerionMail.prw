#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TRYEXCEPTION.CH"
#INCLUDE "XMLXFUN.CH"
/*
função genérica para envio de email Verion
Claudia Cabral - janeiro 2021
*/
User function VerionMail( cPara, cCopia, cOculCop, cAssunto, cBody,cAnexo )
	Local oServer		:= NIL
	Local oMessage 		:= NIL   
	//Local cError        := ""   	     	/* teste */
	//Local cAviso        := ""       	 	/* teste */
	//Local cWarning		:= ""				/* teste */
	Local nret			:= 0
	Local cSMTPServer	:= SuperGetMv( "MV_RELSERV" )
	Local cAccount 		:= SuperGetMv( "MV_RELACNT" )
	Local cPass 		:= SuperGetMv( "MV_RELPSW" )
	Local cPort 		:= SuperGetMv( "MV_VERPORT",.T. ,"587") // parametro customizao para porta SMPT
	Local nTimeout		:= SuperGetMv( "MV_RELTIME" )
	Local lAuth			:= SuperGetMV("MV_RELAUTH",.T.,.F.)
	Local cUser         := SuperGetMv( "MV_RELAUSR" )
	Local lTLS			:= GetMV("MV_RELTLS ",.F.,.F.) 
	If ":" $ cSMTPServer // a porta já esta configurada no endereço do servidor
		cPort := Substr(cSMTPServer,at(":", cSMTPServer )+1)
		cSMTPServer := substr(cSMTPServer,1,at(":",cSMTPServer)-1)
	EndIF
	oServer := TMailManager():New()
	If lTls
		oServer:SetUseTLS(.T.)
	EndIF	
	oServer:Init( "", cSMTPServer, cAccount, cPass, 0, val( cPort ) )
	
	IF( nTimeout <= 0 )
		conout( "[TIMEOUT] DISABLE" )
	ELSE
		conout( "[TIMEOUT] ENABLE()" )
		nRet := oServer:SetSmtpTimeOut( 120 )
		IF nRet != 0
			conout( "[TIMEOUT] Fail to set" )
			conout( "[TIMEOUT][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
			Return .F.
		EndIF
	EndiF
	Conout( "[SMTPCONNECT] connecting ..." )
	nRet := oServer:SmtpConnect()
	IF nRet != 0
		conout( "[SMTPCONNECT] Falha ao conectar" )
		conout( "[SMTPCONNECT][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
		Return .F.
	ELSE
		conout( "[SMTPCONNECT] Sucesso ao conectar" )
	EndIF
	IF lAuth
		conout( "[AUTH] ENABLE" )
		conout( "[AUTH] TRY with ACCOUNT() and PASS()" )
		// try with account and pass
		nRet := oServer:SMTPAuth( cAccount, cPass )
		IF nRet != 0
			conout( "[AUTH] FAIL TRY with ACCOUNT() and PASS()")
			conout( "[AUTH][ERROR] " + str(nRet,6) , oServer:GetErrorString( nRet ) )
			conout( "[AUTH] TRY with USER() and PASS()" )
			// try with user and pass
			nRet := oServer:SMTPAuth( cUser, cPass )
			IF nRet != 0
				conout( "[AUTH] FAIL TRY with USER() and PASS()" )
				conout( "[AUTH][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
				Return .F.
			ELSE
				conout( "[AUTH] SUCEEDED TRY with USER() and PASS()" )
			EndIF
		ELSE
			conout( "[AUTH] SUCEEDED TRY with ACCOUNT and PASS" )
		EndIF
	ELSE
		conout( "[AUTH] DISABLE" )
	EndIF
	conout( "[MESSAGE] Criando mail message" )
	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom          := cAccount
	oMessage:cTo            := cPara
	oMessage:cCc            := cCopia
	oMessage:cBcc           := cOculCop
	oMessage:cSubject       := cAssunto
	oMessage:cBody	 		:= cBody	
//	oMessage:GetAttachCount() 
//	oMessage:GetAttach(1,cAnexo)
	 nRet := oMessage:AttachFile(cAnexo )
    
	if nRet < 0
		conout( "[ATTACH] Attach FAILED..." )
	endif
	
	conout( "[SEND] Sending ..." )
	nRet := oMessage:Send( oServer )
	IF nRet != 0
		conout( "[SEND] Fail to send message" )
		conout( "[SEND][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
	ELSE
		conout( "[SEND] Success to send message" )
	EndIF
	conout( "[DISCONNECT] smtp disconnecting ... " )
	nRet := oServer:SmtpDisconnect()
	IF nRet != 0
		conout( "[DISCONNECT] Fail smtp disconnecting ... " )
		conout( "[DISCONNECT][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
	ELSE
		conout( "[DISCONNECT] Success smtp disconnecting ... " )
	EndIF
Return
