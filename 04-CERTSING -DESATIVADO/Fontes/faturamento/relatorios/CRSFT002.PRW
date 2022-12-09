#Include "Totvs.ch"
#Include "Topconn.ch"

//+----------------------------------------------------------------+
//| Rotina | CRSFT002 | Autor | Renato Ruy     | Data | 12/02/2014 |
//+----------------------------------------------------------------+
//| Descr. | Relatório de Pedidos Faturados                        |
//| Update | Inclusão de campos(TES,CFOP,Vendedor),			       |
//|        | criação de pergunte para filtrar a origem do Pedido.  |
//|        | Rafael Beghini - 10/04/2015						   |
//+----------------------------------------------------------------+
//| Uso    | CertiSign - Faturamento/Fiscal                        |
//+----------------------------------------------------------------+
User Function CRSFT002()
	Local   nVarLen :=	SetVarNameLen(100)
	Local   oReport 
	Private cPerg	  := "CSFTO8"
	
	//ValidPerg()
	CriaSx1( cPerg )
	
	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()
	
	SetVarNameLen(nVarLen)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³CRSFT002 ºAutor  ³Renato Ruy			 º Data ³  18/12/2013 º±±
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
	Local cDescricao	:= "Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."
	      cDescricao	+= "Relação dos Pedidos faturados."
	
	//Objeto do Relatório
	oReport	:=	TReport():New("CSFTO8","Relatorio Ped. Faturados", cPerg, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)
	
	//Seções Contas a Receber, Cliente , Naturezas
	oSection	:= TRSection():New(oReport, "Pedidos"	, {"SC5","SA1"})
	
	/*/Define a Ordem
	TROrder():New(oParent  , uOrder  , cTitle                        	, cAlias  ) */
	//TROrder():New(oSection, "" 		, "Matricula x Salario" 			,         )
	
	//Celulas de Impressão - SC5 - Cab.Pedido de Venda
	TRCell():New(oSection, "C5_FILIAL"	   		, "SC5", "Filial"				,							,02)
	TRCell():New(oSection, "C5_NUM"				, "SC5", "Pedido"				,							,06)
	TRCell():New(oSection, "C5_ATDTLV"	  		, "SC5", "Atend. TLV."			,							,06)
	TRCell():New(oSection, "C5_NUMATEX"	  		, "SC5", "Aten Externo"		,							,09)
	TRCell():New(oSection, "C5_CHVBPAG"	  		, "SC5", "Ped. Gar"			,							,10)
	TRCell():New(oSection, "C5_XORIGPV"	  		, "SC5", "Origem P.V."			,							,15)
	TRCell():New(oSection, "C5_EMISSAO"			, "SC5", "Dt. Emissão"			,"@D"						,08)
	TRCell():New(oSection, "DATALIB"			, "SC5", "Dt. Liberação"		,"@D"						,08)
	TRCell():New(oSection, "C6_NOTA"			, "SC5", "Nota"				,							,09)
	TRCell():New(oSection, "C6_SERIE"			, "SC5", "Série"				,							,03)
	TRCell():New(oSection, "C5_VEND1"			, "SC5", "Cód. Vendedor"		,							,06)
	TRCell():New(oSection, "NOMEVEND"			, "SC5", "Nome Vendedor"		,							,40)
	TRCell():New(oSection, "C6_TES"			     , "SC5", "TES"				,							,03)
	TRCell():New(oSection, "C6_CF"			     , "SC5", "CFOP"				,							,10)
	TRCell():New(oSection, "C6_DATFAT"			, "SC5", "Dt.Faturamento"		,"@D"						,08)
	TRCell():New(oSection, "C5_CLIENTE"			, "SC5", "Cod.Cliente"			,							,06)
	TRCell():New(oSection, "A1_NOME"			, "SA1", "Razão Social"		,							,40)
	TRCell():New(oSection, "C5_CONDPAG"			, "SC5", "Cond. Pagto" 	   	,							,03)
	TRCell():New(oSection, "C5_XNATURE"			, "SC5", "Natureza"	   		,							,10)
	TRCell():New(oSection, "VALORTOT"			, "SC5", "Total Pedido "  	 	,"@E 999,999,999.99"			,12)
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRSFT001  ºAutor  ³Renato Ruy Bernardoº Data ³ 18/12/2013   º±±
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
	Local oSection   := oReport:Section(1)
	Local oBreak     := Nil
	Local cCpoBreak  := ""
	Local cDescBreak := ""
	Local cOrdem     := ""
	Local cRet       := ""
	Local cMvp07     := ""
	Local i          := 0
	Local nOrdem     := oSection:GetOrder()
	
	If ! Empty(Mv_par07)
		cMvp07 := Mv_par07
		For i:=1 To Len(cMvp07)
			If Len(cRet) == 0
				cRet += Substring(cMvp07,i,1)
			Else
				cRet += "','"+Substring(cMvp07,i,1)
			EndIf
		Next
		If AT( '2', cRet ) > 0
			cRet += "','A"
		EndIF
	EndIf
	
	//Transforma parâmetros do tipo Range em expressão SQL para ser utilizadana query.
	MakeSqlExpr(cPerg,cRet)
	
	oSection:BeginQuery()
	BeginSql Alias "QCRSFT002"
		Column C5_EMISSAO	As Date
		Column DATALIB	As Date
		Column C6_DATFAT	As Date
	
		%NoParser%
		
		SELECT 
	        C5_FILIAL,
	        C5_NUM,
	        C5_ATDTLV,
	        C5_NUMATEX,
	        C5_XORIGPV,
	        C5_EMISSAO,
	        C5_CLIENTE,
	        A1_NOME,
	        C5_CONDPAG,
	        C5_XNATURE,
	        C5_TOTPED,
	        C6_NOTA,
	        C6_SERIE,
	        C6_DATFAT,
	        (SELECT C9_DATALIB FROM %Table:SC9% SC9 WHERE C9_FILIAL = SC5.C5_FILIAL AND C9_PEDIDO = SC5.C5_NUM AND ROWNUM = 1 AND SC9.%NOTDEL%) DATALIB,
	        Sum(C6_VALOR) VALORTOT,
	        C6_TES,
	        C6_CF,
	        C5_CHVBPAG,
	        C5_VEND1,
	        (SELECT A3_NOME FROM %Table:SA3% SA3 WHERE C5_VEND1 = A3_COD AND SA3.%NOTDEL% ) NOMEVEND
		FROM %Table:SC5% SC5
		LEFT JOIN %Table:SA1% SA1  ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.%NOTDEL%
		INNER JOIN %Table:SC6% SC6 ON C6_FILIAL = C5_FILIAL AND C6_NUM    = C5_NUM AND SC6.%NOTDEL% AND 
								C6_TES IN ('502','509','602','603','701','801','901','903') AND
								C6_DATFAT BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%
		WHERE 
		C5_FILIAL  BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% AND
		C5_EMISSAO BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04% AND
		C5_XORIGPV IN ( %EXP:cRet% ) AND
		(C6_NOTA != ' ' Or C5_LIBEROK ='E' ) AND 
		C5_BLQ = ' ' AND
		C5_XNATURE NOT IN ('FT020001','FT020007') AND
		SC5.%NOTDEL%
		Group By C5_FILIAL,C5_NUM,C5_ATDTLV,C5_NUMATEX,C5_XORIGPV,C5_EMISSAO,C5_CLIENTE,A1_NOME,C5_CONDPAG,C5_XNATURE,
			     C5_TOTPED,C6_NOTA,C6_SERIE,C6_DATFAT,C6_TES,C6_CF,C5_CHVBPAG,C5_VEND1
		
	EndSql
	oSection:EndQuery()                                        
	
	//Imprime
	oSection:Print()
Return

//+----------------------------------------------------------------+
//| Rotina | CriaSx1 | Autor | Rafael Beghini | Data | 10/04/2015  |
//+----------------------------------------------------------------+
//| Descr. | Cria as Perguntas usadas no parametro.                |
//|        |                                                       |
//+----------------------------------------------------------------+
Static Function CriaSx1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}
	
	/***
	Característica do vetor p/ utilização da função SX1
	---------------------------------------------------
	[n,1] --> texto da pergunta
	[n,2] --> tipo do dado
	[n,3] --> tamanho
	[n,4] --> decimal
	[n,5] --> objeto G=get ou C=choice
	[n,6] --> validacao
	[n,7] --> F3
	[n,8] --> definicao 1
	[n,9] --> definicao 2
	[n,10] -> definicao 3
	[n,11] -> definicao 4
	[n,12] -> definicao 5
	***/
	aAdd(aP,{"Filial de"                  ,"C", 6,0,"G",""                    ,"SM0",""   ,""   ,"","",""})
	aAdd(aP,{"Filial ate"                 ,"C", 6,0,"G","(mv_par02>=mv_par01)","SM0",""   ,""   ,"","",""})
	aAdd(aP,{"Emissão de"                 ,"D", 8,0,"G",""                    ,""   ,""   ,""   ,"","",""})
	aAdd(aP,{"Emissão ate"                ,"D", 8,0,"G","(mv_par04>=mv_par03)",""   ,""   ,""   ,"","",""})
	aAdd(aP,{"Faturamento de"             ,"D", 8,0,"G",""                    ,""   ,""   ,""   ,"","",""})
	aAdd(aP,{"Faturamento ate"            ,"D", 8,0,"G","(mv_par06>=mv_par05)",""   ,""   ,""   ,"","",""})
	aAdd(aP,{"Origem Pedido"              ,"C",10,0,"G","U_FT02Opc()"         ,""   ,""   ,""   ,"","",""})
		
	aAdd(aHelp,{"Informe a filial inicial."})
	aAdd(aHelp,{"Informe a filial final."})	
	aAdd(aHelp,{"Digite a data de emissão incial."})
	aAdd(aHelp,{"Digite a data de emissão final."})
	aAdd(aHelp,{"Digite a data de faturamento incial."})
	aAdd(aHelp,{"Digite a data de faturamento final."})
	aAdd(aHelp,{"Selecione a origem dos pedidos","que deseja filtrar."})
	
	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
		PutSx1(cPerg,;
		cSeq,;
		aP[i,1],aP[i,1],aP[i,1],;
		cMvCh,;
		aP[i,2],;
		aP[i,3],;
		aP[i,4],;
		0,;
		aP[i,5],;
		aP[i,6],;
		aP[i,7],;
		"",;
		"",;
		cMvPar,;
		aP[i,8],aP[i,8],aP[i,8],;
		"",;
		aP[i,9],aP[i,9],aP[i,9],;
		aP[i,10],aP[i,10],aP[i,10],;
		aP[i,11],aP[i,11],aP[i,11],;
		aP[i,12],aP[i,12],aP[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
	Next i
	
Return

User Function FT02Opc()
	Local aRet := {}
	Local aParamBox := {}
	Local i := 0
	Local cRet := ''
	Local aDados := {'1','2','3','4','5','6','7','8','9','0'}
	Local nMv := 0
	Local aMvPar := {}
		
	//1=Manual;2=Varejo;3=Hardware Avulso;4=Televendas;5=Atend.Externo;6=Contratos;7=Port.Assinaturas;8=Cursos;9=Port.SSL;0=Pto.Movel 
	aAdd(aParamBox,{5,"Manual ?"          ,('1' $ MV_PAR07),50,"",.F.})
	aAdd(aParamBox,{5,"Varejo ?"          ,('2' $ MV_PAR07),50,"",.F.})
	aAdd(aParamBox,{5,"Hardware Avulso ?" ,('3' $ MV_PAR07),50,"",.F.})
	aAdd(aParamBox,{5,"Televendas ?"      ,('4' $ MV_PAR07),50,"",.F.})
	aAdd(aParamBox,{5,"Atend.Externo ?"   ,('5' $ MV_PAR07),50,"",.F.})
	aAdd(aParamBox,{5,"Contratos ?"       ,('6' $ MV_PAR07),50,"",.F.})
	aAdd(aParamBox,{5,"Port.Assinaturas ?",('7' $ MV_PAR07),50,"",.F.})
	aAdd(aParamBox,{5,"Cursos ?"          ,('8' $ MV_PAR07),50,"",.F.})
	aAdd(aParamBox,{5,"Port.SSL ?"        ,('9' $ MV_PAR07),50,"",.F.})
	aAdd(aParamBox,{5,"Pto.Movel ?"       ,('0' $ MV_PAR07),50,"",.F.})
	
	For nMv := 1 To 40
		AAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv
	
	If ParamBox(aParamBox,"Seleção de Origem de Pedidos..",@aRet)
	   For i:=1 To Len(aRet)
	   	cRet += Iif(aRet[i],aDados[i],'')
	   Next 
	Endif

	 For nMv := 1 To Len( aMvPar )
	 	&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	 Next nMv
	
	MV_PAR07 := cRet

// Tipo 5 -> Somente CheckBox
//           [2]-Descricao
//           [3]-Indicador Logico contendo o inicial do Check
//           [4]-Tamanho do Radio
//           [5]-Validacao
//           [6]-Flag .T./.F. Parametro Obrigatorio ?
Return(.T.)