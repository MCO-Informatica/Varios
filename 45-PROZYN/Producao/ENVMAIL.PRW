#include 'protheus.ch'
#include 'ap5mail.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³U_ENVMAIL  ºAutor  ³Daniel Paulo       º Data ³  01/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email personalizado do cliente.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP12 - Prozyn                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function U_ENVMAIL(_cRemet, _cDest, _cAssunto, _cMsg, _aAnexos, _cPasta, _lMsg)

// Variaveis para envio do email.

Local cError   := "" // Mensagem de erro a ser mostrada.
Local lResult  := .F. // Resultado de uma conexao ou envio.
Local _cAnexos := '' 
Local _nA      := 0

Private cServer  := Trim(GetMV("MV_RELSERV"))
Private cUser    := Trim(GetMV("MV_RELACNT"))
Private cPass    := Trim(GetMV("MV_RELPSW"))
Private cFrom    := _cRemet // E-mail utilizado para envio de msg.
Private cTo      := _cDest // Grupo de e-mail que recebera a msg.
Private cSubject := _cAssunto // Titulo do e-mail.

Default _lMsg := .F.

For _nA := 1 To Len(_aAnexos)
	
	If _nA > 1
		
		_cAnexos += ';'
		
	EndIf
	
	_cAnexos += _cPasta + _aAnexos[_nA][1]
	
Next _nA

//Conecta no servidor.
CONNECT SMTP SERVER cServer ACCOUNT cUser PASSWORD cPass RESULT lResult

If !lResult
	
	GET MAIL ERROR cError // Atribui retorno de e-mail na variavel cError.
	
	If _lMsg
		
		MsgStop("Erro ao conectar no servidor: " + cError)
		
	Else
		
		Conout("Erro ao conectar no servidor: " + cError)
		
	EndIf
	
	Return
	
Else
	
	Conout("Conectado no Servidor")
	
	If GetMv("MV_RELAUTH")
		
		MailAuth(cUser, cPass)
		
	EndIf
	
EndIf

// Envia mensagem.
SEND MAIL FROM cFrom TO cTo SUBJECT cSubject BODY _cMsg ATTACHMENT _cAnexos RESULT lResult

If !lResult
	
	GET MAIL ERROR cError // Atribui retorno de e-mail na variavel cError.
	
	If _lMsg
		
		MsgStop("Erro ao enviar e-mail: " + cError)
		
	Else
		
		Conout("Erro ao enviar e-mail: " + cError)
		
	EndIf
	
Else
	
	If _lMsg
		
		Alert('Email enviado com sucesso !')
		
	Else
		
		Conout('Email enviado com sucesso !')
		
	EndIf
	
EndIf

Return lResult


      
