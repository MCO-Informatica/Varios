#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function M320FILNF()

Local _lRet := .T.

If SB1->B1_X_CUSTD$"S"
	_lRet	:= .F.
	//ALERT(SB1->B1_COD+" "+SB1->B1_DESC)
EndIf

Return(_lRet)