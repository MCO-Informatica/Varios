#Include "Protheus.ch"

User Function envmail(cEmailTo ,cEmailCc ,cAssunto ,cMensagem ,aAnexos, cAssinatu, cError, lMostra)
	Local cMailServer := GetMV("MV_RELSERV") //"smtp.hgrextrusoras.com.br:587"
	Local cMailConta  := GetMV("MV_RELACNT") //"totvs@hgrextrusoras.com.br"
	Local cMailSenha  := GetMV("MV_RELPSW")  //"Totvs@Hgr2020"
	Local lMailAuth   := GetMv("MV_RELAUTH") //.t. --Parametro que indica se existe autenticacao no e-mail
	Local cProtocol   := ""

	Local nI       := 0
	Local nRet     := 0

	Local lUsaTLS := GetMv("MV_RELTLS") //.f.
	Local lUsaSSL := GetMv("MV_RELSSL") //.f.
	Local nPorta := 0		//587 //informa a porta que o servidor SMTP irá se comunicar, podendo ser 25 ou 587
	Local oServer
	Local oMessage

	Default aAnexos := {}

	nI := len( alltrim(cMailServer) ) - at(":",cMailServer)
	nPorta := val( substr(cMailServer,at(":",cMailServer)+1,nI) )
	cMailServer := substr(cMailServer,1,at(":",cMailServer)-1)

	Begin Sequence

		oMessage:= TMailMessage():New()
		oMessage:Clear()

		oMessage:cDate	 := cValToChar( Date() )
		oMessage:cFrom 	 := cMailConta
		oMessage:cTo 	 := cEmailTo
		oMessage:cCc 	 := cEmailCc
		oMessage:cSubject:= cAssunto
		oMessage:cBody 	 := cMensagem
		oMessage:MsgBodyType( "text/html" )

		For nI := 1 To Len(aAnexos)
			if file(aAnexos[nI])
				nRet := oMessage:AttachFile( aAnexos[nI] )
				if nRet < 0
					cError := "ANEXO: O arquivo " + aAnexos[nI] + " não foi anexado!"
					if lMostra
						alert( cError )
					endif
					Break
				endif
			else
				cError := "ANEXO: O arquivo " + aAnexos[nI] + " não foi encontrado!"
				if lMostra
					alert( cError )
				endif
				nRet:=-1
				Break
			endif
		Next nI

		if !empty(cAssinatu)
			if file("\system\"+cAssinatu)
				nRet := oMessage:AttachFile( "\system\"+cAssinatu )
				if nRet < 0
					cError := "ANEXO: O arquivo " + "\system\"+cAssinatu + " não foi anexado!"
					if lMostra
						alert( cError )
					endif
					Break
				else
					oMessage:AddAttHTag('Content-ID:'+cAssinatu )
					//oMessage:AddAtthTag('Content-Disposition: attachment; filename='+cAssinatu)
				endif
			else
				cError := "ANEXO: O arquivo " + "\system\"+cAssinatu + " não foi encontrado!"
				if lMostra
					alert( cError )
				endif
				nRet:=-1
				Break
			endif
		endif

		oServer := tMailManager():New()
		oServer:SetUseTLS( lUsaTLS ) //Indica se será utilizará a comunicação segura através de TLS (.T.) ou não (.F.)
		oServer:SetUseSSL( lUsaSSL ) //Indica se será utilizará a comunicação segura através de SSL (.T.) ou não (.F.)
		nRet := oServer:Init( "", cMailServer, cMailConta, cMailSenha, 0, nPorta ) //inicilizar o servidor
		if nRet != 0
			cError := "O servidor SMTP não foi inicializado: " + oServer:GetErrorString( nRet )
			if lMostra
				alert(cError)
			endif
			Break
		endif

		nRet := oServer:SetSMTPTimeout( 60 ) //Indica o tempo de espera em segundos.
		if nRet != 0
			cError := "Não foi possível definir " + cProtocol + " tempo limite para " + cValToChar( nTimeout )
			if lMostra
				alert(cError)
			endif
			Break
		endif

		nRet := oServer:SMTPConnect()
		if nRet != 0
			cError := "Não foi possível conectar ao servidor SMTP: " + oServer:GetErrorString( nRet )
			if lMostra
				alert(cError)
			endif
			Break
		endif

		if lMailAuth
			//O método SMTPAuth ao tentar realizar a autenticação do
			//usuário no servidor de e-mail, verifica a configuração
			//da chave AuthSmtp, na seção [Mail], no arquivo de
			//configuração (INI) do TOTVS Application Server, para determinar o valor.
			nRet := oServer:SmtpAuth( cMailConta, cMailSenha )
			if nRet != 0
				cError := "Could not authenticate on SMTP server: " + oServer:GetErrorString( nRet )
				if lMostra
					alert( cError )
				endif
				oServer:SMTPDisconnect()
				Break
			endif
		Endif
		nRet := oMessage:Send( oServer )
		if nRet != 0
			cError := "Não foi possível enviar mensagem: " + oServer:GetErrorString( nRet )
			if lMostra
				alert(cError)
			endif
			Break
		endif

		nRet := oServer:SMTPDisconnect()
		if nRet != 0
			cError := "Não foi possível desconectar o servidor SMTP: " + oServer:GetErrorString( nRet )
			if lMostra
				alert(cError)
			endif
			Break
		endif

	End sequence

Return (nRet==0)
