#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
  
/*
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????ͻ??
??? Programa    ? Fun??es  ? Biblioteca de fun??es gen?ricas                              ???
?????????????????????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????????
*/
/*
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????ͻ??
??? Programa    ? vEnvMail ? Fun??o para envio de e-mail                                  ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Autor       ? 15.09.04 ?                                                              ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Produ??o    ? ??.??.?? ? Ignorado                                                     ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Par?metros  ? ExpC1: e-mail do destinat?rio                                           ???
???             ? ExpC2: assunto do e-mail                                                ???
???             ? ExpC3: texto do e-mail                                                  ???
???             ? ExpC4: anexos do e-mail                                                 ???
???             ? ExpL1: exibe mensagem de envio                                          ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Retorno     ? ExpL2: .T. - envio realizado                                            ???
???             ?        .F. - n?o enviado                                                ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Observa??es ?                                                                         ???
???             ?                                                                         ???
???             ?                                                                         ???
???             ?                                                                         ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Altera??es  ? 99.99.99 - Consultor - Descri??o da altera??o                           ???
???             ?                                                                         ???
?????????????????????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????????
*/
User Function vEnvMail(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem)

Local lRet	:= .T.
Private cMailServer		:= GetMv("MV_RElSERV")
Private cMailConta		:= GetMv("MV_RELACNT")
Private cMailSenha		:= GetMv("MV_RELPSW")
Private cMailDestino	:= If( ValType(cMailDestino) != "U" , cMailDestino,  "" )
Private lMensagem		:= If( ValType(lMensagem)    != "U" , lMensagem,  .T. )

// Efetua valida??es 
If Empty(cMailDestino)
	If lMensagem
		Aviso(	cCadastro,;
				"Conta(s) de e-mail de destino(s) n?o informada. Envio n?o realizado.",;
				{"&Ok"},,;
				"Falta informa??o" )
	EndIf
	lRet	:= .F.
EndIf

If Empty(cAssunto)
	If lMensagem
		Aviso(	cCadastro,;
				"Assunto do e-mail n?o informado. Envio n?o realizado.",;
				{"&Ok"},,;
				"Falta informa??o" )
	EndIf
	lRet	:= .F.
EndIf

If Empty(cTexto)
	If lMensagem
		Aviso(	cCadastro,;
				"Texto do e-mail n?o informado. Envio n?o realizado.",;
				{"&Ok"},,;
				"Falta informa??o" )
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
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????ͻ??
??? Programa    ? vEnvMail2? Fun??o complementar para envio do e-mail                     ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Autor       ? 15.09.04 ?                                                              ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Produ??o    ? ??.??.?? ? Ignorado                                                     ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Par?metros  ? ExpC1: e-mail do destinat?rio                                           ???
???             ? ExpC2: assunto do e-mail                                                ???
???             ? ExpC3: texto do e-mail                                                  ???
???             ? ExpC4: anexos do e-mail                                                 ???
???             ? ExpL1: exibe mensagem de envio                                          ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Retorno     ? ExpL2: .T. - envio realizado                                            ???
???             ?        .F. - n?o enviado                                                ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Observa??es ?                                                                         ???
???             ?                                                                         ???
???             ?                                                                         ???
???             ?                                                                         ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Altera??es  ? 99.99.99 - Consultor - Descri??o da altera??o                           ???
???             ?                                                                         ???
?????????????????????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????????
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
Local cUserAut    := Alltrim(GetMv("MV_RELAUSR")) //Usu?rio para Autentica??o no Servidor de Email
Local cSenhAut    := Alltrim(GetMv("MV_RELAPSW")) //Senha para Autentica??o no Servidor de Email
Local nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conex?o

If lMensagem
	IncProc("Conectando-se ao servidor de e-mail...")
EndIf

//??????????????????????????????????????????????????????Ŀ
//? Executa conexao ao servidor mencionado no parametro. ?
//????????????????????????????????????????????????????????
Connect Smtp Server cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lConexao

If !lAutOk 
	If lSmtpAuth
		lAutOk := MailAuth(cUserAut,cSenhAut)
		If !lAutOk
			Aviso(OemToAnsi("Atencao"),OemToAnsi("Falha na Autentica??o do Usu?rio no Provedor de E-mail - vEnvMail2"),{"Ok"})
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
 				"Nao foi poss?vel estabelecer conex?o com o servidor - "+cErro_Conexao,;
 				{"&Ok"},,;
 				"Sem Conex?o" )
	EndIf
	lRet := .F.
EndIf

If lMensagem
	IncProc("Enviando e-mail...")
EndIf

//????????????????????????????Ŀ
//? Executa envio da mensagem. ?
//??????????????????????????????
If !Empty(cAnexos)
	Send Mail From cMAILCONTA to cMAILDESTINO SubJect cASSUNTO BODY cTEXTO FORMAT TEXT ATTACHMENT cANEXOS RESULT LenVIO
Else
	Send Mail From cMAILCONTA to cMAILDESTINO SubJect cASSUNTO BODY cTEXTO FORMAT TEXT RESULT LenVIO
EndIf

If !lEnvio
	Get Mail Error cErro_Envio
	If lMensagem
		Aviso(	cCadastro,;
					"N?o foi poss?vel enviar a mensagem - "+cErro_Envio,;
					{"&Ok"},,;
					"Falha de envio" )
	EndIf
	lRet := .F.
EndIf

If lMensagem
   IncProc("Desconectando-se do servidor de e-mail...")
EndIf

//??????????????????????????????????????Ŀ
//? Executa disconexao ao servidor SMTP. ?
//????????????????????????????????????????
DisConnect Smtp Server Result lDesconexao

If !lDesconexao
	Get Mail Error cErro_Desconexao
	If lMensagem
		Aviso(	cCadastro,;
				"N?o foi poss?vel desconectar-se do servidor - "+cErro_Desconexao,;
				{"&Ok"},,;
				"Descone??o" )
	EndIf
	lRet := .F.
EndIf

Return(lRet)
