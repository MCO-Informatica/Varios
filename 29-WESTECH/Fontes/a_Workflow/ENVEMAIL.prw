#include "rwmake.ch"
#include "ap5mail.ch"

User Function zTestaMail()
    Local _cHTML := ""
    local _cSubject := "teste"
    _cHTML:='<HTML><HEAD><TITLE></TITLE>'
    _cHTML+='<META http-equiv=Content-Type content="text/html; charset=windows-1252">'
    _cHTML+='<META content="MSHTML 6.00.6000.16735" name=GENERATOR></HEAD>'
    _cHTML+='<BODY>'
    _cHTML+='<H1><FONT color=#ff0000>Envio de informações Pedido de Compra</FONT></H1>'
    _cHTML+='<p>texto aqui</p>'
    _cHTML+='</BODY></HTML>'
    // Envia o e-mail
    cAviso := u_envemail("workflow@westech.com.br","rvalerio@westech.com.br","","",_cSubject,_cHTML)
    
    alert(cAviso)
    
Return
//funcao
User Function zEnvEMail(_cSubject, _cBody, _cMailTo, _cCC, _cAnexo, _cConta, _cSenha)
Local _cMailS       := GetMv("MV_RELSERV")
Local _cAccount     := GetMV("MV_RELACNT") //IIf(_cConta=Nil,GetMV("MV_RELACNT"),_cConta)
Local _cPass        := GetMV("MV_RELFROM") //IIf(_cSenha=Nil,GetMV("MV_RELFROM"),_cSenha)
Local _cSenha2      := GetMV("MV_RELPSW")
Local _cUsuario2    := GetMV("MV_RELACNT")
Local lAuth         := GetMv("MV_RELAUTH",,.T.)
//Local _cSubject     := "teste"
//Local _cMailTo      := "rvalerio@westech.com.br"

ConOut("Enviando e-mail - " + _cSubject + " - para " + _cMailTo)

Connect Smtp Server _cMailS Account _cAccount Password _cPass RESULT lResult

If lAuth // Autenticacao da conta de e-mail
lResult := MailAuth(_cUsuario2, _cSenha2)
If !lResult
ConOut("Nao foi possivel autenticar a conta - " + _cUsuario2)
Return()
EndIf
EndIf

_xx := 0

lResult := .F.

do while !lResult

If !Empty(_cAnexo)
Send Mail From _cAccount To _cMailTo CC _cCC Subject _cSubject Body _cBody ATTACHMENT _cAnexo RESULT lResult
Else
Send Mail From _cAccount To _cMailTo CC _cCC Subject _cSubject Body _cBody RESULT lResult
Endif

_xx++
if _xx > 2
Exit
Else
Get Mail Error cErrorMsg
ConOut(cErrorMsg)
EndIf
EndDo

Return
