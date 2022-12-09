#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A320CUSTD ºAutor  ³Rodrigo Romao   º Data ³  12/06/13       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para validar se ira atualizar o custo do   º±±
±±º          ³produto, caso o mesmo tenha Nota de Importacao.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - Especifico Ancora.                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A320CUSTD()
Local nValor1   := PARAMIXB[1]
Local nValor2   := PARAMIXB[2]
Local cQuery    := ""
Local nCustTot	:= 0
Private nQtdOri	:= 0
Private cNfOrig	:= ""
Private cSerOri := ""
Private cEof	:= chr(13)+chr(10)

cQuery := "SELECT SF8.*"+cEof
cQuery += " FROM "+RetSqlTab("SD1")+" "+cEof
cQuery += " INNER JOIN "+RetSqlTab("SF8")+" ON"+cEof
cQuery += " 	SF8.F8_FILIAL 	= '"+xFilial("SF8")+"' AND "+cEof
cQuery += " 	SF8.F8_NFORIG 	= SD1.D1_DOC AND"+cEof
cQuery += " 	SF8.F8_SERORIG 	= SD1.D1_SERIE AND"+cEof
cQuery += " 	SF8.F8_FORNECE 	= SD1.D1_FORNECE AND"+cEof
cQuery += " 	SF8.F8_LOJA 	= SD1.D1_LOJA AND"+cEof
cQuery += " 	SF8.D_E_L_E_T_ 	= ''"  +cEof
cQuery += " WHERE"+cEof
cQuery += " 	SD1.D1_FILIAL 	= '"+xFilial("SD1")+"' AND "+cEof
cQuery += " 	SD1.D1_COD 		= '"+SB1->B1_COD+"' AND"+cEof
cQuery += " 	SD1.D1_DTDIGIT >= '"+dtos(SB1->B1_DATREF)+"' AND"+cEof
cQuery += " 	SD1.D_E_L_E_T_ 	= ''"+cEof
cQuery += " ORDER BY SF8.F8_NFORIG"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYTRB1", .T., .T.)

DbSelectArea("QRYTRB1")

nQtdOri 	:= 0
nCustTot	:= 0
QRYTRB1->(DbGoTop())
While !QRYTRB1->(Eof())
	
	if nQtdOri == 0
		nQtdOri := retQtdNf(QRYTRB1->F8_NFORIG,QRYTRB1->F8_SERORIG,QRYTRB1->F8_FORNECE,QRYTRB1->F8_LOJA)
	EndIf
	
	nCustTot += retCusto(QRYTRB1->F8_NFDIFRE,QRYTRB1->F8_SEDIFRE,QRYTRB1->F8_TRANSP,QRYTRB1->F8_LOJTRAN)
	
	QRYTRB1->(DbSkip())
End

QRYTRB1->(DbCloseArea())

nCustTot += retCustoComplemento()
nCustoFinal := (nCustTot/nQtdOri)

if nCustoFinal > 0
	//Alert(SB1->B1_COD+"  -  "+cValToChar(nCustoFinal+SB1->B1_CUSTD))
	
	RecLock("SB1",.F.)
		SB1->B1_CUSTD := nCustoFinal+SB1->B1_CUSTD
	SB1->(MsUnLock())
EndIf

Return

Static Function retCusto(cF8NFDIFRE,cF8SERFRE,cF8FORNECE,cLoja)
Local nRet := 0
Local cQuery := ""

cQuery := "SELECT SUM(D1_CUSTO) AS D1_CUSTO FROM "+RetSqlTab("SD1")+" "
cQuery += " INNER JOIN "+RetSqlTab("SF4")+" ON"
cQuery += " 	SF4.F4_FILIAL 	= '"+xFilial("SF4")+"' AND
cQuery += " 	SF4.F4_CODIGO 	= SD1.D1_TES AND "
cQuery += " 	SF4.D_E_L_E_T_ = ''"
cQuery += " WHERE SD1.D1_DOC 	= '"+cF8NFDIFRE+"' AND"
cQuery += "  SD1.D1_SERIE 		= '"+cF8SERFRE+"' AND"
cQuery += "  SD1.D1_FORNECE 	= '"+cF8FORNECE+"' AND"
cQuery += "  SD1.D1_LOJA 		= '"+cLoja+"' AND"
cQuery += "  SD1.D1_COD 		= '"+SB1->B1_COD+"' AND"
cQuery += "  SD1.D_E_L_E_T_ 	= '' AND "
cQuery += "  SF4.F4_ESTOQUE 	= 'S'"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qTmp", .T., .T.)

DbSelectArea("qTmp")
If !qTmp->(Eof())
	nRet := qTmp->D1_CUSTO
EndIf
qTmp->(DbCloseArea())

Return(nRet)

Static Function retQtdNf(cF8NFDIFRE,cF8SERFRE,cF8FORNECE,cLoja)
Local nRet 		:= 0
Local cQuery 	:= ""

cQuery := "SELECT D1_QUANT FROM "+RetSqlTab("SD1")+" "
cQuery += " WHERE SD1.D1_DOC 	= '"+cF8NFDIFRE+"' AND"
cQuery += "  SD1.D1_SERIE 		= '"+cF8SERFRE+"' AND"
cQuery += "  SD1.D1_FORNECE 	= '"+cF8FORNECE+"' AND"
cQuery += "  SD1.D1_LOJA 		= '"+cLoja+"' AND"
cQuery += "  SD1.D1_COD 		= '"+SB1->B1_COD+"' AND "
cQuery += "  SD1.D_E_L_E_T_ 	= ''"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qTmp", .T., .T.)

DbSelectArea("qTmp")
If !qTmp->(Eof())
	nRet := qTmp->D1_QUANT
EndIf
qTmp->(DbCloseArea())

Return(nRet)

Static Function retCustoComplemento()
Local cQuery := ""
Local nRet	 := 0
Local cNfOrig	:= ""
Local cSerOri 	:= ""

cQuery := "SELECT SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_CUSTO,SD1.D1_QUANT"
cQuery += "FROM "+RetSqlTab("SD1")+" "
cQuery += "WHERE SD1.D_E_L_E_T_ = ''"
cQuery += "AND SD1.D1_DTDIGIT >=  '"+DtoS(SB1->B1_DATREF)+"'"
cQuery += "AND SD1.D1_COD 		= '"+SB1->B1_COD+"'"
cQuery += "AND SD1.D1_QUANT 	> 0"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qTmp", .T., .T.)

DbSelectArea("qTmp")
If !qTmp->(Eof())
	cNfOrig	:= qTmp->D1_DOC
	cSerOri := qTmp->D1_SERIE
	
	if nQtdOri == 0
		nQtdOri := qTmp->D1_QUANT
	EndIf
	
End
qTmp->(DbCloseArea())

If !Empty(cNfOrig) .and. !Empty(cSerOri)
	cQuery := "SELECT SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_CUSTO"
	cQuery += "FROM "+RetSqlTab("SD1")+" "
	cQuery += "INNER JOIN "+RetSqlTab("SF4")+" ON SF4.F4_CODIGO = SD1.D1_TES"
	cQuery += "WHERE SD1.D_E_L_E_T_ = ''"
	cQuery += "AND SD1.D1_DTDIGIT >=  '"+DtoS(SB1->B1_DATREF)+"'"
	cQuery += "AND SD1.D1_DOC NOT IN ("
	cQuery += "            SELECT SF8.F8_NFDIFRE FROM "+RetSqlTab("SF8")+" WHERE SF8.D_E_L_E_T_ = '' "
	cQuery += "            		AND SF8.F8_NFDIFRE = SD1.D1_DOC
	cQuery += "            		AND SF8.F8_SEDIFRE = SD1.D1_SERIE
	cQuery += "            		AND SF8.F8_TRANSP = SD1.D1_FORNECE
	cQuery += "            		AND SF8.F8_LOJTRAN = SD1.D1_LOJA)"
	cQuery += "AND SD1.D1_COD 		= '"+SB1->B1_COD+"'"
	cQuery += "AND SF4.F4_ESTOQUE 	= 'S'"
	cQuery += "AND SD1.D1_TIPO 		= 'C'"
	cQuery += "AND SD1.D1_NFORI 	= '"+cNfOrig+"'"
	cQuery += "AND SD1.D1_SERIORI 	= '"+cSerOri+"'"
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "qTmp", .T., .T.)
	
	DbSelectArea("qTmp")
	While !qTmp->(Eof())
		nRet += qTmp->D1_CUSTO
		qTmp->(DbSkip())
	End
	qTmp->(DbCloseArea())
EndIf
Return(nRet)