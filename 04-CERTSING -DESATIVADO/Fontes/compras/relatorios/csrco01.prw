#Include "Totvs.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³CRCO001 ºAutor  ³Renato Ruyº 				Data ³  16/09/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Nfs de Serviço.						          º±±
±±º          ³		                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign - Contábil			                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRCO003()
Local 	nVarLen	:=	SetVarNameLen(100)
Local 	oReport
Private cPerg	:= "CRCO03"

ValidPerg()

Pergunte(cPerg,.F.)
oReport := ReportDef()
oReport:PrintDialog()


SetVarNameLen(nVarLen)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRCO001   ºAutor  ³Renato Ruy          ºData  ³  16/09/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Rateio x Grupo de Rateio.			          º±±
±±º          ³		                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign - Contábil			                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport
Local oSection
Local oBreak1,oBreak2
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."
cDescricao	+=	"Relação das NF de Entrada de Serviço."


//Objeto do Relatório
oReport	:=	TReport():New("CRCO04","Relatorio de Compras de Serviço", cPerg, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)

//Seções Contas a Receber, Cliente , Naturezas
oSection	:= TRSection():New(oReport, "Compras"	, {"SF1","SDE"})


/*/Define a Ordem
TROrder():New(oParent  , uOrder  , cTitle                        	, cAlias  ) */
//TROrder():New(oSection, "" 		, "Matricula x Salario" 			,         )



//Celulas de Impressão - Rateio x Rateio Padrão

TRCell():New(oSection, "FILIAL"	   	   		, "SF1", "Filial"				,							,02)
TRCell():New(oSection, "NUM_NF"				, "SF1", "Nota Fiscal"			,							,09)
TRCell():New(oSection, "EMISSAO"   			, "SF1", "Dt. Emissão" 			,"@D"						,08)
TRCell():New(oSection, "CONTABIL"   		, "SF1", "Dt.Contabil"    		,"@D"						,08)
TRCell():New(oSection, "CLIENTE"	  		, "SF1", "Cod.Fornecedor"		,							,06)
TRCell():New(oSection, "LOJA"  	   			, "SF1", "Loja"					,							,02)
TRCell():New(oSection, "CNPJ"  	   			, "SF1", "Cnpj"					,"@R 99.999.999/9999-99"	,18)
TRCell():New(oSection, "NOME"  	   			, "SF1", "Nome"					,							,20)
TRCell():New(oSection, "ESPECIE"   			, "SF1", "Espécie"				,							,04)
TRCell():New(oSection, "VALOR"		 		, "SF1", "Valor Brut.NF"		,"@E 999,999,999.99"		,12)
TRCell():New(oSection, "VENCIM"      		, "SF1", "Vencimento"    		,"@D"						,08)
TRCell():New(oSection, "NATUREZ" 	  		, "SF1", "Natureza"				,							,09)
TRCell():New(oSection, "IRRF"				, "SF1", "Val.IRRF"				,"@E 999,999.99"			,09)
TRCell():New(oSection, "RETIRF"				, "SF1", "Cod. Ret.IRRF"		,							,06)
TRCell():New(oSection, "ISS"				, "SF1", "Val.ISS"				,"@E 999,999.99"			,09)
TRCell():New(oSection, "CODSER"				, "SF1", "Cod. Serv"			,               			,06)
TRCell():New(oSection, "PIS"				, "SF1", "Val.PIS"				,"@E 999,999.99"			,09)
TRCell():New(oSection, "COFINS"				, "SF1", "Val.COFINS"			,"@E 999,999.99"			,09)
TRCell():New(oSection, "CSLL"				, "SF1", "Val.CSLL"				,"@E 999,999.99"			,09)
TRCell():New(oSection, "DTDIGIT"			, "SD1", "Dt.Digitacao"			,"@D"						,08)
TRCell():New(oSection, "PRODUTO"			, "SD1", "Produto"				,"@!"						,15)
TRCell():New(oSection, "TES"				, "SD1", "Tipo Entrada"			,"@9"						,03)
TRCell():New(oSection, "CCONTABIL"			, "SD1", "Conta contabil"		,"@!"						,20)
TRCell():New(oSection, "MUNICIPIO"			, "SA1", "Municipio"			,"@!"						,35)

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LCRCO003  ºAutor  ³Renato Ruy Bernardoº Data ³ 09/04/2012   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados a serem impressos                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Locar                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrintReport(oReport)
Local oSection		:= oReport:Section(1)
Local oBreak        := Nil
Local cCpoBreak		:= ""
Local cDescBreak	:= ""
Local nOrdem		:= oSection:GetOrder()
Local cOrdem		:= ""
//Local __cJoinSAL	:= "% Cross Apply dbo.Ult3Salarios(RA_FILIAL,RA_MAT) AS RCA %"

//Transforma parâmetros do tipo Range em expressão SQL para ser utilizada na query.
MakeSqlExpr(cPerg)

oSection:BeginQuery()
BeginSql Alias "QCRCO003"
	Column EMISSAO	As Date //Converte em formato de data
	Column DTDIGIT	As Date
	Column CONTABIL	As Date 
	Column VENCIM	As Date
	
	%NoParser%
	
	SELECT DISTINCT
        F1_FILIAL FILIAL,
        F1_DOC NUM_NF,
        F1_SERIE SERIE,
        F1_EMISSAO EMISSAO,
        F1_DTLANC CONTABIL,
        F1_ESPECIE ESPECIE,
        F1_FORNECE CLIENTE,
        F1_LOJA LOJA,
        A2_NOME NOME,   
        A2_CGC  CNPJ,
        A2_MUN  MUNICIPIO,
        F1_VALBRUT VALOR,
        F1_VALIRF IRRF,
        E2_CODRET RETIRF,
        F1_ISS ISS,
        F1_VALIPI IPI,
        F1_VALICM ICMS,
        F1_VALPIS PIS,
        F1_VALCOFI COFINS,
        F1_VALCSLL CSLL,
        E2_VENCREA VENCIM,
        E2_NATUREZ NATUREZ,        
        F3_CODISS  CODSER,
        D1_DTDIGIT DTDIGIT,
        D1_COD PRODUTO,
        D1_TES TES,
        D1_CONTA CCONTABIL
        
FROM %Table:SF1% SF1
LEFT JOIN %Table:SA2% SA2 ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA AND SA2.%NOTDEL%
LEFT JOIN %Table:SE2% SE2 ON E2_NUM = F1_DOC AND E2_PREFIXO = F1_PREFIXO AND E2_FORNECE = F1_FORNECE AND E2_LOJA = F1_LOJA AND SE2.%NOTDEL%
LEFT JOIN %Table:SF3% SF3 ON F3_FILIAL = F1_FILIAL AND F3_NFISCAL = F1_DOC AND F3_SERIE = F1_SERIE AND F3_CLIEFOR = F1_FORNECE AND F3_LOJA = F1_LOJA AND SF3.%NOTDEL%
     JOIN %Table:SD1% SD1 ON D1_FILIAL = F1_FILIAL AND F1_DOC = D1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND SD1.D_E_L_E_T_= ' ' 
WHERE
F1_ESPECIE IN ('NFS','NFSE','DOCFI','FAT','NFF','REC') AND
F1_FILIAL BETWEEN %EXP:mv_par01% AND %EXP:mv_par02% AND
F1_DOC BETWEEN %EXP:mv_par03% AND %EXP:mv_par04% AND
F1_DTDIGIT BETWEEN %EXP:DtoS(mv_par05)% AND %EXP:DtoS(mv_par06)% AND
F1_FORNECE BETWEEN %EXP:mv_par07% AND %EXP:mv_par08% AND
F1_LOJA BETWEEN %EXP:mv_par09% AND %EXP:mv_par10% AND
SF1.%NOTDEL%
ORDER BY F1_DTLANC,F1_FORNECE,F1_LOJA
	
	
EndSql
oSection:EndQuery()

//Imprime
oSection:Print()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³CRCO001 ºAutor  ³Renato Ruyº 				Data ³  16/09/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Nfs de Serviço.						          º±±
±±º          ³		                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign - Contábil			                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Filial de  ?"		   		,"Filial de  ?"	  	  		,"Filial de  ?"		 		,"mv_ch1" 	,"C" 		,02     		,0      		,0     		,"G"		,""          ,"SM0"	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"Filial até ?"		   		,"Filial até ?"		  		,"Filial até ?"		 		,"mv_ch2" 	,"C" 		,02     		,0      		,0     		,"G"		,""          ,"SM0"	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"NF. Entrada de ?"    		,"NF. Entrada de ?"     	,"NF. Entrada de ?"     	,"mv_ch3" 	,"C" 		,09     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par03"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"04" 		,"NF. Entrada Até?"    		,"NF. Entrada Até?" 		,"NF. Entrada Até?" 		,"mv_ch4" 	,"C" 		,09     		,0      		,0     		,"G"		,""          ,""		,""         ,"S"        ,"mv_par04"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   	    ,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"05" 		,"Dt. Digitação de ?"		,"Dt. Digitação de ?"		,"Dt. Digitação de ?"		,"mv_ch5" 	,"D" 		,08     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par05"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"06" 		,"Dt. Digitação Até?"		,"Dt. Digitação Até?"		,"Dt. Digitação Até?"		,"mv_ch6" 	,"D" 		,08     		,0      		,0     		,"G"		,""          ,""		,""         ,"S"        ,"mv_par06"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   	    ,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"07" 		,"Fornecedor de ?"    		,"Fornecedor de ?"    		,"Fornecedor de ?"    		,"mv_ch7" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,"SA2"	    ,""         ,"S"        ,"mv_par07"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"08" 		,"Fornecedor Ate ?"    		,"Fornecedor Ate ?"    		,"Fornecedor Ate ?"    		,"mv_ch8" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,"SA2"		,""         ,"S"        ,"mv_par08"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   	    ,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"09" 		,"Loja de ?"	    		,"Fornecedor de ?"    		,"Fornecedor de ?"    		,"mv_ch9" 	,"C" 		,02     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par09"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"10" 		,"Loja Ate ?"  		  		,"Loja Ate ?"  		  		,"Loja Ate ?"  		  		,"mv_chA" 	,"C" 		,02     		,0      		,0     		,"G"		,""          ,""		,""         ,"S"        ,"mv_par10"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   	    ,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

Return
