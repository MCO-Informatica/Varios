
User Function KPCP01G()

Local _nQtdBase	:=	0
Local _aAreaSB1	:=	GetArea()
                     
_nQtdBase	:=	100/M->B1_CONV                                                                                      
_cComp		:=	IIF(SB1->B1_TIPO$"TT",SUBS(SB1->B1_COD,1,3)+"000"+SUBS(SB1->B1_COD,7),SUBS(SB1->B1_COD,1,3)+"000")

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+SB1->B1_COD+_cComp,.F.)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+_cComp,.f.)
		RecLock("SB1",.F.)
		SB1->B1_CONV	:=	_nQtdBase
		MsUnLock()
	EndIf
	
	RestArea(_aAreaSB1)
EndIf

Return(_nQtdBase)

