#Include "Protheus.Ch"

User Function M460FIL()  

Local 	_cFil 	:=	""

If Alltrim(FunName()) $"MATA460A"
	//----> DOCUMENTO FISCAL = SIM
	If MV_PAR19 == 1	
		_cFil += " SC9->C9_X_PRIOR $ 'S' "
	Else
		_cFil += " SC9->C9_X_PRIOR $ 'N' "
	EndIf
EndIf                     

Return(_cFil)