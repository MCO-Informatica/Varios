#Include 'Protheus.ch'
#Include 'topconn.ch'

User Function zBook2()

	Local oReport := nil
	Local cPerg	:= Padr("ZBOOK2",10)

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)
	//gero a pergunta de modo oculto, ficando dispon�vel no bot�o a��es relacionadas
	Pergunte(cPerg,.T.)

	if !VldParamB2()
		return
	endif

	PswOrder( 1 ) // Ordena por user ID //

	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf

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
	oReport := TReport():New(cNome,"Booking de " + substr(DTOS(MV_PAR01),7,2) + "/" + substr(DTOS(MV_PAR01),5,2) + "/" + substr(DTOS(MV_PAR01),1,4) ;
										+ " ate " + substr(DTOS(MV_PAR02),7,2) + "/" + substr(DTOS(MV_PAR02),5,2) + "/" + substr(DTOS(MV_PAR02),1,4), ;
										cNome,{|oReport| ReportPrint(oReport)},"Descricao do meu relatorio")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=6
	//oReport:cFontBody:="Calibri"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.

	//Monstando a primeira se��o
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"CTD"}, 		, .F.	, 	.F.)
	//TRCell():New(oSection1,"TMP_MESANO",	"TRBSGC",	"Mes/Ano"  		,"@!"	,	20)
	//TRCell():New(oSection1,"TMP_TIPO",		"TRBSGC",	"Tipo" 			,"@!"	,	4)

	//A segunda se��o,
	oSection2:= TRSection():New(oReport, "Booking de " + DTOS(MV_PAR01) + " de " + DTOS(MV_PAR02) , {"CTD"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_CONTRATO"	,"TRBSGC","Contrato"										,"@!"				,22)
	TRCell():New(oSection2,"TMP_DTINI"		,"TRBSGC","Data" + Chr(13) + Chr(10) + "Abertura"			,"@!"				,22)
	TRCell():New(oSection2,"TMP_ADITIVO"	,"TRBSGC","Adit."											,"@!"				,8,,,,,"CENTER")
	//TRCell():New(oSection2,"TMP_DTFIM"		,"TRBSGC","Prev.Entrega"		,"@!"				,22)
	TRCell():New(oSection2,"TMP_NONCLI"		,"TRBSGC","Cliente"											,"@!"				,60,,,,,"LEFT",.T.)
	TRCell():New(oSection2,"TMP_OPUNIT"		,"TRBSGC","Descritivo"										,"@!"				,45,,,,,"LEFT",.T.) 
	TRCell():New(oSection2,"TMP_PAIS"		,"TRBSGC","Pais"											,"@!"				,10,,,,,"CENTER")
	TRCell():New(oSection2,"TMP_XVDCI"		,"TRBSGC","Venda" + Chr(13) + Chr(10) + "c/Trib."			,"@E 999,999,999.99",22,,,,,"CENTER")
	TRCell():New(oSection2,"TMP_XVDSI"		,"TRBSGC","Venda" + Chr(13) + Chr(10) + "s/Trib."			,"@E 999,999,999.99",22,,,,,"CENTER")
	TRCell():New(oSection2,"TMP_CUSTOPR"    ,"TRBSGC","Custo" + Chr(13) + Chr(10) + "Prod."				,"@E 999,999,999.99",22,,,,,"CENTER")
	TRCell():New(oSection2,"TMP_COGS"    	,"TRBSGC","COGS"											,"@E 999,999,999.99",22,,,,,"CENTER")
	TRCell():New(oSection2,"TMP_MGCONTR"	,"TRBSGC","Margem" + Chr(13) + Chr(10) + "Contrib."			,"@E 999,999.99"	,22,,,,,"CENTER")
	TRCell():New(oSection2,"TMP_XPCOM"		,"TRBSGC","%" 	   + Chr(13) + Chr(10) + "Comis."			,"@E 999.99"		,22,,,,,"CENTER")
	TRCell():New(oSection2,"TMP_XVCOM"    	,"TRBSGC","Vlr"    + Chr(13) + Chr(10) + "Comis."			,"@E 999,999,999.99",22,,,,,"CENTER")
	TRCell():New(oSection2,"TMP_MERCADO"	,"TRBSGC","Mercado"											,"@!"				,16,,,,,"CENTER")
	
	oBreak1 := TRBreak():New(oSection2,{|| (TRBSGC->TMP_MESANO) },"",.F.)
	TRFunction():New(oSection2:Cell("TMP_XVDSI")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_XVDCI")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_XVDSI")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_CUSTOPR")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_COGS")		,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_XVCOM")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)

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
	Local dData		:= date()

	//msginfo ( dtos(dData) )
	oSection2:SetHeaderSection(.T.)
	PswOrder( 1 ) // Ordena por user ID //

	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf

	//Monto minha consulta conforme parametros passado

	/*cQuery := " SELECT SUBSTRING(CTD_ITEM,1,2) AS 'TMP_TIPO', CTD_ITEM AS 'TMP_CONTRATO', CTD_DTEXIS AS 'TMP_DTINI', SUBSTRING(CTD_DTEXIS,5,2)+'/'+SUBSTRING(CTD_DTEXIS,1,4) AS 'TMP_MESANO', "
	cQuery += "	CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_NONCLI', "
	cQuery += "	CTD_XEQUIP AS 'TMP_OPUNIT',   CTD_XVDCI AS 'TMP_XVDCI', CTD_XVDSI AS 'TMP_XVDSI', CTD_XCUSTO AS 'TMP_CUSTOPR', 
	cQuery += "	(CTD_XCUTOT-(CTD_XSISFV*(CTD_XPCOM/100))) AS 'TMP_COGS', CTD_XPCOM AS 'TMP_XPCOM',  (CTD_XSISFV*(CTD_XPCOM/100)) AS 'TMP_XVCOM', CTD_XCUTOT AS 'TMP_CUSTOT', "
	cQuery += "	IIF(CTD_XVDSI=0,0,((CTD_XVDSI-CTD_XCUSTO)/CTD_XVDSI)*100) AS 'TMP_MGBR', "
	cQuery += "	IIF(CTD_XVDSI=0,0,((CTD_XVDSI-CTD_XCUTOT)/CTD_XVDSI)*100) AS 'TMP_MGCONTR', " 
	cQuery += "	IIF(A1_PAIS = '105', 'BR', IIF(A1_PAIS='','NDA','SA')) AS 'TMP_PAIS', " 
	cQuery += "	CTD_DTEXSF AS 'TMP_DTFIM', " 
	cQuery += "	CTD_XADDT AS 'TMP_XADDT'  , CTD_XADCI AS 'TMP_XADCI'  , CTD_XADSI AS 'TMP_XADSI'  , CTD_XADSFR AS 'TMP_XADSFR', "
	cQuery += "	CTD_XADDT2 AS 'TMP_XADDT2', CTD_XADCI2 AS 'TMP_XADCI2', CTD_XADSI3 AS 'TMP_XADSI2', CTD_XADSF4 AS 'TMP_XADSF2', "
	cQuery += "	CTD_XADDT3 AS 'TMP_XADDT3', CTD_XADCI2 AS 'TMP_XADCI3', CTD_XADSI3 AS 'TMP_XADSI3', CTD_XADSF4 AS 'TMP_XADSF3', "
	cQuery += "	CTD_XADDT4 AS 'TMP_XADDT4', CTD_XADCI2 AS 'TMP_XADCI4', CTD_XADSI3 AS 'TMP_XADSI4', CTD_XADSF4 AS 'TMP_XADSF4' "
	cQuery += "	FROM CTD010 " 
	cQuery += "	LEFT JOIN SA1010 ON CTD_XCLIEN = SA1010.A1_COD " 
	cQuery += "	WHERE " 

	IF MV_PAR03 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'AT' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR04 == 1 .OR. MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR04 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'CM' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR05 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EN' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR06 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EQ' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR07 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'GR' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR08 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'PR' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR09 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'ST' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "
	ENDIF

	cQuery += "	ORDER BY SUBSTRING(CTD_DTEXIS,5,2)+'/'+SUBSTRING(CTD_DTEXIS,1,4)+SUBSTRING(CTD_ITEM,1,2) ,CTD_DTEXIS, CTD_ITEM "*/

cQuery := "	SELECT SUBSTRING(CTD_ITEM,1,2) AS 'TMP_TIPO', CTD_ITEM AS 'TMP_CONTRATO', CTD_DTEXIS AS 'TMP_DTINI', SUBSTRING(CTD_DTEXIS,5,2)+'/'+SUBSTRING(CTD_DTEXIS,1,4) AS 'TMP_MESANO',  "
cQuery += "CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_NONCLI',  "
cQuery += "CTD_XEQUIP AS 'TMP_OPUNIT', '' AS 'TMP_ADITIVO',  CTD_XVDCI AS 'TMP_XVDCI', CTD_XVDSI AS 'TMP_XVDSI', CTD_XCUSTO AS 'TMP_CUSTOPR',  "
cQuery += "(CTD_XCUTOT-(CTD_XSISFV*(CTD_XPCOM/100))) AS 'TMP_COGS', CTD_XPCOM AS 'TMP_XPCOM',  (CTD_XSISFV*(CTD_XPCOM/100)) AS 'TMP_XVCOM', CTD_XCUTOT AS 'TMP_CUSTOT',  "
cQuery += "IIF(CTD_XVDSI=0,0,((CTD_XVDSI-CTD_XCUSTO)/CTD_XVDSI)*100) AS 'TMP_MGBR',  "
cQuery += "IIF(CTD_XVDSI=0,0,((CTD_XVDSI-CTD_XCUTOT)/CTD_XVDSI)*100) AS 'TMP_MGCONTR',  "
cQuery += "IIF(A1_PAIS = '105', 'BR', IIF(A1_PAIS='','NDA','SA')) AS 'TMP_PAIS',  " 
cQuery += "CTD_DTEXSF AS 'TMP_DTFIM',  "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=1,'MINERACAO', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=2,'CELULOSE', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=3,'QUIMICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=4,'METALURGICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=5,'SIDERURGICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=6,'MUNICIPAL', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=7,'PETROQUIMICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=8,'ALIMENTOS', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=9,'OUTROS', "
cQuery += "'S/PROP.VINCULADA'))))))))) AS 'TMP_MERCADO' "
cQuery += "FROM CTD010  "
cQuery += "LEFT JOIN SA1010 ON CTD_XCLIEN = SA1010.A1_COD  "
cQuery += "WHERE "
IF MV_PAR03 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'AT' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR04 == 1 .OR. MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR04 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'CM' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR05 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EN' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR06 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EQ' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR07 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'GR' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR08 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'PR' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR09 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'ST' "
		cQuery += "	AND CTD_DTEXIS >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_DTEXIS <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "
	ENDIF 
//--UNION ADITVO 1 
cQuery += " UNION ALL "
cQuery += " SELECT SUBSTRING(CTD_ITEM,1,2) AS 'TMP_TIPO', CTD_ITEM AS 'TMP_CONTRATO', CTD_XADDT AS 'TMP_DTINI', SUBSTRING(CTD_XADDT,5,2)+'/'+SUBSTRING(CTD_XADDT,1,4) AS 'TMP_MESANO',  "
cQuery += " CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_NONCLI', CTD_XEQUIP AS 'TMP_OPUNIT',  'S' AS 'TMP_ADITIVO',  "
cQuery += " CTD_XADCI AS 'TMP_XVDCI',  "
cQuery += " CTD_XADSI AS 'TMP_XVDSI',  "
cQuery += " CTD_XADCP1 AS 'TMP_CUSTOPR', " 
cQuery += " (CTD_XADCT1-(CTD_XADSFR*(CTD_XPCOM/100))) AS 'TMP_COGS',  "
cQuery += " CTD_XPCOM AS 'TMP_XPCOM',  "
cQuery += " (CTD_XADSFR*(CTD_XPCOM/100)) AS 'TMP_XVCOM',  "
cQuery += " CTD_XADCT1 AS 'TMP_CUSTOT',  "
cQuery += " IIF(CTD_XADSI=0,0,((CTD_XADSI-CTD_XADCP1)/CTD_XADSI)*100) AS 'TMP_MGBR',  "
cQuery += " IIF(CTD_XADSI=0,0,((CTD_XADSI-CTD_XADCT1)/CTD_XADSI)*100) AS 'TMP_MGCONTR', " 
cQuery += " IIF(A1_PAIS = '105', 'BR', IIF(A1_PAIS='','NDA','SA')) AS 'TMP_PAIS',   "
cQuery += " CTD_DTEXSF AS 'TMP_DTFIM',  "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=1,'MINERACAO', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=2,'CELULOSE', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=3,'QUIMICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=4,'METALURGICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=5,'SIDERURGICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=6,'MUNICIPAL', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=7,'PETROQUIMICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=8,'ALIMENTOS', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=9,'OUTROS', "
cQuery += "'S/PROP.VINCULADA'))))))))) AS 'TMP_MERCADO' "
cQuery += " FROM CTD010  "
cQuery += " LEFT JOIN SA1010 ON CTD_XCLIEN = SA1010.A1_COD  "
cQuery += " WHERE "
IF MV_PAR03 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'AT' "
		cQuery += "	AND CTD_XADDT >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR04 == 1 .OR. MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR04 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'CM' "
		cQuery += "	AND CTD_XADDT >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR05 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EN' "
		cQuery += "	AND CTD_XADDT >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR06 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EQ' "
		cQuery += "	AND CTD_XADDT >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR07 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'GR' "
		cQuery += "	AND CTD_XADDT >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR08 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'PR' "
		cQuery += "	AND CTD_XADDT >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR09 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'ST' "
		cQuery += "	AND CTD_XADDT >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "
	ENDIF 
//--UNION ADITVO 2
cQuery += "	UNION ALL "
cQuery += "	SELECT SUBSTRING(CTD_ITEM,1,2) AS 'TMP_TIPO', CTD_ITEM AS 'TMP_CONTRATO', CTD_XADDT2 AS 'TMP_DTINI', SUBSTRING(CTD_XADDT2,5,2)+'/'+SUBSTRING(CTD_XADDT2,1,4) AS 'TMP_MESANO',  "
cQuery += "	CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_NONCLI', CTD_XEQUIP AS 'TMP_OPUNIT',  'S' AS 'TMP_ADITIVO',  "
cQuery += "	CTD_XADCI2 AS 'TMP_XVDCI',  "
cQuery += "	CTD_XADSI2 AS 'TMP_XVDSI',  "
cQuery += "	CTD_XADCP2 AS 'TMP_CUSTOPR',  "
cQuery += "	(CTD_XADCT2-(CTD_XADSF2*(CTD_XPCOM/100))) AS 'TMP_COGS',  "
cQuery += "	CTD_XPCOM AS 'TMP_XPCOM',  "
cQuery += "	(CTD_XADSF2*(CTD_XPCOM/100)) AS 'TMP_XVCOM',  "
cQuery += "	CTD_XADCT2 AS 'TMP_CUSTOT',  "
cQuery += "	IIF(CTD_XADSI2=0,0,((CTD_XADSI2-CTD_XADCP2)/CTD_XADSI2)*100) AS 'TMP_MGBR',  "
cQuery += "	IIF(CTD_XADSI2=0,0,((CTD_XADSI2-CTD_XADCT2)/CTD_XADSI2)*100) AS 'TMP_MGCONTR', " 
cQuery += "	IIF(A1_PAIS = '105', 'BR', IIF(A1_PAIS='','NDA','SA')) AS 'TMP_PAIS',   "
cQuery += "	CTD_DTEXSF AS 'TMP_DTFIM', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=1,'MINERACAO', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=2,'CELULOSE', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=3,'QUIMICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=4,'METALURGICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=5,'SIDERURGICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=6,'MUNICIPAL', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=7,'PETROQUIMICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=8,'ALIMENTOS', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=9,'OUTROS', "
cQuery += "'S/PROP.VINCULADA'))))))))) AS 'TMP_MERCADO' "
cQuery += "	FROM CTD010  "
cQuery += "	LEFT JOIN SA1010 ON CTD_XCLIEN = SA1010.A1_COD  "
cQuery += "	WHERE "
IF MV_PAR03 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'AT' "
		cQuery += "	AND CTD_XADDT2 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT2 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR04 == 1 .OR. MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR04 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'CM' "
		cQuery += "	AND CTD_XADDT2 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT2 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR05 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EN' "
		cQuery += "	AND CTD_XADDT2 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT2 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR06 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EQ' "
		cQuery += "	AND CTD_XADDT2 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT2 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR07 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'GR' "
		cQuery += "	AND CTD_XADDT2 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT2 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR08 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'PR' "
		cQuery += "	AND CTD_XADDT2 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT2 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR09 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'ST' "
		cQuery += "	AND CTD_XADDT2 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT2 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "
	ENDIF 
//--UNION ADITVO 3
cQuery += "	UNION ALL "
cQuery += "	SELECT SUBSTRING(CTD_ITEM,1,2) AS 'TMP_TIPO', CTD_ITEM AS 'TMP_CONTRATO', CTD_XADDT3 AS 'TMP_DTINI', SUBSTRING(CTD_XADDT3,5,2)+'/'+SUBSTRING(CTD_XADDT3,1,4) AS 'TMP_MESANO',  "
cQuery += "	CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_NONCLI', CTD_XEQUIP AS 'TMP_OPUNIT',  'S' AS 'TMP_ADITIVO',  "
cQuery += "	CTD_XADCI3 AS 'TMP_XVDCI',  "
cQuery += "	CTD_XADSI3 AS 'TMP_XVDSI',  "
cQuery += "	CTD_XADCP3 AS 'TMP_CUSTOPR',  "
cQuery += "	(CTD_XADCT3-(CTD_XADSF3*(CTD_XPCOM/100))) AS 'TMP_COGS',  "
cQuery += "	CTD_XPCOM AS 'TMP_XPCOM',  "
cQuery += "	(CTD_XADSF3*(CTD_XPCOM/100)) AS 'TMP_XVCOM',  "
cQuery += " CTD_XADCT3 AS 'TMP_CUSTOT',  "
cQuery += "	IIF(CTD_XADSI3=0,0,((CTD_XADSI3-CTD_XADCP3)/CTD_XADSI3)*100) AS 'TMP_MGBR',  "
cQuery += "	IIF(CTD_XADSI3=0,0,((CTD_XADSI3-CTD_XADCT3)/CTD_XADSI3)*100) AS 'TMP_MGCONTR', " 
cQuery += "	IIF(A1_PAIS = '105', 'BR', IIF(A1_PAIS='','NDA','SA')) AS 'TMP_PAIS',   "
cQuery += "	CTD_DTEXSF AS 'TMP_DTFIM', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=1,'MINERACAO', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=2,'CELULOSE', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=3,'QUIMICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=4,'METALURGICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=5,'SIDERURGICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=6,'MUNICIPAL', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=7,'PETROQUIMICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=8,'ALIMENTOS', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=9,'OUTROS', "
cQuery += "'S/PROP.VINCULADA'))))))))) AS 'TMP_MERCADO' "
cQuery += "	FROM CTD010  "
cQuery += "	LEFT JOIN SA1010 ON CTD_XCLIEN = SA1010.A1_COD  "
cQuery += "	WHERE "
IF MV_PAR03 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'AT' "
		cQuery += "	AND CTD_XADDT3 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT3 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR04 == 1 .OR. MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR04 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'CM' "
		cQuery += "	AND CTD_XADDT3 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT3 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR05 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EN' "
		cQuery += "	AND CTD_XADDT3 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT3 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR06 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EQ' "
		cQuery += "	AND CTD_XADDT3 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT3 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR07 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'GR' "
		cQuery += "	AND CTD_XADDT3 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT3 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR08 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'PR' "
		cQuery += "	AND CTD_XADDT3 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT3 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR09 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'ST' "
		cQuery += "	AND CTD_XADDT3 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT3 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "
	ENDIF 
//--UNION ADITVO 4
cQuery += "	UNION ALL "
cQuery += "	SELECT SUBSTRING(CTD_ITEM,1,2) AS 'TMP_TIPO', CTD_ITEM AS 'TMP_CONTRATO', CTD_XADDT4 AS 'TMP_DTINI', SUBSTRING(CTD_XADDT4,5,2)+'/'+SUBSTRING(CTD_XADDT4,1,4) AS 'TMP_MESANO',  "
cQuery += "	CTD_XCLIEN AS 'TMP_CODCLI', CTD_XNREDU AS 'TMP_NONCLI', CTD_XEQUIP AS 'TMP_OPUNIT',  'S' AS 'TMP_ADITIVO',  "
cQuery += "	CTD_XADCI4 AS 'TMP_XVDCI',  "
cQuery += "	CTD_XADSI4 AS 'TMP_XVDSI',  "
cQuery += "	CTD_XADCP4 AS 'TMP_CUSTOPR',  "
cQuery += "	(CTD_XADCT4-(CTD_XADSF4*(CTD_XPCOM/100))) AS 'TMP_COGS',  "
cQuery += "	CTD_XPCOM AS 'TMP_XPCOM',  "
cQuery += "	(CTD_XADSF4*(CTD_XPCOM/100)) AS 'TMP_XVCOM',  "
cQuery += "	CTD_XADCT4 AS 'TMP_CUSTOT',  "
cQuery += "	IIF(CTD_XADSI4=0,0,((CTD_XADSI4-CTD_XADCP4)/CTD_XADSI4)*100) AS 'TMP_MGBR',  "
cQuery += "	IIF(CTD_XADSI4=0,0,((CTD_XADSI4-CTD_XADCT4)/CTD_XADSI4)*100) AS 'TMP_MGCONTR', " 
cQuery += "	IIF(A1_PAIS = '105', 'BR', IIF(A1_PAIS='','NDA','SA')) AS 'TMP_PAIS',   "
cQuery += "	CTD_DTEXSF AS 'TMP_DTFIM', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=1,'MINERACAO', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=2,'CELULOSE', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=3,'QUIMICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=4,'METALURGICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=5,'SIDERURGICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=6,'MUNICIPAL', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=7,'PETROQUIMICA', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=8,'ALIMENTOS', "
cQuery += "IIF(SUBSTRING(CTD_NPROP,8,1)=9,'OUTROS', "
cQuery += "'S/PROP.VINCULADA'))))))))) AS 'TMP_MERCADO' "
cQuery += "	FROM CTD010  "
cQuery += "	LEFT JOIN SA1010 ON CTD_XCLIEN = SA1010.A1_COD  "
cQuery += "	WHERE "
IF MV_PAR03 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'AT' "
		cQuery += "	AND CTD_XADDT4 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT4 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR04 == 1 .OR. MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR04 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'CM' "
		cQuery += "	AND CTD_XADDT4 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT4 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF MV_PAR05 == 1 .OR. ;
			MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR05 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EN' "
		cQuery += "	AND CTD_XADDT4 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT4 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR06 == 1 .OR. MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR06 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'EQ' "
		cQuery += "	AND CTD_XADDT4 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT4 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR07 == 1 .OR. MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR07 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'GR' "
		cQuery += "	AND CTD_XADDT4 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT4 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR08 == 1 .OR. MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR08 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'PR' "
		cQuery += "	AND CTD_XADDT4 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT4 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "

		IF  MV_PAR09 == 1
			cQuery += "	OR "
		ELSE
			cQuery += "	"
		ENDIF
	ENDIF

	IF MV_PAR09 == 1
		cQuery += "	CTD010.D_E_L_E_T_ <> '*' AND SA1010.D_E_L_E_T_ <> '*' "
		cQuery += "	AND CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','OPERACOES') "
		cQuery += "	AND SUBSTRING(CTD_ITEM,1,2) = 'ST' "
		cQuery += "	AND CTD_XADDT4 >= '" + DTOS(MV_PAR01) + "' "
		cQuery += "	AND CTD_XADDT4 <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) >= '" + MV_PAR10 + "' "
		cQuery += "	AND SUBSTRING(CTD_ITEM,12,2) <= '" + MV_PAR11 + "' "
	ENDIF 

	cQuery += "		ORDER BY 3 ,2 "


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

		//inicializo a primeira se��o
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBSGC->TMP_MESANO
		cTipo 	:= TRBSGC->TMP_TIPO
		IncProc("Imprimindo Booking"+alltrim(TRBSGC->TMP_MESANO))

		//imprimo a primeira se��o
		//oSection1:Cell("TMP_MESANO"):SetValue(TRBSGC->TMP_MESANO)
		//oSection1:Cell("TMP_TIPO"):SetValue(TRBSGC->TMP_TIPO)
		//oSection1:Printline()

		//inicializo a segunda se��o
		oSection2:init()

		//verifico se o codigo da NCM � mesmo, se sim, imprimo o produto
		While TRBSGC->TMP_MESANO == cNcm //.AND. TRBSGC->TMP_TIPO  == cTipo
			oReport:IncMeter()

			IncProc("Imprimindo Booking "+alltrim(TRBSGC->TMP_MESANO))

			oSection2:Cell("TMP_CONTRATO"):SetValue(TRBSGC->TMP_CONTRATO)

			IF TMP_DTINI = ""
				oSection2:Cell("TMP_DTINI"):SetValue("")
			ELSE
				oSection2:Cell("TMP_DTINI"):SetValue(Substr(TRBSGC->TMP_DTINI,7,2) + "/" + Substr(TRBSGC->TMP_DTINI,5,2) + "/" + Substr(TRBSGC->TMP_DTINI,1,4))
			ENDIF
			oSection2:Cell("TMP_ADITIVO"):SetValue(TRBSGC->TMP_ADITIVO)

			oSection2:Cell("TMP_NONCLI"):SetValue(TRBSGC->TMP_NONCLI)
			oSection2:Cell("TMP_OPUNIT"):SetValue(TRBSGC->TMP_OPUNIT)

			oSection2:Cell("TMP_XVDCI"):SetValue(TRBSGC->TMP_XVDCI)
			oSection2:Cell("TMP_XVDCI"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_XVDSI"):SetValue(TRBSGC->TMP_XVDSI)
			oSection2:Cell("TMP_XVDSI"):SetAlign("RIGHT")

			oSection2:Cell("TMP_CUSTOPR"):SetValue(TRBSGC->TMP_CUSTOPR)
			oSection2:Cell("TMP_CUSTOPR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_CUSTOPR"):SetValue(TRBSGC->TMP_CUSTOPR)
			oSection2:Cell("TMP_CUSTOPR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_COGS"):SetValue(TRBSGC->TMP_COGS)
			oSection2:Cell("TMP_COGS"):SetAlign("RIGHT")
		
			oSection2:Cell("TMP_MGCONTR"):SetValue(TRBSGC->TMP_MGCONTR)
			oSection2:Cell("TMP_MGCONTR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_XPCOM"):SetValue(TRBSGC->TMP_XPCOM)
			oSection2:Cell("TMP_XPCOM"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_XVCOM"):SetValue(TRBSGC->TMP_XVCOM)
			oSection2:Cell("TMP_XVCOM"):SetAlign("RIGHT")

			oSection2:Cell("TMP_MERCADO"):SetValue(TRBSGC->TMP_MERCADO)
			
						/*
			IF TMP_DTFIM = ""
				oSection2:Cell("TMP_DTFIM"):SetValue("")
			ELSE
				oSection2:Cell("TMP_DTFIM"):SetValue(Substr(TRBSGC->TMP_DTFIM,7,2) + "/" + Substr(TRBSGC->TMP_DTFIM,5,2) + "/" + Substr(TRBSGC->TMP_DTFIM,1,4))
			ENDIF
			*/
			oSection2:Cell("TMP_PAIS"):SetValue(TRBSGC->TMP_PAIS)

			oSection2:Printline()

 			TRBSGC->(dbSkip())
 		EndDo
 		//finalizo a segunda se��o para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira se��o
		oSection1:Finish()
	Enddo
Return
///////////////////////////////////////////////

static function VldParamB2()

	if empty(MV_PAR01) .or. empty(MV_PAR02)  // Alguma data vazia
		msgstop("Todas as datas dos parametros devem ser informadas.")
		return(.F.)
	endif

	if empty(MV_PAR03)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Assistencia Tecnica")
		return(.F.)
	endif

	if empty(MV_PAR04)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Comissao")
		return(.F.)
	endif

	if empty(MV_PAR05)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Engenharia")
		return(.F.)
	endif

	if empty(MV_PAR06)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Engenharia")
		return(.F.)
	endif

	if empty(MV_PAR07)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Garantia")
		return(.F.)
	endif

	if empty(MV_PAR08)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Peca")
		return(.F.)
	endif

	if empty(MV_PAR08)  // Data de inicio maior que data de referencia
		msgstop("Deve ser informado Sim ou Nao no parametro Sistema")
		return(.F.)
	endif

	if MV_PAR03 == 2 .AND. MV_PAR04 == 2 .AND. MV_PAR05 == 2 .AND. MV_PAR06 == 2 .AND. MV_PAR07 == 2 .AND. MV_PAR08 == 2 .AND. MV_PAR09 == 2
		msgstop("Deve ser informado pelo menos um tipo de Contrato como Sim")
		return(.F.)
	endif

return(.T.)

///////////////////////////////////////////////

static function ajustaSx1(cPerg)
	//Aqui utilizo a fun��o putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Data Abertura de?"  			, "", "", "mv_ch1", "D", 08, 0, 0, "G", "", "", "", "", "mv_par01")
	putSx1(cPerg, "02", "Data Abertura ate?" 			, "", "", "mv_ch2", "D", 08, 0, 0, "G", "", "", "", "", "mv_par02")
	PutSX1(cPerg, "03", "Assistencia Tecnica (AT)"		, "", "", "mv_ch3", "N", 01, 0, 0, "C", "", "", "", "", "mv_par03","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "04", "Comissao (CM)"					, "", "", "mv_ch4", "N", 01, 0, 0, "C", "", "", "", "", "mv_par04","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "05", "Engenharia (EN)"				, "", "", "mv_ch5", "N", 01, 0, 0, "C", "", "", "", "", "mv_par05","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "06", "Equipamento (EQ)"				, "", "", "mv_ch6", "N", 01, 0, 0, "C", "", "", "", "", "mv_par06","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "07", "Garantia (GR)"					, "", "", "mv_ch7", "N", 01, 0, 0, "C", "", "", "", "", "mv_par07","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "08", "Peca (PR)"						, "", "", "mv_ch8", "N", 01, 0, 0, "C", "", "", "", "", "mv_par08","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg, "09", "Sistema (ST)"					, "", "", "mv_ch9", "N", 01, 0, 0, "C", "", "", "", "", "mv_par09","Sim","","","","Nao","","","","","","","","","","","")
	putSx1(cPerg, "10", "Sequencial Job de?"  			, "", "", "mv_ch10","C", 02, 0, 0, "G", "", "", "", "", "mv_par10")
	putSx1(cPerg, "11", "Sequencial Job ate?" 			, "", "", "mv_ch11","C", 02, 0, 0, "G", "", "", "", "", "mv_par11")
return



