#Include "Protheus.Ch"
#Include "RwMake.Ch"
#Include "TopConn.Ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} HCIMR003
Rotina para impressão do relatório de Aprovações.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/09/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
User Function HCIMR003()

	Local oReport	:= Nil
	Local _cPerg	:= "HCIR003" 
	Local _aParBox	:= {}
	Private aRet	:= {}
	Private _nOpc	:= 0
	Private _aDados	:= {}
	
	aadd(_aParBox,{1,"Data De? "    	,FirstDate( dDataBase ) 				,"@D"						,".T.","",".T.",50,.T.})       
	aAdd(_aParBox,{1,"Data Ate? "		,LastDate( dDataBase )					,"@D"						,"MV_PAR02 >= MV_PAR01","",".T.",50,.T.})
	aadd(_aParBox,{1,"Aprovador De" 	,Space(TamSX3("CR_APROV")[1]) 	,PesqPict("SCR","CR_APROV")	,".T.","SAK",".T.",40,.F.})       
	aadd(_aParBox,{1,"Aprovador Ate" 	,Space(TamSX3("CR_APROV")[1]) 	,PesqPict("SCR","CR_APROV")	,".T.","SAK",".T.",40,.F.})       
	
	If ParamBox(_aParBox,"Relatorio de Aprovações",,,,,,,,,.T.,.T.) //ParamBox(_aParBox,"Relatorio de Aprovações",@aRet)
		Processa({|lEnd| fCreatTMP(@lEnd,_aDados) }, OEMTOANSI("Analise de Aprovações"), "Processando dados, Aguarde...", .T. )		
		oReport := ReportDef(_cPerg,_aDados)
	EndIf
	
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} ReportDef
Função para configuração do TReport - Impressão do relatório.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/09/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function ReportDef(_cPerg,_aDados)

	Local oReport		:= Nil
//	Local oSectionI		:= Nil  
	Local oTotal		:= Nil
	Local cDesc			:= "Este relatorio ira imprimir a analise de aprovação de pedido de compras."
	Local nTam 			:= Len(_aDados)
	
	oReport:= TReport():New("HCIMR003","Relatorio de Aprovações",,{|oReport| PrintReport(oReport, _aDados, nTam)},OEMTOANSI(cDesc))
	oReport:SetLandscape()			// Formato paisagem
	oReport:oPage:nPaperSize:= 9 	// Impressão em papel A4
	oReport:lFooterVisible 	:= .F.	// Não imprime rodapé do protheus
	oReport:lParamPage		:= .F.	// Não imprime pagina de parametros
	
	oSectionI := TRSection():New(oReport,"APV",)
	
	TRCell():New(oSectionI	,"01"	,"FILIAL"	,"Filial"				,,20,.F.,{||_aDados[nConts][01]},,.T.,,,,.T.)
	TRCell():New(oSectionI	,"02"	,"EMISSAO"	,"Dt. Emissao"			,,15,.F.,{||_aDados[nConts][02]},,.T.,,,,.T.)
	TRCell():New(oSectionI	,"03"	,"APROV"	,"Aprovador"			,,35,.F.,{||_aDados[nConts][03]},,.T.,,,,.T.)
	TRCell():New(oSectionI	,"04"	,"VLRAPV"	,"Vlr. Aprovado"		,,25,.F.,{||_aDados[nConts][04]},,.T.,,,,.T.)
	TRCell():New(oSectionI	,"05"	,"VLRPDT"	,"Vlr. Pendente"		,,25,.F.,{||_aDados[nConts][05]},,.T.,,,,.T.)
	TRCell():New(oSectionI	,"06"	,"VLRPTOT"	,"Vlr. Pendente Tot"	,,25,.F.,{||_aDados[nConts][06]},,.T.,,,,.T.)
	TRCell():New(oSectionI	,"07"	,"TPPRD"	,"Tipo Produto"			,,15,.F.,{||_aDados[nConts][07]},,.T.,,,,.T.)
/*	
	oBreak := TRBreak():New(oSectionI,oSectionI:Cell("EMISSAO"),"Total do dia")

	TRFunction():New(oSectionI:Cell("VLRAPV"),NIL,"SUM",oBreak)
	TRFunction():New(oSectionI:Cell("VLRPDT"),NIL,"SUM",oBreak)
	TRFunction():New(oSectionI:Cell("VLRPTOT"),NIL,"SUM",oBreak)
*/
	
	oReport:PrintDialog()
	
Return(oReport)

//-------------------------------------------------------------------
/*/{Protheus.doc} PrintReport
Função para realizar a impressão dos valores de aprovação.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/09/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function PrintReport(oReport, _aDados, nTam)

	oReport:SetMeter(nTam) 
	
	oSectionI:Init()
	
	For nConts := 1 to nTam
		
		oReport:IncMeter()
	
		If oReport:Cancel()
			Exit
		EndIf
		
		oSectionI:PrintLine() 
	End
	
	oSectionI:Finish()

return

//-------------------------------------------------------------------
/*/{Protheus.doc} fCreatTMP
Função para gravação do array para impressão do relatório.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/09/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function fCreatTMP(lEnd,_aDados)

	Local _cQuery	:= ""
	Local cAliasPrc	:= GetNextAlias()
	Local _dData	:= CtoD("//")
	Local _nVlrApv	:= 0
	Local _nVlrPdt	:= 0
	Local _nVlrTPdt	:= 0
	
   	_cQuery	:= " SELECT	CR_FILIAL, "
   	_cQuery += " 		CR_EMISSAO, "
	_cQuery += " 		CR_APROV, "
	_cQuery += " 		AK_NOME, "
	_cQuery	+= " 		CASE 	WHEN SB1.B1_GRUPO = 'SERV' THEN 'Servico' "
	_cQuery	+= " 				WHEN SB1.B1_XTPMAT = 'P' THEN 'Produtivo' "
	_cQuery	+= " 				WHEN SB1.B1_XTPMAT = 'P' THEN 'Improdutivo' "
	_cQuery	+= " 				ELSE 'Indefinido' END AS TIPOPRD "
   	_cQuery += " FROM " + RetSqlName("SCR") + " SCR "

	_cQuery += " LEFT JOIN " + RetSqlName("SAK") + " SAK "
	_cQuery += " ON AK_FILIAL = '" + xFilial("SAK") + "'"
	_cQuery += " AND AK_COD = CR_APROV "
	_cQuery += " AND SAK.D_E_L_E_T_ = ' ' "
	
	_cQuery += " INNER JOIN  " + RetSqlName("SC7") + " SC7 "
	_cQuery += " ON C7_FILIAL = '" + xFilial("SC7") + "' "
	_cQuery += " AND C7_NUM = CR_NUM "
	_cQuery += " AND SC7.D_E_L_E_T_  = ' ' "

	_cQuery += " INNER JOIN  " + RetSqlName("SB1") + " SB1 "
	_cQuery += " ON B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += " AND B1_COD = C7_PRODUTO "
	_cQuery += " AND SB1.D_E_L_E_T_  = ' ' "
 	   	
   	_cQuery += " WHERE  CR_FILIAL = '" + xFilial("SCR") + "' "
   	If !Empty(MV_PAR01) .And. !Empty(MV_PAR02)
		_cQuery += " AND CR_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	EndIf
	_cQuery	+= " AND CR_APROV BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	_cQuery += " AND CR_TIPO = 'PC' "
	_cQuery += " AND SCR.D_E_L_E_T_ = ' ' "
	_cQuery += " GROUP BY CR_FILIAL, CR_EMISSAO, CR_APROV,AK_NOME,B1_XTPMAT, B1_GRUPO "
	_cQuery += " ORDER BY CR_EMISSAO,CR_APROV"

	TcQuery	_cQuery	New Alias &(cAliasPrc)
	PROCREGUA((cAliasPrc)->(RECCOUNT()))
	TCSetField((cAliasPrc),"CR_EMISSAO"		,"D",,)
	INCPROC("Processando analise de aprovacoes")
	If (cAliasPrc)->(!EOF())
		_dData	:= (cAliasPrc)->CR_EMISSAO
		While (cAliasPrc)->(!EOF())
			INCPROC("Data: " + SubStr(DTOS((cAliasPrc)->CR_EMISSAO),7,2) + "/" + SubStr(DTOS((cAliasPrc)->CR_EMISSAO),5,2) + "/" + SubStr(DTOS((cAliasPrc)->CR_EMISSAO),1,4))
			If (cAliasPrc)->CR_EMISSAO <> _dData
				Aadd(_aDados,{;
						""	,;
						""		,;
						""	,;
						"",;
						""	,;
						""	,;
						"" })
				Aadd(_aDados,{;
						""	,;
						"Total do dia"		,;
						""	,;
						_nVlrApv	,;
						_nVlrPdt	,;
						"",;
						""})
				Aadd(_aDados,{;
						""	,;
						""		,;
						""	,;
						"",;
						""	,;
						""	,;
						"" })
				_nVlrApv	:= 0
				_nVlrPdt	:= 0
			EndIf
	   		Aadd(_aDados,{;
						(cAliasPrc)->CR_FILIAL	,;
						(cAliasPrc)->CR_EMISSAO	,;
						(cAliasPrc)->CR_APROV + "/" + (cAliasPrc)->AK_NOME		,;
						_fGetVApv((cAliasPrc)->CR_EMISSAO,(cAliasPrc)->TIPOPRD,(cAliasPrc)->CR_APROV)	,;
						_fGetVPdt((cAliasPrc)->CR_EMISSAO,(cAliasPrc)->TIPOPRD,(cAliasPrc)->CR_APROV)	,;
						_fGetTPdt((cAliasPrc)->CR_EMISSAO,(cAliasPrc)->TIPOPRD,(cAliasPrc)->CR_APROV)	,;
						(cAliasPrc)->TIPOPRD})
						
			_nVlrApv+=_aDados[Len(_aDados),4]
			_nVlrPdt+=_aDados[Len(_aDados),5]
			_dData	:= (cAliasPrc)->CR_EMISSAO
			(cAliasPrc)->(dbSkip())
		EndDo
		Aadd(_aDados,{;
						""	,;
						""		,;
						""	,;
						"",;
						""	,;
						""	,;
			   			"" })
		Aadd(_aDados,{;
						""	,;
						"Total do dia"		,;
						""	,;
						_nVlrApv	,;
						_nVlrPdt	,;
						"",;
						""})
		Aadd(_aDados,{;
						""	,;
						""		,;
						""	,;
						"",;
						""	,;
						""	,;
						"" })
	EndIf

	(cAliasPrc)->(dbCloseArea())
	
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fGetVApv
Função para retorno do valor de aprovação referente a data.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/09/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fGetVApv(_dDtEmissao,_cTipoPrd,_cAprov)

	Local _cQuery 		:= ""
	Local _cAliasTAPV	:= GetNextAlias()
	Local _nVlrApv		:= 0
	
	_cQuery	:= "SELECT SUM(SC71.C7_TOTAL+SC71.C7_VALIPI+SC71.C7_DESPESA+SC71.C7_FRETE+SC71.C7_ICMSRET) AS VLRTOT "
	_cQuery	+= " FROM " + RetSqlName("SC7") + " SC71 "
	
	_cQuery += " INNER JOIN  " + RetSqlName("SB1") + " SB1 "
	_cQuery += " ON B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += " AND B1_COD = C7_PRODUTO "
	Do Case
		Case Upper(Alltrim(_cTipoPrd)) == "PRODUTIVO"
			_cQuery += " AND B1_XTPMAT = 'P' AND B1_GRUPO <> 'SERV' "
		Case Upper(Alltrim(_cTipoPrd)) == "IMPRODUTIVO"
			_cQuery += " AND B1_XTPMAT = 'I' AND B1_GRUPO <> 'SERV' "
		Case Upper(Alltrim(_cTipoPrd)) == "SERVICO"
			_cQuery += " AND B1_GRUPO = 'SERV' "
		OTHERWISE
			_cQuery += " AND B1_GRUPO <> 'SERV' AND B1_XTPMAT NOT IN ('P','I')"

	End Case
	_cQuery += " AND SB1.D_E_L_E_T_  = ' ' "
	
	_cQuery	+= " WHERE SC71.C7_FILIAL = '" + xFilial("SC7") + "'"
	_cQuery	+= " AND SC71.C7_NUM IN (	SELECT SCR1.CR_NUM "
	_cQuery	+= " 						FROM " + RetSqlName("SCR") + " SCR1 "
	_cQuery	+= " 						WHERE SCR1.CR_FILIAL = '" + xFilial("SCR") + "' "
	_cQuery	+= " 						AND SCR1.CR_EMISSAO = '" + DTOS(_dDtEmissao) + "'"
	_cQuery	+= " 						AND SCR1.CR_STATUS IN ('03','05')   "
	_cQuery	+= " 						AND SCR1.CR_APROV = '" + _cAprov + "' "
	_cQuery	+= " 						AND SCR1.CR_TIPO = 'PC' "
	_cQuery	+= " 						AND SCR1.D_E_L_E_T_ = ' ') "
	_cQuery	+= " AND SC71.D_E_L_E_T_ = ' ' "
	
	TcQuery	_cQuery	New Alias &(_cAliasTAPV)	
	
	If (_cAliasTAPV)->(!EOF())
		_nVlrApv	:= (_cAliasTAPV)->VLRTOT
	EndIf
	
	(_cAliasTAPV)->(dbCloseArea())

Return(_nVlrApv)


//-------------------------------------------------------------------
/*/{Protheus.doc} _fGetVPdt
Função para retorno do valor de pendente referente a data.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/09/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fGetVPdt(_dDtEmissao,_cTipoPrd,_cAprov)

	Local _cQuery 		:= ""
	Local _cAliasTPDT	:= GetNextAlias()
	Local _nVlrPdt		:= 0
	
	_cQuery	:= "SELECT SUM(SC72.C7_TOTAL+SC72.C7_VALIPI+SC72.C7_DESPESA+SC72.C7_FRETE+SC72.C7_ICMSRET) AS VLRTOT "
	_cQuery	+= " FROM " + RetSqlName("SC7") + " SC72 "
	
	_cQuery += " INNER JOIN  " + RetSqlName("SB1") + " SB1 "
	_cQuery += " ON B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += " AND B1_COD = C7_PRODUTO "
	Do Case
		Case Upper(Alltrim(_cTipoPrd)) == "PRODUTIVO"
			_cQuery += " AND B1_XTPMAT = 'P' AND B1_GRUPO <> 'SERV' "
		Case Upper(Alltrim(_cTipoPrd)) == "IMPRODUTIVO"
			_cQuery += " AND B1_XTPMAT = 'I' AND B1_GRUPO <> 'SERV' "
		Case Upper(Alltrim(_cTipoPrd)) == "SERVICO"
			_cQuery += " AND B1_GRUPO = 'SERV' "
		OTHERWISE
			_cQuery += " AND B1_GRUPO <> 'SERV' AND B1_XTPMAT NOT IN ('P','I')"

	End Case
	_cQuery += " AND SB1.D_E_L_E_T_  = ' ' "
	
	_cQuery	+= " WHERE SC72.C7_FILIAL = '" + xFilial("SC7") + "'"
	_cQuery	+= " AND SC72.C7_NUM IN (	SELECT SCR2.CR_NUM "
	_cQuery	+= " 						FROM " + RetSqlName("SCR") + " SCR2 "
	_cQuery	+= " 						WHERE SCR2.CR_FILIAL = '" + xFilial("SCR") + "' "
	_cQuery	+= " 						AND SCR2.CR_EMISSAO = '" + DTOS(_dDtEmissao) + "'"
	_cQuery	+= " 						AND SCR2.CR_STATUS = '02' "  
	_cQuery	+= " 						AND SCR2.CR_APROV = '" + _cAprov + "' "
	_cQuery	+= " 						AND SCR2.CR_TIPO = 'PC' "
	_cQuery	+= " 						AND SCR2.D_E_L_E_T_ = ' ') "
	_cQuery	+= " AND SC72.D_E_L_E_T_ = ' ' "
	
	TcQuery	_cQuery	New Alias &(_cAliasTPDT)	
	
	If (_cAliasTPDT)->(!EOF())
		_nVlrPdt	:= (_cAliasTPDT)->VLRTOT
	EndIf
	
	(_cAliasTPDT)->(dbCloseArea())

Return(_nVlrPdt)

//-------------------------------------------------------------------
/*/{Protheus.doc} _fGetTPdt
Função para retorno do valor total de pendente referente a data.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/09/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fGetTPdt(_dDtEmissao,_cTipoPrd,_cAprov)

	Local _cQuery 		:= ""
	Local _cAliasPDT	:= GetNextAlias()
	Local _nVlrTPdt		:= 0
	Local _cDtCorte	:= SuperGetMv("ES_HMR3DTC",,"20140101")
	
	_cQuery	:= "SELECT SUM(SC73.C7_TOTAL+SC73.C7_VALIPI+SC73.C7_DESPESA+SC73.C7_FRETE+SC73.C7_ICMSRET) AS VLRTOT "
	_cQuery	+= " FROM " + RetSqlName("SC7") + " SC73 "
	
	_cQuery += " INNER JOIN  " + RetSqlName("SB1") + " SB1 "
	_cQuery += " ON B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += " AND B1_COD = C7_PRODUTO "
	Do Case
		Case Upper(Alltrim(_cTipoPrd)) == "PRODUTIVO"
			_cQuery += " AND B1_XTPMAT = 'P' AND B1_GRUPO <> 'SERV' "
		Case Upper(Alltrim(_cTipoPrd)) == "IMPRODUTIVO"
			_cQuery += " AND B1_XTPMAT = 'I' AND B1_GRUPO <> 'SERV' "
		Case Upper(Alltrim(_cTipoPrd)) == "SERVICO"
			_cQuery += " AND B1_GRUPO = 'SERV' "
		OTHERWISE
			_cQuery += " AND B1_GRUPO <> 'SERV' AND B1_XTPMAT NOT IN ('P','I')"
	End Case
	_cQuery += " AND SB1.D_E_L_E_T_  = ' ' "
	
	_cQuery	+= " WHERE SC73.C7_FILIAL = '" + xFilial("SC7") + "'"
	_cQuery	+= " AND SC73.C7_NUM IN (	SELECT SCR3.CR_NUM "
	_cQuery	+= " 						FROM " + RetSqlName("SCR") + " SCR3 "
	_cQuery	+= " 						WHERE SCR3.CR_FILIAL = '" + xFilial("SCR") + "' "
	_cQuery	+= " 						AND SCR3.CR_EMISSAO BETWEEN '" + _cDtCorte + "' AND '" + DTOS(_dDtEmissao) + "'"
	_cQuery	+= " 						AND SCR3.CR_STATUS = '02'  "
	_cQuery	+= " 						AND SCR3.CR_APROV = '" + _cAprov + "' "
	_cQuery	+= " 						AND SCR3.CR_TIPO = 'PC' "
	_cQuery	+= " 						AND SCR3.D_E_L_E_T_ = ' ') "
	_cQuery	+= " AND SC73.D_E_L_E_T_ = ' ' "
	
	TcQuery	_cQuery	New Alias &(_cAliasPDT)	
	
	If (_cAliasPDT)->(!EOF())
		_nVlrTPdt	:= (_cAliasPDT)->VLRTOT
	EndIf
	
	(_cAliasPDT)->(dbCloseArea())

Return(_nVlrTPdt)