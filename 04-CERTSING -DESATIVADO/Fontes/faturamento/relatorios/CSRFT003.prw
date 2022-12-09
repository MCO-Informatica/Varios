#Include "Totvs.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �CSRFT002 �Autor  �Renato Ruy Bernardo    � Data �  07/05/2014���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de Notas Denegadas.						          ���
���          �		                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign - Faturamento		                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSRFT003()
Local 	nVarLen	:=	SetVarNameLen(100)
Local 	oReport
Private cPerg	:= "CSRFT03"

Public teste

ValidPerg()

Pergunte(cPerg,.F.)
oReport := ReportDef()
oReport:PrintDialog()


SetVarNameLen(nVarLen)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �CSRFT002 �Autor  �Renato Ruy Bernardo    � Data �  07/05/2014���
�������������������������������������������������������������������������͹��
���Desc.     � Defini��es do Relat�rio                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()
Local oReport
Local oSection
Local oBreak1,oBreak2
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."
      cDescricao	+=	"Rela��o de n�mero de notas fiscais denegadas no range especificado."


//Objeto do Relat�rio
oReport	:=	TReport():New("CSRFT03","Relatorio de Notas Denegadas", cPerg, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)

//Se��es Contas a Receber, Cliente , Naturezas
oSection	:= TRSection():New(oReport, "NF"	, {"SF3"})


/*/Define a Ordem
TROrder():New(oParent  , uOrder  , cTitle                        	, cAlias  ) */
//TROrder():New(oSection, "" 		, "Matricula x Salario" 			,         )



//Celulas de Impress�o - SC1 - SOLICITACAO DE COMPRAS
TRCell():New(oSection, "F3_SERIE"  		, "SF3", "S�rie"				,							,003)
TRCell():New(oSection, "F3_NFISCAL"		, "SF3", "Nota Fiscal"			,							,009)
TRCell():New(oSection, "F3_EMISSAO"		, "SF3", "Dt.Emiss�o"			,"@D"						,008)
TRCell():New(oSection, "F3_VALCONT"		, "SF3", "Valor"				,"@E 999.999.999,99"		,015)
TRCell():New(oSection, "F3_CLIEFOR"		, "SF3", "Cliente"				,							,006)
TRCell():New(oSection, "F3_LOJA"		, "SF3", "Loja"					,							,002)
TRCell():New(oSection, "A1_CGC"	   		, "SF3", "CGC/CNPJ"				,							,014)
TRCell():New(oSection, "F3_CODRSEF"		, "SF3", "Cod.Retorno"			,							,003)
TRCell():New(oSection, "ERRO"			, "SF3", "Mensagem de Erro"		,							,200)		


//Total Geral
//TRFunction():New(oSection:Cell("VALOR")	,,"SUM",, "Total Geral ==>",	,	,	.F.,	.T. , .F.)

Return oReport


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LCRCO003  �Autor  �Renato Ruy Bernardo� Data � 09/04/2012   ���
�������������������������������������������������������������������������͹��
���Desc.     � Dados a serem impressos                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PrintReport(oReport)
Local oSection		:= oReport:Section(1)
Local oBreak        := Nil
Local cCpoBreak		:= ""
Local cDescBreak	:= ""
Local nOrdem		:= oSection:GetOrder()
Local cOrdem		:= ""
Local nQuant		:= (Val(Mv_par03)-Val(Mv_par02))+1
Local nNota			:= Val(Mv_par02)

//Transforma par�metros do tipo Range em express�o SQL para ser utilizadana query.
MakeSqlExpr(cPerg)

oSection:BeginQuery()

If Mv_par04 == 1
BeginSql Alias "QCSRFT003"
	Column F3_EMISSAO	As Date

	%NoParser%
		
	SELECT 	F3_NFISCAL, 
			F3_SERIE, 
			F3_EMISSAO,
			F3_VALCONT,
			F3_CLIEFOR,
			F3_LOJA, 
			A1_CGC,
			F3_CODRSEF,
			MAX(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_ERRO, 4000,1))) ERRO FROM PROTHEUS.SF3010
	//INNER JOIN SPED.SPED055 
	LEFT JOIN SPED.SPED055 
	ON NFSE_ID = F3_SERIE||F3_NFISCAL 
	LEFT JOIN %Table:SA1% SA1
	ON A1_COD = F3_CLIEFOR AND  A1_LOJA = F3_LOJA AND SA1.%NotDel%
	WHERE
	F3_FILIAL = %xFilial:SF3% AND
	F3_NFISCAL Between %Exp:Mv_par02% AND %Exp:Mv_par03% AND
	LENGTH(TRIM(F3_NFISCAL)) >= 7 AND
	//F3_CODRET IN ('T','N',' ') AND
	F3_NFELETR = ' ' AND
	F3_SERIE = %Exp:Mv_par01% 
	//AND UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_ERRO, 4000,1)) IS NOT NULL
	GROUP BY F3_NFISCAL, F3_SERIE, F3_EMISSAO,F3_VALCONT,F3_CLIEFOR,F3_LOJA,A1_CGC,F3_CODRSEF
	
	
	
EndSql
Else
BeginSql Alias "QCSRFT003"
	Column F3_EMISSAO	As Date

	%NoParser%
		
	SELECT 	F3_NFISCAL,
			F3_SERIE,
			F3_EMISSAO,
			F3_VALCONT,
			F3_CLIEFOR,
			F3_LOJA, 
			A1_CGC,
			F3_CODRSEF,
			F3_OBSERV ERRO
	FROM %Table:SF3% SF3
	LEFT JOIN %Table:SA1% SA1 
	ON A1_COD = F3_CLIEFOR AND  A1_LOJA = F3_LOJA AND SA1.%NotDel%
	WHERE
	F3_FILIAL = %xFilial:SF3% AND
	F3_NFISCAL Between %Exp:Mv_par02% AND %Exp:Mv_par03% AND
	LENGTH(TRIM(F3_NFISCAL)) >= 7 AND
	F3_CODRSEF NOT IN ('100','101','102') AND
	F3_SERIE = %Exp:Mv_par01%
	
	
	
EndSql
EndIf


oSection:EndQuery()

//Imprime
oSection:Print()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �CSRFT002 �Autor  �Renato Ruy Bernardo    � Data �  07/05/2014���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o Responsavel por criar as perguntas utilizadas no    ���
���          � Relat�rio.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"S�rie  ?"		   			,"S�rie  ?"	  	  	 		,"S�rie  ?"	  		 		,"mv_ch1" 	,"C" 		,03     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"Nota de ?"		   		,"Nota de ?"		   		,"Nota de ?"		   		,"mv_ch2" 	,"C" 		,09     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"Nota At� ?"   	  		,"Nota At� ?"   	  		,"Nota At� ?"   	  		,"mv_ch3" 	,"C" 		,09     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par03"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"04" 		,"Tipo ?"   	  	  		,"Tipo ?"  		 	  		,"Tipo ?"      		  		,"mv_ch4" 	,"C" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par04"	,"Servi�o" 			,"Servi�o"     		,"Servi�o"    		,""   		,"Produto"      ,"Produto"      ,"Produto"      ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
                                                  	

Return
