#Include "Protheus.ch"

User Function GatTitAB()
	Local aArea := GetArea()

	If M->E2_TIPO == "AB-"

		M->E2_PARCELA := SE2->E2_PARCELA
		M->E2_NATUREZ := SE2->E2_NATUREZ

	EndIf

	RestArea(aArea)

Return .T.
