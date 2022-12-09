#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³PZCVLP02	ºAutor  ³Microsiga		     º Data ³  14/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a conta contabil para LP 597					      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PZCVLP02(nOpc, cDocSE5, cPrefixPa, cNumPa)

Local aArea		:= GetArea()

Default nOpc	:= 1
Default cDocSE5		:= "" 
Default cPrefixPa	:= "" 
Default cNumPa		:= ""

If nOpc == 1 //Retorna a conta contabil debito
	cRet := GetCtaDeb(cDocSE5)
ElseIf nOpc == 2 
	cRet := GetHistLp(cDocSE5, cPrefixPa, cNumPa)
EndIf

RestArea(aArea)	
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetCtaDeb	ºAutor  ³Microsiga		     º Data ³  14/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a conta contabil debito para LP 597			      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetCtaDeb(cDocSE5)
Local aArea		:= GetArea()
Local cRet		:= ""
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()

Default cDocSE5	:= ""

cQuery	:= " SELECT A2_CONTA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA FROM "+RetSqlName("SE5")+" SE5 "+CRLF

cQuery	+= " INNER JOIN "+RetSqlName("SA2")+" SA2 "+CRLF
cQuery	+= " ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' " +CRLF
cQuery	+= " AND SA2.A2_COD = SE5.E5_CLIFOR "+CRLF
cQuery	+= " AND SA2.A2_LOJA = SE5.E5_LOJA "+CRLF
cQuery	+= " AND SA2.D_E_L_E_T_ = ' ' "+CRLF

cQuery	+= " WHERE SE5.E5_FILIAL = '"+xFilial("SE5")+"' "+CRLF
cQuery	+= " AND RTRIM(LTRIM(SE5.E5_PREFIXO+SE5.E5_NUMERO+SE5.E5_PARCELA+SE5.E5_TIPO+SE5.E5_CLIFOR+SE5.E5_LOJA))='"+Alltrim(cDocSE5)+"' "+CRLF
cQuery	+= " AND SE5.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

If (cArqTmp)->(!Eof())
	cRet := (cArqTmp)->A2_CONTA 
EndIf

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)	
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetHistLp	ºAutor  ³Microsiga		     º Data ³  14/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a conta contabil debito para LP 597			      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetHistLp(cDocSE5, cPrefixPa, cNumPa)

Local aArea		:= GetArea()
Local cRet		:= ""
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()

Default cDocSE5		:= "" 
Default cPrefixPa	:= "" 
Default cNumPa		:= ""

cQuery	:= " SELECT A2_CONTA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA FROM "+RetSqlName("SE5")+" SE5 "+CRLF

cQuery	+= " INNER JOIN "+RetSqlName("SA2")+" SA2 "+CRLF
cQuery	+= " ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' " +CRLF
cQuery	+= " AND SA2.A2_COD = SE5.E5_CLIFOR "+CRLF
cQuery	+= " AND SA2.A2_LOJA = SE5.E5_LOJA "+CRLF
cQuery	+= " AND SA2.D_E_L_E_T_ = ' ' "+CRLF

cQuery	+= " WHERE SE5.E5_FILIAL = '"+xFilial("SE5")+"' "+CRLF
cQuery	+= " AND RTRIM(LTRIM(SE5.E5_PREFIXO+SE5.E5_NUMERO+SE5.E5_PARCELA+SE5.E5_TIPO+SE5.E5_CLIFOR+SE5.E5_LOJA))='"+Alltrim(cDocSE5)+"' "+CRLF
cQuery	+= " AND SE5.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)


If (cArqTmp)->(!Eof())
	cRet := "Comp de Pagto "+ Alltrim((cArqTmp)->(E5_PREFIXO+E5_NUMERO)) +" X "+Alltrim(cPrefixPa+cNumPa)+"."
EndIf

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return cRet