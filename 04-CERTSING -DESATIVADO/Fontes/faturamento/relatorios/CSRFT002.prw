#Include "Totvs.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �CSRFT002 �Autor  �Renato Ruy Bernardo    � Data �  07/05/2014���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de Pulo de Notas.						          ���
���          �		                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign - Faturamento		                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSRFT002()
Local 	nVarLen	:=	SetVarNameLen(100)
Local 	oReport
Private cPerg	:= "CSRFT02"

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
���Programa �LCRCO007 �Autor  �Rodrigo S S de Carvalho� Data �  04/06/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Defini��es do Relat�rio                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Locar                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()
Local oReport
Local oSection
Local oBreak1,oBreak2
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."
      cDescricao	+=	"Rela��o de n�mero de notas fiscais n�o faturados no range especificado."


//Objeto do Relat�rio
oReport	:=	TReport():New("CSRFT02","Relatorio de Notas N�o Faturadas", cPerg, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)

//Se��es Contas a Receber, Cliente , Naturezas
oSection	:= TRSection():New(oReport, "Pulo"	, {"SF2"})


/*/Define a Ordem
TROrder():New(oParent  , uOrder  , cTitle                        	, cAlias  ) */
//TROrder():New(oSection, "" 		, "Matricula x Salario" 			,         )



//Celulas de Impress�o - SC1 - SOLICITACAO DE COMPRAS
TRCell():New(oSection, "SERIE"	   		, "SF2", "S�rie"				,							,03)
TRCell():New(oSection, "NOTA"			, "SF2", "Nota Fiscal"			,							,09)
TRCell():New(oSection, "TIPO"			, "SF2", "Tipo de Nota"			,							,15)		
TRCell():New(oSection, "EMISSAO"		, "SF2", "Dt.Emiss�o"			,"@D"						,08)		

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
���Uso       � Locar                                                     ���
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
BeginSql Alias "QCSRFT002"
	Column EMISSAO	As Date

	%NoParser%
		
	SELECT SERIE,NOTA,EMISSAO,COUNT(*) FROM (SELECT %Exp:Mv_par01% SERIE,LPAD(to_char((%EXP:nNota% + ROWNUM)-1),9,'0') NOTA, ' ' EMISSAO FROM %Table:SF2% SF2
	WHERE
	rownum <= %EXP:nQuant%
	UNION ALL
	SELECT F3_SERIE SERIE, F3_NFISCAL NOTA, ' ' EMISSAO from %Table:SF3% SF3
  	WHERE
  	f3_filial = %Exp:xFilial("SF3")% and
	F3_SERIE = %EXP:MV_PAR01% AND 
	F3_NFISCAL BETWEEN %EXP:MV_PAR02% AND %EXP:MV_PAR03% AND
	LENGTH(TRIM(F3_NFISCAL))>6
	//Retorna dados de notas intercaladas-notas com data fora da sequencia.
	Union All
	SELECT F3_SERIE SERIE, F3_NFISCAL NOTA, F3_EMISSAO EMISSAO from PROTHEUS.SF3010 SF3
  	WHERE
  	F3_FILIAL = %Exp:xFilial("SF3")% and
	F3_SERIE = %EXP:MV_PAR01% AND
	F3_NFISCAL BETWEEN %EXP:MV_PAR02% AND %EXP:MV_PAR03% AND
  	F3_EMISSAO < (SELECT F3_EMISSAO FROM PROTHEUS.SF3010 SF32 WHERE F3_FILIAL = '02' AND F3_NFISCAL = LPAD(to_char(to_number(SF3.F3_NFISCAL)-1),9,'0') AND F3_SERIE = '2' AND SF32.D_E_L_E_T_ = ' ' AND ROWNUM = 1) AND
  	LENGTH(TRIM(F3_NFISCAL))>6)
	GROUP BY SERIE, NOTA, EMISSAO
	HAVING COUNT(*) = 1
	ORDER BY NOTA
	
	
	
	
EndSql
oSection:EndQuery()

//Imprime
oSection:Print()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �LCRCO007 �Autor  �Rodrigo S S de Carvalho� Data �  04/06/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o Responsavel por criar as perguntas utilizadas no    ���
���          � Relat�rio.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � LOCAR                                                     ���
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


Return
