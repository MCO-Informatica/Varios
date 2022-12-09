#INCLUDE "PROTHEUS.CH"

User Function EICATUSLD()

Local lRet:= .T.

IF  SB1->B1_XCOTA == '1'
	
	nSldB1 := SB1->B1_XQTDCOT 
	
	IF M->W3_QTDE > nSldB1
		
		cMSGT := "SALDO INDISPONÍVEL - EICATUSLD"
		
		cMSG := PADL("Qtd Item"  ,15)+ Transform(WORK->WKQTDE,"@E 99,999,999.99")  +CRLF
		cMSG += PADL("Saldo Cota",15)+ Transform(SB1->B1_XQTDCOT,"@E 99,999,999.99")  +CRLF
		cMSG += PADL("Disponivel",15)+ Transform(nSldB1,"@E 99,999,999.99")  +CRLF
		
		MsgInfo(cMSG,cMSGT)
		
		lRet := .F.
		
	Endif
	
ENDIF


RETURN( lRet )
