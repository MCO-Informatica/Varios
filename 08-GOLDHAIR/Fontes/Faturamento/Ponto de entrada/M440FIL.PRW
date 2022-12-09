#Include "Protheus.Ch"

User Function M440FIL()      

Local lRet 		:= ""
Local aAreaSc5	:= SC5->(GetArea())

//ALERT("M440FIL")


DbSelectArea("SC5")

//If cFilAnt$"0106.0107.0109"
	//Set Filter To &("C5_X_EMPFA$'"+cFilAnt+"' .AND. Empty(C5_BLQ) .AND. Empty(C5_NOTA)")
//Else
	//Set Filter To &("!C5_X_EMPFA$'0106.0107.0109' .AND. Empty(C5_BLQ) .AND. Empty(C5_NOTA)")
//EndIf

Set Filter To &("C5_X_EMPFA$'"+cFilAnt+"' .AND. Empty(C5_BLQ) .AND. Empty(C5_NOTA)")

RestArea(aAreaSc5)  	

Return()