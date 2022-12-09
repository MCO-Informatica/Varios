#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelPros            บAutor  ณ Luiz     บ Data ณ  07/08/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rios Prospects por Data de Cadastro  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MetaLacre - Protheus 11                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RelPros()
Local aArea := GetArea()
Local oReport
Private cPerg := PadR('RELPROS',10)

AjustaSX1()
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()	

RestArea(aArea)
Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local cTitulo	:= "Relatorio de Prospects por Data de Cadastro"


oReport := TReport():New("RelPros",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)
oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao

oSection := TRSection():New(oReport,"Prospects",{"SUS"})

	TRCell():New(oSection,"US_COD","SUS")
	TRCell():New(oSection,"US_LOJA","SUS")
	TRCell():New(oSection,"US_NOME","SUS")
	TRCell():New(oSection,"US_MUN","SUS")
	TRCell():New(oSection,"US_EST","SUS")
	TRCell():New(oSection,"US_STATUS","SUS")
	TRCell():New(oSection,"US_DATCAD","SUS")
	TRCell():New(oSection,"US_INDCLI","SUS")
	TRCell():New(oSection,"US_INDLOJ","SUS")
	TRCell():New(oSection,"US_INDNOM","SUS",'Cliente Indicacao')
	TRCell():New(oSection,"US_CODCLI","SUS")
	TRCell():New(oSection,"US_LOJACLI","SUS")
	TRCell():New(oSection,"US_DTCONV","SUS")
	TRCell():New(oSection,"US_VEND","SUS")
	TRCell():New(oSection,"A3_NREDUZ","SA3")
	


	oSection:Cell("US_COD"):lHeaderSize := .F.
	oSection:Cell("US_LOJA"):lHeaderSize := .F.
	oSection:Cell("US_NOME"):lHeaderSize := .F.
	oSection:Cell("US_MUN"):lHeaderSize := .F.
	oSection:Cell("US_EST"):lHeaderSize := .F.
	oSection:Cell("US_STATUS"):lHeaderSize := .F.
	oSection:Cell("US_DATCAD"):lHeaderSize := .F.
	oSection:Cell("US_INDCLI"):lHeaderSize := .F.
	oSection:Cell("US_INDLOJ"):lHeaderSize := .F.
	oSection:Cell("US_INDNOM"):lHeaderSize := .F.
	oSection:Cell("US_CODCLI"):lHeaderSize := .F.
	oSection:Cell("US_LOJACLI"):lHeaderSize := .F.
	oSection:Cell("US_DTCONV"):lHeaderSize := .F.
	oSection:Cell("US_VEND"):lHeaderSize := .F.
	oSection:Cell("A3_NREDUZ"):lHeaderSize := .F.
	
	oSection:Cell("US_NOME"):nSize := 20	
	oSection:Cell("US_INDNOM"):nSize := 20	

	oBreak1 := TRBreak():New(oSection,oSection:Cell("US_VEND"),"Qtde Registros")

	TRFunction():New(oSection:Cell("US_VEND")  ,NIL,"COUNT",oBreak1)

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

		SELECT 			US_COD,
						US_NOME,
						US_MUN,
						US_EST,
						US_STATUS =
						CASE
						WHEN US_STATUS = '1' THEN 'Class.'
						WHEN US_STATUS = '2' THEN 'Desenv'
						WHEN US_STATUS = '3' THEN 'Gerente'
						WHEN US_STATUS = '4' THEN 'StandBy'
						WHEN US_STATUS = '5' THEN 'Cancel'
						WHEN US_STATUS = '6' THEN 'Cliente'
						END,
						ISNULL(US_MIDIA + ' - ' + SUH.UH_DESC,'') US_MIDIA,
						US_DATCAD,
						US_INDCLI,
						US_INDLOJ,
						US_INDNOM,
						US_CODCLI,
						US_LOJACLI,
						US_DTCONV,
						US_VEND,
						A3_NREDUZ
		FROM %table:SUS% SUS
		LEFT JOIN %table:SUH% SUH
		ON UH_MIDIA = US_MIDIA AND SUH.%notDel%
		LEFT JOIN %table:SA3% SA3
		ON A3_COD = US_VEND AND SA3.%notDel%
		WHERE SUS.D_E_L_E_T_ = ''      
		AND SUS.US_FILIAL = %xfilial:SUS%
		AND SA3.A3_FILIAL = %xfilial:SA3%
		AND SUH.UH_FILIAL = %xfilial:SUH%
		AND SUS.%notDel%
		AND SUS.US_DATCAD BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND SUS.US_VEND BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		ORDER BY US_VEND,US_DATCAD
	EndSql
	
	oReport:SetTitle('Relatorio de Prospects Por Data de Cadastro - Periodo de ' + DtoC(MV_PAR01) + ' Ate ' + DtoC(MV_PAR02))

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
PutSx1(cPerg,'03','Vendedor de    ?','','','mv_ch3','C', 6, 0, 0,'G','','SA3','','','mv_par03'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'04','Vendedor Ate   ?','','','mv_ch4','C', 6, 0, 0,'G','','SA3','','','mv_par04'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               

Return NIL