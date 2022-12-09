#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelConfNF   บAutor  ณ Luiz     บ Data ณ  30/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rios Conferencia NF Entradas   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MetaLacre - Protheus 11                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RelConfNF()
Local oReport
Private cPerg := PadR('RELCNNF',10)

AjustaSX1()
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()	
Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local cTitulo	:= "Relatorio de Conferencia Nota Fiscal Entrada"


oReport := TReport():New("RelCnNf",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)
oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao

oSection := TRSection():New(oReport,"Conferencia",{"SZ2","SA3",'SC5','SD2','SB1'})

	TRCell():New(oSection,"Z2_DATA","SZ2")
	TRCell():New(oSection,"Z2_CODFOR","SZ2")
	TRCell():New(oSection,"Z2_DESCFOR","SZ2")
	TRCell():New(oSection,"Z2_NUMNF","SZ2")
	TRCell():New(oSection,"Z2_CODPROD","SZ2")
	TRCell():New(oSection,"Z2_DESCPRO","SZ2")
	TRCell():New(oSection,"Z2_QTDNF","SZ2",'Qtde Nota','9,999,999,999')
	TRCell():New(oSection,"Z2_QTDCONF","SZ2",'Qtde Conf.','9,999,999,999')
	TRCell():New(oSection,"Z2_DIFEREN","SZ2",'Diferenca','9,999,999,999')
	TRCell():New(oSection,"Z2_PDIF","QRYCNF",'(%)','@E 9,999.99')
	TRCell():New(oSection,"Z2_PSFORN","SZ2")
	TRCell():New(oSection,"Z2_PSCONF","SZ2")
	TRCell():New(oSection,"Z2_CONFERE","SZ2")
	
	oSection:Cell("Z2_PDIF"):lHeaderSize := .F.
   	oSection:Cell("Z2_PDIF"):nSize := 8	
	oSection:Cell("Z2_DATA"):lHeaderSize := .F.
	oSection:Cell("Z2_NUMNF"):lHeaderSize := .F.
   	oSection:Cell("Z2_NUMNF"):nSize := 10	
	oSection:Cell("Z2_CODPROD"):lHeaderSize := .F.
   	oSection:Cell("Z2_CODPROD"):nSize := 20	
   	oSection:Cell("Z2_DESCPRO"):nSize := 15	
   	oSection:Cell("Z2_DESCFOR"):nSize := 15	


	oBreak1 := TRBreak():New(oSection,oSection:Cell("Z2_NUMNF"),"Total NF")

	TRFunction():New(oSection:Cell("Z2_QTDNF")  ,NIL,"SUM",oBreak1)
	TRFunction():New(oSection:Cell("Z2_QTDCONF"),NIL,"SUM",oBreak1)
	TRFunction():New(oSection:Cell("Z2_DIFEREN"),NIL,"SUM",oBreak1)

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
		SELECT Z2_DATA,Z2_CODFOR,Z2_NUMNF,Z2_CODPROD,Z2_QTDNF,Z2_QTDCONF,(Z2_QTDCONF-Z2_QTDNF) Z2_DIFEREN,ROUND(((Z2_QTDCONF/Z2_QTDNF)*100)-100,2) Z2_PDIF,Z2_PSFORN,Z2_PSCONF,Z2_CONFERE,Z2_DESCFOR,Z2_DESCPRO
		FROM %table:SZ2% Z2,%table:SB1% B1
		WHERE Z2_FILIAL = %xfilial:SZ2%
		AND B1_FILIAL = %xfilial:SB1%
		AND Z2.%notDel%
		AND B1.%notDel%
		AND B1_COD = Z2_CODPROD
		AND Z2_DATA 	BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND Z2_CODFOR 	BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND Z2_CODPROD	BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND B1_GRUPO	BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND Z2_NUMNF	BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
		ORDER BY Z2_DATA, Z2_NUMNF, Z2_CODPROD
	EndSql
	
	oReport:SetTitle('Relatorio de Conferencia Recebimento - Periodo de ' + DtoC(MV_PAR01) + ' Ate ' + DtoC(MV_PAR02))

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
PutSx1(cPerg,'05','Produto De     ?','','','mv_ch5','C',15, 0, 0,'G','','SB1','','','mv_par05'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'06','Produto Ate    ?','','','mv_ch6','C',15, 0, 0,'G','','SB1','','','mv_par06'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'07','Grupo De       ?','','','mv_ch7','C', 4, 0, 0,'G','','SBM','','','mv_par07'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'08','Grupo Ate      ?','','','mv_ch8','C', 4, 0, 0,'G','','SBM','','','mv_par08'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'09','Nota De        ?','','','mv_ch9','C', 9, 0, 0,'G','',''   ,'','','mv_par09'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'10','Nota Ate       ?','','','mv_chA','C', 9, 0, 0,'G','',''   ,'','','mv_par10'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
Return NIL