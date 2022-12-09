#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"


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
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo de Gestao de Contratos                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico 		                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function zAtuGCpe()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Custo de Contratos"
local _cOldData	:= 	dDataBase // Grava a database
 
private cPerg 	:= 	"GCIN01"
private _cArq	:= 	"GCIN01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cItemConta := ""
private _xCTCT 		:= ""

private _cNProp
private _cCodCoord
private _cNomCoord

private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)



Private _aGrpSint:= {}

//ValidPerg()

//FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
//if nOpcA == 1

	pergunte(cPerg,.T.)

	// Faz consistencias iniciais para permitir a execucao da rotina
	if !VldParam() .or. !AbreArq()
		return
	endif

	//if alltrim(substr(_cItemConta,1,2)) == "PR" .OR. alltrim(substr(_cItemConta,1,2)) == "AT" .OR. alltrim(substr(_cItemConta,1,2)) == "CM" .OR. ;
				//alltrim(substr(_cItemConta,1,2)) == "EN" .OR. alltrim(substr(_cItemConta,1,2)) == "GR" 
		MSAguarde({||PLANEJ03()},"Processando Planejamento de Contrato...... ")
	//else
		MSAguarde({||PLANEJ02()},"Processando Planejamento de Contrato... ")	
	//endif

	MSAguarde({||VEND02()},"Processando Vendido ")

	MSAguarde({||PFIN01REAL()},"Processando Ordem de Compra")
	
	MSAguarde({||D101FULL()},"Processando Documento de Entrada...")

	MSAguarde({||DE01REAL()},"Processando Rateio Documento de Entrada")

	MSAguarde({||HR01REAL()},"Processando Apontamento de Horas")

	MSAguarde({||FIN01REAL()},"Processando Financeiro")

	MSAguarde({||CUDIV01REAL()},"Processando Custos Diversos ")

	MSAguarde({||CV401REAL()},"Processando Financeiro Rateio")

	MSAguarde({||GC01SINT()},"Gerando arquivo sintético.") // *** Funcao de gravacao do arquivo sintetico ***

	MontaTela()
	//ShowAnalit()
	
	TRB1->(dbclosearea())
	TRB2->(dbclosearea())
	
//endif


return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa Vendido 01 Equipamento / Sistema	              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function VEND02()

local _cQuery := ""
Local _cFilSZP := xFilial("SZP")
Local cIDSZF := ""
Local cIDSZG := ""
Local cIDSZP := ""

Local nQTDSZF := 0
Local nQTDSZG := 0 
Local nQTDSZP := 0

Local nQTSZG := 0

Local cDescSZP := ""
Local cDescSZG := ""
local cFor	:= ""
local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"

Local aInd2:={}
 Local cCondicao2
 Local bFiltraBrw2

/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/

dbSelectArea("SZF")
SZF->( dbSetOrder(1)) 
SZF->(dbgotop())

dbSelectArea("SZG")
SZG->( dbSetOrder(1))
SZG->(dbgotop())
 

SZP->(dbsetorder(3))

ChkFile("SZP",.F.,"QUERY")

QCTD->(dbGoTop())

while QCTD->(!eof())

	

	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	
	_cItemConta 	:= QCTD->CTD_ITEM
	

cFor 	:= "ALLTRIM(QUERY->ZP_ITEMIC) == alltrim(_cItemConta)"
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZP_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZP_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+ alltrim(_cItemConta) + " - " + alltrim(QUERY->ZP_IDVDSUB))
		ProcessMessage()

		TRB1->TIPO		:= "N3"
		TRB1->NUMERO	:= QUERY->ZP_IDVDSUB
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->CAMPO		:= "XMATPRV"

		if alltrim(QUERY->ZP_GRUPO) == "MPR"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
			TRB1->CAMPO	 	:= "XMATPRV"
		elseif alltrim(QUERY->ZP_GRUPO) == "FAB"
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
			TRB1->CAMPO	 	:= "XFABRIV"
		elseif alltrim(QUERY->ZP_GRUPO) == "COM"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO	 	:= "XCOMERV"
		elseif alltrim(QUERY->ZP_GRUPO) == "SRV"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
			TRB1->CAMPO	 	:= "XSERVIV"
		elseif alltrim(QUERY->ZP_GRUPO) == "ESL"
			TRB1->ID		:= "ESL"
			TRB1->DESCRICAO	:= "ENGENHARIA SLC"
			TRB1->CAMPO		:= "XGENSLV"
		elseif alltrim(QUERY->ZP_GRUPO) == "EBR"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->CAMPO		:= "XENGBRV"
		elseif alltrim(QUERY->ZP_GRUPO) == "CTR"
			TRB1->ID		:= "CTR"
			TRB1->DESCRICAO	:= "CONTRATOS"
			TRB1->CAMPO		:= "XMOCTRV"
		elseif alltrim(QUERY->ZP_GRUPO) == "IDL"
			TRB1->ID		:= "IDL"
			TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
			TRB1->CAMPO		:= "XINSPDV"
		/*elseif alltrim(QUERY->ZD_GRUPO) == "FIN"
			TRB1->ID		:= "FIN"
			TRB1->DESCRICAO	:= "FINANCEIRO"*/
		elseif alltrim(QUERY->ZP_GRUPO) == "CMS"
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
			TRB1->CAMPO		 := "XCOMISV"
		elseif alltrim(QUERY->ZP_GRUPO) == "RDV"
			TRB1->ID		:= "RDV"
			TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
			TRB1->CAMPO		:= "XRERDVV"
		elseif alltrim(QUERY->ZP_GRUPO) == "FRT"
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
			TRB1->CAMPO		:= "XFRETEV"
		elseif alltrim(QUERY->ZP_GRUPO) == "CDV"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
			TRB1->CAMPO		:= "XCUDIVV"
		endif
		

		cIDSZP := alltrim(QUERY->ZP_IDVDSUB)
		cDescSZP := alltrim(QUERY->ZP_DESCRI)
		
		
		SZG->(dbgotop())
		cCondicao2:= "ALLTRIM(SZG->ZG_ITEMIC) == _cItemConta  "
		bFiltraBrw2 := {|| FilBrowse("SZG",@aInd2,@cCondicao2) }
		Eval(bFiltraBrw2)
		
		//msginfo (cValtoChar(nQTDSZD) + " " + cIDSZO )
		
		While SZG->(!eof())	
		
			if cIDSZP == alltrim(SZG->ZG_IDVDSUB)
				nQTSZG := SZG->ZG_QUANT //Posicione("SZD",1,xFilial("SZD")+cIDSZO,"ZD_QUANTR") 
			
				cDescSZG := ALLTRIM(SZG->ZG_DESCRI) + " <-> " + cDescSZP  //alltrim(Posicione("SZD",1,xFilial("SZD") + cIDSZO,"ZD_DESCRI")) 
				TRB1->UNIDADE		:= QUERY->ZP_UM
				exit
			endif
			SZG->(dbskip())
		
		enddo
		TRB1->HISTORICO		:= cDescSZG 
		TRB1->PRODUTO		:= ""
		
		TRB1->QUANTIDADE	:= nQTSZG
		TRB1->VALOR			:= (QUERY->ZP_TOTAL * nQTSZG)
		


		TRB1->PRODUTO		:= ""
		//TRB1->QUANTIDADE	:= QUERY->ZP_QUANT
		//TRB1->UNIDADE		:= QUERY->ZP_UM
		//TRB1->HISTORICO		:= QUERY->ZP_DESCRI
		//TRB1->VALOR			:= (QUERY->ZP_TOTAL*nQTDSZG) //*nQTDSZF

		TRB1->ORIGEM		:= "VD"
		TRB1->ITEMCONTA 	:= QUERY->ZP_ITEMIC
		//TRB1->CAMPO		 	:= "VLRVD"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo
QCTD->(dbskip())

enddo

QCTD->(dbclosearea())
QUERY->(dbclosearea())

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa Plajemento							              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function PLANEJ02()

local _cQuery := ""
Local _cFilSZO := xFilial("SZU")
local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"

Local cIDSZC := ""
Local cIDSZD := ""
Local cIDSZO := ""
Local cIDSZU := ""

Local nQTDSZC := 0
Local nQTDSZD := 0
Local nQTDSZO := 0
Local nQTDSZU := 0

Local nQTSZD := 0
Local nQTSZO := 0
Local nQTSZU := 0

Local cDescSZO := ""
Local cDescSZD := ""
//Local cDescSZO := ""
Local cDescSZU := ""

Local aInd:={}
 Local cCondicao
 Local bFiltraBrw
 

 Local aInd2:={}
 Local cCondicao2
 Local bFiltraBrw2
 
 Local aInd3:={}
 Local cCondicao3
 Local bFiltraBrw3
 
 local cFor := ""

/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/
dbSelectArea("SZC")
SZC->( dbSetOrder(1)) 
SZC->(dbgotop())

dbSelectArea("SZD")
SZD->( dbSetOrder(1))
SZD->(dbgotop())
 
dbSelectArea("SZO")
SZO->(dbsetorder(3))
SZO->(dbgotop())

dbSelectArea("SZU")
SZU->(dbsetorder(2))
SZU->(dbgotop())
/********************************************/

ChkFile("SZU",.F.,"QUERYSZU")



/********************************************/
dbSelectArea("SZO")
/********************************************/
dbSelectArea("SZD")
/********************************************/

QCTD->(dbGoTop())


while QCTD->(!eof())


	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if  ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if  ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	
	_cItemConta 	:= QCTD->CTD_ITEM
	

	cFor := "ALLTRIM(QUERYSZU->ZU_ITEMIC) == _cItemConta"
	
	IndRegua("QUERYSZU",CriaTrab(NIL,.F.),"ZU_ITEMIC",,cFor,"Selecionando Registros...")
	ProcRegua(QUERYSZU->(reccount()))

	QUERYSZU->(dbgotop())
	
	SZO->( dbSetOrder(3))
		
		
		cCondicao2:= "ALLTRIM(SZO->ZO_ITEMIC) == _cItemConta  "
		bFiltraBrw2 := {|| FilBrowse("SZO",@aInd2,@cCondicao2) }
		Eval(bFiltraBrw2)
	
	SZD->( dbSetOrder(1))
		
		
	cCondicao3:= "ALLTRIM(SZD->ZD_ITEMIC) == _cItemConta  "
		bFiltraBrw3 := {|| FilBrowse("SZD",@aInd3,@cCondicao3) }
		Eval(bFiltraBrw3)
		
		//msginfo (cValtoChar(nQTSZO) + " " + cIDSZO )
		
	
		while QUERYSZU->(!eof())
		
			
			/*
			cCondicao:= "ALLTRIM(QUERYSZU->ZU_ITEMIC) == _cItemConta  "
			bFiltraBrw := {|| FilBrowse("QUERYSZU",@aInd,@cCondicao) }
			Eval(bFiltraBrw)
			*/
			if ALLTRIM(QUERYSZU->ZU_ITEMIC) == alltrim(_cItemConta)
		
				RecLock("TRB1",.T.)
				
				MsProcTxt("Processando registro: " + _cItemConta + " - " + alltrim(QUERYSZU->ZU_IDPLSB2))
				ProcessMessage()
		
				TRB1->TIPO		:= "N4"
				//TRB1->NUMERO	:= QUERYSZU->ZO_IDPLSB2
				TRB1->NUMERO	:= QUERYSZU->ZU_IDPLSB2
				TRB1->ID		:= "MPR"
				TRB1->DESCRICAO	:= "MATERIA PRIMA"
				TRB1->CAMPO		:= "XMATPRP"
		
				if alltrim(QUERYSZU->ZU_GRUPO) == "MPR"
					TRB1->ID		:= "MPR"
					TRB1->DESCRICAO	:= "MATERIA PRIMA"
					TRB1->CAMPO		:= "XMATPRP"
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "FAB"
					TRB1->ID		:= "FAB"
					TRB1->DESCRICAO	:= "FABRICACAO"
					TRB1->CAMPO		:= "XFABRIP"
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "COM"
					TRB1->ID		:= "COM"
					TRB1->DESCRICAO	:= "COMERCIAIS"
					TRB1->CAMPO		:= "XCOMERP"
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "SRV"
					TRB1->ID		:= "SRV"
					TRB1->DESCRICAO	:= "SERVICOS"
					TRB1->CAMPO		:= "XSERVIP"
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "EBR"
					TRB1->ID		:= "EBR"
					TRB1->DESCRICAO	:= "ENGENHARIA BR"
					TRB1->CAMPO		:= "XENGBRP"
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "ESL"
					TRB1->ID		:= "ESL"
					TRB1->DESCRICAO	:= "ENGENHARIA SLC"
					TRB1->CAMPO		:= "XENGSLP"
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "CTR"
					TRB1->ID		:= "CTR"
					TRB1->DESCRICAO	:= "CONTRATOS"
					TRB1->CAMPO		:= "XMOCTRP"
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "IDL"
					TRB1->ID		:= "IDL"
					TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
					TRB1->CAMPO		:= "XINSPDP"
				/*elseif alltrim(QUERY->ZO_GRUPO) == "FIN"
					TRB1->ID		:= "FIN"
					TRB1->DESCRICAO	:= "FINANCEIRO"*/
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "CMS"
					TRB1->ID		:= "CMS"
					TRB1->DESCRICAO	:= "COMISSAO"
					TRB1->CAMPO		:= "XCOMISP"
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "RDV"
					TRB1->ID		:= "RDV"
					TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
					TRB1->CAMPO		:= "XRERDVP"
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "FRT"
					TRB1->ID		:= "FRT"
					TRB1->DESCRICAO	:= "FRETE"
					TRB1->CAMPO		:= "XFRETEP"
				elseif alltrim(QUERYSZU->ZU_GRUPO) == "CDV"
					TRB1->ID		:= "CDV"
					TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
					TRB1->CAMPO		:= "XCUDIVP"
				endif
			
				
					cIDSZU 		:= alltrim(QUERYSZU->ZU_IDPLSB2)
					cDescSZU	:= alltrim(QUERYSZU->ZU_DESCRI)
							
					SZO->(dbgotop())
					
					While SZO->(!eof())	
						if cIDSZU == alltrim(SZO->ZO_IDPLSB2) 
							nQTSZO 		:= SZO->ZO_QUANTR
							cIDSZO		:= alltrim(SZO->ZO_IDPLSUB)
							cDescSZO 	:= "(" + cValtoChar(nQTSZO) + ") " + ALLTRIM(SZO->ZO_DESCRI)  + " <-> " + cDescSZU
							exit 
						endif
						SZO->(dbskip())
					enddo
				
					//*********************
					
					SZD->(dbgotop())
				
					While SZD->(!eof())
						if cIDSZO == alltrim(SZD->ZD_IDPLSUB) 
							nQTSZD 		:= SZD->ZD_QUANTR
							cDescSZD 	:= "(" + cValtoChar(nQTSZD) + ") " + ALLTRIM(SZD->ZD_DESCRI)  + " <-> " + cDescSZO  //+ " <-> " + cDescSZU
							exit
						endif
						SZD->(dbskip())
					enddo
					//*********************
					
					TRB1->QUANTIDADE	:= nQTSZD
					TRB1->VALOR			:= (QUERYSZU->ZU_TOTALR * nQTSZO) * nQTSZD
					
				
				TRB1->HISTORICO		:= cDescSZD 
				TRB1->PRODUTO		:= ""
				TRB1->ORIGEM		:= "PL"
				TRB1->ITEMCONTA 	:= QUERYSZU->ZU_ITEMIC
				//TRB1->CAMPO		 	:= "VLRPLN"
		
				MsUnlock()
		
			endif
		
			QUERYSZU->(dbskip())
			
			//cIDSZU 		:= ""
			//cDescSZU	:= ""
			
			//nQTSZO 		:= 0
			//cIDSZO		:= ""
			//cDescSZO 	:= ""
			
			//nQTSZD 		:= 0
			//cDescSZD 	:= ""
			
		enddo
		

	
QCTD->(dbskip())

enddo


SZD->(dbclosearea())
SZO->(dbclosearea())
SZU->(dbclosearea())
QCTD->(dbclosearea())
QUERYSZU->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa Plajemento							              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function PLANEJ03()

local _cQuery := ""
Local _cFilSZO := xFilial("SZO")
local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"

Local cIDSZC := ""
Local cIDSZD := ""
Local cIDSZO := ""
Local cIDSZU := ""

Local nQTDSZC := 0
Local nQTSZDp3 := 0
Local nQTDSZO := 0
Local nQTDSZU := 0

Local nQTSZD := 0
Local nQTSZO := 0
Local nQTSZU := 0

Local cDescSZO := ""
Local cDescSZD := ""
//Local cDescSZO := ""
Local cDescSZU := ""

Local aInd:={}
 Local cCondicao
 Local bFiltraBrw

 local cFor := ""


/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/
dbSelectArea("SZC")
SZC->( dbSetOrder(1)) 
SZC->(dbgotop())

dbSelectArea("SZD")
SZD->( dbSetOrder(1))
SZD->(dbgotop())
 
dbSelectArea("SZO")
SZO->(dbsetorder(3))
SZO->(dbgotop())

dbSelectArea("SZU")
SZU->(dbsetorder(1))
SZU->(dbgotop())
/*******************************************/
ChkFile("SZO",.F.,"QUERYSZO")

/*******************************************/



QCTD->(dbGoTop())


while QCTD->(!eof())

	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if  ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if  ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	
	_cItemConta 	:= QCTD->CTD_ITEM
	
	cFor := "ALLTRIM(QUERYSZO->ZO_ITEMIC) == _cItemConta"
	IndRegua("QUERYSZO",CriaTrab(NIL,.F.),"ZO_ITEMIC",,cFor,"Selecionando Registros...")

	ProcRegua(QUERYSZO->(reccount()))
	
		QUERYSZO->(dbgotop())
		
		while QUERYSZO->(!eof())
		
			if ALLTRIM(QUERYSZO->ZO_ITEMIC) == alltrim(_cItemConta)
		
				RecLock("TRB1",.T.)
				
				MsProcTxt("Processando registro: " + _cItemConta + " - " + alltrim(QUERYSZO->ZO_IDPLSB2))
				ProcessMessage()
		
				TRB1->TIPO		:= "N3"
				TRB1->NUMERO	:= QUERYSZO->ZO_IDPLSB2
				
				TRB1->ID		:= "MPR"
				TRB1->DESCRICAO	:= "MATERIA PRIMA"
				TRB1->CAMPO		:= "XMATPRP"
		
				if alltrim(QUERYSZO->ZO_GRUPO) == "MPR"
					TRB1->ID		:= "MPR"
					TRB1->DESCRICAO	:= "MATERIA PRIMA"
					TRB1->CAMPO		:= "XMATPRP"
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "FAB"
					TRB1->ID		:= "FAB"
					TRB1->DESCRICAO	:= "FABRICACAO"
					TRB1->CAMPO		:= "XFABRIP"
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "COM"
					TRB1->ID		:= "COM"
					TRB1->DESCRICAO	:= "COMERCIAIS"
					TRB1->CAMPO		:= "XCOMERP"
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "SRV"
					TRB1->ID		:= "SRV"
					TRB1->DESCRICAO	:= "SERVICOS"
					TRB1->CAMPO		:= "XSERVIP"
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "EBR"
					TRB1->ID		:= "EBR"
					TRB1->DESCRICAO	:= "ENGENHARIA BR"
					TRB1->CAMPO		:= "XENGBRP"
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "ESL"
					TRB1->ID		:= "ESL"
					TRB1->DESCRICAO	:= "ENGENHARIA SLC"
					TRB1->CAMPO		:= "XENGSLP"
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "CTR"
					TRB1->ID		:= "CTR"
					TRB1->DESCRICAO	:= "CONTRATOS"
					TRB1->CAMPO		:= "XMOCTRP"
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "IDL"
					TRB1->ID		:= "IDL"
					TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
					TRB1->CAMPO		:= "XINSPDP"
				/*elseif alltrim(QUERY->ZO_GRUPO) == "FIN"
					TRB1->ID		:= "FIN"
					TRB1->DESCRICAO	:= "FINANCEIRO"*/
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "CMS"
					TRB1->ID		:= "CMS"
					TRB1->DESCRICAO	:= "COMISSAO"
					TRB1->CAMPO		:= "XCOMISP"
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "RDV"
					TRB1->ID		:= "RDV"
					TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
					TRB1->CAMPO		:= "XRERDVP"
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "FRT"
					TRB1->ID		:= "FRT"
					TRB1->DESCRICAO	:= "FRETE"
					TRB1->CAMPO		:= "XFRETEP"
				elseif alltrim(QUERYSZO->ZO_GRUPO) == "CDV"
					TRB1->ID		:= "CDV"
					TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
					TRB1->CAMPO		:= "XCUDIVP"
				endif
				
				cIDSZO := alltrim(QUERYSZO->ZO_IDPLSUB)
				cDescSZO := alltrim(QUERYSZO->ZO_DESCRI)
				
				
				SZD->( dbSetOrder(1))
				SZD->(dbgotop())
				
				//msginfo (cValtoChar(nQTDSZD) + " " + cIDSZO )
			
				cCondicao:= "ALLTRIM(SZD->ZD_ITEMIC) == _cItemConta  "
				bFiltraBrw := {|| FilBrowse("SZD",@aInd,@cCondicao) }
				Eval(bFiltraBrw)

				While SZD->(!eof())	
				
					if cIDSZO == alltrim(SZD->ZD_IDPLSUB)
						nQTSZD := SZD->ZD_QUANTR //Posicione("SZD",1,xFilial("SZD")+cIDSZO,"ZD_QUANTR") 
					
						cDescSZD := ALLTRIM(SZD->ZD_DESCRI)  + " <-> " + cDescSZO  //alltrim(Posicione("SZD",1,xFilial("SZD") + cIDSZO,"ZD_DESCRI")) 
						TRB1->UNIDADE		:= QUERYSZO->ZO_UMR
						
						exit
					endif
					SZD->(dbskip())
				
				enddo
				
				TRB1->QUANTIDADE	:= nQTSZD
				TRB1->VALOR			:= (QUERYSZO->ZO_TOTALR * nQTSZD) 
			
				TRB1->HISTORICO		:= cDescSZD 
				TRB1->PRODUTO		:= ""
				TRB1->ORIGEM		:= "PL"
				TRB1->ITEMCONTA 	:= QUERYSZO->ZO_ITEMIC
				//TRB1->CAMPO		 	:= "VLRPLN"
		
				MsUnlock()
				
				
		
			endif
		
			
			QUERYSZO->(dbskip())
		
		enddo


	QCTD->(dbskip())

enddo


SZD->(dbclosearea())
SZO->(dbclosearea())
SZU->(dbclosearea())
QCTD->(dbclosearea())

QUERYSZO->(dbclosearea())

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa Ordens de compra   			                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function PFIN01REAL()

local _cQuery := ""
Local QUERY := ""
Local QCTD := ""
Local _cFilSC7 := xFilial("SC7")
local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"
local cFor	:= ""
	Local dData
	Local nValor := 0
	local dDataM2

/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/
SC7->(dbsetorder(23)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SC7",.F.,"QUERYSC7") // Alias dos movimentos bancarios

/************************************/
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
/************************************/
//CTD->(dbsetorder(1))

QCTD->(dbGoTop())

while QCTD->(!eof())

	

	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	
	_cItemConta 	:= QCTD->CTD_ITEM 
	

	cFor := "QUERYSC7->C7_ITEMCTA == alltrim(_cItemConta)"

IndRegua("QUERYSC7",CriaTrab(NIL,.F.),"C7_EMISSAO",,cFor,"Selecionando Registros...")

ProcRegua(QUERYSC7->(reccount()))


QUERYSC7->(dbgotop())

//******************************
	
QUERY2->(dbGoTop())

//*************************
while QUERYSC7->(!eof())

	if QUERYSC7->C7_ITEMCTA == alltrim(_cItemConta) .and. alltrim(QUERYSC7->C7_ENCER) == ""

		RecLock("TRB1",.T.)
		//IncProc("Processando registro: "  + _cItemConta + " - " + alltrim(QUERYSC7->C7_NUM))
		MsProcTxt("Processando registro: "  + _cItemConta + " - " + alltrim(QUERYSC7->C7_NUM))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QUERYSC7->C7_EMISSAO
		TRB1->TIPO		:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO"))
		TRB1->NUMERO	:= QUERYSC7->C7_NUM
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->CAMPO		:= "XMATPRA"

		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "MP" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
			TRB1->CAMPO		:= "XMATPRA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "AI" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "EM" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "GE" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "GG" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "MC" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "ME" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
			TRB1->CAMPO		:= "XMATPRA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "MO" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003") 
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "OI" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
			TRB1->CAMPO		:= "XMATPRA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "PA" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "PI" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "PP" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "PV" ;
										.AND. !SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "SL" ;
										.AND. SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) $ ("SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC") ;
									.AND. SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22"  .AND. !ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003/22220018/2219005");
									.AND. ALLTRIM(QUERYSC7->C7_FORNECE) <> "000022"
									
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
			TRB1->CAMPO		:= "XSERVIA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) $ ("SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC") ;
									.AND. SUBSTR(ALLTRIM(QUERYSC7->C7_PRODUTO),1,2) == "22"  .AND. ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("22220018/2219005")
									
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
			TRB1->CAMPO		:= "XFABRIA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERYSC7->C7_PRODUTO,"B1_TIPO")) == "MO" ;
									.AND. ALLTRIM(QUERYSC7->C7_FORNECE) == "000022"
			TRB1->ID		:= "ESL"
			TRB1->DESCRICAO	:= "ENGENHARIA SLC"
			TRB1->CAMPO		:= "XENGSLA"
		elseif ALLTRIM(QUERYSC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
			TRB1->CAMPO		:= "XFRETEA"

		endif

		TRB1->PRODUTO	:= QUERYSC7->C7_PRODUTO
		if QUERYSC7->C7_QUJE > 0
			TRB1->QUANTIDADE:= QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE
		else
			TRB1->QUANTIDADE:= QUERYSC7->C7_QUANT
		endif
		TRB1->UNIDADE	:= QUERYSC7->C7_UM
		TRB1->HISTORICO	:= QUERYSC7->C7_DESCRI
	

		if QUERYSC7->C7_MOEDA = 2
			dData := QUERYSC7->C7_EMISSAO
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
			IF QUERYSC7->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)
				TRB1->VALOR2	:= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_TOTAL * nValor)
			ELSE
				TRB1->VALOR		:= QUERYSC7->C7_XTOTSI * nValor
				TRB1->VALOR2	:= QUERYSC7->C7_TOTAL * nValor
			ENDIF

		elseif QUERYSC7->C7_MOEDA = 3
			dData := QUERYSC7->C7_EMISSAO
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
			IF QUERYSC7->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)
				TRB1->VALOR2	:= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_TOTAL * nValor)
			ELSE
				TRB1->VALOR		:= QUERYSC7->C7_XTOTSI * nValor
				TRB1->VALOR2	:= QUERYSC7->C7_TOTAL * nValor
			ENDIF

		elseif QUERYSC7->C7_MOEDA = 4
			dData := QUERYSC7->C7_EMISSAO
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
			IF QUERYSC7->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI * nValor)
				TRB1->VALOR2	:= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_TOTAL * nValor)
			ELSE
				TRB1->VALOR		:= QUERYSC7->C7_XTOTSI * nValor
				TRB1->VALOR2	:= QUERYSC7->C7_TOTAL * nValor
			ENDIF
		else
			IF QUERYSC7->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_XTOTSI) 
				TRB1->VALOR2	:= ((QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)/QUERYSC7->C7_QUANT) * (QUERYSC7->C7_TOTAL) 
			ELSE
				
				TRB1->VALOR		:= QUERYSC7->C7_XTOTSI 
				TRB1->VALOR2	:= QUERYSC7->C7_TOTAL 
			ENDIF
		endif

		TRB1->CODFORN	:= QUERYSC7->C7_FORNECE
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERYSC7->C7_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= ""
		TRB1->DNATUREZA := ""
		TRB1->ORIGEM	:= "OC"
		TRB1->ITEMCONTA := QUERYSC7->C7_ITEMCTA
		//TRB1->CAMPO		:= "VLREMP"

		MsUnlock()

	endif

	QUERYSC7->(dbskip())

enddo


	QCTD->(dbskip())

enddo

QCTD->(dbclosearea())
QUERYSC7->(dbclosearea())
QUERY2->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa Documentos de Entrada		                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function D101FULL()

local _cQSD1 := ""
Local _cFilSD1 := xFilial("SD1")
local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"

/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/

_cQSD1 := "SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO' , D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, D1_BASEICM, D1_CUSTO, D1_FORNECE  FROM SD1010  WHERE  D_E_L_E_T_ <> '*' ORDER BY D1_EMISSAO"

	IF Select("_cQSD1") <> 0
		DbSelectArea("_cQSD1")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQSD1 NEW ALIAS "QSD1"

	dbSelectArea("QSD1")
	
QCTD->(dbGoTop())

while QCTD->(!eof())

	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	
	_cItemConta 	:= QCTD->CTD_ITEM


QSD1->(dbGoTop())

while QSD1->(!eof())

	if QSD1->D1_ITEMCTA == alltrim(_cItemConta);
		.AND. ! alltrim(QSD1->D1_CF) $ ;
		('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') ;
		.AND. QSD1->D1_RATEIO == '2';
		.AND. QSD1->D1_RATEIO == '2'
		
		//.OR. QUERY->D1_ITEMCTA == _cItemConta .AND. ! alltrim(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') .AND. QUERY->D1_RATEIO == '2';
		//.AND. !alltrim(QUERY->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2916/2920/2921/2924/2925/2949')

		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "  + _cItemConta + " - " + alltrim(QSD1->D1_DOC))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QSD1->TMP_EMISSAO
		TRB1->TIPO		:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO"))
		TRB1->NUMERO	:= QSD1->D1_DOC
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->CAMPO		:= "XMATPRA"

		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "MP" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
			TRB1->CAMPO		:= "XMATPRA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "AI" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "EM" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "GE" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "GG" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "MC" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "ME" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
			TRB1->CAMPO		:= "XMATPRA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "MO" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "OI" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "PA" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "PI" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "PP" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "PV" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "SL" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "SV" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QSD1->D1_COD) $ ("224001/224004/224002/2212004/224003");
				.OR.;
				!ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QSD1->D1_COD) $ ("224001/224004/224002/2212004/224003/22220018/2219005") ;
				.AND. ALLTRIM(QSD1->D1_FORNECE) <> "000022"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
			TRB1->CAMPO		:= "XSERVIA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" .AND. !ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QSD1->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QSD1->D1_COD) $ ("22220018/2219005")
				
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
			TRB1->CAMPO		:= "XFABRIA"
		
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_TIPO")) == "MO" ;
									.AND. ALLTRIM(QSD1->D1_FORNECE) == "000022"
			TRB1->ID		:= "ESL"
			TRB1->DESCRICAO	:= "ENGENHARIA SLC"
			TRB1->CAMPO		:= "XENGSLA"
			
		elseif ALLTRIM(QSD1->D1_XNATURE) $ ('6.21.00/6.22.00')
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
			TRB1->CAMPO		:= "XCOMISA"
		elseif ALLTRIM(QSD1->D1_COD) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
			TRB1->CAMPO		:= "XFRETEA"
		else
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
			TRB1->CAMPO		:= "XCUDIVA"
		endif

		TRB1->PRODUTO	:= QSD1->D1_COD
		TRB1->HISTORICO	:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QSD1->D1_COD,"B1_DESC"))
		TRB1->QUANTIDADE:= QSD1->D1_QUANT
		TRB1->UNIDADE 	:= QSD1->D1_UM
		TRB1->VALOR		:= QSD1->D1_CUSTO
		if SUBSTR(ALLTRIM(QSD1->D1_CF),1,1) = "3"
			TRB1->VALOR2	:= QSD1->D1_BASEICM
		ELSE
			TRB1->VALOR2	:= QSD1->D1_TOTAL
		END
		
		TRB1->CODFORN	:= QSD1->D1_FORNECE
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QSD1->D1_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= QSD1->D1_CF
		TRB1->NATUREZA	:= QSD1->D1_XNATURE
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+QSD1->D1_XNATURE,"ED_DESCRIC"))
		TRB1->ORIGEM	:= "DE"
		TRB1->ITEMCONTA := QSD1->D1_ITEMCTA
		//TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QSD1->(dbskip())

enddo

	QCTD->(dbskip())

enddo

QCTD->(dbclosearea())
QSD1->(dbclosearea())

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa Documentos de Entrada		                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"
local cFor	:= ""

/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/

SD1->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SDE",.F.,"QUERY") // Alias dos movimentos bancarios


QCTD->(dbGoTop())

while QCTD->(!eof())

	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	
	_cItemConta 	:= QCTD->CTD_ITEM

	cFor := "QUERY->DE_ITEMCTA == alltrim(_cItemConta)"
	
IndRegua("QUERY",CriaTrab(NIL,.F.),"QUERY->DE_DOC",,cFor,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

		cDoc		:= QUERY->DE_DOC
		//cSerie		:= QUERY->DE_SERIE
		cFornece	:= QUERY->DE_FORNECE
		//cLoja		:= QUERY->DE_LOJA
		cItemNF		:= QUERY->DE_ITEMNF

while QUERY->(!eof())

	 

	if QUERY->DE_ITEMCTA == alltrim(_cItemConta);
		.AND. ! alltrim(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_CF")) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') 
		
		cDoc		:= QUERY->DE_DOC
		cSerie		:= QUERY->DE_SERIE
		cFornece	:= QUERY->DE_FORNECE
		cLoja		:= QUERY->DE_LOJA
		cItemNF		:= QUERY->DE_ITEMNF
		
		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "  + _cItemConta + " - " + alltrim(QUERY->DE_DOC))
		ProcessMessage()

		cProdD1 		:= ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_COD"))
		
		
		
		TRB1->DATAMOV	:= POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_EMISSAO")
		TRB1->TIPO		:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO"))
		TRB1->NUMERO	:= QUERY->DE_DOC
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->CAMPO		:= "XMATPRA"

		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "MP" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
			TRB1->CAMPO		:= "XMATPRA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "AI" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "EM" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "GE" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
			TRB1->CAMPO		:= "XCUDIVA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "GG" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
			TRB1->CAMPO		:= "XCUDIVA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "MC" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "ME" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "MO" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
			TRB1->CAMPO		:= "XSERVIA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "OI" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "PA" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "PI" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "PP" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO"))== "PV" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
			TRB1->CAMPO		:= "XCUDIVA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SL" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. ALLTRIM(cProdD1) $ ("22220018/2219005");
				
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
			TRB1->CAMPO		:= "XFABRIA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" ;
				.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. !ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003/22220018/2219005")
				
		/*alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV" ;
				.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. !ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003/22220018/2219005");
				.OR.;*/
				
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
			TRB1->CAMPO		:= "XSERVIA"
		
			
			
		elseif ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00')
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
			TRB1->CAMPO		:= "XCOMISA"
		elseif ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
			TRB1->CAMPO		:= "XFRETEA"
		else
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
			TRB1->CAMPO		:= "XCUDIVA"
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
		//TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QCTD->(dbskip())

enddo

QCTD->(dbclosearea())

QUERY->(dbclosearea())

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa FINANCEIRO					                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function FIN01REAL()

local _cQuery := ""
Local _cFilSE2 := xFilial("SE2")
Local nXIPI := 0
Local nXII := 0
Local nXCOFINS := 0
Local nXPIS := 0
Local nXICMS := 0
Local nXSISCO := 0
Local nXSDA := 0
Local nXTERM := 0
Local nXTRANSP := 0
Local nXFRETE := 0
Local nXFUMIG := 0
Local nXARMAZ := 0
Local nXAFRMM := 0
Local nXCAPA := 0
Local nXCOMIS := 0
Local nXISS := 0
Local nXIRRF := 0
Local nCustoFin := 0
local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"

/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/

_cQuery := "SELECT CAST(E2_BAIXA AS DATE) TMP_BAIXA, E2_TIPO, E2_NUM, E2_NATUREZ, E2_HIST, E2_VLCRUZ, E2_FORNECE, E2_NATUREZ, E2_XXIC, E2_RATEIO, E2_SALDO, E2_BAIXA, "
_cQuery += " E2_TIPO,E2_XIPI,E2_XII,E2_XCOFINS,E2_XPIS,E2_XICMS,E2_XSISCO,E2_XSDA,E2_XTERM,E2_XTRANSP,E2_XFRETE,E2_XFUMIG,E2_XARMAZ,E2_XAFRMM,E2_XCAPA,E2_XCOMIS,E2_XISS,E2_XIRRF, "
_cQuery += " E2_XCTII,E2_XCTIPI,E2_XCTCOF,E2_XCTPIS,E2_XCTICMS,E2_XCTSISC,E2_XCTSDA,E2_XCTTEM,E2_XCTTRAN,E2_XCTFRET,E2_XCTFUM,E2_XCTARM,E2_XCTAFRM,E2_XCTCAPA,E2_XCTCOM,E2_XCTISS,E2_XCTIRRF "
_cQuery += " FROM SE2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY E2_BAIXA "

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	
QCTD->(dbGoTop())

while QCTD->(!eof())

	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	
	_cItemConta 	:= QCTD->CTD_ITEM

	
	QUERY->(dbGoTop())

while QUERY->(!eof())

	IF ALLTRIM(QUERY->E2_TIPO) = "PA" .AND. QUERY->E2_BAIXA <> "" .AND. QUERY->E2_SALDO = 0
		QUERY->(dbsKip())
		loop
	ENDIF
	
	
	if QUERY->E2_XXIC == alltrim(_cItemConta) .AND. ;
	 	!ALLTRIM(QUERY->E2_TIPO) $ ("NF/PR/PA/TX/ISS/INS/INV") .AND. ALLTRIM(QUERY->E2_RATEIO) == "N" 

		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "  + _cItemConta + " - " + alltrim(QUERY->E2_NUM))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->TMP_BAIXA
		TRB1->TIPO		:= QUERY->E2_TIPO
		TRB1->NUMERO	:= QUERY->E2_NUM

		TRB1->ID		:= "CDV"
		TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		TRB1->CAMPO		:= "XCUDIVA"

		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.00.00/2.20.00/2.24.00/2.25.00/2.25.02/3.00.00/3.11.01/3.11.02/3.12.01/3.12.02/3.13.01/3.13.02/3.14.01/" + ;
   										"3.16.01/3.16.02/3.17.01/3.17.02/3.18.00/3.19.00/3.20.00/3.21.00/3.22.00/3.23.00/3.23.01/3.23.02/3.30.00/" + ;
   										"3.14.02/3.31.00/3.32.00/3.33.00/3.34.00/3.41.00/3.42.00/3.50.00/3.51.00/3.53.00/3.55.00/3.56.01/3.56.02/" + ;
   										"3.60.00/3.61.00/3.62.00/3.63.00/3.71.00/3.76.00/3.80.00/3.81.00/3.82.00/3.83.00/3.84.00/3.86.00/3.87.00/" + ;
   										"4.00.00/4.40.00/4.41.00/4.42.00/4.43.00/4.44.00/4.45.00/4.47.00/4.48.00/4.50.00/4.52.00/4.53.00/4.54.00/" + ;
   										"4.55.00/4.56.00/4.57.01/4.57.02/4.58.00/4.59.00/5.00.00/5.60.00/5.61.00/5.62.00/5.63.00/5.80.00/5.82.00/" + ;
   										"6.00.00/6.10.00/6.11.00/6.12.00/6.13.00/6.14.00/6.15.00/6.16.00/6.17.00/6.18.00/6.19.00/6.20.00/7.00.00/" + ;
   										"9.00.00/9.10.00/9.11.00/9.12.00/9.13.00/9.14.00/9.15.00/9.16.00/9.17.00/9.18.00/9.20.00/9.21.00/9.22.00/" + ;
   										"9.23.00/9.24.00/9.25.00/9.26.00/9.30.00/9.31.00/9.32.00/9.33.00/9.34.00/9.35.00/9.36.00/9.40.00/9.41.00/" + ;
   										"9.42.00/9.43.00/9.50.00/9.51.00/9.52.00/9.53.00/9.54.00/9.55.00/APLICACAO/CARTAO/CHEQUE/COFINS/CONVENIO/" + ;
   										"CREDITO/CSLL/DEV./TROCA/DINHEIRO/FINAN/ICMS/INSS/IRF/ISS/NCC/OUTROS/PIS/RECEBIMENT/RESG.APLIC/SANGRIA/TEF/" + ;
   										"TROCO/VALE/"
   			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
			TRB1->CAMPO		:= "XCUDIVA"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
			TRB1->CAMPO		:= "XCOMISA"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.15.01/3.15.02/7.10.00/7.20.00/7.30.00/7.40.00/7.50.00/7.60.00/7.70.00/7.80.00/7.90.00"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMISA"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "8.24.00"
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
			TRB1->CAMPO		:= "XFRETEA"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.10.00/2.11.00/2.12.00/2.13.00/2.14.00/2.15.00/2.16.00/2.17.00/2.18.00/2.19.00/2.21.00/2.22.00/2.23.00/2.25.01/3.10.00/3.57.00"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
			TRB1->CAMPO		:= "XMATPRA"
		endif

		if ALLTRIM(QUERY->E2_TIPO) $ ("RDV") .OR. ALLTRIM(QUERY->E2_NATUREZ) $ "3.70.00/3.72.00/3.73.00/3.74.01/3.74.02/3.75.00/3.77.00/3.85.00/4.51.00/5.64.00/5.70.00" + ;
																			"5.71.00/5.72.00/5.73.00/5.74.00/5.75.00/5.76.00/5.77.00/5.78.00/5.79.00/5.81.00/5.83.00/5.84.00"
			TRB1->ID		:= "RDV"
			TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
			TRB1->CAMPO		:= "XRERDVA"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.40.00/8.00.00/8.10.00/8.10.01/8.11.00/8.12.00/8.12.01/8.13.00/8.14.00/8.15.00/8.15.01/8.15.02/8.16.00/8.17.00/8.17.01/8.18.00/" + ;
										"8.19.00/8.19.01/8.19.02/8.20.00/8.20.01/8.20.02/8.20.03/8.21.00/8.21.01/8.21.02/8.22.00/8.23.00/8.23.01/8.23.02/8.23.03/8.23.04/" + ;
										"8.23.05/8.23.06/8.23.07/8.25.00/8.26.00/8.27.00/8.28.00/8.28.01/8.29.00/8.30.00/8.31.00"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
			TRB1->CAMPO		:= "XSERVIA"
		endif

		TRB1->PRODUTO	:= ""
		TRB1->HISTORICO	:= QUERY->E2_HIST
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE 	:= ""
		
				
		if QUERY->E2_XCTIPI = "2"
			nXIPI := QUERY->E2_XIPI
		else
			nXIPI := 0
		endif
		
		if QUERY->E2_XCTII = "2"
			nXII := QUERY->E2_XII
		else
			nXII := 0
		endif
		
		if QUERY->E2_XCTCOF = "2"
			nXCOFINS := QUERY->E2_XCOFINS
		else
			nXCOFINS := 0
		endif
		
		if QUERY->E2_XCTPIS = "2"
			nXPIS := QUERY->E2_XPIS
		else
			nXPIS := 0
		endif
		
		if QUERY->E2_XCTICMS = "2"
			nXICMS := QUERY->E2_XICMS
		else
			nXICMS := 0
		endif
		
		if QUERY->E2_XCTSISC = "2"
			nXSISCO := QUERY->E2_XSISCO
		else
			nXSISCO := 0
		endif
		
		if QUERY->E2_XCTSDA = "2"
			nXSDA := QUERY->E2_XSDA
		else
			nXSDA := 0
		endif
		
		if QUERY->E2_XCTTEM = "2"
			nXTERM := QUERY->E2_XTERM
		else
			nXTERM := 0
		endif
		
		if QUERY->E2_XCTTRAN = "2"
			nXTRANSP := QUERY->E2_XTRANSP
		else
			nXTRANSP := 0
		endif
		
		if QUERY->E2_XCTFRET = "2"
			nXFRETE := QUERY->E2_XFRETE
		else
			nXFRETE := 0
		endif
		
		if QUERY->E2_XCTFUM = "2"
			nXFUMIG := QUERY->E2_XFUMIG
		else
			nXFUMIG := 0
		endif
		
		if QUERY->E2_XCTARM = "2"
			nXARMAZ := QUERY->E2_XARMAZ
		else
			nXARMAZ := 0
		endif
		
		if QUERY->E2_XCTAFRM = "2"
			nXAFRMM := QUERY->E2_XAFRMM
		else
			nXAFRMM := 0
		endif
		
		if QUERY->E2_XCTCAPA = "2"
			nXCAPA := QUERY->E2_XCAPA
		else
			nXCAPA := 0
		endif
		
		if QUERY->E2_XCTCOM = "2"
			nXCOMIS := QUERY->E2_XCOMIS
		else
			nXCOMIS := 0
		endif
		
		if QUERY->E2_XCTISS = "2"
			nXISS := QUERY->E2_XISS
		else
			nXISS := 0
		endif
		
		if QUERY->E2_XCTIRRF = "2"
			nXIRRF := QUERY->E2_XIRRF
		else
			nXIRRF := 0
		endif
		
		nCustoFin := QUERY->E2_VLCRUZ - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
		if QUERY->E2_TIPO = "PA"
			TRB1->VALOR		:= QUERY->E2_SALDO
			TRB1->VALOR2	:= QUERY->E2_SALDO
		ELSE
			TRB1->VALOR		:= nCustoFin
			TRB1->VALOR2	:= nCustoFin
		endiF
		TRB1->CODFORN	:= QUERY->E2_FORNECE
	
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->E2_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= QUERY->E2_NATUREZ
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+QUERY->E2_NATUREZ,"ED_DESCRIC"))
		TRB1->ORIGEM	:= "FN"
		TRB1->ITEMCONTA := QUERY->E2_XXIC
		//TRB1->CAMPO		:= "VLREMP"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QCTD->(dbskip())

enddo

QCTD->(dbclosearea())

QUERY->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa FINANCEIRO RATEIO			                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function CV401REAL()

local _cQuery := ""
local cQuery := ""
Local _cFilCV4 := xFilial("CV4")

local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"

/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/


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

QCTD->(dbGoTop())

while QCTD->(!eof())

	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	
	_cItemConta 	:= QCTD->CTD_ITEM


QUERY->(dbgotop())


while QUERY->(!eof())

	IF ALLTRIM(QUERY->E2_TIPO) = "PA" .AND. QUERY->E2_BAIXA <> "" 
		QUERY->(dbsKip())
		loop
	ENDIF

	if QUERY->CV4_ITEMD == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "  + _cItemConta + " - " + alltrim(QUERY->CV4_SEQUEN))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->TMP_DTSEQ
		TRB1->NUMERO	:= QUERY->CV4_SEQUEN
		TRB1->TIPO		:= QUERY->E2_TIPO
		TRB1->ID		:= "CDV"
		TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		TRB1->CAMPO		:= "XCUDIVA"

		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.00.00/2.20.00/2.24.00/2.25.00/2.25.02/3.00.00/3.11.01/3.11.02/3.12.01/3.12.02/3.13.01/3.13.02/3.14.01/" + ;
   										"3.16.01/3.16.02/3.17.01/3.17.02/3.18.00/3.19.00/3.20.00/3.21.00/3.22.00/3.23.00/3.23.01/3.23.02/3.30.00/" + ;
   										"3.14.02/3.31.00/3.32.00/3.33.00/3.34.00/3.41.00/3.42.00/3.50.00/3.51.00/3.53.00/3.55.00/3.56.01/3.56.02/" + ;
   										"3.60.00/3.61.00/3.62.00/3.63.00/3.71.00/3.76.00/3.80.00/3.81.00/3.82.00/3.83.00/3.84.00/3.86.00/3.87.00/" + ;
   										"4.00.00/4.40.00/4.41.00/4.42.00/4.43.00/4.44.00/4.45.00/4.47.00/4.48.00/4.50.00/4.52.00/4.53.00/4.54.00/" + ;
   										"4.55.00/4.56.00/4.57.01/4.57.02/4.58.00/4.59.00/5.00.00/5.60.00/5.61.00/5.62.00/5.63.00/5.80.00/5.82.00/" + ;
   										"6.00.00/6.10.00/6.11.00/6.12.00/6.13.00/6.14.00/6.15.00/6.16.00/6.17.00/6.18.00/6.19.00/6.20.00/7.00.00/" + ;
   										"9.00.00/9.10.00/9.11.00/9.12.00/9.13.00/9.14.00/9.15.00/9.16.00/9.17.00/9.18.00/9.20.00/9.21.00/9.22.00/" + ;
   										"9.23.00/9.24.00/9.25.00/9.26.00/9.30.00/9.31.00/9.32.00/9.33.00/9.34.00/9.35.00/9.36.00/9.40.00/9.41.00/" + ;
   										"9.42.00/9.43.00/9.50.00/9.51.00/9.52.00/9.53.00/9.54.00/9.55.00/APLICACAO/CARTAO/CHEQUE/COFINS/CONVENIO/" + ;
   										"CREDITO/CSLL/DEV./TROCA/DINHEIRO/FINAN/ICMS/INSS/IRF/ISS/NCC/OUTROS/PIS/RECEBIMENT/RESG.APLIC/SANGRIA/TEF/" + ;
   										"TROCO/VALE/"
   			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
			TRB1->CAMPO		:= "XCUDIVA"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
			TRB1->CAMPO		:= "XCOMISA"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.15.01/3.15.02/7.10.00/7.20.00/7.30.00/7.40.00/7.50.00/7.60.00/7.70.00/7.80.00/7.90.00"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
			TRB1->CAMPO		:= "XCOMERA"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "8.24.00"
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
			TRB1->CAMPO		:= "XFRETEA"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.10.00/2.11.00/2.12.00/2.13.00/2.14.00/2.15.00/2.16.00/2.17.00/2.18.00/2.19.00/2.21.00/2.22.00/2.23.00/2.25.01/3.10.00/3.57.00"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
			TRB1->CAMPO		:= "XMATPRA"
		endif

		if  ALLTRIM(QUERY->E2_NATUREZ) $ "3.70.00/3.72.00/3.73.00/3.74.01/3.74.02/3.75.00/3.77.00/3.85.00/4.51.00/5.64.00/5.70.00" + ;
																			"5.71.00/5.72.00/5.73.00/5.74.00/5.75.00/5.76.00/5.77.00/5.78.00/5.79.00/5.81.00/5.83.00/5.84.00"
			TRB1->ID		:= "RDV"
			TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
			TRB1->CAMPO		:= "XRERDVA"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.40.00/8.00.00/8.10.00/8.10.01/8.11.00/8.12.00/8.12.01/8.13.00/8.14.00/8.15.00/8.15.01/8.15.02/8.16.00/8.17.00/8.17.01/8.18.00/" + ;
										"8.19.00/8.19.01/8.19.02/8.20.00/8.20.01/8.20.02/8.20.03/8.21.00/8.21.01/8.21.02/8.22.00/8.23.00/8.23.01/8.23.02/8.23.03/8.23.04/" + ;
										"8.23.05/8.23.06/8.23.07/8.25.00/8.26.00/8.27.00/8.28.00/8.28.01/8.29.00/8.30.00/8.31.00"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
			TRB1->CAMPO		:= "XSERVIA"
		endif

		TRB1->PRODUTO	:= ""
		TRB1->HISTORICO	:= QUERY->CV4_HIST
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE 	:= ""
		TRB1->VALOR		:= QUERY->CV4_VALOR
		TRB1->VALOR2	:= QUERY->CV4_VALOR
		TRB1->CODFORN	:= QUERY->E2_FORNECE
		TRB1->FORNECEDOR:= QUERY->E2_NOMFOR
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= QUERY->E2_NATUREZ
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+QUERY->E2_NATUREZ,"ED_DESCRIC"))
		TRB1->ORIGEM	:= "FR"
		TRB1->ITEMCONTA := QUERY->CV4_ITEMD
		//TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QCTD->(dbskip())

enddo

QCTD->(dbclosearea())

QUERY->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFIN01REALºAutor  ³Marcos Zanetti GZ   º Data ³  01/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa HORAS DE CONTRATO				                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


static function HR01REAL()

local _cQuery := ""
Local _cFilSZ4 := xFilial("SZ4")
Local nTarefa
local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"
local cFor 	:= ""

/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/

//SZ4->(dbsetorder(9)) 

ChkFile("SZ4",.F.,"QSZ4") // Alias dos movimentos bancarios


QCTD->(dbGoTop())

while QCTD->(!eof())

	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif

	_cItemConta 	:= QCTD->CTD_ITEM

	cFor := "QSZ4->Z4_ITEMCTA == alltrim(_cItemConta)"
	IndRegua("QSZ4",CriaTrab(NIL,.F.),"Z4_ITEMCTA",,cFor,"Selecionando Registros...")

ProcRegua(QSZ4->(reccount()))
 
QSZ4->(dbgotop())

while QSZ4->(!eof())

	if alltrim(QSZ4->Z4_ITEMCTA) == alltrim(_cItemConta)

		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "  + _cItemConta + " - " + alltrim(QSZ4->Z4_COLAB))
		ProcessMessage()
	
		TRB1->ITEMCONTA := QSZ4->Z4_ITEMCTA
		TRB1->DATAMOV	:= QSZ4->Z4_DATA
		TRB1->TIPO		:= QSZ4->Z4_TAREFA
		TRB1->NUMERO	:= ""

		

		if ALLTRIM(QSZ4->Z4_TAREFA) == "CE"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->CAMPO		:= "XENGBRA"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "EE"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->CAMPO		:= "XENGBRA"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "LB"
			TRB1->ID		:= "LAB"
			TRB1->DESCRICAO	:= "LABORATORIO"
			TRB1->CAMPO		:= "XLABORA"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "PB"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->CAMPO		:= "XENGBRA"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "DT"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->CAMPO		:= "XENGBRA"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "DC"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->CAMPO		:= "XENGBRA"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "OU"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->CAMPO		:= "XENGBRA"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "DI"
			TRB1->ID		:= "IDL"
			TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
			TRB1->CAMPO		:= "XINSPDA"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "SC"
			TRB1->ID		:= "IDL"
			TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
			TRB1->CAMPO		:= "XINSPDA"
		else
			TRB1->ID		:= "CTR"
			TRB1->DESCRICAO	:= "CONTRATOS"
			TRB1->CAMPO		:= "XMOCTRA"
		endif

		if ALLTRIM(QSZ4->Z4_TAREFA) == "VD"
			nTarefa := ":Vendas"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "OP"
			nTarefa := ":Operacoes"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "LB"
			nTarefa := ":Laboratorio"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "EX"
			nTarefa := ":Expedicao"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "DT"
			nTarefa := ":Detalhamento"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "AD"
			nTarefa := ":Administracao"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "CP"
			nTarefa := ":Coordenacao de Contrato"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "CR"
			nTarefa := ":Compras"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "DC"
			nTarefa := ":Outros Documentos"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "CE"
			nTarefa := ":Coordenacao de Engenharia"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "EE"
			nTarefa := ":Estudo de Engenharia"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "PB"
			nTarefa := ":Projeto Basico"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "DI"
			nTarefa := ":Diligenciamento / Inspecao"
		elseif ALLTRIM(QSZ4->Z4_TAREFA) == "SC"
			nTarefa := ":Servico de Campo"
		elseif EMPTY(ALLTRIM(QSZ4->Z4_TAREFA))
			nTarefa := "ST:Sem Tarfa"
		else
			nTarefa := "ST:Sem Tarfa"
		endif


		TRB1->PRODUTO	:= QSZ4->Z4_IDAPTHR
		TRB1->HISTORICO	:= ALLTRIM(QSZ4->Z4_TAREFA) + nTarefa + " - " + QSZ4->Z4_COLAB
		TRB1->QUANTIDADE:= QSZ4->Z4_QTDHRS
		TRB1->UNIDADE	:= "HR"
		TRB1->VALOR		:= QSZ4->Z4_TOTVLR
		TRB1->VALOR2	:= QSZ4->Z4_TOTVLR
		TRB1->CODFORN	:= ""
		TRB1->FORNECEDOR:= ""
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= ""
		TRB1->DNATUREZA := ""
		TRB1->ORIGEM	:= "HR"
		
		//TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QSZ4->(dbskip())

enddo

QCTD->(dbskip())

enddo

QCTD->(dbclosearea())
QSZ4->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFIN01REALºAutor  ³Marcos Zanetti GZ   º Data ³  01/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa CUSTOS DIVERSOS 2				                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


static function CUDIV01REAL()

local _cQuery := ""
Local _cFilZZA := xFilial("ZZA")
Local nTarefa
local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"
local cFor 	:= ""

/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/


ZZA->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("ZZA",.F.,"QUERYZZA") // Alias dos movimentos bancarios

QCTD->(dbGoTop())

while QCTD->(!eof())

	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	
	_cItemConta 	:= QCTD->CTD_ITEM

	cFor := "alltrim(QUERYZZA->ZZA_ITEMIC) == alltrim(_cItemConta)"
	
IndRegua("QUERYZZA",CriaTrab(NIL,.F.),"ZZA_DATA",,cFor,"Selecionando Registros...")
ProcRegua(QUERYZZA->(reccount()))

QUERYZZA->(dbgotop())


while QUERYZZA->(!eof())

	if alltrim(QUERYZZA->ZZA_ITEMIC) == alltrim(_cItemConta)

		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "  + _cItemConta + " - " + alltrim(QUERYZZA->ZZA_NUM))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QUERYZZA->ZZA_DATA
		TRB1->TIPO		:= QUERYZZA->ZZA_TIPO
		TRB1->NUMERO	:= QUERYZZA->ZZA_NUM

		TRB1->ID		:= "CDV"
		TRB1->DESCRICAO	:= "CUSTOS DIVERSOS 2"

		TRB1->PRODUTO	:= ""
		TRB1->HISTORICO	:= QUERYZZA->ZZA_DESCR
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE	:= ""
		TRB1->VALOR		:= QUERYZZA->ZZA_VALOR
		TRB1->VALOR2	:= QUERYZZA->ZZA_VALOR
		TRB1->CODFORN	:= ""
		TRB1->FORNECEDOR:= ""
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= ""
		TRB1->DNATUREZA := ""
		TRB1->ORIGEM	:= "CD"
		TRB1->ITEMCONTA := QUERYZZA->ZZA_ITEMIC
		TRB1->CAMPO		:= "XCUDIVA"
		MsUnlock()

	endif

	QUERYZZA->(dbskip())

enddo
QCTD->(dbskip())

enddo

QCTD->(dbclosearea())

QUERYZZA->(dbclosearea())

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o Arquivo Sintetico                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function GC01SINT()
local _nPos 	:= 0
local _cQuery 	:= ""
local _nSaldo 	:= 0

Local nMPRVal 	:= 0
Local nMPRTot	:= 0

Local nMPRValC 	:= 0
Local nMPRTotC	:= 0

Local nMPRValE 	:= 0
Local nMPRTotE	:= 0

Local nMPRValP 	:= 0
Local nMPRTotP	:= 0

Local nMPRValV 	:= 0
Local nMPRTotV	:= 0

Local nFABVal 	:= 0
Local nFABTot	:= 0

Local nFABValC 	:= 0
Local nFABTotC	:= 0

Local nFABValE 	:= 0
Local nFABTotE	:= 0

Local nFABValV 	:= 0
Local nFABTotV	:= 0

Local nFABValP 	:= 0
Local nFABTotP	:= 0

Local nCOMVal 	:= 0
Local nCOMTot	:= 0

Local nCOMValC 	:= 0
Local nCOMTotC	:= 0

Local nCOMValE 	:= 0
Local nCOMTotE	:= 0

Local nCOMValP 	:= 0
Local nCOMTotP	:= 0

Local nCOMValV 	:= 0
Local nCOMTotV	:= 0

Local nEBRVal 	:= 0
Local nEBRTot	:= 0

Local nEBRValC 	:= 0
Local nEBRTotC	:= 0

Local nEBRValE 	:= 0
Local nEBRTotE	:= 0

Local nEBRValP 	:= 0
Local nEBRTotP	:= 0

Local nEBRValV 	:= 0
Local nEBRTotV	:= 0

Local nESLVal 	:= 0
Local nESLTot	:= 0

Local nESLValC 	:= 0
Local nESLTotC	:= 0

Local nESLValE 	:= 0
Local nESLTotE	:= 0

Local nESLValP 	:= 0
Local nESLTotP	:= 0

Local nESLValV 	:= 0
Local nESLTotV	:= 0

Local nCTRVal 	:= 0
Local nCTRTot	:= 0

Local nCTRValC 	:= 0
Local nCTRTotC	:= 0

Local nCTRValE 	:= 0
Local nCTRTotE	:= 0

Local nCTRValP 	:= 0
Local nCTRTotP	:= 0

Local nCTRValV 	:= 0
Local nCTRTotV	:= 0

Local nIDLVal 	:= 0
Local nIDLTot	:= 0

Local nIDLValC 	:= 0
Local nIDLTotC	:= 0

Local nIDLValE 	:= 0
Local nIDLTotE	:= 0

Local nIDLValP 	:= 0
Local nIDLTotP	:= 0

Local nIDLValV 	:= 0
Local nIDLTotV	:= 0

Local nLABVal 	:= 0
Local nLABTot	:= 0

Local nLABValC 	:= 0
Local nLABTotC	:= 0

Local nLABValE 	:= 0
Local nLABTotE	:= 0

Local nLABValP 	:= 0
Local nLABTotP	:= 0

Local nLABValV 	:= 0
Local nLABTotV	:= 0

Local nFINVal 	:= 0
Local nFINTot	:= 0

Local nFINValC 	:= 0
Local nFINTotC	:= 0

Local nFINValE 	:= 0
Local nFINTotE	:= 0

Local nFINValP 	:= 0
Local nFINTotP	:= 0

Local nFINValV 	:= 0
Local nFINTotV	:= 0

Local nCMSVal 	:= 0
Local nCMSTot	:= 0

Local nCMSValE 	:= 0
Local nCMSTotE	:= 0

Local nCMSValC 	:= 0
Local nCMSTotC	:= 0

Local nCMSValP 	:= 0
Local nCMSTotP	:= 0

Local nCMSValV 	:= 0
Local nCMSTotV	:= 0

Local nRDVVal 	:= 0
Local nRDVTot	:= 0

Local nRDVValC 	:= 0
Local nRDVTotC	:= 0

Local nRDVValE 	:= 0
Local nRDVTotE	:= 0

Local nRDVValP 	:= 0
Local nRDVTotP	:= 0

Local nRDVValV 	:= 0
Local nRDVTotV	:= 0

Local nFRTVal 	:= 0
Local nFRTTot	:= 0

Local nFRTValC 	:= 0
Local nFRTTotC	:= 0

Local nFRTValE 	:= 0
Local nFRTTotE	:= 0

Local nFRTValP 	:= 0
Local nFRTTotP	:= 0

Local nFRTValV 	:= 0
Local nFRTTotV	:= 0

Local nCDVVal 	:= 0
Local nCDVTot	:= 0

Local nCDVValC 	:= 0
Local nCDVTotC	:= 0

Local nCDVValE 	:= 0
Local nCDVTotE	:= 0

Local nCDVValP	:= 0
Local nCDVTotP	:= 0

Local nCDVValV	:= 0
Local nCDVTotV	:= 0

Local nSRVVal 	:= 0
Local nSRVTot	:= 0

Local nSRVValC 	:= 0
Local nSRVTotC	:= 0

Local nSRVValE 	:= 0
Local nSRVTotE	:= 0

Local nSRVValP 	:= 0
Local nSRVTotP 	:= 0

Local nSRVValV 	:= 0
Local nSRVTotV 	:= 0

Local nCPRVal	:= 0
Local nCPRTot	:= 0
Local nCTOVal	:= 0
Local nCTOTot	:= 0
Local nCTOTotC	:= 0
Local nCPRTotC	:= 0

Local nCTOTotE	:= 0
Local nCPRTotE	:= 0

Local nCTOTotP	:= 0
Local nCPRTotP	:= 0

Local nCTOTotV	:= 0
Local nCPRTotV	:= 0

Local nCPRTotR	:= 0

Local nCPRVal2	:= 0
Local nCPRTot2	:= 0
Local nCTOVal2	:= 0
Local nCTOTot2	:= 0
Local nCTOTotC2	:= 0
Local nCPRTotC2	:= 0

Local nCTOTotE2	:= 0
Local nCPRTotE2	:= 0

Local nCTOTotP2	:= 0
Local nCPRTotP2	:= 0

Local nCTOTotV2	:= 0
Local nCPRTotV2	:= 0

Local nCPRTotR2	:= 0

Local nXSISFV	:= 0
Local nXSISFR	:= 0


Local nXVDSIR	:= 0
Local nXVDSI	:= 0
Local nXCUSTO	:= 0
Local nOUTCUS1	:= 0
Local nOUTCUS2	:= 0
local cFor2 := " !ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'"
local cFor  := ""

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


 Local aInd:={}
 Local cCondicao
 Local bFiltraBrw
/************************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QCTD") // Alias dos movimentos bancarios
IndRegua("QCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXSF+CTD_XIDPM",,cFor2,"Selecionando Registros...")

ProcRegua(QCTD->(reccount()))

/************************************/


private _cOrdem := "000001"

QCTD->(dbGoTop())

while QCTD->(!eof())

	if ALLTRIM(QCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'AT'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'CM'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EN'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'EQ'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'PR'
		QCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'ST'
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QCTD->CTD_ITEM,1,2)) = 'GR'
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QCTD->CTD_ITEM,9,2) == '09'
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM < MV_PAR01
		QCTD->(dbskip())
		Loop
	endif

	if QCTD->CTD_XIDPM > MV_PAR02
		QCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QCTD->CTD_ITEM,9,2) < MV_PAR10
		QCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QCTD->CTD_ITEM,9,2)> MV_PAR11
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 1 .AND. QCTD->CTD_DTEXSF < DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QCTD->CTD_DTEXSF > DATE()
		QCTD->(dbskip())
		Loop
	endif
	
	
	_cItemConta 	:= QCTD->CTD_ITEM

	cfor := "ALLTRIM(TRB1->ITEMCONTA) == _cItemConta"
	IndRegua("TRB1",CriaTrab(NIL,.F.),"ITEMCONTA",,cFor,"Selecionando Registros...")

	//*********************** MATERIA PRIMA ********************************
	RecLock("TRB2",.T.)
	
		TRB2->ITEMCONTA	:= _cItemConta
		TRB2->ORDEM		:= _cOrdem
	
	 // VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "MPR" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nMPRValV		:= TRB1->VALOR
				nMPRTotV		+= nMPRValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XMATPRV 	:= nMPRTotV
		

	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "MPR" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nMPRValP		:= TRB1->VALOR
				nMPRTotP		+= nMPRValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XMATPRP 	:= nMPRTotP
		
	// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "MPR" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR')
				nMPRVal		:= TRB1->VALOR //SC7->C7_XTOTSI
				nMPRTot		+= nMPRVal
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		TRB2->XMATPRA 	:= nMPRTot
	
	
	//*********************** COMERCIAIS ********************************
			// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "COM" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nCOMValV		:= TRB1->VALOR
				nCOMTotV		+= nCOMValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XCOMERV 	:= nCOMTotV
	
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "COM" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nCOMValP		:= TRB1->VALOR
				nCOMTotP		+= nCOMValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XCOMERP 	:= nCOMTotP
		
	// EMPENHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if TRB1->ID == "COM" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR')
			nCOMVal		:= TRB1->VALOR //SC7->C7_XTOTSI
			nCOMTot		+= nCOMVal
		endif
		TRB1->(dbskip()) //SC7->(dbskip())
	EndDo

	TRB2->XCOMERA := nCOMTot
	
	//*********************** FABRICACAO ********************************
	// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "FAB" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nFABValV		:= TRB1->VALOR
				nFABTotV		+= nFABValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XFABRIV 	:= nFABTotV
		
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "FAB" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nFABValP		:= TRB1->VALOR
				nFABTotP		+= nFABValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XFABRIP 	:= nFABTotP
	
	// EMPENHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if TRB1->ID == "FAB" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR')
			nFABVal		:= TRB1->VALOR //SC7->C7_XTOTSI
			nFABTot		+= nFABVal
		endif
		TRB1->(dbskip()) //SC7->(dbskip())
	EndDo

	TRB2->XFABRIA := nFABTot
	
	//*********************** SERVICOS ********************************

		// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "SRV" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nSRVValV		:= TRB1->VALOR
				nSRVTotV		+= nSRVValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XSERVIV 	:= nSRVTotV
		
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "SRV" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nSRVValP		:= TRB1->VALOR
				nSRVTotP		+= nSRVValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XSERVIP 	:= nSRVTotP
		
	// EMPENHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if TRB1->ID == "SRV" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR')
			nSRVVal		:= TRB1->VALOR //SC7->·C7_XTOTSI
			nSRVTot		+= nSRVVal
		endif
		TRB1->(dbskip()) //SC7->(dbskip())
	EndDo
	TRB2->XSERVIA := nSRVTot
	
	//*********************** FRETE ********************************

	// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "FRT" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nFRTValV		:= TRB1->VALOR
				nFRTTotV		+= nFRTValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XFRETEV 	:= nFRTTotV
	
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "FRT" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nFRTValP		:= TRB1->VALOR
				nFRTTotP		+= nFRTValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XFRETEP 	:= nFRTTotP
	
	// EMPENHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if TRB1->ID == "FRT" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR')
			nFRTVal		:= TRB1->VALOR //SC7->C7_XTOTSI
			nFRTTot		+= nFRTVal
		endif
		TRB1->(dbskip()) //SC7->(dbskip())
	EndDo

	TRB2->XFRETEA := nFRTTot
	
	//*********************** ENGENHARIA BR ********************************
	// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "EBR" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nEBRValV		:= TRB1->VALOR
				nEBRTotV		+= nEBRValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XENGBRV 	:= nEBRTotV
		
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "EBR" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nEBRValP		:= TRB1->VALOR
				nEBRTotP		+= nEBRValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XENGBRP 	:= nEBRTotP
		
	// EMPENHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if alltrim(TRB1->ID) == "EBR" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('HR')
			nEBRVal		:= TRB1->VALOR //SC7->C7_XTOTSI
			nEBRTot		+= nEBRVal
		endif
		TRB1->(dbskip()) //SC7->(dbskip())
	EndDo

	TRB2->XENGBRA := nEBRTot
	

	//*********************** ENGENHARIA SLC ********************************
	// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "ESL" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nESLValV		:= TRB1->VALOR
				nESLTotV		+= nESLValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XENGSLV 	:= nESLTotV
	
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "ESL" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nESLValP		:= TRB1->VALOR
				nESLTotP		+= nESLValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XENGSLP 	:= nESLTotP
		
	// EMPENHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if alltrim(TRB1->ID) == "ESL" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR')
			nESLVal		:= TRB1->VALOR //SC7->C7_XTOTSI
			nESLTot		+= nESLVal
		endif
		TRB1->(dbskip()) //SC7->(dbskip())
	EndDo

	TRB2->XENGSLA := nESLTot

	//*********************** CONTRATOS ********************************
	
	// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "CTR" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nCTRValV		:= TRB1->VALOR
				nCTRTotV		+= nCTRValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XMOCTRV 	:= nCTRTotV
	
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "CTR" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nCTRValP		:= TRB1->VALOR
				nCTRTotP		+= nCTRValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XMOCTRP 	:= nCTRTotP

	// EMPNHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if alltrim(TRB1->ID) == "CTR" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('HR')
			nCTRVal		:= TRB1->VALOR //SC7->C7_XTOTSI
			nCTRTot		+= nCTRVal
		endif
		TRB1->(dbskip()) //SC7->(dbskip())
	EndDo

	TRB2->XMOCTRA := nCTRTot
	
	//*********************** INSPECAO / DILIGENCIAMENTO ********************
	// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "IDL" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nIDLValV		:= TRB1->VALOR
				nIDLTotV		+= nIDLValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XINSPDV 	:= nIDLTotV
		
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "IDL" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nIDLValP		:= TRB1->VALOR
				nIDLTotP		+= nIDLValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XINSPDP 	:= nIDLTotP
		
	// EMPENHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if alltrim(TRB1->ID) == "IDL" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('HR')
			nIDLVal		:= TRB1->VALOR //SC7->C7_XTOTSI
			nIDLTot		+= nIDLVal
		endif
		TRB1->(dbskip()) //SC7->(dbskip())
	EndDo

	TRB2->XINSPDA := nIDLTot
	
	//*********************** HORAS LABORATORIO ********************
	// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "LAB" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nLABValV		:= TRB1->VALOR
				nLABTotV		+= nLABValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XLABORV 	:= nLABTotV
		
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "LAB" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nLABValP		:= TRB1->VALOR
				nLABTotP		+= nLABValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XLABORP 	:= nLABTotP
		
	// EMPENHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if alltrim(TRB1->ID) == "LAB" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('HR')
			nLABVal		:= TRB1->VALOR //SC7->C7_XTOTSI
			nLABTot		+= nLABVal
		endif
		TRB1->(dbskip()) //SC7->(dbskip())
	EndDo

	TRB2->XLABORA := nLABTot
	
	//*********************** RELATORIO DE VIAGEM ********************************
	
	// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "RDV" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nRDVValV		:= TRB1->VALOR
				nRDVTotV		+= nRDVValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XRERDVV 	:= nRDVTotV
		
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "RDV" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nRDVValP		:= TRB1->VALOR
				nRDVTotP		+= nRDVValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XRERDVP 	:= nRDVTotP
		
	// EMPENHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if alltrim(TRB1->ID) == "RDV" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR')
			nRDVVal		:= TRB1->VALOR //SC7->C7_XTOTSI
			nRDVTot		+= nRDVVal
		endif
		TRB1->(dbskip()) //SC7->(dbskip())
	EndDo

	TRB2->XRERDVA := nRDVTot
	
	//*********************** CUSTOS DIVERSOS ********************************
	
	// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "CDV" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nCDVValV		:= TRB1->VALOR
				nCDVTotV		+= nCDVValV
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XCUDIVV 	:= nCDVTotV
		
	// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ID) == "CDV" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nCDVValP		:= TRB1->VALOR
				nCDVTotP		+= nCDVValP
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->XCUDIVP 	:= nCDVTotP
		
	// EMPENHADO
	TRB1->(dbgotop())
	While TRB1->( ! EOF() )
		if alltrim(TRB1->ID) == "CDV" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR/CD')
			nCDVVal		:= TRB1->VALOR //SC7->C7_XTOTSI
			nCDVTot		+= nCDVVal
		endif
		TRB1->(dbskip()) 
	EndDo

	TRB2->XCUDIVA := nCDVTot
	
		//*********************** CUSTO DE PRODUCAO******************************
	// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nCPRValV		:= TRB1->VALOR
				nCPRTotV		+= nCPRValV
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->XCUPRV		 := nCPRTotV  // nCPRTotV + (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100))
	
		// PLNAJEDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nCPRValP		:= TRB1->VALOR
				nCPRTotP		+= nCPRValP
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->XCUPRP := nCPRTotP //+ (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100))

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR/CD')
				nCPRVal		:= TRB1->VALOR  //SC7->C7_XTOTSI
				nCPRTot		+= nCPRVal
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->XCUPRA := nCPRTot
		
		
		//*********************** MARGEM BRUTA ********************************
		
		nXVDSIR	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDSIR")
		nXVDSI	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDSI")
		nXCUSTO	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSTO")
		nXSISFV	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XSISFV")
		nXSISFR	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XSISFR")
		
		// VENDIDO
		TRB2->XMGBRV	:= ((nXVDSI - nCPRTotV) / nXVDSI )*100

		// PLNAJEDO
		TRB2->XMGBRP	:= ((nXVDSIR - nCPRTotP) / nXVDSIR )*100

		// EMPENHADO
		TRB2->XMGBRA	:= ((nXVDSIR - nCPRTot) / nXVDSIR )*100
		
		//*********************** CONTINGENCIAS ********************************
		// VENDIDO
		TRB2->XOCCONV 	:= nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)
	
		// PLANEJADO
		TRB2->XOCCONP 	:= nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)
		
		// EMPENHADO
		TRB2->XOCCONA	:= 0
		
		//*********************** FIANCAS ********************************
	
		// VENDIDO
		TRB2->XOCFIAV 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)

		// PLANEJADO
		TRB2->XOCFIAP	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)
			
		// EMPENHADO
		TRB2->XOCFIAA	:= 0
		
		//*********************** CUSTO FINANCEIRO ********************************
	
		// VENDIDO
		TRB2->XOCCFIV 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)

		// PLANEJADO
		TRB2->XOCCFIP 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)

		// EMPENHADO
		TRB2->XOCCFIA	:= 0

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)
		MsUnlock()
		
		
		//*********************** GARANTIA ********************************
		// VENDIDO
		TRB2->XOCGARV 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)

		// PLANEJADO
		TRB2->XOCGARP 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)
		
		// EMPENHADO
		TRB2->XOCGARA	:= 0
		
		//*********************** PERDA IMPOSTOS ********************************
		// VENDIDO·
		TRB2->XOCPIMV 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)

		// PLANEJADO·
		TRB2->XOCPIMP 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)
				
		// EMPENHADO
		TRB2->XOCPIMA	:= 0
		
		//*********************** ROYALTY ********************************
		// VENDIDO
		TRB2->XOCROYV 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)

		// PLANEJADO
		TRB2->XOCROYP 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)
	
		// EMPENHADO
		TRB2->XOCROYA	:= 0
		
		nOUTCUS3 := (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)) + ;
				(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)) + ;
				(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)) +  (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)) 
	
	
		// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nCTOValV2		:= TRB1->VALOR  //SC7->C7_XTOTSI
				nCTOTotV2		+= nCTOValV2
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->XCOGSV := (nCTOTotV2 + nOUTCUS3)
		 
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nCTOValP2		:= TRB1->VALOR  //SC7->C7_XTOTSI
				nCTOTotP2		+= nCTOValP2
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->XCOGSP := (nCTOTotP2 + nOUTCUS3)
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			
			if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR/CD')
				nCTOTot2		+= TRB1->VALOR
			endif

			TRB1->(dbskip())
		EndDo
		TRB2->XCOGSA 	:= nCTOTot2
		
		//*********************** COMISSAO ********************************
		// VENDIDO
		TRB2->XCOMISV 	:= nXSISFV * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCOM")/100)

		// PLANEJADO
		TRB2->XCOMISP 	:= nXSISFR * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCOM")/100)

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "CMS" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR')
				nCMSVal		:= TRB1->VALOR //SC7->C7_XTOTSI
				nCMSTot		+= nCMSVal
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->XCOMISA := nCMSTot
		
		//*********************** CUSTO TOTAL ********************************
		nOUTCUS1 := (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)) + ;
				(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)) + ;
				(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)) +  (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)) + ;
				(nXVDSIR * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCOM")/100))
				
		// VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "VD"
				nCTOValV		:= TRB1->VALOR  //SC7->C7_XTOTSI
				nCTOTotV		+= nCTOValV
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->XCUTOTV := (nCTOTotV + nOUTCUS1)

		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) == "PL"
				nCTOValP		:= TRB1->VALOR  //SC7->C7_XTOTSI
				nCTOTotP		+= nCTOValP
			endif
			TRB1->(dbskip()) //SC7->(dbskip())

		EndDo

		TRB2->XCUTOTP := (nCTOTotP + nOUTCUS1)
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if ALLTRIM(TRB1->ITEMCONTA) == _cItemConta .AND. ALLTRIM(TRB1->ORIGEM) $ ('OC/DE/DR/FN/FR/HR/CD')
				nCTOTot		+= TRB1->VALOR
			endif

			TRB1->(dbskip())
		EndDo
		TRB2->XCUTOTA 	:= nCTOTot
	
	//*********************** MARGEM CONTRIBUICAO ********************************
		// VENDIDO
		TRB2->XMGCONV		:= ((nXVDSI - (nCTOTotV + nOUTCUS1)) / nXVDSI )*100
		
		// PLANEJADO
		TRB2->XMGCONP	:= ((nXVDSIR - (nCTOTotP + nOUTCUS1)) / nXVDSIR )*100
		
		// EMPENHADO
		TRB2->XMGCONA	:= ((nXVDSIR - nCTOTot) / nXVDSIR )*100
				
	//****************************************

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)

	dbSelectArea("CTD")
	CTD->( dbSetOrder(1) )
		
	If CTD->( dbSeek(xFilial("CTD")+_cItemConta) )
		RecLock("CTD",.F.)
			CTD->CTD_XACPR  := nCPRTot
			CTD->CTD_XACTO  := nCTOTot
			CTD->CTD_XCUPRR := nCPRTotP
			CTD->CTD_XCUTOR := nCTOTotP + nOUTCUS1
			CTD->CTD_XCOGSR := nCTOTotP2 + nOUTCUS3
			CTD->CTD_XCOGSV := nCTOTotV2 + nOUTCUS3
			
			CTD->CTD_XMATPR := nMPRTotP
			CTD->CTD_XCOMER := nCOMTotP
			CTD->CTD_XFABRI := nFABTotP
			CTD->CTD_XSERVI := nSRVTotP
			CTD->CTD_XFRETE := nFRTTotP
			CTD->CTD_XENGBR := nEBRTotP
			CTD->CTD_XENGSL := nESLTotP
			CTD->CTD_XMOCTR := nCTRTotP
			CTD->CTD_XINSPD := nIDLTotP
			CTD->CTD_XCUDIV := nCDVTotP
			CTD->CTD_XRERDV := nRDVTotP
			CTD->CTD_XLABOR := nLABTotP
			
			CTD->CTD_XMATPA := nMPRTot
			CTD->CTD_XCOMEA := nCOMTot
			CTD->CTD_XFABRA := nFABTot
			CTD->CTD_XSERVA := nSRVTot
			CTD->CTD_XFRETA := nFRTTot
			CTD->CTD_XENGBA := nEBRTot
			CTD->CTD_XENGSA := nESLTot
			CTD->CTD_XMOCTA := nCTRTot
			CTD->CTD_XINSPA := nIDLTot
			CTD->CTD_XCUDIA := nCDVTot
			CTD->CTD_XRERDA := nRDVTot
			CTD->CTD_XLABOA := nLABTot
	
		MsUnLock()
	endif

QCTD->(dbskip())

 nMPRVal 	:= 0
 nMPRTot	:= 0

 nMPRValC 	:= 0
 nMPRTotC	:= 0

 nMRValE 	:= 0
 nMPRTotE	:= 0

 nMPRValP	:= 0
 nMPRTotP	:= 0

 nMPRValP 	:= 0
 nMPRTotP	:= 0

 nMPRValV 	:= 0
 nMPRTotV	:= 0
 
 nCOMVal	:= 0
 nCOMTot	:= 0

 nFABVal 	:= 0
 nFABTot	:= 0

 nFABValC 	:= 0
 nFABTotC	:= 0

 nFABValE 	:= 0
 nFABTotE	:= 0

 nFABValV 	:= 0
 nFABTotV	:= 0

 nFABValP 	:= 0
 nFABTotP	:= 0

 nCOMVal 	:= 0
 nCOMTot	:= 0

 nCOMValC 	:= 0
 nCOMTotC	:= 0

 nCOMValE 	:= 0
 nCOMTotE	:= 0

 nCOMValP 	:= 0
 nCOMTotP	:= 0

 nCOMValV 	:= 0
 nCOMTotV	:= 0

 nEBRVal 	:= 0
 nEBRTot	:= 0

 nEBRValC 	:= 0
 nEBRTotC	:= 0

 nEBRValE 	:= 0
 nEBRTotE	:= 0

 nEBRValP 	:= 0
 nEBRTotP	:= 0

 nEBRValV 	:= 0
 nEBRTotV	:= 0

 nESLVal 	:= 0
 nESLTot	:= 0

 nESLValC 	:= 0
 nESLTotC	:= 0

 nESLValE 	:= 0
 nESLTotE	:= 0

 nESLValP 	:= 0
 nESLTotP	:= 0

 nESLValV 	:= 0
 nESLTotV	:= 0

 nCTRVal 	:= 0
 nCTRTot	:= 0

 nCTRValC 	:= 0
 nCTRTotC	:= 0

 nCTRValE 	:= 0
 nCTRTotE	:= 0

 nCTRValP 	:= 0
 nCTRTotP	:= 0

 nCTRValV 	:= 0
 nCTRTotV	:= 0

 nIDLVal 	:= 0
 nIDLTot	:= 0

 nIDLValC 	:= 0
 nIDLTotC	:= 0

 nIDLValE 	:= 0
 nIDLTotE	:= 0

 nIDLValP 	:= 0
 nIDLTotP	:= 0

 nIDLValV 	:= 0
 nIDLTotV	:= 0

 nLABVal 	:= 0
 nLABTot	:= 0

 nLABValC 	:= 0
 nLABTotC	:= 0

 nLABValE 	:= 0
 nLABTotE	:= 0

 nLABValP 	:= 0
 nLABTotP	:= 0

 nLABValV 	:= 0
 nLABTotV	:= 0

 nFINVal 	:= 0
 nFINTot	:= 0

 nFINValC 	:= 0
 nFINTotC	:= 0

 nFINValE 	:= 0
 nFINTotE	:= 0

 nFINValP 	:= 0
 nFINTotP	:= 0

 nFINValV 	:= 0
 nFINTotV	:= 0

 nCMSVal 	:= 0
 nCMSTot	:= 0

 nCMSValE 	:= 0
 nCMSTotE	:= 0

 nCMSValC 	:= 0
 nCMSTotC	:= 0

 nCMSValP 	:= 0
 nCMSTotP	:= 0

 nCMSValV 	:= 0
 nCMSTotV	:= 0

 nRDVVal 	:= 0
 nRDVTot	:= 0

 nRDVValC 	:= 0
 nRDVTotC	:= 0

 nRDVValE 	:= 0
 nRDVTotE	:= 0

 nRDVValP 	:= 0
 nRDVTotP	:= 0

 nRDVValV 	:= 0
 nRDVTotV	:= 0

 nFRTVal 	:= 0
 nFRTTot	:= 0

 nFRTValC 	:= 0
 nFRTTotC	:= 0

 nFRTValE 	:= 0
 nFRTTotE	:= 0

 nFRTValP 	:= 0
 nFRTTotP	:= 0

 nFRTValV 	:= 0
 nFRTTotV	:= 0

 nCDVVal 	:= 0
 nCDVTot	:= 0

 nCDVValC 	:= 0
 nCDVTotC	:= 0

 nCDVValE 	:= 0
 nCDVTotE	:= 0

 nCDVValP	:= 0
 nCDVTotP	:= 0

 nCDVValV	:= 0
 nCDVTotV	:= 0

 nSRVVal 	:= 0
 nSRVTot	:= 0

 nSRVValC 	:= 0
 nSRVTotC	:= 0

 nSRVValE 	:= 0
 nSRVTotE	:= 0

 nSRVValP 	:= 0
 nSRVTotP 	:= 0

 nSRVValV 	:= 0
 nSRVTotV 	:= 0

 nCPRVal	:= 0
 nCPRTot	:= 0
 nCTOVal	:= 0
 nCTOTot	:= 0
 nCTOTotC	:= 0
 nCPRTotC	:= 0

 nCTOTotE	:= 0
 nCPRTotE	:= 0

 nCTOTotP	:= 0
 nCPRTotP	:= 0

 nCTOTotV	:= 0
 nCPRTotV	:= 0

 nCPRTotR	:= 0
 nCPRVal2	:= 0
 nCPRTot2	:= 0
 nCTOVal2	:= 0
 nCTOTot2	:= 0
 nCTOTotC2	:= 0
 nCPRTotC2	:= 0

 nCTOTotE2	:= 0
 nCPRTotE2	:= 0

 nCTOTotP2	:= 0
 nCPRTotP2	:= 0

 nCTOTotV2	:= 0
 nCPRTotV2	:= 0

 nCPRTotR2	:= 0

enddo
IndRegua("TRB1",CriaTrab(NIL,.F.),"ITEMCONTA",,,"Selecionando Registros...")
QCTD->(dbclosearea())
// Gravacao de uma linha para movimentos sem natureza ou grupo de naturezas


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta a tela de visualizacao do Fluxo Sintetico            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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


cCadastro :=  "Gestao de Contratos - Sintético - Custos " 

AADD( aRotina, {"Pesquisar" ,"AxPesqui" ,0,1})

// Monta aHeader do TRB2
//aadd(aHeader, {"OK","OK","",01,0,"","","C","TRB2","R","","",".F.","V"})

aAdd(aHeader,{" Contrato "				,"ITEMCONTA"	,""					,13,0,"","","D","TRB1","R"}) // Contrato

aAdd(aHeader,{"(V) Materia Prima"		,"XMATPRV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // materia prima
aAdd(aHeader,{"(P) Materia Prima"		,"XMATPRP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // materia prima
aAdd(aHeader,{"(E) Materia Prima"	,"XMATPRA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // materia prima

aAdd(aHeader,{"(V) Comerciais "				,"XCOMERV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // comerciais
aAdd(aHeader,{"(P) Comerciais "				,"XCOMERP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // comerciais
aAdd(aHeader,{"(E) Comerciais "				,"XCOMERA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // comerciais

aAdd(aHeader,{"(V) Fabricação "				,"XFABRIV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // fabricacao
aAdd(aHeader,{"(P) Fabricação "				,"XFABRIP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // fabricacao
aAdd(aHeader,{"(E) Fabricação "				,"XFABRIA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // fabricacao

aAdd(aHeader,{"(V) Serviços "				,"XSERVIV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // servicos
aAdd(aHeader,{"(P) Serviços "				,"XSERVIP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // servicos
aAdd(aHeader,{"(E) Serviços "				,"XSERVIA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // servicos

aAdd(aHeader,{"(V) Frete "					,"XFRETEV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // frete
aAdd(aHeader,{"(P) Frete "					,"XFRETEP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // frete
aAdd(aHeader,{"(E) Frete "					,"XFRETEA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // frete

aAdd(aHeader,{"(V) Engenharia BR"			,"XENGBRV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // engenharia br
aAdd(aHeader,{"(P) Engenharia BR"			,"XENGBRP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // engenharia br
aAdd(aHeader,{"(E) Engenharia BR"			,"XENGBRA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // engenharia br

aAdd(aHeader,{"(V) Engenharia SLC"			,"XENGSLV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // engenharia slc
aAdd(aHeader,{"(P) Engenharia SLC"			,"XENGSLP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // engenharia slc
aAdd(aHeader,{"(E) Engenharia SLC"			,"XENGSLA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // engenharia slc

aAdd(aHeader,{"(V) Contratos"				,"XMOCTRV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // mao de obra contratos
aAdd(aHeader,{"(P) Contratos"				,"XMOCTRP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // mao de obra contratos
aAdd(aHeader,{"(E) Contratos"				,"XMOCTRA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // mao de obra contratos

aAdd(aHeader,{"(V) Inspec./Dilig."			,"XINSPDV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // mao de obra inspecao / dilig.
aAdd(aHeader,{"(P) Inspec./Dilig."			,"XINSPDP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // mao de obra inspecao / dilig.
aAdd(aHeader,{"(E) Inspec./Dilig."			,"XINSPDA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // mao de obra inspecao / dilig.

aAdd(aHeader,{"(V) Laboratorio"				,"XLABORV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // mao de obra laboratorio
aAdd(aHeader,{"(P) Laboratorio"				,"XLABORP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // mao de obra laboratorio
aAdd(aHeader,{"(E) Laboratorio"				,"XLABORA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // mao de obra laboratorio

aAdd(aHeader,{"(V) Rel.Despesas"			,"XRERDVV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // relatorio de viagem
aAdd(aHeader,{"(P) Rel.Despesas"			,"XRERDVP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // relatorio de viagem
aAdd(aHeader,{"(E) Rel.Despesas"			,"XRERDVA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // relatorio de viagem

aAdd(aHeader,{"(V) Custos Diversos"			,"XCUDIVV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // custos diversos
aAdd(aHeader,{"(P) Custos Diversos"			,"XCUDIVP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // custos diversos
aAdd(aHeader,{"(E) Custos Diversos"			,"XCUDIVA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // custos diversos


aAdd(aHeader,{"(V) Custo de Produção"		,"XCUPRV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // custo de producao
aAdd(aHeader,{"(P) Custo de Produção"		,"XCUPRP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // custo de producao
aAdd(aHeader,{"(E) Custo de Produção"		,"XCUPRA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // custo de producao

aAdd(aHeader,{"(V) % Margem Bruta"			,"XMGBRV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // margem bruta
aAdd(aHeader,{"(P) % Margem Bruta"			,"XMGBRP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // margem bruta
aAdd(aHeader,{"(E) % Margem Bruta"			,"XMGBRA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // margem bruta

aAdd(aHeader,{"(V) Contingências"			,"XOCCONV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos contigencias
aAdd(aHeader,{"(P) Contingências"			,"XOCCONP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos contigencias
aAdd(aHeader,{"(E) Contingências"			,"XOCCONA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos contigencias

aAdd(aHeader,{"(V) Fianças"					,"XOCFIAV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos fiancas
aAdd(aHeader,{"(P) Fianças"					,"XOCFIAP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos fiancas
aAdd(aHeader,{"(E) Fianças"					,"XOCFIAA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos fiancas

aAdd(aHeader,{"(V) Custo Financeiro"		,"XOCCFIV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos financeiro
aAdd(aHeader,{"(P) Custo Financeiro"		,"XOCCFIP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos financeiro
aAdd(aHeader,{"(E) Custo Financeiro"		,"XOCCFIA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos financeiro

aAdd(aHeader,{"(V) Garantia"				,"XOCGARV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos garantia
aAdd(aHeader,{"(P) Garantia"				,"XOCGARP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos garantia
aAdd(aHeader,{"(E) Garantia"				,"XOCGARA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos garantia

aAdd(aHeader,{"(V) Perda Impostos"			,"XOCPIMV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos perda de impostos
aAdd(aHeader,{"(P) Perda Impostos"			,"XOCPIMP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos perda de impostos
aAdd(aHeader,{"(E) Perda Impostos"			,"XOCPIMA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos perda de impostos

aAdd(aHeader,{"(V) Royalty"					,"XOCROYV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos royalty
aAdd(aHeader,{"(P) Royalty"					,"XOCROYP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos royalty
aAdd(aHeader,{"(E) Royalty"					,"XOCROYA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos royalty

aAdd(aHeader,{"(V) COGS"					,"XCOGSV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // cogs
aAdd(aHeader,{"(P) COGS"					,"XCOGSP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // cogs
aAdd(aHeader,{"(E) COGS"					,"XCOGSA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // cogs

aAdd(aHeader,{"(V) Comissão"				,"XCOMISV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos comissao
aAdd(aHeader,{"(P) Comissão"				,"XCOMISP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos comissao
aAdd(aHeader,{"(E) Comissão"				,"XCOMISA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // outros custos comissao

aAdd(aHeader,{"(V) Custo Total"				,"XCUTOTV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // custo total
aAdd(aHeader,{"(P) Custo Total"				,"XCUTOTP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // custo total
aAdd(aHeader,{"(E) Custo Total"				,"XCUTOTA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // custo total

aAdd(aHeader,{"(V) % Margem Contrib."		,"XMGCONV"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // margem de contribuicao
aAdd(aHeader,{"(P) % Margem Contrib."			,"XMGCONP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // margem de contribuicao
aAdd(aHeader,{"(E) % Margem Contrib."			,"XMGCONA"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"}) // margem de contribuicao
aadd(aHeader,{"ID"						,"ID"			,""					,05,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgSint ;
TITLE "Gestao de Contratos - Sintético - "  ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-20,aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2")
//_oGetDbSint2 := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2")

_oGetDbSint:oBrowse:bLClicked := {|| msginfo("bHeaderClick") }

_oGetDbSint:oBrowse:BlDblClick := 	{|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ColPos(),2],aheader[_oGetDbSint:oBrowse:ColPos(),1])  , _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()  }

// COR DA FONTE
//_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
// COR DA LINHA
//_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| fTrocaCor(2)}
//_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha

//_oGetDbSint:oBrowse:BlDblClick := {|| ContabilCusto(aheader[_oGetDbSint:oBrowse:ColPos(),2],aheader[_oGetDbSint:oBrowse:ColPos(),1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

nPos := aPosObj[1,3]+5

@ nPos , 0020 Say "LEGENDA: (V) Vendido / (P) Planejado / (E) - Empenhado  "  COLORS 0, 16777215 PIXEL

aadd(aButton , { "BMPTABLE" , { || zExpExcGC01()}, "Gerar Plan. Excel " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return

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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre os arquivos necessarios                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function ShowAnalit(_cCampo)
local cFiltra 	:= ""


private aRotina := {{"Pesquisar" ,"AxPesqui" ,0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Gestao de Contratos - Analítico - Custos " 

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra :=  " alltrim(CAMPO) == '" + alltrim(_cCampo) + "' .and. TRB1->ITEMCONTA == '" + TRB2->ITEMCONTA + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB1
aadd(aHeader, {"Data"			,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Origem"			,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Tipo"			,"TIPO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Numero"			,"NUMERO"	,"",15,0,"","","C","TRB1","R"})
aadd(aHeader, {"Produto"		,"Produto"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Histórico"		,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Quantidade"		,"QUANTIDADE","@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Unid."			,"UNIDADE","",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Vlr.s/Tributos"	,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Vlr.c/Tributos"	,"VALOR2","@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Cod.Forn."		,"CODFORN","",15,0,"","","C","TRB1","R"})
aadd(aHeader, {"Fornecedor"		,"FORNECEDOR","",60,0,"","","C","TRB1","R"})
aadd(aHeader, {"CFOP"			,"CFOP","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Natureza"		,"NATUREZA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descricao Natureza"	,"DNATUREZA","",60,0,"","","C","TRB1","R"})
aadd(aHeader, {"Item Conta"		,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"ID"				,"ID"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descrição ID"	,"DESCRICAO","",40,0,"","","C","TRB1","R"})
aadd(aHeader, {"Campo"			,"CAMPO"		,"",10,0,"","","C","TRB1","R"})

//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Gestao de Contratos - Analítico - "  From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas  "  COLORS 0, 16777215 PIXEL


aadd(aButton , { "BMPTABLE" , { || zExpExcGC2()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE" , { || PRNGCdet()}, "Imprimir " } )


ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre os arquivos necessarios                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function AbreArq()
local aStru 	:= {}

local _cCpoAtu
local _ni

if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Não foi possível abrir o arquivo GCIN01.XLS pois ele pode estar aberto por outro usuário.")
	return(.F.)
endif

// monta arquivo analitico TRB1

aAdd(aStru,{"DATAMOV"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"TIPO"	,"C",03,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)


aAdd(aStru,{"NUMERO"	,"C",15,0}) // Data de movimentacao
aAdd(aStru,{"PRODUTO"	,"C",30,0}) // Historico
aAdd(aStru,{"HISTORICO"	,"C",120,0}) // Historico
aAdd(aStru,{"QUANTIDADE","N",15,2}) // Data de movimentacao
aAdd(aStru,{"UNIDADE","C",02,0}) // Data de movimentacao
aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
aAdd(aStru,{"VALOR2"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"ITEMCONTA"	,"C",13,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"CODFORN"	,"C",15,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"FORNECEDOR","C",60,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"CFOP"		,"C",13,0})
aAdd(aStru,{"NATUREZA"	,"C",13,0})
aAdd(aStru,{"DNATUREZA"	,"C",40,0})
aAdd(aStru,{"ID"		,"C",03,0}) // Historico
aAdd(aStru,{"DESCRICAO"	,"C",20,0}) // Historico
aAdd(aStru,{"CAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico
aAdd(aStru,{"SIMULADO"	,"C",01,0}) // Indica se o registro foi gerado por uma simulacao

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)

//***************************************************************
aStru := {}
//aAdd(aStru,{"OK"		,"C",01,0}) // Descricao da Natureza
aAdd(aStru,{"ITEMCONTA"	,"C",13,0}) // Contrato

aAdd(aStru,{"XMATPRV"	,"N",15,2}) // materia prima
aAdd(aStru,{"XCOMERV"	,"N",15,2}) // comerciais
aAdd(aStru,{"XFABRIV"	,"N",15,2}) // fabricacao
aAdd(aStru,{"XSERVIV"	,"N",15,2}) // servicos
aAdd(aStru,{"XFRETEV"	,"N",15,2}) // frete
aAdd(aStru,{"XENGBRV"	,"N",15,2}) // engenharia br
aAdd(aStru,{"XENGSLV"	,"N",15,2}) // engenharia slc
aAdd(aStru,{"XMOCTRV"	,"N",15,2}) // mao de obra contratos
aAdd(aStru,{"XINSPDV"	,"N",15,2}) // mao de obra inspecao / dilig.
aAdd(aStru,{"XLABORV"	,"N",15,2}) // mao de obra laboratorio
aAdd(aStru,{"XRERDVV"	,"N",15,2}) // relatorio de viagem
aAdd(aStru,{"XCUDIVV"	,"N",15,2}) // custos diversos
aAdd(aStru,{"XCUPRV"	,"N",15,2}) // custo de producao
aAdd(aStru,{"XMGBRV"	,"N",15,2}) // margem bruta
aAdd(aStru,{"XOCCONV"	,"N",15,2}) // outros custos contigencias
aAdd(aStru,{"XOCFIAV"	,"N",15,2}) // outros custos fiancas
aAdd(aStru,{"XOCCFIV"	,"N",15,2}) // outros custos financeiro
aAdd(aStru,{"XOCGARV"	,"N",15,2}) // outros custos garantia
aAdd(aStru,{"XOCPIMV"	,"N",15,2}) // outros custos perda de impostos
aAdd(aStru,{"XOCROYV"	,"N",15,2}) // outros custos royalty
aAdd(aStru,{"XCOGSV"	,"N",15,2}) // cogs
aAdd(aStru,{"XCOMISV"	,"N",15,2}) // outros custos comissao
aAdd(aStru,{"XCUTOTV"	,"N",15,2}) // custo total
aAdd(aStru,{"XMGCONV"	,"N",15,2}) // margem de contribuicao

aAdd(aStru,{"XMATPRP"	,"N",15,2}) // materia prima
aAdd(aStru,{"XCOMERP"	,"N",15,2}) // comerciais
aAdd(aStru,{"XFABRIP"	,"N",15,2}) // fabricacao
aAdd(aStru,{"XSERVIP"	,"N",15,2}) // servicos
aAdd(aStru,{"XFRETEP"	,"N",15,2}) // frete
aAdd(aStru,{"XENGBRP"	,"N",15,2}) // engenharia br
aAdd(aStru,{"XENGSLP"	,"N",15,2}) // engenharia slc
aAdd(aStru,{"XMOCTRP"	,"N",15,2}) // mao de obra contratos
aAdd(aStru,{"XINSPDP"	,"N",15,2}) // mao de obra inspecao / dilig.
aAdd(aStru,{"XLABORP"	,"N",15,2}) // mao de obra laboratorio
aAdd(aStru,{"XRERDVP"	,"N",15,2}) // relatorio de viagem
aAdd(aStru,{"XCUDIVP"	,"N",15,2}) // custos diversos
aAdd(aStru,{"XCUPRP"	,"N",15,2}) // custo de producao
aAdd(aStru,{"XMGBRP"	,"N",15,2}) // margem bruta
aAdd(aStru,{"XOCCONP"	,"N",15,2}) // outros custos contigencias
aAdd(aStru,{"XOCFIAP"	,"N",15,2}) // outros custos fiancas
aAdd(aStru,{"XOCCFIP"	,"N",15,2}) // outros custos financeiro
aAdd(aStru,{"XOCGARP"	,"N",15,2}) // outros custos garantia
aAdd(aStru,{"XOCPIMP"	,"N",15,2}) // outros custos perda de impostos
aAdd(aStru,{"XOCROYP"	,"N",15,2}) // outros custos royalty
aAdd(aStru,{"XCOGSP"	,"N",15,2}) // cogs
aAdd(aStru,{"XCOMISP"	,"N",15,2}) // outros custos comissao
aAdd(aStru,{"XCUTOTP"	,"N",15,2}) // custo total
aAdd(aStru,{"XMGCONP"	,"N",15,2}) // margem de contribuicao

aAdd(aStru,{"XMATPRA"	,"N",15,2}) // materia prima
aAdd(aStru,{"XCOMERA"	,"N",15,2}) // comerciais
aAdd(aStru,{"XFABRIA"	,"N",15,2}) // fabricacao
aAdd(aStru,{"XSERVIA"	,"N",15,2}) // servicos
aAdd(aStru,{"XFRETEA"	,"N",15,2}) // frete
aAdd(aStru,{"XENGBRA"	,"N",15,2}) // engenharia br
aAdd(aStru,{"XENGSLA"	,"N",15,2}) // engenharia slc
aAdd(aStru,{"XMOCTRA"	,"N",15,2}) // mao de obra contratos
aAdd(aStru,{"XINSPDA"	,"N",15,2}) // mao de obra inspecao / dilig.
aAdd(aStru,{"XLABORA"	,"N",15,2}) // mao de obra laboratorio
aAdd(aStru,{"XRERDVA"	,"N",15,2}) // relatorio de viagem
aAdd(aStru,{"XCUDIVA"	,"N",15,2}) // custos diversos
aAdd(aStru,{"XCUPRA"	,"N",15,2}) // custo de producao
aAdd(aStru,{"XMGBRA"	,"N",15,2}) // margem bruta
aAdd(aStru,{"XOCCONA"	,"N",15,2}) // outros custos contigencias
aAdd(aStru,{"XOCFIAA"	,"N",15,2}) // outros custos fiancas
aAdd(aStru,{"XOCCFIA"	,"N",15,2}) // outros custos financeiro
aAdd(aStru,{"XOCGARA"	,"N",15,2}) // outros custos garantia
aAdd(aStru,{"XOCPIMA"	,"N",15,2}) // outros custos perda de impostos
aAdd(aStru,{"XOCROYA"	,"N",15,2}) // outros custos royalty
aAdd(aStru,{"XCOGSA"	,"N",15,2}) // cogs
aAdd(aStru,{"XCOMISA"	,"N",15,2}) // outros custos comissao
aAdd(aStru,{"XCUTOTA"	,"N",15,2}) // custo total
aAdd(aStru,{"XMGCONA"	,"N",15,2}) // margem de contribuicao
aAdd(aStru,{"ID"		,"C",5,0}) // id registro
aAdd(aStru,{"ORDEM"		,"C",10,0}) // Ordem de apresentacao



dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)

aAdd(_aCpos,"ITEMCONTA") 		// Contrato

aAdd(_aCpos,"XMATPRV") 			// materia prima
aAdd(_aCpos,"XCOMERV") 			// comerciais
aAdd(_aCpos,"XFABRIV") 			// fabricacao
aAdd(_aCpos,"XSERVIV") 			// servicos
aAdd(_aCpos,"XFRETEV") 			// frete
aAdd(_aCpos,"XENGBRV") 			// engenharia br
aAdd(_aCpos,"XENGSLV")			// engenharia slc
aAdd(_aCpos,"XMOCTRV") 			// mao de obra contratos
aAdd(_aCpos,"XINSPDV") 			// mao de obra inspecao / dilig.
aAdd(_aCpos,"XLABORV") 			// mao de obra laboratorio
aAdd(_aCpos,"XRERDVV") 			// relatorio de viagem
aAdd(_aCpos,"XCUDIVV") 			// custos diversos
aAdd(_aCpos,"XCUPRV") 			// custo de producao
aAdd(_aCpos,"XMGBRV") 			// margem bruta
aAdd(_aCpos,"XOCCONV") 			// outros custos contigencias
aAdd(_aCpos,"XOCFIAV") 			// outros custos fiancas
aAdd(_aCpos,"XOCCFIV") 			// outros custos financeiro
aAdd(_aCpos,"XOCGARV") 			// outros custos garantia
aAdd(_aCpos,"XOCPIMV") 			// outros custos perda de impostos
aAdd(_aCpos,"XOCROYV") 			// outros custos royalty
aAdd(_aCpos,"XCOGSV") 			// cogs
aAdd(_aCpos,"XCOMISV") 			// outros custos comissao
aAdd(_aCpos,"XCUTOTV") 			// custo total
aAdd(_aCpos,"XMGCONV") 			// margem de contribuicao

aAdd(_aCpos,"XMATPRP") 			// materia prima
aAdd(_aCpos,"XCOMERP") 			// comerciais
aAdd(_aCpos,"XFABRIP") 			// fabricacao
aAdd(_aCpos,"XSERVIP") 			// servicos
aAdd(_aCpos,"XFRETEP") 			// frete
aAdd(_aCpos,"XENGBRP") 			// engenharia br
aAdd(_aCpos,"XENGSLP")			// engenharia slc
aAdd(_aCpos,"XMOCTRP") 			// mao de obra contratos
aAdd(_aCpos,"XINSPDP") 			// mao de obra inspecao / dilig.
aAdd(_aCpos,"XLABORP") 			// mao de obra laboratorio
aAdd(_aCpos,"XRERDVP") 			// relatorio de viagem
aAdd(_aCpos,"XCUDIVP") 			// custos diversos
aAdd(_aCpos,"XCUPRP") 			// custo de producao
aAdd(_aCpos,"XMGBRP") 			// margem bruta
aAdd(_aCpos,"XOCCONP") 			// outros custos contigencias
aAdd(_aCpos,"XOCFIAP") 			// outros custos fiancas
aAdd(_aCpos,"XOCCFIP") 			// outros custos financeiro
aAdd(_aCpos,"XOCGARP") 			// outros custos garantia
aAdd(_aCpos,"XOCPIMP") 			// outros custos perda de impostos
aAdd(_aCpos,"XOCROYP") 			// outros custos royalty
aAdd(_aCpos,"XCOGSP") 			// cogs
aAdd(_aCpos,"XCOMISP") 			// outros custos comissao
aAdd(_aCpos,"XCUTOTP") 			// custo total
aAdd(_aCpos,"XMGCONP") 			// margem de contribuicao

aAdd(_aCpos,"XMATPRA") 			// materia prima
aAdd(_aCpos,"XCOMERA") 			// comerciais
aAdd(_aCpos,"XFABRIA") 			// fabricacao
aAdd(_aCpos,"XSERVIA") 			// servicos
aAdd(_aCpos,"XFRETEA") 			// frete
aAdd(_aCpos,"XENGBRA") 			// engenharia br
aAdd(_aCpos,"XENGSLA") 			// engenharia slc
aAdd(_aCpos,"XMOCTRA") 			// mao de obra contratos
aAdd(_aCpos,"XINSPDA") 			// mao de obra inspecao / dilig.
aAdd(_aCpos,"XLABORA") 			// mao de obra laboratorio
aAdd(_aCpos,"XRERDVA") 			// relatorio de viagem
aAdd(_aCpos,"XCUDIVA") 			// custos diversos
aAdd(_aCpos,"XCUPRA") 			// custo de producao
aAdd(_aCpos,"XMGBRA") 			// margem bruta
aAdd(_aCpos,"XOCCONA") // outros custos contigencias
aAdd(_aCpos,"XOCFIAA") // outros custos fiancas
aAdd(_aCpos,"XOCCFIA") // outros custos financeiro
aAdd(_aCpos,"XOCGARA") // outros custos garantia
aAdd(_aCpos,"XOCPIMA") // outros custos perda de impostos
aAdd(_aCpos,"XOCROYA") // outros custos royalty
aAdd(_aCpos,"XCOGSA") // cogs
aAdd(_aCpos,"XCOMISA") // outros custos comissao
aAdd(_aCpos,"XCUTOTA") // custo total
aAdd(_aCpos,"XMGCONA") // margem de contribuicao
aAdd(_aCpos,"ID") // id registro

_nCampos := len(_aCpos)

index on ORDEM to &(cArqTrb2+"2")
index on ORDEM to &(cArqTrb2+"1")


set index to &(cArqTrb2+"1")

index on ORDEM to &(cArqTrb1+"1")
set index to &(cArqTrb1+"1")

return(.T.)




static function VldParam()

/*
if empty(_dDataIni) .or. empty(_dDataFim) .or. empty(_dDtRef) // Alguma data vazia
	msgstop("Todas as datas dos parâmetros devem ser informadas.")
	return(.F.)
endif

if _dDataIni > _dDtRef // Data de inicio maior que data de referencia
	msgstop("A data de início do processamento deve ser menor ou igual a data de referência.")
	return(.F.)
endif

if _dDataFim < _dDtRef // Data de fim menor que data de referencia
	msgstop("A data de final do processamento deve ser maior ou igual a data de referência.")
	return(.F.)
endif
*/
return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ABREDOC   ºAutor  ³Marcos Zanetti G&Z  º Data ³  01/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre o XLS com os dados do fluxo de caixa                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function AbreDoc( _cFile )
LOCAL cDrive     := ""
LOCAL cDir       := ""

cTempPath := "C:\"
cPathTerm := cTempPath + _cFile

ferase(cTempPath + _cFile)

If CpyS2T( "\SIGAADV\"+_cFile, cTempPath, .T. )
	SplitPath(cPathTerm, @cDrive, @cDir )
	cDir := Alltrim(cDrive) + Alltrim(cDir)
	nRet := ShellExecute( "Open" , cPathTerm ,"", cDir , 3 )
else
	MsgStop("Ocorreram problemas na cópia do arquivo.")
endif

return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao Resumo Custos de Contrato		                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PRNGCRes()


Local nn

Private aPerg :={}
Private cPerg := "PrintGCRes"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa


Processa({|lEnd|MontaRel(),"Imprimindo Resumo Custos de Contrato","AGUARDE.."})

Return Nil


//********************************************************************************************

//************* Estrutura Planejamento ********************

static function zEstruPLN()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Custo de Contratos"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"GCIN01"
private _cArq	:= 	"GCIN01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cItemConta := CTD->CTD_ITEM
private _cFilial 	:= ALLTRIM(CTD->CTD_FILIAL)

private _cNProp
private _cCodCoord
private _cNomCoord

private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)
private cArqTrb4 := CriaTrab(NIL,.F.)


Private _aGrpSint:= {}

//ValidPerg()

//FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
//if nOpcA == 1

	_cItemConta 	:= CTD->CTD_ITEM
	
	dbSelectArea("SZC")
	dbSetOrder(2)
	//SET FILTER TO alltrim(SZC->ZC_ITEMIC) = '_cItemConta'
	
	dbSelectArea("SZD")
	dbSetOrder(3)
	//SET FILTER TO alltrim(SZD->ZD_ITEMIC) = '_cItemConta'
	
	dbSelectArea("SZO")
	dbSetOrder(4)
	//SET FILTER TO alltrim(SZO->ZO_ITEMIC) = '_cItemConta'
	
	dbSelectArea("SZU")
	dbSetOrder(2)
	//SET FILTER TO alltrim(SZU->ZU_ITEMIC) = '_cItemConta'


	MntEstru()

//endif


return


static function MntEstru()
//Local oGet1
Local oGet1 := Space(13)
Local nposi

Local IMAGE1 := "FOLDER5"
Local IMAGE2 := "FOLDER6"
Local IMAGE3 := "FOLDER7"
Local aNodes := {}

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

private _cItemConta := CTD->CTD_ITEM
private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ]+78, aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oDlgSint

	cCadastro :=  "Gestao de Contratos - Planejamento - " + _cItemConta

	DEFINE MSDIALOG _oDlgSint ;
	TITLE "Gestao de Contratos - Sintético - " + _cItemConta ;
	From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"
	
	// Cria a Tree
	
	oTree := DbTree():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],_oDlgSint,,,.T.)
	nX0 := 0
	nX1 := 1
	nX2 := 2
	nX3 := 3
	nX4 := 4
	aadd(aNodes,{cValToChar(nX0),cValtoChar(nX1),"",AllTrim(_cItemConta)+SPACE(40),IMAGE1,IMAGE2})  
	
	nX0++
	nX1++
	
	//msginfo( cValToChar(nX0) )
	//msginfo( cValToChar(nX1) )
	
	dbSelectArea("SZC")
	dbSetOrder(2)
	
	dbSelectArea("SZD")
	dbSetOrder(3)
		
	dbSelectArea("SZO")
	dbSetOrder(4)
	
	dbSelectArea("SZU")
	dbSetOrder(2)
	
	
	SZC->(dbgotop())
	
	//msginfo( cValToChar(nX0) )
	//msginfo( cValToChar(nX1) )
	
	If SZC->(dbSeek(_cItemConta)) //********
	
	While SZC->(!eof()) .AND. ALLTRIM(SZC->ZC_ITEMIC) == alltrim(_cItemConta)
		
		if ALLTRIM(SZC->ZC_ITEMIC) == alltrim(_cItemConta)	
			
			
			cIDPlan := alltrim(SZC->ZC_IDPLAN)
			
			//msginfo( "nivel 2: " +  cValToChar(nX0) + " - " + cIDPlan + " " + _cItemConta )
			//msginfo( "nivel 2: " + cValToChar(nX1)  + " - " + cIDPlan + " " + _cItemConta )
			
			aadd(aNodes,{cValToChar(nX0),cValtoChar(nX1),"",ALLTRIM(SZC->ZC_DESCRI) ;
			+ SPACE(40 - LEN(ALLTRIM(SZC->ZC_DESCRI)) ) ;
			+ space(20) ;
			+ "Total.: " + alltrim(transform(SZC->ZC_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2}) 
			nX1++
			
			
			SZD->(dbgotop())
			
			If SZD->(dbSeek(_cItemConta)) //********
				
			While SZD->(!eof()) .AND. ALLTRIM(SZD->ZD_ITEMIC) == alltrim(_cItemConta)
			
				if ALLTRIM(SZD->ZD_ITEMIC) == ALLTRIM(_cItemConta) .AND. ALLTRIM(SZD->ZD_IDPLAN) == alltrim(cIDPlan) 
					//msginfo( "nivel 3: " +  cValToChar(nX2)  + " - " + cIDPlan + " " + _cItemConta  )
					//msginfo( "nivel 3: " + cValToChar(nX1)  + " - " + cIDPlan + " " + _cItemConta  )
					
					cIDPLSUB := alltrim(SZD->ZD_IDPLSUB)
					aadd(aNodes,{cValToChar(nX2),cValtoChar(nX1),"",alltrim(SZD->ZD_DESCRI) ;
					+ SPACE(40 - LEN(ALLTRIM(SZD->ZD_DESCRI)) ) ;
					+ space(20) ;
					+ "Total.: " + alltrim(transform(SZD->ZD_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2})  
					nX1++
					
					//***************************
					
					SZO->(dbgotop())
					If SZO->(dbSeek(_cItemConta)) //********
					
					While SZO->(!eof()) .AND. ALLTRIM(SZO->ZO_ITEMIC) == alltrim(_cItemConta)
					 
						if ALLTRIM(SZO->ZO_ITEMIC) == ALLTRIM(_cItemConta) .AND. ALLTRIM(SZO->ZO_IDPLSUB) == alltrim(cIDPLSUB) 
							
							//msginfo( "nivel 4: " +  cValToChar(nX3)  + " - " + cIDPLSUB + " " + _cItemConta  )
							//msginfo( "nivel 4: " + cValToChar(nX1)  + " - " + cIDPLSUB + " " + _cItemConta  )
							
							cIDPLSB2 := alltrim(SZO->ZO_IDPLSB2)
							aadd(aNodes,{cValToChar(nX3),cValtoChar(nX1),"",ALLTRIM(SZO->ZO_DESCRI);
							+ SPACE(40 - LEN(ALLTRIM(SZO->ZO_DESCRI)) ) ;
							+ space(20) ;
							+ "Total.: " + alltrim(transform(SZO->ZO_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2}) 
							nX1++
							
							//**************************
							dbSelectArea("SZU")
							dbSetOrder(1)
							
							
							SZU->(dbgotop())
							If SZU->(dbSeek(_cItemConta)) //********
							
							While SZU->(!eof()) .AND. ALLTRIM(SZU->ZU_ITEMIC) == alltrim(_cItemConta)
							
								if ALLTRIM(SZU->ZU_ITEMIC) == ALLTRIM(_cItemConta) .AND. ALLTRIM(SZU->ZU_IDPLSB2) == alltrim(cIDPLSB2) 
								
									//msginfo( "nivel 5: " +  cValToChar(nX4)  + " - " + cIDPLSB2 + " " + _cItemConta  )
									//msginfo( "nivel 5: " + cValToChar(nX1)  + " - " + cIDPLSB2 + " " + _cItemConta  )
								
									aadd(aNodes,{cValToChar(nX4),cValtoChar(nX1),"",ALLTRIM(SZU->ZU_DESCRI);
									+ SPACE(40 - LEN(ALLTRIM(SZU->ZU_DESCRI)) ) ;
									+ space(20) ;
									+ "Total.: " + alltrim(transform(SZU->ZU_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2}) 
									nX1++
									
								endif
								SZU->(dbSkip())
							enddo
							
							ENDIF
							///******************************
						endif
						SZO->(dbSkip())
					enddo
					
					ENDIF
					//****************************
				endif
				SZD->(dbSkip())
			enddo
			ENDIF
			
			
		endif
		SZC->(dbSkip())
		
	enddo
	
	ENDIF //*****
	oTree:PTSendTree( aNodes )


oGroup1:= TGroup():New(0029,0015,0053,0730,'',_oDlgSint,,,.T.)
oGroup2:= TGroup():New(0054,0015,0080,0345,'Venda',_oDlgSint,,,.T.)
oGroup3:= TGroup():New(0054,0350,0080,0730,'Venda Revisado',_oDlgSint,,,.T.)

oGroup4:= TGroup():New(0081,0015,0110,0345,'Custo Vendido',_oDlgSint,,,.T.)
oGroup5:= TGroup():New(0081,0350,0110,0730,'Custo Revisado',_oDlgSint,,,.T.)

@ 0030,0020 Say  "Item Conta: " COLORS 0, 16777215 PIXEL
@ 0038,0020 MSGET  _cItemConta  COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0120 Say  "No.Proposta: "  COLORS 0, 16777215 PIXEL
@ 0038,0120 MSGET alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_NPROP")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0200 Say  "Cod.C·liente: " 	 COLORS 0, 16777215 PIXEL
@ 0038,0200 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCLIEN")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0280 Say  "Cliente: " COLORS 0, 16777215 PIXEL
@ 0038,0280 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XNREDU")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0480 Say  "Coord.Cod.: " COLORS 0, 16777215 PIXEL
@ 0038,0480 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XIDPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0540 Say  "Coordenador " 	COLORS 0, 16777215 PIXEL
@ 0038,0540 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XNOMPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.



@ 0058,0040 Say  "c/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0066,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0100 Say  "s/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0066,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0160 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
@ 0066,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0220 Say  "c/ Tributos US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0220 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCID"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0280 Say  "s/ Tributos US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0280 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSID"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.


@ 0058,0400 Say  "c/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0066,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0460 Say  "s/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0066,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0520 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
@ 0066,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0580 Say  "c/ Tributos  US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0640 Say  "s/ Tributos  US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.


@ 0087,0040 Say  "Produção " 	COLORS 0, 16777215 PIXEL
@ 0095,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUSTO"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0100 Say  "COGS Vendido " 	COLORS 0, 16777215 PIXEL
@ 0095,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCOGSV"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0160 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0095,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOT"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0220 Say  "Data Câmbio " 	COLORS 0, 16777215 PIXEL
@ 0095,0220 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XDTCB")) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0280 Say  "Vlr. Câmbio " 	COLORS 0, 16777215 PIXEL
@ 0095,0280 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCAMB"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.


@ 0087,0400 Say  "Produção " 	COLORS 0, 16777215 PIXEL
@ 0095,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUPRR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0460 Say  "COGS REV. " 	COLORS 0, 16777215 PIXEL
@ 0095,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCOGSR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0520 Say  "Total" 	COLORS 0, 16777215 PIXEL
@ 0095,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0580 Say  "Verba adicional" 	COLORS 0, 16777215 PIXEL
@ 0095,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVBAD"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.



ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)
/*
CTD->(dbclosearea())
SZC->(dbclosearea())
SZD->(dbclosearea())
SZO->(dbclosearea())
SZU->(dbclosearea())
*/

return