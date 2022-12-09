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
	TRCell():New( oSecCab,STR0002			, "",STR0002)
	TRCell():New( oSecCab,STR0003    		, "",STR0003)
	TRCell():New( oSecCab,STR0004			, "",STR0004)
	TRCell():New( oSecCab,STR0005			, "",STR0005)
	TRCell():New( oSecCab,STR0006		   	, "",STR0006)
	TRCell():New( oSecCab,STR0007		   	, "",STR0007)
	TRCell():New( oSecCab,STR0008			, "",STR0008)
	TRCell():New( oSecCab,STR0009			, "",STR0009)
	TRCell():New( oSecCab,STR0010			, "",STR0010)
	TRCell():New( oSecCab,STR0011			, "",STR0011)
	TRCell():New( oSecCab,STR0012			, "",STR0012)
	TRCell():New( oSecCab,STR0013			, "",STR0013)	
	TRCell():New( oSecCab,STR0014			, "",STR0014)
	TRCell():New( oSecCab,STR0015			, "",STR0015)
	TRCell():New( oSecCab,STR0016			, "",STR0016)
	TRCell():New( oSecCab,STR0017			, "",STR0017)
		
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
			SELECT
			SF1.F1_FILIAL 			FILIAL,
			SF1.F1_DOC				NOTAFISCAL,
			SF1.F1_SERIE			SERIE,
			F3_CFO					CFO,
			W9_FORN					CODFORNECEDOR,
			W9_FORLOJ				LOJAFORNECEDOR,
			W9_NOM_FOR				NOMEFORNECEDOR,
			Y5_NOME 				DESPACHANTE	,
			TO_DATE(W6_DTREG_D) 	DATAENTRADANF,
			TO_DATE(SF1.F1_DTDIGIT)	DTDIGIT,
			TO_DATE(W6_DT_NF) 		DATANF,
			W6_VL_NF 				VALORNF,
			W6_HAWB 				PROCESSO,
			W9_MOE_FOB 				MOEDAFOB,
			W9_TX_FOB 				TAXAMOEDAFOB,
			ROUND(SUM(W9_FOB_TOT)*W9_TX_FOB,2) 	TOTALFOB,
			SUM(W9_FOB_TOT) 					CONVERTIDO

			FROM %Table:SW6% SW6

			INNER JOIN %Table:SW9% SW9 ON
			SW6.W6_FILIAL = SW9.W9_FILIAL AND 
			SW6.W6_HAWB = SW9.W9_HAWB 

			INNER JOIN %Table:SF1% SF1 ON 
			SF1.F1_HAWB = SW9.W9_HAWB AND 
			F1_FORNECE = W9_FORN
			AND F1_LOJA = W9_FORLOJ  

			INNER JOIN %Table:SF3% SF3 ON 
			SF3.F3_NFISCAL = SF1.F1_DOC 
			AND SF3.F3_SERIE = SF1.F1_SERIE 
			AND SF3.F3_CLIEFOR = SF1.F1_FORNECE
			AND SF3.F3_LOJA = SF1.F1_LOJA


			INNER JOIN %Table:SY5% SY5 ON
			W6_DESP = Y5_COD

			WHERE (SW9.%notDel% AND SW6.%notDel% AND SF1.%notDel% AND SF3.%notDel%)
			AND F1_DTDIGIT BETWEEN %exp:(DtoS(MV_PAR01))% AND %exp:(DtoS(MV_PAR02))% 
			AND W6_HAWB    BETWEEN %exp:(MV_PAR03)% AND %exp:(MV_PAR04)% 

			GROUP BY  SF1.F1_FILIAL, SF1.F1_DOC, SF1.F1_SERIE, F3_CFO, W9_FORN,W9_FORLOJ,W9_NOM_FOR,Y5_NOME, W6_DTREG_D,F1_DTDIGIT,W6_DT_NF ,W6_VL_NF ,W6_HAWB ,  W9_MOE_FOB , W9_TX_FOB 

			ORDER BY F1_DOC		
		EndSql	

cQry := GetLastQuery()[2]

memowrite('REICINV.sql', cQry)


While !(cAlias)->(EOF())
	//  Verifica se nao foi cancelado            
	If oReport:Cancel()           
		oReport:CancelPrint()
		Exit
	EndIf  	

    oSecCab:Init()
    oSecCab:Cell(STR0001):SetValue((cAlias)->FILIAL)
    oSecCab:Cell(STR0002):SetValue((cAlias)->NOTAFISCAL)
    oSecCab:Cell(STR0003):SetValue((cAlias)->SERIE)
    oSecCab:Cell(STR0004):SetValue((cAlias)->CFO)	
    oSecCab:Cell(STR0005):SetValue((cAlias)->CODFORNECEDOR)
    oSecCab:Cell(STR0006):SetValue((cAlias)->LOJAFORNECEDOR)
    oSecCab:Cell(STR0007):SetValue((cAlias)->NOMEFORNECEDOR)
	oSecCab:Cell(STR0008):SetValue((cAlias)->DESPACHANTE)
    oSecCab:Cell(STR0009):SetValue((cAlias)->DATAENTRADANF)
	oSecCab:Cell(STR0010):SetValue((cAlias)->DTDIGIT)
    oSecCab:Cell(STR0011):SetValue((cAlias)->DATANF)
    oSecCab:Cell(STR0012):SetValue((cAlias)->VALORNF)
    oSecCab:Cell(STR0013):SetValue((cAlias)->PROCESSO)
    oSecCab:Cell(STR0014):SetValue((cAlias)->MOEDAFOB)
    oSecCab:Cell(STR0015):SetValue((cAlias)->TAXAMOEDAFOB)
    oSecCab:Cell(STR0016):SetValue((cAlias)->TOTALFOB)
    oSecCab:Cell(STR0017):SetValue((cAlias)->CONVERTIDO)

    oSecCab:PrintLine()
    (cAlias)->(DbSkip())
EndDo

oSecCab:Finish()

(cAlias)->(DbCloseArea())
oReport:EndPage()
Return 
