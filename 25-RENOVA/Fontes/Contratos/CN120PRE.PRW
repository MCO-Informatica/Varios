#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN120PRE() ³ Autor ³ WELLINGTON MENDES ³ Data ³ 09.04.18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³PONTO DE ENTRADA PARA ALTERAR A VARIAVEL cRetPrf - prefixo
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120PRE()

Local cPrefixo:= PARAMIXB[1]
Local cTipo:= PARAMIXB[2]
Local _aPref    := StrToArray(GetMv("MV_XRENPRF"),";")
Local _aPref2   := StrToArray(GetMv("MV_XRENPR2"),";")  //Criado porque no parametro MV_XRENPRF não cabe mais.
//ALTERA A VARIAVEL LOCAL  cRetPrf DA FUNÇÃO PADRÃO CN120MedEst

IF cTipo == '2'
	
	For nX := 1 to Len(_aPref)
		If Left(_aPref[nX], 3) == CN9->CN9_TPCTO
			cPrefixo := PadR( SubStr(_aPref[nX], 5, Len(_aPref[nX])), Len( SE2->E2_PREFIXO ) )
		EndIf
	Next nX
	
	
	For nX2 := 1 to Len(_aPref2)  // continuacao de _aPref
		If Left(_aPref2[nX2], 3) == CN9->CN9_TPCTO
			cPrefixo := PadR( SubStr(_aPref2[nX2], 5, Len(_aPref2[nX2])), Len( SE2->E2_PREFIXO ) )
		Endif
	Next nX2
	
ENDIF
RETURN(cPrefixo)
