#Include "FINR340.CH"
#Include "PROTHEUS.CH"
#Include "fwcommand.ch"

#Define I_CORRECAO_MONETARIA         1
#Define I_DESCONTO                   2
#Define I_JUROS                      3
#Define I_MULTA                      4
#Define I_VALOR_RECEBIDO             5
#Define I_VALOR_PAGO                 6
#Define I_RECEB_ANT                  7
#Define I_PAGAM_ANT                  8
#Define I_MOTBX                      9

User Function XFIRPCVE()

Local oReport
Local aArea := GetArea()   

oReport := ReportDef()
oReport:PrintDialog()

RestArea(aArea)  

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ReportDef � Autor � Marcio Menon		   � Data �  16/08/06  ���
�������������������������������������������������������������������������͹��
���Descricao � Definicao do objeto do relatorio personalizavel e das      ���
���          � secoes que serao utilizadas.                               ���
�������������������������������������������������������������������������͹��
���Parametros� EXPC1 - Grupo de perguntas do relatorio                    ���
�������������������������������������������������������������������������͹��
���Uso       � 												              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local cReport 	:= "FINR340"	// Nome do relatorio
Local cDescri 	:= OemToAnsi(STR0001)+ OemToAnsi(STR0002)	//"Este programa ir� emitir a posi��o de clientes " "referente a data base do sistema."
Local cTitulo 	:= OemToAnsi(STR0005)	//"Posicao dos Clientes "
Local cPerg		:= "FIN340"	// Nome do grupo de perguntas
Local aOrdem	:= {OemToAnsi(STR0020),OemToAnsi(STR0021)}	//"Por Codigo"###"Por Nome"
Local nTamVal	:= TamSX3("E1_VALOR")[1] + 4
Local lFinr340	:= AllTrim(FUNNAME()) == "XFIRPCVE"

oReport := TReport():New(cReport, cTitulo + " - ", cPerg, {|oReport| ReportPrint(oReport, cTitulo)}, cDescri) 

If lFinr340
	pergunte("FIN340",.F.)
EndIf

oReport:SetLandscape() 		//Imprime o relatorio no formato paisagem
//Gestao
oReport:SetUseGC(.F.)

//������������������������������������������������������������������������Ŀ
//�                                                                        �
//�                      Definicao das Secoes                              �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//� Secao 01                                                               �
//��������������������������������������������������������������������������
oSection1 := TRSection():New(oReport, STR0034,"SA1", aOrdem) //"Dados do Cliente"

TRCell():New(oSection1,"TXTCLI"  ,     , STR0035	,									,10						,/*lPixel*/,{|| STR0015 })	//"Cliente ## CLIENTE : "
TRCell():New(oSection1,"A1_COD"  ,"SA1",  			,PesqPict("SA1","A1_COD" ),TamSX3("A1_COD" )[1],/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"A1_LOJA" ,"SA1",			,PesqPict("SA1","A1_LOJA"),TamSX3("A1_LOJA")[1],/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"A1_NOME" ,"SA1",			,PesqPict("SA1","A1_NOME"),TamSX3("A1_NOME")[1],/*lPixel*/,{|| IIF(mv_par15 == 1, SA1->A1_NOME, SA1->A1_NREDUZ) } )
TRCell():New(oSection1,"POSCLI" , ,			,"@!"   ,18,/*lPixel*/,{|| "POSI��O CLIENTE: " },"RIGHT",,"RIGHT"  )
TRCell():New(oSection1,"A1_SALDUP" ,"SA1",			,PesqPict("SA1","A1_SALDUP"),TamSX3("A1_SALDUP")[1],/*lPixel*/,{|| SA1->A1_SALDUP }, "LEFT", , "LEFT" )

oSection1:SetHeaderSection(.F.)	//Nao imprime o cabe�alho da secao

//������������������������������������������������������������������������Ŀ
//� Secao 02                                                               �
//��������������������������������������������������������������������������
oSection2 := TRSection():New(oSection1, STR0036,{"SE1","SED"}, aOrdem) //"Titulos"

TRCell():New(oSection2,"E1_PREFIXO" ,"SE1" , STR0037	, PesqPict("SE1","E1_PREFIXO") 	, 3 ,/*lPixel*/,{ || SE1->E1_PREFIXO })//"Prf"
TRCell():New(oSection2,"E1_NUM"	  	,"SE1" , STR0038 	, PesqPict("SE1","E1_NUM") 	 	, 12     ,/*lPixel*/,{ || SE1->E1_NUM 		})//"Numero"
TRCell():New(oSection2,"E1_PARCELA" ,"SE1" , STR0039	, PesqPict("SE1","E1_PARCELA")	, 4 ,/*lPixel*/,{ || SE1->E1_PARCELA })//"PC"
TRCell():New(oSection2,"E1_TIPO"  	,"SE1" ,			, PesqPict("SE1","E1_TIPO")    	, 4    ,/*lPixel*/,{ || SE1->E1_TIPO		})
TRCell():New(oSection2,"VALOR"	   	,      , STR0040 	, 								, 18 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Original"
TRCell():New(oSection2,"E1_EMISSAO" ,"SE1" , STR0041 	, PesqPict("SE1","E1_EMISSAO") 	, 12 ,/*lPixel*/,{ || SE1->E1_EMISSAO })//"Emissao"
TRCell():New(oSection2,"E1_VENCREA" ,"SE1" , STR0042 	, PesqPict("SE1","E1_VENCREA") 	, 12 ,/*lPixel*/,{ || SE1->E1_VENCREA })//"Vencto"
TRCell():New(oSection2,"BAIXA" 		,  	   , STR0043	, PesqPict("SE1","E1_BAIXA")   	, 12 ,/*lPixel*/,/*CodeBlock*/)	//"Baixa"
TRCell():New(oSection2,"DAD" 	    ,      , "DES/ABA/DEC", Tm(0,12)					, 10 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") 
TRCell():New(oSection2,"JMA" 	    ,      , "JUR/MUL/ACR", Tm(0,12)					, 10 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"VLRBAIXA"	,      , STR0049	, Tm(0,12) 						, 18 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Baixado"
TRCell():New(oSection2,"SALDO" 		,      , STR0051	, 								, 20 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Saldo Atual"
 
oSection2:SetHeaderSection(.T.)

//Faz o alinhamento do cabecalho das celulas
oSection2:Cell("VLRBAIXA"):SetHeaderAlign("RIGHT")
oSection2:Cell("SALDO"	 ):SetHeaderAlign("RIGHT")
//oSection2:SetLineBreak(.T.)
oSection3 := TRSection():New(oReport, STR0055) //"Totais"

TRCell():New(oSection3,"TXTTOTAL"	,       , STR0055	,						    , Iif(cPaisloc=="MEX",32,21) ,/*lPixel*/,/*CodeBlock*/) //"Totais"	
TRCell():New(oSection3,"VALOR"	 	,		, STR0040  	, PesqPict("SE1","E1_VALOR") , 15 ,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT")//"Valor Original"
TRCell():New(oSection3,"SCOL1"		,       , "" 		, Tm(0,13)     	   	,11,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
TRCell():New(oSection3,"SCOL2"		,       , "" 		, Tm(0,13)     	   	,11,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
TRCell():New(oSection3,"SCOL3"		,       , "" 		, Tm(0,13)     	   	,11,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
TRCell():New(oSection3,"DAD"		,       , "DES/ABA/DEC", Tm(0,13)      	,13,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
TRCell():New(oSection3,"JMA"		, 	    , ""		,Tm(0,13)         	,10  ,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Abatimentos"
TRCell():New(oSection3,"VLRBAIXA"	,    	, STR0049  	,Tm(0,19)               	,16  ,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Baixado"
TRCell():New(oSection3,"SALDO" 		, 	    , STR0051  	,Tm(0,nTamVal)			    ,19 ,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Saldo Atual"

oSection3:SetLineBreak(.T.)	

oSection3:SetLinesBefore(1)
oSection3:Cell("SCOL1"):Hide()
oSection3:Cell("SCOL2"):Hide()
oSection3:Cell("SCOL3"):Hide()
oSection3:SetHeaderSection(.F.)	//Nao imprime o cabe�alho da secao

oSection4 := TRSection():New(oReport, STR0057) //"Totais/Filial"

TRCell():New(oSection4,"TXTTOTAL"	,       , STR0055	,								, 26 ,.T.,/*CodeBlock*/) //"Totais"
TRCell():New(oSection4,"VALOR"	   	,		, STR0040 	, PesqPict("SE1","E1_VALOR")	, 0 ,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT")//"Valor Original"
TRCell():New(oSection4,"SCOL1"		,       , "" 	, Tm(0,13)     	   					, 11,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
TRCell():New(oSection4,"SCOL2"		,       , "" 				, Tm(0,13)     	   	,11,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
TRCell():New(oSection4,"SCOL3"		,       , "" 				, Tm(0,13)     	   	,11,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
TRCell():New(oSection4,"DAD" 	, 	   		, "DES/ABA/DEC"		, Tm(0,13)               ,14,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Abatimentos"
TRCell():New(oSection4,"JMA" 		,       , "JUR/MUL/ACR", Tm(0,13)               ,10  ,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Juros"
TRCell():New(oSection4,"VLRBAIXA"	,    	, STR0049	, Tm(0,19)                  ,18  ,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Baixado"
TRCell():New(oSection4,"SALDO" 		, 	   	, STR0051	, Tm(0,nTamVal)				,21  ,.T.,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Saldo Atual"

oSection4:Cell("SCOL1"):Hide()
oSection4:Cell("SCOL2"):Hide()
oSection4:Cell("SCOL3"):Hide()

oSection4:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

oSectionSA := TRSection():New(oSection1, "SALDO ANTERIOR")

TRCell():New(oSectionSA,"TXTSA"	   	,     ,"SALDOANTERIOR",						    	, 118.5,/*lPixel*/,/*CodeBlock*/) //"Valor Original"
TRCell():New(oSectionSA,"SALDO"		,     ,"SALDO"			, Tm(0,nTamVal)				, 15,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Baixado"

oSectionSA:SetLinesBefore(1)
oSectionSA:SetHeaderSection(.F.)

oReport:nFontBody := 9
Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint �Autor� Marcio Menon       � Data �  16/08/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Imprime o objeto oReport definido na funcao ReportDef.     ���                                                           ���
�������������������������������������������������������������������������͹��
���Parametros� oReport - Objeto TReport do relatorio                      ���
���          � cTitulo - Titulo do relatorio										  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportPrint(oReport,cTitulo)

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)
Local oSection3 := oReport:Section(2)//oReport:Section(1):Section(1):Section(1)
Local oSection4 := oReport:Section(3)//oReport:Section(1):Section(1):Section(1):Section(1)
Local oSectionSA := oReport:Section(1):Section(2)
Local nOrdem	:= oReport:Section(1):GetOrder()
Local lTotGer   := .F.
Local nSalAcu   := 0
Local nTit1		:= 0
Local nTit2		:= 0
Local nTit3		:= 0
Local nTit4		:= 0
Local nTit5		:= 0
Local nTit6		:= 0
Local nTit7		:= 0
Local nTit8		:= 0
Local nTit9		:= 0
Local nTit10	:= 0
Local nTit11	:= 0
Local nTit12	:= 0
Local nTot1		:= 0
Local nTot2		:= 0
Local nTot3		:= 0
Local nTot4		:= 0
Local nTot5		:= 0
Local nTot6		:= 0
Local nTot7		:= 0
Local nTot8		:= 0
Local nTot9		:= 0
Local nTot10	:= 0
Local nTot11	:= 0
Local nTot12	:= 0
Local nTotAbat	:= 0
Local nValorA 	:= 0
Local nSaldoA 	:= 0
Local nBaixaA	:= 0
Local lImpSAnt	:= .T. //imprime saldo anterior -- come�a com true para passar a registrar a unica impress�o POG
Local cForAnt	:= Space(6)
Local lContinua	:= .T.
Local aValor	:= {0,0,0,0,0,0,0,0," ",0,0,0,0,0,0,0,0,0,0,0}				   
Local nSaldo	:= 0
Local nMoeda	:= mv_par10
Local dDataMoeda := dDataBase
Local ndecs		:= 2//Msdecimais(mv_par10)
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
Local i			:= 0
Local nTotFil1	:= 0
Local nTotFil2	:= 0
Local nTotFil3	:= 0
Local nTotFil4	:= 0
Local nTotFil5	:= 0
Local nTotFil6	:= 0
Local nTotFil7	:= 0
Local nTotFil8	:= 0
Local nTotFil9	:= 0
Local nTotFil10	:= 0
Local nTotFil11	:= 0
Local nTotFil12	:= 0
Local lCancelado:= .F.
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
Local lMVGlosa	:= SuperGetMv("MV_GLOSA",.F.,.F.)
Local lIRGlosa	:= .T.
Local lISGlosa	:= .T.
Local lINGlosa	:= .T.
Local nVlrGlosa := 0
//Gestao
Local cFilAtu 	:= cFilAnt
Local lGestao   := ( FWSizeFilial() > 2 ) 	// Indica se usa Gestao Corporativa
Local lSE1Excl  := Iif( lGestao, FWModeAccess("SE1",1) == "E", FWModeAccess("SE1",3) == "E")
Local lSE5Excl  := Iif( lGestao, FWModeAccess("SE5",1) == "E", FWModeAccess("SE5",3) == "E")
Local lQuery 	:= IfDefTopCTB() // verificar se pode executar query (TOPCONN)
Local aSelFil 	:= {}
//Local aSm0		:= {}
Local nLenFil	:= 0 
Local lSE1Comp  := FWModeAccess("SE1",3)== "C" // Verifica se SE1 � compartilhada
Local lSE5Comp  := FWModeAccess("SE5",3)== "C" // Verifica se SE5 � compartilhada
Local aStru		:= SE1->(dbStruct())
Local ni		:= 0		
Local cOrder	:= ""	
Local cFiltSA1	:= oReport:Section(1):GetSqlExp("SA1")
Local cFiltSE1	:= oReport:Section(1):GetSqlExp("SE1")
Local nTamVal 	:= TAMSX3("E1_VALOR")[1] + 4
Local aAreaSE5	:= {}
Local nValAcess	:= 0
Local lExistVlAc:= ExistFunc('FValAcess')
Local lFxLoadFK6:= ExistFunc('FxLoadFK6')
Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
Private cFilDe	:= ""
Private cFilAte := ""

//Gestao
If lQuery
	If mv_par23 == 1 .and. (lSE1Excl .or. lSE5Excl)	//filial nao totalmente compartilhada    
		If  FindFunction("AdmSelecFil")
			If !IsBlind()
				AdmSelecFil("FIN340",23,.F.,@aSelFil,"SE1", .F.)
			Else
				If FindFunction("GetParAuto")
					aRetAuto := GetParAuto("FINR340TestCase") 
					aSelFil  := aRetAuto
				EndIf
		   EndIf
		Else
			If !IsBlind()
				aSelFil := AdmGetFil(.F.,.F.,"SE1")
			Else
				If FindFunction("GetParAuto")
					aRetAuto := GetParAuto("FINR340TestCase") 
					aSelFil  := aRetAuto
				EndIf
			EndIf
		Endif
		If Empty(aSelFil)
			Aadd(aSelFil,cFilAnt)
		Endif
	
		aSM0 := FR340AbreSM0(aSelFil)
	
	Else
		aSM0 := AdmAbreSM0()
	Endif	

	SM0->(DbGoTo(nRegSM0))

Else
	aSM0 := AdmAbreSM0()
Endif

//����������������������������������������Ŀ
//� Definicoes da secao 2. (Titulos)		 �
//������������������������������������������
oSection2:Cell("VALOR"	 	):SetBlock( { || SayValor(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nTamVal,;
										( SE1->E1_TIPO $ MVRECANT + "," + MV_CRNEG ),nDecs, oReport:nDevice, "Valor") } )
										
				
oSection2:Cell("BAIXA"	 	):SetBlock( { || If(dDataBase >= SE1->E1_BAIXA .Or. (mv_par14 == 2 .And. !Empty(SE1->E1_BAIXA)), IIF(!Empty(SE1->E1_BAIXA),SE1->E1_BAIXA," "), ) } )
oSection2:Cell("VLRBAIXA"	):SetBlock( { || aValor[I_VALOR_RECEBIDO] 		} )
oSection2:Cell("DAD"	 	):SetBlock( { || (aValor[I_DESCONTO] - aValor[17]) + nTotAbat + SE1->E1_DECRESC 	} )				
oSection2:Cell("JMA"	 	):SetBlock( { || aValor[I_JUROS] + aValor[I_MULTA] + SE1->E1_SDACRES } )
oSection2:Cell("SALDO"	 	):SetBlock( { || SayValor(nSalAcu,nTamVal,SE1->E1_TIPO $ MVRECANT+","+MV_CRNEG,nDecs,,"Saldo")	} )
oSection2:Cell("VLRBAIXA"	):Picture( TM(aValor[I_VALOR_RECEBIDO],17,nDecs		))

oSection2:SetHeaderPage()	//Define o cabecalho da secao como padrao

//����������������������������������������Ŀ
//� Definicoes da secao 3.	(Totais)	   �
//������������������������������������������

oSection3:Cell("TXTTOTAL"	):SetBlock( { || If (!lTotGer, OemToAnsi(STR0016), OemToAnsi(STR0017)) } )	//"Totais : " ### "TOTAL GERAL : "
oSection3:Cell("VALOR"	 	):SetBlock( { || If (!lTotGer, nTit1, nTot1  ) } )
oSection3:Cell("SCOL1"		):SetBlock( { || If (!lTotGer, 0,0  ) } )
oSection3:Cell("SCOL2"		):SetBlock( { || If (!lTotGer, 0,0  ) } )
oSection3:Cell("SCOL3"		):SetBlock( { || If (!lTotGer, 0,0  ) } )
oSection3:Cell("DAD"	 	):SetBlock( { || If (!lTotGer, nTit2+nTit3+nTit11, nTot2+nTot3+nTot11  ) } )
oSection3:Cell("JMA"	 	):SetBlock( { || If (!lTotGer, nTit4+nTit5+nTit10, nTot4+nTot5+nTot10  ) } )
oSection3:Cell("VLRBAIXA"	):SetBlock( { || If (!lTotGer, nTit7, nTot7  ) } )
oSection3:Cell("SALDO"	 	):SetBlock( { || If (!lTotGer, nTit9, nTot9  ) } )

oSection4:Cell("TXTTOTAL"	):SetBlock( { || "Filial " + Iif( ((lQuery .or. mv_par20==1) .and. lSE1Excl ),Alltrim(cFilSm0),"")})  //"T O T A L   F I L I A L ----> " 
oSection4:Cell("VALOR"	 	):SetBlock( { || nTotFil1  } )
oSection4:Cell("SCOL1"		):SetBlock( { || If (!lTotGer, 0,0  ) } )
oSection4:Cell("SCOL2"		):SetBlock( { || If (!lTotGer, 0,0  ) } )
oSection4:Cell("SCOL3"		):SetBlock( { || If (!lTotGer, 0,0  ) } )
oSection4:Cell("DAD"	 	):SetBlock( { || nTotFil2+nTotFil3+nTotFil11 } )				
oSection4:Cell("JMA"	 	):SetBlock( { || nTotFil4+nTotFil5+nTotFil10 } )
oSection4:Cell("VLRBAIXA"	):SetBlock( { || nTotFil7  } )
oSection4:Cell("SALDO"	 	):SetBlock( { || nTotFil9  } )

oSectionSA:Cell("TXTSA"		):SetBlock({||"SALDOS ANTERIORES: "})

//��������������������������������������������������������������Ŀ
//� Defini��o dos cabe�alhos                                     �
//����������������������������������������������������������������
cTitulo := oReport:Title() + " " + GetMv("MV_MOEDA"+Str(mv_par10,1))
oReport:SetTitle(cTitulo)

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������
//Gestao
If lQuery .And. !Empty(aSelFil)
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
		If nOrdem == 1
			dbSetOrder(2)
			cChave := IndexKey()
			dbSeek(xFilial("SE1")+mv_par01+mv_par03,.T.)
			cCond1 := "SE1->E1_CLIENTE+SE1->E1_LOJA <= '"+mv_par02+mv_par04+"' .and. SE1->E1_FILIAL == '"+xFilial("SE1")+"'"
			cCond2 := "SE1->E1_CLIENTE+SE1->E1_LOJA"
			cOrder := SqlOrder(cChave)
		Else
			If MV_PAR15=1
				cChave  := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			Else
				cChave  := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			EndIf

			If TCSrvType() == "AS/400"
				cIndex	:= CriaTrab(nil,.F.)
				dbSelectArea("SE1")
				IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
				nIndex	:= RetIndex("SE1")  								
				dbSetOrder(nIndex+1)
			Else
				cOrder := SqlOrder(cChave)
			EndIf

			cCond1 := ".T."
			cCond2 := "SE1->E1_NOMCLI+SE1->E1_CLIENTE+SE1->E1_LOJA"
			SE1->(dbGoTop())
		EndIf
	
		oReport:SetMeter(SE1->(LastRec()))
	
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
			cQuery += " SE1.E1_INSS, SE1.E1_CSLL, SE1.E1_COFINS, SE1.E1_PIS, SE1.E1_IRRF, SE1.E1_ISS, "				
			cQuery += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SE1.E1_FILORIG, SE1.E1_VENCTO, SE1.E1_TITPAI  "
        
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
			cQuery += " AND SE1.E1_EMISSAO between '20140101' AND '" + DTOS(mv_par06) + "'" //" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
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
			cQuery2 += " SE1.E1_INSS, SE1.E1_CSLL, SE1.E1_COFINS, SE1.E1_PIS, SE1.E1_IRRF, SE1.E1_ISS, "				
			cQuery2 += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SE1.E1_FILORIG, SE1.E1_VENCTO, SE1.E1_TITPAI  "

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
			cQuery += " AND SE1.E1_EMISSAO between '20140101' AND '" + DTOS(mv_par06) + "'"
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
			
			If mv_par18 == 2 //Considera Liquidados, 1=SIM, 2=N�O -> 2 N�o imprimi os t�tulos que foram liquidados.
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

			//cQuery += " ORDER BY " + cOrder
			cQuery += " ORDER BY E1_EMISSAO,E1_FILIAL,E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO " //+ cOrder
			
			cQuery := ChangeQuery(cQuery)
		
			dbSelectArea("SE1")
			dbCloseArea()
		
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .T., .T.)
			
			For ni := 1 to Len(aStru)	
				If aStru[ni,2] != 'C' .and. FieldPos(aStru[ni,1]) > 0
					TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next nI
		
			//Desabilita o filtro no tratamento da Printline()
			oReport:NoUserFilter()

			
			If (SE1->(EOF()))
				lContinua := .F.
			Else
				lContinua := .T.
			EndIf
			cAliasSA1 := "SE1"
		EndIf
	
		While SE1->(!Eof()) .And. lContinua .And. &cCond1 .And. !oReport:Cancel()
		
			If oReport:Cancel()
				lContinua := .F.
				Exit
			EndIf	
	
			//��������������������������������������������������������������Ŀ
			//� Considera filtro do usuario                                  �
			//����������������������������������������������������������������
			If TcSrvType() != "AS/400"
				dbSelectArea("NEWSE1")
				dbGoto(SE1->RECNO)
			Endif
		
			dbSelectArea("SE1")	
		
			nCont := 1
			nTit1 := nTit2 := nTit3 := nTit4 := nTit5 := nTit6 := nTit7 := nTit8 := nTit9 := nTit10 := nTit11 := nTit12 := 0
			cForAnt := &cCond2
			
			oSection2:Init()
		
			While &cCond2 == cForAnt .And. lContinua .And. &cCond1 .And. !Eof()
			
				If oReport:Cancel()
					lContinua := .F.
					Exit
				EndIf	
				
				oReport:IncMeter()
		
				//��������������������������������������������������������������Ŀ
				//� Considera filtro do usuario                                  �
				//����������������������������������������������������������������
				If TcSrvType() != "AS/400"
					dbSelectArea("NEWSE1")
					dbGoto(SE1->RECNO)
				EndIf
	
				If !Fr340Skip("SE1")
					dbSelectArea("SE1")
					dbSkip()
					Loop
				EndIf
	
				//��������������������������������������������������������������Ŀ
				//� Imprime os dados dos clientes.                               �
				//����������������������������������������������������������������
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
				EndIf
	
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
				EndIf
				
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
					If !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
						nSalAcu := nSalAcu + nSaldo
					Else
						nSalAcu := nSalAcu - nSaldo
					EndIf
					If lVerFil .And. nSaldo > 0
						nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("R",SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,,aFiliais),;
										SE1->E1_MOEDA,mv_par10,dDataMoeda,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0) ),;
										nDecs+1),nDecs)
					EndIf
				Else
					nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par10,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					If !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
						nSalAcu := nSalAcu + nSaldo
					Else
						nSalAcu := nSalAcu - nSaldo
					EndIf
					
				Endif

				lPI       := .T.
				lCF       := .T.
				lCS       := .T.
				lIRGlosa  := .T.
				lISGlosa  := .T.
				lINGlosa  := .T.
				nVlrGlosa := 0

				If SE1->E1_VALOR <> SE1->E1_VALLIQ .Or. SE1->(E1_CSLL+E1_COFINS+E1_PIS+E1_IRRF+E1_INSS) > 0
					nTotAbat := SomaAbat( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, "R", nMoeda, SE1->E1_EMISSAO, SE1->E1_CLIENTE, SE1->E1_LOJA )
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
						ElseIf lMVGlosa .And. Mv_Par14 == 1
							If "IR-"$SE1new->E1_TIPO // IRRF
								lIRGlosa := .F.
							ElseIf "IS-"$SE1new->E1_TIPO // ISS
								lISGlosa := .F.
							ElseIf "IN-"$SE1new->E1_TIPO // INSS
								lINGlosa := .F.
							EndIf
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

					If lMvGlosa .And. Mv_Par14 == 1
						Iif (lIRGlosa , nVlrGlosa += SE1->E1_IRRF, nVlrGlosa += 0 )
						Iif (lISGlosa , nVlrGlosa += SE1->E1_ISS , nVlrGlosa += 0 )
						Iif (lINGlosa , nVlrGlosa += SE1->E1_INSS, nVlrGlosa += 0 )
					EndIf

				Else
					nTotAbat := 0
				EndIf	

				If !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
				   !( MV_PAR14 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
				   If !lMVGlosa .Or. Mv_Par14 == 1
						nSaldo -= nTotAbat + nVlrGlosa
					EndIf
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
				
				//Calculo valor VA
				nValacess	:= 0 
				If SE1->E1_SALDO <>  SE1->E1_VALOR //Sofreu baixa
					aAreaSE5	:= SE5->(GetArea())		
				
					DbSelectArea("SE5")
					DBSetOrder(2) //E5_FILIAL, 	E5_TIPODOC, E5_PREFIXO, E5_NUMERO, 			E5_PARCELA, 	E5_TIPO, 		E5_DATA, E5_CLIFOR, E5_LOJA, E5_SEQ, R_E_C_N_O_, D_E_L_E_T_
					SE5->( dbGoTop() )
					If SE5->(DBSeek(xFilial("SE5") + "VA" + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + Dtos(SE1->E1_BAIXA) + SE1->E1_CLIENTE + SE1->E1_LOJA))
						nValAcess := IIf(lFxLoadFK6,FxLoadFK6("FK1",SE5->E5_IDORIG,"VA")[1,2],0)
					Endif
					
					RestArea(aAreaSE5)				 
					
				Else
					nValAcess := IIf(lExistVlAc,FValAcess(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_NATUREZ, Iif(Empty(SE1->E1_BAIXA),.F.,.T.),"","R",DDataBase),0)
					nSaldo	+= nValAcess					
				Endif				
				
				//Descricao da Situacao de cobranca			
				cSitCobr := Capital(FN022SITCB(SE1->E1_SITUACA)[9])
	
				If !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
					nTit9 += nSaldo
					
					If SE1->E1_EMISSAO >= MV_PAR05
						nTit1 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nTit7 += aValor[I_VALOR_RECEBIDO]
					EndIf
					
					If SE1->E1_EMISSAO < MV_PAR05
						//nValorA += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						//nBaixaA += aValor[I_VALOR_RECEBIDO]
						nSaldoA += nSaldo
						nVlrOriA := 0
					ElseIf lImpSAnt
						lImpSAnt := .T.
					EndIf
				Else
					nTit9 -= nSaldo
					If SE1->E1_EMISSAO >= MV_PAR05
						nTit1 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nTit7 -= aValor[I_VALOR_RECEBIDO]
					EndIf	
					
					If SE1->E1_EMISSAO < MV_PAR05
						//nValorA -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						//nBaixaA -= aValor[I_VALOR_RECEBIDO]
						nSaldoA -= nSaldo
						nVlrOriA := 0
					ElseIf lImpSAnt
						lImpSAnt := .T.
					EndIf
				EndIf
				
				IF SE1->E1_EMISSAO >= MV_PAR05
					nTit2 += (aValor[I_DESCONTO] - aValor[17])
					nTit3 += nTotAbat
					nTit4 += aValor[I_JUROS]
					nTit5 += aValor[I_MULTA]
					nTit6 += aValor[I_CORRECAO_MONETARIA]
					nTit8 += aValor[I_RECEB_ANT]
					nTit10 += SE1->E1_SDACRES 
					nTit11 += SE1->E1_DECRESC 
					nTit12 += nValAcess  
				ENDIF

				If cPaisLoc <> "BRA"
					cMotivo := SE1->E1_TIPO+"   "+ Substr(aValor[I_MOTBX],1,10)
	    	  		nvalor  := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nPos    := aScan(aMotBx,{|X| x[1]== cMotivo})
			
					If nPos > 0
			   		 	aMotBx[nPos][2] += nvalor
					Else
		   				Aadd(aMotBx,{cMotivo,nvalor})
					Endif	
				EndIf
	
				//��������������������������������������������������������������Ŀ
				//� Imprime os titulos dos clientes.                             �
				//����������������������������������������������������������������	
				//oSection2:Init()
				If SE1->E1_EMISSAO >= MV_PAR05
					if lImpSAnt
						oSectionSA:Init()
							//oSectionSA:Cell("VALOR"		):SetValue( nValorA )
							//oSectionSA:Cell("VLRBAIXA"	):SetValue( nBaixaA )
							oSectionSA:Cell("SALDO"		):SetValue( nSaldoA )
						oSectionSA:PrintLine()
						oSectionSA:Finish()
						
						lImpSAnt := .F.
					EndIf
					oSection2:PrintLine()
				EndIf
	
				dbSelectArea("SE1")
				dbSkip()
			EndDo
		
			oSection2:Finish()
			oSection1:Finish()

			//��������������������������������������������������������������Ŀ
			//� Imprime os totais.						                          �
			//����������������������������������������������������������������
			oSection3:Init()
			
			If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+;
			     ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9)+ABS(nTit10)+ABS(nTit11)+ABS(nTit12) > 0 )
	        	
	        	
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
				nTot12 += nTit12
				
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
				nTotFil12 += nTit12
	
				oSection3:PrintLine()	
			EndIf		
			oSection3:Finish()
			oReport:ThinLine()
		EndDo
	
		SE1->(DbCloseArea())			
		
		//����������������������������������������Ŀ
		//� Imprimir TOTAL por filial somente quan-�
		//� do houver mais do que 1 filial.        �
		//������������������������������������������
		If (lQuery .or. mv_par20 == 1) .and. Len( aSM0 ) > 1
			oSection4:Init()  
			oSection4:PrintLine()
			oSection4:Finish()
			oReport:ThinLine()
		Endif

		Store 0 To nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nTotFil10,nTotFil11,nTotFil12
	EndIf

Next nInc

cFilAnt := cFilOld

//��������������������������������������������������������������Ŀ
//� Imprime o Total Geral.					                     �
//����������������������������������������������������������������
lTotGer := .T.	

oSection3:Init()
oSection3:PrintLine()
oSection3:Finish()

If cPaisLoc <> "BRA"
	oSection3:Cell("DESCON"	 ):Disable()
	oSection3:Cell("ABATIM"	 ):Disable()
	oSection3:Cell("JUROS"	 ):Disable()
	oSection3:Cell("MULTA"	 ):Disable()
	oSection3:Cell("CMONE"	 ):Disable()
	oSection3:Cell("VA"		 ):Disable()
	oSection3:Cell("VLRBAIXA"):Disable()
	oSection3:Cell("RECANTEC"):Disable()
	oSection3:Cell("SALDO"	 ):Disable()
	oSection3:Init()
	oReport:PrintText(OemToAnsi(STR0027))		//"TOTAL POR MOTIVO: "

	For i := 1 to Len(aMotBx)
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
		EndIf
		dbSetOrder(1)
	EndIf
Else
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �FR340FIL  � Autor � Andreia           	� Data � 11.01.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Monta Indregua para impressao do relat�rio				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FR340FIL()
Local cString

cString := 'E1_FILIAL="'+xFilial()+'".And.'
cString += 'dtos(E1_EMISSAO)>= "20140101" .and.dtos(E1_EMISSAO)<="'+dtos(mv_par06)+'".And.'
cString += 'dtos(E1_VENCREA)>="'+dtos(mv_par07)+'".and.dtos(E1_VENCREA)<="'+dtos(mv_par08)+'".And.'
cString += 'E1_CLIENTE>="'+mv_par01+'".and.E1_CLIENTE<="'+mv_par02+'".And.'
cString += 'E1_LOJA>="'+mv_par03+'".and.E1_LOJA<="'+mv_par04+'".and.'
cString += 'E1_NATUREZ>="'+mv_par16+'".and.E1_NATUREZ<="'+mv_par17+'"'
If cPaisLoc<>"BRA"
	cString +='.and. !(E1_TIPO$"TF~CH")'
EndIf

Return cString

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �SayValor  � Autor � J�lio Wittwer    	    � Data � 24.06.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna String de valor entre () caso Valor < 0			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINR340.PRX												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function SayValor(nNum,nTam,lInvert,nDecs, nTipImp,cTipo)
Local cPicture,cRetorno
cPicture := tm(nNum,nTam,nDecs)
If nTipImp == 4
	cRetorno := nNum
Else
	cRetorno := Transform(nNum,cPicture)
EndIf

IF (nNum<0 .or. lInvert) .and. cTipo != "Saldo"
	cPicture := tm(nNum,nTam-2,nDecs)
	cRetorno := Transform(nNum,cPicture)
	cRetorno := Right(Space(10)+"("+Alltrim(StrTran(cRetorno,"-",""))+")",nTam+1)
ElseIf nNum <0	.and. cTipo == "Saldo"
	cPicture := tm(nNum,nTam-2,nDecs)
	cRetorno := Transform(nNum,cPicture)
	cRetorno := Right(Space(10)+"("+Alltrim(StrTran(cRetorno,"-",""))+")",nTam+1)
Endif



Return cRetorno

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Fr340Skip � Autor � Pilar S. Albaladejo	� Data � 13.10.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINR340.PRX												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fr340Skip()

Local lRet := .T.
//��������������������������������������������������������������Ŀ
//� Verifica se esta dentro dos parametros                       �
//����������������������������������������������������������������
IF SE1->E1_CLIENTE < mv_par01  .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
	SE1->E1_LOJA    < mv_par03 .OR. SE1->E1_LOJA    > mv_par04 .OR. ;
	DTOS(SE1->E1_EMISSAO) < '20140101' .OR. SE1->E1_EMISSAO > mv_par06 .OR. ;
	SE1->E1_VENCREA < mv_par07 .OR. SE1->E1_VENCREA > mv_par08 .OR. ;
	SE1->E1_NATUREZ < mv_par16 .OR. SE1->E1_NATUREZ > mv_par17 .OR. ;
	SE1->E1_TIPO $ MVABATIM
	lRet := .F.
	
ElseIF SE1->E1_EMISSAO > dDataBase
	lRet := .F.
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se o t�tulo � provis�rio                            �
	//����������������������������������������������������������������
ElseIf (SE1->E1_TIPO $ MVPROVIS .and. mv_par09==2)
	lRet := .F.
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se o t�tulo foi aglutinado em uma fatura            �
	//����������������������������������������������������������������
ElseIf !Empty(SE1->E1_FATURA) .and. Substr(SE1->E1_FATURA,1,6) != "NOTFAT"
	lRet := IIF(mv_par12 == 1, .T., .F.)	// Considera Faturados = mv_par12
	//����������������������������������������Ŀ
	//� Verifica se deve imprimir outras moedas�
	//������������������������������������������
Elseif mv_par13 == 2 // nao imprime
	If SE1->E1_MOEDA != mv_par10 //verifica moeda do campo=moeda parametro
		lRet	:= .F.
	Endif
Endif

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F340VerBxFil �Autor � Gustavo Henrique � Data �  21/04/09  ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica se existem baixas em outras filiais para o titulo ���
���          � posicionado para impressao.                                ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro - Relatorio Posicao Clientes                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AdmAbreSM0� Autor � Orizio                � Data � 22/01/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna um array com as informacoes das filias das empresas ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Finr340Val� Autor � Karen Honda           � Data � 01/03/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida��o no pergunte Ordem Nome para ambiente n�o TOP, n�o ���
���realiza ordena��o pelo Nome Fantasia                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Finr340                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Finr340Val()
Local lRet := .T.
#IFNDEF TOP
	If (Mv_par15 == 2 )
		lRet := .F.
		MsgAlert(STR0059) //"Op��o v�lida somente para ambiente TOP!"
	EndIf	
#ENDIF

Return lRet                      


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FR340AbreSM0� Autor � Mauricio Pequim Jr  � Data � 02/10/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna um array com as informacoes das filias das empresas ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FR340AbreSM0(aSelFil)               

Local aArea			:= SM0->( GetArea() )
Local aRetSM0		:= {}
Local nLaco			:= 0
			
aRetSM0	:= FWLoadSM0()

If Len(aRetSM0) != Len(aSelFil)

	For nLaco := Len(aRetSM0) To 1 Step -1
		cFilx := aRetSm0[nLaco,2]
		nPosFil := Ascan(aSelFil,aRetSm0[nLaco,2])
	
		If nPosFil == 0
			ADel(aRetSM0,nLaco)
			aSize(aRetSM0, Len(aRetSM0)-1)
		Endif
	Next nLaco
Endif

aSort(aRetSm0,,,{ |x,y| x[2] < y[2] } )
RestArea( aArea )

Return aClone(aRetSM0)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��                                                                         ��
��            Funcoes retiradas do arquivo FINXFUN.PRX                     ��
��                                                                         ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � BuscaMoeda ( )                                             ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Antonio Maniero Jr.                      � Data � 19.05.94 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Procura Qual e a moeda de uma titulo baixado no SE1 ou SE2 ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � Gen�rico                                                   ���
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function BuscaMoeda()
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
dbSetOrder(nSavOrd)    // Restaura ordem do SE1/SE2
dbSelectArea(cSavArea)
Return nMoeda