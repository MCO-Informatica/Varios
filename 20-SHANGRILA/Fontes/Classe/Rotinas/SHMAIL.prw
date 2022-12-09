
#INCLUDE "totvs.ch"

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:	
* Retorno		: 	
*/
User Function SHMAIL; Return
Class SHMAIL
  //propriedades para se conectar ao servidor de envio
	Data cSmtp 		as String	// servidor de envio de e-mail
	Data nPorta 	as Integer	// porta do servidor de SMTP (padrão 25)
	Data nTimeOut   as Integer
	Data cConta 	as String	// conta de e-mail para autenticar
	Data cSenha 	as String	// senha de e-mail para autenticar
	Data lAutent 	as Boolean	// se o servidor requer autenticação (Padrão Falso)
	Data cTipoAut 	as String 	// se requer SSL ou TLS (Padrão Nenhuma)
	Data cCodUser 	as String 	//código do usuário para recuperar informações sobre e-mail
	Data oMail 		as Object	//armazena objeto TMailManager usado nessa classe
	Data oMessage	as Object	//armazena objeto TMailManager usado nessa classe
	Data lUsaCript	as Boolean
	Data cUserAut	as String
	Data cTexto		as String
	Data cEof 		as String
	Data aCabec		as Array
	Data aDados  	as Array
	Data aItem  	as Array
	Data cRodape	as String
	Data cCabecalho	as String
	Data cLogo		as String
	Data cDirAux	as String
  	
  //Propriedades para ENVIAR()
	Data cRemet 	as String	// remetente retirado do cadastro de usuário do Protheus
	Data cDest 		as String	// destinatário principal
	Data cCC 		as String	// com cópia para?
	Data cCCO  		as String	// com cópia oculta para? usado em DEFAUT() quando informa e-mail para auditoria
	Data cAssunto 	as String	// assunto do e-mail
	Data cBody 		as String	// corpo do e-mail
	Data aAnexo 	as Array	// array para anexar aquivos

	Data cFile		as String
	Data cPatchFile	as String
	Data cTpWf		as String
	
	METHOD NEW()
	METHOD CONECTA()
	METHOD DEFAUT()
	METHOD CONFIG(cSmtp,nPorta,cConta,cSenha,lAutent,cTipoAut)
	METHOD ENVIAR(cDest,cCC,cCCO,cAssunto,cBody,aAnexo)
	METHOD ENVIAR2(cDest,cCC,cCCO,cAssunto,cBody,aAnexo)
	METHOD DESCONECTA()
	METHOD EMAILFORM()
	METHOD formToFile()
	METHOD CreateFile(cFileName)
	METHOD IncLine(cLine)
	METHOD CloseArq()
	METHOD setTipoWf()
	METHOD getTipoWf()
	METHOD setDirWF()
	METHOD getDirWF()
ENDCLASS


/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:	
* Retorno		: 	
*/
METHOD NEW() CLASS SHMAIL
	Local aDadUser	:= {} // array com dados do usuário
	::cEof			:= CHR(13)+CHR(10)
	::cSmtp			:= ""
	::nPorta		:= 0
	::cConta		:= ""
	::cSenha		:= ""
	::lAutent		:= .F.
	::cTipoAut		:= ""
	::cCodUser		:= ''//RetCodUsr()
	::oMail			:= TMailManager():New()
	::oMessage		:= TMailMessage():New()
	::cRemet		:= ""
	::cDest 		:= ""
	::cCC		    := ""
	::cCCO			:= ""
	::cAssunto		:= ""
	::cBody			:= ""
	::cUserAut		:= ""
	::aAnexo		:= {}
	::aCabec		:= {}
	::aDados		:= {}
	::cRemet		:= ""
	::lUsaCript		:= .F.
	::cRodape		:= ""
	::cCabecalho	:= ""
	::cTexto		:= ''
	::cLogo			:= ''
	::nTimeOut		:= 120
	::cDirAux       := ''
	
	::cFile			:= ""
	::cPatchFile	:= ""
	::cTpWf			:= ""

/* 
PswOrder(1)
If PswSeek(::cCodUser, .T.)
	aDadUser	:= PswRet(1)
	::cRemet	:= aDadUser[1,14]	// E-mail do Usuario Solicitado.
endif
*/
RETURN

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:	
* Retorno		: 	
*/
METHOD DEFAUT() CLASS SHMAIL
	Local cSMTP			:= Alltrim(SuperGetMv('MV_RELSERV',.F.,''))
	Local cSMTPPort 	:= 587
	Local cConta    	:= Alltrim(SuperGetMv('MV_RELACNT',.F.,''))
	Local cSenha		:= Alltrim(SuperGetMv('MV_RELPSW',.F.,''))
	Local cCopia		:= Alltrim(SuperGetMv('MV_MAILADT',.F.,''))
	Local cUserAut		:= Alltrim(SuperGetMv('MV_RELAUSR',.F.,''))
	Local lAutentica	:= SuperGetMv('MV_RELAUTH',.F.,.F.)
	Local cTipoAut  	:= ""
	Local nI        	:= 0
	Local nJ			:= 0

// se o servidor de SMTP tiver uma porta diferente da padrão (25) busca a informação do configurador
	nI:= at(":",cSMTP)
	If nI>0
		nJ:= Len(cSMTP)
		cSMTPPort:= Val(SubStr(cSMTP,nI+1,nJ-nI))
		cSMTP:= SubStr(cSMTP,1,nI-1)
	EndIf

// Busca tipo de criptografia quando autentica
	If lAutentica
		If ::lUsaCript
			cTipoAut := Alltrim(SuperGetMv('ZZ_RELCRIP',.F.,''))
			If cTipoAut==NIL
				cTipoAut:=""
			EndIf
		EndIf
	EndIf
	
	::cSmtp			:= cSmtp
	::nPorta		:= cSMTPPort
	::cConta		:= cConta
	::cSenha		:= cSenha
	::lAutent		:= lAutentica
	::cTipoAut		:= cTipoAut
	::cCCO			:= cCopia
	::cUserAut		:= cUserAut
RETURN
            

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:	
* Retorno		: 	
*/
METHOD CONFIG(cSmtp,nPorta,cConta,cSenha,lAutent,cTipoAut) CLASS SHMAIL
	::cSmtp			:= cSmtp
	::nPorta		:= nPorta
	::cConta		:= cConta
	::cSenha		:= cSenha
	::lAutent		:= lAutent
	::cTipoAut		:= cTipoAut  // "SSL" ou "TLS" ou ""

	If ::cTipoAut==NIL
		::cTipoAut:=""
	EndIf

Return


/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:	
* Retorno		: 	
*/                            
METHOD CONECTA() CLASS SHMAIL
	Local nRet 	:= 0 //variável de retorno das funções

	If (::cTipoAut == "SSL")
		::oMail:SetUseSSL(.T.)
	ElseIf (::cTipoAut == "TLS")
		::oMail:SetUseTLS(.T.)
	EndIf

	::oMail:Init("",::cSmtp,::cConta,::cSenha,0,::nPorta)

	
	nRet := ::oMail:SetSMTPTimeout(::nTimeOut) //2 min
	If nRet == 0
		conout("[SHMAIL].[SMTPTimeout] Set Sucess")
	Else
		conout(nRet)
		conout("[SHMAIL].[SMTPTimeout] Set Error:"+::oMail:GetErrorString(nret))
	Endif

	nRet := ::oMail:SMTPConnect()

	If nRet == 0
		conout("[SHMAIL].[SMTPConnect] Sucess")
	Else
		conout(nRet)
		conout("[SHMAIL].[SMTPConnect] Error"+::oMail:GetErrorString(nret))
	Endif
    
	If ::lAutent
		conout("[SHMAIL].[SMTPAuth] Enable")
		nRet := ::oMail:SMTPAuth(::cUserAut, ::cSenha)
		If nRet != 0
			conout("[SHMAIL].[SMTPAuth] Error:" + str(nRet,6) , ::oMail:GetErrorString(nRet))
		else
			conout("[SHMAIL].[SMTPAuth] Sucess")
		Endif
	Else
		conout("[SHMAIL].[SMTPAuth] Disable")
	Endif

RETURN nRet

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:	
* Retorno		: 	
*/
METHOD ENVIAR(cDest,cCC,cCCO,cAssunto,cBody,aAnexo) CLASS SHMAIL
	Local nRet 	:= 0 //variável de retorno das funções
	::cDest 	:=cDest
	::cCC 		:=cCC
	::cCCO 		:=if(::cCCO<>"",::cCCO + ';'+cCCO,cCCO)
	::cAssunto 	:=cAssunto
	::cBody 	:=cBody
	::aAnexo 	:=aAnexo

	nRet := ::oMail:SendMail(::cRemet,::cDest,::cAssunto,::cBody,::cCC,::cCCO,::aAnexo,len(::aAnexo))

	If nRet == 0
		conout("[SHMAIL].[SENDMail] Sucess")
	Else
		conout(nret)
		conout("[SHMAIL].[SENDMail] Error:"+::oMail:GetErrorString(nret))
	Endif
Return nRet

METHOD ENVIAR2(cDest,cCC,cCCO,cAssunto,cBody,cAnexo) CLASS SHMAIL
	Local nRet 	:= 0 //variável de retorno das funções
	::cDest 	:=cDest
	::cCC 		:=cCC
	::cCCO 		:=if(::cCCO<>"",::cCCO + ';'+cCCO,cCCO)
	::cAssunto 	:=cAssunto
	::cBody 	:=cBody
	
	::oMessage:Clear()
	::oMessage:cFrom           := ::cRemet
  
  	//Altere
	::oMessage:cTo             := cDest
  
  	//Altere
	::oMessage:cCc             := ""
	::oMessage:cBcc            := ""
	::oMessage:cSubject        := cAssunto
	::oMessage:cBody           := cBody
	::oMessage:MsgBodyType( "text/html" )
  
   
  	// Adiciona um anexo, nesse caso a imagem esta no root
	::oMessage:AttachFile( cAnexo )
  
  	// Essa tag, é a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
	::oMessage:AddAttHTag( 'Content-ID: &lt;ID_siga.jpg&gt;' )
	
	nRet := ::oMessage:Send( ::oMail )
	 
	&&nRet := ::oMail:SendMail(::cRemet,::cDest,::cAssunto,::cBody,::cCC,::cCCO,::aAnexo,len(::aAnexo))

	If nRet == 0
		conout("[SHMAIL].[SENDMail] Sucess")
	Else
		conout(nret)
		conout("[SHMAIL].[SENDMail] Error:"+::oMail:GetErrorString(nret))
	Endif
Return nRet

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:	
* Retorno		: 	
*/                                                            
METHOD DESCONECTA() CLASS SHMAIL
	Local nRet 	:= 0 //variável de retorno das funções

	nRet := ::oMail:SmtpDisconnect()
	If nRet == 0
		conout("[SHMAIL].[SMTPDisconnect] Sucess")
	Else
		conout(nret)
		conout(::oMail:GetErrorString(nret))
	Endif

Return nRet

/*
* Metodo		:	EMAILFORM
* Autor			:	João Zabotto
* Data			: 	24/06/2014
* Descricao		:	Monta o HTML para envio do e-mail no final do processamento.
* Retorno		: 	
*/
Method EMAILFORM(uDados) Class SHMAIL
	Local cEmail 	:= ""
	Local aAux		:= uDados

	cEmail := "<html>"
	cEmail += ::cEof
	cEmail += "<head>"
	cEmail += ::cEof
	cEmail += "<style type='text/css'>"
	cEmail += ::cEof
	cEmail += "a:hover { text-decoration: underline"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += "a:link { text-decoration: none"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += "a:active {"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".texto { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; text-decoration: none; font-weight: normal;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".Scroll { SCROLLBAR-FACE-COLOR: #DEDEDE; SCROLLBAR-HIGHLIGHT-COLOR: #DEDEDE; SCROLLBAR-SHADOW-COLOR: #ffffff; SCROLLBAR-3DLIGHT-COLOR: #ffffff; SCROLLBAR-ARROW-COLOR: #ffffff; SCROLLBAR-TRACK-COLOR: #ffffff; SCROLLBAR-DARKSHADOW-COLOR: #DEDEDE;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".combo { font-family: Arial, Helvetica, sans-serif; font-size: 11px; margin: 1px; padding: 1px; border: 1px solid #000000;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".comboselect { font-family: Arial, Helvetica, sans-serif; color: #666666; font-size: 11px; border: 1px #CCCCCC double;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".links { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #CC0000; text-decoration: none; font-weight: bold;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".links-clientes { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #003366; text-decoration: none"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".textobold { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #003366; text-decoration: none; font-weight: bold;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".textoItalico { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: 7F7F7F; text-decoration: none; font-style: italic; font-weight: bold;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".titulo { font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #19167D; text-decoration: none; font-weight: bold;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".links-detalhes { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: FF0000; text-decoration: none"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".TituloMenor { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #19167D; text-decoration: none; font-weight: bold;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".Botoes { font-family: Arial, Helvetica, sans-serif; font-size: 10px; font-weight: normal; text-decoration: none; margin: 2px; padding: 2px; cursor: hand; border: 1px outset #000000;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".Botoes2 { BACKGROUND-COLOR: lightgrey; COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 11px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".TableRowGreyMin1 { BACKGROUND-COLOR: lightgrey; COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 11px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".TableRowGreyMin2 {COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 11px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".TarjaTopoMenu { text-decoration: none; height: 6px; background-image: url('http://localhost/apmenu-right.jpg');"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FundoMenu { text-decoration: none; background-image: url('http://localhost/apmenu-right.jpg');"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FonteMenu { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #19167D; text-decoration: none; font-weight: bold;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FonteSubMenu { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #19167D; text-decoration: none;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FundoSubMenu { text-decoration: none; background-image: url('http://localhost/apmenu-right.jpg');"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".DivisoriaOpçõesMenu { text-decoration: none; background-color: #6680A6; background-image: url('http://localhost/apmenu-right.jpg');"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".TarjaTopoLogin { text-decoration: none; background-color: #426285; height: 6px;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FundoLogin { text-decoration: none; background-color: #F7F7F7;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FundoClaro { text-decoration: none; background-color: #fbfbfb;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".TituloDestaques { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #19167D; text-decoration: none; font-weight: bold;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".TextoDestaques { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; color: #777777; text-decoration: none; font-weight: normal;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FundoDestaques { text-decoration: none; background-color: #E5E5E5;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FundoPontilhado { text-decoration: none; background-image: url('http://localhost/pontilhado.gif'); height: 5px"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FundoPontilhadoVertical { text-decoration: none; background-image: url('http://localhost/pontilhado_vertical.gif'); height: 5px"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".TituloTabelas { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFFFF; text-decoration: none; font-weight: bold;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FundoTituloTabela { text-decoration: none; background-color: #495E73;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".TarjaTopoCor { text-decoration: none; height: 6px; background-image: url('http://localhost/pontilhado.gif'); background-color: #6699CC"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".FundoTabelaDestaques { text-decoration: none; background-color: #495E73;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".comboselect-pequeno { font-family: Arial, Helvetica, sans-serif; color: #666666; font-size: 11px; border: 1px solid #CCCCCC;"
	cEmail += ::cEof
	cEmail += "width: 132px; clear: none; float: none; text-decoration: none; left: 1px; top: 1px;"
	cEmail += ::cEof
	cEmail += "right: 1px; bottom: 1px; clip: rect(1px 1px 1px 1px);"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".comboselect-grande { font-family: Arial, Helvetica, sans-serif; color: #666666; font-size: 11px; border: 1px #CCCCCC double; width: 415px;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".texto-layer { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000000; text-decoration: none"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += ".tituloAvaliacao { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #19167D;"
	cEmail += ::cEof
	cEmail += "text-decoration: none; font-weight: bold; vertical-align: middle; text-align: center; line-height: 12px;"
	cEmail += ::cEof
	cEmail += "}"
	cEmail += ::cEof
	cEmail += "</style>"
	cEmail += ::cEof
	cEmail += "<title>Integração x PROTHEUS</title>"
	cEmail += ::cEof
	cEmail += "</head>"
	cEmail += ::cEof
	cEmail += "<body onLoad='loadval();'>"
	cEmail += ::cEof
	cEmail += "<br>"
	cEmail += ::cEof
	cEmail += "<table style='border-collapse: collapse;' id='AutoNumber2' align='center' border='0' bordercolor='#111111' cellpadding='0'"
	cEmail += ::cEof
	cEmail += "cellspacing='0' height='32' width='100%'>"
	cEmail += ::cEof
	cEmail += "<tbody>"
	cEmail += ::cEof
	cEmail += "<tr>"
	cEmail += ::cEof
	cEmail += "<td height='32' width='14%'>&nbsp;<img src='" + ::cLogo + "' border='0'></td>"
	cEmail += ::cEof
	cEmail += "<td height='32' width='59%'>"
	cEmail += ::cEof
	cEmail += "<p align='center'><strong><font color='#000000' face='Verdana, Arial, Helvetica, sans-serif' size='2'>"
	cEmail += Alltrim(SM0->M0_NOMECOM)+" - CNPJ : "+Alltrim(SM0->M0_CGC)+"<br>"
	cEmail += Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" / "+Alltrim(SM0->M0_ESTCOB)+"<br>"
	cEmail += "Fone : "+Alltrim(SM0->M0_TEL)+" - Fax : "+Alltrim(SM0->M0_FAX)+"</font></strong></p>"
	cEmail += "</td>"
	cEmail += ::cEof
	cEmail += "<td height='32' width='27%'>"
	cEmail += ::cEof
	cEmail += "</td>"
	cEmail += ::cEof
	cEmail += "</tr>"
	cEmail += ::cEof
	cEmail += "</tbody>"
	cEmail += ::cEof
	cEmail += "</table>"
	cEmail += ::cEof
	cEmail += "<br>"
	cEmail += ::cEof
	cEmail += "<table align='center' border='0' cellpadding='0' cellspacing='0' width='100%'>"
	cEmail += ::cEof
	cEmail += "<tbody>"
	cEmail += ::cEof
	cEmail += "<tr background='http://localhost/pontilhado.gif'>"
	cEmail += ::cEof
	cEmail += "<td class='TarjaTopoCor' height='5'> <img src='http://localhost/transparente.gif' height='1' width='1'></td>"
	cEmail += ::cEof
	cEmail += "</tr>"
	cEmail += ::cEof
	cEmail += "</tbody>"
	cEmail += ::cEof
	cEmail += "</table>"
	cEmail += ::cEof
	cEmail += "<br>"
	cEmail += ::cEof
	cEmail += "<table style='border-collapse: collapse;' id='AutoNumber2' align='center' border='0' bordercolor='#111111'"
	cEmail += ::cEof
	cEmail += "cellpadding='0' cellspacing='0' height='32' width='100%'>"
	cEmail += ::cEof
	cEmail += "<tbody>"
	cEmail += ::cEof
	cEmail += "<tr>"
	cEmail += ::cEof
	cEmail += "<td height='32' width='59%'>"
	cEmail += ::cEof


	cEmail += "<p align='center'><font face='Arial' size='5'>" + ::cCabecalho + "</font></p>"
	cEmail += ::cEof

	cEmail += "</td>"
	cEmail += ::cEof
	cEmail += "</tr>"
	cEmail += ::cEof
	cEmail += "</tbody>"
	cEmail += ::cEof
	cEmail += "</table>"
	cEmail += ::cEof
	cEmail += "<br>"
	cEmail += ::cEof
	cEmail += "<table align='center' bgcolor='#f7f7f7' border='1' bordercolor='#e5e5e5'"
	cEmail += ::cEof
	cEmail += "cellpadding='6' cellspacing='0' width='99%'>"
	cEmail += ::cEof
	cEmail += "<tbody>"
	cEmail += ::cEof
	cEmail += "<tr>"
	cEmail += ::cEof
	cEmail += "<td bordercolor='#FFFFFF' class='titulo' width='100%'>"
	cEmail += ::cEof
	cEmail += "<table border='0' cellpadding='2' cellspacing='1' height='36' width='1024'>"
	cEmail += ::cEof
	cEmail += "<tbody>"
	cEmail += ::cEof
	cEmail += "<tr>"
	cEmail += ::cEof
	cEmail += "</tr>"
	cEmail += ::cEof
	cEmail += "</tbody>"
	cEmail += ::cEof
	cEmail += "</table>"
	cEmail += ::cEof
	cEmail += "<table border='0' cellspacing='2' height='41' width='100%'>"
	cEmail += ::cEof
	cEmail += "<tbody>"
	cEmail += ::cEof

	cEmail += " <tr class='texto-layer' bgcolor='#CCCCCC' align='Left'  >"
	cEmail += ::cEof
	
	For nB := 1 to Len(::aCabec)
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+::aCabec[nB]+"</TD>"
		cEmail += ::cEof
	Next nB
	
	
	cEmail += "</TR>"
	cEmail += ::cEof
	
	For nB := 1 to Len(aAux)
		cEmail += "<tr class='texto-layer' bgcolor='"+iif(Empty(aAux[nB][1][2]),"#cccccc","#ffffff")+"' align='Left'>"
		cEmail += ::cEof
		
		aItem := aAux[nB,1]
		
		For nX := 1 To Len(aItem)
			cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aItem[nX]+"</TD>"
			cEmail += ::cEof
		Next
		
		cEmail += "</tr>"
		cEmail += ::cEof
	
	Next

	/*For nB := 1 to Len(aAux)
	
		cEmail += "<tr class='texto-layer' bgcolor='"+iif(Empty(aAux[nB][2]),"#cccccc","#ffffff")+"' align='Left'>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][1]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][2]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][3]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][4]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][5]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][6]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][7]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][8]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][9]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][10]+"</TD>"
		cEmail += ::cEof		
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][11]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][12]+"</TD>"
		cEmail += ::cEof				
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][13]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][14]+"</TD>"
		cEmail += ::cEof				
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][15]+"</TD>"
		cEmail += ::cEof
		cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aAux[nB][16]+"</TD>"
		cEmail += ::cEof				
		cEmail += "</tr>"
		cEmail += ::cEof
	Next nB*/

	cEmail += "</tbody>"
	cEmail += ::cEof
	cEmail += "</table>"
	cEmail += ::cEof
	cEmail += "&nbsp;&nbsp;"
	cEmail += ::cEof
	cEmail += "</div>"
	cEmail += ::cEof
	cEmail += "</td>"
	cEmail += ::cEof
	cEmail += "</tr>"
	cEmail += ::cEof
	cEmail += "</tbody>"
	cEmail += ::cEof
	cEmail += "</table>"
	cEmail += ::cEof
	cEmail += "</span>"
	cEmail += ::cEof
	cEmail += "<br>"
	cEmail += ::cEof
	cEmail += "<br>"
	cEmail += ::cEof
	cEmail += "<table align='center' bgcolor='#f7f7f7' border='1' bordercolor='#e5e5e5'"
	cEmail += ::cEof
	cEmail += "cellpadding='0' cellspacing='0' width='100%'>"
	cEmail += ::cEof
	cEmail += "<tbody>"
	cEmail += ::cEof
	cEmail += "<tr>"
	cEmail += ::cEof
	cEmail += "<td bordercolor='#FFFFFF' width='100%'>"
	cEmail += ::cEof
                    
	If !Empty(::cRodape)
		cEmail += "<p align='center'><font face='Arial' size='5'>" + ::cRodape + "</font></p>"
		cEmail += ::cEof
	EndIf
		
	cEmail += "</td>"
	cEmail += ::cEof
	cEmail += "</tr>"
	cEmail += ::cEof
	cEmail += "</tbody>"
	cEmail += ::cEof
	cEmail += "</table>"
	cEmail += ::cEof
	cEmail += "</body>"
	cEmail += ::cEof
	cEmail += "</html>"

Return(cEmail)

Method formToFile(uDados) Class SHMAIL
	Local cEmail 	:= ""
	Local aAux		:= uDados
	Local cDir		:= ""
	Local cTpWf		:= ""
	Local cDirAux	:= ""
	Local lContinua	:= .T.
	
	cTpWf 	:= ::getTipoWf()	
	cDirAux := ::getDirWf()
	cDir 	:= GetSrvProfString("StartPath","") + cDirAux + "\"
	
	If !lIsDir(cDir)
		MontaDir(cDir)
	Endif
	
	::cPatchFile := cDir + ::cTpWf + "_" + Dtos(dDataBase)+"_"+StrTran(time(),":","")+".html"
	
	If !::CreateFile(::cPatchFile)
		lContinua := .F.
	Endif
	
	if lContinua
		cEmail := "<html>"
		cEmail += ::cEof
		cEmail += "<head>"
		cEmail += ::cEof
		cEmail += "<style type='text/css'>"
		cEmail += ::cEof
		cEmail += "a:hover { text-decoration: underline"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += "a:link { text-decoration: none"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += "a:active {"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".texto { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; text-decoration: none; font-weight: normal;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".Scroll { SCROLLBAR-FACE-COLOR: #DEDEDE; SCROLLBAR-HIGHLIGHT-COLOR: #DEDEDE; SCROLLBAR-SHADOW-COLOR: #ffffff; SCROLLBAR-3DLIGHT-COLOR: #ffffff; SCROLLBAR-ARROW-COLOR: #ffffff; SCROLLBAR-TRACK-COLOR: #ffffff; SCROLLBAR-DARKSHADOW-COLOR: #DEDEDE;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".combo { font-family: Arial, Helvetica, sans-serif; font-size: 11px; margin: 1px; padding: 1px; border: 1px solid #000000;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".comboselect { font-family: Arial, Helvetica, sans-serif; color: #666666; font-size: 11px; border: 1px #CCCCCC double;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".links { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #CC0000; text-decoration: none; font-weight: bold;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".links-clientes { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #003366; text-decoration: none"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".textobold { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #003366; text-decoration: none; font-weight: bold;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".textoItalico { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: 7F7F7F; text-decoration: none; font-style: italic; font-weight: bold;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".titulo { font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #19167D; text-decoration: none; font-weight: bold;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".links-detalhes { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: FF0000; text-decoration: none"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".TituloMenor { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #19167D; text-decoration: none; font-weight: bold;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".Botoes { font-family: Arial, Helvetica, sans-serif; font-size: 10px; font-weight: normal; text-decoration: none; margin: 2px; padding: 2px; cursor: hand; border: 1px outset #000000;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".Botoes2 { BACKGROUND-COLOR: lightgrey; COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 11px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".TableRowGreyMin1 { BACKGROUND-COLOR: lightgrey; COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 11px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".TableRowGreyMin2 {COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 11px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".TarjaTopoMenu { text-decoration: none; height: 6px; background-image: url('http://localhost/apmenu-right.jpg');"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FundoMenu { text-decoration: none; background-image: url('http://localhost/apmenu-right.jpg');"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FonteMenu { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #19167D; text-decoration: none; font-weight: bold;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FonteSubMenu { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #19167D; text-decoration: none;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FundoSubMenu { text-decoration: none; background-image: url('http://localhost/apmenu-right.jpg');"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".DivisoriaOpçõesMenu { text-decoration: none; background-color: #6680A6; background-image: url('http://localhost/apmenu-right.jpg');"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".TarjaTopoLogin { text-decoration: none; background-color: #426285; height: 6px;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FundoLogin { text-decoration: none; background-color: #F7F7F7;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FundoClaro { text-decoration: none; background-color: #fbfbfb;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".TituloDestaques { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #19167D; text-decoration: none; font-weight: bold;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".TextoDestaques { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; color: #777777; text-decoration: none; font-weight: normal;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FundoDestaques { text-decoration: none; background-color: #E5E5E5;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FundoPontilhado { text-decoration: none; background-image: url('http://localhost/pontilhado.gif'); height: 5px"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FundoPontilhadoVertical { text-decoration: none; background-image: url('http://localhost/pontilhado_vertical.gif'); height: 5px"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".TituloTabelas { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFFFF; text-decoration: none; font-weight: bold;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FundoTituloTabela { text-decoration: none; background-color: #495E73;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".TarjaTopoCor { text-decoration: none; height: 6px; background-image: url('http://localhost/pontilhado.gif'); background-color: #6699CC"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".FundoTabelaDestaques { text-decoration: none; background-color: #495E73;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".comboselect-pequeno { font-family: Arial, Helvetica, sans-serif; color: #666666; font-size: 11px; border: 1px solid #CCCCCC;"
		cEmail += ::cEof
		cEmail += "width: 132px; clear: none; float: none; text-decoration: none; left: 1px; top: 1px;"
		cEmail += ::cEof
		cEmail += "right: 1px; bottom: 1px; clip: rect(1px 1px 1px 1px);"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".comboselect-grande { font-family: Arial, Helvetica, sans-serif; color: #666666; font-size: 11px; border: 1px #CCCCCC double; width: 415px;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".texto-layer { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000000; text-decoration: none"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += ".tituloAvaliacao { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #19167D;"
		cEmail += ::cEof
		cEmail += "text-decoration: none; font-weight: bold; vertical-align: middle; text-align: center; line-height: 12px;"
		cEmail += ::cEof
		cEmail += "}"
		cEmail += ::cEof
		cEmail += "</style>"
		cEmail += ::cEof
		cEmail += "<title>Integração x PROTHEUS</title>"
		cEmail += ::cEof
		cEmail += "</head>"
		cEmail += ::cEof
		cEmail += "<body onLoad='loadval();'>"
		cEmail += ::cEof
		cEmail += "<br>"
		cEmail += ::cEof
		cEmail += "<table style='border-collapse: collapse;' id='AutoNumber2' align='center' border='0' bordercolor='#111111' cellpadding='0'"
		cEmail += ::cEof
		cEmail += "cellspacing='0' height='32' width='100%'>"
		cEmail += ::cEof
		cEmail += "<tbody>"
		cEmail += ::cEof
		cEmail += "<tr>"
		cEmail += ::cEof
		cEmail += "<td height='32' width='14%'>&nbsp;<img src='" + ::cLogo + "' border='0'></td>"
		cEmail += ::cEof
		cEmail += "<td height='32' width='59%'>"
		cEmail += ::cEof
		cEmail += "<p align='center'><strong><font color='#000000' face='Verdana, Arial, Helvetica, sans-serif' size='2'>"
		cEmail += Alltrim(SM0->M0_NOMECOM)+" - CNPJ : "+Alltrim(SM0->M0_CGC)+"<br>"
		cEmail += Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" / "+Alltrim(SM0->M0_ESTCOB)+"<br>"
		cEmail += "Fone : "+Alltrim(SM0->M0_TEL)+" - Fax : "+Alltrim(SM0->M0_FAX)+"</font></strong></p>"
		cEmail += "</td>"
		cEmail += ::cEof
		cEmail += "<td height='32' width='27%'>"
		cEmail += ::cEof
		cEmail += "</td>"
		cEmail += ::cEof
		cEmail += "</tr>"
		cEmail += ::cEof
		cEmail += "</tbody>"
		cEmail += ::cEof
		cEmail += "</table>"
		cEmail += ::cEof
		cEmail += "<br>"
		cEmail += ::cEof
		cEmail += "<table align='center' border='0' cellpadding='0' cellspacing='0' width='100%'>"
		cEmail += ::cEof
		cEmail += "<tbody>"
		cEmail += ::cEof
		cEmail += "<tr background='http://localhost/pontilhado.gif'>"
		cEmail += ::cEof
		cEmail += "<td class='TarjaTopoCor' height='5'> <img src='http://localhost/transparente.gif' height='1' width='1'></td>"
		cEmail += ::cEof
		cEmail += "</tr>"
		cEmail += ::cEof
		cEmail += "</tbody>"
		cEmail += ::cEof
		cEmail += "</table>"
		cEmail += ::cEof
		cEmail += "<br>"
		cEmail += ::cEof
		cEmail += "<table style='border-collapse: collapse;' id='AutoNumber2' align='center' border='0' bordercolor='#111111'"
		cEmail += ::cEof
		cEmail += "cellpadding='0' cellspacing='0' height='32' width='100%'>"
		cEmail += ::cEof
		cEmail += "<tbody>"
		cEmail += ::cEof
		cEmail += "<tr>"
		cEmail += ::cEof
		cEmail += "<td height='32' width='59%'>"
		cEmail += ::cEof
		
		
		cEmail += "<p align='center'><font face='Arial' size='5'>" + ::cCabecalho + "</font></p>"
		cEmail += ::cEof
		
		cEmail += "</td>"
		cEmail += ::cEof
		cEmail += "</tr>"
		cEmail += ::cEof
		cEmail += "</tbody>"
		cEmail += ::cEof
		cEmail += "</table>"
		cEmail += ::cEof
		cEmail += "<br>"
		cEmail += ::cEof
		cEmail += "<table align='center' bgcolor='#f7f7f7' border='1' bordercolor='#e5e5e5'"
		cEmail += ::cEof
		cEmail += "cellpadding='6' cellspacing='0' width='99%'>"
		cEmail += ::cEof
		cEmail += "<tbody>"
		cEmail += ::cEof
		cEmail += "<tr>"
		cEmail += ::cEof
		cEmail += "<td bordercolor='#FFFFFF' class='titulo' width='100%'>"
		cEmail += ::cEof
		cEmail += "<table border='0' cellpadding='2' cellspacing='1' height='36' width='1024'>"
		cEmail += ::cEof
		cEmail += "<tbody>"
		cEmail += ::cEof
		cEmail += "<tr>"
		cEmail += ::cEof
		cEmail += "</tr>"
		cEmail += ::cEof
		cEmail += "</tbody>"
		cEmail += ::cEof
		cEmail += "</table>"
		cEmail += ::cEof
		cEmail += "<table border='0' cellspacing='2' height='41' width='100%'>"
		cEmail += ::cEof
		cEmail += "<tbody>"
		cEmail += ::cEof
		
		cEmail += " <tr class='texto-layer' bgcolor='#CCCCCC' align='Left'  >"
		cEmail += ::cEof
		
		For nB := 1 to Len(::aCabec)
			cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+::aCabec[nB]+"</TD>"
			cEmail += ::cEof
		Next nB
		cEmail += "</TR>"
		
		::IncLine(cEmail)
		cEmail := ""
		
		For nB := 1 to Len(aAux)
			cEmail += "<tr class='texto-layer' bgcolor='"+iif(Empty(aAux[nB][1][2]),"#cccccc","#ffffff")+"' align='Left'>"
			cEmail += ::cEof
			
			aItem := aAux[nB,1]
			
			For nX := 1 To Len(aItem)
				cEmail += "	<td align='left' height='19' width='6%' colspan='7'>"+aItem[nX]+"</TD>"
				cEmail += ::cEof
			Next
			
			cEmail += "</tr>"
			cEmail += ::cEof
			
			::IncLine(cEmail)
			cEmail := ""
			
		Next
		
		
		cEmail += "</tbody>"
		cEmail += ::cEof
		cEmail += "</table>"
		cEmail += ::cEof
		cEmail += "&nbsp;&nbsp;"
		cEmail += ::cEof
		cEmail += "</div>"
		cEmail += ::cEof
		cEmail += "</td>"
		cEmail += ::cEof
		cEmail += "</tr>"
		cEmail += ::cEof
		cEmail += "</tbody>"
		cEmail += ::cEof
		cEmail += "</table>"
		cEmail += ::cEof
		cEmail += "</span>"
		cEmail += ::cEof
		cEmail += "<br>"
		cEmail += ::cEof
		cEmail += "<br>"
		cEmail += ::cEof
		cEmail += "<table align='center' bgcolor='#f7f7f7' border='1' bordercolor='#e5e5e5'"
		cEmail += ::cEof
		cEmail += "cellpadding='0' cellspacing='0' width='100%'>"
		cEmail += ::cEof
		cEmail += "<tbody>"
		cEmail += ::cEof
		cEmail += "<tr>"
		cEmail += ::cEof
		cEmail += "<td bordercolor='#FFFFFF' width='100%'>"
		cEmail += ::cEof
		
		If !Empty(::cRodape)
			cEmail += "<p align='center'><font face='Arial' size='5'>" + ::cRodape + "</font></p>"
			cEmail += ::cEof
		EndIf
		
		cEmail += "</td>"
		cEmail += ::cEof
		cEmail += "</tr>"
		cEmail += ::cEof
		cEmail += "</tbody>"
		cEmail += ::cEof
		cEmail += "</table>"
		cEmail += ::cEof
		cEmail += "</body>"
		cEmail += ::cEof
		cEmail += "</html>"
		
		::IncLine(cEmail)
		::CloseArq()
	Endif
	
Return()

Method CreateFile(cFileName) Class SHMAIL
	Local lRet := .t.
	
	If File(cFileName)
		FErase(cFileName)
	Endif
	
	If (::cFile := FCreate(cFileName,0)) == -1
		lRet := .f.
	Endif
Return(lRet)

Method IncLine(cLine) Class SHMAIL
	Local cEol := "CHR(13)+CHR(10)"
	FWrite(::cFile, cLine + &cEol )
Return

Method CloseArq() Class SHMAIL
	Local lRet := .t.
	
	If (fClose(::cFile))
		lRet := .f.
	Endif
Return(lRet)

Method setTipoWf(cParam) Class SHMAIL
	::cTpWf := cParam
Return

Method getTipoWf() Class SHMAIL
	Local cRet := ::cTpWf
Return(cRet)

Method setDirWf(cParam) Class SHMAIL
	::cDirAux := cParam
Return

Method getDirWf() Class SHMAIL
	Local cRet := ::cDirAux
Return(cRet)