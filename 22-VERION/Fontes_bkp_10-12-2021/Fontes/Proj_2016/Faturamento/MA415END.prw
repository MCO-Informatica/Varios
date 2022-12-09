#include "AP5MAIL.ch"
#include "Protheus.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA415END  ºAutor  ³Fernando Macieira   º Data ³ 14/Mar/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para validar Orcamentos, quando situacao   º±±
±±º          ³de clientes = E                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Verion                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA415END()

Local cMailDestino,cAssunto,cTexto,cAnexos,cRisco

cMailDestino := GetMv("MV_XVMAIL")
cAssunto     := "Orçamento com Cliente Risco E"
cTexto       := "Cliente: " +AllTrim(M->CJ_CLIENTE)+"/"+AllTrim(M->CJ_LOJA) + Chr(13)+Chr(10)
cTexto       += "Razão Social: " +AllTrim(Posicione("SA1",1,xFilial("SA1")+M->(CJ_CLIENTE+CJ_LOJA),"A1_NOME")) + Chr(13)+Chr(10)
cTexto       += "Orçamento: " +M->CJ_NUM + Chr(13)+Chr(10)
cTexto       += "Login: " +AllTrim(cUserName)
cAnexos      := ""
cRisco       := ""

cRisco       := Posicione("SA1",1,xFilial("SA1")+M->(CJ_CLIENTE+CJ_LOJA),"A1_RISCO")

If cRisco=="E"
	msgStop("Cliente está com Risco Financeiro","Atenção")
	u_vEnvMail(cMailDestino,cAssunto,cTexto,cAnexos,.t.)
EndIf

Return