#include "totvs.ch"
#include "rptdef.ch"

#define MARGEM_ESQUERDA_BOX_GERAL 80
#define MARGEM_DIREITA_BOX_GERAL oReport:PageWidth( ) - 94
#define MARGEM_SUPERIOR_BOX_GERAL 282
#define MARGEM_INFERIOR_BOX_GERAL oReport:PageHeight() - 450
#define MARGEM_INFERIOR_BOX_ITEMS 2800 //2080

Static lImpAuto	:=	.F.
Static oFont08	:= TFont():New('Arial',,8,,.T.)
Static oFont10	:= TFont():New('Arial',,10,,.F.)
Static oFont12	:= TFont():New( "Arial",,12,,.F.,,,,,.F.)
Static oFont12N := TFont():New( "Arial Black",,12,,.T.,,,,,.F.)

/*/{Protheus.doc} UYFATL04
Impresión del layout de invoice
@author Rodrigo Godinho
@since 23/07/2018
@version 1.0
@param cAlias, characters, Alias
@param nReg, numeric, Recno
@param nOpcx, numeric, Opcion
@type function
/*/
User Function UYFATL04( cAlias, nReg, nOpcx )
Local oReport
Local cPergunta		:= "UYFATL04"
Local lExec			:= .T.
Local aArea			:= GetArea()

//AjustaSX1(cPergunta)

If UsePergs(cAlias, nReg)
	lImpAuto := .F.
	lExec := Pergunte(cPergunta, .T.)
Else
	lImpAuto := .T.
	SetPergs(cPergunta, cAlias)
EndIf

If lExec
	If lImpAuto
		oReport := ReportDef()
	Else
		oReport := ReportDef(cPergunta)
	EndIf
	oReport:PrintDialog()
EndIf

RestArea(aArea)
Return

/*/{Protheus.doc} ReportDef
Función que configuración ( definiciones ) del informe
@author Rodrigo Godinho
@since 23/07/2018
@version 1.0
@param cPergunta, characters, Grupo de preguntas
@type function
/*/
Static Function ReportDef(cPergunta)
Local oReport
Local oSecItems
Local cRepFile	:= "layout_invoice_" + DToS(Date()) + "_" + Replace(Time(), ":", "") + "_" +  CriaTrab(,.F.)
oReport := TReport():New(cRepFile ,"Asistencias", cPergunta ,{|oReport| VldReport(oReport)},"Impresión de cadastro de asistencias en TReport.")
oReport:SetPortrait()
oReport:DisableOrientation()
oReport:HideHeader()
oReport:HideFooter()
oReport:lBold := .T.
//oReport:ShowParamPage()
oReport:lParamPage := .F.

//Hago la configuracion para que el tamaño del papel es A4
oReport:oPage:SetPaperSize(DMPAPER_A4)
If lImpAuto
	oReport:SetEdit(.F.)
EndIf

Return oReport

/*/{Protheus.doc} RunReport
Ejecuta la consulta del informe
@author Rodrigo Godinho
@since 23/07/2018
@version 1.0
@param oReport, object, Objecto de la clase TReport
@type function
/*/
Static Function RunReport(oReport)
Local aArea		:= GetArea()
Local oSecItems	:= oReport:Section(1)
Local cF1Doc	:= ""
Local cF1Serie	:= ""
Local cF1Clie	:= ""
Local cF1Loja	:= ""
Local nF1Moeda	:= 0
Local nNFTotal	:= 0
Local lFirstRec	:= .T.


Local nI		:= 0
Local cDescProd	:= ""
Local nNFPage	:= 0
Local cAliasQry	:= GetNextAlias()
Local aInfoFabr	:= {}
Local aInfoPeso	:= {}
Local aInfoPOCli:= {}
Local nTotRecs	:= 0

//Me fijo que el tamaño del papel es A4
oReport:oPage:SetPaperSize(DMPAPER_A4)

//Mientras espera la query
oReport:SetMeter(0)
oReport:IncMeter()

BeginSQL Alias cAliasQry

	Column F1_EMISSAO as Date

	SELECT
	SF1.*,
	D1_VUNIT, D1_COD,D1_LOTECTL , D1_TOTAL ,D1_ITEM ,D1_QUANT, 

	YA_CODGI, YA_DESCR,  B1_COD, B1_DESC, B1_POSIPI, B1_UM,

	SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC RUT_CLI, SA1.A1_END, SA1.A1_MUN, SA1.A1_PAIS PAIS_CLI, SA1.A1_CEP
				
	FROM %Table:SF1% SF1, %Table:SD1% SD1,%Table:SB1% SB1, %Table:SA1% SA1
	
	LEFT JOIN %Table:SYA% SYA  ON  YA_FILIAL = %xFilial:SYA% 	AND YA_CODGI = A1_PAIS AND SYA.%NotDel%	
	
	WHERE F1_FILIAL = %xFilial:SF1%
	AND F1_SERIE = %Exp:MV_PAR01% 
	AND F1_DOC = %Exp:MV_PAR02%
	AND F1_FORNECE = %Exp:MV_PAR03%
	AND F1_LOJA = %Exp:MV_PAR04%
	AND F1_ESPECIE = 'NCC'
	AND F1_FORMUL = 'S'
	AND SF1.%NotDel%

	AND D1_FILIAL = %xFilial:SD2%
	AND D1_SERIE = F1_SERIE
	AND D1_DOC = F1_DOC
	AND D1_FORNECE  = F1_FORNECE
	AND D1_LOJA = F1_LOJA
	AND SD1.%NotDel%
	AND A1_FILIAL = %xFilial:SA1%
	AND A1_COD = F1_FORNECE AND A1_LOJA = F1_LOJA
	AND SA1.%NotDel%

	AND B1_FILIAL = %xFilial:SB1%
	AND B1_COD = D1_COD
	AND SB1.%NotDel%
	
	ORDER BY D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_ITEM
	
EndSQL

Count To nTotRecs
(cAliasQry)->(dbGoTop())

oReport:SetMeter(nTotRecs)

If !(cAliasQry)->(Eof())
	While !(cAliasQry)->(Eof())
		//Cambió de factura
		If cF1Doc != (cAliasQry)->F1_DOC .Or. cF1Serie != (cAliasQry)->F1_SERIE .Or. ;
		cF1Clie != (cAliasQry)->F1_FORNECE .Or. cF1Loja != (cAliasQry)->F1_LOJA
			If lFirstRec
				lFirstRec := .F.
			Else
				MakeFooter(oReport, .T., nF1Moeda, nNFTotal,aInfoPeso)
				oReport:EndPage()
			EndIf
			cF1Doc		:= (cAliasQry)->F1_DOC
			cF1Serie	:= (cAliasQry)->F1_SERIE
			cF1Clie		:= (cAliasQry)->F1_FORNECE
			cF1Loja		:= (cAliasQry)->F1_LOJA
			nF1Moeda	:= (cAliasQry)->F1_MOEDA
			nNFTotal	:= (cAliasQry)->F1_VALBRUT
			nNFPage		:= 1
			aInfoPeso	:= {} // GetInfPeso(cF1Doc, cF1Serie, cF1Clie, cF1Loja)
			aInfoPOCli	:= {} // GetInfPOCli(cF1Doc, cF1Serie, cF1Clie, cF1Loja)
			PrintPage(oReport, cAliasQry, nNFPage, nF1Moeda, aInfoPeso, aInfoPOCli)
		EndIf
		//Llegó al límite de ítems(productos) en una página
		If oReport:Row() > (MARGEM_INFERIOR_BOX_ITEMS - oReport:LineHeight() * 4)
			MakeFooter(oReport)
			oReport:EndPage()
			nNFPage++
			PrintPage(oReport, cAliasQry, nNFPage, nF1Moeda, aInfoPeso, aInfoPOCli)
		EndIf
		oReport:SkipLine()
		aInfoFabr := GetInfFabr((cAliasQry)->D1_COD, (cAliasQry)->D1_LOTECTL)
		//Impresion del item
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 20, PadC( AllTrim( (cAliasQry)->D1_ITEM ), 4), oFont08)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 90, Transform( (cAliasQry)->D1_QUANT, PesqPict("SD1", "D1_QUANT") ), oFont08)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 290, PadC( AllTrim( (cAliasQry)->B1_UM ), 4), oFont08)
		cDescProd := AllTrim( (cAliasQry)->B1_DESC )
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 390, SubStr(cDescProd, 1, 30 ), oFont08)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 950, AllTrim( (cAliasQry)->D1_COD ), oFont08)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 1270, PadC( AllTrim( Transform( (cAliasQry)->B1_POSIPI, PesqPict("SB1", "B1_POSIPI") ) ), 12 ), oFont08)
		oReport:Say(oReport:Row(), 1560, Transform( (cAliasQry)->D1_VUNIT, PesqPict("SD1", "D1_VUNIT")), oFont08)
		oReport:Say(oReport:Row(), 1910, GetSimbCur(nF1Moeda)+' ' + Transform( (cAliasQry)->D1_TOTAL, PesqPict("SD1", "D1_TOTAL")), oFont10)
		oReport:SkipLine()
		
			//Impresion de las lineas complementares de la descripcion del producto
		For nI := 31 To Len(cDescProd) Step 30
			oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 380, AllTrim(SubStr( cDescProd, nI, 30)), oFont08)
			oReport:SkipLine()
		Next
		//Impresion de los datos de lote y PO del item
		
		cImpLote := IIF( !EMPTY(AllTrim((cAliasQry)->D1_LOTECTL)),"BATCH - "+AllTrim((cAliasQry)->D1_LOTECTL),"")
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 380, cImpLote , oFont08)
		
		cImpLote := IIF(!EMPTY(AllTrim(aInfoFabr[1])),"MANUFACTURER - "+SubStr(AllTrim(aInfoFabr[1]), 1, 20),"")
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 650, cImpLote , oFont08)
		
		cImpLote := IIF(!EMPTY(aInfoFabr[2]),"PAIS - "+SubStr(aInfoFabr[2],1,20),"")
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 1300,cImpLote, oFont08)
		
		oReport:SkipLine()
		
		oReport:IncMeter()
		(cAliasQry)->(dbSkip())
	EndDo
	MakeFooter(oReport, .T., nF1Moeda, nNFTotal,aInfoPeso)
	oReport:EndPage()
EndIf

If Select(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf

RestArea(aArea)
Return


/*/{Protheus.doc} UsePergs
Chequea se utiliza preguntas o no
@author Rodrigo Godinho
@since 23/07/2018
@version 1.0
@param cAlias, characters, descripción
@param nReg, numeric, descripción
@return logic, Se muestra las pregunta o no
@type function
/*/
Static Function UsePergs(cAlias, nReg)
Local lRet		:= .T.

If ValType(cAlias) == "C" .And. !Empty(cAlias) .And. AliasInDic(cAlias) .And. ValType(nReg) == "N" .And. nReg > 0
	(cAlias)->(dbGoTo(nReg))
	If !(cAlias)->(Eof())
		lRet := .F.
	EndIf
EndIf

Return lRet

/*/{Protheus.doc} SetPergs
Asigna los valores a los parámetros de acuerco con el registro posicionado
@author Rodrigo Godinho
@since 23/07/2018
@version 1.0
@param cPergunta, characters, Grupo de preguntas
@param cAlias, characters, descripción
@type function
/*/
Static Function SetPergs(cPergunta, cAlias)
Pergunte(cPergunta, .F.)

MV_PAR01 := (cAlias)->F1_SERIE
MV_PAR02 := (cAlias)->F1_DOC
MV_PAR03 := (cAlias)->F1_FORNECE
MV_PAR04 := (cAlias)->F1_LOJA

Return

/*/{Protheus.doc} MakeHeader
Hace la parte del header del layout
@author Rodrigo Godinho
@since 24/07/2018
@version 1.0
@param oReport, object, descripción
@type function
/*/
Static Function MakeHeader(oReport, cAliasQry)

Local nRow		:= 240
Local nHalfPage	:= oReport:PageWidth()/2
Local cNomeEnt	:= ""
Local cEndEnt	:= ""
Local cMunEnt	:= ""
Local cPaisEnt	:= ""
Local cRUTEnt	:= ""
Local cCEPEnt	:= ""


Public cDESCENG := "" //(cAliasQry)->X5_DESCENG
Public cE4DESCRI := "" // (cAliasQry)->E4_DESCRI
Public cC5XINCO := "" // (cAliasQry)->C5_XINCO


//Datos del cliente
//Chequea si tiene cliente de entrega

cDia := SUBSTR(DTOS((cAliasQry)->F1_EMISSAO),7,2)
cMes := SUBSTR(DTOS((cAliasQry)->F1_EMISSAO),5,2)
cAno := SUBSTR(DTOS((cAliasQry)->F1_EMISSAO),1,4)

nRow += 240

oReport:Say( nRow  , nHalfPage , AllTrim((cAliasQry)->RUT_CLI) , oFont12N)
oReport:Say( nRow  , 2000, cDia+'       '+cMes+'     '+cAno, oFont12N)

	cNomeEnt	:= AllTrim((cAliasQry)->A1_NOME)
	cEndEnt		:= AllTrim((cAliasQry)->A1_END)
	cMunEnt		:= AllTrim((cAliasQry)->A1_MUN)
	cPaisEnt	:= AllTrim((cAliasQry)->PAIS_CLI)
	cRUTEnt		:= AllTrim((cAliasQry)->RUT_CLI)
	cCEPEnt		:= AllTrim((cAliasQry)->A1_CEP)

nRow += 280

cEnd := AllTrim((cAliasQry)->A1_END) +', '+AllTrim((cAliasQry)->A1_MUN)+' - '+AllTrim((cAliasQry)->PAIS_CLI)
cEnd += " - CP: " + AllTrim((cAliasQry)->A1_CEP)

oReport:Say(nRow, MARGEM_ESQUERDA_BOX_GERAL + 220, AllTrim((cAliasQry)->A1_NOME), oFont12N)
nRow += 120
oReport:Say(nRow, MARGEM_ESQUERDA_BOX_GERAL + 240, cEnd , oFont12)


Return

Static Function MakeFooter(oReport, lPrintTotal, nMoeda, nTotal,aInfoPeso)
Local nRowFimBox	:= 2800
Local nColLin1		 := 1950

Default lPrintTotal	:= .F.
Default nMoeda		:= 0
Default nTotal		:= 0

If lPrintTotal
	
	cMoeda := GetSimbCur(nMoeda)
	
	nRowFimBox := 2850
	oReport:Say(nRowFimBox , 0100, "SHIP VIA - " + AllTrim(cDESCENG)		, oFont10)
	oReport:Say(nRowFimBox , 0600, "SALES TERMS - " + AllTrim(cE4DESCRI)	, oFont10)
	oReport:Say(nRowFimBox , 1200, "TERMS - "+ AllTrim(cC5XINCO)			, oFont10)
	
	If ValType(aInfoPeso) == "A" .And. Len(aInfoPeso) > 1
		nRowFimBox := 2900
		oReport:Say(nRowFimBox, 0100 , "Net weight KG:   " + Transform( aInfoPeso[1], "@E 999,999,999.999"), oFont10)
		oReport:Say(nRowFimBox, 1200 , "Gross weight KG: " + Transform( aInfoPeso[2], "@E 999,999,999.999"), oFont10)
	EndIf
	
	nRowFimBox := 3000
	oReport:Say(nRowFimBox + 020, nColLin1, cMoeda + Transform(nTotal	, PesqPict("SF1", "F1_VALBRUT"))	,oFont12N)
//	oReport:Say(nRowFimBox + 100, nColLin1, cMoeda + Transform(nTotal	, PesqPict("SF1", "F1_VALBRUT"))	,oFont12N)
	oReport:Say(nRowFimBox + 180, nColLin1, cMoeda + Transform(  0		, PesqPict("SF1", "F1_VALBRUT"))	,oFont12N)
	oReport:Say(nRowFimBox + 230, nColLin1, cMoeda + Transform(nTotal	, PesqPict("SF1", "F1_VALBRUT"))	,oFont12N)
	
EndIf

Return

/*/{Protheus.doc} VldReport
Valida las opciones del layout
@author Rodrigo Godinho
@since 30/07/2018
@type function
/*/
Static Function VldReport(oReport)
Local lExec			:= .T.
Local lNewIntent	:= .F.
Local nOpcAviso		:= 0
Local cAlias		:= Alias()

If ValType(oReport) == "O"
	If oReport:nDevice == IMP_PDF
		lExec := .F.
		nOpcAviso := Aviso("Error de impresion", "No se puede utilizar la opción generacion en PDF para este layout. ¿Le gustaría volver a intentar imprimir el layout?", {"Sí", "No"}, 2)
		If nOpcAviso == 1
			lNewIntent := .T.
		EndIf
	ElseIf oReport:nDevice == IMP_EXCEL
		lExec := .F.
		nOpcAviso := Aviso("Error de impresion", "No se puede utilizar la opción generacion en Excel para este layout. ¿Le gustaría volver a intentar imprimir el layout?", {"Sí", "No"}, 2)
		If nOpcAviso == 1
			lNewIntent := .T.
		EndIf
	ElseIf oReport:oPage:PaperSize() != DMPAPER_A4
		lExec := .F.
		nOpcAviso := Aviso("Error de impresion", "Este layout fue desarrollado para utilizar papel format A4. ¿Le gustaría volver a intentar imprimir el layout?", {"Sí", "No"}, 2)
		If nOpcAviso == 1
			lNewIntent := .T.
		EndIf
	EndIf
Else
	lExec := .F.
	nOpcAviso := Aviso("Error de impresion", "Ocurrió un error. ¿Le gustaría volver a intentar imprimir el layout?", {"Sí", "No"}, 2)
	If nOpcAviso == 1
		lNewIntent := .T.
	EndIf
EndIf
If lExec
	RunReport(oReport)
Else
	oReport:Cancel()
	If lNewIntent
		If lImpAuto
			U_UYFatL04(cAlias, (cAlias)->(Recno()))
		Else
			U_UYFatL04()
		EndIf
	EndIf
EndIf
Return lExec


/*/{Protheus.doc} PrintPage
Funcion de impresion de parte de la hoja
@author Rodrigo Godinho
@since 30/07/2018
@type function
/*/
Static Function PrintPage(oReport, cAliasQry, nNFPage, nMoeda, aInfoPeso, aInfoPOCli)
Local nColLin1	:= MARGEM_ESQUERDA_BOX_GERAL + 650
Local cMsgFact	:= ""
Local aStrPO	:= {}
Local aMsgLines	:= {}
Local cLinePO	:= ""
Local nI		:= 0
Local nRowInfo := MARGEM_INFERIOR_BOX_ITEMS
Default nNFPage	:= 1

If ValType(oReport) == "O"

	//Parte de cima
	MakeHeader(oReport, cAliasQry)
	oReport:SetRow(1150)
	RectItems(oReport, nMoeda)
	oReport:SkipLine()
	
	//Imprimo los PO's
	If ValType(aInfoPOCli) == "A" .And. Len(aInfoPOCli) > 0
		For nI := 1 To Len(aInfoPOCli)
			If Len(cLinePO + aInfoPOCli[nI] + ", ") > 100
				//Limite de 3 lineas con los PO's por el tema de espacio en el layout
				If Len(aStrPO) > 2
					Exit
				EndIf
				aAdd(aStrPO, AllTrim(cLinePO))
				cLinePO := ""
			EndIf
			cLinePO += aInfoPOCli[nI] + ", "
		Next
		cLinePO := AllTrim(cLinePO)
		//Saco la ultima coma
		If Right(cLinePO,1) == ","
			cLinePO := SubStr(cLinePO, 1, Len(cLinePO) - 1)
		EndIf
		//Agrego la linea
		aAdd(aStrPO, cLinePO)
		oReport:Say(nRowInfo, nColLin1 + 50, "Customer PO's:", oFont08)
		nRowInfo += 36
		For nI := 1 To Len(aStrPO)
			oReport:Say(nRowInfo, nColLin1 + 50, aStrPO[nI], oFont08)
			nRowInfo += 36
		Next
	EndIf
	nRowInfo := MARGEM_INFERIOR_BOX_ITEMS + 360
	cMsgFact := '' 
	If Len(cMsgFact) > 0
		aMsgLines := FWTxt2Array(cMsgFact,100)
		If ValType(aMsgLines) == "A"
			For nI := 1 To Len(aMsgLines)
				oReport:Say(nRowInfo, nColLin1 + 50, aMsgLines[nI], oFont08)
				nRowInfo += 36
				If nI == 12
					Exit
				EndIf
			Next
		EndIf
	EndIf
EndIf


Return

/*/{Protheus.doc} GetSimbCur
Retorna el simbolo de la moneda
@author Rodrigo Godinho
@since 01/08/2018
@param nMoeda, numeric, Moneda
@return character, Simbolo de la moneda
@type function
/*/
Static Function GetSimbCur(nMoeda)
Local cRet	:= ""
Default nMoeda	:= 1

If ValType(nMoeda) == "N"
	cRet := AllTrim(GetMV("MV_SIMB" + AllTrim(Str(nMoeda)), , ""))
EndIf

Return cRet

/*/{Protheus.doc} GetInfFabr
Returna informaciones del fabricante del lote
@author Rodrigo Godinho
@since 13/08/2018
@version 1.0
@param cCodProd, characters, Codigo del producto
@param cLote, characters, Codigo del lote
@return array, array con datos de nombre y pais del fabricante
@type function
/*/
Static Function GetInfFabr(cCodProd, cLote)
Local aRet		:= {}
Local aArea		:= GetArea()
Local cAliasQry	:= GetNextAlias()
Local cNomeFab	:= ""
Local cPaisFab	:= ""

If ValType(cCodProd) == "C" .And. !Empty(cCodProd) .And. ValType(cLote) == "C" .And. !Empty(cLote)
	BeginSQL Alias cAliasQry
		SELECT D1_DOC, D1_COD, D1_DTDIGIT, D1_PEDIDO, D1_ITEMPC, SD1.R_E_C_N_O_, C7_NUM, A2_COD, A2_LOJA
		, CASE WHEN A2_NREDUZ = ' ' THEN A2_NOME ELSE A2_NREDUZ END NOME_FABR
		, YA_DESCR PAIS_FABR
		FROM %Table:SD1% SD1
		LEFT JOIN %Table:SC7% SC7 ON SC7.C7_FILIAL = %xFilial:SC7% AND SC7.C7_NUM = SD1.D1_PEDIDO AND SC7.C7_ITEM = SD1.D1_ITEMPC AND SC7.%NotDel%
		LEFT JOIN %Table:SA2% SA2 ON SA2.A2_FILIAL = %xFilial:SA2% AND SA2.A2_COD = SC7.C7_FABRICA AND SA2.A2_LOJA = SC7.C7_LOJFABR AND SA2.%NotDel%
		LEFT JOIN %Table:SYA% SYA ON SYA.YA_FILIAL = %xFilial:SYA% AND SYA.YA_CODGI = SA2.A2_PAIS AND SYA.%NotDel%
		WHERE SD1.D1_FILIAL = %xFilial:SD1%
		AND SD1.D1_COD = %Exp:cCodProd%
		AND SD1.D1_LOTECTL = %Exp:cLote%
		AND SD1.%NotDel%
		ORDER BY SD1.D1_DTDIGIT DESC, SD1.R_E_C_N_O_ DESC
	EndSQL
	If !(cAliasQry)->(Eof())
		cNomeFab := AllTrim((cAliasQry)->NOME_FABR)
		cPaisFab := AllTrim((cAliasQry)->PAIS_FABR)
	EndIf
	If Select(cAliasQry)
		(cAliasQry)->(dbCloseArea())
	EndIf
EndIf

aRet := {cNomeFab, cPaisFab}

RestArea(aArea)
Return aRet

/*/{Protheus.doc} GetInfPeso
Retorna datos de peso de la factura
@author Rodrigo Godinho
@since 13/08/2018
@version 1.0
@param cDoc, characters, Documento
@param cSerie, characters, Serie
@param cCliente, characters, Cliente
@param cLoja, characters, Loja
@type function
/*/
Static Function GetInfPeso(cDoc, cSerie, cCliente, cLoja)
Local aRet		:= {}
Local aArea		:= GetArea()
Local cAliasQry	:= GetNextAlias()
Local nPesoLiq	:= 0
Local nPesoBrut	:= 0

Default cDoc	:= ""
Default cSerie	:= ""
Default cCliente:= ""
Default cLoja	:= ""

BeginSQL Alias cAliasQry
	SELECT F1_PLIQUI PESO_LIQ, F1_PBRUTO PESO_BRUTO
	FROM %Table:SF1% SF1
	WHERE F1_FILIAL = %xFilial:SF2%
	AND F2_DOC = %Exp:cDoc%
	AND F2_SERIE = %Exp:cSerie%
	AND F1_FORNECE = %Exp:cCliente%
	AND F2_LOJA = %Exp:cLoja%
	AND SF2.%NotDel%
EndSQL
If !(cAliasQry)->(Eof())
	nPesoLiq := (cAliasQry)->PESO_LIQ
	nPesoBrut := (cAliasQry)->PESO_BRUTO
	If nPesoBrut == 0
		nPesoBrut := nPesoLiq
	EndIf
EndIf
If Select(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf

aRet := {nPesoLiq, nPesoBrut}

RestArea(aArea)
Return aRet

/*/{Protheus.doc} GetInfPOCli
Retorna datos de los PO del cliente
@author Rodrigo Godinho
@since 13/08/2018
@version 1.0
@param cDoc, characters, Documento
@param cSerie, characters, Serie
@param cCliente, characters, Cliente
@param cLoja, characters, Loja
@type function
/*/
Static Function GetInfPOCli(cDoc, cSerie, cCliente, cLoja)
Local aRet		:= {}
Local aArea		:= GetArea()
Local cAliasQry	:= GetNextAlias()

Default cDoc	:= ""
Default cSerie	:= ""
Default cCliente:= ""
Default cLoja	:= ""

BeginSQL Alias cAliasQry
	SELECT DISTINCT C6_PEDCLI
	FROM %Table:SD2% SD2
	JOIN %Table:SC6% SC6 ON SC6.C6_FILIAL = %xFilial:SC6% AND SC6.C6_NUM = SD2.D2_PEDIDO AND SC6.C6_ITEM = SD2.D2_ITEMPV  AND SC6.C6_PRODUTO = SD2.D2_COD AND SC6.%NotDel%
	WHERE D2_FILIAL = %xFilial:SD2%
	AND D2_DOC = %Exp:cDoc%
	AND D2_SERIE = %Exp:cSerie%
	AND D2_CLIENTE = %Exp:cCliente%
	AND D2_LOJA = %Exp:cLoja%
	AND D2_ESPECIE = 'NF'
	AND C6_PEDCLI <> ' '
	AND SD2.%NotDel%
	ORDER BY C6_PEDCLI
EndSQL
While !(cAliasQry)->(Eof())
	aAdd(aRet, AllTrim((cAliasQry)->C6_PEDCLI))
	(cAliasQry)->(dbSkip())
EndDo
If Select(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf

RestArea(aArea)
Return aRet



/*/{Protheus.doc} AjustaSX1
Creacion de preguntas
@author Rodrigo Godinho
@since 23/07/2018
@version 1.0
@param cPergunta, characters, Grupo de preguntas
@type function
/*/
Static Function AjustaSX1(cPergunta)
Local nTamSerie	:= GetSX3Cache("F1_SERIE", "X3_TAMANHO")
Local nTamDoc	:= GetSX3Cache("F1_DOC", "X3_TAMANHO")
Local nTamCli	:= GetSX3Cache("F1_FORNECE", "X3_TAMANHO")
Local nTamLoja	:= GetSX3Cache("F1_LOJA", "X3_TAMANHO")

U_PutSx1UY( cPergunta, "01", "¿Serie ?", "¿Serie ?", "¿Serie ?", "MV_CH1", "C", nTamSerie, 0, 0, "G",;
"", "", "", "", "MV_PAR01" )

U_PutSx1UY( cPergunta, "02", "¿Doc. ?", "¿Doc. ?", "¿Doc. ?", "MV_CH2", "C", nTamDoc, 0, 0, "G",;
"", "", "", "", "MV_PAR02" )

U_PutSx1UY( cPergunta, "03", "¿Cliente ?", "¿Cliente ?", "¿Cliente ?", "MV_CH3", "C", nTamCli, 0, 0, "G",;
"", "SA1", "", "", "MV_PAR03" )

U_PutSx1UY( cPergunta, "04", "¿Tienda ?", "¿Tienda  ?", "¿Tienda  ?", "MV_CH4", "C", nTamLoja, 0, 0, "G",;
"", "", "", "", "MV_PAR04" )

Return

Static Function RectItems(oReport, nMoeda)

//Títulos
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 0020, "ITEM", 		oFont10)
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 0130, "QTY", 		oFont10)
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 0280, "UNIT", 		oFont10)
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 0550, "DESCRIPTION",	oFont10)
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 1000, "IMCD CODE", 	oFont10) 
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 1300, "NCM", 		oFont10)
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 1500, "UNIT PRICE", 	oFont10)

oReport:IncRow(030)
Return()