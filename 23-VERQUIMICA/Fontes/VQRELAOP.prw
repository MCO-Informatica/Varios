#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

user function VQRELAOP()
Local oReport
Private cPermis := GetMv("VQ_RELVEN")
Private cDesc 	:= ""
Private nTotQtdA  := 0 
Private nTotVlrA := 0
Private nTotQtdO := 0
Private nTotVlrO := 0
Private nTotQtdP := 0
Private nTotVlrP := 0

If Upper(UsrRetName(Retcodusr())) $ cPermis
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MsgInfo("Relatório exclusivo para supervisores!","VQ_RELVEN - Dados CallCenter")
EndIf

Return
Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New("VQRELAOP", "REL. DADOS CALLCENTER", "VQRELAOP", {|oReport| ReportPrint(oReport, "REL. DADOS CALLCENTER")}, "RELATÓRIO COM DADOS CALLCENTER") 

If AllTrim(FUNNAME()) == "VQRELAOP"
	pergunte("VQRELAOP",.F.)
EndIf

oReport:SetLandscape()

oSection1 := TRSection():New(oReport, "Dados TeleVendas","", ) 

TRCell():New(oSection1,"TXTCODVEN"  ,, "CÓDIGO"			,"@!"							,8,	    ,)
TRCell():New(oSection1,"TXTVENDED"  ,, "VENDEDOR" 		,"@!"							,30,	,)
TRCell():New(oSection1,"QTDEATEN" 	,, "ATENDIMENTOS"	,"@E 999999"					,6,		,)
TRCell():New(oSection1,"VLRATEN" 	,, "TOTAL R$"		,"@E 999,999,999,999.99"		,15,	,)
TRCell():New(oSection1,"QTDEORCA" 	,, "ORÇAMENTOS"		,"@E 999999"					,6,		,)
TRCell():New(oSection1,"VLRORCA" 	,, "TOTAL R$"		,"@E 999,999,999,999.99"		,15,	,)
TRCell():New(oSection1,"QTDEPEDI" 	,, "PEDIDOS"		,"@E 999999"					,6,		,)
TRCell():New(oSection1,"VLRPEDI" 	,, "TOTAL R$"		,"@E 999,999,999,999.99"		,15,	,)

oSection1:SetHeaderSection(.T.)	//Nao imprime o cabeçalho da secao 
	
oSection2 := TRSection():New(oReport, "Totais","", ) 
TRCell():New(oSection2,"TXTTOTAL"  ,, "" 		,"@!"							,44,	, {||cDesc})
TRCell():New(oSection2,"QTDEATEN" 	,, ""				,"@E 999999"					,6,	,{||nTotQtdA} )
TRCell():New(oSection2,"VLRATEN" 	,, ""				,"@E 999,999,999,999.99"		,16,,{||nTotVlrA})
TRCell():New(oSection2,"QTDEORCA" 	,, ""				,"@E 999999"					,10,,{||nTotQtdO} )
TRCell():New(oSection2,"VLRORCA" 	,, ""				,"@E 999,999,999,999.99"		,15,,{||nTotVlrO})
TRCell():New(oSection2,"QTDEPEDI" 	,, ""				,"@E 999999"					,7,	,{||nTotQtdP})
TRCell():New(oSection2,"VLRPEDI" 	,, ""				,"@E 999,999,999,999.99"		,15,,{||nTotVlrP})

oSection2:SetHeaderSection(.T.)	//Nao imprime o cabeçalho da secao
oSection2:SetLinesBefore(2)

oReport:nFontBody := 8

Return oReport


Static Function ReportPrint(oReport,cTitulo)
Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(2)
Local aDados	:= {}
Local cAliasTrb := GetNextAlias()
Local cQuery := ""

cQuery := " SELECT "
cQuery += " 	SUA.UA_VEND AS VENDEDOR, "
cQuery += " 	SA3.A3_NOME, "
cQuery += " 	COUNT(CASE WHEN SUA.UA_OPER = '3' THEN SUA.UA_NUM ELSE '' END ) AS QTDE_ATEN, "	
cQuery += " 	0 AS VALOR_ATEN, "
cQuery += " 	COUNT(CASE WHEN SUA.UA_OPER = '2' THEN SUA.UA_NUM ELSE '' END) AS QTDE_ORC, "
cQuery += " 	SUM( CASE WHEN SUA.UA_OPER = '2' THEN CASE WHEN SUA.UA_MOEDA = '2' THEN SUA.UA_VALBRUT * SUA.UA_VQ_TXDO ELSE SUA.UA_VALBRUT END ELSE 0 END) AS VALOR_ORC,"
cQuery += " 	COUNT(CASE WHEN SUA.UA_OPER = '1' AND SUA.UA_NUMSC5 <> '      '  AND SC5.D_E_L_E_T_ <> '*' AND (C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') THEN SUA.UA_NUM ELSE '' END) QTDE_PEDI, "
cQuery += " 	SUM(CASE WHEN SUA.UA_OPER = '1' AND SUA.UA_NUMSC5 <> '      ' AND SC5.D_E_L_E_T_ <> '*' AND (C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') THEN CASE WHEN SUA.UA_MOEDA = '2' THEN SUA.UA_VALBRUT * SUA.UA_VQ_TXDO ELSE SUA.UA_VALBRUT END ELSE 0 END) VALOR_PEDI "
cQuery += " FROM SUA010 SUA "	
cQuery += " 	LEFT JOIN SC5010 SC5 ON (SC5.D_E_L_E_T_ <> '*' AND SUA.UA_NUMSC5 = SC5.C5_NUM) "
cQuery += " 	INNER JOIN SA3010 SA3 ON (SA3.D_E_L_E_T_ <> '*' AND SA3.A3_COD = SUA.UA_VEND) "
cQuery += " 	WHERE " 
cQuery += " 		SUA.D_E_L_E_T_ <> '*' "
cQuery += " 		AND SUA.UA_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery += "			AND SUA.UA_VEND BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += " GROUP BY " 
cQuery += " 	SUA.UA_VEND, "
cQuery += " 	SA3.A3_NOME "
cQuery += " ORDER BY " 
cQuery += " 	SA3.A3_NOME, "
cQuery += " 	SUA.UA_VEND "

If Select(cAliasTrb) > 0
	( cAliasTrb )->( DbCloseArea() )
EndIf

TcQuery cQuery New Alias ( cAliasTrb )

oSection1:Init()

While !( cAliasTrb )->( Eof() )    
 		oSection1:Cell("TXTCODVEN"):SetValue(( cAliasTrb )->VENDEDOR) 
 		oSection1:Cell("TXTVENDED"):SetValue(( cAliasTrb )->A3_NOME)
 		oSection1:Cell("QTDEATEN"):SetValue(( cAliasTrb )->QTDE_ATEN)
 		oSection1:Cell("VLRATEN"):SetValue(( cAliasTrb )->VALOR_ATEN)
 		oSection1:Cell("QTDEORCA"):SetValue(( cAliasTrb )->QTDE_ORC)
 		oSection1:Cell("VLRORCA"):SetValue(( cAliasTrb )->VALOR_ORC)
 		oSection1:Cell("QTDEPEDI"):SetValue(( cAliasTrb )->QTDE_PEDI)
 		oSection1:Cell("VLRPEDI"):SetValue(( cAliasTrb )->VALOR_PEDI)
 
 		aadd(aDados, {( cAliasTrb )->QTDE_ATEN,( cAliasTrb )->VALOR_ATEN,( cAliasTrb )->QTDE_ORC,( cAliasTrb )->VALOR_ORC,( cAliasTrb )->QTDE_PEDI,( cAliasTrb )->VALOR_PEDI})
 		oSection1:PrintLine()
 		
	( cAliasTrb )->( DbSkip() )
EndDo
oSection1:Finish()

For nX := 1 To Len(aDados)
	nTotQtdA := nTotQtdA + aDados[nX][1]
	nTotVlrA := nTotVlrA + aDados[nX][2]
	nTotQtdO := nTotQtdO + aDados[nX][3]
	nTotVlrO := nTotVlrO + aDados[nX][4]
	nTotQtdP := nTotQtdP + aDados[nX][5]
	nTotVlrP := nTotVlrP + aDados[nX][6]
Next nX

oSection2:Init()
oSection2:PrintLine()
oSection2:Finish()
Return
