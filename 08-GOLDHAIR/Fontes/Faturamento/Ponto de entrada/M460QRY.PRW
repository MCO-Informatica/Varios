#include "protheus.ch"

User Function M460QRY()

Local 	_cQry 	:=	paramixb[1]

If Alltrim(FunName()) $"MATA460A"
	_cQry += "AND C9_X_EMPFA = '"+cFilAnt+"'"
EndIf

Return(_cQry)
