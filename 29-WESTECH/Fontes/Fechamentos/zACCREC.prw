#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

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
user function zACCREC()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"ACCOUNTS RECEIVABLE"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"ACCREC"
private _cArq	:= 	"ACCREC.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aDatas	:= {} // Matriz no formato [ data , campo ]
private _aLegPer:= {} // legenda dos periodos
private _aCpos1	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)


private cArqTrb1 := CriaTrab(NIL,.F.) //"PFIN011"
private cArqTrb2 := CriaTrab(NIL,.F.) //"PFIN012"
private cArqTrb3 := CriaTrab(NIL,.F.) //"PFIN013"

Private _aGrpSint:= {}
Private _cItemConta := ""

PergSalesBR()

AADD(aSays,"Este programa gera planilha com os dados para o ACCOUNTS RECEIVABLE  de acordo com os ")
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

	_dDataIni 	:= DDATABASE // Data inicial
	_dDataFim 	:= MonthSum( DDATABASE, 6 )// Data Final
	//_nDiasPer	:= max(1 , mv_par03) // Quantidade de dias por periodo (minimo de 1 dia)
	//_dDtRef  	:= mv_par04

	// Faz consistencias iniciais para permitir a execucao da rotina
	if !VldParam() .or. !AbreArq()
		return
	endif

	MSAguarde({||PFIN01REAL()},"Received until")
	
	// Processa titulos em aberto
	MSAguarde({|| PFIN01TIT()},"To be received")

	MSAguarde({||PFIN01SINT()},"Gerando arquivo ACCOUNTS RECEIVABLE ") // *** Funcao de gravacao do arquivo sintetico ***
	
	//MSAguarde({||zGeraTRB3()},"Gerando arquivo Total ")
	
	
	MontaTela()

	//dDataBase := _cOldData // restaura a database

	TRB1->(dbclosearea())
	TRB2->(dbclosearea())
	TRB3->(dbclosearea())

endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN01REALบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o fluxo de caixa realizado                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function PFIN01REAL()
	local _cQuery := ""
Local _cFilSE2 := xFilial("SE2")
Local _cFilSE5 := xFilial("SE5")
Local _cFilSED := xFilial("SED")
Local _cFilSEF := xFilial("SEF")
local _cNatureza

local cGrpFluxo := ""
local cFor 		:= ""
local cFil1B		:= ""

SE2->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
SEF->(dbsetorder(1)) // EF_FILIAL + EF_BANCO + EF_AGENCIA + EF_CONTA + EF_NUM
SE5->(dbsetorder(1))


 cQuery := "SELECT DISTINCT E1_XXIC AS 'TMP_CONTRATO', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATA', E5_VALOR AS 'TMP_VALOR',  E5_BENEF AS 'TMP_EMPRESA', E5_NATUREZ, E5_RECPAG, "
 cQuery += "	E5_HISTOR AS 'TMP_HISTORICO', E5_DOCUMEN AS 'TMP_DOCUMENTO', E5_TIPO AS 'TMP_TIPO', E5_BANCO AS 'TMP_BANCO', E5_AGENCIA AS 'TMP_AGENCIA', A6_NOME AS 'TMP_NOME', E5_CONTA AS 'TMP_CONTA' FROM SE5010 "
 cQuery += "	LEFT JOIN SE1010 ON SE1010.E1_NUM = SE5010.E5_NUMERO AND E1_CLIENTE = E5_CLIFOR  "
 cQuery += "	LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA "
 cQuery += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SE1010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "
 cQuery += "E5_RECPAG = 'R' AND E1_BAIXA <> '' AND E5_TIPODOC IN ('RA','VL') ORDER BY 3, 1 "


	IF Select("cQuery") <> 0
		DbSelectArea("cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/************************************/
/************* CONTRATOS *************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERYCTD") // Alias dos movimentos bancarios
IndRegua("QUERYCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXIS+CTD_XIDPM",,,"Selecionando Registros...")

ProcRegua(QUERYCTD->(reccount()))

QUERYCTD->(dbgotop())
//CTD->(dbsetorder(1))
//******************

while QUERYCTD->(!eof())

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERYCTD->CTD_ITEM))
		ProcessMessage()

	if ALLTRIM(QUERYCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES/ESTOQUE'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'AT'
		QUERYCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'CM'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'EN'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'EQ'
		QUERYCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'PR'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'ST'
		QUERYCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'GR'
		QUERYCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '09'
		QUERYCTD->(dbskip())
		Loop
	endif

	if QUERYCTD->CTD_XIDPM < MV_PAR01
		QUERYCTD->(dbskip())
		Loop
	endif

	if QUERYCTD->CTD_XIDPM > MV_PAR02
		QUERYCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QUERYCTD->CTD_ITEM,9,2) < MV_PAR10
		QUERYCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QUERYCTD->CTD_ITEM,9,2)> MV_PAR11
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR12 == 1 .AND. QUERYCTD->CTD_DTEXSF < DATE()
		QUERYCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QUERYCTD->CTD_DTEXSF > DATE()
		QUERYCTD->(dbskip())
		Loop
	endif
	
	_cItemConta := QUERYCTD->CTD_ITEM
		
	QUERY->(dbclearfil())
	QUERY->(dbGoTop())
	cFil1B := " alltrim(QUERY->TMP_CONTRATO)  == alltrim(_cItemConta)" 
	QUERY->(dbsetfilter({|| &(cFil1B)} , cFil1B))
	QUERY->(dbGoTop())

/************************************/

QUERY->(dbgotop())

while QUERY->(!eof())

		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->TMP_NTITULO))
		ProcessMessage()
		
			if QUERY->TMP_CONTRATO <> _cItemConta
				QUERYCTD->(dbskip())
				Loop
			endif

		
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= DataValida(QUERY->TMP_DATA)
			TRB1->VENCTO	:= DataValida(QUERY->TMP_DATA)
			TRB1->NATUREZA	:= QUERY->E5_NATUREZ
			TRB1->DESC_NAT	:= _cNatureza
			TRB1->HISTORICO	:= QUERY->TMP_HISTORICO // alltrim(QUERY->E5_XXIC) + " " + alltrim(QUERY->E5_BENEF) + " " + 
			TRB1->VALOR		:= QUERY->TMP_VALOR
			TRB1->RECPAG	:= QUERY->E5_RECPAG
			TRB1->TIPO		:= "R"
			TRB1->ORIGEM	:= "MB"
			TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
			TRB1->CAMPO		:= "XRECUN"
			TRB1->BANCO		:= QUERY->TMP_BANCO
			TRB1->ITEMCONTA	:= QUERY->TMP_CONTRATO
			TRB1->CLIFOR	:= ""
			TRB1->NCLIFOR	:= QUERY->TMP_EMPRESA
			TRB1->PREFIXO	:= ""
			TRB1->NTITULO	:= QUERY->TMP_NTITULO
			TRB1->PARCELA	:= ""
			TRB1->TIPOD		:= ""
			MsUnlock()
			
		
		
		QUERY->(dbskip())
		
	enddo

	QUERYCTD->(dbskip())

enddo	

QUERY->(dbclearfil())
QUERYCTD->(dbclosearea())
QUERY->(dbclosearea())


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN01REALบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o fluxo de caixa realizado                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
static function PFIN01REAL()
	local _cQuery := ""
Local _cFilSE2 := xFilial("SE2")
Local _cFilSE5 := xFilial("SE5")
Local _cFilSED := xFilial("SED")
Local _cFilSEF := xFilial("SEF")
local _cNatureza

local cGrpFluxo := ""
local cFor 		:= ""
local cFil1B		:= ""

SE2->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
SEF->(dbsetorder(1)) // EF_FILIAL + EF_BANCO + EF_AGENCIA + EF_CONTA + EF_NUM
SE5->(dbsetorder(1))

cForSE5 := "SE5->E5_RECPAG == 'R' .AND. !empty(QUERY->E5_XXIC)"

ChkFile("SE5",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"DTOS(E5_DTDISPO)+E5_NATUREZ",,,"Selecionando Registros...")

ChkFile("SE5",.F.,"SE5_EC") // Alias para estorno de cheques
IndRegua("SE5_EC",CriaTrab(NIL,.F.),"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))


/************* CONTRATOS *************************/

/*
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERYCTD") // Alias dos movimentos bancarios
IndRegua("QUERYCTD",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXIS+CTD_XIDPM",,,"Selecionando Registros...")

ProcRegua(QUERYCTD->(reccount()))

QUERYCTD->(dbgotop())
//CTD->(dbsetorder(1))
//******************

while QUERYCTD->(!eof())

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERYCTD->CTD_ITEM))
		ProcessMessage()

	if ALLTRIM(QUERYCTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES/ESTOQUE'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'AT'
		QUERYCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'CM'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'EN'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'EQ'
		QUERYCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'PR'
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR08 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'ST'
		QUERYCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR09 = 2 .AND. ALLTRIM(SUBSTR(QUERYCTD->CTD_ITEM,1,2)) = 'GR'
		QUERYCTD->(dbskip())
		Loop
	endif


	if SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERYCTD->CTD_ITEM,9,2) == '09'
		QUERYCTD->(dbskip())
		Loop
	endif

	if QUERYCTD->CTD_XIDPM < MV_PAR01
		QUERYCTD->(dbskip())
		Loop
	endif

	if QUERYCTD->CTD_XIDPM > MV_PAR02
		QUERYCTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(QUERYCTD->CTD_ITEM,9,2) < MV_PAR10
		QUERYCTD->(dbskip())
		Loop
	endif

	if SUBSTR(QUERYCTD->CTD_ITEM,9,2)> MV_PAR11
		QUERYCTD->(dbskip())
		Loop
	endif

	if MV_PAR12 == 1 .AND. QUERYCTD->CTD_DTEXSF < DATE()
		QUERYCTD->(dbskip())
		Loop
	endif
	
	if MV_PAR12 == 2 .AND. QUERYCTD->CTD_DTEXSF > DATE()
		QUERYCTD->(dbskip())
		Loop
	endif
	
	_cItemConta := QUERYCTD->CTD_ITEM
		
	QUERY->(dbclearfil())
	QUERY->(dbGoTop())
	cFil1B := " alltrim(QUERY->E5_XXIC)  == alltrim(_cItemConta)" 
	QUERY->(dbsetfilter({|| &(cFil1B)} , cFil1B))
	QUERY->(dbGoTop())
*/
/************************************/
/*
SE5->(dbgotop())
QUERY->(dbgotop())

	while QUERY->(!eof())  .and. QUERY->E5_FILIAL == _cFilSE5 //.and. dtos(QUERY->E5_DATA) < dDatabase
		
	
		MsProcTxt("Processando registro: "+alltrim(QUERY->E5_NUMERO))
		ProcessMessage()
		
		
		if  (QUERY->E5_BANCO $ '117') .or. ;
			(QUERY->E5_VENCTO > QUERY->E5_DTDISPO) .or. ;
			(right(alltrim(QUERY->E5_NUMCHEQ),1) == '*') .or. ;
			(QUERY->E5_SITUACA == 'C') .or. ;
			(QUERY->E5_VALOR == 0) .or. ;
			(QUERY->E5_TIPODOC $ 'DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL/BA') .or. ;
			(QUERY->E5_MOEDA $ "C1/C2/C3/C4/C5" .and. Empty(QUERY->E5_NUMCHEQ) .and. !(QUERY->E5_TIPODOC $ "TR#TE")) 	.or. ;
			(QUERY->E5_TIPODOC $ "TR/TE" .and. Empty(QUERY->E5_NUMERO) .and. !(QUERY->E5_MOEDA $ "R$/DO/TB/TC/CH/EM/PE")) 	.or. ;
			(QUERY->E5_TIPODOC $ "TR/TE" .and. (Substr(QUERY->E5_NUMCHEQ,1,1)=="*" .or. Substr(QUERY->E5_DOCUMEN,1,1) == "*" )) .or. ;
			(QUERY->E5_MOEDA == "CH" .and. IsCaixaLoja(QUERY->E5_BANCO)) 	.or. ;
			(!Empty( QUERY->E5_MOTBX ) .and. !MovBcoBx( QUERY->E5_MOTBX ))	.or. ;
			(left(QUERY->E5_NUMCHEQ,1) == "*"  .or. left(QUERY->E5_DOCUMEN,1) == "*") .or. ;
			QUERY->E5_TIPODOC == "EC" .or. ;
			QUERY->E5_XXIC $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES") .or. ;
			QUERY->E5_RECPAG = "P" .or. ;
			empty(QUERY->E5_XXIC) .or. ;
			SUBSTR(QUERY->E5_NATUREZ,1,1) <> "1"
			QUERY->(dbskip())
			Loop
			
		endif
	
		
		if SED->(dbseek(_cFilSED+QUERY->E5_NATUREZ))
			_cNatureza := SED->ED_DESCRIC
		else
			_cNatureza := "NATUREZA NAO DEFINIDA"
		endif
		
		if alltrim(QUERY->E5_TIPODOC) <> "CH"	
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= DataValida(QUERY->E5_DTDISPO)
			TRB1->VENCTO	:= DataValida(QUERY->E5_DTDISPO)
			TRB1->NATUREZA	:= QUERY->E5_NATUREZ
			TRB1->DESC_NAT	:= _cNatureza
			TRB1->HISTORICO	:= QUERY->E5_HISTOR // alltrim(QUERY->E5_XXIC) + " " + alltrim(QUERY->E5_BENEF) + " " + 
			TRB1->VALOR		:= iif(QUERY->E5_RECPAG == "R" , QUERY->E5_VALOR , -QUERY->E5_VALOR)
			TRB1->RECPAG	:= QUERY->E5_RECPAG
			TRB1->TIPO		:= "R"
			TRB1->ORIGEM	:= "MB"
			TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
			TRB1->CAMPO		:= "XRECUN"
			TRB1->BANCO		:= QUERY->E5_BANCO
			TRB1->ITEMCONTA	:= QUERY->E5_XXIC
			TRB1->CLIFOR	:= QUERY->E5_CLIFOR
			TRB1->NCLIFOR	:= QUERY->E5_BENEF
			TRB1->PREFIXO	:= alltrim(QUERY->E5_BENEF)
			TRB1->NTITULO	:= QUERY->E5_NUMERO
			TRB1->PARCELA	:= ""
			TRB1->TIPOD		:= ""
			MsUnlock()
			
		else // Se for um cheque aglutinado - pesquisa pelos titulos pagos no cheque
			
			
			_nRegQry := 0
			
			if SE5_EC->(dbseek(QUERY->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)))
				while SE5_EC->(!eof()) .and. QUERY->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ) == SE5_EC->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					if SE5_EC->E5_SEQ == QUERY->E5_SEQ .and. SE5_EC->E5_TIPODOC = 'EC' .and. SE5_EC->(recno()) > QUERY->(recno())
						_nRegQry++
					endif
					SE5_EC->(dbskip())
				enddo
			endif
			
			if _nRegQry > 0
				QUERY->(dbskip())
				Loop
			endif
			
			_cChave := _cFilSEF+QUERY->E5_BANCO+QUERY->E5_AGENCIA+QUERY->E5_CONTA+QUERY->E5_NUMCHEQ
			
			if SEF->(dbseek(_cChave))
				
				while SEF->(!eof()) .and. SEF->EF_FILIAL + SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA + SEF->EF_NUM == _cChave
					
					if !empty(SEF->EF_TITULO) .and. SE2->(dbseek(_cFilSE2+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA))
						
						if SED->(dbseek(_cFilSED+SE2->E2_NATUREZ))
							_cNatureza := SED->ED_DESCRIC
						else
							_cNatureza := "NATUREZA NAO DEFINIDA"
						endif
						
						RecLock("TRB1",.T.)
						TRB1->DATAMOV	:= DataValida(QUERY->E5_DTDISPO)
						TRB1->VENCTO	:= DataValida(QUERY->E5_DTDISPO)
						TRB1->NATUREZA	:= SE2->E2_NATUREZ
						TRB1->DESC_NAT	:= _cNatureza //GetAdvFVal("SED","ED_DESCRIC",_cFilSED+SE2->E2_NATUREZ,1,"NATUREZA NAO DEFINIDA")
						TRB1->HISTORICO	:= QUERY->E5_HISTOR
						TRB1->VALOR		:= iif(QUERY->E5_RECPAG == "R" , SEF->EF_VALOR , -SEF->EF_VALOR)
						TRB1->RECPAG	:= QUERY->E5_RECPAG
						TRB1->TIPO		:= "R"
						TRB1->ORIGEM	:= "MB"
						
						if ! alltrim(QUERY->E2_XXIC) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES") .OR. alltrim(QUERY->E2_XXIC) <> "" 
							cGrpFluxo := "2.0X.00"
						elseif alltrim(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00"
							cGrpFluxo := "6.2X.00"
						else
							cGrpFluxo := RetGrupo(TRB1->NATUREZA)
						endif
						
						TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
						TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
						TRB1->BANCO		:= QUERY->E5_BANCO
						TRB1->ITEMCONTA	:= QUERY->E5_XXIC
						TRB1->CLIFOR	:= QUERY->E5_CLIFOR
						TRB1->NCLIFOR	:= QUERY->E5_BENEF
						TRB1->PREFIXO	:= alltrim(QUERY->E5_BENEF)
						TRB1->NTITULO	:= QUERY->E5_NUMERO
						TRB1->PARCELA	:= SE2->E2_PARCELA
						TRB1->TIPOD		:= SE2->E2_TIPO
						MsUnlock()
						
					endif
					SEF->(dbskip())
					
				enddo
				
			endif
		
		endif
		
		QUERY->(dbskip())
		
	enddo

	QUERYCTD->(dbskip())

enddo	

QUERY->(dbclearfil())
QUERYCTD->(dbclosearea())
QUERY->(dbclosearea())
SE5_EC->(dbclosearea())

return
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN01TIT บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa Titulos em aberto                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function PFIN01TIT()
Local _cFilSE1 := xFilial("SE1")
Local _cFilSED := xFilial("SED")
Local _cFilSE2 := xFilial("SE2")
Local _cFilSE5 := xFilial("SE5")
Local _cFilSEF := xFilial("SEF")
local _cQuery := ""
local _nSaldo := 0
local _lNatFluxo := SED->(fieldpos("ED_XFLUXO")) > 0

local cFor 			:= ""



	/************* TITULOS EM ABERTO ***************/
	SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
	
	
	// TITULOS A RECEBER EM ABERTO
	ChkFile("SE1",.F.,"QUERY") // Alias dos titulos a receber
	
	
	QUERY->(dbsetorder(7)) // E1_FILIAL + DTOS(E1_VENCREA) + E1_NOMCLI + E1_PREFIXO + E1_NUM + E1_PARCELA

	while QUERY->(!eof()) //.and. SE1->E1_FILIAL == _cFilSE1 .and. QUERY->E1_VENCREA <= _dDataFim
	
		//oProcess:IncRegua2("Processando Titulos")
		//oProcess:SetRegua2( ("QUERY")->(RecCount()) ) //Alimenta a segunda barra de progresso
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->E1_NUM))
		ProcessMessage()
		
		if 	substr(QUERY->E1_TIPO,3,1) == "-" .or. ;
			!(QUERY->E1_SALDO > 0 .OR. dtos(QUERY->E1_BAIXA) > dtos(ddatabase)) .or. ;
			QUERY->E1_TIPO = "RA" .or. ; //dtos(QUERY->E1_EMISSAO) > dtos(_dDataFim) .or. 
			SUBSTR(QUERY->E1_NATUREZ,1,1) <> "1"
			QUERY->(dbskip())
			loop
		endif
		
			
		
		if SED->(dbseek(_cFilSED+QUERY->E1_NATUREZ))
			_cNatureza := SED->ED_DESCRIC
		endif
		
		_nSaldo :=_CalcSaldo("SE1", QUERY->(recno()))
		
		if _nSaldo <> 0
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= DataValida(QUERY->E1_VENCREA) //iif( dtos(QUERY->E1_VENCREA) < dtos(ddatabase) , DataValida(ddatabase) , DataValida(QUERY->E1_VENCREA) ) //max(DataValida(QUERY->E1_VENCREA), DataValida(_dDtRef)) // A data de previsao tem que ser, no minimo, a data de referencia
			TRB1->VENCTO	:= QUERY->E1_VENCTO
			TRB1->NATUREZA	:= QUERY->E1_NATUREZ
			TRB1->DESC_NAT	:= _cNatureza
			TRB1->VALOR		:= _nSaldo
			TRB1->TIPO		:= "P"
			TRB1->RECPAG	:= "R"
			TRB1->ORIGEM	:= "CR"
			TRB1->HISTORICO	:= 	iif(!empty(QUERY->E1_HIST) , alltrim(QUERY->E1_HIST) ,"") + " " + ;
			iif( dtos(QUERY->E1_VENCREA) < dtos(DataValida(ddatabase)) , " - Vencto.Real: " + dtoc(DataValida(QUERY->E1_VENCREA)) , "" )//QUERY->E1_HIST //alltrim(QUERY->E1_XXIC + " - " + QUERY->E1_NOMCLI + " Titulo:"  + QUERY->E1_NUM + " Parcela:" + QUERY->E1_PARCELA + " Tipo:" + QUERY->E1_TIPO) + ;
			//iif(!empty(QUERY->E1_HIST) , " - " + QUERY->E1_HIST ,"")
			TRB1->GRUPONAT 	:= iif( dtos(QUERY->E1_VENCREA) < dtos(ddatabase) .and. empty(dtos(QUERY->E1_BAIXA)) .and. !empty(QUERY->E1_NATUREZ)  , "0.00.09" , RetGrupo(TRB1->NATUREZA) )//RetGrupo(TRB1->NATUREZA)
			TRB1->CAMPO		:= iif(TRB1->DATAMOV > _dDataFim, "XOTHMO" , RetCampo(TRB1->DATAMOV))
			TRB1->ITEMCONTA	:= QUERY->E1_XXIC
			TRB1->CLIFOR	:= QUERY->E1_CLIENTE
			TRB1->NCLIFOR	:= QUERY->E1_NOMCLI
			TRB1->LOJA		:= QUERY->E1_LOJA
			TRB1->PREFIXO	:= QUERY->E1_PREFIXO
			TRB1->NTITULO	:= QUERY->E1_NUM
			TRB1->PARCELA	:= QUERY->E1_PARCELA
			TRB1->TIPOD		:= QUERY->E1_TIPO
			TRB1->DATAMOV2	:=  DataValida(QUERY->E1_VENCREA) 
			MsUnlock()
		endif
		
		QUERY->(dbskip())
	enddo

QUERY->(dbclosearea())


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_CalcSaldoบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula o saldo do titulo na data de referencia            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function _CalcSaldo(_cAlias, _nRecno)

local _nSaldo := 0

if _cAlias == "SE1"
	
	SE1->(dbgoto(_nRecno))
	
	dbselectarea("SE1")
	
	_nSaldo	:= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,;
	SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,;
	dDatabase,dDatabase,SE1->E1_LOJA,SE1->E1_FILIAL)
	
	dbselectarea("SE1")
	
	_nSaldo -= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,;
	dDatabase,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL)
	
	if SE1->E1_TIPO $ (MV_CRNEG + "/" + MVRECANT) .OR. SE2->E2_TIPO == "RA" // O normal de um titulo a receber e ser positivo
		_nSaldo := -1 * _nSaldo
	endif

else
	
	SE2->(dbgoto(_nRecno))
	
	dbselectarea("SE2")
	
	_nSaldo	:= SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
	SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,1,;
	dDatabase-1,,SE2->E2_LOJA)//_dDtRef,_dDtRef,SE2->E2_LOJA)
	
	dbselectarea("SE2")

	_nSaldo -= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,;
	dDatabase-1,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_FILIAL) //_dDtRef,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_FILIAL)

	if !(SE2->E2_TIPO $ (MV_CPNEG + "/" + MVPAGANT)) .OR. SE2->E2_TIPO == "PA"  // O normal de um titulo a pagar e ser negativo
		_nSaldo := -1 * _nSaldo
	endif
	
endif

return(_nSaldo)


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

Local nTotalVDCI 	:= 0
local nXRECUN		:= 0


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

local cForTRB1 	:= ""
local cItemConta := ""
local nXOTHMO 	:= 0
local nValFAT2 	:= 0
local cFil1B	:= ""
local TotalOM	:= 0

private _cOrdem := "000001"

//*******************

/************* CONTRATOS *************************/
CTD->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CTD",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM+CTD_DTEXIS+CTD_XIDPM",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

CTD->(dbgotop())
//CTD->(dbsetorder(1))
//******************

while QUERY->(!eof())

	//IncProc("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		MsProcTxt("Processando registro: "+alltrim(QUERY->CTD_ITEM))
		ProcessMessage()

	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/OPERACOES/ESTOQUE'
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


		RecLock("TRB2",.T.)
		//TRB2->OK		:= oGreen
		TRB2->ITEM		:= QUERY->CTD_ITEM
		TRB2->CLIENTE	:= QUERY->CTD_XNREDU
		TRB2->XVDCI		:= QUERY->CTD_XVDCIR
		TRB2->XVDSI		:= QUERY->CTD_XVDSIR
		
		_cItemConta := QUERY->CTD_ITEM
		
		TRB1->(dbclearfil())
		TRB1->(dbGoTop())
		cFil1B := " alltrim(TRB1->ITEMCONTA)  == alltrim(_cItemConta)" 
		TRB1->(dbsetfilter({|| &(cFil1B)} , cFil1B))
		TRB1->(dbGoTop())	
		

		
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if alltrim(TRB1->ITEMCONTA) == alltrim(QUERY->CTD_ITEM) .AND. dtos(TRB1->DATAMOV) < dtos(FirstDate(dDatabase)) .AND. TRB1->VALOR > 0
				nXRECUN += TRB1->VALOR
			endif
			TRB1->(dbskip())
		enddo
		
		TRB2->XRECUN	:=	nXRECUN
		
		TRB2->XDELMON	:= QUERY->CTD_DTEXIS //substr(dtoc(QUERY->TMP_XDTEVC),4,7)
		TRB2->XDELMON2	:= substr(dtoc(QUERY->CTD_DTEXIS),4,7)

		//**************************** Faturamento *********************************
		TRB1->(dbgotop())
		for _ni := 1 to len(_aCpos1) // Monta campos com as datas
			//dDTIni :=  ctod(substr( _aLegPer[_ni],1,10))
			//dDTFin :=  ctod(substr( _aLegPer[_ni],14,10 ))

			TRB1->(dbgotop())

			 	While TRB1->( ! EOF() )

					dDTIni :=  FirstDate(ctod(substr( _aLegPer[_ni],1,10)))
					dDTFin :=  LastDate(ctod(substr( _aLegPer[_ni],14,10 )))

					cItem 	:= QUERY->CTD_ITEM

					IF alltrim(TRB1->ITEMCONTA) = alltrim(cItem) .AND. TRB1->DATAMOV >= dDTIni .AND. TRB1->DATAMOV <= dDTFin
						nValFAT		+= TRB1->VALOR
						nValFAT2 	+= TRB1->VALOR
					ENDIF
					TRB1->(dbskip())
				EndDo

			FieldPut(TRB2->(fieldpos(_aCpos1[_ni])) , nValFAT )
			
			nValFAT := 0
		next
	
		TRB1->(dbgotop())

			While TRB1->( ! EOF() )

					cItem 	:= QUERY->CTD_ITEM

					IF alltrim(TRB1->ITEMCONTA) = alltrim(cItem) .AND. TRB1->DATAMOV > dDTFin 
						nXOTHMO		+= TRB1->VALOR
					ENDIF
					TRB1->(dbskip())
				EndDo
				
		TRB2->XOTHMO := nXOTHMO
		TRB2->XTOTAL := nXOTHMO + nValFAT2 + nXRECUN
/*
		aAdd(aStru,{"XOTHMO"	,"N",15,2}) // Descricao da Natureza
		aAdd(aStru,{"XTOTAL"	,"N",15,2}) // Descricao da Natureza
*/
		//************************** Custo Previsto ***********************************
		nXRECUN :=  0
		nValFAT2 := 0
		nXOTHMO := 0
	QUERY->(dbskip())

enddo
/***********Totais TRB3***********************/
RecLock("TRB3",.T.)

TRB3->DESC		:= "TOTAL"

for _ni := 1 to len(_aCpos1)
	TRB2->(dbgotop())
	while TRB2->(!eof())
	
		TotalRev += &("TRB2->" + _aCpos1[_ni])
		TRB2->(dbskip())
	enddo
	TRB2->(dbgobottom())
	FieldPut(TRB3->(fieldpos(_aCpos1[_ni])) , TotalRev  )
	TotalRev := 0
next

TRB2->(dbgotop())
while TRB2->(!eof())
	TotalOM += TRB2->XOTHMO
	TRB2->(dbskip())
enddo

TRB3->XOTHMO := TotalOM 

MsUnlock()

 TotalOM := 0
/*************Total TRB2***********************/
RecLock("TRB2",.T.)

TRB2->ITEM		:= "TOTAL"
TRB2->XDELMON	:= _dDataFim
TRB2->XVDCI		:= nTotalVDCI
TRB2->XVDSI		:= nTotalVDSI

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

TRB2->(dbgotop())
while TRB2->(!eof())
	TotalOM += TRB2->XOTHMO
	TRB2->(dbskip())
enddo
TRB2->(dbgobottom())
TRB2->XOTHMO := TotalOM

MsUnlock()

/******************************/

nTotalFAT2 := 0
nPropFrete2		:= 0
nPropCom2		:= 0

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
Local oFolder1

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
Private _oDlgSint

cCadastro = "ACCOUNTS RECEIVABLE  " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim))
// Monta aHeader do TRB2
//aadd(aHeader, {"  OK"									,"OK"		,"@BMP"				,01,0,".T."		,"","C","TRB2","OK"})
aadd(aHeader, {"  Job No."								,"ITEM"		,""					,15,0,""		,"","C","TRB2","Job No."})
aadd(aHeader, {"Cliente Name"							,"CLIENTE"	,""					,30,0,""		,"","C","TRB2",""})
aadd(aHeader, {"Total With taxes"						,"XVDCI"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Total Without taxes"					,"XVDSI"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Received until"							,"XRECUN"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})

for _ni := 1 to len(_aCpos1) // Monta campos com as datas

	aadd(aHeader, { substr(_aLegPer[_ni],4,7),_aCpos1[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	
next _dData

aadd(aHeader, {"Other month"							,"XOTHMO"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})
aadd(aHeader, {"Total"									,"XTOTAL"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})

aadd(aHeader, {"Delivery Month"							,"XDELMON2"	,""					,7,0,""			,"","C","TRB2",""})
//aadd(aHeader, {"Total","TOTAL","@E 999,999,999.99",15,2,"","","N","TRB2","R"})

DEFINE MSDIALOG _oDlgSint ;
TITLE  "ACCOUNTS RECEIVABLE  " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim));
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"
/***************************************************/
 @ aPosObj2[1,1],aPosObj2[1,2] FOLDER oFolder1 SIZE  aPosObj2[1,4],aPosObj2[1,3]-35 OF _oDlgSint ITEMS "Accounts","Graph" COLORS 0, 16777215 PIXEL

_oGetDbSint := MsGetDb():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2",,,,oFolder1:aDialogs[1])

_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

// COR DA FONTE
_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
// COR DA LINHA
//_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| fTrocaCor(2)}
//_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha
/********************* Grแfico *******************************/
//Instโncia a classe
        oChart := FWChartBar():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB3",,,,oFolder1:aDialogs[2])
        //_oGetDbSint := MsGetDb():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2",,,,oFolder1:aDialogs[1]) 
        //Inicializa pertencendo a janela
        oChart:Init(oFolder1:aDialogs[2], .T., .T. )
         
        //Seta o tํtulo do grแfico
        oChart:SetTitle("ACCOUNTS RECEIVABLE  " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim)), CONTROL_ALIGN_CENTER)
        
        for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	        //Adiciona as s้ries, com as descri็๕es e valores
	        oChart:addSerie(substr(_aLegPer[_ni],4,7), TRB3->(FieldGet(fieldpos(_aCpos1[_ni]))))
               
        next _dData
        oChart:addSerie("Other month", TRB3->XOTHMO)
  
  
        //Define que a legenda serแ mostrada na esquerda
        oChart:setLegend( CONTROL_ALIGN_LEFT )
         
        //Seta a mแscara mostrada na r้gua
        oChart:cPicture := "@E 999,999,999.99"
        
        //Define as cores que serใo utilizadas no grแfico
        aAdd(aRand, {"084,120,164", "007,013,017"})
        aAdd(aRand, {"171,225,108", "017,019,010"})
        aAdd(aRand, {"207,136,077", "020,020,006"})
        aAdd(aRand, {"166,085,082", "017,007,007"})
        aAdd(aRand, {"130,130,130", "008,008,008"})
        aAdd(aRand, {"136,055,052", "017,007,007"})
        aAdd(aRand, {"166,085,082", "017,007,007"})
        
        //Seta as cores utilizadas
        oChart:oFWChartColor:aRandom := aRand
        oChart:oFWChartColor:SetColor("Random")
         
        //Constr๓i o grแfico
        oChart:Build()
/****************************************************/
aadd(aButton , { "BMPTABLE2" , { || zExportExc3()}, "Gerar Plan. Excel " } )
aadd(aButton , { "BMPTABLE2" , { || zExFuA()}, "Analitico " } )
aadd(aButton , { "BMPTABLE2" , { || zTotalRec()}, "Totais " } )
aadd(aButton , { "BMPTABLE2" , { || zPrnGraph()}, "Impressใo Grแfico " } )


ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return
/******************************************************/
Static Function zPrnGraph()
    Local aArea       := GetArea()
    Local cNomeRel    := "rel_Graph_"+dToS(Date())+StrTran(Time(), ':', '-')
    Local cDiretorio  := GetTempPath()
    Local nLinCab     := 025
    Local nAltur      := 250
    Local nLargur     := 1050
    Local aRand       := {}
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
     
    //Criando o objeto de impressใo
    oPrintPvt := FWMSPrinter():New(cNomeRel, IMP_PDF, .F., /*cStartPath*/, .T., , @oPrintPvt, , , , , .T.)
    oPrintPvt:cPathPDF := GetTempPath()
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60, 60, 60, 60)
    oPrintPvt:StartPage()
     
    //Cabe็alho
    oPrintPvt:SayAlign(nLinCab, nColMeio-100, "ACCOUNTS RECEIVABLE" , oFontTit, 500, 20, RGB(0,0,255),, 0)
    nLinCab += 35
    nLinAtu := nLinCab
     
    //Se o arquivo existir, exclui ele
    If File(cDiretorio+"_grafico.png")
        FErase(cDiretorio+"_grafico.png")
    EndIf
     
    //Cria a Janela
    DEFINE MSDIALOG oDlgChar PIXEL FROM 0,0 TO nAltur,nLargur
        //Instโncia a classe
        oChart := FWChartBar():New()
          
        //Inicializa pertencendo a janela
        oChart:Init(oDlgChar, .T., .T. )
          
        //Seta o tํtulo do grแfico
        oChart:SetTitle(dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim)), CONTROL_ALIGN_CENTER)
          
        for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	        //Adiciona as s้ries, com as descri็๕es e valores
	        oChart:addSerie(substr(_aLegPer[_ni],4,7), TRB3->(FieldGet(fieldpos(_aCpos1[_ni]))))
               
        next _dData
        oChart:addSerie("Other month", TRB3->XOTHMO)
          
        //Define que a legenda serแ mostrada na esquerda
        oChart:setLegend( CONTROL_ALIGN_LEFT )
          
         //Seta a mแscara mostrada na r้gua
        oChart:cPicture := "@E 999,999,999.99"
        
        //Define as cores que serใo utilizadas no grแfico
        aAdd(aRand, {"084,120,164", "007,013,017"})
        aAdd(aRand, {"171,225,108", "017,019,010"})
        aAdd(aRand, {"207,136,077", "020,020,006"})
        aAdd(aRand, {"166,085,082", "017,007,007"})
        aAdd(aRand, {"130,130,130", "008,008,008"})
        aAdd(aRand, {"136,055,052", "017,007,007"})
        aAdd(aRand, {"166,085,082", "017,007,007"})
        //Seta as cores utilizadas
        oChart:oFWChartColor:aRandom := aRand
        oChart:oFWChartColor:SetColor("Random")
          
        //Constr๓i o grแfico
        oChart:Build()
    ACTIVATE MSDIALOG oDlgChar CENTERED ON INIT (oChart:SaveToPng(0, 0, nLargur, nAltur, cDiretorio+"_grafico.png"), oDlgChar:End())
     
    oPrintPvt:SayBitmap(nLinAtu, nColIni, cDiretorio+"_grafico.png", nLargur/2, nAltur/1.6)
    nLinAtu += nAltur/1.6 + 3
     
    oPrintPvt:SayAlign(nLinAtu, nColIni+020, "Westech",                            oFontSubN, 100, 07, , , )
     
    //Impressใo do Rodap้
    fImpRod()
     
    //Gera o pdf para visualiza็ใo
    oPrintPvt:Preview()
     
    RestArea(aArea)
Return
 
/*---------------------------------------------------------------------*
 | Func:  fImpRod                                                      |
 | Desc:  Fun็ใo para impressใo do rodap้                              |
 *---------------------------------------------------------------------*/
 
Static Function fImpRod()
    Local nLinRod := nLinFin + 10
    Local cTexto  := ""
 
    //Linha Separat๓ria
    oPrintPvt:Line(nLinRod, nColIni, nLinRod, nColFin, RGB(200, 200, 200))
    nLinRod += 3
     
    //Dados da Esquerda
    cTexto := "Relat๓rio Recebimento    |    "+dToC(dDataBase)+"     "+cHoraEx+"     "+FunName()+"     "+cUserName
    oPrintPvt:SayAlign(nLinRod, nColIni,    cTexto, oFontRod, 250, 07, , , )
     
    //Direita
    cTexto := "Pแgina "+cValToChar(nPagAtu)
    oPrintPvt:SayAlign(nLinRod, nColFin-40, cTexto, oFontRod, 040, 07, , , )
     
    //Finalizando a pแgina e somando mais um
    oPrintPvt:EndPage()
    nPagAtu++
Return

/******************************************************/
Static Function SFMudaCor(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  if TRB2->XVDCI <>  TRB2->XTOTAL; _cCor := CLR_RED; endif
   endif
   /*
   if nIOpcao == 2 // Cor da Fonte
   	  if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.01"; _cCor := CLR_LIGHTGRAY ; endif
   	  
   endif
   */
Return _cCor
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaTela บ												  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Total Recebimento								           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function zTotalRec()
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


 
cCadastro = "TOTAL RECEIVABLE  " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim))
// Monta aHeader do TRB2
aadd(aHeader, {" Total"								,"DESC"		,""					,10,0,""		,"","C","TRB3","Job No."})

for _ni := 1 to len(_aCpos1) // Monta campos com as datas

	aadd(aHeader, { substr(_aLegPer[_ni],4,7),_aCpos1[_ni],"@E 999,999,999.99",15,2,"","","N","TRB3","R"})
	
next _dData
aadd(aHeader, {"Other month"							,"XOTHMO"	,"@E 999,999,999.99",15,2,""		,"","N","TRB2",""})

//aadd(aHeader, {"Total","TOTAL","@E 999,999,999.99",15,2,"","","N","TRB2","R"})

DEFINE MSDIALOG _oDlgSint ;
TITLE  "Total RECEIVABLE  " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim));
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB3",,,,)

_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

//aadd(aButton , { "BMPTABLE2" , { || zExportExc3()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE2" , { || zExFuA()}, "Analitico " } )


ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณShowAnalitบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ShowAnalit(_cCampo,_cPeriodo)
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro := "Fluxo de caixa - Analํtico - " + _cPeriodo


// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
/*
if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0 .or. (empty(TRB2->GRUPOSUP) .and. !empty(TRB2->GRUPO))
	return
endif
XRECUN
XOTHMO
_dDataIni 	:= DDATABASE // Data inicial
	_dDataFim
*/


// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
if alltrim(_cCampo) $ ("XRECUN") 
	cFiltra :=  "  alltrim(ITEMCONTA) == '" + alltrim(TRB2->ITEM) + "' .and. dtos(DATAMOV) < '" + dtos(FirstDate(_dDataIni)) + "'  "
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
elseif alltrim(_cCampo) == "XOTHMO" 
	cFiltra := " alltrim(CAMPO) == '" + alltrim(_cCampo) + "' .and. alltrim(ITEMCONTA) == '" + alltrim(TRB2->ITEM) + "' .and. dtos(DATAMOV) > '" + dtos(LastDate(_dDataFim)) + "'  "
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
elseif alltrim(_cCampo) == "XTOTAL" 
	cFiltra :=  " alltrim(ITEMCONTA) == '" + alltrim(TRB2->ITEM) + "' .and. dtos(DATAMOV) > '" + dtos(FirstDate(_dDataIni)) + "'  "
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
else
	cFiltra := " alltrim(CAMPO) == '" + alltrim(_cCampo) + "' .and. alltrim(ITEMCONTA) == '" + alltrim(TRB2->ITEM) + "' "
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
endif

// Monta aHeader do TRB1
aadd(aHeader, {"Data Real"	,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Vencimento"	,"VENCTO"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Banco"		,"BANCO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Item Conta"	,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Prefixo"	,"PREFIXO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"No.Titulo/OC","NTITULO"	,"",09,0,"","","C","TRB1","R"})
aadd(aHeader, {"Parcela"	,"PARCELA"	,"",01,0,"","","C","TRB1","R"})
aadd(aHeader, {"Tipo"		,"TIPOD"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Natureza"	,"NATUREZA"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descri็ใo"	,"DESC_NAT"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cod.Cli/For","CLIFOR"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cli/For"	,"NCLIFOR"	,"",20,0,"","","C","TRB1","R"})
aadd(aHeader, {"Loja"		,"LOJA"		,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Valor"		,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Hist๓rico"	,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Fluxo de caixa - Analํtico - " + _cPeriodo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA ORIGEM: MB - Movimento Bancแrio / CR - Contas a Receber  "  COLORS 0, 16777215 PIXEL

_oGetDbAnalit:oBrowse:BlDblClick := {|| EditReg() }
_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

//aadd(aButton , { "SIMULACAO", 	{ || (GerSimul(_cCampo,_cPeriodo),TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Simula็ใo" } )
//aadd(aButton , { "EXCLUIR", 	{ || (DelSimul(_cCampo,_cPeriodo),,TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Excluir Simula็ใo" } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE3" , { || zExpAnalitico()}, "Gerar Plan. Excel " } )

_oGetDbAnalit:ForceRefresh()
_oDlgAnalit:Refresh()

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

//TRB1->(dbclearfil())

return

/***********************************/
//**********************************************************************
Static Function EditReg()
    Local aArea       := GetArea()
    Local aAreaC7     := SC7->(GetArea())
    Local aAreaE2     := SE2->(GetArea())
    Local aAreaE1     := SE1->(GetArea())
    Local nOpcao      := 0
    Local cTitulo	  := alltrim(TRB1->NTITULO)
    Local cClifor	  := alltrim(TRB1->CLIFOR)
    Local cLoja		  := alltrim(TRB1->LOJA)
    Local cParcela	  := alltrim(TRB1->PARCELA)
    Local dData		  := DTOS(TRB1->DATAMOV)
    Local cConsSE2	  := cClifor+cTitulo+cParcela
    Local cConsSE1	  := cClifor+cTitulo+cParcela
    Local cOrigem	  := alltrim(TRB1->ORIGEM)
   
    Private cCadastro 
    
    if alltrim(TRB1->GRUPONAT) == "0.00.09" .OR. alltrim(TRB1->GRUPONAT) == "0.00.10"
    	dData		  := DTOS(TRB1->DATAMOV2)
    endif
    
    IF cOrigem == "OC"  
    	
    	cCadastro := "Altera็ใo Ordem de Compra"
    
	    DbSelectArea("SC7")
	    SC7->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	    SC7->(DbGoTop())
	     
	    //Se conseguir posicionar no produto
	    If SC7->(DbSeek(xFilial('SC7')+cTitulo))
	    	
	        nOpcao := fAltRegSC7()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Aten็ใo")
	        EndIf
	       
	    EndIf
	ENDIF
	
	IF cOrigem == "CP"  
		cCadastro := "Altera็ใo Contas a Pagar"

	    DbSelectArea("SE2")
	    SE2->(DbSetOrder(20)) //B1_FILIAL + B1_COD
	    	
		//if SE2->(DbSeek(xFilial("SE2")+cTitulo+cClifor) )
		if SE2->(DbSeek(xFilial("SE2")+TRB1->NTITULO+TRB1->CLIFOR+dData+TRB1->LOJA) )
			//nOpcao := AxAltera("SE2", SE2->(RecNo()), 4)
	        nOpcao := zAltRegSE2()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Aten็ใo")
	            MSAguarde({|| AtuSaldo()},"Atualizando Fluxo de Caixa")
	       
	        EndIf
	    endif
	ENDIF
		
	IF cOrigem == "CR"  

		cCadastro := "Altera็ใo Contas a Receber"
	
	    DbSelectArea("SE1")
	    SE1->(DbSetOrder(30)) //B1_FILIAL + B1_COD
	    SE1->(DbGoTop())
	    
	    //Se conseguir posicionar no produto
	    If SE1->(DbSeek(xFilial("SE1")+TRB1->NTITULO+TRB1->CLIFOR+dData+TRB1->LOJA ))
	       nOpcao := fAltRegSE1()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Aten็ใo")
	            MSAguarde({|| AtuSaldo()},"Atualizando Fluxo de Caixa")
	        EndIf
	    EndIf
	    
	ENDIF
	
	IF cOrigem $ "MB/SB"  
		 MsgInfo("Registro nใo pode ser alterado...", "Aten็ใo")
	ENDIF
     
   
    RestArea(aAreaC7)
    RestArea(aAreaE2)
    RestArea(aAreaE1)
    RestArea(aArea)
Return
/**************************************/
//**********************************************************************
// Altera็ใo Ordem de Compra


static Function fAltRegSC7()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SC7->C7_NUM
Local oGet2
Local cGet2 := Posicione("SA2",1,xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA, "A2_NREDUZ")
Local oGet3
Local dVencto := SC7->C7_DATPRF
Local oGet4
Local oGet5	
Local oGet6	

Local nValor := 0
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4

Local _nOpc := 0
Static _oDlg

If SC7->( dbSeek(xFilial("SC7")+cGet1) )
	While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cGet1
		nValor += SC7->C7_TOTAL + ((SC7->C7_IPI/100) * SC7->C7_TOTAL)
		SC7->( dbSkip() )
	enddo
EndIf


  DEFINE MSDIALOG _oDlg TITLE "Altera Ordem de Compra" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL

    @ 006, 008 MSPANEL oPanel1 PROMPT "" SIZE 184, 088 OF _oDlg COLORS 0, 16777215 RAISED
    @ 000, 002 MSPANEL oPanel2 SIZE 179, 086 OF oPanel1 COLORS 0, 16777215 LOWERED
    @ 007, 006 SAY oSay1 PROMPT "Numero OC" SIZE 020, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 007, 063 SAY oSay2 PROMPT "Fornecedor" SIZE 032, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 006 SAY oSay3 PROMPT "Data Entrega" SIZE 050, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 063 SAY oSay4 PROMPT "Total OC " SIZE 030, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 004 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 049, 004 MSGET oGet3 VAR dVencto SIZE 044, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
   	@ 049, 061 MSGET oGet2 VAR  Transform(nValor,"@E 99,999,999.99") When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 073, 049 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL
    @ 073, 097 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1
  	
  	//SE1->E1_VENCTO 	:= dVencto
  	If SC7->( dbSeek(xFilial("SC7")+cGet1) )
  		
  		While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cGet1
  			Reclock("SC7",.F.)
		  	SC7->C7_DATPRF := DataValida(dVencto,.T.) //Proximo dia ๚til
		  	MsUnlock()
		  	SC7->( dbSkip() )
		  	
		enddo
		
	EndIf
  	
  Endif

   
  
Return _nOpc

// Altera็ใo registro Contas a Receber
static Function fAltRegSE1()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SE1->E1_NUM
Local oGet2
Local cGet2 := Posicione("SA1",1,xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, "A1_NREDUZ")
Local oGet3
Local dVencto := SE1->E1_VENCREA
Local oGet4
Local oGet5	:=  SE1->E1_TIPO
Local oGet6	:=  Posicione("SED",1,xFilial("SED") + ALLTRIM(SE1->E1_NATUREZ), "ED_XGRUPO")
Local nValor := SE1->E1_VALOR
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4

Local _nOpc := 0
Static _oDlg

  DEFINE MSDIALOG _oDlg TITLE "Altera Tํtulo" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL

    @ 006, 008 MSPANEL oPanel1 PROMPT "" SIZE 184, 088 OF _oDlg COLORS 0, 16777215 RAISED
    @ 000, 002 MSPANEL oPanel2 SIZE 179, 086 OF oPanel1 COLORS 0, 16777215 LOWERED
    @ 007, 006 SAY oSay1 PROMPT "Titulo" SIZE 020, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 007, 063 SAY oSay2 PROMPT "Cliente" SIZE 032, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 006 SAY oSay3 PROMPT "Vencimento" SIZE 030, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 063 SAY oSay4 PROMPT "Valor" SIZE 018, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 004 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 049, 004 MSGET oGet3 VAR dVencto SIZE 044, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    if alltrim(oGet5) <> "PR"
    	@ 049, 061 MSGET oGet2 VAR  Transform(nValor,"@E 99,999,999.99") When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    else
    	@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE1","E1_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    endif
    @ 073, 049 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL
    @ 073, 097 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1
  	Reclock("SE1",.F.)
  	//SE1->E1_VENCTO 	:= dVencto
  	SE1->E1_VENCREA := DataValida(dVencto,.T.) //Proximo dia ๚til
  	SE1->E1_VALOR	:= nValor
  	SE1->E1_VLCRUZ	:= nValor
  	SE1->E1_SALDO	:= nValor
  	MsUnlock()
  Endif
  
  Reclock("TRB1",.F.)
	if alltrim(oGet5) <> "PR"
		TRB1->DATAMOV := dVencto
		TRB1->DATAMOV2 := dVencto
		TRB1->CAMPO		:= RetCampo(dVencto)
		TRB1->GRUPONAT	:= oGet6
	else
		TRB1->DATAMOV := dVencto
		TRB1->DATAMOV2 := dVencto
		TRB1->VALOR := nValor
		TRB1->CAMPO		:= RetCampo(dVencto)
		TRB1->GRUPONAT	:= oGet6
	endif
  MsUnlock()
Return _nOpc

/**************************************/
Static Function zExpAnalitico()
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
    oFWMsExcel:AddworkSheet("Fluxo de caixa - Analํtico") 
        //Criando a Tabela
        oFWMsExcel:AddTable("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico")
        
        aAdd(aColunas, "Data Real")									// 1 Data
        aAdd(aColunas, "Vencimento")									// 1 Data
        aAdd(aColunas, "Banco")									// 2 Banco
        aAdd(aColunas, "Item Conta")							// 3 Item Conta
        aAdd(aColunas, "Prefixo")								// 4 Prefixo
        aAdd(aColunas, "No.Tํtulo/OC")							// 5 No.Titulo/OC
        aAdd(aColunas, "Parcela")								// 6 Parcela
        aAdd(aColunas, "Tipo")									// 7 Tipo
        aAdd(aColunas, "Natureza")								// 8 Natureza
        aAdd(aColunas, "Descri็ใo")								// 9 Descri็ใo Natureza
        aAdd(aColunas, "Cod.Cli./For.")							// 10 Codigo Cliente / Fornecedor
        aAdd(aColunas, "Cliente/Fornecedor")					// 11 Cliente / Fornecedor
        aAdd(aColunas, "Loja")									// 12 Loja
        aAdd(aColunas, "Valor")									// 13 Valor
        aAdd(aColunas, "Hist๓rico")								// 13 Hist๓rico
        aAdd(aColunas, "Origem")								// 14 Origem
                
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Data Real",2,4)					// 1 Data
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Vencimento",2,4)					// 1 Data
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Banco",1,2)					// 2 Banco
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Item Conta",1,2)			// 3 Item Conta
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Prefixo",1,2)				// 4 Prefixo
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "No.Tํtulo/OC",1,2)			// 5 No.Titulo/OC
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Parcela",1,2)				// 6 Parcela
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Tipo",1,2)					// 7 Tipo
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Natureza",1,2)				// 8 Natureza
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Descri็ใo",1,2)				// 9 Descri็ใo
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Cod.Cli./For.",1,2)			// 10 Codigo Cliente / Fornecedor
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Cliente/Fornecedor",1,2)	// 11 Cliente / Fornecedor
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Loja",1,2)					// 12 Loja
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Valor",1,2)					// 13 Valor
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Hist๓rico",1,2)					// 13 Valor
        oFWMsExcel:AddColumn("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , "Origem",1,2)				// 14 Origem
           
        While  !(TRB1->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB1->DATAMOV
        	aLinhaAux[2] := TRB1->VENCTO
        	aLinhaAux[3] := TRB1->BANCO
        	aLinhaAux[4] := TRB1->ITEMCONTA
        	aLinhaAux[5] := TRB1->PREFIXO
        	aLinhaAux[6] := TRB1->NTITULO
        	aLinhaAux[7] := TRB1->PARCELA
        	aLinhaAux[8] := TRB1->TIPOD
        	aLinhaAux[9] := TRB1->NATUREZA
        	aLinhaAux[10] := TRB1->DESC_NAT
        	aLinhaAux[11] := TRB1->CLIFOR
        	aLinhaAux[12] := TRB1->NCLIFOR
        	aLinhaAux[13] := TRB1->LOJA
        	aLinhaAux[14] := TRB1->VALOR
        	aLinhaAux[15] := TRB1->HISTORICO
        	aLinhaAux[16] := TRB1->ORIGEM

        		oFWMsExcel:AddRow("Fluxo de caixa - Analํtico","Fluxo de caixa - Analํtico" , aLinhaAux)
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

/***********************************/

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
    oFWMsExcel:AddworkSheet("ACCOUNTS RECEIVABLE") //Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("ACCOUNTS RECEIVABLE","ACCOUNTS RECEIVABLE  " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim)))
       
        aAdd(aColunas, "Job No.")								// 1 ITEM
        aAdd(aColunas, "Cliente Name")							// 2 CLIENTE
        aAdd(aColunas, "Total With taxes")	 					// 3 XVDCI
        aAdd(aColunas, "Total Without taxes")					// 4 XVDSI
        aAdd(aColunas, "Received until")						// 5 XRECUN
    
        for _ni := 1 to len(_aCpos1) // Monta campos com as datas
        	aAdd(aColunas,  substr(_aLegPer[_ni],4,7))
        next 
        
        aAdd(aColunas, "Other month")						// 0 XOTHMO
        aAdd(aColunas, "Total")								// 0 XTOTAL
                
        For nAux := 1 To Len(aColunas)
            oFWMsExcel:AddColumn("ACCOUNTS RECEIVABLE","ACCOUNTS RECEIVABLE  " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim)), aColunas[nAux],1,2)
        Next
           
        nAux := 0 
         
        While  !(TRB2->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB2->ITEM
        	aLinhaAux[2] := TRB2->CLIENTE
        	aLinhaAux[3] := TRB2->XVDCI
        	aLinhaAux[4] := TRB2->XVDSI
        	aLinhaAux[5] := TRB2->XRECUN
                	
        	nAux := 6
        	For _ni := 1 To Len(_aCpos1)
        		aLinhaAux[nAux] := &("TRB2->" + _aCpos1[_ni])
        		nAux++
        	next 
          
        	aLinhaAux[13] := TRB2->XOTHMO
        	aLinhaAux[14] := TRB2->XTOTAL
        	
        	oFWMsExcel:AddRow("ACCOUNTS RECEIVABLE","ACCOUNTS RECEIVABLE  " + dtoc(FirstDate(_dDataIni)) + " to " + dtoc(LastDate(_dDataFim)), aLinhaAux)

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
ฑฑบPrograma  ณShowAnalitบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function zExFuA()
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro := "Fluxo de caixa - Analํtico " 

TRB1->(dbclearfil())

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
/*
if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0 .or. (empty(TRB2->GRUPOSUP) .and. !empty(TRB2->GRUPO))
	return
endif
*/

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
/*
cFiltra := " alltrim(CAMPO) == '" + alltrim(_cCampo) + "' .and. alltrim(GRUPONAT) == '" + alltrim(TRB2->GRUPO) + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
*/
// Monta aHeader do TRB1
aadd(aHeader, {"Data Real"	,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Vencimento"	,"VENCTO"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Banco"		,"BANCO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Item Conta"	,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Prefixo"	,"PREFIXO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"No.Titulo/OC","NTITULO"	,"",09,0,"","","C","TRB1","R"})
aadd(aHeader, {"Parcela"	,"PARCELA"	,"",01,0,"","","C","TRB1","R"})
aadd(aHeader, {"Tipo"		,"TIPOD"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Natureza"	,"NATUREZA"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descri็ใo"	,"DESC_NAT"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cod.Cli/For","CLIFOR"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cli/For"	,"NCLIFOR"	,"",20,0,"","","C","TRB1","R"})
aadd(aHeader, {"Loja"		,"LOJA"		,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Valor"		,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Hist๓rico"	,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Fluxo de caixa - Analํtico Geral"  From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")


@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA ORIGEM: MB - Movimento Bancแrio / CR - Contas a Receber / CP - Contas a Pagar / OC - Ordem de Compras / PV - Pedido de Vendas "  COLORS 0, 16777215 PIXEL

_oGetDbAnalit:oBrowse:BlDblClick := {|| EditReg() }
//_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

aadd(aButton , { "BMPTABLE3" , { || zExpAnalitico()}, "Gerar Plan. Excel " } )

_oGetDbAnalit:ForceRefresh()
_oDlgAnalit:Refresh()

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())

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
Local _dDTIni
Local _dDTFin
Local dDataX
Local nUM := 1
local _ni

if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Nใo foi possํvel abrir o arquivo ACCREC.XLS pois ele pode estar aberto por outro usuแrio.")
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
aAdd(aStru,{"DATAMOV"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"VENCTO"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"BANCO"		,"C",03,0}) // Banco
aAdd(aStru,{"ITEMCONTA"	,"C",13,0}) // Item Conta
aAdd(aStru,{"CLIFOR"	,"C",10,0}) // Codigo Cliente / Fornecedor
aAdd(aStru,{"NCLIFOR"	,"C",20,0}) // Nome Cliente / Fornecedor
aAdd(aStru,{"LOJA"		,"C",02,0}) // Loja
aAdd(aStru,{"PREFIXO"	,"C",03,0}) // Prefixo
aAdd(aStru,{"NTITULO"	,"C",09,0}) // Numero de Titulo
aAdd(aStru,{"PARCELA"	,"C",01,0}) // Parcela
aAdd(aStru,{"TIPOD"		,"C",03,0}) // Tipo
aAdd(aStru,{"HISTORICO"	,"C",100,0}) // Historico
aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
aAdd(aStru,{"RECPAG"	,"C",01,0}) // (R)eceber ou (P)agar
aAdd(aStru,{"TIPO"		,"C",01,0}) // Tipo - (P)revisto ou (R)ealizado
aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"NATUREZA"	,"C",10,0}) // Codigo da Natureza
aAdd(aStru,{"DESC_NAT"	,"C",30,0}) // Descricao da Natureza
aAdd(aStru,{"GRUPONAT"	,"C",10,0}) // Grupos de Natureza
aAdd(aStru,{"CAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico
aAdd(aStru,{"DATAMOV2"	,"D",08,0}) // Data de movimentacao
//aAdd(aStru,{"SIMULADO"	,"C",01,0}) // Indica se o registro foi gerado por uma simulacao

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)

aStru := {}
aAdd(aStru,{"ITEM"		,"C",25,0}) // Codigo da Natureza
aAdd(aStru,{"CLIENTE"	,"C",40,0}) // Descricao da Natureza
aAdd(aStru,{"XVDCI"		,"N",15,2}) // Descricao da Natureza
aAdd(aStru,{"XVDSI"		,"N",15,2}) // Descricao da Natureza
aAdd(aStru,{"XRECUN"	,"N",15,2}) // Descricao da Natureza

for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	aAdd(aStru,{ _aCpos1[_ni] ,"N",15,2}) // Valor do movimento no di
next _dData
aAdd(aStru,{"XOTHMO"	,"N",15,2}) // Descricao da Natureza
aAdd(aStru,{"XTOTAL"	,"N",15,2}) // Descricao da Natureza
aAdd(aStru,{"ORDEM"		,"C",10,0}) // Ordem de apresentacao
aAdd(aStru,{"XDELMON"	,"D",8,0}) // Valor total dos movimentos
aAdd(aStru,{"XDELMON2"	,"C",7,0}) // Valor total dos movimentos


dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
//index on ORDEM to &(cArqTrb2+"2")
index on ITEM to &(cArqTrb2+"1")
index on ITEM to &(cArqTrb2+"2")
set index to &(cArqTrb2+"1")


aStru := {}
aAdd(aStru,{"DESC"		,"C",10,0}) 

for _ni := 1 to len(_aCpos1) // Monta campos com as datas
	aAdd(aStru,{ _aCpos1[_ni] ,"N",15,2}) // Valor do movimento no di
next _dData
aAdd(aStru,{"XOTHMO"	,"N",15,2}) // Descricao da Natureza

dbcreate(cArqTrb3,aStru)
dbUseArea(.T.,,cArqTrb3,"TRB3",.F.,.F.)
//index on ORDEM to &(cArqTrb2+"2")


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