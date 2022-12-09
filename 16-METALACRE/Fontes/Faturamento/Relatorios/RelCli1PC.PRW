#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelCli1PC   บAutor  ณ Luiz     บ Data ณ  17/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Alteracao do fonte de impressao de relatorio customizado   บฑฑ
ฑฑบ          ณ do Orcamento                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MetaLacre - Protheus 11                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Cli1PC()
Local oReport
Private cPerg := PadR('CLI1PC',10)

AjustaSX1()
Pergunte(cPerg,.T.)
If TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()	
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local cTitulo	:= Iif(MV_PAR07==1,"Relatorio de Clientes Abertos/Primeira Compra","Relatorio de Prospects")


oReport := TReport():New("RelCli1PC",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)
oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao

If MV_PAR07==1
	oSection := TRSection():New(oReport,"Clientes",{"SA1","SA3"})

	TRCell():New(oSection,"A1_VEND","SA1")
	TRCell():New(oSection,"A3_NOME","SA3")
	TRCell():New(oSection,"A1_COD","SA1","Cliente")
	TRCell():New(oSection,"A1_LOJA","SA1")
	TRCell():New(oSection,"A1_NOME","SA1")
	TRCell():New(oSection,"A1_PRICOM","SA1")
	TRCell():New(oSection,"A1_CONTATO","SA1")
	TRCell():New(oSection,"A1_DDD","SA1")
	TRCell():New(oSection,"A1_TEL","SA1")

	oBreak := TRBreak():New(oSection,oSection:Cell("A1_VEND"),"Sub Total Vendedores")

Else
	oSection := TRSection():New(oReport,"Prospect",{"SUS","SA3"})

	TRCell():New(oSection,"US_VEND","SUS")
	TRCell():New(oSection,"A3_NOME","SA3")
	TRCell():New(oSection,"US_COD","SUS","Prospect")
	TRCell():New(oSection,"US_LOJA","SUS")
	TRCell():New(oSection,"US_NOME","SUS")
	TRCell():New(oSection,"US_DATCAD","SUS")
	TRCell():New(oSection,"US_DDD","SUS")
	TRCell():New(oSection,"US_TEL","SUS")
//	TRCell():New(oSection,"US_MIDIA","SUS")
	TRCell():New(oSection,"UH_DESC","SUH")
	
	oSection:Cell("US_DATCAD"):lAutoSize := .f.
	oSection:Cell("US_DATCAD"):lHeaderSize := .f.
	
	oBreak := TRBreak():New(oSection,oSection:Cell("US_VEND"),"Sub Total Vendedores")
Endif

If MV_PAR07 == 1
	TRFunction():New(oSection:Cell("A1_COD"),NIL,"COUNT",oBreak)
Else
	TRFunction():New(oSection:Cell("US_COD"),NIL,"COUNT",oBreak)
Endif
Return oReport

Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local cPart
Local cFiltro   := ""

#IFDEF TOP

	//Transforma parametros do tipo Range em expressao SQL para ser utilizada na query 
	MakeSqlExpr(PadR('CLI1PC',10))
	
	If MV_PAR07 == 1

		oSection:BeginQuery()
	
		BeginSql alias "QRYSA1"
			SELECT A1_VEND, A3_NOME, A1_PRICOM, A1_COD, A1_LOJA, A1_NOME, A1_PESSOA, A1_CGC, A1_INSCR, A1_DDD, A1_TEL, A1_EMAIL, A1_CONTATO 
			FROM %table:SA1% SA1
			LEFT JOIN %table:SA3% SA3 ON A3_COD = A1_VEND AND SA3.%notDel% AND A3_FILIAL = %xfilial:SA3% AND A3_COD BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
			WHERE A1_PRICOM BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND A1_FILIAL = %xfilial:SA1%
			AND A1_EST BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% 
			AND A1_IDCWEB = ''                  
			AND SA1.%notDel%
			AND SA1.A1_COD <> '002'
			AND A1_PESSOA = 'J'
			ORDER BY A1_VEND, A1_PRICOM
		EndSql
	
		/*
		Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
		parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
		pela funcao MakeSqlExpr para serem adicionados a query
		*/
		oSection:EndQuery()
    Else
		oSection:BeginQuery()
	
		BeginSql alias "QRYSUS"
			SELECT US_VEND, A3_NOME, US_COD, US_LOJA, US_NOME, US_DDD, US_TEL, US_EMAIL, US_MIDIA, UH_DESC, US_DATCAD
			FROM %table:SUS% SUS
			LEFT JOIN %table:SA3% SA3 ON A3_COD = US_VEND AND SA3.%notDel% AND A3_FILIAL = %xfilial:SA3% AND A3_COD BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
			LEFT JOIN %table:SUH% SUH ON UH_MIDIA = US_MIDIA AND SUH.%notDel% AND UH_FILIAL = %xfilial:SUH% 
			WHERE US_DATCAD BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND US_FILIAL = %xfilial:SUS%
			AND US_EST BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% 
			AND SUS.%notDel%
			ORDER BY US_VEND, US_DATCAD
		EndSql
	
		/*
		Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
		parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
		pela funcao MakeSqlExpr para serem adicionados a query
		*/
		oSection:EndQuery()
    Endif
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
PutSx1(cPerg,'05','Uf De          ?','','','mv_ch5','C', 2, 0, 0,'G','',''   ,'','','mv_par05'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'06','Uf Ate         ?','','','mv_ch6','C', 2, 0, 0,'G','',''   ,'','','mv_par06'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'07','Tipo Cadastro  ?','','','mv_ch7','N', 1, 0, 1,'C','',''   ,'','','mv_par07','Clientes','','','','Prospects','','','','','','','','','','','','',aHelpPor07,aHelpPor07,aHelpPor07)
Return NIL