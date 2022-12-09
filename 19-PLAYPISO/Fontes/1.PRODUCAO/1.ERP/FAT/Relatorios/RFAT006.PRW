#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±     //
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT006   º Autor ³ Mauro Nagata       º Data ³  24/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Faturamento Direto                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda - Actual Trend                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFAT006()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatórios de Faturamento Direto"
//Local cPict         := ""
Local titulo        := "Relatórios de Faturamento Direto"
Local nLin          := 80
//          1         2         3         4         5         6         7         8         9        10         1         2         3         4         5         6         7         8         9        20       21        22
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234578901234567890
Local Cabec1         := "Obra       Pedido   Ped.Compras           Fatura/o.Realizado        Valor    Pedido em Aberto      Elim.por Residuo  Necess.  Emissao       Doc.     Emissao Produto Descricao                      Fornecedor"
Local Cabec2         := "           Compras  Valor        Qtde     Valor        Qtde         IPI      Valor        Qtde     Valor        Qtde Doc.Entr Doc.Entr   Entr/Serie  Pedido"

//Local imprime       := .T.
Private aOrd        := {"Obra"}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RFAT006" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RFAT006"
//Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFAT006" // nome do arquivo usado para impressao em disco
Private cArqTrab
Private cString     := "SC7"

AjustaSX1()

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If MV_PAR03 = 2
	Cabec1  := "Obra      Pedido   Ped.Compras             Fatura/o.Realizado      Pedido em Aberto        Elim.por Residuo "
	Cabec2  := "          Compras  Valor        Qtde       Valor        Qtde       Valor        Qtde       Valor        Qtde"
	limite  := 180
    tamanho := "M"
EndIf

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR03 == 1 //Analitico
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Else //Sintetico
	RptStatus({|| Run2Report(Cabec1,Cabec2,Titulo,nLin) },Titulo)
EndIf

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
              
Local cItemPC  := "" 
//Local cBlqObra := ""   
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
nTotLFD  := 0  //total do Limite do Faturamento Direto
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
						    //nTotPed   := TRB->TOTPED
						    //substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 15/07/2011]
							//nTotPed   := TRB->TOTPED+TRB->VALIPI             
							//substituida linha acima pela abaixo [Bruno Parreira, Actual Trend, 22/08/2011]
							nTotPed   := TRB->TOTPED + TRB->VALIPI + TRB->VALFREP + TRB->VALDESPP + TRB->VALSEGP - TRB->VALDESCP // Total Pedido + Vl IPI + Vl frete + Vl Despesas + Vl Seguro - Vl Desconto
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
						    //nVlrAbe := (TRB->QTPED-TRB->QENTR)*TRB->PRPED
						    //substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 15/07/2011]
							nVlrAbe := (TRB->QTPED-TRB->QENTR)*TRB->PRPED + Round((((TRB->QTPED-TRB->QENTR)/TRB->QTPED)*TRB->VALIPI),2)
							nQtdAbe := TRB->QTPED-TRB->QENTR
						EndIf	
						nTObVlrAb += nVlrAbe
						nTObQtdAb += nQtdAbe
						nTPVlrAb  += nVlrAbe
						nTPQtdAb  += nQtdAbe	
						
						nVlrRes := 0   //valor residual
						nQtdRes := 0   //quantidade residual
						If TRB->RESIDUO = "S"                             
						    //nVlrRes := (TRB->QTPED-TRB->QENTR)*TRB->PRPED                                 
						    //substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 15/07/2011]
							nVlrRes := (TRB->QTPED-TRB->QENTR)*TRB->PRPED + TRB->VALIPI
							nQtdRes := TRB->QTPED-TRB->QENTR
						EndIf
						nTObVlrRs += nVlrRes   //valor residual
						nTObQtdRs += nQtdRes
						nTPVlrRs  += nVlrRes
						nTPQtdRs  += nQtdRes	
					                                                                              
					    //nTotDoc  := TRB->TOTDOC                                                                                    
					    //substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 15/07/2011]
						//nTotDoc  := TRB->TOTDOC + Round(((TRB->QTDOC/TRB->QTPED)*TRB->VALIPI),2)       //total realizado                 
						//substituida linha acima pela abaixo [Bruno Parreira, Actual Trend, 22/08/2011]
						nTotDoc  := TRB->TOTDOC + TRB->VALIPI + TRB->VALFREN + TRB->VALDESPN + TRB->VALSEGN - TRB->VALDESCN       //total realizado
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
				*/   
				//substituido o bloco acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 29/06/2011]
				@ Prow()+1,00      PSay "Total          "
				@ Prow(),18        PSay nTObVlrPC Picture "@RE 999,999.99"
				//@ Prow(),Pcol()+01 PSay nTObQtdPC Picture "@RE 999,999.99"
				@ Prow(),Pcol()+12 PSay nTObVlrRe Picture "@RE 999,999.99"
				@ Prow(),Pcol()+12 PSay nTObVlIPI Picture "@RE 999,999.99"
				@ Prow(),Pcol()+01 PSay nTObVlrAb Picture "@RE 999,999.99"
				@ Prow(),Pcol()+12 PSay nTObVlrRs Picture "@RE 999,999.99"
				
			    @ Prow()+2,10      PSay Replicate("-",72)                                                                                                    
                @ Prow()+1,10      PSay "Demonstrativo de Calculo"                 
                @ Prow()+1,10      PSay Replicate("-",72)                                                                                                    
                
                @ Prow()+1,10      PSay "Total          (+)"
				//@ Prow(),28        PSay nTObVlrPC+nTObVlIPI  Picture "@RE 999,999.99" // Substituido pela linha abaixo sem somar IPI no valor total, pois ja esta somado. [Bruno Parreira, Actual Trend, 02/08/2011] 
				@ Prow(),28        PSay nTObVlrPC  Picture "@RE 999,999.99"
				@ Prow(),Pcol()+01 PSay nTObQtdPC  Picture "@RE 999,999.99"
				                        
				nColAux := Pcol()+5
				@ Prow(),nColAux  PSay "Limite FD      (+)"
				@ Prow(),Pcol()   PSay nVlrLim Picture "@RE 999,999.99"   
				                                                                      
				@ Prow()+1,10     PSay "Realiz.+Aberto (-)"
				@ Prow(),Pcol()   PSay nTObVlrRe+nTObVlrAb Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1 PSay nTObQtdRe+nTObQtdAb Picture "@RE 999,999.99"  
				@ Prow(),nColAux  PSay "Realiz.+Aberto (-)"
				@ Prow(),Pcol()   PSay nTObVlrRe+nTObVlrAb Picture "@RE 999,999.99"         

                @ Prow()+1,10     PSay "Resíduo        (-)"
				@ Prow(),Pcol()   PSay nTObVlrRs Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1 PSay nTObQtdRs Picture "@RE 999,999.99" 	
				@ Prow(),nColAux  PSay Space(16)+Replicate("-",12)
				
				@ Prow()+1,25     PSay Replicate("-",24)
				@ Prow(),nColAux  PSay "Diferenca      (=)"
				@ Prow(),Pcol()   PSay nVlrLim - (nTObVlrRe+nTObVlrAb) Picture "@RE 999,999.99"			
				
				@ Prow()+1,10     PSay "Diferenca      (=)"
				@ Prow(),Pcol()   PSay (nTObVlrPC-nTObVlrRs) - (nTObVlrRe+nTObVlrAb) Picture "@RE 999,999.99"
				@ Prow(),Pcol()+1 PSay (nTObQtdPC-nTObQtdRs) - (nTObQtdRe+nTObQtdAb)           Picture "@RE 999,999.99"

				@ Prow(),nColAux PSay "Fat.Dir.vs Fin (-)"
				@ Prow(),Pcol()    PSay nValPedV Picture "@RE 999,999.99"
				If nVlrLim - (nTObVlrRe+nTObVlrAb) != nValPedV
				   @ Prow(),Pcol()+1 PSay "(verificar)"
				EndIf   

				@ Prow()+1,10      PSay Replicate("-",72)                                                                                                    
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
	   	    @ Prow()+1,00   PSay Replicate("-",116)
			@ Prow()+1,10   PSay "Não existe movimentação para essa Obra "+iif(!empty(mv_par06),"em "+mv_par06+", conforme parâmetro Rel","")+"."
			
			@ Prow()+2,10   PSay Replicate("-",31)                                                                                                    
            @ Prow()+1,10   PSay "Demonstrativo de Calculo"                 
            @ Prow()+1,10   PSay Replicate("-",31)                                                                                                    
                
			@ Prow()+1,10   PSay "Limite Fat.Dir    (+)"
			@ Prow(),Pcol() PSay nVlrLim Picture "@RE 999,999.99"   
				                                                                      
			@ Prow()+1,10   PSay "Fat.Dir vs Financ.(-)"
			@ Prow(),Pcol() PSay nValPedV Picture "@RE 999,999.99"
			
  		    @ Prow()+1,12   PSay Space(16)+Replicate("-",13)    
  		    @ Prow()+1,31   PSay nVlrLim - nValPedV Picture "@RE 999,999.99"         
  		    
  		    @ Prow()+1,10   PSay Replicate("-",31)                                                                                                    

			@ Prow()+2,00   PSay Replicate("=",220)	
		EndIf	
		                                         
		nTotGPed += nTObVlrPC      
		nTotRMA  += nTObVlrRe+nTObVlrAb                 
		nTotLFD  += nVlrLim
		nTotFaFi += nValPedV
		
		DbSelectArea("TRB")
		TRB->(DbCloseArea())
		
		fErase(cArqTrab+GetDBExtension())
		fErase(cArqTrab+OrdBagExt()) 
		
		(clAliasCTT)->(DbSkip())
		 
	EndDo
  	If !lIp 
	   @ Prow()+1,10      PSay "Total Ger.Fatur.Direto(+)"
	   @ Prow(),Pcol()    PSay nTotGPed        Picture "@RE 999,999,999.99"
	   @ Prow(),Pcol()+05 PSay "Total Lim.Fatur.Direto  (+)"
	   @ Prow(),Pcol()    PSay nTotLFD        Picture "@RE 999,999,999.99"
	   @ Prow()+1,10      PSay "Total Realiz.+Aberto  (-)"
	   @ Prow(),Pcol()    PSay nTotRMA         Picture "@RE 999,999,999.99"
  	   @ Prow(),Pcol()+05 PSay "Total Realiz.+Aberto    (-)"
	   @ Prow(),Pcol()    PSay nTotRMA         Picture "@RE 999,999,999.99"
	   @ Prow()+1,35      PSay Replicate("-",14)                           
	   @ Prow(),Pcol()+32 PSay Replicate("-",14)                           
	   @ Prow()+1,35      PSay nTotGPed-nTotRMA Picture "@RE 999,999,999.99"	   
	   @ Prow(),Pcol()+32 PSay nTotLFD-nTotRMA Picture "@RE 999,999,999.99
   	   @ Prow()+1,54      PSay "Total Fat.Dir.vs Financ (-)"
	   @ Prow(),Pcol()    PSay nTotFaFi        Picture "@RE 999,999,999.99"
	   @ Prow()+1,81      PSay Replicate("-",14)
	   @ Prow()+1,81      PSay nTotLFD - nTotRMA - nTotFaFi Picture "@RE 999,999,999.99"
	   @ Prow()+1,00      PSay Replicate("=",220)
	EndIf   
EndIf	                         
	
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
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUN2REPORTº Autor ³ Mauro Nagata       º Data ³  24/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Run2Report(Cabec1,Cabec2,Titulo,nLin)
              
Local cItemPC  := "" 
//Local cBlqObra := ""   
Local nValPedV := 0
Private cCCusto  := ""
Private n_qtdpedc := 0
Private n_valpedc := 0
Private n_valfat := 0
Private n_pedaber := 0
Private n_elimres := 0
Private n_totais := 0
Private n_saldo := 0 
Private  n_totQtpc := 0       
Private  n_totVlpc := 0
Private  n_totVlim := 0
Private  n_totReAb := 0      
Private  n_totSald := 0
Private  n_totValp := 0
Private  n_totTofi := 0
Private nOrdem              

clAliasCTT := RFATSQLCTT()
 	
				//           1         2         3         4         5         6         7         8         9        10         1         2         3         4         5         6         7         8         9        20       21        22
				// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234578901234567890
Cabec1         := " Obra                                              Qtd Ped  Valor      (A) limite   (B)Total Real. (C)Saldo  (D)Total Fat.  Saldo final 
Cabec2         := "                                                   Compras  Ped Compra  Fat. Direto   + Abertos      (A-B)    por Financeiro  (C-D)
//                  9999999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999     9,999,999.99 9,999,999.99  9,999,999.99  9,999,999.99  9,999,999.99 9,999,999.99
a_pos 		   := {1,                                                  52, 56,          69,           83,         96,        108,        120     }
                                                                                                              
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
nTotLFD  := 0  //total do Limite do Faturamento Direto
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
						
		lPula := .T.  //Variavel para verificar se pula mais linhas na mudanca de pedidos. [Bruno Parreira, Actual Trend, 25/05/2011]
		n_qtdpedc := 0
		n_valpedc := 0 
		n_valfat  := 0
		n_pedaber := 0
		n_elimres := 0
        n_totais  := 0
        n_saldo  := 0                   
       	cCCusto := (clAliasCTT)->CTT_CUSTO

		ArqTrb(cCCusto)
		 
		DbSelectArea("TRB")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		If TRB->(!EOF())
		    
			clAliasSC5 := RFATSQLSC5()
 	
			DbSelectArea(clAliasSC5)
			(clAliasSC5)->(DbGoTop())
		    
			if (clAliasSC5)->(!EOF())
				nValPedV := (clAliasSC5)->C5_XSDFATD
			EndIf	
		                       
		    DbSelectArea("TRB")                                            
		    
			Do While !Eof()
				
				DbSelectArea("TRB")
				Do While !Eof().And.TRB->OBRA = cObra
					
					cNumPed := TRB->NUMPED   
					cItemPC := AllTrim(TRB->ITEMPED)  
					cCodFor := TRB->FORNEC
					cNomFor := GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+cCodFor,1,"Não Encontrado")
					
					n_qtdpedc++
					
					lPula := .F.	                                                                                                             
					n_saldo  := 0
					n_totais := 0
					nTPVlrRe := 0
					nTPQtdRe := 0
					nTPVlrAb := 0
					nTPQtdAb := 0
					nTPVlrRs := 0
					nTPQtdRs := 0                         
					lIpPed   := .F. 
					lItFirst := .T.      // Variavel para verificar primeiro Item. [Bruno Parreira, Actual Trend, 25/05/2011]
					
					Do While !Eof().And.TRB->NUMPED = cNumPed
						
					 	If cItemPC <> AllTrim(TRB->ITEMPED) .Or. lItFirst
							lItPas := .T.
						else
							lItPas := .F.
						EndIf 
						
						lItFirst := .F.
						
						cItemPC := AllTrim(TRB->ITEMPED)		
						
						if lItPas                                
							nTotPed   := TRB->TOTPED + TRB->VALIPI + TRB->VALFREP + TRB->VALDESPP + TRB->VALSEGP - TRB->VALDESCP // Total Pedido + Vl IPI + Vl frete + Vl Despesas + Vl Seguro - Vl Desconto
							nQtPed    := TRB->QTPED
							nTObVlrPC += nTotPed
							nTObQtdPC += nQtPed
							nTPVlrPC  += nTotPed
							nTPQtdPC  += nQtPed 
						EndIf    
						
						nVlrAbe := 0  //valor em aberto
						nQtdAbe := 0  //quantidade em aberto
						If TRB->QTPED-TRB->QENTR != 0.And.TRB->RESIDUO != "S"                                               
							nVlrAbe := (TRB->QTPED-TRB->QENTR)*TRB->PRPED + TRB->VALIPI
							nQtdAbe := TRB->QTPED-TRB->QENTR
						EndIf	
						nTObVlrAb += nVlrAbe
						nTObQtdAb += nQtdAbe
						nTPVlrAb  += nVlrAbe
						nTPQtdAb  += nQtdAbe	
						
						nVlrRes := 0   //valor residual
						nQtdRes := 0   //quantidade residual
						If TRB->RESIDUO = "S"                             
							nVlrRes := (TRB->QTPED-TRB->QENTR)*TRB->PRPED + TRB->VALIPI
							nQtdRes := TRB->QTPED-TRB->QENTR
						EndIf
						nTObVlrRs += nVlrRes   //valor residual
						nTObQtdRs += nQtdRes
						nTPVlrRs  += nVlrRes
						nTPQtdRs  += nQtdRes	
					                                                                              
						nTotDoc  := TRB->TOTDOC + TRB->VALIPI + TRB->VALFREN + TRB->VALDESPN + TRB->VALSEGN - TRB->VALDESCN       //total realizado
						nQtDoc   := TRB->QTDOC   
						nTotIPI  := TRB->VALIPI
						nTObVlrRe += nTotDoc
						nTObQtdRe += nQtDoc
						nTPVlrRe  += nTotDoc
						nTPQtdRe  += nQtDoc 
						nTObVlIPI += nTotIPI
						
						lIpPed := .T.
						DbSelectArea("TRB")
					    DbSkip()
					EndDo         
				EndDo      
				
				n_elimres += nTObVlrRs


			EndDo  
		else       
			clAliasSC5 := RFATSQLSC5()
 	
			DbSelectArea(clAliasSC5)
			(clAliasSC5)->(DbGoTop())
		    
			if (clAliasSC5)->(!EOF())
				nValPedV := (clAliasSC5)->C5_XSDFATD
			EndIf	
		EndIf	
   		//           1         2         3         4         5         6         7         8         9        10         1         2         3         4         5         6         7         8         9        20       21        22
         n_saldo  := nVlrLim - (nTObVlrRe+nTObVlrAb)                                                                                                                                                             
         n_totais := n_saldo - nValPedV

		                       		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verificacao para não mostrar obras antigas que não tem movimentos a mais de um ano                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		l_mostractt := .T.
		l_dtok := .F.          
		//solicitado pela Izabel que limitasse as informacoes mesmo que existissem saldo de pedido de compras
		//com mais de um dois em aberto. Ate entao estava limitado a um ano. [Mauro Nagata, Actual Trend, 20140902]         
		//c_dtcomp := strzero(val(subStr(dtos(dDataBase),1,4))-1,4)+subStr(dtos(dDataBase),5,4)
		c_dtcomp := strzero(val(subStr(dtos(dDataBase),1,4))-2,4)+subStr(dtos(dDataBase),5,4)
		If (clAliasCTT)->CTT_XDTINC < c_dtcomp
			DbSelectArea('TRB')
			DbGotop()
			While TRB->(!EOF())
				If TRB->EMISPED > STOD(c_dtcomp)
					l_dtok := .T.
				EndIf
				TRB->(DbSkip())
			EndDo
			If !l_dtok
				l_mostractt := .F.
			EndIf
		EndIf
                  
		If !(MV_PAR05 == 2 .and. n_totais <= 0) .and. l_mostractt       
			@ Prow()+1,a_pos[1] PSay pad(cObra, 10) + '-'+substr(cDescObra, 1, 40)
			@ Prow(),a_pos[02]   PSay transform(n_qtdpedc,"@E 999")	  
			@ Prow(),a_pos[03]   PSay transform(nTObVlrPC,"@E 9,999,999.99")
			@ Prow(),a_pos[04]   PSay transform(nVlrLim,"@E 9,999,999.99")	
			@ Prow(),a_pos[05]   PSay transform(nTObVlrRe+nTObVlrAb,"@E 9,999,999.99")	
			@ Prow(),a_pos[06]   PSay transform(n_saldo,"@E 9,999,999.99")	
			@ Prow(),a_pos[07]   PSay transform(nValPedV,"@E 9,999,999.99")	
			@ Prow(),a_pos[08]   PSay transform(n_totais,"@E 9,999,999.99")	   

			n_totQtpc += n_qtdpedc //total qtd pedido compra
			n_totVlpc += nTObVlrPC  //total valor pedido compra
			n_totVlim += nVlrLim    //total valor do limite fat direto
			n_totReAb += nTObVlrRe+nTObVlrAb // total realizado + aberto
			n_totSald += n_saldo    //total saldo de (a-b) 
			n_totValp += nValPedV   // total faturado pelo financeiro
			n_totTofi += n_totais  // total saldo fina (c-d)
	
		EndIf
	    
		DbSelectArea("TRB")
		TRB->(DbCloseArea())
		
		fErase(cArqTrab+GetDBExtension())
		fErase(cArqTrab+OrdBagExt()) 
		(clAliasCTT)->(DbSkip())
	EndDo 
	@ Prow()+1,00       PSay Replicate("-",134)
	                                                                        //imprimi as linhas
	@ Prow()+1,a_pos[02]  PSay transform(n_totQtpc,"@E 999")	//quantid total pedido de compra
	@ Prow()  ,a_pos[03]   PSay transform(n_totVlpc,"@E 9,999,999.99") // quant total valor de pedido de compra	
	@ Prow()  ,a_pos[04]   PSay transform(n_totVlim,"@E 9,999,999.99")	// quant total do limite do pedido de compra (a)
	@ Prow()  ,a_pos[05]   PSay transform(n_totReAb,"@E 9,999,999.99")	// quant total dos ped realiz e abertos   (b)
	@ Prow()  ,a_pos[06]   PSay transform(n_totSald,"@E 9,999,999.99")	// quant (c)total saldo  (a-b)
	@ Prow()  ,a_pos[07]   PSay transform(n_totValp,"@E 9,999,999.99")	// quant total valor faturado pelo financeiro(d) 
	@ Prow()  ,a_pos[08]   PSay transform(n_totTofi,"@E 9,999,999.99") // total saldo final (c-d)
	
EndIf	                         
	                       


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
           



Static Function ARQTRB(cCodObra)
Local aCampos    := {}
//Local dDtIncl
//Local cUsuario
Local nX := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aTam:=TamSX3("C7_EMISSAO")
aAdd(aCampos,{ "EMISPED"    ,"D",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_NUM")
aAdd(aCampos,{ "NUMPED"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_ITEM")
aAdd(aCampos,{ "ITEMPED"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_PRODUTO")
aAdd(aCampos,{ "PRODUTO"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_XCCFTD")
aAdd(aCampos,{ "OBRA"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_QUANT")
aAdd(aCampos,{ "QTPED"    ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_PRECO")
aAdd(aCampos,{ "PRPED"    ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_TOTAL")
aAdd(aCampos,{ "TOTPED"    ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_QUJE") 
//aTam:=TamSX3("D1_QUANT")
aAdd(aCampos,{ "QENTR"    ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_RESIDUO")
aAdd(aCampos,{ "RESIDUO"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_DATPRF")
aAdd(aCampos,{ "NECESS"    ,"D",aTam[1],aTam[2] } )

aTam:=TamSX3("D1_EMISSAO")
aAdd(aCampos,{ "EMISDOC"    ,"D",aTam[1],aTam[2] } )

aTam:=TamSX3("D1_DOC")
aAdd(aCampos,{ "DOC"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("D1_SERIE")
aAdd(aCampos,{ "SERIE"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("D1_QUANT")
aAdd(aCampos,{ "QTDOC"    ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("D1_VUNIT")
aAdd(aCampos,{ "PRDOC"    ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("D1_TOTAL")
aAdd(aCampos,{ "TOTDOC"    ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_VALIPI")
aAdd(aCampos,{ "VALIPI"    ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("B1_DESC")
aAdd(aCampos,{ "DESCPRD"    ,"C",aTam[1],aTam[2] } ) 

//Inicio - Incluido campos para serem criado na tabela temp. TRB. [Bruno Parreira, Actual Trend, 25/05/2011]

aTam:=TamSX3("CTT_DESC01")
aAdd(aCampos,{ "DESCOBR"    ,"C",aTam[1],aTam[2] } )   

aTam:=TamSX3("CTT_XFATD")
aAdd(aCampos,{ "LIMFATDIR"  ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_FORNECE")
aAdd(aCampos,{ "FORNEC"  ,"C",aTam[1],aTam[2] } )    

//Fim - [Bruno Parreira, Actual Trend, 25/05/2011]

//Incluido Bloco para criar campos de desconto, frete, despesas e seguro do pedido de nota  [Bruno Parreira, Actual Trend, 22/08/2011] 
                                                 
aTam:=TamSX3("D1_VALDESC")
aAdd(aCampos,{ "VALDESCN","N",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_VLDESC")
aAdd(aCampos,{ "VALDESCP","N",aTam[1],aTam[2] } ) 

aTam:=TamSX3("C7_VALFRE")
aAdd(aCampos,{ "VALFREP","N",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_DESPESA")                         
aAdd(aCampos,{ "VALDESPP","N",aTam[1],aTam[2] } )

aTam:=TamSX3("C7_SEGURO")
aAdd(aCampos,{ "VALSEGP","N",aTam[1],aTam[2] } )

aTam:=TamSX3("D1_VALFRE")
aAdd(aCampos,{ "VALFREN","N",aTam[1],aTam[2] } )

aTam:=TamSX3("D1_DESPESA")
aAdd(aCampos,{ "VALDESPN","N",aTam[1],aTam[2] } )

aTam:=TamSX3("D1_SEGURO")
aAdd(aCampos,{ "VALSEGN","N",aTam[1],aTam[2] } )

// Fim Bloco


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

nOrdem  := aReturn[8]   //qual ordem foi escolhida

cOrdem := "OBRA+NUMPED+ITEMPED+DOC+SERIE"

DbSelectArea("TRB")
IndRegua("TRB",cArqTrab,cOrdem,,,"Ordenando os Registros...")

DbSelectArea("TRB")
DbSetOrder(1)
DbGoTop()

cAliasSC7 := "RF006TRB"
aStruSC7  := SC7->(dbStruct())    

cQuery :=	 " SELECT C7_XCCFTD, CTT_DESC01, CTT_XFATD, C7_EMISSAO, C7_NUM, C7_ITEM, C7_PRODUTO, C7_QUANT, C7_TOTAL, C7_QUJE, C7_RESIDUO, C7_FORNECE, "
//cQuery += CRLF + " C7_DATPRF, C7_PRECO, D1_EMISSAO, D1_DOC, D1_SERIE, D1_QUANT, D1_TOTAL, D1_VALIPI, B1_DESC "
//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 15/07/2011]
cQuery += CRLF + " C7_DATPRF, C7_PRECO, D1_EMISSAO, D1_DOC, D1_SERIE, D1_QUANT, D1_TOTAL, C7_VALIPI, B1_DESC, D1_VALDESC, C7_VLDESC, D1_VALFRE, D1_DESPESA, D1_SEGURO, C7_VALFRE, C7_DESPESA, C7_SEGURO "
cQuery += CRLF + " FROM "+ RetSQLName( "SC7" ) +" C7 "

cQuery += CRLF + " LEFT OUTER JOIN "+ RetSQLName( "SD1" ) +" D1 "
cQuery += CRLF + "      ON     D1.D_E_L_E_T_='' "
cQuery += CRLF + "         AND D1_PEDIDO = C7_NUM "
cQuery += CRLF + "         AND D1_ITEMPC = C7_ITEM "
cQuery += CRLF + "         AND D1_COD    = C7_PRODUTO "
cQuery += CRLF + "         AND D1_TES    <> '' "

cQuery += CRLF + " INNER JOIN "+ RetSQLName( "SB1" ) +" B1 "
cQuery += CRLF + "       ON     B1.D_E_L_E_T_='' "                    
//incluida a linha abaixo [Mauro Nagata, Actual Trend, 16/07/2013]
cQuery += CRLF + "          AND B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += CRLF + "          AND B1_COD = C7_PRODUTO "    

//Inicio - Incluido INNER JOIN com CTT para trazer informacoes da OBRA com faturamento direto e filtrar CC bloqueados. [Bruno Parreira, Actual Trend, 25/05/2011]     

cQuery += CRLF + " INNER JOIN "+ RetSQLName( "CTT" ) +" CTT "
cQuery += CRLF + "       ON     CTT.D_E_L_E_T_='' "
cQuery += CRLF + "          AND CTT_XLFATD = 'S' "
cQuery += CRLF + "          AND CTT_CUSTO = C7_XCCFTD "

If MV_PAR04 == 2                                    
	cQuery += CRLF + " AND CTT_MSBLQL = '2' "
EndIf                                                

//Fim - [Bruno Parreira, Actual Trend, 25/05/2011]

cQuery += CRLF + " WHERE C7_XCCFTD = '"+cCodObra+"'"//BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "

if !empty(MV_PAR06)
   cQuery += CRLF + " AND SUBSTRING(C7_EMISSAO,1,4) = '"+MV_PAR06+"'"
endif

cQuery += CRLF + " AND C7_XCCFTD <> '' "    
cQuery += CRLF + " AND C7_XFATD = 'S' " //Incluido para trazer somente pedidos de faturamento direto. [Bruno Parreira, Actual Trend, 25/05/2011]
cQuery += CRLF + " AND C7.D_E_L_E_T_ = '' "
cQuery += CRLF + " ORDER BY C7_XCCFTD, C7_NUM, C7_ITEM, D1_DOC, D1_SERIE "
    
Memowrite("RFAT006.SQL",cQuery)    

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)

For nX := 1 To Len(aStruSC7)
	If ( aStruSC7[nX][2] <> "C" )
		TcSetField(cAliasSC7,aStruSC7[nX][1],aStruSC7[nX][2],aStruSC7[nX][3],aStruSC7[nX][4])
	EndIf
Next nX

TcSetField(cAliasSC7,"D1_EMISSAO","D",8,0)
TcSetField(cAliasSC7,"D1_QUANT","N",11,2)
//incluida a linha abaixo [Mauro Nagata, Actual Trend, 15/07/2011]
TcSetField(cAliasSC7,"C7_QUANT","N",11,2)
TcSetField(cAliasSC7,"D1_VUNIT","N",11,2)
TcSetField(cAliasSC7,"D1_TOTAL","N",14,2)
//TcSetField(cAliasSC7,"D1_VALIPI","N",14,2)    
//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 15/07/2011]
TcSetField(cAliasSC7,"C7_VALIPI","N",14,2)    
TcSetField(cAliasSC7,"C7_FORNECE","C",6,0)

SetRegua(-1)

DbSelectArea(cAliasSC7)
DbGoTop()
Do While !Eof()
	
	IncRegua()
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	
	TRB->EMISPED  := (cAliasSC7)->C7_EMISSAO
	TRB->NUMPED   := (cAliasSC7)->C7_NUM
	TRB->ITEMPED  := (cAliasSC7)->C7_ITEM
	TRB->QTPED    := (cAliasSC7)->C7_QUANT
	TRB->PRODUTO  := (cAliasSC7)->C7_PRODUTO
	TRB->OBRA     := (cAliasSC7)->C7_XCCFTD
	TRB->TOTPED   := (cAliasSC7)->C7_TOTAL
	TRB->QENTR    := (cAliasSC7)->C7_QUJE
	//TRB->QENTR    := (cAliasSC7)->D1_QUANT
	TRB->RESIDUO  := (cAliasSC7)->C7_RESIDUO
	TRB->NECESS   := (cAliasSC7)->C7_DATPRF
	TRB->EMISDOC  := (cAliasSC7)->D1_EMISSAO
	TRB->DOC      := (cAliasSC7)->D1_DOC       //documento de entrada
	TRB->SERIE    := (cAliasSC7)->D1_SERIE     //serie do documento de entrada
	TRB->QTDOC    := (cAliasSC7)->D1_QUANT
	//TRB->VALIPI   := (cAliasSC7)->D1_VALIPI
	//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 15/07/2011]
	TRB->VALIPI   := (cAliasSC7)->C7_VALIPI * ((cAliasSC7)->D1_QUANT/(cAliasSC7)->C7_QUANT)
	TRB->DESCPRD  := (cAliasSC7)->B1_DESC
	TRB->TOTDOC   := (cAliasSC7)->D1_TOTAL
	TRB->QTDOC    := (cAliasSC7)->D1_QUANT
	TRB->PRPED    := (cAliasSC7)->C7_PRECO   
	//Incluido Bloco abaixo para atribuir valor aos campos da TRB. [Bruno Parreira, Actual Trend, 25/05/2011]
	TRB->DESCOBR  := (cAliasSC7)->CTT_DESC01
	TRB->LIMFATDIR:= (cAliasSC7)->CTT_XFATD 
	TRB->FORNEC   := (cAliasSC7)->C7_FORNECE 
	//Fim Bloco                               
	//Incluido bloco abaixo para tratar valores de desconto, frete, despesa e seguro [Bruno Parreira, Actual Trend, 22/08/2011] 
	TRB->VALDESCN := (cAliasSC7)->D1_VALDESC
	TRB->VALDESCP := (cAliasSC7)->C7_VLDESC   
	TRB->VALFREP  := (cAliasSC7)->C7_VALFRE
	TRB->VALDESPP := (cAliasSC7)->C7_DESPESA
	TRB->VALSEGP  := (cAliasSC7)->C7_SEGURO
	TRB->VALFREN  := (cAliasSC7)->D1_VALFRE
	TRB->VALDESPN := (cAliasSC7)->D1_DESPESA
	TRB->VALSEGN  := (cAliasSC7)->D1_SEGURO         
	//Fim Bloco
	
	DbSelectArea(cAliasSC7)
	DbSkip()
EndDo

(cAliasSC7)->(DbCloseArea())

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

Static Function RFATSQLCTT()
	Local clAliasSql := GetNextAlias()  
	Local cBlq       := "" 
	
	If MV_PAR04 == 2                                    
		cBlq := '2'			       
  
		BeginSql Alias clAliasSql    
	   
	  		SELECT CTT_CUSTO, CTT_DESC01, CTT_XFATD, CTT_XDTINC FROM CTT010 CTT
   			WHERE CTT_CUSTO BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% 
   			AND CTT_XLFATD = 'S' 
   			AND CTT_MSBLQL = %EXP:cBlq%    	
   			AND %NotDel%
   			ORDER BY CTT_CUSTO
		
		EndSql
	
	else 
	
		BeginSql Alias clAliasSql    
	   
	  		SELECT CTT_CUSTO, CTT_DESC01, CTT_XFATD, CTT_XDTINC FROM CTT010 CTT
   			WHERE CTT_CUSTO BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% 
   			AND CTT_XLFATD = 'S'   	
   			AND %NotDel%
   			ORDER BY CTT_CUSTO
		
		EndSql  
	
	EndIf	

Return(clAliasSql)  
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATSQLSC5   ³Autor ³  Bruno Parreira      ³Data³ 27/06/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Select SC5                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/     

Static Function RFATSQLSC5()
	Local clAliasSql := GetNextAlias()  

	BeginSql Alias clAliasSql    
   
  		SELECT  SUM(C5_XSDFATD) AS C5_XSDFATD FROM SC5010 SC5     //Modificado para somar pedidos com saldo de faturamento direto - luiz henrique 07/11/2012
   			WHERE C5_CCUSTO = %EXP:cCCusto%
   			AND C5_XSDFATD <> 0 	
   			AND %NotDel%
   			GROUP BY  C5_CCUSTO
	
	EndSql

Return(clAliasSql)  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Mauro Nagata        ³Data³ 24/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()

Local cAlias := Alias(), aPerg := {}
Local nI, nPerg

Aadd(aPerg, {"01","Da Obra          ?" ,"?","?","mv_ch1","C",9,"G","mv_par01","","","","","","","",0,"CTT"})
Aadd(aPerg, {"02","Ate a Obra       ?" ,"?","?","mv_ch2","C",9,"G","mv_par02","","","","","","","",0,"CTT"})
Aadd(aPerg, {"03","Tipo             ?" ,"?","?","mv_ch3","N",1,"C","mv_par03","Analitico","Analitico","Analitico","","Sintetico","Sintetico","Sintetico",0,""}) 
Aadd(aPerg, {"04","Cons. Bloq.      ?" ,"?","?","mv_ch4","N",1,"C","mv_par04","Sim","Sim","Sim","","Nao","Nao","Nao",0,""})
Aadd(aPerg, {"05","Mostra Saldo Zero?" ,"?","?","mv_ch5","N",1,"C","mv_par05","Sim","Sim","Sim","","Nao","Nao","Nao",0,""})
Aadd(aPerg, {"06","Ano              ?" ,"?","?","mv_ch6","C",4,"G","mv_par06","","","","","","","",0,""})

nPerg := Len(aPerg)

DbSelectArea("SX1")
DbSetOrder(1)
For nI := 1 To nPerg
	If !DbSeek(Pad(cPerg,10)+aPerg[nI,1])
		RecLock("SX1",.T.)
		Replace X1_GRUPO	With cPerg                                                                 
		
		Replace X1_ORDEM	With aPerg[nI,01]
		Replace X1_PERGUNT	With aPerg[nI,02]
		Replace X1_PERSPA	With aPerg[nI,03]
		Replace X1_PERENG	With aPerg[nI,04]
		Replace X1_VARIAVL	With aPerg[nI,05]
		Replace X1_TIPO		With aPerg[nI,06]
		Replace X1_TAMANHO	With aPerg[nI,07]
		Replace X1_GSC		With aPerg[nI,08]
		Replace X1_VAR01	With aPerg[nI,09]
		Replace X1_DEF01	With aPerg[nI,10]
		Replace X1_DEFSPA1	With aPerg[nI,11]
		Replace X1_DEFENG1	With aPerg[nI,12]
		Replace X1_CNT01	With aPerg[nI,13]
		Replace X1_DEF02	With aPerg[nI,14]
		Replace X1_DEFSPA2	With aPerg[nI,15]
		Replace X1_DEFENG2	With aPerg[nI,16]
		Replace X1_PRESEL 	With aPerg[nI,17]
		Replace X1_F3    	With aPerg[nI,18]
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe de qual obra")
		aAdd(aHelpSpa,"Informe de qual obra")
		aAdd(aHelpEng,"Informe de qual obra")
		PutSX1Help("P.RFAT00601.",aHelpPor,aHelpEng,aHelpSpa)
		
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe ate que obra")
		aAdd(aHelpSpa,"Informe ate que obra")
		aAdd(aHelpEng,"Informe ate que obra")
		PutSX1Help("P.RFAT00602.",aHelpPor,aHelpEng,aHelpSpa)
		
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe o tipo do relatorio Sint ou Ana-")
		aAdd(aHelpPor,"litico")
		aAdd(aHelpSpa,"Informe o tipo do relatorio Sint ou Ana-")
		aAdd(aHelpSpa,"litico")
		aAdd(aHelpEng,"Informe o tipo do relatorio Sint ou Ana-")
		aAdd(aHelpEng,"litico")
		PutSX1Help("P.RFAT00603.",aHelpPor,aHelpEng,aHelpSpa) 
		
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Considera Obras Bloqueadas")
		aAdd(aHelpSpa,"Considera Obras Bloqueadas")
		aAdd(aHelpEng,"Considera Obras Bloqueadas")
		PutSX1Help("P.RFAT00604.",aHelpPor,aHelpEng,aHelpSpa)

		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Mostra Saldo Zero, Sim ou Não")
		aAdd(aHelpSpa,"Mostra Saldo Zero, Sim ou Não")
		aAdd(aHelpEng,"Mostra Saldo Zero, Sim ou Não")
		PutSX1Help("P.RFAT00605.",aHelpPor,aHelpEng,aHelpSpa)

		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Qual ano considerar?")
		aAdd(aHelpSpa,"Qual ano considerar?")
		aAdd(aHelpEng,"Qual ano considerar?")
		PutSX1Help("P.RFAT00606.",aHelpPor,aHelpEng,aHelpSpa)
		
		MsUnlock()
	EndIf
Next

DbSelectArea(cAlias)

Return
