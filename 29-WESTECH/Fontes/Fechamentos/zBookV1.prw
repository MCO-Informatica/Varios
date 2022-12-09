#include 'protheus.ch'
#include 'parmtype.ch'
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
user function zBookV1()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Gera็ใo de planilha de Booking"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"BOOKINGV1"
private _cArq	:= 	"BOOKINGV1.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")
private cArqTrb1 := CriaTrab(NIL,.F.) //"PFIN011"
private cArqTrb2 := CriaTrab(NIL,.F.) //"PFIN011"
private cArqTrb3 := CriaTrab(NIL,.F.) //"PFIN011"
private cArqTrb4 := CriaTrab(NIL,.F.) //"PFIN011"
Private _aGrpSint:= {}

PergSalesBR()

AADD(aSays,"Este programa gera planilha com os dados para BOOKING de acordo com os ")
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

	MSAguarde({||zBookFT()},"Gerando Booking fonte 1.")
	
	MSAguarde({||zBookFT2()},"Gerando Booking fonte 2.")

	MSAguarde({||zBookTP()},"Gerando Booking por tipo.") // *** Funcao de gravacao do arquivo sintetico ***

	MSAguarde({||zBookTP2()},"Gerando Booking por m๊s.") 
	
	MontaTela()
	TRB1->(dbclosearea())
	TRB2->(dbclosearea())
	TRB3->(dbclosearea())
	TRB4->(dbclosearea())


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
static function zBookTP()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")


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
local cFor 		:= ""
Local TOTVDCI 		:= 0
Local TOTVDSI		:= 0
Local TOTCUPR		:= 0
Local TOTCOGS		:= 0
Local TOTCOMI		:= 0

Local TGVDCI 		:= 0
Local TGVDSI		:= 0
Local TGCUPR		:= 0
Local TGCOGS		:= 0
Local TGCOMI		:= 0


TRB2->(dbgotop())

//******************
cTPITEM2 		:=  "XX"

while TRB2->(!eof())

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(TRB2->ITEM2))
		ProcessMessage()

		RecLock("TRB1",.T.)
		//TRB2->OK		:= oGreen
		TRB1->ITEM		:= TRB2->ITEM2
		TRB1->DTABERT	:= TRB2->DTABERT2
		TRB1->CODCLI	:= TRB2->CODCLI2
		TRB1->CLIENTE	:= TRB2->CLIENTE2
		TRB1->DESCRI	:= TRB2->DESCRI2
		TRB1->CODPAIS	:= TRB2->CODPAIS2
		TRB1->PAIS		:= TRB2->PAIS2
		TRB1->REGIAO	:= TRB2->REGIAO2
		TRB1->VDCI		:= TRB2->VDCI2
		TRB1->VDSI		:= TRB2->VDSI2
		TRB1->CUPRD		:= TRB2->CUPRD2	
		TRB1->COGS		:= TRB2->COGS2
		TRB1->MGCONT	:= TRB2->MGCONT2
		TRB1->PCOMISS	:= TRB2->PCOMISS2
		TRB1->VCOMISS	:= TRB2->VCOMISS2 
		TRB1->CDTABERT	:= TRB2->CDTABERT2
		TRB1->TPITEM	:= TRB2->TPITEM2
		
		TOTVDCI 		+= TRB2->VDCI2
		TOTVDSI			+= TRB2->VDSI2
		TOTCUPR			+= TRB2->CUPRD2	
		TOTCOGS			+= TRB2->COGS2
		TOTCOMI			+= TRB2->VCOMISS2
	
		TGVDCI 			+= TRB2->VDCI2
		TGVDSI			+= TRB2->VDSI2
		TGCUPR			+= TRB2->CUPRD2
		TGCOGS			+= TRB2->COGS2
		TGCOMI			+= TRB2->VCOMISS2
		
		cTPITEM2 		:=  alltrim(substr(TRB2->ITEM2,1,2))		
		MsUnlock()

	TRB2->(dbskip())

	cTPITEM3 :=   alltrim(substr(TRB2->ITEM2,1,2))
	
	if cTPITEM2 <> cTPITEM3  
		RecLock("TRB1",.T.)
			TRB1->ITEM			:= "TOTAL"
			//TRB1->DTABERT		:= ""
			TRB1->CDTABERT	:= substr(dtoc(TRB2->DTABERT2),4,7)
			
			TRB1->VDCI		:= TOTVDCI
			TRB1->VDSI		:= TOTVDSI
			TRB1->CUPRD		:= TOTCUPR
			TRB1->COGS		:= TOTCOGS	
			TRB1->VCOMISS	:= TOTCOMI
			TRB1->TPITEM	:= cTPITEM2
		MsUnlock()
		
		TOTVDCI 	:= 0
		TOTVDSI		:= 0
		TOTCUPR		:= 0
		TOTCOGS		:= 0
		TOTCOMI		:= 0
		
	endif
	
enddo

RecLock("TRB1",.T.)
	TRB1->ITEM		:= "TOTAL GERAL"
	TRB1->DTABERT	:= LastDate(TRB2->DTABERT2) 
	TRB1->CDTABERT	:= substr(dtoc(TRB2->DTABERT2),4,7)
	TRB1->VDCI		:= TGVDCI
	TRB1->VDSI		:= TGVDSI
	TRB1->CUPRD		:= TGCUPR
	TRB1->COGS		:= TGCOGS	
	TRB1->VCOMISS	:= TGCOMI
	TRB1->TPITEM	:= "XX"
MsUnlock()
	

//TRB2->(dbclosearea())


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
static function zBookTP2()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")


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
local cFor 		:= ""
Local TOTVDCI 		:= 0
Local TOTVDSI		:= 0
Local TOTCUPR		:= 0
Local TOTCOGS		:= 0
Local TOTCOMI		:= 0

Local TGVDCI 		:= 0
Local TGVDSI		:= 0
Local TGCUPR		:= 0
Local TGCOGS		:= 0
Local TGCOMI		:= 0

TRB3->(dbgotop())

//******************
cTPITEM2 		:=  "99/9999"

while TRB3->(!eof())

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(TRB3->ITEM3))
		ProcessMessage()

		RecLock("TRB4",.T.)
		//TRB2->OK		:= oGreen
		TRB4->ITEM4		:= TRB3->ITEM3
		TRB4->DTABERT4	:= TRB3->DTABERT3
		TRB4->CODCLI4	:= TRB3->CODCLI3
		TRB4->CLIENTE4	:= TRB3->CLIENTE3
		TRB4->DESCRI4	:= TRB3->DESCRI3
		TRB4->CODPAIS4	:= TRB3->CODPAIS3
		TRB4->PAIS4		:= TRB3->PAIS3
		TRB4->REGIAO4	:= TRB3->REGIAO3
		TRB4->VDCI4		:= TRB3->VDCI3
		TRB4->VDSI4		:= TRB3->VDSI3
		TRB4->CUPRD4	:= TRB3->CUPRD3	
		TRB4->COGS4		:= TRB3->COGS3
		TRB4->MGCONT4	:= TRB3->MGCONT3
		TRB4->PCOMISS4	:= TRB3->PCOMISS3
		TRB4->VCOMISS4	:= TRB3->VCOMISS3 
		TRB4->CDTABERT4	:= TRB3->CDTABERT3
		TRB4->TPITEM4	:= TRB3->TPITEM3
		
		TOTVDCI 		+= TRB3->VDCI3
		TOTVDSI			+= TRB3->VDSI3
		TOTCUPR			+= TRB3->CUPRD3	
		TOTCOGS			+= TRB3->COGS3
		TOTCOMI			+= TRB3->VCOMISS3
	
		TGVDCI 			+= TRB3->VDCI3
		TGVDSI			+= TRB3->VDSI3
		TGCUPR			+= TRB3->CUPRD3
		TGCOGS			+= TRB3->COGS3
		TGCOMI			+= TRB3->VCOMISS3
		
		cTPITEM2 		:=  substr(dtoc(TRB3->DTABERT3),4,7) 
		 
		cTPITEM4		:= 	substr(TRB3->ITEM3,1,2)
		MsUnlock()

	TRB3->(dbskip())

	cTPITEM3 :=   substr(dtoc(TRB3->DTABERT3),4,7)
	
	if cTPITEM2 <> cTPITEM3  
		RecLock("TRB4",.T.)
			TRB4->ITEM4			:= "TOTAL"
			//TRB1->DTABERT		:= ""
			TRB4->CDTABERT4	:= cTPITEM2
			TRB4->VDCI4		:= TOTVDCI
			TRB4->VDSI4		:= TOTVDSI
			TRB4->CUPRD4	:= TOTCUPR
			TRB4->COGS4		:= TOTCOGS	
			TRB4->VCOMISS4	:= TOTCOMI
			TRB4->TPITEM4	:= cTPITEM4
		MsUnlock()
		
		TOTVDCI 	:= 0
		TOTVDSI		:= 0
		TOTCUPR		:= 0
		TOTCOGS		:= 0
		TOTCOMI		:= 0
		
	endif
	
enddo

RecLock("TRB4",.T.)
	TRB4->ITEM4		:= "TOTAL GERAL"
	TRB4->DTABERT4	:= LastDate(TRB3->DTABERT3) 
	TRB4->CDTABERT4	:= "99/9999"
	TRB4->VDCI4		:= TGVDCI
	TRB4->VDSI4		:= TGVDSI
	TRB4->CUPRD4	:= TGCUPR
	TRB4->COGS4		:= TGCOGS	
	TRB4->VCOMISS4	:= TGCOMI
	TRB4->TPITEM4	:= "XX"
MsUnlock()
	

//TRB2->(dbclosearea())

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
static function zBookFT()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")


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
local cFor 		:= ""

cFor	:= "!ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES/ESTOQUE'" + ;
			   " .AND.  dtos(QUERY->CTD_DTEXIS) >= '" + dtos(MV_PAR01) + "' .AND.  dtos(QUERY->CTD_DTEXIS) <= '" + dtos(MV_PAR02) + "'" 

private _cOrdem := "000001"

/**************** CTD **************/
CTD->(dbsetorder(1)) 

ChkFile("CTD",.F.,"QUERY") 
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM,CTD_DTEXIS",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		ProcessMessage()

	if SUBSTR(QUERY->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '09'
		QUERY->(dbskip())
		Loop
	endif

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
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'GR'
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'PR'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'ST'
		QUERY->(dbskip())
		Loop
	endif

		RecLock("TRB2",.T.)
		//TRB2->OK		:= oGreen
		TRB2->ITEM2		:= QUERY->CTD_ITEM
		TRB2->DTABERT2	:= QUERY->CTD_DTEXIS
		TRB2->CODCLI2	:= QUERY->CTD_XCLIEN
		TRB2->CLIENTE2	:= QUERY->CTD_XNREDU
		TRB2->DESCRI2	:= QUERY->CTD_XEQUIP
		TRB2->CODPAIS2	:= Posicione("SA1",1,xFilial("SA1") + alltrim(QUERY->CTD_XCLIEN),"A1_PAIS")
		TRB2->PAIS2		:= Posicione("SYA",1,xFilial("SYA") + alltrim(Posicione("SA1",1,xFilial("SA1") + alltrim(QUERY->CTD_XCLIEN),"A1_PAIS")),"YA_DESCR")
		if alltrim(Posicione("SA1",1,xFilial("SA1") + alltrim(QUERY->CTD_XCLIEN),"A1_PAIS")) == "105" 
			TRB2->REGIAO2		:= "BR"
		else
			TRB2->REGIAO2		:= "SA"
		endif
		TRB2->VDCI2		:= QUERY->CTD_XVDCI
		TRB2->VDSI2		:= QUERY->CTD_XVDSI
		TRB2->CUPRD2	:= QUERY->CTD_XCUSTO
		TRB2->COGS2		:= (QUERY->CTD_XCUTOT-(QUERY->CTD_XSISFV*(QUERY->CTD_XPCOM/100)))
		TRB2->MGCONT2	:= ((QUERY->CTD_XVDSI-QUERY->CTD_XCUSTO)/QUERY->CTD_XVDSI)*100
		TRB2->PCOMISS2	:= QUERY->CTD_XPCOM
		TRB2->VCOMISS2	:= (QUERY->CTD_XSISFV*(QUERY->CTD_XPCOM/100)) 
		TRB2->CDTABERT2	:= substr(dtoc(QUERY->CTD_DTEXIS),4,7)
		TRB2->TPITEM2	:= substr(QUERY->CTD_ITEM,1,2)

		MsUnlock()

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
CTD->(dbclosearea())

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
static function zBookFT2()
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")


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
local cFor 		:= ""

cFor	:= "!ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES/ESTOQUE'" + ;
			   " .AND.  dtos(QUERY->CTD_DTEXIS) >= '" + dtos(MV_PAR01) + "' .AND.  dtos(QUERY->CTD_DTEXIS) <= '" + dtos(MV_PAR02) + "'" 

private _cOrdem := "000001"

/**************** CTD **************/
CTD->(dbsetorder(1)) 

ChkFile("CTD",.F.,"QUERY") 
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM,CTD_DTEXIS",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	
	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		ProcessMessage()

	if SUBSTR(QUERY->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '09'
		QUERY->(dbskip())
		Loop
	endif

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
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'GR'
		QUERY->(dbskip())
		Loop
	endif
	
	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'PR'
		QUERY->(dbskip())
		Loop
	endif

	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QUERY->CTD_ITEM,1,2)) = 'ST'
		QUERY->(dbskip())
		Loop
	endif

		RecLock("TRB3",.T.)
		//TRB2->OK		:= oGreen
		TRB3->ITEM3		:= QUERY->CTD_ITEM
		TRB3->DTABERT3	:= QUERY->CTD_DTEXIS
		TRB3->CODCLI3	:= QUERY->CTD_XCLIEN
		TRB3->CLIENTE3	:= QUERY->CTD_XNREDU
		TRB3->DESCRI3	:= QUERY->CTD_XEQUIP
		TRB3->CODPAIS3	:= Posicione("SA1",1,xFilial("SA1") + alltrim(QUERY->CTD_XCLIEN),"A1_PAIS")
		TRB3->PAIS3		:= Posicione("SYA",1,xFilial("SYA") + alltrim(Posicione("SA1",1,xFilial("SA1") + alltrim(QUERY->CTD_XCLIEN),"A1_PAIS")),"YA_DESCR")
		if alltrim(Posicione("SA1",1,xFilial("SA1") + alltrim(QUERY->CTD_XCLIEN),"A1_PAIS")) == "105" 
			TRB3->REGIAO3		:= "BR"
		else
			TRB3->REGIAO3		:= "SA"
		endif
		TRB3->VDCI3		:= QUERY->CTD_XVDCI
		TRB3->VDSI3		:= QUERY->CTD_XVDSI
		TRB3->CUPRD3	:= QUERY->CTD_XCUSTO
		TRB3->COGS3		:= (QUERY->CTD_XCUTOT-(QUERY->CTD_XSISFV*(QUERY->CTD_XPCOM/100)))
		TRB3->MGCONT3	:= ((QUERY->CTD_XVDSI-QUERY->CTD_XCUSTO)/QUERY->CTD_XVDSI)*100
		TRB3->PCOMISS3	:= QUERY->CTD_XPCOM
		TRB3->VCOMISS3	:= (QUERY->CTD_XSISFV*(QUERY->CTD_XPCOM/100)) 
		TRB3->CDTABERT3	:= substr(dtoc(QUERY->CTD_DTEXIS),4,7)
		TRB3->TPITEM3	:= substr(QUERY->CTD_ITEM,1,2)

		MsUnlock()

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
CTD->(dbclosearea())

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
Private _oDlgSint
Private oFolder1

cCadastro = "Booking " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim)


DEFINE MSDIALOG _oDlgSint ;
TITLE "Booking - de " + dtoc(_dDataIni) + " at้ " + dtoc(_dDataFim);
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

@ aPosObj2[1,1],aPosObj2[1,2] FOLDER oFolder1 SIZE  aPosObj2[1,4],aPosObj2[1,3]-35 OF _oDlgSint ITEMS  "Booking (por M๊s)","Booking (por Tipo)" COLORS 0, 16777215 PIXEL

zTelaBTP2()
zTelaBTP()


aadd(aButton , { "BMPTABLE2" , { || zExportExc3()}, "Gerar Plan. Excel " } )
aadd(aButton , { "BMPTABLE2" , { || zPRNBook2()}, "Imprimir Booking por m๊s " } )
aadd(aButton , { "BMPTABLE2" , { || zPRNBook1()}, "Imprimir Booking por tipo " } )
aadd(aButton , { "BMPTABLE2" , { || zExpBk1()}, "Export Excel (por M๊s)" } )
aadd(aButton , { "BMPTABLE2" , { || zExpBk2()}, "Export Excel (por Tipo)" } )
aadd(aButton , { "BMPTABLE2" , { || zTelaFT()}, "Fonte 1 " } )
aadd(aButton , { "BMPTABLE2" , { || zTelaFT2()}, "Fonte 2 " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return

/***************************************************/

static function zTelaBTP()
// Monta aHeader do TRB1
aadd(aHeader, {"  Contrato"								,"ITEM"		,""					,13,0,""		,"","C","TRB1","Job No."})
aadd(aHeader, {"Data Abertura"							,"DTABERT"	,""					,08,0,""		,"","D","TRB1","R"})
aadd(aHeader, {"Cliente"								,"CLIENTE"	,""					,40,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Descri็ใo"								,"DESCRI"	,""					,40,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Regiใo"									,"REGIAO"	,""					,03,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Paํs"									,"PAIS"		,""					,20,0,""		,"","C","TRB1",""})
aadd(aHeader, {"Venda c/ Trib."							,"VDCI"		,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Venda s/ Trib."							,"VDSI"		,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Custo de Prod."							,"CUPRD"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"COGS"									,"COGS"		,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Margem Contrib."						,"MGCONT"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"% Comissใo"								,"PCOMISS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
aadd(aHeader, {"Comissใo"								,"VCOMISS"	,"@E 999,999,999.99",15,2,""		,"","N","TRB1",""})
//aadd(aHeader, {"Data Abert."							,"CDTABERT"	,""					,07,0,""		,"","C","TRB1",""})
//aadd(aHeader, {"Tipo Contrato"							,"TPITEM"	,""					,02,0,""		,"","C","TRB1",""})

_oGetDbSint := MsGetDb():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB1",,,,oFolder1:aDialogs[2])

_oGetDbSint:ForceRefresh()

// COR DA FONTE
_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor1(1)}
// COR DA LINHA
_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor1(2)} //Cor da Linha

return

/***************************************************/

static function zTelaBTP2()
// Monta aHeader do TRB1
aadd(aHeader, {"  Contrato"								,"ITEM4"	,""					,13,0,""		,"","C","TRB4","Job No."})
aadd(aHeader, {"Data Abertura"							,"DTABERT4"	,""					,08,0,""		,"","D","TRB4","R"})
aadd(aHeader, {"Cliente"								,"CLIENTE4"	,""					,40,0,""		,"","C","TRB4",""})
aadd(aHeader, {"Descri็ใo"								,"DESCRI4"	,""					,40,0,""		,"","C","TRB4",""})
aadd(aHeader, {"Regiใo"									,"REGIAO4"	,""					,03,0,""		,"","C","TRB4",""})
aadd(aHeader, {"Paํs"									,"PAIS4"	,""					,20,0,""		,"","C","TRB4",""})
aadd(aHeader, {"Venda c/ Trib."							,"VDCI4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
aadd(aHeader, {"Venda s/ Trib."							,"VDSI4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
aadd(aHeader, {"Custo de Prod."							,"CUPRD4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
aadd(aHeader, {"COGS"									,"COGS4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
aadd(aHeader, {"Margem Contrib."						,"MGCONT4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
aadd(aHeader, {"% Comissใo"								,"PCOMISS4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
aadd(aHeader, {"Comissใo"								,"VCOMISS4"	,"@E 999,999,999.99",15,2,""		,"","N","TRB4",""})
aadd(aHeader, {"Data Abert."							,"CDTABERT4",""					,07,0,""		,"","C","TRB41",""})
aadd(aHeader, {"Tipo Contrato"							,"TPITEM4"	,""					,02,0,""		,"","C","TRB4",""})

_oGetDbSint2 := MsGetDb():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB4",,,,oFolder1:aDialogs[1])

_oGetDbSint2:ForceRefresh()

// COR DA FONTE
_oGetDbSint2:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor2(1)}
// COR DA LINHA
_oGetDbSint2:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor2(2)} //Cor da Linha

return

/************************************************/

Static Function SFMudaCor1(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB1->ITEM) ==  "TOTAL GERAL"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB1->ITEM) ==  "TOTAL"; _cCor := CLR_YELLOW ; endif
      
    endif
Return _cCor

Static Function SFMudaCor2(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB4->ITEM4) ==  "TOTAL GERAL"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB4->ITEM4) ==  "TOTAL"; _cCor := CLR_YELLOW ; endif
      
    endif
Return _cCor

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
static function zTelaFT()
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


cCadastro = "Booking " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim)
// Monta aHeader do TRB1
aadd(aHeader, {"  Contrato"								,"ITEM2"	,""					,13,0,""		,"","C","TRB2","Job No."})
aadd(aHeader, {"Data Abertura"							,"DTABERT2"	,""					,08,0,""		,"","D","TRB2","R"})
aadd(aHeader, {"Cliente"								,"CLIENTE2"	,""					,40,0,""		,"","C","TRB2",""})
aadd(aHeader, {"Descri็ใo"								,"DESCRI2"	,""					,40,0,""		,"","C","TRB2",""})
aadd(aHeader, {"Regiใo"									,"REGIAO2"	,""					,03,0,""		,"","C","TRB2",""})
aadd(aHeader, {"Paํs"									,"PAIS2"	,""					,20,0,""		,"","C","TRB2",""})
aadd(aHeader, {"Venda c/ Trib."							,"VDCI2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Venda s/ Trib."							,"VDSI2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Custo de Prod."							,"CUPRD2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"COGS"									,"COGS2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Margem Contrib."						,"MGCONT2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"% Comissใo"								,"PCOMISS2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Comissใo"								,"VCOMISS2"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Data Abert."							,"CDTABERT2",""					,07,0,""		,"","C","TRB2",""})
aadd(aHeader, {"Tipo Contrato"							,"TPITEM2"	,""					,02,0,""		,"","C","TRB2",""})

DEFINE MSDIALOG _oDlgSint ;
TITLE "Booking - de " + dtoc(_dDataIni) + " at้ " + dtoc(_dDataFim);
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2")

//aadd(aButton , { "BMPTABLE2" , { || zExportExc3()}, "Gerar Plan. Excel " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

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
static function zTelaFT2()
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


cCadastro = "Booking " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim)
// Monta aHeader do TRB1
aadd(aHeader, {"  Contrato"								,"ITEM3"	,""					,13,0,""		,"","C","TRB3","Job No."})
aadd(aHeader, {"Data Abertura"							,"DTABERT3"	,""					,08,0,""		,"","D","TRB3","R"})
aadd(aHeader, {"Cliente"								,"CLIENTE3"	,""					,40,0,""		,"","C","TRB3",""})
aadd(aHeader, {"Descri็ใo"								,"DESCRI3"	,""					,40,0,""		,"","C","TRB3",""})
aadd(aHeader, {"Regiใo"									,"REGIAO3"	,""					,03,0,""		,"","C","TRB3",""})
aadd(aHeader, {"Paํs"									,"PAIS3"	,""					,20,0,""		,"","C","TRB3",""})
aadd(aHeader, {"Venda c/ Trib."							,"VDCI3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
aadd(aHeader, {"Venda s/ Trib."							,"VDSI3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
aadd(aHeader, {"Custo de Prod."							,"CUPRD3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
aadd(aHeader, {"COGS"									,"COGS3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
aadd(aHeader, {"Margem Contrib."						,"MGCONT3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
aadd(aHeader, {"% Comissใo"								,"PCOMISS3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
aadd(aHeader, {"Comissใo"								,"VCOMISS3"	,"@E 999,999,999.99",15,2,""		,"","N","TRB3",""})
//aadd(aHeader, {"Data Abert."							,"CDTABERT3",""					,07,0,""		,"","C","TRB3",""})
//aadd(aHeader, {"Tipo Contrato"							,"TPITEM3"	,""					,02,0,""		,"","C","TRB3",""})

DEFINE MSDIALOG _oDlgSint ;
TITLE "Booking - de " + dtoc(_dDataIni) + " at้ " + dtoc(_dDataFim);
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB3")

//aadd(aButton , { "BMPTABLE2" , { || zExportExc3()}, "Gerar Plan. Excel " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return

/**********************************************************/

Static Function zExpBk1()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'BookingM.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
    Local nX1		:= 1 

    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
        
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
     
    /*************** TRB4 ****************/  
   
		cTabela := "Booking (por M๊s).." 
	    cPasta	:= "Booking (por M๊s)" 
	    
	    cITEM		:= "Contrato				// 1
	    cDTABERT	:= "Data Abertura"			// 2
	    cCLIENTE	:= "Cliente"				// 3
	    cDESCRI		:= "Descri็ใo"			    // 4
	    cREGIAO		:= "Regiใo"					// 5
	    cVDCI		:= "Venda c/ Trib."			// 6
	    cVDSI		:= "Venda s/ Trib."			// 7
	    cCUPRD		:= "Custo de Prod."			// 8
	    cCOGS		:= "COGS"					// 9
	    cMGCONT		:= "Margem Contrib."		// 10
	    cPCOMISS	:= "% Comissใo"				// 11
	    cVCOMISS	:= "Comissใo"				// 12

    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cITEM)			// 1
        aAdd(aColunas, cDTABERT)		// 2				
        aAdd(aColunas, cCLIENTE)		// 3							
        aAdd(aColunas, cDESCRI)			// 4				
        aAdd(aColunas, cREGIAO)			// 5
        aAdd(aColunas, cVDCI)			// 6	
        aAdd(aColunas, cVDSI)			// 7
        aAdd(aColunas, cCUPRD)			// 8
        aAdd(aColunas, cCOGS)			// 9
        aAdd(aColunas, cMGCONT)			// 10
        aAdd(aColunas, cPCOMISS)		// 11
        aAdd(aColunas, cVCOMISS)		// 12						
                   
        oFWMsExcel:AddColumn(cTabela,cPasta, cITEM,1,2)				// 1 contrato						
        oFWMsExcel:AddColumn(cTabela,cPasta, cDTABERT,1,2)			// 2 data abertura		
        oFWMsExcel:AddColumn(cTabela,cPasta, cCLIENTE,1,2)			// 3 cliente		
        oFWMsExcel:AddColumn(cTabela,cPasta, cDESCRI,1,2)			// 4 descricao
        oFWMsExcel:AddColumn(cTabela,cPasta, cREGIAO,1,2)			// 5 regiao
        oFWMsExcel:AddColumn(cTabela,cPasta, cVDCI,1,2)				// 6 venda com tributos
        oFWMsExcel:AddColumn(cTabela,cPasta, cVDSI,1,2)				// 7 venda sem tributos
        oFWMsExcel:AddColumn(cTabela,cPasta, cCUPRD,1,2)			// 8 custo de producao
        oFWMsExcel:AddColumn(cTabela,cPasta, cCOGS,1,2)				// 9 cogs
        oFWMsExcel:AddColumn(cTabela,cPasta, cMGCONT,1,2)			// 10 margem de contribuicao
        oFWMsExcel:AddColumn(cTabela,cPasta, cPCOMISS,1,2)			// 11 % comissao
        oFWMsExcel:AddColumn(cTabela,cPasta, cVCOMISS,1,2)			// 12 valor de comissao
       
  
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB4->(dbgotop())
	                            
        While  !(TRB4->(EoF()))
    
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB4->ITEM4
        	aLinhaAux[2] := TRB4->DTABERT4
        	aLinhaAux[3] := TRB4->CLIENTE4
        	aLinhaAux[4] := TRB4->DESCRI4
        	aLinhaAux[5] := TRB4->REGIAO4
        	aLinhaAux[6] := TRB4->VDCI4
        	aLinhaAux[7] := TRB4->VDSI4
        	aLinhaAux[8] := TRB4->CUPRD4
        	aLinhaAux[9] := TRB4->COGS4
        	aLinhaAux[10] := TRB4->MGCONT4
        	aLinhaAux[11] := TRB4->PCOMISS4
        	aLinhaAux[12] := TRB4->VCOMISS4
        	
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
	 
        	
            TRB4->(DbSkip())

        EndDo

        TRB4->(dbgotop())
 
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conexใo com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return

/**********************************************************/

Static Function zExpBk2()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'BookingT.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
    Local nX1		:= 1 

    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
        
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
     
    /*************** TRB1 ****************/  
   
		cTabela := "Booking (por M๊s)...." 
	    cPasta	:= "Booking (por M๊s)" 
	    
	    cITEM		:= "Contrato				// 1
	    cDTABERT	:= "Data Abertura"			// 2
	    cCLIENTE	:= "Cliente"				// 3
	    cDESCRI		:= "Descri็ใo"			    // 4
	    cREGIAO		:= "Regiใo"					// 5
	    cVDCI		:= "Venda c/ Trib."			// 6
	    cVDSI		:= "Venda s/ Trib."			// 7
	    cCUPRD		:= "Custo de Prod."			// 8
	    cCOGS		:= "COGS"					// 9
	    cMGCONT		:= "Margem Contrib."		// 10
	    cPCOMISS	:= "% Comissใo"				// 11
	    cVCOMISS	:= "Comissใo"				// 12

    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cITEM)			// 1
        aAdd(aColunas, cDTABERT)		// 2				
        aAdd(aColunas, cCLIENTE)		// 3							
        aAdd(aColunas, cDESCRI)			// 4				
        aAdd(aColunas, cREGIAO)			// 5
        aAdd(aColunas, cVDCI)			// 6	
        aAdd(aColunas, cVDSI)			// 7
        aAdd(aColunas, cCUPRD)			// 8
        aAdd(aColunas, cCOGS)			// 9
        aAdd(aColunas, cMGCONT)			// 10
        aAdd(aColunas, cPCOMISS)		// 11
        aAdd(aColunas, cVCOMISS)		// 12						
                   
        oFWMsExcel:AddColumn(cTabela,cPasta, cITEM,1,2)				// 1 contrato						
        oFWMsExcel:AddColumn(cTabela,cPasta, cDTABERT,1,2)			// 2 data abertura		
        oFWMsExcel:AddColumn(cTabela,cPasta, cCLIENTE,1,2)			// 3 cliente		
        oFWMsExcel:AddColumn(cTabela,cPasta, cDESCRI,1,2)			// 4 descricao
        oFWMsExcel:AddColumn(cTabela,cPasta, cREGIAO,1,2)			// 5 regiao
        oFWMsExcel:AddColumn(cTabela,cPasta, cVDCI,1,2)				// 6 venda com tributos
        oFWMsExcel:AddColumn(cTabela,cPasta, cVDSI,1,2)				// 7 venda sem tributos
        oFWMsExcel:AddColumn(cTabela,cPasta, cCUPRD,1,2)			// 8 custo de producao
        oFWMsExcel:AddColumn(cTabela,cPasta, cCOGS,1,2)				// 9 cogs
        oFWMsExcel:AddColumn(cTabela,cPasta, cMGCONT,1,2)			// 10 margem de contribuicao
        oFWMsExcel:AddColumn(cTabela,cPasta, cPCOMISS,1,2)			// 11 % comissao
        oFWMsExcel:AddColumn(cTabela,cPasta, cVCOMISS,1,2)			// 12 valor de comissao
       
  
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB1->(dbgotop())
	                            
        While  !(TRB1->(EoF()))
    
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB1->ITEM
        	aLinhaAux[2] := TRB1->DTABERT
        	aLinhaAux[3] := TRB1->CLIENTE
        	aLinhaAux[4] := TRB1->DESCRI
        	aLinhaAux[5] := TRB1->REGIAO
        	aLinhaAux[6] := TRB1->VDCI
        	aLinhaAux[7] := TRB1->VDSI
        	aLinhaAux[8] := TRB1->CUPRD
        	aLinhaAux[9] := TRB1->COGS
        	aLinhaAux[10] := TRB1->MGCONT
        	aLinhaAux[11] := TRB1->PCOMISS
        	aLinhaAux[12] := TRB1->VCOMISS
        	
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
    oExcel := MsExcel():New()             //Abre uma nova conexใo com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return


/****************** Impressใo Booking por M~es *****************/

static Function zPRNBook2()

	Local oReport := nil
	Local cPerg	:= Padr("ZBOOK2",10)

	//Incluo/Altero as perguntas na tabela SX1
	//AjustaSX1(cPerg)
	//gero a pergunta de modo oculto, ficando disponํvel no botใo a็๕es relacionadas
	//Pergunte(cPerg,.T.)

	/*
	if !VldParamB2()
		return
	endif
*/

	oReport := RptDef(cPerg)
	oReport:PrintDialog()


Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Booking de " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim), ;
										cNome,{|oReport| ReportPrint(oReport)},"Descri็ใo do meu relat๓rio")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=7
	//oReport:cFontBody:="Calibri"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.


	//Monstando a primeira se็ใo
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"CTD"}, 		, .F.	, 	.F.)
	//TRCell():New(oSection1,"TMP_MESANO",	"TRBSGC",	"Mes/Ano"  		,"@!"	,	20)
	//TRCell():New(oSection1,"TMP_TIPO",		"TRBSGC",	"Tipo" 			,"@!"	,	4)

	//A segunda se็ใo,
	oSection2:= TRSection():New(oReport, "Booking de " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim) , {"CTD"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_CONTRATO"	,"TRBSGC","Contrato"			,"@!"				,22)
	TRCell():New(oSection2,"TMP_DTINI"		,"TRBSGC","Dt.Abertura"			,"@!"				,22)
	//TRCell():New(oSection2,"TMP_DTFIM"		,"TRBSGC","Prev.Entrega"		,"@!"				,22)
	TRCell():New(oSection2,"TMP_NONCLI"		,"TRBSGC","Cliente"				,"@!"				,50)
	TRCell():New(oSection2,"TMP_OPUNIT"		,"TRBSGC","Descritivo"			,"@!"				,35) 
	TRCell():New(oSection2,"TMP_PAIS"		,"TRBSGC","Pais"				,"@!"				,15)
	TRCell():New(oSection2,"TMP_XVDCI"		,"TRBSGC","Venda c/Trib."		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_XVDSI"		,"TRBSGC","Venda s/Trib."		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_CUSTOPR"    ,"TRBSGC","Custo Prd."			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_COGS"    	,"TRBSGC","COGS"				,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_MGCONTR"	,"TRBSGC","Marg.Contr."			,"@E 999,999.99"	,22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_XPCOM"		,"TRBSGC","% Comissใo"			,"@E 999.99"		,22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_XVCOM"    	,"TRBSGC","Vlr.Comissใo"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	
	oBreak1 := TRBreak():New(oSection2,{|| (TRBSGC->TMP_MESANO) },"",.F.)
	TRFunction():New(oSection2:Cell("TMP_XVDSI")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_XVDCI")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_XVDSI")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_CUSTOPR")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_COGS")		,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_XVCOM")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)


	oReport:SetTotalInLine(.F.)

        //Aqui, farei uma quebra  por se็ใo
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.
	Local dData		:= date()

	//msginfo ( dtos(dData) )
	oSection2:SetHeaderSection(.T.)
	PswOrder( 1 ) // Ordena por user ID //

	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf

	//Monto minha consulta conforme parametros passado

	cQuery := " SELECT SUBSTRING(CTD_ITEM,1,2) AS 'TMP_TIPO', CTD_ITEM AS 'TMP_CONTRATO', CTD_DTEXIS AS 'TMP_DTINI', SUBSTRING(CTD_DTEXIS,5,2)+'/'+SUBSTRING(CTD_DTEXIS,1,4) AS 'TMP_MESANO', "
	cQuery += "	CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_NONCLI', "
	cQuery += "	CTD_XEQUIP AS 'TMP_OPUNIT',   CTD_XVDCI AS 'TMP_XVDCI', CTD_XVDSI AS 'TMP_XVDSI', CTD_XCUSTO AS 'TMP_CUSTOPR', 
	cQuery += "	(CTD_XCUTOT-(CTD_XSISFV*(CTD_XPCOM/100))) AS 'TMP_COGS', CTD_XPCOM AS 'TMP_XPCOM',  (CTD_XSISFV*(CTD_XPCOM/100)) AS 'TMP_XVCOM', CTD_XCUTOT AS 'TMP_CUSTOT', "
	cQuery += "	IIF(CTD_XVDSI=0,0,((CTD_XVDSI-CTD_XCUSTO)/CTD_XVDSI)*100) AS 'TMP_MGBR', "
	cQuery += "	IIF(CTD_XVDSI=0,0,((CTD_XVDSI-CTD_XCUTOT)/CTD_XVDSI)*100) AS 'TMP_MGCONTR', " 
	cQuery += "	IIF(A1_PAIS = '105', 'BR', IIF(A1_PAIS='','NDA','SA')) AS 'TMP_PAIS', " 
	cQuery += "	CTD_DTEXSF AS 'TMP_DTFIM' " 
	cQuery += "	FROM CTD010 " 
	cQuery += "	LEFT JOIN SA1010 ON CTD_XCLIEN = SA1010.A1_COD " 
	cQuery += "	WHERE " 

	IF MV_PAR03 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'AT' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR11 + "' "

		IF  MV_PAR04 == 1 .OR. MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR04 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'CM' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR11 + "' "

		IF MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR05 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EN' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR11 + "' "

		IF  MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR06 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EQ' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR11 + "' "

		IF  MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR07 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'GR' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR11 + "' "

		IF  MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR08 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'PR' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR11 + "' "

		IF  MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR09 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'ST' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		//cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR11 + "' "
		


	ENDIF

	cQuery += "	ORDER BY SUBSTRING(CTD_DTEXIS,5,2)+'/'+SUBSTRING(CTD_DTEXIS,1,4)+SUBSTRING(CTD_ITEM,1,2) ,CTD_DTEXIS, CTD_ITEM "

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBSGC") <> 0
		DbSelectArea("TRBSGC")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBSGC"

	dbSelectArea("TRBSGC")
	TRBSGC->(dbGoTop())

	oReport:SetMeter(TRBSGC->(LastRec()))

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira se็ใo
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBSGC->TMP_MESANO
		cTipo 	:= TRBSGC->TMP_TIPO
		IncProc("Imprimindo Booking"+alltrim(TRBSGC->TMP_MESANO))

		//imprimo a primeira se็ใo
		//oSection1:Cell("TMP_MESANO"):SetValue(TRBSGC->TMP_MESANO)
		//oSection1:Cell("TMP_TIPO"):SetValue(TRBSGC->TMP_TIPO)
		//oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While TRBSGC->TMP_MESANO == cNcm //.AND. TRBSGC->TMP_TIPO  == cTipo
			oReport:IncMeter()

			IncProc("Imprimindo Booking "+alltrim(TRBSGC->TMP_MESANO))

			oSection2:Cell("TMP_CONTRATO"):SetValue(TRBSGC->TMP_CONTRATO)

			IF TMP_DTINI = ""
				oSection2:Cell("TMP_DTINI"):SetValue("")
			ELSE
				oSection2:Cell("TMP_DTINI"):SetValue(Substr(TRBSGC->TMP_DTINI,7,2) + "/" + Substr(TRBSGC->TMP_DTINI,5,2) + "/" + Substr(TRBSGC->TMP_DTINI,1,4))
			ENDIF

			oSection2:Cell("TMP_NONCLI"):SetValue(TRBSGC->TMP_NONCLI)
			oSection2:Cell("TMP_OPUNIT"):SetValue(TRBSGC->TMP_OPUNIT)

			oSection2:Cell("TMP_XVDCI"):SetValue(TRBSGC->TMP_XVDCI)
			oSection2:Cell("TMP_XVDCI"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_XVDSI"):SetValue(TRBSGC->TMP_XVDSI)
			oSection2:Cell("TMP_XVDSI"):SetAlign("RIGHT")

			oSection2:Cell("TMP_CUSTOPR"):SetValue(TRBSGC->TMP_CUSTOPR)
			oSection2:Cell("TMP_CUSTOPR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_CUSTOPR"):SetValue(TRBSGC->TMP_CUSTOPR)
			oSection2:Cell("TMP_CUSTOPR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_COGS"):SetValue(TRBSGC->TMP_COGS)
			oSection2:Cell("TMP_COGS"):SetAlign("RIGHT")
		
			oSection2:Cell("TMP_MGCONTR"):SetValue(TRBSGC->TMP_MGCONTR)
			oSection2:Cell("TMP_MGCONTR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_XPCOM"):SetValue(TRBSGC->TMP_XPCOM)
			oSection2:Cell("TMP_XPCOM"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_XVCOM"):SetValue(TRBSGC->TMP_XVCOM)
			oSection2:Cell("TMP_XVCOM"):SetAlign("RIGHT")
			
						/*
			IF TMP_DTFIM = ""
				oSection2:Cell("TMP_DTFIM"):SetValue("")
			ELSE
				oSection2:Cell("TMP_DTFIM"):SetValue(Substr(TRBSGC->TMP_DTFIM,7,2) + "/" + Substr(TRBSGC->TMP_DTFIM,5,2) + "/" + Substr(TRBSGC->TMP_DTFIM,1,4))
			ENDIF
			*/
			oSection2:Cell("TMP_PAIS"):SetValue(TRBSGC->TMP_PAIS)

			oSection2:Printline()

 			TRBSGC->(dbSkip())
 		EndDo
 		//finalizo a segunda se็ใo para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira se็ใo
		oSection1:Finish()
	Enddo
Return
/******************** Imprimir Booking po tipo **********************/

static Function zPRNBook1()


	Local oReport2 := nil
	Local cPerg:= Padr("ZBOOK1",10)

	
	oReport2 := RptDef2(cPerg)
	oReport2:PrintDialog()


Return

Static Function RptDef2(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport2 := TReport():New(cNome,"Booking de " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim), ;
										cNome,{|oReport2| ReportPrint2(oReport2)},"Descri็ใo do meu relat๓rio")
	oReport2:SetLandScape()
	oReport2:SetTotalInLine(.F.)
	oReport2:lBold:= .T.
	oReport2:nFontBody:=7
	//oReport:cFontBody:="Calibri"
	oReport2:SetLeftMargin(2)
	oReport2:SetLineHeight(40)
	oReport2:lParamPage := .F.


	//Monstando a primeira se็ใo
	oSection1:= TRSection():New(oReport2, 	"cTipo",	 	{"CTD"}, 		, .F.	, 	.F.)
	//TRCell():New(oSection1,"TMP_MESANO",	"TRBSGC",	"Mes/Ano"  		,"@!"	,	20)
	//TRCell():New(oSection1,"TMP_TIPO",		"TRBSGC",	"Tipo" 			,"@!"	,	4)

	//A segunda se็ใo,
	oSection2:= TRSection():New(oReport2, "Booking de " + dtoc(_dDataIni) + " to " + dtoc(_dDataFim) , {"CTD"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_CONTRATO"	,"TRBSGC2","Contrato"			,"@!"				,26)
	TRCell():New(oSection2,"TMP_DTINI"		,"TRBSGC2","Dt.Abertura"			,"@!"				,22)
	//TRCell():New(oSection2,"TMP_DTFIM"		,"TRBSGC2","Prev.Entrega"		,"@!"				,22)
	TRCell():New(oSection2,"TMP_NONCLI"		,"TRBSGC2","Cliente"				,"@!"				,50)
	TRCell():New(oSection2,"TMP_OPUNIT"		,"TRBSGC2","Descritivo"			,"@!"				,35) 
	TRCell():New(oSection2,"TMP_PAIS"		,"TRBSGC2","Pais"				,"@!"				,10)
	TRCell():New(oSection2,"TMP_XVDCI"		,"TRBSGC2","Venda c/Trib."		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_XVDSI"		,"TRBSGC2","Venda s/Trib."		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_CUSTOPR"    ,"TRBSGC2","Custo Prd."			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_COGS"    	,"TRBSGC2","COGS"				,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_MGCONTR"	,"TRBSGC2","Marg.Contr."			,"@E 999,999.99"	,22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_XPCOM"		,"TRBSGC2","% Comissใo"			,"@E 999.99"		,22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_XVCOM"    	,"TRBSGC2","Vlr.Comissใo"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	
	oBreak1 := TRBreak():New(oSection2,{|| (TRBSGC->TMP_TIPO) },"",.F.)
	TRFunction():New(oSection2:Cell("TMP_XVDSI")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_XVDCI")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_XVDSI")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_CUSTOPR")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_COGS")		,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_XVCOM")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	
	oReport2:SetTotalInLine(.F.)

    //Aqui, farei uma quebra  por se็ใo
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport2)

/*Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.
	Local dData		:= date()

	//msginfo ( dtos(dData) )
	oSection2:SetHeaderSection(.T.)
	PswOrder( 1 ) // Ordena por user ID //


	//Monto minha consulta conforme parametros passado

	
	cQuery2 := " SELECT SUBSTRING(CTD_ITEM,1,2) AS 'TMP_TIPO', CTD_ITEM AS 'TMP_CONTRATO', CTD_DTEXIS AS 'TMP_DTINI', SUBSTRING(CTD_DTEXIS,5,2)+'/'+SUBSTRING(CTD_DTEXIS,1,4) AS 'TMP_MESANO', "
	cQuery2 += "	CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_NONCLI', "
	cQuery2 += "	CTD_XEQUIP AS 'TMP_OPUNIT',   CTD_XVDCI AS 'TMP_XVDCI', CTD_XVDSI AS 'TMP_XVDSI', CTD_XCUSTO AS 'TMP_CUSTOPR', 
	cQuery2 += "	(CTD_XCUTOT-(CTD_XSISFV*(CTD_XPCOM/100))) AS 'TMP_COGS', CTD_XPCOM AS 'TMP_XPCOM',  (CTD_XSISFV*(CTD_XPCOM/100)) AS 'TMP_XVCOM', CTD_XCUTOT AS 'TMP_CUSTOT', "
	cQuery2 += "	IIF(CTD_XVDSI=0,0,((CTD_XVDSI-CTD_XCUSTO)/CTD_XVDSI)*100) AS 'TMP_MGBR', "
	cQuery2 += "	IIF(CTD_XVDSI=0,0,((CTD_XVDSI-CTD_XCUTOT)/CTD_XVDSI)*100) AS 'TMP_MGCONTR', " 
	cQuery2 += "	IIF(A1_PAIS = '105', 'BR', IIF(A1_PAIS='','NDA','SA')) AS 'TMP_PAIS', " 
	cQuery2 += "	CTD_DTEXSF AS 'TMP_DTFIM' " 
	cQuery2 += "	FROM CTD010 " 
	cQuery2 += "	LEFT JOIN SA1010 ON CTD_XCLIEN = SA1010.A1_COD " 
	cQuery2 += "	WHERE " 

	IF MV_PAR03 == 1
		cQuery2 += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery2 += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') "
		cQuery2 += "	AND SUBSTRING(CTD_ITEM,1,2) = 'AT' "
		cQuery2 += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery2 += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "

		IF  MV_PAR04 == 1 .OR. MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery2 += "	OR "
		ELSE
			cQuery2 += "	"
		ENDIF
	ENDIF

	IF MV_PAR04 == 1
		cQuery2 += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery2 += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') "
		cQuery2 += "	AND SUBSTRING(CTD_ITEM,1,2) = 'CM' "
		cQuery2 += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery2 += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "

		IF MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery2 += "	OR "
		ELSE
			cQuery2 += "	"
		ENDIF
	ENDIF

	IF MV_PAR05 == 1
		cQuery2 += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery2 += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') "
		cQuery2 += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EN' "
		cQuery2 += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery2 += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "

		IF  MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery2 += "	OR "
		ELSE
			cQuery2 += "	"
		ENDIF
	ENDIF

	IF MV_PAR06 == 1
		cQuery2 += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery2 += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') "
		cQuery2 += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EQ' "
		cQuery2 += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery2 += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "

		IF  MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery2 += "	OR "
		ELSE
			cQuery2 += "	"
		ENDIF
	ENDIF

	IF MV_PAR07 == 1
		cQuery2 += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery2 += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') "
		cQuery2 += "	AND SUBSTRING(CTD_ITEM,1,2) = 'GR' "
		cQuery2 += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery2 += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "

		IF  MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery2 += "	OR "
		ELSE
			cQuery2 += "	"
		ENDIF
	ENDIF

	IF MV_PAR08 == 1
		cQuery2 += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery2 += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') "
		cQuery2 += "	AND SUBSTRING(CTD_ITEM,1,2) = 'PR' "
		cQuery2 += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery2 += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "

		IF  MV_PAR09 == 1
			cQuery2 += "	OR "
		ELSE
			cQuery2 += "	"
		ENDIF
	ENDIF

	IF MV_PAR09 == 1
		cQuery2 += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery2 += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') "
		cQuery2 += "	AND SUBSTRING(CTD_ITEM,1,2) = 'ST' "
		cQuery2 += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery2 += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "


	ENDIF

	cQuery2 += "	ORDER BY 1 "

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBSGC2") <> 0
		DbSelectArea("TRBSGC2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery2 NEW ALIAS "TRBSGC2"

	dbSelectArea("TRBSGC2")
	TRBSGC2->(dbGoTop())

	oReport2:SetMeter(TRBSGC2->(LastRec()))

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira se็ใo
		oSection1:Init()

		oReport2:IncMeter()

		cNcm 	:= TRBSGC2->TMP_MESANO
		cTipo 	:= TRBSGC2->TMP_TIPO
		IncProc("Imprimindo Booking"+alltrim(TRBSGC2->TMP_TIPO))

		//imprimo a primeira se็ใo
		//oSection1:Cell("TMP_MESANO"):SetValue(TRBSGC->TMP_MESANO)
		//oSection1:Cell("TMP_TIPO"):SetValue(TRBSGC->TMP_TIPO)
		//oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While  TRBSGC2->TMP_TIPO  == cTipo
			oReport:IncMeter()

			IncProc("Imprimindo Booking "+alltrim(TRBSGC2->TMP_TIPO))

			oSection2:Cell("TMP_CONTRATO"):SetValue(TRBSGC2->TMP_CONTRATO)

			IF TMP_DTINI = ""
				oSection2:Cell("TMP_DTINI"):SetValue("")
			ELSE
				oSection2:Cell("TMP_DTINI"):SetValue(Substr(TRBSGC2->TMP_DTINI,7,2) + "/" + Substr(TRBSGC2->TMP_DTINI,5,2) + "/" + Substr(TRBSGC2->TMP_DTINI,1,4))
			ENDIF

			oSection2:Cell("TMP_NONCLI"):SetValue(TRBSGC2->TMP_NONCLI)
			oSection2:Cell("TMP_OPUNIT"):SetValue(TRBSGC2->TMP_OPUNIT)

			oSection2:Cell("TMP_XVDCI"):SetValue(TRBSGC2->TMP_XVDCI)
			oSection2:Cell("TMP_XVDCI"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_XVDSI"):SetValue(TRBSGC2->TMP_XVDSI)
			oSection2:Cell("TMP_XVDSI"):SetAlign("RIGHT")

			oSection2:Cell("TMP_CUSTOPR"):SetValue(TRBSGC2->TMP_CUSTOPR)
			oSection2:Cell("TMP_CUSTOPR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_CUSTOPR"):SetValue(TRBSGC2->TMP_CUSTOPR)
			oSection2:Cell("TMP_CUSTOPR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_COGS"):SetValue(TRBSGC2->TMP_COGS)
			oSection2:Cell("TMP_COGS"):SetAlign("RIGHT")
		
			oSection2:Cell("TMP_MGCONTR"):SetValue(TRBSGC2->TMP_MGCONTR)
			oSection2:Cell("TMP_MGCONTR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_XPCOM"):SetValue(TRBSGC2->TMP_XPCOM)
			oSection2:Cell("TMP_XPCOM"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_XVCOM"):SetValue(TRBSGC2->TMP_XVCOM)
			oSection2:Cell("TMP_XVCOM"):SetAlign("RIGHT")
			
			
			oSection2:Cell("TMP_PAIS"):SetValue(TRBSGC2->TMP_PAIS)

			oSection2:Printline()

 			TRBSGC2->(dbSkip())
 		EndDo
 		//finalizo a segunda se็ใo para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport2:ThinLine()
 		//finalizo a primeira se็ใo
		oSection1:Finish()
	Enddo
Return*/

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
Local _dDTIni
Local _dDTFin
Local dDataX
Local nUM := 1
local _ni

if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Nใo foi possํvel abrir o arquivo Booking.XLS pois ele pode estar aberto por outro usuแrio.")
	return(.F.)
endif

// monta arquivo analitico
aAdd(aStru,{"ITEM"		,"C",013,0}) // ITEM CONTA
aAdd(aStru,{"DTABERT"	,"D",008,0}) // DATA ABERTURA
aAdd(aStru,{"CODCLI"	,"C",010,0}) // COD CLIENTE
aAdd(aStru,{"CLIENTE"	,"C",130,0}) // CLIENTE
aAdd(aStru,{"DESCRI"	,"C",130,0}) // DESCRICAO EQUIPAMENTO
aAdd(aStru,{"CODPAIS"	,"C",006,0}) // COD PAIS
aAdd(aStru,{"PAIS"		,"C",030,0}) // PAIS
aAdd(aStru,{"REGIAO"	,"C",002,0}) // REGIAO
aAdd(aStru,{"VDCI"		,"N",015,2}) // VENDA COM TRIBUTOS
aAdd(aStru,{"VDSI"		,"N",015,2}) // VENDA COM TRIBUTOS
aAdd(aStru,{"CUPRD"		,"N",015,2}) // CUSTO DE PRODUCAO
aAdd(aStru,{"COGS"		,"N",015,2}) // COGS
aAdd(aStru,{"MGCONT"	,"N",015,2}) // MARGEM DE CONTRIBUICAO
aAdd(aStru,{"PCOMISS"	,"N",015,2}) // % COMISSAO
aAdd(aStru,{"VCOMISS"	,"N",015,2}) // VALOR COMISSAO
aAdd(aStru,{"CDTABERT"	,"C",007,0}) // DATA ABERTURA TEXTO
aAdd(aStru,{"TPITEM"	,"C",002,0}) // TIPO ITEM CONTA

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.F.,.F.)
index on TPITEM to &(cArqTrb1+"1")
//index on DTABERT to &(cArqTrb1+"2")
set index to &(cArqTrb1+"1")

// monta arquivo analitico
aAdd(aStru,{"ITEM2"		,"C",013,0}) // ITEM CONTA
aAdd(aStru,{"DTABERT2"	,"D",008,0}) // DATA ABERTURA
aAdd(aStru,{"CODCLI2"	,"C",010,0}) // COD CLIENTE
aAdd(aStru,{"CLIENTE2"	,"C",130,0}) // CLIENTE
aAdd(aStru,{"DESCRI2"	,"C",130,0}) // DESCRICAO EQUIPAMENTO
aAdd(aStru,{"CODPAIS2"	,"C",006,0}) // COD PAIS
aAdd(aStru,{"PAIS2"		,"C",030,0}) // PAIS
aAdd(aStru,{"REGIAO2"	,"C",002,0}) // REGIAO
aAdd(aStru,{"VDCI2"		,"N",015,2}) // VENDA COM TRIBUTOS
aAdd(aStru,{"VDSI2"		,"N",015,2}) // VENDA COM TRIBUTOS
aAdd(aStru,{"CUPRD2"	,"N",015,2}) // CUSTO DE PRODUCAO
aAdd(aStru,{"COGS2"		,"N",015,2}) // COGS
aAdd(aStru,{"MGCONT2"	,"N",015,2}) // MARGEM DE CONTRIBUICAO
aAdd(aStru,{"PCOMISS2"	,"N",015,2}) // % COMISSAO
aAdd(aStru,{"VCOMISS2"	,"N",015,2}) // VALOR COMISSAO
aAdd(aStru,{"CDTABERT2"	,"C",007,0}) // DATA ABERTURA TEXTO
aAdd(aStru,{"TPITEM2"	,"C",002,0}) // TIPO ITEM CONTA

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
index on TPITEM2 to &(cArqTrb2+"1")
index on DTABERT2 to &(cArqTrb2+"2")
set index to &(cArqTrb2+"1")

// monta arquivo analitico
aAdd(aStru,{"ITEM3"		,"C",013,0}) // ITEM CONTA
aAdd(aStru,{"DTABERT3"	,"D",008,0}) // DATA ABERTURA
aAdd(aStru,{"CODCLI3"	,"C",010,0}) // COD CLIENTE
aAdd(aStru,{"CLIENTE3"	,"C",130,0}) // CLIENTE
aAdd(aStru,{"DESCRI3"	,"C",130,0}) // DESCRICAO EQUIPAMENTO
aAdd(aStru,{"CODPAIS3"	,"C",006,0}) // COD PAIS
aAdd(aStru,{"PAIS3"		,"C",030,0}) // PAIS
aAdd(aStru,{"REGIAO3"	,"C",002,0}) // REGIAO
aAdd(aStru,{"VDCI3"		,"N",015,2}) // VENDA COM TRIBUTOS
aAdd(aStru,{"VDSI3"		,"N",015,2}) // VENDA COM TRIBUTOS
aAdd(aStru,{"CUPRD3"	,"N",015,2}) // CUSTO DE PRODUCAO
aAdd(aStru,{"COGS3"		,"N",015,2}) // COGS
aAdd(aStru,{"MGCONT3"	,"N",015,2}) // MARGEM DE CONTRIBUICAO
aAdd(aStru,{"PCOMISS3"	,"N",015,2}) // % COMISSAO
aAdd(aStru,{"VCOMISS3"	,"N",015,2}) // VALOR COMISSAO
aAdd(aStru,{"CDTABERT3"	,"C",007,0}) // DATA ABERTURA TEXTO
aAdd(aStru,{"TPITEM3"	,"C",002,0}) // TIPO ITEM CONTA

dbcreate(cArqTrb3,aStru)
dbUseArea(.T.,,cArqTrb3,"TRB3",.F.,.F.)
index on DTABERT3 to &(cArqTrb3+"1")
index on TPITEM3 to &(cArqTrb3+"2")
set index to &(cArqTrb3+"1")

// monta arquivo analitico
aAdd(aStru,{"ITEM4"		,"C",013,0}) // ITEM CONTA
aAdd(aStru,{"DTABERT4"	,"D",008,0}) // DATA ABERTURA
aAdd(aStru,{"CODCLI4"	,"C",010,0}) // COD CLIENTE
aAdd(aStru,{"CLIENTE4"	,"C",130,0}) // CLIENTE
aAdd(aStru,{"DESCRI4"	,"C",130,0}) // DESCRICAO EQUIPAMENTO
aAdd(aStru,{"CODPAIS4"	,"C",006,0}) // COD PAIS
aAdd(aStru,{"PAIS4"		,"C",030,0}) // PAIS
aAdd(aStru,{"REGIAO4"	,"C",002,0}) // REGIAO
aAdd(aStru,{"VDCI4"		,"N",015,2}) // VENDA COM TRIBUTOS
aAdd(aStru,{"VDSI4"		,"N",015,2}) // VENDA COM TRIBUTOS
aAdd(aStru,{"CUPRD4"	,"N",015,2}) // CUSTO DE PRODUCAO
aAdd(aStru,{"COGS4"		,"N",015,2}) // COGS
aAdd(aStru,{"MGCONT4"	,"N",015,2}) // MARGEM DE CONTRIBUICAO
aAdd(aStru,{"PCOMISS4"	,"N",015,2}) // % COMISSAO
aAdd(aStru,{"VCOMISS4"	,"N",015,2}) // VALOR COMISSAO
aAdd(aStru,{"CDTABERT4"	,"C",007,0}) // DATA ABERTURA TEXTO
aAdd(aStru,{"TPITEM4"	,"C",002,0}) // TIPO ITEM CONTA

dbcreate(cArqTrb4,aStru)
dbUseArea(.T.,,cArqTrb4,"TRB4",.F.,.F.)
index on CDTABERT4 to &(cArqTrb4+"1")
//index on TPITEM4 to &(cArqTrb4+"2")
set index to &(cArqTrb4+"1")

return(.T.)

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
		msgstop("Deve ser informado Sim ou Nao no parametro Equipamento")
		return(.F.)
	endif
	
	if empty(MV_PAR07)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Garantia")
		return(.F.)
	endif

	if empty(MV_PAR08)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Peca")
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