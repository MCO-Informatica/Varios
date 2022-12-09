#Include 'Protheus.ch'

User Function SD3250I()

	Local aAreaSD3    := SD3->(GetArea())
	Local aAreaSDA    := SDA->(GetArea())
	Local aAreaSDB    := SDB->(GetArea())
	Local aAreaSC2    := SC2->(GetArea())
	Local aAreaSB2    := SB2->(GetArea())
	Local aAreaSBF    := SBF->(GetArea())
	Local aAreaSB5    := SB5->(GetArea())
	Local aAreaSB8    := SB8->(GetArea())
	
	Alert(SC2->C2_NUM)
	
	RestArea(aAreaSD3)
	RestArea(aAreaSDA)
	RestArea(aAreaSDB)
	RestArea(aAreaSC2)
	RestArea(aAreaSB2)
	RestArea(aAreaSBF)
	RestArea(aAreaSB5)
	RestArea(aAreaSB8)

Return .T.