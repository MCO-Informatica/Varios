#INCLUDE "rwmake.ch"
/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘?
臼?Programa  ?PrProd    ? Autor ? AP6 IDE            ? Data ?  03/10/05   艮?
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒?
臼?Descricao ? Codigo gerado pelo AP6 IDE.                                艮?
臼?          ?                                                            艮?
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒?
臼?Uso       ? AP6 IDE                                                    艮?
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識?
*/

User Function Prprod()
Local _aArea :=	GetArea()
Local _WAA := 0

//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳?
//? Declaracao de Variaveis                                             ?
//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳?

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
