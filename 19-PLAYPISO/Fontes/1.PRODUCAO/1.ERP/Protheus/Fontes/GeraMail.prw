#Include "Rwmake.ch"
#Include "Ap5mail.ch"
#Include "Tbicode.ch"
#Include "Tbiconn.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraMail  บAutor  ณ                    บ Data ณ10/09/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GeraMail( Destino, cSubject, Mensagem, aAttach, lWorkFlow, Copia )

Local _cAttach := ""
Servidor := GetMV("MV_RELSERV")
Conta    := GetMV("MV_RELACNT")
PassWord := GetMV("MV_RELPSW")
cFrom   := Conta

CONNECT SMTP SERVER Servidor ACCOUNT Conta PASSWORD Password Result lConectou

If !lConectou
	If !lWorkFlow
		MsgBox("Nao foi possivel conectar ao servidor","Erro de Conexao","Info")
	Else
		ConOut("Nao foi possivel conectar ao servidor")
	EndIf
	Return
Endif

If MailAuth(Conta, PassWord)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica quais sao os Atachados.             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For _i := 1 To Len(aAttach)
		If _i == 1
			_cAttach += aAttach[_i]
		Else
			_cAttach += ", "+aAttach[_i]
		EndIf
	Next
	
	If ValType(copia) <> 'U'
		SEND MAIL From cFrom;
		To Destino;
		CC Copia;
		SUBJECT cSubject ;
		BODY Mensagem ;
		ATTACHMENT _cAttach;
		RESULT lEnviado
	Else
		SEND MAIL From cFrom;
		To Destino;
		SUBJECT cSubject ;
		BODY Mensagem ;
		ATTACHMENT _cAttach;
		RESULT lEnviado
	EndIf
	
	If lEnviado
		If !lWorkFlow
			MsgInfo("E-Mail Enviado com Sucesso!")
		Else
			ConOut("E-Mail Enviado com Sucesso!")
		EndIf
	Else
		cMensagem := ""
		GET MAIL ERROR cMensagem
		If !lWorkFlow
			Alert(cMensagem)
		Else
			ConOut(cMensagem)
		EndIf
	Endif

Else
	MsgAlert("Erro na autenticacao no servidor.")
EndIf

DISCONNECT SMTP SERVER Result lDisConectou

If !lDisConectou
	If !lWorkFlow
		Alert("Nao foi possivel desconectar do servidor de E-Mail - " + Servidor)
	Else
		ConOut("Nao foi possivel desconectar do servidor de E-Mail - " + Servidor)
	EndIf
Endif

Return(lEnviado)