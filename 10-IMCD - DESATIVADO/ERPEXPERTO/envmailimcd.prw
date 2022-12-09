#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TBICONN.CH"

USER FUNCTION ENVMAILIMCD(cTO,cCc,cBcc, cSubject,cBody,aAttach,lDispMail)

	Local oServer
	Local oMessage
	Local cAccount	:= GetMV( "MV_RELACNT" )
	Local cPassword	:= GetMV( "MV_RELPSW"  )
	Local cServer	:= GetMV( "MV_RELSERV" )
	Local nPorta	:=  GetMV( "MV_PORSMTP"  )
	Local nX := 0
	Local nBegin := Seconds()

	Default lDispMail := superGetMv("ES_DISMAIL", .F., .T.)
	Default cTO := PARAMIXB[1]
	Default cCc := PARAMIXB[2]
	Default cBcc:= PARAMIXB[3]
	Default cSubject:= PARAMIXB[4]
	Default cBody:= PARAMIXB[5]
	Default aAttach:= {}

	if lDispMail
		//Cria a conexão com o server STMP ( Envio de e-mail )
		oServer := TMailManager():New()
		oServer:SetUseTLS(.T.)

		nErro := oServer:Init('', cServer , cAccount, cPassword, 0, nPorta )
		If nErro != 0
			sErro := oServer:GetErrorString( nErro )

			//FWLogMsg("INFO", "", "BusinessObject", "ENVMAILIMCD" , "", "", "Falha ao conectar", 0, 0)
			aMessage := {}
			aAdd(aMessage, {"Erro", sErro})

			//Quando enviado o parâmetro de aMessage, o parâmetro cMessage não é exibido no console
			FWLogMsg("INFO", "LAST", "MeuGrupo", "ENVMAILIMCD", "0" , "MeuID", "Init "+sErro, 1, Seconds() - nBegin, aMessage)

			Return .F.
		else

			FWLogMsg("INFO", "LAST", "MeuGrupo", "ENVMAILIMCD", "0" , "MeuID", "oServer:Init conectado", 1, Seconds() - nBegin, {})

		EndIf

		//seta um tempo de time out com servidor de 1min
		If oServer:SetSmtpTimeOut( 60 ) != 0
			FWLogMsg("INFO", "", "BusinessObject", "ENVMAILIMCD" , "", "", "Falha ao setar o time out", 0, 0)
			Return .F.
		EndIf

		//realiza a conexão SMTP
		nErro := oServer:SmtpConnect()

		If nErro != 0
			sErro := oServer:GetErrorString( nErro )
			Conout( sErro )

			//FWLogMsg("INFO", "", "BusinessObject", "ENVMAILIMCD" , "", "", "Falha ao conectar", 0, 0)
			aMessage := {}
			aAdd(aMessage, {"Erro", sErro})

			//Quando enviado o parâmetro de aMessage, o parâmetro cMessage não é exibido no console
			FWLogMsg("INFO", "LAST", "MeuGrupo", "ENVMAILIMCD", "0" , "MeuID", "SmtpConnect "+sErro, 1, Seconds() - nBegin, aMessage)


			Return .F.
		EndIf

		nErro := oServer:SMTPAuth( cAccount, cPassword )

		If nErro != 0
			sErro := oServer:GetErrorString( nErro )
			Conout( sErro )

			//FWLogMsg("INFO", "", "BusinessObject", "ENVMAILIMCD" , "", "", "Falha ao conectar", 0, 0)
			aMessage := {}
			aAdd(aMessage, {"Erro", sErro})

			//Quando enviado o parâmetro de aMessage, o parâmetro cMessage não é exibido no console
			FWLogMsg("INFO", "LAST", "MeuGrupo", "ENVMAILIMCD", "0" , "MeuID", "SmtpConnect "+sErro, 1, Seconds() - nBegin, aMessage)


			Return .F.
		EndIf
		//Apos a conexão, cria o objeto da mensagem
		oMessage := TMailMessage():New()

		//Limpa o objeto
		oMessage:Clear()

		rodape(@cBody)

		oMessage:AttachFile( '\imagens\imcd_logo_2021.jpg' )

		// Essa tag, é a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
		oMessage:AddAttHTag( 'Content-Type: image/gif;' )
		oMessage:AddAttHTag( 'Content-ID: <ID_imcd_logo.jpg>' )

		//Popula com os dados de envio
		oMessage:cFrom              := cAccount //"PROTHEUS@imcdbrasil.com.br"
		oMessage:cTo                := cTO
		oMessage:cCc                := cCc
		oMessage:cBcc               := cBcc
		oMessage:cSubject           := cSubject
		oMessage:cBody              := cBody

		//Adiciona um attach
		oMessage:MsgBodyType( "text/html" )

		For nX := 1 to Len(aAttach)
			//oMessage:AddAttHTag("Content-ID: <" + aAttach[nX] + ">")
			oMessage:AttachFile(aAttach[nX])
		Next nX

		//Envia o e-mail
		nErro :=oMessage:Send( oServer )
		If nErro != 0
			sErro := oServer:GetErrorString( nErro )
			Conout( sErro )
			FWLogMsg("INFO", "", "BusinessObject", "ENVMAILIMCD" , "", "", sErro, 0, 0)
			Return .F.
		EndIf

		//Desconecta do servidor
		If oServer:SmtpDisconnect() != 0
			FWLogMsg("INFO", "", "BusinessObject", "ENVMAILIMCD" , "", "", "Erro ao disconectar do servidor SMTP" , 0, 0)
			Return .F.
		EndIf
	endif

Return .T.


User Function EnvMail()
	Local oMailServer := TMailManager():New()
	Local oMessage := TMailMessage():New()
	Local nErro := 0

	RpcSetType ( 3 )
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

	cAccount	:= GetMV( "MV_RELACNT" )
	cPassword	:= GetMV( "MV_RELPSW"  )
	cServer	:= GetMV( "MV_RELSERV" )
	nPorta	:=  GetMV( "MV_PORSMTP"  )

	oMailServer:SetUseTLS(.T.)
	nErro := oMailServer:Init('', cServer , cAccount, cPassword, 0, nPorta )


	If( (nErro := oMailServer:SmtpConnect()) != 0 )

		conout( "Não conectou.", oMailServer:GetErrorString( nErro ) )
		Return
	EndIf

	If( (nErro := oMailServer:SMTPAuth( cAccount, cPassword )) != 0 )

		conout( "Não conectou.", oMailServer:GetErrorString( nErro ) )
		Return
	EndIf

	oMessage:Clear()
	oMessage:cFrom           := cAccount
	//Altere
	oMessage:cTo             := "junior.gardel@gmail.com;junior.carvalho@imcdbrasil.com.br"
	//Altere
	oMessage:cCc             := ""
	oMessage:cBcc            := ""
	oMessage:cSubject        := "Teste de envio d e-mail"
	oMessage:cBody           := "Teste<br><img src='cid:ID_imcd_logo.jpg'>"
	oMessage:MsgBodyType( "text/html" )

	// Para solicitar confimação de envio
	//oMessage:SetConfirmRead( .T. )

	// Adiciona um anexo, nesse caso a imagem esta no root
	oMessage:AttachFile( '\imagens\imcd_logo_2021.jpg' )

	// Essa tag, é a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
	oMessage:AddAttHTag( 'Content-Type: image/gif;' )
	oMessage:AddAttHTag( 'Content-ID: <ID_imcd_logo.jpg>' )

	nErro := oMessage:Send( oMailServer )
	If( nErro != 0 )
		conout( "Não enviou o e-mail.", oMailServer:GetErrorString( nErro ) )
		Return
	EndIf
	nErro := oMailServer:SmtpDisconnect()
	If( nErro != 0 )
		conout( "Não desconectou.", oMailServer:GetErrorString( nErro ) )
		Return
	EndIf

	RESET ENVIRONMENT
Return

Static function rodape(cBody)
	Local cRod := ""

	cRod += "<br><img src='cid:ID_imcd_logo.jpg'><br>"

	//cRod += '<br><img src="cid:ID_imcd_logo.jpg" alt="LOGO IMCD" width="650" height="191"><br>'

	cRod += '<span style="font-size:9px;">This e-mail and any attachment is for authorised use by the intended recipient(s) only. It may contain proprietary material, confidential information and/or be subject to legal privilege.'
	cRod += 'It should not be copied, disclosed to, retained or used by, any other party. If you are not an intended recipient then please promptly delete this e-mail and any attachment and all copies and inform the sender. Thank you.</span></p>'
	cRod += '<span style="font-size:9px;">Esse e-mail e/ou qualquer anexo &eacute; para uso autorizado apenas de seu(s) destinat&aacute;rio(s). Pode conter material propriet&aacute;rio, informa&ccedil;&atilde;o confidencial '
	cRod += 'e/ou estar sujeito a privil&eacute;gio legal. N&atilde;o deve ser copiado, divulgado, retido ou usado por qualquer outra parte. Se voc&ecirc; n&atilde;o for o destinat&aacute;rio, por favor exclua imediatamente '
	cRod += 'esse e-mail e qualquer anexo ou c&oacute;pias e notifique seu emissor. Obrigado.</span></p>'
	cRod += '</html>'

	cBody := StrTran(cBody, '</html>', cRod)

Return()

