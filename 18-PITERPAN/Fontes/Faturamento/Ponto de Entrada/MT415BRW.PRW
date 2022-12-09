#INCLUDE 'RWMAKE.CH'

USER FUNCTION MT415BRW()

Local aAreaSCJ := SCJ->(GetArea())
Local aAreaSA3 := SA3->(GetArea())
public cCodVen := ''

If SA3->(dbSetOrder(7),dbSeek(xFilial("SA3")+__cUserId)) // Localiza Vendedor pelo ID
cCodVen := SA3->A3_COD
Endif

If !Empty(cCodVen)
dbSelectArea("SCJ")
Set Filter To SCJ->CJ_VEND1 $ cCodVen
Else
dbSelectArea("SCJ")
Set Filter To
EndIf

RestArea(aAreaSCJ)
RestArea(aAreaSA3)

Return()


