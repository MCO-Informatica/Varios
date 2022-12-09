#Include 'Protheus.ch'

User Function shGatDat()

	local aArea 		:= getArea()
	local dRet			:= M->C5_DTENTR
	//local nPosProduto	:= gdFieldPos("C6_PRODUTO")
	//local nPosItem  	:= gdFieldPos("C6_ITEM")
	local nPosDtEnt 	:= gdFieldPos("C6_DTENTR")
	//Local dDataEntr     := M->C5_DTENTR
	Local n := 1


	If Len(aCols) >= 1
		For n := 1 to Len(aCols)
			aCols[n][nPosDtEnt] := M->C5_DTENTR
		Next
	EndIf

	restArea(aArea)

Return dRet
