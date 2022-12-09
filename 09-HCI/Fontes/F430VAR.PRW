#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F430VAR   ºAutor  ³Jose Mauricio       º Data ³  '18/03/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no retorno Cnab pagar, permite            º±±
±±º          ³ manipular as variaveis na leitura do arquivo retorno       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros º±± aValores: ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes,   ±±
±±                nDescont, nAbatim, nValRec, nJuros, nMulta, nOutrDesp,   ±±
±±                nValCc, dDataCred, cOcorr, cMotBan, xBuffer,dDtVc,{} })  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION F430VAR
LOCAL aArea    := GETAREA()          
LOCAL nPosIni  := 0
LOCAL xLinha   := PARAMIXB[1][16]       
LOCAL xPrefixo := ""
LOCAL xNumero  := ""
LOCAL xParcela := ""

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
IF SE2->(DBSEEK(XFILIAL("SE2")+cNumtit))
	cTipo := SE2->E2_TIPO
ENDIF
RETURN