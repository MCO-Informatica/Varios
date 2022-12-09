#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณNBEST001          บAutor  ณDenisVarellaบ Data ณ  04/10/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao de relat๓rio Anแlise de Custos		          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NBEST001()

Local cPerg		:= PadR("NBEST001",10)    
       
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

AADD(	aSx1,{ cPerg,"01","Ano Refer๊ncia AAAA				?","","","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(	aSx1,{ cPerg,"02","M๊s Refer๊ncia MM				?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

Static Function Plan02()
Local _cPathExcel:="C:\TEMP\"
Local  _cPath 	  := AllTrim(GetTempPath())
Local  _cArquivo  := CriaTrab(,.F.)
Local oExcel := Fwmsexcel():new() 
Local oFWMsExcel
Local cURLXML:= ''
Local cQuery:=""
Local cAnterior := SubStr(cValtoChar(DTOS(MonthSub(StoD(mv_par01+mv_par02+'01'),1))),1,6)
Local nCnt		:= 0

cQuery := ""

Private _nHandle  := FCreate(_cArquivo)

cQuery:= " SELECT B1_COD,B1_DESC,B1_MSBLQL,B1_TIPO, "
cQuery+= " isnull((SELECT SUM(B9_QINI) FROM " + RetSqlName('SB9') + " WHERE B9_DATA BETWEEN " + cAnterior + "01" + " AND " + cAnterior + "31" + " and B9_COD = B1_COD and D_E_L_E_T_ <> '*' GROUP BY B9_COD),0) QTDANTERIOR, "
cQuery+= " isnull((SELECT SUM(B9_VINI1) FROM " + RetSqlName('SB9') + " WHERE B9_DATA BETWEEN " + cAnterior + "01" + " AND " + cAnterior + "31" + " and B9_COD = B1_COD and D_E_L_E_T_ <> '*' GROUP BY B9_COD),0) TOTANTERIOR, "
cQuery+= " isnull((SELECT SUM(D2_QUANT)  FROM " + RetSqlName('SD2') + " SD2, " + RetSqlName('SF4') + " SF4  WHERE D2_COD = B1_COD AND SD2.D_E_L_E_T_ <> '*'  AND D2_ORIGLAN <> 'LF' AND D2_EMISSAO BETWEEN " + mv_par01 + mv_par02 + "01 AND " + mv_par01 + mv_par02 + "31  AND D2_TES=F4_CODIGO AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ <> '*'  GROUP BY D2_COD),0) QTDSAIDA, "
cQuery+= " isnull((SELECT SUM(D2_CUSTO1)  FROM " + RetSqlName('SD2') + " SD2, " + RetSqlName('SF4') + " SF4  WHERE D2_COD = B1_COD AND SD2.D_E_L_E_T_ <> '*'  AND D2_ORIGLAN <> 'LF' AND D2_EMISSAO BETWEEN " + mv_par01 + mv_par02 + "01 AND " + mv_par01 + mv_par02 + "31  AND D2_TES=F4_CODIGO AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ <> '*'  GROUP BY D2_COD),0) TOTAIDA, "
cQuery+= " isnull((SELECT SUM(D1_QUANT) QTENTRADA FROM " + RetSqlName('SD1') + " SD1 INNER JOIN " + RetSqlName('SF4') + " SF4 ON D1_TES=F4_CODIGO AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ <> '*'  WHERE D1_COD = B1_COD AND SD1.D_E_L_E_T_ <> '*'  AND D1_ORIGLAN <> 'LF' AND D1_DTDIGIT BETWEEN " + mv_par01 + mv_par02 + "01 AND " + mv_par01 + mv_par02 + "31  GROUP BY D1_COD),0) QTDENTRADA, "
cQuery+= " isnull((SELECT SUM(D1_CUSTO) QTENTRADA FROM " + RetSqlName('SD1') + " SD1 INNER JOIN " + RetSqlName('SF4') + " SF4 ON D1_TES=F4_CODIGO AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ <> '*'  WHERE D1_COD = B1_COD AND SD1.D_E_L_E_T_ <> '*'  AND D1_ORIGLAN <> 'LF' AND D1_DTDIGIT BETWEEN " + mv_par01 + mv_par02 + "01 AND " + mv_par01 + mv_par02 + "31  GROUP BY D1_COD),0) TOTENTRADA, "
//cQuery+= " isnull((SELECT SUM(D3_QUANT) FROM " + RetSqlName('SD3') + " SD3  WHERE  SD3.D3_TM <= 499 AND D3_COD = B1_COD AND SD3.D_E_L_E_T_ <> '*'  AND D3_ESTORNO=' ' AND D3_EMISSAO BETWEEN " + mv_par01 + mv_par02 + "01 AND " + mv_par01 + mv_par02 + "31 GROUP BY D3_COD),0) QTDD31, "
//cQuery+= " isnull((SELECT SUM(D3_CUSTO1) FROM " + RetSqlName('SD3') + " SD3  WHERE SD3.D3_TM <= 499 AND D3_COD = B1_COD AND SD3.D_E_L_E_T_ <> '*'  AND D3_ESTORNO=' ' AND D3_EMISSAO BETWEEN " + mv_par01 + mv_par02 + "01 AND " + mv_par01 + mv_par02 + "31 GROUP BY D3_COD),0) TOTD31, "
//cQuery+= " isnull((SELECT SUM(D3_QUANT) FROM " + RetSqlName('SD3') + " SD3  WHERE SD3.D3_TM > 499 AND D3_COD = B1_COD AND SD3.D_E_L_E_T_ <> '*'  AND D3_ESTORNO=' ' AND D3_EMISSAO BETWEEN " + mv_par01 + mv_par02 + "01 AND " + mv_par01 + mv_par02 + "31 GROUP BY D3_COD),0) QTDD32, "
//cQuery+= " isnull((SELECT SUM(D3_CUSTO1) FROM " + RetSqlName('SD3') + " SD3  WHERE SD3.D3_TM > 499 AND D3_COD = B1_COD AND SD3.D_E_L_E_T_ <> '*'  AND D3_ESTORNO=' ' AND D3_EMISSAO BETWEEN " + mv_par01 + mv_par02 + "01 AND " + mv_par01 + mv_par02 + "31 GROUP BY D3_COD),0) TOTD32, "
cQuery+= " isnull((SELECT SUM(B9_QINI) FROM " + RetSqlName('SB9') + " WHERE B9_DATA BETWEEN " + mv_par01 + mv_par02 + "01 AND " + mv_par01 + mv_par02 + "31 and B9_COD = B1_COD and D_E_L_E_T_ <> '*' GROUP BY B9_COD),0) QTDATUAL, "
cQuery+= " isnull((SELECT SUM(B9_VINI1) FROM " + RetSqlName('SB9') + " WHERE B9_DATA BETWEEN " + mv_par01 + mv_par02 + "01 AND " + mv_par01 + mv_par02 + "31 and B9_COD = B1_COD and D_E_L_E_T_ <> '*' GROUP BY B9_COD),0) TOTATUAL, "

//Movimenta็ใo interna de entrada - custo
cQuery+= " isnull((SELECT SUM(D3_CUSTO1) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_COD = B1_COD "
cQuery+= " 		AND SD3.D3_TM <= '499' " 
cQuery+= " 		AND SD3.D3_OP = '' "
cQuery+= " 		AND SD3.D3_CF NOT IN('DE4','RE4','DE6','RE6','PR0') "
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) MOVINTCUSE, " 

//Movimenta็ใo interna de entrada - quantidade
cQuery+= " isnull((SELECT SUM(D3_QUANT) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_COD = B1_COD " 
cQuery+= " 		AND SD3.D3_TM <= '499' "
cQuery+= " 		AND SD3.D3_OP = '' "
cQuery+= " 		AND SD3.D3_CF NOT IN('DE4','RE4','DE6','RE6','PR0') "
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) MOVINTQTDE, " 

//Movimenta็ใo interna SAIDA - CUSTO
cQuery+= " isnull((SELECT SUM(D3_CUSTO1) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_COD = B1_COD "
cQuery+= " 		AND SD3.D3_TM >= '500' " 
cQuery+= " 		AND SD3.D3_OP = '' "
cQuery+= " 		AND SD3.D3_CF NOT IN('DE4','RE4','DE6','RE6','PR0') "
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) MOVINTCUSS, " 
		
//Movimenta็ใo interna SAIDA - QUANTIDADE		
cQuery+= " isnull((SELECT SUM(D3_QUANT) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_COD = B1_COD " 
cQuery+= " 		AND SD3.D3_TM >= '500' "
cQuery+= " 		AND SD3.D3_OP = '' "
cQuery+= " 		AND SD3.D3_CF NOT IN('DE4','RE4','DE6','RE6','PR0') "
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) MOVINTQTDS, " 		


//Ordem de Produ็ใo - custo		
cQuery+= " isnull((SELECT SUM(D3_CUSTO1) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_COD = B1_COD " 
cQuery+= " 		AND SD3.D3_OP != '' "
cQuery+= " 		AND SD3.D3_CF = 'PR0' "
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) OPCUS, " 
		
//Ordem de Produ็ใo - quantidade		
cQuery+= " isnull((SELECT SUM(D3_QUANT) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_OP != '' "
cQuery+= " 		AND SD3.D3_CF = 'PR0' "
cQuery+= " 		AND SD3.D3_COD = B1_COD " 
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) OPCUSQTD, " 

//Requisi็ใo de produ็ใo -- CUSTO		
cQuery+= " isnull((SELECT SUM(D3_CUSTO1) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_COD = B1_COD " 
cQuery+= " 		AND SD3.D3_OP != '' "
cQuery+= " 		AND SD3.D3_CF != 'PR0' "
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) REQCUS, " 
		
//Requisi็ใo de produ็ใo -- QUANTIDADE		
cQuery+= " isnull((SELECT SUM(D3_QUANT) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_OP != '' "
cQuery+= " 		AND SD3.D3_CF != 'PR0' "
cQuery+= " 		AND SD3.D3_COD = B1_COD " 
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) REQQTD, " 		


//Transferencia Saida - Custo
cQuery+= " isnull((SELECT SUM(D3_CUSTO1) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_COD = B1_COD "
cQuery+= " 		AND SD3.D3_TM >= '500' " 		
cQuery+= " 		AND SD3.D3_CF = 'RE4' "
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) TRFCUSS, " 
		
		
//Transferencia Saida - quantidade		
cQuery+= " isnull((SELECT SUM(D3_QUANT) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_TM >= '500' " 		
cQuery+= " 		AND SD3.D3_CF = 'RE4' "
cQuery+= " 		AND SD3.D3_COD = B1_COD " 
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) TRFQTDS, " 	


//Transferencia Entrada - CUSTO
cQuery+= " isnull((SELECT SUM(D3_CUSTO1) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_COD = B1_COD "
cQuery+= " 		AND SD3.D3_TM <= '499' " 		
cQuery+= " 		AND SD3.D3_CF = 'DE4' "
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) TRFCUSE, " 
		
//Transferencia Entrada - QUANTIDADE		
cQuery+= " isnull((SELECT SUM(D3_QUANT) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_TM <= '499' " 		
cQuery+= " 		AND SD3.D3_CF = 'DE4' "
cQuery+= " 		AND SD3.D3_COD = B1_COD " 
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) TRFQTDE, " 				

//CQ Saida - Custo
cQuery+= "  isnull((SELECT SUM(D3_CUSTO1) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_COD = B1_COD "
cQuery+= " 		AND SD3.D3_TM >= '500' " 		
cQuery+= " 		AND SD3.D3_CF = 'RE6' "
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) CQCUSS, " 
		
//CQ Saida - Quantidade		
cQuery+= " isnull((SELECT SUM(D3_QUANT) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_TM >= '500' " 		
cQuery+= " 		AND SD3.D3_CF = 'RE6' "
cQuery+= " 		AND SD3.D3_COD = B1_COD " 
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) CQQTDS, " 		


//CQ Entrada - Custo
cQuery+= " isnull((SELECT SUM(D3_CUSTO1) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_COD = B1_COD "
cQuery+= " 		AND SD3.D3_TM <= '499' " 		
cQuery+= " 		AND SD3.D3_CF = 'DE6' "
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) CQCUSE, " 
		
//CQ Saida - Quantidade		
cQuery+= " isnull((SELECT SUM(D3_QUANT) FROM " + RetSqlName('SD3') + " SD3 "  
cQuery+= " 		WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery+= " 		AND SD3.D3_TM <= '499' " 		
cQuery+= " 		AND SD3.D3_CF = 'DE6' "
cQuery+= " 		AND SD3.D3_COD = B1_COD " 
cQuery+= " 		AND SD3.D3_ESTORNO=' ' " 
cQuery+= " 		AND SD3.D3_EMISSAO BETWEEN '" + mv_par01 + mv_par02 + "01' AND '" + mv_par01 + mv_par02 + "31' " 
cQuery+= " 		AND SD3.D_E_L_E_T_ <> '*' "  
cQuery+= " 		),0) CQQTDE " 						



cQuery+= " FROM " + RetSqlName('SB1') + " WHERE D_E_L_E_T_ <> '*' " + " ORDER BY B1_COD "
memowrite("NBEST001.txt",cQuery)

TcQuery cQuery New Alias (cAliasEst:=GetNextAlias())

If (cAliasEst)->(!Eof())
	_lRet := .T.
EndIf


oExcel:AddworkSheet("PARยMETROS")
oExcel:AddTable("PARยMETROS","PARยMETROS")
oExcel:AddColumn("PARยMETROS","PARยMETROS","Ano de Refer๊cia",1,1)
oExcel:AddColumn("PARยMETROS","PARยMETROS","M๊s de Refer๊ncia",1,1)
oExcel:AddRow("PARยMETROS","PARยMETROS",{mv_par01,;
mv_par02})

oExcel:AddworkSheet("Anแlise de Custos")
oExcel:AddTable("Anแlise de Custos","Anแlise de Custos")
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","C๓digo",1,1)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Produto",1,1)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Tipo",1,1)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Bloqueado",1,1)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Sld Ant. Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Sld Ant. Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","NF Saํda Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","NF Saํda Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","NF Entr. Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","NF Entr. Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Mov Int Ent. Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Mov Int Ent. Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Mov Int Saida Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Mov Int Saida Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Producao Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Producao Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Req.Produ็ใo Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Req.Produ็ใo Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Transf.Ent.Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Transf.Ent.Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Transf.Saida Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Transf.Saida Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","CQ Ent. Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","CQ Ent. Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","CQ Saida Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","CQ Saida Custo",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Saldo Qtd",1,2)
oExcel:AddColumn("Anแlise de Custos","Anแlise de Custos","Saldo Custo",1,2)


(cAliasEst)->( DbGoTop() )
(cAliasEst)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
(cAliasEst)->( DbGoTop() )

ProcRegua(nCnt)


While !(cAliasEst)->(EOF())
IncProc("Processando...")

oExcel:AddRow("Anแlise de Custos","Anแlise de Custos",{trim((cAliasEst)->B1_COD),trim((cAliasEst)->B1_DESC),;
(cAliasEst)->B1_TIPO,;
(cAliasEst)->B1_MSBLQL,;
(cAliasEst)->QTDANTERIOR,;
(cAliasEst)->TOTANTERIOR,;
(cAliasEst)->QTDSAIDA,;
(cAliasEst)->TOTAIDA,;
(cAliasEst)->QTDENTRADA,;
(cAliasEst)->TOTENTRADA,;
(cAliasEst)->MOVINTQTDE,;
(cAliasEst)->MOVINTCUSE,;
(cAliasEst)->MOVINTQTDS,;
(cAliasEst)->MOVINTCUSS,;
(cAliasEst)->OPCUSQTD,;
(cAliasEst)->OPCUS,;
(cAliasEst)->REQQTD,;
(cAliasEst)->REQCUS,;
(cAliasEst)->TRFQTDE,;
(cAliasEst)->TRFCUSE,;
(cAliasEst)->TRFQTDS,;
(cAliasEst)->TRFCUSS,;
(cAliasEst)->CQQTDE,;
(cAliasEst)->CQCUSE,;
(cAliasEst)->CQQTDS,;
(cAliasEst)->CQCUSS,;
(cAliasEst)->QTDATUAL,;
(cAliasEst)->TOTATUAL})

(cAliasEst)->(DbSKip())
Enddo

(cAliasEst)->(DbCloseArea())

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

Plan02()