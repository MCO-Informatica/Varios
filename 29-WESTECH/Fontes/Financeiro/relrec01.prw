
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relrec01()
	Local oReport := nil
	Local cPerg:= Padr("RELREC01",10)

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
	oReport := TReport():New(cNome,"Recebimento efetivode " + substr(DTOS(MV_PAR03),7,2) + "/" + substr(DTOS(MV_PAR03),5,2) + "/" + substr(DTOS(MV_PAR03),1,4) ;
										+ " ate " + substr(DTOS(MV_PAR04),7,2) + "/" + substr(DTOS(MV_PAR04),5,2) + "/" + substr(DTOS(MV_PAR04),1,4), ;
										cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=7
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.


	//Monstando a primeira seção
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SE5"}, 			, .F.	, 	.F.)
	//TRCell():New(oSection1,"TMP_CONTRATO",	"TRBFIN",	"Contrato"  		,"@!"	,	13)

	//A segunda seção
	oSection2:= TRSection():New(oReport, "Recebimento efetivo", {"SE1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_DATA"		,"TRBFIN","Data"			,"@!"				,19)
	TRCell():New(oSection2,"TMP_CONTRATO"	,"TRBFIN",	"Contrato"  		,"@!"	,	22)
	TRCell():New(oSection2,"TMP_NTITULO"	,"TRBFIN","Título"			,"@!"				,15)
	TRCell():New(oSection2,"TMP_TIPO"		,"TRBFIN","Tipo"			,""					,6)
	TRCell():New(oSection2,"TMP_CONTA"		,"TRBFIN","Conta"			,""					,15)
	TRCell():New(oSection2,"TMP_NOME"		,"TRBFIN","Nome"			,""					,30)
	TRCell():New(oSection2,"TMP_EMPRESA"	,"TRBFIN","Empresa"			,"@!"				,50)
	TRCell():New(oSection2,"TMP_VALOR"		,"TRBFIN","Valor"			,"@E 999,999,999.99",22,,,,,"RIGHT")


	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_DATA) },"",.F.)
	TRFunction():New(oSection2:Cell("TMP_VALOR")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)



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
	// ------ CONTAS A RECEBER FULL


 cQuery := "SELECT DISTINCT E1_XXIC AS 'TMP_CONTRATO', E5_NUMERO AS 'TMP_NTITULO', E5_DATA AS 'TMP_DATA', E5_VALOR AS 'TMP_VALOR',  E5_BENEF AS 'TMP_EMPRESA', "
 cQuery += "	E5_HISTOR AS 'TMP_HISTORICO', E5_DOCUMEN AS 'TMP_DOCUMENTO', E5_TIPO AS 'TMP_TIPO', E5_BANCO AS 'TMP_BANCO', E5_AGENCIA AS 'TMP_AGENCIA', A6_NOME AS 'TMP_NOME', E5_CONTA AS 'TMP_CONTA' FROM SE5010 "
 cQuery += "	LEFT JOIN SE1010 ON SE1010.E1_NUM = SE5010.E5_NUMERO AND E1_CLIENTE = E5_CLIFOR  "
 cQuery += "	LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA "
 cQuery += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SE1010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "
 cQuery += " E1_XXIC		  >= '" + MV_PAR01 + "' AND  "
 cQuery += " E1_XXIC    	  <= '" + MV_PAR02 + "' AND  "
 cQuery += " E5_DATA    >= '" + DTOS(MV_PAR03) + "' AND  "
 cQuery += " E5_DATA    <= '" + DTOS(MV_PAR04) + "' AND  "
 cQuery += "E5_RECPAG = 'R' AND E1_BAIXA <> '' AND E5_TIPODOC IN ('RA','VL') ORDER BY 3, 1 "

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

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBFIN->TMP_DATA
		IncProc("Imprimindo Recebimento Efetito"+alltrim(TRBFIN->TMP_DATA))

		//imprimo a primeira seção
		//oSection1:Cell("TMP_CONTRATO"):SetValue(TRBFIN->TMP_CONTRATO)
		//oSection1:Printline()
		//inicializo a segunda seção
		oSection2:init()

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBFIN->TMP_DATA == cNcm
			oReport:IncMeter()

			IncProc("Imprimindo Recebimento efetivo "+alltrim(TRBFIN->TMP_DATA))

			IF TMP_DATA = ""
				oSection2:Cell("TMP_DATA"):SetValue("")
			ELSE
				oSection2:Cell("TMP_DATA"):SetValue(Substr(TRBFIN->TMP_DATA,7,2) + "/" + Substr(TRBFIN->TMP_DATA,5,2) + "/" + Substr(TRBFIN->TMP_DATA,1,4))
			ENDIF
			oSection2:Cell("TMP_CONTRATO"):SetValue(TRBFIN->TMP_CONTRATO)
			oSection2:Cell("TMP_NTITULO"):SetValue(TRBFIN->TMP_NTITULO)

			oSection2:Cell("TMP_TIPO"):SetValue(TRBFIN->TMP_TIPO)
			oSection2:Cell("TMP_CONTA"):SetValue(TRBFIN->TMP_CONTA)
			oSection2:Cell("TMP_NOME"):SetValue(TRBFIN->TMP_NOME)
			oSection2:Cell("TMP_EMPRESA"):SetValue(TRBFIN->TMP_EMPRESA)
			oSection2:Cell("TMP_VALOR"):SetValue(TRBFIN->TMP_VALOR)

			oSection2:Printline()

 			TRBFIN->(dbSkip())
 		EndDo
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Item Conta de ?"	  , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par01")
	putSx1(cPerg, "02", "Item Conta até?"	  , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par02")
	putSx1(cPerg, "03", "Data de?"  	  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Data ate?"  	      , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")

return









