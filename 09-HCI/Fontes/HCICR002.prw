#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณDESCR002   บAutor  ณBruna Zechetti    บ Data ณ  09/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para impressใo do relat๓rio de saํdas.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HCICR002()

	Local _oReport	:= Nil
//	Local lTReport	:= IiF(FindFunction("TRepInUse") 	,TRepInUse()	,.F.)
//	Local lDefTop 	:= IiF(FindFunction("IfDefTopCTB")	,IfDefTopCTB()	,.F.)
	Local cPerg		:= "HCICR002" 
	Local aFiliais	:= {}
	Local lContinua	:= .T.
	
	CreateSx1(cPerg)
//	If lTReport .and. lDefTop  
		If Pergunte(cPerg,.T.)
			
			If MV_PAR09 == 1							//Seleciona Filiais
				aFiliais	:=	AdmGetFil()
				lContinua	:= Len(aFiliais) > 0
			Else
				aFiliais 	:= {cFilAnt}
			EndIf 	
			
			If lContinua 
				_oReport := ReportDef(cPerg,aFiliais)
				_oReport:PrintDialog()
			EndIf		
		EndIf
//	EndIf
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณReportDef บAutor  ณBruna Zechetti     บ Data ณ  09/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para montagem das colunas do relat๓rio.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef(	cPerg,;			//Grupo de Perguntas
							aFiliais)		//Filiais Selecionadas


	Local _oReport		:= Nil
	Local _oSecI		:= Nil  
	Local _oTotal		:= Nil
	Local _cDesc		:= "Analise de Custo de Saida" 
	Local _cAliasQry	:= GetNextAlias()
	
	_oReport:= TReport():New(cPerg,_cDesc,cPerg,{|| ProcessRpt(_oReport,cPerg,aFiliais,_cAliasQry)},_cDesc)
	_oReport:ParamReadOnly() 
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ                   							_oSecI	  		                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_oSecI := TRSection():New(_oReport,"DADOS PRODUTO",{"SD2","SF4","SB1","NAOUSADO"})
	
	TRCell():New(_oSecI	,"D2_FILIAL"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_EMISSAO"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_DOC"  		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_SERIE"		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_NFORI"		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_SERIORI"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_CLIENTE"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_LOJA"		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_TIPO" 		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_COD" 		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"B1_DESC" 		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"B1_TIPO" 		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"B1_GRUPO"		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_LOCAL"		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_QUANT"		,_cAliasQry,			,,,,,,.T.,,,,.T.) 
	TRCell():New(_oSecI	,"D2_PRCVEN"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_TOTAL"		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_TES"		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_CF"		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"F4_TEXTO"		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"F4_ESTOQUE"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"F4_DUPLIC"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"F4_UPRC" 		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_VALFRE"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_SEGURO"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_DESCON"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_DESPESA"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_CUSTO1"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_BASEICM"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_BRICMS"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_ICMSRET"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_VALICM"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_BASEIPI"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_IPI"  		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_PICM" 		,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_VALIPI"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_BASIMP5"	,_cAliasQry,"Base COFINS"			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_BASIMP6"	,_cAliasQry,"Base PIS"			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_ALQIMP5"	,_cAliasQry,"Aliq. COFINS"			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_ALQIMP6"	,_cAliasQry,"Aliq. PIS"			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_VALIMP5"	,_cAliasQry,"Vlr. COFINS"			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_VALIMP6"	,_cAliasQry,"Vlr. PIS"			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_NUMSEQ"	,_cAliasQry,			,,,,,,.T.,,,,.T.)
	TRCell():New(_oSecI	,"D2_SEQCALC"	,_cAliasQry,			,,,,,,.T.,,,,.T.)

Return(_oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณProcessRpt บAutor  ณBruna Zechetti    บ Data ณ  09/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para montagem da query das notas fiscais de saํda.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcessRpt(_oReport,cPerg,aFiliais,_cAliasQry)

	Local cCondFilD2 	:= "" 
	Local cCondFilF4 	:= "" 
	Local cCondFilB1 	:= ""  
	Local _oSecI		:= _oReport:Section(1)
	
	
	cCondFilD2 	:= " SD2.D2_FILIAL " + GetRngFil( aFiliais , "SD2" )
	cCondFilD2 	:= "%" + cCondFilD2 + "%"
	cCondFilF4 	:= " AND SF4.F4_FILIAL " + GetRngFil( aFiliais , "SF4" )
	cCondFilF4 	:= "%" + cCondFilF4 + "%"
	cCondFilB1 	:= " AND SB1.B1_FILIAL " + GetRngFil( aFiliais , "SB1" )
	cCondFilB1 	:= "%" + cCondFilB1 + "%"
	
	_oSecI:BeginQuery()
	BeginSql alias _cAliasQry
	SELECT SD2.D2_FILIAL
		,SD2.D2_EMISSAO
		,SD2.D2_DOC
		,SD2.D2_SERIE
		,SD2.D2_NFORI
		,SD2.D2_SERIORI
		,SD2.D2_CLIENTE
		,SD2.D2_LOJA
		,SD2.D2_TIPO
		,SD2.D2_COD
		,SB1.B1_DESC
		,SB1.B1_TIPO
		,SB1.B1_GRUPO
		,SD2.D2_LOCAL
		,SD2.D2_QUANT
		,SD2.D2_PRCVEN
		,SD2.D2_TOTAL
		,SD2.D2_TES
		,SD2.D2_CF
		,SF4.F4_TEXTO
		,SF4.F4_ESTOQUE
		,SF4.F4_DUPLIC
		,SF4.F4_UPRC
		,SB1.B1_CUSTD
		,SB1.B1_UPRC
		,SB1.B1_UCALSTD 
		,SD2.D2_CUSTO1
		,SD2.D2_BASEICM
		,SD2.D2_BRICMS
		,SD2.D2_ICMSRET
		,SD2.D2_VALICM
		,SD2.D2_BASEIPI
		,SD2.D2_IPI
		,SD2.D2_PICM
		,SD2.D2_VALIPI
		,SD2.D2_BASIMP5
		,SD2.D2_BASIMP6
		,SD2.D2_ALQIMP5
		,SD2.D2_ALQIMP6
		,SD2.D2_VALIMP5
		,SD2.D2_VALIMP6
		,SD2.D2_NUMSEQ
		,SD2.D2_SEQCALC
		,SD2.D2_VALFRE
		,SD2.D2_SEGURO
		,SD2.D2_DESCON
		,SD2.D2_DESPESA
		FROM %table:SD2% SD2 
		INNER JOIN %table:SF4% SF4
		ON SD2.D2_TES 		= SF4.F4_CODIGO 
		%exp:cCondFilF4%
		INNER JOIN %table:SB1% SB1
		ON SD2.D2_COD 		= SB1.B1_COD
		%exp:cCondFilB1%
		WHERE %exp:cCondFilD2%
		AND D2_DOC BETWEEN 		%exp:MV_PAR01%	AND %exp:MV_PAR02% 
		AND D2_SERIE BETWEEN 	%exp:MV_PAR03%	AND %exp:MV_PAR04%
		AND D2_EMISSAO BETWEEN 	%exp:MV_PAR05%	AND %exp:MV_PAR06%             
		AND D2_COD BETWEEN 		%exp:MV_PAR07%	AND %exp:MV_PAR08%
		AND SD2.%NotDel%                                      
		AND SF4.%NotDel%
		AND SB1.%NotDel%
		ORDER BY D2_EMISSAO 	
	EndSql	
	_oSecI:EndQuery()
	_oSecI:Print()

Return(.T.)
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณCreateSx1  บAutor  ณBruna Zechetti    บ Data ณ  09/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para gera็ใo dos parโmetros do relat๓rio.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CreateSx1(cPerg)

	Local aHelpPor 	:= {""}
	Local aHelpEng 	:= {""}
	Local aHelpSpa 	:= {""}
	Local aArea	 	:= GetArea()
	//------------------------------ MV_PAR01 ------------------------------
	aHelpPor := {"Numero de Documento Inicial para filtro"}
	aHelpSpa := {"Numero de Documento Inicial para filtro"}
	aHelpEng := {"Numero de Documento Inicial para filtro"}
	PutSx1(cPerg,"01","Documento De?"									,"Documento De?"				,"Documento De?"			,"MV_CH1","C",TamSx3("D2_DOC")[1]			,0,0,"G","",""	,"","S","MV_PAR01","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
	//------------------------------ MV_PAR02 ------------------------------
	aHelpPor := {"Numero de Documento Final para filtro"}
	aHelpSpa := {"Numero de Documento Final para filtro"}
	aHelpEng := {"Numero de Documento Final para filtro"}
	PutSx1(cPerg,"02","Documento Ate?"									,"Documento Ate?"				,"Documento Ate?"			,"MV_CH2","C",TamSx3("D2_DOC")[1]			,0,0,"G","",""	,"","S","MV_PAR02","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
	
	//------------------------------ MV_PAR01 ------------------------------
	aHelpPor := {"Serie de Documento Inicial para filtro"}
	aHelpSpa := {"Serie de Documento Inicial para filtro"}
	aHelpEng := {"Serie de Documento Inicial para filtro"}
	PutSx1(cPerg,"03","Serie De?"								   		,"Serie De?"			   		,"Serie De?"			,"MV_CH3","C",TamSx3("D2_SERIE")[1]			,0,0,"G","",""	,"","S","MV_PAR03","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
	//------------------------------ MV_PAR02 ------------------------------
	aHelpPor := {"Serie de Documento Final para filtro"}
	aHelpSpa := {"Serie de Documento Final para filtro"}
	aHelpEng := {"Serie de Documento Final para filtro"}
	PutSx1(cPerg,"04","Serie Ate?"										,"Serie Ate?"			   		,"Serie Ate?"			,"MV_CH4","C",TamSx3("D2_SERIE")[1]			,0,0,"G","",""	,"","S","MV_PAR04","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
	//------------------------------ MV_PAR05 ------------------------------
	aHelpPor := {"Data Inicial de para emissใo"}
	aHelpSpa := {"Data Inicial de para emissใo"}
	aHelpEng := {"Data Inicial de para emissใo"}
	PutSx1(cPerg,"05","Dt. Emissใo De?"							,"Dt.Digitacao De?"			,"Dt.Digitacao De?"			,"MV_CH5","D",TamSx3("D2_EMISSAO")[1]		,0,0,"G","",""		,"","S","MV_PAR05","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
	//------------------------------ MV_PAR06 ------------------------------
	aHelpPor := {"Data Final de para emissใo"}
	aHelpSpa := {"Data Final de para emissใo"}
	aHelpEng := {"Data Final de para emissใo"}
	PutSx1(cPerg,"06","Dt. Emissใo Ate?"							,"Dt.Digitacao Ate?"		,"Dt.Digitacao Ate?"		,"MV_CH6","D",TamSx3("D2_EMISSAO")[1]		,0,0,"G","",""		,"","S","MV_PAR06","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
	//------------------------------ MV_PAR07 ------------------------------
	aHelpPor := {"Codigo de Produto Inicial para filtro"}
	aHelpSpa := {"Codigo de Produto Inicial para filtro"}
	aHelpEng := {"Codigo de Produto Inicial para filtro"}
	PutSx1(cPerg,"07","Produto de?"									,"Produto de?"				,"Produto de?"			,"MV_CH7","C",TamSx3("B1_COD")[1]			,0,0,"G","","SB1"	,"","S","MV_PAR07","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
	//------------------------------ MV_PAR08 ------------------------------
	aHelpPor := {"Codigo de Produto Final para filtro"}
	aHelpSpa := {"Codigo de Produto Final para filtro"}
	aHelpEng := {"Codigo de Produto Final para filtro"}
	PutSx1(cPerg,"08","Produto ate?"								,"Produto ate?"				,"Produto ate?"			,"MV_CH8","C",TamSx3("B1_COD")[1]			,0,0,"G","","SB1"	,"","S","MV_PAR08","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
	//------------------------------ MV_PAR09 ------------------------------
	aHelpPor := {"Indica se Apresentara tela para"	,"selecao de filiais"}
	aHelpSpa := {"Indica se Apresentara tela para"	,"selecao de filiais"}
	aHelpEng := {"Indica se Apresentara tela para"	,"selecao de filiais"}
	PutSx1(cPerg,"09","Seleciona Filiais?"							,"Seleciona Filiais?"		,"Seleciona Filiais?"	,"MV_CH9","N",1								,0,2,"C","",""		,"","S","MV_PAR09","Sim","Sim","Sim"	,"","Nao","Nao","Nao","",""	,""	,"","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
	
	RestArea(aArea)
	
Return (.T.)