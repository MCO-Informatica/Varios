#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
      
//--------------------------------------------------------------------
/*/{Protheus.doc} HCICR001
Relatorio Analise de Custo de Entrada     

@author TOTALIT SOLUTIONS
@since  31/08/2013
@obs    Rotina especifica HCI
@version 1.0
/*/
//--------------------------------------------------------------------
User Function HCICR001()
Local oReport	:= Nil
//Local lTReport	:= IiF(FindFunction("TRepInUse") 	,TRepInUse()	,.F.)
//Local lDefTop 	:= IiF(FindFunction("IfDefTopCTB")	,IfDefTopCTB()	,.F.)
Local cPerg		:= "HCICR001" 
Local aFiliais	:= {}
Local lContinua	:= .T.

CreateSx1(cPerg)
//If lTReport .and. lDefTop  
	If Pergunte(cPerg,.T.)
		
		If MV_PAR09 == 1							//Seleciona Filiais
			aFiliais	:=	AdmGetFil()
			lContinua	:= Len(aFiliais) > 0
		Else
			aFiliais 	:= {cFilAnt}
		EndIf 	
		
		If lContinua 
			oReport := ReportDef(cPerg,aFiliais)
			oReport:PrintDialog()
		EndIf		
	EndIf
//EndIf

Return Nil

//--------------------------------------------------------------------
/*/{Protheus.doc} ReportDef
Relatorio Analise de Custo de Entrada

@author TOTALIT SOLUTIONS
@since  31/08/2013
@obs    Rotina especifica HCI
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function ReportDef(	cPerg,;			//Grupo de Perguntas
							aFiliais)		//Filiais Selecionadas


Local oReport		:= Nil
Local oSectionI		:= Nil  
Local oTotal		:= Nil
Local cDesc			:= "Analise de Custo de Entrada" 
Local cAliasQry		:= GetNextAlias()

oReport:= TReport():New(cPerg,cDesc,cPerg,{|| ProcessRpt(oReport,cPerg,aFiliais,cAliasQry)},cDesc)
oReport:ParamReadOnly() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                   							oSectionI	  		                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectionI := TRSection():New(oReport,"DADOS PRODUTO",{"SD1","SF4","SB1","NAOUSADO"})

TRCell():New(oSectionI	,"D1_FILIAL"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_EMISSAO"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_DTDIGIT"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_DOC"  		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_SERIE"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_FORNECE"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_LOJA"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_TIPO" 		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_COD" 		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"B1_DESC" 		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_LOCAL"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_QUANT"		,cAliasQry,			,,,,,,.T.,,,,.T.) 
TRCell():New(oSectionI	,"D1_VUNIT"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_TOTAL"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_TES"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_CF"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"F4_TEXTO"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"F4_ESTOQUE"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"F4_DUPLIC"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"F4_UPRC" 		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"F4_CREDICM"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"F4_CREDIPI"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"B1_TIPO"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"B1_GRUPO"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"B1_CUSTD"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"B1_UPRC"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"B1_UCALSTD"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_VALFRE"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_SEGURO"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_VALDESC"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_DESPESA"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_CUSTO"		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_BASEICM"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_BRICMS"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_ICMSRET"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_VALICM"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_BASEIPI"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_IPI"  		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_PICM" 		,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_VALIPI"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_BASIMP5"	,cAliasQry,"Base COFINS"			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_BASIMP6"	,cAliasQry,"Base PIS"			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_ALQIMP5"	,cAliasQry,"Aliq. COFINS"			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_ALQIMP6"	,cAliasQry,"Aliq. PIS"			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_VALIMP5"	,cAliasQry,"Vlr. COFINS"			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_VALIMP6"	,cAliasQry,"Vlr. PIS"			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_VALCMAJ"	,cAliasQry,"Vlr. COF. MAJ."			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_NUMSEQ"	,cAliasQry,			,,,,,,.T.,,,,.T.)
TRCell():New(oSectionI	,"D1_SEQCALC"	,cAliasQry,			,,,,,,.T.,,,,.T.)

Return oReport
//--------------------------------------------------------------------
/*/{Protheus.doc} ProcessRpt
Relatorio Analise de Custo de Entrada

@author TOTALIT SOLUTIONS
@since  31/08/2013
@obs    Rotina especifica HCI
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function ProcessRpt(oReport,cPerg,aFiliais,cAliasQry)
Local cCondFilD1 	:= "" 
Local cCondFilF4 	:= "" 
Local cCondFilB1 	:= ""  
Local oSectionI		:= oReport:Section(1)


cCondFilD1 	:= " SD1.D1_FILIAL " + GetRngFil( aFiliais , "SD1" )
cCondFilD1 	:= "%" + cCondFilD1 + "%"
cCondFilF4 	:= " AND SF4.F4_FILIAL " + GetRngFil( aFiliais , "SF4" )
cCondFilF4 	:= "%" + cCondFilF4 + "%"
cCondFilB1 	:= " AND SB1.B1_FILIAL " + GetRngFil( aFiliais , "SB1" )
cCondFilB1 	:= "%" + cCondFilB1 + "%"

oSectionI:BeginQuery()
BeginSql alias cAliasQry
SELECT SD1.D1_FILIAL
	,SD1.D1_EMISSAO
	,SD1.D1_DTDIGIT
	,SD1.D1_DOC
	,SD1.D1_SERIE
	,SD1.D1_FORNECE
	,SD1.D1_LOJA
	,SD1.D1_TIPO
	,SD1.D1_COD
	,SB1.B1_DESC
	,SD1.D1_LOCAL
	,SD1.D1_QUANT
	,SD1.D1_VUNIT
	,SD1.D1_TOTAL
	,SD1.D1_TES
	,SD1.D1_CF
	,SF4.F4_TEXTO
	,SF4.F4_ESTOQUE
	,SF4.F4_DUPLIC
	,SF4.F4_UPRC
	,SF4.F4_CREDICM
	,SF4.F4_CREDIPI
	,SB1.B1_TIPO
	,SB1.B1_GRUPO
	,SB1.B1_CUSTD
	,SB1.B1_UPRC
	,SB1.B1_UCALSTD 
	,SD1.D1_CUSTO
	,SD1.D1_BASEICM
	,SD1.D1_BRICMS
	,SD1.D1_ICMSRET
	,SD1.D1_VALICM
	,SD1.D1_BASEIPI
	,SD1.D1_IPI
	,SD1.D1_PICM
	,SD1.D1_VALIPI
	,SD1.D1_BASIMP5
	,SD1.D1_BASIMP6
	,SD1.D1_ALQIMP5
	,SD1.D1_ALQIMP6
	,SD1.D1_VALIMP5
	,SD1.D1_VALIMP6
	,SD1.D1_NUMSEQ
	,SD1.D1_SEQCALC
	,SD1.D1_VALFRE
	,SD1.D1_SEGURO
	,SD1.D1_VALDESC
	,SD1.D1_DESPESA
	,SD1.D1_VALCMAJ
	FROM %table:SD1% SD1 
	INNER JOIN %table:SF4% SF4
	ON SD1.D1_TES 		= SF4.F4_CODIGO 
	%exp:cCondFilF4%
	INNER JOIN %table:SB1% SB1
	ON SD1.D1_COD 		= SB1.B1_COD
	%exp:cCondFilB1%
	WHERE %exp:cCondFilD1%
	AND D1_DOC BETWEEN 		%exp:MV_PAR01%	AND %exp:MV_PAR02% 
	AND D1_SERIE BETWEEN 	%exp:MV_PAR03%	AND %exp:MV_PAR04%
	AND D1_DTDIGIT BETWEEN 	%exp:MV_PAR05%	AND %exp:MV_PAR06%             
	AND D1_COD BETWEEN 		%exp:MV_PAR07%	AND %exp:MV_PAR08%
	AND SD1.%NotDel%                                      
	AND SF4.%NotDel%
	AND SB1.%NotDel%
	ORDER BY D1_DTDIGIT 	
EndSql	
oSectionI:EndQuery()
oSectionI:Print()

Return .T.	
	

//--------------------------------------------------------------------
/*/{Protheus.doc} CreateSx1
Relatorio de Kardex Sintetico 

@author TOTALIT SOLUTIONS
@since  31/08/2013
@obs    Rotina especifica HCI
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function CreateSx1(cPerg)
Local aHelpPor 	:= {""}
Local aHelpEng 	:= {""}
Local aHelpSpa 	:= {""}
Local aArea	 	:= GetArea()
//------------------------------ MV_PAR01 ------------------------------
aHelpPor := {"Numero de Documento Inicial para filtro"}
aHelpSpa := {"Numero de Documento Inicial para filtro"}
aHelpEng := {"Numero de Documento Inicial para filtro"}
PutSx1(cPerg,"01","Documento De?"									,"Documento De?"				,"Documento De?"			,"MV_CH1","C",TamSx3("D1_DOC")[1]			,0,0,"G","",""	,"","S","MV_PAR01","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
//------------------------------ MV_PAR02 ------------------------------
aHelpPor := {"Numero de Documento Final para filtro"}
aHelpSpa := {"Numero de Documento Final para filtro"}
aHelpEng := {"Numero de Documento Final para filtro"}
PutSx1(cPerg,"02","Documento Ate?"									,"Documento Ate?"				,"Documento Ate?"			,"MV_CH2","C",TamSx3("D1_DOC")[1]			,0,0,"G","",""	,"","S","MV_PAR02","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")

//------------------------------ MV_PAR01 ------------------------------
aHelpPor := {"Serie de Documento Inicial para filtro"}
aHelpSpa := {"Serie de Documento Inicial para filtro"}
aHelpEng := {"Serie de Documento Inicial para filtro"}
PutSx1(cPerg,"03","Serie De?"								   		,"Serie De?"			   		,"Serie De?"			,"MV_CH3","C",TamSx3("D1_SERIE")[1]			,0,0,"G","",""	,"","S","MV_PAR03","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
//------------------------------ MV_PAR02 ------------------------------
aHelpPor := {"Serie de Documento Final para filtro"}
aHelpSpa := {"Serie de Documento Final para filtro"}
aHelpEng := {"Serie de Documento Final para filtro"}
PutSx1(cPerg,"04","Serie Ate?"										,"Serie Ate?"			   		,"Serie Ate?"			,"MV_CH4","C",TamSx3("D1_SERIE")[1]			,0,0,"G","",""	,"","S","MV_PAR04","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
//------------------------------ MV_PAR05 ------------------------------
aHelpPor := {"Data Inicial de para digitação"}
aHelpSpa := {"Data Inicial de para digitação"}
aHelpEng := {"Data Inicial de para digitação"}
PutSx1(cPerg,"05","Dt.Digitacao De?"							,"Dt.Digitacao De?"			,"Dt.Digitacao De?"			,"MV_CH5","D",TamSx3("D1_DTDIGIT")[1]		,0,0,"G","",""		,"","S","MV_PAR05","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
//------------------------------ MV_PAR06 ------------------------------
aHelpPor := {"Data Final de para digitação"}
aHelpSpa := {"Data Final de para digitação"}
aHelpEng := {"Data Final de para digitação"}
PutSx1(cPerg,"06","Dt.Digitacao Ate?"							,"Dt.Digitacao Ate?"		,"Dt.Digitacao Ate?"		,"MV_CH6","D",TamSx3("D1_DTDIGIT")[1]		,0,0,"G","",""		,"","S","MV_PAR06","","",""	,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
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