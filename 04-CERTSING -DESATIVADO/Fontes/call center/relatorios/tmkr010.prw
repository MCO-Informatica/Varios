#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ TMKR010   ³ Autor ³ Tatiana Pontes      ³ Data ³ 19/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Relatorio de Faturamento Vendas SAC                    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TMKR010()

	Local oReport
	Local cPerg 	:= 'TMKR10'       
	Local cAlias 	:= 	GetNextAlias()
	
	AjustaSX1(cPerg)
	Pergunte(cPerg, .T.)

	oReport:=ReportDef(cAlias, cPerg)
	oReport:PrintDialog()
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ ReportDef	³ Autor ³ Tatiana Pontes    ³ Data ³ 19/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Funcao para criacao da estrutura do relatorio			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportDef(cAlias,cPerg)

	Local cTitle
	Local cHelp
	
	Local oReport
	Local oSection1                  
	Local aOrdem  
	
	cTitle 	:= "Relatório de Atendimentos"
	cHelp 	:= "Permite gerar relatório de atendimentos."        
		
	aOrdem  := { "Por Protocolo" }
	
	oReport := TReport():New('TMKR10',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
		
	oSection1 := TRSection():New(oReport,"Atendimentos",{"ADE","SC5","SD2","SB1","SU7","SU0"},aOrdem)

  	TRCell():New(oSection1,"Protocolo"				, "ADE", "Protocolo")
  	TRCell():New(oSection1,"DT_Abertura_Protocolo"	, "ADE", "DT_Abertura_Protocolo")
  	TRCell():New(oSection1,"HR_Abertura"			, "ADE", "HR_Abertura")
 	TRCell():New(oSection1,"Emissao_Pedido"			, "SC5", "Emissao_Pedido")
  	TRCell():New(oSection1,"Emissao_Nota_Fiscal"	, "SD2", "Emissao_Nota_Fiscal")
  	TRCell():New(oSection1,"Valor_Total"			, "SD2", "Valor_Total")
  	TRCell():New(oSection1,"Status_Gar"				, "ADE", "Status_Gar")
  	TRCell():New(oSection1,"Forma_Pagamento"		, "SC5", "Forma_Pagamento")
  	TRCell():New(oSection1,"Pedido_GAR"				, "ADE", "Pedido_GAR")
  	TRCell():New(oSection1,"Email"					, "ADE", "Email")
  	TRCell():New(oSection1,"DDD"					, "ADE", "DDD")
  	TRCell():New(oSection1,"Telefone"				, "ADE", "Telefone")
  	TRCell():New(oSection1,"Desc_Produto"			, "SB1", "Desc_Produto")
  	TRCell():New(oSection1,"Analista"				, "ADE", "Analista")
  	TRCell():New(oSection1,"Nome_Analista"			, "SU7", "Nome_Analista")
  	TRCell():New(oSection1,"Equipe"					, "ADE", "Equipe")
  	TRCell():New(oSection1,"Nome_Equipe"			, "SU0", "Nome_Equipe")
  	TRCell():New(oSection1,"Cpf_Titular"			, "ADE", "Cpf_Titular")
	TRCell():New(oSection1,"Email_Titular"			, "ADE", "Email_Titular")
  	TRCell():New(oSection1,"Nome_Titular"			, "ADE", "Nome_Titular")
  	TRCell():New(oSection1,"Prod_Gar"				, "ADE", "Prod_Gar")
  	TRCell():New(oSection1,"Rz_Social"				, "ADE", "Rz_Social")

Return(oReport)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ ReportPrint ³ Autor ³ Tatiana Pontes    ³ Data ³ 19/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Funcao para montagem dos dados do relatorio				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportPrint(oReport,cAlias)

	Local oSecao1	:= oReport:Section(1)
	
	oSecao1:BeginQuery()
    
 	BeginSql Alias cAlias
 	
 		SELECT
			ADE.ADE_CODIGO AS Protocolo,
			ADE.ADE_DATA AS DT_Abertura_Protocolo,
			ADE.ADE_HORA AS HR_Abertura,
			SC5.C5_EMISSAO AS Emissao_Pedido,
			SD2.D2_EMISSAO AS Emissao_Nota_Fiscal, 
			SUM(SD2.D2_TOTAL) AS Valor_Total,
			ADE.ADE_XSTATG AS STATUS_GAR,
			CASE 	WHEN SC5.C5_TIPMOV = 1 THEN 'BOLETO'
					WHEN SC5.C5_TIPMOV = 2 THEN 'CARTAO'
					ELSE 'OUTROS' 
			END AS FORMA_PAGAMENTO,
			ADE.ADE_PEDGAR AS Pedido_GAR, 
			ADE.ADE_EMAIL2 AS Email, 
			ADE.ADE_DDDRET AS DDD, 
			ADE.ADE_TELRET AS TELEFONE, 
			SB1.B1_DESC AS Desc_Produto,
			ADE.ADE_OPERAD AS Analista,
			SU7.U7_NOME AS Nome_Analista,
			ADE.ADE_GRUPO AS Equipe, 
			SU0.U0_NOME AS NOME_EQUIPE, 
			ADE.ADE_XCPFTI AS Cpf_Titular,
			ADE.ADE_XMAILT AS Email_Titular,
			ADE.ADE_XNOMTI AS Nome_Titular, 
			ADE.ADE_XPRODG AS Prod_Gar, 
			ADE.ADE_XRZSOC AS Rz_Social
		FROM %table:SD2% SD2,
			 %table:SC6% SC6
			 	LEFT OUTER JOIN %table:SC5% SC5 ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC5.%notDel%,
			 %table:SF4% SF4, 
			 %table:ADE% ADE
				LEFT OUTER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = ADE.ADE_FILIAL AND SB1.B1_COD = ADE.ADE_CODSB1 AND SB1.%notDel%
				LEFT OUTER JOIN %table:SUL% SUL ON SUL.UL_TPCOMUN = ADE.ADE_TIPO AND SUL.%notDel%
				LEFT OUTER JOIN %table:SU7% SU7 ON SU7.U7_COD = ADE.ADE_OPERAD 	AND SU7.%notDel%
				LEFT OUTER JOIN %table:SU0% SU0 ON SU0.U0_CODIGO = ADE.ADE_GRUPO AND SU0.%notDel%
		WHERE 
				SD2.D2_FILIAL = '02' AND 
				SD2.D2_EMISSAO >= %Exp:mv_par01% AND
				SD2.D2_EMISSAO <= %Exp:mv_par02% AND 
				SC6.C6_FILIAL = %xFilial:SC6%  AND
				SC6.C6_NUM = SD2.D2_PEDIDO AND
				SC6.C6_ITEM   = SD2.D2_ITEMPV AND
				SC6.C6_PEDGAR <> ' ' AND
				SF4.F4_CODIGO = SD2.D2_TES AND
				SF4.F4_DUPLIC = 'S' AND
				ADE.ADE_FILIAL = %xFilial:ADE%  AND
				ADE.ADE_PEDGAR = SC6.C6_PEDGAR AND
				ADE.ADE_PEDGAR <> ' ' AND
				ADE.ADE_GRUPO = %Exp:mv_par03% AND
				SD2.%notDel% AND
				SC6.%notDel% AND
				SF4.%notDel% AND
				ADE.%notDel%
		GROUP BY
				ADE.ADE_CODIGO, ADE.ADE_DATA, ADE.ADE_HORA, SC5.C5_EMISSAO, SD2.D2_EMISSAO, ADE.ADE_XSTATG, SC5.C5_TIPMOV,
				ADE.ADE_PEDGAR, ADE.ADE_EMAIL2, ADE.ADE_DDDRET, ADE.ADE_TELRET, SB1.B1_DESC, ADE.ADE_OPERAD, SU7.U7_NOME,
				ADE.ADE_GRUPO, SU0.U0_NOME, ADE.ADE_XCPFTI, ADE.ADE_XMAILT, ADE.ADE_XNOMTI, ADE.ADE_XPRODG, ADE.ADE_XRZSOC
	
	EndSql

	oSecao1:EndQuery()
	
	oReport:SetMeter((cAlias)->(RecCount()))
	
	oSecao1:Print()
		
 	(cAlias)->(dbCloseArea())     

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ AjustaSX1	³ Autor ³ Tatiana Pontes    ³ Data ³ 19/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Funcao para criacao das perguntas do relatorio			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function AjustaSX1(cPerg)

	aHlpPor := {}
	Aadd( aHlpPor, "Defina a Data Inicial"	)
	Aadd( aHlpPor, ""	)
	PutSx1(cPerg,	"01","Data Inicial de?","","","mv_ch1","D",TamSX3("D2_EMISSAO")[1],0,1,;   
					"G","","","","S","mv_par01","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)
	
	aHlpPor := {}
	Aadd( aHlpPor, "Defina a Data Final"	)
	Aadd( aHlpPor, ""		)
	PutSx1(cPerg,	"02","Data Final ate?","","","mv_ch2","D",TamSX3("D2_EMISSAO")[1],0,1,;   
					"G","","","","S","mv_par02","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)
	
	aHlpPor := {}
	Aadd( aHlpPor, "Defina o Grupo"	)
	Aadd( aHlpPor, ""	)
	PutSx1(cPerg,	"03","Grupo?","","","mv_ch3","C",TamSX3("ADE_GRUPO")[1],0,1,;   
					"G","","","","S","mv_par03","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)
	
Return(.T.)