#INCLUDE "Protheus.ch"

User Function MTA103MNU()

if !(isincallstack("EICDI158"))
	//aadd(aRotina, {"Imprime AP", "U_RCOM001", 0, 1, 0, Nil})
	aadd(aRotina, {"Inc. Ped. Frete", "U_PEDFRT001", 0, 2, 0, Nil}) 
	aadd(aRotina, {"Incluir Custos EIC.", "U_INCDESPEIC", 0, 2, 0, Nil})     
Endif

Return