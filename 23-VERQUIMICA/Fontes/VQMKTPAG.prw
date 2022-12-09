#include 'protheus.ch'
#include 'parmtype.ch'

user function VQMKTPAG()
Local cMark := ""

If SE2->E2_VQ_LIBP == 'S'
	cMark := 'N'
Else
	cMark := 'S'
EndIf


Begin Transaction
	RecLock("SE2", .F.)
		SE2->E2_VQ_LIBP := cMark
	SE2->(MsUnlock())
End Transaction

IIF(cMark == 'S',MSGINFO("T�tulo marcado para aprova��o"),MSGINFO("T�tulo desmarcado para aprova��o"))
	
return