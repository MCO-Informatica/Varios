#Include "Totvs.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³CRPR060 ºAutor  ³Renato Ruy Bernardo    º Data ³  04/12/2014º±±
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
User Function CRPR060()
Local 	nVarLen	:=	SetVarNameLen(100)
Local 	oReport
Private cPerg	:= "CRPR60"

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
oReport	:=	TReport():New("CRPR60","Relatorio de Remuneração de Parceiros", cPerg, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)

//Seções Contas a Receber, Cliente , Naturezas
oSection	:= TRSection():New(oReport, "Remuneração"	, {"SZ6"})


/*/Define a Ordem
TROrder():New(oParent  , uOrder  , cTitle                        	, cAlias  ) */
//TROrder():New(oSection, "" 		, "Matricula x Salario" 			,         )



//Celulas de Impressão - SZ6 - Movimentos de Remuneração

TRCell():New(oSection, "Z3_CODENT"				, "SZ6", "Código Entidade"		,							,06)
TRCell():New(oSection, "Z3_DESENT"			 	, "SZ3", "Descrição Entidade"	,							,100)
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
TRCell():New(oSection, "BASE_COMISSAO"			, "SZ6", "Valot Tot. Base"		, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "BASE_SOFTWARE"			, "SZ6", "Base Software"		, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "BASE_HARDWARE"			, "SZ6", "Base Hardware"		, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "ZH_DESCRI"				, "SZ6", "Tipo Voucher"			,							,30)
TRCell():New(oSection, "PEDANT"					, "SZ6", "Ped. Anterior"		,							,07)
TRCell():New(oSection, "DT_PEDANT"				, "SZ6", "Dt.Pedido Anterior"	,"@D"						,08)
TRCell():New(oSection, "Z3_CCRCOM"				, "SZ6", "Desc. CCR"			,							,100)
TRCell():New(oSection, "Z3_CODAC"		  		, "SZ6", "Cód. AC"				,							,06)
TRCell():New(oSection, "Z3_DESAC"		  		, "SZ6", "Desc. AC"				,							,100)
TRCell():New(oSection, "Z6_DESGRU"				, "SZ6", "Desc. Grupo"			,							,100)
TRCell():New(oSection, "VLR_ABATIMENTO"			, "SZ6", "Val. Abatimento"		, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "VALOR_SOFTWARE"			, "SZ6", "Val. Bruto Soft"		, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "VALOR_HARDWARE"			, "SZ6", "Val. Bruto Hard"		, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "VALOR_PRODUTO"			, "SZ6", "Valor Bruto Total"	, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "VALOR_COMISSAO_SOFTWARE", "SZ6", "Val. Comiss. Soft"	, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "VALOR_COMISSAO_HARDWARE", "SZ6", "Val. Comiss. Hard"	, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "VALOR_COMISSAO"			, "SZ6", "Valor Tot. Comiss."	, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "VALFED"					, "SZ6", "Val. Comissão Fed."	, "@E 999.999.999,99"		,15)
TRCell():New(oSection, "COMFED"					, "SZ6", "Val. Tot. Comiss+Fed.", "@E 999.999.999,99"		,15)
TRCell():New(oSection, "CONT_CER"				, "QCRPR060", "Contagem Geral"	, "@E 999.999.999"			,15)
TRCell():New(oSection, "CONT_CERHW"				, "QCRPR060", "Contagem Hard."	, "@E 999.999.999"			,15)
TRCell():New(oSection, "CONT_CERSW"				, "QCRPR060", "Contagem Soft."	, "@E 999.999.999"			,15)
TRCell():New(oSection, "Z3_ESTADO"			 	, "SZ3", "UF"					,							,02)
TRCell():New(oSection, "REGIAO"				 	, "SZ3", "Região"				,							,20)

oSection:SetHeaderPage(.F.)

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
Local cWhere		:= " "

If 	   MV_PAR06 == 1
	cWhere := "4"
ElseIf MV_PAR06 == 2
	cWhere := "2"
ElseIf MV_PAR06 == 3
	cWhere := "1"
Else
	cWhere := "8"
EndIf

//Transforma parâmetros do tipo Range em expressão SQL para ser utilizadana query.
MakeSqlExpr(cPerg)

oSection:BeginQuery()

If MV_PAR06 == 2
	BeginSql Alias "QCRPR060"
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
		SZ3.Z3_CODENT ,
		SZ3.Z3_DESENT,
		CASE
	    WHEN MAX(Z6_PEDGAR)   = ' ' THEN 'HARDWARE AVULSO' 
	    WHEN MAX(Z5_DATVER)  != ' ' AND SUM(Z6_VALCOM) = 0 THEN 'PAGO ANTERIORMENTE'//??
	    WHEN MAX(Z6_PEDORI)  != ' ' THEN 'RENOVACAO'
	    WHEN MAX(Z6_VERIFIC) != ' ' THEN 'VERIFICACAO'
	    END STATPED,
	    CASE
	    WHEN MAX(Z5_DATVER)  != ' ' THEN 0
	    ELSE 1
	    END CONT_CER,
	    CASE
	    WHEN (MAX(Z5_DATVER) IS NULL OR MAX(Z5_DATVER) = ' ')  AND SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) > 0 THEN 1
	    ELSE 0
	    END CONT_CERHW,
	    CASE
	    WHEN (MAX(Z5_DATVER) IS NULL OR MAX(Z5_DATVER) = ' ') AND SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) > 0 THEN 1
	    ELSE 0
	    END CONT_CERSW,
		SZ3.Z3_CODFED,
		SZ3.Z3_DESFED,
		SZ3.Z3_CODCAN,
		SZ3.Z3_DESCAN,
		SZ3.Z3_CODCAN2,
		SZ3.Z3_DESCAII,
		SZ3.Z3_CODAC,
		SZ3.Z3_DESAC,
		SZ3.Z3_CODAR,
		SZ3.Z3_DESAR,
		SZ3.Z3_CODCCR,
		MAX((SELECT Z3_DESENT FROM PROTHEUS.SZ3010 WHERE ROWNUM = 1 AND Z3_FILIAL = ' ' AND Z3_CODENT = (SZ6.Z6_CODCCR) AND Z3_TIPENT = '9' AND D_E_L_E_T_ = ' ')) Z3_CCRCOM,
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
		Z6_PEDSITE,
		Z6_PEDGAR,
		Case When MAX(Z6_PEDSITE) = ' ' then MAX(Z6_PEDGAR) Else MAX(Z6_PEDSITE) End Cd_Pedido,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Case when Max(Z6_PEDORI) != ' ' Then Max(Z6_PEDORI) Else Max(ZF_PEDIDO) End PEDANT,
	 	Case when Max(Z6_TIPO) = 'ENTHAR' .And. THEN Max(Z5_EMISSAO) when Max(Z6_PEDORI) > '0' THEN Max((SELECT MAX(Z5_DATEMIS) FROM PROTHEUS.SZ5010 SZ56 WHERE Z5_FILIAL = ' ' AND Z5_PEDGAR > '0' AND Z5_PEDGAR = SZ6.Z6_PEDORI AND D_E_L_E_T_ = ' ')) ELSE Max(Z5_DATVER) END DT_PEDANT,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z5_CODPOS,
		Z5_DESPOS,
		Z6_GRUPO,
		Z6_DESGRU,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALOR_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) VALOR_COMISSAO_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALOR_SOFTWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) VALOR_COMISSAO_SOFTWARE,
		SUM(Z6_VLRABT) VLR_ABATIMENTO,
		SUM(Z6_VLRPROD) VALOR_PRODUTO,
		SUM(Z6_BASECOM) BASE_COMISSAO,
		SUM(Z6_VALCOM) VALOR_COMISSAO,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    SZ32.Z3_ESTADO,
	    CASE
      	WHEN SZ32.Z3_ESTADO IN ('AC','RO','AM','PA','TO','RR','AP') THEN 'Norte'
     	WHEN SZ32.Z3_ESTADO IN ('MA','PI','CE','RN','PB','PE','AL','SE','BA') THEN 'Nordeste'
      	WHEN SZ32.Z3_ESTADO IN ('MT','GO','DF','MS') THEN 'Centro-Oeste'
     	WHEN SZ32.Z3_ESTADO IN ('ES','SP','RJ','MG') THEN 'Sudeste'
      	WHEN SZ32.Z3_ESTADO IN ('PR','SC','RS') THEN 'Sul'
      	ELSE 'UF Não Informado' END REGIAO
		FROM %Table:SZ6% SZ6
	  	JOIN %Table:SZ3% SZ3 ON SZ3.Z3_FILIAL = ' ' AND Z6_CODAC = SZ3.Z3_CODENT AND SZ3.Z3_TIPENT = '2' AND SZ3.D_E_L_E_T_ = ' '
	  	LEFT JOIN %Table:SZF% SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND ZF_COD > '0' AND SZF.D_E_L_E_T_ = ' ' AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0
		LEFT JOIN %Table:SZ5% SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = Trim(regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')) AND SZ5.D_E_L_E_T_ = ' ' AND SZ5.Z5_PRODGAR > '0'
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ3% SZ32 ON SZ32.Z3_FILIAL = ' ' AND Z6_CODPOS = SZ32.Z3_CODGAR AND SZ32.Z3_TIPENT = '4' AND SZ32.D_E_L_E_T_ = ' '
		WHERE
		SZ6.D_E_L_E_T_ = ' ' 
		AND Z6_FILIAL = ' ' 
		AND Z6_PERIODO = %Exp:MV_PAR01% 
		AND SubStr(Z6_CODAC,1,4)   Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
		AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
		AND z6_tpentid IN ('2','5') 
		GROUP BY
		Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		SZ3.Z3_CODENT ,
		SZ3.Z3_DESENT,
		SZ3.Z3_CODFED,
		SZ3.Z3_DESFED,
		SZ3.Z3_CODCAN,
		SZ3.Z3_DESCAN,
		SZ3.Z3_CODCAN2,
		SZ3.Z3_DESCAII,
		SZ3.Z3_CODAC,
		SZ3.Z3_DESAC,
		SZ3.Z3_CODAR,
		SZ3.Z3_DESAR,
		SZ3.Z3_CODCCR,
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
		Z6_PEDSITE,
		Z6_PEDGAR,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU, 
		Z6_CODAGE,
		Z6_NOMEAGE,
		Z5_CODPOS,
		Z5_DESPOS,
		Z6_GRUPO,
		Z6_DESGRU,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    SZ32.Z3_ESTADO
		ORDER BY SZ3.Z3_CODCCR
		
	EndSql
ElseIf MV_PAR06 == 1
		BeginSql Alias "QCRPR060"
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
		Z3_CODENT ,
		Z3_DESENT,
		CASE
	    WHEN MAX(Z6_PEDGAR)   = ' ' THEN 'HARDWARE AVULSO' 
	    WHEN MAX(Z5_DATVER)  != ' ' AND SUM(Z6_VALCOM) = 0 THEN 'PAGO ANTERIORMENTE'
	    WHEN MAX(Z6_PEDORI)  != ' ' THEN 'RENOVACAO'
	    WHEN MAX(Z6_VERIFIC) != ' ' THEN 'VERIFICACAO'
	    END STATPED,
	    CASE
	    WHEN MAX(Z5_DATVER)  != ' ' THEN 0
	    ELSE 1
	    END CONT_CER,
	    CASE
	    WHEN (MAX(Z5_DATVER) IS NULL OR MAX(Z5_DATVER) = ' ')  AND SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) > 0 THEN 1
	    ELSE 0
	    END CONT_CERHW,
	    CASE
	    WHEN (MAX(Z5_DATVER) IS NULL OR MAX(Z5_DATVER) = ' ') AND SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) > 0 THEN 1
	    ELSE 0
	    END CONT_CERSW,
		Z3_CODFED,
		Z3_DESFED,
		Z3_CODCAN,
		Z3_DESCAN,
		Z3_CODCAN2,
		Z3_DESCAII,
		Z3_CODAC,
		Z3_DESAC,
		Z3_CODAR,
		Z3_DESAR,
		Z3_CODCCR,
		MAX((SELECT Z3_DESENT FROM PROTHEUS.SZ3010 WHERE ROWNUM = 1 AND Z3_FILIAL = ' ' AND Z3_CODENT = (SZ6.Z6_CODCCR) AND Z3_TIPENT = '9' AND D_E_L_E_T_ = ' ')) Z3_CCRCOM,
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
		Z6_PEDSITE,
		Z6_PEDGAR,
		Case When MAX(Z6_PEDSITE) = ' ' then MAX(Z6_PEDGAR) Else MAX(Z6_PEDSITE) End Cd_Pedido,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Case when Max(Z6_PEDORI) != ' ' Then Max(Z6_PEDORI) Else Max(ZF_PEDIDO) End PEDANT,
	 	Case when Max(Z6_TIPO) = 'ENTHAR' AND SUM(Z6_VALCOM) = 0  THEN Max(Z5_EMISSAO) when Max(Z6_PEDORI) > '0' AND SUM(Z6_VALCOM) = 0 THEN Max((SELECT MAX(Z5_DATEMIS) FROM PROTHEUS.SZ5010 SZ56 WHERE Z5_FILIAL = ' ' AND Z5_PEDGAR > '0' AND Z5_PEDGAR = SZ6.Z6_PEDORI AND D_E_L_E_T_ = ' ')) When SUM(Z6_VALCOM) = 0 Then Max(Z5_DATVER) END DT_PEDANT,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z5_CODPOS,
		Z5_DESPOS,
		Z6_GRUPO,
		Z6_DESGRU,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALOR_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) VALOR_COMISSAO_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALOR_SOFTWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) VALOR_COMISSAO_SOFTWARE,
		SUM(Z6_VLRABT) VLR_ABATIMENTO,
		SUM(Z6_VLRPROD) VALOR_PRODUTO,
		SUM(Z6_BASECOM) BASE_COMISSAO,
		SUM(Z6_VALCOM) VALOR_COMISSAO,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    Z3_ESTADO,
	    CASE WHEN MAX(Z6_PEDGAR) != ' ' THEN
	    MAX((SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% SZ62 WHERE SZ62.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:MV_PAR01% AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_PEDGAR > '0' AND Z6_TPENTID = '8'))
	    ELSE MAX((SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% SZ62 WHERE SZ62.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:MV_PAR01% AND Z6_PEDSITE = SZ6.Z6_PEDSITE AND Z6_PRODUTO = SZ6.Z6_PRODUTO AND Z6_PEDSITE > '0' AND Z6_TPENTID = '8'))
	    END VALFED,
	    CASE WHEN MAX(Z6_PEDGAR) != ' ' THEN
	    SUM(Z6_VALCOM) + MAX((SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% SZ62 WHERE SZ62.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:MV_PAR01% AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_PEDGAR > '0' AND Z6_TPENTID = '8'))
	    ELSE SUM(Z6_VALCOM) + MAX((SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% SZ62 WHERE SZ62.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:MV_PAR01% AND Z6_PEDSITE = SZ6.Z6_PEDSITE AND Z6_PRODUTO = SZ6.Z6_PRODUTO AND Z6_PEDSITE > '0' AND Z6_TPENTID = '8'))
	    END COMFED,
	    CASE
      	WHEN Z3_ESTADO IN ('AC','RO','AM','PA','TO','RR','AP') THEN 'Norte'
     	WHEN Z3_ESTADO IN ('MA','PI','CE','RN','PB','PE','AL','SE','BA') THEN 'Nordeste'
      	WHEN Z3_ESTADO IN ('MT','GO','DF','MS') THEN 'Centro-Oeste'
     	WHEN Z3_ESTADO IN ('ES','SP','RJ','MG') THEN 'Sudeste'
      	WHEN Z3_ESTADO IN ('PR','SC','RS') THEN 'Sul'
      	ELSE 'UF Não Informado' END REGIAO
		FROM %Table:SZ6% SZ6
	  	JOIN %Table:SZ3% SZ3 ON Z3_FILIAL = ' ' AND Z6_CODENT = Z3_CODENT AND SZ3.D_E_L_E_T_ = ' '
	  	LEFT JOIN %Table:SZF% SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND ZF_COD > '0' AND SZF.D_E_L_E_T_ = ' ' AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0
		LEFT JOIN %Table:SZ5% SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = Trim(regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')) AND SZ5.D_E_L_E_T_ = ' ' AND SZ5.Z5_PRODGAR > '0'
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
		WHERE
		SZ6.D_E_L_E_T_ = ' ' 
		AND Z6_FILIAL = ' '            
		AND Z6_PERIODO = %Exp:MV_PAR01%                            
		AND SubStr(Z6_CODAC,1,4)   Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
		AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
		AND Z6_CODCCR  Between %Exp:MV_PAR07% And %Exp:MV_PAR08%
		AND z6_tpentid = %Exp:cWhere%
		GROUP BY                                                
		Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		Z3_CODENT ,
		Z3_DESENT,
		Z3_CODFED,
		Z3_DESFED,
		Z3_CODCAN,
		Z3_DESCAN,
		Z3_CODCAN2,
		Z3_DESCAII,
		Z3_CODAC,
		Z3_DESAC,
		Z3_CODAR,
		Z3_DESAR,
		Z3_CODCCR,
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
		Z6_PEDSITE,
		Z6_PEDGAR,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU, 
		Z6_CODAGE,
		Z6_NOMEAGE,
		Z5_CODPOS,
		Z5_DESPOS,
		Z6_GRUPO,
		Z6_DESGRU,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    Z3_ESTADO
		ORDER BY Z3_CODCCR
		
	EndSql
Else
BeginSql Alias "QCRPR060"
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
		SZ3.Z3_CODENT ,
		SZ3.Z3_DESENT,
		CASE
	    WHEN MAX(Z6_PEDGAR)   = ' ' THEN 'HARDWARE AVULSO' 
	    WHEN MAX(Z5_DATVER)  != ' ' AND SUM(Z6_VALCOM) = 0 THEN 'PAGO ANTERIORMENTE'
	    WHEN MAX(Z6_PEDORI)  != ' ' THEN 'RENOVACAO'
	    WHEN MAX(Z6_VERIFIC) != ' ' THEN 'VERIFICACAO'
	    END STATPED,
	    CASE
	    WHEN MAX(Z5_DATVER)  != ' ' THEN 0
	    ELSE 1
	    END CONT_CER,
	    CASE
	    WHEN (MAX(Z5_DATVER) IS NULL OR MAX(Z5_DATVER) = ' ')  AND SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) > 0 THEN 1
	    ELSE 0
	    END CONT_CERHW,
	    CASE
	    WHEN (MAX(Z5_DATVER) IS NULL OR MAX(Z5_DATVER) = ' ') AND SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) > 0 THEN 1
	    ELSE 0
	    END CONT_CERSW,
		SZ3.Z3_CODFED,
		SZ3.Z3_DESFED,
		SZ3.Z3_CODCAN,
		SZ3.Z3_DESCAN,
		SZ3.Z3_CODCAN2,
		SZ3.Z3_DESCAII,
		SZ3.Z3_CODAC,
		SZ3.Z3_DESAC,
		SZ3.Z3_CODAR,
		SZ3.Z3_DESAR,
		SZ3.Z3_CODCCR,
		MAX((SELECT Z3_DESENT FROM PROTHEUS.SZ3010 WHERE ROWNUM = 1 AND Z3_FILIAL = ' ' AND Z3_CODENT = (SZ6.Z6_CODCCR) AND Z3_TIPENT = '9' AND D_E_L_E_T_ = ' ')) Z3_CCRCOM,
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
		Z6_PEDSITE,
		Z6_PEDGAR,
		Case When MAX(Z6_PEDSITE) = ' ' then MAX(Z6_PEDGAR) Else MAX(Z6_PEDSITE) End Cd_Pedido,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Case when Max(Z6_PEDORI) != ' ' Then Max(Z6_PEDORI) Else Max(ZF_PEDIDO) End PEDANT,
	 	Case when Max(Z6_TIPO) = 'ENTHAR' AND SUM(Z6_VALCOM) = 0 THEN Max(Z5_EMISSAO) when Max(Z6_PEDORI) > '0' AND SUM(Z6_VALCOM) = 0 THEN Max((SELECT MAX(Z5_DATEMIS) FROM PROTHEUS.SZ5010 SZ56 WHERE Z5_FILIAL = ' ' AND Z5_PEDGAR > '0' AND Z5_PEDGAR = SZ6.Z6_PEDORI AND D_E_L_E_T_ = ' ')) WHEN  SUM(Z6_VALCOM) = 0 Then Max(Z5_DATVER) END DT_PEDANT,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z5_CODPOS,
		Z5_DESPOS,
		Z6_GRUPO,
		Z6_DESGRU,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALOR_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) VALOR_COMISSAO_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALOR_SOFTWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) VALOR_COMISSAO_SOFTWARE,
		SUM(Z6_VLRABT) VLR_ABATIMENTO,
		SUM(Z6_VLRPROD) VALOR_PRODUTO,
		SUM(Z6_BASECOM) BASE_COMISSAO,
		SUM(Z6_VALCOM) VALOR_COMISSAO,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    SZ32.Z3_ESTADO,
	    CASE
      	WHEN SZ32.Z3_ESTADO IN ('AC','RO','AM','PA','TO','RR','AP') THEN 'Norte'
     	WHEN SZ32.Z3_ESTADO IN ('MA','PI','CE','RN','PB','PE','AL','SE','BA') THEN 'Nordeste'
      	WHEN SZ32.Z3_ESTADO IN ('MT','GO','DF','MS') THEN 'Centro-Oeste'
     	WHEN SZ32.Z3_ESTADO IN ('ES','SP','RJ','MG') THEN 'Sudeste'
      	WHEN SZ32.Z3_ESTADO IN ('PR','SC','RS') THEN 'Sul'
      	ELSE 'UF Não Informado' END REGIAO
		FROM %Table:SZ6% SZ6
	  	JOIN %Table:SZ3% SZ3 ON SZ3.Z3_FILIAL = ' ' AND Z6_CODENT = SZ3.Z3_CODENT AND SZ3.D_E_L_E_T_ = ' '
	  	LEFT JOIN %Table:SZF% SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND ZF_COD > '0' AND SZF.D_E_L_E_T_ = ' ' AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0
		LEFT JOIN %Table:SZ5% SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = Trim(regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')) AND SZ5.D_E_L_E_T_ = ' 'AND SZ5.Z5_PRODGAR > '0' 
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ3% SZ32 ON SZ32.Z3_FILIAL = ' ' AND Z6_CODPOS = SZ32.Z3_CODGAR AND SZ32.Z3_TIPENT = '4' AND SZ32.D_E_L_E_T_ = ' '
		WHERE
		SZ6.D_E_L_E_T_ = ' ' 
		AND Z6_FILIAL = ' ' 
		AND Z6_PERIODO = %Exp:MV_PAR01% 
		AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
		AND Z6_TPENTID = %Exp:cWhere%
		GROUP BY
		Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		SZ3.Z3_CODENT ,
		SZ3.Z3_DESENT,
		SZ3.Z3_CODFED,
		SZ3.Z3_DESFED,
		SZ3.Z3_CODCAN,
		SZ3.Z3_DESCAN,
		SZ3.Z3_CODCAN2,
		SZ3.Z3_DESCAII,
		SZ3.Z3_CODAC,
		SZ3.Z3_DESAC,
		SZ3.Z3_CODAR,
		SZ3.Z3_DESAR,
		SZ3.Z3_CODCCR,
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
		Z6_PEDSITE,
		Z6_PEDGAR,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU, 
		Z6_CODAGE,
		Z6_NOMEAGE,
		Z5_CODPOS,
		Z5_DESPOS,
		Z6_GRUPO,
		Z6_DESGRU,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    SZ32.Z3_ESTADO
		ORDER BY SZ3.Z3_CODCCR
		
	EndSql
EndIf
oSection:EndQuery()

//Define Quebra
If MV_PAR06 == 1
oBreak := TRBreak():New( oSection, { || QCRPR060->Z3_CODCCR} ) 
Else
oBreak := TRBreak():New( oSection, { || QCRPR060->Z3_CODENT} ) 
EndIf

TRFunction():New(oSection:Cell("Z3_CODENT"),NIL				,"COUNT",oBreak)
TRFunction():New(oSection:Cell("CONT_CER")  ,    			,"SUM"  ,oBreak,"",,,.T.,.F.)
TRFunction():New(oSection:Cell("CONT_CERHW"),    			,"SUM"  ,oBreak,"",,,.T.,.F.)
TRFunction():New(oSection:Cell("CONT_CERSW"),    			,"SUM"  ,oBreak,"",,,.T.,.F.)
TRFunction():New(oSection:Cell("BASE_COMISSAO"),    		,"SUM"  ,oBreak,"",,,.T.,.F.)
TRFunction():New(oSection:Cell("BASE_SOFTWARE"),    		,"SUM"  ,oBreak,"",,,.T.,.F.)
TRFunction():New(oSection:Cell("BASE_HARDWARE"),    		,"SUM"  ,oBreak,"",,,.T.,.F.)
TRFunction():New(oSection:Cell("VALOR_COMISSAO_SOFTWARE"),  ,"SUM"  ,oBreak,"",,,.T.,.F.)
TRFunction():New(oSection:Cell("VALOR_COMISSAO_HARDWARE"),  ,"SUM"  ,oBreak,"",,,.T.,.F.)
TRFunction():New(oSection:Cell("VALOR_COMISSAO"),    		,"SUM"  ,oBreak,"",,,.T.,.F.)

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
PutSX1(	cPerg		,"06" 		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"mv_ch6" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par06"	,"Posto"   			,"Posto"   			,"Posto"   			,""   		,"AC"           ,"AC"           ,"AC"           ,"Canal"    ,"Canal"    ,"Canal"    	,"Federação","Federação"	,"Federação"	,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"07" 		,"Cod.CCR De ?"   	  		,"Cod.CCR De ?"   	  		,"Cod.CCR De ?"   	  		,"mv_ch7" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par07"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"08" 		,"Cod.CCR Ate ?"  	  		,"Cod.CCR Ate ?"  	  		,"Cod.CCR Ate ?"  	  		,"mv_ch8" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par08"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)


Return
