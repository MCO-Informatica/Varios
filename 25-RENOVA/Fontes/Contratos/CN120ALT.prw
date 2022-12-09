#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN120ALT  ³ Autor ³ WELLINGTON MENDES ³ Data ³ 16.04.18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de entrada executado no momento da geracao de tiutlos ³±±
±±³          ³provisionados no Financeiro apos alterar a situacao do Cto. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120ALT()
Local aCab:= PARAMIXB[1]
Local cTipo:= PARAMIXB[2]
Local _aPref    := StrToArray(GetMv("MV_XRENPRF"),";")
Local _aPref2   := StrToArray(GetMv("MV_XRENPR2"),";")  //Criado porque no parametro MV_XRENPRF não cabe mais.
Local _cPref    := ""
Local nPOsPref:= aScan(aCab,{|x| x[1] == "E2_PREFIXO"})
Local nPOsNum   := aScan(aCab,{|x| x[1] == "E2_NUM"})
Local nPOsParc   := aScan(aCab,{|x| x[1] == "E2_PARCELA"})
Local nPOsTipo   := aScan(aCab,{|x| x[1] == "E2_TIPO"})
Local nPOsForn  := aScan(aCab,{|x| x[1] == "E2_FORNECE"})
Local nPOsLoja  := aScan(aCab,{|x| x[1] == "E2_LOJA"})
Local _AreaAnt := GetArea()


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
	/*
	DbSelectArea("SE2")
	DbSetOrder(1)
	IF  DbSeek(xFilial("SE2")+aCab[nPOsPref][2]+aCab[nPOsNum][2]+aCab[nPOsParc][2]+aCab[nPOsTipo][2]+aCab[nPOsForn][2]+aCab[nPOsLoja][2])
	aCab[nPOsNum][2]:= SOMA1(aCab[nPOsNum][2],9)
	Endif
	
	RestArea(_AreaAnt)
	*/
Else
	aCab:= PARAMIXB[1]
Endif

Return aCab
