#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#include 'parmtype.ch'
#Include "FWMVCDEF.ch"

//����������������������������������������������������������������������������// 
//                        Low Intensity colors 
//����������������������������������������������������������������������������// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//����������������������������������������������������������������������������// 
//                      High Intensity Colors 
//����������������������������������������������������������������������������// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01    												  ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera arquivo de fluxo de caixa                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico 		                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function zVisProp()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Booking"
local _cOldData	:= 	dDataBase // Grava a database

Local oBrowse := FwLoadBrw("MontaTela") // NAVEGADOR

private cPerg 		:= 	"ZFEBOOK"
private cPerg2 		:= 	"ZFEBOOK2"
private _cIdioma 	:= 1
private _cConsidera	:= 1

private _cArq	:= 	"zFeBook.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aDatas	:= {} // Matriz no formato [ data , campo ]
private _aLegPer:= {} // legenda dos periodos
private _aCpos1	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)

private cArqTrb1 := CriaTrab(NIL,.F.) //"PFIN011"
private cArqTrb13 := CriaTrab(NIL,.F.) //"PFIN013"

Private _aGrpSint:= {}
Private _cItemConta := ""

PergFebook()


/*
AADD(aSays,"Este programa gera planilha com os dados para o BOOKINGS  de acordo com os ")
AADD(aSays,"par�metros fornecidos pelo usu�rio. O arquivo gerado pode ser aberto de forma ")
AADD(aSays,"autom�tica pelo Excel.")
AADD(aSays,"")
AADD(aSays,"")
AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )
*/
// Se confirmado o processamento
//if nOpcA == 1

	//pergunte(cPerg,.F.)
	
	pergunte(cPerg,.T.)
	
	_cIdioma 	:= mv_par14
	_cConsidera := mv_par05

	if MV_PAR05 == 1
		_dDataIni 	:= mv_par06 // Data Registro de
		_dDataFim 	:= mv_par07 // Data Registro ate
	else
		_dDataIni 	:= mv_par08 // Data Prev. de
		_dDataFim 	:= mv_par09 // Data Prev. ate
	endif
	//_dDataIni 	:= DDATABASE // Data inicial
	//_dDataFim 	:= MonthSum( DDATABASE, 12 )// Data Final

	// Faz consistencias iniciais para permitir a execucao da rotina
	/*
	if !VldParam() .or. !AbreArq()
		return
	endif
	*/
	if !AbreArq()
		return
	endif
	

	
	MSAguarde({|| zNPROPGER()},"General list of proposals")
	
		
	MontaTela()

	TRB1->(dbclosearea())
	TRB13->(dbclosearea())

//endif

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�												   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa o Project Status AT	/ EN	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zNPROPGER()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("SZ9")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local QUERY2 		:= ""

local cFor 			:= "!ALLTRIM(SUBSTR(QUERY->Z9_NPROP,1,2)) $ '14/15/16/17'"

local cFor2 		:= ""
Local aInd			:={}
Local cCondicao
Local bFiltraBrw
 
Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0
Local nXTOTSI		:= 0
Local nXCUSTOT		:= 0
Local cEQUIPDES		:= ""
local cFiltro	:= ""

LOCAL cTipoSitS := ""
LOCAL cTipoSitC := ""
LOCAL cTipoSitT := ""
LOCAL cTipoSitM := ""
LOCAL nRegS := 0
LOCAL nRegC := 0
LOCAL nRegM := 0
LOCAL nRegT := 0

/**************** SZ9 **************/
SZ9->(dbsetorder(1)) 

ChkFile("SZ9",.F.,"QUERY") 
IndRegua("QUERY",CriaTrab(NIL,.F.),"Z9_DTPREV,Z9_NPROP",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

SZ9->(dbgotop())

/****************SZF - DETALHES *****/

SZF->(dbsetorder(3)) 

ChkFile("SZF",.F.,"QUERY2") 

/*************************************/

while QUERY->(!eof())

		MsProcTxt("Processando registro: "+alltrim(QUERY->Z9_NPROP))
		ProcessMessage()

		RecLock("TRB1",.T.)
		TRB1->NPROP		:= QUERY->Z9_NPROP
		
		IF QUERY->Z9_BOOK == "1" 
			TRB1->BOOK	:= "GENERAL"
		ELSEIF QUERY->Z9_BOOK == "2" 
			TRB1->BOOK	:= "MARKETING PLATFORM"
		ELSEIF QUERY->Z9_BOOK == "3" 
			TRB1->BOOK	:= "BOOKING"
		ELSE
			TRB1->BOOK	:= ""
		ENDIF
		
		if _cIdioma = 1
			IF QUERY->Z9_TIPO == "1" 
				TRB1->FXBUD	:= "FIXED"
			ELSEIF QUERY->Z9_TIPO == "2" 
				TRB1->FXBUD	:= "BUDGET"
			ELSEIF QUERY->Z9_TIPO == "3" 
				TRB1->FXBUD	:= "PROSPECTION"
			ENDIF
		else
			IF QUERY->Z9_TIPO == "1" 
				TRB1->FXBUD	:= "FIRME"
			ELSEIF QUERY->Z9_TIPO == "2" 
				TRB1->FXBUD	:= "ESTIMATIVA"
			ELSEIF QUERY->Z9_TIPO == "3" 
				TRB1->FXBUD	:= "PROSPECCAO"
			ENDIF
		endif
		
		if _cIdioma = 1
			IF ALLTRIM(QUERY->Z9_TIPO) == "1"
				TRB1->FEAEXEC := "EXECUTION"
			ELSEIF ALLTRIM(QUERY->Z9_TIPO) == "2"
				TRB1->FEAEXEC := "FEASIBILITY" 
			ELSEIF ALLTRIM(QUERY->Z9_TIPO) == "3"
				TRB1->FEAEXEC := "FEASIBILITY" 
			ELSE
				TRB1->FEAEXEC := ""
			ENDIF
		else
			IF ALLTRIM(QUERY->Z9_TIPO) == "1"
				TRB1->FEAEXEC := "EXECUCAO"
			ELSEIF ALLTRIM(QUERY->Z9_TIPO) == "2"
				TRB1->FEAEXEC := "VIABILIDADE" 
			ELSEIF ALLTRIM(QUERY->Z9_TIPO) == "3"
				TRB1->FEAEXEC := "VIABILIDADE" 
			ELSE
				TRB1->FEAEXEC := ""
			ENDIF
		endif
		
		
		if _cIdioma = 1
			IF ALLTRIM(QUERY->Z9_STATUS) == "1" 
				TRB1->STATUS	:= "ACTIVE"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "2" 
				TRB1->STATUS	:= "CANCELED"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "3" 
				TRB1->STATUS	:= "DECLINED"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "4" 
				TRB1->STATUS	:= "NOT SENT"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "5" 
				TRB1->STATUS	:= "LOST"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "6" 
				TRB1->STATUS	:= "SLC"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "7" 
				TRB1->STATUS	:= "SOLD"
			ENDIF
		else
			IF ALLTRIM(QUERY->Z9_STATUS) == "1" 
				TRB1->STATUS	:= "ATIVA"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "2" 
				TRB1->STATUS	:= "CANCELADA"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "3" 
				TRB1->STATUS	:= "DECLINADA"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "4" 
				TRB1->STATUS	:= "NAO ENVIADA"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "5" 
				TRB1->STATUS	:= "PERDIDA"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "6" 
				TRB1->STATUS	:= "SLC"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "7" 
				TRB1->STATUS	:= "VENDIDA"
			ENDIF
		endif
		
		TRB1->OPPNAME	:= QUERY->Z9_CONTR
		TRB1->COUNTRY	:= QUERY->Z9_PAIS
			
		//TRB1->MARKSEC	:= ""
		if _cIdioma = 1
			IF QUERY->Z9_MERCADO == "1" 
				TRB1->MARKSEC	:= "MINERALS"
			ELSEIF QUERY->Z9_MERCADO == "2" 
				TRB1->MARKSEC	:= "PULP PAPER"
			ELSEIF QUERY->Z9_MERCADO == "3" 
				TRB1->MARKSEC	:= "CHEMISTRY"
			ELSEIF QUERY->Z9_MERCADO == "4" 
				TRB1->MARKSEC	:= "FERTILIZER"
			ELSEIF QUERY->Z9_MERCADO == "5" 
				TRB1->MARKSEC	:= "SIDERURGY"
			ELSEIF QUERY->Z9_MERCADO == "6" 
				TRB1->MARKSEC	:= "MUNICIPAL"
			ELSEIF QUERY->Z9_MERCADO == "7" 
				TRB1->MARKSEC	:= "PETROCHEMICAL"
			ELSEIF QUERY->Z9_MERCADO == "8" 
				TRB1->MARKSEC	:= "FOODS"
			ELSEIF QUERY->Z9_MERCADO == "9" 
				TRB1->MARKSEC	:= "OTHERS"
			ENDIF
		else
			IF QUERY->Z9_MERCADO == "1" 
				TRB1->MARKSEC	:= "MINERACAO"
			ELSEIF QUERY->Z9_MERCADO == "2" 
				TRB1->MARKSEC	:= "PAPEL CELULOSE"
			ELSEIF QUERY->Z9_MERCADO == "3" 
				TRB1->MARKSEC	:= "QUIMICA"
			ELSEIF QUERY->Z9_MERCADO == "4" 
				TRB1->MARKSEC	:= "FERTILIZANTES"
			ELSEIF QUERY->Z9_MERCADO == "5" 
				TRB1->MARKSEC	:= "SIDERURGIA"
			ELSEIF QUERY->Z9_MERCADO == "6" 
				TRB1->MARKSEC	:= "MUNICIPAL"
			ELSEIF QUERY->Z9_MERCADO == "7" 
				TRB1->MARKSEC	:= "PETROQUIMICA"
			ELSEIF QUERY->Z9_MERCADO == "8" 
				TRB1->MARKSEC	:= "ALIMENTOS"
			ELSEIF QUERY->Z9_MERCADO == "9" 
				TRB1->MARKSEC	:= "OUTROS"
			ENDIF
		endif
		
		if _cIdioma = 1
			if empty(QUERY->Z9_INDUSTR)
				TRB1->INDUSTR	:= ""
			else
				TRB1->INDUSTR := Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(QUERY->Z9_INDUSTR),"ZZJ_PRODIN")
			endif
		else
			if empty(QUERY->Z9_INDUSTR)
				TRB1->INDUSTR	:= ""
			else
				TRB1->INDUSTR	:= QUERY->Z9_INDUSTR
			endif
		endif
		
		TRB1->SALPER	:= UPPER(QUERY->Z9_RESP)
		TRB1->SALREP	:= UPPER(QUERY->Z9_REPRE)
		TRB1->CODEQ		:= QUERY->Z9_XCOEQ
		
		/***************************/
		cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(QUERY->Z9_NPROP) + "'"
			
		IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

		ProcRegua(QUERY2->(reccount()))
			
		SZF->(dbgotop())
		
		while QUERY2->(!eof())
		
			if _cIdioma = 1
				if empty(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIPIN"))
					cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DIMENS) + " "
				else
					cEQUIPDES += " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIPIN")) + alltrim(QUERY2->ZF_DIMENS) + " "
				endif
			else
				cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DESCRI) + " "
			endif
			
			QUERY2->(dbskip())

		enddo	
	
		TRB1->EQUIPDES	:= alltrim(cEQUIPDES)
		/*********************************/
		
		
		TRB1->DIMENS	:= QUERY->Z9_DIMENS
		TRB1->XDTREG	:= DTOS(QUERY->Z9_DTREG)
		TRB1->DTREG		:= QUERY->Z9_DTREG
		TRB1->FORECL	:= QUERY->Z9_DTPREV
		
		/*******************************/
		if QUERY->Z9_TOTSI > 0
			TRB1->FOREAMM	:= QUERY->Z9_TOTSI
			nXTOTSI := QUERY->Z9_TOTSI
		else
			cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(QUERY->Z9_NPROP) + "'"
			
			IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

			ProcRegua(QUERY2->(reccount()))
			
			SZF->(dbgotop())
		
			while QUERY2->(!eof())

				nXTOTSI 		+= QUERY2->ZF_TOTVSI

				QUERY2->(dbskip())

			enddo	
			TRB1->FOREAMM	:= nXTOTSI
		endif
		
		QUERY2->(dbgotop())
				
		if QUERY->Z9_CUSTOT > 0 
			
			nXCUSTOT 		:= QUERY->Z9_CUSTOT
		else
			while QUERY2->(!eof())

				nXCUSTOT 		+= QUERY2->ZF_TOTVSI-(QUERY2->ZF_TOTVSI*(QUERY2->ZF_MKPFIN/100))

				QUERY2->(dbskip())

			enddo	
			
		endif
		
		/*******************************/
		
		//TRB1->FOREAMM	:= QUERY->Z9_TOTSI
		
		nVCOMIS 		:= nXTOTSI * (QUERY->Z9_PCOMIS/100)
		nCOGS			:= nXCUSTOT - nVCOMIS	
		nVCONTMG		:= nXTOTSI - nCOGS - nVCOMIS
		
		TRB1->COGS		:= nCOGS
		TRB1->VCONTRMG	:= nVCONTMG 
		TRB1->CONTRMG	:= (nVCONTMG / nXTOTSI)*100 
		
		TRB1->COMMISS	:= QUERY->Z9_PCOMIS
		TRB1->VCOMMISS	:= nVCOMIS
		
		TRB1->CFORECL	:= substr(dtoc(QUERY->Z9_DTPREV),4,7)
		TRB1->DFORECL	:= QUERY->Z9_DTPREV

		TRB1->DTEPROP	:= QUERY->Z9_DTEPROP
		TRB1->DTEREAL	:= QUERY->Z9_DTEREAL
		
		TRB1->CLASSIF	:= QUERY->Z9_CLASS
		TRB1->MERCADO	:= QUERY->Z9_MERCADO
		TRB1->TIPO		:= QUERY->Z9_TIPO
		TRB1->STATUS2	:= QUERY->Z9_STATUS
		TRB1->IDRESP	:= QUERY->Z9_IDRESP
		TRB1->CODREP	:= QUERY->Z9_CODREP
		TRB1->XFORECL	:= DTOS(QUERY->Z9_DTPREV)
		
		MsUnlock()

	QUERY->(dbskip())
	
	nXTOTSI		:= 0
	nXCUSTOT	:= 0
	cEQUIPDES	:= ""
enddo

	//************ QUERY STATUS  *******************/

	cTipoSitS:= MV_PAR01 //recebe o resultado da pegunta
	cSitQueryS := ""
	
	For nRegS:=1 to Len(cTipoSitS)
	     cSitQueryS += Subs(cTipoSitS,nRegS,1)
	    
	     If ( nRegS+1 ) <= Len(cTipoSitS)
	          cSitQueryS += "/" 
	     Endif
	Next nRegS   
	 
	cSitQueryS := "(" + cSitQueryS + ")"
	//************ QUERY STATUS CLASSIFICACAO *******************/
	nRegC      := 0
	cTipoSitC:= MV_PAR02 //recebe o resultado da pegunta
	cSitQueryC := ""
	
	For nRegC:=1 to Len(cTipoSitC)
	     cSitQueryC += Subs(cTipoSitC,nRegC,1)
	    
	     If ( nRegC+1 ) <= Len(cTipoSitC)
	          cSitQueryC += "/" 
	     Endif
	Next nRegC   
	 
	cSitQueryC := "(" + cSitQueryC + ")"
	//************ QUERY STATUS MERCADO *******************/
	nRegM      := 0
	cTipoSitM:= MV_PAR03 //recebe o resultado da pegunta
	cSitQueryM := ""
	
	For nRegM:=1 to Len(cTipoSitM)
	     cSitQueryM += Subs(cTipoSitM,nRegM,1)
	    
	     If ( nRegM+1 ) <= Len(cTipoSitM)
	          cSitQueryM += "/" 
	     Endif
	Next nRegM   
	 
	cSitQueryM := "(" + cSitQueryM + ")"
	//************ QUERY STATUS TIPO *******************/
	nRegT      := 0
	cTipoSitT:= MV_PAR04 //recebe o resultado da pegunta
	cSitQueryT := ""
	
	For nRegT:=1 to Len(cTipoSitT)
	     cSitQueryT += Subs(cTipoSitT,nRegT,1)
	    
	     If ( nRegT+1 ) <= Len(cTipoSitT)
	          cSitQueryT += "/" 
	     Endif
	Next nRegT   
	 
	cSitQueryT := "(" + cSitQueryT + ")"
	//**************************************************/
//TRB1->STATUS2  $ '('*'/'*'/'*'/'*'/'*'/'*'/'7')'
	TRB1->(dbclearfil())
	TRB1->(dbGoTop())
	// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
	if MV_PAR05 == 1
		cFiltro := " TRB1->STATUS2  $ '" + cSitQueryS + "' .AND. TRB1->CLASSIF $ '" + cSitQueryC + "' .AND. TRB1->MERCADO $ '" + cSitQueryM + ;
					"' .AND. TRB1->TIPO $ '" + cSitQueryT + ;
					"' .AND. TRB1->XDTREG >= '" + DTOS(MV_PAR06) + "' .AND. TRB1->XDTREG <= '" + DTOS(MV_PAR07)  + ; 
					"' .AND. TRB1->IDRESP >= '" + alltrim(MV_PAR10) + "' .AND. TRB1->IDRESP <= '" + alltrim(MV_PAR11) + ;
					"' .AND. TRB1->CODREP >= '" + alltrim(MV_PAR12) + "' .AND. TRB1->CODREP <= '" + alltrim(MV_PAR13)  + "' "  
	else
		cFiltro := " TRB1->STATUS2  $ '" + cSitQueryS + "' .AND. TRB1->CLASSIF $ '" + cSitQueryC + "' .AND. TRB1->MERCADO $ '" + cSitQueryM + ;
				"' .AND. TRB1->TIPO $ '" + cSitQueryT + ;
				"' .AND. TRB1->XFORECL >= '" + DTOS(MV_PAR08) + "' .AND. TRB1->XFORECL <= '" + DTOS(MV_PAR09) + ;
				"' .AND. TRB1->IDRESP >= '" + alltrim(MV_PAR10) + "' .AND. TRB1->IDRESP <= '" + alltrim(MV_PAR11) + ;
				"' .AND. TRB1->CODREP >= '" + alltrim(MV_PAR12) + "' .AND. TRB1->CODREP <= '" + alltrim(MV_PAR13)  + "' "  
	endif
			 
	TRB1->(dbsetfilter({|| &(cFiltro)} , cFiltro))

TRB1->(dbGoTop())
	
QUERY->(dbclosearea())
QUERY2->(dbclosearea())

return



/**********************************************************/
static Function zFGProp()

	local cFiltro	:= ""
	LOCAL cTipoSitS := ""
	LOCAL cTipoSitC := ""
	LOCAL cTipoSitT := ""
	LOCAL cTipoSitM := ""
	LOCAL nRegS := 0
	LOCAL nRegC := 0
	LOCAL nRegM := 0
	LOCAL nRegT := 0
	
	pergunte(cPerg2,.T.)

	//************ QUERY STATUS  *******************/

	cTipoSitS:= MV_PAR01 //recebe o resultado da pegunta
	cSitQueryS := ""
	
	For nRegS:=1 to Len(cTipoSitS)
	     cSitQueryS += Subs(cTipoSitS,nRegS,1)
	    
	     If ( nRegS+1 ) <= Len(cTipoSitS)
	          cSitQueryS += "/" 
	     Endif
	Next nRegS   
	 
	cSitQueryS := "(" + cSitQueryS + ")"
	//************ QUERY STATUS CLASSIFICACAO *******************/
	nRegC      := 0
	cTipoSitC:= MV_PAR02 //recebe o resultado da pegunta
	cSitQueryC := ""
	
	For nRegC:=1 to Len(cTipoSitC)
	     cSitQueryC += Subs(cTipoSitC,nRegC,1)
	    
	     If ( nRegC+1 ) <= Len(cTipoSitC)
	          cSitQueryC += "/" 
	     Endif
	Next nRegC   
	 
	cSitQueryC := "(" + cSitQueryC + ")"
	//************ QUERY STATUS MERCADO *******************/
	nRegM      := 0
	cTipoSitM:= MV_PAR03 //recebe o resultado da pegunta
	cSitQueryM := ""
	
	For nRegM:=1 to Len(cTipoSitM)
	     cSitQueryM += Subs(cTipoSitM,nRegM,1)
	    
	     If ( nRegM+1 ) <= Len(cTipoSitM)
	          cSitQueryM += "/" 
	     Endif
	Next nRegM   
	 
	cSitQueryM := "(" + cSitQueryM + ")"
	//************ QUERY STATUS TIPO *******************/
	nRegT      := 0
	cTipoSitT:= MV_PAR04 //recebe o resultado da pegunta
	cSitQueryT := ""
	
	For nRegT:=1 to Len(cTipoSitT)
	     cSitQueryT += Subs(cTipoSitT,nRegT,1)
	    
	     If ( nRegT+1 ) <= Len(cTipoSitT)
	          cSitQueryT += "/" 
	     Endif
	Next nRegT   
	 
	cSitQueryT := "(" + cSitQueryT + ")"
	//**************************************************/
//TRB1->STATUS2  $ '('*'/'*'/'*'/'*'/'*'/'*'/'7')'
	TRB1->(dbclearfil())
	TRB1->(dbGoTop())
	// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
	if MV_PAR05 == 1
		cFiltro := " TRB1->STATUS2  $ '" + cSitQueryS + "' .AND. TRB1->CLASSIF $ '" + cSitQueryC + "' .AND. TRB1->MERCADO $ '" + cSitQueryM + ;
					"' .AND. TRB1->TIPO $ '" + cSitQueryT + ;
					"' .AND. TRB1->XDTREG >= '" + DTOS(MV_PAR06) + "' .AND. TRB1->XDTREG <= '" + DTOS(MV_PAR07)  + ; 
					"' .AND. TRB1->IDRESP >= '" + alltrim(MV_PAR10) + "' .AND. TRB1->IDRESP <= '" + alltrim(MV_PAR11) + ;
					"' .AND. TRB1->CODREP >= '" + alltrim(MV_PAR12) + "' .AND. TRB1->CODREP <= '" + alltrim(MV_PAR13)  + "' "  
	else
		cFiltro := " TRB1->STATUS2  $ '" + cSitQueryS + "' .AND. TRB1->CLASSIF $ '" + cSitQueryC + "' .AND. TRB1->MERCADO $ '" + cSitQueryM + ;
				"' .AND. TRB1->TIPO $ '" + cSitQueryT + ;
				"' .AND. TRB1->XFORECL >= '" + DTOS(MV_PAR08) + "' .AND. TRB1->XFORECL <= '" + DTOS(MV_PAR09) + ;
				"' .AND. TRB1->IDRESP >= '" + alltrim(MV_PAR10) + "' .AND. TRB1->IDRESP <= '" + alltrim(MV_PAR11) + ;
				"' .AND. TRB1->CODREP >= '" + alltrim(MV_PAR12) + "' .AND. TRB1->CODREP <= '" + alltrim(MV_PAR13)  + "' "  
	endif
			 
	TRB1->(dbsetfilter({|| &(cFiltro)} , cFiltro))

TRB1->(dbGoTop())
return


//**********************************************************/
static function zLimpFil()

	TRB1->(dbclearfil())
	TRB1->(dbGoTop())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�												   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa detalhamento de propostas   		              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zDetProp()
local _cQuery 		:= ""
Local _cFilSZF 		:= xFilial("SZF")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local QUERY2 		:= ""
Local Contador		:= 0
Local aInd:={}
Local cCondicao
Local bFiltraBrw
Local _cFilSZ9 		:= xFilial("SZF")

LOCAL cTipoSitS := ""
	LOCAL cTipoSitC := ""
	LOCAL cTipoSitT := ""
	LOCAL cTipoSitM := ""
	LOCAL nRegS := 0
	LOCAL nRegC := 0
	LOCAL nRegM := 0
	LOCAL nRegT := 0
	
	//************ QUERY STATUS  *******************/

	cTipoSitS:= MV_PAR01 //recebe o resultado da pegunta
	cSitQueryS := ""
	
	For nRegS:=1 to Len(cTipoSitS)
	     cSitQueryS += Subs(cTipoSitS,nRegS,1)
	    
	     If ( nRegS+1 ) <= Len(cTipoSitS)
	          cSitQueryS += "/" 
	     Endif
	Next nRegS   
	 
	cSitQueryS := "(" + cSitQueryS + ")"
	//************ QUERY STATUS CLASSIFICACAO *******************/
	nRegC      := 0
	cTipoSitC:= MV_PAR02 //recebe o resultado da pegunta
	cSitQueryC := ""
	
	For nRegC:=1 to Len(cTipoSitC)
	     cSitQueryC += Subs(cTipoSitC,nRegC,1)
	    
	     If ( nRegC+1 ) <= Len(cTipoSitC)
	          cSitQueryC += "/" 
	     Endif
	Next nRegC   
	 
	cSitQueryC := "(" + cSitQueryC + ")"
	//************ QUERY STATUS MERCADO *******************/
	nRegM      := 0
	cTipoSitM:= MV_PAR03 //recebe o resultado da pegunta
	cSitQueryM := ""
	
	For nRegM:=1 to Len(cTipoSitM)
	     cSitQueryM += Subs(cTipoSitM,nRegM,1)
	    
	     If ( nRegM+1 ) <= Len(cTipoSitM)
	          cSitQueryM += "/" 
	     Endif
	Next nRegM   
	 
	cSitQueryM := "(" + cSitQueryM + ")"
	//************ QUERY STATUS TIPO *******************/
	nRegT      := 0
	cTipoSitT:= MV_PAR04 //recebe o resultado da pegunta
	cSitQueryT := ""
	
	For nRegT:=1 to Len(cTipoSitT)
	     cSitQueryT += Subs(cTipoSitT,nRegT,1)
	    
	     If ( nRegT+1 ) <= Len(cTipoSitT)
	          cSitQueryT += "/" 
	     Endif
	Next nRegT   
	 
	cSitQueryT := "(" + cSitQueryT + ")"
	//**************************************************/
//TRB1->STATUS2  $ '('*'/'*'/'*'/'*'/'*'/'*'/'7')'
	TRB1->(dbclearfil())
	TRB1->(dbGoTop())
	// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
	if MV_PAR05 == 1
		cFiltro := " QUERY->Z9_STATUS  $ '" + cSitQueryS + "' .AND. QUERY->Z9_CLASS $ '" + cSitQueryC + "' .AND. QUERY->Z9_MERCADO $ '" + cSitQueryM + ;
					"' .AND. QUERY->Z9_TIPO $ '" + cSitQueryT + ;
					"' .AND. QUERY->Z9_DTREG >= '" + DTOS(MV_PAR06) + "' .AND. QUERY->Z9_DTREG <= '" + DTOS(MV_PAR07)  + ; 
					"' .AND. QUERY->Z9_IDRESP >= '" + alltrim(MV_PAR10) + "' .AND. QUERY->Z9_IDRESP <= '" + alltrim(MV_PAR11) + ;
					"' .AND. QUERY->Z9_CODREP >= '" + alltrim(MV_PAR12) + "' .AND. QUERY->Z9_CODREP <= '" + alltrim(MV_PAR13)  + "' "  
	else
		cFiltro := " QUERY->Z9_STATUS  $ '" + cSitQueryS + "' .AND. QUERY->Z9_CLASS $ '" + cSitQueryC + "' .AND. QUERY->Z9_MERCADO $ '" + cSitQueryM + ;
				"' .AND. QUERY->Z9_TIPO $ '" + cSitQueryT + ;
				"' .AND. QUERY->Z9_DTPREV >= '" + DTOS(MV_PAR08) + "' .AND. QUERY->Z9_DTPREV <= '" + DTOS(MV_PAR09) + ;
				"' .AND. QUERY->Z9_IDRESP >= '" + alltrim(MV_PAR10) + "' .AND. QUERY->Z9_IDRESP <= '" + alltrim(MV_PAR11) + ;
				"' .AND. QUERY->Z9_CODREP >= '" + alltrim(MV_PAR12) + "' .AND. QUERY->Z9_CODREP <= '" + alltrim(MV_PAR13)  + "' "  
	endif

ZZI->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SZF",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZF_ITEM",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

//ZZI->(dbgotop())

while QUERY->(!eof())

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZF_NPROP))
		ProcessMessage()

		RecLock("TRB13",.T.)
		TRB13->IDVEND	:= QUERY->ZF_IDVEND
		TRB13->ITEM		:= QUERY->ZF_ITEM
		TRB13->CODPROD	:= QUERY->ZF_CODPROD
		TRB13->DESCRI	:= QUERY->ZF_DESCRI
		TRB13->DIMENS	:= QUERY->ZF_DIMENS
		TRB13->QUANT	:= QUERY->ZF_QUANT
		TRB13->TOTAL	:= QUERY->ZF_TOTVSI-(QUERY->ZF_TOTVSI*(QUERY->ZF_MKPFIN/100))
		TRB13->TOTVSI	:= QUERY->ZF_TOTVSI
		TRB13->MGCONT	:= QUERY->ZF_MKPFIN
		TRB13->NPROP	:= QUERY->ZF_NPROP
		
		
		MsUnlock()

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())


return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaTela �												  ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta a tela de visualizacao do Fluxo Sintetico            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function MontaTela()

Local oChart
Local oDlg
Local aRand := {}

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aSize2   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aInfo2   := { aSize2[ 1 ], aSize2[ 2 ], aSize2[ 3 ], aSize2[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aPosObj2 := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oGetDbSint2
Private _oGetDbSint3
Private _oGetDbSint4
Private _oGetDbSint5
Private _oDlgSint
Private oFolder1

if _cIdioma = 1
	cCadastro = "Booking  " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim))
else
	cCadastro = "Vendas  " + dtoc(FirstDate(_dDataIni)) + " ate " + dtoc(LastDate(_dDataFim))
endif
// Monta aHeader do TRB2
//aadd(aHeader, {"  OK"									,"OK"		,"@BMP"				,01,0,".T."		,"","C","TRB2","OK"})

DEFINE MSDIALOG _oDlgSint ;
TITLE  cCadastro;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

if _cIdioma = 1
	 @ aPosObj2[1,1],aPosObj2[1,2] FOLDER oFolder1 SIZE  aPosObj2[1,4],aPosObj2[1,3]-35 OF _oDlgSint ;
	  	ITEMS "General list of proposals" COLORS 0, 16777215 PIXEL
else
	@ aPosObj2[1,1],aPosObj2[1,2] FOLDER oFolder1 SIZE  aPosObj2[1,4],aPosObj2[1,3]-35 OF _oDlgSint ;
	  	ITEMS "Lista geral de propostas" COLORS 0, 16777215 PIXEL
endif

tGerPro()

_oDlgSint:Refresh()
_oDlgSint:CommitControls() 

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return


/********************************/
/* TELA GERAL DE PROPOSTAS		*/
/********************************/

Static Function tGerPro() 


if _cIdioma = 1
	aadd(aHeader, {"  Proposal Number"						,"NPROP"	,""					,10,0,""		,"","C","TRB1","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK"		,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Status"									,"STATUS"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Fixed / Budget"							,"FXBUD"	,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Feasibility Execution"					,"FEAEXEC"	,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Opportunity Name"						,"OPPNAME"	,""					,30,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Country"								,"COUNTRY"	,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Market Sector"							,"MARKSEC"	,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Industry"								,"INDUSTR"	,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Sales Person"							,"SALPER"	,""					,30,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Sales Representantive"					,"SALREP"	,""					,30,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Equipment Description"					,"EQUIPDES"	,""					,30,0,""		,"","C","TRB1",""})
	//aadd(aHeader, {"Dimensions"								,"DIMENS"	,""					,20,0,""		,"","C","TRB1",""})
	//aadd(aHeader, {"Forecast Close"							,"FORECL"	,""					,08,0,""		,"","D","TRB1","R"})
	//aadd(aHeader, {"Registration Date"						,"XDTREG"	,""					,08,0,""		,"","C","TRB1","R"})
	aadd(aHeader, {"Registration Date"						,"DTREG"	,""					,08,0,""		,"","D","TRB1","R"})
	aadd(aHeader, {"Forecast Close"							,"CFORECL"	,""					,07,0,""		,"","C","TRB1","R"})
	aadd(aHeader, {"Proposed Delivery"						,"DTEPROP"	,""					,08,0,""		,"","D","TRB1","R"})
	aadd(aHeader, {"Actual Prop.Delivery"					,"DTEREAL"	,""					,08,0,""		,"","D","TRB1","R"})
	aadd(aHeader, {"Forecast Amount"						,"FOREAMM"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Contrib. Margin"						,"CONTRMG"	,"@E 999.99"		,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Contrib. Margin"						,"VCONTRMG"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Cogs"									,"COGS"		,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Commission"							,"COMMISS"	,"@E 999.99"		,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Commission"								,"VCOMMISS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL1"	,""					,7,0,""			,"","C","TRB1",""})
	
else
	aadd(aHeader, {"  Numero Proposta"						,"NPROP"	,""					,10,0,""		,"","C","TRB1","Proposal Number"})
	//aadd(aHeader, {"Vendas"									,"BOOK"		,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Status"									,"STATUS"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Firme / Estimativa"						,"FXBUD"	,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Viabilidade / Execucao"					,"FEAEXEC"	,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Oportunidade"							,"OPPNAME"	,""					,30,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Pais"									,"COUNTRY"	,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Mercado"								,"MARKSEC"	,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Produto"								,"INDUSTR"	,""					,15,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Responsavel"							,"SALPER"	,""					,30,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Representante Vendas"					,"SALREP"	,""					,30,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Equipamento"							,"EQUIPDES"	,""					,30,0,""		,"","C","TRB1",""})
	//aadd(aHeader, {"Dimens�es"								,"DIMENS"	,""					,20,0,""		,"","C","TRB1",""})
	//aadd(aHeader, {"Prev. Venda"							,"FORECL"	,""					,08,0,""		,"","D","TRB1","R"})
	aadd(aHeader, {"Data Registro"							,"DTREG"	,""					,08,0,""		,"","D","TRB1","R"})
	//aadd(aHeader, {"Data Registro"							,"XDTREG"	,""					,08,0,""		,"","D","TRB1","R"})
	aadd(aHeader, {"Prev. Venda"							,"CFORECL"	,""					,07,0,""		,"","C","TRB1","R"})
	aadd(aHeader, {"Entrega Proposta"						,"DTEPROP"	,""					,08,0,""		,"","D","TRB1","R"})
	aadd(aHeader, {"Entrega Real Prop."						,"DTREG"	,""					,08,0,""		,"","D","TRB1","R"})
	aadd(aHeader, {"Venda s/ Trib."							,"FOREAMM"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Margem Contrib."						,"CONTRMG"	,"@E 999.99"		,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Margem Contrib."						,"VCONTRMG"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Cogs"									,"COGS"		,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Comissao"								,"COMMISS"	,"@E 999.99"		,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Comissao"								,"VCOMMISS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL1"	,""					,7,0,""			,"","C","TRB1",""})
	//aadd(aHeader, {"Forecast Close"							,"DFORECL1"	,""					,08,0,""		,"","D","TRB1","R"})
endif

@ 005 , 0010 BUTTON 'Filtro'   		  Size 60, 12 action(zFGProp()) of oFolder1:aDialogs[1] Pixel  
@ 005 , 0080 BUTTON 'Limpar Filtro'   Size 60, 12 action(zLimpFil()) of oFolder1:aDialogs[1] Pixel 
@ 005 , 0150 BUTTON 'Exportar Excel'   Size 60, 12 action(zExpLPro()) of oFolder1:aDialogs[1] Pixel 


_oGetDbSint := MsGetDb():New(aPosObj[1,1]-13,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB1",,,,oFolder1:aDialogs[1])

_oGetDbSint:oBrowse:BlDblClick := {|| EditTRB1() }


//aadd(aButton , { "BMPTABLE3" , { || zAtualizar()}, "Reprocessar Booking " } )
//aadd(aButton , { "BMPTABLE3" , { || zExpComiss()}, "Export.Excel " } )
//aadd(aButton , { "BMPTABLE3" , { || ShowAnalit()}, "Geral " } )
//aadd(aButton , { "BMPTABLE3" , { || zTotalMPP()}, "No.Prop.MKP " } )
//aadd(aButton , { "BMPTABLE3" , { || zTotalBBR()}, "No.Booking BR/SA/Total " } )
//aadd(aButton , { "BMPTABLE3" , { || zTotalTVD()}, "No.Prop.Vendidas/Activas/Perdidas " } )
//aadd(aButton , { "BMPTABLE3" , { || zPrnGSAL()}, "Imp.Graf.1 " } )

_oGetDbSint:ForceRefresh()
return

//**********************************************************/

Static Function zExpLPro()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'Booking.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
    Local nX1		:= 1 
   
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
    
      
    //Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    
    /*************** TRB2 ****************/  
    //"Booking - " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim))
    if _cIdioma == 1
	    cTabela 	:= "General list of proposals"
	    cPasta		:= "General list of proposals " 
	 
	    cNPROP		:= "Proposal Number"			// 1
	    cSTATUS		:= "Status"						// 2
	    cFXBUD		:= "Fixed / Budget"				// 3
	    cFEAEXEC	:= "Feasibility / Execution"	// 4
	    cOPPNAME	:= "Opportunity Name"			// 5
	    cCOUNTRY	:= "Country"					// 6
	    cMARKSEC	:= "Market Sector"				// 7
	    cINDUSTR	:= "Industry"					// 8
	    cSALPER		:= "Sales Person"				// 9
	    cSALREP		:= "Sales Representative"		// 10
	    cEQUIPDES	:= "Equipment Description"		// 11
	    //cDIMENS		:= "Dimensions"
		cDTREG		:= "Registration Date"			// 12
	    cFORECL		:= "Forecast Close"				// 13
		cDTEPROP	:= "Proposed Delivery"			// 14
		cDTEREAL	:= "Actual Prop.Delivery"		// 15	
	    cFOREAMM	:= "Forecast Amount"			// 16
	    cCONTRMG	:= "% Contrib.Margin"			// 17
	    cVCONTMG	:= "Contrib.Margin"				// 18
	    cCOGS		:= "COGS"						// 19
	    cCOMISS		:= "% Commission"				// 20
	    cVCOMISS	:= "Commission"					// 21
		
	    //cPGET		:= "% Get"						// 20
	    //cPGO		:= "% Go"						// 21
	    //cSALAMOU	:= "Sales Phase Amount"			// 22
	    //cSALCONT	:= "Sales Phase Contribution"	// 23
	
	else
		cTabela := "Lista geral de propostas" 
	    cPasta	:= "Lista geral de propostas" 
	    
	    
	    cNPROP		:= "Numero Proposta"		// 1
	    cSTATUS		:= "Status"					// 2
	    cFXBUD		:= "Fixed / Budget"			// 3
	    cFEAEXEC	:= "Viabilidade / Execucao" // 4
	    cOPPNAME	:= "Oportunidade"			// 5
	    cCOUNTRY	:= "Pais"					// 6
	    cMARKSEC	:= "Mercado"				// 7
	    cINDUSTR	:= "Produto"				// 8
	    cSALPER		:= "Responsavel"			// 9
	    cSALREP		:= "Representante Vendas"	// 10
	    cEQUIPDES	:= "Equipamento"			// 11
	    //cDIMENS		:= "Dimens�es"				// 12
		cDTREG		:= "Data Registro"			// 12
	    cFORECL		:= "Prev.Venda"				// 13
		cDTEPROP	:= "Entrega Proposta"		// 14
		cDTEREAL	:= "Entrega Real Prop."		// 15
	    cFOREAMM	:= "Venda s/ Trib."			// 16
	    cCONTRMG	:= "% Margem Contrib."		// 17
	    cVCONTMG	:= "Margem Contrib."		// 18
	    cCOGS		:= "COGS"					// 19
	    cCOMISS		:= "% Comissao"				// 20
	    cVCOMISS	:= "Comissao"				// 21

	    //cPGET		:= "% Get"					// 21
	    //cPGO		:= "% Go"					// 22
	    //cSALAMOU	:= "Montante Vendas"		// 23
	    //cSALCONT	:= "Montante Contrib."		// 24
	endif
	
	 /*************** TRB1 - Lista geral de propostas ****************/   
	
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cNPROP)			// 1
        aAdd(aColunas, cSTATUS)			// 2				
        aAdd(aColunas, cFXBUD)			// 3								
        aAdd(aColunas, cFEAEXEC)		// 4				
        aAdd(aColunas, cOPPNAME)		// 5
        aAdd(aColunas, cCOUNTRY)		// 6	
        aAdd(aColunas, cMARKSEC)		// 7
        aAdd(aColunas, cINDUSTR)		// 8
        aAdd(aColunas, cSALPER)			// 9
        aAdd(aColunas, cSALREP)			// 10
        aAdd(aColunas, cEQUIPDES)		// 11
        //aAdd(aColunas, cDIMENS)		// 11
		aAdd(aColunas, cDTREG)			// 12
        aAdd(aColunas, cFORECL)			// 13
		aAdd(aColunas, cDTEPROP)		// 14
		aAdd(aColunas, cDTEREAL)		// 15

        aAdd(aColunas, cFOREAMM)		// 16	
        aAdd(aColunas, cCONTRMG)		// 17	
        aAdd(aColunas, cVCONTMG)		// 18
        aAdd(aColunas, cCOGS)			// 19  	
        aAdd(aColunas, cCOMISS)			// 20
        aAdd(aColunas, cVCOMISS)		// 21
           
        oFWMsExcel:AddColumn(cTabela,cPasta, cNPROP,1,2)					// 1 numero proposta						
        oFWMsExcel:AddColumn(cTabela,cPasta, cSTATUS,1,2)					// 2 status			
        oFWMsExcel:AddColumn(cTabela,cPasta, cFXBUD,1,2)					// 3 fixed / budget		
        oFWMsExcel:AddColumn(cTabela,cPasta, cFEAEXEC,1,2)					// 4 viabilidade / execu��o
        oFWMsExcel:AddColumn(cTabela,cPasta, cOPPNAME,1,2)					// 5 oportunidade
        oFWMsExcel:AddColumn(cTabela,cPasta, cCOUNTRY,1,2)					// 6 pais
        oFWMsExcel:AddColumn(cTabela,cPasta, cMARKSEC,1,2)					// 7 mercado
        
        oFWMsExcel:AddColumn(cTabela,cPasta, cINDUSTR,1,2)					// 8 produto
        oFWMsExcel:AddColumn(cTabela,cPasta, cSALPER,1,2)					// 9 responsavel
        oFWMsExcel:AddColumn(cTabela,cPasta, cSALREP,1,2)					// 9 responsavel
        oFWMsExcel:AddColumn(cTabela,cPasta, cEQUIPDES,1,2)					// 10 equipamento
        
        //oFWMsExcel:AddColumn(cTabela,cPasta, cDIMENS,1,2)					// 11 dimensoes	
		oFWMsExcel:AddColumn(cTabela,cPasta, cDTREG,1,2)					// 12 data registro		
        oFWMsExcel:AddColumn(cTabela,cPasta, cFORECL,1,2)					// 13 previsao venda
		oFWMsExcel:AddColumn(cTabela,cPasta, cDTEPROP,1,2)					// 14 entrega proposta
		oFWMsExcel:AddColumn(cTabela,cPasta, cDTEREAL,1,2)					// 15 entrega real proposta

        oFWMsExcel:AddColumn(cTabela,cPasta, cFOREAMM,1,2)					// 16 venda s/ tributos
        oFWMsExcel:AddColumn(cTabela,cPasta, cCONTRMG,1,2)					// 17 % margem contrib.
        oFWMsExcel:AddColumn(cTabela,cPasta, cVCONTMG,1,2)					// 18 margem contrib.
        
        oFWMsExcel:AddColumn(cTabela,cPasta, cCOGS,1,2)						// 19 cogs
        oFWMsExcel:AddColumn(cTabela,cPasta, cCOMISS,1,2)					// 20 % comissao
        oFWMsExcel:AddColumn(cTabela,cPasta, cVCOMISS,1,2)					// 21 comissao
                
  
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB1->(dbgotop())
	                            
        While  !(TRB1->(EoF()))
        
        	//RptStatus({|| fExTRB1()}, "Aguarde...", "Executando rotina...")
         
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB1->NPROP
        	aLinhaAux[2] := TRB1->STATUS
        	aLinhaAux[3] := TRB1->FXBUD
        	aLinhaAux[4] := TRB1->FEAEXEC
        	aLinhaAux[5] := TRB1->OPPNAME
        	aLinhaAux[6] := TRB1->COUNTRY
        	
        	aLinhaAux[7] := TRB1->MARKSEC
        	aLinhaAux[8] := TRB1->INDUSTR
        	aLinhaAux[9] := TRB1->SALPER
        	aLinhaAux[10] := TRB1->SALREP
        	
        	aLinhaAux[11] := TRB1->EQUIPDES
        	//aLinhaAux[12] := TRB1->DIMENS
			aLinhaAux[12] := TRB1->DTREG
        	aLinhaAux[13] := TRB1->CFORECL
			aLinhaAux[14] := TRB1->DTEPROP
			aLinhaAux[15] := TRB1->DTEREAL
        	aLinhaAux[16] := TRB1->FOREAMM
        	
        	aLinhaAux[17] := TRB1->CONTRMG
        	aLinhaAux[18] := TRB1->VCONTRMG
        	aLinhaAux[19] := TRB1->COGS
        	
        	aLinhaAux[20] := TRB1->COMMISS
        	aLinhaAux[21] := TRB1->VCOMMISS	
	        
    
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
	 
        	
            TRB1->(DbSkip())

        EndDo

        TRB1->(dbgotop())
     
    
    
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return


Static Function fExTRB1()
    Local aArea  := GetArea()
    Local nAtual := 0
    Local nTotal := 0
      
    //Executa a consulta
    
      
    //Conta quantos registros existem, e seta no tamanho da r�gua
    Count To nTotal
    SetRegua(nTotal)
      
    //Percorre todos os registros da query
    TRB1->(DbGoTop())
    While ! TRB1->(EoF())
          
        //Incrementa a mensagem na r�gua
        nAtual++
        IncRegua()
          
        TRB1->(DbSkip())
    EndDo
    TRB1->(DbCloseArea())
      
    RestArea(aArea)
Return

/*********************************************************/

Static function zAtualizar()

	pergunte(cPerg,.T.)
	
		
		
	DbSelectArea("TRB1")
	TRB1->(dbgotop())
	zap
	MSAguarde({|| zNPROPGER()},"General list of proposals")
	TRB1->(dbgotop())
	
	DbSelectArea("TRB13")
	TRB13->(dbgotop())
	zap
	MSAguarde({||zDetProp()},"Proposals Details")
	TRB13->(dbgotop())
	
	_oDlgSint:Refresh()
	
Return nil



/******************************************************/
Static Function EditTRB1()
    Local aArea       := GetArea()
    Local aAreaSZ9    := SZ9->(GetArea())
    Local nOpcao1      := 0
    Local cItemZ9	  := alltrim(TRB1->NPROP)
   
    Private cCadastro 
 
   	cCadastro := "Alteracao Proposta"
    
	DbSelectArea("SZ9")
	SZ9->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	SZ9->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If SZ9->(DbSeek(xFilial('SZ9')+cItemZ9))
	    	
	        nOpcao1 := fAltTRB1()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	     
	        EndIf
	       
	EndIf
	
    RestArea(aAreaSZ9)
    RestArea(aArea)
Return

/***********************************/

static Function fAltTRB1()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= alltrim(SZ9->Z9_NPROP)
Local oGet2
Local cGet2 	:= SZ9->Z9_CLASS
Local oGet3
Local cGet3		:= SZ9->Z9_MERCADO
Local oGet4	
Local cGet4		:= SZ9->Z9_INDUSTR
Local oGet5	
Local cGet5		:= SZ9->Z9_TIPO
Local oComboBx1      
Local cComboBx1	:= {"","1 - General","2 - Marketing Platform","3 - Booking"}
Local oGet6	
Local cGet6		:= SZ9->Z9_BOOK
Local oComboBx2      
Local cComboBx2	:= {"","1 - Viabilidade","2 - Execucao"}
Local oGet7	
Local cGet7		:= SZ9->Z9_VIAEXEC
Local oGet8	
Local cGet8		:= SZ9->Z9_IDCONTR
Local oGet9	
Local cGet9		:= Posicione("SA1",1,xFilial("SA1") + SZ9->Z9_IDCONTR, "A1_NREDUZ")
Local oGet10
Local cGet10	:= SZ9->Z9_IDCLFIN
Local oGet11	
Local cGet11	:= Posicione("SA1",1,xFilial("SA1") + SZ9->Z9_IDCONTR, "A1_NREDUZ")
Local oGet12	
Local cGet12	:= SZ9->Z9_XCOEQ
Local oGet13	
Local cGet13	:= SZ9->Z9_XEQUIP
Local oGet14	
Local cGet14	:= SZ9->Z9_DIMENS
Local oGet15
Local cGet15	:= SZ9->Z9_DTREG
Local oGet16	
Local cGet16	:= SZ9->Z9_DTEPROP
Local oGet17	
Local cGet17	:= SZ9->Z9_DTEREAL
Local oGet18	
Local cGet18	:= SZ9->Z9_DTPREV
Local oGet19	
Local cGet19	:= SZ9->Z9_IDELAB
Local oGet20	
Local cGet20	:= POSICIONE("SZL",1,XFILIAL("SZL")+SZ9->Z9_IDELAB,"ZL_NOME")                                            
Local oGet21	
Local cGet21	:= SZ9->Z9_IDRESP
Local oGet22	
Local cGet22	:= POSICIONE("SZL",1,XFILIAL("SZL")+SZ9->Z9_IDRESP,"ZL_NOME")                                            
Local oGet23	
Local cGet23	:= SZ9->Z9_CODPAIS
Local oGet24	
Local cGet24	:= POSICIONE("SYA",1,XFILIAL("SYA")+SZ9->Z9_CODPAIS,"YA_DESCR")                                          
Local oGet25	
Local cGet25	:= SZ9->Z9_CODREP
Local oGet26	
Local cGet26	:= POSICIONE("SA3",1,XFILIAL("SA3")+SZ9->Z9_CODREP,"A3_NOME")                                            
Local oGet27	
Local cGet27	:= SZ9->Z9_LOCAL
Local oGet28	
Local cGet28	:= SZ9->Z9_PROJETO
Local oGet29	
Local cGet29	:= Alltrim(SZ9->Z9_STATUS)
Local oComboBx3   
Local cComboBx3	:= {"","1 - Ativa","2 - Cancelada","3 - Declinada","4 - Nao Enviada","5 - Perdida","6 - SLC","7 - Vendida"}
Local oGet30	
Local cGet30	:= SZ9->Z9_PCONT
Local oGet31	
Local cGet31	:= SZ9->Z9_CUSFIN
Local oGet32	
Local cGet32	:= SZ9->Z9_FIANCAS
Local oGet33	
Local cGet33	:= SZ9->Z9_PROVGAR
Local oGet34
Local cGet34	:= SZ9->Z9_PERDIMP
Local oGet35	
Local cGet35	:= SZ9->Z9_PROYALT
Local oGet36	
Local cGet36	:= SZ9->Z9_PCOMIS
Local oGet37	
Local cGet37	:= SZ9->Z9_CUSTPR
Local oGet38	
Local cGet38	:= SZ9->Z9_CUSTOT
Local oGet39	
Local cGet39	:= SZ9->Z9_TOTSI
Local oGet40	
Local cGet40	:= SZ9->Z9_TOTCI

Local cClass
Local cMerc
Local cTipo
Local cViaExec

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
Local nTotReg := 0

//Local _nOpcao := 1
local cFor2 		:= ""
Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0
Local nXTOTSI		:= 0
Local nXCUSTOT		:= 0
Local cEQUIPDES		:= ""

local cFiltra 	:= ""



private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

Private _oGetDbAnalit
//Private _oDlg
Private _nOpc

Static _oDlg

	cQuery := " SELECT * FROM SZF010 WHERE ZF_NPROP = '" + cGet1 + "' AND D_E_L_E_T_ <> '*' AND ZF_UNIT > 0 AND ZF_TOTAL > 0 AND ZF_TOTVSI > 0 AND ZF_TOTVCI > 0 "
    TCQuery cQuery New Alias "TSZF"
        
    Count To nTotReg
    TSZF->(DbGoTop()) 

/****************SZF - DETALHES *****/

SZF->(dbsetorder(3)) 

ChkFile("SZF",.F.,"QUERY2") 

/*************************************/

if cGet2 = "1"
	cClass := cGet2 + " - " + "Equipamento"
elseif cGet2 = "2"
	cClass := cGet2 + " - " + "Assistencia Tecnica"
elseif cGet2 = "3"
	cClass := cGet2 + " - " + "Peca"
elseif cGet2 = "4"
	cClass := cGet2 + " - " + "Sistema"
elseif cGet2 = "5"
	cClass := cGet2 + " - " + "Engenharia"
endif

if cGet3 = "1"
	cMerc := cGet3 + " - " + "Mineracao"
elseif cGet3 = "2"
	cMerc := cGet3 + " - " + "Papel e Celulose"
elseif cGet3 = "3"
	cMerc := cGet3 + " - " + "Quimica"
elseif cGet3 = "4"
	cMerc := cGet3 + " - " + "Fertilizantes"
elseif cGet3 = "5"
	cMerc := cGet3 + " - " + "Siderurgia"
elseif cGet3 = "6"
	cMerc := cGet3 + " - " + "Municipal"
elseif cGet3 = "7"
	cMerc := cGet3 + " - " + "Petroquimica"
elseif cGet3 = "8"
	cMerc := cGet3 + " - " + "Alimentos"
elseif cGet3 = "9"
	cMerc := cGet3 + " - " + "Outros"
endif

if cGet5 = "1"
	cTipo := cGet5 + " - " + "Firme"
elseif cGet5 = "2"
	cTipo := cGet5 + " - " + "Estimativa"
elseif cGet5 = "3"
	cTipo := cGet5 + " - " + "Prospeccao"
endif

if cGet6 = "1"
	oComboBx1 := cGet6 + " - " + "General"
elseif cGet6 = "2"
	oComboBx1 := cGet6 + " - " + "Marketing Platform"
elseif cGet6 = "3"
	oComboBx1 := cGet6 + " - " + "Booking"
else
	oComboBx1 := ""
endif

if cGet7 = "1"
	oComboBx2 := cGet7 + " - " + "Viabilidade"
elseif cGet7 = "2"
	oComboBx2 := cGet7 + " - " + "Execucao"
else
	oComboBx2 := ""
endif

if cGet29 = "1"
	oComboBx3 := cGet29 + " - " + "Ativa"
elseif cGet29 = "2"
	oComboBx3 := cGet29 + " - " + "Cancelada"
elseif cGet29 = "3"
	oComboBx3 := cGet29 + " - " + "Declinada"
elseif cGet29 = "4"
	oComboBx3 := cGet29 + " - " + "Nao Enviada"
elseif cGet29 = "5"
	oComboBx3 := cGet29 + " - " + "Perdida"
elseif cGet29 = "6"
	oComboBx3 := cGet29 + " - " + "SLC"
elseif cGet29 = "7"
	oComboBx3 := cGet29 + " - " + "Vendida"
else
	oComboBx3 := ""
endif

  DbSelectArea("SZF")
  SZF->(DbSetOrder(4)) //B1_FILIAL + B1_COD
  SZF->(DbGoTop())
  
  aadd(aHeader, {" ID Op.Unit"								,"IDVEND"			,""					,09,0,""		,"","C","TRB13",""})
  aadd(aHeader, {"Item"										,"ITEM"				,""					,09,0,""		,"","C","TRB13",""})
  aadd(aHeader, {"Descricao"								,"DESCRI"			,""					,40,0,""		,"","C","TRB13",""})
  aadd(aHeader, {"Dimensoes"								,"DIMENS"			,""					,30,0,""		,"","C","TRB13",""})
  aadd(aHeader, {"Quantidade"								,"QUANT"			,"@E 999,999,999.99",15,2,""		,"","N","TRB13",""})
  //aadd(aHeader, {"Total"									,"TOTAL"			,"@E 999,999,999.99",15,2,""		,"","N","TRB13",""})
  aadd(aHeader, {"Venda s/ Trib."							,"TOTVSI"			,"@E 999,999,999.99",15,2,""		,"","N","TRB13",""})
  aadd(aHeader, {"Margem Contribuicao"						,"MGCONT"			,"@E 999,999,999.99",15,2,""		,"","N","TRB13",""})
  aadd(aHeader, {"No.Proposta"								,"NPROP"			,""					,13,0,""		,"","C","TRB13",""})

  // Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
  cFiltra := " alltrim(NPROP) == '" + alltrim(cGet1) + "'"
  TRB13->(dbsetfilter({|| &(cFiltra)} , cFiltra))

  DEFINE MSDIALOG _oDlg TITLE "Detalhes Proposta (1)" FROM  aSize[7],0 to aSize[6],aSize[5] COLORS 0, 16777215 of oMainWnd PIXEL
  //DEFINE MSDIALOG _oDlgAnalit TITLE "xx" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
  
  _oGetDbAnalit := MsGetDb():New(aPosObj[1,1]+220,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB13")
  
  if cGet29 = "7"
  		msginfo("Registro nao pode ser editado.")
  else
  		_oGetDbAnalit:oBrowse:BlDblClick := {|| EditSZF() }
  endif
  
  oGroup1:= TGroup():New(0005,0005,0035,0605,'',_oDlg,,,.T.)
  oGroup2:= TGroup():New(0040,0005,0070,0605,'',_oDlg,,,.T.)
  oGroup3:= TGroup():New(0075,0005,0105,0605,'',_oDlg,,,.T.)
  oGroup4:= TGroup():New(0110,0005,0140,0605,'',_oDlg,,,.T.)
  oGroup5:= TGroup():New(0145,0005,0175,0605,'',_oDlg,,,.T.)
  oGroup6:= TGroup():New(0180,0005,0210,0605,'',_oDlg,,,.T.)
  oGroup7:= TGroup():New(0215,0005,0245,0505,'',_oDlg,,,.T.)
        
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "Numro Proposta" 	SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 007, 063 SAY oSay2 PROMPT "Classificacao" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cClass   When .F. SIZE 072, 010 	COLORS 0, 16777215 PIXEL
    
    @ 007, 145 SAY oSay3 PROMPT "Mercado" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
    @ 016, 142 MSGET oGet3 VAR cMerc   When .F. SIZE 072, 010 	COLORS 0, 16777215 PIXEL
    
    @ 007, 225 SAY oSay4 PROMPT "Prod.Final"  SIZE 062, 007  COLORS 0, 16777215 PIXEL
    @ 016, 222 MSGET oGet4 VAR cGet4  Picture "@!" Pixel F3 "ZZJ" SIZE 048, 010 COLORS 0, 16777215 PIXEL
    
    @ 007, 295 SAY oSay5 PROMPT "Tipo" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
    @ 016, 292 MSGET oGet5 VAR cTipo   When .F. SIZE 062, 010 	COLORS 0, 16777215 PIXEL
    
    if cGet29 = "7"
	    @ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
	    @ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .F. SIZE 062, 010 	COLORS 0, 16777215 PIXEL
    
	    //@ 007, 435 SAY oSay7 PROMPT "Viabilidade/Execucao" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
	    //@ 016, 432 ComboBox oComboBx2 Items cComboBx2   When .F. SIZE 062, 010 	COLORS 0, 16777215 PIXEL
	    
	    @ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
	    @ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .F. SIZE 062, 010 	COLORS 0, 16777215 PIXEL
	    /*********************************/
	    @ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 PIXEL
		@ 051, 010 MSGET oGet8 VAR cGet8 When .F.  SIZE 048, 010 COLORS 0, 16777215 PIXEL
	
	    @ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	    @ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 PIXEL
    
	    @ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 PIXEL
		@ 051, 285 MSGET oGet10 VAR cGet10 When .F.  SIZE 048, 010 COLORS 0, 16777215 PIXEL
		
		@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	    @ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 230, 010  COLORS 0, 16777215 PIXEL
	    
	 	/********************************/    
	    @ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 PIXEL
	    @ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 PIXEL
	    @ 085, 071 MSGET oGet16 VAR cGet16 When .F. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 PIXEL
	    @ 085, 131 MSGET oGet17 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 PIXEL
	    @ 085, 191 MSGET oGet18 VAR cGet18 When .F. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	    
	    /*********************************/
	    @ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 PIXEL
		@ 121, 010 MSGET oGet19 VAR cGet19  When .F. SIZE 048, 010 COLORS 0, 16777215 PIXEL
		
		@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 PIXEL
	    @ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 PIXEL
		@ 121, 270 MSGET oGet21 VAR cGet21  When .F. SIZE 048, 010 COLORS 0, 16777215 PIXEL
		
		@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	    @ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 PIXEL
	    /*******************************/
	    @ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 PIXEL
		@ 157, 010 MSGET oGet23 VAR cGet23  When .F. SIZE 048, 010 COLORS 0, 16777215 PIXEL
		
		@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	    @ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 PIXEL
		@ 157, 247 MSGET oGet25 VAR cGet25  When .F. SIZE 048, 010 COLORS 0, 16777215 PIXEL
		
		@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 PIXEL
	    @ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 PIXEL
	    
	    /********************************/
	    @ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 PIXEL
	    @ 193, 010 MSGET oGet27 VAR cGet27 When .F. SIZE 210, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 PIXEL
	    @ 193, 230 MSGET oGet28 VAR cGet28 When .F. SIZE 260, 010  COLORS 0, 16777215 PIXEL
	        
	else
		@ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
	    @ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .T. SIZE 062, 010 	COLORS 0, 16777215 PIXEL
    
	    //@ 007, 435 SAY oSay7 PROMPT "Viabilidade/Execucao" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
	    //@ 016, 432 ComboBox oComboBx2 Items cComboBx2   When .T. SIZE 062, 010 	COLORS 0, 16777215 PIXEL
    
	    @ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
	    @ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .T. SIZE 062, 010 	COLORS 0, 16777215 PIXEL
    
	    /********************************/
	    @ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 PIXEL
		@ 051, 010 MSGET oGet8 VAR cGet8 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 PIXEL
	
	    @ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	    @ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 PIXEL
    
	    @ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 PIXEL
		@ 051, 285 MSGET oGet10 VAR cGet10 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 PIXEL
		
		@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	    @ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 210, 010  COLORS 0, 16777215 PIXEL
	    
	    /******************************/
	    
	    @ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 PIXEL
	    @ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 PIXEL
	    @ 085, 071 MSGET oGet16 VAR cGet16 When .T. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 PIXEL
	    @ 085, 131 MSGET oGet17 VAR cGet15 When .T. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 PIXEL
	    @ 085, 191 MSGET oGet18 VAR cGet18 When .T. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	    
	    /***************************/
	    @ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 PIXEL
		@ 121, 010 MSGET oGet19 VAR cGet19 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 PIXEL
		
		@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 PIXEL
	    @ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 PIXEL
		@ 121, 270 MSGET oGet21 VAR cGet21 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 PIXEL
		
		@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	    @ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 PIXEL
	    /**************************/
	    @ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 PIXEL
		@ 157, 010 MSGET oGet23 VAR cGet23 Picture "@!" Pixel F3 "SYA_2" SIZE 048, 010 COLORS 0, 16777215 PIXEL
		
		@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	    @ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 PIXEL
	    
	    @ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 PIXEL
		@ 157, 247 MSGET oGet25 VAR cGet25 Picture "@!" Pixel F3 "SA3" SIZE 048, 010 COLORS 0, 16777215 PIXEL
		
		@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 PIXEL
	    @ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 PIXEL  
	    /***************************/
	    @ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 PIXEL
	    @ 193, 010 MSGET oGet27 VAR cGet27 When .T. SIZE 210, 010  COLORS 0, 16777215 PIXEL 
	    @ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 PIXEL
	    @ 193, 230 MSGET oGet28 VAR cGet28 When .T. SIZE 260, 010  COLORS 0, 16777215 PIXEL
	    
	endif
   
    if nTotReg > 0
	    @ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 150 SAY oSay32 PROMPT "% Fiancas" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	//@ 254, 010 SAY oSay38 PROMPT "Custo de Total" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	//@ 263, 010 MSGET oGet38 VAR cGet38 PICTURE PesqPict("SZ9","Z9_CUSTOT") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	//@ 254, 080 SAY oSay39 PROMPT "Venda s/ Tributos" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	//@ 263, 080 MSGET oGet39 VAR cGet39 PICTURE PesqPict("SZ9","Z9_TOTCI") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
   	
    else
    	@ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .T. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .T. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 150 SAY oSay32 PROMPT "% Fiancas" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .T. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .T. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .T. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .T. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .T. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	//@ 254, 010 SAY oSay38 PROMPT "Custo de Total" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	//@ 263, 010 MSGET oGet38 VAR cGet38 PICTURE PesqPict("SZ9","Z9_CUSTOT") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	   	//@ 254, 080 SAY oSay39 PROMPT "Venda s/ Tributos" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	   	//@ 263, 080 MSGET oGet39 VAR cGet39 PICTURE PesqPict("SZ9","Z9_TOTCI") When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	endif
	
    @ aPosObj[2,1]+5 ,005 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 070, 015  PIXEL
    @ aPosObj[2,1]+5 ,105 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 070, 015  PIXEL
  
  //msginfo(cValToChar(_nOpc))
  
  ACTIVATE MSDIALOG _oDlg CENTERED
  
  If _nOpc = 1
  	Reclock("SZ9",.F.)
  		SZ9->Z9_BOOK	 	:= SUBSTR(oComboBx1,1,1)
  		//SZ9->Z9_VIAEXEC		:= SUBSTR(oComboBx2,1,1)
  		SZ9->Z9_INDUSTR		:= cGet4 
  		SZ9->Z9_IDCONTR		:= cGet8
  		SZ9->Z9_CONTR		:= cGet9
  		SZ9->Z9_IDCLFIN		:= cGet10
  		SZ9->Z9_CLIFIN		:= cGet11
  		//SZ9->Z9_XCOEQ		:= cGet12
  		//SZ9->Z9_XEQUIP		:= cGet13
  		//SZ9->Z9_DIMENS		:= cGet14
  		SZ9->Z9_DTREG		:= cGet15
  		SZ9->Z9_DTEPROP		:= cGet16
  		SZ9->Z9_DTEREAL		:= cGet17
  		SZ9->Z9_DTPREV		:= cGet18
  		SZ9->Z9_IDELAB		:= cGet19
  		SZ9->Z9_RESPELA		:= cGet20
  		SZ9->Z9_IDRESP		:= cGet21
  		SZ9->Z9_RESP		:= cGet22
  		SZ9->Z9_CODPAIS		:= cGet23
  		SZ9->Z9_PAIS		:= cGet24
  		SZ9->Z9_CODREP		:= cGet25
  		SZ9->Z9_REPRE		:= cGet26
  		SZ9->Z9_LOCAL		:= cGet27
  		SZ9->Z9_PROJETO		:= cGet28
  		SZ9->Z9_STATUS		:= SUBSTR(oComboBx3,1,1)
  		SZ9->Z9_PCONT		:= cGet30
  		SZ9->Z9_CUSFIN		:= cGet31
  		SZ9->Z9_FIANCAS		:= cGet32
  		SZ9->Z9_PROVGAR		:= cGet33
  		SZ9->Z9_PERDIMP		:= cGet34
  		SZ9->Z9_PROYALT		:= cGet35
  		SZ9->Z9_PCOMIS		:= cGet36
  	MsUnlock()

	Reclock("TRB1",.F.)
		
		if SUBSTR(oComboBx1,1,1) = "1"
			TRB1->BOOK 	:= "GENERAL"
		elseIF SUBSTR(oComboBx1,1,1) = "2"
			TRB1->BOOK 	:= "MARKETING PLATFORM"
		elseIF SUBSTR(oComboBx1,1,1) = "3"
			TRB1->BOOK 	:= "BOOKING"
		else
			TRB1->BOOK 	:= ""
		endif

		if _cIdioma = 1
			if SUBSTR(oComboBx3,1,1) = "1"
				TRB1->STATUS 	:= "ACTIVE"
			elseIF SUBSTR(oComboBx3,1,1) = "2"
				TRB1->STATUS 	:= "CANCELED"
			elseIF SUBSTR(oComboBx3,1,1) = "3"
				TRB1->STATUS 	:= "DECLINED"
			elseIF SUBSTR(oComboBx3,1,1) = "4"
				TRB1->STATUS 	:= "NOT SENT"
			elseIF SUBSTR(oComboBx3,1,1) = "5"
				TRB1->STATUS 	:= "LOST"
			elseIF SUBSTR(oComboBx3,1,1) = "6"
				TRB1->STATUS 	:= "SLC"
			elseIF SUBSTR(oComboBx3,1,1) = "7"
				TRB1->STATUS 	:= "SOLD"
			else
				TRB1->STATUS 	:= ""
			endif
		else
			if SUBSTR(oComboBx3,1,1) = "1"
				TRB1->STATUS 	:= "ATIVA"
			elseIF SUBSTR(oComboBx3,1,1) = "2"
				TRB1->STATUS 	:= "CANCELADA"
			elseIF SUBSTR(oComboBx3,1,1) = "3"
				TRB1->STATUS 	:= "DECLINADA"
			elseIF SUBSTR(oComboBx3,1,1) = "4"
				TRB1->STATUS 	:= "NAO ENVIADA"
			elseIF SUBSTR(oComboBx3,1,1) = "5"
				TRB1->STATUS 	:= "PERDIDA"
			elseIF SUBSTR(oComboBx3,1,1) = "6"
				TRB1->STATUS 	:= "SLC"
			elseIF SUBSTR(oComboBx3,1,1) = "7"
				TRB1->STATUS 	:= "VENDIDA"
			else
				TRB1->STATUS 	:= ""
			endif
		endif

		if _cIdioma = 1
			if empty(cGet4)
				TRB1->INDUSTR := ""
			else
				TRB1->INDUSTR := Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(cGet4),"ZZJ_PRODIN")
			endif
		else
			if empty(cGet4)
				TRB1->INDUSTR := ""
			else
				TRB1->INDUSTR		:= cGet4
			endif
		endif
		TRB1->OPPNAME		:= cGet9
		TRB1->CODEQ			:= cGet12
		
		/************* Descricao Equipamento **************/
		cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(cGet1) + "'"
			
		IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

		ProcRegua(QUERY2->(reccount()))
			
		SZF->(dbgotop())
		
		while QUERY2->(!eof())
		
			if _cIdioma = 1
				if empty(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIPIN"))
					cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DIMENS) + " "
				else
					cEQUIPDES += " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIPIN")) + alltrim(QUERY2->ZF_DIMENS) + " "
				endif
			else
				cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DESCRI) + " "
			endif
			
			QUERY2->(dbskip())

		enddo	
	
		TRB1->EQUIPDES	:= alltrim(cEQUIPDES)
		/*************************************************/
		TRB1->DIMENS		:= cGet14
		TRB1->FORECL		:= cGet18
		TRB1->SALPER		:= cGet22
		TRB1->SALREP		:= cGet26
		TRB1->COUNTRY		:= cGet24	
		/*************************************/

		//if cGet39 > 0
			//TRB1->FOREAMM	:= cGet39		
			//nXTOTSI := cGet39		
		//else
			cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(cGet1) + "'"
			
			IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

			ProcRegua(QUERY2->(reccount()))
			
			SZF->(dbgotop())
		
			while QUERY2->(!eof())

				nXTOTSI 		+= QUERY2->ZF_TOTVSI

				QUERY2->(dbskip())

			enddo	
			TRB1->FOREAMM	:= nXTOTSI
		//endif
		
		QUERY2->(dbgotop())
				
		//if cGet38 > 0 
			
			//nXCUSTOT 		:= QUERY->Z9_CUSTOT
		//else
			while QUERY2->(!eof())

				nXCUSTOT 		+= QUERY2->ZF_TOTVSI-(QUERY2->ZF_TOTVSI*(QUERY2->ZF_MKPFIN/100))

				QUERY2->(dbskip())

			enddo	
			
		//endif
		
		/*******************************/
		TRB1->FOREAMM		:= nXTOTSI
		nVCOMIS 			:= nXTOTSI * (cGet36/100)
		nCOGS				:= nXCUSTOT - nVCOMIS	
		nVCONTMG			:= nXTOTSI - nCOGS - nVCOMIS		
		TRB1->COMMISS		:= cGet36
		TRB1->VCOMMISS		:= (nXTOTSI * (cGet36/100))
		TRB1->COGS			:= nCOGS
		TRB1->CONTRMG		:= (nVCONTMG / nXTOTSI)*100 
		TRB1->VCONTRMG		:= nVCONTMG
	MsUnlock()
	
 Endif  
 
	SZF->(DbGoTop())
    TSZF->(DbCloseArea()) 
    QUERY2->(DbCloseArea()) 

Return _nOpc
/******************Editar SZF **************/
Static Function EditSZF()
    Local aArea       := GetArea()
    Local aAreaSZF    := SZF->(GetArea())
    Local nOpcao1SZF  := 0
    Local cIdVend	  := alltrim(TRB13->IDVEND)
    Local cNProp	  := alltrim(TRB13->NPROP)
   
    Private cCadastro 
 
   	cCadastro := "Alteracao Proposta"
    
	DbSelectArea("SZF")
	SZF->(DbSetOrder(5)) //B1_FILIAL + B1_COD
	SZF->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If SZF->(DbSeek(xFilial('SZF')+cIdVend+cNProp))
	    	
	        nOpcao1SZF := fAltTRB13()
	        If nOpcao1SZF == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	     
	        EndIf
	       
	EndIf
	
    RestArea(aAreaSZF)
    RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AbreArq   												  ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function AbreArq()
local aStru 	:= {}
local _dData
local _nDias	:= 1
local _cCpoAtu1
Local _dDTIni
Local _dDTFin
Local dDataX
Local nUM := 1
local _ni


if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Nao foi possivel abrir o arquivo ACCREC.XLS pois ele pode estar aberto por outro usu�rio.")
	return(.F.)
endif

_cCpoAtu1 := "R" +	strtran(dtoc(DataValida(_dDataIni),"dd/mm/yy"),"/","") // Primeiro campo que sera criado

//msginfo( _cCpoAtu )
//if _nDiasPer == 1 // Se for diario, grava a data
//	aadd(_aLegPer , dtoc(_dDataIni,"dd/mm/yy"))
//else // Senao grava dd/mm a dd/mm
	aadd(_aLegPer , left(dtoc(_dDataIni,"dd/mm/yy"),10) + " a ")

//endif

for _dData := _dDataIni to _dDataFim step 1 // Monta campos com as datas

		if _dData == dDataX  // Se ja acumulou mais que o necessario

			 // reinicia o contador
			_aLegPer[len(_aLegPer)] += left(dtoc(_aDatas[len(_aDatas),1],"dd/mm/yy"),10)
			//aadd(_aLegPer , left(dtoc(_dData,"dd/mm/yy"),10) + " a ")

			if FirstDate(_dDataFim)= dDataX
				aadd(_aLegPer , left(dtoc(_dData,"dd/mm/yy"),10) + " a " + left(dtoc(_dDataFim,"dd/mm/yy"),10) )
			else
				aadd(_aLegPer , left(dtoc(_dData,"dd/mm/yy"),10) + " a ")
			endif

			_cCpoAtu1 	:= "R" +	strtran(dtoc(_dData,"dd/mm/yy"),"/","") // gera o nome do campo

			_nDias 		:= 1

		endif

		_nDias++

		dDataX := LastDate(_dData)+1

		aadd(_aDatas , {_dData, _cCpoAtu1})

		if ascan(_aCpos1 , _cCpoAtu1) == 0
			aadd(_aCpos1 , _cCpoAtu1)
		endif

next _dData

_nCampos := len(_aCpos1)

// monta arquivo analitico
aAdd(aStru,{"NPROP"		,"C",13,0}) // Proposal Number
aAdd(aStru,{"BOOK"		,"C",20,0}) // Proposal Number
aAdd(aStru,{"STATUS"	,"C",13,0}) // Proposal Number
aAdd(aStru,{"FXBUD"		,"C",15,0}) // Fixed / Budget
aAdd(aStru,{"FEAEXEC"	,"C",15,0}) // Feasibility Execution
aAdd(aStru,{"OPPNAME"	,"C",40,0}) // Opportunity Name
aAdd(aStru,{"COUNTRY"	,"C",20,0}) // Country
aAdd(aStru,{"MARKSEC"	,"C",20,0}) // Market Sector
aAdd(aStru,{"INDUSTR"	,"C",20,0}) // Industry
aAdd(aStru,{"SALPER"	,"C",40,0}) // Sales Person
aAdd(aStru,{"SALREP"	,"C",40,0}) // Sales Person
aAdd(aStru,{"CODEQ"		,"C",06,0}) // Equipment Description
aAdd(aStru,{"EQUIPDES"	,"C",250,0}) // Equipment Description
aAdd(aStru,{"DIMENS"	,"C",20,0}) // Equipment Description
aAdd(aStru,{"DTREG"		,"D",8,0}) // Data Registro
aAdd(aStru,{"XDTREG"	,"C",8,0}) // Data Registro
aAdd(aStru,{"FORECL"	,"D",8,0}) // Forecast Close
aAdd(aStru,{"DTEPROP"	,"D",8,0}) // Entrega Proposta
aAdd(aStru,{"DTEREAL"	,"D",8,0}) // Entrega Real Proposta	
aAdd(aStru,{"FOREAMM"	,"N",15,2}) // Forecast Amount
aAdd(aStru,{"CONTRMG"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"VCONTRMG"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"COGS"		,"N",15,2}) // Cogs
aAdd(aStru,{"COMMISS"	,"N",15,2}) // Commission
aAdd(aStru,{"VCOMMISS"	,"N",15,2}) // Value Commission
aAdd(aStru,{"SALAMOU"	,"N",15,2}) // Sales Phase Amount
aAdd(aStru,{"SALCONT"	,"N",15,2}) // Sales Phase Contribution
aAdd(aStru,{"COMMENT"	,"C",40,0}) // Comments
aAdd(aStru,{"CFORECL"	,"C",7,0}) // Forecast Close TEXTO
aAdd(aStru,{"DFORECL"	,"D",8,0}) // Forecast Close
aAdd(aStru,{"CLASSIF"	,"C",1,0}) // CLASSIFICACAO
aAdd(aStru,{"MERCADO"	,"C",1,0}) // MERCADO
aAdd(aStru,{"TIPO"		,"C",1,0}) // TIPO
aAdd(aStru,{"STATUS2"	,"C",1,0}) // STATUS
aAdd(aStru,{"IDRESP"	,"C",6,0}) // IDRESP
aAdd(aStru,{"CODREP"	,"C",6,0}) // IDREPRESENTANTE
aAdd(aStru,{"XFORECL"	,"C",8,0}) // DTOS(ZFORECL)

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.F.,.F.)
//index on ORDEM to &(cArqTrb2+"2")
index on NPROP to &(cArqTrb1+"1")
index on FORECL to &(cArqTrb1+"2")
set index to &(cArqTrb1+"1")

/**************Detalhes Proposta ****************************/
aStru := {}
aAdd(aStru,{"IDVEND"	,"C",10,0}) // Proposal Number
aAdd(aStru,{"ITEM"		,"C",10,0}) // Proposal Number
aAdd(aStru,{"CODPROD"	,"C",10,0}) // Proposal Number
aAdd(aStru,{"DESCRI"	,"C",40,0}) // Proposal Number
aAdd(aStru,{"DIMENS"	,"C",30,0}) // Fixed / Budget
aAdd(aStru,{"QUANT"		,"N",15,2}) // Forecast Amount
aAdd(aStru,{"TOTAL"		,"N",15,2}) // Contribution Margin
aAdd(aStru,{"TOTVSI"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"MGCONT"	,"N",15,2}) // Cogs
aAdd(aStru,{"NPROP"		,"C",13,0}) // Forecast Close

dbcreate(cArqTrb13,aStru)
dbUseArea(.T.,,cArqTrb13,"TRB13",.F.,.F.)
index on ITEM to &(cArqTrb13+"1")
index on ITEM to &(cArqTrb13+"2")
set index to &(cArqTrb13+"1")



return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RETGRUPO 												  ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o grupo de uma determinada natureza                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function RetGrupo(_cItem)
local _cRet := ""

if empty(_cItem)
	_cRet := space(10)
else
	CTD->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
	if CTD->(dbseek(xFilial("CTD")+_cItem))
		_cRet := CTD->CTD_ITEM
	endif

endif

return(_cRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RETCAMPO  												  ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o grupo de uma determinada natureza                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function RetCampo(_dData)
local _cRet := ""

_nPos := Ascan(_aDatas , { |x| x[1] == _dData })

if _nPos > 0
	_cRet := _aDatas[_nPos,2]
endif

return(_cRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDPARAM  												  ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida os parametros digitados                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function VldParam()

	/*
	if empty(_dDataIni) .or. empty(_dDataFim)  // Alguma data vazia
		msgstop("Todas as datas dos par�metros devem ser informadas.")
		return(.F.)
	endif
	*/
	if empty(_dDataIni) .or. empty(_dDataFim)  // Alguma data vazia
		msgstop("Todas as datas dos parametros devem ser informadas.")
		return(.F.)
	endif

return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALIDPERG �Autor  										  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria as perguntas do SX1                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function PergFebook()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Data Inicial"			,"Data Inicial"			,"Data Inicial"			,"mv_ch1","D",08,0,0,"G","",""		,"",,"mv_par01","","","","","","","","","","","","","","","","",{"Data de inicio do processamento"})
PutSX1(cPerg,"02","Data Final"				,"Data Final"			,"Data Final"			,"mv_ch2","D",08,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","",{"Data final do processamento"})
//PutSX1(cPerg,"07","Idioma?" 	,"Idioma?","Idioma?","mv_ch7","N",01,0,0,"N","",""		,"",,"mv_par07","Portugues","","","","Ingles","","","","","","","","","","","")

return
