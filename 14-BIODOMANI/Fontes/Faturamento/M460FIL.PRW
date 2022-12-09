#Include "Protheus.Ch"

User Function M460FIL()

    Local 	_cFil 	:=	""

    If Alltrim(FunName()) $"MATA460A"
        //----> DOCUMENTO FISCAL = SIM
        If MV_PAR19 == 1
            _cFil += " SC9->C9_DF $ 'S' .AND. SC9->C9_X_EMPFA$'"+cFilAnt+"' "
        Else
            _cFil += " SC9->C9_DF $ 'N' .AND. SC9->C9_X_EMPFA$'"+cFilAnt+"' "
        EndIf
    EndIf

Return(_cFil)