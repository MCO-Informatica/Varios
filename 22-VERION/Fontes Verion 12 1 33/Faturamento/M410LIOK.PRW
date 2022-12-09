#include "Protheus.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410LIOK  ºAutor  ³Fernando Macieira   º Data ³ 14/Mar/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para tratar a Condicao de Pagamento, no   º±±
±±º          ³ Pedido de Vendas, NEGOCIADA (TIPO 9).                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Verion                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410LIOK()
Local lRetorno, cCondPag, cTpCondPag, nParc1, dParc1
lRetorno   := .t.

// ROTINA DE GERACAO DE PEDIDO DE VENDAS NO CASO DE MEDICAO DE CONTRATOS..... 
If ALLTRIM(FUNNAME()) == "CNTA120"
     return lRetorno
endif

nParc1     := M->C5_PARC1
dParc1     := M->C5_DATA1
cCondPag   := M->C5_CONDPAG
cTpCondPag := Posicione("SE4",1,xFilial("SC5")+cCondPag,"E4_TIPO")

If cTpCondPag == "9"
	Iif(nParc1<=0,Processa({||msgStop("Condição de Pagamento Tipo 9. Informe o Valor na Parcela!","Atenção"),lRetorno:=.f.}),)
	Iif(Empty(dParc1),Processa({||msgStop("Condição de Pagamento Tipo 9. Informe a Data de Vencimento!"),lRetorno:=.f.}),)
EndIf

Return lRetorno
