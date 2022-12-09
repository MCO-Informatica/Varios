#include "totvs.ch"
#include "rptdef.ch"

#define MARGEM_ESQUERDA_BOX_GERAL 84
#define MARGEM_DIREITA_BOX_GERAL oReport:PageWidth( ) - 94
#define MARGEM_SUPERIOR_BOX_GERAL 282
#define MARGEM_INFERIOR_BOX_GERAL oReport:PageHeight() - 450
#define MARGEM_INFERIOR_BOX_ITEMS 2080

Static lImpAuto	:=	.F.

/*/{Protheus.doc} UYFATL01
Impresión del layout de invoice
@author Rodrigo Godinho
@since 23/07/2018
@version 1.0
@param cAlias, characters, Alias
@param nReg, numeric, Recno
@param nOpcx, numeric, Opcion
@type function
/*/
User Function UYFATL01( cAlias, nReg, nOpcx )
Local oReport
Local cPergunta		:= "UYFATL01"
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
//Hago la configuracion para que el tamaño del papel es A4
oReport:oPage:SetPaperSize(DMPAPER_A4)
oReport:lParamPage := .F.

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
Local cF2Doc	:= ""
Local cF2Serie	:= ""
Local cF2Clie	:= ""
Local cF2Loja	:= ""
Local nF2Moeda	:= 0
Local nNFTotal	:= 0
Local lFirstRec	:= .T.
Local nRowLote	:= 0
Local oFontSt01	:= TFont():New('Courier New',,-9,,.T.)
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
	Column F2_EMISSAO as Date
	Column C5_EMISSAO as Date
	SELECT  F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_CLIENT, F2_LOJENT, F2_EMISSAO, F2_MOEDA, F2_VALBRUT,
	D2_QUANT, D2_ITEM, B1_DESC, D2_COD, D2_PRCVEN, B1_POSIPI, B1_UM, D2_TOTAL, D2_LOTECTL, X5_DESCENG X5DESCENG,
	E4_DESCRI, C5_NUM, C5_EMISSAO, C5_XINCO, C5_USERLGI, C6_PEDCLI, A3_NOME,
	SA1.A1_NOME, SA1.A1_CGC RUT_CLI, SA1.A1_END, SA1.A1_MUN, SA1.PAIS PAIS_CLI, SA1.A1_CEP,
	SA1_ENT.A1_NOME A1_NOMEENT, SA1_ENT.A1_CGC RUT_CLIENT, SA1_ENT.A1_END A1_ENDENT, SA1_ENT.A1_MUN A1_MUNENT, SA1_ENT.PAIS PAIS_CLIEN, SA1_ENT.A1_CEP A1_CEPENT
	,C5_BANCO ,C5_XNUMAGE,C5_XNUMCON
	
	FROM
	(
	SELECT F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_CLIENT, F2_LOJENT, F2_EMISSAO, F2_COND, F2_MOEDA, F2_VEND1, F2_VALBRUT
	FROM %Table:SF2%
	WHERE F2_FILIAL = %xFilial:SF2%
	AND F2_SERIE BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND F2_DOC BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND F2_CLIENTE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR07%
	AND F2_LOJA BETWEEN %Exp:MV_PAR06% AND %Exp:MV_PAR08%
	AND F2_ESPECIE = 'NF'
	AND %NotDel%
	) SF2
	JOIN
	(
	SELECT D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_ITEM, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_PEDIDO, D2_LOTECTL, D2_ITEMPV
	FROM %Table:SD2%
	WHERE D2_FILIAL = %xFilial:SD2%
	AND D2_SERIE BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND D2_DOC BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND D2_CLIENTE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR07%
	AND D2_LOJA BETWEEN %Exp:MV_PAR06% AND %Exp:MV_PAR08%
	AND D2_ESPECIE = 'NF'
	AND %NotDel%
	) SD2 ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA
	JOIN
	(
	SELECT A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_END, A1_MUN, A1_CEP, YA_DESCR PAIS
	FROM %Table:SA1%
	LEFT JOIN
	(
	SELECT YA_CODGI, YA_DESCR
	FROM %Table:SYA%
	WHERE YA_FILIAL = %xFilial:SYA%
	AND %NotDel%
	) SYA ON YA_CODGI = A1_PAIS
	WHERE A1_FILIAL = %xFilial:SA1%
	AND %NotDel%
	) SA1 ON SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA
	LEFT JOIN
	(
	SELECT A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_END, A1_MUN, A1_CEP, YA_DESCR PAIS
	FROM %Table:SA1%
	LEFT JOIN
	(
	SELECT YA_CODGI, YA_DESCR
	FROM %Table:SYA%
	WHERE YA_FILIAL = %xFilial:SYA%
	AND %NotDel%
	) SYA ON YA_CODGI = A1_PAIS
	WHERE A1_FILIAL = %xFilial:SA1%
	AND %NotDel%
	) SA1_ENT ON SA1_ENT.A1_COD = SF2.F2_CLIENT AND SA1_ENT.A1_LOJA = SF2.F2_LOJENT
	LEFT JOIN
	(
	SELECT A3_COD, A3_NOME
	FROM %Table:SA3%
	WHERE A3_FILIAL = %xFilial:SA3%
	AND %NotDel%
	) SA3 ON SA3.A3_COD = SF2.F2_VEND1
	LEFT JOIN
	(
	SELECT E4_CODIGO, E4_DESCRI
	FROM %Table:SE4%
	WHERE E4_FILIAL = %xFilial:SE4%
	AND %NotDel%
	) SE4 ON SE4.E4_CODIGO = SF2.F2_COND
	LEFT JOIN
	(
	SELECT B1_COD, B1_DESC, B1_POSIPI, B1_UM
	FROM %Table:SB1%
	WHERE B1_FILIAL = %xFilial:SB1%
	AND %NotDel%
	) SB1 ON SB1.B1_COD = SD2.D2_COD
	LEFT JOIN
	(
	SELECT C5_NUM, C5_EMISSAO, C5_XVIA, C5_XINCO, C5_USERLGI ,C5_BANCO ,C5_XNUMAGE,C5_XNUMCON
	FROM %Table:SC5%
	WHERE C5_FILIAL = %xFilial:SC5%
	AND %NotDel%
	) SC5 ON SC5.C5_NUM = SD2.D2_PEDIDO
	LEFT JOIN
	(
	SELECT C6_NUM, C6_ITEM, C6_PRODUTO, C6_PEDCLI
	FROM %Table:SC6%
	WHERE C6_FILIAL = %xFilial:SC6%
	AND %NotDel%
	) SC6 ON SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_ITEM = SD2.D2_ITEMPV  AND SC6.C6_PRODUTO = SD2.D2_COD
	LEFT JOIN
	(
	SELECT DBF_VIA, DBF_CODVIA
	FROM %Table:DBF%
	WHERE DBF_FILIAL = %xFilial:DBF%
	AND %NotDel%
	) DBF ON DBF.DBF_VIA = SC5.C5_XVIA
	LEFT JOIN
	(
	SELECT SX5.X5_CHAVE, SX5.X5_DESCENG
	FROM %Table:SX5% SX5
	WHERE X5_FILIAL = %xFilial:SX5%
	AND X5_TABELA = 'Y3'
	AND %NotDel%
	) SX5 ON TRIM(SX5.X5_CHAVE) = SUBSTR(TRIM(DBF.DBF_CODVIA),1,1)
	ORDER BY D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_ITEM
EndSQL

Count To nTotRecs
(cAliasQry)->(dbGoTop())

oReport:SetMeter(nTotRecs)

If !(cAliasQry)->(Eof())
	While !(cAliasQry)->(Eof())
		//Cambió de factura
		If cF2Doc != (cAliasQry)->F2_DOC .Or. cF2Serie != (cAliasQry)->F2_SERIE .Or. cF2Clie != (cAliasQry)->F2_CLIENTE .Or. cF2Loja != (cAliasQry)->F2_LOJA
			If lFirstRec
				lFirstRec := .F.
			Else
				RectLotes(oReport, .T., nF2Moeda, nNFTotal)
				MakeFooter(oReport)
				oReport:EndPage()
			EndIf
			cF2Doc		:= (cAliasQry)->F2_DOC
			cF2Serie	:= (cAliasQry)->F2_SERIE
			cF2Clie		:= (cAliasQry)->F2_CLIENTE
			cF2Loja		:= (cAliasQry)->F2_LOJA
			nF2Moeda	:= (cAliasQry)->F2_MOEDA
			nNFTotal	:= (cAliasQry)->F2_VALBRUT
			nNFPage		:= 1
			aInfoPeso	:= GetInfPeso(cF2Doc, cF2Serie, cF2Clie, cF2Loja)
			aInfoPOCli	:= GetInfPOCli(cF2Doc, cF2Serie, cF2Clie, cF2Loja)
			PrintPage(oReport, cAliasQry, nNFPage, nF2Moeda, aInfoPeso, aInfoPOCli)
			nRowLote	:= MARGEM_INFERIOR_BOX_ITEMS + 96
		EndIf
		//Llegó al límite de ítems(productos) en una página
		If oReport:Row() > (MARGEM_INFERIOR_BOX_ITEMS - oReport:LineHeight() * 4)
			RectLotes(oReport)
			MakeFooter(oReport)
			oReport:EndPage()
			nNFPage++
			PrintPage(oReport, cAliasQry, nNFPage, nF2Moeda, aInfoPeso, aInfoPOCli)
			nRowLote := MARGEM_INFERIOR_BOX_ITEMS + 96
		EndIf
		aInfoFabr := GetInfFabr((cAliasQry)->D2_COD, (cAliasQry)->D2_LOTECTL)
		//Impresion del item
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 10, PadC( AllTrim( (cAliasQry)->D2_ITEM ), 4), oFontSt01)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 80, Transform( (cAliasQry)->D2_QUANT, PesqPict("SD2", "D2_QUANT") ), oFontSt01)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 276, PadC( AllTrim( (cAliasQry)->B1_UM ), 4), oFontSt01)
		cDescProd := AllTrim( (cAliasQry)->B1_DESC )
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 380, SubStr(cDescProd, 1, 30 ), oFontSt01)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 940, AllTrim( (cAliasQry)->D2_COD ), oFontSt01)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 1260, PadC( AllTrim( Transform( (cAliasQry)->B1_POSIPI, PesqPict("SD2", "B1_POSIPI") ) ), 12 ), oFontSt01)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 1470, PadC( AllTrim( aInfoFabr[2] ), 15), oFontSt01)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 1630, Transform( (cAliasQry)->D2_PRCVEN, PesqPict("SD2", "D2_PRCVEN")), oFontSt01)
		oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 1850, Transform( (cAliasQry)->D2_TOTAL, PesqPict("SD2", "D2_TOTAL")), oFontSt01)
		oReport:SkipLine()
		//Impresion de las lineas complementares de la descripcion del producto
		For nI := 31 To Len(cDescProd) Step 30
			oReport:Say(oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL + 380, AllTrim(SubStr( cDescProd, nI, 30)), oFontSt01)
			oReport:SkipLine()
		Next
		//Impresion de los datos de lote y PO del item
		oReport:Say(nRowLote, MARGEM_ESQUERDA_BOX_GERAL + 12, AllTrim((cAliasQry)->D2_ITEM), oFontSt01)
		oReport:Say(nRowLote, MARGEM_ESQUERDA_BOX_GERAL + 105, AllTrim((cAliasQry)->D2_LOTECTL), oFontSt01)
		oReport:Say(nRowLote, MARGEM_ESQUERDA_BOX_GERAL + 295, SubStr(AllTrim(aInfoFabr[1]), 1, 20), oFontSt01)
		nRowLote += 36
		oReport:IncMeter()
		(cAliasQry)->(dbSkip())
	EndDo
	RectLotes(oReport, .T., nF2Moeda, nNFTotal)
	MakeFooter(oReport)
	oReport:EndPage()
EndIf

If Select(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf

RestArea(aArea)
Return

/*/{Protheus.doc} AjustaSX1
Creacion de preguntas
@author Rodrigo Godinho
@since 23/07/2018
@version 1.0
@param cPergunta, characters, Grupo de preguntas
@type function
/*/
Static Function AjustaSX1(cPergunta)
Local nTamSerie	:= GetSX3Cache("D2_SERIE", "X3_TAMANHO")
Local nTamDoc	:= GetSX3Cache("D2_DOC", "X3_TAMANHO")
Local nTamCli	:= GetSX3Cache("D2_CLIENTE", "X3_TAMANHO")
Local nTamLoja	:= GetSX3Cache("D2_LOJA", "X3_TAMANHO")

U_PutSx1UY( cPergunta, "01", "¿Serie desde?", "¿Serie desde?", "¿Serie desde?", "MV_CH1", "C", nTamSerie, 0, 0, "G",;
"", "", "", "", "MV_PAR01" )

U_PutSx1UY( cPergunta, "02", "¿Serie hasta?", "¿Serie hasta?", "¿Serie hasta?", "MV_CH2", "C", nTamSerie, 0, 0, "G",;
"", "", "", "", "MV_PAR02" )

U_PutSx1UY( cPergunta, "03", "¿Doc. desde?", "¿Doc. desde?", "¿Doc. desde?", "MV_CH3", "C", nTamDoc, 0, 0, "G",;
"", "", "", "", "MV_PAR03" )

U_PutSx1UY( cPergunta, "04", "¿Doc. hasta?", "¿Doc. hasta?", "¿Doc. hasta?", "MV_CH4", "C", nTamDoc, 0, 0, "G",;
"", "", "", "", "MV_PAR04" )

U_PutSx1UY( cPergunta, "05", "¿Cliente desde?", "¿Cliente desde?", "¿Cliente desde?", "MV_CH5", "C", nTamCli, 0, 0, "G",;
"", "SA1", "", "", "MV_PAR05" )

U_PutSx1UY( cPergunta, "06", "¿Tienda desde?", "¿Tienda  desde?", "¿Tienda  desde?", "MV_CH6", "C", nTamLoja, 0, 0, "G",;
"", "", "", "", "MV_PAR06" )

U_PutSx1UY( cPergunta, "07", "¿Cliente hasta?", "¿Cliente hasta?", "¿Cliente hasta?", "MV_CH7", "C", nTamCli, 0, 0, "G",;
"", "SA1", "", "", "MV_PAR07")

U_PutSx1UY( cPergunta, "08", "¿Tienda hasta?", "¿Tienda  hasta?", "¿Tienda  hasta?", "MV_CH8", "C", nTamLoja, 0, 0, "G",;
"", "", "", "", "MV_PAR08")
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
MV_PAR01 := (cAlias)->F2_SERIE
MV_PAR02 := (cAlias)->F2_SERIE
MV_PAR03 := (cAlias)->F2_DOC
MV_PAR04 := (cAlias)->F2_DOC
MV_PAR05 := (cAlias)->F2_CLIENTE
MV_PAR06 := (cAlias)->F2_LOJA
MV_PAR07 := (cAlias)->F2_CLIENTE
MV_PAR08 := (cAlias)->F2_LOJA
Return

/*/{Protheus.doc} MakeBox
Crea cajas en el informe
@author Rodrigo Godinho
@since 23/07/2018
@version 1.0
@param oReport, object, descripción
@param nTop, numeric, descripción
@param nLeft, numeric, descripción
@param nBottom, numeric, descripción
@param nRight, numeric, descripción
@param nSize, numeric, descripción
@type function
/*/
Static Function MakeBox(oReport, nTop, nLeft, nBottom, nRight, nSize)
//Linha superior
oReport:FillRect({nTop, nLeft, nTop + nSize, nRight})
//Linha esquerda
oReport:FillRect({nTop, nLeft, nBottom, nLeft + nSize})
//Linha direita
oReport:FillRect({nTop, nRight, nBottom, nRight + nSize})
//Linha inferior
oReport:FillRect({nBottom, nLeft, nBottom + nSize, nRight + nSize})

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
Local cFileLogo := GetSrvProfString('Startpath','') + GetMV("UY_LGLAYOT",,"imcd_header_layouts.png")
Local oFontSt01	:= TFont():New('Arial Black',,-10,,.T.)
Local oFontSt02	:= TFont():New('Arial',,-8,,.F.)
Local oFontSt03	:= TFont():New('Arial',,-7,,.F.)
Local nRow		:= MARGEM_SUPERIOR_BOX_GERAL + 190
Local nHalfPage	:= oReport:PageWidth()/2
Local nLinSize	:= 36
Local cNomeEnt	:= ""
Local cEndEnt	:= ""
Local cMunEnt	:= ""
Local cPaisEnt	:= ""
Local cRUTEnt	:= ""
Local cCEPEnt	:= ""


oReport:SayBitmap(MARGEM_SUPERIOR_BOX_GERAL + 48, MARGEM_ESQUERDA_BOX_GERAL + 38, cFileLogo,  1960, 94)
SayCenter(oReport, "INVOICE - " + (cAliasQry)->F2_SERIE + (cAliasQry)->F2_DOC, oFontSt01, nRow)
nRow += 90
//Datos de la empresa
SayCenter(oReport, AllTrim(FWFilRazSocial()), oFontSt01, nRow)
nRow += 50
SayCenter(oReport, AllTrim(SM0->M0_ENDCOB), oFontSt02, nRow)
nRow += nLinSize
SayCenter(oReport, AllTrim(SM0->M0_CIDCOB), oFontSt02, nRow)
nRow += nLinSize
If !Empty(SM0->M0_TEL) .And. !Empty(SM0->M0_FAX)
	SayCenter(oReport, "Tel: " + AllTrim(SM0->M0_TEL) +  " - Fax: " + AllTrim(SM0->M0_FAX) , oFontSt02, nRow)
	nRow += nLinSize
ElseIf !Empty(SM0->M0_TEL) .And. Empty(SM0->M0_FAX)
	SayCenter(oReport, "Tel: " + AllTrim(SM0->M0_TEL), oFontSt02, nRow)
	nRow += nLinSize
ElseIf Empty(SM0->M0_TEL) .And. !Empty(SM0->M0_FAX)
	SayCenter(oReport, "Fax: " + AllTrim(SM0->M0_FAX), oFontSt02, nRow)
	nRow += nLinSize
EndIf
SayCenter(oReport, "RUT: " + AllTrim(SM0->M0_CGC), oFontSt02, nRow)
nRow += 110
//Datos del cliente
//Chequea si tiene cliente de entrega
If !Empty((cAliasQry)->F2_CLIENT) .And. !Empty((cAliasQry)->F2_LOJENT)
	cNomeEnt	:= AllTrim((cAliasQry)->A1_NOMEENT)
	cEndEnt		:= AllTrim((cAliasQry)->A1_ENDENT)
	cMunEnt		:= AllTrim((cAliasQry)->A1_MUNENT)
	cPaisEnt	:= AllTrim((cAliasQry)->PAIS_CLIEN)
	cRUTEnt		:= AllTrim((cAliasQry)->RUT_CLIENT)
	cCEPEnt		:= AllTrim((cAliasQry)->A1_CEPENT)
Else
	cNomeEnt	:= AllTrim((cAliasQry)->A1_NOME)
	cEndEnt		:= AllTrim((cAliasQry)->A1_END)
	cMunEnt		:= AllTrim((cAliasQry)->A1_MUN)
	cPaisEnt	:= AllTrim((cAliasQry)->PAIS_CLI)
	cRUTEnt		:= AllTrim((cAliasQry)->RUT_CLI)
	cCEPEnt		:= AllTrim((cAliasQry)->A1_CEP)
EndIf

oReport:Say(nRow - 5, MARGEM_ESQUERDA_BOX_GERAL + 10, "BILL TO:", oFontSt01)
oReport:Say(nRow, MARGEM_ESQUERDA_BOX_GERAL + 200, AllTrim((cAliasQry)->A1_NOME), oFontSt02)
oReport:Say(nRow - 5, nHalfPage + 100, "SHIP TO:", oFontSt01)
oReport:Say(nRow, nHalfPage + 300, cNomeEnt, oFontSt02)
nRow += nLinSize
oReport:Say(nRow, MARGEM_ESQUERDA_BOX_GERAL + 200, AllTrim((cAliasQry)->A1_END), oFontSt03)
oReport:Say(nRow, nHalfPage + 300, cEndEnt, oFontSt03)
nRow += nLinSize
oReport:Say(nRow, MARGEM_ESQUERDA_BOX_GERAL + 200, AllTrim((cAliasQry)->A1_MUN), oFontSt03)
oReport:Say(nRow, nHalfPage + 300, cMunEnt, oFontSt03)
nRow += nLinSize
oReport:Say(nRow, MARGEM_ESQUERDA_BOX_GERAL + 200, AllTrim((cAliasQry)->PAIS_CLI), oFontSt03)
oReport:Say(nRow, nHalfPage + 300, cPaisEnt, oFontSt03)
nRow += nLinSize
oReport:Say(nRow, MARGEM_ESQUERDA_BOX_GERAL + 200, "Doc. Id.: " + AllTrim((cAliasQry)->RUT_CLI), oFontSt03)
oReport:Say(nRow, nHalfPage + 300, "Doc. Id.: " + cRUTEnt, oFontSt03)
nRow += nLinSize
oReport:Say(nRow, MARGEM_ESQUERDA_BOX_GERAL + 200, "CP: " + AllTrim((cAliasQry)->A1_CEP), oFontSt03)
oReport:Say(nRow, nHalfPage + 300, "CP: " + cCEPEnt, oFontSt03)
Return

/*/{Protheus.doc} RectInfo1
Crea el box de datos de info 1
@author Rodrigo Godinho
@since 24/07/2018
@version 1.0
@param oReport, object, descripción
@type function
/*/
Static Function RectInfo1(oReport, cAliasQry)
Local oFontSt01	:= TFont():New('Calibri',,-10,,.T.)
Local oFontSt02	:= TFont():New('Courier New',,-9,,.T.)

oReport:IncRow(2)
oReport:FillRect({oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL, oReport:Row() + 40, MARGEM_DIREITA_BOX_GERAL})
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 500,  oReport:Row() + 80, MARGEM_ESQUERDA_BOX_GERAL + 500 )
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 900,  oReport:Row() + 80, MARGEM_ESQUERDA_BOX_GERAL + 900 )
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 1450,  oReport:Row() + 80, MARGEM_ESQUERDA_BOX_GERAL + 1450 )

oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 220, "DATE"			, oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 656, "SHIP VIA"		, oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 1100, "SALES TERMS"	, oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 1820, "TERMS"		, oFontSt01, ,Rgb(255,255,255))
oReport:IncRow(40)

oReport:Say(oReport:Row() + 4, MARGEM_ESQUERDA_BOX_GERAL + 190, DToC((cAliasQry)->F2_EMISSAO)				, oFontSt02)
oReport:Say(oReport:Row() + 4, MARGEM_ESQUERDA_BOX_GERAL + 520, PadC(AllTrim((cAliasQry)->X5DESCENG),23)	, oFontSt02)
oReport:Say(oReport:Row() + 4, MARGEM_ESQUERDA_BOX_GERAL + 910, PadC(AllTrim((cAliasQry)->E4_DESCRI),33)	, oFontSt02)
oReport:Say(oReport:Row() + 4, MARGEM_ESQUERDA_BOX_GERAL + 1480, PadC(AllTrim((cAliasQry)->C5_XINCO),50)							, oFontSt02)
oReport:IncRow(40)
Return

/*/{Protheus.doc} RectInfo2
Crea el box de info 2
@author Rodrigo Godinho
@since 24/07/2018
@type function
/*/
Static Function RectInfo2(oReport, cAliasQry)
Local oFontSt01	:= TFont():New('Calibri',,-10,,.T.)
Local oFontSt02	:= TFont():New('Courier New',,-9,,.T.)

oReport:FillRect({oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL, oReport:Row() + 40, MARGEM_DIREITA_BOX_GERAL})
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 500,  oReport:Row() + 80, MARGEM_ESQUERDA_BOX_GERAL + 500 )
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 1450,  oReport:Row() + 80, MARGEM_ESQUERDA_BOX_GERAL + 1450 )

oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 180, "ORDER DATE", oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 800, "SALES PERSON", oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 1740, "OUR ORDER NUMBER", oFontSt01, ,Rgb(255,255,255))
oReport:IncRow(40)

oReport:Say(oReport:Row() + 4, MARGEM_ESQUERDA_BOX_GERAL + 190, DToC((cAliasQry)->C5_EMISSAO)				, oFontSt02)
oReport:Say(oReport:Row() + 4, MARGEM_ESQUERDA_BOX_GERAL + 700, PadC(AllTrim((cAliasQry)->A3_NOME),33,"")	, oFontSt02)
oReport:Say(oReport:Row() + 4, MARGEM_ESQUERDA_BOX_GERAL + 1480, PadC(AllTrim((cAliasQry)->F2_DOC),50,"")	, oFontSt02)
oReport:IncRow(40)
Return

/*/{Protheus.doc} RectItems
Box de itemes
@author Rodrigo Godinho
@since 24/07/2018
@type function
/*/
Static Function RectItems(oReport, nMoeda)
Local oFontSt01	:= TFont():New('Calibri',,-10,,.T.)

//Box dos titulos
oReport:FillRect({oReport:Row(), MARGEM_ESQUERDA_BOX_GERAL, oReport:Row() + 40, MARGEM_DIREITA_BOX_GERAL})

//Títulos
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 10, "ITEM", oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 90, "QTY SHIPPED", oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 280, "UNIT", oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 550, "DESCRIPTION", oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 980, "IMCD CODE", oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 1320, "NCM", oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 1540, "ORIGIN", oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 1740, "UNIT PRICE", oFontSt01, ,Rgb(255,255,255))
oReport:Say(oReport:Row() + 2, MARGEM_ESQUERDA_BOX_GERAL + 1980, "EXTENDED PRICE", oFontSt01, ,Rgb(255,255,255))

//Linhas
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 80,  MARGEM_INFERIOR_BOX_ITEMS, MARGEM_ESQUERDA_BOX_GERAL + 80 )
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 275,  MARGEM_INFERIOR_BOX_ITEMS, MARGEM_ESQUERDA_BOX_GERAL + 275 )
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 360,  MARGEM_INFERIOR_BOX_ITEMS, MARGEM_ESQUERDA_BOX_GERAL + 360 )
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 900,  MARGEM_INFERIOR_BOX_ITEMS, MARGEM_ESQUERDA_BOX_GERAL + 900 )
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 1250,  MARGEM_INFERIOR_BOX_ITEMS, MARGEM_ESQUERDA_BOX_GERAL + 1250 )
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 1450,  MARGEM_INFERIOR_BOX_ITEMS, MARGEM_ESQUERDA_BOX_GERAL + 1450 )
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 1722,  MARGEM_INFERIOR_BOX_ITEMS, MARGEM_ESQUERDA_BOX_GERAL + 1722 )
oReport:Line(oReport:Row() + 40, MARGEM_ESQUERDA_BOX_GERAL + 1920,  MARGEM_INFERIOR_BOX_ITEMS, MARGEM_ESQUERDA_BOX_GERAL + 1920 )

oReport:Say(oReport:Row() + 42, MARGEM_ESQUERDA_BOX_GERAL + 2015, GetSimbCur(nMoeda) + "/TOTAL", oFontSt01)

oReport:Line(MARGEM_INFERIOR_BOX_ITEMS, MARGEM_ESQUERDA_BOX_GERAL,  MARGEM_INFERIOR_BOX_ITEMS, MARGEM_DIREITA_BOX_GERAL )

oReport:IncRow(100)
Return


/*/{Protheus.doc} RectLotes
Caja de los lotes
@author Rodrigo Godinho
@since 27/07/2018
@param oReport, object, Objeto de la clase TReport
@param lPrintTotal, logic, Si imprime el total
@param nMoeda, numeric, Moeda de la factura
@param nTotal, numeric, Total de la factura
@type function
/*/
Static Function RectLotes(oReport, lPrintTotal, nMoeda, nTotal)
Local oFontSt01		:= TFont():New('Arial',,-10,,.T.)
Local oFontSt02		:= TFont():New('Arial',,-10,,.F.)
Local oFontSt03		:= TFont():New('Arial',,-12,,.T.,,,,,,.T.)
Local oFontSt04		:= TFont():New('Calibri',,-10,,.T.)
Local nRowFimBox	:= MARGEM_INFERIOR_BOX_GERAL - 120
Local nRowTopBox	:= MARGEM_INFERIOR_BOX_ITEMS
Local nColLin1		:= MARGEM_ESQUERDA_BOX_GERAL + 650
Local nColLin2		:= MARGEM_ESQUERDA_BOX_GERAL + 1900
Local nRowActual	:= nRowTopBox + 40

Default lPrintTotal	:= .F.
Default nMoeda		:= 0
Default nTotal		:= 0

//Linhas verticais
oReport:Line(MARGEM_INFERIOR_BOX_ITEMS, nColLin1,  MARGEM_INFERIOR_BOX_GERAL, nColLin1 )
//oReport:Line(MARGEM_INFERIOR_BOX_ITEMS, nColLin1,  nRowFimBox, nColLin1 )
oReport:Line(nRowFimBox, nColLin2-100,  MARGEM_INFERIOR_BOX_GERAL, nColLin2-100 )
//Linhas horizontais
//oReport:Line(nRowFimBox - 45, MARGEM_ESQUERDA_BOX_GERAL,  nRowFimBox - 45, nColLin1)
oReport:Line(nRowFimBox, MARGEM_ESQUERDA_BOX_GERAL,  nRowFimBox, MARGEM_DIREITA_BOX_GERAL)
If lPrintTotal
	oReport:Say(nRowFimBox + 10, nColLin2 , "TOTAL INVOICE DUE", oFontSt04)
	oReport:Say(nRowFimBox + 45, nColLin2 , GetSimbCur(nMoeda), oFontSt04)
	oReport:Say(nRowFimBox + 45, nColLin2 + 30, Transform(nTotal, PesqPict("SF2", "F2_VALBRUT")), oFontSt02)
EndIf

oReport:Say(nRowActual, MARGEM_ESQUERDA_BOX_GERAL + 12,  "ITEM", oFontSt01)
oReport:Say(nRowActual, MARGEM_ESQUERDA_BOX_GERAL + 105, "BATCH", oFontSt01)
oReport:Say(nRowActual, MARGEM_ESQUERDA_BOX_GERAL + 295, "MANUFACTURER", oFontSt01)
nRowActual += 50

//Mensagem do fim do box
oReport:Say(nRowFimBox + 40, MARGEM_ESQUERDA_BOX_GERAL + 890, '"Thank You For Your Order!"', oFontSt03)

Return

/*/{Protheus.doc} MakeFooter
Crea el footer
@author Rodrigo Godinho
@since 27/07/2018
@type function
/*/
Static Function MakeFooter(oReport)
Local cFileLogo := GetSrvProfString('Startpath','') + GetMV("UY_IMGFINV",,"imagem_footer_layout_invoice_imcd.png")
oReport:SayBitmap(MARGEM_INFERIOR_BOX_GERAL + 44, MARGEM_ESQUERDA_BOX_GERAL + 1560, cFileLogo,  560, 80)
Return

/*/{Protheus.doc} SayCenter
Imprime una linea centralizada
@author Rodrigo Godinho
@since 26/07/2018
@type function
/*/
Static Function SayCenter(oReport, cText, oFont, nRow)
Local nTextSize	:= 0
Local nColIni	:= 0

Default cText	:= ""

If !Empty(cText) .And. ValType(oReport) == "O" .And. ValType(oFont) == "O"
	Default nRow := oReport:Row()
	nTextSize := oReport:Char2Pix(cText, oFont:Name, oFont:nHeight, oFont:Bold)
	nColIni := ((MARGEM_DIREITA_BOX_GERAL - MARGEM_ESQUERDA_BOX_GERAL) /2) - (nTextSize/2)
	oReport:Say(nRow, nColIni, cText, oFont)
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
			U_UYFatL01(cAlias, (cAlias)->(Recno()))
		Else
			U_UYFatL01()
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
Local oFontSt01	:= TFont():New('Arial',,-8,,.T.)
Local oFontSt02	:= TFont():New('Courier New',,-9,,.T.)
Local nColLin1	:= MARGEM_ESQUERDA_BOX_GERAL + 650
Local nRowInfo	:= MARGEM_INFERIOR_BOX_ITEMS + 40
Local cMsgFact	:= ""
Local aStrPO	:= {}
Local aMsgLines	:= {}
Local cLinePO	:= ""
Local nI		:= 0
Local cUsrPV	:= ""

Default nNFPage	:= 1

If ValType(oReport) == "O"
	If ValType(nNFPage) == "N"
		oReport:Say(50, MARGEM_DIREITA_BOX_GERAL, AllTrim(Str(nNFPage)), oFontSt01)
	EndIf
	//Box principal
	MakeBox(oReport, MARGEM_SUPERIOR_BOX_GERAL, MARGEM_ESQUERDA_BOX_GERAL, MARGEM_INFERIOR_BOX_GERAL, MARGEM_DIREITA_BOX_GERAL, 6)
	//Parte de cima
	MakeHeader(oReport, cAliasQry)
	oReport:SetRow(MARGEM_SUPERIOR_BOX_GERAL + 740)
	oReport:SkipLine()
	RectInfo1(oReport, cAliasQry)
	RectInfo2(oReport, cAliasQry)
	RectItems(oReport, nMoeda)
	If ValType(aInfoPeso) == "A" .And. Len(aInfoPeso) > 1
		oReport:Say(nRowInfo, nColLin1 + 50, "Net weight KG:   " + Transform( aInfoPeso[1], "@E 999,999,999.999"), oFontSt02)
		nRowInfo += 36
		oReport:Say(nRowInfo, nColLin1 + 50, "Gross weight KG: " + Transform( aInfoPeso[2], "@E 999,999,999.999"), oFontSt02)
		nRowInfo += 60
	EndIf
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
		oReport:Say(nRowInfo, nColLin1 + 50, "Customer PO's:", oFontSt02)
		nRowInfo += 36
		For nI := 1 To Len(aStrPO)
			oReport:Say(nRowInfo, nColLin1 + 50, aStrPO[nI], oFontSt02)
			nRowInfo += 36
		Next
	EndIf
	
	If !Empty( (cAliasQry)->C5_BANCO )
		DbSelectArea("SA6")
		DbSetOrder(1)
		IF DbSeek(XFILIAL("SA6")+(cAliasQry)->C5_BANCO+(cAliasQry)->C5_XNUMAGE+(cAliasQry)->C5_XNUMCON,.F.)
			oReport:Say(nRowInfo, nColLin1 + 50, "Banking Account: " + SA6->A6_NOME , oFontSt02)
			nRowInfo += 36
			oReport:Say(nRowInfo, nColLin1 + 50, "Swift Number:: "+ Alltrim( SA6->A6_SWIFT) , oFontSt02)
			nRowInfo += 36
			oReport:Say(nRowInfo, nColLin1 + 50, "Agency: "+ SA6->A6_AGENCIA , oFontSt02)
			nRowInfo += 36
			oReport:Say(nRowInfo, nColLin1 + 50, "Account Number:" + SA6->A6_NUMCON + IIF( !EMPTY(SA6->A6_DVCTA), +'-'+SA6->A6_DVCTA, '') , oFontSt02)
			nRowInfo += 36
		Endif
	Endif
	
	nRowInfo := MARGEM_INFERIOR_BOX_ITEMS + 360
	cMsgFact := AllTrim(GetAdvFVal("SC5", "C5_XMENNOT", xFilial("SC5") + (cAliasQry)->C5_NUM, 1, ""))
	If Len(cMsgFact) > 0
		aMsgLines := FWTxt2Array(cMsgFact,100)
		If ValType(aMsgLines) == "A"
			For nI := 1 To Len(aMsgLines)
				oReport:Say(nRowInfo, nColLin1 + 50, aMsgLines[nI], oFontSt02)
				nRowInfo += 36
				If nI == 12
					Exit
				EndIf
			Next
		EndIf
	EndIf
	If !Empty((cAliasQry)->C5_USERLGI)
		cUsrPV := UsrFullName(SubStr( Embaralha( (cAliasQry)->C5_USERLGI, 1), 3, 6))
		If !Empty(cUsrPV)
			oReport:Say(MARGEM_INFERIOR_BOX_GERAL - 100, MARGEM_ESQUERDA_BOX_GERAL + 100, PadC(AllTrim(cUsrPV),30), oFontSt02)
			oReport:Say(MARGEM_INFERIOR_BOX_GERAL - 060, MARGEM_ESQUERDA_BOX_GERAL + 100, PadC("FOREING TRADE",30), oFontSt02)
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
Local cNomeFab	:= Space(20)
Local cPaisFab	:= Space(20)

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
		IF !EMPTY(AllTrim((cAliasQry)->NOME_FABR))
			cNomeFab := AllTrim((cAliasQry)->NOME_FABR)
			cPaisFab := AllTrim((cAliasQry)->PAIS_FABR)
		ELSE
			FABRIC((cAliasQry)->D1_COD, @cNomeFab, @cPaisFab)
		ENDIF
		
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
	SELECT F2_PLIQUI PESO_LIQ, F2_PBRUTO PESO_BRUTO
	FROM %Table:SF2% SF2
	WHERE F2_FILIAL = %xFilial:SF2%
	AND F2_DOC = %Exp:cDoc%
	AND F2_SERIE = %Exp:cSerie%
	AND F2_CLIENTE = %Exp:cCliente%
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



Static Function FABRIC(cPrd, cNomeFab, cPaisFab)		
 
Local oDlg,oGrp1,oSay2,oGet3,oSay4,oGet5,oSBtn22,oSBtn23

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := " "
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 465
oDlg:nHeight := 250
oDlg:lShowHint := .F.
oDlg:lCentered := .F.

oGrp1 := TGROUP():Create(oDlg)
oGrp1:cName := "oGrp1"
oGrp1:cCaption := "Informe o fabricante e Origem do Produto " + cPrd
oGrp1:nLeft := 12
oGrp1:nTop := 6
oGrp1:nWidth := 435
oGrp1:nHeight := 180
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSay2 := TSAY():Create(oDlg)
oSay2:cName := "oSay2"
oSay2:cCaption := "Fabricante "
oSay2:nLeft := 20
oSay2:nTop := 34
oSay2:nWidth := 65
oSay2:nHeight := 17
oSay2:lShowHint := .F.
oSay2:lReadOnly := .F.
oSay2:Align := 0
oSay2:lVisibleControl := .T.
oSay2:lWordWrap := .F.
oSay2:lTransparent := .F.

oGet3 := TGET():Create(oDlg)
oGet3:cName := "oGet3"
oGet3:nLeft := 86
oGet3:nTop := 33
oGet3:nWidth := 150
oGet3:nHeight := 21
oGet3:lShowHint := .F.
oGet3:lReadOnly := .F.
oGet3:Align := 0
oGet3:cVariable := "cNomeFab"
oGet3:bSetGet := {|u| If(PCount()>0,cNomeFab:=u,cNomeFab) }
oGet3:lVisibleControl := .T.
oGet3:lPassword := .F.
oGet3:lHasButton := .F.
oGet3:Picture := "@!"
//oGet3:bValid := { || VldVol( "1" ) }

oSay4 := TSAY():Create(oDlg)
oSay4:cName := "oSay4"
oSay4:cCaption := "Origem"
oSay4:nLeft := 20
oSay4:nTop := 82
oSay4:nWidth := 65
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oGet5 := TGET():Create(oDlg)
oGet5:cName := "oGet5"
oGet5:nLeft := 85
oGet5:nTop := 82
oGet5:nWidth := 150
oGet5:nHeight := 21
oGet5:lShowHint := .F.
oGet5:lReadOnly := .F.
oGet5:Align := 0
oGet5:cVariable := "cPaisFab"
oGet5:bSetGet := {|u| If(PCount()>0,cPaisFab:=u,cPaisFab) }
oGet5:lVisibleControl := .T.
oGet5:lPassword := .F.
oGet5:lHasButton := .F.
oGet5:Picture := "@!"


oSBtn22 := SBUTTON():Create(oDlg)
oSBtn22:cName := "oSBtn22"
oSBtn22:cCaption := "OK"
oSBtn22:nLeft := 316
oSBtn22:nTop := 192
oSBtn22:nWidth := 52
oSBtn22:nHeight := 22
oSBtn22:lShowHint := .F.
oSBtn22:lReadOnly := .F.
oSBtn22:Align := 0
oSBtn22:lVisibleControl := .T.
oSBtn22:nType := 1
oSBtn22:bAction := {|| oDlg:End() }

oSBtn23 := SBUTTON():Create(oDlg)
oSBtn23:cName := "oSBtn23"
oSBtn23:cCaption := "Cancel"
oSBtn23:nLeft := 378
oSBtn23:nTop := 192
oSBtn23:nWidth := 52
oSBtn23:nHeight := 22
oSBtn23:lShowHint := .F.
oSBtn23:lReadOnly := .F.
oSBtn23:Align := 0
oSBtn23:lVisibleControl := .T.
oSBtn23:nType := 2
oSBtn23:bAction := {|| oDlg:End() }

oDlg:Activate()

Return()