#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "XMLXFUN.CH" 
#INCLUDE "FILEIO.CH"

#DEFINE ENT (CHR(13)+CHR(10))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณRCFGM001  บAutor  ณAdriano Leonardo     บ Data ณ 18/07/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina gen้rica para envio de e-mails.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11 e 12                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RCFGM001(Titulo,_cMsg,_cMail,_cAnexo,_cFromOri,_cBCC)

Local _aAnexo		:= {}
Local Cont			:= 1
Private oServer
Private oMessage
Private nMOb
Private nErr      	:= 0
Private _lSSL     	:= SuperGetMv("MV_RELSSL" ,,.F.)			// Usa SSL Seguro
Private _lTLS    	:= SuperGetMv("MV_RELTLS" ,,.F.)			// Usa TLS Seguro
Private _lConfirm 	:= .F.										// Confirma็ใo de leitura
Private cPopAddr  	:= Separa(GetMv("MV_RELSERV"),":")[01]
Private cSMTPAddr 	:= Separa(GetMv("MV_RELSERV"),":")[01]
Private cPOPPort  	:= 110
Private cSMTPPort 	:= Val(Separa(GetMv("MV_RELSERV"),":")[02])
Private cUser     	:= GetMv("MV_RELACNT")
Private cPass     	:= GetMv("MV_RELPSW")
Private nSMTPTime 	:= (SuperGetMv("MV_RELTIME" ,,120))		 	// Timeout SMTP
Private _cFrom    	:= GetMv("MV_RELACNT")					 	// Remetente da mensagem
Private _cTo      	:= ""                             			// Destinatแrio da mensagem
Private _cCC      	:= ""                            			// C๓pia da mensagem
Private _cAssunto 	:= ""
Private _cRotina  	:= "RCFGM001"
Private _lMultAnex	:= .F.

Default Titulo		:= ""
Default _cMsg		:= ""
Default _cMail		:= ""
Default _cAnexo		:= ""
Default _cFromOri	:= ""
Default _cBCC		:= ""										// C๓pia oculta

Public _aAnexTemp 	:= ""
Public _lRetMail  	:= .F.

If !Empty(_cMail)
	_cTo := _cMail
EndIf
If !Empty(Titulo)
	_cAssunto := AllTrim(Titulo)
EndIf

// Instancia um novo TMailManager
oServer := tMailManager():New()
If _lSSL
	// Usa SSL na conexao
	oServer:SetUseSSL(.T.)
EndIf
If _lTLS
	//Define no envio de e-mail o uso de STARTTLS durante o protocolo de comunica็ใo (Indica se, verdadeiro .T., utilizarแ a comunica็ใo segura atrav้s de SSL/TLS; caso contrแrio, .F.)
	oServer:SetUseTLS(.T.)
EndIf

//Inicializa
oServer:Init(cPopAddr, cSMTPAddr, cUser, cPass, cPOPPort, cSMTPPort)

//Define o Timeout SMTP
If oServer:SetSMTPTimeout(nSMTPTime) != 0
	MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ERROR] Falha ao definir timeout!",_cRotina+"_003")	
	Return(_lRetMail)
EndIf

// Conecta ao servidor
nErr := oServer:SMTPConnect()
//nErr := oServer:IMAPConnect()
//nErr := oServer:IMAPDisconnect()

If nErr <> 0
	MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ERROR] Falha ao conectar: " + AllTrim(Str(nErr)) + " - " + AllTrim(oServer:GetErrorString(nErr)) + "!",_cRotina+"_004")
	//oServer:SmtpDisconnect()
	//oServer:IMAPDisconnect()
	Return(_lRetMail)
EndIf

//oMailManager:SetUseRealID(.T.)		//Define o tipo de identifica็ใo, no servidor de e-mail IMAP - Internet Message Access Protocol, para utiliza็ใo do ID ๚nico da mensagem para a busca de mensagens.

// Realiza autentica็ใo no servidor
nErr := oServer:SmtpAuth(cUser, cPass)
If nErr <> 0
	MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ERROR] Falha ao autenticar: " + AllTrim(Str(nErr)) + " - " + AllTrim(oServer:getErrorString(nErr)) + "!",_cRotina+"_005")
	oServer:SmtpDisconnect()
	//oServer:IMAPDisconnect()
	Return(_lRetMail)
EndIf

// Cria uma nova mensagem atraves da Classe TMailMessage
oMessage := tMailMessage():New()
oMessage:Clear()
oMessage:cFrom := AllTrim(_cFrom)
oMessage:cTo   := AllTrim(_cTo)
If !Empty(_cCC)
	oMessage:cCC   := AllTrim(_cCC)
EndIf
If !Empty(_cBCC)
	oMessage:cBCC := AllTrim(_cBCC)
EndIf

oMessage:cSubject := AllTrim(_cAssunto)
_cTexto := "<html>"
_cTexto += "	<head>"
_cTexto += "		<title>"
_cTexto += "			" + oMessage:cSubject
_cTexto += "		</title>"
_cTexto += "	</head>"
_cTexto += "	<body>"
//_cTexto += "		<hr size=2 width='100%' align=center>"
//_cTexto += "		<BR>"
_cTexto += 			StrTran(_cMsg,CHR(10),"<BR>")
//_cTexto += "		<BR>"
//_cTexto += "		<hr size=2 width='100%' align=center>"
//_cTexto += "		<BR>"
_cTexto += "	</body>"
_cTexto += "</html>"

oMessage:cBody := _cTexto
oMessage:MsgBodyType("text/html")

//Para solicitar confima็ใo de envio
If _lConfirm
	oMessage:SetConfirmRead(.F.)
EndIf

//informo o server que iremos trabalhar com ID real da mensagem
//oMailManager:SetUseRealID(.T.)

//Adiciono attach (anexo)

//Trecho adicionado por Adriano Leonardo em 26/08/2013
If !Empty(_cAnexo) .And. ";" $ _cAnexo
	_aAnexo := StrTokArr(_cAnexo,";")
	_lMultAnex := .T.
	For cont:=1 To Len(_aAnexo)	
		If oMessage:AttachFile(_aAnexo[cont]) < 0
			MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ALERT] Falha ao anexar o arquivo "+_cAnexo+"!",_cRotina+"_006")
			oServer:SmtpDisconnect()
			Return(_lRetMail)
		Else
			//Adiciono uma tag informando que ้ um attach e o nome do arq
			//oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=' + _cAnexo)
			oMessage:AddAttHTag("Content-ID: <ID_" + _cAnexo + ">")
		EndIf
	Next
EndIf                                                      
//Fim do trecho adicionado por Adriano Leonardo em 26/08/2013

//If !Empty(_cAnexo) // Linha comentada por Adriano Leonardo em 26/08/2013 para melhoria na rotina(linha substituta logo abaixo)
If !Empty(_cAnexo) .And. !_lMultAnex
	If oMessage:AttachFile(_cAnexo) < 0
		MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ALERT] Falha ao anexar o arquivo "+_cAnexo+"!",_cRotina+"_006")
		oServer:SmtpDisconnect()
		//oServer:IMAPDisconnect()
		Return(_lRetMail)
	Else
		//Adiciono uma tag informando que ้ um attach e o nome do arq
		//oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=' + _cAnexo)
		oMessage:AddAttHTag("Content-ID: <ID_" + _cAnexo + ">")
	EndIf
EndIf

If !Empty(_cFromOri)
	oMessage:cFrom := _cFromOri
EndIf

// Envia a mensagem
nErr := oMessage:Send(oServer)
If nErr <> 0
	MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ERROR] Falha ao enviar: " + AllTrim(Str(nErr)) + " - " + AllTrim(oServer:GetErrorString(nErr)) + "!",_cRotina+"_002")
	oServer:SmtpDisconnect()
	//oServer:IMAPDisconnect()
	Return(_lRetMail)
EndIf

//Desconecto do servidor
If oServer:SmtpDisconnect() /*oServer:IMAPDisconnect()*/ != 0
	MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ERROR] Erro ao desconectar do servidor SMTP!",_cRotina+"_001")
EndIf

_aAnexTemp := _cAnexo
DeletTmp()

_lRetMail := .T.
Return(_lRetMail)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณ DeletTmp  บAutor ณ Adriano Leonardo de Souza Data ณ22/08/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑ บDesc.   ณ Fun็ใo responsแvel deletar os arquivos temporแrios.         นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso  P11  ณ Protheus11                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function DeletTmp()

   Local nCont2	:= 1
   
	If !Empty(_aAnexTemp) .And. ";" $ _aAnexTemp
		_aAnexo := StrTokArr(_aAnexTemp,";")
	
		For nCont2 := 1 To Len(_aAnexo)
			If File(_aAnexo[nCont2])    //Verifico a exist๊ncia do arquivo
				fErase(_aAnexo[nCont2]) //Apago o arquivo temporแrio
			EndIf
		Next
	Else
		If File(_aAnexTemp)            //Verifico a exist๊ncia do arquivo
			fErase(_aAnexTemp)         //Apago o arquivo temporแrio
		EndIf
	EndIf
	
Return()