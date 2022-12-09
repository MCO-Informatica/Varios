#INCLUDE "rwmake.ch"
/*
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  03/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
*/
User Function PRORC2()
Local _aArea :=	GetArea()
Local _CVLN  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString := "SCK"
_nqtd := 0
_nprc := 0
_nvlr := 0
_NDSC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SBM")
dbSetOrder(1)
dbSelectArea("SZ1")
dbSetOrder(1)
dbSelectArea("SCK")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SM2")
dbSetOrder(1)
dbSelectArea("SCJ")
dbSetOrder(1)

_WCLIENTE := M->CJ_CLIENTE
_WLOJACLI := M->CJ_LOJA
_WDATA    := M->CJ_EMISSAO
_WPROD    := TMP1->CK_PRODUTO
	
	dbSelectArea("SM2")
	dbSeek(_WDATA)
	_WDOLAR := SM2->M2_MOEDA2
	_WEURO  := SM2->M2_MOEDA4
	
	dbSelectArea("SB1")
	dbSeek(xfilial()+_WPROD)
	_WPRECO   := SB1->B1_VERVEN
	_WTIPICMS := SB1->B1_TIPICMS
	_WMOEDA   := SB1->B1_TPMOEDA
	_WFATOR   := SB1->B1_FATOR
	_WPRECO1  := SB1->B1_VERCOM
	_WGRUPO   := SB1->B1_GRUPO
	_WPISCOF  := SB1->B1_PPIS+SB1->B1_PCOFINS	// ALTERADO POR RICARDO SOUZA (UPDUO) 15/09/2021
	dbSelectArea("SBM")
	dbSeek(xFilial()+_WGRUPO)
	
	IF _WFATOR == 0
		_WFATOR := SBM->BM_FATOR
	Endif
	
	dbSelectArea("SA1")
	dbSeek(xfilial()+_WCLIENTE+_WLOJACLI)
	_WEST     := SA1->A1_EST
	_WPERCENT := 0
	
	dbSelectArea("SZ1")
	dbSeek(xfilial()+_WTIPICMS)
	IF     _WEST == 'AC'
		_WPERCENT := SZ1->Z1_AC
	ELSEIF _WEST == 'AL'
		_WPERCENT := SZ1->Z1_AL
	ELSEIF _WEST == 'AM'
		_WPERCENT := SZ1->Z1_AM
	ELSEIF _WEST == 'AP'
		_WPERCENT := SZ1->Z1_AP
	ELSEIF _WEST == 'BA'
		_WPERCENT := SZ1->Z1_BA
	ELSEIF _WEST == 'CE'
		_WPERCENT := SZ1->Z1_CE
	ELSEIF _WEST == 'DF'
		_WPERCENT := SZ1->Z1_DF
	ELSEIF _WEST == 'ES'
		_WPERCENT := SZ1->Z1_ES
	ELSEIF _WEST == 'FN'
		_WPERCENT := SZ1->Z1_FN
	ELSEIF _WEST == 'GO'
		_WPERCENT := SZ1->Z1_GO
	ELSEIF _WEST == 'MA'
		_WPERCENT := SZ1->Z1_MA
	ELSEIF _WEST == 'MG'
		_WPERCENT := SZ1->Z1_MG
	ELSEIF _WEST == 'MS'
		_WPERCENT := SZ1->Z1_MS
	ELSEIF _WEST == 'MT'
		_WPERCENT := SZ1->Z1_MT
	ELSEIF _WEST == 'PA'
		_WPERCENT := SZ1->Z1_PA
	ELSEIF _WEST == 'PB'
		_WPERCENT := SZ1->Z1_PB
	ELSEIF _WEST == 'PE'
		_WPERCENT := SZ1->Z1_PE
	ELSEIF _WEST == 'PI'
		_WPERCENT := SZ1->Z1_PI
	ELSEIF _WEST == 'PR'
		_WPERCENT := SZ1->Z1_PR
	ELSEIF _WEST == 'RJ'
		_WPERCENT := SZ1->Z1_RJ
	ELSEIF _WEST == 'RN'
		_WPERCENT := SZ1->Z1_RN
	ELSEIF _WEST == 'RO'
		_WPERCENT := SZ1->Z1_RO
	ELSEIF _WEST == 'RR'
		_WPERCENT := SZ1->Z1_RR
	ELSEIF _WEST == 'RS'
		_WPERCENT := SZ1->Z1_RS
	ELSEIF _WEST == 'SC'
		_WPERCENT := SZ1->Z1_SC
	ELSEIF _WEST == 'SE'
		_WPERCENT := SZ1->Z1_SE
	ELSEIF _WEST == 'SP'
		_WPERCENT := SZ1->Z1_SP
	ELSEIF _WEST == 'TO'
		_WPERCENT := SZ1->Z1_TO
	ELSEIF _WEST == 'XX'
		_WPERCENT := SZ1->Z1_XX
	ELSEIF _WEST == 'EX'
		_WPERCENT := SZ1->Z1_EX
	ENDIF
	
	__WPERCENT := (100 - _WPERCENT - _WPISCOF) / 100
	
	If _WMOEDA == space(1)
		_WMOEDA := SBM->BM_MOEDA
		IF _WMOEDA == "D"
			_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
			_WAA  := Round( ((_WAA1   * _WDOLAR) / _WPERCENT ) * 1.035 ,2) // vlr venda
		ELSEIF _WMOEDA == "E"
			_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
			_WAA  := Round( ((_WAA1   * _WEURO)  / _WPERCENT ) * 1.035 ,2) // vlr venda
		ELSE
			_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
			_WAA  := Round( (_WAA1 / _WPERCENT ) * 1.035 ,2) // vlr venda
		ENDIF
	ELSE
		IF _WMOEDA == "D"
			_WAA := Round( (((_WPRECO1 * _WFATOR) * _WDOLAR) / _WPERCENT ) * 1.035 ,2)
		ELSEIF _WMOEDA == "E"
			_WAA := Round( (((_WPRECO1 * _WFATOR) * _WEURO ) / _WPERCENT ) * 1.035 ,2)
		ELSE
			_WAA := Round( ((_WPRECO1 * _WFATOR) / _WPERCENT ) * 1.035 ,2)
		ENDIF
	ENDIF
 
/*
    If SM0->M0_CODIGO == "02"
       _WAA := Round( _WAA + (_WAA * (SB1->B1_IPI / 100))  ,2) // vlr venda
    EndIf  
*/
	_nPosProd := TMP1->CK_PRODUTO
	_nPosQTD  := TMP1->CK_QTDVEN
	_nPosPrC  := TMP1->CK_PRCVEN
	_nPosVLR  := TMP1->CK_VALOR
	_nPosDSC  := TMP1->CK_DESCONT
	_nPosVLDC := TMP1->CK_VALDESC

	IF _nPosDSC > 0 // se existir desconto
		_NDSC := (_nPosDSC/100)
		_nprc := Round( (_WAA*_NDSC) ,2)             // calculo do valor do desconto
        _nprf := (_WAA-_nprc)                        // (PRECO-DESCONTO)
		TMP1->CK_PRCVEN  := _nprf                    // (PRECO-DESCONTO)
		TMP1->CK_VALDESC := _nprc                    // Campo do valor de desconto
		_CVLN := Round((_nPosQTD * (_WAA-_nprc)) ,2) // valor total (qtdade*preco)
		TMP1->CK_VALOR := round(_CVLN,2)             // Campo do valor total
    else
		_nprc := _WAA
		TMP1->CK_PRCVEN := _nprc
		_CVLN := Round((_nPosQTD * _nprc) ,2)   // Valor total (qtdade*preco)
		TMP1->CK_VALOR   := round(_CVLN,2) // Campo do valor total
		TMP1->CK_VALDESC := 0              // Zera valor
	ENDIF
//Endif

RestArea(_aArea)
Return (round(_CVLN,2))
