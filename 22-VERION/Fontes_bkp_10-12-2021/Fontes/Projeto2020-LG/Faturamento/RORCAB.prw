/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RORCAB   บ Autor ณ ADINFO CONSULTORIA บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Imprime relat๓rio em formato Treport de or็amentos em      บฑฑ
ฑฑบ          ณ aberto.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verion                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

#include "protheus.ch"

User Function RORCAB()
Local oReport
cPerg := "RORCAB   " 
AjustaSx1()

If TRepInUse()
	Pergunte(cPerg,.F.)

	oReport := ReportDef()
	oReport:PrintDialog()	
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2

oReport := TReport():New("RORCAB","Relat๓rio de Or็amentos em Aberto","RORCAB   ",{|oReport| PrintReport(oReport)},"Relatorio de Or็amentos em abertos")

oSection1 := TRSection():New(oReport,"Itens","SUB")

//TRCell():New(oCliente,"CLOJA"		,/*Tabela*/	,RetTitle("D2_LOJA"		),PesqPict("SD2","D2_LOJA"		),TamSx3("D2_LOJA"			)[1],/*lPixel*/,{|| cLojaAnt				})
TRCell():New(oSection1,"UA_EMISSAO"	,"QRYSUA","Data Emissao"	,PesqPict("SUA","UA_EMISSAO"), TamSx3("UA_EMISSAO")[1],.F.)  
TRCell():New(oSection1,"UA_NUM"		,"QRYSUA","Numero"			,PesqPict("SUA","UA_NUM")	 , TamSx3("UA_NUM")[1])
TRCell():New(oSection1,"TIPO"		,"QRYSUA","Tipo"			,"@!"						 , 1)
TRCell():New(oSection1,"UA_CLIENTE"	,"QRYSUA","Cliente"			,PesqPict("SUA","UA_CLIENTE"), TamSx3("UA_CLIENTE")[1])
TRCell():New(oSection1,"NOME"		,"QRYSUA","Nome Fantasia"	,PesqPict("SA1","A1_NREDUZ"), TamSx3("A1_NREDUZ")[1])
TRCell():New(oSection1,"UA_VEND"	,"QRYSUA","Vendedor"		,PesqPict("SUA","UA_VEND"), TamSx3("UA_VEND")[1])
TRCell():New(oSection1,"A3_NOME"	,"QRYSUA","Nome Vend."		,PesqPict("SA3","A3_NOME"), TamSx3("A3_NOME")[1])
TRCell():New(oSection1,"UB_PRODUTO"	,"QRYSUA","Cod.PRODUTO"		,PesqPict("SUB","UB_PRODUTO") ,TamSx3("UB_PRODUTO")[1])
TRCell():New(oSection1,"B1_DESC"	,"QRYSUA","Descri็ใo"		,PesqPict("SB1","B1_DESC"), TamSx3("B1_DESC")[1])
TRCell():New(oSection1,"UB_QUANT"	,"QRYSUA","Qtd."			,PesqPict("SUB","UB_QUANT") ,TamSx3("UB_QUANT")[1])
TRCell():New(oSection1,"UB_VRUNIT"	,"QRYSUA","Vlr.Unit."		,PesqPict("SUB","UB_VRUNIT") ,TamSx3("UB_VRUNIT")[1])
TRCell():New(oSection1,"UB_VLRITEM"	,"QRYSUA","Total"			,PesqPict("SUB","UB_VLRITEM") ,TamSx3("UB_VLRITEM")[1])
TRCell():New(oSection1,"UA_NUMSC5"	,"QRYSUA","Numero PV"		,PesqPict("SUA","UA_NUMSC5") , TamSx3("UA_NUMSC5")[1])
TRCell():New(oSection1,"D2_DOC"		,"QRYSUA","Numero NF"		,PesqPict("SD2","D2_DOC") 	, TamSx3("D2_DOC")[1])



Return oReport

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)
Local cFiltro   := "" 

oSection1:BeginQuery()

BeginSql alias "QRYSUA"
	
	SELECT UA_EMISSAO, UA_NUM, 'C' TIPO, UA_CLIENTE, A1_NREDUZ NOME, UA_VEND, A3_NOME, UB_PRODUTO, B1_DESC, UB_QUANT, UB_VRUNIT, UB_VLRITEM, UA_NUMSC5, D2_DOC
	FROM %table:SUA% SUA
		INNER JOIN %table:SUB% SUB ON UA_NUM = UB_NUM AND SUB.%notDel%
		INNER JOIN %table:SA1% SA1 ON UA_CLIENTE = A1_COD AND SA1.%notDel%
		INNER JOIN %table:SB1% SB1 ON UB_PRODUTO = B1_COD AND SB1.%notDel%
		INNER JOIN %table:SA3% SA3 ON UA_VEND = A3_COD AND SA3.%notDel%
		LEFT OUTER JOIN %table:SD2% SD2 ON D2_PEDIDO = UB_NUMPV AND D2_ITEMPV = UB_ITEMPV AND D2_PEDIDO <> '' AND SD2.%notDel%
	WHERE UA_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND UA_VEND BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND UB_PRODUTO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND UA_PROSPEC = 'F'
		AND SUA.%notDel%
	UNION ALL
	SELECT UA_EMISSAO, UA_NUM, 'P' TIPO, UA_CLIENTE, US_NREDUZ NOME, UA_VEND, A3_NOME, UB_PRODUTO, B1_DESC, UB_QUANT, UB_VRUNIT, UB_VLRITEM, UA_NUMSC5, D2_DOC
	FROM %table:SUA% SUA
		INNER JOIN %table:SUB% SUB ON UA_NUM = UB_NUM AND SUB.%notDel%
		INNER JOIN %table:SUS% SUS ON UA_CLIENTE = US_COD AND SUS.%notDel%
		INNER JOIN %table:SB1% SB1 ON UB_PRODUTO = B1_COD AND SB1.%notDel%
		INNER JOIN %table:SA3% SA3 ON UA_VEND = A3_COD AND SA3.%notDel%
		LEFT OUTER JOIN %table:SD2% SD2 ON D2_PEDIDO = UB_NUMPV AND D2_ITEMPV = UB_ITEMPV AND D2_PEDIDO <> '' AND SD2.%notDel%
	WHERE UA_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND UA_VEND BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND UB_PRODUTO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND UA_PROSPEC = 'T'		
	AND SUA.%notDel%		
	ORDER BY UA_CLIENTE, UB_PRODUTO, UA_EMISSAO	
	
EndSql        

oSection1:EndQuery()

/*
oSection1:SetParentQuery()
IF ALLTRIM(MV_PAR03) <> "" // OU SEJA, SOMENTE OS ESTADOS QUE ESTA NO PARAMETRO
	oSection1:SetParentFilter({|cParam| QRYSD2->F2_EST $ MV_PAR03})
ENDIF
*/

oSection1:Print()

Return

Static Function AjustaSX1() 

//(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
//	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,	aHelpPor,aHelpEng,aHelpSpa,;
//cHelp)

Local aHelpPor	:= {}
//              'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' //Limite que vai aparecer no Help
Aadd( aHelpPor, "Estados selecionadas para a impressao.  "  )
Aadd( aHelpPor, 'Caso o campo esteja em branco serแ '  )
Aadd( aHelpPor, 'impresso todos os Estados.  Senใo ' )
Aadd( aHelpPor, 'preencha o campo separando os       ')
Aadd( aHelpPor, 'estados com / (barra). Exemplo:      ' )
Aadd( aHelpPor, 'SP/RJ/MG                            ')

PutSx1( cPerg, "01","Data de ?","ฟCuanto a tasa?","How about rate?","mv_cha","D",08,0,1,"G","","","","",;
			"mv_par01","","","","","","","","","","","","","","","","",,,)
PutSx1( cPerg, "02","Data Ate?","ฟCuanto a tasa?","How about rate?","mv_chb","D",08,0,1,"G","","","","",;
			"mv_par02","","","","","","","","","","","","","","","","",,,)			
PutSx1( cPerg, "03","Vendedor de ?","ฟCuanto a tasa?","How about rate?","mv_chc","C",06,0,1,"G","","SA3","","",;
			"mv_par03","","","","","","","","","","","","","","","","",,,)
PutSx1( cPerg, "04","Vendedor Ate?","ฟCuanto a tasa?","How about rate?","mv_chd","C",06,0,1,"G","","SA3","","",;
			"mv_par04","","","","","","","","","","","","","","","","",,,)			
PutSx1( cPerg, "05","Produto de ?","ฟCuanto a tasa?","How about rate?","mv_che","C",15,0,1,"G","","SB1","","",;
			"mv_par05","","","","","","","","","","","","","","","","",,,)
PutSx1( cPerg, "06","Produto Ate?","ฟCuanto a tasa?","How about rate?","mv_chf","C",15,0,1,"G","","SB1","","",;
			"mv_par06","","","","","","","","","","","","","","","","",,,)			


Return                                          

