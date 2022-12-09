#include 'protheus.ch'

Static cArqSint		:= GetNextAlias()//Tabela temporaria sintetica

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVP008		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreeche a tabela temporaria com os dados do forecast		  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/
User Function PZCVP008(nOpc, cCodSegDe, cCodSegAte, nAno)

	Local aArea		:= GetArea()

	Default nOpc		:= 1
	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= ""
	Default nAno		:= 0

	If nOpc == 1 //Inicializa a tabela temporaria

		//Cria a tabela temporaria
		CriaTabFc(cCodSegDe, cCodSegAte, nAno)

		//Atualiza faturamento realizado na tabela temporaria
		AtuFatReal(cCodSegDe, cCodSegAte, nAno)

		//Atualiza faturamento realizado do ano anterior na tabela temporaria
		AtuFatAnt(cCodSegDe, cCodSegAte, nAno)

		//Atualiza o forecast na tabela temporaria
		AtuForecast(cCodSegDe, cCodSegAte, nAno)

		//Atualiza o budget na tabela temporaria
		AtuBudget(cCodSegDe, cCodSegAte, nAno)

		//Atualiza o Relaizado | Forecast da tabela temporaria
		AtuRealFc(cCodSegDe, cCodSegAte, nAno)

		//Atualiza o Realizado + Pedido em carteira(Aberto) na tabela temporaria
		AtuRealPv(cCodSegDe, cCodSegAte, nAno)		

		DbSelectArea(cArqSint)
		DbSetOrder(2)
		(cArqSint)->(DbGoTop())

	ElseIf nOpc == 2 //Fecha a tabela temporaria

		If Select(cArqSint) > 0
			(cArqSint)->(DbCloseArea())
		EndIf

	EndIf

	RestArea(aArea)	
Return cArqSint


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCriaTabFc		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTabela temporaria sintetica								  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaTabFc(cCodSegDe, cCodSegAte, nAno)

	Local aArea 	:= GetArea()
	Local aCmp		:= {}
	Local cArq		:= ""
	Local cIndex1	:= ""
	Local cIndex2	:= ""
	
	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= "" 
	Default nAno		:= 0

	aAdd (aCmp, {"SIN_UNIDNE"	,"C", TAMSX3("ADK_COD")[1]		,	0})
	aAdd (aCmp, {"SIN_DESCUN"	,"C", TAMSX3("ADK_NOME")[1]		,	0})
	aAdd (aCmp, {"SIN_MES"		,"C", 2	,	0})  
	aAdd (aCmp, {"SIN_DMES"		,"C", 11	,	0})
	aAdd (aCmp, {"SIN_ANO"		,"C", 4		,	0})
	aAdd (aCmp, {"SIN_ANOANT"	,"C", 4		,	0})   
	aAdd (aCmp, {"SIN_REAANT"	,"N", TAMSX3("F2_VALBRUT")[1],	TAMSX3("F2_VALBRUT")[2]})
	aAdd (aCmp, {"SIN_REAATU"	,"N", TAMSX3("F2_VALBRUT")[1],	TAMSX3("F2_VALBRUT")[2]})
	aAdd (aCmp, {"SIN_FORECA"	,"N", TAMSX3("F2_VALBRUT")[1],	TAMSX3("F2_VALBRUT")[2]})
	aAdd (aCmp, {"SIN_BUDGET"	,"N", TAMSX3("F2_VALBRUT")[1],	TAMSX3("F2_VALBRUT")[2]})
	aAdd (aCmp, {"SIN_REAFC"	,"N", TAMSX3("F2_VALBRUT")[1],	TAMSX3("F2_VALBRUT")[2]})//Real/Forecast
	aAdd (aCmp, {"SIN_REAPVA"	,"N", TAMSX3("F2_VALBRUT")[1],	TAMSX3("F2_VALBRUT")[2]})//Real+Pedido em carteira

	cArq	:=	CriaTrab(aCmp)
	DbUseArea (.T., __LocalDriver, cArq, cArqSint)

	cIndex1 := CriaTrab(,.F.)
	IndRegua(cArqSint, cIndex1, "SIN_ANO+SIN_MES+SIN_UNIDNE")

	cIndex2 := CriaTrab(,.F.)
	IndRegua(cArqSint, cIndex2, "SIN_UNIDNE+SIN_ANO+SIN_MES")
	

	dbClearIndex()
	dbSetIndex(cIndex1+OrdBagExt())
	dbSetIndex(cIndex2+OrdBagExt())

	//Inicializa a tabela temporaria
	IntTabTmp(cCodSegDe, cCodSegAte, nAno)

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณIntTabTmp		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicializa็ใo da tabela temporaria						  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IntTabTmp(cCodSegDe, cCodSegAte, nAno)

	Local aArea		:= GetArea()
	Local nX		:= 0
	Local nMeses	:= 12
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= "" 
	Default nAno		:= 0

	cQuery	:= "SELECT * FROM "+RetSqlName("ADK")+" ADK "+CRLF
	cQuery	+= " WHERE ADK.ADK_FILIAL = '"+xFilial("ADK")+"' "+CRLF
	cQuery	+= " AND ADK.ADK_COD BETWEEN '"+cCodSegDe+"' AND '"+cCodSegAte+"' "+CRLF 
	cQuery	+= " AND ADK.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea(cArqSint)
	DbSetOrder(1)

	While (cArqTmp)->(!Eof())

		For nX := 1 To nMeses
			RecLock(cArqSint,.T.)

			(cArqSint)->SIN_UNIDNE	:= (cArqTmp)->ADK_COD 
			(cArqSint)->SIN_DESCUN	:= Posicione("ADK",1,xFilial("ADK")+(cArqTmp)->ADK_COD,"ADK_NOME")
			(cArqSint)->SIN_ANO   	:= Alltrim(Str(nAno))
			(cArqSint)->SIN_ANOANT	:= Alltrim(Str(nAno-1))
			(cArqSint)->SIN_MES		:= GetCMes(nX)
			(cArqSint)->SIN_DMES	:= GetDMes(nX)

			(cArqSint)->SIN_REAANT := 0
			(cArqSint)->SIN_REAATU := 0
			(cArqSint)->SIN_FORECA := 0
			(cArqSint)->SIN_BUDGET := 0
			(cArqSint)->SIN_REAFC  := 0
			(cArqSint)->SIN_REAPVA := 0

			(cArqSint)->(MsUnLock())
		Next

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณAtuFatReal	บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
/ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสอออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza o faturamento realizado do ano atual				  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuFatReal(cCodSegDe, cCodSegAte, nAno)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cMesAux	:= ""
	Local cExcCfop := SuperGetMv('MV_EXCMARG',, '5551')   

	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= ""
	Default nAno		:= 0

	cQuery	:= " SELECT MES, ADK_COD, SUM(D2_QUANT) QUANTIDADE, SUM(D2_TOTAL+D2_VALIPI) VALOR FROM ( "+CRLF
	cQuery	+= " SELECT 'FAT' TP, D2_DOC, D2_SERIE, D2_EMISSAO, " +CRLF
	cQuery	+= " 		Month(D2_EMISSAO) MES, " +CRLF
	cQuery	+= " 		Year(D2_EMISSAO) ANO, " +CRLF
	cQuery	+= " 		D2_TIPO, D2_QUANT, D2_PRCVEN, "+CRLF 
	cQuery	+= " 		D2_TOTAL, D2_VALIPI, D2_VALFRE, " +CRLF
	cQuery	+= " 		D2_VALIMP5, D2_VALIMP6, D2_DIFAL, " +CRLF
	cQuery	+= " 		D2_ICMSCOM, D2_VALICM, D2_CUSTO1, " +CRLF
	cQuery	+= " 		D2_LOTECTL, D2_DTVALID, "+CRLF
	cQuery	+= " 		A1_COD, A1_LOJA, A1_NREDUZ, " +CRLF
	cQuery	+= " 		A3_COD, A3_NOME, " +CRLF
	cQuery	+= " 		B1_COD, B1_DESC, "+CRLF
	cQuery	+= " 		ADK_NOME, ADK_COD "+CRLF
	cQuery	+= " 		FROM "+RetSqlName("SD2")+" SD2 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD2.D2_COD "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD = SD2.D2_CLIENTE "+CRLF
	cQuery	+= " AND SA1.A1_LOJA = SD2.D2_LOJA "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("ADK")+" ADK "+CRLF
	cQuery	+= " ON ADK.ADK_FILIAL= '"+xFilial("ADK")+"' "+CRLF
	cQuery	+= " AND ADK.ADK_COD BETWEEN '"+cCodSegDe+"' AND '"+cCodSegAte+"'  "+CRLF
	cQuery	+= " AND ADK.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA3")+" SA3 "+CRLF
	cQuery	+= " ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' "+CRLF
	cQuery	+= " AND SA3.A3_COD = SA1.A1_VEND "+CRLF
	cQuery	+= " AND SA3.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA7")+" SA7 "+CRLF
	cQuery	+= " ON SA7.A7_FILIAL = SA1.A1_FILIAL "+CRLF
	cQuery	+= " AND SA7.A7_CLIENTE = SA1.A1_COD "+CRLF
	cQuery	+= " AND SA7.A7_LOJA = SA1.A1_LOJA "+CRLF
	cQuery	+= " AND SA7.A7_PRODUTO = SD2.D2_COD "+CRLF
	cQuery	+= " AND SUBSTRING(SA7.A7_XSEGMEN,1,1) = SUBSTRING(ADK.ADK_COD, 6,1) "+CRLF
	cQuery	+= " AND SA7.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF 
	cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQuery	+= " AND SF4.F4_CODIGO = SD2.D2_TES "+CRLF
	cQuery	+= " AND SF4.F4_DUPLIC = 'S' "+CRLF
	cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= " WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"' "+CRLF 
	cQuery	+= " AND YEAR(SD2.D2_EMISSAO) = "+Alltrim(Str(nAno))+" "+CRLF
	cQuery	+= " AND SD2.D2_TIPO != 'D' "+CRLF
	cQuery	+= " AND SD2.D2_CF NOT IN"+FormatIn(cExcCfop,";")+" "+CRLF
	cQuery	+= " AND SD2.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " UNION ALL "+CRLF

	cQuery	+= " SELECT 'DEV' TP, D1_DOC, D1_SERIE, D1_DTDIGIT, "+CRLF 
	cQuery	+= " 		Month(D1_DTDIGIT) MES, " +CRLF
	cQuery	+= " 		Year(D1_EMISSAO) ANO, " +CRLF
	cQuery	+= " 		D1_TIPO, (D1_QUANT*-1) D1_QUANT, (D1_VUNIT*-1) D1_VUNIT, "+CRLF 
	cQuery	+= " 		(D1_TOTAL*-1) D1_TOTAL, (D1_VALIPI*-1) D1_VALIPI, (D1_VALFRE*-1) D1_VALFRE, "+CRLF 
	cQuery	+= " 		(D1_VALIMP5*-1) D1_VALIMP5, (D1_VALIMP6*-1) D1_VALIMP6, (D1_DIFAL*-1) D1_DIFAL, " +CRLF
	cQuery	+= " 		(D1_ICMSCOM*-1) D1_ICMSCOM, (D1_VALICM*-1) D1_VALICM, (D1_CUSTO*-1) D1_CUSTO, " +CRLF
	cQuery	+= " 		D1_LOTECTL, D1_DTVALID, "+CRLF
	cQuery	+= " 		A1_COD, A1_LOJA, A1_NREDUZ, " +CRLF
	cQuery	+= " 		A3_COD, A3_NOME, " +CRLF
	cQuery	+= " 		B1_COD, B1_DESC, "+CRLF
	cQuery	+= " 		ADK_NOME, ADK_COD "+CRLF
	cQuery	+= " 		FROM "+RetSqlName("SD1")+" SD1 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD1.D1_COD "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD = SD1.D1_FORNECE "+CRLF
	cQuery	+= " AND SA1.A1_LOJA = SD1.D1_LOJA "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("ADK")+" ADK "+CRLF
	cQuery	+= " ON ADK.ADK_FILIAL= '"+xFilial("ADK")+"' "+CRLF
	cQuery	+= " AND ADK.ADK_COD BETWEEN '"+cCodSegDe+"' AND '"+cCodSegAte+"'  "+CRLF
	cQuery	+= " AND ADK.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA3")+" SA3 "+CRLF
	cQuery	+= " ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' "+CRLF
	cQuery	+= " AND SA3.A3_COD = SA1.A1_VEND "+CRLF
	cQuery	+= " AND SA3.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA7")+" SA7 "+CRLF
	cQuery	+= " ON SA7.A7_FILIAL = SA1.A1_FILIAL "+CRLF
	cQuery	+= " AND SA7.A7_CLIENTE = SA1.A1_COD "+CRLF
	cQuery	+= " AND SA7.A7_LOJA = SA1.A1_LOJA "+CRLF
	cQuery	+= " AND SA7.A7_PRODUTO = SD1.D1_COD "+CRLF
	cQuery	+= " AND SUBSTRING(SA7.A7_XSEGMEN,1,1) = SUBSTRING(ADK.ADK_COD, 6,1) "+CRLF
	cQuery	+= " AND SA7.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
	cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQuery	+= " AND SF4.F4_CODIGO = SD1.D1_TES "+CRLF
	cQuery	+= " AND SF4.F4_DUPLIC = 'S' "+CRLF
	cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "+CRLF 
	cQuery	+= " AND YEAR(SD1.D1_DTDIGIT) = "+Alltrim(Str(nAno))+" "+CRLF
	cQuery	+= " AND SD1.D1_TIPO = 'D' "+CRLF
	cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " ) DADOS "+CRLF
	cQuery	+= " GROUP BY MES, ADK_COD "+CRLF
	cQuery	+= " ORDER BY MES, ADK_COD "

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea(cArqSint)
	DbSetOrder(1)

	While (cArqTmp)->(!Eof())

		cMesAux := GetCMes((cArqTmp)->MES)

		If (cArqSint)->(DbSeek( PadR(Alltrim(Str(nAno)),4) + PadR(cMesAux,2) + (cArqTmp)->ADK_COD))

			RecLock(cArqSint,.F.)

			(cArqSint)->SIN_REAATU	:= (cArqTmp)->VALOR

			(cArqSint)->(MsUnLock())

		EndIf

		(cArqTmp)->(DbSkip())
	EndDo


	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf	


	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณAtuFatAnt	บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 	  บฑฑ
/ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสอออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo do valor realizado do ano anterior			  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuFatAnt(cCodSegDe, cCodSegAte, nAno)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cMesAux	:= ""
	Local cExcCfop := SuperGetMv('MV_EXCMARG',, '5551')

	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= "" 
	Default nAno		:= 0

	cQuery	:= " SELECT MES, ADK_COD, SUM(D2_QUANT) QUANTIDADE, SUM(D2_TOTAL+D2_VALIPI) VALOR FROM ( "+CRLF
	cQuery	+= " SELECT 'FAT' TP, D2_DOC, D2_SERIE, D2_EMISSAO, " +CRLF
	cQuery	+= " 		Month(D2_EMISSAO) MES, " +CRLF
	cQuery	+= " 		Year(D2_EMISSAO) ANO, " +CRLF
	cQuery	+= " 		D2_TIPO, D2_QUANT, D2_PRCVEN, "+CRLF 
	cQuery	+= " 		D2_TOTAL, D2_VALIPI, D2_VALFRE, " +CRLF
	cQuery	+= " 		D2_VALIMP5, D2_VALIMP6, D2_DIFAL, " +CRLF
	cQuery	+= " 		D2_ICMSCOM, D2_VALICM, D2_CUSTO1, " +CRLF
	cQuery	+= " 		D2_LOTECTL, D2_DTVALID, "+CRLF
	cQuery	+= " 		A1_COD, A1_LOJA, A1_NREDUZ, " +CRLF
	cQuery	+= " 		A3_COD, A3_NOME, " +CRLF
	cQuery	+= " 		B1_COD, B1_DESC, "+CRLF
	cQuery	+= " 		ADK_NOME, ADK_COD "+CRLF
	cQuery	+= " 		FROM "+RetSqlName("SD2")+" SD2 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD2.D2_COD "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD = SD2.D2_CLIENTE "+CRLF
	cQuery	+= " AND SA1.A1_LOJA = SD2.D2_LOJA "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("ADK")+" ADK "+CRLF
	cQuery	+= " ON ADK.ADK_FILIAL= '"+xFilial("ADK")+"' "+CRLF
	cQuery	+= " AND ADK.ADK_COD BETWEEN '"+cCodSegDe+"' AND '"+cCodSegAte+"'  "+CRLF
	cQuery	+= " AND ADK.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA3")+" SA3 "+CRLF
	cQuery	+= " ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' "+CRLF
	cQuery	+= " AND SA3.A3_COD = SA1.A1_VEND "+CRLF
	cQuery	+= " AND SA3.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA7")+" SA7 "+CRLF
	cQuery	+= " ON SA7.A7_FILIAL = SA1.A1_FILIAL "+CRLF
	cQuery	+= " AND SA7.A7_CLIENTE = SA1.A1_COD "+CRLF
	cQuery	+= " AND SA7.A7_LOJA = SA1.A1_LOJA "+CRLF
	cQuery	+= " AND SA7.A7_PRODUTO = SD2.D2_COD "+CRLF
	cQuery	+= " AND SUBSTRING(SA7.A7_XSEGMEN,1,1) = SUBSTRING(ADK.ADK_COD, 6,1) "+CRLF
	cQuery	+= " AND SA7.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF 
	cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQuery	+= " AND SF4.F4_CODIGO = SD2.D2_TES "+CRLF
	cQuery	+= " AND SF4.F4_DUPLIC = 'S' "+CRLF
	cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= " WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"' "+CRLF 
	cQuery	+= " AND YEAR(SD2.D2_EMISSAO) = "+Alltrim(Str(nAno-1))+" "+CRLF
	cQuery	+= " AND SD2.D2_TIPO != 'D' "+CRLF
	cQuery	+= " AND SD2.D2_CF NOT IN"+FormatIn(cExcCfop,";")+" "+CRLF	
	cQuery	+= " AND SD2.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " UNION ALL "+CRLF

	cQuery	+= " SELECT 'DEV' TP, D1_DOC, D1_SERIE, D1_DTDIGIT, "+CRLF 
	cQuery	+= " 		Month(D1_DTDIGIT) MES, " +CRLF
	cQuery	+= " 		Year(D1_EMISSAO) ANO, " +CRLF
	cQuery	+= " 		D1_TIPO, (D1_QUANT*-1) D1_QUANT, (D1_VUNIT*-1) D1_VUNIT, "+CRLF 
	cQuery	+= " 		(D1_TOTAL*-1) D1_TOTAL, (D1_VALIPI*-1) D1_VALIPI, (D1_VALFRE*-1) D1_VALFRE, "+CRLF 
	cQuery	+= " 		(D1_VALIMP5*-1) D1_VALIMP5, (D1_VALIMP6*-1) D1_VALIMP6, (D1_DIFAL*-1) D1_DIFAL, " +CRLF
	cQuery	+= " 		(D1_ICMSCOM*-1) D1_ICMSCOM, (D1_VALICM*-1) D1_VALICM, (D1_CUSTO*-1) D1_CUSTO, " +CRLF
	cQuery	+= " 		D1_LOTECTL, D1_DTVALID, "+CRLF
	cQuery	+= " 		A1_COD, A1_LOJA, A1_NREDUZ, " +CRLF
	cQuery	+= " 		A3_COD, A3_NOME, " +CRLF
	cQuery	+= " 		B1_COD, B1_DESC, "+CRLF
	cQuery	+= " 		ADK_NOME, ADK_COD "+CRLF
	cQuery	+= " 		FROM "+RetSqlName("SD1")+" SD1 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD1.D1_COD "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD = SD1.D1_FORNECE "+CRLF
	cQuery	+= " AND SA1.A1_LOJA = SD1.D1_LOJA "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("ADK")+" ADK "+CRLF
	cQuery	+= " ON ADK.ADK_FILIAL= '"+xFilial("ADK")+"' "+CRLF
	cQuery	+= " AND ADK.ADK_COD BETWEEN '"+cCodSegDe+"' AND '"+cCodSegAte+"'  "+CRLF
	cQuery	+= " AND ADK.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA3")+" SA3 "+CRLF
	cQuery	+= " ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' "+CRLF
	cQuery	+= " AND SA3.A3_COD = SA1.A1_VEND "+CRLF
	cQuery	+= " AND SA3.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA7")+" SA7 "+CRLF
	cQuery	+= " ON SA7.A7_FILIAL = SA1.A1_FILIAL "+CRLF
	cQuery	+= " AND SA7.A7_CLIENTE = SA1.A1_COD "+CRLF
	cQuery	+= " AND SA7.A7_LOJA = SA1.A1_LOJA "+CRLF
	cQuery	+= " AND SA7.A7_PRODUTO = SD1.D1_COD "+CRLF
	cQuery	+= " AND SUBSTRING(SA7.A7_XSEGMEN,1,1) = SUBSTRING(ADK.ADK_COD, 6,1) "+CRLF
	cQuery	+= " AND SA7.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
	cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQuery	+= " AND SF4.F4_CODIGO = SD1.D1_TES "+CRLF
	cQuery	+= " AND SF4.F4_DUPLIC = 'S' "+CRLF
	cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "+CRLF 
	cQuery	+= " AND YEAR(SD1.D1_DTDIGIT) = "+Alltrim(Str(nAno-1))+" "+CRLF
	cQuery	+= " AND SD1.D1_TIPO = 'D' "+CRLF
	cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " ) DADOS "+CRLF
	cQuery	+= " GROUP BY MES, ADK_COD "+CRLF
	cQuery	+= " ORDER BY MES, ADK_COD "

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea(cArqSint)
	DbSetOrder(1)

	While (cArqTmp)->(!Eof())

		cMesAux := GetCMes((cArqTmp)->MES)

		If (cArqSint)->(DbSeek( PadR(Alltrim(Str(nAno)),4) + PadR(cMesAux,2) + (cArqTmp)->ADK_COD ))

			RecLock(cArqSint,.F.)

			(cArqSint)->SIN_REAANT	:= (cArqTmp)->VALOR

			(cArqSint)->(MsUnLock())

		EndIf

		(cArqTmp)->(DbSkip())
	EndDo


	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf	


	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณAtuForecast	บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
/ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสอออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza o forecast										  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuForecast(cCodSegDe, cCodSegAte, nAno)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cMesAux	:= ""
	Local nX		:= 0
	Local nMeses	:= 12
	Local cCpoFc	:= ""
	Local nPrcAux	:= 0

	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= "" 
	Default nAno		:= 0

	cQuery	:= " SELECT A1_COD, A1_LOJA, A1_NOME, A1_TABELA, "+CRLF 
	cQuery	+= " 	B1_COD, B1_DESC, " +CRLF
	cQuery	+= " 	A3_COD, A3_NOME, ADK_COD, " +CRLF
	cQuery	+= " 	Z2_QTM01, "+CRLF
	cQuery	+= "  	Z2_QTM02, " +CRLF
	cQuery	+= " 	Z2_QTM03, "+CRLF
	cQuery	+= " 	Z2_QTM04, " +CRLF
	cQuery	+= " 	Z2_QTM05, " +CRLF
	cQuery	+= " 	Z2_QTM06, "+CRLF
	cQuery	+= " 	Z2_QTM07, "+CRLF
	cQuery	+= " 	Z2_QTM08, "+CRLF
	cQuery	+= " 	Z2_QTM09, "+CRLF
	cQuery	+= " 	Z2_QTM10, "+CRLF
	cQuery	+= " 	Z2_QTM11, "+CRLF
	cQuery	+= " 	Z2_QTM12 "+CRLF
	cQuery	+= " 	FROM "+RetSqlName("SZ2")+" SZ2 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD = SZ2.Z2_CLIENTE "+CRLF
	cQuery	+= " AND SA1.A1_LOJA = SZ2.Z2_LOJA "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA3")+" SA3 "+CRLF
	cQuery	+= " ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' "+CRLF
	cQuery	+= " AND SA3.A3_COD = SA1.A1_VEND "+CRLF
	cQuery	+= " AND SA3.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("ADK")+" ADK "+CRLF
	cQuery	+= " ON ADK.ADK_FILIAL= '"+xFilial("ADK")+"' "+CRLF
	cQuery	+= " AND ADK.ADK_COD BETWEEN '"+cCodSegDe+"' AND '"+cCodSegAte+"'  "+CRLF
	cQuery	+= " AND ADK.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA7")+" SA7 "+CRLF
	cQuery	+= " ON SA7.A7_FILIAL = SA1.A1_FILIAL "+CRLF
	cQuery	+= " AND SA7.A7_CLIENTE = SA1.A1_COD "+CRLF
	cQuery	+= " AND SA7.A7_LOJA = SA1.A1_LOJA "+CRLF
	cQuery	+= " AND SA7.A7_PRODUTO = SZ2.Z2_PRODUTO "+CRLF
	cQuery	+= " AND SUBSTRING(SA7.A7_XSEGMEN,1,1) = SUBSTRING(ADK.ADK_COD, 6,1) "+CRLF
	cQuery	+= " AND SA7.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SZ2.Z2_PRODUTO "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SZ2.Z2_FILIAL = '"+xFilial("SZ2")+"' "+CRLF 
	cQuery	+= " AND SZ2.Z2_ANO = '"+Alltrim(Str(nAno))+"' "+CRLF
	cQuery	+= " AND SZ2.Z2_TOPICO = 'F' "+CRLF
	cQuery	+= " AND (SZ2.Z2_QTM01 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM02 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM03 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM04 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM05 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM06 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM07 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM08 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM09 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM10 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM11 " +CRLF
	cQuery	+= " 		+ SZ2.Z2_QTM12) > 0 "+CRLF
	cQuery	+= " AND SZ2.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea(cArqSint)
	DbSetOrder(1)

	While (cArqTmp)->(!Eof())

		//Preenche o forecast para cada mes na tabela temporaria
		For nX := 1 To nMeses

			nPrcAux	:= U_RCRME007((cArqTmp)->A1_COD,(cArqTmp)->A1_LOJA,(cArqTmp)->B1_COD,Alltrim(Str(nAno)), "2")
			cMesAux := GetCMes(nX)
			cCpoFc	:= GetCpoFc(nX)

			If (cArqSint)->(DbSeek( PadR(Alltrim(Str(nAno)),4) + PadR(cMesAux,2) +(cArqTmp)->ADK_COD ))
				RecLock(cArqSint,.F.)
				//(cArqSint)->SIN_FORECA	+= (cArqTmp)->&(cCpoFc)*U_RCRME019((cArqTmp)->A1_COD,(cArqTmp)->A1_LOJA,(cArqTmp)->B1_COD,Alltrim(Str(nAno)))
				(cArqSint)->SIN_FORECA	:= (cArqSint)->SIN_FORECA + ((cArqTmp)->&(cCpoFc)*nPrcAux)
				(cArqSint)->(MsUnLock())
			EndIf
		Next

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณAtuBudget		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo do budget na tabela temporaria				  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuBudget(cCodSegDe, cCodSegAte, nAno)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cMesAux	:= ""
	Local nX		:= 0
	Local nMeses	:= 12
	Local cCpoBd	:= ""

	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= "" 
	Default nAno		:= 0

	cQuery	:= " SELECT "+CRLF  
	cQuery	+= " ADK_COD, "+CRLF
	cQuery	+= " SUM(Z2_QTM01*Z2_PRECO01) Z2_PRECO01, "+CRLF 
	cQuery	+= " SUM(Z2_QTM02*Z2_PRECO02) Z2_PRECO02, " +CRLF
	cQuery	+= " SUM(Z2_QTM03*Z2_PRECO03) Z2_PRECO03, " +CRLF
	cQuery	+= " SUM(Z2_QTM04*Z2_PRECO04) Z2_PRECO04, " +CRLF
	cQuery	+= " SUM(Z2_QTM05*Z2_PRECO05) Z2_PRECO05, " +CRLF
	cQuery	+= " SUM(Z2_QTM06*Z2_PRECO06) Z2_PRECO06, " +CRLF
	cQuery	+= " SUM(Z2_QTM07*Z2_PRECO07) Z2_PRECO07, " +CRLF
	cQuery	+= " SUM(Z2_QTM08*Z2_PRECO08) Z2_PRECO08, " +CRLF
	cQuery	+= " SUM(Z2_QTM09*Z2_PRECO09) Z2_PRECO09, " +CRLF
	cQuery	+= " SUM(Z2_QTM10*Z2_PRECO10) Z2_PRECO10, " +CRLF
	cQuery	+= " SUM(Z2_QTM11*Z2_PRECO11) Z2_PRECO11, " +CRLF
	cQuery	+= " SUM(Z2_QTM12*Z2_PRECO12) Z2_PRECO12 "+CRLF
	cQuery	+= " FROM ( "+CRLF
	cQuery	+= " SELECT A1_COD, A1_LOJA, A1_NOME, A1_TABELA, ADK_COD, "+CRLF 
	cQuery	+= " B1_COD, B1_DESC, " +CRLF
	cQuery	+= " A3_COD, A3_NOME, " +CRLF
	cQuery	+= " Z2_QTM01, "+CRLF
	cQuery	+= " Z2_QTM02, " +CRLF
	cQuery	+= " Z2_QTM03, "+CRLF
	cQuery	+= " Z2_QTM04, " +CRLF
	cQuery	+= " Z2_QTM05, " +CRLF
	cQuery	+= " Z2_QTM06, "+CRLF
	cQuery	+= " Z2_QTM07, "+CRLF
	cQuery	+= " Z2_QTM08, "+CRLF
	cQuery	+= " Z2_QTM09, "+CRLF
	cQuery	+= " Z2_QTM10, "+CRLF
	cQuery	+= " Z2_QTM11, "+CRLF
	cQuery	+= " Z2_QTM12, " +CRLF
	cQuery	+= " Z2_PRECO01, "+CRLF
	cQuery	+= " Z2_PRECO02, "+CRLF
	cQuery	+= " Z2_PRECO03, "+CRLF
	cQuery	+= " Z2_PRECO04, "+CRLF
	cQuery	+= " Z2_PRECO05, "+CRLF
	cQuery	+= " Z2_PRECO06, "+CRLF
	cQuery	+= " Z2_PRECO07, "+CRLF
	cQuery	+= " Z2_PRECO08, "+CRLF
	cQuery	+= " Z2_PRECO09, "+CRLF
	cQuery	+= " Z2_PRECO10, "+CRLF
	cQuery	+= " Z2_PRECO11, "+CRLF
	cQuery	+= " Z2_PRECO12 "+CRLF
	cQuery	+= " FROM "+RetSqlName("SZ2")+" SZ2 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD = SZ2.Z2_CLIENTE "+CRLF
	cQuery	+= " AND SA1.A1_LOJA = SZ2.Z2_LOJA "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA3")+" SA3 "+CRLF
	cQuery	+= " ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' "+CRLF
	cQuery	+= " AND SA3.A3_COD = SA1.A1_VEND "+CRLF
	cQuery	+= " AND SA3.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("ADK")+" ADK "+CRLF
	cQuery	+= " ON ADK.ADK_FILIAL= '"+xFilial("ADK")+"' "+CRLF
	cQuery	+= " AND ADK.ADK_COD BETWEEN '"+cCodSegDe+"' AND '"+cCodSegAte+"'  "+CRLF
	cQuery	+= " AND ADK.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA7")+" SA7 "+CRLF
	cQuery	+= " ON SA7.A7_FILIAL = SA1.A1_FILIAL "+CRLF
	cQuery	+= " AND SA7.A7_CLIENTE = SA1.A1_COD "+CRLF
	cQuery	+= " AND SA7.A7_LOJA = SA1.A1_LOJA "+CRLF
	cQuery	+= " AND SA7.A7_PRODUTO = SZ2.Z2_PRODUTO "+CRLF
	cQuery	+= " AND SUBSTRING(SA7.A7_XSEGMEN,1,1) = SUBSTRING(ADK.ADK_COD, 6,1) "+CRLF
	cQuery	+= " AND SA7.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SZ2.Z2_PRODUTO "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SZ2.Z2_FILIAL = '"+xFilial("SZ2")+"' "+CRLF 
	cQuery	+= " AND SZ2.Z2_ANO = '"+Alltrim(Str(nAno))+"' "+CRLF
	cQuery	+= " AND SZ2.Z2_TOPICO = 'B' "+CRLF
	cQuery	+= " AND (SZ2.Z2_QTM01 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM02 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM03 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM04 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM05 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM06 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM07 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM08 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM09 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM10 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM11 " +CRLF
	cQuery	+= " + SZ2.Z2_QTM12) > 0 "+CRLF
	cQuery	+= " AND SZ2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " 	) DADOS "+CRLF
	cQuery	+= " GROUP BY ADK_COD "

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea(cArqSint)
	DbSetOrder(1)

	While (cArqTmp)->(!Eof())

		For nX := 1 To nMeses
			cMesAux := GetCMes(nX)
			cCpoBd	:= GetCpoBd(nX)

			If (cArqSint)->(DbSeek( PadR(Alltrim(Str(nAno)),4)+ PadR(cMesAux,2) +(cArqTmp)->ADK_COD ))
				RecLock(cArqSint,.F.)
				(cArqSint)->SIN_BUDGET	+= (cArqTmp)->&(cCpoBd)
				(cArqSint)->(MsUnLock())
			EndIf
		Next

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณAtuRealFc		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo do realizado | forecast						  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuRealFc(cCodSegDe, cCodSegAte, nAno)

	Local aArea		:= GetArea()
	Local nMesAtu	:= Month(MsDate())
	Local nMesReal	:= nMesAtu-1 
	Local nX		:= 0
	Local nMeses	:= 12
	Local cMesAux	:= ""
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= "" 
	Default nAno		:= 0

	cQuery	:= "SELECT * FROM "+RetSqlName("ADK")+" ADK "+CRLF
	cQuery	+= " WHERE ADK.ADK_FILIAL = '"+xFilial("ADK")+"' "+CRLF
	cQuery	+= " AND ADK.ADK_COD BETWEEN '"+cCodSegDe+"' AND '"+cCodSegAte+"' "+CRLF 
	cQuery	+= " AND ADK.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea(cArqSint)
	DbSetOrder(1)

	While (cArqTmp)->(!Eof())
	
		For nX := 1  To nMeses

			cMesAux := GetCMes(nX)

			If (cArqSint)->(DbSeek( PadR(Alltrim(Str(nAno)),4) + PadR(cMesAux,2) + (cArqTmp)->ADK_COD ))
				RecLock(cArqSint,.F.)
				If nX <= nMesReal
					(cArqSint)->SIN_REAFC	:= (cArqSint)->SIN_REAATU
				Else
					(cArqSint)->SIN_REAFC	:= (cArqSint)->SIN_FORECA
				EndIf
				(cArqSint)->(MsUnLock())
			EndIf
		
		Next
		
		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0 
		(cArqTmp)->(DbCloseArea())
	EndIf
	
	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณAtuRealPv		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo do realizado | pedido em carteira (Aberto)	  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuRealPv(cCodSegDe, cCodSegAte, nAno)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()	
	Local cMesAux	:= ""
	
	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= ""
	Default nAno		:= 0

	cQuery	:= " SELECT MES, ANO, ADK_COD, SUM(C6_QTDVEN) C6_QTDVEN, SUM(C6_VALOR) C6_VALOR FROM( "+CRLF
	cQuery	+= " SELECT MONTH(C5_FECENT) MES, YEAR(C5_FECENT) ANO, "+CRLF
	cQuery	+= " C5_NUM, C5_MOEDA, C5_TXMOEDA, C6_QTDVEN, "+CRLF
	//cQuery	+= " (CASE WHEN C5_MOEDA = 1 THEN C6_VALOR ELSE C6_VALOR*C5_TXMOEDA END) C6_VALOR, "+CRLF
	cQuery  += " (CASE WHEN C5_MOEDA = 1 THEN C6_VALOR ELSE C6_VALOR * CASE WHEN C5_TXREF = 0 AND M2_MOEDA2 > 0 THEN M2_MOEDA2 ELSE C5_TXMOEDA END END) C6_VALOR,  "+CRLF 
	cQuery	+= " ADK_COD FROM "+RetSqlName("SC5")+" SC5 "+CRLF

	// cQuery += " INNER JOIN  "+RetSqlName("SM2")+" M2 ON M2_DATA = convert(varchar,DATEADD(DAY, -1, C5_EMISSAO),112) AND M2.D_E_L_E_T_ = '' "+CRLF 
	cQuery += " INNER JOIN  "+RetSqlName("SM2")+" M2 ON M2_DATA = convert(varchar,GETDATE(),112) AND M2.D_E_L_E_T_ = '' "+CRLF 

	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD = SC5.C5_CLIENTE "+CRLF
	cQuery	+= " AND SA1.A1_LOJA = SC5.C5_LOJACLI "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SC6")+" SC6 "+CRLF
	cQuery	+= " ON SC6.C6_FILIAL = SC5.C5_FILIAL "+CRLF
	cQuery	+= " AND SC6.C6_NUM = SC5.C5_NUM " +CRLF
	cQuery	+= " AND SC6.C6_NOTA = '' "+CRLF
	cQuery	+= " AND SC6.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SC6.C6_PRODUTO "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("ADK")+" ADK "+CRLF
	cQuery	+= " ON ADK.ADK_FILIAL= '"+xFilial("ADK")+"' "+CRLF
	cQuery	+= " AND ADK.ADK_COD BETWEEN '"+cCodSegDe+"' AND '"+cCodSegAte+"'  "+CRLF
	cQuery	+= " AND ADK.D_E_L_E_T_ = ' ' "

	cQuery	+= " INNER JOIN "+RetSqlName("SA3")+" SA3 "+CRLF
	cQuery	+= " ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' "+CRLF
	cQuery	+= " AND SA3.A3_COD = SA1.A1_VEND "+CRLF
	cQuery	+= " AND SA3.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA7")+" SA7 "+CRLF
	cQuery	+= " ON SA7.A7_FILIAL = SA1.A1_FILIAL "+CRLF
	cQuery	+= " AND SA7.A7_CLIENTE = SA1.A1_COD "+CRLF
	cQuery	+= " AND SA7.A7_LOJA = SA1.A1_LOJA "+CRLF
	cQuery	+= " AND SA7.A7_PRODUTO = SC6.C6_PRODUTO "+CRLF
	cQuery	+= " AND SUBSTRING(SA7.A7_XSEGMEN,1,1) = SUBSTRING(ADK.ADK_COD, 6,1) "+CRLF
	cQuery	+= " AND SA7.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
	cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQuery	+= " AND SF4.F4_CODIGO = SC6.C6_TES "+CRLF
	cQuery	+= " AND SF4.F4_DUPLIC = 'S' "+CRLF
	cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= " WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"' "+CRLF 
	cQuery	+= " AND SC5.C5_NOTA = '' "+CRLF
	cQuery	+= " AND YEAR(SC5.C5_FECENT) = '"+Alltrim(Str(nAno))+"' "+CRLF
	cQuery	+= " AND SC5.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " ) DADOS "+CRLF
	cQuery	+= " GROUP BY MES, ANO, ADK_COD "+CRLF
	cQuery	+= " ORDER BY ANO, MES, ADK_COD "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)
	
	DbSelectArea(cArqSint)
	DbSetOrder(1)
	
	While (cArqTmp)->(!Eof())
		
		cMesAux := GetCMes((cArqTmp)->MES)

		If (cArqSint)->(DbSeek( PadR(Alltrim(Str(nAno)),4) + PadR(cMesAux,2) + (cArqTmp)->ADK_COD ))

			RecLock(cArqSint,.F.)
			(cArqSint)->SIN_REAPVA	:= (cArqSint)->SIN_REAATU+(cArqTmp)->C6_VALOR
			(cArqSint)->(MsUnLock())

		EndIf

		(cArqTmp)->(DbSkip())
	EndDo


	(cArqSint)->(DbGoTop())
	While (cArqSint)->(!Eof())

		If (cArqSint)->SIN_REAPVA == 0
			RecLock(cArqSint,.F.)
			(cArqSint)->SIN_REAPVA	:= (cArqSint)->SIN_REAATU
			(cArqSint)->(MsUnLock())
		Endif

		(cArqSint)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetCMes		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
/ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสอออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o mes												  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCMes(nMes)

	Local aArea	:= GetArea()
	Local aMes	:= {"01","02","03","04","05","06","07","08","09","10","11","12"}
	Local cRet	:= ""

	Default nMes := 1

	cRet := aMes[nMes]

	RestArea(aArea)
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetDMes		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
/ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสอออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a descri็ใo do mสS								  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDMes(nMes)

	Local aArea	:= GetArea()
	Local aMes	:= {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
	Local cRet	:= ""

	Default nMes := 1

	cRet := aMes[nMes]

	RestArea(aArea)
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetCpoFc		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
/ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสอออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o campo referente o m๊s do forecast				  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCpoFc(nMes)

	Local aCpos	:= {"Z2_QTM01",;
	"Z2_QTM02",;
	"Z2_QTM03",;
	"Z2_QTM04",;
	"Z2_QTM05",;
	"Z2_QTM06",;
	"Z2_QTM07",;
	"Z2_QTM08",;
	"Z2_QTM09",;
	"Z2_QTM10",;
	"Z2_QTM11",;
	"Z2_QTM12"}
	Local cRet	:= ""

	Default nMes := 1

	cRet := aCpos[nMes]
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetCpoBd		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
/ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสอออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o campo referente o m๊s do budget					  บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCpoBd(nMes)

	Local aCpos	:= {"Z2_PRECO01",;
	"Z2_PRECO02",;
	"Z2_PRECO03",;
	"Z2_PRECO04",;
	"Z2_PRECO05",;
	"Z2_PRECO06",;
	"Z2_PRECO07",;
	"Z2_PRECO08",;
	"Z2_PRECO09",;
	"Z2_PRECO10",;
	"Z2_PRECO11",;
	"Z2_PRECO12"}
	Local cRet	:= ""

	Default nMes := 1

	cRet := aCpos[nMes]
Return cRet
