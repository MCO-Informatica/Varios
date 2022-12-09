#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelCte   บAutor  ณ Luiz     บ Data ณ  11/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rios Conferencia NF Entradas   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MetaLacre - Protheus 11                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RelCte()
Local oReport
Private cPerg := PadR('RELCTE',10)

AjustaSX1()
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()	
Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local cTitulo	:= "Relatorio de Cteดs"


oReport := TReport():New("RelCte",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)
oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao

oSection := TRSection():New(oReport,"Cte",{"SF1","CC2",'SE2'})

	TRCell():New(oSection,"F1_ESTCTE","SF1")
	TRCell():New(oSection,"F1_CMUCTE","SF1")
	TRCell():New(oSection,"CC2_MUN","CC2")
	TRCell():New(oSection,"F1_EMISSAO","SF1")
	TRCell():New(oSection,"F1_FORNECE","SF1")
	TRCell():New(oSection,"F1_LOJA","SF1")
	TRCell():New(oSection,"F1_NOMFOR","SF1")
	TRCell():New(oSection,"F1_VALBRUT","SF1",'Total CTE','9,999,999.99')
	TRCell():New(oSection,"E2_VENCREA","SE2")
	
	oSection:Cell("E2_VENCREA"):lHeaderSize := .F.
   	oSection:Cell("CC2_MUN"):nSize := 30	
   	oSection:Cell("E2_VENCREA"):nSize := 15	

	oBreak1 := TRBreak():New(oSection,oSection:Cell("F1_ESTCTE"),"Total UF")
	oBreak2 := TRBreak():New(oSection,oSection:Cell("F1_CMUCTE"),"Total Municipio")

	TRFunction():New(oSection:Cell("F1_VALBRUT")  ,NIL,"SUM",oBreak1)
	TRFunction():New(oSection:Cell("F1_VALBRUT")  ,NIL,"SUM",oBreak2)

	oSection:SetTotalInLine(.F.)


Return oReport

Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local cPart
Local cFiltro   := ""

#IFDEF TOP

	//Transforma parametros do tipo Range em expressao SQL para ser utilizada na query 
	MakeSqlExpr(cPerg)
	

	oSection:BeginQuery()
	
	BeginSql alias "QRYCNF"
		SELECT F1_ESTCTE, F1_CMUCTE, LEFT(CC2_MUN,40) CC2_MUN,
				F1_EMISSAO, F1_FORNECE, F1_LOJA, F1_NOMFOR,
				F1_VALBRUT, E2_VENCREA
		FROM %table:SF1% F1, %table:CC2% CC2, %table:SE2% E2
		WHERE F1_CMUCTE = CC2_CODMUN
		AND F1_FILIAL = %xfilial:SF1%
		AND CC2_FILIAL = %xfilial:CC2%
		AND E2_FILIAL = %xfilial:SE2%
		AND F1.%notDel%
		AND E2.%notDel%
		AND CC2.%notDel%
		AND F1_ESTCTE = CC2_EST
		AND E2_NUM = F1_DOC
		AND E2_PREFIXO = F1_SERIE
		AND F1_ESPECIE = 'CTE'
		AND F1_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND F1_FORNECE BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND F1_LOJA    BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND F1_ESTCTE  BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND F1_CMUCTE  BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
		ORDER BY F1_EST, F1_CMUCTE
	EndSql
	
	oReport:SetTitle("Relatorio de CTeดs - Periodo de " + DtoC(MV_PAR01) + ' Ate ' + DtoC(MV_PAR02))

	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
	pela funcao MakeSqlExpr para serem adicionados a query
	*/
	oSection:EndQuery()
#ELSE
#ENDIF	

oSection:Print()

Return



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AjustaSX1()                                                                                                                                       
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aHelpPor01 := {}
Local aHelpPor02 := {}
Local aHelpPor03 := {}
Local aHelpPor04 := {}
Local aHelpPor05 := {}
Local aHelpPor06 := {}
Local aHelpPor07 := {}

PutSx1(cPerg,'01','Data De        ?','','','mv_ch1','D',08, 0, 0,'G','',''   ,'','','mv_par01'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'02','Data Ate       ?','','','mv_ch2','D',08, 0, 0,'G','',''   ,'','','mv_par02'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
PutSx1(cPerg,'03','Fornecedor de  ?','','','mv_ch3','C', 6, 0, 0,'G','','SA2','','','mv_par03'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'04','Fornecedor Ate ?','','','mv_ch4','C', 6, 0, 0,'G','','SA2','','','mv_par04'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'05','Loja de        ?','','','mv_ch5','C', 2, 0, 0,'G','',''   ,'','','mv_par05'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'06','Loja Ate       ?','','','mv_ch6','C', 2, 0, 0,'G','',''   ,'','','mv_par06'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'07','Uf De          ?','','','mv_ch7','C',02, 0, 0,'G','','12' ,'','','mv_par07'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'08','Uf Ate         ?','','','mv_ch8','C',02, 0, 0,'G','','12' ,'','','mv_par08'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'09','Municipio De   ?','','','mv_ch9','C', 5, 0, 0,'G','','CC2','','','mv_par09'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'10','Municipio Ate  ?','','','mv_chA','C', 5, 0, 0,'G','','CC2','','','mv_par10'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
Return NIL