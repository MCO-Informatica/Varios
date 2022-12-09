
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTK271LEG  บAutor  ณNelson Junior       บ Data ณ  15/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPE para altera็ใo das legendas do MBROWSE na tela de Call   บฑฑ
ฑฑบ          ณCenter.                                                     บฑฑ   
ฑฑบ Alterado Por:| Danilo Alves Del Busso 				|Data: 31/07/2015 บฑฑ 	  
ฑฑบ Descria็ใo:	 | Ajustada a variแvel aCores para exibir as cores para	  บฑฑ 
ฑฑบ as legendas de libera็ใo por REGRA ou VERBA							  บฑฑ 
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Tk271Leg(cPasta)

Local aArea  := GetArea()
Local aCores := {}

If cPasta == "2" //Televendas
	//
	aCores := {	{"BR_MARRON"  	,"Atendimento" 			},;
				{"BR_AZUL"		,"Or็amento" 			},;    
				{"BR_PINK"		,"Bloqueado para libera็ใo - REGRA"	}	,;
				{"BR_LARANJA"	,"Bloqueado para libera็ใo - FINANCEIRO"	},;
				{"BR_AMARELO"	,"Bloqueado para libera็ใo - ESTOQUE"	}	,;
				{"BR_VERDE"    	,"Faturamento" 			},;
				{"BR_VERMELHO" 	,"NF. Emitida" 			},;
				{"BR_PRETO"    	,"Cancelado" 			} }
	//
EndIf

RestArea(aArea)

Return(aCores)