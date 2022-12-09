#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ XMATA730  ³ Autor ³ Marcos Bregantin      ³ Data ³         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera carga Acumulativa                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Edson   M.   ³16/01/98³XXXXXX³Inclusao do campo C2_SLDOP.              ³±±
±±³Edson   M.   ³03/02/98³XXXXXX³Subst. do Campo C2_SLDOP por funcao.     ³±±
±±³Viviani      ³08/01/99³Melhor³Nova criacao de dialogo (Protheus)       ³±±
±±³Cesar Valadao³29/06/99³XXXXXX³Acerto de ZAP Para TopConnect.           ³±±
±±³             ³        ³      ³Acerto de Cond de IndRegua P/ Top (SC2). ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data         |BOPS:		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³                          ³              |                  ³±±
±±³      02  ³Erike Yuri da Silva       ³20/02/2006    |00000091869       ³±±
±±³      03  ³                          ³              |                  ³±±
±±³      04  ³                          ³              |                  ³±±
±±³      05  ³                          ³              |                  ³±±
±±³      06  ³                          ³              |                  ³±±
±±³      07  ³                          ³              |                  ³±±
±±³      08  ³                          ³              |                  ³±±
±±³      09  ³Erike Yuri da Silva       ³20/02/2006    |00000091869       ³±±
±±³      10  ³                          ³              |                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XMATA730()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nOpca := 0
LOCAL nSaldo, cMarca
Local aSays:={}, aButtons := {}
LOCAL cCondicao
LOCAL oDlg
#IFNDEF TOP
	Local ni
#ENDIF

PRIVATE lInverte := .T.
PRIVATE cCadastro:= OemToAnsi("Carga Acumulativa")	//"Carga Acumulativa"
PRIVATE aInd := {}, cIndex

PRIVATE aRotina := {	{"Pesquisar","U_XA730P", 0 , 1},;	//"Pesquisar"
{"Calculo","U_XA730C", 0 , 0}}	//"Calculo"


PutSx1("MTA730","08","Considera informacoes  ?","","","mv_ch8","N", 1,0,1,"C","","","","","mv_par08","Carga Maquina","espanhol","ingles","","Roteiro operacoes","espanhol","ingles","","","","","","","","","")
Pergunte("MTA730",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // data de Calculo inicial                          ³
//³ mv_par02 // data de Calculo Final                            ³
//³ mv_par03 // Data entrega OP de                               ³
//³ mv_par04 // Data entrega OP ate                              ³
//³ mv_par05 // Numero da OP de                                  ³
//³ mv_par06 // Numero da OP ate                                 ³
//³ mv_par07 // Saldo a considerar 1 = OP 2 = Operacao           ³
//³ mv_par08 // Considera informacoes 1 Carga maquina 2 Roteiro  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOpca := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nova forma de criar dialogos para processos Batch            ³
//³ COMPATIVEL COM PROTHEUS (BOF)                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aSays,OemToAnsi( "STR0004" ) )
AADD(aSays,OemToAnsi( "STR0005" ) )
AADD(aButtons, { 5,.T.,{|| pergunte("MTA730") } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )
If !ChkFile("SHH",.T.) .or. IsLockSH8(.F.)
	Help(" ",1,"SH8EmUso")
ElseIf nOpca == 1
	XA730Limpa()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retira o SHH da variavel cFopened ref. a abertura no MNU     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SHH")
dbCloseArea()
ClosFile("SHH")

dbSelectArea("SC2")
RetIndex("SC2")
#IFNDEF TOP
	For nI:=1 to Len(aInd)
		if File(aInd[nI]+OrdBagExt())
			Ferase(aInd[nI]+OrdBagExt())
		Endif
	Next
#ENDIF
dbClearFilter()
dbSetorder(1)
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³XA730pesqui³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 22.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisa usando indice condicional                         ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ A730Pesqui                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MAtA730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION XA730P()
Local cAlias,cCampo,nReg
Local cFil:="",nChave:=1,dCampo
Local cIndex,nIndex,cKey,cOrd
Local oDlg, nOpca
Local ni
PRIVATE aOrd := { }
cAlias  := ALIAS()
nOpt1   := 1
nMaiorStr := 0
PesqOrd(cAlias)
cOrd	  := aOrd[1]
cCampo  := Space(40)
For ni:=1 to Len(aOrd)
	aOrd[nI] := OemToAnsi(aOrd[nI])
Next
If IndexOrd() >= Len(aOrd)
	cOrd := aOrd[Len(aOrd)]
ElseIf IndexOrd() <= 1
	cOrd := aOrd[1]
Else
	cOrd := aOrd[IndexOrd()]
Endif

DEFINE MSDIALOG oDlg FROM 5, 5 TO 14, 50 TITLE OemToAnsi("Pesquisar")	//"Pesquisar"
@ 0.6,1.3 COMBOBOX oCBX VAR cOrd ITEMS aOrd  SIZE 165,44  ON CHANGE (nOpt1:=oCbx:nAt)  OF oDlg FONT oDlg:oFont
@ 2.1,1.3 MSGET cCampo SIZE 165,10
DEFINE SBUTTON FROM 055,122   TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 055,149.1 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED
If nOpca == 0
	Return 0
Endif
XA730MontPes()

nReg := RecNo()
IF LastKey() != 27
	Set Softseek On
	IF SubStr(cAlias,1,3) != "SM2"
		cFil:=xFilial(cAlias)
		nChave:=11
	EndIF
	IF SubStr(IndexKey(nOpt1),nChave,4) == "DTOS"
		dCampo:=Ctod(AllTrim(cCampo))
		dbSeek(cFil+DTOS(dCampo))
	Else
		dbSeek(xFilial(cAlias)+trim(cCampo))
	Endif
	IF SubStr(cAlias,1,3) == "SM2"
		dCampo:=Ctod(AllTrim(cCampo))
		dbSeek(dCampo)
	EndIF
EndIF
IF Eof()
	Go nReg
	Help(" ",1,"PESQ01")
EndIF
Set SoftSeek Off
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³XA730SelOp ³ Autor ³ Marcos Bregantim      ³ Data ³10/06/94  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica selecao de Op's                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := XA730SelOp()                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function XA730SelOP()
LOCAL lRet := .f.,cAlias := Alias()

dbSelectArea("SC2")
cCondicao := 'C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= mv_par05 .and. C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= mv_par06 .and. '
cCondicao += 'C2_DATPRF >= mv_par03 .and. C2_DATPRF <= mv_par04 .and. Empty(C2_DATRF) .and. C2_STATUS != "D" .and. '
cCondicao += 'C2_FILIAL == xFilial("SC2")'
If ExistBlock("A730FSC2")
	cRetBlock := ExecBlock("A730FSC2",.F.,.F.,cCondicao)
	If ValType(cRetBlock) == "C"
		cCondicao := cRetBlock
	EndIf
EndIf
If &(cCondicao)
	lRet := .t.
Endif
dbSelectArea(cAlias)
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³XA730QtdOp ³ Autor ³ Marcos Bregantim      ³ Data ³10/06/94  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica saldo da operacao a ser alocado                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := A730QtdOp(ExpA2,ExpN1)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function XA730QtdOp(cOperac)
LOCAL	nSalvaRec, nQuant:=0, cNumOp := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD

If mv_par07 == 1
	nQuant := SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA
Else
	nSalvaRec := SH6-> ( RecNo() )
	SH6-> ( dbSetOrder(1) )
	SH6-> ( dbSeek(xFilial("SH6")+cNumOp+SC2->C2_PRODUTO+cOperac) )
	While !SH6-> ( Eof() ) .And. SH6->H6_FILIAL+SH6->H6_OP+SH6->H6_PRODUTO+SH6->H6_OPERAC == xFilial("SH6")+cNumOp+SC2->C2_PRODUTO+cOperac
		nQuant += SH6->H6_QTDPROD
		SH6-> ( dbSkip() )
	End
	nQuant := SC2->C2_QUANT - nQuant
	SH6-> ( dbGoto(nSalvaRec) )
Endif
Return nQuant

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³XA730Uteis ³ Autor ³ Marcos Bregantim      ³ Data ³10/06/94  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a quantidade de horas uteis                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := XA730Uteis()                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function XA730Uteis()
LOCAL nHoras:=0, cAlias := Alias()
Local ni
Local lA730HNUteis	:= ExistBlock("A730HNUT") //PE que indica as horas nao uteis a serem descontadas no dia.
Local nHNUteis		:= 0  // Varivel numerica que indicara o numero de horas a ser descontadas no dia

If mv_par02 >= mv_par01
	For nI:=mv_par01 to mv_par02
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PE que indica as horas nao uteis a serem descontadas no dia. ³
		//³ Caso o retorno do ponto de entrada seja maior que a hora util³
		//³ definida no cadastro SHB, o valor da hora inutil sera descon-³
		//³ ciderado assumindo valor ZERO. Por premissa o retorno do PE  ³
		//³ deve ser possitivo.(vide documentacao no DEM)                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lA730HNUteis
			nHNUteis := ExecBlock("A730HNUT",.F.,.F.,{nI})
			If ValType(nHNUteis)#"N"
				nHNUteis := 0
			EndIf
		EndIf
		If Dow(nI) == 1
			nHoras += SHB->HB_HRUTDOM-If(nHNUteis > SHB->HB_HRUTDOM,0,nHNUteis)
		ElseIf Dow(nI) == 7
			nHoras += SHB->HB_HRUTSAB-If(nHNUteis > SHB->HB_HRUTSAB,0,nHNUteis)
		Else
			nHoras += SHB->HB_HRUT-If(nHNUteis > SHB->HB_HRUT,0,nHNUteis)
		Endif
	Next
Endif
dbSelectArea(cAlias)
Return (nHoras)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³XA730Calc   ³ Autor ³ Marcelo Iuspa         ³ Data ³20/09/00³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chama a funcao A740RunCalc usando regua de processamento   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ XA730Calculo(cAlias,cCampo,nOpcE,cMarca,lInverte)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA730C(cAlias,cCampo,nOpcE,cMarca,lInverte)
Processa({|| XA730RunCalc(cAlias,cCampo,nOpcE,cMarca,lInverte)})
CloseBrowse()
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³XA730RunCalc ³ Autor ³ Marcos Bregantim      ³ Data ³10/06/94³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica saldo da operacao a ser alocado                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := A730RunCalc(ExpA2,ExpN1)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function XA730RunCalc(cAlias,cCampo,nOpcE,cMarca,lInverte)
Local dDtOp		:= Nil
Local dDtFim	:= Nil
Local cHrIni	:= ""
Local cHrFim	:= ""
Local nUso		:= 0
Local lInclui	:= .F.
Local lA730FOPE	:= ExistBlock("A730FOPE")
Local lLoop		:= .F.
Local nRend		:= 0
Local cFiltSH8	:= ".T." //-- Variavel utilizada para P.E. A730FILT
Local cFiltSG2	:= ".T." //-- Variavel utilizada para P.E. A730FILT
Local aFilOper[2]      //-- Variavel utilizada para P.E. A730FILT
Local lApsInUse := SuperGetMV("MV_APS",.F.,"") == "TOTVS"
PRIVATE cTipoTemp := GetMV("MV_TPHR")

ProcRegua(SC2->(LastRec()))

SH8->(DbsetOrder(1))
SHH->(DbsetOrder(1))

dbSelectArea("SHB")
dbSeek(xFilial("SHB"))
While !Eof() .and. HB_FILIAL == xFilial("SHB")
	RecLock("SHB",.F.)
	Replace HB_USO   With 0
	Replace HB_UTEIS With XA730Uteis()
	MsUnLock()
	dbSkip()
End

dbSelectArea("SC2")
SC2->(DbSetOrder(1))
dbSeek(xFilial("SC2"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PE utilizado para filtrar as Operacoes que deveram entrarem    ³
//³ no Carga Acumulativa. Podera aplicar-se o filtro na tabela SH8 ³
//³ e/ou SG2, dependendo da opcao setada no parametro MV_PAR08.    ³
//³ Devera retorna um Array contendo dois elementos onde:          ³
//³ Elemento 1 => Expressao (Caracter) para filtro do SH8.         ³
//| Elemento 2 => Expressao (Caracter) para filtro do SG2.         ³
//³ (Vide documentacao no DEM)                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("A730FILT")
	aFilOper := ExecBlock("A730FILT",.F.,.F.,MV_PAR08)
	If ValType(aFilOper) == "A" .and. Len(aFilOper) == 2
		cFiltSH8:= If(ValType(aFilOper[1]) == "C" .And. !Empty(aFilOper[1]), aFilOper[1], cFiltSH8)
		cFiltSG2:= If(ValType(aFilOper[2]) == "C" .And. !Empty(aFilOper[2]), aFilOper[2], cFiltSG2)
	EndIf
EndIf
If mv_par08 == 1
	While !SC2->(EOF())
		IncProc()
		If !SC2->(IsMark("C2_OK",cMarca,lInverte)) .Or. !SH8->(DbSeek(xFilial("SH8")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD))
			SC2->(DbSkip())
			Loop
		EndIf
		
		While !SH8->(EOF()) .And. SH8->H8_FILIAL == xFilial("SH8") .And. SH8->H8_OP == SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
			
			If ( SH8->H8_DTINI >= mv_par01 .And. SH8->H8_DTINI <= mv_par02 ) .Or. ;
				( SH8->H8_DTFIM >= mv_par01 .And. SH8->H8_DTFIM <= mv_par02 ) .Or. ;
				( SH8->H8_DTINI < mv_par01  .And. SH8->H8_DTFIM >  mv_par02 )
				If &(cFiltSH8) //-- Filtro aplicado pelo P.E. A730FILT
					
					_dData:=MIN(MV_PAR02,SH8->H8_DTFIM)
					_cHrfi:=IIF(SH8->H8_DTFIM>MV_PAR02,"23:59",SH8->H8_HRFIM)
					
					For dDtOp := SH8->H8_DTINI To _dData  // SH8->H8_DTFIM
						
						If dDtOp == SH8->H8_DTINI
							cHrIni := SH8->H8_HRINI
						Else
							cHrIni := "00:00"
						EndIf
						
						
						If dDtOp == _dData //SH8->H8_DTFIM
							dDtFim := dDtOp
							cHrFim := _cHrfi
						Else
							dDtFim := dDtOp + 1
							cHrFim := "00:00"
						EndIf
						
						If lApsInUse
							nUso := A680TimeCale(dDtOp,cHrIni,dDtFim,cHrFim,SH8->H8_RECURSO)
						Else
							nUso := R815Dur(SH8->H8_RECURSO,dDtFim,cHrFim,dDtOp,cHrIni,"C")
						EndIf
						//						ALERT(SH8->H8_CTRAB+SH8->H8_RECURSO+SH8->H8_OP)
						
						If nUso > 0
							dbSelectArea("SHH")
							lInclui:=.T.
							DbSeek(xFilial("SHH")+DToS(dDtOp)+SH8->H8_CTRAB+SH8->H8_RECURSO+SH8->H8_OP)
							While !Eof() .And. xFilial("SHH")+DToS(dDtOp)+SH8->H8_CTRAB+SH8->H8_RECURSO+SH8->H8_OP == HH_FILIAL+DTOS(HH_DATA)+HH_CTRAB+HH_RECURSO+HH_OP
								// Checa a existencia da mesma operacao
								If HH_OPER == SH8->H8_OPER
									lInclui:=.F.
									Exit
								EndIf
								dbSkip()
							End
							RecLock("SHH",lInclui)
							Replace HH_FILIAL 	With xFilial("SHH")
							Replace HH_DATA 	With dDtOp
							Replace HH_OP 		With SH8->H8_OP
							Replace HH_OPER 	With SH8->H8_OPER
							Replace HH_RECURSO 	With SH8->H8_RECURSO
							Replace HH_FERRAM 	With SH8->H8_FERRAM
							Replace HH_CTRAB 	With SH8->H8_CTRAB
							Replace HH_USO 		With HH_USO+nUso
							MsUnLock()
							dbSelectArea("SHB")
							dbSetOrder(1)
							If dbSeek(xFilial("SHB")+SH8->H8_CTRAB)
								dbSelectArea("SHB")
								RecLock("SHB",.f.)
								Replace HB_USO With HB_USO+nUso
								MsUnLock()
							Endif
						EndIf
					Next
				EndIf
			EndIf
			SH8->(DbSkip())
		EndDo
		SC2->(DbSkip())
	EndDo
Else
	dbSelectArea("SC2")
	dbSeek(xFilial("SC2"))
	While !SC2->(EOF())
		IncProc()
		IF !IsMark("C2_OK",cMarca,lInverte)
			dbSkip()
			Loop
		Endif
		If Empty(cRoteiro := SC2->C2_ROTEIRO)
			dbSelectArea('SB1')
			If dbSeek(xFilial('SB1') + SC2->C2_PRODUTO, .F.)
				If !Empty(SB1->B1_OPERPAD)
					cRoteiro := SB1->B1_OPERPAD
				Else
					cRoteiro:='01'
				EndIf
			Else
				cRoteiro := '01'
			EndIf
		EndIf
		dbSelectArea("SG2")
		dbSetOrder(1)
		dbSeek(xFilial("SG2")+SC2->C2_PRODUTO+cRoteiro,.F.)
		While !Eof() .and. G2_FILIAL == xFilial("SG2") .and. G2_PRODUTO == SC2->C2_PRODUTO .And. SG2->G2_CODIGO == cRoteiro
			If &(cFiltSG2) //-- Filtro aplicado pelo P.E. A730FILT
				dbSelectArea("SHB")
				dbSetOrder(1)
				dbSeek(xFilial("SHB")+SG2->G2_CTRAB)
				dbSelectArea("SG2")
				If (SHB->(Eof()))
					dbSkip()
					Loop
				Endif
				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ PE utilizado para filtrar as Operacoes por ordem de producao   ³
				//³ no Carga Acumulativa. (Bops:00000105102)
				//³ (Vide documentacao no DEM)           çção o Jã                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lA730FOPE
					lLoop := ExecBlock("A730FOPE",.F.,.F.,{SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),SG2->G2_CODIGO,SG2->G2_PRODUTO,SG2->G2_OPERAC})
					If ValType(lLoop) == "L" .and. lLoop
						dbSkip()
						Loop
					EndIf
				EndIf
				
				
				// Definição Júlio Blauecke - 10.07.2015 // Utilizar o mesmo indice da carqa maquina
				//                                       // para calcula a carga acumulativa. 
				IF SHB->HB_REND > 0  // erro de calculo porque estava dobrando o numero de horas em 15.07.2015
				   nRend := (1+(1-(SHB->HB_REND/100)))   // BLAUECKE
				ENDIF
				
				
				nSaldo := XA730QtdOp(SG2->G2_OPERAC)
				
				
				
				If nSaldo == 0
					dbSkip()
					Loop
				Endif
				
				If SG2->G2_TPOPER != "2"
					nUso := (nSaldo/If(SG2->G2_LOTEPAD==0,1,SG2->G2_LOTEPAD)) * A690HoraCt(SG2->G2_TEMPAD* nRend)
					
					IF Mod(nUso*60,60)<>0
						nSaldoDec:= (nUso - int(nuso))*100
						
						Do case
							Case nSaldoDec < 25
								nsaldoDec:=0
							Case nSaldoDec  < 50
								nsaldoDec:=0.25
							Case nSaldoDec < 75
								nsaldoDec:=0.50
							otherwise
								nsaldoDec:=0.75
						Endcase
						nUso:=Int(nUso)+nSaldoDec
					Endif
				Else
					nUso := SC2->C2_QUANT*(SG2->G2_TEMPAD*(1+(1-(SHB->HB_REND/100))))  
				Endif
				
				If nUso > 0
					dbSelectArea("SHH")
					lInclui:=.T.
					DbSeek(xFilial("SHH")+DToS(SC2->C2_DATPRF)+SHB->HB_COD+SG2->G2_RECURSO+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
					While !Eof() .And. xFilial("SHH")+DToS(SC2->C2_DATPRF)+SHB->HB_COD+SG2->G2_RECURSO+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD == HH_FILIAL+DTOS(HH_DATA)+HH_CTRAB+HH_RECURSO+HH_OP
						// Checa a existencia da mesma operacao
						If HH_OPER == SG2->G2_OPERAC
							lInclui:=.F.
							Exit
						EndIf
						dbSkip()
					End
					RecLock("SHH", lInclui)
					Replace HH_FILIAL 	With xFilial("SHH")
					Replace HH_DATA 	With SC2->C2_DATPRF
					Replace HH_OP 		With SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
					Replace HH_OPER 	With SG2->G2_OPERAC
					Replace HH_RECURSO 	With SG2->G2_RECURSO
					Replace HH_FERRAM 	With SG2->G2_FERRAM
					Replace HH_CTRAB 	With SHB->HB_COD
					Replace HH_USO 		With HH_USO+nUso
					MsUnLock()
					dbSelectArea("SHB")
					RecLock("SHB",.F.)
					Replace HB_USO With HB_USO+nUso
					MsUnLock()
				EndIf
			EndIf
			dbSelectArea("SG2")
			dbSkip()
		End
		dbSelectArea("SC2")
		dbSkip()
	End
EndIf
dbSelectArea("SC2")
CloseBrowse()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ XA730Limpa  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³28/02/96³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Limpa o arquivo de operacoes alocadas.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XA730Limpa()
#IFDEF TOP
	Local cFile
#ENDIF
// Limpa o arquivo de operacoes alocadas
DbSelectArea("SHH")
#IFNDEF TOP
	If MA280FLock("SHH")
		Zap
	Else
		Help("EXCL")
	Endif
#ELSE
	cFile := RetSqlName("SHH")
	TCSQLEXEC("DELETE FROM "+cFIle)
	dbSelectArea("SHH")
	dbGotop()
#ENDIF
cIndex := CriaTrab(NIL,.F.)
AADD(aInd,cIndex)
dbSelectArea("SC2")
dbSetOrder(1)
#IFNDEF TOP
	IndRegua("SC2",cIndex,"C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD",,"XA730SelOp()","Gerando Indice Trabalho ...")	//"Gerando Indice Trabalho ..."
#ELSE
	cCondicao:= 'C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= "'+mv_par05+'" .and. C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <="'
	cCondicao+= mv_par06+'" .and. DToS(C2_DATPRF) >="'+DToS(mv_par03)+'".and. DToS(C2_DATPRF) <= "'
	cCondicao+= DToS(mv_par04)+'" .and. C2_DATRF == CToD("")'
	cCondicao+= ' .and. C2_STATUS <> "D" .and. C2_FILIAL =="'+xFilial("SC2")+'"'
	If ExistBlock("A730FSC2")
		cRetBlock := ExecBlock("A730FSC2",.F.,.F.,cCondicao)
		If ValType(cRetBlock) == "C"
			cCondicao := cRetBlock
		EndIf
	EndIf
	IndRegua("SC2",cIndex,"C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD",,cCondicao,"Gerando Indice Trabalho ...")	//"Gerando Indice Trabalho ..."
#ENDIF
dbGoTop()

cCadastro:= OemToAnsi("Gera‡Æo da Carga Acumulativa de M quinas")	//"Gera‡Æo da Carga Acumulativa de M quinas"

cMarca := GetMark()
MarkBrow("SC2","C2_OK",,,,cMarca)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ XA730MontPes³ Autor ³ Rodrigo de A. Sartorio³ Data ³28/02/96³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta os indices condicionais para pesquisa.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XA730MontPes()
DbSetOrder(nOpt1)
cIndex := CriaTrab(nil,.f.)
Aadd(aInd,cIndex)
dbSelectArea("SC2")
cKey   := IndexKey()
#IFNDEF TOP
	IndRegua("SC2",cIndex,cKey,,"XA730SelOp()","Selecionando Registros...")	//"Selecionando Registros..."
	nIndex := RetIndex("SC2")
	dbSelectArea("SC2")
	dbSetIndex(cIndex+OrdBagExt())
	dbSetOrder(nIndex+1)
#ELSE
	// AGUARDANDO SOLUCAO TECNOLOGIA
	cCondicao := 'C2_NUM >= "'+mv_par05+'" .and. C2_NUM <="'
	cCondicao+= mv_par06+'" .and. DTOS(C2_DATPRF) >="'+DtoS(mv_par03)+'".and. DTOS(C2_DATPRF) <="'
	cCondicao+= DtoS(mv_par04)+'" .and. C2_DATRF == CToD("")'
	cCondicao+= ' .and. C2_STATUS <> "D" .and. C2_FILIAL =="'+xFilial("SC2")+'"'
	If ExistBlock("A730FSC2")
		cRetBlock := ExecBlock("A730FSC2",.F.,.F.,cCondicao)
		If ValType(cRetBlock) == "C"
			cCondicao := cRetBlock
		EndIf
	EndIf
	IndRegua("SC2",cIndex,cKey,,cCondicao,"Selecionando Registros...")	//"Selecionando Registros..."
#ENDIF
dbGoTop()
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MTA730MNU")
	ExecBlock("MTA730MNU",.F.,.F.)
EndIf
Return(aRotina)
