#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RelCAbc   ºAutor  ³ Luiz     º Data ³  07/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatórios Curva ABC Clientes º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MetaLacre - Protheus 11                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RelCAbc()
Local oReport
Private cPerg 	:= PADR('RELABC',10) 
	
	
AjustaSX1()
If TRepInUse() //verifica se relatorios personalizaveis esta disponivel 
	Pergunte(cPerg,.F.) 
	oReport := ReportDef() 
	oReport:PrintDialog() 
EndIf 
	
Return 
    
 
Static Function ReportDef() 
	Local oReport 
	Local oSection1 	 
 
	oReport := TReport():New('RELABC',"Relatório Curva Abc Clientes",'RELABC',{|oReport| PrintReport(oReport)},"Esta Rotina irá imprimir o Relatório Curva ABC Clientes") 	
	oReport:SetTotalInLine(.T.) // Impressao do total geral das colunas somadas
	oReport:ShowFooter()            
	oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao
	
	oSection1 := TRSection():New(oReport,"Relatório Curva ABC Clientes",{}) 
	
	oSection1:SetTotalInLine(.T.) // Impressao do total geral das colunas somadas

	//UF VENDEDOR	QTD ORÇAMENTOS	QTD FATURADOS	QTD CANCELADOS	 TOTAL ORÇAMENTOS 	 TOTAL FATURADOS 	 TOTAL CANCELADOS 	 ORCADO X FATURADO 	CLIENTES 1a. COMPRA	NOVOS PROSPECTS

	TRCell():New(oSection1,"_cCod"		    ,"   ","Código"		   										,PesqPict("SA1","A1_COD")		, TamSX3("A1_COD")[1])
	TRCell():New(oSection1,"_cLoja"	        ,"   ","Loja"		   										,PesqPict("SA1","A1_LOJA")	    , TamSX3("A1_LOJA")[1]) 
	TRCell():New(oSection1,"_cNome"         ,"   ","Nome Cliente"  										,PesqPict("SA1","A1_NOME")	    , TamSX3("A1_NOME")[1]) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao da Segunda Secao: Funcionario  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

Return oReport 

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
 
Static Function PrintReport(oReport)
Local cQuery	    := ""
Local oSection1 := oReport:Section(1)

If MV_PAR13 == 1	// Agrupado por Cliente
	If MV_PAR14 == 1 // Totalizado por Valor
		cQuery :=" 		SELECT A1_COD, SUM(D2_TOTAL) TOTAL "
	ElseIf MV_PAR14 == 2 // Totalizado por Quantidade
		cQuery :=" 		SELECT A1_COD, SUM(D2_QUANT) TOTAL "
	Endif	
	cQuery +=" 	FROM " + RetSqlName("SA1") + " A1 (NOLOCK)," + RetSqlName("SD2") + " D2 (NOLOCK)," + RetSqlName("SF4") + " F4 (NOLOCK)," + RetSqlName("SF2") + " F2 (NOLOCK), " + RetSqlName("SB1") + " B1 (NOLOCK) "
	cQuery +=" 	WHERE D2_CLIENTE = A1_COD "
	cQuery +=" 	AND F2_FILIAL = '" + xFilial("SF2") + "' "
	cQuery +=" 	AND D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery +=" 	AND F4_FILIAL = '" + xFilial("SF4") + "' "
	cQuery +=" 	AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery +=" 	AND A1.D_E_L_E_T_ = '' "
	cQuery +=" 	AND D2.D_E_L_E_T_ = '' "
	cQuery +=" 	AND F4.D_E_L_E_T_ = '' "
	cQuery +=" 	AND F2.D_E_L_E_T_ = '' "
	cQuery +=" 	AND B1.D_E_L_E_T_ = '' "
	cQuery +=" 	AND D2_TIPO = 'N' "
	cQuery +=" 	AND D2_TES = F4_CODIGO "
	cQuery +=" 	AND D2_COD = B1_COD "
	cQuery +=" 	AND F4_ESTOQUE = 'S' "
	cQuery +=" 	AND F4_DUPLIC = 'S' "
	cQuery +=" 	AND D2_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery +=" 	AND F2_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" 	AND A1_LOJA = F2_LOJA "
	cQuery +=" 	AND D2_EST BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery +=" 	AND B1_GRUPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery +=" 	AND D2_COD BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	cQuery +=" 	AND A1_REGIAO BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
	cQuery +=" 	AND D2_DOC = F2_DOC "
	cQuery +=" 	AND D2_SERIE = F2_SERIE "
	cQuery +=" 	AND D2_CLIENTE = A1_COD "
	cQuery +=" 	AND D2_FILIAL = F2_FILIAL "
	cQuery +=" 	GROUP BY A1_COD "
	If MV_PAR14 == 1 // Totalizado por Valor
		cQuery +=" 	ORDER BY SUM(D2_TOTAL) DESC "
	ElseIf MV_PAR14 == 2 // Totalizado por Quantidade
		cQuery +=" 	ORDER BY SUM(D2_QUANT) DESC "
	Endif	 
Else
	If MV_PAR14 == 1 // Totalizado por Valor
		cQuery :=" 		SELECT A1_COD, A1_LOJA, SUM(D2_TOTAL) TOTAL "
	ElseIf MV_PAR14 == 2 // Totalizado por Quantidade
		cQuery :=" 		SELECT A1_COD, A1_LOJA, SUM(D2_QUANT) TOTAL "
	Endif	
	cQuery +=" 	FROM " + RetSqlName("SA1") + " A1 (NOLOCK)," + RetSqlName("SD2") + " D2 (NOLOCK)," + RetSqlName("SF4") + " F4 (NOLOCK)," + RetSqlName("SF2") + " F2 (NOLOCK), " + RetSqlName("SB1") + " B1 (NOLOCK) "
	cQuery +=" 	WHERE D2_CLIENTE = A1_COD "
	cQuery +=" 	AND D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery +=" 	AND A1.D_E_L_E_T_ = '' "
	cQuery +=" 	AND D2.D_E_L_E_T_ = '' "
	cQuery +=" 	AND F4.D_E_L_E_T_ = '' "
	cQuery +=" 	AND F2.D_E_L_E_T_ = '' "
	cQuery +=" 	AND D2_TIPO = 'N' "
	cQuery +=" 	AND D2_TES = F4_CODIGO "
	cQuery +=" 	AND D2_COD = B1_COD "
	cQuery +=" 	AND F4_ESTOQUE = 'S' "
	cQuery +=" 	AND F4_DUPLIC = 'S' "
	cQuery +=" 	AND D2_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery +=" 	AND F2_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" 	AND A1_LOJA = F2_LOJA "
	cQuery +=" 	AND D2_EST BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery +=" 	AND B1_GRUPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery +=" 	AND D2_COD BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	cQuery +=" 	AND A1_REGIAO BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
	cQuery +=" 	AND D2_DOC = F2_DOC "
	cQuery +=" 	AND D2_SERIE = F2_SERIE "
	cQuery +=" 	AND D2_CLIENTE = A1_COD "
	cQuery +=" 	AND D2_LOJA = A1_LOJA "
	cQuery +=" 	AND D2_FILIAL = F2_FILIAL "
	cQuery +=" 	GROUP BY A1_COD, A1_LOJA "
	If MV_PAR14 == 1 // Totalizado por Valor
		cQuery +=" 	ORDER BY SUM(D2_TOTAL) DESC "
	ElseIf MV_PAR14 == 2 // Totalizado por Quantidade
		cQuery +=" 	ORDER BY SUM(D2_QUANT) DESC "
	Endif	 
Endif
cQuery := ChangeQuery(cQuery) 	// otimiza a query de acordo c/ o banco 	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CHKV",.T.,.T.)

aVendas	:= {}

dbSelectArea("CHKV")
Count To nReg
dbGoTop()
ProcRegua(nReg)
While CHKV->(!Eof())
	IncProc("Aguarde Processando os Dados")
	
	cNome := ''
	If MV_PAR13==1
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+CHKV->A1_COD))
		
		cNome := SA1->A1_NOME
	Else
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+CHKV->A1_COD+CHKV->A1_LOJA))
		
		cNome := SA1->A1_NOME
	Endif

	AAdd(aVendas,{CHKV->A1_COD,;
					Iif(MV_PAR13==2,CHKV->A1_LOJA,''),;
					cNome,;
					CHKV->TOTAL,;
					0.00})

	CHKV->(dbSkip(1))
Enddo
CHKV->(dbCloseArea())

// Calculo Total Geral

nTotVenda := 0.00
For nVenda := 1 To Len(aVendas)
	nTotVenda += aVendas[nVenda,4]
Next

// Calculo Participação 

For nVenda := 1 To Len(aVendas)
	aVendas[nVenda,5] := Round((aVendas[nVenda,4]/nTotVenda)*100,3)
Next

// Colunas

TRCell():New(oSection1,"_nTotal"   	    ,"   ",Iif(MV_PAR14==1,'Total Valor','Total Qtde')			, Iif(MV_PAR14==1,'@E 999,999,999.99','999,999,999')					    , TamSX3("D2_TOTAL")[1])
TRCell():New(oSection1,"_nPart"		  	,"   ","(%) Participação" 									,'@E 9,999.999'					, TamSX3("D2_TOTAL")[1])

TRFunction():New(oSection1:Cell("_nTotal")	,NIL,"SUM"		,/*oBreak*/,"",Iif(MV_PAR14==1,'@E 999,999,999.99','999,999,999')		,{|| oSection1:Cell("_nTotal"):GetValue(.T.) },.T.,.F.)

ProcRegua(Len(aVendas))
For nVenda := 1 To Len(aVendas)
	If oReport:Cancel() 
		Exit 
	EndIf            
	
	IncProc()
			   
	oSection1:Init()

   	oSection1:Cell("_cCod"):SetValue(aVendas[nVenda,1])	
	oSection1:Cell("_cLoja"):SetValue(aVendas[nVenda,2])
	oSection1:Cell("_cNome"):SetValue(aVendas[nVenda,3])
	oSection1:Cell("_nTotal"):SetValue(aVendas[nVenda,4])
	oSection1:Cell("_nPart"):SetValue(aVendas[nVenda,5])
	

	//Imprime registros na secao 1 
	oSection1:PrintLine()		       
			
Next
oReport:SkipLine()
oReport:PrintText('Quantidade de Clientes Listados: ' + Str(Len(aVendas),6))
oReport:SkipLine()
oSection1:Finish()			
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
PutSx1(cPerg,'09','Produto De     ?','','','mv_ch9','C',15, 0, 0,'G','','SB1','','','mv_par09'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'10','Produto De     ?','','','mv_chA','C',15, 0, 0,'G','','SB1','','','mv_par10'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'11','Regiao de      ?','','','mv_chB','C',03, 0, 0,'G','','SZ9','','','mv_par11'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'12','Regiao Ate     ?','','','mv_chC','C',03, 0, 0,'G','','SZ9','','','mv_par12'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,"13","Agrupar por    ?","","","mv_chD","N",01, 0, 1,"C","",""   ,"","","mv_par13"           ,"Cliente","Cliente","Cliente","","Cliente+Loja","Cliente+Loja","Cliente+Loja","","","","","","","","","",{},{},{})
PutSx1(cPerg,"14","Resultado      ?","","","mv_chE","N",01, 0, 1,"C","",""   ,"","","mv_par14"           ,"Valor","Valor","Valor","","Qtde","Qtde","Qtde","","","","","","","","","",{},{},{})
Return NIL