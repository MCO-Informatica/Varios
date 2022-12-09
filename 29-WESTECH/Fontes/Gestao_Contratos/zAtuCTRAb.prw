#include 'parmtype.ch'
#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include 'totvs.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFIN01    ºAutor  ³Marcos Zanetti GZ   º Data ³  19/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo de fluxo de caixa                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico 		                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function zAtuCTRAb()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Geração de planilha de Project Status"
local _cOldData	:= 	dDataBase // Grava a database

//private cPerg 	:= 	"ZATUCTR01"
//private _cArq	:= 	"ZATUCTR01.XLS"
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


//ValidPerg()

/*
AADD(aSays,"Este programa gera planilha com os dados para o Custo de Contrato.  ")
AADD(aSays,"O arquivo gerado pode ser aberto de forma automática")
AADD(aSays,"pelo Excel.")
AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )
*/
// Se confirmado o processamento
//if nOpcA == 1

	if !AbreArq()
		return
	endif

		//MSAguarde({||PFIN01REAL()},"Fluxo de caixa Realizado")
	//if MV_PAR06 = 1 .OR. MV_PAR08 = 1
		MSAguarde({||PFIN01REAL()},"Processando Contratos")
	//endif

	
	MSAguarde({||GC01SINT()},"Custos de Contratos")
	
	MontaTela()
	
	TRB1->(dbclosearea())


//endif


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFIN01REALº												   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa o Project Status EQ / ST	                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function PFIN01REAL()
//**************** Variaveis de Item Conta  ***************************//
local _cQuery 		:= ""
Local _cFilCTD 		:= xFilial("CTD")
Local QUERY 		:= ""
Local cItemConta	:= ""

//**************** Variaveis de Ordens de Compras *********************//
Local _cFilSC7 		:= xFilial("SC7")
Local dData
Local nValor 		:= 0
Local nTotSC7 		:= 0
local dDataM2
local _cQuery_SC7 	:= ""
local QUERY_SC7 	:= ""
//**************** Variaveis de Ordens de Compras *********************//
Local _cFilSM2 		:= xFilial("SM2")
local _cQuery_SM2 	:= ""
local QUERY_SM2 	:= ""
//**************** Variaveis de Documento de Entrada ******************//
local _cQuery_SD1 := ""
Local _cFilSD1 		:= xFilial("SD1")
Local nTotSD1 		:= 0
local QUERY_SD1 	:= ""
//**************** Variaveis de Documento de Entrada Comissao *********//
local _cQuery_SD1A 	:= ""
Local _cFilSD1A 	:= xFilial("SD1")
Local nTotSD1A 		:= 0
local QUERY_SD1A 	:= ""
//**************** Variaveis de Documento de Entrada Rateio ***********//
local _cQuery_SDE 	:= ""
Local _cFilSDE 		:= xFilial("SDE")
Local nTotSDE 		:= 0
local QUERY_SDE		:= ""
//**************** Variaveis de Documento de Entrada Rateio Comissoes *//
local _cQuery_SDEB 	:= ""
Local _cFilSDEB 	:= xFilial("SDE")
Local nTotSDEB 		:= 0
local QUERY_SDEB	:= ""
//**************** Variaveis de Contas a Pagar ***********************//
local _cQuery_SE2 	:= ""
Local _cFilSE2 		:= xFilial("SE2")
Local nTotSE2 		:= 0
local QUERY_SE2		:= ""
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
//**************** Variaveis de Contas a Pagar Rateio ******************//
local _cQuery_CV4 := ""
Local _cFilCV4 := xFilial("CV4")
Local nTotCV4 := 0
local QUERY_CV4	:= ""
//**************** Variaveis de Apontamento de Horas ******************//
local _cQuery_SZ4 := ""
Local _cFilSZ4 := xFilial("SZ4")
Local nTotSZ4 := 0
local QUERY_SZ4	:= ""
//**************** Variaveis de Custos Diversos 2 *********************//
local _cQuery_ZZA := ""
Local _cFilZZA := xFilial("ZZA")
Local nTotZZA := 0
local QUERY_ZZA	:= ""
//*************** Conexao com Tabel CTD - Item Conta******************//
	CTD->(dbsetorder(1)) 
	
	ChkFile("CTD",.F.,"QUERY") 
	IndRegua("QUERY",CriaTrab(NIL,.F.),"CTD_ITEM",,,"Selecionando Registros...")
	
	ProcRegua(QUERY->(reccount()))
	
	CTD->(dbgotop())
	CTD->(dbsetorder(1))

//**************************************************************************//



while QUERY->(!eof())

	if Empty(ALLTRIM(QUERY->CTD_ITEM)) 
		QUERY->(dbskip())
		Loop
	endif
	
	if SUBSTR(QUERY->CTD_ITEM,9,2) == '10' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '11' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '12' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '14' .OR. SUBSTR(QUERY->CTD_ITEM,9,2) == '09'
		QUERY->(dbskip())
		Loop
	endif

	if ALLTRIM(QUERY->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/ESTOQUE/OPERACOES'
		QUERY->(dbskip())
		Loop
	endif

	if QUERY->CTD_DTEXSF < DDATABASE
		QUERY->(dbskip())
		Loop
	endif
		
	if QUERY->CTD_DTEXSF >= DDATABASE
		QUERY->(dbskip())
		Loop
	endif

	//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		cItemConta		:= QUERY->CTD_ITEM
		
		
		//**************** Conexao com Tabel SC7 - Ordem de Compra ******************//
		/*
		SC7->(dbsetorder(23)) 
		
		ChkFile("SC7",.F.,"QUERY_SC7") // Alias dos movimentos bancarios
		IndRegua("QUERY_SC7",CriaTrab(NIL,.F.),"C7_EMISSAO",,,"Selecionando Registros...")
		
		ProcRegua(QUERY_SC7->(reccount()))
		
		QUERY_SC7->(dbgotop())
		*/
		dbSelectArea("SC7")
		//SM2->( dbSetOrder(1) )
	
		_cQuery_SC7 := "SELECT CAST(C7_EMISSAO AS DATE) AS 'TMP_EMISC7', C7_ENCER, C7_XTOTSI, C7_ITEMCTA, C7_MOEDA FROM SC7010  WHERE  D_E_L_E_T_ <> '*' ORDER BY C7_EMISSAO"
	
		IF Select("_cQuery_SC7") <> 0
			DbSelectArea("_cQuery_SC7")
			DbCloseArea()
		ENDIF
	
		//crio o novo alias
		TCQUERY _cQuery_SC7 NEW ALIAS "QUERY_SC7"
	
		dbSelectArea("QUERY_SC7")
		QUERY_SC7->(dbGoTop())
		
		//**************** Conexao com Tabel SM2 - Moeda ***************************//
		dbSelectArea("SM2")
		//SM2->( dbSetOrder(1) )
	
		_cQuery_SM2 := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"
	
		IF Select("_cQuery_SM2") <> 0
			DbSelectArea("_cQuery_SM2")
			DbCloseArea()
		ENDIF
	
		//crio o novo alias
		TCQUERY _cQuery_SM2 NEW ALIAS "QUERY_SM2"
	
		dbSelectArea("QUERY_SM2")
		QUERY_SM2->(dbGoTop())
	
		//**************************************************************************//
		 
		//************** Soma de Custos de Ordens de Compra *****************//
		while QUERY_SC7->(!eof())
			
			MsProcTxt("Processando Ordem de Compra: "+alltrim(QUERY->CTD_ITEM))
			ProcessMessage()
		
			if alltrim(QUERY_SC7->C7_ITEMCTA) == alltrim(QUERY->CTD_ITEM) .and. alltrim(QUERY_SC7->C7_ENCER) == ""
		
					if QUERY_SC7->C7_MOEDA = 2
					dData := QUERY_SC7->TMP_EMISC7
					//msginfo ( dData )
					while QUERY_SM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
		
						while  QUERY_SM2->(!eof())
							
							nValor := QUERY_SM2->M2_MOEDA2
						
							if dData == QUERY_SM2->TMP_DATA .AND. nValor > 0
								nValor := QUERY_SM2->M2_MOEDA2
								Exit
							else
								QUERY_SM2->(dbSkip())
							endif
		
						enddo
						if dData == QUERY_SM2->TMP_DATA .AND. nValor > 0
							exit
						ENDIF
						dData--
						
					enddo
					
					nTotSC7	+= QUERY_SC7->C7_XTOTSI * nValor
					
		
				elseif QUERY_SC7->C7_MOEDA = 3
					dData := QUERY_SC7->TMP_EMISC7
					//msginfo ( dData )
					while QUERY_SM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
		
						while  QUERY_SM2->(!eof())
							
							nValor := QUERY_SM2->M2_MOEDA3
						
							if dData == QUERY_SM2->TMP_DATA .AND. nValor > 0
								nValor := QUERY_SM2->M2_MOEDA3
								Exit
							else
								QUERY_SM2->(dbSkip())
							endif
		
						enddo
						if dData == QUERY_SM2->TMP_DATA .AND. nValor > 0
							exit
						ENDIF
						dData--
					enddo
					
					nTotSC7	+=  QUERY_SC7->C7_XTOTSI * nValor
					
		
				elseif QUERY_SC7->C7_MOEDA = 4
					dData := QUERY_SC7->TMP_EMISC7
					//msginfo ( dData )
					while QUERY_SM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
		
						while  QUERY_SM2->(!eof())
							
							nValor := QUERY_SM2->M2_MOEDA4
						
							if dData == QUERY_SM2->TMP_DATA .AND. nValor > 0
								nValor := QUERY_SM2->M2_MOEDA4
								Exit
							else
								QUERY_SM2->(dbSkip())
							endif
		
						enddo
						if dData == QUERY_SM2->TMP_DATA .AND. nValor > 0
							exit
						ENDIF
						dData--
					enddo
					nTotSC7	+=  QUERY_SC7->C7_XTOTSI * nValor
					
				else
					nTotSC7	+=  QUERY_SC7->C7_XTOTSI
					
				endif
		
			endif
		
			QUERY_SC7->(dbskip())
		
		enddo
		//********************* Fim Custos Ordens de Compra ******************//
		
		//**************** Conexao com Tabel SD1 - Documento de Entrada ******//
		_cQuery_SD1 := "SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO' , D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, D1_CUSTO, D1_FORNECE  FROM SD1010  WHERE  D_E_L_E_T_ <> '*' AND D1_ITEMCTA = '" + cItemConta + "' ORDER BY D1_EMISSAO"

		IF Select("_cQuery_SD1") <> 0
			DbSelectArea("_cQuery_SD1")
			DbCloseArea()
		ENDIF
	
		//crio o novo alias
		TCQUERY _cQuery_SD1 NEW ALIAS "QUERY_SD1"
	
		dbSelectArea("QUERY_SD1")
		QUERY_SD1->(dbGoTop())
		
		//************** Soma de Custos de Documento de Entrada *************//
		while QUERY_SD1->(!eof())
		
			MsProcTxt("Processando Documento de Entrada: "+alltrim(QUERY->CTD_ITEM))
			ProcessMessage()

			if alltrim(QUERY_SD1->D1_ITEMCTA) == alltrim(QUERY->CTD_ITEM);
				.AND. ! alltrim(QUERY_SD1->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') .AND. QUERY_SD1->D1_RATEIO == '2';
				.AND. ! alltrim(QUERY_SD1->D1_XNATURE) $ ('6.21.00/6.22.00') .AND. QUERY_SD1->D1_RATEIO == '2'
				
				nTotSD1	+= QUERY_SD1->D1_CUSTO
		
			endif
		
			QUERY_SD1->(dbskip())
		
		enddo
		//********************* Fim Custos Documento de Entrada **************//
		
		//**************** Conexao com Tabel SD1 - Documento de Entrada Comissao ******//
		_cQuery_SD1A := "SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO' , D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, D1_CUSTO, D1_FORNECE  FROM SD1010  WHERE  D_E_L_E_T_ <> '*' AND D1_ITEMCTA = '" + cItemConta + "' ORDER BY D1_EMISSAO"

		IF Select("_cQuery_SD1A") <> 0
			DbSelectArea("_cQuery_SD1A")
			DbCloseArea()
		ENDIF
	
		//crio o novo alias
		TCQUERY _cQuery_SD1A NEW ALIAS "QUERY_SD1A"
	
		dbSelectArea("QUERY_SD1A")
		QUERY_SD1A->(dbGoTop())
		
		//************** Soma de Custos de Documento de Entrada Comissao **************//
		while QUERY_SD1A->(!eof())
			
			MsProcTxt("Processando Comissoes: "+alltrim(QUERY->CTD_ITEM))
			ProcessMessage()

			if alltrim(QUERY_SD1A->D1_ITEMCTA) ==  alltrim(QUERY->CTD_ITEM);
				.AND. ! alltrim(QUERY_SD1A->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') .AND. QUERY_SD1A->D1_RATEIO == '2';
				.AND. alltrim(QUERY_SD1A->D1_XNATURE) $ ('6.21.00/6.22.00') .AND. QUERY_SD1A->D1_RATEIO == '2'
				
				nTotSD1A	+= QUERY_SD1A->D1_CUSTO
		
			endif
		
			QUERY_SD1A->(dbskip())
		
		enddo
		//********************* Fim Custos Documento de Entrada Comissao **************//
		//**************** Conexao com Tabel SDE - Documento de Entrada Rateio ********//
		SD1->(dbsetorder(13)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

		ChkFile("SDE",.F.,"QUERY_SD2") // Alias dos movimentos bancarios
		IndRegua("QUERY_SD2",CriaTrab(NIL,.F.),"QUERY_SD2->DE_DOC",,,"Selecionando Registros...")
		
		ProcRegua(QUERY_SD2->(reccount()))
		
		QUERY_SD2->(dbgotop())
		//************** Soma de Custos de Documento de Entrada Rateio ****************//
		while QUERY_SD2->(!eof())
		
			MsProcTxt("Processando Rateio NF: "+alltrim(QUERY->CTD_ITEM))
			ProcessMessage()

			if QUERY_SD2->DE_ITEMCTA == alltrim(QUERY->CTD_ITEM);
				.AND. ! alltrim(POSICIONE("SD1",13,XFILIAL("SD1")+QUERY_SD2->DE_DOC+QUERY_SD2->DE_FORNECE,"D1_CF")) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') ;
				.AND. ! POSICIONE("SD1",13,XFILIAL("SD1")+QUERY_SD2->DE_DOC+QUERY_SD2->DE_FORNECE+QUERY_SD2->DE_ITEMNF,"D1_XNATURE") $ ('6.21.00/6.22.00') ;
				
				nTotSDE		+= QUERY_SD2->DE_CUSTO1
				
			endif
		
			QUERY_SD2->(dbskip())
		
		enddo
		//********************* Fim Custos Documento de Entrada Rateio  *********************//
		//**************** Conexao com Tabel SDEB - Documento de Entrada Rateio Comissao ****//
		SD1->(dbsetorder(13)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

		ChkFile("SDE",.F.,"QUERY_SDEB") // Alias dos movimentos bancarios
		IndRegua("QUERY_SDEB",CriaTrab(NIL,.F.),"QUERY_SDEB->DE_DOC",,,"Selecionando Registros...")
		
		
		ProcRegua(QUERY->(reccount()))
		
		QUERY_SDEB->(dbgotop())
		//************** Soma de Custos de Documento de Entrada Rateio Comissao *************//
		while QUERY_SDEB->(!eof())
		
			MsProcTxt("Processando Rateio NF Comissao: "+alltrim(QUERY->CTD_ITEM))
			ProcessMessage()

			if QUERY_SDEB->DE_ITEMCTA == alltrim(QUERY->CTD_ITEM);
				.AND. ! alltrim(POSICIONE("SD1",13,XFILIAL("SD1")+QUERY_SDEB->DE_DOC+QUERY_SDEB->DE_FORNECE,"D1_CF")) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') ;
				.AND. POSICIONE("SD1",13,XFILIAL("SD1")+QUERY_SDEB->DE_DOC+QUERY_SDEB->DE_FORNECE+QUERY_SDEB->DE_ITEMNF,"D1_XNATURE") $ ('6.21.00/6.22.00')
				
				nTotSDEB		+= QUERY_SDEB->DE_CUSTO1
				
			endif
		
			QUERY_SDEB->(dbskip())
		
		enddo
		
		//********************* Fim Custos Documento de Entrada Rateio Comissao *************//	
		//**************** Conexao com Tabel SE2 - Contas a Pagar ***************************//	
		_cQuery_SE2 := "SELECT CAST(E2_BAIXA AS DATE) TMP_BAIXA, E2_TIPO, E2_NUM, E2_NATUREZ, E2_HIST, E2_VLCRUZ, E2_FORNECE, E2_NATUREZ, E2_XXIC, E2_RATEIO, "
		_cQuery_SE2 += " E2_TIPO,E2_XIPI,E2_XII,E2_XCOFINS,E2_XPIS,E2_XICMS,E2_XSISCO,E2_XSDA,E2_XTERM,E2_XTRANSP,E2_XFRETE,E2_XFUMIG,E2_XARMAZ,E2_XAFRMM,E2_XCAPA,E2_XCOMIS,E2_XISS,E2_XIRRF, "
		_cQuery_SE2 += " E2_XCTII,E2_XCTIPI,E2_XCTCOF,E2_XCTPIS,E2_XCTICMS,E2_XCTSISC,E2_XCTSDA,E2_XCTTEM,E2_XCTTRAN,E2_XCTFRET,E2_XCTFUM,E2_XCTARM,E2_XCTAFRM,E2_XCTCAPA,E2_XCTCOM,E2_XCTISS,E2_XCTIRRF "
		_cQuery_SE2 += " FROM SE2010  WHERE  D_E_L_E_T_ <> '*' AND E2_XXIC = '" + cItemConta + "' ORDER BY E2_BAIXA "
		
		IF Select("_cQuery_SE2") <> 0
			DbSelectArea("_cQuery_SE2")
			DbCloseArea()
		ENDIF
	
		//crio o novo alias
		TCQUERY _cQuery_SE2 NEW ALIAS "QUERY_SE2"
	
		dbSelectArea("QUERY_SE2")
		QUERY_SE2->(dbGoTop())
		
		//************** Soma de Custos de Contas a Pagar ***********************************//
		while QUERY_SE2->(!eof())
		
			MsProcTxt("Processando Contas a Pagar: "+alltrim(QUERY->CTD_ITEM))
			ProcessMessage()

			if QUERY_SE2->E2_XXIC == alltrim(QUERY->CTD_ITEM) .AND. !ALLTRIM(QUERY_SE2->E2_TIPO) $ ("NF/PR/PA/TX/ISS/INS/INV") .AND. ALLTRIM(QUERY_SE2->E2_RATEIO) == "N" //.AND. !EMPTY(QUERY->E2_BAIXA)
				
				if QUERY_SE2->E2_XCTIPI = "2"
					nXIPI := QUERY_SE2->E2_XIPI
				else
					nXIPI := 0
				endif
				
				if QUERY_SE2->E2_XCTII = "2"
					nXII := QUERY_SE2->E2_XII
				else
					nXII := 0
				endif
				
				if QUERY_SE2->E2_XCTCOF = "2"
					nXCOFINS := QUERY_SE2->E2_XCOFINS
				else
					nXCOFINS := 0
				endif
				
				if QUERY_SE2->E2_XCTPIS = "2"
					nXPIS := QUERY_SE2->E2_XPIS
				else
					nXPIS := 0
				endif
				
				if QUERY_SE2->E2_XCTICMS = "2"
					nXICMS := QUERY_SE2->E2_XICMS
				else
					nXICMS := 0
				endif
				
				if QUERY_SE2->E2_XCTSISC = "2"
					nXSISCO := QUERY_SE2->E2_XSISCO
				else
					nXSISCO := 0
				endif
				
				if QUERY_SE2->E2_XCTSDA = "2"
					nXSDA := QUERY_SE2->E2_XSDA
				else
					nXSDA := 0
				endif
				
				if QUERY_SE2->E2_XCTTEM = "2"
					nXTERM := QUERY_SE2->E2_XTERM
				else
					nXTERM := 0
				endif
				
				if QUERY_SE2->E2_XCTTRAN = "2"
					nXTRANSP := QUERY_SE2->E2_XTRANSP
				else
					nXTRANSP := 0
				endif
				
				if QUERY_SE2->E2_XCTFRET = "2"
					nXFRETE := QUERY_SE2->E2_XFRETE
				else
					nXFRETE := 0
				endif
				
				if QUERY_SE2->E2_XCTFUM = "2"
					nXFUMIG := QUERY_SE2->E2_XFUMIG
				else
					nXFUMIG := 0
				endif
				
				if QUERY_SE2->E2_XCTARM = "2"
					nXARMAZ := QUERY_SE2->E2_XARMAZ
				else
					nXARMAZ := 0
				endif
				
				if QUERY_SE2->E2_XCTAFRM = "2"
					nXAFRMM := QUERY_SE2->E2_XAFRMM
				else
					nXAFRMM := 0
				endif
				
				if QUERY_SE2->E2_XCTCAPA = "2"
					nXCAPA := QUERY_SE2->E2_XCAPA
				else
					nXCAPA := 0
				endif
				
				if QUERY_SE2->E2_XCTCOM = "2"
					nXCOMIS := QUERY_SE2->E2_XCOMIS
				else
					nXCOMIS := 0
				endif
				
				if QUERY_SE2->E2_XCTISS = "2"
					nXISS := QUERY_SE2->E2_XISS
				else
					nXISS := 0
				endif
				
				if QUERY_SE2->E2_XCTIRRF = "2"
					nXIRRF := QUERY_SE2->E2_XIRRF
				else
					nXIRRF := 0
				endif
				
				nTotSE2		+= QUERY_SE2->E2_VLCRUZ - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
		
			endif
		
			QUERY_SE2->(dbskip())
		
		enddo
		//********************* Fim Custos Contas a Pagar ***********************************//	
		//**************** Conexao com Tabel SE2 - Contas a Pagar Rateio ********************//
		CV4->(dbsetorder(2)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

		ChkFile("CV4",.F.,"QUERY_CV4") // Alias dos movimentos bancarios
		IndRegua("QUERY_CV4",CriaTrab(NIL,.F.),"CV4_DTSEQ",,,"Selecionando Registros...")
		
		ProcRegua(QUERY_CV4->(reccount()))
		
		QUERY_CV4->(dbgotop())
		//************** Soma de Custos de Contas a Pagar Rateio ****************************//	
		while QUERY_CV4->(!eof())
			
			MsProcTxt("Processando Contas a Pagar Rateio: "+alltrim(QUERY->CTD_ITEM))
			ProcessMessage()

			if QUERY_CV4->CV4_ITEMD == alltrim(QUERY->CTD_ITEM)
		
				nTotCV4		+= QUERY_CV4->CV4_VALOR
		
			endif
		
			QUERY_CV4->(dbskip())
		
		enddo
		//********************* Fim Custos Contas a Pagar Rateio ****************************//	
		//**************** Conexao com Tabel SZ4 - Apontamento de Horas  ********************//
		ChkFile("SZ4",.F.,"QUERY_SZ4") // Alias dos movimentos bancarios
		IndRegua("QUERY_SZ4",CriaTrab(NIL,.F.),"Z4_FILIAL+Z4_ITEMCTA",,,"Selecionando Registros...")
		
		ProcRegua(QUERY_SZ4->(reccount()))
		
		QUERY_SZ4->(dbgotop())
		//************** Soma de Custos de Apontamento de Horas *****************************//	
		while QUERY_SZ4->(!eof())
		
			MsProcTxt("Processando Horas: "+alltrim(QUERY->CTD_ITEM))
			ProcessMessage()

			if QUERY_SZ4->Z4_ITEMCTA == alltrim(QUERY->CTD_ITEM)
		
				nTotSZ4 += QUERY_SZ4->Z4_TOTVLR
				
			endif
		
			QUERY_SZ4->(dbskip())
		
		enddo
		//********************* Fim Custos Apontamento de Horas  ****************************//
		//**************** Conexao com Tabel ZZA - Custos Diversos 2  ***********************//
		ZZA->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

		ChkFile("ZZA",.F.,"QUERY_ZZA") // Alias dos movimentos bancarios
		IndRegua("QUERY_ZZA",CriaTrab(NIL,.F.),"ZZA_DATA",,,"Selecionando Registros...")
		
		ProcRegua(QUERY_ZZA->(reccount()))
		
		QUERY_ZZA->(dbgotop())
		
		//************** Soma de Custos Diversos 2 ******************************************//	
		while QUERY_ZZA->(!eof())
		
			MsProcTxt("Processando Custos Diversos 2: "+alltrim(QUERY->CTD_ITEM))
			ProcessMessage()

			if QUERY_ZZA->ZZA_ITEMIC == alltrim(QUERY->CTD_ITEM)
		
				nTotZZA		+= QUERY_ZZA->ZZA_VALOR
				
			endif
		
			QUERY_ZZA->(dbskip())
		
		enddo
		//********************* Fim Custos Diversos 2  **************************************//
		//***********************************************************************************//
		
		
		TRB1->VALOR		:= nTotSC7 + nTotSD1 + nTotSDE + nTotSDEB + nTotSE2 + nTotCV4 + nTotSZ4 + nTotZZA
		TRB1->VALOR2	:= nTotSC7 + nTotSD1 + nTotSDE + nTotSDEB + nTotSD1A + nTotSE2 + nTotCV4 + nTotSZ4 + nTotZZA
		TRB1->ORIGEM	:= "CT"
		TRB1->ITEMCONTA := cItemConta
		TRB1->CAMPO		:= "VLREMP"
		
		nTotSC7 	:= 0
		nTotSD1 	:= 0
		nTotSD1A 	:= 0	
		nTotSDE 	:= 0
		nTotSE2		:= 0
		nTotSDEB	:= 0
		nTotCV4		:= 0
		nTotSZ4		:= 0
		nTotZZA		:= 0
		
			
		//*******************************************************************//
		MsUnlock()
			
	QUERY->(dbskip())
	QUERY_SC7->(dbclosearea())
	QUERY_SM2->(dbclosearea())
	QUERY_SD1->(dbclosearea())
	QUERY_SD1A->(dbclosearea())
	//QUERY_SD1B->(dbclosearea())
	QUERY_SD2->(dbclosearea())
	QUERY_SDEB->(dbclosearea())
	QUERY_SE2->(dbclosearea())
	QUERY_CV4->(dbclosearea())
	QUERY_SZ4->(dbclosearea())
	QUERY_ZZA->(dbclosearea())
enddo
	

QUERY->(dbclosearea())
//QUERY_SC7->(dbclosearea())
//QUERY_SM2->(dbclosearea())

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


Local nCPRVal	:= 0
Local nCPRTot	:= 0
Local nAvalIC1	:= ""

private _cOrdem := "000001"



	// EMPENHADO
		TRB1->(dbgotop())
		
		While TRB1->( ! EOF() )
		
			dbSelectArea("CTD")
			CTD->(dbSetOrder(1))
			CTD->(dbgotop()) 
			nAvalIC1 := TRB1->ITEMCONTA
			
			while CTD->( ! EOF() )
				MsProcTxt("Atualizando Custos de Contratos: "+alltrim(TRB1->ITEMCONTA))
				ProcessMessage()
				
				IF ALLTRIM(CTD->CTD_ITEM) == alltrim(nAvalIC1)
					RecLock("CTD",.F.)            
						CTD->CTD_XACPR  := TRB1->VALOR
						CTD->CTD_XACTO  := TRB1->VALOR2
		            MsUnlock()  
		        ENDIF
		        CTD->( dbSkip() ) 
		    ENDDO
            TRB1->( dbSkip() ) 
		EndDo

CTD->(dbclosearea())		

return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaTela ºAutor  ³Marcos Zanetti GZ   º Data ³  01/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta a tela de visualizacao do Fluxo Sintetico            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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


// Monta aHeader do TRB2

aadd(aHeader, {"Origem"			,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Custo de Producao"	,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Custo de Total"	,"VALOR2"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Item Conta"		,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Campo"			,"CAMPO"		,"",10,0,"","","C","TRB1","R"})


DEFINE MSDIALOG _oDlgSint ;
TITLE "Projec Status"  ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB1")

//aadd(aButton , { "SIMULACAO", { || GerSimul(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), TRB12->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh() }, "Simulação" } )
aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return


static function AbreArq()
local aStru 	:= {}
local _cCpoAtu
local _ni

// monta arquivo analitico
aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
aAdd(aStru,{"VALOR2"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"ITEMCONTA"	,"C",13,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"CAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico


dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)

return(.T.)


