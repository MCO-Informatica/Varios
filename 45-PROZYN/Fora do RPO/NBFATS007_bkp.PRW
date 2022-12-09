#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'                                                           

/*                                       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณNBFAT007          บAutor  ณDaniel Paulo  Data ณ  06/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao de relat๓rio de Margem tab SZR			          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                                          
User Function NBFAT007()  

	Local cPerg		:= PadR("NBFAT007",10)    

	AjustaSX1(cPerg)
	If Pergunte(cPerg,.T.)

		Processa( {|| Plan02() },"Aguarde" ,"Processando...")

	EndIf

Return() 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1(cPerg)
	Local j
	Local i
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg   := PADR(cPerg,10)
	aSx1   :={}

	AADD(	aSx1,{ cPerg,"01","Data Emissใo De				?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(	aSx1,{ cPerg,"02","Data Emissใo At้				?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(	aSx1,{ cPerg,"03","Cliente De					?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1DEN",""})
	AADD(	aSx1,{ cPerg,"04","Cliente At้					?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1DEN",""})
	AADD(	aSx1,{ cPerg,"05","Vendedor De					?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
	AADD(	aSx1,{ cPerg,"06","Vendedor At้					?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
	AADD(	aSx1,{ cPerg,"07","Segmento De					?","","","mv_ch7","C",20,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","AOV",""})
	AADD(	aSx1,{ cPerg,"08","Segmento At้					?","","","mv_ch8","C",20,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","AOV",""})
	AADD(	aSx1,{ cPerg,"09","Regiใo De					?","","","mv_ch9","C",10,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","A2",""})
	AADD(	aSx1,{ cPerg,"10","Regiใo At้					?","","","mv_chA","C",10,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","A2",""})
	AADD(	aSx1,{ cPerg,"11","UF De						?","","","mv_chB","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","12",""})
	AADD(	aSx1,{ cPerg,"12","UF At้						?","","","mv_chC","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","12",""})
	AADD(	aSx1,{ cPerg,"13","Margem Maior					%","","","mv_chD","N",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(	aSx1,{ cPerg,"14","Margem Menor					%","","","mv_chE","N",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(	aSx1,{ cPerg,"15","Tipo de relatorio			 ","","","mv_chF","N",08,0,0,"C","","mv_par15","Analํtico","","","","","Sint้tico","","","","","","","","","","","","","","","","","","","",""})
	AADD(	aSx1,{ cPerg,"16","Mostrar						 ","","","mv_chG","N",08,0,0,"C","","mv_par16","Vendas","","","","","Devolu็๕es","","","","","Ambos","","","","","","","","","","","","","","",""})
	//AADD(	aSx1,{ cPerg,"17","Moeda Escolhida:				 ","","","mv_chH","N",08,0,0,"C","","mv_par17","MOEDA 1","","","","","MOEDA 2","","","","","","","","","","","","","","","","","","","",""})

	For i := 1 to Len(aSx1)
		If !dbSeek(cPerg+aSx1[i,2])
			RecLock("SX1",.T.)
			For j := 1 To FCount()
				If j <= Len(aSx1[i])
					FieldPut(j,aSx1[i,j])
				Else
					Exit
				EndIf
			Next
			MsUnlock()
		EndIf
	Next

	dbSelectArea(_sAlias)

Return(cPerg)	

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณ Plan02()       ณ Autor ณ AF Custom       ณ Data ณ 27/11/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Plan02()
	Local _cPathExcel:="C:\TEMP\"
	Local  _cArquivo  := CriaTrab(,.F.)
	Local oExcel := Fwmsexcel():new() 
	Local cQuery:=""
	Local nCnt	:= 0

	Private _nHandle  := FCreate(_cArquivo)

	If mv_par15 == 1

		cQuery:= " SELECT ZR.*,ISNULL(CASE WHEN F2_TPFRETE IS NULL THEN C5_TPFRETE ELSE F2_TPFRETE END,'') FRETE,B1_TIPO,ISNULL(ADK_NOME,'OUTROS') NEGOCIO,A7_XSEG2,A7_XLP  " + Chr(13)
		cQuery+= " FROM " + RetSqlName("SZR") + " ZR   " + Chr(13) 
		cQuery+=  " LEFT JOIN " + RetSqlName("SF2") + " F2 ON F2_DOC = ZR_DOC AND F2_EMISSAO = ZR_EMISSAO AND F2.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NUM = ZR_DOC AND C5.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " INNER JOIN " + RetSqlName("SA7") + " A7 ON A7_CLIENTE = ZR_COD AND A7_LOJA = ZR_LJCLIFO AND A7_PRODUTO = ZR_CODPROD AND A7.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " INNER JOIN " + RetSqlName("AOV") + " AOV ON AOV_CODSEG = A7_XSEGMEN AND AOV.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " LEFT JOIN " + RetSqlName("ADK") + " ADK ON CONVERT(INT,ADK_COD) = CONVERT(INT,SUBSTRING(AOV_XUNEG,1,1)) AND ADK.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " INNER JOIN " + RetSqlName("SB1") + " B1 ON B1_COD = ZR_CODPROD AND B1.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+= " WHERE  " + Chr(13) 
		cQuery+= " ZR_EMISSAO BETWEEN '" + DTos(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND "   
		cQuery+= " ZR_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "   
		cQuery+= " ZR_VCOD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND "   
		cQuery+= " ZR_CODSEG BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' AND "   
		cQuery+= " ZR_REGIAO BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND "   
		cQuery+= " ZR_EST BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' "      
		cQuery+= " ORDER BY ZR_TPOPER,ZR_EMISSAO " 

	Else         

		cQuery:= " SELECT " + Chr(13) 
		cQuery+= " ZR_FILIAL,  ZR_EMISSAO, ZR_COD, ZR_DOC, ISNULL(CASE WHEN F2_TPFRETE IS NULL THEN C5_TPFRETE ELSE F2_TPFRETE END,'') FRETE, ZR_NREDUZ,ZR_CODSEG,ZR_CDRDES,ISNULL(ADK_NOME,'OUTROS') NEGOCIO,ZR_DESSEG,A7_XSEG2,A7_XLP,ZR_VREDUZ, ZR_MUN, ZR_PICM," + Chr(13)
		cQuery+=  " '' AS ZR_PRCVEN,sum(ZR_QUANT) AS ZR_QUANT,sum(ZR_TOTAL) as ZR_TOTAL,sum(ZR_TOTAL1) AS ZR_TOTAL1,sum(ZR_VALIPI) AS ZR_VALIPI,sum(ZR_VALICM) AS ZR_VALICM, " + Chr(13)
		cQuery+=  " ZR_CF,sum(ZR_CUSTO1) AS ZR_CUSTO1 ,sum(ZR_VALIMP5) AS ZR_VALIMP5,sum(ZR_VALIMP6) AS ZR_VALIMP6,sum(ZR_VALFRE) AS ZR_VALFRE,ZR_DESCRI,ZR_EST, " + Chr(13)
		cQuery+=  " ZR_DUPLIC,ZR_ESTOQUE,ZR_DESCINT,sum(ZR_ACRVEN1) AS ZR_ACRVEN1,sum(ZR_DIFAL) AS ZR_DIFAL,sum(ZR_ICMSCOM) AS ZR_ICMSCOM,ZR_XNFVEN,ZR_XNFVITE, " + Chr(13)
		cQuery+=  " ZR_TPOPER,ZR_LJCLIFO,ZR_CODPROD,B1_TIPO,ZR_VCOD,ZR_REGIAO,sum(ZR_TTFRT) AS ZR_TTFRT, SUM(ZR_TTITNF) AS ZR_TTITNF, " + Chr(13)
		cQuery+=  " ZR_MOEDA, ZR_TXMOEDA, ZR_LOTECTL, ZR_DTVALID, ZR_DSCPAIS, ZR_NCM ,ZR_DESCGV "+ Chr(13)
		cQuery+=  " FROM " + RetSqlName("SZR") + " ZR   " + Chr(13) 
		cQuery+=  " LEFT JOIN " + RetSqlName("SF2") + " F2 ON F2_DOC = ZR_DOC AND F2_EMISSAO = ZR_EMISSAO AND F2.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NUM = ZR_DOC AND C5.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " INNER JOIN " + RetSqlName("SA7") + " A7 ON A7_CLIENTE = ZR_COD AND A7_LOJA = ZR_LJCLIFO AND A7_PRODUTO = ZR_CODPROD AND A7.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " INNER JOIN " + RetSqlName("AOV") + " AOV ON AOV_CODSEG = A7_XSEGMEN AND AOV.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " LEFT JOIN " + RetSqlName("ADK") + " ADK ON CONVERT(INT,ADK_COD) = CONVERT(INT,SUBSTRING(AOV_XUNEG,1,1)) AND ADK.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " INNER JOIN " + RetSqlName("SB1") + " B1 ON B1_COD = ZR_CODPROD AND B1.D_E_L_E_T_ = '' " + Chr(13) 
		cQuery+=  " WHERE  " + Chr(13)
		cQuery+=  " ZR_EMISSAO BETWEEN '" + DTos(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND "  
		cQuery+=  " ZR_VCOD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND "   
		cQuery+=  " ZR_CODSEG BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' AND "    
		cQuery+=  " ZR_REGIAO BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND "   
		cQuery+=  " ZR_EST BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' "   
		cQuery+=  " group by "
		//cQuery+=  " ZR_FILIAL,ZR_COD,ZR_DOC,ZR_MUN,ZR_NREDUZ,ZR_CODSEG,ZR_CDRDES,ZR_DESSEG,ZR_VREDUZ,ZR_PICM,ZR_CF,ZR_DESCRI,ZR_EST,ZR_DUPLIC,ZR_ESTOQUE,ZR_DESCINT,ZR_XNFVEN,ZR_XNFVITE, " 
		cQuery+=  " ZR_FILIAL,ZR_DOC,C5_TPFRETE,F2_TPFRETE, ZR_EMISSAO, ZR_COD,ZR_MUN,ZR_NREDUZ,ZR_CODSEG,ZR_CDRDES,ADK_NOME,ZR_DESSEG,A7_XSEG2,A7_XLP,ZR_VREDUZ,ZR_PICM,ZR_CF,ZR_DESCRI,ZR_EST,ZR_DUPLIC,ZR_ESTOQUE,ZR_DESCINT,ZR_XNFVEN,ZR_XNFVITE, " 
		cQuery+=  " ZR_TPOPER,ZR_LJCLIFO,ZR_CODPROD,B1_TIPO,ZR_VCOD,ZR_REGIAO,    "  
		cQuery+=  " ZR_MOEDA, ZR_TXMOEDA, ZR_LOTECTL, ZR_DTVALID, ZR_DSCPAIS, ZR_NCM ,ZR_DESCGV "
	Endif

	memowrite("GERSZR",cQuery)

	TcQuery cQuery New Alias (cAliasD2:=GetNextAlias())

	(cAliasD2)->( DbGoTop() )
	(cAliasD2)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
	(cAliasD2)->( DbGoTop() )	
	ProcRegua(nCnt)

	If (cAliasD2)->(!Eof())
		_lRet := .T.
	EndIf


	oExcel:AddworkSheet("PARยMETROS")
	oExcel:AddTable("PARยMETROS","PARยMETROS")
	oExcel:AddColumn("PARยMETROS","PARยMETROS","PARAMETROS",1,1)
	oExcel:AddColumn("PARยMETROS","PARยMETROS","VALOR",1,1)
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Data Digita็ใo De',;
	DTOC(mv_par01)})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Data Digita็ใo At้',;
	DTOC(mv_par02)})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Cliente De',;
	mv_par03})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Cliente At้',;
	mv_par04})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Vendedor De',;
	mv_par05})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Vendedor At้',;
	mv_par06})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Segmento De',;
	mv_par07})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Segmento At้',;
	mv_par08})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Regiใo De',;
	mv_par09})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Regiใo At้',;
	mv_par10})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'UF De',;
	mv_par11})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'UF At้',;
	mv_par12})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Margem Maior %',;
	mv_par13})
	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Margem Menor %',;
	mv_par14})

	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Tipo de Relat๓rio',;
	Iif(mv_par15 == 1,'Analํtico','Sint้tico')})

	oExcel:AddRow("PARยMETROS","PARยMETROS",{'Mostrar',;
	Iif(mv_par16 == 1,'Vendas',Iif(mv_par16 == 2,'Devolu็๕es','Ambos'))})

	oExcel:AddworkSheet("MARGEM TAB SZR")
	oExcel:AddTable("MARGEM TAB SZR","MARGEM TAB SZR")
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Tipo",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Data",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","NF",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Cod Cliente",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Cliente",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","UF",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Cidade",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Unid. Neg๓cio",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Segmento",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Segmenta็ใo",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Linha",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Regiใo",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Vendedor",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Cod Pagto",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Produto",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Tipo",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Alํq. ICMS",1,1)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Quantidade",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Valor Unit",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Valor IPI",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Venda Bruta",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Impostos",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Venda NET",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Tipo Frete",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Frete CIF",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Frete FOB",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","CPV",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Margem Bruta",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Custo Financeiro",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","%Margem",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Custo por KG",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Gera Duplicatas",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Mov. Estoque",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","CFOP",1,2)

	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Moeda",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Tx Moeda",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","GGF",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Cod Prod",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Lote produto",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Dt.Vld.Lote",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Desc Pais",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","NCM",1,2)
	oExcel:AddColumn("MARGEM TAB SZR","MARGEM TAB SZR","Desc Grp Ven",1,2)

	(cAliasD2)->(DbGotOP())

	If mv_par13 == 0 .AND. mv_par14 == 0
		mv_par13 := -9999
		mv_par14 := 9999
	ElseIf mv_par13 == 0 .AND. mv_par14 != 0
		mv_par13 := -9999
	Elseif mv_par13 != 0 .AND. mv_par14 == 0
		mv_par14 := 9999
	Endif

	While !(cAliasD2)->(EOF())

		IncProc("Processando...")

		TOTALFAT :=	((cAliasD2)->ZR_TOTAL + (cAliasD2)->ZR_VALIPI)
		IMPOSTOS := ((cAliasD2)->ZR_VALICM + (cAliasD2)->ZR_VALIMP5 + (cAliasD2)->ZR_VALIMP6 + (cAliasD2)->ZR_DIFAL + (cAliasD2)->ZR_ICMSCOM)
		NETSALES := (TOTALFAT - IMPOSTOS)
		CUSTOFIN := (TOTALFAT * ((cAliasD2)->ZR_ACRVEN1 / 100))
		FRTCIF   := ((cAliasD2)->ZR_TTFRT *(TOTALFAT/(cAliasD2)->ZR_TTITNF)) 	// TOTALFRETE*(TOTALFAT / TOTALITENSNF)
		MARGBRUT := (NETSALES - ((cAliasD2)->ZR_CUSTO1 + FRTCIF + CUSTOFIN))// net sales - (CUSTO + fretecif + custofin)
		MARGPORC := ((NETSALES - ((cAliasD2)->ZR_CUSTO1 + FRTCIF + CUSTOFIN))/NETSALES)*100//((netsales - ( CUSTO + fretecif + custofin))/netsales)*100
		CUSTOKG  := ((cAliasD2)->ZR_CUSTO1 + FRTCIF + CUSTOFIN)/(cAliasD2)->ZR_QUANT   //(CUSTO + fretecif + custofin)/quantidade





		if mv_par16 != 2
			If MARGPORC >= mv_par13 .AND. MARGPORC <= mv_par14 .OR. mv_par13 == 0 .AND. mv_par14 == 0
				oExcel:AddRow("MARGEM TAB SZR","MARGEM TAB SZR",{(cAliasD2)->ZR_TPOPER,;
				STOD((cAliasD2)->ZR_EMISSAO),;
				(cAliasD2)->ZR_DOC,;
				(cAliasD2)->ZR_COD,;
				(cAliasD2)->ZR_NREDUZ,;
				(cAliasD2)->ZR_EST,;
				(cAliasD2)->ZR_MUN,;
				(cAliasD2)->NEGOCIO,;
				(cAliasD2)->ZR_DESSEG,;
				(cAliasD2)->A7_XSEG2,;
				(cAliasD2)->A7_XLP,;
				(cAliasD2)->ZR_CDRDES,;
				(cAliasD2)->ZR_VREDUZ,;
				(cAliasD2)->ZR_DESCRI,;
				(cAliasD2)->ZR_DESCINT,;
				(cAliasD2)->B1_TIPO,;
				(cAliasD2)->ZR_PICM,;
				(cAliasD2)->ZR_QUANT,;
				(cAliasD2)->ZR_PRCVEN,;
				(cAliasD2)->ZR_VALIPI,;
				TOTALFAT,;
				IMPOSTOS,;
				NETSALES,;
				(cAliasD2)->FRETE,;
				FRTCIF,;
				(cAliasD2)->ZR_VALFRE,;
				(cAliasD2)->ZR_CUSTO1,;
				MARGBRUT,;
				CUSTOFIN,;
				MARGPORC,;
				CUSTOKG,;
				(cAliasD2)->ZR_DUPLIC,;
				(cAliasD2)->ZR_ESTOQUE,;
				(cAliasD2)->ZR_CF,;
				(cAliasD2)->ZR_MOEDA,;
				(cAliasD2)->ZR_TXMOEDA,;
				GetGGF((cAliasD2)->ZR_CODPROD, (cAliasD2)->ZR_LOTECTL),;
				(cAliasD2)->ZR_CODPROD,;
				(cAliasD2)->ZR_LOTECTL,;
				STOD((cAliasD2)->ZR_DTVALID),;
				(cAliasD2)->ZR_DSCPAIS,;
				(cAliasD2)->ZR_NCM,;
				(cAliasD2)->ZR_DESCGV;
				})
			Endif
		Endif
		(cAliasD2)->(DbSKip())
	Enddo

	(cAliasD2)->(DbCloseArea())


	oExcel:Activate()
	oExcel:GetXMLFile(_cArquivo+".xml")

	__CopyFile(_cArquivo+".xml",_cPathExcel+_cArquivo+".xml")

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cPathExcel+_cArquivo+".xml") // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetGGF		บAutor  ณMicrosiga	     บ Data ณ  15/05/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o valor da GGF									  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetGGF(cCodProd, cLote)

	Local aArea 	:= GetArea()
	Local nRet		:= 0
	Local nCust		:= 0
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cCodProd	:= "" 
	Default cLote		:= "" 

	cQuery	:= " SELECT D3_EMISSAO, D3_COD, D3_LOTECTL, D3_OP, SUM(D3_QUANT) D3_QUANT FROM "+RetSqlName("SD3")+" SD3 "+CRLF
	cQuery	+= " WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' "+CRLF
	cQuery	+= " AND D3_COD = '"+cCodProd+"' "+CRLF
	cQuery	+= " AND D3_LOTECTL = '"+cLote+"' " +CRLF
	cQuery	+= " AND SD3.D3_CF = 'PR0' "+CRLF
	cQuery	+= " AND SD3.D3_ESTORNO != 'S' "+CRLF
	cQuery	+= " AND SD3.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " GROUP BY D3_EMISSAO, D3_COD, D3_LOTECTL, D3_OP "+CRLF 
	cQuery	+= " ORDER BY D3_EMISSAO DESC "
	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())
		nCust := GetCusMod((cArqTmp)->D3_OP, (cArqTmp)->D3_EMISSAO)

		If (cArqTmp)->D3_QUANT != 0
			nRet += (nCust/(cArqTmp)->D3_QUANT)
		EndIf

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetCusMod		บAutor  ณMicrosiga	     บ Data ณ  15/05/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o custo de produto MOD							  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCusMod(cOp, cEmissao)

	Local aArea 	:= GetArea()
	Local nRet		:= 0
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOp 		:= ""
	Default cEmissao	:= ""

	cQuery := " SELECT SUM(D3_CUSTO1) D3_CUSTO1 FROM "+RetSqlName("SD3")+" SD3 "+CRLF
	cQuery += " WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' "+CRLF
	cQuery += " AND D3_COD LIKE '%MOD%' "+CRLF
	cQuery += " AND D3_EMISSAO = '"+cEmissao+"' "+CRLF
	cQuery += " AND D3_OP = '"+cOp+"' "+CRLF
	cQuery += " AND SD3.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		nRet := (cArqTmp)->D3_CUSTO1
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return nRet
