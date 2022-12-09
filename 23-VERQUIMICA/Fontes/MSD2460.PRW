#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

User Function MSD2460()

Local _cArea := GetArea()

dbSelectArea("SD2")
RecLock("SD2",.f.)
SD2->D2_FCICOD	:=	POSICIONE("SD1",26,xFilial("SD1")+SD2->D2_LOTECTL,"D1_FCICOD")                                        
SD2->(MsUnLock())

dbSelectArea("SC6")
RecLock("SC6",.f.)
SC6->C6_FCICOD	:=	POSICIONE("SD1",26,xFilial("SD1")+SD2->D2_LOTECTL,"D1_FCICOD")                                        
SC6->(MsUnLock())

RestArea(_cArea)
Return()
