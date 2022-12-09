#Include "RWMAKE.CH"
#Include "TOPCONN.CH"                                      
#Include "Protheus.Ch"
#include "TbiConn.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTK271LEG  บ Autor ณMateus Hengle       บ Data ณ 03/12/2013  บฑฑ
ฑฑฬออออออออออฯอออุออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao     ณ PE que altera o texto da legenda do Call Center		  บฑฑ
ฑฑฬออออออออออออออุออออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ Manutencao Efetuada                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAdalberto Netoณ11/03/14ณAlterei o nome da cor MARROM para VIOLETA      ณฑฑ
ฑฑศออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออผฑฑ                      	
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function TK271LEG()  

Local aArea := GetArea()
Local aVetor := {}

aAdd(aVetor, {"BR_VIOLETA" 	, "Atendimento"})
aAdd(aVetor, {"BR_AZUL"		, "Orcamento"})
aAdd(aVetor, {"BR_AMARELO" 	, "Pedido Liberado"})  // criado por Mateus Hengle dia 18/01/14
aAdd(aVetor, {"BR_VERDE" 	, "Pedido Bloqueado"})
aAdd(aVetor, {"BR_VERMELHO"	, "NF. Emitida"}) 
aAdd(aVetor, {"BR_PRETO" 	, "Cancelado"})
aAdd(aVetor, {"BR_PINK"		, "OP Gerada"})    
aAdd(aVetor, {"BR_LARANJA"	, "Bloqueado Credito"})   
 
RestArea(aArea) 

Return aVetor