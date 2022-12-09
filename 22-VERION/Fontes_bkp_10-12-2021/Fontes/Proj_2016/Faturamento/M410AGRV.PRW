#include "AP5MAIL.ch"
#include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410AGRV  ºAutor  ³Fernando Macieira   º Data ³ 14/Mar/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para validar Pedidos de Vendas, quando     º±±
±±º          ³situacao de clientes = E                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Verion                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410AGRV()

Local cMailDestino,cAssunto,cTexto,cAnexos,cRisco

// TRATAMENTO PARA A EMPRESA AEM.... NAO DEVE FAZER
If SM0->M0_CODIGO == "02"
	IF ALTERA                                                               
	   _cverlib  := M->C5_VRLIB
	   _COMVER3  := "MSG /SERVER:AEM-000005 ANDERSON.SANCHES /TIME:7200 O PEDIDO NR "+M->C5_NUM+" FOI ALTERADO, FAVOR VERIFICAR !!! PEDIDO ALTERADO POR "+alltrim(SUBSTR(CUSUARIO,7,15))+"..."

	   IF _CVERLIB $ "F"
	      Winexec(_COMVER3)                  
	   ENDIF
	ENDIF
endif

If SM0->M0_CODIGO <> "02"

	// ROTINA DE GERACAO DE PEDIDO DE VENDAS NO CASO DE IMPORTACAO..... 
	If ALLTRIM(FUNNAME()) == "VRFATA01"
    	 return()
	endif

	// ROTINA DE GERACAO DE PEDIDO DE VENDAS NO CASO DE MEDICAO DE CONTRATOS..... 
	If ALLTRIM(FUNNAME()) == "CNTA120"
	    return()
	endif
Endif

If !M->C5_TIPO $ "DB"
	cMailDestino := GetMv("MV_XVMAIL")
	cMailDestino += ""
	cTexto       := "Cliente: " +AllTrim(M->C5_CLIENTE)+"/"+AllTrim(M->C5_LOJACLI) + Chr(13)+Chr(10)
	cTexto       += "Razão Social: " +AllTrim(Posicione("SA1",1,xFilial("SA1")+M->(C5_CLIENTE+C5_LOJACLI),"A1_NOME")) + Chr(13)+Chr(10)
	cTexto       += "Pedido de Venda: " +M->C5_NUM + Chr(13)+Chr(10)
	cTexto       += "Login: " +AllTrim(cUserName)
	cAnexos      := ""
	cRisco       := ""
	
	cRisco := Posicione("SA1",1,xFilial("SA1")+M->(C5_CLIENTE+C5_LOJACLI),"A1_RISCO")      
	
	If cRisco == "E"
		cAssunto     := "Pedido de Vendas com Cliente Risco E"
		msgStop("Cliente está com Risco Financeiro","Atenção")
		u_vEnvMail(cMailDestino,cAssunto,cTexto,cAnexos,.t.)
	EndIf

    IF (ddatabase - SA1->A1_ULTCOM) > 180
    	cAssunto     := "Pedido de Vendas com Cliente inativo a mais de 6 meses"
		msgStop("Cliente está inativo a mais de 6 meses")
		u_vEnvMail(cMailDestino,cAssunto,cTexto,cAnexos,.t.)
	Endif

    If SC5->C5_DTTXREF <> ddatabase .AND. SM0->M0_CODIGO == "01"
	    msgStop("FAVOR ATUALIZAR O VALOR POIS ESTA CALCULADO COM O DOLAR DE " + dTOC(SC5->C5_DTTXREF))       
    	cAssunto     := "FAVOR ATUALIZAR O VALOR POIS ESTA CALCULADO COM O DOLAR DE " + dTOC(SC5->C5_DTTXREF)
		u_vEnvMail(cMailDestino,cAssunto,cTexto,cAnexos,.t.)
    Endif

EndIf                         

// Tratamento para os pedidos que estao em faturamento e sofreram alteracoes... 
IF ALTERA                                                               
   _cverlib  := M->C5_VRLIB
   _COMVER   := "MSG /SERVER:VERION-000070 WILLIAN.ALMEIDA /TIME:7200 O PEDIDO NR "+M->C5_NUM+" FOI ALTERADO, FAVOR VERIFICAR !!! PEDIDO ALTERADO POR "+alltrim(SUBSTR(CUSUARIO,7,15))+"..."
   _COMVER1  := "MSG /SERVER:VERION-000078 ITAMAR.GARDIEL /TIME:7200 O PEDIDO NR "+M->C5_NUM+" FOI ALTERADO, FAVOR VERIFICAR !!! PEDIDO ALTERADO POR "+alltrim(SUBSTR(CUSUARIO,7,15))+"..."
   _tmp      := 1

   IF _CVERLIB $ "F"
        Winexec(_COMVER)                  
        Winexec(_COMVER1)       
   ENDIF
ENDIF
Return