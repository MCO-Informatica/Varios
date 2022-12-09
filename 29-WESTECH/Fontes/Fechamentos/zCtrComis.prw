
#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include 'totvs.ch'
#include 'parmtype.ch'


//ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ// 
//                        Low Intensity colors 
//ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
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
user function zCtrComis()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"GeraÁ„o de planilha de Comissıes"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"CTRCOMIS01"
private _cArq	:= 	"CTRCOMIS01.XLS"
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

AADD(aSays,"Este programa gera planilha com os dados para o Controle de Comissıes baseado em  ")
AADD(aSays,"Contratos ativos O arquivo gerado pode ser aberto de forma autom·tica")
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
	
	MSAguarde({||D101REAL()},"Processando Comissoes")
	
	MSAguarde({||SE21REAL()},"Processando Comissoes")
		
	MSAguarde({||CV401REAL()},"Processando Comissoes")
	
	
	
		//MSAguarde({||PFIN01REAL()},"Fluxo de caixa Realizado")
	if MV_PAR06 = 1 .OR. MV_PAR08 = 1
		MSAguarde({||CTRCOMEQST()},"Processando Contratos EQ / ST")
	endif
	
	if MV_PAR03 = 1 .OR. MV_PAR05 = 1
		MSAguarde({||CTRCOMAT()},"Processando Contratos AT / EN")
	endif

	if MV_PAR07 = 1
		MSAguarde({||CTRCOMPR()},"Processando Contratos PR")
	endif

	if MV_PAR04 = 1
		MSAguarde({||CTRCOMCM()},"Processando Contratos CM")
	endif

	MontaTela()


	TRB1->(dbclosearea())
	TRB2->(dbclosearea())
	TRB3->(dbclosearea())
	//TRB2->(dbclosearea())


endif


return

static function D101REAL()

local _cQuery := ""
Local _cFilSD1 := xFilial("SD1")

_cQuery := " SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO', cast(E2_VENCREA AS DATE) AS 'TMP_VENCREA' , cast(E2_BAIXA AS DATE) AS 'TMP_BAIXA', "
_cQuery += "  D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, E2_NOMFOR, "
_cQuery += " D1_BASEICM, D1_CUSTO, D1_FORNECE "  
_cQuery += " FROM SD1010 "
_cQuery += " INNER JOIN SE2010 ON D1_DOC = E2_NUM AND D1_FORNECE = E2_FORNECE AND D1_LOJA = E2_LOJA "  
_cQuery += " WHERE  SD1010.D_E_L_E_T_ <> '*' AND  SE2010.D_E_L_E_T_ <> '*' AND D1_XNATURE = '6.21.00' AND E2_BAIXA <> '' AND D1_RATEIO = 2 OR " 
_cQuery += " 		SD1010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND D1_XNATURE = '6.22.00' AND E2_BAIXA <> '' AND D1_RATEIO = 2 "
_cQuery += " 		ORDER BY E2_BAIXA "

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())


while QUERY->(!eof())

	//if QUERY->D1_ITEMCTA == _cItemConta;
		//.AND. ! alltrim(QUERY->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') .AND. QUERY->D1_RATEIO == '2';
		//.AND. QUERY->D1_RATEIO == '2'
		
		RecLock("TRB2",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->D1_DOC))
		ProcessMessage()
		
		TRB2->DATAMOV	:= QUERY->TMP_BAIXA
		TRB2->NUMERO	:= QUERY->D1_DOC
		TRB2->VALOR		:= QUERY->D1_CUSTO
		TRB2->CODFORN	:= QUERY->D1_FORNECE
		TRB2->FORNECEDOR:= QUERY->E2_NOMFOR
		TRB2->NATUREZA	:= QUERY->D1_XNATURE
		TRB2->ITEMCONTA := QUERY->D1_ITEMCTA

		MsUnlock()

	//endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return
/**********************************************************/
static function SE21REAL()
local _cQuery := ""
Local _cFilSDE := xFilial("SE2")

SE2->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SE2",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"QUERY->E2_XXIC",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())


while QUERY->(!eof())

	if QUERY->E2_TIPO <> 'INV' .AND. E2_NATUREZ <> '6.21.00' 
		QUERY->(dbskip())
		Loop
	ENDIF
	if ALLTRIM(QUERY->E2_TIPO) == 'INV' .AND.  E2_NATUREZ == '6.21.00' 
		//.AND. ! alltrim(QUERY->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') .AND. QUERY->D1_RATEIO == '2';
		//.AND. QUERY->D1_RATEIO == '2'
		
		RecLock("TRB2",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->E2_NUM))
		ProcessMessage()
		
		TRB2->DATAMOV	:= QUERY->E2_VENCREA
		TRB2->NUMERO	:= QUERY->E2_NUM
		TRB2->VALOR		:= QUERY->E2_VLCRUZ
		TRB2->CODFORN	:= QUERY->E2_FORNECE
		TRB2->FORNECEDOR:= QUERY->E2_NOMFOR
		TRB2->NATUREZA	:= QUERY->E2_NATUREZ
		TRB2->ITEMCONTA := QUERY->E2_XXIC

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa FINANCEIRO RATEIO			                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

static function CV401REAL()

local _cQuery := ""
local cQuery := ""
Local _cFilCV4 := xFilial("CV4")


cQuery := "	SELECT DISTINCT E2_FORNECE, E2_NOMFOR, E2_LOJA, E2_RATEIO,E2_XXIC, E2_NUM, E2_VENCREA, E2_VENCTO, E2_VLCRUZ, E2_NATUREZ,  " 
cQuery += "	CAST(CV4_DTSEQ AS DATE) AS 'TMP_DTSEQ', CV4_PERCEN,CV4_VALOR,CV4_ITEMD, CV4_HIST, CV4_SEQUEN,"
cQuery += "		CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN AS 'TMP_ARQRAT',E2_ARQRAT, E2_TIPO, E2_BAIXA "  
cQuery += "		FROM CV4010 "
cQuery += "		INNER JOIN SE2010 ON SE2010.E2_ARQRAT = CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN "
cQuery += "		WHERE E2_RATEIO = 'S' AND SE2010.D_E_L_E_T_ <> '*' AND CV4010.D_E_L_E_T_ <> '*' "
cQuery += "				ORDER BY E2_XXIC "

	IF Select("cQuery") <> 0
		DbSelectArea("cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())


QUERY->(dbgotop())


while QUERY->(!eof())

	IF ALLTRIM(QUERY->E2_TIPO) = "PA" .AND. QUERY->E2_BAIXA <> "" 
		QUERY->(dbsKip())
		loop
	ENDIF
	
	if ! ALLTRIM(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
		QUERY->(dbsKip())
		loop
	endif

	RecLock("TRB2",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->E2_NUM))
		ProcessMessage()
		
		TRB2->DATAMOV	:= QUERY->TMP_DTSEQ
		TRB2->NUMERO	:= QUERY->E2_NUM
		TRB2->VALOR		:= QUERY->CV4_VALOR
		TRB2->CODFORN	:= QUERY->E2_FORNECE
		TRB2->FORNECEDOR:= QUERY->E2_NOMFOR
		TRB2->NATUREZA	:= QUERY->E2_NATUREZ
		TRB2->ITEMCONTA := QUERY->CV4_ITEMD

		MsUnlock()

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa Documentos de Entrada		                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

static function DE01REAL()

local _cQuery := ""
Local _cFilSDE := xFilial("SDE")
Local cProdD1 	:= ""
Local cDoc		:= ""
Local cSerie	:= ""
Local cFornece	:= ""
Local cLoja		:= ""
Local cItemNF	:= ""

/*
_cQuery := "SELECT DE_ITEMCTA, DE_DOC, DE_FORNECE, DE_CUSTO1, DE_ITEMNF FROM SDE010  WHERE  D_E_L_E_T_ <> '*' AND DE_ITEMCTA = '" + _cItemConta + "' "


	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())
*/

SD1->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SDE",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"QUERY->DE_DOC",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

		cDoc		:= QUERY->DE_DOC
		//cSerie		:= QUERY->DE_SERIE
		cFornece	:= QUERY->DE_FORNECE
		//cLoja		:= QUERY->DE_LOJA
		cItemNF		:= QUERY->DE_ITEMNF

while QUERY->(!eof())

	 

	if QUERY->DE_ITEMCTA == _cItemConta;
		.AND. ! alltrim(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_CF")) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') 
		
		cDoc		:= QUERY->DE_DOC
		cSerie		:= QUERY->DE_SERIE
		cFornece	:= QUERY->DE_FORNECE
		cLoja		:= QUERY->DE_LOJA
		cItemNF		:= QUERY->DE_ITEMNF
		
		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->DE_DOC))
		ProcessMessage()

		cProdD1 		:= ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_COD"))
		
		
		
		TRB1->DATAMOV	:= POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_EMISSAO")
		TRB1->TIPO		:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO"))
		TRB1->NUMERO	:= QUERY->DE_DOC
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"

		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "MP" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"

		
		elseif ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00')
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		elseif ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		else
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		endif


		TRB1->PRODUTO	:= cProdD1
		TRB1->HISTORICO	:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_DESC"))
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE 	:= ""
		TRB1->VALOR		:= QUERY->DE_CUSTO1
		TRB1->VALOR2	:= QUERY->DE_CUSTO1
		TRB1->CODFORN	:= QUERY->DE_FORNECE
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->DE_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_CF")
		
		TRB1->NATUREZA	:= POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")
		
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE"),"ED_DESCRIC"))
		TRB1->ORIGEM	:= "DR"
		TRB1->ITEMCONTA := QUERY->DE_ITEMCTA
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return



/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PFIN01REAL∫												   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa Controle de Comissıes EQ / ST	                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function CTRCOMEQST()

local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local _cQuerySE1	:= ""
Local QUERYSE1		:= ""
Local _cQuerySE2	:= ""
Local QUERYSE2		:= ""
Local nXSE1			:= 0

Local nTotalREC		:= 0
Local nTotalPAG		:= 0
Local nXVALCOM		:= 0

 Local cItem 		:= ""
 Local cConta 		:= ""
 Local cConta2 		:= ""

 Local nXVDSIR		:= 0
 Local nXVDCIR		:= 0
 Local nXCUPRR		:= 0
 Local nXBOOKMG		:= 0
 Local nXCUTOR		:= 0
 Local nXTOTPAGCM	:= 0
 
 Local nTotalC1		:= 0
 Local nTotalC2		:= 0
 Local nTotalC3		:= 0
 Local nTotalC4		:= 0
 Local nTotalC8		:= 0
 Local nTotalC9		:= 0
 Local nTotalC10	:= 0
 Local nTotalC11	:= 0
 Local nTotalC12	:= 0
 Local nTotalC13	:= 0

 Local nXPCOM		:= 0
 Local nXVCOM		:= 0
 Local nXVDSISF		:= 0

 Local nXVCOMR		:= 0
 Local nXVDSISFR	:= 0
 
 

 local dData1
 local dData2
 local cWeekJOB
//************************ Conexao Dados CTD - Contratos
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
CTD->(dbsetorder(1))

//*********************** Conexao SE1 - Recebimentos Efetivos Contrato


_cQuerySE1 := " SELECT DISTINCT E1_XXIC AS 'TMP_CONTRATOSE1', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATASE1', E5_VALOR AS 'TMP_VALORSE1',  "
_cQuerySE1 += "	A6_NOME AS 'TMP_NOME' FROM SE5010  "
_cQuerySE1 += " LEFT JOIN SE1010 ON SE1010.E1_NUM = SE5010.E5_NUMERO AND E1_CLIENTE = E5_CLIFOR  "
_cQuerySE1 += " LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA  "
_cQuerySE1 += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SE1010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "
_cQuerySE1 += " E5_RECPAG = 'R' AND E1_BAIXA <> '' AND E5_TIPODOC IN ('RA','VL')  "
_cQuerySE1 += " ORDER BY 1, 3   "

	IF Select("_cQuerySE1") <> 0
		DbSelectArea("_cQuerySE1")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuerySE1 NEW ALIAS "QUERYSE1"

	dbSelectArea("QUERYSE1")
	QUERYSE1->(dbGoTop())

//*********************** Conexao SE2 - Pagamento de Comissoes

_cQuerySE2 := " SELECT DISTINCT  E2_XXIC AS 'TMP_CONTRATOSE2', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATASE2', IIF(E5_RECPAG = 'R', -E5_VALOR, E5_VALOR)  AS 'TMP_VALORSE2', "
 _cQuerySE2 += "	ED_DESCRIC AS 'TMP_DESCRI', E5_NATUREZ AS 'TMP_NATUREZA', E2_NATUREZ AS 'TMP_NATUREZA2',  "
 _cQuerySE2 += "	E5_FORNECE AS 'TMP_FORNECE', E5_BENEF AS 'TMP_EMPRESA',  "
 _cQuerySE2 += "	E5_HISTOR AS 'TMP_HISTORICO', E5_DOCUMEN AS 'TMP_DOCUMENTO', E5_TIPO AS 'TMP_TIPO', E5_BANCO AS 'TMP_BANCO', E5_AGENCIA AS 'TMP_AGENCIA', A6_NOME AS 'TMP_NOME', E5_CONTA AS 'TMP_CONTA' " 
 _cQuerySE2 += "	FROM SE5010  "
 _cQuerySE2 += " LEFT JOIN SE2010 ON SE2010.E2_NUM = SE5010.E5_NUMERO AND SE2010.E2_FORNECE = SE5010.E5_FORNECE " 
 _cQuerySE2 += " LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA       "
 _cQuerySE2 += " LEFT JOIN SED010 ON SED010.ED_CODIGO = E5_NATUREZ  "
 _cQuerySE2 += " WHERE  "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND " 
 _cQuerySE2 += " E5_RECPAG = 'P' AND E5_TIPODOC IN ('CP','VL')  AND E2_NATUREZ = '6.21.00' OR    "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "  
 _cQuerySE2 += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('ES') AND E5_BANCO <> '' AND E2_NATUREZ = '6.21.00' OR "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND  "
 _cQuerySE2 += " E5_RECPAG = 'P' AND E5_TIPODOC IN ('CP','VL')  AND E2_NATUREZ = '6.22.00' OR    "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "  
 _cQuerySE2 += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('ES') AND E5_BANCO <> '' AND E2_NATUREZ = '6.22.00'  "
 _cQuerySE2 += " ORDER BY 6,3  "

	IF Select("_cQuerySE2") <> 0
		DbSelectArea("_cQuerySE2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuerySE2 NEW ALIAS "QUERYSE2"

	dbSelectArea("QUERYSE2")
	QUERYSE2->(dbGoTop())

//***********************

while QUERY->(!eof())

	
	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES/ESTOQUE'
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
	
	//************************ Filtro ano contrato
	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR11
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR12
		QUERY->(dbskip())
		Loop
	endif

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		TRB1->ITEM		:= QUERY->CTD_ITEM
		TRB1->CLIENTE	:= QUERY->CTD_XNREDU
		TRB1->NOMPM		:= QUERY->CTD_XNOMPM
		//****************************************
		TRB1->XVDCIVD	:= QUERY->CTD_XVDCI
		TRB1->XVDSIVD	:= QUERY->CTD_XVDSI
		TRB1->XSISFVVD	:= QUERY->CTD_XSISFV
		TRB1->XPCOMVD	:= QUERY->CTD_XPCOM
		TRB1->XVCOMVD	:= (TRB1->XSISFVVD * (QUERY->CTD_XPCOM/100))
		
		TRB1->XCUPRVD	:= QUERY->CTD_XCUSTO
		TRB1->XCOGSVD	:= QUERY->CTD_XCOGSV
		TRB1->XMGCTVD	:= ((QUERY->CTD_XVDSI - (QUERY->CTD_XCUTOT)) / QUERY->CTD_XVDSI )*100

		//****************************************
		TRB1->XVDCIRV	:= QUERY->CTD_XVDCIR
		TRB1->XVDSIRV	:= QUERY->CTD_XVDSIR
		TRB1->XSISFVRV	:= QUERY->CTD_XSISFR
		TRB1->XPCOMRV	:= QUERY->CTD_XPCOM
		TRB1->XVCOMRV	:= (TRB1->XSISFVRV * (QUERY->CTD_XPCOM/100))
		
		TRB1->XCUPRRV	:= QUERY->CTD_XCUPRR
		TRB1->XCOGSRV	:= QUERY->CTD_XCOGSR
		TRB1->XMGCTRV	:= ((QUERY->CTD_XVDSIR - (QUERY->CTD_XCUTOR)) / QUERY->CTD_XVDSIR )*100
		
		//*******************
		TRB1->XREPR1	:= QUERY->CTD_XREPR1
		TRB1->XNRED1	:= QUERY->CTD_XNRED1
		TRB1->XCOR1		:= QUERY->CTD_XCOR1
		if QUERY->CTD_XCOR1 > 0
			TRB1->XVCOR1	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR1/100)
		else
			TRB1->XVCOR1	:= 0
		endif
		
		TRB1->XREPR2	:= QUERY->CTD_XREPR2
		TRB1->XNRED2	:= QUERY->CTD_XNRED2
		TRB1->XCOR2		:= QUERY->CTD_XCOR2
		if QUERY->CTD_XCOR2 > 0
			TRB1->XVCOR2	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR2/100)
		else
			TRB1->XVCOR2	:= 0
		endif
		
		TRB1->XREPR3	:= QUERY->CTD_XREPR3
		TRB1->XNRED3	:= QUERY->CTD_XNRED3
		TRB1->XCOR3		:= QUERY->CTD_XCOR3
		if QUERY->CTD_XCOR3 > 0
			TRB1->XVCOR3	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR3/100)
		else
			TRB1->XVCOR3	:= 0
		endif
		
		TRB1->XREPR4	:= QUERY->CTD_XREPR4
		TRB1->XNRED4	:= QUERY->CTD_XNRED4
		TRB1->XCOR4		:= QUERY->CTD_XCOR4
		if QUERY->CTD_XCOR4 > 0
			TRB1->XVCOR4	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR4/100)
		else
			TRB1->XVCOR4	:= 0
		endif
		//******************* Totalizando Pagamentos	
		QUERYSE1->(dbGoTop())

		while QUERYSE1->(!eof())
		
			IF  QUERY->CTD_ITEM == QUERYSE1->TMP_CONTRATOSE1 
				nTotalREC += QUERYSE1->TMP_VALORSE1
			ENDIF
			QUERYSE1->(dbskip())
		enddo
		TRB1->XTOTPAGO	:= nTotalREC
		TRB1->XPERPAGO	:= (nTotalREC / TRB1->XVDCIRV)*100
		TRB1->XSLDPAGAR := TRB1->XVDCIRV- nTotalREC
		
		//******************* Totalizando Comissoes
		/*
		QUERYSE2->(dbGoTop())

		while QUERYSE2->(!eof())
			IF  alltrim(QUERY->CTD_ITEM) == alltrim(QUERYSE2->TMP_CONTRATOSE2) 
				nTotalPAG += QUERYSE2->TMP_VALORSE2
			ENDIF
			QUERYSE2->(dbskip())
		enddo
		*/
		TRB2->(dbGoTop())

		while TRB2->(!eof())
			IF  alltrim(QUERY->CTD_ITEM) == alltrim(TRB2->ITEMCONTA) 
				nTotalPAG += TRB2->VALOR
			ENDIF
			TRB2->(dbskip())
		enddo
		//*******************
		TRB1->XTOTPAGCM 	:= nTotalPAG
		TRB1->XPERPAGCM		:= (nTotalPAG / TRB1->XVCOMRV)*100
		TRB1->XSLDPAGCM 	:= TRB1->XVCOMRV - nTotalPAG
		TRB1->ITEM2		:= QUERY->CTD_ITEM
		TRB1->TRP		:= "T"
		MsUnlock()
		
		//******************* Detalhes de Recebimentos
		if MV_PAR09 == 1
			QUERYSE1->(dbGoTop())
			cItem 	:= TRB1->ITEM2
			nXVDCIR	:= TRB1->XVDCIRV
			while QUERYSE1->(!eof())
			
				IF  alltrim(cItem) == alltrim(QUERYSE1->TMP_CONTRATOSE1) 
					RecLock("TRB1",.T.)
					TRB1->TRP		:= "R"
					TRB1->ITEM		:= QUERYSE1->TMP_CONTRATOSE1
					TRB1->ITEM2		:= QUERYSE1->TMP_CONTRATOSE1
					TRB1->DATAMOV 	:= QUERYSE1->TMP_DATASE1
					TRB1->XTOTPAGO 	:= QUERYSE1->TMP_VALORSE1
					TRB1->XPERPAGO	:= (QUERYSE1->TMP_VALORSE1 / nXVDCIR)*100
					
					MsUnlock()
				ENDIF
				QUERYSE1->(dbskip())
				
			enddo
		endif
		
		//******************* Detalhes de Pagamentos
		if MV_PAR10 == 1
			TRB2->(dbGoTop())
			cItem 		:= TRB1->ITEM2
			nXVALCOM	:= (QUERY->CTD_XSISFR * (QUERY->CTD_XPCOM/100))
			while TRB2->(!eof())
				
				IF  alltrim(cItem) == alltrim(TRB2->ITEMCONTA) 
					RecLock("TRB1",.T.)
					TRB1->TRP		:= "P"
					TRB1->ITEM		:= TRB2->ITEMCONTA
					TRB1->ITEM2		:= TRB2->ITEMCONTA
					TRB1->DATAMOV2 	:= TRB2->DATAMOV
					TRB1->XTOTPAGCM := TRB2->VALOR
					TRB1->FORNECE	:= TRB2->CODFORN
					TRB1->FORNECED	:= TRB2->FORNECEDOR
					TRB1->XPERPAGCM	:= (TRB2->VALOR / nXVALCOM)*100
					MsUnlock()
				ENDIF
				/*
				IF  alltrim(cItem) == alltrim(QUERYSE2->TMP_CONTRATOSE2) 
					RecLock("TRB1",.T.)
					TRB1->ITEM2		:= QUERYSE2->TMP_CONTRATOSE2
					TRB1->DATAMOV2 	:= QUERYSE2->TMP_DATASE2
					TRB1->XTOTPAGCM := QUERYSE2->TMP_VALORSE2
					TRB1->FORNECE	:= QUERYSE2->TMP_FORNECE
					TRB1->FORNECED	:= QUERYSE2->TMP_EMPRESA
					TRB1->XPERPAGCM	:= (QUERYSE2->TMP_VALORSE2 / nXVALCOM)*100
					MsUnlock()
				ENDIF
				*/
				
				TRB2->(dbskip())
				
			enddo
		endif
		
		
		
		QUERY->(dbskip())
		
	nTotalREC := 0
	nTotalPAG := 0

enddo

	
QUERY->(dbclosearea())
QUERYSE1->(dbclosearea())
QUERYSE2->(dbclosearea())
return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PFIN01REAL∫												   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa o Project Status AT	/ EN	                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/


static function CTRCOMAT()

local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local _cQuerySE1	:= ""
Local QUERYSE1		:= ""
Local _cQuerySE2	:= ""
Local QUERYSE2		:= ""
Local nXSE1			:= 0

Local nTotalREC		:= 0
Local nTotalPAG		:= 0
Local nXVALCOM		:= 0

 Local cItem 		:= ""
 Local cConta 		:= ""
 Local cConta2 		:= ""

 Local nXVDSIR		:= 0
 Local nXVDCIR		:= 0
 Local nXCUPRR		:= 0
 Local nXBOOKMG		:= 0
 Local nXCUTOR		:= 0
 Local nXTOTPAGCM	:= 0
 
 Local nTotalC1		:= 0
 Local nTotalC2		:= 0
 Local nTotalC3		:= 0
 Local nTotalC4		:= 0
 Local nTotalC8		:= 0
 Local nTotalC9		:= 0
 Local nTotalC10	:= 0
 Local nTotalC11	:= 0
 Local nTotalC12	:= 0
 Local nTotalC13	:= 0

 Local nXPCOM		:= 0
 Local nXVCOM		:= 0
 Local nXVDSISF		:= 0

 Local nXVCOMR		:= 0
 Local nXVDSISFR	:= 0
 
 

 local dData1
 local dData2
 local cWeekJOB
//************************ Conexao Dados CTD - Contratos
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
CTD->(dbsetorder(1))

//*********************** Conexao SE1 - Recebimentos Efetivos Contrato


_cQuerySE1 := " SELECT DISTINCT E1_XXIC AS 'TMP_CONTRATOSE1', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATASE1', E5_VALOR AS 'TMP_VALORSE1',  "
_cQuerySE1 += "	A6_NOME AS 'TMP_NOME' FROM SE5010  "
_cQuerySE1 += " LEFT JOIN SE1010 ON SE1010.E1_NUM = SE5010.E5_NUMERO AND E1_CLIENTE = E5_CLIFOR  "
_cQuerySE1 += " LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA  "
_cQuerySE1 += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SE1010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "
_cQuerySE1 += " E5_RECPAG = 'R' AND E1_BAIXA <> '' AND E5_TIPODOC IN ('RA','VL')  "
_cQuerySE1 += " ORDER BY 1, 3   "

	IF Select("_cQuerySE1") <> 0
		DbSelectArea("_cQuerySE1")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuerySE1 NEW ALIAS "QUERYSE1"

	dbSelectArea("QUERYSE1")
	QUERYSE1->(dbGoTop())

//*********************** Conexao SE2 - Pagamento de Comissoes

_cQuerySE2 := " SELECT DISTINCT  E2_XXIC AS 'TMP_CONTRATOSE2', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATASE2', IIF(E5_RECPAG = 'R', -E5_VALOR, E5_VALOR)  AS 'TMP_VALORSE2', "
 _cQuerySE2 += "	ED_DESCRIC AS 'TMP_DESCRI', E5_NATUREZ AS 'TMP_NATUREZA', E2_NATUREZ AS 'TMP_NATUREZA2',  "
 _cQuerySE2 += "	E5_FORNECE AS 'TMP_FORNECE', E5_BENEF AS 'TMP_EMPRESA',  "
 _cQuerySE2 += "	E5_HISTOR AS 'TMP_HISTORICO', E5_DOCUMEN AS 'TMP_DOCUMENTO', E5_TIPO AS 'TMP_TIPO', E5_BANCO AS 'TMP_BANCO', E5_AGENCIA AS 'TMP_AGENCIA', A6_NOME AS 'TMP_NOME', E5_CONTA AS 'TMP_CONTA' " 
 _cQuerySE2 += "	FROM SE5010  "
 _cQuerySE2 += " LEFT JOIN SE2010 ON SE2010.E2_NUM = SE5010.E5_NUMERO AND SE2010.E2_FORNECE = SE5010.E5_FORNECE " 
 _cQuerySE2 += " LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA       "
 _cQuerySE2 += " LEFT JOIN SED010 ON SED010.ED_CODIGO = E5_NATUREZ  "
 _cQuerySE2 += " WHERE  "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND " 
 _cQuerySE2 += " E5_RECPAG = 'P' AND E5_TIPODOC IN ('CP','VL')  AND E2_NATUREZ = '6.21.00' OR    "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "  
 _cQuerySE2 += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('ES') AND E5_BANCO <> '' AND E2_NATUREZ = '6.21.00' OR "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND  "
 _cQuerySE2 += " E5_RECPAG = 'P' AND E5_TIPODOC IN ('CP','VL')  AND E2_NATUREZ = '6.22.00' OR    "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "  
 _cQuerySE2 += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('ES') AND E5_BANCO <> '' AND E2_NATUREZ = '6.22.00'  "
 _cQuerySE2 += " ORDER BY 6,3  "

	IF Select("_cQuerySE2") <> 0
		DbSelectArea("_cQuerySE2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuerySE2 NEW ALIAS "QUERYSE2"

	dbSelectArea("QUERYSE2")
	QUERYSE2->(dbGoTop())

//***********************

while QUERY->(!eof())

	
	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES/ESTOQUE'
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

	
	//************************ Filtro ano contrato
	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR11
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR12
		QUERY->(dbskip())
		Loop
	endif

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		TRB1->ITEM		:= QUERY->CTD_ITEM
		TRB1->CLIENTE	:= QUERY->CTD_XNREDU
		TRB1->NOMPM		:= QUERY->CTD_XNOMPM
		//****************************************
		TRB1->XVDCIVD	:= QUERY->CTD_XVDCI
		TRB1->XVDSIVD	:= QUERY->CTD_XVDSI
		TRB1->XSISFVVD	:= QUERY->CTD_XSISFV
		TRB1->XPCOMVD	:= QUERY->CTD_XPCOM
		TRB1->XVCOMVD	:= (TRB1->XSISFVVD * (QUERY->CTD_XPCOM/100))
		
		TRB1->XCUPRVD	:= QUERY->CTD_XCUSTO
		TRB1->XCOGSVD	:= QUERY->CTD_XCOGSV
		TRB1->XMGCTVD	:= ((QUERY->CTD_XVDSI - (QUERY->CTD_XCUTOT)) / QUERY->CTD_XVDSI )*100

		//****************************************
		TRB1->XVDCIRV	:= QUERY->CTD_XVDCIR
		TRB1->XVDSIRV	:= QUERY->CTD_XVDSIR
		TRB1->XSISFVRV	:= QUERY->CTD_XSISFR
		TRB1->XPCOMRV	:= QUERY->CTD_XPCOM
		TRB1->XVCOMRV	:= (TRB1->XSISFVRV * (QUERY->CTD_XPCOM/100))
		
		TRB1->XCUPRRV	:= QUERY->CTD_XCUPRR
		TRB1->XCOGSRV	:= QUERY->CTD_XCOGSR
		TRB1->XMGCTRV	:= ((QUERY->CTD_XVDSIR - (QUERY->CTD_XCUTOR)) / QUERY->CTD_XVDSIR )*100
		//*******************
		TRB1->XREPR1	:= QUERY->CTD_XREPR1
		TRB1->XNRED1	:= QUERY->CTD_XNRED1
		TRB1->XCOR1		:= QUERY->CTD_XCOR1
		if QUERY->CTD_XCOR1 > 0
			TRB1->XVCOR1	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR1/100)
		else
			TRB1->XVCOR1	:= 0
		endif
		
		TRB1->XREPR2	:= QUERY->CTD_XREPR2
		TRB1->XNRED2	:= QUERY->CTD_XNRED2
		TRB1->XCOR2		:= QUERY->CTD_XCOR2
		if QUERY->CTD_XCOR2 > 0
			TRB1->XVCOR2	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR2/100)
		else
			TRB1->XVCOR2	:= 0
		endif
		
		TRB1->XREPR3	:= QUERY->CTD_XREPR3
		TRB1->XNRED3	:= QUERY->CTD_XNRED3
		TRB1->XCOR3		:= QUERY->CTD_XCOR3
		if QUERY->CTD_XCOR3 > 0
			TRB1->XVCOR3	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR3/100)
		else
			TRB1->XVCOR3	:= 0
		endif
		
		TRB1->XREPR4	:= QUERY->CTD_XREPR4
		TRB1->XNRED4	:= QUERY->CTD_XNRED4
		TRB1->XCOR4		:= QUERY->CTD_XCOR4
		if QUERY->CTD_XCOR4 > 0
			TRB1->XVCOR4	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR4/100)
		else
			TRB1->XVCOR4	:= 0
		endif
		//******************* Totalizando Pagamentos	
		QUERYSE1->(dbGoTop())

		while QUERYSE1->(!eof())
		
			IF  QUERY->CTD_ITEM == QUERYSE1->TMP_CONTRATOSE1 
				nTotalREC += QUERYSE1->TMP_VALORSE1
			ENDIF
			QUERYSE1->(dbskip())
		enddo
		TRB1->XTOTPAGO	:= nTotalREC
		TRB1->XPERPAGO	:= (nTotalREC / TRB1->XVDCIRV)*100
		TRB1->XSLDPAGAR := TRB1->XVDCIRV- nTotalREC
		
		//******************* Totalizando Comissoes
		/*
		QUERYSE2->(dbGoTop())

		while QUERYSE2->(!eof())
			IF  alltrim(QUERY->CTD_ITEM) == alltrim(QUERYSE2->TMP_CONTRATOSE2) 
				nTotalPAG += QUERYSE2->TMP_VALORSE2
			ENDIF
			QUERYSE2->(dbskip())
		enddo
		*/
		TRB2->(dbGoTop())

		while TRB2->(!eof())
			IF  alltrim(QUERY->CTD_ITEM) == alltrim(TRB2->ITEMCONTA) 
				nTotalPAG += TRB2->VALOR
			ENDIF
			TRB2->(dbskip())
		enddo
		//*******************
		TRB1->XTOTPAGCM 	:= nTotalPAG
		TRB1->XPERPAGCM		:= (nTotalPAG / TRB1->XVCOMRV)*100
		TRB1->XSLDPAGCM 	:= TRB1->XVCOMRV - nTotalPAG
		TRB1->ITEM2		:= QUERY->CTD_ITEM
		TRB1->TRP		:= "T"
		MsUnlock()
		
		//******************* Detalhes de Recebimentos
		if MV_PAR09 == 1
			QUERYSE1->(dbGoTop())
			cItem 	:= TRB1->ITEM2
			nXVDCIR	:= TRB1->XVDCIRV
			while QUERYSE1->(!eof())
			
				IF  alltrim(cItem) == alltrim(QUERYSE1->TMP_CONTRATOSE1) 
					RecLock("TRB1",.T.)
					TRB1->TRP		:= "R"
					TRB1->ITEM		:= QUERYSE1->TMP_CONTRATOSE1
					TRB1->ITEM2		:= QUERYSE1->TMP_CONTRATOSE1
					TRB1->DATAMOV 	:= QUERYSE1->TMP_DATASE1
					TRB1->XTOTPAGO 	:= QUERYSE1->TMP_VALORSE1
					TRB1->XPERPAGO	:= (QUERYSE1->TMP_VALORSE1 / nXVDCIR)*100
					
					MsUnlock()
				ENDIF
				QUERYSE1->(dbskip())
				
			enddo
		endif
		
		//******************* Detalhes de Pagamentos
		if MV_PAR10 == 1
			TRB2->(dbGoTop())
			cItem 		:= TRB1->ITEM2
			nXVALCOM	:= (QUERY->CTD_XSISFR * (QUERY->CTD_XPCOM/100))
			while TRB2->(!eof())
				
				IF  alltrim(cItem) == alltrim(TRB2->ITEMCONTA) 
					RecLock("TRB1",.T.)
					TRB1->TRP		:= "P"
					TRB1->ITEM		:= TRB2->ITEMCONTA
					TRB1->ITEM2		:= TRB2->ITEMCONTA
					TRB1->DATAMOV2 	:= TRB2->DATAMOV
					TRB1->XTOTPAGCM := TRB2->VALOR
					TRB1->FORNECE	:= TRB2->CODFORN
					TRB1->FORNECED	:= TRB2->FORNECEDOR
					TRB1->XPERPAGCM	:= (TRB2->VALOR / nXVALCOM)*100
					MsUnlock()
				ENDIF
				/*
				IF  alltrim(cItem) == alltrim(QUERYSE2->TMP_CONTRATOSE2) 
					RecLock("TRB1",.T.)
					TRB1->ITEM2		:= QUERYSE2->TMP_CONTRATOSE2
					TRB1->DATAMOV2 	:= QUERYSE2->TMP_DATASE2
					TRB1->XTOTPAGCM := QUERYSE2->TMP_VALORSE2
					TRB1->FORNECE	:= QUERYSE2->TMP_FORNECE
					TRB1->FORNECED	:= QUERYSE2->TMP_EMPRESA
					TRB1->XPERPAGCM	:= (QUERYSE2->TMP_VALORSE2 / nXVALCOM)*100
					MsUnlock()
				ENDIF
				*/
				
				TRB2->(dbskip())
				
			enddo
		endif
		
		
		
		QUERY->(dbskip())
		
	nTotalREC := 0
	nTotalPAG := 0

enddo

	
QUERY->(dbclosearea())
QUERYSE1->(dbclosearea())
QUERYSE2->(dbclosearea())
return



/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PROSTATPR												   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa o Project Status PR			                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

static function CTRCOMPR()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local _cQuerySE1	:= ""
Local QUERYSE1		:= ""
Local _cQuerySE2	:= ""
Local QUERYSE2		:= ""
Local nXSE1			:= 0

Local nTotalREC		:= 0
Local nTotalPAG		:= 0
Local nXVALCOM		:= 0

 Local cItem 		:= ""
 Local cConta 		:= ""
 Local cConta2 		:= ""

 Local nXVDSIR		:= 0
 Local nXVDCIR		:= 0
 Local nXCUPRR		:= 0
 Local nXBOOKMG		:= 0
 Local nXCUTOR		:= 0
 Local nXTOTPAGCM	:= 0
 
 Local nTotalC1		:= 0
 Local nTotalC2		:= 0
 Local nTotalC3		:= 0
 Local nTotalC4		:= 0
 Local nTotalC8		:= 0
 Local nTotalC9		:= 0
 Local nTotalC10	:= 0
 Local nTotalC11	:= 0
 Local nTotalC12	:= 0
 Local nTotalC13	:= 0

 Local nXPCOM		:= 0
 Local nXVCOM		:= 0
 Local nXVDSISF		:= 0

 Local nXVCOMR		:= 0
 Local nXVDSISFR	:= 0
 
 

 local dData1
 local dData2
 local cWeekJOB
//************************ Conexao Dados CTD - Contratos
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
CTD->(dbsetorder(1))

//*********************** Conexao SE1 - Recebimentos Efetivos Contrato


_cQuerySE1 := " SELECT DISTINCT E1_XXIC AS 'TMP_CONTRATOSE1', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATASE1', E5_VALOR AS 'TMP_VALORSE1',  "
_cQuerySE1 += "	A6_NOME AS 'TMP_NOME' FROM SE5010  "
_cQuerySE1 += " LEFT JOIN SE1010 ON SE1010.E1_NUM = SE5010.E5_NUMERO AND E1_CLIENTE = E5_CLIFOR  "
_cQuerySE1 += " LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA  "
_cQuerySE1 += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SE1010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "
_cQuerySE1 += " E5_RECPAG = 'R' AND E1_BAIXA <> '' AND E5_TIPODOC IN ('RA','VL')  "
_cQuerySE1 += " ORDER BY 1, 3   "

	IF Select("_cQuerySE1") <> 0
		DbSelectArea("_cQuerySE1")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuerySE1 NEW ALIAS "QUERYSE1"

	dbSelectArea("QUERYSE1")
	QUERYSE1->(dbGoTop())

//*********************** Conexao SE2 - Pagamento de Comissoes

_cQuerySE2 := " SELECT DISTINCT  E2_XXIC AS 'TMP_CONTRATOSE2', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATASE2', IIF(E5_RECPAG = 'R', -E5_VALOR, E5_VALOR)  AS 'TMP_VALORSE2', "
 _cQuerySE2 += "	ED_DESCRIC AS 'TMP_DESCRI', E5_NATUREZ AS 'TMP_NATUREZA', E2_NATUREZ AS 'TMP_NATUREZA2',  "
 _cQuerySE2 += "	E5_FORNECE AS 'TMP_FORNECE', E5_BENEF AS 'TMP_EMPRESA',  "
 _cQuerySE2 += "	E5_HISTOR AS 'TMP_HISTORICO', E5_DOCUMEN AS 'TMP_DOCUMENTO', E5_TIPO AS 'TMP_TIPO', E5_BANCO AS 'TMP_BANCO', E5_AGENCIA AS 'TMP_AGENCIA', A6_NOME AS 'TMP_NOME', E5_CONTA AS 'TMP_CONTA' " 
 _cQuerySE2 += "	FROM SE5010  "
 _cQuerySE2 += " LEFT JOIN SE2010 ON SE2010.E2_NUM = SE5010.E5_NUMERO AND SE2010.E2_FORNECE = SE5010.E5_FORNECE " 
 _cQuerySE2 += " LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA       "
 _cQuerySE2 += " LEFT JOIN SED010 ON SED010.ED_CODIGO = E5_NATUREZ  "
 _cQuerySE2 += " WHERE  "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND " 
 _cQuerySE2 += " E5_RECPAG = 'P' AND E5_TIPODOC IN ('CP','VL')  AND E2_NATUREZ = '6.21.00' OR    "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "  
 _cQuerySE2 += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('ES') AND E5_BANCO <> '' AND E2_NATUREZ = '6.21.00' OR "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND  "
 _cQuerySE2 += " E5_RECPAG = 'P' AND E5_TIPODOC IN ('CP','VL')  AND E2_NATUREZ = '6.22.00' OR    "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "  
 _cQuerySE2 += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('ES') AND E5_BANCO <> '' AND E2_NATUREZ = '6.22.00'  "
 _cQuerySE2 += " ORDER BY 6,3  "

	IF Select("_cQuerySE2") <> 0
		DbSelectArea("_cQuerySE2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuerySE2 NEW ALIAS "QUERYSE2"

	dbSelectArea("QUERYSE2")
	QUERYSE2->(dbGoTop())

//***********************

while QUERY->(!eof())

	
	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES/ESTOQUE'
		QUERY->(dbskip())
		Loop
	endif

	if ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'GR/CM/EN/AT/ST/EQ'
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
	
	//************************ Filtro ano contrato
	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR11
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR12
		QUERY->(dbskip())
		Loop
	endif

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		TRB1->ITEM		:= QUERY->CTD_ITEM
		TRB1->CLIENTE	:= QUERY->CTD_XNREDU
		TRB1->NOMPM		:= QUERY->CTD_XNOMPM
		//****************************************
		TRB1->XVDCIVD	:= QUERY->CTD_XVDCI
		TRB1->XVDSIVD	:= QUERY->CTD_XVDSI
		TRB1->XSISFVVD	:= QUERY->CTD_XSISFV
		TRB1->XPCOMVD	:= QUERY->CTD_XPCOM
		TRB1->XVCOMVD	:= (TRB1->XSISFVVD * (QUERY->CTD_XPCOM/100))
		
		TRB1->XCUPRVD	:= QUERY->CTD_XCUSTO
		TRB1->XCOGSVD	:= QUERY->CTD_XCOGSV
		TRB1->XMGCTVD	:= ((QUERY->CTD_XVDSI - (QUERY->CTD_XCUTOT)) / QUERY->CTD_XVDSI )*100

		//****************************************
		TRB1->XVDCIRV	:= QUERY->CTD_XVDCIR
		TRB1->XVDSIRV	:= QUERY->CTD_XVDSIR
		TRB1->XSISFVRV	:= QUERY->CTD_XSISFR
		TRB1->XPCOMRV	:= QUERY->CTD_XPCOM
		TRB1->XVCOMRV	:= (TRB1->XSISFVRV * (QUERY->CTD_XPCOM/100))
		
		TRB1->XCUPRRV	:= QUERY->CTD_XCUPRR
		TRB1->XCOGSRV	:= QUERY->CTD_XCOGSR
		TRB1->XMGCTRV	:= ((QUERY->CTD_XVDSIR - (QUERY->CTD_XCUTOR)) / QUERY->CTD_XVDSIR )*100
		
		//*******************
		TRB1->XREPR1	:= QUERY->CTD_XREPR1
		TRB1->XNRED1	:= QUERY->CTD_XNRED1
		TRB1->XCOR1		:= QUERY->CTD_XCOR1
		if QUERY->CTD_XCOR1 > 0
			TRB1->XVCOR1	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR1/100)
		else
			TRB1->XVCOR1	:= 0
		endif
		
		TRB1->XREPR2	:= QUERY->CTD_XREPR2
		TRB1->XNRED2	:= QUERY->CTD_XNRED2
		TRB1->XCOR2		:= QUERY->CTD_XCOR2
		if QUERY->CTD_XCOR2 > 0
			TRB1->XVCOR2	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR2/100)
		else
			TRB1->XVCOR2	:= 0
		endif
		
		TRB1->XREPR3	:= QUERY->CTD_XREPR3
		TRB1->XNRED3	:= QUERY->CTD_XNRED3
		TRB1->XCOR3		:= QUERY->CTD_XCOR3
		if QUERY->CTD_XCOR3 > 0
			TRB1->XVCOR3	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR3/100)
		else
			TRB1->XVCOR3	:= 0
		endif
		
		TRB1->XREPR4	:= QUERY->CTD_XREPR4
		TRB1->XNRED4	:= QUERY->CTD_XNRED4
		TRB1->XCOR4		:= QUERY->CTD_XCOR4
		if QUERY->CTD_XCOR4 > 0
			TRB1->XVCOR4	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR4/100)
		else
			TRB1->XVCOR4	:= 0
		endif
		//******************* Totalizando Pagamentos	
		QUERYSE1->(dbGoTop())

		while QUERYSE1->(!eof())
		
			IF  QUERY->CTD_ITEM == QUERYSE1->TMP_CONTRATOSE1 
				nTotalREC += QUERYSE1->TMP_VALORSE1
			ENDIF
			QUERYSE1->(dbskip())
		enddo
		TRB1->XTOTPAGO	:= nTotalREC
		TRB1->XPERPAGO	:= (nTotalREC / TRB1->XVDCIRV)*100
		TRB1->XSLDPAGAR := TRB1->XVDCIRV- nTotalREC
		
		//******************* Totalizando Comissoes
		/*
		QUERYSE2->(dbGoTop())

		while QUERYSE2->(!eof())
			IF  alltrim(QUERY->CTD_ITEM) == alltrim(QUERYSE2->TMP_CONTRATOSE2) 
				nTotalPAG += QUERYSE2->TMP_VALORSE2
			ENDIF
			QUERYSE2->(dbskip())
		enddo
		*/
		TRB2->(dbGoTop())

		while TRB2->(!eof())
			IF  alltrim(QUERY->CTD_ITEM) == alltrim(TRB2->ITEMCONTA) 
				nTotalPAG += TRB2->VALOR
			ENDIF
			TRB2->(dbskip())
		enddo
		//*******************
		TRB1->XTOTPAGCM 	:= nTotalPAG
		TRB1->XPERPAGCM		:= (nTotalPAG / TRB1->XVCOMRV)*100
		TRB1->XSLDPAGCM 	:= TRB1->XVCOMRV - nTotalPAG
		TRB1->ITEM2		:= QUERY->CTD_ITEM
		TRB1->TRP		:= "T"
		MsUnlock()
		
		//******************* Detalhes de Recebimentos
		if MV_PAR09 == 1
			QUERYSE1->(dbGoTop())
			cItem 	:= TRB1->ITEM2
			nXVDCIR	:= TRB1->XVDCIRV
			while QUERYSE1->(!eof())
			
				IF  alltrim(cItem) == alltrim(QUERYSE1->TMP_CONTRATOSE1) 
					RecLock("TRB1",.T.)
					TRB1->TRP		:= "R"
					TRB1->ITEM		:= QUERYSE1->TMP_CONTRATOSE1
					TRB1->ITEM2		:= QUERYSE1->TMP_CONTRATOSE1
					TRB1->DATAMOV 	:= QUERYSE1->TMP_DATASE1
					TRB1->XTOTPAGO 	:= QUERYSE1->TMP_VALORSE1
					TRB1->XPERPAGO	:= (QUERYSE1->TMP_VALORSE1 / nXVDCIR)*100
					
					MsUnlock()
				ENDIF
				QUERYSE1->(dbskip())
				
			enddo
		endif
		
		//******************* Detalhes de Pagamentos
		if MV_PAR10 == 1
			TRB2->(dbGoTop())
			cItem 		:= TRB1->ITEM2
			nXVALCOM	:= (QUERY->CTD_XSISFR * (QUERY->CTD_XPCOM/100))
			while TRB2->(!eof())
				
				IF  alltrim(cItem) == alltrim(TRB2->ITEMCONTA) 
					RecLock("TRB1",.T.)
					TRB1->TRP		:= "P"
					TRB1->ITEM		:= TRB2->ITEMCONTA
					TRB1->ITEM2		:= TRB2->ITEMCONTA
					TRB1->DATAMOV2 	:= TRB2->DATAMOV
					TRB1->XTOTPAGCM := TRB2->VALOR
					TRB1->FORNECE	:= TRB2->CODFORN
					TRB1->FORNECED	:= TRB2->FORNECEDOR
					TRB1->XPERPAGCM	:= (TRB2->VALOR / nXVALCOM)*100
					MsUnlock()
				ENDIF
				/*
				IF  alltrim(cItem) == alltrim(QUERYSE2->TMP_CONTRATOSE2) 
					RecLock("TRB1",.T.)
					TRB1->ITEM2		:= QUERYSE2->TMP_CONTRATOSE2
					TRB1->DATAMOV2 	:= QUERYSE2->TMP_DATASE2
					TRB1->XTOTPAGCM := QUERYSE2->TMP_VALORSE2
					TRB1->FORNECE	:= QUERYSE2->TMP_FORNECE
					TRB1->FORNECED	:= QUERYSE2->TMP_EMPRESA
					TRB1->XPERPAGCM	:= (QUERYSE2->TMP_VALORSE2 / nXVALCOM)*100
					MsUnlock()
				ENDIF
				*/
				
				TRB2->(dbskip())
				
			enddo
		endif
		
		
		
		QUERY->(dbskip())
		
	nTotalREC := 0
	nTotalPAG := 0

enddo

	
QUERY->(dbclosearea())
QUERYSE1->(dbclosearea())
QUERYSE2->(dbclosearea())
return


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PROSTATPR												   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processa o Project Status PR			                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

static function CTRCOMCM()

local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local _cQuerySE1	:= ""
Local QUERYSE1		:= ""
Local _cQuerySE2	:= ""
Local QUERYSE2		:= ""
Local nXSE1			:= 0

Local nTotalREC		:= 0
Local nTotalPAG		:= 0
Local nXVALCOM		:= 0

 Local cItem 		:= ""
 Local cConta 		:= ""
 Local cConta2 		:= ""

 Local nXVDSIR		:= 0
 Local nXVDCIR		:= 0
 Local nXCUPRR		:= 0
 Local nXBOOKMG		:= 0
 Local nXCUTOR		:= 0
 Local nXTOTPAGCM	:= 0
 
 Local nTotalC1		:= 0
 Local nTotalC2		:= 0
 Local nTotalC3		:= 0
 Local nTotalC4		:= 0
 Local nTotalC8		:= 0
 Local nTotalC9		:= 0
 Local nTotalC10	:= 0
 Local nTotalC11	:= 0
 Local nTotalC12	:= 0
 Local nTotalC13	:= 0

 Local nXPCOM		:= 0
 Local nXVCOM		:= 0
 Local nXVDSISF		:= 0

 Local nXVCOMR		:= 0
 Local nXVDSISFR	:= 0
 
 

 local dData1
 local dData2
 local cWeekJOB
//************************ Conexao Dados CTD - Contratos
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
CTD->(dbsetorder(1))

//*********************** Conexao SE1 - Recebimentos Efetivos Contrato


_cQuerySE1 := " SELECT DISTINCT E1_XXIC AS 'TMP_CONTRATOSE1', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATASE1', E5_VALOR AS 'TMP_VALORSE1',  "
_cQuerySE1 += "	A6_NOME AS 'TMP_NOME' FROM SE5010  "
_cQuerySE1 += " LEFT JOIN SE1010 ON SE1010.E1_NUM = SE5010.E5_NUMERO AND E1_CLIENTE = E5_CLIFOR  "
_cQuerySE1 += " LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA  "
_cQuerySE1 += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SE1010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "
_cQuerySE1 += " E5_RECPAG = 'R' AND E1_BAIXA <> '' AND E5_TIPODOC IN ('RA','VL')  "
_cQuerySE1 += " ORDER BY 1, 3   "

	IF Select("_cQuerySE1") <> 0
		DbSelectArea("_cQuerySE1")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuerySE1 NEW ALIAS "QUERYSE1"

	dbSelectArea("QUERYSE1")
	QUERYSE1->(dbGoTop())

//*********************** Conexao SE2 - Pagamento de Comissoes

_cQuerySE2 := " SELECT DISTINCT  E2_XXIC AS 'TMP_CONTRATOSE2', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATASE2', IIF(E5_RECPAG = 'R', -E5_VALOR, E5_VALOR)  AS 'TMP_VALORSE2', "
 _cQuerySE2 += "	ED_DESCRIC AS 'TMP_DESCRI', E5_NATUREZ AS 'TMP_NATUREZA', E2_NATUREZ AS 'TMP_NATUREZA2',  "
 _cQuerySE2 += "	E5_FORNECE AS 'TMP_FORNECE', E5_BENEF AS 'TMP_EMPRESA',  "
 _cQuerySE2 += "	E5_HISTOR AS 'TMP_HISTORICO', E5_DOCUMEN AS 'TMP_DOCUMENTO', E5_TIPO AS 'TMP_TIPO', E5_BANCO AS 'TMP_BANCO', E5_AGENCIA AS 'TMP_AGENCIA', A6_NOME AS 'TMP_NOME', E5_CONTA AS 'TMP_CONTA' " 
 _cQuerySE2 += "	FROM SE5010  "
 _cQuerySE2 += " LEFT JOIN SE2010 ON SE2010.E2_NUM = SE5010.E5_NUMERO AND SE2010.E2_FORNECE = SE5010.E5_FORNECE " 
 _cQuerySE2 += " LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA       "
 _cQuerySE2 += " LEFT JOIN SED010 ON SED010.ED_CODIGO = E5_NATUREZ  "
 _cQuerySE2 += " WHERE  "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND " 
 _cQuerySE2 += " E5_RECPAG = 'P' AND E5_TIPODOC IN ('CP','VL')  AND E2_NATUREZ = '6.21.00' OR    "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "  
 _cQuerySE2 += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('ES') AND E5_BANCO <> '' AND E2_NATUREZ = '6.21.00' OR "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND  "
 _cQuerySE2 += " E5_RECPAG = 'P' AND E5_TIPODOC IN ('CP','VL')  AND E2_NATUREZ = '6.22.00' OR    "
 _cQuerySE2 += " SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "  
 _cQuerySE2 += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('ES') AND E5_BANCO <> '' AND E2_NATUREZ = '6.22.00'  "
 _cQuerySE2 += " ORDER BY 6,3  "

	IF Select("_cQuerySE2") <> 0
		DbSelectArea("_cQuerySE2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuerySE2 NEW ALIAS "QUERYSE2"

	dbSelectArea("QUERYSE2")
	QUERYSE2->(dbGoTop())

//***********************

while QUERY->(!eof())

	
	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES/ESTOQUE'
		QUERY->(dbskip())
		Loop
	endif

	if ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'GR/PR/EN/AT/ST/EQ'
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
	
	//************************ Filtro ano contrato
	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR11
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR12
		QUERY->(dbskip())
		Loop
	endif

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		TRB1->ITEM		:= QUERY->CTD_ITEM
		TRB1->CLIENTE	:= QUERY->CTD_XNREDU
		TRB1->NOMPM		:= QUERY->CTD_XNOMPM
		//****************************************
		TRB1->XVDCIVD	:= QUERY->CTD_XVDCI
		TRB1->XVDSIVD	:= QUERY->CTD_XVDSI
		TRB1->XSISFVVD	:= QUERY->CTD_XSISFV
		TRB1->XPCOMVD	:= QUERY->CTD_XPCOM
		TRB1->XVCOMVD	:= (TRB1->XSISFVVD * (QUERY->CTD_XPCOM/100))
		
		TRB1->XCUPRVD	:= QUERY->CTD_XCUSTO
		TRB1->XCOGSVD	:= QUERY->CTD_XCOGSV
		TRB1->XMGCTVD	:= ((QUERY->CTD_XVDSI - (QUERY->CTD_XCUTOT)) / QUERY->CTD_XVDSI )*100

		//****************************************
		TRB1->XVDCIRV	:= QUERY->CTD_XVDCIR
		TRB1->XVDSIRV	:= QUERY->CTD_XVDSIR
		TRB1->XSISFVRV	:= QUERY->CTD_XSISFR
		TRB1->XPCOMRV	:= QUERY->CTD_XPCOM
		TRB1->XVCOMRV	:= (TRB1->XSISFVRV * (QUERY->CTD_XPCOM/100))
		
		TRB1->XCUPRRV	:= QUERY->CTD_XCUPRR
		TRB1->XCOGSRV	:= QUERY->CTD_XCOGSR
		TRB1->XMGCTRV	:= ((QUERY->CTD_XVDSIR - (QUERY->CTD_XCUTOR)) / QUERY->CTD_XVDSIR )*100
		
		//*******************
		TRB1->XREPR1	:= QUERY->CTD_XREPR1
		TRB1->XNRED1	:= QUERY->CTD_XNRED1
		TRB1->XCOR1		:= QUERY->CTD_XCOR1
		if QUERY->CTD_XCOR1 > 0
			TRB1->XVCOR1	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR1/100)
		else
			TRB1->XVCOR1	:= 0
		endif
		
		TRB1->XREPR2	:= QUERY->CTD_XREPR2
		TRB1->XNRED2	:= QUERY->CTD_XNRED2
		TRB1->XCOR2		:= QUERY->CTD_XCOR2
		if QUERY->CTD_XCOR2 > 0
			TRB1->XVCOR2	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR2/100)
		else
			TRB1->XVCOR2	:= 0
		endif
		
		TRB1->XREPR3	:= QUERY->CTD_XREPR3
		TRB1->XNRED3	:= QUERY->CTD_XNRED3
		TRB1->XCOR3		:= QUERY->CTD_XCOR3
		if QUERY->CTD_XCOR3 > 0
			TRB1->XVCOR3	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR3/100)
		else
			TRB1->XVCOR3	:= 0
		endif
		
		TRB1->XREPR4	:= QUERY->CTD_XREPR4
		TRB1->XNRED4	:= QUERY->CTD_XNRED4
		TRB1->XCOR4		:= QUERY->CTD_XCOR4
		if QUERY->CTD_XCOR4 > 0
			TRB1->XVCOR4	:= TRB1->XVCOMRV * (QUERY->CTD_XCOR4/100)
		else
			TRB1->XVCOR4	:= 0
		endif
		//******************* Totalizando Pagamentos	
		QUERYSE1->(dbGoTop())

		while QUERYSE1->(!eof())
		
			IF  QUERY->CTD_ITEM == QUERYSE1->TMP_CONTRATOSE1 
				nTotalREC += QUERYSE1->TMP_VALORSE1
			ENDIF
			QUERYSE1->(dbskip())
		enddo
		TRB1->XTOTPAGO	:= nTotalREC
		TRB1->XPERPAGO	:= (nTotalREC / TRB1->XVDCIRV)*100
		TRB1->XSLDPAGAR := TRB1->XVDCIRV- nTotalREC
		
		//******************* Totalizando Comissoes
		/*
		QUERYSE2->(dbGoTop())

		while QUERYSE2->(!eof())
			IF  alltrim(QUERY->CTD_ITEM) == alltrim(QUERYSE2->TMP_CONTRATOSE2) 
				nTotalPAG += QUERYSE2->TMP_VALORSE2
			ENDIF
			QUERYSE2->(dbskip())
		enddo
		*/
		TRB2->(dbGoTop())

		while TRB2->(!eof())
			IF  alltrim(QUERY->CTD_ITEM) == alltrim(TRB2->ITEMCONTA) 
				nTotalPAG += TRB2->VALOR
			ENDIF
			TRB2->(dbskip())
		enddo
		//*******************
		TRB1->XTOTPAGCM 	:= nTotalPAG
		TRB1->XPERPAGCM		:= (nTotalPAG / TRB1->XVCOMRV)*100
		TRB1->XSLDPAGCM 	:= TRB1->XVCOMRV - nTotalPAG
		TRB1->ITEM2		:= QUERY->CTD_ITEM
		TRB1->TRP		:= "T"
		
		MsUnlock()
		
		//******************* Detalhes de Recebimentos
		if MV_PAR09 == 1
			QUERYSE1->(dbGoTop())
			cItem 	:= TRB1->ITEM2
			nXVDCIR	:= TRB1->XVDCIRV
			while QUERYSE1->(!eof())
			
				IF  alltrim(cItem) == alltrim(QUERYSE1->TMP_CONTRATOSE1) 
					RecLock("TRB1",.T.)
					TRB1->TRP		:= "R"
					TRB1->ITEM		:= QUERYSE1->TMP_CONTRATOSE1
					TRB1->ITEM2		:= QUERYSE1->TMP_CONTRATOSE1
					TRB1->DATAMOV 	:= QUERYSE1->TMP_DATASE1
					TRB1->XTOTPAGO 	:= QUERYSE1->TMP_VALORSE1
					TRB1->XPERPAGO	:= (QUERYSE1->TMP_VALORSE1 / nXVDCIR)*100
					
					MsUnlock()
				ENDIF
				QUERYSE1->(dbskip())
				
			enddo
		endif
		
		//******************* Detalhes de Pagamentos
		if MV_PAR10 == 1
			TRB2->(dbGoTop())
			cItem 		:= TRB1->ITEM2
			nXVALCOM	:= (QUERY->CTD_XSISFR * (QUERY->CTD_XPCOM/100))
			while TRB2->(!eof())
				
				IF  alltrim(cItem) == alltrim(TRB2->ITEMCONTA) 
					RecLock("TRB1",.T.)
					TRB1->TRP		:= "P"
					TRB1->ITEM		:= TRB2->ITEMCONTA
					TRB1->ITEM2		:= TRB2->ITEMCONTA
					TRB1->DATAMOV2 	:= TRB2->DATAMOV
					TRB1->XTOTPAGCM := TRB2->VALOR
					TRB1->FORNECE	:= TRB2->CODFORN
					TRB1->FORNECED	:= TRB2->FORNECEDOR
					TRB1->XPERPAGCM	:= (TRB2->VALOR / nXVALCOM)*100
					MsUnlock()
				ENDIF
				/*
				IF  alltrim(cItem) == alltrim(QUERYSE2->TMP_CONTRATOSE2) 
					RecLock("TRB1",.T.)
					TRB1->ITEM2		:= QUERYSE2->TMP_CONTRATOSE2
					TRB1->DATAMOV2 	:= QUERYSE2->TMP_DATASE2
					TRB1->XTOTPAGCM := QUERYSE2->TMP_VALORSE2
					TRB1->FORNECE	:= QUERYSE2->TMP_FORNECE
					TRB1->FORNECED	:= QUERYSE2->TMP_EMPRESA
					TRB1->XPERPAGCM	:= (QUERYSE2->TMP_VALORSE2 / nXVALCOM)*100
					MsUnlock()
				ENDIF
				*/
				
				TRB2->(dbskip())
				
			enddo
		endif
		
		
		
		QUERY->(dbskip())
		
	nTotalREC := 0
	nTotalPAG := 0

enddo

	
QUERY->(dbclosearea())
QUERYSE1->(dbclosearea())
QUERYSE2->(dbclosearea())
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
Local nPosicao := 0

Local cItem := TRB1->ITEM
Local aInd:={}
Local cCondicao
Local bFiltraBrw

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private aHeader2:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oGetDbSint2
Private _oDlgSint
Private _aColumns := {}

if MV_PAR13 == 1
	cCadastro := "Controle de Comissıes"
	
	DEFINE MSDIALOG _oDlgSint ;
	TITLE "Controle de Comissoes"  ;
	From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"
	
	// Monta aHeader do TRB1
	aadd(aHeader, {"Item Conta"													,"ITEM"		,""					,25,0,0			,"","C","TRB1",""})
	aadd(aHeader, {"Cliente"													,"CLIENTE"	,""					,40,0,""		,"","C","TRB1",""})
	
	aadd(aHeader, {"Venda c/ Tributos"											,"XVDCIVD"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	aadd(aHeader, {"s/ Tributos"												,"XVDSIVD"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	aadd(aHeader, {"s/ Trib." + Chr(13) + Chr(10) + " s/ Frete"					,"XSISFVVD"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	aadd(aHeader, {"% Comiss„o"													,"XPCOMVD"	,"@E 99,999,999.99"	,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Valor " + Chr(13) + Chr(10) + "Comiss„o"					,"XVCOMVD"	,"@E 99,999,999.99"	,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Custo de " + Chr(13) + Chr(10) + "ProduÁ„o"					,"XCUPRVD"	,"@E 99,999,999.99"	,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"COGS"														,"XCOGSVD"	,"@E 99,999,999.99"	,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Marg.Contrib."											,"XMGCTVD"	,"@E 999,999.99"	,15,2,""		,"","N","TRB1",""})

		
	aadd(aHeader, {"Venda c/ " + Chr(13) + Chr(10) + "Tributos Rev."			,"XVDCIRV"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	aadd(aHeader, {"s/ Tributos Rev."											,"XVDSIRV"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	aadd(aHeader, {"s/ Trib." + Chr(13) + Chr(10) + " s/ Frete Rev."			,"XSISFVRV"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Comiss„o Rev."											,"XPCOMRV"	,"@E 99,999,999.99"	,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Valor Comiss„o Rev."										,"XVCOMRV"	,"@E 99,999,999.99"	,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Custo de ProduÁ„o Rev."										,"XCUPRRV"	,"@E 99,999,999.99"	,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"COGS Rev."													,"XCOGSRV"	,"@E 99,999,999.99"	,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Marg.Contrib.Rev"											,"XMGCTRV"	,"@E 999,999.99"	,15,2,""		,"","N","TRB1",""})
	
	
		aadd(aHeader, {"Data Recebimento"										,"DATAMOV"	,""					,08,0,""		,"","D","TRB1",""})
	
	aadd(aHeader, {"Recebimento Cliente"										,"XTOTPAGO"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	aadd(aHeader, {"% Recebido"													,"XPERPAGO"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	aadd(aHeader, {"Saldo a Receber"											,"XSLDPAGAR","@E 99,999,999.99",15,2,""			,"","N","TRB1",""})

		aadd(aHeader, {"Data Pagamento"											,"DATAMOV2"	,""					,08,0,""		,"","D","TRB1",""})
	
	aadd(aHeader, {"Comissao Paga"												,"XTOTPAGCM","@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	aadd(aHeader, {"% Pago"														,"XPERPAGCM","@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	aadd(aHeader, {"Saldo a Pagar"												,"XSLDPAGCM","@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	
		aadd(aHeader, {"Fornecedor"												,"FORNECE"	,""					,10,0,""		,"","C","TRB1",""})
		aadd(aHeader, {"Descricao"												,"FORNECED"	,""					,40,0,""		,"","C","TRB1",""})
	
	
	aadd(aHeader, {"TRP"														,"TRP"		,""					,01,0,""		,"","C","TRB1",""})
	
	aadd(aHeader, {"Representante 1"											,"XREPR1"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Nome"														,"XNRED1"	,""					,40,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"% Comissao a Pagar"											,"XCOR1"	,"@E 999.99"		,06,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Vlr.Comissao"												,"XVCOR1"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	
	aadd(aHeader, {"Representante 2"											,"XREPR2"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Nome"														,"XNRED2"	,""					,40,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"% Comissao a Pagar"											,"XCOR2"	,"@E 999.99"		,06,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Vlr.Comissao"												,"XVCOR2"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	
	aadd(aHeader, {"Representante 3"											,"XREPR3"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Nome"														,"XNRED3"	,""					,40,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"% Comissao a Pagar"											,"XCOR3"	,"@E 999.99"		,06,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Vlr.Comissao"												,"XVCOR3"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	
	aadd(aHeader, {"Representante 4"											,"XREPR4"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Nome"														,"XNRED4"	,""					,40,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"% Comissao a Pagar"											,"XCOR4"	,"@E 999.99"		,06,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Vlr.Comissao"												,"XVCOR4"	,"@E 99,999,999.99",15,2,""			,"","N","TRB1",""})
	
else
	cCadastro := "Control of Commissions"
	
	DEFINE MSDIALOG _oDlgSint ;
	TITLE "Control of Commissions"  ;
	From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"
	
	// Monta aHeader do TRB1
	aadd(aHeader, {"Job"														,"ITEM"		,""					,25,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Client"														,"CLIENTE"	,""					,40,0,""		,"","C","TRB1",""})
	
	aadd(aHeader, {"Sale with Taxes"											,"XVDCIVD"	,"@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Sale without Taxes"											,"XVDSIVD"	,"@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Sale without freight"										,"XSISFVVD"	,"@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Commissions"												,"XPCOMVD"	,"@E 999,999.99"	,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Value Commission"											,"XVCOMVD"	,"@E 99,999,999.99"	,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Production Cost"											,"XCUPRVD"	,"@E 99,999,999.99"	,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"COGS"														,"XCOGSVD"	,"@E 99,999,999.99"	,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Contr. Margin"												,"XMGCTVD"	,"@E 99,999,999.99"	,13,2,""		,"","N","TRB1",""})
	
	
	aadd(aHeader, {"Sale with Taxes Rev."										,"XVDCIRV"	,"@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Sale without Taxes Rev."									,"XVDSIRV"	,"@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Sale without freight Rev."									,"XSISFVRV"	,"@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Commissions Rev."											,"XPCOMRV"	,"@E 999,999.99"	,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Value Commission Rev."										,"XVCOMRV"	,"@E 99,999,999.99"	,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Production Cost Rev."										,"XCUPRRV"	,"@E 99,999,999.99"	,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"COGS Rev. "													,"XCOGSRV"	,"@E 99,999,999.99"	,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Contr. Margin Rev."											,"XMGCTVD"	,"@E 99,999,999.99"	,13,2,""		,"","N","TRB1",""})
		
	
		aadd(aHeader, {"Date Receiving"											,"DATAMOV"	,""					,08,0,""		,"","D","TRB1",""})
	
	aadd(aHeader, {"Receiving"													,"XTOTPAGO"	,"@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Received"													,"XPERPAGO"	,"@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Balance Receivable"											,"XSLDPAGAR","@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	
		aadd(aHeader, {"Date Payment"											,"DATAMOV2"	,""					,08,0,""		,"","D","TRB1",""})
	
	aadd(aHeader, {"Commission Pays"											,"XTOTPAGCM","@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Paid out"													,"XPERPAGCM","@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Balance to Pay"												,"XSLDPAGCM","@E 99,999,999.99" ,13,2,""		,"","N","TRB1",""})
	
		aadd(aHeader, {"Provider"												,"FORNECE"	,""					,10,0,""		,"","C","TRB1",""})
		aadd(aHeader, {"Name"													,"FORNECED"	,""					,40,0,""		,"","C","TRB1",""})
	
	
	aadd(aHeader, {"TRP"														,"TRP"		,""					,03,0,""		,"","C","TRB1",""})
	
	aadd(aHeader, {"Representative 1"											,"XREPR1"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Name"														,"XNRED1"	,""					,40,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"% Commission to Pay"										,"XCOR1"	,"@E 999.99"		,06,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Vlr.Commission"												,"XVCOR1"	,"@E 99,999,999.99" ,15,2,""		,"","N","TRB1",""})
	
	aadd(aHeader, {"Representative 2"											,"XREPR2"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Name"														,"XNRED2"	,""					,40,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"% Commission to Pay"										,"XCOR2"	,"@E 999.99"		,06,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Vlr.Commission"												,"XVCOR2"	,"@E 99,999,999.99" ,15,2,""		,"","N","TRB1",""})
	
	aadd(aHeader, {"Representative 3"											,"XREPR3"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Name"														,"XNRED3"	,""					,40,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"% Commission to Pay"										,"XCOR3"	,"@E 999.99"		,06,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Vlr.Commission"												,"XVCOR3"	,"@E 99,999,999.99" ,15,2,""		,"","N","TRB1",""})
	
	aadd(aHeader, {"Representative 4"											,"XREPR4"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Name"														,"XNRED4"	,""					,40,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"% Commission to Pay"										,"XCOR4"	,"@E 999.99"		,06,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Vlr.Commission"												,"XVCOR4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
endif
_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB1")
/*
// Monta aHeader do TRB2
aadd(aHeader, {"Item Conta"													,"ITEMIC"		,""					,25,0,""		,"","C","TRB2",""})
aadd(aHeader, {"Data Pagamento"												,"DATAMOV"	,""					,08,0,""		,"","D","TRB2",""})
aadd(aHeader, {"Valor Pago"													,"VALOR"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Fornecedor"													,"FORNECE"	,""					,10,0,""		,"","C","TRB2",""})
aadd(aHeader, {"Descricao"													,"FORNECED"	,""					,40,0,""		,"","C","TRB2",""})

nPosicao := aPosObj[1,3]-110
_oGetDbSint2 := MsGetDb():New(nPosicao+5,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2")
*/
_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
// COR DA LINHA
_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| fTrocaCor(2)}
_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha

//_oGetDbSint:oBrowse:BlDblClick := {|| zFilTRB2() }
//_oGetDbSint:oBrowse:BlDblClick  := {|| zFilTRB2(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint2:ForceRefresh(), _oDlgSint:Refresh()}

//_oGetDbSint2:ForceRefresh()
/*
cCondicao:= "TRB2->ITEMIC == " + cItem
bFiltraBrw := {|| FilBrowse("TRB2",@aInd,@cCondicao) }
Eval(bFiltraBrw)
_oGetDbSint2:obrowse:Refresh()
*/
aadd(aButton , { "BMPTABLE2" , { || zExpComiss()}, "Gerar Plan. Excel " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return


Static Function SFMudaCor(nIOpcao)
   Private _cCor := ""
   if MV_PAR09 == 1 .OR. MV_PAR10 == 1
   
	   if nIOpcao == 1 // Cor da Fonte
	   	  if ALLTRIM(TRB1->CLIENTE) <>  ""; _cCor := CLR_BLACK; endif
	   endif
	   
	   if nIOpcao == 2 // Cor da Fonte
	   	  if ALLTRIM(TRB1->CLIENTE) <>  ""; _cCor := CLR_HCYAN ; endif
	   	  if empty(ALLTRIM(TRB1->CLIENTE)) ; _cCor := CLR_WHITE ; endif
	   endif
	
	endif
Return _cCor

static function zFilTRB2()
	
	local cFiltra 	:= ""
	Local cItemIC := TRB1->ITEM

	// Monta filtro no TRB2 para mostrar apenas os movimentos 
	cFiltra := " alltrim(TRB2->ITEMIC) == '" + alltrim(cItemIC) + "' "
	TRB2->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	
	msginfo("x")
	
	if empty(alltrim(TRB1->ITEM))
		TRB2->(dbclearfil())
	endif
	
return

static function AbreArq()
local aStru 	:= {}
local _cCpoAtu
local _ni


// monta arquivo total de comissoes
aAdd(aStru,{"ITEM"			,"C",25,0,""		,"",""}) // Item Conta
aAdd(aStru,{"CLIENTE"		,"C",40,0,""		,""}) // Cliente
aAdd(aStru,{"NOMPM"			,"C",35,0,""		,""}) // Coordenador

aAdd(aStru,{"XVDCIVD"		,"N",13,2,""	,""}) // Valor cem Tributos
aAdd(aStru,{"XVDSIVD"		,"N",13,2,""	,""}) // Valor sem Tributos
aAdd(aStru,{"XSISFVVD"		,"N",13,2,""	,""}) // Valor sem Tributos / sem Frete
aAdd(aStru,{"XPCOMVD"		,"N",13,2,""	,""}) // Comiss„o
aAdd(aStru,{"XVCOMVD"		,"N",13,2,""	,""}) // Comiss„o
aAdd(aStru,{"XCUPRVD"		,"N",13,2,""	,""}) // Comiss„o
aAdd(aStru,{"XCOGSVD"		,"N",13,2,""	,""}) // Comiss„o
aAdd(aStru,{"XMGCTVD"		,"N",13,2,""	,""}) // Comiss„o

aAdd(aStru,{"XVDCIRV"		,"N",13,2,""	,""}) // Valor cem Tributos
aAdd(aStru,{"XVDSIRV"		,"N",13,2,""	,""}) // Valor sem Tributos
aAdd(aStru,{"XSISFVRV"		,"N",13,2,""	,""}) // Valor sem Tributos / sem Frete
aAdd(aStru,{"XPCOMRV"		,"N",13,2,""	,""}) // Comiss„o
aAdd(aStru,{"XVCOMRV"		,"N",13,2,""	,""}) // Comiss„o
aAdd(aStru,{"XCUPRRV"		,"N",13,2,""	,""}) // Comiss„o
aAdd(aStru,{"XCOGSRV"		,"N",13,2,""	,""}) // Comiss„o
aAdd(aStru,{"XMGCTRV"		,"N",13,2,""	,""}) // Comiss„o

aAdd(aStru,{"DATAMOV"	,"D",08,0,""		,""}) // Valor cem Tributos
aAdd(aStru,{"XTOTPAGO"	,"N",15,2,""		,""}) // Pago pelo Cliente
aAdd(aStru,{"XPERPAGO"	,"N",15,2,""		,""}) // % Pago
aAdd(aStru,{"XSLDPAGAR"	,"N",15,2,""		,""}) // Saldo a Pagar
aAdd(aStru,{"DATAMOV2"	,"D",08,0,""		,""}) // Valor cem Tributos
aAdd(aStru,{"XTOTPAGCM","N",15,2,""			,""}) // Pago Comissao
aAdd(aStru,{"XPERPAGCM","N",15,2,""			,""}) // % Pago Comissao
aAdd(aStru,{"XSLDPAGCM","N",15,2,""			,""}) // Saldo a Pagar Comissao
aAdd(aStru,{"ITEM2"		,"C",25,0,""		,""}) // Item Conta
aAdd(aStru,{"FORNECE"	,"C",10,0,""		,""}) // Cliente
aAdd(aStru,{"FORNECED"	,"C",40,0,""		,""}) // Cliente

aAdd(aStru,{"TRP"		,"C",1,0,""		,""}) // TOTRECPAG

aAdd(aStru,{"XREPR1"	,"C",10,0,""		,""}) // Cliente
aAdd(aStru,{"XNRED1"	,"C",40,0,""		,""}) // Cliente
aAdd(aStru,{"XCOR1"		,"N",06,2,""		,""}) // Cliente
aAdd(aStru,{"XVCOR1"	,"N",15,2,""		,""}) // Cliente

aAdd(aStru,{"XREPR2"	,"C",10,0,""		,""}) // Cliente
aAdd(aStru,{"XNRED2"	,"C",40,0,""		,""}) // Cliente
aAdd(aStru,{"XCOR2"		,"N",06,2,""		,""}) // Cliente
aAdd(aStru,{"XVCOR2"	,"N",15,2,""		,""}) // Cliente

aAdd(aStru,{"XREPR3"	,"C",10,0,""		,""}) // Cliente
aAdd(aStru,{"XNRED3"	,"C",40,0,""		,""}) // Cliente
aAdd(aStru,{"XCOR3"		,"N",06,2,""		,""}) // Cliente
aAdd(aStru,{"XVCOR3"	,"N",15,2,""		,""}) // Cliente

aAdd(aStru,{"XREPR4"	,"C",10,0,""		,""}) // Cliente
aAdd(aStru,{"XNRED4"	,"C",40,0,""		,""}) // Cliente
aAdd(aStru,{"XCOR4"		,"N",06,2,""		,""}) // Cliente
aAdd(aStru,{"XVCOR4"	,"N",15,2,""		,""}) // Cliente

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)

// monta arquivo analitico
aStru := {}
aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
aAdd(aStru,{"VALOR2"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"ITEMCONTA"	,"C",13,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"CAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico

dbcreate(cArqTrb3,aStru)
dbUseArea(.T.,,cArqTrb3,"TRB3",.T.,.F.)


aStru := {}
aAdd(aStru,{"DATAMOV"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"ITEMCONTA"	,"C",13,0}) // Item Conta
aAdd(aStru,{"CODFORN"	,"C",10,0}) // Codigo Cliente / Fornecedor
aAdd(aStru,{"FORNECEDOR","C",20,0}) // Nome Cliente / Fornecedor
aAdd(aStru,{"NUMERO"	,"C",09,0}) // Numero de Titulo
aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
aAdd(aStru,{"NATUREZA"	,"C",10,0}) // Codigo da Natureza

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
index on DATAMOV to &(cArqTrb2+"2")



return(.T.)


Static Function zExpComiss()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpComiss.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
    
    //Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth
	
	TRB1->(dbgotop())
   
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
    
    if MV_PAR13 == 1
	    cTabela := "Controle de Comissoes"
	    cPasta	:= "Controle de Comissoes"
	else
		cTabela := "Control of Commissions"
	    cPasta	:= "Control of Commissions"
	endif
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N„o utilizar n˙mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    if MV_PAR13 == 1 
        aAdd(aColunas, "Contrato")				// 1				
        aAdd(aColunas, "Cliente")				// 2							
        	
        aAdd(aColunas, "Venda c/ Tributos")		// 3				
        aAdd(aColunas, "Venda s/ Tributos")		// 4
        aAdd(aColunas, "Venda s/ Frete")		// 5	
        aAdd(aColunas, "% Comissao")			// 6
        aAdd(aColunas, "Comissao")				// 7
        
        aAdd(aColunas, "Custo Producao")		// 8
        aAdd(aColunas, "COGS")					// 9
        aAdd(aColunas, "% Marg.Contr.")			// 10
        
        aAdd(aColunas, "Venda c/ Tributos Rev.")// 11						
        aAdd(aColunas, "Venda s/ Tributos Rev.")// 12	
        aAdd(aColunas, "Venda s/ Frete Rev.")	// 13	
        aAdd(aColunas, "% Comissao Rev.")		// 14
        aAdd(aColunas, "Comissao Rev.")			// 15
        	
        aAdd(aColunas, "Custo Producao Rev.")	// 16
        aAdd(aColunas, "COGS Rev.")				// 17
        aAdd(aColunas, "& Marg.Contr. Rev.")	// 18
    
        aAdd(aColunas, "Data Recebimento")		// 19
       
        aAdd(aColunas, "Recebimento")			// 20
        aAdd(aColunas, "% Recebimento")			// 21
        aAdd(aColunas, "Saldo a Receber")		// 22
     
        	aAdd(aColunas, "Data Pagamento")	// 23	
      
        aAdd(aColunas, "Pag. Comissao")   		// 24
        aAdd(aColunas, "% Pagamento")			// 25
        aAdd(aColunas, "Saldo a Pagar")			// 26
        
        aAdd(aColunas, "Fornecedor")			// 27
        aAdd(aColunas, "Nome")					// 28
        
        aAdd(aColunas, "Cod.Repres.")			// 29
        aAdd(aColunas, "Representante")			// 30
        aAdd(aColunas, "% Comissao a Pagar")	// 31
        aAdd(aColunas, "Vlr.Comissao ")			// 32
        
        aAdd(aColunas, "Cod.Repres.")			// 33
        aAdd(aColunas, "Representante")			// 34
        aAdd(aColunas, "% Comissao a Pagar")	// 35
        aAdd(aColunas, "Vlr.Comissao ")			// 36
        	
        aAdd(aColunas, "Cod.Repres.")			// 37
        aAdd(aColunas, "Representante")			// 38
        aAdd(aColunas, "% Comissao a Pagar")	// 39
        aAdd(aColunas, "Vlr.Comissao ")			// 40
        
        aAdd(aColunas, "Cod.Repres.")			// 41
        aAdd(aColunas, "Representante")			// 42
        aAdd(aColunas, "% Comissao a Pagar")	// 43
        aAdd(aColunas, "Vlr.Comissao ")			// 44
   
        oFWMsExcel:AddColumn(cTabela,cPasta, "Contrato",1,2)				// 1 item						
        oFWMsExcel:AddColumn(cTabela,cPasta, "Cliente",1,2)					// 2 cliente			
        oFWMsExcel:AddColumn(cTabela,cPasta, "Venda c/ Tributos",1,2)		// 3 xvdci			
        oFWMsExcel:AddColumn(cTabela,cPasta, "Venda s/ Tributos",1,2)		// 4 xvdsi
        oFWMsExcel:AddColumn(cTabela,cPasta, "Venda s/ Frete",1,2)			// 5 xsisfv
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Comissao",1,2)				// 6 xpcom
        oFWMsExcel:AddColumn(cTabela,cPasta, "Comissao",1,2)				// 7 xvcom
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Custo Producao",1,2)			// 8 xcuto
        oFWMsExcel:AddColumn(cTabela,cPasta, "COGS",1,2)					// 9 xcogsv
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Marg.Contr.",1,2)			// 10 xvcom
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Venda c/ Tributos Rev.",1,2)	// 11 xvdcir			
        oFWMsExcel:AddColumn(cTabela,cPasta, "Venda s/ Tributos Rev.",1,2)	// 12 xvdsir
        oFWMsExcel:AddColumn(cTabela,cPasta, "Venda s/ Frete Rev.",1,2)		// 13 xsisfvr
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Comissao Rev.",1,2)			// 14 xpcomr
        oFWMsExcel:AddColumn(cTabela,cPasta, "Comissao Rev.",1,2)			// 15 xvcomr
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Custo Producao Rev.",1,2)		// 16 xcutor
        oFWMsExcel:AddColumn(cTabela,cPasta, "COGS Rev.",1,2)				// 17 xcogsvr
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Marg.Contr. Rev.",1,2)		// 18 xvcomr
                
      
        	oFWMsExcel:AddColumn(cTabela,cPasta, "Data Recebimento",1,2)	// 19 datamov
       
        oFWMsExcel:AddColumn(cTabela,cPasta, "Recebimento",1,2)				// 20 xtotpago
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Recebimento",1,2)			// 21 xperpago
        oFWMsExcel:AddColumn(cTabela,cPasta, "Saldo a Receber",1,2)			// 22 xsldpagar	
   
        	oFWMsExcel:AddColumn(cTabela,cPasta, "Data Pagamento",1,2)		// 23 datamov2
   
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Pag. Comissao",1,2)			// 24 xtotpagcm
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Pagamento",1,2)				// 25 xperpagcm		
        oFWMsExcel:AddColumn(cTabela,cPasta, "Saldo a Pagar",1,2)			// 26 xsldpagcm
        
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Fornecedor",1,2)				// 27 fornece
        oFWMsExcel:AddColumn(cTabela,cPasta, "Nome"+SPACE(40),1,2) 			// 28 forneced
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Cod.Repres.",1,2) 			// 29 XREPR1
        oFWMsExcel:AddColumn(cTabela,cPasta, "Representante",1,2) 			// 30 XNRED1
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Comissao a Pagar ",1,2) 	// 31 XCOR1
        oFWMsExcel:AddColumn(cTabela,cPasta, "Vlr.Comissao ",1,2) 			// 32 XVCOR1
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Cod.Repres.",1,2) 			// 33 XREPR2
        oFWMsExcel:AddColumn(cTabela,cPasta, "Representante",1,2) 			// 34 XNRED2
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Comissao a Pagar ",1,2) 	// 35 XCOR2
        oFWMsExcel:AddColumn(cTabela,cPasta, "Vlr.Comissao ",1,2) 			// 36 XVCOR2
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Cod.Repres.",1,2) 			// 37 XREPR3
        oFWMsExcel:AddColumn(cTabela,cPasta, "Representante",1,2) 			// 38 XNRED3
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Comissao a Pagar ",1,2) 	// 39 XCOR3
        oFWMsExcel:AddColumn(cTabela,cPasta, "Vlr.Comissao ",1,2) 			// 40 XVCOR3
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Cod.Repres.",1,2) 			// 41 XREPR4
        oFWMsExcel:AddColumn(cTabela,cPasta, "Representante",1,2) 			// 42 XNRED4
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Comissao a Pagar ",1,2) 	// 43 XCOR4
        oFWMsExcel:AddColumn(cTabela,cPasta, "Vlr.Comissao ",1,2) 			// 44 XVCOR4
        
        
    else
    	
    	aAdd(aColunas, "Job")						// 1 					
        aAdd(aColunas, "Client")					// 2 		
        aAdd(aColunas, "Sale with Taxes")			// 3			
        aAdd(aColunas, "Sale without Taxes")		// 4
        aAdd(aColunas, "Sale without freight")		// 5	
        aAdd(aColunas, "% Commissions")				// 6		
        aAdd(aColunas, "Value Commissions")			// 7
        
        aAdd(aColunas, "Production Cost")			// 8
        aAdd(aColunas, "COGS")						// 9
        aAdd(aColunas, "% Contr. Margin")			// 10
        
        aAdd(aColunas, "Sale with Taxes Rev.")		// 11				
        aAdd(aColunas, "Sale without Taxes Rev.")	// 12	
        aAdd(aColunas, "Sale without freight Rev.")	// 13		
        aAdd(aColunas, "% Commissions Rev.")		// 14	
        aAdd(aColunas, "Value Commissions Rev.")	// 15
        
        aAdd(aColunas, "Production Cost Rev.")		// 16
        aAdd(aColunas, "COGS Rev.")					//17
        aAdd(aColunas, "% Contr. Margin Rev.")		// 18
        
        		
        	aAdd(aColunas, "Date Receiving")		// 19
      			
        aAdd(aColunas, "Receiving")					// 20
        aAdd(aColunas, "% Received")				// 21	
        aAdd(aColunas, "Balance Receivable")		// 22
       							
        	aAdd(aColunas, "Date Payment")			// 23
      		
        aAdd(aColunas, "Commision Payment")			// 24		
        aAdd(aColunas, "% Paid out")				// 25
        aAdd(aColunas, "Balance to Pay")			// 26
        
        aAdd(aColunas, "Provider")					// 27
        aAdd(aColunas, "Name")						// 28
        
        aAdd(aColunas, "Cod.Repres.")				// 29
        aAdd(aColunas, "Representative")			// 30
        aAdd(aColunas, "% Commission Pay")			// 31
        aAdd(aColunas, "Vlr.Commission")			// 32
        
        aAdd(aColunas, "Cod.Repres.")				// 33
        aAdd(aColunas, "Representative")			// 34
        aAdd(aColunas, "% Commission Pay")			// 35
        aAdd(aColunas, "Vlr.Commission")			// 36
        
        aAdd(aColunas, "Cod.Repres.")				// 37
        aAdd(aColunas, "Representative")			// 38
        aAdd(aColunas, "% Commission Pay")			// 39
        aAdd(aColunas, "Vlr.Commission")			// 40
        
        aAdd(aColunas, "Cod.Repres.")				// 41
        aAdd(aColunas, "Representative")			// 42
        aAdd(aColunas, "% Commission Pay")			// 43
        aAdd(aColunas, "Vlr.Commission")			// 44
        
                     
    	oFWMsExcel:AddColumn(cTabela,cPasta, "Job",1,2)						// item			01				
        oFWMsExcel:AddColumn(cTabela,cPasta, "Client",1,2)					// cliente		02	
        oFWMsExcel:AddColumn(cTabela,cPasta, "Sale with Taxes",1,2)			// xvdci		03	
        oFWMsExcel:AddColumn(cTabela,cPasta, "Sale without Taxes",1,2)		// xvdsi		04
        oFWMsExcel:AddColumn(cTabela,cPasta, "Sale without freight",1,2)	// xsisfv		05
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Commissions",1,2)			// xpcom		06
        oFWMsExcel:AddColumn(cTabela,cPasta, "Value Commission",1,2)		// xvcom		07
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Production Cost",1,2)			// xvcom		08
        oFWMsExcel:AddColumn(cTabela,cPasta, "COGS",1,2)					// xvcom		09
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Contr. Margin",1,2)			// xvcom		10
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Sale with Taxes Rev.",1,2)	// xvcom		11
        oFWMsExcel:AddColumn(cTabela,cPasta, "Sale without Taxes Rev.",1,2)	// xvcom		12
        oFWMsExcel:AddColumn(cTabela,cPasta, "Sale without freight Rev.",1,2)	// xvcom	13
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Commissions Rev.",1,2)		// xvcom		14
        oFWMsExcel:AddColumn(cTabela,cPasta, "Value Commissions Rev.",1,2)	// xvcom		15
        oFWMsExcel:AddColumn(cTabela,cPasta, "Production Cost Rev.",1,2)	// xvcom		16
        oFWMsExcel:AddColumn(cTabela,cPasta, "COGS Rev.",1,2)				// xvcom		17
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Contr. Margin Rev.",1,2)	// xvcom		18
        
     
        	oFWMsExcel:AddColumn(cTabela,cPasta, "Date Receiving",2,4)			// datamov	19
       
        oFWMsExcel:AddColumn(cTabela,cPasta, "Receiving",1,2)				// xtotpago		20
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Received",1,2)				// xperpago		21
        oFWMsExcel:AddColumn(cTabela,cPasta, "Balance Receivable",1,2)		// xsldpagar	22
       	
        	oFWMsExcel:AddColumn(cTabela,cPasta, "Date Payment",2,4)			// datamov2	23
       			
        oFWMsExcel:AddColumn(cTabela,cPasta, "Commission Pays",1,2)			// xtotpagcm	24
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Paid out",1,2)				// xperpagcm	25
        oFWMsExcel:AddColumn(cTabela,cPasta, "Balance to Pay",1,2)			// xsldpagcm	26
        	
     
        	oFWMsExcel:AddColumn(cTabela,cPasta, "Provider",1,2)				// fornece  27
        	oFWMsExcel:AddColumn(cTabela,cPasta, "Name"+SPACE(40),1,2) 			// forneced 28
     
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Cod.Repres. 1",1,2) 			// 28 XREPR1	29
        oFWMsExcel:AddColumn(cTabela,cPasta, "Representative 1",1,2) 			// 29 XNRED1	30
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Commission Pay 1",1,2) 	// 30 XCOR1			31
        oFWMsExcel:AddColumn(cTabela,cPasta, "Vlr.Commission 1",1,2) 			// 31 XVCOR1 32
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Cod.Repres. 2",1,2) 			// 28 XREPR2	33
        oFWMsExcel:AddColumn(cTabela,cPasta, "Representative 2",1,2) 			// 29 XNRED2	34
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Commission Pay 2",1,2) 	// 30 XCOR2			35
        oFWMsExcel:AddColumn(cTabela,cPasta, "Vlr.Commission 2",1,2) 			// 31 XVCOR2 36
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Cod.Repres. 3",1,2) 			// 28 XREPR3 	37
        oFWMsExcel:AddColumn(cTabela,cPasta, "Representative 3",1,2) 			// 29 XNRED3	38
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Commission Pay 3",1,2) 	// 30 XCOR3			39
        oFWMsExcel:AddColumn(cTabela,cPasta, "Vlr.Commission 3",1,2) 			// 31 XVCOR3 40
        
        oFWMsExcel:AddColumn(cTabela,cPasta, "Cod.Repres. 4",1,2) 			// 28 XREPR4 	41
        oFWMsExcel:AddColumn(cTabela,cPasta, "Representative 4",1,2) 			// 29 XNRED4	42
        oFWMsExcel:AddColumn(cTabela,cPasta, "% Commission Pay 4",1,2) 	// 30 XCOR4			43
        oFWMsExcel:AddColumn(cTabela,cPasta, "Vlr.Commission 4",1,2) 			// 31 XVCOR4 44
        
        
    endif
    
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
                            
        While  !(TRB1->(EoF()))
         
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB1->ITEM
        	aLinhaAux[2] := TRB1->CLIENTE
        	
        	aLinhaAux[3] := TRB1->XVDCIVD
        	aLinhaAux[4] := TRB1->XVDSIVD
        	aLinhaAux[5] := TRB1->XSISFVVD
        	aLinhaAux[6] := TRB1->XPCOMVD
        	aLinhaAux[7] := TRB1->XVCOMVD
        	
        	aLinhaAux[8] := TRB1->XCUPRVD
        	aLinhaAux[9] := TRB1->XCOGSVD
        	aLinhaAux[10] := TRB1->XMGCTVD
        	
        	aLinhaAux[11] := TRB1->XVDCIRV
        	aLinhaAux[12] := TRB1->XVDSIRV
        	aLinhaAux[13] := TRB1->XSISFVRV
        	aLinhaAux[14] := TRB1->XPCOMRV
        	aLinhaAux[15] := TRB1->XVCOMRV
        	
        	aLinhaAux[16] := TRB1->XCUPRRV
        	aLinhaAux[17] := TRB1->XCOGSRV
        	aLinhaAux[18] := TRB1->XMGCTRV
        	
        	aLinhaAux[19] := DTOC(TRB1->DATAMOV)
        	aLinhaAux[20] := TRB1->XTOTPAGO	
	        aLinhaAux[21] := TRB1->XPERPAGO
	        aLinhaAux[22] := TRB1->XSLDPAGAR
	        
	        aLinhaAux[23] := DTOC(TRB1->DATAMOV2)
        		aLinhaAux[24] := TRB1->XTOTPAGCM
	        	aLinhaAux[25] := TRB1->XPERPAGCM
	        	aLinhaAux[26] := TRB1->XSLDPAGCM
	        	
	        	aLinhaAux[27] := TRB1->FORNECE
	        	aLinhaAux[28] := TRB1->FORNECED
	        	
	        	aLinhaAux[29] := TRB1->XREPR1
	        	aLinhaAux[30] := TRB1->XNRED1
	        	aLinhaAux[31] := TRB1->XCOR1
	        	aLinhaAux[32] := TRB1->XVCOR1
	        	
	        	aLinhaAux[33] := TRB1->XREPR2
	        	aLinhaAux[34] := TRB1->XNRED2
	        	aLinhaAux[35] := TRB1->XCOR2
	        	aLinhaAux[36] := TRB1->XVCOR2
	        	
	        	aLinhaAux[37] := TRB1->XREPR3
	        	aLinhaAux[38] := TRB1->XNRED3
	        	aLinhaAux[39] := TRB1->XCOR3
	        	aLinhaAux[40] := TRB1->XVCOR3
	        	
	        	aLinhaAux[41] := TRB1->XREPR4
	        	aLinhaAux[42] := TRB1->XNRED4
	        	aLinhaAux[43] := TRB1->XCOR4
	        	aLinhaAux[44] := TRB1->XVCOR4
     	
       
        	if MV_PAR09 == 1 .OR. MV_PAR10 == 1
	        	if alltrim(aLinhaAux[2]) <> "" 
	            	oFWMsExcel:SetCelBold(.T.)
	            	oFWMsExcel:SetCelBgColor("#EEE8AA")
	            	//oFWMsExcel:SetCelFrColor("#FFFFFF")
	            	oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	            elseif nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	        else
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	        endif
        	
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

    RestArea(aArea)

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

	if MV_PAR03 == 2 .AND. MV_PAR04 == 2 .AND. MV_PAR05 == 2 .AND. MV_PAR06 == 2 .AND. MV_PAR07 == 2 .AND. MV_PAR08 == 2
		msgstop("Deve ser informado pelo menos um tipo de Contrato como Sim")
		return(.F.)
	endif

return(.T.)

//***********************************CUSTO EMPENHADO
static function PFIN01REAL()

local _cQuery := ""
Local _cFilSC7 := xFilial("SC7")

	Local dData
	Local nValor := 0
	local dDataM2

SC7->(dbsetorder(23)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SC7",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"C7_EMISSAO",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

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

	if QUERY->C7_ITEMCTA == _cItemConta .and. alltrim(QUERY->C7_ENCER) == ""

		RecLock("TRB3",.T.)
		IncProc("Processando registro: "+alltrim(QUERY->C7_NUM))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->C7_NUM))
		ProcessMessage()
		
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
			IF QUERY->C7_QUJE > 0
				TRB3->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
				TRB3->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL * nValor)
			ELSE
				TRB3->VALOR		:= QUERY->C7_XTOTSI * nValor
				TRB3->VALOR2	:= QUERY->C7_TOTAL * nValor
			ENDIF

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
			IF QUERY->C7_QUJE > 0
				TRB3->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
				TRB3->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL * nValor)
			ELSE
				TRB3->VALOR		:= QUERY->C7_XTOTSI * nValor
				TRB3->VALOR2	:= QUERY->C7_TOTAL * nValor
			ENDIF

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
			IF QUERY->C7_QUJE > 0
				TRB3->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
				TRB3->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL * nValor)
			ELSE
				TRB3->VALOR		:= QUERY->C7_XTOTSI * nValor
				TRB3->VALOR2	:= QUERY->C7_TOTAL * nValor
			ENDIF
		else
			IF QUERY->C7_QUJE > 0
				TRB3->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI) 
				TRB3->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL) 
			ELSE
				
				TRB3->VALOR		:= QUERY->C7_XTOTSI 
				TRB3->VALOR2	:= QUERY->C7_TOTAL 
			ENDIF
		endif

		TRB3->ORIGEM	:= "C7"
		TRB3->ITEMCONTA := QUERY->C7_ITEMCTA
		TRB3->CAMPO		:= "VLREMP"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
QUERY2->(dbclosearea())

return

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
	PutSX1(cPerg, "09", "Recebimento (Detalhes)?"		, "", "", "mv_ch9", "N", 01, 0, 0, "C", "", "", "", "", "mv_par09","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "10", "Comissao (Detalhes)?"			, "", "", "mv_ch10", "N", 01, 0, 0, "C", "", "", "", "", "mv_par10","Sim","","","","Nao","","","","","","","","","","","")
	putSx1(cPerg, "11", "Ano de?"  						, "", "", "mv_ch11", "C", 02, 0, 0, "G", "", "", "", "", "mv_par11")
	putSx1(cPerg, "12", "Ano atÈ?" 						, "", "", "mv_ch12", "C", 02, 0, 0, "G", "", "", "", "", "mv_par12")
return