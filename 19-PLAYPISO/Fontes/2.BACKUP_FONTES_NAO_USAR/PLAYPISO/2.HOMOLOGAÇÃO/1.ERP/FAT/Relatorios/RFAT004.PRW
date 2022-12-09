#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TOPCONN.CH"    
            
#define DMPAPER_LETTER    1  // Letter 8 1/2 x 11 in
#define DMPAPER_LETTERSMALL  2   // Letter Small 8 1/2 x 11 in
#define DMPAPER_TABLOID   3 // Tabloid 11 x 17 in
#define DMPAPER_LEDGER   4 // Ledger 17 x 11 in                                          
#define DMPAPER_LEGAL   5 // Legal 8 1/2 x 14 in
#define DMPAPER_EXECUTIVE  7 // Executive 7 1/4 x 10 1/2 in                                                	
#define DMPAPER_A3    8 // A3 297 x 420 mm
#define DMPAPER_A4    9 // A4 210 x 297 mm
#define DMPAPER_A4SMALL   10 // A4 Small 210 x 297 mm
#define DMPAPER_A5    11 // A5 148 x 210 mm
#define DMPAPER_B4    12 // B4 250 x 354
#define DMPAPER_B5    13 // B5 182 x 257 mm
#define DMPAPER_FOLIO   14 // Folio 8 1/2 x 13 in
#define DMPAPER_NOTE   18 // Note 8 1/2 x 11 in
#define DMPAPER_ENV_10   20 // Envelope #10 4 1/8 x 9 1/2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT004   ºAutor  ³Bruno S. Parreira   º Data ³  25/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de pedidos de venda                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico LISONDA                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFAT004()
	Local clDesc1 	:= "Relatório para impressão dos pedidos de venda"
	Local clDesc2 	:= ""
	Local clDesc3 	:= ""
	Local clString	:= "CTT"     

	Private cpTamanho	:= "P"

	Private cpTitulo  := "Saldos a Faturar"
	         
	Private cpProgram := "RFAT004"

	Private aOrd      := {}

	Private opFont08  := TFont():New( "Tahoma",,08,,.F.,,,,,.F.) 
	Private opFont08n := TFont():New( "Tahoma",,08,,.T.,,,,,.F.)
	Private opFont10  := TFont():New( "Tahoma",,10,,.F.,,,,,.F.)
	Private opFont10n := TFont():New( "Tahoma",,10,,.T.,,,,,.F.)	
	Private opFont12  := TFont():New( "Tahoma",,12,,.F.,,,,,.F.) 
	Private opFont12n := TFont():New( "Tahoma",,12,,.T.,,,,,.F.)
	Private opFont14n := TFont():New( "Tahoma",,14,,.T.,,,,,.F.)
	Private opFont15  := TFont():New( "Tahoma",,15,,.F.,,,,,.F.)
	Private opFont17n := TFont():New( "Tahoma",,17,,.T.,,,,,.F.)     
		
	Private aReturn := {"Zebrado",1,"Administracao", 2, 2, 1, "",0 }   

	Private li		:= 80, limite:=132, lRodape:=.F.           

	Private nLin 	 := 100
	Private	nfim     := 2300//3300    
	Private nCol 	 := 50
	Private nPula 	 := 50
//	Private	aCols    := {300,450,1200,1450,1570}
//	Private aColOb   := {90,180,500,620}    
//	Private aColPd   := {200,350,500,800,1000,1150,1300,1450}     
	
	Private	aColTit  := {490,850,1400,1630}
	Private	aColIPd  := {520,650,1380,1700,1820,1950}
	Private aColOb   := {290,380,700,820}    
	Private aColPd   := {400,520,650,900,1110,1290,1460,1630} 
	Private aGrade   := {2.1*(nfim-(50))/10,;
						 2.7*(nfim-(50))/10,;
						 5.9*(nfim-(50))/10,;
						 7.1*(nfim-(50))/10,;
						 8.5*(nfim-(50))/10}
	
	Private n_cont   := 0     
	
	Private cpObra   := ""
	Private cpPed    := "" 
	Private cpIPed   := "" 
	Private vTotPed  := 0 
	Private vTotG    := 0
	
	Private cpVazio  := ""
	
	Private cpPerg    := "RFAT004"  
	
	oprn := TMSPrinter():New(cpTitulo)   
	
	nCor1:=RGB(180,180,180)       
	nCor2:=RGB(210,210,210)
	oBrush1 := TBrush():New("",nCor1)
	oBrush2 := TBrush():New("",nCor2)
	
	oprn:SetPortrait()  
	oprn:setPaperSize(DMPAPER_A4)   
	
	cpPerg := PADR(cpPerg,10)
	
	AjustaSX1(cpPerg)         
	
	pergunte(cpPerg,.F.)
	
	wnrel:=SetPrint(clString,cpProgram,cpPerg,@cpTitulo,clDesc1,clDesc2,clDesc3,.F.,aOrd,.F.,cpTamanho) 
	
	If nLastKey == 27
 		Return
 	Endif 
 	                                                            
	SetDefault(aReturn,clString)
	
	If nLastKey == 27
 		Return
 	Endif 
 	
 	//if !oprn:Setup()
  	//	Return	
  	//EndIf
	
	Processa({||ImpRel()}, cpTitulo, "Gerando Relatório, aguarde...") 
     
  	If ( aReturn[5] == 1 ) //1-Disco, 2-Impressora  
		oPrn:Preview()
	Else           
		oPrn:Print() 
		MS_FLUSH()
	EndIf
	
Return	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Função para ajustar o SX1. PERGUNTAS.                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

Static function AjustaSX1(clPerg)

   	Local aAreaAtu	:= GetArea()
	Local aAreaSX1	:= SX1->(GetArea())
	Local aHelp		:= {}                             
	Local clTamSX1	:= Len(SX1->X1_GRUPO)
	Local clPesPerg	:= ""    
                                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define os títulos e Help das perguntas                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aAdd(aHelp,{{"Obra Inicial"	  	," "," "},{""},{""}})
	aAdd(aHelp,{{"Obra Final"	  	," "," "},{""},{""}}) 
	aAdd(aHelp,{{"Pedido Inicial"	," "," "},{""},{""}})
	aAdd(aHelp,{{"Pedido Final"	 	," "," "},{""},{""}})
	aAdd(aHelp,{{"Cliente Inicial"	," "," "},{""},{""}})
	aAdd(aHelp,{{"Cliente Final" 	," "," "},{""},{""}}) 
	aAdd(aHelp,{{"Filial Inicial"	," "," "},{""},{""}})
	aAdd(aHelp,{{"Filial Final" 	," "," "},{""},{""}}) 
	aAdd(aHelp,{{"Condição de Faturamento" 	," "," "},{""},{""}})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava as perguntas no arquivo SX1                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                                      
	PutSx1(clPerg,"01","De Obra?"  		,"De Obra?"   	,"De Obra?"    	,"mv_ch1" ,"C",9 ,0,,"G","","",,"","mv_par01","","","","","","","","","","","","","","","","",aHelp[01,1],aHelp[01,2],aHelp[01,3],"")
	PutSx1(clPerg,"02","Ate Obra?"   	,"Ate Obra?"   	,"Ate Obra?"   	,"mv_ch2" ,"C",9 ,0,,"G","","",,"","mv_par02","","","","","","","","","","","","","","","","",aHelp[02,1],aHelp[02,2],aHelp[02,3],"")
	PutSx1(clPerg,"03","De Pedido?"   	,"De Pedido?"  	,"De Pedido?"  	,"mv_ch3" ,"C",6 ,0,,"G","","",,"","mv_par03","","","","","","","","","","","","","","","","",aHelp[03,1],aHelp[03,2],aHelp[03,3],"")
	PutSx1(clPerg,"04","Ate Pedido?"   	,"Ate Pedido?" 	,"Ate Pedido?" 	,"mv_ch4" ,"C",6 ,0,,"G","","",,"","mv_par04","","","","","","","","","","","","","","","","",aHelp[04,1],aHelp[04,2],aHelp[04,3],"")
	PutSx1(clPerg,"05","De Cliente?"   	,"De Cliente?" 	,"De Cliente?" 	,"mv_ch5" ,"C",6 ,0,,"G","","",,"","mv_par05","","","","","","","","","","","","","","","","",aHelp[05,1],aHelp[05,2],aHelp[05,3],"")
	PutSx1(clPerg,"06","Ate Cliente?"  	,"Ate Cliente?"	,"Ate Cliente?"	,"mv_ch6" ,"C",6 ,0,,"G","","",,"","mv_par06","","","","","","","","","","","","","","","","",aHelp[06,1],aHelp[06,2],aHelp[06,3],"")
	PutSx1(clPerg,"07","De Filial?"   	,"De Filial?"	,"De Filial?"	,"mv_ch7" ,"C",6 ,0,,"G","","",,"","mv_par07","","","","","","","","","","","","","","","","",aHelp[07,1],aHelp[07,2],aHelp[07,3],"")
	PutSx1(clPerg,"08","Ate Filial?"   	,"Ate Filial?"	,"Ate Filial?"	,"mv_ch8" ,"C",6 ,0,,"G","","",,"","mv_par08","","","","","","","","","","","","","","","","",aHelp[08,1],aHelp[08,2],aHelp[08,3],"")
	PutSx1(clPerg,"09","Cond. Fat.?"   	,"Cond. Fat.?"	,"Cond. Fat.?"	,"mv_ch9" ,"N",1 ,0,,"C","","",,"","mv_par09","Data Fixa","Data Fixa","Data Fixa","","Medição","Medição","Medição","","Todos","Todos","Todos","","","","","",aHelp[09,1],aHelp[09,2],aHelp[09,3],"")	
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva as áreas originais                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    

 	RestArea( aAreaSX1 )
 	RestArea( aAreaAtu )
                                                                                                                                                                                                                                                                                                                                                                                                          
Return( Nil )    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressão do relatório                                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    

Static Function ImpRel() 	
	NPAG := 1
	
	Cabec()
					
    CorpRel()   
Return       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho do relatorio                                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

Static Function Cabec()
	Local aArea := GetArea()
	Local clTxt := ""  

	oPrn:EndPage()
        
    If Li > 55
		oPrn:Say(nLin-20,1000,cpTitulo ,opFont14n,100)
		
		oPrn:Box(50,nCol,175,nfim)
		oPrn:Box(50,nCol,175,nfim-320)
	    oPrn:Box(50,nCol,175,400)
	    
	 	oPrn:Say(075,nCol+10,"SIGA/RFAT004/v.P10"  	,opFont08n,100)
		oPrn:Say(115,nCol+10,"Hora...: " + time()	,opFont08n,100)
	
		oPrn:Say(075,1990,"Folha....: " + str(NPAG)   	,opFont08n,100)
		oPrn:Say(115,1990,"DT.Emiss.: " + dtoc(date())	,opFont08n,100)
	
		nLin += nPula
		nLin += nPula   
	    
		oPrn:FillRect({nLin,nCol,nLin+50,nfim}, oBrush1)
		oPrn:Box(nLin,nCol,nLin+50,nfim)
		oPrn:Box(nLin,nCol,nLin+50,aGrade[1])
		oPrn:Box(nLin,nCol,nLin+50,aGrade[2])
		oPrn:Box(nLin,nCol,nLin+50,aGrade[3])
		oPrn:Box(nLin,nCol,nLin+50,aGrade[4])
		oPrn:Box(nLin,nCol,nLin+50,aGrade[5])		
	          
		c_imp := "ITEM"
		oPrn:Say(nLin,aColTit[1],c_imp,opFont10n,100)
	
		c_imp := "PRODUTO"
		oPrn:Say(nLin,aColTit[2],c_imp,opFont10n,100)
		
		c_imp := "VALOR"
		oPrn:Say(nLin,aColTit[3],c_imp,opFont10n,100)
		
		c_imp := "DT. ENTREGA"
		oPrn:Say(nLin,aColTit[4],c_imp,opFont10n,100)
	
		nLin += nPula
		imprp	:= .T.
	
    EndIf
    
	RestArea(aArea)
Return
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Corpo do relatorio                                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

Static Function CorpRel()
   	local clVOb := ""  
   	
   	Private cCdFat := ""
   	
   	if mv_par09 == 1
		cCdFat := "1"
	elseif mv_par09 == 2
	   	cCdFat := "3"
	elseif mv_par09 == 3
	  	cCdFat := " "
	EndIf   	
   	
   	clAliasCTT := RFATSQLCTT()
 	
 	DbSelectArea(clAliasCTT)
	(clAliasCTT)->(DbGoTop())
	
	if (clAliasCTT)->(!EOF())
		While (clAliasCTT)->(!EOF())
			if n_cont > 60
				nLin = 100
				n_cont = 0
				NPAG += 1
				Cabec()
			EndIf  
			
			if (clAliasCTT)->CTT_CUSTO <> clVOb
			
				cpObra := (clAliasCTT)->CTT_CUSTO    

				vTotPed := 0 

				clAliasVrg := RFATSQLVRG()

				(clAliasVrg)->(DbGoTop()) 

				if (clAliasVrg)->REG > 0
                
                	oPrn:FillRect({nLin,nCol,nLin+50,nfim}, oBrush2)
					oPrn:Box(nLin,nCol,nLin+50,nfim)
				
					c_imp := "Obra: " 
					oPrn:Say(nLin+7,aColOb[1],c_imp,opFont08n,100)

					c_imp := (clAliasCTT)->CTT_CUSTO 
					oPrn:Say(nLin+7,aColOb[2],c_imp,opFont08n,100)
	
					c_imp := "Cliente: "
					oPrn:Say(nLin+7,aColOb[3],c_imp,opFont08n,100)
	
					c_imp := Posicione("SA1",1,xFilial()+(clAliasCTT)->CTT_XCONT1+(clAliasCTT)->CTT_XLJCT1,"A1_NOME")
					oPrn:Say(nLin+7,aColOb[4],c_imp,opFont08n,100)     
			
					nLin += nPula
		
					n_cont += 1 
				
				EndIf   
				
				DbCloseArea(clAliasVrg)  // Inserido para fechar tabela [Bruno Parreira, Actual Trend, 12/07/2011]
			
				clAliasSC5 := RFATSQLSC5()
 
				(clAliasSC5)->(DbGoTop())
	  		
	  			if (clAliasSC5)->(!EOF())
  				while (clAliasSC5)->(!EOF())
	  					if n_cont > 60
							nLin = 100
							n_cont = 0
							NPAG += 1
							Cabec()
						EndIf  
						cpPed = (clAliasSC5)->C5_NUM
					
						clAliasReg := RFATSQLREG()
					
						(clAliasReg)->(DbGoTop()) 
					
						if(clAliasReg)->REG > 0
					
							clAliasTot := RFATSQLTOT()
					
							(clAliasTot)->(DbGoTop())    	
	  			 	    
	  			   			oPrn:Box(nLin,nCol,nLin+50,nfim)
	  			 			c_imp := "Pedido: "
							oPrn:Say(nLin+7,aColPd[1],c_imp,opFont08n,100)
					
							c_imp := (clAliasSC5)->C5_NUM
							oPrn:Say(nLin+7,aColPd[2],c_imp,opFont08,100)
					
							c_imp := "Total do Pedido: "
							oPrn:Say(nLin+7,aColPd[3],c_imp,opFont08n,100)
					                    
							c_imp := "R$ " + Alltrim(Transform((clAliasTot)->TOTAL, "@E 999,999,999.99"))
							oPrn:Say(nLin+7,aColPd[4],c_imp,opFont08,100)
					
						 //	c_imp := "Sit. Pedido: "
						//	oPrn:Say(nLin+7,aColPd[5],c_imp,opFont08n,100)
					  	
							if (clAliasSC5)->C5_XSITP == "1" 		
								c_imp := "Normal"
							elseif (clAliasSC5)->C5_XSITP == "2"
								c_imp := "Caucionado"   
							else	
								c_imp := ""
							EndIf 
					
						//	oPrn:Say(nLin+7,aColPd[6],c_imp,opFont08,100)
					
							c_imp := "Cond. Fat.: "
							oPrn:Say(nLin+7,aColPd[7],c_imp,opFont08n,100)
					    
							if (clAliasSC5)->C5_XCONDF == "1" 		
								c_imp := "Dt. Fixa"
							elseif (clAliasSC5)->C5_XCONDF == "2"
								c_imp := "Dt. Entrega"          
							elseif (clAliasSC5)->C5_XCONDF == "3"
						 		c_imp := "Medição"
							else
						 		c_imp := "" 		
							EndIf		
			            
							oPrn:Say(nLin+7,aColPd[8],c_imp,opFont08,100)

	  			 			nLin += nPula

							n_cont += 1     
							
							DbCloseArea(clAliasTot)  // Inserido para fechar tabela [Bruno Parreira, Actual Trend, 12/07/2011]
						EndIf 
			
						DbCloseArea(clAliasReg)  // Inserido para fechar tabela [Bruno Parreira, Actual Trend, 12/07/2011]	 

						clAliasSC6 := RFATSQLSC6()

						(clAliasSC6)->(DbGoTop())

	  					if (clAliasSC6)->(!EOF())
	  						while (clAliasSC6)->(!EOF())
	  							if n_cont > 60
									nLin = 100
									n_cont = 0
									NPAG += 1
									Cabec()
								EndIf      	
                            
								oPrn:Box(nLin,nCol,nLin+50,nfim)
								oPrn:Box(nLin,nCol,nLin+50,aGrade[1])
								oPrn:Box(nLin,nCol,nLin+50,aGrade[2])
								oPrn:Box(nLin,nCol,nLin+50,aGrade[3])
								oPrn:Box(nLin,nCol,nLin+50,aGrade[4])
								oPrn:Box(nLin,nCol,nLin+50,aGrade[5])								
							
	  							c_imp := (clAliasSC6)->C6_ITEM
								oPrn:Say(nLin+7,aColIPd[1],c_imp,opFont08,100)
	  			 	        
	  			 	        	c_imp := AllTrim((clAliasSC6)->C6_PRODUTO) + " - " + Posicione("SB1",1,xFilial()+(clAliasSC6)->C6_PRODUTO,"B1_DESC") 
								oPrn:Say(nLin+7,aColIPd[2],c_imp,opFont08,100)
	  			 	        
	  							c_imp := "R$ " + Alltrim(Transform((clAliasSC6)->C6_VALOR, "@E 999,999,999.99"))
								oPrn:Say(nLin+7,aColIPd[3],c_imp,opFont08,100) 	        
	  			 	        
	  			 				c_imp := DtoC(stod((clAliasSC6)->C6_ENTREG))
								oPrn:Say(nLin+7,aColIPd[4],c_imp,opFont08,100)    
							
								cpIPed := (clAliasSC6)->C6_ITEM
							
								clAliasLOG := RFATSQLLOG()

								(clAliasLOG)->(DbGoTop())
							
								if (clAliasLOG)->REG > 1
									c_imp := "*"
									oPrn:Say(nLin+7,aColIPd[5],c_imp,opFont10n,100)	
								EndIF     
								
								if (claliasSC6)->C6_XSITP == 'S'
									c_imp := "Caucionado"
									oPrn:Say(nLin+7,aColIPd[6],c_imp,opFont08,100)
								EndIf
								
	  			 				nLin += nPula
		
								n_cont += 1
							
								vTotPed += (clAliasSC6)->C6_VALOR 
							
								(clAliasSC6)->(DbSkip()) 
	  						EndDo
	  						oPrn:Box(nLin,nCol,nLin+50,nfim)
	  						c_imp := "Total à Faturar: "
							oPrn:Say(nLin+7,aColPd[5],c_imp,opFont08n,100) 
						
							c_imp := "R$ " + Alltrim(Transform(vTotPed, "@E 999,999,999.99"))
							oPrn:Say(nLin+7,aColIPd[3],c_imp,opFont08,100)   
						
							vTotG += vTotPed
						
							vTotPed := 0
						
							nLin += nPula
		
							n_cont += 1
	  					EndIf
	  					DbCloseArea(clAliasSC6) // Inserido para fechar tabela [Bruno Parreira, Actual Trend, 12/07/2011]
	  					(clAliasSC5)->(DbSkip())  	  				 	
	  		   		EndDo
	  			EndIf
	  			DbCloseArea(clAliasSC5)// Inserido para fechar tabela [Bruno Parreira, Actual Trend, 12/07/2011]
	  		EndIf
	  		clVOb := (clAliasCTT)->CTT_CUSTO
	  		(clAliasCTT)->(DbSkip())
		EndDo  
	 	oPrn:Box(nLin,nCol,nLin+50,nfim)
	  	c_imp := "Total Geral: ****************************************************************"
		oPrn:Say(nLin+7,aColOb[1],c_imp,opFont08n,100) 
						
		c_imp := "R$ " + Alltrim(Transform(vTotG, "@E 999,999,999.99"))
		oPrn:Say(nLin+7,aColPd[8],c_imp,opFont08n,100)   	
	EndIf
	DbCloseArea(clAliasCTT)   // Inserido para fechar tabela [Bruno Parreira, Actual Trend, 12/07/2011]
Return  

Static Function RFATSQLCTT()
	Local clAliasSql := GetNextAlias()
	
	if cCdFat == '1' .Or. cCdFat == '3'

		BeginSql Alias clAliasSql    
	  
			select CTT_CUSTO, CTT_XCONT1, CTT_XLJCT1 from %Table:CTT% CTT
			inner join %Table:SC5% SC5 on C5_CCUSTO = CTT_CUSTO AND SC5.%NotDel% AND C5_XPEDFIN='S' AND C5_XCONDF=%EXP:AllTrim(cCdFat)%
			INNER JOIN %Table:SC6% SC6 ON C6_NUM=C5_NUM AND SC6.%NotDel% AND C6_FILIAL>=%EXP:MV_PAR07% AND C6_FILIAL<=%EXP:MV_PAR08%// Inserido para nao trazer Obra sem Item a faturar [Luiz Henrique, Actual Trend, 28/05/2012]
			where CTT.%NotDel% AND CTT_CUSTO>=%EXP:MV_PAR01% AND CTT_CUSTO<=%EXP:MV_PAR02% 
			AND CTT_XCONT1>=%EXP:MV_PAR05% AND CTT_XCONT1<=%EXP:MV_PAR06%			
			AND C6_NOTA=%EXP:cpVazio% // Inserido para nao trazer Obra sem Item a faturar [Luiz Henrique, Actual Trend, 28/05/2012]
	    	AND C6_BLQ=%EXP:cpVazio% // Inserido para nao trazer Obra sem Item a faturar [Luiz Henrique, Actual Trend, 28/05/2012]
			order by CTT_CUSTO

		EndSql
		
	else
		
		BeginSql Alias clAliasSql    
	  
			select CTT_CUSTO, CTT_XCONT1, CTT_XLJCT1 from %Table:CTT% CTT
			inner join %Table:SC5% SC5 on C5_CCUSTO = CTT_CUSTO AND SC5.%NotDel% AND C5_XPEDFIN='S'
			INNER JOIN %Table:SC6% SC6 ON C6_NUM=C5_NUM AND SC6.%NotDel% AND C6_FILIAL>=%EXP:MV_PAR07% AND C6_FILIAL<=%EXP:MV_PAR08%// Inserido para nao trazer Obra sem Item a faturar [Luiz Henrique, Actual Trend, 28/05/2012]
			where CTT.%NotDel% AND CTT_CUSTO>=%EXP:MV_PAR01% AND CTT_CUSTO<=%EXP:MV_PAR02% 
			AND CTT_XCONT1>=%EXP:MV_PAR05% AND CTT_XCONT1<=%EXP:MV_PAR06% 
			AND C6_NOTA=%EXP:cpVazio% // Inserido para nao trazer Obra sem Item a faturar [Luiz Henrique, Actual Trend, 28/05/2012]
	    	AND C6_BLQ=%EXP:cpVazio%  // Inserido para nao trazer Obra sem Item a faturar [Luiz Henrique, Actual Trend, 28/05/2012]
			order by CTT_CUSTO

		EndSql
	
	EndIf	

Return(clAliasSql)    

Static Function RFATSQLSC5()
	Local clAliasSql := GetNextAlias()
    
    if cCdFat == '1' .Or. cCdFat == '3'
    
		BeginSql Alias clAliasSql    
	  
			select C5_NUM, C5_XSITP, C5_XCONDF from %Table:SC5% SC5   
			where SC5.%NotDel% AND C5_FILIAL>=%EXP:MV_PAR07% AND C5_FILIAL<=%EXP:MV_PAR08%
			AND C5_CCUSTO=%EXP:cpObra% AND C5_NUM>=%EXP:MV_PAR03% AND C5_NUM<=%EXP:MV_PAR04%
			AND C5_XPEDFIN='S' AND C5_XCONDF=%EXP:AllTrim(cCdFat)%
			order by C5_NUM
		                    
		EndSql
	
	else
		
		BeginSql Alias clAliasSql    
	  
			select C5_NUM, C5_XSITP, C5_XCONDF from %Table:SC5% SC5 
			where SC5.%NotDel% AND C5_FILIAL>=%EXP:MV_PAR07% AND C5_FILIAL<=%EXP:MV_PAR08%
			AND C5_CCUSTO=%EXP:cpObra% AND C5_NUM>=%EXP:MV_PAR03% AND C5_NUM<=%EXP:MV_PAR04%
			AND C5_XPEDFIN='S'
			order by C5_NUM
		
		EndSql
	
	EndIf	
		

Return(clAliasSql)   

Static Function RFATSQLVRG()
	Local clAliasSql := GetNextAlias()  
	
	if cCdFat == '1' .Or. cCdFat == '3'

		BeginSql Alias clAliasSql    
	  
			select COUNT(*) as REG from %Table:SC5% SC5
			inner join %Table:SC6% SC6 on C6_NUM = C5_NUM AND SC6.%NotDel% 
			AND C6_NOTA=%EXP:cpVazio% 
			AND C6_BLQ=%EXP:cpVazio% 
			where SC5.%NotDel% AND C5_FILIAL>=%EXP:MV_PAR07% AND C5_FILIAL<=%EXP:MV_PAR08% 
			AND C5_CCUSTO=%EXP:cpObra% AND C5_NUM>=%EXP:MV_PAR03% AND C5_NUM<=%EXP:MV_PAR04%
			AND C5_XPEDFIN='S' AND C5_XCONDF=%EXP:AllTrim(cCdFat)% 
		
		EndSql
		
	else	     
	
		BeginSql Alias clAliasSql    
	  
			select COUNT(*) as REG from %Table:SC5% SC5
			inner join %Table:SC6% SC6 on C6_NUM = C5_NUM AND SC6.%NotDel% 
			AND C6_NOTA=%EXP:cpVazio% 
			AND C6_BLQ=%EXP:cpVazio%
			where SC5.%NotDel% AND C5_FILIAL>=%EXP:MV_PAR07% AND C5_FILIAL<=%EXP:MV_PAR08%
			AND C5_CCUSTO=%EXP:cpObra% AND C5_NUM>=%EXP:MV_PAR03% AND C5_NUM<=%EXP:MV_PAR04%
			AND C5_XPEDFIN='S'
		
		EndSql
		
	EndIf	

Return(clAliasSql)  

Static Function RFATSQLSC6()
	Local clAliasSql := GetNextAlias()

	BeginSql Alias clAliasSql    
	  
		select C6_ITEM, C6_PRODUTO, C6_VALOR, C6_ENTREG, C6_XSITP from %Table:SC6% SC6
		where %NotDel% AND C6_FILIAL>=%EXP:MV_PAR07% AND C6_FILIAL<=%EXP:MV_PAR08%
		AND C6_NUM=%EXP:cpPed% 
		AND C6_NOTA=%EXP:cpVazio% 
		AND C6_BLQ=%EXP:cpVazio%
		order by C6_ITEM
		
	EndSql

Return(clAliasSql) 

Static Function RFATSQLTOT()
	Local clAliasSql := GetNextAlias()

	BeginSql Alias clAliasSql    
	  
		select SUM(C6_VALOR) as TOTAL from %Table:SC6% SC6
		where %NotDel% AND C6_FILIAL>=%EXP:MV_PAR07% AND C6_FILIAL<=%EXP:MV_PAR08%
		AND C6_NUM=%EXP:cpPed% AND C6_BLQ=%EXP:cpVazio% 
		
	EndSql

Return(clAliasSql)    

Static Function RFATSQLREG()
	Local clAliasSql := GetNextAlias()

	BeginSql Alias clAliasSql    
	  
		select COUNT(*) as REG from %Table:SC6% SC6
		where %NotDel% AND C6_FILIAL>=%EXP:MV_PAR07% AND C6_FILIAL<=%EXP:MV_PAR08%
		AND C6_NUM=%EXP:cpPed% 
		AND C6_NOTA=%EXP:cpVazio%
		AND C6_BLQ=%EXP:cpVazio%
		
	EndSql

Return(clAliasSql)       

Static Function RFATSQLLOG()
	Local clAliasSql := GetNextAlias()

	BeginSql Alias clAliasSql    
	  
		select COUNT(*) as REG from %Table:SZ4% SZ4
		where %NotDel% AND Z4_FILIAL>=%EXP:MV_PAR07% AND Z4_FILIAL<=%EXP:MV_PAR08%
		AND Z4_PEDIDO=%EXP:cpPed% AND Z4_ITEM=%EXP:cpIPed%
		
	EndSql

Return(clAliasSql)       