#Include "Totvs.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³CRTMK01 ºAutor  ³Renato Ruy Bernardo	  º Data ³  11/05/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Atendimento do Fiscal.				          º±±
±±º          ³		                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign - Service Desk		                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRTMK02()
Local 	nVarLen	:=	SetVarNameLen(100)
Local 	oReport
Private cPerg	:= "CRTK02"

Public teste

ValidPerg()

Pergunte(cPerg,.F.)
oReport := ReportDef()
oReport:PrintDialog()


SetVarNameLen(nVarLen)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³CRTMK01 ºAutor  ³Renato Ruy Bernardo	  º Data ³  11/05/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Atendimento do Fiscal.				          º±±
±±º          ³		                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign - Service Desk		                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport
Local oSection
Local oBreak1,oBreak2
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."
cDescricao	+=	"Relatório de atendimentos do Financeiro."


//Objeto do Relatório
oReport	:=	TReport():New("CRTK02","RELATORIO DE REEMBOLSO A CLIENTES (SERVICE DESK)", cPerg, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)

//Seções Contas a Receber, Cliente , Naturezas
oSection	:= TRSection():New(oReport, "Financeiro"	, {"ADE","SU9","SE2","SX5"})


/*/Define a Ordem
TROrder():New(oParent  , uOrder  , cTitle                        	, cAlias  ) */
//TROrder():New(oSection, "" 		, "Matricula x Salario" 			,         )



//Celulas de Impressão - ADF- Lista Atendimento
TRCell():New(oSection, "ADE_FILIAL"			, "ADE", "Filial"				,							,02)
TRCell():New(oSection, "ADE_CODIGO"			, "ADF", "Protocolo"			,							,06)
TRCell():New(oSection, "E2_PREFIXO" 		, "SE2", "Prefixo"				,							,03)
TRCell():New(oSection, "E2_NUM" 			, "SE2", "Título"				,							,09)
TRCell():New(oSection, "E2_PARCELA"	 	 	, "SE2", "Parcela"				,							,02)
TRCell():New(oSection, "E2_VALOR"	   		, "SE2", "Valor"				,"@E 999,999.99"			,15)
TRCell():New(oSection, "E2_TIPO"	   		, "SE2", "Tipo"					,							,03)
TRCell():New(oSection, "E2_HIST"	   		, "SE2", "Histórico"			,							,25)
TRCell():New(oSection, "E2_EMISSAO"			, "SE2", "Dt.Emissão"			,"@D"						,08)
TRCell():New(oSection, "E2_VENCREA"			, "SE2", "Dt.Vencto."			,"@D"						,08)
TRCell():New(oSection, "E2_FORNECE"			, "SE2", "Cod.Forn."			,							,06)
TRCell():New(oSection, "A2_NOME"			, "SA2", "Razão Social"			,							,40)

//Total Geral
TRFunction():New(oSection:Cell("E2_VALOR")	,,"SUM",, "Total Geral ==>",	,	,	.F.,	.T. , .F.)

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LCRCO003  ºAutor  ³Renato Ruy Bernardoº Data ³ 09/04/2012   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados a serem impressos                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Locar                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrintReport(oReport)
Local oSection		:= oReport:Section(1)
Local oBreak        := Nil
Local cCpoBreak		:= ""
Local cDescBreak	:= ""
Local nOrdem		:= oSection:GetOrder()
Local cOrdem		:= ""

//Transforma parâmetros do tipo Range em expressão SQL para ser utilizadana query.
MakeSqlExpr(cPerg)

oSection:BeginQuery()
BeginSql Alias "QCRTMK002"
	Column E2_EMISSAO	As Date
	Column E2_VENCREA	As Date

	SELECT
	ADE_FILIAL,
	ADE_CODIGO,
	E2_PREFIXO,
	E2_NUM,
	E2_TIPO,
	E2_HIST,
	E2_PARCELA,
	E2_VALOR,
	E2_EMISSAO,
	E2_VENCREA,
	E2_FORNECE,
	A2_NOME
	FROM %Table:SE2% SE2
	LEFT JOIN %Table:SA2% SA2 ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2.D_E_L_E_T_ = ' '
	LEFT JOIN %Table:ADE% ADE ON E2_FILORIG = ADE_FILIAL AND TRIM(ADE_PEDGAR) = TO_CHAR(TO_NUMBER(E2_NUM)) AND ADE.D_E_L_E_T_ = ' '
	WHERE
	E2_FILIAL = '  ' AND
	E2_TIPO = 'DEV' AND
	E2_VENCTO Between %Exp:Mv_Par01% and %Exp:Mv_Par02% and
	SUBSTR(E2_HIST,1,14) = 'Reembolso GAR:' AND
	SE2.D_E_L_E_T_ = ' ' AND
	ADE_GRUPO = %Exp:Mv_Par03%
	Order by E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA
	
EndSql
oSection:EndQuery()

//Imprime
oSection:Print()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³CRTMK01 ºAutor  ³Renato Ruy Bernardo	  º Data ³  11/05/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Atendimento do Fiscal.				          º±±
±±º          ³		                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign - Service Desk		                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Data de ?"		   		,"Data de ?"		   		,"Data de ?"		   		,"mv_ch1" 	,"D" 		,08     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"Data Até ?"   	  		,"Data Até ?"   	  		,"Data Até ?"   	  		,"mv_ch2" 	,"D" 		,08     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"Equipe ?"		   			,"Equipe ?"			   		,"Equipe ?"		   			,"mv_ch3" 	,"C" 		,02     		,0      		,0     		,"G"		,""          ,"SX0REL"  ,""         ,"S"        ,"mv_par03"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)


Return
