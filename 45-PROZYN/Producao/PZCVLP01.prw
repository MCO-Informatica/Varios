#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³PZCVLP01	ºAutor  ³Microsiga		     º Data ³  03/04/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a conta contabil para LP						      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function PZCVLP01(cDoc, cSerie, cContaDef)

Local aArea 	:= GetArea()
Local cRet		:= ""
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
	
Default cDoc		:= "" 
Default cSerie		:= "" 
Default cContaDef	:= ""

cQuery	:= " SELECT F2_DOC, F2_SERIE, C5_NATUREZ, ED_CONTA FROM "+RetSqlName("SF2")+" SF2 "+CRLF
cQuery	+= " INNER JOIN "+RetSqlName("SC5")+" SC5 "+CRLF
cQuery	+= " ON SC5.C5_FILIAL = SF2.F2_FILIAL "+CRLF
cQuery	+= " AND SC5.C5_NOTA = SF2.F2_DOC "+CRLF
cQuery	+= " AND SC5.C5_SERIE = SF2.F2_SERIE "+CRLF

cQuery	+= " INNER JOIN "+RetSqlName("SED")+" SED "+CRLF
cQuery	+= " ON SED.ED_FILIAL = SC5.C5_FILIAL "+CRLF
cQuery	+= " AND SED.ED_CODIGO = SC5.C5_NATUREZ "+CRLF
cQuery	+= " AND SED.D_E_L_E_T_ = ' ' "+CRLF

cQuery	+= " WHERE SF2.F2_FILIAL = '"+xFilial("SF2")+"' "+CRLF
cQuery	+= " AND SF2.F2_DOC = '"+cDoc+"' "+CRLF
cQuery	+= " AND SF2.F2_SERIE = '"+cSerie+"' " +CRLF
cQuery	+= " AND SF2.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

While (cArqTmp)->(!Eof())
	
	cRet := (cArqTmp)->ED_CONTA
	
	If !Empty(cRet)
		exit
	EndIf
	
	(cArqTmp)->(DbSkip()) 
EndDo

//Verifica se está vazio e preenche com o valor default
If Empty(cRet)
	cRet := cContaDef
EndIf

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)	
return cRet