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
user function zFeBook()

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
private cArqTrb2 := CriaTrab(NIL,.F.) //"PFIN012"
private cArqTrb3 := CriaTrab(NIL,.F.) //"PFIN013"
private cArqTrb4 := CriaTrab(NIL,.F.) //"PFIN013"
private cArqTrb5 := CriaTrab(NIL,.F.) //"PFIN013"
private cArqTrb6 := CriaTrab(NIL,.F.) //"PFIN013"
private cArqTrb7 := CriaTrab(NIL,.F.) //"PFIN013"
private cArqTrb8 := CriaTrab(NIL,.F.) //"PFIN013"
private cArqTrb9 := CriaTrab(NIL,.F.) //"PFIN013"
private cArqTrb10 := CriaTrab(NIL,.F.) //"PFIN013"
private cArqTrb11 := CriaTrab(NIL,.F.) //"PFIN013"
private cArqTrb12 := CriaTrab(NIL,.F.) //"PFIN013"
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
	
	
	MSAguarde({|| zPREVPPS()},"Spare parts & Field service (v1) ")
	
	MSAguarde({|| zSPAREP()},"Spare parts & Field service (v2)")
	
	MSAguarde({||zDetProp()},"Proposals Details")
	
	MSAguarde({|| zGERPROP()},"General list of proposals")
	
	MSAguarde({|| zNPROPGER()},"General list of proposals")
	
	MSAguarde({||zMARKPL()},"Marketing Platform")
	
	MSAguarde({||zBookBR()},"Booking BR")
	
	MSAguarde({||zBookSA()},"Booking SA")
	
	MSAguarde({||zBookTT()},"Booking Total")
	
	MSAguarde({||zMKTotal()},"Count Marketing Platform")
	
	MSAguarde({||zBRTotal()},"Count Booking BR")
	
	MSAguarde({||zSATotal()},"Count Booking SA")
	
	MSAguarde({||zTTTotal()},"Count Booking Total")
	
	MSAguarde({||zVDTotal()},"Count Sold Total")
	
	MSAguarde({||zACTTotal()},"Count Active Total")
	
	MSAguarde({||zLOSTTotal()},"Count Lost Total")
	
	MontaTela()

	TRB1->(dbclosearea())
	TRB2->(dbclosearea())
	TRB3->(dbclosearea())
	TRB4->(dbclosearea())
	TRB5->(dbclosearea())
	TRB6->(dbclosearea())
	TRB7->(dbclosearea())
	TRB8->(dbclosearea())
	TRB9->(dbclosearea())
	TRB10->(dbclosearea())
	TRB11->(dbclosearea())
	TRB12->(dbclosearea())
	TRB13->(dbclosearea())

//endif

return
/***************************************/
static function zMKTotal()
	local nContProp := 0
	
	RecLock("TRB8",.T.)
	
	TRB2->(dbgotop())
	
		TRB8->DESC	:= "Qtd.Prop." 
		for _ni := 1 to len(_aCpos1) // Monta campos com as datas
			//dDTIni :=  ctod(substr( _aLegPer[_ni],1,10))
			//dDTFin :=  ctod(substr( _aLegPer[_ni],14,10 ))

			TRB2->(dbgotop())

			 	While TRB2->( ! EOF() )

					dDTIni :=  FirstDate(ctod(substr( _aLegPer[_ni],1,10)))
					dDTFin :=  LastDate(ctod(substr( _aLegPer[_ni],14,10 )))

					IF alltrim(TRB2->BOOK2) = "MARKETING PLATFORM" .AND. TRB2->FORECL2 >= dDTIni .AND. TRB2->FORECL2 <= dDTFin
						nContProp := nContProp + 1	
					ENDIF
					TRB2->(dbskip())
				EndDo

			FieldPut(TRB8->(fieldpos(_aCpos1[_ni])) , nContProp )
			
			nContProp := 0
		next
	MsUnlock()
return

/***************************************/
static function zBRTotal()
	local nContProp := 0
	
	RecLock("TRB9",.T.)
	
	
	TRB6->(dbgotop())
	
		TRB9->DESC	:= "Booking BR" 
		for _ni := 1 to len(_aCpos1) // Monta campos com as datas
			//dDTIni :=  ctod(substr( _aLegPer[_ni],1,10))
			//dDTFin :=  ctod(substr( _aLegPer[_ni],14,10 ))

			TRB6->(dbgotop())

			 	While TRB6->( ! EOF() )

					dDTIni :=  FirstDate(ctod(substr( _aLegPer[_ni],1,10)))
					dDTFin :=  LastDate(ctod(substr( _aLegPer[_ni],14,10 )))

					IF alltrim(TRB6->XPAIS) = "BRASIL" .AND. TRB6->XDFORECL >= dDTIni .AND. TRB6->XDFORECL <= dDTFin .AND. alltrim(TRB6->XSTATUS) == "1"
					
						nContProp := nContProp + 1	
					ENDIF
					TRB6->(dbskip())
				EndDo

			FieldPut(TRB9->(fieldpos(_aCpos1[_ni])) , nContProp )
			
			nContProp := 0
		next
	MsUnlock()
return

/***************************************/
static function zSATotal()
	local nContProp := 0
	
	RecLock("TRB9",.T.)
	
	
	TRB6->(dbgotop())
	
		TRB9->DESC	:= "Booking SA" 
		for _ni := 1 to len(_aCpos1) // Monta campos com as datas
			//dDTIni :=  ctod(substr( _aLegPer[_ni],1,10))
			//dDTFin :=  ctod(substr( _aLegPer[_ni],14,10 ))

			TRB6->(dbgotop())

			 	While TRB6->( ! EOF() )

					dDTIni :=  FirstDate(ctod(substr( _aLegPer[_ni],1,10)))
					dDTFin :=  LastDate(ctod(substr( _aLegPer[_ni],14,10 )))

					IF alltrim(TRB6->XPAIS) <> "BRASIL" .AND. TRB6->XDFORECL >= dDTIni .AND. TRB6->XDFORECL <= dDTFin .AND. alltrim(TRB6->XSTATUS) == "1"
						nContProp := nContProp + 1	
					ENDIF
					TRB6->(dbskip())
				EndDo

			FieldPut(TRB9->(fieldpos(_aCpos1[_ni])) , nContProp )
			
			nContProp := 0
		next
	MsUnlock()
return

/***************************************/
static function zTTTotal()
	local nContProp := 0
	
	RecLock("TRB9",.T.)
	
	
	TRB6->(dbgotop())
	
		TRB9->DESC	:= "Booking Total" 
		for _ni := 1 to len(_aCpos1) // Monta campos com as datas
			//dDTIni :=  ctod(substr( _aLegPer[_ni],1,10))
			//dDTFin :=  ctod(substr( _aLegPer[_ni],14,10 ))

			TRB6->(dbgotop())

			 	While TRB6->( ! EOF() )

					dDTIni :=  FirstDate(ctod(substr( _aLegPer[_ni],1,10)))
					dDTFin :=  LastDate(ctod(substr( _aLegPer[_ni],14,10 )))

					IF TRB6->XDFORECL >= dDTIni .AND. TRB6->XDFORECL <= dDTFin .AND. alltrim(TRB6->XSTATUS) == '1'
						nContProp := nContProp + 1	
					ENDIF
					TRB6->(dbskip())
				EndDo

			FieldPut(TRB9->(fieldpos(_aCpos1[_ni])) , nContProp )
			
			nContProp := 0
		next
	MsUnlock()
return

/***************************************/
static function zVDTotal()
	local nContProp := 0
	
	RecLock("TRB12",.T.)
	
	
	TRB1->(dbgotop())
	
		TRB12->DESC	:= "SOLD" 
		for _ni := 1 to len(_aCpos1) // Monta campos com as datas
			//dDTIni :=  ctod(substr( _aLegPer[_ni],1,10))
			//dDTFin :=  ctod(substr( _aLegPer[_ni],14,10 ))

			TRB1->(dbgotop())

			 	While TRB1->( ! EOF() )

					dDTIni :=  FirstDate(ctod(substr( _aLegPer[_ni],1,10)))
					dDTFin :=  LastDate(ctod(substr( _aLegPer[_ni],14,10 )))

					IF alltrim(TRB1->STATUS) $ "SOLD/VENDIDA" .AND. TRB1->FORECL >= dDTIni .AND. TRB1->FORECL <= dDTFin 
						nContProp := nContProp + 1	
					ENDIF
					TRB1->(dbskip())
				EndDo

			FieldPut(TRB12->(fieldpos(_aCpos1[_ni])) , nContProp )
			
			nContProp := 0
		next
	MsUnlock()
return

/***************************************/
static function zACTTotal()
	local nContProp := 0
	
	RecLock("TRB12",.T.)
	
	
	TRB1->(dbgotop())
	
		TRB12->DESC	:= "ACTIVE" 
		for _ni := 1 to len(_aCpos1) // Monta campos com as datas
			//dDTIni :=  ctod(substr( _aLegPer[_ni],1,10))
			//dDTFin :=  ctod(substr( _aLegPer[_ni],14,10 ))

			TRB1->(dbgotop())

			 	While TRB1->( ! EOF() )

					dDTIni :=  FirstDate(ctod(substr( _aLegPer[_ni],1,10)))
					dDTFin :=  LastDate(ctod(substr( _aLegPer[_ni],14,10 )))

					IF alltrim(TRB1->STATUS) $ "ACTIVE/ATIVA" .AND. TRB1->FORECL >= dDTIni .AND. TRB1->FORECL <= dDTFin
						nContProp := nContProp + 1	
					ENDIF
					TRB1->(dbskip())
				EndDo

			FieldPut(TRB12->(fieldpos(_aCpos1[_ni])) , nContProp )
			
			nContProp := 0
		next
	MsUnlock()
return

/***************************************/
static function zLOSTTotal()
	local nContProp := 0
	
	RecLock("TRB12",.T.)
	
	
	TRB1->(dbgotop())
	
		TRB12->DESC	:= "LOST" 
		for _ni := 1 to len(_aCpos1) // Monta campos com as datas
			//dDTIni :=  ctod(substr( _aLegPer[_ni],1,10))
			//dDTFin :=  ctod(substr( _aLegPer[_ni],14,10 ))

			TRB1->(dbgotop())

			 	While TRB1->( ! EOF() )

					dDTIni :=  FirstDate(ctod(substr( _aLegPer[_ni],1,10)))
					dDTFin :=  LastDate(ctod(substr( _aLegPer[_ni],14,10 )))

					IF alltrim(TRB1->STATUS) $ "LOST/PERDIDA" .AND. TRB1->FORECL >= dDTIni .AND. TRB1->FORECL <= dDTFin
						nContProp := nContProp + 1	
					ENDIF
					TRB1->(dbskip())
				EndDo

			FieldPut(TRB12->(fieldpos(_aCpos1[_ni])) , nContProp )
			
			nContProp := 0
		next
	MsUnlock()
return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�												   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa o Previsao partes e pecas e servicos              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zPREVPPS()
local _cQuery 		:= ""
Local _cFilZZI 		:= xFilial("ZZI")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local QUERY2 		:= ""
Local Contador		:= 0
Local aInd:={}
Local cCondicao
Local bFiltraBrw



Local _cFilSZ9 		:= xFilial("SZ9")

ZZI->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("ZZI",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZI_PREVVD",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

//ZZI->(dbgotop())

while QUERY->(!eof())

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZZI_ID))
		ProcessMessage()
		
		if QUERY->ZZI_PREVVD <= _dDataIni
			QUERY->(dbskip())
			LOOP
		ENDIF
		
		if QUERY->ZZI_PREVVD >= _dDataFim
			QUERY->(dbskip())
			LOOP
		ENDIF
		
		//x1FORECL2 :=  substr(dtoc(QUERY->ZZI_PREVVD),4,7)
		//x3FORECL2 :=  QUERY->ZZI_PREVVD
	
		RecLock("TRB6",.T.)
		TRB6->XNPROP	:= "XXXXX-XXX"
		TRB6->XSTATUS	:= "1"
		TRB6->XBOOK		:= QUERY->ZZI_BOOK
		TRB6->XTIPO		:= QUERY->ZZI_TIPO
		TRB6->XVIAEXEC	:= QUERY->ZZI_VIAEXE
		TRB6->XMERCADO	:= QUERY->ZZI_MERC
		TRB6->XPAIS		:= QUERY->ZZI_PAIS
		
		if _cIdioma = 1
			TRB6->XCONTR	:= QUERY->ZZI_OPING
		else
			TRB6->XCONTR	:= QUERY->ZZI_OPNAM
		endif
		
		TRB6->XDTPREV	:= QUERY->ZZI_PREVVD
		
		if _cIdioma = 1 
			TRB6->XEQUIP	:= QUERY->ZZI_DESCIN
		else	
			TRB6->XEQUIP	:= QUERY->ZZI_DESC
		endif
		
		if _cIdioma = 1
			TRB6->XPRODUTO	:= Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(QUERY->ZZI_PRODUT),"ZZJ_PRODIN")
		else
			TRB6->XPRODUTO	:= QUERY->ZZI_PRODUT
		endif
		
		TRB6->XRESP		:= QUERY->ZZI_RESP
		TRB6->XTOTSI	:= QUERY->ZZI_VDSI
		TRB6->XCOGS		:= QUERY->ZZI_COGS
		TRB6->PCONTRMG	:= QUERY->ZZI_PMGCON
		TRB6->VCONTRMG	:= QUERY->ZZI_MGCON
		TRB6->XPCOMIS	:= QUERY->ZZI_PCOMIS
		TRB6->VCOMMISS	:= QUERY->ZZI_COMIS
		TRB6->XPGET		:= QUERY->ZZI_PGET
		TRB6->XPGO		:= QUERY->ZZI_PGO
		TRB6->XSALAMOU	:= QUERY->ZZI_MTVD
		TRB6->XSALCONT	:= QUERY->ZZI_MTCONT
		TRB6->XCFORECL	:= substr(dtoc(QUERY->ZZI_PREVVD),4,7)
		TRB6->XDFORECL	:= QUERY->ZZI_PREVVD
		TRB6->XID		:= QUERY->ZZI_ID
		
		MsUnlock()

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())


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
���Programa  �PFIN01REAL�												   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa o Previsao partes e pecas e servicos              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zGERPROP()
local _cQuery 		:= ""
Local _cFilSZ9 		:= xFilial("SZ9")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local QUERY2 		:= ""
Local Contador		:= 0
Local aInd:={}
Local cCondicao
Local bFiltraBrw
Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0
Local nXTOTSI		:= 0
Local nXCUSTOT		:= 0
Local cFor2			:= ""

/**************** SZ9 **************/
SZ9->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SZ9",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"Z9_DTPREV,Z9_NPROP",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

SZ9->(dbgotop())

/****************SZF - DETALHES *****/

SZF->(dbsetorder(3)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SZF",.F.,"QUERY2") // Alias dos movimentos bancarios

/*************************************/

while QUERY->(!eof())

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->Z9_NPROP))
		ProcessMessage()
		
		if QUERY->Z9_DTPREV <= _dDataIni
			QUERY->(dbskip())
			LOOP
		ENDIF
		
		if QUERY->Z9_DTPREV >= _dDataFim
			QUERY->(dbskip())
			LOOP
		ENDIF
		
		//x1FORECL2 :=  substr(dtoc(QUERY->Z9_DTPREV),4,7)
		//x3FORECL2 :=  QUERY->Z9_DTPREV
	
		RecLock("TRB6",.T.)
		TRB6->XNPROP	:= QUERY->Z9_NPROP
		TRB6->XBOOK		:= QUERY->Z9_BOOK
		TRB6->XTIPO		:= QUERY->Z9_TIPO
		TRB6->XSTATUS	:= QUERY->Z9_STATUS
		TRB6->XVIAEXEC	:= QUERY->Z9_VIAEXEC
		TRB6->XMERCADO	:= QUERY->Z9_MERCADO
		TRB6->XCONTR	:= QUERY->Z9_CONTR
		TRB6->XPAIS		:= QUERY->Z9_PAIS
		TRB6->XDTPREV	:= QUERY->Z9_DTPREV
		TRB6->CODEQ		:= QUERY->Z9_XCOEQ
		
		if _cIdioma = 1
			if empty(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY->Z9_XCOEQ),"ZA_EQUIPIN"))
				TRB6->XEQUIP	:= QUERY->Z9_XEQUIP
			else
				TRB6->XEQUIP	:= Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY->Z9_XCOEQ),"ZA_EQUIPIN")
			endif
		else
			TRB6->XEQUIP	:= QUERY->Z9_XEQUIP
		endif
		
		TRB6->XDIMENS	:= QUERY->Z9_DIMENS
		
		if _cIdioma = 1
			if empty(alltrim(QUERY->Z9_INDUSTR))
				TRB6->XPRODUTO	:= ""
			else
				TRB6->XPRODUTO := Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(QUERY->Z9_INDUSTR),"ZZJ_PRODIN")
			endif
		else
			if empty(alltrim(QUERY->Z9_INDUSTR))
				TRB6->XPRODUTO	:= ""
			else
				TRB6->XPRODUTO	:= QUERY->Z9_INDUSTR
			endif
		endif
		
		TRB6->XRESP		:= QUERY->Z9_RESP
		TRB6->XREPR		:= QUERY->Z9_REPRE
		
		if QUERY->Z9_TOTSI > 0
			TRB6->XTOTSI	:= QUERY->Z9_TOTSI
			nXTOTSI := QUERY->Z9_TOTSI
		else
		
			cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(QUERY->Z9_NPROP) + "'"
			
			IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

			ProcRegua(QUERY2->(reccount()))
			
			while QUERY2->(!eof())

				nXTOTSI 		+= QUERY2->ZF_TOTVSI

				QUERY2->(dbskip())

			enddo	
			TRB6->XTOTSI	:= nXTOTSI
		endif
		
		QUERY2->(dbgotop())
				
		if QUERY->Z9_CUSTOT > 0 
			TRB6->XCUSTOT	:= QUERY->Z9_CUSTOT
			nXCUSTOT 		:= QUERY->Z9_CUSTOT
		else
			while QUERY2->(!eof())

				nXCUSTOT 		+= QUERY2->ZF_TOTVSI-(QUERY2->ZF_TOTVSI*(QUERY2->ZF_MKPFIN/100))

				QUERY2->(dbskip())

			enddo	
			TRB6->XCUSTOT	:= nXCUSTOT
		endif
		
		nVCOMIS 		:= nXTOTSI * (QUERY->Z9_PCOMIS/100)
		nCOGS			:= nXCUSTOT - nVCOMIS	
		nVCONTMG		:= nXTOTSI - nCOGS - nVCOMIS
		
		TRB6->XCOGS		:= nCOGS
		TRB6->VCONTRMG	:= nVCONTMG 
		TRB6->PCONTRMG	:= (nVCONTMG / nXTOTSI)*100 
		
		TRB6->XPCOMIS	:= QUERY->Z9_PCOMIS
		TRB6->VCOMMISS	:= nVCOMIS
		
		TRB6->XPGET		:= QUERY->Z9_PGET
		TRB6->XPGO		:= QUERY->Z9_PGO
		TRB6->XSALAMOU	:= QUERY->Z9_SALAMOU
		TRB6->XSALCONT	:= QUERY->Z9_SALCONT
		TRB6->XCFORECL	:= substr(dtoc(TRB6->XDTPREV),4,7)
		TRB6->XDFORECL	:= TRB6->XDTPREV
	
	
		MsUnlock()

	QUERY->(dbskip())
	
	nXTOTSI 		:= 0
	nXCUSTOT 		:= 0
	
enddo

QUERY->(dbclosearea())
QUERY2->(dbclosearea())
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

static function zSPAREP()
local _cQuery 		:= ""
Local _cFilZZI 		:= xFilial("ZZI")
Local dData 		:= DDatabase
Local QUERY 		:= ""

Local TOTFOR7 		:= 0
Local TOTVCON7		:= 0
Local TOTCOGS7		:= 0
Local TOTVCOM7		:= 0
Local TOTSALA5		:= 0
Local TOTSALC5		:= 0

Local TGFOR7 		:= 0
Local TGVCON7		:= 0
Local TGCOGS7		:= 0
Local TGVCOM7		:= 0
Local TGSALAM5		:= 0
Local TGSALCO5		:= 0	


ZZI->(dbsetorder(1)) 

ChkFile("ZZI",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZI_ID,ZZI_PREVVD",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

ZZI->(dbgotop())

while QUERY->(!eof())
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZZI_ID))
		ProcessMessage()
		
		if QUERY->ZZI_PREVVD <= _dDataIni
			QUERY->(dbskip())
			LOOP
		ENDIF
		
		if QUERY->ZZI_PREVVD >= _dDataFim
			QUERY->(dbskip())
			LOOP
		ENDIF

		RecLock("TRB7",.T.)
		
		TRB7->ID7			:= QUERY->ZZI_ID
		
		TRB7->NPROP7		:= "XXXXX-XXX"

		if _cIdioma = 1
			IF QUERY->ZZI_BOOK == "1" 
				TRB7->BOOK7	:= "PARTS / SERVICES"
			ELSEIF QUERY->ZZI_BOOK == "3" 
				TRB7->BOOK7	:= "BOOKING"
			ELSE
				TRB7->BOOK7	:= ""
			ENDIF
		
		else
			IF QUERY->ZZI_BOOK == "1" 
				TRB7->BOOK7	:= "PECAS / SERVICOS"
			ELSEIF QUERY->ZZI_BOOK == "3" 
				TRB7->BOOK7	:= "BOOKING"
			ELSE
				TRB7->BOOK7	:= ""
			ENDIF
		endif
		
		if _cIdioma = 1
		
				TRB7->FXBUD7	:= "BUDGET"
			
		else
			
				TRB7->FXBUD7	:= "ESTIMATIVA"
			
		endif
		
		if _cIdioma = 1
		
				TRB7->FEAEXEC7 := "FEASIBILITY"
			
		else
			
				TRB7->FEAEXEC7 := "VIABILIDADE"
			
		endif
		
		if _cIdioma = 1
			TRB7->OPPNAME7	:= QUERY->ZZI_OPING
		else
			TRB7->OPPNAME7	:= QUERY->ZZI_OPNAM
		endif
		
		TRB7->COUNTRY7	:= QUERY->ZZI_PAIS
		
		
		//TRB1->MARKSEC	:= ""
		
		if _cIdioma = 1
		
			IF QUERY->ZZI_MERC == "1" 
				TRB7->MARKSEC7	:= "MINERALS"
			ELSEIF QUERY->ZZI_MERC == "2" 
				TRB7->MARKSEC7	:= "PULP PAPER"
			ELSEIF QUERY->ZZI_MERC == "3" 
				TRB7->MARKSEC7	:= "CHEMISTRY"
			ELSEIF QUERY->ZZI_MERC == "4" 
				TRB7->MARKSEC7	:= "FERTILIZER"
			ELSEIF QUERY->ZZI_MERC == "5" 
				TRB7->MARKSEC7	:= "SIDERURGY"
			ELSEIF QUERY->ZZI_MERC == "6" 
				TRB7->MARKSEC7	:= "MUNICIPAL"
			ELSEIF QUERY->ZZI_MERC == "7" 
				TRB7->MARKSEC7	:= "PETROCHEMICAL"
			ELSEIF QUERY->ZZI_MERC == "8" 
				TRB7->MARKSEC7	:= "FOODS"
			ELSEIF QUERY->ZZI_MERC == "9" 
				TRB7->MARKSEC7	:= "OTHERS"
			ENDIF
		
		else
			IF QUERY->ZZI_MERC == "1" 
				TRB7->MARKSEC7	:= "MINERACAO"
			ELSEIF QUERY->ZZI_MERC == "2" 
				TRB7->MARKSEC7	:= "PAPEL CELULOSE"
			ELSEIF QUERY->ZZI_MERC == "3" 
				TRB7->MARKSEC7	:= "QUIMICA"
			ELSEIF QUERY->ZZI_MERC == "4" 
				TRB7->MARKSEC7	:= "FERTILIZANTES"
			ELSEIF QUERY->ZZI_MERC == "5" 
				TRB7->MARKSEC7	:= "SIDERURGIA"
			ELSEIF QUERY->ZZI_MERC == "6" 
				TRB7->MARKSEC7	:= "MUNICIPAL"
			ELSEIF QUERY->ZZI_MERC == "7" 
				TRB7->MARKSEC7	:= "PETROQUIMICA"
			ELSEIF QUERY->ZZI_MERC == "8" 
				TRB7->MARKSEC7	:= "ALIMENTOS"
			ELSEIF QUERY->ZZI_MERC == "9" 
				TRB7->MARKSEC7	:= "OUTROS"
			ENDIF
		endif
		
		if _cIdioma = 1
			TRB7->INDUSTR7 := Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(QUERY->ZZI_PRODUT),"ZZJ_PRODIN")
		else
			TRB7->INDUSTR7 := QUERY->ZZI_PRODUT
		endif
		
		TRB7->SALPER7	:= UPPER(QUERY->ZZI_RESP)
		TRB7->SALREP7	:= ""
		
		if _cIdioma = 1
			if empty(QUERY->ZZI_DESCIN)
				TRB7->EQUIPDES7	:= QUERY->ZZI_DESC
			else
				TRB7->EQUIPDES7	:= QUERY->ZZI_DESCIN
			endif
		else
			TRB7->EQUIPDES7	:= QUERY->ZZI_DESC
		endif
		TRB7->FORECL7	:= QUERY->ZZI_PREVVD
		TRB7->FOREAMM7	:= QUERY->ZZI_VDSI
		TRB7->CONTRMG7	:= QUERY->ZZI_PMGCON
		TRB7->VCONTRMG7	:= QUERY->ZZI_MGCON
		TRB7->COGS7		:= QUERY->ZZI_COGS
		TRB7->COMMISS7	:= QUERY->ZZI_PCOMIS
		TRB7->VCOMMISS7	:= QUERY->ZZI_COMIS
		TRB7->CFORECL7	:= substr(dtoc(QUERY->ZZI_PREVVD),4,7)
		TRB7->DFORECL7	:= QUERY->ZZI_PREVVD
		TRB7->PGET7		:= QUERY->ZZI_PGET
		TRB7->PGO7		:= QUERY->ZZI_PGO
		TRB7->SALAMOU7	:= QUERY->ZZI_MTVD
		TRB7->SALCONT7	:= QUERY->ZZI_MTCONT
		
		TGFOR7 			+= QUERY->ZZI_VDSI
		TGVCON7			+= QUERY->ZZI_MGCON
		TGCOGS7			+= QUERY->ZZI_COGS
		TGVCOM7			+= QUERY->ZZI_COMIS
		TGSALAM5		+= QUERY->ZZI_MTVD
		TGSALCO5		+= QUERY->ZZI_MTCONT
		
		MsUnlock()

	QUERY->(dbskip())

enddo

RecLock("TRB7",.T.)
	TRB7->NPROP7		:= "TOTAL GERAL"
	TRB7->DFORECL7		:= LastDate(_dDataFim) 
	TRB7->CFORECL7		:= substr(dtoc(_dDataFim),4,7)
	TRB7->FOREAMM7		:= TGFOR7
	TRB7->VCONTRMG7		:= TGVCON7
	TRB7->COGS7			:= TGCOGS7
	TRB7->VCOMMISS7		:= TGVCOM7
	TRB7->SALAMOU7		:= TGSALAM5
	TRB7->SALCONT7		:= TGSALCO5
MsUnlock()
	
QUERY->(dbclosearea())

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

static function zMARKPL()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("SZ9")
Local dData 		:= DDatabase
Local QUERY 		:= ""
Local Contador		:= 0

Local TOTFOR2 		:= 0
Local TOTVCON2		:= 0
Local TOTCOGS2		:= 0
Local TOTVCOM2		:= 0

Local TGFOR2 		:= 0
Local TGVCON2		:= 0
Local TGCOGS2		:= 0
Local TGVCOM2		:= 0
Local TGSALAM2		:= 0
Local TGSALCO2		:= 0

//local cFor 			:= "!ALLTRIM(SUBSTR(QUERY->Z9_NPROP,1,2)) $ '14/15/16/17'"
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


CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SZ9",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"Z9_DTPREV,Z9_NPROP",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

/****************SZF - DETALHES *****/

SZF->(dbsetorder(3)) 

ChkFile("SZF",.F.,"QUERY2") 

/*************************************/


CTD->(dbgotop())
//CTD->(dbsetorder(1))
while QUERY->(!eof())

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->Z9_NPROP))
		ProcessMessage()
		
		IF ALLTRIM(QUERY->Z9_STATUS) $ "2/3/4/5/6/7"
			QUERY->(dbskip())
			LOOP
		ENDIF
		
		IF !ALLTRIM(QUERY->Z9_BOOK) $ "2"
			QUERY->(dbskip())
			LOOP
		ENDIF
		
		if MV_PAR05 = 1

			if QUERY->Z9_DTREG <= _dDataIni //MV_PAR01
				QUERY->(dbskip())
				LOOP
			ENDIF
			
			if QUERY->Z9_DTREG >= _dDataFim //MV_PAR02
				QUERY->(dbskip())
				LOOP
			ENDIF

		else

			if QUERY->Z9_DTPREV <= _dDataIni //MV_PAR01
				QUERY->(dbskip())
				LOOP
			ENDIF
			
			if QUERY->Z9_DTPREV >= _dDataFim //MV_PAR02
				QUERY->(dbskip())
				LOOP
			ENDIF
		ENDIF
		
		x1FORECL2 :=  substr(dtoc(QUERY->Z9_DTPREV),4,7)
		x3FORECL2 :=  QUERY->Z9_DTPREV
	
		RecLock("TRB2",.T.)
		TRB2->NPROP2		:= QUERY->Z9_NPROP
		
		IF QUERY->Z9_BOOK == "1" 
			TRB2->BOOK2	:= "GENERAL"
		ELSEIF QUERY->Z9_BOOK == "2" 
			TRB2->BOOK2	:= "MARKETING PLATFORM"
		ELSEIF QUERY->Z9_BOOK == "3" 
			TRB2->BOOK2	:= "BOOKING"
		ELSE
			TRB2->BOOK2	:= ""
		ENDIF
		
		if _cIdioma = 1
			IF QUERY->Z9_TIPO == "1" 
				TRB2->FXBUD2	:= "FIXED"
			ELSEIF QUERY->Z9_TIPO == "2" 
				TRB2->FXBUD2	:= "BUDGET"
			ELSEIF QUERY->Z9_TIPO == "3" 
				TRB2->FXBUD2	:= "PROSPECTION"
			ENDIF
		else
			IF QUERY->Z9_TIPO == "1" 
				TRB2->FXBUD2	:= "FIRME"
			ELSEIF QUERY->Z9_TIPO == "2" 
				TRB2->FXBUD2	:= "ESTIMATIVA"
			ELSEIF QUERY->Z9_TIPO == "3" 
				TRB2->FXBUD2	:= "PROSPECCAO"
			ENDIF
		endif
		
		if _cIdioma = 1
			IF ALLTRIM(QUERY->Z9_TIPO) == "1"
				TRB2->FEAEXEC2 := "EXECUTION"
			ELSEIF ALLTRIM(QUERY->Z9_TIPO) == "2"
				TRB2->FEAEXEC2 := "FEASIBILITY" 
			ELSEIF ALLTRIM(QUERY->Z9_TIPO) == "3"
				TRB2->FEAEXEC2 := "FEASIBILITY" 
			ELSE
				TRB2->FEAEXEC2 := ""
			ENDIF
		else
			IF ALLTRIM(QUERY->Z9_TIPO) == "1"
				TRB2->FEAEXEC2 := "EXECUCAO"
			ELSEIF ALLTRIM(QUERY->Z9_TIPO) == "2"
				TRB2->FEAEXEC2 := "VIABILIDADE" 
			ELSEIF ALLTRIM(QUERY->Z9_TIPO) == "3"
				TRB2->FEAEXEC2 := "VIABILIDADE" 
			ELSE
				TRB2->FEAEXEC2 := ""
			ENDIF
		endif
		
		if _cIdioma = 1
			IF ALLTRIM(QUERY->Z9_STATUS) == "1" 
				TRB2->STATUS2	:= "ACTIVE"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "2" 
				TRB2->STATUS2	:= "CANCELED"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "3" 
				TRB2->STATUS2	:= "DECLINED"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "4" 
				TRB2->STATUS2	:= "NOT SENT"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "5" 
				TRB2->STATUS2	:= "LOST"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "6" 
				TRB2->STATUS2	:= "SLC"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "7" 
				TRB2->STATUS2	:= "SOLD"
			ENDIF
		else
			IF ALLTRIM(QUERY->Z9_STATUS) == "1" 
				TRB2->STATUS2	:= "ATIVA"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "2" 
				TRB2->STATUS2	:= "CANCELADA"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "3" 
				TRB2->STATUS2	:= "DECLINADA"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "4" 
				TRB2->STATUS2	:= "NAO ENVIADA"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "5" 
				TRB2->STATUS2	:= "PERDIDA"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "6" 
				TRB2->STATUS2	:= "SLC"
			ELSEIF ALLTRIM(QUERY->Z9_STATUS) == "7" 
				TRB2->STATUS2	:= "VENDIDA"
			ENDIF
		endif
		
		TRB2->OPPNAME2	:= QUERY->Z9_CONTR
		TRB2->COUNTRY2	:= QUERY->Z9_PAIS
		
		//TRB2->MARKSEC2	:= ""
		
		if _cIdioma = 1
			IF QUERY->Z9_MERCADO == "1" 
				TRB2->MARKSEC2	:= "MINERALS"
			ELSEIF QUERY->Z9_MERCADO == "2" 
				TRB2->MARKSEC2	:= "PULP PAPER"
			ELSEIF QUERY->Z9_MERCADO == "3" 
				TRB2->MARKSEC2	:= "CHEMISTRY"
			ELSEIF QUERY->Z9_MERCADO == "4" 
				TRB2->MARKSEC2	:= "FERTILIZER"
			ELSEIF QUERY->Z9_MERCADO == "5" 
				TRB2->MARKSEC2	:= "SIDERURGY"
			ELSEIF QUERY->Z9_MERCADO == "6" 
				TRB2->MARKSEC2	:= "MUNICIPAL"
			ELSEIF QUERY->Z9_MERCADO == "7" 
				TRB2->MARKSEC2	:= "PETROCHEMICAL"
			ELSEIF QUERY->Z9_MERCADO == "8" 
				TRB2->MARKSEC2	:= "FOODS"
			ELSEIF QUERY->Z9_MERCADO == "9" 
				TRB2->MARKSEC2	:= "OTHERS"
			ENDIF
		else
			IF QUERY->Z9_MERCADO == "1" 
				TRB2->MARKSEC2	:= "MINERACAO"
			ELSEIF QUERY->Z9_MERCADO == "2" 
				TRB2->MARKSEC2	:= "CELULOSE"
			ELSEIF QUERY->Z9_MERCADO == "3" 
				TRB2->MARKSEC2	:= "QUIMICA"
			ELSEIF QUERY->Z9_MERCADO == "4" 
				TRB2->MARKSEC2	:= "FETILIZANTES"
			ELSEIF QUERY->Z9_MERCADO == "5" 
				TRB2->MARKSEC2	:= "SIDERURGIA"
			ELSEIF QUERY->Z9_MERCADO == "6" 
				TRB2->MARKSEC2	:= "MUNICIPAL"
			ELSEIF QUERY->Z9_MERCADO == "7" 
				TRB2->MARKSEC2	:= "PETROQUIMICA"
			ELSEIF QUERY->Z9_MERCADO == "8" 
				TRB2->MARKSEC2	:= "ALIMENTOS"
			ELSEIF QUERY->Z9_MERCADO == "9" 
				TRB2->MARKSEC2	:= "OUTROS"
			ENDIF
		endif
		
		if _cIdioma = 1
			TRB2->INDUSTR2 := Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(QUERY->Z9_INDUSTR),"ZZJ_PRODIN")
		else
			TRB2->INDUSTR2	:= QUERY->Z9_INDUSTR
		endif
		
		TRB2->SALPER2	:= UPPER(QUERY->Z9_RESP)
		TRB2->SALREP2	:= UPPER(QUERY->Z9_REPRE)
		TRB2->CODEQ2	:= QUERY->Z9_XCOEQ
		
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
	
		TRB2->EQUIPDES2	:= alltrim(cEQUIPDES)
		/*********************************/
	
		TRB2->DIMENS2	:= QUERY->Z9_DIMENS
		TRB2->FORECL2	:= QUERY->Z9_DTPREV
		
		/*******************************/
		if QUERY->Z9_TOTSI > 0
			TRB2->FOREAMM2	:= QUERY->Z9_TOTSI
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
			TRB2->FOREAMM2	:= nXTOTSI
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

		nVCOMIS 		:= nXTOTSI * (QUERY->Z9_PCOMIS/100)
		nCOGS			:= nXCUSTOT - nVCOMIS	
		nVCONTMG		:= nXTOTSI - nCOGS - nVCOMIS
		
		TRB2->COGS2		:= nCOGS
		TRB2->VCONTRMG2	:= nVCONTMG 
		TRB2->CONTRMG2	:= (nVCONTMG / nXTOTSI)*100 
		
		TRB2->COMMISS2	:= QUERY->Z9_PCOMIS
		TRB2->VCOMMISS2	:= nVCOMIS
		
		TRB2->PGET2		:= QUERY->Z9_PGET
		TRB2->PGO2		:= QUERY->Z9_PGO
		TRB2->SALAMOU2	:= QUERY->Z9_SALAMOU
		TRB2->SALCONT2	:= QUERY->Z9_SALCONT
		
		TRB2->CFORECL2	:= substr(dtoc(QUERY->Z9_DTPREV),4,7)
		TRB2->DFORECL2	:= QUERY->Z9_DTPREV
		
		TGFOR2 			+= nXTOTSI
		TGVCON2			+= nVCONTMG 
		TGCOGS2			+= nCOGS
		TGVCOM2			+= nVCOMIS
		TGSALAM2		+= QUERY->Z9_SALAMOU
		TGSALCO2		+= QUERY->Z9_SALCONT		
			
		MsUnlock()

	QUERY->(dbskip())
	
	nXTOTSI		:= 0
	nXCUSTOT	:= 0
	cEQUIPDES	:= ""
enddo
RecLock("TRB2",.T.)
	TRB2->NPROP2		:= "TOTAL GERAL"
	TRB2->DFORECL2		:= LastDate(_dDataFim) 
	TRB2->CFORECL2		:= substr(dtoc(_dDataFim),4,7)
	TRB2->FOREAMM2		:= TGFOR2
	TRB2->VCONTRMG2		:= TGVCON2
	TRB2->COGS2			:= TGCOGS2
	TRB2->VCOMMISS2		:= TGVCOM2
	TRB2->SALAMOU2		:= TGSALAM2
	TRB2->SALCONT2		:= TGSALCO2
MsUnlock()
	
QUERY->(dbclosearea())
QUERY2->(dbclosearea())

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

static function zBookBR()
local _cQuery 		:= ""
Local _cFilTRB6 		:= xFilial("TRB6")
Local dData 		:= DDatabase
Local QUERY 		:= ""

Local TOTFOR3 		:= 0
Local TOTVCON3		:= 0
Local TOTCOGS3		:= 0
Local TOTVCOM3		:= 0

Local TGFOR3 		:= 0
Local TGVCON3		:= 0
Local TGCOGS3		:= 0
Local TGVCOM3		:= 0

Local TOTSALA3		:= 0
Local TOTSALC3		:= 0
Local TGSALAM3		:= 0
Local TGSALCO3		:= 0
Local cEQUIPDES		:= ""

 Local aInd:={}
 Local cCondicao
 Local bFiltraBrw
local cFiltra 	:= ""

Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0
Local nXTOTSI		:= 0
Local nXCUSTOT		:= 0
Local cFor2			:= ""

cFiltra := " alltrim(XBOOK) == '3' .AND. alltrim(XPAIS) == 'BRASIL' .AND. alltrim(XSTATUS) == '1'"
TRB6->(dbsetfilter({|| &(cFiltra)} , cFiltra))

TRB6->(dbgotop())

/****************SZF - DETALHES *****/

SZF->(dbsetorder(3)) 

ChkFile("SZF",.F.,"QUERY2") 

/*************************************/

while TRB6->(!eof())
		
		d1FORECL3 :=  substr(dtoc(LastDate(TRB6->XDTPREV)),1,10)

		MsProcTxt("Processando registro: "+alltrim(TRB6->XNPROP))
		ProcessMessage()
		
		/*		
		IF !ALLTRIM(TRB6->XBOOK) $ "3"
			TRB6->(dbskip())
			LOOP
		ENDIF
		
		IF !ALLTRIM(TRB6->XPAIS) $ "BRASIL"
			TRB6->(dbskip())
			LOOP
		ENDIF
		*/
		/*
		if TRB6->XDTPREV <= MV_PAR01
			TRB6->(dbskip())
			LOOP
		ENDIF
		
		if TRB6->XDTPREV >= MV_PAR02
			TRB6->(dbskip())
			LOOP
		ENDIF
		*/
		RecLock("TRB3",.T.)
		TRB3->NPROP3		:= TRB6->XNPROP
		
		IF alltrim(TRB6->XBOOK) == "1" 
			TRB3->BOOK3	:= "GENERAL"
		ELSEIF alltrim(TRB6->XBOOK) == "2" 
			TRB3->BOOK3	:= "MARKETING PLATFORM"
		ELSEIF alltrim(TRB6->XBOOK) == "3" 
			TRB3->BOOK3	:= "BOOKING"
		ELSE
			TRB3->BOOK3	:= ""
		ENDIF
		
		if _cIdioma = 1
			IF alltrim(TRB6->XTIPO) == "1" 
				TRB3->FXBUD3	:= "FIXED"
			ELSEIF alltrim(TRB6->XTIPO) == "2" 
				TRB3->FXBUD3	:= "BUDGET"
			ELSEIF alltrim(TRB6->XTIPO) == "3" 
				TRB3->FXBUD3	:= "PROSPECTION"
			ENDIF
		else
			IF alltrim(TRB6->XTIPO) == "1" 
				TRB3->FXBUD3	:= "FIRME"
			ELSEIF alltrim(TRB6->XTIPO) == "2" 
				TRB3->FXBUD3	:= "ESTIMATIVA"
			ELSEIF alltrim(TRB6->XTIPO) == "3" 
				TRB3->FXBUD3	:= "PROSPECCAO"
			ENDIF
		endif
		
		if _cIdioma = 1
			IF ALLTRIM(TRB6->XTIPO) == "1"
				TRB3->FEAEXEC3 := "EXECUTION"
			ELSEIF ALLTRIM(TRB6->XTIPO) == "2"
				TRB3->FEAEXEC3 := "FEASIBILITY" 
			ELSEIF ALLTRIM(TRB6->XTIPO) == "3"
				TRB3->FEAEXEC3 := "FEASIBILITY" 
			ELSE
				TRB3->FEAEXEC3 := ""
			ENDIF
		else
			IF ALLTRIM(TRB6->XTIPO) == "1"
				TRB3->FEAEXEC3 := "EXECUCAO"
			ELSEIF ALLTRIM(TRB6->XTIPO) == "2"
				TRB3->FEAEXEC3 := "VIABILIDADE" 
			ELSEIF ALLTRIM(TRB6->XTIPO) == "3"
				TRB3->FEAEXEC3 := "VIABILIDADE" 
			ELSE
				TRB3->FEAEXEC3 := ""
			ENDIF
		endif
		
		if _cIdioma = 1
			IF ALLTRIM(TRB6->XSTATUS) == "1" 
				TRB3->STATUS3	:= "ACTIVE"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "2" 
				TRB3->STATUS3	:= "CANCELED"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "3" 
				TRB3->STATUS3	:= "DECLINED"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "4" 
				TRB3->STATUS3	:= "NOT SENT"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "5" 
				TRB3->STATUS3	:= "LOST"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "6" 
				TRB3->STATUS3	:= "SLC"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "7" 
				TRB3->STATUS3	:= "SOLD"
			ENDIF
		else
			IF ALLTRIM(TRB6->XSTATUS) == "1" 
				TRB3->STATUS3	:= "ATIVA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "2" 
				TRB3->STATUS3	:= "CANCELADA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "3" 
				TRB3->STATUS3	:= "DECLINADA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "4" 
				TRB3->STATUS3	:= "NAO ENVIADA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "5" 
				TRB3->STATUS3	:= "PERDIDA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "6" 
				TRB3->STATUS3	:= "SLC"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "7" 
				TRB3->STATUS3	:= "VENDIDA"
			ENDIF
		endif
		
		TRB3->OPPNAME3	:= TRB6->XCONTR
		TRB3->COUNTRY3	:= TRB6->XPAIS
		
		//TRB2->MARKSEC2	:= ""
		if _cIdioma = 1
			IF TRB6->XMERCADO == "1" 
				TRB3->MARKSEC3	:= "MINERALS"
			ELSEIF TRB6->XMERCADO == "2" 
				TRB3->MARKSEC3	:= "PULP PAPER"
			ELSEIF TRB6->XMERCADO == "3" 
				TRB3->MARKSEC3	:= "CHEMISTRY"
			ELSEIF TRB6->XMERCADO == "4" 
				TRB3->MARKSEC3	:= "FERTILIZER"
			ELSEIF TRB6->XMERCADO == "5" 
				TRB3->MARKSEC3	:= "SIDERURGY"
			ELSEIF TRB6->XMERCADO == "6" 
				TRB3->MARKSEC3	:= "MUNICIPAL"
			ELSEIF TRB6->XMERCADO == "7" 
				TRB3->MARKSEC3	:= "PETROQUIMICA"
			ELSEIF TRB6->XMERCADO == "8" 
				TRB3->MARKSEC3	:= "ALIMENTOS"
			ELSEIF TRB6->XMERCADO == "9" 
				TRB3->MARKSEC3	:= "OUTROS"
			ENDIF
		else
			IF TRB6->XMERCADO == "1" 
				TRB3->MARKSEC3	:= "MINERACAO"
			ELSEIF TRB6->XMERCADO == "2" 
				TRB3->MARKSEC3	:= "CELULOSE"
			ELSEIF TRB6->XMERCADO == "3" 
				TRB3->MARKSEC3	:= "QUIMICA"
			ELSEIF TRB6->XMERCADO == "4" 
				TRB3->MARKSEC3	:= "FETILIZANTES"
			ELSEIF TRB6->XMERCADO == "5" 
				TRB3->MARKSEC3	:= "SIDERURGIA"
			ELSEIF TRB6->XMERCADO == "6" 
				TRB3->MARKSEC3	:= "MUNICIPAL"
			ELSEIF TRB6->XMERCADO == "7" 
				TRB3->MARKSEC3	:= "PETROQUIMICA"
			ELSEIF TRB6->XMERCADO == "8" 
				TRB3->MARKSEC3	:= "ALIMENTOS"
			ELSEIF TRB6->XMERCADO == "9" 
				TRB3->MARKSEC3	:= "OUTROS"
			ENDIF
		endif
		
		TRB3->INDUSTR3	:= TRB6->XPRODUTO
		TRB3->SALPER3	:= UPPER(TRB6->XRESP)
		TRB3->SALREP3	:= UPPER(TRB6->XREPR)
		TRB3->CODEQ3	:= TRB6->CODEQ
		
	
		if _cIdioma = 1
			if !empty(alltrim(TRB6->XID))
				cEQUIPDES	:= TRB6->XEQUIP
			else
				/***************************/
				cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(TRB6->XNPROP) + "'"
					
				IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")
		
				ProcRegua(QUERY2->(reccount()))
					
				SZF->(dbgotop())
				
				while QUERY2->(!eof())
				
					if _cIdioma = 1
						if empty(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIPIN"))
							cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DIMENS) + " "
						else
							cEQUIPDES += " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIPIN")) + alltrim(QUERY2->ZF_DESCRI) + " "
						endif
					else
						cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DESCRI) + " "
					endif
					
					QUERY2->(dbskip())
		
				enddo	

				/*********************************/
			endif
		else
			if ! empty(alltrim(TRB6->XID))
				cEQUIPDES	:= TRB6->XEQUIP
			else
				/***************************/
				cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(TRB6->XNPROP) + "'"
					
				IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")
		
				ProcRegua(QUERY2->(reccount()))
					
				SZF->(dbgotop())
				
				while QUERY2->(!eof())
				
					if _cIdioma = 1
						if empty(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIP"))
							cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DIMENS) + " "
						else
							cEQUIPDES += " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIP")) + alltrim(QUERY2->ZF_DIMENS) + " "
						endif
					else
						cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DESCRI) + " "
					endif
					
					QUERY2->(dbskip())
		
				enddo	

				/*********************************/
			endif
		endif
		
		TRB3->EQUIPDES3	:= alltrim(cEQUIPDES)
		
		TRB3->DIMENS3	:= TRB6->XDIMENS
		TRB3->FORECL3	:= TRB6->XDTPREV
		TRB3->FOREAMM3	:= TRB6->XTOTSI
				
		nVCOMIS 		:= TRB6->VCOMMISS 		//TRB6->XTOTSI * (TRB6->XPCOMIS/100)
		nCOGS			:= TRB6->XCOGS 			//TRB6->XCUSTOT - nVCOMIS	
		nVCONTMG		:= TRB6->VCONTRMG 		//TRB6->XTOTSI - nCOGS - nVCOMIS
		
		TRB3->COGS3		:= nCOGS
		TRB3->VCONTRMG3	:= nVCONTMG 
		TRB3->CONTRMG3	:= TRB6->PCONTRMG		//(nVCONTMG / TRB6->XTOTSI)*100 
		
		TRB3->COMMISS3	:= TRB6->XPCOMIS
		TRB3->VCOMMISS3	:= nVCOMIS

		TRB3->CFORECL3	:= substr(dtoc(TRB6->XDTPREV),4,7)
		TRB3->DFORECL3	:= TRB6->XDTPREV
		
		TRB3->PGET3		:= TRB6->XPGET
		TRB3->PGO3		:= TRB6->XPGO
		TRB3->SALAMOU3	:= TRB6->XSALAMOU
		TRB3->SALCONT3	:= TRB6->XSALCONT
		
		TRB3->ID3		:= TRB6->XID
	
		TOTFOR3 		+= TRB6->XTOTSI
		TOTVCON3		+= TRB6->VCONTRMG
		TOTCOGS3		+= TRB6->XCOGS
		TOTVCOM3		+= TRB6->VCOMMISS
		TOTSALA3		+= TRB6->XSALAMOU
		TOTSALC3		+= TRB6->XSALCONT
		
		TGFOR3 			+= TRB6->XTOTSI
		TGVCON3			+= TRB6->VCONTRMG
		TGCOGS3			+= TRB6->VCOMMISS
		TGVCOM3			+= TRB6->VCOMMISS
		TGSALAM3		+= TRB6->XSALAMOU
		TGSALCO3		+= TRB6->XSALCONT
				
		MsUnlock()
				
		x3FORECL3 :=  TRB6->XDTPREV
	
	TRB6->(dbskip())
	cEQUIPDES := ""
	
	d2FORECL3 :=   substr(dtoc(LastDate(TRB6->XDTPREV)),1,10) 
	
	if d1FORECL3  <> d2FORECL3
		RecLock("TRB3",.T.)
			TRB3->NPROP3		:= "TOTAL"
			TRB3->DFORECL3		:= LastDate(x3FORECL3) 
			TRB3->CFORECL3		:= substr(dtoc(x3FORECL3),4,7)
			TRB3->FOREAMM3		:= TOTFOR3
			TRB3->VCONTRMG3		:= TOTVCON3
			TRB3->COGS3			:= TOTCOGS3
			TRB3->VCOMMISS3		:= TOTVCOM3
			
			TRB3->SALAMOU3		:= TOTSALA3
			TRB3->SALCONT3		:= TOTSALC3
			
		MsUnlock()
		
		TOTFOR3 		:= 0
		TOTVCON3		:= 0
		TOTCOGS3		:= 0
		TOTVCOM3		:= 0
		TOTSALA3		:= 0
		TOTSALC3		:= 0
		
	endif
	
enddo
RecLock("TRB3",.T.)
	TRB3->NPROP3		:= "TOTAL GERAL"
	TRB3->DFORECL3		:= LastDate(_dDataFim) 
	TRB3->CFORECL3		:= substr(dtoc(_dDataFim),4,7)
	TRB3->FOREAMM3		:= TGFOR3
	TRB3->VCONTRMG3		:= TGVCON3
	TRB3->COGS3			:= TGCOGS3
	TRB3->VCOMMISS3		:= TGVCOM3
	
	TRB3->SALAMOU3		:= TGSALAM3
	TRB3->SALCONT3		:= TGSALCO3
MsUnlock()
	
//TRB6->(dbclosearea())
QUERY2->(dbclosearea())


return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�												   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa o Project Status AT	/ EN	                      ���
����������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zBookSA()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("SZ9")
Local dData 		:= DDatabase
Local QUERY 		:= ""

Local TOTFOR4 		:= 0
Local TOTVCON4		:= 0
Local TOTCOGS4		:= 0
Local TOTVCOM4		:= 0

Local TGFOR4 		:= 0
Local TGVCON4		:= 0
Local TGCOGS4		:= 0
Local TGVCOM4		:= 0

Local TOTSALA4		:= 0
Local TOTSALC4		:= 0
Local TGSALAM4		:= 0
Local TGSALCO4		:= 0

Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0
Local nXTOTSI		:= 0
Local nXCUSTOT		:= 0
Local cEQUIPDES		:= ""
Local cFor2			:= ""

local cFiltra 	:= ""

cFiltra := " alltrim(XBOOK) == '3' .AND. alltrim(XPAIS) <> 'BRASIL' .AND. alltrim(XSTATUS) == '1'"
TRB6->(dbsetfilter({|| &(cFiltra)} , cFiltra))

TRB6->(dbgotop())

/****************SZF - DETALHES *****/

SZF->(dbsetorder(3)) 

ChkFile("SZF",.F.,"QUERY2") 

/*************************************/

while TRB6->(!eof())

		d1FORECL4 :=  substr(dtoc(LastDate(TRB6->XDTPREV)),1,10)

	
		MsProcTxt("Processando registro: "+alltrim(TRB6->XNPROP))
		ProcessMessage()
		
	
		if TRB6->XDTPREV <= _dDataIni
			TRB6->(dbskip())
			LOOP
		ENDIF
		
		if TRB6->XDTPREV >= _dDataFim
			TRB6->(dbskip())
			LOOP
		ENDIF
		
			
	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB4",.T.)
		TRB4->NPROP4		:= TRB6->XNPROP
		
		IF alltrim(TRB6->XBOOK) == "1" 
			TRB4->BOOK4	:= "GENERAL"
		ELSEIF alltrim(TRB6->XBOOK) == "2" 
			TRB4->BOOK4	:= "MARKETING PLATFORM"
		ELSEIF alltrim(TRB6->XBOOK) == "3" 
			TRB4->BOOK4	:= "BOOKING"
		ELSE
			TRB4->BOOK4	:= ""
		ENDIF
		
		if _cIdioma = 1
			IF TRB6->XTIPO == "1" 
				TRB4->FXBUD4	:= "FIXED"
			ELSEIF TRB6->XTIPO == "2" 
				TRB4->FXBUD4	:= "BUDGET"
			ELSEIF TRB6->XTIPO == "3" 
				TRB4->FXBUD4	:= "PROSPECTION"
			ENDIF
		else
			IF TRB6->XTIPO == "1" 
				TRB4->FXBUD4	:= "FIRME"
			ELSEIF TRB6->XTIPO == "2" 
				TRB4->FXBUD4	:= "ESTIMATIVA"
			ELSEIF TRB6->XTIPO == "3" 
				TRB4->FXBUD4	:= "PROSPECCAO"
			ENDIF
		endif
		
		if _cIdioma = 1
			IF ALLTRIM(TRB6->XTIPO) == "1"
				TRB4->FEAEXEC4 := "EXECUTION"
			ELSEIF ALLTRIM(TRB6->XTIPO) == "2"
				TRB4->FEAEXEC4 := "FEASIBILITY" 
			ELSEIF ALLTRIM(TRB6->XTIPO) == "3"
				TRB4->FEAEXEC4 := "FEASIBILITY" 
			ELSE
				TRB4->FEAEXEC4 := ""
			ENDIF
		else
			IF ALLTRIM(TRB6->XTIPO) == "1"
				TRB4->FEAEXEC4 := "EXECUCAO"
			ELSEIF ALLTRIM(TRB6->XTIPO) == "2"
				TRB4->FEAEXEC4 := "VIABILIDADE" 
			ELSEIF ALLTRIM(TRB6->XTIPO) == "3"
				TRB4->FEAEXEC4 := "VIABILIDADE" 
			ELSE
				TRB4->FEAEXEC4 := ""
			ENDIF
		endif
		
		
		if _cIdioma = 1
			IF ALLTRIM(TRB6->XSTATUS) == "1" 
				TRB4->STATUS4	:= "ACTIVE"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "2" 
				TRB4->STATUS4	:= "CANCELED"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "3" 
				TRB4->STATUS4	:= "DECLINED"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "4" 
				TRB4->STATUS4	:= "NOT SENT"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "5" 
				TRB4->STATUS4	:= "LOST"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "6" 
				TRB4->STATUS4	:= "SLC"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "7" 
				TRB4->STATUS4	:= "SOLD"
			ENDIF
		else
			IF ALLTRIM(TRB6->XSTATUS) == "1" 
				TRB4->STATUS4	:= "ATIVA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "2" 
				TRB4->STATUS4	:= "CANCELADA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "3" 
				TRB4->STATUS4	:= "DECLINADA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "4" 
				TRB4->STATUS4	:= "NAO ENVIADA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "5" 
				TRB4->STATUS4	:= "PERDIDA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "6" 
				TRB4->STATUS4	:= "SLC"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "7" 
				TRB4->STATUS4	:= "VENDIDA"
			ENDIF
		endif
		
		TRB4->OPPNAME4	:= TRB6->XCONTR
		TRB4->COUNTRY4	:= TRB6->XPAIS
		
		//TRB2->MARKSEC2	:= ""
		
		if _cIdioma = 1
			IF TRB6->XMERCADO == "1" 
				TRB4->MARKSEC4	:= "MINERALS"
			ELSEIF TRB6->XMERCADO == "2" 
				TRB4->MARKSEC4	:= "PULP PAPER"
			ELSEIF TRB6->XMERCADO == "3" 
				TRB4->MARKSEC4	:= "CHEMISTRY"
			ELSEIF TRB6->XMERCADO == "4" 
				TRB4->MARKSEC4	:= "FERTILIZER"
			ELSEIF TRB6->XMERCADO == "5" 
				TRB4->MARKSEC4	:= "SIDERURGY"
			ELSEIF TRB6->XMERCADO == "6" 
				TRB4->MARKSEC4	:= "MUNICIPAL"
			ELSEIF TRB6->XMERCADO == "7" 
				TRB4->MARKSEC4	:= "PETROCHEMICAL"
			ELSEIF TRB6->XMERCADO == "8" 
				TRB4->MARKSEC4	:= "FOODS"
			ELSEIF TRB6->XMERCADO == "9" 
				TRB4->MARKSEC4	:= "OTHERS"
			ENDIF
		else
			IF TRB6->XMERCADO == "1" 
				TRB4->MARKSEC4	:= "MINERACAO"
			ELSEIF TRB6->XMERCADO == "2" 
				TRB4->MARKSEC4	:= "PAPEL CELULOSE"
			ELSEIF TRB6->XMERCADO == "3" 
				TRB4->MARKSEC4	:= "QUIMICA"
			ELSEIF TRB6->XMERCADO == "4" 
				TRB4->MARKSEC4	:= "FETILIZANTES"
			ELSEIF TRB6->XMERCADO == "5" 
				TRB4->MARKSEC4	:= "SIDERURGIA"
			ELSEIF TRB6->XMERCADO == "6" 
				TRB4->MARKSEC4	:= "MUNICIPAL"
			ELSEIF TRB6->XMERCADO == "7" 
				TRB4->MARKSEC4	:= "PETROQUIMICA"
			ELSEIF TRB6->XMERCADO == "8" 
				TRB4->MARKSEC4	:= "ALIMENTOS"
			ELSEIF TRB6->XMERCADO == "9" 
				TRB4->MARKSEC4	:= "OUTROS"
			ENDIF
		endif
		
		TRB4->INDUSTR4	:= TRB6->XPRODUTO
		
		TRB4->SALPER4	:= UPPER(TRB6->XRESP)
		TRB4->SALREP4	:= UPPER(TRB6->XREPR)
		TRB4->CODEQ4	:= TRB6->CODEQ
		
		if _cIdioma = 1
			if !empty(alltrim(TRB6->XID))
				cEQUIPDES	:= TRB6->XEQUIP
			else
				/***************************/
				cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(TRB6->XNPROP) + "'"
					
				IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")
		
				ProcRegua(QUERY2->(reccount()))
					
				SZF->(dbgotop())
				
				while QUERY2->(!eof())
				
					if _cIdioma = 1
						if empty(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIPIN"))
							cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DIMENS) + " "
						else
							cEQUIPDES += " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIPIN")) + alltrim(QUERY2->ZF_DESCRI) + " "
						endif
					else
						cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DESCRI) + " "
					endif
					
					QUERY2->(dbskip())
		
				enddo	

				/*********************************/
			endif
		else
			if ! empty(alltrim(TRB6->XID))
				cEQUIPDES	:= TRB6->XEQUIP
			else
				/***************************/
				cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(TRB6->XNPROP) + "'"
					
				IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")
		
				ProcRegua(QUERY2->(reccount()))
					
				SZF->(dbgotop())
				
				while QUERY2->(!eof())
				
					if _cIdioma = 1
						if empty(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIP"))
							cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DIMENS) + " "
						else
							cEQUIPDES += " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIP")) + alltrim(QUERY2->ZF_DIMENS) + " "
						endif
					else
						cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DESCRI) + " "
					endif
					
					QUERY2->(dbskip())
		
				enddo	

				/*********************************/
			endif
		endif
		
		TRB4->EQUIPDES4	:= alltrim(cEQUIPDES)
	
		TRB4->DIMENS4	:= TRB6->XDIMENS
		TRB4->FORECL4	:= TRB6->XDTPREV
		TRB4->FOREAMM4	:= TRB6->XTOTSI
		/*
		nVCOMIS 		:= TRB6->XTOTSI * (TRB6->XPCOMIS/100)
		nCOGS			:= TRB6->XCUSTOT - nVCOMIS	
		nVCONTMG		:= TRB6->XTOTSI - nCOGS - nVCOMIS
		
		TRB4->COGS4		:= nCOGS
		TRB4->VCONTRMG4	:= nVCONTMG 
		TRB4->CONTRMG4	:= (nVCONTMG / TRB6->XTOTSI)*100 
		*/
		
				
		nVCOMIS 		:= TRB6->VCOMMISS 		//TRB6->XTOTSI * (TRB6->XPCOMIS/100)
		nCOGS			:= TRB6->XCOGS 			//TRB6->XCUSTOT - nVCOMIS	
		nVCONTMG		:= TRB6->VCONTRMG 		//TRB6->XTOTSI - nCOGS - nVCOMIS
		
		TRB4->COGS4		:= nCOGS
		TRB4->VCONTRMG4	:= nVCONTMG 
		TRB4->CONTRMG4	:= TRB6->PCONTRMG		//(nVCONTMG / TRB6->XTOTSI)*100 
		
		TRB4->COMMISS4	:= TRB6->XPCOMIS
		TRB4->VCOMMISS4	:= nVCOMIS
	
		TRB4->CFORECL4	:= substr(dtoc(TRB6->XDTPREV),4,7)
		TRB4->DFORECL4	:= TRB6->XDTPREV
		
		TRB4->PGET4		:= TRB6->XPGET
		TRB4->PGO4		:= TRB6->XPGO
		TRB4->SALAMOU4	:= TRB6->XSALAMOU
		TRB4->SALCONT4	:= TRB6->XSALCONT
		
		TRB4->ID4		:= TRB6->XID
	
		TOTFOR4 		+= TRB6->XTOTSI
		TOTVCON4		+= TRB6->VCONTRMG
		TOTCOGS4		+= TRB6->XCOGS
		TOTVCOM4		+= TRB6->VCOMMISS
		TOTSALA4		+= TRB6->XSALAMOU
		TOTSALC4		+= TRB6->XSALCONT
		
		TGFOR4 			+= TRB6->XTOTSI
		TGVCON4			+= TRB6->VCONTRMG
		TGCOGS4			+= TRB6->VCOMMISS
		TGVCOM4			+= TRB6->VCOMMISS
		TGSALAM4		+= TRB6->XSALAMOU
		TGSALCO4		+= TRB6->XSALCONT
				
		MsUnlock()
				
		x3FORECL4 :=  TRB6->XDTPREV
	
	TRB6->(dbskip())
	cEQUIPDES := ""
	
	d2FORECL4 :=   substr(dtoc(LastDate(TRB6->XDTPREV)),1,10) 
	

	if d1FORECL4  <> d2FORECL4
		RecLock("TRB4",.T.)
			TRB4->NPROP4		:= "TOTAL"
			TRB4->DFORECL4		:= LastDate(x3FORECL4) 
			TRB4->CFORECL4		:= substr(dtoc(x3FORECL4),4,7)
			TRB4->FOREAMM4		:= TOTFOR4
			TRB4->VCONTRMG4		:= TOTVCON4
			TRB4->COGS4			:= TOTCOGS4
			TRB4->VCOMMISS4		:= TOTVCOM4
			
			TRB4->SALAMOU4		:= TOTSALA4
			TRB4->SALCONT4		:= TOTSALC4
			
		MsUnlock()
		
		TOTFOR4 		:= 0
		TOTVCON4		:= 0
		TOTCOGS4		:= 0
		TOTVCOM4		:= 0
		TOTSALA4		:= 0
		TOTSALC4		:= 0
		
	endif
	
enddo
RecLock("TRB4",.T.)
	TRB4->NPROP4		:= "TOTAL GERAL"
	TRB4->DFORECL4		:= LastDate(_dDataFim) 
	TRB4->CFORECL4		:= substr(dtoc(_dDataFim),4,7)
	TRB4->FOREAMM4		:= TGFOR4
	TRB4->VCONTRMG4		:= TGVCON4
	TRB4->COGS4			:= TGCOGS4
	TRB4->VCOMMISS4		:= TGVCOM4
	
	TRB4->SALAMOU4		:= TGSALAM4
	TRB4->SALCONT4		:= TGSALCO4
MsUnlock()
	
//TRB6->(dbclosearea())
QUERY2->(dbclosearea())

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

static function zBookTT()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("SZ9")
Local dData 		:= DDatabase
Local QUERY 		:= ""

Local TOTFOR5 		:= 0
Local TOTVCON5		:= 0
Local TOTCOGS5		:= 0
Local TOTVCOM5		:= 0

Local TGFOR5 		:= 0
Local TGVCON5		:= 0
Local TGCOGS5		:= 0
Local TGVCOM5		:= 0

Local TOTSALA5		:= 0
Local TOTSALC5		:= 0
Local TGSALAM5		:= 0
Local TGSALCO5		:= 0

Local x1FORECL5		:= ""
Local x2FORECL5		:= ""
local cFiltra 	:= ""

Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0
Local nXTOTSI		:= 0
Local nXCUSTOT		:= 0
Local cEQUIPDES		:= ""
Local cFor2			:= ""

cFiltra := " alltrim(XBOOK) == '3' .AND. alltrim(XSTATUS) == '1'"
TRB6->(dbsetfilter({|| &(cFiltra)} , cFiltra))

TRB6->(dbgotop())

TRB5->(dbgotop())

/****************SZF - DETALHES *****/

SZF->(dbsetorder(3)) 

ChkFile("SZF",.F.,"QUERY2") 

/*************************************/

do while  TRB6->(!eof())
	
		d1FORECL5 :=  substr(dtoc(LastDate(TRB6->XDTPREV)),1,10)
		
	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(TRB6->XNPROP))
		ProcessMessage()
		
		IF ALLTRIM(TRB6->XSTATUS) $ "2/3/4/5/6/7"
			TRB6->(dbskip())
			LOOP
		ENDIF
		/*
		IF !ALLTRIM(TRB6->XBOOK) $ "3"
			TRB6->(dbskip())
			LOOP
		ENDIF
		
		if QUERY->Z9_DTPREV <= MV_PAR01
			QUERY->(dbskip())
			LOOP
		ENDIF
		
		if QUERY->Z9_DTPREV >= MV_PAR02
			QUERY->(dbskip())
			LOOP
		ENDIF
		*/
	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB5",.T.)

		TRB5->NPROP5		:= TRB6->XNPROP
		
		IF alltrim(TRB6->XBOOK) == "1" 
			TRB5->BOOK5	:= "GENERAL"
		ELSEIF alltrim(TRB6->XBOOK) == "2" 
			TRB5->BOOK5	:= "MARKETING PLATFORM"
		ELSEIF alltrim(TRB6->XBOOK) == "3" 
			TRB5->BOOK5	:= "BOOKING"
		ELSE
			TRB5->BOOK5	:= ""
		ENDIF
		
		if _cIdioma = 1
			IF TRB6->XTIPO == "1" 
				TRB5->FXBUD5	:= "FIXED"
			ELSEIF TRB6->XTIPO == "2" 
				TRB5->FXBUD5	:= "BUDGET"
			ELSEIF TRB6->XTIPO == "3" 
				TRB5->FXBUD5	:= "PROSPECTION"
			ENDIF
		else
			IF TRB6->XTIPO == "1" 
				TRB5->FXBUD5	:= "FIRME"
			ELSEIF TRB6->XTIPO == "2" 
				TRB5->FXBUD5	:= "ESTIMATIVA"
			ELSEIF TRB6->XTIPO == "3" 
				TRB5->FXBUD5	:= "PROSPECCAO"
			ENDIF
		endif
		
		if _cIdioma = 1
			IF ALLTRIM(TRB6->XTIPO) == "1"
				TRB5->FEAEXEC5 := "EXECUTION"
			ELSEIF ALLTRIM(TRB6->XTIPO) == "2"
				TRB5->FEAEXEC5 := "FEASIBILITY" 
			ELSEIF ALLTRIM(TRB6->XTIPO) == "3"
				TRB5->FEAEXEC5 := "FEASIBILITY" 
			ELSE
				TRB5->FEAEXEC5 := ""
			ENDIF
		else
			IF ALLTRIM(TRB6->XTIPO) == "1"
				TRB5->FEAEXEC5 := "EXECUCAO"
			ELSEIF ALLTRIM(TRB6->XTIPO) == "2"
				TRB5->FEAEXEC5 := "VIABILIDADE" 
			ELSEIF ALLTRIM(TRB6->XTIPO) == "3"
				TRB5->FEAEXEC5 := "VIABILIDADE" 
			ELSE
				TRB5->FEAEXEC5 := ""
			ENDIF
		endif
		
		if _cIdioma = 1
			IF ALLTRIM(TRB6->XSTATUS) == "1" 
				TRB5->STATUS5	:= "ACTIVE"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "2" 
				TRB5->STATUS5	:= "CANCELED"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "3" 
				TRB5->STATUS5	:= "DECLINED"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "4" 
				TRB5->STATUS5	:= "NOT SENT"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "5" 
				TRB5->STATUS5	:= "LOST"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "6" 
				TRB5->STATUS5	:= "SLC"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "7" 
				TRB5->STATUS5	:= "SOLD"
			ENDIF
		else
			IF ALLTRIM(TRB6->XSTATUS) == "1" 
				TRB5->STATUS5	:= "ATIVA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "2" 
				TRB5->STATUS5	:= "CANCELADA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "3" 
				TRB5->STATUS5	:= "DECLINADA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "4" 
				TRB5->STATUS5	:= "NAO ENVIADA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "5" 
				TRB5->STATUS5	:= "PERDIDA"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "6" 
				TRB5->STATUS5	:= "SLC"
			ELSEIF ALLTRIM(TRB6->XSTATUS) == "7" 
				TRB5->STATUS5	:= "VENDIDA"
			ENDIF
		endif
		
		TRB5->OPPNAME5	:= TRB6->XCONTR
		TRB5->COUNTRY5	:= TRB6->XPAIS
		
		//TRB2->MARKSEC2	:= ""
		if _cIdioma = 1
			IF TRB6->XMERCADO == "1" 
				TRB5->MARKSEC5	:= "MINERALS"
			ELSEIF TRB6->XMERCADO == "2" 
				TRB5->MARKSEC5	:= "PULP PAPER"
			ELSEIF TRB6->XMERCADO == "3" 
				TRB5->MARKSEC5	:= "CHEMISTRY"
			ELSEIF TRB6->XMERCADO == "4" 
				TRB5->MARKSEC5	:= "FERTILIZER"
			ELSEIF TRB6->XMERCADO == "5" 
				TRB5->MARKSEC5	:= "SIDERURGY"
			ELSEIF TRB6->XMERCADO == "6" 
				TRB5->MARKSEC5	:= "MUNICIPAL"
			ELSEIF TRB6->XMERCADO == "7" 
				TRB5->MARKSEC5	:= "PETROCHEMICAL"
			ELSEIF TRB6->XMERCADO == "8" 
				TRB5->MARKSEC5	:= "FOODS"
			ELSEIF TRB6->XMERCADO == "9" 
				TRB5->MARKSEC5	:= "OTHERS"
			ENDIF
		else
			IF TRB6->XMERCADO == "1" 
				TRB5->MARKSEC5	:= "MINERACAO"
			ELSEIF TRB6->XMERCADO == "2" 
				TRB5->MARKSEC5	:= "CELULOSE"
			ELSEIF TRB6->XMERCADO == "3" 
				TRB5->MARKSEC5	:= "QUIMICA"
			ELSEIF TRB6->XMERCADO == "4" 
				TRB5->MARKSEC5	:= "FETILIZANTES"
			ELSEIF TRB6->XMERCADO == "5" 
				TRB5->MARKSEC5	:= "SIDERURGIA"
			ELSEIF TRB6->XMERCADO == "6" 
				TRB5->MARKSEC5	:= "MUNICIPAL"
			ELSEIF TRB6->XMERCADO == "7" 
				TRB5->MARKSEC5	:= "PETROQUIMICA"
			ELSEIF TRB6->XMERCADO == "8" 
				TRB5->MARKSEC5	:= "ALIMENTOS"
			ELSEIF TRB6->XMERCADO == "9" 
				TRB5->MARKSEC5	:= "OUTROS"
			ENDIF
		endif
		
		TRB5->INDUSTR5	:= TRB6->XPRODUTO
		
		TRB5->SALPER5	:= UPPER(TRB6->XRESP)
		TRB5->SALREP5	:= UPPER(TRB6->XREPR)
		TRB5->CODEQ5	:= TRB6->CODEQ
		
		if _cIdioma = 1
			if !empty(alltrim(TRB6->XID))
				cEQUIPDES	:= TRB6->XEQUIP
			else
				/***************************/
				cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(TRB6->XNPROP) + "'"
					
				IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")
		
				ProcRegua(QUERY2->(reccount()))
					
				SZF->(dbgotop())
				
				while QUERY2->(!eof())
				
					if _cIdioma = 1
						if empty(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIPIN"))
							cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DIMENS) + " "
						else
							cEQUIPDES += " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIPIN")) + alltrim(QUERY2->ZF_DESCRI) + " "
						endif
					else
						cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DESCRI) + " "
					endif
					
					QUERY2->(dbskip())
		
				enddo	

				/*********************************/
			endif
		else
			if ! empty(alltrim(TRB6->XID))
				cEQUIPDES	:= TRB6->XEQUIP
			else
				/***************************/
				cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(TRB6->XNPROP) + "'"
					
				IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")
		
				ProcRegua(QUERY2->(reccount()))
					
				SZF->(dbgotop())
				
				while QUERY2->(!eof())
				
					if _cIdioma = 1
						if empty(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIP"))
							cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DIMENS) + " "
						else
							cEQUIPDES += " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(Posicione("SZA",1,xFilial("SZA") + alltrim(QUERY2->ZF_CODPROD),"ZA_EQUIP")) + alltrim(QUERY2->ZF_DIMENS) + " "
						endif
					else
						cEQUIPDES	+= " " + cValtoChar(QUERY2->ZF_QUANT) + " " + alltrim(QUERY2->ZF_DESCRI) + " " + alltrim(QUERY2->ZF_DESCRI) + " "
					endif
					
					QUERY2->(dbskip())
		
				enddo	

				/*********************************/
			endif
		endif
		
		TRB5->EQUIPDES5	:= alltrim(cEQUIPDES)

		TRB5->DIMENS5	:= TRB6->XDIMENS
		TRB5->FORECL5	:= TRB6->XDTPREV
		TRB5->FOREAMM5	:= TRB6->XTOTSI
		
		/*
		nVCOMIS 		:= TRB6->XTOTSI * (TRB6->XPCOMIS/100)
		nCOGS			:= TRB6->XCUSTOT - nVCOMIS	
		nVCONTMG		:= TRB6->XTOTSI - nCOGS - nVCOMIS
		
		TRB5->COGS5		:= nCOGS
		TRB5->VCONTRMG5	:= nVCONTMG 
		TRB5->CONTRMG5	:= (nVCONTMG / TRB6->XTOTSI)*100 
		
		*/

		nVCOMIS 		:= TRB6->VCOMMISS 		//TRB6->XTOTSI * (TRB6->XPCOMIS/100)
		nCOGS			:= TRB6->XCOGS 			//TRB6->XCUSTOT - nVCOMIS	
		nVCONTMG		:= TRB6->VCONTRMG 		//TRB6->XTOTSI - nCOGS - nVCOMIS
		
		TRB5->COGS5		:= nCOGS
		TRB5->VCONTRMG5	:= nVCONTMG 
		TRB5->CONTRMG5	:= TRB6->PCONTRMG		//(nVCONTMG / TRB6->XTOTSI)*100 
		
		TRB5->COMMISS5	:= TRB6->XPCOMIS
		TRB5->VCOMMISS5	:= nVCOMIS
		
		TRB5->CFORECL5	:= substr(dtoc(TRB6->XDTPREV),4,7)
		TRB5->DFORECL5	:= TRB6->XDTPREV
		
		TRB5->PGET5		:= TRB6->XPGET
		TRB5->PGO5		:= TRB6->XPGO
		TRB5->SALAMOU5	:= TRB6->XSALAMOU
		TRB5->SALCONT5	:= TRB6->XSALCONT
		
		TRB5->ID5		:= TRB6->XID
	
		TOTFOR5 		+= TRB6->XTOTSI
		TOTVCON5		+= TRB6->VCONTRMG
		TOTCOGS5		+= TRB6->XCOGS
		TOTVCOM5		+= TRB6->VCOMMISS
		TOTSALA5		+= TRB6->XSALAMOU
		TOTSALC5		+= TRB6->XSALCONT
		
		TGFOR5 			+= TRB6->XTOTSI
		TGVCON5			+= TRB6->VCONTRMG
		TGCOGS5			+= TRB6->VCOMMISS
		TGVCOM5			+= TRB6->VCOMMISS
		TGSALAM5		+= TRB6->XSALAMOU
		TGSALCO5		+= TRB6->XSALCONT
				
		MsUnlock()
				
		x3FORECL5 :=  TRB6->XDTPREV
	
	TRB6->(dbskip())
	cEQUIPDES := ""
	
	d2FORECL5 :=   substr(dtoc(LastDate(TRB6->XDTPREV)),1,10) 
	

	if d1FORECL5  <> d2FORECL5
		RecLock("TRB5",.T.)
			TRB5->NPROP5		:= "TOTAL"
			TRB5->DFORECL5		:= LastDate(x3FORECL5) 
			TRB5->CFORECL5		:= substr(dtoc(x3FORECL5),4,7)
			TRB5->FOREAMM5		:= TOTFOR5
			TRB5->VCONTRMG5		:= TOTVCON5
			TRB5->COGS5			:= TOTCOGS5
			TRB5->VCOMMISS5		:= TOTVCOM5
			
			TRB5->SALAMOU5		:= TOTSALA5
			TRB5->SALCONT5		:= TOTSALC5
			
		MsUnlock()
		
		TOTFOR5 		:= 0
		TOTVCON5		:= 0
		TOTCOGS5		:= 0
		TOTVCOM5		:= 0
		TOTSALA5		:= 0
		TOTSALC5		:= 0
		
	endif
	
enddo
RecLock("TRB5",.T.)
	TRB5->NPROP5		:= "TOTAL GERAL"
	TRB5->DFORECL5		:= LastDate(_dDataFim) 
	TRB5->CFORECL5		:= substr(dtoc(_dDataFim),4,7)
	TRB5->FOREAMM5		:= TGFOR5
	TRB5->VCONTRMG5		:= TGVCON5
	TRB5->COGS5			:= TGCOGS5
	TRB5->VCOMMISS5		:= TGVCOM5
	
	TRB5->SALAMOU5		:= TGSALAM5
	TRB5->SALCONT5		:= TGSALCO5
MsUnlock()
	
//TRB6->(dbclosearea())
QUERY2->(dbclosearea())

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
	  	ITEMS "General list of proposals", "Spare parts & Field service","Marketing Platform", "Booking BR","Booking SA","Booking Total",;
	  	"Sold / Active / Lost Graph (1)" ;
	  	,"Marketing Platform Graph", "Booking BR / SA / Total Graph" COLORS 0, 16777215 PIXEL
else
	@ aPosObj2[1,1],aPosObj2[1,2] FOLDER oFolder1 SIZE  aPosObj2[1,4],aPosObj2[1,3]-35 OF _oDlgSint ;
	  	ITEMS "Lista geral de propostas", "Previsao - Pecas de reposicao e servico de campo","Plataforma de Marketing", "Vendas (Booking) BR";
	  	,"Vendas (Booking) SA","Vendas (Booking) Total","Vendidas / Ativas / Perdidas Grafico (1)" ;
	  	,"Plataforma de Marketing Grafico", "Vendas BR / SA / Total Grafico" COLORS 0, 16777215 PIXEL
endif

tGerPro()
tPrevSP()
tMarkPl()
tBookBr()
tBookSA()
tBookTT()
zGrafVD()
zGrafMKP()
zGrafBBR()

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
	aadd(aHeader, {"Forecast Amount"						,"FOREAMM"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Contrib. Margin"						,"CONTRMG"	,"@E 999.99"		,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Contrib. Margin"						,"VCONTRMG"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Cogs"									,"COGS"		,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Commission"							,"COMMISS"	,"@E 999.99"		,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Commission"								,"VCOMMISS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL1"	,""					,7,0,""			,"","C","TRB1",""})
	
else
	aadd(aHeader, {"  Numero Proposta"						,"NPROP"	,""					,10,0,""		,"","C","TRB1","Proposal Number"})
	aadd(aHeader, {"Vendas"									,"BOOK"		,""					,15,0,""		,"","C","TRB1",""})
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
	aadd(aHeader, {"Venda s/ Trib."							,"FOREAMM"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Margem Contrib."						,"CONTRMG"	,"@E 999.99"		,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Margem Contrib."						,"VCONTRMG"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Cogs"									,"COGS"		,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"% Comissao"								,"COMMISS"	,"@E 999.99"		,15,2,""		,"","N","TRB1",""})
	aadd(aHeader, {"Comissao"								,"VCOMMISS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL1"	,""					,7,0,""			,"","C","TRB1",""})
	//aadd(aHeader, {"Forecast Close"							,"DFORECL1"	,""					,08,0,""		,"","D","TRB1","R"})
endif

@ 005 , 0010 BUTTON 'Filtro'   Size 60, 12 action(zFGProp()) of oFolder1:aDialogs[1] Pixel  
@ 005 , 0080 BUTTON 'Limpar Filtro'   Size 60, 12 action(zLimpFil()) of oFolder1:aDialogs[1] Pixel 


_oGetDbSint := MsGetDb():New(aPosObj[1,1]-13,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB1",,,,oFolder1:aDialogs[1])

_oGetDbSint:oBrowse:BlDblClick := {|| EditTRB1() }


aadd(aButton , { "BMPTABLE3" , { || zAtualizar()}, "Reprocessar Booking " } )
aadd(aButton , { "BMPTABLE3" , { || zExpComiss()}, "Export.Excel " } )
//aadd(aButton , { "BMPTABLE3" , { || ShowAnalit()}, "Geral " } )
//aadd(aButton , { "BMPTABLE3" , { || zTotalMPP()}, "No.Prop.MKP " } )
//aadd(aButton , { "BMPTABLE3" , { || zTotalBBR()}, "No.Booking BR/SA/Total " } )
//aadd(aButton , { "BMPTABLE3" , { || zTotalTVD()}, "No.Prop.Vendidas/Activas/Perdidas " } )
aadd(aButton , { "BMPTABLE3" , { || zPrnGSAL()}, "Imp.Graf.1 " } )

_oGetDbSint:ForceRefresh()
return

/********************************/
/* TELA PECAS E SERVICOS 		*/
/********************************/
Static Function tPrevSP()

if _cIdioma = 1
	aadd(aHeader, {"  Proposal Number"						,"NPROP7"	,""					,10,0,""		,"","C","TRB7","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK7"	,""					,15,0,""		,"","C","TRB7",""})
	//aadd(aHeader, {"Status"									,"STATUS7"	,""					,13,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Fixed / Budget"							,"FXBUD7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Feasibility Execution"					,"FEAEXEC7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Opportunity Name"						,"OPPNAME7"	,""					,30,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Country"								,"COUNTRY7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Market Sector"							,"MARKSEC7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Industry"								,"INDUSTR7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Sales Person"							,"SALPER7"	,""					,30,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Sales Representantive"					,"SALREP7"	,""					,30,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Equipment Description"					,"EQUIPDES7",""					,30,0,""		,"","C","TRB7",""})
	//aadd(aHeader, {"Dimensions"								,"DIMENS7"	,""					,15,0,""		,"","C","TRB7",""})
	//aadd(aHeader, {"Forecast Close"							,"FORECL7"	,""					,08,0,""		,"","D","TRB7","R"})
	aadd(aHeader, {"Forecast Close"							,"CFORECL7"	,""					,7,0,""			,"","C","TRB7",""})
	aadd(aHeader, {"Forecast Amount"						,"FOREAMM7"	,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"% Contrib. Margin"						,"CONTRMG7"	,"@E 999.99"		,15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"Contrib. Margin"						,"VCONTRMG7","@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"Cogs"									,"COGS7"	,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"% Commission"							,"COMMISS7"	,"@E 999.99"		,15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"Commission"								,"VCOMMISS7","@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"% Get"									,"PGET7"	,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"% Go"									,"PGO7"		,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"Sales Phase Amount"						,"SALAMOU7"	,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"Sales Phase Contribution"				,"SALCONT7"	,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	//aadd(aHeader, {"Comments"								,"COMMENT3"	,""					,40,0,""		,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"						,"CFORECL3"	,""					,7,0,""			,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"						,"DFORECL3"	,""					,08,0,""		,"","D","TRB3","R"})
	aadd(aHeader, {"ID"										,"ID7"		,""					,10,0,""		,"","C","TRB7",""})
else
	aadd(aHeader, {"  Numero Proposta"						,"NPROP7"	,""					,10,0,""		,"","C","TRB7","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK7"	,""					,15,0,""		,"","C","TRB7",""})
	//aadd(aHeader, {"Status"								,"STATUS7"	,""					,13,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Firme / Estimativa"						,"FXBUD7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Viabilidade / Execucao"					,"FEAEXEC7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Oportunidade"							,"OPPNAME7"	,""					,30,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Pais"									,"COUNTRY7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Mercado"								,"MARKSEC7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Produto"								,"INDUSTR7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Responsavel"							,"SALPER7"	,""					,30,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Representante Vendas"					,"SALREP7"	,""					,30,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Equipamento"							,"EQUIPDES7",""					,30,0,""		,"","C","TRB7",""})
	//aadd(aHeader, {"Dimens�es"								,"DIMENS7"	,""					,15,0,""		,"","C","TRB7",""})
	aadd(aHeader, {"Prev.Vendas"							,"FORECL7"	,""					,08,0,""		,"","D","TRB7","R"})
	aadd(aHeader, {"Venda s/ Trib."							,"FOREAMM7"	,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"% Magem Contrib."						,"CONTRMG7"	,"@E 999.99"		,15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"Margem Contrib."						,"VCONTRMG7","@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"Cogs"									,"COGS7"	,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"% Comissao"								,"COMMISS7"	,"@E 999.99"		,15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"Comissao"								,"VCOMMISS7","@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"% Get"									,"PGET7"	,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"% Go"									,"PGO7"		,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"Sales Phase Amount"						,"SALAMOU7"	,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	aadd(aHeader, {"Sales Phase Contribution"				,"SALCONT7"	,"@E 999,999,999.99",15,2,""		,"","N","TRB7",""})
	//aadd(aHeader, {"Comments"								,"COMMENT3"	,""					,40,0,""		,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"						,"CFORECL3"	,""					,7,0,""			,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"						,"DFORECL3"	,""					,08,0,""		,"","D","TRB3","R"})
	aadd(aHeader, {"ID"										,"ID7"		,""					,10,0,""		,"","C","TRB7",""})
endif

_oGetDbSint7 := MsGetDb():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB7",,,,oFolder1:aDialogs[2])
_oGetDbSint7:oBrowse:BlDblClick := {|| EditTRB7() }

_oGetDbSint7:ForceRefresh()


// COR DA FONTE
_oGetDbSint7:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor7(1)}
// COR DA LINHA
_oGetDbSint7:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor7(2)} //Cor da Linha


return

/********************************/
/* TELA MARKETING PLATAFORMA	*/
/********************************/
Static Function tMarkPl()

if _cIdioma = 1
	aadd(aHeader, {"  Proposal Number"						,"NPROP2"	,""					,10,0,""		,"","C","TRB2","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Status"									,"STATUS2"	,""					,10,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Fixed / Budget"							,"FXBUD2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Feasibility Execution"					,"FEAEXEC2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Opportunity Name"						,"OPPNAME2"	,""					,30,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Country"								,"COUNTRY2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Market Sector"							,"MARKSEC2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Industry"								,"INDUSTR2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Sales Person"							,"SALPER2"	,""					,30,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Sales Representantive"					,"SALREP2"	,""					,30,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Equipment Description"					,"EQUIPDES2",""					,30,0,""		,"","C","TRB2",""})
	//aadd(aHeader, {"Dimensions"								,"DIMENS2"	,""					,20,0,""		,"","C","TRB2",""})
	//aadd(aHeader, {"Forecast Close"							,"FORECL2"	,""					,08,0,""		,"","D","TRB2","R"})
	aadd(aHeader, {"Forecast Close"							,"CFORECL2"	,""					,7,0,""			,"","C","TRB2",""})
	aadd(aHeader, {"Forecast Amount"						,"FOREAMM2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"% Contrib. Margin"						,"CONTRMG2"	,"@E 999.99"		,15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"Contribution Margin"					,"VCONTRMG2","@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"Cogs"									,"COGS2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"% Commission"							,"COMMISS2"	,"@E 999.99"		,15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"Commission"								,"VCOMMISS2","@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"% Get"									,"PGET2"	,"@E 999.99"		,15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"% Go"									,"PGO2"		,"@E 999.99"		,15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"Sales Phase Amount"						,"SALAMOU2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"Sales Phase Contribution"				,"SALCONT2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL2"	,""					,7,0,""			,"","C","TRB2",""})
	//aadd(aHeader, {"Forecast Close"							,"DFORECL2"	,""					,08,0,""		,"","D","TRB2","R"})
else
	aadd(aHeader, {"  Numero Proposta"						,"NPROP2"	,""					,10,0,""		,"","C","TRB2","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Status"									,"STATUS2"	,""					,10,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Firme / Estimativa"						,"FXBUD2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Viabilidade / Execucao"					,"FEAEXEC2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Oportunidade"							,"OPPNAME2"	,""					,30,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Pais"									,"COUNTRY2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Mercado"								,"MARKSEC2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Produto"								,"INDUSTR2"	,""					,15,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Responsavel"							,"SALPER2"	,""					,30,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Representante Vendas"					,"SALREP2"	,""					,30,0,""		,"","C","TRB2",""})
	aadd(aHeader, {"Equipamento"							,"EQUIPDES2",""					,30,0,""		,"","C","TRB2",""})
	//aadd(aHeader, {"Dimens�es"								,"DIMENS2"	,""					,15,0,""		,"","C","TRB2",""})
	//aadd(aHeader, {"Prev. Venda"							,"FORECL2"	,""					,08,0,""		,"","D","TRB2","R"})
	aadd(aHeader, {"Prev. Venda"							,"CFORECL2"	,""					,7,0,""			,"","C","TRB2",""})
	aadd(aHeader, {"Venda s/ Trib."							,"FOREAMM2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"% Margem Contrib."						,"CONTRMG2"	,"@E 999.99"		,15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"Margem Contrib."						,"VCONTRMG2","@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"Cogs"									,"COGS2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"% Comissao"								,"COMMISS2"	,"@E 999.99"		,15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"Comissao"								,"VCOMMISS2","@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"% Get"									,"PGET2"	,"@E 999.99"		,15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"% Go"									,"PGO2"		,"@E 999.99"		,15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"Montante Vendas"						,"SALAMOU2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	aadd(aHeader, {"Montante Coontrib."						,"SALCONT2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL2"	,""					,7,0,""			,"","C","TRB2",""})
	//aadd(aHeader, {"Forecast Close"							,"DFORECL2"	,""					,08,0,""		,"","D","TRB2","R"})
endif

_oGetDbSint2 := MsGetDb():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2",,,,oFolder1:aDialogs[3])
_oGetDbSint2:oBrowse:BlDblClick := {|| EditTRB2() }

_oGetDbSint2:ForceRefresh()


// COR DA FONTE
_oGetDbSint2:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor2(1)}
// COR DA LINHA
_oGetDbSint2:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor2(2)} //Cor da Linha

return


/*********************************************************/

Static Function tBookBr()

if _cIdioma = 1
	aadd(aHeader, {"  Proposal Number"						,"NPROP3"	,""					,10,0,""		,"","C","TRB3","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Status"									,"STATUS3"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Fixed / Budget"							,"FXBUD3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Feasibility Execution"					,"FEAEXEC3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Opportunity Name"						,"OPPNAME3"	,""					,30,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Country"								,"COUNTRY3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Market Sector"							,"MARKSEC3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Industry"								,"INDUSTR3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Sales Person"							,"SALPER3"	,""					,30,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Sales Representantive"					,"SALREP3"	,""					,30,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Equipment Description"					,"EQUIPDES3",""					,30,0,""		,"","C","TRB3",""})
	//aadd(aHeader, {"Dimensions"								,"DIMENS3"	,""					,15,0,""		,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"							,"FORECL3"	,""					,08,0,""		,"","D","TRB3","R"})
	aadd(aHeader, {"Forecast Close"							,"CFORECL3"	,""					,7,0,""			,"","C","TRB3",""})
	aadd(aHeader, {"Forecast Amount"						,"FOREAMM3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"% Contrib. Margin"						,"CONTRMG3"	,"@E 999.99"		,15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"Contrib. Margin"						,"VCONTRMG3","@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"Cogs"									,"COGS3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"% Commission"							,"COMMISS3"	,"@E 999.99"		,15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"Commission"								,"VCOMMISS3","@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"% Get"									,"PGET3"	,"@E 999.99"		,15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"% Go"									,"PGO3"		,"@E 999.99"		,15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"Sales Phase Amount"						,"SALAMOU3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"Sales Phase Contribution"				,"SALCONT3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	//aadd(aHeader, {"Comments"								,"COMMENT3"	,""					,40,0,""		,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL3"	,""					,7,0,""			,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"							,"DFORECL3"	,""					,08,0,""		,"","D","TRB3","R"})
else
	aadd(aHeader, {"  Numero Proposta"						,"NPROP3"	,""					,10,0,""		,"","C","TRB3","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Status"									,"STATUS3"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Firme / Estimativa"						,"FXBUD3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Viabilidade / Execucao"					,"FEAEXEC3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Oportunidade"							,"OPPNAME3"	,""					,30,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Pais"									,"COUNTRY3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Mercado"								,"MARKSEC3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Produto"								,"INDUSTR3"	,""					,15,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Responsavel"							,"SALPER3"	,""					,30,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Representante Vendas"					,"SALREP3"	,""					,30,0,""		,"","C","TRB3",""})
	aadd(aHeader, {"Equipamento"							,"EQUIPDES3",""					,30,0,""		,"","C","TRB3",""})
	//aadd(aHeader, {"Dimens�es"								,"DIMENS3"	,""					,15,0,""		,"","C","TRB3",""})
	//aadd(aHeader, {"Prev. Vendas"							,"FORECL3"	,""					,08,0,""		,"","D","TRB3","R"})
	aadd(aHeader, {"Prev. Vendas"							,"CFORECL3"	,""					,7,0,""			,"","C","TRB3",""})
	aadd(aHeader, {"Vendas s/ Trib."						,"FOREAMM3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"% Margem Contrib."						,"CONTRMG3"	,"@E 999.99"		,15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"Margem Contrib."						,"VCONTRMG3","@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"Cogs"									,"COGS3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"% Comissao"								,"COMMISS3"	,"@E 999.99"		,15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"Comissao"								,"VCOMMISS3","@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"% Get"									,"PGET3"	,"@E 999.99"		,15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"% Go"									,"PGO3"		,"@E 999.99"		,15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"Montante Vendas"						,"SALAMOU3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	aadd(aHeader, {"Montante Coontrib."						,"SALCONT3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
	//aadd(aHeader, {"Comments"								,"COMMENT3"	,""					,40,0,""		,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL3"	,""					,7,0,""			,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"							,"DFORECL3"	,""					,08,0,""		,"","D","TRB3","R"})
endif

_oGetDbSint3 := MsGetDb():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB3",,,,oFolder1:aDialogs[4])
_oGetDbSint3:oBrowse:BlDblClick := {|| EditTRB3() }

_oGetDbSint3:ForceRefresh()

// COR DA FONTE
_oGetDbSint3:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor3(1)}
// COR DA LINHA
_oGetDbSint3:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor3(2)} //Cor da Linha

return
/*********************************************************/
Static Function tBookSA()

if _cIdioma = 1
	aadd(aHeader, {"  Proposal Number"						,"NPROP4"	,""					,10,0,""		,"","C","TRB4","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Status"									,"STATUS4"	,""					,10,0,""		,"","C","TRB1",""})
	aadd(aHeader, {"Fixed / Budget"							,"FXBUD4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Feasibility Execution"					,"FEAEXEC4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Opportunity Name"						,"OPPNAME4"	,""					,30,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Country"								,"COUNTRY4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Market Sector"							,"MARKSEC4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Industry"								,"INDUSTR4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Sales Person"							,"SALPER4"	,""					,30,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Sales Representantive"					,"SALREP4"	,""					,30,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Equipment Description"					,"EQUIPDES4",""					,30,0,""		,"","C","TRB4",""})
	//aadd(aHeader, {"Dimensions"								,"DIMENS4"	,""					,15,0,""		,"","C","TRB4",""})
	//aadd(aHeader, {"Forecast Close"							,"FORECL4"	,""					,08,0,""		,"","D","TRB4","R"})
	aadd(aHeader, {"Forecast Close"							,"CFORECL4"	,""					,7,0,""			,"","C","TRB4",""})
	aadd(aHeader, {"Forecast Amount"						,"FOREAMM4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"% Contrib. Margin"						,"CONTRMG4"	,"@E 999.99",15,2	,""				,"","N","TRB4",""})
	aadd(aHeader, {"Contrib Margin"							,"VCONTRMG4","@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"Cogs"									,"COGS4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"% Commission"							,"COMMISS4"	,"@E 999.99"		,15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"Commission"								,"VCOMMISS4","@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"% Get"									,"PGET4"	,"@E 999.99"		,15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"% Go"									,"PGO4"		,"@E 999.99"		,15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"Sales Phase Amount"						,"SALAMOU4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"Sales Phase Contribution"				,"SALCONT4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	//aadd(aHeader, {"Comments"								,"COMMENT4"	,""					,40,0,""		,"","C","TRB4",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL4"	,""					,7,0,""			,"","C","TRB4",""})
	//aadd(aHeader, {"Forecast Close"							,"DFORECL4"	,""					,08,0,""		,"","D","TRB4","R"})
else
	aadd(aHeader, {"  Numero Proposta"						,"NPROP4"	,""					,10,0,""		,"","C","TRB4","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Status"									,"STATUS4"	,""					,10,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Firme / Estimativa"						,"FXBUD4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Viabilidade / Execucao"					,"FEAEXEC4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Oportunidade"							,"OPPNAME4"	,""					,30,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Pais"									,"COUNTRY4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Mercado"								,"MARKSEC4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Produto"								,"INDUSTR4"	,""					,15,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Responsavel"							,"SALPER4"	,""					,30,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Representante Vendas"					,"SALREP4"	,""					,30,0,""		,"","C","TRB4",""})
	aadd(aHeader, {"Equipamento"							,"EQUIPDES4",""					,30,0,""		,"","C","TRB4",""})
	//aadd(aHeader, {"Dimens�es"								,"DIMENS4"	,""					,15,0,""		,"","C","TRB4",""})
	//aadd(aHeader, {"Prev. Vendas"							,"FORECL4"	,""					,08,0,""		,"","D","TRB4","R"})
	aadd(aHeader, {"Prev. Vendas"							,"CFORECL4"	,""					,7,0,""			,"","C","TRB4",""})
	aadd(aHeader, {"Vendas s/ Trib."						,"FOREAMM4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"% Margem Contrib."						,"CONTRMG4"	,"@E 999.99"		,15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"Margem Contrib."						,"VCONTRMG4","@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"Cogs"									,"COGS4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"% Comissao"								,"COMMISS4"	,"@E 999.99"		,15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"Comissao"								,"VCOMMISS4","@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"% Get"									,"PGET4"	,"@E 999.99"		,15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"% Go"									,"PGO4"		,"@E 999.99"		,15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"Montante Vendas"						,"SALAMOU4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	aadd(aHeader, {"Montante Coontrib."						,"SALCONT4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
	//aadd(aHeader, {"Comments"								,"COMMENT3"	,""					,40,0,""		,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL3"	,""					,7,0,""			,"","C","TRB3",""})
	//aadd(aHeader, {"Forecast Close"							,"DFORECL3"	,""					,08,0,""		,"","D","TRB3","R"})
endif

_oGetDbSint4 := MsGetDb():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB4",,,,oFolder1:aDialogs[5])
_oGetDbSint4:oBrowse:BlDblClick := {|| EditTRB4() }

_oGetDbSint4:ForceRefresh()

// COR DA FONTE
_oGetDbSint4:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor4(1)}
// COR DA LINHA
_oGetDbSint4:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor4(2)} //Cor da Linha

Return

/*******************************************************/
Static Function tBookTT()

if _cIdioma = 1
	aadd(aHeader, {"  Proposal Number"						,"NPROP5"	,""					,10,0,""		,"","C","TRB5","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Status"									,"STATUS5"	,""					,10,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Fixed / Budget"							,"FXBUD5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Feasibility Execution"					,"FEAEXEC5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Opportunity Name"						,"OPPNAME5"	,""					,30,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Country"								,"COUNTRY5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Market Sector"							,"MARKSEC5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Industry"								,"INDUSTR5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Sales Person"							,"SALPER5"	,""					,30,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Sales Representantive"					,"SALREP5"	,""					,30,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Equipment Description"					,"EQUIPDES5",""					,30,0,""		,"","C","TRB5",""})
	//aadd(aHeader, {"Dimensions"								,"DIMENS5"	,""					,15,0,""		,"","C","TRB5",""})
	//aadd(aHeader, {"Forecast Close"							,"FORECL5"	,""					,08,0,""		,"","D","TRB5","R"})
	aadd(aHeader, {"Forecast Close"							,"CFORECL5"	,""					,7,0,""			,"","C","TRB5",""})
	aadd(aHeader, {"Forecast Amount"						,"FOREAMM5"	,"@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"% Contrib. Margin"						,"CONTRMG5"	,"@E 999.99"		,15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"Contrib. Margin"						,"VCONTRMG5","@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"Cogs"									,"COGS5"	,"@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"% Commission"							,"COMMISS5"	,"@E 999.99"		,15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"Commission"								,"VCOMMISS5","@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"% Get"									,"PGET5"	,"@E 999.99"		,15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"% Go"									,"PGO5"		,"@E 999.99"		,15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"Sales Phase Amount"						,"SALAMOU5"	,"@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"Sales Phase Contribution"				,"SALCONT5"	,"@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	//aadd(aHeader, {"Comments"								,"COMMENT5"	,""					,40,0,""		,"","C","TRB5",""})
	//aadd(aHeader, {"Forecast Close"							,"CFORECL5"	,""					,7,0,""			,"","C","TRB5",""})
	//aadd(aHeader, {"Forecast Close"							,"DFORECL5"	,""					,08,0,""		,"","D","TRB5","R"})
else

	aadd(aHeader, {"  Numero Proposta"						,"NPROP5"	,""					,10,0,""		,"","C","TRB5","Proposal Number"})
	aadd(aHeader, {"Booking"								,"BOOK5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Status"									,"STATUS5"	,""					,10,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Firme / Estimativa"						,"FXBUD5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Viabilidade / Execucao"					,"FEAEXEC5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Oportunidade"							,"OPPNAME5"	,""					,30,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Pais"									,"COUNTRY5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Mercado"								,"MARKSEC5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Produto"								,"INDUSTR5"	,""					,15,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Responsavel"							,"SALPER5"	,""					,30,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Representante Vendas"					,"SALREP5"	,""					,30,0,""		,"","C","TRB5",""})
	aadd(aHeader, {"Equipamento"							,"EQUIPDES5",""					,30,0,""		,"","C","TRB5",""})
	//aadd(aHeader, {"Dimens�es"								,"DIMENS5"	,""					,15,0,""		,"","C","TRB5",""})
	//aadd(aHeader, {"Prev. Vendas"							,"FORECL5"	,""					,08,0,""		,"","D","TRB5","R"})
	aadd(aHeader, {"Prev. Vendas"							,"CFORECL5"	,""					,7,0,""			,"","C","TRB5",""})
	aadd(aHeader, {"Vendas s/ Trib."						,"FOREAMM5"	,"@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"% Margem Contrib."						,"CONTRMG5"	,"@E 999.99"		,15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"Margem Contrib."						,"VCONTRMG5","@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"Cogs"									,"COGS5"	,"@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"% Comissao"								,"COMMISS5"	,"@E 999.99"		,15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"Comissao"								,"VCOMMISS5","@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"% Get"									,"PGET5"	,"@E 999.99"		,15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"% Go"									,"PGO5"		,"@E 999.99"		,15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"Montante Vendas"						,"SALAMOU5"	,"@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	aadd(aHeader, {"Montante Coontrib."						,"SALCONT5"	,"@E 999,999,999.99",15,2,""		,"","N","TRB5",""})
	//aadd(aHeader, {"Comments"								,"COMMENT5"	,""					,40,0,""		,"","C","TRB5",""})
	//aadd(aHeader, {"Forecast Close"						,"CFORECL5"	,""					,7,0,""			,"","C","TRB5",""})
	//aadd(aHeader, {"Forecast Close"						,"DFORECL5"	,""					,08,0,""		,"","D","TRB5","R"})

endif

_oGetDbSint5 := MsGetDb():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB5",,,,oFolder1:aDialogs[6])
_oGetDbSint5:oBrowse:BlDblClick := {|| EditTRB5() }

_oGetDbSint5:ForceRefresh()

// COR DA FONTE
_oGetDbSint5:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor5(1)}
// COR DA LINHA
_oGetDbSint5:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor5(2)} //Cor da Linha

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ShowAnalit�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function ShowAnalit()

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro := "xx" 

// Monta aHeader do TRB1
aadd(aHeader, {"  ProposTA"								,"XNPROP"	,""					,13,0,""		,"","C","TRB6","Proposal Number"})
aadd(aHeader, {"Booking"								,"XBOOK"	,""					,15,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Status"									,"XSTATUS"	,""					,01,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Prev. venda"							,"XDTPREV"	,""					,08,0,""		,"","D","TRB6","R"})
aadd(aHeader, {"Mercado"								,"XMERCADO"	,""					,01,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Tipo"									,"XTIPO"	,""					,01,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Viab. / Exec."							,"XVIAEXEC"	,""					,01,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Oport."									,"XCONTR"	,""					,40,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Pais"									,"XPAIS"	,""					,30,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Produto"								,"XPRODUTO"	,""					,20,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Resp"									,"XRESP"	,""					,40,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Representante"							,"XREPR"	,""					,40,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Equipment Description"					,"XEQUIP"	,""					,40,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Dimensions"								,"XDIMENS"	,""					,40,0,""		,"","C","TRB6",""})
aadd(aHeader, {"Custo Total"							,"XCUSTOT"	,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"Venda s/ Trib."							,"XTOTSI"	,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"COGS"									,"XCOGS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"% Margem Contrib."						,"PCONTRMG"	,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"Margem Contrib."						,"PCONTRMG"	,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"% Comissao"								,"XPCOMIS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"Comissao"								,"VCOMMISS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"% GET"									,"XPGET"	,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"% PGO"									,"XPGO"		,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"XSALAMOU"								,"XSALAMOU"	,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"XSALCONT"								,"XSALCONT"	,"@E 999,999,999.99",15,2,""		,"","N","TRB6",""})
aadd(aHeader, {"ID"										,"XID"		,""					,10,0,""		,"","C","TRB6",""})

DEFINE MSDIALOG _oDlgAnalit TITLE "xx" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB6")

_oGetDbAnalit:ForceRefresh()
_oDlgAnalit:Refresh()

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

return



/****************** Grafico vendas *******************/
static function zGrafVD()

		Local oChart
		Local oDlg
		Local aRand := {}
		Local nSold	:= 0
		Local nActive := 0
		Local aDados1 := {}
		Local aDados2 := {}
		Local aDados3 := {}
		LOCAL _ni
	
	
		TRB12->(dbgotop())
		for _ni := 1 to len(_aCpos1)
		
			aAdd(aDados1,{substr(_aLegPer[_ni],4,7),	TRB12->(FieldGet(fieldpos(_aCpos1[_ni]))) })  
		
		next _dData 
		TRB12->(DbSkip())
		for _ni := 1 to len(_aCpos1)
		
			aAdd(aDados2,{substr(_aLegPer[_ni],4,7),	TRB12->(FieldGet(fieldpos(_aCpos1[_ni]))) })  
		
		next _dData 
		TRB12->(DbSkip())
		for _ni := 1 to len(_aCpos1)
		
			aAdd(aDados3,{substr(_aLegPer[_ni],4,7),	TRB12->(FieldGet(fieldpos(_aCpos1[_ni]))) })  
		
		next _dData 
		TRB12->(dbgotop())
		//Inst�ncia a classe
        oChart := FWChartLine():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB12",,,,oFolder1:aDialogs[7])
        //oChart := FWChartLine():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2,, ,,,,,,,,,,,oFolder1:aDialogs[7]) 
        //Inicializa pertencendo a janela
        oChart:Init(oFolder1:aDialogs[7], .T., .T. )
         
        //Seta o t�tulo do gr�fico
        oChart:SetTitle("Qty. Proposals Sold / Active / Lost " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7), CONTROL_ALIGN_CENTER)
        
        oChart:addSerie("Sold", aDados1 )
		oChart:addSerie("Active", aDados2 )
		oChart:addSerie("Lost", aDados3 )

	        
        //Define que a legenda ser� mostrada na esquerda
        oChart:setLegend( CONTROL_ALIGN_LEFT )
         
        //Seta a m�scara mostrada na r�gua
        oChart:cPicture := "@E 999,999,999.99"
                 
        //Constr�i o gr�fico
        oChart:Build()

return
/*******************Pring Grafico Sold / Active / Lost ****************/

Static Function zPrnGSAL()
    Local aArea       := GetArea()
    Local cNomeRel    := "rel_Graph_"+dToS(Date())+StrTran(Time(), ':', '-')
    Local cDiretorio  := GetTempPath()
    Local nLinCab     := 025
    Local nAltur      := 650 // 200
    Local nLargur     := 1550 //1050
    Local aRand       := {}
    Local aDados1 := {}
	Local aDados2 := {}
	Local aDados3 := {}
    
    Private cHoraEx    := Time()
    Private nPagAtu    := 1
    Private oPrintPvt
    //Fontes
    Private cNomeFont  := "Arial"
    Private oFontRod   := TFont():New(cNomeFont, , -06, , .F.)
    Private oFontTit   := TFont():New(cNomeFont, , -20, , .T.)
    Private oFontSubN  := TFont():New(cNomeFont, , -17, , .T.)
    //Linhas e colunas
    Private nLinAtu     := 0
    Private nLinFin     := 820
    Private nColIni     := 010
    Private nColFin     := 550
    Private nColMeio    := (nColFin-nColIni)/2
     
    //Criando o objeto de impress�o
    oPrintPvt := FWMSPrinter():New(cNomeRel, IMP_PDF, .F., /*cStartPath*/, .T., , @oPrintPvt, , , , , .T.)
    oPrintPvt:cPathPDF := GetTempPath()
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetLandScape()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60, 60, 60, 60)
    oPrintPvt:StartPage()
     
    //Cabe�alho
    oPrintPvt:SayAlign(nLinCab, nColMeio-100,"" , oFontTit, 500, 20, RGB(0,0,255),, 0)
    nLinCab += 35
    nLinAtu := nLinCab
     
    //Se o arquivo existir, exclui ele
    If File(cDiretorio+"_grafico.png")
        FErase(cDiretorio+"_grafico.png")
    EndIf
     
    //Cria a Janela
    DEFINE MSDIALOG oDlgChar PIXEL FROM 0,0 TO nAltur,nLargur
    
    	TRB12->(dbgotop())
		for _ni := 1 to len(_aCpos1)
		
			aAdd(aDados1,{substr(_aLegPer[_ni],4,7),	TRB12->(FieldGet(fieldpos(_aCpos1[_ni]))) })  
		
		next _dData 
		TRB12->(DbSkip())
		for _ni := 1 to len(_aCpos1)
		
			aAdd(aDados2,{substr(_aLegPer[_ni],4,7),	TRB12->(FieldGet(fieldpos(_aCpos1[_ni]))) })  
		
		next _dData 
		TRB12->(DbSkip())
		for _ni := 1 to len(_aCpos1)
		
			aAdd(aDados3,{substr(_aLegPer[_ni],4,7),	TRB12->(FieldGet(fieldpos(_aCpos1[_ni]))) })  
		
		next _dData 
		TRB12->(dbgotop())
    
    
        //Inst�ncia a classe
        oChart := FWChartLine():New()
          
        //Inicializa pertencendo a janela
        oChart:Init(oDlgChar, .T., .T. )
          
        //Seta o t�tulo do gr�fico
        oChart:SetTitle("Qty. Proposals Sold / Active / Lost " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7), CONTROL_ALIGN_CENTER)
          
        oChart:addSerie("Sold", aDados1 )
		oChart:addSerie("Active", aDados2 )
		oChart:addSerie("Lost", aDados3 )
       
          
        //Define que a legenda ser� mostrada na esquerda
        oChart:setLegend( CONTROL_ALIGN_LEFT )
          
         //Seta a m�scara mostrada na r�gua
        oChart:cPicture := "@E 999,999,999.99"
        
      
          
        //Constr�i o gr�fico
        oChart:Build()
    ACTIVATE MSDIALOG oDlgChar CENTERED ON INIT (oChart:SaveToPng(0, 0, nLargur, nAltur, cDiretorio+"_grafico.png"), oDlgChar:End())
     
    oPrintPvt:SayBitmap(nLinAtu, nColIni, cDiretorio+"_grafico.png", nLargur/2, nAltur/1.6)
    nLinAtu += nAltur/1.6 + 3
     
    oPrintPvt:SayAlign(nLinAtu, nColIni+020, "Westech Equipamentos Industriais Ltda.",                            oFontSubN, 500, 07, , , )
     
    //Impress�o do Rodap�
    fImpRod1()
     
    //Gera o pdf para visualiza��o
    oPrintPvt:Preview()
     
    RestArea(aArea)
Return

Static Function fImpRod1()
    Local nLinRod := nLinFin + 10
    Local cTexto  := ""
 
    //Linha Separat�ria
    oPrintPvt:Line(nLinRod, nColIni, nLinRod, nColFin, RGB(200, 200, 200))
    nLinRod += 3
     
    //Dados da Esquerda
    cTexto := "Relatario Qtd.Propostas    |    "+dToC(dDataBase)+"     "+cHoraEx+"     "+FunName()+"     "+cUserName
    oPrintPvt:SayAlign(nLinRod, nColIni,    cTexto, oFontRod, 250, 07, , , )
     
    //Direita
    cTexto := "Pagina "+cValToChar(nPagAtu)
    oPrintPvt:SayAlign(nLinRod, nColFin-40, cTexto, oFontRod, 040, 07, , , )
     
    //Finalizando a p�gina e somando mais um
    oPrintPvt:EndPage()
    nPagAtu++
Return

/****************** Grafico MARKETING PLATFORM *******************/
static function zGrafMKP()
		
		Local oChart
		Local oDlg
		Local aRand := {}
		LOCAL _ni
		
		//Inst�ncia a classe
        oChart := FWChartBar():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB8",,,,oFolder1:aDialogs[8])
         
        //Inicializa pertencendo a janela
        oChart:Init(oFolder1:aDialogs[8], .T., .T. )
         
        //Seta o t�tulo do gr�fico
        
        oChart:SetTitle("MARKETING PLATFORM " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7), CONTROL_ALIGN_CENTER)
        
        for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	        //Adiciona as s�ries, com as descri��es e valores
	        oChart:addSerie(substr(_aLegPer[_ni],4,7), TRB8->(FieldGet(fieldpos(_aCpos1[_ni]))))
               
        next _dData
        
        //Define que a legenda ser� mostrada na esquerda
        oChart:setLegend( CONTROL_ALIGN_LEFT )
         
        //Seta a m�scara mostrada na r�gua
        oChart:cPicture := "@E 999,999,999.99"
        
        //Define as cores que ser�o utilizadas no gr�fico
         aAdd(aRand, {"084,120,164", "007,013,017"})
        aAdd(aRand, {"171,225,108", "017,019,010"})
        
        aAdd(aRand, {"084,120,164", "007,013,017"})
        aAdd(aRand, {"171,225,108", "017,019,010"})
        
        aAdd(aRand, {"084,120,164", "007,013,017"})
        aAdd(aRand, {"171,225,108", "017,019,010"})
        
        aAdd(aRand, {"084,120,164", "007,013,017"})
        aAdd(aRand, {"171,225,108", "017,019,010"})
        
        aAdd(aRand, {"084,120,164", "007,013,017"})
        aAdd(aRand, {"171,225,108", "017,019,010"})
        
        aAdd(aRand, {"084,120,164", "007,013,017"})
        aAdd(aRand, {"171,225,108", "017,019,010"})
        //Seta as cores utilizadas
        oChart:oFWChartColor:aRandom := aRand
        oChart:oFWChartColor:SetColor("Random")
         
        //Constr�i o gr�fico
        oChart:Build()
Return

/****************** Grafico BOOKING BR *******************/
static function zGrafBBR()
		Local oChart
		Local oDlg
		Local aRand := {}
		Local aDados1 := {}
		Local aDados2 := {}
		Local aDados3 := {}
	
		TRB9->(dbgotop())
		for _ni := 1 to len(_aCpos1)
		
			aAdd(aDados1,{substr(_aLegPer[_ni],4,7),	TRB9->(FieldGet(fieldpos(_aCpos1[_ni]))) })  
		
		next _dData 
		TRB9->(DbSkip())
		for _ni := 1 to len(_aCpos1)
		
			aAdd(aDados2,{substr(_aLegPer[_ni],4,7),	TRB9->(FieldGet(fieldpos(_aCpos1[_ni]))) })  
		
		next _dData 
		TRB9->(DbSkip())
		
		for _ni := 1 to len(_aCpos1)
		
			aAdd(aDados3,{substr(_aLegPer[_ni],4,7),	TRB9->(FieldGet(fieldpos(_aCpos1[_ni]))) })  
		
		next _dData 
		TRB9->(dbgotop())
		
		//Inst�ncia a classe
        oChart := FWChartLine():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB9",,,,oFolder1:aDialogs[9])
         
        //Inicializa pertencendo a janela
        oChart:Init(oFolder1:aDialogs[9], .T., .T. )
         
        //Seta o t�tulo do gr�fico
        oChart:SetTitle("BOOKING " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7), CONTROL_ALIGN_CENTER)

        oChart:addSerie("Booking BR", aDados1 )
		oChart:addSerie("Booking SA", aDados2 ) 
		oChart:addSerie("Booking Total", aDados3 ) 
        
   
        //Define que a legenda ser� mostrada na esquerda
        oChart:setLegend( CONTROL_ALIGN_LEFT )
         
        //Seta a m�scara mostrada na r�gua
        oChart:cPicture := "@E 999,999,999.99"

        //Constr�i o gr�fico
        oChart:Build()
return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaTela �												  ���
�������������������������������������������������������������������������͹��
���Desc.     � Quantidade marketing Plataforma							           ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function zTotalMPP()
Local oFolder1
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
Private _oDlgSint


 
cCadastro = "QTD. MARKETING PLATFORM  " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7)
// Monta aHeader do TRB2
aadd(aHeader, {" Descricao"								,"DESC"		,""					,10,0,""		,"","C","TRB8",""})

for _ni := 1 to len(_aCpos1) // Monta campos com as datas

	aadd(aHeader, { substr(_aLegPer[_ni],4,7),_aCpos1[_ni],"@E 999,999,999.99",15,2,"","","N","TRB8","R"})
	
next _dData


DEFINE MSDIALOG _oDlgSint ;
TITLE  "QTD. MARKETING PLATFORM  " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7);
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB8",,,,)

_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

//aadd(aButton , { "BMPTABLE2" , { || zExportExc3()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE2" , { || zExFuA()}, "Analitico " } )


ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return

/*****************Quantidade booking BR *******************/
static function zTotalBBR()
Local oFolder1
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
Private _oDlgSint


 
cCadastro = "QTD. BOOKING BR / SA / TOTAL  " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7)
// Monta aHeader do TRB2
aadd(aHeader, {" Descricao"								,"DESC"		,""					,10,0,""		,"","C","TRB9",""})

for _ni := 1 to len(_aCpos1) // Monta campos com as datas

	aadd(aHeader, { substr(_aLegPer[_ni],4,7),_aCpos1[_ni],"@E 999,999,999.99",15,2,"","","N","TRB9","R"})
	
next _dData


DEFINE MSDIALOG _oDlgSint ;
TITLE  "QTD. BOOKING BR " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7);
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB9",,,,)

_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

//aadd(aButton , { "BMPTABLE2" , { || zExportExc3()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE2" , { || zExFuA()}, "Analitico " } )


ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return



/*****************Quantidade Vendidas *******************/
static function zTotalTVD()
Local oFolder1
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
Private _oDlgSint


 
cCadastro = "QTD. Vendidas / Activas / Perdidas  " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim))
// Monta aHeader do TRB2
aadd(aHeader, {" Descricao"								,"DESC"		,""					,10,0,""		,"","C","TRB12",""})

for _ni := 1 to len(_aCpos1) // Monta campos com as datas

	aadd(aHeader, { substr(_aLegPer[_ni],4,7),_aCpos1[_ni],"@E 999,999,999.99",15,2,"","","N","TRB12","R"})
	
next _dData


DEFINE MSDIALOG _oDlgSint ;
TITLE  "QTD. Vendidas / Ativas " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim));
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB12",,,,)

_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

//aadd(aButton , { "BMPTABLE2" , { || zExportExc3()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE2" , { || zExFuA()}, "Analitico " } )


ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

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
//**********************************************************/

Static Function zExpComiss()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'Booking.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
    
    Local aLinhaAux2 := {}
    Local aColunas2  := {}
    Local aColsMa2	:= {}
    
    Local aLinhaAux3 := {}
    Local aColunas3  := {}
    Local aColsMa3	 := {}
    
    Local aLinhaAux4 := {}
    Local aColunas4  := {}
    Local aColsMa4	:= {}
    
    Local aLinhaAux5 := {}
    Local aColunas5  := {}
    Local aColsMa5	:= {}
    
    Local aLinhaAux6 := {}
    Local aColunas6  := {}
    Local aColsMa6	:= {}
    
    Local aLinhaAux7 := {}
    Local aColunas7  := {}
    Local aColsMa7	:= {}
    
    Local nX1		:= 1 
    Local nX2		:= 1 
    Local nX3		:= 1 
    Local nX4		:= 1 
    Local nX5		:= 1 
    Local nX6		:= 1 
    Local nX7		:= 1 
    
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
    
    Local cTabela2	:= "" 
    Local cPasta2	:= ""
    
    Local cTabela3	:= "" 
    Local cPasta3	:= ""
    
    Local cTabela4	:= "" 
    Local cPasta4	:= ""
    
    Local cTabela5	:= "" 
    Local cPasta5	:= ""
    
    //Local cTabela6	:= "" 
    //Local cPasta6	:= ""
    
    Local cTabela7	:= "" 
    Local cPasta7	:= ""
    
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
	    
	    cTabela7 	:= "Spare parts & Field service" 
	    cPasta7		:= "Spare parts & Field service " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7)
	    
	    cTabela2 	:= "Marketing Platform"
	    cPasta2		:= "Marketing Platform "  + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7)
	    
	    cTabela3 	:= "Booking BR" 
	    cPasta3		:= "Booking BR " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7)
	    
	    cTabela4 	:= "Booking SA" 
	    cPasta4		:= "Booking SA " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7)
	    
	    cTabela5 	:= "Booking Total" 
	    cPasta5		:= "Booking Total " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " to " + substr(dtoc(LastDate(_dDataFim)),4,7)
	    
	    cNPROP		:= "Proposal Number"
	    cSTATUS		:= "Status"
	    cFXBUD		:= "Fixed / Budget"
	    cFEAEXEC	:= "Feasibility / Execution"
	    cOPPNAME	:= "Opportunity Name"
	    cCOUNTRY	:= "Country"
	    cMARKSEC	:= "Market Sector"
	    cINDUSTR	:= "Industry"
	    cSALPER		:= "Sales Person"
	    cSALREP		:= "Sales Representative"
	    cEQUIPDES	:= "Equipment Description"
	    //cDIMENS		:= "Dimensions"
		cDTREG		:= "Registration Date"
	    cFORECL		:= "Forecast Close"
	    cFOREAMM	:= "Forecast Amount"
	    cCONTRMG	:= "% Contrib.Margin"
	    cVCONTMG	:= "Contrib.Margin"
	    cCOGS		:= "COGS"
	    cCOMISS		:= "% Commission"
	    cVCOMISS	:= "Commission"
	    cPGET		:= "% Get"
	    cPGO		:= "% Go"
	    cSALAMOU	:= "Sales Phase Amount"
	    cSALCONT	:= "Sales Phase Contribution"
	
	else
		cTabela := "Lista geral de propostas" 
	    cPasta	:= "Lista geral de propostas" 
	    
	    cTabela7 	:= "Pecas de reposicao e servico de campo" 
	    cPasta7		:= "Pecas de reposicao e servico de campo " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " ate " + substr(dtoc(LastDate(_dDataFim)),4,7)
	    
	    cTabela2 	:= "Plataforma de Marketing"
	    cPasta2		:= "Plataforma de Marketing " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " ate " + substr(dtoc(LastDate(_dDataFim)),4,7)
	    
	    cTabela3 	:= "Vendas BR" 
	    cPasta3		:= "Vendas BR " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " ate " + substr(dtoc(LastDate(_dDataFim)),4,7)
	    
	    cTabela4 	:= "Vendas SA" 
	    cPasta4		:= "Vendas SA " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " ate " + substr(dtoc(LastDate(_dDataFim)),4,7)
	    
	    cTabela5 	:= "Vendas Total" 
	    cPasta5		:= "Vendas Total " + substr(dtoc(FirstDate(_dDataIni)),4,7) + " ate " + substr(dtoc(LastDate(_dDataFim)),4,7)
	    
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
	    cFORECL		:= "Prev.Venda"				// 14
	    cFOREAMM	:= "Venda s/ Trib."			// 15
	    cCONTRMG	:= "% Margem Contrib."		// 16
	    cVCONTMG	:= "Margem Contrib."		// 17
	    cCOGS		:= "COGS"					// 18
	    cCOMISS		:= "% Comissao"				// 19
	    cVCOMISS	:= "Comissao"				// 20
	    cPGET		:= "% Get"					// 21
	    cPGO		:= "% Go"					// 22
	    cSALAMOU	:= "Montante Vendas"		// 23
	    cSALCONT	:= "Montante Contrib."		// 24
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
        aAdd(aColunas, cFOREAMM)		// 14	
        aAdd(aColunas, cCONTRMG)		// 15	
        aAdd(aColunas, cVCONTMG)		// 16
        aAdd(aColunas, cCOGS)			// 17  	
        aAdd(aColunas, cCOMISS)			// 18
        aAdd(aColunas, cVCOMISS)		// 19
           
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
        oFWMsExcel:AddColumn(cTabela,cPasta, cFOREAMM,1,2)					// 14 venda s/ tributos
        oFWMsExcel:AddColumn(cTabela,cPasta, cCONTRMG,1,2)					// 15 % margem contrib.
        oFWMsExcel:AddColumn(cTabela,cPasta, cVCONTMG,1,2)					// 16 margem contrib.
        
        oFWMsExcel:AddColumn(cTabela,cPasta, cCOGS,1,2)						// 17 cogs
        oFWMsExcel:AddColumn(cTabela,cPasta, cCOMISS,1,2)					// 18 % comissao
        oFWMsExcel:AddColumn(cTabela,cPasta, cVCOMISS,1,2)					// 19 comissao
                
  
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
        	aLinhaAux[14] := TRB1->FOREAMM
        	
        	aLinhaAux[15] := TRB1->CONTRMG
        	aLinhaAux[16] := TRB1->VCONTRMG
        	aLinhaAux[17] := TRB1->COGS
        	
        	aLinhaAux[18] := TRB1->COMMISS
        	aLinhaAux[19] := TRB1->VCOMMISS	
	        
    
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
     
      /*************** TRB7 Servicos / Partes e Pecas ****************/   
      
        //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela7) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela7,cPasta7)
    
    	aAdd(aColunas7, cNPROP)			// 1
        aAdd(aColunas7, cSTATUS)		// 2				
        aAdd(aColunas7, cFXBUD)			// 3							
        aAdd(aColunas7, cFEAEXEC)		// 4				
        aAdd(aColunas7, cOPPNAME)		// 5
        aAdd(aColunas7, cCOUNTRY)		// 6	
        aAdd(aColunas7, cMARKSEC)		// 7
        aAdd(aColunas7, cINDUSTR)		// 8
        aAdd(aColunas7, cSALPER)		// 9
        aAdd(aColunas7, cEQUIPDES)		// 10
        //aAdd(aColunas7, cDIMENS)		// 11
        aAdd(aColunas7, cFORECL)		// 12						
        aAdd(aColunas7, cFOREAMM)		// 13	
        aAdd(aColunas7, cCONTRMG)		// 14	
        aAdd(aColunas7, cVCONTMG)		// 15
        aAdd(aColunas7, cCOGS)			// 16
        aAdd(aColunas7, cCOMISS)		// 17
        aAdd(aColunas7, cVCOMISS)		// 18
        aAdd(aColunas7, cPGET)			// 19
        aAdd(aColunas7, cPGO)			// 20
        aAdd(aColunas7, cSALAMOU)		// 21
        aAdd(aColunas7, cSALCONT)		// 22
        
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cNPROP,1,2)					// 1 numero proposta						
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cSTATUS,1,2)					// 2 status			
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cFXBUD,1,2)					// 3 fixed / budget		
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cFEAEXEC,1,2)				// 4 viabilidade / execu��o
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cOPPNAME,1,2)				// 5 oportunidade
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cCOUNTRY,1,2)				// 6 pais
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cMARKSEC,1,2)				// 7 mercado
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cINDUSTR,1,2)				// 8 produto
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cSALPER,1,2)					// 9 responsavel
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cEQUIPDES,1,2)				// 10 equipament     
        //oFWMsExcel:AddColumn(cTabela7,cPasta7, cDIMENS,1,2)					// 11 dimensoes			
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cFORECL,1,2)					// 12 previsao venda
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cFOREAMM,1,2)				// 13 venda s/ tributos
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cCONTRMG,1,2)				// 14 % margem contrib.
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cVCONTMG,1,2)				// 15 margem contrib
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cCOGS,1,2)					// 16 cogs
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cCOMISS,1,2)					// 17 % comissao
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cVCOMISS,1,2)				// 18 comissao
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cPGET,1,2)					// 19 % get
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cPGO,1,2)					// 20 % go
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cSALAMOU,1,2)				// 21 montante vendas
        oFWMsExcel:AddColumn(cTabela7,cPasta7, cSALCONT,1,2)				// 22 montante contrib.
                
    For nAux := 1 To Len(aColunas7)
         aAdd(aColsMa7,  nX7 )
         nX7++
    Next
        nCL	:= 1
        TRB7->(dbgotop())
                            
        While  !(TRB7->(EoF()))
        	
        	//MsProcTxt("Processando registros: "+alltrim(TRB7->NPROP7))
        	//ProcessMessage()
         
        	aLinhaAux7 := Array(Len(aColunas7))
        	aLinhaAux7[1] := TRB7->NPROP7
        	aLinhaAux7[2] := TRB7->STATUS7
        	aLinhaAux7[3] := TRB7->FXBUD7
        	aLinhaAux7[4] := TRB7->FEAEXEC7
        	aLinhaAux7[5] := TRB7->OPPNAME7
        	aLinhaAux7[6] := TRB7->COUNTRY7
        	aLinhaAux7[7] := TRB7->MARKSEC7
        	aLinhaAux7[8] := TRB7->INDUSTR7
        	aLinhaAux7[9] := TRB7->SALPER7
        	aLinhaAux7[10] := TRB7->EQUIPDES7
        	//aLinhaAux7[11] := TRB7->DIMENS7
        	aLinhaAux7[11] := TRB7->CFORECL7
        	aLinhaAux7[12] := TRB7->FOREAMM7
        	aLinhaAux7[13] := TRB7->CONTRMG7
        	aLinhaAux7[14] := TRB7->VCONTRMG7
        	aLinhaAux7[15] := TRB7->COGS7
        	aLinhaAux7[16] := TRB7->COMMISS7
        	aLinhaAux7[17] := TRB7->VCOMMISS7	
        	aLinhaAux7[18] := TRB7->PGET7
        	aLinhaAux7[19] := TRB7->PGO7
        	aLinhaAux7[20] := TRB7->SALAMOU7
        	aLinhaAux7[21] := TRB7->SALCONT7	
	        
    
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela7,cPasta7, aLinhaAux7,aColsMa7)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela7,cPasta7, aLinhaAux7,aColsMa7)
	        		nCL		:= 1
	        	endif
	 
        	
            TRB7->(DbSkip())

        EndDo

        TRB7->(dbgotop())
  
      
     /*************** TRB2 Marketing Platform****************/   
     
        //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela2) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela2,cPasta2)
    
    	aAdd(aColunas2, cNPROP)			// 1
        aAdd(aColunas2, cSTATUS)		// 2				
        aAdd(aColunas2, cFXBUD)			// 3							
        aAdd(aColunas2, cFEAEXEC)		// 4				
        aAdd(aColunas2, cOPPNAME)		// 5
        aAdd(aColunas2, cCOUNTRY)		// 6	
        aAdd(aColunas2, cMARKSEC)		// 7
        aAdd(aColunas2, cINDUSTR)		// 8
        aAdd(aColunas2, cSALPER)		// 9
        aAdd(aColunas2, cSALREP)		// 10
        aAdd(aColunas2, cEQUIPDES)		// 11
        //aAdd(aColunas2, cDIMENS)		// 12
        aAdd(aColunas2, cFORECL)		// 12						
        aAdd(aColunas2, cFOREAMM)		// 13	
        aAdd(aColunas2, cCONTRMG)		// 14	
        aAdd(aColunas2, cVCONTMG)		// 15
        aAdd(aColunas2, cCOGS)			// 16
        aAdd(aColunas2, cCOMISS)		// 17
        aAdd(aColunas2, cVCOMISS)		// 18
        aAdd(aColunas2, cPGET)			// 19
        aAdd(aColunas2, cPGO)			// 20
        aAdd(aColunas2, cSALAMOU)		// 21
        aAdd(aColunas2, cSALCONT)		// 22
           
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cNPROP,1,2)					// 1 numero proposta						
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cSTATUS,1,2)					// 2 status			
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cFXBUD,1,2)					// 3 fixed / budget		
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cFEAEXEC,1,2)				// 4 viabilidade / execu��o
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cOPPNAME,1,2)				// 5 oportunidade
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cCOUNTRY,1,2)				// 6 pais
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cMARKSEC,1,2)				// 7 mercado
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cINDUSTR,1,2)				// 8 produto
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cSALPER,1,2)					// 9 responsavel
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cSALREP,1,2)					// 10 representante
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cEQUIPDES,1,2)				// 11 equipament     
        //oFWMsExcel:AddColumn(cTabela2,cPasta2, cDIMENS,1,2)					// 12 dimensoes			
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cFORECL,1,2)					// 12 previsao venda
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cFOREAMM,1,2)				// 13 venda s/ tributos
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cCONTRMG,1,2)				// 14 % margem contrib.
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cVCONTMG,1,2)				// 15 margem contrib
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cCOGS,1,2)					// 16 cogs
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cCOMISS,1,2)					// 17 % comissao
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cVCOMISS,1,2)				// 18 comissao
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cPGET,1,2)					// 19 % get
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cPGO,1,2)					// 20 % go
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cSALAMOU,1,2)				// 21 montante vendas
        oFWMsExcel:AddColumn(cTabela2,cPasta2, cSALCONT,1,2)				// 22 montante contrib.        
      
  
    For nAux := 1 To Len(aColunas2)
         aAdd(aColsMa2,  nX2 )
         nX2++
    Next
        nCL	:= 1
        TRB2->(dbgotop())
                            
        While  !(TRB2->(EoF()))
        
        	//MsProcTxt("Processando registros: "+alltrim(TRB2->NPROP2))
        	//ProcessMessage()
         
        	aLinhaAux2 := Array(Len(aColunas2))
        	aLinhaAux2[1] := TRB2->NPROP2
        	aLinhaAux2[2] := TRB2->STATUS2
        	aLinhaAux2[3] := TRB2->FXBUD2
        	aLinhaAux2[4] := TRB2->FEAEXEC2
        	aLinhaAux2[5] := TRB2->OPPNAME2
        	aLinhaAux2[6] := TRB2->COUNTRY2
        	aLinhaAux2[7] := TRB2->MARKSEC2
        	aLinhaAux2[8] := TRB2->INDUSTR2
        	aLinhaAux2[9] := TRB2->SALPER2
        	aLinhaAux2[10] := TRB2->SALREP2
        	aLinhaAux2[11] := TRB2->EQUIPDES2
        	//aLinhaAux2[12] := TRB2->DIMENS2
        	aLinhaAux2[12] := TRB2->CFORECL2
        	aLinhaAux2[13] := TRB2->FOREAMM2
        	aLinhaAux2[14] := TRB2->CONTRMG2
        	aLinhaAux2[15] := TRB2->VCONTRMG2
        	aLinhaAux2[16] := TRB2->COGS2
        	aLinhaAux2[17] := TRB2->COMMISS2
        	aLinhaAux2[18] := TRB2->VCOMMISS2	
        	aLinhaAux2[19] := TRB2->PGET2
        	aLinhaAux2[20] := TRB2->PGO2
        	aLinhaAux2[21] := TRB2->SALAMOU2
        	aLinhaAux2[22] := TRB2->SALCONT2	
	        
    
	        	if alltrim(aLinhaAux2[1]) == "TOTAL"
	            	oFWMsExcel:SetCelBold(.T.)	
	            	oFWMsExcel:SetCelBgColor("#FFD700")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela2,cPasta2, aLinhaAux2,aColsMa2)
	        	elseif alltrim(aLinhaAux2[1]) == "TOTAL GERAL"
	            	oFWMsExcel:SetCelBold(.T.)	
	            	oFWMsExcel:SetCelBgColor("#008000")
	            	oFWMsExcel:SetCelFrColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela2,cPasta2, aLinhaAux2,aColsMa2)
	        	elseif nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela2,cPasta2, aLinhaAux2,aColsMa2)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela2,cPasta2, aLinhaAux2,aColsMa2)
	        		nCL		:= 1
	        	
	        	endif
	 
        	
            TRB2->(DbSkip())

        EndDo

        TRB2->(dbgotop())
   
    /*************** TRB3  Booking BR****************/  
   
        //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela3) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela3,cPasta3)
    
    	aAdd(aColunas3, cNPROP)			// 1
        aAdd(aColunas3, cSTATUS)		// 2				
        aAdd(aColunas3, cFXBUD)			// 3							
        aAdd(aColunas3, cFEAEXEC)		// 4				
        aAdd(aColunas3, cOPPNAME)		// 5
        aAdd(aColunas3, cCOUNTRY)		// 6	
        aAdd(aColunas3, cMARKSEC)		// 7
        aAdd(aColunas3, cINDUSTR)		// 8
        aAdd(aColunas3, cSALPER)		// 9
        aAdd(aColunas3, cSALREP)		// 10
        aAdd(aColunas3, cEQUIPDES)		// 11
        //aAdd(aColunas3, cDIMENS)		// 12
        aAdd(aColunas3, cFORECL)		// 13						
        aAdd(aColunas3, cFOREAMM)		// 14	
        aAdd(aColunas3, cCONTRMG)		// 15	
        aAdd(aColunas3, cVCONTMG)		// 16
        aAdd(aColunas3, cCOGS)			// 17
        aAdd(aColunas3, cCOMISS)		// 18
        aAdd(aColunas3, cVCOMISS)		// 19
        aAdd(aColunas3, cPGET)			// 20
        aAdd(aColunas3, cPGO)			// 21
        aAdd(aColunas3, cSALAMOU)		// 22
        aAdd(aColunas3, cSALCONT)		// 23
        
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cNPROP,1,2)					// 1 numero proposta						
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cSTATUS,1,2)					// 2 status			
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cFXBUD,1,2)					// 3 fixed / budget		
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cFEAEXEC,1,2)				// 4 viabilidade / execu��o
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cOPPNAME,1,2)				// 5 oportunidade
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cCOUNTRY,1,2)				// 6 pais
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cMARKSEC,1,2)				// 7 mercado
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cINDUSTR,1,2)				// 8 produto
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cSALPER,1,2)					// 9 responsavel
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cSALREP,1,2)					// 10 representante
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cEQUIPDES,1,2)				// 11 equipament     
        //oFWMsExcel:AddColumn(cTabela3,cPasta3, cDIMENS,1,2)					// 12 dimensoes			
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cFORECL,1,2)					// 13 previsao venda
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cFOREAMM,1,2)				// 14 venda s/ tributos
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cCONTRMG,1,2)				// 15 % margem contrib.
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cVCONTMG,1,2)				// 16 margem contrib
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cCOGS,1,2)					// 17 cogs
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cCOMISS,1,2)					// 18 % comissao
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cVCOMISS,1,2)				// 19 comissao
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cPGET,1,2)					// 20 % get
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cPGO,1,2)					// 21 % go
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cSALAMOU,1,2)				// 22 montante vendas
        oFWMsExcel:AddColumn(cTabela3,cPasta3, cSALCONT,1,2)				// 23 montante contrib.
                
      
  
    For nAux := 1 To Len(aColunas3)
         aAdd(aColsMa3,  nX3 )
         nX3++
    Next
        nCL	:= 1
        TRB3->(dbgotop())
                            
        While  !(TRB3->(EoF()))
        
        	//MsProcTxt("Processando registros: "+alltrim(TRB3->NPROP3))
        	//ProcessMessage()
         
        	aLinhaAux3 := Array(Len(aColunas3))
        	aLinhaAux3[1] := TRB3->NPROP3
        	aLinhaAux3[2] := TRB3->STATUS3
        	aLinhaAux3[3] := TRB3->FXBUD3
        	aLinhaAux3[4] := TRB3->FEAEXEC3
        	aLinhaAux3[5] := TRB3->OPPNAME3
        	aLinhaAux3[6] := TRB3->COUNTRY3
        	aLinhaAux3[7] := TRB3->MARKSEC3
        	aLinhaAux3[8] := TRB3->INDUSTR3
        	aLinhaAux3[9] := TRB3->SALPER3
        	aLinhaAux3[10] := TRB3->SALREP3
        	aLinhaAux3[11] := TRB3->EQUIPDES3
        	//aLinhaAux3[12] := TRB3->DIMENS3
        	aLinhaAux3[12] := TRB3->CFORECL3
        	aLinhaAux3[13] := TRB3->FOREAMM3
        	aLinhaAux3[14] := TRB3->CONTRMG3
        	aLinhaAux3[15] := TRB3->VCONTRMG3
        	aLinhaAux3[16] := TRB3->COGS3
        	aLinhaAux3[17] := TRB3->COMMISS3
        	aLinhaAux3[18] := TRB3->VCOMMISS3	
        	aLinhaAux3[19] := TRB3->PGET3
        	aLinhaAux3[20] := TRB3->PGO3
        	aLinhaAux3[21] := TRB3->SALAMOU3
        	aLinhaAux3[22] := TRB3->SALCONT3	
	        
	        
        		if alltrim(aLinhaAux3[1]) == "TOTAL"
	            	oFWMsExcel:SetCelBold(.T.)	
	            	oFWMsExcel:SetCelBgColor("#FFD700")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela3,cPasta3, aLinhaAux3,aColsMa3)
	        	elseif alltrim(aLinhaAux3[1]) == "TOTAL GERAL"
	            	oFWMsExcel:SetCelBold(.T.)	
	            	oFWMsExcel:SetCelBgColor("#008000")
	            	oFWMsExcel:SetCelFrColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela3,cPasta3, aLinhaAux3,aColsMa3)
	        	elseif nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela3,cPasta3, aLinhaAux3,aColsMa3)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela3,cPasta3, aLinhaAux3,aColsMa3)
	        		nCL		:= 1
	        	
	        	endif
	 
            TRB3->(DbSkip())

        EndDo

        TRB3->(dbgotop())

    /*************** TRB4 Booking SA****************/ 
    
        //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela4) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela4,cPasta4)
    
    	aAdd(aColunas4, cNPROP)			// 1
        aAdd(aColunas4, cSTATUS)		// 2				
        aAdd(aColunas4, cFXBUD)			// 3							
        aAdd(aColunas4, cFEAEXEC)		// 4				
        aAdd(aColunas4, cOPPNAME)		// 5
        aAdd(aColunas4, cCOUNTRY)		// 6	
        aAdd(aColunas4, cMARKSEC)		// 7
        aAdd(aColunas4, cINDUSTR)		// 8
        aAdd(aColunas4, cSALPER)		// 9
        aAdd(aColunas4, cSALREP)		// 10
        aAdd(aColunas4, cEQUIPDES)		// 11
        //aAdd(aColunas4, cDIMENS)		// 12
        aAdd(aColunas4, cFORECL)		// 13						
        aAdd(aColunas4, cFOREAMM)		// 14	
        aAdd(aColunas4, cCONTRMG)		// 15	
        aAdd(aColunas4, cVCONTMG)		// 16
        aAdd(aColunas4, cCOGS)			// 17
        aAdd(aColunas4, cCOMISS)		// 18
        aAdd(aColunas4, cVCOMISS)		// 19
        aAdd(aColunas4, cPGET)			// 20
        aAdd(aColunas4, cPGO)			// 21
        aAdd(aColunas4, cSALAMOU)		// 22
        aAdd(aColunas4, cSALCONT)		// 23
        
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cNPROP,1,2)					// 1 numero proposta						
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cSTATUS,1,2)					// 2 status			
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cFXBUD,1,2)					// 3 fixed / budget		
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cFEAEXEC,1,2)				// 4 viabilidade / execu��o
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cOPPNAME,1,2)				// 5 oportunidade
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cCOUNTRY,1,2)				// 6 pais
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cMARKSEC,1,2)				// 7 mercado
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cINDUSTR,1,2)				// 8 produto
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cSALPER,1,2)					// 9 responsavel
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cSALREP,1,2)					// 10 representante
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cEQUIPDES,1,2)				// 11 equipament     
        //oFWMsExcel:AddColumn(cTabela4,cPasta4, cDIMENS,1,2)					// 12 dimensoes			
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cFORECL,1,2)					// 13 previsao venda
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cFOREAMM,1,2)				// 14 venda s/ tributos
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cCONTRMG,1,2)				// 15 % margem contrib.
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cVCONTMG,1,2)				// 16 margem contrib
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cCOGS,1,2)					// 17 cogs
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cCOMISS,1,2)					// 18 % comissao
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cVCOMISS,1,2)				// 19 comissao
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cPGET,1,2)					// 20 % get
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cPGO,1,2)					// 21 % go
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cSALAMOU,1,2)				// 22 montante vendas
        oFWMsExcel:AddColumn(cTabela4,cPasta4, cSALCONT,1,2)				// 23 montante contrib.
                
      
  
    For nAux := 1 To Len(aColunas4)
         aAdd(aColsMa4,  nX4 )
         nX4++
    Next
        nCL	:= 1
        TRB4->(dbgotop())
                            
        While  !(TRB4->(EoF()))
        
        	//MsProcTxt("Processando registro: "+alltrim(TRB4->NPROP4))
        	//ProcessMessage()
         
        	aLinhaAux4 := Array(Len(aColunas4))
        	aLinhaAux4[1] := TRB4->NPROP4
        	aLinhaAux4[2] := TRB4->STATUS4
        	aLinhaAux4[3] := TRB4->FXBUD4
        	aLinhaAux4[4] := TRB4->FEAEXEC4
        	aLinhaAux4[5] := TRB4->OPPNAME4
        	aLinhaAux4[6] := TRB4->COUNTRY4
        	aLinhaAux4[7] := TRB4->MARKSEC4
        	aLinhaAux4[8] := TRB4->INDUSTR4
        	aLinhaAux4[9] := TRB4->SALPER4
        	aLinhaAux4[10] := TRB4->SALREP4
        	aLinhaAux4[11] := TRB4->EQUIPDES4
        	//aLinhaAux4[12] := TRB4->DIMENS4
        	aLinhaAux4[12] := TRB4->CFORECL4
        	aLinhaAux4[13] := TRB4->FOREAMM4
        	aLinhaAux4[14] := TRB4->CONTRMG4
        	aLinhaAux4[15] := TRB4->VCONTRMG4
        	aLinhaAux4[16] := TRB4->COGS4
        	aLinhaAux4[17] := TRB4->COMMISS4
        	aLinhaAux4[18] := TRB4->VCOMMISS4	
        	aLinhaAux4[19] := TRB4->PGET4
        	aLinhaAux4[20] := TRB4->PGO4
        	aLinhaAux4[21] := TRB4->SALAMOU4
        	aLinhaAux4[22] := TRB4->SALCONT4	
	        
	        
        		if alltrim(aLinhaAux4[1]) == "TOTAL"
	            	oFWMsExcel:SetCelBold(.T.)	
	            	oFWMsExcel:SetCelBgColor("#FFD700")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela4,cPasta4, aLinhaAux4,aColsMa4)
	        	elseif alltrim(aLinhaAux4[1]) == "TOTAL GERAL"
	            	oFWMsExcel:SetCelBold(.T.)	
	            	oFWMsExcel:SetCelBgColor("#008000")
	            	oFWMsExcel:SetCelFrColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela4,cPasta4, aLinhaAux4,aColsMa4)
	        	elseif nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela4,cPasta4, aLinhaAux4,aColsMa4)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela4,cPasta4, aLinhaAux4,aColsMa4)
	        		nCL		:= 1
	        	
	        	endif

            TRB4->(DbSkip())

        EndDo

        TRB4->(dbgotop())
      
    /*************** TRB5 Booking Total****************/ 
 
        //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela5) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela5,cPasta5)
    
    	aAdd(aColunas5, cNPROP)			// 1
        aAdd(aColunas5, cSTATUS)		// 2				
        aAdd(aColunas5, cFXBUD)			// 3							
        aAdd(aColunas5, cFEAEXEC)		// 4				
        aAdd(aColunas5, cOPPNAME)		// 5
        aAdd(aColunas5, cCOUNTRY)		// 6	
        aAdd(aColunas5, cMARKSEC)		// 7
        aAdd(aColunas5, cINDUSTR)		// 8
        aAdd(aColunas5, cSALPER)		// 9
        aAdd(aColunas5, cSALREP)		// 10
        aAdd(aColunas5, cEQUIPDES)		// 11
        //aAdd(aColunas5, cDIMENS)		// 12
        aAdd(aColunas5, cFORECL)		// 13						
        aAdd(aColunas5, cFOREAMM)		// 14	
        aAdd(aColunas5, cCONTRMG)		// 15	
        aAdd(aColunas5, cVCONTMG)		// 16
        aAdd(aColunas5, cCOGS)			// 17
        aAdd(aColunas5, cCOMISS)		// 18
        aAdd(aColunas5, cVCOMISS)		// 19
        aAdd(aColunas5, cPGET)			// 20
        aAdd(aColunas5, cPGO)			// 21
        aAdd(aColunas5, cSALAMOU)		// 22
        aAdd(aColunas5, cSALCONT)		// 23
        
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cNPROP,1,2)					// 1 numero proposta						
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cSTATUS,1,2)					// 2 status			
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cFXBUD,1,2)					// 3 fixed / budget		
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cFEAEXEC,1,2)				// 4 viabilidade / execu��o
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cOPPNAME,1,2)				// 5 oportunidade
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cCOUNTRY,1,2)				// 6 pais
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cMARKSEC,1,2)				// 7 mercado
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cINDUSTR,1,2)				// 8 produto
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cSALPER,1,2)					// 9 responsavel
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cSALREP,1,2)					// 10 representante
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cEQUIPDES,1,2)				// 11 equipament     
        //oFWMsExcel:AddColumn(cTabela5,cPasta5, cDIMENS,1,2)					// 12 dimensoes			
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cFORECL,1,2)					// 13 previsao venda
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cFOREAMM,1,2)				// 14 venda s/ tributos
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cCONTRMG,1,2)				// 15 % margem contrib.
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cVCONTMG,1,2)				// 16 margem contrib
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cCOGS,1,2)					// 17 cogs
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cCOMISS,1,2)					// 18 % comissao
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cVCOMISS,1,2)				// 19 comissao
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cPGET,1,2)					// 20 % get
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cPGO,1,2)					// 21 % go
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cSALAMOU,1,2)				// 22 montante vendas
        oFWMsExcel:AddColumn(cTabela5,cPasta5, cSALCONT,1,2)				// 23 montante contrib.

    For nAux := 1 To Len(aColunas5)
         aAdd(aColsMa5,  nX5 )
         nX5++
    Next
        nCL	:= 1
        TRB5->(dbgotop())
                            
        While  !(TRB5->(EoF()))
        
        	//MsProcTxt("Processando registro: "+alltrim(TRB5->NPROP5))
        	//ProcessMessage()
         
        	aLinhaAux5 := Array(Len(aColunas5))
        	aLinhaAux5[1] := TRB5->NPROP5
        	aLinhaAux5[2] := TRB5->STATUS5
        	aLinhaAux5[3] := TRB5->FXBUD5
        	aLinhaAux5[4] := TRB5->FEAEXEC5
        	aLinhaAux5[5] := TRB5->OPPNAME5
        	aLinhaAux5[6] := TRB5->COUNTRY5
        	aLinhaAux5[7] := TRB5->MARKSEC5
        	aLinhaAux5[8] := TRB5->INDUSTR5
        	aLinhaAux5[9] := TRB5->SALPER5
        	aLinhaAux5[10] := TRB5->SALREP5
        	aLinhaAux5[11] := TRB5->EQUIPDES5
        	//aLinhaAux5[12] := TRB5->DIMENS5
        	aLinhaAux5[12] := TRB5->CFORECL5
        	aLinhaAux5[13] := TRB5->FOREAMM5
        	aLinhaAux5[14] := TRB5->CONTRMG5
        	aLinhaAux5[15] := TRB5->VCONTRMG5
        	aLinhaAux5[16] := TRB5->COGS5
        	aLinhaAux5[17] := TRB5->COMMISS5
        	aLinhaAux5[18] := TRB5->VCOMMISS5	
        	aLinhaAux5[19] := TRB5->PGET5
        	aLinhaAux5[20] := TRB5->PGO5
        	aLinhaAux5[21] := TRB5->SALAMOU5
        	aLinhaAux5[22] := TRB5->SALCONT5	
	        
	        
        		if alltrim(aLinhaAux5[1]) == "TOTAL"
	            	oFWMsExcel:SetCelBold(.T.)	
	            	oFWMsExcel:SetCelBgColor("#FFD700")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela5,cPasta5, aLinhaAux5,aColsMa5)
	        	elseif alltrim(aLinhaAux5[1]) == "TOTAL GERAL"
	            	oFWMsExcel:SetCelBold(.T.)	
	            	oFWMsExcel:SetCelBgColor("#008000")
	            	oFWMsExcel:SetCelFrColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela5,cPasta5, aLinhaAux5,aColsMa5)
	        	elseif nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela5,cPasta5, aLinhaAux5,aColsMa5)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	            	oFWMsExcel:SetCelFrColor("#000000")
	        		oFWMsExcel:AddRow(cTabela5,cPasta5, aLinhaAux5,aColsMa5)
	        		nCL		:= 1
	        	
	        	endif
	 
            TRB5->(DbSkip())

        EndDo

        TRB5->(dbgotop())

    /**************************************/
    
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
Static Function SFMudaCor2(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB2->NPROP2) ==  "TOTAL GERAL"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB2->NPROP2) ==  "TOTAL"; _cCor := CLR_YELLOW ; endif
      
    endif
Return _cCor

Static Function SFMudaCor3(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB3->NPROP3) ==  "TOTAL GERAL"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB3->NPROP3) ==  "TOTAL"; _cCor := CLR_YELLOW ; endif
      
    endif
Return _cCor

Static Function SFMudaCor4(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB4->NPROP4) ==  "TOTAL GERAL"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB4->NPROP4) ==  "TOTAL"; _cCor := CLR_YELLOW ; endif
      
    endif
Return _cCor

Static Function SFMudaCor5(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB5->NPROP5) ==  "TOTAL GERAL"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB5->NPROP5) ==  "TOTAL"; _cCor := CLR_YELLOW ; endif
      
    endif
Return _cCor

Static Function SFMudaCor7(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB7->NPROP7) ==  "TOTAL GERAL"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB7->NPROP7) ==  "TOTAL"; _cCor := CLR_YELLOW ; endif
      
    endif
Return _cCor

/********************************************************/
Static function zAtualizar()

	pergunte(cPerg,.T.)
	
		
	/*****************/
	
	DbSelectArea("TRB13")
	TRB13->(dbgotop())
	zap
	MSAguarde({||zDetProp()},"Proposals Details")
	TRB13->(dbgotop())
	
	DbSelectArea("TRB1")
	TRB1->(dbgotop())
	zap
	MSAguarde({|| zNPROPGER()},"General list of proposals")
	TRB1->(dbgotop())
	
	DbSelectArea("TRB2")
	TRB2->(dbgotop())
	zap
	MSAguarde({||zMARKPL()},"Marketing Platform")
	TRB2->(dbgotop())
	
	DbSelectArea("TRB3")
	TRB3->(dbgotop())
	zap
	MSAguarde({||zBookBR()},"Booking BR")
	TRB3->(dbgotop())
	
	DbSelectArea("TRB4")
	TRB4->(dbgotop())
	zap
	MSAguarde({||zBookSA()},"Booking SA")
	TRB4->(dbgotop())
	
	DbSelectArea("TRB5")
	TRB5->(dbgotop())
	zap
	MSAguarde({||zBookTT()},"Booking Total")
	TRB5->(dbgotop())
	
	DbSelectArea("TRB6")
	TRB6->(dbgotop())
	zap
	MSAguarde({|| zPREVPPS()},"Spare parts & Field service (v1) ")
	MSAguarde({|| zGERPROP()},"General list of proposals")
	TRB6->(dbgotop())
	
	DbSelectArea("TRB7")
	TRB7->(dbgotop())
	zap
	MSAguarde({|| zSPAREP()},"Spare parts & Field service (v2)")
	TRB7->(dbgotop())
	
	DbSelectArea("TRB8")
	zap
	MSAguarde({||zMKTotal()},"Count Marketing Platform")
	
	DbSelectArea("TRB9")
	zap
	MSAguarde({||zBRTotal()},"Count Booking BR")
	MSAguarde({||zSATotal()},"Count Booking SA")
	MSAguarde({||zTTTotal()},"Count Booking Total")
	
	DbSelectArea("TRB12")
	zap
	MSAguarde({||zACTTotal()},"Count Active Total")
	MSAguarde({||zVDTotal()},"Count Sold Total")
	MSAguarde({||zLOSTTotal()},"Count Lost Total")
	
	_oDlgSint:Refresh()
	
Return nil



/******************************************************/
Static Function EditTRB1()
    Local aArea       := GetArea()
    Local aAreaSZ9    := SZ9->(GetArea())
    Local nOpcao1      := 0
    Local cItemZ9	  := alltrim(TRB1->NPROP)
   
    Private cCadastro 
 
   	cCadastro := "Altera��o Proposta"
    
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


/**********Editar SZF **************/
static Function fAltTRB13()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= alltrim(SZF->ZF_IDVEND)
Local oGet2
Local cGet2 	:= SZF->ZF_ITEM
Local oGet3
Local cGet3		:= SZF->ZF_CODPROD
Local oGet4	
Local cGet4		:= SZF->ZF_DESCRI
Local oGet5	
Local cGet5		:= SZF->ZF_DIMENS
Local oGet6	
Local cGet6		:= SZF->ZF_QUANT
Local oGet7	
Local cGet7		:= SZF->ZF_TOTVSI
Local oGet8	
Local cGet8		:= SZF->ZF_MKPFIN
Local oGet9	
Local cGet9		:= SZF->ZF_NPROP

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

Local nTotReg := 0

Local _nOpcSZF := 0
Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0

Static _oDlgSZF

  DEFINE MSDIALOG _oDlgSZF TITLE "Detalhes Proposta (1)" FROM 000, 000  TO 0280, 1025 COLORS 0, 16777215 PIXEL

   oGroup1:= TGroup():New(0005,0005,0035,0505,'',_oDlgSZF,,,.T.)
   oGroup2:= TGroup():New(0040,0005,0070,0505,'',_oDlgSZF,,,.T.)
   oGroup3:= TGroup():New(0075,0005,0105,0505,'',_oDlgSZF,,,.T.)
   //oGroup4:= TGroup():New(0110,0005,0140,0505,'',_oDlgSZF,,,.T.)
   
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "IDVend" 	SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 007, 063 SAY oSay9 PROMPT "No.Proposta" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet9 VAR cGet9   When .F. SIZE 072, 010 	COLORS 0, 16777215 PIXEL
   
	@ 042, 010 SAY oSay3 PROMPT "Cod.Equip." SIZE 032, 007  COLORS 0, 16777215 PIXEL
	@ 051, 010 MSGET oGet3 VAR cGet3 Picture "@!" Pixel F3 "SZA" SIZE  048, 010 COLORS 0, 16777215 PIXEL
		
	@ 042, 073 SAY oSay4 PROMPT "Equipamento" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	@ 051, 070 MSGET oGet4 VAR cGet4 When .F. SIZE 215, 010  COLORS 0, 16777215 PIXEL
	    
	@ 042, 303 SAY oSay5 PROMPT "Dimensoes" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	@ 051, 301 MSGET oGet5 VAR cGet5 When .T. SIZE 195, 010  COLORS 0, 16777215 PIXEL
	
	@ 076, 010 SAY oSay6 PROMPT "Quantidade" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	@ 085, 010 MSGET oGet6 VAR cGet6 PICTURE PesqPict("SZF","ZF_QUANT") When .T. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	@ 076, 080 SAY oSay7 PROMPT "Total s/ Trib." SIZE 050, 007  COLORS 0, 16777215 PIXEL
	@ 085, 080 MSGET oGet7 VAR cGet7 PICTURE PesqPict("SZF","ZF_TOTVSI") When .T. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	
	@ 076, 150 SAY oSay8 PROMPT "Margem Contribuicao" SIZE 050, 007  COLORS 0, 16777215 PIXEL
	@ 085, 150 MSGET oGet8 VAR cGet8 PICTURE PesqPict("SZF","ZF_MKPFIN") When .T. SIZE 060, 010 COLORS 0, 16777215 PIXEL
	   	

    @ 120, 160 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlgSZF:End() ) SIZE 070, 010  PIXEL
    @ 120, 240 BUTTON oButton2 PROMPT "OK" Action( _nOpcSZF := 1, _oDlgSZF:End() ) SIZE 070, 010  PIXEL
      
  ACTIVATE MSDIALOG _oDlgSZF CENTERED
  
  If _nOpcSZF = 1
  	Reclock("SZF",.F.)
 
  		SZF->ZF_CODPROD		:= cGet3 
  		SZF->ZF_DESCRI		:= cGet4
  		SZF->ZF_DIMENS		:= cGet5
  		SZF->ZF_QUANT		:= cGet6
  		SZF->ZF_TOTVSI		:= cGet7
  		SZF->ZF_MKPFIN		:= cGet8
  		
  	MsUnlock()
  Endif
  
	Reclock("TRB13",.F.)

		TRB13->CODPROD		:= cGet3
		TRB13->DESCRI		:= cGet4
		TRB13->DIMENS		:= cGet5
		TRB13->QUANT		:= cGet6
		TRB13->TOTVSI		:= cGet7
		TRB13->MGCONT		:= cGet8
	
	MsUnlock()
   

  
Return _nOpcSZF

/*******************************************/

Static Function EditTRB2()
    Local aArea       := GetArea()
    Local aAreaSZ9    := SZ9->(GetArea())
    Local nOpcao      := 0
    Local cItemZ92	  := alltrim(TRB2->NPROP2)
   
    Private cCadastro 
 
   	cCadastro := "Alteracao Proposta"
    
	DbSelectArea("SZ9")
	SZ9->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	SZ9->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If SZ9->(DbSeek(xFilial('SZ9')+cItemZ92))
	    	
	        nOpcao := fAltTRB2()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	       
	EndIf
	
	RestArea(aAreaSZ9)
    RestArea(aArea)
Return
/**********************************/
static Function fAltTRB2()
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

Local _nOpc := 0
local cFor2 		:= ""
Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0
Local nXTOTSI		:= 0
Local nXCUSTOT		:= 0
Local cEQUIPDES		:= ""

Local oChkBox1 
Local lCheck1 	:= SZ9->Z9_GETFAV
Local oChkBox2 
Local lCheck2 	:= SZ9->Z9_GETBEN
Local oChkBox3 
Local lCheck3 	:= SZ9->Z9_GETPIL
Local oChkBox4 
Local lCheck4 	:= SZ9->Z9_GETPRO
Local oChkBox5 
Local lCheck5 	:= SZ9->Z9_GETSEC
Local oChkBox6 
Local lCheck6 	:= SZ9->Z9_GETEQU
Local oChkBox7 
Local lCheck7 	:= SZ9->Z9_GETAPP
Local oChkBox8 
Local lCheck8 	:= SZ9->Z9_GETPRE
Local oChkBox9 
Local lCheck9 	:= SZ9->Z9_GETECO
Local oChkBox10 
Local lCheck10 	:= SZ9->Z9_GETVAL
Local oChkBox11 
Local lCheck11 	:= SZ9->Z9_GETGAT
Local oChkBox12 
Local lCheck12 	:= SZ9->Z9_GETINF
Local oChkBox13 
Local lCheck13 	:= SZ9->Z9_GETDEC
Local oChkBox14 
Local lCheck14 	:= SZ9->Z9_GETDEL
Local oChkBox15 
Local lCheck15 	:= SZ9->Z9_GETSHO

Local oChkBox16 
Local lCheck16 	:= SZ9->Z9_GOCON
Local oChkBox17 
Local lCheck17 	:= SZ9->Z9_GOFEA
Local oChkBox18 
Local lCheck18 	:= SZ9->Z9_GOPRE
Local oChkBox19 
Local lCheck19 	:= SZ9->Z9_GOECO
Local oChkBox20 
Local lCheck20 	:= SZ9->Z9_GOSCO
Local oChkBox21 
Local lCheck21 	:= SZ9->Z9_GOPREL
Local oChkBox22 
Local lCheck22 	:= SZ9->Z9_GOQUOT
Local oChkBox23 
Local lCheck23 	:= SZ9->Z9_GOLETT
Local oChkBox24 
Local lCheck24 	:= SZ9->Z9_GOPLAC

local nGETFAV, nGETBEN, nGETPIL, nGETPRO, nGETSEC, nGETEQU, nGETAPP, nGETPRE, nGETECO, nGETVAL, nGETGAT, nGETINF, nGETDEC, nGETDEL, nGETSHO
Local nTGET	:= 0
Local nTGO	:= 0

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
elseif cGet27 = "4"
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

  @ 002,002 FOLDER oFolder2 SIZE  aSize[6]+300,aSize[5]+100 OF _oDlg ;
  	ITEMS "Detalhes", "Get & Go" COLORS 0, 16777215 PIXEL

  _oGetDbAnalit := MsGetDb():New(aPosObj[1,1]+220,aPosObj[1,2],aPosObj[1,3]-30,aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB13",,,,oFolder2:aDialogs[1])
  
  if cGet29 = "7"
  		msginfo("Registro nao pode ser editado.")
  else
  		_oGetDbAnalit:oBrowse:BlDblClick := {|| EditSZF() }
  endif
  
  oGroup1:= TGroup():New(0005,0005,0035,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup2:= TGroup():New(0040,0005,0070,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup3:= TGroup():New(0075,0005,0105,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup4:= TGroup():New(0110,0005,0140,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup5:= TGroup():New(0145,0005,0175,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup6:= TGroup():New(0180,0005,0210,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup7:= TGroup():New(0215,0005,0245,0505,'',oFolder2:aDialogs[1],,,.T.)
  
  oGroup10:= TGroup():New(0005,0005,0315,0195,'GET',oFolder2:aDialogs[2],,,.T.)
  oGroup11:= TGroup():New(0005,0200,0315,0505,'GO',oFolder2:aDialogs[2],,,.T.)
        
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "Numro Proposta" 	SIZE 020, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 063 SAY oSay2 PROMPT "Classifica��o" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 061 MSGET oGet2 VAR cClass   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 145 SAY oSay3 PROMPT "Mercado" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 142 MSGET oGet3 VAR cMerc   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 225 SAY oSay4 PROMPT "Prod.Final"  SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 222 MSGET oGet4 VAR cGet4  Picture "@!" Pixel F3 "ZZJ" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 295 SAY oSay5 PROMPT "Tipo" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 292 MSGET oGet5 VAR cTipo   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    if cGet29 = "7"
	    @ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /*********************************/
	    @ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 010 MSGET oGet8 VAR cGet8 When .F.  SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	    @ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    @ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 285 MSGET oGet10 VAR cGet10 When .F.  SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 230, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	 	/********************************/    
	    @ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 071 MSGET oGet16 VAR cGet16 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 131 MSGET oGet17 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 191 MSGET oGet18 VAR cGet18 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /*********************************/
	    @ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 010 MSGET oGet19 VAR cGet19  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 270 MSGET oGet21 VAR cGet21  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /*******************************/
	    @ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 010 MSGET oGet23 VAR cGet23  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 247 MSGET oGet25 VAR cGet25  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /********************************/
	    @ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 010 MSGET oGet27 VAR cGet27 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 230 MSGET oGet28 VAR cGet28 When .F. SIZE 260, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	else
		@ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
        
	    @ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    /********************************/
	    @ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 010 MSGET oGet8 VAR cGet8 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	    @ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    @ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 285 MSGET oGet10 VAR cGet10 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /******************************/
	    
	    @ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1]PIXEL
	    
	    @ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1]PIXEL
	    @ 085, 071 MSGET oGet16 VAR cGet16 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 131 MSGET oGet17 VAR cGet15 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 191 MSGET oGet18 VAR cGet18 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /***************************/
	    @ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 010 MSGET oGet19 VAR cGet19 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 270 MSGET oGet21 VAR cGet21 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /**************************/
	    @ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 010 MSGET oGet23 VAR cGet23 Picture "@!" Pixel F3 "SYA_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 247 MSGET oGet25 VAR cGet25 Picture "@!" Pixel F3 "SA3" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /***************************/
	    @ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 010 MSGET oGet27 VAR cGet27 When .T. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 230 MSGET oGet28 VAR cGet28 When .T. SIZE 260, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	endif

    
    if nTotReg > 0
	    @ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 150 SAY oSay32 PROMPT "% Fiancas" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	
    else
    	@ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 150 SAY oSay32 PROMPT "% Fiancas" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
  	
	endif
	
	/********************** FIM DETALHES ********************/
	/********************** GET GO ********************/
	//@ 020, 030 SAY oSay41 PROMPT "Favourable front end position involvement" 	SIZE 100, 007  COLORS 0, 16777215  OF oFolder2:aDialogs[2] PIXEL 
    //@ 020, 010 MSGET oGet41 VAR cGet41 When .T. SIZE 015, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[2] PIXEL
    
    @ 020,010 CHECKBOX oChkBox1 VAR lCheck1 PROMPT "Favourable front end position involvement (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 040,010 CHECKBOX oChkBox2 VAR lCheck2 PROMPT "Bench testing (2,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 060,010 CHECKBOX oChkBox3 VAR lCheck3 PROMPT "Pilot testing (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 080,010 CHECKBOX oChkBox4 VAR lCheck4 PROMPT "Process advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 100,010 CHECKBOX oChkBox5 VAR lCheck5 PROMPT "Specification advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 120,010 CHECKBOX oChkBox6 VAR lCheck6 PROMPT "Equipment Installed with similar application (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 140,010 CHECKBOX oChkBox7 VAR lCheck7 PROMPT "Equipment installed on same application (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 160,010 CHECKBOX oChkBox8 VAR lCheck8 PROMPT "Preferred  Vendor (2,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 180,010 CHECKBOX oChkBox9 VAR lCheck9 PROMPT "Economic advantage (10%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 200,010 CHECKBOX oChkBox10 VAR lCheck10 PROMPT "Value added advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 220,010 CHECKBOX oChkBox11 VAR lCheck11 PROMPT "Gatekeeper (2.5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 240,010 CHECKBOX oChkBox12 VAR lCheck12 PROMPT "Influencer good historical relationship (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 260,010 CHECKBOX oChkBox13 VAR lCheck13 PROMPT "Decision maker, good historical relationship (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 280,010 CHECKBOX oChkBox14 VAR lCheck14 PROMPT "Delivery mechanism exceeds competion (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 300,010 CHECKBOX oChkBox15 VAR lCheck15 PROMPT "Short listed and given opportunity for final presentation (17,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    
    @ 020,210 CHECKBOX oChkBox16 VAR lCheck16 PROMPT "Concept/Pre-feasability: Project Identified, preliminary budget (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 040,210 CHECKBOX oChkBox17 VAR lCheck17 PROMPT "Feasibility: budget quote prelim process design. (10%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 060,210 CHECKBOX oChkBox18 VAR lCheck18 PROMPT "Preliminary Design & process Selection. (20%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 080,210 CHECKBOX oChkBox19 VAR lCheck19 PROMPT "Economic evaluation: Pilot testing, Sampling and site evaluation approved, Funds approved for design phase (30%)" SIZE 300,15  OF oFolder2:aDialogs[2] PIXEL
    @ 100,210 CHECKBOX oChkBox20 VAR lCheck20 PROMPT "Scope finalized, design finalized, economics confirmed, final budget. (50%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 120,210 CHECKBOX oChkBox21 VAR lCheck21 PROMPT "Preliminary board, final changes to flow sheet approval final proposal and Compliance date. (80%)" SIZE 300,15  OF oFolder2:aDialogs[2] PIXEL
    @ 140,210 CHECKBOX oChkBox22 VAR lCheck22 PROMPT "Final quotation scope of supply.(85%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 160,210 CHECKBOX oChkBox23 VAR lCheck23 PROMPT "Letter of Intent. (90%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 180,210 CHECKBOX oChkBox24 VAR lCheck24 PROMPT "Final order placed (100%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
     
	/********************** FIM GET GO ********************/
	
    @ aPosObj[2,1]+5 ,005 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 070, 015  PIXEL
    @ aPosObj[2,1]+5 , 105 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 070, 015  PIXEL
  
  ACTIVATE MSDIALOG _oDlg CENTERED
  
 
  If _nOpc = 1
  	
  	Reclock("SZ9",.F.)
 
  		SZ9->Z9_BOOK	 	:= SUBSTR(oComboBx1,1,1)
  		SZ9->Z9_INDUSTR		:= cGet4 
  		SZ9->Z9_IDCONTR		:= cGet8
  		SZ9->Z9_CONTR		:= cGet9
  		SZ9->Z9_IDCLFIN		:= cGet10
  		SZ9->Z9_CLIFIN		:= cGet11
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
  		
  		SZ9->Z9_GETFAV		:= lCheck1
  		SZ9->Z9_GETBEN		:= lCheck2
  		SZ9->Z9_GETPIL		:= lCheck3
  		SZ9->Z9_GETPRO		:= lCheck4
  		SZ9->Z9_GETSEC		:= lCheck5
  		SZ9->Z9_GETEQU		:= lCheck6
  		SZ9->Z9_GETAPP		:= lCheck7
  		SZ9->Z9_GETPRE		:= lCheck8
  		SZ9->Z9_GETECO		:= lCheck9
  		SZ9->Z9_GETVAL		:= lCheck10
  		SZ9->Z9_GETGAT		:= lCheck11
  		SZ9->Z9_GETINF		:= lCheck12
  		SZ9->Z9_GETDEC		:= lCheck13
  		SZ9->Z9_GETDEL		:= lCheck14
  		SZ9->Z9_GETSHO		:= lCheck15
  		
  		if lCheck1 = .T.
  			nGETFAV := 5
  		else 
  			nGETFAV := 0
  		endif
  		if lCheck2 = .T.
  			nGETBEN := 2.5
  		else
  			nGETBEN := 0
  		endif
  		if lCheck3 = .T.
  			nGETPIL := 5
  		else
  			nGETPIL := 0
  		endif
  		if lCheck4 = .T.
  			nGETPRO := 7.5
  		else
  			nGETPRO := 0
  		endif
  		if lCheck5 = .T.
  		 	nGETSEC := 7.5
  		else
  		 	nGETSEC := 0
  		endif
  		if lCheck6 = .T.
  		 	nGETEQU := 5
  		else
  			nGETEQU := 0
  		endif
  		if lCheck7 = .T.
  			nGETAPP := 7.5
  		else
  			nGETAPP := 0
  		endif
  		if lCheck8 = .T.
  		 	nGETPRE := 2.5
  		else
  			nGETPRE := 0
  		endif
  		if lCheck9 = .T.
  			nGETECO := 10
  		else
  			nGETECO := 0
  		endif
  		if lCheck10 = .T.
  			nGETVAL := 7.5
  		else
  		 	nGETVAL := 0
  		endif
  		if lCheck11 = .T.
  			nGETGAT := 2.5
  		else
  		 	nGETGAT := 0
  		endif
  		if lCheck12 = .T.
  			nGETINF := 5
  		else
  			nGETINF := 0
  		endif
  		if lCheck13 = .T.
  			nGETDEC := 7.5
  		else
  		 	nGETDEC := 0
  		endif
  		if lCheck14 = .T.
  			nGETDEL := 7.5
  		else
  		 	nGETDEL := 0
  		endif
  		if lCheck15 = .T.
  			nGETSHO := 17.5
  		else
  		 	nGETSHO := 0
  		endif
  		
  		nTGET := nGETFAV + nGETBEN + nGETPIL + nGETPRO + nGETSEC + nGETEQU + nGETAPP + nGETPRE + nGETECO + nGETVAL + nGETGAT + nGETINF + nGETDEC + nGETDEL + nGETSHO
  		
  		SZ9->Z9_PGET		:= nTGET
  		
  		if lCheck16 = .T.
  			SZ9->Z9_GOCON		:= lCheck16
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		SZ9->Z9_GOCON		:= lCheck16
  			SZ9->Z9_GOFEA		:= lCheck16
  			SZ9->Z9_GOPRE		:= lCheck16
	  		SZ9->Z9_GOECO		:= lCheck16
	  		SZ9->Z9_GOSCO		:= lCheck16
	  		SZ9->Z9_GOPREL		:= lCheck16
	  		SZ9->Z9_GOQUOT		:= lCheck16
	  		SZ9->Z9_GOLETT		:= lCheck16
	  		SZ9->Z9_GOPLAC		:= lCheck16
  		endif
  		
  		if lCheck17 = .T.
  			SZ9->Z9_GOCON		:= lCheck17
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck17
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck17
	  		SZ9->Z9_GOECO		:= lCheck17
	  		SZ9->Z9_GOSCO		:= lCheck17
	  		SZ9->Z9_GOPREL		:= lCheck17
	  		SZ9->Z9_GOQUOT		:= lCheck17
	  		SZ9->Z9_GOLETT		:= lCheck17
	  		SZ9->Z9_GOPLAC		:= lCheck17
  		endif	
  		
  		if lCheck18 = .T.
  			SZ9->Z9_GOCON		:= lCheck18
  			SZ9->Z9_GOFEA		:= lCheck18
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck18
  			//SZ9->Z9_GOFEA		:= lCheck18
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck18
	  		SZ9->Z9_GOSCO		:= lCheck18
	  		SZ9->Z9_GOPREL		:= lCheck18
	  		SZ9->Z9_GOQUOT		:= lCheck18
	  		SZ9->Z9_GOLETT		:= lCheck18
	  		SZ9->Z9_GOPLAC		:= lCheck18
  		endif
  		
  		if lCheck19 = .T.
  			SZ9->Z9_GOCON		:= lCheck19
  			SZ9->Z9_GOFEA		:= lCheck19
  			SZ9->Z9_GOPRE		:= lCheck19
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck19
  			//SZ9->Z9_GOFEA		:= lCheck19
  			//SZ9->Z9_GOPRE		:= lCheck19
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck19
	  		SZ9->Z9_GOPREL		:= lCheck19
	  		SZ9->Z9_GOQUOT		:= lCheck19
	  		SZ9->Z9_GOLETT		:= lCheck19
	  		SZ9->Z9_GOPLAC		:= lCheck19
  		endif
  		
  		if lCheck20 = .T.
  			SZ9->Z9_GOCON		:= lCheck20
  			SZ9->Z9_GOFEA		:= lCheck20
  			SZ9->Z9_GOPRE		:= lCheck20
	  		SZ9->Z9_GOECO		:= lCheck20
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck20
  			//SZ9->Z9_GOFEA		:= lCheck20
  			//SZ9->Z9_GOPRE		:= lCheck20
	  		//SZ9->Z9_GOECO		:= lCheck20
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck20
	  		SZ9->Z9_GOQUOT		:= lCheck20
	  		SZ9->Z9_GOLETT		:= lCheck20
	  		SZ9->Z9_GOPLAC		:= lCheck20
  		endif
  		
  		if lCheck21 = .T.
  			SZ9->Z9_GOCON		:= lCheck21
  			SZ9->Z9_GOFEA		:= lCheck21
  			SZ9->Z9_GOPRE		:= lCheck21
	  		SZ9->Z9_GOECO		:= lCheck21
	  		SZ9->Z9_GOSCO		:= lCheck21
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck21
  			//SZ9->Z9_GOFEA		:= lCheck21
  			//SZ9->Z9_GOPRE		:= lCheck21
	  		//SZ9->Z9_GOECO		:= lCheck21
	  		//SZ9->Z9_GOSCO		:= lCheck21
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck21
	  		SZ9->Z9_GOLETT		:= lCheck21
	  		SZ9->Z9_GOPLAC		:= lCheck21
  		endif
  		
  		if lCheck22 = .T.
  			SZ9->Z9_GOCON		:= lCheck22
  			SZ9->Z9_GOFEA		:= lCheck22
  			SZ9->Z9_GOPRE		:= lCheck22
	  		SZ9->Z9_GOECO		:= lCheck22
	  		SZ9->Z9_GOSCO		:= lCheck22
	  		SZ9->Z9_GOPREL		:= lCheck22
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck22
	  		SZ9->Z9_GOPLAC		:= lCheck22
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck22
  			//SZ9->Z9_GOFEA		:= lCheck22
  			//SZ9->Z9_GOPRE		:= lCheck22
	  		//SZ9->Z9_GOECO		:= lCheck22
	  		//SZ9->Z9_GOSCO		:= lCheck22
	  		//SZ9->Z9_GOPREL	:= lCheck22
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck22
	  		SZ9->Z9_GOPLAC		:= lCheck22
  		endif
  		
  		if lCheck23 = .T.
  			SZ9->Z9_GOCON		:= lCheck23
  			SZ9->Z9_GOFEA		:= lCheck23
  			SZ9->Z9_GOPRE		:= lCheck23
	  		SZ9->Z9_GOECO		:= lCheck23
	  		SZ9->Z9_GOSCO		:= lCheck23
	  		SZ9->Z9_GOPREL		:= lCheck23
	  		SZ9->Z9_GOQUOT		:= lCheck23
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck22
  			//SZ9->Z9_GOFEA		:= lCheck22
  			//SZ9->Z9_GOPRE		:= lCheck22
	  		//SZ9->Z9_GOECO		:= lCheck22
	  		//SZ9->Z9_GOSCO		:= lCheck22
	  		//SZ9->Z9_GOPREL	:= lCheck22
	  		//SZ9->Z9_GOQUOT	:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck23
  		endif
  		
  		if lCheck24 = .T.
  			SZ9->Z9_GOCON		:= lCheck24
  			SZ9->Z9_GOFEA		:= lCheck24
  			SZ9->Z9_GOPRE		:= lCheck24
	  		SZ9->Z9_GOECO		:= lCheck24
	  		SZ9->Z9_GOSCO		:= lCheck24
	  		SZ9->Z9_GOPREL		:= lCheck24
	  		SZ9->Z9_GOQUOT		:= lCheck24
	  		SZ9->Z9_GOLETT		:= lCheck24
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck24
  			//SZ9->Z9_GOFEA		:= lCheck24
  			//SZ9->Z9_GOPRE		:= lCheck24
	  		//SZ9->Z9_GOECO		:= lCheck24
	  		//SZ9->Z9_GOSCO		:= lCheck24
	  		//SZ9->Z9_GOPREL	:= lCheck24
	  		//SZ9->Z9_GOQUOT	:= lCheck24
	  		//SZ9->Z9_GOLETT	:= lCheck24
	  		SZ9->Z9_GOPLAC		:= lCheck24
  		endif
  		
  		if lCheck16 = .F. //.AND.lCheck17 = .F. .AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 0
  			nTGO				:= 0
  			
  		endif
  		
  		if lCheck16 = .T. //.AND.lCheck17 = .F. .AND. lCheck18 = .F. .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 5
  			nTGO				:= 5
  			
  		endif
  		
  		if lCheck17 = .T. //.AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 10
  			nTGO				:= 10
  			
  		endif
  		
  		if lCheck18 = .T. //.AND. lCheck19 = .F. .AND.  ;
  		   // lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 20
  			nTGO				:= 20
  			
  		endif
  		
  		if  lCheck19 = .T. //.AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 30
  			nTGO				:= 30
  			
  		endif
  		
  		if lCheck20 = .T. //.AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 50
  			nTGO				:= 50
  			
  		endif
  		
  		if  lCheck21 = .T. //.AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 80
  			nTGO				:= 80
  			
  		endif
  		
  		if  lCheck22 = .T. //.AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 85
  			nTGO				:= 85
  			
  		endif
  		
  		if lCheck23 = .T. //.AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 90
  			nTGO				:= 90
  			
  		endif
  		
  		if  lCheck24 = .T. 
  			SZ9->Z9_PGO			:= 100
  			nTGO				:= 100
  			
  		endif

  	MsUnlock()

  
  
	Reclock("TRB2",.F.)
		
		if SUBSTR(oComboBx1,1,1) = "1"
			TRB2->BOOK2 	:= "GENERAL"
		elseIF SUBSTR(oComboBx1,1,1) = "2"
			TRB2->BOOK2 	:= "MARKETING PLATFORM"
		elseIF SUBSTR(oComboBx1,1,1) = "3"
			TRB2->BOOK2 	:= "BOOKING"
		else
			TRB2->BOOK2 	:= ""
		endif

		if MV_PAR03 = 1
			if SUBSTR(oComboBx3,1,1) = "1"
				TRB2->STATUS2 	:= "ACTIVE"
			elseIF SUBSTR(oComboBx3,1,1) = "2"
				TRB2->STATUS2 	:= "CANCELED"
			elseIF SUBSTR(oComboBx3,1,1) = "3"
				TRB2->STATUS2 	:= "DECLINED"
			elseIF SUBSTR(oComboBx3,1,1) = "4"
				TRB2->STATUS2 	:= "NOT SENT"
			elseIF SUBSTR(oComboBx3,1,1) = "5"
				TRB2->STATUS2 	:= "LOST"
			elseIF SUBSTR(oComboBx3,1,1) = "6"
				TRB2->STATUS2 	:= "SLC"
			elseIF SUBSTR(oComboBx3,1,1) = "7"
				TRB2->STATUS2 	:= "SOLD"
			else
				TRB2->STATUS2 	:= ""
			endif
		else
			if SUBSTR(oComboBx3,1,1) = "1"
				TRB2->STATUS2 	:= "ATIVA"
			elseIF SUBSTR(oComboBx3,1,1) = "2"
				TRB2->STATUS2 	:= "CANCELADA"
			elseIF SUBSTR(oComboBx3,1,1) = "3"
				TRB2->STATUS2 	:= "DECLINADA"
			elseIF SUBSTR(oComboBx3,1,1) = "4"
				TRB2->STATUS2 	:= "NAO ENVIADA"
			elseIF SUBSTR(oComboBx3,1,1) = "5"
				TRB2->STATUS2 	:= "PERDIDA"
			elseIF SUBSTR(oComboBx3,1,1) = "6"
				TRB2->STATUS2 	:= "SLC"
			elseIF SUBSTR(oComboBx3,1,1) = "7"
				TRB2->STATUS2 	:= "VENDIDA"
			else
				TRB2->STATUS2 	:= ""
			endif
		endif
		if MV_PAR03 = 1
			if empty(cGet4)
				TRB2->INDUSTR2 := ""
			else
				TRB2->INDUSTR2 := Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(cGet4),"ZZJ_PRODIN")
			endif
		else
			if empty(cGet4)
				TRB2->INDUSTR2 := ""
			else
				TRB2->INDUSTR2		:= cGet4
			endif
		endif
		TRB2->OPPNAME2		:= cGet9
		TRB2->CODEQ2			:= cGet12
		
		/************* Descricao Equipamento **************/
		cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(cGet1) + "'"
			
		IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

		ProcRegua(QUERY2->(reccount()))
			
		SZF->(dbgotop())
		
		while QUERY2->(!eof())
		
			if MV_PAR03 = 1
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
	
		TRB2->EQUIPDES2	:= alltrim(cEQUIPDES)
		/*************************************************/
		
		//TRB1->EQUIPDES		:= cGet13
		
		TRB2->DIMENS2		:= cGet14
		TRB2->FORECL2		:= cGet18
		TRB2->SALPER2		:= cGet22
		TRB2->SALREP2		:= cGet26
		TRB2->COUNTRY2		:= cGet24	
		
		/*************************************/
		cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(cGet1) + "'"
			
		IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

		ProcRegua(QUERY2->(reccount()))
			
		SZF->(dbgotop())
		
		while QUERY2->(!eof())

			nXTOTSI 		+= QUERY2->ZF_TOTVSI
			QUERY2->(dbskip())

		enddo	
		TRB2->FOREAMM2	:= nXTOTSI
		QUERY2->(dbgotop())
				
		while QUERY2->(!eof())

			nXCUSTOT 		+= QUERY2->ZF_TOTVSI-(QUERY2->ZF_TOTVSI*(QUERY2->ZF_MKPFIN/100))

			QUERY2->(dbskip())

		enddo	
		
		/*******************************/
		
		TRB2->FOREAMM2		:= nXTOTSI
		
		nVCOMIS 			:= nXTOTSI * (cGet36/100)
		nCOGS				:= nXCUSTOT - nVCOMIS	
		nVCONTMG			:= nXTOTSI - nCOGS - nVCOMIS
				
		TRB2->COMMISS2		:= cGet36
		TRB2->VCOMMISS2		:= (nXTOTSI * (cGet36/100))
		TRB2->COGS2			:= nCOGS
		TRB2->CONTRMG2		:= (nVCONTMG / nXTOTSI)*100 
		TRB2->VCONTRMG2		:= nVCONTMG
		
		TRB2->PGET2			:= nTGET
		TRB2->PGO2			:= nTGO
		TRB2->SALAMOU2		:= nXTOTSI * ((nTGET/100) * (nTGO /100))
  		TRB2->SALCONT2		:= (nVCONTMG)  * (nTGET /100) * (nTGO /100)
	MsUnlock()
	
	
  	Reclock("SZ9",.F.)
   		
  		if lCheck16 = .F. //.AND.lCheck17 = .F. .AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck16 = .T. //.AND.lCheck17 = .F. .AND. lCheck18 = .F. .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck17 = .T. //.AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck18 = .T. //.AND. lCheck19 = .F. .AND.  ;
  		   // lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck19 = .T. //.AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck20 = .T. //.AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck21 = .T. //.AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck22 = .T. //.AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck23 = .T. //.AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck24 = .T. 
   			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif

  	MsUnlock()
  Endif
  
	
  
	SZF->(DbGoTop())
    TSZF->(DbCloseArea()) 
    QUERY2->(DbCloseArea())
    
Return _nOpc

/*************************************************/
Static Function EditTRB3()
    Local aArea       := GetArea()
    Local aAreaSZ9    := SZ9->(GetArea())
    Local nOpcao      := 0
    Local cItemZ93	  := alltrim(TRB3->NPROP3)
    
    Private cCadastro 
 
   	cCadastro := "Alteracao Proposta"
    
	DbSelectArea("SZ9")
	SZ9->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	SZ9->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If SZ9->(DbSeek(xFilial('SZ9')+cItemZ93))
	    	
	        nOpcao := fAltTRB3()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	 elseif alltrim(cItemZ93) == "TOTAL" .OR. alltrim(cItemZ93) == "TOTAL GERAL"
	 	msginfo("Registro nao pode editado.")
	 else
	 	EditTRB7d()
	 
	       
	EndIf
	
    RestArea(aAreaSZ9)
    RestArea(aArea)
    
Return
/**********************************/
Static Function EditTRB7d()
    Local aArea       := GetArea()
    Local aAreaZZI    := ZZI->(GetArea())
    Local nOpcao1      := 0
    Local cItemZZI	  := alltrim(TRB3->ID3)
   
    Private cCadastro 
 
   	cCadastro := "Alteracao Proposta"
    
	DbSelectArea("ZZI")
	ZZI->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	ZZI->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If ZZI->(DbSeek(xFilial('ZZI')+cItemZZI))
	    	
	        nOpcao1 := fAltTRB7()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	       
	EndIf
	
    RestArea(aAreaZZI)
    RestArea(aArea)
Return
/***************************************/

static Function fAltTRB3()
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

Local _nOpc := 0
local cFor2 		:= ""
Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0
Local nXTOTSI		:= 0
Local nXCUSTOT		:= 0
Local cEQUIPDES		:= ""

Local oChkBox1 
Local lCheck1 	:= SZ9->Z9_GETFAV
Local oChkBox2 
Local lCheck2 	:= SZ9->Z9_GETBEN
Local oChkBox3 
Local lCheck3 	:= SZ9->Z9_GETPIL
Local oChkBox4 
Local lCheck4 	:= SZ9->Z9_GETPRO
Local oChkBox5 
Local lCheck5 	:= SZ9->Z9_GETSEC
Local oChkBox6 
Local lCheck6 	:= SZ9->Z9_GETEQU
Local oChkBox7 
Local lCheck7 	:= SZ9->Z9_GETAPP
Local oChkBox8 
Local lCheck8 	:= SZ9->Z9_GETPRE
Local oChkBox9 
Local lCheck9 	:= SZ9->Z9_GETECO
Local oChkBox10 
Local lCheck10 	:= SZ9->Z9_GETVAL
Local oChkBox11 
Local lCheck11 	:= SZ9->Z9_GETGAT
Local oChkBox12 
Local lCheck12 	:= SZ9->Z9_GETINF
Local oChkBox13 
Local lCheck13 	:= SZ9->Z9_GETDEC
Local oChkBox14 
Local lCheck14 	:= SZ9->Z9_GETDEL
Local oChkBox15 
Local lCheck15 	:= SZ9->Z9_GETSHO

Local oChkBox16 
Local lCheck16 	:= SZ9->Z9_GOCON
Local oChkBox17 
Local lCheck17 	:= SZ9->Z9_GOFEA
Local oChkBox18 
Local lCheck18 	:= SZ9->Z9_GOPRE
Local oChkBox19 
Local lCheck19 	:= SZ9->Z9_GOECO
Local oChkBox20 
Local lCheck20 	:= SZ9->Z9_GOSCO
Local oChkBox21 
Local lCheck21 	:= SZ9->Z9_GOPREL
Local oChkBox22 
Local lCheck22 	:= SZ9->Z9_GOQUOT
Local oChkBox23 
Local lCheck23 	:= SZ9->Z9_GOLETT
Local oChkBox24 
Local lCheck24 	:= SZ9->Z9_GOPLAC

local nGETFAV, nGETBEN, nGETPIL, nGETPRO, nGETSEC, nGETEQU, nGETAPP, nGETPRE, nGETECO, nGETVAL, nGETGAT, nGETINF, nGETDEC, nGETDEL, nGETSHO
Local nTGET	:= 0
Local nTGO	:= 0

local cFiltra 	:= ""

//Static _oDlg

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

Private _oGetDbAnalit
Private _oDlg

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
elseif cGet27 = "4"
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

  @ 002,002 FOLDER oFolder2 SIZE  aSize[6]+300,aSize[5]+100 OF _oDlg ;
  	ITEMS "Detalhes", "Get & Go" COLORS 0, 16777215 PIXEL

  _oGetDbAnalit := MsGetDb():New(aPosObj[1,1]+220,aPosObj[1,2],aPosObj[1,3]-30,aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB13",,,,oFolder2:aDialogs[1])
  
  if cGet29 = "7"
  		msginfo("Registro nao pode ser editado.")
  else
  		_oGetDbAnalit:oBrowse:BlDblClick := {|| EditSZF() }
  endif
  
  oGroup1:= TGroup():New(0005,0005,0035,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup2:= TGroup():New(0040,0005,0070,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup3:= TGroup():New(0075,0005,0105,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup4:= TGroup():New(0110,0005,0140,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup5:= TGroup():New(0145,0005,0175,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup6:= TGroup():New(0180,0005,0210,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup7:= TGroup():New(0215,0005,0245,0505,'',oFolder2:aDialogs[1],,,.T.)
  
  oGroup10:= TGroup():New(0005,0005,0315,0195,'GET',oFolder2:aDialogs[2],,,.T.)
  oGroup11:= TGroup():New(0005,0200,0315,0505,'GO',oFolder2:aDialogs[2],,,.T.)
        
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "Numro Proposta" 	SIZE 020, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 063 SAY oSay2 PROMPT "Classificacao" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 061 MSGET oGet2 VAR cClass   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 145 SAY oSay3 PROMPT "Mercado" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 142 MSGET oGet3 VAR cMerc   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 225 SAY oSay4 PROMPT "Prod.Final"  SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 222 MSGET oGet4 VAR cGet4  Picture "@!" Pixel F3 "ZZJ" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 295 SAY oSay5 PROMPT "Tipo" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 292 MSGET oGet5 VAR cTipo   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    if cGet29 = "7"
	    @ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /*********************************/
	    @ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 010 MSGET oGet8 VAR cGet8 When .F.  SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	    @ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    @ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 285 MSGET oGet10 VAR cGet10 When .F.  SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 230, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	 	/********************************/    
	    @ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 071 MSGET oGet16 VAR cGet16 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 131 MSGET oGet17 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 191 MSGET oGet18 VAR cGet18 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /*********************************/
	    @ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 010 MSGET oGet19 VAR cGet19  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 270 MSGET oGet21 VAR cGet21  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /*******************************/
	    @ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 010 MSGET oGet23 VAR cGet23  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 247 MSGET oGet25 VAR cGet25  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /********************************/
	    @ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 010 MSGET oGet27 VAR cGet27 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 230 MSGET oGet28 VAR cGet28 When .F. SIZE 260, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	else
		@ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
        
	    @ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    /********************************/
	    @ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 010 MSGET oGet8 VAR cGet8 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	    @ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    @ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 285 MSGET oGet10 VAR cGet10 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /******************************/
	    
	    @ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1]PIXEL
	    
	    @ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1]PIXEL
	    @ 085, 071 MSGET oGet16 VAR cGet16 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 131 MSGET oGet17 VAR cGet15 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 191 MSGET oGet18 VAR cGet18 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /***************************/
	    @ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 010 MSGET oGet19 VAR cGet19 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 270 MSGET oGet21 VAR cGet21 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /**************************/
	    @ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 010 MSGET oGet23 VAR cGet23 Picture "@!" Pixel F3 "SYA_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 247 MSGET oGet25 VAR cGet25 Picture "@!" Pixel F3 "SA3" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /***************************/
	    @ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 010 MSGET oGet27 VAR cGet27 When .T. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 230 MSGET oGet28 VAR cGet28 When .T. SIZE 260, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	endif

    
    if nTotReg > 0
	    @ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 150 SAY oSay32 PROMPT "% Fiancas" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	
    else
    	@ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 150 SAY oSay32 PROMPT "% Fiancas" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
  	
	endif
	
	/********************** FIM DETALHES ********************/
	/********************** GET GO ********************/
	//@ 020, 030 SAY oSay41 PROMPT "Favourable front end position involvement" 	SIZE 100, 007  COLORS 0, 16777215  OF oFolder2:aDialogs[2] PIXEL 
    //@ 020, 010 MSGET oGet41 VAR cGet41 When .T. SIZE 015, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[2] PIXEL
    
    @ 020,010 CHECKBOX oChkBox1 VAR lCheck1 PROMPT "Favourable front end position involvement (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 040,010 CHECKBOX oChkBox2 VAR lCheck2 PROMPT "Bench testing (2,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 060,010 CHECKBOX oChkBox3 VAR lCheck3 PROMPT "Pilot testing (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 080,010 CHECKBOX oChkBox4 VAR lCheck4 PROMPT "Process advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 100,010 CHECKBOX oChkBox5 VAR lCheck5 PROMPT "Specification advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 120,010 CHECKBOX oChkBox6 VAR lCheck6 PROMPT "Equipment Installed with similar application (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 140,010 CHECKBOX oChkBox7 VAR lCheck7 PROMPT "Equipment installed on same application (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 160,010 CHECKBOX oChkBox8 VAR lCheck8 PROMPT "Preferred  Vendor (2,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 180,010 CHECKBOX oChkBox9 VAR lCheck9 PROMPT "Economic advantage (10%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 200,010 CHECKBOX oChkBox10 VAR lCheck10 PROMPT "Value added advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 220,010 CHECKBOX oChkBox11 VAR lCheck11 PROMPT "Gatekeeper (2.5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 240,010 CHECKBOX oChkBox12 VAR lCheck12 PROMPT "Influencer good historical relationship (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 260,010 CHECKBOX oChkBox13 VAR lCheck13 PROMPT "Decision maker, good historical relationship (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 280,010 CHECKBOX oChkBox14 VAR lCheck14 PROMPT "Delivery mechanism exceeds competion (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 300,010 CHECKBOX oChkBox15 VAR lCheck15 PROMPT "Short listed and given opportunity for final presentation (17,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    
    @ 020,210 CHECKBOX oChkBox16 VAR lCheck16 PROMPT "Concept/Pre-feasability: Project Identified, preliminary budget (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 040,210 CHECKBOX oChkBox17 VAR lCheck17 PROMPT "Feasibility: budget quote prelim process design. (10%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 060,210 CHECKBOX oChkBox18 VAR lCheck18 PROMPT "Preliminary Design & process Selection. (20%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 080,210 CHECKBOX oChkBox19 VAR lCheck19 PROMPT "Economic evaluation: Pilot testing, Sampling and site evaluation approved, Funds approved for design phase (30%)" SIZE 300,15  OF oFolder2:aDialogs[2] PIXEL
    @ 100,210 CHECKBOX oChkBox20 VAR lCheck20 PROMPT "Scope finalized, design finalized, economics confirmed, final budget. (50%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 120,210 CHECKBOX oChkBox21 VAR lCheck21 PROMPT "Preliminary board, final changes to flow sheet approval final proposal and Compliance date. (80%)" SIZE 300,15  OF oFolder2:aDialogs[2] PIXEL
    @ 140,210 CHECKBOX oChkBox22 VAR lCheck22 PROMPT "Final quotation scope of supply.(85%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 160,210 CHECKBOX oChkBox23 VAR lCheck23 PROMPT "Letter of Intent. (90%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 180,210 CHECKBOX oChkBox24 VAR lCheck24 PROMPT "Final order placed (100%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
     
	/********************** FIM GET GO ********************/
	
    @ aPosObj[2,1]+5 ,005 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 070, 015  PIXEL
    @ aPosObj[2,1]+5 , 105 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 070, 015  PIXEL
  
  ACTIVATE MSDIALOG _oDlg CENTERED
  
 
  If _nOpc = 1
  	
  	Reclock("SZ9",.F.)
 
  		SZ9->Z9_BOOK	 	:= SUBSTR(oComboBx1,1,1)
  		SZ9->Z9_INDUSTR		:= cGet4 
  		SZ9->Z9_IDCONTR		:= cGet8
  		SZ9->Z9_CONTR		:= cGet9
  		SZ9->Z9_IDCLFIN		:= cGet10
  		SZ9->Z9_CLIFIN		:= cGet11
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
  		
  		SZ9->Z9_GETFAV		:= lCheck1
  		SZ9->Z9_GETBEN		:= lCheck2
  		SZ9->Z9_GETPIL		:= lCheck3
  		SZ9->Z9_GETPRO		:= lCheck4
  		SZ9->Z9_GETSEC		:= lCheck5
  		SZ9->Z9_GETEQU		:= lCheck6
  		SZ9->Z9_GETAPP		:= lCheck7
  		SZ9->Z9_GETPRE		:= lCheck8
  		SZ9->Z9_GETECO		:= lCheck9
  		SZ9->Z9_GETVAL		:= lCheck10
  		SZ9->Z9_GETGAT		:= lCheck11
  		SZ9->Z9_GETINF		:= lCheck12
  		SZ9->Z9_GETDEC		:= lCheck13
  		SZ9->Z9_GETDEL		:= lCheck14
  		SZ9->Z9_GETSHO		:= lCheck15
  		
  		if lCheck1 = .T.
  			nGETFAV := 5
  		else 
  			nGETFAV := 0
  		endif
  		if lCheck2 = .T.
  			nGETBEN := 2.5
  		else
  			nGETBEN := 0
  		endif
  		if lCheck3 = .T.
  			nGETPIL := 5
  		else
  			nGETPIL := 0
  		endif
  		if lCheck4 = .T.
  			nGETPRO := 7.5
  		else
  			nGETPRO := 0
  		endif
  		if lCheck5 = .T.
  		 	nGETSEC := 7.5
  		else
  		 	nGETSEC := 0
  		endif
  		if lCheck6 = .T.
  		 	nGETEQU := 5
  		else
  			nGETEQU := 0
  		endif
  		if lCheck7 = .T.
  			nGETAPP := 7.5
  		else
  			nGETAPP := 0
  		endif
  		if lCheck8 = .T.
  		 	nGETPRE := 2.5
  		else
  			nGETPRE := 0
  		endif
  		if lCheck9 = .T.
  			nGETECO := 10
  		else
  			nGETECO := 0
  		endif
  		if lCheck10 = .T.
  			nGETVAL := 7.5
  		else
  		 	nGETVAL := 0
  		endif
  		if lCheck11 = .T.
  			nGETGAT := 2.5
  		else
  		 	nGETGAT := 0
  		endif
  		if lCheck12 = .T.
  			nGETINF := 5
  		else
  			nGETINF := 0
  		endif
  		if lCheck13 = .T.
  			nGETDEC := 7.5
  		else
  		 	nGETDEC := 0
  		endif
  		if lCheck14 = .T.
  			nGETDEL := 7.5
  		else
  		 	nGETDEL := 0
  		endif
  		if lCheck15 = .T.
  			nGETSHO := 17.5
  		else
  		 	nGETSHO := 0
  		endif
  		
  		nTGET := nGETFAV + nGETBEN + nGETPIL + nGETPRO + nGETSEC + nGETEQU + nGETAPP + nGETPRE + nGETECO + nGETVAL + nGETGAT + nGETINF + nGETDEC + nGETDEL + nGETSHO
  		
  		SZ9->Z9_PGET		:= nTGET
  		
  		if lCheck16 = .T.
  			SZ9->Z9_GOCON		:= lCheck16
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		SZ9->Z9_GOCON		:= lCheck16
  			SZ9->Z9_GOFEA		:= lCheck16
  			SZ9->Z9_GOPRE		:= lCheck16
	  		SZ9->Z9_GOECO		:= lCheck16
	  		SZ9->Z9_GOSCO		:= lCheck16
	  		SZ9->Z9_GOPREL		:= lCheck16
	  		SZ9->Z9_GOQUOT		:= lCheck16
	  		SZ9->Z9_GOLETT		:= lCheck16
	  		SZ9->Z9_GOPLAC		:= lCheck16
  		endif
  		
  		if lCheck17 = .T.
  			SZ9->Z9_GOCON		:= lCheck17
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck17
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck17
	  		SZ9->Z9_GOECO		:= lCheck17
	  		SZ9->Z9_GOSCO		:= lCheck17
	  		SZ9->Z9_GOPREL		:= lCheck17
	  		SZ9->Z9_GOQUOT		:= lCheck17
	  		SZ9->Z9_GOLETT		:= lCheck17
	  		SZ9->Z9_GOPLAC		:= lCheck17
  		endif	
  		
  		if lCheck18 = .T.
  			SZ9->Z9_GOCON		:= lCheck18
  			SZ9->Z9_GOFEA		:= lCheck18
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck18
  			//SZ9->Z9_GOFEA		:= lCheck18
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck18
	  		SZ9->Z9_GOSCO		:= lCheck18
	  		SZ9->Z9_GOPREL		:= lCheck18
	  		SZ9->Z9_GOQUOT		:= lCheck18
	  		SZ9->Z9_GOLETT		:= lCheck18
	  		SZ9->Z9_GOPLAC		:= lCheck18
  		endif
  		
  		if lCheck19 = .T.
  			SZ9->Z9_GOCON		:= lCheck19
  			SZ9->Z9_GOFEA		:= lCheck19
  			SZ9->Z9_GOPRE		:= lCheck19
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck19
  			//SZ9->Z9_GOFEA		:= lCheck19
  			//SZ9->Z9_GOPRE		:= lCheck19
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck19
	  		SZ9->Z9_GOPREL		:= lCheck19
	  		SZ9->Z9_GOQUOT		:= lCheck19
	  		SZ9->Z9_GOLETT		:= lCheck19
	  		SZ9->Z9_GOPLAC		:= lCheck19
  		endif
  		
  		if lCheck20 = .T.
  			SZ9->Z9_GOCON		:= lCheck20
  			SZ9->Z9_GOFEA		:= lCheck20
  			SZ9->Z9_GOPRE		:= lCheck20
	  		SZ9->Z9_GOECO		:= lCheck20
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck20
  			//SZ9->Z9_GOFEA		:= lCheck20
  			//SZ9->Z9_GOPRE		:= lCheck20
	  		//SZ9->Z9_GOECO		:= lCheck20
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck20
	  		SZ9->Z9_GOQUOT		:= lCheck20
	  		SZ9->Z9_GOLETT		:= lCheck20
	  		SZ9->Z9_GOPLAC		:= lCheck20
  		endif
  		
  		if lCheck21 = .T.
  			SZ9->Z9_GOCON		:= lCheck21
  			SZ9->Z9_GOFEA		:= lCheck21
  			SZ9->Z9_GOPRE		:= lCheck21
	  		SZ9->Z9_GOECO		:= lCheck21
	  		SZ9->Z9_GOSCO		:= lCheck21
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck21
  			//SZ9->Z9_GOFEA		:= lCheck21
  			//SZ9->Z9_GOPRE		:= lCheck21
	  		//SZ9->Z9_GOECO		:= lCheck21
	  		//SZ9->Z9_GOSCO		:= lCheck21
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck21
	  		SZ9->Z9_GOLETT		:= lCheck21
	  		SZ9->Z9_GOPLAC		:= lCheck21
  		endif
  		
  		if lCheck22 = .T.
  			SZ9->Z9_GOCON		:= lCheck22
  			SZ9->Z9_GOFEA		:= lCheck22
  			SZ9->Z9_GOPRE		:= lCheck22
	  		SZ9->Z9_GOECO		:= lCheck22
	  		SZ9->Z9_GOSCO		:= lCheck22
	  		SZ9->Z9_GOPREL		:= lCheck22
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck22
	  		SZ9->Z9_GOPLAC		:= lCheck22
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck22
  			//SZ9->Z9_GOFEA		:= lCheck22
  			//SZ9->Z9_GOPRE		:= lCheck22
	  		//SZ9->Z9_GOECO		:= lCheck22
	  		//SZ9->Z9_GOSCO		:= lCheck22
	  		//SZ9->Z9_GOPREL	:= lCheck22
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck22
	  		SZ9->Z9_GOPLAC		:= lCheck22
  		endif
  		
  		if lCheck23 = .T.
  			SZ9->Z9_GOCON		:= lCheck23
  			SZ9->Z9_GOFEA		:= lCheck23
  			SZ9->Z9_GOPRE		:= lCheck23
	  		SZ9->Z9_GOECO		:= lCheck23
	  		SZ9->Z9_GOSCO		:= lCheck23
	  		SZ9->Z9_GOPREL		:= lCheck23
	  		SZ9->Z9_GOQUOT		:= lCheck23
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck22
  			//SZ9->Z9_GOFEA		:= lCheck22
  			//SZ9->Z9_GOPRE		:= lCheck22
	  		//SZ9->Z9_GOECO		:= lCheck22
	  		//SZ9->Z9_GOSCO		:= lCheck22
	  		//SZ9->Z9_GOPREL	:= lCheck22
	  		//SZ9->Z9_GOQUOT	:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck23
  		endif
  		
  		if lCheck24 = .T.
  			SZ9->Z9_GOCON		:= lCheck24
  			SZ9->Z9_GOFEA		:= lCheck24
  			SZ9->Z9_GOPRE		:= lCheck24
	  		SZ9->Z9_GOECO		:= lCheck24
	  		SZ9->Z9_GOSCO		:= lCheck24
	  		SZ9->Z9_GOPREL		:= lCheck24
	  		SZ9->Z9_GOQUOT		:= lCheck24
	  		SZ9->Z9_GOLETT		:= lCheck24
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck24
  			//SZ9->Z9_GOFEA		:= lCheck24
  			//SZ9->Z9_GOPRE		:= lCheck24
	  		//SZ9->Z9_GOECO		:= lCheck24
	  		//SZ9->Z9_GOSCO		:= lCheck24
	  		//SZ9->Z9_GOPREL	:= lCheck24
	  		//SZ9->Z9_GOQUOT	:= lCheck24
	  		//SZ9->Z9_GOLETT	:= lCheck24
	  		SZ9->Z9_GOPLAC		:= lCheck24
  		endif
  		
  		if lCheck16 = .F. //.AND.lCheck17 = .F. .AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 0
  			nTGO				:= 0
  			
  		endif
  		
  		if lCheck16 = .T. //.AND.lCheck17 = .F. .AND. lCheck18 = .F. .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 5
  			nTGO				:= 5
  			
  		endif
  		
  		if lCheck17 = .T. //.AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 10
  			nTGO				:= 10
  			
  		endif
  		
  		if lCheck18 = .T. //.AND. lCheck19 = .F. .AND.  ;
  		   // lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 20
  			nTGO				:= 20
  			
  		endif
  		
  		if  lCheck19 = .T. //.AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 30
  			nTGO				:= 30
  			
  		endif
  		
  		if lCheck20 = .T. //.AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 50
  			nTGO				:= 50
  			
  		endif
  		
  		if  lCheck21 = .T. //.AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 80
  			nTGO				:= 80
  			
  		endif
  		
  		if  lCheck22 = .T. //.AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 85
  			nTGO				:= 85
  			
  		endif
  		
  		if lCheck23 = .T. //.AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 90
  			nTGO				:= 90
  			
  		endif
  		
  		if  lCheck24 = .T. 
  			SZ9->Z9_PGO			:= 100
  			nTGO				:= 100
  			
  		endif

  	MsUnlock()

  
  
	Reclock("TRB3",.F.)
		
		if SUBSTR(oComboBx1,1,1) = "1"
			TRB3->BOOK3 	:= "GENERAL"
		elseIF SUBSTR(oComboBx1,1,1) = "2"
			TRB3->BOOK3 	:= "MARKETING PLATFORM"
		elseIF SUBSTR(oComboBx1,1,1) = "3"
			TRB3->BOOK3 	:= "BOOKING"
		else
			TRB3->BOOK3 	:= ""
		endif

		if MV_PAR03 = 1
			if SUBSTR(oComboBx3,1,1) = "1"
				TRB3->STATUS3 	:= "ACTIVE"
			elseIF SUBSTR(oComboBx3,1,1) = "2"
				TRB3->STATUS3 	:= "CANCELED"
			elseIF SUBSTR(oComboBx3,1,1) = "3"
				TRB3->STATUS3 	:= "DECLINED"
			elseIF SUBSTR(oComboBx3,1,1) = "4"
				TRB3->STATUS3 	:= "NOT SENT"
			elseIF SUBSTR(oComboBx3,1,1) = "5"
				TRB3->STATUS3 	:= "LOST"
			elseIF SUBSTR(oComboBx3,1,1) = "6"
				TRB3->STATUS3 	:= "SLC"
			elseIF SUBSTR(oComboBx3,1,1) = "7"
				TRB3->STATUS3 	:= "SOLD"
			else
				TRB3->STATUS3 	:= ""
			endif
		else
			if SUBSTR(oComboBx3,1,1) = "1"
				TRB3->STATUS3 	:= "ATIVA"
			elseIF SUBSTR(oComboBx3,1,1) = "2"
				TRB3->STATUS3 	:= "CANCELADA"
			elseIF SUBSTR(oComboBx3,1,1) = "3"
				TRB3->STATUS3 	:= "DECLINADA"
			elseIF SUBSTR(oComboBx3,1,1) = "4"
				TRB3->STATUS3 	:= "NAO ENVIADA"
			elseIF SUBSTR(oComboBx3,1,1) = "5"
				TRB3->STATUS3 	:= "PERDIDA"
			elseIF SUBSTR(oComboBx3,1,1) = "6"
				TRB3->STATUS3 	:= "SLC"
			elseIF SUBSTR(oComboBx3,1,1) = "7"
				TRB3->STATUS3 	:= "VENDIDA"
			else
				TRB3->STATUS3 	:= ""
			endif
		endif
		if MV_PAR03 = 1
			if empty(cGet4)
				TRB3->INDUSTR3 := ""
			else
				TRB3->INDUSTR3 := Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(cGet4),"ZZJ_PRODIN")
			endif
		else
			if empty(cGet4)
				TRB3->INDUSTR3 := ""
			else
				TRB3->INDUSTR3		:= cGet4
			endif
		endif
		TRB3->OPPNAME3		:= cGet9
		TRB3->CODEQ3			:= cGet12
		
		/************* Descricao Equipamento **************/
		cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(cGet1) + "'"
			
		IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

		ProcRegua(QUERY2->(reccount()))
			
		SZF->(dbgotop())
		
		while QUERY2->(!eof())
		
			if MV_PAR03 = 1
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
	
		TRB3->EQUIPDES3	:= alltrim(cEQUIPDES)
		/*************************************************/
		
		//TRB1->EQUIPDES		:= cGet13
		
		TRB3->DIMENS3		:= cGet14
		TRB3->FORECL3		:= cGet18
		TRB3->SALPER3		:= cGet22
		TRB3->SALREP3		:= cGet26
		TRB3->COUNTRY3		:= cGet24	
		
		/*************************************/
		cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(cGet1) + "'"
			
		IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

		ProcRegua(QUERY2->(reccount()))
			
		SZF->(dbgotop())
		
		while QUERY2->(!eof())

			nXTOTSI 		+= QUERY2->ZF_TOTVSI
			QUERY2->(dbskip())

		enddo	
		TRB2->FOREAMM2	:= nXTOTSI
		QUERY2->(dbgotop())
				
		while QUERY2->(!eof())

			nXCUSTOT 		+= QUERY2->ZF_TOTVSI-(QUERY2->ZF_TOTVSI*(QUERY2->ZF_MKPFIN/100))

			QUERY2->(dbskip())

		enddo	
		
		/*******************************/
		
		TRB3->FOREAMM3		:= nXTOTSI
		
		nVCOMIS 			:= nXTOTSI * (cGet36/100)
		nCOGS				:= nXCUSTOT - nVCOMIS	
		nVCONTMG			:= nXTOTSI - nCOGS - nVCOMIS
				
		TRB3->COMMISS3		:= cGet36
		TRB3->VCOMMISS3		:= (nXTOTSI * (cGet36/100))
		TRB3->COGS3			:= nCOGS
		TRB3->CONTRMG3		:= (nVCONTMG / nXTOTSI)*100 
		TRB3->VCONTRMG3		:= nVCONTMG
		
		TRB3->PGET3			:= nTGET
		TRB3->PGO3			:= nTGO
		TRB3->SALAMOU3		:= nXTOTSI * ((nTGET/100) * (nTGO /100))
  		TRB3->SALCONT3		:= (nVCONTMG)  * (nTGET /100) * (nTGO /100)
	MsUnlock()
	
	
  	Reclock("SZ9",.F.)
   		
  		if lCheck16 = .F. //.AND.lCheck17 = .F. .AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck16 = .T. //.AND.lCheck17 = .F. .AND. lCheck18 = .F. .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck17 = .T. //.AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck18 = .T. //.AND. lCheck19 = .F. .AND.  ;
  		   // lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck19 = .T. //.AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck20 = .T. //.AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck21 = .T. //.AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck22 = .T. //.AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck23 = .T. //.AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck24 = .T. 
   			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif

  	MsUnlock()
  Endif
  
	
  
	SZF->(DbGoTop())
    TSZF->(DbCloseArea()) 
    QUERY2->(DbCloseArea())

Return _nOpc

/**********************************/
Static Function EditTRB4()
    Local aArea       := GetArea()
    Local aAreaSZ9    := SZ9->(GetArea())
    Local nOpcao      := 0
    Local cItemZ94	  := alltrim(TRB4->NPROP4)
   
    Private cCadastro 
 
   	cCadastro := "Alteracao Proposta"
    
	DbSelectArea("SZ9")
	SZ9->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	SZ9->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If SZ9->(DbSeek(xFilial('SZ9')+cItemZ94))
	    	
	        nOpcao := fAltTRB4()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Aten��o")
	        EndIf
	 elseif alltrim(cItemZ94) == "TOTAL" .OR. alltrim(cItemZ94) == "TOTAL GERAL"
	 	msginfo("Registro nao pode editado.")
	 else
	 	EditTRB7c()
   
	EndIf
	
	nOpcao := ""
    RestArea(aAreaSZ9)
    RestArea(aArea)
Return
/**********************************/
Static Function EditTRB7c()
    Local aArea       := GetArea()
    Local aAreaZZI    := ZZI->(GetArea())
    Local nOpcao1      := 0
    Local cItemZZI	  := alltrim(TRB4->ID4)
   
    Private cCadastro 
 
   	cCadastro := "Altera��o Proposta"
    
	DbSelectArea("ZZI")
	ZZI->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	ZZI->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If ZZI->(DbSeek(xFilial('ZZI')+cItemZZI))
	    	
	        nOpcao1 := fAltTRB7()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Aten��o")
	        EndIf
	       
	EndIf
	
    RestArea(aAreaZZI)
    RestArea(aArea)
Return
/***********************************/
static Function fAltTRB4()
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

Local _nOpc := 0
local cFor2 		:= ""
Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0
Local nXTOTSI		:= 0
Local nXCUSTOT		:= 0
Local cEQUIPDES		:= ""

Local oChkBox1 
Local lCheck1 	:= SZ9->Z9_GETFAV
Local oChkBox2 
Local lCheck2 	:= SZ9->Z9_GETBEN
Local oChkBox3 
Local lCheck3 	:= SZ9->Z9_GETPIL
Local oChkBox4 
Local lCheck4 	:= SZ9->Z9_GETPRO
Local oChkBox5 
Local lCheck5 	:= SZ9->Z9_GETSEC
Local oChkBox6 
Local lCheck6 	:= SZ9->Z9_GETEQU
Local oChkBox7 
Local lCheck7 	:= SZ9->Z9_GETAPP
Local oChkBox8 
Local lCheck8 	:= SZ9->Z9_GETPRE
Local oChkBox9 
Local lCheck9 	:= SZ9->Z9_GETECO
Local oChkBox10 
Local lCheck10 	:= SZ9->Z9_GETVAL
Local oChkBox11 
Local lCheck11 	:= SZ9->Z9_GETGAT
Local oChkBox12 
Local lCheck12 	:= SZ9->Z9_GETINF
Local oChkBox13 
Local lCheck13 	:= SZ9->Z9_GETDEC
Local oChkBox14 
Local lCheck14 	:= SZ9->Z9_GETDEL
Local oChkBox15 
Local lCheck15 	:= SZ9->Z9_GETSHO

Local oChkBox16 
Local lCheck16 	:= SZ9->Z9_GOCON
Local oChkBox17 
Local lCheck17 	:= SZ9->Z9_GOFEA
Local oChkBox18 
Local lCheck18 	:= SZ9->Z9_GOPRE
Local oChkBox19 
Local lCheck19 	:= SZ9->Z9_GOECO
Local oChkBox20 
Local lCheck20 	:= SZ9->Z9_GOSCO
Local oChkBox21 
Local lCheck21 	:= SZ9->Z9_GOPREL
Local oChkBox22 
Local lCheck22 	:= SZ9->Z9_GOQUOT
Local oChkBox23 
Local lCheck23 	:= SZ9->Z9_GOLETT
Local oChkBox24 
Local lCheck24 	:= SZ9->Z9_GOPLAC

local nGETFAV, nGETBEN, nGETPIL, nGETPRO, nGETSEC, nGETEQU, nGETAPP, nGETPRE, nGETECO, nGETVAL, nGETGAT, nGETINF, nGETDEC, nGETDEL, nGETSHO
Local nTGET	:= 0
Local nTGO	:= 0

local cFiltra 	:= ""

//Static _oDlg

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

Private _oGetDbAnalit
Private _oDlg

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
elseif cGet27 = "4"
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

  @ 002,002 FOLDER oFolder2 SIZE  aSize[6]+300,aSize[5]+100 OF _oDlg ;
  	ITEMS "Detalhes", "Get & Go" COLORS 0, 16777215 PIXEL

  _oGetDbAnalit := MsGetDb():New(aPosObj[1,1]+220,aPosObj[1,2],aPosObj[1,3]-30,aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB13",,,,oFolder2:aDialogs[1])
  
  if cGet29 = "7"
  		msginfo("Registro nao pode ser editado.")
  else
  		_oGetDbAnalit:oBrowse:BlDblClick := {|| EditSZF() }
  endif
  
  oGroup1:= TGroup():New(0005,0005,0035,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup2:= TGroup():New(0040,0005,0070,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup3:= TGroup():New(0075,0005,0105,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup4:= TGroup():New(0110,0005,0140,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup5:= TGroup():New(0145,0005,0175,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup6:= TGroup():New(0180,0005,0210,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup7:= TGroup():New(0215,0005,0245,0505,'',oFolder2:aDialogs[1],,,.T.)
  
  oGroup10:= TGroup():New(0005,0005,0315,0195,'GET',oFolder2:aDialogs[2],,,.T.)
  oGroup11:= TGroup():New(0005,0200,0315,0505,'GO',oFolder2:aDialogs[2],,,.T.)
        
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "Numro Proposta" 	SIZE 020, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 063 SAY oSay2 PROMPT "Classifica��o" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 061 MSGET oGet2 VAR cClass   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 145 SAY oSay3 PROMPT "Mercado" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 142 MSGET oGet3 VAR cMerc   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 225 SAY oSay4 PROMPT "Prod.Final"  SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 222 MSGET oGet4 VAR cGet4  Picture "@!" Pixel F3 "ZZJ" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 295 SAY oSay5 PROMPT "Tipo" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 292 MSGET oGet5 VAR cTipo   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    if cGet29 = "7"
	    @ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /*********************************/
	    @ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 010 MSGET oGet8 VAR cGet8 When .F.  SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	    @ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    @ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 285 MSGET oGet10 VAR cGet10 When .F.  SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 230, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	 	/********************************/    
	    @ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 071 MSGET oGet16 VAR cGet16 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 131 MSGET oGet17 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 191 MSGET oGet18 VAR cGet18 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /*********************************/
	    @ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 010 MSGET oGet19 VAR cGet19  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 270 MSGET oGet21 VAR cGet21  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /*******************************/
	    @ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 010 MSGET oGet23 VAR cGet23  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 247 MSGET oGet25 VAR cGet25  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /********************************/
	    @ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 010 MSGET oGet27 VAR cGet27 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 230 MSGET oGet28 VAR cGet28 When .F. SIZE 260, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	else
		@ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
        
	    @ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    /********************************/
	    @ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 010 MSGET oGet8 VAR cGet8 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	    @ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    @ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 285 MSGET oGet10 VAR cGet10 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /******************************/
	    
	    @ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1]PIXEL
	    
	    @ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1]PIXEL
	    @ 085, 071 MSGET oGet16 VAR cGet16 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 131 MSGET oGet17 VAR cGet15 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 191 MSGET oGet18 VAR cGet18 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /***************************/
	    @ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 010 MSGET oGet19 VAR cGet19 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 270 MSGET oGet21 VAR cGet21 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /**************************/
	    @ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 010 MSGET oGet23 VAR cGet23 Picture "@!" Pixel F3 "SYA_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 247 MSGET oGet25 VAR cGet25 Picture "@!" Pixel F3 "SA3" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /***************************/
	    @ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 010 MSGET oGet27 VAR cGet27 When .T. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 230 MSGET oGet28 VAR cGet28 When .T. SIZE 260, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	endif

    
    if nTotReg > 0
	    @ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 150 SAY oSay32 PROMPT "% Fiancas" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	
    else
    	@ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 150 SAY oSay32 PROMPT "% Fiancas" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
  	
	endif
	
	/********************** FIM DETALHES ********************/
	/********************** GET GO ********************/
	//@ 020, 030 SAY oSay41 PROMPT "Favourable front end position involvement" 	SIZE 100, 007  COLORS 0, 16777215  OF oFolder2:aDialogs[2] PIXEL 
    //@ 020, 010 MSGET oGet41 VAR cGet41 When .T. SIZE 015, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[2] PIXEL
    
    @ 020,010 CHECKBOX oChkBox1 VAR lCheck1 PROMPT "Favourable front end position involvement (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 040,010 CHECKBOX oChkBox2 VAR lCheck2 PROMPT "Bench testing (2,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 060,010 CHECKBOX oChkBox3 VAR lCheck3 PROMPT "Pilot testing (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 080,010 CHECKBOX oChkBox4 VAR lCheck4 PROMPT "Process advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 100,010 CHECKBOX oChkBox5 VAR lCheck5 PROMPT "Specification advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 120,010 CHECKBOX oChkBox6 VAR lCheck6 PROMPT "Equipment Installed with similar application (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 140,010 CHECKBOX oChkBox7 VAR lCheck7 PROMPT "Equipment installed on same application (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 160,010 CHECKBOX oChkBox8 VAR lCheck8 PROMPT "Preferred  Vendor (2,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 180,010 CHECKBOX oChkBox9 VAR lCheck9 PROMPT "Economic advantage (10%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 200,010 CHECKBOX oChkBox10 VAR lCheck10 PROMPT "Value added advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 220,010 CHECKBOX oChkBox11 VAR lCheck11 PROMPT "Gatekeeper (2.5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 240,010 CHECKBOX oChkBox12 VAR lCheck12 PROMPT "Influencer good historical relationship (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 260,010 CHECKBOX oChkBox13 VAR lCheck13 PROMPT "Decision maker, good historical relationship (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 280,010 CHECKBOX oChkBox14 VAR lCheck14 PROMPT "Delivery mechanism exceeds competion (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 300,010 CHECKBOX oChkBox15 VAR lCheck15 PROMPT "Short listed and given opportunity for final presentation (17,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    
    @ 020,210 CHECKBOX oChkBox16 VAR lCheck16 PROMPT "Concept/Pre-feasability: Project Identified, preliminary budget (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 040,210 CHECKBOX oChkBox17 VAR lCheck17 PROMPT "Feasibility: budget quote prelim process design. (10%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 060,210 CHECKBOX oChkBox18 VAR lCheck18 PROMPT "Preliminary Design & process Selection. (20%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 080,210 CHECKBOX oChkBox19 VAR lCheck19 PROMPT "Economic evaluation: Pilot testing, Sampling and site evaluation approved, Funds approved for design phase (30%)" SIZE 300,15  OF oFolder2:aDialogs[2] PIXEL
    @ 100,210 CHECKBOX oChkBox20 VAR lCheck20 PROMPT "Scope finalized, design finalized, economics confirmed, final budget. (50%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 120,210 CHECKBOX oChkBox21 VAR lCheck21 PROMPT "Preliminary board, final changes to flow sheet approval final proposal and Compliance date. (80%)" SIZE 300,15  OF oFolder2:aDialogs[2] PIXEL
    @ 140,210 CHECKBOX oChkBox22 VAR lCheck22 PROMPT "Final quotation scope of supply.(85%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 160,210 CHECKBOX oChkBox23 VAR lCheck23 PROMPT "Letter of Intent. (90%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 180,210 CHECKBOX oChkBox24 VAR lCheck24 PROMPT "Final order placed (100%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
     
	/********************** FIM GET GO ********************/
	
    @ aPosObj[2,1]+5 ,005 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 070, 015  PIXEL
    @ aPosObj[2,1]+5 , 105 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 070, 015  PIXEL
  
  ACTIVATE MSDIALOG _oDlg CENTERED
  
 
  If _nOpc = 1
  	
  	Reclock("SZ9",.F.)
 
  		SZ9->Z9_BOOK	 	:= SUBSTR(oComboBx1,1,1)
  		SZ9->Z9_INDUSTR		:= cGet4 
  		SZ9->Z9_IDCONTR		:= cGet8
  		SZ9->Z9_CONTR		:= cGet9
  		SZ9->Z9_IDCLFIN		:= cGet10
  		SZ9->Z9_CLIFIN		:= cGet11
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
  		
  		SZ9->Z9_GETFAV		:= lCheck1
  		SZ9->Z9_GETBEN		:= lCheck2
  		SZ9->Z9_GETPIL		:= lCheck3
  		SZ9->Z9_GETPRO		:= lCheck4
  		SZ9->Z9_GETSEC		:= lCheck5
  		SZ9->Z9_GETEQU		:= lCheck6
  		SZ9->Z9_GETAPP		:= lCheck7
  		SZ9->Z9_GETPRE		:= lCheck8
  		SZ9->Z9_GETECO		:= lCheck9
  		SZ9->Z9_GETVAL		:= lCheck10
  		SZ9->Z9_GETGAT		:= lCheck11
  		SZ9->Z9_GETINF		:= lCheck12
  		SZ9->Z9_GETDEC		:= lCheck13
  		SZ9->Z9_GETDEL		:= lCheck14
  		SZ9->Z9_GETSHO		:= lCheck15
  		
  		if lCheck1 = .T.
  			nGETFAV := 5
  		else 
  			nGETFAV := 0
  		endif
  		if lCheck2 = .T.
  			nGETBEN := 2.5
  		else
  			nGETBEN := 0
  		endif
  		if lCheck3 = .T.
  			nGETPIL := 5
  		else
  			nGETPIL := 0
  		endif
  		if lCheck4 = .T.
  			nGETPRO := 7.5
  		else
  			nGETPRO := 0
  		endif
  		if lCheck5 = .T.
  		 	nGETSEC := 7.5
  		else
  		 	nGETSEC := 0
  		endif
  		if lCheck6 = .T.
  		 	nGETEQU := 5
  		else
  			nGETEQU := 0
  		endif
  		if lCheck7 = .T.
  			nGETAPP := 7.5
  		else
  			nGETAPP := 0
  		endif
  		if lCheck8 = .T.
  		 	nGETPRE := 2.5
  		else
  			nGETPRE := 0
  		endif
  		if lCheck9 = .T.
  			nGETECO := 10
  		else
  			nGETECO := 0
  		endif
  		if lCheck10 = .T.
  			nGETVAL := 7.5
  		else
  		 	nGETVAL := 0
  		endif
  		if lCheck11 = .T.
  			nGETGAT := 2.5
  		else
  		 	nGETGAT := 0
  		endif
  		if lCheck12 = .T.
  			nGETINF := 5
  		else
  			nGETINF := 0
  		endif
  		if lCheck13 = .T.
  			nGETDEC := 7.5
  		else
  		 	nGETDEC := 0
  		endif
  		if lCheck14 = .T.
  			nGETDEL := 7.5
  		else
  		 	nGETDEL := 0
  		endif
  		if lCheck15 = .T.
  			nGETSHO := 17.5
  		else
  		 	nGETSHO := 0
  		endif
  		
  		nTGET := nGETFAV + nGETBEN + nGETPIL + nGETPRO + nGETSEC + nGETEQU + nGETAPP + nGETPRE + nGETECO + nGETVAL + nGETGAT + nGETINF + nGETDEC + nGETDEL + nGETSHO
  		
  		SZ9->Z9_PGET		:= nTGET
  		
  		if lCheck16 = .T.
  			SZ9->Z9_GOCON		:= lCheck16
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		SZ9->Z9_GOCON		:= lCheck16
  			SZ9->Z9_GOFEA		:= lCheck16
  			SZ9->Z9_GOPRE		:= lCheck16
	  		SZ9->Z9_GOECO		:= lCheck16
	  		SZ9->Z9_GOSCO		:= lCheck16
	  		SZ9->Z9_GOPREL		:= lCheck16
	  		SZ9->Z9_GOQUOT		:= lCheck16
	  		SZ9->Z9_GOLETT		:= lCheck16
	  		SZ9->Z9_GOPLAC		:= lCheck16
  		endif
  		
  		if lCheck17 = .T.
  			SZ9->Z9_GOCON		:= lCheck17
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck17
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck17
	  		SZ9->Z9_GOECO		:= lCheck17
	  		SZ9->Z9_GOSCO		:= lCheck17
	  		SZ9->Z9_GOPREL		:= lCheck17
	  		SZ9->Z9_GOQUOT		:= lCheck17
	  		SZ9->Z9_GOLETT		:= lCheck17
	  		SZ9->Z9_GOPLAC		:= lCheck17
  		endif	
  		
  		if lCheck18 = .T.
  			SZ9->Z9_GOCON		:= lCheck18
  			SZ9->Z9_GOFEA		:= lCheck18
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck18
  			//SZ9->Z9_GOFEA		:= lCheck18
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck18
	  		SZ9->Z9_GOSCO		:= lCheck18
	  		SZ9->Z9_GOPREL		:= lCheck18
	  		SZ9->Z9_GOQUOT		:= lCheck18
	  		SZ9->Z9_GOLETT		:= lCheck18
	  		SZ9->Z9_GOPLAC		:= lCheck18
  		endif
  		
  		if lCheck19 = .T.
  			SZ9->Z9_GOCON		:= lCheck19
  			SZ9->Z9_GOFEA		:= lCheck19
  			SZ9->Z9_GOPRE		:= lCheck19
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck19
  			//SZ9->Z9_GOFEA		:= lCheck19
  			//SZ9->Z9_GOPRE		:= lCheck19
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck19
	  		SZ9->Z9_GOPREL		:= lCheck19
	  		SZ9->Z9_GOQUOT		:= lCheck19
	  		SZ9->Z9_GOLETT		:= lCheck19
	  		SZ9->Z9_GOPLAC		:= lCheck19
  		endif
  		
  		if lCheck20 = .T.
  			SZ9->Z9_GOCON		:= lCheck20
  			SZ9->Z9_GOFEA		:= lCheck20
  			SZ9->Z9_GOPRE		:= lCheck20
	  		SZ9->Z9_GOECO		:= lCheck20
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck20
  			//SZ9->Z9_GOFEA		:= lCheck20
  			//SZ9->Z9_GOPRE		:= lCheck20
	  		//SZ9->Z9_GOECO		:= lCheck20
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck20
	  		SZ9->Z9_GOQUOT		:= lCheck20
	  		SZ9->Z9_GOLETT		:= lCheck20
	  		SZ9->Z9_GOPLAC		:= lCheck20
  		endif
  		
  		if lCheck21 = .T.
  			SZ9->Z9_GOCON		:= lCheck21
  			SZ9->Z9_GOFEA		:= lCheck21
  			SZ9->Z9_GOPRE		:= lCheck21
	  		SZ9->Z9_GOECO		:= lCheck21
	  		SZ9->Z9_GOSCO		:= lCheck21
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck21
  			//SZ9->Z9_GOFEA		:= lCheck21
  			//SZ9->Z9_GOPRE		:= lCheck21
	  		//SZ9->Z9_GOECO		:= lCheck21
	  		//SZ9->Z9_GOSCO		:= lCheck21
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck21
	  		SZ9->Z9_GOLETT		:= lCheck21
	  		SZ9->Z9_GOPLAC		:= lCheck21
  		endif
  		
  		if lCheck22 = .T.
  			SZ9->Z9_GOCON		:= lCheck22
  			SZ9->Z9_GOFEA		:= lCheck22
  			SZ9->Z9_GOPRE		:= lCheck22
	  		SZ9->Z9_GOECO		:= lCheck22
	  		SZ9->Z9_GOSCO		:= lCheck22
	  		SZ9->Z9_GOPREL		:= lCheck22
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck22
	  		SZ9->Z9_GOPLAC		:= lCheck22
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck22
  			//SZ9->Z9_GOFEA		:= lCheck22
  			//SZ9->Z9_GOPRE		:= lCheck22
	  		//SZ9->Z9_GOECO		:= lCheck22
	  		//SZ9->Z9_GOSCO		:= lCheck22
	  		//SZ9->Z9_GOPREL	:= lCheck22
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck22
	  		SZ9->Z9_GOPLAC		:= lCheck22
  		endif
  		
  		if lCheck23 = .T.
  			SZ9->Z9_GOCON		:= lCheck23
  			SZ9->Z9_GOFEA		:= lCheck23
  			SZ9->Z9_GOPRE		:= lCheck23
	  		SZ9->Z9_GOECO		:= lCheck23
	  		SZ9->Z9_GOSCO		:= lCheck23
	  		SZ9->Z9_GOPREL		:= lCheck23
	  		SZ9->Z9_GOQUOT		:= lCheck23
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck22
  			//SZ9->Z9_GOFEA		:= lCheck22
  			//SZ9->Z9_GOPRE		:= lCheck22
	  		//SZ9->Z9_GOECO		:= lCheck22
	  		//SZ9->Z9_GOSCO		:= lCheck22
	  		//SZ9->Z9_GOPREL	:= lCheck22
	  		//SZ9->Z9_GOQUOT	:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck23
  		endif
  		
  		if lCheck24 = .T.
  			SZ9->Z9_GOCON		:= lCheck24
  			SZ9->Z9_GOFEA		:= lCheck24
  			SZ9->Z9_GOPRE		:= lCheck24
	  		SZ9->Z9_GOECO		:= lCheck24
	  		SZ9->Z9_GOSCO		:= lCheck24
	  		SZ9->Z9_GOPREL		:= lCheck24
	  		SZ9->Z9_GOQUOT		:= lCheck24
	  		SZ9->Z9_GOLETT		:= lCheck24
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck24
  			//SZ9->Z9_GOFEA		:= lCheck24
  			//SZ9->Z9_GOPRE		:= lCheck24
	  		//SZ9->Z9_GOECO		:= lCheck24
	  		//SZ9->Z9_GOSCO		:= lCheck24
	  		//SZ9->Z9_GOPREL	:= lCheck24
	  		//SZ9->Z9_GOQUOT	:= lCheck24
	  		//SZ9->Z9_GOLETT	:= lCheck24
	  		SZ9->Z9_GOPLAC		:= lCheck24
  		endif
  		
  		if lCheck16 = .F. //.AND.lCheck17 = .F. .AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 0
  			nTGO				:= 0
  			
  		endif
  		
  		if lCheck16 = .T. //.AND.lCheck17 = .F. .AND. lCheck18 = .F. .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 5
  			nTGO				:= 5
  			
  		endif
  		
  		if lCheck17 = .T. //.AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 10
  			nTGO				:= 10
  			
  		endif
  		
  		if lCheck18 = .T. //.AND. lCheck19 = .F. .AND.  ;
  		   // lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 20
  			nTGO				:= 20
  			
  		endif
  		
  		if  lCheck19 = .T. //.AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 30
  			nTGO				:= 30
  			
  		endif
  		
  		if lCheck20 = .T. //.AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 50
  			nTGO				:= 50
  			
  		endif
  		
  		if  lCheck21 = .T. //.AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 80
  			nTGO				:= 80
  			
  		endif
  		
  		if  lCheck22 = .T. //.AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 85
  			nTGO				:= 85
  			
  		endif
  		
  		if lCheck23 = .T. //.AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 90
  			nTGO				:= 90
  			
  		endif
  		
  		if  lCheck24 = .T. 
  			SZ9->Z9_PGO			:= 100
  			nTGO				:= 100
  			
  		endif

  	MsUnlock()

  
  
	Reclock("TRB4",.F.)
		
		if SUBSTR(oComboBx1,1,1) = "1"
			TRB4->BOOK4 	:= "GENERAL"
		elseIF SUBSTR(oComboBx1,1,1) = "2"
			TRB4->BOOK4 	:= "MARKETING PLATFORM"
		elseIF SUBSTR(oComboBx1,1,1) = "3"
			TRB4->BOOK4 	:= "BOOKING"
		else
			TRB4->BOOK4 	:= ""
		endif

		if MV_PAR03 = 1
			if SUBSTR(oComboBx3,1,1) = "1"
				TRB4->STATUS4 	:= "ACTIVE"
			elseIF SUBSTR(oComboBx3,1,1) = "2"
				TRB4->STATUS4 	:= "CANCELED"
			elseIF SUBSTR(oComboBx3,1,1) = "3"
				TRB4->STATUS4 	:= "DECLINED"
			elseIF SUBSTR(oComboBx3,1,1) = "4"
				TRB4->STATUS4 	:= "NOT SENT"
			elseIF SUBSTR(oComboBx3,1,1) = "5"
				TRB4->STATUS4 	:= "LOST"
			elseIF SUBSTR(oComboBx3,1,1) = "6"
				TRB4->STATUS4 	:= "SLC"
			elseIF SUBSTR(oComboBx3,1,1) = "7"
				TRB4->STATUS4 	:= "SOLD"
			else
				TRB4->STATUS4 	:= ""
			endif
		else
			if SUBSTR(oComboBx3,1,1) = "1"
				TRB4->STATUS4 	:= "ATIVA"
			elseIF SUBSTR(oComboBx3,1,1) = "2"
				TRB4->STATUS4 	:= "CANCELADA"
			elseIF SUBSTR(oComboBx3,1,1) = "3"
				TRB4->STATUS4 	:= "DECLINADA"
			elseIF SUBSTR(oComboBx3,1,1) = "4"
				TRB4->STATUS4 	:= "NAO ENVIADA"
			elseIF SUBSTR(oComboBx3,1,1) = "5"
				TRB4->STATUS4 	:= "PERDIDA"
			elseIF SUBSTR(oComboBx3,1,1) = "6"
				TRB4->STATUS4 	:= "SLC"
			elseIF SUBSTR(oComboBx3,1,1) = "7"
				TRB4->STATUS4 	:= "VENDIDA"
			else
				TRB4->STATUS4 	:= ""
			endif
		endif
		if MV_PAR03 = 1
			if empty(cGet4)
				TRB4->INDUSTR4 := ""
			else
				TRB4->INDUSTR4 := Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(cGet4),"ZZJ_PRODIN")
			endif
		else
			if empty(cGet4)
				TRB4->INDUSTR4 := ""
			else
				TRB4->INDUSTR4		:= cGet4
			endif
		endif
		TRB4->OPPNAME4		:= cGet9
		TRB4->CODEQ4			:= cGet12
		
		/************* Descricao Equipamento **************/
		cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(cGet1) + "'"
			
		IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

		ProcRegua(QUERY2->(reccount()))
			
		SZF->(dbgotop())
		
		while QUERY2->(!eof())
		
			if MV_PAR03 = 1
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
	
		TRB4->EQUIPDES4	:= alltrim(cEQUIPDES)
		/*************************************************/
		
		//TRB1->EQUIPDES		:= cGet13
		
		TRB4->DIMENS4		:= cGet14
		TRB4->FORECL4		:= cGet18
		TRB4->SALPER4		:= cGet22
		TRB4->SALREP4		:= cGet26
		TRB4->COUNTRY4		:= cGet24	
		
		/*************************************/
		cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(cGet1) + "'"
			
		IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

		ProcRegua(QUERY2->(reccount()))
			
		SZF->(dbgotop())
		
		while QUERY2->(!eof())

			nXTOTSI 		+= QUERY2->ZF_TOTVSI
			QUERY2->(dbskip())

		enddo	
		TRB4->FOREAMM4	:= nXTOTSI
		QUERY2->(dbgotop())
				
		while QUERY2->(!eof())

			nXCUSTOT 		+= QUERY2->ZF_TOTVSI-(QUERY2->ZF_TOTVSI*(QUERY2->ZF_MKPFIN/100))

			QUERY2->(dbskip())

		enddo	
		
		/*******************************/
		
		TRB4->FOREAMM4		:= nXTOTSI
		
		nVCOMIS 			:= nXTOTSI * (cGet36/100)
		nCOGS				:= nXCUSTOT - nVCOMIS	
		nVCONTMG			:= nXTOTSI - nCOGS - nVCOMIS
				
		TRB4->COMMISS4		:= cGet36
		TRB4->VCOMMISS4		:= (nXTOTSI * (cGet36/100))
		TRB4->COGS4			:= nCOGS
		TRB4->CONTRMG4		:= (nVCONTMG / nXTOTSI)*100 
		TRB4->VCONTRMG4		:= nVCONTMG
		
		TRB4->PGET4			:= nTGET
		TRB4->PGO4			:= nTGO
		TRB4->SALAMOU4		:= nXTOTSI * ((nTGET/100) * (nTGO /100))
  		TRB4->SALCONT4		:= (nVCONTMG)  * (nTGET /100) * (nTGO /100)
	MsUnlock()
	
	
  	Reclock("SZ9",.F.)
   		
  		if lCheck16 = .F. //.AND.lCheck17 = .F. .AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck16 = .T. //.AND.lCheck17 = .F. .AND. lCheck18 = .F. .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck17 = .T. //.AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck18 = .T. //.AND. lCheck19 = .F. .AND.  ;
  		   // lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck19 = .T. //.AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck20 = .T. //.AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck21 = .T. //.AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck22 = .T. //.AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck23 = .T. //.AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck24 = .T. 
   			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif

  	MsUnlock()
  Endif
  
	
  
	SZF->(DbGoTop())
    TSZF->(DbCloseArea()) 
    QUERY2->(DbCloseArea())
Return _nOpc

/**********************************/
Static Function EditTRB5()
    Local aArea       := GetArea()
    Local aAreaSZ9    := SZ9->(GetArea())
    Local nOpcao      := 0
    Local cItemZ95	  := alltrim(TRB5->NPROP5)

    Private cCadastro 
 
   	cCadastro := "Alteracao Proposta"
    
	DbSelectArea("SZ9")
	SZ9->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	SZ9->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	If SZ9->(DbSeek(xFilial('SZ9')+cItemZ95))
	        nOpcao := fAltTRB5()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	elseif alltrim(cItemZ95) == "TOTAL" .OR. alltrim(cItemZ95) == "TOTAL GERAL"
	 	msginfo("Registro nao pode editado.")
	Else
		EditTRB7b()
	EndIf
	
	nOpcao := ""
    RestArea(aAreaSZ9)
    RestArea(aArea)
Return
/**********************************/
Static Function EditTRB7b()
    Local aArea       := GetArea()
    Local aAreaZZI    := ZZI->(GetArea())
    Local nOpcao1      := 0
    Local cItemZZI	  := alltrim(TRB5->ID5)
   
    Private cCadastro 
 
   	cCadastro := "Alteracao Proposta"
    
	DbSelectArea("ZZI")
	ZZI->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	ZZI->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If ZZI->(DbSeek(xFilial('ZZI')+cItemZZI))
	    	
	        nOpcao1 := fAltTRB7()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	       
	EndIf
	
    RestArea(aAreaZZI)
    RestArea(aArea)
Return
/**********************************/

static Function fAltTRB5()
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

Local _nOpc := 0
local cFor2 		:= ""
Local nVCOMIS		:= 0
Local nCOGS			:= 0
Local nVCONTMG		:= 0
Local nXTOTSI		:= 0
Local nXCUSTOT		:= 0
Local cEQUIPDES		:= ""

Local oChkBox1 
Local lCheck1 	:= SZ9->Z9_GETFAV
Local oChkBox2 
Local lCheck2 	:= SZ9->Z9_GETBEN
Local oChkBox3 
Local lCheck3 	:= SZ9->Z9_GETPIL
Local oChkBox4 
Local lCheck4 	:= SZ9->Z9_GETPRO
Local oChkBox5 
Local lCheck5 	:= SZ9->Z9_GETSEC
Local oChkBox6 
Local lCheck6 	:= SZ9->Z9_GETEQU
Local oChkBox7 
Local lCheck7 	:= SZ9->Z9_GETAPP
Local oChkBox8 
Local lCheck8 	:= SZ9->Z9_GETPRE
Local oChkBox9 
Local lCheck9 	:= SZ9->Z9_GETECO
Local oChkBox10 
Local lCheck10 	:= SZ9->Z9_GETVAL
Local oChkBox11 
Local lCheck11 	:= SZ9->Z9_GETGAT
Local oChkBox12 
Local lCheck12 	:= SZ9->Z9_GETINF
Local oChkBox13 
Local lCheck13 	:= SZ9->Z9_GETDEC
Local oChkBox14 
Local lCheck14 	:= SZ9->Z9_GETDEL
Local oChkBox15 
Local lCheck15 	:= SZ9->Z9_GETSHO

Local oChkBox16 
Local lCheck16 	:= SZ9->Z9_GOCON
Local oChkBox17 
Local lCheck17 	:= SZ9->Z9_GOFEA
Local oChkBox18 
Local lCheck18 	:= SZ9->Z9_GOPRE
Local oChkBox19 
Local lCheck19 	:= SZ9->Z9_GOECO
Local oChkBox20 
Local lCheck20 	:= SZ9->Z9_GOSCO
Local oChkBox21 
Local lCheck21 	:= SZ9->Z9_GOPREL
Local oChkBox22 
Local lCheck22 	:= SZ9->Z9_GOQUOT
Local oChkBox23 
Local lCheck23 	:= SZ9->Z9_GOLETT
Local oChkBox24 
Local lCheck24 	:= SZ9->Z9_GOPLAC

local nGETFAV, nGETBEN, nGETPIL, nGETPRO, nGETSEC, nGETEQU, nGETAPP, nGETPRE, nGETECO, nGETVAL, nGETGAT, nGETINF, nGETDEC, nGETDEL, nGETSHO
Local nTGET	:= 0
Local nTGO	:= 0

local cFiltra 	:= ""

//Static _oDlg

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

Private _oGetDbAnalit
Private _oDlg

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
elseif cGet27 = "4"
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

  @ 002,002 FOLDER oFolder2 SIZE  aSize[6]+300,aSize[5]+100 OF _oDlg ;
  	ITEMS "Detalhes", "Get & Go" COLORS 0, 16777215 PIXEL

  _oGetDbAnalit := MsGetDb():New(aPosObj[1,1]+220,aPosObj[1,2],aPosObj[1,3]-30,aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB13",,,,oFolder2:aDialogs[1])
  
  if cGet29 = "7"
  		msginfo("Registro nao pode ser editado.")
  else
  		_oGetDbAnalit:oBrowse:BlDblClick := {|| EditSZF() }
  endif
  
  oGroup1:= TGroup():New(0005,0005,0035,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup2:= TGroup():New(0040,0005,0070,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup3:= TGroup():New(0075,0005,0105,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup4:= TGroup():New(0110,0005,0140,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup5:= TGroup():New(0145,0005,0175,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup6:= TGroup():New(0180,0005,0210,0605,'',oFolder2:aDialogs[1],,,.T.)
  oGroup7:= TGroup():New(0215,0005,0245,0505,'',oFolder2:aDialogs[1],,,.T.)
  
  oGroup10:= TGroup():New(0005,0005,0315,0195,'GET',oFolder2:aDialogs[2],,,.T.)
  oGroup11:= TGroup():New(0005,0200,0315,0505,'GO',oFolder2:aDialogs[2],,,.T.)
        
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "Numro Proposta" 	SIZE 020, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 063 SAY oSay2 PROMPT "Classificacao" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 061 MSGET oGet2 VAR cClass   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 145 SAY oSay3 PROMPT "Mercado" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 142 MSGET oGet3 VAR cMerc   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 225 SAY oSay4 PROMPT "Prod.Final"  SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 222 MSGET oGet4 VAR cGet4  Picture "@!" Pixel F3 "ZZJ" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 295 SAY oSay5 PROMPT "Tipo" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 292 MSGET oGet5 VAR cTipo   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    if cGet29 = "7"
	    @ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /*********************************/
	    @ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 010 MSGET oGet8 VAR cGet8 When .F.  SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	    @ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    @ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 285 MSGET oGet10 VAR cGet10 When .F.  SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 230, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	 	/********************************/    
	    @ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 071 MSGET oGet16 VAR cGet16 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 131 MSGET oGet17 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 191 MSGET oGet18 VAR cGet18 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /*********************************/
	    @ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 010 MSGET oGet19 VAR cGet19  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 270 MSGET oGet21 VAR cGet21  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /*******************************/
	    @ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 010 MSGET oGet23 VAR cGet23  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 247 MSGET oGet25 VAR cGet25  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /********************************/
	    @ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 010 MSGET oGet27 VAR cGet27 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 230 MSGET oGet28 VAR cGet28 When .F. SIZE 260, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	else
		@ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
        
	    @ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    /********************************/
	    @ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 010 MSGET oGet8 VAR cGet8 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	    @ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	    @ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 051, 285 MSGET oGet10 VAR cGet10 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /******************************/
	    
	    @ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1]PIXEL
	    
	    @ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1]PIXEL
	    @ 085, 071 MSGET oGet16 VAR cGet16 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 131 MSGET oGet17 VAR cGet15 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 085, 191 MSGET oGet18 VAR cGet18 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /***************************/
	    @ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 010 MSGET oGet19 VAR cGet19 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 121, 270 MSGET oGet21 VAR cGet21 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    /**************************/
	    @ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 010 MSGET oGet23 VAR cGet23 Picture "@!" Pixel F3 "SYA_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		@ 157, 247 MSGET oGet25 VAR cGet25 Picture "@!" Pixel F3 "SA3" SIZE 048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
		@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    /***************************/
	    @ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 010 MSGET oGet27 VAR cGet27 When .T. SIZE 210, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	    @ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    @ 193, 230 MSGET oGet28 VAR cGet28 When .T. SIZE 260, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	endif

    
    if nTotReg > 0
	    @ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 150 SAY oSay32 PROMPT "% Fiancas" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	
    else
    	@ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 150 SAY oSay32 PROMPT "% Fiancas" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	   	@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
  	
	endif
	
	/********************** FIM DETALHES ********************/
	/********************** GET GO ********************/
	//@ 020, 030 SAY oSay41 PROMPT "Favourable front end position involvement" 	SIZE 100, 007  COLORS 0, 16777215  OF oFolder2:aDialogs[2] PIXEL 
    //@ 020, 010 MSGET oGet41 VAR cGet41 When .T. SIZE 015, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[2] PIXEL
    
    @ 020,010 CHECKBOX oChkBox1 VAR lCheck1 PROMPT "Favourable front end position involvement (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 040,010 CHECKBOX oChkBox2 VAR lCheck2 PROMPT "Bench testing (2,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 060,010 CHECKBOX oChkBox3 VAR lCheck3 PROMPT "Pilot testing (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 080,010 CHECKBOX oChkBox4 VAR lCheck4 PROMPT "Process advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 100,010 CHECKBOX oChkBox5 VAR lCheck5 PROMPT "Specification advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 120,010 CHECKBOX oChkBox6 VAR lCheck6 PROMPT "Equipment Installed with similar application (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 140,010 CHECKBOX oChkBox7 VAR lCheck7 PROMPT "Equipment installed on same application (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 160,010 CHECKBOX oChkBox8 VAR lCheck8 PROMPT "Preferred  Vendor (2,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 180,010 CHECKBOX oChkBox9 VAR lCheck9 PROMPT "Economic advantage (10%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 200,010 CHECKBOX oChkBox10 VAR lCheck10 PROMPT "Value added advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 220,010 CHECKBOX oChkBox11 VAR lCheck11 PROMPT "Gatekeeper (2.5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 240,010 CHECKBOX oChkBox12 VAR lCheck12 PROMPT "Influencer good historical relationship (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 260,010 CHECKBOX oChkBox13 VAR lCheck13 PROMPT "Decision maker, good historical relationship (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 280,010 CHECKBOX oChkBox14 VAR lCheck14 PROMPT "Delivery mechanism exceeds competion (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 300,010 CHECKBOX oChkBox15 VAR lCheck15 PROMPT "Short listed and given opportunity for final presentation (17,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    
    @ 020,210 CHECKBOX oChkBox16 VAR lCheck16 PROMPT "Concept/Pre-feasability: Project Identified, preliminary budget (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 040,210 CHECKBOX oChkBox17 VAR lCheck17 PROMPT "Feasibility: budget quote prelim process design. (10%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 060,210 CHECKBOX oChkBox18 VAR lCheck18 PROMPT "Preliminary Design & process Selection. (20%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 080,210 CHECKBOX oChkBox19 VAR lCheck19 PROMPT "Economic evaluation: Pilot testing, Sampling and site evaluation approved, Funds approved for design phase (30%)" SIZE 300,15  OF oFolder2:aDialogs[2] PIXEL
    @ 100,210 CHECKBOX oChkBox20 VAR lCheck20 PROMPT "Scope finalized, design finalized, economics confirmed, final budget. (50%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 120,210 CHECKBOX oChkBox21 VAR lCheck21 PROMPT "Preliminary board, final changes to flow sheet approval final proposal and Compliance date. (80%)" SIZE 300,15  OF oFolder2:aDialogs[2] PIXEL
    @ 140,210 CHECKBOX oChkBox22 VAR lCheck22 PROMPT "Final quotation scope of supply.(85%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 160,210 CHECKBOX oChkBox23 VAR lCheck23 PROMPT "Letter of Intent. (90%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 180,210 CHECKBOX oChkBox24 VAR lCheck24 PROMPT "Final order placed (100%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
     
	/********************** FIM GET GO ********************/
	
    @ aPosObj[2,1]+5 ,005 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 070, 015  PIXEL
    @ aPosObj[2,1]+5 , 105 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 070, 015  PIXEL
  
  ACTIVATE MSDIALOG _oDlg CENTERED
  
 
  If _nOpc = 1
  	
  	Reclock("SZ9",.F.)
 
  		SZ9->Z9_BOOK	 	:= SUBSTR(oComboBx1,1,1)
  		SZ9->Z9_INDUSTR		:= cGet4 
  		SZ9->Z9_IDCONTR		:= cGet8
  		SZ9->Z9_CONTR		:= cGet9
  		SZ9->Z9_IDCLFIN		:= cGet10
  		SZ9->Z9_CLIFIN		:= cGet11
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
  		
  		SZ9->Z9_GETFAV		:= lCheck1
  		SZ9->Z9_GETBEN		:= lCheck2
  		SZ9->Z9_GETPIL		:= lCheck3
  		SZ9->Z9_GETPRO		:= lCheck4
  		SZ9->Z9_GETSEC		:= lCheck5
  		SZ9->Z9_GETEQU		:= lCheck6
  		SZ9->Z9_GETAPP		:= lCheck7
  		SZ9->Z9_GETPRE		:= lCheck8
  		SZ9->Z9_GETECO		:= lCheck9
  		SZ9->Z9_GETVAL		:= lCheck10
  		SZ9->Z9_GETGAT		:= lCheck11
  		SZ9->Z9_GETINF		:= lCheck12
  		SZ9->Z9_GETDEC		:= lCheck13
  		SZ9->Z9_GETDEL		:= lCheck14
  		SZ9->Z9_GETSHO		:= lCheck15
  		
  		if lCheck1 = .T.
  			nGETFAV := 5
  		else 
  			nGETFAV := 0
  		endif
  		if lCheck2 = .T.
  			nGETBEN := 2.5
  		else
  			nGETBEN := 0
  		endif
  		if lCheck3 = .T.
  			nGETPIL := 5
  		else
  			nGETPIL := 0
  		endif
  		if lCheck4 = .T.
  			nGETPRO := 7.5
  		else
  			nGETPRO := 0
  		endif
  		if lCheck5 = .T.
  		 	nGETSEC := 7.5
  		else
  		 	nGETSEC := 0
  		endif
  		if lCheck6 = .T.
  		 	nGETEQU := 5
  		else
  			nGETEQU := 0
  		endif
  		if lCheck7 = .T.
  			nGETAPP := 7.5
  		else
  			nGETAPP := 0
  		endif
  		if lCheck8 = .T.
  		 	nGETPRE := 2.5
  		else
  			nGETPRE := 0
  		endif
  		if lCheck9 = .T.
  			nGETECO := 10
  		else
  			nGETECO := 0
  		endif
  		if lCheck10 = .T.
  			nGETVAL := 7.5
  		else
  		 	nGETVAL := 0
  		endif
  		if lCheck11 = .T.
  			nGETGAT := 2.5
  		else
  		 	nGETGAT := 0
  		endif
  		if lCheck12 = .T.
  			nGETINF := 5
  		else
  			nGETINF := 0
  		endif
  		if lCheck13 = .T.
  			nGETDEC := 7.5
  		else
  		 	nGETDEC := 0
  		endif
  		if lCheck14 = .T.
  			nGETDEL := 7.5
  		else
  		 	nGETDEL := 0
  		endif
  		if lCheck15 = .T.
  			nGETSHO := 17.5
  		else
  		 	nGETSHO := 0
  		endif
  		
  		nTGET := nGETFAV + nGETBEN + nGETPIL + nGETPRO + nGETSEC + nGETEQU + nGETAPP + nGETPRE + nGETECO + nGETVAL + nGETGAT + nGETINF + nGETDEC + nGETDEL + nGETSHO
  		
  		SZ9->Z9_PGET		:= nTGET
  		
  		if lCheck16 = .T.
  			SZ9->Z9_GOCON		:= lCheck16
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		SZ9->Z9_GOCON		:= lCheck16
  			SZ9->Z9_GOFEA		:= lCheck16
  			SZ9->Z9_GOPRE		:= lCheck16
	  		SZ9->Z9_GOECO		:= lCheck16
	  		SZ9->Z9_GOSCO		:= lCheck16
	  		SZ9->Z9_GOPREL		:= lCheck16
	  		SZ9->Z9_GOQUOT		:= lCheck16
	  		SZ9->Z9_GOLETT		:= lCheck16
	  		SZ9->Z9_GOPLAC		:= lCheck16
  		endif
  		
  		if lCheck17 = .T.
  			SZ9->Z9_GOCON		:= lCheck17
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck17
  			SZ9->Z9_GOFEA		:= lCheck17
  			SZ9->Z9_GOPRE		:= lCheck17
	  		SZ9->Z9_GOECO		:= lCheck17
	  		SZ9->Z9_GOSCO		:= lCheck17
	  		SZ9->Z9_GOPREL		:= lCheck17
	  		SZ9->Z9_GOQUOT		:= lCheck17
	  		SZ9->Z9_GOLETT		:= lCheck17
	  		SZ9->Z9_GOPLAC		:= lCheck17
  		endif	
  		
  		if lCheck18 = .T.
  			SZ9->Z9_GOCON		:= lCheck18
  			SZ9->Z9_GOFEA		:= lCheck18
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck18
  			//SZ9->Z9_GOFEA		:= lCheck18
  			SZ9->Z9_GOPRE		:= lCheck18
	  		SZ9->Z9_GOECO		:= lCheck18
	  		SZ9->Z9_GOSCO		:= lCheck18
	  		SZ9->Z9_GOPREL		:= lCheck18
	  		SZ9->Z9_GOQUOT		:= lCheck18
	  		SZ9->Z9_GOLETT		:= lCheck18
	  		SZ9->Z9_GOPLAC		:= lCheck18
  		endif
  		
  		if lCheck19 = .T.
  			SZ9->Z9_GOCON		:= lCheck19
  			SZ9->Z9_GOFEA		:= lCheck19
  			SZ9->Z9_GOPRE		:= lCheck19
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck19
  			//SZ9->Z9_GOFEA		:= lCheck19
  			//SZ9->Z9_GOPRE		:= lCheck19
	  		SZ9->Z9_GOECO		:= lCheck19
	  		SZ9->Z9_GOSCO		:= lCheck19
	  		SZ9->Z9_GOPREL		:= lCheck19
	  		SZ9->Z9_GOQUOT		:= lCheck19
	  		SZ9->Z9_GOLETT		:= lCheck19
	  		SZ9->Z9_GOPLAC		:= lCheck19
  		endif
  		
  		if lCheck20 = .T.
  			SZ9->Z9_GOCON		:= lCheck20
  			SZ9->Z9_GOFEA		:= lCheck20
  			SZ9->Z9_GOPRE		:= lCheck20
	  		SZ9->Z9_GOECO		:= lCheck20
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck20
  			//SZ9->Z9_GOFEA		:= lCheck20
  			//SZ9->Z9_GOPRE		:= lCheck20
	  		//SZ9->Z9_GOECO		:= lCheck20
	  		SZ9->Z9_GOSCO		:= lCheck20
	  		SZ9->Z9_GOPREL		:= lCheck20
	  		SZ9->Z9_GOQUOT		:= lCheck20
	  		SZ9->Z9_GOLETT		:= lCheck20
	  		SZ9->Z9_GOPLAC		:= lCheck20
  		endif
  		
  		if lCheck21 = .T.
  			SZ9->Z9_GOCON		:= lCheck21
  			SZ9->Z9_GOFEA		:= lCheck21
  			SZ9->Z9_GOPRE		:= lCheck21
	  		SZ9->Z9_GOECO		:= lCheck21
	  		SZ9->Z9_GOSCO		:= lCheck21
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck21
  			//SZ9->Z9_GOFEA		:= lCheck21
  			//SZ9->Z9_GOPRE		:= lCheck21
	  		//SZ9->Z9_GOECO		:= lCheck21
	  		//SZ9->Z9_GOSCO		:= lCheck21
	  		SZ9->Z9_GOPREL		:= lCheck21
	  		SZ9->Z9_GOQUOT		:= lCheck21
	  		SZ9->Z9_GOLETT		:= lCheck21
	  		SZ9->Z9_GOPLAC		:= lCheck21
  		endif
  		
  		if lCheck22 = .T.
  			SZ9->Z9_GOCON		:= lCheck22
  			SZ9->Z9_GOFEA		:= lCheck22
  			SZ9->Z9_GOPRE		:= lCheck22
	  		SZ9->Z9_GOECO		:= lCheck22
	  		SZ9->Z9_GOSCO		:= lCheck22
	  		SZ9->Z9_GOPREL		:= lCheck22
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck22
	  		SZ9->Z9_GOPLAC		:= lCheck22
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck22
  			//SZ9->Z9_GOFEA		:= lCheck22
  			//SZ9->Z9_GOPRE		:= lCheck22
	  		//SZ9->Z9_GOECO		:= lCheck22
	  		//SZ9->Z9_GOSCO		:= lCheck22
	  		//SZ9->Z9_GOPREL	:= lCheck22
	  		SZ9->Z9_GOQUOT		:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck22
	  		SZ9->Z9_GOPLAC		:= lCheck22
  		endif
  		
  		if lCheck23 = .T.
  			SZ9->Z9_GOCON		:= lCheck23
  			SZ9->Z9_GOFEA		:= lCheck23
  			SZ9->Z9_GOPRE		:= lCheck23
	  		SZ9->Z9_GOECO		:= lCheck23
	  		SZ9->Z9_GOSCO		:= lCheck23
	  		SZ9->Z9_GOPREL		:= lCheck23
	  		SZ9->Z9_GOQUOT		:= lCheck23
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck22
  			//SZ9->Z9_GOFEA		:= lCheck22
  			//SZ9->Z9_GOPRE		:= lCheck22
	  		//SZ9->Z9_GOECO		:= lCheck22
	  		//SZ9->Z9_GOSCO		:= lCheck22
	  		//SZ9->Z9_GOPREL	:= lCheck22
	  		//SZ9->Z9_GOQUOT	:= lCheck22
	  		SZ9->Z9_GOLETT		:= lCheck23
	  		SZ9->Z9_GOPLAC		:= lCheck23
  		endif
  		
  		if lCheck24 = .T.
  			SZ9->Z9_GOCON		:= lCheck24
  			SZ9->Z9_GOFEA		:= lCheck24
  			SZ9->Z9_GOPRE		:= lCheck24
	  		SZ9->Z9_GOECO		:= lCheck24
	  		SZ9->Z9_GOSCO		:= lCheck24
	  		SZ9->Z9_GOPREL		:= lCheck24
	  		SZ9->Z9_GOQUOT		:= lCheck24
	  		SZ9->Z9_GOLETT		:= lCheck24
	  		SZ9->Z9_GOPLAC		:= lCheck24
	  	else
	  		//SZ9->Z9_GOCON		:= lCheck24
  			//SZ9->Z9_GOFEA		:= lCheck24
  			//SZ9->Z9_GOPRE		:= lCheck24
	  		//SZ9->Z9_GOECO		:= lCheck24
	  		//SZ9->Z9_GOSCO		:= lCheck24
	  		//SZ9->Z9_GOPREL	:= lCheck24
	  		//SZ9->Z9_GOQUOT	:= lCheck24
	  		//SZ9->Z9_GOLETT	:= lCheck24
	  		SZ9->Z9_GOPLAC		:= lCheck24
  		endif
  		
  		if lCheck16 = .F. //.AND.lCheck17 = .F. .AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 0
  			nTGO				:= 0
  			
  		endif
  		
  		if lCheck16 = .T. //.AND.lCheck17 = .F. .AND. lCheck18 = .F. .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 5
  			nTGO				:= 5
  			
  		endif
  		
  		if lCheck17 = .T. //.AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 10
  			nTGO				:= 10
  			
  		endif
  		
  		if lCheck18 = .T. //.AND. lCheck19 = .F. .AND.  ;
  		   // lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 20
  			nTGO				:= 20
  			
  		endif
  		
  		if  lCheck19 = .T. //.AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 30
  			nTGO				:= 30
  			
  		endif
  		
  		if lCheck20 = .T. //.AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 50
  			nTGO				:= 50
  			
  		endif
  		
  		if  lCheck21 = .T. //.AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 80
  			nTGO				:= 80
  			
  		endif
  		
  		if  lCheck22 = .T. //.AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 85
  			nTGO				:= 85
  			
  		endif
  		
  		if lCheck23 = .T. //.AND. lCheck24 = .F. 
  			SZ9->Z9_PGO			:= 90
  			nTGO				:= 90
  			
  		endif
  		
  		if  lCheck24 = .T. 
  			SZ9->Z9_PGO			:= 100
  			nTGO				:= 100
  			
  		endif

  	MsUnlock()

  
  
	Reclock("TRB5",.F.)
		
		if SUBSTR(oComboBx1,1,1) = "1"
			TRB5->BOOK5 	:= "GENERAL"
		elseIF SUBSTR(oComboBx1,1,1) = "2"
			TRB5->BOOK5 	:= "MARKETING PLATFORM"
		elseIF SUBSTR(oComboBx1,1,1) = "3"
			TRB5->BOOK5 	:= "BOOKING"
		else
			TRB5->BOOK5 	:= ""
		endif

		if MV_PAR03 = 1
			if SUBSTR(oComboBx3,1,1) = "1"
				TRB5->STATUS5 	:= "ACTIVE"
			elseIF SUBSTR(oComboBx3,1,1) = "2"
				TRB5->STATUS5 	:= "CANCELED"
			elseIF SUBSTR(oComboBx3,1,1) = "3"
				TRB5->STATUS5 	:= "DECLINED"
			elseIF SUBSTR(oComboBx3,1,1) = "4"
				TRB5->STATUS5 	:= "NOT SENT"
			elseIF SUBSTR(oComboBx3,1,1) = "5"
				TRB5->STATUS5 	:= "LOST"
			elseIF SUBSTR(oComboBx3,1,1) = "6"
				TRB5->STATUS5 	:= "SLC"
			elseIF SUBSTR(oComboBx3,1,1) = "7"
				TRB5->STATUS5 	:= "SOLD"
			else
				TRB5->STATUS5 	:= ""
			endif
		else
			if SUBSTR(oComboBx3,1,1) = "1"
				TRB5->STATUS5 	:= "ATIVA"
			elseIF SUBSTR(oComboBx3,1,1) = "2"
				TRB5->STATUS5 	:= "CANCELADA"
			elseIF SUBSTR(oComboBx3,1,1) = "3"
				TRB5->STATUS5 	:= "DECLINADA"
			elseIF SUBSTR(oComboBx3,1,1) = "4"
				TRB5->STATUS5 	:= "NAO ENVIADA"
			elseIF SUBSTR(oComboBx3,1,1) = "5"
				TRB5->STATUS5 	:= "PERDIDA"
			elseIF SUBSTR(oComboBx3,1,1) = "6"
				TRB5->STATUS5 	:= "SLC"
			elseIF SUBSTR(oComboBx3,1,1) = "7"
				TRB5->STATUS5 	:= "VENDIDA"
			else
				TRB5->STATUS5 	:= ""
			endif
		endif
		if MV_PAR03 = 1
			if empty(cGet4)
				TRB5->INDUSTR5 := ""
			else
				TRB5->INDUSTR5 := Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(cGet4),"ZZJ_PRODIN")
			endif
		else
			if empty(cGet4)
				TRB5->INDUSTR5 := ""
			else
				TRB5->INDUSTR5		:= cGet4
			endif
		endif
		TRB5->OPPNAME5		:= cGet9
		TRB5->CODEQ5			:= cGet12
		
		/************* Descricao Equipamento **************/
		cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(cGet1) + "'"
			
		IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

		ProcRegua(QUERY2->(reccount()))
			
		SZF->(dbgotop())
		
		while QUERY2->(!eof())
		
			if MV_PAR03 = 1
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
	
		TRB5->EQUIPDES5	:= alltrim(cEQUIPDES)
		/*************************************************/
		
		//TRB1->EQUIPDES		:= cGet13
		
		TRB5->DIMENS5		:= cGet14
		TRB5->FORECL5		:= cGet18
		TRB5->SALPER5		:= cGet22
		TRB5->SALREP5		:= cGet26
		TRB5->COUNTRY5		:= cGet24	
		
		/*************************************/
		cFor2 			:= "ALLTRIM(QUERY2->ZF_NPROP) =  '" + ALLTRIM(cGet1) + "'"
			
		IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZF_NPROP,ZF_IDVEND",,cFor2,"Selecionando Registros...")

		ProcRegua(QUERY2->(reccount()))
			
		SZF->(dbgotop())
		
		while QUERY2->(!eof())

			nXTOTSI 		+= QUERY2->ZF_TOTVSI
			QUERY2->(dbskip())

		enddo	
		TRB2->FOREAMM2	:= nXTOTSI
		QUERY2->(dbgotop())
				
		while QUERY2->(!eof())

			nXCUSTOT 		+= QUERY2->ZF_TOTVSI-(QUERY2->ZF_TOTVSI*(QUERY2->ZF_MKPFIN/100))

			QUERY2->(dbskip())

		enddo	
		
		/*******************************/
		
		TRB5->FOREAMM5		:= nXTOTSI
		
		nVCOMIS 			:= nXTOTSI * (cGet36/100)
		nCOGS				:= nXCUSTOT - nVCOMIS	
		nVCONTMG			:= nXTOTSI - nCOGS - nVCOMIS
				
		TRB5->COMMISS5		:= cGet36
		TRB5->VCOMMISS5		:= (nXTOTSI * (cGet36/100))
		TRB5->COGS5			:= nCOGS
		TRB5->CONTRMG5		:= (nVCONTMG / nXTOTSI)*100 
		TRB5->VCONTRMG5		:= nVCONTMG
		
		TRB5->PGET5			:= nTGET
		TRB5->PGO5			:= nTGO
		TRB5->SALAMOU5		:= nXTOTSI * ((nTGET/100) * (nTGO /100))
  		TRB5->SALCONT5		:= (nVCONTMG)  * (nTGET /100) * (nTGO /100)
	MsUnlock()
	
	
  	Reclock("SZ9",.F.)
   		
  		if lCheck16 = .F. //.AND.lCheck17 = .F. .AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck16 = .T. //.AND.lCheck17 = .F. .AND. lCheck18 = .F. .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck17 = .T. //.AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck18 = .T. //.AND. lCheck19 = .F. .AND.  ;
  		   // lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck19 = .T. //.AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck20 = .T. //.AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck21 = .T. //.AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck22 = .T. //.AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if lCheck23 = .T. //.AND. lCheck24 = .F. 
  			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif
  		
  		if  lCheck24 = .T. 
   			SZ9->Z9_SALAMOU		:= nXTOTSI  * (nTGET /100) * (nTGO /100)
  			SZ9->Z9_SALCONT		:= nVCONTMG  * (nTGET /100) * (nTGO /100)
  		endif

  	MsUnlock()
  Endif
  
	
  
	SZF->(DbGoTop())
    TSZF->(DbCloseArea()) 
    QUERY2->(DbCloseArea())
Return _nOpc
/***********************************************/


Static Function EditTRB7()
    Local aArea       := GetArea()
    Local aAreaZZI    := ZZI->(GetArea())
    Local nOpcao1      := 0
    Local cItemZZI	  := alltrim(TRB7->ID7)
    Local cItemZZI2	  := alltrim(TRB7->NPROP7)
   
    Private cCadastro 
 
   	cCadastro := "Alteracao Proposta"
    
	DbSelectArea("ZZI")
	ZZI->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	ZZI->(DbGoTop())
	
	
	if cItemZZI2  == "TOTAL GERAL"
	  	msginfo("Registro nao pode editado.")
	else
	 	//Se conseguir posicionar no produto
	 	If ZZI->(DbSeek(xFilial('ZZI')+cItemZZI))
	    	
	        nOpcao1 := fAltTRB7()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	    endif
	EndIf
	
    RestArea(aAreaZZI)
    RestArea(aArea)
Return

/******************************************************/

static Function fAltTRB7()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= alltrim(ZZI->ZZI_ID)
//Local oGet2
//Local cGet2 	:= SZ9->Z9_CLASS
Local oGet3
Local cGet3		:= ZZI->ZZI_MERC
Local oGet4	
Local cGet4		:= ZZI->ZZI_PRODUT


Local oComboBx3      
Local cComboBx3	:= {"","1 - Firme","2 - Estimativa"}
Local oGet5	
Local cGet5		:= alltrim(ZZI->ZZI_TIPO)

Local oComboBx1      
Local cComboBx1	:= {"","1 - Pecas / Servicos","3 - Booking"}
Local oGet6	
Local cGet6		:= Alltrim(ZZI->ZZI_BOOK)

Local oComboBx2      
Local cComboBx2	:= {"","1 - Viabilidade","2 - Execucao"}
Local oGet7	
Local cGet7		:= ZZI->ZZI_VIAEXE

Local oGet8	
Local cGet8		:= ZZI->ZZI_OPNAM
Local oGet9	
Local cGet9		:= ZZI->ZZI_OPING
Local oGet10	
Local cGet10	:= ZZI->ZZI_IDRESP
Local oGet11	
Local cGet11	:= POSICIONE("SZL",1,XFILIAL("SZL")+ZZI->ZZI_IDRESP,"ZL_NOME")  
Local oGet12
Local cGet12	:= ZZI->ZZI_DESC
Local oGet13	
Local cGet13	:= ZZI->ZZI_DESCIN
Local oGet14	
Local cGet14	:= ZZI->ZZI_CPAIS
Local oGet15	
Local cGet15	:= POSICIONE("SYA",1,XFILIAL("SYA")+ZZI->ZZI_CPAIS,"YA_DESCR")     
Local oGet16
Local cGet16		:= ZZI->ZZI_PREVVD
Local oGet17
Local cGet17		:= ZZI->ZZI_VDSI
Local oGet18
Local cGet18		:= ZZI->ZZI_PMGCON
Local oGet19
Local cGet19		:= ZZI->ZZI_MGCON
Local oGet20
Local cGet20		:= ZZI->ZZI_COGS
Local oGet21
Local cGet21		:= ZZI->ZZI_PCOMIS
Local oGet22
Local cGet22		:= ZZI->ZZI_COMIS

Local oChkBox1 
Local lCheck1 	:= ZZI->ZZI_GETFAV
Local oChkBox2 
Local lCheck2 	:= ZZI->ZZI_GETBEN
Local oChkBox3 
Local lCheck3 	:= ZZI->ZZI_GETPIL
Local oChkBox4 
Local lCheck4 	:= ZZI->ZZI_GETPRO
Local oChkBox5 
Local lCheck5 	:= ZZI->ZZI_GETSEC
Local oChkBox6 
Local lCheck6 	:= ZZI->ZZI_GETEQU
Local oChkBox7 
Local lCheck7 	:= ZZI->ZZI_GETAPP
Local oChkBox8 
Local lCheck8 	:= ZZI->ZZI_GETPRE
Local oChkBox9 
Local lCheck9 	:= ZZI->ZZI_GETECO
Local oChkBox10 
Local lCheck10 	:= ZZI->ZZI_GETVAL
Local oChkBox11 
Local lCheck11 	:= ZZI->ZZI_GETGAT
Local oChkBox12 
Local lCheck12 	:= ZZI->ZZI_GETINF
Local oChkBox13 
Local lCheck13 	:= ZZI->ZZI_GETDEC
Local oChkBox14 
Local lCheck14 	:= ZZI->ZZI_GETDEL
Local oChkBox15 
Local lCheck15 	:= ZZI->ZZI_GETSHO

Local oChkBox16 
Local lCheck16 	:= ZZI->ZZI_GOCON
Local oChkBox17 
Local lCheck17 	:= ZZI->ZZI_GOFEA
Local oChkBox18 
Local lCheck18 	:= SZ9->Z9_GOPRE
Local oChkBox19 
Local lCheck19 	:= ZZI->ZZI_GOECO
Local oChkBox20 
Local lCheck20 	:= ZZI->ZZI_GOSCO
Local oChkBox21 
Local lCheck21 	:= ZZI->ZZI_GOPREL
Local oChkBox22 
Local lCheck22 	:= ZZI->ZZI_GOQUOT
Local oChkBox23 
Local lCheck23 	:= ZZI->ZZI_GOLETT
Local oChkBox24 
Local lCheck24 	:= ZZI->ZZI_GOPLAC

local nGETFAV, nGETBEN, nGETPIL, nGETPRO, nGETSEC, nGETEQU, nGETAPP, nGETPRE, nGETECO, nGETVAL, nGETGAT, nGETINF, nGETDEC, nGETDEL, nGETSHO
Local nTGET	:= 0
Local nTGO	:= 0

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
Local nTotReg := 0

Local _nOpc := 0
Static _oDlg


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
else
	cTipo := ""
endif

if cGet6 = "1"
	oComboBx1 := cGet6 + " - " + "Pecas / Servicos"
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


   DEFINE MSDIALOG _oDlg TITLE "Previsao de Vendas" FROM 000, 000  TO 0500, 1025 of oMainWnd PIXEL
  
  @ 002,002 FOLDER oFolder2 SIZE  600,900 OF _oDlg ;
  	ITEMS "Detalhes", "Get & Go" COLORS 0, 16777215 PIXEL
  
   oGroup1:= TGroup():New(0005,0005,0035,0505,'',oFolder2:aDialogs[1],,,.T.)
   oGroup2:= TGroup():New(0040,0005,0070,0505,'',oFolder2:aDialogs[1],,,.T.)
   oGroup3:= TGroup():New(0075,0005,0105,0505,'',oFolder2:aDialogs[1],,,.T.)
   oGroup4:= TGroup():New(0110,0005,0140,0505,'',oFolder2:aDialogs[1],,,.T.)
   oGroup5:= TGroup():New(0145,0005,0175,0505,'',oFolder2:aDialogs[1],,,.T.)
   
   oGroup10:= TGroup():New(0005,0005,0180,0195,'GET',oFolder2:aDialogs[2],,,.T.)
   oGroup11:= TGroup():New(0005,0200,0180,0505,'GO',oFolder2:aDialogs[2],,,.T.)
   
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "ID" 	SIZE 020, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 063 SAY oSay3 PROMPT "Mercado" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 061 MSGET oGet3 VAR cMerc   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 145 SAY oSay4 PROMPT "Prod.Final"  SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 142 MSGET oGet4 VAR cGet4  Picture "@!" Pixel F3 "ZZJ" SIZE 068, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 222 SAY oSay5 PROMPT "Tipo" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    @ 016, 220 MSGET oGet5 VAR cTipo   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
    @ 007, 300 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 016, 300 ComboBox oComboBx1 Items cComboBx1   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
    @ 007, 380 SAY oSay7 PROMPT "Viabilidade/Execucao" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 016, 380 ComboBox oComboBx2 Items cComboBx2   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	@ 007, 450 SAY oSay16 PROMPT "Prev.Venda" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 016, 450 MSGET oGet16 VAR cGet16 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	@ 042, 010 SAY oSay8 PROMPT "Oportunidade" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 051, 010 MSGET oGet8 VAR cGet8 When .T. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
    
	@ 042, 248 SAY oSay9 PROMPT "Oportunidade (Ingles)" SIZE 080, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 051, 245 MSGET oGet9 VAR cGet9 When .T. SIZE 240, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	@ 076, 010 SAY oSay10 PROMPT "Id Resp." SIZE 032, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 085, 010 MSGET oGet10 VAR cGet10 Picture "@!" Pixel F3 "zColab"  SIZE  048, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
		
	@ 076, 073 SAY oSay11 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 085, 070 MSGET oGet11 VAR cGet11 When .F. SIZE 180, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	@ 076, 260 SAY oSay14 PROMPT "Cod.Pais" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 085, 260 MSGET oGet14 VAR cGet14  Picture "@!" Pixel F3 "SYA_2" SIZE 048, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	@ 076, 320 SAY oSay15 PROMPT "Pais" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 085, 320 MSGET oGet15 VAR cGet15 When .F. SIZE 180, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	    
	@ 112, 010 SAY oSay12 PROMPT "Descricao" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 121, 010 MSGET oGet12 VAR cGet12 When .T. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
	@ 112, 240 SAY oSay13 PROMPT "Descricao (Ingles)" SIZE 052, 007 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 121, 240 MSGET oGet13 VAR cGet13 When .T. SIZE 220, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	    
    @ 148, 010 SAY oSay17 PROMPT "Venda s/ Trib." SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
   	@ 157, 010 MSGET oGet17 VAR cGet17 PICTURE PesqPict("ZZI","ZZI_VDSI") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	@ 148, 080 SAY oSay18 PROMPT "% Margem Contribuicao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 157, 080 MSGET oGet18 VAR cGet18 PICTURE PesqPict("ZZI","ZZI_PMGCON") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	@ 148, 150 SAY oSay19 PROMPT "Margem Contribuicao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 157, 150 MSGET oGet19 VAR cGet19 PICTURE PesqPict("ZZI","ZZI_MGCON") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	@ 148, 220 SAY oSay20 PROMPT "COGS" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 157, 220 MSGET oGet20 VAR cGet20 PICTURE PesqPict("ZZI","ZZI_COGS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	@ 148, 290 SAY oSay21 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 157, 290 MSGET oGet21 VAR cGet21 PICTURE PesqPict("ZZI","ZZI_PCOMIS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	   	
	@ 148, 360 SAY oSay22 PROMPT "Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	@ 157, 360 MSGET oGet22 VAR cGet22 PICTURE PesqPict("ZZI","ZZI_COMIS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder2:aDialogs[1] PIXEL
	
	
	/********************** GET GO ********************/
	//@ 020, 030 SAY oSay41 PROMPT "Favourable front end position involvement" 	SIZE 100, 007  COLORS 0, 16777215  OF oFolder2:aDialogs[2] PIXEL 
    //@ 020, 010 MSGET oGet41 VAR cGet41 When .T. SIZE 015, 010  COLORS 0, 16777215 OF oFolder2:aDialogs[2] PIXEL
    
    @ 020,010 CHECKBOX oChkBox1 VAR lCheck1 PROMPT "Favourable front end position involvement (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 030,010 CHECKBOX oChkBox2 VAR lCheck2 PROMPT "Bench testing (2,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 040,010 CHECKBOX oChkBox3 VAR lCheck3 PROMPT "Pilot testing (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 050,010 CHECKBOX oChkBox4 VAR lCheck4 PROMPT "Process advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 060,010 CHECKBOX oChkBox5 VAR lCheck5 PROMPT "Specification advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 070,010 CHECKBOX oChkBox6 VAR lCheck6 PROMPT "Equipment Installed with similar application (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 080,010 CHECKBOX oChkBox7 VAR lCheck7 PROMPT "Equipment installed on same application (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 090,010 CHECKBOX oChkBox8 VAR lCheck8 PROMPT "Preferred  Vendor (2,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 100,010 CHECKBOX oChkBox9 VAR lCheck9 PROMPT "Economic advantage (10%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 110,010 CHECKBOX oChkBox10 VAR lCheck10 PROMPT "Value added advantage (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 120,010 CHECKBOX oChkBox11 VAR lCheck11 PROMPT "Gatekeeper (2.5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 130,010 CHECKBOX oChkBox12 VAR lCheck12 PROMPT "Influencer good historical relationship (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 140,010 CHECKBOX oChkBox13 VAR lCheck13 PROMPT "Decision maker, good historical relationship (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 150,010 CHECKBOX oChkBox14 VAR lCheck14 PROMPT "Delivery mechanism exceeds competion (7,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 160,010 CHECKBOX oChkBox15 VAR lCheck15 PROMPT "Short listed and given opportunity for final presentation (17,5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    
    @ 020,210 CHECKBOX oChkBox16 VAR lCheck16 PROMPT "Concept/Pre-feasability: Project Identified, preliminary budget (5%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 030,210 CHECKBOX oChkBox17 VAR lCheck17 PROMPT "Feasibility: budget quote prelim process design. (10%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 040,210 CHECKBOX oChkBox18 VAR lCheck18 PROMPT "Preliminary Design & process Selection. (20%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 050,210 CHECKBOX oChkBox19 VAR lCheck19 PROMPT "Economic evaluation: Pilot testing, Sampling and site evaluation approved, Funds approved for design phase (30%)" SIZE 300,15  OF oFolder2:aDialogs[2] PIXEL
    @ 060,210 CHECKBOX oChkBox20 VAR lCheck20 PROMPT "Scope finalized, design finalized, economics confirmed, final budget. (50%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 070,210 CHECKBOX oChkBox21 VAR lCheck21 PROMPT "Preliminary board, final changes to flow sheet approval final proposal and Compliance date. (80%)" SIZE 300,15  OF oFolder2:aDialogs[2] PIXEL
    @ 080,210 CHECKBOX oChkBox22 VAR lCheck22 PROMPT "Final quotation scope of supply.(85%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 090,210 CHECKBOX oChkBox23 VAR lCheck23 PROMPT "Letter of Intent. (90%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    @ 100,210 CHECKBOX oChkBox24 VAR lCheck24 PROMPT "Final order placed (100%)" SIZE 200,15  OF oFolder2:aDialogs[2] PIXEL
    
	/********************** FIM GET GO ********************/
	   	
    @ 220, 160 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 070, 010  PIXEL
    @ 220, 240 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 070, 010  PIXEL
    
  ACTIVATE MSDIALOG _oDlg CENTERED
  
  If _nOpc = 1
  	Reclock("ZZI",.F.)
 
  		ZZI->ZZI_BOOK	 	:= SUBSTR(oComboBx1,1,1)
  		ZZI->ZZI_VIAEXE		:= SUBSTR(oComboBx2,1,1)
  		//ZZI->ZZI_TIPO		:= SUBSTR(cTipo,1,1)
  		ZZI->ZZI_PRODUT		:= cGet4 
  		ZZI->ZZI_OPNAM		:= cGet8
  		ZZI->ZZI_OPING		:= cGet9  
  		ZZI->ZZI_IDRESP		:= cGet10
  		ZZI->ZZI_RESP		:= cGet11
  		ZZI->ZZI_DESC		:= cGet12
  		ZZI->ZZI_DESCIN		:= cGet13
  		ZZI->ZZI_CPAIS		:= cGet14
  		ZZI->ZZI_PAIS		:= cGet15
  		ZZI->ZZI_PREVVD		:= cGet16
  		ZZI->ZZI_VDSI		:= cGet17
  		ZZI->ZZI_PMGCON		:= cGet18
  		ZZI->ZZI_MGCON		:= cGet17 * (cGet18/100) //cGet19
  		ZZI->ZZI_COGS		:= cGet17 - (cGet17 * (cGet18/100)) - (cGet17*(cGet21/100)) //cGet20
  		ZZI->ZZI_PCOMIS		:= cGet21
  		ZZI->ZZI_COMIS		:= (cGet17 * (cGet21/100)) //cGet22
  	
  		
  		ZZI->ZZI_GETFAV		:= lCheck1
  		ZZI->ZZI_GETBEN		:= lCheck2
  		ZZI->ZZI_GETPIL		:= lCheck3
  		ZZI->ZZI_GETPRO		:= lCheck4
  		ZZI->ZZI_GETSEC		:= lCheck5
  		ZZI->ZZI_GETEQU		:= lCheck6
  		ZZI->ZZI_GETAPP		:= lCheck7
  		ZZI->ZZI_GETPRE		:= lCheck8
  		ZZI->ZZI_GETECO		:= lCheck9
  		ZZI->ZZI_GETVAL		:= lCheck10
  		ZZI->ZZI_GETGAT		:= lCheck11
  		ZZI->ZZI_GETINF		:= lCheck12
  		ZZI->ZZI_GETDEC		:= lCheck13
  		ZZI->ZZI_GETDEL		:= lCheck14
  		ZZI->ZZI_GETSHO		:= lCheck15
  		
  		if lCheck1 = .T.
  			nGETFAV := 5
  		else 
  			nGETFAV := 0
  		endif
  		if lCheck2 = .T.
  			nGETBEN := 2.5
  		else
  			nGETBEN := 0
  		endif
  		if lCheck3 = .T.
  			nGETPIL := 5
  		else
  			nGETPIL := 0
  		endif
  		if lCheck4 = .T.
  			nGETPRO := 7.5
  		else
  			nGETPRO := 0
  		endif
  		if lCheck5 = .T.
  		 	nGETSEC := 7.5
  		else
  		 	nGETSEC := 0
  		endif
  		if lCheck6 = .T.
  		 	nGETEQU := 5
  		else
  			nGETEQU := 0
  		endif
  		if lCheck7 = .T.
  			nGETAPP := 7.5
  		else
  			nGETAPP := 0
  		endif
  		if lCheck8 = .T.
  		 	nGETPRE := 2.5
  		else
  			nGETPRE := 0
  		endif
  		if lCheck9 = .T.
  			nGETECO := 10
  		else
  			nGETECO := 0
  		endif
  		if lCheck10 = .T.
  			nGETVAL := 7.5
  		else
  		 	nGETVAL := 0
  		endif
  		if lCheck11 = .T.
  			nGETGAT := 2.5
  		else
  		 	nGETGAT := 0
  		endif
  		if lCheck12 = .T.
  			nGETINF := 5
  		else
  			nGETINF := 0
  		endif
  		if lCheck13 = .T.
  			nGETDEC := 7.5
  		else
  		 	nGETDEC := 0
  		endif
  		if lCheck14 = .T.
  			nGETDEL := 7.5
  		else
  		 	nGETDEL := 0
  		endif
  		if lCheck15 = .T.
  			nGETSHO := 17.5
  		else
  		 	nGETSHO := 0
  		endif
  		
  		nTGET := nGETFAV + nGETBEN + nGETPIL + nGETPRO + nGETSEC + nGETEQU + nGETAPP + nGETPRE + nGETECO + nGETVAL + nGETGAT + nGETINF + nGETDEC + nGETDEL + nGETSHO
  		
  		ZZI->ZZI_PGET		:= nTGET
  		
  		if lCheck16 = .T.
  			ZZI->ZZI_GOCON		:= lCheck16
  			ZZI->ZZI_GOFEA		:= lCheck17
  			ZZI->ZZI_GOPRE		:= lCheck18
	  		ZZI->ZZI_GOECO		:= lCheck19
	  		ZZI->ZZI_GOSCO		:= lCheck20
	  		ZZI->ZZI_GOPREL		:= lCheck21
	  		ZZI->ZZI_GOQUOT		:= lCheck22
	  		ZZI->ZZI_GOLETT		:= lCheck23
	  		ZZI->ZZI_GOPLAC		:= lCheck24
	  	else
	  		ZZI->ZZI_GOCON		:= lCheck16
  			ZZI->ZZI_GOFEA		:= lCheck16
  			ZZI->ZZI_GOPRE		:= lCheck16
	  		ZZI->ZZI_GOECO		:= lCheck16
	  		ZZI->ZZI_GOSCO		:= lCheck16
	  		ZZI->ZZI_GOPREL		:= lCheck16
	  		ZZI->ZZI_GOQUOT		:= lCheck16
	  		ZZI->ZZI_GOLETT		:= lCheck16
	  		ZZI->ZZI_GOPLAC		:= lCheck16
  		endif
  		
  		if lCheck17 = .T.
  			ZZI->ZZI_GOCON		:= lCheck17
  			ZZI->ZZI_GOFEA		:= lCheck17
  			ZZI->ZZI_GOPRE		:= lCheck18
	  		ZZI->ZZI_GOECO		:= lCheck19
	  		ZZI->ZZI_GOSCO		:= lCheck20
	  		ZZI->ZZI_GOPREL		:= lCheck21
	  		ZZI->ZZI_GOQUOT		:= lCheck22
	  		ZZI->ZZI_GOLETT		:= lCheck23
	  		ZZI->ZZI_GOPLAC		:= lCheck24
	  	else
	  		//ZZI->ZZI_GOCON		:= lCheck17
  			ZZI->ZZI_GOFEA		:= lCheck17
  			ZZI->ZZI_GOPRE		:= lCheck17
	  		ZZI->ZZI_GOECO		:= lCheck17
	  		ZZI->ZZI_GOSCO		:= lCheck17
	  		ZZI->ZZI_GOPREL		:= lCheck17
	  		ZZI->ZZI_GOQUOT		:= lCheck17
	  		ZZI->ZZI_GOLETT		:= lCheck17
	  		ZZI->ZZI_GOPLAC		:= lCheck17
  		endif	
  		
  		if lCheck18 = .T.
  			ZZI->ZZI_GOCON		:= lCheck18
  			ZZI->ZZI_GOFEA		:= lCheck18
  			ZZI->ZZI_GOPRE		:= lCheck18
	  		ZZI->ZZI_GOECO		:= lCheck19
	  		ZZI->ZZI_GOSCO		:= lCheck20
	  		ZZI->ZZI_GOPREL		:= lCheck21
	  		ZZI->ZZI_GOQUOT		:= lCheck22
	  		ZZI->ZZI_GOLETT		:= lCheck23
	  		ZZI->ZZI_GOPLAC		:= lCheck24
	  	else
	  		//ZZI->ZZI_GOCON		:= lCheck18
  			//ZZI->ZZI_GOFEA		:= lCheck18
  			ZZI->ZZI_GOPRE		:= lCheck18
	  		ZZI->ZZI_GOECO		:= lCheck18
	  		ZZI->ZZI_GOSCO		:= lCheck18
	  		ZZI->ZZI_GOPREL		:= lCheck18
	  		ZZI->ZZI_GOQUOT		:= lCheck18
	  		ZZI->ZZI_GOLETT		:= lCheck18
	  		ZZI->ZZI_GOPLAC		:= lCheck18
  		endif
  		
  		if lCheck19 = .T.
  			ZZI->ZZI_GOCON		:= lCheck19
  			ZZI->ZZI_GOFEA		:= lCheck19
  			ZZI->ZZI_GOPRE		:= lCheck19
	  		ZZI->ZZI_GOECO		:= lCheck19
	  		ZZI->ZZI_GOSCO		:= lCheck20
	  		ZZI->ZZI_GOPREL		:= lCheck21
	  		ZZI->ZZI_GOQUOT		:= lCheck22
	  		ZZI->ZZI_GOLETT		:= lCheck23
	  		ZZI->ZZI_GOPLAC		:= lCheck24
	  	else
	  		//ZZI->ZZI_GOCON		:= lCheck19
  			//ZZI->ZZI_GOFEA		:= lCheck19
  			//ZZI->ZZI_GOPRE		:= lCheck19
	  		ZZI->ZZI_GOECO		:= lCheck19
	  		ZZI->ZZI_GOSCO		:= lCheck19
	  		ZZI->ZZI_GOPREL		:= lCheck19
	  		ZZI->ZZI_GOQUOT		:= lCheck19
	  		ZZI->ZZI_GOLETT		:= lCheck19
	  		ZZI->ZZI_GOPLAC		:= lCheck19
  		endif
  		
  		if lCheck20 = .T.
  			ZZI->ZZI_GOCON		:= lCheck20
  			ZZI->ZZI_GOFEA		:= lCheck20
  			ZZI->ZZI_GOPRE		:= lCheck20
	  		ZZI->ZZI_GOECO		:= lCheck20
	  		ZZI->ZZI_GOSCO		:= lCheck20
	  		ZZI->ZZI_GOPREL		:= lCheck21
	  		ZZI->ZZI_GOQUOT		:= lCheck22
	  		ZZI->ZZI_GOLETT		:= lCheck23
	  		ZZI->ZZI_GOPLAC		:= lCheck24
	  	else
	  		//ZZI->ZZI_GOCON		:= lCheck20
  			//ZZI->ZZI_GOFEA		:= lCheck20
  			//ZZI->ZZI_GOPRE		:= lCheck20
	  		//ZZI->ZZI_GOECO		:= lCheck20
	  		ZZI->ZZI_GOSCO		:= lCheck20
	  		ZZI->ZZI_GOPREL		:= lCheck20
	  		ZZI->ZZI_GOQUOT		:= lCheck20
	  		ZZI->ZZI_GOLETT		:= lCheck20
	  		ZZI->ZZI_GOPLAC		:= lCheck20
  		endif
  		
  		if lCheck21 = .T.
  			ZZI->ZZI_GOCON		:= lCheck21
  			ZZI->ZZI_GOFEA		:= lCheck21
  			ZZI->ZZI_GOPRE		:= lCheck21
	  		ZZI->ZZI_GOECO		:= lCheck21
	  		ZZI->ZZI_GOSCO		:= lCheck21
	  		ZZI->ZZI_GOPREL		:= lCheck21
	  		ZZI->ZZI_GOQUOT		:= lCheck22
	  		ZZI->ZZI_GOLETT		:= lCheck23
	  		ZZI->ZZI_GOPLAC		:= lCheck24
	  	else
	  		//ZZI->ZZI_GOCON		:= lCheck21
  			//ZZI->ZZI_GOFEA		:= lCheck21
  			//ZZI->ZZI_GOPRE		:= lCheck21
	  		//ZZI->ZZI_GOECO		:= lCheck21
	  		//ZZI->ZZI_GOSCO		:= lCheck21
	  		ZZI->ZZI_GOPREL		:= lCheck21
	  		ZZI->ZZI_GOQUOT		:= lCheck21
	  		ZZI->ZZI_GOLETT		:= lCheck21
	  		ZZI->ZZI_GOPLAC		:= lCheck21
  		endif
  		
  		if lCheck22 = .T.
  			ZZI->ZZI_GOCON		:= lCheck22
  			ZZI->ZZI_GOFEA		:= lCheck22
  			ZZI->ZZI_GOPRE		:= lCheck22
	  		ZZI->ZZI_GOECO		:= lCheck22
	  		ZZI->ZZI_GOSCO		:= lCheck22
	  		ZZI->ZZI_GOPREL		:= lCheck22
	  		ZZI->ZZI_GOQUOT		:= lCheck22
	  		ZZI->ZZI_GOLETT		:= lCheck22
	  		ZZI->ZZI_GOPLAC		:= lCheck22
	  	else
	  		//ZZI->ZZI_GOCON		:= lCheck22
  			//ZZI->ZZI_GOFEA		:= lCheck22
  			//ZZI->ZZI_GOPRE		:= lCheck22
	  		//ZZI->ZZI_GOECO		:= lCheck22
	  		//ZZI->ZZI_GOSCO		:= lCheck22
	  		//ZZI->ZZI_GOPREL	:= lCheck22
	  		ZZI->ZZI_GOQUOT		:= lCheck22
	  		ZZI->ZZI_GOLETT		:= lCheck22
	  		ZZI->ZZI_GOPLAC		:= lCheck22
  		endif
  		
  		if lCheck23 = .T.
  			ZZI->ZZI_GOCON		:= lCheck23
  			ZZI->ZZI_GOFEA		:= lCheck23
  			ZZI->ZZI_GOPRE		:= lCheck23
	  		ZZI->ZZI_GOECO		:= lCheck23
	  		ZZI->ZZI_GOSCO		:= lCheck23
	  		ZZI->ZZI_GOPREL		:= lCheck23
	  		ZZI->ZZI_GOQUOT		:= lCheck23
	  		ZZI->ZZI_GOLETT		:= lCheck23
	  		ZZI->ZZI_GOPLAC		:= lCheck24
	  	else
	  		//ZZI->ZZI_GOCON		:= lCheck22
  			//ZZI->ZZI_GOFEA		:= lCheck22
  			//ZZI->ZZI_GOPRE		:= lCheck22
	  		//ZZI->ZZI_GOECO		:= lCheck22
	  		//ZZI->ZZI_GOSCO		:= lCheck22
	  		//ZZI->ZZI_GOPREL	:= lCheck22
	  		//ZZI->ZZI_GOQUOT	:= lCheck22
	  		ZZI->ZZI_GOLETT		:= lCheck23
	  		ZZI->ZZI_GOPLAC		:= lCheck23
  		endif
  		
  		if lCheck24 = .T.
  			ZZI->ZZI_GOCON		:= lCheck24
  			ZZI->ZZI_GOFEA		:= lCheck24
  			ZZI->ZZI_GOPRE		:= lCheck24
	  		ZZI->ZZI_GOECO		:= lCheck24
	  		ZZI->ZZI_GOSCO		:= lCheck24
	  		ZZI->ZZI_GOPREL		:= lCheck24
	  		ZZI->ZZI_GOQUOT		:= lCheck24
	  		ZZI->ZZI_GOLETT		:= lCheck24
	  		ZZI->ZZI_GOPLAC		:= lCheck24
	  	else
	  		//ZZI->ZZI_GOCON		:= lCheck24
  			//ZZI->ZZI_GOFEA		:= lCheck24
  			//ZZI->ZZI_GOPRE		:= lCheck24
	  		//ZZI->ZZI_GOECO		:= lCheck24
	  		//ZZI->ZZI_GOSCO		:= lCheck24
	  		//ZZI->ZZI_GOPREL	:= lCheck24
	  		//ZZI->ZZI_GOQUOT	:= lCheck24
	  		//ZZI->ZZI_GOLETT	:= lCheck24
	  		ZZI->ZZI_GOPLAC		:= lCheck24
  		endif
  		
  		if lCheck16 = .F. //.AND.lCheck17 = .F. .AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			ZZI->ZZI_PGO		:= 0
  			nTGO				:= 0
  			ZZI->ZZI_MTVD		:= cGet17 *  ((nTGET/100) * (nTGO /100))
  			ZZI->ZZI_MTCONT		:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))
  		endif
  		
  		if lCheck16 = .T. //.AND.lCheck17 = .F. .AND. lCheck18 = .F. .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			ZZI->ZZI_PGO			:= 5
  			nTGO				:= 5
  			ZZI->ZZI_MTVD		:= cGet17 *  ((nTGET/100) * (nTGO /100))
  			ZZI->ZZI_MTCONT		:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))
  		endif
  		
  		if lCheck17 = .T. //.AND. lCheck18 = .F.  .AND. lCheck19 = .F. .AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			ZZI->ZZI_PGO			:= 10
  			nTGO				:= 10
  			ZZI->ZZI_MTVD		:= cGet17 *  ((nTGET/100) * (nTGO /100))
  			ZZI->ZZI_MTCONT		:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))
  		endif
  		
  		if lCheck18 = .T. //.AND. lCheck19 = .F. .AND.  ;
  		   // lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			ZZI->ZZI_PGO			:= 20
  			nTGO				:= 20
  			ZZI->ZZI_MTVD		:= cGet17 *  ((nTGET/100) * (nTGO /100))
  			ZZI->ZZI_MTCONT		:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))
  		endif
  		
  		if  lCheck19 = .T. //.AND.  ;
  		    //lCheck20 = .F. .AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			ZZI->ZZI_PGO			:= 30
  			nTGO				:= 30
  			ZZI->ZZI_MTVD		:= cGet17 *  ((nTGET/100) * (nTGO /100))
  			ZZI->ZZI_MTCONT		:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))
  		endif
  		
  		if lCheck20 = .T. //.AND. lCheck21 = .F. .AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			ZZI->ZZI_PGO			:= 50
  			nTGO				:= 50
  			ZZI->ZZI_MTVD		:= cGet17 *  ((nTGET/100) * (nTGO /100))
  			ZZI->ZZI_MTCONT		:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))
  		endif
  		
  		if  lCheck21 = .T. //.AND. lCheck22 = .F. .AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			ZZI->ZZI_PGO			:= 80
  			nTGO				:= 80
  			ZZI->ZZI_MTVD		:= cGet17 *  ((nTGET/100) * (nTGO /100))
  			ZZI->ZZI_MTCONT		:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))
  		endif
  		
  		if  lCheck22 = .T. //.AND. lCheck23 = .F. .AND. lCheck24 = .F. 
  			ZZI->ZZI_PGO			:= 85
  			nTGO				:= 85
  			ZZI->ZZI_MTVD		:= cGet17 *  ((nTGET/100) * (nTGO /100))
  			ZZI->ZZI_MTCONT		:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))
  		endif
  		
  		if lCheck23 = .T. //.AND. lCheck24 = .F. 
  			ZZI->ZZI_PGO			:= 90
  			nTGO				:= 90
  			ZZI->ZZI_MTVD		:= cGet17 *  ((nTGET/100) * (nTGO /100))
  			ZZI->ZZI_MTCONT		:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))
  		endif
  		
  		if  lCheck24 = .T. 
  			ZZI->ZZI_PGO			:= 100
  			nTGO				:= 100
  			ZZI->ZZI_MTVD		:= cGet17 *  ((nTGET/100) * (nTGO /100))
  			ZZI->ZZI_MTCONT		:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))
  		endif
  	
  		
  	MsUnlock()
  Endif
  
	Reclock("TRB7",.F.)
		
		if SUBSTR(oComboBx1,1,1) = "1"
			TRB7->BOOK7 	:= "PECAS / SERVICOS"
		elseIF SUBSTR(oComboBx1,1,1) = "3"
			TRB7->BOOK7 	:= "BOOKING"
		else
			TRB7->BOOK7 	:= ""
		endif
		
		if MV_PAR03 = 1
			if SUBSTR(oComboBx2,1,1) = "1"
				TRB7->FEAEXEC7 	:= "FEASIBILITY"
			elseIF SUBSTR(oComboBx2,1,1) = "2"
				TRB7->FEAEXEC7 	:= "EXECUTION"
			else
				TRB7->FEAEXEC7 	:= ""
			endif
		else
			if SUBSTR(oComboBx2,1,1) = "1"
				TRB7->FEAEXEC7 	:= "VIABILIDADE"
			elseIF SUBSTR(oComboBx2,1,1) = "2"
				TRB7->FEAEXEC7 	:= "EXECUCAO"
			else
				TRB7->FEAEXEC7 	:= ""
			endif
		endif
		
		
		if MV_PAR03 = 1
			if empty(cGet4)
				TRB7->INDUSTR7 := ""
			else
				TRB7->INDUSTR7 := Posicione("ZZJ",2,xFilial("ZZJ") + alltrim(cGet4),"ZZJ_PRODIN")
			endif
		else
			if empty(cGet4)
				TRB7->INDUSTR7 := ""
			else
				TRB7->INDUSTR7		:= cGet4
			endif
		endif
		
		if MV_PAR03 = 1
			TRB7->OPPNAME7		:= cGet9
		else
			TRB7->OPPNAME7		:= cGet8
		endif
		
		TRB7->SALPER7			:= cGet11
	
		if MV_PAR03 = 1 
			TRB7->EQUIPDES7		:= cGet13
		else
			TRB7->EQUIPDES7		:= cGet12
		endif
		
		TRB7->COUNTRY7			:= cGet15
		TRB7->FORECL7			:= cGet16
		TRB7->FOREAMM7			:= cGet17
		TRB7->CONTRMG7			:= cGet18
		TRB7->VCONTRMG7			:= cGet17 * (cGet18/100)
		TRB7->COGS7				:= cGet17 - (cGet17 * (cGet18/100)) - (cGet17*(cGet21/100))
		TRB7->COMMISS7			:= cGet21
		TRB7->VCOMMISS7			:= (cGet17 * (cGet21/100))
		TRB7->PGET7				:= nTGET
		TRB7->PGO7				:= nTGO
		TRB7->SALAMOU7			:= cGet17 *  ((nTGET/100) * (nTGO /100))
  		TRB7->SALCONT7			:= (cGet17 * (cGet18/100)) * ((nTGET/100) * (nTGO /100))

	MsUnlock()


Return _nOpc



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraExcel  												  ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera Arquivo em Excel e abre                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function GeraExcel(_cAlias,_cFiltro,aHeader)

	MsAguarde({||GeraCSV(_cAlias,_cFiltro,aHeader)},"Aguarde","Gerando Planilha",.F.)

return

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

aStru := {}
aAdd(aStru,{"NPROP2"	,"C",13,0}) // 1 Proposal Number
aAdd(aStru,{"STATUS2"	,"C",13,0}) // 2 Status
aAdd(aStru,{"BOOK2"		,"C",20,0}) // 3 book
aAdd(aStru,{"FXBUD2"	,"C",15,0}) // 4 Fixed / Budget
aAdd(aStru,{"FEAEXEC2"	,"C",15,0}) // 5 Feasibility Execution
aAdd(aStru,{"OPPNAME2"	,"C",40,0}) // 6 Opportunity Name
aAdd(aStru,{"COUNTRY2"	,"C",20,0}) // 7 Country
aAdd(aStru,{"MARKSEC2"	,"C",20,0}) // 8 Market Sector
aAdd(aStru,{"INDUSTR2"	,"C",20,0}) // 9 Industry
aAdd(aStru,{"SALPER2"	,"C",40,0}) // 10 Sales Person
aAdd(aStru,{"SALREP2"	,"C",40,0}) // 11 Sales Person
aAdd(aStru,{"CODEQ2"	,"C",06,0}) // -- Equipment Description
aAdd(aStru,{"EQUIPDES2"	,"C",250,0})// 12 Equipment Description
aAdd(aStru,{"DIMENS2"	,"C",20,0}) // -- Equipment Description
aAdd(aStru,{"FORECL2"	,"D",8,0})  // 13 Forecast Close	
aAdd(aStru,{"FOREAMM2"	,"N",15,2}) // 14 Forecast Amount
aAdd(aStru,{"CONTRMG2"	,"N",15,2}) // 15 Contribution Margin
aAdd(aStru,{"VCONTRMG2"	,"N",15,2}) // 16 Contribution Margin
aAdd(aStru,{"COGS2"		,"N",15,2}) // 17 Cogs
aAdd(aStru,{"COMMISS2"	,"N",15,2}) // 18 Commission
aAdd(aStru,{"VCOMMISS2"	,"N",15,2}) // 19 Value Commission
aAdd(aStru,{"PGET2"		,"N",15,2}) // 20 % Get
aAdd(aStru,{"PGO2"		,"N",15,2}) // 21 % Go
aAdd(aStru,{"SALAMOU2"	,"N",15,2}) // 22 Sales Phase Amount
aAdd(aStru,{"SALCONT2"	,"N",15,2}) // 23 Sales Phase Contribution
aAdd(aStru,{"COMMENT2"	,"C",40,0}) // Comments
aAdd(aStru,{"CFORECL2"	,"C",7,0}) // Forecast Close TEXTO
aAdd(aStru,{"DFORECL2"	,"D",8,0}) // Forecast Close	

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
//index on ORDEM to &(cArqTrb2+"2")
index on DFORECL2 to &(cArqTrb2+"1")
index on NPROP2 to &(cArqTrb2+"2")
set index to &(cArqTrb2+"1")

aStru := {}
aAdd(aStru,{"NPROP3"		,"C",13,0}) // Proposal Number
aAdd(aStru,{"BOOK3"		,"C",20,0}) // Proposal Number
aAdd(aStru,{"STATUS3"	,"C",13,0}) // Proposal Number
aAdd(aStru,{"FXBUD3"		,"C",15,0}) // Fixed / Budget
aAdd(aStru,{"FEAEXEC3"	,"C",15,0}) // Feasibility Execution
aAdd(aStru,{"OPPNAME3"	,"C",40,0}) // Opportunity Name
aAdd(aStru,{"COUNTRY3"	,"C",20,0}) // Country
aAdd(aStru,{"MARKSEC3"	,"C",20,0}) // Market Sector
aAdd(aStru,{"INDUSTR3"	,"C",20,0}) // Industry
aAdd(aStru,{"SALPER3"	,"C",40,0}) // Sales Person
aAdd(aStru,{"SALREP3"	,"C",40,0}) // Sales Person
aAdd(aStru,{"CODEQ3"	,"C",06,0}) // Equipment Description
aAdd(aStru,{"EQUIPDES3"	,"C",250,0}) // Equipment Description
aAdd(aStru,{"DIMENS3"	,"C",20,0}) // Equipment Description
aAdd(aStru,{"FORECL3"	,"D",8,0}) // Forecast Close	
aAdd(aStru,{"FOREAMM3"	,"N",15,2}) // Forecast Amount
aAdd(aStru,{"CONTRMG3"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"VCONTRMG3"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"COGS3"		,"N",15,2}) // Cogs
aAdd(aStru,{"COMMISS3"	,"N",15,2}) // Commission
aAdd(aStru,{"VCOMMISS3"	,"N",15,2}) // Value Commission
aAdd(aStru,{"PGET3"		,"N",15,2}) // % Get
aAdd(aStru,{"PGO3"		,"N",15,2}) // % Go
aAdd(aStru,{"SALAMOU3"	,"N",15,2}) // Sales Phase Amount
aAdd(aStru,{"SALCONT3"	,"N",15,2}) // Sales Phase Contribution
aAdd(aStru,{"COMMENT3"	,"C",40,0}) // Comments
aAdd(aStru,{"CFORECL3"	,"C",7,0}) // Forecast Close TEXTO
aAdd(aStru,{"DFORECL3"	,"D",8,0}) // Forecast Close
aAdd(aStru,{"ID3"		,"C",10,0}) // Forecast Close	

dbcreate(cArqTrb3,aStru)
dbUseArea(.T.,,cArqTrb3,"TRB3",.F.,.F.)
//index on ORDEM to &(cArqTrb2+"2")
index on DFORECL3 to &(cArqTrb3+"1")
index on NPROP3 to &(cArqTrb3+"2")
set index to &(cArqTrb3+"1")

aStru := {}
aAdd(aStru,{"NPROP4"		,"C",13,0}) // Proposal Number
aAdd(aStru,{"BOOK4"		,"C",20,0}) // Proposal Number
aAdd(aStru,{"STATUS4"		,"C",13,0}) // Proposal Number
aAdd(aStru,{"FXBUD4"		,"C",15,0}) // Fixed / Budget
aAdd(aStru,{"FEAEXEC4"	,"C",15,0}) // Feasibility Execution
aAdd(aStru,{"OPPNAME4"	,"C",40,0}) // Opportunity Name
aAdd(aStru,{"COUNTRY4"	,"C",20,0}) // Country
aAdd(aStru,{"MARKSEC4"	,"C",20,0}) // Market Sector
aAdd(aStru,{"INDUSTR4"	,"C",20,0}) // Industry
aAdd(aStru,{"SALPER4"	,"C",40,0}) // Sales Person
aAdd(aStru,{"SALREP4"	,"C",40,0}) // Sales Person
aAdd(aStru,{"CODEQ4"	,"C",06,0}) // Equipment Description
aAdd(aStru,{"EQUIPDES4"	,"C",250,0}) // Equipment Description
aAdd(aStru,{"DIMENS4"	,"C",20,0}) // Equipment Description
aAdd(aStru,{"FORECL4"	,"D",8,0}) // Forecast Close	
aAdd(aStru,{"FOREAMM4"	,"N",15,2}) // Forecast Amount
aAdd(aStru,{"CONTRMG4"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"VCONTRMG4"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"COGS4"		,"N",15,2}) // Cogs
aAdd(aStru,{"COMMISS4"	,"N",15,2}) // Commission
aAdd(aStru,{"VCOMMISS4"	,"N",15,2}) // Value Commission
aAdd(aStru,{"PGET4"		,"N",15,2}) // % Get
aAdd(aStru,{"PGO4"		,"N",15,2}) // % Go
aAdd(aStru,{"SALAMOU4"	,"N",15,2}) // Sales Phase Amount
aAdd(aStru,{"SALCONT4"	,"N",15,2}) // Sales Phase Contribution
aAdd(aStru,{"COMMENT4"	,"C",40,0}) // Comments
aAdd(aStru,{"CFORECL4"	,"C",7,0}) // Forecast Close TEXTO
aAdd(aStru,{"DFORECL4"	,"D",8,0}) // Forecast Close	
aAdd(aStru,{"ID4"		,"C",10,0}) // Forecast Close

dbcreate(cArqTrb4,aStru)
dbUseArea(.T.,,cArqTrb4,"TRB4",.F.,.F.)
//index on ORDEM to &(cArqTrb2+"2")
index on DFORECL4 to &(cArqTrb4+"1")
index on NPROP4 to &(cArqTrb4+"2")
set index to &(cArqTrb4+"1")

aStru := {}
aAdd(aStru,{"NPROP5"		,"C",13,0}) // Proposal Number
aAdd(aStru,{"BOOK5"		,"C",20,0}) // Proposal Number
aAdd(aStru,{"STATUS5"	,"C",13,0}) // Proposal Number
aAdd(aStru,{"FXBUD5"		,"C",15,0}) // Fixed / Budget
aAdd(aStru,{"FEAEXEC5"	,"C",15,0}) // Feasibility Execution
aAdd(aStru,{"OPPNAME5"	,"C",40,0}) // Opportunity Name
aAdd(aStru,{"COUNTRY5"	,"C",20,0}) // Country
aAdd(aStru,{"MARKSEC5"	,"C",20,0}) // Market Sector
aAdd(aStru,{"INDUSTR5"	,"C",20,0}) // Industry
aAdd(aStru,{"SALPER5"	,"C",40,0}) // Sales Person
aAdd(aStru,{"SALREP5"	,"C",40,0}) // Sales Person
aAdd(aStru,{"CODEQ5"	,"C",06,0}) // Equipment Description
aAdd(aStru,{"EQUIPDES5"	,"C",250,0}) // Equipment Description
aAdd(aStru,{"DIMENS5"	,"C",20,0}) // Equipment Description
aAdd(aStru,{"FORECL5"	,"D",8,0}) // Forecast Close	
aAdd(aStru,{"FOREAMM5"	,"N",15,2}) // Forecast Amount
aAdd(aStru,{"CONTRMG5"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"VCONTRMG5"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"COGS5"		,"N",15,2}) // Cogs
aAdd(aStru,{"COMMISS5"	,"N",15,2}) // Commission
aAdd(aStru,{"VCOMMISS5"	,"N",15,2}) // Value Commission
aAdd(aStru,{"PGET5"		,"N",15,2}) // % Get
aAdd(aStru,{"PGO5"		,"N",15,2}) // % Go
aAdd(aStru,{"SALAMOU5"	,"N",15,2}) // Sales Phase Amount
aAdd(aStru,{"SALCONT5"	,"N",15,2}) // Sales Phase Contribution
aAdd(aStru,{"COMMENT5"	,"C",40,0}) // Comments
aAdd(aStru,{"CFORECL5"	,"C",7,0}) // Forecast Close TEXTO
aAdd(aStru,{"DFORECL5"	,"D",8,0}) // Forecast Close	
aAdd(aStru,{"ID5"		,"C",10,0}) // Forecast Close

dbcreate(cArqTrb5,aStru)
dbUseArea(.T.,,cArqTrb5,"TRB5",.F.,.F.)
//index on ORDEM to &(cArqTrb2+"2")
index on DFORECL5 to &(cArqTrb5+"1")
index on NPROP5 to &(cArqTrb5+"2")
set index to &(cArqTrb5+"1")

aStru := {}
aAdd(aStru,{"XNPROP"	,"C",13,0}) // Numero Proposta
aAdd(aStru,{"XBOOK"		,"C",20,0}) // Booking
aAdd(aStru,{"XSTATUS"	,"C",13,0}) // Status
aAdd(aStru,{"XDTPREV"	,"D",08,0}) // Prev.Venda
aAdd(aStru,{"XMERCADO"	,"C",01,0}) // Mercado
aAdd(aStru,{"XTIPO"		,"C",01,0}) // Tipo
aAdd(aStru,{"XVIAEXEC"	,"C",01,0}) // Feasibility Execution
aAdd(aStru,{"XCONTR"	,"C",40,0}) // Opportunity Name
aAdd(aStru,{"XPAIS"		,"C",30,0}) // Country
aAdd(aStru,{"XPRODUTO"	,"C",20,0}) // Produto
aAdd(aStru,{"XRESP"		,"C",40,0}) // Sales Person
aAdd(aStru,{"XREPR"		,"C",40,0}) // Sales Person
aAdd(aStru,{"CODEQ"		,"C",06,0}) // Equipment Description
aAdd(aStru,{"XEQUIP"	,"C",250,0}) // Equipment Description
aAdd(aStru,{"XDIMENS"	,"C",30,0}) // Equipment Description
aAdd(aStru,{"XCUSTOT"	,"N",15,2}) // Custo Total
aAdd(aStru,{"XTOTSI"	,"N",15,2}) // Forecast Amount
aAdd(aStru,{"XCOGS"		,"N",15,2}) // Cogs
aAdd(aStru,{"PCONTRMG"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"VCONTRMG"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"XPCOMIS"	,"N",15,2}) // % Comiss�o
aAdd(aStru,{"VCOMMISS"	,"N",15,2}) // Value Commission
aAdd(aStru,{"XPGET"		,"N",15,2}) // % Get
aAdd(aStru,{"XPGO"		,"N",15,2}) // % Go
aAdd(aStru,{"XSALAMOU"	,"N",15,2}) // Sales Phase Amount
aAdd(aStru,{"XSALCONT"	,"N",15,2}) // Sales Phase Contribution
aAdd(aStru,{"XCFORECL"	,"C",7,0}) // Forecast Close TEXTO
aAdd(aStru,{"XDFORECL"	,"D",8,0}) // Forecast Close	
aAdd(aStru,{"XID"		,"C",10,0}) // Forecast Close

dbcreate(cArqTrb6,aStru)
dbUseArea(.T.,,cArqTrb6,"TRB6",.F.,.F.)
//index on ORDEM to &(cArqTrb2+"2")
index on XDFORECL to &(cArqTrb6+"1")
index on XNPROP to &(cArqTrb6+"2")
set index to &(cArqTrb6+"1")

aStru := {}
aAdd(aStru,{"NPROP7"	,"C",13,0}) // Proposal Number
aAdd(aStru,{"BOOK7"		,"C",20,0}) // Proposal Number
aAdd(aStru,{"STATUS7"	,"C",13,0}) // Proposal Number
aAdd(aStru,{"FXBUD7"	,"C",15,0}) // Fixed / Budget
aAdd(aStru,{"FEAEXEC7"	,"C",15,0}) // Feasibility Execution
aAdd(aStru,{"OPPNAME7"	,"C",40,0}) // Opportunity Name
aAdd(aStru,{"COUNTRY7"	,"C",20,0}) // Country
aAdd(aStru,{"MARKSEC7"	,"C",20,0}) // Market Sector
aAdd(aStru,{"INDUSTR7"	,"C",20,0}) // Industry
aAdd(aStru,{"SALPER7"	,"C",40,0}) // Sales Person
aAdd(aStru,{"SALREP7"	,"C",40,0}) // Sales Person
aAdd(aStru,{"CODEQ7"	,"C",06,0}) // Equipment Description
aAdd(aStru,{"EQUIPDES7"	,"C",250,0}) // Equipment Description
aAdd(aStru,{"DIMENS7"	,"C",20,0}) // Equipment Description
aAdd(aStru,{"FORECL7"	,"D",8,0}) // Forecast Close	
aAdd(aStru,{"FOREAMM7"	,"N",15,2}) // Forecast Amount
aAdd(aStru,{"CONTRMG7"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"VCONTRMG7"	,"N",15,2}) // Contribution Margin
aAdd(aStru,{"COGS7"		,"N",15,2}) // Cogs
aAdd(aStru,{"COMMISS7"	,"N",15,2}) // Commission
aAdd(aStru,{"VCOMMISS7"	,"N",15,2}) // Value Commission
aAdd(aStru,{"PGET7"		,"N",15,2}) // % Get
aAdd(aStru,{"PGO7"		,"N",15,2}) // % Go
aAdd(aStru,{"SALAMOU7"	,"N",15,2}) // Sales Phase Amount
aAdd(aStru,{"SALCONT7"	,"N",15,2}) // Sales Phase Contribution
aAdd(aStru,{"COMMENT7"	,"C",40,0}) // Comments
aAdd(aStru,{"CFORECL7"	,"C",7,0}) // Forecast Close TEXTO
aAdd(aStru,{"DFORECL7"	,"D",8,0}) // Forecast Close	
aAdd(aStru,{"ID7"		,"C",10,0}) // Forecast Close

dbcreate(cArqTrb7,aStru)
dbUseArea(.T.,,cArqTrb7,"TRB7",.F.,.F.)
//index on ORDEM to &(cArqTrb2+"2")
index on DFORECL7 to &(cArqTrb7+"1")
index on ID7 to &(cArqTrb7+"2")
set index to &(cArqTrb7+"1")

/************** Marketing Plataforma *************/

aStru := {}
aAdd(aStru,{"DESC"		,"C",10,0}) 

for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	aAdd(aStru,{ _aCpos1[_ni] ,"N",15,2}) // Valor do movimento no di
next _dData


dbcreate(cArqTrb8,aStru)
dbUseArea(.T.,,cArqTrb8,"TRB8",.F.,.F.)

/************** Booking Sa *************/

aStru := {}
aAdd(aStru,{"DESC"		,"C",10,0}) 

for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	aAdd(aStru,{ _aCpos1[_ni] ,"N",15,2}) // Valor do movimento no di
next _dData


dbcreate(cArqTrb9,aStru)
dbUseArea(.T.,,cArqTrb9,"TRB9",.F.,.F.)

/************** Booking BR *************/

aStru := {}
aAdd(aStru,{"DESC"		,"C",10,0}) 

for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	aAdd(aStru,{ _aCpos1[_ni] ,"N",15,2}) // Valor do movimento no di
next _dData


dbcreate(cArqTrb10,aStru)
dbUseArea(.T.,,cArqTrb10,"TRB10",.F.,.F.)


/************** Booking TOTAL *************/

aStru := {}
aAdd(aStru,{"DESC"		,"C",10,0}) 

for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	aAdd(aStru,{ _aCpos1[_ni] ,"N",15,2}) // Valor do movimento no di
next _dData


dbcreate(cArqTrb11,aStru)
dbUseArea(.T.,,cArqTrb11,"TRB11",.F.,.F.)

/************** Vendidas *************/

aStru := {}
aAdd(aStru,{"DESC"		,"C",10,0}) 

for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	aAdd(aStru,{ _aCpos1[_ni] ,"N",15,2}) // Valor do movimento no di
next _dData


dbcreate(cArqTrb12,aStru)
dbUseArea(.T.,,cArqTrb12,"TRB12",.F.,.F.)

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