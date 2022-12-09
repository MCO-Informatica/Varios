#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include 'totvs.ch'
#include 'parmtype.ch'
#Include 'FWMVCDef.ch'

//ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ// 
//                        Low Intensity colors 
//ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768                // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896                // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ// 
//                      High Intensity Colors 
//ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PFIN01    ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  19/09/05   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Gera arquivo de fluxo de caixa                             ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico 		                                  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
user function zCurrJobS()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0

local cCadastro	:= 	"GeraÁ„o de planilha de Project Status"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"ZCURJOBS01"
private _cArq	:= 	"ZCURJOBS01.XLS"
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

 //⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Leds utilizados para as legendas das rotinas≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Private oGreen   	:= LoadBitmap( GetResources(), "BR_VERDE")
Private oRed    	:= LoadBitmap( GetResources(), "BR_VERMELHO")
Private oBlack	:= LoadBitmap( GetResources(), "BR_PRETO")
Private oYellow	:= LoadBitmap( GetResources(), "BR_AMARELO")
Private oBrown	:= LoadBitmap( GetResources(), "BR_MARROM")
Private oBlue		:= LoadBitmap( GetResources(), "BR_AZUL")
Private oOrange	:= LoadBitmap( GetResources(), "BR_LARANJA")
Private oViolet	:= LoadBitmap( GetResources(), "BR_VIOLETA")
Private oPink		:= LoadBitmap( GetResources(), "BR_PINK")
Private oGray		:= LoadBitmap( GetResources(), "BR_CINZA")


ValidPerg()

AADD(aSays,"Este programa gera planilha com os dados para o Current Job Shedule baseado em  ")
AADD(aSays,"Contratos ativos O arquivo gerado pode ser aberto de forma autom·tica")
AADD(aSays,"pelo Excel.")
AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
if nOpcA == 1

	if !VldParamCJ() .or. !AbreArq()
		return
	endif

	MSAguarde({||DOCSAI02()},"Processando Documentos de Saida (Geral)")
	
	MSAguarde({||SE1IN02()},"Processando Invoice (Geral)")

	MSAguarde({||SD1D02()},"Processando NF devoluÁ„o (Geral)")
	
	MSAguarde({||PROSTEQST()},"Processando Contratos")

	MontaTela()


	TRB1->(dbclosearea())


endif

return


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PFIN01REAL∫												   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa o Project Status EQ / ST	                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function PROSTEQST()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local QUERYSD2 		:= ""
Local QUERYSE1 		:= ""
local _cQuerySD2 := ""
local _cQuerySE1 := ""
Local _cFilSD2 := xFilial("SD2")

 Local nTotalCQ5RD 	:= 0
 Local nTotalCQ5RDr := 0
 Local nCredito 	:= 0
 Local nDebito		:= 0
 Local cItem 		:= ""
 Local cConta 		:= ""
 Local cConta2 		:= ""

 Local nXVDSIR		:= 0
 Local nXCUPRR		:= 0
 Local nXBOOKMG		:= 0
 Local nXCUTOR		:= 0
 

 Local nTotalC1		:= 0
 Local nTotalC2		:= 0
 Local nTotalC3		:= 0
 Local nTotalC4		:= 0
 Local nTotalC8		:= 0
 Local nTotalC9		:= 0
 Local nTotalC10		:= 0
 Local nTotalC11		:= 0
 Local nTotalC12		:= 0
 Local nTotalC13		:= 0

 Local cMoeda		:= "01"
 Local cContaR		:= "4"
 Local cContaD		:= "5"
 Local cContaE		:= "113"

 Local nXPCOM		:= 0
 Local nXVCOM		:= 0
 Local nXVDSISF		:= 0

 Local nXVCOMR		:= 0
 Local nXVDSISFR	:= 0
 
 Local tXFATDOL  	:= 0
 Local tXFATREA		:= 0
 Local tXTOTHR		:= 0
 Local tXHRSHP		:= 0
 Local tXVDC1R		:= 0
 Local tXFATRE2		:= 0

 local dData1
 local dData2
 local cWeekJOB
 
 Local aInd:={}
 Local cCondicao
 Local bFiltraBrw
 local nTotalSD2 := 0
 local nTotalSD1 := 0
 local nTotalSE1 := 0
 local cItemConta := ""
 local cForSD2	:= ""
 
 local xTotItemCI := 0
 local xTotItemSI := 0

 
 local cFor := "ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'EQ/ST'"
/************* CONTRATOS *************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_DTEXIS+CTD_ITEM+CTD_XIDPM",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())
	
	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		ProcessMessage()

	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERY->(dbskip())
		Loop
	endif
/*
	if ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'AT/GR/CM/EN/PR'
		QUERY->(dbskip())
		Loop
	endif
*/

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'AT'
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'CM'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'EN'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'EQ'
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'PR'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'ST'
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'GR'
		QUERY->(dbskip())
		Loop
	endif


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

	if MV_PAR12 == 1 .AND. QUERY->CTD_DTEXSF < DATE()
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QUERY->CTD_DTEXSF > DATE()
		QUERY->(dbskip())
		Loop
	endif

	 	

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		//TRB1->OK		:= oGreen
		TRB1->ITEM		:= QUERY->CTD_ITEM		// CTD_ITEM 	- JOB  
		TRB1->CLIENTE	:= QUERY->CTD_XNREDU	// CTD_XNREDU 	- NOME DO CLIENTE 
		TRB1->XPAIS		:= Posicione("SYA",1,xFilial("SYA") + Posicione("SA1",1,xFilial("SA1") + QUERY->CTD_XCLIEN,"A1_PAIS"),"YA_DESCR") //Posicione("SA1",1,xFilial("SA1") + QUERY->CTD_XCLIEN,"A1_PAIS")
		TRB1->DTEXIS	:= QUERY->CTD_DTEXIS					
		TRB1->DTEXIS2	:= substr(dtoc(QUERY->CTD_DTEXIS),4,7)
		TRB1->XQTY		:= QUERY->CTD_XQTY		// CTD_XQTY		- QUANTIDADE
		TRB1->XMODEL	:= QUERY->CTD_XMODEL	// CTD_XMODEL	- MODELO
		TRB1->XEQUIP	:= QUERY->CTD_XEQUIP	// CTD_XEQUIP		- EQUIPAMENTO
		TRB1->XSIZE		:= QUERY->CTD_XSIZE		// CTD_XSIZE		- TAMANHO
		TRB1->XGP		:= QUERY->CTD_XGP		// CTD_XGP		- GP
		TRB1->XNOMPM	:= QUERY->CTD_XNOMPM	// CTD_XNOMPM		- NOME PM
		TRB1->XPO		:= QUERY->CTD_XPO		// CTD_XPO		- PO
		TRB1->XACCPT	:= QUERY->CTD_XACCPT	// CTD_XACCPT		- ACCPT
		TRB1->XLLPO		:= QUERY->CTD_XLLPO		// CTD_XLLPO		- LLPO
		TRB1->XJBRVW	:= QUERY->CTD_XJBRVW	// CTD_XJBRVW		- JBRVW
		TRB1->XSENT		:= QUERY->CTD_XSENT		// CTD_XSENT		- SENT
		TRB1->XCERT		:= QUERY->CTD_XCERT		// CTD_XCERT		- CERT
		TRB1->XSQUAD	:= QUERY->CTD_XSQUAD	// CTD_XSQUAD		- SQUAD
		TRB1->XDAPCT	:= QUERY->CTD_XDAPCT	// CTD_XDAPCPT	- SUBMITTAL CONTRACT SUBMIT DATE
		TRB1->XDTAPR	:= QUERY->CTD_XDTAPR	// CTD_XDTAPR		- SUBMITTAL SUBMIT DATE
		TRB1->XDTAVC	:= QUERY->CTD_XDTAVC	// CTD_XDTAVC		- SUBMITTAL TARGET APPROVAL DATE
		TRB1->XDTAVR	:= QUERY->CTD_XDTAVR	// CTD_XDTAVR		- SUBMITTAL APPROVAL DATE
		TRB1->XFDANC	:= QUERY->CTD_XFDANC	// CTD_XFDANC		- FABRICATION DWG ANCHR
		TRB1->XFBDTR	:= QUERY->CTD_XFBDTR	// CTD_XFBDTR		- FABRICATION DWG DTRVW
		TRB1->XFBTRD	:= QUERY->CTD_XFBTRD	// CTD_XFBTRD		- FABRICATION DWG FBTRD
		TRB1->XFBRD		:= QUERY->CTD_XFBRD		// CTD_XFBRD		- FABRICATION DWG RELEASE DATE
		TRB1->XFBORD	:= QUERY->CTD_XFBORD	// CTD_XFBORD		- FABRICATION DWG ORDER
		TRB1->XFBREC	:= QUERY->CTD_XFBREC	// CTD_XFBREC		- FABRICATION DWG RECVD
		TRB1->XFBINS	:= QUERY->CTD_XFBINS	// CTD_XFBINS		- FABRICATION DWG INSPR
		TRB1->XDRDR		:= QUERY->CTD_XDRDR		// CTD_XDRDR		- DRIVE DRREQ
		TRB1->XDRNSU	:= QUERY->CTD_XDRNSU	// CTD_XDRNSU		- DRIVE NSUB
		TRB1->XDRPSD	:= QUERY->CTD_XDRPSD	// CTD_XDRPSD		- DRIVE PROJECTD DRIVE SHIP DATE
		TRB1->XELER		:= QUERY->CTD_XELER		// CTD_XELER		- ELECTRICAL EREQ
		TRB1->XELNS		:= QUERY->CTD_XELNS		// CTD_XELNS		- ELECTRICAL NSUB
		TRB1->XELSD		:= QUERY->CTD_XELSD		// CTD_XELSD		- ELECTRICAL TARGET SHIP DATE
		TRB1->XSHSH		:= QUERY->CTD_XSHSH		// CTD_XSHSH		- SHIPMENT TAGET SHIP DATE
		TRB1->XDTEVC	:= QUERY->CTD_XDTEVC	// CTD_XDTEVC		- SHIPMENT CONTRACT SHIP DATE
		TRB1->XDTEVR	:= QUERY->CTD_XDTEVR	// CTD_XDTEVR		- SHIPMENT SHIP DATE
		TRB1->XSHBCD	:= QUERY->CTD_XSHBCD	// CTD_XSHBCD		- SHIPMENT BILL CYC DAY
		TRB1->XSHOM		:= QUERY->CTD_XSHOM		// CTD_XSHOM		- SHIPMENT OM
		TRB1->XSHIP		:= QUERY->CTD_XSHIP		// CTD_XSHIP		- SHIPMENT SHIP
		TRB1->XINVC		:= QUERY->CTD_XINVC		// CTD_XINVC		- SHIPMENT INVC
		TRB1->XPPAF		:= QUERY->CTD_XPPAF		// CTD_XPPAFT		- SHIPMENT PPAFT
		TRB1->XRCRVW	:= QUERY->CTD_XRCRVW	// CTD_XRCRVW		- SHIPMENT RCRVW
		
		
		
		/********************************************/
		
		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "RE"
				xTotItemCI		+= TRB3->XVDCI
				xTotItemSI		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		/********************************************/
		
		TRB1->XFATREA	:= QUERY->CTD_XVDCIR - xTotItemCI 			// CTD_XFATREA	- FATURAMENTO EM REAIS
		
		if QUERY->CTD_XCAMB > 0
			TRB1->XFATDOL	:= (QUERY->CTD_XVDCIR - xTotItemCI) /  QUERY->CTD_XCAMB					// CTD_XFATDOL	- FATURAMENTO DOLAR
		else
			TRB1->XFATDOL	:= 0
		endif
		
		TRB1->XTOTHR	:= QUERY->CTD_XTOTHR	// CTD_XTOTHR		- TOTAL HRS LEFT
		TRB1->XHRSHP	:= QUERY->CTD_XHRSHP	// CTD_XHRSHP		- HRS TO SHIP
		
		TRB1->XVDC1R	:= QUERY->CTD_XVDCIR
		TRB1->XFATRE2	:= xTotItemCI
		
		TRB1->XNOTES	:= QUERY->CTD_XNOTES	// CTD_XNOTES		- NOTES
		
		
		tXFATDOL  	+= TRB1->XFATDOL
		tXFATREA	+= TRB1->XFATREA
		tXTOTHR		+= TRB1->XTOTHR
		tXHRSHP		+= TRB1->XHRSHP
		tXVDC1R		+= TRB1->XVDC1R	
		tXFATRE2	+= TRB1->XFATRE2

		

	QUERY->(dbskip())
	
	xTotItemCI := 0
	xTotItemSI := 0
	
	
enddo

	RecLock("TRB1",.T.)
		TRB1->ITEM		:= "TOTAL"
		TRB1->XFATDOL 	:= tXFATDOL  	
		TRB1->XFATREA	:= tXFATREA	 
		TRB1->XTOTHR	:= tXTOTHR	 
		TRB1->XHRSHP	:= tXHRSHP	 
		TRB1->XVDC1R	:= tXVDC1R	 
		TRB1->XFATRE2	:= tXFATRE2	 
	MsUnlock()

QUERY->(dbclosearea())
TRB3->(dbclosearea())



return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa documento de saida   				              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/


static function DOCSAI02()

local _cQuery := ""
Local _cFilSD2 := xFilial("SD2")


// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO
 	_cQuery := "SELECT D2_ITEMCC AS 'TMP_CONTRATO', D2_DOC AS 'TMP_DOC', D2_SERIE AS 'TMP_SERIE', D2_CF AS 'TMP_CFOP',  CAST(D2_EMISSAO AS DATE) AS 'TMP_EMISSAO', D2_CLIENTE AS 'TMP_CLIENTE', A1_NOME AS 'TMP_NOME', "  
	_cQuery += "		SUM(D2_VALBRUT) AS 'TMP_TOTAL', "
    _cQuery += "	    (SUM(D2_VALBRUT)-SUM(D2_VALIPI))-SUM(D2_VALICM)-SUM(D2_VALISS)-SUM(D2_VALIMP6)-SUM(D2_VALIMP5) AS 'TMP_TOTALSI', " 
    _cQuery += "	    SUM(D2_VALIPI) AS 'TMP_IPI', "
	_cQuery += "	    SUM(D2_VALICM) as 'TMP_ICMS', "
    _cQuery += "	    SUM(D2_VALISS) AS 'TMP_ISS', " 
    _cQuery += "	    SUM(D2_VALIMP6) AS 'TMP_PIS', " 
    _cQuery += "	    SUM(D2_VALIMP5) AS 'TMP_COFINS', " 
    _cQuery += "	  	CTD_XVDCI AS 'TMP_VDCI',  "
	_cQuery += "	   	CTD_XVDSI AS 'TMP_VDSI',   "
	_cQuery += "	  	CTD_XVDCIR AS 'TMP_VDCIR',  "
	_cQuery += "	   	CTD_XVDSIR AS 'TMP_VDSIR'   "
    _cQuery += "	    FROM SD2010 "
	_cQuery += "		LEFT JOIN SA1010 ON D2_CLIENTE = SA1010.A1_COD " 
	_cQuery += " 	LEFT JOIN CTD010 ON D2_ITEMCC = CTD_ITEM "  
	_cQuery += "	WHERE D2_DOC NOT IN (SELECT F3_NFISCAL FROM SF3010 WHERE F3_DTCANC <> '') AND D2_DOC NOT IN (SELECT SUBSTRING(F3_OBSERV,16,6) AS NFDEV FROM SF3010 WHERE F3_TIPO = 'D') AND "
	_cQuery += "	D2_CF IN (SELECT D2_CF FROM SD2010 WHERE "
	_cQuery += "											 D2_CF BETWEEN '6101' AND '6106' OR " 
	_cQuery += "											 D2_CF BETWEEN '5101' AND '5125' OR "
	_cQuery += "											 D2_CF BETWEEN '5551' AND '5551' OR " 
	_cQuery += "											 D2_CF BETWEEN '5922' AND '5922' OR " 
	_cQuery += "											 D2_CF BETWEEN '5933' AND '5933' OR "
	_cQuery += "											 D2_CF BETWEEN '6109' AND '6120' OR "
	_cQuery += "											 D2_CF BETWEEN '6122' AND '6125' OR " 
	_cQuery += "											 D2_CF BETWEEN '7101' AND '7933' OR " 
	_cQuery += "											 D2_CF BETWEEN '6933' AND '6933' OR " 
	_cQuery += "											 D2_CF BETWEEN '7949' AND '7949' AND D2_ITEMCC LIKE 'AT%'  OR " 
	_cQuery += "											 D2_CF BETWEEN '7949' AND '7949' AND D2_ITEMCC LIKE 'CM%'  OR "
	_cQuery += "											 D2_CF BETWEEN '7949' AND '7949' AND D2_ITEMCC LIKE 'EN%'  OR "  
	_cQuery += "											 D2_CF BETWEEN '6551' AND '6551') AND "
  	_cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' GROUP BY D2_DOC, D2_SERIE, D2_CF, D2_ITEMCC, D2_EMISSAO, D2_CLIENTE, A1_NOME,CTD_XVDCI,CTD_XVDSI,CTD_XVDCIR,CTD_XVDSIR ORDER BY D2_ITEMCC, D2_DOC "
	

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())
//******************

while QUERY->(!eof())

		
	//if ALLTRIM(QUERY->ZG_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB3",.T.)
		
		//IncProc("Processando registro: "+alltrim(QUERY->TMP_DOC))
		MsProcTxt("Processando registro: "+alltrim(QUERY->TMP_DOC))
		ProcessMessage()

		TRB3->ITEMCONTA	:= QUERY->TMP_CONTRATO
		TRB3->DESCR		:= "REALIZADO"
		TRB3->NF		:= QUERY->TMP_DOC
		TRB3->DATAMOV	:= QUERY->TMP_EMISSAO
		TRB3->XVDCI		:= QUERY->TMP_TOTAL
		TRB3->XVDSI		:= QUERY->TMP_TOTALSI
		TRB3->XTIPO		:= "RE"
		TRB3->ORIGEM 	:= "DS"
		TRB3->CAMPO 	:= QUERY->TMP_CONTRATO
		TRB3->XDELMON2	:= substr(dtoc(QUERY->TMP_EMISSAO),4,7)
		
		MsUnlock()
	//endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa INVOICE								              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

static function SE1IN02()
local _cQuery 		:= ""
Local _cFilSE1 		:= xFilial("SE1")
Local dData 		:= DDatabase
Local QUERY 		:= ""
local cFor := "ALLTRIM(QUERY->E1_TIPO) == 'INV'"

SE1->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SE1",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"E1_XXIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

SE1->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())
	
		//if ALLTRIM(QUERY->ZG_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB3",.T.)
		
		//IncProc("Processando registro: "+alltrim(QUERY->TMP_DOC))
		MsProcTxt("Processando registro: "+alltrim(QUERY->E1_XXIC))
		ProcessMessage()

		TRB3->ITEMCONTA	:= QUERY->E1_XXIC
		TRB3->DESCR		:= "REALIZADO"
		TRB3->NF		:= QUERY->E1_NUM
		TRB3->DATAMOV	:= QUERY->E1_VENCREA
		TRB3->XVDCI		:= QUERY->E1_VLCRUZ
		TRB3->XVDSI		:= QUERY->E1_VLCRUZ
		TRB3->XTIPO		:= "RE"
		TRB3->ORIGEM 	:= "IN"
		TRB3->CAMPO 	:= QUERY->E1_XXIC
		TRB3->XDELMON2	:= substr(dtoc(QUERY->E1_VENCREA),4,7)
		
		MsUnlock()
	//endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa devolucoes							              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

static function SD1D02()
local _cQuery 		:= ""
Local _cFilSD1 		:= xFilial("SD1")
Local dData 		:= DDatabase
Local QUERY 		:= ""
local cFor := "D1_CF = '1201' .OR. D1_CF = '2201' .OR. D1_CF = '5201'"


SE1->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SD1",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"D1_ITEMCTA",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

SD1->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())

		
	//if ALLTRIM(QUERY->ZG_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB3",.T.)
		
		//IncProc("Processando registro: "+alltrim(QUERY->TMP_DOC))
		MsProcTxt("Processando registro: "+alltrim(QUERY->D1_ITEMCTA))
		ProcessMessage()

		TRB3->ITEMCONTA	:= QUERY->D1_ITEMCTA
		TRB3->DESCR		:= "DEVOLUCAO"
		TRB3->NF		:= QUERY->D1_DOC
		TRB3->DATAMOV	:= QUERY->D1_EMISSAO
		TRB3->XVDCI		:= -1 * QUERY->D1_TOTAL
		TRB3->XVDSI		:= -1 * QUERY->D1_CUSTO
		TRB3->XTIPO		:= "RE"
		TRB3->ORIGEM 	:= "DV"
		TRB3->CAMPO 	:= QUERY->D1_ITEMCTA
		
		TRB3->XDELMON2	:= substr(dtoc(QUERY->D1_EMISSAO),4,7)
		MsUnlock()
	//endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MontaTela ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Monta a tela de visualizacao do Fluxo Sintetico            ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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

cCadastro := "Current Job Shedule"

// Monta aHeader do TRB2

aadd(aHeader, {"  Job No."													,"ITEM"		,""					,13,0,""		,"","C","TRB1","Job No."})
aadd(aHeader, {"Job Name"													,"CLIENTE"	,""					,40,0,""		,"","C","TRB1","The plant name (not the county or city)"})
aadd(aHeader, {"St/Pr Cntry"												,"XPAIS"	,""					,25,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Booked Date"												,"DTEXIS2"   ,""				,07,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Qty"														,"XQTY"		,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Model #"													,"XMODEL"	,""					,30,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Equipment"													,"XEQUIP"	,""					,30,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Size"														,"XSIZE"	,""					,20,0,""		,"","C","TRB1",""})
aadd(aHeader, {"GP"															,"XGP"		,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"PM"															,"XNOMPM"	,""					,30,0,""		,"","C","TRB1",""})
aadd(aHeader, {"PO"															,"XPO"		,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Accpt"														,"XACCPT"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"LLPO"														,"XLLPO"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"JbRvw"														,"XJBRVW"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Sent"														,"XSENT"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Cert"														,"XPO"		,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Squad"														,"XSQUAD"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(S) Contract Submit Date"									,"XDAPCT"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(S) Submit Date"											,"XDTAPR"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(S) Target Approval Date"									,"XDTAVC"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(S) Approval Date"											,"XDTAVR"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(F) Anchr"													,"XFDANC"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(F) DtRvw"													,"XFBDTR"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(F) Target Release Date"									,"XFBTRD"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(F) Release Date"											,"XFBTRD"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(F) Order"													,"XFBORD"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(F) Recvd"													,"XFBREC"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(F) Inspr"													,"XFBINS"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(D) DrReq"													,"XDRNSU"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(D) NSub"													,"XDRNSU"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(D) Projectd Drive Ship Date"								,"XDRPSD"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(E) EReq"													,"XELER"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(E) NSub"													,"XELNS"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(E) Target Ship Date"										,"XELSD"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(SM) Target Ship Date"										,"XSHSH"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(SM) Contract Ship Date"									,"XDTEVC"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(SM) Ship Date"												,"XDTEVR"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(SM) Bill Cyc Day"											,"XSHBCD"	,""					,08,0,""		,"","D","TRB1",""})
aadd(aHeader, {"(SM) OM"													,"XSHOM"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(SM) Ship"													,"XSHIP"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(SM) Invc"													,"XINVC"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(SM) PPAFt"													,"XPPAF"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"(SM) RcRvw"													,"XRCRVW"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Dollars Unbilied"											,"XFATDOL"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Reais Unbilied"												,"XFATREA"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Total Hrs Left"												,"XTOTHR"	,""					,09,0,""		,"","N","TRB1",""})
aadd(aHeader, {"Hrs to Ship"												,"XHRSHP"	,""					,09,0,""		,"","N","TRB1",""})
aadd(aHeader, {"Total Revised-Original Contract"							,"XVDC1R"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Total Billing"												,"XFATRE2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})

aadd(aHeader, {"Notes"														,"XNOTES"	,""					,200,0,""		,"","C","TRB1",""})


DEFINE MSDIALOG _oDlgSint ;
TITLE "Current Job Shedule"  ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"


//ADD LEGEND DATA  "XPOC=='1'" COLOR "GREEN" TITLE "Chave teste 1" OF oBrowse

_oGetDbSint := MsGetDb():New(aPosObj[1,1]+20,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB1")

_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
// COR DA LINHA
//_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| fTrocaCor(2)}
_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha

@ aPosObj[1,1] , 0005 Say "LEGENDA : (S) - Submittal / (F) - Fabrication Drawings for Supply Phase / (D) - Drive / (E) - Electrical / (SM) - Shipment "  COLORS 0, 16777215 PIXEL

_oGetDbSint:oBrowse:BlDblClick := {|| EditCTDItem() }

//aadd(aButton , { "SIMULACAO", { || GerSimul(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), TRB12->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh() }, "SimulaÁ„o" } )
//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE2" , { || zExportCuJ()}, "Gerar Plan. Excel " } )
aadd(aButton , { "BMPTABLE3" , { || zAbreHelp()}, "Help Campos " } )


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
aAdd(aStru,{"ITEM"		,"C",13,0,""		,""}) // CTD_ITEM 		- JOB  
aAdd(aStru,{"CLIENTE"	,"C",40,0,""		,""}) // CTD_XNREDU 	- NOME DO CLIENTE 
aAdd(aStru,{"XPAIS"		,"C",25,0,""		,""}) // A1_PAIS 		- PAIS 
aAdd(aStru,{"DTEXIS"	,"D",08,0,""		,""}) // A1_PAIS 		- PAIS 
aAdd(aStru,{"DTEXIS2"	,"C",07,0,""		,""}) // A1_PAIS 		- PAIS 
aAdd(aStru,{"XQTY"		,"N",15,2,""		,""}) // CTD_XQTY		- QUANTIDADE
aAdd(aStru,{"XMODEL"	,"C",30,0,""		,""}) // CTD_XMODEL		- MODELO
aAdd(aStru,{"XEQUIP"	,"C",30,0,""		,""}) // CTD_XEQUIP		- EQUIPAMENTO
aAdd(aStru,{"XSIZE"		,"C",20,0,""		,""}) // CTD_XSIZE		- TAMANHO
aAdd(aStru,{"XGP"		,"C",03,0,""		,""}) // CTD_XGP		- GP
aAdd(aStru,{"XNOMPM"	,"C",30,0,""		,""}) // CTD_XNOMPM		- NOME PM
aAdd(aStru,{"XPO"		,"C",03,0,""		,""}) // CTD_XPO		- PO
aAdd(aStru,{"XACCPT"	,"C",03,0,""		,""}) // CTD_XACCPT		- ACCPT
aAdd(aStru,{"XLLPO"		,"C",03,0,""		,""}) // CTD_XLLPO		- LLPO
aAdd(aStru,{"XJBRVW"	,"C",03,0,""		,""}) // CTD_XJBRVW		- JBRVW
aAdd(aStru,{"XSENT"		,"C",03,0,""		,""}) // CTD_XSENT		- SENT
aAdd(aStru,{"XCERT"		,"C",03,0,""		,""}) // CTD_XCERT		- CERT
aAdd(aStru,{"XSQUAD"	,"C",03,0,""		,""}) // CTD_XSQUAD		- SQUAD
aAdd(aStru,{"XDAPCT"	,"D",08,0,""		,""}) // CTD_XDAPCPT	- SUBMITTAL CONTRACT SUBMIT DATE
aAdd(aStru,{"XDTAPR"	,"D",08,0,""		,""}) // CTD_XDTAPR		- SUBMITTAL SUBMIT DATE
aAdd(aStru,{"XDTAVC"	,"D",08,0,""		,""}) // CTD_XDTAVC		- SUBMITTAL TARGET APPROVAL DATE
aAdd(aStru,{"XDTAVR"	,"D",08,0,""		,""}) // CTD_XDTAVR		- SUBMITTAL APPROVAL DATE
aAdd(aStru,{"XFDANC"	,"C",03,0,""		,""}) // CTD_XFDANC		- FABRICATION DWG ANCHR
aAdd(aStru,{"XFBDTR"	,"C",03,0,""		,""}) // CTD_XFBDTR		- FABRICATION DWG DTRVW
aAdd(aStru,{"XFBTRD"	,"D",08,0,""		,""}) // CTD_XFBTRD		- FABRICATION DWG FBTRD
aAdd(aStru,{"XFBRD"		,"D",08,0,""		,""}) // CTD_XFBRD		- FABRICATION DWG RELEASE DATE
aAdd(aStru,{"XFBORD"	,"C",03,0,""		,""}) // CTD_XFBORD		- FABRICATION DWG ORDER
aAdd(aStru,{"XFBREC"	,"C",03,0,""		,""}) // CTD_XFBREC		- FABRICATION DWG RECVD
aAdd(aStru,{"XFBINS"	,"C",03,0,""		,""}) // CTD_XFBINS		- FABRICATION DWG INSPR
aAdd(aStru,{"XDRDR"		,"C",03,0,""		,""}) // CTD_XDRDR		- DRIVE DRREQ
aAdd(aStru,{"XDRNSU"	,"C",03,0,""		,""}) // CTD_XDRNSU		- DRIVE NSUB
aAdd(aStru,{"XDRPSD"	,"D",08,0,""		,""}) // CTD_XDRPSD		- DRIVE PROJECTD DRIVE SHIP DATE
aAdd(aStru,{"XELER"		,"C",03,0,""		,""}) // CTD_XELER		- ELECTRICAL EREQ
aAdd(aStru,{"XELNS"		,"C",03,0,""		,""}) // CTD_XELNS		- ELECTRICAL NSUB
aAdd(aStru,{"XELSD"		,"D",08,0,""		,""}) // CTD_XELSD		- ELECTRICAL TARGET SHIP DATE
aAdd(aStru,{"XSHSH"		,"D",08,0,""		,""}) // CTD_XSHSH		- SHIPMENT TAGET SHIP DATE
aAdd(aStru,{"XDTEVC"	,"D",08,0,""		,""}) // CTD_XDTEVC		- SHIPMENT CONTRACT SHIP DATE
aAdd(aStru,{"XDTEVR"	,"D",08,0,""		,""}) // CTD_XDTEVR		- SHIPMENT SHIP DATE
aAdd(aStru,{"XSHBCD"	,"D",08,0,""		,""}) // CTD_XSHBCD		- SHIPMENT BILL CYC DAY
aAdd(aStru,{"XSHOM"		,"C",03,0,""		,""}) // CTD_XSHOM		- SHIPMENT OM
aAdd(aStru,{"XSHIP"		,"C",03,0,""		,""}) // CTD_XSHIP		- SHIPMENT SHIP
aAdd(aStru,{"XINVC"		,"C",03,0,""		,""}) // CTD_XINVC		- SHIPMENT INVC
aAdd(aStru,{"XPPAF"		,"C",03,0,""		,""}) // CTD_XPPAFT		- SHIPMENT PPAFT
aAdd(aStru,{"XRCRVW"	,"C",03,0,""		,""}) // CTD_XRCRVW		- SHIPMENT RCRVW
aAdd(aStru,{"XFATDOL"	,"N",15,2,""		,""}) // CTD_XFATDOL	- FATURAMENTO DOLAR
aAdd(aStru,{"XFATREA"	,"N",15,2,""		,""}) // CTD_XFATREA	- FATURAMENTO EM REAIS
aAdd(aStru,{"XTOTHR"	,"N",09,0,""		,""}) // CTD_XTOTHR		- TOTAL HRS LEFT
aAdd(aStru,{"XHRSHP"	,"N",09,0,""		,""}) // CTD_XHRSHP		- HRS TO SHIP

aAdd(aStru,{"XVDC1R"		,"N",15,2,""		,""})
aAdd(aStru,{"XFATRE2"		,"N",15,2,""		,""})

aAdd(aStru,{"XNOTES"	,"C",200,0,""		,""}) // CTD_XNOTES		- NOTES


dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)


// monta arquivo analitico TRB3
aStru := {}
aAdd(aStru,{"ITEMCONTA"	,"C",13,0})
aAdd(aStru,{"DESCR"		,"C",25,0})
aAdd(aStru,{"NF"		,"C",10,0})
aAdd(aStru,{"SERIE"		,"C",10,0})
aAdd(aStru,{"DATAMOV"	,"D",08,0})
aAdd(aStru,{"XVDCI"		,"N",15,2})		// VALOR VENDIDO ORIGINAL C/ TRIBUTOS
aAdd(aStru,{"XVDSI"		,"N",15,2})		// VALOR VENDIDO ORIGINAL S/ TRIBUTOS
aAdd(aStru,{"XTIPO"		,"C",10,0})
aAdd(aStru,{"ORIGEM"	,"C",03,0})
aAdd(aStru,{"CAMPO"		,"C",13,0})
aAdd(aStru,{"XDELMON2"	,"C",7,0}) // Valor total dos movimentos

dbcreate(cArqTrb3,aStru)
dbUseArea(.T.,,cArqTrb3,"TRB3",.T.,.F.)


return(.T.)

Static Function EditCTDItem()
    Local aArea       := GetArea()
    Local aAreaCTD    := CTD->(GetArea())
    Local nOpcao      := 0
    Local cItemIC	  := alltrim(TRB1->ITEM)
   
   
    Private cCadastro 
 
   	cCadastro := "AlteraÁ„o Item Conta"
    
	DbSelectArea("CTD")
	CTD->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	CTD->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If CTD->(DbSeek(xFilial('CTD')+cItemIC))
	    	
	        nOpcao := fAltRegCTD()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "AtenÁ„o")
	        EndIf
	       
	EndIf

    RestArea(aAreaCTD)
    RestArea(aArea)
Return

/*********************************************/
Static Function zAbreHelp()
    Local aArea:= GetArea()
    
    Local cNomeArqP := "QR-00-043-Schedule-meeting-Key.html"
    Local cDirP 	:= "\\srvwt\docsprotheus\"
     
    //Tentando abrir o objeto
    nRet := ShellExecute("open", cNomeArqP, "", cDirP, 1)
     
    //Se houver algum erro
    If nRet <= 32
        MsgStop("N„o foi possÌvel abrir o arquivo " +cDirP+cNomeArqP+ "!", "AtenÁ„o")
    EndIf 
     
    RestArea(aArea)
Return




// AlteraÁ„o Ordem de Compra


static Function fAltRegCTD()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= CTD->CTD_ITEM
Local cGet2 	:= Posicione("SA1",1,xFilial("SA1") + CTD->CTD_XCLIEN, "A1_NREDUZ")
Local cGet3		:= Posicione("SYA",1,xFilial("SYA") + Posicione("SA1",1,xFilial("SA1") + CTD->CTD_XCLIEN,"A1_PAIS"),"YA_DESCR") //Posicione("SA1",1,xFilial("SA1") + QUERY->CTD_XCLIEN,"A1_PAIS")
Local cGet4		:= CTD->CTD_DTEXIS
Local cGet5
Local cGet6
Local cGet7
Local cGet8
Local cGet9
Local cGet10
Local cGet11
Local cGet12
Local cGet13
Local cGet14
Local cGet15
Local cGet16
Local cGet17
Local cGet18
Local cGet19
Local cGet20
Local cGet21
Local cGet22
Local cGet23
Local cGet24
Local cGet25
Local cGet26
Local cGet27
Local cGet28
Local cGet29
Local cGet30
Local cGet31
Local cGet32
Local cGet33
Local cGet34
Local cGet35
Local cGet36
Local cGet37
Local cGet38
Local cGet39
Local cGet40
Local cGet41
Local cGet42
Local cGet43
Local cGet44
Local cGet45
Local cGet46
Local cGet47
Local cGet48

Local dDtIni 	:= CTD->CTD_DTEXIS 	//
Local nXQTY	 	:= CTD->CTD_XQTY	//
Local cXMODEL	:= CTD->CTD_XMODEL	//
Local cXSIZE	:= CTD->CTD_XSIZE
Local cXGP		:= CTD->CTD_XGP
Local cXNOMPM	:= CTD->CTD_XNOMPM
Local cXEQUIP	:= CTD->CTD_XEQUIP
Local cXPO		:= CTD->CTD_XPO
Local cXACCPT	:= CTD->CTD_XACCPT
Local cXLLPO	:= CTD->CTD_XLLPO
Local cXJBRVW	:= CTD->CTD_XJBRVW
Local cXSENT	:= CTD->CTD_XSENT
Local cXCERT	:= CTD->CTD_XCERT
Local cXSQUAD	:= CTD->CTD_XSQUAD
Local dXDAPCT	:= CTD->CTD_XDAPCT
Local dXDTAPR	:= CTD->CTD_XDTAPR
Local dXDTAVC	:= CTD->CTD_XDTAVC
Local dXDTAVR	:= CTD->CTD_XDTAVR
Local cXFDANC	:= CTD->CTD_XFDANC
Local cXFBDTR	:= CTD->CTD_XFBDTR
Local dXFBTRD	:= CTD->CTD_XFBTRD
Local dXFBRD	:= CTD->CTD_XFBRD
Local cXFBORD	:= CTD->CTD_XFBORD
Local cXFBREC	:= CTD->CTD_XFBREC
Local cXFBINS	:= CTD->CTD_XFBINS
Local cXDRDR	:= CTD->CTD_XDRDR
Local cXDRNSU	:= CTD->CTD_XDRNSU
Local dXDRPSD	:= CTD->CTD_XDRPSD
Local cXELER	:= CTD->CTD_XELER
Local cXELNS	:= CTD->CTD_XELNS
Local dXELSD	:= CTD->CTD_XELSD
Local dXSHSH	:= CTD->CTD_XSHSH
Local dXDTEVC	:= CTD->CTD_XDTEVC
Local dXDTEVR	:= CTD->CTD_XDTEVR
Local dXSHBCD	:= CTD->CTD_XSHBCD
Local cXSHOM	:= CTD->CTD_XSHOM
Local cXSHIP	:= CTD->CTD_XSHIP
Local cXINVC	:= CTD->CTD_XINVC
Local cXPPAF	:= CTD->CTD_XPPAF
Local cXRCRVW	:= CTD->CTD_XRCRVW
Local nXFATDOL	:= TRB1->XFATDOL
Local nXFATREA	:= TRB1->XFATREA
Local nXTOTHR	:= CTD->CTD_XTOTHR
Local nXHRSHP	:= CTD->CTD_XHRSHP
Local cXNOTES	:= CTD->CTD_XNOTES
	

Local nValor := 0
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay14
Local oSay15
Local oSay16
Local oSay17
Local oSay18
Local oSay19
Local oSay20
Local oSay21
Local oSay22
Local oSay23
Local oSay24
Local oSay25
Local oSay26
Local oSay27
Local oSay28
Local oSay29
Local oSay30
Local oSay31
Local oSay32
Local oSay33
Local oSay34
Local oSay35
Local oSay36
Local oSay37
Local oSay38
Local oSay39
Local oSay40
Local oSay41
Local oSay42
Local oSay43
Local oSay44
Local oSay45
Local oSay46
Local oSay47
Local oSay48

Local _nOpc := 0
Static _oDlg


  DEFINE MSDIALOG _oDlg TITLE "Altera Item Conta" FROM 000, 000  TO 0630, 1000 COLORS 0, 16777215 PIXEL
  
   //@ 006, 008 MSPANEL oPanel1 PROMPT "" SIZE 184, 088 OF _oDlg COLORS 0, 16777215 RAISED
   // @ 000, 002 MSPANEL oPanel2 SIZE 179, 086 OF oPanel1 COLORS 0, 16777215 LOWERED

   oGroup1:= TGroup():New(0005,0005,0080,0495,'',_oDlg,,,.T.)
   oGroup2:= TGroup():New(0085,0005,0120,0495,'Submittal',_oDlg,,,.T.)
   oGroup3:= TGroup():New(0125,0005,0160,0495,'Fabrication Drawings for Supply Phase',_oDlg,,,.T.)
   oGroup4:= TGroup():New(0165,0005,0200,0250,'Drive',_oDlg,,,.T.)
   oGroup5:= TGroup():New(0165,0255,0200,0495,'Electrical',_oDlg,,,.T.)
   oGroup6:= TGroup():New(0200,0005,0290,0495,'Shipment',_oDlg,,,.T.)

    
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "Job" 	SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 PIXEL
    // CLIENTE
    @ 007, 063 SAY oSay2 PROMPT "Name" 		SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2 When .F. 	SIZE 170, 010 	COLORS 0, 16777215 PIXEL
    
    // PAIS
    @ 007, 245 SAY oSay3 PROMPT "St/Pr Cntry" 	SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 016, 245 MSGET oGet3 VAR cGet3 When .F. 	SIZE 080, 010 COLORS 0, 16777215 PIXEL
    
    // Book date
    @ 007, 340 SAY oSay4 PROMPT "Book Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 016, 340 MSGET oGet4 VAR dDtIni When .F.  SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    // QTY
    @ 007, 400 SAY oSay5 PROMPT "QTY" SIZE 050, 007  COLORS 0, 16777215 PIXEL
   	@ 016, 400 MSGET oGet5 VAR nXQTY PICTURE PesqPict("CTD","CTD_XQTY") When .T. SIZE 080, 010 COLORS 0, 16777215 PIXEL
    
     // Model 
    @ 031, 010 SAY oSay6 PROMPT "Model #" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 040, 010 MSGET oGet6 VAR cXMODEL When .T.  SIZE 200, 010  COLORS 0, 16777215 PIXEL
    
    // Size 
    @ 031, 215 SAY oSay7 PROMPT "Size" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 040, 215 MSGET oGet7 VAR cXSIZE When .T.  SIZE 200, 010  COLORS 0, 16777215 PIXEL
   
    // GP 
    @ 031, 420 SAY oSay8 PROMPT "GP" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 040, 420 MSGET oGet8 VAR cXGP When .T.  SIZE 20, 010  COLORS 0, 16777215 PIXEL
    
    // PM 
    @ 054, 010 SAY oSay9 PROMPT "PM" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 063, 010 MSGET oGet9 VAR cXNOMPM When .F.  SIZE 200, 010  COLORS 0, 16777215 PIXEL
    
    
    // Equipment 
    @ 054, 225 SAY oSay9 PROMPT "Equipment" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 063, 225 MSGET oGet9 VAR cXEQUIP When .F.  SIZE 200, 010  COLORS 0, 16777215 PIXEL

    /********************************************/
     // PO 
    @ 094, 010 SAY oSay10 PROMPT "PO" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 010 MSGET oGet10 VAR cXPO When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
     // Accpt 
    @ 094, 045 SAY oSay11 PROMPT "Accpt" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 045 MSGET oGet11 VAR cXACCPT When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
     // LLPO
    @ 094, 080 SAY oSay12 PROMPT "LLPO" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 080 MSGET oGet12 VAR cXLLPO When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // LLPO
    @ 094, 115 SAY oSay13 PROMPT "LLPO" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 115 MSGET oGet13 VAR cXLLPO When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // JbRvw
    @ 094, 150 SAY oSay14 PROMPT "JbRvw" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 150 MSGET oGet14 VAR cXJBRVW When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
     // Sent
    @ 094, 185 SAY oSay15 PROMPT "Sent" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 185 MSGET oGet15 VAR cXSENT When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
     // Sent
    @ 094, 220 SAY oSay16 PROMPT "Cert" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 220 MSGET oGet16 VAR cXCERT When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // Sent
    @ 094, 255 SAY oSay16 PROMPT "Squad" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 255 MSGET oGet16 VAR cXSQUAD When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
     // Contract submit date
    @ 094, 295 SAY oSay17 PROMPT "Contract Submit Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 295 MSGET oGet17 VAR dXDAPCT When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    // Submit date
    @ 094, 345 SAY oSay18 PROMPT "Submit Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 345 MSGET oGet18 VAR dXDTAPR When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    // Target Approval Date
    @ 094, 395 SAY oSay19 PROMPT "Target Approval Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 395 MSGET oGet19 VAR dXDTAVC When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    // Approval Date
    @ 094, 445 SAY oSay20 PROMPT "Target Approval Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 103, 445 MSGET oGet20 VAR dXDTAVR When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    /***********************************/
    // Anchr
    @ 134, 010 SAY oSay21 PROMPT "Anchr" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 143, 010 MSGET oGet21 VAR cXFDANC When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // DtRvw
    @ 134, 045 SAY oSay22 PROMPT "DtRvw" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 143, 045 MSGET oGet22 VAR cXFBDTR When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // Target Release Date
    @ 134, 080 SAY oSay23 PROMPT "Target Release Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 143, 080 MSGET oGet23 VAR dXFBTRD When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    // Release Date
    @ 134, 135 SAY oSay24 PROMPT "Release Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 143, 135 MSGET oGet24 VAR dXFBRD When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    // Order
    @ 134, 190 SAY oSay25 PROMPT "Order" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 143, 190 MSGET oGet25 VAR cXFBORD When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // Recvd
    @ 134, 225 SAY oSay26 PROMPT "Recvd" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 143, 225 MSGET oGet26 VAR cXFBREC When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // Inspr
    @ 134, 260 SAY oSay27 PROMPT "Inspr" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 143, 260 MSGET oGet27 VAR cXFBINS When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    /***************DRIVE********************/
    // DrReq
    @ 174, 010 SAY oSay28 PROMPT "DrReq" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 183, 010 MSGET oGet28 VAR cXDRDR When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // NSub
    @ 174, 045 SAY oSay29 PROMPT "NSub" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 183, 045 MSGET oGet29 VAR cXDRNSU When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // Projectd Drive Ship Date
    @ 174, 080 SAY oSay30 PROMPT "Projectd Drive Ship Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 183, 080 MSGET oGet30 VAR dXDRPSD When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    /***************ELECTRICAL********************/
    // EReq
    @ 174, 260 SAY oSay31 PROMPT "EReq" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 183, 260 MSGET oGet31 VAR cXELER When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // NSub
    @ 174, 295 SAY oSay32 PROMPT "NSub" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 183, 295 MSGET oGet32 VAR cXELNS When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // Target Ship Date
    @ 174, 330 SAY oSay33 PROMPT "Target Ship Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 183, 330 MSGET oGet33 VAR dXELSD When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    /************* SHIPMENT **********************/
    // Target Ship Date
    @ 214, 010 SAY oSay34 PROMPT "Target Ship Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 223, 010 MSGET oGet34 VAR dXSHSH When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
     // Contract Ship Date
    @ 214, 060 SAY oSay35 PROMPT "Contract Ship Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 223, 060 MSGET oGet35 VAR dXDTEVC When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    // Ship Date
    @ 214, 110 SAY oSay36 PROMPT "Ship Date" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 223, 110 MSGET oGet36 VAR dXDTEVR When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    // Bill Cyc Day
    @ 214, 160 SAY oSay37 PROMPT "Bill Cyc Day" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 223, 160 MSGET oGet37 VAR dXSHBCD When .T.  SIZE 45, 010  COLORS 0, 16777215 PIXEL
    
    // OM
    @ 214, 210 SAY oSay38 PROMPT "OM" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 223, 210 MSGET oGet38 VAR cXSHOM When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // SHIP
    @ 214, 245 SAY oSay39 PROMPT "Ship" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 223, 245 MSGET oGet39 VAR cXSHIP When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // Invc
    @ 214, 280 SAY oSay40 PROMPT "Invc" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 223, 280 MSGET oGet40 VAR cXINVC When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // PPAFt
    @ 214, 315 SAY oSay41 PROMPT "PPAFt" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 223, 315 MSGET oGet41 VAR cXPPAF When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
    // RcRvw
    @ 214, 350 SAY oSay42 PROMPT "RcRvw" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 223, 350 MSGET oGet42 VAR cXRCRVW When .T.  SIZE 30, 010  COLORS 0, 16777215 PIXEL
    
   
    // Dollars Unbilled
    @ 238, 010 SAY oSay43 PROMPT "Dollars Unbilled" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 247, 010 MSGET oGet43 VAR Transform(nXFATDOL,"@E 99,999,999.99") When .F.  SIZE 80, 010  COLORS 0, 16777215 PIXEL
    
    // Dollars Unbilled
    @ 238, 095 SAY oSay44 PROMPT "Reais Unbilled" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 247, 095 MSGET oGet44 VAR Transform(nXFATREA,"@E 99,999,999.99") When .F.  SIZE 80, 010  COLORS 0, 16777215 PIXEL
    
    // Total Hrs Left
    @ 238, 180 SAY oSay45 PROMPT "Total Hrs Left" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 247, 180 MSGET oGet45 VAR nXTOTHR PICTURE PesqPict("CTD","CTD_XTOTHR") When .T.  SIZE 80, 010  COLORS 0, 16777215 PIXEL
    
     // Hrs to Ship
    @ 238, 265 SAY oSay46 PROMPT "Hrs to Ship" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 247, 265 MSGET oGet46 VAR nXHRSHP PICTURE PesqPict("CTD","CTD_XTOTHR") When .T.  SIZE 80, 010  COLORS 0, 16777215 PIXEL
    
    // Notes
    @ 262, 010 SAY oSay47 PROMPT "Notes" SIZE 050, 007  COLORS 0, 16777215 PIXEL
    @ 271, 010 MSGET oGet47 VAR cXNOTES PICTURE PesqPict("CTD","CTD_XNOTES") When .T.  SIZE 440, 010  COLORS 0, 16777215 PIXEL
    
    @ 300, 160 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 070, 010 OF oPanel2 PIXEL
    @ 300, 240 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 070, 010 OF oPanel2 PIXEL
    @ 300, 320 BUTTON oButton1 PROMPT "Help" Action( zAbreHelp() ) SIZE 070, 010 OF oPanel2 PIXEL
 

  ACTIVATE MSDIALOG _oDlg CENTERED


  If _nOpc = 1
  	Reclock("CTD",.F.)
  	//SE1->E1_VENCTO 	:= dVencto
  		CTD->CTD_XQTY 	:= nXQTY
  		CTD->CTD_XMODEL	:= cXMODEL//
  		CTD->CTD_XSIZE	:= cXSIZE
  		CTD->CTD_XGP	:= cXGP
  		CTD->CTD_XEQUIP	:= cXEQUIP
  		CTD->CTD_XPO	:= cXPO
  		CTD->CTD_XACCPT	:= cXACCPT
  		CTD->CTD_XLLPO	:= cXLLPO
  		CTD->CTD_XJBRVW := cXJBRVW
  		CTD->CTD_XSENT 	:= cXSENT
  		CTD->CTD_XCERT 	:= cXCERT
  		CTD->CTD_XSQUAD := cXSQUAD
  		CTD->CTD_XDAPCT := dXDAPCT
  		CTD->CTD_XDTAPR := dXDTAPR
  		CTD->CTD_XDTAVC := dXDTAVC
  		CTD->CTD_XDTAVR := dXDTAVR
  		CTD->CTD_XFDANC := cXFDANC
  		CTD->CTD_XFBDTR := cXFBDTR
  		CTD->CTD_XFBTRD := dXFBTRD
  		CTD->CTD_XFBRD 	:= dXFBRD
  		CTD->CTD_XFBORD := cXFBORD
  		CTD->CTD_XFBREC := cXFBREC
  		CTD->CTD_XFBINS := cXFBINS
  		CTD->CTD_XDRDR 	:= cXDRDR
  		CTD->CTD_XDRNSU := cXDRNSU
  		CTD->CTD_XDRPSD := dXDRPSD
  		CTD->CTD_XELER 	:= cXELER
  		CTD->CTD_XELNS 	:= cXELNS
  		CTD->CTD_XELSD 	:= dXELSD
  		CTD->CTD_XSHSH 	:= dXSHSH
  		CTD->CTD_XDTEVC := dXDTEVC
  		CTD->CTD_XDTEVR := dXDTEVR
  		CTD->CTD_XSHBCD := dXSHBCD
  		CTD->CTD_XSHOM 	:= cXSHOM
  		CTD->CTD_XSHIP 	:= cXSHIP
  		CTD->CTD_XINVC 	:= cXINVC
  		CTD->CTD_XPPAF 	:= cXPPAF
  		CTD->CTD_XRCRVW 	:= cXRCRVW
  		CTD->CTD_XTOTHR 	:= nXTOTHR
  		CTD->CTD_XHRSHP 	:= nXHRSHP
  		CTD->CTD_XNOTES 	:= cXNOTES

  	MsUnlock()
  Endif
 
  Reclock("TRB1",.F.)

  		TRB1->XQTY 		:= nXQTY
  		TRB1->XMODEL	:= cXMODEL //
  		TRB1->XSIZE		:= cXSIZE
  		TRB1->XGP		:= cXGP
  		TRB1->XEQUIP	:= cXEQUIP
  		TRB1->XPO		:= cXPO
  		TRB1->XACCPT	:= cXACCPT
  		TRB1->XLLPO		:= cXLLPO
  		TRB1->XJBRVW 	:= cXJBRVW
  		TRB1->XSENT 	:= cXSENT
  		TRB1->XCERT 	:= cXCERT
  		TRB1->XSQUAD 	:= cXSQUAD
  		TRB1->XDAPCT 	:= dXDAPCT
  		TRB1->XDTAPR 	:= dXDTAPR
  		TRB1->XDTAVC 	:= dXDTAVC
  		TRB1->XDTAVR 	:= dXDTAVR
  		TRB1->XFDANC 	:= cXFDANC
  		TRB1->XFBDTR 	:= cXFBDTR
  		TRB1->XFBTRD 	:= dXFBTRD
  		TRB1->XFBRD 	:= dXFBRD
  		TRB1->XFBORD 	:= cXFBORD
  		TRB1->XFBREC 	:= cXFBREC
  		TRB1->XFBINS 	:= cXFBINS
  		TRB1->XDRDR 	:= cXDRDR
  		TRB1->XDRNSU 	:= cXDRNSU
  		TRB1->XDRPSD 	:= dXDRPSD
  		TRB1->XELER 	:= cXELER
  		TRB1->XELNS 	:= cXELNS
  		TRB1->XELSD 	:= dXELSD
  		TRB1->XSHSH 	:= dXSHSH
  		TRB1->XDTEVC 	:= dXDTEVC
  		TRB1->XDTEVR 	:= dXDTEVR
  		TRB1->XSHBCD 	:= dXSHBCD
  		TRB1->XSHOM 	:= cXSHOM
  		TRB1->XSHIP 	:= cXSHIP
  		TRB1->XINVC 	:= cXINVC
  		TRB1->XPPAF 	:= cXPPAF
  		TRB1->XRCRVW 	:= cXRCRVW
  		TRB1->XTOTHR 	:= nXTOTHR
  		TRB1->XHRSHP 	:= nXHRSHP
  		TRB1->XNOTES 	:= cXNOTES
		
  MsUnlock()

   
  
Return _nOpc


Static Function zExportCuJ()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExportCuJ.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
    
    //Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth

    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do tÌtulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Current Job Schedule") //N„o utilizar n˙mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Current Job Schedule","Current Job Schedule")
        
        aAdd(aColunas, "Job No.")								// 01 ITEM
        aAdd(aColunas, "Job Name")								// 02 CLIENTE
        aAdd(aColunas, "St/Pr Cntry")							// 03 XPAIS
        aAdd(aColunas, "Booked Date")							// 04 DTEXIS2
        aAdd(aColunas, "Qty")									// 05 XQTY
        aAdd(aColunas, "Model #")								// 06 XMODEL
        aAdd(aColunas, "Equipment")								// 07 XEQUIP    
        aAdd(aColunas, "Size")									// 08 XSIZE
        aAdd(aColunas, "GP")									// 09 XGP
        aAdd(aColunas, "PM")									// 10 XNOMPM
        aAdd(aColunas, "PO")									// 11 XPO
        aAdd(aColunas, "Accpt")									// 12 XACCPT
        aAdd(aColunas, "LLPO")									// 13 XLLPO
        aAdd(aColunas, "JbRvw")									// 14 XJBRVW
        aAdd(aColunas, "Sent")									// 15 XSENT
        aAdd(aColunas, "Cert")									// 16 XCERT
        aAdd(aColunas, "Squad")									// 17 XSQUAD
        aAdd(aColunas, "(S) Contract Submit Date")				// 18 XDAPCT
        aAdd(aColunas, "(S) Submit Date")						// 19 XDTAPR
        aAdd(aColunas, "(S) Target Approval Date")				// 20 XDTAVC
        aAdd(aColunas, "(S) Approval Date")						// 21 XDTAVR
        aAdd(aColunas, "(F) Anchr")								// 22 XFDANC
        aAdd(aColunas, "(F) DtRvw")								// 23 XFBDTR
        aAdd(aColunas, "(F) Target Release Date")				// 24 XFBTRD
        aAdd(aColunas, "(F) Release Date")						// 25 XFBTRD
        aAdd(aColunas, "(F) Order")								// 26 XFBORD
        aAdd(aColunas, "(F) Recvd")								// 27 XFBREC
        aAdd(aColunas, "(F) Inspr")								// 28 XFBINS
        aAdd(aColunas, "(D) DrReq") 							// 29 XDRNSU
        aAdd(aColunas, "(D) NSub") 								// 30 XDRNSU
        aAdd(aColunas, "(D) Projectd Drive Ship Date") 			// 31 XDRPSD
        aAdd(aColunas, "(E) EReq") 								// 32 XELER
        aAdd(aColunas, "(E) NSub") 								// 33 XELNS
        aAdd(aColunas, "(E) Target Ship Date") 					// 34 XELSD
        aAdd(aColunas, "(SM) Target Ship Date") 				// 35 XSHSH
        aAdd(aColunas, "(SM) Contract Ship Date") 				// 36 XDTEVC
        aAdd(aColunas, "(SM) Ship Date") 						// 37 XDTEVR
        aAdd(aColunas, "(SM) Bill Cyc Day") 					// 38 XSHBCD
        aAdd(aColunas, "(SM) OM") 								// 39 XSHOM
        aAdd(aColunas, "(SM) Ship") 							// 40 XSHIP
        aAdd(aColunas, "(SM) Invc") 							// 41 XINVC
        aAdd(aColunas, "(SM) PPAFt") 							// 42 XPPAF
        aAdd(aColunas, "(SM) RcRvw") 							// 43 XRCRVW
        aAdd(aColunas, "Dollars Unbilied")						// 44 XFATDOL
        aAdd(aColunas, "Reais Unbilied") 						// 45 XFATREA
        aAdd(aColunas, "Total Hrs Left") 						// 46 XTOTHR
        aAdd(aColunas, "Hrs to Ship") 							// 47 XHRSHIP
        
        aAdd(aColunas, "Total Revised-Original Contract") 		// 48 XVDC1R
        aAdd(aColunas, "Total Billing") 						// 49 XFATRE2
        
        aAdd(aColunas, "Notes") 								// 50 XNOTES
        
        
      
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Job No.",1,2)								// 01 ITEM
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Job Name",1,2)								// 02 CLIENTE
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "St/Pr Cntry",1,2)							// 03 XPAIS
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Booked Date",1,2)							// 04 DTEXIS2
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Qty",1,2)									// 05 XQTY
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Model #",1,2)								// 06 XMODEL
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Equipment",1,2)							// 07 XEQUIP  
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Size",1,2)									// 08 XSIZE
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "GP",1,2)									// 09 XGP
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "PM",1,2)									// 10 XNOMPM
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "PO",1,2)									// 11 XPO
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Accpt")									// 12 XACCPT
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "LLPO")										// 13 XLLPO
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "JbRvw")									// 14 XJBRVW
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Sent")										// 15 XSENT
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Cert")										// 16 XCERT
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Squad")									// 17 XSQUAD
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(S) Contract Submit Date")					// 18 XDAPCT
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(S) Submit Date")							// 19 XDTAPR
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(S) Target Approval Date")					// 20 XDTAVC
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(S) Approval Date")						// 21 XDTAVR
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(F) Anchr")								// 22 XFDANC
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(F) DtRvw")								// 23 XFBDTR
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(F) Target Release Date")					// 24 XFBTRD
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(F) Release Date")							// 25 XFBTRD
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(F) Order")								// 26 XFBORD
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(F) Recvd")								// 27 XFBREC
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(F) Inspr")								// 28 XFBINS
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(D) DrReq") 								// 29 XDRDR
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(D) NSub") 								// 30 XDRNSU
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(D) Projectd Drive Ship Date") 			// 31 XDRPSD
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(E) EReq") 								// 32 XELER
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(E) NSub") 								// 33 XELNS
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(E) Target Ship Date") 					// 34 XELSD
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(SM) Target Ship Date") 					// 35 XSHSH
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(SM) Contract Ship Date") 					// 36 XDTEVC
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(SM) Ship Date") 							// 37 XDTEVR
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(SM) Bill Cyc Day") 						// 38 XSHBCD
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(SM) OM") 									// 39 XSHOM
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(SM) Ship") 								// 40 XSHIP
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(SM) Invc") 								// 41 XINVC
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(SM) PPAFt") 								// 42 XPPAF
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "(SM) RcRvw") 								// 43 XRCRVW
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Dollars Unbilied")							// 44 XFATDOL
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Reais Unbilied") 							// 45 XFATREA
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Total Hrs Left") 							// 46 XTOTHR
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Hrs to Ship") 								// 47 XHRSHIP
        
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Total Revised-Original Contract") 			// 48 XVDC1R
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Total Billing") 							// 49 XFATRE2
        
        oFWMsExcel:AddColumn("Current Job Schedule","Current Job Schedule", "Notes") 									// 50 XNOTES	
    

                 
        While  !(TRB1->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB1->ITEM
        	aLinhaAux[2] := TRB1->CLIENTE
        	aLinhaAux[3] := TRB1->XPAIS
        	aLinhaAux[4] := TRB1->DTEXIS2
        	aLinhaAux[5] := TRB1->XQTY
        	aLinhaAux[6] := TRB1->XMODEL
        	aLinhaAux[7] := TRB1->XEQUIP    
        	aLinhaAux[8] := TRB1->XSIZE
        	aLinhaAux[9] := TRB1->XGP
        	aLinhaAux[10] := TRB1->XNOMPM
        	aLinhaAux[11] := TRB1->XPO
        	aLinhaAux[12] := TRB1->XACCPT
        	aLinhaAux[13] := TRB1->XLLPO
        	aLinhaAux[14] := TRB1->XJBRVW
        	aLinhaAux[15] := TRB1->XSENT
        	aLinhaAux[16] := TRB1->XCERT
        	aLinhaAux[17] := TRB1->XSQUAD
        	aLinhaAux[18] := TRB1->XDAPCT
        	aLinhaAux[19] := TRB1->XDTAPR
        	aLinhaAux[20] := TRB1->XDTAVC
        	aLinhaAux[21] := TRB1->XDTAVR
        	aLinhaAux[22] := TRB1->XFDANC
        	aLinhaAux[23] := TRB1->XFBDTR
        	aLinhaAux[24] := TRB1->XFBTRD
        	aLinhaAux[25] := TRB1->XFBTRD
        	aLinhaAux[26] := TRB1->XFBORD
        	aLinhaAux[27] := TRB1->XFBREC
        	aLinhaAux[28] := TRB1->XFBINS
        	aLinhaAux[29] := TRB1->XDRDR
        	aLinhaAux[30] := TRB1->XDRNSU
        	aLinhaAux[31] := TRB1->XDRPSD
        	aLinhaAux[32] := TRB1->XELER
        	aLinhaAux[33] := TRB1->XELNS
        	aLinhaAux[34] := TRB1->XELSD
        	aLinhaAux[35] := TRB1->XSHSH
        	aLinhaAux[36] := TRB1->XDTEVC
        	aLinhaAux[37] := TRB1->XDTEVR
        	aLinhaAux[38] := TRB1->XSHBCD
        	aLinhaAux[39] := TRB1->XSHOM
        	aLinhaAux[40] := TRB1->XSHIP
        	aLinhaAux[41] := TRB1->XINVC
        	aLinhaAux[42] := TRB1->XPPAF
        	aLinhaAux[43] := TRB1->XRCRVW
        	aLinhaAux[44] := TRB1->XFATDOL
        	aLinhaAux[45] := TRB1->XFATREA
        	aLinhaAux[46] := TRB1->XTOTHR
        	aLinhaAux[47] := TRB1->XHRSHP
        	
        	aLinhaAux[48] := TRB1->XVDC1R
        	aLinhaAux[49] := TRB1->XFATRE2
        	
        	aLinhaAux[50] := TRB1->XNOTES
     
       		oFWMsExcel:AddRow("Current Job Schedule","Current Job Schedule", aLinhaAux)

            TRB1->(DbSkip())

        EndDo

        TRB1->(dbgotop())

    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex„o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

Return


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GeraExcel  												  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Gera Arquivo em Excel e abre                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GeraCSV    												  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Gera Arquivo em Excel e abre                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
	MsgAlert("Falha na criaÁ„o do arquivo")
Endif

(_cAlias)->(dbclearfil())

Return

///////////////////////////////////////////////
static function VldParamCJ()

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
	
	if empty(MV_PAR11)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Ano ate.")
		return(.F.)
	endif

	if MV_PAR03 == 2 .AND. MV_PAR04 == 2 .AND. MV_PAR05 == 2 .AND. MV_PAR06 == 2 .AND. MV_PAR07 == 2 .AND. MV_PAR08 == 2 .AND. MV_PAR09 == 2
		msgstop("Deve ser informado pelo menos um tipo de Contrato como Sim")
		return(.F.)
	endif

return(.T.)

///////////////////////////////////////////////

static function VALIDPERG()

	putSx1(cPerg, "01", "Coordenador de?"  				, "", "", "mv_ch1", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par01")
	putSx1(cPerg, "02", "Coordenador atÈ?" 				, "", "", "mv_ch2", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par02")
	PutSX1(cPerg, "03", "Assistencia Tecnica (AT)"		, "", "", "mv_ch3", "N", 01, 0, 0, "C", "", "", "", "", "mv_par03","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "04", "Comissao (CM)"					, "", "", "mv_ch4", "N", 01, 0, 0, "C", "", "", "", "", "mv_par04","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "05", "Engenharia (EN)"				, "", "", "mv_ch5", "N", 01, 0, 0, "C", "", "", "", "", "mv_par05","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "06", "Equipamento (EQ)"				, "", "", "mv_ch6", "N", 01, 0, 0, "C", "", "", "", "", "mv_par06","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "07", "Peca (PR)"						, "", "", "mv_ch7", "N", 01, 0, 0, "C", "", "", "", "", "mv_par07","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "08", "Sistema (ST)"					, "", "", "mv_ch8", "N", 01, 0, 0, "C", "", "", "", "", "mv_par08","Sim","","","","Nao","","","","","","","","","","","")

return