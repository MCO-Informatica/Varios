#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE 'TBICONN.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณParcial de Vendas บAutor  ณDenisVarellaบ Data ณ  28/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao de relat๓rio Parcial de Vendas em excel             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NBFAT001()

Local cPerg		:= PadR("NBFAT001",10)    
Private _cPathExcel:="C:\TEMP\"
Private  _cArquivo  := CriaTrab(,.F.)
       
AjustaSX1(cPerg)
If Pergunte(cPerg,.T.)

	Processa( {|| Plan02() },"Aguarde" ,"Processando...")

EndIf

Return() 

User Function NBJFAT01()
	Local cTo := SuperGetMV("MV_TOFAT01",,"denis.varella@newbridge.srv.br")
	Local cCC := SuperGetMV("MV_CCFAT01",,"")

	Local dUlMes := GetMv("MV_ULMES")
	Local dNBFAT01 := GetMv("MV_NBFAT01")

	Local dMes := FirstDate(MonthSub(FirstDate(Date()),1))

	Private MV_PAR01 := dMes
	Private MV_PAR02 := LastDate(dMes)
	Private MV_PAR03 := ""
	Private MV_PAR04 := "ZZZZZZ"
	Private MV_PAR05 := ""
	Private MV_PAR06 := "ZZZZZZ"
	Private MV_PAR07 := ""
	Private MV_PAR08 := "ZZZZZZ"
	Private MV_PAR09 := ""
	Private MV_PAR10 := "ZZZ"
	Private MV_PAR11 := ""
	Private MV_PAR12 := "ZZ"
	Private MV_PAR13 := 0
	Private MV_PAR14 := 0
	Private MV_PAR15 := 1
	Private MV_PAR16 := 3

	Private _cArquivo  := "RELMARGEM"
	Private _cPathExcel := "\NBFAT001\"

	If dNBFAT01 < MonthSub(FirstDate(Date()),1) .and. dUlMes == LastDate(MonthSub(FirstDate(Date()),1))

		Processa( {|| Plan02() },"Aguarde" ,"Processando...")
		U_zEnvMail(cTo, "Relat๓rio de Margem Completo - "+Month2Str(dMes)+"/"+Year2Str(dMes), "Data de processamento: "+DtoC(date())+" เs "+Time()+".", {"\NBFAT001\"+_cArquivo+".xml"}, .f., .t., .t., cCC)
		fErase("\NBFAT007\"+_cArquivo+".xml")
		PUTMV("MV_NBFAT01", Date())

	EndIf

Return

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
Local oExcel := Fwmsexcel():new()
Local cQuery:=""

Private _nHandle  := FCreate(_cArquivo)

If mv_par15 == 1
cQuery:= " SELECT D1_TOTAL,A1_COD,A1_NREDUZ,A1_MUN, " + Chr(13)
cQuery+= " SUBSTRING(F2_EMISSAO,7,2) + '/' + SUBSTRING(F2_EMISSAO,5,2) + '/' + SUBSTRING(F2_EMISSAO,1,4) as F2_EMISSAO, "  
cQuery+= " D2_PICM,AOV_DESSEG,F2_EST,A1_CODSEG,A1_CDRDES,D2_DOC,A3_NREDUZ,E4_DESCRI,E4_ACRVEN1,B1_DESCINT,D2_QUANT,D2_PRCVEN,D2_VALIPI, "  
cQuery+= " D2_VALFRE, "  
cQuery+= " (D2_VALICM + D2_VALIMP5 + D2_VALIMP6 + D2_DIFAL + D2_ICMSCOM) AS IMPOSTOS, "  
cQuery+= " (D2_TOTAL - (D2_VALICM + D2_VALIPI + D2_VALIMP5 + D2_VALIMP6 + D2_DIFAL + D2_ICMSCOM)) AS NETSALES,"  
cQuery+= " D2_CUSTO1, "  
cQuery+= " ((D2_TOTAL - (D2_VALICM + D2_VALIPI + D2_VALIMP5 + D2_VALIMP6 + D2_DIFAL + D2_ICMSCOM)) - (D2_CUSTO1 + nullif((D1_TOTAL * (D2_TOTAL / (select SUM(D2_TOTAL) FROM SD2010 WHERE D2_DOC = D2.D2_DOC))),0) + ((D2_TOTAL + D2_VALIPI) * E4_ACRVEN1 / 100))) as MARGBRUT, "  
cQuery+= " ((((D2_TOTAL - (D2_VALICM + D2_VALIPI + D2_VALIMP5 + D2_VALIMP6 + D2_DIFAL + D2_ICMSCOM)) - (D2_CUSTO1 + nullif((D1_TOTAL * (D2_TOTAL / (select SUM(D2_TOTAL) FROM SD2010 WHERE D2_DOC = D2.D2_DOC))),0) + ((D2_TOTAL + D2_VALIPI) * E4_ACRVEN1 / 100))) / nullif((D2_TOTAL - (D2_VALICM + D2_VALIPI + D2_VALIMP5 + D2_VALIMP6 + D2_DIFAL + D2_ICMSCOM)),0)) * 100) as MARGPORC, "  
cQuery+= " (D2_CUSTO1 / nullif(D2_QUANT,0)) as CUSTOKG, "  
cQuery+= " (D2_TOTAL + D2_VALIPI) as TOTALFAT, "  

/* Alterado por Denis 08/01/2018 */   
cQuery+= " F4_ESTOQUE as ESTOQUE, "  
/* Alterado por Denis 08/01/2018 */    
	
cQuery+= " ((D2_TOTAL + D2_VALIPI) * E4_ACRVEN1 / 100) AS CUSTOFIN, "  
cQuery+= " (D2_CUSTO1 + nullif((D1_TOTAL * (D2_TOTAL / (select SUM(D2_TOTAL) FROM SD2010 WHERE D2_DOC = D2.D2_DOC))),0)) AS CUSTOOP, "  
cQuery+= " nullif((D1_TOTAL * (D2_TOTAL / (select SUM(D2_TOTAL) FROM SD2010 WHERE D2_DOC = D2.D2_DOC))),0) AS FRETECIF "  
cQuery+= " FROM " + RetSqlName("SD2") + " D2 "  
cQuery+= " INNER JOIN " + RetSqlName('SA1') + " A1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA "  
cQuery+= " LEFT JOIN " + RetSqlName('SA3') + " A3 ON A1_VEND = A3_COD AND A3.D_E_L_E_T_ = ''   "  
cQuery+= " LEFT JOIN " + RetSqlName('SA7') + " A7 ON D2_CLIENTE = A7_CLIENTE AND D2_LOJA = A7_LOJA AND D2_COD = A7_PRODUTO AND A7.D_E_L_E_T_ = ''   "  
cQuery+= " LEFT JOIN " + RetSqlName('AOV') + " OV ON AOV_CODSEG = A7_XSEGMEN AND OV.D_E_L_E_T_ = ''   "  
cQuery+= " INNER JOIN " + RetSqlName('SB1') + " B1 ON D2_COD = B1_COD "  
cQuery+= " INNER JOIN " + RetSqlName('SF2') + " F2 ON D2_DOC = F2_DOC and D2_SERIE = F2_SERIE "  
cQuery+= " LEFT JOIN " + RetSqlName('SE4') + " E4 ON E4_CODIGO = F2_COND "     
cQuery+= " INNER JOIN " + RetSqlName('SF4') + " F4 ON D2_TES = F4_CODIGO AND F4_DUPLIC='S' "     
cQuery+= " LEFT JOIN " + RetSqlName('SD1') + " D1 ON D2_DOC = D1_NFSAIDA AND D1_SERIORI = D2_SERIE AND D1_ITEMORI = D2_ITEM AND D1_TIPO = 'D' AND D1.D_E_L_E_T_ <> '*' "  
cQuery+= " WHERE  "  
cQuery+= " D2_EMISSAO BETWEEN '" + DTos(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND "   
cQuery+= " A1_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "   
cQuery+= " A1_VEND BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND "   
cQuery+= " A7_XSEGMEN BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' AND "   
cQuery+= " A1_REGIAO BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND "  
cQuery+= " F2_EST BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' AND "  
cQuery+= "A1.D_E_L_E_T_=' ' AND  "  
cQuery+= "B1.D_E_L_E_T_=' ' AND  "  
cQuery+= "D2.D_E_L_E_T_=' ' AND  "  
cQuery+= "E4.D_E_L_E_T_=' ' AND  "  
cQuery+= "F2.D_E_L_E_T_=' ' AND  "  
cQuery+= "F4.D_E_L_E_T_=' ' "  
Else
cQuery:= " SELECT sum(D1_TOTAL) as D1_TOTAL,A1_COD,('---') as D2_PRCVEN,('---') as A1_MUN,('---') as D2_PICM,('--/--/----') as F2_EMISSAO,AOV_DESSEG,A1_NREDUZ,D2_DOC,F2_EST,A1_CODSEG,A1_CDRDES,A3_NREDUZ,E4_DESCRI,E4_ACRVEN1,B1_DESCINT,sum(D2_QUANT) as D2_QUANT,sum(D2_VALIPI) as D2_VALIPI, "  
cQuery+= " sum(D2_VALFRE) as D2_VALFRE, "  
cQuery+= " sum((D2_VALICM + D2_VALIMP5 + D2_VALIMP6 + D2_DIFAL + D2_ICMSCOM)) AS IMPOSTOS, "  
cQuery+= " sum((D2_TOTAL - (D2_VALICM + D2_VALIPI + D2_VALIMP5 + D2_VALIMP6 + D2_DIFAL + D2_ICMSCOM))) AS NETSALES,"  
cQuery+= " sum(D2_CUSTO1) as D2_CUSTO1, "  
cQuery+= " sum(((D2_TOTAL - (D2_VALICM + D2_VALIPI + D2_VALIMP5 + D2_VALIMP6 + D2_DIFAL + D2_ICMSCOM)) - (D2_CUSTO1 + nullif((D1_TOTAL * D2_TOTAL),0) + ((D2_TOTAL + D2_VALIPI) * nullif(E4_ACRVEN1,0) / 100)))) as MARGBRUT, "  
cQuery+= " sum(((((D2_TOTAL - (D2_VALICM + D2_VALIPI + D2_VALIMP5 + D2_VALIMP6 + D2_DIFAL + D2_ICMSCOM)) - (D2_CUSTO1 + nullif((D1_TOTAL * D2_TOTAL),0) + ((D2_TOTAL + D2_VALIPI) * nullif(E4_ACRVEN1,0) / 100))) / nullif((D2_TOTAL - (D2_VALICM + D2_VALIPI + D2_VALIMP5 + D2_VALIMP6 + D2_DIFAL + D2_ICMSCOM)),0)) * 100)) as MARGPORC, "  
cQuery+= " sum(nullif(D2_CUSTO1,0) / nullif(D2_QUANT, 0)) as CUSTOKG, "  
cQuery+= " sum(D2_TOTAL + D2_VALIPI) as TOTALFAT, "  
cQuery+= " sum(((D2_TOTAL + D2_VALIPI) * nullif(E4_ACRVEN1,0) / 100)) AS CUSTOFIN, "  
cQuery+= " sum(nullif(D1_TOTAL,0)) AS FRETECIF, " 

/* Alterado por Denis 08/01/2018 */   
cQuery+= " F4_ESTOQUE as ESTOQUE, "  
/* Alterado por Denis 08/01/2018 */    

cQuery+= " sum((D2_CUSTO1 + nullif((D1_TOTAL),0))) AS CUSTOOP "  
cQuery+= " FROM " + RetSqlName("SD2") + " D2 "  
cQuery+= " INNER JOIN " + RetSqlName('SA1') + " A1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA "  
cQuery+= " LEFT JOIN " + RetSqlName('SA3') + " A3 ON A1_VEND = A3_COD AND A3.D_E_L_E_T_ = ''   "  
cQuery+= " LEFT JOIN " + RetSqlName('SA7') + " A7 ON D2_CLIENTE = A7_CLIENTE AND D2_LOJA = A7_LOJA AND D2_COD = A7_PRODUTO AND A7.D_E_L_E_T_ = ''   "  
cQuery+= " LEFT JOIN " + RetSqlName('AOV') + " OV ON AOV_CODSEG = A7_XSEGMEN AND OV.D_E_L_E_T_ = ''   "  
cQuery+= " INNER JOIN " + RetSqlName('SB1') + " B1 ON D2_COD = B1_COD "  
cQuery+= " INNER JOIN " + RetSqlName('SF2') + " F2 ON D2_DOC = F2_DOC and D2_SERIE = F2_SERIE "  
cQuery+= " LEFT JOIN " + RetSqlName('SE4') + " E4 ON E4_CODIGO = F2_COND "     
cQuery+= " INNER JOIN " + RetSqlName('SF4') + " F4 ON D2_TES = F4_CODIGO AND F4_DUPLIC='S' "     
cQuery+= " LEFT JOIN " + RetSqlName('SD1') + " D1 ON D2_DOC = D1_NFSAIDA AND D1_SERIORI = D2_SERIE AND D1_ITEMORI = D2_ITEM AND D1_TIPO = 'D' AND D1.D_E_L_E_T_ <> '*' "  
cQuery+= " WHERE  "  
cQuery+= " D2_EMISSAO BETWEEN '" + DTos(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND "   
cQuery+= " A1_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "   
cQuery+= " A1_VEND BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND "   
cQuery+= " A7_XSEGMEN BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' AND "   
cQuery+= " A1_REGIAO BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND "   
cQuery+= " F2_EST BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' AND "  
cQuery+= "A1.D_E_L_E_T_=' ' AND  "  
cQuery+= "B1.D_E_L_E_T_=' ' AND  "  
cQuery+= "D2.D_E_L_E_T_=' ' AND  "  
cQuery+= "E4.D_E_L_E_T_=' ' AND  "  
cQuery+= "F2.D_E_L_E_T_=' ' AND  "  
cQuery+= "F4.D_E_L_E_T_=' ' "	  
cQuery+= "GROUP BY D2_CLIENTE,D2_COD,A1_COD,A1_NREDUZ,D2_DOC,F2_EST,A1_CODSEG,A1_CDRDES,A3_NREDUZ,E4_DESCRI,E4_ACRVEN1,B1_DESCINT,A1_MUN,AOV_DESSEG,F2_EMISSAO,D2_PICM,F4_ESTOQUE  
Endif
cQuery+= " ORDER BY A1_NREDUZ,D2_COD "   
memowrite("GERSAI",cQuery)

TcQuery cQuery New Alias (cAliasD2:=GetNextAlias())

If (cAliasD2)->(!Eof())
	_lRet := .T.
EndIf

If mv_par15 == 1
cQuery:= " SELECT A1_COD,A1_NREDUZ,F1_EST,A1_CODSEG,A1_CDRDES,A1_MUN, "  
cQuery+= " SUBSTRING(F1_EMISSAO,7,2) + '/' + SUBSTRING(F1_EMISSAO,5,2) + '/' + SUBSTRING(F1_EMISSAO,1,4) as F1_EMISSAO, "  
cQuery+= " D1_PICM,AOV_DESSEG,A3_NREDUZ,B1_DESCINT,D1_DOC,D1_QUANT,(D1_VUNIT*-1) as D1_VUNIT,D1_VALFRE,D1_VALIPI,(D1_VALICM + D1_VALIMP5 + D1_VALIMP6 + D1_ICMSCOM) AS IMPOSTOS,(D1_TOTAL - (D1_VALICM + D1_VALIPI + D1_VALIMP5 + D1_VALIMP6 + D1_ICMSCOM)) AS NETSALES, "

/* Alterado por Denis 08/01/2018 */   
cQuery+= " F4_ESTOQUE as ESTOQUE, "  
/* Alterado por Denis 08/01/2018 */    
 
cQuery+= "D1_CUSTO,((D1_TOTAL - (D1_VALICM + D1_VALIPI + D1_VALIMP5 + D1_VALIMP6 + D1_ICMSCOM)) - D1_CUSTO) as MARGBRUT, ((((D1_TOTAL - (D1_VALICM + D1_VALIPI + D1_VALIMP5 + D1_VALIMP6 + D1_ICMSCOM)) - D1_CUSTO) / nullif((D1_TOTAL - (D1_VALICM + D1_VALIPI + D1_VALIMP5 + D1_VALIMP6 + D1_ICMSCOM)),0)) * 100) as MARGPORC, (D1_CUSTO / nullif(D1_QUANT,0)) as CUSTOKG, (D1_TOTAL + D1_VALIPI) as TOTALFAT "  
cQuery+= " FROM " + RetSqlName("SD1") + " D1 "  
cQuery+= " INNER JOIN " + RetSqlName('SA1') + " A1 ON D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA "  
cQuery+= " LEFT JOIN " + RetSqlName('SA3') + " A3 ON A1_VEND = A3_COD AND A3.D_E_L_E_T_ = ''   "  
cQuery+= " LEFT JOIN " + RetSqlName('SA7') + " A7 ON D1_FORNECE = A7_CLIENTE AND D1_LOJA = A7_LOJA AND D1_COD = A7_PRODUTO AND A7.D_E_L_E_T_ = ''   "  
cQuery+= " LEFT JOIN " + RetSqlName('AOV') + " OV ON AOV_CODSEG = A7_XSEGMEN AND OV.D_E_L_E_T_ = ''   "  
cQuery+= " INNER JOIN " + RetSqlName('SB1') + " B1 ON D1_COD = B1_COD "  
cQuery+= " INNER JOIN " + RetSqlName('SF1') + " F1 ON D1_DOC = F1_DOC and D1_SERIE = F1_SERIE "  
cQuery+= " INNER JOIN " + RetSqlName('SF4') + " F4 ON D1_TES = F4_CODIGO AND F4_DUPLIC='S' "     
cQuery+= " WHERE  "  
cQuery+= " D1_TIPO = 'D' AND "    
cQuery+= " D1_DTDIGIT BETWEEN '" + DTos(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND "    
cQuery+= " A1_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "   
cQuery+= " A1_VEND BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND "   
cQuery+= " A7_XSEGMEN BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' AND "   
cQuery+= " A1_CDRDES BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND "   
cQuery+= " F1_EST BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' AND "  
cQuery+= "A1.D_E_L_E_T_=' ' AND  "  
cQuery+= "B1.D_E_L_E_T_=' ' AND  "  
cQuery+= "D1.D_E_L_E_T_=' ' AND  "  
cQuery+= "F1.D_E_L_E_T_=' ' AND  "  
cQuery+= "F4.D_E_L_E_T_=' ' "  
Else
cQuery:= " SELECT D1_COD,A1_COD,A1_NREDUZ,F1_EST,A1_CODSEG,D1_DOC,A1_CDRDES,('---') as A1_MUN,('---') as D1_PICM,('--/--/----') as F1_EMISSAO,AOV_DESSEG,A3_NREDUZ,B1_DESCINT,('---') as D1_VUNIT, "  
cQuery+= " sum(D1_QUANT) as D1_QUANT, "  
cQuery+= " sum(D1_VALFRE) as D1_VALFRE, "  
cQuery+= " sum(D1_VALIPI) as D1_VALIPI, "  
cQuery+= " sum((D1_VALICM + D1_VALIMP5 + D1_VALIMP6 + D1_ICMSCOM)) AS IMPOSTOS, "  
cQuery+= " sum(D1_TOTAL - (D1_VALICM + D1_VALIPI + D1_VALIMP5 + D1_VALIMP6 + D1_ICMSCOM)) AS NETSALES, "  
cQuery+= " sum(D1_CUSTO) as D1_CUSTO, "  
cQuery+= " sum(((D1_TOTAL - (D1_VALICM + D1_VALIPI + D1_VALIMP5 + D1_VALIMP6 + D1_ICMSCOM)) - D1_CUSTO)) as MARGBRUT, "   
cQuery+= " sum((((D1_TOTAL - (D1_VALICM + D1_VALIPI + D1_VALIMP5 + D1_VALIMP6 + D1_ICMSCOM)) - D1_CUSTO)) / (D1_TOTAL - (D1_VALICM + D1_VALIPI + D1_VALIMP5 + D1_VALIMP6 + D1_ICMSCOM))) as MARGPORC, "   
cQuery+= " sum(nullif(D1_CUSTO,0) / nullif(D1_QUANT,0)) as CUSTOKG,  " 

/* Alterado por Denis 08/01/2018 */   
cQuery+= " F4_ESTOQUE as ESTOQUE, "  
/* Alterado por Denis 08/01/2018 */    

cQuery+= " sum(D1_TOTAL + D1_VALIPI) as TOTALFAT  "  
cQuery+= " FROM " + RetSqlName("SD1") + " D1 "  
cQuery+= " INNER JOIN " + RetSqlName('SA1') + " A1 ON D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA "
cQuery+= " LEFT JOIN " + RetSqlName('SA3') + " A3 ON A1_VEND = A3_COD AND A3.D_E_L_E_T_ = ''   "  
cQuery+= " LEFT JOIN " + RetSqlName('SA7') + " A7 ON D1_FORNECE = A7_CLIENTE AND D1_LOJA = A7_LOJA AND D1_COD = A7_PRODUTO AND A7.D_E_L_E_T_ = ''   "  
cQuery+= " LEFT JOIN " + RetSqlName('AOV') + " OV ON AOV_CODSEG = A7_XSEGMEN AND OV.D_E_L_E_T_ = ''   "  
cQuery+= " INNER JOIN " + RetSqlName('SB1') + " B1 ON D1_COD = B1_COD "  
cQuery+= " INNER JOIN " + RetSqlName('SF1') + " F1 ON D1_DOC = F1_DOC and D1_SERIE = F1_SERIE "  
cQuery+= " INNER JOIN " + RetSqlName('SF4') + " F4 ON D1_TES = F4_CODIGO AND F4_DUPLIC='S' "     
cQuery+= " WHERE  "  
cQuery+= " D1_TIPO = 'D' AND "    
cQuery+= " D1_DTDIGIT BETWEEN '" + DTos(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND "    
cQuery+= " A1_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "   
cQuery+= " A1_VEND BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND "   
cQuery+= " A7_XSEGMEN BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' AND "   
cQuery+= " A1_CDRDES BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND "   
cQuery+= " F1_EST BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' AND "  
cQuery+= "A1.D_E_L_E_T_=' ' AND  "   
cQuery+= "B1.D_E_L_E_T_=' ' AND  "  
cQuery+= "D1.D_E_L_E_T_=' ' AND  "  
cQuery+= "F1.D_E_L_E_T_=' ' AND  "  
cQuery+= "F4.D_E_L_E_T_=' ' "  
cQuery+= "GROUP BY D1_COD,A1_COD,A1_NREDUZ,D1_DOC,D1_FORNECE,F1_EST,A1_CODSEG,A1_CDRDES,A3_NREDUZ,B1_DESCINT,A1_MUN,AOV_DESSEG,F1_EMISSAO,D1_PICM,F4_ESTOQUE "  
Endif
cQuery+= " ORDER BY A1_NREDUZ,D1_COD "  
memowrite("GERENT",cQuery)

TcQuery cQuery New Alias (cAliasD1:=GetNextAlias())

If (cAliasD1)->(!Eof())
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

oExcel:AddworkSheet("MARGEM GERA DUPLICATA")
oExcel:AddTable("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA")
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Tipo",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Data",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","NF",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Cod Cliente",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Cliente",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","UF",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Cidade",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Segmento",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Regiใo",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Vendedor",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Cod Pagto",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Produto",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Alํq. ICMS",1,1)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Quantidade",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Valor Unit",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Valor IPI",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Venda Bruta",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Impostos",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Venda NET",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Frete CIF",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Frete FOB",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","CPV",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Margem Bruta",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Custo Financeiro",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","%Margem",1,2)
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Custo por KG",1,2)
/* Alterado por Denis 08/01/2018 */   
oExcel:AddColumn("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA","Mov. Estoque",1,2)
/* Alterado por Denis 08/01/2018 */   

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
if mv_par16 != 2
If (cAliasD2)->MARGPORC >= mv_par13 .AND. (cAliasD2)->MARGPORC <= mv_par14 .OR. mv_par13 == 0 .AND. mv_par14 == 0
oExcel:AddRow("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA",{'Venda',;
(cAliasD2)->F2_EMISSAO,;
(cAliasD2)->D2_DOC,;
(cAliasD2)->A1_COD,;
(cAliasD2)->A1_NREDUZ,;
(cAliasD2)->F2_EST,;
(cAliasD2)->A1_MUN,;
(cAliasD2)->AOV_DESSEG,;
(cAliasD2)->A1_CDRDES,;
(cAliasD2)->A3_NREDUZ,;
(cAliasD2)->E4_DESCRI,;
(cAliasD2)->B1_DESCINT,;
(cAliasD2)->D2_PICM,;
(cAliasD2)->D2_QUANT,;
(cAliasD2)->D2_PRCVEN,;
(cAliasD2)->D2_VALIPI,;
(cAliasD2)->TOTALFAT,;
(cAliasD2)->IMPOSTOS,;
(cAliasD2)->NETSALES,;
(cAliasD2)->FRETECIF,;
(cAliasD2)->D2_VALFRE,;
(cAliasD2)->CUSTOOP,;
(cAliasD2)->MARGBRUT,;
(cAliasD2)->CUSTOFIN,;
(cAliasD2)->MARGPORC,;
(cAliasD2)->CUSTOKG,;
(cAliasD2)->ESTOQUE})
Endif
Endif
(cAliasD2)->(DbSKip())
Enddo

(cAliasD1)->(DbGotOP())

While !(cAliasD1)->(EOF())
if mv_par16 != 1
If (cAliasD1)->MARGPORC >= mv_par13 .AND. (cAliasD1)->MARGPORC <= mv_par14 .OR. mv_par13 == 0 .AND. mv_par14 == 0
oExcel:AddRow("MARGEM GERA DUPLICATA","MARGEM GERA DUPLICATA",{'Devolu็ใo',;
(cAliasD1)->F1_EMISSAO,;
(cAliasD1)->D1_DOC,;
(cAliasD1)->A1_COD,;
(cAliasD1)->A1_NREDUZ,;
(cAliasD1)->F1_EST,;
(cAliasD1)->A1_MUN,;
(cAliasD1)->AOV_DESSEG,;
(cAliasD1)->A1_CDRDES,;
(cAliasD1)->A3_NREDUZ,;
'',;
(cAliasD1)->B1_DESCINT,;
(cAliasD1)->D1_PICM,;
(cAliasD1)->D1_QUANT,;
(cAliasD1)->D1_VUNIT,;
(cAliasD1)->D1_VALIPI*-1,;
(cAliasD1)->TOTALFAT*-1,;
(cAliasD1)->IMPOSTOS*-1,;
(cAliasD1)->NETSALES*-1,;
0,;
(cAliasD1)->D1_VALFRE*-1,;
(cAliasD1)->D1_CUSTO*-1,;
(cAliasD1)->MARGBRUT*-1,;
0,;
(cAliasD1)->MARGPORC,;
(cAliasD1)->CUSTOKG*-1,;
(cAliasD1)->ESTOQUE})
Endif
Endif
(cAliasD1)->(DbSKip())
Enddo

(cAliasD1)->(DbCloseArea())
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

Plan02()
