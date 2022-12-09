#Include 'Protheus.ch'
#Include 'topconn.ch'

User Function relGC02()


	Local oReport := nil
	Local cPerg:= Padr("relGC02",10)

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
	Pergunte(cPerg,.T.)


	PswOrder( 1 ) // Ordena por user ID //

	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf

	IF cGRUPO == "000002" .OR. cGRUPO == "000003" .OR. cGRUPO == "000005" .OR. cGRUPO == "000006"
		IF MV_PAR01 == "ADMINISTRACAO" .OR. MV_PAR02 == "ADMINISTRACAO" .OR. MV_PAR01 == "XXXXXX" .OR. MV_PAR02 == "XXXXXX"
			msginfo( "Perfil do usuário não pode filtrar por Item Conta." )
	        return .F.
	    ENDIF
	END IF

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
	oReport := TReport():New(cNome,"JOB'S - Sumário de Faturamento e Recebimento",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=6
	//oReport:cFontBody:="Calibri"
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"CTD"}, 			, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_CONTRATO",	"TRBSGC",	"Contrato"  		,"@!"	,	20)
	TRCell():New(oSection1,"TMP_CODCLI",	"TRBSGC",	"Cod.Cli."  		,"@!"	,	15)
	TRCell():New(oSection1,"TMP_CLIENTE",	"TRBSGC",	"Cliente."  		,"@!"	,	30)
	TRCell():New(oSection1,"TMP_DTINI",		"TRBSGC",	"Pedido" 	 		,"@!"	,	16)
	TRCell():New(oSection1,"TMP_DTFIM",		"TRBSGC",	"Entrega."  		,"@!"	,	16)


	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Gestao de Contratos ", {"CTD"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_ITEM"		,"TRBSGC","Item"				,"@!"				,06)
	TRCell():New(oSection2,"TMP_DESCRI"		,"TRBSGC","Tipo"				,"@!"				,22)

	TRCell():New(oSection2,"TMP_PVCI"		,"TRBSGC","Vend.c/Tributos"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_PVSI"		,"TRBSGC","Vend.s/Tributos"		,"@E 999,999,999.99",22,,,,,"RIGHT")

	TRCell():New(oSection2,"TMP_DTFAT"		,"TRBSGC","Data Fat."			,"@!"	,	16,,,,,"CENTER")
	TRCell():New(oSection2,"TMP_FATCTR"		,"TRBSGC","Faturamento "		,"@E 999,999,999.99",22,,,,,"RIGHT")

	TRCell():New(oSection2,"TMP_DTREC"		,"TRBSGC","Data Receb.."		,"@!"	,	16,,,,,"CENTER")
	TRCell():New(oSection2,"TMP_RECCTR"		,"TRBSGC","Recebimento."		,"@E 999,999,999.99",22,,,,,"RIGHT")

	TRCell():New(oSection2,"TMP_SALDO"		,"TRBSGC","Sld a Fat."		   	,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_SLDREC"		,"TRBSGC","Sld a Rec."			,"@E 999,999,999.99",22,,,,,"RIGHT")

	/*
	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_CONTRATO) },"Subtotal:",.F.)
	TRFunction():New(oSection2:Cell("TMP_VALOR")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_SALDO")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	*/

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
	Local dData		:= date()

	//msginfo ( dtos(dData) )
	oSection2:SetHeaderSection(.T.)
	PswOrder( 1 ) // Ordena por user ID //

	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf

	//Monto minha consulta conforme parametros passado
	// ------ CONTAS A PAGAR FULL



	cQuery := " SELECT CTD_ITEM AS 'TMP_CONTRATO', CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_CLIENTE', CTD_XCUSTO AS 'TMP_CUSTO', CTD_XCUTOT AS 'TMP_CUSTPRD', "
	cQuery += "				CTD_XVDCI AS 'TMP_VDCI', CTD_XVDSI AS 'TMP_VDSI', convert(varchar(30),CTD_DTEXIS,102) AS 'TMP_DTINI', convert(varchar(30),CTD_DTEXSF,102) AS 'TMP_DTFIM', "
	cQuery += "		ZZ_PVCI AS 'TMP_PVCI', ZZ_PVSI AS 'TMP_PVSI', "
	cQuery += "				ZZ_ITEM AS 'TMP_ITEM', ZZ_DESCRI AS 'TMP_DESCRI', ZZ_PVSI AS 'TMP_PVSI', ZZ_PVCI AS 'TMP_PVCI',  "
	cQuery += "				convert(varchar(30),ZZ_DTFAT,102) AS 'TMP_DTFAT', ZZ_FATCTR AS 'TMP_FATCTR', convert(varchar(30),ZZ_DTREC,102) AS 'TMP_DTREC', ZZ_RECCTR AS 'TMP_RECCTR', ZZ_SALDO AS 'TMP_SALDO', ZZ_SLDREC AS 'TMP_SLDREC' "
	cQuery += "	FROM CTD010 "
	cQuery += "				INNER JOIN SZZ010 ON ZZ_ITEMIC = CTD_ITEM "
	cQuery += "	WHERE CTD010.D_E_L_E_T_ <> '*' AND  SZZ010.D_E_L_E_T_ <> '*' AND "
	cQuery += "				CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') AND "
	cQuery += "				CTD_ITEM >= '" + MV_PAR01 + "' AND CTD_ITEM <= '" + MV_PAR02 + "' AND SUBSTRING(CTD_ITEM,9,2) >= '15' AND "
	cQuery += " CTD_DTEXIS    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " CTD_DTEXIS    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " CTD_DTEXSF    >= '" + DTOS(MV_PAR05) + "' AND  "
	cQuery += " CTD_DTEXSF    <= '" + DTOS(MV_PAR06) + "' AND "
	cQuery += "	CTD_XIDPM >= '" + MV_PAR07 + "' AND CTD_XIDPM <= '" + MV_PAR08 + "'"
	cQuery += "	ORDER BY SUBSTRING(CTD_ITEM,9,2), SUBSTRING(CTD_ITEM,1,2), SUBSTRING(CTD_ITEM,4,3) "


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

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBSGC->TMP_CONTRATO
		IncProc("Imprimindo Faturamento e Recebimento"+alltrim(TRBSGC->TMP_CONTRATO))

		//imprimo a primeira seção
		oSection1:Cell("TMP_CONTRATO"):SetValue(TRBSGC->TMP_CONTRATO)
		oSection1:Cell("TMP_CODCLI"):SetValue(TRBSGC->TMP_CODCLI)
		oSection1:Cell("TMP_CLIENTE"):SetValue(TRBSGC->TMP_CLIENTE)


		IF TMP_DTINI = ""
			oSection1:Cell("TMP_DTINI"):SetValue("")
		ELSE
			oSection1:Cell("TMP_DTINI"):SetValue(Substr(TRBSGC->TMP_DTINI,7,2) + "/" + Substr(TRBSGC->TMP_DTINI,5,2) + "/" + Substr(TRBSGC->TMP_DTINI,1,4))
		ENDIF

		IF TMP_DTFIM = ""
			oSection1:Cell("TMP_DTFIM"):SetValue("")
		ELSE
			oSection1:Cell("TMP_DTFIM"):SetValue(Substr(TRBSGC->TMP_DTFIM,7,2) + "/" + Substr(TRBSGC->TMP_DTFIM,5,2) + "/" + Substr(TRBSGC->TMP_DTFIM,1,4))
		ENDIF


		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBSGC->TMP_CONTRATO == cNcm
			oReport:IncMeter()

			IncProc("Imprimindo Sumario "+alltrim(TRBSGC->TMP_CONTRATO))

			oSection2:Cell("TMP_ITEM"):SetValue(TRBSGC->TMP_ITEM)
			oSection2:Cell("TMP_DESCRI"):SetValue(TRBSGC->TMP_DESCRI)

			oSection2:Cell("TMP_PVCI"):SetValue(TRBSGC->TMP_PVCI)
			oSection2:Cell("TMP_PVCI"):SetAlign("RIGHT")

			oSection2:Cell("TMP_PVSI"):SetValue(TRBSGC->TMP_PVSI)
			oSection2:Cell("TMP_PVSI"):SetAlign("RIGHT")


			IF TMP_DTFIM = ""
				oSection2:Cell("TMP_DTFAT"):SetValue("")
				oSection2:Cell("TMP_DTFAT"):SetAlign("CENTER")
			ELSE
				oSection2:Cell("TMP_DTFAT"):SetValue(Substr(TRBSGC->TMP_DTFAT,7,2) + "/" + Substr(TRBSGC->TMP_DTFAT,5,2) + "/" + Substr(TRBSGC->TMP_DTFAT,1,4))
				oSection2:Cell("TMP_DTFAT"):SetAlign("CENTER")
			ENDIF

			oSection2:Cell("TMP_FATCTR"):SetValue(TRBSGC->TMP_FATCTR)
			oSection2:Cell("TMP_FATCTR"):SetAlign("RIGHT")


			IF TMP_DTREC = ""
				oSection2:Cell("TMP_DTREC"):SetValue("")
				oSection2:Cell("TMP_DTREC"):SetAlign("CENTER")
			ELSE
				oSection2:Cell("TMP_DTREC"):SetValue(Substr(TRBSGC->TMP_DTREC,7,2) + "/" + Substr(TRBSGC->TMP_DTREC,5,2) + "/" + Substr(TRBSGC->TMP_DTREC,1,4))
				oSection2:Cell("TMP_DTREC"):SetAlign("CENTER")
			ENDIF


			oSection2:Cell("TMP_RECCTR"):SetValue(TRBSGC->TMP_RECCTR)
			oSection2:Cell("TMP_RECCTR"):SetAlign("RIGHT")



			oSection2:Cell("TMP_SALDO"):SetValue(TRBSGC->TMP_SALDO)
			oSection2:Cell("TMP_SALDO"):SetAlign("TMP_DCUSTO")

			oSection2:Cell("TMP_SLDREC"):SetValue(TRBSGC->TMP_SLDREC)
			oSection2:Cell("TMP_SLDREC"):SetAlign("TMP_SLDREC")


			oSection2:Printline()

 			TRBSGC->(dbSkip())
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
	putSx1(cPerg, "03", "Data Inicio de?"  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Data Inicio até?"    , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")
	putSx1(cPerg, "05", "Data Fim de?"  	  , "", "", "mv_ch5", "D", 08, 0, 0, "G", "", "", "", "", "mv_par05")
	putSx1(cPerg, "06", "Data Fim até?"  	  , "", "", "mv_ch6", "D", 08, 0, 0, "G", "", "", "", "", "mv_par06")
	putSx1(cPerg, "07", "Coordenador de ?"	  , "", "", "mv_ch7", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par07")
	putSx1(cPerg, "08", "Coordenador de ?"	  , "", "", "mv_ch8", "C", 06, 0, 0, "G", "", "ZZB", "", "", "mv_par08")


return

