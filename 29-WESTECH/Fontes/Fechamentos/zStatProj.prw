#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include 'totvs.ch'


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 
//                        Low Intensity colors 
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 
//                      High Intensity Colors 
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFIN01    ºAutor  ³Marcos Zanetti GZ   º Data ³  19/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo de fluxo de caixa                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico 		                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function zStatProj()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Geração de planilha de Project Status"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"ZSTATPROJ01"
private _cArq	:= 	"ZSTATPROJ01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aDatas	:= {} // Matriz no formato [ data , campo ]
private _aLegPer:= {} // legenda dos periodos
private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
private _nSaldoIni 	:= 0
Private _aRegSimul	:= {} // matriz com os recnos do TRB1 e do SZ3, respectivamente

private cArqTrb1 := CriaTrab(NIL,.F.) //"PFIN011"
private cArqTrb2 := CriaTrab(NIL,.F.) //"PFIN012"
private cArqTrb3 := CriaTrab(NIL,.F.) //"PFIN013"

Private _aGrpSint:= {}


ValidPerg()

AADD(aSays,"Este programa gera planilha com os dados para o Project Status.  ")
AADD(aSays,"O arquivo gerado pode ser aberto de forma automática")
AADD(aSays,"pelo Excel.")
AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
if nOpcA == 1

	if !VldParamPS() .or. !AbreArq()
		return
	endif

		//MSAguarde({||PFIN01REAL()},"Fluxo de caixa Realizado")
	if MV_PAR06 = 1 .OR. MV_PAR08 = 1
		MSAguarde({||PFIN01REAL()},"Processando Contratos EQ / ST")
	endif

	if MV_PAR03 = 1 .OR. MV_PAR05 = 1
		MSAguarde({||PROSTATAT()},"Processando Contratos AT / EN")
	endif

	if MV_PAR07 = 1
		MSAguarde({||PROSTATPR()},"Processando Contratos PR")
	endif

	if MV_PAR04 = 1
		MSAguarde({||PROSTATCM()},"Processando Contratos CM")
	endif
	
	if MV_PAR09 = 1
		MSAguarde({||PROSTATGR()},"Processando Contratos GR")
	endif

	MontaTela()


	TRB1->(dbclosearea())


endif


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFIN01REALº												   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa o Project Status EQ / ST	                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function PFIN01REAL()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""

 Local nTotalCQ5RD 	:= 0
 Local nTotalCQ5RDr := 0
 Local nCredito 	:= 0
 Local nDebito		:= 0
 Local cItem 		:= ""
 Local cConta 		:= ""

 Local nXVDSIR		:= 0
 Local nXCUPRR		:= 0
 Local nXBOOKMG		:= 0

 Local nTotalC1		:= 0
 Local nTotalC2		:= 0
 Local nTotalC3		:= 0
 Local nTotalC4		:= 0
 Local nTotalC8		:= 0
 Local nTotalC9		:= 0

 Local cMoeda		:= "01"
 Local cContaR		:= "4"
 Local cContaD		:= "5"

 Local nXPCOM		:= 0
 Local nXVCOM		:= 0
 Local nXVDSISF		:= 0

 Local nXVCOMR		:= 0
 Local nXVDSISFR	:= 0

 Local nXReceita 	:= 0
 Local nXCusto		:= 0
 Local nXCustoCom	:= 0
 Local nXMGContr	:= 0

 local dData1
 local dData2
 local cWeekJOB

CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_DTEXIS",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
CTD->(dbsetorder(1))
while QUERY->(!eof())


	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/ESTOQUE'
		QUERY->(dbskip())
		Loop
	endif

	if ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'AT/GR/CM/EN/PR'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'EQ'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'ST'
		QUERY->(dbskip())
		Loop
	endif

	/*
	if ALLTRIM(QUERY->CTD_XSTAT) == '2'
		QUERY->(dbskip())
		Loop
	endif
	*/

	if SUBSTR(QUERY->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '09'
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM < MV_PAR01
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM > MV_PAR02
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR10
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR11
		QUERY->(dbskip())
		Loop
	endif

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		TRB1->ITEM		:= QUERY->CTD_ITEM
		TRB1->CLIENTE	:= QUERY->CTD_XNREDU
		TRB1->NOMPM		:= QUERY->CTD_XNOMPM
		TRB1->XEQUIP	:= QUERY->CTD_XEQUIP
		//****************************************
		TRB1->XVDSI		:= QUERY->CTD_XVDSI

		nXPCOM			:= QUERY->CTD_XPCOM
		nXVDSISF		:= QUERY->CTD_XSISFP
		nXVCOM			:= nXVDSISF * ( nXPCOM / 100 )

		TRB1->XCUSTO	:= QUERY->CTD_XCUTOT - nXVCOM
		TRB1->XVCOM		:= nXVCOM
		//*********************************
		TRB1->XVDSIR	:= QUERY->CTD_XVDSIR



		XVDSISFR		:= QUERY->CTD_XSISFR
		nXVCOMR			:= XVDSISFR * ( nXPCOM / 100 )
		TRB1->XCUPRR	:= QUERY->CTD_XCUTOR - nXVCOMR
		//**********************************
		TRB1->VOVER		:= 0
		TRB1->VANTCOGS	:= 0
		TRB1->VAMOUNT	:= 0

		cItem 	:= ALLTRIM(QUERY->CTD_ITEM)
		dbselectarea("CQ5")

   		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0

		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaR) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "4" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=    nCredito - nDebito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XFATCONT	:= nTotalCQ5RDr
		nXReceita := nTotalCQ5RDr

		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0



		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "5" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XCOGSCONT := nTotalCQ5RD
		nXCusto := nTotalCQ5RDr


		//*********************************************************
		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0


		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := alltrim(CQ5->CQ5_CONTA)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "621020001" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XCOMCONT := nTotalCQ5RD
		nXCustoCom := nTotalCQ5RDr

		nXCustoCom := nTotalCQ5RDr



		nXMGContr :=( (nXReceita - (nXCusto + nXCustoCom)) / nXReceita )*100

		TRB1->XMGContr := nXMGContr

		//********************************************************************

		TRB1->VCOGSREV	:= 0
		TRB1->VCOGSRET	:= 0
		TRB1->VJOBCOST	:= 0

		nXCUPRR			:= QUERY->CTD_XCUTOR - nXVCOMR
		nXVDSIR			:= QUERY->CTD_XVDSIR


		nXBOOKMG		:= Round((1-nXCUPRR/nXVDSIR)*100,0)
		TRB1->XBOOKMG	:= nXBOOKMG
		TRB1->VCURRMG	:= 0
		TRB1->VPRANMG	:= 0
		TRB1->VPROREC	:= 0
		TRB1->VUSAGAAP	:= 0
		TRB1->DTEXIS	:= QUERY->CTD_DTEXIS


		TRB1->XDAPCT	:= QUERY->CTD_XDAPCT

		TRB1->XDTAPR	:= QUERY->CTD_XDTAPR
		TRB1->XDTAVC	:= QUERY->CTD_XDTAVC
		TRB1->XDTAVR	:= QUERY->CTD_XDTAVR
		TRB1->XDTFAP	:= QUERY->CTD_XDTFAP
		TRB1->XDTFAR	:= QUERY->CTD_XDTFAR
		TRB1->XDTEVC	:= QUERY->CTD_XDTEVC
		TRB1->XDTEVR	:= QUERY->CTD_XDTEVR
		TRB1->XDTCOC	:= QUERY->CTD_XDTCOC
		TRB1->XDTCOP	:= QUERY->CTD_XDTCOP

		dData1 := QUERY->CTD_XDTEVC
		dData2 := Date()

		cWeekJOB := (dData1 - dData2)/7

		IF Empty(dData1)
			TRB1->XDTWK		:= 0
		Else
			TRB1->XDTWK		:= cWeekJOB
		Endif


		nTotalC1 		+= QUERY->CTD_XVDSI
		nTotalC2 		+= QUERY->CTD_XCUTOT - nXVCOM
		nTotalC3 		+= QUERY->CTD_XVDSIR
		nTotalC4 		+= QUERY->CTD_XCUTOR - nXVCOMR
		nTotalC8 		+= TRB1->XFATCONT
		nTotalC9 		+= TRB1->XCOGSCONT

		MsUnlock()

	QUERY->(dbskip())

enddo
	RecLock("TRB1",.T.)
	QUERY->(dbskip())
		TRB1->ITEM		:= "TOTAL CAPITAL PROJECT"
		TRB1->XVDSI		:= nTotalC1
		TRB1->XCUSTO	:= nTotalC2
		TRB1->XVDSIR	:= nTotalC3
		TRB1->XCUPRR	:= nTotalC4
		TRB1->XFATCONT	:= nTotalC8
		TRB1->XCOGSCONT	:= nTotalC9
	MsUnlock()
	RecLock("TRB1",.T.)
	QUERY->(dbskip())
		TRB1->ITEM		:= ""
	MsUnlock()

QUERY->(dbclosearea())
CQ5->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFIN01REALº												   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa o Project Status AT	/ EN	                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function PROSTATAT()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""

 Local nTotalCQ5RD 	:= 0
 Local nTotalCQ5RDr := 0
 Local nCredito 	:= 0
 Local nDebito		:= 0
 Local cItem 		:= ""
 Local cConta 		:= ""

 Local nXVDSIR		:= 0
 Local nXCUPRR		:= 0
 Local nXBOOKMG		:= 0

 Local nTotalC1		:= 0
 Local nTotalC2		:= 0
 Local nTotalC3		:= 0
 Local nTotalC4		:= 0
 Local nTotalC8		:= 0
 Local nTotalC9		:= 0

 Local cMoeda		:= "01"
 Local cContaR		:= "4"
 Local cContaD		:= "5"

 Local nXPCOM		:= 0
 Local nXVCOM		:= 0
 Local nXVDSISF		:= 0

 Local nXVCOMR		:= 0
 Local nXVDSISFR	:= 0

 Local nXReceita 	:= 0
 Local nXCusto		:= 0
 Local nXCustoCom	:= 0
 Local nXMGContr	:= 0

 local dData1
 local dData2
 local cWeekJOB

CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_DTEXIS",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
CTD->(dbsetorder(1))
while QUERY->(!eof())


	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/ESTOQUE/OPERACOES'
		QUERY->(dbskip())
		Loop
	endif

	if ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'GR/CM/PR/ST/EQ'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'AT'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'EN'
		QUERY->(dbskip())
		Loop
	endif

	/*
	if ALLTRIM(QUERY->CTD_XSTAT) == '2'
		QUERY->(dbskip())
		Loop
	endif
	*/

	if SUBSTR(QUERY->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '09'
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM < MV_PAR01
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM > MV_PAR02
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR10
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR11
		QUERY->(dbskip())
		Loop
	endif


	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		TRB1->ITEM		:= QUERY->CTD_ITEM
		TRB1->CLIENTE	:= QUERY->CTD_XNREDU
		TRB1->NOMPM		:= QUERY->CTD_XNOMPM
		TRB1->XEQUIP	:= QUERY->CTD_XEQUIP
		//****************************************
		TRB1->XVDSI		:= QUERY->CTD_XVDSI

		nXPCOM			:= QUERY->CTD_XPCOM
		nXVDSISF		:= QUERY->CTD_XSISFP
		nXVCOM			:= nXVDSISF * ( nXPCOM / 100 )

		TRB1->XCUSTO	:= QUERY->CTD_XCUTOT - nXVCOM
		TRB1->XVCOM		:= nXVCOM
		//*********************************
		TRB1->XVDSIR	:= QUERY->CTD_XVDSIR

		XVDSISFR		:= QUERY->CTD_XSISFR
		nXVCOMR			:= XVDSISFR * ( nXPCOM / 100 )
		TRB1->XCUPRR	:= QUERY->CTD_XCUTOR - nXVCOMR
		//**********************************
		TRB1->VOVER		:= 0
		TRB1->VANTCOGS	:= 0
		TRB1->VAMOUNT	:= 0

		cItem 	:= QUERY->CTD_ITEM
		dbselectarea("CQ5")

			nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0


		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaR) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "4" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=    nCredito - nDebito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XFATCONT	:= nTotalCQ5RDr
		nXReceita := nTotalCQ5RDr

		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0

		//*************************************
		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)

			IF cConta == "5" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XCOGSCONT := nTotalCQ5RD
		nXCusto := nTotalCQ5RDr

		//*********************************************************
		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0


		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := alltrim(CQ5->CQ5_CONTA)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "621020001" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XCOMCONT := nTotalCQ5RD
		nXCustoCom := nTotalCQ5RDr

		nXCustoCom := nTotalCQ5RDr

		nXMGContr :=( (nXReceita - (nXCusto + nXCustoCom)) / nXReceita )*100

		TRB1->XMGContr := nXMGContr


		//********************************************************************

		TRB1->VCOGSREV	:= 0
		TRB1->VCOGSRET	:= 0
		TRB1->VJOBCOST	:= 0
		nXCUPRR			:= QUERY->CTD_XCUTOR - nXVCOMR
		nXVDSIR			:= QUERY->CTD_XVDSIR
		nXBOOKMG		:= Round((1-nXCUPRR/nXVDSIR)*100,0)
		TRB1->XBOOKMG	:= nXBOOKMG
		TRB1->VCURRMG	:= 0
		TRB1->VPRANMG	:= 0
		TRB1->VPROREC	:= 0
		TRB1->VUSAGAAP	:= 0
		TRB1->DTEXIS	:= QUERY->CTD_DTEXIS

		TRB1->XDAPCT	:= QUERY->CTD_XDAPCT

		TRB1->XDTAPR	:= QUERY->CTD_XDTAPR
		TRB1->XDTAVC	:= QUERY->CTD_XDTAVC
		TRB1->XDTAVR	:= QUERY->CTD_XDTAVR
		TRB1->XDTFAP	:= QUERY->CTD_XDTFAP
		TRB1->XDTFAR	:= QUERY->CTD_XDTFAR
		TRB1->XDTEVC	:= QUERY->CTD_XDTEVC
		TRB1->XDTEVR	:= QUERY->CTD_XDTEVR
		TRB1->XDTCOC	:= QUERY->CTD_XDTCOC
		TRB1->XDTCOP	:= QUERY->CTD_XDTCOP

		dData1 := QUERY->CTD_XDTEVC
		dData2 := Date()

		cWeekJOB := (dData1 - dData2)/7

		IF Empty(dData1)
			TRB1->XDTWK		:= 0
		Else
			TRB1->XDTWK		:= cWeekJOB
		Endif


		nTotalC1 		+= QUERY->CTD_XVDSI
		nTotalC2 		+= QUERY->CTD_XCUTOT - nXVCOM
		nTotalC3 		+= QUERY->CTD_XVDSIR
		nTotalC4 		+= QUERY->CTD_XCUTOR - nXVCOMR
		nTotalC8 		+= TRB1->XFATCONT
		nTotalC9 		+= TRB1->XCOGSCONT

		MsUnlock()

	QUERY->(dbskip())

enddo
	RecLock("TRB1",.T.)
	QUERY->(dbskip())
		TRB1->ITEM		:= "TOTAL SERVICE"
		TRB1->XVDSI		:= nTotalC1
		TRB1->XCUSTO	:= nTotalC2
		TRB1->XVDSIR	:= nTotalC3
		TRB1->XCUPRR	:= nTotalC4
		TRB1->XFATCONT	:= nTotalC8
		TRB1->XCOGSCONT	:= nTotalC9
	MsUnlock()
	RecLock("TRB1",.T.)
	QUERY->(dbskip())
		TRB1->ITEM		:= ""
	MsUnlock()

QUERY->(dbclosearea())
CQ5->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROSTATPR												   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa o Project Status PR			                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function PROSTATPR()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""

 Local nTotalCQ5RD 	:= 0
 Local nTotalCQ5RDr := 0
 Local nCredito 	:= 0
 Local nDebito		:= 0
 Local cItem 		:= ""
 Local cConta 		:= ""

 Local nXVDSIR		:= 0
 Local nXCUPRR		:= 0
 Local nXBOOKMG		:= 0

 Local nTotalC1		:= 0
 Local nTotalC2		:= 0
 Local nTotalC3		:= 0
 Local nTotalC4		:= 0
 Local nTotalC8		:= 0
 Local nTotalC9		:= 0

  Local cMoeda		:= "01"
 Local cContaR		:= "4"
 Local cContaD		:= "5"

 Local nXPCOM		:= 0
 Local nXVCOM		:= 0
 Local nXVDSISF		:= 0

 Local nXVCOMR		:= 0
 Local nXVDSISFR	:= 0

 Local nXReceita 	:= 0
 Local nXCusto		:= 0
 Local nXCustoCom	:= 0
 Local nXMGContr	:= 0

 local dData1
 local dData2
 local cWeekJOB

CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_DTEXIS",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
CTD->(dbsetorder(1))
while QUERY->(!eof())


	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/ESTOQUE/OPERACOES'
		QUERY->(dbskip())
		Loop
	endif

	if ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'GR/CM/EN/AT/ST/EQ'
		QUERY->(dbskip())
		Loop
	endif

	/*
	if ALLTRIM(QUERY->CTD_XSTAT) == '2'
		QUERY->(dbskip())
		Loop
	endif
	*/

	if SUBSTR(QUERY->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '09'
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM < MV_PAR01
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM > MV_PAR02
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR10
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR11
		QUERY->(dbskip())
		Loop
	endif

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		TRB1->ITEM		:= QUERY->CTD_ITEM
		TRB1->CLIENTE	:= QUERY->CTD_XNREDU
		TRB1->NOMPM		:= QUERY->CTD_XNOMPM
		TRB1->XEQUIP	:= QUERY->CTD_XEQUIP
		//****************************************
		TRB1->XVDSI		:= QUERY->CTD_XVDSI

		nXPCOM			:= QUERY->CTD_XPCOM
		nXVDSISF		:= QUERY->CTD_XSISFP
		nXVCOM			:= nXVDSISF * ( nXPCOM / 100 )

		TRB1->XCUSTO	:= QUERY->CTD_XCUTOT - nXVCOM
		TRB1->XVCOM		:= nXVCOM
		//*********************************
		TRB1->XVDSIR	:= QUERY->CTD_XVDSIR

		XVDSISFR		:= QUERY->CTD_XSISFR
		nXVCOMR			:= XVDSISFR * ( nXPCOM / 100 )
		TRB1->XCUPRR	:= QUERY->CTD_XCUTOR - nXVCOMR
		//**********************************
		TRB1->VOVER		:= 0
		TRB1->VANTCOGS	:= 0
		TRB1->VAMOUNT	:= 0

		cItem 	:= QUERY->CTD_ITEM
		dbselectarea("CQ5")

		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0


		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaR) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "4" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=    nCredito - nDebito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XFATCONT	:= nTotalCQ5RDr
		nXReceita := nTotalCQ5RDr

		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0

		//*************************************
		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)

			IF cConta == "5" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XCOGSCONT := nTotalCQ5RD
		nXCusto := nTotalCQ5RDr

		//*********************************************************
		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0


		CQ5->( dbSetOrder(7))
		CQ5->(dbgotop())
		CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "621020001" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XCOMCONT := nTotalCQ5RD
		nXCustoCom := nTotalCQ5RDr

		nXCustoCom := nTotalCQ5RDr

		nXMGContr :=( (nXReceita - (nXCusto + nXCustoCom)) / nXReceita )*100

		TRB1->XMGContr := nXMGContr


		//********************************************************************

		TRB1->VCOGSREV	:= 0
		TRB1->VCOGSRET	:= 0
		TRB1->VJOBCOST	:= 0
		nXCUPRR			:= QUERY->CTD_XCUTOR - nXVCOMR
		nXVDSIR			:= QUERY->CTD_XVDSIR
		nXBOOKMG		:= Round((1-nXCUPRR/nXVDSIR)*100,0)
		TRB1->XBOOKMG	:= nXBOOKMG
		TRB1->VCURRMG	:= 0
		TRB1->VPRANMG	:= 0
		TRB1->VPROREC	:= 0
		TRB1->VUSAGAAP	:= 0
		TRB1->DTEXIS	:= QUERY->CTD_DTEXIS

		TRB1->XDAPCT	:= QUERY->CTD_XDAPCT

		TRB1->XDTAPR	:= QUERY->CTD_XDTAPR
		TRB1->XDTAVC	:= QUERY->CTD_XDTAVC
		TRB1->XDTAVR	:= QUERY->CTD_XDTAVR
		TRB1->XDTFAP	:= QUERY->CTD_XDTFAP
		TRB1->XDTFAR	:= QUERY->CTD_XDTFAR
		TRB1->XDTEVC	:= QUERY->CTD_XDTEVC
		TRB1->XDTEVR	:= QUERY->CTD_XDTEVR
		TRB1->XDTCOC	:= QUERY->CTD_XDTCOC
		TRB1->XDTCOP	:= QUERY->CTD_XDTCOP

		dData1 := QUERY->CTD_XDTEVC
		dData2 := Date()

		cWeekJOB := (dData1 - dData2)/7

		IF Empty(dData1)
			TRB1->XDTWK		:= 0
		Else
			TRB1->XDTWK		:= cWeekJOB
		Endif

		nTotalC1 		+= QUERY->CTD_XVDSI
		nTotalC2 		+= QUERY->CTD_XCUTOT - nXVCOM
		nTotalC3 		+= QUERY->CTD_XVDSIR
		nTotalC4 		+= QUERY->CTD_XCUTOR - nXVCOMR
		nTotalC8 		+= TRB1->XFATCONT
		nTotalC9 		+= TRB1->XCOGSCONT

		MsUnlock()

	QUERY->(dbskip())

enddo
	RecLock("TRB1",.T.)
	QUERY->(dbskip())
		TRB1->ITEM		:= "TOTAL PARTS"
		TRB1->XVDSI		:= nTotalC1
		TRB1->XCUSTO	:= nTotalC2
		TRB1->XVDSIR	:= nTotalC3
		TRB1->XCUPRR	:= nTotalC4
		TRB1->XFATCONT	:= nTotalC8
		TRB1->XCOGSCONT	:= nTotalC9
	MsUnlock()
	RecLock("TRB1",.T.)
	QUERY->(dbskip())
		TRB1->ITEM		:= ""

	MsUnlock()

QUERY->(dbclosearea())
CQ5->(dbclosearea())

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROSTATPR												   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa o Project Status PR			                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function PROSTATCM()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""

 Local nTotalCQ5RD 	:= 0
 Local nTotalCQ5RDr := 0
 Local nCredito 	:= 0
 Local nDebito		:= 0
 Local cItem 		:= ""
 Local cConta 		:= ""

 Local nXVDSIR		:= 0
 Local nXCUPRR		:= 0
 Local nXBOOKMG		:= 0

 Local nTotalC1		:= 0
 Local nTotalC2		:= 0
 Local nTotalC3		:= 0
 Local nTotalC4		:= 0
 Local nTotalC8		:= 0
 Local nTotalC9		:= 0

 Local cMoeda		:= "01"
 Local cContaR		:= "4"
 Local cContaD		:= "5"

 Local nXPCOM		:= 0
 Local nXVCOM		:= 0
 Local nXVDSISF		:= 0

 Local nXReceita 	:= 0
 Local nXCusto		:= 0
 Local nXCustoCom	:= 0
 Local nXMGContr	:= 0

 Local nXVCOMR		:= 0
 Local nXVDSISFR	:= 0
 local dData1
 local dData2
 local cWeekJOB



CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_DTEXIS",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
CTD->(dbsetorder(1))
while QUERY->(!eof())


	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/ESTOQUE/OPERACOES'
		QUERY->(dbskip())
		Loop
	endif

	if ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'GR/PR/EN/AT/ST/EQ'
		QUERY->(dbskip())
		Loop
	endif

	/*
	if ALLTRIM(QUERY->CTD_XSTAT) == '2'
		QUERY->(dbskip())
		Loop
	endif
	*/

	if SUBSTR(QUERY->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '09'
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM < MV_PAR01
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM > MV_PAR02
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR10
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR11
		QUERY->(dbskip())
		Loop
	endif

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		TRB1->ITEM		:= QUERY->CTD_ITEM
		TRB1->CLIENTE	:= QUERY->CTD_XNREDU
		TRB1->NOMPM		:= QUERY->CTD_XNOMPM
		TRB1->XEQUIP	:= QUERY->CTD_XEQUIP
		//****************************************
		TRB1->XVDSI		:= QUERY->CTD_XVDSI

		nXPCOM			:= QUERY->CTD_XPCOM
		nXVDSISF		:= QUERY->CTD_XSISFP
		nXVCOM			:= nXVDSISF * ( nXPCOM / 100 )

		TRB1->XCUSTO	:= QUERY->CTD_XCUTOT - nXVCOM
		TRB1->XVCOM		:= nXVCOM
		//*********************************
		TRB1->XVDSIR	:= QUERY->CTD_XVDSIR

		XVDSISFR		:= QUERY->CTD_XSISFR
		nXVCOMR			:= XVDSISFR * ( nXPCOM / 100 )
		TRB1->XCUPRR	:= QUERY->CTD_XCUTOR - nXVCOMR
		//**********************************
		TRB1->VOVER		:= 0
		TRB1->VANTCOGS	:= 0
		TRB1->VAMOUNT	:= 0

		cItem 	:= QUERY->CTD_ITEM
		dbselectarea("CQ5")

		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0


		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		//CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaR) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "4" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=    nCredito - nDebito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XFATCONT	:= nTotalCQ5RDr
		nXReceita := nTotalCQ5RDr

		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0

		//*************************************
		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		//CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)

			IF cConta == "5" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XCOGSCONT := nTotalCQ5RD
		nXCusto := nTotalCQ5RDr

		//*********************************************************
		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0


		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		//CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := alltrim(CQ5->CQ5_CONTA)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "621020001" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XCOMCONT := nTotalCQ5RD
		nXCustoCom := nTotalCQ5RDr

		nXCustoCom := nTotalCQ5RDr

		nXMGContr :=( (nXReceita - (nXCusto + nXCustoCom)) / nXReceita )*100

		TRB1->XMGContr := nXMGContr


		//********************************************************************

		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0

		//*************************************
		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		//CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,3)

			IF cConta == "113" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XESTCONT := nTotalCQ5RD



		TRB1->VCOGSREV	:= 0
		TRB1->VCOGSRET	:= 0
		TRB1->VJOBCOST	:= 0
		nXCUPRR			:= QUERY->CTD_XCUTOR - nXVCOMR
		nXVDSIR			:= QUERY->CTD_XVDSIR
		nXBOOKMG		:= Round((1-nXCUPRR/nXVDSIR)*100,0)
		TRB1->XBOOKMG	:= nXBOOKMG
		TRB1->VCURRMG	:= 0
		TRB1->VPRANMG	:= 0
		TRB1->VPROREC	:= 0
		TRB1->VUSAGAAP	:= 0
		TRB1->DTEXIS	:= QUERY->CTD_DTEXIS

		TRB1->XDAPCT	:= QUERY->CTD_XDAPCT

		TRB1->XDTAPR	:= QUERY->CTD_XDTAPR
		TRB1->XDTAVC	:= QUERY->CTD_XDTAVC
		TRB1->XDTAVR	:= QUERY->CTD_XDTAVR
		TRB1->XDTFAP	:= QUERY->CTD_XDTFAP
		TRB1->XDTFAR	:= QUERY->CTD_XDTFAR
		TRB1->XDTEVC	:= QUERY->CTD_XDTEVC
		TRB1->XDTEVR	:= QUERY->CTD_XDTEVR
		TRB1->XDTCOC	:= QUERY->CTD_XDTCOC
		TRB1->XDTCOP	:= QUERY->CTD_XDTCOP

		dData1 := QUERY->CTD_XDTEVC
		dData2 := Date()

		cWeekJOB := (dData1 - dData2) /7

		IF Empty(dData1)
			TRB1->XDTWK		:= 0
		Else
			TRB1->XDTWK		:= cWeekJOB
		Endif


		nTotalC1 		+= QUERY->CTD_XVDSI
		nTotalC2 		+= QUERY->CTD_XCUTOT - nXVCOM
		nTotalC3 		+= QUERY->CTD_XVDSIR
		nTotalC4 		+= QUERY->CTD_XCUTOR - nXVCOMR
		nTotalC8 		+= TRB1->XFATCONT
		nTotalC9 		+= TRB1->XCOGSCONT

		MsUnlock()

	QUERY->(dbskip())

enddo
	RecLock("TRB1",.T.)
	QUERY->(dbskip())
		TRB1->ITEM		:= "TOTAL COMMISSIONS"
		TRB1->XVDSI		:= nTotalC1
		TRB1->XCUSTO	:= nTotalC2
		TRB1->XVDSIR	:= nTotalC3
		TRB1->XCUPRR	:= nTotalC4
		TRB1->XFATCONT	:= nTotalC8
		TRB1->XCOGSCONT	:= nTotalC9
	MsUnlock()


QUERY->(dbclosearea())
CQ5->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROSTATPR												   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa o Project Status PR			                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function PROSTATGR()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""

 Local nTotalCQ5RD 	:= 0
 Local nTotalCQ5RDr := 0
 Local nCredito 	:= 0
 Local nDebito		:= 0
 Local cItem 		:= ""
 Local cConta 		:= ""

 Local nXVDSIR		:= 0
 Local nXCUPRR		:= 0
 Local nXBOOKMG		:= 0

 Local nTotalC1		:= 0
 Local nTotalC2		:= 0
 Local nTotalC3		:= 0
 Local nTotalC4		:= 0
 Local nTotalC8		:= 0
 Local nTotalC9		:= 0

 Local cMoeda		:= "01"
 Local cContaR		:= "4"
 Local cContaD		:= "5"

 Local nXPCOM		:= 0
 Local nXVCOM		:= 0
 Local nXVDSISF		:= 0

 Local nXReceita 	:= 0
 Local nXCusto		:= 0
 Local nXCustoCom	:= 0
 Local nXMGContr	:= 0

 Local nXVCOMR		:= 0
 Local nXVDSISFR	:= 0
 local dData1
 local dData2
 local cWeekJOB



CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_DTEXIS",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
CTD->(dbsetorder(1))
while QUERY->(!eof())


	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/ESTOQUE/OPERACOES'
		QUERY->(dbskip())
		Loop
	endif

	if ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'CM/PR/EN/AT/ST/EQ'
		QUERY->(dbskip())
		Loop
	endif

	/*
	if ALLTRIM(QUERY->CTD_XSTAT) == '2'
		QUERY->(dbskip())
		Loop
	endif
	*/

	if SUBSTR(QUERY->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '09'
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM < MV_PAR01
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM > MV_PAR02
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR10
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR11
		QUERY->(dbskip())
		Loop
	endif

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		TRB1->ITEM		:= QUERY->CTD_ITEM
		TRB1->CLIENTE	:= QUERY->CTD_XNREDU
		TRB1->NOMPM		:= QUERY->CTD_XNOMPM
		TRB1->XEQUIP	:= QUERY->CTD_XEQUIP
		//****************************************
		TRB1->XVDSI		:= QUERY->CTD_XVDSI

		nXPCOM			:= QUERY->CTD_XPCOM
		nXVDSISF		:= QUERY->CTD_XSISFP
		nXVCOM			:= nXVDSISF * ( nXPCOM / 100 )

		TRB1->XCUSTO	:= QUERY->CTD_XCUTOT - nXVCOM
		TRB1->XVCOM		:= nXVCOM
		//*********************************
		TRB1->XVDSIR	:= QUERY->CTD_XVDSIR

		XVDSISFR		:= QUERY->CTD_XSISFR
		nXVCOMR			:= XVDSISFR * ( nXPCOM / 100 )
		TRB1->XCUPRR	:= QUERY->CTD_XCUTOR - nXVCOMR
		//**********************************
		TRB1->VOVER		:= 0
		TRB1->VANTCOGS	:= 0
		TRB1->VAMOUNT	:= 0

		cItem 	:= QUERY->CTD_ITEM
		dbselectarea("CQ5")

		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0


		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		//CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaR) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "4" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=    nCredito - nDebito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XFATCONT	:= nTotalCQ5RDr
		nXReceita := nTotalCQ5RDr

		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0

		//*************************************
		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		//CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,1)

			IF cConta == "5" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XCOGSCONT := nTotalCQ5RD
		nXCusto := nTotalCQ5RDr

		//*********************************************************
		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0


		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		//CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := alltrim(CQ5->CQ5_CONTA)
			cItem 	:= QUERY->CTD_ITEM

			IF cConta == "621020001" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XCOMCONT := nTotalCQ5RD
		nXCustoCom := nTotalCQ5RDr

		nXCustoCom := nTotalCQ5RDr

		nXMGContr :=( (nXReceita - (nXCusto + nXCustoCom)) / nXReceita )*100

		TRB1->XMGContr := nXMGContr


		//********************************************************************

		nTotalCQ5RD 	:= 0
		nTotalCQ5RDr 	:= 0
		nCredito 		:= 0
		nDebito			:= 0

		//*************************************
		CQ5->( dbSetOrder(4))
		CQ5->(dbgotop())
		//CQ5->( dbSeek( xFilial("CQ5")+cItem+cMoeda+cContaD) )

		while CQ5->(!eof())
			cConta := substr(CQ5->CQ5_CONTA,1,3)

			IF cConta == "113" .AND. alltrim(CQ5->CQ5_ITEM) == cItem .AND. alltrim(CQ5->CQ5_MOEDA) == "01" .AND. ALLTRIM(CQ5->CQ5_LP) <> "Z"
				nCredito	:= CQ5->CQ5_CREDIT
				nDebito		:= CQ5->CQ5_DEBITO
				nTotalCQ5RD		+=   nDebito -nCredito
				CQ5->(dbskip())
			ELSE
				CQ5->(dbskip())
			ENDIF

			nTotalCQ5RDr 	:= nTotalCQ5RD

		enddo

		TRB1->XESTCONT := nTotalCQ5RD



		TRB1->VCOGSREV	:= 0
		TRB1->VCOGSRET	:= 0
		TRB1->VJOBCOST	:= 0
		nXCUPRR			:= QUERY->CTD_XCUTOR - nXVCOMR
		nXVDSIR			:= QUERY->CTD_XVDSIR
		nXBOOKMG		:= Round((1-nXCUPRR/nXVDSIR)*100,0)
		TRB1->XBOOKMG	:= nXBOOKMG
		TRB1->VCURRMG	:= 0
		TRB1->VPRANMG	:= 0
		TRB1->VPROREC	:= 0
		TRB1->VUSAGAAP	:= 0
		TRB1->DTEXIS	:= QUERY->CTD_DTEXIS

		TRB1->XDAPCT	:= QUERY->CTD_XDAPCT

		TRB1->XDTAPR	:= QUERY->CTD_XDTAPR
		TRB1->XDTAVC	:= QUERY->CTD_XDTAVC
		TRB1->XDTAVR	:= QUERY->CTD_XDTAVR
		TRB1->XDTFAP	:= QUERY->CTD_XDTFAP
		TRB1->XDTFAR	:= QUERY->CTD_XDTFAR
		TRB1->XDTEVC	:= QUERY->CTD_XDTEVC
		TRB1->XDTEVR	:= QUERY->CTD_XDTEVR
		TRB1->XDTCOC	:= QUERY->CTD_XDTCOC
		TRB1->XDTCOP	:= QUERY->CTD_XDTCOP

		dData1 := QUERY->CTD_XDTEVC
		dData2 := Date()

		cWeekJOB := (dData1 - dData2) /7

		IF Empty(dData1)
			TRB1->XDTWK		:= 0
		Else
			TRB1->XDTWK		:= cWeekJOB
		Endif


		nTotalC1 		+= QUERY->CTD_XVDSI
		nTotalC2 		+= QUERY->CTD_XCUTOT - nXVCOM
		nTotalC3 		+= QUERY->CTD_XVDSIR
		nTotalC4 		+= QUERY->CTD_XCUTOR - nXVCOMR
		nTotalC8 		+= TRB1->XFATCONT
		nTotalC9 		+= TRB1->XCOGSCONT

		MsUnlock()

	QUERY->(dbskip())

enddo
	RecLock("TRB1",.T.)
	QUERY->(dbskip())
		TRB1->ITEM		:= "TOTAL WARRANTY"
		TRB1->XVDSI		:= nTotalC1
		TRB1->XCUSTO	:= nTotalC2
		TRB1->XVDSIR	:= nTotalC3
		TRB1->XCUPRR	:= nTotalC4
		TRB1->XFATCONT	:= nTotalC8
		TRB1->XCOGSCONT	:= nTotalC9
	MsUnlock()


QUERY->(dbclosearea())
CQ5->(dbclosearea())

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaTela ºAutor  ³Marcos Zanetti GZ   º Data ³  01/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta a tela de visualizacao do Fluxo Sintetico            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function MontaTela()
private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oDlgSint
Private _aColumns := {}


// Monta aHeader do TRB2

aadd(aHeader, {"  Job No."													,"ITEM"		,""					,25,0,""		,"","C","TRB1","Job No."})
aadd(aHeader, {"Job Name"													,"CLIENTE"	,""					,40,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Project Manager"											,"NOMPM"	,""					,40,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Description"												,"XEQUIP"	,""					,40,0,""		,"","C","TRB1",""})

aadd(aHeader, {"Total Revenue-Original Contract"							,"XVDSI"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Total COGs-Original Contract"								,"XCUSTO"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Comission-Original Contract"								,"XVCOM"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})

aadd(aHeader, {"Total Revised-Original Contract"							,"XVDSIR"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Total COGs-Revised Contract"								,"XCUPRR"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Booked Gross Margin %"										,"XBOOKMG"  ,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})

//aadd(aHeader, {"Over (Under) budget changes to COGS"						,"VOVER"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
//aadd(aHeader, {"Total Anticipated as of the date this Report"				,"VANTCOGS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
//aadd(aHeader, {"Amount includ.inAnticip.COGS that is for warranty accrual"	,"VAMOUNT"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Revenue captured so far"									,"XFATCONT"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Actual COGS captured so far"								,"XCOGSCONT","@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Commiission captured so far"								,"XCOMCONT","@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Margin of contribution  %"									,"XMGContr","@E 999,999,999.99",15,2,""		,"","N","TRB1",""})

aadd(aHeader, {"Accounting stock"											,"XESTCONT","@E 999,999,999.99",15,2,""		,"","N","TRB1",""})

//aadd(aHeader, {"COGS Captured by revaluation provision"					,"VCOGSREV" ,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
//aadd(aHeader, {"COGS Captured by retention provision"						,"VCOGSRET" ,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
//aadd(aHeader, {"Job Costs captured in other areas of the income statement","VJOBCOST" ,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})

//aadd(aHeader, {"Current Anticipated Margin %"								,"VCURRMG"  ,"@E 999.99"		,6,2,""			,"","N","TRB1",""})
//aadd(aHeader, {"Previous Month Anticipated Margin %"						,"VPRANMG"  ,"@E 999.99"		,6,2,""			,"","N","TRB1",""})
//aadd(aHeader, {"% of Project Revenue Recognized"							,"VPROREC"  ,"@E 999.99"		,6,2,""			,"","N","TRB1",""})
//aadd(aHeader, {"% complete USA GAAP"										,"VUSAGAAP" ,"@E 999.99"		,6,2,""			,"","N","TRB1",""})
aadd(aHeader, {"Booked Date"												,"DTEXIS"   ,""					,8,0,""		,"","D","TRB1",""})
aadd(aHeader, {"Contractual Submittal Date"									,"XDAPCT"   ,""					,8,0,""			,"","D","TRB1",""})

aadd(aHeader, {"Actual Submittal Date"										,"XDTAPR"   ,""					,8,0,""			,"","D","TRB1",""})
aadd(aHeader, {"Contractual Approval Date"									,"XDTAVC"   ,""					,8,0,""			,"","D","TRB1",""})
aadd(aHeader, {"Actual Approval Date"										,"XDTAVR"   ,""					,8,0,""			,"","D","TRB1",""})
aadd(aHeader, {"Planned Fabrication Release Date"							,"XDTFAP"   ,""					,8,0,""			,"","D","TRB1",""})
aadd(aHeader, {"Actual Fabrication Release Date"							,"XDTFAR"   ,""					,8,0,""			,"","D","TRB1",""})
aadd(aHeader, {"Contractual Shipping Date"									,"XDTEVC"   ,""					,8,0,""			,"","D","TRB1",""})
aadd(aHeader, {"Actual Shipping Date"										,"XDTEVR"   ,""					,8,0,""			,"","D","TRB1",""})
aadd(aHeader, {"Contractual Job Completion Date"							,"XDTCOC"   ,""					,8,0,""			,"","D","TRB1",""})
aadd(aHeader, {"Expected Job Completion Date"								,"XDTCOP"   ,""					,8,0,""			,"","D","TRB1",""})
aadd(aHeader, {"Weeks left to Contractual Shipping Date"					,"XDTWK"   ,"@E 99,999.99"	,8,2,""			,"","N","TRB1",""})


DEFINE MSDIALOG _oDlgSint ;
TITLE "Projec Status"  ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB1")

_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
// COR DA LINHA
//_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| fTrocaCor(2)}
_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linh

//aadd(aButton , { "SIMULACAO", { || GerSimul(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), TRB12->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh() }, "Simulação" } )
//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE2" , { || zExportExc2()}, "Gerar Plan. Excel " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return


Static Function SFMudaCor(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  if ALLTRIM(TRB1->ITEM) ==  ""; _cCor := CLR_LIGHTGRAY; endif
    endif
   
   if nIOpcao == 2 // Cor da Fonte
   	  if ALLTRIM(TRB1->ITEM) ==  ""; _cCor := CLR_LIGHTGRAY ; endif
   	  if ALLTRIM(TRB1->ITEM) ==  "TOTAL CAPITAL PROJECT"; _cCor := CLR_YELLOW ; endif
   	  if ALLTRIM(TRB1->ITEM) ==  "TOTAL SERVICE"; _cCor := CLR_YELLOW ; endif
   	  if ALLTRIM(TRB1->ITEM) ==  "TOTAL PARTS"; _cCor := CLR_YELLOW ; endif
   	  if ALLTRIM(TRB1->ITEM) ==  "TOTAL COMMISSIONS"; _cCor := CLR_YELLOW ; endif
   	  if ALLTRIM(TRB1->ITEM) ==  "TOTAL WARRANTY"; _cCor := CLR_YELLOW ; endif

    endif
Return _cCor

static function AbreArq()
local aStru 	:= {}
local _cCpoAtu
local _ni

// monta arquivo analitico
aAdd(aStru,{"ITEM"		,"C",25,0,""	,""}) // Data de movimentacao
aAdd(aStru,{"CLIENTE"	,"C",40,0,""		,""}) // Historico
aAdd(aStru,{"NOMPM"		,"C",40,0,""		,""}) // Historico
aAdd(aStru,{"XEQUIP"	,"C",40,0,""		,""}) // Historico


aAdd(aStru,{"XVDSI"		,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"XCUSTO"	,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"XVCOM"		,"N",15,2,""		,""}) // Valor do movimento

aAdd(aStru,{"XVDSIR"	,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"XCUPRR"	,"N",15,2,""		,""}) // Valor do movimento


aAdd(aStru,{"VOVER"		,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"VANTCOGS"	,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"VAMOUNT"	,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"XFATCONT"	,"N",15,2,""		,""}) // Valor do movimento

aAdd(aStru,{"XCOGSCONT"	,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"XCOMCONT"	,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"XMGContr"	,"N",15,2,""		,""}) // Valor do movimento


aAdd(aStru,{"XESTCONT"	,"N",15,2,""		,""}) // Valor do movimento

aAdd(aStru,{"VCOGSREV"	,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"VCOGSRET"	,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"VJOBCOST"	,"N",15,2,""		,""}) // Valor do movimento

aAdd(aStru,{"XBOOKMG"	,"N",15,2,""		,""}) // Valor do movimento
aAdd(aStru,{"VCURRMG"	,"N",6,2,""		,""}) // Valor do movimento
aAdd(aStru,{"VPRANMG"	,"N",6,2,""		,""}) // Valor do movimento
aAdd(aStru,{"VPROREC"	,"N",6,2,""		,""}) // Valor do movimento
aAdd(aStru,{"VUSAGAAP"	,"N",6,2,""		,""}) // Valor do movimento
aAdd(aStru,{"DTEXIS"	,"D",8,0,""		,""}) // Valor do movimento
aAdd(aStru,{"XDAPCT"	,"D",8,0,""		,""}) // Valor do movimento

aAdd(aStru,{"XDTAPR"	,"D",8,0,""		,""}) // Valor do movimento
aAdd(aStru,{"XDTAVC"	,"D",8,0,""		,""}) // Valor do movimento
aAdd(aStru,{"XDTAVR"	,"D",8,0,""		,""}) // Valor do movimento
aAdd(aStru,{"XDTFAP"	,"D",8,0,""		,""}) // Valor do movimento
aAdd(aStru,{"XDTFAR"	,"D",8,0,""		,""}) // Valor do movimento
aAdd(aStru,{"XDTEVC"	,"D",8,0,""		,""}) // Valor do movimento
aAdd(aStru,{"XDTEVR"	,"D",8,0,""		,""}) // Valor do movimento
aAdd(aStru,{"XDTCOC"	,"D",8,0,""		,""}) // Valor do movimento
aAdd(aStru,{"XDTCOP"	,"D",8,0,""		,""}) // Valor do movimento
aAdd(aStru,{"XDTWK"		,"N",8,2,""		,""}) // Valor do movimento


dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)

return(.T.)

Static Function zExportExc2()
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExportExc.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do título - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Project Status") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Project Status","Project Status")
        
        aAdd(aColunas, "Job No.")								// 1 ITEM
        aAdd(aColunas, "Job Name")								// 2 CLIENTE
        aAdd(aColunas, "Project Manager")						// 3 NOMPM
        aAdd(aColunas, "Total Revenue-Original Contract")		// 4 XVDSI
        aAdd(aColunas, "Total COGs-Original Contract")			// 5 XCUSTO
        aAdd(aColunas, "Total Revised-Original Contract")		// 6 XVDSIR
        aAdd(aColunas, "Total COGs-Revised Contract")			// 7 XCUPRR
        aAdd(aColunas, "Revenue captured so far")				// 8 XFATCONT
        aAdd(aColunas, "Actual COGS captured so far")			// 9 XCOGSCONT
        aAdd(aColunas, "Booked Gross Margin %")					// 10 XBOOKMG
        aAdd(aColunas, "Booked Date")							// 11 DTEXIS
        aAdd(aColunas, "Contractual Submittal Date")			// 12 XDAPCT
        aAdd(aColunas, "Actual Submittal Date")					// 13 XDTAPR
        aAdd(aColunas, "Contractual Approval Date")				// 14 XDTAVC
        aAdd(aColunas, "Actual Approval Date")					// 15 XDTAVR
        aAdd(aColunas, "Planned Fabrication Release Date")		// 16 XDTFAP
        aAdd(aColunas, "Actual Fabrication Release Date")		// 17 XDTFAR
        aAdd(aColunas, "Contractual Shipping Date")				// 18 XDTEVC
        aAdd(aColunas, "Actual Shipping Date")					// 19 XDTEVR
        aAdd(aColunas, "Contractual Job Completion Date")		// 20 XDTCOC
        aAdd(aColunas, "Expected Job Completion Date")			// 21 XDTCOP
        aAdd(aColunas, "Weeks left to Contractual Shipping Date") // 22 XDTWK
      
        oFWMsExcel:AddColumn("Project Status","Project Status", "Job No.",1,2)							// 1 ITEM.
        oFWMsExcel:AddColumn("Project Status","Project Status", "Job Name",1,2)							// 2 CLIENTE
        oFWMsExcel:AddColumn("Project Status","Project Status", "Project Manager",1,2)					// 3 NOMPM
        oFWMsExcel:AddColumn("Project Status","Project Status", "Total Revenue-Original Contract",1,2)	// 4 XVDSI
        oFWMsExcel:AddColumn("Project Status","Project Status", "Total COGs-Original Contract",1,2)		// 5 XCUSTO
        oFWMsExcel:AddColumn("Project Status","Project Status", "Total Revised-Original Contract",1,2)	// 6 XVDSIR
        oFWMsExcel:AddColumn("Project Status","Project Status", "Total COGs-Revised Contract",1,2)		// 7 XCUPRR
        oFWMsExcel:AddColumn("Project Status","Project Status", "Revenue captured so far",1,2)			// 8 XFATCONT
        oFWMsExcel:AddColumn("Project Status","Project Status", "Actual COGS captured so far",1,2)		// 9 XCOGSCONT
        oFWMsExcel:AddColumn("Project Status","Project Status", "Booked Gross Margin %",2,2)			// 10 XBOOKMG
        oFWMsExcel:AddColumn("Project Status","Project Status", "Booked Date",2,4)						// 11 DTEXIS
        oFWMsExcel:AddColumn("Project Status","Project Status", "Contractual Submittal Date",2,4)		// 12 XDAPCT
        oFWMsExcel:AddColumn("Project Status","Project Status", "Actual Submittal Date",2,4)			// 13 XDTAPR
        oFWMsExcel:AddColumn("Project Status","Project Status", "Contractual Approval Date",2,4)		// 14 XDTAVC
        oFWMsExcel:AddColumn("Project Status","Project Status", "Actual Approval Date",2,4)				// 15 XDTAVR
        oFWMsExcel:AddColumn("Project Status","Project Status", "Planned Fabrication Release Date",2,4) // 16 XDTFAP
        oFWMsExcel:AddColumn("Project Status","Project Status", "Actual Fabrication Release Date",2,4)  // 17 XDTFAR
        oFWMsExcel:AddColumn("Project Status","Project Status", "Contractual Shipping Date",2,4)		// 18 XDTEVC
        oFWMsExcel:AddColumn("Project Status","Project Status", "Actual Shipping Date",2,4)				// 19 XDTEVR
        oFWMsExcel:AddColumn("Project Status","Project Status", "Contractual Job Completion Date",2,4)	// 20 XDTCOC
        oFWMsExcel:AddColumn("Project Status","Project Status", "Expected Job Completion Date",2,4)		// 21 XDTCOP
        oFWMsExcel:AddColumn("Project Status","Project Status", "Weeks left to Contractual Shipping Date",2,2) // 22 XDTWK

                 
        While  !(TRB1->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB1->ITEM
        	aLinhaAux[2] := TRB1->CLIENTE
        	aLinhaAux[3] := TRB1->NOMPM
        	aLinhaAux[4] := TRB1->XVDSI
        	aLinhaAux[5] := TRB1->XCUSTO
        	aLinhaAux[6] := TRB1->XVDSIR
        	aLinhaAux[7] := TRB1->XCUPRR
        	aLinhaAux[8] := TRB1->XFATCONT
        	aLinhaAux[9] := TRB1->XCOGSCONT
        	aLinhaAux[10] := TRB1->XBOOKMG
        	aLinhaAux[11] := TRB1->DTEXIS
        	aLinhaAux[12] := TRB1->XDAPCT
        	aLinhaAux[13] := TRB1->XDTAPR
        	aLinhaAux[14] := TRB1->XDTAVC
        	aLinhaAux[15] := TRB1->XDTAVR
        	aLinhaAux[16] := TRB1->XDTFAP
        	aLinhaAux[17] := TRB1->XDTFAR
        	aLinhaAux[18] := TRB1->XDTEVC
        	aLinhaAux[19] := TRB1->XDTEVR
        	aLinhaAux[20] := TRB1->XDTCOC
        	aLinhaAux[21] := TRB1->XDTCOP
        	aLinhaAux[22] := TRB1->XDTWK
        	
        	       	
        	//if substr(alltrim(aLinhaAux[1]),1,5) == "TOTAL"
        	//	oFWMsExcel:SetCelBgColor("#4169E1")
        	//	oFWMsExcel:AddRow("Project Status","Project Status", aLinhaAux,{1})
        	//else
        		
        		oFWMsExcel:AddRow("Project Status","Project Status", aLinhaAux)
        	//endif
            TRB1->(DbSkip())

        EndDo

        TRB1->(dbgotop())
   
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraExcel  												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Arquivo em Excel e abre                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function GeraExcel(_cAlias,_cFiltro,aHeader)

MsAguarde({||GeraCSV(_cAlias,_cFiltro,aHeader)},"Aguarde","Gerando Planilha",.F.)

/*
_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)

if !empty(_cFiltro)
	copy to &(_cArq) VIA "DBFCDXADS" for &(_cFiltro)
else
	copy to &(_cArq) VIA "DBFCDXADS"
endif

MsAguarde({||AbreDoc( _cArq ) },"Aguarde","Abrindo Arquivo",.F.)
*/

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraCSV    												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Arquivo em Excel e abre                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function geraCSV(_cAlias,_cFiltro,aHeader) //aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)

local cDirDocs  := MsDocPath()
Local cArquivo 	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX

local _cArq		:= ""

_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)

if !empty(_cFiltro)
	(_cAlias)->(dbsetfilter({|| &(_cFiltro)} , _cFiltro))
endif

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

If nHandle > 0

	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha

	(_cAlias)->(dbgotop())
	while (_cAlias)->(!eof())

		for _ni := 1 to len(aHeader)

			_uValor := ""

			if aHeader[_ni,8] == "D" // Trata campos data
				_uValor := dtoc(&(_cAlias + "->" + aHeader[_ni,2]))
			elseif aHeader[_ni,8] == "N" // Trata campos numericos
				_uValor := transform(&(_cAlias + "->" + aHeader[_ni,2]),aHeader[_ni,3])
			elseif aHeader[_ni,8] == "C" // Trata campos caracter
				_uValor := &(_cAlias + "->" + aHeader[_ni,2])
			endif

			if _ni <> len(aHeader)
				fWrite(nHandle, _uValor + ";" )
			endif

		next _ni

		fWrite(nHandle, cCrLf )

		(_cAlias)->(dbskip())

	enddo

	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado')
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

Else
	MsgAlert("Falha na criação do arquivo")
Endif

(_cAlias)->(dbclearfil())

Return

///////////////////////////////////////////////
static function VldParamPS()

	if empty(MV_PAR02)  // Alguma data vazia
		msgstop("Id do Coordenador devem ser informadas.")
		return(.F.)
	endif

	if empty(MV_PAR03)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Assistencia Tecnica")
		return(.F.)
	endif

	if empty(MV_PAR04)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Comissao")
		return(.F.)
	endif

	if empty(MV_PAR05)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Engenharia")
		return(.F.)
	endif

	if empty(MV_PAR06)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Engenharia")
		return(.F.)
	endif

	if empty(MV_PAR07)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Peca")
		return(.F.)
	endif

	if empty(MV_PAR08)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Sistema")
		return(.F.)
	endif
	
	if empty(MV_PAR09)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Sistema")
		return(.F.)
	endif

	if MV_PAR03 == 2 .AND. MV_PAR04 == 2 .AND. MV_PAR05 == 2 .AND. MV_PAR06 == 2 .AND. MV_PAR07 == 2 .AND. MV_PAR08 == 2 .AND. MV_PAR09 == 2
		msgstop("Deve ser informado pelo menos um tipo de Contrato como Sim")
		return(.F.)
	endif

	if empty(MV_PAR11)
		msgstop("Deve ser informado pelo menos um parametro Ano até.")
		return(.F.)
	endif

return(.T.)

///////////////////////////////////////////////

static function VALIDPERG()

	putSx1(cPerg, "01", "Coordenador de?"  				, "", "", "mv_ch1", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par01")
	putSx1(cPerg, "02", "Coordenador até?" 				, "", "", "mv_ch2", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par02")
	PutSX1(cPerg, "03", "Assistencia Tecnica (AT)"		, "", "", "mv_ch3", "N", 01, 0, 0, "C", "", "", "", "", "mv_par03","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "04", "Comissao (CM)"					, "", "", "mv_ch4", "N", 01, 0, 0, "C", "", "", "", "", "mv_par04","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "05", "Engenharia (EN)"				, "", "", "mv_ch5", "N", 01, 0, 0, "C", "", "", "", "", "mv_par05","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "06", "Equipamento (EQ)"				, "", "", "mv_ch6", "N", 01, 0, 0, "C", "", "", "", "", "mv_par06","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "07", "Peca (PR)"						, "", "", "mv_ch7", "N", 01, 0, 0, "C", "", "", "", "", "mv_par07","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "08", "Sistema (ST)"					, "", "", "mv_ch8", "N", 01, 0, 0, "C", "", "", "", "", "mv_par08","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "09", "Garantia (GR)"					, "", "", "mv_ch9", "N", 01, 0, 0, "C", "", "", "", "", "mv_par09","Sim","","","","Nao","","","","","","","","","","","")
	putSx1(cPerg, "10", "Ano de?"  						, "", "", "mv_ch10", "C", 02, 0, 0, "G", "", "", "", "", "mv_par10")
	putSx1(cPerg, "11", "Ano até?" 						, "", "", "mv_ch11", "C", 02, 0, 0, "G", "", "", "", "", "mv_par11")
return
