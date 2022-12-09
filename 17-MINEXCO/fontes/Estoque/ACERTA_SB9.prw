#include "rwmake.ch"

User Function ACERTA_SB9()

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SB2")
dbSetOrder(1)

Processa({||RunProc()},"Acerta SB9")
Return

Static Function RunProc()

_nQtdeSeg := 0
_nQtdeIni := 0

dbSelectArea("SB9")
dbSetOrder(1)
dbGoTop()

ProcRegua(RecCount())

While !Eof()
	
	IncProc("Selecionando Produto "+SB9->B9_COD)
	
	
	If !DTOS(SB9->B9_DATA) $ "20140831"
		dbSelectArea("SB9")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SBJ")
	dbSetOrder(1)
	dbSeek(xFilial("SBJ")+SB9->B9_COD,.F.)
	While !Eof() .and. SBJ->BJ_COD == SB9->B9_COD
		
		
		If !DTOS(SBJ->BJ_DATA) $ "20140831"
			dbSelectArea("SBJ")
			dbSkip()
			Loop
		EndIf
		
		_nQtdeIni	:=	_nQtdeIni + BJ_QINI
		_nQtdeSeg	:=	_nQtdeSeg + BJ_QISEGUM
		
		dbSelectArea("SBJ")
		dbSkip()
	EndDo
	
	RecLock("SB9",.f.)
	SB9->B9_QISEGUM	:=	_nQtdeSeg
	SB9->B9_QINI	:=	_nQtdeIni
	MsUnLock()
	
	_nQtdeSeg := 0
	_nQtdeIni := 0
	
	dbSelectArea("SB9")
	dbSkip()
	
EndDo

Return()

