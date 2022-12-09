#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ MT120OK  ³ Totvs                         ³ Data ³ 09/11    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de entrada para validacao do PC.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120F()

Local _lRet    := .T.
Local _nPosCt  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_XCONTRA'})
Local _nPosItm := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM'   })
Local _nPosSC  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_NUMSC'  })
Local _nPosISC := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEMSC' })
Local lPms     := .F.
Local nLoop    := Nil

If AllTrim(Upper(FunName())) == "CNTA121"
	If CND->CND_XPMS == "1"
		lPms := .T.
	EndIf
EndIf

For nLoop := 1 to Len(aCols)
	If ATail(aCols[nLoop]) // aCols deletado
		Loop
	Endif

	If ! Empty(aCols[nLoop,_nPosCt])
    	dbSelectArea("PA2")
		dbSetOrder(3)

		If ! Empty(aCols[nLoop,_nPosSC])
			If dbSeek(xFilial("PA2") + cA120Num + aCols[nLoop, _nPosItm])
				Reclock("PA2", .F.)
				PA2->PA2_NUMPC := cA120Num
				PA2->PA2_ITPC  := aCols[nLoop, _nPosItm]
				MsUnlock()
			Else
				Reclock("PA2", .T.)
				PA2->PA2_FILIAL := xFilial("PA2")
			    PA2->PA2_CONTRA := aCols[nLoop,_nPosCt]
				PA2->PA2_NUMPC  := cA120Num
				PA2->PA2_ITPC   := aCols[nLoop, _nPosItm]
				PA2->PA2_USADO  := "2"
				MsUnlock()
			EndIf
		Endif
	EndIf

	If lPms
		PmsDlgPC(3,cA120Num)
	EndIf
Next

If lPms
	PmsWritePC(1,"SC7")
EndIf

Return(_lRet)
