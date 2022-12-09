#include "rwmake.ch"
#include "ap5mail.ch"
 
/*
***********************************************
* Progrma: EnvMail      Autor: Eduardo Pessoa *
* Descrição: Rotina para envio de emails.     *
* Data: 06/12/2007                            *
* Parametros: EMail Origem, EMail Destino,    *
*             Subject, Body, Anexo, .T., Bcc  *
***********************************************
*/ 
 
User Function ENVMAIL(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
/*Local _cMailS       := GetMv("MV_RELSERV")
Local _cAccount     := GetMV("MV_RELACNT") //IIf(_cConta=Nil,GetMV("MV_RELACNT"),_cConta)
Local _cPass        := GetMV("MV_RELFROM") //IIf(_cSenha=Nil,GetMV("MV_RELFROM"),_cSenha)
Local _cSenha2      := GetMV("MV_RELPSW")
Local _cUsuario2    := GetMV("MV_RELACNT")
Local lAuth         := GetMv("MV_RELAUTH",,.T.)*/

Local _nAux

// Variaveis da função
//**************************************************************
Private _nTentativas := 0
Private _cSMTPServer := GetMv("MV_RELSERV") //GetMV("MV_WFSMTP")
Private _cAccount    := GetMV("MV_RELACNT") //GetMV("MV_WFMAIL")
Private _cPassword   := GetMV("MV_RELPSW")
Private _lEnviado    := .F.
Private _cUsuario    := Upper(AllTrim(cUserName))
Private _nAux		:= 0
Private _cUsuario2    := GetMV("MV_RELACNT")
Private lAuth         := GetMv("MV_RELAUTH",,.T.)
 
// Validação dos campos do email
//**************************************************************
If _pcBcc == NIL
	_pcBcc := ""
EndIf
 
_pcBcc := StrTran(_pcBcc," ","")
 
If _pcOrigem == NIL
	_pcOrigem := GetMV("MV_RELFROM") //GetMV("MV_WFMAIL")
EndIf
 
_pcOrigem := StrTran(_pcOrigem," ","")
 
If _pcDestino == NIL
	_pcDestino := "rvalerio@westech.com.br"
EndIf
 
_pcDestino := StrTran(_pcDestino," ","")
 
If _pcSubject == NIL
	_pcSubject := "Sem Subject (ENVMAIL)"
EndIf
 
If _pcBody == NIL
	_pcBody := "Sem Body (ENVMAIL)"
EndIf
 
If _pcArquivo == NIL
	_pcArquivo := ""
EndIf
 
For _nAux := 1 To 10
	_pcOrigem := StrTran(_pcOrigem," ;","")
	_pcOrigem := StrTran(_pcOrigem,"; ","")
Next
 
If _plAutomatico == NIL
	_plAutomatico := .F.
EndIf
 
// Executa a função, mostrando a tela de envio (.T.) ou não (.F.)
//**************************************************************
If !_plAutomatico
    EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
	//Processa({||EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)},"Enviando EMail(s)...")
Else
	EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
EndIf
 
If !_plAutomatico
	If !_lEnviado
		MsgStop("Atenção: Erro no envio de EMail!!!!!!!")
	EndIf
Else
	ConOut("Atenção: Erro no envio de Email!")
Endif
 
Return _lEnviado
 
/*
***********************************************
* Progrma: EnviaEmail   Autor: Eduardo Pessoa *
* Descrição: Subrotina para envio de email.   *
* Data: 06/12/2007                            *
* Parametros: EMail Origem, EMail Destino,    *
*             Subject, Body, Anexo, .T., Bcc  *
***********************************************
*/ 
Static Function EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
// Veriaveis da função
//**************************************************************
Local _nTentMax := 50  // Tentativas máximas
Local _nSecMax  := 30  // Segundos máximos  
Local _cTime    := (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
Local _nAuxTime := 0
local _nTentativas
 
// O que ocorrer primeiro (segundos ou tentativas), ele para.
//**************************************************************
_cTime += _nSecMax
 
If !_plAutomatico
	ProcRegua(_nTentMax)
EndIf
 
// Exibe mensagem no console/Log
//**************************************************************
ConOut("ENVMAIL=> ***** Envio de Email ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))
 
For _nTentativas := 1 To _nTentMax
	
	If !_plAutomatico
		IncProc("Tentativa "+AllTrim(Str(_nTentativas)))
	EndIf
	ConOut("ENVMAIL=> ***** Tentativa "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))
	
	CONNECT SMTP SERVER _cSMTPServer ACCOUNT _cAccount PASSWORD _cPassword RESULT _lEnviado
	
    SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado

	/*If _lEnviado
		If Empty(_pcBcc)
			If Empty(_pcArquivo)
				SEND MAIL FROM _pcOrigem TO _pcDestino SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Else
				SEND MAIL FROM _pcOrigem TO _pcDestino SUBJECT _pcSubject BODY _pcBody ATTACHMENT _pcArquivo FORMAT TEXT RESULT _lEnviado
			EndIf
		Else
			If Empty(_pcArquivo)
				SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Else
				SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody ATTACHMENT _pcArquivo FORMAT TEXT RESULT _lEnviado
			EndIf
		EndIf
		DISCONNECT SMTP SERVER
	EndIf*/
	
	If _lEnviado .Or. _cTime <= (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
		_nTentativas := _nTentMax
	EndIf
Next
 
ConOut("ENVMAIL=> ***** Resultado de Envio "+IIf(_lEnviado,"T","F")+" / "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))
 
Return
//**************************************************************
//Fim códifo Função EnvMail
 
//inicio do código: função para testar o envio de email
//**************************************************************
#Include "Rwmake.ch"
 
/*
***********************************************
* Progrma: TestaMail    Autor: Eduardo Pessoa *
* Descrição: Envia email.                     *
* Data: 12/04/2008                            *
* Parametros:                                 *
*                                             *
***********************************************
*/ 
User Function TestaMail()
Local _cHTML := ""
 
_cHTML:='<HTML><HEAD><TITLE></TITLE>'
_cHTML+='<META http-equiv=Content-Type content="text/html; charset=windows-1252">'
_cHTML+='<META content="MSHTML 6.00.6000.16735" name=GENERATOR></HEAD>'
_cHTML+='<BODY>'
_cHTML+='<H1><FONT color=#ff0000>Envio de informações confidenciais</FONT></H1>'
_cHTML+='<TABLE cellSpacing=0 cellPadding=0 width="100%" bgColor=#afeeee background="" '
_cHTML+='border=1>'
_cHTML+='  <TBODY>'
_cHTML+='  <TR>'
_cHTML+='    <TD>Voce está participando</TD>'
_cHTML+='<TD>123</TD></TR>'
_cHTML+='  <TR>'
_cHTML+='    <TD>de um teste de envio</TD>'
_cHTML+='    <TD>456</TD></TR>'
_cHTML+='  <TR>'
_cHTML+='    <TD>de email!!!</TD>'
_cHTML+='    <TD>789</TD></TR></TBODY></TABLE>'
_cHTML+='<P>&nbsp;</P>'
_cHTML+='<P><A href="https://www.codigofonte.com.br">Clique nesse '
_cHTML+='link!!!</A></P></BODY></HTML>'
 
// Envia o e-mail
U_ENVMAIL("workflow@westech.com.br","rvalerio@westech.com.br","TESTE DE  ENVIO DE EMAIL...",_cHTML)
 
Return
//*******************************************************
//Fim do código - Envia Email
