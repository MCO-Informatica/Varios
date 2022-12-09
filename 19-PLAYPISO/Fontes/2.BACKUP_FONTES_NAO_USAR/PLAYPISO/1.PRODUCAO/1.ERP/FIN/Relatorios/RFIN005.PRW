#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN005   º Autor ³ Bruno Parreira     º Data ³  18/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Faturamento Direto                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda - Actual Trend                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFIN005()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatórios de Liberação de Pagamento à Empreiteiros"
Local cPict         := ""
Local titulo        := "Relatórios de Liberação de Pagamento à Empreiteiros"
Local nLin          := 80
//          1         2         3         4         5         6         7         8         9        10         1         2         3         4         5         6         7         8         9        20       21        22
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234578901234567890
Local Cabec1         := "Obra    Descrição Obra                           Dt. Emissão   Vlr. Contrato   No. Título  Parcela   Vlr. Titulo   Dt. Baixa   Vlr. Baixado    Saldo    Vencto. Real   Dias de Atraso "
Local Cabec2         := ""

Local imprime       := .T.
Private aOrd        := {}//{"Obra"}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RFIN005" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RFIN005"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFIN005" // nome do arquivo usado para impressao em disco
Private cArqTrab
Private cString     := "SE2"

//AjustaSX1()

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27 // If nLastKey == 27 - TOBIAS PENICHE - ActualTrend - 02131007
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27  // If nLastKey == 27 - TOBIAS PENICHE - ActualTrend - 02131007
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Mauro Nagata       º Data ³  24/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)  
        
Local cFornece := ""  
Local cNumTit  := ""
Local cObra    := ""
Local cDescF   := ""

cAliasSE2 := RFINSQLSE2()                                         

DbSelectArea(cAliasSE2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            
nTotVlrCtr := 0  
nTotVlrTit := 0
nTotVlrBxa := 0
nTotVlrSld := 0  

nTotEmpCtr := 0
nTotEmpTit := 0
nTotEmpBxa := 0
nTotEmpSld := 0  

nDiasAtr := 0

nCountReg := 0
DbEval({|| nCountReg++})
(cAliasSE2)->(DbGoTop())
SetRegua(nCountReg)

if (cAliasSE2)->(!EOF())
    lFirst := .T.
	While (cAliasSE2)->(!EOF())
	IncRegua()
	    
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@Prow()+1,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If Prow() >55 .Or. lFirst
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
			lFirst := .T.
			//lIp := .F.
		EndIf      
		
		if cFornece == (cAliasSE2)->E2_FORNECE 
			lVerF := .T.
		else	
		    lVerF := .F.
		EndIf  
		
		if cNumTit == (cAliasSE2)->E2_NUM  
			lPasT := .T.  
		else
			lPasT := .F.	
		EndIf   
		
		If lFirst
			nLinha := 1          // nLinha := 0 TOBIAS PENICHE - ActualTrend - 20131003 *original
		else
			nLinha := 2         
		EndIf		
		
		if !lVerF .Or. lFirst
			
			cDescF  := (cAliasSE2)->E2_NOMFOR 
			cNumTit := (cAliasSE2)->E2_NUM
							
			@ Prow()+nLinha,0 PSay "Empreiteiro:"
			@ Prow(),Pcol()+1 PSay cDescF
			@ Prow()+1,0      PSay "Num. Tit.:"
			@ Prow(),Pcol()+1 PSay cNumTit
			
		elseIf !lPasT
		
			cNumTit := (cAliasSE2)->E2_NUM
			@ Prow()+2,0      PSay "Num. Tit.:"
			@ Prow(),Pcol()+1 PSay cNumTit
						
		EndIf
		
		cObra     := (cAliasSE2)->E2_XCC       
		cDescObra := (cAliasSE2)->E2_XDESCR       
		cDtEmiss  := Dtoc(Stod((cAliasSE2)->E2_EMISSAO))
		nVlrContr := (cAliasSE2)->E2_VLRCON
		cNumTit   := (cAliasSE2)->E2_NUM
		cParcela  := (cAliasSE2)->E2_PARCELA
		nValTit   := (cAliasSE2)->E2_VALOR
		cDtBaixa  := Dtoc(Stod((cAliasSE2)->E5_DATA))
		nVlrBaixa := (cAliasSE2)->E5_VALOR
		nSaldo    := (cAliasSE2)->E2_SALDO              
		cVencRea  := Dtoc(Stod((cAliasSE2)->E2_VENCREA))	
		nDiasAtr  := Stod(Dtos(DDATABASE)) - Stod((cAliasSE2)->E2_VENCREA)
		
		@ Prow()+1,0 PSay cObra  
		@ Prow(),PCol()+1 PSay cDescObra  
		@ Prow(),PCol()+2 PSay cDtEmiss
		@ Prow(),PCol()+5 PSay nVlrContr Picture "@RE 999,999.99"
		@ Prow(),PCol()+4 PSay cNumTit
		@ Prow(),PCol()+5 PSay cParcela
		@ Prow(),PCol()+6 PSay nValTit Picture "@RE 999,999.99"
		@ Prow(),PCol()+3 PSay cDtBaixa  
		@ Prow(),PCol()+5 PSay nVlrBaixa Picture "@RE 999,999.99"
		@ Prow(),PCol()+4 PSay nSaldo Picture "@RE 999,999.99"
		@ Prow(),PCol()+4 PSay cVencRea    
		@ Prow(),PCol()+5 PSay nDiasAtr
		                      
		nTotVlrCtr += nVlrContr
		nTotVlrTit += nValTit
		nTotVlrBxa += nVlrBaixa
		nTotVlrSld += nSaldo		
		
		cFornece := (cAliasSE2)->E2_FORNECE   
		cNumTit  := (cAliasSE2)->E2_NUM   
		
		(cAliasSE2)->(DbSkip()) 
		
		if cNumTit <> (cAliasSE2)->E2_NUM   
			@ Prow()+1,0  PSay Replicate("-",181)
			@ Prow()+1,0  PSay "Total Título: "		
			@ Prow(),65   PSay nTotVlrCtr Picture "@RE 999,999.99"
			@ Prow(),101  PSay nTotVlrTit Picture "@RE 999,999.99" 
			@ Prow(),127  PSay nTotVlrBxa Picture "@RE 999,999.99"
			@ Prow(),141  PSay nTotVlrSld Picture "@RE 999,999.99" 
			  
			nTotEmpCtr += nTotVlrCtr
			nTotEmpTit += nTotVlrTit
			nTotEmpBxa += nTotVlrBxa
			nTotEmpSld += nTotVlrSld
			
			nTotVlrCtr := 0
			nTotVlrTit := 0 
			nTotVlrBxa := 0
			nTotVlrSld := 0
		EndIf  
		
		if cFornece <> (cAliasSE2)->E2_FORNECE 
			@ Prow()+1,0  PSay Replicate("_",181)
			@ Prow()+1,0  PSay "Total do Empreiteiro: "		
			@ Prow(),65   PSay nTotEmpCtr Picture "@RE 999,999.99"
			@ Prow(),101  PSay nTotEmpTit Picture "@RE 999,999.99" 
			@ Prow(),127  PSay nTotEmpBxa Picture "@RE 999,999.99"
			@ Prow(),141  PSay nTotEmpSld Picture "@RE 999,999.99" 
			@ Prow()+2,0  PSay Replicate("=",181)	 
			
			nTotEmpCtr := 0
			nTotEmpTit := 0
			nTotEmpBxa := 0
			nTotEmpSld := 0
		EndIf    
		
		lFirst := .F. 
	EndDO	
EndIf

/*              
Local cItemPC  := "" 
Local cBlqObra := ""   
Local nValPedV := 0
Private cCCusto  := ""

Private nOrdem              

clAliasCTT := RFATSQLCTT()
 	
DbSelectArea(clAliasCTT)
(clAliasCTT)->(DbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//SetRegua(RecCount())                                                                     
//substituida linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 29/06/2011]
nCountReg := 0
DbEval({|| nCountReg++})
(clAliasCTT)->(DbGoTop())
SetRegua(nCountReg)
//fim bloco [Mauro Nagata, Actual Trend, 29/06/2011]                                                        
	          
nTotGPed := 0  //total Geral de PEDidos
nTotRMA  := 0  //total Realizado Mais Aberto
nTotFaFi := 0  //total FAturamento vs FInanceiro	
	
if (clAliasCTT)->(!EOF())
	lIp := .T.
	Do While (clAliasCTT)->(!EOF())      
	    
	    IncRegua()
	    
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@Prow()+1,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If Prow()>55.Or.lIp
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			lIp := .F.
		EndIf

		cObra     := (clAliasCTT)->CTT_CUSTO
		cDescObra := (clAliasCTT)->CTT_DESC01 
		nVlrLim   := (clAliasCTT)->CTT_XFATD
						
		@ Prow()+2,0      PSay cObra
		@ Prow(),Pcol()+1 PSay cDescObra
		@ Prow(),Pcol()+1 PSay "- Limite Faturamento Direto :"
		@ Prow(),Pcol()+1 PSay nVlrLim Picture "@RE 999,999,999.99"
			
		lPula := .T.  //Variavel para verificar se pula mais linhas na mudanca de pedidos. [Bruno Parreira, Actual Trend, 25/05/2011]
            
        cCCusto := (clAliasCTT)->CTT_CUSTO

		ArqTrb(cCCusto)
		 
		DbSelectArea("TRB")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		   
	//	SetRegua(RecCount())
		      
	//	lPula 	:= .T.
	   //	lIp 	:= .T.  
	   	nTObVlrPC := 0    //total de valor por obra x pedido de compras
		nTObQtdPC := 0   //total de quantidade por obra x pedido de compras
		
		nTObVlrRe := 0    //total de valor por obra x Realizado
		nTObQtdRe := 0   //total de quantidade por obra x realizado
		
		nTObVlrAb := 0    //total de valor por obra x em aberto
		nTObQtdAb := 0   //total de quantidade por obra x em aberto
		
		nTObVlrRs := 0    //total de valor por obra x residuo
		nTObQtdRs := 0   //total de quantidade por obra x residuo        
		
		nTObVlIPI := 0   //total do IPI do Realizado         
		
		nTPVlrPC := 0
		nTPQtdPC := 0  
		
		nValPedV := 0
	   
		lItPas 	:= .T.
		DbGoTop()
		if TRB->(!EOF())     
		    
			clAliasSC5 := RFATSQLSC5()
 	
			DbSelectArea(clAliasSC5)
			(clAliasSC5)->(DbGoTop())
		    
			if (clAliasSC5)->(!EOF())
				nValPedV := (clAliasSC5)->C5_XSDFATD
			EndIf	
		                       
		    //incluida linha abaixo [Mauro Nagata, Actual Trend, 29/06/2011]
		    DbSelectArea("TRB")                                            
		    
			Do While !Eof()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o cancelamento pelo usuario...                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
		//	  	If lAbortPrint
		//			@Prow()+1,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		//			Exit
		//		Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do cabecalho do relatorio. . .                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
		//		If Prow()>55.Or.lIp
		//			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		//			lIp := .F.
		//		EndIf
				
				//                     1         2         3         4         5         6         7         8         9        10         1         2         3         4         5         6         7         8         9        20       21        22
				//           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234578901234567890
				//Cabec1 := "Obra      Pedido  Ped.Compras             Fatura/o.Realizado      Pedido em Aberto        Elim.por Residuo        Necessidade  Emissao   Doc.Entr/Serie Emissao Item   Produto      Descricao                              "
				//Cabec2 := "          Compras Valor        Qtde       Valor        Qtde       Valor        Qtde       Valor        Qtde       Doc.Entrada  Doc.Entr                 Pedido" Pedido
				
	    //		cObra     := TRB->OBRA
		//		cDescObra := "Nao Encontrada"
				
				
		//		cDescObra := TRB->DESCOBR
		//		nVlrLim   := TRB->LIMFATDIR
							
		//		@ Prow()+2,0      PSay cObra
		//		@ Prow(),Pcol()+1 PSay cDescObra
		//		@ Prow(),Pcol()+1 PSay "- Limite Faturamento Direto :"
		//		@ Prow(),Pcol()+1 PSay nVlrLim Picture "@RE 999,999,999.99"
				
		//		lPula := .T.  //Variavel para verificar se pula mais linhas na mudanca de pedidos. [Bruno Parreira, Actual Trend, 25/05/2011]
				
			
				DbSelectArea("TRB")
				Do While !Eof().And.TRB->OBRA = cObra
					//IncRegua("Imprimindo . . . ")
					If Prow()>55
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					EndIf
					
					cNumPed := TRB->NUMPED   
					cItemPC := AllTrim(TRB->ITEMPED)  
					cCodFor := TRB->FORNEC
					cNomFor := GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+cCodFor,1,"Não Encontrado")
					
					//Inicio - Incluido condicao abaixo para tratar quebra de linha ao mudar de pedido. [Bruno Parreira, Actual Trend, 25/05/2011]
					if !lPula
						@ Prow()+1,10 Psay cNumPed          //numero do pedido de compras
					else
						@ Prow()+2,10 Psay cNumPed          //numero do pedido de compras
					EndIf
					
					lPula := .F.	                                                                                                             
					//Fim - [Bruno Parreira, Actual Trend, 25/05/2011]
					
					nTPVlrRe := 0
					nTPQtdRe := 0
					nTPVlrAb := 0
					nTPQtdAb := 0
					nTPVlrRs := 0
					nTPQtdRs := 0                         
					lIpPed   := .F. 
					lItFirst := .T.      // Variavel para verificar primeiro Item. [Bruno Parreira, Actual Trend, 25/05/2011]
					
					Do While !Eof().And.TRB->NUMPED = cNumPed
						
						//Inicio - Incluido bloco abaixo para somar o item no total de pedidos somente uma vez. [Bruno Parreira, Actual Trend, 25/05/2011]
					 	If cItemPC <> AllTrim(TRB->ITEMPED) .Or. lItFirst
							lItPas := .T.
						else
							lItPas := .F.
						EndIf 
						
						lItFirst := .F.
						
						cItemPC := AllTrim(TRB->ITEMPED)		
						
						if lItPas 
							nTotPed   := TRB->TOTPED                      
							nQtPed    := TRB->QTPED
							nTObVlrPC += nTotPed
							nTObQtdPC += nQtPed
							nTPVlrPC  += nTotPed
							nTPQtdPC  += nQtPed 
						EndIf    
						//Fim - [Bruno Parreira, Actual Trend, 25/05/2011]                
						
						nVlrAbe := 0  //valor em aberto
						nQtdAbe := 0  //quantidade em aberto
						If TRB->QTPED-TRB->QENTR != 0.And.TRB->RESIDUO != "S"
							nVlrAbe := (TRB->QTPED-TRB->QENTR)*TRB->PRPED
							nQtdAbe := TRB->QTPED-TRB->QENTR
						EndIf	
						nTObVlrAb += nVlrAbe
						nTObQtdAb += nQtdAbe
						nTPVlrAb  += nVlrAbe
						nTPQtdAb  += nQtdAbe	
						
						nVlrRes := 0   //valor residual
						nQtdRes := 0   //quantidade residual
						If TRB->RESIDUO = "S"
							nVlrRes := (TRB->QTPED-TRB->QENTR)*TRB->PRPED
							nQtdRes := TRB->QTPED-TRB->QENTR
						EndIf
						nTObVlrRs += nVlrRes
						nTObQtdRs += nQtdRes
						nTPVlrRs  += nVlrRes
						nTPQtdRs  += nQtdRes	
					
						nTotDoc  := TRB->TOTDOC
						nQtDoc   := TRB->QTDOC   
						nTotIPI  := TRB->VALIPI
						nTObVlrRe += nTotDoc
						nTObQtdRe += nQtDoc
						nTPVlrRe  += nTotDoc
						nTPQtdRe  += nQtDoc 
						nTObVlIPI += nTotIPI
						
						If MV_PAR03 = 1  //relatorio analitico
							@ Prow()+If(lIpPed,1,0),18 Psay nTotPed Picture "@RE 999,999.99"  //total pedido de compras
							@ Prow(),Pcol()+1          Psay nQtPed  Picture "@RE 999,999.99"
							
							@ Prow(),Pcol()+1 Psay nTotDoc Picture "@RE 999,999.99"   //total realizado     //45
							@ Prow(),Pcol()+1 Psay nQtDoc  Picture "@RE 999,999.99"   
							@ Prow(),Pcol()+1 Psay nTotIPI  Picture "@RE 999,999.99"
							
							@ Prow(),Pcol()+1 Psay nVlrAbe Picture "@RE 999,999.99"   //69
							@ Prow(),Pcol()+1 Psay nQtdAbe Picture "@RE 999,999.99"
							
							@ Prow(),Pcol()+1 Psay nVlrRes Picture "@RE 999,999.99"  //93
							@ Prow(),Pcol()+1 Psay nQtdRes Picture "@RE 999,999.99"
							
							@ Prow(),Pcol()+1 Psay TRB->NECESS  Picture "@D"
							@ Prow(),Pcol()+1 Psay TRB->EMISDOC Picture "@D"
							@ Prow(),Pcol()+1 Psay TRB->DOC+"/"
							@ Prow(),Pcol()   Psay TRB->SERIE
							@ Prow(),Pcol()+1 Psay TRB->EMISPED Picture "@D"
							
						//	@ Prow(),Pcol()+1 Psay TRB->ITEMPED
							@ Prow(),Pcol()+1 Psay Left(TRB->PRODUTO,6)
							@ Prow(),Pcol()+1 Psay Left(TRB->DESCPRD,24) 
							@ Prow(),Pcol()+1 Psay cCodFor   
							@ Prow(),Pcol()+1 Psay Left(cNomFor,24)
						EndIf                           
						lIpPed := .T.
						DbSelectArea("TRB")
					    DbSkip()
					EndDo         
					If MV_PAR03 = 2 
					   @ Prow(),18       Psay nTPVlrPC Picture "@RE 999,999.99"  //total pedido de compras
					   @ Prow(),Pcol()+1 Psay nTPQtdPC Picture "@RE 999,999.99"
							
					   @ Prow(),42       Psay nTPVlrRe Picture "@RE 999,999.99"   //total realizado
					   @ Prow(),Pcol()+1 Psay nTPQtdRe  Picture "@RE 999,999.99"
							
					   @ Prow(),66       Psay nTPVlrAb Picture "@RE 999,999.99"
					   @ Prow(),Pcol()+1 Psay nTPQtdAb Picture "@RE 999,999.99"
							
					   @ Prow(),90       Psay nTPVlrRs Picture "@RE 999,999.99"
					   @ Prow(),Pcol()+1 Psay nTPQtdRs Picture "@RE 999,999.99"
					EndIf		
				EndDo      
				@ Prow()+1,00     PSay Replicate("-",116)
				/*
				@ Prow()+1,00     PSay "Total          (+)"
				//@ Prow(),17       PSay nTObVlrPC-nTObVlrRs Picture "@RE 99,999,999.99"
				//@ Prow(),Pcol()+1 PSay nTObQtdPC-nTObQtdRs Picture "@RE 999,999.99" 
				@ Prow(),18       PSay nTObVlrPC Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1 PSay nTObQtdPC Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1       PSay nTObVlrRe Picture "@RE 999,999.99"
				//@ Prow(),Pcol()+1 PSay nTObQtdRe Picture "@RE 999,999.99" 
				@ Prow(),Pcol()+1 PSay nTObVlIPI Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1       PSay nTObVlrAb Picture "@RE 999,999.99"
				//@ Prow(),Pcol()+1 PSay nTObQtdAb Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1       PSay nTObVlrRs Picture "@RE 999,999.99"
				//@ Prow(),Pcol()+1 PSay nTObQtdRs Picture "@RE 999,999.99"
				                                                                      
				@ Prow()+1,00     PSay "Resíduo        (-)"
				@ Prow(),Pcol()   PSay nTObVlrRs Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1 PSay nTObQtdRs Picture "@RE 999,999.99"
				@ Prow()+1,00     PSay "Realiz.+Aberto (-)"
				@ Prow(),Pcol()   PSay nTObVlrRe+nTObVlrAb Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1 PSay nTObQtdRe+nTObQtdAb Picture "@RE 999,999.99"  
				@ Prow()+1,15     PSay Replicate("-",27)
				@ Prow()+1,00     PSay "Diferenca      (=)"
				@ Prow(),Pcol()   PSay (nTObVlrPC-nTObVlrRs) - (nTObVlrRe+nTObVlrAb+nTObVlIPI) Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1 PSay (nTObQtdPC-nTObQtdRs) - (nTObQtdRe+nTObQtdAb) Picture "@RE 999,999.99"
				
				
				@ Prow()+2,00     PSay "Limite FD      (+)"
				@ Prow(),Pcol()   PSay nVlrLim Picture "@RE 999,999.99"
				@ Prow()+1,00     PSay "Realiz.+Aberto (-)"
				@ Prow(),Pcol()   PSay nTObVlrRe+nTObVlrAb Picture "@RE 999,999.99"
				@ Prow()+1,15     PSay Replicate("-",16)
				@ Prow()+1,00     PSay "Diferenca      (=)"
				@ Prow(),Pcol()   PSay nVlrLim - (nTObVlrRe+nTObVlrAb+nTObVlIPI) Picture "@RE 999,999.99"
				
				if nValPedV <> 0
					@ Prow()+2,00     PSay "Valor em faturamento no financeiro:"
					@ Prow(),Pcol()   PSay nValPedV Picture "@RE 999,999.99"
				EndIf
				*//*  
				//substituido o bloco acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 29/06/2011]
				@ Prow()+1,00      PSay "Total          "
				@ Prow(),18        PSay nTObVlrPC Picture "@RE 999,999.99"
				//@ Prow(),Pcol()+01 PSay nTObQtdPC Picture "@RE 999,999.99"
				@ Prow(),Pcol()+12 PSay nTObVlrRe Picture "@RE 999,999.99"
				@ Prow(),Pcol()+12 PSay nTObVlIPI Picture "@RE 999,999.99"
				@ Prow(),Pcol()+01 PSay nTObVlrAb Picture "@RE 999,999.99"
				@ Prow(),Pcol()+11 PSay nTObVlrRs Picture "@RE 999,999.99"
				
			    @ Prow()+2,05      PSay Replicate("-",72)                                                                                                    
                @ Prow()+1,05      PSay "Demonstrativo de Calculo"                 
                @ Prow()+1,05      PSay Replicate("-",72)                                                                                                    
                
                @ Prow()+1,05      PSay "Total          (+)"
				@ Prow(),23        PSay nTObVlrPC Picture "@RE 999,999.99"
				@ Prow(),Pcol()+01 PSay nTObQtdPC Picture "@RE 999,999.99"
				                        
				nColAux := Pcol()+5
				@ Prow(),nColAux  PSay "Limite FD      (+)"
				@ Prow(),Pcol()   PSay nVlrLim Picture "@RE 999,999.99"   
				                                                                      
				@ Prow()+1,05     PSay "Realiz.+Aberto (-)"
				@ Prow(),Pcol()   PSay nTObVlrRe+nTObVlrAb Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1 PSay nTObQtdRe+nTObQtdAb Picture "@RE 999,999.99"  
				@ Prow(),nColAux  PSay "Realiz.+Aberto (-)"
				@ Prow(),Pcol()   PSay nTObVlrRe+nTObVlrAb Picture "@RE 999,999.99"         

                @ Prow()+1,05     PSay "Resíduo        (-)"
				@ Prow(),Pcol()   PSay nTObVlrRs Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1 PSay nTObQtdRs Picture "@RE 999,999.99" 	
				@ Prow(),nColAux  PSay Space(16)+Replicate("-",12)
				
				@ Prow()+1,20     PSay Replicate("-",24)
				@ Prow(),nColAux  PSay "Diferenca      (=)"
				@ Prow(),Pcol()   PSay nVlrLim - (nTObVlrRe+nTObVlrAb+nTObVlIPI) Picture "@RE 999,999.99"			
				
				@ Prow()+1,05     PSay "Diferenca      (=)"
				@ Prow(),Pcol()   PSay (nTObVlrPC-nTObVlrRs) - (nTObVlrRe+nTObVlrAb+nTObVlIPI) Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1 PSay (nTObQtdPC-nTObQtdRs) - (nTObQtdRe+nTObQtdAb)           Picture "@RE 999,999.99"

				If nValPedV <> 0
					@ Prow(),nColAux PSay "Valor Financeiro:"
					@ Prow(),Pcol()  PSay nValPedV Picture "@RE 999,999.99"
				EndIf	
				@ Prow()+1,05      PSay Replicate("-",72)                                                                                                    
				//fim bloco [Mauro Nagata, Actual Trend, 29/06/2011]
				                                                                                          
				@ Prow()+2,00     PSay Replicate("=",220)
			EndDo  
		else       
			clAliasSC5 := RFATSQLSC5()
 	
			DbSelectArea(clAliasSC5)
			(clAliasSC5)->(DbGoTop())
		    
			if (clAliasSC5)->(!EOF())
				nValPedV := (clAliasSC5)->C5_XSDFATD
			EndIf	
		    
			@ Prow()+1,00     PSay "Não existe movimentação para essa Obra."
			  
			
			If nValPedV <> 0
				@ Prow()+1,00   PSay "Valor Financeiro:"
				@ Prow(),Pcol()  PSay nValPedV Picture "@RE 999,999.99"
			EndIf 
			
			@ Prow()+2,00     PSay Replicate("=",220)	
		EndIf	
		                                         
		nTotGPed += nTObVlrPC
		nTotRMA  += nTObVlrRe+nTObVlrAb                 
		nTotFaFi += nValPedV
		
		DbSelectArea("TRB")
		DbCloseArea("TRB")
		
		fErase(cArqTrab+GetDBExtension())
		fErase(cArqTrab+OrdBagExt()) 
		
		(clAliasCTT)->(DbSkip())
		 
	EndDo
  	If !lIp 
	   @ Prow()+1,05   PSay "Total Fatur.Direto    (+)"
	   @ Prow(),Pcol() PSay nTotGPed        Picture "@RE 999,999,999.99"
	   @ Prow()+1,05   PSay "Total Realiz.+Aberto  (-)"
	   @ Prow(),Pcol() PSay nTotRMA         Picture "@RE 999,999,999.99"
	   @ Prow()+1,30   PSay Replicate("-",14)                           
	   @ Prow()+1,30   PSay nTotGPed-nTotRMA Picture "@RE 999,999,999.99"
   	   @ Prow()+1,05   PSay "Total Fatur vs Financ (-)"
	   @ Prow(),Pcol() PSay nTotFaFi        Picture "@RE 999,999,999.99"
	   @ Prow()+1,30   PSay Replicate("-",14)
	   @ Prow()+1,30   PSay nTotGPed-nTotRMA - nTotFaFi Picture "@RE 999,999,999.99"
	   @ Prow()+1,00     PSay Replicate("=",220)
	EndIf   
EndIf	

*/                         
	
Roda(cbcont,cbtxt,tamanho)
		
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	DbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATSQLCTT   ³Autor ³  Bruno Parreira      ³Data³ 20/06/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Select CTT                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

Static Function RFINSQLSE2()
	Local clAliasSql := GetNextAlias()  
	Local cBlq       := "" 
	
	BeginSql Alias clAliasSql    
   
  	  	SELECT E2_XCC, E2_FORNECE, E2_NOMFOR, E2_XDESCR, E2_EMISSAO, MAX(E2_VLRCON) AS E2_VLRCON, E2_NUM, 
  	  	E2_PARCELA, MAX(E2_VALOR) AS E2_VALOR, MAX(E5_DATA) AS E5_DATA, SUM(E5_VALOR) AS E5_VALOR, MAX(E2_SALDO) AS E2_SALDO, E2_VENCREA FROM %Table:SE2% SE2
   		LEFT OUTER JOIN %Table:SE5% SE5
   		ON E5_FILIAL = %EXP:xFilial('SE5')%
   		AND E5_PREFIXO = E2_PREFIXO
   		AND E5_NUMERO = E2_NUM
   		AND E5_PARCELA = E2_PARCELA
   		AND SE5.%NotDel%
   		WHERE E2_FILIAL = %EXP:xFilial('SE2')% 
   		AND E2_NATUREZ = '220204'
   		AND E2_SALDO > 0
   		AND SE2.%NotDel%
   		GROUP BY E2_FORNECE, E2_NOMFOR, E2_XDESCR, E2_XCC, E2_NUM, E2_PARCELA, E2_VENCREA, E2_EMISSAO
   		ORDER BY E2_NOMFOR, E2_XCC, E2_NUM, E2_PARCELA
	
	EndSql

Return(clAliasSql)  
      
