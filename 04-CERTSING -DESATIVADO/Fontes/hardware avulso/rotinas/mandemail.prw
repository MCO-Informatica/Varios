#include "Protheus.ch"
#include "ap5mail.ch"
#define _EOL chr(13) + chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMANDAEMAILบAutor  ณOpvs (David)        บ Data ณ  13/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNCAO PARA ENVIAR MENSAGENS                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MandEmail(xCorpo, xDest, xAssunto, xAnexo, xCC, xBCC, xAcc)

Local   cAccount  := AllTrim(GetNewPar("MV_RELACNT"," ")) 
Local   cPassword := AllTrim(GetNewPar("MV_RELPSW" ," "))
Local   cServer   := AllTrim(GetNewPar("MV_RELSERV"," "))
Local   cUserAut  := Alltrim(GetMv("MV_RELAUSR",,"")) //Usuแrio para Autentica็ใo no Servidor de Email
Local   cPassAut  := Alltrim(GetMv("MV_RELAPSW",,""))//Senha para Autentica็ใo no Servidor de Email
Local   nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conexใo
Local   lAutentica  := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autentica็ใo
Local   nI        := 1
Local   lRet      := .T. 

Default xDest     := ""
Default xCC		  := ""
Default xBCC      := ""
Default xCorpo	  := ""
Default xAnexo    := ""
Default xAssunto  := "<< Mensagem sem assunto >>"  

If Empty(xDest+xCC+xBCC)
//	ConOut("Nao Foram Econtrados endere็os para Enviar e-mail Mensagem: "+xAssunto)
	Return(lRet)
EndIf

_cMsg := "Conectando a " + cServer + _EOL +;
"Conta: " + cAccount + _EOL +;
"Senha: " + cPassword
//ConOut(_cMsg) 

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut Result lOk

If ( lOk )

    // Realiza autenticacao caso o servidor seja autenticado.
	If lAutentica
		If !MailAuth(cUserAut,cPassAut)
//			ConOut("Falha na Autentica็ใo do Usuแrio")
			DISCONNECT SMTP SERVER RESULT lOk
			IF !lOk
				GET MAIL ERROR cErrorMsg
//				ConOut("Erro na Desconexใo: "+cErrorMsg)
			ENDIF
			Return .F.
		EndIf
	EndIf

	SEND MAIL FROM cAccount TO xDest CC xCC BCC xBCC SUBJECT xAssunto BODY xCorpo ATTACHMENT xAnexo RESULT lOk

	If !lOk
		GET MAIL ERROR cErro
		cErro := "Erro durante o envio - destinatแrio: " + xDest + _EOL + _EOL + cErro
//		conout(cErro)
		lRet:= .F.
	Endif
	
	DISCONNECT SMTP SERVER RESULT lOk
	If !lOk
		GET MAIL ERROR cErro
///		conout(cErro)
	Endif
Else
	GET MAIL ERROR cErro
//	conout(cErro)
	lRet:= .F.
EndIf

Return(lRet)