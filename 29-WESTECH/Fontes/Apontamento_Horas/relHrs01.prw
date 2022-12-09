#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relHrs01()
	Local oReport := nil
	Local cPerg:= Padr("relHrs01",10)


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
	Local oSection2:= Nil
	Local oBreak
	Local oFunction

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Relatório Apontamento Horas  " ,cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=7
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.


	//Monstando a primeira seção

	oSection1:= TRSection():New(oReport, 	"NCM"		,{"SZ4"}, 	, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_CONTRATO"	,"TRBAPT"	,"Contrato"		,"@!"				,20)
	TRCell():New(oSection1,"TMP_COLAB"		,"TRBAPT"	,"Colaborador"		,"@!"				,50)
	TRCell():New(oSection1,"TMP_TAREFA"		,"TRBAPT"	,"Tarefa"		,"@!"				,30)

	TRCell():New(oSection1,"TMP_HRSCONT"	,"TRBAPT"	,"Horas"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VLRCONT"	,"TRBAPT"	,"Valor"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_DESCR"		,"TRBAPT"	,"Descricao"	,"@!",40)


	TRFunction():New(oSection1:Cell("TMP_HRSCONT")	,NIL,"SUM",,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("TMP_VLRCONT")	,NIL,"SUM",,,,,.T.,.F.)



	oReport:SetTotalInLine(.F.)

        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText("Subtotal Contrato ")



Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.

	Local cQuery2   := ""



	//Monto minha consulta conforme parametros passado

	cQuery := " SELECT Z4_COLAB AS 'TMP_COLAB', Z4_DESCR AS 'TMP_DESCR', SUM(Z4_QTDHRS) AS 'TMP_HRSCONT', SUM(Z4_TOTVLR) AS 'TMP_VLRCONT' , Z4_ITEMCTA AS 'TMP_CONTRATO', "
	cQuery += "	CASE "
	cQuery += "		WHEN Z4_TAREFA = 'AD' THEN 'ADMINISTRACAO' WHEN Z4_TAREFA = 'CE' THEN 'COORDENACAO DE ENGENHARIA' "
	cQuery += "		WHEN Z4_TAREFA = 'CP' THEN 'COORDENACAO DE CONTRATO' WHEN Z4_TAREFA = 'CR' THEN 'COMPRAS' "
	cQuery += "		WHEN Z4_TAREFA = 'DC' THEN 'OUTROS DOCUMENTOS' WHEN Z4_TAREFA = 'DI' THEN 'DILIGENCIAMENTO / INSPECAO' "
	cQuery += "		WHEN Z4_TAREFA = 'DT' THEN 'DETALHAMENTO' WHEN Z4_TAREFA = 'EE' THEN 'ESTUDO DE ENGENHARIA' "
	cQuery += "		WHEN Z4_TAREFA = 'EX' THEN 'EXPEDICAO' WHEN Z4_TAREFA = 'LB' THEN 'TESTE DE LABORATORIO / PILOTO' "
	cQuery += "		WHEN Z4_TAREFA = 'MDB' THEN 'MANUAL / DATABOOK' WHEN Z4_TAREFA = 'OP' THEN 'OPERACOES' "
	cQuery += "		WHEN Z4_TAREFA = 'PB' THEN 'PROJETO BASICO' WHEN Z4_TAREFA = 'SC' THEN 'SERVICO DE CAMPO' "
	cQuery += "		WHEN Z4_TAREFA = 'TR' THEN 'TESTE DE LABORATORIO / PILOTO' WHEN Z4_TAREFA = 'VA' THEN 'VERIFICACAO / APROVACAO' "
	cQuery += "		WHEN Z4_TAREFA = 'VD' THEN 'VENDAS' "  
	cQuery += " 	WHEN Z4_TAREFA = 'AP' THEN 'ASSUNTOS PARTICULARES'  "
	cQuery += " 	WHEN Z4_TAREFA = 'VD' THEN 'CONSULTA MEDICA/DOENCA'  "
	cQuery += " 	WHEN Z4_TAREFA = 'OU' THEN 'OUTROS'  "
	cQuery += "	END AS 'TMP_TAREFA' "
	cQuery += " 	FROM SZ4010 "
	cQuery += " 	WHERE D_E_L_E_T_ <> '*' AND  Z4_ITEMCTA NOT IN ('PROPOSTA','ADMINISTRACAO') AND "
	cQuery += " 	Z4_DATA		  >= '" + DTOS(MV_PAR01) + "' AND  "
	cQuery += " 	Z4_DATA    	  <= '" + DTOS(MV_PAR02) + "' AND "
	cQuery += " Z4_ITEMCTA    >= '" + MV_PAR03 + "' AND  "
	cQuery += " Z4_ITEMCTA    <= '" + MV_PAR04 + "'   "
	cQuery += " 	GROUP BY  Z4_ITEMCTA, Z4_COLAB, Z4_DESCR, Z4_TAREFA  ORDER BY Z4_ITEMCTA, Z4_COLAB "


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

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBAPT->TMP_COLAB
		IncProc("Imprimindo Apontamento Horas "+alltrim(TRBAPT->TMP_CONTRATO))

		//imprimo a primeira seção
		oSection1:Cell("TMP_CONTRATO"):SetValue(TRBAPT->TMP_CONTRATO)
		oSection1:Cell("TMP_COLAB"):SetValue(TRBAPT->TMP_COLAB)
		oSection1:Cell("TMP_TAREFA"):SetValue(TRBAPT->TMP_TAREFA)
		oSection1:Cell("TMP_HRSCONT"):SetValue(TRBAPT->TMP_HRSCONT)
		oSection1:Cell("TMP_VLRCONT"):SetValue(TRBAPT->TMP_VLRCONT)
		oSection1:Cell("TMP_DESCR"):SetValue(TRBAPT->TMP_DESCR)

		oReport:ThinLine()
		oSection1:Printline()
		TRBAPT->(dbSkip())

	Enddo

	oSection1:Finish()



Return

static function ajustaSx1(cPerg)

	putSx1(cPerg, "01", "Data de?"	  	  , "", "", "mv_ch1", "D", 08, 0, 0, "G", "", "", "", "", "mv_par01")
	putSx1(cPerg, "02", "Data até?"	  	  , "", "", "mv_ch2", "D", 08, 0, 0, "G", "", "", "", "", "mv_par02")
	putSx1(cPerg, "03", "Item Conta de ?" , "", "", "mv_ch3", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par03")
	putSx1(cPerg, "04", "Item Conta até?" , "", "", "mv_ch4", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par04")
return


                                                     













