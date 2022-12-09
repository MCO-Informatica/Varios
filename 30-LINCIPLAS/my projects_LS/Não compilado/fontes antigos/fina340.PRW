#INCLUDE "FINA340.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH" 
                        
Static lFWCodFil := FindFunction("FWCodFil")
STATIC __lBlind		:= IsBlind()

/// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Fina340	³ Autor ³ Valter G. Nogueira Jr.³ Data ³ 18/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Compensa‡„o entre t¡tulos e adiantamentos 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fina340()	   					                    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	     ³ Gen‚rico 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS                     					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Claudio    ³13/07/00³xxxxxx³ Retirar todas as chamadas a WriteSx2     ³±±
±±³Paulo August³12/09/01³Melhor³Permitir que a compensacao seja feita     ³±±
±±³            ³        ³      ³atraves dos titulos compensaveis(RA,NCC,..³±±
±±³Marcel      ³14/10/07³Melhor³PA com valor Bruto                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Fina340(nPosArotina)
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nVlMoeda	:= 0
Local nSavInd := IndexOrd()
LOCAL nSavRec	:= RecNO()
Local nA, cMoedaTx
Local cCondicao
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vetor com Condicoes para a legenda da mBrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private  aCores :={	{ 'E2_SALDO = E2_VALOR .AND. E2_ACRESC = E2_SDACRES'  , 'ENABLE' },;   // Titulo nao Compensado
					{ 'E2_SALDO =  0'         , 'DISABLE'},;	// Titulo Compensado Totalmente 
					{ 'E2_SALDO <> 0'         , 'BR_AZUL'} }	// Titulo Compensado Parcialmente

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := MenuDef()    
Private cCodDiario	:= ""
CODFORCP  	:= ""	//para contabilizar o Codigo do Fornecedor da Compensacao
LOJFORCP 	:= ""	//para contabilizar a Loja do Fornecedor da Compensacao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                PARAMETROS  	                     ³
//³                              	                 ³
//³ MV_PAR01 : Considera Loja  Sim/Nao               ³
//³ MV_PAR02 : Considera Fornecedor  Original/Outros ³
//³ MV_PAR03 : Do Fornecedor                         ³
//³ MV_PAR04 : Ate Fornecedor                        ³
//³ MV_PAR05 : Considera filiais abaixo              ³
//³ MV_PAR06 : Da Filial                             ³
//³ MV_PAR07 : Ate a Filial                          ³
//³ MV_PAR08 : Aglutina Lancto?                      ³
//³ MV_PAR09 : Mostra Lancamentos Cont beis          ³
//³ MV_PAR10 : Compensa Normais ou Impostos          ³
//³ MV_PAR11 : Contabiliza On-Line                   ³
//³ MV_PAR12 : Compensa Transferidos (em bordero)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega fun‡„o Pergunte                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("AFI340",.T.)})
Pergunte("AFI340",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabe‡alho da tela de baixas				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi(STR0025)  //"Compensa‡„o de Titulos"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cLote
LoteCont( "FIN" )

PRIVATE	VALOR 	:= 0
PRIVATE VALOR4	:= 0
PRIVATE VLRINSTR := 0
PRIVATE	cMarca	:= GetMark()
PRIVATE	lFina340 := ExistBlock("FA340FILT")
PRIVATE	cCpoNum

PRIVATE nTamTit := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]
PRIVATE nTamTip := TamSX3("E2_TIPO")[1]
Private aTxMoedas	:=	{}
Private lCalcIssBx := !Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .and. ;
						  !Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2"  //Retencao do ISS pela emissao (1) ou baixa (2)

DEFAULT nPosArotina := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura aTxMoedas         ³
//³ [1] -> Nome Moeda          	³
//³ [2] -> Taxa a Ser Utilizada	³
//³ [3] -> Picture          	³
//³ [4] -> Taxa do dia atual    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1"),1})
For nA := 2	To MoedFin()
	cMoedaTx :=	Str(nA,IIf(nA <= 9,1,2))
	If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
		nVlMoeda := RecMoeda(dDataBase,nA)
		Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),nVlMoeda,PesqPict("SM2","M2_MOEDA"+cMoedaTx),nVlMoeda })
	Else
		Exit
	Endif
Next

If nPosArotina > 0 // Sera executada uma opcao diretamento de aRotina, sem passar pela mBrowse
	dbSelectArea("SE2")
	bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
	Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para ser utilizado antes do Browse          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("F340BROW")
		ExecBlock("F340BROW",.f.,.f.)
	Else
		DbSelectArea("SE2")
		If cPaisLoc <> "ANG"
			cCondicao := " E2_ORIGEM <> 'FINA085A' "
		EndIf 
	Endif 

	dbSelectArea("SE2")
	dbSetOrder(1)
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endere‡a a Fun‡„o de BROWSE				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SE2",,,,,,Fa340Leg(),,,,,,,,cCondicao) 
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SE2->(DbClearFilter())
dbSelectArea("SE2")
dbSetOrder(nSavInd)
dbGoTo(nSavRec)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fa340Comp³ Autor ³ Valter G. Nogueira Jr.³ Data ³ 18/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca‡„o dos titulos para compensa‡„o							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa340Comp() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
FuncTion fA340Comp(cAlias,cCampo,nOpcE)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local cVarQ 		:= "  "
LOCAL lContabil	:= .f.
LOCAL lPadrao
LOCAL nPosCnt	   :=0
LOCAL nOpca			:=0
LOCAL nTotal		:=0
LOCAL nValorComp	:=0
LOCAL nValorDec		:=0
LOCAL nValorAcre	:=0

LOCAL cAdiantamento
LOCAL cArquivo
LOCAL cPadrao	:="597"
Local nValBX	:= 0			// Valor da baixa na moeda 1
Local nValBX2	:= 0			// Valor da baixa na moeda do tit principal
LOCAL nOrdem	:= SE2->(IndexOrd())
LOCAL nTitIni	:= SE2->(Recno())
LOCAL lF340_PA := ExistBlock("F340_PA")
Local lAglutina:= Iif(mv_par08==1,.T.,.F.)
Local lDigita  := iif(mv_par09==1,.T.,.F.)
Local nDecs   := 2
Local nSalTit := 0 
Local nDecs1  := MsDecimais(1)
LOCAL oTitulo
LOCAL oDlg
LOCAL oOk   := LoadBitmap( GetResources(), "LBOK" )
LOCAL oNo   := LoadBitmap( GetResources(), "LBNO" )
Local nSldReal := 0
LOCAL lF340NAT := ExistBlock("F340NAT")
LOCAL oGet01
LOCAL oValorCp
Local nTotAbat		:= 0
Local nValPadrao  := 0
Local nTit := 0
Local nAcresc := 0
Local nDecres := 0
Local cSetFilter := SE2->(DBFILTER()) // Salva o filtro
Local nX          := 0
Local nValImp     := 0
Local nValImpPa   := 0
Local aImp10925   := {}
Local aImp10925pa := {}
Local lVerLibTit := .T.
// Controla retencao de impostos da lei 10925.
Local lContrRet   := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local	lIRPFBaixa := .F.
Local aSize := {}
Local oPanel
Local oPanel2
Local lPaBruto		:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor
Local lBaixaImp   := .F.
Local lPa := .F.
Local lGeraNDF := .F.
Local lGeraTx  := .F.
Local nPisTx   := 0
Local nCofTx   := 0
Local nCslTx   := 0
Local cLa
Local aButtonTxt := {}
Local aDiario :={}
Local lVldDtFin  := .T.
Local lChequeLib := .T.
Local cCondic
Local aAreaSE5   

Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}
Local aTitAux   := {}

Local cChvSE2	:=	SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
Local lFinVDoc	:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
Local lBxINSSAut:= GetNewPar("MV_BXINSAU","2")=="1" 
Local	nProp		:=	nPisProp	:= nCofProp := nCslProp	:=	nBasePis	:=	nValDif	:=	0  
Local lPropPA 	:= SuperGetMv("MV_COMPCP",,.F.) //Verifica se vai proporcionalizar quando PA>NF e PA liquido. 
Local lRInssPa := .F.
local nSaldoprop := 0
local nOldSaldo := 0
local nValBxliq	 := 0
local nValBxliq2 := 0
Local aAreaSE2 := {}
Local oChkFltMed:= NIL													// Objeto para check box para habilitar Filtra Medicao
Local lCheck    := .F.													// Variavel do objeto oChkFltMed
Local oNumCont  := NIL													// Objeto para MSGet para receber o numero do contrato
Local cNumCont  := Space(TamSX3("E2_MDCONTR")[1])						// Numero do contrato quando o checkbox oChkFltMed estiver marcado
Local lValPgto := SuperGetMv("MV_BP10925",.T.,"1") == "2" //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos
local nValliq	:= 0
Local lBxImpAut	:= GetNewPar("MV_CPIMPAT",2) == 1
Local cSeqImp		:= ""
Local lNoTitComp  := .F.

PRIVATE	aTitulos	:={}
PRIVATE	aTitINSS	:={}
PRIVATE	aRecNo		:={}
PRIVATE	aRecNoINSS	:={}
PRIVATE	aRegSE2		:={}
PRIVATE	aBaixaSE5	:={}
PRIVATE	cPrefixo	:= SE2->E2_PREFIXO
PRIVATE	cNum		:= SE2->E2_NUM
PRIVATE	cTipoTit 	:= SE2->E2_TIPO
PRIVATE	cFornece 	:= SE2->E2_FORNECE
PRIVATE	cLoja 		:= SE2->E2_LOJA
PRIVATE	cSaldo		:= CriaVar("E2_SALDO")
PRIVATE	nValor		:= CriaVar("E2_SALDO")
PRIVATE	cParcela 	:= SE2->E2_PARCELA
PRIVATE	nMoeda		:= SE2->E2_MOEDA
PRIVATE	dBaixa		:= dDataBase  
PRIVATE dEmiss		:= SE2->E2_EMIS1
PRIVATE	nValTot		:= 0,nPosSaldo:=0,nPosValor:=0
PRIVATE	cBanco		:= Criavar("E2_PORTADO")
PRIVATE nHdlPrv		:=0
Private lDebito		:=.F.
PRIVATE	nTxMoeda	:= SE2->E2_TXMOEDA
PRIVATE aFlagCTB	:= {}
PRIVATE lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
PRIVATE nValCorCM	:= 0
//Variavel indica se irá provisionar os impostos de INSS e ISS na inclusão da PA, deduzindo-os do valor de adiantamento.
PRIVATE lPrImPA := !Empty( SE2->( FieldPos( "E2_PRINSS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRISS" ) ) ) .And. ;
				 !lPaBruto .And. SuperGetMv("MV_PAPRIME",.T.,"2") == "1"         
PRIVATE nPis:= 0
PRIVATE	nCof:= 0
PRIVATE	nCsl:= 0
PRIVATE nIrf:= 0
PRIVATE	nISS:= 0 
PRIVATE	nIns:= 0 
PRIVATE lAltera	:= .F.
PRIVATE cTitPai		:= SE2->E2_TITPAI
PRIVATE cTitPaiINS	:= CriaVar("E2_TITPAI")

If lPrImPA
	SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ)) 	
	lRInssPa := !Empty( SED->( FieldPos( "ED_RINSSPA" ) ) ) .And. SED->ED_RINSSPA == '1'
EndIf
Dbselectarea("SA2")
SA2->(Dbsetorder(1))
If SA2->(Dbseek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA)))
	lIRPFBaixa :=IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 				
Endif
If !LockCmpCP( cChvSE2 )
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N„o permitir compensa‡ao de titulos de abatimento.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoTit $ MVABATIM

	//ÚÄÄÄÄÄÄ¿
	//³HELP'S³
	//ÀÄÄÄÄÄÄÙ
	// Portugues
 	Aadd(aHelpPor,"Nao e permitida a compensacao a partir" )
 	Aadd(aHelpPor,"de um titulo de abatimento." )
	// Espanhol
 	Aadd(aHelpSpa,"No se permite hacer la compensacion" )
 	Aadd(aHelpSpa,"a partir de un titulo de descoento" )
	// Ingles
 	Aadd(aHelpEng,"It is not possible to execute the" )
 	Aadd(aHelpEng,"clearance based on a discounted bill" )

	PutHelp("PNOCMPABT",aHelpPor,aHelpEng,aHelpSpa,.F.)
	aHelpPor := {} ; 	aHelpSpa := {} ; 	aHelpEng := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soluction's³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
	// Portugues
 	Aadd(aHelpPor,"Utilize um titulo de tipo" )
 	Aadd(aHelpPor,"diferente de abatimento." )
	// Espanhol
 	Aadd(aHelpSpa,"Utiliza un titulo de diverso" )
 	Aadd(aHelpSpa,"tipo de descontar." )
	// Ingles
 	Aadd(aHelpEng,"It uses a bill of different" )
 	Aadd(aHelpEng,"type of discounting." )

	PutHelp("SNOCMPABT",aHelpPor,aHelpEng,aHelpSpa,.F.)
	aHelpPor := {} ; 	aHelpSpa := {} ; aHelpEng := {}

	Help(" ",1,"NOCMPABT")

	Return (.T.)
Endif

If cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT+"/INA"
	lDebito:=.T.
Endif   

IF lFina340 				// EMBRAER
	dbSelectArea("SX3")
	dbSetOrder(2)
	If	dbSeek("E2_PO_NUM")
		If X3USO(X3_USADO)
			cCpoNum	:= SE2->E2_PO_NUM
		EndIf
	EndIf
	dbSelectArea(cAlias)
Endif                                                          


IF (ExistBlock("F340LIBT"))
	lVerLibTit :=ExecBlock("F340LIBT",.f.,.f.)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N„o permite compensa‡Æo de titulos nao liberados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVerLibTit
	If !( SE2->E2_TIPO $ MVPAGANT+"/INA" ) .And. ;
	   (GetMv("MV_CTLIPAG").and.Empty(SE2->E2_DATALIB).and.(SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE)>GetMV("MV_VLMINPG"))
		Help(" " , 1 , "FA080NAOLIB") // NÆo permite baixar t¡tulos nÆo liberados
		Return .F.
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a apresentação dos documentos                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF AliasIndic("FRD") .AND. (SE2->(FieldPos("E2_TEMDOCS")) > 0) .And. FindFunction("CN062ValDocs") .And. lFinVDoc
	If !CN062ValDocs("07",.F.)
		Return .F. 
	EndIf
EndIf			 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N„o permite compensa‡Æo de impostos possam ser acessados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If GetMv("MV_IMPADT") != "S" .and. mv_par10 == 2
	Help(" ",1,"NOADTIMP")
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N„o permite que t¡tulos j  baixados possam ser acessados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SE2->E2_SALDO == 0
	Help(" ",1,"FA330JABAI")
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif

If ExistBlock("F340DTFIN")
	lVldDtFin := ExecBlock("F340DTFIN",.F.,.F.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVldDtFin .and. !DtMovFin()
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso esteja ligado o controle de solicitacao de notas de credito e exista alguma ³
//³ pendencia para este titulo                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc	<> "BRA"
	SCU->(DbSetOrder(2))
Endif
If cPaisloc <> "BRA" .And. GetMv('MV_SOLNCP') .And. SE2->E2_TIPO == MVNOTAFIS ;
		.And. SCU->(MsSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_NUM+SE2->E2_PREFIXO)).And. Empty(SCU->CU_NCRED)
	HELP(" ",1,"SOLNCPAB")
	Return
Endif  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulos de adiantamento nÆo sÆo compensaveis como titulo principal. No ³
//³ caso doa tipos TX, quando for ISS (gerado via C.Receber) s¢ compenso c/³
//³ adiantamentos ao municipio. Quando gerados via C.Pagar, apenas com titu³
//³ los de adiantamento de impostos (TXA)                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lPrimPa
	If (((cTipoTit $ MVTAXA .and. Alltrim(cFornece) == GetMv("MV_MUNIC")) .or. ;
		 !(cTipoTit $ MVTAXA+"/"+MVINSS+"/INA")).and. mv_par10 == 2) .or. ;
		 (cTipoTit $ MVTAXA+"/"+MVINSS+"/INA" .and. mv_par10 == 1) 
		lNoTitComp := .T.
	EndIf
Else
	//Para permitir compensação de titulos TX FunRural
	If (((cTipoTit $ MVTAXA .and. Alltrim(cFornece) == GetMv("MV_MUNIC")) .or. ;
		 !(cTipoTit $ MVTAXA)).and. mv_par10 == 2)	
		 
		 lNoTitComp := .T.
	EndIf		 
Endif
If lNoTitComp
	Help(" ",1,"NOTITCOMP")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(1)
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ A Data de Emissao(EMIS1) do Titulo posicionado não podera ser maior que|
//| a DataBase do Sistema.                                                 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         
If dEmiss > dDatabase 
	
	Help(" ",1,"NOTITSEL")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(1)
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulos provisorios nao sao compensaveis como titulo principal.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoTit $ MVPROVIS
	Help(" ",1,"NOCMPPROV",,STR0028+chr(13)+STR0029,1,0 )   //"Nao é permitida a compensacao a partir de"###"um titulo provisorio"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(1)
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif

If mv_par12 == 2 .and. !Empty(SE2->E2_NUMBOR)
	Help(" ",1,"NOCMPTRF")
	dbSelectArea("SE2")
	dbSetOrder(1)
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif    

If Empty(GetHelp("NOCMPIMP"))
	//ÚÄÄÄÄÄÄ¿
	//³HELP'S³
	//ÀÄÄÄÄÄÄÙ
	// Portugues
	aHelpPor := {} ; 	aHelpSpa := {} ; 	aHelpEng := {}                        
 	Aadd(aHelpPor,"Operação não permitida, pois titulo    ")
 	Aadd(aHelpPor,"reteve imposto na geração de bordero ")
	// Espanhol
 	Aadd(aHelpSpa,"Operacion no permitida, pues el ")
 	Aadd(aHelpSpa,"titulo retuvo el impuesto en la ")
 	Aadd(aHelpSpa,"generacion de bordero.")
	// Ingles
 	Aadd(aHelpEng,"Operation not allowed due to ")
 	Aadd(aHelpEng,"tax withholding by the bill upon" )
 	Aadd(aHelpEng,"bordereau generation." )

	PutHelp("PNOCMPIMP",aHelpPor,aHelpEng,aHelpSpa,.F.)
	aHelpPor := {} ; 	aHelpSpa := {} ; 	aHelpEng := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soluction's³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
	// Portugues
 	Aadd(aHelpPor,"Retire o titulo do bordero" )
	// Espanhol
 	Aadd(aHelpSpa,"Retire el titulo del bordero.")
	// Ingles
 	Aadd(aHelpEng,"Remove the bill from the bordereau." )

	PutHelp("SNOCMPIMP",aHelpPor,aHelpEng,aHelpSpa,.F.)
	aHelpPor := {} ; 	aHelpSpa := {} ; aHelpEng := {}
Endif

If mv_par12 == 1 .and. !Empty(SE2->E2_NUMBOR) 
	If (lPccBaixa .and. !(Empty(SE2->E2_PIS) .AND. Empty(SE2->E2_CSLL).and. Empty(SE2->E2_COFINS)));
		.OR. (lIRPFBaixa .AND. !Empty(SE2->E2_IRRF) )
			
			Help(" ",1,"NOCMPIMP")
			dbSelectArea("SE2")
			dbSetOrder(1)
			DeleteObject(oOk)
			DeleteObject(oNo)
			Return (.T.)
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o titulo esta bloqueado - Gestao de Contratos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SE2->(FieldPos("E2_MSBLQL"))) .And. SE2->E2_MSBLQL == "1"
	Help(" ",1,"SE2BLOQ")
	Return .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ AAF - Titulos originados no SIGAEFF não devem ser alterados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "SIGAEFF" $ SE2->E2_ORIGEM
   Help(" ",1,"FAORIEFF")
   Return .F.
EndIf

If Empty(GetHelp("NOCHQADT"))
	//ÚÄÄÄÄÄÄ¿
	//³HELP'S³
	//ÀÄÄÄÄÄÄÙ
	// Portugues
	aHelpPor := {} ; 	aHelpSpa := {} ; 	aHelpEng := {}
 	Aadd(aHelpPor,"Operação não permitida, pois ainda não ")
 	Aadd(aHelpPor,"foi liberado o cheque desse pagamento, ")
 	Aadd(aHelpPor,"ou o cheque ainda não existe.")
	// Espanhol
 	Aadd(aHelpSpa,"Operación no permitida porque todavía ")
 	Aadd(aHelpSpa,"no se liberó el cheque de dicho pago o")
 	Aadd(aHelpSpa,"el cheque todavía no existe.")
	// Ingles
 	Aadd(aHelpEng,"Transaction not allowed because check ")
 	Aadd(aHelpEng,"for such payment has not been released," )
 	Aadd(aHelpEng,"yet or check does not still exist." )

	PutHelp("PNOCHQADT",aHelpPor,aHelpEng,aHelpSpa,.F.)
	aHelpPor := {} ; 	aHelpSpa := {} ; 	aHelpEng := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soluction's³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
	// Portugues
 	Aadd(aHelpPor,"Gere o cheque do adiantamento e/ou" )
 	Aadd(aHelpPor,"Verifique a liberação do cheque." )
	// Espanhol
 	Aadd(aHelpSpa,"Genere cheque de anticipo y/o ")
 	Aadd(aHelpSpa,"Verifique liberación del cheque." )
	// Ingles
 	Aadd(aHelpEng,"Generate advance check and/or " )
 	Aadd(aHelpEng,"Verify check release." )

	PutHelp("SNOCHQADT",aHelpPor,aHelpEng,aHelpSpa,.F.)
	aHelpPor := {} ; 	aHelpSpa := {} ; aHelpEng := {}
Endif

// Se for um titulo de adiantamento, verifica se existem cheques nao liberados, pois se existir, nao permitir a baixa
// Isso ocorre quando o parametro MV_LIBCHEQ esta igual a N, foi gerado um cheque para o adiantamento e este
// ainda nao foi liberado
If Alltrim(cTipoTit) $ MVPAGANT+"/"+"INA" 
	If mv_par01 = 1 .And. mv_par02 = 1
		//Considera Loja e Fornecedor Original.
		cCondic := 'SE2->E2_FORNECE == SEF->EF_FORNECE .And. SE2->E2_LOJA == SEF->EF_LOJA .And. SEF->EF_LIBER == "N"'
	Elseif (mv_par01 = 2 .And. mv_par02 = 1) .Or. (mv_par02 = 2)
		//Não considera Loja e considera o Fornecedor Original ou então apenas considera Outros Fornecedores.
		cCondic := 'SE2->E2_FORNECE == SEF->EF_FORNECE .And. SEF->EF_LIBER == "N"'
	Else
		cCondic := 'SEF->EF_LIBER == "N"'
	Endif
	
	SEF->(DbSetOrder(3))
	SEF->(MsSeek(xFilial("SEF")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+Pad(E2_NUMBCO,Len(SEF->EF_NUM)))))

	While SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_NUM)==SE2->( E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+Pad(E2_NUMBCO,Len(SEF->EF_NUM)) ) .and. !SEF->(Eof())
		
		//Verifica se ha cheques nao liberados de acordo com a condicao.
		If &cCondic
			lChequeLib := .F. // Cheque nao esta liberado
			Exit 
		Endif
		
		SEF->(dbSkip())
	EndDo
	
	//Caso haja algum cheque nao liberado, a compensacao nao sera executada. Validação apenas para Brasil
		If cPaisLoc == "BRA"
			If !lChequeLib .Or. !FA340VerPA()
				Help(" ",1,"NOCHQADT")	
				dbSelectArea("SE2")
				dbSetOrder(1)
				DeleteObject(oOk)
				DeleteObject(oNo)
				Return (.T.)
			Endif
		EndIf
  
	//ANGOLA|BRASIL - Nao permitir compensar titulos de adiantamento relacionado a pedido
	#IFDEF TOP
		If cPaisLoc $ "ANG|BRA|MEX" .and. AliasInDic("FIE")
			If FinAdtSld( "P", SE2->( E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO ) )
				Help(" ",1,"ADTXPED",,STR0047,1,0)  //"Adiantamento relacionado a um pedido somente poderá ser utilizado no relacionamento com pedidos"
				dbSelectArea("SE2")
				dbSetOrder(1)
				DeleteObject(oOk)
				DeleteObject(oNo)
				Return (.T.)		
			Endif
		Endif
	#ENDIF	
		      
Endif   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoIniLan("000017")

While .T.

	//Se o titulo possuir taxa contratada, inicializo a moeda do titulo com a cotação contratada.
	If SE2->E2_MOEDA < 1
		nTxMoeda	 := If(SE2->E2_TXMOEDA > 0 .and. Empty(SE2->E2_DTVARIA), SE2->E2_TXMOEDA,RecMoeda(dDatabase,1))
		aTxMoedas[1,2] := nTxMoeda
	Else
		nTxMoeda	 := If(SE2->E2_MOEDA > 1,If(SE2->E2_TXMOEDA > 0 .and. Empty(SE2->E2_DTVARIA), SE2->E2_TXMOEDA,RecMoeda(dDatabase,SE2->E2_MOEDA)),0)
		If cPaisLoc =="ARG"		
			nTxMoeda := RecMoeda(dDatabase,SE2->E2_MOEDA)                       
		EndIf
		aTxMoedas[SE2->E2_MOEDA,2] := nTxMoeda
	EndIf

	nSaldo := SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Somente  verifica Abatimentos quando compensar titulos normais  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 1 
		nValImp := 0     
  		nPis:= 0
		nCof := 0
		nCsl := 0
		nIrf := 0 
		nISS := 0
		// Verifica os valores dos Txs (lei 10925) para subtrair do saldo do PA.
		If (lContrRet .Or. lIRPFBaixa) .And. SE2->E2_TIPO $ MVPAGANT+"/INA"									
			aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa,SE2->E2_PARCISS)				

			For nX := 1 To Len(aImp10925)  
		 		Do Case
					Case Alltrim(aImp10925[nX][5]) $ Alltrim(GetMv("MV_PISNAT"))
						nPis+=aImp10925[nX][6]                      
					Case Alltrim(aImp10925[nX][5]) $ Alltrim(GetMv("MV_COFINS"))
						nCof+=aImp10925[nX][6]				
					Case Alltrim(aImp10925[nX][5]) $ Alltrim(GetMv("MV_CSLL"))
						nCsl+=aImp10925[nX][6]  
					Case Alltrim(aImp10925[nX][5]) $ Alltrim(&(GetMv("MV_IRF")))
						nIrf+=aImp10925[nX][6]
					Case Alltrim(aImp10925[nX][5]) $ Alltrim(&(GetMv("MV_ISS")))
						nIss+=aImp10925[nX][6]
				EndCase
				nValImp += aImp10925[nX][6]
			Next
			If lPrImPA  .and. lPropPA .and. (SE2->E2_PIS > 0 .OR. SE2->E2_COFINS > 0 .OR. SE2->E2_CSLL > 0 .OR. SE2->E2_IRRF > 0) .and. lValPgto
				nValImp += If(lRInssPa,SE2->(E2_INSS+E2_PRISS),SE2->(E2_PRINSS+E2_PRISS))
			Endif
		Endif
		If !lDebito
			nTotAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
			nSaldo -= nTotAbat                                                                                    
		Endif  

		//Para Pa Bruto NAO reconsituo a base somando os impostos
		IF !lPaBruto .AND. SE2->E2_TIPO $ MVPAGANT+"/INA"  .and. lValPgto
			If lPropPA 
				nSaldo:= nSaldo
			Else 
				nSaldo += nValImp
			Endif
		Endif
	Endif   
	IF !lPaBruto .AND. !(SE2->E2_TIPO $ MVPAGANT+"/INA") .and. lPropPA  .and. lValPgto
		nSaldoProp:= F340CompSal(SE2->(RECNO()),.F.) 
		nProp:= nSaldoProp/(If(lPccBaixa,SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL,0)+ If(lIRPFBaixa,SE2->E2_IRRF,0)+if(lCalcIssBx,SE2->E2_ISS,0))
		If lPccBaixa 
			nSaldo-= If(nProp>0,(SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL)*nProp,(SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL)) 
		Endif

		If lCalcIssBx
			nSaldo-= If(nProp>0,SE2->E2_ISS*nProp,SE2->E2_ISS) 
		Endif     
		If lIRPFBaixa
			nSaldo-= If(nProp>0,SE2->E2_IRRF*nProp,SE2->E2_IRRF) 		
		Endif
				
	Endif
	
	cSaldo := TRANSFORM( nSaldo, "@E 9999,999,999.99" )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulo a ser compensado			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aSize := MSADVSIZE()
	If lPanelFin  //Chamado pelo Painel Financeiro
		//Espacamento := 45
		dbSelectArea(cAlias)
		oPanelDados := FinWindow:GetVisPanel()
		oPanelDados:FreeChildren()
		aDim := DLGinPANEL(oPanelDados)
		DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³
		//³ -------------------------------------------------------------- ³
		//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
		//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
		//³ tracao e redivisao por 2 para a centralizacao. 					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 225) /2
		nEspLin  := 20
		
	Else
		nEspLarg := 0
		nEspLin  := 2
		DEFINE MSDIALOG oDlg FROM 88,31 TO 275,545 TITLE OemToAnsi(STR0005) PIXEL  //"Compensa‡„o de Titulos a Pagar"
	Endif
	

	oDlg:lMaximized := .F.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT
	
	@ 000+nEspLin, 002+nEspLarg TO 030+nEspLin, 255+nEspLarg OF oPanel	PIXEL
	@ 031+nEspLin, 002+nEspLarg TO 062+nEspLin, 255+nEspLarg OF oPanel	PIXEL
	
	@ 15+nEspLin, 006+nEspLarg MSGET cPrefixo							SIZE 19, 10 OF oPanel PIXEL
	@ 15+nEspLin, 032+nEspLarg MSGET cNum 	 VALID !EMPTY(cNum)	SIZE 70, 10 OF oPanel PIXEL
	@ 15+nEspLin, 105+nEspLarg MSGET cParcela							SIZE 20, 10 OF oPanel PIXEL
	If lDebito
		@ 15+nEspLin, 129+nEspLarg MSGET cTipoTit Picture "@!"  Valid !Empty(cTipoTit) .AND.;
		!cTipoTit $ MVABATIM .AND. cTipoTit $ MVPAGANT+"/INA"+"/"+MV_CPNEG;
		.AND. Fa340Tit1() SIZE 12, 10 OF oPanel PIXEL
	else
		@ 15+nEspLin, 129+nEspLarg MSGET cTipoTit Picture "@!"  Valid !Empty(cTipoTit) .AND.;
		!cTipoTit $ MVABATIM .AND. !(cTipoTit $ MVPAGANT+"/INA"+"/"+MV_CPNEG);
		.AND. Fa340Tit1() SIZE 12, 10 OF oPanel PIXEL
	Endif
	@ 15+nEspLin, 155+nEspLarg	MSGET cFornece Valid fa340For(cFornece) SIZE 70, 10 OF oPanel PIXEL
	@ 15+nEspLin, 226+nEspLarg	MSGET cLoja  							Valid Fa340For(cFornece,cLoja) ;
	SIZE 16, 10 OF oPanel PIXEL
	
	@ 47+nEspLin, 006+nEspLarg	MSGET cSaldo WHEN .F.   			SIZE 41, 10 OF oPanel PIXEL
	@ 47+nEspLin, 060+nEspLarg	MSGET nMoeda  WHEN .F.	 SIZE 18, 10 OF oPanel PIXEL
	@ 47+nEspLin, 085+nEspLarg	MSGET oValorCp VAR nValor  Picture	"@E 9999,999,999.99";
	Valid nValor >= 0 .AND. nValor <= nSaldo;
	SIZE 52, 10 OF oPanel PIXEL HASBUTTON
	oValorCp:cReadvar:= "NLIM450"
	@ 47+nEspLin, 142+nEspLarg	MSGET dBaixa   Valid dBaixa >= SE2->E2_EMISSAO .and. ;
	If(ExistBlock("F340DTFIN") .and. ExecBlock("F340DTFIN",.F.,.F.),DtMovFin(dBaixa),) SIZE 41, 10 OF oPanel PIXEL  HASBUTTON
	@ 47+nEspLin, 185+nEspLarg MSGET oNumCont VAR cNumCont SIZE 50, 10 Picture "@!" OF oPanel PIXEL                                      	
	oNumCont:lVisible := .F.

	@ 07+nEspLin, 006+nEspLarg SAY OemToAnsi(STR0006)  SIZE 21, 7 OF oPanel PIXEL  //"Prefixo"
	@ 07+nEspLin, 032+nEspLarg SAY OemToAnsi(STR0007)  SIZE 22, 7 OF oPanel PIXEL  //"N£mero"
	@ 06+nEspLin, 105+nEspLarg SAY OemToAnsi(STR0008)  SIZE 23, 7 OF oPanel PIXEL  //"Parcela"
	@ 06+nEspLin, 129+nEspLarg SAY OemToAnsi(STR0009)  SIZE 14, 7 OF oPanel PIXEL  //"Tipo"
	@ 06+nEspLin, 155+nEspLarg SAY OemToAnsi(STR0010)  SIZE 34, 7 OF oPanel PIXEL  //"Fornecedor"
	@ 06+nEspLin, 226+nEspLarg SAY OemToAnsi(STR0011)  SIZE 14, 7 OF oPanel PIXEL  //"Loja"
	
	@ 38+nEspLin, 006+nEspLarg SAY OemToAnsi(STR0012)  SIZE 34, 7 OF oPanel PIXEL  //"Saldo"
	@ 38+nEspLin, 060+nEspLarg SAY OemToAnsi(STR0013)  SIZE 21, 7 OF oPanel PIXEL  //"Moeda"
	@ 38+nEspLin, 085+nEspLarg SAY OemToAnsi(STR0014)  SIZE 55, 7 OF oPanel PIXEL  //"Valor a compensar"
	@ 38+nEspLin, 142+nEspLarg SAY OemToAnsi(STR0015)  SIZE 45, 7 OF oPanel PIXEL  //"Data da Baixa"
	@ 37+nEspLin, 185+nEspLarg CHECKBOX oChkFltMed VAR lCheck PROMPT OemToAnsi(STR0063) SIZE 80,7 PIXEL OF oPanel ON CLICK(oNumCont:lVisible := lCheck, IIf(!lCheck, cNumCont := Space(TamSX3("E2_MDCONTR")[1]), .T.) ,oNumCont:Refresh())  //#"Filtra Medicao" 
	
	If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
		SX3->(DbSetorder(2))
		SX3->(DbSeek("E5_DIACTB"))
		cCodDiario  := Criavar("E5_DIACTB",.T.)
		cTitDiar :=  AllTrim(X3TITULO())
		SX3->(DbSetorder(1))
		@ 038+nEspLin, 192+nEspLarg SAY cTitDiar SIZE 45, 7 OF oPanel PIXEL
		@ 047+nEspLin, 192+nEspLarg MSGET cCodDiario F3 "CVL" SIZE 20, 10 OF oPanel Valid VldCodSeq( cCodDiario ) When CtbWdia() PIXEL HASBUTTON
	Endif
	
	If lPanelFin  //Chamado pelo Painel Financeiro
		aButtonTxt := {} 	// esse array deve ser reiniciado do zero pois uma vez com conteudo e o processo
		// for reiniciado, seu conteudo sera adicionado quantas vezes se reiniciar, e assim
		// sera exibido varios botoes na barra de ferramentas
		
		AADD(aButtonTxt,{STR0026,STR0026, {||Fa340SetMo()}})
		
		oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])
		ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
		{||nOpca:=1,If(fa340Tudok(oDlg),oDLg:End(),nOpca:=2)},;
		{||nOpca:=0,oDlg:End()},,aButtonTxt)
		
		FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)
		
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para tramento das Moedas (aTxMoedas)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("F340TAXA")
			ExecBlock("F340TAXA",.F.,.F.,{aTxMoedas})
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Botao de Taxas de cada Moeda³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ 68, 05 BUTTON OemToAnsi(STR0026) SIZE 50,18 ACTION (Fa340SetMo()) OF oPanel PIXEL //Taxas Moedas
		
		DEFINE SBUTTON FROM 68, 190 TYPE 1 ENABLE ACTION (nOpca:=1,If(fa340Tudok(oDlg),oDLg:End(),nOpca:=2)) OF oPanel
		DEFINE SBUTTON FROM 68, 218 TYPE 2 ENABLE ACTION (nOpca:=0,oDlg:End()) OF oPanel
		ACTIVATE MSDIALOG oDlg CENTERED
		
	Endif
	
	IF nOpca == 0
		DbSelectArea(cAlias)
		dbSetOrder(nOrdem)
		Exit
	EndIF
	
	If nOpca == 2  //Dados Invalidos	validados no botao OK
		Loop
	Endif
	
	dbSelectArea(cAlias)
	nRecNo	:= RecNo()

	//Fa340Tit() //Gera Tabela com os titulos - aTitulos
	
	cNumCont := ALLTRIM(cNumCont)
	Fa340Tit(cNumCont,0) //Gera Tabela com os titulos - aTitulos
	If Len(aTitulos) == 0
		Help(" ",1,"NOTITSEL")
		Exit
	EndIf
	
	aTitAux := AClone(aTitulos)
	If ExistBlock("F340ATLIS")
		aTitulos := ExecBlock("F340ATLIS", .F., .F.,{aTitulos})
		If ValType(aTitulos) <> "A"
			aTitulos := AClone(aTitAux)
		Endif
	Endif
	
	If lBxINSSAut .and. MV_PAR10 == 1  
		If SE2->E2_INSS > 0
			dbSelectArea(cAlias)
			If SE2->E2_TIPO $ MVPAGANT
				dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCINS+"INA"+GetMV("MV_FORINSS")+Space(Len(SE2->E2_FORNECE)-Len(GetMV("MV_FORINSS")))+PadR( "00", TamSX3("A2_LOJA")[1], "0" ) ))
			Else
				dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCINS+MVINSS+GetMV("MV_FORINSS")+Space(Len(SE2->E2_FORNECE)-Len(GetMV("MV_FORINSS")))+PadR( "00", TamSX3("A2_LOJA")[1], "0" ) ))			
			EndIf
			cTitPaiINS	:= SE2->E2_TITPAI
			nOldSaldo	:= nSaldo
			nSaldo 	:= SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
			nRecnoINSS	:= Recno()
			Fa340Tit(cNumCont,1) //Gera Tabela com os titulos INSS- aTitINSS
			dbSelectArea(cAlias)
			dbGoTo(nRecno)
			nSaldo 		:= nOldSaldo
		Endif
	Endif
	
	nQtdTit := 0	 // quantidade de titulos,mostrado no rodape do browse
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulos a compensar         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpca   := 0
	
	aSize := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	oDLg:lMaximized := .T.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP
	
	@003,005 Say STR0042 + Pad(Getmv("MV_SIMB"+Alltrim(STR(SE2->E2_MOEDA))),4)  PIXEL Of oPanel  // "Compensaçäo de Titulos - Valores expressos em "
	
	If cPaisLoc == "BRA"
		@ 1.0, 1.0 LISTBOX oTitulo   VAR cVarQ Fields;
		HEADER "",OemToAnsi(STR0006),;  //"Prefixo"
		OemToAnsi(STR0007),;  //"N£mero"
		OemToAnsi(STR0008),;  //"Parcela"
		OemToAnsi(STR0009),;  //"Tipo"
		OemToAnsi(STR0016),;  //"Saldo do t¡tulo"
		OemToAnsi(STR0017),;   //"Valor compensado"
		OemToAnsi(STR0064),;   //"Limite de compensação"
		STR0038,; //"Acréscimos"
		STR0039,; //"Decréscimos"
		OemToAnsi(STR0010),;   //"Fornecedor"
		OemToAnsi(STR0027),;   //"Emissao"
		OemToAnsi(STR0043);
		COLSIZES 12, GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
		GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBB"),;
		GetTextWidth(0,"BBBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
		GetTextWidth(0,"BBBBBBBBBB");
		SIZE 293,54.5 ON DBLCLICK (aTitulos:=FA340Troca(oTitulo:nAt,aTitulos,oGet01),oTitulo:Refresh()) NOSCROLL
		
		oTitulo:SetArray(aTitulos)
		oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,8],oOk,oNo),;
		aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
		aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
		aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
		aTitulos[oTitulo:nAt,22],;
		aTitulos[oTitulo:nAt,10],aTitulos[oTitulo:nAt,11],;
		aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,12],;
		aTitulos[oTitulo:nAt,13]}}  
	Else
		@ 1.0, 1.0 LISTBOX oTitulo   VAR cVarQ Fields;
		HEADER "",OemToAnsi(STR0006),;  //"Prefixo"
		OemToAnsi(STR0007),;  //"N£mero"
		OemToAnsi(STR0008),;  //"Parcela"
		OemToAnsi(STR0009),;  //"Tipo"
		OemToAnsi(STR0016),;  //"Saldo do t¡tulo"
		OemToAnsi(STR0017),;   //"Valor compensado"
		STR0038,; //"Acréscimos"
		STR0039,; //"Decréscimos"                                k
		OemToAnsi(STR0010),;   //"Fornecedor"
		OemToAnsi(STR0013),;   //"Moeda"
		OemToAnsi(STR0027);   //"Emissao"
		COLSIZES 12, GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
		GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBB"),;
		GetTextWidth(0,"BBBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBB");
		SIZE 293,54.5 ON DBLCLICK (aTitulos:=FA340Troca(oTitulo:nAt,aTitulos,oGet01),oTitulo:Refresh()) NOSCROLL
		
		oTitulo:SetArray(aTitulos)
		oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,8],oOk,oNo),;
		aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
		aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
		aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
		aTitulos[oTitulo:nAt,11],aTitulos[oTitulo:nAt,12],;
		aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,9],;
		aTitulos[oTitulo:nAt,10]}}
	EndIf
	//////////////////////////
	// Marca ou desmarca todos
	oTitulo:bHeaderClick := {|oObj,nCol| If( nCol==1, fMarkAll(@aTitulos, @nValTot),Nil), oTitulo:Refresh(),oGet01:Refresh()}
	oTitulo:Align := CONTROL_ALIGN_ALLCLIENT
	//---
	@  4, 353 SAY STR0031 PIXEL OF oPanel SIZE 70,7
	@	4, 403 MSGET oGet01 VAR nValTot PICTURE "@E 999,999,999.99" WHEN .F. PIXEL OF oPanel SIZE 70,7
	
	If !lPanelFin  //Chamado pelo Painel Financeiro
		oPanel2 := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,20,20,.T.,.T. )
		oPanel2:Align := CONTROL_ALIGN_BOTTOM
		
		@  4, 008 BUTTON STR0030 SIZE 50,11 ACTION ( Fa340Inver(@aTitulos,@oTitulo,@oGet01) ) OF oPanel2 PIXEL
		@  4, 065 BUTTON STR0001 SIZE 50,11 ACTION PesqListBox(@oTitulo,aTitulos) OF oPanel2 PIXEL
	Else
		aButtonTxt := {}
		AADD(aButtonTxt,{STR0045,STR0030, {||Fa340Inver(@aTitulos,@oTitulo,@oGet01)}})
		AADD(aButtonTxt,{STR0001,STR0001, {||PesqListBox(@oTitulo,aTitulos)}})
	Endif
	
	
	If lPanelFin  //Chamado pelo Painel Financeiro
		ACTIVATE MSDIALOG oDlg ON INIT (oTitulo:Refresh(), FaMyBar(oDlg,;
		{|| nOpca := 1,IF(Fa340OK(),oDlg:End(),nOpca:=0)},;
		{|| oDlg:End()},,aButtonTxt))
	Else
		DEFINE SBUTTON FROM 4 ,325 TYPE 1 ACTION (nOpca := 1,IF(Fa340OK(),oDlg:End(),nOpca:=0)) ENABLE OF oPanel2
		DEFINE SBUTTON FROM 4 ,360 TYPE 2 ACTION oDlg:End() ENABLE OF oPanel2
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oTitulo:Refresh())
	Endif

	If nOpcA == 2
		Loop
	ElseIf nOpcA == 0 .or. nOpca == 3
		F340Semaforo(aTitulos,.F.,0)
		Exit
	Else
		If Str(nValtot,17,2) != Str(nValor,17,2) .and. nValor != 0 .and. nOpca == 1
			Help(" ",1,"FA330COMP")
			Loop
		Endif
		nValor := (Int(nValTot*100)/100)
		If Str(nValor,17,2) > Str(nSaldo,17,2)
			Help(" ",1,"FA330IVAL")
			Loop
		EndIf

		DbSelectArea("SE2")
		nOrdSE2	:= IndexOrd()
		dbGotop()

		lPadrao:=VerPadrao(cPadrao)
		VALOR  	:= 0
		VLRINSTR	:= 0
		ABATIMENTO := 0
		aRegSE2 := {}
		aBaixaSE5 := {}
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para permitir a manipulação dos titulos ³
		//³ selecionados pela markbrowse                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (ExistBlock("F340MKTIT"))    
			aTitulos := ExecBlock("F340MKTIT",.F.,.F.,{aTitulos})   
		Endif 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio da prote‡„o via TTS								  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Begin Transaction
		For nTit := 1 to Len(aTitulos)
			nPosCnt++
			  If aTitulos[nTit,6]<> aTitulos[nTit,IIF(cPaisLoc == "BRA",22,5)] 
				  lAltera:= .T.
			  Else
			  	  lAltera:= .F.
			  Endif 
			 	  
			//proporcionalização do impostos quando posicionado na PA
   			If lPccBaixa .Or. lIRPFBaixa  
   				nValBxliq:=0
				dbGoTo(nRecno) //posiciona no titulo selecionado na tela inicial da compensação
				If lContrRet 
				
					aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa,SE2->E2_PARCISS)				
					nValImp := 0
				   
					If SE2->E2_TIPO $ MVPAGANT+"/INA"
					   	nPis:= 0
		   				nCof := 0
						nCsl := 0
						nIrf := 0 
						nISS := 0	
					Endif												

					For nX := 1 To Len(aImp10925)
						Do Case
							Case Alltrim(aImp10925[nX][5]) $ Alltrim(GetMv("MV_PISNAT"))
								nPis+=aImp10925[nX][6]
							Case Alltrim(aImp10925[nX][5]) $ Alltrim(GetMv("MV_COFINS"))
								nCof+=aImp10925[nX][6]				
							Case Alltrim(aImp10925[nX][5]) $ Alltrim(GetMv("MV_CSLL"))
								nCsl+=aImp10925[nX][6]  
							Case Alltrim(aImp10925[nX][5]) $ Alltrim(&(GetMv("MV_IRF")))
								nIrf+=aImp10925[nX][6]
							Case Alltrim(aImp10925[nX][5]) $ Alltrim(&(GetMv("MV_ISS")))
								nIss+=aImp10925[nX][6]
				 		EndCase 
						nValImp += aImp10925[nX][6]
					Next													
					//Se for PABruto e já tiver retido os impostos em outra compensacao zera o valor dos impostos
					If lPaBruto .and. SE2->E2_TIPO $ MVPAGANT+"/INA" .and. !empty(SE2->E2_TITADT)
						nValImp := 0
					EndIf
					
				Endif  
				If lPropPA .and.  lPrImPA .and. (lPccBaixa .Or. lIRPFBaixa).and. lValPgto
					 If !lPaBruto .And. SE2->E2_TIPO $ MVPAGANT+"/INA" .And. SE2->E2_BASEPIS > 0 .And. lPropPA 
					   	nSaldoProp:= F340CompSal()   
   						nValBxliq := aTitulos[nTit,9]   //  valor de baixa da PA
						nValBxliq2:= aTitulos[nTit,9]	//valor de baixa da NF 

					   	If nSaldo==nValor  //Indica que a compensação será total
					   	   	If nValor>aTitulos[nTit,9] .and. aTitulos[nTit,23]<>aTitulos[nTit,18]//indica que o titulo posicionado não é o total a ser baixado e a PA é maior q a NF								
								nProp	  :=   aTitulos[nTit,9]/SE2->E2_BASEPIS
					   	   	Elseif  (nValor>aTitulos[nTit,9] .OR. aTitulos[nTit,20]<SE2->E2_BASEPIS  ) .and. aTitulos[nTit,9]==aTitulos[nTit,21]   // indica baixa total e a PA é menor que a NF
					   	   	     nProp	  :=	aTitulos[nTit,20]/SE2->E2_BASEPIS  	
					   	   	Elseif nValor==aTitulos[nTit,9] .and. aTitulos[nTit,9]==aTitulos[nTit,21] .AND. aTitulos[nTit,20]==SE2->E2_BASEPIS    // indica baixa total e a PA igual NF 
			 		   	   		 nSaldoProp:= F340CompSal(aRecNo[nTit],.T.)//retorna saldo a prop da NF
  		   	   		 	  	  	 nProp	  :=   nSaldoProp/SE2->E2_BASEPIS // porporcionaliza sobre a base restante  
  		   	   		 	 	Elseif aTitulos[nTit,20]>SE2->E2_BASEPIS //indica que a PA< NF
  		   	   		 	 			 nSaldoProp:= F340CompSal(SE2->(Recno()),.T.)
  		   	   		 	  	  		 nProp	  :=   nSaldoProp/SE2->E2_BASEPIS
					   	   	Endif
					    Else
					   	   	If aTitulos[nTit,9]==aTitulos[nTit,21] .and. aTitulos[nTit,20]<SE2->E2_BASEPIS .and. !lAltera // indica que a PA é maior que a NF e a compensação da NF será total
					   	   	   	If aTitulos[nTit,9]== aTitulos[nTit,23] //indica que é a primeira baixa da NF e será total
					   	   	    	nProp	  :=	aTitulos[nTit,20]/SE2->E2_BASEPIS  
					   	   	    Else 
					   	   	    	nSaldoProp:= F340CompSal(aRecNo[nTit],.T.)
					   	   		   	nProp	  :=   nSaldoProp/SE2->E2_BASEPIS // porporcionaliza sobre a base restante
					   	   	    Endif
					   	  	Else  
					   	  		If SE2->E2_SALDO> aTitulos[nTit,21] .AND. aTitulos[nTit,9]==aTitulos[nTit,21].and. !lAltera // INDICA QUE O TITULO SOFREU BAIXA PARCIAL E O SALDO É MENOR QUE A BASE DE CALCULO DA PA
					   	  			nSaldoProp:= F340CompSal(aRecNo[nTit],.T.)                                              // e a baixa da NF será total
					   	   		   	nProp	  :=   nSaldoProp/SE2->E2_BASEPIS // porporcionaliza sobre a base restante
					   	   		Else
					   	   			nProp	  :=	aTitulos[nTit,9]/SE2->E2_BASEPIS  
					   	   		Endif
					   	   	Endif   

					   	Endif
					Endif
				EndIf
		  	EndIf
			// Zero a variavel que soma os impostos (lei 10925) do titulo.
			nValImp := 0
			nValImpPa := 0
			nPixTx    := 0
			nCofTx    := 0
			nCslTx    := 0
			lBaixaImp := .F.
			lGeraNdf  := .F.
			lGeraTx   := .F.
			
			IF aTitulos[nTit,8]
				IF lPadrao .and. !lContabil .and. mv_par11 == 1
					nTotal := 0
					lContabil := .t.
					nHdlPrv := HeadProva( cLote,;
					                      "FINA340",;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )
				EndIf
				// Posiciona no PA/NDF				
				dbSelectArea("SE2")
				dbGoTo(aRecNo[nTit])
				aAdd(aRegSE2, aRecNo[nTit])
				cAdiantamento := E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
				cChave := "SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO"
				//Identifica se uma compensacao partiu de um PA
				If !(SE2->E2_TIPO $ MVPAGANT+"/INA")
					lPa := .T.
					//Tratamento E2_PRETPIS <> "4" para caso PCC tenha sido gerado no bordero
					If !Empty(E2_BASEPIS) .and. E2_PIS > 0  .and. SE2->E2_PRETPIS <> "4" // Posicionado no principal
						lGeraTx := .T.
						nPisTx := SE2->E2_PIS
						nCofTx := SE2->E2_COFINS
						nCslTx := SE2->E2_CSLL
					EndIf
					If lPaBruto .and. (lContrRet .Or. lIRPFBaixa) .and. Empty(SE2->E2_TITADT) //Verifico se os impostos deste PA ja foram retidos
						dbGoTo(nRecno) //Posiciona no PA para calcular impostos
						
						If Empty(SE2->E2_TITADT) //Verifico se os impostos deste PA ja foram retidos
						
							aImp10925pa := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa)
							
							For nX := 1 To Len(aImp10925pa)
							
								nValImpPa += aImp10925pa[nX][6]
								
							Next
							If Len(aImp10925pa) > 0 .And. (!lIRPFBaixa .Or. lPccBaixa)
								If !Empty(SE2->E2_PARCPIS)
									nPisTx -= aImp10925pa[1][6]
								ElseIf !Empty(SE2->E2_PARCCOF)
									nCofTx -= aImp10925pa[2][6]
								ElseIf !Empty(SE2->E2_PARCSLL)
									nCslTx -= aImp10925pa[3][6]
								EndIf
							EndIf
							
						EndIf
						
						dbGoTo(aRecNo[nTit]) //Volta no título principal
					EndIf
				EndIf
				// Verifica os valores dos Txs (lei 10925) para subtrair do saldo do PA.
				If lContrRet .Or. lIRPFBaixa
				
					aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa,SE2->E2_PARCISS)				
	
					For nX := 1 To Len(aImp10925)
						//tratamento para o PCC que foi gerado pela NF no bordero
						If nX == 1 .And. SE2->E2_PRETPIS <> "4"
							nValImp += aImp10925[nX][6]
						ElseIf nX == 2 .And. SE2->E2_PRETCOF <> "4"
							nValImp += aImp10925[nX][6]
						ElseIf 	nX == 3 .And. SE2->E2_PRETCSL <> "4"
							nValImp += aImp10925[nX][6]
						ElseIf nX >= 4
							nValImp += aImp10925[nX][6]	
						EndIf	
					Next 
					
				    If !lCalcIssBx .and. !lPrImPA .and. SE2->E2_ISS>0
   						nValImp += SE2->E2_ISS
					EndIf
					
				    If !lIRPFBaixa .and. SE2->E2_IRRF>0 .and. !lPAbruto .And. SE2->E2_TIPO $ MVPAGANT 					
						nValImp += SE2->E2_IRRF
				    EndIf	

					//Se for PABruto e já tiver retido os impostos em outra compensacao zera o valor dos impostos
					If lPaBruto .and. SE2->E2_TIPO $ MVPAGANT+"/INA" .and. !empty(SE2->E2_TITADT)
						nValImp := 0
					EndIf					
					
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se Considera Fornecedor Original  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cAdiantamento += SE2->E2_FORNECE
				cChave +="+SE5->E5_CLIFOR"
				cAdiantamento += SE2->E2_LOJA
				cChave += "+SE5->E5_LOJA"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valor da baixa na moeda 1 							  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPaisLoc == "BRA"
					nValBx := aTitulos[nTit,9]
					nAcresc := Fa340VTit(aTitulos[nTit,10])
					nDecres := Fa340VTit(aTitulos[nTit,11])
				Else
					nValBx := Fa340VTit(aTitulos[nTit,6])
					nAcresc := Fa340VTit(aTitulos[nTit,11])
					nDecres := Fa340VTit(aTitulos[nTit,12])
				Endif
				
				IF lPadrao
				   If cPaisLoc == "BRA"								
					  nValorComp += Round(NoRound(xMoeda(nValBx,nMoeda,1,,3,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
				   Else
				      nValorComp += xMoeda(nValBX,nMoeda,1,aTitulos[nTit,10],,aTxMoedas[aTitulos[nTit,9]][2])										   
				   EndIf	   										  
				EndIf
				
				dbSelectArea("SE2")
				dbGoTo(nRecNo)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Guardo dados do titulo principal para utilizar   ³
				//³ no historico da contabiliza‡Æo                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				STRLCTPAD := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+;
								 SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA

				CODFORCP := SE2->E2_FORNECE
				LOJFORCP := SE2->E2_LOJA
				
				//Controle de PABruto
				If !Empty(E2_BASEPIS) .and. E2_PIS > 0 .and. !lPA
					nPisTx := SE2->E2_PIS
					nCofTx := SE2->E2_COFINS
					nCslTx := SE2->E2_CSLL
				EndIf 
				If lPropPA .and.  lPrImPA .and. !lPA  .and. lValPgto
        			If lPccBaixa 
				 		nPis	:= SE2->E2_PIS
				 		nCof 	:= SE2->E2_COFINS
				  		nCsl 	:= SE2->E2_CSLL 
				  	Endif
					nIrf	:= If(lIRPFBaixa ,SE2->E2_IRRF,0)
					nInss	:= SE2->E2_INSS	
					nIss	:= SE2->E2_ISS
				Else
					If lPa .And. lIRPFBaixa .and. nProp == 1 
						nIrf	:= SE2->E2_IRRF	
						//Verifica se ja houve alguma compensacao da PA que reteve o IR para nao reter novamente				
						nIrf -= Fin340SE5IR()											
					EndIf	
				Endif  
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valor da Baixa na moeda do titulo principal 	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPaisLoc == "BRA"
					nValBx2 := aTitulos[nTit,9]
					nAcresc := Fa340VTit(aTitulos[nTit,10])
					nDecres := Fa340VTit(aTitulos[nTit,11])
					
					nValDif	:=	0
					If !lPropPA .And. lIRPFBaixa .And. SE2->E2_IRRF == 0
		 					For nX := 1 To Len(aImp10925)
								If Alltrim(aImp10925[nX][5]) = "IRF"
									nValDif += aImp10925[nX][7]
								Endif	
							Next 							
					Else		
						nValDif :=	SE2->E2_IRRF 			
					Endif
					If lPropPA .and.  lPrImPA .and. (lPccBaixa .Or. lIRPFBaixa) .and. lValPgto
					  	  	If !lPaBruto .And. !(SE2->E2_TIPO $ MVPAGANT+"/INA") .And. SE2->E2_BASEPIS > 0 .And. lPropPA .and. !lPa 
					  		   	nSaldoProp:= F340CompSal(SE2->(Recno()))
      
   								nValBxliq := aTitulos[nTit,9]   //  valor de baixa da PA
							  	nValBxliq2:= aTitulos[nTit,9]	//valor de baixa da NF 

					   	   		If nSaldo==nValor  //Indica que a compensação será total
					   	   		  	If nValor>aTitulos[nTit,9] .and. aTitulos[nTit,23]<>aTitulos[nTit,21]//indica que o titulo posicionado não é o total a ser baixado e a NF é maior q a PA
					   	   		  	  	  	nSaldoProp:= F340CompSal(aRecNo[nTit],.T.)
					   	   		 	  	  	nProp	  :=   nSaldoProp/SE2->E2_BASEPIS // porporcionaliza sobre a base restante
					   	   		 	Elseif  nValor>aTitulos[nTit,9] .and. aTitulos[nTit,23]==aTitulos[nTit,21]   // indica baixa total e a NF é menor que a PA
					   	   		   		nProp	  :=	aTitulos[nTit,20]/SE2->E2_BASEPIS  	
					   	   		 	Else      
					   	   		 		nProp:= nSaldoProp/(If(lPccBaixa,SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL,0)+ If(lIRPFBaixa,SE2->E2_IRRF,0)+if(lCalcIssBx,SE2->E2_ISS,0))       
					   	   		  	Endif
					   	   	    Else
					   	   	    	If aTitulos[nTit,9]==aTitulos[nTit,21] .and. aTitulos[nTit,20]<SE2->E2_BASEPIS // indica que a NF é maior que a PA e a compensação da PA será total
					   	   	    	
					   	   	    		If aTitulos[nTit,9]== aTitulos[nTit,23] //indica que é a primeira baixa da PA e será total
					   	   	    			nProp	  :=	aTitulos[nTit,20]/SE2->E2_BASEPIS  
					   	   	    		Else 
					   	   	    			nSaldoProp:= F340CompSal(aRecNo[nTit],.T.)
					   	   		 	  	  	nProp	  :=   nSaldoProp/SE2->E2_BASEPIS // porporcionaliza sobre a base restante
					   	   	    		Endif
					   	   		 	Else
					   	   	       		nProp	  :=	aTitulos[nTit,9]/SE2->E2_BASEPIS  
					   	   	       	Endif   

					   	   	    Endif
						  	Endif
					EndIf
											
					//Tratamento PA Bruto
					If lPaBruto .and. !lPa	//Compensacao partiu do titulo principal
						If SE2->E2_SALDO >= (nValBx2 + nValImp)
							lBaixaImp := .T.
						ElseIf SE2->E2_SALDO == (Fa340VTit(aTitulos[nTit,5]) - Iif(lPropPA,nValImp,Iif(lIRPFBaixa,nValImp-nValDif,nValImp))) 
							lGeraNDF := .T.
							If !Empty(E2_BASEPIS) .and. E2_PIS > 0
								lGeraTX := .T.
								nPisTx  -= aImp10925[1][6]
								nCofTx  -= aImp10925[2][6]
								nCslTx  -= aImp10925[3][6]
							EndIf
						ElseIf SE2->E2_SALDO < nValBx2
							nValBx  := SE2->E2_SALDO
							nValBx2 := SE2->E2_SALDO
						EndIf
					ElseIf lPaBruto .and. lPa	//Compensação partiu do PA
						If Fa340VTit(aTitulos[nTit,5]) >= (nValBx2 + nValImpPa)
							lBaixaImp := .T.
						ElseIf Fa340VTit(aTitulos[nTit,5])- Iif(lIRPFBaixa .And. !lPropPA,SE2->E2_IRRF,0) == SE2->E2_SALDO
							lGeraNDF := .T.
						EndIf
					EndIf
				Else
					If cPaisLoc == "BOL"                     
						// Tratamento especifico para bolivia para considerar nValComp com 5 casas decimais
						// devido a erro de arredondamento no cancelamento da compensacao
						If aTitulos[nTit,5] <> aTitulos[nTit,6] //se for compensação parcial
							nValBx2 := Round(NoRound(Fa340VTit(aTitulos[nTit,6]),3),2)
						Else
							nValBx2 := aTitulos[nTit,13]
						EndIf
					Else
						nValBx2 := Fa340VTit(aTitulos[nTit,6])
					EndIf
					nAcresc := Fa340VTit(aTitulos[nTit,11])
					nDecres := Fa340VTit(aTitulos[nTit,12])
				Endif
				
				If cPaisLoc == "BRA"
					nValorDec	+= Round(NoRound(xMoeda(nDecres,nMoeda,1,,3,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
					nValorAcre 	+= Round(NoRound(xMoeda(nAcresc,nMoeda,1,,3,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
				Else
					nValorDec  += xMoeda(nDecres,nMoeda,1,aTitulos[nTit,10],,aTxMoedas[aTitulos[nTit,9]][2])										   
					nValorAcre += xMoeda(nAcresc,nMoeda,1,aTitulos[nTit,10],,aTxMoedas[aTitulos[nTit,9]][2])										   
				EndIf

				//Verifica se o valor do acrescimo e maior que o da baixa.
				If nAcresc > nValBx2                                
					nAcresc := nValBx2	
				Endif
				If lPrImPA .and. SE2->E2_TIPO $ MVPAGANT+"/INA" .and. lPa
						If !(aTitulos[nTit,4] $ MVPAGANT+"/INA")
				  			aAreaSE2 := SE2->(GetArea()) 
				  			dbSelectArea("SE2")
							dbGoTo(aRecNo[nTit]) 
					   		//chamada da função para retornar PCC e IR proporcional 
					   		nPis:=nPis*nprop
					   		nCof:=nCof*nprop
					   		nCsl:=nCsl*nprop
					   		nIrf :=nIrf*nprop 
   							nISS :=nISS*nprop
							nIns :=nIns*nprop
					   	   
						   	RestArea(aAreaSE2)  
						Endif  
			   	EndIf  
			  	If lPrImPA .and. !(SE2->E2_TIPO $ MVPAGANT+"/INA") .and. !lPa      
			  		//chamada da função para retornar PCC e IR proporcional 
					nPis:=nPis*nprop
					nCof:=nCof*nprop
					nCsl:=nCsl*nprop
					nIrf :=nIrf*nprop 
					nISS :=nISS*nprop
					nIns :=nIns*nprop
					If lAltera
						nValBxliq := aTitulos[nTit,9] - (If(lPccBaixa,nPis+nCof+nCsl,0)+ If(lIRPFBaixa,nIrf,0)+if(lCalcIssBx,nIss,0))  //  valor de baixa da PA
						nValBxliq2:= aTitulos[nTit,9] - (If(lPccBaixa,nPis+nCof+nCsl,0)+ If(lIRPFBaixa,nIrf,0)+if(lCalcIssBx,nIss,0))	//valor de baixa da NF    
					Endif
			   	EndIf
				If nValBxliq2==0
					nValBxliq2:= nValBx2 				
				Endif
				If nValBxliq==0
					nValBxliq:= nValBx 				
				Endif
				cSeqImp := SE5->E5_SEQ

				IF cPaisLoc == "BRA" 
					Fa340Grv(lPadrao,iif(!lPaBruto .And. SE2->E2_TIPO $ MVPAGANT+"/INA",nValBx+IIf(lIRPFBaixa,nValImp,0),nValBx2),;
							cAdiantamento,,aRecno[nTit],lDebito,mv_par11,Fa340TxMd(nMoeda,nTxMoeda),nAcresc,nDecres,aBaixaSE5,;
							If(!lPaBruto .and. lBaixaImp,If(lPA,nValImpPa,nValImp),0),,Iif(lPa, nValBxliq2,nValBxLiq),nPis,nCof,nCsl,nIrf,Iif(lCalcIssBx,nIss,0),(aTitulos[nTit,20]*nProp))							
				ELSE
					Fa340Grv(lPadrao,nValBx2,cAdiantamento,,aRecno[nTit],lDebito,mv_par11,Fa340TxMd(nMoeda,nTxMoeda),nAcresc,nDecres,aBaixaSE5,If(lPaBruto .and. !lBaixaImp,If(lPA,nValImpPa,nValImp),0))
				ENDIF
		
				If lPrImPA .and. SE2->E2_TIPO $ MVPAGANT+"/INA" .and. lPa
			   		nValBx := aTitulos[nTit,9]
				EndIf 
				If lPrImPA .and. !(SE2->E2_TIPO $ MVPAGANT+"/INA") .and. !lPa 
			 		nValBx :=nValBxLiq  
			 	Endif
			 	If lPrImPA .and. SE2->E2_TIPO $ MVPAGANT+"/INA" .and. lPa 
			 		nValBx :=nValBxLiq2
			 	Endif 
					nValBxLiq  := 0  
					nValBxliq2 := 0
				//Ponto de entrada 
				
				//Se a compensacao partiu do titulo principal
				If !lPa
					If lBaixaImp
						//"Parti do princ, baixa imp"
						Fa340BxTxPa(aRecNo[nTit])
					ElseIf lGeraNDF
						//"Parti do princ, gera NDF"
						FA340GeraNDF(nRecno,nValImp+If(lGeraTx,nPisTx+nCofTx+nCslTx,0),cAdiantamento,lGeraTx)
						//Vou Gerar Tx com os impostos que não foram retidos no PA
						If lGeraTx
							SE2->(dbGoTo(nRecno))
							cLa := SE2->E2_LA
							RecLock("SE2")
							SE2->E2_LA := " " //Limpo flag de contabilização para gerar TX 
							MsUnlock()
							FGrvImpPcc(nPisTx,nCofTx,nCslTx,nRecno,.F.,,,"FINA340",nMoeda)

							SE2->(dbGoTo(nRecno))
							If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
								aAdd( aFlagCTB, {"E2_LA", "S", "SE2", SE2->( Recno() ), 0, 0, 0} )
							Else
								RecLock("SE2")
								SE2->E2_LA := cLa
								MsUnlock()
							EndIf
						EndIf
					EndIf
				Else //Se partiu de PA
					If lBaixaImp
						//"Parti do PA, baixa imp"
						Fa340BxTxPa(nRecno)
					ElseIf lGeraNDF
						//"Parti do PA, gera NDF"
						FA340GeraNDF(aRecNo[nTit],nValImpPa+If(lGeraTx,nPisTx+nCofTx+nCslTx,0),SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),lGeraTx)
						//Vou Gerar Tx com os impostos que não foram retidos no PA
						If lGeraTx
							SE2->(dbGoTo(aRecNo[nTit]))
							cLa := SE2->E2_LA
							RecLock("SE2")
							SE2->E2_LA := " " //Limpo flag de contabilização para gerar TX 
							MsUnlock()
							FGrvImpPcc(nPisTx,nCofTx,nCslTx,aRecNo[nTit],.F.,,,"FINA340",nMoeda)

							SE2->(dbGoTo(aRecNo[nTit]))
							If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
								aAdd( aFlagCTB, {"E2_LA", "S", "SE2", SE2->( Recno() ), 0, 0, 0} )
							Else
								RecLock("SE2")
								SE2->E2_LA := cLa
								MsUnlock()
							EndIf
						EndIf						
					EndIf
				EndIf

				//Verifica se existe solicitacao de NCP e caso exista atualiza o campo CU_DTBAIXA...			
				If cPaisLoc <> "BRA"				   				   
					A055AtuDtBx("1",SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NUM,SE2->E2_PREFIXO,SE2->E2_BAIXA)
				EndIf


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no adiantamento para contabiliza‡„o    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE2")
				dbGoTo(aRecNo[nTit])
				DbSelectArea("SED")
				DbSetOrder(1)
				DbSeek(xFilial("SED")+SE2->E2_NATUREZ)
				dbSelectArea("SE2")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de Entrada				     		  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lF340NAT
					Execblock("F340NAT",.F.,.F.,nRecno)
				Endif
				dbSelectArea("SE2")
				dbGoTo(aRecNo[nTit])
				// Nao somo abatimentos, se o titulo for de debito
				If !(SE2->E2_TIPO $ MV_CPNEG + "/" + MVPAGANT+"/INA")
					nTotAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
				Else
					nTotAbat := 0	
				Endif	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza saldo do PA/NDF                      	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Reclock("SE2")
				If cPaisLoc == "BRA"				
					//Atualiza a data de vencimento dos titulos de impostos
					If lDebito
						AltVencImp(dDataBase)
					Endif
					If (lPccBaixa .Or. lIRPFBaixa) .AND. !lPaBruto .AND. lPrImPA  .and. lPropPA .and. SE2->E2_TIPO $ MVPAGANT+"/INA" .and. lValPgto
						nValliq:= SE2->E2_SALDO
					Endif
					// Se estiver baixando tudo, zera o saldo
					If nValBx == Fa340VTit(aTitulos[nTit,5]) - IIf(!lPaBruto,nValImp,0)
						SE2->E2_SALDO := 0
						SE2->E2_SDACRES := 0
						SE2->E2_SDDECRE := 0						
						If (lPccBaixa .Or. lIRPFBaixa) .and. !lPaBruto .And. SE2->E2_BASEPIS > 0 .And. lPropPA .and. lPa .and. lValPgto
			  				 If  !(SE2->E2_TIPO $ MVPAGANT+"/INA")    
			  				 	nValImp	+= nPis+nCof+nCsl+nIrf+nIss 
			  				 Endif
			  			Elseif SE2->E2_PIS > 0 .OR. SE2->E2_COFINS > 0 .OR. SE2->E2_CSLL > 0 .OR. SE2->E2_IRRF > 0
			  				nValImp	+= If(lPrImPA,If(lRInssPa .AND. SE2->E2_TIPO $ MVPAGANT+"/INA",SE2->E2_INSS,SE2->E2_PRINSS)+SE2->E2_PRISS,0)												
		  				Endif
		  				//Proporcionalizo o imposto, garantindo que o valor esteja de acordo com o valor baixado anteriormente (caso seja compensação parcial)
		  				If nProp < 1
		  					nValImp := nValImp * nProp
		  				EndIf 						
					Else   
						If lPccBaixa .Or. lIRPFBaixa 
								If !lPaBruto .And. SE2->E2_BASEPIS > 0 .And. lPropPA .and. lPa .and. lValPgto;
								.and. (SE2->E2_PIS > 0 .OR. SE2->E2_COFINS > 0 .OR. SE2->E2_CSLL > 0 .OR. SE2->E2_IRRF > 0 .OR. nIss>0) 
			  					  	If  !(SE2->E2_TIPO $ MVPAGANT+"/INA")    
			  				   			nValImp	:= nPis+nCof+nCSL+nIRF+nIss
			  			  	   	 	Endif  
			  					Elseif !lPaBruto.And. lPropPA .and. lValPgto .and. !lPa .and. (SE2->E2_PIS > 0 .OR. SE2->E2_COFINS > 0 .OR. SE2->E2_CSLL > 0 .OR. SE2->E2_IRRF > 0)   
					  				nValImp	+= If(lPrImPA,If(lRInssPa .AND. SE2->E2_TIPO $ MVPAGANT+"/INA",SE2->E2_INSS,SE2->E2_PRINSS)+SE2->E2_PRISS,0)												
		  						Endif 
						   		If !lPaBruto .And. SE2->E2_TIPO $ MVPAGANT+"/INA" .And. SE2->E2_BASEPIS > nBasePis .And. lPropPA .and. lValPgto .and. !lPa 
						   				SE2->E2_SALDO	-= Round(NoRound(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
							   	Else
									SE2->E2_SALDO	-= Round(NoRound(xMoeda(nValBx-nAcresc+If(!lPa,0,nValImp)+nDecres,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
								Endif
						Else
							SE2->E2_SALDO	-= Round(NoRound(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
						EndIf                                                                                        
						SE2->E2_SDACRES	-= Round(Noround(xMoeda(nAcresc,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
						SE2->E2_SDDECRE	-= Round(Noround(xMoeda(nDecres,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
					Endif   
					If lPccBaixa .and. !lPaBruto .and. SE2->E2_TIPO $ MVPAGANT+"/INA" .And. SE2->E2_BASEPIS > nBasePis .And. lPropPA .and. lValPgto .and. !lPa;
						.and. (SE2->E2_PIS > 0 .OR. SE2->E2_COFINS > 0 .OR. SE2->E2_CSLL > 0 .OR. SE2->E2_IRRF > 0).and. !lAltera   
							  SE2->E2_VALLIQ:= Round(NoRound(xMoeda((nValBx-nAcresc+nDecres),nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
					ElseIf lPccBaixa .and. !lPaBruto .and. SE2->E2_TIPO $ MVPAGANT+"/INA" .And. lPropPA .and. !lPa .and. aTitulos[nTit,18]>=nValBx   
						 	 SE2->E2_VALLIQ:= Round(NoRound(xMoeda((nValBx-nAcresc+nDecres),nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
					Else
						  SE2->E2_VALLIQ:= Round(NoRound(xMoeda(nValBx,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
				 	Endif
					SE2->E2_MOVIMEN:= dBaixa					
					If !(SE2->E2_TIPO $ MVPAGANT+"/INA") .and. lPropPA .and. lValPgto .and.  lPrImPA .and. (lPccBaixa .Or. lIRPFBaixa.OR.lCalcIssBx)
					   	If nPis> 0
						   	SE2->E2_VRETPIS	+= nPis 
					   		SE2->E2_PRETPIS	:= "7"
					   	Endif
						If nCsl> 0
							SE2->E2_VRETCSL	+= nCsl  
							SE2->E2_PRETCSL	:= "7"
						Endif
	   	 				If nCof> 0
							SE2->E2_VRETCOF	+= nCof  
							SE2->E2_PRETCOF	:= "7"  
						Endif
						If nIrf> 0
							SE2->E2_VRETIRF	+= nIrf    
							SE2->E2_PRETIRF	:= "7"
					    EndIf   
   						If nIss> 0
							SE2->E2_VRETISS	+= nIss    
					    EndIf
					    
			   		Endif
				Else
					If nValBx == Fa340VTit(aTitulos[nTit,5]) 
						SE2->E2_SALDO := 0
						SE2->E2_SDACRES := 0
						SE2->E2_SDDECRE := 0						
					Else
						nDecs := MsDecimais(SE2->E2_MOEDA)
						nSalTit := SE2->E2_SALDO - Round(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE2->E2_MOEDA,dDatabase,nDecs+1,aTxMoedas[nMoeda][2],aTxMoedas[SE2->E2_MOEDA][2]),nDecs)				
						SE2->E2_SALDO   := Iif(nSalTit <= 0,0,nSalTit)
					EndIf   
					SE2->E2_MOVIMEN := dDatabase				
					SE2->E2_VALLIQ  += Round(xMoeda(nValBx,nMoeda,1,dDatabase,nDecs1+1,aTxMoedas[nMoeda][2]),nDecs1)				
				EndIf   				
				SE2->E2_BAIXA := dDataBase 
				
				// Nao somo abatimentos, se o titulo for de debito
				If !(SE2->E2_TIPO $ MV_CPNEG + "/" + MVPAGANT+"/INA")
					nTotAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
				Else
					nTotAbat := 0	
				Endif				 
					
				IIF(SE2->E2_SALDO>=nTotAbat.and.lDebito,SE2->E2_SALDO-=nTotAbat,NIL)
								   				   
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no registro de natureza		³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))
				// Efetua a baixa dos titulos de abatimento
				If !( E2_TIPO $ MVPAGANT+"/INA"+"/"+MV_CPNEG )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Baixar titulos de abatimento se for baixa total				  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE2")
					nSalvRec := Recno()
					If (E2_SALDO-nTotabat) <= 0
						dbSetOrder(1)
						dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA))
						cPrefixo := SE2->E2_PREFIXO
						cNum := SE2->E2_NUM
						cParcela := SE2->E2_PARCELA
						While !EOF() .And. E2_FILIAL==xFilial("SE2") .And. E2_PREFIXO=cPrefixo 		.And.;
												E2_NUM==cNum 			.And. E2_PARCELA==cParcela
				
							IF E2_FORNECE==cFornece	.And. E2_LOJA == cLoja
								IF E2_TIPO $ MVABATIM
									RecLock("SE2")
									Replace E2_SALDO	  With 0
									Replace E2_BAIXA	  With Iif(E2_BAIXA<=dBaixa,dBaixa,E2_BAIXA)
									Replace E2_LOTE	  With cLote
									Replace E2_MOVIMEN  With dBaixa
									Replace E2_PORTADO  With cBanco
									MsUnlock( )
								EndIF
							Endif
							dbSelectArea( "SE2" )
							dbSkip( )
						Enddo
					Endif
					dbGoto(nSalvRec)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza campo de maior atraso no Cadastro de Fornecedores		³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nAtraso:=dBaixa-SE2->E2_VENCTO
					If nAtraso > 1
						IF Dow(SE2->E2_VENCTO) == 1 .Or. Dow(SE2->E2_VENCTO) == 7
							IF Dow(dBaixa) == 2 .and. nAtraso <= 2
								nAtraso := 0
							EndIF
						EndIF
						nAtraso:=IIF(nAtraso<0,0,nAtraso)
						If SA2->A2_MATR < nAtraso
							dbSelectArea( "SA2" )
							dbSetOrder( 1 )
							If SA2->( MsSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA ) )
								RecLock( "SA2" )
								Replace A2_MATR With nAtraso
								MsUnlock()
							EndIf
						Endif
					Endif
	            Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de Entrada				        	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lF340_PA
					Execblock("F340_PA",.F.,.F.)
				Endif
				MsUnlock()

				//Atualiza dados do fornecedor
				If SE2->E2_MOEDA > 1
					nValPadrao := Round(NoRound(xMoeda(nValBx - nValImp,nMoeda,SE2->E2_MOEDA,,3,,If(cPaisLoc=="BRA",Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),0)),3),2)
					nValPadrao := Round(NoRound(xMoeda(nValBx - nValImp,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3,If(cPaisLoc=="BRA",Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),0)),3),2)
				Else
					nValPadrao := Round(NoRound(xMoeda(nValBx - nValImp,nMoeda,SE2->E2_MOEDA,,3,Fa340TxMd(nMoeda,nTxMoeda),Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA)),3),2)
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posicionar novamente no titulo posicionado antes de pressionar o botao Compensar³
				//³e posicionar na natureza correspondente                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE2")
				nSalvRec := Recno()
				
				dbGoTo(nRecNo)
				DbSelectArea("SED")
				DbSetOrder(1)
				DbSeek(xFilial("SED")+SE2->E2_NATUREZ)  //Posicionar na natureza antes de contabilizar
				dbSelectArea("SE2")
				dbGoto(nSalvRec)
		
				If lPadrao .and. mv_par11 == 1
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA340",;
					                    cLote,;
					                    /*nLinha*/,;
					                    /*lExecuta*/,;
					                    /*cCriterio*/,;
					                    /*lRateio*/,;
					                    /*cChaveBusca*/,;
					                    /*aCT5*/,;
					                    /*lPosiciona*/,;
					                    @aFlagCTB,;
					                    /*aTabRecOri*/,;
					                    /*aDadosProva*/ )
				Endif

				dbSelectArea("SE2")
				dbGoTo(nRecNo)
				F340Semaforo(aTitulos[nTit],.F.,aRecno[nTit]) // LIBERA REGISTRO NO SEMAFORO
				
				//Envio de e-mail pela rotina de checklist de documentos obrigatorios
				If lFinVDoc
					FA340ValDocs(aTitulos[nTit],,.T.)
				EndIf            
			Else	
				If Len(aTitINSS) <= nTit .and. Len(aTitINSS) <> 0
					aTitINSS[nTit][8] := aTitulos[nTit][8]
				Endif					
			Endif
		Next
		If Len(aTitINSS) <> 0
			For nTit := 1 to Len(aTitINSS)
			
				IF aTitINSS[nTit,8]
					IF lPadrao .and. !lContabil .and. mv_par11 == 1
						nTotal := 0
						lContabil := .t.
						nHdlPrv := HeadProva( cLote,;
						                      "FINA340",;
						                      Substr( cUsuario, 7, 6 ),;
						                      @cArquivo )
					EndIf
					// Posiciona no PA/NDF				
					dbSelectArea("SE2")
					dbGoTo(aRecNoINSS[nTit])
					aAdd(aRegSE2, aRecNoINSS[nTit])
					cAdiantamento := E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
					cChave := "SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO"
							
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se Considera Fornecedor Original  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cAdiantamento += SE2->E2_FORNECE
					cChave +="+SE5->E5_CLIFOR"
					cAdiantamento += SE2->E2_LOJA
					cChave += "+SE5->E5_LOJA"
							
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Valor da baixa na moeda 1 							  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cPaisLoc == "BRA"
						nValBx 	:= aTitINSS[nTit,9]
						nAcresc := Fa340VTit(aTitINSS[nTit,10])
						nDecres := Fa340VTit(aTitINSS[nTit,11])
					Endif
							
					IF lPadrao
					   If cPaisLoc == "BRA"								
						  nValorComp += Round(NoRound(xMoeda(nValBx,nMoeda,1,,3,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
					   EndIf	   										  
					EndIf
							
					dbSelectArea("SE2")
					dbGoTo(nRecNoINSS)
					If lDebito .and. !FA340VerPA()                 
						Exit
					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Guardo dados do titulo principal para utilizar   ³
					//³ no historico da contabiliza‡Æo                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					STRLCTPAD	:= SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+;
								 SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
			
					CODFORCP 	:= SE2->E2_FORNECE
					LOJFORCP 	:= SE2->E2_LOJA
							
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Valor da Baixa na moeda do titulo principal 	  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cPaisLoc == "BRA"
						nValBx2 := aTitINSS[nTit,9]
						nAcresc := Fa340VTit(aTitINSS[nTit,10])
						nDecres := Fa340VTit(aTitINSS[nTit,11])
						
						//Tratamento PA Bruto
						If SE2->E2_SALDO < nValBx2
							nValBx  := SE2->E2_SALDO
							nValBx2 := SE2->E2_SALDO
						EndIf
					EndIf		
					
					If cPaisLoc == "BRA"
						nValorDec	+= Round(NoRound(xMoeda(nDecres,nMoeda,1,,3,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
						nValorAcre 	+= Round(NoRound(xMoeda(nAcresc,nMoeda,1,,3,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
					EndIf
			
					//Verifica se o valor do acrescimo e maior que o da baixa.
					If nAcresc > nValBx2                                
						nAcresc := nValBx2	
					Endif
					
					cSeqImp := SE5->E5_SEQ
					
					Fa340Grv(lPadrao,nValBx2,cAdiantamento,,aRecNoINSS[nTit],lDebito,mv_par11,Fa340TxMd(nMoeda,nTxMoeda),nAcresc,nDecres,aBaixaSE5,If(lPaBruto .and. lBaixaImp,If(lPA,nValImpPa,nValImp),0))
			
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona no adiantamento para contabiliza‡„o    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE2")
					dbGoTo(aRecNoINSS[nTit])
					DbSelectArea("SED")
					DbSetOrder(1)
					DbSeek(xFilial("SED")+SE2->E2_NATUREZ)
			
					// Nao somo abatimentos, se o titulo for de debito
					If !(SE2->E2_TIPO $ MV_CPNEG + "/" + MVPAGANT+"/INA")
						nTotAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
					Else
						nTotAbat := 0	
					Endif	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza saldo do PA/NDF                      	  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Reclock("SE2")
					If cPaisLoc == "BRA"				
						//Atualiza a data de vencimento dos titulos de impostos
						If lDebito
							AltVencImp(dDataBase)
						Endif
						// Se estiver baixando tudo, zera o saldo
						If nValBx == Fa340VTit(aTitINSS[nTit,5])
							SE2->E2_SALDO := 0
							SE2->E2_SDACRES := 0
							SE2->E2_SDDECRE := 0						
						Else   
							SE2->E2_SALDO	-= Round(NoRound(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
							SE2->E2_SDACRES	-= Round(Noround(xMoeda(nAcresc,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
							SE2->E2_SDDECRE	-= Round(Noround(xMoeda(nDecres,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
						Endif   
						SE2->E2_VALLIQ:= Round(NoRound(xMoeda(nValBx,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
						SE2->E2_MOVIMEN:= dBaixa					
					EndIf   				
					SE2->E2_BAIXA := dDataBase				   				   
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona no registro de natureza		³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))
					// Efetua a baixa dos titulos de abatimento
					If !( E2_TIPO $ MVPAGANT+"/INA"+"/"+MV_CPNEG )
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Baixar titulos de abatimento se for baixa total				  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SE2")
						nSalvRec := Recno()
						If (E2_SALDO-nTotabat) <= 0
							dbSetOrder(1)
							dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA))
							cPrefixo := SE2->E2_PREFIXO
							cNum := SE2->E2_NUM
							cParcela := SE2->E2_PARCELA
							While !EOF() .And. E2_FILIAL==xFilial("SE2") .And. E2_PREFIXO=cPrefixo 		.And.;
												E2_NUM==cNum 			.And. E2_PARCELA==cParcela
							
								IF E2_FORNECE==cFornece	.And. E2_LOJA == cLoja
									IF E2_TIPO $ MVABATIM
										RecLock("SE2")
										Replace E2_SALDO	  With 0
										Replace E2_BAIXA	  With Iif(E2_BAIXA<=dBaixa,dBaixa,E2_BAIXA)
										Replace E2_LOTE	  With cLote
										Replace E2_MOVIMEN  With dBaixa
										Replace E2_PORTADO  With cBanco
										MsUnlock( )
									EndIF
								Endif
								dbSelectArea( "SE2" )
								dbSkip( )
							Enddo
						Endif
						dbGoto(nSalvRec)
								
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza campo de maior atraso no Cadastro de Fornecedores		³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nAtraso:=dBaixa-SE2->E2_VENCTO
						If nAtraso > 1
							IF Dow(SE2->E2_VENCTO) == 1 .Or. Dow(SE2->E2_VENCTO) == 7
								IF Dow(dBaixa) == 2 .and. nAtraso <= 2
									nAtraso := 0
								EndIF
							EndIF
							nAtraso:=IIF(nAtraso<0,0,nAtraso)
							If SA2->A2_MATR < nAtraso
								dbSelectArea( "SA2" )
								dbSetOrder( 1 )
								If SA2->( MsSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA ) )
									RecLock( "SA2" )
									Replace A2_MATR With nAtraso
									MsUnlock()
								EndIf
							Endif
						Endif
					Endif
					MsUnlock()
			
					//Atualiza dados do fornecedor
					If SE2->E2_MOEDA > 1
						nValPadrao := Round(NoRound(xMoeda(nValBx - nValImp,nMoeda,SE2->E2_MOEDA,,3,,If(cPaisLoc=="BRA",Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),0)),3),2)
						nValPadrao := Round(NoRound(xMoeda(nValBx - nValImp,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3,If(cPaisLoc=="BRA",Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),0)),3),2)
					Else
						nValPadrao := Round(NoRound(xMoeda(nValBx - nValImp,nMoeda,SE2->E2_MOEDA,,3,Fa340TxMd(nMoeda,nTxMoeda),Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA)),3),2)
					Endif
			
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posicionar novamente no titulo posicionado antes de pressionar o botao Compensar³
					//³e posicionar na natureza correspondente                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE2")
					nSalvRec := Recno()
					
					dbGoTo(nRecNo)
					DbSelectArea("SED")
					DbSetOrder(1)
					DbSeek(xFilial("SED")+SE2->E2_NATUREZ)  //Posicionar na natureza antes de contabilizar
					dbSelectArea("SE2")
					dbGoto(nSalvRec)
					
					If lPadrao .and. mv_par11 == 1
						nTotal += DetProva( nHdlPrv,;
						                    cPadrao,;
						                    "FINA340",;
						                    cLote,;
						                    /*nLinha*/,;
						                    /*lExecuta*/,;
						                    /*cCriterio*/,;
						                    /*lRateio*/,;
						                    /*cChaveBusca*/,;
						                    /*aCT5*/,;
						                    /*lPosiciona*/,;
						                    @aFlagCTB,;
						                    /*aTabRecOri*/,;
						                    /*aDadosProva*/ )
					Endif
			
					dbSelectArea("SE2")
					dbGoTo(nRecNo)
					F340Semaforo(aTitINSS[nTit],.F.,aRecNoINSS[nTit]) // LIBERA REGISTRO NO SEMAFORO
							
				Endif
			Next

		EndIf
		nRegSE5 := SE5->(Recno())
		nRegSE2 := SE2->(Recno())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posicionar novamente no titulo posicionado antes de pressionar o botao Compensar³
		//³e posicionar na natureza correspondente                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE2")
		dbGoTo(nRecNo)
		DbSelectArea("SED")
		DbSetOrder(1)
		DbSeek(xFilial("SED")+SE2->E2_NATUREZ)  //Posicionar na natureza antes de contabilizar
		dbSelectArea("SE2")
		
		If nValorComp > 0 .And. lPadrao .And. mv_par11 == 1
			SE5->(dbGoBottom())
			SE5->(dbSkip())
			SE2->(dbGoBottom())
			SE2->(dbSkip())
			VALOR    := nValorComp
			VALOR2	 := nValorAcre			
			VALOR3 	 := nValorDec
			VALOR4	 := nValCorCM
			
			VLRINSTR := nValorComp
			nSldReal := Round(NoRound(xMoeda(nSaldo,nMoeda,1,,3,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,nTxMoeda),0)),3),2)
			ABATIMENTO := IIF(STR(nSldReal,17,2) == STR(nValorComp,17,2),nTotAbat,0)
			REGVALOR := nRecNo    // usado para a contabiliza‡„o
			nTotal += DetProva( nHdlPrv,;
			                    cPadrao,;
			                    "FINA340",;
			                    cLote,;
			                    0,;
			                    .F.,;
			                    "FINA340",;
			                    /*lRateio*/,;
			                    /*cChaveBusca*/,;
			                    /*aCT5*/,;
			                    /*lPosiciona*/,;
			                    @aFlagCTB,;
			                    /*aTabRecOri*/,;
			                    /*aDadosProva*/ )
	
			For nX := 1 To Len(aBaixaSE5)
				If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() ) 
					AAdd(aDiario,{"SE5",aBaixaSE5[nX],cCodDiario,"E5_NODIA","E5_DIACTB"})
				EndIf	                
			Next nX

			RodaProva(  nHdlPrv,;
						nTotal)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lan‡amento Cont bil							  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cA100Incl( @cArquivo,;
			           nHdlPrv,;
			           3,;
			           cLote,;
			           lDigita,;
			           lAglutina,;
			           /*cOnLine*/,;
			           /*dData*/,;
			           /*dReproc*/,;
			           @aFlagCTB,;
			           /*aDadosProva*/,;
			           aDiario )
			aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

		EndIf

		If lBxImpAut .and. !lPCCBaixa
			Fa340BTxAu(aTitulos, nRecno, cSeqImp)
		Endif

		SE5->(dbGoTo(nRegSE5))
		SE2->(dbGoTo(nRegSE2))

		//integracao com modulo PCO
		Fa340IntPco(nRecno, aRegSE2, aClone(aBaixaSE5))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Final  da protecao via TTS							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		End Transaction
		
		//Envio de e-mail pela rotina de checklist de documentos obrigatorios
		IF AliasIndic("FRD") .AND. (SE2->(FieldPos("E2_TEMDOCS")) > 0) .And. FindFunction("CN062ValDocs") .And. lFinVDoc
			CN062ValDocs("07",.F.,.T.)
		EndIf
	Endif
	Exit
Enddo

cPrefixo := CriaVar("E2_PREFIXO")
cNum		:= CriaVar("E2_NUM")
cTipoTit := CriaVar("E2_TIPO")
cFornece := CriaVar("E2_FORNECE")
cLoja 	:= CriaVar("E2_LOJA")
cSaldo	:= CriaVar("E2_SALDO")
nValor	:= CriaVar("E2_SALDO")
cParcela := CriaVar("E2_PARCELA")
nMoeda	:= 1
nValor	:= 0
nValTot	:= 0
VALOR4 	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoFinLan("000017")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbSetOrder(nOrdem)
dbGoto(nTitIni)
DeleteObject(oOk)
DeleteObject(oNo)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada no final da atualização dos titulos		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("F340GRV")
	Execblock("F340GRV",.F.,.F.,{nOpcA})
Endif
                                           
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura o filtro, para que o usuario que utilizar filtro atraves do   ³ 
//³ PE FA340BROW nao perca este filtro.                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Filter to &cSetFilter.

UnLockCmpCP( cChvSE2 )

Return (.T.)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FA340For ³ Autor ³ Mauricio Pequim Jr 	  ³ Data ³ 05/01/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica validade do Fornecedor									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa340For()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA340																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fa340For( cFornecedor, cLoja )
Local cAlias:=Alias()
Local lRet := .T.
Local nRecSe2
Local nOrdSe2

If Empty(cFornecedor)
	lRet := .F.
Else
	cAlias:=Alias()
	dbSelectArea("SA2")
	dbSetOrder(1)
	cLoja:=Iif(cLoja == Nil .or. (Empty(cLoja) .and. Empty(SE2->E2_LOJA)),"",cLoja)
	If !(dbSeek(xFilial("SA2")+cFornecedor+cLoja))
		lRet := .f.
	Else 
		dbSelectArea("SE2")
		nOrdSe2 := IndexOrd()
		nRecSe2 := Recno()
		dbSetOrder(1)
		If !MsSeek(xFilial("SE2")+cPrefixo+cNum+cParcela+cTipoTit+cFornecedor+cLoja)
			Help(" ",1,"NOTIT")
			lRet := .F.
		Endif
		dbSetOrder(nOrdSe2)
		DbGoto(nRecSe2)
	EndIf
Endif	
dbSelectArea(cAlias)
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA340Desc³ Autor ³ Wagner Xavier 		  ³ Data ³ 01/09/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cancelar a Compensa‡„o de Adiantamentos.						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FA340Desc() 						  									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340				                          					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FA340Desc( cAlias, nReg, nOpc )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nOpcA 	 := 0
Local lCancelou := .F.
Local cNatureza
Local aRegistros:= {}
Local aRegINSS:= {}
Local cChaveSE2
LOCAL cArquivo,nTotal:=0,lPadrao,cPadrao:="589"
LOCAL nRecSe2,nRecSe5
Local lFirst		:= .F.
Local nValorBaix:=0, nValBaix2:=0, nValINSS2:=0
Local nTotAbat    := 0
Local cDocumento
Local cCondic
Local lAglutina:= Iif(mv_par08==1,.t.,.f.)
Local lDigita  := iif(mv_par09==1,.T.,.F.)
Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )
Local cVarQ := "  "
Local oTitulo
LOCAL oDlg
Local lF340Can 	:= ExistBlock("F340CAN")
Local lF340ACan := ExistBlock("F340ACAN")
Local lF340FCan := ExistBlock("F340FCAN")
Local nDecs       := 2
Local nTxMoeda    := 0
Local nDecs1      := MsDecimais(1)
Local nLiq        := 0
Local lAchou
Local cFornAdt
Local	nLen
Local cChaveAdt
Local nLaco := 0 
Local nAcresc := 0		//Acrescimo do titulo de adiantamento
Local nDecres := 0		//Decrescimo do titulo de adiantamento
Local nTitAcres := 0		//Acrescimo do titulo principal
Local nTitDecre := 0		//Decrescimo do titulo principal
Local nINSAcres := 0		//Acrescimo do titulo principal de INSS
Local nINSDecre := 0		//Decrescimo do titulo principal de INSS
local nSE2Rec := 0
Local aSE5 := {}
Local nX := 0
Local	nValSaldo	:=	0
#IFDEF TOP
	Local nSE5  		:= 0
	Local cQuery	  	:= ""
	Local aStruSE5	  	:= {}
	Local lFa340Qry	:= Existblock("FA340QRY")
	Local cQueryADD	
#ENDIF
Local nValImp     := 0
Local aImp10925   := {}
// Controla retencao de impostos da lei 10925.
Local lContrRet   := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

Local lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 

Local aSize	:= {}
Local oPanel
Local lPaBruto		:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor
Local lNDF        := .F. //Identifica se o titulo tem NDF
Local aRecPa      := {}
Local nRecNDF
Local aDiario := {}
Local lVldDtFin := .T.
Local lAchouCli	:= .F.
Local aAreaAnt
Local cChaveE2Adt := ""
Local cChaveE5Adt := ""
Local aAreaE5Adt
Local aAreaE2Adt
Local cChvSemaf	:=	SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
Local lF340GREST := ExistBlock("F340GREST")
Local	nProp			:=	nPisProp	:= nCofProp := nCslProp	:=	nBasePis	:=	0        
Local lPropPA 		:= SuperGetMv("MV_COMPCP",,.F.) //Verifica se vai proporcionalizar quando PA>NF e PA liquido. 
Local lValPgto := SuperGetMv("MV_BP10925",.T.,"1") == "2" //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos 
//Variavel indica se irá provisionar os impostos de INSS e ISS na inclusão da PA, deduzindo-os do valor de adiantamento.
Local lPrImPA := !Empty( SE2->( FieldPos( "E2_PRINSS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRISS" ) ) ) .And. ;
				 !lPaBruto .And. SuperGetMv("MV_PAPRIME",.T.,"2") == "1"     
Local cPret	  := ""

//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa 	:= SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Local lAltPa		:=	.F.
Local nImp			:=	0            
Local nVPis			:=	0            
Local nVCof			:=	0            
Local nVCsl			:=	0            
Local nVIrf			:=	0            
Local nVIss			:=	0            
Local nRegTit		:=	0
Local lBxINSSAut 	:= GetNewPar("MV_BXINSAU","2")=="1" 
Local lBxImpAut 	:= GetNewPar("MV_CPIMPAT",2)==1 
Local cSeqEstorno	:= ""
Local aKeysTx := {}
Local lNaoSelec 	:= .F.
Local cFilCred      := ""
Local aDadosX		:= {}
Local bWhile     
Local nFilAt 

//--- Tratamento Gestao Corporativa
Local lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
//
Local cFilFwSE2 := IIF( lGestao .And. FindFunction("FwFilial"), FwFilial("SE2") , xFilial("SE2") )
Local cFilFwSE5 := IIF( lGestao .And. FindFunction("FwFilial"), FwFilial("SE5") , xFilial("SE5") )

PRIVATE 	nMoeda	:= SE2->E2_MOEDA
PRIVATE	aTitulos :={}
PRIVATE	aTitINSS :={}
PRIVATE	cPrefixo := SE2->E2_PREFIXO
PRIVATE	cNum		:= SE2->E2_NUM
PRIVATE	cTipoTit := SE2->E2_TIPO
PRIVATE	cFornece := SE2->E2_FORNECE
PRIVATE	cLoja 	:= SE2->E2_LOJA
PRIVATE	cParcela := SE2->E2_PARCELA
PRIVATE lDebito := .F.
PRIVATE	cTipodoc := " "
PRIVATE cTipodc:=" "
PRIVATE nHdlPrv  := 0
PRIVATE aFlagCTB	:= {}
PRIVATE lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)

If !LockCmpCP( cChvSemaf )
	Return
Endif

nRegSE2 := SE2->( Recno() )

If cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT+"/"+"INA"
	lDebito:=.T.   
	cTipodoc := "BA"
	cTipodc	 := "CP"
Else
	cTipodoc := "CP"
	cTipodc	 := "BA"
Endif              

If SE2->E2_TIPO $ MVABATIM
	Help(" ",1,"FA030INVAL")
	Return .T.
Endif

If ExistBlock("F340DTFIN")
	lVldDtFin := ExecBlock("F340DTFIN",.F.,.F.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVldDtFin .and. !DtMovFin()
	Return
Endif	

While .T.
	aTitulos   := {}
	aRegistros := {}

	If lF340aCan .And. !ExecBlock("F340ACAN",.f.,.f.)
		Return
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoIniLan("000017")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulo a ser compensado          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aSize := MSADVSIZE()
	If lPanelFin  //Chamado pelo Painel Financeiro
		dbSelectArea(cAlias)
		oPanelDados := FinWindow:GetVisPanel()
		oPanelDados:FreeChildren()
		aDim := DLGinPANEL(oPanelDados)
		DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³
		//³ -------------------------------------------------------------- ³
		//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
		//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
		//³ tracao e redivisao por 2 para a centralizacao. 					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 225) /2
		nEspLin  := 20
		
	Else
		nEspLarg := 0
		nEspLin  := 2
		DEFINE MSDIALOG oDlg FROM	88,31 TO 187,535 TITLE OemToAnsi(STR0005) PIXEL  //"Compensa‡„o de Titulos a Pagar"
	Endif

	
	oDlg:lMaximized := .F.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT    		
	
	@ 00+nEspLin, 003+nEspLarg TO 29+nEspLin, 252+nEspLarg OF oPanel  PIXEL		

	@ 14+nEspLin, 006+nEspLarg MSGET cPrefixo                           SIZE 19, 10 OF oPanel PIXEL
	@ 14+nEspLin, 032+nEspLarg MSGET cNum     Valid !Empty(cNum)        SIZE 70, 10 OF oPanel PIXEL
	@ 14+nEspLin, 105+nEspLarg MSGET cParcela                           SIZE 20, 10 OF oPanel PIXEL
	@ 14+nEspLin, 129+nEspLarg MSGET cTipoTit Picture "@!"  Valid  !Empty(cTipoTit) .and.;
		!cTipoTit $ MVABATIM										SIZE 16, 10 OF oPanel PIXEL
	@ 14+nEspLin, 155+nEspLarg MSGET cFornece Valid fa340FOR(cFornece)  SIZE 67, 10 OF oPanel PIXEL
	@ 14+nEspLin, 225+nEspLarg MSGET cLoja Valid Fa340For(cFornece,cLoja)        SIZE 16, 10 OF oPanel PIXEL

	@ 06+nEspLin, 006+nEspLarg SAY OemToAnsi(STR0006)    SIZE 21, 7 OF oPanel PIXEL  //"Prefixo"
	@ 06+nEspLin, 032+nEspLarg SAY OemToAnsi(STR0007)    SIZE 22, 7 OF oPanel PIXEL  //"N£mero"
	@ 05+nEspLin, 105+nEspLarg SAY OemToAnsi(STR0008)    SIZE 23, 7 OF oPanel PIXEL  //"Parcela"
	@ 05+nEspLin, 129+nEspLarg SAY OemToAnsi(STR0009)    SIZE 14, 7 OF oPanel PIXEL  //"Tipo"
	@ 05+nEspLin, 155+nEspLarg SAY OemToAnsi(STR0010)    SIZE 34, 7 OF oPanel PIXEL  //"Fornecedor"
	@ 05+nEspLin, 225+nEspLarg SAY OemToAnsi(STR0011)    SIZE 14, 7 OF oPanel PIXEL  //"Loja"
  
	If lPanelFin  //Chamado pelo Painel Financeiro
		oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])
		ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
		{||nOpca:=1,oDLg:End()},;
		{||oDlg:End()})
		
		FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)
		
	Else
		DEFINE SBUTTON FROM 34, 188 TYPE 1 ENABLE ACTION (nOpca:=1,oDLg:End()) OF oDlg
		DEFINE SBUTTON FROM 34, 216 TYPE 2 ENABLE ACTION oDlg:End() OF oDlg
		ACTIVATE MSDIALOG oDlg CENTERED
	Endif	


	If nOpca==0
		UnLockCmpCP(cChvSemaf)
		Return
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo existe. 	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(6)
	dbSeek(cFilial+cFornece+cLoja+cPrefixo+cNum+cParcela+cTipoTit)
	If !Found()
		Help(" ",1,"NOTIT")
		dbSetOrder(1)
		DbGoto(nReg)
		UnLockCmpCP(cChvSemaf)
		Return
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo j  foi compensado.	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SE2->E2_SALDO == SE2->E2_VALOR ) .and. ;
		(SE2->E2_ACRESC == SE2->E2_SDACRES) .and. ;
		(SE2->E2_DECRESC == SE2->E2_SDDECRE)		

		Help(" ",1,"A330NAOCOMP")
		dbSetOrder(1)
		DbGoto(nReg)
		UnLockCmpCP(cChvSemaf)
		Return
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo tem NDF baixada - PABruto ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lPaBruto .and. !lDebito .and. Fa340VerNDF(@lNDF)
		MsgAlert(STR0044)
		dbSetOrder(1)
		DbGoto(nReg)
		UnLockCmpCP(cChvSemaf)
		Return		
	EndIf

	//ANGOLA - Nao permitir compensar titulos de adiantamento relacionados a pedido				      
	#IFDEF TOP
		If cPaisLoc == "ANG" .and. AliasInDic("FIE")
			FIE->(dbSetOrder(3))
			If FIE->(MsSeek(xFilial("FIE")+"P"+SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)))
				Help(" ",1,"NOCANCMP",,STR0048,1,0)  //"Compensação realizada através do relacionamento Adiantamento x Pedido somente poderá ser cancelada com o cancelamento do documento fiscal"
				dbSetOrder(1)
				DbGoto(nReg)
				UnLockCmpCP(cChvSemaf)
				Return
				
			Endif 
		Endif
	#ENDIF	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Guardo dados do titulo principal para utilizar   ³
	//³ no historico da contabiliza‡Æo                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	STRLCTPAD := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
	CODFORCP := SE2->E2_FORNECE
	LOJFORCP := SE2->E2_LOJA

	cNatureza 	:= SE2->E2_NATUREZA
	nMoeda		:= SE2->E2_MOEDA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura adiantamentos do titulo original.			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTitulos := {}

	#IFDEF	TOP
	
		If TcSrvType() != "AS/400"

			cQuery := "SELECT SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, "
			cQuery += "SE5.E5_TIPO, SE5.E5_DATA, SE5.E5_CLIFOR, SE5.E5_LOJA, SE5.E5_SEQ, "
			cQuery += "SE5.E5_DOCUMEN, SE5.E5_FILORIG, SE5.E5_VLMOED2, SE5.E5_FORNADT, SE5.E5_LOJAADT, SE5.R_E_C_N_O_ E5_RECNO, "
			cQuery += "SE2.E2_VALOR, SE2.E2_FORNECE, SE2.E2_LOJA "
			cQuery += "FROM "+RetSqlName("SE5") + " SE5, "
			cQuery += RetSqlName("SE2") + " SE2 "			
			cQuery += "WHERE "
			If !eMPTY( cFilFwSE5 )
				cQuery += "SE5.E5_FILORIG = '"+xFilial("SE5")+"' AND "
			Else
				cQuery += "SE5.E5_FILIAL = '"+xFilial("SE5")+"' AND "
			Endif
			cQuery += "SE2.E2_FILIAL = '"+xFilial("SE2")+"' AND "
			cQuery += "SE5.E5_PREFIXO = SE2.E2_PREFIXO AND "
			cQuery += "SE5.E5_NUMERO = SE2.E2_NUM AND "
			cQuery += "SE5.E5_PARCELA = SE2.E2_PARCELA AND "
			cQuery += "SE5.E5_TIPO = SE2.E2_TIPO AND "
			
			If mv_par02==1 
				cQuery += "SE5.E5_CLIFOR = SE2.E2_FORNECE AND "
			EndIf	 
			If (mv_par01==1 .and. mv_par02==1)
				cQuery += "SE5.E5_LOJA = SE2.E2_LOJA AND "
     		Endif
			cQuery += "(SE5.E5_TIPODOC = '"+cTipoDoc+"' OR "
			cQuery += "SE5.E5_TIPODOC = '"+cTipodc+"') AND "
			cQuery += "SE5.E5_MOTBX = 'CMP' AND "
			cQuery += "SE5.E5_RECPAG = 'P' AND "			
			cQuery += "SE5.E5_PREFIXO ='"+cPrefixo+"' AND "
			cQuery += "SE5.E5_NUMERO ='"+cNum+"' AND "	
			cQuery += "SE5.E5_PARCELA ='"+cParcela+"' AND "
			cQuery += "SE5.E5_TIPO = '"+cTipoTit+"' AND "
			cQuery += "SE5.E5_CLIFOR = '"+cFornece+"' AND "
			cQuery += "SE5.E5_LOJA = '"+cLoja+"' AND "
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada	na selecao do SE5³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF lFa340Qry
				cQueryADD := ExecBlock("FA340QRY",.F.,.F.)
				IF ValType(cQueryADD) == "C"
					cQuery += " (" + cQueryADD + ")  AND "
				ENDIF
			ENDIF             
			
			cQuery += "SE5.D_E_L_E_T_ = ' ' AND "
			cQuery += "SE2.D_E_L_E_T_ = ' ' "			
			cQuery += "ORDER BY "
			cQuery += "SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, "
			cQuery += "SE5.E5_TIPO, SE5.E5_DATA, SE5.E5_SEQ"
			
			cQuery := ChangeQuery(cQuery)
						
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)		
		
			aStruSE5:= SE5->(dbStruct())

			For nSE5 := 1 To Len(aStruSE5)
				If aStruSE5[nSE5][2] <> "C" .and.  FieldPos(aStruSE5[nSE5][1]) > 0
					TcSetField("TRB",aStruSE5[nSE5][1],aStruSE5[nSE5][2],aStruSE5[nSE5][3],aStruSE5[nSE5][4])
				EndIf
			Next nSE5	
		
			While TRB->(!EOF())
				// Verifica o fornecedor do Adto. apenas se estiver posicionado do
				// titulo de PA ao fazer a exclusao.
				If cTipoTit $ MVPAGANT+"/INA" .And.;
					SE5->(FieldPos("E5_FORNADT")) > 0 .And.;
					TRB->(E5_FORNADT+E5_LOJAADT)	!= SE2->(E2_FORNECE+E2_LOJA) .And.;
					TRB->(E5_CLIFOR+E5_LOJA) 		!= SE2->(E2_FORNECE+E2_LOJA)
					TRB->(DbSkip())
					Loop
				Endif
					
				//Verifica se a data base do sistema eh menor que a data de compensacao dos titulos
				If DTOS(dDataBase) < DTOS(TRB->E5_DATA) 
					TRB->(DbSkip())
  					Loop
	 			EndIf														
				
				//Verifica se tem baixa cancelada
				If TemBxCanc(TRB->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) , .T. , TRB->E5_FILIAL )
					TRB->( dbskip())
					loop
				EndIf

				If cPaisLoc $ "BRA|MEX" .and. AliasInDic("FR3") .and. AliasInDic("FIE")
					// se estorno da compensacao nao estah partindo do titulo de debito
					If !lDebito
						If SE2->E2_ORIGEM = "MATA100" .and. SE2->E2_TIPO = MVNOTAFIS
							// checa se condicao de pagamento eh relacionado com adiantamento
							If FaNfsRAdt(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_EMISSAO)
								// checa se eh a primeira baixa para o titulo principal, pois a primeira baixa eh realizada no momento da geracao do documento de entrada, quando hah adiantamento relacionado ao documento.
								If FaBxEmisDoc(TRB->E5_FILIAL,TRB->E5_PREFIXO,TRB->E5_NUMERO,TRB->E5_PARCELA,TRB->E5_CLIFOR,TRB->E5_LOJA,TRB->E5_TIPO,TRB->E5_DATA,TRB->E5_SEQ,"P",TRB->E5_DOCUMEN)
									dbSelectArea("TRB")
									dbSkip()
									Loop
								Endif
							Endif
						Endif       
					// se estorno da compensacao estah partindo do titulo de credito
					Else	
						// posiciona no titulo principal e na baixa principal para checar se eh adiantamento e se esta baixa foi gerada no momento da emissao do documento de saida.
						aAreaAnt := GetArea()
						aAreaE5Adt := SE5->(GetArea())
						cChaveE5Adt := TRB->E5_FILIAL+cTipoDc+Subs(TRB->E5_DOCUMEN,1,nTamTit+nTamTip)+dTos(TRB->E5_DATA)+TRB->(E5_CLIFOR+E5_LOJA+E5_SEQ)
						aAreaE2Adt := SE2->(GetArea())					
						cChaveE2Adt := TRB->E5_FILIAL+TRB->(E5_CLIFOR+E5_LOJA)+Subs(TRB->E5_DOCUMEN,1,nTamTit+nTamTip)
						// posiciona no titulo principal
						SE2->(dbSetOrder(6))
						If SE2->(dbSeek(cChaveE2Adt))
							// posiciona na baixa principal					
							SE5->(dbSetOrder(2))
							If SE5->(dbSeek(cChaveE5Adt))
								If SE2->E2_ORIGEM = "MATA100" .and. SE2->E2_TIPO = MVNOTAFIS
									// checa se condicao de pagamento eh relacionado com adiantamento
									If FaNfsRAdt(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_EMISSAO)
										// checa se eh a primeira baixa para o titulo principal, pois a primeira baixa eh realizada no momento da geracao do documento de saida, quando hah adiantamento relacionado ao documento.
										If FaBxEmisDoc(SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_TIPO,SE5->E5_DATA,SE5->E5_SEQ,"P",SE5->E5_DOCUMEN)
											RestArea(aAreaE2Adt)
											RestArea(aAreaE5Adt)
											RestArea(aAreaAnt)
											dbSelectArea("TRB")
											dbSkip()
											Loop
										Endif
									Endif
								Endif       
							Endif	
						Endif	
						RestArea(aAreaE2Adt)
						RestArea(aAreaE5Adt)
						RestArea(aAreaAnt)
						dbSelectArea("TRB")
					Endif
				Endif		

				If TRB->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E2_FORNECE+E2_LOJA) == ;
					SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
					Aadd( aTitulos,{TRB->E5_PREFIXO, TRB->E5_NUMERO    , TRB->E5_PARCELA,;
						  TRB->E5_TIPO   , DtoC(TRB->E5_DATA),;
						  SubStr(TRB->E5_DOCUMEN,1,nTamTit+nTamTip),;
						  TRB->E5_SEQ, Transform(TRB->E2_VALOR,"@E 9999,999,999.99"),;
			           Transform(TRB->E5_VLMOED2,"@E 9999,999,999.99"),Iif(DtMovFin(TRB->E5_DATA,.F.),.T.,.F.)})
					
					AADD( aRegistros, TRB->E5_RECNO)
						
					If !Empty(TRB->E5_FILORIG) .and. !Empty( cFilFwSE2 )
						cChaveSe2 := TRB->E5_FILORIG+SubStr( TRB->E5_DOCUMEN ,1,nTamTit+nTamTip )+TRB->(E5_FORNADT+E5_LOJAADT)
					Else
						cChaveSe2 := xFilial("SE2")+SubStr( TRB->E5_DOCUMEN ,1,nTamTit+nTamTip )+TRB->(E5_FORNADT+E5_LOJAADT)
					Endif					
				
					If !(F340Semaforo({},.T.,aRegistros[Len(aRegistros)], cChaveSe2,{},.F.)) // se conseguirmos travar o registro do SE2	
							aTitulos[Len(aTitulos)] := .F.
					Endif
					
				Endif	
				TRB->(DbSkip())
			EndDo			
      Else
	#ENDIF 
			dbSelectArea("SE5")
			dbSetOrder(2)
			dbSeek( xFilial("SE5")+cTipoDoc )
			While !Eof() .and. cFilial == SE5->E5_FILIAL .and. SE5->E5_TIPODOC == cTipoDoc
	
				If SE5->E5_MOTBX != "CMP" .or. E5_RECPAG != "P"
					dbSkip( )
					Loop
				Endif

				//Verifica se tem baixa cancelada
				If TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
					SE5->( dbskip())
					loop
				EndIf             
				
				//Verifica se a data base do sistema eh menor que a data de compensacao dos titulos
				If DTOS(dDataBase) < DTOS(SE5->E5_DATA) 
					dbSkip()
  					Loop
	 			EndIf	
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica Fornecedor se considerar Fornecedor Original   ³
				//³ na selecao de titulos 									³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (mv_par02 == 1 .Or. !(cTipoTit $ MVPAGANT+"/INA")) .and.  SE5->E5_CLIFOR != SE2->E2_FORNECE
					dbSkip( )
					Loop
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica loja caso considere loja na selecao de titulos	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ((mv_par01 == 1 .and. mv_par02 == 1) .Or. !(cTipoTit $ MVPAGANT+"/INA")) .and.  SE5->E5_LOJA != SE2->E2_LOJA
					dbSkip( )
					Loop
				EndIf
				// Verifica o fornecedor do Adto. apenas se estiver posicionado do
				// titulo de PA ao fazer a exclusao.
				If cTipoTit $ MVPAGANT+"/INA" .And.;
					SE5->(E5_FORNADT+E5_LOJAADT)	!= SE2->(E2_FORNECE+E2_LOJA) .And.;
					SE5->(E5_CLIFOR+E5_LOJA) 		!= SE2->(E2_FORNECE+E2_LOJA)
					dbSkip( )
					Loop
				Endif
	
				If SE5->E5_PREFIXO # cPrefixo .Or. SE5->E5_NUMERO # cNum .Or. ;
					SE5->E5_PARCELA # cParcela .Or. SE5->E5_TIPO # cTipoTit
					dbSkip()
					Loop
				Endif
				Aadd( aTitulos,{SE5->E5_PREFIXO, SE5->E5_NUMERO    , SE5->E5_PARCELA,;
				SE5->E5_TIPO   , DtoC(SE5->E5_DATA),;
				SubStr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip),;
                SE5->E5_SEQ, Transform(SE2->E2_VALOR,"@E 9999,999,999.99"),;
				Transform(SE5->E5_VLMOED2,"@E 9999,999,999.99"),Iif(DtMovFin(SE5->E5_DATA,.F.),.T.,.F.)})
				AADD( aRegistros, SE5->(Recno()))
				dbSelectArea( "SE5" )
				dbSkip()
			Enddo
	#IFDEF TOP
		Endif			
	#ENDIF

	If Len(aTitulos) == 0
		Help(" ",1,"NOTITSEL")
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				dbSelectArea( "TRB")
				dbCloseArea()
			Endif
		#ENDIF	
		dbSelectArea( "SE2" )
		dbSetOrder( 1 )
		dbSelectArea( "SE5" )
		dbSetOrder( 1 )
		dbGoTo( nReg )
		UnLockCmpCP(cChvSemaf)
		Return
	Endif

	If lBxINSSAut .and. MV_PAR10 == 1

		#IFDEF TOP
			If TcSrvType() != "AS/400"
				dbSelectArea( "TRB")
				dbCloseArea()
			Endif	
		#ENDIF

		If SE2->E2_INSS > 0
			dbSelectArea( "SE2" )
			dbSetOrder(1)
			If SE2->E2_TIPO $ MVPAGANT
				dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCINS+'INA'+GetMV("MV_FORINSS")+Space(Len(SE2->E2_FORNECE)-Len(GetMV("MV_FORINSS")))+PadR( "00", TamSX3("A2_LOJA")[1], "0" ) ))
			Else
				dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCINS+MVINSS+GetMV("MV_FORINSS")+Space(Len(SE2->E2_FORNECE)-Len(GetMV("MV_FORINSS")))+PadR( "00", TamSX3("A2_LOJA")[1], "0" ) ))
			EndIf			
			nRecnoINSS := Recno()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Procura adiantamentos do titulo original.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aTitINSS := {}
		
			#IFDEF	TOP
			
				If TcSrvType() != "AS/400"
		
					cQuery := "SELECT SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, "
					cQuery += "SE5.E5_TIPO, SE5.E5_DATA, SE5.E5_CLIFOR, SE5.E5_LOJA, SE5.E5_SEQ, "
					cQuery += "SE5.E5_DOCUMEN, SE5.E5_FILORIG, SE5.E5_VLMOED2, SE5.E5_FORNADT, SE5.E5_LOJAADT, SE5.R_E_C_N_O_ E5_RECNO, "
					cQuery += "SE2.E2_VALOR, SE2.E2_FORNECE, SE2.E2_LOJA "
					cQuery += "FROM "+RetSqlName("SE5") + " SE5, "
					cQuery += RetSqlName("SE2") + " SE2 "			
					cQuery += "WHERE "
					cQuery += "SE5.E5_FILIAL = '"+xFilial("SE5")+"' AND "
					cQuery += "SE2.E2_FILIAL = '"+xFilial("SE2")+"' AND "
					cQuery += "SE5.E5_PREFIXO = SE2.E2_PREFIXO AND "
					cQuery += "SE5.E5_NUMERO = SE2.E2_NUM AND "
					cQuery += "SE5.E5_PARCELA = SE2.E2_PARCELA AND "
					cQuery += "SE5.E5_TIPO = SE2.E2_TIPO AND "
					
					If mv_par02==1 
						cQuery += "SE5.E5_CLIFOR = SE2.E2_FORNECE AND "
					EndIf	 
					If (mv_par01==1 .and. mv_par02==1)
						cQuery += "SE5.E5_LOJA = SE2.E2_LOJA AND "
		     		Endif
					cQuery += "SE5.E5_TIPODOC = '"+cTipoDoc+"' AND "
					cQuery += "SE5.E5_MOTBX = 'CMP' AND "
					cQuery += "SE5.E5_RECPAG = 'P' AND "			
					cQuery += "SE5.E5_PREFIXO ='"+SE2->E2_PREFIXO+"' AND "
					cQuery += "SE5.E5_NUMERO ='"+SE2->E2_NUM+"' AND "	
					cQuery += "SE5.E5_PARCELA ='"+SE2->E2_PARCELA+"' AND "
					cQuery += "SE5.E5_TIPO = '"+SE2->E2_TIPO+"' AND "
					cQuery += "SE5.E5_CLIFOR = '"+SE2->E2_FORNECE+"' AND "
					cQuery += "SE5.E5_LOJA = '"+SE2->E2_LOJA+"' AND "
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de Entrada	na selecao do SE5³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF lFa340Qry
						cQueryADD := ExecBlock("FA340QRY",.F.,.F.)
						IF ValType(cQueryADD) == "C"
							cQuery += " (" + cQueryADD + ")  AND "
						ENDIF
					ENDIF             
					
					cQuery += "SE5.D_E_L_E_T_ = ' ' AND "
					cQuery += "SE2.D_E_L_E_T_ = ' ' "			
					cQuery += "ORDER BY "
					cQuery += "SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, "
					cQuery += "SE5.E5_TIPO, SE5.E5_DATA, SE5.E5_SEQ"
					
					cQuery := ChangeQuery(cQuery)
								
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)		
				
					aStruSE5:= SE5->(dbStruct())
		
					For nSE5 := 1 To Len(aStruSE5)
						If aStruSE5[nSE5][2] <> "C" .and.  FieldPos(aStruSE5[nSE5][1]) > 0
							TcSetField("TRB",aStruSE5[nSE5][1],aStruSE5[nSE5][2],aStruSE5[nSE5][3],aStruSE5[nSE5][4])
						EndIf
					Next nSE5	
				
					While TRB->(!EOF())
						// Verifica o fornecedor do Adto. apenas se estiver posicionado do
						// titulo de PA ao fazer a exclusao.
						If cTipoTit $ MVPAGANT+"/INA" .And.;
							SE5->(FieldPos("E5_FORNADT")) > 0 .And.;
							TRB->(E5_FORNADT+E5_LOJAADT)	!= SE2->(E2_FORNECE+E2_LOJA) .And.;
							TRB->(E5_CLIFOR+E5_LOJA) 		!= SE2->(E2_FORNECE+E2_LOJA)
							TRB->(DbSkip())
							Loop
						Endif
							
						//Verifica se a data base do sistema eh menor que a data de compensacao dos titulos
						If DTOS(dDataBase) < DTOS(TRB->E5_DATA) 
							TRB->(DbSkip())
		  					Loop
			 			EndIf														
						
						//Verifica se tem baixa cancelada
						If TemBxCanc(TRB->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.T.)
							TRB->( dbskip())
							loop
						EndIf
		
						If cPaisLoc $ "BRA|MEX" .and. AliasInDic("FR3") .and. AliasInDic("FIE")
							// se estorno da compensacao nao estah partindo do titulo de debito
							If !lDebito
								If SE2->E2_ORIGEM = "MATA100" .and. SE2->E2_TIPO = MVNOTAFIS
									// checa se condicao de pagamento eh relacionado com adiantamento
									If FaNfsRAdt(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_EMISSAO)
										// checa se eh a primeira baixa para o titulo principal, pois a primeira baixa eh realizada no momento da geracao do documento de entrada, quando hah adiantamento relacionado ao documento.
										If FaBxEmisDoc(TRB->E5_FILIAL,TRB->E5_PREFIXO,TRB->E5_NUMERO,TRB->E5_PARCELA,TRB->E5_CLIFOR,TRB->E5_LOJA,TRB->E5_TIPO,TRB->E5_DATA,TRB->E5_SEQ,"P",TRB->E5_DOCUMEN)
											dbSelectArea("TRB")
											dbSkip()
											Loop
										Endif
									Endif
								Endif       
							// se estorno da compensacao estah partindo do titulo de credito
							Else	
								// posiciona no titulo principal e na baixa principal para checar se eh adiantamento e se esta baixa foi gerada no momento da emissao do documento de saida.
								aAreaAnt := GetArea()
								aAreaE5Adt := SE5->(GetArea())
								cChaveE5Adt := TRB->E5_FILIAL+cTipoDc+Subs(TRB->E5_DOCUMEN,1,nTamTit+nTamTip)+dTos(TRB->E5_DATA)+TRB->(E5_CLIFOR+E5_LOJA+E5_SEQ)
								aAreaE2Adt := SE2->(GetArea())					
								cChaveE2Adt := TRB->E5_FILIAL+TRB->(E5_CLIFOR+E5_LOJA)+Subs(TRB->E5_DOCUMEN,1,nTamTit+nTamTip)
								// posiciona no titulo principal
								SE2->(dbSetOrder(6))
								If SE2->(dbSeek(cChaveE2Adt))
									// posiciona na baixa principal					
									SE5->(dbSetOrder(2))
									If SE5->(dbSeek(cChaveE5Adt))
										If SE2->E2_ORIGEM = "MATA100" .and. SE2->E2_TIPO = MVNOTAFIS
											// checa se condicao de pagamento eh relacionado com adiantamento
											If FaNfsRAdt(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_EMISSAO)
												// checa se eh a primeira baixa para o titulo principal, pois a primeira baixa eh realizada no momento da geracao do documento de saida, quando hah adiantamento relacionado ao documento.
												If FaBxEmisDoc(SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_TIPO,SE5->E5_DATA,SE5->E5_SEQ,"P",SE5->E5_DOCUMEN)
													RestArea(aAreaE2Adt)
													RestArea(aAreaE5Adt)
													RestArea(aAreaAnt)
													dbSelectArea("TRB")
													dbSkip()
													Loop
												Endif
											Endif
										Endif       
									Endif	
								Endif	
								RestArea(aAreaE2Adt)
								RestArea(aAreaE5Adt)
								RestArea(aAreaAnt)
								dbSelectArea("TRB")
							Endif
						Endif		
		
						If TRB->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E2_FORNECE+E2_LOJA) == ;
							SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
							Aadd( aTitINSS,{TRB->E5_PREFIXO, TRB->E5_NUMERO    , TRB->E5_PARCELA,;
								  TRB->E5_TIPO   , DtoC(TRB->E5_DATA),;
								  SubStr(TRB->E5_DOCUMEN,1,nTamTit+nTamTip),;
								  TRB->E5_SEQ, Transform(TRB->E2_VALOR,"@E 9999,999,999.99"),;
					           Transform(TRB->E5_VLMOED2,"@E 9999,999,999.99"),Iif(DtMovFin(TRB->E5_DATA,.F.),.T.,.F.)})
							
							AADD( aRegINSS, TRB->E5_RECNO)
								
							If !Empty(TRB->E5_FILORIG) .and. !Empty( cFilFwSE2 )
								cChaveSe2 := TRB->E5_FILORIG+SubStr( TRB->E5_DOCUMEN ,1,nTamTit+nTamTip )+TRB->(E5_FORNADT+E5_LOJAADT)
							Else
								cChaveSe2 := xFilial("SE2")+SubStr( TRB->E5_DOCUMEN ,1,nTamTit+nTamTip )+TRB->(E5_FORNADT+E5_LOJAADT)
							Endif					
						
							If !(F340Semaforo({},.T.,aRegINSS[Len(aRegINSS)], cChaveSe2,{},.F.)) // se conseguirmos travar o registro do SE2	
									aTitINSS[Len(aTitINSS)] := .F.
							Endif
							
						Endif	
						TRB->(DbSkip())
					EndDo			
		      Else
			#ENDIF 
					dbSelectArea("SE5")
					dbSetOrder(2)
					dbSeek( xFilial("SE5")+cTipoDoc )
					While !Eof() .and. cFilial == SE5->E5_FILIAL .and. SE5->E5_TIPODOC == cTipoDoc
			
						If SE5->E5_MOTBX != "CMP" .or. E5_RECPAG != "P"
							dbSkip( )
							Loop
						Endif
		
						//Verifica se tem baixa cancelada
						If TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
							SE5->( dbskip())
							loop
						EndIf             
						
						//Verifica se a data base do sistema eh menor que a data de compensacao dos titulos
						If DTOS(dDataBase) < DTOS(SE5->E5_DATA) 
							dbSkip()
		  					Loop
			 			EndIf	
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica Fornecedor se considerar Fornecedor Original   ³
						//³ na selecao de titulos 									³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (mv_par02 == 1 .Or. !(cTipoTit $ MVPAGANT+"/INA")) .and.  SE5->E5_CLIFOR != SE2->E2_FORNECE
							dbSkip( )
							Loop
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica loja caso considere loja na selecao de titulos	  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ((mv_par01 == 1 .and. mv_par02 == 1) .Or. !(cTipoTit $ MVPAGANT+"/INA")) .and.  SE5->E5_LOJA != SE2->E2_LOJA
							dbSkip( )
							Loop
						EndIf
						// Verifica o fornecedor do Adto. apenas se estiver posicionado do
						// titulo de PA ao fazer a exclusao.
						If cTipoTit $ MVPAGANT+"/INA" .And.;
							SE5->(E5_FORNADT+E5_LOJAADT)	!= SE2->(E2_FORNECE+E2_LOJA) .And.;
							SE5->(E5_CLIFOR+E5_LOJA) 		!= SE2->(E2_FORNECE+E2_LOJA)
							dbSkip( )
							Loop
						Endif
			
						If SE5->E5_PREFIXO # cPrefixo .Or. SE5->E5_NUMERO # cNum .Or. ;
							SE5->E5_PARCELA # cParcela .Or. SE5->E5_TIPO # cTipoTit
							dbSkip()
							Loop
						Endif
						Aadd( aTitINSS,{SE5->E5_PREFIXO, SE5->E5_NUMERO    , SE5->E5_PARCELA,;
						SE5->E5_TIPO   , DtoC(SE5->E5_DATA),;
						SubStr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip),;
						SE5->E5_SEQ, Transform(SE2->E2_VALOR,"@E 9999,999,999.99"),;
						Transform(SE5->E5_VLMOED2,"@E 9999,999,999.99"),Iif(DtMovFin(SE5->E5_DATA,.F.),.T.,.F.)})
						AADD( aRegINSS, SE5->(Recno()))
						dbSelectArea( "SE5" )
						dbSkip()
					Enddo
			#IFDEF TOP
				Endif			
			#ENDIF
		
			dbSelectArea( "SE2" )
			dbGoTo(nRegSE2)
		EndIf
	EndIf

	nOpca   := 0

	aSize := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlg TITLE STR0041 From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	oDLg:lMaximized := .T.

	@ 00.5,0 TO 5.4, 32.0 LABEL cCadastro OF oDlg
	@ 01.0,.5 LISTBOX oTitulo VAR cVarQ Fields;
		HEADER "", OemToAnsi(STR0006),;  //"Prefixo"
		OemToAnsi(STR0007),;  //"N£mero"
		OemToAnsi(STR0008),;  //"Parcela"
		OemToAnsi(STR0009),;  //"Tipo"
		OemToAnsi(STR0020),;  //"Data"
		OemToAnsi(STR0021),;  //"Documento"
		OemToAnsi(STR0022),;  //"Seq"
		OemToAnsi(STR0023),;  //"Valor do t¡tulo"
		OemToAnsi(STR0017) ;   //"Valor compensado"
		COLSIZES 12, GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBB"),;
		GetTextWidth(0,"BBBBBB"),GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBB"),GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBBBBBBBBB");
		SIZE 250,54.5 ON DBLCLICK (aTitulos := FA340marca(oTitulo:nAt,aTitulos,aRegistros,nOpc),oTitulo:Refresh()) NOSCROLL

	oTitulo:SetArray(aTitulos)
	oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,10],oOk,oNo),;
		aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
		aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
		aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
		aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,8],;
		aTitulos[oTitulo:nAt,9]}}

	oTitulo:Align := CONTROL_ALIGN_ALLCLIENT
	//---
	
	
	If lPanelFin  //Chamado pelo Painel Financeiro			
		ACTIVATE MSDIALOG oDlg ON INIT (oTitulo:Refresh(), FaMyBar(oDlg,;
	   	{|| nOpca := 1,oDlg:End()},;   					
			{|| nOpca := 0,oDlg:End()}))    
			 	
	Else
		oPanel := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,20,20,.T.,.T. )
		oPanel:Align := CONTROL_ALIGN_BOTTOM
		DEFINE SBUTTON FROM 4,325 TYPE 1 ACTION (nOpca := 1,oDlg:End())  ENABLE OF oPanel PIXEL
		DEFINE SBUTTON FROM 4,360 TYPE 2 ACTION (nOpca := 0,oDlg:End())  ENABLE OF oPanel PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oTitulo:Refresh())
	Endif

	If nOpca == 2   // somente no DOS - Redigita
		Loop
	ElseIf nOpcA == 0
		F340Semaforo(aTitulos,.F.,0,,aRegistros,.F.)
	Elseif nOpcA == 1

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa pto de entrada apos confirmacao           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lF340Can
			ExecBlock("F340CAN",.f.,.f.,aRegistros)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Volta o valor aos PAs/NDFs	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE5")
		dbSetOrder(2)
		nValorBaix := 0
		lPadrao := VerPadrao(cPadrao)

		If lPadrao
			lFirst := .T.
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio da prote‡„o via TTS							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Begin Transaction
		For nLaco := 1 to Len(aRegistros)
			cCondic := "(aTitulos["+STR(nLaco)+",10])"
			If &cCondic
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ So monta o cabecalho do LP se acha pelo menos um³
				//³ registro marcado 										 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFirst
					nHdlPrv := HeadProva( cLote,;
					                      "FINA340",;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )

					VALOR 	:= 0
					VLRINSTR := 0
					lFirst:= .F.
				Endif
				dbSelectArea("SE5")
				dbGoTo(aRegistros[nLaco])
				cDocumento := Substr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)+;
					IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
					IIf(mv_par01==1 .and. mv_par02==1,SE5->E5_LOJA,"")

				cSeq		  := SE5->E5_SEQ
				cChaveAdt  := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)

				//Acrescimos e Decrescimos do titulo principal
				If SE5->E5_VLJUROS > 0
					nTitAcres	+= Round(NoRound(xMoeda(SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,3,,IIF(SE5->E5_TXMOEDA>0,SE5->E5_TXMOEDA,Fa340TxMd(nMoeda,nTxMoeda))),3),2)
				Endif
				If SE5->E5_VLDESCO > 0
					nTitDecre	+= Round(NoRound(xMoeda(SE5->E5_VLDESCO,1,nMoeda,SE5->E5_DATA,3,,IIF(SE5->E5_TXMOEDA>0,SE5->E5_TXMOEDA,Fa340TxMd(nMoeda,nTxMoeda))),3),2)
				Endif
                
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Localiza o t¡tulo PA/NDF correspondente … baixa ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa a chave de pesquisa com  ³
				//³ a filial padrÆo. Caso seja utilizada³
				//³ compensa‡Æo em outras filiais, ir   ³
				//³ utilizar-se do campo E5_FILORIG.    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cChaveSe2 := xFilial("SE2")+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+;
					If(!Empty(SE5->E5_FORNADT),SE5->(E5_FORNADT+E5_LOJAADT),IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
					IIf(mv_par01==1 .and. mv_par02==1,SE5->E5_LOJA,""))
					
				If !Empty(SE5->E5_FILORIG) .and. !Empty( cFilFwSE2 )
					aDadosX := GetInfSE5(SE5->E5_DOCUMEN)
                    cFilCred := FaPesqBx(SE5->E5_FILIAL,aDadosX[1],aDadosX[2],aDadosX[3],aDadosX[5],aDadosX[6],aDadosX[4],SE5->E5_DATA,SE5->E5_SEQ,"P",SE5->E5_DOCUMEN,cTipoDc)
					cChaveSe2 := cFilCred+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )										
				Endif

				dbSelectArea("SE2")
				dbSetOrder(1)
				If (cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT+"/INA")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Volta valor do abatimento se existir ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nTotAbat := 0
					dbSelectArea("SE2")
					dbSeek(Left(cChaveSe2,Len(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA)))
					While !Eof() .And.;
							E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA==Left(cChaveSe2,Len(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA))
						If SE2->E2_TIPO $ MVABATIM
							nTotAbat += SE2->E2_VALOR-SE2->E2_SALDO
							RecLock("SE2",.F.)
							SE2->E2_SALDO := SE2->E2_VALOR
							SE2->E2_BAIXA := Ctod("")
							MsUnLock()
						EndIf
						dbSelectArea("SE2")
						dbSkip()
					EndDo
				Endif	
				
				If !lDebito
					Fa340VerNDF(@lNDF,@nRecNDF) //Baixa NDF
				EndIf
			
				If dbSeek(cChaveSe2)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o t¡tulo tem NDF baixada - PABruto ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lPaBruto .and. lDebito .and. Fa340VerNDF(@lNDF,@nRecNDF)
						MsgAlert(STR0044)						
						#IFDEF TOP
							If TcSrvType() != "AS/400"
								dbSelectArea( "TRB")
								dbCloseArea()
							Endif
						#ENDIF	
						dbSelectArea( "SE2" )
						dbSetOrder( 1 )
						dbSelectArea( "SE5" )
						dbSetOrder( 1 )
						dbGoTo( nReg )
						Return		
					EndIf
				   
				   	If !lDebito
				   		AAdd( aRecPa, SE2->( Recno() ) )
				   	EndIf
			   
				   
					cAdiantamento := Substr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)
					While !Eof().and.E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO==Substr(cAdiantamento,1,nTamtit+nTamTip).and.;
							E2_FILIAL == Substr(cChaveSe2,1,IIf( lFWCodFil, FWGETTAMFILIAL, 2 ))
						// Zero a variavel que soma os impostos (lei 10925)do titulo.
						nValImp := 0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica Fornecedor. Verifica Loja (Se considera Loja)	³
						//³ Se n„o considera Fornecedor Original, verifica se perten³
						//³ ce a faixa selecionada (mv_par03 a mv_par04)            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   					If !Empty(SE5->E5_FORNADT)
							lAchou := SE5->(E5_FORNADT+E5_LOJAADT) == SE2->(E2_FORNECE+E2_LOJA)
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica Fornecedor. Verifica Loja (Se considera Loja)	³
							//³ Se n„o considera Fornecedor Original, verifica se perten³
							//³ ce a faixa selecionada (mv_par03 a mv_par04)            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							lAchou := (SE2->E2_FORNECE == SE5->E5_CLIFOR .and. ;
										IIf (mv_par01 == 1 , SE2->E2_LOJA == SE5->E5_LOJA,.T.)) .OR. ;
										(mv_par02 == 2 .and. SE2->E2_FORNECE >= mv_par03 .and. ;
										SE2->E2_FORNECE <= mv_par04 )
						Endif
						If lAchou
							If (lContrRet .Or. lIRPFBaixa) .and. SE2->E2_TIPO $ MVPAGANT+"/INA" .and. !lPaBruto 
								
								If lPccBaixa .And. !lPaBruto .And. lPropPA .and. lValPgto//Proporcionalizacao do PA. 	 	
									aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa,SE2->E2_PARCISS)				
								Else
									aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa,SE2->E2_PARCISS)				
								Endif
									
								For nX := 1 To Len(aImp10925)   
									nValImp += aImp10925[nX][6]
								Next					
							Elseif lContrRet .And. SE2->E2_TIPO $ MVPAGANT+"/INA" .AND. lPaBruto .and. (!(SE5->E5_PRETPIS == '5') .and.;
							 !Empty(SE2->E2_TITADT) .Or. lIRPFBaixa)
								
								aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa,SE2->E2_PARCISS)				
									
								For nX := 1 To Len(aImp10925)
									nValImp += aImp10925[nX][6]
								Next		
								
								If SE5->E5_VALOR == SE2->E2_VALOR .And. !Empty(SE2->E2_BAIXA) .And. !lPropPA
									nValImp	:=	0								
								Endif
																				
							Endif
							
							RecLock("SE2")
							If cPaisLoc == "BRA"																																						
								If lDebito
									AltvencImp(SE2->E2_VENCREA)
								Endif
							   
							 						
								If lPccBaixa .And. !lPaBruto .And. lPropPA .and. lValPgto
							   		F340SalPr(cTipodc)	  
							 	Else
							 	
								 	lAltPa	:=	.F.							 	
								  	nTxMoeda := IIf(!Empty(SE5->E5_TXMOEDA),SE5->E5_TXMOEDA,RecMoeda(SE5->E5_DATA,SE2->E2_MOEDA))
									If (SE2->E2_MOEDA > 1 .AND. nMoeda == 1) .or. (SE2->E2_MOEDA == 1 .AND. nMoeda > 1) 
										If Val(SE5->E5_MOEDA) == SE2->E2_MOEDA 
											SE2->E2_SALDO += Round(NoRound(xMoeda(SE5->E5_VALOR - Iif(SE5->E5_VALOR-IIf(nProp>0,(nValImp*nProp),nValImp) == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0),nMoeda,SE2->E2_MOEDA,SE5->E5_DATA,3,,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA)),3),2)
										Else
											SE2->E2_SALDO += SE5->E5_VALOR
										EndIf	
									ElseIf (SE2->E2_MOEDA == 1 .And. nMoeda == 1) .And. nProp > 0 .And. lPropPA .and. lValPgto
										SE2->E2_SALDO +=Round(NoRound(xMoeda(SE5->E5_VALOR - IIf(nProp>0,(nValImp*nProp),nValImp),1,SE2->E2_MOEDA,SE5->E5_DATA,3,,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA)),3),2)
										lAltPa	:=	.T.
									Endif
									If (lPaBruto .or. (!lPaBruto .and. !SE2->E2_TIPO $ MVPAGANT+"/INA") ).and. ( SE2->E2_VALOR != SE2->E2_SALDO )	 .And.  (SE2->E2_MOEDA == 1 .AND. nMoeda == 1)													
										SE2->E2_SALDO += Round(NoRound(xMoeda(SE5->E5_VLMOED2 - Iif(SE5->E5_VLMOED2-IIf(nProp>0,(nValImp*nProp),nValImp) == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0),nMoeda,SE2->E2_MOEDA,SE5->E5_DATA,3	, If(SE2->E2_MOEDA == 1, Fa340TxMd(nMoeda,nTxMoeda),Fa340TxMd(nMoeda,SE2->E2_TXMOEDA));
																																	, If(nMoeda        == 1, Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ))),3),2)
									Endif     
								Endif
		   				  
								If SE2->E2_SALDO < SE2->E2_VALOR
									If lPaBruto .and. !lIRPFBaixa .and. !Empty(SE2->E2_PARCIR) .and. SE2->(E2_SALDO + E2_VRETIRF + nValImp ) == SE2->E2_VALOR 
										nValImp += SE2->E2_VRETIRF
									ElseIf !lPaBruto .and. ( SE2->(E2_SALDO + E2_VRETIRF + nValImp ) < SE2->E2_VALOR ) .and. SE5->E5_VRETIRF > 0
										nValImp += SE5->E5_VRETIRF
									Endif
									nSaldoOrig := SE2->E2_SALDO
									SE2->E2_SALDO	+= Round(NoRound(xMoeda(nValImp,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
									If SE2->E2_SALDO > SE2->E2_VALOR .Or. (SE2->E2_SALDO < SE2->E2_VALOR .And. lIrpfBaixa) 	//Recupero o saldo original caso seja maior que
										SE2->E2_SALDO := nSaldoOrig															//o valor do título ou verifico se o saldo é menor
									EndIf																					//e o IR foi calculado na baixa (PA)
								EndIf 
		   					
		   					//QUESTAO DE ARREDONDAMENTO
								If ABS(SE2->E2_VALOR - SE2->E2_SALDO) <= 0.009999 .And. !(lPropPA .And. nProp>0)
									SE2->E2_SALDO := SE2->E2_VALOR
								Endif
							   SE2->E2_VALLIQ:= 0                                                  
								nValorBaix+= SE5->E5_VALOR + nTitDecre - nTitAcres
								nImp+= SE5->E5_VRETPIS+SE5->E5_VRETCOF+SE5->E5_VRETCSL+SE5->E5_VRETIRF+SE5->E5_VRETISS
								nVPis+=SE5->E5_VRETPIS
								nVCof+=SE5->E5_VRETCOF
								nVCsl+=SE5->E5_VRETCSL
								nVIrf+=SE5->E5_VRETIRF 
								nVIss+=SE5->E5_VRETISS
								If SE2->E2_MOEDA == 1 .AND. nMoeda > 1 .And. lDebito
                                    If STR(SE5->E5_VALOR,17,2) != STR(SE5->E5_VLMOED2,17,2)
                                    	nValBaix2 += SE5->E5_VLMOED2
                                    Else	
                                    	If Val(SE5->E5_MOEDA) <> SE2->E2_MOEDA
											nValBaix2 += Round(NoRound(xMoeda(SE5->E5_VLMOED2,SE2->E2_MOEDA,nMoeda,SE5->E5_DATA,3	,If(lDebito,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ));
																																,If(lDebito,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,SE2->E2_TXMOEDA))),3),2)
										Else
											nValBaix2 += SE5->E5_VLMOED2	
										EndIf																																
									Endif
								Else
                                    If STR(SE5->E5_VALOR,17,2) != STR(SE5->E5_VLMOED2,17,2)
                                    	nValBaix2 += SE5->E5_VLMOED2
                                    Else	
                                    	If Val(SE5->E5_MOEDA) <> SE2->E2_MOEDA
											nValBaix2 += Round(NoRound(xMoeda(SE5->E5_VALOR,1,nMoeda,SE5->E5_DATA,3,,If(lDebito,Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),Fa340TxMd(nMoeda,nTxMoeda))),3),2)
										Else
											nValBaix2 += SE5->E5_VLMOED2	
										EndIf											
									Endif									
								Endif	
								nValBaix2+= Round(NoRound(xMoeda(SE5->E5_VLDESCO-SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,3	,If(lDebito,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ));
																															,If(lDebito,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,SE2->E2_TXMOEDA))),3),2)
								nSe2Rec := SE2->(RECNO())
							Else
         					//Procurar o registro da baixa, ao inves de utilizatr o da compensacao, para poder pegar  
         					//diretamente os valores utilizados para a baixa.
							   nDecs 	:= MsDecimais(nMoeda)
								nRecBkpSE5	:=	SE5->(Recno())
								nOrdBkpSE5	:=	SE5->(IndexOrd())
							   	nTxMoeda	:=	SE5->E5_VALOR/SE5->E5_VLMOED2
								nValBaix2 	+= SE5->E5_VLMOED2+Round(xMoeda(SE5->E5_VLDESCO - SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,nTxMoeda)),nDecs1)
							   nLiq  		+= Round(xMoeda(SE5->E5_VLMOED2+nTotAbat,nMoeda,1,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,nTxMoeda)),nDecs1)
	
								SE5->(DbSetOrder(7))
								If SE5->(FieldPos("E5_FORNADT"))>0 .and. !Empty(SE5->E5_FORNADT)
									SE5->(MsSeek(xFilial()+SubStr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)+SE5->(E5_FORNADT+E5_LOJAADT)+SE5->E5_SEQ))							
								Else
									SE5->(MsSeek(xFilial()+SubStr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)+SE2->(E2_FORNECE+E2_LOJA)+SE5->E5_SEQ))							
		                        Endif 
        		                If SE5->(Found())
									nValorBaix	+=	SE5->E5_VALOR + nTitDecre - nTitAcres
									nValSaldo 	:=	SE5->E5_VLMOED2+nTotAbat
									nVlLiqBx		:=	SE5->E5_VALOR+Round(xMoeda(nTotAbat,nMoeda,1,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,SE5->E5_VALOR/SE5->E5_VLMOED2)),nDecs1)														
								Else
									SE5->(DbSetOrder(nOrdBkpSE5))
									SE5->(dBGoTo(nRecBkpSE5))
									nValorBaix	+= SE5->E5_VALOR + nTitDecre - nTitAcres
									nValSaldo	:=	xMoeda(SE5->E5_VLMOED2+nTotAbat,nMoeda,SE2->E2_MOEDA,SE5->E5_DATA,nDecs+3,Fa340TxMd(nMoeda,nTxMoeda))
									nVlLiqBx		:=	Round(xMoeda(SE5->E5_VLMOED2+nTotAbat,nMoeda,1,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,nTxMoeda)),nDecs1)														
								Endif   
								//QUESTAO DE ARREDONDAMENTO
								If ABS(SE2->E2_VALOR - (SE2->E2_SALDO+nValSaldo)) <= 0.9999/(10**MsDecimais(SE2->E2_MOEDA)).Or.;
									SE2->E2_VALOR < (SE2->E2_SALDO+nValSaldo)
									SE2->E2_SALDO := SE2->E2_VALOR               
								Else
									SE2->E2_SALDO += nValSaldo									
								Endif

							   	SE2->E2_VALLIQ -= nVlLiqBx
								nSe2Rec := SE2->(RECNO())      
								SE5->(DbSetOrder(nOrdBkpSE5))
								SE5->(dBgOTO(nRecBkpSE5))
							EndIf   							   
							If NoRound( SE2->E2_VALOR, 2 ) == NoRound( SE2->E2_SALDO, 2 )
								SE2->E2_BAIXA := CtoD("  /  /  ")
					            //Caso exista solicitacao de NCP eh necessario atualizar o campo CU_DTBAIXA... 
            					If cPaisLoc <> "BRA"
            						A055AtuDtBx("2",SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NUM,SE2->E2_PREFIXO,SE2->E2_BAIXA)
								EndIf
							EndIf
						   MsUnlock()

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza dados no Cadastro de Fornecedores              		³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dbSelectArea("SA2")
							lAchouCli := MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
							If !lAchouCli
								// Pesquisa com a filial origem do titulo, para casos de SA2 exclusivo
								lAchouCli := MsSeek(SE2->E2_FILORIG+SE2->E2_FORNECE+SE2->E2_LOJA)
							EndIf								
							If lAchouCli
								RecLock("SA2")
								If SE2->E2_MOEDA > 1
									nValPadrao := Round(NoRound(xMoeda(SE5->E5_VALOR - nValImp,1,SE2->E2_MOEDA,SE5->E5_DATA,3,,If(lDebito,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda))),3),2)
								Else
									nValPadrao := SE5->E5_VALOR 
								Endif
								IF SE2->E2_TIPO $ MVPAGANT+"/INA"+"/"+MV_CPNEG
									SA2->A2_SALDUP	-= nValPadrao
									SA2->A2_SALDUPM	-= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
								Else
									SA2->A2_SALDUP		+= nValPadrao
									SA2->A2_SALDUPM	+= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
								Endif
								SA2->(MsUnlock())
							EndIf
						Endif
						dbSelectArea("SE2")
						dbSkip()
					Enddo
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Deleta a baixa do SE5					 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE5")
					dbSetOrder(2)
					cFornAdt := ""    
					nFilAt := SE5->E5_filial
					nLen := Len(SE5->E5_PREFIXO+SE5->E5_NUMERO+;
									SE5->E5_PARCELA+SE5->E5_TIPO+;
									If(!Empty(SE5->E5_FORNADT),"",;
									IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
									IIf(mv_par01==1 .And. mv_par02==1,SE5->E5_LOJA,"")))
					If !Empty(SE5->E5_FORNADT)
						cFornAdt		:= SE5->(E5_FORNADT+E5_LOJAADT)
					Endif	
					If (dbSeek(nFilAt+cTipodc+SubStr(Trim(cDocumento),1,nTamTit+nTamTip)))
						While !EOF() .And. nFilAt+cTipodc+SubStr(Trim(cDocumento),1,nTamTit+nTamTip)== SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) .And. Empty(SE5->E5_DOCUMEN)
							SE5->(DbSkip())
						EndDo
						If !Empty( cFilFwSE2 ) .and. !empty(cFilCred)
							bWhile := {|| cFilCred == SE5->E5_FILORIG }
						Else
							bWhile := {|| SE5->E5_FILIAL == xFilial("SE5") }
						Endif                                

						While !Eof() .And. eval(bWhile) .And. ;
								(Left(cDocumento,nLen) ==	SE5->E5_PREFIXO+SE5->E5_NUMERO+;
																	SE5->E5_PARCELA+SE5->E5_TIPO+;
																	If(!Empty(SE5->E5_FORNADT),"",;
																	IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
																	IIf(mv_par01==1 .And. mv_par02==1,SE5->E5_LOJA,""));
									.or. SE5->E5_TIPO == "INA")								
							If cSeq == SE5->E5_SEQ .And. ;
								(Empty(E5_FORNADT+E5_LOJAADT)		 .Or.;
								 SE5->(E5_FORNADT+E5_LOJAADT)	== SE5->(E5_CLIFOR+E5_LOJA) .Or.;
								 SE5->(E5_CLIFOR+E5_LOJA)		== cFornAdt .Or.;
								 SE5->(E5_FORNADT+E5_LOJAADT)	== cFornAdt) .And.;
								SubStr(Trim(SE5->E5_DOCUMEN),1,nTamTit+nTamTip) == cChaveAdt

								//Dados do titulo de adiantamento
								dbSelectArea("SE2")
								dbGoto(nSE2Rec)
								RecLock("SE2")
								nAcresc := Round(NoRound(xMoeda(SE5->E5_VLJUROS,1,SE2->E2_MOEDA,SE5->E5_DATA,3,,SE5->E5_TXMOEDA),3),2)
								nDecres := Round(NoRound(xMoeda(SE5->E5_VLDESCO,1,SE2->E2_MOEDA,SE5->E5_DATA,3,,SE5->E5_TXMOEDA),3),2)
								SE2->E2_SALDO += nDecres - nAcresc
								//QUESTAO DE ARREDONDAMENTO
								If ABS(SE2->E2_VALOR - xMoeda(SE5->E5_VLMOED2+If(lPaBruto,nValImp,0),nMoeda,SE2->E2_MOEDA,SE5->E5_DATA,3) - (nTotAbat + nDecres - nAcresc)) <= 0.0099999
									SE2->E2_SALDO := SE2->E2_VALOR
								Endif  
								SE2->E2_SDACRES += nAcresc
								SE2->E2_SDDECRE += nDecres	  
								If !(SE2->E2_TIPO $ MVPAGANT+"/INA") .and. lPropPA .and. lValPgto .and.  lPrImPA 
								   	   	If lPccBaixa
										   	SE2->E2_VRETPIS	-= SE5->E5_VRETPIS
											SE2->E2_VRETCSL	-= SE5->E5_VRETCSL
											SE2->E2_VRETCOF -= SE5->E5_VRETCOF
										Endif  
										If lIRPFBaixa
											SE2->E2_VRETIRF	-= SE5->E5_VRETIRF  
										Endif
										If lCalcIssBx 
											SE2->E2_VRETISS	-= SE5->E5_VRETISS
										Endif	
										If SE2->(E2_VRETPIS+E2_VRETCOF+E2_VRETCSL)>0
	  										cPret:=FinRtPret(SE5->E5_SEQ)  
	   										SE2->E2_PRETPIS := cPret
											SE2->E2_PRETCOF := cPret
											SE2->E2_PRETCSL := cPret
										Else
											SE2->E2_PRETPIS := "1"
											SE2->E2_PRETCOF := "1"
											SE2->E2_PRETCSL := "1"
										EndIf
						   		Endif				
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ So limpa a data da baixa se nao houver mais 	 ³
								//³ nenhum movimento para este titulo					 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If NoRound( SE2->E2_VALOR, 2 ) == NoRound( SE2->E2_SALDO, 2 )
									SE2->E2_BAIXA := CtoD("  /  /  ")
								EndIf
								MsUnlock()			

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Grava lançamento no PCO ref  titulo compensado apos cancelamento    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								PCODetLan("000017","02","FINA340")
								Aadd( aKeysTx , {SE5->E5_TIPO, SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)} )
								If nOpc == 4 .and. SE5->E5_LA <> "S " //Exclusao
									cSeqEstorno := SE5->E5_SEQ
									Fin340ExCM(SE5->E5_FILIAL, SE5->E5_SEQ)
									Reclock("SE5")
									dbDelete()
									MsUnlock()
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava lançamento no PCO ref baixa titulo compensado apos a cancelamento    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									PCODetLan("000017","06","FINA340",.T.)
								Else
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Obtem os dados do registro tipo RA para gerar um	  ³
									//³ registro de estorno 										  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									aSE5 := {}
									//dbSetOrder( 1 )
									dbSelectArea("SE5")
									dbSetOrder(1)
									For nX := 1 to SE5->( Fcount() )
										AAdd( aSE5, SE5->( FieldGet(nX) ) )
									NEXT
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava o registro de estorno                     	  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									RecLock("SE5" ,.T.)
									For nX := 1 to SE5->(Fcount())
										SE5->( FieldPut( nX,aSE5[nX]))
									Next
									SE5->E5_TIPODOC	:= "ES"
									SE5->E5_RECPAG	:= "R"
									SE5->E5_HISTOR	:= STR0041 //"Cancel. de Compensacao"
									SE5->E5_DATA	:= dDatabase
									SE5->E5_DTDIGIT	:= dDataBase
									SE5->E5_DTDISPO	:= dDataBase
									SE5->E5_LA			:= IIF(lPadrao .and. MV_PAR11 == 1 ,"S","N")
									
									If mv_par11 == 1 .And. lUsaFlag
										aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
									Elseif mv_par11 == 1 .And. !lUsaFlag .And. lPadrao						
										SE5->E5_LA		:= "S"
									EndIf

									If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
 					  					SE5->E5_NODIA := ""
  				   					EndIf	

  									If SE5->(FieldPos("E5_MSEXP")) > 0
										SE5->E5_MSEXP := ""
  									EndIf  				   				

									MsUnlock()
									cSeqEstorno := SE5->E5_SEQ
									
									If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
 										AAdd(aDiario,{"SE5",SE5->(Recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"})
  									EndIf	  
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava lançamento no PCO ref baixa titulo compensado apos a cancelamento    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									PCODetLan("000017","06","FINA340")
									
									If lF340GREST
										ExecBlock("F340GREST",.F.,.F.)
									EndIf
								Endif
							Endif
							dbSkip()
						EndDo
					EndIF
					dbSetOrder(1)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³  Apaga registro da movimenta‡„o  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE5")
					dbGoTo(aRegistros[nLaco])

					If lPadrao .and. mv_par11 == 1
						nTotal += DetProva( nHdlPrv,;
						                    cPadrao,;
						                    "FINA340",;
						                    cLote,;
						                    /*nLinha*/,;
						                    /*lExecuta*/,;
						                    /*cCriterio*/,;
						                    /*lRateio*/,;
						                    /*cChaveBusca*/,;
						                    /*aCT5*/,;
						                    /*lPosiciona*/,;
						                    @aFlagCTB,;
						                    /*aTabRecOri*/,;
						                    /*aDadosProva*/ )
					EndIF

					F340Semaforo({},.F.,aRegistros[nLaco], "", {}, .F.) // LIBERA REGISTRO NO SEMAFORO
					Aadd( aKeysTx , {SE5->E5_TIPO, SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)} )
					If nOpc == 4 .and. SE5->E5_LA <> "S "  //Exclusao				

						Fin340ExCM(SE5->E5_FILIAL, SE5->E5_SEQ)

						Reclock("SE5",.F.,.T.)
						dbDelete()
						MsUnlock()
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava lançamento no PCO ref baixa titulo principal apos a canc.compensacao ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						PCODetLan("000017","05","FINA340",.T.)
	    	     	Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Obtem os dados do registro tipo RA para gerar um	³
						//³ registro de estorno 							    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aSE5 := {}
						dbSetOrder( 1 )
						For nX := 1 to SE5->( Fcount() )
							AAdd( aSE5, SE5->( FieldGet(nX) ) )
						NEXT
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava o registro de estorno                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RecLock("SE5" ,.T.)
						For nX := 1 to SE5->(Fcount())
							SE5->( FieldPut( nX,aSE5[nX]))
						Next
						SE5->E5_TIPODOC	:= "ES"
						SE5->E5_RECPAG	:= "R"
						SE5->E5_HISTOR	:= STR0041 //"Cancel. de Compensacao"
						SE5->E5_DATA	:= dDatabase
						SE5->E5_DTDIGIT	:= dDataBase
						SE5->E5_DTDISPO	:= dDataBase                        
						SE5->E5_LA		:= IIF(lPadrao .and. MV_PAR11 == 1 ,"S","N")
						If mv_par11 == 1 .And. lUsaFlag
							aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
						Elseif mv_par11 == 1 .And. !lUsaFlag .And. lPadrao						
							SE5->E5_LA		:= "S"
						EndIf
						If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
 							SE5->E5_NODIA := ""
	  					EndIf	

						If SE5->(FieldPos("E5_MSEXP")) > 0
							SE5->E5_MSEXP := ""
						EndIf  				   				
	  					
						MsUnlock()
						If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
 							AAdd(aDiario,{"SE5",SE5->(Recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"})
  						EndIf	  
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava lançamento no PCO ref baixa titulo principal apos a canc.compensacao ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						PCODetLan("000017","05","FINA340")
						
						If lF340GREST
							ExecBlock("F340GREST",.F.,.F.)
						EndIf						
					Endif
					lCancelou := .T.
					
				Endif
			Endif
		Next

		//Trata o estorno automatico do inss
		If Len(aTitINSS) <> 0
			For nLaco := 1 to Len(aRegINSS)
				cCondic := "(aTitINSS["+STR(nLaco)+",10])"
				If &cCondic
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ So monta o cabecalho do LP se acha pelo menos um³
					//³ registro marcado 										 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lFirst
						nHdlPrv := HeadProva( cLote,;
						                      "FINA340",;
						                      Substr( cUsuario, 7, 6 ),;
						                      @cArquivo )
	
						VALOR 	:= 0
						VLRINSTR := 0
						lFirst:= .F.
					Endif
					dbSelectArea("SE5")
					dbGoTo(aRegINSS[nLaco])
					cDocumento := Substr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)+;
						IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
						IIf(mv_par01==1 .and. mv_par02==1,SE5->E5_LOJA,"")
	
					cSeq		  := SE5->E5_SEQ
					cChaveAdt  := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)
	
					//Acrescimos e Decrescimos do titulo principal
					If SE5->E5_VLJUROS > 0
						nINSAcres	+= Round(NoRound(xMoeda(SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,3,,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
					Endif
					If SE5->E5_VLDESCO > 0
						nINSDecre	+= Round(NoRound(xMoeda(SE5->E5_VLDESCO,1,nMoeda,SE5->E5_DATA,3,,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
					Endif
	                
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Localiza o t¡tulo PA/NDF correspondente … baixa ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Inicializa a chave de pesquisa com  ³
					//³ a filial padrÆo. Caso seja utilizada³
					//³ compensa‡Æo em outras filiais, ir   ³
					//³ utilizar-se do campo E5_FILORIG.    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cChaveSe2 := xFilial("SE2")+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+;
						If(!Empty(SE5->E5_FORNADT),SE5->(E5_FORNADT+E5_LOJAADT),IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
						IIf(mv_par01==1 .and. mv_par02==1,SE5->E5_LOJA,""))
						
					If !Empty(SE5->E5_FILORIG) .and. !Empty( cFilFwSE2 )
						aDadosX := GetInfSE5(SE5->E5_DOCUMEN)
                    	cFilCred := FaPesqBx(SE5->E5_FILIAL,aDadosX[1],aDadosX[2],aDadosX[3],aDadosX[5],aDadosX[6],aDadosX[4],SE5->E5_DATA,SE5->E5_SEQ,"P",SE5->E5_DOCUMEN,cTipoDc)
						cChaveSe2 := cFilCred+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )							
					Endif
	
					dbSelectArea("SE2")
					dbSetOrder(1)
					If (cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT+"/INA")
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Volta valor do abatimento se existir ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nTotAbat := 0
						dbSelectArea("SE2")
						dbSeek(Left(cChaveSe2,Len(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA)))
						While !Eof() .And.;
								E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA==Left(cChaveSe2,Len(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA))
							If SE2->E2_TIPO $ MVABATIM
								nTotAbat += SE2->E2_VALOR-SE2->E2_SALDO
								RecLock("SE2",.F.)
								SE2->E2_SALDO := SE2->E2_VALOR
								SE2->E2_BAIXA := Ctod("")
								MsUnLock()
							EndIf
							dbSelectArea("SE2")
							dbSkip()
						EndDo
					Endif	
					
					If !lDebito
						Fa340VerNDF(@lNDF,@nRecNDF) //Baixa NDF
					EndIf
				
					If dbSeek(cChaveSe2)
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se o t¡tulo tem NDF baixada - PABruto ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lPaBruto .and. lDebito .and. Fa340VerNDF(@lNDF,@nRecNDF)
							MsgAlert(STR0044)						
							#IFDEF TOP
								If TcSrvType() != "AS/400"
									dbSelectArea( "TRB")
									dbCloseArea()
								Endif
							#ENDIF	
							dbSelectArea( "SE2" )
							dbSetOrder( 1 )
							dbSelectArea( "SE5" )
							dbSetOrder( 1 )
							dbGoTo( nReg )
							Return		
						EndIf
					   
					   	If !lDebito
					   		AAdd( aRecPa, SE2->( Recno() ) )
					   	EndIf
				   
					   
						cAdiantamento := Substr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)
						While !Eof().and.E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO==Substr(cAdiantamento,1,nTamtit+nTamTip).and.;
								E2_FILIAL == Substr(cChaveSe2,1,IIf( lFWCodFil, FWGETTAMFILIAL, 2 ))
							// Zero a variavel que soma os impostos (lei 10925)do titulo.
							nValImp := 0
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica Fornecedor. Verifica Loja (Se considera Loja)	³
							//³ Se n„o considera Fornecedor Original, verifica se perten³
							//³ ce a faixa selecionada (mv_par03 a mv_par04)            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   					If !Empty(SE5->E5_FORNADT)
								lAchou := SE5->(E5_FORNADT+E5_LOJAADT) == SE2->(E2_FORNECE+E2_LOJA)
							Else
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verifica Fornecedor. Verifica Loja (Se considera Loja)	³
								//³ Se n„o considera Fornecedor Original, verifica se perten³
								//³ ce a faixa selecionada (mv_par03 a mv_par04)            ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								lAchou := (SE2->E2_FORNECE == SE5->E5_CLIFOR .and. ;
											IIf (mv_par01 == 1 , SE2->E2_LOJA == SE5->E5_LOJA,.T.)) .OR. ;
											(mv_par02 == 2 .and. SE2->E2_FORNECE >= mv_par03 .and. ;
											SE2->E2_FORNECE <= mv_par04 )
							Endif
							If lAchou
								If (lContrRet .Or. lIRPFBaixa) .and. SE2->E2_TIPO $ MVPAGANT+"/INA" .and. !lPaBruto //.or. SE5->E5_PRETPIS != '5') )
									
									If lPccBaixa .And. !lPaBruto .And. lPropPA //Proporcionalizacao do PA. 	 	
										aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,.T.)
									Else
										aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,.T.)								
									Endif
										
									For nX := 1 To Len(aImp10925)
										nValImp += aImp10925[nX][6]
									Next							
								Elseif lContrRet .And. SE2->E2_TIPO $ MVPAGANT+"/INA" .AND. lPaBruto .and. (!(SE5->E5_PRETPIS == '5') .and.;
								 !Empty(SE2->E2_TITADT) .Or. lIRPFBaixa)
									
									aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,.T.)
										
									For nX := 1 To Len(aImp10925)
										nValImp += aImp10925[nX][6]
									Next		
									
									If SE5->E5_VALOR == SE2->E2_VALOR .And. !Empty(SE2->E2_BAIXA) .And. !lPropPA
										nValImp	:=	0								
									Endif
																					
								Endif
								
								RecLock("SE2")
								If cPaisLoc == "BRA"																																						
									If lDebito
										AltvencImp(SE2->E2_VENCREA)
									Endif
								   
								   nProp		:=	nPisProp	:= nCofProp := nCslProp	:=	nBasePis	:=	0								
									If lPccBaixa .And. !lPaBruto .And. lPropPA //Proporcionalizacao do PA. 	  
										nRegTit	:=	SE2->(Recno())
										aAreaSE2 := SE2->(GetArea())
										dbSelectArea("SE2")
										SE2->(Dbsetorder(1))
										If SE2->(DbSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))												                     
											nPisProp	:= SE2->E2_PIS
											nCofProp	:=	SE2->E2_COFINS
											nCslProp	:=	SE2->E2_CSLL
											nBasePis	:=	SE2->E2_BASEPIS				            																		
										Endif																			
										SE2->(RestArea(aAreaSE2))
										SE2->(DbGoto(nRegTit))   
									Endif																																		
																	
									nProp	:=	0 
									If lPccBaixa .And. !lPaBruto .And. SE2->E2_TIPO $ MVPAGANT+"/INA" .And. SE2->E2_BASEPIS > nBasePis .And. lPropPA //Proporcionalizacao do PA. 									
										nProp	:=	(nPisProp+nCofProp+nCslProp)/(SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL)															
									Endif
								 	
								 	lAltPa	:=	.F.							 	
								   nTxMoeda := IIf(!Empty(SE5->E5_TXMOEDA),SE5->E5_TXMOEDA,RecMoeda(SE5->E5_DATA,SE2->E2_MOEDA))
									If (SE2->E2_MOEDA > 1 .AND. nMoeda == 1) .or. (SE2->E2_MOEDA == 1 .AND. nMoeda > 1) 
										SE2->E2_SALDO += Round(NoRound(xMoeda(SE5->E5_VALOR - Iif(SE5->E5_VALOR-IIf(nProp>0,(nValImp*nProp),nValImp) == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0),1,SE2->E2_MOEDA,SE5->E5_DATA,3,,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA)),3),2)
									ElseIf (SE2->E2_MOEDA == 1 .And. nMoeda == 1) .And. nProp > 0 .And. lPropPA 
										SE2->E2_SALDO +=Round(NoRound(xMoeda(SE5->E5_VALOR - IIf(nProp>0,(nValImp*nProp),nValImp),1,SE2->E2_MOEDA,SE5->E5_DATA,3,,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA)),3),2)
										lAltPa	:=	.T.
									Else														
										SE2->E2_SALDO += Round(NoRound(xMoeda(SE5->E5_VLMOED2 - Iif(SE5->E5_VLMOED2-IIf(nProp>0,(nValImp*nProp),nValImp) == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0),nMoeda,SE2->E2_MOEDA,SE5->E5_DATA,3	, If(SE2->E2_MOEDA == 1, Fa340TxMd(nMoeda,nTxMoeda),Fa340TxMd(nMoeda,SE2->E2_TXMOEDA));
																																	, If(nMoeda        == 1, Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ))),3),2)
									Endif
			   				  
									If lPaBruto .And. SE2->E2_SALDO < SE2->E2_VALOR
										SE2->E2_SALDO	+= Round(NoRound(xMoeda(nValImp,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
									EndIf 
			   					
			   					//QUESTAO DE ARREDONDAMENTO
									If ABS(SE2->E2_VALOR - SE2->E2_SALDO) <= 0.009999 .And. !(lPropPA .And. nProp>0)
										SE2->E2_SALDO := SE2->E2_VALOR
									Endif
								   SE2->E2_VALLIQ:= 0                                                  
									nValorBaix+= SE5->E5_VALOR + nINSDecre - nINSAcres
									If SE2->E2_MOEDA == 1 .AND. nMoeda > 1 .And. lDebito
	                                    If STR(SE5->E5_VALOR,17,2) != STR(SE5->E5_VLMOED2,17,2)
	                                    	nValINSS2 += SE5->E5_VLMOED2
	                                    Else	
											nValINSS2 += Round(NoRound(xMoeda(SE5->E5_VLMOED2,SE2->E2_MOEDA,nMoeda,SE5->E5_DATA,3	,If(lDebito,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ));
																																	,If(lDebito,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,SE2->E2_TXMOEDA))),3),2)
										Endif
									Else
	                                    If STR(SE5->E5_VALOR,17,2) != STR(SE5->E5_VLMOED2,17,2)
	                                    	nValINSS2 += SE5->E5_VLMOED2
	                                    Else	
											nValINSS2 += Round(NoRound(xMoeda(SE5->E5_VALOR,1,nMoeda,SE5->E5_DATA,3,,If(lDebito,Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),Fa340TxMd(nMoeda,nTxMoeda))),3),2)
										Endif									
									Endif	
									nValINSS2+= Round(NoRound(xMoeda(SE5->E5_VLDESCO-SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,3	,If(lDebito,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ));
																																,If(lDebito,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,SE2->E2_TXMOEDA))),3),2)
									nSe2Rec := SE2->(RECNO())
								Else
	         					//Procurar o registro da baixa, ao inves de utilizatr o da compensacao, para poder pegar  
	         					//diretamente os valores utilizados para a baixa.
								   nDecs 	:= MsDecimais(nMoeda)
									nRecBkpSE5	:=	SE5->(Recno())
									nOrdBkpSE5	:=	SE5->(IndexOrd())
								   	nTxMoeda	:=	SE5->E5_VALOR/SE5->E5_VLMOED2
									nValINSS2 	+= SE5->E5_VLMOED2+Round(xMoeda(SE5->E5_VLDESCO - SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,nTxMoeda)),nDecs1)
								   nLiq  		+= Round(xMoeda(SE5->E5_VLMOED2+nTotAbat,nMoeda,1,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,nTxMoeda)),nDecs1)
		
									SE5->(DbSetOrder(7))
									If SE5->(FieldPos("E5_FORNADT"))>0 .and. !Empty(SE5->E5_FORNADT)
										SE5->(MsSeek(xFilial()+SubStr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)+SE5->(E5_FORNADT+E5_LOJAADT)+SE5->E5_SEQ))							
									Else
										SE5->(MsSeek(xFilial()+SubStr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)+SE2->(E2_FORNECE+E2_LOJA)+SE5->E5_SEQ))							
			                        Endif 
	        		                If SE5->(Found())
										nValorBaix	+=	SE5->E5_VALOR + nINSDecre - nINSAcres
										nValSaldo 	:=	SE5->E5_VLMOED2+nTotAbat
										nVlLiqBx		:=	SE5->E5_VALOR+Round(xMoeda(nTotAbat,nMoeda,1,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,SE5->E5_VALOR/SE5->E5_VLMOED2)),nDecs1)														
									Else
										SE5->(DbSetOrder(nOrdBkpSE5))
										SE5->(dBGoTo(nRecBkpSE5))
										nValorBaix	+= SE5->E5_VALOR + nINSDecre - nINSAcres
										nValSaldo	:=	xMoeda(SE5->E5_VLMOED2+nTotAbat,nMoeda,SE2->E2_MOEDA,SE5->E5_DATA,nDecs+3,Fa340TxMd(nMoeda,nTxMoeda))
										nVlLiqBx		:=	Round(xMoeda(SE5->E5_VLMOED2+nTotAbat,nMoeda,1,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,nTxMoeda)),nDecs1)														
									Endif   
									//QUESTAO DE ARREDONDAMENTO
									If ABS(SE2->E2_VALOR - (SE2->E2_SALDO+nValSaldo)) <= 0.9999/(10**MsDecimais(SE2->E2_MOEDA)).Or.;
										SE2->E2_VALOR < (SE2->E2_SALDO+nValSaldo)
										SE2->E2_SALDO := SE2->E2_VALOR               
									Else
										SE2->E2_SALDO += nValSaldo									
									Endif
	
								   	SE2->E2_VALLIQ -= nVlLiqBx
									nSe2Rec := SE2->(RECNO())      
									SE5->(DbSetOrder(nOrdBkpSE5))
									SE5->(dBgOTO(nRecBkpSE5))
								EndIf   							   
								If NoRound( SE2->E2_VALOR, 2 ) == NoRound( SE2->E2_SALDO, 2 )
									SE2->E2_BAIXA := CtoD("  /  /  ")
						            //Caso exista solicitacao de NCP eh necessario atualizar o campo CU_DTBAIXA... 
	            					If cPaisLoc <> "BRA"
	            						A055AtuDtBx("2",SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NUM,SE2->E2_PREFIXO,SE2->E2_BAIXA)
									EndIf
								EndIf
								MsUnlock()
	
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza dados no Cadastro de Fornecedores              		³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea("SA2")
								lAchouCli := MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
								If !lAchouCli
									// Pesquisa com a filial origem do titulo, para casos de SA2 exclusivo
									lAchouCli := MsSeek(SE2->E2_FILORIG+SE2->E2_FORNECE+SE2->E2_LOJA)
								EndIf								
								If lAchouCli
									RecLock("SA2")
									If SE2->E2_MOEDA > 1
										nValPadrao := Round(NoRound(xMoeda(SE5->E5_VALOR - nValImp,1,SE2->E2_MOEDA,SE5->E5_DATA,3,,If(lDebito,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda))),3),2)
									Else
										nValPadrao := SE5->E5_VALOR - nValImp
									Endif
									IF SE2->E2_TIPO $ MVPAGANT+"/INA"+"/"+MV_CPNEG
										SA2->A2_SALDUP	-= nValPadrao
										SA2->A2_SALDUPM	-= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
									Else
										SA2->A2_SALDUP		+= nValPadrao
										SA2->A2_SALDUPM	+= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
									Endif
									SA2->(MsUnlock())
								EndIf
							Endif
							dbSelectArea("SE2")
							dbSkip()
						Enddo
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Deleta a baixa do SE5					 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SE5")
						dbSetOrder(2)
						cFornAdt := ""   
						nFilAt := SE5->E5_filial
						nLen := Len(SE5->E5_PREFIXO+SE5->E5_NUMERO+;
										SE5->E5_PARCELA+SE5->E5_TIPO)
						If !Empty(SE5->E5_FORNADT)
							cFornAdt		:= SE5->(E5_FORNADT+E5_LOJAADT)
						Endif	
						If (dbSeek(nFilAt+cTipodc+SubStr(Trim(cDocumento),1,nTamTit+nTamTip)))
							If !Empty( cFilFwSE2 ) .and. !empty(cFilCred)
								bWhile := {|| cFilCred == SE5->E5_FILORIG }
							Else
								bWhile := {|| SE5->E5_FILIAL == xFilial("SE5") }
							Endif                                

					   		While !Eof() .And. eval(bWhile) .And. ;
									Left(cDocumento,nLen) ==	SE5->E5_PREFIXO+SE5->E5_NUMERO+;
																SE5->E5_PARCELA+SE5->E5_TIPO
								If cSeq == SE5->E5_SEQ .And. ;
									(Empty(E5_FORNADT+E5_LOJAADT)		 .Or.;
									 SE5->(E5_FORNADT+E5_LOJAADT)	== SE5->(E5_CLIFOR+E5_LOJA) .Or.;
									 SE5->(E5_CLIFOR+E5_LOJA)		== cFornAdt .Or.;
									 SE5->(E5_FORNADT+E5_LOJAADT)	== cFornAdt) .And.;
									SubStr(Trim(SE5->E5_DOCUMEN),1,nTamTit+nTamTip) == cChaveAdt
	
									//Dados do titulo de adiantamento
									dbSelectArea("SE2")
									dbGoto(nSE2Rec)
									RecLock("SE2")
									nAcresc := Round(NoRound(xMoeda(SE5->E5_VLJUROS,1,SE2->E2_MOEDA,SE5->E5_DATA,3),3),2)
									nDecres := Round(NoRound(xMoeda(SE5->E5_VLDESCO,1,SE2->E2_MOEDA,SE5->E5_DATA,3),3),2)
									SE2->E2_SALDO += nDecres - nAcresc
									//QUESTAO DE ARREDONDAMENTO
									If ABS(SE2->E2_VALOR - xMoeda(SE5->E5_VLMOED2+If(lPaBruto,nValImp,0),nMoeda,SE2->E2_MOEDA,SE5->E5_DATA,3) - (nTotAbat + nDecres - nAcresc)) <= 0.0099999
										SE2->E2_SALDO := SE2->E2_VALOR
									Endif
									SE2->E2_SDACRES += nAcresc
									SE2->E2_SDDECRE += nDecres					
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ So limpa a data da baixa se nao houver mais 	 ³
									//³ nenhum movimento para este titulo					 ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If NoRound( SE2->E2_VALOR, 2 ) == NoRound( SE2->E2_SALDO, 2 )
										SE2->E2_BAIXA := CtoD("  /  /  ")
									EndIf
									MsUnlock()			
	
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava lançamento no PCO ref  titulo compensado apos cancelamento    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									PCODetLan("000017","02","FINA340")
									
									If nOpc == 4 .and. SE5->E5_LA <> "S " //Exclusao
										
										Fin340ExCM(SE5->E5_FILIAL, SE5->E5_SEQ)
										Reclock("SE5")
										dbDelete()
										MsUnlock()
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Grava lançamento no PCO ref baixa titulo compensado apos a cancelamento    ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										PCODetLan("000017","06","FINA340",.T.)
									Else
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Obtem os dados do registro tipo RA para gerar um	  ³
										//³ registro de estorno 										  ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										aSE5 := {}
										dbSetOrder( 1 )
										For nX := 1 to SE5->( Fcount() )
											AAdd( aSE5, SE5->( FieldGet(nX) ) )
										NEXT
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Grava o registro de estorno                     	  ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										RecLock("SE5" ,.T.)
										For nX := 1 to SE5->(Fcount())
											SE5->( FieldPut( nX,aSE5[nX]))
										Next
										SE5->E5_TIPODOC	:= "ES"
										SE5->E5_RECPAG	:= "R"
										SE5->E5_HISTOR	:= STR0041 //"Cancel. de Compensacao"
										SE5->E5_DATA	:= dDatabase
										SE5->E5_DTDIGIT	:= dDataBase
										SE5->E5_DTDISPO	:= dDataBase
										SE5->E5_LA			:= IIF(lPadrao .and. MV_PAR11 == 1 ,"S","N")
										
										If mv_par11 == 1 .And. lUsaFlag
											aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
										Elseif mv_par11 == 1 .And. !lUsaFlag .And. lPadrao						
											SE5->E5_LA		:= "S"
										EndIf
	
										If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
	 					  					SE5->E5_NODIA := ""
	  				   					EndIf	
	
	  									If SE5->(FieldPos("E5_MSEXP")) > 0
											SE5->E5_MSEXP := ""
	  									EndIf  				   				
	
										MsUnlock()
										If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
	 										AAdd(aDiario,{"SE5",SE5->(Recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"})
	  									EndIf	  
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Grava lançamento no PCO ref baixa titulo compensado apos a cancelamento    ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										PCODetLan("000017","06","FINA340")
										
										If lF340GREST
											ExecBlock("F340GREST",.F.,.F.)
										EndIf
									Endif
								Endif
								dbSkip()
							EndDo
						EndIF
						dbSetOrder(1)
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³  Apaga registro da movimenta‡„o  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SE5")
						dbGoTo(aRegINSS[nLaco])
	
						If lPadrao .and. mv_par11 == 1
							nTotal += DetProva( nHdlPrv,;
							                    cPadrao,;
							                    "FINA340",;
							                    cLote,;
							                    /*nLinha*/,;
							                    /*lExecuta*/,;
							                    /*cCriterio*/,;
							                    /*lRateio*/,;
							                    /*cChaveBusca*/,;
							                    /*aCT5*/,;
							                    /*lPosiciona*/,;
							                    @aFlagCTB,;
							                    /*aTabRecOri*/,;
							                    /*aDadosProva*/ )
						EndIF
	
						F340Semaforo({},.F.,aRegINSS[nLaco], "", {}, .F.) // LIBERA REGISTRO NO SEMAFORO
						If nOpc == 4 .and. SE5->E5_LA <> "S "  //Exclusao	
							Fin340ExCM(SE5->E5_FILIAL, SE5->E5_SEQ)			
							Reclock("SE5",.F.,.T.)
							dbDelete()
							MsUnlock()
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava lançamento no PCO ref baixa titulo principal apos a canc.compensacao ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							PCODetLan("000017","05","FINA340",.T.)
		    	     	Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Obtem os dados do registro tipo RA para gerar um	³
							//³ registro de estorno 							    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aSE5 := {}
							dbSetOrder( 1 )
							For nX := 1 to SE5->( Fcount() )
								AAdd( aSE5, SE5->( FieldGet(nX) ) )
							NEXT
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava o registro de estorno                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RecLock("SE5" ,.T.)
							For nX := 1 to SE5->(Fcount())
								SE5->( FieldPut( nX,aSE5[nX]))
							Next
							SE5->E5_TIPODOC	:= "ES"
							SE5->E5_RECPAG	:= "R"
							SE5->E5_HISTOR	:= STR0041 //"Cancel. de Compensacao"
							SE5->E5_DATA	:= dDatabase
							SE5->E5_DTDIGIT	:= dDataBase
							SE5->E5_DTDISPO	:= dDataBase                        
							SE5->E5_LA		:= IIF(lPadrao .and. MV_PAR11 == 1 ,"S","N")
							If mv_par11 == 1 .And. lUsaFlag
								aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
							Elseif mv_par11 == 1 .And. !lUsaFlag .And. lPadrao						
								SE5->E5_LA		:= "S"
							EndIf
							If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
	 							SE5->E5_NODIA := ""
		  					EndIf	
	
							If SE5->(FieldPos("E5_MSEXP")) > 0
								SE5->E5_MSEXP := ""
							EndIf  				   				
		  					
							MsUnlock()
							If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
	 							AAdd(aDiario,{"SE5",SE5->(Recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"})
	  						EndIf	  
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava lançamento no PCO ref baixa titulo principal apos a canc.compensacao ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							PCODetLan("000017","05","FINA340")
							
							If lF340GREST
								ExecBlock("F340GREST",.F.,.F.)
							EndIf						
						Endif
						lCancelou := .T.
						
					Endif
				Endif
			Next
		EndIf

		If lPadrao .and. lCancelou .and. !lFirst .and. mv_par11 == 1
			VALOR 	:= nValorBaix
			VLRINSTR := nValorBaix
			dbSelectArea("SE2")
			nRecSe2 := RecNo()
			dbGoBottom()
			dbSkip()
			dbSelectArea("SE5")
			nRecSe5 := RecNo()
			dbGoBottom()
			dbSkip()
			nTotal += DetProva( nHdlPrv,;
			                    cPadrao,;
			                    "FINA340",;
			                    cLote,;
			                    0,;
			                    .F.,;
			                    "FINA340",;
			                    /*lRateio*/,;
			                    /*cChaveBusca*/,;
			                    /*aCT5*/,;
			                    /*lPosiciona*/,;
			                    @aFlagCTB,;
			                    /*aTabRecOri*/,;
			                    /*aDadosProva*/ )

			RodaProva(  nHdlPrv,;
						nTotal)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lan‡amento Cont bil	                	³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cA100Incl( @cArquivo,;
			           nHdlPrv,;
			           3,;
			           cLote,;
			           lDigita,;
			           lAglutina,;
			           /*cOnLine*/,;
			           /*dData*/,;
			           /*dReproc*/,;
			           @aFlagCTB,;
			           /*aDadosProva*/,;
			           aDiario )
			aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

			dbSelectArea("SE2")
			dbGoTo(nRecSe2)
			dbSelectArea("SE5")
			dbGoTo(nRecSe5)
		EndIF
		If !(cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT+"/INA")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Volta valor do abatimento se existir ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotAbat := 0
			dbSelectArea("SE2")
			dbSetOrder(6)
			dbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNum+cParcela,.F.)															
			While ( !Eof() .And. xFilial("SE2") == SE2->E2_FILIAL 	.And.;
					cFornece       == SE2->E2_FORNECE 	.And.;
					cLoja          == SE2->E2_LOJA		.And.;
					cPrefixo       == SE2->E2_PREFIXO	.And.;
					cNum				== SE2->E2_NUM			.And.;
					cParcela    	== SE2->E2_PARCELA )
				If SE2->E2_TIPO $ MVABATIM .And. (nValBaix2 != 0 .Or. nValorBaix != 0)
					nTotAbat += SE2->E2_VALOR-SE2->E2_SALDO
					RecLock("SE2",.F.)
					SE2->E2_SALDO := SE2->E2_VALOR
					SE2->E2_BAIXA := Ctod("")
					MsUnLock()
				EndIf
				dbSelectArea("SE2")
				dbSkip()
			EndDo
		Endif	
		dbSelectArea("SE2")
		dbSetOrder(1)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Volta valor do titulo.  	     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nValBaix2 # 0 .Or. nValorBaix # 0 .Or. nTitDecre # 0 .Or. nTitAcres # 0 
			SE2->(dbGoTo(nRegSE2))
			nValImp 		:=	0
			aImp10925 	:=	{}		 			
			// Verifica os valores dos Txs (lei 10925) para subtrair do saldo do PA.
			If (lContrRet .Or. lIRPFBaixa) .And. SE2->E2_TIPO $ MVPAGANT+"/INA" .AND. !lPaBruto 
				aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa,SE2->E2_PARCISS)				
				
				
			ElseIf lPccBaixa .And. !lPaBruto .And. lPropPA .and. lValPgto .And. SE2->E2_TIPO $ MVPAGANT+"/INA" //Proporcionalizacao do PA. 	
				aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa,SE2->E2_PARCISS)				

			ElseIf (lContrRet .Or. lIRPFBaixa) .And. SE2->E2_TIPO $ MVPAGANT+"/INA" .AND. lPaBruto .and. !Empty(SE2->E2_TITADT)
					aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa,SE2->E2_PARCISS)				
		   	ElseIf !lPccBaixa .and.!SE2->E2_TIPO $ MVPAGANT+"/INA"  
		   			aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa,SE2->E2_PARCISS)	
			Endif  
			
			
			For nX := 1 To Len(aImp10925) 
				nValImp += aImp10925[nX][6]
			Next
			
			If ! lDebito
				AltvencImp(SE2->E2_VENCREA)
			Endif
			
			Reclock( "SE2")
			
			If lPropPA .And. SE2->E2_TIPO $ MVPAGANT+"/INA" //Proporcionalizacao do PA. 	 									
				If !lAltPa //Verificar se o saldo do PA foi alterado anteriormente.
					SE2->E2_SALDO	+= nValBaix2 		
				Endif					
			Elseif lPropPA 		
				SE2->E2_SALDO	+= nValBaix2
			Else
				SE2->E2_SALDO	+= nValBaix2
			Endif
			SE2->E2_SDDECRE += nTitDecre
			SE2->E2_SDACRES += nTitAcres
			If !(cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT+"/INA")
				SE2->E2_SALDO  += nTotAbat
			Endif	
			If cPaisLoc == "BRA"			
			   SE2->E2_VALLIQ := 0
			Else 
			   SE2->E2_VALLIQ -= nLiq
			EndIf  
			If !(SE2->E2_TIPO $ MVPAGANT+"/INA") .and. lPropPA .and.  lPrImPA 
			   	If lPccBaixa
				   	SE2->E2_VRETPIS	-= nVPis
					SE2->E2_VRETCSL	-= nVCsl
					SE2->E2_VRETCOF -= nVCof  
					If ( SE2->E2_SALDO < SE2->E2_VALOR ) // garante que o saldo seja recomposto corretamente
						SE2->E2_SALDO += ( nVPis + nVCsl + nVCof )	
					Endif
				Endif  
				If lIRPFBaixa
					SE2->E2_VRETIRF	-= nVIrf
					SE2->E2_SALDO += nVIrf
				Endif
				If lCalcIssBx 
					SE2->E2_VRETISS	-= nVIss
					SE2->E2_SALDO += nVIss
				Endif
					If SE2->(E2_VRETPIS+E2_VRETCOF+E2_VRETCSL)>0
						cPret:=FinRtPret(SE5->E5_SEQ)  
						SE2->E2_PRETPIS := cPret
						SE2->E2_PRETCOF := cPret
						SE2->E2_PRETCSL := cPret
					Else
						SE2->E2_PRETPIS := "1"
						SE2->E2_PRETCOF := "1"
						SE2->E2_PRETCSL := "1"
					EndIf
			Endif		
			If NoRound( SE2->E2_VALOR, 2 ) == NoRound( SE2->E2_SALDO, 2 )
				SE2->E2_BAIXA := CtoD(" /  /  ")
	            //Caso exista solicitacao de NCP eh necessario atualizar o campo CU_DTBAIXA... 
				If cPaisLoc <> "BRA"
					A055AtuDtBx("2",SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NUM,SE2->E2_PREFIXO,SE2->E2_BAIXA)
				EndIf				
			EndIF
			MsUnlock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de entrada para gravações complementares    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lF340FCan
				ExecBlock("F340FCAN",.f.,.f.)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava lançamento no PCO ref titulo principal apos a canc.compensacao    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PCODetLan("000017","01","FINA340")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza dados no Cadastro de Fornecedores					  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SA2")
			dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			RecLock("SA2")
			If SE2->E2_MOEDA > 1
				nValPadrao := Round(NoRound(xMoeda(SE5->E5_VALOR - Iif(nValBaix2-nValImp == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0),1,nMoeda,SE5->E5_DATA,3,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0)),3),2)
			Else
				nValPadrao := nValBaix2+nTotAbat-Iif(nValBaix2-nValImp == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0)  
			Endif
			IF SE2->E2_TIPO $ MVPAGANT+"/INA"+"/"+MV_CPNEG
				SA2->A2_SALDUP		-= nValPadrao
				SA2->A2_SALDUPM	-= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
			Else
				SA2->A2_SALDUP		+= nValPadrao
				SA2->A2_SALDUPM	+= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
			Endif
			SA2->(MsUnlock())
		Endif
		//Trata o estorno automatico do inss
		If Len(aTitINSS) <> 0
			dbSelectArea("SE2")
			SE2->(dbGoTo(nRecnoINSS))
			cFornece	:= SE2->E2_FORNECE
			cLoja       := SE2->E2_LOJA	
			cPrefixo    := SE2->E2_PREFIXO
			cNum		:= SE2->E2_NUM
			cParcela    := SE2->E2_PARCELA
		
			If !(SE2->E2_TIPO $ MV_CPNEG .or. Alltrim(SE2->E2_TIPO) $ MVPAGANT+"/INA")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Volta valor do abatimento se existir ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nTotAbat := 0
				dbSelectArea("SE2")
				dbSetOrder(6)
				dbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNum+cParcela,.F.)															
				While ( !Eof() .And. xFilial("SE2") == SE2->E2_FILIAL 	.And.;
						cFornece       == SE2->E2_FORNECE 	.And.;
						cLoja          == SE2->E2_LOJA		.And.;
						cPrefixo       == SE2->E2_PREFIXO	.And.;
						cNum		   == SE2->E2_NUM		.And.;
						cParcela       == SE2->E2_PARCELA )
					If SE2->E2_TIPO $ MVABATIM .And. (nValINSS2 != 0 .Or. nValorBaix != 0)
						nTotAbat += SE2->E2_VALOR-SE2->E2_SALDO
						RecLock("SE2",.F.)
						SE2->E2_SALDO := SE2->E2_VALOR
						SE2->E2_BAIXA := Ctod("")
						MsUnLock()
					EndIf
					dbSelectArea("SE2")
					dbSkip()
				EndDo
			Endif	
			dbSelectArea("SE2")
			dbSetOrder(1)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Volta valor do titulo.  	     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nValINSS2 # 0 .Or. nValorBaix # 0 .Or. nINSDecre # 0 .Or. nINSAcres # 0 
				SE2->(dbGoTo(nRecnoINSS))
				nValImp 		:=	0
				aImp10925 	:=	{}		 			
				// Verifica os valores dos Txs (lei 10925) para subtrair do saldo do PA.
				If (lContrRet .Or. lIRPFBaixa) .And. SE2->E2_TIPO $ MVPAGANT+"/INA" .AND. !lPaBruto //.or. (Fa340BxTx(SE2->(recno())) .and. SE5->E5_PRETPIS != '5') )
					aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa)
					
					
				ElseIf lPccBaixa .And. !lPaBruto .And. lPropPA .And. SE2->E2_TIPO $ MVPAGANT+"/INA" //Proporcionalizacao do PA. 	
					aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,.T.)		
	
				ElseIf (lContrRet .Or. lIRPFBaixa) .And. SE2->E2_TIPO $ MVPAGANT+"/INA" .AND. lPaBruto .and. !Empty(SE2->E2_TITADT)
					aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,lIRPFBaixa)
				Endif
				
				For nX := 1 To Len(aImp10925)		
					nValImp += aImp10925[nX][6]
				Next
				
				If ! lDebito
					AltvencImp(SE2->E2_VENCREA)
				Endif
				
				Reclock( "SE2")
				
				If lPropPA .And. nProp > 0 .And. SE2->E2_TIPO $ MVPAGANT+"/INA" //Proporcionalizacao do PA. 	 									
					If !lAltPa //Verificar se o saldo do PA foi alterado anteriormente.
						SE2->E2_SALDO	+= nValINSS2 - Iif(nProp>0,(nValImp*nProp),nValImp)			
					Endif					
				Else			
					SE2->E2_SALDO	+= nValINSS2 - Iif(nValINSS2-nValImp == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0)
				Endif
				SE2->E2_SDDECRE += nINSDecre
				SE2->E2_SDACRES += nINSAcres
				If !(SE2->E2_TIPO $ MV_CPNEG .or. Alltrim(SE2->E2_TIPO) $ MVPAGANT+"/INA")
					SE2->E2_SALDO  += nTotAbat
				Endif	
				If cPaisLoc == "BRA"			
				   SE2->E2_VALLIQ := 0
				EndIf   			   
				If NoRound( SE2->E2_VALOR, 2 ) == NoRound( SE2->E2_SALDO, 2 )
					SE2->E2_BAIXA := CtoD(" /  /  ")
				EndIF
				MsUnlock()
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava lançamento no PCO ref titulo principal apos a canc.compensacao    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PCODetLan("000017","01","FINA340")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza dados no Cadastro de Fornecedores					  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA2")
				dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
				RecLock("SA2")
				If SE2->E2_MOEDA > 1
					nValPadrao := Round(NoRound(xMoeda(SE5->E5_VALOR - Iif(nValINSS2-nValImp == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0),1,nMoeda,SE5->E5_DATA,3,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0)),3),2)
				Else
					nValPadrao := nValINSS2+nTotAbat-Iif(nValINSS2-nValImp == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0)  
				Endif
				IF SE2->E2_TIPO $ MVPAGANT+"/INA"+"/"+MV_CPNEG
					SA2->A2_SALDUP		-= nValPadrao
					SA2->A2_SALDUPM	-= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
				Else
					SA2->A2_SALDUP		+= nValPadrao
					SA2->A2_SALDUPM	+= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
				Endif
				SA2->(MsUnlock())
			Endif
			
		EndIf		

		SE2->(dbGoTo(nRegSE2))
		If lBxImpAut .and. !lPCCBaixa
			Fa340EstTX(aTitulos, nReg, cSeqEstorno, aKeysTx)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Final  da protecao via TTS								  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		End Transaction
		
		//Baixa Impostos e NDF - PABRUTO
		If lPABruto .and. !lNDF
			If lDebito
				Fa340BxTxPa(nReg,.T.)
			Else
				For nX := 1 to len(aRecPA)
					Fa340BxTxPa(aRecPA[nX],.T.)
				Next
			EndIf
		ElseIf lPaBruto .and. lNDF
			FA340GeraNDF(nRecNDF,,,.T.) // exclui NDF
		EndIf
		
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoFinLan("000017")
	
	Exit
	
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	If TcSrvType() != "AS/400"
        If Select("TRB") > 0
			dbSelectArea( "TRB")
			dbCloseArea()
		EndIf
	Endif
#ENDIF

UnLockCmpCP(cChvSemaf)
dbSelectArea( "SE2" )
dbSetOrder( 1 )
dbSelectArea( "SE5" )
dbSetOrder( 1 )
dbGoTo( nReg )

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340Tit	³ Autor ³ Valter G. Nogueira Jr.³ Data ³ 18/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera Tabela com os titulos 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina340																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function Fa340Tit(cNumCont,nProc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada 						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cSavArea	:= Alias()
LOCAL nSavOrd	:= IndexOrd()
LOCAL nRecNo	:= RecNo()
LOCAL nTotComp	:= 0
LOCAL lMarca	:= .F.
LOCAL nRecEmp	:= SM0->(RecNo())
LOCAL cEmpAnt	:= SM0->M0_CODIGO
LOCAL cFilDe
LOCAL cFilAte
Local nDecs		:= MsDecimais(nMoeda)
Local cCondicao
Local cOrder 	:= SE2->(IndexKey(nSavOrd)) //Considerara a ordem do browse de entrada da rotina.
Local lQuery	:= .F.
Local cCPNEG	:= MV_CPNEG
Local nX		:= 0
Local nTotAbat	:= 0
Local nSldTit	:= 0
Local nValmin	:= 0
Local lVerLibTit:= .T.
Local lAdiciona	:= .T.
Local lPaBruto	:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor
Local cCondic
Local lFinVDoc	:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
Local lPrimeiro :=.T. //identifica se o help de documentos sera gerado ou nao
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
					 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
					 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
					 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Local	nProp   := 0        
Local lPropPA 	:= SuperGetMv("MV_COMPCP",,.F.) //Verifica se vai proporcionalizar quando PA>NF e PA liquido.     
Local lValPgto := SuperGetMv("MV_BP10925",.T.,"1") == "2" //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos
Local nValLim	:= 0 
Local aAreaSe2  := SE2->(GetArea()) 
local nValComp	:= 0

//--- Tratamento Gestao Corporativa
Local lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
//
Local cFilFwSE2 := IIF( lGestao .And. FindFunction("FwFilial"), FwFilial("SE2") , xFilial("SE2") )

#IFDEF TOP
	Local aStru := SE2->(dbStruct())
	
#ELSE
	Local cIndexSe2
	Local nIndexSE2 
#ENDIF
Local aImp10925 := {}
Local nValImp   := 0

// Controla retencao de impostos da lei 10925.
Local lContrRet := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

Local lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 
LOCAL nSaldoprop := 0
//Variavel indica se irá provisionar os impostos de INSS e ISS na inclusão da PA, deduzindo-os do valor de adiantamento.
Local lPrImPA := !Empty( SE2->( FieldPos( "E2_PRINSS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRISS" ) ) ) .And. ;
				 !lPaBruto .And. SuperGetMv("MV_PAPRIME",.T.,"2") == "1"           
Local nImp:=0            
Local lContrato := .F. 		// Identifica se vai utilizar o filtro por numero de contrato
Local nVlCompOri := 0                                   
Local cAliasSE2  := ""
Local nRecAux 	:= 0
Local nSaldParc := 0
Local cEmpresa	:= FWCodEmp()
Local nRecnoSE2 := 0
Local lConsImp := IIf(SE2->E2_TIPO $ MVPAGANT+"/INA",SE2->E2_BASEPIS > SE2->E2_VALOR,.F.   ) // Considera o valor descontado do imposto se for PA e tiver retido
DEFAULT cNumCont := ""		// Numero do contrato caso o mesmo tenha sido preenchido
DEFAULT nProc := 0

lContrato := IIf(Empty(cNumCont), .F., .T.)

If "|" $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,"|","")
ElseIf "," $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,",","")
Endif    
If Mod(Len(cCPNEG),3) > 0
	cCPNEG	+=	Replicate(" ",3-Mod(Len(cCPNEG),3))
Endif	
If mv_par05 == 2
	cFilDe := cFilAnt
	cFilAte:= cFilAnt
Else
	cFilDe := mv_par06
	cFilAte:= mv_par07
Endif

If cPaisLoc <> "BRA"
	SCU->(DbSetOrder(2))
Endif
dbSelectArea("SM0")
dbSeek(cEmpAnt+IIF(!EMPTY(cFilDe),cFilDe,""),.T.)

If nProc == 0
	aTitulos := {}
	aRecNo   := {}
EndIf
Pergunte("AFI340",.F.)

IF (ExistBlock("F340LIBT"))
	lVerLibTit :=ExecBlock("F340LIBT",.f.,.f.)
Endif


While SM0->(!Eof()) .and. SM0-> M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil,  FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
	
    cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0-> M0_CODFIL )
	lUnidNeg := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
	
	If cEmpresa	<> FWCodEmp() .and. lUnidNeg
		SM0->(DbSkip())
		Loop
	Endif
	
	#IFDEF TOP
		lQuery := .T.

		cOrder	 := SqlOrder(cOrder)
		cCondicao := "SELECT "
		For nX:= 1 to Len(aStru)
			cCondicao += aStru[nX,1]+", "
		Next

		cCondicao += "R_E_C_N_O_ E2_RECNO "

		cCondicao += "  FROM "+	RetSqlName("SE2")

		cCondicao += " WHERE "

		cCondicao += " E2_FILIAL = '" + xFilial("SE2") + "' "

		IF MV_PAR02 == 1
			If nProc == 1
				cCondicao += " AND E2_FORNECE = '" + GetMV("MV_FORINSS") + Space(Len(SE2->E2_FORNECE) - Len(GetMV("MV_FORINSS"))) + "'"
			Else
				cCondicao += " AND E2_FORNECE = '" + cFornece + "'"
			EndIf
		Else
			If nProc == 1
				cCondicao += " AND E2_FORNECE = '" + GetMV("MV_FORINSS") + Space(Len(SE2->E2_FORNECE) - Len(GetMV("MV_FORINSS"))) + "'"
			Else
				cCondicao += " AND E2_FORNECE >='" + mv_par03 + "'"	
				cCondicao += " AND E2_FORNECE <='" + mv_par04 + "'"
			EndIf
		ENDIF	

		IF MV_PAR01 == 1 .And. MV_PAR02 == 1
			If nProc == 1
				cCondicao += " AND E2_LOJA = '" + PadR( "00", TamSX3("A2_LOJA")[1], "0" ) + "'"
			Else
				cCondicao += " AND E2_LOJA = '" + cLoja + "'"
			EndIf			
		ENDIF

		cCondicao += " AND E2_SALDO <> 0"
		cCondicao += " AND E2_EMIS1 <= '" + DTOS(dDatabase) + "'"	
		cCondicao += " AND E2_TIPO <> 'PR'"
				
		If cPaisLoc <> "ANG"
			cCondicao += " AND E2_ORIGEM <> 'FINA085A' "
		EndIf

		If lDebito			
			If lVerLibTit
				// controla Liberacao do titulo
				If !Empty(GetMv("MV_CTLIPAG") )
					nValmin:= GetMV("MV_VLMINPG")	
				 	cCondicao += "AND (E2_DATALIB <> ' ' OR  (E2_SALDO+E2_SDACRES-E2_SDDECRE)< " + str(nValmin)+ " )"
				EndIf
			EndIf
			
			If nProc == 1
				cCondicao += " AND E2_TIPO NOT IN " + FORMATIN("INA",,3)
			Else
				cCondicao += " AND E2_TIPO NOT IN " + FORMATIN(cCPNEG+MVPAGANT+"INA",,3)
				cCondicao += " AND E2_TIPO NOT IN " + FORMATIN(MVABATIM,'|')
			EndIf
		Else
			If mv_par10 == 1	
				If nProc == 0
					cCondicao += " AND E2_TIPO IN " + FORMATIN(cCPNEG+MVPAGANT,,3)
				ElseIf nProc == 1
					cCondicao += " AND E2_TIPO IN " + FORMATIN("INA",,3)
				Else
					cCondicao += " AND E2_TIPO IN " + FORMATIN(cCPNEG+MVPAGANT,,3)
				EndIf								
			Else  // Compensar titulos imposto
				If cTipoTit $ MVTAXA
					cCondicao += " AND E2_TIPO IN " + FORMATIN(MVTXA,,3)
				ElseIf cTipoTit $ MVINSS
					cCondicao += " AND E2_TIPO IN " + FORMATIN("INA",,3)
				ElseIf cTipoTit $ "INA"
					cCondicao += " AND E2_TIPO IN " + FORMATIN(MVINSS,,3)
				Else
					cCondicao += " AND E2_TIPO IN " + FORMATIN(MVTXA,,3)
				EndIf				
			Endif
		Endif
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para filtrar pelo MSFIL em caso de ³
		//³ arquivo compartilhado.  Titulos                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If (ExistBlock("F340FLCP"))    
			cCondicao += ExecBlock("F340FLCP",.F.,.F.)   
		Endif                    

		// Nao compensa titulos enviados ao banco (em bordero)
		If mv_par12 == 2
			cCondicao += " And  E2_NUMBOR = '" + SPACE( TamSX3("E2_NUMBOR")[1] ) + "'"	
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se houver um numero de contrato o mesmo serah verificado nas condicoes da consulta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lContrato
			cCondicao += " AND E2_MDCONTR = '" + cNumCont + "'"
		Endif       
		If !lPaBruto .AND. lPrImPA  .and. lPropPA .and. lValPgto .and. !(SE2->E2_TIPO $ MVPAGANT+"/INA") 
			If lPccBaixa
				If SE2->E2_PIS>0 
					cCondicao += " AND E2_PIS > 0 "
				Else
					cCondicao += " AND E2_PIS = 0 "  
				Endif
				If SE2->E2_COFINS>0 
					cCondicao += " AND E2_COFINS > 0 "
				Else
					cCondicao += " AND E2_COFINS = 0 "  
				Endif 
				If SE2->E2_COFINS>0 
					cCondicao += " AND E2_COFINS > 0 "
				Else
					cCondicao += " AND E2_COFINS = 0 "  
				Endif   
				If SE2->E2_CSLL>0 
					cCondicao += " AND E2_CSLL > 0 "
				Else
					cCondicao += " AND E2_CSLL = 0 "  
				Endif
			Endif
			If lIRPFBaixa 
				If SE2->E2_IRRF>0 
					cCondicao += " AND E2_IRRF > 0 "
				Else
					cCondicao += " AND E2_IRRF = 0 "  
				Endif 
			Endif
			If lCalcIssBx 
				If SE2->E2_ISS>0 
					cCondicao += " AND E2_ISS > 0 "
				Else
					cCondicao += " AND E2_ISS = 0 "  
				Endif
			Else
				If SE2->E2_ISS>0 
					cCondicao += " AND E2_PRISS > 0 "
				Else
					cCondicao += " AND E2_PRISS = 0 "  
				Endif
			Endif
		Elseif !lPaBruto .AND. lPrImPA  .and. lPropPA .and. lValPgto
			If lPccBaixa
				If SE2->E2_PIS>0 
					cCondicao += " AND E2_PIS > 0 "
				Else
					cCondicao += " AND E2_PIS = 0 "  
				Endif
				If SE2->E2_COFINS>0 
					cCondicao += " AND E2_COFINS > 0 "
				Else
					cCondicao += " AND E2_COFINS = 0 "  
				Endif 
				If SE2->E2_COFINS>0 
					cCondicao += " AND E2_COFINS > 0 "
				Else
					cCondicao += " AND E2_COFINS = 0 "  
				Endif   
				If SE2->E2_CSLL>0 
					cCondicao += " AND E2_CSLL > 0 "
				Else
					cCondicao += " AND E2_CSLL = 0 "  
				Endif
			Endif
			If lIRPFBaixa 
				If SE2->E2_IRRF>0 
					cCondicao += " AND E2_IRRF > 0 "
				Else
					cCondicao += " AND E2_IRRF = 0 "  
				Endif 
			Endif
			If lCalcIssBx 
				If SE2->E2_ISS>0 
					cCondicao += " AND E2_ISS > 0 "
				Else
					cCondicao += " AND E2_ISS = 0 "  
				Endif
			Else
				If SE2->E2_PRISS>0 
					cCondicao += " AND E2_ISS > 0 "
				Else
					cCondicao += " AND E2_ISS = 0 "  
				Endif
			Endif
		Endif
		
		cCondicao += " AND D_E_L_E_T_ <> '*' "	

		cCondicao += " ORDER BY "+ SqlOrder(cOrder)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para filtrar a selecao dos titulos ³
		//³ que serao compensados - ambiente TOP                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (ExistBlock("F340FCPTOP"))    
			cCondicao := ExecBlock("F340FCPTOP",.F.,.F.,{cCondicao})   
		Endif  		
		
		cCondicao := ChangeQuery(cCondicao)
		
		dbSelectArea("SE2")
		dbCloseArea()
		dbSelectArea("SA2") 

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cCondicao), '__SUBS', .F., .T.)

		For nX := 1 to Len(aStru)
			If aStru[nX,2] != 'C'
				TCSetField('__SUBS', aStru[nX,1], aStru[nX,2],aStru[nX,3],aStru[nX,4])
			Endif
		Next
		

		cAliasSE2 := "__SUBS"
		__SUBS->( DBGoTop() )	
		
   #ELSE
		lQuery := .F.

		cCondicao := 'E2_FILIAL=="' + xFilial('SE2') + '"'
		IF MV_PAR02 == 1
			If nProc == 1
				cCondicao += '.And.E2_FORNECE=="' + GetMV("MV_FORINSS") + Space(Len(SE2->E2_FORNECE) - Len(GetMV("MV_FORINSS"))) + '"'
			Else
				cCondicao += '.And.E2_FORNECE=="' + cFornece + '"'
			EndIf
		ElseIf MV_PAR02 == 2
			If nProc == 1
				cCondicao += '.And.E2_FORNECE=="' + GetMV("MV_FORINSS") + Space(Len(SE2->E2_FORNECE) - Len(GetMV("MV_FORINSS"))) + '"'
			Else
				cCondicao += '.And.E2_FORNECE>="' + Mv_Par03 + '"'	
				cCondicao += '.And.E2_FORNECE<="' + Mv_Par04 + '"'
			EndIf
		ENDIF	
		IF MV_PAR01 == 1 .And. MV_PAR02 == 1
			If nProc == 1
				cCondicao += '.And.E2_LOJA=="' + PadR( "00", TamSX3("A2_LOJA")[1], "0" ) + '"'
			Else
				cCondicao += '.And.E2_LOJA=="' + cLoja + '"'
			EndIf			
		ENDIF
		cCondicao += '.And.E2_SALDO<>0'
		cCondicao += '.And.DTOS(E2_EMIS1)<="' + DTOS(dDatabase) + '"'		
		cCondicao += '.And.E2_TIPO<>"PR"'

		If lDebito
			If lVerLibTit
				// controla Liberacao do titulo
				If !Empty(GetMv("MV_CTLIPAG") )
					nValmin:= GetMV("MV_VLMINPG")	
				 	cCondicao += '.And. (!Empty(E2_DATALIB).Or. (E2_SALDO+E2_SDACRES-E2_SDDECRE)> ' + str(nValmin) + ')'
				EndIf
			EndIf
			
			If nProc == 1
				cCondicao += '.And.!(E2_TIPO$"' + 'INA' + '")'	
			Else
				cCondicao += '.And.!(E2_TIPO$"' + MV_CPNEG + '/' + MVPAGANT + '/' + MVABATIM + '")'
			EndIf
		Else
			If mv_par10 == 1
				If nProc == 0
					cCondicao += '.And.(E2_TIPO$"'+ MV_CPNEG + '/' + MVPAGANT + '")'
				ElseIf nProc == 1
					cCondicao += '.And.(E2_TIPO$"' + "INA" + '")'	
				Else
					cCondicao += '.And.(E2_TIPO$"'+ MV_CPNEG + '/' + MVPAGANT + '")'
				EndIf								
			Else	// Compensar titulos imposto
				If cTipoTit $ MVTAXA
					cCondicao += '.And.(E2_TIPO$"' + MVTXA + '")'	
				ElseIf cTipoTit $ MVINSS
					cCondicao += '.And.(E2_TIPO$"' + 'INA' + '")'	
				ElseIf cTipoTit $ 'INA'
					cCondicao += '.And.(E2_TIPO$"' + MVINSS + '")'	
				Else
					cCondicao += '.And.(E2_TIPO$"' + MVTXA + '")'	
				EndIf
			Endif
		Endif
		
		// Nao compensa titulos enviados ao banco (em bordero)
		If mv_par12 == 2 .and. !Empty(SE2->E2_NUMBOR)
			cCondicao += ' .And. E2_NUMBOR == "' + SPACE( TamSX3("E2_NUMBOR")[1] ) + '"'	
		Endif  

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se houver um numero de contrato o mesmo serah verificado nas condicoes da consulta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lContrato
			cCondicao += ' .AND. E2_MDCONTR = "' + cNumCont + '"'
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para filtrar a selecao dos titulos ³
		//³ que serao compensados - ambiente Codebase           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (ExistBlock("F340FCPBAS"))    
			cCondicao := ExecBlock("F340FCPBAS",.F.,.F.,{cCondicao})   
		Endif  		
		
		DBSelectArea("SE2")
		cIndexSe2 := CriaTrab(nil,.f.)
		IndRegua("SE2",cIndexSe2,cOrder,,cCondicao,STR0033) // "Selecionanto Registros..."
		nIndexSE2 := RetIndex("SE2")
		dbSetIndex(cIndexSe2+OrdBagExt())
		dbSetOrder(nIndexSe2+1)
		
		cAliasSE2 := "SE2"    	
    	SE2->( DBGoTop() )
    	
	#ENDIF

	WHILE (cAliasSE2)->( !Eof() ) .and. (cAliasSE2)->E2_FILIAL == xFilial("SE2")
		nRecnoSE2 := If(lQuery,(cAliasSE2)->E2_RECNO , (cAliasSE2)->(RecNo()))
		If !lPaBruto .AND. lPrImPA  .and. lPropPA .and. lValPgto .and. !((cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA") 
			If SED->(MsSeek(xFilial("SED")+(cAliasSE2)->E2_NATUREZ)) .and. !Empty( SED->( FieldPos( "ED_RINSSPA" ) ) ) .And. SED->ED_RINSSPA == '1'
				If (cAliasSE2)->E2_INSS = 0 
					(cAliasSE2)->( dbSkip() )
					Loop		
				Endif
			EndIf
		Elseif !lPaBruto .AND. lPrImPA  .and. lPropPA .and. lValPgto
			If SED->(MsSeek(xFilial("SED")+(cAliasSE2)->E2_NATUREZ)) .and. !Empty( SED->( FieldPos( "ED_RINSSPA" ) ) ) .And. SED->ED_RINSSPA == '1'
				If (cAliasSE2)->E2_INSS = 0 
					(cAliasSE2)->( dbSkip() )
					Loop		
				Endif
			EndIf
		EndIf
		// Zero a variavel que soma os impostos (lei 10925)do titulo.
		nValImp := 0
		nImp	:= 0  
		nValLim := 0
		nValComp := 0
		If lFina340
			lRet := Execblock("FA340FILT",.F.,.F.,{nRecno})
			If !lRet
				(cAliasSE2)->( dbSkip() )
				Loop
			Endif
		Endif

		//ANGOLA|BRASIL - Nao permitir compensar titulos de adiantamento relacionados a pedido
		#IFDEF TOP
			If cPaisLoc $ "ANG|BRA|MEX" .and. AliasInDic("FIE")
				FIE->(dbSetOrder(3))
				If FIE->(MsSeek(xFilial("FIE")+"P"+(cAliasSE2)->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)))
					(cAliasSE2)->( dbSkip() )
					Loop
				Endif
				// se for o titulo pricipal, procura na tabela FR3
				If cPaisLoc $ "BRA|MEX" .and. AliasInDic("FR3") .and. (cAliasSE2)->E2_TIPO = MVNOTAFIS
					FR3->(dbSetOrder(3))
					If FR3->(MsSeek(xFilial("FR3")+"P"+(cAliasSE2)->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)))
						(cAliasSE2)->( dbSkip() )
						Loop
					Endif	
				Endif
			Endif	
		#ENDIF	

		// Caso controle retencao de impostos da lei 10925 e caso seja PA, efetua
		// varredura dos impostos para compor o valor principal a ser usado na compensacao.
		If (lContrRet .Or. lIRPFBaixa) .And. (cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA"        
		
			aImp10925 := TxLei10925((cAliasSE2)->E2_PREFIXO,(cAliasSE2)->E2_NUM,(cAliasSE2)->E2_PARCELA,(cAliasSE2)->E2_PARCPIS,(cAliasSE2)->E2_PARCCOF,(cAliasSE2)->E2_PARCSLL,,(cAliasSE2)->E2_PARCIR,lIRPFBaixa,(cAliasSE2)->E2_PARCISS)				
				
			For nX := 1 To Len(aImp10925)  
				nValImp += aImp10925[nX][6]
			Next
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso esteja ligado o controle de solicitacao de notas de credito e exista alguma ³
		//³ pendencia para este titulo                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If cPaisLoc	<> "BRA"
			SCU->(DbSetOrder(2))
		EndIf
		
		If cPaisLoc	<> "BRA" .and. GetMv('MV_SOLNCP') .And. (cAliasSE2)->E2_TIPO == MVNOTAFIS ;
					.And. SCU->(MsSeek( xFilial()+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA+(cAliasSE2)->E2_NUM+(cAliasSE2)->E2_PREFIXO )).And. Empty(SCU->CU_NCRED)
				//HELP(" ",1,"SOLNCPAB")
				lMarca   := .F.
				nValComp := 0
		ElseIf nTotComp < nValor .or. ( nValor == 0 .And. nTotComp < nSaldo )

			lMarca   := .T.

			
			If cPaisLoc == "BRA"			
			   	If lPccBaixa .or. lIRPFBaixa  .or. lCalcIssBx
					If !lPaBruto .And. (cAliasSE2)->E2_BASEPIS > 0 .And. lPropPA .and. lValPgto .and. (cAliasSE2)->E2_TIPO == MVPAGANT+"/INA"  .and. (cAliasSE2)->E2_VALOR <> (cAliasSE2)->E2_SALDO;
						.and. ((cAliasSE2)->E2_PIS > 0 .OR. (cAliasSE2)->E2_COFINS > 0 .OR. (cAliasSE2)->E2_CSLL > 0 .OR. (cAliasSE2)->E2_IRRF > 0)
					  	nProp	:= ((cAliasSE2)->E2_SALDO/(cAliasSE2)->E2_VALOR) 
						If nProp <1
							nProp	:= 	1- nProp     
						Endif

				   	ElseIf lPropPA .and. (cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA" .and. lValPgto
						 nProp	:= (cAliasSE2)->E2_SALDO / ((cAliasSE2)->E2_VALOR - IIf(!lCalcIssBx,(cAliasSE2)->E2_PRINSS + (cAliasSE2)->E2_PRISS,0))
					Elseif ((cAliasSE2)->E2_PIS+(cAliasSE2)->E2_COFINS+ (cAliasSE2)->E2_CSLL+ (cAliasSE2)->E2_IRRF) == 0 .and. lCalcIssBx .and.!((cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA")  
 						nSaldoProp:= F340CompSal(nRecnoSE2,.F.)
					  	nProp	:=	(nSaldoProp/(cAliasSE2)->E2_ISS)
						nImp:= (cAliasSE2)->E2_ISS
					Else
						nSaldoProp:= F340CompSal(nRecnoSE2,.T.)
					  	nProp	:=	(nSaldoProp/(cAliasSE2)->E2_BASEPIS)
						nImp:= If(lPccBaixa .and. lConsImp,(cAliasSE2)->E2_PIS+(cAliasSE2)->E2_COFINS+(cAliasSE2)->E2_CSLL,0)+ If(lIRPFBaixa,(cAliasSE2)->E2_IRRF,0)+If(lCalcIssBx,(cAliasSE2)->E2_ISS,0)
					Endif                                      
				EndIf
				nSldTit	:=	xMoeda((cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE,;
																(cAliasSE2)->E2_MOEDA,;
																nMoeda,;
																,;
																5	,;
																If(nMoeda        == 1,Fa340TxMd((cAliasSE2)->E2_MOEDA,(cAliasSE2)->E2_TXMOEDA),Fa340TxMd((cAliasSE2)->E2_MOEDA,nTxMoeda  ));
																,If((cAliasSE2)->E2_MOEDA == 1,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,(cAliasSE2)->E2_TXMOEDA)))
				If !lPaBruto 
		   			nValComp := IIF (nValor-nTotComp > nSldTit .or. nValor == 0,nSldTit + Iif((cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA",nImp,nValImp),nValor-nTotComp)
				Else
		   			nValComp := IIF (nValor-nTotComp > nSldTit .or. nValor == 0,nSldTit ,nValor-nTotComp)
		   		Endif
			ElseIf cPaisLoc == "BOL"
				// Calcula nSldTit e nValComp com cinco casas decimais, devido a erro de arredondamento 
				// na funcao FA340MOV, somente para Bolivia.
				nSldTit	:=	xMoeda((cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE ,(cAliasSE2)->E2_MOEDA,nMoeda,dDatabase,5,aTxMoedas[E2_MOEDA][2],aTxMoedas[nMoeda][2])
				nValComp := IIF (nValor-nTotComp > nSldTit .or. nValor == 0,nSldTit,nValor-nTotComp)
			Else 			
				nSldTit  := Round(xMoeda((cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE ,(cAliasSE2)->E2_MOEDA,nMoeda,dDatabase,nDecs+1,aTxMoedas[E2_MOEDA][2],aTxMoedas[nMoeda][2]),nDecs)
			    nValComp := IIF(nValor-nTotComp > nSldTit .or. nValor == 0,nSldTit,nValor-nTotComp)			
			EndIf			   			   

			//Pa Bruto nao resoma impostos
			If nValor-nTotComp > nSldTit //.or. nValor == 0 .and. lPaBruto 
				nValComp -= nValImp
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PONTO DE ENTRADA F340CMP                                      ³
			//³ Tratamento de valor a ser compensado em determinado titulo    ³
			//³ permitindo que o usuario possa calcular o valor do titulo NDF ³
			//³ ou PA a ser compensado.                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF ExistBlock("F340CMP")
				nValComp:= ExecBlock("F340CMP",.F.,.F.)
			Endif
			nTotComp += nValComp
			nVlCompOri := nValComp
		Else
			lMarca   := .F.
			IF  nValor == 0 .And. nTotComp > nSaldo 
				nValComp := 0
			EndIf
		EndIf
		If cPaisLoc == "BRA"		
			lAdiciona := .T.
			// Nao somo abatimentos, se o titulo for de debito
			If !((cAliasSE2)->E2_TIPO $ MV_CPNEG + "/" + MVPAGANT+"/INA") .and. !ldebito
				nTotAbat := SomaAbat((cAliasSE2)->E2_PREFIXO,(cAliasSE2)->E2_NUM,(cAliasSE2)->E2_PARCELA,"P",(cAliasSE2)->E2_MOEDA,,(cAliasSE2)->E2_FORNECE)
			Else
				nTotAbat := 0	
				SEF->(DbSetOrder(3))
				SEF->(MsSeek(xFilial("SEF")+(cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+Pad(E2_NUMBCO,Len(SEF->EF_NUM)))))
				
				If mv_par01 = 1 .And. mv_par02 = 1
					//Considera Loja e Fornecedor Original.
					cCondic := cAliasSE2+'->E2_FORNECE == SEF->EF_FORNECE .And. '+cAliasSE2+'->E2_LOJA == SEF->EF_LOJA .And. SEF->EF_LIBER == "N"'
				Elseif (mv_par01 = 2 .And. mv_par02 = 1) .Or. (mv_par02 = 2)
					//Não considera Loja e considera o Fornecedor Original ou então apenas considera Outros Fornecedores.
					cCondic := cAliasSE2+'->E2_FORNECE == SEF->EF_FORNECE .And. SEF->EF_LIBER == "N"'
				Else
					cCondic := 'SEF->EF_LIBER == "N"'
				Endif
				
				While SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_NUM)==(cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+Pad(E2_NUMBCO,Len(SEF->EF_NUM)) ) .and. !SEF->(Eof())
					//Verifica se ha cheques nao liberados.
					If &cCondic
						lAdiciona := .F.
						Exit 
					Endif					
					SEF->(dbSkip())
				EndDo
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica PA se tem movimento no SE5 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ((cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA")
					nRecAux := (cAliasSE2)->( Recno() )
					dbSelectArea("SE2") 
					dbSetOrder(1)
					dbSeek(xFilial("SE2")+(cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))					
					lAdiciona := FA340VerPA()
					RestArea(aAreaSE2)
					dbSelectArea(cAliasSE2)
					dbGoto(nRecAux)
					If !lAdiciona
						nTotComp-=nValComp
					Endif
				Endif
			Endif
			If nSaldParc == 0
				nSaldParc := nSaldo
			Endif
 			If lPccBaixa .or. lIRPFBaixa .or. lCalcIssBx
				If !lPaBruto .And. (cAliasSE2)->E2_BASEPIS > 0 .And. lPropPA .and. lValPgto.and. (cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA"  .and. (cAliasSE2)->E2_VALOR <> (cAliasSE2)->E2_SALDO;
			  		.and. ((cAliasSE2)->E2_PIS > 0 .OR. (cAliasSE2)->E2_COFINS > 0 .OR. (cAliasSE2)->E2_CSLL > 0 .OR. (cAliasSE2)->E2_IRRF > 0)
			  		
				   	nProp	:= (cAliasSE2)->E2_SALDO / ((cAliasSE2)->E2_VALOR - IIf(!lCalcIssBx,(cAliasSE2)->E2_PRINSS + (cAliasSE2)->E2_PRISS,0)) 
					If nProp <1
						nProp	:= 	1- nProp     
					Endif
				ElseIf lPropPA .and. (cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA"  .and. lValPgto
			  		nProp	:= ((cAliasSE2)->E2_SALDO/(cAliasSE2)->E2_VALOR)  
				Elseif ((cAliasSE2)->E2_PIS+(cAliasSE2)->E2_COFINS+ (cAliasSE2)->E2_CSLL+ (cAliasSE2)->E2_IRRF) == 0 .and. lCalcIssBx .and. !((cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA")  
					nSaldoProp:= F340CompSal(nRecnoSE2,.F.)
				  	nProp	:=	(nSaldoProp/(cAliasSE2)->E2_ISS)
					nImp:= (cAliasSE2)->E2_ISS
			  	Elseif lPropPA
					nSaldoProp:= F340CompSal(nRecnoSE2, .T.)
				  	nProp	:=	(nSaldoProp/(cAliasSE2)->E2_BASEPIS) 
					nImp:= If(lPccBaixa,(cAliasSE2)->E2_PIS+(cAliasSE2)->E2_COFINS+(cAliasSE2)->E2_CSLL,0)+ If(lIRPFBaixa,(cAliasSE2)->E2_IRRF,0)+If(lCalcIssBx,(cAliasSE2)->E2_ISS,0)
				Endif
				If lPropPA .and. lValPgto .and. !lPaBruto .and. lPrImPA  .and. ((cAliasSE2)->E2_PIS>0 .or. (cAliasSE2)->E2_COFINS>0 .or. (cAliasSE2)->E2_CSLL>0 .or. (cAliasSE2)->E2_IRRF>0) .and. (cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA"
					nValLim:= F340LimCmp(nRecno,(cAliasSE2)->E2_BASEPIS,(cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),(cAliasSE2)->E2_PIS,(cAliasSE2)->E2_COFINS,(cAliasSE2)->E2_CSLL,(cAliasSE2)->E2_IRRF,(cAliasSE2)->E2_ISS,(cAliasSE2)->E2_SALDO) //valor limite de compensação
					If (cAliasSE2)->E2_MOEDA <> nMoeda .and. (cAliasSE2)->E2_MOEDA == 1
				   		nValLim := xMoeda(nValLim,(cAliasSE2)->E2_MOEDA,nMoeda,,5)
				   	EndIf 
				Else  
					If nSaldo < (cAliasSE2)->E2_SALDO .OR. nValComp==0
				   		nValLim:= F340LimCmp(nRecno,(cAliasSE2)->E2_BASEPIS,(cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),(cAliasSE2)->E2_PIS,(cAliasSE2)->E2_COFINS,(cAliasSE2)->E2_CSLL,(cAliasSE2)->E2_IRRF,(cAliasSE2)->E2_ISS,(cAliasSE2)->E2_SALDO) //valor limite de compensação
				   		If (cAliasSE2)->E2_MOEDA <> nMoeda .and. (cAliasSE2)->E2_MOEDA == 1
				   			nValLim := xMoeda(nValLim,(cAliasSE2)->E2_MOEDA,nMoeda,,5)
				   		EndIf   
					Elseif nValComp>(cAliasSE2)->E2_SALDO //Indica que o titulo foi baixado parcialmente
						nValLim:=If(!((cAliasSE2)->E2_TIPO $ MVPAGANT+"/INA") ,((cAliasSE2)->E2_SALDO+ (cAliasSE2)->E2_SDACRES - (cAliasSE2)->E2_SDDECRE)-(nImp*nProp),((cAliasSE2)->E2_SALDO + (cAliasSE2)->E2_SDACRES - (cAliasSE2)->E2_SDDECRE))
					Else
						nValLim:= nValComp
					Endif
				Endif    				
				If (cAliasSE2)->E2_MOEDA <> nMoeda .And. (cAliasSE2)->E2_MOEDA <> 1//.And. nValComp > (cAliasSE2)->E2_SALDO
					nValLim := xMoeda(nValLim+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE-nTotAbat,(cAliasSE2)->E2_MOEDA,nMoeda,,nDecs+1, If(nMoeda== 1,Fa340TxMd((cAliasSE2)->E2_MOEDA,(cAliasSE2)->E2_TXMOEDA),Fa340TxMd((cAliasSE2)->E2_MOEDA,nTxMoeda )))
				Endif				
				If nValLim>0  
					If nValLim>nSaldo
						nValLim:=nSaldo
					Endif
					If ( nMoeda > 1 ) .and. ( nValComp > 0 ) .and. ( nValLim > nValComp )
						nValLim := nValComp
					ElseIf nValComp>0 .AND. nValor==0
						nValComp:=nValLim
					Endif
				Endif
			Endif   
			//Tratamento para compensar PA x NF e PA x NF em moedas diferentes  (PCC na emissão)
			If nValLim==0 .and. !lPccBaixa .and. (cAliasSE2)->E2_MOEDA <> nMoeda .and. (cAliasSE2)->E2_MOEDA <> 1      // NF
				nValLim := xMoeda((cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE-nTotAbat,(cAliasSE2)->E2_MOEDA,nMoeda,,nDecs+1, If(nMoeda== 1,Fa340TxMd((cAliasSE2)->E2_MOEDA,(cAliasSE2)->E2_TXMOEDA),Fa340TxMd((cAliasSE2)->E2_MOEDA,nTxMoeda )))
			Endif 
			If !lPccBaixa .and. (cAliasSE2)->E2_MOEDA <> nMoeda .and. nSaldo < nValComp .and. nValLim == 0            // PA
				nValLim:= F340LimCmp(nRecno,(cAliasSE2)->E2_BASEPIS,(cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),(cAliasSE2)->E2_PIS,(cAliasSE2)->E2_COFINS,(cAliasSE2)->E2_CSLL,(cAliasSE2)->E2_IRRF,(cAliasSE2)->E2_ISS,(cAliasSE2)->E2_SALDO) //valor limite de compensação			
		   		If (cAliasSE2)->E2_MOEDA <> nMoeda .and. (cAliasSE2)->E2_MOEDA == 1
		   			nValLim := xMoeda(nValLim,(cAliasSE2)->E2_MOEDA,nMoeda,,5)
		   		EndIf  				
		    ElseIf nValComp>0 .AND. nValor==0 .AND. !lPccBaixa .and. nSaldo >= nValComp .and. nValLim == 0       // PA
				nValLim:= F340LimCmp(nRecno,(cAliasSE2)->E2_BASEPIS,(cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),(cAliasSE2)->E2_PIS,(cAliasSE2)->E2_COFINS,(cAliasSE2)->E2_CSLL,(cAliasSE2)->E2_IRRF,(cAliasSE2)->E2_ISS,(cAliasSE2)->E2_SALDO) //valor limite de compensação			
		   		If (cAliasSE2)->E2_MOEDA <> nMoeda .and. (cAliasSE2)->E2_MOEDA == 1
		   			nValLim := xMoeda(nValLim,(cAliasSE2)->E2_MOEDA,nMoeda,,5)
		   		EndIf  						    
			Endif			
			If nValLim==0
				If (cAliasSE2)->E2_SALDO>=nSaldo
					nValLim	:= nSaldo   
					nValComp:= If(lMarca,nSaldo,nValComp)
				Else
					nValLim	:= (cAliasSE2)->E2_SALDO - (cAliasSE2)->E2_SDDECRE + (cAliasSE2)->E2_SDACRES
			   		nValComp:= If(lMarca,(cAliasSE2)->E2_SALDO - (cAliasSE2)->E2_SDDECRE + (cAliasSE2)->E2_SDACRES,nValComp)
				Endif
				If (cAliasSE2)->E2_MOEDA <> nMoeda .and. (cAliasSE2)->E2_MOEDA == 1
				   	nValLim := xMoeda(nValLim,(cAliasSE2)->E2_MOEDA,nMoeda,,5)
				ElseIf (cAliasSE2)->E2_MOEDA <> nMoeda .And. (cAliasSE2)->E2_MOEDA <> 1//.And. nValComp > (cAliasSE2)->E2_SALDO
					nValLim := xMoeda(nValLim+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE-nTotAbat,(cAliasSE2)->E2_MOEDA,nMoeda,,nDecs+1, If(nMoeda== 1,Fa340TxMd((cAliasSE2)->E2_MOEDA,(cAliasSE2)->E2_TXMOEDA),Fa340TxMd((cAliasSE2)->E2_MOEDA,nTxMoeda )))
				Endif	
			Endif          
			If nSaldParc < nValComp
				nValComp := nSaldParc
			Endif
			nSaldParc -= nValComp
 			If lAdiciona .and. (MV_PAR10 == 2 .or. nProc == 1)
				lAdiciona := IF((cAliasSE2)->E2_TIPO $ MVINSS,F340ForINA( (cAliasSE2)->E2_TITPAI , If(nProc==1,cTitPaiINS,cTitPai)),F340ForINA( If(nProc==1,cTitPaiINS,cTitPai), (cAliasSE2)->E2_TITPAI ))
				If !lAdiciona
					nTotComp -= nVlCompOri
				EndIf
			EndIf
			If lAdiciona
				If nProc == 1
					Aadd(aTitINSS,{(cAliasSE2)->E2_PREFIXO,;
				   					(cAliasSE2)->E2_NUM,;
					   				(cAliasSE2)->E2_PARCELA,;
				   					(cAliasSE2)->E2_TIPO,;
				   					Transform(Round(NoRound(xMoeda((cAliasSE2)->E2_SALDO-Iif(nProp>0,(nImp*nProp),0)+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE-nTotAbat,(cAliasSE2)->E2_MOEDA,nMoeda,,nDecs+1	,If(nMoeda        == 1,Fa340TxMd((cAliasSE2)->E2_MOEDA,(cAliasSE2)->E2_TXMOEDA),Fa340TxMd((cAliasSE2)->E2_MOEDA,nTxMoeda        ));
											,If((cAliasSE2)->E2_MOEDA == 1,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,(cAliasSE2)->E2_TXMOEDA))),nDecs+1),nDecs),"@E 9999,999,999.99"),;
				   					Transform(nValComp-If(nValor<=0,nTotAbat,0),"@E 9999,999,999.99"),;
				   					(cAliasSE2)->E2_NOMFOR,;
				   					lMarca,;
				   					nValComp-If(nValor<=0,nTotAbat,0),;
									Transform(xMoeda((cAliasSE2)->E2_SDACRES,(cAliasSE2)->E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
									Transform(xMoeda((cAliasSE2)->E2_SDDECRE,(cAliasSE2)->E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
									(cAliasSE2)->E2_EMISSAO,;
	  								(cAliasSE2)->E2_VENCREA,;
	  		   						(cAliasSE2)->E2_FORNECE,;
	  								(cAliasSE2)->E2_LOJA,;
	  								(cAliasSE2)->E2_FILIAL,;
									(nImp*nProp),;
			   				  		Round(NoRound(xMoeda((cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_SDACRES -(cAliasSE2)->E2_SDDECRE-nTotAbat,(cAliasSE2)->E2_MOEDA,nMoeda,,nDecs+1	,If(nMoeda        == 1,Fa340TxMd((cAliasSE2)->E2_MOEDA,(cAliasSE2)->E2_TXMOEDA),Fa340TxMd((cAliasSE2)->E2_MOEDA,nTxMoeda        ));
			   							,If((cAliasSE2)->E2_MOEDA == 1,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,(cAliasSE2)->E2_TXMOEDA))),nDecs+1),nDecs),;
	  		   			      		nImp,;
	  		   			      		(cAliasSE2)->E2_BASEPIS,;
	  		   			      		nValLim,;
	  		   			      		Transform(xMoeda(nValLim,(cAliasSE2)->E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
	  		   			      		(cAliasSE2)->E2_VALOR})
					Aadd(aRecNoINSS,nRecnoSE2)
	  			Else
					Aadd(aTitulos,{(cAliasSE2)->E2_PREFIXO,;
			   						(cAliasSE2)->E2_NUM,;
				   					(cAliasSE2)->E2_PARCELA,;
			   						(cAliasSE2)->E2_TIPO,;
			   						Transform(Round(NoRound(xMoeda((cAliasSE2)->E2_SALDO+IIf(!lPABruto,(nValImp * nProp),0)+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE-nTotAbat,(cAliasSE2)->E2_MOEDA,nMoeda,,nDecs+1	,If(nMoeda        == 1,Fa340TxMd((cAliasSE2)->E2_MOEDA,(cAliasSE2)->E2_TXMOEDA),Fa340TxMd((cAliasSE2)->E2_MOEDA,nTxMoeda )),; //Saldo
			   						If((cAliasSE2)->E2_MOEDA == 1,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,(cAliasSE2)->E2_TXMOEDA))),nDecs+1),nDecs),"@E 9999,999,999.99"),;
			   						Transform(nValComp-If(nValor<=0,nTotAbat,0),"@E 9999,999,999.99"),; // Valor compensado
			   						(cAliasSE2)->E2_NOMFOR,;
			   						lMarca,;
			   						nValComp-If(nValor<=0,nTotAbat,0),;//Limite de compensacao
								   	Transform(xMoeda((cAliasSE2)->E2_SDACRES,(cAliasSE2)->E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
								   	Transform(xMoeda((cAliasSE2)->E2_SDDECRE,(cAliasSE2)->E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
	  		   			      		(cAliasSE2)->E2_EMISSAO,;
	  		   			      		(cAliasSE2)->E2_VENCREA,;
	  		   			      		(cAliasSE2)->E2_FORNECE,;
	  		   			      		(cAliasSE2)->E2_LOJA,;
	  		   			      		(cAliasSE2)->E2_FILIAL,;
	  		   			      		(nImp*nProp),;
			   				  		Round(NoRound(xMoeda((cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_SDACRES -(cAliasSE2)->E2_SDDECRE-nTotAbat,(cAliasSE2)->E2_MOEDA,nMoeda,,nDecs+1	,If(nMoeda        == 1,Fa340TxMd((cAliasSE2)->E2_MOEDA,(cAliasSE2)->E2_TXMOEDA),Fa340TxMd((cAliasSE2)->E2_MOEDA,nTxMoeda        ));
			   							,If((cAliasSE2)->E2_MOEDA == 1,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,(cAliasSE2)->E2_TXMOEDA))),nDecs+1),nDecs),;
	  		   			      		nImp,;
	  		   			      		(cAliasSE2)->E2_BASEPIS,;
	  		   			      		nValLim,;
	  		   			      		Transform(nValLim,"@E 9999,999,999.99"),; // Transform(xMoeda(nValLim,(cAliasSE2)->E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
	  		   			      		(cAliasSE2)->E2_VALOR})
					Aadd(aRecNo,nRecnoSE2)
				EndIf
			Endif
		Else
			If cPaisLoc == "BOL"               
				// Adiciona nValComp ao final do vetor devido a erro de arredondamento na funcao FA340MOV, somente para Bolivia.
				Aadd(aTitulos,{(cAliasSE2)->E2_PREFIXO,;
			   					(cAliasSE2)->E2_NUM,;
	   							(cAliasSE2)->E2_PARCELA,;
	   							(cAliasSE2)->E2_TIPO,;
			   					Transform(Round(xMoeda((cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE,(cAliasSE2)->E2_MOEDA,nMoeda,E2_EMISSAO,nDecs+1,aTxMoedas[(cAliasSE2)->E2_MOEDA][2],aTxMoedas[nMoeda][2]),nDecs),"@E 9999,999,999.99"),;
			   					Transform(nValComp,"@E 9999,999,999.99"),;
			   					(cAliasSE2)->E2_NOMFOR,;
			   					lMarca,;
								(cAliasSE2)->E2_MOEDA,;
				   				(cAliasSE2)->E2_EMISSAO,;
								Transform(xMoeda((cAliasSE2)->E2_SDACRES,(cAliasSE2)->E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
								Transform(xMoeda((cAliasSE2)->E2_SDDECRE,(cAliasSE2)->E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
								nValComp,;
								(cAliasSE2)->E2_FORNECE,;
								(cAliasSE2)->E2_LOJA,;
								(cAliasSE2)->E2_FILIAL})
			Else
				Aadd(aTitulos,{(cAliasSE2)->E2_PREFIXO,;
			   					(cAliasSE2)->E2_NUM,;
			   					(cAliasSE2)->E2_PARCELA,;
			   					(cAliasSE2)->E2_TIPO,;
			   					Transform(Round(xMoeda((cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE,(cAliasSE2)->E2_MOEDA,nMoeda,(cAliasSE2)->E2_EMISSAO,nDecs+1,aTxMoedas[E2_MOEDA][2],aTxMoedas[nMoeda][2]),nDecs),"@E 9999,999,999.99"),;
			   					Transform(nValComp,"@E 9999,999,999.99"),;
			   					(cAliasSE2)->E2_NOMFOR,;
			   					lMarca,;
			   					(cAliasSE2)->E2_MOEDA,;
			   					(cAliasSE2)->E2_EMISSAO,;
								Transform(xMoeda((cAliasSE2)->E2_SDACRES,(cAliasSE2)->E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
								Transform(xMoeda((cAliasSE2)->E2_SDDECRE,(cAliasSE2)->E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
								(cAliasSE2)->E2_FORNECE,;
								(cAliasSE2)->E2_LOJA,;
								(cAliasSE2)->E2_FILIAL})
			EndIf
			Aadd(aRecNo,nRecnoSE2)
		EndIf	  		   
		
		(cAliasSE2)->( DBSkip() )
		
	EndDo
	#IFNDEF TOP
		dbSelectArea("SE2")
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
	#ELSE
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSelectArea("SE2")
		dbSetOrder(1)
	#ENDIF
	
	dbSelectArea("SM0")
	dbSkip()
	If Empty( cFilFwSE2 )
		EXIT
	Endif    
	#IFDEF TOP 
		If TcSrvType() != "AS/400" .AND. SELECT("__SUBS") > 0
			dbSelectArea("__SUBS")
			dbCloseArea()
   		Endif
	#ENDIF				
EndDo

#IFDEF TOP 
	If TcSrvType() != "AS/400" .AND. SELECT("__SUBS") > 0
		dbSelectArea("__SUBS")
		dbCloseArea()
	Endif
#ENDIF	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SM0")
dbGoto(nRecEmp)
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza valor total dos t¡tulos - Windows	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValTot := 0
For nX := 1 to Len(aTitulos)
	If aTitulos[nX,8]
		If F340Semaforo(aTitulos[nX],.T.,aRecno[nX],,,,.F.)
			nValtot += Fa340VTit(aTitulos[nX,6])
		Else
			aTitulos[nX,8] := .F.
		Endif
	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validação dos documentos obrigatórios	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFinVDoc
	FA340ValDocs(aTitulos,.T.,,.T.,@lPrimeiro)
EndIf

dbSelectArea(cSavArea)
dbSetOrder(nSavOrd)
dbgoto(nRecNo)

Return aTitulos

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340VTit ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 14/01/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o saldo ou valor do titulo a ser compensado		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina340																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function Fa340VTit(aTitulo,cTipoTit,cValor)
LOCAL nValor
cValor := IIF (cValor == NIL,aTitulo,cValor)
nValor := DesTrans(cValor)
Return nValor

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340Tit1 ³ Autor ³ Marcos Patricio		  ³ Data ³ 19/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o saldo ou valor do titulo a ser compensado		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa340Tit1																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA340Tit1()
Local lRet :=.T. 
Local aArea 

dbSelectArea("SE2")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada permite alterar o indice que sera aplicado no Markbrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("FA340ORD")
	dbSetOrder(ExecBlock("FA340ORD",.F.,.F.))
Endif
aArea := GetArea()
dbSetOrder( 6 )

If !dbSeek(cFilial+cFornece+cLoja+cPrefixo+cNum+cParcela+cTipoTit)
	DbSetOrder(1)
	Help(" ",1,"NOTIT")
	lRet :=.F.
EndIf

DbSelectArea("SE2")
RestArea(aArea) 

Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340OK	³ Autor ³ Marcos Patricio		  ³ Data ³ 19/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Confirma a marcacao dos titulos para compensacao.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa340OK																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA340OK()             

Local lF340ValOk := ExistBlock("f340ValOk")
Local lRet       := .t. 

If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() ) 
	If !CTBvldDiario(cCodDiario,dDataBase)
		Return(.f.)
	EndIf
EndIf

If lF340ValOk
	lRet := ExecBlock("F340ValOk", .f., .f., {aTitulos})
	If lRet == Nil
		lRet := (MsgYesNo(OemToAnsi(STR0024),OemToAnsi(STR0018)))  //"Confirma marca‡„o de T¡tulos ?"###"Aten‡„o"	
	EndIf 
Else	
	lRet :=	lRet := (MsgYesNo(OemToAnsi(STR0024),OemToAnsi(STR0018)))  //"Confirma marca‡„o de T¡tulos ?"###"Aten‡„o"	
EndIf	
	
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340Troca³ Autor ³ Marcos Patricio		  ³ Data ³ 19/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Troca o flag para marcado ou nao,aceitando valor.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa340Troca																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA340Troca(nIt,aArray,oGet)
Local oDlg
Local nOpca 	:= 0
Local nI 		:= 0
Local nAcresc 	:= 0 
Local lOk		:= .T.
Local lValDocs	:= .T.
Local lFinVDoc	:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios    
Local lPropPA 	:= SuperGetMv("MV_COMPCP",,.F.) //Verifica se vai proporcionalizar quando PA>NF e PA liquido
Local lValPgto := SuperGetMv("MV_BP10925",.T.,"1") == "2" //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos
Local lPaBruto	:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor   
//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Local	lIRPFBaixa := .F.
//Variavel indica se irá provisionar os impostos de INSS e ISS na inclusão da PA, deduzindo-os do valor de adiantamento.
Local lPrImPA := !Empty( SE2->( FieldPos( "E2_PRINSS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRISS" ) ) ) .And. ;
				 !lPaBruto .And. SuperGetMv("MV_PAPRIME",.T.,"2") == "1"              
Local xt       := 0   
Local nVlSaldo := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso esteja ligado o controle de solicitacao de notas de credito e exista alguma ³
//³ pendencia para este titulo                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cPaisLoc	<> "BRA" .and. !aArray[nIt,8]
	SCU->(DbSetOrder(2))
	If GetMv('MV_SOLNCP') .And. aTitulos[nIt,4] == MVNOTAFIS ;
			.And. SCU->(MsSeek( xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA+aTitulos[nIt,2]+aTitulos[nIt,1] )).And. Empty(SCU->CU_NCRED)
		HELP(" ",1,"SOLNCPAB")
		Return aArray
	Endif
Endif

cValor  := Fa340VTit(aTitulos[nIt,IIF(cPaisLoc == "BRA",22,5)]) 
cSaldo  := Fa340VTit(aTitulos[nIt,IIF(cPaisLoc == "BRA",22,5)]) 

If !aArray[nIt,8]
	If lFinVDoc
		If !FA340ValDocs(aArray[nIt])
			lValDocs := .F.
		EndIf
	EndIf
EndIf

If lValDocs
	aArray[nIt,8] := !aArray[nIt,8]
EndIf

If cPaisLoc == "BRA" .And. nValor > 0
	For xt := 1 to Len(aTitulos)
		If aTitulos[xt][8] .And. xt <> nIt
			nVlSaldo += Destrans(aTitulos[xt][6])
		EndIf
    Next
    cSaldo:=(nValor - nVlSaldo)
    cValor:= cSaldo
EndIf                     

nValtot := 0

If aArray[nIt,8]

	DEFINE MSDIALOG oDlg FROM 069,070 TO 160,330 TITLE OemToAnsi(STR0005) PIXEL  //"Compensa‡„o de Titulos a Pagar"

	@ 001, 002 TO 027, 128 OF oDlg  PIXEL
	@ 010, 068 MSGET cValor Picture "@E 9999,999,999.99" SIZE 54, 10 OF oDlg Hasbutton PIXEL
	@ 011, 009 SAY OemToAnsi(STR0014)  SIZE 54, 7 OF oDlg PIXEL  //"Valor a compensar"
	DEFINE SBUTTON FROM 29, 71 TYPE 1 ENABLE ACTION (nOpca:=1,If((cValor <= cSaldo .AND. cValor > 0),oDLg:End(),nOpca:=0)) OF oDlg
	DEFINE SBUTTON FROM 29, 99 TYPE 2 ENABLE ACTION (aArray[nIt,8]:=.F.,oDlg:End()) OF oDlg

	ACTIVATE MSDIALOG oDlg

	IF nOpca == 1
		If !F340Semaforo(aArray[nIt],.T.,aRecno[nIt]) // se conseguirmos travar o registro do SE2
			lOk := .F.
			aArray[nIt,8] := .F.
		Endif
		
		If lOk
			cSaldo -= cValor
			If Fa340CSld(aRecno[nIt], cValor)
				aArray[nIt,6]:=Transf(cValor,"@E 9999,999,999.99")
				If cPaisLoc == "BRA" 
					aArray[nIt,9]:= cValor      
					If  cValor <> Round(aArray[nIt,21],2)					
						nProp:=cValor/aArray[nIt,20]
				  		aArray[nIt,18]:= cValor
				  	Else
				  		aArray[nIt,9]:= aArray[nIt,21]				  		
				  		nProp:= 1	
				  	Endif
  					aArray[nIt,17]:=Transf((aArray[nIt,19]*nprop),"@E 9999,999,999.99")
				ElseIf cPaisLoc == "BOL"
					aArray[nIt,13]:= Fa340VTit(aArray[nIt,6])
				Endif
				For nI := 1 to Len(aArray)
				   If aArray[nI,8]
				      nValtot += Fa340VTit(aArray[nI,6])
				   Endif
				Next
			Else   
				aArray[nIt,8] := !aArray[nIt,8]
			Endif
		Endif
	
	Else
		aArray[nIt,8] := .F. 
		For nI := 1 to Len(aArray)
		   If aArray[nI,8]
		      nValtot += Fa340VTit(aArray[nI,6])
		   Endif
		Next
	Endif
Else
	If !aArray[nIt,8]
		aArray[nIt,6]:=Transf(0,"@E 9999,999,999.99")
		If cPaisLoc == "BRA"
			aArray[nIt,9]:= 0
		Endif
	Endif
	For nI:=1 to Len(aArray)
	   If aArray[nI,8]
	      nValtot+=Fa340VTit(aArray[nI,6])
	   Endif
	Next
	F340Semaforo(aArray[nIt],.F.,aRecno[nIt])
EndIf
If oGet != Nil
	oGet:Refresh()
Endif
Return aArray

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340Marca³ Autor ³ Alice Y Yamamoto 	  ³ Data ³ 08/04/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca os itens a serem excluidos 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa340descr																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function fa340Marca(nIt,aArray,aRegistros,nOpc)

If (aArray[nIt,10] )
	F340Semaforo( {} , .F. /*TRAVA*/ , aRegistros[nIt] /*Recno*/ , "" /*chave para trava*/, {} ,.F. /*estorno*/)
	aArray[nIt,10] := .F.
Else
	If Fa340VldDt(aArray[nIt],nOpc) .and. F340Semaforo( {} , .T. /*TRAVA*/ , aRegistros[nIt] /*Recno*/ , "" /*chave para trava*/, {} ,.F. /*estorno*/)
		aArray[nIt,10] := .T.
	Endif
Endif

Return aArray

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340SetMo³ Autor ³ Fernando Machima      ³ Data ³ 19/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tela de taxas de moedas                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa340SetMo																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Fa340SetMo()
Local oDlg 
Local nLenMoedas	:= Len(aTxMoedas)
Local nI            := 1
Local nLinTelaF  							//altura da tela de fora
Local nLinTelaD								// altura da tela de dentro	     
Local nLinButton
Local aSay := {}
Local aGet := {}
Local cBlKMoeda    

nLinTelaD	:=  05 + ((nLenMoedas-1) * 14)			// altura da tela de dentro	-> 14-tamanho de cada linha -> 5-sobra em cima e em baixo    
nLinTelaF  	:= 200 + ((nLenMoedas-1) * 30.5) + 35	// altura da tela de fora -> 200-onde comecou a tela -> 30,5-equivalente por linha -> 35-botao e sobras da tela 

nLinButton  :=  03 + nLinTelaD

If nLenMoedas > 1

	DEFINE MSDIALOG oDlg From 200,0 TO nLinTelaF,230 TITLE OemToAnsi(STR0026) PIXEL  //Taxas Moedas			

		@ 005,005  To nLinTelaD,110 OF oDlg PIXEL

		For nI := 1 To nLenMoedas-1              
			cBlKMoeda := "{|| aTxMoedas["+AllTrim(Str(ni+1))+",1]}"
			aAdd(aSay, TSay():New(1+(ni*12),010,&cBlKMoeda,oDlg,,, .F., .F., .T.,.T.,,,,, .F., .F., .F., .F.)) 
		    aAdd(aGet, TGet():New((ni*12)-2,060,&("{|x| If(x <> NIL,aTxMoedas["+AllTRim(Str(ni+1))+",2] := x,aTxMoedas["+Str(ni+1)+",2])}"),oDlg,45,,aTxMoedas[nI,3],,,,,,,.T.,,,,.F.,.T.,,.F.,.F.,,,,.F.,,.T.))
		Next nI
				
	DEFINE  SButton FROM nLinButton,80 TYPE 1 Action (oDlg:End() ) ENABLE OF oDlg  PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED
Else
	Help("",1,"NoMoneda")
Endif
Return
           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³Fa340TudOkºAutor  ³Mauricio`Pequim Jr  º Data ³  24/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validar os campos informados na compensacao                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fina340                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Fa340TudOk(oDlg)
Local nX
Local lRet := .T.

For nX := 1 To Len(oDlg:aControls)
	If ValType(oDlg:aControls[nX]) == "O" .And.;
		!Empty(oDlg:aControls[nX]:bValid)
		
		lRet:=Eval(oDlg:aControls[nX]:bValid)
		If ValType(lRet) != "L"
			lRet := .T.
		Endif	
		If !lRet
			Help(" ",1,"F340Erro")	
			Exit // Sai no primeiro campo invalido
		Endif	
	Endif
Next

//Ponto de entrada para permitir ou nao compensar um determinado titulo
If lRet .and. ExistBlock("F340VLD")
	lRet := ExecBlock("F340VLD",.F.,.F.)
Endif
Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa340Leg   ³ Autor ³ Nilton Pereira       ³ Data ³ 17.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fa340Leg(nReg)
Local uRetorno := .T.
Local aLegenda := {	{"ENABLE"		, 	STR0034	},;	// "Titulo nao Compensado"
				   	{"DISABLE"		, 	STR0035	},;	// "Titulo Compensado Totalmente"
				   	{"BR_AZUL"		,   STR0036	}} 	// "Titulo Compensado Parcialmente"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para alterar informações da legenda.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("F340LEGE")
	aLegenda := ExecBlock("F340LEGE",.f.,.f.,{aLegenda})
Endif         

If nReg = Nil	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
	uRetorno := {}
	Aadd(uRetorno, {'E2_SALDO =  E2_VALOR .AND. E2_ACRESC = E2_SDACRES', aLegenda[1][1]}) // Titulo nao Compensado
	Aadd(uRetorno, {'E2_SALDO =  0', aLegenda[2][1]})			// Titulo Compensado Totalmente 
	Aadd(uRetorno, {'E2_SALDO <> 0', aLegenda[3][1]})			// Titulo Compensado Parcialmente
Else
	BrwLegenda(cCadastro,STR0037,aLegenda) 
Endif


Return uRetorno

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa340TxMd  ³ Autor ³ Cristiano Denardi    ³ Data ³ 05.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Busca Taxa em aTxMoedas e verifica se foi trocada          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fa340TxMd( nMoeda2, nTx )

Local lExistTxMd	:= Type("aTxMoedas")#"U" .And. Len(aTxMoedas) > 0  

Default nTx			:= 0
Default nMoeda2 		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura aTxMoedas         ³
//³ [1] -> Nome Moeda          	³
//³ [2] -> Taxa a Ser Utilizada	³
//³ [3] -> Picture          	³
//³ [4] -> Taxa do dia atual    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Esta função só deve ser chamada pela rotina de compensação a pagar

If nMoeda2 > 0 .And. lExistTxMd 
	If aTxMoedas[nMoeda2][2] <> aTxMoedas[nMoeda2][4] .and. (aTxMoedas[nMoeda2][2]<>0)
		nTx := aTxMoedas[nMoeda2][2]
	Endif
Endif

Return( nTx )
                                   

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa340Inver ³ Autor ³ Cristiano Denardi    ³ Data ³ 05.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inverte a selecao da relacao de Titulos a Compensar        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa340Inver( aTit, oTit, oGet )

Local nA 		:= 0
Local lValDocs	:= .T.
Local lFinVDoc	:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
Local lPrimeiro:=.T.
nValTot  := 0 

For nA := 1 To Len(aTit)
	lValDocs := .T.
	If !aTit[nA][08]
		If lFinVDoc
			If !FA340ValDocs(aTit[nA],.T.,,,@lPrimeiro)		//Valida os documentos obrigatorios
				lValDocs := .F.
			EndIf
		EndIf
		If lValDocs
			F340Semaforo(aTit[nA],.T.,aRecno[nA])
			aTit[nA][08] := !aTit[nA][08]
		EndIf
	Else
		F340Semaforo(aTit[nA],.F.,aRecno[nA])
		aTit[nA][08] := !aTit[nA][08]
	EndIf
	If aTit[nA][08]
		If ( Fa340VTit(aTit[nA][6]) = 0 )
	 		aTit[nA][6] := aTit[nA][5]
	 		If cPaisLoc == "BRA"
		 		aTit[nA][9] := DesTrans(aTit[nA][5])
	 		EndIf
		Endif
		nValTot += Fa340VTit(aTit[nA][6])
	Else
		aTit[nA][6] := Transform(0,"@E 9999,999,999.99")
		If cPaisLoc == "BRA"
			aTit[nA][9] := aTit[nA][6]
		EndIf	
	Endif
Next nA

oTit:Refresh()
oGet:Refresh()

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fMarkAll   ³ Autor ³ Cristiano Denardi    ³ Data ³ 05.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Marca ou Desmarca todos os titulos				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fMarkAll( aTit )

Local nA 		:= 0
Local lValDocs	:= .T.
Local lFinVDoc	:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
Local lPrimeiro:=.T.
lMarkAll := .F.
For nA := 1 To Len(aTit)
	If !aTit[nA][8]
		lMarkAll := .T.
	EndIf
Next nA

If Len(aTit) > 0
	nValTot  := 0 
	For nA := 1 To Len(aTit)
		lValDocs := .T.
		If !aTit[nA][8]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso tenha integracao Documentos  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AliasIndic("FRD") .And. (SE2->(FieldPos("E2_TEMDOCS")) > 0) .And. FindFunction("CN062ValDocs") .And. lFinVDoc
				If !FA340ValDocs(aTit[nA],.T.,,,@lPrimeiro)
					lValDocs := .F.
				EndIf
			EndIf

			If lValDocs		
				If F340Semaforo(aTit[nA],.T.,aRecno[nA])
					aTit[nA][08]	:= .T.
					aTit[nA][6]		:= aTit[nA][5]

					If cPaisLoc == "BRA"   
						aTit[nA][6]		:= aTit[nA][22]
						aTit[nA][9]		:= DesTrans(aTit[nA][22])
						nValTot			+= Fa340VTit(aTit[nA][6])
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caso esteja ligado o controle de solicitacao de notas de credito e exista alguma ³
					//³ pendencia para este titulo                                                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
					ElseIf cPaisLoc	<> "BRA"
						SCU->(DbSetOrder(2))
						If GetMv('MV_SOLNCP') .And. aTit[nA,4] == MVNOTAFIS ;
								.And. SCU->(MsSeek( xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA+aTit[nA,2]+aTit[nA,1] )).And. Empty(SCU->CU_NCRED)
							//HELP(" ",1,"SOLNCPAB")
							aTit[nA][08]	:= .F. 
							aTit[nA][6]		:= Transform(0,"@E 9999,999,999.99")
						Else
							nValTot			+= Fa340VTit(aTit[nA][6])
						Endif
					EndIf
				Endif
			EndIf
		ElseIf !lMarkAll
			F340Semaforo(aTit[nA],.F.,aRecno[nA])
			aTit[nA][08]	:= .F.
			aTit[nA][6]		:= Transform(0,"@E 9999,999,999.99")
			If cPaisLoc == "BRA"
				aTit[nA][9]		:= DesTrans(aTit[nA][6])
		    EndIf
		Else
			nValTot	+= Fa340VTit(aTit[nA][6])			
		Endif
	Next nA
EndIf

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa340IntPco ºAutor ³Paulo Carnelossi    º Data ³  22/11/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³funcao que gera os lancamentos no sigapco (PcoDetLan())     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fa340IntPco(nRecSE2, aRecnoSE2, aBaixaSE5)
Local aArea := GetArea()
Local aAreaSE2 := SE2->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local nX

If SuperGetMV("MV_PCOINTE",.F.,"2")=="1"

	dbSelectArea("SE2")
	dbGoto(nRecSE2) //titulo principal apos a compensacao
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava lançamento no PCO ref titulo principal apos a compensacao    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PCODetLan("000017","01","FINA340")
	
	For nX := 1 TO Len(aRecnoSE2) // ARRAY COM REGISTROS TITULOS COMPENSADOS
	
		//grava lcto ref. titulo compensado
		dbSelectArea("SE2")	
		dbGoto(aRecnoSE2[nX])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref titulo compensado apos a compensacao   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000017","02","FINA340")
	
		//grava lctos das baixas referente titulo principal e titulo compensado
		dbSelectArea("SE5")
		
		dbGoto(aBaixaSE5[(nX*2)-1])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref baixa (Mov.Bancaria-SE5) do titulo principal apos a compensacao   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000017","03","FINA340")
	
		dbGoto(aBaixaSE5[(nX*2)])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref baixa do titulo compensado (Mov.Bancaria-SE5)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000017","04","FINA340")
	
	Next
	
EndIf

RestArea(aAreaSE5)
RestArea(aAreaSE2)
RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³23/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
Local aRotina := { { STR0001,"AxPesqui"  , 0 , 1,,.F. },;  //"Pesquisar"
	{ STR0002,"AxVisual"  , 0 , 2 },;  //"Visualizar"
	{ STR0003,"Fa340Comp" , 0 , 4 },;  //"Compensar"
	{ STR0004,"Fa340Desc" , 0 , 4 },;  //"Excluir"
	{ STR0040,"Fa340Desc" , 0 , 4 },;  //"Estornar"
	{ STR0037,"Fa340Leg"  ,0,2, ,.F.} }      //"Legenda"
Return(aRotina)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa340VerNDF³ Autor ³ Marcel Borges        ³ Data ³ 15.09.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o título tem NDF e se sofreu baixas            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa340VerNDF(lNDF,nRecNDF)

	Local aArea    := GetArea()
	Local nRecno
	DEFAULT lNDF    := .F.
	DEFAULT nRecNDF := 0
	
	DbSelectArea("SE2")
	DbSetOrder(1)
	nRecno := SE2->(recno())
	If MsSeek(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+Subst(MV_CPNEG,1,3)+SE2->E2_FORNECE+SE2->E2_LOJA)
		If SE2->E2_ORIGEM == "FINA340"
			lNDF := .T.
			nRecNDF := SE2->(recno())
			If SE2->E2_SALDO < SE2->E2_VALOR 
				RestArea(aArea)
				Return .T.
			EndIf
		EndIf
	EndIf		
	dbGoTo(nRecno)
	RestArea(aArea)
Return .F.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FinA340T   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 26.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada semi-automatica utilizado pelo gestor financeiro   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function FinA340T(aParam)
	cRotinaExec := "FINA340"
	ReCreateBrow("SE2",FinWindow)      	
	FinA340(aParam[1])
	ReCreateBrow("SE2",FinWindow)      	
	dbSelectArea("SE2")
	
	INCLUI := .F.
	ALTERA := .F.
	
Return .T.	



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA340VerPa ºAutor  ³ Gustavo Henrique º Data ³  20/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se houve movimento de liberacao de cheque para PA º±±
±±º          ³ quando informado "sim" para pergunta "Gera Chq Adt?" no    º±±
±±º          ³ momento da inclusao do titulo de PA.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro - Compensacao CP                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA340VerPA()

Local aAreaSE5	:= GetArea('SE5')           
Local cChavePA	:= ""
Local lCheqLib	:= .F.
Local lRet		:= .T.
                
cChavePA := xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)

// Caso não tenha achado movimento para o PA ou
// Achou movimento, mas nao possui cheque gerado, nao permite a compensacao (Gera Chq Adt = Sim, Gera mov s/ chq = Nao)
SE5->( dbSetOrder( 7 ) )
lRet := SE5->( dbSeek( cChavePA ) )


If lRet .And. !(SE5->E5_TIPODOC $ "PA")	// Baixa ou Cheque
    Do While SE5->( ! EoF() .And. E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA == cChavePA )
		If !(TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.F.))
			If (SE5->E5_TIPODOC $ "BA/CH" .And. !Empty(SE5->E5_NUMCHEQ) .And. SubStr(SE5->E5_NUMCHEQ,1,1) <> "*") .OR. SE5->E5_TIPODOC $ "VL"
				lCheqLib := .T.
				Exit		
			EndIf      
		Endif
    	SE5->( dbSkip() )
	EndDo          	 
	lRet := lCheqLib
EndIf

RestArea(aAreaSE5)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FaNfsRAdt   ³ Autor ³Totvs                ³ Data ³10.05.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Checa se condicao de pagamento do documento de entrada usa  ³±±
±±³          ³adiantamento.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se Condicao de Pagamento gera Adiantamento    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Prefixo do titulo                                    ³±±
±±³          ³ExpC2: Numero do titulo                                     ³±±
±±³          ³ExpC3: Codigo do fornecedor                                 ³±±
±±³          ³ExpC4: Loja do fornecedor                                   ³±±
±±³          ³ExpD5: Data de Emissao do Documento                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FaNfsRAdt(cPrefixo,cNum,cFornece,cLoja,dDataEmis)

Local aArea := GetArea()
Local cQ := ""
Local lRet := .F.

cQ	:= "SELECT F1_COND "
cQ += "FROM "+RetSqlName("SF1")+" "
cQ += "WHERE F1_FILIAL = '"+xFilial("SF1")+"' "
cQ += "AND F1_PREFIXO = '"+cPrefixo+"' "
cQ += "AND F1_DUPL = '"+cNum+"' "
cQ += "AND F1_FORNECE = '"+cFornece+"' "
cQ += "AND F1_LOJA = '"+cLoja+"' "
cQ += "AND F1_DTDIGIT = '"+dTos(dDataEmis)+"' "
cQ += "AND D_E_L_E_T_= ' ' "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"TRBSF1",.T.,.T.)

If !Eof()
	If A120UsaAdi(TRBSF1->F1_COND)
		lRet := .T.
	Endif
Endif

TRBSF1->(dbCloseArea())

RestArea(aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LockcCmpCp  ºAutor  ³Clovis Magenta      º Data ³  22/10/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que bloqueia os registros selecionados na rotina de  º±±
±±º          ³ compensacao para manter integridade dos dados               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA340                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LockCmpCP( cChave , lMsg)

Local lRet := .T.
DEFAULT lMsg := .T.

While lRet .And. !LockByName( "F340" + cChave + cEmpAnt ,.T., .F., .T. )
	If !__lBlind
		If lMsg // quando carregamos a tela para seleção de titulos, simplesmente não deixamos o titulo marcado.
			If Aviso("Registro em uso","Este registro está sendo manipulado por outro usuário e se encontra travado. Deseja tentar usá-lo novamente?",{"Sim", "Não"},2)==1
//			+CHR(13)+CHR(10)+"Chave do título (Filial+Pref+Num+Parc+Tipo+Fornec+Loja: "+ cChave 
				Loop
			Else
				lRet:=.F.
			Endif
		Else
			lRet:=.F.
		Endif
	Else
		Sleep( 5000 )
	EndIf
EndDo

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UnLockCmpCpºAutor  ³Clovis Magenta      º Data ³  22/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para liberar registro em lock na rotina de compensa- º±±
±±º          ³ cao.                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA340                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UnLockCmpCP( cChave )
Return ( UnLockByName( "F340" + cChave + cEmpAnt , .T. , .F., .T. ), nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F340Semaforo ºAutor  ³Clovis Magenta      º Data ³ 22/10/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que realiza o bloqueio do registro SE2 selecionado   º±±
±±º          ³ no momento da compensacao, para nao haver conflito de dados º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA340                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function F340Semaforo( aDados , lTrava , nRecno , cChvSE2 , aRegs ,lCompensa ,lMsg )
Local lCancel	:= (nRecno == 0) // quando igual a zero, a tela de seleção dos títulos fora cancelada Ou iniciada)
Local lRet 		:= .T.
Local aArea		:= GetArea()
Local aAreaSE2	:= SE2->(GetArea())
Local nX			:= 0

//--- Tratamento Gestao Corporativa
Local lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
//
Local cFilFwSE2 := IIF( lGestao .And. FindFunction("FwFilial"), FwFilial("SE2") , xFilial("SE2") )

DEFAULT  aRegs		:= {}
DEFAULT  cChvSE2	:= ""
DEFAULT lCompensa := .T.
DEFAULT lMsg		:= .T.

If lCompensa
	If !lCancel
	
		dbSelectArea("SE2")
		SE2->(dbGoTo(nRecno))
		cChvSE2 := xFilial("SE2")+aDados[1]+aDados[2]+aDados[3]+aDados[4]+SE2->(E2_FORNECE+E2_LOJA)
		If lTrava
			If !LockCmpCP(cChvSE2,lMsg)
				lRet := .F.
			Endif
		Else
			UnLockCmpCP(cChvSE2)
		Endif
	
	Else /* --> Abandono da tela de seleção: destravar todos os travados <-- */

		dbSelectArea("SE2")
		For nX := 1 to Len(aDados)

			If aDados[nX,8] // verifica se está selecionado para liberar registro
				SE2->(dbGoTo(aRecno[nX]))
				cChvSE2 := xFilial("SE2")+aDados[nX,1]+aDados[nX,2]+aDados[nX,3]+aDados[nX,4]+SE2->(E2_FORNECE+E2_LOJA)
				UnLockCmpCP(cChvSE2)
			Endif

		Next nX
			
	Endif


Else /* --> Estorno da compensação <-- */


	If !lCancel 	// Se estiver na tela de seleção dos titulos no estorno

	//***********************************************************************************************************//		
	// Pega chave do titulo selecionado no estorno/exclusao da Compensacao baseando-se no recno do mesmo no SE5  //
	//***********************************************************************************************************//
	
		If Empty(cChvSE2)
			SE5->(dbGoTo(nRecno))

			If !Empty(SE5->E5_FILORIG) .and. !Empty( cFilFwSE2 )
				cChvSE2 := SE5->E5_FILORIG+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+SE5->(E5_FORNADT+E5_LOJAADT)
			Else
				cChvSE2 := xFilial("SE2")+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+SE5->(E5_FORNADT+E5_LOJAADT)
			Endif
		Endif
	
	//***********************************************************************************************************//		
	
		If lTrava
			If !LockCmpCP(cChvSE2,lMsg)
				lRet := .F.
			Endif
		Else
			UnLockCmpCP(cChvSE2)
		Endif

	Else  /* --> Abandono da tela de seleção no estorno: destravar todos os travados <-- */
	             
		dbSelectArea("SE5")
		For nX := 1 to Len(aDados)

			If aDados[nX,10] // verifica se está selecionado para liberar registro

				SE5->(dbGoTo(aRegs[nX]))
			
				If !Empty(SE5->E5_FILORIG) .and. !Empty( cFilFwSE2 )
					cChvSE2 := SE5->E5_FILORIG+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+SE5->(E5_FORNADT+E5_LOJAADT)
				Else
					cChvSE2 := xFilial("SE2")+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+SE5->(E5_FORNADT+E5_LOJAADT)
				Endif					
				
				UnLockCmpCP(cChvSE2)
			Endif

		Next nX
		
	Endif
	
Endif

RestArea(aAreaSE2)
RestArea(aArea)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa340CSld ºAutor  ³Clovis Magenta	     º Data ³  23/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que valida o valor digitado para compensação na telaº±±
±±º          ³ de Mark. Validação necessária para integridade dos valores.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Fa340CSld(nRecnoSE2, nValor)
Local lGoodSld := .T.
Local aArea		:= GetArea()
Local aAreaSE2	:= SE2->(GetArea())
Local lPropPA	:= SuperGetMv("MV_COMPCP",,.F.) //Verifica se vai proporcionalizar quando PA>NF e PA liquido
Local lValPgto := SuperGetMv("MV_BP10925",.T.,"1") == "2" //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos
Local lPaBruto	:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor   
//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Local	lIRPFBaixa := .F.
//Variavel indica se irá provisionar os impostos de INSS e ISS na inclusão da PA, deduzindo-os do valor de adiantamento.
Local lPrImPA := !Empty( SE2->( FieldPos( "E2_PRINSS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRISS" ) ) ) .And. ;
				 !lPaBruto .And. SuperGetMv("MV_PAPRIME",.T.,"2") == "1"     
Local nImp:=0 
Local lRInssPa := .F.

Dbselectarea("SA2")
SA2->(Dbsetorder(1))
If SA2->(Dbseek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA)))
	lIRPFBaixa :=IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 				
Endif

dbselectArea("SE2")
SE2->(dbGoTo(nRecnoSE2))
If lPrImPA
	SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ)) 	
	lRInssPa := !Empty( SED->( FieldPos( "ED_RINSSPA" ) ) ) .And. SED->ED_RINSSPA == '1'
EndIf
nSldTit:= SE2->E2_SALDO +SE2->E2_SDACRES-SE2->E2_SDDECRE
If (lPCCBaixa .or. lIRPFBaixa) .and. lPropPA .and. !lPaBruto .and. lValPgto
	nImp:=Iif(lPCCBaixa,SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL,0)+IIF(lIRPFBaixa, SE2->E2_IRRF,0)+ If(lPrImPA .AND. SE2->E2_TIPO == MVPAGANT+"/INA" .And. !lRInssPA,SE2->E2_PRINSS +Iif(!lCalcIssBx,SE2->E2_PRISS,SE2->E2_ISS),SE2->E2_INSS +Iif(lCalcIssBx,SE2->E2_ISS,0))
	nImp:= nImp*(SE2->E2_SALDO/SE2->E2_VALOR)   
	nSaldoTit	:=	Round(xMoeda((nSldTit+nImp),SE2->E2_MOEDA,nMoeda,,5,If(nMoeda== 1,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda  ));
																,If(SE2->E2_MOEDA == 1,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,SE2->E2_TXMOEDA))),MsDecimais(nMoeda))    
Else
	If Alltrim(SE2->E2_ORIGEM) $ "MATA100|MATA466N" 
		nSaldoTit	:=	Round(xMoeda(E2_SALDO+E2_SDACRES-E2_SDDECRE ,SE2->E2_MOEDA,nMoeda,dDatabase,2+1,aTxMoedas[E2_MOEDA][2],aTxMoedas[nMoeda][2]),2)
	Else
		nSaldoTit	:=	Round(xMoeda(SE2->E2_SALDO+SE2->E2_SDACRES,SE2->E2_MOEDA,nMoeda,,5,If(nMoeda== 1,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda  ));
																	,If(SE2->E2_MOEDA == 1,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,SE2->E2_TXMOEDA))),MsDecimais(nMoeda))
	Endif
EndIf
If nSaldoTit < nValor 
	lGoodSld := .F.
	//"Este título não possui mais o saldo que se apresenta. Possivelmente outro usuário manipulou este mesmo título. Favor verificar."
	// "Saldo insuficiente!"
	MsgAlert(STR0055,STR0054)
Endif

RestArea(aArea)
RestArea(aAreaSE2)

Return lGoodSld

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa340VldDtºAutor  ³ Clovis Magenta     º Data ³  13/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consiste MV_DATAFIN antes de cancelar baixa/compensação  	º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Fa340VldDt(aArray,nOpc)
Local lRet := .T.

If lRet .and. SuperGetMv("MV_BXDTFIN",,"1") == "2"	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ A data da baixa deve ser passada como parametro, pois ³
	//³ a "exclusao" deve ser validada pela data de baixa e o ³
	//³ cancelamento pela data base do sistema.				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nOpc == 4 // Exclusão de Compensação
		lRet := DtMovFin(CtoD(aArray[05]))
	ElseIf nOpc == 5  // Estorno de Compensação
		lRet := DtMovFin()
	EndIf
Endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA340ValDocs  ºAutor  ³Renan G. Alexandre  º Data ³ 02/24/11º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de posicionamento da tabela SE2 para validacao dos   º±±
±±º          ³documentos obrigatorios.                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aTitulo = Array com o titulo a pagar que sera validado     º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA340ValDocs(aTitulo,lTodos,lEmail,lExibe,lPrimeiro)

Local lRet			:= .T.
Local aArea			:= {}
Local aAreaSE2		:= {}
Local cTitulo		:= ""
Local lFinVDoc		:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
Local nX			:= 0
Default lPrimeiro :=.F.
Default lTodos		:= .F.
Default lEmail		:= .F.

If lFinVDoc .And. !lExibe
	aArea 		:= GetArea()
	aAreaSE2	:= SE2->(GetArea())
	
	dbSelectArea("SE2")
	
	If AliasIndic("FRD") .And. (SE2->(FieldPos("E2_TEMDOCS")) > 0) .And. FindFunction("CN062ValDocs")
		If cPaisLoc == "BRA"
			cTitulo := aTitulo[16]+aTitulo[1]+aTitulo[2]+aTitulo[3]+aTitulo[4]+aTitulo[14]+aTitulo[15]
		ElseIf cPaisLoc == "BOL"
			cTitulo := aTitulo[16]+aTitulo[1]+aTitulo[2]+aTitulo[3]+aTitulo[4]+aTitulo[14]+aTitulo[15]
		Else
			cTitulo := aTitulo[15]+aTitulo[1]+aTitulo[2]+aTitulo[3]+aTitulo[4]+aTitulo[13]+aTitulo[14]
		EndIf
	    
		SE2->(dbSetOrder(1))		//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		SE2->(dbGoTop())
		If SE2->(dbSeek(cTitulo))		//Posiciona no titulo para a funcao de validacao dos documentos.
			If lEmail
				CN062ValDocs("07",.F.,.T.)
			Else
				If !CN062ValDocs("07",.F.,.F.,lTodos,@lPrimeiro)
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf
	
	RestArea(aAreaSE2)
	RestArea(aArea)
	
ElseIf lFinVDoc .And. lExibe
	aArea 		:= GetArea()
	aAreaSE2	:= SE2->(GetArea())
	
	dbSelectArea("SE2")
	
	If AliasIndic("FRD") .And. (SE2->(FieldPos("E2_TEMDOCS")) > 0) .And. FindFunction("CN062ValDocs")
		SE2->(dbSetOrder(1))		//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		SE2->(dbGoTop())
		For nX := 1 To Len(aTitulos)
			If aTitulos[nX][8]
				If cPaisLoc == "BRA"
					cTitulo := aTitulos[nX,16]+aTitulos[nX,1]+aTitulos[nX,2]+aTitulos[nX,3]+aTitulos[nX,4]+aTitulos[nX,14]+aTitulos[nX,15]
				ElseIf cPaisLoc == "BOL"
					cTitulo := aTitulos[nX,16]+aTitulos[nX,1]+aTitulos[nX,2]+aTitulos[nX,3]+aTitulos[nX,4]+aTitulos[nX,14]+aTitulos[nX,15]
				Else
					cTitulo := aTitulos[nX,15]+aTitulos[nX,1]+aTitulos[nX,2]+aTitulos[nX,3]+aTitulos[nX,4]+aTitulos[nX,13]+aTitulos[nX,14]
				EndIf
				If dbSeek(cTitulo)
					If !CN062ValDocs("07",.F.,.F.,lTodos,@lPrimeiro)
						aTitulos[nX][8] := .F.
					EndIf
				EndIf
			EndIf
		Next nX
	
	EndIf
	
	RestArea(aAreaSE2)
	RestArea(aArea)
	
EndIf

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA340   ºAutor  ³Pâmela Bernardo     º Data ³  05/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ composição do E2_SALDO de titulos com impostos e           º±±
±±º          ³ proporcionalização                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ fina340                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F340SalPr(cTpdoc) 

    
Local lPropPA 	:= SuperGetMv("MV_COMPCP",,.F.) //Verifica se vai proporcionalizar quando PA>NF e PA liquido
Local lValPgto 	:= SuperGetMv("MV_BP10925",.T.,"1") == "2" //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos
Local lPaBruto	:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor
LOCAL cAlias 	:= GetNextAlias()         
Local aAreaSE2	:= SE2->(GetArea()) 


#IFDEF TOP
	Local nSE5  		:= 0
	Local cQuery	  	:= ""
	Local aStruSE5	  	:= {}

#ENDIF
           
Default cTpdoc:= cTipodc	

#IFDEF	TOP
	
		If TcSrvType() != "AS/400"

			cQuery := "SELECT DISTINCT SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, "
			cQuery += "SE5.E5_TIPO, SE5.E5_DATA, SE5.E5_CLIFOR, SE5.E5_LOJA, SE5.E5_SEQ,SE5.E5_VRETPIS, SE5.E5_VRETCOF,SE5.E5_VRETCSL,SE5.E5_VRETIRF,SE5.E5_VRETISS,"
			cQuery += "SE5.E5_DOCUMEN, SE5.E5_FILORIG, SE5.E5_VLMOED2, SE5.E5_FORNADT, SE5.E5_LOJAADT, SE5.E5_TXMOEDA, SE5.E5_VALOR, SE5.R_E_C_N_O_ E5_RECNO, SE5.E5_MOEDA "
			cQuery += "FROM "+RetSqlName("SE5") + " SE5 "
			
			cQuery += "WHERE "
			cQuery += "SE5.E5_FILIAL = '"+xFilial("SE5")+"' AND "
			cQuery += "SE5.E5_PREFIXO = '"+SE2->E2_PREFIXO+"' AND "
			cQuery += "SE5.E5_NUMERO = '"+SE2->E2_NUM +"'AND "
			cQuery += "SE5.E5_PARCELA = '"+SE2->E2_PARCELA+"' AND "
			cQuery += "SE5.E5_TIPO = '"+SE2->E2_TIPO+"' AND "
			
			If mv_par02==1 
				cQuery += "SE5.E5_CLIFOR = '"+SE2->E2_FORNECE+"' AND "  
			Else
		   		cQuery +=	"SE5.E5_CLIFOR >='" + Mv_Par03 + "' AND "
				cQuery += "SE5.E5_CLIFOR <='" + Mv_Par04 + "' AND "
			EndIf	 
			If (mv_par01==1 .and. mv_par02==1)
				cQuery += "SE5.E5_LOJA = '"+SE2->E2_LOJA+"' AND "
     		Endif  

			cQuery += "SE5.E5_TIPODOC ='" +cTpdoc+ "' AND "

			cQuery += "SE5.E5_MOTBX = 'CMP' AND "
			cQuery += "SE5.E5_RECPAG = 'P' AND "			
		
			cQuery += "SE5.D_E_L_E_T_ = ' ' "
			cQuery += "ORDER BY "
			cQuery += "SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, "
			cQuery += "SE5.E5_TIPO, SE5.E5_DATA, SE5.E5_SEQ"
			
			cQuery := ChangeQuery(cQuery)
						
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAlias),.T.,.T.)		
		
			aStruSE5:= SE5->(dbStruct())

			For nSE5 := 1 To Len(aStruSE5)
				If aStruSE5[nSE5][2] <> "C" .and.  FieldPos(aStruSE5[nSE5][1]) > 0
					TcSetField((cAlias),aStruSE5[nSE5][1],aStruSE5[nSE5][2],aStruSE5[nSE5][3],aStruSE5[nSE5][4])
				EndIf
			Next nSE5	
		
			While (cAlias)->(!EOF())
					
				//Verifica se a data base do sistema eh menor que a data de compensacao dos titulos
				If DTOS(dDataBase) < DTOS((cAlias)->E5_DATA) 
			   		(cAlias)->(DbSkip())
  					Loop
	 			EndIf 
	 			IF SE5->E5_SEQ <>(cAlias)->E5_SEQ														
					(cAlias)->(DbSkip())
  					Loop
	 			EndIf 
				//Verifica se tem baixa cancelada
				If TemBxCanc((cAlias)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.F.)
					(cAlias)->( dbskip())
					loop
				EndIf

				If !lPaBruto .And. lPropPA .and. SE2->E2_TIPO == (cAlias)->E5_TIPO .and. lValPgto
				    nTxMoeda := IIf(!Empty((cAlias)->E5_TXMOEDA),(cAlias)->E5_TXMOEDA,RecMoeda((cAlias)->E5_DATA,SE2->E2_MOEDA))
					If (SE2->E2_MOEDA > 1 .AND. nMoeda == 1) .or. (SE2->E2_MOEDA == 1 .AND. nMoeda > 1) 
						If Val((cAlias)->E5_MOEDA) == SE2->E2_MOEDA
							SE2->E2_SALDO += Round(NoRound(xMoeda((cAlias)->E5_VALOR,nMoeda,SE2->E2_MOEDA,(cAlias)->E5_DATA,3,,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA)),3),2)
						Else
							SE2->E2_SALDO += Round(NoRound((cAlias)->E5_VALOR,3),2)						
						EndIf
					ElseIf (SE2->E2_MOEDA > 1 .AND. nMoeda == 1)	
						SE2->E2_SALDO += Round(NoRound((cAlias)->E5_VALOR,3),2)
					ElseIf (SE2->E2_MOEDA == 1 .And. nMoeda == 1) .And. lPropPA .and. lValPgto
						SE2->E2_SALDO +=Round(NoRound(xMoeda((cAlias)->E5_VALOR ,1,SE2->E2_MOEDA,(cAlias)->E5_DATA,3,,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA)),3),2)
						lAltPa	:=	.T.
					Else		  												
						SE2->E2_SALDO += Round(NoRound(xMoeda((cAlias)->E5_VLMOED2,nMoeda,SE2->E2_MOEDA,(cAlias)->E5_DATA,3, If(SE2->E2_MOEDA == 1, Fa340TxMd(nMoeda,nTxMoeda),Fa340TxMd(nMoeda,SE2->E2_TXMOEDA)),;
											If(nMoeda == 1, Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda))),3),2)
					Endif 
					If !(SE2->E2_TIPO $ MVPAGANT+"/INA")
						SE2->E2_SALDO +=(cAlias)->E5_VRETPIS+(cAlias)->E5_VRETCOF+(cAlias)->E5_VRETCSL+(cAlias)->E5_VRETIRF+(cAlias)->E5_VRETISS
					Endif
				Endif  
 
				(cAlias)->(DbSkip())
			EndDo 

		EndIf   
If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
Endif
Restarea(aAreaSE2)	   
		
#ENDIF	  
RETURN		



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA340   ºAutor  ³Pâmela Bernardo     º Data ³  05/28/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Composição de base de calculo quando ocorre baixa parcial   º±±
±±º          ³sem ser por compensação                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA340                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F340CompSal(nRecno,lRetorna)       

LOCAL cAlias 	:= GetNextAlias()   
Local nTotbx 	:= 0
Local aAreaSe2  := SE2->(GetArea())  
Local aAreaSe5  := SE5->(GetArea()) 
Local nValBas	:= 0     
Local lValPgto := SuperGetMv("MV_BP10925",.T.,"1") == "2" //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos
//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa 	:= SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Local lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 


#IFDEF TOP
	Local nSE5  		:= 0
	Local cQuery	  	:= ""                      
	Local aStruSE5	  	:= {}

#ENDIF
           
Default nRecno:= SE2->(Recno())   
Default lRetorna:= .F. // determina se o retorno será o saldo ou imposto já compensado

dbSelectArea("SE2") 
SE2->(dbGoTo(nRecno))
SE5->(DbSetOrder(7))

#IFDEF	TOP
	
		If TcSrvType() != "AS/400"

			cQuery := "SELECT SE5.E5_FILIAL, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, "
			cQuery += "SE5.E5_TIPO, SE5.E5_CLIFOR, SE5.E5_LOJA, SE5.E5_SEQ, E5_DOCUMEN, "
			cQuery += "SE5.E5_VALOR, E5_VRETPIS, E5_VRETCOF, E5_VRETCSL, E5_VRETIRF, E5_PRETIRF, E5_PRETPIS, E5_PRETCOF, E5_PRETCSL,E5_VRETISS"
			cQuery += "FROM "+RetSqlName("SE5") + " SE5"
			cQuery += "WHERE "                                               
			cQuery += "SE5.E5_FILIAL = '"+xFilial("SE2")+"' AND "    
			cQuery += "SE5.E5_PREFIXO ='" + SE2->E2_PREFIXO +"' AND "
			cQuery += "SE5.E5_NUMERO = '" + SE2->E2_NUM +"' AND "
			cQuery += "SE5.E5_PARCELA ='" + SE2->E2_PARCELA +"' AND "
			cQuery += "SE5.E5_TIPO = '" + SE2->E2_TIPO +"' AND "
			cQuery += "SE5.E5_CLIFOR = '" + SE2->E2_FORNECE +"' AND "
			cQuery += "SE5.E5_LOJA = '" + SE2->E2_LOJA +"' AND "
     		cQuery += "SE5.E5_MOTBX NOT IN ('FAT','IRF','PCC','LIQ','STP') AND "    
     		If SE2->E2_TIPO $ MVPAGANT+"/INA" 
     			cQuery += "SE5.E5_MOTBX NOT IN ('NOR') AND "    
     		Endif
			cQuery += "SE5.E5_RECPAG = 'P' AND "	
			cQuery += "SE5.E5_TIPODOC <>'ES' AND "		
		
			cQuery += "SE5.D_E_L_E_T_ = ' ' "
			
			cQuery := ChangeQuery(cQuery)
						
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAlias),.T.,.T.)		
		
			aStruSE5:= SE5->(dbStruct())

			For nSE5 := 1 To Len(aStruSE5)
				If aStruSE5[nSE5][2] <> "C" .and.  FieldPos(aStruSE5[nSE5][1]) > 0
					TcSetField((cAlias),aStruSE5[nSE5][1],aStruSE5[nSE5][2],aStruSE5[nSE5][3],aStruSE5[nSE5][4])
				EndIf
			Next nSE5	
		
			While (cAlias)->(!EOF())
					
				//Verifica se tem baixa cancelada
				If TemBxCanc((cAlias)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.F.)
					(cAlias)->( dbskip())
					loop
				EndIf  
				If !lRetorna
					 nTotbx+= If(lValPgto,(cAlias)->E5_VRETPIS+ (cAlias)->E5_VRETCOF + (cAlias)->E5_VRETCSL + (cAlias)->E5_VRETIRF+(cAlias)->E5_VRETISS,0)
				ElseIF SE5->(MsSeek(xFilial()+SubStr((cAlias)->E5_DOCUMEN,1,nTamTit+nTamTip)+SE2->(E2_FORNECE+E2_LOJA)+(cAlias)->E5_SEQ));
						 .AND. SE2->E2_TIPO $ MVPAGANT+"/INA"
					 nTotbx+= SE5->E5_VALOR +If(lValPgto,SE5->E5_VRETPIS+ SE5->E5_VRETCOF + SE5->E5_VRETCSL + SE5->E5_VRETIRF+SE5->E5_VRETISS,0)
				Else
					nTotbx+= (cAlias)->E5_VALOR +If(lValPgto,(cAlias)->E5_VRETPIS+ (cAlias)->E5_VRETCOF + (cAlias)->E5_VRETCSL + (cAlias)->E5_VRETIRF+(cAlias)->E5_VRETISS,0) 
				Endif
				(cAlias)->( dbskip())
			EndDo  
		Endif
#ENDIF		

If lPccBaixa .and. !lRetorna
	nValBas+=SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL  
Endif

If lIRPFBaixa .and. !lRetorna
	nValBas+=SE2->E2_IRRF
Endif 
If lCalcIssBx.and. !lRetorna
	nValBas+=SE2->E2_ISS
Endif    
If nTotbx>0.and. !lRetorna
	nValBas-= nTotbx
Endif    

If lRetorna
	nValBas:= If(nTotbx>0,SE2->E2_BASEPIS-nTotbx,SE2->E2_BASEPIS) 		
Endif
  
RestArea(aAreaSE2)
RestArea(aAreaSE5)
                  
If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
Endif
Return nValBas


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA340   ºAutor  ³Pâmela Bernardo     º Data ³  23/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para definir valor limite de compensação             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA340                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F340LimCmp(nRecno,nBase,cChaveSE5,nPis,nCofins,nCsll,nIrf,nIss,nSaldoCmp) //recno do titulo principal

LOCAL cAlias 	:= GetNextAlias()   
Local nTotbx 	:= 0
Local aAreaSe2  := SE2->(GetArea())
Local nPropnf	:= 0
Local nVallim	:= 0
Local nValiq	:= 0 
//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
					 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
					 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
					 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local	lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
					    !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
					   	!Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) )    

Local lPropPA 	:= SuperGetMv("MV_COMPCP",,.F.) //Verifica se vai proporcionalizar quando PA>NF e PA liquido.
			   	

#IFDEF TOP
	Local nSE5  		:= 0
	Local cQuery	  	:= ""                      
	Local aStruSE5	  	:= {}

#ENDIF
           
Default nRecno:= SE2->(Recno())   
Default nBase := SE2->E2_BASEPIS 
Default cChaveSE5:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO) 
Default nPis 	:= SE2->E2_PIS 
Default nCofins := SE2->E2_COFINS
Default nCsll  	:= SE2->E2_CSLL
Default nIrf 	:= SE2->E2_IRRF
Default nIss 	:= SE2->E2_ISS
Default nSaldoCmp := SE2->E2_SALDO

dbSelectArea("SE2") 
SE2->(dbGoTo(nRecno))

#IFDEF	TOP
	
		If TcSrvType() != "AS/400"

			cQuery := "SELECT SE5.E5_FILIAL, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, "
			cQuery += "SE5.E5_TIPO, SE5.E5_CLIFOR, SE5.E5_LOJA, SE5.E5_SEQ, "
			cQuery += "SE5.E5_VALOR, E5_VRETPIS, E5_VRETCOF, E5_VRETCSL, E5_VRETIRF, E5_PRETIRF, E5_PRETPIS, E5_PRETCOF, E5_PRETCSL"
			cQuery += "FROM "+RetSqlName("SE5") + " SE5"
			cQuery += "WHERE "                                               
			cQuery += "SE5.E5_FILIAL = '"+xFilial("SE2")+"' AND "    
			cQuery += "SE5.E5_PREFIXO ='" + SE2->E2_PREFIXO +"' AND "
			cQuery += "SE5.E5_NUMERO = '" + SE2->E2_NUM +"' AND "
			cQuery += "SE5.E5_PARCELA ='" + SE2->E2_PARCELA +"' AND "
			cQuery += "SE5.E5_TIPO = '" + SE2->E2_TIPO +"' AND "
			cQuery += "SE5.E5_CLIFOR = '" + SE2->E2_FORNECE +"' AND "
			cQuery += "SE5.E5_LOJA = '" + SE2->E2_LOJA +"' AND "  
			cQuery += "SE5.E5_DOCUMEN = '" + cChaveSE5 +"' AND "
     		cQuery += "SE5.E5_MOTBX NOT IN ('FAT','IRF','PCC','LIQ','STP') AND "
			cQuery += "SE5.E5_RECPAG = 'P' AND "	
			cQuery += "SE5.E5_TIPODOC <>'ES' AND "		
		
			cQuery += "SE5.D_E_L_E_T_ = ' ' "
			
			cQuery := ChangeQuery(cQuery)
						
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAlias),.T.,.T.)		
		
			aStruSE5:= SE5->(dbStruct())

			For nSE5 := 1 To Len(aStruSE5)
				If aStruSE5[nSE5][2] <> "C" .and.  FieldPos(aStruSE5[nSE5][1]) > 0
					TcSetField((cAlias),aStruSE5[nSE5][1],aStruSE5[nSE5][2],aStruSE5[nSE5][3],aStruSE5[nSE5][4])
				EndIf
			Next nSE5	
		
			While (cAlias)->(!EOF())
					
				//Verifica se tem baixa cancelada
				If TemBxCanc((cAlias)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.F.)
					(cAlias)->( dbskip())
					loop
				EndIf  
					nTotbx+= (cAlias)->E5_VALOR-Iif(lIRPFBaixa,(cAlias)->E5_VRETIRF,0)
				(cAlias)->( dbskip())
			EndDo  
		Endif
#ENDIF		

If  nBase<SE2->E2_BASEPIS   
	nPropnf:= nBase/SE2->E2_BASEPIS
Else
	nPropnf:= 1
Endif
nValiq:= SE2->E2_VLCRUZ
If lPccBaixa .and. nPis+nCofins+nCsll>0 .AND. !(SE2->E2_TIPO $ MVPAGANT+"/INA") .and. lPropPA
	nValiq-= (SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL)
Endif
If lCalcIssBx .and. nIss>0 .AND. !(SE2->E2_TIPO $ MVPAGANT+"/INA").and. lPropPA
	nValiq-= SE2->E2_ISS
Endif
If nTotbx>0 
	nValLim:= (nValiq*nPropnf)- nTotbx
Else        
	If nBase < SE2->E2_BASEPIS .And. ((MVPAGANT $ cChaveSE5) .OR. ("INA" $ cChaveSE5))
		nValLim	:=	nSaldoCmp
	Else
		nValLim	:= MIN( ( nValiq * nPropnf ), nSaldoCmp )
	Endif			
Endif  
             
If SE2->E2_TIPO <> MVPAGANT
	nValLim := nValLim - SE2->E2_SDDECRE + SE2->E2_SDACRES
EndIf

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
Endif

RestArea(aAreaSE2)

Return nValLim
        
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³F340ForINA ³ Autor ³ Andre Lago           ³ Data ³ 14/05/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que Busca para o titulo passado os Fornecedor        ³±±
±±³          ³do titulo PAI     					  		  			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA090									  				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function F340ForINA( cPaiINS, cPaiINA )

Local aArBusca	:= GetArea()
Local lRet		:= .F.
Local cIndexC	:= ""
Local cCondicao1:= ""	
Local cKey1   	:= ""
Local nIndexC   := 0
Local cFilter   := ""   
Local cForINS   := ""
Local cLjINS    := ""
Local cForINA   := ""
Local cLjINA    := ""
Local cAliasB   := "__SE2"
Default cPaiINS	:= ""
Default cPaiINA	:= ""

If Select(cAliasB) <= 0
	SomaAbat("","","","P")
EndIf

If !Empty(cPaiINS)

	cFilter := (cAliasB)->(DbFilter())

	dbSelectArea(cAliasB)
	dbSetOrder(1)
	If dbSeek( xFilial("SE2")+cPaiINS )
		cForINS := E2_FORNECE
		cLjINS  := E2_LOJA
		If dbSeek( xFilial("SE2")+cPaiINA )
			cForINA := E2_FORNECE
			cLjINA  := E2_LOJA
        EndIf
        If cForINS+cLjINS == cForINA+cLjINA
			If F090PagINA( (cAliasB)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) )
				lRet := .T.
			EndIf
		EndIf
	EndIf
EndIf
        
#IFNDEF TOP
	FErase (cIndexC+OrdBagExt())
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SE2",cAliasB)
DbSelectArea(cAliasB)
Set Filter to &cFilter
RestArea( aArBusca )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tx10925	ºAutor  ³TOTVS			     º Data ³  13/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que retorna uma matriz com os titulos TXs gerados    º±±
±±º          ³a partir do titulo principal.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Financeiro                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Tx10925(cPrefixo,cNum,cParcela,cParcPis,cParcCof,cParCsll,lPaEmis,cParcIrf,lIRBaixa,lEstorno)

Local aArea     := GetArea()
Local aImpostos := {}
Local cTaxa     

Default cParcPis := ""
Default cParcCof := ""
Default cParCsll := ""    
Default lPaEmis  := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. ;
							(!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ;
							 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
							 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
							 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Default cParcIrf := ""
Default lIRBaixa := .F.

If !lPaEmis .and. SE2->E2_TIPO $ MVPAGANT+"/INA"
	cTaxa := MVTXA
Else
	cTaxa := MVTAXA
EndIF

// Seleciono SE2 com outro alias para efetuar a varredura dos impostos
If Select("__SE2") == 0
	ChkFile("SE2",.F.,"__SE2")
Else
	DbSelectArea("__SE2")
	DbGoTop()
EndIf

dbSetOrder(1)                                      

// Caso a parcela do PIS nao esteja em branco, busco pelo TX para carregar o array.
If !Empty(cParcPis)
	If (dbSeek(xFilial("SE2") + cPrefixo + cNum + cParcPis + cTAXA))
		If __SE2->E2_SALDO > 0 .or. lEstorno
			Aadd(aImpostos,{E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_VALOR,E2_SALDO,__SE2->(Recno()), "PIS"})
		Endif
	Endif
Endif
If Len(aImpostos) == 0
	Aadd(aImpostos,{})
Endif

// Caso a parcela do Cofins nao esteja em branco, busco pelo TX para carregar o array.     
If !Empty(cParcCof)
	If (dbSeek(xFilial("SE2") + cPrefixo + cNum + cParcCof + cTAXA))
		If __SE2->E2_SALDO > 0 .or. lEstorno
			Aadd(aImpostos,{E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_VALOR,E2_SALDO,__SE2->(Recno()), "COF"})
		Endif
	Endif
Endif                      
If Len(aImpostos) < 2
	Aadd(aImpostos,{})
Endif

// Caso a parcela do Csll nao esteja em branco, busco pelo TX para carregar o array.
If !Empty(cParCsll)
	If (dbSeek(xFilial("SE2") + cPrefixo + cNum + cParCsll + cTAXA))
		If __SE2->E2_SALDO > 0 .or. lEstorno
			Aadd(aImpostos,{E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_VALOR,E2_SALDO,__SE2->(Recno()), "CSL"})
		Endif
	Endif
Endif
If Len(aImpostos) < 3
	Aadd(aImpostos,{})
Endif

// Caso a parcela do IRRF nao esteja em branco, busco pelo TX para carregar o array.
If !Empty(cParcIrf) .and. ! lIRBaixa
	If (dbSeek(xFilial("SE2") + cPrefixo + cNum + cParcIrf + cTAXA))
		If __SE2->E2_SALDO > 0 .or. lEstorno
			Aadd(aImpostos,{E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_VALOR,E2_SALDO,__SE2->(Recno()), "IRF"})
		Endif
	Endif
Endif
If Len(aImpostos) < 4
	Aadd(aImpostos,{})
Endif

RestArea(aArea)

Return aImpostos


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa340BTxAuºAutor  ³Clovis Magenta      º Data ³  13/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Procura e carrega todos os impostos de um determinado titu-º±±
±±º          ³ lo a pagar. Não podem estar baixado para serem compensados º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Fa340BTxAu(aTitulos, nRecno, cSeqImp)
Local aArea 			:= GetArea()
Local aAreaSE2 		:= SE2->( GetArea() )
Local aTitMarkImp		:= {}
Local nX					:= 0
Local nPis				:= 0
Local nCofins			:= 0
Local nCsll				:= 0
Local nIR				:= 0
Local nValProp			:= 0
Local cAdiantamento	:= ""
Local cDocOriginal	:= ""
Local cForneceOri		:=	""
Local cLojaOri			:= ""
Local lDebito			:= .F.

/* Dados de aTítulos => Array com informações dos títulos selecionados na grid/mark */
/*
[1] E2_PREFIXO
[2] E2_NUM
[3] E2_PARCELA
[4] E2_TIPO
[5] Transform(Round(NoRound(xMoeda(E2_SALDO+nValImp+E2_SDACRES-E2_SDDECRE-nTotAbat,SE2->E2_MOEDA,nMoeda,,nDecs+1	,If(nMoeda        == 1,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ))
[6] Transform(nValComp-If(nValor<=0,nTotAbat,0),"@E 9999,999,999.99"),;
[7] E2_NOMFOR
[8] lMarca
[9] nValComp-If(nValor<=0,nTotAbat,0)
[10] Transform(xMoeda(E2_SDACRES,E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99")
[11] Transform(xMoeda(E2_SDDECRE,E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99")
[12] E2_EMISSAO
[13] E2_VENCREA
[14] E2_FORNECE
[15] E2_LOJA
[16] E2_FILIAL
*/

// CARREGO PRIMEIRAMENTE OS TITULOS TXA REFERENTES AOS MARCADOS NA MARKBROWSE. DEPOIS BAIXAREI ESTES TITULOS TXAS.
DbSelectArea("SE2")
DbSetOrder(1) // FILIAL + PREFIXO + NUMERO + PARCELA + TIPO + FORNECEDOR + LOJA
For nX:=1 to Len(aTitulos)
	If aTitulos[nX][8]
		If dbSeek(aTitulos[nX][16] + aTitulos[nX][1] + aTitulos[nX][2] + aTitulos[nX][3] + aTitulos[nX][4] + aTitulos[nX][14] + aTitulos[nX][15] )

			IF SE2->E2_TIPO $ MVPAGANT+"/INA"
				cAdiantamento	:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
				cForneceOri		:=	SE2->E2_FORNECE
				cLojaOri			:= SE2->E2_LOJA
//				lDebito 			:= .T.
			Else
				cDocOriginal	:= SE2->E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
			Endif

			nValProp := Round(( Val(aTitulos[nX][6]) / Val(aTitulos[nX][5])),2) // ---> valor compensado / valor liquido
			aadd(aTitMarkImp, Tx10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,,.F.) )
			aadd(aTitMarkImp[len(aTitMarkImp)], nValProp)
			aadd(aTitMarkImp[len(aTitMarkImp)], nX)
		Endif
	Endif
Next nX

// ********** TRECHO PARA BAIXAR TITULOS TX(A) REFERENTES AO TITULO PRINCIPAL SELECIONADO NO BROWSE *********** //
DbSelectArea("SE2")
SE2->(DbGoto(nRecno))

IF SE2->E2_TIPO $ MVPAGANT+"/INA"
	cAdiantamento	:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
	cForneceOri		:=	SE2->E2_FORNECE
	cLojaOri			:= SE2->E2_LOJA
	lDebito 			:= .T.
Else
	cDocOriginal	:= SE2->E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
Endif

aImp10925 := Tx10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,,.T.)
// FIM ********** TRECHO PARA BAIXAR TITULOS TXA REFERENTES AO TITULO PRINCIPAL SELECIONADO NO BROWSE *********** //

For nX:=1 to Len(aTitMarkImp)
	
	If Len(aTitMarkImp[nX][1])>0
		SE2->(DbGoTo(aTitMarkImp[nX][1][8]))
		nPis	:= aTitMarkImp[nX][1][7] * aTitMarkImp[nX][5]
		Reclock("SE2",.F.)
			E2_SALDO		-=	nPis
			E2_VALLIQ	+=	nPis
			E2_DTBAIXA	:=	dDataBase
			Fa340GrImp( nPis , cAdiantamento , cDocOriginal , cSeqImp,cForneceOri,cLojaOri,!lDebito)
		MsUnlock()

		If Len(aImp10925[3]) > 0
			SE2->(DbGoTo(aImp10925[1][8]))
			Reclock("SE2",.F.)
				E2_SALDO		-=	nPis
				E2_VALLIQ	+=	nPis
				E2_DTBAIXA	:=	dDataBase
				Fa340GrImp( nPis , cAdiantamento , cDocOriginal , cSeqImp,cForneceOri,cLojaOri,lDebito)
			MsUnlock()
		Endif
	Endif

	If Len(aTitMarkImp[nX][2])>0
		SE2->(DbGoTo(aTitMarkImp[nX][2][8]))
		nCofins := aTitMarkImp[nX][2][7] * aTitMarkImp[nX][5]
		Reclock("SE2",.F.)
			E2_SALDO		-=	nCofins
			E2_VALLIQ	+=	nCofins
			E2_DTBAIXA	:=	dDataBase
			Fa340GrImp( nCofins , cAdiantamento , cDocOriginal , cSeqImp,cForneceOri,cLojaOri,!lDebito)
		MsUnlock()

		If Len(aImp10925[3]) > 0
			SE2->(DbGoTo(aImp10925[2][8]))
			Reclock("SE2",.F.)
				E2_SALDO		-=	nCofins
				E2_VALLIQ	+=	nCofins
				E2_DTBAIXA	:=	dDataBase
				Fa340GrImp( nCofins , cAdiantamento , cDocOriginal , cSeqImp,cForneceOri,cLojaOri,lDebito)
			MsUnlock()
		Endif
	Endif

	If Len(aTitMarkImp[nX][3])>0
		SE2->(DbGoTo(aTitMarkImp[nX][3][8]))
		nCsll := aTitMarkImp[nX][3][7] * aTitMarkImp[nX][5]
		Reclock("SE2",.F.)
			E2_SALDO		-=	nCsll
			E2_VALLIQ	+=	nCsll
			E2_DTBAIXA	:=	dDataBase
			Fa340GrImp( nCsll , cAdiantamento , cDocOriginal , cSeqImp,cForneceOri,cLojaOri,!lDebito)
		MsUnlock()

		If Len(aImp10925[3]) > 0
			SE2->(DbGoTo(aImp10925[3][8]))
			Reclock("SE2",.F.)
				E2_SALDO		-=	nCsll
				E2_VALLIQ	+=	nCsll
				E2_DTBAIXA	:=	dDataBase
				Fa340GrImp( nCsll , cAdiantamento , cDocOriginal , cSeqImp,cForneceOri,cLojaOri,lDebito)
			MsUnlock()
		Endif
	Endif

	If Len(aTitMarkImp[nX][4])>0
		SE2->(DbGoTo(aTitMarkImp[nX][4][8]))
		nIR := aTitMarkImp[nX][4][7] * aTitMarkImp[nX][5]
		Reclock("SE2",.F.)
			E2_SALDO		-=	nIR
			E2_VALLIQ	+=	nIR
			E2_DTBAIXA	:=	dDataBase
			Fa340GrImp( nIR , cAdiantamento , cDocOriginal , cSeqImp,cForneceOri,cLojaOri,!lDebito)
		MsUnlock()

		If Len(aImp10925[4]) > 0
			SE2->(DbGoTo(aImp10925[4][8]))
			Reclock("SE2",.F.)
				E2_SALDO		-=	nIR
				E2_VALLIQ	+=	nIR
				E2_DTBAIXA	:=	dDataBase
				Fa340GrImp( nIR , cAdiantamento , cDocOriginal , cSeqImp,cForneceOri,cLojaOri,lDebito)
			MsUnlock()
		Endif

	Endif

Next nX
// FIM ********** TRECHO PARA BAIXAR TITULOS TXA REFERENTES AOS TITULO SELECIONADOS NO MARKBROWSE *********** //

Restarea(aAreaSE2)
Restarea(aArea)

Return

Function Fa340EstTX(aTitulos, nReg, cSeq, aKeysTx)

Local aArea 		:= GetArea()
Local aAreaSE2 	:= SE2->( GetArea() )
Local aTitMarkImp	:= {}
Local aImp10925	:= {}
Local nX				:= 0
Local nPis			:= 0
Local nCofins		:= 0
Local nCsll			:= 0
Local nIR			:= 0
Local nValProp		:= 0
Local nValorCP 	:= 0
Local cValorCP 	:= ""

/* Dados de aTítulos => Array com informações dos títulos selecionados na grid/mark */
/*
[1] E2_PREFIXO
[2] E2_NUM
[3] E2_PARCELA
[4] E2_TIPO
[5] Transform(Round(NoRound(xMoeda(E2_SALDO+nValImp+E2_SDACRES-E2_SDDECRE-nTotAbat,SE2->E2_MOEDA,nMoeda,,nDecs+1	,If(nMoeda        == 1,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ))
[6] Transform(nValComp-If(nValor<=0,nTotAbat,0),"@E 9999,999,999.99"),;
[7] E2_NOMFOR
[8] lMarca
[9] nValComp-If(nValor<=0,nTotAbat,0)
[10] Transform(xMoeda(E2_SDACRES,E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99")
[11] Transform(xMoeda(E2_SDDECRE,E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99")
[12] E2_EMISSAO
[13] E2_VENCREA
[14] E2_FORNECE
[15] E2_LOJA
[16] E2_FILIAL
*/

/* 
aKeysTx [1] -> 1 (titulos marcados)  /  2 (titulo principal selecionado)
aKeysTx [2] -> SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
*/

DbSelectArea("SE2")
DbSetOrder(1) // FILIAL + PREFIXO + NUMERO + PARCELA + TIPO + FORNECEDOR + LOJA
For nX:=1 to Len(aTitulos)
	If aTitulos[nX][10]
		If dbSeek(xFilial("SE2") + aTitulos[nX][6] )

			cValorCP := STRTRAN(aTitulos[nX][9] ,".", "")
			cValorCP := STRTRAN(cValorCP ,",", ".")
			nValorCP := Val(cValorCP)

			nValProp := Round(( nValorCP / SE2->E2_VALOR ),2) // ---> valor compensado / valor liquido
			aadd(aTitMarkImp, Tx10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,,.T. ) )
			aadd(aTitMarkImp[len(aTitMarkImp)], nValProp)
			aadd(aTitMarkImp[len(aTitMarkImp)], "") //aKeysTx[nX+1]
			aadd(aTitMarkImp[len(aTitMarkImp)], nValorCP)
		Endif
	Endif
Next nX

DbSelectArea('SE2')
SE2->(DbGoto(nReg))
aImp10925 := Tx10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL,,SE2->E2_PARCIR,,.T.)

For nX:=1 to Len(aTitMarkImp)

//PIS
	If Len(aTitMarkImp[nX][1])>0
		nPis := aTitMarkImp[nX][1][6] * aTitMarkImp[nX][5]
		SE2->(DbGoTo(aTitMarkImp[nX][1][8]))
		Reclock("SE2",.F.)
			E2_SALDO		+=	nPis
			E2_VALLIQ	-=	nPis
			E2_DTBAIXA	:=	dDataBase
		MsUnlock()

		F340DelMov()

		If Len(aImp10925[1]) > 0
			SE2->(DbGoTo(aImp10925[1][8]))
			Reclock("SE2",.F.)
				E2_SALDO		+=	nPis
				E2_VALLIQ	-=	nPis
				E2_DTBAIXA	:=	dDataBase
			MsUnlock()
			F340DelMov()
		Endif
	Endif


//COFINS
	If Len(aTitMarkImp[nX][2])>0
		nCofins := aTitMarkImp[nX][2][6] * aTitMarkImp[nX][5]
		SE2->(DbGoTo(aTitMarkImp[nX][2][8]))
		Reclock("SE2",.F.)
			E2_SALDO		+=	nCofins
			E2_VALLIQ	-=	nCofins
			E2_DTBAIXA	:=	dDataBase
		MsUnlock()

		F340DelMov()

		If Len(aImp10925[2]) > 0
			SE2->(DbGoTo(aImp10925[2][8]))
			Reclock("SE2",.F.)
				E2_SALDO		+=	nCofins
				E2_VALLIQ	-=	nCofins
				E2_DTBAIXA	:=	dDataBase
			MsUnlock()
			F340DelMov()
		Endif
		
	Endif


// CSLL
	If Len(aTitMarkImp[nX][3])>0
		nCsll := aTitMarkImp[nX][3][6] * aTitMarkImp[nX][5]
		SE2->(DbGoTo(aTitMarkImp[nX][3][8]))
		Reclock("SE2",.F.)
			E2_SALDO		+=	nCsll
			E2_VALLIQ	-=	nCsll
			E2_DTBAIXA	:=	dDataBase
		MsUnlock()

		F340DelMov()
		
		If Len(aImp10925[3]) > 0
			SE2->(DbGoTo(aImp10925[3][8]))
			Reclock("SE2",.F.)
				E2_SALDO		+=	nCsll
				E2_VALLIQ	-=	nCsll
				E2_DTBAIXA	:=	dDataBase
			MsUnlock()

			F340DelMov()
		Endif
	Endif

	//IR
	If Len(aTitMarkImp[nX][4])>0
		SE2->(DbGoTo(aTitMarkImp[nX][4][8]))
		nIR := aTitMarkImp[nX][4][6] * aTitMarkImp[nX][5]
		Reclock("SE2",.F.)
			E2_SALDO		+=	nIR
			E2_VALLIQ	-=	nIR
			E2_DTBAIXA	:=	dDataBase
		MsUnlock()

		F340DelMov()
		
		If Len(aImp10925[4]) > 0
			SE2->(DbGoTo(aImp10925[4][8]))
			Reclock("SE2",.F.)
				E2_SALDO		+=	nIR
				E2_VALLIQ	-=	nIR
				E2_DTBAIXA	:=	dDataBase
				
				F340DelMov()
			MsUnlock()
		Endif
		
	Endif

Next nX

Restarea(aAreaSE2)
Restarea(aArea)

Return



STATIC Function Fa340GrImp(nValor,cAdiantamento,cDocOriginal,cSequencia,cForneceOri,cLojaOri,lDebito)
Local aArea 			:= GetArea()

DEFAULT nValor 		:= 0
DEFAULT cAdiantamento:= ""
DEFAULT cDocOriginal := ""
DEFAULT cSequencia	:= "01"

If nValor > 0
	IF !lDebito

		RecLock("SE5",.T.)
		Replace E5_FILIAL 	With xFilial("SE5")
		Replace E5_DATA		With dDatabase
		Replace E5_VALOR		With nValor
		Replace E5_NATUREZ	With SE2->E2_NATUREZ
		Replace E5_RECPAG 	With "P"
		Replace E5_TIPO		With SE2->E2_TIPO
		Replace E5_TIPODOC 	With "CP"
		Replace E5_HISTOR  	With OemToAnsi( "Compens. Adiantamento" ) // "Compens. Adiantamento"

		// Grava fornecedor do titulo no movimento do PA, para ser utilizado no 
		// cancelamento da compensacao, quando se utiliza PA de outros fornecedores
		// para compensar.
		Replace E5_FORNADT 	With cForneceOri
		Replace E5_LOJAADT 	With cLojaOri

		Replace E5_LA			With "N"
		Replace E5_LOTE		With cLote
		Replace E5_PREFIXO	With SE2->E2_PREFIXO
		Replace E5_NUMERO 	With SE2->E2_NUM
		Replace E5_PARCELA	With SE2->E2_PARCELA
		Replace E5_CLIFOR 	With SE2->E2_FORNECE
		Replace E5_FORNECE 	With SE2->E2_FORNECE
		Replace E5_LOJA		With SE2->E2_LOJA
		Replace E5_BENEF		With SE2->E2_NOMFOR
		Replace E5_DTDIGIT	With dDataBase
		Replace E5_MOTBX		With "CMP"
		Replace E5_DTDISPO	With SE5->E5_DATA
		Replace E5_SEQ 		With cSequencia
		Replace E5_DOCUMEN	With cAdiantamento
		Replace E5_VLMOED2	With nValor
		Replace E5_FILORIG   With SE2->E2_FILORIG
		Replace E5_MOEDA	   With '01'

		MsUnlock()

	Else
		
		RecLock("SE5",.T.)
		Replace E5_FILIAL		With xFilial("SE5")
		Replace E5_DATA		With dDatabase
		Replace E5_VALOR		With nValor
		Replace E5_NATUREZ	With SE2->E2_NATUREZ
		Replace E5_RECPAG		With "P"
		Replace E5_TIPO		With SE2->E2_TIPO
		Replace E5_TIPODOC 	With "BA"           
		Replace E5_HISTOR		With OemToAnsi("Baixa por Compensacao") //"Baixa por Compensacao" 

		// Grava fornecedor do titulo no movimento do PA, para ser utilizado no 
		// cancelamento da compensacao, quando se utiliza PA de outros fornecedores
		// para compensar.
		Replace E5_FORNADT With cForneceOri
		Replace E5_LOJAADT With cLojaOri

		Replace E5_LA			With "N"
		Replace E5_PREFIXO	With SE2->E2_PREFIXO
		Replace E5_NUMERO		With SE2->E2_NUM
		Replace E5_PARCELA	With SE2->E2_PARCELA
		Replace E5_CLIFOR		With SE2->E2_FORNECE
		Replace E5_FORNECE	With SE2->E2_FORNECE
		Replace E5_LOJA		With SE2->E2_LOJA
		Replace E5_BENEF		With SE2->E2_NOMFOR
		Replace E5_DTDIGIT	With dDataBase
		Replace E5_MOTBX		With "CMP"
		Replace E5_DTDISPO	With SE5->E5_DATA
		Replace E5_DOCUMEN	With cDocOriginal
		Replace E5_SEQ 		With cSequencia
		Replace E5_VLMOED2	With nValor
		Replace E5_FILORIG   With SE2->E2_FILORIG
		Replace E5_MOEDA	   With '01'

		MsUnlock()

	Endif

Endif

RestArea(aArea)

Return

Function F340DelMov()
Local aArea 	:= GetArea()
Local aAreaSE5 := SE5->(GetArea())

//DEFAULT cChave := ""

dbSelectARea("SE5")
dbSetOrder(7)
If dbSeek(xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+cSeq)
	Reclock("SE5",.F.)
		SE5->(dbDelete())
	MsUnlock()
Endif

RestArea(aAreaSE5)
RestArea(aArea)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FaPesqBx ³ Autor ³Felipe Cunha            ³ Data ³19.10.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Checa se a compensacao do titulo foi gerada no momento da   ³±±
±±³          ³emissao do documento.Parametros devem ser o do titulo       ³±±
±±³          ³principal (Tipo de titulo = MVNOTAFIS).                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se a Compensacao foi realizada na geracao do  ³±±
±±³          ³Documento                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Filial do SE5                                        ³±±
±±³          ³ExpC2: Prefixo do titulo                                    ³±±
±±³          ³ExpC3: Numero do titulo                                     ³±±
±±³          ³ExpC4: Parcela do titulo                                    ³±±
±±³          ³ExpC5: Cliente/Fornecedor do titulo                         ³±±
±±³          ³ExpC6: Loja do titulo                                       ³±±
±±³          ³ExpC7: Tipo da baixa                                        ³±±
±±³          ³ExpD8: Data de emissao do titulo                            ³±±
±±³          ³ExpC9: Sequencia da baixa                                   ³±±
±±³          ³ExpC10: Carteira da baixa "R"/"P"                           ³±±
±±³          ³ExpC11: Numero do documento                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Esta rotina eh usada no contas a receber a pagar.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function FaPesqBx(cFilSE5,cPrefixo,cNum,cParcela,cCliFor,cLoja,cTipo,dDataE,cSeq,cCarteira,cDocumen,cTipoDoc)

Local aArea 	:= GetArea()
Local cQryAux 	:= ""
Local cFilorig 	:= ''
Local cCondicao := ""

#IFDEF TOP

	// localiza as baixa para o titulo principal por ordem de sequencia, para comparar com a quantidade de baixas ocorridas no momento da geracao do documento
	cQryAux	:= "SELECT E5_FILORIG "
	cQryAux += "FROM "+RetSqlName("SE5")+" "
	cQryAux += "WHERE E5_SEQ = '"+cSeq+"' "
	cQryAux += "AND E5_RECPAG   = '"+cCarteira+"' "
	cQryAux += "AND E5_SITUACA <> 'C' "
	cQryAux += "AND E5_DATA 	= '"+dTos(dDataE)+"' "
	cQryAux += "AND E5_NUMERO   = '"+cNum+"' "
	cQryAux += "AND E5_PREFIXO  = '"+cPrefixo+"' "
	cQryAux += "AND E5_PARCELA  = '"+cParcela+"' "
	cQryAux += "AND E5_CLIFOR   = '"+cCliFor+"' "
	cQryAux += "AND E5_LOJA     = '"+cLoja+"' "
	//cQryAux += "AND E5_TIPO     = '"+cTipo+"' "
	cQryAux += "AND E5_MOTBX    = 'CMP' "
	cQryAux += "AND E5_TIPODOC  = '"+cTipoDoc+"' "
	cQryAux += "AND D_E_L_E_T_  = ' ' "
	//cQryAux += "AND E5_DOCUMEN  = '"+cDocumen+"' " // considera somente as baixas que usaram este mesmo documento, ou seja, as baixas deste adiantamento
	cQryAux += "ORDER BY E5_FILIAL,E5_SEQ "
	cQryAux := ChangeQuery(cQryAux)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryAux),"__TRBSE5",.T.,.T.)
	
	If __TRBSE5->(!EOF())
		cFilorig := __TRBSE5->E5_FILORIG
	EndIf
	                
	__TRBSE5->(DbCloseArea())
#ELSE

	cCondicao := "E5_SEQ = '"+cSeq+"' "
	cCondicao += ".AND. E5_RECPAG   = '"+cCarteira+"' "
	cCondicao += ".AND. E5_SITUACA <> 'C' "
	cCondicao += ".AND. E5_DATA 	= '"+dToc(dDataE)+"' "
	cCondicao += ".AND. E5_NUMERO   = '"+cNum+"' "
	cCondicao += ".AND. E5_PREFIXO  = '"+cPrefixo+"' "
	cCondicao += ".AND. E5_PARCELA  = '"+cParcela+"' "
	cCondicao += ".AND. E5_CLIFOR   = '"+cCliFor+"' "
	cCondicao += ".AND. E5_LOJA     = '"+cLoja+"' "
	cCondicao += ".AND. E5_MOTBX    = 'CMP' "
	cCondicao += ".AND. E5_TIPODOC  = '"+cTipoDoc+"' "
	
	DBSelectArea("SE5")
	
	SE5->(DbSetfilter({||&cCondicao},cCondicao))
	If SE5->(!EOF())
		cFilorig := SE5->E5_FILORIG
	EndIf
	
	Set Filter to

#ENDIF

RestArea(aArea)

Return(cFilorig) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³GetInfSE5 ³ Autor ³Clovis Magenta         ³ Data ³26.10.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Pega as informações da SE5->E5_DOCUMEN e divide em partes   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aSE5: Array com as informações do SE5->E5_DOCUMEN           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cDoc: SE5->E5_DOCUMEN                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GetInfSE5(cDoc)
Local nPrefixo 	:= TamSX3("E2_PREFIXO")[1]
Local nNum		:= TamSX3("E2_NUM")[1]
Local nParcel	:= TamSX3("E2_PARCELA")[1]
Local nTipo		:= TamSX3("E2_TIPO")[1]
Local nFor		:= TamSX3("E2_FORNECE")[1]
Local nLoja		:= TamSX3("E2_LOJA")[1]
Local nCont		:= 1
Local aSE5		:= {}
Local nx		:= 0

Default cDoc := ""

For nX:=1 to 6
    Do Case
    	Case nX == 1
			Aadd(aSE5,substr(cDoc,1,nPrefixo ) )
			nCont += nPrefixo
    	Case nX == 2
			Aadd(aSE5,substr(cDoc,nCont,nNum ) )
			nCont += nNum
    	Case nX == 3
			Aadd(aSE5,substr(cDoc,nCont,nParcel ) )
			nCont += nParcel
    	Case nX == 4
			Aadd(aSE5,substr(cDoc,nCont,nTipo ) )
			nCont += nTipo
    	Case nX == 5
			Aadd(aSE5,substr(cDoc,nCont,nFor ) )
			nCont += nFor
    	Case nX == 6
			Aadd(aSE5,substr(cDoc,nCont,nLoja ) )

	EndCase

Next nX

Return aSE5


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fin340ExCMºAutor  ³Karen                º Data ³  28/08/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função que excluirá o registro de correção monetaria na SE5 º±±
±±º          ³ ao excluir uma compensacao                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fin340ExCM(cFilCmp, cSequen)
Local aArea 	:= GetArea()
Local aAreaSE5 	:= SE5->( GetArea() )
Local cChave	:= ""
DEFAULT cFilCmp := xFilial("SE5")
DEFAULT cSequen := SE5->E5_SEQ

SE5->(DbSetorder(7))
If SE5->( DbSeek(cFilCmp+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO) )
	cChave := cFilCmp+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO
	
	While cChave == SE5->(E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO )
		If SE5->E5_TIPODOC $ "VM;CM" .AND. cSequen == SE5->E5_SEQ
			RecLock("SE5")
				dbDelete() // Deve-se deletar, como é feito quando se tem histórico de baixas de um titulo a ser excluído.
			MsUnLock()
		EndIf
		SE5->(DbSkip())
	EndDo
Endif

RestArea(aAreaSE5)
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fin340SE5IRºAutor  ³Karen                º Data ³  28/08/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função irá verificar se ja houve baixa parcial pela compensacao º±±
±±º          ³ e se ja gravou nesta baixa o IR, para nao gravar 2x na SE5 º±±
±±º          ³ senão, o IR será somado mais de uma vez no saldo           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fin340SE5IR()
Local aArea 	:= GetArea()
Local aAreaSE5 	:= SE5->( GetArea() )
Local cQuery := ""
Local cTipodoc := "CP"
Local cTipodc	 := "BA"
Local lTop := .F.
Local nIrrf := 0

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		lTop := .T.
	EndIf
#ENDIF
If lTop
	
	cQuery := "SELECT E5_VRETIRF "
	cQuery += "FROM "+RetSqlName("SE5") + " SE5 "
	cQuery += "WHERE "
	cQuery += "SE5.E5_FILIAL = '"+xFilial("SE5")+"' AND "
	cQuery += "SE5.E5_PREFIXO = '" + SE2->E2_PREFIXO + "' AND "
	cQuery += "SE5.E5_NUMERO = '" + SE2->E2_NUM + "' AND "
	cQuery += "SE5.E5_PARCELA = '" + SE2->E2_PARCELA + "' AND "
	cQuery += "SE5.E5_TIPO = '" + SE2->E2_TIPO + "' AND "
	cQuery += "SE5.E5_CLIFOR = '" + SE2->E2_FORNECE + "' AND "
	cQuery += "SE5.E5_LOJA = '" + SE2->E2_LOJA + "' AND "
	cQuery += "(SE5.E5_TIPODOC = '"+cTipoDoc+"' OR "
	cQuery += "SE5.E5_TIPODOC = '"+cTipodc+"') AND "
	cQuery += "SE5.E5_MOTBX = 'CMP' AND "
	cQuery += "SE5.E5_RECPAG = 'P' AND "			
	cQuery += "SE5.D_E_L_E_T_ = ' ' AND "
	cQuery += "SE5.E5_DOCUMEN NOT IN ( SELECT E5_DOCUMEN FROM "+RetSqlName("SE5") + " SE5B "
	cQuery += "WHERE "
	cQuery += "SE5B.E5_FILIAL = '"+xFilial("SE5")+"' AND "
	cQuery += "SE5B.E5_prefixo = '"+ SE2->E2_PREFIXO + "' AND " 
    cQuery += "SE5B.e5_numero = '" + SE2->E2_NUM + "' AND "
    cQuery += "SE5B.e5_parcela = '" + SE2->E2_PARCELA + "' AND " 
    cQuery += "SE5B.e5_tipo = '" + SE2->E2_TIPO + "' AND "
    cQuery += "SE5B.e5_clifor = '" + SE2->E2_FORNECE + "' AND "
    cQuery += "SE5B.e5_loja = '" + SE2->E2_LOJA + "' AND "
    cQuery += "SE5B.e5_tipodoc = 'ES' AND "
    cQuery += "SE5B.e5_motbx = 'CMP' AND "
    cQuery += "SE5B.e5_recpag = 'R' AND "
    cQuery += "SE5B.d_e_l_e_t_ = ' ' )"
			
	cQuery := ChangeQuery(cQuery)
						
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)		
	
	If TRB->(!EOF())
		nIrrf := TRB->E5_VRETIRF
	EndIf
		
	TRB->(dbCloseArea())
		
Else
	
	SE5->(DbSetorder(7)) // E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ
	cChave := xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
	If SE5->( DbSeek(cChave) )

		While cChave == SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA )
			If (SE5->E5_TIPODOC == cTipoDoc .or. SE5->E5_TIPODOC == cTipodc) .And. SE5->E5_MOTBX = 'CMP' .And. SE5->E5_RECPAG = 'P'
				nIrrf := SE5->E5_VRETIRF  
				nReg := SE5->( RECNO() )
				If SE5->( DbSeek(cChave) )
					While cChave == SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA )
						If SE5->E5_TIPODOC == "ES" .And. SE5->E5_MOTBX = 'CMP' .And. SE5->E5_RECPAG = 'R'				
							nIrrf := 0
				            Exit
				        Endif
				        SE5->(DbSkip())
				    Enddo
				 Endif
				 SE5->( dbgoto(nReg) )
			     Exit
			EndIf 			
			SE5->(DbSkip())
		EndDo   
		
	Endif

EndIf

RestArea(aAreaSE5)
RestArea(aArea)

Return nIrrf
