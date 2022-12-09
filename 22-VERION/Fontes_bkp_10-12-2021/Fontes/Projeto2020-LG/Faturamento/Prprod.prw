#INCLUDE "rwmake.ch"
/*
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrProd    º Autor ³ AP6 IDE            º Data ³  03/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
*/

User Function Prprod()
Local _aArea :=	GetArea()
Local _WAA := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString := "SB1"

dbSelectArea("SBM")
dbSetOrder(1)

dbSelectArea("SM2")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)

_WPRECO   := M->B1_VERCOM
_WTIPICMS := M->B1_FATOR
_WMOEDA   := M->B1_TPMOEDA
//_WDATA    := M->B1_DATREF
_WDATA    := DDATABASE
_WGRUPO    := M->B1_GRUPO

dbSelectArea("SBM")
dbSeek(xFilial()+_WGRUPO)

If _WTIPICMS == 0
   _WTIPICMS := SBM->BM_FATOR
Endif                        

If _WMOEDA == space(1)
   _WMOEDA := SBM->BM_MOEDA
Endif                        

dbSelectArea("SM2")
dbSeek(_WDATA)
_WDOLAR := SM2->M2_MOEDA2
_WEURO  := SM2->M2_MOEDA4

IF _WMOEDA == "D"
   _WAA := Round( (_WPRECO * _WTIPICMS) * _WDOLAR ,2)
ELSEIF _WMOEDA == "E"
   _WAA := Round( (_WPRECO * _WTIPICMS) * _WEURO ,2)
ELSE
   _WAA := Round( (_WPRECO * _WTIPICMS) ,2)
ENDIF

RestArea(_aArea)

Return (_Waa)