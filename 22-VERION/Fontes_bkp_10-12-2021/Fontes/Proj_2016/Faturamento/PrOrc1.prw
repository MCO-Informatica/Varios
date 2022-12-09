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
User Function PrOrc1()
Local _aArea :=	GetArea()
Local _WAA   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cString := "SCK"

dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SBM")
dbSetOrder(1)
dbSelectArea("SZ1")
dbSetOrder(1)
dbSelectArea("SUB")
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
//_WDATA    := DDATABASE

dbSelectArea("SM2")
dbSeek(_WDATA)
_WDOLAR := SM2->M2_MOEDA2
_WEURO  := SM2->M2_MOEDA4

dbSelectArea("SB1")
dbSeek(xfilial()+_WPROD)
_WPRECO   := SB1->B1_VERVEN
_WTIPICMS := SB1->B1_TIPICMS
_WMOEDA   := SB1->B1_TPMOEDA
_WGRUPO   := SB1->B1_GRUPO
_WFATOR   := SB1->B1_FATOR
_WPRECO1  := SB1->B1_VERCOM

dbSelectArea("SBM")
dbSeek(xFilial()+_WGRUPO)
If _WFATOR == 0
   _WFATOR := SBM->BM_FATOR
Endif                        

dbSelectArea("SA1")
dbSeek(xfilial()+_WCLIENTE+_WLOJACLI)
_WEST     := SA1->A1_EST
_WPERCENT := 0

dbSelectArea("SZ1")
dbSeek(xfilial()+_WTIPICMS)
IF _WEST == 'AC'
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

_WPERCENT := (100 - _WPERCENT) / 100
 
If _WMOEDA == space(1)
   _WMOEDA := SBM->BM_MOEDA
   IF _WMOEDA == "D"
      _WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
 	  _WAA := Round( ((_WAA1 * _WDOLAR) / _WPERCENT ) * 1.035 ,2)
   ELSEIF _WMOEDA == "E"
      _WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
      _WAA := Round( ((_WAA1 * _WEURO) / _WPERCENT ) * 1.035 ,2)
   ELSE
      _WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
      _WAA := Round( (_WAA1 / _WPERCENT ) * 1.035 ,2)
   ENDIF
ELSE
   IF _WMOEDA == "D"
      _WAA := Round( (((_WPRECO1 * _WFATOR) * _WDOLAR) / _WPERCENT ) * 1.035 ,2)
   ELSEIF _WMOEDA == "E"
      _WAA := Round( (((_WPRECO1 * _WFATOR) * _WEURO ) / _WPERCENT ) * 1.035 ,2)
   ELSE
      _WAA := Round( (((_WPRECO1 * _WFATOR) ) / _WPERCENT ) * 1.035 ,2)
   ENDIF
ENDIF

/*
If SM0->M0_CODIGO == "02"
   _WAA := Round( _WAA + (_WAA * (SB1->B1_IPI / 100)) ,2)
EndIf   
*/

RestArea(_aArea)
Return (_Waa)	