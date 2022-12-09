#INCLUDE "PROTHEUS.CH"

User Function MT150SCR()

	Local oNewDialog  := PARAMIXB// Rotina do usuário que manipula as propriedades do oDlg
	Local aObjects  := {}
	Local aInfo 	 := {}
	Local aPosGet	 := {}
	Local aPosObj   := {}
	Local aSizeAut  := {}
	
	If !l150Auto
		aSizeAut	:= MsAdvSize()
	EndIf
	
	aObjects := {}
	AAdd( aObjects, { 0,    41, .T., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 0,    75, .T., .F. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,;
				{{10,40,95,140,200,222,268,240},;
				{10,40,111,140,223,268,63},;
				{5,70,160,205,295},;
				{6,34,200,215},;
				{6,34,80,113,153,178},;
				{6,34,245,268,260},;
				{10,50,150,190,120},;
				{273,130,190},;
				{8,45,73,103,139,167,190,225,253},;
				{144,190,144,190,289,293},;
				{142,293,140},;
				{9,47,188,148,9,146} } )
				
				@ aPosObj[1][1]+37,aPosGet[2,3] SAY "TESTE" OF oNewDialog PIXEL SIZE 030,006 // "Taxa da Moeda"

Return