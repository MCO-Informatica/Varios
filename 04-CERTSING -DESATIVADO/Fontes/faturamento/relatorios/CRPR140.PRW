#Include "Totvs.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³CRPR070 ºAutor  ³Renato Ruy Bernardo    º Data ³  04/12/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Remuneração de Parceiros.			          º±±
±±º          ³* Postos                                                    º±±
±±º          ³* AC	                                                      º±±
±±º          ³* CANAL                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign - Faturamento		                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRPR140()
Local 	nVarLen	:=	SetVarNameLen(100)
Local 	oReport
Private cPerg	:= "CRPR140"

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
±±ºPrograma ³ReportDef ºAutor  ³Renato Ruy Bernardo	  º Data ³  04/12/2014º±±
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
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."
cDescricao	+=	"Relação de número de notas fiscais não faturados no range especificado."


//Objeto do Relatório
oReport	:=	TReport():New("CRPR140","Relatorio de Remuneração de Parceiros", cPerg, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)

//Seções Contas a Receber, Cliente , Naturezas
oSection	:= TRSection():New(oReport, "Remuneração"	, {"SZ5","PA8"})
//Celulas de Impressão - SZ6 - Movimentos de Remuneração

TRCell():New(oSection, "Z5_PEDGAR"				, "SZ5", "Pedido"				,							,07) 
TRCell():New(oSection, "Z5_DATVAL"				, "SZ5", "Dt.Validação"			,"@D"						,08)
TRCell():New(oSection, "Z5_DATVER"				, "SZ5", "Dt.Verificação"		,"@D"						,08)
TRCell():New(oSection, "Z5_DATEMIS"				, "SZ5", "Dt.Emissão/Renovação"	,"@D"						,08)
TRCell():New(oSection, "Z5_VALORSW"		   		, "SZ5", "Valor SW"				,"@E 999.999.999,99"		,15)
TRCell():New(oSection, "Z5_VALORHW"		   		, "SZ5", "Valor HW"				,"@E 999.999.999,99"		,15)
TRCell():New(oSection, "Z5_PRODGAR"				, "SZ5", "Produto"				,							,30)
TRCell():New(oSection, "PA8_DESBPG"				, "PA8", "Descrição Produto"	,							,99)
TRCell():New(oSection, "Z5_CODVOU"				, "SZ5", "Código Voucher"		,							,20)
TRCell():New(oSection, "ZH_DESCRI"				, "SZ5", "Descrição Voucher"	,							,30)
TRCell():New(oSection, "Z5_GRUPO"				, "SZ5", "Código Projeto"		,							,20)
TRCell():New(oSection, "Z5_DESGRU"				, "SZ5", "Descrição Projeto"	,							,99)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PrintReportºAutor  ³Renato Ruy Bernardoº Data ³ 09/04/2012   º±±
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
Local oSection		:= oReport:Section(1)
Local oBreak        := Nil
Local cCpoBreak		:= ""
Local cDescBreak	:= ""
Local nOrdem		:= oSection:GetOrder()
Local cOrdem		:= ""
//Local nQuant		:= (Val(Mv_par03)-Val(Mv_par02))+1
//Local nNota			:= Val(Mv_par02)
Local cWhere		:= 0

If 	   MV_PAR03 == 1
	cWhere := 99999999999
Else
	cWhere := 0
EndIf

//Transforma parâmetros do tipo Range em expressão SQL para ser utilizadana query.
MakeSqlExpr(cPerg)

If Select("QCRPR070") == 0

	Beginsql Alias "TMPPED"
		SELECT Z5_PEDGAR, R_E_C_N_O_ RECNOZ5 FROM %Table:SZ5%
		WHERE
		Z5_FILIAL = %xFilial:SZ5% AND
		Z5_DATVER BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%  AND
		Z5_PEDGANT = ' ' AND
		Z5_PRODGAR = ' ' AND
		%NOTDEL%
		UNION ALL
		SELECT Z5_PEDGAR, R_E_C_N_O_ RECNOZ5 FROM %Table:SZ5%
		WHERE
		Z5_FILIAL = %xFilial:SZ5% AND
		Z5_DATEMIS BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%  AND
		Z5_PEDGANT > ' ' AND
		Z5_PRODGAR = ' ' AND
		%NOTDEL%
	Endsql
	
	DbSelectArea("SZ5")
	While !TMPPED->(EOF())
		If !Empty(TMPPED->Z5_PEDGAR)
			SZ5->(DbGoTo(TMPPED->RECNOZ5))
			StaticCall(CRPA027,CRPA027B,TMPPED->Z5_PEDGAR,.F.)
		Endif
		TMPPED->(DbSkip())	
	Enddo
	TMPPED->(DbCloseArea())
	
Endif

oSection:BeginQuery()

	BeginSql Alias "QCRPR070"
		Column Z5_DATVAL	As Date
		Column Z5_DATVER	As Date
		Column Z5_DATEMIS	As Date
		
		%NoParser%
		
		SELECT Z5_PEDGAR, 
		       Z5_DATVAL, 
		       Z5_DATVER, 
		       Z5_DATEMIS, 
		       Z5_VALORSW, 
		       Z5_VALORHW, 
		       Z5_PRODGAR,
		       PA8_DESBPG,
		       Z5_CODVOU,
		       ZH_DESCRI,
		       Z5_GRUPO,
		       Z5_DESGRU
		FROM %Table:SZ5% SZ5
		LEFT JOIN %Table:PA8% PA8 ON PA8_FILIAL = %xFilial:PA8% AND PA8_CODBPG = Z5_PRODGAR AND PA8.%Notdel%
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = %xFilial:SZH% AND ZH_TIPO = Z5_TIPVOU AND SZH.%Notdel%
		WHERE 
		Z5_FILIAL = %xFilial:SZ5%
		AND Z5_DATVER BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND Z5_DATVAL > '20121231'
		AND Z5_CODAC != 'NAOREM' 
		AND UPPER(Z5_DESPRO) NOT LIKE '%TESTE%'
		AND SubStr(Z5_PRODGAR,1,3) != 'PRD'
		AND SubStr(Z5_PRODGAR,1,3) != 'SPB'
		AND SubStr(Z5_PRODGAR,1,3) != 'CSI'
		AND SubStr(Z5_PRODGAR,1,4) != 'CERT'
		AND SubStr(Z5_PRODGAR,1,5) != 'CLASS'
		AND Z5_PRODGAR NOT LIKE '%BB%'
		AND Z5_PRODGAR > ' '
		AND Z5_PEDGANT = ' '
		AND Z5_VALORSW <= %Exp:cWhere%
		AND Z5_VALORHW <= %Exp:cWhere%
		AND SZ5.%NotDel%
		UNION
		SELECT Z5_PEDGAR, 
		       Z5_DATVAL, 
		       Z5_DATVER, 
		       Z5_DATEMIS, 
		       Z5_VALORSW, 
		       Z5_VALORHW, 
		       Z5_PRODGAR,
		       PA8_DESBPG,
		       Z5_CODVOU,
		       ZH_DESCRI,
		       Z5_GRUPO,
		       Z5_DESGRU
		FROM %Table:SZ5% SZ5
		LEFT JOIN %Table:PA8% PA8 ON PA8_FILIAL = %xFilial:PA8% AND PA8_CODBPG = Z5_PRODGAR AND PA8.%Notdel%
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = %xFilial:SZH% AND ZH_TIPO = Z5_TIPVOU AND SZH.%Notdel%
		WHERE 
		Z5_FILIAL = %xFilial:SZ5%
		AND Z5_DATEMIS BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND Z5_PEDGANT > ' '
		AND Z5_CODAC != 'NAOREM' 
		AND UPPER(Z5_DESPRO) NOT LIKE '%TESTE%'
		AND SubStr(Z5_PRODGAR,1,3) != 'PRD'
		AND SubStr(Z5_PRODGAR,1,3) != 'SPB'
		AND SubStr(Z5_PRODGAR,1,3) != 'CSI'
		AND SubStr(Z5_PRODGAR,1,4) != 'CERT'
		AND SubStr(Z5_PRODGAR,1,5) != 'CLASS'
		AND Z5_PRODGAR NOT LIKE '%BB%'
		AND Z5_PRODGAR > ' '
		AND Z5_VALORSW <= %Exp:cWhere%
		AND Z5_VALORHW <= %Exp:cWhere%
		AND SZ5.%NotDel%
		
	EndSql
	
oSection:EndQuery()

//Imprime
oSection:Print()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ValidPerg ºAutor  ³Renato Ruy Bernardo    º Data ³  04/06/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função Responsavel por criar as perguntas utilizadas no    º±±
±±º          ³ Relatório.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Data de ?"	   			,"Data de ?"  	  	 		,"Data de ?"  		 		,"mv_ch1" 	,"D" 		,08     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"Data Ate ?"	   			,"Data Ate ?"  	  	 		,"Data Ate ?"  		 		,"mv_ch2" 	,"D" 		,08     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"Sem Valor ?"		  		,"Sem Valor ?"		  		,"Sem Valor ?" 		  		,"mv_ch3" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par03"	,"Todos"			,"Todos"			,"Todos"			,""   		,"Sem Valor"	,"Sem Valor"	,"Sem Valor"	,""		    ,""		    ,""		    	,""		    ,""		    	,""		    	,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

Return
