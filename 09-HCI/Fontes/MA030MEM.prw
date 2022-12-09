#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User function MA030MEM()           

	Local aSaveArea := GetArea()
	Public cQry
	
	cQry := U_HCIDM010("Cliente")
	If !Empty(cQry)
		cQry	:= "A1_COD+A1_LOJA $ '" + cQry + "'"
		dbSelectArea('SA1') 
		Set Filter to &cQry
	EndIf
	
	RestArea(aSaveArea)
	
Return()