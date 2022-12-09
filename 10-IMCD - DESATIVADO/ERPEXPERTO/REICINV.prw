#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

#DEFINE STR0000	"REICINV"
#DEFINE STR0001 "FILIAL"
#DEFINE STR0002	"NOTAFISCAL"
#DEFINE STR0003	"SERIE"
#DEFINE STR0004	"CFO"
#DEFINE STR0005	"CODFORNECEDOR"
#DEFINE STR0006	"LOJAFORNECEDOR"
#DEFINE STR0007	"NOMEFORNECEDOR"
#DEFINE STR0008	"DESPACHANTE"
#DEFINE STR0009	"DATAENTRADANF"
#DEFINE STR0010 "DTDIGIT"
#DEFINE STR0011 "DATANF"
#DEFINE STR0012 "VALORNF"
#DEFINE STR0013 "PROCESSO"
#DEFINE STR0014 "MOEDAFOB"
#DEFINE STR0015 "TAXAMOEDAFOB"
#DEFINE STR0016 "TOTALFOB"
#DEFINE STR0017 "CONVERTIDO"

/*/{Protheus.doc} REICINV
Relatório de Fornecedores estrangeiros
Recebe as datas de e até, processo de e até, e retorna os valores FOB, informações de MOEDA
dos processos bem como o número e série das notas fiscais de entrada
@type function
@version  
@author Placido
@since 15/04/2021
@return return_type, return_description
/*/
User Function REICINV()
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg := "REICINV"

	Pergunte(cPerg,.T.)
	ReportDef()
	oReport:PrintDialog()
Return


Static Function ReportDef()
	oReport := TReport():New(STR0000,"Relatório Fornecedores Estrangeiros",cPerg,{|oReport| PrintReport(oReport)},"Relatório Fornecedores Estrangeiros")
	oReport:SetLandscape(.T.)

	oSecCab := TRSection():New( oReport ,"Relatório Fornecedores Estrangeiros" )

	TRCell():New( oSecCab,STR0001			, "",STR0001)
	TRCell():New( oSecCab,STR0013			, "",STR0013)
	TRCell():New( oSecCab,STR0002			, "",STR0002)

	TRCell():New( oSecCab,STR0010			, "",STR0010)
	TRCell():New( oSecCab,STR0007		   	, "",STR0007)
	TRCell():New( oSecCab,STR0016			, "",STR0016)
	TRCell():New( oSecCab,STR0014			, "",STR0014)
	TRCell():New( oSecCab,STR0017			, "",STR0017)

	TRCell():New( oSecCab,STR0003    		, "",STR0003)
	TRCell():New( oSecCab,STR0004			, "",STR0004)
	TRCell():New( oSecCab,STR0005			, "",STR0005)
	TRCell():New( oSecCab,STR0006		   	, "",STR0006)
	
	TRCell():New( oSecCab,STR0008			, "",STR0008)
	TRCell():New( oSecCab,STR0009			, "",STR0009)
	
	TRCell():New( oSecCab,STR0011			, "",STR0011)
	TRCell():New( oSecCab,STR0012			, "",STR0012)
	
	
	TRCell():New( oSecCab,STR0015			, "",STR0015)
	
	oBreak := TRBreak():New(oSecCab,oSecCab:Cell("CODFORNECEDOR"),"Sub Total Titulos")
	//ESTA LINHA IRÁ CONTAR A QUANTIDADE DE REGISTROS LISTADOS NO RELATÓRIO PARA A ÚNICA SEÇÃO QUE TEMOS

	TRFunction():New(oSecCab:Cell("TOTALFOB"),"Total FOB","SUM",oBreak)
	TRFunction():New(oSecCab:Cell("CONVERTIDO"),"Total Convertido","SUM",oBreak)

	TRFunction():New(oSecCab:Cell("CODFORNECEDOR"),"Total de Notas Fiscais","COUNT")

Return

Static Function PrintReport(oReport)
	Local (cAlias) := GetNextAlias()

	oSecCab:Init()

	BeginSql Alias cAlias

			column W6_DTREG_D as Date
			column F1_DTDIGIT as Date
			column W6_DT_NF as Date

SELECT  
FILIAL, NOTAFISCAL, SERIE, CFO, CODFORNECEDOR, LOJAFORNECEDOR, NOMEFORNECEDOR, DESPACHANTE, DATAENTRADANF,
DTDIGIT, DATANF, VALORNF, PROCESSO, MOEDAFOB, 
TAXAMOEDAFOB, ROUND(SUM(TOTALFOB1)* TAXA,2) TOTALFOB, sum(CONVERTIDO1) CONVERTIDO

FROM (
			SELECT DISTINCT (W9_INVOICE ),
			SF1.F1_FILIAL 			FILIAL,
			SF1.F1_DOC				NOTAFISCAL,
			SF1.F1_SERIE			SERIE,
			COALESCE(F3_CFO,' ')  	CFO,
			W9_FORN					CODFORNECEDOR,
			W9_FORLOJ				LOJAFORNECEDOR,
			W9_NOM_FOR				NOMEFORNECEDOR,
			Y5_NOME 				DESPACHANTE	,
			(W6_DTREG_D) 			DATAENTRADANF,
			(SF1.F1_DTDIGIT)		DTDIGIT,
			(W6_DT_NF) 				DATANF,
			W6_VL_NF 				VALORNF,
			W6_HAWB 				PROCESSO,
			W9_MOE_FOB 				MOEDAFOB,
			W9_TX_FOB 				TAXAMOEDAFOB,
			(W9_FOB_TOT) 	TOTALFOB1,
			W9_TX_FOB TAXA,
			(W9_FOB_TOT) 		CONVERTIDO1

			FROM %Table:SW6% SW6

			INNER JOIN %Table:SW9% SW9 ON
			SW9.W9_FILIAL = SW6.W6_FILIAL
			AND SW9.W9_HAWB = SW6.W6_HAWB
			AND SW9.%notDel%

			INNER JOIN %Table:SWN% SWN ON 
			WN_FILIAL = W9_FILIAL
			AND WN_HAWB = W9_HAWB
			AND WN_INVOICE = W9_INVOICE
			AND WN_TIPO_NF <> '6'
			AND SWN.%notDel%
			
			INNER JOIN %Table:SF1% SF1 ON 
			F1_HAWB = WN_HAWB
			AND F1_LOJA = WN_LOJA			
			AND F1_FORNECE = WN_FORNECE
			AND F1_SERIE = WN_SERIE
			AND F1_DOC = WN_DOC
			AND F1_FILIAL = WN_FILIAL
			AND SF1.%notDel%

			INNER JOIN %Table:SF3% SF3 ON 
			SF3.F3_NFISCAL = SF1.F1_DOC 
			AND SF3.F3_SERIE = SF1.F1_SERIE 
			AND SF3.F3_CLIEFOR = SF1.F1_FORNECE
			AND SF3.F3_LOJA = SF1.F1_LOJA
			AND SF3.F3_FILIAL = SF1.F1_FILIAL
			AND SF3.%notDel%

			INNER JOIN %Table:SY5% SY5 ON
			W6_DESP = Y5_COD
			AND SY5.%notDel%
			
			WHERE
			F3_CFO <> '3949' 
			AND F1_DTDIGIT BETWEEN %exp:(DtoS(MV_PAR01))% AND %exp:(DtoS(MV_PAR02))% 
			AND W6_HAWB    BETWEEN %exp:(MV_PAR03)% AND %exp:(MV_PAR04)% 
			AND SW6.%notDel% 
			)
			
		GROUP BY FILIAL, NOTAFISCAL, SERIE, CFO, CODFORNECEDOR, 
		LOJAFORNECEDOR, NOMEFORNECEDOR, DESPACHANTE, DATAENTRADANF, DTDIGIT, 
		DATANF, VALORNF, PROCESSO, MOEDAFOB, TAXAMOEDAFOB
		ORDER BY    1,    2

	EndSql
/*
cQry := GetLastQuery()[2]
memowrite('REICINV.sql', cQry)
*/

	While !(cAlias)->(EOF())
		//  Verifica se nao foi cancelado
		If oReport:Cancel()
			oReport:CancelPrint()
			Exit
		EndIf

		oSecCab:Init()
		oSecCab:Cell(STR0001):SetValue((cAlias)->FILIAL)
		oSecCab:Cell(STR0013):SetValue((cAlias)->PROCESSO)
		oSecCab:Cell(STR0002):SetValue((cAlias)->NOTAFISCAL)
		oSecCab:Cell(STR0010):SetValue(stod((cAlias)->DTDIGIT))
		oSecCab:Cell(STR0007):SetValue((cAlias)->NOMEFORNECEDOR)
		oSecCab:Cell(STR0016):SetValue((cAlias)->TOTALFOB)
		oSecCab:Cell(STR0014):SetValue((cAlias)->MOEDAFOB)
		oSecCab:Cell(STR0017):SetValue((cAlias)->CONVERTIDO)


		oSecCab:Cell(STR0003):SetValue((cAlias)->SERIE)
		oSecCab:Cell(STR0004):SetValue((cAlias)->CFO)
		oSecCab:Cell(STR0005):SetValue((cAlias)->CODFORNECEDOR)
		oSecCab:Cell(STR0006):SetValue((cAlias)->LOJAFORNECEDOR)

		oSecCab:Cell(STR0008):SetValue((cAlias)->DESPACHANTE)
		oSecCab:Cell(STR0009):SetValue(stod((cAlias)->DATAENTRADANF))

		oSecCab:Cell(STR0011):SetValue(stod((cAlias)->DATANF))
		oSecCab:Cell(STR0012):SetValue((cAlias)->VALORNF)

		oSecCab:Cell(STR0015):SetValue((cAlias)->TAXAMOEDAFOB)

		oSecCab:PrintLine()
		(cAlias)->(DbSkip())
	EndDo

	oSecCab:Finish()

	(cAlias)->(DbCloseArea())
	oReport:EndPage()
Return
