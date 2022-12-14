#include "protheus.ch"
#include "ap5mail.ch"            

USER Function MailNFE(cFilePath,cFileName,cCliente,cNumNota,cSerieNF,cTransp)

Local cAnexos := ""
Local cEndDanfe := ""
Local cDestino := "\system\pdf"
Local cExtensao := ".pdf"
Local lOk := .T.
Local cServer := GETMV("MV_RELSERV")
Local cAccount := GETMV("MV_RELACNT")
Local cPassword := GETMV("MV_RELPSW")
Local cDiretorio := ""
Local cFrom := GETMV("MV_RELFROM")
Local cTo := "alessandra@stch.com.br" //GETMV("MV_EMAILSC")
Local cMailEst := "alessandra@stch.com.br" // "teste@akad."
Local CC := "alessandra@stch.com.br" // "teste@akad"
Local cCC := "alessandra@stch.com.br" //""

Local cSubject := "NF-e "+ALLTRIM(cNumNota)+"/"+ALLTRIM(cSerieNF)

Local cBody := OEMTOANSI("Prezados Senhores")+CHR(13)+CHR(10)
cBody += CHR(13)+CHR(10)
cBody += OEMTOANSI("Segue anexo nota fiscal ")+ALLTRIM(cNumNota)+"/"+ALLTRIM(cSerieNF)+" e Boleto banc?rio para pagamento "+"."+CHR(13)+CHR(10)
cBody += CHR(13)+CHR(10)
cBody += OEMTOANSI("Atenciosamente")+CHR(13)+CHR(10)
cBody += CHR(13)+CHR(10)
cBody += alltrim(USRRETNAME(RETCODUSR()))+CHR(13)+CHR(10)
cBody += OEMTOANSI("DEPARTAMENTO")+CHR(13)+CHR(10)
cBody += OEMTOANSI("EMPRESA")+CHR(13)+CHR(10)
cBody += OEMTOANSI("Telefone: (11) 1111-1111")+CHR(13)+CHR(10)
cBody += OEMTOANSI("Aten??o: Este ? um email gerado automaticamente pelo sistema. Favor n?o responder este email.")+CHR(13)+CHR(10)


	cEndDanfe := ALLTRIM(cFilePath)+ALLTRIM(cFileName)+".pdf"
	//Inclui a Danfe no anexo do email
	CpyT2S(cEndDanfe,cDestino)
	
	cAnexos:= lower(ALLTRIM(cDestino+cFileName+cExtensao))  //UPPER AO CONTRARIO
		
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lOk
	
	If lOk
		//ALERT("Servidor de e-mail conectado!")
	ELSE
		ALERT("Servidor de e-mail N?O conectado!")
	Endif
	
	if !MailAuth(cFrom,cPassword)
		ALERT("Erro de autentica??o!")
		DISCONNECT SMTP SERVER
		ALERT("Servidor de e-mail desconectado!")
	ELSE
		//ALERT("SERVIDOR AUTENTICADO OK")
	ENDIF
	
	If lOk
		SEND MAIL FROM cFrom TO cTo CC cCC SUBJECT cSubject BODY cBody ATTACHMENT cAnexos Result lOk
	EndIf
	

	If !lOk
		Help("",1,"AVG0001056")
	EndIf
	
	DISCONNECT SMTP SERVER
	//ALERT("PROCESSO FINALIZADO")



Return .T.

