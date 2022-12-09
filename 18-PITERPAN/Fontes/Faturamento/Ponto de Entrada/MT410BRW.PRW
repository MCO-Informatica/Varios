#include "protheus.ch"

User Function MT410BRW()

Local aAreaSC5 := SC5->(GetArea())
Local aAreaSA3 := SA3->(GetArea())
PUBLIC  cCodVen := ''

If SA3->(dbSetOrder(7),dbSeek(xFilial("SA3")+__cUserId)) // Localiza Vendedor pelo ID
cCodVen := SA3->A3_COD
Endif

If !Empty(cCodVen)
dbSelectArea("SC5")
Set Filter To SC5->C5_VEND1 $ cCodVen
Else
dbSelectArea("SC5")
Set Filter To
EndIf

RestArea(aAreaSC5)
RestArea(aAreaSA3)
Return()
