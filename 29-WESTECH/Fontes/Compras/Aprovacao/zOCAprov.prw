#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"
#include 'parmtype.ch'
#Include 'FWMVCDef.ch'

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½// 
//                        Low Intensity colors 
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½// 
//                      High Intensity Colors 
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 
/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Gera arquivo de Gestao de Contratos                        ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ Especifico 		                                  ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
user function zOCAprov()

local aSays			:=	{}
local aButtons 		:= 	{}
local nOpca 		:= 	0
local cCadastro		:= 	"Aprovacao Ordem de Compra"
local _cOldData		:= 	dDataBase // Grava a database

//private cPerg 	:= 	"APROC01"
private _cArq		:= 	"APROC01.XLS"
private CR 			:= chr(13)+chr(10)
private _cFilSC7	:= xFilial("SC7")
private _aCpos		:= {} // Campos de datas criados no TRB2
private _aCpos2		:= {} // Campos de datas criados no TRB2
private _nCampos	:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cItemConta := SC7->C7_ITEMCTA
private _cFilial 	:= ALLTRIM(SC7->C7_FILIAL)
private cArqTrb1 	:= CriaTrab(NIL,.F.)
private cArqTrb2 	:= CriaTrab(NIL,.F.)
private cArqTrb3 	:= CriaTrab(NIL,.F.)
private cArqTrb3Z 	:= CriaTrab(NIL,.F.)
private cArqTrb9 	:= CriaTrab(NIL,.F.)
private cArqTrb9X 	:= CriaTrab(NIL,.F.)
//Private _cDepart :=  alltrim(PSWRET()[1][12])
//Private _oDlgAnalit
Private _oGetDbAnalit
Private _oDlgAnalit
Private _oDlgAnalit2
Private _oDlgAnalit5
Private _aGrpSint:= {}
/* impressao */
Private aPerg :={}
Private cPerg := "zPEROCA"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa

/***********************/
//ValidPerg()
/*
AADD(aSays,"Este programa gera planilha com os dados para o Faturamento baseado em  ")
AADD(aSays,"Contratos ativos e inativos. O arquivo gerado pode ser aberto de forma ")
AADD(aSays,"automï¿½tica pelo Excel.")
AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )
*/

//FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
//if nOpcA == 1

	if !AbreArq()
		return
	endif

	MSAguarde({||LISTOCS()},"Processando Ordens de Compra Abertas")

	MSAguarde({||DETALOC()},"Processando Detalhamento Ordens de Compra")

	MontaTela()

	TRB1->(dbclosearea())
	TRB2->(dbclosearea())
	TRB3->(dbclosearea())
	TRB3Z->(dbclosearea())
	TRB9->(dbclosearea())
	TRB9X->(dbclosearea())

//endif
return
/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Processa INVOICE								              ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

static function DETALOC()
local _cQuery 		:= ""
Local _cFilSC7 		:= xFilial("SC7")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local nValor 		:= 1
local cQueryUPD 	:= ""

local cFor := "ALLTRIM(QUERY->C7_ENCER) <> 'E'"

SC7->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SC7",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"C7_NUM",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

SC7->(dbgotop())
//CTD->(dbsetorder(1))

cQueryUPD := "UPDATE SC7010 SET C7_XCTRVB = '4' FROM SC7010 WHERE C7_XAPRN1 <> '' AND C7_XAPRN2 <> ''"

TcSqlExec(cQueryUPD)

//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )

	_cQuery := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY2"
	
	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

//*************************
while QUERY->(!eof())
		RecLock("TRB1",.T.)
		
		//IncProc("Processando registro: "+alltrim(QUERY->TMP_DOC))
		MsProcTxt("Processando registro: "+alltrim(QUERY->C7_NUM))
		ProcessMessage()
		
		TRB1->NUM		:= QUERY->C7_NUM
		TRB1->ITEM		:= QUERY->C7_ITEM
		TRB1->CODPROD	:= QUERY->C7_PRODUTO
		if QUERY->C7_MOEDA = 1
			TRB1->PRODUTO	:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(QUERY->C7_PRODUTO),"B1_DESC"))
		else
			TRB1->PRODUTO	:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(QUERY->C7_PRODUTO),"B1_XXDI"))
		endif
		TRB1->DATAMOV	:= QUERY->C7_EMISSAO
		TRB1->DATAMOV2	:= QUERY->C7_DATPRF
		TRB1->FORNECE	:= QUERY->C7_FORNECE
		TRB1->LOJA		:= QUERY->C7_LOJA
		
		//************************************
		if QUERY->C7_MOEDA = 2
			dData := QUERY->C7_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA2
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA2
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
				
			enddo
			TRB1->PRECO		:= QUERY->C7_PRECO * nValor
			TRB1->XVDCI		:= QUERY->C7_TOTAL * nValor
			TRB1->XVDSI		:= QUERY->C7_XTOTSI * nValor
			TRB1->PRECO2	:= QUERY->C7_PRECO
			TRB1->XVDCI2	:= QUERY->C7_TOTAL 
			TRB1->XVDSI2	:= QUERY->C7_XTOTSI
		elseif QUERY->C7_MOEDA = 3
			dData := QUERY->C7_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA3
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA3
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			TRB1->PRECO		:= QUERY->C7_PRECO * nValor
			TRB1->XVDCI		:= QUERY->C7_TOTAL * nValor
			TRB1->XVDSI		:= QUERY->C7_XTOTSI * nValor
			TRB1->PRECO2	:= QUERY->C7_PRECO
			TRB1->XVDCI2	:= QUERY->C7_TOTAL 
			TRB1->XVDSI2	:= QUERY->C7_XTOTSI
		elseif QUERY->C7_MOEDA = 4
			dData := QUERY->C7_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA4
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA4
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			TRB1->PRECO		:= QUERY->C7_PRECO * nValor
			TRB1->XVDCI		:= QUERY->C7_TOTAL * nValor
			TRB1->XVDSI		:= QUERY->C7_XTOTSI * nValor
			TRB1->PRECO2	:= QUERY->C7_PRECO
			TRB1->XVDCI2	:= QUERY->C7_TOTAL 
			TRB1->XVDSI2	:= QUERY->C7_XTOTSI
		else
			TRB1->PRECO		:= QUERY->C7_PRECO 
			TRB1->XVDCI		:= QUERY->C7_TOTAL 
			TRB1->XVDSI		:= QUERY->C7_XTOTSI 
			TRB1->PRECO2	:= 0
			TRB1->XVDCI2	:= 0 
			TRB1->XVDSI2	:= 0
		endif
		
		//************************************
		//TRB1->XVDCI		:= QUERY->C7_TOTAL
		//TRB1->XVDSI		:= QUERY->C7_XTOTSI
		TRB1->ITEMCONTA	:= QUERY->C7_ITEMCTA
		TRB1->IPI		:= QUERY->C7_IPI
		TRB1->ICM		:= QUERY->C7_PICM
		TRB1->XPCOF		:= QUERY->C7_XPCOF
		TRB1->XPPIS		:= QUERY->C7_XPPIS
		TRB1->XAPRN1	:= QUERY->C7_XAPRN1
		TRB1->XAPRN2	:= QUERY->C7_XAPRN2
		TRB1->XAPRN3	:= QUERY->C7_XAPRN3
		TRB1->XCTRVB	:= QUERY->C7_XCTRVB
		TRB1->QUANT		:= QUERY->C7_QUANT
		TRB1->UM		:= QUERY->C7_UM
		
		MsUnlock()
	//endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
QUERY2->(dbclosearea())

return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Processa Vendido 01 Percas					              ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

static function LISTOCS()
Local nValor := 1
local _cQuery := ""
local _cQuery2 := ""
Local _cFilSC7 := xFilial("SC7")
Local cXAPRN1 :=  ""
Local cXAPRN2 :=  ""
Local cXAPRN3 :=  ""
local cFor := ""
Local cDepartamento := ""	
Local cGrup := ""
Local cGrup2 := ""
local cUserCoord := ""

// -- SELECT OCS ABERTAS
	_cQuery := " SELECT  C7_NUM, CAST(C7_EMISSAO AS DATE) 'TMP_EMISSAO', C7_FORNECE, SUM(C7_TOTAL) AS 'TMP_TOTAL', SUM(C7_XTOTSI) AS 'TMP_XTOTSI', " 
	_cQuery += "  C7_XCTRVB, C7_ITEMCTA, C7_XAPRN1, C7_XAPRN2, C7_XAPRN3,C7_MOEDA, "
	_cQuery += "  SUM(C7_DESPESA) AS 'TMP_DESPESA', SUM(C7_SEGURO) AS 'TMP_SEGURO', SUM(C7_VALFRE) AS 'TMP_VALFRE', SUM(C7_VALIPI) AS 'TMP_VALIPI', SUM(C7_ICMSRET) AS 'TMP_ICMSRET', SUM(C7_VLDESC) AS 'TMP_VLDESC', "
	_cQuery += "  (SELECT SUM(C7_TOTAL) FROM SC7010 AS B WHERE B.C7_NUM = A.C7_NUM) AS 'TMP_TOTPCI', "
	_cQuery += "  (SELECT SUM(C7_XTOTSI) FROM SC7010 AS B WHERE B.C7_NUM = A.C7_NUM) AS 'TMP_TOTPSI' "
	_cQuery += "  FROM SC7010 AS A "
	_cQuery += "  WHERE A.D_E_L_E_T_ <> '*' AND C7_ENCER <> 'E'  AND C7_EMISSAO >= '20180521' " 
	_cQuery += "  GROUP BY C7_NUM, C7_EMISSAO, C7_FORNECE, C7_XCTRVB, C7_ITEMCTA, C7_XAPRN1, C7_XAPRN2, C7_XAPRN3, C7_MOEDA "
	_cQuery += "  ORDER BY 1 "

//AND C7_XCTRVB <> ''

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())
	
//******************
	/*
	if ALltrim(PSWRET()[1][12]) $ "Diretoria/Contabilidade/Controladoria" 
		cFor := "QUERY->TMP_TOTAL >= 1500 .AND. !EMPTY(C7_XAPRN1) .AND. EMPTY(C7_XAPRN2) .AND. C7_XCTRVB <> '4' .OR. C7_ITEMCTA == 'ADMINISTRACAO' .AND. C7_XCTRVB <> '4' "
		IndRegua("QUERY",CriaTrab(NIL,.F.),"C7_NUM",,cFor,"Selecionando Registros...")
	else 
		IndRegua("QUERY",CriaTrab(NIL,.F.),"C7_XCTRVB+C7_NUM",,,"Selecionando Registros...")
	endif
	*/
	// TITULOS A RECEBER EM ABERTO
//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )
	/*
	_cQuery2 := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuery2") <> 0
		DbSelectArea("_cQuery2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery2 NEW ALIAS "QUERY2"

	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())
	*/
	SM2->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
	ChkFile("SM2",.F.,"QUERY2") // Alias dos movimentos bancarios
	IndRegua("QUERY2",CriaTrab(NIL,.F.),"M2_DATA",,,"Selecionando Registros...")
	
	ProcRegua(QUERY2->(reccount()))
	
	SM2->(dbgotop())

while QUERY->(!eof())

		RecLock("TRB2",.T.)
		
		//IncProc("Processando registro: "+alltrim(QUERY->TMP_DOC))
		MsProcTxt("Processando registro: "+alltrim(QUERY->C7_NUM))
		ProcessMessage()

		TRB2->ITEMCONTA	:= QUERY->C7_ITEMCTA
		TRB2->NUM		:= QUERY->C7_NUM
		TRB2->DATAMOV	:= QUERY->TMP_EMISSAO
		TRB2->FORNECE	:= QUERY->C7_FORNECE
		TRB2->MOEDA		:= QUERY->C7_MOEDA
		
		TRB2->NOME		:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+alltrim(POSICIONE("SC7",1,XFILIAL("SC7")+QUERY->C7_NUM,"C7_FORNECE")),"A2_NOME"))
		TRB2->LOJA		:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+alltrim(POSICIONE("SC7",1,XFILIAL("SC7")+QUERY->C7_NUM,"C7_FORNECE")),"A2_LOJA"))
		
		IF QUERY->C7_MOEDA = 1
			varSimb := ""
		ELSEIF QUERY->C7_MOEDA = 2
			varSimb := "US$"
		ELSEIF QUERY->C7_MOEDA = 3
			varSimb := "UFIR"
		ELSEIF QUERY->C7_MOEDA = 4
			varSimb := "EUR"
		ENDIF
		
		TRB2->MOEDAD		:= varSimb
		//************************************/
		
		if QUERY->C7_MOEDA = 2
			dData := QUERY->TMP_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA2
				
					if dData == QUERY2->M2_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA2
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->M2_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
				
			enddo
			
			TRB2->XVDCI		:= ((QUERY->TMP_TOTAL+QUERY->TMP_DESPESA+QUERY->TMP_SEGURO+QUERY->TMP_VALFRE+QUERY->TMP_VALIPI+QUERY->TMP_ICMSRET)-QUERY->TMP_VLDESC) * nValor
			TRB2->XVDSI		:= QUERY->TMP_XTOTSI * nValor
			
			TRB2->XVDCI2	:= ((QUERY->TMP_TOTAL+QUERY->TMP_DESPESA+QUERY->TMP_SEGURO+QUERY->TMP_VALFRE+QUERY->TMP_VALIPI+QUERY->TMP_ICMSRET)-QUERY->TMP_VLDESC) 
			TRB2->XVDSI2	:= QUERY->TMP_XTOTSI
		elseif QUERY->C7_MOEDA = 3
			dData := QUERY->TMP_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA3
				
					if dData == QUERY2->M2_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA3
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->M2_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			
			TRB2->XVDCI		:= ((QUERY->TMP_TOTAL+QUERY->TMP_DESPESA+QUERY->TMP_SEGURO+QUERY->TMP_VALFRE+QUERY->TMP_VALIPI+QUERY->TMP_ICMSRET)-QUERY->TMP_VLDESC) * nValor
			TRB2->XVDSI		:= QUERY->TMP_XTOTSI * nValor
			
			TRB2->XVDCI2	:= ((QUERY->TMP_TOTAL+QUERY->TMP_DESPESA+QUERY->TMP_SEGURO+QUERY->TMP_VALFRE+QUERY->TMP_VALIPI+QUERY->TMP_ICMSRET)-QUERY->TMP_VLDESC)
			TRB2->XVDSI2	:= QUERY->TMP_XTOTSI
		elseif QUERY->C7_MOEDA = 4
			dData := QUERY->TMP_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA4
				
					if dData == QUERY2->M2_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA4
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->M2_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			
			TRB2->XVDCI		:= ((QUERY->TMP_TOTAL+QUERY->TMP_DESPESA+QUERY->TMP_SEGURO+QUERY->TMP_VALFRE+QUERY->TMP_VALIPI+QUERY->TMP_ICMSRET)-QUERY->TMP_VLDESC) * nValor
			TRB2->XVDSI		:= QUERY->TMP_XTOTSI * nValor
			
			TRB2->XVDCI2	:= (QUERY->TMP_TOTAL+QUERY->TMP_DESPESA+QUERY->TMP_SEGURO+QUERY->TMP_VALFRE+QUERY->TMP_VALIPI+QUERY->TMP_ICMSRET)-QUERY->TMP_VLDESC 
			TRB2->XVDSI2	:= QUERY->TMP_XTOTSI
		else

			nValor := 1
			
			TRB2->XVDCI		:= (QUERY->TMP_TOTAL+QUERY->TMP_DESPESA+QUERY->TMP_SEGURO+QUERY->TMP_VALFRE+QUERY->TMP_VALIPI+QUERY->TMP_ICMSRET)-QUERY->TMP_VLDESC 
			TRB2->XVDSI		:= QUERY->TMP_XTOTSI 
			
			TRB2->XVDCI2	:= 0 
			TRB2->XVDSI2	:= 0
		endif
		
		//************************************
		/*
		TRB2->XVDCI		:= QUERY->TMP_TOTAL
		TRB2->XVDSI		:= QUERY->TMP_XTOTSI
		
		TRB2->XVDCI2	:= QUERY->TMP_TOTAL
		TRB2->XVDSI2	:= QUERY->TMP_XTOTSI
		
		TRB2->DESPESA	:= QUERY->TMP_DESPESA
		TRB2->SEGURO	:= QUERY->TMP_SEGURO
		TRB2->VALFRE	:= QUERY->TMP_VALFRE
		TRB2->VALIPI	:= QUERY->TMP_VALIPI
		TRB2->ICMSRET	:= QUERY->TMP_ICMSRET
		TRB2->VLDESC	:= QUERY->TMP_VLDESC
		*/
		
		TRB2->TOTPCI	:= QUERY->TMP_TOTPCI  * nValor
		TRB2->TOTPSI	:= QUERY->TMP_TOTPSI * nValor
		TRB2->XCTRVB	:= QUERY->C7_XCTRVB
		
		cUserCoord := POSICIONE("CTD",1,XFILIAL("CTD")+ SC7->C7_ITEMCTA,"CTD_XIDPM")

		PswOrder(1)
		If PswSeek(alltrim(cUserCoord), .T. )
			cGrup := alltrim(PSWRET()[1][12])
		endif

		//alert ( cGrup )

		if ALLTRIM(QUERY->C7_ITEMCTA) $ "ADMINISTRACAO/PROPOSTA" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
			TRB2->DESCR := "Diretoria"
		elseif ALLTRIM(QUERY->C7_ITEMCTA) $ "ADMINISTRACAO/PROPOSTA" .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
			TRB2->DESCR := "Aprovado"
		endif

		if cGrup == "Contratos" .AND. substr(QUERY->C7_ITEMCTA,1,2) $ "EQ/ST"
			if TRB2->TOTPCI > 1500 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO"
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Coordenador / Diretoria"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Diretoria"
				elseif EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Coordenador"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Aprovado"
				endif
			else
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1))
					TRB2->DESCR := "Coordenador"
				else
					TRB2->DESCR := "Aprovado"
				endif
			endif
		endif

		if cGrup == "Contratos" .AND. substr(QUERY->C7_ITEMCTA,1,2) $ "AT/PR/GR/CM"
			if TRB2->TOTPCI > 1500 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO"
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3))
					TRB2->DESCR := "Coordenador / Gerencia / Diretoria"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1))  .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Gerencia / Diretoria"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Diretoria"
				elseif EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Coordenador / Diretoria"
				elseif EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Coordenador / Gerencia"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Gerencia"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3))
					TRB2->DESCR := "Aprovado"
				endif
			else
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1))
					TRB2->DESCR := "Coordenador"
				else
					TRB2->DESCR := "Aprovado"
				endif
			endif
		endif

		if cGrup == "Contratos(E)" .AND. substr(QUERY->C7_ITEMCTA,1,2) $ "EQ/ST"
			if TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO"
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Coordenador / Diretoria"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Diretoria"
				elseif EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Coordenador"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Aprovado"
				endif
			else
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1))
					TRB2->DESCR := "Coordenador"
				else
					TRB2->DESCR := "Aprovado"
				endif
			endif
		endif

		if cGrup == "Contratos(E)" .AND. substr(QUERY->C7_ITEMCTA,1,2) $ "AT/PR/GR/CM"

			if TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO"
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3))
					TRB2->DESCR := "Coordenador / Gerencia / Diretoria"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1))  .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Gerencia / Diretoria"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Diretoria"
				elseif EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Coordenador / Diretoria"
				elseif EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Coordenador / Gerencia"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Gerencia"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3))
					TRB2->DESCR := "Aprovado"
				endif
			else
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1))
					TRB2->DESCR := "Coordenador"
				else
					TRB2->DESCR := "Aprovado"
				endif
			endif
		endif

		PswOrder(1)
		If PswSeek(alltrim(RetCodUsr()), .T. )
			cGrup2 := alltrim(PSWRET()[1][12])
		endif

		if cGrup2 == "Diretoria" .AND. substr(QUERY->C7_ITEMCTA,1,2) $ "EQ/ST"
			if TRB2->TOTPCI > 1500 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO"
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Coordenador / Diretoria"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Diretoria"
				elseif EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Coordenador"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Aprovado"
				endif
			else
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1))
					TRB2->DESCR := "Coordenador"
				else
					TRB2->DESCR := "Aprovado"
				endif
			endif
		endif

		if cGrup2 == "Diretoria" .AND. substr(QUERY->C7_ITEMCTA,1,2) $ "AT/PR/GR/CM"
			if TRB2->TOTPCI > 1500 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO"
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3))
					TRB2->DESCR := "Coordenador / Gerencia / Diretoria"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1))  .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2))
					TRB2->DESCR := "Gerencia / Diretoria"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Diretoria"
				elseif EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Coordenador / Diretoria"
				elseif EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Coordenador / Gerencia"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) 
					TRB2->DESCR := "Gerencia"
				elseif !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN3))
					TRB2->DESCR := "Aprovado"
				endif
			else
				if EMPTY(ALLTRIM(QUERY->C7_XAPRN1))
					TRB2->DESCR := "Coordenador"
				else
					TRB2->DESCR := "Aprovado"
				endif
			endif
		endif




/*
	
		if cGrup == "Contratos" .AND. QUERY->C7_XCTRVB <> "4"
			if alltrim(QUERY->C7_XCTRVB) == "4"
				TRB2->DESCR := "Aprovado"
			elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) //.AND. _cDepart == "Contratos"
				TRB2->DESCR := "Coordenador / Diretoria"
			elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1))  .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2))// .AND. _cDepart == "Contratos"
				TRB2->DESCR := "Coordenador "
			elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN1))  .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) //.AND. _cDepart == "Contratos"
				TRB2->DESCR := "Diretoria "
			elseif TRB2->TOTPCI <= 1500 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. cGrup == "Contratos"
				TRB2->DESCR := "Coordenador "
			elseif TRB2->TOTPCI <= 1500 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. cGrup == "Contratos"
				TRB2->DESCR := "Aprovado "
			endif
	
		elseif cGrup == "Contratos(E)" .AND. QUERY->C7_XCTRVB <> "4"
			if TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3))//.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador / Gerencia / Diretoria"
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3))//.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador /  Diretoria"
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3))//.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador / Gerencia "
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) //.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador / Diretoria"
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1))  .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) //.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador "
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN1))  .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) //.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Diretoria "
			elseif TRB2->TOTPCI <= 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) //.AND. //_cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador "
			elseif TRB2->TOTPCI <= 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) //.AND. //_cDepart == "Contratos(E)"
				TRB2->DESCR := "Aprovado "	
			endif
		elseif cGrup == "" .AND. QUERY->C7_XCTRVB <> "4"
			if TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3))//.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador / Gerencia / Diretoria"
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3))//.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador /  Diretoria"
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3))//.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador / Gerencia "
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN3)) //.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador / Diretoria"
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) //.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador / Diretoria"
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1))  .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) //.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador "
			elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN1))  .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) //.AND. _cDepart == "Contratos(E)"
				TRB2->DESCR := "Diretoria "
			elseif TRB2->TOTPCI <= 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) //.AND. //_cDepart == "Contratos(E)"
				TRB2->DESCR := "Coordenador "
			elseif TRB2->TOTPCI <= 1000 .AND. ALLTRIM(QUERY->C7_ITEMCTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(QUERY->C7_XAPRN1)) //.AND. //_cDepart == "Contratos(E)"
				TRB2->DESCR := "Aprovado "	
			endif
		elseif QUERY->C7_XCTRVB == "4"
			TRB2->DESCR := "Aprovado "	
		else		
			if ALLTRIM(QUERY->C7_ITEMCTA) == "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(QUERY->C7_XAPRN2)) //.AND. QUERY->C7_XCTRVB <> "4"
				TRB2->DESCR := "Diretoria "
			endif
			
		endif*/
		
		cXAPRN1 :=  AllTrim(UsrFullName(alltrim(QUERY->C7_XAPRN1)))
		TRB2->XAPRN1	:= QUERY->C7_XAPRN1
		TRB2->XAPRN1D	:= cXAPRN1
		cXAPRN1 := ""
		
		cXAPRN2 :=  AllTrim(UsrFullName(alltrim(QUERY->C7_XAPRN2)))
		TRB2->XAPRN2	:= QUERY->C7_XAPRN2
		TRB2->XAPRN2D	:= cXAPRN2
		cXAPRN2 := ""

		cXAPRN3 :=  AllTrim(UsrFullName(alltrim(QUERY->C7_XAPRN3)))
		TRB2->XAPRN3	:= QUERY->C7_XAPRN3
		TRB2->XAPRN3D	:= cXAPRN3
		cXAPRN3 := ""
		
		TRB2->DESPESA	:= QUERY->TMP_DESPESA
		TRB2->SEGURO	:= QUERY->TMP_SEGURO
		TRB2->VALFRE	:= QUERY->TMP_VALFRE
		TRB2->VALIPI	:= QUERY->TMP_VALIPI
		TRB2->ICMSRET	:= QUERY->TMP_ICMSRET
		TRB2->VLDESC	:= QUERY->TMP_VLDESC
			
		MsUnlock()
	//endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
QUERY2->(dbclosearea())

return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Monta a tela de visualizacao do Fluxo Sintetico            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
static function MontaTela()
//Local oGet1
Local oGet1 := Space(13)
Local nposi
Local oGreen   	:= LoadBitmap( GetResources(), "BR_VERDE")
Local oRed    	:= LoadBitmap( GetResources(), "BR_VERMELHO")
Local oBlack	:= LoadBitmap( GetResources(), "BR_PRETO")
Local oYellow	:= LoadBitmap( GetResources(), "BR_AMARELO")
Local oBrown	:= LoadBitmap( GetResources(), "BR_MARROM")
Local oBlue		:= LoadBitmap( GetResources(), "BR_AZUL")
Local oOrange	:= LoadBitmap( GetResources(), "BR_LARANJA")
Local oViolet	:= LoadBitmap( GetResources(), "BR_VIOLETA")
Local oPink		:= LoadBitmap( GetResources(), "BR_PINK")
Local oGray		:= LoadBitmap( GetResources(), "BR_CINZA")
local cDepart := ""
local cGrup		:= ""
private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ]+25, aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oGetDbSint2
Private _oDlgSint

/*
private cField := FieldName( 1 )   // Obtï¿½m o nome do primeiro campo
	//private xValue := &cField          // Obtï¿½m o conteï¿½do deste campo
	private _cItemConta := &cField 
*/
//private _cItemConta := TRB2->CAMPO

cCadastro :=  "Aprovacao Ordem de Compra "

	PswOrder(2)
	If PswSeek(alltrim(RetCodUsr()), .T. )
		cGrup := alltrim(PSWRET()[1][12])
	endif

	if cGrup $ "Diretoria/Contabilidade/Controladoria" 
		cFil1B := "TRB2->TOTPCI >= 1000  .AND. TRB2->XCTRVB <> '4' "  //.AND. alltrim(TRB2->XAPRN1) <> '' .AND. alltrim(TRB2->XAPRN2) == '' .AND. TRB2->XCTRVB <> '4' .OR. alltrim(TRB2->ITEMCONTA) == 'ADMINISTRACAO'
		TRB2->(dbsetfilter({|| &(cFil1B)} , cFil1B))
		TRB2->(dbGoTop())
	else
		cFil1B := " TRB2->XCTRVB <> '4' " 
		TRB2->(dbsetfilter({|| &(cFil1B)} , cFil1B))
		TRB2->(dbGoTop())
	endif

// Monta aHeader do TRB2

aadd(aHeader, {" Numero O.C."			,"NUM"		,"",06,0,"","","C","TRB2","R"})
aadd(aHeader, {"Requer Aprovacaoo"		,"DESCR"	,"",20,0,"","","C","TRB2","R"})
aadd(aHeader, {"Emissao"			 	,"DATAMOV"	,"",08,0,"","","D","TRB2","R"})
aadd(aHeader, {"Fornecedor"			 	,"FORNECE"	,"",10,0,"","","C","TRB2","R"})
aadd(aHeader, {"Nome"					,"NOME"		,"",60,0,"","","C","TRB2","R"})
aadd(aHeader, {"Loja"					,"LOJA"		,"",02,0,"","","C","TRB2","R"})
aadd(aHeader, {"Total c/ Tributos R$"	,"XVDCI"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Total s/ Tributos R$"	,"XVDSI"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Moeda"					,"MOEDA"	,"@E 999",3,0,"","","N","TRB2","R"})
aadd(aHeader, {"$"						,"MOEDAD"	,"",05,0,"","","C","TRB2","R"})
aadd(aHeader, {"Total c/ Tributos " 	,"XVDCI2"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Total s/ Tributos " 	,"XVDSI2"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Item Conta"				,"ITEMCONTA","",13,0,"","","C","TRB2","R"})
aadd(aHeader, {"Aprov. Nivel 1"			,"XAPRN1"	,"",06,0,"","","C","TRB2","R"})
aadd(aHeader, {"Coordenador"			,"XAPRN1D"	,"",40,0,"","","C","TRB2","R"})
aadd(aHeader, {"Aprov. Nivel 2"			,"XAPRN3"	,"",06,0,"","","C","TRB2","R"})
aadd(aHeader, {"Gerencia"				,"XAPRN3D"	,"",40,0,"","","C","TRB2","R"})
aadd(aHeader, {"Aprov. Nivel 3"			,"XAPRN2"	,"",06,0,"","","C","TRB2","R"})
aadd(aHeader, {"Diretoria"				,"XAPRN2D"	,"",40,0,"","","C","TRB2","R"})
aadd(aHeader, {"Controle Aprovacao"		,"XCTRVB"	,"",01,0,"","","C","TRB2","R"})
aadd(aHeader, {"Despesa"				,"DESPESA"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"SEGURO"					,"SEGURO"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Frete"					,"VALFRE"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"IPI"					,"VALIPI"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"ICMS Subst.Trib."		,"ICMSRET"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Desconto"				,"VLDESC"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Total OC c/Trib."		,"TOTPCI"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Total OC s/Trib."		,"TOTPSI"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})

DEFINE MSDIALOG _oDlgSint ;
TITLE "Aprovacao Ordem de Compra " ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-20,aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2")


_oGetDbSint:oBrowse:BlDblClick := 	{|| ShowAnalit()  , , _oDlgSint:Refresh()  }
//_oGetDbSint:oBrowse:BlDblClick := 	{|| ShowAnalit()  , _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()  }

/*
// COR DA FONTE
_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
// COR DA LINHA
//_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| fTrocaCor(2)}
_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha
*/

@ 0035 , 0010 BUTTON 'Contratos - Nao Aprovadas'  + Chr(13) + Chr(10) + 'maior que 1500,00'           Size 75, 20 action(OC1500()) of _oDlgSint Pixel  
@ 0035 , 0090 BUTTON 'Contratos - Nao Aprovadas'  + Chr(13) + Chr(10) + 'menor ou igual a 1500,00'   Size 75, 20 action(OC5001()) of _oDlgSint Pixel  
@ 0035 , 0170 BUTTON 'Administracao'  + Chr(13) + Chr(10) + 'Nao Aprovadas'    	  	    		  	Size 75, 20 action(OCADM()) of _oDlgSint Pixel 
@ 0035 , 0250 BUTTON 'Contratos'  + Chr(13) + Chr(10) + 'maior que 1500,00'         				  Size 75, 20 action(OC5002()) of _oDlgSint Pixel  
@ 0035 , 0330 BUTTON 'Contratos'  + Chr(13) + Chr(10) + 'menor ou igual a 1500,00'					  Size 75, 20 action(OC5003()) of _oDlgSint Pixel  
@ 0035 , 0410 BUTTON 'Administracao'					   	  	    		  						  Size 75, 20 action(OCADM2()) of _oDlgSint Pixel 
@ 0035 , 0490 BUTTON 'Todos  '   	  	   													   		  Size 75, 20 action(OCfull()) of _oDlgSint Pixel 

nPos := aPosObj[1,3]-15

@ nPos , 0005 Say "De um clique duplo na Ordem de Compra para visualizar detalhes e Aprovar. "  COLORS 0, 16777215 PIXEL

//nPos := aPosObj[1,3]-30
//@ nPos+5 , aPosObj[2,2]+5 Say "Dï¿½ um clique duplo na Ordem de Compra para visualizar detalhes e Aprovar. "  COLORS 0, 16777215 PIXEL
//aadd(aButton , { "BMPTABLE" , { || zExpFatF()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
//aadd(aButton , { "BMPTABLE" , { || VendidoFull("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Vendido " } )
//aadd(aButton , { "BMPTABLE" , { || u_PedComPo()}, "Imprimir " } )

//aadd(aButton , { "BMPTABLE" , { || ShowAnalit()}, "Imprimir " } )
//aadd(aButton , { "BMPTABLE" , { || GCemail()}, "Enviar Email " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

//ACTIVATE MSDIALOG _oDlgSint CENTERED

//TRB2->(dbgotop())
TRB2->(DBGoBottom())
TRB2->(dbgotop())
_oGetDbSint:Refresh()

return

//********************

static function OCfull()
	TRB2->(dbclearfil())
	TRB2->(dbGoTop())
return

//****************************
static function OC1500()

local cFiltro1A 	:= ""

TRB2->(dbclearfil())
TRB2->(dbGoTop())
// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltro1A := " TRB2->TOTPCI  >= 1500 .AND. TRB2->ITEMCONTA <> 'ADMINISTRACAO' .AND. TRB2->XCTRVB <> '4'" 
TRB2->(dbsetfilter({|| &(cFiltro1A)} , cFiltro1A))

TRB2->(dbGoTop())
Return
//*********************************
static function OC5001()

local cFil1B 	:= ""

TRB2->(dbclearfil())
TRB2->(dbGoTop())
// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFil1B := " TRB2->TOTPCI  < 1500 .AND. TRB2->ITEMCONTA <> 'ADMINISTRACAO' .AND. TRB2->XCTRVB <> '4'" 
TRB2->(dbsetfilter({|| &(cFil1B)} , cFil1B))
TRB2->(dbGoTop())
Return

//******************************
static function OCADM()

local cFil1C 	:= ""
TRB2->(dbclearfil())
TRB2->(dbGoTop())
// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFil1C := " TRB2->ITEMCONTA $ 'ADMINISTRACAO/ESTOQUE' .AND. TRB2->XCTRVB <> '4'" 
TRB2->(dbsetfilter({|| &(cFil1C)} , cFil1C))
TRB2->(dbGoTop())
Return

static function OCTODOS()
	TRB2->(dbclearfil())
	TRB2->(dbGoTop())
return

//************************
static function OC5002()

local cFiltro1A 	:= ""

TRB2->(dbclearfil())
TRB2->(dbGoTop())
// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltro1A := " TRB2->TOTPCI  > 1500 .AND. TRB2->ITEMCONTA <> 'ADMINISTRACAO'" 
TRB2->(dbsetfilter({|| &(cFiltro1A)} , cFiltro1A))

TRB2->(dbGoTop())
Return

//*********************************
static function OC5003()

local cFil1B 	:= ""

TRB2->(dbclearfil())
TRB2->(dbGoTop())
// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFil1B := " TRB2->TOTPCI  <= 1500 .AND. TRB2->ITEMCONTA <> 'ADMINISTRACAO'" 
TRB2->(dbsetfilter({|| &(cFil1B)} , cFil1B))
TRB2->(dbGoTop())
Return

//****************************

static function OCADM2()

local cFil1C 	:= ""
TRB2->(dbclearfil())
TRB2->(dbGoTop())
// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFil1C := " TRB2->ITEMCONTA $ 'ADMINISTRACAO/ESTOQUE'" 
TRB2->(dbsetfilter({|| &(cFil1C)} , cFil1C))
TRB2->(dbGoTop())
Return

/*
Static Function SFMudaCor(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  
   	  if EMPTY(ALLTRIM(TRB2->DESCRICAO)) .AND. EMPTY(ALLTRIM(TRB2->GRUPO)); _cCor := CLR_LIGHTGRAY; endif
   	    	 
    endif
   
   if nIOpcao == 2 // Cor da Fonte
   	  if EMPTY(ALLTRIM(TRB2->DESCRICAO)) .AND. EMPTY(ALLTRIM(TRB2->GRUPO)); _cCor := CLR_LIGHTGRAY; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "CUSTO PRODUCAO"; _cCor := CLR_YELLOW ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "CUSTO TOTAL"; _cCor := CLR_YELLOW ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "MARGEM BRUTA"; _cCor := CLR_HGREEN  ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "MARGEM CONTRIB."; _cCor := CLR_HGREEN ; endif
   	  
   	   if ALLTRIM(TRB2->GRUPO) ==  "COGS"; _cCor := CLR_HCYAN ; endif
          //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.18"; _cCor := CLR_HGREEN ; endif
      
  
    endif
Return _cCor
*/

static function ShowAnalit(_Campo)
local cFiltra 	:= ""
local nVDSI 	:= 0
local nVDSIcIPI := 0
local nVDCI 	:= 0
local nVLDESC 	:= 0
local nICMSRET	:= 0
local nVALIPI	:= 0
local nVALFRE	:= 0
local nSEGURO	:= 0
local nDESPESA	:= 0
//local nVDCI2	:= 0
local nVDSI2	:= 0

Private oAnexCham1
Private cAnexCham1 := Space(255)


Private nVDCI2	:= 0
Private _oGetDbAnalit
Private _oDlgAnalit
Private _oDlgAnalit2
Private _oDlgAnalit5

Private xSize   := MsAdvSize(,.F.,400)
Private xObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private xInfo2   := { xSize[ 1 ], xSize[ 2 ], xSize[ 3 ], xSize[ 4 ]-125, 5, 5 }
Private xPosObj := MsObjSize( xInfo2, xObjects, .T. )

Private xInfo3   := { xSize[ 1 ]+350, xSize[ 2 ]+290, xSize[ 3 ], xSize[ 4 ], 5, 5 }
Private xPosObj2 := MsObjSize( xInfo3, xObjects, .T. )

Private xInfo5   := { xSize[ 1 ], xSize[ 2 ]+290, xSize[ 3 ], xSize[ 4 ], 5, 5 }
Private xPosObj5 := MsObjSize( xInfo5, xObjects, .T. )

Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}
Private cNum 	:=  TRB2->NUM

zProvJobs()
zXPrJobs()
zCustJobs()
zZCuJobs()

cCadastro :=  "Aprovacao Ordem de Compra - " + cNum

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
/*
if ALLTRIM(_cCampo) == "PEREMP" .or. ALLTRIM(_cCampo) == "PERVD" .OR. ALLTRIM(_cCampo) == "PERPLN" .OR. ALLTRIM(_cCampo) == "VLRSLD" .OR. ALLTRIM(_cCampo) == "PERSLD" .OR.;
	ALLTRIM(_cCampo) == "PERCTB" .OR. ALLTRIM(_cCampo) == "PERCTBE" .OR. ALLTRIM(_cCampo) == "ID"
	return
endif
*/

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra := " TRB1->NUM  == '" + TRB2->NUM + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))

cMoeda := POSICIONE("SC7",1,XFILIAL("SC7")+cNum,"C7_MOEDA")

	IF cMoeda = 1
		varSimb := "R$"
	ELSEIF cMoeda = 2
		varSimb := "US$"
	ELSEIF cMoeda = 3
		varSimb := "UFIR"
	ELSEIF cMoeda = 4
		varSimb := "EUR"
	ENDIF

// Monta aHeader do TRB1
aadd(aHeader, {"Item"					,"ITEM"		,"",06,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cod.Produto"			,"CODPROD"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descricao"				,"PRODUTO"	,"",80,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Fornecedor"			,"FORNECE"	,"",10,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Nome"					,"NOME"		,"",60,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Loja"					,"LOJA"		,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Quantidade"				,"QUANT"	,"@E 99,999.999999",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Unidade"				,"UM"		,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Preco  R$"				,"PRECO"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Total c/ Tributos R$"	,"XVDCI"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Total s/ Tributos R$"	,"XVDSI"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
if varSimb <> "R$"
	aadd(aHeader, {"Preco " + varSimb		,"PRECO2"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total c/ Tributos " + varSimb 	,"XVDCI2"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total s/ Tributos "	+ varSimb	,"XVDSI2"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
endif
aadd(aHeader, {"Item Conta"				,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Data Entrega"		 	,"DATAMOV2"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"% IPI"					,"IPI"		,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"% ICMS"					,"ICM"		,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"% PIS"					,"XPPIS"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"% Cofins"				,"XPCOF"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Usuario Nivel 1"		,"XAPRN1"	,"",06,0,"","","C","TRB1","R"})
aadd(aHeader, {"Usuario Nivel 3"		,"XAPRN2"	,"",06,0,"","","C","TRB1","R"})
aadd(aHeader, {"Controle Aprovacao"		,"XCTRVB"	,"",01,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Descricao"			,"DESCR"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Numero O.C."			,"NUM"		,"",06,0,"","","C","TRB1","R"})
aadd(aHeader, {"Usuario Nivel 2"		,"XAPRN3"	,"",06,0,"","","C","TRB1","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Aprovacao Ordem de Compra - " + cNum  From xSize[7],0 to xSize[6],xSize[5] of oMainWnd PIXEL

 @ aPosObj[1,1]+78,aPosObj[1,2] FOLDER oFolder1 SIZE  aPosObj[1,4],aPosObj[1,3]-150 OF _oDlgAnalit ;
	  	ITEMS "Itens Pedido de Compra", "Provisoes (Financeiro - Contas a Pagar)", "Custo Contrato" COLORS 0, 16777215 PIXEL

zProvCPIC()
zCabDetOC()
zCustIC()
	
@ 0005, xPosObj[2,2] BUTTON '&Aprovar Ordem de Compra'          Size 80, 20 action(zValidar()) OF oFolder1:aDialogs[1] Pixel
@ 0005, xPosObj[2,2]+90 BUTTON '&Rejeitar '           			Size 80, 20 action(xRejeitar()) OF oFolder1:aDialogs[1] Pixel
@ 0005, xPosObj[2,2]+180 BUTTON '&Notas '           			Size 80, 20 action(xNotas()) OF oFolder1:aDialogs[1] Pixel 
@ 0005, xPosObj[2,2]+270 BUTTON '&Entrega '           			Size 80, 20 action(xEntrega()) OF oFolder1:aDialogs[1] Pixel  
//@ 0005, xPosObj[2,2]+360 BUTTON '&Imprimir '           			Size 80, 20 action(zImpriPC()) OF oFolder1:aDialogs[1] Pixel  

//@ aPosObj[2,1]+95, aPosObj[2,2]+5 BUTTON '&Imprimir '           			Size 80, 20 action(zPedCom()) of _oDlgAnalit Pixel  


//@ xPosObj5[2,1],xPosObj5[1,2] Say  "Custo de Contrato(s)  " COLORS 0, 16777215 OF oFolder1:aDialogs[3] Pixel
//@ xPosObj[2,1],xPosObj[1,2] Say  "Controle de Provisoes - Contas a Pagar  " COLORS 0, 16777215 OF oFolder1:aDialogs[2] Pixel


//@ aPosObj[2,1]+5, aPosObj[2,2]+260 BUTTON '&Imprimir '           			Size 80, 20 action(U_PedComPo()) of _oDlgAnalit Pixel  
//@ aPosObj[2,1]+5, aPosObj[2,2]+345 BUTTON '&Provisoes Job'           		Size 80, 20 action(zProvJobs()) of _oDlgAnalit Pixel  
//@ aPosObj[2,1]+5, aPosObj[2,2]+270 BUTTON '&Imprimir '           			Size 80, 20 action(zPedCom()) of _oDlgAnalit Pixel  

//aadd(aButton , { "BMPTABLE" , { || MontaRel()}, "Imprimir " } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
//aadd(aButton , { "BMPTABLE" , { || PRNGCdet()}, "Imprimir " } )

//aadd(aButton , { "BMPTABLE" , { || zImpriPC()}, "Imprimir " } )

//ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)
ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

//ACTIVATE MSDIALOG _oDlgAnalit CENTERED

TRB1->(dbclearfil())



return

/***********************************************
/** CABEÇALHO DETALHAMENTO PEDIDO DE COMPRA   */
/**********************************************/

static function zCabDetOC()

local nVDSI 	:= 0
local nVDSIcIPI := 0
local nVDCI 	:= 0
local nVLDESC 	:= 0
local nICMSRET	:= 0
local nVALIPI	:= 0
local nVALFRE	:= 0
local nSEGURO	:= 0
local nDESPESA	:= 0
//local nVDCI2	:= 0
local nVDSI2	:= 0

	oGroup1:= TGroup():New(0029,0015,0053,0730,'',_oDlgAnalit,,,.T.)
oGroup2:= TGroup():New(0054,0015,0080,0730,'',_oDlgAnalit,,,.T.)
oGroup4:= TGroup():New(0081,0015,0110,0730,'',_oDlgAnalit,,,.T.)
oGroup4:= TGroup():New(0108,0015,0137,0730,'',_oDlgAnalit,,,.T.)
//oGroup3:= TGroup():New(0054,0350,0080,0730,'',_oDlgAnalit,,,.T.)
/*
oGroup4:= TGroup():New(0081,0015,0110,0345,'Custo Vendido',_oDlgAnalit,,,.T.)
oGroup5:= TGroup():New(0081,0350,0110,0730,'Custo Revisado',_oDlgAnalit,,,.T.)
*/

@ 0030,0020 Say  "Emissao " COLORS 0, 16777215 PIXEL
@ 0038,0020 MSGET  Posicione("SC7",1,xFilial("SC7") + cNum,"C7_EMISSAO")  COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0070 Say  "Fornecedor "  COLORS 0, 16777215 PIXEL
@ 0038,0070 MSGET alltrim(POSICIONE("SC7",1,XFILIAL("SC7")+cNum,"C7_FORNECE")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0110 Say  "Nome Fornecedor " COLORS 0, 16777215 PIXEL
@ 0038,0110 MSGET  alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+alltrim(POSICIONE("SC7",1,XFILIAL("SC7")+cNum,"C7_FORNECE")),"A2_NOME")) SIZE 260,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0380 Say  "Contato "  COLORS 0, 16777215 PIXEL
@ 0038,0380 MSGET alltrim(POSICIONE("SC7",1,XFILIAL("SC7")+cNum,"C7_CONTATO")) SIZE 280,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.



/* totalizar cabecalhos detalhamento */
TRB2->(dbGoTop())
while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
	if TRB1->NUM  == TRB2->NUM
		nDESPESA += TRB2->DESPESA
	endif
	TRB2->(dbskip())
enddo

TRB2->(dbGoTop())
while TRB2->NUM <> cNum
	TRB2->(dbskip())
enddo

@ 0056,0020 Say  "Despesas " 	COLORS 0, 16777215 PIXEL
@ 0064,0020 MSGET  transform(nDESPESA, "@E 999,999,999.99" ) SIZE 65,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

/* totalizar cabecalhos detalhamento */
TRB2->(dbGoTop())
while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
	if TRB1->NUM  == TRB2->NUM
		nSEGURO += TRB2->SEGURO
	endif
	TRB2->(dbskip())
enddo

TRB2->(dbGoTop())
while TRB2->NUM <> cNum
	TRB2->(dbskip())
enddo

@ 0056,0090 Say  "Seguro " 	COLORS 0, 16777215 PIXEL
@ 0064,0090 MSGET  transform(nSEGURO, "@E 999,999,999.99" ) SIZE 65,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

/* totalizar cabecalhos detalhamento */
TRB2->(dbGoTop())
while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
	if TRB1->NUM  == TRB2->NUM
		nVALFRE += TRB2->VALFRE
	endif
	TRB2->(dbskip())
enddo

TRB2->(dbGoTop())
while TRB2->NUM <> cNum
	TRB2->(dbskip())
enddo

@ 0056,0160 Say  "Frete " 	COLORS 0, 16777215 PIXEL
@ 0064,0160 MSGET  transform(nVALFRE, "@E 999,999,999.99" ) SIZE 65,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

/* totalizar cabecalhos detalhamento */
TRB2->(dbGoTop())
while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
	if TRB1->NUM  == TRB2->NUM
		nVALIPI += TRB2->VALIPI
	endif
	TRB2->(dbskip())
enddo

TRB2->(dbGoTop())
while TRB2->NUM <> cNum
	TRB2->(dbskip())
enddo

@ 0056,0230 Say  "IPI " 	COLORS 0, 16777215 PIXEL
@ 0064,0230 MSGET  transform(nVALIPI, "@E 999,999,999.99" ) SIZE 60,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

/* totalizar cabecalhos detalhamento */
TRB2->(dbGoTop())
while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
	if TRB1->NUM  == TRB2->NUM
		nICMSRET += TRB2->ICMSRET
	endif
	TRB2->(dbskip())
enddo

TRB2->(dbGoTop())
while TRB2->NUM <> cNum
	TRB2->(dbskip())
enddo

@ 0056,0300 Say  "ICMS Subst.Trib. " 	COLORS 0, 16777215 PIXEL
@ 0064,0300 MSGET  transform(nICMSRET, "@E 999,999,999.99" ) SIZE 65,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

/* totalizar cabecalhos detalhamento */
TRB2->(dbGoTop())
while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
	if TRB1->NUM  == TRB2->NUM
		nVLDESC += TRB2->VLDESC
	endif
	TRB2->(dbskip())
enddo

TRB2->(dbGoTop())
while TRB2->NUM <> cNum
	TRB2->(dbskip())
enddo

@ 0056,0370 Say  "Desconto " 	COLORS 0, 16777215 PIXEL
@ 0064,0370 MSGET  transform(nVLDESC, "@E 999,999,999.99" ) SIZE 65,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

/* totalizar cabecalhos detalhamento */
TRB2->(dbGoTop())
while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
	if TRB1->NUM  == TRB2->NUM
		nVDCI += TRB2->XVDCI
	endif
	TRB2->(dbskip())
enddo

TRB2->(dbGoTop())
while TRB2->NUM <> cNum
	TRB2->(dbskip())
enddo

@ 0056,0450 Say  "Total Produtos R$ " 	COLORS 0, 16777215 PIXEL
@ 0064,0450 MSGET  transform(nVDCI, "@E 999,999,999.99" ) SIZE 65,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

/* totalizar cabecalhos detalhamento */
TRB2->(dbGoTop())
while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
	if TRB1->NUM  == TRB2->NUM
		nVDSIcIPI += (TRB2->XVDCI+TRB2->SEGURO+TRB2->DESPESA+TRB2->VALFRE)-(TRB2->VLDESC+TRB2->ICMSRET) // TRB2->VALIPI+
	endif
	TRB2->(dbskip())
enddo

TRB2->(dbGoTop())
while TRB2->NUM <> cNum
	TRB2->(dbskip())
enddo

@ 0056,0520 Say  "Total O.C. c/ IPI R$ " 	COLORS 0, 16777215 PIXEL
@ 0064,0520 MSGET  transform(nVDSIcIPI, "@E 999,999,999.99" ) SIZE 55,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

/* totalizar cabecalhos detalhamento */
TRB2->(dbGoTop())
while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
	if TRB1->NUM  == TRB2->NUM
		nVDSI += TRB2->XVDSI
	endif
	TRB2->(dbskip())
enddo

TRB2->(dbGoTop())
while TRB2->NUM <> cNum
	TRB2->(dbskip())
enddo

@ 0056,0590 Say  "Total s/ Tributos R$" 	COLORS 0, 16777215 PIXEL
@ 0064,0590 MSGET  transform(nVDSI, "@E 999,999,999.99" ) SIZE 65,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F. //TRB2->XVDSI
/*************************************/

if varSimb <> "R$"

	/* totalizar cabecalhos detalhamento */
	TRB2->(dbGoTop())
	while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
		if TRB1->NUM  == TRB2->NUM
			nVDCI2 += TRB2->XVDCI2
		endif
		TRB2->(dbskip())
	enddo
	
	TRB2->(dbGoTop())
	while TRB2->NUM <> cNum
		TRB2->(dbskip())
	enddo

	@ 0085,0450 Say  "Total Produtos "  + varSimb 	COLORS 0, 16777215 PIXEL
	@ 0093,0450 MSGET  transform(nVDCI2, "@E 999,999,999.99" ) SIZE 65,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	/* totalizar cabecalhos detalhamento */
	TRB2->(dbGoTop())
	while TRB2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
		if TRB1->NUM  == TRB2->NUM
			nVDSI2 += TRB2->XVDSI2
		endif
		TRB2->(dbskip())
	enddo
	
	TRB2->(dbGoTop())
	while TRB2->NUM <> cNum
		TRB2->(dbskip())
	enddo
	
	@ 0085,0520 Say  "Total s/ Tributos "  + varSimb 	COLORS 0, 16777215 PIXEL
	@ 0093,0520 MSGET  transform(nVDSI2, "@E 999,999,999.99" ) SIZE 65,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

endif

@ 0085,0020 Say  "Codicao de Pagamento " 	 COLORS 0, 16777215 PIXEL
@ 0093,0020 MSGET  alltrim(POSICIONE("SC7",1,XFILIAL("SC7")+cNum,"C7_COND")) SIZE 85,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0085,0110 Say  " " 	 COLORS 0, 16777215 PIXEL
@ 0093,0110 MSGET  ALLTRIM(Posicione("SE4",1,xFilial("SE4") + alltrim(POSICIONE("SC7",1,XFILIAL("SC7")+cNum,"C7_COND")),"E4_DESCRI")) SIZE 200,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0085,0320 Say  "Moeda "  COLORS 0, 16777215 PIXEL
@ 0093,0320 MSGET transform(POSICIONE("SC7",1,XFILIAL("SC7")+cNum,"C7_MOEDA"), "@E 99") SIZE 20,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0085,0345 Say  " "  COLORS 0, 16777215 PIXEL
@ 0093,0345 MSGET varSimb SIZE 30,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

cAnexCham1 := POSICIONE("SC7",1,XFILIAL("SC7")+cNum,"C7_XARQ")

@ 0114,0020 Say  "Planilha de Equalizacao (caminho + arquivo)"  COLORS 0, 16777215 PIXEL
@ 0122,0020 MSGET oAnexCham1 VAR cAnexCham1 Picture "@S60" Pixel F3 "DIR" Size 300, 010 COLORS 0, 16777215 PIXEL                //Size 150, 010 F3 'DIR' Picture "@S60" WHEN .T.

@ 0122,0330 BUTTON '&Ver.'         			   Size 20, 10 action(zVisArq()) of _oDlgAnalit Pixel 
@ 0122,0360 BUTTON 'V&incular Arquivo a OC'    Size 70, 10 action(zVincArq()) of _oDlgAnalit Pixel 

return

/***************************************************/
/** PROVISOES DE CONTRATO RELACIONADOS AO PEDIDO   */
/***************************************************/

static function zProvCPIC()

	oGetDbAnalit := MsGetDb():New(xPosObj[1,1],xPosObj[1,2],xPosObj[1,3]-30,xPosObj[1,4], 2, ;
	"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1",,,,oFolder1:aDialogs[1])

	// Monta aHeader do TRB9
		aadd(aHeader, {" Origem"	,"PPTIPO"		,"",10,0,"","","C","TRB9","R"})
		aadd(aHeader, {"Data Mov."	,"PPDTMOV"		,"",08,0,"","","D","TRB9","R"})
		aadd(aHeader, {"Docto."		,"PPDOCTO"		,"",15,0,"","","C","TRB9","R"})
		aadd(aHeader, {"Tipo."		,"PPTPDOC"		,"",03,0,"","","C","TRB9","R"})

		aadd(aHeader, {"Valor R$"	,"PPVLRDC"		,"@E 999,999,999.99",15,2,"","","N","TRB9","R"})
		aadd(aHeader, {"Valor "		,"PPVLRDC2"		,"@E 999,999,999.99",15,2,"","","N","TRB9","R"})
		aadd(aHeader, {"Natureza"	,"PNATURE"		,"",13,0,"","","C","TRB9","R"})
		aadd(aHeader, {"Moeda "		,"PPMOEDA"		,"@E 99",02,0,"","","N","TRB9","R"})
		aadd(aHeader, {"Taxa Moeda"	,"PPTXMOE"		,"@E 999,999,999.9999",15,4,"","","N","TRB9","R"})

		aadd(aHeader, {"Descricao"	,"PPBENEF"		,"",20,0,"","","C","TRB9","R"})
		aadd(aHeader, {"Historico"	,"PPHIST"		,"",20,0,"","","C","TRB9","R"})
		aadd(aHeader, {"Contrato"	,"PPICTA"		,"",13,0,"","","C","TRB9","R"})
		aadd(aHeader, {"Loja"		,"PPLOJA"		,"",02,0,"","","C","TRB9","R"})
		aadd(aHeader, {"Fornecedor"	,"PPFORNE"		,"",10,0,"","","C","TRB9","R"})

	_oGetDbAnalit2 := MsGetDb():New(xPosObj[1,1],xPosObj[1,2],xPosObj[1,3]-30,xPosObj[1,4], 2, ;
	"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB9",,,,oFolder1:aDialogs[2])

	//@ xPosObj5[2,1],xPosObj5[1,2] Say  "Custo de Contrato(s)  " COLORS 0, 16777215 OF oFolder1:aDialogs[3] Pixel
	//@ xPosObj[2,1],xPosObj[1,2] Say  "Controle de Provisoes - Contas a Pagar  " COLORS 0, 16777215 OF oFolder1:aDialogs[2] Pixel
	@ 0005, 0005 BUTTON '&Excluir Provisao'         Size 80, 20 action(zExclSE2())  OF oFolder1:aDialogs[2] Pixel
	@ 0005, 0090 Say  "* De um clique duplo no titulo para alteracao.  "  COLORS 0, 16777215 OF oFolder1:aDialogs[2] Pixel

	_oGetDbAnalit2:oBrowse:BlDblClick := {|| zEditSE2()}

return

/***************************************************/
/** CUSTOS DE CONTRATO							   */
/***************************************************/

static function zCustIC()
	_
aadd(aHeader, {" Item"		,"CITEM"		,"",02,0,"","","C","TRB3","R"})
aadd(aHeader, {" Descricao"	,"CDESCRI"		,"",30,0,"","","C","TRB3","R"})
aadd(aHeader, {" Valor "	,"CVALOR"		,"@E 999,999,999.99",15,2,"","","N","TRB3","R"})
aadd(aHeader, {" Contrato "	,"CITEMIC"		,"",13,0,"","","C","TRB3","R"})
aadd(aHeader, {" Tipo Custo","CTIPCUSTO"	,"",06,0,"","","C","TRB3","R"})

_oGetDbAnalit5 := MsGetDb():New(xPosObj[1,1]-20,xPosObj[1,2],xPosObj[1,3]-30,xPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB3",,,,oFolder1:aDialogs[3])


return

/*****************************************************/
static function xRejeitar() 


Static _oDlg


local cGrup := ""
Private oMotivo
Private cMotivo := Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XREJEIT")


	
	PswOrder(1)
	If PswSeek(RetCodUsr(), .T. )
		cGrup := alltrim(PSWRET()[1][12])
	endif

	if cGrup == "Diretoria"

 DEFINE MSDIALOG _oDlg TITLE "Rejeitar" FROM 000, 000  TO 380, 1000 COLORS 0, 16777215 PIXEL

oGroup1:= TGroup():New(0002,0002,0160,0500,'Motivo',_oDlg,,,.T.)

@ 0010,0005 GET oMotivo VAR cMotivo MEMO  Size 486, 142 COLORS 0, 16777215 PIXEL   

 //   if Empty(alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST"))) .AND. Empty(alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XNOTAS")))

@ 0165 , 0180 BUTTON '&Ok'            	  Size 050, 0020 action(xRejMot(),_oDlg:End()) of _oDlg Pixel    
@ 0165 , 0240 BUTTON '&Fechar'            Size 050, 0020 action(_oDlg:End()) of _oDlg Pixel     
    
ACTIVATE MSDIALOG _oDlg CENTERED

	else
		MsgInfo("Recurso não disponivel.", "Westech")
	endif
  
return

/*****************************************************/
static function xRejMot() 

		dbSelectArea("SC7")
		SC7->( dbSetOrder(1))
		SC7->(dbgotop())
				
		If SC7->( dbSeek(xFilial("SC7")+cNum) ) // == .F. .OR. Empty(cNum)
					
			While SC7->(!eof())
					
			if cNum == alltrim(SC7->C7_NUM)
				RecLock("SC7",.F.)			
				SC7->C7_XREJEIT	:=  cMotivo
				MsUnlock()  
				
			endif
			SC7->(dbskip())
			enddo
			u_zEvRejOC()
		endif

return

/*
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada, para visualização do arquivo anexado e salvo º±±
±±º          ³no servidor   									          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function zVisArq(CCodigo,cParametro)

Local cArq :=""
Local cArq1:=""
Local lRet:=.T.

cArq := AllTrim(cAnexCham1)
lRet:=FILE(cArq) // Verifica no diretório Desenhos Técnicos do servidor se existe o arquivo buscado.pdf
If lRet
//	If	MAKEDIR('C:\TEMP')!= 0
//		Alert("Impossivel a Criação da Pasta C:\TEMP em Sua Maquina Local, Verifique !!!")
//		Return .f.
//	EndIf

	//pega o caminho do arquivo
//	cArq :=cParametro+"\"+cCodigo+".pdf"
	//copia o arquivo para a pasta temp no remote
	//Limpa a pasta temporaria no remote
//	Ferase('C:\TEMP\'+cCodigo+".pdf")
//	__COPYFILE(cParametro+"\"+cCodigo+".pdf",'C:\TEMP\'+cCodigo+".pdf")
//	CpyS2T(cParametro+"\"+cCodigo+".pdf", 'C:\TEMP\', .T.)
	shellExecute( "Open", cArq, " /k dir", "C:\", 1 ) //executa o programa para leitura do arquivo copiado
Else   
	Alert("Atencao Arquivo " + cArq + " Não Localizado !!!")
//	If Msgyesno("Não há nenhum documento!,Deseja Anexar?") //se não encontrar o arquivo no diretório, informa o usuário
//		U_UPPPDF(cCodigo,cParametro)
//	Else  && Bruno Abrigo em 19\03\2012
//		Return
//	EndIf
EndIf

Return lRet


/*
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada, para visualização do arquivo anexado e salvo º±±
±±º          ³no servidor   									          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function zVincArq(CCodigo,cParametro)

Local cArq :=""
Local cArq1:=""
Local lRet:=.T.

cArq := AllTrim(cAnexCham1)
lRet:=FILE(cArq) // Verifica no diretório Desenhos Técnicos do servidor se existe o arquivo buscado.pdf
If lRet
	dbSelectArea("SC7")
	SC7->( dbSetOrder(1))
	SC7->(dbgotop())
			
	If SC7->( dbSeek(xFilial("SC7")+cNum) ) // == .F. .OR. Empty(cNum)
				
		While SC7->(!eof())
				
		if cNum == alltrim(SC7->C7_NUM)
			RecLock("SC7",.F.)			
			SC7->C7_XARQ	:=  cArq
			MsUnlock()  
			
		endif
		SC7->(dbskip())
		enddo
		MsgInfo("Arquivo vinculado com sucesso.", "Westech")
	endif
	
Else   
	Alert("Atencao Arquivo " + cArq + " Não Localizado !!!")

EndIf

Return lRet

/******************************************************/

static function xNotas()

Local oButton1
Local oButton2
Local _nOpc := 0
Static _oDlg

if ! EMPTY(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XNOTAS"))
	
	msginfo ( Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XNOTAS"), "Notas O.C." )

else	
  DEFINE MSDIALOG _oDlg TITLE "Notas" FROM 000, 000  TO 380, 1000 COLORS 0, 16777215 PIXEL

  	oGroup1:= TGroup():New(0002,0002,0160,0500,'Notas',_oDlg,,,.T.)
    if Empty(alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST"))) .AND. Empty(alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XNOTAS")))
	    @ 0010, 0006 SAY "As Condicoes Gerais de Compras - Anexo 3 - PQ-90-0784 revisao 05 - sao parte integrante desta Ordem de compra: "   COLORS 0, 16777215 PIXEL
	    @ 0020, 0006 SAY "A Ordem de Compra e as Condicoes Gerais de Compra deverao ser assinadas e devolvidas em ate tres dias. A partir deste prazo serao considerados aprovadas."    COLORS 0, 16777215 PIXEL
	    @ 0030, 0006 SAY "Nao serao aceitas notas fiscais de recebimento de materiais sem que nela constem numero da Ordem de Compra."  COLORS 0, 16777215 PIXEL
	    @ 0040, 0006 SAY "A Westech se reserva o direito de efetuar testes na fabrica do fornecedor antes da liberacao para entrega."  COLORS 0, 16777215 PIXEL
	    @ 0050, 0006 SAY "A penalidade por atraso de entrega sera de 0,3% ao dia com teto maximo de 10%. Os valores correspondente serao glosados do pagamento a ser feito."  COLORS 0, 16777215 PIXEL
	    @ 0060, 0006 SAY "Os preco informados incluem ICMS, PIS e COFINS."  COLORS 0, 16777215 PIXEL
	    @ 0070, 0006 SAY "A Westech nao aceita emissao de boletos para pagamentos, bem como, nao aceita negociacao de duplicata com terceiros."   COLORS 0, 16777215 PIXEL
	    @ 0080, 0006 SAY "Os pagamentos serao feitos atraves de deposito bancario."   COLORS 0, 16777215 PIXEL
	    @ 0090, 0006 SAY "Material destinado a industrializacao."  COLORS 0, 16777215 PIXEL
	    @ 0100, 0006 SAY "Enviar certificado de qualidade do produto anexado a nota fiscal."   COLORS 0, 16777215 PIXEL
	elseIF !Empty(alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")))
		@ 0010, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTAL1"))      COLORS 0, 16777215 PIXEL
		@ 0020, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTAL2"))      COLORS 0, 16777215 PIXEL
		@ 0030, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTAL3"))      COLORS 0, 16777215 PIXEL
		@ 0040, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTAL4"))      COLORS 0, 16777215 PIXEL
		@ 0050, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTAL5"))      COLORS 0, 16777215 PIXEL
		@ 0060, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTAL6"))      COLORS 0, 16777215 PIXEL
		@ 0070, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTAL7"))      COLORS 0, 16777215 PIXEL
		@ 0080, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTAL8"))      COLORS 0, 16777215 PIXEL
		@ 0090, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTAL9"))      COLORS 0, 16777215 PIXEL
		@ 0100, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTA10"))      COLORS 0, 16777215 PIXEL
		@ 0110, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTA11"))      COLORS 0, 16777215 PIXEL
		@ 0120, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTA12"))      COLORS 0, 16777215 PIXEL
		@ 0130, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTA13"))      COLORS 0, 16777215 PIXEL
		@ 0140, 0006 SAY alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")),"M4_XNOTA14"))      COLORS 0, 16777215 PIXEL
	/*ELSE //IF //!Empty(alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XNOTAS")))
			///oPrint:Say  (1410,0070,Alltrim(cXNotas),oFont7a)

			nLin := 10
			nLinhas := MLCount(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XNOTAS"),200)
			For nXi:= 1 To 18
			
			        cTxtLinha := MemoLine(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XNOTAS"),200,nXi)
			       
			        msginfo ( cTxtLinha )
			        
			        If ! Empty(cTxtLinha)
			              //oPrint:Say(nLin+=40,0006,(cTxtLinha),oFont7a)
			              @ nLin+=10, 0006 SAY cTxtLinha  COLORS 0, 16777215 PIXEL
			        EndIf
			        			       
			Next nXi	
			*/
	endif
   
    @ 0165 , 0240 BUTTON '&Fechar'            Size 050, 0020 action(_oDlg:End()) of _oDlg Pixel     
    
  ACTIVATE MSDIALOG _oDlg CENTERED
  
 endif

Return 

/******************************************************/

static function xEntrega()

Local oButton1
Local oButton2
Local cCodigo
Local _nOpc := 0
Static _oDlg

  DEFINE MSDIALOG _oDlg TITLE "Entrega" FROM 000, 000  TO 175, 360 COLORS 0, 16777215 PIXEL //380, 1000

  	oGroup1:= TGroup():New(0002,0002,0060,0180,'Entrega',_oDlg,,,.T.)
    if Empty(alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST")))  
	    @ 0010, 0006 SAY "Westech Equipamentos Idustriais "   COLORS 0, 16777215 PIXEL
	    @ 0020, 0006 SAY "Rua Marques de Paranagua, 360"    COLORS 0, 16777215 PIXEL
	    @ 0030, 0006 SAY "Consolacao = Sao Paulo - SP - 01303-050"  COLORS 0, 16777215 PIXEL
	    
	else
		cCODIGO  := SUBSTR(alltrim(Posicione("SM4",1,xFilial("SM4") + alltrim(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_MSG")),"M4_FORMULA")),2,6)
		@ 0010, 0006 SAY alltrim(Posicione("SA2",1,xFilial("SA2") + cCODIGO,"A2_NREDUZ"))      COLORS 0, 16777215 PIXEL
		@ 0020, 0006 SAY alltrim(Posicione("SA2",1,xFilial("SA2") + cCODIGO,"A2_END"))      COLORS 0, 16777215 PIXEL
		@ 0030, 0006 SAY alltrim(Posicione("SA2",1,xFilial("SA2") + cCODIGO,"A2_BAIRRO")) + " - " + ;
		      			 alltrim(Posicione("SA2",1,xFilial("SA2") + cCODIGO,"A2_EST")) + " - " + ;
		      			 alltrim(Posicione("SA2",1,xFilial("SA2") + cCODIGO,"A2_MUN")) + " - " + ;
		      			 alltrim(Posicione("SA2",1,xFilial("SA2") + cCODIGO,"A2_CEP")) COLORS 0, 16777215 PIXEL
		@ 0040, 0006 SAY alltrim(Posicione("SA2",1,xFilial("SA2") + cCODIGO,"A2_PAIS"))     COLORS 0, 16777215 PIXEL
		
	endif
   
    @ 0065 , 0065  BUTTON '&Fechar'            Size 050, 0020 action(_oDlg:End()) of _oDlg Pixel     
    
  ACTIVATE MSDIALOG _oDlg CENTERED

Return 

static function zValidar()

	local _cQuery2 	:= ""
	local _cQuery4 	:= ""
	local cFor 		:= ""
	local nTotPCPR 	:= 0
	local nTotPTOT 	:= 0
	local nPlnCPR	:= 0
	local nPlnTot	:= 0
	local nEmpCPR	:= 0
	local nEmpTot	:= 0
	private _cItemCta 	:= ''
	
	TRB1->(dbgotop())

/*
	DbSelectArea("TRB9")
	TRB9->(dbgotop())
	zap*/

	// Analisar contratos pedido de compra ativo

		_cQuery4 := " SELECT C7_NUM, C7_ITEMCTA "
		_cQuery4 += "  FROM SC7010 "
		_cQuery4 += "  WHERE D_E_L_E_T_ <> '*' AND C7_NUM = '" + cNum + "' "
		_cQuery4 += "  GROUP BY C7_NUM, C7_ITEMCTA ORDER BY 1 "

	//AND C7_XCTRVB <> ''

		IF Select("_cQuery4") <> 0
			DbSelectArea("_cQuery4")
			DbCloseArea()
		ENDIF

		//crio o novo alias
		TCQUERY _cQuery4 NEW ALIAS "QUERY4"

		dbSelectArea("QUERY4")
		QUERY4->(dbGoTop())

		while QUERY4->(!eof())

			cItemCta	:= QUERY4->C7_ITEMCTA
			
			dbSelectArea("TRB9X")
			dbGoTop()
			While TRB9X->( ! EOF() )
				if ALLTRIM(TRB9X->XPTIPO) = "PROVISAO" .AND. 'TRB9X->XPICTA = cItemCta .AND. !TRB9X->XNATURE $ ("6.22.00/6.21.00/COMISSOES") 
					nTotPCPR	+= TRB9X->XPVLRDC // total custo de producao
				endif
				if TRB9X->XPICTA = cItemCta 
					nTotPTOT	+= TRB9X->XPVLRDC // total custo de total
				endif
				TRB9X->(dbskip())
			enddo

			dbSelectArea("TRB3Z")
			dbGoTop()
			While TRB3Z->( ! EOF() )
				if TRB3Z->ZITEMIC = cItemCta .AND. TRB3Z->ZTIPCUSTO = 'PLNPRD'
					nPlnCPR	:= TRB3Z->ZVALOR // total custo de producao
				endif
				if TRB3Z->ZITEMIC = cItemCta .AND. TRB3Z->ZTIPCUSTO = 'PLNTOT'
					nPlnTot	:= TRB3Z->ZVALOR // total custo de total
				endif
				TRB3Z->(dbskip())
			enddo

			dbSelectArea("TRB3Z")
			dbGoTop()
			While TRB3Z->( ! EOF() )
				if TRB3Z->ZITEMIC = cItemCta .AND. TRB3Z->ZTIPCUSTO = 'EMPPRD'
					nEmpCPR	:= TRB3Z->ZVALOR // total custo de producao
				endif
				if TRB3->CITEMIC = cItemCta .AND. TRB3->CTIPCUSTO = 'EMPTOT'
					nEmpTot	:= TRB3Z->ZVALOR // total custo de total
				endif
				TRB3Z->(dbskip())
			enddo

			/*
			if nTotPTOT > 0
				if (nEmpCPR+nTotPCPR) > nPlnCPR
					MsgAlert("Custo de Producao Empenhado + Provisoes excedem Custo de Producao Planejado. Verifique cadastro de Provisoes." + CHR(13)+CHR(10) + ;
					"Aprovacao sera cancelada." + CHR(13)+CHR(10) + CHR(13)+CHR(10) + ;
					"Custo Producao Planejado " + cItemCta  + ": " + cValTochar(Transform(nPlnCPR,"@E 999,999,999.99")) + CHR(13)+CHR(10) + ;
					"Custo Producao Empenhado " + cItemCta  + ": " + cValTochar(Transform(nEmpCPR,"@E 999,999,999.99")) + CHR(13)+CHR(10) + ;
					"Excedente Provisoes " + cItemCta  + ": " + cValTochar(Transform(nPlnCPR-(nEmpCPR+nTotPCPR),"@E 999,999,999.99")) )
					QUERY4->(dbclosearea())
					//return .F.
				endif
			endif*/
			nTotPCPR 	:= 0
			nTotPTOT 	:= 0
			nPlnCPR	:= 0
			nPlnTot	:= 0
			nEmpCPR	:= 0
			nEmpTot	:= 0
		
			QUERY4->(dbskip())
			
		enddo
	// fim do pedido de compra ativo

	if (nEmpCPR+nTotPCPR) <= nPlnCPR

		zAprvOCs()

	endif

	QUERY4->(dbclosearea())
	
return

static function zAprvOCs()

	local nX := TRB1->(RECCOUNT())
	local nI := 0
	local cGrup := ""
	
	private cXAPRN1 := ""
	private cXAPRN2 := ""
	private cXCTRVB := ""
	private cXCTRVB2 := ""
	
	//msginfo ( cDepart )
	
	TRB1->(dbgotop())

	PswOrder(1)
	If PswSeek(RetCodUsr(), .T. )
		cGrup := alltrim(PSWRET()[1][12])
	endif


	//*******************************************************************************************************

	if empty(AllTrim(cAnexCham1))

		If MsgYesNo("Planilha de equalizacao nao informada. Deseja continuar?", "Westech?")
	
		else
			msginfo("Operacao de aprovacao cancelada.")
			RETURN .F.
		endif
	endif

	//*******************************************************************************************************

If MsgYesNo("Confirma aprovacao?")	
		
	if cGrup == "Contratos" .AND.  !EMPTY(ALLTRIM(TRB1->XAPRN1))
		msginfo("Ordem de Compra ja aprovada pelo coordenador.")
	endif

	if cGrup == "Gerencia" .AND.  !EMPTY(ALLTRIM(TRB1->XAPRN3))
		msginfo("Ordem de Compra ja aprovada pela gerencia.")
	endif
	
	if cGrup == "Diretoria" .AND.  !EMPTY(ALLTRIM(TRB1->XAPRN2))
		msginfo("Ordem de Compra ja aprovada pela diretoria.")
	endif
	
	if cGrup == "Contratos"  .AND.  EMPTY(ALLTRIM(TRB1->XAPRN1))
		//TRB1->(dbgotop())
		while TRB1->(FieldGet(fieldpos(_aCpos[18]))) == cNum //TRB1->(!eof()) .AND. 
			RecLock("TRB1",.F.)
			if 	TRB1->NUM == cNum
				TRB1->XAPRN1 := RetCodUsr() //FieldPut(TRB1->(fieldpos(_aCpos[15])), AllTrim(RetCodUsr()) )
				cXAPRN1 :=  AllTrim(RetCodUsr())
				
				if ALLTRIM(TRB1->ITEMCONTA) == 'ADMINISTRACAO'
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "3"  )
					cXCTRVB := "3"
					
				elseif TRB2->TOTPCI < 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> 'ADMINISTRACAO'
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "4"  ) 
					cXCTRVB := "4"
					
				elseif TRB2->TOTPCI >= 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> 'ADMINISTRACAO' 
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "1"  ) 
					cXCTRVB := "1"
					
				elseif TRB2->TOTPCI >= 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> 'ADMINISTRACAO'
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "1"  ) 
					cXCTRVB := "1"
					
				endif  
			endif
			MsUnlock()
			TRB1->( dbSkip() )
			/*if TRB1->(!eof())
				TRB1->( dbSkip() )
			endif*/
		enddo
	
	elseif cGrup == "Contratos(E)"  //.AND.  empty(alltrim(TRB1->(FieldGet(fieldpos(_aCpos[15]))))) //EMPTY(ALLTRIM(TRB1->XAPRN1))
		//TRB1->(dbgotop())
		//msginfo(cNum)
		while  TRB1->(FieldGet(fieldpos(_aCpos[18]))) == cNum //TRB1->NUM == cNum //TRB1->(FieldGet(fieldpos(_aCpos[18]))) == cNum //TRB1->(!eof()) .AND. 
			RecLock("TRB1",.F.)
			
			if 	TRB1->NUM == cNum	
				FieldPut(TRB1->(fieldpos(_aCpos[15])), AllTrim(RetCodUsr()) ) //TRB1->XAPRN1 := RetCodUsr() 
				cXAPRN1 :=  AllTrim(RetCodUsr())
				
				if ALLTRIM(TRB1->ITEMCONTA) == 'ADMINISTRACAO'
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "3"  ) //TRB1->XCTRVB := "3" 
					cXCTRVB := "3"
					
				elseif TRB2->TOTPCI < 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> 'ADMINISTRACAO'
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "4"  ) //TRB1->XCTRVB := "4" 
					cXCTRVB := "4"
					
				elseif TRB2->TOTPCI >= 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> 'ADMINISTRACAO' 
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "2"  )  //TRB1->XCTRVB := "2" 
					cXCTRVB := "2"
					
				elseif TRB2->TOTPCI >= 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> 'ADMINISTRACAO'
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "1"  ) //TRB1->XCTRVB := "1"
					cXCTRVB := "1"
					
				endif  
			endif
			MsUnlock()
			TRB1->( dbSkip() )
			/*if TRB1->(!eof())
				TRB1->( dbSkip() )
			endif*/
		enddo

	elseif cGrup == "Gerencia"  //.AND.  empty(alltrim(TRB1->(FieldGet(fieldpos(_aCpos[15]))))) //EMPTY(ALLTRIM(TRB1->XAPRN1))
		//TRB1->(dbgotop())
		//msginfo(cNum)
		while  TRB1->(FieldGet(fieldpos(_aCpos[18]))) == cNum //TRB1->NUM == cNum //TRB1->(FieldGet(fieldpos(_aCpos[18]))) == cNum //TRB1->(!eof()) .AND. 
			RecLock("TRB1",.F.)
			
			if 	TRB1->NUM == cNum	
				FieldPut(TRB1->(fieldpos(_aCpos[19])), AllTrim(RetCodUsr()) ) //TRB1->XAPRN1 := RetCodUsr() 
				cXAPRN3 :=  AllTrim(RetCodUsr())
				
				if ALLTRIM(TRB1->ITEMCONTA) == 'ADMINISTRACAO'
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "3"  ) //TRB1->XCTRVB := "3" 
					cXCTRVB := "3"
										
				elseif TRB2->TOTPCI >= 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> 'ADMINISTRACAO' 
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "2"  )  //TRB1->XCTRVB := "2" 
					cXCTRVB := "2"
					
				elseif TRB2->TOTPCI >= 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> 'ADMINISTRACAO'
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "1"  ) //TRB1->XCTRVB := "1"
					cXCTRVB := "1"
					
				endif  
			endif
			MsUnlock()
			TRB1->( dbSkip() )
			/*if TRB1->(!eof())
				TRB1->( dbSkip() )
			endif*/
		enddo
		
	elseif  cGrup == "Diretoria" //.AND.  empty(alltrim(TRB1->(FieldGet(fieldpos(_aCpos[16])))))
		
		while TRB1->(FieldGet(fieldpos(_aCpos[18]))) == cNum //TRB1->(FieldGet(fieldpos(_aCpos[18]))) == cNum //TRB1->(!eof()) .AND. 
			//msginfo( cGrup)
			RecLock("TRB1",.F.)
			if 	TRB1->NUM == cNum

				FieldPut(TRB1->(fieldpos(_aCpos[16])), AllTrim(RetCodUsr()) )
				cXAPRN2 :=  AllTrim(RetCodUsr())
				cXCTRVB2 := "4"

				if ALLTRIM(TRB1->ITEMCONTA) == 'ADMINISTRACAO'
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "4"  )
					cXCTRVB2 := "4"
					
				elseif  ALLTRIM(TRB1->ITEMCONTA) <> 'ADMINISTRACAO' //TRB1->TOTPCI < 1500 .AND.
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "4"  ) 
					cXCTRVB2 := "4"
				
				elseif  ALLTRIM(TRB1->ITEMCONTA) <> 'ADMINISTRACAO' .AND. EMPTY(TRB1->XAPRN1) //TRB1->TOTPCI > 1500 .AND.
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "4"  ) 
					cXCTRVB2 := "4"
					
				elseif ALLTRIM(TRB1->ITEMCONTA) <> 'ADMINISTRACAO'  //TRB1->TOTPCI >= 1500 .AND.
					FieldPut(TRB1->(fieldpos(_aCpos[17])) ,  "4"  ) 
					cXCTRVB2 := "4"
				
				endif  

				//msginfo(cXCTRVB2)
			endif
			MsUnlock()
			TRB1->( dbSkip() )
			/*if TRB1->(!eof())
				TRB1->( dbSkip() )
			endif*/
		enddo
	
	endif
	
	Close(_oDlgAnalit)
	
	While TRB2->NUM == cNum
	
	//if TRB2->(FieldGet(fieldpos(_aCpos[1]))) == cNum
	if TRB2->NUM == cNum
			RecLock("TRB2",.F.)
				//FieldPut(TRB2->(fieldpos(_aCpos[13])) , "4" )
				
				if cGrup == "Contratos" .AND.  empty(alltrim(TRB1->(FieldGet(fieldpos(_aCpos[14])))))//EMPTY(ALLTRIM(TRB2->XAPRN1))// .OR. TRB1->NUM == cNum .AND. AllTrim(RetCodUsr()) == "000046"
					TRB2->XAPRN1 := cXAPRN1
					TRB2->XAPRN1D := AllTrim(UsrFullName(alltrim(cXAPRN1)))
					TRB2->XCTRVB := cXCTRVB
				
					if TRB2->XCTRVB == "4"
						TRB2->DESCR := "Aprovado"
					
					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1)) ;
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) .AND. !SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador / Diretoria"
					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1))  ;
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. !EMPTY(ALLTRIM(TRB2->XAPRN2)) .AND. !SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador "
					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. !SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Diretoria "
					
					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1)) .AND. EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador / Gerencia / Diretoria"

					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. !EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador / Gerencia "
					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Gerencia / Diretoria "
					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. !EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Gerencia"
					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. !EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Diretoria"

					elseif TRB2->TOTPCI <= 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1))
						TRB2->DESCR := "Coordenador "
					elseif TRB2->TOTPCI <= 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))
						TRB2->DESCR := "Aprovado "

					elseif ALLTRIM(TRB2->ITEMCONTA) == "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) //.AND. QUERY->C7_XCTRVB <> "4"
						TRB2->DESCR := "Diretoria "
					endif
					
					If SC7->( dbSeek(xFilial("SC7")+cNum) )
								 
				           While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cNum
				               
								RecLock("SC7",.F.)
								if SC7->C7_NUM == cNum
							    	//msginfo(_cDepart + cXAPRN1)
							    	SC7->C7_XAPRN1 := cXAPRN1
							    	SC7->C7_XCTRVB := cXCTRVB
							    endif
							    MsUnlock()  
						
						SC7->( dbSkip() )
		        
						endDo

				   EndIf
					
				elseif cGrup == "Contratos(E)" .AND.  EMPTY(ALLTRIM(TRB2->XAPRN1))// .OR. TRB1->NUM == cNum .AND. AllTrim(RetCodUsr()) == "000046"
					TRB2->XAPRN1 := cXAPRN1
					TRB2->XAPRN1D := AllTrim(UsrFullName(alltrim(cXAPRN1)))
					TRB2->XCTRVB := cXCTRVB
				
					if TRB2->XCTRVB == "4"
						TRB2->DESCR := "Aprovado"
					
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1)) .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) ;
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. !SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador / Diretoria"
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. !EMPTY(ALLTRIM(TRB2->XAPRN2)) ;
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. !SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador "
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) ;
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. !SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Diretoria "

					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1)) .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) ;
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador / Gerencia / Diretoria"
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. !EMPTY(ALLTRIM(TRB2->XAPRN2)) ;
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador / Gerencia "
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) ;
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Gerencia / Diretoria "


					elseif TRB2->TOTPCI <= 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1))
						TRB2->DESCR := "Coordenador "
					elseif TRB2->TOTPCI <= 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))
						TRB2->DESCR := "Aprovado "
					elseif ALLTRIM(TRB2->ITEMCONTA) == "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) //.AND. QUERY->C7_XCTRVB <> "4"
						TRB2->DESCR := "Diretoria "
					endif
					
					dbSelectArea("SC7")
					dbGoTop()
					dbSetOrder(1)
							
					If SC7->( dbSeek(xFilial("SC7")+cNum) )
								 
				           While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cNum
				               
								RecLock("SC7",.F.)
								if SC7->C7_NUM == cNum
							    	//msginfo(_cDepart + cXAPRN1)
							    	SC7->C7_XAPRN1 := cXAPRN1
							    	SC7->C7_XCTRVB := cXCTRVB
							    endif
							    MsUnlock()  
						
						SC7->( dbSkip() )
		        
						endDo

				   EndIf
				
				elseif cGrup == "Gerencia" .AND.  EMPTY(ALLTRIM(TRB2->XAPRN1))// .OR. TRB1->NUM == cNum .AND. AllTrim(RetCodUsr()) == "000046"
					TRB2->XAPRN3 := cXAPRN3
					TRB2->XAPRN3D := AllTrim(UsrFullName(alltrim(cXAPRN3)))
					TRB2->XCTRVB := cXCTRVB
				
					if TRB2->XCTRVB == "4"
						TRB2->DESCR := "Aprovado"
					
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1)) .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) ;
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador / Gerencia / Diretoria"
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. !EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador / Gerencia "
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Gerencia / Diretoria "
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Gerencia / Diretoria "
					elseif TRB2->TOTPCI <= 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1)) .AND. !EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. !EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador "
					elseif TRB2->TOTPCI <= 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1)).AND. !EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. !EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Aprovado "
					elseif ALLTRIM(TRB2->ITEMCONTA) == "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) //.AND. QUERY->C7_XCTRVB <> "4"
						TRB2->DESCR := "Diretoria "
					endif
					
					dbSelectArea("SC7")
					dbGoTop()
					dbSetOrder(1)
							
					If SC7->( dbSeek(xFilial("SC7")+cNum) )
								 
				           While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cNum
				               
								RecLock("SC7",.F.)
								if SC7->C7_NUM == cNum
							    	//msginfo(_cDepart + cXAPRN1)
							    	SC7->C7_XAPRN3 := cXAPRN3
							    	SC7->C7_XCTRVB := cXCTRVB
							    endif
							    MsUnlock()  
						
						SC7->( dbSkip() )
		        
						endDo

				   EndIf
					
				elseif cGrup == "Diretoria" 
					TRB2->XAPRN2 := cXAPRN2
					TRB2->XAPRN2D := AllTrim(UsrFullName(alltrim(cXAPRN2)))
					TRB2->XCTRVB := cXCTRVB2

					if TRB2->XCTRVB == "4"
						TRB2->DESCR := "Aprovado"
					
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1)) .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) ;
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador / Gerencia / Diretoria"
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. !EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador / Gerencia "
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Gerencia / Diretoria "
					elseif TRB2->TOTPCI > 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Gerencia / Diretoria "
					elseif TRB2->TOTPCI <= 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1)) .AND. !EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. !EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Coordenador "
					elseif TRB2->TOTPCI <= 1000 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1)).AND. !EMPTY(ALLTRIM(TRB2->XAPRN2));
							.AND. !EMPTY(ALLTRIM(TRB2->XAPRN3)) .AND. SUBSTR(TRB2->ITEMCONTA,1,2) $ "AT/PR"
						TRB2->DESCR := "Aprovado "
					elseif ALLTRIM(TRB2->ITEMCONTA) == "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) //.AND. QUERY->C7_XCTRVB <> "4"
						TRB2->DESCR := "Diretoria "
					endif
					
					/*if TRB2->(FieldGet(fieldpos(_aCpos[18]))) = "4" //TRB2->XCTRVB == "4"
						TRB2->DESCR := "Aprovado"
					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1)) .AND. EMPTY(ALLTRIM(TRB2->XAPRN2))
						TRB2->DESCR := "Requer Aprovacao do Coordenador e Diretoria"
					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. !EMPTY(ALLTRIM(TRB2->XAPRN2))
						TRB2->DESCR := "Requer Aprovacao do Coordenador "
					elseif TRB2->TOTPCI > 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))  .AND. EMPTY(ALLTRIM(TRB2->XAPRN2))
						RB2->DESCR := "Requer Aprovacao da Diretoria "
					elseif TRB2->TOTPCI <= 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN1))
						TRB2->DESCR := "Requer Aprovacao do Coordenador "
					elseif TRB2->TOTPCI <= 1500 .AND. ALLTRIM(TRB2->ITEMCONTA) <> "ADMINISTRACAO" .AND. !EMPTY(ALLTRIM(TRB2->XAPRN1))
						TRB2->DESCR := "Aprovado "
					elseif ALLTRIM(TRB2->ITEMCONTA) == "ADMINISTRACAO" .AND. EMPTY(ALLTRIM(TRB2->XAPRN2)) //.AND. QUERY->C7_XCTRVB <> "4"
						TRB2->DESCR := "Requer Aprovacao da Diretoria "
					
					endif*/
					
					If SC7->( dbSeek(xFilial("SC7")+cNum) )
								 
				           While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cNum
				               
								RecLock("SC7",.F.)
								if SC7->C7_NUM == cNum
							 		//msginfo(_cDepart + cXAPRN1)
							    	SC7->C7_XAPRN2 := cXAPRN2
							    	SC7->C7_XCTRVB := cXCTRVB2
							    endif
							    MsUnlock()  
						
						SC7->( dbSkip() )
		        
						endDo

				   EndIf
					
				endif
				
			MsUnlock() 
	endif
		
	TRB2->( dbSkip() )
	
	endDo
	//*****************************************************************
	TRB2->(DBGoBottom())
	TRB2->(dbgotop())
	GetdRefresh()

endif

zAPSC7()
	
//DbCloseArea("SC7")

return

static function zAPSC7()
	/*
	local cXAPRN1 := TRB2->XAPRN1
	local cXAPRN2 := TRB2->XAPRN2
	local cXCTRVB := TRB2->XCTRVB
	*/
	local cGrup := ""
	local nTotalCom := 0
	local cItemCT

	PswOrder(1)
	If PswSeek(RetCodUsr(), .T. )
		cGrup := alltrim(PSWRET()[1][12])
	endif

		//msginfo( cGrup)
		dbSelectArea("SC7")
		dbGoTop()
		dbSetOrder(1)
		If SC7->( dbSeek(xFilial("SC7")+cNum) )
						
				While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cNum
					
						RecLock("SC7",.F.)  
							if cGrup == "Contratos" .AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN1)) 
								//msginfo(_cDepart + cXAPRN1)
								SC7->C7_XAPRN1 := RetCodUsr() // cXAPRN1
								SC7->C7_XCTRVB := "2" //cXCTRVB
							elseif cGrup == "Contratos(E)" .AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN1)) 
								//msginfo(_cDepart + cXAPRN1)
								SC7->C7_XAPRN1 := RetCodUsr()
								SC7->C7_XCTRVB := "2"	
							elseif cGrup == "Gerencia" .AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN3)) 
								//msginfo(_cDepart + cXAPRN1)
								SC7->C7_XAPRN3 := RetCodUsr()
								SC7->C7_XCTRVB := "2"	
							elseif cGrup == "Diretoria" .AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN2)) ;
							.OR. AllTrim(RetCodUsr()) == "000063" .AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN2)) ;
							.OR. AllTrim(RetCodUsr()) == "000016" .AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN2)) ;
							.OR. AllTrim(RetCodUsr()) == "000077" .AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN2)) //;
							//.OR. AllTrim(RetCodUsr()) == "000046" .AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN2))
								//msginfo(_cDepart + cXAPRN1)
								SC7->C7_XAPRN2 := RetCodUsr() //cXAPRN2
								SC7->C7_XCTRVB := "4"
							endif
						MsUnlock()  
						cItemCT := SC7->C7_ITEMCTA
						nTotalCom	+= (SC7->C7_TOTAL + SC7->C7_VALIPI + SC7->C7_SEGURO + SC7->C7_DESPESA + SC7->C7_VALFRE) - (SC7->C7_VLDESC + SC7->C7_ICMSRET)  // Totalizando Valor do pedido de compras
						SC7->( dbSkip() )
				
				endDo

				if cGrup == "Contratos" .AND. !SUBSTR(cItemCT,1,2) $ "AT/PR" // .AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN1)) 
								//msginfo(cGrup + " " + SUBSTR(cItemCT,1,2))
								u_zEnviaAprov()
								if nTotalCom > 1500
									u_zEvMailSCA()
								endif
				elseif cGrup == "Contratos" .AND. SUBSTR(cItemCT,1,2) $ "AT/PR" // .AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN1)) 
								//msginfo(cGrup + " " + SUBSTR(cItemCT,1,2))
								u_zEnviaAprov()
								if nTotalCom > 1500
									u_zEvMailGSC()
								endif
				elseif cGrup == "Contratos(E)" .AND. !SUBSTR(cItemCT,1,2) $ "AT/PR" //.AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN1)) 
								//msginfo(cGrup + " " + SUBSTR(cItemCT,1,2))
								u_zEnviaAprov()
								if nTotalCom > 1000
									u_zEvMailSCA()
								endif
				elseif cGrup == "Contratos(E)" .AND. SUBSTR(cItemCT,1,2) $ "AT/PR" //.AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN1)) 
								//msginfo(cGrup + " " + SUBSTR(cItemCT,1,2))
								u_zEnviaAprov()
								if nTotalCom > 1000
									u_zEvMailGSC()
								ENDIF
				elseif cGrup == "Gerencia" .AND. SUBSTR(cItemCT,1,2) $ "AT/PR" //.AND.  EMPTY(ALLTRIM(SC7->C7_XAPRN1)) 
								//msginfo(cGrup + " " + SUBSTR(cItemCT,1,2))
								u_zEnviaAprov()
								u_zEvMailGSC()
				elseif cGrup == "Diretoria"
								msginfo(cGrup + " " + SUBSTR(cItemCT,1,2))
								u_zEvMailDAP()	
				endif

			
		EndIf
	

	TRB2->(DBGoBottom())
	TRB2->(dbgotop())


return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½PFIN01REALï¿½Autor  Reginaldo Valerio						   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Processa PAGAMENTO planejado       		              ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

static function zProvJobs()

local _cQuery 		:= ""
local _cQuery2 		:= ""
Local _cFilSE2 		:= xFilial("SE2")
local cFor 			:= ""
local nTotPAG1 		:= 0
local nTotPAG2 		:= 0
private _cItemCta 	:= ''

DbSelectArea("TRB9")
TRB9->(dbgotop())
zap

DbSelectArea("TRB9X")
TRB9X->(dbgotop())
zap

SE2->(dbsetorder(1)) 

// Analisar contratos pedido de compra ativo

	_cQuery2 := " SELECT C7_NUM, C7_ITEMCTA "
	_cQuery2 += "  FROM SC7010 "
	_cQuery2 += "  WHERE D_E_L_E_T_ <> '*' AND C7_NUM = '" + cNum + "' "
	_cQuery2 += "  GROUP BY C7_NUM, C7_ITEMCTA ORDER BY 1 "

//AND C7_XCTRVB <> ''

	IF Select("_cQuery2") <> 0
		DbSelectArea("_cQuery2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery2 NEW ALIAS "QUERY2"

	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

//************************************************
	while QUERY2->(!eof())

		cItemCta	:= QUERY2->C7_ITEMCTA
		//msginfo(cItemCta)

		cFor 		:= "ALLTRIM(QUERY->E2_XXIC) = cItemCta .AND. ALLTRIM(QUERY->E2_TIPO) = 'PR' .AND. !cItemCta $ ('ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES')  "

		ChkFile("SE2",.F.,"QUERY") // Alias dos movimentos bancarios
		IndRegua("QUERY",CriaTrab(NIL,.F.),"E2_VENCREA",,cFor,"Selecionando Registros...")
		ProcRegua(QUERY->(reccount()))

		QUERY->(dbgotop())

		/************PEDIDO DE COMPRA POSICIONADO*****************/

			while QUERY->(!eof())

					RecLock("TRB9",.T.)
					
					//MsProcTxt("Processando registro: "+alltrim(QUERY->E2_NUM))
					//ProcessMessage()
					
					TRB9->PPTIPO	:= "Provisao"
					TRB9->PPDTMOV	:= QUERY->E2_VENCREA
					TRB9->PPDOCTO	:= QUERY->E2_NUM
					TRB9->PPTPDOC	:= QUERY->E2_TIPO

					TRB9->PPVLRDC	:= QUERY->E2_VLCRUZ
					TRB9->PPVLRDC2	:= QUERY->E2_VALOR
					TRB9->PNATURE	:= QUERY->E2_NATUREZ
					TRB9->PPMOEDA	:= QUERY->E2_MOEDA
					TRB9->PPTXMOE	:= QUERY->E2_TXMOEDA

					TRB9->PPBENEF	:= QUERY->E2_NOMFOR
					TRB9->PPHIST	:= QUERY->E2_HIST
					TRB9->PPICTA	:= QUERY->E2_XXIC
					TRB9->PPDTMOV2	:= QUERY->E2_VENCREA
					
					TRB9->PPFORNE	:= QUERY->E2_FORNECE
					TRB9->PPNFORN	:= QUERY->E2_NOMFOR
					TRB9->PPLOJA	:= QUERY->E2_LOJA
					TRB9->PPPREF	:= QUERY->E2_PREFIXO
					TRB9->PPNTIT	:= QUERY->E2_NUM
					TRB9->PPPARCEL	:= QUERY->E2_PARCELA
							
					nTotPAG1 +=  QUERY->E2_VLCRUZ
					nTotPAG2 +=  QUERY->E2_VALOR
							
					MsUnlock()
			
				QUERY->(dbskip())

			enddo

			QUERY2->(dbskip())
			if nTotPAG1 > 0 .AND. nTotPAG2 > 0
				RecLock("TRB9",.T.) 
					TRB9->PPTIPO	:= "TOTAL"
					TRB9->PPDTMOV2	:= ctod("31/12/2099")
					TRB9->PPVLRDC	:= nTotPAG1
					TRB9->PPVLRDC2	:= nTotPAG2
					TRB9->PPICTA	:= cItemCta
				MsUnlock()
			endif
	
		nTotPAG1 := 0
		nTotPAG2 := 0
		QUERY->(dbclosearea())
		//msginfo(cItemCta)
	enddo

//QUERY->(dbclosearea())
QUERY2->(dbclosearea())

return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½PFIN01REALï¿½Autor  Reginaldo Valerio						   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Processa PAGAMENTO planejado       		              ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

static function zXPrJobs()

local _cQuery := ""
local _cQuery2 := ""
Local _cFilSE2 := xFilial("SE2")
local cFor 		:= ""
local nTotPAG1 	:= 0
local nTotPAG2 	:= 0
private _cItemCta 	:= ''

DbSelectArea("TRB9X")
TRB9X->(dbgotop())
zap

SE2->(dbsetorder(1)) 

// Analisar contratos pedido de compra ativo

	_cQuery2 := " SELECT C7_NUM, C7_ITEMCTA "
	_cQuery2 += "  FROM SC7010 "
	_cQuery2 += "  WHERE D_E_L_E_T_ <> '*' AND C7_NUM = '" + cNum + "' "
	_cQuery2 += "  GROUP BY C7_NUM, C7_ITEMCTA ORDER BY 1 "

//AND C7_XCTRVB <> ''

	IF Select("_cQuery2") <> 0
		DbSelectArea("_cQuery2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery2 NEW ALIAS "QUERY2"

	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

//************************************************
	while QUERY2->(!eof())

		cItemCta	:= QUERY2->C7_ITEMCTA
		//msginfo(cItemCta)

		cFor 		:= "ALLTRIM(QUERY->E2_XXIC) = cItemCta .AND. ALLTRIM(QUERY->E2_TIPO) = 'PR' .AND. !cItemCta $ ('ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES')  "

		ChkFile("SE2",.F.,"QUERY") // Alias dos movimentos bancarios
		IndRegua("QUERY",CriaTrab(NIL,.F.),"E2_VENCREA",,cFor,"Selecionando Registros...")
		ProcRegua(QUERY->(reccount()))

		QUERY->(dbgotop())

		/************PEDIDO DE COMPRA POSICIONADO*****************/

			while QUERY->(!eof())

					RecLock("TRB9X",.T.)
					
					//MsProcTxt("Processando registro: "+alltrim(QUERY->E2_NUM))
					//ProcessMessage()
					
					TRB9X->XPTIPO	:= "Provisao"
					TRB9X->XPDTMOV	:= QUERY->E2_VENCREA
					TRB9X->XPDOCTO	:= QUERY->E2_NUM
					TRB9X->XPTPDOC	:= QUERY->E2_TIPO
					TRB9X->XPVLRDC	:= QUERY->E2_VLCRUZ
					TRB9X->XPVLRDC2	:= QUERY->E2_VALOR
					TRB9X->XNATURE	:= QUERY->E2_NATUREZ
					TRB9X->XPMOEDA	:= QUERY->E2_MOEDA
					TRB9X->XPTXMOE	:= QUERY->E2_TXMOEDA

					TRB9X->XPBENEF	:= QUERY->E2_NOMFOR
					TRB9X->XPHIST	:= QUERY->E2_HIST
					TRB9X->XPICTA	:= QUERY->E2_XXIC
					TRB9X->XPDTMOV2	:= QUERY->E2_VENCREA
					
					TRB9X->XPFORNE	:= QUERY->E2_FORNECE
					TRB9X->XPNFORN	:= QUERY->E2_NOMFOR
					TRB9X->XPLOJA	:= QUERY->E2_LOJA
					TRB9X->XPPREF	:= QUERY->E2_PREFIXO
					TRB9X->XPNTIT	:= QUERY->E2_NUM
					TRB9X->XPPARCEL	:= QUERY->E2_PARCELA
							
					nTotPAG1 +=  QUERY->E2_VLCRUZ
					nTotPAG2 +=  QUERY->E2_VALOR
							
					MsUnlock()
			
				QUERY->(dbskip())

			enddo

			QUERY2->(dbskip())
			if nTotPAG1 > 0 .AND. nTotPAG2 > 0
				RecLock("TRB9X",.T.) 
					TRB9X->XPTIPO	:= "TOTAL"
					TRB9X->XPDTMOV2	:= ctod("31/12/2099")
					TRB9X->XPVLRDC	:= nTotPAG1
					TRB9X->XPVLRDC2	:= nTotPAG2
					TRB9X->XPICTA	:= cItemCta
				MsUnlock()
			endif
	
		nTotPAG1 := 0
		nTotPAG2 := 0
		QUERY->(dbclosearea())
		//msginfo(cItemCta)
	enddo

//QUERY->(dbclosearea())
QUERY2->(dbclosearea())

return


/******************* Ediï¿½ï¿½o pagamento Planejado ************************/

Static Function zEditSE2()
    Local aArea       := GetArea()
    Local aAreaE2     := SE2->(GetArea())
    Local nOpcao      := 0
    Local cTitulo	  := alltrim(TRB9->PPNTIT)
    Local cClifor	  := alltrim(TRB9->PPFORNE)
    Local cLoja		  := alltrim(TRB9->PPLOJA)
    Local cParcela	  := alltrim(TRB9->PPPARCEL)
    Local dData		  := DTOS(TRB9->PPDTMOV)
    Local cConsSE2	  := cClifor+cTitulo+cParcela

    Private cCadastro 

		cCadastro := "Alteracao Contas a Pagar"

	    DbSelectArea("SE2")
	    SE2->(DbSetOrder(20)) //B1_FILIAL + B1_COD
	    	
		//if SE2->(DbSeek(xFilial("SE2")+cTitulo+cClifor) )
		if SE2->(DbSeek(xFilial("SE2")+TRB9->PPNTIT+TRB9->PPFORNE+dData+TRB9->PPLOJA) )
			nOpcao := zAltRegSE2()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")	
	        elseif nOpcao == 2
	           nOpcao := zAltRegSE2()   
	        EndIf
	    endif

    RestArea(aAreaE2)
    RestArea(aArea)
Return

/******************* Ediï¿½ï¿½o pagamento Planejado ************************/

static function zAltRegSE2()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= SE2->E2_NUM
Local oGet2
Local cGet2 	:= Posicione("SA2",1,xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA, "A2_NREDUZ")
Local oGet3
Local oFornece 	:= SE2->E2_FORNECE
Local oGet7 
Local oGet8 	:= SE2->E2_LOJA
Local dVencto 	:= SE2->E2_VENCREA
Local oGet5		:=  SE2->E2_TIPO
Local oGet6		:=  Posicione("SED",1,xFilial("SED") + ALLTRIM(SE2->E2_NATUREZ), "ED_XGRUPO")
Local oGet4
Local nValor 	:= SE2->E2_VALOR
Local oGet15
Local nValorRE 	:= SE2->E2_VLCRUZ
Local oGet16
Local nMoeda 	:= SE2->E2_MOEDA
Local oGet17
Local nTXMoeda 	:= SE2->E2_TXMOEDA
Local oGet9
Local cGet9 	:= SE2->E2_HIST
Local oGet10
Local cGet10	:= SE2->E2_TIPO
Local oGet11
Local cGet11 	:= SE2->E2_XXIC
Local oGet12
Local cGet12 	:= SE2->E2_NATUREZ
Local dEmissa	:= SE2->E2_EMISSAO
Local oGet13
Local dVenct 	:= SE2->E2_VENCTO
Local oGet14
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay7
local _cQuery 		:= ""
Local dData 		:= DDatabase
Local dData2		:= DDatabase
Local QUERY 		:= ""
Local QUERY2 		:= ""
Local QUERY3 		:= ""
Local nVlrMoeda		:= 1

Local _nOpc := 0
Static _oDlg

//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )

	_cQuerySM2 := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuerySM2") <> 0
		DbSelectArea("_cQuerySM2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuerySM2 NEW ALIAS "QUERYSM2"
	
	dbSelectArea("QUERYSM2")
	QUERYSM2->(dbGoTop())

//*************************

  DEFINE MSDIALOG _oDlg TITLE "Edicao Titulo Contas a Pagar" FROM 000, 000  TO 350, 498 COLORS 0, 16777215 PIXEL
  
  	oGroup1:= TGroup():New(0005,0005,0145,0245,'',_oDlg,,,.T.)
 
    @ 013, 010 SAY oSay1 PROMPT "Titulo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 010 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 062 SAY oSay10 PROMPT "Tipo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oGet10 VAR cGet10 When .F. SIZE 032, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 102 SAY oSay11 PROMPT "Contrato" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 102 MSGET oGet11 VAR cGet11 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 172 SAY oSay11 PROMPT "Natureza" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 172 MSGET oGet12 VAR cGet12 Picture "@!" Pixel F3 "SED" SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
 	@ 037, 010 SAY oSay7 PROMPT "Codigo" SIZE 032, 007  COLORS 0, 16777215 PIXEL
	@ 046, 010 MSGET oGet7 VAR oFornece Picture "@!" Pixel F3 "SA2" SIZE 048, 010  COLORS 0, 16777215 PIXEL
	   
    @ 037, 063 SAY oSay2 PROMPT "Fornecedor" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 046, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 180, 010  COLORS 0, 16777215 PIXEL
    
     /**************/
    @ 063, 010 SAY oSay13 PROMPT "Emissao" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 010 MSGET oGet13 VAR dEmissa SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 060 SAY oSay14 PROMPT "Vencimento" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 060 MSGET oGet14 VAR dVenct SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 110 SAY oSay3 PROMPT "Vencto Real" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 110 MSGET oGet3 VAR dVencto SIZE 044, 010  COLORS 0, 16777215 PIXEL
    /**************/  
	
    @ 087, 010 SAY oSay4 PROMPT "Valor R$" SIZE 038, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 010 MSGET oGet15 VAR nValorRE PICTURE PesqPict("SE2","E2_VLCRUZ") SIZE 060, 010  COLORS 0, 16777215 PIXEL

	@ 087, 080 SAY oSay4 PROMPT "Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 080 MSGET oGet16 VAR nMoeda PICTURE PesqPict("SE2","E2_MOEDA") Pixel F3 "SM2" SIZE 020, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 110 SAY oSay4 PROMPT "Valor" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 110 MSGET oGet4 VAR nValor  PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 180 SAY oSay4 PROMPT "Taxa Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 180 MSGET oGet17 VAR nTXMoeda When .F. PICTURE PesqPict("SE2","E2_TXMOEDA") SIZE 060, 010  COLORS 0, 16777215 PIXEL  
     
    @ 111, 010 SAY oSay9 PROMPT "Historico" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 122, 010 MSGET oGet9 VAR cGet9 When .T. SIZE 230, 010  COLORS 0, 16777215 PIXEL
    
    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 152, 079 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 039, 010  PIXEL
    @ 152, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 039, 010  PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

	if empty(oFornece) 
		msgstop("Informe codigo do Fornecedor.")
		_nOpc := 2
	endif
	
	if empty(cGet12) 
		msgstop("Informe Natureza.")
		_nOpc := 2
	endif

	if nValor = 0 .AND. nValorRE = 0 .AND. EMTPTY(nMoeda)
		msgstop("Informe valor do titulo.")
		_nOpc := 2
	endif

	if empty(cGet9) 
		msgstop("Informe Historico.")
		_nOpc := 2
	endif

	if dVencto < dVenct
		msgstop("Vencimento real nao pode menor que Vencimento.")
		_nOpc := 2
	endif

  If _nOpc = 1
  	Reclock("SE2",.F.)
  	//SE2->E2_VENCTO 	:= dVencto
  	SE2->E2_VENCREA 	:= DataValida(dVencto,.T.) //Proximo dia ï¿½til
  	SE2->E2_EMISSAO 	:= DataValida(dEmissa,.T.) //Proximo dia ï¿½til
  	SE2->E2_VENCTO 		:= DataValida(dVenct,.T.) //Proximo dia ï¿½til

	//************************************
	if nValor = 0 .OR. nValor > 0 .AND. nValorRE > 0 
		
		if nMoeda = 2
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERYSM2->(!eof())
						
						nTXMoeda := QUERYSM2->M2_MOEDA2
					
						if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERYSM2->M2_MOEDA2
							Exit
						else
							QUERYSM2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERYSM2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE * nTXMoeda
				SE2->E2_SALDO	:= nValorRE * nTXMoeda
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 3
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERYSM2->(!eof())
						
						nTXMoeda := QUERYSM2->M2_MOEDA3
					
						if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERYSM2->M2_MOEDA3
							Exit
						else
							QUERYSM2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERYSM2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE * nTXMoeda
				SE2->E2_SALDO	:= nValorRE * nTXMoeda
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 4
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERYSM2->(!eof())
						
						nTXMoeda := QUERYSM2->M2_MOEDA4
					
						if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERYSM2->M2_MOEDA4
							Exit
						else
							QUERYSM2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERYSM2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE * nTXMoeda
				SE2->E2_SALDO	:= nValorRE * nTXMoeda
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  

		else
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE 
				SE2->E2_SALDO	:= nValorRE 
				SE2->E2_MOEDA	:= 1
				SE2->E2_TXMOEDA	:= 0  
			
		endif

	endif

	if nValorRE = 0

		if nMoeda = 2
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERYSM2->(!eof())
						
						nTXMoeda := QUERYSM2->M2_MOEDA2
					
						if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERYSM2->M2_MOEDA2
							Exit
						else
							QUERYSM2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERYSM2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValor / nTXMoeda
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 3
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERYSM2->(!eof())
						
						nTXMoeda := QUERYSM2->M2_MOEDA3
					
						if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERYSM2->M2_MOEDA3
							Exit
						else
							QUERYSM2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERYSM2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValor / nTXMoeda
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 4
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERYSM2->(!eof())
						
						nTXMoeda := QUERYSM2->M2_MOEDA4
					
						if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERYSM2->M2_MOEDA4
							Exit
						else
							QUERYSM2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERYSM2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERYSM2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValor / nTXMoeda
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  

		else
				SE2->E2_VLCRUZ	:= nValor
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor 
				SE2->E2_MOEDA	:= 1
				SE2->E2_TXMOEDA	:= 0  
			
		endif

	endif

  	SE2->E2_HIST	:= cGet9
  	SE2->E2_NATUREZ	:= cGet12
  	if alltrim(oGet5) = "PR"
  		SE2->E2_FORNECE	:= alltrim(oFornece)
  		SE2->E2_NOMFOR	:= Posicione("SA2",1,xFilial("SA2") + oFornece, "A2_NREDUZ")
  		SE2->E2_LOJA	:= Posicione("SA2",1,xFilial("SA2") + oFornece, "A2_LOJA")
  	endif	
  	MsUnlock()
  
	DbSelectArea("TRB9")
	TRB9->(dbgotop())
	zap
	MSAguarde({||zProvJobs()},"Processando Contas a Pagar Planejado")
	TRB9->(DBGoBottom())
	TRB9->(dbgotop())
	GetdRefresh()

	DbSelectArea("TRB9X")
	TRB9X->(dbgotop())
	zap
	MSAguarde({||zXPrJobs()},"Processando Contas a Pagar Planejado")
	TRB9X->(DBGoBottom())
	TRB9X->(dbgotop())
	GetdRefresh()

  Endif

 QUERYSM2->(DbCloseArea())

Return _nOpc

/******************* Exclusao pagamento Planejado ************************/
Static Function zExclSE2()
    Local aArea       := GetArea()
    Local aAreaE2     := SE2->(GetArea())
    Local nOpcao      := 0
    Local cTitulo	  := alltrim(TRB9->PPNTIT)
    Local cClifor	  := alltrim(TRB9->PPFORNE)
    Local cLoja		  := alltrim(TRB9->PPLOJA)
    Local cParcela	  := alltrim(TRB9->PPPARCEL)
    Local dData		  := DTOS(TRB9->PPDTMOV)
    Local cConsSE2	  := cClifor+cTitulo+cParcela
    Private cCadastro 

		cCadastro := "Alteracao Contas a Pagar"

	    DbSelectArea("SE2")
	    SE2->(DbSetOrder(20)) //B1_FILIAL + B1_COD
	    	
		//if SE2->(DbSeek(xFilial("SE2")+cTitulo+cClifor) )
		if SE2->(DbSeek(xFilial("SE2")+TRB9->PPNTIT+TRB9->PPFORNE+dData+TRB9->PPLOJA) )
			nOpcao := zExcRegSE2()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")	
	        EndIf
	    endif

    RestArea(aAreaE2)
    RestArea(aArea)
Return

/******************* Exclusao pagamento Planejado ************************/

static function zExcRegSE2()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= SE2->E2_NUM
Local oGet2
Local cGet2 	:= Posicione("SA2",1,xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA, "A2_NREDUZ")
Local oGet3
Local oFornece 	:= SE2->E2_FORNECE
Local oGet7 
Local oGet8 	:= SE2->E2_LOJA
Local dVencto 	:= SE2->E2_VENCREA
//Local oGet4
Local oGet5		:=  SE2->E2_TIPO
Local oGet6		:=  Posicione("SED",1,xFilial("SED") + ALLTRIM(SE2->E2_NATUREZ), "ED_XGRUPO")
//Local nValor 	:= SE2->E2_VALOR
Local oGet9
Local cGet9 	:= SE2->E2_HIST
Local oGet10
Local cGet10	:= SE2->E2_TIPO
Local oGet11
Local cGet11 	:= SE2->E2_XXIC
Local oGet12
Local cGet12 	:= SE2->E2_NATUREZ

Local oGet4
Local nValor 	:= SE2->E2_VALOR

Local oGet15
Local nValorRE 	:= SE2->E2_VLCRUZ

Local oGet16
Local nMoeda 	:= SE2->E2_MOEDA

Local oGet17
Local nTXMoeda 	:= SE2->E2_TXMOEDA

Local dEmissa	:= SE2->E2_EMISSAO
Local oGet13
Local dVenct 	:= SE2->E2_VENCTO
Local oGet14

Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay7

Local _nOpc := 0
Static _oDlg

	DEFINE MSDIALOG _oDlg TITLE "Exclusao Titulo Contas a Pagar" FROM 000, 000  TO 350, 498 COLORS 0, 16777215 PIXEL

  	oGroup1:= TGroup():New(0005,0005,0145,0245,'',_oDlg,,,.T.)

 /// DEFINE MSDIALOG _oDlg TITLE "Exclusao Titulo Contas a Pagar" FROM 000, 000  TO 300, 498 COLORS 0, 16777215 PIXEL

  //	oGroup1:= TGroup():New(0005,0005,0125,0245,'',_oDlg,,,.T.)
 
    @ 013, 010 SAY oSay1 PROMPT "Titulo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 010 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 062 SAY oSay10 PROMPT "Tipo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oGet10 VAR cGet10 When .F. SIZE 032, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 102 SAY oSay11 PROMPT "Contrato" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 102 MSGET oGet11 VAR cGet11 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 172 SAY oSay11 PROMPT "Natureza" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 172 MSGET oGet12 VAR cGet12 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
 	@ 037, 010 SAY oSay7 PROMPT "Codigo" SIZE 032, 007  COLORS 0, 16777215 PIXEL
	@ 046, 010 MSGET oGet7 VAR oFornece When .F. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	   
    @ 037, 063 SAY oSay2 PROMPT "Fornecedor" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 046, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 180, 010  COLORS 0, 16777215 PIXEL
    
     /**************/
    @ 063, 010 SAY oSay13 PROMPT "Emissao" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 010 MSGET oGet13 VAR dEmissa When .F. SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 060 SAY oSay14 PROMPT "Vencimento" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 060 MSGET oGet14 VAR dVenct When .F. SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 110 SAY oSay3 PROMPT "Vencto Real" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 110 MSGET oGet3 VAR dVencto When .F.SIZE 044, 010  COLORS 0, 16777215 PIXEL
    /**************/  
     /**************/  
    @ 087, 010 SAY oSay4 PROMPT "Valor R$" SIZE 038, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 010 MSGET oGet15 VAR nValorRE When .F. PICTURE PesqPict("SE2","E2_VLCRUZ") SIZE 060, 010  COLORS 0, 16777215 PIXEL

	@ 087, 080 SAY oSay4 PROMPT "Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 080 MSGET oGet16 VAR nMoeda When .F. PICTURE PesqPict("SE2","E2_MOEDA") Pixel F3 "SM2" SIZE 020, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 110 SAY oSay4 PROMPT "Valor" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 110 MSGET oGet4 VAR nValor When .F. PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 180 SAY oSay4 PROMPT "Taxa Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 180 MSGET oGet17 VAR nTXMoeda When .F. PICTURE PesqPict("SE2","E2_TXMOEDA") SIZE 060, 010  COLORS 0, 16777215 PIXEL  
     
    @ 111, 010 SAY oSay9 PROMPT "Historico" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 122, 010 MSGET oGet9 VAR cGet9 When .F. SIZE 230, 010  COLORS 0, 16777215 PIXEL
    
    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 152, 079 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 039, 010  PIXEL
    @ 152, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 039, 010  PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1
  	Reclock("SE2",.F.)
  		DbSelectArea("SE2")
  		Reclock("SE2",.F.)
  		if SE2->(DbSeek(xFilial("SE2")+cGet1+oFornece+dtos(dVencto)+oGet8) )
  			SE2->(DbDelete())
  	 	endif	
  	 MsUnlock()
  
	DbSelectArea("TRB9")
	TRB9->(dbgotop())
	zap
	MSAguarde({||zProvJobs()},"Processando Contas a Pagar Planejado")
	TRB9->(DBGoBottom())
	TRB9->(dbgotop())
	GetdRefresh()

	DbSelectArea("TRB9X")
	TRB9X->(dbgotop())
	zap
	MSAguarde({||zXPrJobs()},"Processando Contas a Pagar Planejado")
	TRB9X->(DBGoBottom())
	TRB9X->(dbgotop())
	GetdRefresh()
  Endif
Return _nOpc

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½PFIN01REALï¿½Autor  Reginaldo Valerio						   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Processa PAGAMENTO planejado       		              ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

static function zCustJobs()
local nTotCusto 	:= 0
local nTotCTot 		:= 0
local _cQuery 		:= ""
local _cQuery2 		:= ""
Local _cFilSE2 		:= xFilial("SE2")
local cFor 			:= ""
local nTotPAG1 		:= 0
local nTotPAG2 		:= 0
//**** variaveis SC7
Local _cQuerySC7 	:= ""
Local _cFilSC7 		:= xFilial("SC7")
Local dData
Local nValor 		:= 0
local dDataM2
local cForSC7 		:= ""
//**** variaveis SD1
local _cQuerySD1 	:= ""
Local _cFilSD1 		:= xFilial("SD1")
//**** variaveis SDE - rateio nf
local _cQuerySDE	:= ""
Local _cFilSDE 		:= xFilial("SDE")
Local cProdD1 		:= ""
Local cDoc			:= ""
Local cSerie		:= ""
Local cFornece		:= ""
Local cLoja			:= ""
Local cItemNF		:= ""
local cForSDE 		:= "" //ALLTRIM(QUERY->DE_ITEMCTA) == _cItemConta
//**** variaveis SE2
local _cQuerySE2 	:= ""
Local _cFilSE2 		:= xFilial("SE2")
Local nXIPI 		:= 0
Local nXII 			:= 0
Local nXCOFINS 		:= 0
Local nXPIS 		:= 0
Local nXICMS 		:= 0
Local nXSISCO 		:= 0
Local nXSDA 		:= 0
Local nXTERM 		:= 0
Local nXTRANSP 		:= 0
Local nXFRETE 		:= 0
Local nXFUMIG 		:= 0
Local nXARMAZ 		:= 0
Local nXAFRMM 		:= 0
Local nXCAPA 		:= 0
Local nXCOMIS 		:= 0
Local nXISS 		:= 0
Local nXIRRF 		:= 0
Local nCustoFin 	:= 0
Local nCustoFin2 	:= 0
//**** variaveis CV4
local _cQueryCV4 	:= ""
local cQueryCV4 	:= ""
Local _cFilCV4 		:= xFilial("CV4")
//**** variaveis SZ4
local _cQuerySZ4 	:= ""
Local _cFilSZ4 		:= xFilial("SZ4")
Local nTarefa
local cForSZ4 		:= "" //"ALLTRIM(QUERYSZ4->Z4_ITEMCTA) == cItemCta"
//**** variaveis ZZA
local _cQueryZZA := ""
Local _cFilZZA := xFilial("ZZA")
local cForZZA := "" //"ALLTRIM(QUERYZZA->ZZA_ITEMIC) == _cItemConta"
//****
local nContador		:= 1
private _cItemCta 	:= ''
//**** limpemza TRB3	
	DbSelectArea("TRB3")
	TRB3->(dbgotop())
	zap

// Analisar contratos pedido de compra ativo
	_cQuery2 := " SELECT C7_NUM, C7_ITEMCTA "
	_cQuery2 += "  FROM SC7010 "
	_cQuery2 += "  WHERE D_E_L_E_T_ <> '*' AND C7_NUM = '" + cNum + "' "
	_cQuery2 += "  GROUP BY C7_NUM, C7_ITEMCTA ORDER BY 1 "

	IF Select("_cQuery2") <> 0
		DbSelectArea("_cQuery2")
		DbCloseArea()
	ENDIF
	//crio o novo alias
	TCQUERY _cQuery2 NEW ALIAS "QUERY2"
	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())
//************************************************
	while QUERY2->(!eof())

		cItemCta	:= QUERY2->C7_ITEMCTA
		cForSC7 	:= "ALLTRIM(QUERYSC7->C7_ITEMCTA) == cItemCta .AND. !cItemCta $ ('ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES')"
		
		//**** Abertura tabela para carregar valores SC7
			SC7->(dbsetorder(23)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
			ChkFile("SC7",.F.,"QUERYSC7") // Alias dos movimentos bancarios
			IndRegua("QUERYSC7",CriaTrab(NIL,.F.),"C7_EMISSAO",,cForSC7,"Selecionando Registros...")
			ProcRegua(QUERYSC7->(reccount()))
			QUERYSC7->(dbgotop())
		//******************************
			dbSelectArea("SM2")
			_cQuerySM2 := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"
			IF Select("_cQuerySM2") <> 0
				DbSelectArea("_cQuerySM2")
				DbCloseArea()
			ENDIF
			//crio o novo alias
			TCQUERY _cQuerySM2 NEW ALIAS "QUERYSM2"
			dbSelectArea("QUERYSM2")
			QUERYSM2->(dbGoTop())
	//*******************
			//*************************
			while QUERYSC7->(!eof())

				if QUERYSC7->C7_ITEMCTA == cItemCta .and. alltrim(QUERYSC7->C7_ENCER) == ""

					IncProc("Processando registro: "+alltrim(QUERYSC7->C7_NUM))
					//MsProcTxt("Processando registro: "+alltrim(QUERY->C7_NUM))
					ProcessMessage()
					
					if QUERYSC7->C7_MOEDA = 2
						dData := QUERYSC7->C7_EMISSAO
						//msginfo ( dData )
						while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

							while  QUERYSM2->(!eof())
								
								nValor := QUERYSM2->M2_MOEDA2
							
								if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
									nValor := QUERYSM2->M2_MOEDA2
									Exit
								else
									QUERYSM2->(dbSkip())
								endif

							enddo
							if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
								exit
							ENDIF
							dData--
							
						enddo
						IF QUERYSC7->C7_QUJE > 0
							nTotCusto	+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)
							nTotCTot	+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)
						ELSE
							nTotCusto	+= QUERYSC7->C7_XTOTSI * nValor
							nTotCTot	+= QUERYSC7->C7_XTOTSI * nValor
						ENDIF

					elseif QUERYSC7->C7_MOEDA = 3
						dData := QUERYSC7->C7_EMISSAO
						//msginfo ( dData )
						while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
							while  QUERYSM2->(!eof())
								
								nValor := QUERYSM2->M2_MOEDA3
							
								if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
									nValor := QUERYSM2->M2_MOEDA3
									Exit
								else
									QUERYSM2->(dbSkip())
								endif

							enddo
							if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
								exit
							ENDIF
							dData--
						enddo
						IF QUERYSC7->C7_QUJE > 0
							nTotCusto		+= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
							nTotCTot		+= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
						ELSE
							nTotCusto		+= QUERYSC7->C7_XTOTSI * nValor
							nTotCTot		+= QUERYSC7->C7_XTOTSI * nValor
						ENDIF

					elseif QUERYSC7->C7_MOEDA = 4
						dData := QUERYSC7->C7_EMISSAO
						//msginfo ( dData )
						while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

							while  QUERYSM2->(!eof())
								
								nValor := QUERYSM2->M2_MOEDA4
							
								if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
									nValor := QUERYSM2->M2_MOEDA4
									Exit
								else
									QUERYSM2->(dbSkip())
								endif

							enddo
							if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
								exit
							ENDIF
							dData--
						enddo
						IF QUERYSC7->C7_QUJE > 0
							nTotCusto		+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)
							nTotCTot		+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)		
						ELSE
							nTotCusto		+= QUERYSC7->C7_XTOTSI * nValor
							nTotCTot		+= QUERYSC7->C7_XTOTSI * nValor
						ENDIF
					else
						IF QUERYSC7->C7_QUJE > 0
							nTotCusto		+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI) 
							nTotCTot		+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI) 
						ELSE
							nTotCusto		+= QUERYSC7->C7_XTOTSI
							nTotCTot 		+= QUERYSC7->C7_XTOTSI
						ENDIF
					endif

				endif
				QUERYSC7->(dbskip())

			enddo
			//**** fim custo SC7
			//**** inicio custo SD1
			_cQuerySD1 := "SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO' , D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, D1_BASEICM,D1_GRUPO, D1_CUSTO, D1_FORNECE  FROM SD1010  WHERE  D_E_L_E_T_ <> '*' AND D1_ITEMCTA = '" + cItemCta + "' ORDER BY D1_EMISSAO"

			IF Select("_cQuerySD1") <> 0
				DbSelectArea("_cQuerySD1")
				DbCloseArea()
			ENDIF

			//crio o novo alias
			TCQUERY _cQuerySD1 NEW ALIAS "QUERYSD1"

			dbSelectArea("QUERYSD1")
			QUERYSD1->(dbGoTop())

			while QUERYSD1->(!eof())

				if QUERYSD1->D1_ITEMCTA == cItemCta;
					.AND. ! alltrim(QUERYSD1->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') .AND. QUERYSD1->D1_RATEIO == '2';
					.AND. QUERYSD1->D1_RATEIO == '2'
								
					//MsProcTxt("Processando registro: "+alltrim(QUERYSD1->D1_DOC))
					//ProcessMessage()
					
					if !ALLTRIM(QUERYSD1->D1_XNATURE) $ ('6.21.00/6.22.00')
						nTotCusto		+= QUERYSD1->D1_CUSTO
					ENDIF
					nTotCTot		+= QUERYSD1->D1_CUSTO
								
				endif

				QUERYSD1->(dbskip())

			enddo

			//**** fim custo SD1
			//**** inicio custo SDE
			cForSDE 		:= "ALLTRIM(QUERYSDE->DE_ITEMCTA) == cItemCta"
			SD1->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

			ChkFile("SDE",.F.,"QUERYSDE") // Alias dos movimentos bancarios
			IndRegua("QUERYSDE",CriaTrab(NIL,.F.),"QUERYSDE->DE_DOC",,cForSDE,"Selecionando Registros...")
			ProcRegua(QUERYSDE->(reccount()))
			QUERYSDE->(dbgotop())

			cDoc		:= QUERYSDE->DE_DOC
			cFornece	:= QUERYSDE->DE_FORNECE
			cItemNF		:= QUERYSDE->DE_ITEMNF

			while QUERYSDE->(!eof())

				if QUERYSDE->DE_ITEMCTA == cItemCta;
					.AND. ! alltrim(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_CF")) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') 
					
					cDoc		:= QUERYSDE->DE_DOC
					cSerie		:= QUERYSDE->DE_SERIE
					cFornece	:= QUERYSDE->DE_FORNECE
					cLoja		:= QUERYSDE->DE_LOJA
					cItemNF		:= QUERYSDE->DE_ITEMNF
							
					//MsProcTxt("Processando registro: "+alltrim(QUERY->DE_DOC))
					//ProcessMessage()
					
					if !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00')
						nTotCusto	+= QUERYSDE->DE_CUSTO1	
					endif
					nTotCTot	+= QUERYSDE->DE_CUSTO1
					
				endif

				QUERYSDE->(dbskip())

			enddo

			//**** fim custo SD2
			//**** inicio custo SE2
			_cQuerySE2 := "SELECT CAST(E2_BAIXA AS DATE) TMP_BAIXA, E2_TIPO, E2_NUM, E2_NATUREZ, E2_HIST, E2_VLCRUZ, E2_FORNECE, E2_NATUREZ, E2_XXIC, E2_RATEIO, E2_SALDO, E2_BAIXA, "
			_cQuerySE2 += " E2_TIPO,E2_XIPI,E2_XII,E2_XCOFINS,E2_XPIS,E2_XICMS,E2_XSISCO,E2_XSDA,E2_XTERM,E2_XTRANSP,E2_XFRETE,E2_XFUMIG,E2_XARMAZ,E2_XAFRMM,E2_XCAPA,E2_XCOMIS,E2_XISS,E2_XIRRF, "
			_cQuerySE2 += " E2_XCTII,E2_XCTIPI,E2_XCTCOF,E2_XCTPIS,E2_XCTICMS,E2_XCTSISC,E2_XCTSDA,E2_XCTTEM,E2_XCTTRAN,E2_XCTFRET,E2_XCTFUM,E2_XCTARM,E2_XCTAFRM,E2_XCTCAPA,E2_XCTCOM,E2_XCTISS,E2_XCTIRRF "
			_cQuerySE2 += " FROM SE2010  WHERE  D_E_L_E_T_ <> '*' AND E2_XXIC = '" + cItemCta + "' ORDER BY E2_BAIXA "
			IF Select("_cQuerySE2") <> 0
				DbSelectArea("_cQuerySE2")
				DbCloseArea()
			ENDIF
			//crio o novo alias
			TCQUERY _cQuerySE2 NEW ALIAS "QUERYSE2"
			dbSelectArea("QUERYSE2")
			QUERYSE2->(dbGoTop())
			
			while QUERYSE2->(!eof())

				IF ALLTRIM(QUERYSE2->E2_TIPO) = "PA" .AND. QUERYSE2->E2_BAIXA <> "" .AND. QUERYSE2->E2_SALDO = 0
					QUERYSE2->(dbsKip())
					loop
				ENDIF
				
				if QUERYSE2->E2_XXIC == cItemCta .AND. !ALLTRIM(QUERYSE2->E2_TIPO) $ ("NF/PR/PA/TX/ISS/INS/INV") .AND. ALLTRIM(QUERYSE2->E2_RATEIO) == "N" //.AND. !EMPTY(QUERY->E2_BAIXA)

					if QUERYSE2->E2_XCTIPI = "2"
						nXIPI := QUERYSE2->E2_XIPI
					else
						nXIPI := 0
					endif
					
					if QUERYSE2->E2_XCTII = "2"
						nXII := QUERYSE2->E2_XII
					else
						nXII := 0
					endif
					
					if QUERYSE2->E2_XCTCOF = "2"
						nXCOFINS := QUERYSE2->E2_XCOFINS
					else
						nXCOFINS := 0
					endif
					
					if QUERYSE2->E2_XCTPIS = "2"
						nXPIS := QUERYSE2->E2_XPIS
					else
						nXPIS := 0
					endif
					
					if QUERYSE2->E2_XCTICMS = "2"
						nXICMS := QUERYSE2->E2_XICMS
					else
						nXICMS := 0
					endif
					
					if QUERYSE2->E2_XCTSISC = "2"
						nXSISCO := QUERYSE2->E2_XSISCO
					else
						nXSISCO := 0
					endif
					
					if QUERYSE2->E2_XCTSDA = "2"
						nXSDA := QUERYSE2->E2_XSDA
					else
						nXSDA := 0
					endif
					
					if QUERYSE2->E2_XCTTEM = "2"
						nXTERM := QUERYSE2->E2_XTERM
					else
						nXTERM := 0
					endif
					
					if QUERYSE2->E2_XCTTRAN = "2"
						nXTRANSP := QUERYSE2->E2_XTRANSP
					else
						nXTRANSP := 0
					endif
					
					if QUERYSE2->E2_XCTFRET = "2"
						nXFRETE := QUERYSE2->E2_XFRETE
					else
						nXFRETE := 0
					endif
					
					if QUERYSE2->E2_XCTFUM = "2"
						nXFUMIG := QUERYSE2->E2_XFUMIG
					else
						nXFUMIG := 0
					endif
					
					if QUERYSE2->E2_XCTARM = "2"
						nXARMAZ := QUERYSE2->E2_XARMAZ
					else
						nXARMAZ := 0
					endif
					
					if QUERYSE2->E2_XCTAFRM = "2"
						nXAFRMM := QUERYSE2->E2_XAFRMM
					else
						nXAFRMM := 0
					endif
					
					if QUERYSE2->E2_XCTCAPA = "2"
						nXCAPA := QUERYSE2->E2_XCAPA
					else
						nXCAPA := 0
					endif
					
					if QUERYSE2->E2_XCTCOM = "2"
						nXCOMIS := QUERYSE2->E2_XCOMIS
					else
						nXCOMIS := 0
					endif
					
					if QUERYSE2->E2_XCTISS = "2"
						nXISS := QUERYSE2->E2_XISS
					else
						nXISS := 0
					endif
					
					if QUERYSE2->E2_XCTIRRF = "2"
						nXIRRF := QUERYSE2->E2_XIRRF
					else
						nXIRRF := 0
					endif

					if !ALLTRIM(QUERYSE2->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
						nCustoFin := QUERYSE2->E2_VLCRUZ - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
						if QUERYSE2->E2_TIPO = "PA"
							nTotCusto		+= QUERYSE2->E2_SALDO
						ELSE
							nTotCusto		+= nCustoFin
						endiF
					endif
					
					nCustoFin2 := QUERYSE2->E2_VLCRUZ - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
					if QUERYSE2->E2_TIPO = "PA"
						nTotCTot		+= QUERYSE2->E2_SALDO
					ELSE
						nTotCTot		+= nCustoFin2
					endiF
					
				endif
				QUERYSE2->(dbskip())
			enddo
			//**** fim CUSTO SE2
			//**** inicio custo CV4
			cQueryCV4 := "	SELECT DISTINCT E2_FORNECE, E2_NOMFOR, E2_LOJA, E2_RATEIO,E2_XXIC, E2_NUM, E2_VENCREA, E2_VENCTO, E2_VLCRUZ, E2_NATUREZ,  " 
			cQueryCV4 += "	CAST(CV4_DTSEQ AS DATE) AS 'TMP_DTSEQ', CV4_PERCEN,CV4_VALOR,CV4_ITEMD, CV4_HIST, CV4_SEQUEN,"
			cQueryCV4 += "		CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN AS 'TMP_ARQRAT',E2_ARQRAT, E2_TIPO, E2_BAIXA, " 
			cQueryCV4 += " E2_TIPO,E2_XIPI,E2_XII,E2_XCOFINS,E2_XPIS,E2_XICMS,E2_XSISCO,E2_XSDA,E2_XTERM,E2_XTRANSP,E2_XFRETE,E2_XFUMIG,E2_XARMAZ,E2_XAFRMM,E2_XCAPA,E2_XCOMIS,E2_XISS,E2_XIRRF, "
			cQueryCV4 += " E2_XCTII,E2_XCTIPI,E2_XCTCOF,E2_XCTPIS,E2_XCTICMS,E2_XCTSISC,E2_XCTSDA,E2_XCTTEM,E2_XCTTRAN,E2_XCTFRET,E2_XCTFUM,E2_XCTARM,E2_XCTAFRM,E2_XCTCAPA,E2_XCTCOM,E2_XCTISS,E2_XCTIRRF " 
			cQueryCV4 += "		FROM CV4010 "
			cQueryCV4 += "		INNER JOIN SE2010 ON SE2010.E2_ARQRAT = CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN "
			cQueryCV4 += "		WHERE E2_RATEIO = 'S' AND SE2010.D_E_L_E_T_ <> '*' AND CV4010.D_E_L_E_T_ <> '*' "
			cQueryCV4 += "				ORDER BY E2_XXIC "

			IF Select("cQueryCV4") <> 0
				DbSelectArea("cQueryCV4")
				DbCloseArea()
			ENDIF
			//crio o novo alias
			TCQUERY cQueryCV4 NEW ALIAS "QUERYCV4"
			dbSelectArea("QUERYCV4")
			QUERYCV4->(dbGoTop())

			QUERYCV4->(dbgotop())

			while QUERYCV4->(!eof())

				IF ALLTRIM(QUERYCV4->E2_TIPO) = "PA" .AND. QUERYCV4->E2_BAIXA <> "" 
					QUERYCV4->(dbsKip())
					loop
				ENDIF

				if QUERYCV4->CV4_ITEMD == cItemCta

					if QUERYCV4->E2_XCTIPI = "2"
						nXIPI := QUERYCV4->E2_XIPI * (QUERYCV4->CV4_PERCEN/100)
					else
						nXIPI := 0
					endif
					
					if QUERYCV4->E2_XCTII = "2"
						nXII := QUERYCV4->E2_XII * (QUERYCV4->CV4_PERCEN/100)
					else
						nXII := 0
					endif
					
					if QUERYCV4->E2_XCTCOF = "2"
						nXCOFINS := QUERYCV4->E2_XCOFINS * (QUERYCV4->CV4_PERCEN/100)
					else
						nXCOFINS := 0
					endif
					
					if QUERYCV4->E2_XCTPIS = "2"
						nXPIS := QUERYCV4->E2_XPIS * (QUERYCV4->CV4_PERCEN/100)
					else
						nXPIS := 0
					endif
					
					if QUERYCV4->E2_XCTICMS = "2"
						nXICMS := QUERYCV4->E2_XICMS * (QUERYCV4->CV4_PERCEN/100)
					else
						nXICMS := 0
					endif
					
					if QUERYCV4->E2_XCTSISC = "2"
						nXSISCO := QUERYCV4->E2_XSISCO * (QUERYCV4->CV4_PERCEN/100)
					else
						nXSISCO := 0
					endif
					
					if QUERYCV4->E2_XCTSDA = "2"
						nXSDA := QUERYCV4->E2_XSDA * (QUERYCV4->CV4_PERCEN/100)
					else
						nXSDA := 0
					endif
					
					if QUERYCV4->E2_XCTTEM = "2"
						nXTERM := QUERYCV4->E2_XTERM * (QUERYCV4->CV4_PERCEN/100)
					else
						nXTERM := 0
					endif
					
					if QUERYCV4->E2_XCTTRAN = "2"
						nXTRANSP := QUERYCV4->E2_XTRANSP * (QUERYCV4->CV4_PERCEN/100)
					else
						nXTRANSP := 0
					endif
					
					if QUERYCV4->E2_XCTFRET = "2"
						nXFRETE := QUERYCV4->E2_XFRETE * (QUERYCV4->CV4_PERCEN/100)
					else
						nXFRETE := 0
					endif
					
					if QUERYCV4->E2_XCTFUM = "2"
						nXFUMIG := QUERYCV4->E2_XFUMIG * (QUERYCV4->CV4_PERCEN/100)
					else
						nXFUMIG := 0
					endif
					
					if QUERYCV4->E2_XCTARM = "2"
						nXARMAZ := QUERYCV4->E2_XARMAZ * (QUERYCV4->CV4_PERCEN/100)
					else
						nXARMAZ := 0
					endif
					
					if QUERYCV4->E2_XCTAFRM = "2"
						nXAFRMM := QUERYCV4->E2_XAFRMM * (QUERYCV4->CV4_PERCEN/100)
					else
						nXAFRMM := 0
					endif
					
					if QUERYCV4->E2_XCTCAPA = "2"
						nXCAPA := QUERYCV4->E2_XCAPA * (QUERYCV4->CV4_PERCEN/100)
					else
						nXCAPA := 0
					endif
					
					if QUERYCV4->E2_XCTCOM = "2"
						nXCOMIS := QUERYCV4->E2_XCOMIS * (QUERYCV4->CV4_PERCEN/100)
					else
						nXCOMIS := 0
					endif
					
					if QUERYCV4->E2_XCTISS = "2"
						nXISS := QUERYCV4->E2_XISS * (QUERYCV4->CV4_PERCEN/100)
					else
						nXISS := 0
					endif
					
					if QUERYCV4->E2_XCTIRRF = "2"
						nXIRRF := QUERYCV4->E2_XIRRF * (QUERYCV4->CV4_PERCEN/100)
					else
						nXIRRF := 0
					endif

					if !ALLTRIM(QUERYCV4->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
						nTotCusto		+= QUERYCV4->CV4_VALOR - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
					endif
					nTotCTot		+= QUERYCV4->CV4_VALOR - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
					
				endif

				QUERYCV4->(dbskip())

			enddo
			//**** fim custo CV4
			//**** inicio custo SZ4
			cForSZ4 		:= "ALLTRIM(QUERYSZ4->Z4_ITEMCTA) == cItemCta"
			ChkFile("SZ4",.F.,"QUERYSZ4") // Alias dos movimentos bancarios
			IndRegua("QUERYSZ4",CriaTrab(NIL,.F.),"Z4_FILIAL+Z4_ITEMCTA",,cForSZ4,"Selecionando Registros...")
			ProcRegua(QUERYSZ4->(reccount()))
			QUERYSZ4->(dbgotop())

			while QUERYSZ4->(!eof())
				if QUERYSZ4->Z4_ITEMCTA == cItemCta
					nTotCusto		+= QUERYSZ4->Z4_TOTVLR
					nTotCTot		+= QUERYSZ4->Z4_TOTVLR
				endif
				QUERYSZ4->(dbskip())
			enddo
			//**** fim custo SZ4
			//**** inicio custo ZZA
			cForZZA := "ALLTRIM(QUERYZZA->ZZA_ITEMIC) == _cItemConta"
			ZZA->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

			ChkFile("ZZA",.F.,"QUERYZZA") // Alias dos movimentos bancarios
			IndRegua("QUERYZZA",CriaTrab(NIL,.F.),"ZZA_DATA",,cForZZA,"Selecionando Registros...")
			ProcRegua(QUERYZZA->(reccount()))

			QUERYZZA->(dbgotop())

			while QUERYZZA->(!eof())

				if QUERYZZA->ZZA_ITEMIC == cItemCta
					nTotCusto	+= QUERYZZA->ZZA_VALOR
					nTotCTot	+= QUERYZZA->ZZA_VALOR
				endif

				QUERYZZA->(dbskip())

			enddo
			//**** fim custo ZZA
		
	//*******************
			QUERY2->(dbskip())

		if !cItemCta  $ ("ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES")		
			RecLock("TRB3",.T.)
				TRB3->CITEM		:= cValTochar(nContador) + "1"
				TRB3->CDESCRI	:= "Custo Producao Planejado"
				TRB3->CVALOR	:= POSICIONE("CTD",1,XFILIAL("CTD")+cItemCta,"CTD_XCUPRR")
				TRB3->CITEMIC	:= cItemCta
				TRB3->CTIPCUSTO := "PLNPRD"
			MsUnlock()
			RecLock("TRB3",.T.)
				TRB3->CITEM		:= cValTochar(nContador) + "2"
				TRB3->CDESCRI	:= "Custo Total Planejado"
				TRB3->CVALOR	:= POSICIONE("CTD",1,XFILIAL("CTD")+cItemCta,"CTD_XCUTOR")
				TRB3->CITEMIC	:= cItemCta
				TRB3->CTIPCUSTO := "PLNTOT"
			MsUnlock()
			//RecLock("TRB3",.T.)
			//	TRB3->CITEM		:= cValTochar(nContador) + "3"
			//	TRB3->CDESCRI	:= "Verba Adicional"
			//	TRB3->CVALOR	:= POSICIONE("CTD",1,XFILIAL("CTD")+cItemCta,"CTD_XVBAD")
			//	TRB3->CITEMIC	:= cItemCta
			//MsUnlock()
			RecLock("TRB3",.T.)
				TRB3->CITEM		:= cValTochar(nContador) + "3"
				TRB3->CDESCRI	:= "Custo Producao Empenhado"
				TRB3->CVALOR	:= nTotCusto
				TRB3->CITEMIC	:= cItemCta
				TRB3->CTIPCUSTO := "EMPPRD"
			MsUnlock()
			RecLock("TRB3",.T.)
				TRB3->CITEM		:= cValTochar(nContador) + "4"
				TRB3->CDESCRI	:= "Custo Total Empenhado"
				TRB3->CVALOR	:= nTotCTot
				TRB3->CITEMIC	:= cItemCta
				TRB3->CTIPCUSTO := "EMPTOT"
			MsUnlock()
			RecLock("TRB3",.T.)
				TRB3->CITEM		:= cValTochar(nContador) + "5"
				TRB3->CDESCRI	:= "------------------------------"
				TRB3->CVALOR	:= 0
				TRB3->CITEMIC	:= "------------------------------"
				TRB3->CTIPCUSTO := "------"
			MsUnlock()
			nTotCusto 	:= 0
			nTotCTot 	:= 0
		endif
			nContador := nContador + 1
			//QUERY->(dbclosearea())
			QUERYSC7->(dbclosearea())
			QUERYSM2->(dbclosearea())
			QUERYSD1->(dbclosearea())
			QUERYSDE->(dbclosearea())
			QUERYSE2->(dbclosearea())
			QUERYCV4->(dbclosearea())
			QUERYSZ4->(dbclosearea())
			QUERYZZA->(dbclosearea())
		
	enddo

	//QUERY->(dbclosearea())
	QUERY2->(dbclosearea())
	
return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½PFIN01REALï¿½Autor  Reginaldo Valerio						   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Processa PAGAMENTO planejado       		              ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

static function zZCuJobs()
local nTotCusto 	:= 0
local nTotCTot 		:= 0
local _cQuery 		:= ""
local _cQuery2 		:= ""
Local _cFilSE2 		:= xFilial("SE2")
local cFor 			:= ""
local nTotPAG1 		:= 0
local nTotPAG2 		:= 0
//**** variaveis SC7
Local _cQuerySC7 	:= ""
Local _cFilSC7 		:= xFilial("SC7")
Local dData
Local nValor 		:= 0
local dDataM2
local cForSC7 		:= ""
//**** variaveis SD1
local _cQuerySD1 	:= ""
Local _cFilSD1 		:= xFilial("SD1")
//**** variaveis SDE - rateio nf
local _cQuerySDE	:= ""
Local _cFilSDE 		:= xFilial("SDE")
Local cProdD1 		:= ""
Local cDoc			:= ""
Local cSerie		:= ""
Local cFornece		:= ""
Local cLoja			:= ""
Local cItemNF		:= ""
local cForSDE 		:= "" //ALLTRIM(QUERY->DE_ITEMCTA) == _cItemConta
//**** variaveis SE2
local _cQuerySE2 	:= ""
Local _cFilSE2 		:= xFilial("SE2")
Local nXIPI 		:= 0
Local nXII 			:= 0
Local nXCOFINS 		:= 0
Local nXPIS 		:= 0
Local nXICMS 		:= 0
Local nXSISCO 		:= 0
Local nXSDA 		:= 0
Local nXTERM 		:= 0
Local nXTRANSP 		:= 0
Local nXFRETE 		:= 0
Local nXFUMIG 		:= 0
Local nXARMAZ 		:= 0
Local nXAFRMM 		:= 0
Local nXCAPA 		:= 0
Local nXCOMIS 		:= 0
Local nXISS 		:= 0
Local nXIRRF 		:= 0
Local nCustoFin 	:= 0
Local nCustoFin2 	:= 0
//**** variaveis CV4
local _cQueryCV4 	:= ""
local cQueryCV4 	:= ""
Local _cFilCV4 		:= xFilial("CV4")
//**** variaveis SZ4
local _cQuerySZ4 	:= ""
Local _cFilSZ4 		:= xFilial("SZ4")
Local nTarefa
local cForSZ4 		:= "" //"ALLTRIM(QUERYSZ4->Z4_ITEMCTA) == cItemCta"
//**** variaveis ZZA
local _cQueryZZA := ""
Local _cFilZZA := xFilial("ZZA")
local cForZZA := "" //"ALLTRIM(QUERYZZA->ZZA_ITEMIC) == _cItemConta"
//****
local nContador		:= 1
private _cItemCta 	:= ''
//**** limpemza TRB3	
	DbSelectArea("TRB3Z")
	TRB3Z->(dbgotop())
	zap

// Analisar contratos pedido de compra ativo
	_cQuery2 := " SELECT C7_NUM, C7_ITEMCTA "
	_cQuery2 += "  FROM SC7010 "
	_cQuery2 += "  WHERE D_E_L_E_T_ <> '*' AND C7_NUM = '" + cNum + "' "
	_cQuery2 += "  GROUP BY C7_NUM, C7_ITEMCTA ORDER BY 1 "

	IF Select("_cQuery2") <> 0
		DbSelectArea("_cQuery2")
		DbCloseArea()
	ENDIF
	//crio o novo alias
	TCQUERY _cQuery2 NEW ALIAS "QUERY2"
	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())
//************************************************
	while QUERY2->(!eof())

		cItemCta	:= QUERY2->C7_ITEMCTA
		cForSC7 	:= "ALLTRIM(QUERYSC7->C7_ITEMCTA) == cItemCta .AND. !cItemCta $ ('ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES')"
		
		//**** Abertura tabela para carregar valores SC7
			SC7->(dbsetorder(23)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
			ChkFile("SC7",.F.,"QUERYSC7") // Alias dos movimentos bancarios
			IndRegua("QUERYSC7",CriaTrab(NIL,.F.),"C7_EMISSAO",,cForSC7,"Selecionando Registros...")
			ProcRegua(QUERYSC7->(reccount()))
			QUERYSC7->(dbgotop())
		//******************************
			dbSelectArea("SM2")
			_cQuerySM2 := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"
			IF Select("_cQuerySM2") <> 0
				DbSelectArea("_cQuerySM2")
				DbCloseArea()
			ENDIF
			//crio o novo alias
			TCQUERY _cQuerySM2 NEW ALIAS "QUERYSM2"
			dbSelectArea("QUERYSM2")
			QUERYSM2->(dbGoTop())
	//*******************
			//*************************
			while QUERYSC7->(!eof())

				if QUERYSC7->C7_ITEMCTA == cItemCta .and. alltrim(QUERYSC7->C7_ENCER) == ""

					IncProc("Processando registro: "+alltrim(QUERYSC7->C7_NUM))
					//MsProcTxt("Processando registro: "+alltrim(QUERY->C7_NUM))
					ProcessMessage()
					
					if QUERYSC7->C7_MOEDA = 2
						dData := QUERYSC7->C7_EMISSAO
						//msginfo ( dData )
						while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

							while  QUERYSM2->(!eof())
								
								nValor := QUERYSM2->M2_MOEDA2
							
								if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
									nValor := QUERYSM2->M2_MOEDA2
									Exit
								else
									QUERYSM2->(dbSkip())
								endif

							enddo
							if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
								exit
							ENDIF
							dData--
							
						enddo
						IF QUERYSC7->C7_QUJE > 0
							nTotCusto	+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)
							nTotCTot	+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)
						ELSE
							nTotCusto	+= QUERYSC7->C7_XTOTSI * nValor
							nTotCTot	+= QUERYSC7->C7_XTOTSI * nValor
						ENDIF

					elseif QUERYSC7->C7_MOEDA = 3
						dData := QUERYSC7->C7_EMISSAO
						//msginfo ( dData )
						while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
							while  QUERYSM2->(!eof())
								
								nValor := QUERYSM2->M2_MOEDA3
							
								if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
									nValor := QUERYSM2->M2_MOEDA3
									Exit
								else
									QUERYSM2->(dbSkip())
								endif

							enddo
							if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
								exit
							ENDIF
							dData--
						enddo
						IF QUERYSC7->C7_QUJE > 0
							nTotCusto		+= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
							nTotCTot		+= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
						ELSE
							nTotCusto		+= QUERYSC7->C7_XTOTSI * nValor
							nTotCTot		+= QUERYSC7->C7_XTOTSI * nValor
						ENDIF

					elseif QUERYSC7->C7_MOEDA = 4
						dData := QUERYSC7->C7_EMISSAO
						//msginfo ( dData )
						while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

							while  QUERYSM2->(!eof())
								
								nValor := QUERYSM2->M2_MOEDA4
							
								if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
									nValor := QUERYSM2->M2_MOEDA4
									Exit
								else
									QUERYSM2->(dbSkip())
								endif

							enddo
							if dData == QUERYSM2->TMP_DATA .AND. nValor > 0
								exit
							ENDIF
							dData--
						enddo
						IF QUERYSC7->C7_QUJE > 0
							nTotCusto		+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)
							nTotCTot		+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)		
						ELSE
							nTotCusto		+= QUERYSC7->C7_XTOTSI * nValor
							nTotCTot		+= QUERYSC7->C7_XTOTSI * nValor
						ENDIF
					else
						IF QUERYSC7->C7_QUJE > 0
							nTotCusto		+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI) 
							nTotCTot		+= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI) 
						ELSE
							nTotCusto		+= QUERYSC7->C7_XTOTSI
							nTotCTot 		+= QUERYSC7->C7_XTOTSI
						ENDIF
					endif

				endif
				QUERYSC7->(dbskip())

			enddo
			//**** fim custo SC7
			//**** inicio custo SD1
			_cQuerySD1 := "SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO' , D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, D1_BASEICM,D1_GRUPO, D1_CUSTO, D1_FORNECE  FROM SD1010  WHERE  D_E_L_E_T_ <> '*' AND D1_ITEMCTA = '" + cItemCta + "' ORDER BY D1_EMISSAO"

			IF Select("_cQuerySD1") <> 0
				DbSelectArea("_cQuerySD1")
				DbCloseArea()
			ENDIF

			//crio o novo alias
			TCQUERY _cQuerySD1 NEW ALIAS "QUERYSD1"

			dbSelectArea("QUERYSD1")
			QUERYSD1->(dbGoTop())

			while QUERYSD1->(!eof())

				if QUERYSD1->D1_ITEMCTA == cItemCta;
					.AND. ! alltrim(QUERYSD1->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') .AND. QUERYSD1->D1_RATEIO == '2';
					.AND. QUERYSD1->D1_RATEIO == '2'
								
					//MsProcTxt("Processando registro: "+alltrim(QUERYSD1->D1_DOC))
					//ProcessMessage()
					
					if !ALLTRIM(QUERYSD1->D1_XNATURE) $ ('6.21.00/6.22.00')
						nTotCusto		+= QUERYSD1->D1_CUSTO
					ENDIF
					nTotCTot		+= QUERYSD1->D1_CUSTO
								
				endif

				QUERYSD1->(dbskip())

			enddo

			//**** fim custo SD1
			//**** inicio custo SDE
			cForSDE 		:= "ALLTRIM(QUERYSDE->DE_ITEMCTA) == cItemCta"
			SD1->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

			ChkFile("SDE",.F.,"QUERYSDE") // Alias dos movimentos bancarios
			IndRegua("QUERYSDE",CriaTrab(NIL,.F.),"QUERYSDE->DE_DOC",,cForSDE,"Selecionando Registros...")
			ProcRegua(QUERYSDE->(reccount()))
			QUERYSDE->(dbgotop())

			cDoc		:= QUERYSDE->DE_DOC
			cFornece	:= QUERYSDE->DE_FORNECE
			cItemNF		:= QUERYSDE->DE_ITEMNF

			while QUERYSDE->(!eof())

				if QUERYSDE->DE_ITEMCTA == cItemCta;
					.AND. ! alltrim(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_CF")) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') 
					
					cDoc		:= QUERYSDE->DE_DOC
					cSerie		:= QUERYSDE->DE_SERIE
					cFornece	:= QUERYSDE->DE_FORNECE
					cLoja		:= QUERYSDE->DE_LOJA
					cItemNF		:= QUERYSDE->DE_ITEMNF
							
					//MsProcTxt("Processando registro: "+alltrim(QUERY->DE_DOC))
					//ProcessMessage()
					
					if !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00')
						nTotCusto	+= QUERYSDE->DE_CUSTO1	
					endif
					nTotCTot	+= QUERYSDE->DE_CUSTO1
					
				endif

				QUERYSDE->(dbskip())

			enddo

			//**** fim custo SD2
			//**** inicio custo SE2
			_cQuerySE2 := "SELECT CAST(E2_BAIXA AS DATE) TMP_BAIXA, E2_TIPO, E2_NUM, E2_NATUREZ, E2_HIST, E2_VLCRUZ, E2_FORNECE, E2_NATUREZ, E2_XXIC, E2_RATEIO, E2_SALDO, E2_BAIXA, "
			_cQuerySE2 += " E2_TIPO,E2_XIPI,E2_XII,E2_XCOFINS,E2_XPIS,E2_XICMS,E2_XSISCO,E2_XSDA,E2_XTERM,E2_XTRANSP,E2_XFRETE,E2_XFUMIG,E2_XARMAZ,E2_XAFRMM,E2_XCAPA,E2_XCOMIS,E2_XISS,E2_XIRRF, "
			_cQuerySE2 += " E2_XCTII,E2_XCTIPI,E2_XCTCOF,E2_XCTPIS,E2_XCTICMS,E2_XCTSISC,E2_XCTSDA,E2_XCTTEM,E2_XCTTRAN,E2_XCTFRET,E2_XCTFUM,E2_XCTARM,E2_XCTAFRM,E2_XCTCAPA,E2_XCTCOM,E2_XCTISS,E2_XCTIRRF "
			_cQuerySE2 += " FROM SE2010  WHERE  D_E_L_E_T_ <> '*' AND E2_XXIC = '" + cItemCta + "' ORDER BY E2_BAIXA "
			IF Select("_cQuerySE2") <> 0
				DbSelectArea("_cQuerySE2")
				DbCloseArea()
			ENDIF
			//crio o novo alias
			TCQUERY _cQuerySE2 NEW ALIAS "QUERYSE2"
			dbSelectArea("QUERYSE2")
			QUERYSE2->(dbGoTop())
			
			while QUERYSE2->(!eof())

				IF ALLTRIM(QUERYSE2->E2_TIPO) = "PA" .AND. QUERYSE2->E2_BAIXA <> "" .AND. QUERYSE2->E2_SALDO = 0
					QUERYSE2->(dbsKip())
					loop
				ENDIF
				
				if QUERYSE2->E2_XXIC == cItemCta .AND. !ALLTRIM(QUERYSE2->E2_TIPO) $ ("NF/PR/PA/TX/ISS/INS/INV") .AND. ALLTRIM(QUERYSE2->E2_RATEIO) == "N" //.AND. !EMPTY(QUERY->E2_BAIXA)

					if QUERYSE2->E2_XCTIPI = "2"
						nXIPI := QUERYSE2->E2_XIPI
					else
						nXIPI := 0
					endif
					
					if QUERYSE2->E2_XCTII = "2"
						nXII := QUERYSE2->E2_XII
					else
						nXII := 0
					endif
					
					if QUERYSE2->E2_XCTCOF = "2"
						nXCOFINS := QUERYSE2->E2_XCOFINS
					else
						nXCOFINS := 0
					endif
					
					if QUERYSE2->E2_XCTPIS = "2"
						nXPIS := QUERYSE2->E2_XPIS
					else
						nXPIS := 0
					endif
					
					if QUERYSE2->E2_XCTICMS = "2"
						nXICMS := QUERYSE2->E2_XICMS
					else
						nXICMS := 0
					endif
					
					if QUERYSE2->E2_XCTSISC = "2"
						nXSISCO := QUERYSE2->E2_XSISCO
					else
						nXSISCO := 0
					endif
					
					if QUERYSE2->E2_XCTSDA = "2"
						nXSDA := QUERYSE2->E2_XSDA
					else
						nXSDA := 0
					endif
					
					if QUERYSE2->E2_XCTTEM = "2"
						nXTERM := QUERYSE2->E2_XTERM
					else
						nXTERM := 0
					endif
					
					if QUERYSE2->E2_XCTTRAN = "2"
						nXTRANSP := QUERYSE2->E2_XTRANSP
					else
						nXTRANSP := 0
					endif
					
					if QUERYSE2->E2_XCTFRET = "2"
						nXFRETE := QUERYSE2->E2_XFRETE
					else
						nXFRETE := 0
					endif
					
					if QUERYSE2->E2_XCTFUM = "2"
						nXFUMIG := QUERYSE2->E2_XFUMIG
					else
						nXFUMIG := 0
					endif
					
					if QUERYSE2->E2_XCTARM = "2"
						nXARMAZ := QUERYSE2->E2_XARMAZ
					else
						nXARMAZ := 0
					endif
					
					if QUERYSE2->E2_XCTAFRM = "2"
						nXAFRMM := QUERYSE2->E2_XAFRMM
					else
						nXAFRMM := 0
					endif
					
					if QUERYSE2->E2_XCTCAPA = "2"
						nXCAPA := QUERYSE2->E2_XCAPA
					else
						nXCAPA := 0
					endif
					
					if QUERYSE2->E2_XCTCOM = "2"
						nXCOMIS := QUERYSE2->E2_XCOMIS
					else
						nXCOMIS := 0
					endif
					
					if QUERYSE2->E2_XCTISS = "2"
						nXISS := QUERYSE2->E2_XISS
					else
						nXISS := 0
					endif
					
					if QUERYSE2->E2_XCTIRRF = "2"
						nXIRRF := QUERYSE2->E2_XIRRF
					else
						nXIRRF := 0
					endif

					if !ALLTRIM(QUERYSE2->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
						nCustoFin := QUERYSE2->E2_VLCRUZ - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
						if QUERYSE2->E2_TIPO = "PA"
							nTotCusto		+= QUERYSE2->E2_SALDO
						ELSE
							nTotCusto		+= nCustoFin
						endiF
					endif
					
					nCustoFin2 := QUERYSE2->E2_VLCRUZ - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
					if QUERYSE2->E2_TIPO = "PA"
						nTotCTot		+= QUERYSE2->E2_SALDO
					ELSE
						nTotCTot		+= nCustoFin2
					endiF
					
				endif
				QUERYSE2->(dbskip())
			enddo
			//**** fim CUSTO SE2
			//**** inicio custo CV4
			cQueryCV4 := "	SELECT DISTINCT E2_FORNECE, E2_NOMFOR, E2_LOJA, E2_RATEIO,E2_XXIC, E2_NUM, E2_VENCREA, E2_VENCTO, E2_VLCRUZ, E2_NATUREZ,  " 
			cQueryCV4 += "	CAST(CV4_DTSEQ AS DATE) AS 'TMP_DTSEQ', CV4_PERCEN,CV4_VALOR,CV4_ITEMD, CV4_HIST, CV4_SEQUEN,"
			cQueryCV4 += "		CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN AS 'TMP_ARQRAT',E2_ARQRAT, E2_TIPO, E2_BAIXA, " 
			cQueryCV4 += " E2_TIPO,E2_XIPI,E2_XII,E2_XCOFINS,E2_XPIS,E2_XICMS,E2_XSISCO,E2_XSDA,E2_XTERM,E2_XTRANSP,E2_XFRETE,E2_XFUMIG,E2_XARMAZ,E2_XAFRMM,E2_XCAPA,E2_XCOMIS,E2_XISS,E2_XIRRF, "
			cQueryCV4 += " E2_XCTII,E2_XCTIPI,E2_XCTCOF,E2_XCTPIS,E2_XCTICMS,E2_XCTSISC,E2_XCTSDA,E2_XCTTEM,E2_XCTTRAN,E2_XCTFRET,E2_XCTFUM,E2_XCTARM,E2_XCTAFRM,E2_XCTCAPA,E2_XCTCOM,E2_XCTISS,E2_XCTIRRF " 
			cQueryCV4 += "		FROM CV4010 "
			cQueryCV4 += "		INNER JOIN SE2010 ON SE2010.E2_ARQRAT = CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN "
			cQueryCV4 += "		WHERE E2_RATEIO = 'S' AND SE2010.D_E_L_E_T_ <> '*' AND CV4010.D_E_L_E_T_ <> '*' "
			cQueryCV4 += "				ORDER BY E2_XXIC "

			IF Select("cQueryCV4") <> 0
				DbSelectArea("cQueryCV4")
				DbCloseArea()
			ENDIF
			//crio o novo alias
			TCQUERY cQueryCV4 NEW ALIAS "QUERYCV4"
			dbSelectArea("QUERYCV4")
			QUERYCV4->(dbGoTop())

			QUERYCV4->(dbgotop())

			while QUERYCV4->(!eof())

				IF ALLTRIM(QUERYCV4->E2_TIPO) = "PA" .AND. QUERYCV4->E2_BAIXA <> "" 
					QUERYCV4->(dbsKip())
					loop
				ENDIF

				if QUERYCV4->CV4_ITEMD == cItemCta

					if QUERYCV4->E2_XCTIPI = "2"
						nXIPI := QUERYCV4->E2_XIPI * (QUERYCV4->CV4_PERCEN/100)
					else
						nXIPI := 0
					endif
					
					if QUERYCV4->E2_XCTII = "2"
						nXII := QUERYCV4->E2_XII * (QUERYCV4->CV4_PERCEN/100)
					else
						nXII := 0
					endif
					
					if QUERYCV4->E2_XCTCOF = "2"
						nXCOFINS := QUERYCV4->E2_XCOFINS * (QUERYCV4->CV4_PERCEN/100)
					else
						nXCOFINS := 0
					endif
					
					if QUERYCV4->E2_XCTPIS = "2"
						nXPIS := QUERYCV4->E2_XPIS * (QUERYCV4->CV4_PERCEN/100)
					else
						nXPIS := 0
					endif
					
					if QUERYCV4->E2_XCTICMS = "2"
						nXICMS := QUERYCV4->E2_XICMS * (QUERYCV4->CV4_PERCEN/100)
					else
						nXICMS := 0
					endif
					
					if QUERYCV4->E2_XCTSISC = "2"
						nXSISCO := QUERYCV4->E2_XSISCO * (QUERYCV4->CV4_PERCEN/100)
					else
						nXSISCO := 0
					endif
					
					if QUERYCV4->E2_XCTSDA = "2"
						nXSDA := QUERYCV4->E2_XSDA * (QUERYCV4->CV4_PERCEN/100)
					else
						nXSDA := 0
					endif
					
					if QUERYCV4->E2_XCTTEM = "2"
						nXTERM := QUERYCV4->E2_XTERM * (QUERYCV4->CV4_PERCEN/100)
					else
						nXTERM := 0
					endif
					
					if QUERYCV4->E2_XCTTRAN = "2"
						nXTRANSP := QUERYCV4->E2_XTRANSP * (QUERYCV4->CV4_PERCEN/100)
					else
						nXTRANSP := 0
					endif
					
					if QUERYCV4->E2_XCTFRET = "2"
						nXFRETE := QUERYCV4->E2_XFRETE * (QUERYCV4->CV4_PERCEN/100)
					else
						nXFRETE := 0
					endif
					
					if QUERYCV4->E2_XCTFUM = "2"
						nXFUMIG := QUERYCV4->E2_XFUMIG * (QUERYCV4->CV4_PERCEN/100)
					else
						nXFUMIG := 0
					endif
					
					if QUERYCV4->E2_XCTARM = "2"
						nXARMAZ := QUERYCV4->E2_XARMAZ * (QUERYCV4->CV4_PERCEN/100)
					else
						nXARMAZ := 0
					endif
					
					if QUERYCV4->E2_XCTAFRM = "2"
						nXAFRMM := QUERYCV4->E2_XAFRMM * (QUERYCV4->CV4_PERCEN/100)
					else
						nXAFRMM := 0
					endif
					
					if QUERYCV4->E2_XCTCAPA = "2"
						nXCAPA := QUERYCV4->E2_XCAPA * (QUERYCV4->CV4_PERCEN/100)
					else
						nXCAPA := 0
					endif
					
					if QUERYCV4->E2_XCTCOM = "2"
						nXCOMIS := QUERYCV4->E2_XCOMIS * (QUERYCV4->CV4_PERCEN/100)
					else
						nXCOMIS := 0
					endif
					
					if QUERYCV4->E2_XCTISS = "2"
						nXISS := QUERYCV4->E2_XISS * (QUERYCV4->CV4_PERCEN/100)
					else
						nXISS := 0
					endif
					
					if QUERYCV4->E2_XCTIRRF = "2"
						nXIRRF := QUERYCV4->E2_XIRRF * (QUERYCV4->CV4_PERCEN/100)
					else
						nXIRRF := 0
					endif

					if !ALLTRIM(QUERYCV4->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
						nTotCusto		+= QUERYCV4->CV4_VALOR - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
					endif
					nTotCTot		+= QUERYCV4->CV4_VALOR - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
					
				endif

				QUERYCV4->(dbskip())

			enddo
			//**** fim custo CV4
			//**** inicio custo SZ4
			cForSZ4 		:= "ALLTRIM(QUERYSZ4->Z4_ITEMCTA) == cItemCta"
			ChkFile("SZ4",.F.,"QUERYSZ4") // Alias dos movimentos bancarios
			IndRegua("QUERYSZ4",CriaTrab(NIL,.F.),"Z4_FILIAL+Z4_ITEMCTA",,cForSZ4,"Selecionando Registros...")
			ProcRegua(QUERYSZ4->(reccount()))
			QUERYSZ4->(dbgotop())

			while QUERYSZ4->(!eof())
				if QUERYSZ4->Z4_ITEMCTA == cItemCta
					nTotCusto		+= QUERYSZ4->Z4_TOTVLR
					nTotCTot		+= QUERYSZ4->Z4_TOTVLR
				endif
				QUERYSZ4->(dbskip())
			enddo
			//**** fim custo SZ4
			//**** inicio custo ZZA
			cForZZA := "ALLTRIM(QUERYZZA->ZZA_ITEMIC) == _cItemConta"
			ZZA->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

			ChkFile("ZZA",.F.,"QUERYZZA") // Alias dos movimentos bancarios
			IndRegua("QUERYZZA",CriaTrab(NIL,.F.),"ZZA_DATA",,cForZZA,"Selecionando Registros...")
			ProcRegua(QUERYZZA->(reccount()))

			QUERYZZA->(dbgotop())

			while QUERYZZA->(!eof())

				if QUERYZZA->ZZA_ITEMIC == cItemCta
					nTotCusto	+= QUERYZZA->ZZA_VALOR
					nTotCTot	+= QUERYZZA->ZZA_VALOR
				endif

				QUERYZZA->(dbskip())

			enddo
			//**** fim custo ZZA
		
	//*******************
			QUERY2->(dbskip())

		if !cItemCta  $ ("ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES")		
			RecLock("TRB3Z",.T.)
				TRB3Z->ZITEM		:= cValTochar(nContador) + "1"
				TRB3Z->ZDESCRI	:= "Custo Producao Planejado"
				TRB3Z->ZVALOR	:= POSICIONE("CTD",1,XFILIAL("CTD")+cItemCta,"CTD_XCUPRR")
				TRB3Z->ZITEMIC	:= cItemCta
				TRB3Z->ZTIPCUSTO := "PLNPRD"
			MsUnlock()
			RecLock("TRB3Z",.T.)
				TRB3Z->ZITEM		:= cValTochar(nContador) + "2"
				TRB3Z->ZDESCRI	:= "Custo Total Planejado"
				TRB3Z->ZVALOR	:= POSICIONE("CTD",1,XFILIAL("CTD")+cItemCta,"CTD_XCUTOR")
				TRB3Z->ZITEMIC	:= cItemCta
				TRB3Z->ZTIPCUSTO := "PLNTOT"
			MsUnlock()
			//RecLock("TRB3",.T.)
			//	TRB3->CITEM		:= cValTochar(nContador) + "3"
			//	TRB3->CDESCRI	:= "Verba Adicional"
			//	TRB3->CVALOR	:= POSICIONE("CTD",1,XFILIAL("CTD")+cItemCta,"CTD_XVBAD")
			//	TRB3->CITEMIC	:= cItemCta
			//MsUnlock()
			RecLock("TRB3",.T.)
				TRB3Z->ZITEM		:= cValTochar(nContador) + "3"
				TRB3Z->ZDESCRI	:= "Custo Producao Empenhado"
				TRB3Z->ZVALOR	:= nTotCusto
				TRB3Z->ZITEMIC	:= cItemCta
				TRB3Z->ZTIPCUSTO := "EMPPRD"
			MsUnlock()
			RecLock("TRB3Z",.T.)
				TRB3Z->ZITEM		:= cValTochar(nContador) + "4"
				TRB3Z->ZDESCRI	:= "Custo Total Empenhado"
				TRB3Z->ZVALOR	:= nTotCTot
				TRB3Z->ZITEMIC	:= cItemCta
				TRB3Z->ZTIPCUSTO := "EMPTOT"
			MsUnlock()
			RecLock("TRB3Z",.T.)
				TRB3Z->ZITEM		:= cValTochar(nContador) + "5"
				TRB3Z->ZDESCRI	:= "------------------------------"
				TRB3Z->ZVALOR	:= 0
				TRB3Z->ZITEMIC	:= "------------------------------"
				TRB3Z->ZTIPCUSTO := "------"
			MsUnlock()
			nTotCusto 	:= 0
			nTotCTot 	:= 0
		endif
			nContador := nContador + 1
			//QUERY->(dbclosearea())
			QUERYSC7->(dbclosearea())
			QUERYSM2->(dbclosearea())
			QUERYSD1->(dbclosearea())
			QUERYSDE->(dbclosearea())
			QUERYSE2->(dbclosearea())
			QUERYCV4->(dbclosearea())
			QUERYSZ4->(dbclosearea())
			QUERYZZA->(dbclosearea())
		
	enddo

	//QUERY->(dbclosearea())
	QUERY2->(dbclosearea())
	
return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Gera Arquivo em Excel e abre                               ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
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
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Gera Arquivo em Excel e abre                               ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
Static Function geraCSV(_cAlias,_cFiltro,aHeader) //aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)

local cDirDocs  := MsDocPath()
Local cArquivo 	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX
Local _ni

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
	MsgAlert("Falha na criaï¿½ï¿½o do arquivo")
Endif

(_cAlias)->(dbclearfil())

Return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Abre os arquivos necessarios                               ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
static function AbreArq()
local aStru 	:= {}

local _cCpoAtu
local _ni

if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Nï¿½o foi possï¿½vel abrir o arquivo GCIN01.XLS pois ele pode estar aberto por outro usuï¿½rio.")
	return(.F.)
endif

// monta arquivo analitico TRB1
aAdd(aStru,{"ITEM"		,"C",06,0})		// ITEM
aAdd(aStru,{"CODPROD"	,"C",30,0})		// CODIGO DO PRODUTO
aAdd(aStru,{"PRODUTO"	,"C",80,0})		// DESCRICAO PRODUTO
aAdd(aStru,{"NUM"		,"C",06,0})		// NUMERO OC
aAdd(aStru,{"DATAMOV"	,"D",08,0}) 	// EMISSAO
aAdd(aStru,{"DATAMOV2"	,"D",08,0}) 	// ENTREGA
aAdd(aStru,{"FORNECE"	,"C",10,0})		// CODIGO FORNECEDOR
aAdd(aStru,{"NOME"		,"C",60,0})		// NOME FORNECEDOR
aAdd(aStru,{"LOJA"		,"C",02,0})		// LOJA
aAdd(aStru,{"QUANT"		,"N",15,6})		// QUANTIDADE
aAdd(aStru,{"UM"		,"C",02,0})		// UNIDADE
aAdd(aStru,{"PRECO"		,"N",15,2})		// PRECO
aAdd(aStru,{"XVDCI"		,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"XVDSI"		,"N",15,2})		// TOTAL SEM TRIBUTOS
aAdd(aStru,{"PRECO2"	,"N",15,2})		// PRECO
aAdd(aStru,{"XVDCI2"	,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"XVDSI2"	,"N",15,2})		// TOTAL SEM TRIBUTOS
aAdd(aStru,{"ITEMCONTA"	,"C",13,0})
aAdd(aStru,{"IPI"		,"N",15,2})		// % IPI
aAdd(aStru,{"ICM"		,"N",15,2})		// % ICMS
aAdd(aStru,{"XPCOF"		,"N",15,2})		// % COFINS
aAdd(aStru,{"XPPIS"		,"N",15,2})		// % PIS
aAdd(aStru,{"XAPRN1"	,"C",06,0})		// % Aprovaï¿½ï¿½o Coordenador
aAdd(aStru,{"XAPRN2"	,"C",06,0})		// % Aprovaï¿½ï¿½o Diretoria
aAdd(aStru,{"XCTRVB"	,"C",01,0})		// % Status aprovaï¿½ï¿½o
aAdd(aStru,{"DESCR"		,"C",40,0})		// STATUS DO PEDITO
aAdd(aStru,{"XAPRN3"	,"C",06,0})		// % Aprovaï¿½ï¿½o Diretoria

aadd(_aCpos , "ITEM")		// 1
aadd(_aCpos , "CODPROD")	// 2
aadd(_aCpos , "PRODUTO")	// 3
aadd(_aCpos , "QUANT")		// 4
aadd(_aCpos , "UM")			// 5
aadd(_aCpos , "PRECO")		// 6
aadd(_aCpos , "XVDCI")		// 7
aadd(_aCpos , "XVDSI") 		// 8
aadd(_aCpos , "ITEMCONTA")  // 9
aadd(_aCpos , "DATAMOV2")   // 10
aadd(_aCpos , "IPI")		// 11
aadd(_aCpos , "ICM")		// 12
aadd(_aCpos , "XPCOF")		// 13
aadd(_aCpos , "XPPIS")		// 14
aadd(_aCpos , "XAPRN1")		// 15
aadd(_aCpos , "XAPRN2")		// 16
aadd(_aCpos , "XCTRVB")		// 17
aadd(_aCpos , "NUM")		// 18
aadd(_aCpos , "XAPRN3")		// 16

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)

//****************
aStru := {}
aAdd(aStru,{"NUM"		,"C",06,0})		// NUMERO OC
aAdd(aStru,{"DATAMOV"	,"D",08,0}) 	// EMISSAO
aAdd(aStru,{"FORNECE"	,"C",10,0})		// CODIGO FORNECEDOR
aAdd(aStru,{"NOME"		,"C",60,0})		// NOME FORNECEDOR
aAdd(aStru,{"LOJA"		,"C",02,0})		// LOJA
aAdd(aStru,{"XVDCI"		,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"XVDSI"		,"N",15,2})		// TOTAL SEM TRIBUTOS
aAdd(aStru,{"MOEDA"		,"N",3,0})		// TOTAL SEM TRIBUTOS
aAdd(aStru,{"MOEDAD"	,"C",03,0})		// LOJA
aAdd(aStru,{"XVDCI2"	,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"XVDSI2"	,"N",15,2})		// TOTAL SEM TRIBUTOS
aAdd(aStru,{"ITEMCONTA"	,"C",13,0})
aAdd(aStru,{"DESCR"		,"C",70,0})		// STATUS DO PEDITO
aAdd(aStru,{"XAPRN1"	,"C",06,0})		// APROVACAO NIVEL 1
aAdd(aStru,{"XAPRN1D"	,"C",40,0})		// APROVACAO NIVEL 1 DESCRICAO
aAdd(aStru,{"XAPRN3"	,"C",06,0})		// APROVACAO NIVEL 2
aAdd(aStru,{"XAPRN3D"	,"C",40,0})		// APROVACAO NIVEL 2 DESCRICAO
aAdd(aStru,{"XAPRN2"	,"C",06,0})		// APROVACAO NIVEL 3
aAdd(aStru,{"XAPRN2D"	,"C",40,0})		// APROVACAO NIVEL 3 DESCRICAO	
aAdd(aStru,{"XCTRVB"	,"C",01,0})	
aAdd(aStru,{"DESPESA"		,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"SEGURO"		,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"VALFRE"		,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"VALIPI"		,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"ICMSRET"		,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"VLDESC"		,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"TOTPCI"		,"N",15,2})		// TOTAL PEDIDO
aAdd(aStru,{"TOTPSI"		,"N",15,2})		// TOTAL PEDIDO

_nCampos := len(_aCpos)
aadd(_aCpos2 , "NUM")		// 17
dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
index on NUM to &(cArqTrb2+"2")
index on NUM to &(cArqTrb2+"1")
set index to &(cArqTrb2+"1")

/******** CAMPOS PAGAMENTO PLANEJADO ***************/
aStru := {}
aAdd(aStru,{"PPTIPO"	,"C",15,0}) // Tipo de faturamento
aAdd(aStru,{"PPDTMOV"	,"D",08,0}) // data movimentaï¿½ï¿½o
aAdd(aStru,{"PPDOCTO"	,"C",15,0}) // numero documento
aAdd(aStru,{"PPTPDOC"	,"C",15,0}) // numero documento
aAdd(aStru,{"PPVLRDC"	,"N",15,2}) // valor documento R$
aAdd(aStru,{"PPVLRDC2"	,"N",15,2}) // valor documento
aAdd(aStru,{"PNATURE"	,"C",13,0}) // natureza
aAdd(aStru,{"PPMOEDA"	,"N",02,0}) // moeda
aAdd(aStru,{"PPTXMOE"	,"N",15,4}) // taxa moeda
aAdd(aStru,{"PPBENEF"	,"C",40,0}) // Descricao
aAdd(aStru,{"PPHIST"	,"C",80,0}) // Descricao
aAdd(aStru,{"PPICTA"	,"C",13,0}) // contrato
aAdd(aStru,{"PPFORNE"	,"C",10,0}) // Codigo Cliente / Fornecedor
aAdd(aStru,{"PPNFORN"	,"C",20,0}) // Nome Cliente / Fornecedor
aAdd(aStru,{"PPLOJA"	,"C",02,0}) // Loja
aAdd(aStru,{"PPPREF"	,"C",03,0}) // Prefixo
aAdd(aStru,{"PPNTIT"	,"C",09,0}) // Numero de Titulo
aAdd(aStru,{"PPPARCEL"	,"C",01,0}) // Parcela
aAdd(aStru,{"PPDTMOV2"	,"D",08,0}) // data movimentaï¿½ï¿½o

dbcreate(cArqTrb9,aStru)
dbUseArea(.T.,,cArqTrb9,"TRB9",.F.,.F.)
index on PPDTMOV2 to &(cArqTrb9+"1")
set index to &(cArqTrb9+"1")

/******** CAMPOS PAGAMENTO PLANEJADO 2***************/
aStru := {}
aAdd(aStru,{"XPTIPO"	,"C",15,0}) // Tipo de faturamento
aAdd(aStru,{"XPDTMOV"	,"D",08,0}) // data movimentaï¿½ï¿½o
aAdd(aStru,{"XPDOCTO"	,"C",15,0}) // numero documento
aAdd(aStru,{"XPTPDOC"	,"C",15,0}) // numero documento
aAdd(aStru,{"XPVLRDC"	,"N",15,2}) // valor documento R$
aAdd(aStru,{"XPVLRDC2"	,"N",15,2}) // valor documento
aAdd(aStru,{"XNATURE"	,"C",13,0}) // natureza
aAdd(aStru,{"XPMOEDA"	,"N",02,0}) // moeda
aAdd(aStru,{"XPTXMOE"	,"N",15,4}) // taxa moeda
aAdd(aStru,{"XPBENEF"	,"C",40,0}) // Descricao
aAdd(aStru,{"XPHIST"	,"C",80,0}) // Descricao
aAdd(aStru,{"XPICTA"	,"C",13,0}) // contrato
aAdd(aStru,{"XPFORNE"	,"C",10,0}) // Codigo Cliente / Fornecedor
aAdd(aStru,{"XPNFORN"	,"C",20,0}) // Nome Cliente / Fornecedor
aAdd(aStru,{"XPLOJA"	,"C",02,0}) // Loja
aAdd(aStru,{"XPPREF"	,"C",03,0}) // Prefixo
aAdd(aStru,{"XPNTIT"	,"C",09,0}) // Numero de Titulo
aAdd(aStru,{"XPPARCEL"	,"C",01,0}) // Parcela
aAdd(aStru,{"XPDTMOV2"	,"D",08,0}) // data movimentaï¿½ï¿½o

dbcreate(cArqTrb9X,aStru)
dbUseArea(.T.,,cArqTrb9X,"TRB9X",.F.,.F.)
index on XPDTMOV2 to &(cArqTrb9X+"1")
set index to &(cArqTrb9X+"1")

aStru := {}
aAdd(aStru,{"CITEM"		,"C",02,0}) // numero de item adicionado
aAdd(aStru,{"CDESCRI"	,"C",30,0}) // descricao do custo
aAdd(aStru,{"CVALOR"	,"N",15,2}) // valor custo atual contrato
aAdd(aStru,{"CITEMIC"	,"C",13,0}) // numero de item adicionado
aAdd(aStru,{"CTIPCUSTO"	,"C",06,0}) // tipo de custo

dbcreate(cArqTrb3,aStru)
dbUseArea(.T.,,cArqTrb3,"TRB3",.F.,.F.)
index on CITEM to &(cArqTrb3+"1")
set index to &(cArqTrb3+"1")

aStru := {}
aAdd(aStru,{"ZITEM"		,"C",02,0}) // numero de item adicionado
aAdd(aStru,{"ZDESCRI"	,"C",30,0}) // descricao do custo
aAdd(aStru,{"ZVALOR"	,"N",15,2}) // valor custo atual contrato
aAdd(aStru,{"ZITEMIC"	,"C",13,0}) // numero de item adicionado
aAdd(aStru,{"ZTIPCUSTO"	,"C",06,0}) // tipo de custo

dbcreate(cArqTrb3Z,aStru)
dbUseArea(.T.,,cArqTrb3Z,"TRB3Z",.F.,.F.)
index on ZITEM to &(cArqTrb3Z+"1")
set index to &(cArqTrb3Z+"1")



return(.T.)


//--------------------------------------------------------------------------------------------


///////////////////////////////////////////////
static function VldParamFR()

/*

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
	endif*/

return(.T.)


/************************************************************************/
/* IMPRIMIR PEDIDO COMPRA												*/
/************************************************************************/
/************************************************************************/


Static Function zImpriPC()


Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa


If Select("PEDCOMIR") <> 0
	PEDCOMIR->( DbCLoseArea() )
End


MontaRel()
//Processa({|lEnd|MontaRel(),"Imprimindo Pedido Compras","AGUARDE.."})

//oAnexCham1:setfocus

//ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

Return Nil


//********************************************************************************************


Static Function MontaRel()

Local nD, nP , nC, _cObs
Local nValor 		:= 1
Private cTipoCont := ""
Private nTotalCom2 := 0
Private cRequer := ""
Private _cObsItem := ""
Private nCont  := 0
Private nCont1 := 1
Private Cont   := 1
Private Cont1  := 15
Private oPrint,oFont7,oFont7n,oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont16,oFont16n,oFont20,oFont24,oFont9b
Private aDadosEmp	:=	{SM0->M0_NOMECOM,; //Nome da Empresa - 1
SM0->M0_ENDCOB ,; //Endereï¿½o - 2ï¿½
AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+" - " + SM0->M0_ESTCOB,;  // + " - " + SM0->M0_UFCOB,;//Complemento - 3
Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3),; //CEP - 4
SM0->M0_TEL,; //Telefones - 5
Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+; // CNPJ - 6
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+;
Subs(SM0->M0_CGC,13,2),; //CGC
Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+; // INSCR. ESTADUAL - 7
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3),;
Subs(SM0->M0_CIDENT,1,20)} //Cidade da

//Parï¿½metros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont7  := TFont():New("Calibri",8,7 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7n := TFont():New("Calibri",8,7 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8  := TFont():New("Calibri",8,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7a  := TFont():New("Arial",8,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7an  := TFont():New("Arial",8,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8n := TFont():New("Calibri",8,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Calibri",8,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9b := TFont():New("Calibri",8,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9n := TFont():New("Calibri",8,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Calibri",8,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11 := TFont():New("Calibri",8,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12 := TFont():New("Calibri",8,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13 := TFont():New("Calibri",8,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14 := TFont():New("Calibri",8,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Calibri",8,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Calibri",8,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20 := TFont():New("Calibri",8,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Calibri",8,24,.T.,.T.,5,.T.,5,.T.,.F.)
oFont28 := TFont():New("Calibri",8,28,.T.,.T.,5,.T.,5,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';

oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)

oPrint:= TMSPrinter():New("PedCom")
//oPrint:SetPortrait() // ou SetLandscape()
oPrint:SetLandScape()
oPrint:SetPaperSize(9)

/*//=========
oPrint := TmsPrinter():New()

oPrint:SetPortrait() ( Para Retrato) ou
oPrint:SetLandScape() ( Para Paisagem )

oPrint:SetPaperSize(1)     ( 1 - Carta ) ou
oPrint:SetPaperSize(9)     ( 9 - A4 )
//========*/


oPrint:Setup() // para configurar impressora

cFileLogo := "lgrl" + cEmpAnt + ".bmp"
DbSelectArea("SA2"); DbSetOrder(1)


cQuery := "SELECT C7_NUM, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_CONAPRO, C7_TOTAL, C7_ITEM, C7_PRODUTO, C7_QTSEGUM, C7_SEGUM, C7_IPI, C7_ALIQISS, C7_PICM, C7_XXDTREV, C7_ICMSRET, C7_CONTATO,"
cQuery += "       C7_COND, C7_TPFRETE, C7_FRETE, C7_CC, C7_CONTA, C7_DESCRI, C7_QUANT, C7_PRECO, C7_XXREV, C7_MOEDA, R_E_C_N_O_ NRECNO, ISNULL( CONVERT( VARCHAR(4096), CONVERT(VARBINARY(4096), C7_XNOTAS)),'') AS C7_XNOTAS,  "
cQuery += "       C7_DATPRF, C7_UM, C7_VALIPI, C7_USER, C7_APROV, C7_OBS, ISNULL( CONVERT( VARCHAR(4096), CONVERT(VARBINARY(4096), C7_XMEMO)),'') AS C7_XMEMO, C7_DESC, C7_NUMSC, C7_ITEMCTA, C7_MSG, C7_REAJUST, C7_DESPESA, C7_SEGURO, C7_VALFRE, C7_VLDESC "
cQuery += " FROM " + RetSQLName("SC7") + " SC7 "
cQuery += "WHERE C7_FILIAL = '" + XFILIAL("SC7") + "' AND "
cQuery += "C7_NUM     >= '" + cNum + "' AND  "
//cQuery += "C7_EMISSAO >= '" + DTOS(MV_PAR07) + "' AND  "
//cQuery += "C7_EMISSAO <= '" + DTOS(MV_PAR08) + "' AND  "
//cQuery += "C7_PRODUTO >= '" + MV_PAR09 + "' AND  "
//cQuery += "C7_PRODUTO <= '" + MV_PAR10 + "' AND  "
cQuery += "C7_CONAPRO <> 'B' AND "
cQuery += "SC7.D_E_L_E_T_ <> '*'"
cQuery += "ORDER BY C7_NUM, C7_ITEM"
cQuery := ChangeQuery(cQuery)

dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),"PEDCOMIR", .F., .T.)
TcSetField( "PEDCOMIR", "C7_EMISSAO" , "D", 8, 0 )
// TcSetField( "PEDCOMIR", "C7_DATPRF"  , "D", 8, 0 )


DbSelectArea("PEDCOMIR")
DbGoTop()

_cObs := "1 - A mercadoria sera aceita somente se, na sua Nota Fiscal constar o numero do nosso Pedido de Compra."
//_cObs := "1 - Somente aceitaremos a mercadoria se a na sua Nota Fiscal constar o numero do nosso Pedido de Compras."

Do While !PEDCOMIR->(Eof())
	SA2->(DbSeek( xFilial("SA2") + PEDCOMIR->C7_FORNECE + PEDCOMIR->C7_LOJA) )
	cCodCredor 		:= alltrim(SA2->A2_COD)
	cLojaCredor		:= SA2->A2_LOJA
	cNomeCredor 	:= Alltrim(SA2->A2_NOME)
	cCGC        	:= SA2->A2_CGC
	cEnd        	:= Alltrim(SA2->A2_END)
	cBairro			:= Alltrim(SA2->A2_BAIRRO)
	cCidade			:= Alltrim(SA2->A2_MUN)
	cDDI			:= Alltrim(SA2->A2_DDI)
	cDDD			:= Alltrim(SA2->A2_DDD)
	cTel        	:= Alltrim(SA2->A2_TEL)
	cMun        	:= Alltrim(SA2->A2_MUN)
	cEst        	:= SA2->A2_EST
	cPAIS			:= SA2->A2_PAIS
	cEmail			:= Alltrim(SA2->A2_EMAIL)
	cCEP			:= Alltrim(SA2->A2_CEP)
	cINSCR			:= Alltrim(SA2->A2_INSCR)
	cINSCRM			:= Alltrim(SA2->A2_INSCRM)
	cTemCredor  	:= .T.
	cNaoBloqueado	:= .T.
	cTemCredor    	:= .F.
	cNumPed       	:= PEDCOMIR->C7_Num
	cCodFor       	:= PEDCOMIR->C7_Fornece
	cNumSC			:= PEDCOMIR->C7_NUMSC
	aDados        	:= {}
	cObserv       	:= PEDCOMIR->C7_OBS
	dDataEmi		:= PEDCOMIR->C7_EMISSAO
	nRevisao		:= PEDCOMIR->C7_XXREV
	dRevisao		:= PEDCOMIR->C7_XXDTREV
	cMoeda			:= PEDCOMIR->C7_MOEDA
	cContato		:= PEDCOMIR->C7_CONTATO
	//dDataEnt		:= PEDCOMIR->C7_DATPRF
	_cSolic__		:= Posicione("SC1",1,xFilial("SC1") + PEDCOMIR->C7_NUMSC,"C1_USER")
	_cCompr__		:= Posicione("SY1",3,xFilial("SY1") + PEDCOMIR->C7_USER,"Y1_NOME")
	_cCompr2__		:= Posicione("SY1",3,xFilial("SY1") + PEDCOMIR->C7_USER,"Y1_USER")
	_cAprov__		:= Posicione("SAK",1,xFilial("SAK") + PEDCOMIR->C7_APROV,"AK_NOME")
	nTotGeral 		:= 0
	nTotalIPI 		:= 0
	nTotalIPI 		:= 0
	nTotalDesc		:= 0
	nTotalDesp		:= 0
	nTotalSeg		:= 0
	nTotalFrete		:= 0
	nTotalProd		:= 0
	nTotalCom  		:= 0
	nSubTotal  		:= 0
	nTotalICMSRET	:= 0
	nTotPdSIPI		:= 0
	cCondPagto		:= Posicione("SE4",1,xFilial("SE4") + PEDCOMIR->C7_COND,"E4_DESCRI") 	//cCondPagto		:= PEDCOMIR->C7_COND + " - " + Posicione("SE4",1,xFilial("SE4") + PEDCOMIR->C7_COND,"E4_DESCRI")
	cTipoFrete		:= IF(PEDCOMIR->C7_TPFRETE = "F","FOB","CIF") +  Transform(PEDCOMIR->C7_FRETE,"@E 999,999.99")
	cFormula		:= Posicione("SM4",1,xFilial("SM4") + PEDCOMIR->C7_MSG,"M4_CODIGO")
	cFormula2		:= Posicione("SM4",1,xFilial("SM4") + PEDCOMIR->C7_REAJUST,"M4_CODIGO")
	cXMEMO       	:= MSMM(PEDCOMIR->C7_XMEMO)
	cXNOTAS       	:= MSMM(PEDCOMIR->C7_XNOTAS)

	

	//cProdIngles		:= Posicione("SB1",1,xFilial("SB1") + PEDCOMIR->C7_PRODUTO,"B1_XXDI")

		if substr(alltrim(PEDCOMIR->C7_ITEMCTA),1,2) $ "AT/PR/EN/EQ/GR/ST" 
			cRequer := "1"
		elseif alltrim(PEDCOMIR->C7_ITEMCTA) == "ESTOQUE" 
			cRequer := "1"
		elseif alltrim(PEDCOMIR->C7_ITEMCTA) $ "ADMINISTRACAO/QUALIDADE/ENGENHARIA/PROPOSTA/ATIVO/ZZZZZZZZZZZZZ/XXXXXX" .AND. EMPTY(cRequer)
			cRequer := "2"
		endif

	Do While !Eof() .And. PEDCOMIR->C7_NUM == cNumPed
		TcSetField( "PEDCOMIR", "C7_EMISSAO" , "D", 8, 0 )
		aAdd(aDados,{PEDCOMIR->C7_ITEM,;	// 1
		PEDCOMIR->C7_DATPRF,;          		// 2
		Trim(PEDCOMIR->C7_DESCRI),;      	// 3
		PEDCOMIR->C7_QUANT,;             	// 4
		PEDCOMIR->C7_PRECO,;              	// 5
		PEDCOMIR->C7_TOTAL,;             	// 6
		PEDCOMIR->C7_PRODUTO,;				// 7
		PEDCOMIR->C7_UM,;            		// 8
		PEDCOMIR->C7_VALIPI,;           	// 9
		PEDCOMIR->C7_DESC,;					// 10
		PEDCOMIR->C7_OBS,;                	// 11
		PEDCOMIR->C7_ITEMCTA,;            	// 12
		PEDCOMIR->C7_DESPESA,;            	// 13
		PEDCOMIR->C7_SEGURO,;            	// 14
		PEDCOMIR->C7_VALFRE,;            	// 15
		PEDCOMIR->C7_VLDESC,;            	// 16
		PEDCOMIR->C7_CC,;					// 17
		PEDCOMIR->C7_XXREV,;				// 18
		PEDCOMIR->C7_QTSEGUM,;				// 19
		PEDCOMIR->C7_SEGUM,;				// 20
		PEDCOMIR->C7_IPI,;					// 21
		PEDCOMIR->C7_PICM,;					// 22
		PEDCOMIR->C7_ALIQISS,;				// 23
		PEDCOMIR->C7_ICMSRET,;				// 24
		PEDCOMIR->C7_XMEMO,;				// 25
		PEDCOMIR->C7_XNOTAS})				// 26
		
		nTotalProd	+= PEDCOMIR->C7_TOTAL	//Totalizando Valor do produto
		nTotalDesc	+= PEDCOMIR->C7_VLDESC  //Totalizando Descontos
		nTotalDesp  += PEDCOMIR->C7_DESPESA // Totalizando Despesas
		nTotalSeg	+= PEDCOMIR->C7_SEGURO // Totalizando Seguro
		nTotalFrete	+= PEDCOMIR->C7_VALFRE // Totalizando Frete
		nTotalICMSRET += PEDCOMIR->C7_ICMSRET // Totalizando ICMS Retido
		//nTotalAcre	+= aDados[nP,]  //Totalizando Acrescimo
		nTotalProd	+= PEDCOMIR->C7_PRECO	//Totalizando Valor do produto
		nTotalCom	+= (PEDCOMIR->C7_TOTAL + PEDCOMIR->C7_VALIPI + PEDCOMIR->C7_SEGURO + PEDCOMIR->C7_DESPESA + PEDCOMIR->C7_VALFRE) - (PEDCOMIR->C7_VLDESC + PEDCOMIR->C7_ICMSRET)  // Totalizando Valor do pedido de compras
		nTotalIPI 	+= PEDCOMIR->C7_VALIPI // Totalizando IPI
		cXNOTAS		:= PEDCOMIR->C7_XNOTAS
		//nTotGeral += PEDCOMIR->C7_TOTAL + PEDCOMIR->C7_VALIPI  // Totalizando Valor do pedido de compras

		DbSkip()
	EndDo

	SET FILTER TO CTD->CTD_ITEM <> 'ADMINISTRACAO' .AND. CTD->CTD_ITEM<>'PROPOSTA' .AND. CTD->CTD_ITEM<>'QUALIDADE' .AND. CTD->CTD_ITEM<>'ATIVO' ;
			 .AND. CTD->CTD_ITEM<>'ENGENHARIA' .AND. CTD->CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD->CTD_ITEM<>'XXXXXX' .AND. SUBSTR(CTD->CTD_ITEM,9,2) >= '15'
	
	nTotPdSIPI += (nTotalCom - nTotalIPI) - nTotalDesp - nTotalFrete

	//=================================== Conversão moeda
	//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )

	_cQuery := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY2"
	
	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

	//*************************

		if cMoeda = 2
			dData := dDataEmi
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA2
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA2
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
				
			enddo
			nTotalCom2		:= nTotalCom * nValor
			
		elseif cMoeda= 3
			dData := dDataEmi
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA3
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA3
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			nTotalCom2		:= nTotalCom * nValor
		elseif cMoeda = 4
			dData := dDataEmi
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA4
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA4
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			nTotalCom2		:= nTotalCom * nValor
		else
			nTotalCom2		:= nTotalCom 
		endif
		QUERY2->( DbCloseArea() )
	//===================================
	//local de de entrega usando cadastro de formulas

	dbSelectArea("SM4")
	SM4->( dbSetOrder(1) )
	If SM4->( dbSeek( xFilial("SM4")+cFormula) )
		cCODIGO  := SUBSTR(SM4->M4_FORMULA,2,6)

		If SA2->( dbSeek( xFilial("SA2")+cCODIGO) )
			ccNREDUZ  	:= SA2->A2_NREDUZ
			ccEnd		:= SA2->A2_END
			ccBairro	:= SA2->A2_BAIRRO
			ccEst		:= SA2->A2_EST
			ccMun		:= SA2->A2_MUN
			ccCEP		:= SA2->A2_CEP
			ccPAIS		:= SA2->A2_PAIS
		ENDIF

	ENDIF

	If SM4->( dbSeek( xFilial("SM4")+cFormula2) )
		//msgAlert ( cFormula2 )
		cLinha1 := SM4->M4_XNOTAL1
		cLinha2 := SM4->M4_XNOTAL2
		cLinha3 := SM4->M4_XNOTAL3
		cLinha4 := SM4->M4_XNOTAL4
		cLinha5 := SM4->M4_XNOTAL5
		cLinha6 := SM4->M4_XNOTAL6
		cLinha7 := SM4->M4_XNOTAL7
		cLinha8 := SM4->M4_XNOTAL8
		cLinha9 := SM4->M4_XNOTAL9
		cLinha10 := SM4->M4_XNOTA10
		cLinha11 := SM4->M4_XNOTA11
		cLinha12 := SM4->M4_XNOTA12
		cLinha13 := SM4->M4_XNOTA13
		cLinha14 := SM4->M4_XNOTA14

	ENDIF
	
	
	//===================================

	IF cMoeda = 1
		varSimb := "R$"
	ELSEIF cMoeda = 2
		varSimb := "US$"
	ELSEIF cMoeda = 3
		varSimb := "UFIR"
	ELSEIF cMoeda = 4
		varSimb := "EUR"
	ENDIF

	nPos	:= 0
	lchk01	:= .T.
	nCont	:= 0
	//nCont := nCont + 1     //***************************

	_cObsItem	:= ""

	For nC := 1 to Len(aDados)
		If !Empty(aDados[nc,11])
			If lchk01
				_cObsItem	:= Alltrim(aDados[nc,11]) + " - "
				lchk01 := .F.
			Else
				_cObsItem += Alltrim(aDados[nc,11]) + " - "
			Endif
		Endif

		If Cont > Cont1
			nCont1 := nCont1 + 1
			Cont := 1

		Endif
		//Cont := Cont + 1

	Next

	lEmpCab := lEmpRoda := .t.
	// Controla Qtd de Numero de Linhas Por pedido de compras Maximo de 15 linhas nos itens de um pedido
		//PEDCOMIR->C7_XMEMO,;				// 25
		//PEDCOMIR->C7_XNOTAS})				// 26
		//PEDCOMIR->C7_OBS,;                	// 11
	nLinMax	:= 18 // 19 //36 //17 //23
	nLinAtu	:= 1
	lCrtPag	:= .T.

	For nP := 1 to len(aDados)

		If  nLinAtu > nLinMax
			nCont := nCont + 1
			//oPrint:Say  (0260,1900,Transform(StrZero(ncont,3),""),oFont10)
			//oPrint:Say  (0260,1970,"de",oFont10)
			//oPrint:Say  (0260,2020,Transform(StrZero(ncont1,3),""),oFont10)

			oPrint:EndPage() // Finaliza a pï¿½gina
			lEmpCab := .t.
			lCrtPag	:= .F.
			nLinAtu := 1

			nSubTotal := 0

		Endif
		//================== Numer de paginas ==========================
		If lEmpCab
			EmpCab(_cObs)
			lEmpCab := .f.
			nPos := 0

			If lCrtPag
				nCont := nCont + 1
				//nCont1 := nCont1 + 1

				nSubTotal	+= 0
				//**********
			Endif
			// Numero de Pagina / Paginas
		   	//oPrint:Say  (0360,3100,Transform(StrZero(ncont,3),""),oFont8)
		   	oPrint:Say  (0360,3000,"Pagina " + Transform(StrZero(ncont,3),"") ,oFont8) // + " de " + Transform(StrZero(ncont1,3),"") ****
                                                          

		Endif
		//===============================================================
		_nTamStr	:= 85
		_lChkTam	:= .T.
		_nTamDesc	:= 85

		//**********
		nSubTotal	+= aDados[nP,6] + aDados[nP,9] + aDados[nP,14]  + aDados[nP,15] - aDados[nP,16] // Totalizando Valor do pedido de compras

		If nLinAtu <= nLinMax
			oPrint:Say  (0520+nPos,0060,aDados[nP,1],oFont7) //Item produto
			oPrint:Say  (0520+nPos,0140,aDados[nP,7],oFont7) //Codigo produto


			//IF MV_PAR12 = 1
				//cProdIngles		:= Posicione("SB1",1,xFilial("SB1") + aDados[nP,7],"B1_XXDI") // descriï¿½ï¿½o em ingles
				//aDadosConc := ALLTRIM(cProdIngles) + " " + ALLTRIM(aDados[nP,11]) + " " + ALLTRIM(aDados[nP,25]) 
			//ELSE
		   		aDadosConc := alltrim(Posicione("SB1",1,xFilial("SB1") + ALLTRIM(aDados[nP,7]),"B1_DESC")) + " " + ALLTRIM(aDados[nP,11]) + " " + ALLTRIM(aDados[nP,25])  // descricao em portugues ALLTRIM(aDados[nP,3])
		 	////END IF
			/*
		 	nLinhas := MLCount(ALLTRIM(aDadosConc),85)
			For nXi:= 1 To nLinhas
			        cTxtLinha := MemoLine(ALLTRIM(aDadosConc),85,nXi)
			        If ! Empty(cTxtLinha)
			               oPrint:Say(0520+nPos,470,(cTxtLinha),oFont7)
			        EndIf
			        nPos		+= 40
			Next nXi
*/

			oPrint:Say  (0520+nPos,0470,ALLTRIM(Substr(aDadosConc,1,_nTamStr)),oFont7) // Desc.Produto oPrint:Say  (0580+nPos,0370,Substr(aDados[nP,3],1,_nTamStr),oFont7)

			nLinAtu := nLinAtu + 1

			If Len(aDadosConc) > _nTamDesc  // Len(ALLTRIM(aDados[nP,3] + " " + ALLTRIM(aDados[nP,11]))) > _nTamDesc
				While _lChkTam
					nPos		+= 40
					//_nTamDesc	:= _nTamDesc + 1

					//IF MV_PAR12 = 1
						//cProdIngles		:= ALLTRIM(Posicione("SB1",1,xFilial("SB1") + aDados[nP,7],"B1_XXDI"))
						//aDadosConc := ALLTRIM(cProdIngles) + ALLTRIM(aDados[nP,11]) + " " + ALLTRIM(aDados[nP,25]) 
					//ELSE
		   				aDadosConc := ALLTRIM(aDados[nP,3]) + " " + AllTrim(aDados[nP,11]) + " " + ALLTRIM(aDados[nP,25]) 
		 			//END IF

					// aDadosConc := aDados[nP,3] + " " + aDados[nP,11]

					oPrint:Say  (0520+nPos,470,Substr(aDadosConc,_nTamDesc + 1,_nTamStr),oFont7) // Desc.Produto oPrint:Say  (0580+nPos,370,Substr(aDados[nP,3],_nTamDesc + 1,_nTamStr),oFont7)
					If Len(aDadosConc) > (_nTamDesc + _nTamStr) + 1 // Len(ALLTrim(aDados[nP,3] + " " + AllTrim(aDados[nP,11]))) > (_nTamDesc + _nTamStr) + 1
						_nTamDesc += _nTamStr
						nLinAtu := nLinAtu + 1
						Loop
					Else
						_lChkTam	:= .F.
					Endif
				Enddo
			Endif

			//oPrint:Say  (0940+nPos,0410,Posicione("SB1",1,xFilial("SB1") + aDados[nP,7],"B1_DESC"),oFont8) // Desc.Produto
			oPrint:Say  (0520+nPos,1810, Alltrim(Transform(aDados[nP,4],"@E 999,999.9999")),oFont7,20,,,1)//quantidade produto
			oPrint:Say  (0520+nPos,1850,aDados[nP,8],oFont8)//Unidade de medida
			oPrint:Say  (0520+nPos,2090, Alltrim(Transform(aDados[nP,19],"@E 999,999,999.999999")),oFont7,20,,,1) //2a. quantidade produto
			oPrint:Say  (0520+nPos,2430, Alltrim(Transform(aDados[nP,5],"@E 999,999,999.999999")),oFont7,20,,,1) //Preco do produto
			oPrint:Say  (0520+nPos,2110,aDados[nP,20],oFont8)//2a. Unidade de medida

			//IF MV_PAR12 = 1
				//oPrint:Say  (0520+nPos,2720,"0,00",oFont7)//Valor IPI
				//oPrint:Say  (0520+nPos,2790,"0,00",oFont7)//Valor ICMS
				//oPrint:Say  (0520+nPos,2890,"0,00",oFont7)//Valor ISS
			//ELSE
		   		oPrint:Say  (0520+nPos,2710,Transform(aDados[nP,21],"@E 999.99"),oFont7)//Valor IPI
		   		oPrint:Say  (0520+nPos,2800,Transform(aDados[nP,22],"@E 999.99"),oFont7)//Valor ICMS
		   		oPrint:Say  (0520+nPos,2890,Transform(aDados[nP,23],"@E 999.99"),oFont7)//Valor ISS
		 	//END IF

			oPrint:Say  (0520+nPos,2680, Alltrim(transform(aDados[nP,6],"@E 999,999,999.99")),oFont7,20,,,1)//Valor Total
			oPrint:Say  (0520+nPos,2970,Substr(aDados[nP,2],7,2) + "/" + Substr(aDados[nP,2],5,2) + "/" + Substr(aDados[nP,2],1,4),oFont7) // Data de Entrega
			oPrint:Say  (0520+nPos,3130,aDados[nP,12],oFont7) // Item contabil

			cTipoCont := Substr(aDados[nP,12],1,2)

			/*
			nTotPdSIPI = nTotalCom - nTotalIPI
			nTotalProd	+= aDados[nP,6]	//Totalizando Valor do produto
			nTotalDesc	+= aDados[nP,16]  //Totalizando Descontos
			nTotalDesp  += aDados[nP,13] // Totalizando Despesas
			nTotalSeg	+= aDados[nP,14] // Totalizando Seguro
			nTotalFrete	+= aDados[nP,15] // Totalizando Frete
			nTotalICMSRET += aDados[nP,24] // Totalizando ICMS Retido
			//nTotalAcre	+= aDados[nP,]  //Totalizando Acrescimo
			nTotalProd	+= aDados[nP,5]	//Totalizando Valor do produto
			nTotalCom	+= (aDados[nP,6] + aDados[nP,9] + aDados[nP,14] + aDados[nP,13] + aDados[nP,15]) - (aDados[nP,16] + aDados[nP,24])  // Totalizando Valor do pedido de compras
			nTotalIPI 	+= aDados[nP,9] // Totalizando IPI
			*/

			If nLinAtu = nLinMax - 1 .OR. nLinAtu = nLinMax
				//************
				oPrint:Say  (1400,3250, alltrim(transform(nSubTotal ,"@E 999,999,999.99")),oFont11,20,,,1)// SubTotal do pedido de compras
				//************

			End if

			nPos  += 40
			nLinAtu := nLinAtu + 1

		EndIf

	Next

	//oPrint:Say  (2030,2900,varSimb + " " + transform(nTotalCom ,"@E 999,999,999.99"),oFont12)// Total do pedido de compras


	DbSelectArea("PEDCOMIR")

	nCont := nCont + 1 //==============
	nCont1 := nCont1 + 1 //==============


	If EOF() = .T.
		//nTotPdSIPI = nTotalCom - nTotalIPI

		//oPrint:Say  (1470,3250, alltrim(transform(nSubTotal ,"@E 999,999,999.99")),oFont11,20,,,1)// SubTotal do pedido de compras
		/*
		oPrint:Say  (1530,3250, alltrim(transform(nTotPdSIPI ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Produtos sem IPI
		oPrint:Say  (1590,3250, alltrim(transform(nTotalSeg ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando Seguro
		oPrint:Say  (1650,3250, alltrim(transform(nTotalFrete ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando Frete
		oPrint:Say  (1710,3250, alltrim(transform(nTotalDesp ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Despesa
		oPrint:Say  (1770,3250, alltrim(transform(nTotalIPI ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando IPI
		//oPrint:Say  (2110,2570,varSimb + " " + transform(nSubTotal ,"@E 999,999,999.99"),oFont11)// SubTotal do pedido de compras
		oPrint:Say  (1830,3250, alltrim(transform(nTotalDesc ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Desconto
		oPrint:Say  (1890,3250, alltrim(transform(nTotalICMSRET ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando ICMS ST
		oPrint:Say  (1950,3250, alltrim(transform(nTotalCom ,"@E 999,999,999.99")),oFont12,20,,,1)      // Total do pedido de compras
		*/
	EndIf


	oPrint:EndPage() // Finaliza a pï¿½gina

Enddo


oPrint:EndPage() // Finaliza a pï¿½gina

PEDCOMIR->( DbCloseArea() )
//================================================



//If Mv_par11 == 2
	oPrint:Preview()  // Visualiza antes de imprimir
/*Else
	oPrint:Print() // Imprime direto na impressora default do AP5
End*/


Return nil


//*****************************************************************************************
//|------------------------------------------------------------------------|
//| Impressao do corpo do pedido de compras                                |
//|------------------------------------------------------------------------|
Static Function EMPCAB(_cObs)
local nXi
Local cGrup := ""
Local cGrup2 := ""
Local cGrup3 := ""

Private cUserCoord := ""

//IF MV_PAR12 == 2
		//... Impressao do cabecalho
		oPrint:StartPage()   // Inicia uma nova pï¿½gina

		// Cabecalho
		//oPrint:FillRect({0050,0050,0190,0740},oBrush2)

		oPrint:Box	(0050,0050,0510,3300) //Box Cabeï¿½a

		oPrint:Box	(0050,0050,0190,0740) // logo
		oPrint:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrint:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Dados da Empresa
		oPrint:Box	(0050,0050,0410,0740) // Empresa
		// oPrint:Say  ( 0220,0580,"Empresa " ,oFont9n)
		oPrint:Say  ( 0210,0060,ALLTRIM(aDadosEmp[2]),oFont8)   // Endereco
		oPrint:Say  ( 0250,0060,aDadosEmp[3] + " - " + "BRASIL - " + "CEP: " + aDadosEmp[4] ,oFont8) // CEP
		oPrint:Say  ( 0290,0060,"Tel.: " + "55-11-3234-5400 - Fax: 55-11-3234-5423" ,oFont8) // TEL
		oPrint:Say  ( 0330,0060,"CNPJ: " + aDadosEmp[6] + " - " + "Insc.Est. - " + aDadosEmp[7] ,oFont8) // CNPJ
		oPrint:Say  ( 0370,0060,"Insc. Municipal: 3.489.047-5",oFont8)
		//oPrint:Say  ( 0370,0060,"E-mail NF Eletrï¿½nica: notafiscal@westech.com.br ",oFont8n)

		// Ordem de Compra
		oPrint:Box	(0050,0740,0190,1340) // Titulo Pedido
		oPrint:Say  (0070,0800,"ORDEM DE COMPRA  ",oFont14)
		oPrint:Say  (0120,0900,"No " + cNumPed,oFont14)

		oPrint:Box	(0190,0740,0350,1050) // Data Emissao
		oPrint:Say  (0220,0780,"Data Emissao " ,oFont12)
		oPrint:Say  (0280,0780,DTOC(dDataEmi) ,oFont12)


		oPrint:Box	(0190,1050,0350,1340) // Revisao
		oPrint:Say  (0220,1100,"Revisao: No: " + Transform(nRevisao, "@E 999"),oFont9)
		If EMPTY(dRevisao)
			oPrint:Say  (0280,1100,"Data: " + SPACE(3) ,oFont9)
		Else
			oPrint:Say  (0280,1100,"Data: " + Substr(dRevisao,7,2) + "/" + Substr(dRevisao,5,2) + "/" + Substr(dRevisao,1,4) ,oFont9)

		Endif

		//oPrint:Say  (0280,1090,"Nï¿½: " + Transform(nRevisao, "@E 999"),oFont8n)

		oPrint:Box	(0050,1340,0350,2400) // Fornecedor
		oPrint:Say  (0070,1350,"Fornecedor",oFont9n)
		oPrint:Say  (0110,1350, cCodCredor + " - " + cNomeCredor,oFont9n)
		oPrint:Say  (0150,1350,cEnd + " - " + cBAIRRO ,oFont8)
		oPrint:Say  (0190,1350,cMUN + " - "  + cEst + " - " + cPAIS + " - CEP: " + cCEP + " - Tel: " + cDDI + "-" + cDDD + "-" + cTel,oFont8)
		oPrint:Say  (0230,1350,"CNPJ: " + Transform(cCGC,"@R 99.999.999/9999-99") + " - " + "Inscr. Est.: " + cINSCR + " - Inscr. Mun.: " + cINSCRM  ,oFont8)
		oPrint:Say  (0270,1350,"E-mail:" + cEmail,oFont8)
		oPrint:Say  (0310,1350,"Contato: " + cContato,oFont8)

		oPrint:Box	(0050,2400,0185,3300) // Local de Entrega
		oPrint:Say  (0060,2410,"Local de Entrega: ",oFont9n)
		IF EMPTY(cFormula)
			oPrint:Say  (0100,2410, ALLTRIM( aDadosEmp[2]) ,oFont8)
			oPrint:Say  (0140,2410, ALLTRIM( aDadosEmp[3]) + " - " + ALLTRIM( aDadosEmp[4]),oFont8)

		ELSE
			oPrint:Say  (0100,2410, ALLTRIM(ccNREDUZ) + " - " + ALLTRIM(ccEND) ,oFont8)
			oPrint:Say  (0140,2410, ALLTRIM(ccBAIRRO) + " - " + ALLTRIM(ccMUN) + " - " + ALLTRIM(ccEST) + " - CEP: " + ALLTRIM(ccCEP),oFont8)
		ENDIF

		oPrint:Box	(0050,2400,0350,3300) // Local de Cobranca
		oPrint:Say  (0195,2410,"Local de Cobranca: ",oFont9n)
		oPrint:Say  (0235,2410, ALLTRIM( aDadosEmp[2]) ,oFont8)
		oPrint:Say  (0275,2410, ALLTRIM( aDadosEmp[3]) + " - " + ALLTRIM( aDadosEmp[4]),oFont8)
		oPrint:Say  (0315,2410,"E-mail NF Eletronica: notafiscal@westech.com.br ",oFont8n)

		oPrint:Box	(0350,0740,0410,3300) // Local de Cobranca
		oPrint:Say  (0360,0790,"Autorizamos o fornecimento dos seguintes materiais / servicos, conforme condicoes estabelecidas nesta ordem de compra e seus anexos. ",oFont9n)

		oPrint:Box	(0350,2900,0410,3300) // Numero Pagina
		//oPrint:Say  (0360,2920,"Pï¿½gina",oFont9)

		oPrint:Box	(0410,0050,0460,3300) // cabecalhos itens pedido
		oPrint:Box	(0410,0050,0460,1650)
		oPrint:Say  (0420,0950,"Escopo de Fornecimento",oFont7n,1800,,,1)
		oPrint:Box	(0410,2210,0460,2700)
		oPrint:Say  (0420,2350,"Precos com Impostos",oFont7n)
		oPrint:Box	(0410,2700,0460,2960)
		oPrint:Say  (0420,2730,"Impostos Inclusos",oFont7n)

		oPrint:Box	(2050,0050,2120,3300) // Cond. pag
		//oPrint:Say  (2020,1510,"Condiï¿½ï¿½o de Pagamento: ",oFont9n)
		oPrint:Say  (2060,0070,"Condicaoo de Pagamento: " + cCondPagto, oFont9n,,,0)

		oPrint:Box	(1370,2400,1480,3300)
		oPrint:Say  (1400,2420,"SubTotal pagina " + varSimb + " : ",oFont9)

		oPrint:Box	(1480,2400,1580,3300)
		oPrint:Say  (1510,2420,"Total Itens (s/ IPI) " + varSimb + " : ",oFont9)
		oPrint:Say  (1510,3250, alltrim(transform(nTotPdSIPI ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Produtos sem IPI

		oPrint:Box	(1580,2400,1820,3300)
		oPrint:Say  (1590,2420,"Seguro " + varSimb + " : ",oFont9)
		oPrint:Say  (1590,3250, alltrim(transform(nTotalSeg ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando Seguro

		//oPrint:Box	(1640,2400,1700,3300)
		oPrint:Say  (1650,2420,"Frete " + varSimb + " : ",oFont9)
		oPrint:Say  (1650,3250, alltrim(transform(nTotalFrete ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando Frete

		//oPrint:Box	(1700,2400,1940,3300)
		oPrint:Say  (1710,2420,"Despesas " + varSimb + " : ",oFont9)
		oPrint:Say  (1710,3250, alltrim(transform(nTotalDesp ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Despesa

		//oPrint:Box	(1760,2400,1820,3300)
		oPrint:Say  (1770,2420,"Total IPI " + varSimb + " : ",oFont9)
		oPrint:Say  (1770,3250, alltrim(transform(nTotalIPI ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando IPI

		oPrint:Box	(1820,2400,1940,3300)
		oPrint:Say  (1830,2420,"Desconto " + varSimb + " : ",oFont9)
		oPrint:Say  (1830,3250, alltrim(transform(nTotalDesc ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Desconto

		//oPrint:Box	(1880,2400,1940,3300)
		oPrint:Say  (1890,2420,"ICMS Subst.Tributaria " + varSimb + " : ",oFont9)
		oPrint:Say  (1890,3250, alltrim(transform(nTotalICMSRET ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando ICMS ST

		oPrint:Box	(1940,2400,2050,3300)
		oPrint:Say  (1975,2420,"Total Ordem de Compra " + varSimb + " : ",oFont12)
		oPrint:Say  (1975,3250, alltrim(transform(nTotalCom ,"@E 999,999,999.99")),oFont12,20,,,1)      // Total do pedido de compras

		// Cabecalho Itens do Pedido

		oPrint:Box	(0460,0050,0510,3300) // cabecalhos itens pedido

		oPrint:Box	(0460,0050,1370,0130) // cabecalho Item
		oPrint:Say  (0470,0060,"Item",oFont7n)

		oPrint:Box	(0460,0130,1370,0465) // cabecalho Codigo
		oPrint:Say  (0470,0200,"Codigo",oFont7n)

		oPrint:Box	(0460,0465,1370,1650) // cabecalho Descricao
		oPrint:Say  (0470,0900,"Descricao do Material e/ou Servico",oFont7n)

		oPrint:Box	(0460,1650,1370,1830) // cabecalho Quantidade
		oPrint:Say  (0470,1690,"1a Qtd.",oFont7n)

		oPrint:Box	(0460,1830,1370,1930) // cabecalho Undidade de medida
		oPrint:Say  (0470,1840,"1a Un.",oFont7n)

		oPrint:Box	(0460,1930,1370,2110) // cabecalho Quantidade
		oPrint:Say  (0470,1970,"2a Qtd.",oFont7n)

		oPrint:Box	(0460,2110,1370,2210) // cabecalho Undidade de medida
		oPrint:Say  (0470,2120,"2a Un.",oFont7n)

		oPrint:Box	(0460,2210,1370,2450) // cabecalho Preco Unitario
		oPrint:Say  (0470,2270,"Unitario " + varSimb,oFont7n)

		oPrint:Box	(0460,2450,1370,2700) // cabecalho Total
		oPrint:Say  (0470,2540,"Total " + varSimb,oFont7n)

		oPrint:Box	(0460,2700,1370,2780) // cabecalho Ipi
		oPrint:Say  (0470,2710,"IPI %",oFont7n)

		oPrint:Box	(0460,2780,1370,2880) // cabecalho Ipi
		oPrint:Say  (0470,2790,"ICMS %",oFont7n)

		oPrint:Say  (0470,2890,"ISS %",oFont7n)

		oPrint:Box	(0460,2960,1370,3120) // cabecalho Data Entrega
		oPrint:Say  (0470,2970,"Data Entrega",oFont7n)

		oPrint:Box	(0460,3120,1370,3300) // cabecalho No. Job
		oPrint:Say  (0470,3130,"Item Contabil",oFont7n)

		// Rodapï¿½
		oPrint:Box	(1370,0050,2170,3300) //

		//oPrint:Box	(1700,200,2100,3300) // Nota do Pedido
		oPrint:Say  (1375,0070,"Notas ",oFont9n)

		IF EMPTY(cFormula2) .AND. EMPTY(cXNotas)

			oPrint:Say  (1410,0070,"As Condicoes Gerais de Compras - Anexo 3 - PQ-90-0784 revisao 05 - sao parte integrante desta Ordem de compra: ",oFont7a)
			oPrint:Say  (1450,0070,"A Ordem de Compra e as Condicoes Gerais de Compra deverao ser assinadas e devolvidas em ate tres dias. A partir deste prazo serao considerados aprovadas.",oFont7a)
			oPrint:Say  (1490,0070,"Nao serao aceitas notas fiscais de recebimento de materiais sem que nela constem numero da Ordem de Compra.",oFont7a)
			oPrint:Say  (1530,0070,"A Westech se reserva o direito de efetuar testes na fabrica do fornecedor antes da liberacao para entrega. ",oFont7a)
			oPrint:Say  (1570,0070,"A penalidadade por atraso de entrega sera de 0,3% ao dia com teto maximo de 10%. Os valores correspondente serao glosados do pagamento a ser feito. ",oFont7a)
			oPrint:Say  (1610,0070,"Os preco informados incluem ICMS, PIS e COFINS.",oFont7a)
			oPrint:Say  (1650,0070,"Os pagamentos serao feitos atraves de deposito bancario.",oFont7a)
			oPrint:Say  (1690,0070,"Material destinado a industrializacao.",oFont7a)
			oPrint:Say  (1730,0070,"Enviar certificado de qualidade do produto anexado a nota fiscal.",oFont7a)
			oPrint:Say  (1770,0070,"Importante:",oFont7an)
			oPrint:Say  (1810,0070,"A Westech nao aceita emissao de boletos para pagamentos, bem como, nao aceita negociacao de duplicata com terceiros.",oFont7an)
			oPrint:Say  (1850,0070,"Fornecer uma via fisica do Certificado de Materia Prima / Procedencia junto com envio do produto e uma via eletronica (e-mail) junto com nota fiscal.",oFont7an)
			oPrint:Say  (1890,0070,"",oFont7a)
			oPrint:Say  (1930,0070,"",oFont7a)


		ELSEIF !EMPTY(cFormula2) .AND. EMPTY(cXNotas)
			oPrint:Say  (1410,0070,cLinha1,oFont7a)
			oPrint:Say  (1450,0070,cLinha2,oFont7a)
			oPrint:Say  (1490,0070,cLinha3,oFont7a)
			oPrint:Say  (1530,0070,cLinha4,oFont7a)
			oPrint:Say  (1570,0070,cLinha5,oFont7a)
			oPrint:Say  (1610,0070,cLinha6,oFont7a)
			oPrint:Say  (1650,0070,cLinha7,oFont7a)
			oPrint:Say  (1690,0070,cLinha8,oFont7a)
			oPrint:Say  (1730,0070,cLinha9,oFont7a)
			oPrint:Say  (1770,0070,cLinha10,oFont7a)
			oPrint:Say  (1810,0070,cLinha11,oFont7a)
			oPrint:Say  (1850,0070,cLinha12,oFont7a)
			oPrint:Say  (1890,0070,cLinha13,oFont7a)
			oPrint:Say  (1930,0070,cLinha14,oFont7a)
			
		ELSEIF !EMPTY(cXNotas)
			///oPrint:Say  (1410,0070,Alltrim(cXNotas),oFont7a)
			nLin := 1370
			nLinhas := MLCount(cXNotas,200)
			For nXi:= 1 To 18
			
			        cTxtLinha := MemoLine(cXNotas,200,nXi)
			        If ! Empty(cTxtLinha)
			              oPrint:Say(nLin+=40,0070,(cTxtLinha),oFont7a)
			        EndIf
			        			       
			Next nXi
		END IF

		oPrint:FillRect({2120,0050,2170,1490},oBrush)
		oPrint:FillRect({2120,1490,2170,2450},oBrush)
		oPrint:FillRect({2120,2450,2170,3300},oBrush)

		
		oPrint:Box	(2120,0050,2170,1100)
		oPrint:Say  (2130,0650,"Emissao",oFont8n)
		
				
		oPrint:Box	(2120,1100,2170,2650)
		oPrint:Say  (2130,1820,"Aprovacao",oFont8n)
		
		oPrint:Box	(2120,2650,2170,3300)
		oPrint:Say  (2130,2660,"Aceitacao desta Ordem de Compra Pelo Fornecedor",oFont9n)

		// Socitante
		cIdSolic		:= Alltrim(Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER"))
		cAssSolic	:= GetSrvProfString('Startpath','') + cIdSolic + '.BMP'
		oPrint:SayBitmap(2230,0070,cAssSolic,0520,0120)
		
		oPrint:Box	(2170,0050,2350,0530)  // (2170,0050,2350,0700) 
		oPrint:Say  (2180,0060,"Solicitante",oFont8n)
		oPrint:Say  (2210,0060,AllTrim(UsrFullName(Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER"))),oFont8)
		oPrint:Say  (2310,0060,Posicione("ZZE",1,xFilial("ZZE") + (Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER")),"ZZE_CARGO"),oFont8)
	
		//Assinatura Emitido por
		cIdConf		:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"))
		cAssConf	:= GetSrvProfString('Startpath','') + cIdConf + '.BMP'
		oPrint:SayBitmap(2230,0540,cAssConf,0520,0120)

		oPrint:Box	(2170,0530,2350,1100) // Emitido por (2170,0700,2350,1290)
		oPrint:Say  (2180,0540,"Comprador(a)",oFont8n)
		oPrint:Say  (2210,0540,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"))),oFont8)
		oPrint:Say  (2310,0540,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"),"ZZE_CARGO"),oFont8)
		
		// Assinatura Coordenador
		oPrint:Box	(2170,1100,2350,1600) // coordenador (2170,1290,2350,1870)
		if  EMPTY(SC7->C7_XAPRN1) .and. SC7->C7_ITEMCTA <> 'ADMINISTRACAO'//.OR. alltrim(SC7->C7_XCTRVB) <> "4" // 
			oPrint:Say  (2210,1110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1110,"DO COORDENADOR(A)",oFont8n)
			
		elseif !EMPTY(SC7->C7_XAPRN1) //.AND. alltrim(SC7->C7_XCTRVB) == "4" //elseif cRequer == "1" .and. !EMPTY(SC7->C7_XAPRN1)
			cIdCoord	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"))
			cAssCoord	:= GetSrvProfString('Startpath','') + cIdCoord + '.BMP'
			oPrint:SayBitmap(2230,1110,cAssCoord,0520,0120)
			oPrint:Say  (2180,1110,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"))),oFont8)
			oPrint:Say  (2310,1110,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"),"ZZE_CARGO"),oFont8)
		endif

		cUserCoord := POSICIONE("CTD",1,XFILIAL("CTD")+ SC7->C7_ITEMCTA,"CTD_XIDPM")
		
		PswOrder(1)
		If PswSeek(cUserCoord, .T. )
			cGrup := alltrim(PSWRET()[1][12])
		endif

		//MsgInfo(cGrup)

		// Assinatura Gerência
		oPrint:Box	(2170,1600,2350,2100)  // Gerenccia (2170,1290,2350,1870)
		if EMPTY(SC7->C7_XAPRN3) .AND.  substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR' .AND. nTotalCom > 1000 .AND. cGrup == "Contratos(E)" 
			oPrint:Say  (2210,1610,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1610,"DA GERENCIA",oFont8n)

		elseif EMPTY(SC7->C7_XAPRN3) .AND.  substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR' .AND. nTotalCom > 1500 .AND. cGrup == "Contratos" 
			oPrint:Say  (2210,1610,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1610,"DA GERENCIA",oFont8n)
		
		elseif !EMPTY(SC7->C7_XAPRN3) //.AND. alltrim(SC7->C7_XCTRVB) == "4" //elseif cRequer == "1" .and. !EMPTY(SC7->C7_XAPRN1)
			cIdGeren	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN3"))
			cAssGeren	:= GetSrvProfString('Startpath','') + cIdCoord + '.BMP'
			oPrint:SayBitmap(2230,1610,cAssCoord,0520,0120)
			oPrint:Say  (2180,1610,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"))),oFont8)
			oPrint:Say  (2310,1610,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"),"ZZE_CARGO"),oFont8)
		endif
			
		//ENDIF
		
		oPrint:Box	(2170,2100,2350,2650) // Diretoria (2170,1870,2350,2650)

		// Assinatura DIRETORIA
		if EMPTY(SC7->C7_XAPRN2) .AND. nTotalCom > 1000 .AND. substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR'  .AND. cGrup == "Contratos(E)" 
			oPrint:Say  (2210,2110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)

		elseif EMPTY(SC7->C7_XAPRN2) .AND. nTotalCom > 1500 .AND. substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR' .AND. cGrup == "Contratos" 
			oPrint:Say  (2210,2110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)
		
		elseif EMPTY(SC7->C7_XAPRN2) .AND. !substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR'// cRequer = "1"
			oPrint:Say  (2210,2110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)
			
		elseif !EMPTY(SC7->C7_XAPRN2)
			cIdDiret	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"))
			cAssDiret	:= GetSrvProfString('Startpath','') + cIdDiret + '.BMP'
			oPrint:SayBitmap(2230,2110,cAssDiret,0520,0120)
			oPrint:Say  (2180,2110,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"))),oFont8)
			oPrint:Say  (2310,2110,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"),"ZZE_CARGO"),oFont8)
			
		//elseif EMPTY(SC7->C7_XAPRN2) .AND. cRequer = "2"
			//oPrint:Say  (2210,1920,"",oFont20)	
			
		endif

		oPrint:Box	(2170,2650,2350,3030) //
		oPrint:Say  (2180,2660,"Nome / Assinatura",oFont8n)

		oPrint:Box	(2170,3030,2350,3300) //
		oPrint:Say  (2180,3040,"Data",oFont9n)
		
/*ELSE
		//... Impressao do cabecalho
		oPrint:StartPage()   // Inicia uma nova pï¿½gina

		// Cabecalho
		//oPrint:FillRect({0050,0050,0190,0740},oBrush2)

		oPrint:Box	(0050,0050,0510,3300) //Box Cabeï¿½a

		oPrint:Box	(0050,0050,0190,0740) // logo
		oPrint:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrint:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Dados da Empresa
		oPrint:Box	(0050,0050,0410,0740) // Empresa
		// oPrint:Say  ( 0220,0580,"Empresa " ,oFont9n)
		oPrint:Say  ( 0210,0060,ALLTRIM(aDadosEmp[2]),oFont8)   // Endereco
		oPrint:Say  ( 0250,0060,aDadosEmp[3] + " - " + "BRASIL - " + "CEP: " + aDadosEmp[4] ,oFont8) // CEP
		oPrint:Say  ( 0290,0060,"Tel.: " + "55-11-3234-5400 - Fax: 55-11-3234-5423" ,oFont8) // TEL
		oPrint:Say  ( 0330,0060,"CNPJ: " + aDadosEmp[6] + " - " + "Insc.Est. - " + aDadosEmp[7] ,oFont8) // CNPJ
		oPrint:Say  ( 0370,0060,"Insc. Municipal: 3.489.047-5",oFont8)
		//oPrint:Say  ( 0370,0060,"E-mail NF Eletrï¿½nica: notafiscal@westech.com.br ",oFont8n)

		// Ordem de Compra
		oPrint:Box	(0050,0740,0190,1340) // Titulo Pedido
		oPrint:Say  (0070,0800,"PURCHASE ORDER ",oFont14)
		oPrint:Say  (0120,0900,"No " + cNumPed,oFont14)

		oPrint:Box	(0190,0740,0350,1050) // Data Emissao
		oPrint:Say  (0220,0780,"Issue " ,oFont12)
		oPrint:Say  (0280,0780,DTOC(dDataEmi) ,oFont12)

		oPrint:Box	(0190,1050,0350,1340) // Revisao
		oPrint:Say  (0220,1100,"Review: No: " + Transform(nRevisao, "@E 999"),oFont9)
		If EMPTY(dRevisao)
			oPrint:Say  (0280,1100,"Date: " + SPACE(3) ,oFont9)
		Else
			oPrint:Say  (0280,1100,"Date: " + Substr(dRevisao,7,2) + "/" + Substr(dRevisao,5,2) + "/" + Substr(dRevisao,1,4) ,oFont9)

		Endif

		//oPrint:Say  (0280,1090,"Nï¿½: " + Transform(nRevisao, "@E 999"),oFont8n)

		oPrint:Box	(0050,1340,0350,2400) // Fornecedor
		oPrint:Say  (0070,1350,"Provider",oFont9n)
		oPrint:Say  (0110,1350, cCodCredor + " - " + cNomeCredor,oFont9n)
		oPrint:Say  (0150,1350,cEnd + " - " + cBAIRRO ,oFont8)
		oPrint:Say  (0190,1350,cMUN + " - "  + cEst + " - " + cPAIS + " - CEP: " + cCEP + " - Tel: " + cDDI + "-" + cDDD + "-" + cTel,oFont8)
		oPrint:Say  (0230,1350,"CNPJ: " + Transform(cCGC,"@R 99.999.999/9999-99") + " - " + "Inscr. Est.: " + cINSCR + " - Inscr. Mun.: " + cINSCRM  ,oFont8)
		oPrint:Say  (0270,1350,"E-mail:" + cEmail,oFont8)
		oPrint:Say  (0310,1350,"Contact: " + cContato,oFont8)

		oPrint:Box	(0050,2400,0185,3300) // Local de Entrega
		oPrint:Say  (0060,2410,"Delivery Address: ",oFont9n)
		IF EMPTY(cFormula)
			oPrint:Say  (0100,2410, ALLTRIM( aDadosEmp[2]) ,oFont8)
			oPrint:Say  (0140,2410, ALLTRIM( aDadosEmp[3]) + " - " + ALLTRIM( aDadosEmp[4]),oFont8)

		ELSE
			oPrint:Say  (0100,2410, ALLTRIM(ccNREDUZ) + " - " + ALLTRIM(ccEND) ,oFont8)
			oPrint:Say  (0140,2410, ALLTRIM(ccBAIRRO) + " - " + ALLTRIM(ccMUN) + " - " + ALLTRIM(ccEST) + " - CEP: " + ALLTRIM(ccCEP),oFont8)
		ENDIF

		oPrint:Box	(0050,2400,0350,3300) // Local de Cobranca
		oPrint:Say  (0195,2410,"Local Billing ",oFont9n)
		oPrint:Say  (0235,2410, ALLTRIM( aDadosEmp[2]) ,oFont8)
		oPrint:Say  (0275,2410, ALLTRIM( aDadosEmp[3]) + " - " + ALLTRIM( aDadosEmp[4]),oFont8)
		oPrint:Say  (0315,2410,"E-mail NF Eletronica: notafiscal@westech.com.br ",oFont8n)

		oPrint:Box	(0350,0740,0410,3300) // Local de Cobranca
		oPrint:Say  (0360,0790,"We authorize the supply of the following materials / services, condition established this purchase order and its attachments ",oFont9n)

		oPrint:Box	(0350,2900,0410,3300) // Numero Pagina
		//oPrint:Say  (0360,2920,"Pï¿½gina",oFont9)

		oPrint:Box	(0410,0050,0460,3300) // cabecalhos itens pedido
		oPrint:Box	(0410,0050,0460,1650)
		oPrint:Say  (0420,0950,"Scope of Supply",oFont7n,1800,,,1)
		oPrint:Box	(0410,2210,0460,2700)
		oPrint:Say  (0420,2350,"Prices Taxes",oFont7n)
		oPrint:Box	(0410,2700,0460,2960)
		oPrint:Say  (0420,2730,"Including taxes",oFont7n)

		oPrint:Box	(2050,0050,2120,3300) // Cond. pag
		//oPrint:Say  (2020,1510,"Condiï¿½ï¿½o de Pagamento: ",oFont9n)
		oPrint:Say  (2060,0070,"Terms of Payment: " + cCondPagto, oFont9n,,,0)

		//oPrint:Box	(2010,2400,2120,3300) // Cond. pag
		//oPrint:Say  (2020,2420,"Terms of Payment: ",oFont9n)
		//oPrint:Say  (2060,2420,cCondPagto, oFont9n)
		
		//***
		
		
		//****oPrint:Box	(1470,2400,1520,3300)
		oPrint:Box	(1370,2400,1520,3300)
		oPrint:Say  (1400,2420,"SubTotal page " + varSimb + " : ",oFont9)

		oPrint:Box	(1520,2400,1580,3300)
		oPrint:Say  (1530,2420,"Total Items (s/ IPI) " + varSimb + " : ",oFont9)
		oPrint:Say  (1530,3250, alltrim(transform(nTotPdSIPI ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Produtos sem IPI

		oPrint:Box	(1580,2400,1820,3300)
		oPrint:Say  (1590,2420,"Insurance " + varSimb + " : ",oFont9)
		oPrint:Say  (1590,3250, alltrim(transform(nTotalSeg ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando Seguro

		//oPrint:Box	(1640,2400,1700,3300)
		oPrint:Say  (1650,2420,"Freight " + varSimb + " : ",oFont9)
		oPrint:Say  (1650,3250, alltrim(transform(nTotalFrete ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando Frete

		//oPrint:Box	(1700,2400,1940,3300)
		oPrint:Say  (1710,2420,"Expenses " + varSimb + " : ",oFont9)
		oPrint:Say  (1710,3250, alltrim(transform(nTotalDesp ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Despesa

		//oPrint:Box	(1760,2400,1820,3300)
		oPrint:Say  (1770,2420,"Total IPI " + varSimb + " : ",oFont9)
		oPrint:Say  (1770,3250, alltrim(transform(nTotalIPI ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando IPI

		oPrint:Box	(1820,2400,1940,3300)
		oPrint:Say  (1830,2420,"Discount " + varSimb + " : ",oFont9)
		oPrint:Say  (1830,3250, alltrim(transform(nTotalDesc ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Desconto

		//oPrint:Box	(1880,2400,1940,3300)
		oPrint:Say  (1890,2420,"ICMS tax substitution " + varSimb + " : ",oFont9)
		oPrint:Say  (1890,3250, alltrim(transform(nTotalICMSRET ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando ICMS ST

		oPrint:Box	(1940,2400,2050,3300)
		oPrint:Say  (1975,2420,"Total Purchase Order " + varSimb + " : ",oFont12)
		oPrint:Say  (1975,3250, alltrim(transform(nTotalCom ,"@E 999,999,999.99")),oFont12,20,,,1)      // Total do pedido de compras
	
		// Cabecalho Itens do Pedido

		oPrint:Box	(0460,0050,0510,3300) // cabecalhos itens pedido

		oPrint:Box	(0460,0050,1370,0130) // cabecalho Item
		oPrint:Say  (0470,0060,"Item",oFont7n)

		oPrint:Box	(0460,0130,1370,0430) // cabecalho Codigo
		oPrint:Say  (0470,0200,"Code",oFont7n)

		oPrint:Box	(0460,0430,1370,1650) // cabecalho Descricao
		oPrint:Say  (0470,0900,"Description of Material and / or Service",oFont7n)

		oPrint:Box	(0460,1650,1370,1830) // cabecalho Quantidade
		oPrint:Say  (0470,1690,"1a. Qtd.",oFont7n)

		oPrint:Box	(0460,1830,1370,1930) // cabecalho Undidade de medida
		oPrint:Say  (0470,1840,"1a. Un.",oFont7n)

		oPrint:Box	(0460,1930,1370,2110) // cabecalho Quantidade
		oPrint:Say  (0470,1970,"2a. Qtd.",oFont7n)

		oPrint:Box	(0460,2110,1370,2210) // cabecalho Undidade de medida
		oPrint:Say  (0470,2120,"2a Un.",oFont7n)

		oPrint:Box	(0460,2210,1370,2450) // cabecalho Preco Unitario
		oPrint:Say  (0470,2270,"Each " + varSimb,oFont7n)

		oPrint:Box	(0460,2450,1370,2700) // cabecalho Total
		oPrint:Say  (0470,2540,"Total " + varSimb,oFont7n)

		oPrint:Box	(0460,2700,1370,2780) // cabecalho Ipi
		oPrint:Say  (0470,2710,"IPI %",oFont7n)

		oPrint:Box	(0460,2780,1370,2880) // cabecalho Ipi
		oPrint:Say  (0470,2790,"ICMS %",oFont7n)

		oPrint:Say  (0470,2890,"ISS %",oFont7n)

		oPrint:Box	(0460,2960,1370,3120) // cabecalho Data Entrega
		oPrint:Say  (0470,2970,"Delivery Date",oFont7n)

		oPrint:Box	(0460,3120,1370,3300) // cabecalho No. Job
		oPrint:Say  (0470,3130,"ACC Number",oFont7n)

		// Rodapï¿½
		oPrint:Box	(1370,0050,2170,3300) //

		//oPrint:Box	(1700,200,2100,3300) // Nota do Pedido
		oPrint:Say  (1375,0070,"Observations ",oFont9n)

		IF EMPTY(cFormula2) .AND. EMPTY(cXNotas)

			oPrint:Say  (1410,0070,"",oFont8)
			oPrint:Say  (1450,0070,"",oFont8)
			oPrint:Say  (1490,0070,"",oFont8)
			oPrint:Say  (1530,0070,"",oFont8)
			oPrint:Say  (1570,0070,"",oFont8)
			oPrint:Say  (1610,0070,"",oFont8)
			oPrint:Say  (1650,0070,"",oFont8)
			oPrint:Say  (1690,0070,"",oFont8)
			oPrint:Say  (1730,0070,"",oFont8)
			oPrint:Say  (1870,0070,"",oFont8)
			oPrint:Say  (1810,0070,"",oFont8)
			oPrint:Say  (1850,0070,"",oFont8)
			oPrint:Say  (1890,0070,"",oFont8)
			oPrint:Say  (1930,0070,"",oFont8)

		ELSEIF !EMPTY(cFormula2) .AND. EMPTY(cXNotas)
		
			oPrint:Say  (1410,0070,cLinha1,oFont8)
			oPrint:Say  (1450,0070,cLinha2,oFont8)
			oPrint:Say  (1490,0070,cLinha3,oFont8)
			oPrint:Say  (1530,0070,cLinha4,oFont8)
			oPrint:Say  (1570,0070,cLinha5,oFont8)
			oPrint:Say  (1610,0070,cLinha6,oFont8)
			oPrint:Say  (1650,0070,cLinha7,oFont8)
			oPrint:Say  (1690,0070,cLinha8,oFont8)
			oPrint:Say  (1730,0070,cLinha9,oFont8)
			oPrint:Say  (1770,0070,cLinha10,oFont8)
			oPrint:Say  (1810,0070,cLinha11,oFont8)
			oPrint:Say  (1850,0070,cLinha12,oFont8)
			oPrint:Say  (1890,0070,cLinha13,oFont8)
			oPrint:Say  (1930,0070,cLinha14,oFont8)
			
		ELSEIF !EMPTY(cXNotas)
			///oPrint:Say  (1410,0070,Alltrim(cXNotas),oFont7a)
			nLin := 1370
			nLinhas := MLCount(cXNotas,200)
			For nXi:= 1 To 18
			
			        cTxtLinha := MemoLine(cXNotas,200,nXi)
			        If ! Empty(cTxtLinha)
			              oPrint:Say(nLin+=40,0070,(cTxtLinha),oFont7a)
			        EndIf
			        			       
			Next nXi
			
		END IF
		

		oPrint:FillRect({2120,0050,2170,1490},oBrush)
		oPrint:FillRect({2120,1490,2170,2450},oBrush)
		oPrint:FillRect({2120,2450,2170,3300},oBrush)

		oPrint:Box	(2120,0050,2170,1100)
		oPrint:Say  (2130,0650,"Emission",oFont8n)
		
		oPrint:Box	(2120,1100,2170,2650)
		oPrint:Say  (2130,1820,"Approval",oFont8n)
		
		oPrint:Box	(2120,2650,2170,3300)
		oPrint:Say  (2130,2660,"Acceptance of this Purchase Order by Supplier",oFont9n)

		
		//***
		// Socitante
		cIdSolic		:= Alltrim(Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER"))
		cAssSolic	:= GetSrvProfString('Startpath','') + cIdSolic + '.BMP'
		oPrint:SayBitmap(2230,0070,cAssSolic,0520,0120)
		
		oPrint:Box	(2170,0050,2350,0530)  // (2170,0050,2350,0700) 
		oPrint:Say  (2180,0060,"Requester",oFont8n)
		oPrint:Say  (2210,0060,AllTrim(UsrFullName(Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER"))),oFont8)
		oPrint:Say  (2310,0060,Posicione("ZZE",1,xFilial("ZZE") + (Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER")),"ZZE_CARGO"),oFont8)

		//Assinatura Emitido por
		cIdConf		:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"))
		cAssConf	:= GetSrvProfString('Startpath','') + cIdConf + '.BMP'
		oPrint:SayBitmap(2230,0540,cAssConf,0520,0120)

		oPrint:Box	(2170,0530,2350,1100) // Emitido por (2170,0700,2350,1290)
		oPrint:Say  (2180,0540,"Issued by",oFont8n)
		oPrint:Say  (2210,0540,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"))),oFont8)
		oPrint:Say  (2310,0540,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"),"ZZE_CARGO"),oFont8)

		
		// Assinatura Coordenador
		oPrint:Box	(2170,1100,2350,1600) // coordenador (2170,1290,2350,1870)
		if  EMPTY(SC7->C7_XAPRN1) .and. SC7->C7_ITEMCTA <> 'ADMINISTRACAO'//.OR. alltrim(SC7->C7_XCTRVB) <> "4" // 
			oPrint:Say  (2210,1110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1110,"DO COORDENADOR(A)",oFont8n)
			
		elseif !EMPTY(SC7->C7_XAPRN1) //.AND. alltrim(SC7->C7_XCTRVB) == "4" //elseif cRequer == "1" .and. !EMPTY(SC7->C7_XAPRN1)
			cIdCoord	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"))
			cAssCoord	:= GetSrvProfString('Startpath','') + cIdCoord + '.BMP'
			oPrint:SayBitmap(2230,1110,cAssCoord,0520,0120)
			oPrint:Say  (2180,1110,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"))),oFont8)
			oPrint:Say  (2310,1110,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"),"ZZE_CARGO"),oFont8)
		endif

		cUserCoord := POSICIONE("CTD",1,XFILIAL("CTD")+ SC7->C7_ITEMCTA,"CTD_XIDPM")
		
		PswOrder(1)
		If PswSeek(cUserCoord, .T. )
			cGrup := alltrim(PSWRET()[1][12])
		endif

		// Assinatura Gerência
		oPrint:Box	(2170,1600,2350,2100)  // Gerenccia (2170,1290,2350,1870)
		if EMPTY(SC7->C7_XAPRN3) .AND.  substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR' .AND. nTotalCom > 1000 .AND. cGrup == "Contratos(E)" //.AND. cTipoCont $ "AT/PR"
			oPrint:Say  (2210,1610,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1610,"DA GERENCIA",oFont8n)

		elseif EMPTY(SC7->C7_XAPRN3) .AND.  substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR' .AND. nTotalCom > 1500 .AND. cGrup == "Contratos" //.AND. cTipoCont $ "AT/PR"
			oPrint:Say  (2210,1610,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1610,"DA GERENCIA",oFont8n)
		
		elseif !EMPTY(SC7->C7_XAPRN3) //.AND. alltrim(SC7->C7_XCTRVB) == "4" //elseif cRequer == "1" .and. !EMPTY(SC7->C7_XAPRN1)
			cIdGeren	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN3"))
			cAssGeren	:= GetSrvProfString('Startpath','') + cIdCoord + '.BMP'
			oPrint:SayBitmap(2230,1610,cAssCoord,0520,0120)
			oPrint:Say  (2180,1610,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"))),oFont8)
			oPrint:Say  (2310,1610,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"),"ZZE_CARGO"),oFont8)
		endif

		PswOrder(2)
		If PswSeek( SC7->C7_XAPRN1, .T. )
			cGrup := alltrim(PSWRET()[1][12])
		endif

		oPrint:Box	(2170,2100,2350,2650) // Diretoria (2170,1870,2350,2650)

		// Assinatura DIRETORIA
		if EMPTY(SC7->C7_XAPRN2) .AND. nTotalCom > 1000 .AND. substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR' .AND. cGrup == "Contratos(E)" //ALLTRIM(SC7->C7_XAPRN1) $ ("000071/000076/000078/000046")
			oPrint:Say  (2210,2110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)
		
		elseif EMPTY(SC7->C7_XAPRN2) .AND. nTotalCom > 1500 .AND. substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR' .AND. cGrup == "Contratos" //ALLTRIM(SC7->C7_XAPRN1) $ ("000071/000076/000078/000046")
			oPrint:Say  (2210,2110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)
		
		elseif EMPTY(SC7->C7_XAPRN2) .AND. !substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR'// cRequer = "1"
			oPrint:Say  (2210,2110,"REQUER APROVACAO.....",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)
			
		elseif !EMPTY(SC7->C7_XAPRN2)
			cIdDiret	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"))
			cAssDiret	:= GetSrvProfString('Startpath','') + cIdDiret + '.BMP'
			oPrint:SayBitmap(2230,2110,cAssDiret,0520,0120)
			oPrint:Say  (2180,2110,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"))),oFont8)
			oPrint:Say  (2310,2110,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"),"ZZE_CARGO"),oFont8)
			
		//elseif EMPTY(SC7->C7_XAPRN2) .AND. cRequer = "2"
			//oPrint:Say  (2210,1920,"",oFont20)	
			
		endif
	
		oPrint:Box	(2170,2650,2350,3030) //
		oPrint:Say  (2180,2660,"Name / Signature",oFont8n)

		oPrint:Box	(2170,3030,2350,3300) //
		oPrint:Say  (2180,3040,"Date",oFont9n)



ENDIF*/



DbSelectArea("PEDCOMIR")

//oPrint:EndPage() // Finaliza a pï¿½gina

Return


//*************************************************************************************

Static Function fAjustaSx1()
local i, j
cAlias	:= Alias()
_nPerg 	:= 1


dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(cPerg)
	DO WHILE ALLTRIM(SX1->X1_GRUPO) == ALLTRIM(cPerg)
		_nPerg := _nPerg + 1
		DBSKIP()
	ENDDO
ENDIF

aRegistro:= {}
//          Grupo/Ordem/Pergunt              		/SPA/ENG/Variavl/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/Pyme/GRPSXG/HELP/PICTURE
aAdd(aRegistro,{cPerg,"01","Do Pedido?		","","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
aAdd(aRegistro,{cPerg,"02","Ate Pedido?		","","","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
aAdd(aRegistro,{cPerg,"03","Do Fornecedor?	","","","mv_ch3","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegistro,{cPerg,"04","Ate Fornecedor?	","","","mv_ch4","C",06,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegistro,{cPerg,"05","Da Loja?		","","","mv_ch5","C",02,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"06","Ate Loja? 		","","","mv_ch6","C",02,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"07","Da Emissao?		","","","mv_ch7","D",08,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"08","Ate Emissao?	","","","mv_ch8","D",08,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"09","Do Produto?		","","","mv_ch9","C",15,00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegistro,{cPerg,"10","Ate Produto?	","","","mv_cha","C",15,00,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegistro,{cPerg,"11","Imprim./Visual?	","","","mv_chb","N",01,00,2,"N","","mv_par11","Imprimir","","","","","Visua.Impr.","","","","","","","","","","","","","","","","","","","   ","","","",""})
aAdd(aRegistro,{cPerg,"12","Idioma OC?		","","","mv_chc","N",01,00,2,"N","","mv_par12","Ingles","","","","","Portugues","","","","","","","","","","","","","","","","","","","   ","","","",""})

IF Len(aRegistro) >= _nPerg
	For i:= _nPerg  to Len(aRegistro)
		Reclock("SX1",.t.)
		For j:=1 to FCount()
			If J<= LEN (aRegistro[i])
				FieldPut(j,aRegistro[i,j])
			Endif
		Next
		MsUnlock()
	Next
EndIf
dbSelectArea(cAlias)
Return
