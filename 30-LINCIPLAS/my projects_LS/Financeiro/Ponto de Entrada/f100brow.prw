#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#DEFINE ENTER CHR(13)+CHR(10)

// Programa.: f100brow()
// Autor....: Alexandre Dalpiaz
// Data.....: 30/07/10
// Descrição: altera rotina de transferencias bancarias, no menu das movimentaços bancarias
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function f100brow()
////////////////////////

aRotina[7] := { "Transf","U_LA_fA100Tran", 0 , 3}
//aAdd(aRotina,{ "Descontabilizar","U_LS_SlDes", 0 , 3}

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidNatur()
////////////////////////////

If SZK->(DbSeek(xFilial('SZK') + cNaturOri,.F.))
	//cNaturDes	:= cNaturOri
	nDocTran := val(getmv("ST_NUMSEQ"))
	nDocTran++
	PUTMV("ST_NUMSEQ", strzero(nDocTran,6)) // Atualiza o parametro com o valor atualizado
	cDocTran	:= str(nDocTran)
	cHist100	:= &(SZK->ZK_HISTOR)
	cBenef100 	:= &(SZK->ZK_BENEF)
EndIf
//dbclosearea("TRB2")
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fa100tran³Autor  ³ Wagner Xavier         ³ Data ³ 03/06/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Transferencia entre bancos/agencias.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fa100tran()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA100                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LA_fa100tran(cAlias,nReg,nOpc)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nOpcA			:=0
LOCAL lA100BL01	:= ExistBlock("A100BL01")
LOCAL lF100DOC		:= ExistBlock("F100DOC")
LOCAL aValores		:= {}
LOCAL lGrava
LOCAL nA,cMoedaTx
LOCAL lSpbInUse	:= SpbInUse()
LOCAL aModalSPB	:=  {"1=TED","2=CIP","3=COMP"}
LOCAL oModSpb
LOCAL cModSpb
LOCAL aTrfPms		:= {}
LOCAL lEstorno		:= .F.
LOCAL oBcoOrig
LOCAL oBcoDest
LOCAL aSimbMoeda	:= {}							//Array com os simbolos das moedas.
LOCAL nPosMoeda	:= 0							//Verifica a posicao da moeda no array aSimbMoeda
LOCAL nX				:= 0							//Contador
LOCAL nTotMoeda	:= 0							//TotMoeda

PRIVATE cBenef100 	:= CriaVar("E5_BENEF")
PRIVATE oDlg
PRIVATE cBcoOrig		:= CriaVar("E5_BANCO")
PRIVATE cBcoDest		:= CriaVar("E5_BANCO")
PRIVATE cAgenOrig	:= CriaVar("E5_AGENCIA")
PRIVATE cAgenDest	:= CriaVar("E5_AGENCIA")
PRIVATE cCtaOrig		:= CriaVar("E5_CONTA")
PRIVATE cCtaDest		:= CriaVar("E5_CONTA")
PRIVATE cNaturOri	:= CriaVar("E5_NATUREZ")
PRIVATE cNaturDes	:= CriaVar("E5_NATUREZ")
PRIVATE cDocTran		:= CriaVar("E5_NUMCHEQ")
PRIVATE cHist100		:= CriaVar("E5_HISTOR")
PRIVATE nValorTran	:=0

M->E5_DATA := dDataBase

// rotina externa nao contabiliza (o SIGALOJA usa esta rotina
// direto da rotina de venda rapida e neste caso
// o parametro ‚ sempre .T.
If Substr(Upper(FunName()),1,7) == "LOJA220"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Permissao "Sangria/Entrada de Troco" - #5 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !LjProfile(5,,,,,.T.)
		Return(NIL)
	EndIf
	lExterno := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta a Ocorrencia "EST" no SX5 para for‡ar o usuario a uti-³
//³ lizar a OPCAO Estorno para que o saldo bancario seja tratado ³
//³ corretamente.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
If dbSeek(xFilial()+"14"+"EST")
	Reclock("SX5")
	dbDelete()
	MsUnlock()
Endif

Private nTotal := 0
Private cTipoTran := Space(3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !DtMovFin()
	Return
Endif

While .T.
	
	dbSelectArea("SE5")
	cFilOrig    := cFilAnt
	cFilDest    := '  '
	cBcoOrig	:= CriaVar("E5_BANCO")
	cBcoDest	:= CriaVar("E5_BANCO")
	cAgenOrig:= CriaVar("E5_AGENCIA")
	cAgenDest:= CriaVar("E5_AGENCIA")
	cCtaOrig	:= CriaVar("E5_CONTA")
	cCtaDest	:= CriaVar("E5_CONTA")
	cNaturOri:= CriaVar("E5_NATUREZ")
	cNaturDes:= CriaVar("E5_NATUREZ")
	cClassOri:= CriaVar("E5_CLASS")
	cClassDes:= CriaVar("E5_CLASS")
	cDocTran := CriaVar("E5_NUMCHEQ")
	cHist100 := CriaVar("E5_HISTOR")
	nValorTran:=0
	cBenef100:= CriaVar("E5_BENEF")
	cTipoTran := 'TB ' 
	If lSpbInUse
		cModSpb := "1"
	Endif
	nOpcA := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebe dados a serem digitados 										  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DEFINE MSDIALOG oDlg FROM  32, 113 TO 358,620 TITLE "Movimentação Bancária" PIXEL
	@ 06, 4 TO 036, 310 OF oDlg	PIXEL
	@ 44, 4 TO 074, 310 OF oDlg	PIXEL
	@ 85, 4 TO 159, 172 OF oDlg	PIXEL
	
	@ 01, 04 SAY "Origem" 		 SIZE 25, 7 OF oDlg PIXEL	//
	@ 13, 07 SAY "Filial"		 SIZE 19, 7 OF oDlg PIXEL	// "filial
	@ 13, 47 SAY "Banco" 		 SIZE 19, 7 OF oDlg PIXEL	// "Banco"
	@ 13, 79 SAY "Agência" 		 SIZE 25, 7 OF oDlg PIXEL	// "Agˆncia"
	@ 13,107 SAY "Conta" 		 SIZE 20, 7 OF oDlg PIXEL	// "Conta"
	@ 13,155 SAY "Natureza"		 SIZE 28, 7 OF oDlg PIXEL	// "Natureza"
//	@ 13,203 SAY "Classificação" SIZE 30, 7 OF oDlg PIXEL	// classificacao
	
	@ 40, 04 SAY "Destino" 		 SIZE 25, 7 OF oDlg PIXEL	// "Destino"
	@ 52, 07 SAY "Filial"		 SIZE 19, 7 OF oDlg PIXEL	// "filial
	@ 52, 47 SAY "Banco" 		 SIZE 23, 7 OF oDlg PIXEL	// "Banco"
	@ 52, 79 SAY "Agência" 		 SIZE 27, 7 OF oDlg PIXEL
	@ 52,107 SAY "Conta" 		 SIZE 18, 7 OF oDlg PIXEL	// "Conta"
	@ 52,155 SAY "Natureza"		 SIZE 28, 7 OF oDlg PIXEL	// "Natureza"
//	@ 52,203 SAY "Classificação" SIZE 30, 7 OF oDlg PIXEL	// classificacao
	
	@ 79, 04 SAY "Identificação" SIZE 41, 7 OF oDlg PIXEL	// "Identifica‡„o"
	@ 93, 08 SAY "Tipo Mov." 	 SIZE 31, 7 OF oDlg PIXEL	// "Tipo Mov."
	@ 93, 42 SAY "Número Doc." 	 SIZE 43, 7 OF oDlg PIXEL	// "N£mero Doc."
	@ 93, 99 SAY "Valor" 		 SIZE 17, 7 OF oDlg PIXEL	// "Valor"
	@ 115,09 SAY "Histórico" 	 SIZE 28, 7 OF oDlg PIXEL	// "Hist¢rico"
	@ 136,09 SAY "Beneficiário"  SIZE 40, 7 OF oDlg PIXEL	// "Benefici rio"
	
	@ 22, 07 MSGET oFilOrig VAR cFilOrig	F3 "SM0"	Picture "@!"  	Valid ValidBAC(cFilOrig,cBcoOrig,cAgenOrig,cCtaOrig)    SIZE 10, 10 OF oDlg PIXEL hasbutton when .f.
	@ 22, 47 MSGET oBcoOrig VAR cBcoOrig	F3 "SA6A"	Picture "@!"  	Valid ValidBAC(cFilOrig,cBcoOrig,cAgenOrig,cCtaOrig)	SIZE 10, 10 OF oDlg PIXEL hasbutton
	@ 22, 79 MSGET cAgenOrig  							Picture "@!"	Valid ValidBAC(cFilOrig,cBcoOrig,cAgenOrig,cCtaOrig)	SIZE 20, 10 OF oDlg PIXEL when !empty(cBcoOrig)
	@ 22,107 MSGET cCtaOrig								Picture "@!"	Valid ValidBAC(cFilOrig,cBcoOrig,cAgenOrig,cCtaOrig) 	SIZE 45, 10 OF oDlg PIXEL when !empty(cAgenOrig)
	@ 22,155 MSGET oNaturOri Var cNaturOri	F3 "SED"  	picture '@!'	Valid ExistCpo("SED",@cNaturOri) .and. ValidBAC(cFilOrig) 	SIZE 47, 10 OF oDlg PIXEL hasbutton
//	@ 22,203 MSGET cClassOri				F3 "SZU"  	picture '@!'	Valid ExistCpo("SZU",@cClassOri) .and. ValidNatur(2)	SIZE 47, 10 OF oDlg PIXEL hasbutton
	
	@ 60, 07 MSGET oFilDest VAR cFilDest	F3 "SM0"	Picture "@!"  	Valid ValidBAC(cFilDest,cBcoDest,cAgenDest,cCtaDest)	SIZE 10, 10 OF oDlg PIXEL hasbutton
	@ 60, 47 MSGET oBcoDest VAR cBcoDest	F3 "SA6C" 	Picture "@!"	Valid ValidBAC(cFilDest,cBcoDest,cAgenDest,cCtaDest) 	SIZE 10, 10 OF oDlg PIXEL hasbutton when !empty(cFilDest)
	@ 60, 79 MSGET cAgenDest							Picture "@!"	Valid ValidBAC(cFilDest,cBcoDest,cAgenDest,cCtaDest) 	SIZE 20, 10 OF oDlg PIXEL when !empty(cBcoDest)
	@ 60,107 MSGET cCtaDest								Picture "@!" 	Valid (cBcoDest != cBcoOrig .or. cAgenDest != cAgenOrig .or.	cCtaDest != cCtaOrig) .and. ValidBAC(cFilDest,cBcoDest,cAgenDest,cCtaDest)	SIZE 45, 10 OF oDlg PIXEL when !empty(cAgenDest)
	@ 60,155 MSGET oNaturDes Var cNaturDes	F3 "SED"	picture '@!'	Valid ValidBAC(cFilDest)								SIZE 47, 10 OF oDlg PIXEL hasbutton 
//	@ 60,203 MSGET cClassDes				F3 "SZU"  	picture '@!'	Valid ExistCpo("SZU",@cClassDes) 						SIZE 47, 10 OF oDlg PIXEL hasbutton
	
	@ 102,09 MSGET cTipoTran				F3 "14"		Picture "!!!"	Valid (!Empty(cTipoTran) .And. ExistCpo("SX5","14"+cTipoTran)) .and. ;
	Iif(cTipoTran="CH",fa050Cheque(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran),.T.) .And. ;
	Iif(cTipoTran="CH",fa100DocTran(cBcoOrig,cAgenOrig,cCtaOrig,cTipoTran,@cDocTran),.T.) SIZE  15, 10 OF oDlg PIXEL hasbutton
	@ 102,42 MSGET cDocTran		Picture PesqPict("SE5", "E5_NUMCHEQ")	Valid !Empty(cDocTran).and.fa100doc(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran)	SIZE	47, 10 OF oDlg PIXEL //WHEN !(SZK->(DbSeek(xFilial('SZK') + cNaturOri,.F.)))
	@ 102,99 MSGET nValorTran	PicTure PesqPict("SE5","E5_VALOR",15)	Valid nValorTran > 0     SIZE  66, 10 OF oDlg PIXEL hasbutton
	
	@ 123, 9 MSGET cHist100		Picture "@S22"      							Valid !Empty(cHist100)        SIZE 155, 10 OF oDlg PIXEL //WHEN !(SZK->(DbSeek(xFilial('SZK') + cNaturOri,.F.)))
	
	@ 144, 9 MSGET cBenef100	Picture "@S21"      							Valid !Empty(cBenef100)       SIZE 155, 10 OF oDlg PIXEL //WHEN !(SZK->(DbSeek(xFilial('SZK') + cNaturOri,.F.)))
	
	If lSpbInUse
		@ 162, 4 TO 188, 172 OF oDlg	PIXEL
		@ 165,09 SAY "Modalidade SPB" SIZE 60, 07 OF oDlg PIXEL  //"Modalidade SPB"
		@ 173,09 MSCOMBOBOX oModSPB VAR cModSpb ITEMS aModalSpb SIZE 56, 47 OF oDlg PIXEL ;
		VALID SpbTipo("SE5",cModSpb,cTipoTran,"TR")
	Endif
	
	DEFINE SBUTTON FROM 144, 180 TYPE 1 ENABLE ACTION (nOpca:=1,oDLg:End()) OF oDlg
	DEFINE SBUTTON FROM 123, 180 TYPE 2 ENABLE ACTION (nOpca:=0,oDlg:End()) OF oDlg
	If IntePms()
		aTrfPms := {CriaVar("E5_PROJPMS"),CriaVar("E5_TASKPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_EDTPMS"),CriaVar("E5_TASKPMS")}
		@ 36,180 BUTTON "Projetos..." SIZE 29 ,14   ACTION {||F100PmsTrf(aTrfPms)	} OF oDlg PIXEL
	EndIf
	
	ACTIVATE MSDIALOG oDlg CENTERED VALID  (iif(nOpca==1 , ;
	CarregaSa6(cBcoOrig,cAgenOrig,cCtaOrig,.T.,,.T.) .and. ;
	ValidTran(cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig).and.;
	IIF(lSpbInUse,SpbTipo("SE5",cModSpb,cTipoTran,"TR"),.T.),.T.) )// .and.  _FA100TRF()
	
	IF nOpcA == 1
		Begin Transaction
		lGrava := .T.
		If ExistBlock("FA100TRF")
			lGrava := ExecBlock("FA100TRF", .F., .F., { cBcoOrig, cAgenOrig, cCtaOrig,;
			cBcoDest, cAgenDest, cCtaDest,;
			cTipoTran, cDocTran, nValorTran,;
			cHist100, cBenef100,cNaturOri,;
			cNaturDes , cModSpb, lEstorno})
			
		Endif
		
		If lF100DOC
			cDocTran := ExecBlock("F100DOC",.F.,.F.,{	cBcoOrig	, cAgenOrig	, cCtaOrig		,;
			cBcoDest	, cAgenDest	, cCtaDest		,;
			cTipoTran	, cDocTran	, nValorTran	,;
			cHist100	, cBenef100	, cNaturOri		,;
			cNaturDes 	, cModSpb	, lEstorno})
		EndIf
		
		IF lGrava
			//Preenche o array aSimbMoeda
			nTotMoeda := MoedFin()
			For nX := 1 To nTotMoeda
				If( !(Empty(SuperGetMV("MV_MOEDA"+STR(nX,1)))) )
					AAdd( aSimbMoeda,SuperGetMV("MV_SIMB"+Ltrim(Str(nX))) )
				EndIf
			Next nX
			
			//Verifica e transacao em dinheiro e deixa fazer a transferencia entre bancos
			nPosMoeda := Ascan(aSimbMoeda,{|x| Trim(x) == Trim(cTipoTran)})
			
			If IsCaixaLoja(cBcoOrig) .AND. !(IsCaixaLoja(cBcoDest)) .AND. nPosMoeda == 0
				MsgInfo("Não é possivel realizar uma transferência de um caixa para um banco através desta rotina. Utilize as rotinas do contas a receber.")
			Else
				fa100grava(cFilOrig, cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,;
				cFilDest,cBcoDest,cAgenDest,cCtaDest,cNaturDes,;
				cTipoTran,cDocTran,nValorTran,cHist100,;
				cBenef100,,cModSpb,aTrfPms)
			EndIf
		ENDIF
		End Transaction
		If SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA + SEF->EF_NUM == cBcoOrig + cAgenOrig + cCtaOrig + cDocTran .and. SEF->EF_VALOR == nValorTran
			RecLock('SEF',.f.)
			SEF->EF_SERIE = 'XXX'
			DbDelete()
			MsUnLock()
		EndIf
		If lA100BL01
			aValores := {cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,cBcoDest,cAgenDest,;
			cCtaDest,cNaturDes,cTipoTran,nValorTran,cDocTran,cBenef100,cHist100,cModSpb}
			ExecBlock("A100BL01",.F.,.F.,aValores)
		EndIf
	Else
		Exit
	Endif
Enddo
Return
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fa100tit  ³ Autor ³ Wagner Xavier         ³ Data ³ 30/04/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera titulo de cheque, com data do vencimento               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa100tit()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA100                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fa100tit()
Local cAlias:=Alias()
Local cPrefixo := "CHQ"
Local cParcela := TamParcela("E1_PARCELA","1","01","001")
Local cCliente := GetMv("MV_CLIPAD")

//Cria Fornecedor Padrao
dbSelectArea("SA1")
dbSetOrder(1)
If !dbSeek(xfilial("SA1")+cCliente+"01")
	Reclock("SA1",.T.)
	SA1->A1_FILIAL  := cFilial
	SA1->A1_COD 	:= GetMV("MV_CLIPAD")
	SA1->A1_LOJA	:= "01"
	SA1->A1_NOME	:= "CLIENTE PADRAO"
	SA1->A1_NREDUZ  := "CLIENTE PADRAO"
	SA1->A1_BAIRRO  := "."
	SA1->A1_MUN 	:= "."
	SA1->A1_EST 	:= SuperGetMv("MV_ESTADO")
	SA1->A1_End 	:= "."
	SA1->A1_TIPO	:= "J"
	MsUnlock()
	FKCOMMIT()
Endif

dbSelectArea( "SE1" )
dbSetOrder ( 1 )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o titulo ja existe. Em caso afirmativo, ser adi- ³
//³ cionado 1 ao prefixo do titulo. 									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While .T.
	
	If dbSeek( xFilial("SE1")+cPrefixo+Substr(SE5->E5_NUMCHEQ,1,TamSX3("E1_NUM")[1]) + ;
		cParcela+ Substr(MVCHEQUE,1,3) )
		cPrefixo := Soma1( cPrefixo )
		Loop
	Endif
	Reclock("SE1",.T.)
	SE1->E1_FILIAL 	:= xFilial()
	SE1->E1_PREFIXO	:= cPrefixo
	SE1->E1_NUM 		:= Substr(SE5->E5_NUMCHEQ,1,TamSX3("E1_NUM")[1])
	SE1->E1_TIPO		:= MVCHEQUE
	SE1->E1_PARCELA	:= cParcela
	SE1->E1_VENCTO 	:= SE5->E5_VENCTO
	SE1->E1_VENCREA	:= DataValida(SE5->E5_VENCTO,.T.)
	SE1->E1_VENCORI	:= DataValida(SE5->E5_VENCTO,.T.)
	SE1->E1_VALOR		:= SE5->E5_VALOR
	SE1->E1_SALDO		:= SE5->E5_VALOR
	SE1->E1_NATUREZ	:= SE5->E5_NATUREZ
	SE1->E1_EMISSAO	:= SE5->E5_DATA
	SE1->E1_EMIS1		:= SE5->E5_DATA
	SE1->E1_HIST		:= SE5->E5_HISTOR
	SE1->E1_SITUACA	:= "0"
	SE1->E1_CLIENTE	:= IIF(Empty(SE5->E5_CLIFOR),Getmv("MV_CLIPAD"),SE5->E5_CLIFOR)
	SE1->E1_LOJA		:= "01"
	SE1->E1_MOEDA		:= 1
	dbSelectArea("SA1")
	dbSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
	dbSelectArea("SE1")
	SE1->E1_NOMCLI := SA1->A1_NREDUZ
	SE1->E1_VLCRUZ := SE1->E1_VALOR
	If SpbInUse()
		SE1->E1_MODSPB := SE5->E5_MODSPB
	Endif
	Exit
End
MsUnLock()
dbSelectArea( cAlias )
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fa100TitPg³ Autor ³ Valter G. Nogueira Jr.³ Data ³ 17/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera titulo de cheque, com data do vencimento               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa100TitPg()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA100                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fa100TitPg()
Local cAlias	:= Alias()
Local cPrefixo := "CHQ"
Local cParcela := TamParcela("E2_PARCELA","1","01","001")
Local cFornece := GetMv("MV_FORPAD")

//Cria Fornecedor Padrao
dbSelectArea("SA2")
dbSetOrder(1)
If !dbSeek(xfilial("SA2")+cFornece+"00")
	Reclock("SA2",.T.)
	SA2->A2_FILIAL := cFilial
	SA2->A2_COD 	:= GetMV("MV_FORPAD")
	SA2->A2_LOJA	:= "00"
	SA2->A2_NOME	:= "FORNECEDOR PADRAO"
	SA2->A2_NREDUZ := "FORNECEDOR PADRAO"
	SA2->A2_BAIRRO := "."
	SA2->A2_MUN 	:= "."
	SA2->A2_EST 	:= SuperGetMv("MV_ESTADO")
	SA2->A2_End 	:= "."
	SA2->A2_TIPO	:= "J"
	MsUnlock()
	FKCOMMIT()
Endif

dbSelectArea( "SE2" )
dbSetOrder ( 1 )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o titulo j  existe. Em caso afirmativo, ser adi- ³
//³ cionado 1 ao prefixo do titulo. 									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While .T.
	
	If dbSeek( xFilial("SE2")+cPrefixo+Substr(SE5->E5_NUMCHEQ,1,TamSX3("E1_NUM")[1]) + ;
		cParcela+ Substr(MVCHEQUE,1,3))
		cPrefixo := Soma1( cPrefixo )
		LOOP
	End
	
	Reclock("SE2",.T.)
	SE2->E2_FILIAL  	:= cFilial
	SE2->E2_PREFIXO 	:= cPrefixo
	SE2->E2_NUM 	 	:= Substr(SE5->E5_NUMCHEQ,1,TamSX3("E1_NUM")[1])
	SE2->E2_TIPO	 	:= MVCHEQUE
	SE2->E2_PARCELA 	:= cParcela
	SE2->E2_VENCTO  	:= SE5->E5_VENCTO
	SE2->E2_VENCREA 	:= DataValida(SE5->E5_VENCTO,.T.)
	SE2->E2_VENCORI 	:= DataValida(SE5->E5_VENCTO,.T.)
	SE2->E2_VALOR	 	:= SE5->E5_VALOR
	SE2->E2_SALDO	 	:= SE5->E5_VALOR
	SE2->E2_NATUREZ 	:= SE5->E5_NATUREZ
	SE2->E2_EMISSAO 	:= SE5->E5_DATA
	SE2->E2_EMIS1	 	:= SE5->E5_DATA
	SE2->E2_HIST	 	:= SE5->E5_HISTOR
	SE2->E2_FORNECE 	:= IIF(Empty(SE5->E5_CLIFOR),Getmv("MV_FORPAD"),SE5->E5_CLIFOR)
	SE2->E2_LOJA	 	:= "00"
	SE2->E2_MOEDA	 	:= 1
	SE2->E2_VLCRUZ  	:= SE2->E2_VALOR
	SE2->E2_ORIGEM  	:= "FINA100"		// Identifica Rotina Geradora
	dbSelectArea("SA2")
	dbSeek(cFilial+SE2->E2_FORNECE+SE2->E2_LOJA)
	dbSelectArea("SE2")
	Replace E2_NOMFOR With SA2->A2_NREDUZ
	If SpbInUse()
		SE2->E2_MODSPB := SE5->E5_MODSPB
	Endif
	Exit
Enddo
MsUnLock()
dbSelectArea( cAlias )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fa100DocTran³ Autor ³ Wagner Xavier         ³ Data ³ 14/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ponto de entrada para manipular variavel cDocTran             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa100DocTran(cBcoOrig,cAgenOrig,cCtaOrig,cTipoTran,cDocTran)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fa100DocTran(cBcoOrig,cAgenOrig,cCtaOrig,cTipoTran,cDocTran)

If ExistBlock("FA100DOC")
	cDocTran := ExecBlock("FA100DOC", .F., .F., {cBcoOrig, cAgenOrig,cCtaOrig,cTipoTran})
EndIf

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fa100grava³ Autor ³ Wagner Xavier         ³ Data ³ 08/09/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Faz as atualizacoes para transferencia.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa100grava()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA100                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function fa100grava(cFilOrig,cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,;
cFilDest,cBcoDest,cAgenDest,cCtaDest,cNaturDes,;
cTipoTran,cDocTran,nValorTran,cHist100,;
cBenef100,lEstorno,cModSpb,aTrfPms)

Local lPadrao1:=.F.
Local lPadrao2:=.F.
Local cPadrao:="560"
Local lMostra,lAglutina
Local lA100TR01	:= ExistBlock("A100TR01")
Local lA100TR02	:= ExistBlock("A100TR02")
Local lA100TR03	:= ExistBlock("A100TR03")
Local lA100TRA	:= ExistBlock("A100TRA")
Local lA100TRB	:= ExistBlock("A100TRB")
Local lA100TRC	:= ExistBlock("A100TRC")
Local nRegSEF := 0
Local nMoedOrig   := 1
Local nMoedTran	:=	1
Local lSpbInUse	:= SpbInUse()

lEstorno := IIF (lEstorno == NIL , .F., lEstorno)

DEFAULT aTrfPms	:= {}
DEFAULT lExterno  := .F.

STRLCTPAD := " "

If !(Empty(cBcoOrig+cAgenOrig+cCtaOrig))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atencao!, neste programa sera' utilizado 2 lan‡amentos padroni³
	//³ zados, pois o mesmo gera 2 registros na movimentacao bancaria³
	//³ O 1. registro para a saida  (Banco Origem ) ->Padrao "560"   ³
	//³ O 2. registro para a entrada(Banco Destino) ->Padrao "561"   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SA6" )
	dbSeek( xFilial("SA6") + cBcoDest + cAgenDest + cCtaDest )
	nMoedTran	:=	MAX(SA6->A6_MOEDA,1)
	dbSelectArea( "SA6" )
	dbSeek(  xFilial("SA6") + cBcoOrig + cAgenOrig + cCtaOrig )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza movimentacao bancaria c/referencia a saida			  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Reclock("SE5",.T.)
	SE5->E5_FILIAL		:= cFilOrig
	SE5->E5_DATA		:= dDataBase
	SE5->E5_BANCO		:= cBcoOrig
	SE5->E5_AGENCIA		:= cAgenOrig
	SE5->E5_CONTA		:= cCtaOrig
	SE5->E5_RECPAG		:= "P"
	SE5->E5_NUMCHEQ		:= cDocTran
	SE5->E5_HISTOR		:= cHist100
	SE5->E5_TIPODOC		:= "TR"
	SE5->E5_MOEDA		:= cTipoTran
	SE5->E5_VALOR		:= nValorTran
	SE5->E5_DTDIGIT		:= dDataBase
	SE5->E5_BENEF		:= cBenef100
	SE5->E5_DTDISPO		:= SE5->E5_DATA
	SE5->E5_NATUREZ		:= cNaturOri
	SE5->E5_CLASS  		:= cClassOri
	SE5->E5_FILORIG		:= cFilAnt
	
	If lSpbInUse
		SE5->E5_MODSPB	:= cModSpb
	Endif
	MsUnLock()
	If !Empty(aTrfPms) .And. !Empty(aTrfPms[1])
		nRecNo	:= SE5->(RecNo())
		cID		:= STRZERO(SE5->(RecNo()),10)
		cStart	:= "AA"
		dbSelectArea("SE5")
		dbSetOrder(9)
		While dbSeek(xFilial()+cID)
			cID := STRZERO(nRecNo,8)+cStart
			cStart := SomaIt(cStart)
		End
		SE5->(dbGoto(nRecNo))
		RecLock('SE5',.F.)
		SE5->E5_PROJPMS	:= cId
		MsUnlock()
		RecLock("AJE",.T.)
		AJE->AJE_FILIAL	:= xFilial("AJE")
		AJE->AJE_VALOR 	:= SE5->E5_VALOR
		AJE->AJE_DATA		:= SE5->E5_DATA
		AJE->AJE_HISTOR	:= SE5->E5_HISTOR
		AJE->AJE_PROJET	:= aTrfPms[1]
		AJE->AJE_REVISA	:= PmsAF8Ver(aTrfPms[1])
		AJE->AJE_TAREFA	:= aTrfPms[2]
		AJE->AJE_ID			:= cID
		MsUnlock()
	EndIf
	If (Alltrim(cTipoTran) == "TB" .or. ;
		(Alltrim(cTipoTran) == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. !lEstorno
		nRegSEF := Fa100Cheq("FINA100TRF")
	Endif
	
	If lA100TR01
		ExecBlock("A100TR01",.F.,.F.,lEstorno)
	EndIf
	If lA100TRA
		ExecBlock("A100TRA",.F.,.F.,{lEstorno, cBcoOrig,  cBcoDest,  cAgenOrig, cAgenDest, cCtaOrig,;
		cCtaDest, cNaturOri, cNaturDes, cDocTran,  cHist100})
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ So atualiza do saldo se for R$,DO,TB,TC ou se for CH e o ban-³
	//³ co origem n„o for um caixa do loja, pois este foi gerado no  ³
	//³ SE1 e somente sera atualizado na baixa do titulo.            ³
	//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
	//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
	//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((Alltrim(SE5->E5_MOEDA) $ "R$/DO/TB/TC"+IIf(cPaisLoc=="BRA","","/$ ")) .or. ;
		(SE5->E5_MOEDA == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. ;
		!(SUBSTR(SE5->E5_NUMCHEQ,1,1) == "*")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza saldo bancario.												  ³
		//³ Paso o E5_VALOR pois fora do Brasil a conta pode ser em moeda³
		//³ diferente da moea Oficial.                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AtuSalBco(cBcoOrig,cAgenOrig,cCtaOrig,dDataBase,SE5->E5_VALOR,"-")
	Endif
	
	If !lExterno
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³Lan‡amento Contabil - 1. registro do SE5									³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lPadrao1:=VerPadrao(cPadrao)
		STRLCTPAD := cBcoDest+"/"+cAgenDest+"/"+cCtaDest
		IF lPadrao1 .and. mv_par04 == 1
			nHdlPrv:=HeadProva(cLote,"FINA100",left(cUserName,6),@cArquivo)
		Endif
		
		IF lPadrao1 .and. mv_par04 == 1
			nTotal+=DetProva(nHdlPrv,cPadrao,"FINA100",cLote)
		Endif
		
		IF lPadrao1 .and. mv_par04 == 1  // On Line
			Reclock("SE5")
			Replace E5_LA With "S"
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
		//³ Conforme situação do parâmetro abaixo, integra com o SIGAGSP ³
		//³             MV_SIGAGSP - 0-Não / 1-Integra                   ³
		//³ e-mail de Fernando Mazzarolo de 08/11/2004                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
		If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
			GSPF380(3)
		EndIf
	Endif
Endif

If !(Empty(cBcoDest+cAgenDest+cCtaDest))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza movimentacao bancaria c/referencia a entrada		  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SA6" )
	dbSeek( xfilial("SA6")+ cBcoDest + cAgenDest + cCtaDest )
	Reclock("SE5",.T.)
	SE5->E5_FILIAL		:= cFilDest
	SE5->E5_DATA		:= dDataBase
	SE5->E5_BANCO		:= cBcoDest
	SE5->E5_AGENCIA		:= cAgenDest
	SE5->E5_CONTA		:= cCtaDest
	SE5->E5_RECPAG		:= "R"
	SE5->E5_DOCUMEN		:= cDocTran
	SE5->E5_HISTOR		:= cHist100
	SE5->E5_TIPODOC		:= "TR"
	SE5->E5_MOEDA		:= cTipoTran
	SE5->E5_VALOR		:= nValorTran
	SE5->E5_DTDIGIT		:= dDataBase
	SE5->E5_BENEF		:= cBenef100
	SE5->E5_DTDISPO		:= SE5->E5_DATA
	SE5->E5_NATUREZ		:= cNaturDes
	SE5->E5_CLASS  		:= cClassDes
	SE5->E5_FILORIG		:= cFilAnt
	If lSpbInUse
		SE5->E5_MODSPB	:= cModSpb
	Endif
	If !Empty(aTrfPms) .And. !Empty(aTrfPms[3])
		nRecNo	:= SE5->(RecNo())
		cID		:= STRZERO(SE5->(RecNo()),10)
		cStart	:= "AA"
		dbSelectArea("SE5")
		dbSetOrder(9)
		While dbSeek(xFilial()+cID)
			cID := STRZERO(nRecNo,8)+cStart
			cStart := SomaIt(cStart)
		EndDO
		SE5->(dbGoto(nRecNo))
		RecLock('SE5',.F.)
		SE5->E5_PROJPMS	:= cId
		MsUnlock()
		RecLock("AJE",.T.)
		AJE->AJE_FILIAL	:= xFilial("AJE")
		AJE->AJE_VALOR 	:= SE5->E5_VALOR
		AJE->AJE_DATA		:= SE5->E5_DATA
		AJE->AJE_HISTOR	:= SE5->E5_HISTOR
		AJE->AJE_PROJET	:= aTrfPms[3]
		AJE->AJE_REVISA	:= PmsAF8Ver(aTrfPms[3])
		AJE->AJE_EDT		:= aTrfPms[4]
		AJE->AJE_TAREFA	:= aTrfPms[5]
		AJE->AJE_ID			:= cID
		MsUnlock()
	EndIf
	MsUnLock()
	
	If lA100TR02
		ExecBlock("A100TR02",.F.,.F.,lEstorno)
	EndIf
	If lA100TRB
		ExecBlock("A100TRB",.F.,.F.,{lEstorno, cBcoOrig,  cBcoDest,  cAgenOrig, cAgenDest, cCtaOrig,;
		cCtaDest, cNaturOri, cNaturDes, cDocTran,  cHist100})
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ So atualiza do saldo se for R$,DO,TB,TC ou se for CH e o ban-³
	//³ co origem n„o for um caixa do loja, pois este foi gerado no  ³
	//³ SE1 e somente sera atualizado na baixa do titulo.            ³
	//³ O teste do caixa ‚ exatamente para o banco origem Mesmo.     ³
	//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
	//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
	//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((Alltrim(SE5->E5_MOEDA) $ "R$/DO/TB/TC"+IIf(cPaisLoc=="BRA","","/$ ") ) .or. ;
		(SE5->E5_MOEDA == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. ;
		!(SUBSTR(SE5->E5_NUMCHEQ,1,1) == "*")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza saldo bancario.												  ³
		//³ Paso o E5_VALOR pois fora do Brasil a conta pode ser em moeda³
		//³ diferente da moea Oficial.                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		AtuSalBco(cBcoDest,cAgenDest,cCtaDest,dDataBase,SE5->E5_VALOR,"+")
	Endif
	
	If !lExterno
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³Lan‡amento Contabil - 2. registro do SE5									³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cPadrao :="561"
		lPadrao2:=VerPadrao(cPadrao)
		STRLCTPAD := cBcoOrig+"/"+cAgenOrig+"/"+cCtaOrig
		IF lPadrao2 .and. !lPadrao1 .and. mv_par04 == 1
			nHdlPrv:=HeadProva(cLote,"FINA100",left(cUserName,6),@cArquivo)
		Endif
		
		IF lPadrao2 .and. mv_par04 == 1
			nTotal+=DetProva(nHdlPrv,cPadrao,"FINA100",cLote)
		Endif
		
		IF ( lPadrao1 .or. lPadrao2) .and. mv_par04 == 1
			RodaProva(nHdlPrv,nTotal)
			lAglutina:=Iif(mv_par01==1,.T.,.F.)
			lMostra	:=Iif(mv_par02==1,.T.,.F.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lancamento Contabil							  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lMostra,lAglutina)
			If lPadrao1 .and. nRegSEF > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se contabilizou a Saida, e Foi uma TB  / CH, ent„o  ³
				//³ marca no cheque que j  foi contabilizado.           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SEF")
				DbGoto(nRegSEF)
				Reclock("SEF")
				SEF->EF_LA := "S"
				MsUnlock()
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
		//³ Conforme situação do parâmetro abaixo, integra com o SIGAGSP ³
		//³             MV_SIGAGSP - 0-Não / 1-Integra                   ³
		//³ e-mail de Fernando Mazzarolo de 08/11/2004                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
		If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
			GSPF380(4)
		EndIf
	Endif
Endif

If lA100TR03
	ExecBlock("A100TR03",.F.,.F.,lEstorno)
EndIf
If lA100TRC
	ExecBlock("A100TRC",.F.,.F.,{lEstorno, cBcoOrig,  cBcoDest,  cAgenOrig, cAgenDest, cCtaOrig,;
	cCtaDest, cNaturOri, cNaturDes, cDocTran,  cHist100})
EndIf

IF !lExterno .and. lPadrao2 .and. mv_par04 == 1  // On Line
	Reclock("SE5")
	Replace E5_LA With "S"
EndIf

Return



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// validação das contas correntes (banco/agência/conta) por centralizadora
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _FA100TRF()
///////////////////////////

lGrava := .t.
If !(Posicione('SA6',1,xFilial('SA6') + cBcoOrig + cAgenOrig + cCtaOrig,'A6_EMPRESA') $ GetMv('MV_EMPGRP'))
	MsgAlert('Verifique Banco/Agência/Conta de origem.' + _cEnter + 'Inválido para esta empresa','ATENÇÃO!!!')
	lGrava := .f.
EndIf
If lGrava .and. !(Posicione('SA6',1,xFilial('SA6') + cBcoDest + cAgenDest + cCtaDest,'A6_EMPRESA') $ GetMv('MV_EMPGRP'))
	MsgAlert('Verifique Banco/Agência/Conta de destino.' + _cEnter + 'Inválido para esta empresa','ATENÇÃO!!!')
	lGrava := .f.
EndIf

Return(lGrava)



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// validação das contas correntes (banco/agência/conta) por centralizadora
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FA100OKR()
////////////////////////
lGrava := .t.
If !(Posicione('SA6',1,xFilial('SA6') + M->E5_BANCO + M->E5_AGENCIA + M->E5_CONTA,'A6_EMPRESA') $ GetMv('MV_EMPGRP'))
	MsgAlert('Verifique Banco/Agência/Conta do recebimento.' + _cEnter + 'Inválido para esta empresa','ATENÇÃO!!!')
	lGrava := .f.
EndIf
Return(lGrava)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F100Filial(_cVar)
///////////////////////////////
Local _lRet := (SA6->A6_EMPRESA $ Posicione('SX6',1,_cVar + "MV_EMPGRP",'X6_CONTEUD'))

Return(_lRet)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidBAC(_xFilial, _xBanco, _xAgencia, _xConta) // valida banco agencia conta
/////////////////////////////////////////////////////////////////////////////////////////////
Local _lRet      := .t.
Local cAlias    := alias()
Local cEmpresas := Posicione('SX6',1, _xFilial + "MV_EMPGRP",'X6_CONTEUD')
Local _aNaturezas := {}
aAdd(_aNaturezas,{'','','225','260'})           
aAdd(_aNaturezas,{'A0','C0','213','212'})
aAdd(_aNaturezas,{'A0','G0','217','212'})
aAdd(_aNaturezas,{'A0','01','215','212'})
aAdd(_aNaturezas,{'A0','BH','223','212'})
aAdd(_aNaturezas,{'A0','R0','219','212'})
aAdd(_aNaturezas,{'A0','T0','221','212'})
aAdd(_aNaturezas,{'C0','A0','211','214'})
aAdd(_aNaturezas,{'C0','G0','217','214'})
aAdd(_aNaturezas,{'C0','01','215','214'})
aAdd(_aNaturezas,{'C0','BH','223','214'})
aAdd(_aNaturezas,{'C0','R0','219','214'})
aAdd(_aNaturezas,{'C0','T0','221','214'})
aAdd(_aNaturezas,{'G0','A0','211','218'})
aAdd(_aNaturezas,{'G0','C0','213','218'})
aAdd(_aNaturezas,{'G0','01','215','218'})
aAdd(_aNaturezas,{'G0','BH','223','218'})
aAdd(_aNaturezas,{'G0','R0','219','218'})
aAdd(_aNaturezas,{'G0','T0','221','218'})
aAdd(_aNaturezas,{'01','A0','211','216'})
aAdd(_aNaturezas,{'01','C0','213','216'})
aAdd(_aNaturezas,{'01','G0','217','216'})
aAdd(_aNaturezas,{'01','BH','223','216'})
aAdd(_aNaturezas,{'01','R0','219','216'})
aAdd(_aNaturezas,{'01','T0','221','216'})
aAdd(_aNaturezas,{'BH','A0','211','224'})
aAdd(_aNaturezas,{'BH','C0','213','224'})
aAdd(_aNaturezas,{'BH','G0','217','224'})
aAdd(_aNaturezas,{'BH','01','215','224'})
aAdd(_aNaturezas,{'BH','R0','219','224'})
aAdd(_aNaturezas,{'BH','T0','221','224'})
aAdd(_aNaturezas,{'R0','A0','211','220'})
aAdd(_aNaturezas,{'R0','C0','213','220'})
aAdd(_aNaturezas,{'R0','G0','217','220'})
aAdd(_aNaturezas,{'R0','01','225','260'})
aAdd(_aNaturezas,{'R0','BH','223','220'})
aAdd(_aNaturezas,{'R0','T0','221','220'})
aAdd(_aNaturezas,{'T0','A0','211','222'})
aAdd(_aNaturezas,{'T0','C0','213','222'})
aAdd(_aNaturezas,{'T0','G0','217','222'})
aAdd(_aNaturezas,{'T0','01','215','222'})
aAdd(_aNaturezas,{'T0','BH','223','222'})
aAdd(_aNaturezas,{'T0','R0','219','222'})           

aAdd(_aNaturezas,{'A0','A0','225','260'})
aAdd(_aNaturezas,{'C0','C0','225','260'})
aAdd(_aNaturezas,{'G0','G0','225','260'})
aAdd(_aNaturezas,{'01','01','225','260'})
aAdd(_aNaturezas,{'BH','BH','225','260'})
aAdd(_aNaturezas,{'R0','R0','225','260'})           
aAdd(_aNaturezas,{'T0','T0','225','260'})           

If (ReadVar() $ 'CNATUORI/CNATUREDES' .and. !empty(cFilDest) .and. !empty(cFilOrig)) .or. (ReadVar() == 'CFILORIG' .and. !empty(cFilDest)) .or. (ReadVar() == 'CFILDEST' .and. !empty(cFilOrig))
	_nPos := aScan(_aNaturezas, {|x| X[1] == cFilOrig .and. X[2] == cFilDest})
	_nPos := iif(_nPos > 0, _nPos,1)
	cNaturOri := _aNaturezas[_nPos,3]
	cNaturDes := _aNaturezas[_nPos,4]
	oNaturDes:Refresh()		
	oNaturOri:Refresh()		
	ValidNatur()
	Return(.t.)
EndIf

If !(_xFilial $ GetMv('LS_MATRIZ'))
	MsgAlert('Filial deve ser uma centralizadora.','ATENÇÃO!!!','ALERT')
	Return(.f.)
EndIf

DbSelectArea("SA6") 
SA6->(DbSetOrder(1))
//If Empty(A6_EMPRESA)
//A6_EMPRESA := "1"
If Empty(cEmpresas)
cEmpresas := "1"
Set Filter to cEmpresas $ cEmpresas        //A6_EMPRESAS

If !DbSeek(xFilial('SA6') + alltrim(_xBanco) + iif(empty(_xAgencia),alltrim(_xAgencia),_xAgencia) + iif(empty(_xConta),alltrim(_xConta),_xConta),.f.)
	MsgAlert('Verifique Filial/Banco/Agência/Conta do recebimento.' + _cEnter + 'Inválido para esta empresa','ATENÇÃO!!!','ALERT')
	_lRet := .f.
EndIf
Endif
Set Filter to
DbSelectArea(cAlias)

Return(_lRet)

