#INCLUDE "PROTHEUS.CH"

User Function F240SUMD	
Local nValDescr	:= 0	

If SEA->EA_MODELO$ "17"
nValDescr := SE2->E2_XVLENT
EndIf

Return nValDescr