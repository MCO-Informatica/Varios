#INCLUDE "protheus.ch"

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³ RelOpor1 ³ AUTOR ³ Luiz Alberto V Alves  ³ DATA ³ 01/02/16³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ Relatorio de Oportunidade de Vendas						  ³±±
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
User Function RelLog()
Local oReport
Private cPerg 	:= PADR('LOGTIT',10) 
	
	
AjustaSX1()
Pergunte(cPerg,.T.) 
oReport := ReportDef() 
oReport:PrintDialog() 
	
Return 
    
 
Static Function ReportDef() 
	Local oReport 
	Local oSection1 	 
 
	cTitulo := "Log Titulos Inclusão Manual"
	cTitulo += " - Per: " + DtoC(MV_PAR01) + " - " + DtoC(MV_PAR02) 
	
	oReport := TReport():New('LOGTIT',cTitulo,'',{|oReport| PrintReport(oReport)},"Esta Rotina irá imprimir o Relatório Titulos Inclusão Manual") 	
	oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao
	
	oSection1 := TRSection():New(oReport,cTitulo,{"SE2"}) 

	TRCell():New(oSection1,"_cPrefixo"      ,"   ","Prefixo"	   		,PesqPict("SE2","E2_PREFIXO")	    , TamSX3("E2_PREFIXO")[1]) 
	TRCell():New(oSection1,"_cNumero"   	,"   ","Numero"				,PesqPict("SE2","E2_NUM")	    	, TamSX3("E2_NUM")[1]) 
	TRCell():New(oSection1,"_cParcela"  	,"   ","Parcela" 			,PesqPict("SE2","E2_PARCELA")	    , TamSX3("E2_PARCELA")[1]) 
	TRCell():New(oSection1,"_cTipo"		  	,"   ","Tipo"				,PesqPict("SE2","E2_TIPO")	    	, TamSX3("E2_PARCELA")[1]) 
	TRCell():New(oSection1,"_cFornece"      ,"   ","Fornecedor"			,PesqPict("SE2","E2_FORNECE")	    , TamSX3("E2_FORNECE")[1]) 
	TRCell():New(oSection1,"_cNome"		    ,"   ","Razao"			    ,PesqPict("SA2","A2_NREDUZ")		, TamSX3("A2_NREDUZ")[1])
	TRCell():New(oSection1,"_dEmissao"		,"   ","Emissao"	   		,'99/99/9999'						, 10)
	TRCell():New(oSection1,"_dVencto"		,"   ","Vencto"		   		,'99/99/9999'						, 10)
	TRCell():New(oSection1,"_dBaixa"		,"   ","Baixa"		   		,'99/99/9999'						, 10)
	TRCell():New(oSection1,"_cRefe"			,"   ","Referencia"	   		,''						, 10)
	TRCell():New(oSection1,"_nValor"		,"   ","Valor"		   		,PesqPict("SE2","E2_VALOR")		    , TamSX3("E2_VALOR")[1])
	TRCell():New(oSection1,"_cUsuInc" 		,"   ","Usuario"		,''		    , 15)
	TRCell():New(oSection1,"_dUsuInc" 		,"   ","Data"		,'99/99/9999'	    , 10)
	TRCell():New(oSection1,"_cDelete" 		,"   ","Reg Deletado"		,'@!'	    , 10)

	If MV_PAR05 == 1
		oBreak1 := TRBreak():New(oSection1,oSection1:Cell("_cFornece"),"T O T A L  F O R N E C E D O R:",.F.,)
	ElseIf MV_PAR05 == 2
		oBreak1 := TRBreak():New(oSection1,oSection1:Cell("_cRefe"),"T O T A L  R E F E R E N C I A:",.F.,)
	Endif

	TRFunction():New(oSection1:Cell("_nValor")  ,NIL,"SUM",oBreak1 ,/*Titulo*/,'@E 9,999,999,999.99',/*uFormula*/,.F.,.F.)
	

	oSection1:Cell("_cNumero"):lHeaderSize := .F.
	oSection1:Cell("_dEmissao"):lHeaderSize := .F.
	oSection1:Cell("_dVencto"):lHeaderSize := .F.
	oSection1:Cell("_cNumero"):lHeaderSize := .F.
	oSection1:Cell("_dBaixa"):lHeaderSize := .F.
	oSection1:Cell("_cUsuInc"):lHeaderSize := .F.
	oSection1:Cell("_dUsuInc"):lHeaderSize := .F.

	oSection1:SetTotalInLine(.F.)     
	TRFunction():New(oSection1:Cell("_nValor"),/*cId*/,"SUM"     ,/*oBreak*/,,'@E 9,999,999,999.99',/*uFormula*/,.F.           ,.T.           ,.F.        ,)


Return oReport 

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
 
Static Function PrintReport(oReport)
Local cQuery	    := ""
Local oSection1 := oReport:Section(1)
Local cQuery := ''

If MV_PAR07 == 2 .Or. MV_PAR07 == 3
	cQuery :=" SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, A2_NREDUZ, E2_EMISSAO, E2_VENCTO, E2_VENCREA, E2_VALOR, E2_BAIXA, LEFT(E2.E2_EMISSAO,6) REFE, E2.R_E_C_N_O_ REGIS, E2.D_E_L_E_T_ DELETADO "
	cQuery +=" FROM " + RetSqlName("SE2") + " E2, " + RetSqlName("SA2") + " A2 "
	cQuery +=" WHERE E2_FILIAL = '" + xFilial("SE2") + "' "
	cQuery +=" AND A2_FILIAL = '" + xFilial("SA2") + "' "
	cQuery +=" AND E2_FORNECE = A2_COD "
	cQuery +=" AND E2_LOJA = A2_LOJA "
	cQuery +=" AND E2_ORIGEM = 'FINA050' "
	If Empty(MV_PAR06)
		cQuery +=" AND E2_TIPO = 'NF' "
	Else
		cQuery +=" AND E2_TIPO = '" + AllTrim(MV_PAR06) + "' "
	Endif
	cQuery +=" AND E2_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery +=" AND E2.D_E_L_E_T_ = '' "
	cQuery +=" AND A2.D_E_L_E_T_ = '' "
Endif
If MV_PAR07==3	// Imprime Registros Deletados
	cQuery +=" UNION ALL "
Endif
If MV_PAR07 == 1 .Or. MV_PAR07 == 3
	cQuery +=" SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, A2_NREDUZ, E2_EMISSAO, E2_VENCTO, E2_VENCREA, E2_VALOR, E2_BAIXA, LEFT(E2.E2_EMISSAO,6) REFE, E2.R_E_C_N_O_ REGIS, E2.D_E_L_E_T_ DELETADO "
	cQuery +=" FROM " + RetSqlName("SE2") + " E2, " + RetSqlName("SA2") + " A2 "
	cQuery +=" WHERE E2_FILIAL = '" + xFilial("SE2") + "' "
	cQuery +=" AND A2_FILIAL = '" + xFilial("SA2") + "' "
	cQuery +=" AND E2_FORNECE = A2_COD "
	cQuery +=" AND E2_LOJA = A2_LOJA "
	cQuery +=" AND E2_ORIGEM = 'FINA050' "
	If Empty(MV_PAR06)
		cQuery +=" AND E2_TIPO = 'NF' "
	Else
		cQuery +=" AND E2_TIPO = '" + AllTrim(MV_PAR06) + "' "
	Endif
	cQuery +=" AND E2_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery +=" AND E2.D_E_L_E_T_ = '*' "
	cQuery +=" AND A2.D_E_L_E_T_ = '' "
Endif
If MV_PAR05 == 1
	cQuery +=" ORDER BY E2_FORNECE, E2_LOJA, E2_EMISSAO "
ElseIf MV_PAR05 == 2
	cQuery +=" ORDER BY LEFT(E2.E2_EMISSAO,6), E2.E2_EMISSAO "
Endif

cQuery := ChangeQuery(cQuery) 	// otimiza a query de acordo c/ o banco 	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CHKV",.T.,.T.)

TcSetField('CHKV','E2_EMISSAO','D')
TcSetField('CHKV','E2_VENCTO','D')
TcSetField('CHKV','E2_VENCREA','D')

aVendas	:= {}

If MV_PAR07 == 1 .Or. MV_PAR07 == 3 // Deletados
	SET DELETED OFF
Endif

dbSelectArea("CHKV")
Count To nReg
dbGoTop()
ProcRegua(nReg)
While CHKV->(!Eof())
	IncProc("Aguarde Processando os Dados")
	
	SE2->(dbGoTo(CHKV->REGIS))
	
	If Empty(CHKV->DELETADO)
		cUserI := FWLeUserlg("E2_USERLGI")
		cDataI := FWLeUserlg("E2_USERLGI", 2)
	Else
		cUserI := FWLeUserlg("E2_USERLGA")
		cDataI := FWLeUserlg("E2_USERLGA", 2)
	Endif		
	If !Empty(cUserI) .And. !(AllTrim(cUserI)>=AllTrim(MV_PAR03) .And. AllTrim(cUserI) <= AllTrim(MV_PAR04))
		CHKV->(dbSkip(1));Loop
	Endif
	
	AAdd(aVendas,{SE2->E2_PREFIXO,;
					SE2->E2_NUM,;
					SE2->E2_PARCELA,;
					SE2->E2_TIPO,;
					SE2->E2_FORNECE+'/'+SE2->E2_LOJA,;
					CHKV->A2_NREDUZ,;
					SE2->E2_EMISSAO,;
					SE2->E2_VENCREA,;
					SE2->E2_BAIXA,;
					SE2->E2_VALOR,;
					cUserI,;
					cDataI,;
					Right(CHKV->REFE,2)+'/'+Left(CHKV->REFE,4),;
					CHKV->DELETADO})

	CHKV->(dbSkip(1))
Enddo
CHKV->(dbCloseArea())

SET DELETED ON

oReport:SetMeter(Len(aVendas))
For nVenda := 1 To Len(aVendas)
	oReport:IncMeter() 

	If oReport:Cancel() 
		Exit 
	EndIf 
			   
	oSection1:Init()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicio da impressao do cabecalho das NFs                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         	
   		
	oSection1:Cell("_cPrefixo"):SetValue(aVendas[nVenda,1])	
	oSection1:Cell("_cNumero"):SetValue(aVendas[nVenda,2])	
	oSection1:Cell("_cParcela"):SetValue(aVendas[nVenda,3])	
	oSection1:Cell("_cTipo"):SetValue(aVendas[nVenda,4])	
	oSection1:Cell("_cFornece"):SetValue(aVendas[nVenda,5])	
	oSection1:Cell("_cNome"):SetValue(aVendas[nVenda,6])	
	oSection1:Cell("_dEmissao"):SetValue(aVendas[nVenda,7])	
	oSection1:Cell("_dVencto"):SetValue(aVendas[nVenda,8])	
	oSection1:Cell("_dBaixa"):SetValue(aVendas[nVenda,9])	
	oSection1:Cell("_nValor"):SetValue(aVendas[nVenda,10])	
	oSection1:Cell("_cUsuInc"):SetValue(aVendas[nVenda,11])	
	oSection1:Cell("_dUsuInc"):SetValue(aVendas[nVenda,12])	
	oSection1:Cell("_cRefe"):SetValue(aVendas[nVenda,13])	
	oSection1:Cell("_cDelete"):SetValue(aVendas[nVenda,14])	

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
PutSx1(cPerg,'03','Usuario de     ?','','','mv_ch3','C',15, 0, 0,'G','','US3','','','mv_par03'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'04','Usuario Ate    ?','','','mv_ch4','C',15, 0, 0,'G','','US3','','','mv_par04'			 ,   ''              ,'','','',''       ,'','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'05','Ordem          ?','','','mv_ch5','N', 1, 0, 1,'C','',''   ,'','','mv_par05'           ,   'Por Fornecedor','','','','Mes/Ano','','','','','','','','','','','',aHelpPor07,aHelpPor07,aHelpPor07)
PutSx1(cPerg,'06','Tipo Titulo    ?','','','mv_ch6','C', 3, 0, 1,'G','','05' ,'','','mv_par06'           ,   ''              ,'','','',''       ,'','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'07','Imprime Deletados ?','','','mv_ch7','N', 1, 0, 1,'C','',''   ,'','','mv_par07'           ,   'Sim','','','','Nao','','','Ambos','','','','','','','','',aHelpPor07,aHelpPor07,aHelpPor07)

Return NIL
