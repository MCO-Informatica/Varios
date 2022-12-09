#include "totvs.ch"
#include "Ap5Mail.ch"

/*__________________________________________________________/
# Programa para envio de emails.							#
# Renato Ruy - 12/02/2014								    #
/__________________________________________________________*/ 
 
User Function CSWF001( _cEnvia, _cRecebe, _cAssunto, _cMensagem, _cAnexo )
 
Local cServer 	:= AllTrim(GetMV("MV_RELSERV"))
Local cAccount 	:= AllTrim(GetMV("MV_RELFROM"))
Local cEnvia 	:= _cEnvia
Local cRecebe 	:= _cRecebe
Local cPassword := AllTrim(GetMV("MV_CSGCT05"))
Local cAssunto	:= _cAssunto                                                                                                                                                                                                                                                    
Local nI := 1
Local cMensagem := _cMensagem
 
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou //realiza conexão com o servidor de internet
 
If lConectou
	If !Empty(_cAnexo)
		SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY cMensagem ATTACHMENT _cAnexo RESULT lEnviado
	Else
		SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY cMensagem RESULT lEnviado
	EndIf
Endif
 
If lEnviado  
Conout("E-mail enviado!")
Else
Conout("Erro no envio do e-mail!")
Endif
 
DISCONNECT SMTP SERVER Result lDisConectou
 
return()