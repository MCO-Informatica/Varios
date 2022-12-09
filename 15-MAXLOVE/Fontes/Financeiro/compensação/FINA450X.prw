#include "FINA450.ch"
#include "PROTHEUS.CH"
#include "FILEIO.CH"
#include "FWMVCDEF.CH"
#INCLUDE "FWLIBVERSION.CH"

Static __oFINA4501  := NIL
STATIC lExistVa		:= ExistFunc("FValAcess")
STATIC lExistFKD	:= ExistFunc("FAtuFKDBx")
STATIC __lImpCC		:= NIL
STATIC __lPccCC		:= NIL
STATIC __VlMinIr	:= 0
STATIC __VlMinPC	:= 0
STATIC __lVLDCRP	:= ExistBlock("F450VLDCRP")
Static __lMetric	:= .F.
Static __lEstorna   := .F.


/*/{Protheus.doc} FINA450X
@description compensa��o entre carteiras rotina Padr�o custumizada para a MAXLOVE
@type function
@version  1.0
@author fabio.favaretto
@since 8/2/2022
@see 
/*/
User Function FINA450X(nPosArotina,aAutoCab,nOpcAuto)

	Local nRegSE2	:= SE2->(Recno())
	Local lRotAuto	:= (aAutoCab <> NIL)
	Local lPccBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"

	Private aRotina := MenuDef()
	//-----------------------------------
	// Verifica o n�mero do Lote
	//-----------------------------------
	Private cLote
	Private cMarca 		:= GetMark()
	Private lInverte
	Private cTipos 		:= ""
	Private cCadastro 	:= STR0004  //"Comp Pagar / Receber"
	Private cModSpb		:= "1"
	Private nDebCred	:=	1
	If Type("lMSErroAuto") <> "L"
		Private lMSErroAuto := .F.
		Private lMSHelpAuto := .F. // para mostrar os erros na tela
	Endif
	Default nPosArotina	:= 0

	Fa450MotBx("CEC","COMP CARTE","ANSN")

	VALOR 		:= 0
	VALOR2		:= 0
	VALOR3		:= 0
	VALOR4		:= 0
	VALOR5		:= 0
	VLRINSTR    := 0

	__lMetric	:= FwLibVersion() >= "20210517"

	//Verifica se abate impostos na CEC para titulos a Pagar
	If __lImpCC == NIL
		__lImpCC	:= SuperGetMV("MV_CC10925",.T.,1 ) == 2  // Gera PCC/IRF na compensa��o entre carteiras quando PCC/IRF na baixa
		__lPccCC	:= __lImpCC .and. lPccBaixa
		__VlMinIr	:= SuperGetMv("MV_VLRETIR", .T., 10 )
		__VlMinPC	:= SuperGetMv("MV_VL13137", .T., 10 )
	Endif

	SetKey(VK_F12,{|a,b| AcessaPerg("AFI450",.T.)})

	pergunte("AFI450",.F.)

	If nPosArotina > 0
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
			mBrowse(6,1,22,75,"SE2",,,,,,Fa450Leg())
		Endif
	Endif

	dbSelectArea("SE5")
	dbSetOrder(1)

Return

/*{Protheus.doc} FA450CMP
@description Realiza a compensacao de titulos a pagar com receber 
@author Fabio.Favaretto 
@since  02/08/2022
*/

User Function FA450CMP(cAlias,nReg,nOpcx, aCpos , aAutoCab )

	Local lPanelFin 	:= IsPanelFin()
	Local oDlg			:= Nil
	Local cMoeda450		:= ""
	Local aMoedas		:= {}
	Local oDlg1			:= Nil
	Local oTotalP		:= Nil
	Local oTotalR		:= Nil
	Local oSelecP		:= Nil
	Local oSelecR		:= Nil
	Local oMark			:= Nil
	Local nTamFil		:= TamSx3("E2_FILIAL")[1]
	Local nTamPref		:= TamSx3("E2_PREFIXO")[1]
	Local nTamNum		:= TamSx3("E2_NUM")[1]
	Local nTamParc		:= TamSx3("E2_PARCELA")[1]
	Local nTamTipo		:= TamSx3("E2_TIPO")[1]
	Local nTamForn		:= TamSx3("E2_FORNECE")[1]
	Local nTamLoja		:= TamSx3("E1_LOJA")[1]
	Local nTamTitulo	:= nTamPref + nTamNum + nTamParc + nTamTipo
	Local nTamChavE2	:= nTamFil + nTamForn + nTamLoja + nTamtitulo
	Local nTamChavE1	:= nTamtitulo + nTamFil
	Local nTamCod		:= nTamForn + nTamLoja + 1
	Local nRecAtu 		:= 0
	Local cChaveSE5		:= 0
	Local nOrdAtu		:= 0
	Local lFA450BU		:= Existblock("lFA450BU")
	Local cChaveTit		:= ""
	Local cChaveFK7		:= ""

	//----------------------
	// Tratamento ExecAuto
	//----------------------
	Local aChaveRec := {}
	Local aChavePag	:= {}

	Local aCampos	:= {{"P_R"      ,"C", 1,0},;
		{"TITULO"   ,"C",nTamTitulo+3,0},;
		{"PAGAR"    ,"N",15,2},;
		{"RECEBER"  ,"N",15,2},;
		{"EMISSAO"  ,"D", 8,0},;
		{"VENCTO"   ,"D", 8,0},;
		{"TIPO"     ,"C", 3,0},;
		{"MARCA"    ,"C", 2,0},;
		{"CHAVE"    ,"C",nTamChavE2,0},;
		{"PRINCIP"	,"N",15,2},;
		{"ABATIM"   ,"N",15,2},;
		{"JUROS"    ,"N",15,2},;
		{"MULTA"    ,"N",15,2},;
		{"VALACES"  ,"N",15,2},;
		{"DESCONT"	,"N",15,2},;
		{"ACRESC"   ,"N",15,2},;
		{"DECRESC"  ,"N",15,2},;
		{"PCC"  	,"N",15,2},;
		{"IRRF"  	,"N",15,2},;	//Irrf Retido
	{"CLIFOR"	,"C",nTamCod,0},;
		{"NOME"     ,"C",20,0},;
		{"CHAVEORI" ,"C",nTamChavE2,0},;
		{"PIS"  	,"N",15,2},;	//Pis Retido
	{"COF"  	,"N",15,2},;	//Cofins Retido
	{"CSL"  	,"N",15,2},;	//Csll Retido
	{"PISC"  	,"N",15,2},;	//Pis Calculado
	{"COFC"  	,"N",15,2},;	//Cofins Calculado
	{"CSLC"  	,"N",15,2},;	//Csll Calculado
	{"IRRFC"  	,"N",15,2},;	//Irrf Calculado
	{"PISBC"  	,"N",15,2},;	//Base Pis Calculado
	{"COFBC"  	,"N",15,2},;	//Base Cofins Calculado
	{"CSLBC"  	,"N",15,2},;	//Base Csll Calculado
	{"IRRBC"  	,"N",15,2},;	//Base Irrf Calculado
	{"PISBR"  	,"N",15,2},;	//Base Pis Retido
	{"COFBR"  	,"N",15,2},;	//Base Cofins Retido
	{"CSLBR"  	,"N",15,2},;	//Base Csll Retido
	{"IRRBR"  	,"N",15,2},;	//Base Irrf Retido
	{"POSAR"  	,"N",10,0} }

	Local aCpoBro	:= {{"MARCA"	,, " ","  "},;
		{"P_R"		,, STR0005,"!"},;   //"Carteira"
	{"TITULO"	,, STR0006,"@X"},;  //"Numero T�tulo"
	{"PAGAR"	,, STR0007,"@E 9,999,999,999.99"},;  //"Valor Pagar"
	{"RECEBER"	,, STR0008,"@E 9,999,999,999.99"},;  //"Valor Receber"
	{"EMISSAO"	,, STR0009,"@X"},;  //"Data Emissao"
	{"VENCTO"	,, STR0010,"@X"},;  //"Data Vencimento"
	{"TIPO"		,, STR0075,"@X"},;  //"Tipo"
	{"PRINCIP"	,, STR0069,"@E 9,999,999,999.99"},; //"Saldo Titulo"
	{"JUROS"	,, STR0070,"@E 9,999,999,999.99"},; //"Juros"
	{"MULTA"	,, STR0071,"@E 9,999,999,999.99"},; //"Multa"
	{"VALACES"	,, STR0101,"@E 9,999,999,999.99"},; //"Valores Acess�rios"
	{"DESCONT"	,, STR0072,"@E 9,999,999,999.99"},; //"Descontos"
	{"ACRESC"	,, STR0073,"@E 9,999,999,999.99"},; //"Acrescimos"
	{"DECRESC"	,, STR0074,"@E 9,999,999,999.99"},; //"Decrescimos"
	{"CLIFOR"	,, STR0076,"@X"},; //"Cli/For"
	{"NOME"		,, STR0077,"@X"}}  //"Nome"

	Local aOfuscar	:= {.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,RetGlbLGPD("E1_NOMCLI")}
	Local cNumComp	:= ''
	Local lPadrao	:= .F.
	Local cPadrao	:= "594"
	Local lCabec	:= .F.
	Local lSai1		:= .F.
	Local lSai2		:= .F.
	Local nOpca		:= 0
	Local nValMax 	:= 0
	Local nValMaxR	:= 0
	Local nValMaxP	:= 0
	Local nRec		:= 0
	Local nRecTRB	:= 0
	Local lBaixou	:= .F.
	Local lDigita	:= .F.
	Local lAglut	:= .F.
	Local TRB		:= ""
	Local cLanca	:= ""
	Local nA		:= 0
	Local cMoedaTx	:= ""
	Local nDecse2   := TamSx3("E2_TXMOEDA")[2]
	Local nDecse1   := TamSx3("E1_TXMOEDA")[2]
	Local nValDia 	:= 0
	Local aSE5Recs	:= {}
	Local oFnt      := NIL
	Local aBut450	:= {}
	Local bSet16 	:= SetKey(16,{||Fa450Pesq(oMark)})
	Local bSet5 	:= SetKey(5,{||Fa450Edit(oSelecP,oSelecR,nTamChavE1,nTamChavE2)})
	Local aChaveLbn := {}
	Local aRet 		:= {}
	Local aSize 	:= {}
	Local aButtonTxt:= {}
	Local aFlagCTB	:= {}
	Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	Local lProcessou := .T.
	Local lFinVDoc	:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)//Controle de validacao de documentos obrigatorios
	Local lF450ValCon := ExistBlock( "F450ValCon")
	Local nRegSE1 	:= 0
	Local nRegSE2  	:= 0
	Local lPrimeiro	:= .T. //valida��o do help de controle de docuemntos
	Local aAlt   	:= {}
	Local nTxMoeda  := 0
	Local oCli450	:= NIL
	Local oLjCli    := NIL
	Local oFor450   := NIL
	Local oLjFor	:= NIL

	//Gest�o.
	Local cLayout   := FWSM0Layout()
	Local lGestao	:= "E" $ cLayout .Or. "U" $ cLayout
	Local lSE1Excl	:= Iif( lGestao, FWModeAccess("SE1",1) == "E", FWModeAccess("SE1",3) == "E")
	Local lSE2Excl	:= Iif( lGestao, FWModeAccess("SE2",1) == "E", FWModeAccess("SE2",3) == "E")
	Local aSelFil	:= {}
	Local cAliasSE1	:= ""
	Local cAliasSE2	:= ""
	Local aTmpFil	:= {}

	Local nLinIni	:= 0
	Local nColIni	:= 0
	Local nLinFin	:= 0
	Local nColFin	:= 0
	Local cCliCont	:= ''
	Local cLjCont	:= ''
	Local aValidGet	:= {}
	Local lBxDtFin 	:= SuperGetMv("MV_BXDTFIN",,"1") == "2"
	Local aImpos	:= {}
	Local aTitCalc	:= {}
	Local nPos		:= 0
	Local nInicio	:= 0
	Local nFim		:= 0
	Local nCountReg	:= 0
	Local lAltValPg := .F.

	Local aOrdem :={}
	Local oOrdem

	LoteCont( "FIN" )

	Private nLim450		:= 0
	Private lF450Auto	:=(aAutoCab <> NIL)
	Private nMoeda		:= 0
	Private nProRata	:= 0
	Private nCM1		:= 0
	Private dVenIni450	:= CTOD("//")
	Private dVenFim450	:= CTOD("//")
	Private cCli450		:= ""
	Private cLjCli		:= ""
	Private cFor450 	:= ""
	Private cLjFor		:= ""
	Private nSelecP 	:= 0
	Private nSelecR 	:= 0
	Private nTotalP 	:= 0
	Private nTotPCC 	:= 0
	Private nTotIrf 	:= 0
	Private nTotalR 	:= 0
	Private nTotal		:= 0
	Private dBaixa		:= CTOD("//")
	Private dDebito		:= CTOD("//")
	Private cBanco		:= ""
	Private cAgencia	:= ""
	Private cConta		:= ""
	Private cCheque		:= ""
	Private cPortado	:= ""
	Private cNumBor		:= ""
	Private cLoteFin	:= ""
	Private cArquivo	:= ""
	Private nDescont	:= 0
	Private nAbatim		:= 0
	Private nJuros		:= 0
	Private nMulta		:= 0
	Private nVa 		:= 0
	Private cMotBX		:= ""
	Private lDesconto	:= .F.
	Private cHist070	:= ""
	Private nValRec		:= 0
	Private nTotAbat	:= 0
	Private nDespes		:= 0
	Private nValCC		:= 0
	Private nValPgto	:= 0
	Private aTxMoedas	:= {}
	Private nDifCambio  := 0
	Private nCM			:= 0
	Private nAcresc		:= 0
	Private nDecresc	:= 0
	Private lTitFuturo	:= .F.
	Private lIntegracao := IF(GetMV("MV_EASYFIN")=="S",.T.,.F.)		//uso pela FINA080
	Private nValTot     := 0										//uso pela FINA080

	//Reestruturacao SE5
	PRIVATE nDescCalc 	:= 0
	PRIVATE nJurosCalc 	:= 0
	PRIVATE nVACalc 	:= 0
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
	PRIVATE nPis		:= 0
	PRIVATE nCofins		:= 0
	PRIVATE nCsll		:= 0
	PRIVATE nIrrf		:= 0
	PRIVATE nBaseIrpf	:= 0

	If cPaisLoc == "MEX" .And. lF450Auto
		If Type("lMonedaC") == "U"
			Private lMonedaC := .F.
		EndIf
	Else
		Private lMonedaC := .F.
	EndIf

	// Zerar variaveis para contabilizar os impostos da lei 10925.
	VALOR5 := 0
	VALOR6 := 0
	VALOR7 := 0

	cCli450		:= CriaVar("E1_CLIENTE")
	cLjCli		:= CriaVar("E1_LOJA")
	//cFor450		:= CriaVar("E2_FORNECE")
	//cLjFor		:= CriaVar("E2_LOJA")
	//dVenIni450	:= Ctod("  /  /  ")
	//dVenFim450	:= Ctod("  /  /  ")

	cOrdem	    :=""
	cTpDoc		:= CriaVar("E2_TIPO")
	cFor450		:= CriaVar("E2_FORNECE")
	cLjFor		:= CriaVar("E2_LOJA")
	dVenIni450	:= Ctod("  /  /  ")
	dVenFim450	:= Ctod("  /  /  ")
	dEmiIni450	:= Ctod("  /  /  ")
	dEmiFim450	:= Ctod("  /  /  ")

//informa��es do cliente - 25/09/16
	dCliIniVen	:= Ctod("  /  /  ")
	dCliFimVen	:= Ctod("  /  /  ")
	dCliIniEmi	:= Ctod("  /  /  ")
	dCliFimEmi	:= Ctod("  /  /  ")
	cTpDocCli	:= CriaVar("E1_TIPO")
	cPrefixo	:= CriaVar("E1_PREFIXO")
	cPrefFor	:= CriaVar("E2_PREFIXO")

	AAdd( aOrdem, "Valor" )

	// Verifica se data do movimento� menor que data limite de movimentacao no financeiro
	If lBxDtFin .and. !DtMovFin(dDatabase,.T.,"3")
		Return
	Endif

	//Adiciono os campos de PCC e IRRF apenas na tela do Brasil
	If cPaisLoc == "BRA"
		aadd(aCpoBro,{"PCC"		,, "Pis Cofins Csll","@E 9,999,999,999.99"} )  //"Pis Cofins Csll"
		aadd(aCpoBro,{"IRRF"	,, "Irrf"           ,"@E 9,999,999,999.99"} )  //"Irrf"
		aadd(aOfuscar,.f.)
		aadd(aOfuscar,.f.)
	EndIF

	If ExistBlock("F450BROW")
		aRet    := ExecBlock("F450BROW",.F.,.F.,{aCampos,aCpoBro,aOfuscar})
		aCampos := aRet[1]
		aCpoBro := aRet[2]
		If Len(aRet) == 3
			aOfuscar := aRet[3]
		EndIf
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

	AADD(aBut450,{"PESQUISA",{||Fa450Pesq(oMark)}, STR0053,STR0001}) //"Pesquisar..(CTRL-P)"###"Pesquisar"
	AADD(aBut450,{"NOTE",{||Fa450Edit(oSelecP,oSelecR,nTamChavE1,nTamChavE2)}, STR0052,STR0081}) //"Edita Registro..(CTRL-E)"###"Editar"

	If  lFA450BU
		aBut450:=ExecBlock("lFA450BU",.F.,.F.,{aBut450})
	EndIf

	SetKey(VK_F12,{|a,b| AcessaPerg("AFI450",.T.)})
	pergunte("AFI450",.F.)

	lPadrao := VerPadrao(cPadrao)
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

		cNumComp	:= Soma1(GetMv("MV_NUMCOMP"),6)

		While !MayIUseCode("IDENTEE"+xFilial("SE1")+cNumComp)
			cNumComp := Soma1(cNumComp)
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

				//����������������������������������������������������������������Ŀ
				//� Observacao Importante quanto as coordenadas calculadas abaixo: �
				//� -------------------------------------------------------------- �
				//� a funcao DlgWidthPanel() retorna o dobro do valor da area do	 �
				//� painel, sendo assim este deve ser dividido por 2 antes da sub- �
				//� tracao e redivisao por 2 para a centralizacao. 					 �
				//������������������������������������������������������������������
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
			@ 06+nEspLin, 007+nEspLarg	SAY STR0018 SIZE 25, 7 OF oPanel PIXEL	//"N�mero"

			@ 20+nEspLin, 045+nEspLarg 	SAY "Vencimento Fornecedor" SIZE 60, 10 OF oPanel PIXEL
			@ 20+nEspLin, 150+nEspLarg	SAY "Prefixo"               SIZE 60, 10 OF oPanel PIXEL
			@ 20+nEspLin, 245+nEspLarg  SAY "Emissao Fornecedor"    SIZE 60, 10 OF oPanel PIXEL

			@ 28+nEspLin, 010+nEspLarg	SAY STR0021 SIZE 15, 10 OF oPanel PIXEL  //"De:"
			@ 28+nEspLin, 075+nEspLarg	SAY STR0022 SIZE 15, 10 OF oPanel PIXEL  //"At�:"
			@ 28+nEspLin, 160+nEspLarg	SAY STR0021 SIZE 15, 10 OF oPanel PIXEL  //"De:"
			@ 28+nEspLin, 225+nEspLarg	SAY STR0022 SIZE 15, 10 OF oPanel PIXEL  //"At�:"

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
				FA450DATA(dVenIni450,dVenFim450)),.T.);
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 27+nEspLin, 150+nEspLarg	MSGET cPrefFor	SIZE 30, 10 OF oPanel PIXEL


			@ 27+nEspLin, 215+nEspLarg	MSGET dEmiIni450	Valid If(nOpca<>0,!Empty(dEmiIni450),.T.) ;
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 27+nEspLin, 285+nEspLarg	MSGET dEmiFim450	Valid If(nOpca<>0,(!Empty(dEmiFim450) .And. ;
				F450DATAe(dEmiIni450,dEmiFim450)),.T.);
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
			@ 115+nEspLin, 075+nEspLarg	SAY STR0022 SIZE 15, 10 OF oPanel PIXEL  //"At�:"
			@ 115+nEspLin, 160+nEspLarg	SAY STR0021 SIZE 15, 10 OF oPanel PIXEL  //"De:"
			@ 115+nEspLin, 225+nEspLarg	SAY STR0022 SIZE 15, 10 OF oPanel PIXEL  //"At�:"


			@ 140+nEspLin, 010+nEspLarg	SAY "Tipo Doc Cli" SIZE 40, 7 OF oPanel PIXEL
			@ 140+nEspLin, 045+nEspLarg	SAY "Prefixo" SIZE 40, 7 OF oPanel PIXEL

			//GETS

			@ 115+nEspLin, 020+nEspLarg	MSGET dCliIniVen	Valid If(nOpca<>0,!Empty(dCliIniVen),.T.) ;
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 115+nEspLin, 090+nEspLarg	MSGET dCliFimVen	Valid If(nOpca<>0,(!Empty(dCliFimVen) .And. ;
				FA450DATA(dCliIniVen,dCliFimVen)),.T.);
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 115+nEspLin, 170+nEspLarg	MSGET dCliIniEmi	Valid If(nOpca<>0,!Empty(dCliIniEmi),.T.) ;
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 115+nEspLin, 240+nEspLarg	MSGET dCliFimEmi	Valid If(nOpca<>0,(!Empty(dCliFimEmi) .And. ;
				F450DATAe(dCliIniEmi,dCliFimEmi)),.T.);
				SIZE 50, 10 OF oPanel PIXEL Hasbutton
			@ 152+nEspLin, 010+nEspLarg	MSGET cTpDocCli		F3 "05";
				SIZE 30, 10 OF oPanel PIXEL Hasbutton
			@ 152+nEspLin, 045+nEspLarg	MSGET cPrefixo	SIZE 30, 10 OF oPanel PIXEL


			//outros
			@ 73+nEspLin, 106+nEspLarg RADIO oRadio VAR nDebCred ITEMS STR0067,STR0068  SIZE 80,10 OF oPanel PIXEL //'Compensar titulos de debito'#'Compensar titulos de credito'

			@ 74+nEspLin, 006+nEspLarg	MSCOMBOBOX oMoeda VAR cMoeda450 ITEMS aMoedas SIZE 80, 10 OF oPanel PIXEL

			@ 86+nEspLin,006+nEspLarg CHECKBOX oTitFuturo VAR lTitFuturo  PROMPT STR0088 FONT oDlg:oFont SIZE 89,11 OF oPanel PIXEL 	//"Titulos com Emiss�o Futura"



			If lPanelFin  //Chamado pelo Painel Financeiro
				If cPaisLoc <> "BRA"
					AADD(aButtonTxt,{STR0064,STR0064, {||Fa450SetMo()}})
				Endif

				ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
					{|| nOpca:=1,Iif(FA450OK(),oDlg:End(), nOpca := 0)},;
					{|| nOpca:=0,oDlg:End()},,aButtonTxt)

			Else
				If cPaisLoc <> "BRA"
					@ 47, 220 BUTTON STR0064 SIZE 32,18 ACTION (Fa450SetMo()) OF oPanel PIXEL //Taxas Moedas
				EndIf

				DEFINE SBUTTON FROM 09, 360 TYPE 1 ENABLE OF oPanel ACTION ( nOpca:=1,Iif(FA450OK(),oDlg:End(), nOpca := 0))
				DEFINE SBUTTON FROM 22, 360 TYPE 2 ENABLE OF oPanel ACTION ( nOpca:=0,oDlg:End())

				ACTIVATE MSDIALOG oDlg CENTERED
			Endif

		Else
			//------------------------------------
			// Tratamento para Rotina Automatica
			//------------------------------------
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTDVENINI450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="D"
				dVenIni450	:=	aAutoCab[nT,2]
				Aadd(aValidGet,{'dVenIni450' ,dVenIni450,'Dtos(dVenIni450) <> " " ',.T.})
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTDVENFIM450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="D"
				dVenFim450	:=	aAutoCab[nT,2]
				Aadd(aValidGet,{'dVenFim450' ,dVenFim450,'FA450Data(dVenIni450,dVenFim450,.T.)',.T.})
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTNLIM450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="N"
				nLim450	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTCCLI450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="C"
				cCli450	:=	Padr(aAutoCab[nT,2],TAMSX3("E1_CLIENTE")[1])
				Aadd(aValidGet,{'cCli450' ,cCli450,"FA450Cli(,.T.)",.T.})
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTCLJCLI'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="C"
				cLjCli	:=	Padr(aAutoCab[nT,2],TAMSX3("E1_LOJA")[1])
			Endif
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTCFOR450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="C"
				cFor450	:=	Padr(aAutoCab[nT,2],TAMSX3("E2_FORNECE")[1])
				Aadd(aValidGet,{'cFor450' ,cFor450,'FA450For(,.T.)',.T.})
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTCLJFOR'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="C"
				cLjFor	:=	Padr(aAutoCab[nT,2],TAMSX3("E2_LOJA")[1])
			Endif
			cMoeda450 := "01"
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTCMOEDA450'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="C"
				cMoeda450	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTNDEBCRED'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="N"
				nDebCred	:=	aAutoCab[nT,2]
			EndIf
			IF (nT := ascan(aAutoCab,{|x| x[1]='AUTLTITFUTURO'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="L"
				lTitFuturo	:=	aAutoCab[nT,2]
			EndIf
			If (nT := ascan(aAutoCab,{|x| x[1]='AUTARECCHAVE'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="A"
				aChaveRec	:=	aAutoCab[nT,2]
			EndIf
			If (nT := ascan(aAutoCab,{|x| x[1]='AUTAPAGCHAVE'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="A"
				aChavePag	:=	aAutoCab[nT,2]
			EndIf
			If (nT := ascan(aAutoCab,{|x| x[1]='AUTAFILCOMP'})) > 0 .and. VALTYPE(aAutoCab[nT,2])=="A"
				aSelFil	:=	aAutoCab[nT,2]
			EndIf

			If !MsVldGAuto(aValidGet)
				nOpca := 0
				lMsErroAuto := .T.
			Else
				nOpca := 1
			EndIf

		EndIf

		If nOpca == 0
			lProcessou := .F.
			Exit
		EndIF

		//Adiciona campos para M�xico, Peru y Colombia
		If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("fn450Cpo")
			fn450Cpo(@aCampos, @aCpoBro, @aOfuscar, cMoeda450)
		EndIF
		nMoeda := Val(Substr(cMoeda450,1,2))

		//Sele��o de filiais.
		If !lF450Auto
			If lSE1Excl .and. lSE2Excl .And. mv_par04 == 1
				aSelFil := AdmGetFil(.F.,.T.,"SE1")
				If Len(aSelFil) == 0
					lProcessou := .F.
					Exit
				EndIf
			Else
				aSelFil := {cFilAnt}
			EndIf
		Endif

		//-------------------------
		// Filtra o arquivo SE1
		//-------------------------
		nInicio := Seconds()

		cAliasSE1	:= "TRBSE1"
		cQuery 		:= FA450Chec1(lTitFuturo,aSelFil,aTmpFil)
		cQuery 		:= ChangeQuery(cQuery)

		If Select("TRBSE1") > 0
			TRBSE1->(DbCloseArea())
		EndIf

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSE1, .F., .T.)

		lSai1 := .F.

		If (cAliasSE1)->( BOF() ) .and. (cAliasSE1)->( EOF() )
			lSai1 := .T.
			(cAliasSE1)->(DbCloseArea())
			dbSelectArea("SE1")
			RetIndex("SE1")
			Set Filter to
			dbSetOrder(1)
			dbGoTop()
			dbSelectArea("SE1")
			lProcessou := .F.
			Exit
		EndIf

		//-------------------------
		// Filtra o arquivo SE2
		//-------------------------
		cAliasSE2	:= "TRBSE2"
		cQuery 		:= FA450Chec2(lTitFuturo,aSelFil,aTmpFil)
		cQuery 		:= ChangeQuery(cQuery)

		If Select("TRBSE2") > 0
			TRBSE2->(DbCloseArea())
		EndIf

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSE2, .F., .T.)

		lSai2 := .F.

		If (cAliasSE2)->( BOF() ) .and. (cAliasSE2)->( EOF() )
			lSai2 := .T.
			(cAliasSE2)->(DbCloseArea())
			dbSelectArea("SE2")
			RetIndex("SE2")
			Set Filter to
			dbSetOrder(1)
			dbGoTop()
			dbSelectArea("SE2")
			lProcessou := .F.
			Exit
		EndIf

		If (lSai1 .Or. lSai2) .AND. !lF450Auto
			Help(" ",1,"RECNO")
			Loop
		EndIF

		//-------------------------
		// Cria Arquivo Temporario
		//-------------------------
		TRB := U_Fa450Gerarq(aCampos)

		//------------------------------------------
		// Carrega Registros do Arquivo Temporario
		//------------------------------------------
		Fa450Repl(TRB, cAliasSE1, cAliasSE2, aAutoCab, aImpos)

		nOpca   := 0
		dbSelectArea("TRB")
		If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("fn450DbEvx")
			DBEVAL({ |a| fn450DbEvx(nLim450,,aChaveLbn, aChavePag , aChaveRec,@lPrimeiro )})
		Else
			DBEVAL({ |a| FA450DBEVA(nLim450,,aChaveLbn, aChavePag , aChaveRec,@lPrimeiro )})
		EndIf
		dbGotop()
		nFim := Seconds() - nInicio
		nFim := nFim/TRB->(RECCOUNT())
		If __lMetric
			// Metrica do tempo para exibir a tela de titulos para marca��o
			FwCustomMetrics():setAverageMetric("TempoEntrada", "financeiro-protheus_tempo-conclusao-processo_seconds", nFim)
		Endif

		If !lF450Auto
			aSize := MSADVSIZE()

			oSize := FWDefSize():New(.T.)

			oSize:AddObject("MASTER",100,100,.T.,.T.)
			oSize:lLateral := .F.
			oSize:lProp := .T.

			oSize:Process()

			DEFINE MSDIALOG oDlg1 TITLE STR0027 PIXEL FROM oSize:aWindSize[1],oSize:aWindSize[2] To oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd //"Compensa��o Entre Carteiras"
			oDlg1:lMaximized := .T.

			nLinIni := oSize:GetDimension("MASTER","LININI")
			nColIni := oSize:GetDimension("MASTER","COLINI")
			nLinFin := oSize:GetDimension("MASTER","LINEND")
			nColFin := oSize:GetDimension("MASTER","COLEND")

			@ nLinIni + 003, 005 Say STR0066 	FONT oDlg1:oFont PIXEL OF oDlg1  //"Compensacao Nr. "
			@ nLinIni + 003, 060 Say cNumComp Picture "@!"	FONT oFnt COLOR CLR_HBLUE PIXEL OF oDlg1
			If cPaisLoc == "MEX" .and. lMonedaC
				@ nLinIni + 003, 115 Say "Moneda Seleccionada: " 	FONT oDlg1:oFont PIXEL OF oDlg1  //"Moneda Seleccionada: "
				@ nLinIni + 003, 180 Say cMoeda450 Picture "@!"	FONT oFnt COLOR CLR_HBLUE PIXEL OF oDlg1
				@ nLinIni + 003, 245 Say "Tasa: "	FONT oDlg1:oFont PIXEL OF oDlg1  //"Tasa: "
				@ nLinIni + 003, 265 Say aTxMoedas[nMoeda][2] FONT oFnt COLOR CLR_HBLUE PIXEL OF oDlg1
			EndIf
			// Panel
			////////

			/////////////
			// MarkBrowse
			oMark := MsSelect():New("TRB","MARCA","",aCpoBro,@lInverte,@cMarca,{nLinIni + 20, nColIni, nLinFin-40, nColFin})
			oMark:bMark := {| | Fa450Disp(cMarca,lInverte,oTotalP,oTotalR,oSelecP,oSelecR)}
			oMark:oBrowse:lhasMark = .t.
			oMark:oBrowse:lCanAllmark := .t.
			If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("fn450Invet")
				oMark:bAval	:= {||	fn450Invet(cMarca,oTotalP,oTotalR,oSelecP,oSelecR, .F., aChaveLbn), oMark:oBrowse:Refresh(.t.)}
				oMark:oBrowse:bAllMark := { || fn450Invet(cMarca,oTotalP,oTotalR, oSelecP,oSelecR, .T., aChaveLbn)}
			Else
				oMark:bAval	:= {||	FA450Inverte(cMarca,oTotalP,oTotalR,oSelecP,oSelecR, .F., aChaveLbn), oMark:oBrowse:Refresh(.t.)}
			EndIf

			If GetFinLGPD()
				oMark:oBrowse:aObfuscatedCols := aOfuscar
			Endif
			If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("fn450Invet")
				oMark:oBrowse:bAllMark := { || fn450Invet(cMarca,oTotalP,oTotalR, oSelecP,oSelecR, .T., aChaveLbn)}
			Else
				oMark:oBrowse:bAllMark := { || FA450Inverte(cMarca,oTotalP,oTotalR, oSelecP,oSelecR, .T., aChaveLbn)}
			Endif
			// MarkBrowse
			/////////////

			////////
			// Panel 2
			oPanel2 := TPanel():New(0,0,'',oDlg1,, .T., .T.,, ,40,40,.T.,.T. )

			If ! lPanelFin
				oPanel2:Align := CONTROL_ALIGN_BOTTOM
			Endif

			@003,060 Say STR0028 FONT oDlg1:oFont PIXEL OF oPanel2 //"Pagar"
			@003,200 Say STR0029 FONT oDlg1:oFont PIXEL OF oPanel2 //"Receber"

			@012,005 Say STR0030 FONT oDlg1:oFont PIXEL OF oPanel2 //"Total Exibido :"
			@012,060 Say oTotalP VAR nTotalP 	Picture "@E 999,999,999,999,999.99" FONT oDlg1:oFont PIXEL OF oPanel2
			@012,200 Say oTotalR VAR nTotalR 	Picture "@E 999,999,999,999,999.99" FONT oDlg1:oFont PIXEL OF oPanel2

			@021,005 Say STR0031 FONT oDlg1:oFont PIXEL OF oPanel2 //"Total Selecionado :"
			@021,060 Say oSelecP VAR nSelecP 	Picture "@E 999,999,999,999,999.99" FONT oDlg1:oFont PIXEL OF oPanel2
			@021,200 Say oSelecR VAR nSelecR 	Picture "@E 999,999,999,999,999.99" FONT oDlg1:oFont PIXEL OF oPanel2
			If cPaisLoc == "MEX" .and. lMonedaC
				@032,005 Say "Totales mostrados en :" + cMoeda450  FONT oDlg1:oFont PIXEL OF oPanel2 //"Totales mostrados en :"
			EndIf
			// Panel
			////////

			If lPanelFin  //Chamado pelo Painel Financeiro
				ACTIVATE MSDIALOG oDlg1 ON INIT ( FaMyBar(oDlg1, {|| nOpca := 1,oDlg1:End()},;
					{|| nOpca := 2,oDlg1:End()},aBut450),oPanel2:Align := CONTROL_ALIGN_BOTTOM) CENTERED
			Else
				ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,	{|| Iif( F450VldCar(), (nOpca := 1,oDlg1:End()), nOpca := 0) },;
					{|| nOpca := 2,oDlg1:End()},,aBut450)
			Endif
		Else
			Fa450Marca() //Trata o dbeval para marcar e totalizar itens
			If F450VldCar()
				nOpca   := 1
			EndIf
		EndIf

		If lF450ValCon .And. nOpca == 1
			nOldOpca := nOpca
			nOpca  	:= ExecBlock( "F450ValCon", .F., .F. )
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

		//------------------------------------------------------
		//�Integracao com o SIGAPCO para lancamento via processo
		//------------------------------------------------------
		PcoIniLan("000018")

		If nOpcA == 1 .and. VrPdComp(nSelecP, nSelecR, nTamChavE2)

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
					nInicio := Iif(Empty(nInicio),Seconds(),nInicio)
					//-------------------------------------
					// Registro do Contas a Receber
					//-------------------------------------
					If TRB->MARCA == cMarca
						nValRec	:= 0
						nValPgto := 0

						//Salvo o c�digo do cliente e a loja para posicionar antes da contabiliza��o
						cCliCont := IIf( !Empty( SE1->E1_CLIENTE ), SE1->E1_CLIENTE, cCliCont )
						cLjCont  := IIf( !Empty( SE1->E1_LOJA ), SE1->E1_LOJA, cLjCont )

						If !Empty(TRB->RECEBER)
							//-------------------------------------
							// Procura registro no SE1
							//-------------------------------------
							dbSelectArea("SE1")
							dbSetOrder(1)
							dbSeek(Substr(TRB->CHAVE,1,nTamChavE1))
							dbSelectArea("TRB")
							//-------------------------------------
							// Inicializa variaveis para baixa
							//-------------------------------------
							dBaixa		:= dDataBase
							cBanco		:= cAgencia := cConta := cBenef :=	cCheque	:= " "
							cPortado 	:= cNumBor		:= " "
							cLoteFin 	:= " "
							nDescont	:= nAbatim := nJuros := nMulta := nCm := nVa := 0
							cMotBX		:= "CEC"             // Compensacao Entre Carteiras
							lDesconto	:= .F.
							StrLctPad   := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
							nRec		:= SE1->(Recno())
							nRecTRB		:= TRB->(Recno())
							dbSelectArea("SE1")

							SE1->(dbGoto(nRec))
							dbSelectArea("TRB")
							TRB->(dbGoto(nRecTRB))
							nValRec		:= RECEBER
							nTotAbat	:= ABATIM
							//--------------------------------------------------------------------------
							// Se nao for baixar total o titulo, desconsidera abatimento
							// no calculo do valor recebido.  Zera-se nTotAbat pois ele
							// ja esta� somado no nValRec e seria somado novamente na
							// gravacao da baixa (FA070GRV()).
							//--------------------------------------------------------------------------
							If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("Fn450VlMnd")
								nValRec := Fn450VlMnd(RECEBER,SE1->E1_MOEDA,nDecse1 )
							EndIf
							If nValRec > nValMaxR
								nValRec  := nValMaxR
								nTotAbat := 0
							EndIf
							nValMaxR 		-= nValRec
							nValEstrang		:= nValRec
							nEstOriginal	:= nValRec - JUROS- VALACES - MULTA - SE1->E1_SDACRES + DESCONT + SE1->E1_SDDECRE + ABATIM

							nAcresc := 0
							nDecresc := 0
							nDescont := 0
							nJuros := 0
							nMulta := 0
							nVA := 0
							nPis := 0
							nCofins := 0
							nCsll := 0
							nIrrf := 0
							nPisCalc := 0
							nCslCalc := 0
							nCofCalc := 0

							nJurosCalc	:= 0
							nDescCalc 	:= 0
							nMultaCalc 	:= 0
							If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("fn450OtrVl")
								fn450OtrVl("SE1",nDecse1 )
							Else

								If (SE1->E1_SDACRES + SE1->E1_SDDECRE + DESCONT + JUROS + MULTA + VALACES) != 0

									If SE1->E1_SDACRES != 0
										nAcresc	:= Round(xMoeda(SE1->E1_SDACRES,nMoeda,1,dDataBase,nDecse1,SE1->E1_TXMOEDA),2)
									Endif

									If SE1->E1_SDDECRE != 0
										nDecresc := Round(xMoeda(SE1->E1_SDDECRE,nMoeda,1,dDataBase,nDecse1,SE1->E1_TXMOEDA),2)
									Endif

									If DESCONT != 0
										nDescont := Round(xMoeda(DESCONT,nMoeda,1,dDataBase,nDecse1,SE1->E1_TXMOEDA),2)
									Endif

									If JUROS != 0
										nJuros := Round(xMoeda(JUROS,nMoeda,1,dDataBase,nDecse1,SE1->E1_TXMOEDA),2)
									Endif

									If MULTA != 0
										nMulta := Round(xMoeda(MULTA,nMoeda,1,dDataBase,nDecse1,SE1->E1_TXMOEDA),2)
									Endif

									If VALACES != 0
										nVA	:= Round(xMoeda(VALACES,nMoeda,1,dDataBase,nDecse1,SE1->E1_TXMOEDA),2)
									Endif
								Endif

							Endif
							nJurosCalc	:= nJuros
							nDescCalc 	:= nDescont
							nMultaCalc 	:= nMulta
							// Converte para poder baixar
							If cPaisLoc == "BRA"
								nValRec	:= Round(xMoeda(nValRec,nMoeda,1,dDataBase,nDecse1,SE1->E1_TXMOEDA),2)
								//Se existir taxa contratada n�o deve calcular a corre��o monetaria, pois no
								//momento da compensa��o n�o � possivel manipular a taxa da moeda.
								If SE1->E1_TXMOEDA == 0
									FA070CORR(nEstOriginal,0)
								Endif
							Else
								If cPaisLoc == "MEX"  .and. lMonedaC .and. FindFunction("fn450AsgVl")
									fn450AsgVl('SE1', @nValDia,@nDifCambio,@nCM,nValRec ,SE1->E1_MOEDA,SE1->E1_TXMOEDA ,nDecse1)
								Else
									nValDia		:= Round(xMoeda(nValRec,nMoeda,1,dDataBase,nDecse1,SE1->E1_TXMOEDA),2)
									nValRec		:= Round(xMoeda(nValRec,nMoeda,1,dDataBase,nDecse1,aTxMoedas[nMoeda][2]),2)
									nDifCambio	:= nValRec - nValDia
									nCM			:= nDifCambio
								EndIf
							EndIf

							SE1->(dbGoto(nRec))
							cHist070 	:= STR0034  //"Valor recebido por compensacao"
							//-----------------------------------------------------------
							// Efetua a baixa
							//-----------------------------------------------------------
							If nValRec > 0

								If Empty(SE1->E1_NUM)
									dbSelectArea("SE1")
									SE1->(dbSetOrder(1))
									If !SE1->(Dbseek(xFilial("SE1")+(StrTran(Strtran(TRB->TITULO,"|",""),"*","")))) //!SE1->(Dbseek(xFilial("SE1")+(StrTran(Strtran(TRB->TITULO,"/",""),"*",""))))
										//If !SE1->(Dbseek(xFilial("SE1")+(StrTran(Strtran(TRB->CHAVE,"/",""),"*",""))))
											ConOut("Titulo n�o encontrado:" + TRB->TITULO)
										//EndIf
									EndIf
								EndIf

								RecLock("SE1")
								Replace E1_IDENTEE		With cNumComp
								MsUnLock()

								//-----------------------------------------------------------
								//Valores Acessorios.
								//-----------------------------------------------------------
								If lExistFKD
									FAtuFKDBx(.F.,"R")
								EndIf

								If SE1->E1_TXMOEDA > 0
									nTxMoeda := SE1->E1_TXMOEDA
								Else
									nTxMoeda := RecMoeda(dBaixa,nMoeda)
								Endif

								lBaixou	 := FA070Grv(lPadrao,lDesconto,.F.,Nil,.F.,dDataBase,.F.,Nil,,IIf(cPaisLoc=="BRA",nTxMoeda,aTxMoedas[nMoeda][2]))		//Nil=Arquivo Cnab

								// Atualiza o status do titulo no SERASA
								If lBaixou
									SE5->(DbSetOrder(21))			//E5_FILIAL+E5_IDORIG+E5_TIPODOC
									If SE5->(MsSeek(xFilial("SE5") + SE5->E5_IDORIG + "BA"))  // Gravar o E5_IDENTEE para todos os registros, para n�o afetar o estorno.

										nRecSE5 := SE5->(Recno())

										If cPaisLoc == "BRA"
											If lBaixou
												If SE1->E1_SALDO <= 0
													cChaveTit := xFilial("SE1",SE1->E1_FILORIG)	+ "|" +;
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

										// nova vers�o para gravar SE5 e demais tabelas
										SE5->(dbGoTo(nRecSE5))
										If AllTrim( SE5->E5_TABORI ) == "FK1"
											aAreaAnt := GetArea()
											RecLock("SE5")
											E5_IDENTEE := cNumComp
											E5_XSLDSE1:=SE1->E1_SALDO
											If !lUsaFlag
												E5_LA := 'S'
											Else
												aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->(Recno() ), 0, 0, 0} )
											EndIf
											MsUnlock()

											FK1->(DbSetOrder(1))
											If FK1->(dbseek(SE5->E5_FILIAL+SE5->E5_IDORIG))
												Reclock("FK1", .F.)
												FK1_IDPROC := cNumComp
												If !lUsaFlag
													FK1_LA := 'S'
												Else
													aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->(Recno() ), 0, 0, 0} )
												EndIf
												MsUnlock()
											Endif
											RestArea(aAreaAnt)
										EndIf

										AAdd(aSE5Recs,{"R",SE5->(Recno())})

										//Atualizo o n�mero da compensa��o nos valores acessorios (DC|MT|JR|CM|VA)
										//Mantido na forma antiga pois essas informa��es n�o s�o repassadas para as FK6
										//Este trecho ser� retirado quando a SE5 n�o for mais gravada
										dbSelectArea("SE5")
										nRecAtu := SE5->(Recno())
										nOrdAtu := SE5->(IndexOrd())
										SE5->(dbSetOrder(7))	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
										cChaveSe5 := SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
										cTipodoc := "DC|MT|JR|CM|VA"
										If dbSeek(cChaveSE5)
											While !SE5->(EOF()) .AND. cChaveSe5 == SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
												//Atualizo o n�mero da compensa��o nos valores acessorios (DC|MT|JR|CM|VA)
												If SE5->E5_TIPODOC $ cTipodoc
													RecLock("SE5")
													Replace E5_IDENTEE With cNumComp

													If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
														aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
													Else
														Replace E5_LA With "S"
													EndIf
													MsUnLock()
												Endif

												SE5->(dbSkip())
											EndDo
										Endif

										SE5->(dbSetOrder(nOrdAtu))
										SE5->(dbGoto(nRecAtu))

										aadd( aAlt,{ STR0099,'','','',STR0100 +  Alltrim(cNumComp) })
										//chamada da Fun��o que cria o Hist�rico de Cobran�a
										FinaCONC(aAlt)

										SE5->(dbSetOrder(nOrdAtu))
										SE5->(dbGoto(nRecAtu))

										//--------------------------------------------
										// Inicializa variaveis para contabilizacao
										//--------------------------------------------
										VALOR := nValRec
										VLRINSTR := VALOR
										If nMoeda <= 5 .And. nMoeda > 1
											cVal := Str(nMoeda,1)
											VALOR&cVal := nValEstrang
										EndIf
									EndIf
								Endif
							EndIf
							//---------------------------
							//Registro do Contas a Pagar
							//---------------------------
						ElseIf !Empty(TRB->PAGAR)
							//-------------------------
							//Procura registro no SE2
							//-------------------------
							dbSelectArea("SE2")
							dbSetOrder(1)
							dbSeek(Substr(TRB->CHAVE,1,nTamChavE2))
							dbSelectArea("TRB")
							//-----------------------------------
							// Inicializa variaveis para baixa
							//-----------------------------------
							dBaixa		:= dDataBase
							dDebito		:= dBaixa
							cBanco		:= cAgencia := cConta := cBenef := cLoteFin := " "
							cCheque		:= cPortado := cNumBor := " "
							nDespes		:= nDescont := nAbatim := nJuros := nMulta := 0
							nValCc		:= nCm := 0
							nVA			:= 0
							lDesconto	:= .F.
							cMotBx		:= "CEC"
							StrLctPad   := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
							nRec		:= SE2->(Recno())
							nRecTRB		:= TRB->(Recno())
							aTitCalc	:= {}

							dbSelectArea("SE2")

							cHist070 	:= STR0080 //"Valor Pago por compensacao"
							SE2->(dbGoto(nRec))

							dbSelectArea("TRB")
							TRB->(dbGoto(nRecTRB))
							//------------------------------
							// Calcula valor a ser baixado
							//------------------------------
							nValPgto 	:= PAGAR
							nTotAbat	:= ABATIM

							//------------------------------------------------------
							// Se n�o for baixar total o titulo, desconsidera abat.
							// no calculo do valor recebido
							// Caso o valor do titulo seja maior que o restante a
							// compensar, baixa-se apenas a diferen�a.
							//-------------------------------------------------------
							If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("Fn450VlMnd")
								nValPgto := Fn450VlMnd(PAGAR,SE2->E2_MOEDA,nDecse2 )
							EndIf

							If nValPgto > nValMaxP
								nValPgto := nValMaxP
								lAltValPg := .T.
								nTotAbat := 0
							EndIf

							//Recomponho o valor do IRRF e PCC para que o valor pago v� corretamente para a baixa autom�tica do titulo.
							If __lImpCC

								If TRB->PCC != 0
									nPis 	:= TRB->PIS
									nCofins	:= TRB->COF
									nCsll 	:= TRB->CSL
								Endif

								If TRB->IRRF != 0
									nIrrf := TRB->IRRF
								Endif

								nPisCalc	:= TRB->PISC	//Pis Calculado
								nCofCalc	:= TRB->COFC	//Cofins Calculado
								nCslCalc	:= TRB->CSLC	//Csll Calculado
								nIrfCalc	:= TRB->IRRFC	//Irrf Calculado
								nPisBaseC	:= TRB->PISBC	//Base Pis Calculado
								nCofBaseC	:= TRB->COFBC	//Base Cofins Calculado
								nCslBaseC	:= TRB->CSLBC	//Base Csll Calculado
								nIrfBaseC	:= TRB->IRRBC	//Base Irrf Calculado
								nPisBaseR	:= TRB->PISBR	//Base Pis Retido
								nCofBaseR	:= TRB->COFBR	//Base Cofins Retido
								nCslBaseR	:= TRB->CSLBR	//Base Csll Retido
								nIrfBaseR	:= TRB->IRRBR	//Base Irrf Retido

								If !Empty(TRB->POSAR)
									nPos := TRB->POSAR
									If ValType(aImpos[nPos])=="A"
										aTitCalc := aImpos[nPos]
									EndIf
								Endif
							Endif

							nValMaxP 	-= nValPgto
							nValEstrang	:= nValPgto
							nEstOriginal := nValPgto - JUROS- VALACES - MULTA - SE2->E2_SDACRES  + DESCONT + SE2->E2_SDDECRE + nTotAbat

							nAcresc := 0
							nDecresc := 0
							nDescont := 0
							nJuros := 0
							nMulta := 0
							nVA := 0
							nJurosCalc	:= 0
							nDescCalc 	:= 0
							nMultaCalc 	:= 0
							If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("fn450OtrVl")
								fn450OtrVl("SE2",nDecse2 )
							Else

								If (SE2->E2_SDACRES+SE2->E2_SDDECRE+DESCONT+JUROS+MULTA+VALACES) != 0

									If SE2->E2_SDACRES != 0
										nAcresc		:= Round(xMoeda(SE2->E2_SDACRES,nMoeda,1,dDataBase,nDecse2,SE2->E2_TXMOEDA),2)
									Endif

									If SE2->E2_SDDECRE != 0
										nDecresc	:= Round(xMoeda(SE2->E2_SDDECRE,nMoeda,1,dDataBase,nDecse2,SE2->E2_TXMOEDA),2)
									Endif

									If DESCONT != 0
										nDescont	:= Round(xMoeda(DESCONT,nMoeda,1,dDataBase,nDecse2,SE2->E2_TXMOEDA),2)
									Endif

									If JUROS != 0
										nJuros		:= Round(xMoeda(JUROS,nMoeda,1,dDataBase,nDecse2,SE2->E2_TXMOEDA),2)
									Endif

									If MULTA != 0
										nMulta		:= Round(xMoeda(MULTA,nMoeda,1,dDataBase,nDecse2,SE2->E2_TXMOEDA),2)
									Endif

									If VALACES != 0
										nVA			:= Round(xMoeda(VALACES,nMoeda,1,dDataBase,nDecse2,SE2->E2_TXMOEDA),2)
									Endif

								Endif
							EndIf

							nJurosCalc	:= nJuros
							nDescCalc 	:= nDescont
							nMultaCalc 	:= nMulta

							// Converte para poder baixar
							If cPaisLoc == "BRA"
								nValPgto := Round(xMoeda(nValPgto,nMoeda,1,dDataBase,nDecse2,SE2->E2_TXMOEDA),2)
								//Se existir taxa contratada n�o deve calcular a corre��o monetaria, pois no
								//momento da compensa��o n�o � possivel manipular a taxa da moeda
								If SE2->E2_TXMOEDA == 0
									FA080CORR(nEstOriginal,0)
								Endif
							Else
								If cPaisLoc == "MEX"  .and. lMonedaC .and. FindFunction("fn450AsgVl")
									fn450AsgVl('SE2', @nValDia,@nDifCambio,@nCM,nValPgto ,SE2->E2_MOEDA,SE2->E2_TXMOEDA ,nDecse2)
								Else
									nValDia		 := Round(xMoeda(nValPgto,nMoeda,1,dDataBase,nDecse2,SE2->E2_TXMOEDA),2)
									nValPgto 	 := Round(xMoeda(nValPgto,nMoeda,1,dDataBase,nDecse2,aTxMoedas[nMoeda][2]),2)
									nDifCambio   := nValPgto - nValDia
									nCm			 := nDifCambio
								EndIf
							EndIf

							//-------------------
							// Efetua a baixa
							//-------------------
							If nValPgto > 0
								SE2->(DbClearFilter())

								If Empty(SE2->E2_NUM)
									dbSelectArea("SE2")
									SE2->(dbSetOrder(1))
									//SE2->(Dbseek(RTrim(Strtran(TRB->CHAVE,"**",""))))
									If !SE2->(Dbseek(xFilial("SE2")+(StrTran(Strtran(TRB->(TITULO+CLIFOR),"|",""),"*","")))) //!SE2->(Dbseek(xFilial("SE2")+(StrTran(Strtran(TRB->(TITULO+CLIFOR),"/",""),"*",""))))
										//If !SE2->(Dbseek(xFilial("SE2")+(StrTran(Strtran(TRB->(AllTrim(CHAVE)+AllTrim(CLIFOR)),"/",""),"*",""))))
											ConOut("Titulo n�o encontrado:" + TRB->TITULO)
										//EndIf
									EndIf
								EndIf
								//"    VL ||15798-NF ||A||VL ||001000||01"
								//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
								RecLock("SE2")
								Replace E2_IDENTEE	With cNumComp
								MsUnLock()

								nValTot     := SE2->E2_VLCRUZ

								//-----------------------------------------------------------
								//Valores Acessorios.
								//-----------------------------------------------------------
								If lExistFKD
									FAtuFKDBx(.F.,"P")
								EndIf

								If SE2->E2_TXMOEDA > 0
									nTxMoeda := SE2->E2_TXMOEDA
								Else
									nTxMoeda := RecMoeda(dBaixa,nMoeda)
								Endif

								cLanca		:= "S"

								If cPaisLoc == "BRA" .and. __lImpCC .and. lAltValPg
									F450VerImp( , , , ,@nValPgto)
								EndIf

								lBaixou		:= fA080Grv(lPadrao,.F.,.F.,cLanca,,IIf(cPaisLoc=="BRA",nTxMoeda,aTxMoedas[nMoeda][2]),,,,,,,aTitCalc)

								If lBaixou .And. __lImpCC
									RecLock("SE2")
									SE2->E2_VRETIRF += nIrrf
									MsUnlock()
								EndIf

								//Grava o codigo da compensa��o e o flag de contabiliza��o
								If AllTrim( SE5->E5_TABORI ) == "FK2"
									aAreaAnt := GetArea()
									RecLock("SE5")
									E5_IDENTEE := cNumComp
									E5_XSLDSE2:=SE2->E2_SALDO
									If !lUsaFlag
										E5_LA := 'S'
									Else
										aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->(Recno() ), 0, 0, 0} )
									EndIf
									MsUnlock()

									FK2->(DbSetOrder(1))
									If FK2->(dbseek(SE5->E5_FILIAL+SE5->E5_IDORIG))
										Reclock("FK2", .F.)
										FK2_IDPROC := cNumComp
										If !lUsaFlag
											FK2_LA := 'S'
										Else
											aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->(Recno() ), 0, 0, 0} )
										EndIf
										MsUnlock()
									Endif
									RestArea(aAreaAnt)
								EndIf

								If lBaixou
									AAdd(aSE5Recs,{"P",SE5->(Recno())})

									//Atualizo o n�mero da compensa��o nos valores acessorios (DC|MT|JR|CM|VA)
									//Mantido na forma antiga pois essas informa��es n�o s�o repassadas para as FK6
									//Este trecho ser� retirado quando a SE5 n�o for mais gravada
									dbSelectArea("SE5")
									nRecAtu := SE5->(Recno())
									nOrdAtu := SE5->(IndexOrd())
									SE5->(dbSetOrder(7))	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
									cChaveSe5 := SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
									cTipodoc := "DC|MT|JR|CM|VA"
									If dbSeek(cChaveSE5)
										While !SE5->(EOF()) .AND. cChaveSe5 == SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)

											//Atualizo o n�mero da compensa��o nos valores acessorios (DC|MT|JR|CM|VA)
											If SE5->E5_TIPODOC $ cTipodoc
												RecLock("SE5")
												Replace E5_IDENTEE With cNumComp

												If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
													aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
												Else
													Replace E5_LA With "S"
												EndIf
												MsUnLock()
											Endif

											SE5->(dbSkip())
										EndDo
									Endif

									SE5->(dbSetOrder(nOrdAtu))
									SE5->(dbGoto(nRecAtu))
									//-------------------------------------------
									// Inicializa variaveis para contabilizacao
									//-------------------------------------------
									VALOR := nValPgto
									VLRINSTR := VALOR
									If nMoeda <= 5 .And. nMoeda > 1
										cVal := Str(nMoeda,1)
										VALOR&cVal := nValEstrang
									EndIf
								Endif
							EndIf
						EndIf

						If nValRec > 0
							dbSelectArea("SA1")
							dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)

							nRegSE1 := SE1->(Recno())
							dbSelectArea("SE2")
							dbGobottom()
							dbSkip()
						ElseIf SA1->A1_COD + SA1->A1_LOJA != cCliCont + cLjCont
							DbSelectArea( 'SA1' )
							DbSeek( xFilial( 'SA1' ) + cCliCont + cLjCont )
						EndIf

						If nValPgto > 0
							dbSelectArea("SA2")
							dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)

							nRegSE2 := SE2->(Recno())
							dbSelectArea("SE1")
							dbGobottom()
							dbSkip()
						Endif

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

						Endif
						//-------------------------------------------------------
						// Integracao com o SIGAPCO para lancamento via processo
						//-------------------------------------------------------
						If !Empty(TRB->RECEBER)
							PcoDetLan("000018","02","FINA450",.F.) // ITEM 02 RECEBER
						ElseIf !Empty(TRB->PAGAR)
							PcoDetLan("000018","01","FINA450",.F.) // ITEM 01 PAGAR
						EndIf

						//Envio de e-mail pela rotina de checklist de documentos obrigatorios
						If (Upper(TRB->P_R) == "P") .And. lFinVDoc
							FA450ValDocs(TRB->CHAVE,.F.,.T.,.T.)
						EndIf

						nPis 		:= 0
						nCofins		:= 0
						nCsll		:= 0
						nIrrf 		:= 0
						nPisCalc	:= 0	//Pis Calculado
						nCofCalc	:= 0	//Cofins Calculado
						nCslCalc	:= 0	//Csll Calculado
						nIrfCalc	:= 0	//Irrf Calculado
						nPisBaseC	:= 0	//Base Pis Calculado
						nCofBaseC	:= 0	//Base Cofins Calculado
						nCslBaseC	:= 0	//Base Csll Calculado
						nIrfBaseC	:= 0	//Base Irrf Calculado
						nPisBaseR	:= 0	//Base Pis Retido
						nCofBaseR	:= 0	//Base Cofins Retido
						nCslBaseR	:= 0	//Base Csll Retido
						nIrfBaseR	:= 0	//Base Irrf Retido

					EndIf
					nCountReg += 1
					dbSelectArea("TRB")
					dbSkip()
				EndDo

				nFim := Seconds() - nInicio
				nFim := nFim/nCountReg

				If __lMetric
					// Metrica do tempo para exibir a tela de titulos para marca��o
					FwCustomMetrics():setAverageMetric("TempoGrava��o", "financeiro-protheus_tempo-conclus�o-processo_seconds", nFim)
				Endif

				DBCOMMITALL()
			End Transaction

			//---------------------------------------
			// Grava o numero da compensacao no SX6.
			//---------------------------------------
			dbSelectArea("SX6")
			PutMv("MV_NUMCOMP", cNumComp)

		Endif
		Exit
	Enddo

	If (lSai1 .Or. lSai2) .AND. !lF450Auto
		Help(" ",1,"RECNO")
		lProcessou  := .F.
	EndIF

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
				aFlagCTB := {}
		Endif


		//--------------------------------------------------------
		// Integracao com o SIGAPCO para lancamento via processo
		//--------------------------------------------------------
		PcoFinLan("000018")

	Endif

	//------------------------
	// Restaura os indices
	//------------------------
	dbSelectArea("SE1")
	dbSetOrder(1)

	dbSelectArea("SE2")
	dbSetOrder(1)

	If __oFINA4501 <> Nil
		__oFINA4501:Delete()
		__oFINA4501	:= Nil
	Endif

	FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()

	dbSelectArea( cAlias )
	dbSetOrder(1)

	If MsgYesNo("Deseja imprimir a compensa��o?")

		cQuery := " UPDATE "+ RetSQLName("SE5")+ " "
		cQuery += "  SET E5_DATA = E5_DTDISPO "
		cQuery += "  WHERE E5_DATA = '' "

		TCSQLExec(cQuery)

		U_RELAT003()
	EndIf


Return

//-------------------------------------------------------------------
/*{Protheus.doc} FA450Cli
Verifica se cliente existe 

@param lAutomato, Verifica se esta sendo chamada por rotina automatica
@author Vitor Duca
@since   22/08/2019
*/
//-------------------------------------------------------------------
Static Function FA450Cli(oCli450,lAutomato)
	LOCAL lRetorna as Logical
	Local cChave   as Character
	Local aArea    as Array

	Default lAutomato := .F.
	Default oCli450	  := NIL

	lRetorna := .T.
	cChave 	 := ""
	aArea	 := GetArea()

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	If !lAutomato
		If oCli450:lModiFied
			cChave := cCli450+IIF(!Empty(cLjCli),cLjCli,"")
			If SA1->(DbSeek(xFilial("SA1")+cChave))
				If cLjCli <> SA1->A1_LOJA
					cLjCli := SA1->A1_LOJA
				EndIf
			Else
				Help(" ",1,"FA450CLI")
				lRetorna := .F.
			EndIf
		Endif
	Else
		cChave := cCli450+cLjCli
		If SA1->(DbSeek(xFilial("SA1")+cChave))
			lRetorna := .T.
		Else
			lMsErroAuto := .T.
			lRetorna := .F.
		EndIf
	Endif

	RestArea(aArea)
Return lRetorna

//-------------------------------------------------------------------
/*{Protheus.doc} FA450For
Verifica se fornecedor existe 

@param lAutomato, Verifica se esta sendo chamada por rotina automatica
@author Vitor Duca 
@since   22/08/2019
*/
//-------------------------------------------------------------------
Static Function FA450For(oFor450,lAutomato)
	LOCAL lRetorna as Logical
	Local cChave   as Character
	Local aArea    as Array

	Default lAutomato := .F.
	Default oFor450	  := NIL

	lRetorna := .T.
	cChave 	 := ""
	aArea	 := GetArea()

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))

	If !lAutomato
		If oFor450:lModiFied
			cChave := cFor450+IIF(!Empty(cLjFor),cLjFor,"")
			If SA2->(DbSeek(xFilial("SA2")+cChave))
				If cLjFor <> SA2->A2_LOJA
					cLjFor := SA2->A2_LOJA
				EndIf
			Else
				Help(" ",1,"FA450For")
				lRetorna := .F.
			EndIf
		Endif
	Else
		cChave := cFor450+cLjFor
		If SA2->(DbSeek(xFilial("SA2")+cChave))
			lRetorna := .T.
		Else
			lMsErroAuto := .T.
			lRetorna := .F.
		Endif
	Endif

	RestArea(aArea)
Return lRetorna

//-------------------------------------------------------------------
/*{Protheus.doc} Fa450DbEva
Trata o dbeval para marcar e desmarcar item	

@author Pilar s. Albaladejo
@since   20/05/1992
*/
//-------------------------------------------------------------------
Static Function Fa450DbEva(nLim450,lMarcaTodos,aChaveLbn , aChavePag, aChaveRec,lPrimeiro)
	Local nTamChavE1	:= TamSx3("E1_PREFIXO")[1]+TamSx3("E1_NUM")[1]+TamSx3("E1_PARCELA")[1]+TamSx3("E1_TIPO")[1]+TamSx3("E1_FILIAL")[1]
	Local nTamChavE2	:= TamSx3("E2_PREFIXO")[1]+TamSx3("E2_NUM")[1]+TamSx3("E2_PARCELA")[1]+TamSx3("E2_TIPO")[1]+TamSx3("E2_FILIAL")[1]+TamSx3("E2_FORNECE")[1]+TamSx3("E2_LOJA")[1]
	Local lFinVDoc		:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)
	Local aArea			:= GetArea()
	Local aAreaSE2		:= SE2->(GetArea())
	Local nX			:= 0
	Local lMarcar		:= .F.
	Local nValOld		:= 0

	Default lPrimeiro:=.F.

	SE2->(dbSEtORder(1))

	lMarcaTodos := Iif(lMarcaTodos == Nil, .F., lMarcaTodos)

	If Right(TRB->TIPO,1) != "|"
		cChaveLbn := "CEC" + TRB->(P_R+CHAVE)

		If lMarcaTodos
			If LockByName(cChaveLbn,.T.,.F.)
				RecLock("TRB")

				If RECEBER != 0
					nSelecR += RECEBER
					TRB->MARCA := cMarca
				Else
					If AllTrim(TRB->(P_R))=="P" .and. lFinVDoc
						SE2->(dbSeek(TRB->(CHAVE)))
						IF CN062ValDocs("07",.F.,.F.,.T.,@lPrimeiro)
							nSelecP += PAGAR
							TRB->MARCA := cMarca
						Endif
					Else
						nSelecP += PAGAR
						TRB->MARCA := cMarca
					Endif
				EndIf

				Msunlock()
				Aadd(aChaveLbn,cChaveLbn)
			Endif
		Else
			IF RECEBER != 0
				If !lF450Auto
					lMarcar := (nSelecR < nLim450 .And. (RECEBER+nSelecR) <= nLim450)
				Else
					nX := aScan(aChaveRec, {|x| x[1]==Substr(CHAVE,1,nTamChavE1) })
					lMarcar := nX > 0 .And. ( (nSelecR < nLim450 .And. (RECEBER+nSelecR) <= nLim450) .OR. ( nlim450 == 0) )
				EndIf

				If lMarcar
					If LockByName(cChaveLbn,.T.,.F.)
						If AllTrim(TRB->(P_R))=="P" .and. lFinVDoc
							SE2->(dbSeek(TRB->(CHAVE)))
							IF CN062ValDocs("07",.F.,.F.,.T.,@lPrimeiro)
								RecLock("TRB")
								nSelecR += RECEBER
								TRB->MARCA := cMarca
								MsUnlock( )
								Aadd(aChaveLbn,cChaveLbn)
							Endif
						Else
							RecLock("TRB")
							nSelecR += RECEBER
							TRB->MARCA := cMarca
							MsUnlock( )
							Aadd(aChaveLbn,cChaveLbn)
						Endif

						If lF450Auto .And. VALTYPE(aChaveRec[nX]) == "A" .And. Len(aChaveRec[nX]) == 5
							nValOld := aChaveRec[nX,2] - ( aChaveRec[nX,3] + aChaveRec[nX,4] + aChaveRec[nX,5] )
							Fa450ValOk(If(RECEBER > aChaveRec[nX,2], RECEBER, aChaveRec[nX,2]), nValOld, aChaveRec[nX,3], aChaveRec[nX,5], aChaveRec[nX,4])
						EndIf
					Endif
				ElseIf (lF450Auto .And. nX > 0 .And. ((RECEBER+nSelecR) > nLim450) .And. !(nSelecR == nLim450))
					If LockByName(cChaveLbn,.T.,.F.)
						If AllTrim(TRB->(P_R))=="P" .and. lFinVDoc
							SE2->(MsSeek(TRB->(CHAVE)))
							IF CN062ValDocs("07",.F.,.F.,.T.,@lPrimeiro)
								RecLock("TRB")
								nSelecR := nLim450
								TRB->MARCA := cMarca
								MsUnlock( )
								Aadd(aChaveLbn,cChaveLbn)
							Endif
						Else
							RecLock("TRB")
							nSelecR := nLim450
							TRB->MARCA := cMarca
							MsUnlock( )
							Aadd(aChaveLbn,cChaveLbn)
						Endif

						If lF450Auto .And. VALTYPE(aChaveRec[nX]) == "A" .And. Len(aChaveRec[nX]) == 5
							nValOld := aChaveRec[nX,2] - ( aChaveRec[nX,3] + aChaveRec[nX,4] + aChaveRec[nX,5] )
							Fa450ValOk(RECEBER, nValOld, aChaveRec[nX,3], aChaveRec[nX,5], aChaveRec[nX,4])
						EndIf
					Endif
				Else
					RecLock("TRB")
					TRB->MARCA := " "
					MsUnlock( )
				EndIf
			Else
				If !lF450Auto
					lMarcar := (nSelecP < nLim450 .And. (PAGAR+nSelecP) <= nLim450)
				Else
					nX := aScan(aChavePag, {|x| x[1] == Substr(CHAVE,1,nTamChavE2) })
					lMarcar := nX > 0 .And. ( (nSelecP < nLim450 .And. (PAGAR+nSelecP) <= nLim450) .OR. ( nlim450 == 0) )
				EndIf

				If lMarcar
					If LockByName(cChaveLbn,.T.,.F.)
						If AllTrim(TRB->(P_R))=="P" .and. lFinVDoc
							SE2->(dbSeek(TRB->(CHAVE)))
							IF CN062ValDocs("07",.F.,.F.,.T.,@lPrimeiro)
								RecLock("TRB")
								nSelecP += PAGAR
								TRB->MARCA := cMarca
								MsUnlock( )
								Aadd(aChaveLbn,cChaveLbn)
							Endif
						Else
							RecLock("TRB")
							nSelecP += PAGAR
							TRB->MARCA := cMarca
							MsUnlock( )
							Aadd(aChaveLbn,cChaveLbn)
						Endif
						If lF450Auto .And. VALTYPE(aChavePag[nX]) == "A" .And. Len(aChavePag[nX]) == 5
							nValOld := aChavePag[nX,2] - ( aChavePag[nX,3] + aChavePag[nX,4] + aChavePag[nX,5] )
							Fa450ValOk(aChavePag[nX,2],nValOld,aChavePag[nX,3],aChavePag[nX,5],aChavePag[nX,4])
						EndIf
					Endif
				ElseIF (lF450Auto .AND. nX > 0 .AND. (((PAGAR+nSelecP) >= nLim450) .and. !(nSelecP == nLim450)))
					If LockByName(cChaveLbn,.T.,.F.)
						If AllTrim(TRB->(P_R))=="P" .and. lFinVDoc
							SE2->(MsSeek(TRB->(CHAVE)))
							IF CN062ValDocs("07",.F.,.F.,.T.,@lPrimeiro)
								RecLock("TRB")
								nSelecP := nLim450
								TRB->MARCA := cMarca
								MsUnlock( )
								Aadd(aChaveLbn,cChaveLbn)
							Endif
						Else
							RecLock("TRB")
							nSelecP := nLim450
							TRB->MARCA := cMarca
							MsUnlock( )
							Aadd(aChaveLbn,cChaveLbn)
						Endif

						If lF450Auto .And. VALTYPE(aChavePag[nX]) == "A" .And. Len(aChavePag[nX]) == 5
							nValOld := aChavePag[nX,2] - ( aChavePag[nX,3] + aChavePag[nX,4] + aChavePag[nX,5] )
							Fa450ValOk(aChavePag[nX,2],nValOld,aChavePag[nX,3],aChavePag[nX,5],aChavePag[nX,4])
						EndIf
					Endif
				Else
					RecLock("TRB")
					TRB->MARCA := " "
					MsUnlock( )
				EndIf
			EndIF
		EndIf
		MsUnlock( )
	EndIf

	RestArea(aAreaSE2)
	RestArea(aArea)
Return Nil

//-------------------------------------------------------------------
/*{Protheus.doc} FA450Data
Verifica se data final � maior que data inicial 

@author Pilar s. Albaladejo
@since   20/02/1997
*/
//-------------------------------------------------------------------
Static Function FA450Data(dVenIni450,dVenFim450,lAutomato)
	LOCAL lRet:=.T.

	Default lAutomato  := .F.

	If !lAutomato
		IF dVenFim450 < dVenIni450
			Help(" ",1,"DATAMENOR")
			lRet:=.F.
		EndIF
	Else
		IF dVenFim450 < dVenIni450
			lMsErroAuto := .T.
			lRet:=.F.
		EndIF
	Endif

Return lRet

//-------------------------------------------------------------------
/*{Protheus.doc} FA450Chec1
Retorna expressao para Indice Condicional dos titulos a receber

@author Pilar s. Albaladejo
@since   20/02/1997
*/
//-------------------------------------------------------------------
Static Function FA450Chec1(lTitFuturo,aSelFil,aTmpFil)
	//PCREQ-3782 - Bloqueio por situa��o de cobran�a
	Local cString := ""
	Local cTmpSE1Fil := ""

	cString := "SELECT SE1.R_E_C_N_O_ RECNO FROM " + RetSqlName("SE1") + " SE1 WHERE "

	If ExistBlock("F450OWN")
		cString += ExecBlock("F450OWN",.F.,.F.)
	Else
		If Len(aSelFil) > 1
			cString += "SE1.E1_FILIAL " + GetRngFil( aSelFil, "SE1", .T., @cTmpSE1Fil ) + " AND "
			aAdd(aTmpFil, cTmpSE1Fil)
		Else
			cString += "SE1.E1_FILIAL =  '" + xFilial("SE1") + "' AND "
		Endif

		//cString += "SE1.E1_CLIENTE = '" + cCli450        + "' AND "

		cString += "E1_VENCREA >= '" + DTOS(dCliIniVen) + "' AND "
		cString += "E1_VENCREA <= '" + DTOS(dCliFimVen) + "' AND "

		/*
		If !Empty(cLjCli)
			cString += "SE1.E1_LOJA = '" + cLjCli + "' AND "
		Endif
		*/

		//cString += "SE1.E1_VENCREA >= '" + DTOS(dVenIni450) + "' AND "
		//cString += "SE1.E1_VENCREA <= '" + DTOS(dVenFim450) + "' AND "

		If !lTitFuturo
			//cString += "SE1.E1_EMISSAO <= '" + DTOS(dDataBase) + "' AND "
			cString += "E1_EMISSAO >= '" + DTOS(dCliIniEmi) + "' AND "
			cString += "E1_EMISSAO <= '" + DTOS(dCliFimEmi) + "' AND "
		Endif

		If nDebCred == 1 // Titulos Normais
			cString += "E1_TIPO NOT IN ('"+MVPROVIS+"','"+MVPAGANT+"','"+MV_CPNEG+"','"+MVABATIM+"') AND "
		ElseIf  nDebCred == 2
			cString += "(E1_TIPO NOT IN ('"+MVPAGANT+"','"+MV_CPNEG+"') AND "
		Endif

		cString += F450TipoIN("R",nDebCred)

		//Se nao considera titulos transferidos, filtra (exibe) apenas os titulos que estao em carteira.
		If mv_par03 == 2
			cString += "SE1.E1_SITUACA IN ('0','F','G') AND "
		Endif

		cString += "E1_ORIGEM <> 'SIGAEFF' AND "

		If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("fn450SEX")
			cString += fn450SEX(lMonedaC, nMoeda, 'SE1')
		Else
			cString += "SE1.E1_MOEDA = " + Alltrim(Str(nMoeda,2)) + " AND "
		EndIf
		cString += "SE1.E1_SALDO > 0  AND "
		cString += "SE1.D_E_L_E_T_ = ' ' "

		If !Empty(cTpDocCli)
			cString += "AND E1_TIPO = '"+cTpDocCli+"' AND "
		Endif
		If !Empty(cPrefixo)
			cString += "AND E1_PREFIXO = '"+cPrefixo+"' AND "
		Endif

		cString += "SE1.E1_TIPO <> 'CHD' "

		If ExistBlock("F450FIL")
			cString += ExecBlock("F450FIL",.F.,.F.)
		EndIf
	EndIf

Return cString

//-------------------------------------------------------------------
/*{Protheus.doc} FA450Chec2
Retorna expressao para Indice Condicional dos titulos a pagar	

@author Pilar s. Albaladejo
@since   20/02/1997
*/
//-------------------------------------------------------------------
Static Function FA450Chec2(lTitFuturo,aSelFil,aTmpFil)
	Local lCtLiPag := SuperGetMv("MV_CTLIPAG",.F.,.F.)
	Local lPrjCni   :=  ValidaCNI()
	Local cString := ""
	Local cTmpSE2Fil := ""
	Local cMinPag   := cValToChar(SuperGetMv("MV_VLMINPG", .F., "0"))

	cString := "SELECT SE2.R_E_C_N_O_ RECNO FROM " + RetSqlName("SE2") + " SE2 WHERE "

	If ExistBlock("F450OWN1")
		cString += ExecBlock("F450OWN1",.F.,.F.)
	Else
		If Len(aSelFil) > 1
			cString += "SE2.E2_FILIAL " + GetRngFil( aSelFil, "SE2", .T., @cTmpSE2Fil ) + " AND "
			aAdd(aTmpFil, cTmpSE2Fil)
		Else
			cString += "SE2.E2_FILIAL =  '" + xFilial("SE2") + "' AND "
		Endif

		// controla Liberacao do titulo
		If lCtLiPag
			cString += "(SE2.E2_DATALIB <> ' ' OR CAST((SE2.E2_SALDO + SE2.E2_SDACRES - SE2.E2_SDDECRE) AS DECIMAL(18,2)) < '" + cMinPag + "') AND "
		EndIf

		cString += "SE2.E2_FORNECE = '" + cFor450        + "' AND "

		If !Empty(cLjFor)
			cString += "SE2.E2_LOJA = '" + cLjFor + "' AND "
		Endif

		cString += "SE2.E2_VENCREA >= '" + DTOS(dVenIni450) + "' AND "
		cString += "SE2.E2_VENCREA <= '" + DTOS(dVenFim450) + "' AND "

		If !lTitFuturo
			//cString += "SE2.E2_EMIS1 <= '" + DTOS(dDataBase) + "' AND "
			cString += "SE2.E2_EMISSAO >= '" + DTOS(dEmiIni450) + "' AND "
			cString += "SE2.E2_EMISSAO <= '" + DTOS(dEmiFim450) + "' AND "
		Endif

		cString += F450TipoIN("P",nDebCred)

		// Se n�o considera t�tulos transferidos, filtra (exibe) apenas os t�tulos que est�o em carteira.
		If mv_par03 == 2
			cString += "SE2.E2_NUMBOR = '' AND "
		Endif
		If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("fn450SEX")
			cString += fn450SEX(lMonedaC, nMoeda, 'SE2')
		Else
			cString += "SE2.E2_MOEDA = " + Alltrim(Str(nMoeda,2)) + " AND "
		EndIf
		cString += "SE2.E2_SALDO > 0  AND "

		//AAF - Titulos originados no SIGAEFF n�o devem ser alterados
		cString += "SE2.E2_ORIGEM <> 'SIGAEFF ' AND "

		If nDebCred == 1 // Titulos Normais
			cString += "E2_TIPO NOT IN ('"+MVPROVIS+"','"+MVPAGANT+"','"+MV_CPNEG+"','"+MVABATIM+"') AND "
		ElseIf  nDebCred == 2
			cString += "(E2_TIPO NOT IN ('"+MVPAGANT+"','"+MV_CPNEG+"') AND "
		Endif

		If !Empty(cTpDoc)
			cString += "SE2.E2_TIPO = '"+cTpDoc+"' AND "
		Endif
		If !Empty(cPrefFor)
			cString += "SE2.E2_PREFIXO = '"+cPrefFor+"' AND "
		Endif
		cString += "SE2.E2_FORNECE='" + cFor450 + "' "
		If !Empty(cLjFor)
			cString += "AND SE2.E2_LOJA='" + cLjFor + "' "
		EndIf

		/*-----------------------------------------------------------------------
		|Tratamento Realizado para o cliente CNI
		|Os titulos a pagar que est�o com solicita��o de transferencia em aberto 
		|N�o devem entrar na rotina de Compensa��o 
		-------------------------------------------------------------------------*/
		If lPrjCni
			cString += "SE2.E2_NUMSOL = '     ' AND "
		Endif
			
		cString += "AND SE2.D_E_L_E_T_ = ' ' "
		
		If ExistBlock("F450FIL1")
			cString += ExecBlock("F450FIL1",.F.,.F.)		
		EndIf			
	EndIf

Return cString

//-------------------------------------------------------------------
/*{Protheus.doc} Fa450Gerarq
Gera arquivo de trabalho	

@author Pilar s. Albaladejo
@since   20/02/1997
*/
//-------------------------------------------------------------------
User Function Fa450Gerarq(aCampos)
	Local TRB
	Local cChave := "P_R+CHAVE"
	Local aStruct := {}
	Local aTam := {}
	Local cArquivo := ""

	Local nTamFil		:= TamSx3("E2_FILIAL")[1]
	Local nTamPref		:= TamSx3("E2_PREFIXO")[1]
	Local nTamNum		:= TamSx3("E2_NUM")[1]
	Local nTamParc		:= TamSx3("E2_PARCELA")[1]
	Local nTamTipo		:= TamSx3("E2_TIPO")[1]
	Local nTamForn		:= TamSx3("E2_FORNECE")[1]
	Local nTamLoja		:= TamSx3("E1_LOJA")[1]

	Local nTamTitulo	:= nTamPref + nTamNum + nTamParc + nTamTipo
	Local nTamChavE2	:= nTamFil + nTamForn + nTamLoja + nTamtitulo
	Local nTamChavE1	:= nTamtitulo + nTamFil
	Local nTamCod		:= nTamForn + nTamLoja + 1

	If cOrdem == "Valor"
		cChave := "P_R+STR(PAGAR)+STR(RECEBER)"
	Endif

	//Ponto de entrada para possibilitar alterar a ordem dos registros a serem selecionados
	If ExistBlock("F450ORDEM")
		cChave := ExecBlock( "F450ORDEM", .F., .F., { cChave } )
	EndIf
/*
	If __oFINA4501 <> Nil
		__oFINA4501:Delete()
		__oFINA4501	:= Nil
	Endif

	//Cria o Objeto do FwTemporaryTable
	__oFINA4501 := FwTemporaryTable():New("TRB")

	//Cria a estrutura do alias temporario
	__oFINA4501:SetFields(aCampos)

	//Adiciona o indicie na tabela temporaria
	__oFINA4501:AddIndex("1",StrTokArr(cChave,"+"))

	//Criando a Tabela Temporaria
	__oFINA4501:Create()

	*/


	aStruct := {}

	aAdd(aStruct,{"P_R"      ,"C",1,0})
	aAdd(aStruct,{"TITULO"   ,"C",nTamTitulo+3,0})
	aAdd(aStruct,{"PAGAR"    ,"N",15,2})
	aAdd(aStruct,{"RECEBER"  ,"N",15,2})
	aAdd(aStruct,{"EMISSAO"  ,"D", 8,0})
	aAdd(aStruct,{"VENCTO"   ,"D", 8,0})
	aAdd(aStruct,{"TIPO"     ,"C", 3,0})
	aAdd(aStruct,{"MARCA"    ,"C", 2,0})
	aAdd(aStruct,{"CHAVE"    ,"C",nTamChavE2,0})
	aAdd(aStruct,{"PRINCIP"	 ,"N",15,2})
	aAdd(aStruct,{"ABATIM"   ,"N",15,2})
	aAdd(aStruct,{"JUROS"    ,"N",15,2})
	aAdd(aStruct,{"MULTA"    ,"N",15,2})
	aAdd(aStruct,{"VALACES"  ,"N",15,2})
	aAdd(aStruct,{"DESCONT"	 ,"N",15,2})
	aAdd(aStruct,{"ACRESC"   ,"N",15,2})
	aAdd(aStruct,{"DECRESC"  ,"N",15,2})
	aAdd(aStruct,{"PCC"  	 ,"N",15,2})
	aAdd(aStruct,{"IRRF"  	 ,"N",15,2})	//Irrf Retido
	aAdd(aStruct,{"CLIFOR"	 ,"C",nTamCod,0})
	aAdd(aStruct,{"NOME"     ,"C",20,0})
	aAdd(aStruct,{"CHAVEORI" ,"C",nTamChavE2,0})
	aAdd(aStruct,{"PIS"  	 ,"N",15,2})	//Pis Retido
	aAdd(aStruct,{"COF"  	 ,"N",15,2})	//Cofins Retido
	aAdd(aStruct,{"CSL"  	 ,"N",15,2})	//Csll Retido
	aAdd(aStruct,{"PISC"  	 ,"N",15,2})	//Pis Calculado
	aAdd(aStruct,{"COFC"  	 ,"N",15,2})	//Cofins Calculado
	aAdd(aStruct,{"CSLC"  	 ,"N",15,2})	//Csll Calculado
	aAdd(aStruct,{"IRRFC"  	 ,"N",15,2})	//Irrf Calculado
	aAdd(aStruct,{"PISBC"  	 ,"N",15,2})	//Base Pis Calculado
	aAdd(aStruct,{"COFBC"  	 ,"N",15,2})	//Base Cofins Calculado
	aAdd(aStruct,{"CSLBC"  	 ,"N",15,2})	//Base Csll Calculado
	aAdd(aStruct,{"IRRBC"  	 ,"N",15,2})	//Base Irrf Calculado
	aAdd(aStruct,{"PISBR"  	 ,"N",15,2})	//Base Pis Retido
	aAdd(aStruct,{"COFBR"  	 ,"N",15,2})	//Base Cofins Retido
	aAdd(aStruct,{"CSLBR"  	 ,"N",15,2})	//Base Csll Retido
	aAdd(aStruct,{"IRRBR"  	 ,"N",15,2})	//Base Irrf Retido
	aAdd(aStruct,{"POSAR"  	 ,"N",10,0})


	cArquivo := CriaTrab(aStruct,.T.)

	If Select("TRB") != 0
		TRB->(dbCloseArea())
	End

	dbUseArea(.T.,"",cArquivo,"TRB",.F.,.F.)

	IndRegua("TRB",cArquivo,cChave,,,"Criando �ndice...")

Return TRB

//-------------------------------------------------------------------
/*{Protheus.doc} Fa450Repl
Grava registros no arquivo temporario	

@author Pilar s. Albaladejo
@since   20/02/1997
*/
//-------------------------------------------------------------------
Static Function Fa450Repl(TRB, cAliasSE1,cAliasSE2,aAutoCab, aImpos)
	Local nAbat			:= 0
	Local nJuros		:= 0
	Local nVa			:= 0
	Local nDescont		:= 0
	Local nMulta		:= 0                             //Valor da Multa
	Local cMVJurTipo 	:= SuperGetMV("MV_JURTIPO",,"") //Tipo de calculo dos Juros
	Local lLojxRMul  	:= .T.  //Calculo de Juros e Multas: SIGALOJA x SIGAFIN
	Local lMvLjIntFS 	:= SuperGetMV("MV_LJINTFS", , .F.) //Integra��o com o Financial Services Habilitada?
	Local nPccTit		:= 0
	Local nIRFTit		:= 0
	Local lIntSJURI     := SuperGetMv("MV_JURXFIN",.T.,.F.) // Integra��o com o m�dulo SIGAPFS
	Local lOk 			:= .T.
	Local aPcc			:= Array(7)

	Default aImpos 		:= {}

	AFill( aPcc, 0 )

	dBaixa		:= dDataBase

	dbSelectArea(cAliasSE1)
	dbGotop()

	While !(cAliasSE1)->(Eof())
		If lOk
			dbSelectArea("SE1")
			lOk := .F.
		EndIf

		SE1->(DbGoTo((cAliasSE1)->RECNO))

		//-----------------------------------------------------------
		// Mexico - Manejo de Anticipo
		// Validacao para nao selecionar os titulos das notas
		// de adiantamento e os titulos do tipo RA gerados pela
		// rotina recebimentos diversos.
		//-----------------------------------------------------------
		If cPaisLoc == "MEX" .And.;
				X3Usado("ED_OPERADT") .And.;
				Upper(Alltrim(SE1->E1_ORIGEM)) $ "FINA087A|MATA467N" .And.;
				GetAdvFVal("SED","ED_OPERADT",xFilial("SED")+SE1->E1_NATUREZ,1,"") == "1"

			SE1->(dbSkip())
			Loop
		EndIf

		If lExistVA
			nVa		:= FValAcess(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_NATUREZ, /*lBaixados*/,/*cCodVa*/,"R",dDatabase)
			//Converto para a moeda do titulo para compor o valor da baixa corretamente
			If SE1->E1_MOEDA > 1
				nVa := xMoeda(nVa,1,SE1->E1_MOEDA,dDataBase,3,,SE1->E1_TXMOEDA)
			Endif
		EndIf

		nAbat	:= SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"S",dDataBase,,,,,,,SE1->E1_FILORIG)
		nJuros	:= fa070Juros(SE1->E1_MOEDA)
		nDescont := FaDescFin("SE1",dDataBase,SE1->E1_SALDO-nAbat,SE1->E1_MOEDA)

		//---------------------------------------------------------
		// Calcula a multa, conforme a regra do controle de lojas
		//---------------------------------------------------------
		nMulta := 0

		If (cMvJurTipo == "L" .OR. lMvLjIntFS) .and. lLojxRMul  .and. SE1->E1_SALDO > 0 .And. !(SE1->E1_TIPO $ MVRECANT + "|" + MV_CRNEG)

			//------------------------------------------------------------------
			// Calcula o valor da Multa  :funcao LojxRMul :fonte Lojxrec
			//------------------------------------------------------------------
			nMulta := LojxRMul( , , ,SE1->E1_SALDO, SE1->E1_ACRESC, SE1->E1_VENCREA,, , SE1->E1_MULTA, ,;
				SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_CLIENTE, SE1->E1_LOJA, "SE1",.T. )

		Endif
		//Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Final
		If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("fn450GrTmp")
			fn450GrTmp('SE1',TRB, nAbat,nJuros,nVa,nDescont,nMulta)
		Else
			RecLock("TRB",.T.)
			Replace P_R			With "R"
			Replace TITULO		With SE1->E1_PREFIXO + "|" + SE1->E1_NUM + "|" + SE1->E1_PARCELA+ "|" + SE1->E1_TIPO
			Replace EMISSAO		With SE1->E1_EMISSAO
			Replace VENCTO		With SE1->E1_VENCREA
			Replace RECEBER		With SE1->E1_SALDO - nAbat + SE1->E1_SDACRES - SE1->E1_SDDECRE + nJuros - nDescont + nMulta + nVA
			//Replace	VLRREC	    With SE1->E1_VALLIQ
			Replace MARCA		With " "
			Replace TIPO		With SE1->E1_TIPO
			Replace PRINCIP		With SE1->E1_SALDO
			Replace ABATIM		With nAbat
			Replace JUROS		With nJuros
			Replace MULTA		With nMulta	 //Calculo de Juros e Multas: SIGALOJA x SIGAFIN
			Replace VALACES		With nVA
			Replace DESCONT		With nDescont
			Replace ACRESC		With SE1->E1_SDACRES
			Replace DECRESC		With SE1->E1_SDDECRE
			Replace PCC			With 0
			Replace IRRF		With 0
			Replace CLIFOR		With SE1->E1_CLIENTE+"|"+SE1->E1_LOJA
			Replace NOME		With SE1->E1_NOMCLI
			Replace CHAVE		With SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
			MsUnlock()

			nTotalR	+= RECEBER
		EndIf
		If ExistBlock("F450GRAVA")
			Execblock("F450GRAVA",.F.,.F.,{"SE1"})
		EndIf
		(cAliasSE1)->(dbSkip())
	EndDo

	lOk := .T.
	dbSelectArea(cAliasSE2)
	dbGotop()

	While !(cAliasSE2)->(Eof())
		If lOk
			DbSelectArea("SE2")
			lOk := .F.
		EndIf

		SE2->(DbGoTo((cAliasSE2)->RECNO))

		//------------------------------------------------------------------------------------------------
		// Caso tenha integracao SIGAPFS (MV_JURXFIN = .T.), valida as regras para manipulacao do t�tulo.
		//------------------------------------------------------------------------------------------------
		If lIntSJURI .And. !Fa450Juri(SE2->(RECNO()))
			(cAliasSE2)->(dbSkip())
			Loop
		EndIf

		nAbat	:= SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_MOEDA,"V",dDataBase,SE2->E2_LOJA,,,,,SE2->E2_TIPO)
		nJuros	:= fa080Juros(SE2->E2_MOEDA)
		nMulta	:= 0

		//--------------------------------------------------------------------------
		//C�lculo de Valores Acessorios
		//-----------------------------------------------------------------------------
		If lExistVa
			nVa	:= FValAcess(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NATUREZ, /*lBaixados*/,/*cCodVa*/,"P",dDatabase)
			//Converto para a moeda do titulo para compor o valor da baixa corretamente
			If SE2->E2_MOEDA > 1
				nVa := xMoeda(nVa,1,SE2->E2_MOEDA,dDataBase,3,,SE2->E2_TXMOEDA)
			Endif
		EndIf

		AFill( aPcc, 0 )
		If cPaisLoc == "BRA" .and. __lImpCC
			nValPgto := 0
			F450VerImp(@nPccTit, @nIrfTit, aPcc, , ,.T.)
		Endif
		If cPaisLoc == "MEX" .and. lMonedaC .and. FindFunction("fn450GrTmp")
			fn450GrTmp('SE2',TRB, nAbat,nJuros,nVa,nDescont,nMulta)
		Else
			RecLock("TRB",.T.)
			Replace	P_R			With "P"
			Replace	TITULO		With SE2->E2_PREFIXO + "|" + SE2->E2_NUM + "|" + SE2->E2_PARCELA+ "|" + SE2->E2_TIPO //Caire, troquei o - por &
			Replace	EMISSAO		With SE2->E2_EMISSAO
			Replace	VENCTO		With SE2->E2_VENCREA
			//Replace	VLRPAG	    With SE2->E2_VALLIQ
			Replace PAGAR 		With SE2->E2_SALDO - nAbat + SE2->E2_SDACRES - SE2->E2_SDDECRE + nJuros + nVA + nMulta - (nPccTit + nIrfTit)
			Replace	MARCA 		With " "
			Replace TIPO     	With SE2->E2_TIPO
			Replace	PRINCIP		With SE2->E2_SALDO
			Replace	ABATIM		With nAbat
			Replace JUROS		With nJuros
			Replace MULTA		With nMulta
			Replace VALACES		With nVA
			Replace DESCONT		With 0
			Replace ACRESC		With SE2->E2_SDACRES
			Replace DECRESC		With SE2->E2_SDDECRE
			Replace PCC			With nPccTit
			Replace IRRF		With nIrfTit
			Replace CLIFOR		With SE2->E2_FORNECE+"|"+SE2->E2_LOJA //Caire, troquei o - por &
			Replace NOME		With SE2->E2_NOMFOR
			Replace	CHAVE 		With SE2->(E2_FILIAL+E2_PREFIXO+SE2->E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
			Replace PIS			With aPcc[2]
			Replace COF			With aPcc[3]
			Replace CSL			With aPcc[4]
			Replace PISC		With nPisCalc		//Pis Calculado
			Replace COFC		With nCofCalc		//Cofins Calculado
			Replace CSLC		With nCslCalc		//Csll Calculado
			Replace IRRFC		With nIrfCalc		//Irrf Calculado
			Replace PISBC		With nPisBaseC		//Base Pis Calculado
			Replace COFBC		With nCofBaseC		//Base Cofins Calculado
			Replace CSLBC		With nCslBaseC		//Base Csll Calculado
			Replace IRRBC		With nIrfBaseC		//Base Irrf Calculado
			Replace PISBR		With nPisBaseR		//Base Pis Retido
			Replace COFBR		With nCofBaseR		//Base Cofins Retido
			Replace CSLBR		With nCslBaseR		//Base Csll Retido
			Replace IRRBR		With nIrfBaseR		//Base Irrf Retido

			//Prepara��o para a grava��o de reten��o do PCC
			If Len(aPCC) > 4
				AAdd(aImpos, aPCC[5])
				Replace POSAR	With Len(aImpos)
			Endif
			MsUnlock()

			nTotalP	+= PAGAR
		EndIf
		If ExistBlock("F450GRAVA")
			Execblock("F450GRAVA",.F.,.F.,{"SE2"})
		EndIf
		(cAliasSE2)->(dbSkip())
	EndDo

	If !Empty(cAliasSe1)
		DbSelectArea(cAliasSe1)
		DbCloseArea()
	Endif

	If !Empty(cAliasSe2)
		DbSelectArea(cAliasSe2)
		DbCloseArea()
	Endif


Return

//-------------------------------------------------------------------
/*{Protheus.doc} Fa450F3
Habilita ou nao a tecla F3 	

@author Wagner Xavier
@since   28/02/1997
*/
//-------------------------------------------------------------------
Static Function Fa450F3(cArq)
	If cArq == nil
		Set Key K_F3 To
	Else
		SetKey( K_F3, {|a,b,c| ConPad1(a,b,c,cArq)} )
	Endif

Return (.t.)

//-------------------------------------------------------------------
/*{Protheus.doc} Fa450Inverte
Inverte markbrowse no windows	

@author Pilar S Albaladejo
@since   28/02/1997
*/
//-------------------------------------------------------------------
Static Function Fa450Inverte(cMarca,oTotalP,oTotalR,oSelecP,oSelecR,lTodos,aChaveLbn)
	Local nReg			:= TRB->(Recno())
	Local lCompensa		:= .F.
	Local nTamChavE2	:= TamSx3("E2_PREFIXO")[1]+TamSx3("E2_NUM")[1]+TamSx3("E2_PARCELA")[1]+TamSx3("E2_TIPO")[1]+TamSx3("E2_FILIAL")[1]+TamSx3("E2_FORNECE")[1]+TamSx3("E2_LOJA")[1]
	Local nTamChavE1	:= TamSx3("E2_PREFIXO")[1]+TamSx3("E2_NUM")[1]+TamSx3("E2_PARCELA")[1]+TamSx3("E2_TIPO")[1]+2
	Local cTipo			:= ""
	Local lValDocs		:= .T.
	Local lFinVDoc		:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
	Local lPrimeiro		:= .T. // na valida��o de amarra��o fin x documentos, deve passar apenas uma vez pelo help
	Local lSelecP		:= .F.
	Local lSelecR		:= .F.
	Local nVlPagar		:= 0
	Local nVlReceb		:= 0
	Local lAlterado		:= .F.

	Default lTodos		:= .T.

	If lTodos
		dbSelectArea("TRB")
		dbGoTop()
	Endif

	While !lTodos .Or. !Eof()
		lValDocs := .T.
		lCompensa := .T.
		//--------------------------------------------------------------
		// So executa o P.E. quando o registro/titulo est� sendo marcado.
		// Nao chama na "desmarca��o".
		//--------------------------------------------------------------
		If ExistBlock("F450Conf") .and. MARCA != cMarca
			//-------------------------------------------------
			// Procura registro no SE1 ou SE2, conforme titulo
			//-------------------------------------------------
			If TRB->RECEBER != 0
				dbSelectArea("SE1")
				dbSetOrder(1)
				dbSeek(Substr(TRB->CHAVE,1,nTamChavE1))
				//----------------------------------------------------------------------------------
				// Caso seja um Titulo � Receber, o parametro passado para o PE terah conteudo "R",
				// nesse caso o RDMake devera consultar o SE1.
				//----------------------------------------------------------------------------------
				cTipo := "R"
			Else
				dbSelectArea("SE2")
				dbSetOrder(1)
				dbSeek(Substr(TRB->CHAVE,1,nTamChavE2))
				//--------------------------------------------------------------------------------
				// Caso seja um Titulo � Pagar, o parametro passado para o PE terah conteudo "P",
				// nesse caso o RDMake deverah consultar o SE2.
				//--------------------------------------------------------------------------------
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
			If !(TRB->TIPO $ MVABATIM)
				IF TRB->MARCA == cMarca
					RecLock("TRB")
					TRB->MARCA := "  "
					If TRB->RECEBER != 0
						nSelecR -= TRB->RECEBER
					Else
						nSelecP -= TRB->PAGAR
					EndIf
					nAscan := Ascan(aChaveLbn, cChaveLbn )
					If nAscan > 0
						UnLockByName(aChaveLbn[nAscan],.T.,.F.)
					Endif
				Else
					If (Upper(TRB->P_R) == "P") .And. lFinVDoc
						If !FA450ValDocs(TRB->CHAVE,lTodos,.T.,,@lPrimeiro)
							lValDocs := .F.
						EndIf
					EndIf
					If lValDocs
						If (TRB->P_R == "P")
							dbSelectArea("SE2")
							DbSetOrder(1)
							If dbSeek(TRB->(CHAVE))
								If SE2->E2_SALDO != TRB->PRINCIP
									lAlterado := .T.
								Endif
							EndIf
						Else
							dbSelectArea("SE1")
							DbSetOrder(1)
							If dbSeek(TRB->(CHAVE))
								If SE1->E1_SALDO != TRB->PRINCIP
									lAlterado := .T.
								Endif
							EndIf
						EndIf
						If ExistBlock("F450GRAVA")
							lAlterado := .F.
						Endif
						DbSelectArea("TRB")
						If LockByName(cChaveLbn,.T.,.F.) .and. !lAlterado
							RecLock("TRB")
							TRB->MARCA := cMarca
							If TRB->RECEBER != 0
								nSelecR += TRB->RECEBER
							Else
								nSelecP += TRB->PAGAR
								DbSelectArea("TRB")
							EndIf
							Aadd(aChaveLbn, cChaveLbn )
						Else
							If !lTodos
								MsgAlert(STR0082, STR0083) // "Existe outro usu�rio utilizando o titulo. N�o � permitida a compensa��o do titulo quando ele est� sendo utilizado por outro usu�rio" ## "Aten��o"
							Endif
						Endif
					EndIf
				Endif
				MsUnlock()
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

Return ( lAlterado )

//-------------------------------------------------------------------
/*{Protheus.doc} Fa450Disp
Exibe na tela os titulos marcados - WINDOWS	

@author Pilar S Albaladejo
@since   28/02/1997
*/
//-------------------------------------------------------------------
Static Function Fa450Disp(cMarca,lInverte,oTotalP,oTotalR,oSelecP,oSelecR)
	Local cFieldMarca := "MARCA"

	If Right(TRB->TIPO,1) != "|"
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

//-------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}Fa450Edit
Ajusta valores de compensa��o

@author Pilar S Albaladejo
@since  12/03/1997
@version 12.1.7
/*/
//-------------------------------------------------------------------------------------------------------------
Static Function Fa450Edit(oSelecP,oSelecR,nTamChavE1,nTamChavE2)
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

	DEFINE MSDIALOG oDlg FROM	69,70 TO 320,331 TITLE cTitulo PIXEL
	@ 0.5, 2 TO 105, 132 OF oDlg  PIXEL


	@ 07, 68	MSGET TRB->PRINCIP Picture "@E 9999,999,999.99" HASBUTTON When .F. SIZE 54, 10 OF oDlg PIXEL
	@ 08, 09 SAY STR0078 SIZE 54, 7 OF oDlg PIXEL //"Valor Principal"

	@ 17, 68	MSGET TRB->ABATIM Picture "@E 9999,999,999.99" HASBUTTON When .F.	SIZE 54, 10 OF oDlg PIXEL
	@ 18, 09 SAY STR0079 SIZE 54, 7 OF oDlg PIXEL //"Abatimentos"

	@ 27, 68	MSGET TRB->ACRESC Picture "@E 9999,999,999.99" HASBUTTON When .F. 	SIZE 54, 10 OF oDlg PIXEL
	@ 28, 09 SAY STR0073  SIZE 54, 7 OF oDlg PIXEL //"Acrescimos"

	@ 37, 68	MSGET TRB->DECRESC Picture "@E 9999,999,999.99" HASBUTTON When .F. 	SIZE 54, 10 OF oDlg PIXEL
	@ 38, 09 SAY STR0074  SIZE 54, 7 OF oDlg PIXEL //"Decrescimos"

	@ 47, 68	MSGET nJurAtu		Picture "@E 9999,999,999.99" Valid F450AtuVal(@nValor,oValor,nJurAtu,@nOldJur,nDesAtu,@nOldDes,nMulAtu,@nOldMul,1,TRB->VALACES) SIZE 54, 10 OF oDlg Hasbutton PIXEL
	@ 48, 09 SAY STR0070  SIZE 54, 7 OF oDlg PIXEL  //"Juros"

	@ 57, 68	MSGET nMulAtu		Picture "@E 9999,999,999.99" Valid F450AtuVal(@nValor,oValor,nJurAtu,@nOldJur,nDesAtu,@nOldDes,nMulAtu,@nOldMul,2,TRB->VALACES) SIZE 54, 10 OF oDlg Hasbutton PIXEL
	@ 58, 09 SAY STR0071  SIZE 54, 7 OF oDlg PIXEL  //"Multa"

	@ 67, 68	MSGET nDesAtu		Picture "@E 9999,999,999.99" Valid F450AtuVal(@nValor,oValor,nJurAtu,@nOldJur,nDesAtu,@nOldDes,nMulAtu,@nOldMul,3,TRB->VALACES) SIZE 54, 10 OF oDlg Hasbutton PIXEL
	@ 68, 09 SAY STR0072  SIZE 54, 7 OF oDlg PIXEL //"Descontos"

	@ 77, 68	MSGET TRB->VALACES Picture "@E 9999,999,999.99" HASBUTTON When .F. 	SIZE 54, 10 OF oDlg PIXEL
	@ 78, 09 SAY STR0101  SIZE 54, 7 OF oDlg PIXEL //"Valores Acess�rios"

	@ 87, 68	MSGET oValor VAR nValor Picture "@E 9999,999,999.99" Valid Fa450Val(@nValor,nJurAtu,nDesAtu,TRB->ACRESC,TRB->DECRESC,TRB->ABATIM,nMulAtu,nTamChavE1,nTamChavE2,TRB->VALACES);
		SIZE 54, 10 OF oDlg Hasbutton PIXEL
	@ 88, 9 SAY STR0057  SIZE 54, 7 OF oDlg PIXEL  //"Valor a compensar"

	DEFINE SBUTTON FROM 108, 71 TYPE 1 ENABLE ACTION (nOpca:=1,Fa450ValOk(@nValor,nOldVal,nJurAtu,nDesAtu,nMulAtu),;
		iif(cPaisLoc == 'MEX' .and. lMonedaC .and. FindFunction("Fn450Mark"), Fn450Mark(nOldVal,oSelecP,oSelecR,nValor),Fa450Marca(nOldVal,oSelecP,oSelecR,nValor)),;
		oDLg:End(),nOpca:=0) OF oDlg
	DEFINE SBUTTON FROM 108, 99 TYPE 2 ENABLE ACTION (oDlg:End()) OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

Return

//-------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}Fa450Marca
Trata o dbeval para marcar e totalizar itens

@author Pilar S Albaladejo
@since  15/03/1997
@version 12.1.7
/*/
//-------------------------------------------------------------------------------------------------------------
Static Function Fa450Marca(nOldVal,oSelecp,oSelecR,nValor)
	Local _nRectrb := TRB->(Recno())

	Default nValor := 0

	nSelecR := 0
	nSelecP := 0

	DbSelectArea("TRB")
	TRB->(DbGoTop())
	While TRB->(!Eof())
		If !Empty(TRB->MARCA)
			If TRB->RECEBER != 0
				If TRB->(Recno()) == _nRecTrb .And. nValor <> 0
					nSelecR += nValor
				Else
					If TRB->RECEBER <> TRB->PRINCIP
						nSelecR += TRB->RECEBER
					Else
						nSelecR += TRB->(PRINCIP + JUROS + MULTA - DESCONT + VALACES)
					EndIf
				EndIf
				If nLim450 > 0 .and. nSelecR >= nLim450
					nSelecR := nLim450
				Endif
			Else
				If TRB->(Recno()) == _nRecTrb .And. nValor <> 0
					nSelecP += nValor
				Else
					If TRB->PAGAR <> TRB->PRINCIP
						nSelecP += TRB->PAGAR
					Else
						nSelecP += TRB->(PRINCIP + JUROS + MULTA - DESCONT + VALACES)
					EndIf
				EndIf
				If nLim450 > 0 .and. nSelecP >= nLim450
					nSelecP := nLim450
				Endif
			Endif
		Endif
		TRB->(DbSkip())
	Enddo

	TRB->(DbGoto(_nRectrb))

	If !lF450Auto
		oSelecP:Refresh()
		oSelecR:Refresh()
	EndIf

Return Nil

//-------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}Fa450Val
Valida o valor digitado no ajuste de valores de compensa��o

@author Pilar S Albaladejo
@since  12/03/1997
@version 12.1.7
/*/
//-------------------------------------------------------------------------------------------------------------
Static Function Fa450Val(nValor,nJurAtu,nDesAtu,nAcresc,nDecresc,nAbatim,nMulAtu,nTamChavE1,nTamChavE2,nVlrVA)
	Local lRet := .T.

	DEFAULT nVlrVA := 0

	If nValor == 0
		lRet := .F.
	ElseiF nValor < nJurAtu + nMulAtu + nVlrVA
		lRet := .F.
	Else
		If TRB->RECEBER != 0
			dbSelectArea("SE1")
			dbSetOrder(1)
			If	dbSeek(Substr(TRB->CHAVE,1,nTamChavE1))
				If SE1->E1_SALDO < nValor-nJurAtu-nMulAtu+nDesAtu-nAcresc+nDecresc+nAbatim-nVlrVA
					Help(" ",1,"FA450VAL")
					lRet := .F.
				Endif
			EndIf
		Else
			dbSelectArea("SE2")
			dbSetOrder(1)
			If	dbSeek(Substr(TRB->CHAVE,1,nTamChavE2))
				If SE2->E2_SALDO < nValor-nJurAtu-nMulAtu+nDesAtu-nAcresc+nDecresc+nAbatim-nVlrVA
					Help(" ",1,"FA450VAL")
					lRet := .F.
				Endif
			EndIf
		EndIf
	EndIF

Return lRet

//-------------------------------------------------------------------
/*{Protheus.doc} Fa450ValOk
Verifica na confirmacao da tela, a validacao do valor - WIN

@author Pilar S Albaladejo
@since   12/03/1997
*/
//-------------------------------------------------------------------
Static Function Fa450ValOk(nValor,nOldVal,nJur,nDesc,nMulta)
	Local nCasDec 		:= TamSx3("E1_TXMOEDA")[2]
	Local aPcc          := {}

	RecLock("TRB")
	If TRB->RECEBER != 0
		If Empty(TRB->MARCA)
			nSelecR += nOldVal
		ElseIf nJur != JUROS
			nSelecR := nOldVal - nJur
		EndIf
		If nDesc != DESCONT .And. !Empty(TRB->MARCA)
			nSelecR := nOldVal + nDesc
		EndIf
		If nMulta != MULTA .And. !Empty(TRB->MARCA)
			nSelecR := nOldVal - nMulta
		Endif
		Replace RECEBER	With nValor
	Else
		If Empty(TRB->MARCA)
			nSelecP += nOldVal
		ElseIf nJur != JUROS
			nSelecP := nOldVal + nJur
		EndIf
		If nDesc != DESCONT .And. !Empty(TRB->MARCA)
			nSelecP := nOldVal - nDesc
		EndIf
		If nMulta != MULTA .And. !Empty(TRB->MARCA)
			nSelecP := nOldVal + nMulta
		Endif

		If __lImpCC
			SE2->(DbSetOrder(1))
			SE2->(MsSeek(TRB->CHAVE))

			SED->(DbSetOrder(1))
			SED->(MSSeek(xFilial("SED",SE2->E2_FILORIG)+SE2->E2_NATUREZ))

			aPcc    	:= newMinPcc(dDataBase, nValor, SED->ED_CODIGO, "P", strtran(TRB->CLIFOR,"|",""), /*nIss*/, /*nIns*/, /*nIrf*/, /*lMin*/, /*lIgnrOrg*/, /*cMotBx*/)
			nValor      -= aPcc[2] + aPcc[3] + aPcc[4]

			Replace PIS			With aPcc[2]
			Replace COF			With aPcc[3]
			Replace CSL			With aPcc[4]
			Replace PISC		With nPisCalc		//Pis Calculado
			Replace COFC		With nCofCalc		//Cofins Calculado
			Replace CSLC		With nCslCalc		//Csll Calculado
			Replace IRRFC		With nIrfCalc		//Irrf Calculado
			Replace PISBC		With nPisBaseC		//Base Pis Calculado
			Replace COFBC		With nCofBaseC		//Base Cofins Calculado
			Replace CSLBC		With nCslBaseC		//Base Csll Calculado
			Replace IRRBC		With nIrfBaseC		//Base Irrf Calculado
			Replace PISBR		With nPisBaseR		//Base Pis Retido
			Replace COFBR		With nCofBaseR		//Base Cofins Retido
			Replace CSLBR		With nCslBaseR		//Base Csll Retido
			Replace IRRBR		With nIrfBaseR		//Base Irrf Retido
			Replace PCC         With aPcc[2] + aPcc[3] + aPcc[4]
		ENDIF

		Replace PAGAR With nValor
	EndIf
	If cPaisLoc == "MEX" .and. lMonedaC
		Replace VALORM	With  Round(xMoeda(nValor, TRB->MONEDA, nMoeda, dBaixa, nCasDec, aTxMoedas[TRB->MONEDA][2], aTxMoedas[nMoeda][2]), 2)
	Endif
	Replace MARCA		With cMarca
	Replace JUROS		With nJur
	Replace DESCONT	With nDesc
	Replace MULTA 	With nMulta
	MsUnlock()

Return

//-------------------------------------------------------------------
/*{Protheus.doc} Fa450Pesq
tela de pesquisa - WINDOWS

@author Pilar S Albaladejo
@since   12/03/1997
*/
//-------------------------------------------------------------------
Static Function Fa450Pesq(oMark)
	Local cAliasAnt := Alias()
	Local nRecno := 0
	Local cAlias := ""
	Local nRecTrb := 0
	Local cChave := ""
	Local cCampo := ""
	Local oDlg := NIL
	Local nOpc := 0
	Local nOpcA := 0

	DEFINE MSDIALOG oDlg FROM 90,11 TO 260,321 TITLE STR0058 PIXEL

	@ 10,13 TO 53, 142 LABEL STR0005 OF oDlg	PIXEL
	@ 24,27 RADIO nOpc PROMPT STR0029,STR0028 SIZE  60,9 OF oDlg PIXEL

	DEFINE SBUTTON FROM 60, 85 TYPE 1 ENABLE OF oDlg ACTION If(nOpc > 0, (nOpcA := 1, cAlias := If(nOpc=1,"SE1","SE2"),oDlg:End()), MsgAlert(STR0065,STR0083))
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

//-------------------------------------------------------------------
/*{Protheus.doc} Fa450OK
Funcao que verifica se Campos necess�rios estao preenchidos
na Compensacao CR - Windows

@author Mauricio Pequim Jr.
@since   01/08/1997
*/
//-------------------------------------------------------------------
Static Function Fa450OK()
	If /*Empty(cCli450) .or. Empty(cFor450) .or.*/;
			Empty(dVenIni450) .or. Empty(dVenFim450)
		Help(" ",1,"FA450OK")
		lRet := .F.
	else
		lRet := .T.
	endif
	If ExistBlock("F450valid")
		lRet    := ExecBlock("F450valid",.F.,.F.)
	Endif

Return lRet

//-------------------------------------------------------------------
/*{Protheus.doc} FA450CAN
Cancelamento de Compensa��o 

@author Mauricio Pequim Jr.
@since   20/12/1998
*/
//-------------------------------------------------------------------                
User Function FA450CAN(cAlias, cCampo, nOpcx, aCampos, aAutoCab)
	Local lPanelFin 	:= IsPanelFin()
	Local cArquivo		:= ""
	Local nTotal		:=0
	Local nHdlPrv		:=0
	Local nOpcT			:=0
	Local cTitulo 		:= STR0061
	Local lCabec 		:= .F.
	Local lPadrao		:= VerPadrao("535")
	Local cPadrao 		:= "535"
	Local nTotAbat 		:= 0
	Local nValRec 		:= 0
	Local nValPag 		:= 0
	Local lBxUnica 		:= .F.
	Local nRec450 		:= Recno()
	Local nJuros 		:= 0
	Local nDescont 		:= 0
	Local nMulta		:= 0
	Local cFornece  	:= ""
	Local cLoja     	:= ""
	local aBaixaSE3 	:= {}
	Local nDecs			:= TamSx3("E2_TXMOEDA")[2]
	Local nTaxa			:= 1
	Local nValDifC		:= 0
	Local lF450SE1C 	:= ExistBlock("F450SE1C")
	Local lF450SE2C 	:= ExistBlock("F450SE2C")
	Local nX			:= 0
	Local lAltFilial 	:= !Empty(xFilial("SE2")) .and. VerSenha(115) //permissao de editar registros de outras filiais
	Local aFiliais 		:= {}
	Local cFilCan		:= cFilAnt
	Local cFilAtu		:= cFilAnt
	Local nRecPnl		:= SE2->(Recno())
	Local aFlagCTB 		:= {}
	Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	Local nInc			:= 0
	Local aSM0			:= AdmAbreSM0()
	Local aFilCod		:= {}
	Local lF450Auto  	:= (aAutoCab <> NIL)
	Local lPccBxCP	 	:= SuperGetMv("MV_BX10925",.T.,"2") == "1"
	Local lPccBxCR	 	:= SuperGetMv("MV_BR10925",.T.,"2") == "1"
	Local aListIdCC 	:= {}
	Local nPosIdCC      := 0
	Local nListBx       := 0
	Local nPCCCtbz 		:= 0
	Local nUltCmp 		:= ""
	Local aIdentees 	:= {}
	Local a450ListBx 	:= {}
	Local aTabRecOri	:= {'',0}	// aTabRecOri[1]-> Tabela Origem ; aTabRecOri[2]-> RecNo
	Local nVa			:= 0
	Local lAtuForn  	:= SuperGetMv("MV_ATUFORN",.F.,.T.)
	Local cChaveSe1		:= ""
	Local cChaveSe2		:= ""
	Local cSinal    	:= ""
	Local cAliasFK1 	:= ""
	Local cAliasFK2 	:= ""
	Local cIdDoc    	:= ""
	Local cIdFk1    	:= ""
	Local cIdFk2		:= ""
	Local nTamFil		:= TamSx3("E1_FILIAL")[1]
	Local nTamPref		:= TamSx3("E1_PREFIXO")[1]
	Local nTamNum		:= TamSx3("E1_NUM")[1]
	Local nTamParc		:= TamSx3("E1_PARCELA")[1]
	Local nTamTipo		:= TamSx3("E1_TIPO")[1]
	Local nTamTitulo	:= nTamFil + nTamPref + nTamNum + nTamParc + nTamTipo
	Local oCbx1			:= Nil
	Local lRet			:= .T.
	Local lBxDtFin 		:= SuperGetMv("MV_BXDTFIN",,"1") == "2"
	Local aAreaSE5		:= {}

	Private cCompCan := CriaVar("E1_NUM" , .F.)
	Private cLote
	Private StrLctPad   := ""

	// Zerar variaveis para contabilizar os impostos da lei 10925.
	VALOR5 := 0
	VALOR6 := 0
	VALOR7 := 0

	// Estorna a operacao caso a matriz de rotina esteja com o conteudo 5 na posicao 4.
	__lEstorna := aRotina[nOpcx][4]==5

	// Verifica se data do movimento� menor que data limite de movimentacao no financeiro
	If lBxDtFin .and. !DtMovFin(dDatabase,.T.,"3")
		Return
	Endif

	If __lEstorna
		cTitulo := STR0085  //"Estornar"
	Endif

	//----------------------------------------------------------------
	// Verifica o numero do Lote
	//----------------------------------------------------------------
	LoteCont("FIN")

	cCompCan	:= SE2->E2_IDENTEE
	nOpcT 		:= 0

	//Abertura dos arquivos para utilizacao nas funcoes SumAbatPag e SumAbatRec
	//Se faz necessario devido ao controle de transacao nao permitir abertura de arquivos
	If Select("__SE1") == 0
		ChkFile("SE1",.F.,"__SE1")
	Endif
	If Select("__SE2") == 0
		ChkFile("SE2",.F.,"__SE2")
	Endif
	//----------------------------------------------------------------
	// Carrega funcao Pergunte
	//----------------------------------------------------------------
	SetKey (VK_F12,{|a,b| AcessaPerg("AFI450",.T.)})
	pergunte("AFI450",.F.)

	If !lF450Auto

		//----------------------------------------------------------------
		// Observacao Importante quanto as coordenadas calculadas abaixo:
		//----------------------------------------------------------------
		// A funcao DlgWidthPanel() retorna o dobro do valor da area do
		// painel, sendo assim este deve ser dividido por 2 antes da
		// subtracao e redivisao por 2 para a centralizacao.
		//----------------------------------------------------------------
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
			@ 32+nEspLin, 14+nEspLarg SAY STR0062 SIZE 49, 07 OF oPanel4 PIXEL //"Nro. Compensa��o"
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
			@ 11+nEspLin, 14+nEspLarg SAY STR0062 SIZE 49, 07 OF oPanel4 PIXEL //"Nro. Compensa��o"
		Endif

		If lAltFilial
			cFilAnt := aFilCod[oCbx1:nAt] // Atualizar a CFilAnt nesse trecho, pois n�o � atualizada acima. Necess�rio para o estorno quando t�tulo cp e cr est�o em filiais diferentes.
		EndIf

		If lPanelFin  //Chamado pelo Painel Financeiro
			ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
				{||nOpct:=1,IF(A450CalCn(cCompCan,@cAliasFK1,@cAliasFK2),oDlg:End(),nOpct:=0)},;
				{||nOpcT:=0,oDlg:End()})

		Else
			DEFINE SBUTTON FROM 10, 133 TYPE 1 ACTION (nOpct:=1,;
				IIF(NaoVazio(cCompCan) .and. A450CalCn(cCompCan,@cAliasFK1,@cAliasFK2),oDlg4:End(),nOpct:=0)) ENABLE OF oDlg4
			DEFINE SBUTTON FROM 23, 133 TYPE 2 ACTION (nOpcT:=0,oDlg4:End()) ENABLE OF oDlg4

			ACTIVATE MSDIALOG oDlg4 CENTERED
		Endif

	Else
		A450CalCn(cCompCan,@cAliasFK1,@cAliasFK2)
		nOpct := 1
	EndIf

	// Ponto de entrada que controla se o titulo sera cancelado/estornado ou nao
	If ExistBlock("F450CAES")
		nOpct := ExecBlock("F450CAES",.F.,.F.,{cCompCan,nOpct})
	EndIf

	// Integracao com o SIGAPCO para lancamento via processo PcoIniLan("000018")
	PcoIniLan("000018")

	If nOpct == 1
		If Empty(cAliasFK1) .and. Empty(cAliasFK2)
			Help(" ",1,"RECNO")

			FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
			lRet      := .F.
		Endif

		//Parametros da Funcao LockByName() 1o - Nome da Trava, 2o - usa informacoes da Empresa na chave, 3o - usa informacoes da Filial na chave
		If lRet .And. LockByName(cCompCan,.T.,.F.)
			Begin Transaction

				While (cAliasFK1)->(!Eof())
					FK1->(dbGoto((cAliasFK1)->RECNO))
					cIdDoc := FK1->FK1_IDDOC
					cIdFk1 := FK1->FK1_IDFK1

					FK7->(DbSetOrder(1))
					If FK7->(DbSeek(xFilial("FK7", FK1->FK1_FILORI)+cIdDoc))
						cChaveSe1 := FK7->FK7_CHAVE
					Endif

					cChaveSe1 := SUBSTR(strtran(cChaveSe1,"|",""),1,nTamTitulo)
					SE1->(dbSetOrder(1))

					If __lPccCC .and. lPccBxCR
						If SE1->(dbSeek(cChaveSe1))
							aBaixa	   := {}

							AADD(aBaixa, {"E1_PREFIXO", SE1->E1_PREFIXO, Nil})	// 01
							AADD(aBaixa, {"E1_NUM",     SE1->E1_NUM,     Nil})	// 02
							AADD(aBaixa, {"E1_PARCELA", SE1->E1_PARCELA, Nil})	// 03
							AADD(aBaixa, {"E1_TIPO",    SE1->E1_TIPO,    Nil})	// 04
							AADD(aBaixa, {"E1_CLIENTE", SE1->E1_CLIENTE, Nil})	// 05
							AADD(aBaixa, {"E1_LOJA",    SE1->E1_LOJA,    Nil})	// 06

							aListIdCC	:= Sel450Baixa( "VL |BA |CP "+MV_CRNEG,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,;
								SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,,@a450ListBx,.T.)

							For nX := 1 to Len(a450ListBx)
								If !Empty(a450ListBx[nX][19])
									aAdd(aIdentees,a450ListBx[nX][19])
								EndIf
							Next nX

							aSort(aIdentees)
							nPosIdCC := Len(aListIdCC[1])-TamSx3("E5_IDENTEE")[1]+1
							nX       := 1
							nListBx  := 0

							While nListBx == 0 .and. nx <= Len(aListIdCC)
								If SubStr(aListIdCC[nX], nPosIdCC,Len(aListIdCC[nX])) == cCompCan
									nListBx := nX
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

							If SuperGetMv("MV_BP10925",.T.,"1") == "1"
								If SE1->E1_SALDO <> 0
									nPCCCtbz := 0
								EndIf
							Else
								nPCCCtbz :=0
								For nX := 1 to Len(a450ListBx)
									If a450ListBx[nX][19] == cCompCan
										nPCCCtbz := a450ListBx[nX][11] + a450ListBx[nX][12] + a450ListBx[nX][13]
									EndIf
								Next nX
							EndIf

							VALOR    := FK1->FK1_VALOR + nPCCCtbz
							VLRINSTR := VALOR

							If SE1->E1_MOEDA <= 5 .And. SE1->E1_MOEDA > 1
								cVal := Str(SE1->E1_MOEDA,1)
								VALOR&cVal := Round(xMoeda(FK1->FK1_VALOR+nPCCCtbz, 1, SE1->E1_MOEDA, FK1->FK1_DATA, nDecs, SE1->E1_TXMOEDA),2)
							EndIf

							MSExecAuto({|a,b,c,d| Fina070(a,b,c,d)},aBaixa,5,.f.,nListBx)
							pergunte("AFI450",.F.)

							If lMsErroAuto
								MostraErro()
								DisarmTransaction()
								Break
							Else
								RecLock("SE1")
								SE1->E1_IDENTEE := nUltCmp
								SE1->(MsUnLock())
								SE1->(DbSetOrder(1))
							EndIf
						EndIf
					Else
						If SE1->(dbSeek(cChaveSe1))
							aBaixa		:= Sel450Baixa( "VL |BA |CP "+MV_CRNEG,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,,@a450ListBx,.T.)
							nTaxa		:= FK1->(FK1_VALOR / FK1_VLMOE2)
							dDataAnt 	:= Iif(Len(aBaixa) < 2, CtoD(""), a450ListBx[Len(aBaixa)-1,07])

							If !SE1->E1_TIPO $ MV_CRNEG+"|"+MVRECANT
								nTotAbat := SumAbatRec(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA,SE1->E1_MOEDA,"V",FK1->FK1_DATA,,,,,,,SE1->E1_FILORIG)
							EndIf

							If lExistVa //Valores Acessorios
								nVA	:= FxLoadFK6("FK1", FK1->FK1_IDFK1, "VA")[1,2]
							EndIf
							nJuros	 := FA450FK6("FK1", FK1->FK1_IDFK1, "JR")[1,2]
							nDescont := FA450FK6("FK1", FK1->FK1_IDFK1, "DC")[1,2]
							nMulta   := FA450FK6("FK1", FK1->FK1_IDFK1, "MT")[1,2]

							If cPaisLoc == "BRA"
								nValRec	 := FK1->FK1_VALOR

								If SE1->E1_MOEDA > 1
									nValRec	 := Round(xMoeda(nValRec, 1, SE1->E1_MOEDA, FK1->FK1_DATA, nDecs, SE1->E1_TXMOEDA, nTaxa),2)

									If (nJuros+nDescont+nMulta+nVa) != 0
										If nJuros != 0
											nJuros := Round(xMoeda(nJuros, 1, SE1->E1_MOEDA, FK1->FK1_DATA, nDecs, SE1->E1_TXMOEDA, nTaxa),2)
										EndIf

										If nDescont != 0
											nDescont := Round(xMoeda(nDescont, 1, SE1->E1_MOEDA, FK1->FK1_DATA, nDecs, SE1->E1_TXMOEDA, nTaxa),2)
										EndIf

										If nMulta != 0
											nMulta := Round(xMoeda(nMulta, 1, SE1->E1_MOEDA, FK1->FK1_DATA, nDecs, SE1->E1_TXMOEDA, nTaxa),2)
										EndIf

										If nVa != 0
											nVa := Round(xMoeda(nVa, 1, SE1->E1_MOEDA, FK1->FK1_DATA, nDecs, SE1->E1_TXMOEDA, nTaxa),2)
										EndIf
									EndIf
								EndIf
							Else
								nValRec		:= FK1->FK1_VLMOE2
								nJuros		:= xMoeda(nJuros,1,SE1->E1_MOEDA,FK1->FK1_DATA,nDecs,Nil,nTaxa)
								nDescont	:= xMoeda(nDescont,1,SE1->E1_MOEDA,FK1->FK1_DATA,nDecs,Nil,nTaxa)
								nMulta		:= xMoeda(nMulta,1,SE1->E1_MOEDA,FK1->FK1_DATA,nDecs,Nil,nTaxa)
								nValDifC	:= FA450FK6("FK1", FK1->FK1_IDFK1, "CM")[1,2]
							Endif

							nValRec   += (nDescont - nJuros - nMulta - nVA)
							lBxUnica  := IIf(STR(nValRec+nTotAbat+SE1->E1_SALDO,17,2) == STR(SE1->E1_VALOR,17,2),.T.,.F.)
							StrLctPad := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)

							If (ALLTRIM(SE1->E1_ORIGEM) == "FINA677") .and. !(FINVERRES(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA),SE1->E1_ORIGEM, "R"))
								Help(" " , 1 , "FAVIAGEM")
								DisarmTransaction()
								Return .F.
							Endif

							If nTotAbat > 0 .And. SE1->E1_SALDO == 0
								nRec450 := SE1->(Recno())
								nValRec += nTotAbat
								SE1->(dbSetOrder(1))

								If SE1->(dbSeek(xFilial("SE1", SE1->E1_FILORIG) + SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)))
									cTitAnt := (SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)

									While SE1->(!Eof()) .and. cTitAnt == (SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
										If !SE1->E1_TIPO $ MVABATIM
											SE1->(dbSkip())
											Loop
										Endif

										Reclock("SE1")
										SE1->E1_BAIXA   := Ctod(" /  /  ")
										SE1->E1_SALDO   := SE1->E1_VALOR
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

										//Carrega variaveis para contabilizacao dos abatimentos (impostos da lei 10925).
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

								SE1->(dbSetOrder(2))
								SE1->(dbGoto(nRec450))
							Endif

							RecLock("SE1")
							SE1->E1_SALDO   += nValRec
							SE1->E1_IDENTEE := ""
							SE1->E1_BAIXA   := dDataAnt

							If cPaisLoc == "CHI" .And. nValDifC <> 0
								SE1->E1_CAMBIO	-=	nValDifC
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

							DBSelectArea("FK1")

							//Valores Acessorios
							If lExistFKD
								FAtuFKDBx(.T.,"R")
							EndIf

							If (ALLTRIM(SE1->E1_ORIGEM) == "FINA677")
								FINATURES(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA),.F.,SE1->E1_ORIGEM,"R")
							Endif

							//Atualiza o status do titulo no SERASA
							If cPaisLoc == "BRA"
								cChaveTit := xFilial("SE1", SE1->E1_FILORIG)+"|"+SE1->E1_PREFIXO+"|"+SE1->E1_NUM+"|"+SE1->E1_PARCELA+"|"+SE1->E1_TIPO+"|"+SE1->E1_CLIENTE+"|"+SE1->E1_LOJA
								cChaveFK7 := FINGRVFK7("SE1", cChaveTit)
								F770BxRen("3", "", cChaveFK7)
							Endif

							//Ponto de entrada para gravacoes complementares
							If lF450SE1C
								ExecBlock("F450SE1C",.F.,.F.)
							Endif

							//Inicializa variaveis para contabilizacao
							VALOR    := FK1->FK1_VALOR
							VLRINSTR := VALOR

							If SE1->E1_MOEDA <= 5 .And. SE1->E1_MOEDA > 1
								cVal := Str(SE1->E1_MOEDA,1)

								If cPaisLoc == "BRA"
									VALOR&cVal := Round(xMoeda(FK1->FK1_VALOR, 1, SE1->E1_MOEDA, FK1->FK1_DATA, nDecs, SE1->E1_TXMOEDA),2)
								Else
									VALOR&cVal := FK1->FK1_VLMOE2
								Endif
							EndIf

							SE5->(DbSetOrder(21))
							If SE5->(DbSeek(xFilial("SE5")+cIdFk1))

								If SA1->(dbSeek(xFilial("SA1", SE1->E1_FILORIG)+SE1->E1_CLIENTE+SE1->E1_LOJA))
									cSinal := "+"

									IF SE5->E5_RECPAG == "R" .And. SE5->E5_TIPO $ MV_CPNEG+"/"+MVPAGANT  .Or.  SE5->E5_RECPAG == "P" .And. SE5->E5_TIPO $ MV_CRNEG+"/"+MVRECANT
										cSinal := "-"
									EndIf

									AtuSalDup(cSinal, nValRec, SE1->E1_MOEDA, SE1->E1_TIPO, Nil, SE1->E1_EMISSAO, nDecs, SE1->E1_TXMOEDA)
								EndIf

								DBSelectArea("SE5")

								If SE5->E5_TIPODOC $ "BA/DC/MT/JR"
									aadd(aBaixaSE3, {SE5->E5_MOTBX , SE5->E5_SEQ , SE5->(Recno())})
								EndIf

								//Gera os lan�amentos de Estorno/Cancelamento SE5
								If !Fa450GrvEst(lUsaFlag, __lEstorna, @aFlagCTB)
									lRet := .F.
									DisarmTransaction()
									Exit
								Endif
							EndIf
						EndIf
					Endif

					//Contabiliza��o
					aTabRecOri	:= {'SE5', Recno()}
					If !lCabec .and. lPadrao
						nHdlPrv := HeadProva( cLote, "FINA450", Substr( cUsuario, 7, 6 ), @cArquivo )
						lCabec := .t.
					Endif

					If lCabec .and. lPadrao .and. (VALOR+VALOR2+VALOR3+VALOR4+VALOR5) > 0
						SE2->(dbGoTo(0))
						nTotal += DetProva(nHdlPrv,cPadrao,"FINA450",cLote,/*nLinha*/,/*lExecuta*/,/*cCriterio*/,/*lRateio*/,/*cChaveBusca*/,/*aCT5*/,.F.,@aFlagCTB,aTabRecOri,/*aDadosProva*/)
					Endif

					//Integracao com o SIGAPCO para lancamento via processo PCODetLan("000018","01","FINA450",.T.)
					PCODetLan("000018","02","FINA450",.T.)

					(cAliasFK1)->(DbSkip())
				EndDo

				While (cAliasFK2)->(!Eof())
					FK2->(dbGoto((cAliasFK2)->RECNO))
					cIdDoc := FK2->FK2_IDDOC
					cIdFk2 := FK2->FK2_IDFK2

					FK7->(DbSetOrder(1))
					If FK7->(DbSeek(xFilial("FK7", FK2->FK2_FILORI)+cIdDoc))
						cChaveSe2 := FK7->FK7_CHAVE
					Endif
					cChaveSe2 := strtran(cChaveSe2,"|","")

					If SE2->(dbSeek(cChaveSe2))

						If __lPccCC .and. lPccBxCP

							aBaixa	   := {}

							AADD(aBaixa, {"E2_PREFIXO", SE2->E2_PREFIXO, Nil})	// 01
							AADD(aBaixa, {"E2_NUM",     SE2->E2_NUM,     Nil})	// 02
							AADD(aBaixa, {"E2_PARCELA", SE2->E2_PARCELA, Nil})	// 03
							AADD(aBaixa, {"E2_TIPO",    SE2->E2_TIPO,    Nil})	// 04
							AADD(aBaixa, {"E2_FORNECE", SE2->E2_FORNECE, Nil})	// 05
							AADD(aBaixa, {"E2_LOJA",    SE2->E2_LOJA,    Nil})	// 06

							aListIdCC := Sel450Baixa("VL |BA |CP ",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
								SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,@nPCCCtbz,@a450ListBx)

							For nX := 1 to Len(a450ListBx)
								If !Empty(a450ListBx[nX][19])
									aAdd(aIdentees,a450ListBx[nX][19])
								EndIf
							Next nX

							aSort(aIdentees)
							nPosIdCC := Len(aListIdCC[1])-TamSx3("E5_IDENTEE")[1]+1
							nX       := 1
							nListBx  := 0

							While nListBx == 0 .and. nx <= Len(aListIdCC)
								If SubStr(aListIdCC[nX], nPosIdCC,Len(aListIdCC[nX])) == cCompCan
									nListBx := nX
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

							//se tem impostos retidos, s� pode cancelar a ultima baixa.
							If aIdentees[Len(aIdentees)] <> cCompCan .and. (SE2->E2_VRETPIS <> 0 .or. SE2->E2_VRETCOF <> 0 .or. SE2->E2_VRETCSL <> 0)
								Aviso(STR0083,STR0093,{STR0094})
								DisarmTransaction()
								Break
								Exit
							EndIf

							If SuperGetMv("MV_BP10925",.T.,"1") == "1"
								If SE2->E2_SALDO <> 0
									nPCCCtbz := 0
								EndIf
							Else
								nPCCCtbz :=0

								For nX := 1 to Len(a450ListBx)
									If a450ListBx[nX][19] == cCompCan
										nPCCCtbz := a450ListBx[nX][11] + a450ListBx[nX][12] + a450ListBx[nX][13]
									EndIf
								Next nX
							EndIf

							VALOR    := FK2->FK2_VALOR + nPCCCtbz
							VLRINSTR := VALOR

							If SE2->E2_MOEDA <= 5 .And. SE2->E2_MOEDA > 1
								cVal := Str(SE2->E2_MOEDA,1)
								VALOR&cVal := Round(xMoeda(FK2->FK2_VALOR+nPCCCtbz, 1, SE2->E2_MOEDA, FK2->FK2_DATA, nDecs, SE2->E2_TXMOEDA),2)
							EndIf

							MSExecAuto({|a,b,c,d,e,f| Fina080(a,b,c,d,e,f)},aBaixa,5,.f.,nListBx,,.F.)
							pergunte("AFI450",.F.)

							//Restaura a variavel de contabiliza��o que � zerada pelo FINA080
							VALOR := VLRINSTR

							If lMsErroAuto
								MostraErro()
								DisarmTransaction()
								Break
							Else

								If Empty(SE2->E2_NUM)
									dbSelectArea("SE2")
									SE2->(dbSetOrder(1))
									//SE2->(Dbseek(RTrim(Strtran(TRB->CHAVE,"**",""))))
									If !SE2->(Dbseek(xFilial("SE2")+(StrTran(Strtran(TRB->(TITULO+CLIFOR),"|",""),"*",""))))//!SE2->(Dbseek(xFilial("SE2")+(StrTran(Strtran(TRB->(TITULO+CLIFOR),"/",""),"*",""))))
										//If !SE2->(Dbseek(xFilial("SE2")+(StrTran(Strtran(TRB->(AllTrim(CHAVE)+AllTrim(CLIFOR)),"/",""),"*",""))))
											ConOut("Titulo n�o encontrado:" + TRB->TITULO)
										//EndIf
									EndIf
								EndIf

								RecLock("SE2")
								SE2->E2_IDENTEE := nUltCmp
								SE2->(MsUnLock())
								SE2->(DbSetOrder(1))

								If __lEstorna
									RecLock("SE5")
									SE5->E5_SITUACA := "X"
									SE5->(MsUnlock())

									aAreaSE5 := SE5->(GetArea())

									SE5->(DbSetOrder(21))
									If SE5->(dbSeek(xFilial("SE5")+cIdFk2+"BA"))
										RecLock("SE5")
										SE5->E5_SITUACA := "X"
										SE5->(MsUnlock())
									ENDIF

									RestArea(aAreaSE5)
								Endif

							EndIf

						Else

							nTaxa	   := FK2->(FK2_VALOR / FK2_VLMOE2)

							If !SE2->E2_TIPO $ MVPAGANT+"|"+MV_CPNEG
								nTotAbat := SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_MOEDA,"V",FK2->FK2_DATA,SE2->E2_LOJA,,,,,SE2->E2_TIPO)
							EndIf

							//Valores Acessorios
							If lExistVa
								nVA	:= FxLoadFK6("FK2",FK2->FK2_IDFK2,"VA")[1,2]
							EndIf
							nJuros   := FA450FK6("FK2",FK2->FK2_IDFK2,"JR")[1,2]
							nDescont := FA450FK6("FK2",FK2->FK2_IDFK2,"DC")[1,2]
							nMulta	 := FA450FK6("FK2",FK2->FK2_IDFK2,"MT")[1,2]

							If cPaisLoc == "BRA"
								nValPag  := FK2->FK2_VALOR

								If SE2->E2_MOEDA > 1
									nValPag := Round(xMoeda( nValPag, 1, SE2->E2_MOEDA, FK2->FK2_DATA, nDecs, SE2->E2_TXMOEDA, nTaxa),2)

									If (nJuros+nDescont+nMulta+nVa) != 0
										If nJuros != 0
											nJuros := Round(xMoeda(nJuros, 1, SE2->E2_MOEDA, FK2->FK2_DATA, nDecs, SE2->E2_TXMOEDA, nTaxa),2)
										EndIf

										If nDescont != 0
											nDescont := Round(xMoeda(nDescont, 1, SE2->E2_MOEDA, FK2->FK2_DATA, nDecs, SE2->E2_TXMOEDA, nTaxa),2)
										EndIf

										If nMulta != 0
											nMulta := Round(xMoeda(nMulta, 1, SE2->E2_MOEDA, FK2->FK2_DATA, nDecs, SE2->E2_TXMOEDA, nTaxa),2)
										EndIf

										If nVa != 0
											nVa := Round(xMoeda(nVa, 1, SE1->E1_MOEDA, FK2->FK2_DATA, nDecs, SE2->E2_TXMOEDA, nTaxa),2)
										EndIf
									EndIf
								EndIf
							Else
								nValPag		:= FK2->FK2_VLMOE2
								nJuros		:= xMoeda(nJuros,1,SE2->E2_MOEDA,FK2->FK2_DATA,nDecs,Nil,nTaxa)
								nDescont	:= xMoeda(nDescont,1,SE2->E2_MOEDA,FK2->FK2_DATA,nDecs,Nil,nTaxa)
								nMulta		:= xMoeda(nMulta,1,SE2->E2_MOEDA,FK2->FK2_DATA,nDecs,Nil,nTaxa)
								nValDifC	:= FA450FK6("FK2", FK2->FK2_IDFK2, "CM")[1,2]
							Endif

							nValPag   += (nDescont - nJuros - nMulta - nVa)
							cFornece  := SE2->E2_FORNECE
							cLoja	  := SE2->E2_LOJA
							StrLctPad := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
							lBxUnica  := IIf(STR(nValPag+nTotAbat+SE2->E2_SALDO,17,2) == STR(SE2->E2_VALOR,17,2),.T.,.F.)

							If (ALLTRIM(SE2->E2_ORIGEM) $ "FINA667|FINA677") .and. !(FINVERRES(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),SE2->E2_ORIGEM, "P"))
								Help(" " , 1 , "FAVIAGEM")
								DisarmTransaction()
								Return .F.
							Endif

							If lBxUnica .And. nTotAbat > 0
								nRec450 := SE2->(Recno())
								nValPag += nTotAbat

								If SE2->(dbSeek(xFilial("SE2", SE2->E2_FILORIG)+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA))
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

										Reclock("SE2")
										SE2->E2_BAIXA	:= Ctod(" /  /  ")
										SE2->E2_SALDO	:= SE2->E2_VALOR
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

								SE2->(dbSetOrder(1))
								SE2->(dbGoto(nRec450))
							Endif

							If !lBxUnica
								nUltCmp := GetIdent(xFilial("SE2",SE5->E5_FILORIG),SE2->E2_IDENTEE)
							EndIf

							RecLock("SE2")
							SE2->E2_SALDO   += nValPag
							SE2->E2_IDENTEE := nUltCmp

							If cPaisLoc == "CHI" .And. nValDifC <> 0
								SE2->E2_CAMBIO -=	nValDifC
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

							DBSelectArea("FK2")

							If lF450SE2C
								ExecBlock("F450SE2C",.F.,.F.)
							Endif

							//Valores Acessorios
							If lExistFKD
								FAtuFKDBx(.T.,"P")
							EndIf

							If (ALLTRIM(SE2->E2_ORIGEM) $ "FINA667|FINA677")
								FINATURES(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),.F., SE2->E2_ORIGEM,"P")
							Endif

							VALOR    := FK2->FK2_VALOR
							VLRINSTR := VALOR

							If SE2->E2_MOEDA <= 5 .And. SE2->E2_MOEDA > 1
								cVal := Str(SE2->E2_MOEDA,1)

								If cPaisLoc == "BRA"
									VALOR&cVal := Round(xMoeda(FK2->FK2_VALOR,1,SE2->E2_MOEDA,FK2->FK2_DATA, nDecs, SE2->E2_TXMOEDA),2)
								Else
									VALOR&cVal := FK2->FK2_VLMOE2
								Endif
							EndIf

							SE5->(DbSetOrder(21))
							If SE5->(dbSeek(xFilial("SE5")+cIdFk2))

								If lAtuForn .And. SA2->(dbSeek(xFilial("SA2", SE2->E2_FILORIG)+SE2->E2_FORNECE+SE2->E2_LOJA))
									RecLock("SA2")
									IF SE5->E5_RECPAG == "R" .And. SE5->E5_TIPO $ MV_CPNEG+"/"+MVPAGANT  .Or.  SE5->E5_RECPAG == "P" .And. SE5->E5_TIPO $ MV_CRNEG+"/"+MVRECANT
										SA2->A2_SALDUP -= nValPag
										SA2->A2_SALDUPM -= xMoeda(nValPag, 1, Val(GetMv("MV_MCUSTO")), SE2->E2_EMISSAO, nDecs, SE2->E2_TXMOEDA)
									Else
										SA2->A2_SALDUP += nValPag
										SA2->A2_SALDUPM += xMoeda(nValPag, 1, Val(GetMv("MV_MCUSTO")), SE2->E2_EMISSAO, nDecs, SE2->E2_TXMOEDA)
									EndIf
									SA2->(MsUnLock())
								Endif
							EndIf

							//Gera os lan�amentos de Estorno/Cancelamento SE5
							If !Fa450GrvEst(lUsaFlag, __lEstorna, @aFlagCTB)
								lRet := .F.
								DisarmTransaction()
								Exit
							Endif
						Endif

						//Contabiliza��o
						aTabRecOri := {'SE5', SE5->(Recno())}
						If !lCabec .and. lPadrao
							nHdlPrv := HeadProva( cLote, "FINA450", Substr( cUsuario, 7, 6 ), @cArquivo )
							lCabec := .t.
						Endif

						If lCabec .and. lPadrao .and. (VALOR+VALOR2+VALOR3+VALOR4+VALOR5) > 0
							SE1->(dbGoto(0))
							nTotal += DetProva(nHdlPrv,cPadrao,"FINA450",cLote,/*nLinha*/,/*lExecuta*/,/*cCriterio*/,/*lRateio*/,/*cChaveBusca*/,/*aCT5*/,.F.,@aFlagCTB,aTabRecOri,/*aDadosProva*/)
						Endif

						//Integracao com o SIGAPCO para lancamento via processo PCODetLan("000018","01","FINA450",.T.)
						PCODetLan("000018","01","FINA450",.T.)

					Endif
					(cAliasFK2)->(DbSkip())
				EndDo

				IF lRet .and. lPadrao .and. lCabec .and. nTotal > 0
					RodaProva(nHdlPrv, nTotal)
					//Envia para Lancamento Contabil
					cA100Incl(cArquivo,nHdlPrv,3,cLote, mv_par01 == 1,mv_par02 == 1,/*cOnLine*/,/*dData*/,/*dReproc*/,@aFlagCTB,/*aDadosProva*/,/*aDiario*/)
					aFlagCTB := {}
				Endif

				UnLockByName(cCompCan,.T.,.F.)
			End Transaction
		Elseif lRet
			MsgAlert(STR0084, STR0083) // "Existe outro usu�rio cancelando esta compensa��o. N�o � permitido o cancelamento da mesma compensa��o por dois usu�rios ao mesmo tempo." ## "Aten��o"
		Endif

		If !Empty(cAliasFK1)
			(cAliasFK1)->(DbCloseArea())
			cAliasFK1 := " "
		Endif

		If !Empty(cAliasFK2)
			(cAliasFK2)->(DbCloseArea())
			cAliasFK2 := " "
		Endif

		FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()

	Endif

	__lEstorna := .F.

	If lRet
		Fa440DeleB(aBaixaSE3,.F.,.F.,"FINA070")
		cFilAnt := cFilAtu
		PcoFinLan("000018")
		SE2->(MSGOTO(nRecPnl))
	EndIf

Return .T.

/*/{Protheus.doc} F450VerEst
	Fun��o responsavel por retornar se a opera��o selecionada � de estorno
	ou cancelamento, quando a rotina utiliza execauto
	@type  Function
	@author Vitor Duca
	@since 21/09/2021
	@version 1.0
	@return lEstorno, Logical, Indica se a opera��o � um estorno
/*/
Static Function F450VerEst()
Return __lEstorna

//-------------------------------------------------------------------
/*{Protheus.doc} A450CALCN

Fun��o para montar as tabelas temporarias da FK1 e FK2

@param cCompCan - Identificador da compensa��o 
@param cAliasFK1 - Alias da Tabela FK1
@param cAliasFK2 - Alias da Tabela FK2

@author Vitor Duca
@version 12
@since  18/03/2019
*/
//-------------------------------------------------------------------
Static Function A450CalCn(cCompCan as Character,cAliasFK1 as Character,cAliasFK2 as Character)
	Local cQuery       as Character
	Local lRet		   as Logical
	Local aArea		   as Array

	//inicializa��o das variaveis
	lRet	   := .T.
	aArea      := GetArea()

	While .T.
		cQuery     := ""
		cAliasFK1  := "FK1CEC"
		cAliasFK2  := "FK2CEC"
		//-------------------------------
		// Seleciona movimentos na FK1
		//-------------------------------
		cQuery := "SELECT R_E_C_N_O_ RECNO"
		cQuery += " FROM "+RetSqlName("FK1")+" FK1"
		cQuery += " WHERE FK1.FK1_FILIAL = '"+xFilial("FK1")+"'"
		cQuery += " AND FK1.FK1_IDPROC = '"+cCompCan+"'"
		cQuery += " AND FK1_DATA <= '" + DTOS(dDatabase) + "'"
		cQuery += " AND FK1_TPDOC NOT IN ('ES')"
		cQuery += " AND 0 = ( SELECT COUNT(*) FROM "+RetSqlName("FK1") + " EST"
		cQuery += " WHERE  EST.FK1_IDPROC = FK1.FK1_IDPROC "
		cQuery += " AND  EST.FK1_SEQ = FK1.FK1_SEQ "
		cQuery += " AND  EST.FK1_TPDOC = 'ES' AND EST.D_E_L_E_T_ = ' ')"
		cQuery += " AND FK1.D_E_L_E_T_ = ' '"

		cQuery 	  := ChangeQuery(cQuery)
		MpSysOpenQuery(cQuery,cAliasFK1)

		//-------------------------------
		// Seleciona movimentos na FK2
		//-------------------------------
		cQuery := "SELECT R_E_C_N_O_ RECNO"
		cQuery += " FROM "+RetSqlName("FK2")+" FK2"
		cQuery += " WHERE FK2.FK2_FILIAL = '"+xFilial("FK2")+"'"
		cQuery += " AND FK2.FK2_IDPROC = '"+cCompCan+"'"
		cQuery += " AND FK2_DATA <= '" + DTOS(dDatabase) + "'"
		cQuery += " AND FK2_TPDOC NOT IN ('ES')"
		cQuery += " AND 0 = ( SELECT COUNT(*) FROM "+RetSqlName("FK2") + " EST"
		cQuery += " WHERE  EST.FK2_IDPROC = FK2.FK2_IDPROC "
		cQuery += " AND  EST.FK2_SEQ = FK2.FK2_SEQ "
		cQuery += " AND  EST.FK2_TPDOC = 'ES' AND EST.D_E_L_E_T_ = ' ')"
		cQuery += " AND FK2.D_E_L_E_T_ = ' '"

		cQuery 	  := ChangeQuery(cQuery)
		MpSysOpenQuery(cQuery,cAliasFK2)

		If (cAliasFK2)->(EOF()) .AND. (cAliasFK1)->(EOF())
			(cAliasFK2)->(DbCloseArea())
			cAliasFK2 := ""
			(cAliasFK1)->(DbCloseArea())
			cAliasFK1 := ""
			Exit
		ElseIf (cAliasFK1)->(!EOF()) .AND. (cAliasFK2)->(EOF())
			// Ajuste de base historica para o campo FK2_IDPROC
			A450RecFk2(cCompCan,@cAliasFK2,@cAliasFK1)
			Loop
		Endif
		Exit
	EndDo

	RestArea(aArea)

Return .T.

//------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Fa450SetMo
Atualiza os valores na tela de Edicao da Enchoicebar 

@author Fernando Machima
@since  09/03/2001
@version 12.1.7
/*/
//------------------------------------------------------------------------------------------------
Static Function Fa450SetMo()
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

//------------------------------------------------------------------------------------------------
/*/{Protheus.doc} F450AtuVal
Atualiza os valores na tela de Edicao da Enchoicebar 

@author Mauricio Pequim Jr
@since  23/09/2003
@version 12.1.7
/*/
//------------------------------------------------------------------------------------------------
Static Function F450AtuVal(nValor,oValor,nJurAtu,nOldJur,nDesAtu,nOldDes,nMulAtu,nOldMul,nOpera,nValVA)
	Local lRet := .T.

	If nJurAtu < 0
		lRet := .F.
	Endif
	If lRet .and. nMulAtu < 0
		lRet := .F.
	Endif
	If lRet .and. nDesAtu < 0
		lRet := .F.
	Endif
	If lRet .and. nValor + nJurAtu + nMulAtu - nDesAtu - nOldJur - nOldMul + nOldDes + nValVA <= 0
		lRet := .F.
	Endif

	If lRet .AND. !Empty(Alltrim(ReadVar()))
		nValor  := nValor + nJurAtu + nMulAtu - nDesAtu - nOldJur - nOldMul + nOldDes + nValVA
		nOldJur := nJurAtu
		nOldMul := nMulAtu
		nOldDes := nDesAtu
	Endif
	oValor:Refresh()

Return lRet

//------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Fa450GrvEst
Grava o movimento de estorno da baixa por CEC

lUsaFlag		Usa Flag CTB
lEstorno		Identifica se � um processo de estorno (.T.) ou cancelamento (.F.)
aFlagCTB 		Array com o R_E_C_N_O_ que sera contabilizado  

@author Mauricio Pequim Jr
@since  06/01/2016
@version 12.1.7
/*/
//------------------------------------------------------------------------------------------------
Static Function Fa450GrvEst(lUsaFlag,lEstorno,aFlagCTB)
	Local aAreaAnt	:= {}
	Local oModelMov	:= NIL
	Local cLog		:= ""
	Local lRet		:= .T.
	Local cAliasFK	:= ""
	Local lTitCred	:= .F.
	Local cChaveSe5 := SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
	Local cTipodoc  := "DC|MT|JR|CM|VA"
	Local cCamposE5	:= ""

	Local aOrdem :={}
	Local oOrdem

	Default lEstorno := .F.

	lTitCred := SE5->E5_TIPO $ MVRECANT+"/"+MVPAGANT+"/"+MV_CRNEG+"/"+MV_CPNEG

	If lTitCred
		cAliasFK := if(SE5->E5_RECPAG= "R","FK2", "FK1")
	Else
		cAliasFK := if(SE5->E5_RECPAG= "R","FK1", "FK2")
	Endif

	If AllTrim( SE5->E5_TABORI ) == cAliasFK
		aAreaAnt := GetArea()
		dbSelectArea(cAliasFK)
		(cAliasFK)->(DbSetOrder(1))

		If MsSeek( xFilial(cAliasFK) + SE5->E5_IDORIG )
			If lTitCred
				oModelMov := FWLoadModel(if(SE5->E5_RECPAG= "R","FINM020","FINM010"))
			Else
				oModelMov := FWLoadModel(if(SE5->E5_RECPAG= "R","FINM010","FINM020"))
			EndIf

			oModelMov:SetOperation( MODEL_OPERATION_UPDATE )
			oModelMov:Activate()
			oSubFKA := oModelMov:GetModel( "FKADETAIL" )

			If oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )
				If lEstorno
					cCamposE5 := "{ {'E5_SITUACA', 'X'} }"
					oModelMov:SetValue("MASTER", "E5_CAMPOS", cCamposE5)
				Endif

				oModelMov:SetValue('MASTER','HISTMOV', STR0086)
				oModelMov:SetValue("MASTER", "E5_GRV", .T. )
				oModelMov:SetValue("MASTER", "E5_OPERACAO", If(lEstorno, 2, 1))

				If oModelMov:VldData()
					oModelMov:CommitData()
					SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))
				Else
					lRet := .F.
					cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
					cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
					cLog += cValToChar(oModelMov:GetErrorMessage()[6])

					If !lF450Auto
						Help( ,,"M450SITX",,cLog, 1, 0 )
					Endif
				Endif
			Endif

			oModelMov:DeActivate()
			oModelMov:Destroy()
			oModelMov:= NIL

			If lEstorno .and. lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
				aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
			EndIf
		Endif

		//Limpar o n�mero da compensa��o nos valores acessorios (DC|MT|JR|CM|VA)
		SE5->(dbSetOrder(7))
		If SE5->(dbSeek(cChaveSE5))
			While !SE5->(EOF()) .AND. cChaveSe5 == SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
				If SE5->E5_TIPODOC $ cTipodoc
					RecLock("SE5")
					If lEstorno
						Replace SE5->E5_SITUACA With "X"
					Else
						Replace SE5->E5_SITUACA With "C"
					Endif
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
					Else
						Replace SE5->E5_LA With "S"
					EndIf
					SE5->(MsUnLock())
				Endif
				SE5->(dbSkip())
			EndDo
		Endif

		RestArea(aAreaAnt)
	Endif

Return lRet

//-------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Utilizacao de menu Funcional

@Sample 
Parametros do array a Rotina:
1. Nome a aparecer no cabecalho                          
2. Nome da Rotina associada                                 
3. Reservado                                                
4. Tipo de Transa��o a ser efetuada:                       
	1 - Pesquisa e Posiciona em um Banco de Dados   	
	2 - Simplesmente Mostra os Campos                     
	3 - Inclui registros no Bancos de Dados              
	4 - Altera o registro corrente                          
	5 - Remove o registro corrente do Banco de Dados      
5. Nivel de acesso                                         
6. Habilita Menu Funcional

@author Ana Paula N. Silva
@since  27/11/2006
@version 12
@Return Array com opcoes da rotina.
/*/
//-------------------------------------------------------------------------    
Static Function MenuDef()
	Local aRotina := {	{ STR0001, "AxPesqui"   , 0 , 1,,.F.} ,;	//"Pesquisar"
	{ STR0002, 	"AxVisual"  , 0 , 2} ,;			//"Visualizar"
	{ STR0003, 	"U_Fa450CMP"  , 0 , 3} ,;			//"Compensar"
	{ STR0060, 	"U_Fa450Can"  , 0 , 6} ,;
		{ STR0085, 	"U_Fa450Can"  , 0 , 5} ,; 	 	// Estornar
	{ STR0089,	"U_Fa450Leg"	, 0	, 7,,.F.}}		// "Legenda"

	// Ponto de entrada para inclusao de uma nova op��o no menu
	If ExistBlock("FA450BUT")
		aRotina := Execblock("FA450BUT",.F.,.F.,{aRotina})
	Endif

Return(aRotina)

//-------------------------------------------------------------------------
/*/{Protheus.doc} FinA450T
Chamada semi-automatica utilizado pelo gestor financeiro  

@author Marcelo Celi Marques
@since  26/03/2008
@version 12
/*/
//-------------------------------------------------------------------------     
Static Function FinA450T(aParam)
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

//-------------------------------------------------------------------------
/*/{Protheus.doc} Fa450MotBx
Funcao criar automaticamente o motivo de baixa CEC na tabela Mot baixas   

@author Marcelo Celi Marques
@since  29/04/2009
@version 12
/*/
//-------------------------------------------------------------------------                   
Static Function Fa450MotBx(cMot,cNomMot, cConfMot)
	Local lMotBxEsp	:= .F.
	Local aMotbx 	:= ReadMotBx(@lMotBxEsp)
	Local nHdlMot	:= 0
	Local I			:= 0
	Local cFile 	:= "SIGAADV.MOT"
	Local nTamLn	:= 19

	If lMotBxEsp
		nTamLn	:= 20
		cConfMot	:= cConfMot + "N"
	EndIf
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

		For I:= 0 to  nTamArq step nTamLn // Processo para ir para o final do arquivo
			xBuffer:=Space(nTamLn)
			FREAD(nHdlMot,@xBuffer,nTamLn)
		Next

		fWrite(nHdlMot,cMot+cNomMot+cConfMot+chr(13)+chr(10))
		fClose(nHdlMot)
	EndIf
Return

//-------------------------------------------------------------------------
/*/{Protheus.doc} AdmAbreSM0
Retorna um array com as informacoes das filias das empresas

@author Orizio
@since  22/01/2010
@version 12
/*/
//-------------------------------------------------------------------------
Static Function AdmAbreSM0()
	Local aArea		:= SM0->( GetArea() )
	Local aRetSM0	:= {}

	aRetSM0	:= FWLoadSM0()

	RestArea( aArea )

Return aRetSM0

//-------------------------------------------------------------------------
/*/{Protheus.doc} Fa450Leg
Legenda da rotina, referentes a situa��o dos titulos

@author Pablo Gollan Carreras
@since  16/04/2010
@version 12
/*/
//-------------------------------------------------------------------------
Static Function Fa450Leg(nReg)
	Local lCtLiPag := SuperGetMv("MV_CTLIPAG",.F.,.F.)
	Local uRetorno		:= .T.
	Local aLegen		:= {{"ENABLE",STR0090},{"DISABLE",STR0091},{"BR_AZUL",STR0092},{"BR_AMARELO",STR0112}}

	If Empty(nReg)
		uRetorno := {}
		IF lCtLiPag
			aAdd(uRetorno, {' Empty(E2_DATALIB) .AND. (SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE) > GetMV("MV_VLMINPG") .AND. E2_SALDO > 0 ', aLegen[4][1]})// Titulo Aguardando Libera��o
		Endif
		aAdd(uRetorno, {'E2_SALDO =  E2_VALOR .AND. E2_ACRESC = E2_SDACRES', aLegen[1][1]}) // Titulo nao Compensado
		aAdd(uRetorno, {'E2_SALDO =  0', aLegen[2][1]})			// Titulo Compensado Totalmente
		aAdd(uRetorno, {'E2_SALDO <> 0', aLegen[3][1]})			// Titulo Compensado Parcialmente
	Else
		BrwLegenda(cCadastro,STR0089,aLegen)
	Endif

Return(uRetorno)

//-------------------------------------------------------------------------
/*/{Protheus.doc} Sel450Baixa
Traz lista de Baixas para serem canceladas

@author Adrianne Furtado
@since  06/07/2010
@version 12
/*/
//-------------------------------------------------------------------------
Static Function Sel450Baixa(cTipoDoc,cPrefixo, cNum, cParcela,cTipo,cFornece,cLoja, nTotPCC, a450ListBx,lRec, nTotIRF)
	Local __k        := 0
	Local cTipoBaixa := ""
	Local aBaixa     := {}
	Local cNumero    := ""
	Local aAreaSE5   := {}
	Local cIdDoc	 := ""
	Local cChaveTit	 := ""
	Local cAliasTit	 := ""

	Default nTotPCC := 0
	Default a450ListBx := {}
	Default lRec := .F.
	Default nTotIRF := 0

	aAreaSE5 := SE5->(GetArea())

	nTotPCC := 0
	nTotIRF := 0
	SE5->(dbSetOrder(2))

	FOR __k := 1 TO Len(cTipoDoc) Step 4
		cTipoBaixa := AllTrim(Substr(cTipodoc,__k,3 ) )
		SE5->(dbSeek(cFilial+cTipoBaixa+cPrefixo+cNum+cParcela+cTipo))

		While !SE5->(Eof()) .and. SE5->E5_FILIAL==cFilial .and. ;
				SE5->(E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)==cTipoBaixa+cPrefixo+cNum+cParcela+cTipo

			If SE5->E5_MOTBX $ "FAT|DSD" .or. SE5->E5_SITUACA == "C"
				SE5->(dbSkip())
				Loop
			Endif

			If SE5->E5_MOTBX $ "PCC|IRF"
				If SE5->E5_MOTBX == "PCC"
					nTotPCC += SE5->E5_VALOR
				Else
					nTotIrf += SE5->E5_VALOR
				Endif
				SE5->(dbSkip())
				Loop
			Endif

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
				SE5->(dbSkip())
				loop
			EndIf

			If lRec
				cAliasTit := "SE1"
				cChaveTit := xFilial(cAliasTit, SE1->E1_FILORIG)+"|"+SE1->E1_PREFIXO+"|"+SE1->E1_NUM+"|"+SE1->E1_PARCELA+"|"+SE1->E1_TIPO+"|"+SE1->E1_CLIENTE+"|"+SE1->E1_LOJA
				cIdDoc := FINGRVFK7(cAliasTit, cChaveTit)
			Else
				cAliasTit := "SE2"
				cChaveTit := xFilial(cAliasTit, SE2->E2_FILORIG)+"|"+SE2->E2_PREFIXO+"|"+SE2->E2_NUM+"|"+SE2->E2_PARCELA+"|"+SE2->E2_TIPO+"|"+SE2->E2_FORNECE+"|"+SE2->E2_LOJA
				cIdDoc := FINGRVFK7(cAliasTit, cChaveTit)
			Endif

			If F450BxCanc(cIdDoc,cAliasTit,SE5->E5_SEQ)
				SE5->(dbSkip())
				Loop
			Endif

			cNumero := SE5->E5_NUMERO+Iif(Len(SE5->E5_NUMERO)==TamSx3("E5_NUMERO")[1],Space(Len(SE5->E5_NUMERO)),"")

			If !lRec
				nTotPCC += If(SE5->(E5_PRETCSL) == " ",SE5->(E5_VRETCSL),0)
				nTotPCC += If(SE5->(E5_PRETPIS) == " ",SE5->(E5_VRETPIS),0)
				nTotPCC += If(SE5->(E5_PRETCOF) == " ",SE5->(E5_VRETCOF),0)
				nTotIRF += If(SE5->(E5_PRETIRF) == " ",SE5->(E5_VRETIRF),0)
			EndIf

			Aadd(aBaixa,SE5->E5_PREFIXO+" "+cNumero       +;
				" "+SE5->E5_PARCELA+" "+SE5->E5_TIPO+" "+SE5->E5_CLIFOR +;
				" "+SE5->E5_LOJA+" "+Dtoc(SE5->E5_DATA)        +;
				" "+Transf(SE5->E5_VALOR,"@E 9999,999,999.99")+"   "+SE5->E5_SEQ  + SE5->E5_IDENTEE)

			Aadd(a450ListBx,{	SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO	,;
				SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_DATA				,;
				SE5->E5_VALOR,SE5->E5_SEQ,SE5->E5_DTDISPO				,;
				SE5->E5_VRETPIS,SE5->E5_VRETCOF,SE5->E5_VRETCSL,;
				SE5->E5_PRETPIS,SE5->E5_PRETCOF,SE5->E5_PRETCSL,;
				SE5->E5_TIPODOC,SE5->E5_MOTBX  ,SE5->E5_IDENTEE,;
				SE5->E5_VRETIRF,SE5->E5_VRETIRF})

			SE5->(dbSkip())
		EndDo
	Next __k

	RestArea(aAreaSE5)

Return( aBaixa )

//-------------------------------------------------------------------------
/*/{Protheus.doc} VrPdComp
Verifica se o t�tulo s� tem saldo de impostos e nesse caso
verifica se o valor a compensar � superior ao saldo a pagar

@author Adrianne Furtado
@since  06/07/2010
@version 12
/*/
//-------------------------------------------------------------------------
Static Function VrPdComp(nSelecP, nSelecR,nTamChavE2)
	Local lRet := .T.
	Local aAreaSE2
	Local nVlSldImp := 0

	If __lImpCC
		If nSelecP > nSelecR
			aAreaSE2 := SE2->(GetArea())
			SE2->(dbSetOrder(1))
			dbSelectArea("TRB")
			dbGotop( )

			While !Eof()
				If TRB->MARCA == cMarca .and. !Empty(TRB->PAGAR)
					SE2->(dbSeek(Substr(TRB->CHAVE,1,nTamChavE2)))
					//no IF abaixo, o saldo do t�tulo � o valor exato dos impostos. Exemplo: Tem um t�tulo de 10.000, mas informou 9535 no momento da baixa
					If SE2->E2_SALDO == SE2->(E2_PIS-E2_VRETPIS)+SE2->(E2_COFINS-E2_VRETCOF)+SE2->(E2_CSLL-E2_VRETCSL)
						nVlSldImp += SE2->(E2_PIS+E2_COFINS+E2_CSLL)
						// para essa situa��o o valor a ser compensado precisa ser maior ou igual ao saldo do t�tulo
					EndIf
				EndIf
				DbSkip()
			EndDo
			If nSelecR < nVlSldImp
				Aviso(STR0083,STR0095 ,{STR0094}) //"aten��o" "Quando o saldo do t�tulo � referente aos impostos e MV_CC10925 = 2, a compensa��o precisa ser de valor igual ou maior que esse saldo."//"ok"
				lRet := .F.
			EndIf
			RestArea(aAreaSE2)
		EndIf
	EndIf

Return lRet

//-------------------------------------------------------------------------
/*/{Protheus.doc} FA450ValDocs
Posiciona o titulo na tabela SE2 para validacao dos documentos obrigatorios

@author Renan G. Alexandre
@since  25/02/2011
@version 12
/*/
//-------------------------------------------------------------------------
Static Function FA450ValDocs(cTitulo,lTodos,lArea,lEmail,lPrimeiro)
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

//-------------------------------------------------------------------------
/*/{Protheus.doc} F450TipoIN
Montagem da expressao para query (Tipos de Titulo)

@param cCart, Carteira a ser considarada (Receber ou Pagar)
@param nDebCred, Considera titulos normais ou credito

@author Mauricio Pequim Jr
@since  21/08/2013
@version 12
/*/
//-------------------------------------------------------------------------
Static Function F450TipoIN(cCart,nDebCred)
	Local cQuery := ""
	Local cTipos := ""

	If cCart == "R"		//Contas a Receber
		If nDebCred == 1	//Titulos Normais
			cTipos := MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM
		Else				//Titulos Credito
			cTipos := MVRECANT+"/"+MV_CRNEG
		Endif
	Else				//Contas a Pagar
		If nDebCred == 1	//Titulos Normais
			cTipos := MVPROVIS+"/"+MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM
		Else				//Titulos Credito
			cTipos := MVPAGANT+"/"+MV_CPNEG
		Endif
	Endif

	//Unifico os separadores
	cTipos	:=	StrTran(cTipos,',','/')
	cTipos	:=	StrTran(cTipos,';','/')
	cTipos	:=	StrTran(cTipos,'|','/')
	cTipos	:=	StrTran(cTipos,'\','/')

	cTipos := Formatin(cTipos,"/")

	//Monto a expressao da Query
	If cCart == "R"
		If nDebCred == 1
			cQuery += "SE1.E1_TIPO NOT IN " + cTipos + " AND "
		Else
			cQuery += "SE1.E1_TIPO IN " + cTipos + " AND "
		Endif
	Else
		If nDebCred == 1
			cQuery += "SE2.E2_TIPO NOT IN " + cTipos + " AND "
		Else
			cQuery += "SE2.E2_TIPO IN " + cTipos + " AND "
		Endif
	Endif

Return cQuery

//-------------------------------------------------------------------------
/*/{Protheus.doc} GetIdent
Obt�m o identificador do processo de CEC no cancelamento

@author Vitor Duca
@since  27/03/2019
@version 12
/*/
//-------------------------------------------------------------------------
Static Function GetIdent(cFil as Character, cIdent as Character) as Character
	Local cRetIdent as Character
	Local aArea as Array
	Local cTabTmp as Character

	cRetIdent := ""
	aArea := GetArea()
	cTabTmp	:= "TMPSE5"

	BeginSql Alias cTabTmp
		SELECT MAX(SE5.E5_IDENTEE) AS IDENTEE
			FROM %Table:SE5% SE5
			WHERE SE5.E5_FILIAL = %Exp:cFil%
				AND SE5.E5_IDENTEE <> %Exp:cIdent%
				AND SE5.E5_PREFIXO = %Exp:SE2->E2_PREFIXO%
				AND SE5.E5_NUMERO = %Exp:SE2->E2_NUM%
				AND SE5.E5_PARCELA = %Exp:SE2->E2_PARCELA%
				AND SE5.E5_TIPO = %Exp:SE2->E2_TIPO%
				AND SE5.E5_FORNECE = %Exp:SE2->E2_FORNECE%
				AND SE5.E5_LOJA    = %Exp:SE2->E2_LOJA%
				AND SE5.E5_SITUACA NOT IN (%EXP:'C'%,%EXP:'X'%)
				AND SE5.E5_TIPODOC <> 'ES' 
				AND SE5.%NotDel%
	EndSql

	cRetIdent := (cTabTmp)->IDENTEE
	(cTabTmp)->(dbCloseArea())
	RestArea(aArea)

Return cRetIdent

//-------------------------------------------------------------------------
/*/{Protheus.doc} F450VldCar
Verifica se existem titulos das carteiras a pagar e receber selecionados
@return lRet - Boolean

@author Fabio Casagrande Lima
@since  27/11/17
/*/
//-------------------------------------------------------------------------
Static Function F450VldCar()
	Local lRet   := .T.

	If nSelecP == 0 .Or. nSelecR == 0
		lRet := .F.
		If nSelecP == 0
			HELP(" ",1,"F450VldCarP" ,,Iif (lF450Auto,"Os titulos a pagar enviados via ExecAuto nao foram encontrados." ,"Nenhum titulo a pagar foi selecionado."),2,0,,,,,, {"Selecione um titulo a pagar."})
			//STR0119 "Os t�tulos a pagar enviados via ExecAuto n�o foram encontrados." | STR0113 Nenhum t�tulo a pagar foi selecionado." | STR0120 "Selecione um t�tulo a pagar."
		Else
			HELP(" ",1,"F450VldCarR" ,,Iif (lF450Auto,"Os titulos a receber enviados via ExecAuto nao foram encontrados." ,"Nenhum titulo a receber foi selecionado."),2,0,,,,,, {"Selecione um titulo a receber."})
			//STR0121 "Os t�tulos a receber enviados via ExecAuto n�o foram encontrados." | STR0114 Nenhum t�tulo a receber foi selecionado." | STR0122 "Selecione um t�tulo a receber."
		Endif
	EndIf

	IF __lVLDCRP //Ponto de Entrada para Valida��es Complementares
		lRet := ExecBlock("F450VLDCRP",.F.,.F.)
	EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Fa450Juri(nRecno)
Verifica se tem integracao com o SIGAPFS e realiza as validacoes da 
integracao

@param nRecno    Recno do t�tulo da SE2 (Contas a pagar)

@Return lRet   .T. Se o t�tulo � valido para ser manipulado.

@author Jorge Martins
@since 10/10/2017
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function Fa450Juri(nRecno)
	Local lRet      := .T.

	lRet := JVldBxPag(nRecno, .F., .F.)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} F450VerImp()
Verifica a reten��o dos impostos PCC e IRRF do Contas a Pagar

@param nPccTit	Valor de PCC no Titulo
@param nIrfTit	Valor de IRF no Titulo

@Return lRet   .T. Se o t�tulo � valido para ser manipulado.

@author Jorge Martins
@since 10/10/2017
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function F450VerImp(nPccTit, nIrfTit, aPcc, aIrrf, nValPgto,lMarcaTit)

	Local lIRRFBaixa := .F.
	Local nPropIRF := 0
	Local nSalImp := 0
	Local lParcial := .F.
	Local nTotLiq := 0
	Local nPccRet 	:= 0
	Local nIrfRet 	:= 0
	Local lMVBP10925 := SuperGetMv("MV_BP10925",.F.,"1") == "2"

	DEFAULT lMarcaTit   := .F.
	DEFAULT nPccTit 	:= 0
	DEFAULT nIrfTit 	:= 0
	DEFAULT aPcc		:= {}
	DEFAULT aIrrf		:= {}
	DEFAULT nValPgto	:= {}

	nPccRet := 0
	nPccTit := 0
	nIrfRet := 0
	nIrfTit := 0

	//Retorna se o IRRF � retido na baixa e posiciona SA2/SED
	lIRRFBaixa := F450IsIrBx()

	If __lPccCC
		// essa chamada � feita para alimentar a vari�vel nPccRet e nIrfRet e para recalcular o PCC antes da baixa do t�tulo a pagar
		Sel450Baixa("VL /BA /CP /",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA, @nPccRet,,,@nIrfRet)
		nSalImp := salRefPag(SA2->A2_COD+SA2->A2_LOJA,.F.,.F.,.F.,.F.,.F.,.F.)

		If lMVBP10925
			nSalImp -= nPccRet
		ENDIF

		nTotLiq := nSalImp - nPis - nCofins - nCsll - nIrrf

		If !lMarcaTit
			lParcial := (nValPgto + nPis + nCofins + nCsll + nIrrf) < nTotLiq
		ENDIF

		If lMarcaTit .Or. !lParcial
			aPcc    	:= newMinPcc(dDataBase, nSalImp, SED->ED_CODIGO, "P", SA2->A2_COD + SA2->A2_LOJA, /*nIss*/, /*nIns*/, /*nIrf*/, /*lMin*/, /*lIgnrOrg*/, /*cMotBx*/)
			nPccTit		:= aPcc[2] + aPcc[3] + aPcc[4]
		Else
			aPcc    	:= newMinPcc(dDataBase,nValPgto, SED->ED_CODIGO, "P", SA2->A2_COD + SA2->A2_LOJA, /*nIss*/, /*nIns*/, /*nIrf*/, /*lMin*/, /*lIgnrOrg*/, /*cMotBx*/)
			nPccTit		:= aPcc[2] + aPcc[3] + aPcc[4]
			nPis		:= aPcc[2]
			nCofins		:= aPcc[3]
			nCsll		:= aPcc[4]

			If lMVBP10925
				nValPgto    -= nPccTit
			ENDIF
		EndIf

		If __VlMinPc > nPccTit
			If lParcial
				nValPgto += nPccTit
			EndIf
			nPccTit		:= 0
			aPcc[2] 	:= 0
			aPcc[3] 	:= 0
			aPcc[4] 	:= 0
		Endif
	EndIF

	If __lImpCC .and. lIRRFBaixa
		If lParcial
			nPropIrf := ((nValPgto + nPccTit) / SE2->E2_BASEIRF)
			nIrfTit  := Round( (SE2->E2_IRRF * nPropIrf), 2)
			nBaseIrpf	:= Round( (SE2->E2_BASEIRF * nPropIrf), 2)
			nIrfCalc	:= nIrfTit
			nIrrf		:= nIrfTit
			nIrfBaseC	:= nBaseIrpf
			nIrfBaseR	:= nBaseIrpf
			nValPgto	-= nIrfTit
		Else
			nPropIrf := (nSalImp / SE2->E2_BASEIRF)
			nIrfTit := Round( (SE2->E2_IRRF * nPropIrf), 2)
			nBaseIrpf := Round( (SE2->E2_BASEIRF * nPropIrf), 2)
			nIrfCalc	:= nIrfTit
			nIrfBaseC 	:= nBaseIrpf
			nIrfBaseR 	:= nBaseIrpf
		EndIf
		If __VlMinIr > nIrfTit
			If lParcial
				nValPgto += nIrfTit
			EndIf
			nIrfTit := 0
			nIrfBaseR := 0
		Endif
	EndIf

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} FA450FK6(cAlias,cIdFk,cTipo)
Fun��o que busca os valores complementares da compensa��o na FK6

@param cAlias ,A Tabela de Origem do Dado (Obrigatorio)
@param cIdFk  ,ID da Origem do Dado (Obrigatorio)
@param cTipo  ,Tipodoc espec�fico (JR, MT, DC, VA)

@return aRet  ,Vetor com as somatorias dos campos FK6_VALCAL,FK6_VALMOV, 
sendo o vetor composto na mesma ordem

@author Vitor Duca
@since 23/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------------------
Static Function FA450FK6(cAlias As Character,cIdFk As Character,cTipo As Character) As Array
	Local aArea   As Array
	Local aRet    As Array
	Local nValCal As Numeric
	Local nValMov As Numeric

	//Inicializa��o das variaveis
	aArea   := GetArea()
	aRet    := {}
	nValCal := 0
	nValMov := 0

	DbSelectArea("FK6")
	FK6->(DbSetOrder(3))		//FK6_FILIAL+FK6_IDORIG+FK6_TABORI+FK6_TPDOC
	If FK6->(DbSeek(xFilial('FK6') + cIdFk + cAlias + cTipo))
		While FK6->(!EOF()) .And. FK6->(FK6_FILIAL + FK6_IDORIG + FK6_TABORI + FK6_TPDOC) == xFilial('FK6') + cIdFk + cAlias + cTipo

			If cTipo == "VA"
				If FK6->FK6_ACAO == '1'
					nValCal += FK6->FK6_VALCAL
					nValMov += FK6->FK6_VALMOV
				Else
					nValCal -= FK6->FK6_VALCAL
					nValMov -= FK6->FK6_VALMOV
				EndIf
				FK6->(DbSkip())
			ElseIf cTipo $ "JR|MT|DC|CM"
				nValCal += FK6->FK6_VALCAL
				nValMov += FK6->FK6_VALMOV
				Exit
			Endif
		EndDo
	EndIf

	aAdd(aRet,{nValCal,nValMov})

	RestArea(aArea)

Return aRet

//-------------------------------------------------------------------
/*{Protheus.doc} A450RecFk2

Ajuste de base historica para grava��o do campo FK2_IDPROC
para ser utilizado na query da fun��o A450CalCn

@param cCompCan - Identificador da compensa��o 

@author Vitor Duca
@version 12
@since 24/09/2019
@Obs Possivel retirada apos o release 12.1.25
*/
//-------------------------------------------------------------------
Static Function A450RecFk2(cCompCan As Character, cAliasFK2 As Character, cAliasFK1 As Character)
	Local cQuery    As Character
	Local cAliasSE5 As Character
	Local aArea		As Array
	Local oRecFk2	As Object

	//Inicializa��o das variaveis
	cQuery    := ""
	cAliasSE5 := "SE5FK2"
	aArea     := GetArea()
	oRecFk2   := NIL

	DbSelectArea("FK2")
	DbSetOrder(1)
	DbSelectArea("SE5")
	DbSetOrder(1)

	cQuery += "SELECT E5_IDORIG IDORIG, R_E_C_N_O_ RECNO FROM " + RetSqlName("SE5") + " WHERE "
	cQuery += "E5_FILIAL = ? AND "
	cQuery += "E5_IDENTEE = ? AND "
	cQuery += "E5_DATA <= ? AND "
	cQuery += "E5_TIPODOC NOT IN ('ES', 'CM', 'VM', 'JR', 'MT', 'VA', 'DC') AND "
	cQuery += "E5_SITUACA NOT IN ('C', 'X') AND "
	cQuery += "E5_TABORI = ? AND "
	cQuery += "D_E_L_E_T_ = ' ' "

	cQuery 	  := ChangeQuery(cQuery)
	oRecFk2 := FWPreparedStatement():New(cQuery)

	oRecFk2:SetString(1,xFilial("SE5"))
	oRecFk2:SetString(2,cCompCan)
	oRecFk2:SetString(3,Dtos(dDataBase))
	oRecFk2:SetString(4,"FK2")
	cQuery := oRecFk2:GetFixQuery()
	MpSysOpenQuery(cQuery,cAliasSE5)

	While (cAliasSE5)->(!Eof())
		If FK2->(DbSeek(xFilial("FK2")+(cAliasSE5)->IDORIG))
			If Empty(FK2->FK2_IDPROC)
				Reclock("FK2",.F.)
				FK2->FK2_IDPROC := cCompCan
				FK2->(MsUnLock())
			Endif
		Else
			//Migra o registro de SE5 posicionado que ainda n�o foi migrado
			SE5->(DbGoTo((cAliasSE5)->RECNO))
			If SE5->E5_MOVFKS <> 'S' .AND. SE5->( !EOF() ) .and. !Empty(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
				FINXSE5(SE5->(Recno()), 2)
			Endif
		Endif
		(cAliasSE5)->(DbSkip())
	EndDo

	oRecFk2:Destroy()
	oRecFk2 := Nil

	If !Empty(cAliasSE5)
		(cAliasSE5)->(DbCloseArea())
		cAliasSE5 := " "
	Endif

	RestArea(aArea)

Return

//-------------------------------------------------------------------
/*{Protheus.doc} F450IsIrBx
Faz a verifica��o se o IRRF � retido na baixa - Contas a pagar

@author Pequim 
@since  06/11/2020
*/
//-------------------------------------------------------------------
Static Function F450IsIrBx()

	Local lIRRFBaixa := .F.

	SA2->(dbSetOrder(1))
	SA2->(MSSeek(xFilial("SA2",SE2->E2_FILORIG)+SE2->(E2_FORNECE+E2_LOJA)))

	SED->(DbSetOrder(1))
	SED->(MSSeek(xFilial("SED",SE2->E2_FILORIG)+SE2->E2_NATUREZ))

	lIRRFBaixa := SA2->A2_CALCIRF == "2" .And. SED->ED_CALCIRF = "S" .And. !SE2->E2_TIPO $ MVPAGANT

Return lIRRFBaixa

/*/{Protheus.doc} F450BxCanc
	Verifica se existe estorno para a baixa posicionada
	@type  Static Function
	@author Vitor Duca
	@since 22/06/2021
	@version 1.0
	@param cIdDoc, Character, _IDDOC do titulo
	@return lRet, Logical, Se existem cancelamento para a baixa posicionada
	@example
	@see (links_or_references)
	/*/
Static Function F450BxCanc(cIdDoc As Character, cAliasTit As Character, cSeqFk	As Character) As Logical
	Local cQuery As Character
	Local cField As Character
	Local cTable As Character
	Local lRet As Logical

	Default cAliasTit := "SE1"
	Default cIdDoc := ""
	Default cSeqFk := "01"

	cField := "FK1_"
	cTable := "FK1"
	lRet := .F.

	If cAliasTit == "SE2"
		cField := "FK2_"
		cTable := "FK2"
	Endif

	cQuery := "SELECT COUNT(*) SUMREG "
	cQuery += "FROM "+RetSqlName(cTable) + " "
	cQuery += "WHERE " + cField + "IDDOC = '"+cIdDoc+"' "
	cQuery += "AND " + cField + "TPDOC = 'ES' "
	cQuery += "AND " + cField + "SEQ = '" + cSeqFk + "' "
	cQuery += "AND D_E_L_E_T_ = '' "

	lRet := MpSysExecScalar(cQuery,"SUMREG") > 0

Return lRet


Static Function F450DATaE(dEmiIni450,dEmiFim450)

	LOCAL lRet:=.T.
	IF dEmiFim450 < dEmiIni450
		Help(" ",1,"DATAMENOR")
		lRet:=.F.
	EndIF
Return lRet
