#Include 'Protheus.ch'

User Function LPF399DEB()

	local cConta
	
	
	IF ALLTRIM(SRZ->RZ_CC) = "2110" .OR. ALLTRIM(SRZ->RZ_CC) = "2204" .OR. ALLTRIM(SRZ->RZ_CC) = "2303" .OR. ALLTRIM(SRZ->RZ_CC) = "3108" .OR. ALLTRIM(SRZ->RZ_CC) = "3304" .OR. ALLTRIM(SRZ->RZ_CC) = "4105" .OR. ALLTRIM(SRZ->RZ_CC) = "4302"
		cConta := "213010004"
		
	ELSE
		cConta := "213010001"		
	
	ENDIF
	


Return cConta



