#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ Fun็๕es  ณ Biblioteca de fun็๕es gen้ricas                              บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ vEnvMail ณ Fun็ใo para envio de e-mail                                  บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 15.09.04 ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ ??.??.?? ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpC1: e-mail do destinatแrio                                           บฑฑ
ฑฑบ             ณ ExpC2: assunto do e-mail                                                บฑฑ
ฑฑบ             ณ ExpC3: texto do e-mail                                                  บฑฑ
ฑฑบ             ณ ExpC4: anexos do e-mail                                                 บฑฑ
ฑฑบ             ณ ExpL1: exibe mensagem de envio                                          บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ ExpL2: .T. - envio realizado                                            บฑฑ
ฑฑบ             ณ        .F. - nใo enviado                                                บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function vEnvMail(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem)

Local lRet	:= .T.
Private cMailServer		:= GetMv("MV_RElSERV")
Private cMailConta		:= GetMv("MV_RELACNT")
Private cMailSenha		:= GetMv("MV_RELPSW")
Private cMailDestino	:= If( ValType(cMailDestino) != "U" , cMailDestino,  "" )
Private lMensagem		:= If( ValType(lMensagem)    != "U" , lMensagem,  .T. )

// Efetua valida็๕es 
If Empty(cMailDestino)
	If lMensagem
		Aviso(	cCadastro,;
				"Conta(s) de e-mail de destino(s) nใo informada. Envio nใo realizado.",;
				{"&Ok"},,;
				"Falta informa็ใo" )
	EndIf
	lRet	:= .F.
EndIf

If Empty(cAssunto)
	If lMensagem
		Aviso(	cCadastro,;
				"Assunto do e-mail nใo informado. Envio nใo realizado.",;
				{"&Ok"},,;
				"Falta informa็ใo" )
	EndIf
	lRet	:= .F.
EndIf

If Empty(cTexto)
	If lMensagem
		Aviso(	cCadastro,;
				"Texto do e-mail nใo informado. Envio nใo realizado.",;
				{"&Ok"},,;
				"Falta informa็ใo" )
	EndIf
	lRet	:= .F.
EndIf

If lRet
	If lMensagem
		Processa({|| lRet := vEnvMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem)})
	Else
		lRet := vEnvMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem)
	EndIf
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ vEnvMail2ณ Fun็ใo complementar para envio do e-mail                     บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 15.09.04 ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ ??.??.?? ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpC1: e-mail do destinatแrio                                           บฑฑ
ฑฑบ             ณ ExpC2: assunto do e-mail                                                บฑฑ
ฑฑบ             ณ ExpC3: texto do e-mail                                                  บฑฑ
ฑฑบ             ณ ExpC4: anexos do e-mail                                                 บฑฑ
ฑฑบ             ณ ExpL1: exibe mensagem de envio                                          บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ ExpL2: .T. - envio realizado                                            บฑฑ
ฑฑบ             ณ        .F. - nใo enviado                                                บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function vEnvMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem)

Local lConexao			:= .F.
Local lEnvio			:= .F.
Local lDesconexao		:= .F.
Local lRet				:= .F.
Local cAssunto			:= If( ValType(cAssunto) != "U" , cAssunto , "" )
Local cTexto			:= If( ValType(cTexto)   != "U" , cTexto   , "" )
Local cAnexos			:= If( ValType(cAnexos)  != "U" , cAnexos  , "" )
Local cErro_Conexao		:= ""
Local cErro_Envio		:= ""
Local cErro_Desconexao	:= ""
Local lAutOk      := .F. 
Local lSmtpAuth   := GetMv("MV_RELAUTH",,.F.)
Local cUserAut    := Alltrim(GetMv("MV_RELAUSR")) //Usuแrio para Autentica็ใo no Servidor de Email
Local cSenhAut    := Alltrim(GetMv("MV_RELAPSW")) //Senha para Autentica็ใo no Servidor de Email
Local nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conexใo

If lMensagem
	IncProc("Conectando-se ao servidor de e-mail...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa conexao ao servidor mencionado no parametro. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Connect Smtp Server cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lConexao

If !lAutOk 
	If lSmtpAuth
		lAutOk := MailAuth(cUserAut,cSenhAut)
		If !lAutOk
			Aviso(OemToAnsi("Atencao"),OemToAnsi("Falha na Autentica็ใo do Usuแrio no Provedor de E-mail - vEnvMail2"),{"Ok"})
			DISCONNECT SMTP SERVER
			// Return ==> COMENTADO
		Endif
	Else
		lAutOk := .T.
	EndIf
EndIf

If !lConexao
	GET MAIL ERROR cErro_Conexao
	If lMensagem
 		Aviso(	cCadastro,;
 				"Nao foi possํvel estabelecer conexใo com o servidor - "+cErro_Conexao,;
 				{"&Ok"},,;
 				"Sem Conexใo" )
	EndIf
	lRet := .F.
EndIf

If lMensagem
	IncProc("Enviando e-mail...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa envio da mensagem. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(cAnexos)
	Send Mail From cMAILCONTA to cMAILDESTINO SubJect cASSUNTO BODY cTEXTO FORMAT TEXT ATTACHMENT cANEXOS RESULT LenVIO
Else
	Send Mail From cMAILCONTA to cMAILDESTINO SubJect cASSUNTO BODY cTEXTO FORMAT TEXT RESULT LenVIO
EndIf

If !lEnvio
	Get Mail Error cErro_Envio
	If lMensagem
		Aviso(	cCadastro,;
					"Nใo foi possํvel enviar a mensagem - "+cErro_Envio,;
					{"&Ok"},,;
					"Falha de envio" )
	EndIf
	lRet := .F.
EndIf

If lMensagem
   IncProc("Desconectando-se do servidor de e-mail...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa disconexao ao servidor SMTP. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DisConnect Smtp Server Result lDesconexao

If !lDesconexao
	Get Mail Error cErro_Desconexao
	If lMensagem
		Aviso(	cCadastro,;
				"Nใo foi possํvel desconectar-se do servidor - "+cErro_Desconexao,;
				{"&Ok"},,;
				"Descone็ใo" )
	EndIf
	lRet := .F.
EndIf

Return(lRet)
