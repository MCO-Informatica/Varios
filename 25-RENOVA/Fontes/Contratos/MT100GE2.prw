#INCLUDE "PROTHEUS.CH"


User Function MT100GE2()

Local aArea    := GetArea()
Local aAreaSC7 := SC7->(GetArea())
Local aAreaSA2 := SA2->(GetArea())
Local aAreaSE2 := SE2->(GetArea())   

dbSelectArea("SC7")
dbSetOrder(1)
If MsSeek(xFilial("SC7") + SD1->D1_PEDIDO)
	If !Empty(SC7->C7_XOBSPA)
		SE2->E2_XOBSPA := SC7->C7_XOBSPA
	EndIf
EndIf

RestArea(aArea)
RestArea(aAreaSC7)
RestArea(aAreaSA2)
RestArea(aAreaSE2)

Return