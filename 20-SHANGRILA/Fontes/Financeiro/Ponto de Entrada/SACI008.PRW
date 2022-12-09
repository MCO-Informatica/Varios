#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function SACI008()

Local _aArea	:=	GetArea()


If SE5->E5_MOTBX$"BCC"
	RecLock("SE5",.F.)
	SE5->E5_TIPODOC = 'VL'
	MsUnLock()
EndIf

RestArea(_aArea)

Return

