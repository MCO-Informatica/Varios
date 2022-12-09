#include "rwmake.ch"
#include "protheus.ch"

User Function CS6_AJU()

_cRevisa := "000023"
_cCodAgl := ""                              

dbSelectArea("CS6")
dbSetOrder(2)
dbSeek(xFilial("CS6")+_cRevisa,.f.)

ProcRegua(LastRec())


While Eof() == .f.

	IncProc("Processando...")

	If CS6->CS6_CODREV+CS6->CS6_CODAGL == _cRevisa+_cCodAgl
		RecLock("CS6",.F.)
		dbDelete()
		MsUnLock()
	EndIf

	_cCodAgl := SC6->C6_CODAGL
	
	dbSelectArea("CS6")
	dbSkip()

EndDo

Return