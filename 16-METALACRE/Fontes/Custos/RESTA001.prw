#include "rwmake.ch"
#include "protheus.ch"

User Function RESTA001()
Local aArea     := GetArea()

If SB1->B1_TIPO$"MP.MC.BN.GG.EB" .OR. SUBSTRING(SB1->B1_COD,1,3)$"MOD"
	_lRet	:=	.T.
Else
	_lRet	:=	.F.
EndIf	

RestArea(aArea)
Return(_lRet)