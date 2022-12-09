#include "protheus.ch"

User Function M460QRY()

    Local 	_cQry 	:=	paramixb[1]

    If Alltrim(FunName()) $"MATA460A"
        //----> DOCUMENTO FISCAL = SIM
        If MV_PAR19 == 1
            _cQry += "AND C9_DF = 'S' AND C9_X_EMPFA = '"+cFilAnt+"'"
        Else
            _cQry += "AND C9_DF = 'N' AND C9_X_EMPFA = '"+cFilAnt+"'"
        EndIf
    EndIf

Return(_cQry)
