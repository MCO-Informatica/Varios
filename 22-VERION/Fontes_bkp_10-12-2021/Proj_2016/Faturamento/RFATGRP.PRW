/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFATGRP  บ Autor ณ ADINFO CONSULTORIA บ Data ณ  21/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Imprime relat๓rio em formato Treport de vendas por grupo   บฑฑ
ฑฑบ          ณ de produtos.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verion                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

#include "protheus.ch"

User Function RFATGRP()
Local oReport
cPerg := "RFATGRP  " 
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

oReport := TReport():New("RFATGRP","Relat๓rio de Vendas por Grupo","RFATGRP  ",{|oReport| PrintReport(oReport)},"Relatorio de Vendas por Grupo")

oSection1 := TRSection():New(oReport,"Itens","SD2")

//TRCell():New(oCliente,"CLOJA"		,/*Tabela*/	,RetTitle("D2_LOJA"		),PesqPict("SD2","D2_LOJA"		),TamSx3("D2_LOJA"			)[1],/*lPixel*/,{|| cLojaAnt				})
//	SELECT D2_EMISSAO, D2_DOC, D2_PEDIDO, D2_CLIENTE, A1_NOME, B1_GRUPO, D2_COD, B1_DESC, D2_QUANT, D2_PRCVEN, D2_TOTAL	
TRCell():New(oSection1,"D2_EMISSAO"	,"QRYSUA","Data Emissao"	,PesqPict("SD2","D2_EMISSAO"), TamSx3("D2_EMISSAO")[1],.F.)  
TRCell():New(oSection1,"D2_DOC"		,"QRYSUA","Numero NF"		,PesqPict("SD2","D2_DOC")	 , TamSx3("D2_DOC")[1])
TRCell():New(oSection1,"D2_PEDIDO"	,"QRYSUA","No. Pedido"		,PesqPict("SD2","D2_PEDIDO"), TamSx3("D2_PEDIDO")[1])
TRCell():New(oSection1,"D2_CLIENTE"	,"QRYSUA","Cliente"			,PesqPict("SD2","D2_CLIENTE"), TamSx3("D2_CLIENTE")[1])
TRCell():New(oSection1,"A1_NREDUZ"	,"QRYSUA","Nome Fantasia"	,PesqPict("SA1","A1_NREDUZ"), TamSx3("A1_NREDUZ")[1])
TRCell():New(oSection1,"B1_GRUPO"	,"QRYSUA","Grupo"			,PesqPict("SB1","B1_GRUPO"), TamSx3("B1_GRUPO")[1])
TRCell():New(oSection1,"D2_COD"		,"QRYSUA","Cod. Prod."		,PesqPict("SD2","D2_COD"), TamSx3("D2_COD")[1])
TRCell():New(oSection1,"B1_DESC"	,"QRYSUA","Descri็ใo"		,PesqPict("SB1","B1_DESC"), TamSx3("B1_DESC")[1])
TRCell():New(oSection1,"D2_QUANT"	,"QRYSUA","Qtd."			,PesqPict("SD2","D2_QUANT") ,TamSx3("D2_QUANT")[1])
TRCell():New(oSection1,"D2_PRCVEN"	,"QRYSUA","Vlr.Unit."		,PesqPict("SD2","D2_PRCVEN") ,TamSx3("D2_PRCVEN")[1])
TRCell():New(oSection1,"D2_TOTAL"	,"QRYSUA","Total"			,PesqPict("SD2","D2_TOTAL") ,TamSx3("D2_TOTAL")[1])


Return oReport

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)
Local cFiltro   := "" 

oSection1:BeginQuery()

BeginSql alias "QRYSD2"
	
	SELECT D2_EMISSAO, D2_DOC, D2_PEDIDO, D2_CLIENTE, A1_NREDUZ, B1_GRUPO, D2_COD, B1_DESC, D2_QUANT, D2_PRCVEN, D2_TOTAL	
	FROM %table:SD2% SD2
		INNER JOIN %table:SB1% SB1 ON B1_COD = D2_COD AND SB1.%notDel%
		INNER JOIN %table:SA1% SA1 ON D2_CLIENTE = A1_COD AND SA1.%notDel%
		INNER JOIN %table:SF4% SF4 ON F4_CODIGO = D2_TES AND F4_DUPLIC = 'S' AND SF4.%notDel%		
	WHERE D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND B1_GRUPO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND D2_COD BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SD2.%notDel%
	ORDER BY D2_EMISSAO, B1_GRUPO
	
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
PutSx1( cPerg, "03","Grupo de ?","ฟCuanto a tasa?","How about rate?","mv_chc","C",04,0,1,"G","","SBM","","",;
			"mv_par03","","","","","","","","","","","","","","","","",,,)
PutSx1( cPerg, "04","Grupo Ate?","ฟCuanto a tasa?","How about rate?","mv_chd","C",04,0,1,"G","","SBM","","",;
			"mv_par04","","","","","","","","","","","","","","","","",,,)			
PutSx1( cPerg, "05","Produto de ?","ฟCuanto a tasa?","How about rate?","mv_che","C",15,0,1,"G","","SB1","","",;
			"mv_par05","","","","","","","","","","","","","","","","",,,)
PutSx1( cPerg, "06","Produto Ate?","ฟCuanto a tasa?","How about rate?","mv_chf","C",15,0,1,"G","","SB1","","",;
			"mv_par06","","","","","","","","","","","","","","","","",,,)			


Return                                          

