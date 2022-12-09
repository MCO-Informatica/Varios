#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Controle do Usuario                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE HAProvider DESCRIPTION "WebService para controle de compras via Portal" NAMESPACE "http://localhost:8080/HAProvider.apw" 

	WSDATA cxmlret	                As String
	WSDATA senha 					As String

	WSMETHOD validaCont		DESCRIPTION "validaContato"

ENDWSSERVICE

WSMETHOD validaCont WSRECEIVE email WSSEND cxmlret WSSERVICE HAProvider
	Local lReturn	:= .T.
	Local cCode		:= '1'
	
	DbSelectArea('SU5')
	DbSetOrder(9)
	If DbSeek(xFilial('SU5') + email)
		If senha <> SU5->U5_XSENHA
			cCode := '0'
		EndIf
	Else
		cCode := '0'
	EndIf
	
	If cCode == '0'
		::cxmlret := XML_VERSION + CRLF
		::cxmlret += '<contatoFullType>' + CRLF
	    ::cxmlret += '		<code>' + cCode + '</code>' + CRLF //1=sucesso na operação; 0=erro
	    ::cxmlret += '		<msg></msg>' + CRLF
	    ::cxmlret += '		<exception>Contato ou senha inválidos</exception>' + CRLF
	    ::cxmlret += '		<id></id>' + CRLF
	    ::cxmlret += '		<nome></nome>' + CRLF
	    ::cxmlret += '		<cpf></cpf>' + CRLF
	    ::cxmlret += '		<email></email>' + CRLF
	    ::cxmlret += '		<senha></senha>' + CRLF
		::cxmlret += '</contatoFullType>' + CRLF
	Else
		::cxmlret := XML_VERSION + CRLF
		::cxmlret += '<contatoFullType>' + CRLF
	    ::cxmlret += '		<code>' + cCode + '</code>' + CRLF //1=sucesso na operação; 0=erro
	    ::cxmlret += '		</msg>' + CRLF
	    ::cxmlret += '		</exception>' + CRLF
	    ::cxmlret += '		<id>' + SU5->U5_CODCONT + '</id>' + CRLF
	    ::cxmlret += '		<nome>' + AllTrim(SU5->U5_CONTAT) + '</nome>' + CRLF
	    ::cxmlret += '		<cpf>' + AllTrim(SU5->U5_CPF) + '</cpf>' + CRLF
	    ::cxmlret += '		<email>' + AllTrim(SU5->U5_EMAIL) + '</email>' + CRLF
	    ::cxmlret += '		<senha>' + SU5->U5_XSENHA + '</senha>' + CRLF
		::cxmlret += '</contatoFullType>' + CRLF
	EndIf

Return(lReturn)