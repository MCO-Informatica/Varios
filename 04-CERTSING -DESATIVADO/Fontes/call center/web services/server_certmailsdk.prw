#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Controle do Usuario                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE CertMailSdk DESCRIPTION "WebService para controle de Recebimento de emails na rotina ServiceDesk" NAMESPACE "http://192.168.16.10:1803/" 

	WSDATA xml	                As String    
	WSDATA xmlret               As String
	
	WSMETHOD ReceiveMail					DESCRIPTION "Recebe os emails para abertura de teleatendimento"
	WSMETHOD RetCtaMail						DESCRIPTION "retorna as contas ativas de email configuradas"
		
ENDWSSERVICE

WSMETHOD ReceiveMail WSRECEIVE xml WSSEND xmlret WSSERVICE CertMailSdk

Local lReturn	:= .T.
Local cError	:= ""
Local cWarning	:= ""

Local cCta		:= "" 
Local cType		:= ""  
Local cId		:= ""  
Local cFrom		:= ""  
Local cTo		:= ""  
Local cCc		:= ""  
Local cBcc		:= ""  
Local cSub		:= ""  
Local cAtt		:= ""
Local cErrTp	:= ""  
Local cErrDes	:= ""  
Local cErrSta	:= ""  
Local lProc		:= .F.
Local lInProc	:= .F.
Local cCodSDK	:= ""
Local cBase		:= ""

Local bRestVar	:= {||	cCta	:= "",; 
						cType	:= "",;  
						cId		:= "",;  
						cFrom	:= "",;  
						cTo		:= "",;  
						cCc		:= "",;  
						cBcc	:= "",;  
						cSub	:= "",;  
						cAtt	:= "",;
						cErrTp	:= "",;  
						cErrDes	:= "",;  
						cErrSta	:= "",;  
						lProc	:= .F.,;
						lInProc	:= .F.,;
						cCodSDK := "",;
						cBase	:= "" }
Local bGrvLog	:= {|| u_ctsdkput(cCta, cType, cId, cFrom, cTo, cCc, cBcc, cSub, cAtt, cErrTp, cErrDes, cErrSta, lProc, lInProc ,cCodSDK, cBase) }
Local bVldTag	:= {|a| iif(Type(a) <> "U",&(a),"") }
Local cXml		:= ::xml

Private nMail	:= 0
Private nErr	:= 0
Private oXml

u_ctsdkset()

oXml := XmlParser( ::xml, "_", @cError, @cWarning )

If !Empty(cError)
	::xmlret := XML_VERSION + CRLF
	::xmlret += '<MailNotificationFullType>' + CRLF
	::xmlret += '		<code>0</code>' + CRLF //1=sucesso na operação; 0=erro
	::xmlret += '		<msg>Inconsistencia no parse do xml de entrada</msg>' + CRLF
	::xmlret += '		<exception>'+cError+'</exception>' + CRLF
	::xmlret += '</MailNotificationFullType>' + CRLF 
	conout("Erro de parser "+CRLF+cError)
	Return(.T.)
EndIf

If Type("oXml:_MAILNOTIFICATION:_MESSAGE") <> "U"  .and. Type("oXml:_MAILNOTIFICATION:_ACCOUNT") <> "U" 
	If Valtype(oXml:_MAILNOTIFICATION:_MESSAGE) <> "A"
		XmlNode2Arr( oXml:_MAILNOTIFICATION:_MESSAGE, "_MESSAGE" )
	EndIf
	
	For nMail:=1 to len(oXml:_MAILNOTIFICATION:_MESSAGE)
		Eval(bRestVar)
		cCta	:= oXml:_MAILNOTIFICATION:_ACCOUNT:TEXT 
		cType	:= "R"  
		cId 	:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_MESSAGE[nMail]:_ID:TEXT")
		cFrom	:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_MESSAGE[nMail]:_FROM:TEXT")
		cTo		:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_MESSAGE[nMail]:_TO:TEXT")  
		cCc		:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_MESSAGE[nMail]:_CC:TEXT")
		cBcc	:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_MESSAGE[nMail]:_BCC:TEXT")  
		cSub	:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_MESSAGE[nMail]:_SUBJECT:TEXT")  
		cAtt	:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_MESSAGE[nMail]:_ATTACHMENTS:TEXT")  
		cBase	:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_MESSAGE[nMail]:_BASE:TEXT")  
		lProc	:= .F.
		lInProc	:= .F.
	    
	    eval(bGrvLog)
	Next
	
	If Type("oXml:_MAILNOTIFICATION:_ERROR") <> "U"
		If Valtype(oXml:_MAILNOTIFICATION:_ERROR) <> "A"
			XmlNode2Arr( oXml:_MAILNOTIFICATION:_ERROR, "_ERROR" )
		EndIf
		
		For nErr:=1 to Len(oXml:_MAILNOTIFICATION:_ERROR)
			Eval(bRestVar)
			cCta	:= oXml:_MAILNOTIFICATION:_ACCOUNT:TEXT 
			cType	:= "E"  
			cErrTp	:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_ERROR[nErr]:_TYPE:TEXT") 	
			cErrDes	:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_ERROR[nErr]:_DESCRIPTION:TEXT")
			cErrSta	:= Eval(bVldTag,"oXml:_MAILNOTIFICATION:_ERROR[nErr]:_STACKTRACE:TEXT") 
			lProc	:= .T.
			lInProc	:= .T.
		    
			eval(bGrvLog)
		Next	
	EndIf
EndIf

::xmlret := XML_VERSION + CRLF
::xmlret += '<MailNotificationFullType>' + CRLF
::xmlret += '		<code>1</code>' + CRLF //1=sucesso na operação; 0=erro
::xmlret += '		<msg>Xml Processado com Sucesso</msg>' + CRLF
::xmlret += '		<exception></exception>' + CRLF
::xmlret += '</MailNotificationFullType>' + CRLF 

Return(lReturn)

WSMETHOD RetCtaMail WSRECEIVE NULLPARAM WSSEND xmlret WSSERVICE CertMailSdk
Local lReturn	:= .T.
Local cDirMail	:= GetNewPar("MV_XDIRSDK","\mailbox")
Local cRootPath	:= GetSrvProfString("RootPath","")
Local cCtaMail	:= GetNewPar("MV_XCTASDK","")
Local cStore	:= GetNewPar("MV_XSTRSDK","pop3s")
Local cXPrtSdk	:= GetNewPar("MV_XPRTSDK","995")

/*
none - nao descarta nenhuma mensagem (util para testes ou desenvolvimento);
seen - despreza mensagens lidas anteriormente, mas nao as descarta;
deleted - remove as mensagens apos a leitura;
*/
Local cDiscard	:= GetNewPar("MV_XDISSDK","seen")
Local cTmpVer	:= GetNewPar("MV_XFRESDK","120")
Local cNumMsg	:= GetNewPar("MV_XNMSGDK","25")

BeginSql Alias "TRBSZR"

	SELECT
	  ZR_SERVER,
	  ZR_CTAMAIL,
	  ZR_PASMAIL,
	  ZR_GRPSDK
	FROM
	  %Table:SZR%
	WHERE
	  ZR_ATIVO = 'S' AND
	  %notdel%

EndSql

::xmlret := ""
::xmlret += XML_VERSION+CRLF
::xmlret += '<MailReader xmlns="http://www.certisign.com.br/MailReaderXMLSchema" >'+CRLF
::xmlret += "	<root>"+Alltrim(cRootPath)+Alltrim(cDirMail)+"</root>"+CRLF
::xmlret += "	<config> "+CRLF
::xmlret += "		<discardStrategy>"+Alltrim(cDiscard)+"</discardStrategy> "+CRLF
::xmlret += "		<frequency>"+Alltrim(cTmpVer)+"</frequency> "+CRLF
::xmlret += "		<numberMessages>"+Alltrim(cNumMsg)+"</numberMessages> "+CRLF
::xmlret += "	</config> "+CRLF
::xmlret += "	<servers>"+CRLF
While !TRBSZR->(EoF())
	If Empty(cCtaMail) .or. ( Upper(Alltrim(TRBSZR->ZR_GRPSDK)) $ Upper(Alltrim(cCtaMail)) )
		::xmlret += "		<server>"+CRLF
		::xmlret += "			<host>"+Alltrim(TRBSZR->ZR_SERVER)+"</host>"+CRLF
		::xmlret += "			<port>"+cXPrtSdk+"</port>"+CRLF
		::xmlret += "			<store>"+Alltrim(cStore)+"</store>"+CRLF
		::xmlret += "				<account>"+CRLF
		::xmlret += "					<username>"+Lower(Alltrim(TRBSZR->ZR_CTAMAIL))+"</username>"+CRLF
		::xmlret += "					<password>"+Alltrim(PswEncript(TRBSZR->ZR_PASMAIL,1))+"</password>"+CRLF
		::xmlret += "				</account>"+CRLF
		::xmlret += "		</server>"+CRLF
	EndIf
	TRBSZR->(DbSkip())
EndDo
::xmlret += "	</servers>"+CRLF
TRBSZR->(DbGoTop())
::xmlret += "	<groups>"+CRLF
While !TRBSZR->(EoF())

	If Empty(cCtaMail) .or. ( Upper(Alltrim(TRBSZR->ZR_GRPSDK)) $ Upper(Alltrim(cCtaMail)) )
		::xmlret += "		<group>"+CRLF
		::xmlret += "			<id>"+Alltrim(TRBSZR->ZR_GRPSDK)+"</id>"+CRLF
		::xmlret += "			<accounts>"+Lower(Alltrim(TRBSZR->ZR_CTAMAIL))+"</accounts>"+CRLF
		::xmlret += "		</group>"+CRLF
	EndIf	
	TRBSZR->(DbSkip())
EndDo
::xmlret += "	</groups>"+CRLF
::xmlret += "</MailReader>"+CRLF	

TRBSZR->(DbCloseArea())

Return(lReturn)
