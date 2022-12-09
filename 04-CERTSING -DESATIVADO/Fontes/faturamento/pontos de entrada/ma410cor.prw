#include "PROTHEUS.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410COR  บAutor  ณMicrosiga           บ Data ณ  11/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User function MA410COR()

aCores := {	{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)","BR_VERDE","Pedido em Aberto" },;     	//Pedido em Aberto
           	{"!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,"BR_VERMELHO","Pedido Encerrado"},;     	//Pedido Encerrado
			{"!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)","BR_AMARELO","Pedido de Venda Liberado"},; 	// Pedido de Venda Liberado
           	{"C5_BLQ == '1'",'BR_AZUL',"Pedido Bloquedo por regra"},;  												//Pedido Bloquedo por regra
           	{"C5_BLQ == '2'",'BR_LARANJA',"Pedido Bloqueado por verba"},;
           	{"Empty(C5_NOTA) .and. !Empty(C5_XNPSITE) .AND. (!Empty(C5_XNFHRD) .OR. !Empty(C5_XNFSFW) .OR. !Empty(C5_XNFHRE))","BR_BRANCO","Pedido Parcialmente Faturado"}}           										//Pedido Parcialmente Faturado
                       
Return(aCores)                  
