#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function zRelatHrs()
	Local oReport := nil
	Local cPerg:= Padr("zRelatHrs",10)


	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)
	//gero a pergunta de modo oculto, ficando dispon�vel no bot�o a��es relacionadas
	Pergunte(cPerg,.T.)


	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil

	Local oBreak
	Local oFunction

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Relatorio Apontamento Horas  - " + Substr(DTOS(MV_PAR01),7,2) + "/" + Substr(DTOS(MV_PAR01),5,2) + "/" + Substr(DTOS(MV_PAR01),1,4) + " at� " +  Substr(DTOS(MV_PAR02),7,2) + "/" + Substr(DTOS(MV_PAR02),5,2) + "/" + Substr(DTOS(MV_PAR02),1,4) ,cNome,{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=6
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.


	//Monstando a primeira se��o


	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SZ4"}, 	, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_COLAB"		,"TRBAPT"	,"Colaborador"		,"@!"				,30)
	TRCell():New(oSection1,"TMP_HRSVD"		,"TRBAPT"	,"Hrs.Vendas"		,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VLRVD"		,"TRBAPT"	,"Vlr.Vendas"		,"@E 999,999,999.99",14,,,,,"RIGHT")

	TRCell():New(oSection1,"TMP_HRSQUA"		,"TRBAPT"	,"Hrs.Qualid."	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VLRQUA"		,"TRBAPT"	,"Vlr.Qualid."	,"@E 999,999,999.99",14,,,,,"RIGHT")

	TRCell():New(oSection1,"TMP_HRSENG"		,"TRBAPT"	,"Hrs.Eng."	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VLRENG"		,"TRBAPT"	,"Vlr.Eng."	,"@E 999,999,999.99",14,,,,,"RIGHT")

	TRCell():New(oSection1,"TMP_HRSADM"		,"TRBAPT"	,"Hrs.Admin."		,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VLRADM"		,"TRBAPT"	,"Vlr.Admin."		,"@E 999,999,999.99",14,,,,,"RIGHT")
	
	TRCell():New(oSection1,"TMP_HRSOPE"		,"TRBAPT"	,"Hrs.Oper."	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VLROPE"		,"TRBAPT"	,"Vlr.Oper."	,"@E 999,999,999.99",14,,,,,"RIGHT")

	TRCell():New(oSection1,"TMP_HRSCTR"		,"TRBAPT"	,"Hrs.Contr."	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VLRCTR"		,"TRBAPT"	,"Vlr.Contr."	,"@E 999,999,999.99",14,,,,,"RIGHT")

	TRCell():New(oSection1,"TMP_TOTHRS"		,"TRBAPT"	,"Total Hrs"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_TOTVLR"		,"TRBAPT"	,"Total Valor"	,"@E 999,999,999.99",14,,,,,"RIGHT")

/*
	oBreak1 := TRBreak():New(oSection2,{|| (TRBAPT->TMP_COLAB) },"Subtotal",.F.)
	TRFunction():New(oSection2:Cell("TMP_DATA")		,NIL,"COUNT",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_QTDHRS")	,NIL,"SUM",oBreak1,,,,.F.,.T.)
	*/

	TRFunction():New(oSection1:Cell("TMP_HRSVD")	,NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("TMP_VLRVD")	,NIL,"SUM",,,,,.F.,.T.)

	TRFunction():New(oSection1:Cell("TMP_HRSQUA")	,NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("TMP_VLRQUA")	,NIL,"SUM",,,,,.F.,.T.)

	TRFunction():New(oSection1:Cell("TMP_HRSENG")	,NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("TMP_VLRENG")	,NIL,"SUM",,,,,.F.,.T.)

	TRFunction():New(oSection1:Cell("TMP_HRSADM")	,NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("TMP_VLRADM")	,NIL,"SUM",,,,,.F.,.T.)
	
	TRFunction():New(oSection1:Cell("TMP_HRSOPE")	,NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("TMP_VLROPE")	,NIL,"SUM",,,,,.F.,.T.)

	TRFunction():New(oSection1:Cell("TMP_HRSCTR")	,NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("TMP_VLRCTR")	,NIL,"SUM",,,,,.F.,.T.)

	TRFunction():New(oSection1:Cell("TMP_TOTHRS")	,NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("TMP_TOTVLR")	,NIL,"SUM",,,,,.F.,.T.)

	oReport:SetTotalInLine(.F.)

        //Aqui, farei uma quebra  por se��o
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText("Total Contrato ")


Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.

	Local cQuery2   := ""


	//Monto minha consulta conforme parametros passado

	cQuery := " SELECT DISTINCT Z4_COLAB AS 'TMP_COLAB', "
	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'PROPOSTA' GROUP BY Z4_COLAB),0) AS 'TMP_HRSVD', "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'PROPOSTA' GROUP BY Z4_COLAB),0) AS 'TMP_VLRVD', "
	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'QUALIDADE' GROUP BY Z4_COLAB),0) AS 'TMP_HRSQUA', "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'QUALIDADE' GROUP BY Z4_COLAB),0) AS 'TMP_VLRQUA', "
	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'ENGENHARIA' GROUP BY Z4_COLAB),0) AS 'TMP_HRSENG', "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'ENGENHARIA' GROUP BY Z4_COLAB),0) AS 'TMP_VLRENG', "


	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'ADMINISTRACAO' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0) AS 'TMP_HRSADM', "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'ADMINISTRACAO' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0) AS 'TMP_VLRADM', "
	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'OPERACOES' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0) AS 'TMP_HRSOPE', "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'OPERACOES'  AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0) AS 'TMP_VLROPE', "
	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA NOT IN ('PROPOSTA') AND SUBSTRING(Z4_ITEMCTA,1,2) IN ('AT','EQ','ST','GR','EN','PR','CM') AND SZ4010.D_E_L_E_T_ <> '*'   GROUP BY Z4_COLAB),0) AS 'TMP_HRSCTR', "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA NOT IN ('PROPOSTA') AND SUBSTRING(Z4_ITEMCTA,1,2) IN ('AT','EQ','ST','GR','EN','PR') AND SZ4010.D_E_L_E_T_ <> '*'   GROUP BY Z4_COLAB),0) AS 'TMP_VLRCTR', "


	cQuery += " (ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'PROPOSTA' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0)+ "
	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'QUALIDADE' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0)+ "
	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'ENGENHARIA' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0)+ "
	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'ADMINISTRACAO' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0)+ "
	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'OPERACOES' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0)+ "
	cQuery += " ISNULL((SELECT SUM(Z4_QTDHRS) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA NOT IN ('PROPOSTA') AND SUBSTRING(Z4_ITEMCTA,1,2) IN ('AT','EQ','ST','GR','EN','PR','CM') AND SZ4010.D_E_L_E_T_ <> '*'   GROUP BY Z4_COLAB),0)) AS 'TMP_TOTHRS', "


	cQuery += " (ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'PROPOSTA' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0)+ "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'QUALIDADE' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0)+ "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'ENGENHARIA' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0)+ "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'ADMINISTRACAO' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0)+ "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA = 'OPERACOES' AND SZ4010.D_E_L_E_T_ <> '*'  GROUP BY Z4_COLAB),0)+ "
	cQuery += " ISNULL((SELECT SUM(Z4_TOTVLR) FROM SZ4010 WHERE D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' AND Z4_COLAB = TB1.Z4_COLAB AND Z4_ITEMCTA NOT IN ('PROPOSTA') AND SUBSTRING(Z4_ITEMCTA,1,2) IN ('AT','EQ','ST','GR','EN','PR','CM') AND SZ4010.D_E_L_E_T_ <> '*'   GROUP BY Z4_COLAB),0)) AS 'TMP_TOTVLR' "

	cQuery += " FROM SZ4010 AS TB1 "
	cQuery += " WHERE TB1.D_E_L_E_T_ <> '*' AND Z4_DATA >= '" + DTOS(MV_PAR01) + "' AND Z4_DATA <= '" + DTOS(MV_PAR02) + "' "



	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBAPT") <> 0
		DbSelectArea("TRBAPT")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBAPT"

	dbSelectArea("TRBAPT")
	TRBAPT->(dbGoTop())

	oReport:SetMeter(TRBAPT->(LastRec()))

	oReport:SkipLine(3)
	oReport:FatLine()
	oReport:PrintText("RESUMO CONTRATOS")
	oReport:FatLine()

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira se��o
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBAPT->TMP_COLAB
		IncProc("Imprimindo Apontamento Horas "+alltrim(TRBAPT->TMP_COLAB))

		/*
		TMP_COLAB
	TMP_HRSVD
	TMP_VLRVD
	TMP_HRSQUA
	TMP_VLRQUA

	TMP_HRSADM
	TMP_VLRADM
	TMP_HRSCTR
	TMP_VLRCTR
	TMP_TOTALHRS
	TMP_TOTALVLR
	*/

		//imprimo a primeira se��o
		oSection1:Cell("TMP_COLAB"):SetValue(TRBAPT->TMP_COLAB)

		oSection1:Cell("TMP_HRSVD"):SetValue(TRBAPT->TMP_HRSVD)
		oSection1:Cell("TMP_HRSVD"):SetAlign("RIGHT")


		oSection1:Cell("TMP_VLRVD"):SetValue(TRBAPT->TMP_VLRVD)
		oSection1:Cell("TMP_VLRVD"):SetAlign("RIGHT")

		oSection1:Cell("TMP_HRSQUA"):SetValue(TRBAPT->TMP_HRSQUA)
		oSection1:Cell("TMP_HRSQUA"):SetAlign("RIGHT")

		oSection1:Cell("TMP_VLRQUA"):SetValue(TRBAPT->TMP_VLRQUA)
		oSection1:Cell("TMP_VLRQUA"):SetAlign("RIGHT")

		oSection1:Cell("TMP_HRSENG"):SetValue(TRBAPT->TMP_HRSENG)
		oSection1:Cell("TMP_HRSENG"):SetAlign("RIGHT")

		oSection1:Cell("TMP_VLRENG"):SetValue(TRBAPT->TMP_VLRENG)
		oSection1:Cell("TMP_VLRENG"):SetAlign("RIGHT")

		oSection1:Cell("TMP_HRSADM"):SetValue(TRBAPT->TMP_HRSADM)
		oSection1:Cell("TMP_HRSADM"):SetAlign("RIGHT")

		oSection1:Cell("TMP_VLRADM"):SetValue(TRBAPT->TMP_VLRADM)
		oSection1:Cell("TMP_VLRADM"):SetAlign("RIGHT")
		
		oSection1:Cell("TMP_HRSOPE"):SetValue(TRBAPT->TMP_HRSOPE)
		oSection1:Cell("TMP_HRSOPE"):SetAlign("RIGHT")

		oSection1:Cell("TMP_VLROPE"):SetValue(TRBAPT->TMP_VLROPE)
		oSection1:Cell("TMP_VLROPE"):SetAlign("RIGHT")

		oSection1:Cell("TMP_HRSCTR"):SetValue(TRBAPT->TMP_HRSCTR)
		oSection1:Cell("TMP_HRSCTR"):SetAlign("RIGHT")

		oSection1:Cell("TMP_VLRCTR"):SetValue(TRBAPT->TMP_VLRCTR)
		oSection1:Cell("TMP_VLRCTR"):SetAlign("RIGHT")

		oSection1:Cell("TMP_TOTHRS"):SetValue(TRBAPT->TMP_TOTHRS)
		oSection1:Cell("TMP_TOTHRS"):SetAlign("RIGHT")

		oSection1:Cell("TMP_TOTVLR"):SetValue(TRBAPT->TMP_TOTVLR)
		oSection1:Cell("TMP_TOTVLR"):SetAlign("RIGHT")


		oReport:ThinLine()
		oSection1:Printline()
		TRBAPT->(dbSkip())

	Enddo

	oSection1:Finish()



Return

static function ajustaSx1(cPerg)

	putSx1(cPerg, "01", "Data de?"	  	  , "", "", "mv_ch1", "D", 08, 0, 0, "G", "", "", "", "", "mv_par01")
	putSx1(cPerg, "02", "Data ate?"	  	  , "", "", "mv_ch2", "D", 08, 0, 0, "G", "", "", "", "", "mv_par02")

return












