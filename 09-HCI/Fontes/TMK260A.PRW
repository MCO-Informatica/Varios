#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"

User Function TMK260A() 
	
	If RecLock("SUS",.F.)
		SUS->US_XHISTOR	:= _cObsDia
		SUS->US_XOBSDIA	:= ""
		SUS->(MsUnLock())
	EndIf

Return .T.