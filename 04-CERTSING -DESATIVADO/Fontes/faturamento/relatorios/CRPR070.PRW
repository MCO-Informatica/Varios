#Include "Totvs.ch"
//#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³CRPR070 ºAutor  ³Renato Ruy Bernardo    º Data ³  04/12/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Remuneração de Parceiros.			          º±±
±±º          ³* Postos                                                    º±±
±±º          ³* AC	                                                      º±±
±±º          ³* CANAL                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign - Faturamento		                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRPR070()
Local 	nVarLen	:=	SetVarNameLen(100)
Local 	oReport
Private cPerg	:= "CRPR70"

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
±±ºPrograma ³ReportDef ºAutor  ³Renato Ruy Bernardo	  º Data ³  04/12/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definições do Relatório                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport
Local oSection
Local oBreak1,oBreak2
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."
cDescricao	+=	"Relação de número de notas fiscais não faturados no range especificado."


//Objeto do Relatório
oReport	:=	TReport():New("CRPR70","Relatorio de Remuneração de Parceiros", cPerg, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)
oReport:lHeaderVisible := .T.

//Seções Contas a Receber, Cliente , Naturezas
oSection	:= TRSection():New(oReport, "Remuneração"	, {"SZ6"})
//Celulas de Impressão - SZ6 - Movimentos de Remuneração

TRCell():New(oSection, "Z6_CODENT"				, "SZ6", "Código Entidade"		,							,06)
TRCell():New(oSection, "Z6_DESENT"			 	, "SZ6", "Descrição Entidade"	,							,100)
TRCell():New(oSection, "Z6_CODVEND"			 	, "SZ6", "Cod.Vendedor"			,							,30)
TRCell():New(oSection, "Z6_NOMVEND"			 	, "SZ6", "Nome Vendedor"		,							,100)
TRCell():New(oSection, "Z6_NOMEAGE"				, "SZ6", "Desc. Agente Val."	,							,100)
TRCell():New(oSection, "Z6_PRODUTO"				, "SZ6", "Cod. Produto"			,							,30)
TRCell():New(oSection, "Z6_DESCRPR"				, "SZ6", "Desc.Produto"			,							,100)
TRCell():New(oSection, "Cd_Pedido"				, "SZ6", "Pedido"				,							,07) 
TRCell():New(oSection, "STATPED" 				, "SZ6", "Status Pedido"		,							,20)
TRCell():New(oSection, "Z6_DTPEDI"				, "SZ6", "Dt.Pedido"			,"@D"						,08)
TRCell():New(oSection, "Z6_VALIDA"				, "SZ6", "Dt.Validação"			,"@D"						,08)
TRCell():New(oSection, "Z6_VERIFIC"				, "SZ6", "Dt.Verificação"		,"@D"						,08)
TRCell():New(oSection, "Z6_DTEMISS"				, "SZ6", "Dt.Emissão/Renovação"	,"@D"						,08)
TRCell():New(oSection, "Z6_NTITULA" 			, "SZ6", "Nome Cliente"			,							,100) 
TRCell():New(oSection, "ZH_DESCRI"				, "SZ6", "Tipo Voucher"			,							,30)
TRCell():New(oSection, "PEDANT"					, "SZ6", "Ped. Anterior"		,							,07)
TRCell():New(oSection, "DT_PEDANT"				, "SZ6", "Dt.Pedido Anterior"	,"@D"						,08)
//TRCell():New(oSection, "Z6_CCRCOM"				, "SZ6", "Desc. CCR"			,							,100)
TRCell():New(oSection, "Z6_CODAC"		  		, "SZ6", "Cód. AC"				,							,06)
TRCell():New(oSection, "Z6_DESGRU"				, "SZ6", "Desc. Grupo"			,							,100)
TRCell():New(oSection, "Z6_DESREDE"				, "SZ6", "Link"					,							,128)
TRCell():New(oSection, "VALOR_PRODUTO"			, "SZ6", "Val. Bruto"			, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "BASE_COMISSAO"			, "SZ6", "Val. Faturamento"		, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "VALOR_COMISSAO"			, "SZ6", "Valor Tot. Comiss."	, "@E 999.999.999,99"		,15) 
TRCell():New(oSection, "CONT_CER"				, "QCRPR070", "Contador"		, "@E 999.999.999"			,15) 


//oSection:HideHeader(.T.)
//oSection:SetLineBreak()
//oSection:SetHeaderPage()
//oSection::SetHeaderBreak(.T.)

//Total Geral
TRFunction():New(oSection:Cell("CD_PEDIDO"),,"COUNT",, "Certificados Verificados ==>",	,	,	.F.,	.T. , .F.)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PrintReportºAutor  ³Renato Ruy Bernardoº Data ³ 09/04/2012   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados a serem impressos                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
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
//Local nQuant		:= (Val(Mv_par03)-Val(Mv_par02))+1
//Local nNota			:= Val(Mv_par02)
Local cWhere		:= "%  %"
Local cWhere2		:= "%  %"
Private nTotal		:= 0

If 	   MV_PAR06 == 1
	cWhere := "7"
Else
	cWhere := "10"
EndIf

If 	   MV_PAR07 == 2
	cOrdem := "%Z6_CODENT%"
	cWhere2:= "ICP"
Else
	cOrdem := "%Z6_DESREDE%"
	cWhere2:= "ZZZ"
EndIf

//Transforma parâmetros do tipo Range em expressão SQL para ser utilizadana query.
MakeSqlExpr(cPerg)

oSection:BeginQuery()

If 	   MV_PAR06 == 1
	BeginSql Alias "QCRPR070"
		Column Z6_DTPEDI	As Date
		Column Z6_VERIFIC	As Date
		Column Z6_VALIDA	As Date
		Column Z6_DTEMISS	As Date
		Column Z6_DTPGTO	As Date
		Column DT_PEDANT	As Date
		
		%NoParser%
		
		
		SELECT
		Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		Z6_CODENT ,
		Z6_DESENT,
		CASE
	    WHEN Z6_PEDGAR   = ' ' THEN 'HARWARE AVULSO' 
	    WHEN Z5_DATVER  != ' ' AND Z6_VALCOM = 0 THEN 'PAGO ANTERIORMENTE'
	    WHEN Z6_PEDORI  != ' ' THEN 'RENOVACAO'
	    WHEN Z6_VERIFIC != ' ' THEN 'VERIFICACAO'
	    END STATPED,
	    CASE
	    WHEN Z5_DATVER  != ' ' THEN 0
	    ELSE 1
	    END CONT_CER,
		Z6_TPENTID,
		Z6_PRODUTO,
		Z6_DESCRPR,
		Z6_DTPEDI,
		Z6_VERIFIC,
		Z6_VALIDA,
		Z6_DTEMISS,
		Z6_CODVEND,
		Z6_NOMVEND,
		Z6_RECORI,
		Z6_PEDORI,
		Z6_CODCCR, 
		(SELECT Z3_DESENT FROM PROTHEUS.SZ3010 WHERE Z3_FILIAL = ' ' AND Z3_CODENT = (SZ6.Z6_CODCCR) AND Z3_TIPENT = '9' AND D_E_L_E_T_ = ' ') Z6_CCRCOM,
		Z6_CODAC,
		Z6_PEDSITE,
		Z6_PEDGAR,
		Case When Z6_PEDSITE = ' ' then Z6_PEDGAR Else Z6_PEDSITE End Cd_Pedido,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Case when Z6_PEDORI != ' ' Then Z6_PEDORI Else ZF_PEDIDO End PEDANT,
	 	Case when Z6_TIPO = 'ENTHAR' AND Z6_VALCOM = 0 THEN Z5_EMISSAO when Z6_PEDORI > '0' AND Z6_VALCOM = 0 THEN (SELECT MAX(Z5_DATEMIS) FROM PROTHEUS.SZ5010 SZ56 WHERE Z5_FILIAL = ' ' AND Z5_PEDGAR > '0' AND Z5_PEDGAR = SZ6.Z6_PEDORI AND D_E_L_E_T_ = ' ') WHEN  Z6_VALCOM = 0 Then Z5_DATVER END DT_PEDANT,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z5_CODPOS,
		Z6_GRUPO,
		Z6_DESGRU,
		Z6_VLRPROD VALOR_PRODUTO,
		Z6_BASECOM BASE_COMISSAO,
		Z6_VALCOM VALOR_COMISSAO,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    Z6_DESREDE
		FROM %Table:SZ6% SZ6
	  	LEFT JOIN %Table:SZF% SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND SZF.D_E_L_E_T_ = ' '  AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0
		LEFT JOIN %Table:SZ5% SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = Trim(regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')) AND SZ5.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
		WHERE
		SZ6.D_E_L_E_T_ = ' ' 
		AND Z6_FILIAL = ' ' 
		AND Z6_PERIODO = %Exp:MV_PAR01% 
		AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
		AND SubStr(Z6_CODAC,1,4) Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
		AND z6_tpentid = %Exp:cWhere% 
		AND Z6_CODAC != %Exp:cWhere2%
		
		ORDER BY %Exp:cOrdem%
		
	EndSql
Else
	BeginSql Alias "QCRPR070"
		Column Z6_DTPEDI	As Date
		Column Z6_VERIFIC	As Date
		Column Z6_VALIDA	As Date
		Column Z6_DTEMISS	As Date
		Column Z6_DTPGTO	As Date
		Column DT_PEDANT	As Date
		
		%NoParser%
		
		
		SELECT
		Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		Z6_CODENT ,
		Z6_DESENT,
		CASE
	    WHEN Z6_PEDGAR   = ' ' THEN 'HARDWARE AVULSO' 
	    WHEN Z5_DATVER  != ' ' AND Z6_VALCOM = 0 THEN 'PAGO ANTERIORMENTE'
	    WHEN Z6_PEDORI  != ' ' THEN 'RENOVACAO'
	    WHEN Z6_VERIFIC != ' ' THEN 'VERIFICACAO'
	    END STATPED,
	    CASE
	    WHEN Z5_DATVER  != ' ' THEN 0
	    ELSE 1
	    END CONT_CER,
		Z6_TPENTID,
		Z6_PRODUTO,
		Z6_DESCRPR,
		Z6_DTPEDI,
		Z6_VERIFIC,
		Z6_VALIDA,
		Z6_DTEMISS,
		Z6_CODVEND,
		Z6_NOMVEND,
		Z6_RECORI,
		Z6_PEDORI,
		Z6_CODCCR,
		(SELECT Z3_DESENT FROM PROTHEUS.SZ3010 WHERE Z3_FILIAL = ' ' AND Z3_CODENT = (SZ6.Z6_CODCCR) AND Z3_TIPENT = '9' AND D_E_L_E_T_ = ' ') Z6_CCRCOM,
		Z6_PEDSITE,
		Z6_PEDGAR,
		Case When Z6_PEDSITE = ' ' then Z6_PEDGAR Else Z6_PEDSITE End Cd_Pedido,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Case when Z6_PEDORI != ' ' Then Z6_PEDORI Else ZF_PEDIDO End PEDANT,
		Case when Z6_TIPO = 'ENTHAR' AND Z6_VALCOM = 0 THEN Z5_EMISSAO when Z6_PEDORI > '0' AND Z6_VALCOM = 0 THEN (SELECT MAX(Z5_DATEMIS) FROM PROTHEUS.SZ5010 SZ56 WHERE Z5_FILIAL = ' ' AND Z5_PEDGAR > '0' AND Z5_PEDGAR = SZ6.Z6_PEDORI AND D_E_L_E_T_ = ' ') WHEN  Z6_VALCOM = 0 Then Z5_DATVER END DT_PEDANT,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z5_CODPOS,
		Z6_GRUPO,
		Z6_DESGRU,
		Z6_VLRPROD VALOR_PRODUTO,
		Z6_BASECOM BASE_COMISSAO,
		Z6_VALCOM VALOR_COMISSAO,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    Z6_DESREDE
		FROM %Table:SZ6% SZ6
	  	LEFT JOIN %Table:SZF% SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND SZF.D_E_L_E_T_ = ' '  AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0
		LEFT JOIN %Table:SZ5% SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = Trim(regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')) AND SZ5.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
		WHERE
		SZ6.D_E_L_E_T_ = ' ' 
		AND Z6_FILIAL = ' ' 
		AND Z6_PERIODO = %Exp:MV_PAR01% 
		AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
		AND z6_tpentid = %Exp:cWhere%
		ORDER BY %Exp:cOrdem%
		
	EndSql
EndIf

oSection:EndQuery()

//Define Quebra
If Mv_par07 == 2
	oBreak := TRBreak():New( oSection, { || QCRPR070->Z6_CODENT } ) 
Else
	oBreak := TRBreak():New( oSection, { || QCRPR070->Z6_DESREDE } )
EndIf
TRFunction():New(oSection:Cell("Z6_CODENT")		,NIL ,"COUNT",oBreak)
TRFunction():New(oSection:Cell("CONT_CER")		,    ,"SUM"  ,oBreak,"",,,.T.,.F.)
TRFunction():New(oSection:Cell("BASE_COMISSAO")	,    ,"SUM"  ,oBreak,"",,,.T.,.F.)
TRFunction():New(oSection:Cell("VALOR_COMISSAO"),    ,"SUM"  ,oBreak,"",,,.T.,.F.)

oBreak:SetPageBreak(.T.)

//Imprime
oSection:Print()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ValidPerg ºAutor  ³Renato Ruy Bernardo    º Data ³  04/06/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função Responsavel por criar as perguntas utilizadas no    º±±
±±º          ³ Relatório.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Periodo  ?"	   			,"Periodo  ?"  	  	 		,"Periodo  ?"  		 		,"mv_ch1" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"AC De?"	 		  		,"AC De?"	 		  		,"AC De?"	 		  		,"mv_ch2" 	,"C" 		,04     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"AC Ate?"	 		  		,"AC Ate?"	 		  		,"AC Ate?"	 		  		,"mv_ch3" 	,"C" 		,04     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par03"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"04" 		,"Entidade De ?"   	  		,"Entidade De ?"   	  		,"Entidade De ?"   	  		,"mv_ch4" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par04"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"05" 		,"Entidade Ate ?"  	  		,"Entidade Ate ?"  	  		,"Entidade Ate ?"  	  		,"mv_ch5" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par05"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"06" 		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"mv_ch6" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par06"	,"Camp.Contador"	,"Camp.Contador"	,"Camp.Contador"	,""   		,"Clube Rev."   ,"Clube Rev."   ,"Clube Rev."   ,""		    ,""		    ,""		    	,""		    ,""		    	,""		    	,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"07" 		,"Ordena por Link ?"  		,"Ordem por Link ?"  		,"Ordena por Link ?"  		,"mv_ch7" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par07"	,"Sim"				,"Sim"				,"Sim"				,""   		,"Não"			,"Não"		    ,"Não"		    ,""		    ,""		    ,""		    	,""		    ,""		    	,""		    	,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

Return
