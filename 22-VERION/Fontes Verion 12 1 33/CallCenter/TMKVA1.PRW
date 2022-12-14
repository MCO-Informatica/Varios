#include "AP5MAIL.ch"
#Include "Protheus.ch"

user Function TMKVA1()
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
Local cUserAut    := Alltrim(GetMv("MV_RELAUSR",,cMailConta)) //Usu?rio para Autentica??o no Servidor de Email
Local cSenhAut    := Alltrim(GetMv("MV_RELAPSW",,cMailSenha)) //Senha para Autentica??o no Servidor de Email
Local nTimeOut    := GetMv("MV_RELTIME",,240) //Tempo de Espera antes de abortar a Conex?o
                                           
Private cEmailTo    := Alltrim( GetNewPar("VR_TMKEML1","vendas@verion.com.br") )
Private cEmailCC    := Alltrim( GetNewPar("VR_TMKEML2","eli@verion.com.br") )
Private cAssunto    := PadR("Inclusao do Cliente - Via Call Center - Favor Validar !!!",120)
Private cMensagem   := " "
Private cAttach     := " "
Private lAciTM0     := .f.

_CNOM   := TkDCliente(SUA->UA_CLIENTE,SUA->UA_LOJA)
_DDTIC  := DDATABASE
_cusuar := substr(cusuario,7,15)
_cProd  := GetSxeNum("SA1")  // N?mero do Pr?ximo Or?amento

cMensagem   := "Inclusao do Cliente nr. "+_cprod+" - "+_CNOM+" na data "+dtoc(_ddtic)+" pelo(a) Sr(a) "+_cusuar
cMensagem   += Chr(13)+" Cidade - "+SA1->A1_MUN+" UF - "+SA1->A1_EST 

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
				Aviso(OemToAnsi("Atencao"),OemToAnsi("Falha na Autentica??o do Usu?rio no Provedor de E-mail - TMKVA1"),{"Ok"})
				RestArea(aArea)
				DISCONNECT SMTP SERVER
			Endif
		Else
			lAutOk := .T.
		EndIf
	EndIf

	If lOk .and. lAutOk
		SEND MAIL FROM cEmailTo /*"vendas@verion.com.br"*/;
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
Return(.t.)


//User Function TMKVA1()
//Local lRet 	  := .T.
//Return(lRet)
