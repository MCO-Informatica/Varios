#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelVendas1   บAutor  ณ Luiz     บ Data ณ  09/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rios Fechamento Neg๓cios   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MetaLacre - Protheus 11                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RelVendas1()
Local oReport
Private cPerg := PadR('RELVND1',10)

AjustaSX1()
Pergunte(cPerg,.F.)
If TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()	
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local cTitulo	:= "Relatorio de Vendas"


oReport := TReport():New("RelVnd1",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)
oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao

oSection := TRSection():New(oReport,"Vendas",{"SA1","SA3",'SC5','SD2','SB1'})

	TRCell():New(oSection,"C5_VEND1","SC5")
	TRCell():New(oSection,"A3_NOME","SA3")
	TRCell():New(oSection,"A1_EST","SA1")
	TRCell():New(oSection,"B1_GRUPO","SB1")
	TRCell():New(oSection,"B1_COD","SB1")
	TRCell():New(oSection,"C6_OPC","SC6")
	TRCell():New(oSection,"C5_EMISSAO","SC5")
	TRCell():New(oSection,"D2_QUANT","SD2")
	TRCell():New(oSection,"D2_PRCVEN","SD2")
	TRCell():New(oSection,"C6_VALOR","SC6")

	oBreak1 := TRBreak():New(oSection,oSection:Cell("C5_VEND1"),"T O T A L  V E N D E D O R:",.F.,)
	oBreak2 := TRBreak():New(oSection,oSection:Cell("A1_EST"),"Sub Total UF")
	oBreak3 := TRBreak():New(oSection,oSection:Cell("B1_GRUPO"),"Sub Total Grupo Produtos")

	TRFunction():New(oSection:Cell("D2_QUANT")  ,NIL,"SUM",oBreak1 ,/*Titulo*/,'9999999',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell("C6_VALOR"),NIL,"SUM",oBreak1)

	TRFunction():New(oSection:Cell("D2_QUANT")  ,NIL,"SUM",oBreak2 ,/*Titulo*/,'9999999',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell("C6_VALOR"),NIL,"SUM",oBreak2)

	TRFunction():New(oSection:Cell("D2_QUANT")  ,NIL,"SUM",oBreak3 ,/*Titulo*/,'9999999',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell("C6_VALOR"),NIL,"SUM",oBreak3)

	oSection:Cell("C5_VEND1"):lHeaderSize := .F.
	oSection:Cell("C5_VEND1"):nSize := 6	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection:Cell("C6_OPC"):nSize := 20		// Ajuste do Campo Opcional para o Tamanho de 20 Caracteres
	oSection:Cell("C5_EMISSAO"):lHeaderSize := .F.
	oSection:Cell("C5_EMISSAO"):nSize := 10	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection:Cell("D2_QUANT"):SetPicture('9999999')
	oSection:SetTotalInLine(.T.)
	

Return oReport

Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local cPart
Local cFiltro   := ""

#IFDEF TOP

	cLike := "%'%"+AllTrim(MV_PAR09)+"%'%"
                                                   
	//Transforma parametros do tipo Range em expressao SQL para ser utilizada na query 
	MakeSqlExpr(cPerg)
	

	oSection:BeginQuery()
	
	BeginSql alias "QRYVND"                                                                                                             
		SELECT C5_VEND1, A3_NOME, A1_EST, B1_GRUPO, B1_COD, B1_DESC, C6_OPC, C5_EMISSAO, SUM(C6_QTDVEN) D2_QUANT, AVG(C6_PRCVEN) D2_PRCVEN, SUM(C6_VALOR) D2_TOTAL
		FROM %table:SC5% C5,%table:SA1% A1,%table:SA3% A3,%table:SB1% B1,%table:SC6% C6,%table:SF4% F4
		WHERE C5_FILIAL = %xfilial:SC5%
		AND B1_FILIAL = %xfilial:SB1%
		AND C6_FILIAL = %xfilial:SC6%
		AND F4_FILIAL = %xfilial:SF4%
		AND A1_FILIAL = %xfilial:SA1%
		AND A1.%notDel%
		AND C5.%notDel%
		AND C6.%notDel%
		AND B1.%notDel%
		AND A3.%notDel%
		AND F4.%notDel%
		AND C5_NUM = C6_NUM
		AND C5_FILIAL = C6_FILIAL
		AND C5_CLIENT = A1_COD
		AND C5_LOJACLI = A1_LOJA
		AND C6_PRODUTO = B1_COD
		AND C5_VEND1 = A3_COD
		AND C5_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND C5_VEND1 BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND A1_EST BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND B1_GRUPO BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND C6_OPC LIKE %Exp:cLike%
		AND B1_COD BETWEEN %Exp:mv_par10% AND %Exp:mv_par11%
		AND F4_CODIGO = C6_TES
		AND F4_ESTOQUE = 'S'
		AND C5_PEDWEB = ''
		AND C5_TIPO = 'N'
		AND F4_DUPLIC = 'S'
		GROUP BY C5_VEND1,A3_NOME,A1_EST,B1_GRUPO,B1_COD,B1_DESC,C6_OPC,C5_EMISSAO
		ORDER BY C5_VEND1, A1_EST, B1_GRUPO, B1_COD, C5_EMISSAO
	EndSql
	
	oReport:SetTitle('Relatorio de Vendas - Periodo de ' + DtoC(MV_PAR01) + ' Ate ' + DtoC(MV_PAR02))

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
PutSx1(cPerg,'05','Uf De          ?','','','mv_ch5','C', 2, 0, 0,'G','',''   ,'','','mv_par05'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'06','Uf Ate         ?','','','mv_ch6','C', 2, 0, 0,'G','',''   ,'','','mv_par06'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'07','Grupo De       ?','','','mv_ch7','C', 4, 0, 0,'G','','SBM','','','mv_par07'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'08','Grupo Ate      ?','','','mv_ch8','C', 4, 0, 0,'G','','SBM','','','mv_par08'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'09','Parte Opcinais ?','','','mv_ch9','C',10, 0, 0,'G','',''   ,'','','mv_par09'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'10','Produto De     ?','','','mv_chA','C',15, 0, 0,'G','','SB1','','','mv_par10'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'11','Produto Ate    ?','','','mv_chB','C',15, 0, 0,'G','','SB1','','','mv_par11'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
Return NIL