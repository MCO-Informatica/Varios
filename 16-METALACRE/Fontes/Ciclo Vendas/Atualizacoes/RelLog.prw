#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelLog   บAutor  ณ Luiz     บ Data ณ  04/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rios de Log de Ciclo  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre - Protheus 11                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RelLog()
Local oReport
Private cPerg := PadR('RELLog',10)

AjustaSX1()
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()	
Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local cTitulo	:= "Relatorio de Acoes de Ciclo de Clientes"


oReport := TReport():New("RelLog",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo,.t.,,,,,,2)
oReport:cFontBody := 'Courier New'
oReport:nFontBody := 9         
oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao


oSection := TRSection():New(oReport,"Acoes",{"SZ5",'SZA'})

	TRCell():New(oSection,"Z5_DATA","SZ5")
	TRCell():New(oSection,"Z5_HORA","SZ5")
	TRCell():New(oSection,"Z5_CLIENTE","SZ5")
	TRCell():New(oSection,"Z5_LOJA","SZ5")
	TRCell():New(oSection,"Z5_NOMCLI","SZ5")
	TRCell():New(oSection,"Z5_USER","SZ5")
	TRCell():New(oSection,"Z5_NOMUSR","SZ5")
	TRCell():New(oSection,"Z5_ACAO","SZ5")
	TRCell():New(oSection,"Z5_CODMOT","SZ5")
	TRCell():New(oSection,"ZA_DESC","SZA")

	oSection:Cell("Z5_CLIENTE"):lHeaderSize := .F.
	oSection:Cell("Z5_LOJA"):lHeaderSize := .F.
	oSection:Cell("Z5_DATA"):lHeaderSize := .F.
	oSection:Cell("Z5_HORA"):lHeaderSize := .F.
	oSection:Cell("Z5_USER"):lHeaderSize := .F.

	oSection:Cell("Z5_CLIENTE"):nSize := 10
	oSection:Cell("Z5_LOJA"):nSize := 4
	oSection:Cell("Z5_DATA"):nSize := 12
	oSection:Cell("Z5_HORA"):nSize := 14
	oSection:Cell("Z5_USER"):nSize := 12
/*

	oBreak1 := TRBreak():New(oSection,oSection:Cell("Z2_NUMNF"),"Total NF")

	TRFunction():New(oSection:Cell("Z2_QTDNF"),NIL,"SUM",oBreak1 ,,'9999999',,.F.,.F.)
//	TRFunction():New(oSection:Cell("Z2_QTDCONF"),NIL,"SUM",oBreak1)
//	TRFunction():New(oSection:Cell("Z2_DIFEREN"),NIL,"SUM",oBreak1)

//	oSection:SetTotalInLine(.T.)
  */

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
		SELECT Z5.*, ZA.*
		FROM %table:SZ5% Z5,%table:SZA% ZA
		WHERE Z5_FILIAL = %xfilial:SZ5%
		AND ZA_FILIAL = %xfilial:SZA%
		AND Z5.%notDel%
		AND ZA.%notDel%
		AND ZA_COD = Z5_CODMOT
		AND Z5_DATA 	BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND Z5_HORA 	BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND Z5_USER		BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND Z5_CLIENTE	BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND Z5_LOJA		BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
		AND Z5_CODMOT 	BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		ORDER BY Z5_DATA, Z5_HORA, Z5_CLIENTE, Z5_LOJA
	EndSql
	
	oReport:SetTitle('Relatorio de Acoes de Ciclo de Clientes - Periodo de ' + DtoC(MV_PAR01) + ' Ate ' + DtoC(MV_PAR02))

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
PutSx1(cPerg,'03','Hora De        ?','','','mv_ch3','C',05, 0, 0,'G','',''   ,'','','mv_par03'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'04','Hora Ate       ?','','','mv_ch4','C',05, 0, 0,'G','',''   ,'','','mv_par04'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
PutSx1(cPerg,'05','Usuario  De    ?','','','mv_ch5','C',06, 0, 0,'G','','USR','','','mv_par05'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'06','Usuario  Ate   ?','','','mv_ch6','C',06, 0, 0,'G','','USR','','','mv_par06'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
PutSx1(cPerg,'07','Cliente de     ?','','','mv_ch7','C',06, 0, 0,'G','','SA1','','','mv_par07'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'08','Cliente Ate    ?','','','mv_ch8','C',06, 0, 0,'G','','SA1','','','mv_par08'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'09','Loja de        ?','','','mv_ch9','C',02, 0, 0,'G','',''   ,'','','mv_par09'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'10','Loja Ate       ?','','','mv_ch0','C',02, 0, 0,'G','',''   ,'','','mv_par10'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'11','Motivo De      ?','','','mv_chE','C',04, 0, 0,'G','','SZA','','','mv_par15'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'12','Motivo Ate     ?','','','mv_chF','C',04, 0, 0,'G','','SZA','','','mv_par16'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
Return NIL