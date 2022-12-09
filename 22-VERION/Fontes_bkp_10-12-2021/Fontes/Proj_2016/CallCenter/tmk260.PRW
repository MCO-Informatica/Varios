#include "AP5MAIL.ch"
#Include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ tmk260   ³ Autor ³Ricardo Cavalini       ³ Data ³ 03/02/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Apos a inclusao de prospect (Ponto de Entrada)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ tmk2600 ()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGAFat                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos  ³ SA1 ( cadastro de clientes )                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user Function tmk260()
Local nOpcao := 0
Local oMemo,oDlg1
Local aArea       := GetArea()
Local lOk         := .F.		// Variavel que verifica se foi conectado OK
Local lAutOk      := .F. 
Local lSendOk     := .F.		// Variavel que verifica se foi enviado OK
Local cMailConta  := AllTrim(GetNewPar("MV_RELACNT"," "))
Local cMailServer := AllTrim(GetNewPar("MV_RELSERV"," "))
Local cMailSenha  := AllTrim(GetNewPar("MV_RELPSW" ," "))
Local lSmtpAuth   := GetMv("MV_RELAUTH",,.F.)
Local cUserAut    := Alltrim(GetMv("MV_RELAUSR",,cMailConta)) //Usuário para Autenticação no Servidor de Email
Local cSenhAut    := Alltrim(GetMv("MV_RELAPSW",,cMailSenha)) //Senha para Autenticação no Servidor de Email
Local nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conexão

Private cEmailTo    := "vendas@verion.com.br"
Private cEmailCC    := "cleide@verion.com.br;tereza@verion.com.br;eli@verion.com.br"
Private cAssunto    := PadR("Inclusao do Cliente - Via Call Center - Favor Validar !!!",120)
Private cMensagem   := " "
Private cAttach     := " "
Private lAciTM0 := .f.

_cProd  := SUS->US_COD
_CNOM   := SUS->US_NOME
_DDTIC  := DDATABASE
_cusuar := substr(cusuario,7,15)

cMensagem   := "Inclusao de Prospect nr. "+_cprod+" - "+_CNOM+" na data "+dtoc(_ddtic)+" pelo(a) Sr(a) "+_cusuar

//Verifica se existe o SMTP Server
If 	Empty(cMailServer)
	Help(" ",1,"ATENCAO",,"O Servidor de SMTP nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELSERV).",4,5)
	RestArea(aArea)
	Return
EndIf

//Verifica se existe a CONTA 
If 	Empty(cMailConta)
	Help(" ",1,"ATENCAO",,"A Conta do email nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELACNT).",4,5)
	RestArea(aArea)
	Return
EndIf

//Verifica se existe a Senha
If 	Empty(cMailSenha) 
	Help(" ",1,"ATENCAO",,"A Senha do email nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELPSW).",4,5)
	RestArea(aArea)
	Return
EndIf

// Envia e-mail com os dados necessarios
If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nTimeOut RESULT lOk

	If !lAutOk 
		If lSmtpAuth
			lAutOk := MailAuth(cUserAut,cSenhAut)
			If !lAutOk
				Aviso(OemToAnsi("Atencao"),OemToAnsi("Falha na Autenticação do Usuário no Provedor de E-mail - tmk260"),{"Ok"})
				RestArea(aArea)
				DISCONNECT SMTP SERVER
				//	Return  = Linha Comentanda em 26/03/10  - Conforme solicitação da Sr. Elisangela.
				lAutOk := .T.
			Endif
		Else
			lAutOk := .T.
		EndIf
	EndIf

	If lOk .and. lAutOk
			SEND MAIL FROM "verion@verion.com.br";
					TO cEmailTo;
 					CC cEmailcc;					
					SUBJECT Trim(cAssunto);
					BODY cMensagem;  
					RESULT lSendOk 
		If !lSendOk
			Help(" ",1,"ATENCAO",,"Erro no envio de Email",4,5)
		EndIf
	Else
		Help(" ",1,"ATENCAO",,"Erro na conexao com o SMTP Server",4,5)
	EndIf
	DISCONNECT SMTP SERVER
EndIf                   

RestArea(aArea)
Return