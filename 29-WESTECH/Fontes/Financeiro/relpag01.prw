
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relpag01()
	Local oReport := nil
	Local cPerg:= Padr("relpag01",10)

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
	Local oSection2:= Nil
	Local oBreak
	Local oFunction

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Pagamento efetivo de " + substr(DTOS(MV_PAR07),7,2) + "/" + substr(DTOS(MV_PAR07),5,2) + "/" + substr(DTOS(MV_PAR07),1,4) ;
										+ " ate " + substr(DTOS(MV_PAR08),7,2) + "/" + substr(DTOS(MV_PAR08),5,2) + "/" + substr(DTOS(MV_PAR08),1,4), ;
										cNome,{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=7
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.


	//Monstando a primeira se��o
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SE5"}, 			, .F.	, 	.F.)
	//TRCell():New(oSection1,"TMP_CONTRATO",	"TRBFIN",	"Contrato"  		,"@!"	,	13)
	//TRCell():New(oSection1,"TMP_NATUREZA"	,"TRBFIN","Naureza"	   		,"@!"				,13)
	//TRCell():New(oSection1,"TMP_DESCRI"		,"TRBFIN","Descr.Nat."	  	,"@!"				,30)

	//A segunda se��o
	oSection2:= TRSection():New(oReport, "Pagamento efetivo de " + DTOS(MV_PAR07) + " de " + DTOS(MV_PAR08), {"SE2"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_DATA"		,"TRBFIN","Data"			,"@!"				,19)
	TRCell():New(oSection2,"TMP_CONTRATO"	,"TRBFIN",	"Contrato"  		,"@!"	,	18)
	TRCell():New(oSection2,"TMP_NATUREZA"	,"TRBFIN","Naureza"	   		,"@!"				,12)
	TRCell():New(oSection2,"TMP_DESCRI"		,"TRBFIN","Descr.Nat."	  	,"@!"				,30)
	TRCell():New(oSection2,"TMP_NTITULO"	,"TRBFIN","T�tulo"			,"@!"				,15)

	TRCell():New(oSection2,"TMP_TIPO"		,"TRBFIN","Tipo"			,""					,6)
	TRCell():New(oSection2,"TMP_CONTA"		,"TRBFIN","Conta"			,""					,15)
	TRCell():New(oSection2,"TMP_NOME"		,"TRBFIN","Nome"			,""					,30)
	TRCell():New(oSection2,"TMP_EMPRESA"	,"TRBFIN","Empresa"			,"@!"				,30)
	TRCell():New(oSection2,"TMP_VALOR"		,"TRBFIN","Valor"			,"@E 999,999,999.99",22,,,,,"RIGHT")

	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_CONTRATO) },"",.F.)
	TRFunction():New(oSection2:Cell("TMP_VALOR")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)

	oReport:SetTotalInLine(.F.)

        //Aqui, farei uma quebra  por se��o
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local cNcm      := ""
	Local cNat		:= ""
	Local lPrim 	:= .T.
	oSection2:SetHeaderSection(.T.)

	//Monto minha consulta conforme parametros passado
	// ------ CONTAS A RECEBER FULL



	cQuery := " SELECT DISTINCT E2_XXIC AS 'TMP_CONTRATO', E5_NUMERO AS 'TMP_NTITULO', E5_DATA  AS 'TMP_DATA', IIF(E5_RECPAG = 'R', -E5_VALOR, E5_VALOR)  AS 'TMP_VALOR', "
	cQuery += " ED_DESCRIC AS 'TMP_DESCRI', E5_NATUREZ AS 'TMP_NATUREZA', "
	cQuery += " E5_FORNECE AS 'TMP_FORNECE', E5_BENEF AS 'TMP_EMPRESA', "
	cQuery += " E5_HISTOR AS 'TMP_HISTORICO', E5_DOCUMEN AS 'TMP_DOCUMENTO', E5_TIPO AS 'TMP_TIPO', E5_BANCO AS 'TMP_BANCO', E5_AGENCIA AS 'TMP_AGENCIA', A6_NOME AS 'TMP_NOME', E5_CONTA AS 'TMP_CONTA' "
	cQuery += " FROM SE5010 "
	cQuery += " LEFT JOIN SE2010 ON SE2010.E2_NUM = SE5010.E5_NUMERO AND SE2010.E2_FORNECE = SE5010.E5_FORNECE "
	cQuery += " LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA "
	cQuery += "	LEFT JOIN SED010 ON SED010.ED_CODIGO = E5_NATUREZ "
    cQuery += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "
 cQuery += " E2_XXIC		  >= '" + MV_PAR01 + "' AND  "
 cQuery += " E2_XXIC    	  <= '" + MV_PAR02 + "' AND  "
 cQuery += " E5_FORNECE		  >= '" + MV_PAR03 + "' AND  "
 cQuery += " E5_FORNECE    	  <= '" + MV_PAR04 + "' AND  "
 cQuery += " E5_NATUREZ		  >= '" + MV_PAR05 + "' AND  "
 cQuery += " E5_NATUREZ    	  <= '" + MV_PAR06 + "' AND  "
 cQuery += " E5_DATA    >= '" + DTOS(MV_PAR07) + "' AND  "
 cQuery += " E5_DATA    <= '" + DTOS(MV_PAR08) + "' AND  "
 cQuery += " E5_RECPAG = 'P' AND E5_TIPODOC IN ('PA','VL') AND E5_BANCO <> '' OR "
 cQuery += " E2_XXIC		  >= '" + MV_PAR01 + "' AND  "
 cQuery += " E2_XXIC    	  <= '" + MV_PAR02 + "' AND  "
 cQuery += " E5_FORNECE		  >= '" + MV_PAR03 + "' AND  "
 cQuery += " E5_FORNECE    	  <= '" + MV_PAR04 + "' AND  "
 cQuery += " E5_NATUREZ		  >= '" + MV_PAR05 + "' AND  "
 cQuery += " E5_NATUREZ    	  <= '" + MV_PAR06 + "' AND  "
 cQuery += " E5_DATA    >= '" + DTOS(MV_PAR07) + "' AND  "
 cQuery += " E5_DATA    <= '" + DTOS(MV_PAR08) + "' AND  "
 cQuery += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('ES') AND E5_BANCO <> '' OR "
 cQuery += " E2_XXIC		  >= '" + MV_PAR01 + "' AND  "
 cQuery += " E2_XXIC    	  <= '" + MV_PAR02 + "' AND  "
 cQuery += " E5_FORNECE		  >= '" + MV_PAR03 + "' AND  "
 cQuery += " E5_FORNECE    	  <= '" + MV_PAR04 + "' AND  "
 cQuery += " E5_NATUREZ		  >= '" + MV_PAR05 + "' AND  "
 cQuery += " E5_NATUREZ    	  <= '" + MV_PAR06 + "' AND  "
 cQuery += " E5_DATA    >= '" + DTOS(MV_PAR07) + "' AND  "
 cQuery += " E5_DATA    <= '" + DTOS(MV_PAR08) + "' AND  "
 cQuery += " E5_RECPAG = 'R' AND E5_TIPODOC IN ('CP')  ORDER BY 3, 1 "


 //cQuery += "E5_RECPAG = 'P' AND E2_BAIXA <> '' AND E5_TIPODOC IN ('PA','VL') "

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBFIN") <> 0
		DbSelectArea("TRBFIN")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBFIN"

	dbSelectArea("TRBFIN")
	TRBFIN->(dbGoTop())

	oReport:SetMeter(TRBFIN->(LastRec()))

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira se��o
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBFIN->TMP_CONTRATO
		cNat	:= TRBFIN->TMP_NATUREZA
		IncProc("Imprimindo Pagamento efetivo"+alltrim(TRBFIN->TMP_CONTRATO))

		//imprimo a primeira se��o
		//oSection1:Cell("TMP_CONTRATO"):SetValue(TRBFIN->TMP_CONTRATO)
		//oSection1:Cell("TMP_NATUREZA"):SetValue(TRBFIN->TMP_NATUREZA)
		//oSection1:Cell("TMP_DESCRI"):SetValue(TRBFIN->TMP_DESCRI)

		//oSection1:Printline()

		//inicializo a segunda se��o
		oSection2:init()

		//verifico se o codigo da NCM � mesmo, se sim, imprimo o produto
		While TRBFIN->TMP_CONTRATO == cNcm .AND. TRBFIN->TMP_NATUREZA == cNat
			oReport:IncMeter()

			IncProc("Imprimindo Pagamento efetivo "+alltrim(TRBFIN->TMP_NATUREZA))
			oSection2:Cell("TMP_CONTRATO"):SetValue(TRBFIN->TMP_CONTRATO)
			IF TMP_DATA = ""
				oSection2:Cell("TMP_DATA"):SetValue("")
			ELSE
				oSection2:Cell("TMP_DATA"):SetValue(Substr(TRBFIN->TMP_DATA,7,2) + "/" + Substr(TRBFIN->TMP_DATA,5,2) + "/" + Substr(TRBFIN->TMP_DATA,1,4))
			ENDIF
			oSection2:Cell("TMP_NATUREZA"):SetValue(TRBFIN->TMP_NATUREZA)
			oSection2:Cell("TMP_DESCRI"):SetValue(TRBFIN->TMP_DESCRI)
			oSection2:Cell("TMP_NTITULO"):SetValue(TRBFIN->TMP_NTITULO)

			oSection2:Cell("TMP_TIPO"):SetValue(TRBFIN->TMP_TIPO)
			oSection2:Cell("TMP_CONTA"):SetValue(TRBFIN->TMP_CONTA)
			oSection2:Cell("TMP_NOME"):SetValue(TRBFIN->TMP_NOME)
			oSection2:Cell("TMP_EMPRESA"):SetValue(TRBFIN->TMP_EMPRESA)
			oSection2:Cell("TMP_VALOR"):SetValue(TRBFIN->TMP_VALOR)

			oSection2:Printline()

 			TRBFIN->(dbSkip())
 		EndDo
 		//finalizo a segunda se��o para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira se��o
		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a fun��o putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Item Conta de ?"	  , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par01")
	putSx1(cPerg, "02", "Item Conta at�?"	  , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par02")
	putSx1(cPerg, "03", "Fornecedor de ?"	  , "", "", "mv_ch3", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par03")
	putSx1(cPerg, "04", "Fornecedor at�?"	  , "", "", "mv_ch4", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par04")
	putSx1(cPerg, "05", "Natureza de ?"		  , "", "", "mv_ch5", "C", 13, 0, 0, "G", "", "SED", "", "", "mv_par05")
	putSx1(cPerg, "06", "Natureza at�?"	  	  , "", "", "mv_ch6", "C", 13, 0, 0, "G", "", "SED", "", "", "mv_par06")
	putSx1(cPerg, "07", "Data de?"  	  	  , "", "", "mv_ch7", "D", 08, 0, 0, "G", "", "", "", "", "mv_par07")
	putSx1(cPerg, "08", "Data ate?"  	      , "", "", "mv_ch8", "D", 08, 0, 0, "G", "", "", "", "", "mv_par08")
return











