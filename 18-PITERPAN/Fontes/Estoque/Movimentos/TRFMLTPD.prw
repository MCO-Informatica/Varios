//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#INCLUDE 'MATA261.CH'

//Constantes
#Define STR_PULA        Chr(13)+Chr(10)

#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#DEFINE LINHAS 999


User Function MTA261MNU()

	AADD(aRotina, {'Importa Pedido - 01 para 90', "U_TRFMLTPD()", 0, 0, 0, Nil} )
	AADD(aRotina, {'Importa Pedido - 90 para 01', "U_TRFMLTPD(.T.)", 0, 0, 0, Nil} )

Return




User Function TRFMLTPD(lInverte)

	Local cSql := ""
/*
	Private oDlg1
	Private oSay1
	Private oGet1
	Private oButton1

	Private cPedido := Space(6)
*/
	Default lInverte := .F.
/*
	oDlg1       := TDialog():New(0,0,150,200,"Informe o Pedido",,,,,CLR_BLACK,CLR_WHITE,,,.T.) //180,180
	oSay1       := TSay():New(10,20,{||'Pedido'},oDlg1,,,,,,.T.,CLR_BLACK,CLR_WHITE,300,20)
	oGet1       := TGet():New( 20,20,{|u| IIF(Pcount()>0,cPedido:=u,cPedido)},oDlg1,60,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cPedido,,,,)
	oGet1:cF3   := "SC5"
	oButton1    :=  TButton():New( 45, 20, "OK",oDlg1,{||oDlg1:End()}, 60,15,,,.F.,.T.,.F.,,.F.,,,.F. ) //Chama tela de clientes
	oDlg1:Activate(,,,.T.)

	If Empty(cPedido)
		Return .T.
	EndIf
*/
	a241Inclui(,,,)

	/*cSql := "SELECT * FROM "+RetSqlName("SC6")+" SC6 WHERE SC6.D_E_L_E_T_=' ' AND C6_NUM = '"+cPedido+"' "
	If Select("QC6") > 0
		QC6->(DbCloseArea())
	EndIf

	TcQuery ChangeQuery(cSql) New Alias "QC6"

	While !QC6->(EOF())

		MsgInfo(QC6->C6_PRODUTO,'Produto')

		QC6->(DbSkip())
	End

	If Select("QC6") > 0
		QC6->(DbCloseArea())
	EndIf
*/

Return .T.




Static Function a241Inclui(cAlias,nReg,nOpc,cNewDoc,lChangeDoc)
Local GetList    := {}
Local nOpcao     := 3
Local oDlg
Local dDataFec   := MVUlmes()
Local cCampo     := ""
Local i          := 0
Local nX         := 0
Local aCamposVld := {}
Local bBlkVld    := {|x| x[3] := &(x[2])}
Local lRet			 := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva a integridade dos dados                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nSavRec, nSavReg, lVldPCO
Local cSavScr, cSavCur, cSavRow, cSavCol

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a Existencia do ponto de entrada e seta valor       ³
//³ da variavel que define se edita o documento ou nao           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lDocto       := .T.
Local lPimsInt	   := SuperGetMV("MV_PIMSINT",.F.,.F.)
Local aObjects 		:= {}
Local aSize   	    := MsAdvSize(.F.)
Local oSize
Local aInfo     	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
Local aPosObj		:= {}
Local cF3          := If(CtbInUse(), 'CTT', If(SuperGetMV('MV_SIGAGSP', .F., '0')=='1', 'NI3', 'SI3')) //-- MV_SIGAGSP = "0"-Nao integra/ "1"-Integra
Local aADDButtons  := {}
Local aTelaButtons := {}
Local cMay         := ""
Local aCpoCab:={}
Local aCpx:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Walk-Thru						                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aNoFields	   := {}
Local lFirst       := .T.
Local aBtnBack     := {}
//-- Variavel usada para verificar se o disparo da funcao IntegDef() pode ser feita manualmente
Local lIntegDef  :=  FWHasEAI("MATA241")
Local lWmsNew    := SuperGetMV("MV_WMSNEW",.F.,.F.)
Local lWmsSD3    := Iif(Type('lExecWms')=='L', lExecWms, .F.)
Local lDocSD3    := Iif(Type('lDocWms')=='L', lDocWms, .F.)
Local lMT241CAB  :=  ExistBlock("MT241CAB")
Local lMT241SD3  :=  ExistBlock("MT241SD3")
Local lMT241CAN  :=  ExistBlock("MT241CAN")
Local cPicD3Doc  :=  PesqPict("SD3","D3_DOC")
Local cPicD3TM   :=  PesqPict("SD3","D3_TM")
Local cPicD3CC   :=  PesqPict("SD3","D3_CC")
Local cvalidcc   := 	getvalid("D3_CC")

Local aD3NumSeq
Local aRetInt 	 := {}

PRIVATE nPosCod    := 0
PRIVATE nPosLocal  := 0
PRIVATE nPosLote   := 0
PRIVATE nPosLotCTL := 0
PRIVATE nPosDValid := 0
PRIVATE nPosQuant  := 0
PRIVATE nPosTES    := 0
PRIVATE nPosCusto1 := 0
PRIVATE nPosUm     := 0
PRIVATE nPosServic := 0
PRIVATE nPosPotenc := 0
PRIVATE nPosConta  := 0
PRIVATE nPosCC     := 0
PRIVATE nPosGrupo  := 0
PRIVATE nPosTipo   := 0
PRIVATE nPosSegUm  := 0
PRIVATE nPosQtSegUm:= 0
PRIVATE nPosDesc   := 0
PRIVATE nPosOp     := 0
PRIVATE nPosTRT    := 0
PRIVATE nPosLocali := 0
PRIVATE nPosNumSer := 0
PRIVATE nPos241Loc := 0
PRIVATE nPos241Qtd := 0
PRIVATE nPosCodVei := 0
PRIVATE nPosViagem := 0
PRIVATE nPosProj   := 0
PRIVATE nPosTarefa := 0
PRIVATE nPosClVl   := 0
PRIVATE nPosItemCT := 0
PRIVATE nPosStatus := 0
PRIVATE nPosNumSa  := 0
PRIVATE nPosItemSa := 0
PRIVATE nPosDoc    := 0

//Variavel de controle do itens os quais terao pergunta ao usuario, para que o mesmo seja perguntado somente uma vez
PRIVATE aResposta  := {}

//-- Variavel utilizada pela integracao com SIGAMNT
Private aMntGarant := {}


Private l241Auto := .F.

Default cAlias := "SD3"
Default nOpcX  := 3

If Type("INCLUI") == "L" .And. !INCLUI
	INCLUI := .T.
EndIf

// -- Protecao quando rotina for executada em modo automatico

If (lPimsInt .And. l241Auto) .Or. FunName() == "MATA185" .Or. IsInCallStack("MATI241") .Or. (l241Auto .And. FunName() == "EICDI154")
	aNoFields := {"D3_DOC","D3_TM","D3_PERDA","D3_EMISSAO","D3_PARCTOT","D3_ESTORNO","D3_NODIA","D3_DIACTB"}
Else
	aNoFields := {"D3_DOC","D3_TM","D3_CC","D3_PERDA","D3_EMISSAO","D3_PARCTOT","D3_ESTORNO","D3_NODIA","D3_DIACTB"}
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percentual FCI   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aNoFields,"D3_PERIMP")
AADD(aNoFields,"D3_VLRVI")

If Type("aCtbDia") == "U"
   Private aCtbDia := {}
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona informacoes para validacao de Get Fixo no array     ³
//³ aCamposVld                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCamposVld,{"D3_CC","cCC",""})
AADD(aCamposVld,{"D3_EMISSAO","dA241Data",""})

If ExistBlock("MTA241DOC")
	lDocto:=ExecBlock("MTA241DOC",.F.,.F.)
	If Valtype(lDocto) # "L"
		lDocto:=.T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a Existencia da varivael l241Auto                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Type("l241Auto") == "U" )
	Private l241Auto := .F.
EndIf

PRIVATE aLogSld    := {}
PRIVATE aValidGet  := {}

PRIVATE cDocumento := CriaVar("D3_DOC")
PRIVATE dA241Data  := CriaVar("D3_EMISSAO")
PRIVATE cCC        := CriaVar("D3_CC")
PRIVATE cTM        := CriaVar("D3_TM")
PRIVATE cNrAbate   := IIF(cPaisLoc=="PTG",CriaVar("D3_NRABATE"),"")
PRIVATE nOpca      := 0
PRIVATE nFatConv   := 0
PRIVATE nCOpcao    := 3

PRIVATE aRatVei    := {}
PRIVATE aRatFro    := {}
PRIVATE aArraySDG  := {}
PRIVATE l241Inc    := .T.

Default cNewDoc    := ''
Default lChangeDoc := .F.

aButtons     := If(Type("aButtons") == "U", {}, aButtons)
aTelaButtons := ACLONE(aButtons)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Portaria CAT83  - Se o parâmetro não estiver ativo, não inclui o campo no acols ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !V240CAT83()
	aAdd(aNoFields,"D3_CODLAN")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Guia de Abate - Portugal   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc=="PTG"
	AADD(aNoFields,"D3_NRABATE")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o numero com o ultimo + 1                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD3")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar data do ultimo fechamento em SX6.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dDataFec >= dDataBase
	Help ( " ", 1, "FECHTO" )
	Return 0
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra tabela de tipos de movimentacao para aparecerem apenas req/dev ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF5")
//If Upper(AllTrim(cXFunc)) == "A185ATU2SD3"
//	cCond := 'F5_TIPO == "R"'
//Else
	cCond := 'F5_TIPO == "R" .OR. F5_TIPO == "D"'
//EndIf
MsFilter(cCond)
dbGoTop()

dbSelectArea(cAlias)
nSavReg     := RecNo()

If l241Auto .And. lDocSD3
	If (nPosDoc := Ascan(aAutoCab,{|x| Alltrim(x[1]) == 'D3_DOC'})) > 0
		cDocumento := Iif(!Empty(aAutoCab[nPosDoc,2]),aAutoCab[nPosDoc,2],cDocumento)
	EndIf
EndIf

cDocumento := IIf(Empty(cDocumento),NextNumero("SD3",2,"D3_DOC",.T.),cDocumento)

// Busca proximo documento na tabela auxiliar (DH1) quando controla novo WMS
If lWmsNew .And. !lDocSD3
	dbSelectArea("DH1")
	DH1->(dbSetOrder(2))
	If DH1->(dbSeek(xFilial("DH1")+cDocumento))
		cDocumento := NextNumero("DH1",2,"DH1_DOC",.T.)
	EndIf
EndIf

cDocumento := A261RetINV(cDocumento)
dbSetOrder(1)
MsGoTo(nSavReg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader e aCols utilizando a funcao FillGetDados       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aHeader[0]
PRIVATE aCols[0]
PRIVATE Continua

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sintaxe da FillGetDados( nOpcx, cAlias, nOrder, cSeekKey, bSeekWhile, uSeekFor, aNoFields, aYesFields, lOnlyYes, cQuery, bMontCols, lEmpty, aHeaderAux, aColsAux, bAfterCols, bBeforeCols, bAfterHeader, cAliasQry )   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If Upper(AllTrim(cXFunc)) == "A185ATU2SD3"
//	FillGetDados(nOpc,cAlias,1,,,,aNoFields,,,,{|aColsX| A185Atu2SD3(aColsX) }/*bMontCols*/,,,,,, {|aHeaderX| a241AfterH(aHeaderX,nOpcao)}/*bAfterHeader*/  )
//Else
	FillGetDados(nOpc,cAlias,1,,,,aNoFields,,,,,.T./*lEmpty*/,,, {|aColsX| a241AfterC(nOpcao,aColsX,cAlias)}/*bAfterCols*/,, {|aHeaderX| a241AfterH(aHeaderX,nOpcao)}/*bAfterHeader*/  )
//EndIf

For nx := 1 To Len(aHeader)
	Do Case
		Case Trim(aHeader[nx][2]) == "D3_COD"
			nPosCod:=nX
		Case Trim(aHeader[nx][2]) == "D3_LOCAL"
			nPosLocal:=nX
		Case Trim(aHeader[nx][2]) == "D3_NUMLOTE"
			nPosLote:=nX
		Case Trim(aHeader[nx][2]) == "D3_LOTECTL"
			nPosLotCTL:=nX
		Case Trim(aHeader[nx][2]) == "D3_DTVALID"
			nPosDValid:=nX
		Case Trim(aHeader[nx][2]) == "D3_POTENCI"
			nPosPotenc:=nX
		Case Trim(aHeader[nx][2]) == "D3_QUANT"
			nPosQuant:=nX
		Case Trim(aHeader[nx][2]) == "D3_SEGUM"
			nPosSegUm:=nX
		Case Trim(aHeader[nx][2]) == "D3_QTSEGUM"
			nPosQtSegUm:=nX
		Case Trim(aHeader[nx][2]) == "D3_TEATF"
			nPosTES:=nX
		Case Trim(aHeader[nx][2]) == "D3_CUSTO1"
			nPosCusto1:=nX
		Case Trim(aHeader[nx][2]) == "D3_UM"
			nPosUm:=nX
		Case Trim(aHeader[nx][2]) == "D3_CONTA"
			nPosConta:=nX
		Case Trim(aHeader[nx][2]) == "D3_GRUPO"
			nPosGrupo:=nX
		Case Trim(aHeader[nx][2]) == "D3_TIPO"
			nPosTipo:=nX
		Case Trim(aHeader[nx][2]) == "D3_OP"
			nPosOp:=nX
		Case Trim(aHeader[nx][2]) == "D3_TRT"
			nPosTrt:=nX
		Case Trim(aHeader[nx][2]) == "D3_DESCRI"
			nPosDesc:=nX
		Case Trim(aHeader[nx][2]) == "D3_LOCALIZ"
			nPosLocali:=nX
		Case Trim(aHeader[nx][2]) == "D3_NUMSERI"
			nPosNumSer:=nX
		Case Trim(aHeader[nx][2]) == "D3_CODVEI"
			nPosCodVei:=nX
		Case Trim(aHeader[nx][2]) == "D3_VIAGEM"
			nPosViagem:=nX
		Case Trim(aHeader[nx][2]) == "D3_SERVIC"
			nPosServic:=nX
		Case Trim(aHeader[nx][2]) == "D3_PROJPMS"
			nPosProj:=nX
		Case Trim(aHeader[nx][2]) == "D3_TASKPMS"
			nPosTarefa:=nX
		Case Trim(aHeader[nx][2]) == "D3_CLVL"
			nPosClVl:=nX
		Case Trim(aHeader[nx][2]) == "D3_ITEMCTA"
			nPosItemCT:=nX
		Case Trim(aHeader[nx][2]) == "D3_STATUS"
			nPosStatus:=nX
		Case Trim(aHeader[nx][2]) == "D3_NUMSA"
			nPosNumSa:=nX
		Case Trim(aHeader[nx][2]) == "D3_ITEMSA"
			nPosItemSa:=nX
		Case Trim(aHeader[nx][2]) == "D3_CUSTO2"
			nPosCusto2:=nX
		Case Trim(aHeader[nx][2]) == "D3_CUSTO3"
			nPosCusto3:=nX
		Case Trim(aHeader[nx][2]) == "D3_CUSTO4"
			nPosCusto4:=nX
		Case Trim(aHeader[nx][2]) == "D3_CUSTO5"
			nPosCusto5:=nX
	EndCase
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacao do uso de alguns campos obrigatorios               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(nPosCod)
	UserException("D3_COD"  +OemToAnsi(STR0021))
ElseIf Empty(nPosLocal)
	UserException("D3_LOCAL"+OemToAnsi(STR0021))
ElseIf Empty(nPosQuant)
	UserException("D3_QUANT"+OemToAnsi(STR0021))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa Ponto de Entrada p/ adicao de campos na getdados             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MTA241CPO")
	ExecBlock("MTA241CPO",.F.,.F.,{nOpc})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa Ponto de Entrada p/ validacao do SIGAPCO                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l185 .And. ExistBlock("MTA241PCO")
	lVldPCO := ExecBlock("MTA241PCO",.F.,.F.,{nOpc})
	If ValType(lVldPCO) == "L"
	 	If !lVldPCO
	 		Return nOpca
	 	EndIf
	EndIf
EndIf

If (l241Auto)
	MsAuto2aCols()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada para montar array com botoes a      ³
//³ serem apresentados na tela de INCLUSAO                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock( "M241BUT" ) )
	aADDButtons:=ExecBlock("M241BUT",.F.,.F.)
	If ValType(aADDButtons) == "A"
		For nx:=1 to Len(aADDButtons)
			AADD(aTelaButtons,aADDButtons[nx])
		Next nx
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada criado para configurar botoes da enchoicebar        ³
//³ Este PE foi criado porque o PE acima (M241BUT) nao permite manipular ³
//³ botoes da enchoicebar.                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "A241BUT" )
	aBtnBack := aClone(aTelaButtons)
	aTelaButtons := ExecBlock( "A241BUT", .F., .F., { nOpc, aTelaButtons } )
	If ValType( aTelaButtons ) # "A"
		aTelaButtons := aClone(aBtnBack)
	EndIf
EndIf

While .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoIniLan("000151")
	If (! l241Auto)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definição array aObjects                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oSize := FwDefSize():New()

		oSize:AddObject( "CABECALHO",  100, 8, .T., .T. ) // Totalmente dimensionavel
		oSize:AddObject( "GETDADOS" ,  100, 92, .T., .T. ) // Totalmente dimensionavel
		oSize:lProp 	:= .T. // Proporcional
		oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3

		oSize:Process() 	   // Dispara os calculos

		dA241Data  := dDataBase
		cCC        := " "
		cTM        := "008"

		
	cSql := "SELECT * FROM "+RetSqlName("SB2")+" SB2 JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD = SB2.B2_COD AND SB1.D_E_L_E_T_=' '  WHERE SB2.B2_LOCAL = '90' AND SB2.B2_FILIAL = '01' AND SB2.D_E_L_E_T_ =' ' AND SB2.B2_QATU > 0 "
	
	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf
	TcQuery ChangeQuery(cSql) New Alias "QRY"

	QRY->(DbGoTop())

	aCols := {}

	While !QRY->(EOF())

	aAdd(aCols,{QRY->B2_COD,;  			   //D3_COD
				QRY->B1_DESC,;      	   //D3_DESCRI
				" ",;					   //D3_OP
				QRY->B2_QATU,;			   //D3_QUANT
				QRY->B1_UM,;        	   //D3_UM
				" ",;					   //D3_CONTA
				"90",;              	   //D3_LOCAL
				.F.})

	QRY->(DbSkip())

	End


	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ativa tecla F4 para Saldos de Lotes e Localizacao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Set Key VK_F4 TO ShowF4()

		Continua := .F.
		DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0004) OF oMainWnd PIXEL FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definição Panel que sera usado no posicionamento da tela             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPanel1:= TSay():New(oSize:GetDimension("CABECALHO","LININI"),oSize:GetDimension("CABECALHO","COLINI"),{||''},oDlg,,,,,,.T.,,,oSize:GetDimension("CABECALHO","XSIZE"),oSize:GetDimension("CABECALHO","YSIZE"))
		oPanel2:= tPanel():New(oSize:GetDimension("GETDADOS","LININI"),oSize:GetDimension("GETDADOS","COLINI"),,oDlg,,,,,,oSize:GetDimension("GETDADOS","XSIZE"),oSize:GetDimension("GETDADOS","YSIZE"),,)


		@ 0.4,00.7  SAY OemToAnsi(STR0009) OF oPanel1 	//"N£mero Documento"
		@ 0.3,08.0  MSGET cDocumento	Picture cPicD3Doc Valid CheckSx3("D3_DOC") .And. VldUser('D3_DOC') WHEN If(ExistBlock("MTA241DOC"),lDocto,If(GetSx3Cache("D3_DOC","X3_VISUAL") == "V",.F.,&(GetSx3Cache("D3_DOC","X3_WHEN")))) SIZE 65,08 OF oPanel1
		@ 0.4,17.3	SAY OemToAnsi(STR0010) OF oPanel1	//"TM"
		@ 0.3,18.7	MSGET oTm Var cTm F3 "SF5" Picture cPicD3TM Valid A241ChkSX3("D3_TM") .And. VldUser('D3_TM') WHEN If(GetSx3Cache("D3_TM","X3_VISUAL") == "V",.F.,&(GetSx3Cache("D3_TM","X3_WHEN"))) OF oPanel1
		oTm:bLostFocus := { || IIf(!Vazio(cTm) ,{cNrAbate:=A240NGUIA(cTm,.F.)},cNrAbate:="aaa")}

		@ 0.4,22.7  SAY OemToAnsi(STR0011) OF oPanel1 	//"Centro de Custo"
		@ 0.3,27.9  MSGET cCC F3 cF3 Picture cPicD3CC Valid &(cvalidcc) .And. VldUser('D3_CC') WHEN If(GetSx3Cache("D3_CC","X3_VISUAL") == "V",.F.,&(GetSx3Cache("D3_CC","X3_WHEN"))) OF oPanel1
		If len(cCC) <= 9
			@ 0.4,36.5 SAY OemToAnsi(STR0012) OF oPanel1 	//"Emissao"
			@ 0.3,39.5 MSGET dA241Data Valid A241Data() .And. VldUser('D3_EMISSAO') WHEN If(GetSx3Cache("D3_EMISSAO","X3_VISUAL") == "V",.F.,&(GetSx3Cache("D3_EMISSAO","X3_WHEN"))) SIZE 40,08 OF oPanel1
		Else
		 	@ 0.4,43.5 SAY OemToAnsi(STR0012) OF oPanel1 //"Emissao"
			@ 0.3,46.5 MSGET dA241Data Valid A241Data() .And. VldUser('D3_EMISSAO') WHEN If(GetSx3Cache("D3_EMISSAO","X3_VISUAL") == "V",.F.,&(GetSx3Cache("D3_EMISSAO","X3_WHEN"))) SIZE 40,08 OF oPanel1
		EndIf

	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Guia de Abate - Portugal   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc=="PTG"
			@ 0.4,46.7 SAY OemToAnsi(STR0047) OF oDlg 	//"Guia de Abate"
			@ 0.3,50.9 MSGET cNrAbate When .F. Of oDlg
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ponto de Entrada que disponibiliza o Objeto da Dialog - oDlg  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMT241CAB
			aCpx:=ExecBlock("MT241CAB",.F.,.F.,{@oDlg,nOpc})
		EndIf

		oGet := MSGetDados():New(oSize:GetDimension("GETDADOS","LININI"),oSize:GetDimension("GETDADOS","COLINI"),;
		 oSize:GetDimension("GETDADOS","LINEND"),oSize:GetDimension("GETDADOS","COLEND"),;
					nOpc,'A241LinOk','A241TudoOk','',;
					If(l185,.F.,.T.),If(l185,aAlter,Nil),NIL,NIL,;
					LINHAS,,,,,,,,,oPanel2)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| (AEval(aCamposVld,bBlkVld),IIf(oGet:TudoOK() .And. ChkGetFix(aCamposVld,.F.,.T.) .And. ChkOpSusp(),(oDlg:End(),nOpca:=1),nOpca := 0))},{||oDlg:End()},,aTelaButtons)
	Else
		// Criacao do Array aValidGet
		aValidGet := {}
		aAdd(aValidGet,{"cDocumento"   ,aAutoCab[ProcH("D3_DOC"    ),2],"CheckSx3('D3_DOC').And. VldUser('D3_DOC')",.T.})
		aAdd(aValidGet,{"cTM"          ,aAutoCab[ProcH("D3_TM"     ),2],"CheckSx3('D3_TM') .And. VldUser('D3_TM')" ,.F.})
		aAdd(aValidGet,{"cCC"          ,aAutoCab[ProcH("D3_CC"     ),2],"CheckSx3('D3_CC') .And. VldUser('D3_CC')" ,.F.})
		aAdd(aValidGet,{"dA241Data"    ,aAutoCab[ProcH("D3_EMISSAO"),2],"A241Data()"                               ,.T.})
		If ! SD3->(MsVldGAuto(aValidGet)) // consiste os gets
			Return .F.
		EndIf
		If ! SD3->(MsVldAcAuto(aValidGet,"A241LinOk(o)","A241TudoOk(o)"))   // consiste o campos do Acols
			Return .F.
		EndIf
		nOpcA := 1
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga lancamentos de validacao nao utilizados gerados no SIGAPCO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcA <> 1
		PcoFreeBlq("000151",.T.)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera o Conteudo do Ponto de Entrada MT241CAB para utilizacao |
	//³ posterior no Ponto de Entrada MT241GRV           			     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCpoCab:={}
	If lMT241CAB
		If VALTYPE(aCpx)='A'
 		    aCpoCab:=Aclone(aCpx)
		EndIf
	EndIf

	If nOpcA == 1
			Begin Transaction
			aD3NumSeq := a241Grava(cAlias,nOpcao,@lChangeDoc, aCpoCab)
			If !( aD3NumSeq[ 1 ] )
				lRet := .F.
				nOpca:= 0
				disarmTransaction()
			Else
				// Processa Gatilhos
				EvalTrigger()
				If __lSX8
					ConfirmSX8()
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se a funcao estiver sendo executada via MATA185, esta funcao         ³
				//³atualizara as demais tabelas dentro da mesma transacao (SCQ/SCP/SB2) ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If l185
					If !A185AtuSCQ(SD3->D3_DOC, aD3NumSeq[ 2 ] )
						nOpca:= 0
						lRet := .F.
						disarmTransaction()
					EndIf
				EndIf

				If lIntegDef
					SD3->(DbSetOrder(2))
					If	SD3->(DbSeek(xFilial("SD3")+cDocumento))
						aRetInt := FwIntegDef( "MATA241",,,,"MATA241" )
						If Valtype(aRetInt) == "A"
							If Len(aRetInt) == 2
								If !aRetInt[ 01 ]
									disarmTransaction()
									Help( Nil, Nil, STR0055, Nil, aRetInt[ 02 ], 1, 0, Nil, Nil, Nil, Nil, Nil, { STR0056 } )
									nOpcA:= 0
								Endif
							Endif
						EndIf
					EndIf
				EndIf
			EndIf
			End Transaction

			//Tratamento Realizado para Estornar Mov. Interno Gerado via A241Inclui com Adapter Config como Sincrono
			If lIntegDef .And. ( Valtype(aRetInt) == "A" .And. Len(aRetInt) == 2 .And. !aRetInt[ 01 ] )
				If SD3->(DbSeek(xFilial("SD3") + cDocumento ) )
					l241Auto := .T.
					A241Estorn( 'SD3', SD3->( RecNo() ), 6 )
					l241Auto := .F.
				EndIf
			EndIf

			If lRet
				If lChangeDoc  //-- No. do Documento foi alterado
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se a funcao estiver sendo executada via MATA185, esta mensagem ³
					//³sera exibida no MATA185 (fora da Transacao)                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !l185 .And. !l241Auto
						Help("",1,"A240DOC",,cDocumento,4,30)
					EndIf
					cNewDoc := cDocumento
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoFinLan("000151")

				If lMT241SD3
					ExecBlock("MT241SD3",.F.,.F.)
				End

				//Somente executa as ordens de serviço do WMS, após a transação
				//Pois a execução dos serviços no WMS tem transação própria
				If IntWMS() .And. !lWmsNew .Or. (lWmsNew .And. !lWmsSD3)
					WmsExeServ()
				EndIf

				If lLogMov .And. Len(aLogSld) > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprimir Relatorio de Movimentos nao realizados por falta de saldo ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					RelLogMov(aLogSld)
				EndIf
		  EndIf
	ElseIf __lSX8
		RollBackSX8()
	EndIf

	If nOpca == 0 .And. lMT241CAN
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para tratamento especifico do usuario ³
		//³ no momento do Cancelamento                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ExecBlock('MT241CAN', .F., .F.)
	EndIf

	Exit
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desativa tecla F4                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F4 to

dbSelectArea("SF5")
dbClearFilter()
dbGoTop()
SetCursor(0)
dbSelectArea(cAlias)
Return nOpca


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a241AfterC³ Autor ³ Ricardo Berti         ³ Data ³ 22/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tratamento de excecoes na montagem automatica do aCols pela³±±
±±³          ³ FillGetDados, executada APOS gerar cada elemento do aCols. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpL1:=a241AfterC(ExpN1,ExpA1,ExpC1,ExpA2,ExpA3,ExpA4,ExpL1)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Numero da opcao selecionada                        ³±±
±±³          ³ ExpA1 = aCols (passado por ref.)                           ³±±
±±³          ³ ExpC1 = Alias do arq. principal                            ³±±
±±³          ³ ExpA2 = Array c/ dados de SD3 p/ tratamento de Dead-Lock   ³±±
±±³          ³ ExpA3 = Array c/ dados de SB2 p/ tratamento de Dead-Lock   ³±±
±±³          ³ ExpA4 = Array c/ dados de SB3 p/ tratamento de Dead-Lock   ³±±
±±³          ³ ExpL1 = Variavel que indica se o movimento esta sem docum. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 = .F. aborta a FillGetDados (montagem do aCols)  	  ³±±
±±³          ³         .T. continua a montagem do aCols pela FillGetDados ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA241                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a241AfterC(nOpc,aColsX,cAlias,aLockSB2,aLockSB3,aLockSD3,lEmBranco)

Local nPosDesc :=0
Local nPosCod	 :=0
Local nPos		 :=0

Default lEmBranco := .F.

If nOpc == 3	// Inclusao
		nPos := Ascan(aHeader,{|x| Alltrim(x[2])=="D3_DTVALID"})
		If nPos > 0
			aColsX[1][nPos] := dDataBase
		EndIf
Else 	// Visualizacao / Estorno

	If nOpc <> 2	// Estorno
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para Dead-Lock                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aScan(aLockSD3,SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_NUMSEQ)==0
			aAdd(aLockSD3,SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_NUMSEQ)
		EndIf
		If aScan(aLockSB2,SD3->D3_COD+SD3->D3_LOCAL)==0
			aAdd(aLockSB2,SD3->D3_COD+SD3->D3_LOCAL)
		EndIf
		If aScan(aLockSB3,SD3->D3_COD)==0
			aAdd(aLockSB3,SD3->D3_COD)
		EndIf

		nPos := Ascan(aHeader,{|x| Alltrim(x[2])=="D3_ESTORNO"})
		If aHeader[nPos,10] # "V"
			aColsX[Len(aColsX)][nPos] := "S"
		EndIf
	EndIf

	nPosDesc := Ascan(aHeader,{|x| Alltrim(x[2])=="D3_DESCRI"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche descricao do produto no campo virtual       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nPosDesc > 0
		nPosCod := Ascan(aHeader,{|x| Alltrim(x[2])=="D3_COD"})
		If SB1->(dbSeek(xFilial("SB1")+aColsX[Len(aColsX),nPosCod]))
			aColsX[Len(aColsX),nPosDesc]:= SB1->B1_DESC
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Integracao com o Modulo de Transporte (TMS)                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IntTMS()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se foi informado Rateio de Viagem/Veiculo ou Rateio ³
		//³ de Frota para o Item                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		a241VerSDG(SD3->D3_NUMSEQ,Len(aColsX))
		dbSelectArea( cAlias )
	EndIf
	If Empty(SD3->D3_DOC)
		lEmBranco:=.T.
	EndIf
EndIf
Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a241AfterH³ Autor ³ Ricardo Berti         ³ Data ³ 29/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao executada APOS gerar aHeader, antes da FillGetDados ³±±
±±³          ³ criar os campos do Walk-Thru, para adicao de novos campos  ³±±
±±³          ³ neste.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ a241AfterH(ExpN1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array aHeader passado por ref.                     ³±±
±±³          ³ ExpN1 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA241                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a241AfterH(aHeaderX,nOpc)
Local nInd		:= 0
Local aAuxHead	:= {}
Local lAdD3Ident:= ( Type( "lSeloFiscal" ) == "L" .And. lSeloFiscal )
Local aVldCpo	:= { { "D3_LOTECTL", .T. }, { "D3_DESCRI", .T. }, { "D3_IDENT", lAdD3Ident } }
Local aCpos 	:= { "", "X3_CAMPO", "X3_PICTURE", "X3_TAMANHO", "X3_DECIMAL", "X3_VALID", "X3_USADO", "X3_TIPO", "X3_ARQUIVO", "X3_CONTEXT" }
Local bGetSx3	:= { | x,y | GetSx3Cache( x, y ) }

If nOpc == 3 .Or. l185	// Inclusao
	If l241Auto
		For nInd := 1 To Len( aVldCpo )
			If aVldCpo[ nInd ][ 2 ]
				aAuxHead := {}
				If Ascan(aHeaderX,{|x| Alltrim(x[2] )== aVldCpo[ nInd ][ 1 ] } ) == 0 .And. !Empty( Eval( bGetSx3, aVldCpo[ nInd ][ 1 ], "X3_TITULO" ) )
					AEval( aCpos, { | x | Aadd( aAuxHead, IIf( Empty( x ), AllTrim( X3Titulo() ), Eval( bGetSx3, aVldCpo[ nInd ][ 1 ], x ) ) ) } )
					Aadd( aHeaderX, AClone( aAuxHead ) )
				EndIf
			EndIf
		Next nInd
	EndIf

	If l185
		If Ascan(aHeaderX,{|x| Alltrim(x[2])=="D3_NUMSA"}) == 0
			AADD(aHeaderX,{ STR0031	, "D3_NUMSA"	, "@!",	10, 0, Nil, Nil, "C", "SD3", Nil }) //"Numero SA"
		EndIf
		If Ascan(aHeaderX,{|x| Alltrim(x[2])=="D3_ITEMSA"}) == 0
			AADD(aHeaderX,{ STR0032	, "D3_ITEMSA"	, "@!",	10, 0, Nil, Nil, "C", "SD3", Nil }) //"Item SA"
		EndIf
	EndIf
EndIf

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A241ChkSX3³ Autor ³Marcos V. Ferreira      ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida o campo de acordo com o X3_VALID                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Campo a ser validado de acordo com o X3_VALID       ³±±
±±³          ³ ExpC2 = Se .T. utilizar inicializador padrao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA241                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A241ChkSX3(cCampo,cIniVar)
Local lRet	:= .T.
Local cVar	:= Nil
Local cValid:= Nil
Local aArea	:= GetArea()
Default cIniVar	:= ''

cVar	:= "M->" + cCampo
cValid 	:= IIf( !Empty( GetSx3Cache( cCampo, "X3_VALID" ) ), AllTrim( GetSx3Cache( cCampo, "X3_VALID" ) ), "" ) + IIf( !Empty( GetSx3Cache( cCampo, "X3_VLDUSER" ) ), " .And. " + AllTrim( GetSx3Cache( cCampo, "X3_VLDUSER" ) ), "" )

If Empty( cIniVar )
	&cVar  := &(ReadVar())
Else
	&cVar	 := cIniVar
EndIf

If !Empty( cValid )
	lRet := &( cValid )
EndIf

RestArea( aArea )
Return lRet



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A241Data ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 31/10/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a data em relacao a data do Ultimo fechamento       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA241                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A241Data()
Local dDataFec := MVUlmes()
Local lRet:=.T.,lBackRet:=.T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a existencia do ponto de Entrada MTA241I                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lMta241I := (ExistBlock("MTA241I"))
If dDataFec >= &(ReadVar())
	Help ( " ", 1, "FECHTO" )
	lRet:=.F.
EndIf
If lRet .And. lMta241I
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa Ponto de Entrada                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lBackRet:=lRet
	lRet:=ExecBlock("MTA241I",.F.,.F.)
	If ValType(lRet) != "L"
		lRet:=lBackRet
	EndIf
EndIf
Return lRet



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a241Grava ³ Autor ³ Gilson Nascimento     ³ Data ³04/05/95  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gravar os dados no arquivo                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero da opcao selecionada                        ³±±
±±³          ³ ExpL1 = Valida se o no. do documento sera alterado         ³±±
±±³          ³ ExpA1 = Campos do Cabecalho implementados pelo PE:MT241CAB ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mata241                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a241Grava(cAlias,nOpcao,lChangeDoc,aCpoUsu)
Local lRet			:= .T.
Local n
Local nY           := 0
Local nMaxArray
Local nCntItem     := 1
Local aAnterior    := {}
Local nCntDel      := 0
Local nOrder
Local nX
Local cItem
Local cMay         := ''
Local aRegSD3      := {}
Local aLockSB2     := {}
Local aLockSB3     := {}
Local lIntGH       := SuperGetMV("MV_INTGH",.F.,.F.)
Local lFirstNum    := .T.
Local lPimsInt     := SuperGetMV("MV_PIMSINT",.F.,.F.)
Local aCMNF			:= {0,0,0,0,0}
Local lCAT83		:= FindFunction("V240CAT83") .And. V240CAT83()
Local cNumseq		:= ""
Local nPosIdent   := 0
Local aEndereco   := {}
Local lHSGrvGaj   := FindFunction("HS_GRVGAJ")
Local aItenSD3		:= {}
Local cCF         := ""
Local cAproPri    := "0"
Local nPosIdDCF   := 0
Local nPosNumSeq  := 0
Local lWmsNew     := SuperGetMV("MV_WMSNEW",.F.,.F.)
Local lWmsSD3     := Iif(Type('lExecWms')=='L', lExecWms, .F.)
Local aAuxRet			:= {}
Local nPosSeq			:= 0
Local cPosNumSa   := ""
Local cPosItemSa  := ""

Local lCpoUser   := ExistBlock('CPOSDH1')
Local aCpoUser   := {}
Local aCpoAuxUsr := {}
Local nPosAux    := 0
Private cNewItSDG  := "" // Variavel utilizada pelo programa Mata103

// -- Protecao quando rotina for executada em modo automatico
If Type("cA240End") == "U"
	Private cA240End   := CriaVar('DB_LOCALIZ')
EndIf

If Type("aCtbDia") == "U"
   Private aCtbDia := {}
EndIf

Default lChangeDoc := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o ultimo elemento do array esta em branco        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxArray := Len(aCols)
If Empty(aCols[nMaxArray,nPosCod]) .And. Empty(aCols[nMaxArray,nPosQuant])
	nMaxArray--
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se durante a digitacao n„o foi incluido um documento³
//³ com o mesmo numero por outro usu rio.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !l241Auto
	dbSelectArea(cAlias)
	nOrder:=IndexOrd()
	dbSetOrder(2)
	dbSeek(xFilial()+cDocumento)
	cMay := "SD3"+Alltrim(xFilial())+cDocumento
	lFirstNum :=.T.
	While D3_FILIAL+D3_DOC==xFilial()+cDocumento.Or.!MayIUseCode(cMay)
		If D3_ESTORNO # "S"
			If lFirstNum
				cDocumento := NextNumero("SD3",2,"D3_DOC",.T.)
				cDocumento := A261RetINV(cDocumento)
				lFirstNum :=.F.
			Else
				cDocumento := Soma1(cDocumento)
			EndIf
			lChangeDoc := .T.
			cMay := "SD3"+Alltrim(xFilial())+cDocumento
		EndIf
		dbSkip()
	EndDo
	dbSetOrder(nOrder)
	
	If lWMSNew .And. !lWmsSD3
		dbSelectArea("DH1")
		DH1->(dbSetOrder(2))
		If DH1->(dbSeek(xFilial("DH1")+cDocumento))
			cDocumento := NextNumero("DH1",2,"DH1_DOC",.T.)
			cMay := "SD3"+Alltrim(xFilial())+cDocumento
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento para Dead-Lock                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX:=1 to Len(aCols)
	If aScan(aLockSB2,aCols[nX][nPosCod]+aCols[nX][nPosLocal])==0
		aAdd(aLockSB2,aCols[nX][nPosCod]+aCols[nX][nPosLocal])
	EndIf
	If aScan(aLockSB3,aCols[nX][nPosCod])==0
		aAdd(aLockSB3,aCols[nX][nPosCod])
	EndIf
Next nX
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento para Dead-Lock                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MultLock("SB2",aLockSB2,1) .And. MultLock("SB3",aLockSB3,1)
	For nx := 1 to nMaxArray
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ verifica se nao esta deletado (DEL)                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !aCols[nx][Len(aCols[nx])]
			If A241LinOk(nil,nx)
				If lWmsSD3
					nPosNumSeq := aScan(aAutoItens[nx], {|x| AllTrim(x[1]) == "D3_NUMSEQ"})
					cNumseq    := aAutoItens[nx][nPosNumSeq][2]
				Else
					cNumseq := ProxNum() //Pega o numero sequencial do movimento
				EndIf

				// Integração WMS - Busca endereço
				If !lWmsSD3 .And. IntWMS(aCols[nx,nPosCod]) .And. !Empty(aCols[nx,nPosServic]) .And. !(Type('cA240End')=='U')
					a240Ender(aCols[nx,nPosLocal],aCols[nx,nPosCod],aCols[nx,nPosQuant],cNumseq,cTm,aEndereco)
				EndIf
				// Verifica se produto controla WMS
				If lWMSNew .And. !lWmsSD3 .And. (cTm > '500') .And. IntWMS(aCols[nx,nPosCod]) .And. !Empty(aCols[nx,nPosServic])

					cCF:= A240GeraCF(cAproPri,aCols[nx,nPosCod],cTM,aCols[nx,nPosOp]) //-- Retorna D3_CF

					aAdd(aItenSD3,{})
					aAdd(aItenSD3[Len(aItenSD3)],xFilial("DH1"))
					aAdd(aItenSD3[Len(aItenSD3)],cTM)
					aAdd(aItenSD3[Len(aItenSD3)],dA241Data)
					aAdd(aItenSD3[Len(aItenSD3)],cNumseq)
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosCod])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosLotCTL])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosLocal])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosLocali])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosQuant])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosQtSegUm])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosTrt])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosProj])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosTarefa])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosClVl])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosServic])
					aAdd(aItenSD3[Len(aItenSD3)],cCC)
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosConta])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosItemCT])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosStatus])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosOp])
					If nPosNumSa > 0 //-- FieldPos
						aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosNumSa])
					Else
						aAdd(aItenSD3[Len(aItenSD3)],"")
					EndIf
					If nPosItemSa > 0 //-- FieldPos
						aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosItemSa])
					Else
						aAdd(aItenSD3[Len(aItenSD3)],"")
					EndIf
					aAdd(aItenSD3[Len(aItenSD3)],cDocumento)
					aAdd(aItenSD3[Len(aItenSD3)],cCF)
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosLote])
					aAdd(aItenSD3[Len(aItenSD3)],aCols[nx,nPosNumSer])
					If nPosCusto1 > 0
						AADD(aItenSD3[Len(aItenSD3)], aCols[nx,nPosCusto1]) //D3_CUSTO1
					Else
					   	AADD(aItenSD3[Len(aItenSD3)], 0)	//D3_CUSTO1
					EndIf   	
					If nPosCusto2 > 0
						AADD(aItenSD3[Len(aItenSD3)], aCols[nx,nPosCusto2])	//D3_CUSTO2
					Else
						AADD(aItenSD3[Len(aItenSD3)], 0)	//D3_CUSTO2
					Endif
					If nPosCusto3 > 0
						AADD(aItenSD3[Len(aItenSD3)], aCols[nx,nPosCusto3])	//D3_CUSTO3
					Else
						AADD(aItenSD3[Len(aItenSD3)], 0)	//D3_CUSTO3
					Endif
					If nPosCusto4 > 0
						AADD(aItenSD3[Len(aItenSD3)], aCols[nx,nPosCusto4])	//D3_CUSTO4
					Else
						AADD(aItenSD3[Len(aItenSD3)], 0)	//D3_CUSTO4
					Endif
					If nPosCusto5 > 0
						AADD(aItenSD3[Len(aItenSD3)], aCols[nx,nPosCusto5])	//D3_CUSTO5
					Else
						AADD(aItenSD3[Len(aItenSD3)], 0)	//D3_CUSTO5
					Endif
					AADD(aItenSD3[Len(aItenSD3)], aCols[nx,nPosDValid])//D3_DTVALID
					AADD(aItenSD3[Len(aItenSD3)], aCols[nx,nPosPotenc])//D3_POTENCI
					
					If lCpoUser
						aCpoUser := ExecBlock('CPOSDH1',.F.,.F.,{"MATA241",nX})
						If ValType(aCpoUser) == 'A'
							aADD(aCpoAuxUsr,{})
							nPosAux := Len(aCpoAuxUsr)
							For nY := 1 to Len(aCpoUser)
								aADD(aCpoAuxUsr[nPosAux],{aCpoUser[nY,1],aCpoUser[nY,2]})
							Next nY
						EndIf
					EndIf
			Else
					RecLock(cAlias,.T.)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza dados padroes da movimentacao interna           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SD3->D3_DOC:= cDocumento
					SD3->D3_EMISSAO := dA241Data
					SD3->D3_FILIAL :=xFilial("SD3")
					SD3->D3_TM:= cTM
					SD3->D3_CC:= cCC
					aAdd(aRegSD3,SD3->(Recno()))
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza dados do corpo da movimentacao interna          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nY := 1 to Len(aHeader)
						If aHeader[nY][10] # "V"
							xVar := Trim(aHeader[nY][2])
							If AllTrim(xVar) != "D3_CC" .Or. (!Empty(aCols[nx,nY]))
								Replace &xVar With aCols[nx][nY]
							EndIf
						EndIf
					Next nY
					If l241Auto
						nPosIdent := aScan(aAutoItens[nx], {|x| AllTrim(x[1]) == "D3_IDENT"})
						If nPosIdent > 0
							SD3->D3_IDENT:= aAutoItens[nx][nPosIdent][2]
						EndIf
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza B2_QEMPSA - Pre-Requisicao                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					A185BxEmp(nX)					

					//Gera Ativo
					aCMNF := {0,0,0,0,0}
					If SF5->(MsSeek(xFilial("SF5")+cTm))
						If SF5->(FieldPos("F5_GERAATF"))> 0 .And. SF4->(MsSeek(xFilial("SF4")+SF5->F5_TEATF))
							If SF5->F5_GERAATF == "1"
								A241AvalATF(SF4->F4_BENSATF == "1",SF4->F4_COMPONE == "1",,cNumseq,@aCMNF)
							EndIf
						EndIf
					EndIf
					If l241Auto .And. lWmsSD3
						If nPosLotCTL > 0
							SD3->D3_LOTECTL := aAutoItens[nx][nPosLotCTL][2]
						EndIf
						If nPosLote > 0
							SD3->D3_LOCALIZ := aAutoItens[nx][nPosLote][2]
						EndIf
						If nPosLocali > 0
							SD3->D3_LOCALIZ := aAutoItens[nx][nPosLocali][2]
						EndIf
						nPosIdDCF := aScan(aAutoItens[nx], {|x| AllTrim(x[1]) == "D3_IDDCF"})
						If nPosIdDCF > 0 .And. SD3->(FieldPos("D3_IDDCF")) > 0
							SD3->D3_IDDCF   := aAutoItens[nx][nPosIdDCF][2]
						EndIf
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Envia p/func. de atualizacoes (SD3,SB2,SB3,SC2,..) ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					a240Atu(NIL,nx,,cNumseq,aCMNF)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Gravacao da CAT83                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lCAT83 .And. Empty(SD3->D3_CODLAN)
						SD3->D3_CODLAN := A240CAT83()
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Integracao TMS                                                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If IntTMS() .And. (Len(aRatVei)>0  .Or. Len(aRatFro)>0)
						If Type("nHdlPrv") <> "N"	.And. Type("lCtbOnLine") <> "L"
							lCtbOnLine := .F.
							nHdlPrv    := 0
							nTotal     := 0
							cLoteEst   := ''
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se o Item da NF foi rateado por Veiculo/Viagem ou por Frota    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cItem  := StrZero(nx,Len(SDG->DG_ITEM))
						nItRat := aScan(aRatVei,{|x| x[1] == cItem})
						If nItRat > 0
							cTpRateio := "V"
							A103GrvSDG('SD3',aRatVei,cTpRaTeio,cItem,lCtbOnLine,nHdlPrv,@nTotal,cLoteEst,"MATA241")
						Else
							nItRat := aScan(aRatFro,{|x| x[1] == cItem})
							If nItRat > 0
								cTpRateio := "F"
								A103GrvSDG('SD3',aRatFro,cTpRateio,cItem,lCtbOnLine,nHdlPrv,@nTotal,cLoteEst,"MATA241")
							EndIf
						EndIf
					EndIf

				    If lIntGH .And. lHSGrvGaj
						If If(Type("__lMovest") <> "U", __lMovest, .F.)
							HS_GRVGAJ(,nx, SD3->D3_NUMSEQ, SD3->D3_DOC)
						Endif
					EndIf
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cria array com os movimentos dos Produtos sem saldos         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lLogMov
					LogSaldo(aCols[nx,1],aCols[nx,15],aCols[nx,2],aCols[nx,6],aCols[nx,3],;
					aCols[nx,17],aCols[nx,18],aCols[nx,19],aCols[nx,20],aCols[nx,21],;
					@aLogSld,cDocumento,dA241Data)
				EndIf
				lRet := .F.
				Exit
			EndIf
		EndIf

		If lRet
			//Tratamento para Inclusao da Chave Doc + NumSeq para ser Utilizado na funcao A185AtuSCQ
			If IntWMS(aCols[nx,nPosCod])
				//No caso do WMS deve-se utilizar as informações das variáveis para preencher o array, visto que não foi gerada a SD3 neste momento
				cPosNumSa := Iif(nPosNumSa > 0,aCols[nx,nPosNumSa],"")
				cPosItemSa := Iif(nPosItemSa > 0,aCols[nx,nPosItemSa],"")
				nPosSeq := Ascan( aAuxRet, { | x | AllTrim( x[ 1 ] ) == AllTrim( cDocumento ) .And. AllTrim( x[ 2 ] ) == AllTrim( cNumseq ) .And. AllTrim( x[ 3 ] ) == AllTrim( aCols[nx,nPosCod] ) .And. AllTrim( x[ 4 ] ) == AllTrim( aCols[nx,nPosLocal] ) .And. AllTrim( x[ 5 ] ) == AllTrim( cPosNumSa ) .And. AllTrim( x[ 6 ] ) == AllTrim( cPosItemSa ) } )
				If nPosSeq == 0
					Aadd( aAuxRet,{ cDocumento, cNumseq, aCols[nx,nPosCod], aCols[nx,nPosLocal], cPosNumSa, cPosItemSa} )
				EndIf		
			Else
				nPosSeq := Ascan( aAuxRet, { | x | AllTrim( x[ 1 ] ) == AllTrim( SD3->D3_DOC ) .And. AllTrim( x[ 2 ] ) == AllTrim( SD3->D3_NUMSEQ ) .And. AllTrim( x[ 3 ] ) == AllTrim( SD3->D3_COD ) .And. AllTrim( x[ 4 ] ) == AllTrim( SD3->D3_LOCAL ) .And. AllTrim( x[ 5 ] ) == AllTrim( SD3->D3_NUMSA ) .And. AllTrim( x[ 6 ] ) == AllTrim( SD3->D3_ITEMSA ) } )
				If nPosSeq == 0
					Aadd( aAuxRet,{ SD3->D3_DOC, SD3->D3_NUMSEQ, SD3->D3_COD, SD3->D3_LOCAL, SD3->D3_NUMSA, SD3->D3_ITEMSA } )
				EndIf
			EndIf
		EndIf

	Next nx

	If Len(aItenSD3) > 0
		EspDH1Wms(aItenSD3,"MATA241",cA240End,,,aCpoAuxUsr)
		ADEL(aItenSD3[1],1)
		ASIZE(aItenSD3[1],1)
		aItenSD3[1] := {}
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao de campos da Guia de Abate - Portugal		   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc =="PTG" .And. nOpca == 1 .And. SF5->F5_PERDA$"OB|EX"
		cNGuia:=A240NGUIA(SD3->D3_TM,.T.)
		For nX := 1 To Len(aRegSD3)
			SD3->(MsGoTo(aRegSD3[nX]))
			RecLock("SD3",.F.)
			Replace D3_STATUS With SF5->F5_PERDA
			Replace SD3->D3_NRABATE With cNGuia
		Next nx
	EndIf
	FreeUsedCode()

	If lMT241GRV
		ExecBlock("MT241GRV",.F.,.F.,{cDocumento,aCpoUsu})
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o custo medio e' calculado On-Line               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cCusMed == "O"
		If !lCriaHeader .And. nTotal > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa perguntas deste programa                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ mv_par01 - Se mostra e permite digitar lancamentos contabeis   ³
			//³ mv_par02 - Se deve aglutinar os lancamentos contabeis          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Pergunte("MTA240",.F.)
			lDigita   := Iif(mv_par01 == 1,.T.,.F.)
			lAglutina := Iif(mv_par02 == 1,.T.,.F.)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se ele criou o arquivo de prova ele deve gravar o rodape'    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RodaProva(nHdlPrv,nTotal)

			If !Empty(aCtbDia)
				cCodDiario := CtbaVerdia()
				For nX := 1 to Len(aCtbDia)
					aCtbDia[nX][3] := cCodDiario
				Next nX
			EndIf

			If cA100Incl(cArquivo,nHdlPrv,3,cLoteEst,lDigita,lAglutina,,,,,,aCtbDia)
				lCriaHeader := .T.
				nTotal      := 0 // Total dos lancamentos contabeis

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava a data de Contabilizacao do campo D3_DTLANC         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nX := 1 To Len(aRegSD3)
					SD3->(MsGoTo(aRegSD3[nX]))
					RecLock("SD3",.F.)
					Replace D3_DTLANC With dDataBase
					MsUnLock()
				Next nX
			EndIf

		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 	Integracao com PIMS				³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SuperGetMV("MV_PIMSINT",.F.,.F.))
			PIMSCtOnline(aRegSD3)
		EndIf

	EndIf

Else
	ConOut("WARNING: DEADLOCK CONTROL IS ON")
	lRet := .F.
EndIf

Return { lRet , aAuxRet }

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A241LinOk ³ Autor ³ Rosane L. Chene       ³ Data ³ 05/10/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa que faz consistencias apos a digitacao da tela    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA240                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Variavel Objeto	                                  ³±±
±±³          ³ ExpN1 = Numero da variavel n referente ao aCols            ³±±
±±³          ³ ExpL1 = Se .T. analisa se ha qtde disponivel em estoque    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A241LinOk(o,nx,lVldQtd)
Local lRet       := .T.
Local lSai       := .F.
Local cAlias     := "SD3"
Local nOrdSB8
Local nRecSB8
Local cLocal
Local i
Local nQtd       := 0
Local nSaldo     := 0
Local lBaixaEmp  := .F.
Local lBxEmpB8   := .F.
Local lQtdZero   := .F.
Local cTrt       := ""
Local lMov       := If(nx==Nil,.T.,.F.)
Local lEmpPrj    := .F.
Local nQtdPrj    := 0
Local nXZ        := 0
Local cProcName  := Upper( AllTrim( ProcName(1) ) )
Local lEmpPrev   := If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
Local lVldAlmo   := GetMV("MV_VLDALMO") == "S"
Local cSeek	   	 := ""
Local lGrade     := MaGrade()
Local lReferencia:= .F.
Local cPROJPMS   := ""
Local cTASKPMS   := ""
Local nPosCod	 := aScan(aHeader,{|x| AllTrim(x[2])=="D3_COD"})
Local nPosLocal  := aScan(aHeader,{|x| AllTrim(x[2])=="D3_LOCAL"})
Local nRevisao   := aScan(aHeader,{|x| AllTrim(x[2])=="D3_REVISAO"})
Local nLocaliz   := aScan(aHeader,{|x| AllTrim(x[2])=="D3_LOCALIZ"})
Local nPConta		:= GDFieldPos("D3_CONTA")
Local nPItemCta		:= GDFieldPos("D3_ITEMCTA")
Local nPCLVL		:= GDFieldPos("D3_CLVL")
Local lRevProd   := SuperGetMv("MV_REVPROD",.F.,.F.)
Local cRvSB5	 := ""
Local cBlqSG5	 := ""
Local cStatus    := ""
Local lMata340   := IsInCallStack("MATA340")
Local lWmsNew    := SuperGetMv("MV_WMSNEW",.F.,.F.)
Local lWmsSD3    := Iif(Type('lExecWms')=='L', lExecWms, .F.)
Local lPrdIntWms := .F.
Local cLocProc	:= GetMvNNR('MV_LOCPROC','99')
Local lDAmarCt	 := SuperGetMV("MV_DAMARCT",.F.,.F.)

Default lVldQtd  := .F.

// Impede a inclusao de movimento com TM inexistente
If !lMata340 
	If SF5->F5_FILIAL+SF5->F5_CODIGO # xFilial("SF5")+cTm
		If !SF5->(MsSeek(xFilial("SF5")+cTm))
			Help(" ",1,"REGNOIS")
			Return .F.
		EndIf
	EndIf
EndIf

// Seta variavel n para valor de nx
If Valtype(nx) == "N"
	n:=nx
EndIf

lPrdIntWms := IntWMS(aCols[n,nPosCod])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o produto est  em revisao vigente e envia para armazem de CQ para ser validado pela engenharia    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRevProd .And. !GDdeleted(n)

	cRvSB5 := Posicione("SB5",1,xFilial("SB5")+aCols[n,nPosCod],"B5_REVPROD")
	cBlqSG5:= Posicione("SG5",1,xFilial("SG5")+aCols[n,nPosCod]+aCols[n,nRevisao],"G5_MSBLQL")
	cStatus:= Posicione("SG5",1,xFilial("SG5")+aCols[n,nPosCod]+aCols[n,nRevisao],"G5_STATUS")
    If cRvSB5=="1"
	    If Empty(cRvSB5)
			Aviso(STR0014,STR0048,{STR0051})//"Não foi encontrado registro do produto selecionado na rotina de Complemento de Produto."
			lRet:= .F.
		ElseIf Empty(cBlqSG5)
			Aviso(STR0014,STR0049,{STR0051})//"O produto selecionado não possui revisão em uso. Verifique o cadastro de Revisões."
			lRet:= .F.
		ElseIf cBlqSG5=="1"
			Help(" ",1,"REGBLOQ")
			lRet:= .F.
		ElseIf cStatus=="2" .AND. cTM<"500"
			Aviso(STR0014,STR0050,{STR0051})//"Esta revisão não pode ser alimentada pois está inativa."
			lRet:= .F.
		EndIf
	EndIf
EndIf

If lRet .And. IntePMS() .And. FindFunction('VldMovPMS')
	lRet := VldMovPMS(aCols[n,nPosProj], aCols[n,nPosTarefa], cTm, aCols[n,nPosCod], aCols[n,nPosQuant], "MATA241") 
EndIf
//Validacao de permissao do armazem
If !lMata340 .And. lRet .And. !GDdeleted(n)
	lRet := MaAvalPerm(3,{aCols[n][nPosLocal],aCols[n][nPosCod]})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o armazem está bloqueado.   ³
//ÀÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .and. !GDdeleted(n) .And. !ExistCpo("NNR",aCols[n][nPosLocal]) 
	lRet := .F.
EndIf

If lRet .And. !Empty(aCols[n,nPosOp]) .And. !("OS001" $ aCols[n,nPosOp])
	SC2->(DbSetOrder(1)) // FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
	If SC2->(dbSeek(xFilial("SC2") + aCols[n,nPosOp])) .And. !Empty(SC2->C2_DATRF)
		Help(" ",1,"OPENCERR")
		lRet := .F.
	EndIf
EndIf

//-- Posiciona SB1 para validacoes
SB1->(MsSeek(xFilial("SB1")+aCols[n,nPosCod]))
//Bloqueia produto fantasma 
IIf(lRet,lRet := A241VLDFan(aCols[n,nPosCod]),lRet)

If lRet .And. !GDdeleted(n) .And. (lRet:=MaCheckCols(aHeader,aCols,n))
	For nxZ = 1 To Len(aHeader)
		If Empty(aCols[n][nxZ])
			If Trim(aHeader[nxZ][2]) == "D3_COD" .And. n == Len(aCols)
				Help(" ",1,"A11002")
				lRet := .F.
				lSai:=.T.
			EndIf
			If (Trim(aHeader[nxZ][2]) == "D3_COD" .Or.;
				(Trim(aHeader[nxZ][2]) == "D3_QUANT" .And. SF5->F5_QTDZERO # "1")) .And. !lSai
				Help(" ",1,"A241BRANC",,'"'+' '+aHeader[nxZ][1]+' '+'"',4,3)
				lRet := .F.
			EndIf
		EndIf
		If !lRet
			Exit
		EndIf
	Next

	If lRet .And. Inclui .And. lPrdIntWms .And. !lWmsSD3
		lRet := WmsAvalSD3("6")
	EndIf
	If lRet .And. Inclui
		If !lSai .And. !lMata340
			SB2->(DbSetOrder(1))
			If aCols[n][Len(aCols[n])]
				Return(lRet)
			EndIf
			If lGrade
				cVar:=aCols[n,nPosCod]
				lReferencia := MatGrdPrrf(@cVar)
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Utiliza o parametro MV_VLDALMO para validar o local |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lReferencia
				If lRet .And. lVldAlmo .And. !(SB2->(MsSeek(xFilial("SB2")+aCols[n,nPosCod]+aCols[n,nPosLocal])))
					Help("",1,"A241LOCAL",,aCols[n,nPosCod],2,23)
					lRet := .F.
				EndIf
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o produto est  sendo inventariado.      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lReferencia
				If BlqInvent(aCols[n,nPosCod],aCols[n,nPosLocal],,aCols[n,nPosLocali])
					Help(" ",1,"BLQINVENT",,aCols[n,nPosCod]+OemToAnsi(STR0017)+aCols[n,nPosLocal],1,11) //" Almox: "
					lRet:=.F.
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Analisa se o tipo do armazem permite a movimentacao |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRet .And. AvalBlqLoc(aCols[n,nPosCod],aCols[n,nPosLocal],Nil,,,,,,,aCols[n,nPosOp])
					lRet:=.F.
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se a Qtde estiver em branco ele deve dar uma mensagem  ³
			//³ de que este registro nao sera' gravado.                ³
			//³ Este campo nao pode ficar obrigatorio porque ele e'    ³
			//³ utilizado na Producao(Informacao da Perda de Producao),³
			//³ onde nao deve ser obrigatorio.                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet .And. Empty(aCols[n][nPosQuant]) .And. !lMata340
				If SF5->(MsSeek(xFilial("SF5")+cTm))
					If SF5->F5_QTDZERO # "1"
						Help(" ",1,"MA240NAOGR")
						lRet := .F.
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Validacao para nao permitir que usuario informe os campos       |
						//|LOTE/SUB-LOTE quando quando a qtde. informada e' igual a zero.  |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ElseIf ( !Empty(nPosLotCTL).And.!Empty(aCols[n,nPosLotCTL]) .Or. ;
						!Empty(nPosLote).And.!Empty(aCols[n,nPosLote]) )
						Help(" ",1,"A240QLZERO")
						lRet := .F.
					EndIf
				Else
					Help(" ",1,"MA240NAOGR")
					lRet := .F.
				EndIf
			EndIf

			dbSelectArea("SF5")
			If !lMata340 .And. MsSeek(xFilial("SF5")+cTM)
				lQtdZero:=Empty(aCols[n][nPosQuant]) .And. SF5->F5_QTDZERO == "1"

				cPROJPMS := iIf(Empty(nPosProj), CriaVar("D3_PROJPMS"), aCols[n,nPosProj])
				cTASKPMS := iIf(Empty(nPosTarefa), CriaVar("D3_TASKPMS"), aCols[n,nPosTarefa])

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso esteja baixando empenho verifica o saldo empenhado³
				//³ a fim de evitar divergencia entre o movimento no SD3 e ³
				//³ os movimentos no SD5 e SDB.                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			  If !lReferencia
					lEmpPrj  := ( !Empty(cPROJPMS) .And. ;
								  !Empty(cTASKPMS) )
					lBaixaEmp:=SF5->F5_ATUEMP == "S" .And. ( !Empty(If(Empty(nPosOp),CriaVar("D3_OP"),aCols[n,nPosOP])) .OR. lEmpPrj)
					cTrt     :=If(ValType(nPosTRT)=="N" .And. nPosTRT > 0,aCols[n,nPosTrt],CriaVar("D3_TRT"))
					lRet:=lRet .And. A240AvalEm(@lBaixaEmp,aCols[n,nPosCod],aCols[n,nPosLocal],aCols[n,nPosQuant],If(Empty(nPosLotCTL),CriaVar("D3_LOTECTL"),aCols[n,nPosLotCTL]),If(Empty(nPosLote),CriaVar("D3_NUMLOTE"),aCols[n,nPosLote]),If(Empty(nPosLocali),CriaVar("D3_LOCALIZ"),aCols[n,nPosLocali]),If(Empty(nPosNumSer),CriaVar("D3_NUMSERI"),aCols[n,nPosNumSer]),If(Empty(nPosOP),CriaVar("D3_OP"),aCols[n,nPosOp]),cTRT,.T.,cTM<="500",@lBxEmpB8,If(nPosPotenc>0,aCols[n,nPosPotenc],), cPROJPMS, cTASKPMS)
					If ValType(nPosTRT)=="N" .And. nPosTRT > 0 .and. lRet .and. lEmpPrj
						aCols[n,nPosTrt] := cTrt
					EndIf
				Endif
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Validacao para nao permitir que um produto de apropriacao indireta     |
			//| tenha o numero da ordem de producao preenchido.                        |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet .And. !lReferencia
				If (SB1->B1_APROPRI == 'I') .And. (SF5->F5_APROPR != "S") .And. If(Empty(nPosOP),.F.,!Empty(aCols[n,nPosOP]))
					Help("",1,"MA241IND")
					lRet := .F.
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Validacao para nao permitir que um produto de apropriacao indireta     |
				//| tenha movimentacao valorizada (armazem de processo).				   |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRet .And. (SB1->B1_APROPRI == 'I') .And. (SF5->F5_APROPR != "S") .And. (SF5->F5_VAL == "S")
					Help("",1,"A240VALIN")
					lRet := .F.
				EndIf
			Endif

			nQtdPrj := If(lBaixaEmp .And. lEmpPrj, aCols[n,nPosQuant], 0)

			If lRet.and.!lReferencia
				//--> Verifica se o saldo do armazem esta liberado
				lRet := SldBlqSB2(aCols[n,nPosCod],aCols[n,nPosLocal])
			EndIf
			If lRet .And. (GETMV("MV_ESTNEG") != "S" .Or. Localiza(aCols[n,nPosCod],.T.) .Or. Rastro(aCols[n,nPosCod])) .And. !IsProdMod(aCols[n][nPosCod]) .And. !lReferencia
				If cTM > "500"
					dbSelectArea("SB2")
					MsSeek(xFilial("SB2")+aCols[n][nPosCod]+aCols[n][nPosLocal])
					If !lQtdZero .And. QtdComp(aCols[n][nPosQuant]) > QtdComp(SaldoMov(Nil,!lBaixaEmp,Nil,mv_par03==1,If(lBaixaEmp,aCols[n,nPosQuant],Nil),nQtdPrj,Nil, If(Type('dA241Data')=="D",dA241Data,dDataBase),!l185)) + If(l185 .And. GetMv("MV_TPSALDO")=="S",QtdComp(aCols[n][nPosQuant]),0)
						cHelp:=OemToAnsi(STR0016)+AllTrim(B2_COD)+OemToAnsi(STR0017)+B2_LOCAL+OemToAnsi(STR0018)+ALLTRIM(Transform(SaldoMov(Nil,!lBaixaEmp,Nil,mv_par03==1,If(lBaixaEmp,aCols[n,nPosQuant],Nil),nQtdPrj,Nil,If(Type('dA241Data')=="D",dA241Data,dDataBase)),PesqPictQt("B2_QATU",14)))	// Produto Local Saldo Disp.
						Help(" ",1,"MA240NEGAT",,cHelp,4,1)
						lRet := .F.
					EndIf
					If Localiza(aCols[n,nPosCod],.T.)
						// Verifica campos necessarios p/ Localizacao
						If Empty(nPosLocali)
							UserException("D3_LOCALIZ"+OemToAnsi(STR0021))
						EndIf
						If !(lPrdIntWms .And. !Empty(aCols[n,nPosServic]))
							If Empty(aCols[n,nPosLocali]) .And. Empty(aCols[n,nPosNumSer]) .And. !(SF5->F5_QTDZERO=="1" .And. QtdComp(aCols[n,nPosQuant]) == QtdComp(0))
								Help(" ",1,"LOCALIZOBR")
								lRet:=.F.
							EndIf
						EndIf
						If lRet .And. (!Empty(aCols[n,nPosLocali]) .Or. !Empty(aCols[n,nPosNumSer]))
						 	If !(lWmsNew .And. lPrdIntWms)
						 		/*
									Alterada chamada da função SaldoSBF para passar o número da OP.
									Necessário para o projeto de integração TOTVS MES.
								*/
								If QtdComp(SaldoSBF(aCols[n,nPosLocal],aCols[n,nPosLocali],aCols[n,nPosCod],aCols[n,nPosNumSer],aCols[n,nPosLotCTL],aCols[n,nPosLote],lBxEmpB8,,,aCols[n,nPosoP])) < QtdComp(aCols[n,nPosQuant])
									Help(" ",1,"SALDOLOCLZ")
									lRet:=.F.
								EndIf
							Else
								If QtdComp(WmsSldD14(aCols[n,nPosLocal],aCols[n,nPosLocali],aCols[n,nPosCod],aCols[n,nPosNumSer],aCols[n,nPosLotCTL],aCols[n,nPosLote],lBxEmpB8)) < QtdComp(aCols[n,nPosQuant])
									Help(" ",1,"SALDOLOCLZ")
									lRet:=.F.
								EndIf
							EndIf
						EndIf
					EndIf
				Else
					dbSelectArea("SB1")
					MsSeek(xFilial("SB1")+aCols[n,nPosCod])
					If (B1_APROPRI == "I" .And. Empty(If(Empty(nPosOP),CriaVar("D3_OP"),aCols[n,nPosOp]))) .And. SF5->F5_APROPR != "S"
						cApropri := "3"
					Else
						cApropri := "0"
					EndIf
					If cApropri == "3"
						dbSelectArea("SB2")
						If MsSeek(xFilial("SB2")+aCols[n,nPosCod] + cLocProc)
							If cApropri == "3" .And. (QtdComp(SaldoMov(Nil,!lBaixaEmp,Nil,mv_par03==1,Nil,Nil,Nil,If(Type('dA241Data')=="D",dA241Data,dDataBase))) < QtdComp(aCols[n,nPosQuant]))
								Help(" ",1,"MA240PRNEG")
								lRet:=.F.
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se usar Rastreabilidade e o numero do Lote nao for     ³
			//³ preenchido o registro nao sera gravado tambem.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet .And. Rastro(aCols[n][nPosCod]) .And. !lQtdZero .And. !lReferencia
				// Verifica campos necessarios p/ Rastreabilidade
				If Empty(nPosLotCTL)
					UserException("D3_LOTECTL"+OemToAnsi(STR0021))
				EndIf
				If !IsProdMod(aCols[n][nPosCod])
					cLocal := aCols[n][nPosLocal]
					If  cTM <= "500" .And. SF5->F5_APROPR != "S" .And. SB1->B1_APROPRI == "I"
						cLocal := cLocProc
					EndIf
					If cTM > "500" .Or. (SF5->F5_APROPR != "S" .And. SB1->B1_APROPRI == "I")
						If Empty(If(Rastro(aCols[n][nPosCod],"S"),aCols[n][nPosLote],aCols[n][nPosLotCTL]))
							Help(" ",1,"A240NUMLOT")
							lRet := .F.
						EndIf
						If lRet
							dbSelectArea("SB8")
							nOrdSB8 := IndexOrd()
							nRecSB8 := RecNo()
							If Rastro(aCols[n][nPosCod],"S")
								dbSetOrder(2)
								If dbSeek(xFilial("SB8")+aCols[n][nPosLote]+aCols[n][nPosLotCTL]+aCols[n][nPosCod]+cLocal)
									nQtd:=0
									For i:=If(ValType(nx)=="N",nx,1) to Len(aCols)
										If aCols[i][nPosLotCTL]+aCols[i][nPosLote]+aCols[i][nPosCod] == aCols[n][nPosLotCTL]+aCols[n][nPosLote]+aCols[n][nPosCod] .And. !aCols[i][Len(aCols[i])]
											If aCols[i, nPosLocal] == cLocal
												nQtd+=aCols[i][nPosQuant]
											EndIf
										EndIf
									Next i
									If QtdComp(SB8Saldo(lBxEmpB8,nil,nil,nil,nil,lEmpPrev,nil,dA241Data)) < QtdComp(nQtd)
										cHelp:=OemToAnsi(STR0016)+AllTrim(B8_PRODUTO)+OemToAnsi(STR0017)+B8_LOCAL+OemToAnsi(STR0018)+ALLTRIM(Transform(SB8Saldo(nil,nil,nil,nil,nil,lEmpPrev,nil,dA241Data),PesqPictQt("B8_SALDO", 14)))+OemToAnsi(STR0019)+aCols[n][nPosLotCTL] // Produto#Local#Saldo Disp.#Lote
										Help(" ",1,"A240LOTENE",,cHelp,4,1)
										lRet := .F.
									EndIf
								Else
									Help(" ",1,"A240LOTERR")
									lRet := .F.
								EndIf
							Else
								dbSetOrder(3)
								cSeek:=xFilial("SB8")+aCols[n][nPosCod]+cLocal+aCols[n][nPosLotCTL]
								If dbSeek(cSeek)
									nQtd:=0
									For i:=If(ValType(nx)=="N",nx,1) to Len(aCols)
										If aCols[i][nPosLotCTL]+aCols[i][nPosCod] == aCols[n][nPosLotCTL]+aCols[n][nPosCod] .And. !aCols[i][Len(aCols[i])]
											If aCols[i, nPosLocal] == cLocal .Or. (SF5->F5_APROPR != "S" .And. SB1->B1_APROPRI == "I")
												nQtd+=aCols[i][nPosQuant]
											EndIf
										EndIf
									Next i
									nSaldo:=SaldoLote(aCols[n][nPosCod],cLocal,aCols[n][nPosLotCTL],NIL,lBxEmpB8,.T.,nil,dA241Data)
									If QtdComp(nSaldo) < QtdComp(nQtd)
										cHelp:=OemToAnsi(STR0016)+AllTrim(aCols[n][nPosCod])+OemToAnsi(STR0017)+cLocal+OemToAnsi(STR0018)+ALLTRIM(Transform(nSaldo,PesqPictQt("B8_SALDO", 14)))+OemToAnsi(STR0019)+aCols[n][nPosLotCTL] // Produto#Local#Saldo Disp.#Lote
										Help(" ",1,"A240LOTENE",,cHelp,4,1)
										lRet := .F.
									EndIf
								Else
									Help(" ",1,"A240LOTERR")
									lRet := .F.
								EndIf
							EndIf
							dbSetOrder(nOrdSB8)
							MsGoto(nRecSB8)
						EndIf
					Else
						dbSelectArea("SB8")
						nOrdSB8 := IndexOrd()
						nRecSB8 := RecNo()
						If !Empty(If(Rastro(aCols[n][nPosCod],"S"),aCols[n][nPosLote],aCols[n][nPosLotCTL]))
							If Rastro(aCols[n][nPosCod],"S")
								dbSetOrder(2)
								cSeek:=xFilial("SB8")+aCols[n][nPosLote]+aCols[n][nPosLotCTL]+aCols[n][nPosCod]+cLocal
							Else
								dbSetOrder(3)
								cSeek:=xFilial("SB8")+aCols[n][nPosCod]+cLocal+aCols[n][nPosLotCTL]
							EndIf
							If dbSeek(cSeek)
								If Rastro(aCols[n][nPosCod],"S")
									nQtd:=0
									For i:=If(ValType(nx)=="N",nx,1) to Len(aCols)
										If aCols[i][nPosLotCTL]+aCols[i][nPosLote]+aCols[i][nPosCod] == aCols[n][nPosLotCTL]+aCols[n][nPosLote]+aCols[n][nPosCod] .And. !aCols[i][Len(aCols[i])]
											If aCols[i, nPosLocal] == cLocal
												nQtd+=aCols[i][nPosQuant]
											EndIf
										EndIf
									Next i
									If QtdComp(SB8SALDO(,,,,,lEmpPrev,,,.T.) + nQtd) > QtdComp(SB8->B8_QTDORI)
										Help(" ",1,"A240LOTQTD")
										lRet := .F.
									EndIf
								EndIf
							EndIf
							dbSetOrder(nOrdSB8)
							MsGoto(nRecSB8)
						Else
							SB8->( dbSetOrder( 3 ) )
							SB8->( dbSeek( FWxFilial( "SB8" ) + aCols[n][nPosCod] + cLocal + aCols[n][nPosLotCTL] ) )
							dbSetOrder(nOrdSB8)
						EndIf
					EndIf
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se a movimentacao for valorizado e o custo nao for     ³
			//³ preenchido o registro nao sera gravado tambem.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet .And. SF5->F5_VAL=="S"
				IF   nPosCusto1 == 0 .Or.  aCols[n][nPosCusto1] = 0 
					Help(" ",1,"A240VALSD3")
					lRet := .F.
				Endif
			EndIf
		Else
			lRet := .T.
		EndIf

	EndIf
	If !Empty(If(Empty(nPosOp),CriaVar("D3_OP"),aCols[n,nPosOp])) .And. lRet .And. lMov .And. !lReferencia
		If ( l241Auto )
			lRet:= .T.
		Else
			lRet:=A240Alert(aCols[n,nPosCod],If(Empty(nPosOP),CriaVar("D3_OP"),aCols[n,nPosOP]))
		EndIf
	EndIf
	If lRet
		lRet:=A240Data( dA241Data, aCols[n,nPosOP] )
	EndIf
	If lUsaSegUm .And. lRet
		lRet := A240SegUm()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacao para nao permitir que o usuario restaure uma linha    |
	//³ deletada sem antes verificar o saldo disponivel para o produto. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		If lVldQtd .And. SuperGetMV("MV_ESTNEG") == "N"
			M->D3_QUANT	:= aCols[n][nPosQuant]
			lRet:= A240Quant()
		EndIf
	EndIf

	If lRet
		If (AvalMovSelo(aCols[n][nPosCod],cTM))
			Help(" ",1,"SELOFSINC")
			lRet:=.F.
		EndIf
	EndIf

	dbSelectarea(cAlias)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacao do Custo FIFO On-Line                     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. IsFifoOnLine() .And. cTM > "500"
	If SaldoSBD("SD3",aCols[n,nPosCod],aCols[n,nPosLocal],dDataBase,.F.)[1] < aCols[n][nPosQuant]
		Help(" ",1,"DIVFIFO2")
		lRet := .F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada MT241TOK                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. ExistBlock("MT241LOK")
	lRet := ExecBlock("MT241LOK",.F.,.F.,{n})
	If ValType(lRet) # "L"
		lRet:=.T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa lancamento de validacao, quando a integracao com PCO estah ligada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. !GDdeleted(n)
	If cProcName # "A241GRAVA" .And. cProcName # "A241TUDOOK"
		If cTM <= "500"		// Entrada
			lRet := PCOVldLan("000151","01","MATA240",.T.)
		Else				// Saida
			lRet := PCOVldLan("000151","02","MATA240",.T.)
		EndIf
	EndIf
EndIf

//Consiste amarração da Conta Contábil X Centro de Custo
If lRet .And. nPConta <> 0 .And. nPItemCta <> 0 .And. nPClVl <> 0 .And. !( lDAmarCt )
	If !CtbAmarra(aCols[n,nPConta],cCC,aCols[n,nPItemCTA],aCols[n,nPCLVL])
		lRet:=.F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Conta Contábil está bloqueada. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. !( Empty( aCols[ n, nPConta ] ) )
	lRet := Ctb105Cta( aCols[ n, nPConta ] )
EndIf


Return lRet



//-------------------------------------------------------------------
/*/{Protheus.doc} A241GerImp()
Função que alimenta tabela de imposto para estorno de credito PIS/COFINS
@author Leonardo Quintania
@since 27/04/2015
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function A241GerImp(nValor,nDocumento,nImposto)
Local oModel  := FWLoadModel("FISA042")
Local nOpc 	:= 3
Local lRet		:= .T.

oModel:SetOperation(nOpc)

If (lRet := oModel:Activate()) //-- Ativa o modelo de dados 
	
	oModel:SetValue("FISA042MOD","CF5_FILIAL",xFilial("CF5"))
	oModel:SetValue("FISA042MOD","CF5_INDAJU","0")
	oModel:SetValue("FISA042MOD","CF5_PISCOF",IIF(nImposto==1,"0","1"))
	oModel:SetValue("FISA042MOD","CF5_VALAJU",nValor)
	oModel:SetValue("FISA042MOD","CF5_CODAJU","06")
	oModel:SetValue("FISA042MOD","CF5_NUMDOC",nDocumento)
	oModel:SetValue("FISA042MOD","CF5_DESAJU","Ajuste de Credito devido a geração de ativo de um produto em estoque")
	oModel:SetValue("FISA042MOD","CF5_DTREF" ,dDataBase) 
				
	If (lRet := oModel:VldData()) //-- Valida os dados e integridade conforme dicionario do Model
		lRet := oModel:CommitData() //-- Efetiva gravacao dos dados na tabela
	EndIf
	
	oModel:DeActivate() //-- Desativa o Model

EndIf

Return NIL

Static Function getvalid( cCampo )
Local aArea	 := GetArea()
Local cValid := IIf( !Empty( GetSx3Cache( cCampo, "X3_VALID" ) ), AllTrim( GetSx3Cache( cCampo, "X3_VALID" ) ), "" ) + IIf( !Empty( GetSx3Cache( cCampo, "X3_VLDUSER" ) ), " .And. " + AllTrim( GetSx3Cache( cCampo, "X3_VLDUSER" ) ), "" )

RestArea( aArea )
Return cValid

//-------------------------------------------------------------------
/*/{Protheus.doc} A241VLDFan()
Valida se produto é fantasma 
@author Materiais 
@since 07/12/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function A241VLDFan(cProdFan)

Local aArea	:= GetArea()
Local aAreaSB1:= SB1->(GetArea())
Local lRet := .T.
Default cProdFan  := " "

If !Empty(cProdFan)
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+cProdFan)
	If RetFldProd(cProdFan,"B1_FANTASM") == "S"
		Help(" ",1,"A241PROFAN")
		lRet := .F.
	EndIf
EndIf

RestArea( aAreaSB1 )
RestArea( aArea )
Return(lRet)
