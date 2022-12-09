#INCLUDE "Rwmake.ch"
#include "Average.ch"
#INCLUDE "TOPCONN.CH"

#DEFINE  NFE_UNICA     3
#define  NF_TRANS      6

//+-----------------------------------------------------------------------------------//
//|Empresa...: Makeni
//|Funcao....: EICDI154_RDM
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 11 de Janeiro de 2010 - 08:00
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 10
//|Descricao.: Pontos de Entrada na geração da NF de Importação
//|Observação:
//+-----------------------------------------------------------------------------------//
*----------------------------------------------*
User Function EICDI154()
*----------------------------------------------*
local nInd as numeric
local aAreaSD1 as array
local nPosItem as numeric
local nPosPrd  as numeric
local nPosLot  as numeric
local nPosDtVl as numeric
local nPosDFbr as numeric
//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "EICDI154" , __cUserID )

_nTotFob := SW6->W6_FOB_TOT

If Type("ParamIXB") # "C"
	Return .F.
EndIf

//+------------------------------------------------------------------------------------//
//|VerIfica pelo parametro padrao do DESEMBARAÇO F12 se fara a contabilização
//|Precionando F12 na tela do Desembaraço poderam selecionar os parametros
//+------------------------------------------------------------------------------------//
//MV_PAR03 := Posicione("SX1",1,"EICFI4    "+"02","X1_PRESEL")  // Mostra   Lançamento Contabil?
//MV_PAR04 := Posicione("SX1",1,"EICFI4    "+"03","X1_PRESEL")  // Aglutina Lançamento Contabil?

Do Case
	
	/*
	//+-----------------------------------------------------------------------------------//
	//|Parametro..: "FINAL_GRAVA_NF"
	//|Descricao..: Verifica as contabilizações para Gravação da Nota
	//+-----------------------------------------------------------------------------------//
	Case ParamIxb == "FINAL_GRAVA_NF"
	
	If nTipoNF == 1 .OR. nTipoNF == 3
	
	//+------------------------------------------------------------------------------------//
	//|Contabilização de Pré-Nota
	//+------------------------------------------------------------------------------------//
	//|Estorno Contabilização Em Transito
	//|Só será efetuado o lançamento do estorno, caso a data gravada no arquivo não esteja
	//|em branco, sabemos assim que já foi contabilizada necessitando estorná-la.
	//+------------------------------------------------------------------------------------//
	dDtaEmb := SW6->W6_DT_EMB
	If !Empty(dDtaEmb)
	U_UZValInform("905")
	Endif
	
	
	EndIf
	
	
	//+-----------------------------------------------------------------------------------//
	//|Parametro..: "ANTES_ESTORNO_NOTA"
	//|Descricao..: Verifica as contabilizações no estorno e se há NF Transferencia
	//+-----------------------------------------------------------------------------------//
	Case ParamIxb == "ANTES_ESTORNO_NOTA"
	
	If nTipoNF == 1 .OR. nTipoNF == 3
	
	//+------------------------------------------------------------------------------------//
	//|Inclusão Retorno da Contabilização Dta Em Transito
	//+------------------------------------------------------------------------------------//
	dDtaEmb := SW6->W6_DT_EMB
	If !Empty(dDtaEmb)
	SW6->W6_DT_EMB := dDtaEmb // O Lancamento 904 busca a data do Embarque com M-> entao foi preciso FAZER a recpcao desta variavel
	U_UZValInform("900")
	Endif
	
	EndIf
	*/
	
	Case ParamIxb == "GRAVACAO_SD1"
		
		
		If lLote .and. nTipoNF == 1
			
			Aadd( aItem, { "D1_FABRIC" , Work1->WKFABR , ".T." } )
			Aadd( aItem, { "D1_LOJFABR" , Work1->WKFABLOJ , ".T." } )
			
			cQry:="SELECT WV_DTFABR FROM "+RETSQLNAME("SWV") +"  SWV "
			cQry+="WHERE SWV.WV_FILIAL  = '"+xFilial('SWV')  +"' AND "
			cQry+="      SWV.WV_HAWB    = '"+SW6->W6_HAWB    +"' AND "
			cQry+="      SWV.WV_INVOICE = '"+Work1->WKINVOICE+"' AND "
			cQry+="      SWV.WV_PO_NUM  = '"+Work1->WKPO_NUM +"' AND "
			cQry+="      SWV.WV_PGI_NUM = '"+Work1->WKPGI_NUM+"' AND "
			cQry+="      SWV.WV_COD_I   = '"+Work1->WKCOD_I  +"' AND "
			cQry+="      SWV.WV_POSICAO = '"+Work1->WKPOSICAO+"' AND "
			cQry+="      SWV.WV_LOTE = '"+Work1->WK_LOTE  +"' AND "
			cQry+="      SWV.D_E_L_E_T_ = ' ' "
			
			If Select("TSWV") > 0
				TSWV->( dbCloseArea() )
			EndIf
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), "TSWV", .F., .T.)
			TCSetField("TSWV", "WV_DTFABR", "D",08 )
			
			IF SD1->(FIELDPOS("D1_LOTECTL")) # 0 .AND. SD1->(FIELDPOS("D1_DTVALID")) # 0 .and. ! Empty(TSWV->WV_DTFABR)
				AADD(aItem,{"D1_DFABRIC",TSWV->WV_DTFABR  ,})
			Endif
			
		Endif
	Case ParamIxb == "FINAL_GRAVA_NF"	
		if !lMsErroAuto
			aAreaSD1 := SD1->(getArea())
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1))

			for nInd := 1 to len(aItens)
				nPosItem := aScan(aItens[nInd], {|aItem|aItem[1]=="D1_ITEM"})
				nPosPrd  := aScan(aItens[nInd], {|aItem|aItem[1]=="D1_COD"})
				nPosLot  := aScan(aItens[nInd], {|aItem|aItem[1]=="D1_LOTECTL"})
				nPosDtVl := aScan(aItens[nInd], {|aItem|aItem[1]=="D1_DTVALID"})
				nPosDFbr := aScan(aItens[nInd], {|aItem|aItem[1]=="D1_DFABRIC"})
				if nPosItem > 0 .AND. nPosPrd > 0

					if SD1->(dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)+;
					              aItens[nInd][nPosPrd][2]+ aItens[nInd][nPosItem][2]))
						if empty(SD1->D1_LOTECTL)
							reclock("SD1",.F.)
							if nPosLot > 0
								SD1->D1_LOTECTL := aItens[nInd][nPosLot][2]
							endif
							if nPosDtVl > 0
								SD1->D1_DTVALID := aItens[nInd][nPosDtVl][2]
							endif
							if nPosDFbr > 0
								SD1->D1_DFABRIC := aItens[nInd][nPosDFbr][2]
							endif
							SD1->(msUnlock())
						endif
					endif
				endif
			next nInd

			restArea(aAreaSD1)
			aSize(aAreaSD1,0)
		endif
EndCase

Return

//+------------------------------------------------------------------------------------//
//|Fim do programa EICDI154_RDM.PRW
//+------------------------------------------------------------------------------------//
