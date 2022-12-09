#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relcom01()
	Local oReport := nil
	Local cPerg:= Padr("relcom01",10)

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
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
	oReport := TReport():New(cNome,"Relatório de Custo de Materiais" ,cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.T.)
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SC7"}, 	, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_CODPROD"	,"TRBCOM"	,"Cod.Produto"		,"@!"	,	30)
	TRCell():New(oSection1,"TMP_DESCRICAO"	,"TRBCOM"	,"Produto"			,"@!"	,	72)

	TRCell():New(oSection1,"TMP_VUNITCI"	,"TRBCOM"	,"Prc.c/Trib."		,"@E 999,999,999.99",17,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VUNITSI"	,"TRBCOM"	,"s/ Tributos"		,"@E 999,999,999.99",17,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_CUME"		,"TRBCOM"	,"Custo Medio"		,"@E 999,999,999.99",17,,,,,"RIGHT")

	TRCell():New(oSection1,"TMP_SLDATU"		,"TRBCOM"	,"Sld.Atual"		,"@E 999,999.99"	,14,,,,,"RIGHT")


	TRCell():New(oSection1,"TMP_UNIDADE"	,"TRBCOM"	,"Unid."			,"@!"				,4,,,,,"CENTER")
	TRCell():New(oSection1,"TMP_UCOM"		,"TRBCOM"	,"Ult. Compra"		,"@!"				,	17)
	TRCell():New(oSection1,"TMP_OC"			,"TRBCOM"	,"OC"				,"@!"				,	7)

	TRCell():New(oSection1,"TMP_CODFOR"		,"TRBCOM"	,"Cod.Forn."		,"@!"	,	7)
	TRCell():New(oSection1,"TMP_FORNECE"	,"TRBCOM"	,"Fornecedor"		,"@!"	,	40)
	TRCell():New(oSection1,"TMP_CONTRATO"	,"TRBCOM"	,"Contrato"		,"@!"	,	20)

	TRFunction():New(oSection1:Cell("TMP_CODPROD")	,NIL,"COUNT",,,,,.F.,.T.)

	oReport:SetTotalInLine(.F.)

        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.


	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO


	cQuery := " SELECT DISTINCT C7_PRODUTO AS 'TMP_CODPROD', C7_DESCRI AS 'TMP_DESCRICAO', C7_DATPRF AS 'TMP_UCOM', "
	cQuery += "	IIF(C7_MOEDA = '1', C7_PRECO, C7_PRECO*C7_TXMOEDA) AS 'TMP_VUNITCI', "
	cQuery += "	B2_CM1 AS 'TMP_CUME', B2_QATU AS 'TMP_SLDATU', "
	cQuery += "	IIF(C7_MOEDA = '1', C7_XTOTSI/C7_QUANT, (C7_XTOTSI/C7_QUANT)*C7_TXMOEDA) AS 'TMP_VUNITSI', C7_UM AS 'TMP_UNIDADE', "
	cQuery += "	C7_NUM AS 'TMP_OC', C7_FORNECE AS 'TMP_CODFOR', A2_NREDUZ AS 'TMP_FORNECE', C7_ITEMCTA AS 'TMP_CONTRATO' "
	cQuery += " FROM SC7010 AS SC7V1 "
	cQuery += "	JOIN SA2010 ON SC7V1.C7_FORNECE = SA2010.A2_COD AND SC7V1.C7_LOJA = SA2010.A2_LOJA "
	cQuery += "	LEFT JOIN SB2010 ON SC7V1.C7_PRODUTO = B2_COD "
	cQuery += "	wHERE SC7V1.C7_PRODUTO IN (SELECT TOP 3 SC7V2.C7_PRODUTO FROM SC7010 AS SC7V2 WHERE SC7V1.C7_PRODUTO = SC7V2.C7_PRODUTO ORDER BY C7_DATPRF DESC) AND "
	cQuery += "	SC7V1.D_E_L_E_T_ <> '*' AND C7_ENCER = 'E'

	IF ! EMPTY(ALLTRIM(MV_PAR03))
		cQuery += "	  AND SC7V1.C7_DESCRI LIKE CHAR(37) + '" + ALLTRIM(MV_PAR03)  + "' + CHAR(37) "
	else
		cQuery += " AND SC7V1.C7_PRODUTO     >= '" + MV_PAR01 + "'   "
		cQuery += " AND SC7V1.C7_PRODUTO     <= '" + MV_PAR02 + "'   "
	endif


	cQuery += "	  ORDER BY 3 DESC, 2 , 1"


	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBCOM") <> 0
		DbSelectArea("TRBCOM")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBCOM"

	dbSelectArea("TRBCOM")
	TRBCOM->(dbGoTop())

	oReport:SetMeter(TRBCOM->(LastRec()))

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBCOM->TMP_CODPROD
		IncProc("Imprimindo Custo de Materiais ")

		//imprimo a primeira seção
		oSection1:Cell("TMP_CODPROD"):SetValue(TRBCOM->TMP_CODPROD)
		oSection1:Cell("TMP_DESCRICAO"):SetValue(TRBCOM->TMP_DESCRICAO)

		oSection1:Cell("TMP_VUNITCI"):SetValue(TRBCOM->TMP_VUNITCI)
		oSection1:Cell("TMP_VUNITSI"):SetValue(TRBCOM->TMP_VUNITSI)
		oSection1:Cell("TMP_CUME"):SetValue(TRBCOM->TMP_CUME)

		oSection1:Cell("TMP_SLDATU"):SetValue(TRBCOM->TMP_SLDATU)

		oSection1:Cell("TMP_UNIDADE"):SetValue(TRBCOM->TMP_UNIDADE)
		oSection1:Cell("TMP_OC"):SetValue(TRBCOM->TMP_OC)
		oSection1:Cell("TMP_UCOM"):SetValue(TRBCOM->TMP_UCOM)

		IF TMP_UCOM = ""
			oSection1:Cell("TMP_UCOM"):SetValue("")
		ELSE
			oSection1:Cell("TMP_UCOM"):SetValue(Substr(TRBCOM->TMP_UCOM,7,2) + "/" + Substr(TRBCOM->TMP_UCOM,5,2) + "/" + Substr(TRBCOM->TMP_UCOM,1,4))
		ENDIF

		oSection1:Cell("TMP_CODFOR"):SetValue(TRBCOM->TMP_CODFOR)
		oSection1:Cell("TMP_FORNECE"):SetValue(TRBCOM->TMP_FORNECE)
		oSection1:Cell("TMP_CONTRATO"):SetValue(TRBCOM->TMP_CONTRATO)

		oReport:ThinLine()
		oSection1:Printline()
		TRBCOM->(dbSkip())

	Enddo

	//imprimo uma linha para separar uma NCM de outra

 		//finalizo a primeira seção
		oSection1:Finish()
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Codigo Produto de "	  , "", "", "mv_ch1", "C", 30, 0, 0, "G", "", "XXSB1", "", "", "mv_par01")
	putSx1(cPerg, "02", "Codigo Produto até?"	  , "", "", "mv_ch2", "C", 30, 0, 0, "G", "", "XXSB1", "", "", "mv_par02")
	putSx1(cPerg, "03", "Descricao Produto?"	  , "", "", "mv_ch3", "C", 80, 0, 0, "G", "", "", "", "", "mv_par03")

return

