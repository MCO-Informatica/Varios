#include 'protheus.ch'
#include "TbiConn.ch" 

//-------------------------------------------------------------------
/*/{Protheus.doc} SFMAIL
Classe para auxiliar o envio de e-mail
@author  marcio.katsumata
@since   11/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFMAIL
    method new() constructor
	method sendMail()

	data user as character        //Usuário do FTP
	data password as character    //Senha do FTP

endclass


method new() class SFMAIL


return

//-------------------------------------------------------------------
/*/{Protheus.doc} sendMail
Método responsável por envio de e-mail 
@author  marcio.katsumata
@since   14/06/2019
@version 1.0
@param   cAssunto, character, assunto
@param   cMensagem, character, mensagem no corpo do e-mail
@param   cEmail   , character, e-mail do destinatário 
@param   aAttach  , array, vetor com os arquivos a serem enviados como anexo
@param   cMsgErro , character, mensagem de erro da rotina
@return  boolean, sucesso no envio da mensagem
/*/
//-------------------------------------------------------------------
method sendMail(cAssunto,cMensagem,cEmail,aAttach,cMsgErro) class SFMAIL
Local oMailServer 	:= Nil
Local cEmailTo   	:= ""
Local cEmailBcc		:= ""
Local cError    	:= ""  
Local cEMailAst 	:= cAssunto
Local oMessage
Local lResult
Local aAnexo		:= {}
// Verifica se serao utilizados os valores padrao.
local aInfoSrv      := strtokarr2(GetMV( "MV_RELSERV") , ":", .f.)
Local cAccount		:= alltrim(GetMV( "MV_RELACNT") )
Local cPassword		:= alltrim(GetMV( "MV_RELAPSW"))
Local cServer		:= iif (len(aInfoSrv)>= 1, aInfoSrv[1],"")//smtp do dominio
Local cAttach     	:= ""
Local cFrom   		:= cAccount              
Local lUseSSL     	:= GetMv("MV_RELSSL")        //Define se o envio e recebimento de E-Mail utilizara conexao segura (SSL);
Local lAuth      	:= GetMv("MV_RELAUTH")       //Servidor de E-Mail necessita de Autenticacao? Determina se o Servidor necessita de Autenticacao;
Local lTls			:= GetMV( "MV_RELTLS" )      //Informe se o servidor de SMTP tem conexão do tipo segura ( SSL/TLS ).    
Local nX        	:= 0
Local nPort			:= iif (len(aInfoSrv)== 2, val(aInfoSrv[2]),25) //Define porta que será utilizado para envio do Email
Default aAttach		:= {} 
Default lResult		:= .T.
Default cMsgErro	:= ""
cEmailTo 			:= cEmail
aAnexo 				:= Aclone(aAttach)

          
If !lAuth 
                               
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult
	//Valida se  realizará a conexão ao servidor antes de realizar o envio
	If lResult
		//Realiza o tratamento dos anexos
		For nX:= 1 to Len(aAnexo)
			cAttach += aAnexo[nX] + "; "
		Next nX
		
		SEND MAIL FROM cFrom ;
		TO          	cEmailTo;
		BCC        		cEmailBcc;
		SUBJECT     	Txt2Htm( cEMailAst, cEmail );
		BODY    		Txt2Htm( cMensagem, cEmail );
		ATTACHMENT  	cAttach  ;
		RESULT 			lResult
                                               
       If !lResult
       		//Erro no envio do email
      	 	GET MAIL ERROR cError
       		cMsgErro += "[SendMail] "+cError
       EndIf

       DISCONNECT SMTP SERVER

    Else
    	//Erro na conexao com o SMTP Server
    	GET MAIL ERROR cError                                       
    	cMsgErro += "[SendMail] "+cError                                                                       
	EndIf
		DISCONNECT SMTP SERVER
Else
     //Instancia o objeto do MailServer
     oMailServer:= TMailManager():New()
     oMailServer:SetUseSSL(lUseSSL)    //Obs: Apenas se servidor de e-mail utiliza autenticacao SSL para envio
     oMailServer:SetUseTLS(lTls)       //Obs: Apenas se servidor de e-mail utiliza autenticacao TLS para recebimento
     oMailServer:Init("",cServer,cAccount,cPassword,0,nPort)  
	cMsg :=  (cServer+","+cAccount+","+cPassword+","+cValToChar(nPort)+","+cValToChar(lUseSSL)+","+cValToChar(lTls)+";"+cEmailTo)
    FWLogMsg("INFO", "", "BusinessObject", "SFMAIL" , "", "", cMsg, 0, 0)
    //Definição do timeout do servidor
     If oMailServer:SetSmtpTimeOut(120) 
     	cMsgErro += "[SendMail]  Timeout no servidor de e-mail"
		 cMsg :=  ("timeout")
		 FWLogMsg("INFO", "", "BusinessObject", "SFMAIL" , "", "", cMsg, 0, 0)
     	Return .F.
     EndIf

     //Conexão com servidor
     nErr := oMailServer:smtpConnect()
     If nErr <> 0
     	cMsgErro+= oMailServer:getErrorString(nErr)
     	oMailServer:smtpDisconnect()
     	lResult := .F. // Especifica que no hay conexion para parar el proceso de envío
     	Return .F.
     EndIf

                               
     //Autenticação com servidor smtp
     nErr := oMailServer:smtpAuth(cAccount, cPassword)
     If nErr <> 0
     	cMsgErro += "[SendMail] Autenticação e-mail: "+oMailServer:getErrorString(nErr)
     	oMailServer:smtpDisconnect()
     	return .F.
     EndIf
                               
     //Cria objeto da mensagem+
     oMessage := tMailMessage():new()
     oMessage:clear()
     oMessage:cFrom := cFrom 
     oMessage:cTo := cEmailTo 
     oMessage:cCc := cEmailBcc
     oMessage:cSubject :=  cEMailAst
                
     oMessage:cBody := cMensagem
     //oMessage:AttachFile(_CAnexo)       						 //Adiciona um anexo, nesse caso a imagem esta no root
                               
     For nX := 1 to Len(aAnexo)
     	oMessage:AddAttHTag("Content-ID: <" + aAnexo[nX] + ">") //Essa tag, é a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
     	oMessage:AttachFile(aAnexo[nX])                       //Adiciona um anexo, nesse caso a imagem esta no root
     Next nX
                               
     //Dispara o email          
     nErr := oMessage:send(oMailServer)
     If nErr <> 0
     	cMsgErro += "[SendMail] "+oMailServer:getErrorString(nErr)
     	oMailServer:smtpDisconnect()
     	Return .F.
     Else
      lResult := .T.
     EndIf

      //Desconecta do servidor
    oMailServer:smtpDisconnect()
	freeObj(oMailServer)
EndIf

Return(lResult)


user function sfmail()
return