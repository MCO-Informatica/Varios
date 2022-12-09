#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat004()
	Local oReport := nil
	Local cPerg:= Padr("RELAT004",10)

	//Incluo/Altero as perguntas na tabela SX1
	//AjustaSX1(cPerg)
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
	Pergunte(cPerg,.T.)

	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Relatório Pedidos de Compra - Contrato x Fornecedor / Item",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=6
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.


	//Monstando a primeira seção
	//Neste exemplo, a primeira seção será composta por duas colunas, código da NCM e sua descrição
	//Iremos disponibilizar para esta seção apenas a tabela SYD, pois quando você for em personalizar
	//e entrar na primeira seção, você terá todos os outros campos disponíveis, com isso, será
	//permitido a inserção dos outros campos
	//Neste exemplo, também, já deixarei definido o nome dos campos, mascara e tamanho, mas você
	//terá toda a liberdade de modificá-los via relatorio.
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SC7"}, 	, .F.	,.T.)
	TRCell():New(oSection1,"TMP_CONTRATO",	"TRBOC",	"CONTRATO"  ,"@!"	,13)
	TRCell():New(oSection1,"TMP_FORNECE","TRBOC","Cod.Fornec."		,"@!"	,10)
	TRCell():New(oSection1,"TMP_NOME"  	,"TRBOC","Fornecedor"		,"@!"	,20)
	TRCell():New(oSection1,"TMP_OC"   	,"TRBOC","OC"				,"@!"	,06)
	TRCell():New(oSection1,"TMP_EMISSAO","TRBOC","Emissão"			,""		,12)

	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Pedidos de Compra", {"SC7"}, NIL, .F., .T.)


	TRCell():New(oSection2,"TMP_ENTREGA","TRBOC","Entrega"			,""					,12)
	TRCell():New(oSection2,"TMP_PRODUTO","TRBOC","Código"			,"@!"				,30)
	TRCell():New(oSection2,"TMP_DESCRI"	,"TRBOC","Produto"			,"@!"				,80)
	TRCell():New(oSection2,"TMP_QTD"	,"TRBOC","Quant."			,"@E 99,999,999.9999",15,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_UM"		,"TRBOC","Unid."			,"@!"				,02)
	TRCell():New(oSection2,"TMP_UNITARIO","TRBOC","Unitário"		,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_TOTAL"  ,"TRBOC","Total"			,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_XTOTSI"  ,"TRBOC","Tot.s/Tributos"	,"@E 999,999,999.99",14,,,,,"RIGHT")


	TRCell():New(oSection2,"TMP_OP" 	,"TRBOC","Ordem Prod."		,"@!"				,13)
	TRCell():New(oSection2,"TMP_STATUS" ,"TRBOC","Status"			,"@!"				,14)

	oBreak1 := TRBreak():New(oSection2,{|| (TRBOC->TMP_OC) },"Subtotal:",.F.)
	//TRFunction():New(oSection2:Cell("TMP_OC")	,NIL,"COUNT",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_TOTAL")	,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_XTOTSI")	,NIL,"SUM",oBreak1,,,,.F.,.T.)


	oReport:SetTotalInLine(.F.)

        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.
	oSection2:SetHeaderSection(.T.)


	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO

	cQuery := "	SELECT C7_ITEMCTA AS 'TMP_CONTRATO', C7_NUM as 'TMP_OC', "
	cQuery += "	CAST(C7_EMISSAO as Date) AS 'TMP_EMISSAO', CAST(C7_DATPRF AS DATE) AS 'TMP_ENTREGA', C7_FORNECE AS 'TMP_FORNECE', SA2010.A2_NREDUZ AS 'TMP_NOME', "
	cQuery += "	C7_PRODUTO AS 'TMP_PRODUTO', C7_DESCRI AS 'TMP_DESCRI',C7_QUANT AS 'TMP_QTD', C7_UM AS 'TMP_UM', C7_PRECO AS 'TMP_UNITARIO', C7_OP AS 'TMP_OP',  C7_XTOTSI AS 'TMP_XTOTSI', "
	cQuery += "	CASE "
	cQuery += "	WHEN C7_MOEDA = '1' "
	cQuery += "		THEN  "
	cQuery += "		(C7_TOTAL) "
	cQuery += "	WHEN C7_MOEDA = '2' "
	cQuery += "		THEN (C7_TOTAL)*M2_MOEDA2 "
	cQuery += "		END AS 'TMP_TOTAL',
	cQuery += "	CASE "
	cQuery += "	WHEN C7_MOEDA = '1' "
	cQuery += "		THEN "
	cQuery += "		(((C7_TOTAL)-(C7_VALIPI))-(C7_VALICM)-((C7_VALISS))-(((C7_TOTAL)-(C7_VALIPI))*0.0760)-(((C7_TOTAL)-(C7_VALIPI))*0.0165)) "
	cQuery += "	WHEN C7_MOEDA = '2' "
	cQuery += "		THEN  "
	cQuery += "		(((C7_TOTAL)-(C7_VALIPI))-(C7_VALICM)-((C7_VALISS))-(((C7_TOTAL)-(C7_VALIPI))*0.0760)-(((C7_TOTAL)-(C7_VALIPI))*0.0165))*M2_MOEDA2 "
	cQuery += "		END AS 'TMP_TOTALSI', "
	cQuery += "	IIF(C7_ENCER = 'E', 'Fechado', IIF((C7_QUANT) <> (C7_QUJE) AND (C7_QUJE) > 0, 'Parcial', 'Aberto')) AS 'TMP_STATUS' "
	cQuery += "	FROM SC7010 "
	cQuery += "	INNER JOIN SA2010 ON C7_FORNECE=SA2010.A2_COD "
	cQuery += "	LEFT JOIN SM2010 ON C7_EMISSAO=SM2010.M2_DATA "
	cQuery += "	INNER JOIN SB1010 ON C7_PRODUTO=SB1010.B1_COD "
	cQuery += "	where SC7010.D_E_L_E_T_ <> '*' AND SM2010.D_E_L_E_T_ <> '*' AND SB1010.D_E_L_E_T_ <> '*' AND SA2010.D_E_L_E_T_ <> '*' AND "
	cQuery += " C7_ITEMCTA     >= '" + MV_PAR01 + "' AND  "
	cQuery += " C7_ITEMCTA     <= '" + MV_PAR02 + "' AND  "
	cQuery += " C7_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " C7_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " C7_FORNECE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " C7_FORNECE    <= '" + MV_PAR06 + "' AND "
	cQuery += " C7_NUM    	  >= '" + MV_PAR07 + "' AND  "
	cQuery += " C7_NUM    	  <= '" + MV_PAR08 + "' "
	cQuery += "	ORDER BY C7_ITEMCTA, A2_NREDUZ, C7_NUM "



	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBOC") <> 0
		DbSelectArea("TRBOC")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBOC"

	dbSelectArea("TRBOC")
	TRBOC->(dbGoTop())

	oReport:SetMeter(TRBOC->(LastRec()))

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBOC->TMP_OC
		IncProc("Imprimindo OC "+alltrim(TRBOC->TMP_CONTRATO))

		//imprimo a primeira seção
		oSection1:Cell("TMP_CONTRATO"):SetValue(TRBOC->TMP_CONTRATO)
		oSection1:Cell("TMP_FORNECE"):SetValue(TRBOC->TMP_FORNECE)
		oSection1:Cell("TMP_NOME"):SetValue(TRBOC->TMP_NOME)
		oSection1:Cell("TMP_OC"):SetValue(TRBOC->TMP_OC)
		oSection1:Cell("TMP_EMISSAO"):SetValue(TRBOC->TMP_EMISSAO)
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBOC->TMP_OC == cNcm
			oReport:IncMeter()

			IncProc("Imprimindo OC "+alltrim(TRBOC->TMP_OC))

			oSection2:Cell("TMP_ENTREGA"):SetValue(TRBOC->TMP_ENTREGA)
			oSection2:Cell("TMP_PRODUTO"):SetValue(TRBOC->TMP_PRODUTO)
			oSection2:Cell("TMP_DESCRI"):SetValue(TRBOC->TMP_DESCRI)

			oSection2:Cell("TMP_QTD"):SetValue(TRBOC->TMP_QTD)
			oSection2:Cell("TMP_QTD"):SetAlign("RIGHT")

			oSection2:Cell("TMP_UM"):SetValue(TRBOC->TMP_UM)

			oSection2:Cell("TMP_UNITARIO"):SetValue(TRBOC->TMP_UNITARIO)
			oSection2:Cell("TMP_UNITARIO"):SetAlign("RIGHT")

			oSection2:Cell("TMP_TOTAL"):SetValue(TRBOC->TMP_TOTAL)
			oSection2:Cell("TMP_TOTAL"):SetAlign("RIGHT")

			oSection2:Cell("TMP_XTOTSI"):SetValue(TRBOC->TMP_XTOTSI)
			oSection2:Cell("TMP_XTOTSI"):SetAlign("RIGHT")

			oSection2:Cell("TMP_OP"):SetValue(TRBOC->TMP_OP)
			oSection2:Cell("TMP_STATUS"):SetValue(TRBOC->TMP_STATUS)


			oSection2:Printline()


 			TRBOC->(dbSkip())
 		EndDo
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSection1:Finish()
	Enddo
Return

/*
static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Item Conta de ?"	  , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par01")
	putSx1(cPerg, "02", "Item Conta até?"	  , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par02")
	putSx1(cPerg, "03", "Emissão de?"	  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Emissão até?"	  	  , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")
	putSx1(cPerg, "05", "Fornecedor de ?"	  , "", "", "mv_ch5", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par05")
	putSx1(cPerg, "06", "Fornecedor até?"	  , "", "", "mv_ch6", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par06")
	putSx1(cPerg, "07", "Orderm de compra de ?", "", "", "mv_ch7", "C", 06, 0, 0, "G", "", "SC7", "", "", "mv_par07")
	putSx1(cPerg, "08", "Orderm de compra até?", "", "", "mv_ch8", "C", 06, 0, 0, "G", "", "SC7", "", "", "mv_par08")
return

*/
