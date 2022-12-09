
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VQCT650D  ºAutor  ³Felipe - Armi       º Data ³  03/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Rotina para localizar a conta Debito do lancamento 650    º±±
±±º          ³ Compras                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// LINHA ORIGINAL -> IIF(EMPTY(ALLTRIM(SD1->D1_CONTA)),POSICIONE("SF4",1,xFilial("SF4")+SD1->D1_TES,"&F4_XCTAD"),SD1->D1_CONTA)

User Function VQCT650D()

Local _aAreaD1   := SD1->(GetArea())
Local _aAreaE2   := SE2->(GetArea())
Local _aAreaED   := SED->(GetArea())
Local _aAreaF4   := SF4->(GetArea())

Local _cConta  := ""

DbSelectArea("SF4") ; DbSetOrder(1)
DbSelecTArea("SE2") ; DbSetORder(6)
DbSelectArea("SED") ; DbSetOrder(1)
DbSelectArea("SD1") ; DbSetOrder(1)


If !Empty(SD1->D1_CONTA)
	_cConta  := ALLTRIM(SD1->D1_CONTA)
EndIf


	IF EMPTY(_cConta)
		
		If SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES))
			If !Empty(SF4->F4_XCTAD)
				_cConta := AllTrim(SF4->F4_XCTAD)
			EndIf
		EndIf
	
	EndIf

	IF EMPTY(_cConta) //.and. SA2->A2_EXT = "EX" 
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+SD1->D1_COD)
		_cConta := SB1->B1_CONTA
	EndIf	

	IF EMPTY(_cConta)		
		//		If SD1->(DbSeek(xFilial("SD1")+SD1->(D1_FORNECE+D1_LOJA+D1_SERIE+D1_DOC)))
		If DbSeek(xFilial("SED")+SE2->E2_NATUREZ)
			If !Empty(SED->ED_CONTA)
				_cConta := AllTrim(SED->ED_CONTA)
				
			EndIf
		EndIf
		
	EndIf
	




SD1->(RestArea(_aAreaD1))
SE2->(RestArea(_aAreaE2))
SED->(RestArea(_aAreaED))
SF4->(RestArea(_aAreaF4))

Return(_cConta)
