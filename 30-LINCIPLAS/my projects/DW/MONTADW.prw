#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "ap5mail.ch"
#DEFINE CRLF Chr(13)+Chr(10)

// *--------------------------------------------------*
User Function DWCORP()
// *--------------------------------------------------*

//RpcsetEnv("01","01","Administrador","121912","u_TELACLI","LANPRO",{"SM0","SB1","SM2","SM4","SED","SED","CTT"})

conout("PROCESSO DW - " + DTOC(DDATABASE) + "-" + TIME() + "INICIO CALCULO DBF")
Private cPerg 		:= "DWCORP"

// Cria Array Princial com todas as movimentacoes do periodo 
Public aMovtoPV		:= {}
Public aMovtoNF 	:= {}
Public dtini		:= 0
Public dtfim		:= 0
// Cria variaveis temporarias
Public nDBrinde 	:= 0
Public nNFDBrinde	:= 0
Public nDQtdPV 		:= 0
Public nDPagoPV 	:= 0
Public nDQtdAssPV 	:= 0
Public nDPgAssPV 	:= 0
Public nDQtdNF 		:= 0
Public nDPagoNF 	:= 0
Public nDQtdAssNF 	:= 0
Public nDPgAssNF 	:= 0
Public nOPGPV		:= 0
Public nOQtdPV		:= 0
Public nOAPGPV		:= 0
Public nOAqtdPV		:= 0
Public nOPGNF		:= 0
Public nOqtdNF		:= 0
Public nOAPGNF		:= 0
Public nOAqtdNF		:= 0
Public nTVlrAPV		:= 0
Public nTQtdAPV		:= 0
Public nTVlrPV		:= 0 // 06 - POSICAO DAS COLUNAS NO HTML
Public nTQtdPV		:= 0 // 07 - POSICAO DAS COLUNAS NO HTML
Public nTVlrPVO		:= 0 // 12 - POSICAO DAS COLUNAS NO HTML
Public nTQtdPVO		:= 0 // 13 - POSICAO DAS COLUNAS NO HTML
Public nTVlrNF		:= 0 // 19 - POSICAO DAS COLUNAS NO HTML
Public nTQtdNF		:= 0 // 20 - POSICAO DAS COLUNAS NO HTML
Public nTVlrNFO		:= 0 // 25 - POSICAO DAS COLUNAS NO HTML
Public nTQtdNFO		:= 0 // 26 - POSICAO DAS COLUNAS NO HTML

lPerg 				:= pergunte(cPerg, .T.)

IF lPerg

	Processa( {|| U_PVVEN(MV_PAR01 ,MV_PAR02) }, "Aguarde...", "Processando Pedidos de Venda . . . "				,.F. )
	Processa( {|| U_PVFAT(MV_PAR01 ,MV_PAR02) }, "Aguarde...", "Processando Notas Fiscais . . . "					,.F. )
	Processa( {|| U_OPVFAT(MV_PAR01,MV_PAR02) }, "Aguarde...", "Processando Pedidos de Venda - Tipo B . . . "		,.F. )
	Processa( {|| U_ONFFAT(MV_PAR01,MV_PAR02) }, "Aguarde...", "Processando Notas Fiscais - Tipo B. . . "			,.F. )
	
	conout("PROCESSO DW - " + DTOC(DDATABASE) + "-" + TIME() + "FIM CALCULO DE DADOS")
	conout("PROCESSO DW - " + DTOC(DDATABASE) + "-" + TIME() + "INICIO MONTAGEM VIEWS")
	// Montagem dos Views Html (Drill-Down)
	
	// ============================================= DW Corporativo - Sintetico
	//aLinhas 	:= {}
	aColunas 	:= {}
	aIndic 		:= {}
	aLinhas		:= {}
	
	for f:=1 to 12
		aadd(aLinhas,{ mesextenso(f), str(f) } )
	next f
	aadd(aLinhas ,{ "Total", "13" } )
	
	aadd(aColunas,{ "Brindes"    				, "brinde"   } )	//01	PV
	aadd(aColunas,{ "Capacetes Vendidos"    	, "capven"   } )	//02	PV
	aadd(aColunas,{ "QTD Vendidos"    			, "capven"   } )	//03	PV
	aadd(aColunas,{ "Acessorios Vendidos"   	, "aceven"   } )	//04	PV
	aadd(aColunas,{ "QTD Vendidos"   			, "aceven"   } )	//05	PV
	aadd(aColunas,{ "T VLR CapAcc PV"  			, "capvenT"  } )	//06	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc PV"  			, "capvenT"  } )	//07	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc PV"  			, "capvenT"  } )	//08	TOTAL GERAL
	
	aadd(aColunas,{ "Capacetes Vendidos O"  	, "capven2"  } )	//09	OUTROS
	aadd(aColunas,{ "QTD Vendidos O"  			, "capven2"  } )	//10	OUTROS
	aadd(aColunas,{ "Acessorios Vendidos O"  	, "capven2"  } )	//11	OUTROS
	aadd(aColunas,{ "QTD Vendidos O"		  	, "capven2"  } )	//12	OUTROS
	aadd(aColunas,{ "T VLR CapAcc PV O"  		, "capvenT"  } )	//13	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc PV O" 		, "capvenT"  } )	//14	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc PV O" 		, "capvenT"  } )	//15	TOTAL GERAL
	
	aadd(aColunas,{ "Brindes Faturados"			, "NFbrinde" } )	//16	NF
	aadd(aColunas,{ "Capacetes Faturados"   	, "capfat"   } )	//17	NF
	aadd(aColunas,{ "QTD Faturados"   			, "capfat"   } )	//18	NF
	aadd(aColunas,{ "Acessorios Faturados"  	, "acefat"   } )	//19	NF
	aadd(aColunas,{ "QTD Faturados"  			, "acefat"   } )	//20	NF
	aadd(aColunas,{ "T VLR CapAcc NF"  			, "capfatT"  } )	//21	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc NF"			, "capfatT"  } )	//22	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc PV O" 		, "capvenT"  } )	//23	TOTAL GERAL
	
	aadd(aColunas,{ "Capacetes Faturados O"  	, "capfat2"  } )	//24	OUTROS
	aadd(aColunas,{ "QTD Faturados O" 			, "capfat2"  } )	//25	OUTROS
	aadd(aColunas,{ "Acessorios Vendidos O"  	, "capfat2"  } )	//26	OUTROS
	aadd(aColunas,{ "QTD Faturados O"			, "capfat2"  } )	//27	OUTROS
	aadd(aColunas,{ "T VLR CapAcc NF O"  		, "capfatT"  } )	//28	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc NF O"			, "capfatT"  } )	//29	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc NF O"			, "capfatT"  } )	//30	TOTAL GERAL
	
	For x:=1 to len(aLinhas)
		For y:=1 to len(aColunas)
			IF X < 13
				IF Y == 1 		// 1 BRINDE PV
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_Brinde	(y,val(aLinhas[x][2])) 		, aColunas[y][1] })
					nDBrinde	+= u_Brinde(y,val(aLinhas[x][2]))
				ELSEIF Y == 2 	// 2 CAPACETES VENDIDOS PV
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_PagoPV	(y,val(aLinhas[x][2])) 		, aColunas[y][1] })
					nDPagoPV	+= u_PagoPV(y,val(aLinhas[x][2]))
					NTVLRPV		:= NTVLRPV + u_PagoPV(y,val(aLinhas[x][2]))
				ELSEIF Y == 3 	// 3 CAPACETES QTD PV
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_QtdPV	(y,val(aLinhas[x][2])) 		, aColunas[y][1] })
					nDQtdPV 	+= u_QtdPV(y,val(aLinhas[x][2]))
					nTQtdPV 	:= nTQtdPV + u_QtdPV(y,val(aLinhas[x][2]))
				ELSEIF Y == 4 	// 4 ACESSORIOS VENDIDOS PV
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_PagoAssPV(y,val(aLinhas[x][2]))		, aColunas[y][1] })
					nDPgAssPV 	+= u_PagoAssPV(y,val(aLinhas[x][2]))
					nTVlrAPV 	:= nTVlrAPV + u_PagoAssPV(y,val(aLinhas[x][2]))
				ELSEIF Y == 5 	// 5 ACESSORIOS QTD PV
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_QtdAssPV(y,val(aLinhas[x][2])) 		, aColunas[y][1] })
					nDQtdAssPV	+= u_QtdAssPV(y,val(aLinhas[x][2]))
					nTQtdAPV 	:= nTQtdAPV + u_QtdAssPV(y,val(aLinhas[x][2]))
					// PEDIDOS DE VENDA - OUTROS		//
				ELSEIF Y == 06 	// 11 OUTROS
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_OPGPV(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nOPGPV 		+= u_OPGPV(y,val(aLinhas[x][2]))
					NTVLRPV		:= NTVLRPV + u_OPGPV(y,val(aLinhas[x][2]))
				ELSEIF Y == 07 	// 12 OUTROS
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_OQtdPV(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nOQTDPV 	+= u_OQtdPV(y,val(aLinhas[x][2]))
					nTQtdPV 	:= nTQtdPV + u_OQtdPV(y,val(aLinhas[x][2]))
				ELSEIF Y == 08 	// 13 OUTROS
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_OAPGPV(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nOAPGPV 	+= u_OAPGPV(y,val(aLinhas[x][2]))
					nTVlrAPV 	:= nTVlrAPV + u_OAPGPV(y,val(aLinhas[x][2]))
				ELSEIF Y == 09 	// 14 OUTROS
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_OAQtdPV(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nTQtdAPV 	+= u_OAQtdPV(y,val(aLinhas[x][2]))
					nTQtdAPV 	:= nTQtdAPV + u_OAQtdPV(y,val(aLinhas[x][2]))
					
				ELSEIF Y == 10
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVLRPV									, aColunas[y][1] })
				ELSEIF Y == 11
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQTDPV									, aColunas[y][1] })
				ELSEIF Y == 12
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVlrAPV									, aColunas[y][1] })
				ELSEIF Y == 13
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQtdAPV									, aColunas[y][1] })
					// TOTAL GERAL
				ELSEIF Y == 14
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVLRPV+nTVlrAPV							, aColunas[y][1] })
				ELSEIF Y == 15
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQTDPV+nTQtdAPV							, aColunas[y][1] })
					//////////////////
				ELSEIF Y == 16 	// 6 BRINDE NF
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_NFBrinde(y,val(aLinhas[x][2])) 		, aColunas[y][1] })
					nNFDBrinde 	+= u_NFBrinde(y,val(aLinhas[x][2]))
				ELSEIF Y == 17 	// 7 CAPACETES NOTA FISCAL
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_PagoNF(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nDPagoNF	+= u_PagoNF(y,val(aLinhas[x][2]))
				ELSEIF Y == 18 	// 8 CAPACETES QTD NF
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_QtdNF(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nDQtdNF 	+= u_QtdNF(y,val(aLinhas[x][2]))
				ELSEIF Y == 19 	// 9 ACESSORIOS NOTA FISCAL
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_pagoAssNF(y,val(aLinhas[x][2]))		, aColunas[y][1] })
					nDPgAssNF 	+= u_PagoAssNF(y,val(aLinhas[x][2]))
				ELSEIF Y == 20 	// 10 ACESSORIOS QTD NF
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_QtdAssNF(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nDQtdAssNF 	+= u_QtdAssNF(y,val(aLinhas[x][2]))
					//////////////////
					// FATURADOS - NF				//
				ELSEIF Y == 21 	// 15 OUTROS
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_OPGNF(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nOPGNF 		+= u_OPGNF(y,val(aLinhas[x][2]))
				ELSEIF Y == 22 	// 16 OUTROS
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_OQtdNF(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nOQTDNF 	+= u_OQtdNF(y,val(aLinhas[x][2]))
				ELSEIF Y == 23 	// 17 OUTROS
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_OAPGNF(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nOAPGNF 	+= u_OAPGNF(y,val(aLinhas[x][2]))
				ELSEIF Y == 24 	// 18 OUTROS
					aadd(aIndic, {alltrim(aLinhas[x][1])	, u_OAQtdNF(y,val(aLinhas[x][2]))			, aColunas[y][1] })
					nOAQTDNF 	+= u_OAQtdNF(y,val(aLinhas[x][2]))
					
				ELSEIF Y == 25
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVLRNF									, aColunas[y][1] })
				ELSEIF Y == 26
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQTDNF									, aColunas[y][1] })
				ELSEIF Y == 27
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVLRNFO									, aColunas[y][1] })
				ELSEIF Y == 28
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQTDNFO									, aColunas[y][1] })
				ELSEIF Y == 29
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVLRNF+nTVLRNFO							, aColunas[y][1] })
				ELSEIF Y == 30
					aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQTDNF+nTQTDNFO							, aColunas[y][1] })
					//ELSEIF Y > 18 // OUTROS
					//	aadd(aIndic, {alltrim(aLinhas[x][1])	,  										, aColunas[y][1] })
				ENDIF
			ELSEIF X == 13
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDBrinde										, aColunas[01][1] }) // Brindes 			- PV
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDPagoPV										, aColunas[02][1] }) // Valor 				- PV
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDQtdPV										, aColunas[03][1] }) // Qtd 				- PV
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDPgAssPV									, aColunas[04][1] }) // Valor Acessorio 	- PV
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDQtdAssPV									, aColunas[05][1] }) // Qtd Acessorio 		- PV
				
				aadd(aIndic, {alltrim(aLinhas[x][1]), nOPGPV										, aColunas[06][1] }) // Valor PV 			- PV Tipo B
				aadd(aIndic, {alltrim(aLinhas[x][1]), nOQTDPV										, aColunas[07][1] }) // Qtd PV 				- PV Tipo B
				aadd(aIndic, {alltrim(aLinhas[x][1]), nOAPGPV										, aColunas[08][1] }) // Valor Acessorio 	- PV Tipo B
				aadd(aIndic, {alltrim(aLinhas[x][1]), nOAqtdPV										, aColunas[09][1] }) // Qtd Acessorio 		- PV Tipo B
				
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDPagoPV+nOPGPV								, aColunas[10][1] }) // Valor PV 			- PV VLR TOTAL
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDQtdPV+nOQTDPV								, aColunas[11][1] }) // Qtd PV 				- PV QTD TOTAL
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDPgAssPV+nOAPGPV  					 		, aColunas[12][1] }) // Valor PV 			- PV Tipo B VLR TOTAL
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDQtdAssPV+nOAqtdPV							, aColunas[13][1] }) // Qtd PV 				- PV Tipo B QTD TOTAL
				
				aadd(aIndic, {alltrim(aLinhas[x][1]), (nDPagoPV+nDPgAssPV)+(nOPGPV+nOAPGPV)  		, aColunas[14][1] }) // Valor PV 			- PV VLR TOTAL GERAL
				aadd(aIndic, {alltrim(aLinhas[x][1]), (nDQtdPV+nDQtdAssPV)+(nOQTDPV+nOAqtdPV)		, aColunas[15][1] }) // Qtd PV 				- PV QTD TOTAL GERAL
				
				aadd(aIndic, {alltrim(aLinhas[x][1]), nNFDBrinde									, aColunas[16][1] }) // Brindes 			- NF
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDPagoNF										, aColunas[17][1] }) // Valor Cap 			- NF
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDQtdNF										, aColunas[18][1] }) // Qtd Cap 			- NF
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDPgAssNF									, aColunas[19][1] }) // Valor Acessorio 	- NF
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDQtdAssNF									, aColunas[20][1] }) // Qtd Acessorio 		- NF
				
				aadd(aIndic, {alltrim(aLinhas[x][1]), nOPGNF										, aColunas[21][1] }) // Valor Cap 			- NF TIPO B
				aadd(aIndic, {alltrim(aLinhas[x][1]), nOqtdNF										, aColunas[22][1] }) // Qtd Cap 			- NF TIPO B
				aadd(aIndic, {alltrim(aLinhas[x][1]), nOAPGNF										, aColunas[23][1] }) // Valor Acessorio 	- NF TIPO B
				aadd(aIndic, {alltrim(aLinhas[x][1]), nOAqtdNF										, aColunas[24][1] }) // Qtd Acessorio 		- NF TIPO B
				
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDPagoNF+nOPGNF						   		, aColunas[25][1] }) // Valor PV 			- NV VLR TOTAL
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDQtdNF+nOqtdNF						   		, aColunas[26][1] }) // Qtd PV 				- NF QTD TOTAL
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDPgAssNF+nOAPGNF  							, aColunas[27][1] }) // Valor PV 			- PV Tipo B VLR TOTAL
				aadd(aIndic, {alltrim(aLinhas[x][1]), nDQtdAssNF+nOAqtdNF							, aColunas[28][1] }) // Qtd PV 				- PV Tipo B QTD TOTAL
				
				aadd(aIndic, {alltrim(aLinhas[x][1]), (nDPagoNF+nDPgAssNF)+(nOPGNF+nOAPGNF)  		, aColunas[29][1] }) // Valor PV 			- PV VLR TOTAL GERAL
				aadd(aIndic, {alltrim(aLinhas[x][1]), (nDQtdNF+nDQtdAssNF)+(nOqtdNF+nOAqtdNF)		, aColunas[30][1] }) // Qtd PV 				- PV QTD TOTAL GERAL
			ENDIF
		Next y
		
		nTVlrPV		:= 0 // 06 - POSICAO DAS COLUNAS NO HTML
		nTQtdPV		:= 0 // 07 - POSICAO DAS COLUNAS NO HTML
		nTVlrPVO	:= 0 // 12 - POSICAO DAS COLUNAS NO HTML
		nTQtdPVO	:= 0 // 13 - POSICAO DAS COLUNAS NO HTML
		nTVlrNF		:= 0 // 19 - POSICAO DAS COLUNAS NO HTML
		nTQtdNF		:= 0 // 20 - POSICAO DAS COLUNAS NO HTML
		nTVlrNFO	:= 0 // 25 - POSICAO DAS COLUNAS NO HTML
		nTQtdNFO	:= 0 // 26 - POSICAO DAS COLUNAS NO HTML
		nTVlrAPV	:= 0
		nTQtdAPV	:= 0
		nTVlrANF	:= 0
		nTQtdANF	:= 0
		
	Next x
	// Gera Dimensão (Point Of View) Html
	U_MDW(aLinhas,aColunas,aIndic,"Gerencial","Gerencial Anual Spider - Sintético",0)
	
	
	
	// ============================================= DW Corporativo - Analitico (MESES)
	
	aLinhas 	:= {}
	aColunas 	:= {}
	aIndic 		:= {}
	
	
	for f:=1 to 31
		aadd(aLinhas,{ str(f), f } )
	next f
	aadd(aLinhas,{ "Total", 32 } )
	
	aSort(aLinhas,,,{|x,y| x[2] < y[2]})
	
	aadd(aColunas,{ "Brindes"    				, "brinde"   } )	//01	PV
	aadd(aColunas,{ "Capacetes Vendidos"    	, "capven"   } )	//02	PV
	aadd(aColunas,{ "QTD Vendidos"    			, "capven"   } )	//03	PV
	aadd(aColunas,{ "Acessorios Vendidos"   	, "aceven"   } )	//04	PV
	aadd(aColunas,{ "QTD Vendidos"   			, "aceven"   } )	//05	PV
	
	aadd(aColunas,{ "Capacetes Vendidos O"  	, "capven2"  } )	//06	OUTROS
	aadd(aColunas,{ "QTD Vendidos O"  			, "capven2"  } )	//07	OUTROS
	aadd(aColunas,{ "Acessorios Vendidos O"  	, "capven2"  } )	//08	OUTROS
	aadd(aColunas,{ "QTD Vendidos O"		  	, "capven2"  } )	//09	OUTROS
	
	aadd(aColunas,{ "T VLR CapAcc PV"  			, "capvenT"  } )	//10	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc PV"  			, "capvenT"  } )	//11	TOTAIS
	aadd(aColunas,{ "T VLR CapAcc PV O"  		, "capvenT"  } )	//12	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc PV O" 		, "capvenT"  } )	//13	TOTAIS
	aadd(aColunas,{ "T VLR CapAcc PV O"  		, "capvenT"  } )	//14	TOTAL GERAL
	aadd(aColunas,{ "T QTD CapAcc PV O" 		, "capvenT"  } )	//15	TOTAL GERAL
	
	aadd(aColunas,{ "Brindes Faturados"			, "NFbrinde" } )	//16	NF
	aadd(aColunas,{ "Capacetes Faturados"   	, "capfat"   } )	//17	NF
	aadd(aColunas,{ "QTD Faturados"   			, "capfat"   } )	//18	NF
	aadd(aColunas,{ "Acessorios Faturados"  	, "acefat"   } )	//19	NF
	aadd(aColunas,{ "QTD Faturados"  			, "acefat"   } )	//20	NF
	
	aadd(aColunas,{ "Capacetes Faturados O"  	, "capfat2"  } )	//21	OUTROS
	aadd(aColunas,{ "QTD Faturados O" 			, "capfat2"  } )	//22	OUTROS
	aadd(aColunas,{ "Acessorios Vendidos O"  	, "capfat2"  } )	//23	OUTROS
	aadd(aColunas,{ "QTD Faturados O"			, "capfat2"  } )	//24	OUTROS
	
	aadd(aColunas,{ "T VLR CapAcc NF"  			, "capfatT"  } )	//25	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc NF"			, "capfatT"  } )	//26	TOTAIS
	aadd(aColunas,{ "T VLR CapAcc NF O"  		, "capfatT"  } )	//27	TOTAIS
	aadd(aColunas,{ "T QTD CapAcc NF O"			, "capfatT"  } )	//28	TOTAIS
	aadd(aColunas,{ "T VLR CapAcc NF O"  		, "capfatT"  } )	//29	TOTAL GERAL
	aadd(aColunas,{ "T QTD CapAcc NF O"			, "capfatT"  } )	//30	TOTAL GERAL
	
	nDBrinde	:= 0
	nNFDBrinde	:= 0
	nDQtdPV 	:= 0
	nDPagoPV 	:= 0
	nDQtdAssPV 	:= 0
	nDPgAssPV 	:= 0
	nDQtdNF 	:= 0
	nDPagoNF 	:= 0
	nDQtdAssNF 	:= 0
	nDPgAssNF 	:= 0
	nDOqtdPV	:= 0
	nDOPGPV		:= 0
	nDOAPGPV	:= 0
	nDOAqtdPV	:= 0
	nDOPGNF		:= 0
	nDOqtdNF	:= 0
	nDOAPGNF	:= 0
	nDOAqtdNF	:= 0
	nTVlrAPV	:= 0
	nTQtdAPV	:= 0
	nTVlrANF	:= 0
	nTQtdANF	:= 0
	nTVlrPV		:= 0 // 06 - POSICAO DAS COLUNAS NO HTML
	nTQtdPV		:= 0 // 07 - POSICAO DAS COLUNAS NO HTML
	nTVlrPVO	:= 0 // 12 - POSICAO DAS COLUNAS NO HTML
	nTQtdPVO	:= 0 // 13 - POSICAO DAS COLUNAS NO HTML
	nTVlrNF		:= 0 // 19 - POSICAO DAS COLUNAS NO HTML
	nTQtdNF		:= 0 // 20 - POSICAO DAS COLUNAS NO HTML
	nTVlrNFO	:= 0 // 25 - POSICAO DAS COLUNAS NO HTML
	nTQtdNFO	:= 0 // 26 - POSICAO DAS COLUNAS NO HTML
	// MONTA DADOS DIARIOS
	For m:=1 To 12
		For x:=1 to len(aLinhas)
			For y:=1 to len(aColunas)
				IF X < 32
					IF Y == 1 		// BRINDE PV
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_DBrinde		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDBrinde 	+= u_DBrinde(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 2	// VALOR CAPACETES PEDIDO DE VENDA
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_DPagoPV		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDPagoPV 	+= u_DPagoPV(y,val(aLinhas[x][1]),m)
						NTVLRPV 	:= NTVLRPV + u_DPagoPV(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 3 	// QUANTIDADE CAPACETES PEDIDO DE VENDA
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_DQtdPV		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDQtdPV 	+= u_DQtdPV(y,val(aLinhas[x][1]),m)
						NTQTDPV 	:= NTQTDPV + u_DQtdPV(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 4 	// VALOR ACESSORIOS PEDIDO DE VENDA
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_DPgAssPV		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDPgAssPV 	+= u_DPgAssPV(y,val(aLinhas[x][1]),m)
						NTVLRAPV 	:= NTVLRAPV + u_DPgAssPV(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 5 	// QUANTIDADE ACESSORIOS PEDIDO DE VENDA
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_DQtdAssPV	(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDQtdAssPV 	+= u_DQtdAssPV(y,val(aLinhas[x][1]),m)
						NTQTDAPV 	:= NTQTDAPV + u_DQtdAssPV(y,val(aLinhas[x][1]),m)
						// OUTROS
					ELSEIF Y == 6 	// VALOR CAPACETES PEDIDO DE VENDA
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_ODPGPV		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDOPGPV 	+= u_ODPGPV(y,val(aLinhas[x][1]),m)
						NTVLRPV 	:= NTVLRPV + u_ODPGPV(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 7 	// QUANTIDADE CAPACETES PEDIDO DE VENDA
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_ODqtdPV		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDOqtdPV 	+= u_ODQtdPV(y,val(aLinhas[x][1]),m)
						NTQTDPV 	:= NTQTDPV + u_ODQtdPV(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 8 	// VALOR ACESSORIOS PEDIDO DE VENDA
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_ODAPGPV		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDOAPGPV 	+= u_ODAPGPV(y,val(aLinhas[x][1]),m)
						NTVLRAPV 	:= NTVLRAPV + u_ODAPGPV(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 9 	// QUANTIDADE ACESSORIOS PEDIDO DE VENDA
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_ODAqtdPV		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDOAqtdPV 	+= u_ODAqtdPV(y,val(aLinhas[x][1]),m)
						NTQTDAPV 	:= NTQTDAPV + u_ODAqtdPV(y,val(aLinhas[x][1]),m)
						
					ELSEIF Y == 10	// TOTAIS
						aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVLRPV																	, aColunas[y][1] })
					ELSEIF Y == 11
						aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQTDPV																	, aColunas[y][1] })
					ELSEIF Y == 12
						aadd(aIndic, {alltrim(aLinhas[x][1])	, NTVLRAPV																	, aColunas[y][1] })
					ELSEIF Y == 13
						aadd(aIndic, {alltrim(aLinhas[x][1])	, NTQTDAPV																	, aColunas[y][1] })
						
					ELSEIF Y == 14
						aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVLRPV+NTVLRAPV															, aColunas[y][1] })
					ELSEIF Y == 15
						aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQTDPV+NTQTDAPV															, aColunas[y][1] })
						
					ELSEIF Y == 16 	// BRINDE NF
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_NFDBrinde	(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nNFDBrinde 	+= u_NFDBrinde(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 17 	// VALOR CAPACETES NOTA FISCAL
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_DPagoNF		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDPagoNF 	+= u_DPagoNF(y,val(aLinhas[x][1]),m)
						nTVlrNF 	:= nTVlrNF + u_DPagoNF(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 18 	// QUANTIDADE CAPACETES NOTA FISCAL
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_DQtdNF		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDQtdNF 	+= u_DQtdNF(y,val(aLinhas[x][1]),m)
						nTQtdNF 	:= nTQtdNF + u_DQtdNF(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 19 	// VALOR ACESSORIOS NOTA FISCAL
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_DPgAssNF		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDPgAssNF 	+= u_DPgAssNF(y,val(aLinhas[x][1]),m)
						nTVlrANF 	:= nTVlrANF + u_DPgAssNF(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 20 	// QUANTIDADE ACESSORIOS NOTA FISCAL
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_DQtdAssNF	(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDQtdAssNF 	+= u_DQtdAssNF(y,val(aLinhas[x][1]),m)
						nTQtdANF 	:= nTQtdANF + u_DQtdAssNF(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 21 	// VALOR CAPACETES NOTA FISCAL OUTROS
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_ODPGNF		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDOPGNF 	+= u_ODPGNF(y,val(aLinhas[x][1]),m)
						nDPagoNF 	:= nDPagoNF + u_ODPGNF(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 22 	// QUANTIDADE ACESSORIOS NOTA FISCAL OUTROS
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_ODqtdNF		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDOqtdNF 	+= u_ODqtdNF(y,val(aLinhas[x][1]),m)
						nTQtdNF 	:= nTQtdNF + u_ODqtdNF(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 23 	// VALOR ACESSORIOS NOTA FISCAL OUTROS
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_ODAPGNF		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDOAPGNF 	+= u_ODAPGNF(y,val(aLinhas[x][1]),m)
						nTVlrANF 	:= nTVlrANF + u_ODAPGNF(y,val(aLinhas[x][1]),m)
					ELSEIF Y == 24 	// QUANTIDADE CAPACETES NOTA FISCAL OUTROS
						aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m))) , u_ODAqtdNF		(y,val(aLinhas[x][1]),m)	, aColunas[y][1] })
						nDOAqtdNF	+= u_ODAqtdNF(y,val(aLinhas[x][1]),m)
						nTQtdANF	:= nTQtdANF + u_ODAqtdNF(y,val(aLinhas[x][1]),m)
						
					ELSEIF Y == 25 // TOTAIS
						aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVLRNF																	, aColunas[y][1] })
					ELSEIF Y == 26
						aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQTDNF																	, aColunas[y][1] })
					ELSEIF Y == 27
						aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVlrANF																	, aColunas[y][1] })
					ELSEIF Y == 28
						aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQtdANF																	, aColunas[y][1] })
						
					ELSEIF Y == 29
						aadd(aIndic, {alltrim(aLinhas[x][1])	, nTVLRNF+nTVlrANF															, aColunas[y][1] })
					ELSEIF Y == 30
						aadd(aIndic, {alltrim(aLinhas[x][1])	, nTQTDNF+nTQtdANF															, aColunas[y][1] })
						
					ENDIF
				ELSEIF X == 32
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDBrinde										, aColunas[01][1] }) // 01
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDPagoPV										, aColunas[02][1] }) // 02
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDQtdPV										, aColunas[03][1] }) // 03
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDPgAssPV										, aColunas[04][1] }) // 04
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDQtdAssPV									, aColunas[05][1] }) // 05
					
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOPGPV										, aColunas[06][1] }) // 06
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOqtdPV										, aColunas[07][1] }) // 07
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOAPGPV										, aColunas[08][1] }) // 08
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOAqtdPV										, aColunas[09][1] }) // 09
					/*
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDPagoPV	+nDPgAssPV							, aColunas[10][1] }) // 10
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDQtdPV	+nDQtdAssPV							, aColunas[11][1] }) // 11
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOPGPV	+nDOAPGPV	   						, aColunas[12][1] }) // 12
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOqtdPV	+nDOAqtdPV							, aColunas[13][1] }) // 13
					*/
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDPagoPV	+nDOPGPV							, aColunas[10][1] }) // 10
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDQtdPV	+nDOqtdPV							, aColunas[11][1] }) // 11
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDPgAssPV	+nDOAPGPV	   						, aColunas[12][1] }) // 12
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDQtdAssPV+nDOAqtdPV							, aColunas[13][1] }) // 13
					
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, (nDPagoPV	+nDPgAssPV) +(nDOPGPV	+nDOAPGPV)	, aColunas[14][1] }) // 14
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, (nDQtdPV	+nDQtdAssPV)+(nDOqtdPV	+nDOAqtdPV)	, aColunas[15][1] }) // 15
					
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nNFDBrinde									, aColunas[16][1] }) // 16
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDPagoNF										, aColunas[17][1] }) // 17
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDQtdNF										, aColunas[18][1] }) // 18
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDPgAssNF										, aColunas[19][1] }) // 19
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDQtdAssNF									, aColunas[20][1] }) // 20
					
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOPGNF										, aColunas[21][1] }) // 21
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOqtdNF										, aColunas[22][1] }) // 22
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOAPGNF										, aColunas[23][1] }) // 23
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOAqtdNF										, aColunas[24][1] }) // 24
					/*
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDPagoNF	+nDPgAssNF							, aColunas[25][1] }) // 25
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDQtdNF	+nDQtdAssNF							, aColunas[26][1] }) // 26
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOPGNF	+nDOAPGNF							, aColunas[27][1] }) // 27
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDOqtdNF	+nDOAqtdNF							, aColunas[28][1] }) // 28
					*/
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDPagoNF	+nDOPGNF							, aColunas[25][1] }) // 25
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDQtdNF	+nDOqtdNF							, aColunas[26][1] }) // 26
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDPgAssNF	+nDOAPGNF							, aColunas[27][1] }) // 27
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, nDQtdAssNF+nDOAqtdNF							, aColunas[28][1] }) // 28
					
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, (nDPagoNF	+nDPgAssNF) +(nDOPGNF	+nDOAPGNF)	, aColunas[29][1] }) // 29
					aadd(aIndic, {alltrim(aLinhas[x][1])+"_"+alltrim(mesextenso(str(m)))	, (nDQtdNF	+nDQtdAssNF)+(nDOqtdNF	+nDOAqtdNF)	, aColunas[30][1] }) // 30
					
				ENDIF
			Next y
			
			nTVlrPV		:= 0 // 06 - POSICAO DAS COLUNAS NO HTML
			nTQtdPV		:= 0 // 07 - POSICAO DAS COLUNAS NO HTML
			nTVlrPVO	:= 0 // 12 - POSICAO DAS COLUNAS NO HTML
			nTQtdPVO	:= 0 // 13 - POSICAO DAS COLUNAS NO HTML
			nTVlrNF		:= 0 // 19 - POSICAO DAS COLUNAS NO HTML
			nTQtdNF		:= 0 // 20 - POSICAO DAS COLUNAS NO HTML
			nTVlrNFO	:= 0 // 25 - POSICAO DAS COLUNAS NO HTML
			nTQtdNFO	:= 0 // 26 - POSICAO DAS COLUNAS NO HTML
			nTVlrANF	:= 0
			nTQtdANF	:= 0
			NTVLRAPV 	:= 0
			NTQTDAPV	:= 0
			
			
		Next x
		
		// Zera variaveis
		nDBrinde	:= 0
		nNFDBrinde	:= 0
		nDQtdPV 	:= 0
		nDPagoPV 	:= 0
		nDQtdAssPV 	:= 0
		nDPgAssPV 	:= 0
		nDQtdNF 	:= 0
		nDPagoNF 	:= 0
		nDQtdAssNF 	:= 0
		nDPgAssNF 	:= 0
		nTVlrANF	:= 0
		nTQtdANF	:= 0
		NTVLRAPV 	:= 0
		NTQTDAPV	:= 0
		
		// Gera Dimensão (Point Of View) Html
		U_MDW(aLinhas,aColunas,aIndic,mesextenso(m),"Relatorio gerencial - "+mesextenso(m),0)
		
		aIndic 		:= {}
	Next m
	
	conout("PROCESSO DW - " + DTOC(DDATABASE) + "-" + TIME() + "FIM MONTAGEM VIEWS")
	
ENDIF 

Return

//*--------------------------------------------------*
User Function MDW(aLin,aCol,aInd,cArq,cTit,nLink)
// *--------------------------------------------------*

Private f

CNOME 		:= cArq // "Corporativo"
_cARQ0   	:= "\system\dw\" + CNOME +".htm"
_nHandle0	:= FCreate(_cARQ0)

IF LEN(aLin) > 0
	nTot   	:= 0
	nLargo 	:= 100 * len(aCol)
	
	//	aCC := aLin //ASort(aLin,,,{|x,y|x[2]<y[2]})
	XCRLF  	:= CHR(13) + CHR(10)
	cTEXTO 	:= "<HTML><HEAD><TITLE>Consulta DW - Atualizado em " + dtoc(ddatabase) + " - " + time() + "</TITLE>"
	cTEXTO 	+= '<style type="text/css">' 						+ xcrlf
	cTEXTO 	+= '<!-- link -->' 									+ xcrlf
	cTEXTO 	+= 'a { ' 											+ xcrlf
	cTEXTO 	+= '	font-family: Tahoma;' 						+ xcrlf
	cTEXTO 	+= '	color: #000000;' 							+ xcrlf
	cTEXTO 	+= '	text-decoration: none;' 					+ xcrlf
	cTEXTO 	+= '}' 												+ xcrlf
	cTEXTO 	+= '<!-- link quando posicionar o mouse -->' 		+ xcrlf
	cTEXTO 	+= 'a:hover { ' 									+ xcrlf
	cTEXTO 	+= '	color: #99CCFF;' 							+ xcrlf
	cTEXTO 	+= '	text-decoration: underline;' 				+ xcrlf
	cTEXTO 	+= '}' 												+ xcrlf
	cTEXTO 	+= '</style>' 										+ xcrlf
	cTEXTO 	+= '	</HEAD>' 									+ xcrlf
	cTEXTO 	+= '<P style="MARGIN-LEFT: 0px; TEXT-INDENT: 1px; LINE-HEIGHT: 80%" align=justify><IMG src="image002.jpg" alt="Spider Capacetes" border=0>'+ xcrlf
	if !empty(cTit)
		cTEXTO += '<P style="MARGIN-LEFT: 0px; TEXT-INDENT: 2px; LINE-HEIGHT: 400%" align=center><FONT face=TAHOMA size=5>' + ctit
	endif
	cTEXTO 	+= '<br>'											+ xcrlf
	
	// INICIA TABELA
	cTexto 	+= '	<table border="0"width="600"> ' 			+ CRLF
	// MONTA COLUNA EM BRANCO REFERENTE AOS DIAS
	// LINHA 1
	cTexto 	+= '	<td colspan=1  style="background-color: #FFFFFF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"></td> ' 					+ CRLF
	cTexto 	+= '	<tr> '
	cTexto 	+= '	<td colspan=1  style="background-color: #FFFFFF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"></td> ' 					+ CRLF
	// MONTA COLUNAS PEDIDOS DE VENDA E FATURADOS
	cTexto 	+= '	<td colspan=15 style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="right"><font face="Arial" size="2" color="#000000">Pedidos de Venda</td> '	+ CRLF
	cTexto 	+= '	<td colspan=15 style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Faturamento</td> ' 		+ CRLF
	cTexto 	+= '	<tr> '
	// LINHA 2
	// MONTA COLUNA EM BRANCO REFERENTE AOS DIAS
	cTexto 	+= '	<td colspan=1  style="background-color: #FFFFFF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"></td> ' 					+ CRLF
	// MONTA COLUNA BRINDES - FATURADOS
	cTexto 	+= '	<td colspan=1  style="background-color: #BCEE68; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Brindes</td> '			+ CRLF
	// MONTA COLUNAS CAPACETES OFICIAL, ACESSORIOS OFICIAL E CAPACETES TIPO B, ACESSORIOS TIPO B - PEDIDOS DE VENDA
	cTexto 	+= '	<td colspan=2  style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Capacetes Oficial</td> ' 	+ CRLF
	cTexto 	+= '	<td colspan=2  style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Acessorios Oficial</td> ' + CRLF
	cTexto 	+= '	<td colspan=2  style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Capacetes Tipo B</td> ' 	+ CRLF
	cTexto 	+= '	<td colspan=2  style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Acessorios  Tipo B</td> ' + CRLF
	// TOTAIS
	cTexto 	+= '	<td colspan=2  style="background-color: #CFCFCF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Capacetes A+B</td> ' 	+ CRLF
	cTexto 	+= '	<td colspan=2  style="background-color: #EECBAD; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Acessorios A+B</td> ' 		+ CRLF
	// TOTAIS GERAL
	cTexto 	+= '	<td colspan=2  style="background-color: #FFFF00; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Total Geral</td> ' 		+ CRLF
	//cTexto += '	<td colspan=2  style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Totais Tipo B</td> ' 	+ CRLF
	// MONTA COLUNA BRINDES - FATURADOS
	cTexto 	+= '	<td colspan=1  style="background-color: #BCEE68; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Brindes</td> '			+ CRLF
	// MONTA COLUNAS CAPACETES OFICIAL, ACESSORIOS OFICIAL E CAPACETES TIPO B, ACESSORIOS TIPO B - FATURADOS
	cTexto 	+= '	<td colspan=2  style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Capacetes Oficial</td> ' 	+ CRLF
	cTexto 	+= '	<td colspan=2  style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Acessorios Oficial</td> ' + CRLF
	cTexto 	+= '	<td colspan=2  style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Capacetes Tipo B</td> ' 	+ CRLF
	cTexto 	+= '	<td colspan=2  style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Acessorios  Tipo B</td> '	+ CRLF
	// TOTAIS
	cTexto 	+= '	<td colspan=2  style="background-color: #CFCFCF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Capacetes A+B</td> ' 	+ CRLF
	cTexto 	+= '	<td colspan=2  style="background-color: #EECBAD; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Acessorios A+B</td> ' 		+ CRLF
	// TOTAIS GERAL
	cTexto 	+= '	<td colspan=2  style="background-color: #FFFF00; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Total Geral</td> ' 		+ CRLF
	//cTexto += '	<td colspan=2  style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Totais Tipo B</td> ' 	+ CRLF
	cTexto 	+= '	<tr> '
	// LINHA 3
	// MONTA COLUNA QUANTIDADE DOS BRINDES - PEDIDOS DE VENDA
	cTexto 	+= '	<td colspan=1  style="background-color: #FFFFFF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"></td> ' 					+ CRLF
	//cTexto += '	<td style="background-color: #BCEE68; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"></td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #BCEE68; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	// MONTA COLUNAS DE VALORES E QUANTIDADES DE CAPACETES E ACESSORIOS OFICIAL - PEDIDOS DE VENDA
	cTexto 	+= '	<td style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	// MONTA COLUNAS DE VALORES E QUANTIDADES DE CAPACETES E ACESSORIOS TIPO B - PEDIDOS DE VENDA
	cTexto 	+= '	<td style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	// TOTAIS
	cTexto 	+= '	<td style="background-color: #CFCFCF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #CFCFCF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #EECBAD; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #EECBAD; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	// TOTAL GERAL
	cTexto 	+= '	<td style="background-color: #FFFF00; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #FFFF00; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	// MONTA COLUNA QUANTIDADE DOS BRINDES - FATURADOS
	cTexto 	+= '	<td style="background-color: #BCEE68; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	// MONTA COLUNAS DE VALORES E QUANTIDADES DE CAPACETES E ACESSORIOS OFICIAL - FATURADOS
	cTexto 	+= '	<td style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	// MONTA COLUNAS DE VALORES E QUANTIDADES DE CAPACETES E ACESSORIOS TIPO B - FATURADOS
	cTexto 	+= '	<td style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	// TOTAIS
	cTexto 	+= '	<td style="background-color: #CFCFCF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #CFCFCF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #EECBAD; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #EECBAD; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	// TOTAL GERAL
	cTexto 	+= '	<td style="background-color: #FFFF00; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">R$ </td> ' 							+ CRLF
	cTexto 	+= '	<td style="background-color: #FFFF00; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Qtd</td> ' 							+ CRLF
	cTexto 	+= '	</tr> ' + CRLF
	// LINHA 4
	nVal1  	:= U_RetAtr( .T.,"C",MV_PAR01,MV_PAR02)	// BRINDES
	nVal2  	:= U_RetAtr( .F.,"A",MV_PAR01,MV_PAR02)	// CAPACETES 	VALOR
	nVal3  	:= U_RetAtr( .T.,"A",MV_PAR01,MV_PAR02)	// CAPACETES 	QTD
	nVal4  	:= U_RetAtr( .F.,"B",MV_PAR01,MV_PAR02)	// ACESSORIOS 	VALOR
	nVal5  	:= U_RetAtr( .T.,"B",MV_PAR01,MV_PAR02)	// ACESSORIOS 	QTD
	nVal6  	:= U_ORetAtr(.F.,"A",MV_PAR01,MV_PAR02)	// CAPACETES 	VALOR 	OUTROS
	nVal7  	:= U_ORetAtr(.T.,"A",MV_PAR01,MV_PAR02)	// CAPACETES 	QTD		OUTROS
	nVal8  	:= U_ORetAtr(.F.,"B",MV_PAR01,MV_PAR02)	// ACESSORIOS 	VALOR 	OUTROS
	nVal9  	:= U_ORetAtr(.T.,"B",MV_PAR01,MV_PAR02)	// ACESSORIOS 	QTD		OUTROS
	nValA  	:= nVal2+nVal6							 	// TOTAL CAPACETES
	nValB  	:= nVal3+nVal7							 	// TOTAL ACESSORIOS
	nValC  	:= nVal4+nVal8							 	// TOTAL CAPACETES
	nValD  	:= nVal5+nVal9							 	// TOTAL ACESSORIOS
	// MONT	A COLUNA EM BRANCO REFERENTE AOS DIAS
	cTexto 	+= 	'  <td colspan=1 style="background-color: #FFFFFF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000">Mes/Dia</td> ' 			+ CRLF
	// MONTA COLUNAS COM VALORES ATRASADOS
	// BRINDES
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nVal1>0,TRANSFORM(nVal1,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	// OFICIAL
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nVal2>0,TRANSFORM(nVal2,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nVal3>0,TRANSFORM(nVal3,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nVal4>0,TRANSFORM(nVal4,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nVal5>0,TRANSFORM(nVal5,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	// TIPO B
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nVal6>0,TRANSFORM(nVal6,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nVal7>0,TRANSFORM(nVal7,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nVal8>0,TRANSFORM(nVal8,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nVal9>0,TRANSFORM(nVal9,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	// TOTAIS OFICIAL
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nValA>0,TRANSFORM(nValA,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nValB>0,TRANSFORM(nValB,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	// TOTAIS TIPO B
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nValC>0,TRANSFORM(nValC,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(nValD>0,TRANSFORM(nValD,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	// TOTAL GERAL
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF((nValA+nValC)>0,TRANSFORM(nValA+nValC,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF((nValB+nValD)>0,TRANSFORM(nValB+nValD,"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	// COMPLETA A LINHA, ATRASADOS SAO APENAS PARA PEDIDOS DE VENDA
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTEXTO 	+= 	'  <td style="background-color: #FF0000; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + ''+'">'+IIF(0>0,TRANSFORM(U_RetAtr(.T.,"C",MV_PAR01,MV_PAR02),"@E 99,999,999.99"),"") +'</a></td>' + CRLF
	cTexto 	+= 	'  </tr> ' + CRLF
	FWrite(_nHandle0,ctexto)
	
	w	   	:= 0
	FOR g:=1 TO LEN(aLin)
		
		cTEXTO 			:= 	'  <td style="background-color: #FFFFFF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="url">'+IIF(G==LEN(aLin),"<B>","")+aLin[g][1]+'</a></td>' + CRLF
		
		for f:=1 to len(aCol)
			
			IF F == 1 						// BRINDES PEDIDOS DE VENDA
				cTEXTO 	+= 	'  <td style="background-color: #BCEE68; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F >= 02 .AND. F <= 05 	// PV OFICIAL
				cTEXTO 	+= 	'  <td style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F >= 06 .AND. F <= 09 	// PV TIPO B
				cTEXTO 	+= 	'  <td style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F >= 10 .AND. F <= 11 	// PV OFICIAL TOTAIS
				cTEXTO 	+= 	'  <td style="background-color: #CFCFCF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F >= 12 .AND. F <= 13 	// PV TIPO B TOTAIS
				cTEXTO 	+= 	'  <td style="background-color: #EECBAD; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F >= 14 .AND. F <= 15 	// PV TIPO TOTAL GERAL
				cTEXTO 	+= 	'  <td style="background-color: #FFFF00; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F == 16 					// BRINDES FATURADOS
				cTEXTO 	+= 	'  <td style="background-color: #BCEE68; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F >= 17 .AND. F <= 20 	// NF OFICIAL
				cTEXTO 	+= 	'  <td style="background-color: #AFEEEE; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F >= 21 .AND. F <= 24 	// NF TIPO B
				cTEXTO 	+= 	'  <td style="background-color: #DEB887; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F >= 25 .AND. F <= 26 	// NF OFICIAL TOTAIS
				cTEXTO 	+= 	'  <td style="background-color: #CFCFCF; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F >= 27 .AND. F <= 28 	// NF TIPO B TOTAIS
				cTEXTO 	+= 	'  <td style="background-color: #EECBAD; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ELSEIF F >= 29 .AND. F <= 30 	// NF TIPO TOTAL GERAL
				cTEXTO 	+= 	'  <td style="background-color: #FFFF00; border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2" color="#000000"><a href="' + alltrim(aInd[f+w][1]) +if(nLink<>5, '.htm','')+'">'+IIF(aInd[f+w][2]>0,IIF(G==LEN(aLin),"<B>","")+TRANSFORM(aInd[f+w][2],"@E 99,999,999.99"),"") +'</a></td>' + CRLF
			ENDIF
		next f
		cTEXTO += '<TR>'
		w += LEN(aCol)
		FWrite(_nHandle0,ctexto)
	NEXT g
	
	cTEXTO += '</HTML>' + XCRLF
	
	FClose(_nHandle0)
	
	CpyS2T("\SYSTEM\DW\"+CNOME+".htm","C:\DW",.F.)
	CpyS2T("\SYSTEM\DW\IMAGE001.JPG","C:\DW",.F.)
	CpyS2T("\SYSTEM\DW\IMAGE002.JPG","C:\DW",.F.)
	
ENDIF

Return


// *-------------------------------------------------*
Static Function fInim(nm)
// *--------------------------------------------------*

dRet := ctod("")

dRet := ctod("01/"+STRZERO(NM,2)+"/"+STR(YEAR(DDATABASE)) )

Return(dRet)

// *-------------------------------------------------*
Static Function fFimm(nm)
// *--------------------------------------------------*

dRet := ctod("")
nDiaFim := 31

IF nm == 1
	nDiaFim := 31
ELSEIF nm == 2
	nDiaFim := 28
ELSEIF nm == 3
	nDiaFim := 31
ELSEIF nm == 4
	nDiaFim := 30
ELSEIF nm == 5
	nDiaFim := 31
ELSEIF nm == 6
	nDiaFim := 30
ELSEIF nm == 7
	nDiaFim := 31
ELSEIF nm == 8
	nDiaFim := 31
ELSEIF nm == 9
	nDiaFim := 30
ELSEIF nm == 10
	nDiaFim := 31
ELSEIF nm == 11
	nDiaFim := 30
ELSEIF nm == 12
	nDiaFim := 31
EndIF



dRet := ctod( STRZERO(nDiaFim,2) + "/" +STRZERO(NM,2)+"/"+STR(YEAR(DDATABASE)) )

Return(dRet)
// *--------------------------------------------------*
Static Function PictMTDW(cNat)
// *--------------------------------------------------*

Local cRet:=""

IF LEN(cNat) == 2
	cRet:=Trans(cNat,"@R 9.9")
ELSEIF LEN(cNat) == 3
	cRet:=Trans(cNat,"@R 9.9.9")
ELSEIF LEN(cNat) == 4
	cRet:=Trans(cNat,"@R 9.9.99")
ELSE
	cRet:=cNat
ENDIF

Return cRet
