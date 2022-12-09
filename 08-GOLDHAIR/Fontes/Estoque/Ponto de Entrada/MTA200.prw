#INCLUDE "Protheus.ch"

User Function MTA200          
local aArea := GetArea()
IF RecLock("SG1",.F.)
	SG1->G1_X_DESC = posicione("SB1",1,xFilial("SB1")+SG1->G1_COD,"B1_DESC")
	MsUnlock()
ENDIF
                        
Restarea(aArea)
Return .T.