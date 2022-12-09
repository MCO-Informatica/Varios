#include "rwmake.ch"

User Function ACERTAEST()

Processa({||RunProc()},"ACERTA ESTOQUE")
Return

Static function runproc()

dbselectarea("SB2")
dbgotop()
procregua(lastrec())

_nQatu	:=	0

while eof() == .f.

    incproc("Ajustando dados do produto "+SB2->B2_COD)

    dbSelectArea("SB1")
    dbSetOrder(1)
    If dbSeek(xFilial("SB1")+SB2->B2_COD,.F.)
    
    	If SB1->B1_RASTRO$"L"
    	
    		dbSelectArea("SB8")
    		dbSetOrder(1)
    		If dbSeek(xFilial("SB8")+SB2->B2_COD+SB2->B2_LOCAL,.F.)
    			
    			While SB8->(B8_PRODUTO+B8_LOCAL) == SB2->(B2_COD+B2_LOCAL)
    			
    				_nQatu	+= SB8->B8_SALDO
		
		    		dbSelectArea("SB8")
    				dbSkip()		    
    				
    			EndDo
    		
    		EndIf
    	    
    		RecLock("SB2",.F.)
    		SB2->B2_QATU	:=	_nQatu
    		SB2->B2_CM1		:=	SB1->B1_CUSTD
    		SB2->B2_VATU1	:=	_nQatu * SB1->B1_CUSTD
    		SB2->B2_CM2		:=	0
    		SB2->B2_VATU2	:=	0
    		SB2->B2_CM3		:=	0
    		SB2->B2_VATU3	:=	0
    		SB2->B2_CM4		:=	0
    		SB2->B2_VATU4	:=	0
    		SB2->B2_CM5		:=	0
    		SB2->B2_VATU5	:=	0
    		MsUnLock()
    		
    		_nQatu	:=	0

    	Else
    	
    		RecLock("SB2",.F.)
    		SB2->B2_CM1		:=	SB1->B1_CUSTD
    		SB2->B2_VATU1	:=	SB2->B2_QATU * SB1->B1_CUSTD
    		SB2->B2_CM2		:=	0
    		SB2->B2_VATU2	:=	0
    		SB2->B2_CM3		:=	0
    		SB2->B2_VATU3	:=	0
    		SB2->B2_CM4		:=	0
    		SB2->B2_VATU4	:=	0
    		SB2->B2_CM5		:=	0
    		SB2->B2_VATU5	:=	0
    		MsUnLock()
    	
    	EndIf
    EndIf
    
    dbSelectArea("SB2")
    dbskip()
EndDo

Return
