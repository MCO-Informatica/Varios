#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
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
user function zProcCust()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Custo de Contratos"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg01	:= 	"VPERGPC"
private _cArq	:= 	"VPERGPC.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
private _cItemConta 
private _cFilial 	:= ALLTRIM(CTD->CTD_FILIAL)

private _cNProp
private _cCodCoord
private _cNomCoord

private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)
private cArqTrb4 := CriaTrab(NIL,.F.)


Private _aGrpSint:= {}


/*
AADD(aSays,"Este programa gera planilha com os dados para o Project Status.  ")
AADD(aSays,"O arquivo gerado pode ser aberto de forma automแtica")
AADD(aSays,"pelo Excel.")
AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )
*/

ValidPergPC()

// Se confirmado o processamento
//if nOpcA == 1
	CTD->(dbsetorder(1))
	CTD->(dbgotop())

	pergunte(cPerg01,.F.)
	
	// Faz consistencias iniciais para permitir a execucao da rotina
	//if !VldParam() .or. !AbreArq()
		//return
	//endif
	
	
	
while CTD->(!eof())
	
	if ALLTRIM(CTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/ENGENHARIA/ATIVO/XXXXXX/ZZZZZZZZZZZZZ/QUALIDADE/ESTOQUE/OPERACOES'
		CTD->(dbskip())
		Loop
	endif
	
	if empty(CTD->CTD_ITEM)
		CTD->(dbskip())
		Loop
	endif
	/*
	if SUBSTR(CTD->CTD_ITEM,9,2) == '10' .OR. SUBSTR(CTD->CTD_ITEM,9,2) == '11' .OR. SUBSTR(CTD->CTD_ITEM,9,2) == '12' .OR. SUBSTR(CTD->CTD_ITEM,9,2) == '13' ;
		.OR. SUBSTR(CTD->CTD_ITEM,9,2) == '14' .OR. SUBSTR(CTD->CTD_ITEM,9,2) == '09'
		CTD->(dbskip())
		Loop
	endif
	
	if MV_PAR01 = 2 .AND. ALLTRIM(SUBSTR(CTD->CTD_ITEM,1,2)) = 'AT'
		CTD->(dbskip())
		Loop
	endif
	
	if MV_PAR02 = 2 .AND. ALLTRIM(SUBSTR(CTD->CTD_ITEM,1,2)) = 'CM'
		CTD->(dbskip())
		Loop
	endif
	
	if MV_PAR03 = 2 .AND. ALLTRIM(SUBSTR(CTD->CTD_ITEM,1,2)) = 'EN'
		CTD->(dbskip())
		Loop
	endif
	
	if MV_PAR04 = 2 .AND. ALLTRIM(SUBSTR(CTD->CTD_ITEM,1,2)) = 'GR'
		CTD->(dbskip())
		Loop
	endif
	
	if MV_PAR05 = 2 .AND. ALLTRIM(SUBSTR(CTD->CTD_ITEM,1,2)) = 'EQ'
		CTD->(dbskip())
		Loop
	endif
	
	if MV_PAR06 = 2 .AND. ALLTRIM(SUBSTR(CTD->CTD_ITEM,1,2)) = 'PR'
		CTD->(dbskip())
		Loop
	endif
	
	if MV_PAR07 = 2 .AND. ALLTRIM(SUBSTR(CTD->CTD_ITEM,1,2)) = 'ST'
		CTD->(dbskip())
		Loop
	endif
	
	if SUBSTR(CTD->CTD_ITEM,9,2) < MV_PAR08
		CTD->(dbskip())
		Loop
	endif

	if SUBSTR(CTD->CTD_ITEM,9,2) > MV_PAR09
		CTD->(dbskip())
		Loop
	endif
	*/

	
	_cItemConta 	:= CTD->CTD_ITEM

	MSAguarde({||PFIN01ATUAL()},"Processando Ordem de Compra " + _cItemConta)

	//MSAguarde({||D101ATUAL()},"Processando Documento de Entrada " + _cItemConta)
	
	//MSAguarde({||DC01ATUAL()},"Processando Comissao " + _cItemConta)
	
	//MSAguarde({||DC201ATUAL()},"Processando Comissao (Rateio) " + _cItemConta)
	
	//MSAguarde({||DE01ATUAL()},"Processando Rateio Documento de Entrada " + _cItemConta)

	//MSAguarde({||HR01ATUAL()},"Processando Apontamento de Horas " + _cItemConta)

	//MSAguarde({||FIN01ATUAL()},"Processando Financeiro " + _cItemConta)

	//MSAguarde({||CUDIV01ATUAL()},"Processando Custos Diversos " + _cItemConta)

	//MSAguarde({||CV401ATUAL()},"Processando Financeiro Rateio " + _cItemConta)
	
	MSAguarde({||GC01SINT()},"Atualizando Custo de Producao Atual " + _cItemConta)
	CTD->(dbskip())
	
enddo
	
	
	AnaliticoFull()
	//GC01SINT()
	//MontaTela()

	TRB1->(dbclosearea())
	
	TRB2->(dbclosearea())
	//TRB4->(dbclosearea())

//endif


return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa Ordens de compra   			                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function PFIN01ATUAL()

local _cQuery := ""


Local _cFilSC7 := xFilial("SC7")

	Local dData
	Local nValor := 0
	Local nTotSC7 := 0
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
			
			nTotSC7	+= QUERY->C7_XTOTSI * nValor
			

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
			nTotSC7	+=  QUERY->C7_XTOTSI * nValor
			

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
			nTotSC7	+=  QUERY->C7_XTOTSI * nValor
			
		else
			nTotSC7	+=  QUERY->C7_XTOTSI
			
		endif

	endif

	QUERY->(dbskip())

enddo

	RecLock("TRB1",.T.)
		TRB1->VALOR		:= nTotSC7
		TRB1->ORIGEM	:= "OC"
		TRB1->ITEMCONTA := _cItemConta
		TRB1->CAMPO		:= "VLREMP"
	MsUnlock()

QUERY->(dbclosearea())
QUERY2->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa Documentos de Entrada		                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function D101ATUAL()

local _cQuery := ""
Local _cFilSD1 := xFilial("SD1")
Local nTotSD1 := 0


_cQuery := "SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO' , D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, D1_CUSTO, D1_FORNECE  FROM SD1010  WHERE  D_E_L_E_T_ <> '*' AND D1_ITEMCTA = '" + _cItemConta + "' ORDER BY D1_EMISSAO"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())


while QUERY->(!eof())

	if QUERY->D1_ITEMCTA == _cItemConta;
		.AND. ! alltrim(QUERY->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') .AND. QUERY->D1_RATEIO == '2';
		.AND. ! alltrim(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') .AND. QUERY->D1_RATEIO == '2'
		
		nTotSD1	+= QUERY->D1_CUSTO

	endif

	QUERY->(dbskip())

enddo
	RecLock("TRB1",.T.)
		
		TRB1->VALOR		:= nTotSD1
		TRB1->ORIGEM	:= "DE"
		TRB1->ITEMCONTA := _cItemConta
		TRB1->CAMPO		:= "VLREMP"
	MsUnlock()

QUERY->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa Documentos de Entrada Comissao                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function DC01ATUAL()

local _cQuery := ""
Local _cFilSD1 := xFilial("SD1")
Local nTotSD1A := 0


_cQuery := "SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO' , D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, D1_CUSTO, D1_FORNECE  FROM SD1010  WHERE  D_E_L_E_T_ <> '*' AND D1_ITEMCTA = '" + _cItemConta + "' ORDER BY D1_EMISSAO"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())


while QUERY->(!eof())

	if QUERY->D1_ITEMCTA == _cItemConta;
		.AND. ! alltrim(QUERY->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') .AND. QUERY->D1_RATEIO == '2';
		.AND. alltrim(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') .AND. QUERY->D1_RATEIO == '2'
		
		nTotSD1A	+= QUERY->D1_CUSTO

	endif

	QUERY->(dbskip())

enddo
	RecLock("TRB1",.T.)
		
		TRB1->VALOR		:= nTotSD1A
		TRB1->ORIGEM	:= "C1"
		TRB1->ITEMCONTA := _cItemConta
		TRB1->CAMPO		:= "VLREMP"
	MsUnlock()

QUERY->(dbclosearea())

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa Documentos de Entrada		                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function DE01ATUAL()

local _cQuery := ""
Local _cFilSDE := xFilial("SDE")
Local cProdD1 := ""
Local nTotSDE := 0


SD1->(dbsetorder(13)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SDE",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"QUERY->DE_DOC",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if QUERY->DE_ITEMCTA == _cItemConta;
		.AND. ! alltrim(POSICIONE("SD1",13,XFILIAL("SD1")+QUERY->DE_DOC+QUERY->DE_FORNECE,"D1_CF")) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') ;
		.AND. ! POSICIONE("SD1",13,XFILIAL("SD1")+QUERY->DE_DOC+QUERY->DE_FORNECE+QUERY->DE_ITEMNF,"D1_XNATURE") $ ('6.21.00/6.22.00') ;
		

		nTotSDE		+= QUERY->DE_CUSTO1
		
	endif

	QUERY->(dbskip())

enddo

	RecLock("TRB1",.T.)
		TRB1->VALOR		:= nTotSDE
		TRB1->ORIGEM	:= "DR"
		TRB1->ITEMCONTA := _cItemConta
		TRB1->CAMPO		:= "VLREMP"
	MsUnlock()

QUERY->(dbclosearea())

return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa Documentos de Entrada rateio comissao             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function DC201ATUAL()

local _cQuery := ""
Local _cFilSDE := xFilial("SDE")
Local cProdD1 := ""
Local nTotSDEB := 0


SD1->(dbsetorder(13)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SDE",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"QUERY->DE_DOC",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if QUERY->DE_ITEMCTA == _cItemConta;
		.AND. ! alltrim(POSICIONE("SD1",13,XFILIAL("SD1")+QUERY->DE_DOC+QUERY->DE_FORNECE,"D1_CF")) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') ;
		.AND. POSICIONE("SD1",13,XFILIAL("SD1")+QUERY->DE_DOC+QUERY->DE_FORNECE+QUERY->DE_ITEMNF,"D1_XNATURE") $ ('6.21.00/6.22.00')
		

		nTotSDEB		+= QUERY->DE_CUSTO1
		
	endif

	QUERY->(dbskip())

enddo

	RecLock("TRB1",.T.)
		TRB1->VALOR		:= nTotSDEB
		TRB1->ORIGEM	:= "C2"
		TRB1->ITEMCONTA := _cItemConta
		TRB1->CAMPO		:= "VLREMP"
	MsUnlock()

QUERY->(dbclosearea())

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa FINANCEIRO					                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function FIN01ATUAL()

local _cQuery := ""
Local _cFilSE2 := xFilial("SE2")
Local nTotSE2 := 0

_cQuery := "SELECT CAST(E2_BAIXA AS DATE) TMP_BAIXA, E2_TIPO, E2_NUM, E2_NATUREZ, E2_HIST, E2_VLCRUZ, E2_FORNECE, E2_NATUREZ, E2_XXIC, E2_RATEIO FROM SE2010  WHERE  D_E_L_E_T_ <> '*' AND E2_XXIC = '" + _cItemConta + "' ORDER BY E2_BAIXA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

while QUERY->(!eof())

	if QUERY->E2_XXIC == _cItemConta .AND. !ALLTRIM(QUERY->E2_TIPO) $ ("NF/PR/PA/TX/ISS/INS/INV") .AND. ALLTRIM(QUERY->E2_RATEIO) == "N" //.AND. !EMPTY(QUERY->E2_BAIXA)
		
		nTotSE2		+= QUERY->E2_VLCRUZ

	endif

	QUERY->(dbskip())

enddo

	RecLock("TRB1",.T.)
		
		TRB1->VALOR		:= nTotSE2
		TRB1->ORIGEM	:= "FN"
		TRB1->ITEMCONTA := _cItemConta
		TRB1->CAMPO		:= "VLREMP"

	MsUnlock()

QUERY->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa FINANCEIRO RATEIO			                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function CV401ATUAL()

local _cQuery := ""
Local _cFilCV4 := xFilial("CV4")
Local nTotCV4 := 0


CV4->(dbsetorder(2)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CV4",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CV4_DTSEQ",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())
//SC7->(dbgotop())
//QUERY->(dbseek( ALLTRIM(MV_PAR01),.T.))

while QUERY->(!eof())

	if QUERY->CV4_ITEMD == _cItemConta

		nTotCV4		+= QUERY->CV4_VALOR

	endif

	QUERY->(dbskip())

enddo

	RecLock("TRB1",.T.)
		TRB1->VALOR		:= nTotCV4
		TRB1->ORIGEM	:= "FR"
		TRB1->ITEMCONTA := _cItemConta
		TRB1->CAMPO		:= "VLREMP"
	MsUnlock()

QUERY->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN01REALบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa HORAS DE CONTRATO				                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


static function HR01ATUAL()

local _cQuery := ""
Local _cFilSZ4 := xFilial("SZ4")
Local nTarefa
Local nTotSZ4 := 0

//SZ4->(dbsetorder(9)) 

ChkFile("SZ4",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"Z4_FILIAL+Z4_ITEMCTA",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())
//SC7->(dbgotop())
//QUERY->(dbseek( ALLTRIM(MV_PAR01),.T.))

while QUERY->(!eof())

	if QUERY->Z4_ITEMCTA == _cItemConta

		nTotSZ4 += QUERY->Z4_TOTVLR
		
	endif

	QUERY->(dbskip())

enddo

	RecLock("TRB1",.T.)
		TRB1->VALOR		:= nTotSZ4
		TRB1->ORIGEM	:= "HR"
		TRB1->ITEMCONTA := _cItemConta
		TRB1->CAMPO		:= "VLREMP"
	MsUnlock()

QUERY->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN01REALบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa CUSTOS DIVERSOS 2				                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


static function CUDIV01ATUAL()

local _cQuery := ""
Local _cFilZZA := xFilial("ZZA")
Local nTarefa
Local nTotZZA := 0


ZZA->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("ZZA",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZA_DATA",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())


while QUERY->(!eof())

	if QUERY->ZZA_ITEMIC == _cItemConta

		nTotZZA		+= QUERY->ZZA_VALOR
		
	endif

	QUERY->(dbskip())

enddo
	
	RecLock("TRB1",.T.)
		TRB1->VALOR		:= nTotZZA
		TRB1->ORIGEM	:= "CD"
		TRB1->ITEMCONTA := _cItemConta
		TRB1->CAMPO		:= "VLREMP"
	MsUnlock()

QUERY->(dbclosearea())

return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo Sintetico                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


static function GC01SINT()
local _nPos 	:= 0
local _cQuery 	:= ""


Local nCPRVal	:= 0
Local nCPRTot	:= 0

private _cOrdem := "000001"

dbSelectArea("CTD")
CTD->( dbSetOrder(1)) 

	// EMPENHADO
		TRB1->(dbgotop())
		
		While TRB1->( ! EOF() )
			if  ALLTRIM(TRB1->ORIGEM) $ "OC/DE/DR/HR/FN/CD/FR" .AND. ALLTRIM(TRB1->ITEMCONTA) == _cItemConta 
				nCPRVal		+= TRB1->VALOR 
			endif
			
			if  ALLTRIM(TRB1->ITEMCONTA) == _cItemConta
				nCPRTot		+= TRB1->VALOR 
			endif
			TRB1->(dbskip()) 
		EndDo
		
		CTD->(dbgotop())
		While CTD->( ! EOF() ) 
            IF ALLTRIM(CTD->CTD_ITEM) == _cItemConta   
				RecLock("CTD",.F.)            
					CTD->CTD_XACPR  := TRB1->VALOR
					CTD->CTD_XACTO  := TRB1->VALOR
	            MsUnlock()  
	        ENDIF
            CTD->( dbSkip() )
       EndDo


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function AnaliticoFull(_cCampo)
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo2   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo2, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada


// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra := " ALLTRIM(CAMPO) == 'VLREMP' .AND. TRB1->ITEMCONTA == '" + _cItemConta + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB1

aadd(aHeader, {"Origem"			,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Vlr.s/Tributos"	,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Item Conta"		,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Campo"			,"CAMPO"		,"",10,0,"","","C","TRB1","R"})


//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Gestao de Contratos - Empenhado Analํtico - " + _cItemConta From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada  / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque "  COLORS 0, 16777215 PIXEL

aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE" , { || zGCRel01()}, "Imprimir " } )

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())

return

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


aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
aAdd(aStru,{"ITEMCONTA"	,"C",13,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"CAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico



dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)

//***************************************************************
aStru := {}
aAdd(aStru,{"GRUPO"		,"C",20,0}) // Descricao da Natureza
aAdd(aStru,{"DESCRICAO"	,"C",30,0}) // Descricao da Natureza
aAdd(aStru,{"VLRVD"		,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERVD"		,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRPLN"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERPLN"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLREMP"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PEREMP"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRSLD"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERSLD"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRCTB"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERCTB"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRCTBE"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERCTBE"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"ID"		,"C",5,0}) // Codigo da Natureza
aAdd(aStru,{"ORDEM"		,"C",10,0}) // Ordem de apresentacao



dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)

aadd(_aCpos , "DESCRICAO")
aadd(_aCpos , "VLRVD")
aadd(_aCpos , "PERVD")
aadd(_aCpos , "VLRPLN")
aadd(_aCpos , "PERPLN")
aadd(_aCpos , "VLREMP")
aadd(_aCpos , "PEREMP")
aadd(_aCpos , "VLRSLD")
aadd(_aCpos , "PERSLD")
aadd(_aCpos , "VLRCTB")
aadd(_aCpos , "PERCTB")
aadd(_aCpos , "VLRCTBE")
aadd(_aCpos , "PERCTBE")

_nCampos := len(_aCpos)

index on ORDEM to &(cArqTrb2+"2")
index on ORDEM to &(cArqTrb2+"1")
index on ORDEM to &(cArqTrb4+"1")

set index to &(cArqTrb2+"1")
set index to &(cArqTrb4+"1")


return(.T.)




static function VldParam()


	if empty(MV_PAR01)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Assistencia Tecnica")
		return(.F.)
	endif

	if empty(MV_PAR02)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Comissao")
		return(.F.)
	endif

	if empty(MV_PAR03)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Engenharia")
		return(.F.)
	endif

	if empty(MV_PAR04)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Engenharia")
		return(.F.)
	endif

	if empty(MV_PAR05)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Peca")
		return(.F.)
	endif

	if empty(MV_PAR06)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Sistema")
		return(.F.)
	endif

	if MV_PAR03 == 2 .AND. MV_PAR04 == 2 .AND. MV_PAR05 == 2 .AND. MV_PAR06 == 2 .AND. MV_PAR07 == 2 .AND. MV_PAR08 == 2
		msgstop("Deve ser informado pelo menos um tipo de Contrato como Sim")
		return(.F.)
	endif

	if empty(MV_PAR08)
		msgstop("Deve ser informado pelo menos um parametro Ano at้.")
		return(.F.)
	endif
	
return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณABREDOC   บAutor  ณMarcos Zanetti G&Z  บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre o XLS com os dados do fluxo de caixa                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	MsgStop("Ocorreram problemas na c๓pia do arquivo.")
endif

return

static function ValidPergPC()

	PutSX1(cPerg01, "01", "Assistencia Tecnica (AT)"		, "", "", "mv_ch1", "N", 01, 0, 0, "C", "", "", "", "", "mv_par01","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg01, "02", "Comissao (CM)"					, "", "", "mv_ch2", "N", 01, 0, 0, "C", "", "", "", "", "mv_par02","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg01, "03", "Engenharia (EN)"				, "", "", "mv_ch3", "N", 01, 0, 0, "C", "", "", "", "", "mv_par03","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg01, "04", "Engenharia (GR)"				, "", "", "mv_ch4", "N", 01, 0, 0, "C", "", "", "", "", "mv_par04","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg01, "05", "Equipamento (EQ)"				, "", "", "mv_ch5", "N", 01, 0, 0, "C", "", "", "", "", "mv_par05","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg01, "06", "Peca (PR)"						, "", "", "mv_ch6", "N", 01, 0, 0, "C", "", "", "", "", "mv_par06","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg01, "07", "Sistema (ST)"					, "", "", "mv_ch7", "N", 01, 0, 0, "C", "", "", "", "", "mv_par07","Sim","","","","Nao","","","","","","","","","","","")
	putSx1(cPerg01, "08", "Ano de?"  						, "", "", "mv_ch8", "C", 02, 0, 0, "G", "", "", "", "", "mv_par08")
	putSx1(cPerg01, "09", "Ano at้?" 						, "", "", "mv_ch8", "C", 02, 0, 0, "G", "", "", "", "", "mv_par09")
	
return