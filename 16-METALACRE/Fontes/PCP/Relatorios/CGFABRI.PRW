#INCLUDE "rwmake.ch"                                                                                                                                     
#INCLUDE "protheus.ch"

#Define CRLF ( chr(13)+chr(10) )

#DEFINE CF1_PEDIDO	001
#DEFINE CF1_CLIENTE 002
#DEFINE CF1_XGRUPO	003
#DEFINE CF1_GRUPO	004
#DEFINE CF1_NUMOP	005
#DEFINE CF1_PEDCLI	006
#DEFINE CF1_ENTREGA	007
#DEFINE CF1_SALDO	008
#DEFINE CF1_CAPACID	009
#DEFINE CF1_TOTAPRO 010
#DEFINE CF1_TOTEPRO 011

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CgFabri  บ Autor ณ Luiz Alberto       บ Data ณ  24/06/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio Novo Carga Fabrica                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CgFabri()
Local oReport
Private cPerg 	:= PADR('CGFABRI',10) 
	
ValidPerg()
If !Pergunte(cPerg,.T.) 
	Return
Endif
If TRepInUse() //verifica se relatorios personalizaveis esta disponivel 
	oReport := ReportDef() 
	oReport:PrintDialog() 
EndIf 
	
Return 
    
 
Static Function ReportDef() 
	Local oReport 
	Local oSection1 	 
 
	oReport := TReport():New('CGFABRI',"Relat๓rio Carga Fabrica",cPerg,{|oReport| PrintReport(oReport)},"Esta Rotina irแ imprimir o Relat๓rio Carga Fabrica") 	
	oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao
	oReport:SetTotalInLine(.T.) // Impressao do total geral das colunas somadas
	oReport:ShowFooter()
	
	oSection1 := TRSection():New(oReport,"Relat๓rio Carga Fabrica",{"SA1"}) 
	oSection1:SetTotalInLine(.T.) // impressao do total por sessao das colunas somadas
	
	//UF VENDEDOR	QTD ORวAMENTOS	QTD FATURADOS	QTD CANCELADOS	 TOTAL ORวAMENTOS 	 TOTAL FATURADOS 	 TOTAL CANCELADOS 	 ORCADO X FATURADO 	CLIENTES 1a. COMPRA	NOVOS PROSPECTS

	If MV_PAR04 == 1
		TRCell():New(oSection1,"COL01"	    ,"   ","Pedido"		   		,'@!'		, TamSX3("C5_NUM")[1])
		TRCell():New(oSection1,"COL02"      ,"   ","Cliente"	   		,'@!'	   	, TamSX3("A1_NOME")[1]) 
		TRCell():New(oSection1,"COL03"      ,"   ","Grupo"		   		,'@!'	   	, TamSX3("B1_GRUPO")[1]) 
		TRCell():New(oSection1,"COL04"      ,"   ","O.P."		   		,'@!'	    , TamSX3("C2_NUM")[1]) 
		TRCell():New(oSection1,"COL05"   	,"   ","Ped.Cliente"		,'@!'		, TamSX3("C6_PEDCLI")[1]) 
		TRCell():New(oSection1,"COL06"  	,"   ","Entrega"			,'99/99/9999', 12) 
		TRCell():New(oSection1,"COL07"      ,"   ","Saldo Disponivel"	,'@E 9,999,999.9', TamSX3("C6_QTDVEN")[1]) 
		TRCell():New(oSection1,"COL08"	    ,"   ","Capacidade"			,'@E 9,999,999.9', TamSX3("C6_QTDVEN")[1]) 
		TRCell():New(oSection1,"COL09" 		,"   ","Total a Produzir"	,'@E 9,999,999.9', TamSX3("C6_QTDVEN")[1]) 
		TRCell():New(oSection1,"COL10"		,"   ","Total Producao"		,'@E 9,999,999.9', TamSX3("C6_QTDVEN")[1]) 
	ElseIf MV_PAR04 == 2
		TRCell():New(oSection1,"COL03"      ,"   ","Grupo"		   		,'@!'	   	, TamSX3("B1_GRUPO")[1]) 
		TRCell():New(oSection1,"COL06"  	,"   ","Entrega"			,'99/99/9999', 12) 
		TRCell():New(oSection1,"COL07"      ,"   ","Saldo Disponivel"	,'@E 9,999,999.9', TamSX3("C6_QTDVEN")[1]) 
		TRCell():New(oSection1,"COL08"	    ,"   ","Capacidade"			,'@E 9,999,999.9', TamSX3("C6_QTDVEN")[1]) 
		TRCell():New(oSection1,"COL09" 		,"   ","Total a Produzir"	,'@E 9,999,999.9', TamSX3("C6_QTDVEN")[1]) 
		TRCell():New(oSection1,"COL10"		,"   ","Total Producao"		,'@E 9,999,999.9', TamSX3("C6_QTDVEN")[1]) 
	Endif

	oBreak1 := TRBreak():New(oSection1,oSection1:Cell("COL03"),"Grupo:",.F.,)

	TRFunction():New(oSection1:Cell("COL07")  ,NIL,"SUM",oBreak1 ,/*Titulo*/,'@E 999,999,999.99',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("COL08")  ,NIL,"SUM",oBreak1 ,/*Titulo*/,'@E 999,999,999.99',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("COL09")  ,NIL,"SUM",oBreak1 ,/*Titulo*/,'@E 999,999,999.99',/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("COL10")  ,NIL,"SUM",oBreak1 ,/*Titulo*/,'@E 999,999,999.99',/*uFormula*/,.F.,.F.)
		
Return oReport 

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
 
Static Function PrintReport(oReport)
Local cQuery	    := ""
Local oSection1 := oReport:Section(1)

If MV_PAR04 == 1	// Detalhado
	cQuery:= " SELECT C2_PEDIDO, C5_CLIENTE, C5_LOJACLI, B1_GRUPO, B1_XGRUPO, C2_NUM, C6_PEDCLI PEDCLI, C2_DATPRF, ZH_SLDGRP, ZH_CAPGRP, 0 ZH_GRPAPR, ZH_GRPUSO "
	cQuery+= " FROM " + RetSqlName("SC2") + " C2, " + RetSqlName("SB1") + " B1, " + RetSqlName("SBM") + " BM, " + RetSqlName("SZH") + " ZH, " + RetSqlName("SC5") + " C5, " + RetSqlName("SC6") + " C6 "
	cQuery+= " WHERE    C2_FILIAL='" + xFilial("SC2") + "' AND C2.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      B1.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      C5.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      C6.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      ZH.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      BM_FILIAL='" + xFilial("SBM") + "' AND BM.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      B1_FILIAL='" + xFilial("SB1") + "' AND B1.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      C5_FILIAL='" + xFilial("SC5") + "' "
	cQuery+= " AND      C6_FILIAL='" + xFilial("SC6") + "' "
	cQuery+= " AND      C2_PRODUTO = B1_COD           "
	cQuery+= " AND      ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO)    "
	cQuery+= " AND		 ZH_GRUPO = BM_GRUPO "
	cQuery+= " AND      ZH_DATA  = C2_DATPRF "
	cQuery+= " AND (C2_QUANT-C2_QUJE-C2_PERDA) > 0 AND (C2_PEDIDO <> '' OR B1_TIPO IN ('PA','PC') )  "
	cQuery+= " AND NOT (C2_TPOP = 'F' AND C2_DATRF <> '' AND (C2_QUJE < C2_QUANT OR C2_QUJE >= C2_QUANT))                              "
	cQuery+= " AND C2_DATPRF BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "' "
	cQuery+= " AND C2_PEDIDO = C5_NUM "
	cQuery+= " AND C6_PRODUTO = C2_PRODUTO "
	cQuery+= " AND C6_ITEM = C2_ITEM "
	cQuery+= " AND C6_NUM = C5_NUM "

	cQuery+= " UNION ALL

	cQuery+= " SELECT C6_NUM, C6_CLI, C6_LOJA, B1_GRUPO, B1_XGRUPO, C6_NUM, C6_PEDCLI PEDCLI, C6_ENTREG, ZH_SLDGRP, ZH_CAPGRP, ZH_GRPAPR, 0 ZH_GRPUSO "
	cQuery+= " FROM " + RetSqlName("SC6") + " C6, " + RetSqlName("SB1") + " B1, " + RetSqlName("SBM") + " BM, " + RetSqlName("SZH") + " ZH, " + RetSqlName("SC5") + " C5 "
	cQuery+= " WHERE C6_FILIAL='" + xFilial("SB1") + "' AND C6.D_E_L_E_T_<>'*'       "
	cQuery+= " AND      C5_FILIAL='" + xFilial("SB1") + "' AND C5.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      B1.D_E_L_E_T_<>'*'  AND      B1_FILIAL='" + xFilial("SB1") + "'  "
	cQuery+= " AND      BM_FILIAL='" + xFilial("SB1") + "' AND BM.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      ZH.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      C6_BLQ NOT IN('R')  AND C6_PRODUTO = B1_COD      "
	cQuery+= " AND      C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND C5_TIPO = 'N'   "
	cQuery+= " AND      ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO)    "
	cQuery+= " AND      C6_TES <> '516'           "
	cQuery+= " AND	  ZH_GRUPO = BM_GRUPO  "
	cQuery+= " AND	  ZH_DATA = C6_ENTREG  "
	cQuery+= " AND C6_ENTREG BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "' "
	cQuery+= " AND C6_NUMOP = '' "
	cQuery+= " ORDER BY 8, 1 "

ElseIf MV_PAR04 == 2

	cQuery:= " SELECT B1_GRUPO, B1_XGRUPO, C2_DATPRF, SUM(ZH_SLDGRP) ZH_SLDGRP, SUM(ZH_CAPGRP) ZH_CAPGRP, SUM(0) ZH_GRPAPR, SUM(ZH_GRPUSO) ZH_GRPUSO "
	cQuery+= " FROM " + RetSqlName("SC2") + " C2, " + RetSqlName("SB1") + " B1, " + RetSqlName("SBM") + " BM, " + RetSqlName("SZH") + " ZH, " + RetSqlName("SC5") + " C5, " + RetSqlName("SC6") + " C6 "
	cQuery+= " WHERE    C2_FILIAL='" + xFilial("SC2") + "' AND C2.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      B1.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      C5.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      C6.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      ZH.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      BM_FILIAL='" + xFilial("SBM") + "' AND BM.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      B1_FILIAL='" + xFilial("SB1") + "' AND B1.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      C5_FILIAL='" + xFilial("SC5") + "' "
	cQuery+= " AND      C6_FILIAL='" + xFilial("SC6") + "' "
	cQuery+= " AND      C2_PRODUTO = B1_COD           "
	cQuery+= " AND      ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO)    "
	cQuery+= " AND		 ZH_GRUPO = BM_GRUPO "
	cQuery+= " AND      ZH_DATA  = C2_DATPRF "
	cQuery+= " AND (C2_QUANT-C2_QUJE-C2_PERDA) > 0 AND (C2_PEDIDO <> '' OR B1_TIPO IN ('PA','PC') )  "
	cQuery+= " AND NOT (C2_TPOP = 'F' AND C2_DATRF <> '' AND (C2_QUJE < C2_QUANT OR C2_QUJE >= C2_QUANT))                              "
	cQuery+= " AND C2_DATPRF BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "' "
	cQuery+= " AND C2_PEDIDO = C5_NUM "
	cQuery+= " AND C6_PRODUTO = C2_PRODUTO "
	cQuery+= " AND C6_ITEM = C2_ITEM "
	cQuery+= " AND C6_NUM = C5_NUM "
	cQuery+= " GROUP BY B1_GRUPO, B1_XGRUPO, C2_DATPRF "

	cQuery+= " UNION ALL

	cQuery+= " SELECT B1_GRUPO, B1_XGRUPO, C6_ENTREG, SUM(ZH_SLDGRP) ZH_SLDGRP, SUM(ZH_CAPGRP) ZH_CAPGRP, SUM(ZH_GRPAPR) ZH_GRPAPR, SUM(0) ZH_GRPUSO "
	cQuery+= " FROM " + RetSqlName("SC6") + " C6, " + RetSqlName("SB1") + " B1, " + RetSqlName("SBM") + " BM, " + RetSqlName("SZH") + " ZH, " + RetSqlName("SC5") + " C5 "
	cQuery+= " WHERE C6_FILIAL='" + xFilial("SB1") + "' AND C6.D_E_L_E_T_<>'*'       "
	cQuery+= " AND      C5_FILIAL='" + xFilial("SB1") + "' AND C5.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      B1.D_E_L_E_T_<>'*'  AND      B1_FILIAL='" + xFilial("SB1") + "'  "
	cQuery+= " AND      BM_FILIAL='" + xFilial("SB1") + "' AND BM.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      ZH.D_E_L_E_T_<>'*'   "
	cQuery+= " AND      C6_BLQ NOT IN('R')  AND C6_PRODUTO = B1_COD      "
	cQuery+= " AND      C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND C5_TIPO = 'N'   "
	cQuery+= " AND      ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO)    "
	cQuery+= " AND      C6_TES <> '516'           "
	cQuery+= " AND	  ZH_GRUPO = BM_GRUPO  "
	cQuery+= " AND	  ZH_DATA = C6_ENTREG  "
	cQuery+= " AND C6_ENTREG BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "' "
	cQuery+= " AND C6_NUMOP = '' "
	cQuery+= " GROUP BY B1_GRUPO, B1_XGRUPO, C6_ENTREG "
	cQuery+= " ORDER BY 3, 1 "

Endif

cQuery := ChangeQuery(cQuery) 	// otimiza a query de acordo c/ o banco 	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CHKV",.T.,.T.)

tcSetField("CHKV","C2_DATPRF","D")

aCargas	:= {}

dbSelectArea("CHKV")
Count To nReg
dbGoTop()
ProcRegua(nReg)
While CHKV->(!Eof())
	IncProc("Aguarde Processando os Dados")
	
	If MV_PAR04 == 1
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+CHKV->C5_CLIENTE+CHKV->C5_LOJACLI))
	
		AAdd(aCargas,{CHKV->C2_PEDIDO,;
							CHKV->C5_CLIENTE+'/'+CHKV->C5_LOJACLI + ' - ' + SA1->A1_NOME,;
							Iif(!Empty(CHKV->B1_XGRUPO),CHKV->B1_XGRUPO,CHKV->B1_GRUPO),;
							CHKV->B1_XGRUPO,;
							CHKV->C2_NUM,;
							CHKV->PEDCLI,;
							CHKV->C2_DATPRF,;
							CHKV->ZH_SLDGRP,;
							CHKV->ZH_CAPGRP,;
							CHKV->ZH_GRPAPR,;
							CHKV->ZH_GRPUSO})

	ElseIf MV_PAR04 == 2
		nAchou := Ascan(aCargas,{|x| x[3]==Iif(!Empty(CHKV->B1_XGRUPO),CHKV->B1_XGRUPO,CHKV->B1_GRUPO) .And. x[7]==CHKV->C2_DATPRF})
		If Empty(nAchou)	
			AAdd(aCargas,{'',;
								'',;
								Iif(!Empty(CHKV->B1_XGRUPO),CHKV->B1_XGRUPO,CHKV->B1_GRUPO),;
								CHKV->B1_XGRUPO,;
								'',;
								'',;
								CHKV->C2_DATPRF,;
								CHKV->ZH_SLDGRP,;
								CHKV->ZH_CAPGRP,;
								CHKV->ZH_GRPAPR,;
								CHKV->ZH_GRPUSO})
		Else 
			aCargas[nAchou,CF1_TOTAPRO]	+=	CHKV->ZH_GRPAPR
			aCargas[nAchou,CF1_TOTEPRO]	+=	CHKV->ZH_GRPUSO
		Endif
	Endif
	CHKV->(dbSkip(1))
Enddo
CHKV->(dbCloseArea())

// Tratamento dos Saldos

For nCarga := 1 To Len(aCargas)
	If Len(AllTrim(aCargas[nCarga,CF1_XGRUPO]))==4	// SubGrupo
		nAchou := Ascan(aCargas,{|x| AllTrim(x[CF1_XGRUPO])==Left(aCargas[nCarga,CF1_XGRUPO],3) .And. x[CF1_ENTREGA]==aCargas[nCarga,CF1_ENTREGA]})
		If !Empty(nAchou)		
			aCargas[nAchou,CF1_SALDO]	+=	(aCargas[nCarga,CF1_TOTAPRO]+aCargas[nCarga,CF1_TOTEPRO])
			aCargas[nAchou,CF1_TOTAPRO]	-=	aCargas[nCarga,CF1_TOTAPRO]
			aCargas[nAchou,CF1_TOTEPRO]	-=	aCargas[nCarga,CF1_TOTEPRO]
		Endif
	Endif
Next

// Impressao

For nCarga := 1 To Len(aCargas)
	If oReport:Cancel() 
		Exit 
	EndIf 
			   
	oSection1:Init()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicio da impressao do cabecalho das NFs                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         	

	If MV_PAR04 == 1
	   	oSection1:Cell("COL01"):SetValue(aCargas[nCarga,CF1_PEDIDO])	
		oSection1:Cell("COL02"):SetValue(aCargas[nCarga,CF1_CLIENTE])
		oSection1:Cell("COL03"):SetValue(aCargas[nCarga,CF1_XGRUPO])
		oSection1:Cell("COL04"):SetValue(aCargas[nCarga,CF1_NUMOP])
		oSection1:Cell("COL05"):SetValue(aCargas[nCarga,CF1_PEDCLI])
		oSection1:Cell("COL06"):SetValue(aCargas[nCarga,CF1_ENTREGA])
		oSection1:Cell("COL07"):SetValue(aCargas[nCarga,CF1_SALDO])
		oSection1:Cell("COL08"):SetValue(aCargas[nCarga,CF1_CAPACID])
		oSection1:Cell("COL09"):SetValue(aCargas[nCarga,CF1_TOTAPRO])
		oSection1:Cell("COL10"):SetValue(aCargas[nCarga,CF1_TOTEPRO])
	ElseIf MV_PAR04 == 2
		oSection1:Cell("COL03"):SetValue(aCargas[nCarga,CF1_XGRUPO])
		oSection1:Cell("COL06"):SetValue(aCargas[nCarga,CF1_ENTREGA])
		oSection1:Cell("COL07"):SetValue(aCargas[nCarga,CF1_SALDO])
		oSection1:Cell("COL08"):SetValue(aCargas[nCarga,CF1_CAPACID])
		oSection1:Cell("COL09"):SetValue(aCargas[nCarga,CF1_TOTAPRO])
		oSection1:Cell("COL10"):SetValue(aCargas[nCarga,CF1_TOTEPRO])
	Endif	
	//Imprime registros na secao 1 
	oSection1:PrintLine()		       
			
Next
oSection1:Finish()			
Return    


*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Criacao do Grupo de Perguntas                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()
_aArea := GetArea()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(cPerg,10)

aRegs :={}
Aadd(aRegs,{cPerg,"01","Produto de              ?","mv_ch1","C",30,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SB1",""})
Aadd(aRegs,{cPerg,"02","Produto Ate             ?","mv_ch2","C",30,0,0,"G","","mv_par02","","","","","","","","","","","","","","","SB1",""})
Aadd(aRegs,{cPerg,"03","Grupo		            ?","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SBM",""})
Aadd(aRegs,{cPerg,"04","Tipo			        ?","mv_ch4","N",01,0,3,"C","","mv_par04","Analitico","","","Sintetico","","","","","","","","","","","",''})
Aadd(aRegs,{cPerg,"05","Entrega de              ?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Entrega Ate             ?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","",""})

For i := 1 To Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := aRegs[i,01]
		SX1->X1_ORDEM   := aRegs[i,02]
		SX1->X1_PERGUNT := aRegs[i,03]
		SX1->X1_VARIAVL := aRegs[i,04]
		SX1->X1_TIPO    := aRegs[i,05]
		SX1->X1_TAMANHO := aRegs[i,06]
		SX1->X1_DECIMAL := aRegs[i,07]
		SX1->X1_PRESEL  := aRegs[i,08]
		SX1->X1_GSC     := aRegs[i,09]
		SX1->X1_VALID   := aRegs[i,10]
		SX1->X1_VAR01   := aRegs[i,11]
		SX1->X1_DEF01   := aRegs[i,12]
		SX1->X1_CNT01   := aRegs[i,13]
		SX1->X1_VAR02   := aRegs[i,14]
		SX1->X1_DEF02   := aRegs[i,15]
		SX1->X1_CNT02   := aRegs[i,16]
		SX1->X1_VAR03   := aRegs[i,17]
		SX1->X1_DEF03   := aRegs[i,18]
		SX1->X1_CNT03   := aRegs[i,19]
		SX1->X1_VAR04   := aRegs[i,20]
		SX1->X1_DEF04   := aRegs[i,21]
		SX1->X1_CNT04   := aRegs[i,22]
		SX1->X1_VAR05   := aRegs[i,23]
		SX1->X1_DEF05   := aRegs[i,24]
		SX1->X1_CNT05   := aRegs[i,25]
		SX1->X1_F3      := aRegs[i,26]    
		SX1->X1_VALID	:= aRegs[i,27]
		MsUnlock()
		DbCommit()
	Endif
Next

RestArea(_aArea)

Return()
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
