#include "FINA450.ch"
#include "PROTHEUS.CH"
#include "FILEIO.CH"
#include "FWMVCDEF.CH"
#Include 'topconn.ch'
#include 'tbiconn.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINA450X	³ Autor ³ Rogerio O Candisani   ³ Data ³ 03/09/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Compensacao Pagar / Receber								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			Especifico Maxlove                                               ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FINA450X()												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FinA450X(nPosArotina,aAutoCab,nOpcAuto)
	Local lPanelFin := IsPanelFin()
	Local aPergs := {}
	Local nRegSE2 := SE2->(Recno())
	Local lRotAuto := (aAutoCab <> NIL)

	Private aRotina := MenuDef()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o n£mero do Lote 											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cLote
	Private cMarca := GetMark()
	Private lInverte
	Private cTipos := ""
	Private cCadastro := STR0004  //"Comp Pagar / Receber"
	Private cModSpb := "1"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Usado no Chile, indica se serao compensados titulos de credito ou de debito³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private nDebCred	:=	1
	Private lMsErroAuto := .f.
	Default nPosArotina := 0

	U_Fa450MotBx("CEC","COMP CARTE","ANSN")

	VALOR 		:= 0
	VALOR2		:= 0
	VALOR3		:= 0
	VALOR4		:= 0
	VALOR5		:= 0
	VLRINSTR    := 0

	SetKey (VK_F12,{|a,b| AcessaPerg("AFI450",.T.)})

	pergunte("AFI450",.F.)

	If nPosArotina > 0 // Sera executada uma opcao diretamento de aRotina, sem passar pela mBrowse
		dbSelectArea("SE2")
		nRegSE2 := Recno()
		bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
		Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina)
		MSGoto(nRegSE2)
	Else
		If lRotAuto
			If nOpcAuto == 3
				U_FA450CMP( "SE2", SE2->( Recno() ), Nil , Nil , aAutoCab  )
			ELseIf nOpcAuto == 4 .Or. nOpcAuto == 5
				U_FA450CAN( "SE2", SE2->( Recno() ), nOpcAuto, Nil, aAutoCab )
			EndIf
		Else
			mBrowse(6,1,22,75,"SE2",,,,,,U_Fa450Leg())
		Endif
	Endif

	dbSelectArea("SE5")
	dbSetOrder(1)	&& devolve ordem principal

	AtualTab()

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o	 ³FA450cmp	³ Autor ³ Wagner Xavier 		  ³ Data ³ 21/05/93 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Realiza a compensacao de titulos a pagar com receber		  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe	 ³ FA450CMP(ExpC1,ExpN1,ExpN2)										  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = Alias do arquivo											  ³±±
	±±³			 ³ ExpN1 = Numero do registro 										  ³±±
	±±³			 ³ ExpN2 = Opcao selecionada no menu								  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA450CMP(cAlias,nReg,nOpcx, aCpos , aAutoCab )
	Local lPanelFin := IsPanelFin()
	Local nCount		:= 0
	Local oDlg, oCbx, cMoeda450, aMoedas:={}, oDlg1
	Local oTotalP, oTotalR, oSelecP, oSelecR
	Local oMark
	Local nTamTitulo	:= TamSx3("E2_PREFIXO")[1]+TamSx3("E2_NUM")[1]+TamSx3("E2_PARCELA")[1]+TamSx3("E2_TIPO")[1]
	Local nTamChavE2	:= TamSx3("E2_FILIAL")[1]+TamSx3("E2_FORNECE")[1]+TamSx3("E2_LOJA")[1]+nTamtitulo
	Local nTamChavE1	:= nTamtitulo+TamSx3("E2_FILIAL")[1]
	Local nTamParc		:= TamSx3("E2_PARCELA")[1]
	Local nTamCod		:= TamSx3("E1_CLIENTE")[1]+TamSx3("E1_LOJA")[1]+1 //Tamanho do codigo do Cliente para browse
	Local nTamForn		:= TamSx3("E2_FORNECE")[1]
	Local nPosIniPref := TamSx3("E2_FILIAL")[1]+1
	Local nPosIniNum	:= TamSx3("E2_FILIAL")[1]+TamSx3("E1_PREFIXO")[1]+1
	Local nPosIniParc := TamSx3("E2_FILIAL")[1]+TamSx3("E1_PREFIXO")[1]+TamSx3("E2_NUM")[1]+1
	Local nPosIniLoja := TamSx3("E2_FILIAL")[1]+TamSx3("E2_PREFIXO")[1]+TamSx3("E2_NUM")[1]+TamSx3("E2_PARCELA")[1]+TamSx3("E2_TIPO")[1]+TamSx3("E2_FORNECE")[1]+1
	Local nRecAtu 		:= 0
	Local cChaveSE5	:= 0
	Local aTipoDoc		:= {}
	Local nX				:= 0
	Local nOrdAtu		:= 0
	Local lFA450BU	:= Existblock ("lFA450BU")
	Local cChaveTit	:= ""
	Local cChaveFK7	:= ""

//**********************
// tratamento ExecAuto *
//**********************
	Local aChaveRec := {}
	Local aChavePag	:= {}

	Local aCampos := {{"P_R"      ,"C", 1,0},;
		{"TITULO"   ,"C",nTamTitulo+3,0},;
		{"PAGAR"    ,"N",15,2},;
		{"RECEBER"  ,"N",15,2},;
		{"VLRPAG"     ,"N",15,2},;
		{"VLRREC"     ,"N",15,2},;
		{"EMISSAO"  ,"D", 8,0},;
		{"VENCTO"   ,"D", 8,0},;
		{"TIPO"     ,"C", 3,0},;
		{"MARCA"    ,"C", 2,0},;
		{"CHAVE"    ,"C",nTamChavE2,0},;
		{"PRINCIP"	,"N",15,2},;
		{"ABATIM"   ,"N",15,2},;
		{"JUROS"    ,"N",15,2},;
		{"MULTA"    ,"N",15,2},;
		{"DESCONT"	,"N",15,2},;
		{"ACRESC"   ,"N",15,2},;
		{"DECRESC"  ,"N",15,2},;
		{"CLIFOR"	,"C",nTamCod,0},;
		{"NOME"     ,"C",20,0}}
	//{"CHVVLR"	,"C",15,0},;
		//{"NOME"     ,"C",20,0}}

/*
Local aCpoBro	:= {{ "MARCA"		,, " ","  "},;
						{	"P_R"			,, STR0005,"!"},;   //"Carteira"
						{	"TITULO"		,, STR0006,"@X"},;  //"N£mero T¡tulo"
						{	"PAGAR"		,, STR0007,"@E 9,999,999,999.99"},;  //"Valor Pagar"
						{	"RECEBER"	,, STR0008,"@E 9,999,999,999.99"},;  //"Valor Receber"
						{	"EMISSAO"	,, STR0009,"@X"},;  //"Data EmissÆo"
						{	"VENCTO"		,, STR0010,"@X"},;  //"Data Vencimento"
						{  "TIPO"		,, STR0075,"@X"},;  //"Tipo"
						{	"PRINCIP"	,, STR0069,"@E 9,999,999,999.99"},; //"Saldo Titulo"
						{	"JUROS"		,, STR0070,"@E 9,999,999,999.99"},; //"Juros"
						{	"MULTA"		,, STR0071,"@E 9,999,999,999.99"},; //"Multa"
						{	"DESCONT"	,, STR0072,"@E 9,999,999,999.99"},; //"Descontos"
						{	"ACRESC"		,, STR0073,"@E 9,999,999,999.99"},; //"Acrescimos"
						{	"DECRESC"	,, STR0074,"@E 9,999,999,999.99"},; //"Decrescimos"
						{	"CLIFOR"		,, STR0076,"@X"},; //"Cli/For"
						{  "NOME"		,, STR0077,"@X"}}  //"Nome"
*/
	Local aCpoBro	:= {{ "MARCA"		,, " ","  "},;
		{	"P_R"			,, STR0005,"!"},;   //"Carteira"
	{   "TIPO"		,, STR0075,"@X"},;  //"Tipo"
	{	"TITULO"		,, STR0006,"@X"},;  //"N£mero T¡tulo"
	{	"PAGAR"		,, STR0007,"@E 9,999,999,999.99"},;  //"Valor Pagar"
	{	"RECEBER"	,, STR0008,"@E 9,999,999,999.99"},;  //"Valor Receber"
	{	"VLRPAG"		,, "Valor Pago","@E 9,999,999,999.99"},;  //"Valor Pago"
	{	"VLRREC"		,, "Valor Recebido","@E 9,999,999,999.99"},;  //"Valor Pago"
	{	"PRINCIP"	,, STR0069,"@E 9,999,999,999.99"},; //"Saldo Titulo"
	{   "NOME"		,, STR0077,"@X"},;  //"Nome"
	{	"VENCTO"		,, STR0010,"@X"},;  //"Data Vencimento"
	{	"EMISSAO"	,, STR0009,"@X"}}  //"Data EmissÆo"

	Local cNumComp := ''
	Local lPadrao := .F.
	Local cPadrao := "594"
	Local lCabec := .F.
	Local cIndex1, cIndex2
	Local cChave, nIndex
	Local lSai1, lSai2
	Local nOpca:=0
	Local nValMax := nValMaxR := nValMaxP := 0
	Local nRec,nRecTRB,lBaixou,lDigita,lAglut
	Local TRB	:= ""
	Local cLanca
	Local nA, cMoedaTx
	Local nDecs1  := MsDecimais(1)
	Local nValDia := 0
	Local aSE5Recs	:=	{}
	Local oFnt
	Local aBut450 := {}
	Local bSet16 := SetKey(16,{||U_Fa450Pesq(oMark)})
	Local bSet5 := SetKey(5,{||U_Fa450Edit(oSelecP,oSelecR,nTamChavE1,nTamChavE2)})
	Local aChaveLbn := {}
	Local aRet := {}
	Local aSize := {}
	Local aButtonTxt := {}
	Local aFlagCTB := {}
	Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	Local lProcessou := .T.
	Local lMsEAuto := .F.
	Local lFinVDoc	:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
	Local lFF450VCon  := ExistBlock( "FF450VCon")
	Local nRegSE1  := 0
	Local nRegSE2  := 0
	Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"
	Local lPccCC	:= SuperGetMV( "MV_CC10925" , , 1) == 2 .and. lPCCBaixa // Gera PCC na compensação entre carteiras quando PCC na baixa
	Local nBP10925 := SuperGetMv("MV_BP10925",.T.,"1") //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos
	Local nVl10925
	Local aBaixa := {}
	Local lPrimeiro:=.T. //validação do help de controle de docuemntos
	Local aAlt   := {}

// Variaveis do Model para atualizar o movimento bancario
	Local oModelMov
	Local oSubFK1
	Local oSubFK5
	Local oSubFK7
	Local oSubFK3
	Local oSubFK4
	Local cLog := ""
	Local cChaveTit
	Local cOrig
	Local cIdDoc:= ""
	Local cIdMov
	Local cIdFK4:= ""
	Local cCamposE5:=""
	Local aOrdem :={}
	Local oOrdem
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LoteCont( "FIN" )
	Private nLim450 := 0
	Private lF450Auto :=(aAutoCab <> NIL)
	Private nTamNum := TamSx3("E1_NUM")[1]
	Private nMoeda := 0
	Private nProRata := 0
	Private nCM1 := 0
	Private dVenIni450, dVenFim450
	Private cCli450, cLjCli, cFor450, cLjFor
	Private nSelecP := nSelecR := nTotalP := nTotPCC := nTotalR := nTotal := 0
	Private dBaixa, cBanco, cAgencia, cConta, cCheque
	Private cPortado, cNumBor
	Private cLoteFin, cArquivo
	Private nDescont:=0, nAbatim:=0, nJuros:=0, nMulta:=0
	Private cMotBX, lDesconto, cHist070
	Private nValRec:=0, nTotAbat:=0, nDespes:=0
	Private nValCC:=0, nValPgto:=0
	Private aTxMoedas	:=	{}
	Private nDifCambio  := 0
	Private nCM			:= 0
	Private nAcresc	:= 0
	Private nDecresc	:= 0
	Private lTitFuturo := .F.
//Default lIntegracao := IF(GetMV("MV_EASYFIN")=="S",.T.,.F.)		//uso pela FINA080

//Reestruturacao SE5
	PRIVATE nDescCalc 	:= 0
	PRIVATE nJurosCalc 	:= 0
	PRIVATE nMultaCalc 	:= 0
	PRIVATE nCorrCalc	:= 0
	PRIVATE nDifCamCalc	:= 0
	PRIVATE nImpSubCalc	:= 0
	PRIVATE nPisCalc	:= 0
	PRIVATE nCofCalc	:= 0
	PRIVATE nCslCalc	:= 0
	PRIVATE nIrfCalc	:= 0
	PRIVATE nIssCalc	:= 0
	PRIVATE nPisBaseR 	:= 0
	PRIVATE nCofBaseR	:= 0
	PRIVATE nCslBaseR 	:= 0
	PRIVATE nIrfBaseR 	:= 0
	PRIVATE nIssBaseR 	:= 0
	PRIVATE nPisBaseC 	:= 0
	PRIVATE nCofBaseC 	:= 0
	PRIVATE nCslBaseC 	:= 0
	PRIVATE nIrfBaseC 	:= 0
	PRIVATE nIssBaseC 	:= 0


	DEFINE FONT oFnt NAME "Arial" SIZE 12,14 BOLD

// Zerar variaveis para contabilizar os impostos da lei 10925.
	VALOR5 := 0
	VALOR6 := 0
	VALOR7 := 0

//cCli450	:= CriaVar("E1_CLIENTE")
//cLjCli		:= CriaVar("E1_LOJA")
	cOrdem	    :=""
	cTpDoc		:= CriaVar("E2_TIPO")
	cFor450	:= CriaVar("E2_FORNECE")
	cLjFor		:= CriaVar("E2_LOJA")
	dVenIni450	:= Ctod("  /  /  ")
	dVenFim450	:= Ctod("  /  /  ")
	dEmiIni450	:= Ctod("  /  /  ")
	dEmiFim450	:= Ctod("  /  /  ")

//informações do cliente - 25/09/16
	dCliIniVen	:= Ctod("  /  /  ")
	dCliFimVen	:= Ctod("  /  /  ")
	dCliIniEmi	:= Ctod("  /  /  ")
	dCliFimEmi	:= Ctod("  /  /  ")
	cTpDocCli	:= CriaVar("E1_TIPO")
	cPrefixo	:= CriaVar("E1_PREFIXO")
	cPrefFor	:= CriaVar("E2_PREFIXO")

//ordenação dos registros
//AAdd( aOrdem, "Valor Receber" )		
	AAdd( aOrdem, "Valor" )

	If !CtbValiDt(,dDatabase,,,,{"FIN001","FIN002"},)
		Return
	EndIf

	If ExistBlock("F450BROW")
		aRet    := ExecBlock("F450BROW",.F.,.F.,{aCampos,aCpoBro})
		aCampos := aRet[1]
		aCpoBro := aRet[2]
	Endif

	If cPaisLoc <> "BRA"
		Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1")})
		For nA	:=	2	To MoedFin()
			cMoedaTx	:=	Str(nA,IIf(nA <= 9,1,2))
			If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
				Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),RecMoeda(dDataBase,nA),PesqPict("SM2","M2_MOEDA"+cMoedaTx) })
			Else
				Exit
			Endif
		Next
	EndIf

	AADD(aBut450,{"PESQUISA",{||U_Fa450Pesq(oMark)}, STR0053,STR0001}) //"Pesquisar..(CTRL-P)"###"Pesquisar"
//AADD(aBut450,{"NOTE",{||U_Fa450Edit(oSelecP,oSelecR,nTamChavE1,nTamChavE2)}, STR0052,STR0081}) //"Edita Registro..(CTRL-E)"###"Editar"

	If  lFA450BU
		aBut450:=ExecBlock("lFA450BU",.F.,.F.,{aBut450})
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega funcao Pergunte												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetKey (VK_F12,{|a,b| AcessaPerg("AFI450",.T.)})
	pergunte("AFI450",.F.)

	lPadrao:=VerPadrao(cPadrao)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa array com as moedas existentes.						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aMoedas := FDescMoed()

//Abertura dos arquivos para utilizacao nas funcoes SumAbatPag e SumAbatRec
//Se faz necessario devido ao controle de transacao nao permitir abertura de arquivos
	If Select("__SE1") == 0
		ChkFile("SE1",.F.,"__SE1")
	Endif
	If Select("__SE2") == 0
		ChkFile("SE2",.F.,"__SE2")
	Endif
	dbSelectArea(cAlias)


	While .T.

		nSelecP := nSelecR := nTotalP := nTotalR := 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica numero do ultimo Bordero                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNumComp	:= Soma1(GetMv("MV_NUMCOMP"),6)

		While !MayIUseCode("IDENTEE"+xFilial("SE1")+cNumComp)  	//Verifica se esta sendo usado por outro usuario
			cNumComp := Soma1(cNumComp)									//Busca o proximo numero disponivel
		EndDo

		dbSelectArea(cAlias)
		nOpca := 0

		DEFINE FONT oFnt NAME "Arial" SIZE 12,14 BOLD

		If !lF450Auto
			aSize := MSADVSIZE()
			If lPanelFin  //Chamado pelo Painel Financeiro
				dbSelectArea(cAlias)
				oPanelDados := FinWindow:GetVisPanel()
				oPanelDados:FreeChildren()
				aDim := DLGinPANEL(oPanelDados)
				DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
				oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³
				//³ -------------------------------------------------------------- ³
				//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
				//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
				//³ tracao e redivisao por 2 para a centralizacao. 					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 195) /2
				nEspLin  := 0

			Else
				nEspLarg := 5
				nEspLin  := 3

				//DEFINE MSDIALOG oDlg FROM	113, 33 TO 500,548 TITLE cCadastro PIXEL
				DEFINE MSDIALOG oDlg FROM	100, 30 TO 500,800 TITLE cCadastro PIXEL
			Endif

			oDlg:lMaximized := .F.
			oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
			oPanel:Align := CONTROL_ALIGN_ALLCLIENT

			@ nEspLin   , nEspLarg TO 17+nEspLin , 348+nEspLarg OF oPanel	PIXEL
			@ 18+nEspLin, nEspLarg TO 100+nEspLin, 348+nEspLarg OF oPanel	PIXEL
			nEspLarg := nEspLarg -3

			//LABLES
			@ 06+nEspLin, 007+nEspLarg	SAY STR0018 SIZE 25, 7 OF oPanel PIXEL	//"N£mero"

			@ 20+nEspLin, 045+nEspLarg 	SAY "Vencimento Fornecedor" SIZE 60, 10 OF oPanel PIXEL
			@ 20+nEspLin, 150+nEspLarg	SAY "Prefixo"               SIZE 60, 10 OF oPanel PIXEL
			@ 20+nEspLin, 245+nEspLarg  SAY "Emissao Fornecedor"    SIZE 60, 10 OF oPanel PIXEL

			@ 28+nEspLin, 010+nEspLarg	SAY STR0021 SIZE 15, 10 OF oPanel PIXEL  //"De:"
			@ 28+nEspLin, 075+nEspLarg	SAY STR0022 SIZE 15, 10 OF oPanel PIXEL  //"At‚:"
			@ 28+nEspLin, 160+nEspLarg	SAY STR0021 SIZE 15, 10 OF oPanel PIXEL  //"De:"
			@ 28+nEspLin, 225+nEspLarg	SAY STR0022 SIZE 15, 10 OF oPanel PIXEL  //"At‚:"

			@ 45+nEspLin, 010+nEspLarg	SAY "Tipo Doc Forn" SIZE 40, 10 OF oPanel PIXEL
			@ 45+nEspLin, 045+nEspLarg	SAY "Ordenar por"   SIZE 40, 10 OF oPanel PIXEL
			@ 45+nEspLin, 115+nEspLarg	SAY STR0024 SIZE 55, 10 OF oPanel PIXEL  //"Fornecedor"
			@ 45+nEspLin, 175+nEspLarg	SAY STR0063 SIZE 15, 10 OF oPanel PIXEL  //"Loja"

			//@ 67+nEspLin, 007+nEspLarg	SAY STR0025 SIZE 22, 7 OF oPanel PIXEL  //"Moeda"

			//GETS
			@ 06+nEspLin, 035+nEspLarg	SAY	cNumComp 	Picture "@!" SIZE 60, 10 OF oPanel PIXEL  FONT oFnt COLOR CLR_HBLUE

			@ 27+nEspLin, 020+nEspLarg	MSGET dVenIni450	Valid If(nOpca<>0,!Empty(dVenIni450),.T.) ;
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 27+nEspLin, 090+nEspLarg	MSGET dVenFim450	Valid If(nOpca<>0,(!Empty(dVenFim450) .And. ;
				U_450DATA(dVenIni450,dVenFim450)),.T.);
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 27+nEspLin, 150+nEspLarg	MSGET cPrefFor	SIZE 30, 10 OF oPanel PIXEL


			@ 27+nEspLin, 215+nEspLarg	MSGET dEmiIni450	Valid If(nOpca<>0,!Empty(dEmiIni450),.T.) ;
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 27+nEspLin, 285+nEspLarg	MSGET dEmiFim450	Valid If(nOpca<>0,(!Empty(dEmiFim450) .And. ;
				U_450DATAe(dEmiIni450,dEmiFim450)),.T.);
				SIZE 50, 10 OF oPanel PIXEL Hasbutton

			@ 52+nEspLin, 010+nEspLarg	MSGET cTpDoc		F3 "05";
				SIZE 30, 10 OF oPanel PIXEL Hasbutton
			@ 52+nEspLin, 045+nEspLarg	MSCOMBOBOX oOrdem VAR cOrdem ITEMS aOrdem SIZE 65, 10 OF oPanel PIXEL
			@ 52+nEspLin, 115+nEspLarg	MSGET cFor450		F3 "FOR" ;
				Valid If(nOpca<>0,FA450For(cFor450),.T.) ;
				SIZE 60, 10 OF oPanel PIXEL Hasbutton
			@ 52+nEspLin, 175+nEspLarg	MSGET cLjFor		Picture "@!" ;
				Valid If(nOpca<>0,FA450For(cFor450,cLjFor),.T.) ;
				SIZE 20, 10 OF oPanel PIXEL

			//Cliente - candisani
			@ 103+nEspLin, nEspLarg+3 TO 180+nEspLin, 348+nEspLarg+3 OF oPanel	PIXEL

			@ 105+nEspLin, 045+nEspLarg SAY "Vencimento Cliente" SIZE 60, 10 OF oPanel PIXEL
			@ 105+nEspLin, 200+nEspLarg SAY "Emissao Cliente"    SIZE 60, 10 OF oPanel PIXEL

			@ 115+nEspLin, 010+nEspLarg	SAY STR0021 SIZE 15, 10 OF oPanel PIXEL  //"De:"
			@ 115+nEspLin, 075+nEspLarg	SAY STR0022 SIZE 15, 10 OF oPanel PIXEL  //"At‚:"
			@ 115+nEspLin, 160+nEspLarg	SAY STR0021 SIZE 15, 10 OF oPanel PIXEL  //"De:"
			@ 115+nEspLin, 225+nEspLarg	SAY STR0022 SIZE 15, 10 OF oPanel PIXEL  //"At‚:"


			@ 140+nEspLin, 010+nEspLarg	SAY "Tipo Doc Cli" SIZE 40, 7 OF oPanel PIXEL
			@ 140+nEspLin, 045+nEspLarg	SAY "Prefixo" SIZE 40, 7 OF oPanel PIXEL

			//GETS

			@ 115+nEspLin, 020+nEspLarg	MSGET dCliIniVen	Valid If(nOpca<>0,!Empty(dCliIniVen),.T.) ;
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 115+nEspLin, 090+nEspLarg	MSGET dCliFimVen	Valid If(nOpca<>0,(!Empty(dCliFimVen) .And. ;
				U_450DATA(dCliIniVen,dCliFimVen)),.T.);
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 115+nEspLin, 170+nEspLarg	MSGET dCliIniEmi	Valid If(nOpca<>0,!Empty(dCliIniEmi),.T.) ;
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 115+nEspLin, 240+nEspLarg	MSGET dCliFimEmi	Valid If(nOpca<>0,(!Empty(dCliFimEmi) .And. ;
				U_450DATAe(dCliIniEmi,dCliFimEmi)),.T.);
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 152+nEspLin, 010+nEspLarg	MSGET cTpDocCli		F3 "05";
				SIZE 30, 10 OF oPanel PIXEL Hasbutton
			@ 152+nEspLin, 045+nEspLarg	MSGET cPrefixo	SIZE 30, 10 OF oPanel PIXEL


			//outros
			@ 73+nEspLin, 106+nEspLarg RADIO oRadio VAR nDebCred ITEMS STR0067,STR0068  SIZE 80,10 OF oPanel PIXEL //'Compensar titulos de debito'#'Compensar titulos de credito'

			@ 74+nEspLin, 006+nEspLarg	MSCOMBOBOX oMoeda VAR cMoeda450 ITEMS aMoedas SIZE 80, 10 OF oPanel PIXEL

			@ 86+nEspLin,006+nEspLarg CHECKBOX oTitFuturo VAR lTitFuturo  PROMPT STR0088 FONT oDlg:oFont SIZE 89,11 OF oPanel PIXEL 	//"Titulos com Emissão Futura"



			If lPanelFin  //Chamado pelo Painel Financeiro
				If cPaisLoc <> "BRA"
					AADD(aButtonTxt,{STR0064,STR0064, {||Fa450SetMo()}})
				Endif

				ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
					{|| nOpca:=1,Iif(U_FA450OK(),oDlg:End(), nOpca := 0)},;
					{|| nOpca:=0,oDlg:End()},,aButtonTxt)

			Else
				If cPaisLoc <> "BRA"
					@ 47, 220 BUTTON STR0064 SIZE 32,18 ACTION (Fa450SetMo()) OF oPanel PIXEL //Taxas Moedas
				EndIf

				DEFINE SBUTTON FROM 09, 360 TYPE 1 ENABLE OF oPanel ACTION ( nOpca:=1,Iif(U_FA450OK(),oDlg:End(), nOpca := 0))
				DEFINE SBUTTON FROM 22, 360 TYPE 2 ENABLE OF oPanel ACTION ( nOpca:=0,oDlg:End())

				ACTIVATE MSDIALOG oDlg CENTERED
			Endif
		Else
			//************************************
			// tratamento para Rotina Automatica *
			//************************************
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTDVENINI450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="D"
				dVenIni450	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTDVENFIM450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="D"
				dVenFim450	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTNLIM450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="N"
				nLim450	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTCCLI450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="C"
				cCli450	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTCLJCLI'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="C"
				cLjCli	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTCFOR450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="C"
				cFor450	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTCLJFOR'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="C"
				cLjFor	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTCMOEDA450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="C"
				cMoeda450	:=	aAutoCab[nT,2]
			Else
				cMoeda450 := "01"
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTNDEBCRED'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="N"
				nDebCred	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTLTITFUTURO'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="L"
				lTitFuturo	:=	aAutoCab[nT,2]
			EndIf
			// valida parametros da ExecAuto
			If !U_Fa450OK()
				nOpca:=0
				lMsErroAuto := .F.
			Else
				nOpca:=1
			Endif
		EndIf

		If nOpca == 0
			lProcessou := .F.
			Exit
		EndIF
		nMoeda := Val(Substr(cMoeda450,1,2))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra o arquivo SE1													  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")
		cIndex1	:= CriaTrab(nil,.f.)
		cChave	:= IndexKey()
		IndRegua("SE1",cIndex1,cChave,,U_FA450Chec1(lTitFuturo),STR0026)  //"Selecionando Registros..."
		nIndex := RetIndex("SE1")
		#IFNDEF TOP
			dbSetIndex(cIndex1+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)
		dbGoTop()

		lSai1 := .F.
		If SE1->( BOF() ) .and. SE1->( EOF() )
			lSai1 := .T.
			#IFDEF TOP
				dbSelectArea("SE1")
				Set Filter To
				dbSetOrder(1)
			#ENDIF
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra o arquivo SE2													  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE2")
		cIndex2	:= CriaTrab(nil,.f.)
		cChave1	:= IndexKey()
		IndRegua("SE2",cIndex2,cChave1,,U_FA450Ch2(lTitFuturo),STR0026)  //"Selecionando Registros..."
		nIndex := RetIndex("SE2")

		#IFNDEF TOP
			dbSetIndex(cIndex2+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)
		dbGoTop()

		lSai2 := .F.
		If SE2->( BOF() ) .and. SE2->( EOF() )
			lSai2 := .T.
			#IFDEF TOP
				dbSelectArea("SE2")
				Set Filter To
				dbSetOrder(1)
			#ENDIF
		EndIf

		If (lSai1 .Or. lSai2) .AND. !lF450Auto
			Help(" ",1,"RECNO")
			Loop
		EndIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria Arquivo Temporario							 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TRB := U_Fa450Gerarq(aCampos)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega Registros do Arquivo Temporario		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_Fa450Repl(TRB)

		//***************************************
		// Trata chaves que foram enviadas pela *
		// rotina automatica para compensar.    *
		//***************************************
		If lF450Auto
			If (nT := ascan(aAutoCab,{|x| x[1]='AUTARECCHAVE'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="A"
				//TRB->CHAVE 	= SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
				aChaveRec	:=	aAutoCab[nT,2]
			EndIf
			If (nT := ascan(aAutoCab,{|x| x[1]='AUTAPAGCHAVE'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="A"
				//TRB->CHAVE 	= SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
				aChavePag	:=	aAutoCab[nT,2]
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Browse do arquivo temporario 						³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nOpca   := 0
		dbSelectArea("TRB")
		DBEVAL({ |a| U_FA450DBEVA(nLim450,,aChaveLbn, aChavePag , aChaveRec,@lPrimeiro )})
		dbGotop()

		If !lF450Auto
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz o calculo automatico de dimensoes de objetos     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aSize := MSADVSIZE()

			DEFINE MSDIALOG oDlg1 TITLE STR0027 From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL //"Compensa‡Æo Entre Carteiras"
			oDlg1:lMaximized := .T.

			oPanel := TPanel():New(0,0,'',oDlg1,, .T., .T.,, ,20,20,.T.,.T. )
			oPanel:Align := CONTROL_ALIGN_TOP

			@003, 005 Say STR0066 	FONT oDlg1:oFont PIXEL OF oPanel  //"Compensacao Nr. "
			@003, 060 Say cNumComp Picture "@!"	FONT oFnt COLOR CLR_HBLUE PIXEL OF oPanel
			// Panel
			////////

			/////////////
			// MarkBrowse
			oMark := MsSelect():New("TRB","MARCA","",aCpoBro,@lInverte,@cMarca,{50,oDlg1:nLeft,oDlg1:nBottom,oDlg1:nRight})
			oMark:bMark := {| | U_Fa450Disp(cMarca,lInverte,oTotalP,oTotalR,oSelecP,oSelecR)}
			oMark:oBrowse:lhasMark = .t.
			oMark:oBrowse:lCanAllmark := .t.
			oMark:bAval	:= {||	U_FA450Inverte(cMarca,oTotalP,oTotalR,oSelecP,oSelecR, .F., aChaveLbn),;
				oMark:oBrowse:Refresh(.t.)}

			oMark:oBrowse:bAllMark := { || U_FA450Inverte(cMarca,oTotalP,oTotalR, oSelecP,oSelecR, .T., aChaveLbn)}
			oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
			// MarkBrowse
			/////////////

			////////
			// Panel 2
			oPanel2 := TPanel():New(0,0,'',oDlg1,, .T., .T.,, ,40,40,.T.,.T. )

			If ! lPanelFin
				oPanel2:Align := CONTROL_ALIGN_BOTTOM
			Endif

			@003,060	Say STR0028 FONT oDlg1:oFont PIXEL OF oPanel2 //"Pagar"
			@003,200	Say STR0029 FONT oDlg1:oFont PIXEL OF oPanel2 //"Receber"

			@012,005	Say STR0030 FONT oDlg1:oFont PIXEL OF oPanel2 //"Total Exibido :"
			@012,060 Say oTotalP VAR nTotalP 	Picture "@E 999,999,999,999,999.99" FONT oDlg1:oFont PIXEL OF oPanel2
			@012,200 Say oTotalR VAR nTotalR 	Picture "@E 999,999,999,999,999.99" FONT oDlg1:oFont PIXEL OF oPanel2

			@021,005	Say STR0031 FONT oDlg1:oFont PIXEL OF oPanel2 //"Total Selecionado :"
			@021,060 Say oSelecP VAR nSelecP 	Picture "@E 999,999,999,999,999.99" FONT oDlg1:oFont PIXEL OF oPanel2
			@021,200	Say oSelecR VAR nSelecR 	Picture "@E 999,999,999,999,999.99" FONT oDlg1:oFont PIXEL OF oPanel2
			// Panel
			////////

			If lPanelFin  //Chamado pelo Painel Financeiro
				ACTIVATE MSDIALOG oDlg1 ON INIT ( FaMyBar(oDlg1, {|| nOpca := 1,oDlg1:End()},;
					{|| nOpca := 2,oDlg1:End()},aBut450),oPanel2:Align := CONTROL_ALIGN_BOTTOM) CENTERED
			Else
				ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,	{|| nOpca := 1,oDlg1:End()},;
					{|| nOpca := 2,oDlg1:End()},,aBut450)
			Endif

		Else
			nOpca   := 1
		EndIf

		If lFF450VCon .And. nOpca == 1
			nOldOpca := nOpca
			nOpca  	:= ExecBlock( "FF450VCon", .F., .F. )
			If nOpca == Nil
				nOpca := nOldOpca
			EndIf
		EndIf

		SetKey(16,bSet16)
		SetKey(5,bSet5)

		If nOpca == 0
			lProcessou := .F.
			Exit
		EndIf

		If nSelecP == 0 .Or. nSelecR == 0
			lProcessou := .F.
			Exit
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Integracao com o SIGAPCO para lancamento via processo³
		//³PcoIniLan("000018")                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoIniLan("000018")


		If nOpcA == 1 .and. U_VrPdComp(nSelecP, nSelecR, nTamChavE2)

			dbSelectArea("TRB")
			dbGotop( )

			If nSelecP > nSelecR
				nValMax := nSelecR
			Else
				nValMax := nSelecP
			EndIf

			nValMaxR := nValMaxP := nValMax

			Begin Transaction

				While ! Eof()
					lBaixou := .F.

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Registro do Contas a Receber 	  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If TRB->MARCA == cMarca
						nValRec	:= 0
						nValPgto := 0

						If !Empty(TRB->RECEBER)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Procura registro no SE1											 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dbSelectArea("SE1")
							dbSetOrder(1)
							dbSeek(Substr(TRB->CHAVE,1,nTamChavE1))
							dbSelectArea("TRB")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Inicializa variaveis para baixa 								 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dBaixa		:= dDataBase
							cBanco		:= cAgencia := cConta := cBenef :=	cCheque	:= " "
							cPortado 	:= cNumBor		:= " "
							cLoteFin 	:= " "
							nDescont 	:= nAbatim := nJuros := nMulta := nCm := 0
							cMotBX		:= "CEC"             // Compensacao Entre Carteiras
							lDesconto	:= .F.
							StrLctPad   := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Calcula valor a ser baixado										 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nRec			:= SE1->(Recno())
							nRecTRB		:= TRB->(Recno())
							dbSelectArea("SE1")
							//TRB->CHAVE 	= SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
							nTotAbat 	:= SumAbatRec(Substr(TRB->CHAVE,nPosIniPref,3),Substr(TRB->CHAVE,nPosIniNum,nTamNum),;
								Substr(TRB->CHAVE,nPosIniParc,nTamParc),nMoeda,"S",dDataBase)

							SE1->(dbGoto(nRec))
							dbSelectArea("TRB")
							TRB->(dbGoto(nRecTRB))
							nValRec		:= RECEBER
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Se n„o for baixar total o titulo, desconsidera abatimento³
							//³ no calculo do valor recebido.  Zera-se nTotAbat pois ele ³
							//³ j  est  somado no nValRec e seria somado novamente na    ³
							//³ gravacao da baixa (FA070GRV()).                          ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nValRec > nValMaxR
								nValRec := nValMaxR
								nTotAbat:=0
							EndIf
							nValMaxR 	-= nValRec
							nValEstrang := nValRec
							nAcresc		:= SE1->E1_SDACRES
							nDecresc	:= SE1->E1_SDDECRE
							nDescont	:= xMoeda(DESCONT,nMoeda,1,dDataBase)
							nJuros		:= xMoeda(JUROS,nMoeda,1,dDataBase)
							nMulta		:= xMoeda(MULTA,nMoeda,1,dDataBase)
							nTxMoeda	:= SE1->E1_TXMOEDA
							// Converte para poder baixar
							If cPaisLoc == "BRA"
								nValRec	:= xMoeda(nValRec,nMoeda,1,dDataBase)
								FA070CORR(nValEstrang,0)
							Else
								nValDia		:= Round(xMoeda(nValRec,nMoeda,1,dDataBase,nDecs1+1,nTxMoeda),nDecs1)
								nValRec		:= Round(xMoeda(nValRec,nMoeda,1,dDataBase,nDecs1+1,aTxMoedas[nMoeda][2]),nDecs1)
								nDifCambio	:= nValRec - nValDia
								nCM			:=	nDifCambio
							EndIf
							SE1->(dbGoto(nRec))
							cHist070 	:= STR0034  //"Valor recebido por compensacao"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Efetua a baixa											 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nValRec > 0

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Grava numero da compensacao no SE1 						 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea("SE1")
								SE1->(dbSetOrder(1))
								//(Dbseek(RTrim(Strtran(TRB->CHAVE,"**",""))))

								If !SE1->(Dbseek(xFilial("SE1")+(StrTran(Strtran(TRB->TITULO,"-",""),"*",""))))
									If !SE1->(Dbseek(xFilial("SE1")+(StrTran(Strtran(TRB->CHAVE,"-",""),"*",""))))
										Alert("Titulo não encontrado:" + TRB->TITULO)
									EndIf
								EndIf

								RecLock("SE1")
								Replace E1_IDENTEE	With cNumComp
								SE1->(MsUnLock())


								lBaixou		:= FA070Grv(lPadrao,lDesconto,.F.,Nil,.F.,dDataBase,.F.,Nil)		//Nil=Arquivo Cnab
						/*
						Atualiza o status do titulo no SERASA */
						If cPaisLoc == "BRA"
							If lBaixou
								If SE1->E1_SALDO <= 0
									cChaveTit := xFilial("SE1")	+ "|" +;
												SE1->E1_PREFIXO	+ "|" +;
												SE1->E1_NUM		+ "|" +;
												SE1->E1_PARCELA	+ "|" +;
												SE1->E1_TIPO		+ "|" +;
												SE1->E1_CLIENTE	+ "|" +;
												SE1->E1_LOJA
									cChaveFK7 := FINGRVFK7("SE1",cChaveTit)
									F770BxRen("1","CEC",cChaveFK7)
								Endif
							Endif
						Endif					
											
                        // nova versão para gravar SE5 e demais tabelas
                        
                        If AllTrim( SE5->E5_TABORI ) == "FK1"
                        	oModelMov := FWLoadModel("FINM010")
							aAreaAnt := GetArea()
							dbSelectArea( "FK1" )
							FK1->( DbSetOrder( 1 ) )
							If MsSeek( xFilial("FK1") + SE5->E5_IDORIG )
								oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
								oModelMov:Activate()
								oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação SE5
								//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
								//E5_OPERACAO 2 = Altera E5_TIPODOC da SE5 para 'ES' e gera estorno na FK5
								//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5 
								//Manda o campo LA com o valor de 2 Caracteres, para manter a gravação original na E5
								
								cCampoSE5 := "{" 
								cCamposE5 += "{'E5_IDENTEE','"+cNumComp+"' }"
								If !lUsaFlag 
									cCamposE5 += ",{'E5_LA', 'S'}"
								EndIf
                                cCamposE5 += "}"
                                
								oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5
								oModelMov:SetValue( "MASTER", "E5_OPERACAO",0 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
								
								//Posiciona a FKA com base no IDORIG da SE5 posicionada
								oSubFKA := oModelMov:GetModel( "FKADETAIL" )
								oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

								oSubFK1 := oModelMov:GetModel("FK1DETAIL")
								oSubFK1:SetValue( "FK1_IDPROC",cNumComp)
								If !lUsaFlag 
									oSubFK1:SetValue( "FK1_LA",'S') 																
								endif
								If oModelMov:VldData()
							       	oModelMov:CommitData()
							       	SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))

									If  lUsaFlag
										aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->(Recno() ), 0, 0, 0} )
									EndIf

						   	    	oModelMov:DeActivate()
								Else
									lRet := .F.
								    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
							    	cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
   							   		cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
                                        	
						       		Help( ,,"MF450VID1",,cLog, 1, 0 )
					       	   		
								Endif								
							Endif
							RestArea(aAreaAnt)
						EndIf

						AAdd(aSE5Recs,{"R",SE5->(Recno())})

						//Gravar o numero da compensacao nos titulos de juros, multa e desconto
						//para permitir que os mesmos sejam cancelados quando do cancelamento da
						//compensacao
						dbSelectArea("SE5")
						nRecAtu := SE5->(Recno())
						nOrdAtu := SE5->(IndexOrd())
						dbSetOrder(2)
						cChaveSe5 := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(dDatabase)+E5_CLIFOR+E5_LOJA+E5_SEQ)
						aTipodoc := {"DC","MT","JR","CM"}
						For nX := 1 to Len(aTipodoc)
							If dbSeek(xFilial("SE5")+aTipoDoc[nX]+cChaveSE5)

		                        If AllTrim( SE5->E5_TABORI ) == "FK1"
        		                	oModelMov := FWLoadModel("FINM010")
									aAreaAnt := GetArea()
									dbSelectArea( "FK1" )
									FK1->( DbSetOrder( 1 ) )
									If MsSeek( xFilial("FK1") + SE5->E5_IDORIG )
										oModelMov := FWLoadModel("FINM010")
										oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
										oModelMov:Activate() 
										//Posiciona a FKA com base no IDORIG da SE5 posicionada
										oSubFKA := oModelMov:GetModel( "FKADETAIL" )
										oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

										oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação SE5
										//Manda o campo LA com o valor de 2 Caracteres, para manter a gravação original na E5
										cCamposE5 := '{'
										cCamposE5 += "{'E5_IDENTEE','"+cNumComp+"' }"
    									If !lUsaFlag 
											cCamposE5 += ",{'E5_LA', 'S'}"
										EndIf
                                        cCamposE5 += "}"
                                        
										oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5
										oModelMov:SetValue( "MASTER", "E5_OPERACAO",0 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
										oSubFK1 := oModelMov:GetModel("FK1DETAIL")
										oSubFK1:SetValue( "FK1_IDPROC",cNumComp) 
										If !lUsaFlag 
											oSubFK1:SetValue( "FK1_LA",'S') 																
										endif
																
										If oModelMov:VldData()
							    		   	oModelMov:CommitData()
							    		   	SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))

											If  lUsaFlag
												aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->(Recno() ), 0, 0, 0} )
											EndIf

						   	    			oModelMov:DeActivate()
							   			Else
											lRet := .F.
										    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
							    			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
   							   				cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
                                        	
						       				Help( ,,"MF450VID2",,cLog, 1, 0 )
					       	   		
							   			Endif								
									Endif
								   RestArea(aAreaAnt)
								endif	
							Endif
		                
		      			Next	
		      			
		      			
		      			///numbor			
						aadd( aAlt,{ "STR0099",'','','',"STR0100" +  Alltrim(cNumComp) })   
						///chamada da Função que cria o Histórico de Cobrança
						FinaCONC(aAlt)
				      			
		      			
						SE5->(dbSetOrder(nOrdAtu))
						SE5->(dbGoto(nRecAtu))
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Inicializa variaveis para contabilizacao 					 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						VALOR := nValRec
						VLRINSTR := VALOR
						If nMoeda <= 5 .And. nMoeda > 1
							cVal := Str(nMoeda,1)
							VALOR&cVal := nValEstrang
						EndIf
					EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Registro do Contas a Pagar		  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf !Empty(TRB->PAGAR)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Procura registro no SE2											 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE2")
					dbSetOrder(1)
					dbSeek(Substr(TRB->CHAVE,1,nTamChavE2))
					dbSelectArea("TRB")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Inicializa variaveis para baixa 								 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dBaixa		:= dDataBase
					cBanco		:= cAgencia := cConta := cBenef := cLoteFin := " "
					cCheque		:= cPortado := cNumBor := " "
					nDespes		:= nDescont := nAbatim := nJuros := nMulta := 0
					nValCc		:= nCm := 0
					lDesconto	:= .F.
					cMotBx		:= "CEC"
					StrLctPad   := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Calcula Abatimentos 												 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nRec			:= SE2->(Recno())
					nRecTRB		:= TRB->(Recno())
					dbSelectArea("SE2")
					//TRB->CHAVE 	= SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+;
					//						SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
					//SumAbatPag(cPrefixo,cNumero,cParcela,cFornece,nMoeda,cCpo,dData,cLoja,cTipoData,dDataIni,dDataFim)
					nTotAbat 	:= SumAbatPag(Substr(TRB->CHAVE,nPosIniPref,3),Substr(TRB->CHAVE,nPosIniNum,nTamNum),;
										Substr(TRB->CHAVE,nPosIniParc,nTamParc),cFor450,nMoeda,"S",dDataBase,;
										Substr(TRB->CHAVE,nPosIniLoja,Len(TRB->CHAVE)))

					cHist070 	:= STR0080 //"Valor Pago por compensacao"
					SE2->(dbGoto(nRec))

					dbSelectArea("TRB")
					TRB->(dbGoto(nRecTRB))
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Calcula valor a ser baixado										 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nValPgto 	:= PAGAR 
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se n„o for baixar total o titulo, desconsidera abat.³
					//³ no calculo do valor recebido 							  ³
					//³ Caso o valor do titulo seja maior que o restante a  ³
					//³ compensar, baixa-se apenas a diferen‡a.             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nValPgto > nValMaxP
						nValPgto := nValMaxP
					EndIf
					nValMaxP -= nValPgto
					nValEstrang := nValPgto
					nAcresc		:= SE2->E2_SDACRES
					nDecresc	:= SE2->E2_SDDECRE
					nDescont	:= xMoeda(DESCONT,nMoeda,1,dDataBase)
					nJuros		:= xMoeda(JUROS,nMoeda,1,dDataBase)
					nMulta		:= xMoeda(MULTA,nMoeda,1,dDataBase)					
					nTxMoeda	:= SE2->E2_TXMOEDA
					// Converte para poder baixar
					If cPaisLoc == "BRA"					
					   nValPgto := xMoeda(nValPgto,nMoeda,1,dDataBase)
					   FA080CORR(nValEstrang,0)
					Else                                                                                                                    
						nValDia		 := Round(xMoeda(nValPgto,nMoeda,1,dDataBase,nDecs1+1,nTxMoeda),nDecs1)
                  		nValPgto 	 := Round(xMoeda(nValPgto,nMoeda,1,dDataBase,nDecs1+1,aTxMoedas[nMoeda][2]),nDecs1)					
						nDifCambio   := nValPgto - nValDia                       
					EndIf   
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Efetua a baixa											 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nValPgto > 0
						If lPccCC
							SE2->(DbClearFilter())                                                         
							
							nVl10925 := CalcVlPg(nValPgto)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava numero da compensacao no SE2 						 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							If Empty(SE2->E2_NUM)
							dbSelectArea("SE2")
							SE2->(dbSetOrder(1))
							//SE2->(Dbseek(RTrim(Strtran(TRB->CHAVE,"**",""))))
							If !SE2->(Dbseek(xFilial("SE2")+(StrTran(Strtran(TRB->TITULO,"-",""),"*",""))))
								If !SE2->(Dbseek(xFilial("SE2")+(StrTran(Strtran(TRB->CHAVE,"-",""),"*",""))))
									Alert("Titulo não encontrado:" + TRB->TITULO)
								EndIf
							EndIf
							EndIf

							RecLock("SE2",.F.)
							Replace E2_IDENTEE	With cNumComp
							SE2->(MsUnLock())
							
							lBaixou := .F.
							aBaixa	:=	{}	
							AADD(aBaixa,{"E2_PREFIXO" 	,SE2->E2_PREFIXO		, Nil})	
							AADD(aBaixa,{"E2_NUM"     	,SE2->E2_NUM			, Nil})	
							AADD(aBaixa,{"E2_PARCELA" 	,SE2->E2_PARCELA		, Nil})	
							AADD(aBaixa,{"E2_TIPO"    	,SE2->E2_TIPO			, Nil})	
							AADD(aBaixa,{"E2_FORNECE"	,SE2->E2_FORNECE		, Nil})	
							AADD(aBaixa,{"E2_LOJA"    	,SE2->E2_LOJA			, Nil})	
							AADD(aBaixa,{"AUTMOTBX"  	,"CEC"					, Nil})	
							AADD(aBaixa,{"AUTHIST"   	,STR0080				, Nil})	// "Valor pago por compensacao"
							AADD(aBaixa,{"AUTVLRPG"  	,nVl10925				, Nil})	
							AADD(aBaixa,{"AUTJUROS"  	,nJuros					, Nil})	
							AADD(aBaixa,{"AUTMULTA"  	,nMulta					, Nil})	
							
							aCampos := {"E2_FORNECE","E2_LOJA","E2_NUM","E2_TIPO","E2_PREFIXO","E2_PARCELA","E2_DIRF","E2_CODRET","E2_DESDOBR","E2_VALOR"}
							For nx := 1 to Len(aCampos)
								If aCampos[nX] <> "E2_VALOR"
									M->(&(aCampos[nX])) := SE2->(&(aCampos[nX]))
								Else
									M->E2_VALOR := nValPgto
								EndIf
							Next nx       
  							
							lMsEAuto := .F.
							MSExecAuto({|x,y| Fina080(x,y)},aBaixa,4)						
							pergunte("AFI450",.F.)

							If lMsErroAuto
								lBaixou := .F.
								MostraErro()
								Exit
							Else
								lBaixou := .T.

								If AllTrim( SE5->E5_TABORI ) == "FK2"
									aAreaAnt := GetArea()
			                        oModelMov := FWLoadModel("FINM020")
									oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
									oModelMov:Activate()
									//Posiciona a FKA com base no IDORIG da SE5 posicionada
									oSubFKA := oModelMov:GetModel( "FKADETAIL" )
									oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

									oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação SE5
									oSubFK2 := oModelMov:GetModel("FK2DETAIL")
										
									//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
									//E5_OPERACAO 2 = Altera E5_TIPODOC da SE5 para 'ES' e gera estorno na FK5
									//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5 
									//Manda o campo LA com o valor de 2 Caracteres, para manter a gravação original na E5
									oModelMov:SetValue( "MASTER", "E5_OPERACAO",0 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
									cCamposE5 := "{"
									cCamposE5 += "{'E5_IDENTEE','"+cNumComp+"' }"
									If !lUsaFlag 
										cCamposE5 += ",{'E5_LA', 'S'}"
									EndIf
                                    cCamposE5 += "}"
                                       
									oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5
									oSubFK2:SetValue("FK2_IDPROC",cNumComp) 
									If !lUsaFlag 
										oSubFK2:SetValue("FK2_LA","S") 
									Endif																
									
									If oModelMov:VldData()
							       		oModelMov:CommitData()
							       		SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))
										If  lUsaFlag
											aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->(Recno() ), 0, 0, 0} )
										EndIf

					   	    			oModelMov:DeActivate()
						   			Else
										lRet := .F.
									    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
						    			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
						   				cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
                                      	
					       				Help( ,,"MF450VID3",,cLog, 1, 0 )
				       	   		
						   			Endif								
									RestArea(aAreaAnt)
								EndIf
								
							EndIf														
				  		Else																														
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava numero da compensacao no SE2                       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							dbSelectArea("SE2")
							SE2->(dbSetOrder(1))
							If !SE2->(Dbseek(xFilial("SE2")+(StrTran(Strtran(TRB->TITULO,"-",""),"*",""))))
								If !SE2->(Dbseek(xFilial("SE2")+(StrTran(Strtran(TRB->CHAVE,"-",""),"*",""))))
									Alert("Titulo não encontrado:" + TRB->TITULO)
								EndIf
							EndIf

							RecLock("SE2",.F.)
							Replace E2_IDENTEE	With cNumComp
	
							cLanca		:= "S"
							lBaixou		:= fA080Grv(lPadrao,.F.,.F.,cLanca,,IIf(cPaisLoc=="BRA",Nil,aTxMoedas[nMoeda][2]))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava numero da compensacao no SE5 						 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							If AllTrim( SE5->E5_TABORI ) == "FK2"
		     					oModelMov := FWLoadModel("FINM020")
								aAreaAnt := GetArea()
								oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
								oModelMov:Activate()  
								//Posiciona a FKA com base no IDORIG da SE5 posicionada
								oSubFKA := oModelMov:GetModel( "FKADETAIL" )
								oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

								oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação SE5
								//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
								//E5_OPERACAO 2 = Altera E5_TIPODOC da SE5 para 'ES' e gera estorno na FK5
								//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5 
								//Manda o campo LA com o valor de 2 Caracteres, para manter a gravação original na E5
								cCamposE5 := "{" 
								cCamposE5 += "{'E5_IDENTEE','"+cNumComp+"' }"									
								If !lUsaFlag 
									cCamposE5 += ",{'E5_LA', 'S'}"
								EndIf
								cCamposE5 += "}"
								
								oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5
								oModelMov:SetValue( "MASTER", "E5_OPERACAO",0 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
								oSubFK2 := oModelMov:GetModel("FK2DETAIL")
								oSubFK2:SetValue( "FK2_IDPROC",cNumComp) 
								If !lUsaFlag 
									oSubFK2:SetValue( "FK2_LA", 'S')
								EndIf
															
								If oModelMov:VldData()
					       			oModelMov:CommitData()
					       			SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))
									If  lUsaFlag
										aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->(Recno() ), 0, 0, 0} )
									EndIf
					   	    		oModelMov:DeActivate()
					   			Else
									lRet := .F.
								    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
					    			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
					   				cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
                                       	
				       				Help( ,,"MF450VID4",,cLog, 1, 0 )
		       	   		
					   			Endif								
								RestArea(aAreaAnt)
								
							EndIf	                        
							AAdd(aSE5Recs,{"P",SE5->(Recno())})
	
							//Gravar o numero da compensacao nos titulos de juros, multa e desconto
							//para permitir que os mesmos sejam cancelados quando do cancelamento da
							//compensacao
							dbSelectArea("SE5")
							nRecAtu := SE5->(Recno())
							nOrdAtu := SE5->(IndexOrd())
							dbSetOrder(2)
							cChaveSe5 := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(dDatabase)+E5_CLIFOR+E5_LOJA+E5_SEQ)
							aTipodoc := {"DC","MT","JR","CM"}
							For nX := 1 to Len(aTipodoc)
								If dbSeek(xFilial("SE5")+aTipoDoc[nX]+cChaveSE5)

									If AllTrim( SE5->E5_TABORI ) == "FK2"
		    	                    	oModelMov := FWLoadModel("FINM020")
										aAreaAnt := GetArea()
										oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
										oModelMov:Activate()  
										//Posiciona a FKA com base no IDORIG da SE5 posicionada
										oSubFKA := oModelMov:GetModel( "FKADETAIL" )
										oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

										oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação SE5
										//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
										//E5_OPERACAO 2 = Altera E5_TIPODOC da SE5 para 'ES' e gera estorno na FK5
										//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5 
										//Manda o campo LA com o valor de 2 Caracteres, para manter a gravação original na E5
									    cCamposE5 := "{"

										cCamposE5 += "{'E5_IDENTEE','"+cNumComp+"' }"
										If !lUsaFlag 
											cCamposE5 += ",{'E5_LA', 'S'}"
										EndIf
									    cCamposE5 += "}"
										oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5
										oModelMov:SetValue( "MASTER", "E5_OPERACAO",0 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
										oSubFK2 := oModelMov:GetModel("FK2DETAIL")
										oSubFK2:SetValue( "FK2_IDPROC",cNumComp) 
										If !lUsaFlag 
											oSubFK2:SetValue( "FK2_LA", 'S')
										EndIf					
										If oModelMov:VldData()
							       			oModelMov:CommitData()
							       			SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))

											If  lUsaFlag
												aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->(Recno() ), 0, 0, 0} )
											EndIf

						   	    			oModelMov:DeActivate()
							   			Else
											lRet := .F.
										    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
							    			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
							   				cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
					    	   				Help( ,,"MF450VID5",,cLog, 1, 0 )
				       	   		
							   			Endif								

										RestArea(aAreaAnt)
									EndIf
				
								Endif
							Next	
	
							SE5->(dbSetOrder(nOrdAtu))
							SE5->(dbGoto(nRecAtu))	                 
                 		Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Inicializa variaveis para contabilizacao 					 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						VALOR := nValPgto
						VLRINSTR := VALOR
						If nMoeda <= 5 .And. nMoeda > 1
							cVal := Str(nMoeda,1)
							VALOR&cVal := nValEstrang
						EndIf
					EndIf
				EndIf

				If nValRec > 0  

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona SA1 para contabiliza‡Æo        					 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SA1")
					dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
					
					nRegSE1 := SE1->(Recno())
					dbSelectArea("SE2")
					dbGobottom()
					dbSkip()
				Endif
				
				If nValPgto > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona SA2 para contabiliza‡Æo                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SA2")
					dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)

					nRegSE2 := SE2->(Recno())			
					dbSelectArea("SE1")
					dbGobottom()
					dbSkip()
				Endif			

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Contabiliza	                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !lCabec .and. lPadrao
					nHdlPrv := HeadProva( cLote,;
					                      "FINA450",;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )

					lCabec := .t.
				End
				If lCabec .and. lPadrao .and. lBaixou .and. (VALOR+VALOR2+VALOR3+VALOR4+VALOR5) > 0
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA450",;
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

				End
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Integracao com o SIGAPCO para lancamento via processo³
				//³PCODetLan("000018","01","FINA450",.T.)               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000018","01","FINA450",.F.)
				
				//Envio de e-mail pela rotina de checklist de documentos obrigatorios
				If (Upper(TRB->P_R) == "P") .And. lFinVDoc
					F450VD(TRB->CHAVE,.F.,.T.,.T.)
				EndIf
				
			End
			dbSelectArea("TRB")
			dbSkip()
		EndDo                                                      
		//imprimir a compensação
		If MsgYesNo("Deseja imprimir a compensação?")
			
			cQuery := " UPDATE "+ RetSQLName("SE5")+ " "
			cQuery := cQuery + "  SET E5_DATA = E5_DTDISPO "
			cQuery := cQuery + "  WHERE E5_DATA = '' "
	
			TCSQLExec(cQuery)

			U_RELAT003()
		Endif	                         

		End Transaction		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o numero da compensacao no SX6.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX6")
		GetMv("MV_NUMCOMP") // Posiciona SX6 de acordo com a filial
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := cNumComp
		SX6->X6_CONTSPA := cNumComp
		SX6->X6_CONTENG := cNumComp
		SX6->(msUnlock())
	Endif
	Exit
End

If !Empty(aChaveLbn)
	aEval(aChaveLbn, {|e| UnLockByName(e,.T.,.F.) } ) // Libera Lock
Endif
     
SE1->(dbGoTo(nRegSE1))
SE2->(dbGoTo(nRegSE2))

//Se houve processamento de compensacao
//realizo os processos abaixo
If	lProcessou 

	If ExistBlock("F450SE5")
		ExecBlock("F450SE5",.F.,.F.,aSE5Recs)
	Endif	
	
	IF lPadrao .and. lCabec
		RodaProva(  nHdlPrv,;
					nTotal)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia para Lancamento Contabil							  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lDigita:=IIF(mv_par01==1,.T.,.F.)
		lAglut :=IIF(mv_par02==1,.T.,.F.)
		cA100Incl( cArquivo,;
		           nHdlPrv,;
		           3,;
		           cLote,;
		           lDigita,;
		           lAglut,;
		           /*cOnLine*/,;
		           /*dData*/,;
		           /*dReproc*/,;
		           @aFlagCTB,;
		           /*aDadosProva*/,;
		           /*aDiario*/ )
		aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Integracao com o SIGAPCO para lancamento via processo³
	//³PcoFinLan("000018")                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoFinLan("000018")

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os indices 													  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
Set Filter to
dbSetOrder(1)
dbGoTop()
RetIndex("SE1")
#IFNDEF TOP
   If !Empty(cIndex1)
	  Ferase (cIndex1+OrdBagExt())
   EndIf
#ENDIF   

dbSelectArea("SE2")
Set Filter to
dbSetOrder(1)
dbGoTop()
RetIndex("SE2")
#IFNDEF TOP
   If !Empty(cIndex2)
	  Ferase (cIndex2+OrdBagExt())
   EndIf
#ENDIF      

If !Empty(TRB)
	DbSelectArea("TRB")
	DbCloseArea()
    #IFNDEF TOP		
	   Ferase(TRB+GetDBExtension())
	   Ferase(TRB+".NTX")
    #ENDIF      	   
EndIf

FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()

dbSelectArea( cAlias )
dbSetOrder(1)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fa450Cli ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 20/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se cliente existe 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA450Cli(ExpC1)														  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA450Cli(cCli450,cLjCli)

LOCAL lRetorna := .T.

dbSelectArea( "SA1")
If cLjCli == Nil .Or. Empty( cLjCli )
	If !dbSeek( xFilial()+cCli450)
		Help(" ",1,"FA450CLI")
		lRetorna := .F.
	EndIf
Else
	If !dbSeek( xFilial()+cCli450+cLjCli)
		Help(" ",1,"FA450CLI")
		lRetorna := .F.
	EndIf
Endif
Return lRetorna

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fa450For ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 20/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se cliente existe 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA450For(ExpC1)														  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA450For(cFor450,cLjFor)

LOCAL lRetorna := .T.

dbSelectArea( "SA2")

If cLjFor == Nil .Or. Empty( cLjFor )
	If !dbSeek( xFilial()+cFor450 )
		Help(" ",1,"FA450For")
		lRetorna := .F.
	EndIf
Else
	If !dbSeek( xFilial()+cFor450+cLjFor )
		Help(" ",1,"FA450For")
		lRetorna := .F.
	EndIf
Endif

Return lRetorna

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA450DBEVA³ Autor ³ Wagner Xavier 		  ³ Data ³ 20/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Trata o dbeval para marcar e desmarcar item					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA450DBEVA()															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA450																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450DbEva(nLim450,lMarcaTodos,aChaveLbn , aChavePag, aChaveRec,lPrimeiro )
Local nTamChavE1	:= TamSx3("E1_PREFIXO")[1]+TamSx3("E1_NUM")[1]+TamSx3("E1_PARCELA")[1]+TamSx3("E1_TIPO")[1]+TamSx3("E1_FILIAL")[1]
Local lFinVDoc	:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)
Local aArea:=GetArea()
Local aAreaSE2:=SE2->(GetArea())
Default lPrimeiro:=.F.
SE2->(dbSEtORder(1))

lMarcaTodos := Iif(lMarcaTodos == Nil, .F., lMarcaTodos)

If Right(TRB->TIPO,1) != "-"
	cChaveLbn := "CEC" + TRB->(P_R+CHAVE)
	If lMarcaTodos
		//-- Parametros da Funcao LockByName() :
		//   1o - Nome da Trava
		//   2o - usa informacoes da Empresa na chave
		//   3o - usa informacoes da Filial na chave 
		If LockByName(cChaveLbn,.T.,.F.)
			RecLock("TRB")
			If RECEBER != 0
				nSelecR += RECEBER
				TRB->MARCA := cMarca
			Else
				If AllTrim(TRB->(P_R))=="P" .and. lFinVDoc //validação do controle de documentos
					SE2->(dbSeek(TRB->(CHAVE)))
					IF CN062ValDocs("07",.F.,.F.,.T.,@lPrimeiro)
						nSelecP += PAGAR
						TRB->MARCA := cMarca
					Endif
				Else
					nSelecP += RECEBER
					TRB->MARCA := cMarca
				Endif
			EndIf
			TRB->(MsUnlock())
			Aadd(aChaveLbn,cChaveLbn)
		Endif	
	Else
		IF RECEBER != 0
			If (nSelecR < nLim450 .And. (RECEBER+nSelecR) <= nLim450 .AND. !lF450Auto) .or. ( lF450Auto .AND. aScan(aChaveRec, {|x| x[1]==Substr(CHAVE,1,nTamChavE1) })>0 .AND. ((nSelecR < nLim450 .And. (RECEBER+nSelecR) <= nLim450) .OR. ( nlim450 == 0)))
				//-- Parametros da Funcao LockByName() :
				//   1o - Nome da Trava
				//   2o - usa informacoes da Empresa na chave
				//   3o - usa informacoes da Filial na chave 
				If LockByName(cChaveLbn,.T.,.F.)
					If AllTrim(TRB->(P_R))=="P" .and. lFinVDoc //validação
						SE2->(dbSeek(TRB->(CHAVE)))
						IF CN062ValDocs("07",.F.,.F.,.T.,@lPrimeiro)
							RecLock("TRB")
							nSelecR += RECEBER
							TRB->MARCA := cMarca
							TRB->(MsUnlock())
							Aadd(aChaveLbn,cChaveLbn)
						Endif
					Else
						RecLock("TRB")
						nSelecR += RECEBER
						TRB->MARCA := cMarca
						TRB->(MsUnlock())
						Aadd(aChaveLbn,cChaveLbn)
					Endif
				Endif	
			ElseIf (lF450Auto .AND. aScan(aChaveRec, {|x| x[1]==Substr(CHAVE,1,nTamChavE1) })>0 .AND. ((RECEBER+nSelecR) > nLim450) .and. !(nSelecR == nLim450))
				If LockByName(cChaveLbn,.T.,.F.)
					If AllTrim(_TRB->(P_R))=="P" .and. lFinVDoc //validação
						SE2->(MsSeek(_TRB->(CHAVE)))
						IF CN062ValDocs("07",.F.,.F.,.T.,@lPrimeiro)
							RecLock("_TRB")
							nSelecR := nLim450
							_TRB->MARCA := cMarca
							TRB->(MsUnlock())
							Aadd(aChaveLbn,cChaveLbn)
						Endif
					Else
						RecLock("_TRB")
						nSelecR := nLim450
						_TRB->MARCA := cMarca
						TRB->(MsUnlock())
						Aadd(aChaveLbn,cChaveLbn)
					Endif
				Endif				
			Else
				RecLock("TRB")
				TRB->MARCA := " "
				TRB->(MsUnlock())
			EndIf
		Else
			If ((nSelecP < nLim450 .And. (PAGAR+nSelecP) <= nLim450 .AND. !lF450Auto) .or. ( lF450Auto .AND. aScan(aChavePag, {|x| x[1]==CHAVE })>0 .AND. ((nSelecP < nLim450 .And. (PAGAR+nSelecP) <= nLim450) .OR. ( nlim450 == 0)))) 
				//-- Parametros da Funcao LockByName() :
				//   1o - Nome da Trava
				//   2o - usa informacoes da Empresa na chave
				//   3o - usa informacoes da Filial na chave 
				If LockByName(cChaveLbn,.T.,.F.)
					If AllTrim(TRB->(P_R))=="P" .and. lFinVDoc //validação
						SE2->(dbSeek(TRB->(CHAVE)))
						IF CN062ValDocs("07",.F.,.F.,.T.,@lPrimeiro)
							RecLock("TRB")
							nSelecP += PAGAR
							TRB->MARCA := cMarca
							TRB->(MsUnlock())
							Aadd(aChaveLbn,cChaveLbn)
						Endif
					Else
						RecLock("TRB")
						nSelecP += RECEBER
						TRB->MARCA := cMarca
						TRB->(MsUnlock())
						Aadd(aChaveLbn,cChaveLbn)
					Endif
				Endif	
			ElseIF (lF450Auto .AND. aScan(aChavePag, {|x| x[1]==CHAVE })>0 .AND. (((PAGAR+nSelecP) >= nLim450) .and. !(nSelecP == nLim450)))
				//-- Parametros da Funcao LockByName() :
				//   1o - Nome da Trava
				//   2o - usa informacoes da Empresa na chave
				//   3o - usa informacoes da Filial na chave 
				If LockByName(cChaveLbn,.T.,.F.)
					If AllTrim(_TRB->(P_R))=="P" .and. lFinVDoc //validação
						SE2->(MsSeek(_TRB->(CHAVE)))
						IF CN062ValDocs("07",.F.,.F.,.T.,@lPrimeiro)
							RecLock("_TRB")
							nSelecP := nLim450
							_TRB->MARCA := cMarca
							TRB->(MsUnlock())
							Aadd(aChaveLbn,cChaveLbn)
						Endif
					Else
						RecLock("_TRB")
						nSelecP := nLim450
						_TRB->MARCA := cMarca
						TRB->(MsUnlock())
						Aadd(aChaveLbn,cChaveLbn)
					Endif
				Endif				
			Else
				RecLock("TRB")
				TRB->MARCA := " "
				MsUnlock()
			EndIf
		EndIF
	EndIf
	MsUnlock()
EndIf
RestArea(aAreaSE2)
RestArea(aArea)
Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ 450DATA³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 20/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se data final ‚ maior que data inicial 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ 450DATa(ExpD1,ExpD2)												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA450																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function 450DATa(dVenIni450,dVenFim450)

LOCAL lRet:=.T.
IF dVenFim450 < dVenIni450
	Help(" ",1,"DATAMENOR")
	lRet:=.F.
EndIF
Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ 450DATA³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 20/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se data final ‚ maior que data inicial 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ 450DATa(ExpD1,ExpD2)												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA450																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function 450DATaE(dEmiIni450,dEmiFim450)

LOCAL lRet:=.T.
IF dEmiFim450 < dEmiIni450
	Help(" ",1,"DATAMENOR")
	lRet:=.F.
EndIF
Return lRet



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA450Chec1³ Autor ³ Pilar s. Albaladejo   ³ Data ³ 20/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna expressao para Indice Condicional 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA450Chec1()												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA450Chec1(lTitFuturo)

Local cString

//PCREQ-3782 - Bloqueio por situação de cobrança
Local cLstCart := FN022LSTCB(1,'0008')	//Lista das situacoes de cobranca (Carteira)
Local cLstNoBlq := FN022LSTCB(6,'0008')	//Lista das situacoes de cobranca (Não bloqueadas para determinado processo)

// OBS: Nao aumentar o tamanho da string!! O maximo que a indregua suporta
// sao 256 caracteres!!  - candisani
IF ExistBlock("F450OWN")
	cString := ExecBlock("F450OWN",.F.,.F.)
Else
	cString := 'E1_FILIAL=="' + xFilial()+ '".And.'
	cString += 'DTOS(E1_VENCREA)>="' + DTOS(dCliIniVen) + '".And.'
	cString += 'DTOS(E1_VENCREA)<="' + DTOS(dCliFimVen) + '".And.'

	If !lTitFuturo
		cString += 'DTOS(E1_EMISSAO)>="' + DTOS(dCliIniEmi) + '".And.'
		cString += 'DTOS(E1_EMISSAO)<="' + DTOS(dCliFimEmi) + '".And.'
	Endif
	
	If nDebCred == 1
		cString += '!(E1_TIPO$"'+MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+'").And. '
	ElseIf  nDebCred == 2
		cString += '(E1_TIPO$"'+MVRECANT+"/"+MV_CRNEG+'").And. '
	Endif
	// Se nao considera titulos transferidos, filtra (exibe) apenas os titulos que estao em carteira.
	If mv_par03 == 2
		cString += 'E1_SITUACA $ "'+cLstCart+'".And.'	
	Else
		//PCREQ-3782 - Bloqueio por situação de cobrança
		cString += 'E1_SITUACA $ "'+cLstNoBlq+'" .And.'
	Endif	
	cString += 'E1_MOEDA=' + Alltrim(Str(nMoeda,2)) + '.And.'
	cString += 'E1_SALDO>0.And.'
	//If !Empty(cTpDoc)
	//	cString += 'E1_TIPO $ "'+cTpDoc+'".And.'	
	//Endif
	//nao aparecer tipo CHD - cheque devolvido a pedido de Karla
	If !Empty(cTpDocCli)
		cString += 'E1_TIPO $ "'+cTpDocCli+'".And.'	
	Endif
	If !Empty(cPrefixo)
		cString += 'E1_PREFIXO $ "'+cPrefixo+'".And.'	
	Endif
	cString += 'E1_TIPO <> "CHD" '
	//cString += 'E1_CLIENTE ="' + cCli450 + '"'
	//If !Empty(cLjCli)
	//	cString += '.And.E1_LOJA ="' + cLjCli + '"'
	//Endif
Endif

Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA450Ch2³ Autor ³ Pilar s. Albaladejo   ³ Data ³ 20/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna expressao para Indice Condicional 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA450Ch2()												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA450Ch2(lTitFuturo)

Local cString
Local nValmin:= 0
Local lVerLibTit := .T.
Local lPrjCni   :=  .T.

// OBS: Nao aumentar o tamanho da string!! O maximo que a indregua suporta
// sao 256 caracteres!!
IF ExistBlock("F450OWN1")
	cString := ExecBlock("F450OWN1",.F.,.F.)
Else
	cString := 'E2_FILIAL=="' + xFilial() + '".And.'
	cString += 'DTOS(E2_VENCREA)>="' + DTOS(dVenIni450) + '".And.'
	cString += 'DTOS(E2_VENCREA)<="' + DTOS(dVenFim450) + '".And.'

	If !lTitFuturo
		cString += 'DTOS(E2_EMISSAO)>="' + DTOS(dEmiIni450) + '".And.'
		cString += 'DTOS(E2_EMISSAO)<="' + DTOS(dEmiFim450) + '".And.'
	Endif
	
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ AAF - Titulos originados no SIGAEFF não devem ser alterados   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cString += "!'SIGAEFF'$E2_ORIGEM.AND."
    
    
	If nDebCred == 1 // Titulos Normais
		cString += '!(E2_TIPO$"'+MVPROVIS+"/"+MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM+'").And.'
	ElseIf  nDebCred == 2
		cString += '(E2_TIPO$"'+MVPAGANT+"/"+MV_CPNEG+'").And.'
	Endif
	
	cString += 'E2_MOEDA=' + Alltrim(Str(nMoeda,2)) + '.And.'
	cString += 'E2_SALDO>0.And.' 
    
   	IF (ExistBlock("F450LIBT"))
		lVerLibTit :=ExecBlock("F450LIBT",.f.,.f.)
	Endif
   
	// controla Liberacao do titulo
   	If lVerLibTit
		If !Empty(GetMv("MV_CTLIPAG") )
			nValmin:= GetMV("MV_VLMINPG")	
	 		cString += "((DTOS(E2_DATALIB) <> '        ').Or. ((DTOS(E2_DATALIB) <> '        ').And.(E2_SALDO + E2_SDACRES - E2_SDDECRE)< " + str(nValmin)+ ")) .And. "
		EndIf
	EndIf
	If !Empty(cTpDoc)
		cString += 'E2_TIPO $ "'+cTpDoc+'".And.'	
	Endif
	If !Empty(cPrefFor)
		cString += 'E2_PREFIXO $ "'+cPrefFor+'".And.'	
	Endif	
	cString += 'E2_FORNECE="' + cFor450 + '"'
	If !Empty(cLjFor)
		cString += '.And.E2_LOJA="' + cLjFor + '"'
	Endif
	
	/*-----------------------------------------------------------------------
	|Tratamento Realizado para o cliente CNI
	|Os titulos a pagar que estão com solicitação de transferencia em aberto 
	|Não devem entrar na rotina de Compensação 
	-------------------------------------------------------------------------*/
	If lPrjCni
		cString += ".And.Empty(E2_NUMSOL)"
	Endif
	
	//-----------------------------------------------------
	// Complemento de filtro do Documento Hábil - SIAFI
	//-----------------------------------------------------
	cString += FinTemDH(.T. /*lFiltro*/,/*cAlias*/,.F. /*lHelp*/, .F./*lTop*/)
	
EndIf

Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA450GerAr³ Autor ³ Pilar s. Albaladejo   ³ Data ³ 20/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera arquivo de trabalho											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA450GerAr()															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450Gerarq(aCampos)

Local TRB, cIndex

If ( Select ( "TRB" ) <> 0 )
	dbSelectArea ( "TRB" )
	dbCloseArea ()
End
TRB:=CriaTrab(aCampos)
dbUseArea( .T.,, TRB, "TRB", NIL, .F. )

cIndex := CriaTrab(nil,.f.)
//cChave := "P_R+CHAVE"
/*
{"P_R"      ,"C", 1,0},;
						{"TITULO"   ,"C",nTamTitulo+3,0},;
						{"PAGAR"    ,"N",15,2},;
						{"RECEBER"  ,"N",15,2},;
						{"VLRPAG"  ,"N",15,2},;
						{"VLRREC"  ,"N",15,2},;
						{"EMISSAO"  ,"D", 8,0},;
						{"VENCTO"   ,"D", 8,0},;
						{"TIPO"     ,"C", 3,0},;
						{"MARCA"    ,"C", 2,0},;
						{"CHAVE"    ,"C",nTamChavE2,0},;
					
*/

								If cOrdem == "Valor"
									cChave := "P_R+STR(PAGAR)+STR(RECEBER)"
									//cChave := "P_R+CHVVLR"
								Endif

//Ponto de entrada para possibilitar alterar a ordem dos registros a serem selecionados
								If ExistBlock("F450ORDEM")
									cChave := ExecBlock( "F450ORDEM", .F., .F., { cChave } )
								EndIf

								IndRegua("TRB",cIndex,cChave,,,STR0044)  //"Selecionando Registros..."



								Return TRB

/*/
								ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
								±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
								±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
								±±³Fun‡„o	 ³FA450Repl ³ Autor ³ Pilar s. Albaladejo   ³ Data ³ 20/02/97 ³±±
								±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
								±±³Descri‡„o ³ Grava registros no arquivo temporario					  ³±±
								±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
								±±³Sintaxe	 ³ FA450Repl() 												  ³±±
								±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
								±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
								ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450Repl(TRB)

	Local nAbat:= 0
	Local nJuros := 0
	Local nDescont := 0
	Local nMulta	:= 0                             //Valor da Multa
	Local cMVJurTipo := SuperGetMV("MV_JURTIPO",,"") //Tipo de calculo dos Juros
	Local lLojxRMul  := .T.  //Calculo de Juros e Multas: SIGALOJA x SIGAFIN
	Local lMvLjIntFS := SuperGetMV("MV_LJINTFS", , .F.) //Integração com o Financial Services Habilitada?

	Local nPCCRet := 0
	Local nPccTit	:= 0
	Local nBP10925 := SuperGetMv("MV_BP10925",.T.,"1") //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos
	Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"
	Local lPccCC	:= SuperGetMV( "MV_CC10925" , , 1) == 2 .and. lPCCBaixa // Gera PCC na compensação entre carteiras quando PCC na baixa

	dBaixa		:= dDataBase

	dbSelectArea("SE1")
	dbGotop()

	While !Eof()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mexico - Manejo de Anticipo                               ³
		//³ Validacao para nao selecionar os titulos das notas        ³
		//³ de adiantamento e os titulos do tipo RA gerados pela      ³
		//³ rotina recebimentos diversos.                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc == "MEX" .And.;
				X3Usado("ED_OPERADT") .And.;
				Upper(Alltrim(SE1->E1_ORIGEM)) $ "FINA087A|MATA467N" .And.;
				GetAdvFVal("SED","ED_OPERADT",xFilial("SED")+SE1->E1_NATUREZ,1,"") == "1"

			SE1->(dbSkip())
			Loop

		EndIf

		nAbat  := SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"S",dDataBase)
		nJuros := fa070Juros()
		nDescont := FaDescFin("SE1",dDataBase,SE1->E1_SALDO-nAbat,SE1->E1_MOEDA)

		//Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Inicio
	/*BEGINDOC
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula a multa, conforme a regra do controle de lojas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ENDDOC*/ 
	nMulta := 0
	If (cMvJurTipo == "L" .OR. lMvLjIntFS) .and. lLojxRMul 

		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Calcula o valor da Multa  :funcao LojxRMul :fonte Lojxrec          ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		  nMulta := LojxRMul( , , ,SE1->E1_SALDO, SE1->E1_ACRESC, SE1->E1_VENCREA,, , SE1->E1_MULTA, ,;
		  					 SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_CLIENTE, SE1->E1_LOJA, "SE1" )   	

	Endif
	//Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Final	
	RecLock("TRB",.T.)
	Replace	P_R		With "R"
	Replace	TITULO	With SE1->E1_PREFIXO + "-" + SE1->E1_NUM + "-" + SE1->E1_PARCELA+ "-" + SE1->E1_TIPO
	Replace	EMISSAO	With SE1->E1_EMISSAO
	Replace	VENCTO	With SE1->E1_VENCREA
	Replace	RECEBER	With SE1->E1_SALDO - nAbat + SE1->E1_SDACRES - SE1->E1_SDDECRE + nJuros - nDescont + nMulta
	//Replace	VLRREC	With SE1->E1_VALLIQ
	Replace	MARCA 	With " "
	Replace  TIPO     With SE1->E1_TIPO
	Replace	PRINCIP	With SE1->E1_SALDO
	//Replace	CHVVLR	With STRZERO(SE1->E1_SALDO,15,2)
	Replace	ABATIM	With nAbat
	Replace  JUROS		With nJuros
	Replace  MULTA		With nMulta	 //Calculo de Juros e Multas: SIGALOJA x SIGAFIN 
	Replace  DESCONT	With nDescont
	Replace  ACRESC	With SE1->E1_SDACRES
	Replace  DECRESC	With SE1->E1_SDDECRE
	Replace  CLIFOR	With SE1->E1_CLIENTE+"-"+SE1->E1_LOJA
	Replace  NOME		With SE1->E1_NOMCLI
	Replace	CHAVE 	With SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
	TRB->(MsUnlock())
	
	nTotalR	+= RECEBER
	If ExistBlock("F450GRAVA")
		Execblock("F450GRAVA",.F.,.F.,{"SE1"})
	EndIf
	dbselectArea("SE1")
	dbSkip()
EndDo

dbSelectArea("SE2")
dbGotop()

While !Eof()
	nAbat := SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_MOEDA,"S",dDataBase,SE2->E2_LOJA)
	nJuros := fa080Juros()	

	If lPccCC .and. nBP10925 <> "1"
		// essa chamada é feita para alimentar a variável nPCCRet
		Sel450Baixa("VL /BA /CP /",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA, @nPCCRet)
		nPccTit := SE2->(E2_PIS + E2_COFINS + E2_CSLL)
	EndIf	
	
	RecLock("TRB",.T.)
	Replace	P_R		With "P"
	Replace	TITULO	With SE2->E2_PREFIXO + "-" + SE2->E2_NUM + "-" + SE2->E2_PARCELA+ "-" + SE2->E2_TIPO
	Replace	EMISSAO	With SE2->E2_EMISSAO
	Replace	VENCTO	With SE2->E2_VENCREA
	//Replace	VLRPAG	With SE2->E2_VALLIQ
	Replace	PAGAR 	With SE2->E2_SALDO - nAbat + SE2->E2_SDACRES - SE2->E2_SDDECRE + FaJuros(SE2->E2_VALOR,SE2->E2_SALDO,SE2->E2_VENCTO,SE2->E2_VALJUR,SE2->E2_PORCJUR,SE2->E2_MOEDA,SE2->E2_EMISSAO,,,,SE2->E2_VENCREA) + nPCCRet - (nPccTit)
	Replace	MARCA 	With " "
	Replace  TIPO     With SE2->E2_TIPO
	Replace	PRINCIP	With SE2->E2_SALDO
	//Replace	CHVVLR	With STRZERO(SE2->E2_SALDO,15,2)
	Replace	ABATIM	With nAbat
	Replace  JUROS		With nJuros
	Replace  MULTA		With 0	
	Replace  DESCONT	With 0
	Replace  ACRESC	With SE2->E2_SDACRES
	Replace  DECRESC	With SE2->E2_SDDECRE
	Replace  CLIFOR	With SE2->E2_FORNECE+"-"+SE2->E2_LOJA
	Replace  NOME		With SE2->E2_NOMFOR
	Replace	CHAVE 	With SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+;
							SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
	TRB->(MsUnlock())
	nTotalP	+= PAGAR
	If ExistBlock("F450GRAVA")
		Execblock("F450GRAVA",.F.,.F.,{"SE2"})
	EndIf
	dbselectArea("SE2")
	dbSkip()
EndDo

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fa450F3	³ Autor ³ Wagner Xavier         ³ Data ³ 19.09.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Habilita ou nao a tecla F3 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450F3(cArq)

If cArq == nil
	Set Key K_F3 To
Else
	SetKey( K_F3, {|a,b,c| ConPad1(a,b,c,cArq)} )
End
Return (.t.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa450Inver³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 28/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inverte markbrowse no windows								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINA450													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450Inverte(cMarca,oTotalP,oTotalR,oSelecP,oSelecR,lTodos,aChaveLbn)
Local nReg := TRB->(Recno())
Local lCompensa 
Local nTamChavE2	:= TamSx3("E2_PREFIXO")[1]+TamSx3("E2_NUM")[1]+TamSx3("E2_PARCELA")[1]+TamSx3("E2_TIPO")[1]+TamSx3("E2_FILIAL")[1]+TamSx3("E2_FORNECE")[1]+TamSx3("E2_LOJA")[1]
Local nTamChavE1	:= TamSx3("E2_PREFIXO")[1]+TamSx3("E2_NUM")[1]+TamSx3("E2_PARCELA")[1]+TamSx3("E2_TIPO")[1]+2
Local cTipo
Local lValDocs		:= .T.
Local lFinVDoc		:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
Local nPCCRet		:= 0
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"
Local lPccCC	:= SuperGetMV( "MV_CC10925" , , 1) == 2 .and. lPCCBaixa // Gera PCC na compensação entre carteiras quando PCC na baixa
Local lPrimeiro:=.T. // na validação de amarração fin x documentos, deve passar apenas uma vez pelo help
Local lSelecP := .F.
Local lSelecR := .F.
Local nVlPagar := 0
Local nVlReceb := 0
Default lTodos := .T.

If lTodos
	dbSelectArea("TRB")
	dbGoTop()
Endif

While !lTodos .Or. !Eof()
	lValDocs := .T.
	lCompensa := .T.                   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soh executa o P.E. quando o registro/titulo está sendo marcado. ³
	//³Nao chama na "desmarcação".                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("F450Conf") .and. MARCA != cMarca
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Procura registro no SE1 ou SE2, conforme titulo			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TRB->RECEBER != 0
			dbSelectArea("SE1")
			dbSetOrder(1)
			dbSeek(Substr(TRB->CHAVE,1,nTamChavE1))     
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso seja um Titulo à Receber, o parametro passado para o PE terah conteudo "R", ³
			//³nesse caso o RDMake devera consultar o SE1.										³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTipo := "R"
		Else
			dbSelectArea("SE2")
			dbSetOrder(1)
			dbSeek(Substr(TRB->CHAVE,1,nTamChavE2))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso seja um Titulo à Pagar, o parametro passado para o PE terah conteudo "P", ³
			//³nesse caso o RDMake deverah consultar o SE2.                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTipo := "P"
		EndIf

	   	lCompensa := ExecBlock("F450Conf",.F.,.F.,{cTipo})
		dbSelectArea("TRB")
	EndIf
   
    If lCompensa
		//-- Parametros da Funcao LockByName() :
		//   1o - Nome da Trava
		//   2o - usa informacoes da Empresa na chave
		//   3o - usa informacoes da Filial na chave 
		cChaveLbn := "CEC" + TRB->(P_R+CHAVE)
		If Right(TRB->TIPO,1) != "-"
			IF MARCA == cMarca
				RecLock("TRB")
				TRB->MARCA := "  "
				If TRB->RECEBER != 0
					nSelecR -= TRB->RECEBER
				Else
					nSelecP -= TRB->PAGAR
					If lPccCC
						DbSelectArea("SE2")
						DbSetOrder(1)
						DbSeek(TRB->CHAVE)						
						// essa chamada é feita para alimentar a variável nPCCRet
						Sel450Baixa("VL /BA /CP /",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA, @nPCCRet)
						nTotPCC -= (SE2->(E2_PIS + E2_COFINS + E2_CSLL) - nPCCRet)
					EndIf
					DbSelectArea("TRB")
				EndIf
				nAscan := Ascan(aChaveLbn, cChaveLbn )
				If nAscan > 0
					UnLockByName(aChaveLbn[nAscan],.T.,.F.) // Libera Lock
				Endif
			Else
				If (Upper(TRB->P_R) == "P") .And. lFinVDoc
					If !F450VD(TRB->CHAVE,lTodos,.T.,,@lPrimeiro)
						lValDocs := .F.
					EndIf
				EndIF
				If lValDocs
					If LockByName(cChaveLbn,.T.,.F.)
						RecLock("TRB")
						TRB->MARCA := cMarca
						If TRB->RECEBER != 0
							nSelecR += TRB->RECEBER
						Else
							nSelecP += TRB->PAGAR
							If lPccCC
								DbSelectArea("SE2")
								DbSetOrder(1)
								DbSeek(TRB->CHAVE)
								// essa chamada é feita para alimentar a variável nPCCRet
								Sel450Baixa("VL /BA /CP /",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA, @nPCCRet)			
								nTotPCC += ((SE2->E2_PIS + SE2->E2_COFINS + SE2->E2_CSLL) - nPCCRet)
							EndIf
							DbSelectArea("TRB")							
						EndIf
						Aadd(aChaveLbn, cChaveLbn )
					Else
						If !lTodos
							MsgAlert(STR0082, STR0083) // "Existe outro usuário utilizando o titulo. Não é permitida a compensação do titulo quando ele está sendo utilizado por outro usuário" ## "Atenção"
						Endif
					Endif
				EndIf
			Endif
			TRB->(MsUnlock())
		Endif	
	EndIf
	If lTodos
		dbSkip()
	Else
		Exit	
	Endif
Enddo

If nLim450 != 0
	If lTodos
		TRB->(dbGoTop())
		
		While TRB->(!Eof()) .And. (!lSelecP .OR. !lSelecR)
			If nLim450 < nSelecP .And. TRB->PAGAR > 0
				nSelecP := nLim450
				lSelecP := .T.
			ElseIf nLim450 > nSelecP .And. TRB->PAGAR > 0 .And. Empty(TRB->MARCA)
				nSelecP := 0	
			ElseIf TRB->PAGAR > 0
				nVlPagar += TRB->PAGAR		
			EndIf 
			
			If nLim450 < nSelecR .And. TRB->RECEBER > 0
				nSelecR := nLim450
				lSelecR := .T.	
			ElseIf nLim450 > nSelecR .And. TRB->RECEBER > 0 .And. Empty(TRB->MARCA) 
				nSelecR := 0	
			ElseIf TRB->RECEBER > 0
				nVlReceb += TRB->RECEBER	
			EndIf 	
								
			TRB->(dbSkip())		
		EndDo	
		
		If nSelecP <= 0 .And. nVlPagar > 0
			nSelecP := nVlPagar	 
		EndIf  
		
		If nSelecR <= 0 .And. nVlReceb > 0
			nSelecR := nVlReceb	
		EndIf  	 
	Else	
		If nLim450 < nSelecP
			nSelecP := nLim450
		ElseIf nLim450 < nSelecR
			nSelecR := nLim450
		EndIf
		If nSelecR < 0
		   	nSelecR:= 0
		Elseif nSelecP < 0
		  	nSelecP:= 0
	 	Endif	
	EndIf
EndIf

oSelecP:Refresh()
oSelecR:Refresh()
TRB->(MsGoto(nReg))
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa450Disp ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 28/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe na tela os titulos marcados - WINDOWS				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINA450													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450Disp(cMarca,lInverte,oTotalP,oTotalR,oSelecP,oSelecR)

Local cFieldMarca := "MARCA"

If Right(TRB->TIPO,1) != "-"
	If IsMark(cFieldMarca,cMarca,lInverte)
		If TRB->RECEBER != 0
			nSelecR += RECEBER
		Else
			nSelecP += PAGAR
		EndIf
	Else
		If TRB->RECEBER != 0
			nSelecR -= RECEBER
		Else
			nSelecP -= PAGAR
		EndIf
	End
EndIf
oSelecP:Refresh()
oSelecR:Refresh()
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa450Bar	³ Autor ³ Pilar S Albaladejo    ³ Data ³12.03.97  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra a EnchoiceBar na tela - WINDOWS 		    		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450Bar(oDlg,bOk,bCancel,oSelecP,oSelecR,oMark,nTamChavE1,nTamChavE2)

Local oBar, bSet15, bSet24, lOk
Local lVolta :=.f.

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
DEFINE BUTTON RESOURCE "S4WB005N" OF oBar ACTION NaoDisp() TOOLTIP STR0045  //"Recortar"
DEFINE BUTTON RESOURCE "S4WB006N" OF oBar ACTION NaoDisp() TOOLTIP STR0046  //"Copiar"
DEFINE BUTTON RESOURCE "S4WB007N" OF oBar ACTION NaoDisp() TOOLTIP STR0047  //"Colar"
DEFINE BUTTON RESOURCE "S4WB008N" OF oBar GROUP ACTION Calculadora() TOOLTIP STR0048  //"Calculadora..."
DEFINE BUTTON RESOURCE "S4WB009N" OF oBar ACTION Agenda() TOOLTIP STR0049  //"Agenda..."
DEFINE BUTTON RESOURCE "S4WB010N" OF oBar ACTION OurSpool() TOOLTIP STR0050  //"Gerenciador de ImpressÆo..."
DEFINE BUTTON RESOURCE "S4WB016N" OF oBar GROUP ACTION HelProg() TOOLTIP STR0051  //"Help de Programa..."

DEFINE BUTTON oBtnEdt RESOURCE "NOTE" OF oBar ACTION Fa450Edit(oSelecP,;
		oSelecR,nTamChavE1,nTamChavE2) TOOLTIP STR0052  //"Edita Registro..(CTRL-E)"
SetKey(5,oBtnEdt:bAction)

DEFINE BUTTON oBtnPsq RESOURCE "PESQUISA" OF oBar ACTION Fa450Pesq(oMark)  ;
		TOOLTIP STR0053  //"Pesquisar..(CTRL-P)"

SetKey(16,oBtnPsq:bAction)
oBar:nGroups += 6
DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
SetKEY(15,oBtOk:bAction)
DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.f.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP STR0054  //"Cancelar - <Ctrl-X>"

SetKEY(24,oBtCan:bAction)
oDlg:bSet15 := oBtOk:bAction
oDlg:bSet24 := oBtCan:bAction
oBar:bRClicked := {|| AllwaysTrue()}

Return nil


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa450Button Autor ³ Pilar S Albaladejo    ³ Data ³12.03.97  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Desliga Botao da enchoice bar - WINDOWS	    			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ButtonOff(bSet15,bSet24,lOk)
DEFAULT lOk := .t.
IF lOk
	SetKey(15,bSet15)
	SetKey(24,bSet24)
Endif
Return .T.


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa450Edit ³ Autor ³ Pilar S Albaladejo    ³ Data ³12.03.97  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra a EnchoiceBar na tela - WINDOWS 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450Edit(oSelecP,oSelecR,nTamChavE1,nTamChavE2)

Local nValor
Local cTitulo
Local nOldVal
Local nOldJur
Local nOldDes
Local nJurAtu
Local nDesAtu  
Local nOpca := 0

If TRB->RECEBER != 0
	cTitulo	:= STR0055  //"Altera Valor Receber"
	nOldVal	:= TRB->RECEBER
	nValor 	:= TRB->RECEBER
Else
	cTitulo := STR0056  //"Altera Valor Pagar"
	nOldVal:= TRB->PAGAR
	nValor := TRB->PAGAR
EndIf

nOldJur	:= TRB->JUROS
nOldDes	:= TRB->DESCONT
nOldMul	:= TRB->MULTA
nJurAtu	:= TRB->JUROS
nDesAtu	:= TRB->DESCONT
nMulAtu	:= TRB->MULTA

DEFINE MSDIALOG oDlg FROM	69,70 TO 300,331 TITLE cTitulo PIXEL
@ 0.5, 2 TO 95, 128 OF oDlg  PIXEL

@ 07, 68	MSGET TRB->PRINCIP Picture "@E 9999,999,999.99" When .F. SIZE 54, 10 OF oDlg PIXEL
@ 08, 09 SAY STR0078 SIZE 54, 7 OF oDlg PIXEL //"Valor Principal"

@ 17, 68	MSGET TRB->ABATIM Picture "@E 9999,999,999.99" When .F.	SIZE 54, 10 OF oDlg PIXEL
@ 18, 09 SAY STR0079 SIZE 54, 7 OF oDlg PIXEL //"Abatimentos"

@ 27, 68	MSGET TRB->ACRESC Picture "@E 9999,999,999.99" When .F. 	SIZE 54, 10 OF oDlg PIXEL
@ 28, 09 SAY STR0073  SIZE 54, 7 OF oDlg PIXEL //"Acrescimos"

@ 37, 68	MSGET TRB->DECRESC Picture "@E 9999,999,999.99" When .F. 	SIZE 54, 10 OF oDlg PIXEL
@ 38, 09 SAY STR0074  SIZE 54, 7 OF oDlg PIXEL //"Decrescimos"

@ 47, 68	MSGET nJurAtu		Picture "@E 9999,999,999.99" Valid F450AtuVal(@nValor,oValor,nJurAtu,@nOldJur,nDesAtu,@nOldDes,nMulAtu,@nOldMul,1) SIZE 54, 10 OF oDlg Hasbutton PIXEL
@ 48, 09 SAY STR0070  SIZE 54, 7 OF oDlg PIXEL  //"Valor a compensar" //"Juros"

@ 57, 68	MSGET nMulAtu		Picture "@E 9999,999,999.99" Valid F450AtuVal(@nValor,oValor,nJurAtu,@nOldJur,nDesAtu,@nOldDes,nMulAtu,@nOldMul,2) SIZE 54, 10 OF oDlg Hasbutton PIXEL
@ 58, 09 SAY STR0071  SIZE 54, 7 OF oDlg PIXEL  //"Valor a compensar" //"Multa"

@ 67, 68	MSGET nDesAtu		Picture "@E 9999,999,999.99" Valid F450AtuVal(@nValor,oValor,nJurAtu,@nOldJur,nDesAtu,@nOldDes,nMulAtu,@nOldMul,3) SIZE 54, 10 OF oDlg Hasbutton PIXEL
@ 68, 09 SAY STR0072  SIZE 54, 7 OF oDlg PIXEL  //"Valor a compensar" //"Descontos"

@ 77, 68	MSGET oValor VAR nValor Picture "@E 9999,999,999.99" Valid F450V(nValor,nJurAtu,nDesAtu,TRB->ACRESC,TRB->DECRESC,TRB->ABATIM,nMulAtu,nTamChavE1,nTamChavE2);
			SIZE 54, 10 OF oDlg Hasbutton PIXEL
@ 78, 9 SAY STR0057  SIZE 54, 7 OF oDlg PIXEL  //"Valor a compensar"

DEFINE SBUTTON FROM 98, 71 TYPE 1 ENABLE ACTION (nOpca:=1,F450VOk(nValor,nOldVal,nJurAtu,nDesAtu,nMulAtu),;
									Fa450Marca(nOldVal,oSelecP,oSelecR),;
									oDLg:End(),nOpca:=0) OF oDlg
DEFINE SBUTTON FROM 98, 99 TYPE 2 ENABLE ACTION (oDlg:End()) OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA450Marca³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 15/03/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Trata o dbeval para marcar e totalizar itens 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA450MARCA()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA450													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450Marca(nOldVal,oSelecp,oSelecR)

If Right(TRB->TIPO,1) != "-"
	If !Empty(TRB->MARCA)
		If TRB->RECEBER != 0
			nSelecR += RECEBER - nOldVal
		Else
			nSelecP += PAGAR - nOldVal
		Endif
	EndIF
EndIf
oSelecP:Refresh()
oSelecR:Refresh()

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³F450V	³ Autor ³ Pilar S Albaladejo    ³ Data ³12.03.97  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida o valor digitado 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F450V(nValor,nJurAtu,nDesAtu,nAcresc,nDecresc,nAbatim,nMulAtu,nTamChavE1,nTamChavE2)

Local lRet := .T.

If nValor == 0
	lRet := .F.
ElseiF nValor < nJurAtu + nMulAtu
	lRet := .F.  
Else
	If TRB->RECEBER != 0
		dbSelectArea("SE1")
		dbSetOrder(1)
		If	dbSeek(Substr(TRB->CHAVE,1,nTamChavE1))
			If SE1->E1_SALDO < nValor-nJurAtu-nMulAtu+nDesAtu-nAcresc+nDecresc+nAbatim
				Help(" ",1,"F450V")
				lRet := .F.
			Endif
		EndIf
	Else
		dbSelectArea("SE2")
		dbSetOrder(1)
		If	dbSeek(Substr(TRB->CHAVE,1,nTamChavE2))
			If SE2->E2_SALDO < nValor-nJurAtu-nMulAtu+nDesAtu-nAcresc+nDecresc+nAbatim
				Help(" ",1,"F450V")
				lRet := .F.
			Endif
		EndIf
	EndIf
EndIF
Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³F450VOK³ Autor ³ Pilar S Albaladejo	³ Data ³12.03.97  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica na confirmacao da tela, a validacao do valor - WIN³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F450VOk(nValor,nOldVal,nJur,nDesc,nMulta)

RecLock("TRB")
If TRB->RECEBER != 0
	If Empty(TRB->MARCA)
		nSelecR += nOldVal
	Endif
	Replace RECEBER	With nValor
Else
	If Empty(TRB->MARCA)
		nSelecP += nOldVal
	Endif
	Replace PAGAR With nValor
EndIf
Replace MARCA		With cMarca
Replace JUROS		With nJur
Replace DESCONT	With nDesc
Replace MULTA 		With nMulta
TRB->(MsUnlock())

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa450Pesq ³ Autor ³ Pilar S Albaladejo	³ Data ³12.03.97  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ tela de pesquisa - WINDOWS 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450Pesq(oMark)
Local cAliasAnt := Alias(),;
		nRecno				  ,;
		cAlias				  ,;
		nRecTrb				  ,;
		cChave              ,;
		cCampo				  ,;
		oDlg                
Local nOpc := 0, nOpcA := 0

DEFINE MSDIALOG oDlg FROM 90,11 TO 260,321 TITLE STR0058 PIXEL

@ 10,13 TO 53, 142 LABEL STR0005 OF oDlg	PIXEL
@ 24,27 RADIO nOpc PROMPT STR0029,STR0028 SIZE  60,9 OF oDlg PIXEL

DEFINE SBUTTON FROM 60, 85 TYPE 1 ENABLE OF oDlg ACTION If(nOpc > 0, (nOpcA := 1, cAlias := If(nOpc=1,"SE1","SE2"),oDlg:End()), MsgAlert(STR0065))
DEFINE SBUTTON FROM 60,115 TYPE 2 ENABLE OF oDlg ACTION (oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If nOpcA > 0
	DbSelectArea(cAlias)
	nRecno  := Recno()
	nRecTrb := TRB->(RecNo())
	cCampo  := Right(cAlias,2)
	
	// Obtem os campos de pesquisa de cAlias, para pesquisar no TRB, pois
	// os indice do TRB eh unico (FILIAL+PREFIXO+NUMERO+PARCELA+TIPO) e em
	// AxPesqui, o usuario pode escolher a chave desejada.
	
	If Eof()	.Or. Bof()	
		dbGotop()
	Endif	
	cChave := cAlias + "->("+cCampo+"_FILIAL+"+cCampo+"_PREFIXO+"+cCampo+"_NUM+"+cCampo+"_PARCELA+"+cCampo+"_TIPO)"		
	AxPesqui()
	
	// Posiciona no TRB o conteudo do registro de cAlias
	If ! TRB->(MSSeek(If(nOpc==1,"R","P")+&cChave))
		dbGoto(nRecNo)
		Trb->(DbGoto(nRecTrb))
	Endif
	oMark:oBrowse:Refresh(.T.)
Endif
DbSelectArea(cAliasAnt)

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa450OK   ³ Autor ³ Mauricio Pequim Jr	³ Data ³01.08.97  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que verifica se Campos necess rios estao preenchidos³±±
±±³    		 ³ na Compensacao CR - Windows								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450OK()

If Empty(cFor450) .or.;
	Empty(dVenIni450) .or. Empty(dVenFim450) 
	Help(" ",1,"FA450OK")
	lRet := .F.
else	
   lRet := .T.
endif  
If ExistBlock("FF450Vid")
	lRet    := ExecBlock("FF450Vid",.F.,.F.)
Endif

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA450CAN   ³ Autor ³ Mauricio Pequim Jr.	  ³ Data ³ 20/12/98³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cancelamento de Liquida‡„o                 			       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA450CAN()												   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                   
User Function FA450CAN(cAlias,cCampo,nOpcx,aCampos,aAutoCab)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local lPanelFin := IsPanelFin()
Local cArquivo,nTotal:=0,nHdlPrv:=0,nOpcT:=0
Local cTitulo := STR0061  //"Cancelamento"
Local lCabec := .F.
Local lPadrao:= VerPadrao("535")  // Cancelamento de Comp. Carteiras
Local cPadrao := "535"
Local lDigita := .T.
Local nTotAbat := 0
Local nValRec := 0
Local nValPag := 0
Local cIndex:=""
Local lBxUnica := .F.
Local nRec450 := Recno()
Local nJuros := 0
Local nDescont := 0
Local nMulta	:= 0
Local cFornece
Local cLoja
local aBaixaSE3 := {}   
Local nDecs	:=	2
Local nTaxa	:=	1
Local nValDifC	:=	0
Local lF450SE1C := ExistBlock("F450SE1C")
Local lF450SE2C := ExistBlock("F450SE2C")
Local aEstorno := {}
Local lEstorna := .F.
Local nX
Local aCancela := {}
Local lAltFilial := !Empty(xFilial("SE2")) .and. VerSenha(115) //permissao de editar registros de outras filiais
Local aFiliais := {}
Local nRecAtu	:= SM0->(RECNO())
Local cEmpAtu	:= SM0->M0_CODIGO
Local cFilCan	:= cFilAnt
Local cFilAtu	:= cFilAnt
Local nRecPnl	:= SE2->(Recno())
Local aFlagCTB := {}
Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
Local nInc		:= 0
Local aSM0		:= AdmAbreSM0()
Local aFilCod	:= {}
Local lF450Auto  := (aAutoCab <> NIL)
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"
Local lPccCC	:= SuperGetMV( "MV_CC10925" , , 1) == 2 .and. lPCCBaixa // Gera PCC na compensação entre carteiras quando PCC na baixa
Local lSomaPCC := .F.
Local aListIdCC := {}
Local nPosIdCC
Local nListBx
Local cFilter
Local nPCCCtbz := 0
Local nUltCmp := ""
Local aIdentees := {}
Local a450ListBx := {}
Local nRecSE2 := 0

Local aTabRecOri	:= {'',0}	// aTabRecOri[1]-> Tabela Origem ; aTabRecOri[2]-> RecNo
            
// Variaveis do Modelo de Gravacao do Movimento Financeiro
Local aAreaAnt := {}
Local oModelMov
Local cLog := ""
Local lRet := .T.
Local cAliasFK

Private cCompCan := CriaVar("E1_NUM" , .F.)
Private cLote
Private StrLctPad   := "" 

// Zerar variaveis para contabilizar os impostos da lei 10925.
VALOR5 := 0
VALOR6 := 0
VALOR7 := 0                   

// Estorna a operacao caso a matriz de rotina esteja com o conteudo 5 na posicao 4.
lEstorna := aRotina[nOpcx][4]==5

If !CtbValiDt(,dDatabase,,,,{"FIN001","FIN002"},) 
	Return
EndIf

If lEstorna
	cTitulo := STR0085  //"Estornar"
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LoteCont("FIN")

cCompCan	:= SE2->E2_IDENTEE
nRecSE2 	:= SE2->( Recno() )
nOpcT 	:= 0

//Abertura dos arquivos para utilizacao nas funcoes SumAbatPag e SumAbatRec
//Se faz necessario devido ao controle de transacao nao permitir abertura de arquivos
If Select("__SE1") == 0
	ChkFile("SE1",.F.,"__SE1")
Endif
If Select("__SE2") == 0
	ChkFile("SE2",.F.,"__SE2")
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega funcao Pergunte												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("AFI450",.T.)})
pergunte("AFI450",.F.)

If !lF450Auto

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³
	//³ -------------------------------------------------------------- ³
	//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
	//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
	//³ tracao e redivisao por 2 para a centralizacao. 					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAltFilial
		For nInc := 1 To Len( aSM0 )
			If aSM0[nInc][1] == cEmpAnt
				aAdd( aFiliais, aSM0[nInc][2]+ " - " + aSM0[nInc][6] )
				aAdd( aFilCod , aSM0[nInc][2])
			EndIf
		Next
		
		If lPanelFin  //Chamado pelo Painel Financeiro
			dbSelectArea(cAlias)
			oPanelDados := FinWindow:GetVisPanel()
			oPanelDados:FreeChildren()
			aDim := DLGinPANEL(oPanelDados)
			DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
			oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])
			nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 114) /2
			nEspLin  := 10
			oDlg:lMaximized := .F.
			oPanel4 := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
			oPanel4:Align := CONTROL_ALIGN_ALLCLIENT
		Else
			DEFINE MSDIALOG oDlg4 FROM	20,1 TO 140,340 TITLE cTitulo PIXEL
			nEspLarg := 2
			nEspLin  := 2
			oDlg4:lMaximized := .F.
			oPanel4 := TPanel():New(0,0,'',oDlg4,, .T., .T.,, ,20,20)
			oPanel4:Align := CONTROL_ALIGN_ALLCLIENT
		Endif
		
		@ nEspLin,  nEspLarg TO 56+nEspLin, 125+nEspLarg OF oPanel4 PIXEL
		@ 05+nEspLin, 14+nEspLarg SAY STR0087 SIZE 50, 7 OF oPanel4 PIXEL  //"Selecione a Filial"
		@ 14+nEspLin, 14+nEspLarg MSCOMBOBOX oCbx1 VAR cFilCan ITEMS aFiliais SIZE 90, 30 OF oPanel4 ;
			PIXEL ON CHANGE cFilAnt := aFilCod[oCbx1:nAt]
		@ 32+nEspLin, 14+nEspLarg SAY STR0062 SIZE 49, 07 OF oPanel4 PIXEL //"Nro. Compensa‡„o"
		@ 40+nEspLin, 14+nEspLarg MSGET cCompCan Valid If(nOpcT<>0,NaoVazio(cCompCan),.T.) SIZE 49, 11 OF oPanel4 PIXEL
		
	Else
		If lPanelFin  //Chamado pelo Painel Financeiro
			dbSelectArea(cAlias)
			oPanelDados := FinWindow:GetVisPanel()
			oPanelDados:FreeChildren()
			aDim := DLGinPANEL(oPanelDados)
			DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
			oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])
			nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 114) /2
			nEspLin  := 10
			oDlg:lMaximized := .F.
			oPanel4 := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
			oPanel4:Align := CONTROL_ALIGN_ALLCLIENT
		Else
			DEFINE MSDIALOG oDlg4 FROM	20,1 TO 120,340 TITLE cTitulo PIXEL
			nEspLarg := 2
			nEspLin  := 2
			oDlg4:lMaximized := .F.
			oPanel4 := TPanel():New(0,0,'',oDlg4,, .T., .T.,, ,20,20)
			oPanel4:Align := CONTROL_ALIGN_ALLCLIENT
		Endif
		
		@ nEspLin,  nEspLarg TO 36+nEspLin, 125+nEspLarg OF oPanel4 PIXEL
		@ 21+nEspLin, 14+nEspLarg MSGET cCompCan Valid If(nOpcT<>0,NaoVazio(cCompCan),.T.) SIZE 49, 11 OF oPanel4 PIXEL
		@ 11+nEspLin, 14+nEspLarg SAY STR0062 SIZE 49, 07 OF oPanel4 PIXEL //"Nro. Compensa‡„o"
	Endif
	
	
	If lPanelFin  //Chamado pelo Painel Financeiro
		ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
		{||nOpct:=1,IF(A450CalCn(cCompCan,@cIndex),oDlg:End(),nOpct:=0)},;
		{||nOpcT:=0,oDlg:End()})
	
	Else
		DEFINE SBUTTON FROM 10, 133 TYPE 1 ACTION (nOpct:=1,;
		IIF(NaoVazio(cCompCan) .and. A450CalCn(cCompCan,@cIndex),oDlg4:End(),nOpct:=0)) ENABLE OF oDlg4
		DEFINE SBUTTON FROM 23, 133 TYPE 2 ACTION (nOpcT:=0,oDlg4:End()) ENABLE OF oDlg4
		
		ACTIVATE MSDIALOG oDlg4 CENTERED
	Endif

Else
    
	A450CalCn(cCompCan,@cIndex)	
	nOpct := 1

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada que controla se o titulo sera cancelado/extornado ou nao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("F450CAES")
	nOpct := ExecBlock("F450CAES",.F.,.F.,{cCompCan,nOpct})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Integracao com o SIGAPCO para lancamento via processo³
//³PcoIniLan("000018")                                  ³                                                                                      	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoIniLan("000018")

If nOpct == 1
	//-- Parametros da Funcao LockByName() :
	//   1o - Nome da Trava
	//   2o - usa informacoes da Empresa na chave
	//   3o - usa informacoes da Filial na chave
	If LockByName(cCompCan,.T.,.F.)
		SE5->(dbGoTop())
		aEstorno := {}
		Begin Transaction
		While SE5->(!Eof())

			If SE5->E5_TIPODOC $ "DC/JR/MT/CM"
				SE5->(dbSkip())
				Loop
			Endif
			
			If (SE5->E5_RECPAG == "R" .And. !(SE5->E5_TIPO $ MV_CPNEG+"/"+MVPAGANT) ) .Or.( SE5->E5_RECPAG == "P" .And. ( SE5->E5_TIPO $ MV_CRNEG+"/"+MVRECANT ) )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cancela a compensacao de titulo a receber					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE1")
				dbSetOrder(2)
				If dbSeek(xFilial("SE1")+SE5->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)) 
					
					aTabRecOri := { 'SE5', SE5->( RECNO() ) }
					
					aBaixa:= Sel450Baixa( "VL /BA /CP /"+MV_CRNEG,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,,@a450ListBx,.T.)
					nDecs	:=	MsDecimais(SE1->E1_MOEDA)
					nTaxa	:=	SE5->E5_VALOR/SE5->E5_VLMOED2
					dDataAnt := Iif(Len(aBaixa)==1,CtoD(""),;
										a450ListBx[Len(aBaixa)-1,07])
					
					nTotAbat 	:= SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,;
											SE1->E1_PARCELA,SE1->E1_MOEDA,"V",SE5->E5_DATA)
					If cPaisLoc == "BRA"
						If SE1->E1_MOEDA <= 1
							nValRec		:= xMoeda(SE5->E5_VALOR,1,SE1->E1_MOEDA,SE5->E5_DATA)
						Else
							nValRec		:= Round(NoRound(xMoeda(SE5->E5_VALOR,1,SE1->E1_MOEDA,SE5->E5_DATA,3),3),2)	
						EndIf
						nJuros		:= xMoeda(SE5->E5_VLJUROS,1,SE1->E1_MOEDA,SE5->E5_DATA)
						nDescont		:= xMoeda(SE5->E5_VLDESCO,1,SE1->E1_MOEDA,SE5->E5_DATA)
						nMulta		:= xMoeda(SE5->E5_VLMULTA,1,SE1->E1_MOEDA,SE5->E5_DATA)
					Else
						nValRec		:= SE5->E5_VLMOED2
						nJuros		:= xMoeda(SE5->E5_VLJUROS,1,SE1->E1_MOEDA,SE5->E5_DATA,nDecs+1,Nil,nTaxa)
						nDescont		:= xMoeda(SE5->E5_VLDESCO,1,SE1->E1_MOEDA,SE5->E5_DATA,nDecs+1,Nil,nTaxa)
						nMulta		:= xMoeda(SE5->E5_VLMULTA,1,SE1->E1_MOEDA,SE5->E5_DATA,nDecs+1,Nil,nTaxa)
						nValDifC		:= SE5->E5_VLCORRE
					Endif				
					nValRec		+= nDescont - nJuros - nMulta
					nRec450 := SE1->(Recno())
					lBxUnica := IIf(STR(nValRec+nTotAbat+SE1->E1_SALDO,17,2) == STR(SE1->E1_VALOR,17,2),.T.,.F.) 
					StrLctPad   := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
					If (ALLTRIM(SE1->E1_ORIGEM) == "FINA677") .and. !(FINVERRES(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA),SE1->E1_ORIGEM, "R"))
						 	Help(" " , 1 , "FAVIAGEM") 
							DisarmTransaction()
							Return .F.
					Endif
					
					If nTotAbat > 0 .AND. SE1->E1_SALDO == 0
						nValRec += nTotAbat
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se h  abatimentos para voltar a carteira                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SE1->(dbSetOrder(1))
						If SE1->(dbSeek(xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA))
							cTitAnt := (SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
							While SE1->(!Eof()) .and. cTitAnt == (SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
								If !SE1->E1_TIPO  $MVABATIM
									SE1->(dbSkip())
									Loop
								Endif
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Volta t¡tulo para carteira                                       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								Reclock("SE1")
								SE1->E1_BAIXA   := Ctod(" /  /  ")
								SE1->E1_SALDO   := E1_VALOR
								SE1->E1_DESCONT := 0
								SE1->E1_JUROS   := 0
								SE1->E1_MULTA   := 0
								SE1->E1_CORREC  := 0
								SE1->E1_VARURV  := 0
								SE1->E1_VALLIQ  := 0
								SE1->E1_LOTE    := Space(Len(E1_LOTE))
								SE1->E1_DATABOR := Ctod(" /  /  ")
								SE1->E1_STATUS  := "A"
								SE1->E1_IDENTEE := ""
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Carrega variaveis para contabilizacao dos    ³
								//³ abatimentos (impostos da lei 10925).         ³			
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If SE1->E1_TIPO == MVPIABT
									VALOR5 := SE1->E1_VALOR			
								ElseIf SE1->E1_TIPO == MVCFABT
									VALOR6 := SE1->E1_VALOR
								ElseIf SE1->E1_TIPO == MVCSABT
									VALOR7 := SE1->E1_VALOR						
								Endif			
								SE1->(MsUnlock())
								SE1->(dbSkip())
							EndDo
						Endif
					Endif
					SE1->(dbGoto(nRec450))
					RecLock("SE1")
					SE1->E1_SALDO += nValRec
					SE1->E1_IDENTEE := ""   
					SE1->E1_BAIXA   := dDataAnt
					If cPaisLoc == "CHI" .And. nValDifC <> 0
						E1_CAMBIO	-=	nValDifC
					Endif			
					If lBxUnica
						SE1->E1_BAIXA   := Ctod(" /  /  ")
						SE1->E1_VALLIQ  := 0
						SE1->E1_SDACRES := SE1->E1_ACRESC
						SE1->E1_SDDECRE := SE1->E1_DECRESC
						SE1->E1_DESCONT := 0
						SE1->E1_JUROS   := 0
						SE1->E1_MULTA   := 0
						SE1->E1_CORREC  := 0
						SE1->E1_VARURV  := 0
						SE1->E1_VALLIQ  := 0
						SE1->E1_STATUS  := "A"
					Endif
					SE1->(MsUnLock())
					//Atualiza o Status de viagem
					If (ALLTRIM(SE1->E1_ORIGEM) == "FINA677")
						FINATURES(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA),.F.,SE1->E1_ORIGEM,"R")
					Endif
					
							/*
					Atualiza o status do titulo no SERASA */
					If cPaisLoc == "BRA"
						cChaveTit := xFilial("SE1") + "|" +;
									SE1->E1_PREFIXO + "|" +;
									SE1->E1_NUM		+ "|" +;
									SE1->E1_PARCELA + "|" +;
									SE1->E1_TIPO	+ "|" +;
									SE1->E1_CLIENTE + "|" +;
									SE1->E1_LOJA
						cChaveFK7 := FINGRVFK7("SE1",cChaveTit)
						F770BxRen("3","",cChaveFK7)
					Endif
					
					//Ponto de entrada para gravacoes complementares
					If lF450SE1C
						ExecBlock("F450SE1C",.F.,.F.)
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Inicializa variaveis para contabilizacao 					 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					VALOR := SE5->E5_VALOR
					VLRINSTR := VALOR
					If SE1->E1_MOEDA <= 5 .And. SE1->E1_MOEDA > 1
						cVal := Str(SE1->E1_MOEDA,1)
						If cPaisLoc == "BRA"
							VALOR&cVal := xMoeda(SE5->E5_VALOR,1,SE1->E1_MOEDA,SE5->E5_DATA)
						Else
							VALOR&cVal := SE5->E5_VLMOED2
						Endif						
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Cancela compensacao						 							 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE5")
					nRecSE5 := SE5->(recno())
					SE5->(dbGotop())
					While SE5->(!Eof()) .and. SE5->E5_IDENTEE == cCompCan
						If SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_RECPAG) == ;
							xFilial("SE5")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA+"R")

							If ! lEstorna
							    aadd(aCancela,SE5->(Recno()))
							Else
								aadd(aEstorno,SE5->(Recno()))
							Endif

							aadd(aBaixaSE3,{ SE5->E5_MOTBX , SE5->E5_SEQ , SE5->(Recno()) })
						Endif
						SE5->(dbSkip())
					Enddo
					SE5->(dbGoto(nRecSE5))
				EndIf
			Else								
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cancela a compensacao de titulo a pagar  					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				//If - Para processos COM retenção de PCC no título a Pagar na rotina compensação entre carteiras
				//Else - Para processos SEM retenção de PCC no título a Pagar na rotina compensação entre carteiras - PADRÃO
				If lPccCC .and. lPCCBaixa

					dbSelectArea("SE2")
					dbSetOrder(6)
					If dbSeek(xFilial("SE2")+SE5->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
						
						aTabRecOri := { 'SE5', SE5->( RECNO() ) }
						
						aBaixa	:=	{}	
						AADD(aBaixa,{"E2_PREFIXO" 	,SE2->E2_PREFIXO		, Nil})	// 01
						AADD(aBaixa,{"E2_NUM"     	,SE2->E2_NUM			, Nil})	// 02
						AADD(aBaixa,{"E2_PARCELA" 	,SE2->E2_PARCELA		, Nil})	// 03
						AADD(aBaixa,{"E2_TIPO"    	,SE2->E2_TIPO			, Nil})	// 04
						AADD(aBaixa,{"E2_FORNECE"	,SE2->E2_FORNECE		, Nil})	// 05
						AADD(aBaixa,{"E2_LOJA"    	,SE2->E2_LOJA			, Nil})	// 06
         	
	              		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Procura pelas baixas deste titulo                                     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cFilter := SE5->(DbFilter())
						SE5->(DbClearFilter())                                                                  	      
         	      
						aListIdCC := Sel450Baixa("VL /BA /CP /",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,;
											SE2->E2_FORNECE,SE2->E2_LOJA,@nPCCCtbz,@a450ListBx) 

						For nX := 1 to Len(a450ListBx)
							If a450ListBx[nX][19]<> ""
								aAdd(aIdentees,a450ListBx[nX][19])
							EndIf
						Next nX

						aSort(aIdentees)						
												
						nPosIdCC := Len(aListIdCC[1])-TamSx3("E5_IDENTEE")[1]+1
						
						nX := 1     
						nListBx := 0
						While nListBx == 0 .and. nx <= Len(aListIdCC)
							If SubStr(aListIdCC[nX],nPosIdCC,Len(aListIdCC[nX])) == cCompCan //SE5->E5_IDENTEE
								nListBx := nX         //para saber qual o numero da baixa a ser cancelada                            
							Else 
								nX ++								
							EndIf
						EndDo

						For nX := 1 to Len(aIdentees)
							If Len(aIdentees) > 1
								If aIdentees[Len(aIdentees)] == SE5->E5_IDENTEE
									nUltCmp := aIdentees[Len(aIdentees)-1]
									nX := Len(aIdentees)
								EndIf
							EndIf
						Next nX                                                  
                                                                                                                
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Inicializa variaveis para contabilizacao 					 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						// se tem impostos retidos, só pode cancelar a ultima baixa.
						If aIdentees[Len(aIdentees)] <> cCompCan .and. (SE2->E2_VRETPIS <> 0 .or. SE2->E2_VRETCOF <> 0 .or. SE2->E2_VRETCSL <> 0)
							//"Para títulos com impostos não é permitido cancelar uma baixa intermediária. É necessário que cancele a partir da ultima baixa." //"OK"
							Aviso(STR0083,STR0093,{STR0094})
							DisarmTransaction()
						   Exit
						EndIf

						If SuperGetMv("MV_BP10925",.T.,"1") == "1" 
							//Se nao for a ultima baixa parcial de um título baixado totalmente, nao soma o PCC na variavel de contabilização						
							If SE2->E2_SALDO <> 0
								nPCCCtbz :=0
							EndIf  
						Else                                       
							nPCCCtbz :=0
							For nX := 1 to Len(a450ListBx)
								If a450ListBx[nX][19] == cCompCan //SE5->E5_IDENTEE
									nPCCCtbz := a450ListBx[nX][11] + a450ListBx[nX][12] + a450ListBx[nX][13]
  		    					EndIf
  		       			Next nX
						End
						VALOR := SE5->E5_VALOR + nPCCCtbz
						VLRINSTR := VALOR
						If SE2->E2_MOEDA <= 5 .And. SE2->E2_MOEDA > 1
							cVal := Str(SE2->E2_MOEDA,1)
							VALOR&cVal := xMoeda(SE5->E5_VALOR+nPCCCtbz,1,SE2->E2_MOEDA,SE5->E5_DATA)
						EndIf

						MSExecAuto({|a,b,c,d| Fina080(a,b,c,d)},aBaixa,5,.f.,nListBx)						
						pergunte("AFI450",.F.)

						If lMsErroAuto
							MostraErro()
							DisarmTransaction()
						Else	
							RecLock("SE2",.F.)
							SE2->E2_IDENTEE := nUltCmp
								If ! lEstorna
									aadd(aCancela,SE5->(Recno()))
								Else
									aadd(aEstorno,SE5->(Recno()))
								Endif
							SE2->(MsUnLock())					
						EndIf

						DbSelectArea("SE5")
						If !Empty(cFilter)
							Set Filter To &cFilter
						Endif
						
					End
		  		Else																								
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Cancela a compensacao de titulo a receber					 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE2")
					dbSetOrder(6)
					If dbSeek(xFilial("SE2")+SE5->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
						
						aTabRecOri := { 'SE5', SE5->( RECNO() ) }
						
						nDecs	:=	MsDecimais(SE2->E2_MOEDA)
						nTaxa	:=	SE5->E5_VALOR/SE5->E5_VLMOED2
						
						nTotAbat 	:= SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
												SE2->E2_FORNECE,SE2->E2_MOEDA,"V",SE5->E5_DATA,SE2->E2_LOJA)
						If cPaisLoc == "BRA"
							If SE2->E2_MOEDA <= 1
								nValPag		:= xMoeda(SE5->E5_VALOR,1,SE2->E2_MOEDA,SE5->E5_DATA)
							Else
								nValPag		:= Round(NoRound(xMoeda(SE5->E5_VALOR,1,SE2->E2_MOEDA,SE5->E5_DATA,3),3),2)	
							EndIf
							nJuros		:= xMoeda(SE5->E5_VLJUROS,1,SE2->E2_MOEDA,SE5->E5_DATA)
							nDescont		:= xMoeda(SE5->E5_VLDESCO,1,SE2->E2_MOEDA,SE5->E5_DATA)
							nMulta		:= xMoeda(SE5->E5_VLMULTA,1,SE2->E2_MOEDA,SE5->E5_DATA)
						Else
							nValPag		:= SE5->E5_VLMOED2
							nJuros		:= xMoeda(SE5->E5_VLJUROS,1,SE2->E2_MOEDA,SE5->E5_DATA,nDecs+1,Nil,nTaxa)
							nDescont		:= xMoeda(SE5->E5_VLDESCO,1,SE2->E2_MOEDA,SE5->E5_DATA,nDecs+1,Nil,nTaxa)
							nMulta		:= xMoeda(SE5->E5_VLMULTA,1,SE2->E2_MOEDA,SE5->E5_DATA,nDecs+1,Nil,nTaxa)
							nValDifC		:= SE5->E5_VLCORRE
						Endif
						nValPag		+= nDescont - nJuros - nMulta
						cFornece		:= SE2->E2_FORNECE
						cLoja			:= SE2->E2_LOJA
						StrLctPad   := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
						nRec450 := SE2->(Recno())
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Caso esteja utilizando outras moedas, faz o acerto do valor do ³
						//³ titulo se a diferença for de 0.01				           	   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SE2->E2_MOEDA > 1 .And. Round(((nValPag+nTotAbat+SE2->E2_SALDO)-SE2->E2_VALOR),2) = 0.01
							nValPag -= 0.01
						EndIf
						lBxUnica := IIf(STR(nValPag+nTotAbat+SE2->E2_SALDO,17,2) == STR(SE2->E2_VALOR,17,2),.T.,.F.) 
						If (ALLTRIM(SE2->E2_ORIGEM) $ "FINA667|FINA677") .and. !(FINVERRES(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),SE2->E2_ORIGEM, "P"))
 							Help(" " , 1 , "FAVIAGEM") 
							DisarmTransaction()
							Return .F.
						Endif
						If lBxUnica .and. nTotAbat > 0
							nValPag += nTotAbat
							*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							*³Verifica se h  abatimentos para voltar a carteira					  ³
							*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							SE2->(dbSetOrder(1))
							If SE2->(dbSeek(xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA))
								cTitAnt := (SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA)
								While !SE2->(Eof()) .and. cTitAnt == (SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA)
									IF !SE2->E2_TIPO $ MVABATIM
										SE2->(dbSkip())
										Loop
									EndIF
									IF SE2->E2_FORNECE+SE2->E2_LOJA != cFornece+cLoja
										SE2->(dbSkip())
										Loop
									EndIF 
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Volta titulo para carteira 				  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									RecLock("SE2",.F.)
									SE2->E2_BAIXA	:= Ctod(" /  /  ")
									SE2->E2_SALDO	:= E2_VALOR
									SE2->E2_VALLIQ	:= 0 
									SE2->E2_IDENTEE := ""
									SE2->E2_DESCONT := 0
									SE2->E2_JUROS   := 0
									SE2->E2_MULTA   := 0
									SE2->E2_CORREC  := 0
									SE2->(MsUnlock())
									SE2->(dbSkip())
								Enddo
							Endif
						Endif
						SE2->(dbGoto(nRec450))
						RecLock("SE2",.F.)
						SE2->E2_SALDO += nValPag
						SE2->E2_IDENTEE := ""
						If cPaisLoc == "CHI" .And. nValDifC <> 0
							E2_CAMBIO	-=	nValDifC
						Endif			
						If lBxUnica
							SE2->E2_BAIXA   := Ctod(" /  /  ")
							SE2->E2_VALLIQ  := 0
							SE2->E2_SDACRES := SE2->E2_ACRESC
							SE2->E2_SDDECRE := SE2->E2_DECRESC
							SE2->E2_DESCONT := 0
							SE2->E2_JUROS   := 0
							SE2->E2_MULTA   := 0
							SE2->E2_CORREC  := 0
						Endif
						SE2->(MsUnLock())
						//Ponto de entrada para gravacoes complementares
						If lF450SE2C
							ExecBlock("F450SE2C",.F.,.F.)
						Endif    
						
						If (ALLTRIM(SE2->E2_ORIGEM) $ "FINA667|FINA677")
							FINATURES(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),.F., SE2->E2_ORIGEM,"P")
						Endif
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Inicializa variaveis para contabilizacao 					 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						VALOR := SE5->E5_VALOR
						VLRINSTR := VALOR
						If SE2->E2_MOEDA <= 5 .And. SE2->E2_MOEDA > 1
							cVal := Str(SE2->E2_MOEDA,1)
							If cPaisLoc == "BRA"
								VALOR&cVal := xMoeda(SE5->E5_VALOR,1,SE2->E2_MOEDA,SE5->E5_DATA)
							Else
								VALOR&cVal := SE5->E5_VLMOED2
							Endif						
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Cancela compensacao						 				 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SE5")
						nRecSE5 := SE5->(recno())
						SE5->(dbGotop())
						While SE5->(!Eof()) .And. SE5->E5_IDENTEE == cCompCan
							If SE5->(!Eof()) .and. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_RECPAG) == ;
								xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA+"P")
								If ! lEstorna
									Aadd(aCancela, SE5->(Recno()))
								Else
									Aadd(aEstorno, SE5->(Recno()))
								Endif
							Endif
							SE5->(dbSkip())
						Enddo
						SE5->(dbGoto(nRecSE5))
					EndIf
				Endif	
			Endif
			If (SE5->E5_RECPAG == "R" .And. !(SE5->E5_TIPO $ MV_CPNEG+"/"+MVPAGANT) ) .Or.( SE5->E5_RECPAG == "P" .And. (SE5->E5_TIPO $ MV_CRNEG+"/"+MVRECANT))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona SA1 para contabiliza‡Æo        					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA1")
				dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)    
				IF SE5->E5_RECPAG == "R" .And. SE5->E5_TIPO $ MV_CPNEG+"/"+MVPAGANT  .Or.  SE5->E5_RECPAG == "P" .And. SE5->E5_TIPO $ MV_CRNEG+"/"+MVRECANT
					AtuSalDup("-",nValRec,SE1->E1_MOEDA,SE1->E1_TIPO,,SE1->E1_EMISSAO)
				Else
					AtuSalDup("+",nValRec,SE1->E1_MOEDA,SE1->E1_TIPO,,SE1->E1_EMISSAO)
				EndIf	
				
				dbSelectArea("SE2")
				dbGobottom()
				dbSkip()
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona SA2 para contabiliza‡Æo        					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA2")
				dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
				RecLock("SA2")
				IF SE5->E5_RECPAG == "R" .And. SE5->E5_TIPO $ MV_CPNEG+"/"+MVPAGANT  .Or.  SE5->E5_RECPAG == "P" .And. SE5->E5_TIPO $ MV_CRNEG+"/"+MVRECANT
					SA2->A2_SALDUP		-= nValPag
					SA2->A2_SALDUPM -= xMoeda(nValPag,1,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,3)
				Else
					SA2->A2_SALDUP		+= nValPag
					SA2->A2_SALDUPM += xMoeda(nValPag,1,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,3)
				EndIf	
				SA2->(MsUnLock())
				
				dbSelectArea("SE1")
				dbGobottom()
				dbSkip()
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Contabiliza															 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If !lCabec .and. lPadrao
				nHdlPrv := HeadProva( cLote,;
				                      "FINA450",;
				                      Substr( cUsuario, 7, 6 ),;
				                      @cArquivo )

				lCabec := .t.
			Endif
			If lCabec .and. lPadrao .and. (VALOR+VALOR2+VALOR3+VALOR4+VALOR5) > 0
				nTotal += DetProva( nHdlPrv,;
				                    cPadrao,;
				                    "FINA450",;
				                    cLote,;
				                    /*nLinha*/,;
				                    /*lExecuta*/,;
				                    /*cCriterio*/,;
				                    /*lRateio*/,;
				                    /*cChaveBusca*/,;
				                    /*aCT5*/,;
				                    .F.,;
				                    @aFlagCTB,;
				                    aTabRecOri,;
				                    /*aDadosProva*/ )

			Endif
			
			dbSelectArea("SE5")
			dbSetOrder(1)
			SE5->(dbSkip())

		Enddo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recupera a Integridade dos dados							 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE5")
		RetIndex("SE5")
		Set Filter to
		If !Empty(cIndex)
			Ferase(cIndex+OrdBagExt())
		Endif
		
		For nx := 1 To Len(aCancela)
			SE5->(dbGoto(aCancela[nx])) 

			//Posiciona a FK5 para mandar a operação de alteração com base no registro posicionado da SE5
			cAliasFK := if(SE5->E5_RECPAG= "R","FK1", "FK2") 
			If AllTrim( SE5->E5_TABORI ) == cAliasFK
				aAreaAnt := GetArea()
				dbSelectArea( cAliasFK )
				(cAliasFk)->( DbSetOrder( 1 ) )
				If MsSeek( xFilial(cAliasFK) + SE5->E5_IDORIG )
					oModelMov := FWLoadModel(if(SE5->E5_RECPAG= "R","FINM010","FINM020")) //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
					oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
					oModelMov:Activate()      
					//Posiciona a FKA com base no IDORIG da SE5 posicionada
					oSubFKA := oModelMov:GetModel( "FKADETAIL" )
					oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

					oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação SE5
					//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
					//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
					//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
					oModelMov:SetValue( "MASTER", "E5_OPERACAO", 1 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
				
					If oModelMov:VldData()
	    			   	oModelMov:CommitData()
	    			   	oModelMov:DeActivate()
	   				Else
						lRet := .F.
		    			cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
		    			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
		   				cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
    
	       				If !lF450Auto      
	       					Help( ,,"MF450VID6",,cLog, 1, 0 )
       	   				Endif	
					Endif								
				Endif
				RestArea(aAreaAnt)
			Endif
		Next

		For nX :=1 To Len(aEstorno)
			SE5->(dbGoTo( aEstorno[nX] ))

			//Posiciona a FK5 para mandar a operação de alteração com base no registro posicionado da SE5
			cAliasFK := If(SE5->E5_RECPAG= "R","FK1", "FK2")
			If AllTrim( SE5->E5_TABORI ) == cAliasFK
				aAreaAnt := GetArea()
				dbSelectArea( cAliasFK )
				(cAliasFk)->( DbSetOrder( 1 ) )
				If MsSeek( xFilial(cAliasFK) + SE5->E5_IDORIG )
					oModelMov := FWLoadModel(if(SE5->E5_RECPAG= "R","FINM010","FINM020")) //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
					oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
					oModelMov:Activate()

					//Posiciona a FKA com base no IDORIG da SE5 posicionada
					oSubFKA := oModelMov:GetModel( "FKADETAIL" )
					oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

					cCamposE5 := "{"
					cCamposE5 += "{'E5_SITUACA', 'X'}"
					cCamposE5 += "}"

					oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação SE5
					oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5 

					//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
					//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
					//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
					oModelMov:SetValue( "MASTER", "E5_OPERACAO", 2 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5

					If oModelMov:VldData()
						oModelMov:CommitData()
						SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))
						oModelMov:DeActivate()
					Else
						lRet := .F.
						cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
						cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
						cLog += cValToChar(oModelMov:GetErrorMessage()[6])

						If !lF450Auto
							Help( ,,"M450SITX",,cLog, 1, 0 )
						Endif
					Endif

					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
					EndIf
				EndIf
				RestArea(aAreaAnt)
			EndIf
		Next nX

		IF lPadrao .and. lCabec .and. nTotal > 0
			RodaProva(  nHdlPrv,;
						nTotal)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lancamento Contabil						³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lDigita:=IIF(mv_par01==1,.T.,.F.)
			lAglut :=IIF(mv_par02==1,.T.,.F.)
			cA100Incl( cArquivo,;
			           nHdlPrv,;
			           3,;
			           cLote,;
			           lDigita,;
			           lAglut,;
			           /*cOnLine*/,;
			           /*dData*/,;
			           /*dReproc*/,;
			           @aFlagCTB,;
			           /*aDadosProva*/,;
			           /*aDiario*/ )
			aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

		Endif
		
		UnLockByName(cCompCan,.T.,.F.)
		End Transaction
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Integracao com o SIGAPCO para lancamento via processo³
		//³PCODetLan("000018","01","FINA450",.T.)               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SE2->( dbGoto(nRecSE2) )
		PCODetLan("000018","01","FINA450",.T.)
		
	Else
		MsgAlert(STR0084, STR0083) // "Existe outro usuário cancelando esta compensação. Não é permitido o cancelamento da mesma compensação por dois usuários ao mesmo tempo." ## "Atenção"
	Endif			
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE5")
RetIndex("SE5")
Set Filter to
If !Empty(cIndex)
	Ferase(cIndex+OrdBagExt())
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estorna Comissao                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Fa440DeleB(aBaixaSE3,.F.,.F.,"FINA070")

cFilAnt := cFilAtu

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Integracao com o SIGAPCO para lancamento via processo³
//³PcoFinLan("000018")                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoFinLan("000018")

SE2->(MSGOTO(nRecPnl))

Return (.T.)
	
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ A450FCan   ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 02/02/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Sele‡„o para a cria‡„o do indice condicional no CANCELAMENTO ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina450														³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A450FCan()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devera selecionar todos os registros que atendam a seguinte condi‡„o : 	  ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ 2. Ou titulos que tenham originado a liquidacao selecionada 			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cFiltro
cFiltro := 'E5_FILIAL=="'+xFilial("SE5")+'".And.'
cFiltro += 'E5_IDENTEE=="'+cCompCan+'".And.'
cFiltro += 'Dtos(E5_DATA)<="'+Dtos(dDataBase)+'".And.'
cFiltro += 'E5_TIPODOC<>"ES".And.'
cFiltro += 'E5_SITUACA<>"C".And.'
cFiltro += 'E5_SITUACA<>"X"' 

If ExistBlock("F450FCA")
	cFiltro += '.And.'
	cFiltro += ExecBlock("F450FCA",.F.,.F.)
EndIf  

Return cFiltro


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ A450CalCn  ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 02/02/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calcula Parcelas, Nro.Titulos e valor da Liquida. a cancelar ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina450													    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A450CalCn(cCompCan,cIndex)
Local cChave
Local nIndex

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria indice condicional separando os titulos que deram origem a ³
//³ liquidacao e os titulos que foram gerados							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE5")
cIndex := CriaTrab(nil,.f.)
cChave := IndexKey(1)
IndRegua("SE5",cIndex,cChave,,A450FCAN(),STR0026)  //"Selecionando Registros..."
nIndex := RetIndex("SE5")
dbSelectArea("SE5")
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbGoTop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Certifica se foram encontrados registros na condi‡„o selecionada	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If BOF() .and. EOF()
	Help(" ",1,"RECNO")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura os indices do SE5 e deleta o arquivo de trabalho		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	Set Filter to
	RetIndex("SE5")
	fErase(cIndex+OrdBagExt())
	cIndex := ""
	dbSetOrder(1)
	Return .F.
EndIf
dbSelectArea("SE5")
Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa450SetMo³ Autor ³ Fernando Machima      ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tela de taxas de moedas                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA450 												      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fa450SetMo()
	Local oDlg, nLenMoedas	:= Len(aTxMoedas)

	If nLenMoedas > 1
		DEFINE MSDIALOG oDlg From 200,0 TO 362,230 TITLE STR0060 PIXEL
		@ 005,005  To 062,110 OF oDlg PIXEL
		@ 012,010 SAY  aTxMoedas[2][1]  Of oDlg PIXEL
		@ 010,060 MSGET aTxMoedas[2][2] PICTURE aTxMoedas[1][3] Of oDlg PIXEL
		If nLenMoedas > 2
			@ 024,010 SAY  aTxMoedas[3][1]  Of oDlg PIXEL
			@ 022,060 MSGET aTxMoedas[3][2] PICTURE aTxMoedas[2][3] Of oDlg PIXEL
			If nLenMoedas > 3
				@ 036,010 SAY  aTxMoedas[4][1]  Of oDlg PIXEL
				@ 034,060 MSGET aTxMoedas[4][2] PICTURE aTxMoedas[3][3] Of oDlg PIXEL
				If nLenMoedas > 4
					@ 048,010 SAY  aTxMoedas[5][1]  Of oDlg PIXEL
					@ 046,060 MSGET aTxMoedas[5][2] PICTURE aTxMoedas[4][3] Of oDlg PIXEL
				Endif
			Endif
		Endif
		DEFINE  SButton FROM 064,80 TYPE 1 Action (oDlg:End() ) ENABLE OF oDlg  PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		Help("",1,STR0025)
	Endif
Return


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o	 ³F450AtuVal³ Autor ³ Mauricio Pequim Jr.   ³ Data ³23.09.03  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Atualiza os valores na tela de Edicao da Enchoicebar 	  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ Generico 												  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F450AtuVal(nValor,oValor,nJurAtu,nOldJur,nDesAtu,nOldDes,nMulAtu,nOldMul,nOpera)
	Local lRet := .T.

	If nJurAtu < 0
		lRet := .F.
	Endif
	If lRet .and. nDesAtu < 0
		lRet := .F.
	Endif
	If lRet .and. nDesAtu < 0
		lRet := .F.
	Endif
	If lRet .and. nValor + nJurAtu + nMulAtu - nDesAtu - nOldJur - nOldMul + nOldDes <= 0
		lRet := .F.
	Endif
	If lRet
		nValor := nValor
		If nOpera == 1  //Juros
			nValor := nValor + nJurAtu - nOldJur
			nOldJur := nJurAtu
		ElseIf nOpera == 2  //Multa
			nValor := nValor + nMulAtu - nOldMul
			nOldMul := nMulAtu
		ElseIf nOpera == 3  //Descontos
			nValor := nValor - nDesAtu + nOldDes
			nOldDes := nDesAtu
		Endif
		oValor:Refresh()
	Endif

Return lRet

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o	 ³Fa450GrvEst³ Autor ³ Claudio D. de Souza   ³ Data ³ 21/09/05 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Grava o movimento de estorno da baixa por CEC       		   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe	 ³ Fa450GrvEst(ExpN1)          								   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpN1 = Numero do registro do movimento a ser estornado	   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa450GrvEst(nRecnoSe5,lUsaFlag)
	Local aAreaSe5	:= SE5->(GetArea())
	Local nX
	Local aCampos	:= {}
// Variaveis do Modelo de Gravacao do Movimento Financeiro
	Local aAreaAnt := {}
	Local oModelMov
	Local cLog := ""
	Local lRet := .T.
	Local cAliasFK

// Posiciona no registro a ser estornado
	SE5->(MsGoto(nRecnoSe5))

// Grava registro de estorno baseado no registro que foi estornado, alterando os campos TIPODOC e RECPAG

//Posiciona a FK5 para mandar a operação de alteração com base no registro posicionado da SE5
	cAliasFK := if(SE5->E5_RECPAG == "P","FK2", "FK1")
	If AllTrim( SE5->E5_TABORI ) == cAliasFK
		aAreaAnt := GetArea()
		oModelMov := FWLoadModel(if(SE5->E5_RECPAG= "R","FINM010","FINM020")) //Inverte o model para gravar o estorno
		oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
		oModelMov:Activate()
		//Posiciona a FKA com base no IDORIG da SE5 posicionada
		oSubFKA := oModelMov:GetModel( "FKADETAIL" )
		oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )
		oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação SE5
		//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
		//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
		//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
		oModelMov:SetValue( "MASTER", "E5_OPERACAO", 2 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
		oSubFK5 := oModelMov:GetModel("FK5DETAIL")
		oSubFK5:SetValue( "FK5_HISTOR", STR0086)

		If oModelMov:VldData()
			oModelMov:CommitData()
			oModelMov:DeActivate()
		Else
			lRet := .F.
			cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[6])

			Help( ,,"MF450VID7",,cLog, 1, 0 )
		Endif
		RestArea(aAreaAnt)

	EndIf

Return Nil

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³27/11/06 ³±±
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
	±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados   	  ³±±
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

	Local aRotina := { { STR0001, "AxPesqui"   , 0 , 1,,.F.} ,;  //"Pesquisar"
	{ STR0002, 	"AxVisual"   	, 0 , 2} ,;  //"Visualizar"
	{ STR0003, 	"U_Fa450CMP"   	, 0 , 3} ,;  //"Compensar"
	{ STR0060, 	"U_Fa450Can"   	, 0 , 6} ,;
		{ STR0085, 	"U_Fa450Can"   	, 0 , 5} ,; 	 	// Estornar
	{ STR0089,	"U_Fa450Leg"		, 0	, 7,,.F.}}	// "Legenda"

// Ponto de entrada para inclusao de botao na barra de ferramentas
	If ExistBlock("FA450BUT")
		aRotina := Execblock("FA450BUT",.F.,.F.,{aRotina})
	Endif

Return(aRotina)

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³FinA450T   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 26.03.08 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Chamada semi-automatica utilizado pelo gestor financeiro   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ FINA450                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FinA450T(aParam)

	cRotinaExec := "FINA450"
	ReCreateBrow("SE2",FinWindow)
	FinA450(aParam[1])
	dbSelectarea("SE2")
	FinVisual("SE2",FinWindow,SE2->(Recno()),.T.)
	ReCreateBrow("SE2",FinWindow)

	dbSelectArea("SE2")

	INCLUI := .F.
	ALTERA := .F.

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FA450MotBXºAutor  ³Marcelo Celi Marquesº Data ³  29/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao criar automaticamente o motivo de baixa CEC na      º±±
±±º          ³ tabela Mot baixas                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA450                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                    
User Function Fa450MotBx(cMot,cNomMot, cConfMot)
	Local aMotbx := ReadMotBx()
	Local nHdlMot, I, cFile := "SIGAADV.MOT"

	If ExistBlock("FILEMOT")
		cFile := ExecBlock("FILEMOT",.F.,.F.,{cFile})
	Endif

	If Ascan(aMotbx, {|x| Substr(x,1,3) == Upper(cMot)}) < 1
		nHdlMot := FOPEN(cFile,FO_READWRITE)
		If nHdlMot <0
			HELP(" ",1,"SIGAADV.MOT")
			Final("SIGAADV.MOT")
		Endif

		nTamArq:=FSEEK(nHdlMot,0,2)	// VerIfica tamanho do arquivo
		FSEEK(nHdlMot,0,0)			// Volta para inicio do arquivo

		For I:= 0 to  nTamArq step 19 // Processo para ir para o final do arquivo
			xBuffer:=Space(19)
			FREAD(nHdlMot,@xBuffer,19)
		Next

		fWrite(nHdlMot,cMot+cNomMot+cConfMot+chr(13)+chr(10))
		fClose(nHdlMot)
	EndIf
Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AdmAbreSM0()

	Local aArea		:= SM0->( GetArea() )
	Local aRetSM0	:= {}

	aRetSM0	:= FWLoadSM0()

	RestArea( aArea )

Return aRetSM0

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa450Leg  ºAutor  ³Pablo Gollan Carreras º Data ³  16/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                              º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FINA450                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Fa450Leg(nReg)

	Local uRetorno		:= .T.
	Local aLegen		:= {{"ENABLE",STR0090},{"DISABLE",STR0091},{"BR_AZUL",STR0092}}

	If Empty(nReg)
		uRetorno := {}
		aAdd(uRetorno, {'E2_SALDO =  E2_VALOR .AND. E2_ACRESC = E2_SDACRES', aLegen[1][1]}) // Titulo nao Compensado
		aAdd(uRetorno, {'E2_SALDO =  0', aLegen[2][1]})			// Titulo Compensado Totalmente
		aAdd(uRetorno, {'E2_SALDO <> 0', aLegen[3][1]})			// Titulo Compensado Parcialmente
	Else
		BrwLegenda(cCadastro,STR0089,aLegen)
	Endif

Return(uRetorno)


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³Sel450baix³ Autor ³ Adrianne Furtado      ³ Data ³ 06/07/10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Traz lista de Baixas para serem canceladas                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³Sel450Baixa()                                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³FINA450	                                                  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Sel450Baixa(cTipoDoc,cPrefixo, cNum, cParcela,cTipo,cFornece,cLoja, nTotPCC, a450ListBx,lRec)

	Local __k
	Local cTipoBaixa
	Local nRecAtu
	Local cSequencia
	Local lEstornada := .f.
	Local aBaixa := {}
	Local cNumero

//ChkFile("SE5",.F.,"__SUBS")
	Local aAreaSE5 := SE5->(GetArea())
	Local cFilter := SE5->(DbFilter())
	Local cIndKey := SE5->(IndexKey())

	Default nTotPCC := 0 //variavel para retornar o total de PCC retido nesse titulo
	Default a450ListBx := {}
	Default lRec := .F.

	nTotPCC := 0

	SE5->(DbClearFilter())

	FOR __k := 1 TO Len(cTipoDoc) Step 4

		cTipoBaixa := AllTrim(Substr(cTipodoc,__k,3 ) )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Procura pela baixas dependendo do Tipodoc passado como parametro      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE5")
		SE5->(dbSetOrder(2))
		SE5->(dbSeek(xFilial()+cTipoBaixa+cPrefixo+cNum+cParcela+cTipo))
		While !SE5->(Eof()) .and. SE5->E5_FILIAL==xFilial() .and. ;
				SE5->E5_TIPODOC+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO==cTipoBaixa+cPrefixo+cNum+cParcela+cTipo

			If SE5->E5_MOTBX $ "FAT#DSD"
				dbSkip()
				Loop
			Endif

			If SE5->E5_MOTBX $"PCC,IRF"
				If SE5->E5_MOTBX == "PCC"
					dbSkip()
					Loop
				Endif
			Endif

			IF SE5->E5_SITUACAO == "C"
				SE5->(dbSkip())
				Loop
			EndIF


			If !lRec
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					IF SE5->E5_RECPAG != "R" .And. IIf(cpaisloc=="BRA",.T.,Empty(SE5->E5_ORDREC))
						SE5->(dbSkip())
						Loop
					EndIF
				Else
					IF SE5->E5_RECPAG != "P" .And. IIf(cpaisloc=="BRA",.T.,Empty(SE5->E5_ORDREC))
						SE5->(dbSkip())
						Loop
					EndIF
				Endif
			Else
				If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG

					IF SE5->E5_RECPAG != "P" .And. IIf(cpaisloc=="BRA",.T.,Empty(SE5->E5_ORDREC))
						SE5->(dbSkip())
						Loop
					EndIF
				Else
					IF SE5->E5_RECPAG != "R"  .And. IIf(cpaisloc=="BRA",.T.,Empty(SE5->E5_ORDREC))
						SE5->(dbSkip())
						Loop
					EndIF
				Endif
			EndIf



			IF SE5->E5_CLIFOR != cFornece .OR. SE5->E5_LOJA != cLoja
				SE5->(dbSkip())
				Loop
			EndIF

			If cTipoBaixa == "BA" .and. ( SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVRECANT) .AND. !EMPTY(SE5->E5_DOCUMEN) .And. IIf(cpaisloc=="BRA",.T.,Empty(SE5->E5_ORDREC))
				dbskip()
				loop
			EndIf


			nRecAtu := SE5->(recno())
			cSequencia := SE5->E5_SEQ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se existe uma baixa cancelada para esta baixa efetuada       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SE5->(dbSeek(xFilial()+"ES"+cPrefixo+cNum+cParcela+cTipo))
			While !SE5->(Eof()) .and. SE5->E5_FILIAL==xFilial() .and. ;
					SE5->E5_TIPODOC+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO=="ES"+cPrefixo+cNum+cParcela+cTipo

				If SE5->E5_MOTBX == "FAT"
					dbSkip()
					Loop
				Endif

				IF SE5->E5_CLIFOR != cFornece .OR. SE5->E5_LOJA != cLoja
					SE5->(dbSkip())
					Loop
				EndIF

				if SE5->E5_SEQ == cSequencia
					lEstornada := .T.
					Exit
				EndIf
				SE5->( dbSkip() )
			EndDo
			SE5->(dbGoTo(nRecAtu))
			If lEstornada
				lEstornada := .f.
				SE5->(dbSkip())
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Aten‡„o, o array aBaixaSE5 ‚ o elemento fundamental para que ³
			//³a baixa funcione a contento. Se for necess rio alter -lo,deve³
			//³ser feito com a MAXIMA ATENCAO, pois as variaveis tratadas na³
			//³funcao est„o com posi‡”es fixas dentro do array              ³
			//³Mem¢ria de Calculo do array em quest„o.                      ³
			//³                                                             ³
			//³Informa‡„o        Posicao     Tamanho  					    ³
			//³                                                             ³
			//³Prefixo            01           03  					        ³
			//³Numero             02           12           				³
			//³Parcela            03           01						    ³
			//³Tipo               04           03					        ³
			//³Cliente/Fornec     05           06					        ³
			//³Loja               06           02					        ³
			//³Data da baixa      07           08					        ³
			//³Valor              08           15					        ³
			//³Sequencia          09           02					        ³
			//³Data Dispon.       10           08					        ³
			//³Banco              11           03					        ³
			//³Agencia            12           05					        ³
			//³Conta              13           10					        ³
			//³Dt. Disponibil.    14           08				            ³
			//³Identee			    15           do campo E5_IDENTEE      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cNumero := SE5->E5_NUMERO+Iif(Len(SE5->E5_NUMERO)==TamSx3("E5_NUMERO")[1],Space(Len(SE5->E5_NUMERO)),"")

			If !lRec
				// Para apresentar o valor a compensar, retorno o PCC retido na soma das baixas
				nTotPCC += If(SE5->(E5_PRETCSL) == " ",SE5->(E5_VRETCSL),0)
				nTotPCC += If(SE5->(E5_PRETPIS) == " ",SE5->(E5_VRETPIS),0)
				nTotPCC += If(SE5->(E5_PRETCOF) == " ",SE5->(E5_VRETCOF),0)
			EndIf

			Aadd(aBaixa,SE5->E5_PREFIXO+" "+cNumero       +;
				" "+SE5->E5_PARCELA+" "+E5_TIPO+" "+E5_CLIFOR +;
				" "+E5_LOJA+" "+Dtoc(E5_DATA)        +;
				" "+Transf(E5_VALOR,"@E 9999,999,999.99")+"   "+E5_SEQ  + SE5->E5_IDENTEE)

			Aadd(a450ListBx,{ SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO	,;
				SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_DATA				,;
				SE5->E5_VALOR,SE5->E5_SEQ,SE5->E5_DTDISPO				,;
				SE5->E5_VRETPIS,SE5->E5_VRETCOF,SE5->E5_VRETCSL,;
				SE5->E5_PRETPIS,SE5->E5_PRETCOF,SE5->E5_PRETCSL,;
				SE5->E5_TIPODOC,SE5->E5_MOTBX  ,SE5->E5_IDENTEE})

			SE5->(dbSkip())
		EndDo
	Next __k


	DbSelectArea("SE5")
	If !Empty(cFilter)
		Set Filter To &cFilter
	Endif

	SE5->(RestArea(aAreaSE5))
//SE5->(DbSetOrder(1))


//SE5->(DbCloseArea())

Return( aBaixa )


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³Sel450baix³ Autor ³ Adrianne Furtado      ³ Data ³ 06/07/10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Traz lista de Baixas para serem canceladas                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³Sel450Baixa()                                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³FINA450	                                                  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CalcVlPg(nValPgto,lTela)
	Local nVl10925
	Local nPCCRet := 0
	Local nAbat := SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_MOEDA,"S",dDataBase,SE2->E2_LOJA)

	Sel450Baixa("VL /BA /CP /",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA, @nPCCRet)

	If  nValPgto == SE2->E2_SALDO - nAbat + SE2->E2_SDACRES - SE2->E2_SDDECRE + FaJuros(SE2->E2_VALOR,SE2->E2_SALDO,SE2->E2_VENCTO,SE2->E2_VALJUR,SE2->E2_PORCJUR,SE2->E2_MOEDA,SE2->E2_EMISSAO,,,,SE2->E2_VENCREA) + nPCCRet
		nVl10925 := nValPgto - nPCCRet
	Else
		nVl10925 := nValPgto
	EndIf

Return nVl10925

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³ VrPdComp ³ Autor ³ Adrianne Furtado      ³ Data ³ 06/07/10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Verifica se o título só tem saldo de impostos e nesse caso ³±±
	±±³          ³ verifica se o valor a compensar é superior ao saldo a pagar³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ VrPdComp()                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³FINA450	                                                  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VrPdComp(nSelecP, nSelecR,nTamChavE2)
	Local lRet := .T.
	Local aAreaSE2
	Local nVlSldImp := 0
	Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"
	Local lPccCC	:= SuperGetMV( "MV_CC10925" , , 1) == 2 .and. lPCCBaixa // Gera PCC na compensação entre carteiras quando PCC na baixa

	If lPccCC
		If nSelecP > nSelecR
			aAreaSE2 := SE2->(GetArea())
			SE2->(dbSetOrder(1))
			dbSelectArea("TRB")
			dbGotop( )

			While ! Eof()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Registro do Contas a Pagar 	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If TRB->MARCA == cMarca .and. !Empty(TRB->PAGAR)
					SE2->(dbSeek(Substr(TRB->CHAVE,1,nTamChavE2)))
					//no IF abaixo, o saldo do título é o valor exato dos impostos. Exemplo: Tem um título de 10.000, mas informou 9535 no momento da baixa
					If SE2->E2_SALDO == SE2->(E2_PIS-E2_VRETPIS)+SE2->(E2_COFINS-E2_VRETCOF)+SE2->(E2_CSLL-E2_VRETCSL)
						nVlSldImp += SE2->(E2_PIS+E2_COFINS+E2_CSLL)
						// para essa situação o valor a ser compensado precisa ser maior ou igual ao saldo do título
					EndIf

				EndIf
				DbSkip()
			EndDo
			If nSelecR < nVlSldImp
				Aviso(STR0083,STR0095 ,{STR0094}) //"atenção" "Quando o saldo do título é referente aos impostos e MV_CC10925 = 2, a compensação precisa ser de valor igual ou maior que esse saldo."//"ok"
				lRet := .F.
			EndIf
			RestArea(aAreaSE2)
		EndIf
	EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F450VD ºAutor  ³Renan G. Alexandre º Data ³  02/25/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Posiciona o titulo na tabela SE2 para validacao dos         º±±
±±ºDesc.     ³documentos obrigatorios                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F450VD(cTitulo,lTodos,lArea,lEmail,lPrimeiro)

	Local aArea			:= {}
	Local aAreaSE2		:= {}
	Local cSE2Filtro	:= SE2->(dbFilter())
	Local lRet			:= .T.
	Local lFinVDoc		:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios

	Default lTodos 		:= .F.
	Default lArea		:= .F.
	Default lEmail		:= .F.
	Default lPrimeiro		:=.F.

	If lFinVDoc

		aArea := GetArea()
		If Select("SE2") > 0
			aAreaSE2 := SE2->(GetArea())
		EndIf

		If lArea
			If !Empty(cSE2Filtro)
				SE2->(dbClearFilter())
			EndIf
		EndIf

		dbSelectArea("SE2")
		dbSetOrder(1)		//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		dbGoTop()

		If dbSeek(cTitulo)
			If lEmail
				CN062ValDocs("07",.F.,.T.)
			Else
				If !CN062ValDocs("07",.F.,.F.,lTodos,@lPrimeiro)
					lRet := .F.
				EndIf
			EndIf
		EndIf

		If lArea
			If !Empty(cSE2Filtro)
				SE2->(dbSetfilter({||&cSE2Filtro},cSE2Filtro))
			EndIf
		EndIf

		RestArea(aAreaSE2)
		RestArea(aArea)

	EndIf

Return(lRet)


Static Function AtualTab()

	Local cSql := ""


	cSql := "UPDATE "+RetSqlName("SE2")+"  "
	cSql += "SET E2_IDENTEE = E5_IDENTEE  "
	cSql += "FROM "+RetSqlName("SE2")+" SE2 JOIN "+RetSqlName("SE5")+" SE5 "
	cSql += "ON SE5.E5_PREFIXO = SE2.E2_PREFIXO  "
	cSql += "AND SE2.E2_FILIAL = SE5.E5_FILIAL  "
	cSql += "AND SE5.E5_NUMERO = SE2.E2_NUM AND SE5.E5_CLIFOR = SE2.E2_FORNECE "
	cSql += "AND SE2.E2_LOJA = SE5.E5_LOJA AND SE5.E5_PARCELA = SE2.E2_PARCELA  "
	cSql += "AND SE5.E5_TIPO = SE2.E2_TIPO AND SE5.E5_IDENTEE <> ' ' AND SE5.D_E_L_E_T_ =' ' "
	cSql += "WHERE SE2.D_E_L_E_T_ =' ' AND SE2.E2_IDENTEE = ' ' "
	TcSqlExec(cSql)


	cSql := "UPDATE "+RetSqlName("SE1")+"  "
	cSql += "SET E1_IDENTEE = E5_IDENTEE  "
	cSql += "FROM "+RetSqlName("SE1")+" SE1 JOIN "+RetSqlName("SE5")+" SE5 "
	cSql += "ON SE5.E5_PREFIXO = SE1.E1_PREFIXO  "
	cSql += "AND SE1.E1_FILIAL = SE5.E5_FILIAL  "
	cSql += "AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_CLIFOR = SE1.E1_CLIENTE "
	cSql += "AND SE1.E1_LOJA = SE5.E5_LOJA AND SE5.E5_PARCELA = SE1.E1_PARCELA  "
	cSql += "AND SE5.E5_TIPO = SE1.E1_TIPO AND SE5.E5_IDENTEE <> ' ' AND SE5.D_E_L_E_T_ =' ' "
	cSql += "WHERE SE1.D_E_L_E_T_ =' ' AND SE1.E1_IDENTEE = ' ' "
	TcSqlExec(cSql)


Return Nil
