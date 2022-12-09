#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relGC05()


	Local oReport := nil
	Local cPerg:= Padr("relGC05",10)

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
	oReport := TReport():New(cNome,"Relatório de Custos Empenhado / Contabilizado  " ,cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=6
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.


	//Monstando a primeira seção

	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"CTD"}, 	, .F.	, 	.T.)

	TRCell():New(oSection1,"TMP_CONTRATO",	"TRBSGC",	"Contrato"  		,"@!"				,25)
	TRCell():New(oSection1,"TMP_DTINI"		,"TRBSGC","Data Venda."			,""					,18,,,,,"CENTER")
	TRCell():New(oSection1,"TMP_CLIENTE"	,"TRBSGC","Cliente."  			,"@!"				,50)
	TRCell():New(oSection1,"TMP_PVCFRT"		,"TRBSGC","Vend.s/Frete"		,"@E 99,999,999",20,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_PVSFRT"		,"TRBSGC","Vend.c/Frete"		,"@E 99,999,999",20,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_DCUSTO"		,"TRBSGC","Custo Prod."			,"@E 99,999,999",20,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_CUPRD"		,"TRBSGC","Custo+Contig."		,"@E 99,999,999",20,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_COMISSAO"	,"TRBSGC","Comissao"			,"@E 99,999,999",18,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_OUOUT"		,"TRBSGC","Out.Custos"			,"@E 99,999,999",18,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_CUSTOTAL"	,"TRBSGC","Total"				,"@E 99,999,999",20,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_PERMB"		,"TRBSGC","% Mg.Bruta"			,"@E 99,999,999.99",18,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_PERCTB"		,"TRBSGC","% Mg.Contr."			,"@E 99,999,999.99",15,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_DESCRI"		,"TRBSGC","Descr."			,"@!"				,5)



	//TRFunction():New(oSection1:Cell("TMP_VUNITSI")	,NIL,"SUM",,,,,.F.,.T.)

	oReport:SetTotalInLine(.F.)

        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	//oSection1:SetTotalText("Subtotal Contrato ")



Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)

	Local cQuery    := ""
	Local cNcm      := ""
	Local cDesc     := ""
	Local lPrim 	:= .T.

	//Monto minha consulta conforme parametros passado
	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO

	cQuery := " SELECT CTD_ITEM AS 'TMP_CONTRATO', CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_CLIENTE', CTD_XCUSTO AS 'TMP_CUSTO', CTD_XCUTOT AS 'TMP_CUSTPRD',  "
	cQuery += "			CTD_XVDCI AS 'TMP_VDCI', CTD_XVDSI AS 'TMP_VDSI', convert(varchar(30),CTD_DTEXIS,102) AS 'TMP_DTINI', convert(varchar(30),CTD_DTEXSF,102) AS 'TMP_DTFIM', "
	cQuery += "			ZN_PVCFRT AS 'TMP_PVCFRT', ZN_PVSFRT AS 'TMP_PVSFRT', "
	cQuery += "			ZN_ITEM AS 'TMP_ITEM', LEFT(ZN_DESCRI,3) AS 'TMP_DESCRI', ZN_CUSTO AS 'TMP_DCUSTO', ZN_CONTIG AS 'TMP_CONTIG', ZN_CUPRD AS 'TMP_CUPRD', "
	cQuery += "			ZN_OCFIA AS 'TMP_FIANCAS', ZN_OCFIN AS 'TMP_CUSTFIN', ZN_OCGAR AS 'TMP_GARANTIA', ZN_OCPIP AS 'TMP_PERDIMP', ZN_OCCOM AS 'TMP_COMISSAO', ZN_OCROY AS 'TMP_ROYALTY', "
	cQuery += "			ZN_OUOUT  AS 'TMP_OUOUT' ,ZN_CUSTOT AS 'TMP_CUSTOTAL', "
	cQuery += "			ZN_VLRMB AS 'TMP_VLRMB', ZN_PERMB AS 'TMP_PERMB', ZN_VLRCTB AS 'TMP_VLRCTB', ZN_PERCTB AS 'TMP_PERCTB' "
	cQuery += "	FROM CTD010 "
	cQuery += "		LEFT JOIN SZN010 ON CTD_ITEM = ZN_ITEMIC "
	cQuery += "	WHERE  "
	cQuery += "		CTD_ITEM IN "
	cQuery += "		( "
	cQuery += "			SELECT CTD_ITEM "
	cQuery += "	FROM CTD010 "
	cQuery += "			WHERE CTD010.D_E_L_E_T_ <> '*' AND "
	cQuery += "				CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') AND "
	cQuery += "				CTD_ITEM >= '" + MV_PAR01 + "' AND CTD_ITEM <= '" + MV_PAR02 + "' AND "
	cQuery += " CTD_DTEXIS    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " CTD_DTEXIS    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " CTD_DTEXSF    >= '" + DTOS(MV_PAR05) + "' AND  "
	cQuery += " CTD_DTEXSF    <= '" + DTOS(MV_PAR06) + "' AND  "
	cQuery += "				SUBSTRING(CTD_ITEM,9,2) >= '15' "
	cQuery += "		) AND ZN_DESCRI = 'EMPENHADO' "
	cQuery += "		OR "
	cQuery += "		CTD_ITEM IN "
	cQuery += "		( "
	cQuery += "			SELECT CTD_ITEM "
	cQuery += "	FROM CTD010 "
	cQuery += "			WHERE CTD010.D_E_L_E_T_ <> '*' AND "
	cQuery += "				CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') AND "
	cQuery += "				CTD_ITEM >= '" + MV_PAR01 + "' AND CTD_ITEM <= '" + MV_PAR02 + "' AND "
	cQuery += " CTD_DTEXIS    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " CTD_DTEXIS    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " CTD_DTEXSF    >= '" + DTOS(MV_PAR05) + "' AND  "
	cQuery += " CTD_DTEXSF    <= '" + DTOS(MV_PAR06) + "' AND "
	cQuery += "	CTD_XIDPM >= '" + MV_PAR07 + "' AND CTD_XIDPM <= '" + MV_PAR08 + "' AND "
	cQuery += "				SUBSTRING(CTD_ITEM,9,2) >= '15' "
	cQuery += "		) AND ZN_DESCRI IS NULL "
	cQuery += "		OR "
	cQuery += "		CTD_ITEM IN "
	cQuery += "		( "
	cQuery += "			SELECT CTD_ITEM "
	cQuery += "	FROM CTD010 "
	cQuery += "			WHERE CTD010.D_E_L_E_T_ <> '*' AND "
	cQuery += "				CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') AND "
	cQuery += "				CTD_ITEM >= '" + MV_PAR01 + "' AND CTD_ITEM <= '" + MV_PAR02 + "' AND "
	cQuery += " CTD_DTEXIS    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " CTD_DTEXIS    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " CTD_DTEXSF    >= '" + DTOS(MV_PAR05) + "' AND  "
	cQuery += " CTD_DTEXSF    <= '" + DTOS(MV_PAR06) + "' AND "
	cQuery += "	CTD_XIDPM >= '" + MV_PAR07 + "' AND CTD_XIDPM <= '" + MV_PAR08 + "' AND "
	cQuery += "				SUBSTRING(CTD_ITEM,9,2) >= '15' "
	cQuery += "		) AND ZN_DESCRI = 'CONTABILIZADO' "
	cQuery += "	ORDER BY SUBSTRING(CTD_ITEM,9,2), SUBSTRING(CTD_ITEM,1,2), SUBSTRING(CTD_ITEM,4,3), SUBSTRING(CTD_ITEM,12,2)  "

	/*
	cQuery := " SELECT CTD_ITEM AS 'TMP_CONTRATO', CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_CLIENTE', CTD_XCUSTO AS 'TMP_CUSTO', CTD_XCUTOT AS 'TMP_CUSTPRD', "
	cQuery += "			CTD_XVDCI AS 'TMP_VDCI', CTD_XVDSI AS 'TMP_VDSI', convert(varchar(30),CTD_DTEXIS,102) AS 'TMP_DTINI', convert(varchar(30),CTD_DTEXSF,102) AS 'TMP_DTFIM', "
	cQuery += "			ZN_PVCFRT AS 'TMP_PVCFRT', ZN_PVSFRT AS 'TMP_PVSFRT', "
	cQuery += "			ZN_ITEM AS 'TMP_ITEM', ZN_DESCRI AS 'TMP_DESCRI', ZN_CUSTO AS 'TMP_DCUSTO', ZN_CONTIG AS 'TMP_CONTIG', ZN_CUPRD AS 'TMP_CUPRD', "
	cQuery += "			ZN_OCFIA AS 'TMP_FIANCAS', ZN_OCFIN AS 'TMP_CUSTFIN', ZN_OCGAR AS 'TMP_GARANTIA', ZN_OCPIP AS 'TMP_PERDIMP', ZN_OCCOM AS 'TMP_COMISSAO', ZN_OCROY AS 'TMP_ROYALTY', "
	cQuery += "			ZN_OUOUT  AS 'TMP_OUOUT' ,ZN_CUSTOT AS 'TMP_CUSTOTAL', "
	cQuery += "		ZN_VLRMB AS 'TMP_VLRMB', ZN_PERMB AS 'TMP_PERMB', ZN_VLRCTB AS 'TMP_VLRCTB', ZN_PERCTB AS 'TMP_PERCTB' "
	cQuery += "	FROM CTD010 "
	cQuery += "		INNER JOIN SZN010 ON ZN_ITEMIC = CTD_ITEM "
	cQuery += "		WHERE CTD010.D_E_L_E_T_ <> '*' AND  SZN010.D_E_L_E_T_ <> '*' AND "
	cQuery += "		CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') AND "
	cQuery += "		CTD_ITEM >= '" + MV_PAR01 + "' AND CTD_ITEM <= '" + MV_PAR02 + "' "
	cQuery += "				AND ZN_DESCRI = 'EMPENHADO' AND SUBSTRING(CTD_ITEM,9,2) >= '15' "
	cQuery += "	ORDER BY SUBSTRING(CTD_ITEM,9,2), SUBSTRING(CTD_ITEM,1,2), SUBSTRING(CTD_ITEM,4,3), SUBSTRING(CTD_ITEM,12,2) "
	*/

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBSGC") <> 0
		DbSelectArea("TRBSGC")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBSGC"

	dbSelectArea("TRBSGC")
	TRBSGC->(dbGoTop())

	oReport:SetMeter(TRBSGC->(LastRec()))

	oReport:SkipLine(3)
	oReport:FatLine()
	oReport:PrintText("Custo Empenhado / Contabilizado")
	oReport:FatLine()


		oSection1:Printline()
		TRBSGC->(dbSkip())



	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBSGC->TMP_CONTRATO
		cDesc	:= Alltrim(TRBSGC->TMP_DESCRI)

		IncProc("Imprimindo Custo  "+alltrim(TRBSGC->TMP_CONTRATO))



		//imprimo a primeira seção


					oSection1:Cell("TMP_CONTRATO"):SetValue(TRBSGC->TMP_CONTRATO)

					IF TMP_DTINI = ""

						oSection1:Cell("TMP_DTINI"):SetValue("")
						oSection1:Cell("TMP_DTINI"):SetAlign("CENTER")
					ELSE
						oSection1:Cell("TMP_DTINI"):SetValue(Substr(TRBSGC->TMP_DTINI,7,2) + "/" + Substr(TRBSGC->TMP_DTINI,5,2) + "/" + Substr(TRBSGC->TMP_DTINI,1,4))
						oSection1:Cell("TMP_DTINI"):SetAlign("CENTER")

					ENDIF

					oSection1:Cell("TMP_CLIENTE"):SetValue(TRBSGC->TMP_CLIENTE)

					oSection1:Cell("TMP_PVCFRT"):SetValue(TRBSGC->TMP_PVCFRT)
					oSection1:Cell("TMP_PVCFRT"):SetAlign("RIGHT")

					oSection1:Cell("TMP_PVSFRT"):SetValue(TRBSGC->TMP_PVSFRT)
					oSection1:Cell("TMP_PVSFRT"):SetAlign("RIGHT")

					oSection1:Cell("TMP_DCUSTO"):SetValue(TRBSGC->TMP_DCUSTO)
					oSection1:Cell("TMP_DCUSTO"):SetAlign("RIGHT")

					oSection1:Cell("TMP_CUPRD"):SetValue(TRBSGC->TMP_CUPRD)
					oSection1:Cell("TMP_CUPRD"):SetAlign("RIGHT")

					oSection1:Cell("TMP_COMISSAO"):SetValue(TRBSGC->TMP_COMISSAO)
					oSection1:Cell("TMP_COMISSAO"):SetAlign("RIGHT")

					oSection1:Cell("TMP_OUOUT"):SetValue(TRBSGC->TMP_OUOUT)
					oSection1:Cell("TMP_OUOUT"):SetAlign("RIGHT")

					oSection1:Cell("TMP_CUSTOTAL"):SetValue(TRBSGC->TMP_CUSTOTAL)
					oSection1:Cell("TMP_CUSTOTAL"):SetAlign("RIGHT")

					oSection1:Cell("TMP_PERMB"):SetValue(TRBSGC->TMP_PERMB)
					oSection1:Cell("TMP_PERMB"):SetAlign("RIGHT")

					oSection1:Cell("TMP_PERCTB"):SetValue(TRBSGC->TMP_PERCTB)
					oSection1:Cell("TMP_PERCTB"):SetAlign("RIGHT")

					oSection1:Cell("TMP_DESCRI"):SetValue(TRBSGC->TMP_DESCRI)


		oSection1:Printline()
		TRBSGC->(dbSkip())

	Enddo

	oSection1:Finish()


Return

static function ajustaSx1(cPerg)

	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Item Conta de ?"	  , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par01")
	putSx1(cPerg, "02", "Item Conta até?"	  , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par02")
	putSx1(cPerg, "03", "Data Inicio de?"  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Data Inicio até?"    , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")
	putSx1(cPerg, "05", "Data Fim de?"  	  , "", "", "mv_ch5", "D", 08, 0, 0, "G", "", "", "", "", "mv_par05")
	putSx1(cPerg, "06", "Data Fim até?"  	  , "", "", "mv_ch6", "D", 08, 0, 0, "G", "", "", "", "", "mv_par06")
	putSx1(cPerg, "07", "Coordenador de ?"	  , "", "", "mv_ch7", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par07")
	putSx1(cPerg, "08", "Coordenador de ?"	  , "", "", "mv_ch8", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par08")


return






