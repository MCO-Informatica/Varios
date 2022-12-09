#INCLUDE "protheus.ch"

#DEFINE VND_UF		001
#DEFINE VND_VEND	002
#DEFINE VND_NOME	003
#DEFINE VND_QORC	004
#DEFINE VND_QFAT	005
#DEFINE VND_QCAN	006
#DEFINE VND_TORC	007
#DEFINE VND_TFAT	008
#DEFINE VND_TCAN	009
/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³ RelVendas2 ³ AUTOR ³ Luiz Alberto V Alves  ³ DATA ³ 16/12/14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ Relatorio de Vendas Negociadas por Uf/Vendedor 			  ³±±
±±³          ³ 			                                                  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PROGRAMADOR    ³ DATA   ³ MOTIVO DA ALTERACAO		                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³               ³        ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function RVnd2()

Local oReport
Private cPerg 	:= PADR('RELVND2',10) 
	
	
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
 
	oReport := TReport():New('RELVND2',"Relatório Fechamento de Negócios",'RELVND2',{|oReport| PrintReport(oReport)},"Esta Rotina irá imprimir o Relatório Fechamento de Negócios") 	
	oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao
	oReport:SetTotalInLine(.T.) // Impressao do total geral das colunas somadas
	oReport:ShowFooter()
	
	oSection1 := TRSection():New(oReport,"Relatório Fechamento de Negócios",{"SUA",'SUB','SA3','SA1','SUS'}) 
	oSection1:SetTotalInLine(.T.) // impressao do total por sessao das colunas somadas
	
	//UF VENDEDOR	QTD ORÇAMENTOS	QTD FATURADOS	QTD CANCELADOS	 TOTAL ORÇAMENTOS 	 TOTAL FATURADOS 	 TOTAL CANCELADOS 	 ORCADO X FATURADO 	CLIENTES 1a. COMPRA	NOVOS PROSPECTS

	TRCell():New(oSection1,"_cUF"		    ,"   ","UF"			   		,PesqPict("SA1","A1_EST")		, TamSX3("A1_EST")[1])
	TRCell():New(oSection1,"_cVendedo"      ,"   ","Código"		   		,PesqPict("SA3","A3_COD")	    , TamSX3("A3_COD")[1]) 
	TRCell():New(oSection1,"_cVendNom"      ,"   ","Vendedor(a)"   		,PesqPict("SA3","A3_NREDUZ")	    , TamSX3("A3_NREDUZ")[1]) 
	TRCell():New(oSection1,"_nQtdOrcs"   	,"   ","Qtd Orçamentos"		,'9999'						    , 4)
	TRCell():New(oSection1,"_nQtdFats"  	,"   ","Qtd Faturados" 		,'9999'							, 4)
	TRCell():New(oSection1,"_nQtdCanc"      ,"   ","Qtd Cancelados"		,'9999'						    , 4)
	TRCell():New(oSection1,"_nTotOrcs"	    ,"   ","Total Orçamentos"   ,PesqPict("SF2","F2_VALBRUT")	    , TamSX3("F2_VALBRUT")[1])
	TRCell():New(oSection1,"_nTotFats" 		,"   ","Total Faturados"	,PesqPict("SF2","F2_VALBRUT")	    , TamSX3("F2_VALBRUT")[1])
	TRCell():New(oSection1,"_nTotCanc"		,"   ","Total Cancelados"   ,PesqPict("SF2","F2_VALBRUT")	    , TamSX3("F2_VALBRUT")[1])
	TRCell():New(oSection1,"_PerOrcFt"	    ,"   ","Orçado x Faturado"  ,'@E 9999.99'						, 7)	 				 	

	// Centraliza o cabeçalho das colunas abaixo
	oSection1:Cell("_nQtdOrcs"):SetHeaderAlign("CENTER") 
	oSection1:Cell("_nQtdFats"):SetHeaderAlign("CENTER") 
	oSection1:Cell("_nQtdCanc"):SetHeaderAlign("CENTER") 	
                                          	
	oSection1:Cell("_cVendedo"):nSize := 6	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cVendedo"):lHeaderSize := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao da Segunda Secao: Funcionario  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
//	oSection2 := TRSection():New(oSection1,'Canceladas x Motivos',{"SUA"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)		//Funcionario	
//	oSection2:SetTotalInLine(.F.)
//	oSection2:SetHeaderBreak(.T.)
//	oSection2:SetLeftMargin(1)	//Identacao da Secao  
	
//	TRCell():New(oSection2,"_cCodOcor"		    ,"   ","Ocorrências"			   		,'@!'		, 6)
//	TRCell():New(oSection2,"_cOcoDesc"		    ,"   ","Descrição Motivo"		   		,'@!'		, 30)
//	TRCell():New(oSection2,"_nQtdCOco"		    ,"   ","Quantidade"			 	  		,'9999'		, 4)
//	TRCell():New(oSection2,"_nVlrCOco"		    ,"   ","Valor Total"			   		,PesqPict("SF2","F2_VALBRUT")	    , TamSX3("F2_VALBRUT")[1])

	oBreak1 := TRBreak():New(oSection1,oSection1:Cell("_cUF"),"TOTAL UF:",.F.,)

	TRFunction():New(oSection1:Cell("_nQtdOrcs")  ,NIL,"SUM",oBreak1 ,/*Titulo*/,'9999999',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("_nQtdFats")  ,NIL,"SUM",oBreak1 ,/*Titulo*/,'9999999',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("_nQtdCanc")  ,NIL,"SUM",oBreak1 ,/*Titulo*/,'9999999',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("_nTotOrcs")  ,'TORCS',"SUM",oBreak1 ,/*Titulo*/,'@E 999,999,999.99',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("_nTotFats")  ,'TFATS',"SUM",oBreak1 ,/*Titulo*/,'@E 999,999,999.99',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("_nTotCanc")  ,NIL,"SUM",oBreak1 ,/*Titulo*/,'@E 999,999,999.99',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("_PerOrcFt")  ,'TPERC',"ONPRINT",oBreak1 ,/*Titulo*/,'@E 9,999.99',/*uFormula*/,.F.,.F.)
	
	oReport:GetFunction('TPERC'):SetFormula({|| (oReport:GetFunction('TFATS'):uLastValue / oReport:GetFunction('TORCS'):uLastValue) * 100 })
		
Return oReport 

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
 
Static Function PrintReport(oReport)
Local cQuery	    := ""
Local oSection1 := oReport:Section(1)

If MV_PAR07 == 1	// Quebra por Estado
	cQuery :=" SELECT DISTINCT 'ORCAMENTO' TIPO, A1_EST, UA_VEND, SUM(UA_VALBRUT) TOTAL_ORCAMENTO, COUNT(UA_NUM) QTD_ORCAMENTOS, SUM(0) TOTAL_FATURADO, COUNT(0) QTD_FATURADO, SUM(0) TOTAL_CANCELADO, COUNT(0) QTD_CANCELADO "
	cQuery +=" FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SA1") + " A1 "
	cQuery +=" WHERE UA.D_E_L_E_T_ = '' "
	cQuery +=" AND UA_VEND <> ''         "
	cQuery +=" AND A1.D_E_L_E_T_ = '' "
	cQuery +=" AND UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery +=" AND UA_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" AND A1_EST  BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery +=" AND UA_STATUS <> 'CAN' "
	cQuery +=" AND UA_OPER IN('1','2') "
	cQuery +=" AND A1_COD = UA_CLIENTE "
	cQuery +=" AND A1_LOJA = UA_LOJA "
	cQuery +=" GROUP BY A1_EST, UA_VEND "
	cQuery +=" UNION ALL "
	cQuery +=" SELECT DISTINCT 'FATURADO' TIPO, A1_EST, C5_VEND1, SUM(0) TOTAL_ORCAMENTO, COUNT(0) QTD_ORCAMENTOS, SUM(C5_TOTPED) TOTAL_FATURADO, COUNT(C5_NUM) QTD_FATURADO, SUM(0) TOTAL_CANCELADO, COUNT(0) QTD_CANCELADO "
	cQuery +=" FROM " + RetSqlName("SC5") + " C5, " + RetSqlName("SA1") + " A1 " 
	cQuery +=" WHERE C5.D_E_L_E_T_ = '' "
	cQuery +=" AND A1.D_E_L_E_T_ = '' "
	cQuery +=" AND C5_VEND1 <> '' "
	cQuery +=" AND C5_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery +=" AND C5_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" AND A1_EST  BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery +=" AND C5_TIPO = 'N' "
	cQuery +=" AND C5_PEDWEB = '' "
	cQuery +=" AND C5_NUMAT <> '' "
	cQuery +=" AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI "
	cQuery +=" GROUP BY A1_EST, C5_VEND1 "
	cQuery +=" UNION ALL "
	cQuery +=" SELECT DISTINCT 'CANCELADO' TIPO, A1_EST, UA_VEND, SUM(0) TOTAL_ORCAMENTO, COUNT(0) QTD_ORCAMENTOS, SUM(0) TOTAL_FATURADO, COUNT(0) QTD_FATURADO, SUM(UA_VALBRUT) TOTAL_CANCELADO, COUNT(UA_NUM) QTD_CANCELADO "
	cQuery +=" FROM " + RetSqlName("SUA") + " UA, " + RetSqlName("SA1") + " A1 "
	cQuery +=" WHERE UA.D_E_L_E_T_ = '' "
	cQuery +=" AND UA_VEND <> '' "
	cQuery +=" AND A1.D_E_L_E_T_ = '' "
	cQuery +=" AND UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery +=" AND UA_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" AND A1_EST  BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery +=" AND UA_STATUS = 'CAN' "
	cQuery +=" AND UA_OPER IN('1','2') "
	cQuery +=" AND A1_COD = UA_CLIENTE "
	cQuery +=" AND A1_LOJA = UA_LOJA "
	cQuery +=" GROUP BY A1_EST, UA_VEND "
	cQuery +=" ORDER BY A1_EST, UA_VEND "
ElseIf MV_PAR07 == 2
	cQuery :=" SELECT DISTINCT 'ORCAMENTO' TIPO, UA_VEND, SUM(UA_VALBRUT) TOTAL_ORCAMENTO, COUNT(UA_NUM) QTD_ORCAMENTOS, SUM(0) TOTAL_FATURADO, COUNT(0) QTD_FATURADO, SUM(0) TOTAL_CANCELADO, COUNT(0) QTD_CANCELADO "
	cQuery +=" FROM " + RetSqlName("SUA") + " UA "
	cQuery +=" WHERE UA.D_E_L_E_T_ = '' "
	cQuery +=" AND UA_VEND <> ''         "
	cQuery +=" AND UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery +=" AND UA_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" AND UA_STATUS <> 'CAN' "
	cQuery +=" AND UA_OPER IN('1','2') "
	cQuery +=" GROUP BY UA_VEND "
	cQuery +=" UNION ALL "
	cQuery +=" SELECT DISTINCT 'FATURADO' TIPO, C5_VEND1, SUM(0) TOTAL_ORCAMENTO, COUNT(0) QTD_ORCAMENTOS, SUM(C5_TOTPED) TOTAL_FATURADO, COUNT(C5_NUM) QTD_FATURADO, SUM(0) TOTAL_CANCELADO, COUNT(0) QTD_CANCELADO "
	cQuery +=" FROM " + RetSqlName("SC5") + " C5 "
	cQuery +=" WHERE C5.D_E_L_E_T_ = '' "
	cQuery +=" AND C5_VEND1 <> '' "
	cQuery +=" AND C5_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery +=" AND C5_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" AND C5_TIPO = 'N' "
	cQuery +=" AND C5_PEDWEB = '' "
	cQuery +=" AND C5_NUMAT <> '' "
	cQuery +=" GROUP BY C5_VEND1 "
	cQuery +=" UNION ALL "
	cQuery +=" SELECT DISTINCT 'CANCELADO' TIPO, UA_VEND, SUM(0) TOTAL_ORCAMENTO, COUNT(0) QTD_ORCAMENTOS, SUM(0) TOTAL_FATURADO, COUNT(0) QTD_FATURADO, SUM(UA_VALBRUT) TOTAL_CANCELADO, COUNT(UA_NUM) QTD_CANCELADO "
	cQuery +=" FROM " + RetSqlName("SUA") + " UA "
	cQuery +=" WHERE UA.D_E_L_E_T_ = '' "
	cQuery +=" AND UA_VEND <> '' "
	cQuery +=" AND UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery +=" AND UA_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" AND UA_STATUS = 'CAN' "
	cQuery +=" AND UA_OPER IN('1','2') "
	cQuery +=" GROUP BY UA_VEND "
	cQuery +=" ORDER BY UA_VEND "
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
	
	If MV_PAR07 == 1
		nAchou	:= Ascan(aVendas,{|x| x[1]==CHKV->A1_EST .And. x[2] == CHKV->UA_VEND})
		If Empty(nAchou)
			AAdd(aVendas,{CHKV->A1_EST,;
							CHKV->UA_VEND,;
							Posicione("SA3",1,xFilial("SA3")+CHKV->UA_VEND,"A3_NOME"),;
							Iif(CHKV->TIPO=='ORCAMENTO',CHKV->QTD_ORCAMENTOS,0),;
							Iif(CHKV->TIPO=='FATURADO ',CHKV->QTD_FATURADO,0),;
							Iif(CHKV->TIPO=='CANCELADO',CHKV->QTD_CANCELADO,0),;
							Iif(CHKV->TIPO=='ORCAMENTO',CHKV->TOTAL_ORCAMENTO,0),;
							Iif(CHKV->TIPO=='FATURADO ',CHKV->TOTAL_FATURADO,0),;
							Iif(CHKV->TIPO=='CANCELADO',CHKV->TOTAL_CANCELADO,0)})
		Else 
			aVendas[nAchou,VND_QORC] += Iif(CHKV->TIPO=='ORCAMENTO',CHKV->QTD_ORCAMENTOS,0)
			aVendas[nAchou,VND_QFAT] += Iif(CHKV->TIPO=='FATURADO ',CHKV->QTD_FATURADO,0)
			aVendas[nAchou,VND_QCAN] += Iif(CHKV->TIPO=='CANCELADO',CHKV->QTD_CANCELADO,0)
			aVendas[nAchou,VND_TORC] += Iif(CHKV->TIPO=='ORCAMENTO',CHKV->TOTAL_ORCAMENTO,0)
			aVendas[nAchou,VND_TFAT] += Iif(CHKV->TIPO=='FATURADO ',CHKV->TOTAL_FATURADO,0)
			aVendas[nAchou,VND_TCAN] += Iif(CHKV->TIPO=='CANCELADO',CHKV->TOTAL_CANCELADO,0)
		Endif
	ElseIf MV_PAR07 == 2
		nAchou	:= Ascan(aVendas,{|x| x[2] == CHKV->UA_VEND})
		If Empty(nAchou)
			AAdd(aVendas,{'',;
							CHKV->UA_VEND,;
							Posicione("SA3",1,xFilial("SA3")+CHKV->UA_VEND,"A3_NOME"),;
							Iif(CHKV->TIPO=='ORCAMENTO',CHKV->QTD_ORCAMENTOS,0),;
							Iif(CHKV->TIPO=='FATURADO ',CHKV->QTD_FATURADO,0),;
							Iif(CHKV->TIPO=='CANCELADO',CHKV->QTD_CANCELADO,0),;
							Iif(CHKV->TIPO=='ORCAMENTO',CHKV->TOTAL_ORCAMENTO,0),;
							Iif(CHKV->TIPO=='FATURADO ',CHKV->TOTAL_FATURADO,0),;
							Iif(CHKV->TIPO=='CANCELADO',CHKV->TOTAL_CANCELADO,0)})
		Else 
			aVendas[nAchou,VND_QORC] += Iif(CHKV->TIPO=='ORCAMENTO',CHKV->QTD_ORCAMENTOS,0)
			aVendas[nAchou,VND_QFAT] += Iif(CHKV->TIPO=='FATURADO ',CHKV->QTD_FATURADO,0)
			aVendas[nAchou,VND_QCAN] += Iif(CHKV->TIPO=='CANCELADO',CHKV->QTD_CANCELADO,0)
			aVendas[nAchou,VND_TORC] += Iif(CHKV->TIPO=='ORCAMENTO',CHKV->TOTAL_ORCAMENTO,0)
			aVendas[nAchou,VND_TFAT] += Iif(CHKV->TIPO=='FATURADO ',CHKV->TOTAL_FATURADO,0)
			aVendas[nAchou,VND_TCAN] += Iif(CHKV->TIPO=='CANCELADO',CHKV->TOTAL_CANCELADO,0)
		Endif
	Endif
	CHKV->(dbSkip(1))
Enddo
CHKV->(dbCloseArea())


For nVenda := 1 To Len(aVendas)
	If oReport:Cancel() 
		Exit 
	EndIf 
			   
	oSection1:Init()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicio da impressao do cabecalho das NFs                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         	
   		
   	oSection1:Cell("_cUF"):SetValue(aVendas[nVenda,VND_UF])	
	oSection1:Cell("_cVendedo"):SetValue(aVendas[nVenda,VND_VEND])
	oSection1:Cell("_cVendNom"):SetValue(aVendas[nVenda,VND_NOME])
	oSection1:Cell("_nQtdOrcs"):SetValue(aVendas[nVenda,VND_QORC])
	oSection1:Cell("_nQtdFats"):SetValue(aVendas[nVenda,VND_QFAT])
	oSection1:Cell("_nQtdCanc"):SetValue(aVendas[nVenda,VND_QCAN])
	oSection1:Cell("_nTotOrcs"):SetValue(aVendas[nVenda,VND_TORC])
	oSection1:Cell("_nTotFats"):SetValue(aVendas[nVenda,VND_TFAT])
	oSection1:Cell("_nTotCanc"):SetValue(aVendas[nVenda,VND_TCAN])
	oSection1:Cell("_PerOrcFt"):SetValue(Round((aVendas[nVenda,VND_TFAT]/aVendas[nVenda,VND_TORC])*100,2))						
	
	If MV_PAR07 == 2
		oSection1:Cell("_cUF"):Hide()
	Else	
		oSection1:Cell("_cUF"):Show()
	Endif

	//Imprime registros na secao 1 
	oSection1:PrintLine()		       
			
Next
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

PutSx1(cPerg,'01','Data De        ?','','','mv_ch1','D',08, 0, 0,'G','',''   ,'','','mv_par01'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'02','Data Ate       ?','','','mv_ch2','D',08, 0, 0,'G','',''   ,'','','mv_par02'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
PutSx1(cPerg,'03','Vendedor de    ?','','','mv_ch3','C', 6, 0, 0,'G','','SA3','','','mv_par03'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'04','Vendedor Ate   ?','','','mv_ch4','C', 6, 0, 0,'G','','SA3','','','mv_par04'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'05','Uf De          ?','','','mv_ch5','C', 2, 0, 0,'G','',''   ,'','','mv_par05'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'06','Uf Ate         ?','','','mv_ch6','C', 2, 0, 0,'G','',''   ,'','','mv_par06'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)
PutSx1(cPerg,'07','Agrupo por UF  ?','','','mv_ch7','N', 1, 0, 1,'C','',''   ,'','','mv_par07'           ,'Sim','','',''          ,'Nao','','','','','','','','','','','',aHelpPor07,aHelpPor07,aHelpPor07)
Return NIL