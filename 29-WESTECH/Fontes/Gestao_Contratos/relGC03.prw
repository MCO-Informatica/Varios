#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relGC03()




	Local oReport := nil
	Local cPerg:= Padr("relGC03",10)

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
	oReport := TReport():New(cNome,"Relatório de Faturamento / Recebimento Realizado " ,cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
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
	TRCell():New(oSection1,"TMP_CONTRATO",	"TRBSGC",	"Contrato"  		,"@!"	,	22)

	TRCell():New(oSection1,"TMP_DTINI"		,"TRBSGC","Data Venda."		,""	,	16,,,,,"CENTER")


	TRCell():New(oSection1,"TMP_CLIENTE",	"TRBSGC",	"Cliente."  		,"@!"	,	40)
	TRCell():New(oSection1,"TMP_PVCI"		,"TRBSGC","Vend.c/Trib."		,"@E 99,999,999.99",18,,,,,"RIGHT")


	TRCell():New(oSection1,"TMP_FATCTR"		,"TRBSGC","Faturamento "		,"@E 99,999,999.99",16,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_DTFAT"		,"TRBSGC","Data Fatura."		,""	,	18,,,,,"CENTER")

	TRCell():New(oSection1,"TMP_RECCTR"		,"TRBSGC","Recebimento."		,"@E 99,999,999.99",18,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_DTREC"		,"TRBSGC","Data Recebi."		,"@!"	,   18,,,,,"CENTER")
	TRCell():New(oSection1,"TMP_SALDO"		,"TRBSGC","Sld a Fat."		   	,"@E 99,999,999.99",18,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_SLDREC"		,"TRBSGC","Sld a Rec."			,"@E 99,999,999.99",18,,,,,"RIGHT")

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
	Local lPrim 	:= .T.

	//Monto minha consulta conforme parametros passado
	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO

	cQuery := " SELECT CTD_ITEM AS 'TMP_CONTRATO', CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_CLIENTE', CTD_XCUSTO AS 'TMP_CUSTO', CTD_XCUTOT AS 'TMP_CUSTPRD', "
	cQuery += "		CTD_XVDCI AS 'TMP_VDCI', CTD_XVDSI AS 'TMP_VDSI', convert(varchar(30),CTD_DTEXIS,102) AS 'TMP_DTINI', convert(varchar(30),CTD_DTEXSF,102) AS 'TMP_DTFIM', "
	cQuery += "		ZZ_PVCI AS 'TMP_PVCI', ZZ_PVSI AS 'TMP_PVSI', "
	cQuery += "		ZZ_ITEM AS 'TMP_ITEM', ZZ_DESCRI AS 'TMP_DESCRI', ZZ_PVSI AS 'TMP_PVSI', ZZ_PVCI AS 'TMP_PVCI', "
	cQuery += "		convert(varchar(30),ZZ_DTFAT,102) AS 'TMP_DTFAT', ZZ_FATCTR AS 'TMP_FATCTR', convert(varchar(30),ZZ_DTREC,102) AS 'TMP_DTREC', ZZ_RECCTR AS 'TMP_RECCTR', ZZ_SALDO AS 'TMP_SALDO', ZZ_SLDREC AS 'TMP_SLDREC' "
	cQuery += "		FROM CTD010 "
	cQuery += "			LEFT JOIN SZZ010 ON CTD_ITEM = ZZ_ITEMIC  "
	cQuery += "	WHERE "
	cQuery += "		CTD_ITEM IN "
	cQuery += "		( "
	cQuery += "			SELECT CTD_ITEM  "
	cQuery += "	FROM CTD010 "
	cQuery += "			WHERE CTD010.D_E_L_E_T_ <> '*' AND  "
	cQuery += "				CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') AND "
	cQuery += "				CTD_ITEM >= '" + MV_PAR01 + "' AND CTD_ITEM <= '" + MV_PAR02 + "' AND "
	cQuery += " CTD_DTEXIS    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " CTD_DTEXIS    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " CTD_DTEXSF    >= '" + DTOS(MV_PAR05) + "' AND  "
	cQuery += " CTD_DTEXSF    <= '" + DTOS(MV_PAR06) + "' AND "
	cQuery += "	CTD_XIDPM >= '" + MV_PAR07 + "' AND CTD_XIDPM <= '" + MV_PAR08 + "' AND "
	cQuery += "				SUBSTRING(CTD_ITEM,9,2) >= '15' "
	cQuery += "		) AND ZZ_DESCRI IS NULL  OR "
	cQuery += "		CTD_ITEM IN "
	cQuery += "		( "
	cQuery += "			SELECT CTD_ITEM  "
	cQuery += "	FROM CTD010 "
	cQuery += "			WHERE CTD010.D_E_L_E_T_ <> '*' AND  "
	cQuery += "				CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') AND "
	cQuery += "				CTD_ITEM >= '" + MV_PAR01 + "' AND CTD_ITEM <= '" + MV_PAR02 + "' AND "
	cQuery += " CTD_DTEXIS    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " CTD_DTEXIS    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " CTD_DTEXSF    >= '" + DTOS(MV_PAR05) + "' AND  "
	cQuery += " CTD_DTEXSF    <= '" + DTOS(MV_PAR06) + "' AND  "
	cQuery += "	CTD_XIDPM >= '" + MV_PAR07 + "' AND CTD_XIDPM <= '" + MV_PAR08 + "' AND"
	cQuery += "				SUBSTRING(CTD_ITEM,9,2) >= '15' "
	cQuery += "		) AND  ZZ_DESCRI = 'REALIZADO' "
	cQuery += "	ORDER BY SUBSTRING(CTD_ITEM,9,2), SUBSTRING(CTD_ITEM,1,2), SUBSTRING(CTD_ITEM,4,3), SUBSTRING(CTD_ITEM,12,2) "

	/*
	cQuery := " SELECT CTD_ITEM AS 'TMP_CONTRATO', CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_CLIENTE', CTD_XCUSTO AS 'TMP_CUSTO', CTD_XCUTOT AS 'TMP_CUSTPRD', "
	cQuery += "				CTD_XVDCI AS 'TMP_VDCI', CTD_XVDSI AS 'TMP_VDSI', convert(varchar(30),CTD_DTEXIS,102) AS 'TMP_DTINI', convert(varchar(30),CTD_DTEXSF,102) AS 'TMP_DTFIM', "
	cQuery += "		ZZ_PVCI AS 'TMP_PVCI', ZZ_PVSI AS 'TMP_PVSI', "
	cQuery += "				ZZ_ITEM AS 'TMP_ITEM', ZZ_DESCRI AS 'TMP_DESCRI', ZZ_PVSI AS 'TMP_PVSI', ZZ_PVCI AS 'TMP_PVCI',  "
	cQuery += "				convert(varchar(30),ZZ_DTFAT,102) AS 'TMP_DTFAT', ZZ_FATCTR AS 'TMP_FATCTR', convert(varchar(30),ZZ_DTREC,102) AS 'TMP_DTREC', ZZ_RECCTR AS 'TMP_RECCTR', ZZ_SALDO AS 'TMP_SALDO', ZZ_SLDREC AS 'TMP_SLDREC' "
	cQuery += "	FROM CTD010 "
	cQuery += "				INNER JOIN SZZ010 ON ZZ_ITEMIC = CTD_ITEM "
	cQuery += "	WHERE CTD010.D_E_L_E_T_ <> '*' AND  SZZ010.D_E_L_E_T_ <> '*' AND "
	cQuery += "				CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') AND "
	cQuery += "				CTD_ITEM >= '" + MV_PAR01 + "' AND CTD_ITEM <= '" + MV_PAR02 + "' "
	cQuery += "				AND ZZ_DESCRI = 'REALIZADO' AND SUBSTRING(CTD_ITEM,9,2) >= '15' "
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
	oReport:PrintText("Fatturamento / Recebimento Realizado")
	oReport:FatLine()

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBSGC->TMP_CONTRATO
		IncProc("Imprimindo Faturamento / Recebimento  "+alltrim(TRBSGC->TMP_CONTRATO))

		//imprimo a primeira seção

			oSection1:Cell("TMP_CONTRATO"):SetValue(TRBSGC->TMP_CONTRATO)
			oSection1:Cell("TMP_CLIENTE"):SetValue(TRBSGC->TMP_CLIENTE)

			oSection1:Cell("TMP_PVCI"):SetValue(TRBSGC->TMP_PVCI)
			oSection1:Cell("TMP_PVCI"):SetAlign("RIGHT")


			IF TMP_DTINI = ""
				oSection1:Cell("TMP_DTINI"):SetValue("")
				oSection1:Cell("TMP_DTINI"):SetAlign("CENTER")
			ELSE
				oSection1:Cell("TMP_DTINI"):SetValue(Substr(TRBSGC->TMP_DTINI,7,2) + "/" + Substr(TRBSGC->TMP_DTINI,5,2) + "/" + Substr(TRBSGC->TMP_DTINI,1,4))
				oSection1:Cell("TMP_DTINI"):SetAlign("CENTER")
			ENDIF


			oSection1:Cell("TMP_FATCTR"):SetValue(TRBSGC->TMP_FATCTR)
			oSection1:Cell("TMP_FATCTR"):SetAlign("RIGHT")

			IF TMP_DTFAT = ""
				oSection1:Cell("TMP_DTFAT"):SetValue("")
				oSection1:Cell("TMP_DTFAT"):SetAlign("CENTER")
			ELSE
				oSection1:Cell("TMP_DTFAT"):SetValue(Substr(TRBSGC->TMP_DTFAT,7,2) + "/" + Substr(TRBSGC->TMP_DTFAT,5,2) + "/" + Substr(TRBSGC->TMP_DTFAT,1,4))
				oSection1:Cell("TMP_DTFAT"):SetAlign("CENTER")
			ENDIF



			//oSection1:Cell("TMP_DTREC"):SetValue(TRBSGC->TMP_DTREC)

			oSection1:Cell("TMP_RECCTR"):SetValue(TRBSGC->TMP_RECCTR)
			oSection1:Cell("TMP_RECCTR"):SetAlign("RIGHT")

			IF TMP_DTREC = ""
				oSection1:Cell("TMP_DTREC"):SetValue("")
				oSection1:Cell("TMP_DTREC"):SetAlign("CENTER")
			ELSE
				oSection1:Cell("TMP_DTREC"):SetValue(Substr(TRBSGC->TMP_DTREC,7,2) + "/" + Substr(TRBSGC->TMP_DTREC,5,2) + "/" + Substr(TRBSGC->TMP_DTREC,1,4))
				oSection1:Cell("TMP_DTREC"):SetAlign("CENTER")
			ENDIF

			oSection1:Cell("TMP_SALDO"):SetValue(TRBSGC->TMP_SALDO)
			oSection1:Cell("TMP_SALDO"):SetAlign("RIGHT")

			oSection1:Cell("TMP_SLDREC"):SetValue(TRBSGC->TMP_SLDREC)
			oSection1:Cell("TMP_SLDREC"):SetAlign("RIGHT")
		oReport:ThinLine()
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




