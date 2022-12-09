#Include "Protheus.Ch"

User Function M460FIL()  

Local 	_cFil 	:=	""

If Alltrim(FunName()) $"MATA460A"
	_cFil += " SC9->C9_X_EMPFA$'"+cFilAnt+"' "
EndIf                     

Return(_cFil)