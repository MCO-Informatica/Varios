#INCLUDE "FINR340.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "fwcommand.ch"

#Define I_CORRECAO_MONETARIA         1
#Define I_DESCONTO                   2
#Define I_JUROS                      3
#Define I_MULTA                      4
#Define I_VALOR_RECEBIDO             5
#Define I_VALOR_PAGO                 6
#Define I_RECEB_ANT                  7
#Define I_PAGAM_ANT                  8
#Define I_MOTBX                      9

USER FUNCTION XFINRVS2()

Local oReport
Local aArea := GetArea()   


If TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Return U_XFRVS2R3() // Executa versão anterior do fonte
Endif

RestArea(aArea)  

RETURN

Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local cReport 	:= "FINR340"	// Nome do relatorio
Local cDescri 	:= OemToAnsi(STR0001)+ OemToAnsi(STR0002)	//"Este programa ir  emitir a posi‡„o de clientes " "referente a data base do sistema."
Local cTitulo 	:= OemToAnsi(STR0005)	//"Posicao dos Clientes "
Local cPerg		:= "FIN340"	// Nome do grupo de perguntas
Local aOrdem	:= {OemToAnsi(STR0020),OemToAnsi(STR0021)}	//"Por Codigo"###"Por Nome"
Local nTamVal	:= TamSX3("E1_VALOR")[1] + 4
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport := TReport():New(cReport, cTitulo + " - ", cPerg, {|oReport| ReportPrint(oReport, cTitulo)}, cDescri) 

pergunte("FIN340",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // do Cliente                            ³
//³ mv_par02            // Ate o Cliente                         ³
//³ mv_par03            // Da Loja                               ³
//³ mv_par04            // Ate a Loja                            ³
//³ mv_par05            // Da Emissao                            ³
//³ mv_par06            // Ate a Emissao                         ³
//³ mv_par07            // Do Vencimento                         ³
//³ mv_par08            // Ate o Vencimento                      ³
//³ mv_par09            // Imprime os t¡tulos provis¢rios        ³
//³ mv_par10            // Qual a moeda                          ³
//³ mv_par11            // Reajusta pela DataBase ou Vencto      ³
//³ mv_par12            // Considera Faturados                   ³
//³ mv_par13            // Imprime Outras Moedas                 ³
//³ mv_par14            // Considera Data Base                   ³
//³ mv_par15            // Imprime Nome? (Razao Social/N.Reduzid)³
//³ mv_par16            // Natureza De ?                         ³
//³ mv_par17            // Natureza Ate?                         ³
//³ mv_par18            // Considera Liquidados?                 ³
//³ mv_par19            // Cons. Baixas por Recibo?              ³
//³ mv_par20		 	// Consid Filiais  ?  					³
//³ mv_par21		 	// da filial							³
//³ mv_par22		 	// a flial 								³
//³ mv_par23		 	// Seleciona filiais					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SetLandscape() 		//Imprime o relatorio no formato paisagem
//Gestao
oReport:SetUseGC(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                        ³
//³                      Definicao das Secoes                              ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 01                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, STR0034,"SA1", aOrdem) //"Dados do Cliente"

TRCell():New(oSection1,"TXTCLI"  ,     , STR0035	,									,10						,/*lPixel*/,{|| STR0015 })	//"Cliente ## CLIENTE : "
TRCell():New(oSection1,"A1_COD"  ,"SA1",  			,PesqPict("SA1","A1_COD" ),TamSX3("A1_COD" )[1],/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"A1_LOJA" ,"SA1",			,PesqPict("SA1","A1_LOJA"),TamSX3("A1_LOJA")[1],/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"A1_NOME" ,"SA1",			,PesqPict("SA1","A1_NOME"),TamSX3("A1_NOME")[1],/*lPixel*/,{|| IIF(mv_par15 == 1, SA1->A1_NOME, SA1->A1_NREDUZ) } )

oSection1:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 02                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1, STR0036,{"SE1","SED"}, aOrdem) //"Titulos"

TRCell():New(oSection2,"E1_PREFIXO" ,"SE1" , STR0037	, PesqPict("SE1","E1_PREFIXO") 	, TamSX3("E1_PREFIXO")[1] ,/*lPixel*/,{ || SE1->E1_PREFIXO })//"Prf"
TRCell():New(oSection2,"E1_NUM"	  	,"SE1" , STR0038 	, PesqPict("SE1","E1_NUM") 	 	, TamSX3("E1_NUM")[1]     ,/*lPixel*/,{ || SE1->E1_NUM 		})//"Numero"
TRCell():New(oSection2,"E1_PARCELA" ,"SE1" , STR0039	, PesqPict("SE1","E1_PARCELA")	, TamSX3("E1_PARCELA")[1] ,/*lPixel*/,{ || SE1->E1_PARCELA })//"PC"
TRCell():New(oSection2,"E1_TIPO"  	,"SE1" ,			, PesqPict("SE1","E1_TIPO")    	, TamSX3("E1_TIPO")[1]    ,/*lPixel*/,{ || SE1->E1_TIPO		})
TRCell():New(oSection2,"VALOR"	   	,      , STR0040 	, 								    , 20 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Original"
TRCell():New(oSection2,"E1_EMISSAO" ,"SE1" , STR0041 	, PesqPict("SE1","E1_EMISSAO") 	, 10 ,/*lPixel*/,{ || SE1->E1_EMISSAO })//"Emissao"
TRCell():New(oSection2,"E1_VENCREA" ,"SE1" , STR0042 	, PesqPict("SE1","E1_VENCREA") 	, 10 ,/*lPixel*/,{ || SE1->E1_VENCREA })//"Vencto"
TRCell():New(oSection2,"BAIXA" 		,  	   , STR0043	, PesqPict("SE1","E1_BAIXA")   	, 10 ,/*lPixel*/,/*CodeBlock*/)	//"Baixa"
//TRCell():New(oSection2,"DESCON" 	,      , STR0044	, Tm(0,13) 						, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
//TRCell():New(oSection2,"ABATIM" 	,      , STR0045	, Tm(0,13) 						, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Abatimentos"
//TRCell():New(oSection2,"JUROS" 		,      , STR0046	, Tm(0,13) 						, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Juros"
//TRCell():New(oSection2,"MULTA" 		,      , STR0047	, Tm(0,13) 						, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Multa"
//TRCell():New(oSection2,"CMONE" 		,      , STR0048	, Tm(0,13) 						, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGH",,"RIGHT") //"Corr. Monet."
TRCell():New(oSection2,"VLRBAIXA"	,      , STR0049	, Tm(0,19) 						, 19 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Baixado"
//TRCell():New(oSection2,"RECANTEC" 	,      , STR0050	, Tm(0,19) 						, 19 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Rec. Antecip."
//TRCell():New(oSection2,"E1_ACRESC"	,"SE1" , 			, Tm(0,13) 						, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
//TRCell():New(oSection2,"E1_DECRESC" ,"SE1" , 			, Tm(0,13) 						, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"SALDO" 		,      , STR0051	, 								, 20 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Saldo Atual"
//TRCell():New(oSection2,"MOTIVO" 	,      , STR0052	, 								, 15 ,/*lPixel*/,/*CodeBlock*/) //"Motivo"
//TRCell():New(oSection2,"SITUACAO"	,      , STR0053	, 								, 10 ,/*lPixel*/,/*CodeBlock*/) //"Situacao"
//TRCell():New(oSection2,"E1_PORTADO" ,"SE1", STR0054	, 									, 03 ,/*lPixel*/,{ || SE1->E1_PORTADO })	//"Port."

oSection2:SetHeaderSection(.T.)

//Faz o alinhamento do cabecalho das celulas
//oSection2:Cell("DESCON"	 ):SetHeaderAlign("RIGHT")
//oSection2:Cell("ABATIM"	 ):SetHeaderAlign("RIGHT")
//oSection2:Cell("JUROS"	 ):SetHeaderAlign("RIGHT")
//oSection2:Cell("MULTA"	 ):SetHeaderAlign("RIGHT")
//oSection2:Cell("CMONE"	 ):SetHeaderAlign("RIGHT")
oSection2:Cell("VLRBAIXA"):SetHeaderAlign("RIGHT")
//oSection2:Cell("RECANTEC"):SetHeaderAlign("RIGHT")
oSection2:Cell("SALDO"	 ):SetHeaderAlign("RIGHT")

oSection2:SetLineBreak(.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 03                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3 := TRSection():New(oReport, STR0055) //"Totais"

TRCell():New(oSection3,"TXTTOTAL"	,       , STR0055	,						    , Iif(cPaisloc=="MEX",32,21) ,/*lPixel*/,/*CodeBlock*/) //"Totais"	
TRCell():New(oSection3,"VALOR"	 	,		, STR0040  , PesqPict("SE1","E1_VALOR"), 20 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")//"Valor Original"
TRCell():New(oSection3,"E1_EMISSAO", "SE1" , STR0041	, 							, 10 ,/*lPixel*/,/*CodeBlock*/) //"Emissao"
TRCell():New(oSection3,"E1_VENCREA", "SE1" , STR0042 ,							, 10 ,/*lPixel*/,/*CodeBlock*/) //"Vencto"
TRCell():New(oSection3,"E1_BAIXA"  , "SE1" , STR0043 	, 							, 10 ,/*lPixel*/,/*CodeBlock*/) //"Baixa"
//TRCell():New(oSection3,"DESCON"		,       , STR0044 	, Tm(0,13)           	   	, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
//TRCell():New(oSection3,"ABATIM"		, 	    , STR0045	, Tm(0,13)              	, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Abatimentos"
//TRCell():New(oSection3,"JUROS" 		,       , STR0046	, Tm(0,13)                	, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Juros"
//TRCell():New(oSection3,"MULTA" 		,       , STR0047	, Tm(0,13)                	, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Multa"
//TRCell():New(oSection3,"CMONE" 		,       , STR0048	, Tm(0,13)                	, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Corr. Monet."
TRCell():New(oSection3,"VLRBAIXA"	,    	, STR0049	, Tm(0,19)                	, 19 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Baixado"
//TRCell():New(oSection3,"RECANTEC" 	,  	  	, STR0050	, Tm(0,19)					, 19 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Rec. Antecip."
//TRCell():New(oSection3,"E1_ACRESC"	, "SE1" , 			, Tm(0,13)					, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Acrescimo"
//TRCell():New(oSection3,"E1_DECRESC", "SE1" , 			, Tm(0,13) 				, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Decrescimo"
TRCell():New(oSection3,"SALDO" 		, 	    , STR0051	, Tm(0,nTamVal) 			, 20 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Saldo Atual"

oSection3:SetLineBreak(.T.)
//Oculta as celulas
oSection3:Cell("E1_EMISSAO"):Hide()
oSection3:Cell("E1_VENCREA"):Hide()
oSection3:Cell("E1_BAIXA"  ):Hide()

oSection3:SetLinesBefore(0.5)
oSection3:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 04                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection4 := TRSection():New(oReport, STR0057) //"Totais/Filial"

TRCell():New(oSection4,"TXTTOTAL"	,       , STR0055	,								, 54 ,/*lPixel*/,/*CodeBlock*/) //"Totais"
TRCell():New(oSection4,"VALOR"	   	,		, STR0040 	, PesqPict("SE1","E1_VALOR"), 20 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")//"Valor Original"
//TRCell():New(oSection4,"DESCON" 	,       , STR0044 	, Tm(0,13)                  	, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
//TRCell():New(oSection4,"ABATIM" 	, 	   	, STR0045	, Tm(0,13)                  	, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Abatimentos"
//TRCell():New(oSection4,"JUROS" 		,       , STR0046	, Tm(0,13)                  	, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Juros"
//TRCell():New(oSection4,"MULTA" 		,       , STR0047	, Tm(0,13)                  	, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Multa"
//TRCell():New(oSection4,"CMONE" 		,       , STR0048	, Tm(0,13)                  	, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Corr. Monet."
TRCell():New(oSection4,"VLRBAIXA"	,    	, STR0049	, Tm(0,19)                  	, 19 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Baixado"
//TRCell():New(oSection4,"RECANTEC" 	,  	  	, STR0050	, Tm(0,19)						, 19 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Rec. Antecip."
//TRCell():New(oSection4,"E1_ACRESC"	, "SE1" , 			, Tm(0,13) 					, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Acrescimo"
//TRCell():New(oSection4,"E1_DECRESC", "SE1" , 			, Tm(0,13) 					, 11 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Decrescimo"
TRCell():New(oSection4,"SALDO" 		, 	   	, STR0051	, Tm(0,nTamVal)				, 15 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Saldo Atual"

oSection4:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

oReport:nFontBody := 5
Return oReport

Static Function ReportPrint(oReport,cTitulo)

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)
Local oSection3 := oReport:Section(2)//oReport:Section(1):Section(1):Section(1)
Local oSection4 := oReport:Section(3)//oReport:Section(1):Section(1):Section(1):Section(1)
Local nOrdem	:= oReport:Section(1):GetOrder()
Local lTotGer   := .F.
Local nTit1		:=0
Local nTit2		:=0
Local nTit3		:=0
Local nTit4		:=0
Local nTit5		:=0
Local nTit6		:=0
Local nTit7		:=0
Local nTit8		:=0
Local nTit9		:=0
Local nTit10	:=0
Local nTit11	:=0
Local nTot1		:=0
Local nTot2		:=0
Local nTot3		:=0
Local nTot4		:=0
Local nTot5		:=0
Local nTot6		:=0
Local nTot7		:=0
Local nTot8		:=0
Local nTot9		:=0
Local nTot10	:=0
Local nTot11	:=0
Local nTotAbat	:= 0
Local cForAnt	:= Space(6)
Local lContinua	:= .T.
Local aValor	:= {0,0,0,0,0,0,0,0,""}
Local nSaldo	:= 0
Local nMoeda	:= mv_par10
Local dDataMoeda := dDataBase
Local ndecs		:= Msdecimais(mv_par10)
Local cMotivo	:= " "
Local aMotBx	:= {}
Local nValor	:= 0
Local nPos		:= 0
Local cAliasSA1 := "SA1"
Local cSitCobr  := " "
Local cCond1	:= ""
Local cCond2	:= ""
Local cChave	:= ""
Local cIndex	:= ""
Local cChaveE1	:= ""
Local cChaveE2	:= ""
Local cTipoant	:= ""
Local ntotaltipo:= 0
Local i			:=0
Local nTotFil1	:=0
Local nTotFil2	:=0
Local nTotFil3	:=0
Local nTotFil4	:=0
Local nTotFil5	:=0
Local nTotFil6	:=0
Local nTotFil7	:=0
Local nTotFil8	:=0
Local nTotFil9	:=0
Local nTotFil10	:=0
Local nTotFil11	:=0
Local lCancelado := .F.
Local aFiliais	:= {}           
Local lVerFil	:= .F.
Local nInc		:= 0
Local cFilOld	:= cFilAnt
Local lSai		:= .F.
Local aCelulas	:= aClone(oReport:aSection[1]:aCell[4]:oParent:aSection[1]:aCell)    
Local nX		:= 0
Local cFilSmo	:= ""
Local lCS		:= .T. 
Local lPI		:= .T. 
Local lCF		:= .T.
Local cSeek		:= ""
//Gestao
Local cFilAtu 	:= cFilAnt
Local lGestao   := ( FWSizeFilial() > 2 ) 	// Indica se usa Gestao Corporativa
Local lSE1Excl  := Iif( lGestao, FWModeAccess("SE1",1) == "E", FWModeAccess("SE1",3) == "E")
Local lSE5Excl  := Iif( lGestao, FWModeAccess("SE5",1) == "E", FWModeAccess("SE5",3) == "E")
Local lQuery 	:= IfDefTopCTB() // verificar se pode executar query (TOPCONN)
Local aSelFil 	:= {}
//Local aSm0		:= {}
Local nLenFil	:= 0 
Local lSE1Comp  := FWModeAccess("SE1",3)== "C" // Verifica se SE1 é compartilhada
Local lSE5Comp  := FWModeAccess("SE5",3)== "C" // Verifica se SE5 é compartilhada

#IFDEF TOP
	Local aStru		:= SE1->(dbStruct())
	Local ni		:= 0		
	Local cOrder	:= ""	
	Local cFiltSA1 := oReport:Section(1):GetSqlExp("SA1")
	Local cFiltSE1 := oReport:Section(1):GetSqlExp("SE1")
#ENDIF	

Local nTamVal 	:= TAMSX3("E1_VALOR")[1] + 4

Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
Private cFilDe	:= ""
Private cFilAte := ""

//Gestao
If lQuery
	If mv_par23 == 1 .and. (lSE1Excl .or. lSE5Excl)	//filial nao totalmente compartilhada    
		If  FindFunction("AdmSelecFil")
			AdmSelecFil("FIN340",23,.F.,@aSelFil,"SE1",.F.)
		Else
			aSelFil := AdmGetFil(.F.,.F.,"SE1")
			If Empty(aSelFil)
				Aadd(aSelFil,cFilAnt)
			Endif
		Endif
	Endif	
	If Empty(aSelFil)
		aSelFil := {cFilAnt}
	Endif
	SM0->(DbGoTo(nRegSM0))

	aSM0 := FR340AbreSM0(aSelFil)
Else
	aSM0 := AdmAbreSM0()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes da secao 2. (Titulos)		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2:Cell("VALOR"	 	):SetBlock( { || SayValor(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nTamVal,;
								 									( SE1->E1_TIPO $ MVRECANT + "," + MV_CRNEG ),nDecs, oReport:nDevice) } )
oSection2:Cell("BAIXA"	 	):SetBlock( { || If(dDataBase >= SE1->E1_BAIXA .Or. (mv_par14 == 2 .And. !Empty(SE1->E1_BAIXA)), IIF(!Empty(SE1->E1_BAIXA),SE1->E1_BAIXA," "), ) } )
//oSection2:Cell("DESCON"	 	):SetBlock( { || aValor[I_DESCONTO] - aValor[17]			} )
//oSection2:Cell("ABATIM"	 	):SetBlock( { || nTotAbat 						} )
//oSection2:Cell("JUROS"	 	):SetBlock( { || aValor[I_JUROS] 				} )		
//oSection2:Cell("MULTA"	 	):SetBlock( { || aValor[I_MULTA] 				} )
//oSection2:Cell("CMONE"	 	):SetBlock( { || aValor[I_CORRECAO_MONETARIA]	} )
oSection2:Cell("VLRBAIXA"	):SetBlock( { || aValor[I_VALOR_RECEBIDO] 		} )				
//oSection2:Cell("RECANTEC"	):SetBlock( { || aValor[I_RECEB_ANT] 			} )
//oSection2:Cell("E1_ACRESC"  ):SetBlock( { || SE1->E1_SDACRES 				} )
//oSection2:Cell("E1_DECRESC" ):SetBlock( { || SE1->E1_DECRESC 				} )
oSection2:Cell("SALDO"	 	):SetBlock( { || SayValor(nSaldo,nTamVal,SE1->E1_TIPO $ MVRECANT+","+MV_CRNEG,nDecs)	} )
//oSection2:Cell("MOTIVO"	 	):SetBlock( { || Pad(aValor[I_MOTBX],15)		} )
//oSection2:Cell("SITUACAO"	):SetBlock( { || cSitCobr 						} )

//oSection2:Cell("DESCON"	 	):Picture( TM(aValor[I_DESCONTO],13,nDecs				))
//oSection2:Cell("ABATIM"	 	):Picture( TM(nTotAbat,13,nDecs							))
//oSection2:Cell("JUROS"	 	):Picture( TM(aValor[I_JUROS],13,nDecs					))
//oSection2:Cell("MULTA"	 	):Picture( TM(aValor[I_MULTA],13,nDecs					))
//oSection2:Cell("CMONE"	 	):Picture( TM(aValor[I_CORRECAO_MONETARIA],13,nDecs	))
oSection2:Cell("VLRBAIXA"	):Picture( TM(aValor[I_VALOR_RECEBIDO],17,nDecs		))
//oSection2:Cell("RECANTEC"	):Picture( TM(aValor[I_RECEB_ANT],17,nDecs				))
//oSection2:Cell("E1_ACRESC"	):Picture( TM(SE1->E1_SDACRES,13,nDecs					))
//oSection2:Cell("E1_DECRESC"	):Picture( TM(SE1->E1_SDDECRE,13,nDecs					))

oSection2:SetHeaderPage()	//Define o cabecalho da secao como padrao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes da secao 3.	(Totais)	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3:Cell("TXTTOTAL"	):SetBlock( { || If (!lTotGer, OemToAnsi(STR0016), OemToAnsi(STR0017)) } )	//"Totais : " ### "TOTAL GERAL : "
oSection3:Cell("VALOR"	 	):SetBlock( { || If (!lTotGer, nTit1, nTot1  ) } )
//oSection3:Cell("DESCON"	 	):SetBlock( { || If (!lTotGer, nTit2, nTot2  ) } )
//oSection3:Cell("ABATIM"	 	):SetBlock( { || If (!lTotGer, nTit3, nTot3  ) } )				
//oSection3:Cell("JUROS"	 	):SetBlock( { || If (!lTotGer, nTit4, nTot4  ) } )
//oSection3:Cell("MULTA"	 	):SetBlock( { || If (!lTotGer, nTit5, nTot5  ) } )
//oSection3:Cell("CMONE"	 	):SetBlock( { || If (!lTotGer, nTit6, nTot6  ) } )
oSection3:Cell("VLRBAIXA"	):SetBlock( { || If (!lTotGer, nTit7, nTot7  ) } )
//oSection3:Cell("RECANTEC"	):SetBlock( { || If (!lTotGer, nTit8, nTot8  ) } )
oSection3:Cell("SALDO"	 	):SetBlock( { || If (!lTotGer, nTit9, nTot9  ) } )
//oSection3:Cell("E1_ACRESC"	):SetBlock( { || If (!lTotGer, nTit10, nTot10) } )
//oSection3:Cell("E1_DECRESC"	):SetBlock( { || If (!lTotGer, nTit11, nTot11) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes da secao 4.	(Totais/Filial)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection4:Cell("TXTTOTAL"	):SetBlock( { || STR0058 +" "+Iif( ((lQuery .or. mv_par20==1) .and. lSE1Excl ),Alltrim(cFilSm0),"")})  //"T O T A L   F I L I A L ----> " 
oSection4:Cell("VALOR"	 	):SetBlock( { || nTotFil1  } )
//oSection4:Cell("DESCON"	 	):SetBlock( { || nTotFil2  } )
//oSection4:Cell("ABATIM"	 	):SetBlock( { || nTotFil3  } )				
//oSection4:Cell("JUROS"	 	):SetBlock( { || nTotFil4  } )
//oSection4:Cell("MULTA"	 	):SetBlock( { || nTotFil5  } )
//oSection4:Cell("CMONE"	 	):SetBlock( { || nTotFil6  } )
oSection4:Cell("VLRBAIXA"	):SetBlock( { || nTotFil7  } )
//oSection4:Cell("RECANTEC"	):SetBlock( { || nTotFil8  } )
oSection4:Cell("SALDO"	 	):SetBlock( { || nTotFil9  } )
//oSection4:Cell("E1_ACRESC"  ):SetBlock( { || nTotFil10 } )
//oSection4:Cell("E1_DECRESC"	):SetBlock( { || nTotFil11 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo := oReport:Title() + " " + GetMv("MV_MOEDA1")
oReport:SetTitle(cTitulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Gestao
If lQuery
	cFilDe  := aSelFil[1]
	cFilAte := aSelFil[Len(aSelFil)]
Else
	If mv_par20 == 2
		cFilDe  := cFilAnt
		cFilAte := cFilAnt
	Else
		cFilDe := mv_par21	// Todas as filiais
		cFilAte:= mv_par22
	Endif
Endif

aFiliais := FinRetFil()

oReport:NoUserFilter()

For nInc := 1 To Len( aSM0 )
   cFilSm0 :=	""
   If aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte)
   
   		oSection1:Init()
   
		cFilAnt := aSM0[nInc][2]
		cFilSm0 :=	aSM0[nInc][2] + ' - ' + aSM0[nInc][7]

		dbSelectArea("SE1")
		IF nOrdem == 1
			dbSetOrder(2)
			cChave := IndexKey()
			dbSeek(xFilial("SE1")+mv_par01+mv_par03,.T.)
			cCond1 := "SE1->E1_CLIENTE+SE1->E1_LOJA <= '"+mv_par02+mv_par04+"' .and. SE1->E1_FILIAL == '"+xFilial("SE1")+"'"
			cCond2 := "SE1->E1_CLIENTE+SE1->E1_LOJA"
			#IFDEF TOP
				cOrder := SqlOrder(cChave)
			#ENDIF
		Else
			If MV_PAR15=1
				cChave  := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			Else
				cChave  := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			EndIf


			#IFDEF TOP
				If TCSrvType() == "AS/400"
					cIndex	:= CriaTrab(nil,.f.)
					dbSelectArea("SE1")
					IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
					nIndex	:= RetIndex("SE1")  								
					dbSetOrder(nIndex+1)
				Else
					cOrder := SqlOrder(cChave)
				EndIf
			#ELSE
				cIndex	:= CriaTrab(nil,.f.)
				dbSelectArea("SE1")
				IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
				nIndex	:= RetIndex("SE1")      
				dbSetIndex(cIndex+OrdBagExt())	
				dbSetOrder(nIndex+1)
			#ENDIF
			cCond1 := ".T."
			cCond2 := "SE1->E1_NOMCLI+SE1->E1_CLIENTE+SE1->E1_LOJA"
			SE1->(dbGoTop())
		EndIf
	
		oReport:SetMeter(SE1->(LastRec()))
	
		#IFDEF TOP
			If TcSrvType() != "AS/400"
	
				If Select("NEWSE1") > 0
					dbSelectArea("NEWSE1")
					dbCloseArea()
				Endif
				ChkFile("SE1",.F.,"NEWSE1")
	
				dbSelectArea("SE1")
				aStru := dbStruct()
	
				// Montagem do SELECT apenas com os campos necessarios ao relatorio
				
				
				cQuery := "SELECT DISTINCT "
		
				if nOrdem == 1
					cQuery += " SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_NOMCLI, "
				else
					cQuery += " SE1.E1_FILIAL, SE1.E1_NOMCLI, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "		
				endif
	
				cQuery += " SE1.E1_NATUREZ, SE1.E1_SITUACA, SE1.E1_PORTADO, SE1.E1_SALDO, SE1.E1_MOEDA, SE1.E1_RECIBO, SE1.E1_ORIGEM, "		
				cQuery += " SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_BAIXA, SE1.E1_FATURA, SE1.E1_DTFATUR, SE1.E1_VALLIQ," 		
				cQuery += " SE1.E1_VALOR,SE1.E1_SDACRES,SE1.E1_SDDECRE,SE1.E1_TXMOEDA,SE1.E1_ACRESC,SE1.E1_DECRESC,SE1.R_E_C_N_O_ RECNO, "
				cQuery += " SE1.E1_INSS, SE1.E1_CSLL, SE1.E1_COFINS, SE1.E1_PIS, SE1.E1_IRRF, "				
				cQuery += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ "
            
				For nx := 1 To Len(aCelulas)
					If !(aCelulas[nX]:cName $ cQuery) .And. (Substr(aCelulas[nX]:cName,1,2) == "E1" .Or. Substr(aCelulas[nX]:cName,1,2) == "A1")
						If Substr(aCelulas[nX]:cName,1,2) == "E1"
							cQuery += ",SE1." + aCelulas[nX]:cName + " "
						Else
							cQuery += ",SA1." + aCelulas[nX]:cName + " "
						EndIf
					EndIf													
         	Next nX
			
				cQuery += " FROM " + RetSqlName("SE1") +" SE1 " 

				cQuery += " JOIN " + RetSQLName("SE5") + " SE5 "
				If lSE5Comp
					cQuery += "   ON  SE5.E5_FILORIG  = '" + cFilAnt + "' AND "
				Else
					cQuery += "   ON  SE5.E5_FILIAL  = '" + xFilial("SE5") + "' AND "
				EndIf
				cQuery += "       SE5.E5_PREFIXO = SE1.E1_PREFIXO AND "
				cQuery += "       SE5.E5_NUMERO  = SE1.E1_NUM     AND "
				cQuery += "       SE5.E5_PARCELA = SE1.E1_PARCELA AND "
				cQuery += "       SE5.E5_TIPO    = SE1.E1_TIPO   AND "
				cQuery += "       SE5.E5_MOTBX   <> 'DSD'        AND "
				cQuery += "       (SE5.E5_RECPAG  = 'R'            OR  "
				cQuery += "       (SE5.E5_RECPAG  = 'P'            AND "
				cQuery += "        SE5.E5_TIPO  = '"+MV_CRNEG+"')) AND "
				
				If mv_par18 == 2
					cQuery += "    SE5.E5_MOTBX   <> 'LIQ'        AND "
				EndIf
					
				cQuery += "       SE5.D_E_L_E_T_ = ' ' "
				cQuery += " JOIN " + RetSqlName("SA1") + " SA1 " 
				cQuery += "   ON  SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND " 
				cQuery += "       SA1.A1_COD = SE1.E1_CLIENTE AND "
				cQuery += "       SA1.A1_LOJA = SE1.E1_LOJA  AND "
				cQuery += "       SA1.D_E_L_E_T_ = ' ' "

				cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "' "                                   
				cQuery += " AND SE1.E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
				cQuery += " AND SE1.E1_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
				cQuery += " AND SE1.E1_EMISSAO between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
				cQuery += " AND SE1.E1_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
				cQuery += " AND SE1.E1_TIPO NOT LIKE '%-' "
				cQuery += " AND SE1.E1_EMISSAO <=  '"     + DTOS(dDataBase) + "'"
				cQuery += " AND SE1.E1_NATUREZ between '" + mv_par16        + "' AND '" + mv_par17       + "'"
				If cPaisLoc<>"BRA"
					cQuery += "AND SE1.E1_TIPO<>'CH' AND SE1.E1_TIPO<>'TF'"
				EndIf
				If mv_par09 == 2
					cQuery += " AND SE1.E1_TIPO <> '"+MVPROVIS+"'"
				EndIf
				If mv_par12 == 2
					cQuery += " AND SE1.E1_FATURA IN('"+Space(Len(E1_FATURA))+"','NOTFAT') "
				Endif
			
				If mv_par19 == 2
					cQuery += "AND (( SE1.E1_RECIBO <> '"+Space(Len(SE1->E1_RECIBO))+"'"
					cQuery += "AND SE1.E1_ORIGEM = 'FINA087A') OR (SE1.E1_RECIBO = '"+Space(Len(SE1->E1_RECIBO))+"') )"
				Endif
				
				If mv_par18 == 2 //Considera Liquidados, 1=SIM, 2=N�O -> 2 n�o imprimi os t�tulos que foram liquidados.
					cQuery += " AND SE1.E1_SALDO > 0  " 
				EndIf
				
				cQuery += " AND SE1.D_E_L_E_T_ = ' '"

				//Adiciono filtro do usuario na Query
				If !Empty(cFiltSA1)
					cQuery += " AND " + cFiltSA1
				EndIf
			
				//Adiciono filtro do usuario na Query
				If !Empty(cFiltSE1)
					cQuery += " AND " + cFiltSE1 
				EndIf

				cQuery2 := " UNION SELECT "
		
				if nOrdem == 1
					cQuery2 += " SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_NOMCLI, "
				else
					cQuery2 += " SE1.E1_FILIAL, SE1.E1_NOMCLI, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "		
				endif
	
				cQuery2 += " SE1.E1_NATUREZ, SE1.E1_SITUACA, SE1.E1_PORTADO, SE1.E1_SALDO, SE1.E1_MOEDA, SE1.E1_RECIBO, SE1.E1_ORIGEM, "		
				cQuery2 += " SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_BAIXA, SE1.E1_FATURA, SE1.E1_DTFATUR, SE1.E1_VALLIQ," 		
				cQuery2 += " SE1.E1_VALOR,SE1.E1_SDACRES,SE1.E1_SDDECRE,SE1.E1_TXMOEDA,SE1.E1_ACRESC,SE1.E1_DECRESC,SE1.R_E_C_N_O_ RECNO, "
				cQuery2 += " SE1.E1_INSS, SE1.E1_CSLL, SE1.E1_COFINS, SE1.E1_PIS, SE1.E1_IRRF, "				
				cQuery2 += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ "

				For nx := 1 To Len(aCelulas)
					If !(aCelulas[nX]:cName $ cQuery2) .And. (Substr(aCelulas[nX]:cName,1,2) == "E1" .Or. Substr(aCelulas[nX]:cName,1,2) == "A1")
						If Substr(aCelulas[nX]:cName,1,2) == "E1"
							cQuery2 += ",SE1." + aCelulas[nX]:cName + " "
						Else
							cQuery2 += ",SA1." + aCelulas[nX]:cName + " "
						EndIf
					EndIf													
         	Next nX

				cQuery += cQuery2

				cQuery += " FROM " + RetSqlName("SE1") +" SE1 " 

				cQuery += " JOIN " + RetSqlName("SA1") + " SA1 " 
				cQuery += "   ON  SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND " 
				cQuery += "       SA1.A1_COD = SE1.E1_CLIENTE AND "
				cQuery += "       SA1.A1_LOJA = SE1.E1_LOJA  AND "
				cQuery += "       SA1.D_E_L_E_T_ = ' ' "
				If lSE1Comp
					cQuery += " WHERE SE1.E1_FILORIG = '" + cFilAnt + "' "
				Else
					cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
				EndIf                            
				cQuery += " AND SE1.E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
				cQuery += " AND SE1.E1_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
				cQuery += " AND SE1.E1_EMISSAO between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
				cQuery += " AND SE1.E1_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
				cQuery += " AND SE1.E1_TIPO NOT LIKE '%-' "
				cQuery += " AND SE1.E1_TIPO NOT LIKE 'RA' "
				cQuery += " AND SE1.E1_EMISSAO <=  '"     + DTOS(dDataBase) + "'"
				cQuery += " AND SE1.E1_NATUREZ between '" + mv_par16        + "' AND '" + mv_par17       + "'"
				If cPaisLoc<>"BRA"
					cQuery += "AND SE1.E1_TIPO<>'CH' AND SE1.E1_TIPO<>'TF'"
				EndIf
				If mv_par09 == 2
					cQuery += " AND SE1.E1_TIPO <> '"+MVPROVIS+"'"
				EndIf
				If mv_par12 == 2
					cQuery += " AND SE1.E1_FATURA IN('"+Space(Len(E1_FATURA))+"','NOTFAT') "
				Endif
			
				If mv_par19 == 2
					cQuery += "AND (( SE1.E1_RECIBO <> '"+Space(Len(SE1->E1_RECIBO))+"'"
					cQuery += "AND SE1.E1_ORIGEM = 'FINA087A') OR (SE1.E1_RECIBO = '"+Space(Len(SE1->E1_RECIBO))+"') )"
				Endif
				
				If mv_par18 == 2 //Considera Liquidados, 1=SIM, 2=N�O -> 2 n�o imprimi os t�tulos que foram liquidados.
					cQuery += " AND SE1.E1_SALDO > 0  " 
				EndIf

				cQuery += " AND SE1.D_E_L_E_T_ = ' '"

				//Adiciono filtro do usuario na Query
				If !Empty(cFiltSA1)
					cQuery += " AND " + cFiltSA1
				EndIf
			
				//Adiciono filtro do usuario na Query
				If !Empty(cFiltSE1)
					cQuery += " AND " + cFiltSE1 
				EndIf

				cQuery += " ORDER BY E1_EMISSAO,E1_FILIAL,E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO " //+ cOrder
				
				cQuery := ChangeQuery(cQuery)
			
				dbSelectArea("SE1")
				dbCloseArea()
								
				EECVIEW(@cQuery)
	
				dbSelectArea("SE1")
				dbCloseArea()
			
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .T., .T.)
				
				For ni := 1 to Len(aStru)
					If aStru[ni,2] != 'C' .and. FieldPos(aStru[ni,1]) > 0
						TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
					Endif
				Next
			
				//Desabilita o filtro no tratamento da Printline()
				oReport:NoUserFilter()
	
				If (SE1->(EOF()))
					lContinua := .F.
				Else
					lContinua := .T.
				EndIf
				cAliasSA1 := "SE1"
			EndIf
		#ENDIF
	
		While SE1->(!Eof()) .And. lContinua .And. &cCond1 .And. !oReport:Cancel()
		
			If oReport:Cancel()
				lContinua := .F.
				Exit
			EndIf	
	

			#IFNDEF TOP
				// Nao considera Ti. Liquidados ou geradores de liquidacao
				dbSelectArea("SE5")
				dbSetorder(5)

				IF SE5->(MsSeek(xFilial('SE5')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))

					cChaveE1 := "xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO"
					cChaveE5 := "xFilial('SE5')+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO"
						
					While !EOF() .And. (&(cChaveE1) == &(cChaveE5))
		 				If (mv_par18 == 2 .AND. SE5->E5_MOTBX == "LIQ" ) .OR. SE5->E5_MOTBX == "DSD"
							lSai := .T.
							Exit
						EndIf
						SE5->(dbSkip())
					Enddo
					If lSai
						SE1->(dbSkip())
						Loop
					Endif

				Endif
				dbSelectArea("SE1")
	
			#ENDIF
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			#IFDEF TOP
				If TcSrvType() != "AS/400"
					dbSelectArea("NEWSE1")
					dbGoto(SE1->RECNO)
				Endif
			#Endif
		
			dbSelectArea("SE1")	
		
			nCont := 1
			nTit1:=nTit2:=nTit3:=nTit4:=nTit5:=nTit6:=nTit7:=nTit8:=nTit9:=nTit10:=nTit11:=0
			cForAnt:= &cCond2
			
			oSection2:Init()
		
			While &cCond2 == cForAnt .And. lContinua .And. &cCond1 .And. !Eof()
			
				#IFNDEF TOP
	   				If mv_par19 == 2
						If (!Empty(SE1->E1_RECIBO) .And. SE1->E1_ORIGEM <> "FINA087A")
						SE1->( dbSkip() )
						Loop
						Endif
					Endif  
				#ENDIF
			
				If oReport:Cancel()
					lContinua := .F.
					Exit
				EndIf	
				
				oReport:IncMeter()
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Considera filtro do usuario                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				#IFDEF TOP
					If TcSrvType() != "AS/400"
						dbSelectArea("NEWSE1")
						dbGoto(SE1->RECNO)
					Endif
				#Endif
	
				If !Fr340Skip("SE1")
					dbSelectArea("SE1")
					dbSkip()
					Loop
				EndIf
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime os dados dos clientes.                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA1")
				dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
			  	If nCont = 1
			   		oSection1:Init()
			   		If xFilial("SA1")+A1_COD+A1_LOJA <> xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA // para casos em que o Inti() desposiciona a tabela
			   			dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
			   		EndIf
			   		oSection1:PrintLine()
					oSection1:Finish()
					nCont++
				Endif
	
				dbSelectArea("SE1")
			
				IF mv_par11 == 1
					dDataMoeda	:=	dDataBase
				Else
					dDataMoeda	:=	SE1->E1_VENCREA
				Endif
				
				aValor := Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,nMoeda,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA,,,,mv_par14 == 1, @lCancelado)
						
				DbSelectArea("SE5")
				DbSetOrder(2)
				
				If DbSeek(xFilial("SE5") + "CM" + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + DtoS(SE1->E1_BAIXA) + SE1->E1_CLIENTE + SE1->E1_LOJA ) //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ 
				
					If !(alltrim(SE1->E1_TIPO) $ MVRECANT+"/"+MVPAGANT+"/"+MV_CRNEG+"/"+MV_CPNEG) .AND. SE5->E5_TIPODOC $ ("CM") .AND. (aValor[I_CORRECAO_MONETARIA] == 0)
						lNaoConv := (nMoeda == 1 .And.(cPaisLoc=="BRA".Or.Empty(E5_BANCO)).or.( nMoeda==Val( SE5->E5_MOEDA) .And. cPaisLoc<>"BRA" .And. !Empty(E5_BANCO)) )
						aValor[I_CORRECAO_MONETARIA]+=Iif(lNaoConv, SE5->E5_VALOR,xMoeda(Iif(cpaisLoc=="BRA", SE5->E5_VLMOED2, SE5->E5_VALOR),Iif(!Empty(SE5->E5_MOEDA) .And. cPaisLoc<>"BRA",Val(SE5->E5_MOEDA),SE1->E1_MOEDA),IIf( nMoeda == NIL , 1 , nMoeda ),SE5->E5_DATA,,Iif(SE5->E5_TXMOEDA > 0, SE5->E5_TXMOEDA,)))
					EndIf
				End
				
				If lCancelado
					SE1->( DbSkip() )
					Loop
				EndIf			
				
			    // Indica se deve checar outras filiais   
				lVerFil := (!Empty(xFilial("SE1")) .And. !Empty(xFilial("SE5")) .And. Len(aFiliais) > 1)
	                                                                             
				// Caso o titulo tenha baixa e a mesma nao conste para a filial corrente (vetor aValor acima), verifica se existem baixas em oturas filiais
				If lVerFil .And. !Empty(SE1->E1_BAIXA) .And. aValor[11] == 0 
					F340VerBxFil( @aValor, aFiliais, nMoeda )
				EndIf
	
				If mv_par14 == 1
					nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,nMoeda,dDataMoeda,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					// Verifica se existem compensacoes em outras filiais para descontar do saldo, pois a SaldoTit() verifica
					// somente as movimentacoes da filial corrente.
					If lVerFil .And. nSaldo > 0
						nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("R",SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,,aFiliais),;
										SE1->E1_MOEDA,mv_par10,dDataMoeda,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0) ),;
										nDecs+1),nDecs)
					EndIf
				Else
					nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par10,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
				Endif
	
				If SE1->E1_VALOR <> SE1->E1_VALLIQ .Or. SE1->(E1_CSLL+E1_COFINS+E1_PIS+E1_IRRF+E1_INSS) > 0
					nTotAbat := SomaAbat ( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, "R", nMoeda )
					If Select("SE1new") == 0
						ChkFile("SE1",.F.,"SE1new")// Gerado um novo Alias para nao desposicionar o ponteiro
					Else                            // do Alias atual (SE1).
						DbSelectArea("SE1new")
					EndIf
					
					SE1new->(DbSetOrder(1))
					SE1new->(DbSeek(xFilial("SE1")+ SE1->E1_PREFIXO+ SE1->E1_NUM+ SE1->E1_PARCELA))
					
					Iif(SE1new->(Found()), cSeek := xFilial()+ SE1new->E1_PREFIXO+ SE1new->E1_NUM+;
					SE1new->E1_PARCELA+ SE1new->E1_CLIENTE+ SE1new->E1_LOJA, cSeek :="")
					
					//-- Quando MV_BR10925 = 1(na Baixa) a funcao SomaAbat nao considera PCC pois os titulos ainda nao foram gerados,
					//-- por isto feito o controle abaixo.
					Do While !Eof() .And.;
						cSeek == xFilial()+ SE1new->E1_PREFIXO+ SE1new->E1_NUM+;
						SE1new->E1_PARCELA+ SE1new->E1_CLIENTE+ SE1new->E1_LOJA
						//-- Verifico se ja foi realizado titulos de abatimento para o PCC(PIS, COFINS, CSLL)
						//-- Se sim nao sera somado o PCC novamente a variavel nTotAbat
						//-- Controle usado quando MV_BR10925 = 2(na Emissao).
						If "PI-"$SE1new->E1_TIPO // PIS
							lPI := .F.
						ElseIf "CF-"$SE1new->E1_TIPO // COFINS
							lCF := .F.
						ElseIf "CS-"$SE1new->E1_TIPO // CSLL
							lCS := .F.
						EndIf
						
						SE1new->(DbSkip())
					Enddo
					SE1new->(DbCloseArea())// Fecho o novo Alias para o SE1 pois nao sera usado depois.					
					//-- Somo abaixo PCC dependendo se houve ou nao os titulos de abatimentos do PCC, a funcao SomaAbat somente
					//-- considera o PCC na Emissao e coluna Abatimentos do relatorio ficava errado considerando somente
					//-- o IRRF.
					Iif (lPI , nTotAbat := nTotAbat + SE1->E1_PIS, 	nTotAbat := nTotAbat + 0)
					Iif (lCF , nTotAbat := nTotAbat + SE1->E1_COFINS, 	nTotAbat := nTotAbat + 0)
					Iif (lCS , nTotAbat := nTotAbat + SE1->E1_CSLL, 	nTotAbat := nTotAbat + 0)
					
				Else
					nTotAbat := 0
				EndIf	
	
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
				   ! ( MV_PAR14 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nSaldo -= nTotAbat
				EndIf
				
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_DECRESC == 0
					aValor[I_DESCONTO] += SE1->E1_DECRESC	
					nSaldo -= SE1->E1_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					aValor[I_JUROS] += SE1->E1_ACRESC
					nSaldo += SE1->E1_ACRESC
				Endif
				
				If SE1->E1_SALDO > 0 .And. Empty(SE1->E1_BAIXA)
					aValor[I_JUROS] += SE1->E1_ACRESC
					aValor[I_DESCONTO] += SE1->E1_DECRESC	
				Else
					aValor[I_JUROS] += SE1->E1_SDACRES
					aValor[I_DESCONTO] += SE1->E1_SDDECRE
				EndIf
				
				//Descricao da Situacao de cobranca			
				cSitCobr := Capital(FN022SITCB(SE1->E1_SITUACA)[9])
	
				If !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
					nTit1 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit7 += aValor[I_VALOR_RECEBIDO]
					nTit9 += nSaldo
				Else
					nTit1 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit7 -= aValor[I_VALOR_RECEBIDO]
					nTit9 -= nSaldo
				Endif
			
				nTit2 += (aValor[I_DESCONTO] - aValor[17])
				nTit3 += nTotAbat
				nTit4 += aValor[I_JUROS]
				nTit5 += aValor[I_MULTA]
				nTit6 += aValor[I_CORRECAO_MONETARIA]
				nTit8 += aValor[I_RECEB_ANT]
				nTit10 += SE1->E1_SDACRES    
			    nTit11 += SE1->E1_DECRESC    
				
				If cPaisLoc <> "BRA"
					cMotivo := SE1->E1_TIPO+"   "+ Substr(aValor[I_MOTBX],1,10)
	    	  		nvalor  := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nPos    := aScan(aMotBx,{|X| x[1]== cMotivo})
			
					If nPos > 0
			   		 	aMotBx[nPos][2] += nvalor
					else
		   				Aadd(aMotBx,{cMotivo,nvalor})
					Endif	
				Endif
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime os titulos dos clientes.                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
				//oSection2:Init()
				oSection2:PrintLine()
	
				dbSelectArea("SE1")
				dbSkip()
			Enddo
		
			oSection2:Finish()
			oSection1:Finish()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime os totais.						                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSection3:Init()
	
			If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+;
			     ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9)+ABS(nTit10)+ABS(nTit11) > 0 )
	        	
				nTot1  += nTit1
				nTot2  += nTit2
				nTot3  += nTit3
				nTot4  += nTit4
				nTot5  += nTit5
				nTot6  += nTit6
				nTot7  += nTit7
				nTot8  += nTit8
				nTot9  += nTit9
				nTot10 += nTit10
				nTot11 += nTit11
				
				nTotFil1  += nTit1
				nTotFil2  += nTit2
				nTotFil3  += nTit3
				nTotFil4  += nTit4
				nTotFil5  += nTit5
				nTotFil6  += nTit6
				nTotFil7  += nTit7
				nTotFil8  += nTit8			
				nTotFil9  += nTit9
				nTotFil10 += nTit10
				nTotFil11 += nTit11
	
				oSection3:PrintLine()
			EndIf		
			oSection3:Finish()
			oReport:ThinLine()
		Enddo
	
		SE1->(DbCloseArea())			
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprimir TOTAL por filial somente quan-³
		//³ do houver mais do que 1 filial.        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (lQuery .or. mv_par20 == 1) .and. Len( aSM0 ) > 1
			oSection4:Init()  
			oSection4:PrintLine()
			oSection4:Finish()
			oReport:ThinLine()
		Endif

		Store 0 To nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nTotFil10,nTotFil11
	EndIf

Next

cFilAnt := cFilOld

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o Total Geral.					                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lTotGer := .T.	

oSection3:Init()
oSection3:PrintLine()
oSection3:Finish()

If cPaisLoc <> "BRA"
	oSection3:Cell("VLRBAIXA"):Disable()
	oSection3:Cell("SALDO"	 ):Disable()
	oSection3:Init()
	oReport:PrintText(OemToAnsi(STR0027))		//"TOTAL POR MOTIVO : "

	For i:=1 to Len(aMotBx)
		If cTipoant==" "
	   	cTipoant:=subs(aMotBX[i][1],1,3)
		Endif
		If  ctipoant	== subs(aMotBX[i][1],1,3)
			oSection3:Cell("TXTTOTAL"):SetBlock( { || aMotBX[i] [1] } )
			oSection3:Cell("VALOR"	 ):SetBlock( { || aMotBX[i] [2] } )
			oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
			oSection3:PrintLine()
			ntotaltipo += aMotBX[i] [2] 
			ctipoant	  := subs(aMotBX[i][1],1,3)
		else 
			oSection3:Cell("TXTTOTAL"):SetBlock( { || OemToAnsi(STR0016) + ctipoant } )
			oSection3:Cell("VALOR"	 ):SetBlock( { || ntotaltipo } )
			oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
			ntotaltipo := 0
			oSection3:PrintLine()
			oReport:PrintText("")
			oSection3:Cell("TXTTOTAL"):SetBlock( { || aMotBX[i] [1] } )
			oSection3:Cell("VALOR"	 ):SetBlock( { || aMotBX[i] [2] } )
			oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
			oSection3:PrintLine()
			ntotaltipo += aMotBX[i] [2] 
			ctipoant   := subs(aMotBX[i][1],1,3)
		Endif				
	Next i
	oSection3:Cell("TXTTOTAL"):SetBlock( { || OemToAnsi(STR0016) + ctipoant } )
	oSection3:Cell("VALOR"	 ):SetBlock( { || ntotaltipo } )
	oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
	oSection3:PrintLine()
	oSection3:Finish()
EndIf

//Gestao
If lQuery
	If TcSrvType() != "AS/400"
		If Select("NEWSE1") > 0
			dbSelectArea("NEWSE1")
			dbCloseArea()		
		Endif
		dbSelectArea("SE1")
		dbCloseArea()
		ChkFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	Else
		dbSelectArea("SE1")
		dbClearFil()
		RetIndex( "SE1" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	Endif
Else
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
Endif

Return

USER FUNCTION XFRVS2R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 :=OemToAnsi(STR0001)  //"Este programa ir  emitir a posi‡„o de clientes "
Local cDesc2 :=OemToAnsi(STR0002)  //"referente a data base do sistema."
Local cDesc3 :=""
Local cString:="SE1"

Private aLinha:={}
Private aReturn:={ OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private cPerg:="FIN340"
Private cabec1,cabec2,titulo,wnrel,tamanho:="G",nomeprog:="FINR340"
Private nLastKey := 0
Private aOrd :={OemToAnsi(STR0020),OemToAnsi(STR0021) }  //"Por Codigo"###"Por Nome"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo:= OemToAnsi(STR0005)  //"Posicao dos Clientes "
cabec1:= OemToAnsi(STR0006)  //"Prf Numero      PC  Tip Valor Original Emissao   Vencto   Baixa                               R  E  C  E  B  I  M  E  N  T  O  S                                                                       "
cabec2:= OemToAnsi(STR0019) //"                                                                   Descontos    Abatimentos          Juros          Multa    Corr. Monet     Valor Baixado   Rec.Antecipado    Saldo Atual  Motivo          Situacao     Port."


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN340",.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // do Cliente                            ³
//³ mv_par02            // Ate o Cliente                         ³
//³ mv_par03            // Da Loja                               ³
//³ mv_par04            // Ate a Loja                            ³
//³ mv_par05            // Da Emissao                            ³
//³ mv_par06            // Ate a Emissao                         ³
//³ mv_par07            // Do Vencimento                         ³
//³ mv_par08            // Ate o Vencimento                      ³
//³ mv_par09            // Imprime os t¡tulos provis¢rios        ³
//³ mv_par10            // Qual a moeda                          ³
//³ mv_par11            // Reajusta pela DataBase ou Vencto      ³
//³ mv_par12            // Considera Faturados                   ³
//³ mv_par13            // Imprime Outras Moedas                 ³
//³ mv_par14            // Considera Data Base                   ³
//³ mv_par15            // Imprime Nome? (Razao Social/N.Reduzid)³
//³ mv_par16            // Natureza De ?                         ³
//³ mv_par17            // Natureza Ate?                         ³
//³ mv_par18            // Considera Liquidados?                 ³
//³ mv_par20			// Consid Filiais  ?  					³
//³ mv_par21			// da filial							³
//³ mv_par22			// a flial 								³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FINR340"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa340Imp(@lEnd,wnRel,cString)},Titulo)
Return


Static Function FA340Imp(lEnd,wnRel,cString)

Local CbTxt,cbCont
Local nTotAbat:=0,nOrdem
Local nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0,nTit6:=0,nTit7:=0,nTit8:=0,nTit9:=0
Local nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTot5:=0,nTot6:=0,nTot7:=0,nTot8:=0,nTot9:=0
Local cForAnt:=Space(6)
Local lContinua := .T.
Local aValor:={0,0,0,0,0,0,0,0,""}
Local nSaldo:=0
Local nMoeda:=0
Local dDataMoeda:=dDataBase		//SITCOB
LOCAL cCond1,cCond2,cChave,cIndex

#IFDEF TOP
	Local aStru 	:= SE1->(dbStruct()), ni
	Local cOrder
#ENDIF	
Local cFilterUser := aReturn[7]
Local ndecs :=Msdecimais(mv_par10)
Local cMotivo:= " "
Local aMotBx := {}
Local nValor:= 0
Local nPos := 0
Local cAliasSA1 := "SA1"
Local cSitCobr := " "   
Local nTotFil1:=0
Local nTotFil2:=0
Local nTotFil3:=0
Local nTotFil4:=0
Local nTotFil5:=0
Local nTotFil6:=0
Local nTotFil7:=0
Local nTotFil8:=0
Local nTotFil9:=0
Local aFiliais:= {}           
Local lVerFil := .F.
Local nInc		:= 0
Local aSM0		:= AdmAbreSM0()
Local cFilOld	:= cFilAnt
Local cFilSm0	:=	""
Local lCS:= lPI:= lCF:= .T.
Local cSeek:= ""

PRIVATE cFilDe,cFilAte

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par20 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par21	// Todas as filiais
	cFilAte:= mv_par22
Endif

aFiliais := FinRetFil()

For nInc := 1 To Len( aSM0 )
	cFilSm0	:=	""
	If aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte)
		cFilAnt	:= aSM0[nInc][2]
      cFilSm0	:=	aSM0[nInc][2] + ' - ' + aSM0[nInc][7]

		nMoeda := mv_par10
		Titulo += " - " + GetMv("MV_MOEDA1")
		nOrdem := aReturn[8]
	
		dbSelectArea("SE1")
		IF nOrdem = 1
			dbSetOrder(2)
			cChave := IndexKey()
			dbSeek(xFilial("SE1")+mv_par01+mv_par03,.t.)
			cCond1 := 'SE1->E1_CLIENTE+SE1->E1_LOJA <= mv_par02+mv_par04 .and. SE1->E1_FILIAL == xFilial("SE1")'
			cCond2 := "SE1->E1_CLIENTE+SE1->E1_LOJA"
			#IFDEF TOP
				cOrder := SqlOrder(cChave)
			#ENDIF
		Else
			If MV_PAR15=1
				cChave  := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			Else
				cChave  := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			EndIf

			#IFDEF TOP
				If TCSrvType() == "AS/400"
					cIndex	:= CriaTrab(nil,.f.)
					dbSelectArea("SE1")
					IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
					nIndex	:= RetIndex("SE1")
					dbSetOrder(nIndex+1)
				Else
					cOrder := SqlOrder(cChave)
				EndIf
			#ELSE
				cIndex	:= CriaTrab(nil,.f.)
				dbSelectArea("SE1")
				IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
				nIndex	:= RetIndex("SE1")
				dbSetIndex(cIndex+OrdBagExt())
				dbSetOrder(nIndex+1)
			#ENDIF
			cCond1 := ".T."
			cCond2 := "SE1->E1_NOMCLI+SE1->E1_CLIENTE+SE1->E1_LOJA"
			SE1->( dbGoTop() )
		EndIf
		SetRegua(RecCount())
	
		While !Eof() .And. lContinua .And. &cCond1		
		
			#IFNDEF TOP
				// Nao considera Ti. Liquidados ou geradores de liquidacao
				dbSelectArea("SE5")
				dbSetorder(5)

				IF SE5->(MsSeek(xFilial('SE5')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))

					cChaveE1 := "xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO"
					cChaveE5 := "xFilial('SE5')+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO"
						
					While !EOF() .And. (&(cChaveE1) == &(cChaveE5))
		 				If (mv_par18 == 2 .AND. SE5->E5_MOTBX == "LIQ" ) .OR. SE5->E5_MOTBX == "DSD"
							lSai := .T.
							Exit
						EndIf
						SE5->(dbSkip())
					Enddo
					If lSai
						SE1->(dbSkip())
						Loop
					Endif

				Endif
				dbSelectArea("SE1")
	
			#ENDIF
			
			If lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0014)  //"CANCELADO PELO OPERADOR"
				Exit
			Endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			#IFDEF TOP
				If TcSrvType() != "AS/400"
					dbSelectArea("NEWSE1")
					dbGoto(SE1->RECNO)
				Endif
			#Endif
		
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSelectArea("SE1")
				dbSkip()
				Loop
			Endif
	
			dbSelectArea("SE1")	
		
			nCont:=1
			nTit1:=nTit2:=nTit3:=nTit4:=nTit5:=nTit6:=nTit7:=nTit8:=nTit9:=0
			cForAnt:= &cCond2
		
			While &cCond2 == cForAnt .And. lContinua .And. &cCond1 .And. !Eof()
				
				#IFNDEF TOP
	
		   			If mv_par19 == 2
						If (!Empty(SE1->E1_RECIBO) .And. SE1->E1_ORIGEM <> "FINA087A")
						SE1->( dbSkip() )
						Loop
						Endif
					Endif  
		
				#ENDIF
			
			
				If lEnd
					@PROW()+1,001 PSAY OemToAnsi(STR0014)  //"CANCELADO PELO OPERADOR"
					lContinua := .F.
					Exit
				Endif
			
				IncRegua()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Considera filtro do usuario                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				#IFDEF TOP
					If TcSrvType() != "AS/400"
						dbSelectArea("NEWSE1")
						dbGoto(SE1->RECNO)
					Endif
				#Endif
	
				If !Empty(cFilterUser).and.!(&cFilterUser)
					dbSelectArea("SE1")
					dbSkip()
					Loop
				Endif
	
				dbSelectArea("SE1")		
				
				If !Fr340Skip("SE1")
					dbSelectArea("SE1")
					dbSkip()
					Loop
				EndIf
				
				#IFDEF TOP
					If TcSrvType() == "AS/400"
						dbSelectArea(cAliasSA1)
						dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
					Endif
				#ELSE
					dbSelectArea(cAliasSA1)
					dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				#ENDIF
			
				IF li > 58     
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")))
				EndIF
			
			  	If nCont = 1
					@li,0 PSAY OemToAnsi(STR0015)+(cAliasSA1)->A1_COD+"-"+(cAliasSA1)->A1_LOJA+" "+IIF(mv_par15 == 1, (cAliasSA1)->A1_NOME,(cAliasSA1)->A1_NREDUZ)  //"CLIENTE : "
					Li+= 2
					nCont++
				Endif
			
				dbSelectArea("SE1")
			                                                                     
				IF mv_par11 == 1
					dDataMoeda	:=	dDataBase
				Else
					dDataMoeda	:=	SE1->E1_VENCREA
				Endif
			
			    // Indica se deve checar outras filiais   
				lVerFil := (!Empty(xFilial("SE1")) .And. !Empty(xFilial("SE5")) .And. Len(aFiliais) > 1)
			
				aValor := Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,nMoeda,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA,,,,mv_par14 == 1)
	            	            				
				DbSelectArea("SE5")
				DbSetOrder(2)
				
				If DbSeek(xFilial("SE5") + "CM" + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + DtoS(SE1->E1_BAIXA) + SE1->E1_CLIENTE + SE1->E1_LOJA ) //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ 
				
					If !(alltrim(SE1->E1_TIPO) $ MVRECANT+"/"+MVPAGANT+"/"+MV_CRNEG+"/"+MV_CPNEG) .AND. SE5->E5_TIPODOC $ ("CM") .AND. (aValor[I_CORRECAO_MONETARIA] == 0)
						lNaoConv := (nMoeda == 1 .And.(cPaisLoc=="BRA".Or.Empty(E5_BANCO)).or.( nMoeda==Val( SE5->E5_MOEDA) .And. cPaisLoc<>"BRA" .And. !Empty(E5_BANCO)) )
						aValor[I_CORRECAO_MONETARIA]+=Iif(lNaoConv, SE5->E5_VALOR,xMoeda(Iif(cpaisLoc=="BRA", SE5->E5_VLMOED2, SE5->E5_VALOR),Iif(!Empty(SE5->E5_MOEDA) .And. cPaisLoc<>"BRA",Val(SE5->E5_MOEDA),SE1->E1_MOEDA),IIf( nMoeda == NIL , 1 , nMoeda ),SE5->E5_DATA,,Iif(SE5->E5_TXMOEDA > 0, SE5->E5_TXMOEDA,)))
					EndIf
				End
				                                                                 
				// Caso o titulo tenha baixa e a mesma nao conste para a filial corrente (vetor aValor acima), verifica se existem baixas em oturas filiais
				If lVerFil .And. !Empty(SE1->E1_BAIXA) .And. aValor[11] == 0 
					F340VerBxFil( @aValor, aFiliais, nMoeda )
				EndIf
	
				If mv_par14 == 1
					nSaldo:=SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,nMoeda,dDataMoeda,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					// Verifica se existem compensacoes em outras filiais para descontar do saldo, pois a SaldoTit() verifica
					// somente as movimentacoes da filial corrente.
					If lVerFil .And. nSaldo > 0
						nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("R",SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,,aFiliais),;
										SE1->E1_MOEDA,mv_par10,dDataMoeda,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0) ),;
										nDecs+1),nDecs)
					EndIf
				Else
					nSaldo:=xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par10,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
				Endif
	
				If SE1->E1_VALOR <> SE1->E1_VALLIQ .Or. SE1->(E1_CSLL+E1_COFINS+E1_PIS+E1_IRRF+E1_INSS) > 0
					nTotAbat := SomaAbat ( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, "R", nMoeda )
					If Select("SE1new") == 0
						ChkFile("SE1",.F.,"SE1new")// Gerado um novo Alias para nao desposicionar o ponteiro
					Else                            // do Alias atual (SE1).
						DbSelectArea("SE1new")
					EndIf
					
					SE1new->(DbSetOrder(1))
					SE1new->(DbSeek(xFilial("SE1")+ SE1->E1_PREFIXO+ SE1->E1_NUM+ SE1->E1_PARCELA))
					
					Iif(SE1new->(Found()), cSeek := xFilial()+ SE1new->E1_PREFIXO+ SE1new->E1_NUM+;
					SE1new->E1_PARCELA+ SE1new->E1_CLIENTE+ SE1new->E1_LOJA, cSeek :="")
					
					//-- Quando MV_BR10925 = 1(na Baixa) a funcao SomaAbat nao considera PCC pois os titulos ainda nao foram gerados,
					//-- por isto feito o controle abaixo.
					Do While !Eof() .And.;
						cSeek == xFilial()+ SE1new->E1_PREFIXO+ SE1new->E1_NUM+;
						SE1new->E1_PARCELA+ SE1new->E1_CLIENTE+ SE1new->E1_LOJA
						//-- Verifico se ja foi realizado titulos de abatimento para o PCC(PIS, COFINS, CSLL)
						//-- Se sim nao sera somado o PCC novamente a variavel nTotAbat
						//-- Controle usado quando MV_BR10925 = 2(na Emissao).
						If "PI-"$SE1new->E1_TIPO // PIS
							lPI := .F.
						ElseIf "CF-"$SE1new->E1_TIPO // COFINS
							lCF := .F.
						ElseIf "CS-"$SE1new->E1_TIPO // CSLL
							lCS := .F.
						EndIf
						
						SE1new->(DbSkip())
					Enddo
					SE1new->(DbCloseArea())// Fecho o novo Alias para o SE1 pois nao sera usado depois.					
					//-- Somo abaixo PCC dependendo se houve ou nao os titulos de abatimentos do PCC, a funcao SomaAbat somente
					//-- considera o PCC na Emissao e coluna Abatimentos do relatorio ficava errado considerando somente
					//-- o IRRF.
					Iif (lPI , nTotAbat := nTotAbat + SE1->E1_PIS, 	nTotAbat := nTotAbat + 0)
					Iif (lCF , nTotAbat := nTotAbat + SE1->E1_COFINS, 	nTotAbat := nTotAbat + 0)
					Iif (lCS , nTotAbat := nTotAbat + SE1->E1_CSLL, 	nTotAbat := nTotAbat + 0)
											
				Else	
					nTotAbat := 0
				EndIf
				
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
					aValor[I_DESCONTO] += SE1->E1_DECRESC	
					nSaldo -= SE1->E1_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					aValor[I_JUROS] += SE1->E1_ACRESC
					nSaldo += SE1->E1_ACRESC
				Endif
				
				If SE1->E1_SALDO > 0 .And. Empty(SE1->E1_BAIXA)
					aValor[I_JUROS] += SE1->E1_ACRESC
					aValor[I_DESCONTO] += SE1->E1_DECRESC	
				Else
					aValor[I_JUROS] += SE1->E1_SDACRES
					aValor[I_DESCONTO] += SE1->E1_SDDECRE
				EndIf
	
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
				   ! ( MV_PAR14 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nSaldo -= nTotAbat
				EndIf

				//Descricao da Situacao de cobranca			
				cSitCobr := Capital(FN022SITCB(SE1->E1_SITUACA)[9])
				
				@li,  0 PSAY SE1->E1_PREFIXO+"-"+SE1->E1_NUM
				// Em ambiente Portugal, pula linha se utilizada numeracao de nota maior que 12 posicoes
				If cPaisLoc == "PTG" .And. nTamE1Num > 12
					li++
				EndIf	
				@li, 14 PSAY SE1->E1_PARCELA
				@li, 18 PSAY SE1->E1_TIPO          
				
				@li, 22 PSAY SayValor(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),18,;
				SE1->E1_TIPO$MVRECANT+","+MV_CRNEG,nDecs)
		
				@li, 41 PSAY SE1->E1_EMISSAO
				@li, 52 PSAY SE1->E1_VENCREA
				IF dDataBase >= SE1->E1_BAIXA .Or. (mv_par14 == 2 .And. !Empty(SE1->E1_BAIXA))
					@li, 63 PSAY IIF(!Empty(SE1->E1_BAIXA),SE1->E1_BAIXA," ")
				Endif
				@li, 74 PSAY aValor[I_DESCONTO]               Picture TM(aValor[I_DESCONTO]			 ,13,nDecs)
				@li, 88 PSAY nTotAbat                         Picture TM(nTotAbat					 ,13,nDecs)
				@li,100 PSAY aValor[I_JUROS]                  Picture TM(aValor[I_JUROS]			 ,13,nDecs)
				@li,113 PSAY aValor[I_MULTA]                  Picture TM(aValor[I_MULTA]			 ,13,nDecs)
				@li,126 PSAY aValor[I_CORRECAO_MONETARIA]     Picture TM(aValor[I_CORRECAO_MONETARIA],13,nDecs)
				@li,140 PSAY aValor[I_VALOR_RECEBIDO]		  Picture TM(aValor[I_VALOR_RECEBIDO]	  ,19,nDecs)
				@li,161 PSAY aValor[I_RECEB_ANT]              Picture TM(aValor[I_RECEB_ANT]		  ,18,nDecs)   	
			
				@li,180 PSAY SayValor(nSaldo,18,SE1->E1_TIPO $ MVRECANT+","+MV_CRNEG,nDecs)
				@li,199 PSAY Pad(aValor[I_MOTBX],9)
				@li,209 PSAY SUBSTR(cSitCobr,1,8)
				@li,218 PSAY SE1->E1_PORTADO                      
			
				If ! ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG )
					nTit1+= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit7+=aValor[I_VALOR_RECEBIDO]
					nTit9+=nSaldo
				Else
					nTit1-= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit7-=aValor[I_VALOR_RECEBIDO]
					nTit9-=nSaldo
				Endif
			
				nTit2+=aValor[I_DESCONTO]
				nTit3+=nTotAbat
				nTit4+=aValor[I_JUROS]
				nTit5+=aValor[I_MULTA]
				nTit6+=aValor[I_CORRECAO_MONETARIA]
				nTit8+=aValor[I_RECEB_ANT]
			
				If cPaisLoc<>"BRA"
					cMotivo:= SE1->E1_TIPO+"   "+ Substr(aValor[I_MOTBX],1,10)
			        nvalor:=xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nPos := aScan(aMotBx,{|X| x[1]== cMotivo})
			
					If nPos > 0
				   	 	aMotBx[nPos][2]+= nvalor
					else
	   					Aadd(aMotBx,{cMotivo,nvalor})
					Endif	
				Endif
				dbSelectArea("SE1")
				dbSkip()
				li++
			Enddo
		
			If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9) > 0 )
				ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9,nDecs)
				li++
				nTot1 += nTit1
				nTot2 += nTit2
				nTot3 += nTit3
				nTot4 += nTit4
				nTot5 += nTit5
				nTot6 += nTit6
				nTot7 += nTit7
				nTot8 += nTit8
				nTot9 += nTit9    
				
				nTotFil1 += nTit1
				nTotFil2 += nTit2
				nTotFil3 += nTit3
				nTotFil4 += nTit4
				nTotFil5 += nTit5
				nTotFil6 += nTit6
				nTotFil7 += nTit7
				nTotFil8 += nTit8			
				nTotFil9 += nTit9			
			Endif
		Enddo        
	
		SE1->(DbCloseArea())			
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprimir TOTAL por filial somente quan-³
		//³ do houver mais do que 1 filial.        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if mv_par20 == 1 .and. Len( aSM0 ) > 1
			ImpFil340(nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nDecs,cFilSm0)	
		Endif
		Store 0 To nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9
		
		If Empty(xFilial("SE1"))		
			Exit
		Endif	
	EndIf
Next

cFilAnt := cFilOld

IF li > 55 .and. li != 80
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
End

IF li != 80
	If cPaisLoc<>"BRA"
		ImpTotG(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,aMotBx,nDecs)
	else	
		ImpTotG(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,,nDecs)
	Endif
	roda(cbcont,cbtxt,tamanho)
EndIF

Set Device TO Screen

#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		If Select("NEWSE1") > 0
			dbSelectArea("NEWSE1")
			dbCloseArea()		
		Endif
		dbSelectArea("SE1")
		dbCloseArea()
		ChkFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	else
		dbSelectArea("SE1")
		dbClearFil()
		RetIndex( "SE1" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9,nDecs)

li++
@li,  0 PSAY OemToAnsi(STR0016)  //"Totais : "
@li,023 PSAY nTit1   Picture TM(nTit1,17,nDecs)
@li,074 PSAY nTit2   Picture TM(nTit2,13,nDecs)
@li,088 PSAY nTit3   Picture TM(nTit3,13,nDecs)
@li,101 PSAY nTit4   Picture TM(nTit4,13,nDecs)
@li,114 PSAY nTit5   Picture TM(nTit5,13,nDecs)
@li,127 PSAY nTit6   Picture TM(nTit6,13,nDecs)
@li,141 PSAY nTit7   Picture TM(nTit7,19,nDecs)
@li,161 PSAY nTit8   Picture TM(nTit8,19,nDecs)
@li,182 PSAY nTit9   Picture TM(nTit9,17,nDecs)
li++
@li,000 PSAY Replicate("-",220)
li++
Return(.T.)

Static Function ImpTotg(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,aMotBx,nDecs)
Local ntotaltipo:=0
Local cTipoant:=" "
Local i
li++
@li,0 PSAY OemToAnsi(STR0017)  //"TOTAL GERAL : "
@li,021 PSAY nTot1   Picture TM(nTot1,17,nDecs)
@li,074 PSAY nTot2   Picture TM(nTot2,13,nDecs)
@li,088 PSAY nTot3   Picture TM(nTot3,13,nDecs)
@li,101 PSAY nTot4   Picture TM(nTot4,13,nDecs)
@li,114 PSAY nTot5   Picture TM(nTot5,13,nDecs)
@li,127 PSAY nTot6   Picture TM(nTot6,13,nDecs)
@li,141 PSAY nTot7   Picture TM(ntot7,19,nDecs)
@li,161 PSAY nTot8   Picture TM(nTot8,19,nDecs)
@li,182 PSAY nTot9   Picture TM(nTot9,17,nDecs)
li++

If cPaisLoc<>"BRA"
	@li,0 PSAY OemToAnsi(STR0027)     //"TOTAL POR MOTIVO : "
	li:=li+2

	aMotBX:=asort(aMotBX,,,{|x,y| x[1] < y[1]})
	For i:=1 to Len(aMotBx)
		If cTipoant==" "
	   	cTipoant:=subs(aMotBX[i][1],1,3)
		Endif
		If  ctipoant	== subs(aMotBX[i][1],1,3)
			@ Li,001 PSAY aMotBX[i] [1]
			@ Li,025 PSAY aMotBX[i] [2] Picture PesqPict("SE1","E1_VALOR",17,MV_PAR10)
			ntotaltipo += aMotBX[i] [2] 
			ctipoant:=subs(aMotBX[i][1],1,3)
		else 
			@ Li,001 PSAY OemToAnsi(STR0016) + ctipoant
			@ Li,025 PSAY ntotaltipo PicTure PesqPict("SE1","E1_VALOR",17,MV_PAR10)	
			ntotaltipo:=0
			li:=li+2
			@ Li,001 PSAY aMotBX[i] [1]
			@ Li,025 PSAY aMotBX[i] [2] Picture PesqPict("SE1","E1_VALOR",17,MV_PAR10)
			ntotaltipo += aMotBX[i] [2] 
			ctipoant:=subs(aMotBX[i][1],1,3)
		Endif	
		IF li > 55 
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		End
		Li++
	Next i
	@ Li,001 PSAY OemToAnsi(STR0016) + ctipoant
	@ Li,025 PSAY ntotaltipo PicTure PesqPict("SE1","E1_VALOR",17,MV_PAR10)
Endif
Return(.T.)


Static Function FR340FIL()
Local cString

cString := 'E1_FILIAL="'+xFilial()+'".And.'
cString += 'dtos(E1_EMISSAO)>="'+dtos(mv_par05)+'".and.dtos(E1_EMISSAO)<="'+dtos(mv_par06)+'".And.'
cString += 'dtos(E1_VENCREA)>="'+dtos(mv_par07)+'".and.dtos(E1_VENCREA)<="'+dtos(mv_par08)+'".And.'
cString += 'E1_CLIENTE>="'+mv_par01+'".and.E1_CLIENTE<="'+mv_par02+'".And.'
cString += 'E1_LOJA>="'+mv_par03+'".and.E1_LOJA<="'+mv_par04+'".and.'
cString += 'E1_NATUREZ>="'+mv_par16+'".and.E1_NATUREZ<="'+mv_par17+'"'
If cPaisLoc<>"BRA"
	cString +='.and. !(E1_TIPO$"TF~CH")'
EndIf

Return cString


Static Function SayValor(nNum,nTam,lInvert,nDecs, nTipImp)
Local cPicture,cRetorno
cPicture := tm(nNum,nTam,nDecs)
If nTipImp == 4
	cRetorno := nNum
Else
	cRetorno := Transform(nNum,cPicture)
EndIf
IF nNum<0 .or. lInvert
	cPicture := tm(nNum,nTam-2,nDecs)
	cRetorno := Transform(nNum,cPicture)
   cRetorno := Right(Space(10)+"("+Alltrim(StrTran(cRetorno,"-",""))+")",nTam+1)
Endif
Return cRetorno

Static Function Fr340Skip()

Local lRet := .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta dentro dos parametros                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
	SE1->E1_LOJA    < mv_par03 .OR. SE1->E1_LOJA    > mv_par04 .OR. ;
	SE1->E1_EMISSAO < mv_par05 .OR. SE1->E1_EMISSAO > mv_par06 .OR. ;
	SE1->E1_VENCREA < mv_par07 .OR. SE1->E1_VENCREA > mv_par08 .OR. ;
	SE1->E1_NATUREZ < mv_par16 .OR. SE1->E1_NATUREZ > mv_par17 .OR. ;
	SE1->E1_TIPO $ MVABATIM
	lRet := .F.
	
ElseIF SE1->E1_EMISSAO > dDataBase
	lRet := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo ‚ provis¢rio                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf (SE1->E1_TIPO $ MVPROVIS .and. mv_par09==2)
	lRet := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo foi aglutinado em uma fatura            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf !Empty(SE1->E1_FATURA) .and. Substr(SE1->E1_FATURA,1,6) != "NOTFAT"
	lRet := IIF(mv_par12 == 1, .T., .F.)	// Considera Faturados = mv_par12
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve imprimir outras moedas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Elseif mv_par13 == 2 // nao imprime
	If SE1->E1_MOEDA != mv_par10 //verifica moeda do campo=moeda parametro
		lRet	:= .F.
	Endif
Endif

Return lRet


STATIC Function ImpFil340(nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nDecs,cFilSm0)
DEFAULT nDecs := Msdecimais(mv_par15)

li--
IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
EndIF

@li,000 PSAY OemToAnsi(STR0058)+" "+Iif(mv_par20==1,Alltrim(cFilSm0),"")  //"T O T A L   F I L I A L ----> "
@li,050 PSAY nTotFil1 Picture TM(nTotFil1,16,nDecs)
@li,077 PSAY nTotFil2 Picture TM(nTotFil2,10,nDecs)
@li,091 PSAY nTotFil3 Picture TM(nTotFil3,10,nDecs)
@li,104 PSAY nTotFil4 Picture TM(nTotFil4,10,nDecs)
@li,117 PSAY nTotFil5 Picture TM(nTotFil5,10,nDecs)
@li,130 PSAY nTotFil6 Picture TM(nTotFil6,10,nDecs)
@li,141 PSAY nTotFil7 Picture TM(nTotFil7,19,nDecs)
@li,161 PSAY nTotFil8 Picture TM(nTotFil8,19,nDecs)
@li,189 PSAY nTotFil9 Picture TM(nTotFil9,10,nDecs)
li++
@li,000 PSAY Replicate("-",220)
li+=2
Return .T.


Static Function F340VerBxFil( aValor, aFiliais, nMoeda )

Local aTmpValor := {}
Local nX		:= 0
Local nY		:= 0

// Pesquisa baixas do titulo em outras filiais
For nX := 1 To Len(aFiliais)
	If aFiliais[nX] <> SE1->E1_FILIAL
		AAdd( aTmpValor, Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,nMoeda,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA,aFiliais[nX],,,mv_par14 == 1) )
	EndIf	
Next nX                                       

// Atualiza valores das baixas em outras filiais no vetor definitivo aValor
For nX := 1 To Len(aTmpValor)
	For nY := 1 To Len(aValor)
		If nY <> 9	// Nao soma historico de baixa
			aValor[nY] += aTmpValor[nX,nY]
		EndIf	
	Next nY
Next nX                                                                    

// Para impressao, guarda o historico da primeira baixa encontrada
If Empty( aValor[9] )
	For nX := 1 To Len( aTmpValor )
		If !Empty( aTmpValor[ nX , 9 ] )
			aValor[ 9 ] := aTmpValor[ nX , 9 ]
			Exit
		EndIf
	Next nX
EndIf

aSize( aTmpValor , 0 )
aTmpValor := Nil

Return( aValor )


Static Function AdmAbreSM0()
	Local aArea			:= SM0->( GetArea() )
	Local aAux			:= {}
	Local aRetSM0		:= {}
	Local lFWLoadSM0	:= .T.
	Local lFWCodFilSM0 	:= .T.

	If lFWLoadSM0
		aRetSM0	:= FWLoadSM0()
	Else
		DbSelectArea( "SM0" )
		SM0->( DbGoTop() )
		While SM0->( !Eof() )
			aAux := { 	SM0->M0_CODIGO,;
						IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
						"",;
						"",;
						"",;
						SM0->M0_NOME,;
						SM0->M0_FILIAL }

			aAdd( aRetSM0, aClone( aAux ) )
			SM0->( DbSkip() )
		End
	EndIf

	RestArea( aArea )
Return aRetSM0


Static Function Fr340Val()
Local lRet := .T.
#IFNDEF TOP
	If (Mv_par15 == 2 )
		lRet := .F.
		MsgAlert(STR0059) //"Opção válida somente para ambiente TOP!"
	EndIf	
#ENDIF

Return lRet                      

Static Function FR340AbreSM0(aSelFil)               

Local aArea			:= SM0->( GetArea() )
Local aRetSM0		:= {}
Local nLaco			:= 0
			
aRetSM0	:= FWLoadSM0()

If Len(aRetSM0) != Len(aSelFil)

	For nLaco := Len(aRetSM0) To 1 Step -1
		cFilx := aRetSm0[nLaco,SM0_CODFIL]
		nPosFil := Ascan(aSelFil,aRetSm0[nLaco,SM0_CODFIL])
	
		If nPosFil == 0
			ADel(aRetSM0,nLaco)
			aSize(aRetSM0, Len(aRetSM0)-1)
		Endif
	Next
Endif

aSort(aRetSm0,,,{ |x,y| x[SM0_CODFIL] < y[SM0_CODFIL] } )
RestArea( aArea )

Return aClone(aRetSM0)

STATIC FUNCTION BuscaMoeda()
LOCAL cSavArea:=Alias()
LOCAL nMoeda:=0
LOCAL nSavOrd:=0

If SE5->E5_RECPAG == "R"
	dbSelectArea("SE1")
Else
	dbSelectArea("SE2")
Endif
nSavOrd := IndexOrd()   // Guarda ordem do SE1/SE2
dbSetOrder(1)
If dbSeek(cFilial+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+Iif(E5_RECPAG=="R","",E5_CLIFOR)))
	If SE5->E5_RECPAG == "R"
		nMoeda:=E1_MOEDA
	Else
		nMoeda:=E2_MOEDA
	Endif
Endif
dbSetOrder(nSavOrd)   // Restaura ordem do SE1/SE2
dbSelectArea(cSavArea)
Return nMoeda
