#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FR650FIL  ºAutor  ³Jose Mauricio       º Data ³  '18/03/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no relatorio de retorno Cnab, auxilia     º±±
±±º          ³ na localização do titulo                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros º±± aValores: ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes,±±
±±                nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc,      ±±
±±                dCred, cOcorr, xBuffer })                                ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION FR650FIL
LOCAL aArea    := GETAREA()          
LOCAL nPosIni  := 0
LOCAL xLinha   := PARAMIXB[1][14]       
LOCAL xPrefixo := ""
LOCAL xNumero  := ""
LOCAL xParcela := ""
lRet := .T.

IF MV_PAR07 == 2 // PAGAR
                   
	DO CASE
		CASE ALLTRIM(SEE->EE_CODIGO) == "001" .AND. ALLTRIM(SEE->EE_SUBCTA) == "PAG"  // BANCO DO BRASIL PAGAR
			nPosIni := 183
			xPrefixo  := SUBSTR(xLinha,nPosIni,TamSX3("E2_PREFIXO")[1])
			nPosIni   += LEN(xPrefixo) 
			xNumero   := SUBSTR(xLinha,nPosIni,TamSX3("E2_NUM")[1])		
			nPosIni   += LEN(xNumero)                                     
			xParcela  := SUBSTR(xLinha,nPosIni,TamSX3("E2_PARCELA")[1])		
		CASE ALLTRIM(SEE->EE_CODIGO) == "341" .AND. ALLTRIM(SEE->EE_SUBCTA) == "PAG"  // BANCO ITAU PAGAR
			nPosIni := 183
			xPrefixo  := SUBSTR(xLinha,nPosIni,TamSX3("E2_PREFIXO")[1])
			nPosIni   += LEN(xPrefixo) 
			xNumero   := SUBSTR(xLinha,nPosIni,TamSX3("E2_NUM")[1])		
			nPosIni   += LEN(xNumero)                                     
			xParcela  := SUBSTR(xLinha,nPosIni,TamSX3("E2_PARCELA")[1])		
		CASE ALLTRIM(SEE->EE_CODIGO) == "237" .AND. ALLTRIM(SEE->EE_SUBCTA) == "PAG"  // BRADESCO PAGAR	
			nPosIni := 416
			xPrefixo  := SUBSTR(xLinha,nPosIni,TamSX3("E2_PREFIXO")[1])
			nPosIni   += LEN(xPrefixo) 
			xNumero   := SUBSTR(xLinha,nPosIni,TamSX3("E2_NUM")[1])		
			nPosIni   += LEN(xNumero)                                     
			xParcela  := SUBSTR(xLinha,nPosIni,TamSX3("E2_PARCELA")[1])		
	END	   
	
	cNumTit	:= xPrefixo+xNumero+xParcela        
	SE2->(DBSETORDER(1))
	IF SE2->(!DBSEEK(XFILIAL("SE2")+cNumtit))
		lRet := .F.
	ELSE
		cTipo := SE2->E2_TIPO
		lRet := .T.
	ENDIF
ENDIF	
RETURN(lRet)