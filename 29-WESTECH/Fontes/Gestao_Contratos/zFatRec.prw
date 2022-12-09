#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"
#include 'parmtype.ch'

//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ// 
//                        Low Intensity colors 
//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ// 
//                      High Intensity Colors 
//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ// 

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
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera arquivo de Gestao de Contratos                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico 		                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function zFatRec()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Faturamento / Recebimento"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"FRIN01"
private _cArq	:= 	"FRIN01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cItemConta := CTD->CTD_ITEM
private _xCTCT 		:= CTD->CTD_XCTCT
private _cFilial 	:= ALLTRIM(CTD->CTD_FILIAL)

private _cNProp
private _cCodCoord
private _cNomCoord

private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)
private cArqTrb3 := CriaTrab(NIL,.F.)

Private _aGrpSint:= {}

//ValidPerg()

AADD(aSays,"Este programa gera planilha com os dados para o Faturamento baseado em  ")
AADD(aSays,"Contratos ativos e inativos. O arquivo gerado pode ser aberto de forma ")
AADD(aSays,"automแtica pelo Excel.")
AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

//FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
if nOpcA == 1

	if !VldParamFR() .or. !AbreArq()
		return
	endif

	MSAguarde({||PLANFAT()},"Processando Planejamento faturamento (Periodo)")
	
	MSAguarde({||PLANFAT02()},"Processando Planejamento faturamento (Geral)")
	
	MSAguarde({||DOCSAIDA()},"Processando Documentos de Saida (Periodo)")
	
	MSAguarde({||SE1INV()},"Processando Invoice (Periodo)")
	
	MSAguarde({||SD1DEV()},"Processando NF devolu็ใo (Periodo)")
	
	MSAguarde({||DOCSAI02()},"Processando Documentos de Saida (Geral)")
	
	MSAguarde({||SE1IN02()},"Processando Invoice (Geral)")

	MSAguarde({||SD1D02()},"Processando NF devolu็ใo (Geral)")

	if MV_PAR03 = 1 .OR. MV_PAR05 = 1
		MSAguarde({||PROSTATAT()},"Processando Contratos AT / EN")
	endif
	
	if MV_PAR06 = 1 .OR. MV_PAR08 = 1
		MSAguarde({||PROCEQST()},"Processando Contratos EQ / ST")
	endif

	if MV_PAR07 = 1
		MSAguarde({||PROSTATPR()},"Processando Contratos PR")
	endif

	if MV_PAR09 = 1
		MSAguarde({||PROSTATGR()},"Processando Contratos GR")
	endif

	if MV_PAR04 = 1
		MSAguarde({||PROSTATCM()},"Processando Contratos CM")
	endif

	MSAguarde({||zTotTRB2()},"Processando Total Faturamento")
	

	MontaTela()

	TRB1->(dbclosearea())
	TRB2->(dbclosearea())
	TRB3->(dbclosearea())

endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa Planejamento Faturamento			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function PLANFAT()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""

SZQ->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SZQ",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZQ_ITEMIC",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

		/*
		if dtos(QUERY->ZQ_DATA) < dtos(MV_PAR13) 
			QUERY->(dbskip())
			Loop
		endif
		
		if  dtos(QUERY->ZQ_DATA) > dtos(MV_PAR14)
			QUERY->(dbskip())
			Loop
		endif
		*/
	
	if QUERY->ZQ_DATA >= MV_PAR13 .AND. QUERY->ZQ_DATA <= MV_PAR14 .AND. ! EMPTY(alltrim(QUERY->ZQ_ITEMIC))
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZQ_ITEMIC))
		ProcessMessage()
	
		RecLock("TRB1",.T.)
		
		TRB1->PITEMCONTA	:= QUERY->ZQ_ITEMIC
		TRB1->PDESCR		:= "PLANEJADO"
		TRB1->PNF			:= ""
		TRB1->PDATAMOV		:= QUERY->ZQ_DATA
		TRB1->PXVDCI		:= QUERY->ZQ_FATREV
		TRB1->PXVDSI		:= QUERY->ZQ_FATRVSI
		TRB1->PXTIPO		:= "PL"
		TRB1->PORIGEM 		:= "PL"
		TRB1->PCAMPO 		:= QUERY->ZQ_ITEMIC
		TRB1->PXDELMON2		:= substr(dtoc(QUERY->ZQ_DATA),4,7)
		
		MsUnlock()
	//endif
	ENDIF
	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa Planejamento Faturamento			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function PLANFAT02()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""

SZQ->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SZQ",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZQ_ITEMIC",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

SZQ->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())

		RecLock("TRB3",.T.)
		
		//IncProc("Processando registro: "+alltrim(QUERY->TMP_DOC))
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZQ_ITEMIC))
		ProcessMessage()

		TRB3->ITEMCONTA	:= QUERY->ZQ_ITEMIC
		TRB3->DESCR		:= "PLANEJADO"
		TRB3->NF		:= ""
		TRB3->DATAMOV	:= QUERY->ZQ_DATA
		TRB3->XVDCI		:= QUERY->ZQ_FATREV
		TRB3->XVDSI		:= QUERY->ZQ_FATRVSI
		TRB3->XTIPO		:= "PL"
		TRB3->ORIGEM 	:= "PL"
		TRB3->CAMPO 	:= QUERY->ZQ_ITEMIC
		TRB3->XDELMON2	:= substr(dtoc(QUERY->ZQ_DATA),4,7)
		
		MsUnlock()
	//endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa documento de saida   				              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function DOCSAIDA()

local _cQuery := ""
Local _cFilSD2 := xFilial("SD2")

// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO
 	_cQuery := "SELECT D2_ITEMCC AS 'TMP_CONTRATO', D2_DOC AS 'TMP_DOC', D2_SERIE AS 'TMP_SERIE', D2_CF AS 'TMP_CFOP',  CAST(D2_EMISSAO AS DATE) AS 'TMP_EMISSAO',D2_EMISSAO, D2_CLIENTE AS 'TMP_CLIENTE', A1_NOME AS 'TMP_NOME', "  
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
	_cQuery += "											 D2_CF BETWEEN '5116' AND '5116' OR " 
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

	if QUERY->D2_EMISSAO >= DTOS(MV_PAR13) .AND. QUERY->D2_EMISSAO <= DTOS(MV_PAR14) 
		RecLock("TRB1",.T.)
		
		//IncProc("Processando registro: "+alltrim(QUERY->TMP_DOC))
		MsProcTxt("Processando registro: "+alltrim(QUERY->TMP_DOC))
		ProcessMessage()

		TRB1->PITEMCONTA	:= QUERY->TMP_CONTRATO
		TRB1->PDESCR		:= "REALIZADO"
		TRB1->PNF			:= QUERY->TMP_DOC
		TRB1->PDATAMOV		:= QUERY->TMP_EMISSAO
		TRB1->PXVDCI		:= QUERY->TMP_TOTAL
		TRB1->PXVDSI		:= QUERY->TMP_TOTALSI
		TRB1->PXTIPO		:= "RE"
		TRB1->PORIGEM 		:= "DS"
		TRB1->PCAMPO 		:= QUERY->TMP_CONTRATO
		TRB1->PXDELMON2		:= substr(dtoc(QUERY->TMP_EMISSAO),4,7)
		
		MsUnlock()
	//endif
	endif
	
	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa documento de saida   				              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa INVOICE								              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function SE1INV()
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
	
		if dtos(QUERY->E1_VENCREA) < dtos(MV_PAR13) 
			QUERY->(dbskip())
			Loop
		endif
		
		if  dtos(QUERY->E1_VENCREA) > dtos(MV_PAR14)
			QUERY->(dbskip())
			Loop
		endif

	//if ALLTRIM(QUERY->ZG_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		//IncProc("Processando registro: "+alltrim(QUERY->TMP_DOC))
		MsProcTxt("Processando registro: "+alltrim(QUERY->E1_XXIC))
		ProcessMessage()

		TRB1->PITEMCONTA	:= QUERY->E1_XXIC
		TRB1->PDESCR		:= "REALIZADO"
		TRB1->PNF		:= QUERY->E1_NUM
		TRB1->PDATAMOV	:= QUERY->E1_VENCREA
		TRB1->PXVDCI		:= QUERY->E1_VLCRUZ
		TRB1->PXVDSI		:= QUERY->E1_VLCRUZ
		TRB1->PXTIPO		:= "RE"
		TRB1->PORIGEM 	:= "IN"
		TRB1->PCAMPO 	:= QUERY->E1_XXIC
		TRB1->PXDELMON2	:= substr(dtoc(QUERY->E1_VENCREA),4,7)
		
		MsUnlock()
	//endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa INVOICE								              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa INVOICE								              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function SD1DEV()
local _cQuery 		:= ""
Local _cFilSD1 		:= xFilial("SD1")
Local dData 		:= DDatabase
Local QUERY 		:= ""
local cFor := "D1_CF = '1201' .OR. D1_CF = '2201'"

SD1->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SD1",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"D1_ITEMCTA",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

SD1->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())

		if dtos(QUERY->D1_EMISSAO) < dtos(MV_PAR13) 
			QUERY->(dbskip())
			Loop
		endif
		
		if  dtos(QUERY->D1_EMISSAO) > dtos(MV_PAR14)
			QUERY->(dbskip())
			Loop
		endif

	//if ALLTRIM(QUERY->ZG_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		//IncProc("Processando registro: "+alltrim(QUERY->TMP_DOC))
		MsProcTxt("Processando registro: "+alltrim(QUERY->D1_ITEMCTA))
		ProcessMessage()

		TRB1->PITEMCONTA	:= QUERY->D1_ITEMCTA
		TRB1->PDESCR		:= "DEVOLUCAO"
		TRB1->PNF			:= QUERY->D1_DOC
		TRB1->PDATAMOV		:= QUERY->D1_EMISSAO
		TRB1->PXVDCI		:= -1 * QUERY->D1_TOTAL
		TRB1->PXVDSI		:= -1 * QUERY->D1_CUSTO
		TRB1->PXTIPO		:= "RE"
		TRB1->PORIGEM 		:= "DV"
		TRB1->PCAMPO 		:= QUERY->D1_ITEMCTA
		TRB1->PXDELMON2		:= substr(dtoc(QUERY->D1_EMISSAO),4,7)
		
		MsUnlock()
	//endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa devolucoes							              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo Sintetico                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function PROSTATAT()

local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""


 //**********
 Local xTotItemCI		:= 0
 Local xTotItemSI		:= 0
 
 Local xTotICIpl		:= 0
 Local xTotISIpl		:= 0
 
 local dData1
 local dData2
 local cWeekJOB
 
 Local aInd:={}
 Local cCondicao
 Local bFiltraBrw
 
 local cFor := "ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'AT/EN'"
 local cFor3 := ""
 local nContar := 0

CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())
	
	nContar := 0
	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		ProcessMessage()

	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
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
	
	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR10
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR11
		QUERY->(dbskip())
		Loop
	endif

	
	if MV_PAR12 == 1 .AND. dtos(QUERY->CTD_DTEXSF) < dtos(DDATABASE)
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. dtos(QUERY->CTD_DTEXSF) >= dtos(DDATABASE)
		QUERY->(dbskip())
		Loop
	endif
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) $ 'PL/RE' "
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")
	
		ProcRegua(TRB1->(reccount()))
		
	if MV_PAR15 = 1	
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
		
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. dtos(TRB1->PDATAMOV) >= dtos(MV_PAR13) .AND. dtos(TRB1->PDATAMOV) <= dtos(MV_PAR14)
				nContar		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
			
		if nContar = 0
			QUERY->(dbskip())
			Loop
		endif
	endif

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
	RecLock("TRB2",.T.)
		
		TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
		TRB2->CLIENTE	:= QUERY->CTD_XNREDU
		TRB2->XVDCI		:= QUERY->CTD_XVDCI
		TRB2->XVDSI		:= QUERY->CTD_XVDSI
		TRB2->XVDCIR	:= QUERY->CTD_XVDCIR
		TRB2->XVDSIR	:= QUERY->CTD_XVDSIR
		
		cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'PL'"
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")
	
		ProcRegua(TRB1->(reccount()))
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
		
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB1->PXTIPO) == "PL"
				xTotICIpl		+= TRB1->PXVDCI
				xTotISIpl		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
		
		TRB2->XVDCIP	:= xTotICIpl
		TRB2->XVDSIP	:= xTotISIpl
		
		xTotICIpl := 0
		xTotISIpl := 0

		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "PL"
				xTotICIpl		+= TRB3->XVDCI
				xTotISIpl		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		TRB2->XVDCIP2	:= xTotICIpl
		TRB2->XVDSIP2	:= xTotISIpl
		
		xTotICIpl := 0
		xTotISIpl := 0
		
		cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'RE'"
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

		ProcRegua(TRB1->(reccount()))
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB1->PXTIPO) == "RE"
				xTotItemCI		+= TRB1->PXVDCI
				xTotItemSI		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
		
		TRB2->XVDCIRE 	:= xTotItemCI
		TRB2->XVDSIRE 	:= xTotItemSI
		
		xTotItemCI := 0
		xTotItemSI := 0
		
		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "RE"
				xTotItemCI		+= TRB3->XVDCI
				xTotItemSI		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		TRB2->XVDCIRE2 	:= xTotItemCI
		TRB2->XVDSIRE2 	:= xTotItemSI
		
		xTotItemCI := 0
		xTotItemSI := 0
		
		TRB2->XSLDPG	:= QUERY->CTD_XVDCIR - TRB2->XVDCIRE 
		TRB2->XPERFAT	:= (TRB2->XVDCIRE / QUERY->CTD_XVDCIR)*100
		TRB2->XPERFAT2	:= (TRB2->XVDCIRE2 / QUERY->CTD_XVDCIR)*100
		TRB2->CAMPO 	:= QUERY->CTD_ITEM
		TRB2->TPR		:= "T"

	MsUnlock()
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'PL' "
	
	IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

	ProcRegua(TRB1->(reccount()))
	
	TRB1->(dbgotop())
	
		while TRB1->(!eof())
			RecLock("TRB2",.T.)
				TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
				if alltrim(TRB1->PXTIPO) == "PL"
					TRB2->XDATFATP	:= TRB1->PDATAMOV
					TRB2->XVDCIP	:= TRB1->PXVDCI
					TRB2->XVDSIP	:= TRB1->PXVDSI
					TRB2->TPR		:= "P"
				endif
			MsUnlock()
			TRB1->(dbskip())
		enddo
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'RE'"
	
	IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

	ProcRegua(TRB1->(reccount()))
		
	TRB1->(dbgotop())
	
		while TRB1->(!eof())
			RecLock("TRB2",.T.)
				TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
				if alltrim(TRB1->PXTIPO) == "RE"
					TRB2->XDATFATR	:= TRB1->PDATAMOV
					TRB2->XVDCIRE	:= TRB1->PXVDCI
					TRB2->XVDSIRE	:= TRB1->PXVDSI
					TRB2->TPR		:= "R"
				endif
			MsUnlock()
			TRB1->(dbskip())
		enddo
	

	QUERY->(dbskip())

enddo
	
IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,,"Selecionando Registros...")	

TRB1->(dbclearfil())
TRB3->(dbclearfil())
QUERY->(dbclosearea())
CTD->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo Sintetico                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function PROCEQST()

local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""

 Local xTotItemCI		:= 0
 Local xTotItemSI		:= 0
 
 Local xTotICIpl		:= 0
 Local xTotISIpl		:= 0
 
 local dData1
 local dData2
 local cWeekJOB
 
 Local aInd:={}
 Local cCondicao
 Local bFiltraBrw
 local cFor3 := ""
 local nContar := 0
 
 local cFor := "ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'EQ/ST'"

CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())
	nContar := 0
	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		ProcessMessage()

	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
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
	
	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR10
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR11
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. dtos(QUERY->CTD_DTEXSF) < dtos(DDATABASE)
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. dtos(QUERY->CTD_DTEXSF) >= dtos(DDATABASE)
		QUERY->(dbskip())
		Loop
	endif
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) $ 'PL/RE' "
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")
	
		ProcRegua(TRB1->(reccount()))
	
	if MV_PAR15 = 1		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
		
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. dtos(TRB1->PDATAMOV) >= dtos(MV_PAR13) .AND. dtos(TRB1->PDATAMOV) <= dtos(MV_PAR14)
				nContar		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
			
		if nContar = 0
			QUERY->(dbskip())
			Loop
		endif
	endif
	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
	RecLock("TRB2",.T.)
		
		TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
		TRB2->CLIENTE	:= QUERY->CTD_XNREDU
		TRB2->XVDCI		:= QUERY->CTD_XVDCI
		TRB2->XVDSI		:= QUERY->CTD_XVDSI
		TRB2->XVDCIR	:= QUERY->CTD_XVDCIR
		TRB2->XVDSIR	:= QUERY->CTD_XVDSIR
		
		cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'PL'"
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")
	
		ProcRegua(TRB1->(reccount()))
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
		
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB1->PXTIPO) == "PL"
				xTotICIpl		+= TRB1->PXVDCI
				xTotISIpl		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
		
		TRB2->XVDCIP	:= xTotICIpl
		TRB2->XVDSIP	:= xTotISIpl
		
		xTotICIpl := 0
		xTotISIpl := 0

		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "PL"
				xTotICIpl		+= TRB3->XVDCI
				xTotISIpl		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		TRB2->XVDCIP2	:= xTotICIpl
		TRB2->XVDSIP2	:= xTotISIpl
		
		xTotICIpl := 0
		xTotISIpl := 0
		
		cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'RE'"
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

		ProcRegua(TRB1->(reccount()))
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB1->PXTIPO) == "RE"
				xTotItemCI		+= TRB1->PXVDCI
				xTotItemSI		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
		
		TRB2->XVDCIRE 	:= xTotItemCI
		TRB2->XVDSIRE 	:= xTotItemSI
		
		xTotItemCI := 0
		xTotItemSI := 0
		
		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "RE"
				xTotItemCI		+= TRB3->XVDCI
				xTotItemSI		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		TRB2->XVDCIRE2 	:= xTotItemCI
		TRB2->XVDSIRE2 	:= xTotItemSI
		
		xTotItemCI := 0
		xTotItemSI := 0
		
		TRB2->XSLDPG	:= QUERY->CTD_XVDCIR - TRB2->XVDCIRE 
		TRB2->XPERFAT	:= (TRB2->XVDCIRE / QUERY->CTD_XVDCIR)*100
		TRB2->XPERFAT2	:= (TRB2->XVDCIRE2 / QUERY->CTD_XVDCIR)*100
		TRB2->CAMPO 	:= QUERY->CTD_ITEM
		TRB2->TPR		:= "T"

	MsUnlock()
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'PL' "
	
	IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

	ProcRegua(TRB1->(reccount()))
	
	TRB1->(dbgotop())
	
		while TRB1->(!eof())
			RecLock("TRB2",.T.)
				TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
				if alltrim(TRB1->PXTIPO) == "PL"
					TRB2->XDATFATP	:= TRB1->PDATAMOV
					TRB2->XVDCIP	:= TRB1->PXVDCI
					TRB2->XVDSIP	:= TRB1->PXVDSI
					TRB2->TPR		:= "P"
				endif
			MsUnlock()
			TRB1->(dbskip())
		enddo
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'RE'"
	
	IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

	ProcRegua(TRB1->(reccount()))
		
	TRB1->(dbgotop())
	
		while TRB1->(!eof())
			RecLock("TRB2",.T.)
				TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
				if alltrim(TRB1->PXTIPO) == "RE"
					TRB2->XDATFATR	:= TRB1->PDATAMOV
					TRB2->XVDCIRE	:= TRB1->PXVDCI
					TRB2->XVDSIRE	:= TRB1->PXVDSI
					TRB2->TPR		:= "R"
				endif
			MsUnlock()
			TRB1->(dbskip())
		enddo
	

	QUERY->(dbskip())

enddo
	
IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,,"Selecionando Registros...")	

TRB1->(dbclearfil())
TRB3->(dbclearfil())
QUERY->(dbclosearea())
CTD->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROSTATPR												   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o Project Status PR			                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function PROSTATPR()

local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""


 //**********
 Local xTotItemCI		:= 0
 Local xTotItemSI		:= 0
 
 Local xTotICIpl		:= 0
 Local xTotISIpl		:= 0
 
 local dData1
 local dData2
 local cWeekJOB
 
 Local aInd:={}
 Local cCondicao
 Local bFiltraBrw

 local cFor := "ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'PR'"
 local cFor3 := ""
 local nContar := 0

CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM,CTD_DTEXSF,CTD_XIDPM",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())
	nContar := 0
	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		ProcessMessage()

	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
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
	
	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR10
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2) > MV_PAR11
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. dtos(QUERY->CTD_DTEXSF) < dtos(DDATABASE)
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. dtos(QUERY->CTD_DTEXSF) >= dtos(DDATABASE)
		QUERY->(dbskip())
		Loop
	endif
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) $ 'PL/RE' "
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")
	
		ProcRegua(TRB1->(reccount()))
	
	if MV_PAR15 = 1		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
		
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  // .AND. dtos(TRB1->PDATAMOV) >= dtos(MV_PAR13) .AND. dtos(TRB1->PDATAMOV) <= dtos(MV_PAR14)
				nContar		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
			
		if nContar = 0
			QUERY->(dbskip())
			Loop
		endif
	endif
	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
	RecLock("TRB2",.T.)
		
		TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
		TRB2->CLIENTE	:= QUERY->CTD_XNREDU
		TRB2->XVDCI		:= QUERY->CTD_XVDCI
		TRB2->XVDSI		:= QUERY->CTD_XVDSI
		TRB2->XVDCIR	:= QUERY->CTD_XVDCIR
		TRB2->XVDSIR	:= QUERY->CTD_XVDSIR
		
		cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'PL'"
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")
	
		ProcRegua(TRB1->(reccount()))
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
		
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB1->PXTIPO) == "PL"
				xTotICIpl		+= TRB1->PXVDCI
				xTotISIpl		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
		
		TRB2->XVDCIP	:= xTotICIpl
		TRB2->XVDSIP	:= xTotISIpl
		
		xTotICIpl := 0
		xTotISIpl := 0

		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "PL"
				xTotICIpl		+= TRB3->XVDCI
				xTotISIpl		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		TRB2->XVDCIP2	:= xTotICIpl
		TRB2->XVDSIP2	:= xTotISIpl
		
		xTotICIpl := 0
		xTotISIpl := 0
		
		cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'RE'"
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

		ProcRegua(TRB1->(reccount()))
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB1->PXTIPO) == "RE"
				xTotItemCI		+= TRB1->PXVDCI
				xTotItemSI		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
		
		TRB2->XVDCIRE 	:= xTotItemCI
		TRB2->XVDSIRE 	:= xTotItemSI
		
		xTotItemCI := 0
		xTotItemSI := 0
		
		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "RE"
				xTotItemCI		+= TRB3->XVDCI
				xTotItemSI		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		TRB2->XVDCIRE2 	:= xTotItemCI
		TRB2->XVDSIRE2 	:= xTotItemSI
		
		xTotItemCI := 0
		xTotItemSI := 0
		
		TRB2->XSLDPG	:= QUERY->CTD_XVDCIR - TRB2->XVDCIRE 
		TRB2->XPERFAT	:= (TRB2->XVDCIRE / QUERY->CTD_XVDCIR)*100
		TRB2->XPERFAT2	:= (TRB2->XVDCIRE2 / QUERY->CTD_XVDCIR)*100
		TRB2->CAMPO 	:= QUERY->CTD_ITEM
		TRB2->TPR		:= "T"

	MsUnlock()
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'PL' "
	
	IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

	ProcRegua(TRB1->(reccount()))
	
	TRB1->(dbgotop())
	
		while TRB1->(!eof())
			RecLock("TRB2",.T.)
				TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
				if alltrim(TRB1->PXTIPO) == "PL"
					TRB2->XDATFATP	:= TRB1->PDATAMOV
					TRB2->XVDCIP	:= TRB1->PXVDCI
					TRB2->XVDSIP	:= TRB1->PXVDSI
					TRB2->TPR		:= "P"
				endif
			MsUnlock()
			TRB1->(dbskip())
		enddo
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'RE'"
	
	IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

	ProcRegua(TRB1->(reccount()))
		
	TRB1->(dbgotop())
	
		while TRB1->(!eof())
			RecLock("TRB2",.T.)
				TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
				if alltrim(TRB1->PXTIPO) == "RE"
					TRB2->XDATFATR	:= TRB1->PDATAMOV
					TRB2->XVDCIRE	:= TRB1->PXVDCI
					TRB2->XVDSIRE	:= TRB1->PXVDSI
					TRB2->TPR		:= "R"
				endif
			MsUnlock()
			TRB1->(dbskip())
		enddo
	

	QUERY->(dbskip())

enddo

IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,,"Selecionando Registros...")	

TRB1->(dbclearfil())
TRB3->(dbclearfil())
QUERY->(dbclosearea())
CTD->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROSTATPR												   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o Project Status PR			                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function PROSTATGR()

local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""
 Local xTotItemCI		:= 0
 Local xTotItemSI		:= 0
 
 Local xTotICIpl		:= 0
 Local xTotISIpl		:= 0
 
 local dData1
 local dData2
 local cWeekJOB
 
 Local aInd:={}
 Local cCondicao
 Local bFiltraBrw
 local cFor := "ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'GR'"
 local cFor3 := ""
 local nContar := 0

CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM,CTD_DTEXSF,CTD_XIDPM",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())
	nContar := 0
	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		ProcessMessage()

	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERY->(dbskip())
		Loop
	endif

	if ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'PR/CM/EN/AT/ST/EQ'
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

	
	if MV_PAR12 == 1 .AND. dtos(QUERY->CTD_DTEXSF) < dtos(DDATABASE)
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. dtos(QUERY->CTD_DTEXSF) >= dtos(DDATABASE)
		QUERY->(dbskip())
		Loop
	endif
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) $ 'PL/RE' "
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")
	
		ProcRegua(TRB1->(reccount()))
	
	if MV_PAR15 = 1		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
		
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. dtos(TRB1->PDATAMOV) >= dtos(MV_PAR13) .AND. dtos(TRB1->PDATAMOV) <= dtos(MV_PAR14)
				nContar		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
			
		if nContar = 0
			QUERY->(dbskip())
			Loop
		endif
	endif
	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
	RecLock("TRB2",.T.)
		
		TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
		TRB2->CLIENTE	:= QUERY->CTD_XNREDU
		TRB2->XVDCI		:= QUERY->CTD_XVDCI
		TRB2->XVDSI		:= QUERY->CTD_XVDSI
		TRB2->XVDCIR	:= QUERY->CTD_XVDCIR
		TRB2->XVDSIR	:= QUERY->CTD_XVDSIR
		
		cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'PL'"
		
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")
	
		ProcRegua(TRB1->(reccount()))
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
		
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB1->PXTIPO) == "PL"
				xTotICIpl		+= TRB1->PXVDCI
				xTotISIpl		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
		
		TRB2->XVDCIP	:= xTotICIpl
		TRB2->XVDSIP	:= xTotISIpl
		
		xTotICIpl := 0
		xTotISIpl := 0

		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "PL"
				xTotICIpl		+= TRB3->XVDCI
				xTotISIpl		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		TRB2->XVDCIP2	:= xTotICIpl
		TRB2->XVDSIP2	:= xTotISIpl
		
		xTotICIpl := 0
		xTotISIpl := 0
		
		cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'RE'"
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

		ProcRegua(TRB1->(reccount()))
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB1->PXTIPO) == "RE"
				xTotItemCI		+= TRB1->PXVDCI
				xTotItemSI		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
				
		TRB2->XVDCIRE 	:= xTotItemCI
		TRB2->XVDSIRE 	:= xTotItemSI
		
		xTotItemCI := 0
		xTotItemSI := 0
		
		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "RE"
				xTotItemCI		+= TRB3->XVDCI
				xTotItemSI		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		TRB2->XVDCIRE2 	:= xTotItemCI
		TRB2->XVDSIRE2 	:= xTotItemSI
		
		xTotItemCI := 0
		xTotItemSI := 0
		
		TRB2->XSLDPG	:= QUERY->CTD_XVDCIR - TRB2->XVDCIRE 
		TRB2->XPERFAT	:= (TRB2->XVDCIRE / QUERY->CTD_XVDCIR)*100
		TRB2->XPERFAT2	:= (TRB2->XVDCIRE2 / QUERY->CTD_XVDCIR)*100
		TRB2->CAMPO 	:= QUERY->CTD_ITEM
		TRB2->TPR		:= "T"

	MsUnlock()
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'PL' "
	
	IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

	ProcRegua(TRB1->(reccount()))
	
	TRB1->(dbgotop())
	
		while TRB1->(!eof())
			RecLock("TRB2",.T.)
				TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
				if alltrim(TRB1->PXTIPO) == "PL"
					TRB2->XDATFATP	:= TRB1->PDATAMOV
					TRB2->XVDCIP	:= TRB1->PXVDCI
					TRB2->XVDSIP	:= TRB1->PXVDSI
					TRB2->TPR		:= "P"
				endif
			MsUnlock()
			TRB1->(dbskip())
		enddo
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'RE'"
	
	IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

	ProcRegua(TRB1->(reccount()))
		
	TRB1->(dbgotop())
	
		while TRB1->(!eof())
			RecLock("TRB2",.T.)
				TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
				if alltrim(TRB1->PXTIPO) == "RE"
					TRB2->XDATFATR	:= TRB1->PDATAMOV
					TRB2->XVDCIRE	:= TRB1->PXVDCI
					TRB2->XVDSIRE	:= TRB1->PXVDSI
					TRB2->TPR		:= "R"
				endif
			MsUnlock()
			TRB1->(dbskip())
		enddo
	
	QUERY->(dbskip())

enddo
	
IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,,"Selecionando Registros...")	

TRB1->(dbclearfil())
TRB3->(dbclearfil())
QUERY->(dbclosearea())
CTD->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROSTATPR												   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o Project Status PR			                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function PROSTATCM()

local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData 		:= DDatabase
Local QUERY 		:= ""

 Local xTotItemCI		:= 0
 Local xTotItemSI		:= 0
 
 Local xTotICIpl		:= 0
 Local xTotISIpl		:= 0
 
 local dData1
 local dData2
 local cWeekJOB
 
 Local aInd:={}
 Local cCondicao
 Local bFiltraBrw
 local cFor := "ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'CM'"
 local cFor3 := ""
 local nContar := 0
 
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM,CTD_DTEXSF,CTD_XIDPM",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())
	nContar := 0
	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		ProcessMessage()

	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
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
	
	if SUBSTR(QUERY->CTD_ITEM,9,2) < MV_PAR10
		QUERY->(dbskip())
		Loop
	endif

	if SUBSTR(QUERY->CTD_ITEM,9,2)> MV_PAR11
		QUERY->(dbskip())
		Loop
	endif
		
	if MV_PAR12 == 1 .AND. dtos(QUERY->CTD_DTEXSF) < dtos(DDATABASE)
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. dtos(QUERY->CTD_DTEXSF) >= dtos(DDATABASE)
		QUERY->(dbskip())
		Loop
	endif
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) $ 'PL/RE' "
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")
	
		ProcRegua(TRB1->(reccount()))
	
	if MV_PAR15 = 1		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
		
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. dtos(TRB1->PDATAMOV) >= dtos(MV_PAR13) .AND. dtos(TRB1->PDATAMOV) <= dtos(MV_PAR14)
				nContar		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
			
		if nContar = 0
			QUERY->(dbskip())
			Loop
		endif
	endif
	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
	RecLock("TRB2",.T.)
		
		TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
		TRB2->CLIENTE	:= QUERY->CTD_XNREDU
		TRB2->XVDCI		:= QUERY->CTD_XVDCI
		TRB2->XVDSI		:= QUERY->CTD_XVDSI
		TRB2->XVDCIR	:= QUERY->CTD_XVDCIR
		TRB2->XVDSIR	:= QUERY->CTD_XVDSIR
		
		cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'PL'"
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")
	
		ProcRegua(TRB1->(reccount()))
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
		
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB1->PXTIPO) == "PL"
				xTotICIpl		+= TRB1->PXVDCI
				xTotISIpl		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
		
		TRB2->XVDCIP	:= xTotICIpl
		TRB2->XVDSIP	:= xTotISIpl
		
		xTotICIpl := 0
		xTotISIpl := 0

		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "PL"
				xTotICIpl		+= TRB3->XVDCI
				xTotISIpl		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		TRB2->XVDCIP2	:= xTotICIpl
		TRB2->XVDSIP2	:= xTotISIpl
		
		xTotICIpl := 0
		xTotISIpl := 0
		
		cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'RE'"
	
		IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

		ProcRegua(TRB1->(reccount()))
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->PITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB1->PXTIPO) == "RE"
				xTotItemCI		+= TRB1->PXVDCI
				xTotItemSI		+= TRB1->PXVDSI
			endif
			TRB1->(dbskip())
		EndDo
		
		TRB2->XVDCIRE 	:= xTotItemCI
		TRB2->XVDSIRE 	:= xTotItemSI
		
		xTotItemCI := 0
		xTotItemSI := 0
		
		TRB3->(dbgotop())
		While TRB3->( ! EOF() )
			if alltrim(TRB3->ITEMCONTA) == Alltrim(QUERY->CTD_ITEM)  .AND. alltrim(TRB3->XTIPO) == "RE"
				xTotItemCI		+= TRB3->XVDCI
				xTotItemSI		+= TRB3->XVDSI
			endif
			TRB3->(dbskip())
		EndDo
		
		TRB2->XVDCIRE2 	:= xTotItemCI
		TRB2->XVDSIRE2 	:= xTotItemSI
		
		xTotItemCI := 0
		xTotItemSI := 0
		
		TRB2->XSLDPG	:= QUERY->CTD_XVDCIR - TRB2->XVDCIRE 
		TRB2->XPERFAT	:= (TRB2->XVDCIRE / QUERY->CTD_XVDCIR)*100
		TRB2->XPERFAT2	:= (TRB2->XVDCIRE2 / QUERY->CTD_XVDCIR)*100
		TRB2->CAMPO 	:= QUERY->CTD_ITEM
		TRB2->TPR		:= "T"

	MsUnlock()
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'PL' "
	
	IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

	ProcRegua(TRB1->(reccount()))
	
	TRB1->(dbgotop())
	
		while TRB1->(!eof())
			RecLock("TRB2",.T.)
				TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
				if alltrim(TRB1->PXTIPO) == "PL"
					TRB2->XDATFATP	:= TRB1->PDATAMOV
					TRB2->XVDCIP	:= TRB1->PXVDCI
					TRB2->XVDSIP	:= TRB1->PXVDSI
					TRB2->TPR		:= "P"
				endif
			MsUnlock()
			TRB1->(dbskip())
		enddo
	
	cFor3 := "ALLTRIM(TRB1->PITEMCONTA) == QUERY->CTD_ITEM .AND. ALLTRIM(TRB1->PXTIPO) == 'RE'"
	
	IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,cFor3,"Selecionando Registros...")

	ProcRegua(TRB1->(reccount()))
		
	TRB1->(dbgotop())
	
		while TRB1->(!eof())
			RecLock("TRB2",.T.)
				TRB2->ITEMCONTA	:= QUERY->CTD_ITEM
				if alltrim(TRB1->PXTIPO) == "RE"
					TRB2->XDATFATR	:= TRB1->PDATAMOV
					TRB2->XVDCIRE	:= TRB1->PXVDCI
					TRB2->XVDSIRE	:= TRB1->PXVDSI
					TRB2->TPR		:= "R"
				endif
			MsUnlock()
			TRB1->(dbskip())
		enddo
	

	QUERY->(dbskip())

enddo
	
IndRegua("TRB1",CriaTrab(NIL,.F.),"PITEMCONTA",,,"Selecionando Registros...")	

TRB1->(dbclearfil())
TRB3->(dbclearfil())
QUERY->(dbclosearea())
CTD->(dbclosearea())

return

static function zTotTRB2()
	Local nTXVDCIP 		:= 0
	Local nTXVDSIP 		:= 0
	Local nTXVDCIRE 	:= 0
	Local nTXVDSIRE		:= 0
	Local nTXVDCIP2		:= 0
	Local nTXVDSIP2		:= 0
	Local nTXVDCIRE2	:= 0
	Local nTXVDSIRE2	:= 0
	
	TRB2->(dbgotop())
	While TRB2->( ! EOF() )
		
		if alltrim(TRB2->TPR) == "T"
			nTXVDCIP	+= TRB2->XVDCIP
			nTXVDSIP	+= TRB2->XVDSIP
			nTXVDCIRE	+= TRB2->XVDCIRE	
			nTXVDSIRE	+= TRB2->XVDSIRE
			nTXVDCIP2	+= TRB2->XVDCIP2
			nTXVDSIP2	+= TRB2->XVDSIP2
			nTXVDCIRE2	+= TRB2->XVDCIRE2
			nTXVDSIRE2	+= TRB2->XVDSIRE2
		endif
		
		TRB2->(dbskip())
		
	EndDo
	
	RecLock("TRB2",.T.)
			TRB2->ITEMCONTA	:= "TOTAL"
			TRB2->XVDCIP	:= nTXVDCIP
			TRB2->XVDSIP	:= nTXVDSIP
			TRB2->XVDCIRE	:= nTXVDCIRE
			TRB2->XVDSIRE	:= nTXVDSIRE
			TRB2->XVDCIP2	:= nTXVDCIP2
			TRB2->XVDSIP2	:= nTXVDSIP2
			TRB2->XVDCIRE2	:= nTXVDCIRE2
			TRB2->XVDSIRE2	:= nTXVDSIRE2
	MsUnlock()
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a tela de visualizacao do Fluxo Sintetico            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oGetDbSint2
Private _oDlgSint

cCadastro :=  "Faturamento - Sint้tico - " + dtoc(MV_PAR13) + " ate " +  dtoc(MV_PAR14)

// Monta aHeader do TRB2
//aadd(aHeader, {"OK","OK","",01,0,"","","C","TRB2","R","","",".F.","V"})
aadd(aHeader, {"Item Conta"			,"ITEMCONTA"	,""					,13,0,"","","C","TRB2","R"})
aadd(aHeader, {"Cliente"			,"CLIENTE"		,""					,60,0,"","","C","TRB2","R"})
aadd(aHeader, {"Venda c/ Tributos"	,"XVDCI"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"s/ Tributos"		,"XVDSI"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"c/ Tributos	Rev."	,"XVDCIR"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"s/ Tributos Rev."	,"XVDSIR"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})

aadd(aHeader, {"Data Plan."			,"XDATFATP"	,""					,8,0,""			,"","D","TRB2",""})

aadd(aHeader, {"c/ Trib. Plan."  + Chr(13) + Chr(10) + " (Periodo)"	,"XVDCIP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"s/ Trib. Plan."  + Chr(13) + Chr(10) + " (Periodo)"	,"XVDSIP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})

aadd(aHeader, {"Data Real"			,"XDATFATR"	,""					,8,0,""			,"","D","TRB2",""})

aadd(aHeader, {"c/ Trib. Real" + Chr(13) + Chr(10) + " (Periodo)"	,"XVDCIRE"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"s/ Trib. Real" + Chr(13) + Chr(10) + " (Periodo)"	,"XVDSIRE"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"% Faturado" + Chr(13) + Chr(10) + " (Periodo)"	,"XPERFAT"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
//aadd(aHeader, {"Saldo a Faturar"	,"XSLDPG"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})



aadd(aHeader, {"c/ Trib. Plan."  + Chr(13) + Chr(10) + " (Total)"	,"XVDCIP2"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"s/ Trib. Plan."  + Chr(13) + Chr(10) + " (Total)"	,"XVDSIP2"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"c/ Trib. Real" + Chr(13) + Chr(10) + " (Total)"	,"XVDCIRE2"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"s/ Trib. Real" + Chr(13) + Chr(10) + " (Total)"	,"XVDSIRE2"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"% Faturado" + Chr(13) + Chr(10) + "(Total) "	,"XPERFAT2"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
//aadd(aHeader, {"CAMPO"				,"CAMPO"		,""					,13,0,"","","C","TRB1","R"})
aadd(aHeader, {"TPR"			,"TPR"	,""					,01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgSint ;
TITLE "Faturamento - Sint้tico " ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2")

_oGetDbSint:oBrowse:bLClicked := {|| msginfo("bHeaderClick") }

//_oGetDbSint:oBrowse:BlDblClick := 	{|| ShowAnalit()  , _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()  }

// COR DA FONTE
_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
// COR DA LINHA
//_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| fTrocaCor(2)}
_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha

_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ColPos(),2],aheader[_oGetDbSint:oBrowse:ColPos(),1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

aadd(aButton , { "BMPTABLE" , { || zExpFatF()}, "Gerar Plan. Excel " } )
aadd(aButton , { "BMPTABLE" , { ||MntTlTRB3()}, "TRB3 " } )
aadd(aButton , { "BMPTABLE" , { ||MntTlTRB1()}, "TRB1 " } )

//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
//aadd(aButton , { "BMPTABLE" , { || VendidoFull("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Vendido " } )

//aadd(aButton , { "BMPTABLE" , { || ShowAnalit()}, "Imprimir " } )
//aadd(aButton , { "BMPTABLE" , { || GCemail()}, "Enviar Email " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

TRB2->(dbgotop())

return

Static Function SFMudaCor(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  
   	  //if EMPTY(ALLTRIM(TRB2->DESCRICAO)) .AND. EMPTY(ALLTRIM(TRB2->GRUPO)); _cCor := CLR_LIGHTGRAY; endif
   	    	 
    endif
      
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB2->TPR) ==  "T"; _cCor := CLR_HCYAN ; endif
   	  if ALLTRIM(TRB2->ITEMCONTA) ==  "TOTAL"; _cCor := CLR_HGREEN ; endif
   	 
    endif
Return _cCor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a tela de trb3 faturamento total			          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function MntTlTRB3()

local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Faturamento - TRB3- " + dtoc(MV_PAR13) + " ate " +  dtoc(MV_PAR14)

// Monta aHeader do TRB2
//aadd(aHeader, {"OK","OK","",01,0,"","","C","TRB2","R","","",".F.","V"})
aadd(aHeader, {"Item Conta"			,"ITEMCONTA"	,""					,13,0,"","","C","TRB3","R"})
aadd(aHeader, {"Descricao"			,"DESCR"		,""					,25,0,"","","C","TRB3","R"})
aadd(aHeader, {"NF"					,"NF"			,""					,10,0,"","","C","TRB3","R"})
aadd(aHeader, {"SERIE"				,"SERIE"		,""					,10,0,"","","C","TRB3","R"})
aadd(aHeader, {"Data Mov."			,"DATAMOV"		,""					,08,0,"","","D","TRB3","R"})
aadd(aHeader, {"c/ Trib."			,"XVDCI"		,"@E 999,999,999.99",15,2,"","","N","TRB3","R"})
aadd(aHeader, {"s/ Trib."			,"XVDSI"		,"@E 999,999,999.99",15,2,"","","N","TRB3","R"})
aadd(aHeader, {"Tipo"				,"XTIPO"		,""					,10,0,"","","C","TRB3",""})
aadd(aHeader, {"Origem"				,"ORIGEM"		,""					,03,0,"","","C","TRB3",""})
aadd(aHeader, {"Campo"		 		,"CAMPO"		,""					,13,0,"","","C","TRB3","R"})
aadd(aHeader, {"Data mov 2"			,"XDELMON2"		,""					,07,0,"","","C","TRB3","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Faturamento - TRB3- " + dtoc(MV_PAR13) + " ate " +  dtoc(MV_PAR14) From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB3")

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB3->(dbclearfil())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a tela de trb1 faturamento total			          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function MntTlTRB1()

local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Faturamento - TRB1- " + dtoc(MV_PAR13) + " ate " +  dtoc(MV_PAR14)

// Monta aHeader do TRB2
//aadd(aHeader, {"OK","OK","",01,0,"","","C","TRB2","R","","",".F.","V"})
aadd(aHeader, {"Item Conta"			,"PITEMCONTA"	,""					,13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descricao"			,"PDESCR"		,""					,25,0,"","","C","TRB1","R"})
aadd(aHeader, {"NF"					,"PNF"			,""					,10,0,"","","C","TRB1","R"})
aadd(aHeader, {"SERIE"				,"PSERIE"		,""					,10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Data Mov."			,"PDATAMOV"		,""					,08,0,"","","D","TRB1","R"})
aadd(aHeader, {"c/ Trib."			,"PXVDCI"		,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"s/ Trib."			,"PXVDSI"		,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Tipo"				,"PXTIPO"		,""					,10,0,"","","C","TRB1",""})
aadd(aHeader, {"Origem"				,"PORIGEM"		,""					,03,0,"","","C","TRB1",""})
aadd(aHeader, {"Campo"		 		,"PCAMPO"		,""					,13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Data mov 2"			,"PXDELMON2"		,""					,07,0,"","","C","TRB1","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Faturamento - TRB1- " + dtoc(MV_PAR13) + " ate " +  dtoc(MV_PAR14) From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exportacao Faturamento				                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function zExpFatF()
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpSintetico.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
   
    TRB2->(dbgotop())
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do tํtulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Faturamento - Sint้tico") 
        //Criando a Tabela
        oFWMsExcel:AddTable("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14))
        
        aAdd(aColunas, "Item Conta")							// 1 Item Conta
        aAdd(aColunas, "Cliente")								// 2 Cliente
        aAdd(aColunas, "Venda c/ Tributos")						// 3 Venda c/ Tributos
        aAdd(aColunas, "s/ Tributos")							// 4 s/ Tributos
        aAdd(aColunas, "c/ Tributos	Rev.")						// 5 c/ Tributos	Rev.
        aAdd(aColunas, "s/ Tributos Rev.")						// 6 s/ Tributos Rev.
             
        aAdd(aColunas, "Data Plan.")						// 6 s/ Tributos Rev.
        aAdd(aColunas, "c/ Tributos	Plan. (Periodo)")						// 7 c/ Tributos	Plan.
        aAdd(aColunas, "s/ Tributos Plan. (Periodo)")						// 8 s/ Tributos Plan.
        
        aAdd(aColunas, "Data Real")						// 6 s/ Tributos Rev.
        aAdd(aColunas, "c/ Tributos	Real (Perido)")						// 9 c/ Tributos	Real
        aAdd(aColunas, "s/ Tributos Real (Perido)")						// 10 s/ Tributos Real
        aAdd(aColunas, "% Faturado (Perido)")
        
        aAdd(aColunas, "c/ Tributos	Plan. (Total)")						// 7 c/ Tributos	Plan.
        aAdd(aColunas, "s/ Tributos Plan. (Total)")						// 8 s/ Tributos Plan.										// 11 % 
        aAdd(aColunas, "c/ Tributos	Real (Total)")						// 9 c/ Tributos	Real
        aAdd(aColunas, "s/ Tributos Real (Total)")						// 10 s/ Tributos Real
        aAdd(aColunas, "% Faturado (Total)")										// 11 % 
        aAdd(aColunas, "TPR")

        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "Item Conta",2,4)				// 1 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "Cliente",1,2)					// 2 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "Venda c/ Tributos",1,2)			// 3 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "s/ Tributos",1,2)				// 4 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "c/ Tributos	Rev.",1,2)			// 5 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "s/ Tributos Rev.",1,2)			// 6 
        
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "Data Plan.",2,4)
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "c/ Tributos	Plan. (Periodo)",1,2)			// 7 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "s/ Tributos Plan. (Periodo)",1,2)	
        
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "Data Real",2,4)		// 8 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "c/ Tributos	Real (Periodo)",1,2)					// 9 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "s/ Tributos Real (Periodo)",1,2)				// 10 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "% Faturado Periodo",1,2)
        
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "c/ Tributos	Plan. (Total)",1,2)			// 7 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "s/ Tributos Plan. (Total)",1,2)			// 8 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "c/ Tributos	Real (Total)",1,2)					// 9 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "s/ Tributos Real (Total)",1,2)				// 10 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "% Faturado (Total)",1,2)		// 11 
        oFWMsExcel:AddColumn("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , "TPR",2,4)
              
        While  !(TRB2->(EoF()))
 
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB2->ITEMCONTA
        	aLinhaAux[2] := TRB2->CLIENTE
        	aLinhaAux[3] := TRB2->XVDCI
        	aLinhaAux[4] := TRB2->XVDSI
        	aLinhaAux[5] := TRB2->XVDCIR
        	aLinhaAux[6] := TRB2->XVDSIR
        	
        	aLinhaAux[7] := TRB2->XDATFATP
        	aLinhaAux[8] := TRB2->XVDCIP
        	aLinhaAux[9] := TRB2->XVDSIP
        	
        	aLinhaAux[10] := TRB2->XDATFATR
        	aLinhaAux[11] := TRB2->XVDCIRE
        	aLinhaAux[12] := TRB2->XVDSIRE
        	aLinhaAux[13] := TRB2->XPERFAT
        	
        	aLinhaAux[14] := TRB2->XVDCIP2
        	aLinhaAux[15] := TRB2->XVDSIP2
        	aLinhaAux[16] := TRB2->XVDCIRE2
        	aLinhaAux[17] := TRB2->XVDSIRE2
        	aLinhaAux[18] := TRB2->XPERFAT2
        	aLinhaAux[19] := TRB2->TPR
              	       	
        	//if substr(alltrim(aLinhaAux[1]),1,5) == "TOTAL"
        	//	oFWMsExcel:SetCelBgColor("#4169E1")
        	//	oFWMsExcel:AddRow("Project Status","Project Status", aLinhaAux,{1})
        	//else
        		
        		oFWMsExcel:AddRow("Faturamento - Sint้tico","Faturamento - Sint้tico - " +  dtoc(MV_PAR13) + " ate " + dtoc(MV_PAR14) , aLinhaAux)
        	//endif
            TRB2->(DbSkip())

        EndDo

        TRB2->(dbgotop())
   
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             	//Abre uma nova conexใo com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)                 	//Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

Return

static function ShowAnalit(_Campo)
local cFiltra 	:= ""

local cFiltra2 	:= ""
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo2   := { aSize[ 1 ], aSize[ 2 ]+90, aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo2, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Faturamento - Analํtico - " + TRB2->ITEMCONTA

DEFINE MSDIALOG _oDlgAnalit TITLE "Faturamento - Analํtico"  From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

zCabec()
zTelTrb1()
zTelTrb3()

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-170,aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA TIPO: PL - Planejado / RE - Realizado / LEGENDA ORIGEM: / PL - Planejamento / DS - Documento de Saida / IV - Invoice Financeiro / DV - NF Devolucao "  COLORS 0, 16777215 PIXEL

aadd(aButton , { "BMPTABLE" , { || zExpFDet()}, "Gerar Plan. Excel (Periodo)" } )
aadd(aButton , { "BMPTABLE" , { || zExpDFull()}, "Gerar Plan. Excel (Total)" } )

//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
//aadd(aButton , { "BMPTABLE" , { || PRNGCdet()}, "Imprimir " } )

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())
TRB3->(dbclearfil())
cField 		:= ""
_cItemConta := ""

return

static function zTelTrb1()
	local cFiltra 	:= ""
		
	// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
	cFiltra := " TRB1->PITEMCONTA  == '" + TRB2->ITEMCONTA + "' "
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	
	aadd(aHeader, {"Tipo"				 	,"PXTIPO"	,"",10,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Origem"				 	,"PORIGEM"	,"",03,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Descricao"				,"PDESCR"	,"",25,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Nf"						,"PNF"		,"",10,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Serie"					,"PSERIE"	,"",10,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Planejado / Emissao" 	,"PDATAMOV"	,"",08,0,"","","D","TRB1","R"})
	aadd(aHeader, {"c/ Tributos"			,"PXVDCI"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"s/ Tributos"			,"PXVDSI"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Item Conta"				,"PITEMCONTA","",13,0,"","","C","TRB1","R"})
	
	//aadd(aHeader, {"Data"				,"XDELMON2"	,""					,7,0,""			,"","C","TRB1",""})
	
	@ aPosObj[1,1]-10 , aPosObj[2,2]+5 Say "Faturamento - " + dtoc(MV_PAR13) + " ate " +  dtoc(MV_PAR14)  COLORS 0, 16777215 PIXEL
		
return

static function zTelTrb3()

	local cFiltra2 	:= ""
	
	cFiltra2 := " TRB3->ITEMCONTA  == '" + TRB2->ITEMCONTA + "' "
	TRB3->(dbsetfilter({|| &(cFiltra2)} , cFiltra2))
	
	aadd(aHeader, {"Tipo"				 	,"XTIPO"	,"",10,0,"","","C","TRB3","R"})
	aadd(aHeader, {"Origem"				 	,"ORIGEM"	,"",03,0,"","","C","TRB3","R"})
	aadd(aHeader, {"Descricao"				,"DESCR"	,"",25,0,"","","C","TRB3","R"})
	aadd(aHeader, {"Nf"						,"NF"		,"",10,0,"","","C","TRB3","R"})
	aadd(aHeader, {"Serie"					,"SERIE"	,"",10,0,"","","C","TRB3","R"})
	aadd(aHeader, {"Planejado / Emissao" 	,"DATAMOV"	,"",08,0,"","","D","TRB3","R"})
	aadd(aHeader, {"c/ Tributos"			,"XVDCI"	,"@E 999,999,999.99",15,2,"","","N","TRB3","R"})
	aadd(aHeader, {"s/ Tributos"			,"XVDSI"	,"@E 999,999,999.99",15,2,"","","N","TRB3","R"})
	aadd(aHeader, {"Item Conta"				,"ITEMCONTA","",13,0,"","","C","TRB3","R"})
	
	nPos := aPosObj[1,1]+150

	@ nPos-10 , aPosObj[2,2]+5 Say "Faturamento Total "  COLORS 0, 16777215 PIXEL
	
	_oGetDbAnalit2 := MsGetDb():New(nPos,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
	"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB3")
		
return

static function zCabec()

oGroup1:= TGroup():New(0029,0015,0053,0730,'',_oDlgAnalit,,,.T.)
oGroup2:= TGroup():New(0054,0015,0080,0345,'Venda',_oDlgAnalit,,,.T.)
oGroup3:= TGroup():New(0054,0350,0080,0730,'Venda Revisado',_oDlgAnalit,,,.T.)

oGroup4:= TGroup():New(0081,0015,0110,0345,'Custo Vendido',_oDlgAnalit,,,.T.)
oGroup5:= TGroup():New(0081,0350,0110,0730,'Custo Revisado',_oDlgAnalit,,,.T.)

@ 0030,0020 Say  "Item Conta: " COLORS 0, 16777215 PIXEL
@ 0038,0020 MSGET  TRB2->ITEMCONTA  COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0120 Say  "No.Proposta: "  COLORS 0, 16777215 PIXEL
@ 0038,0120 MSGET alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_NPROP")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0200 Say  "Cod.Cทliente: " 	 COLORS 0, 16777215 PIXEL
@ 0038,0200 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XCLIEN")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0280 Say  "Cliente: " COLORS 0, 16777215 PIXEL
@ 0038,0280 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XNREDU")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0480 Say  "Coord.Cod.: " COLORS 0, 16777215 PIXEL
@ 0038,0480 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XIDPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0540 Say  "Coordenador " 	COLORS 0, 16777215 PIXEL
@ 0038,0540 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XNOMPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.


@ 0058,0040 Say  "c/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0066,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XVDCI"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0100 Say  "s/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0066,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XVDSI"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0160 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
@ 0066,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XSISFV"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0220 Say  "c/ Tributos US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0220 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XVDCID"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0280 Say  "s/ Tributos US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0280 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XVDSID"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.


@ 0058,0400 Say  "c/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0066,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XVDCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0460 Say  "s/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0066,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XVDSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0520 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
@ 0066,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XSISFR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0580 Say  "c/ Tributos  US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XVCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0640 Say  "s/ Tributos  US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XVSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0040 Say  "Produ็ใo " 	COLORS 0, 16777215 PIXEL
@ 0095,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XCUSTO"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0100 Say  "COGS Vendido " 	COLORS 0, 16777215 PIXEL
@ 0095,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XCOGSV"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0160 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0095,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XCUTOT"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0220 Say  "Data Cโmbio " 	COLORS 0, 16777215 PIXEL
@ 0095,0220 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XDTCB")) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0280 Say  "Vlr. Cโmbio " 	COLORS 0, 16777215 PIXEL
@ 0095,0280 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XCAMB"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0400 Say  "Produ็ใo " 	COLORS 0, 16777215 PIXEL
@ 0095,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XCUPRR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0460 Say  "COGS REV. " 	COLORS 0, 16777215 PIXEL
@ 0095,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XCOGSR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0520 Say  "Total" 	COLORS 0, 16777215 PIXEL
@ 0095,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XCUTOR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0580 Say  "Verba adicional" 	COLORS 0, 16777215 PIXEL
@ 0095,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+TRB2->ITEMCONTA,"CTD_XVBAD"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exportacao Faturamento				                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function zExpFDet()
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpAnalitico.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
   
    TRB2->(dbgotop())
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do tํtulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Faturamento - Analํtico") 
        //Criando a Tabela
        oFWMsExcel:AddTable("Faturamento - Analํtico","Faturamento - Analํtico")
        
        aAdd(aColunas, "Item Conta")							// 1 Item Conta
        aAdd(aColunas, "Tipo")									// 2 Tipo
        aAdd(aColunas, "Origem")								// 3 Origem
        aAdd(aColunas, "Descricao")								// 4 Descricao
        aAdd(aColunas, "Nf")									// 5 Nf
        aAdd(aColunas, "Serie")									// 6 Serie
        aAdd(aColunas, "Planejado / Emissao")					// 7 Planejado / Emissao
        aAdd(aColunas, "c/ Tributos")							// 8 c/ Tributos
        aAdd(aColunas, "s/ Tributos")							// 9 s/ Tributos

        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Item Conta",2,4)				// 1 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Tipo",1,2)						// 2 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Origem",1,2)					// 3 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Descricao",1,2)					// 4 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Nf",1,2)						// 5 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Serie",1,2)						// 6 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Planejado / Emissao",1,2)		// 7 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "c/ Tributos",1,2)				// 8 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "s/ Tributos",1,2)				// 9 
       
        While  !(TRB1->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB1->PITEMCONTA
        	aLinhaAux[2] := TRB1->PXTIPO
        	aLinhaAux[3] := TRB1->PORIGEM
        	aLinhaAux[4] := TRB1->PDESCR
        	aLinhaAux[5] := TRB1->PNF
        	aLinhaAux[6] := TRB1->PSERIE
        	aLinhaAux[7] := TRB1->PDATAMOV
        	aLinhaAux[8] := TRB1->PXVDCI
        	aLinhaAux[9] := TRB1->PXVDSI
                	       	
        	//if substr(alltrim(aLinhaAux[1]),1,5) == "TOTAL"
        	//	oFWMsExcel:SetCelBgColor("#4169E1")
        	//	oFWMsExcel:AddRow("Project Status","Project Status", aLinhaAux,{1})
        	//else
        		
        		oFWMsExcel:AddRow("Faturamento - Analํtico","Faturamento - Analํtico" , aLinhaAux)
        	//endif
            TRB1->(DbSkip())

        EndDo

        TRB1->(dbgotop())
   
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             	//Abre uma nova conexใo com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)                 	//Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exportacao Faturamento				                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function zExpDFull()
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpAnalitico.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
   
    TRB2->(dbgotop())
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do tํtulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Faturamento - Analํtico") 
        //Criando a Tabela
        oFWMsExcel:AddTable("Faturamento - Analํtico","Faturamento - Analํtico")
        
        aAdd(aColunas, "Item Conta")							// 1 Item Conta
        aAdd(aColunas, "Tipo")									// 2 Tipo
        aAdd(aColunas, "Origem")								// 3 Origem
        aAdd(aColunas, "Descricao")								// 4 Descricao
        aAdd(aColunas, "Nf")									// 5 Nf
        aAdd(aColunas, "Serie")									// 6 Serie
        aAdd(aColunas, "Planejado / Emissao")					// 7 Planejado / Emissao
        aAdd(aColunas, "c/ Tributos")							// 8 c/ Tributos
        aAdd(aColunas, "s/ Tributos")							// 9 s/ Tributos

        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Item Conta",2,4)				// 1 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Tipo",1,2)						// 2 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Origem",1,2)					// 3 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Descricao",1,2)					// 4 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Nf",1,2)						// 5 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Serie",1,2)						// 6 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "Planejado / Emissao",1,2)		// 7 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "c/ Tributos",1,2)				// 8 
        oFWMsExcel:AddColumn("Faturamento - Analํtico","Faturamento - Analํtico" , "s/ Tributos",1,2)				// 9 
   
        While  !(TRB3->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB3->ITEMCONTA
        	aLinhaAux[2] := TRB3->XTIPO
        	aLinhaAux[3] := TRB3->ORIGEM
        	aLinhaAux[4] := TRB3->DESCR
        	aLinhaAux[5] := TRB3->NF
        	aLinhaAux[6] := TRB3->SERIE
        	aLinhaAux[7] := TRB3->DATAMOV
        	aLinhaAux[8] := TRB3->XVDCI
        	aLinhaAux[9] := TRB3->XVDSI
               	       	
        	//if substr(alltrim(aLinhaAux[1]),1,5) == "TOTAL"
        	//	oFWMsExcel:SetCelBgColor("#4169E1")
        	//	oFWMsExcel:AddRow("Project Status","Project Status", aLinhaAux,{1})
        	//else
        		
        		oFWMsExcel:AddRow("Faturamento - Analํtico","Faturamento - Analํtico" , aLinhaAux)
        	//endif
            TRB3->(DbSkip())

        EndDo

        TRB1->(dbgotop())
   
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             	//Abre uma nova conexใo com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)                 	//Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Arquivo em Excel e abre                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Arquivo em Excel e abre                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	MsgAlert("Falha na cria็ใo do arquivo")
Endif

(_cAlias)->(dbclearfil())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function AbreArq()
local aStru 	:= {}

local _cCpoAtu
local _ni

if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Nใo foi possํvel abrir o arquivo GCIN01.XLS pois ele pode estar aberto por outro usuแrio.")
	return(.F.)
endif

// monta arquivo analitico TRB1
aAdd(aStru,{"PITEMCONTA"	,"C",13,0})
aAdd(aStru,{"PDESCR"		,"C",25,0})
aAdd(aStru,{"PNF"		,"C",10,0})
aAdd(aStru,{"PSERIE"		,"C",10,0})
aAdd(aStru,{"PDATAMOV"	,"D",08,0})
aAdd(aStru,{"PXVDCI"		,"N",15,2})		// VALOR VENDIDO ORIGINAL C/ TRIBUTOS
aAdd(aStru,{"PXVDSI"		,"N",15,2})		// VALOR VENDIDO ORIGINAL S/ TRIBUTOS
aAdd(aStru,{"PXTIPO"		,"C",10,0})
aAdd(aStru,{"PORIGEM"	,"C",03,0})
aAdd(aStru,{"PCAMPO"		,"C",13,0})
aAdd(aStru,{"PXDELMON2"	,"C",7,0}) // Valor total dos movimentos


dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)
//dbUseArea(.T.,,cArqTrb1,"TRB11",.T.,.F.)

//****************
aStru := {}
aAdd(aStru,{"ITEMCONTA"	,"C",13,0})		// ITEM CONTA
aAdd(aStru,{"CLIENTE"	,"C",60,0}) 	// CLIENTE
aAdd(aStru,{"XVDCI"		,"N",15,2})		// VALOR VENDIDO ORIGINAL C/ TRIBUTOS
aAdd(aStru,{"XVDSI"		,"N",15,2})		// VALOR VENDIDO ORIGINAL S/ TRIBUTOS

aAdd(aStru,{"XVDCIR"	,"N",15,2})		// VALOR VENDIDO ORIGINAL
aAdd(aStru,{"XVDSIR"	,"N",15,2})
aAdd(aStru,{"XVDCIP"	,"N",15,2})
aAdd(aStru,{"XVDSIP"	,"N",15,2})
aAdd(aStru,{"XVDCIRE"	,"N",15,2})
aAdd(aStru,{"XVDSIRE"	,"N",15,2})
aAdd(aStru,{"XSLDPG"	,"N",15,2})
aAdd(aStru,{"XPERFAT"	,"N",15,2})
aAdd(aStru,{"XVDCIP2"	,"N",15,2})
aAdd(aStru,{"XVDSIP2"	,"N",15,2})
aAdd(aStru,{"XVDCIRE2"	,"N",15,2})
aAdd(aStru,{"XVDSIRE2"	,"N",15,2})
aAdd(aStru,{"XPERFAT2"	,"N",15,2})
aAdd(aStru,{"CAMPO"		,"C",13,0})
aAdd(aStru,{"XDATFATP"	,"D",8,0}) // Valor total dos movimentos
aAdd(aStru,{"XDATFATR"	,"D",8,0}) // Valor total dos movimentos

aAdd(aStru,{"TPR"	,"C",01,0})		// ITEM CONTA

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)

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

/*
aadd(_aCpos , "ITEMCONTA")
aadd(_aCpos , "CLIENTE")
aadd(_aCpos , "XVDCI")
aadd(_aCpos , "XVDSI")
aadd(_aCpos , "XVDCIR")
aadd(_aCpos , "XVDSIR")
aadd(_aCpos , "XVDCIP")
aadd(_aCpos , "XVDSIP")
aadd(_aCpos , "XVDCIRE")
aadd(_aCpos , "XVDSIRE")
aadd(_aCpos , "XSLDPG")
aadd(_aCpos , "XPERFAT")

_nCampos := len(_aCpos)
*/
index on ITEMCONTA to &(cArqTrb2+"2")
index on ITEMCONTA to &(cArqTrb2+"1")

set index to &(cArqTrb2+"1")

return(.T.)

//--------------------------------------------------------------------------------------------

static function VldParamFR()

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
	putSx1(cPerg, "02", "Coordenador at้?" 				, "", "", "mv_ch2", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par02")
	PutSX1(cPerg, "03", "Assistencia Tecnica (AT)"		, "", "", "mv_ch3", "N", 01, 0, 0, "C", "", "", "", "", "mv_par03","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "04", "Comissao (CM)"					, "", "", "mv_ch4", "N", 01, 0, 0, "C", "", "", "", "", "mv_par04","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "05", "Engenharia (EN)"				, "", "", "mv_ch5", "N", 01, 0, 0, "C", "", "", "", "", "mv_par05","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "06", "Equipamento (EQ)"				, "", "", "mv_ch6", "N", 01, 0, 0, "C", "", "", "", "", "mv_par06","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "07", "Peca (PR)"						, "", "", "mv_ch7", "N", 01, 0, 0, "C", "", "", "", "", "mv_par07","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "08", "Sistema (ST)"					, "", "", "mv_ch8", "N", 01, 0, 0, "C", "", "", "", "", "mv_par08","Sim","","","","Nao","","","","","","","","","","","")

return
