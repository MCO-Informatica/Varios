#Include 'Protheus.ch'

User Function GatCodProICC()

	Local cEnd
	
	cITEMCC:=M->B1_ITEMCC
	
	IF EMPTY(B1_XXND)
		cValor := M->B1_ITEMCC +"-" + SUBSTR(GETSXENUM("SB1","B1_COD"),24,2)
	ELSE
		cValor := M->B1_XXND
	ENDIF
         
Return(cValor)

