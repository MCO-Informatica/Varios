#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelPgAnt           บAutor  ณ Luiz     บ Data ณ  08/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rios Pagamentos Antecipados por Or็amento            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MetaLacre - Protheus 11                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RelPgAnt()
Local oReport
Private cPerg := PadR('RELPGA',10)

AjustaSX1()
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()	
Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local cTitulo	:= "Relatorio de Or็amentos Pagamentos Antecipados"


oReport := TReport():New("RelPgAnt",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)
oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao

oSection := TRSection():New(oReport,"Pagamentos",{"SUA","SE4",'SA3'})


	TRCell():New(oSection,"UA_NUM","SUA")
	TRCell():New(oSection,"UA_EMISSAO","SUA")
	TRCell():New(oSection,"UA_CLIENTE","SUA")
	TRCell():New(oSection,"UA_LOJA","SUA")
	TRCell():New(oSection,"UA_NOMECLI","SUA")
	TRCell():New(oSection,"A3_COD","SA3")
	TRCell():New(oSection,"A3_NOME","SA3")
	TRCell():New(oSection,"UA_CONDPG","SUA")
	TRCell():New(oSection,"UA_VALBRUT","SUA")
	
/*	oBreak1 := TRBreak():New(oSection,oSection:Cell("Z2_NUMNF"),"Total NF")

	TRFunction():New(oSection:Cell("Z2_QTDNF")  ,NIL,"SUM",oBreak1)
	TRFunction():New(oSection:Cell("Z2_QTDCONF"),NIL,"SUM",oBreak1)
	TRFunction():New(oSection:Cell("Z2_DIFEREN"),NIL,"SUM",oBreak1)
  */
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
		SELECT UA_NUM, UA_EMISSAO, UA_CLIENTE, UA_LOJA, UA_NOMECLI, A3_COD, A3_NOME, UA_CONDPG, UA_VALBRUT
		FROM %table:SUA% UA,%table:SE4% E4,%table:SA3% A3
		WHERE UA.%notDel%
		AND E4.%notDel%
		AND A3.%notDel%
		AND UA.UA_FILIAL = %xfilial:SUA%
		AND E4.E4_FILIAL = %xfilial:SE4%
		AND A3.A3_FILIAL = %xfilial:SA3%
		AND UA.UA_CONDPG = E4.E4_CODIGO
		AND E4_CTRADT = '1'
		AND UA.UA_OPER <> '1'
		AND UA.UA_NUMSC5 = ''
		AND UA.UA_CANC <> 'S'
		AND UA_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND UA.UA_VEND = A3.A3_COD
		ORDER BY UA_EMISSAO
	EndSql
	
	oReport:SetTitle('Relatorio de Or็amentos Pagamentos Antecipados - Periodo de ' + DtoC(MV_PAR01) + ' Ate ' + DtoC(MV_PAR02))

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

PutSx1(cPerg,'01','Emissao de  ?','','','mv_ch1','D',08, 0, 0,'G','',''   ,'','','mv_par01'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'02','Emissao Ate ?','','','mv_ch2','D',08, 0, 0,'G','',''   ,'','','mv_par02'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
Return NIL