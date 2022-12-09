#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN01    												  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera arquivo de fluxo de caixa                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico 		                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function SalesBR()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Gera็ใo de planilha de Sales BR"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"SALESBR01"
private _cArq	:= 	"SALESBR01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aDatas	:= {} // Matriz no formato [ data , campo ]
private _aLegPer:= {} // legenda dos periodos
private _aCpos1	:= {} // Campos de datas criados no TRB2
private _aCpos2	:= {} // Campos de datas criados no TRB2
private _aCpos3	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nCampos2:= 0 // numero de campos de data - len(_aCpos)
private _nCampos3:= 0 // numero de campos de data - len(_aCpos)

private cArqTrb1 := CriaTrab(NIL,.F.) //"PFIN011"
private cArqTrb2 := CriaTrab(NIL,.F.) //"PFIN012"
private cArqTrb3 := CriaTrab(NIL,.F.) //"PFIN013"

Private _aGrpSint:= {}

PergSalesBR()

AADD(aSays,"Este programa gera planilha com os dados para o SALES BR/SA de acordo com os ")
AADD(aSays,"parโmetros fornecidos pelo usuแrio. O arquivo gerado pode ser aberto de forma ")
AADD(aSays,"automแtica pelo Excel.")
AADD(aSays,"")
AADD(aSays,"")
AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
if nOpcA == 1

	pergunte(cPerg,.F.)

	_dDataIni 	:= mv_par01 // Data inicial
	_dDataFim 	:= mv_par02 // Data Final
	//_nDiasPer	:= max(1 , mv_par03) // Quantidade de dias por periodo (minimo de 1 dia)
	//_dDtRef  	:= mv_par04

	// Faz consistencias iniciais para permitir a execucao da rotina
	if !VldParam() .or. !AbreArq()
		return
	endif

	MSAguarde({||PFIN01SINT()},"Gerando arquivo Sales") // *** Funcao de gravacao do arquivo sintetico ***

	MontaTela()

	//dDataBase := _cOldData // restaura a database

	TRB1->(dbclosearea())
	TRB11->(dbclosearea())
	TRB2->(dbclosearea())

endif

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN01SINTบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo Sintetico                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function PFIN01SINT()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local dData
Local QUERY 		:= ""
local cFiltra 		:= " ORDEM <> '000001' "
Local nXVDSIR		:= 0
Local nXCUPRR		:= 0
Local nXBOOKMG		:= 0
Local cTipo			:= "PR"
Local nTotalPR		:= 0
Local nTotalPRr		:= 0
Local nValPR		:= 0
local _nDias		:= 1
Local dDTIni
Local dDTFim
Local _ni2			:= 1
Local nTotalCOGS	:= 0

Local nTotalFAT		:= 0
Local nTotalFATr	:= 0
Local nValFAT		:= 0
Local nTotFAT		:= 0

Local nTotalPRC		:= 0
Local nTotalPRCr	:= 0
Local nValPRC		:= 0
Local nTotalCOMIS	:= 0
Local cTipoSZH		:= ""
Local nPerOCR		:= 0
Local dDataRef		:= MV_PAR04

Local nTotalCT4RD 	:= 0
Local nTotalCT4RDr 	:= 0

Local nTotalCT4RD_2 	:= 0
Local nTotalCT4RDr_2 	:= 0

Local cConta
Local cMoeda		:= "01"
Local cContaR		:= "4"
Local cContaD		:= "5"
Local nCredito		:= 0
Local nDebito		:= 0

Local nCredito_2	:= 0
Local nDebito_2		:= 0

Local nVDSI 		:= 0
Local nCUSTO		:= 0
Local nPropFat		:= 0
Local nPropFatTot	:= 0
Local nPropCom		:= 0
Local nPropComTot	:= 0
Local nVDSISFR		:= 0
Local nPropFrete 	:= 0

Local nTotalVDSI	:= 0
Local nTotalXCOGS	:= 0
Local nTotalXCOMIS	:= 0
Local nTotalCpo1	:= 0
Local nTotalFAT2	:= 0
Local nTotalCOGS2   := 0
Local nTotalCMS2	:= 0

Local nPropFrete2 	:= 0
Local nPropCom2		:= 0
Local nPropFat2		:= 0
Local nPropFatTot2	:= 0

Local nXPCOM2		:= 0

Local TotalRev		:= 0
Local TotalCogs		:= 0
Local TotalCMS		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLeds utilizados para as legendas das rotinasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

private _cOrdem := "000001"

//*******************

_cQuery := " SELECT  CAST(CTD_XDTCOP AS DATE) AS 'TMP_XDTCOP', CAST(CTD_XDTEVC AS DATE) AS 'TMP_XDTEVC', CAST(CTD_DTEXSF AS DATE) AS 'TMP_DTEXSF', "
_cQuery += "	IIF(A1_PAIS = '105', 'BR', IIF(A1_PAIS='','NDA','SA')) AS 'TMP_PAIS', "
_cQuery += " CTD_ITEM, CTD_XSALES, CTD_XNREDU, CTD_XPCOM, CTD_XSISFR, CTD_XVDSIR, CTD_XCUTOR,CTD_XIDPM, IIF(A1_PAIS = '105', 'BR', IIF(A1_PAIS='','NDA','SA')) AS 'TMP_PAIS' FROM "
_cQuery += " CTD010  "
_cQuery += "	LEFT JOIN SA1010 ON CTD_XCLIEN = SA1010.A1_COD "
_cQuery += " WHERE  CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' AND CTD_XSALES = '1' ORDER BY CTD_ITEM, CTD_XDTCOP "

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

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		ProcessMessage()

	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'AT'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'EN'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'EQ'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR10 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'ST'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'CM'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'PR'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR11 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'GR'
		QUERY->(dbskip())
		Loop
	endif

	/*
	if ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) $ 'GR/PR/EN/AT/ST/CM'
		QUERY->(dbskip())
		Loop
	endif
	*/

	
	if ALLTRIM(QUERY->CTD_XSALES) == '2'
		QUERY->(dbskip())
		Loop
	endif
	

	if SUBSTR(QUERY->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '09'
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM < MV_PAR03
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_XIDPM > MV_PAR04
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR12 = 2 .AND. ALLTRIM(QUERY->TMP_PAIS) = 'SA'
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR12 = 3 .AND. ALLTRIM(QUERY->TMP_PAIS) = 'BR' .OR. MV_PAR12 = 3 .AND. ALLTRIM(QUERY->TMP_PAIS) = 'ND'
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR13 == 1 .AND. dtos(QUERY->TMP_DTEXSF) < dtos(DATE())
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR13 == 2 .AND. dtos(QUERY->TMP_DTEXSF) > dtos(DATE())
		QUERY->(dbskip())
		Loop
	endif

		RecLock("TRB2",.T.)
		//TRB2->OK		:= oGreen
		TRB2->ITEM		:= QUERY->CTD_ITEM
		TRB2->CLIENTE	:= QUERY->CTD_XNREDU
		TRB2->REGIAO	:= QUERY->TMP_PAIS
		TRB2->XDELMON	:= QUERY->TMP_XDTEVC //substr(dtoc(QUERY->TMP_XDTEVC),4,7)
		TRB2->XDELMON2	:= substr(dtoc(QUERY->TMP_XDTEVC),4,7)

		//**************************** Faturamento *********************************
		
		//dbselectarea("SZQ")
		SZQ->( dbSetOrder(1))
		SZQ->(dbgotop())

		for _ni := 1 to len(_aCpos1) // Monta campos com as datas

			//FieldPut(TRB2->(fieldpos(_aCpos1[_ni])) , 2 )
			cItem 	:= QUERY->CTD_ITEM
			nXPCOM	:= QUERY->CTD_XPCOM
			nVDSISFR:= QUERY->CTD_XSISFR
			nXVCOM	:= QUERY->CTD_XSISFR * (QUERY->CTD_XPCOM / 100 )
			nVDSI 	:= QUERY->CTD_XVDSIR
			nCUSTO 	:= QUERY->CTD_XCUTOR- nXVCOM

			dDTIni :=  ctod(substr( _aLegPer[_ni],1,10))
			dDTFin :=  ctod(substr( _aLegPer[_ni],14,10 ))

			//-------------------------------Faturamento Previsto ------------------------------------------
			SZQ->( dbSetOrder(1))
			SZQ->(dbgotop())

			 	While SZQ->( ! EOF() )

					dDTIni :=  FirstDate(ctod(substr( _aLegPer[_ni],1,10)))
					dDTFin :=  LastDate(ctod(substr( _aLegPer[_ni],14,10 )))

					cItem 	:= QUERY->CTD_ITEM

					IF alltrim(SZQ->ZQ_ITEMIC) = alltrim(cItem) .AND. SZQ->ZQ_DATA >= dDTIni .AND. SZQ->ZQ_DATA <= dDTFin
						nValFAT		:= SZQ->ZQ_FATRVSI
						nTotalFAT	+= nValFAT

						//SZQ->(dbskip())
					ENDIF
					SZQ->(dbskip())
				EndDo

				//msginfo ( nTotalPRr )

			//endif

			nTotFAT  += nTotalFAT

			nTotalFATr 	:= nTotalFAT

			FieldPut(TRB2->(fieldpos(_aCpos1[_ni])) , nTotalFATr )

			nPropFat := nCUSTO * (nTotalFATr / nVDSI)
			nPropFatTot += nPropFat
			FieldPut(TRB2->(fieldpos(_aCpos2[_ni])) , nPropFat )

			nPropFrete :=  (nVDSI - nVDSISFR) * (nTotalFATr / nVDSI)
			
			nPropCom	:= (nTotalFATr - nPropFrete) * (nXPCOM /100)
			nPropComTot += nPropCom
			FieldPut(TRB2->(fieldpos(_aCpos3[_ni])) , nPropCom )


			//msginfo(nTotFAT)

			nTotalFAT		:= 0
			nTotalFATr		:= 0
			nValFAT			:= 0

		next
		TRB2->XPCOGS 	:= nXPCOM
		TRB2->XVDSI		:= nTotFAT
		TRB2->XGROSSMG	:= ( (nTotFAT - nPropFatTot) /nTotFAT ) * 100  // (nVlrMargBR_ZF / nXVDSICTD3) * 100
		TRB2->XCOGS		:= nPropFatTot
		TRB2->XCOMIS	:= nPropComTot

		nTotalVDSI 			+= nTotFAT
		nTotalXCOGS 		+= nPropFatTot
		nTotalXCOMIS		+= nPropComTot

		nPropComTot := 0
		nTotFAT := 0
		nPropFatTot := 0

		//************************** Custo Previsto ***********************************

	QUERY->(dbskip())

enddo


RecLock("TRB2",.T.)
TRB2->ITEM		:= "TOTAL"
TRB2->XDELMON	:= _dDataFim
TRB2->XVDSI		:= nTotalVDSI
TRB2->XCOGS		:= nTotalXCOGS
TRB2->XCOMIS	:= nTotalXCOMIS
//TRB2->XDELMON	:= ""
TRB2->XDELMON2	:= "99/9999"

for _ni := 1 to len(_aCpos1)
	TRB2->(dbgotop())
	while TRB2->(!eof())
		TotalRev += &("TRB2->" + _aCpos1[_ni])
		TRB2->(dbskip())
	enddo
	TRB2->(dbgobottom())
	FieldPut(TRB2->(fieldpos(_aCpos1[_ni])) , TotalRev )
	TotalRev := 0
next

for _ni := 1 to len(_aCpos2)
	TRB2->(dbgotop())
	while TRB2->(!eof())
		TotalCogs += &("TRB2->" + _aCpos2[_ni])
		TRB2->(dbskip())
	enddo
	TRB2->(dbgobottom())
	FieldPut(TRB2->(fieldpos(_aCpos2[_ni])) , TotalCogs )
	TotalCogs := 0
next

for _ni := 1 to len(_aCpos3)
	TRB2->(dbgotop())
	while TRB2->(!eof())
		TotalCMS += &("TRB2->" + _aCpos3[_ni])
		TRB2->(dbskip())
	enddo
	TRB2->(dbgobottom())
	FieldPut(TRB2->(fieldpos(_aCpos3[_ni])) , TotalCMS )
	TotalCMS := 0
next

MsUnlock()

nTotalFAT2 := 0
nPropFrete2		:= 0
nPropCom2		:= 0

QUERY->(dbclosearea())
CTD->(dbclosearea())
SE2->(dbclosearea())
SZQ->(dbclosearea())


return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaTela บ												  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a tela de visualizacao do Fluxo Sintetico            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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


cCadastro = "Sales in " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim)
// Monta aHeader do TRB2
//aadd(aHeader, {"  OK"									,"OK"		,"@BMP"				,01,0,".T."		,"","C","TRB2","OK"})
aadd(aHeader, {"  Job No."								,"ITEM"		,""					,25,0,""		,"","C","TRB2","Job No."})
aadd(aHeader, {"Cliente Name"							,"CLIENTE"	,""					,40,0,""		,"","C","TRB2",""})
aadd(aHeader, {"Region"									,"REGIAO"	,""					,03,0,""		,"","C","TRB2",""})
aadd(aHeader, {"Sales Amount"							,"XVDSI"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Gross Margin"							,"XGROSSMG"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"COGS"									,"XCOGS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"% 	"									,"XPCOGS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Commission"								,"XCOMIS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Delivery Month"							,"XDELMON2"	,""					,7,0,""			,"","C","TRB2",""})

for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	/*
	aadd(aHeader, {"Revenue "    + _aLegPer[_ni],_aCpos1[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"COGS " 		 + _aLegPer[_ni],_aCpos2[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Commission "  + _aLegPer[_ni],_aCpos3[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	*/
	
	aadd(aHeader, {"Revenue "    + substr(_aLegPer[_ni],4,7),_aCpos1[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"COGS " 		 + substr(_aLegPer[_ni],4,7),_aCpos2[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Commission "  + substr(_aLegPer[_ni],4,7),_aCpos3[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	
next _dData
//aadd(aHeader, {"Total","TOTAL","@E 999,999,999.99",15,2,"","","N","TRB2","R"})

DEFINE MSDIALOG _oDlgSint ;
TITLE "Sales BR - de " + dtoc(_dDataIni) + " at้ " + dtoc(_dDataFim);
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2")

_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

//aadd(aButton , { "SIMULACAO", { || GerSimul(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh() }, "Simula็ใo" } )
//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE2" , { || zExportExc3()}, "Gerar Plan. Excel " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return


Static Function zExportExc3()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExportExc3.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColunas2  := {}
    Local aColunas3  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsExcel := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
    
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
    oFWMsExcel:AddworkSheet("Sales") //Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Sales","Sales BR - in " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim))
        
        /*
        oFWMsExcel:AddColumn("Sales","Sales", "Job No.",1,2)		// 1 ITEM.
        oFWMsExcel:AddColumn("Sales","Sales", "Job Name",1,2)		// 2 CLIENTE
        oFWMsExcel:AddColumn("Sales","Sales", "Sales Amount",1,2)	// 3 XVDSI
        oFWMsExcel:AddColumn("Sales","Sales", "Gross Margin",1,2)	// 4 XGROSSMG
        oFWMsExcel:AddColumn("Sales","Sales", "COGS",1,2)			// 5 XCOGS
        oFWMsExcel:AddColumn("Sales","Sales", "%",1,2)				// 6 XPCOGS
        oFWMsExcel:AddColumn("Sales","Sales", "Commission",1,2)		// 7 XCOMIS
        oFWMsExcel:AddColumn("Sales","Sales", "Delivery Month",2,1)	// 8 XDELMON
        */
        
        aAdd(aColunas, "Job No.")								// 1 ITEM
        aAdd(aColunas, "Job Name")								// 2 CLIENTE
        aAdd(aColunas, "Region")								// 3 CLIENTE
        aAdd(aColunas, "Sales Amount")	 						// 4 XVDSI
        aAdd(aColunas, "Gross Margin")							// 5 XGROSSMG
        aAdd(aColunas, "COGS")									// 6 XCOGS
        aAdd(aColunas, "%")										// 7 XPCOGS
        aAdd(aColunas, "Commission")							// 8 XCOMIS
        aAdd(aColunas, "Delivery Month")						// 9 XDELMON2
        
        for _ni := 1 to len(_aCpos1) // Monta campos com as datas
        	aAdd(aColunas, "Revenue "    	+ substr(_aLegPer[_ni],4,7))
        	aAdd(aColunas, "COGS "    		+ substr(_aLegPer[_ni],4,7))
        	aAdd(aColunas, "Commission "    + substr(_aLegPer[_ni],4,7))
        next 
                
        For nAux := 1 To Len(aColunas)
            oFWMsExcel:AddColumn("Sales","Sales BR - in " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim), aColunas[nAux],1,2)
        Next
        
        nAux := 0 
         
        While  !(TRB2->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB2->ITEM
        	aLinhaAux[2] := TRB2->CLIENTE
        	aLinhaAux[3] := TRB2->REGIAO
        	aLinhaAux[4] := TRB2->XVDSI
        	aLinhaAux[5] := TRB2->XGROSSMG
        	aLinhaAux[6] := TRB2->XCOGS
        	aLinhaAux[7] := TRB2->XPCOGS
        	aLinhaAux[8] := TRB2->XCOMIS
        	aLinhaAux[9] := TRB2->XDELMON2
        	
        	nAux := 10
        	For _ni := 1 To Len(_aCpos1)
        		aLinhaAux[nAux] := &("TRB2->" + _aCpos1[_ni])
        		nAux++
        		aLinhaAux[nAux] := &("TRB2->" + _aCpos2[_ni])
        		nAux++
        		aLinhaAux[nAux] := &("TRB2->" + _aCpos3[_ni])
        		nAux++
            next 
          
        	oFWMsExcel:AddRow("Sales","Sales BR - in " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim), aLinhaAux)

            TRB2->(DbSkip())
        
        EndDo
       
        TRB2->(dbgotop())
    
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conexใo com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณShowAnalitบ												  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function ShowAnalit(_cCampo,_cPeriodo)
/*
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0 .or. (empty(TRB2->GRUPOSUP) .and. !empty(TRB2->GRUPO))
	return
endif

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra := " alltrim(CAMPO) == '" + alltrim(_cCampo) + "' .and. alltrim(ITEM) == '" + alltrim(TRB2->ITEM) + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))


// Monta aHeader do TRB1
aadd(aHeader, {"Data"		,"DATAMOV"	,"",08,0,"","","D","TRB2","R"})
aadd(aHeader, {"Item"		,"ITEM"		,"",20,0,"","","C","TRB2","R"})
aadd(aHeader, {"Hist๓rico"	,"HISTORICO","",150,0,"","","C","TRB2","R"})
aadd(aHeader, {"Valor"		,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB2","R"})


DEFINE MSDIALOG _oDlgAnalit TITLE "Fluxo de caixa - Analํtico - " + _cPeriodo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

//@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: MB - Movimento Bancแrio / CR - Contas a Receber / CP - Contas a Pagar / OC - Ordem de Compras / PV - Pedido de Vendas"

aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())
*/
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraExcel  												  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Arquivo em Excel e abre                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function GeraExcel(_cAlias,_cFiltro,aHeader)

	MsAguarde({||GeraCSV(_cAlias,_cFiltro,aHeader)},"Aguarde","Gerando Planilha",.F.)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraCSV   บAutor  										  บฑฑ
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbreArq   												  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function AbreArq()
local aStru 	:= {}
local _dData
local _nDias	:= 1
local _cCpoAtu1
local _cCpoAtu2
local _cCpoAtu3
Local _dDTIni
Local _dDTFin
Local dDataX
Local nUM := 1



local _ni

if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Nใo foi possํvel abrir o arquivo SALESBR01.XLS pois ele pode estar aberto por outro usuแrio.")
	return(.F.)
endif

_cCpoAtu1 := "R" +	strtran(dtoc(DataValida(_dDataIni),"dd/mm/yy"),"/","") // Primeiro campo que sera criado
_cCpoAtu2 := "C" +	strtran(dtoc(DataValida(_dDataIni),"dd/mm/yy"),"/","") // Primeiro campo que sera criado
_cCpoAtu3 := "M" +	strtran(dtoc(DataValida(_dDataIni),"dd/mm/yy"),"/","") // Primeiro campo que sera criado

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
			_cCpoAtu2 	:= "C" +	strtran(dtoc(_dData,"dd/mm/yy"),"/","") // gera o nome do campo
			_cCpoAtu3 	:= "M" +	strtran(dtoc(_dData,"dd/mm/yy"),"/","") // gera o nome do campo

			_nDias 		:= 1

		endif

		_nDias++

		dDataX := LastDate(_dData)+1

		//msginfo ( dDataX )

		aadd(_aDatas , {_dData, _cCpoAtu1})

		if ascan(_aCpos1 , _cCpoAtu1) == 0
			aadd(_aCpos1 , _cCpoAtu1)
		endif

		//------------------------------
		aadd(_aDatas , {_dData, _cCpoAtu2})

		if ascan(_aCpos2 , _cCpoAtu2) == 0
			aadd(_aCpos2 , _cCpoAtu2)
		endif

		//------------------------------

		aadd(_aDatas , {_dData,_cCpoAtu3})

		if ascan(_aCpos3 , _cCpoAtu3) == 0
			aadd(_aCpos3 , _cCpoAtu3)
		endif
		
		//------------------------------

	//endif
	//msginfo ( _dData )

next _dData

_nCampos := len(_aCpos1) + len(_aCpos2) + len(_aCpos3)

// monta arquivo analitico
//aAdd(aStru,{"OK"		,"C",01,0}) // Data de movimentacao
aAdd(aStru,{"DATAMOV"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"HISTORICO"	,"C",130,0}) // Historico
aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
aAdd(aStru,{"RECPAG"	,"C",01,0}) // (R)eceber ou (P)agar
aAdd(aStru,{"TIPO"		,"C",01,0}) // Tipo - (P)revisto ou (R)ealizado
aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"ITEM"		,"C",20,0}) // Codigo da Natureza
aAdd(aStru,{"CAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)
dbUseArea(.T.,,cArqTrb1,"TRB11",.T.,.F.)

aStru := {}
aAdd(aStru,{"OK"		,"C",01,0}) // Data de movimentacao
aAdd(aStru,{"ITEM"		,"C",25,0}) // Codigo da Natureza
aAdd(aStru,{"CLIENTE"	,"C",40,0}) // Descricao da Natureza
aAdd(aStru,{"REGIAO"	,"C",03,0}) // Descricao da Natureza
aAdd(aStru,{"XVDSI"		,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"XGROSSMG"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"XCOGS"		,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"XPCOGS"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"XCOMIS"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"XDELMON2"	,"C",7,0}) // Valor total dos movimentos

for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	aAdd(aStru,{ _aCpos1[_ni] ,"N",15,2}) // Valor do movimento no dia
	aAdd(aStru,{ _aCpos2[_ni] ,"N",15,2}) // Valor do movimento no dia
	aAdd(aStru,{ _aCpos3[_ni] ,"N",15,2}) // Valor do movimento no dia

next _dData
aAdd(aStru,{"ORDEM"		,"C",10,0}) // Ordem de apresentacao
aAdd(aStru,{"XDELMON"	,"D",8,0}) // Valor total dos movimentos



dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
//index on ORDEM to &(cArqTrb2+"2")
index on XDELMON2 to &(cArqTrb2+"1")
index on ITEM to &(cArqTrb2+"2")
set index to &(cArqTrb2+"1")

return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RETGRUPO 												  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o grupo de uma determinada natureza                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RETCAMPO  												  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o grupo de uma determinada natureza                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function RetCampo(_dData)
local _cRet := ""

_nPos := Ascan(_aDatas , { |x| x[1] == _dData })

if _nPos > 0
	_cRet := _aDatas[_nPos,2]
endif

return(_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDPARAM  												  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida os parametros digitados                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function VldParam()

	/*
	if empty(_dDataIni) .or. empty(_dDataFim)  // Alguma data vazia
		msgstop("Todas as datas dos parโmetros devem ser informadas.")
		return(.F.)
	endif
	*/
	if empty(_dDataIni) .or. empty(_dDataFim)  // Alguma data vazia
		msgstop("Todas as datas dos parโmetros devem ser informadas.")
		return(.F.)
	endif


	if empty(MV_PAR04)  // Alguma data vazia
		msgstop("Id do Coordenador devem ser informadas.")
		return(.F.)
	endif

	if empty(MV_PAR05)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Assistencia Tecnica")
		return(.F.)
	endif

	if empty(MV_PAR06)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Comissao")
		return(.F.)
	endif

	if empty(MV_PAR07)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Engenharia")
		return(.F.)
	endif

	if empty(MV_PAR08)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Equipamento")
		return(.F.)
	endif

	if empty(MV_PAR09)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Peca")
		return(.F.)
	endif

	if empty(MV_PAR10)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Sistema")
		return(.F.)
	endif

	if empty(MV_PAR11)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Garantia")
		return(.F.)
	endif

	if MV_PAR05 == 2 .AND. MV_PAR06 == 2 .AND. MV_PAR07 == 2 .AND. MV_PAR08 == 2 .AND. MV_PAR09 == 2 .AND. MV_PAR10 == 2 .AND. MV_PAR11 == 2
		msgstop("Deve ser informado pelo menos um tipo de Contrato como Sim")
		return(.F.)
	endif


return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  										  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function PergSalesBR()

	// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
	// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
	PutSX1(cPerg,"01","Data Inicial"					,"Data Inicial"			,"Data Inicial"			,"mv_ch1","D",08,0,0,"G","",""		,"",,"mv_par01","","","","","","","","","","","","","","","","",{"Data de inicio do processamento"})
	PutSX1(cPerg,"02","Data Final"						,"Data Final"			,"Data Final"			,"mv_ch2","D",08,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","",{"Data final do processamento"})
	putSx1(cPerg,"03", "Coordenador de?"  				, "", ""										,"mv_ch3","C",06,0,0,"G","","ZZB"	,"","", "mv_par03")
	putSx1(cPerg,"04", "Coordenador at้?" 				, "", ""										,"mv_ch4","C",06,0,0,"G","","ZZB"	,"","", "mv_par04")
	PutSX1(cPerg,"05", "Assistencia Tecnica (AT)"		, "", ""										,"mv_ch5","N",01,0,0,"C","",""		,"","", "mv_par05","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"06", "Comissao (CM)"					, "", ""										,"mv_ch6","N",01,0,0,"C","",""		,"","", "mv_par06","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"07", "Engenharia (EN)"				, "", ""										,"mv_ch7","N",01,0,0,"C","",""		,"","", "mv_par07","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"08", "Equipamento (EQ)"				, "", ""										,"mv_ch8","N",01,0,0,"C","",""		,"","", "mv_par08","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"09", "Peca (PR)"						, "", ""										,"mv_ch9","N",01,0,0,"C","",""		,"","", "mv_par09","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"10", "Sistema (ST)"					, "", ""										,"mv_ch10","N",01,0,0,"C","",""		,"","", "mv_par10","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"11", "Garantia (GR)"					, "", ""										,"mv_ch11","N",01,0,0,"C","",""		,"","", "mv_par11","Sim","","","","Nao","","","","","","","","","","","")
return