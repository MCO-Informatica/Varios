#Include "Totvs.ch"
#Include "Topconn.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  |CSTR010	?Autor  ?Renato Ruy Bernardo ? Data ?  31/08/2016 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Relat?rio de combos, desmembrado por SW e HW.		          ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Certisign - Faturamento		                              ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function CSTR010()
Local 	nVarLen	:=	SetVarNameLen(100)
Local 	oReport
Private cPerg	:= "CSTR010"

ValidPerg()

Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()


SetVarNameLen(nVarLen)
Return


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?ReportDef ?Autor  ?Renato Ruy Bernardo ? Data ?  31/08/2016 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Defini??es do Relat?rio                                    ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Certisign                                                  ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function ReportDef()
Local oReport
Local oSection
Local oBreak1,oBreak2
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."
cDescricao	+=	"Rela??o de n?mero de notas fiscais n?o faturados no range especificado."


//Objeto do Relat?rio
oReport	:=	TReport():New("CSTR010","Relatorio de Remunera??o de Parceiros", cPerg, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)

//Se??es Contas a Receber, Cliente , Naturezas
oSection	:= TRSection():New(oReport, "Combos"	, {"DA1","SZJ"})
//Celulas de Impress?o - SZ6 - Movimentos de Remunera??o

TRCell():New(oSection, "DA1_CODTAB"				, "QCSTR010", "Codigo Tabela"		,							,03)
TRCell():New(oSection, "DA0_DESCRI"				, "QCSTR010", "Nome da Tabela"		,							,30)
TRCell():New(oSection, "DA1_CODPRO"				, "QCSTR010", "Produto"				,							,30)
//TRCell():New(oSection, "DA1_DESCRI"				, "QCSTR010", "Descri??o"			,							,50)
TRCell():New(oSection, "DA1_DESAMI"				, "QCSTR010", "Desc.Amigavel"		,							,50)
TRCell():New(oSection, "DA1_CODCOB"				, "QCSTR010", "Codigo Combo"		,							,30)
TRCell():New(oSection, "DA1_CODGAR"				, "QCSTR010", "Cod. Prod. Gar"		,							,30)
TRCell():New(oSection, "DA1_DESGAR"				, "QCSTR010", "Desc. Prod. Gar"		,							,50)
TRCell():New(oSection, "ATIVO"					, "QCSTR010", "Ativo"				,							,12)
TRCell():New(oSection, "VALORSW"				, "QCSTR010", "Pre?o Tabela SW"		,							,15)
TRCell():New(oSection, "VALORHW"				, "QCSTR010", "Pre?o Tabela HW"		,							,15)
TRCell():New(oSection, "DA1_XPRCRE"				, "QCSTR010", "Pre?o Renova??o"		,							,15)
TRCell():New(oSection, "DA1_PRCVEN"				, "QCSTR010", "Pre?o de Venda"		,							,15)
TRCell():New(oSection, "DA1_NUMPAR"				, "QCSTR010", "N? Parcelas"			,							,15)

Return oReport

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  PrintReport?Autor  ?Renato Ruy Bernardo ? Data ?  31/08/2016 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Dados a serem impressos                                    ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Certisign                                                  ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function PrintReport(oReport)
Local oSection		:= oReport:Section(1)
Local oBreak        := Nil
Local cCpoBreak		:= ""
Local cDescBreak	:= ""
Local cWhere		:= "% "+Iif(Empty(Mv_par02),""," DA1_CODTAB = '"+Mv_par02+"' AND")+" %"
Local cWhere2		:= "% "+Iif(Empty(Mv_par02),""," DA1_CODTAB = '"+Mv_par02+"' AND")+" %"
Local nOrdem		:= oSection:GetOrder()
Local cOrdem		:= ""

If MV_PAR01 == 1
	cWhere := "% DA1_ATIVO = '1' AND "+Iif(Empty(Mv_par02),"","DA1_CODTAB = '"+Mv_par02+"' AND")+" %"
Elseif MV_PAR01 == 3
	cWhere := "% DA1_ATIVO = '2' AND "+Iif(Empty(Mv_par02),"","DA1_CODTAB = '"+Mv_par02+"' AND")+" %"
Endif

//Transforma par?metros do tipo Range em express?o SQL para ser utilizadana query.
MakeSqlExpr(cPerg)

oSection:BeginQuery()

	BeginSql Alias "QCSTR010"
		SELECT DA1_CODTAB, 
			TRIM(DA0_DESCRI) AS DA0_DESCRI, 
			DA1_CODPRO, 
			TRIM(DA1_DESAMI) AS DA1_DESAMI, 
			DA1_CODCOB, 
			DA1_CODGAR, 
			TRIM(DA1_DESGAR) AS DA1_DESGAR, 
			DECODE(DA1_ATIVO, '1', 'ATIVO', 'DESATIVADO') ATIVO, 
			CASE 
				WHEN DA1_CODCOB = ' ' THEN DA1_PRCVEN 
				ELSE (SELECT Sum(DECODE(B1_CATEGO, '2', ZJ_PRETAB, 
													0)) 
					FROM   %Table:SZI% ZI 
							INNER JOIN %Table:SZJ% ZJ 
									ON ZJ_FILIAL = ZI_FILIAL 
										AND ZJ_COMBO = ZI_COMBO 
										AND ZJ.%Notdel%
							INNER JOIN %Table:SB1% B1 
									ON B1_FILIAL = %xFilial:SB1%
										AND B1_COD = ZJ_CODPROD 
										AND B1.%Notdel% 
					WHERE  ZI.%Notdel%
							AND ZI_FILIAL = %xFilial:SZI%
							AND ZI_TABPRE = DA1_CODTAB 
							AND ZI_COMBO = DA1_CODCOB) 
			END                             AS VALORSW, 
			CASE 
				WHEN DA1_CODCOB = ' ' THEN 0 
				ELSE (SELECT Sum(DECODE(B1_CATEGO, '1', ZJ_PRETAB, 
													0)) 
					FROM   %Table:SZI% ZI 
							INNER JOIN %Table:SZJ% ZJ 
									ON ZJ_FILIAL = ZI_FILIAL 
										AND ZJ_COMBO = ZI_COMBO 
										AND ZJ.%Notdel% 
							INNER JOIN %Table:SB1% B1 
									ON B1_FILIAL = %xFilial:SB1% 
										AND B1_COD = ZJ_CODPROD 
										AND B1.%Notdel% 
					WHERE  ZI.%Notdel% 
							AND ZI_FILIAL = %xFilial:SZI%
							AND ZI_TABPRE = DA1_CODTAB 
							AND ZI_COMBO = DA1_CODCOB) 
			END                             AS VALORHW, 
			DA1_XPRCRE, 
			DA1_PRCVEN, 
			DA1_NUMPAR 
		FROM   %Table:DA0% DA0 
			INNER JOIN %Table:DA1% DA1 
					ON DA1_FILIAL = DA0_FILIAL 
						AND DA1_CODTAB = DA0_CODTAB 
						AND %Exp:cWhere% 
						DA1.%Notdel%
						//AND DA1_CODCOB = '000000000002734' 
						//AND DA1_CODGAR = 'ACMA3PJNFETOASSSPHV2' 
		WHERE  DA0.%Notdel% 
			AND DA0_FILIAL = %xFilial:DA0%			
		ORDER  BY DA1_CODTAB, DA0_DESCRI, DA1_CODPRO, DA1_DESAMI, DA1_CODCOB, DA1_CODGAR, DA1_DESGAR, DA1_XPRCRE, DA1_PRCVEN		
	EndSql

oSection:EndQuery()

//Imprime
oSection:Print()

Return


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  |ValidPerg	?Autor  ?Renato Ruy Bernardo ? Data ?  31/08/2016 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Fun??o Responsavel por criar as perguntas utilizadas no    ???
???          ? Relat?rio.                                                 ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Certisign                                                  ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ]    [ cDefSpa3 ] [ cDefEng3 ] [ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Status"         	  		,"Status"         	  		,"Status"         	  		,"mv_ch1" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,"Ativo"   			,"Ativo"   			,"Ativo"   			,""   		,"Todos"        ,"Todos"        ,"Todos"        ,"Desativado","Desativado","Canal"    	,""			,""				,""				,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"Tabela de Pre?os"			,"Tabela de Pre?os"			,"Tabela de Pre?os"			,"mv_ch2" 	,"C" 		,03     		,0      		,0     		,"G"		,""          ,"DA0"	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

Return
