#include "APWEBSRV.CH"
#include "PROTHEUS.CH"

WsService ChatProtheus  Description "SERVIÇO DE WEB CHAT PROTHEUS" NAMESPACE "http://tst:8019/ws/9901/tws4.apw"

   WsData codEncerramento As String
   WsData msgEncerramento As String
   WsData mensagem        As String
   WsData idConversa      As String
   WsData cparam          As String
   WsData cRet1           As String // usado para retorno
   WsData cRet2           As String // usado para retorno
   WsData cRet3           As String // usado para retorno
   WsMethod iniciaConversa     Description "Inicia CHAT"
   WsMethod enviaMensagem      Description "Envia Mensagem"
   WsMethod encerraConversa    Description "Encerra Conversa"

EndWsService

WsMethod iniciaConversa  WsReceive cparam WsSend cRet1 WsService ChatProtheus
	Local lRet 		:= .T.
	Local cMens		:= ""
	Local cCodret	:= ""

	IF(Empty(cparam))
   		lRet := .F.
   		SetSoapFault( "Parametros Invalidos", "Parametros Invalidos" )
	Else
		_noperwb:=""

		oChat := CtSdkChat():New(.F.)
		oChat:Init()

		lRet := oChat:SetFila(cparam)

		If lRet
			cMens	:=  "Chat Certisign"
			cCodret	:= "1"
		Else
			cMens	:= "2"
			cCodret	:= "0"
		EndIf

	   	::cRet1:='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+Chr(13)+Chr(10)
	   	::cRet1+='<wsReturnType xmlns:ns2="http://www.example.org/DisponibilidadeOperadorSchema">'+Chr(13)+Chr(10)
	   	::cRet1+='   <ns2:code>'+cCodret+'</ns2:code>'+Chr(13)+Chr(10)
	   	::cRet1+='   <ns2:message>'+cMens+'</ns2:message>'+Chr(13)+Chr(10)
	   	::cRet1+='   <ns2:exception></ns2:exception>'+Chr(13)+Chr(10)
	   	::cRet1+='</wsReturnType>'+Chr(13)+Chr(10)

	   	FreeObj(oChat)
	   	oChat := nil

	EndIf

	DelClassIntF()

Return(.T.)


WsMethod enviaMensagem  WsReceive idConversa,mensagem WsSend cRet2 WsService ChatProtheus
	Local lRet 		:= .T.
	Local cMens		:= ""
	Local cCodret	:= ""
	Local nTenta	:= 1

	IF(Empty(::idConversa)) .Or.  (Empty(::mensagem))
	    lRet := .F.
	    SetSoapFault( "Parametros Invalidos", "Parametros Invalidos!" )
	Else

	   	cMens	:=""
	   	cCodret	:=""

	   	oChat := CtSdkChat():New(.F.)
		oChat:Init()
	   	cCodret := oChat:SetConversa(::mensagem,"02",0,Alltrim(::idConversa))
	   	
   	    While !("1"$cCodret) .And. nTenta <= 3
	    	sleep(100)
	    	cCodret := oChat:SetConversa(::mensagem,"02",0,Alltrim(::idConversa))
	    	nTenta  += 1	
	    Enddo 

	   cMens  :=Iif(cCodret="1","Enviada com Sucesso",Iif(cCodret="0","Id do clinte não Encontrado",;
	   Iif(cCodret="-1","Problemas na Gravaçâo","Erro Desconhecido")))

	   ::cRet2:='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+Chr(13)+Chr(10)
	   ::cRet2+='<wsReturnType xmlns:ns2="http://www.example.org/DisponibilidadeOperadorSchema">'+Chr(13)+Chr(10)
	   ::cRet2+='   <ns2:code>'+cCodret+'</ns2:code>'+Chr(13)+Chr(10)
	   ::cRet2+='   <ns2:message>'+cMens+'</ns2:message>'+Chr(13)+Chr(10)
	   ::cRet2+='   <ns2:exception></ns2:exception>'+Chr(13)+Chr(10)
	   ::cRet2+='</wsReturnType>'+Chr(13)+Chr(10)

	   FreeObj(oChat)
	   oChat := nil

	EndIf

	DelClassIntF()

Return(lRet)


WsMethod encerraConversa  WsReceive idConversa,codEncerramento,msgEncerramento WsSend cRet3 WsService ChatProtheus
	Local lRet 		:= .t.
	Local cMens		:= ""
	Local cCodret	:= ""

	IF(Empty(::idConversa)) .Or. (Empty(::codEncerramento)) .Or. (Empty(::msgEncerramento))
	    lRet := .F.
	    SetSoapFault( "Parametros Invalidos", "Parametros Invalidos!" )
	Else
	    cMens	:= CRLF+ "[PROTHEUS]" + "[" + Time() + "]"+CRLF +" ****ENCERRAMENTO****"+CRLF+"CONTATO ENCERROU A CONVERSA ATRAVÉS DO PORTAL "+CRLF
	    cCodret:= ""
	    oChat := CtSdkChat():New(.F.)
		oChat:Init()
	    cCodret:=oChat:SetConversa(cMens,"02",0,Alltrim(::idConversa))

	   ::cRet3:='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+Chr(13)+Chr(10)
	   ::cRet3+='<wsReturnType xmlns:ns2="http://www.example.org/DisponibilidadeOperadorSchema">'+Chr(13)+Chr(10)
	   ::cRet3+='   <ns2:code>'+cCodret+'</ns2:code>'+Chr(13)+Chr(10)
	   ::cRet3+='   <ns2:message></ns2:message>'+Chr(13)+Chr(10)
	   ::cRet3+='   <ns2:exception></ns2:exception>'+Chr(13)+Chr(10)
	   ::cRet3+='</wsReturnType>'+Chr(13)+Chr(10)

	   FreeObj(oChat)
	   oChat := nil
	EndIF

	DelClassIntF()
Return lRet