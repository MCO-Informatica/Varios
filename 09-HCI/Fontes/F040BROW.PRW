#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User function F040BROW()           

	Local aSaveArea := GetArea()
	Public cQry
	
	cQry := U_HCIDM010("Cliente")
	If !Empty(cQry)
		cQry	:= "@E1_CLIENTE+E1_LOJA $ '" + cQry + "'"
		dbSelectArea('SE1') 
		Set Filter to &cQry
	EndIf
	
	RestArea(aSaveArea)
	
Return()