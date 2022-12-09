

USER FUNCTION MT415BRW()

Local aAreaSCJ := SCJ->(GetArea())
Local aAreaSA3 := SA3->(GetArea())
Local cCodVen := ''
Local cFiltro := ''
If SA3->(dbSetOrder(7),dbSeek(xFilial("SA3")+__cUserId)) // Localiza Vendedor pelo ID
    cCodVen := SA3->A3_COD
Endif

If !Empty(cCodVen)
    cFiltro := "CJ_VEND1 == '"+cCodVen+"' "
EndIf

RestArea(aAreaSCJ)
RestArea(aAreaSA3)

return cFiltro


