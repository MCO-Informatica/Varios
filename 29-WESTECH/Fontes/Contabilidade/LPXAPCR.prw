#Include 'Protheus.ch'

User Function LPXAPCR()
	local cConta
	
	
	IF ALLTRIM(SZ4->Z4_ITEMCTA) = "PROPOSTA" 
		cConta := "691010002"

	//ELSEIF ALLTRIM(SZ4->Z4_ITEMCTA) = "ADMINISTRACAO" 
		//cConta := "691010002" 
		
	ELSEIF SUBSTR(SZ4->Z4_ITEMCTA,1,2) $ "AT/EQ/EN/PR/ST/GR/CM"  
		cConta := "691010002"
		
	//ELSE
		//cConta := SPACE(10)
	
	ENDIF

Return cConta

