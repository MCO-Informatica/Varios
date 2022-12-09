#Include "Protheus.ch"

/*/{Protheus.doc} CN121AFN
Nota rotina para tratar títulos gerados pela medição de contrato CNTA121
@type User_function
@version 1
@author André Couto
@since 10/04/2022
@return return_Array, com cabeçalho dos títulos gerados

@See https://tdn.totvs.com/pages/releaseview.action?pageId=274840426
@See https://tdn.totvs.com/pages/releaseview.action?pageId=578632647

/*/ // OK
User Function CN121AFN()
    //Local aResult   := Nil //Retornar nulo caso nao modifique o array
	Local aCab      := PARAMIXB[1]
	Local cTipo     := PARAMIXB[2]
	Local _aPref    := StrToArray(GetMv("MV_XRENPRF"),";")
	Local _aPref2   := StrToArray(GetMv("MV_XRENPR2"),";")  //Criado porque no parametro MV_XRENPRF não cabe mais.
	Local _cPref    := ""
	Local nPOsPref  := aScan(aCab,{|x| x[1] == "E2_PREFIXO"})
	Local nX 		:= 0
	Local nX2		:= 0
	Local _AreaAnt  := GetArea()


	If cTipo == '1' // COMPRA
		//ATUALIZA PREFIXO CONFORME PARAMETRO ESPECIFICO
		For nX := 1 to Len(_aPref)
			If Left(_aPref[nX], 3) == CN9->CN9_TPCTO
				_cPref := PadR( SubStr(_aPref[nX], 5, Len(_aPref[nX])), Len( SE2->E2_PREFIXO ) )
			EndIf
		Next nX

		If EMPTY(_cPref)
			For nX2 := 1 to Len(_aPref2)  // continuacao de _aPref
				If Left(_aPref2[nX2], 3) == CN9->CN9_TPCTO
					_cPref := PadR( SubStr(_aPref2[nX2], 5, Len(_aPref2[nX2])), Len( SE2->E2_PREFIXO ) )
				EndIf
			Next nX2
		ENDIF

		If Empty(_cPref)
			_cPref := "MED"
		EndIf

		If nPOsPref > 0
			aCab[nPOsPref][2]:= _cPref
		Endif

	ElseIF cTipo == '2' //VENDA

		For nX := 1 to Len(_aPref)
			If Left(_aPref[nX], 3) == CN9->CN9_TPCTO
				cPrefixo := PadR( SubStr(_aPref[nX], 5, Len(_aPref[nX])), Len( SE1->E1_PREFIXO ) )
			EndIf
		Next nX

		For nX2 := 1 to Len(_aPref2)  // continuacao de _aPref
			If Left(_aPref2[nX2], 3) == CN9->CN9_TPCTO
				cPrefixo := PadR( SubStr(_aPref2[nX2], 5, Len(_aPref2[nX2])), Len( SE1->E1_PREFIXO ) )
			Endif
		Next nX2

	Endif

	RestArea(_AreaAnt)

Return aCab
