#Include "Protheus.CH"
#Include "RwMake.Ch"
#Include "TopConn.CH"
#include "TBICONN.CH" 

#DEFINE CRLF CHR(13) + CHR(10)

User Function HCIDA019()

	Local _aCores		:= {}
	Local cUserAdmin	:= GetMv("ES_Z0ADMUS",,"000000,000335,000148")
	Local _cVend		:= FT300VEND()
	
	Private cCadastro	:= OEMTOANSI("Apontamento de Visita")
	Private _cFiltro	:= ""
	Private aRotina		:= {}
	
	// Adiciona elementos ao aRotina
	Aadd(aRotina,{"Pesquisar"		,"AxPesqui"			,0,1})
	Aadd(aRotina,{"Visualizar"		,"u_fHCIDA19(2)"	,0,2})
	Aadd(aRotina,{"Incluir"			,"u_fHCIDA19(3)"	,0,3})

	If !(__cUserID $ cUserAdmin)			
		_cFiltro := "AD5_VEND = '" + _cVend + "'"
		MBrowse(6, 1,22,75,"AD5",,,,,,/*_aCores*/,,,,,,,,_cFiltro)						
	Else		
		MBrowse(6, 1,22,75,"AD5",,,,,,/*_aCores*/)		
	EndIf
	
Return()

User Function fHCIDA19(_nOpc)
	
	Local _aArea	:= GetArea()
	Local _nOpcA	:= 0
	Local _aEncho	:= {}

	Do Case
		Case _nOpc == 2
			aadd(_aEncho,"AD5_VEND")
			aadd(_aEncho,"AD5_NOMVEN")
			aadd(_aEncho,"AD5_DATA")
			aadd(_aEncho,"AD5_SEQUEN")
			aadd(_aEncho,"AD5_CODCLI")
			aadd(_aEncho,"AD5_LOJA")
			aadd(_aEncho,"AD5_NROPOR")
			aadd(_aEncho,"AD5_EVENTO")
			aadd(_aEncho,"AD5_DESEVE")
			aadd(_aEncho,"AD5_RESULT")
			aadd(_aEncho,"AD5_PROSPE")
			aadd(_aEncho,"AD5_LOJPRO")
			Aadd(_aEncho,"NOUSER")
			
			_nOpcA := AxVisual( "AD5", AD5->(Recno()), 3,_aEncho,,,,,,,,,.T.)
			MBrChgLoop(.F.)
			
		Case _nOpc == 3
			aadd(_aEncho,"AD5_VEND")
			aadd(_aEncho,"AD5_NOMVEN")
			aadd(_aEncho,"AD5_DATA")
			aadd(_aEncho,"AD5_SEQUEN")
			aadd(_aEncho,"AD5_CODCLI")
			aadd(_aEncho,"AD5_LOJA")
			aadd(_aEncho,"AD5_NROPOR")
			aadd(_aEncho,"AD5_EVENTO")
			aadd(_aEncho,"AD5_DESEVE")
			aadd(_aEncho,"AD5_RESULT")
			aadd(_aEncho,"AD5_PROSPE")
			aadd(_aEncho,"AD5_LOJPRO")
			Aadd(_aEncho,"NOUSER")
			
			_nOpcA := AxInclui( "AD5", AD5->(Recno()), 3,_aEncho,,,,,,,,,.T.)
			If _nOpcA == 1
				fWFApto()
			EndIf
			MBrChgLoop(.F.)

	EndCase
	
	RestArea(_aArea)

Return()

User Function fWFApto()

	Local _cMsg			:= ""
	Local _cAssunto		:= "Aviso de Apontamento- " + Alltrim(AD5->AD5_VEND) + "/Data " + SubStr(DtoS(dDataBase),7,2) + "/" + SubStr(DtoS(dDataBase),5,2) + "/" + SubStr(DtoS(dDataBase),1,4) + " - " + time()
	Local _cPara		:= ""
	Local _cCopy		:= ""
	Local _nI			:= 0
	Local _aEmailApt	:= Separa(GetMV("ES_WFHSTPT",,"000076,000009,000254,000256,000515,000057,000148"),",")
		
	Begin Transaction 

		For _nI	:= 1 To Len(_aEmailApt)
		
			_cMsg	:= '<html>'+CRLF
			_cMsg	+= '	<head>'+CRLF
			_cMsg	+= '		<title>Apontamento</title>'+CRLF
			_cMsg	+= '	</head> '+CRLF
			_cMsg	+= '	<body> '+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<FONT SIZE = "5" COLOR = "#000099"><B><center>Apontamento - ' + Alltrim(AD5->AD5_VEND) + "/Data " + SubStr(DtoS(dDataBase),7,2) + "/" + SubStr(DtoS(dDataBase),5,2) + "/" + SubStr(DtoS(dDataBase),1,4) + " - " + time()  + '</center></B></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Prezado(a) ' + UsrFullName(_aEmailApt[_nI]) +',</p></FONT>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Foi realizado a inclusão de apontamento: </p></FONT>'+CRLF 
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Vendedor: ' + AD5->AD5_NOMVEN + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Data: ' + SubStr(DtoS(AD5->AD5_DATA),7,2) + "/" + SubStr(DtoS(AD5->AD5_DATA),5,2) + "/" + SubStr(DtoS(AD5->AD5_DATA),1,4) + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Cliente: ' + POSICIONE("SA1",1,xFilial("SA1") + AD5->AD5_CODCLI + AD5->AD5_LOJCLI,"A1_NOME") + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Oportunidade: ' + AD5->AD5_NROPOR + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Evento: ' + AD5->AD5_EVENTO + AD5->AD5_DESEVE + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Prospect: ' + AD5->AD5_PROSPE + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Resultado: ' + AD5->AD5_RESULT + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Grato(a).</p></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '	</body>'+CRLF
			_cMsg	+= '</html>'+CRLF
			
			_cPara		:= AllTrim(UsrRetMail(_aEmailApt[_nI]))
			
			MailDSC(_cPara, _cAssunto, _cMsg, _cCopy)
			
		Next _nI	
		
		If !Empty(AD5->AD5_VEND)
	
			_cMsg	:= '<html>'+CRLF
			_cMsg	+= '	<head>'+CRLF
			_cMsg	+= '		<title>Apontamento</title>'+CRLF
			_cMsg	+= '	</head> '+CRLF
			_cMsg	+= '	<body> '+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<FONT SIZE = "5" COLOR = "#000099"><B><center>Apontamento - ' + Alltrim(AD5->AD5_VEND) + "/Data " + SubStr(DtoS(dDataBase),7,2) + "/" + SubStr(DtoS(dDataBase),5,2) + "/" + SubStr(DtoS(dDataBase),1,4) + " - " + time()  + '</center></B></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Prezado(a) ' + SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + AD5->AD5_VEND,1)) +',</p></FONT>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Foi realizado a inclusão de apontamento: </p></FONT>'+CRLF 
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Vendedor: ' + AD5->AD5_NOMVEN + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Data: ' + SubStr(DtoS(AD5->AD5_DATA),7,2) + "/" + SubStr(DtoS(AD5->AD5_DATA),5,2) + "/" + SubStr(DtoS(AD5->AD5_DATA),1,4) + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Cliente: ' + POSICIONE("SA1",1,xFilial("SA1") + AD5->AD5_CODCLI + AD5->AD5_LOJCLI,"A1_NOME") + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Oportunidade: ' + AD5->AD5_NROPOR + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Evento: ' + AD5->AD5_EVENTO + AD5->AD5_DESEVE + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Prospect: ' + AD5->AD5_PROSPE + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Resultado: ' + AD5->AD5_RESULT + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#000099"><p>Grato(a).</p></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '	</body>'+CRLF
			_cMsg	+= '</html>'+CRLF
			
			_cPara		:= SA3->(GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3") + AD5->AD5_VEND,1))
			
			MailDSC(_cPara, _cAssunto, _cMsg, _cCopy)
			
		EndIf

	End Transaction 

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} MailDSC
Funcao para envio de email em caso de conta SMTP usar criptografia TLS

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/10/2014
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function MailDSC(cPara, cAssunto, cMsg, cCC)

	Local oMail 
	Local oMessage
	Local nErro
	Local lRet 			:= .T.
	Local cSMTPServer	:= Alltrim(GetMV("MV_WFSMTP"))
	Local cSMTPUser		:= Alltrim(GetMV("MV_WFAUTUS"))
	Local cSMTPPass		:= Alltrim(GetMV("MV_WFAUTSE"))
	Local cMailFrom		:= cSMTPUser
	Local nPort	   		:= 587
	Local lUseAuth		:= .T.
	
	conout('Conectando com SMTP ['+cSMTPServer+'] ')
	oMail := TMailManager():New()
//	oMail:SetUseTLS(.t.)
	conout('Inicializando SMTP')
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )
	oMail:SetSmtpTimeOut( 30 )
	conout('Conectando com servidor...')
	nErro := oMail:SmtpConnect()
	
	If lUseAuth
		nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
		If nErro <> 0
			cMAilError := oMail:GetErrorString(nErro)
			DEFAULT cMailError := '***UNKNOW***'
			conout("Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')')
			lRet := .F.
		EndIf
	EndIf
	
	If nErro <> 0
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		conout(cMAilError)
		
		conout("Erro de Conexão SMTP "+str(nErro,4))
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
		lRet := .F.
	EndIf 
	
	If lRet
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom		:= cMailFrom
		oMessage:cTo		:= cPara
		oMessage:cCC		:= cCC
		oMessage:cSubject	:= cAssunto
		oMessage:cBody		:= cMsg
		
		conout('Enviando Mensagem para ['+cPara+'] ')
		nErro := oMessage:Send( oMail )
		
		If nErro <> 0
			xError := oMail:GetErrorString(nErro)
			conout("Erro de Envio SMTP "+str(nErro,4)+" ("+xError+")")
			lRet := .F.
		Else
			conout("Mensagem enviada com sucesso!")
		EndIf
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
	EndIf
Return lRet