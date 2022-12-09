#include "rwmake.ch"
#include "ap5mail.ch"              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ENVMAIL  บAutor  ณMarcelo Scibarauskasบ Data ณ  08/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de envio de emails                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ _cFrom - remetente do email                                บฑฑ
ฑฑบ          ณ _cTo - destinatario do email                               บฑฑ
ฑฑบ          ณ _cCC - destinatario da copia do email                      บฑฑ
ฑฑบ          ณ _cBCC - destinatario da copia oculta do email              บฑฑ
ฑฑบ          ณ _cSubject - Assunto do email                               บฑฑ
ฑฑบ          ณ _cBody - Corpo do email (pode usar codigo HTML)            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function EnvMail(_cTo, _cSubject, _cBody)


private _cSerMail	:= alltrim(GetMV("MV_RELSERV"))
private _cConta    	:= alltrim(GetMV("MV_RELACNT"))
private _cSenha		:= alltrim(GetMV("MV_RELPSW"))
private _lConectou	:= .F.
private _lEnviado	:= .F.
private _cMailError	:= ""
Private _cFrom 		:= _cConta


// Conecta ao servidor de email
CONNECT SMTP SERVER _cSerMail ACCOUNT _cConta PASSWORD _cSenha Result _lConectou

if !(_lConectou) // Se nao conectou informa o erro
	GET MAIL ERROR _cMailError
	MsgBox("Nใo foi possํvel conectar ao Servidor de email. Procure o Administrador da rede."+chr(13)+chr(10)+;
	"Erro retornado: "+_cMailError)
else
	
	If GetNewPar("MV_RELAUTH",.F.)
		_lRetAuth := MailAuth(_cConta,_cSenha)
	Else
		_lRetAuth := .T.
	EndIf
	
	If _lRetAuth

		SEND MAIL FROM _cFrom TO _cTo SUBJECT	_cSubject 	Body _cBody RESULT _lEnviado
					
	Else
		MsgBox("Nao foi possivel autenticar o usuario e senha para envio de e-mail!")
		lEnviado := .F.
	EndIf

	if !(_lEnviado)
		GET MAIL ERROR _cMailError
		MsgBox("Nใo foi possํvel enviar o email. Procure o Administrador da rede." + _cEnter + "Erro retornado: " + _cMailError)
	endif
	
	DISCONNECT SMTP SERVER
	
endif

return