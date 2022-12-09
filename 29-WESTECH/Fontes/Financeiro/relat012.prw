
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat012()
	Local oReport := nil
	Local cPerg:= Padr("RELAT012",10)

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)
	//gero a pergunta de modo oculto, ficando dispon�vel no bot�o a��es relacionadas
	Pergunte(cPerg,.T.)

	PswOrder( 1 ) // Ordena por user ID //

	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf

	IF cGRUPO == "000002" .OR. cGRUPO == "000003" .OR. cGRUPO == "000005" .OR. cGRUPO == "000006"
		IF MV_PAR01 == "ADMINISTRACAO" .OR. MV_PAR02 == "ADMINISTRACAO" .OR. MV_PAR01 == "XXXXXX" .OR. MV_PAR02 == "XXXXXX"
			msginfo( "Perfil do usu�rio n�o pode filtrar por Item Conta." )
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
	oReport := TReport():New(cNome,"Contas a Pagar - Provis�es",cNome,{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=7
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.


	//Monstando a primeira se��o
	//Neste exemplo, a primeira se��o ser� composta por duas colunas, c�digo da NCM e sua descri��o
	//Iremos disponibilizar para esta se��o apenas a tabela SYD, pois quando voc� for em personalizar
	//e entrar na primeira se��o, voc� ter� todos os outros campos dispon�veis, com isso, ser�
	//permitido a inser��o dos outros campos
	//Neste exemplo, tamb�m, j� deixarei definido o nome dos campos, mascara e tamanho, mas voc�
	//ter� toda a liberdade de modific�-los via relatorio.
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SE2"}, 			, .F.	, 	.F.)
	//TRCell():New(oSection1,"TMP_CONTRATO",	"TRBFIN",	"Contrato"  		,"@!"	,	13)

	//A segunda se��o, ser� apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb�m a tabela de NCM, com isso, voc� poderia incluir os campos da tabela
	//SYD.Semelhante a se��o 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Contas a Pagar - Provis�es", {"SE2"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_CONTRATO"	,"TRBFIN","Contrato"  		,"@!"			,	25)
	TRCell():New(oSection2,"TMP_TITULO"		,"TRBFIN","T�tulo"			,"@!"				,09)
	TRCell():New(oSection2,"TMP_TIPO"		,"TRBFIN","Tipo"			,"@!"				,06)
	TRCell():New(oSection2,"TMP_NATUREZA"	,"TRBFIN","Natureza"		,"@!"				,12)
	TRCell():New(oSection2,"TMP_CODFORN"	,"TRBFIN","C�digo"			,"@!"				,12)
	TRCell():New(oSection2,"TMP_FORNECE"	,"TRBFIN","Fornecedor"		,"@!"				,40)
	TRCell():New(oSection2,"TMP_VENCTO"		,"TRBFIN","Vencimento"		,""					,19)
	TRCell():New(oSection2,"TMP_VENCREAL"	,"TRBFIN","Vencto.Real"		,""					,19)
	TRCell():New(oSection2,"TMP_VALOR"		,"TRBFIN","Valor"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_SALDO"		,"TRBFIN","Saldo"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_BAIXA"		,"TRBFIN","Baixa"			,""					,19)
	TRCell():New(oSection2,"TMP_HIST"		,"TRBFIN","Hist�rico"		,""					,80)


	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_VENCREAL) },"",.F.)
	TRFunction():New(oSection2:Cell("TMP_VALOR")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_SALDO")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)


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
	Local lPrim 	:= .T.
	oSection2:SetHeaderSection(.T.)
	PswOrder( 1 ) // Ordena por user ID //

	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf

	//Monto minha consulta conforme parametros passado
	// ------ CONTAS A PAGAR Provis�es

	cQuery := "SELECT	E2_XXIC AS 'TMP_CONTRATO', E2_NUM as 'TMP_TITULO', E2_TIPO as 'TMP_TIPO', E2_NATUREZ as 'TMP_NATUREZA', E2_FORNECE as 'TMP_CODFORN', "
	cQuery += "		E2_NOMFOR as 'TMP_FORNECE', CAST(E2_EMISSAO as Date) as 'TMP_EMISSAO', E2_VENCTO  as 'TMP_VENCTO', E2_VENCREA as 'TMP_VENCREAL', "
	cQuery += "		IIF(E2_TIPO = 'PA' AND E2_BAIXA <> '', E2_VALOR, E2_VALOR)  as 'TMP_VALOR', "
	cQuery += "		E2_SALDO AS 'TMP_SALDO', "
	cQuery += "		E2_HIST as 'TMP_HIST', E2_BAIXA AS 'TMP_BAIXA', E2_BAIXA "
	cQuery += "	FROM SE2010 "
	cQuery += "	WHERE  SE2010.D_E_L_E_T_ <> '*' AND E2_TIPO = 'PR' AND "

	IF cGRUPO == "000002" .OR. cGRUPO == "000003" .OR. cGRUPO == "000005" .OR. cGRUPO == "000006"
		cQuery += " E2_XXIC NOT IN  (SELECT E2_XXIC FROM SE2010 WHERE E2_XXIC = 'ADMINISTRACAO') AND "
		cQuery += " E2_XXIC NOT IN  (SELECT E2_XXIC FROM SE2010 WHERE E2_XXIC = 'XXXXXX') AND "
		cQuery += " E2_XXIC NOT IN  (SELECT E2_XXIC FROM SE2010 WHERE E2_XXIC = ' ') AND "
	END IF

	cQuery += " E2_XXIC		  >= '" + MV_PAR01 + "' AND  "
	cQuery += " E2_XXIC    	  <= '" + MV_PAR02 + "' AND  "
	cQuery += " E2_VENCREA    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " E2_VENCREA    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " E2_FORNECE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " E2_FORNECE    <= '" + MV_PAR06 + "' "
	cQuery += "	ORDER BY E2_VENCREA,E2_XXIC,  E2_EMISSAO "


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

		cNcm 	:= TRBFIN->TMP_VENCREAL
		IncProc("Imprimindo Contas a Pagar - Provis�es"+alltrim(TRBFIN->TMP_VENCREAL))

		//imprimo a primeira se��o
		//oSection1:Cell("TMP_VENCREAL"):SetValue(TRBFIN->TMP_CONTRATO)

		oSection1:Printline()

		//inicializo a segunda se��o
		oSection2:init()

		//verifico se o codigo da NCM � mesmo, se sim, imprimo o produto
		While TRBFIN->TMP_VENCREAL == cNcm
			oReport:IncMeter()

			IncProc("Imprimindo Contas a Pagar - Provis�es "+alltrim(TRBFIN->TMP_VENCREAL))
			oSection2:Cell("TMP_CONTRATO"):SetValue(TRBFIN->TMP_CONTRATO)
			oSection2:Cell("TMP_TIPO"):SetValue(TRBFIN->TMP_TIPO)
			oSection2:Cell("TMP_NATUREZA"):SetValue(TRBFIN->TMP_NATUREZA)
			oSection2:Cell("TMP_CODFORN"):SetValue(TRBFIN->TMP_CODFORN)
			oSection2:Cell("TMP_FORNECE"):SetValue(TRBFIN->TMP_FORNECE)
			IF TMP_VENCTO = ""
				oSection2:Cell("TMP_VENCTO"):SetValue("")
			ELSE
				oSection2:Cell("TMP_VENCTO"):SetValue(Substr(TRBFIN->TMP_VENCTO,7,2) + "/" + Substr(TRBFIN->TMP_VENCTO,5,2) + "/" + Substr(TRBFIN->TMP_VENCTO,1,4))
			ENDIF

			//oSection2:Cell("TMP_VENCTO"):SetValue(TRBFIN->TMP_VENCTO)

			IF TMP_VENCREAL = ""
				oSection2:Cell("TMP_VENCREAL"):SetValue("")
			ELSE
				oSection2:Cell("TMP_VENCREAL"):SetValue(Substr(TRBFIN->TMP_VENCREAL,7,2) + "/" + Substr(TRBFIN->TMP_VENCREAL,5,2) + "/" + Substr(TRBFIN->TMP_VENCREAL,1,4))
			ENDIF
			oSection2:Cell("TMP_VALOR"):SetValue(TRBFIN->TMP_VALOR)
			oSection2:Cell("TMP_VALOR"):SetAlign("RIGHT")

			oSection2:Cell("TMP_SALDO"):SetValue(TRBFIN->TMP_SALDO)
			oSection2:Cell("TMP_SALDO"):SetAlign("RIGHT")

			IF TMP_BAIXA = ""
				oSection2:Cell("TMP_BAIXA"):SetValue("")
			ELSE
				oSection2:Cell("TMP_BAIXA"):SetValue(Substr(TRBFIN->TMP_BAIXA,7,2) + "/" + Substr(TRBFIN->TMP_BAIXA,5,2) + "/" + Substr(TRBFIN->TMP_BAIXA,1,4))
			ENDIF
			oSection2:Cell("TMP_HIST"):SetValue(TRBFIN->TMP_HIST)

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
	putSx1(cPerg, "03", "Venc. Real de?"  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Venc. Real at�?"  	  , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")
	putSx1(cPerg, "05", "Fornecedor de ?"	  , "", "", "mv_ch5", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par05")
	putSx1(cPerg, "06", "Fornecedor at�?"	  , "", "", "mv_ch6", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par06")

return







