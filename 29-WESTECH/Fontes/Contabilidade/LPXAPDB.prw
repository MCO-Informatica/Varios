#Include 'Protheus.ch'

User Function LPXAPDB()
	
	local cConta
	
	

	IF ALLTRIM(SZ4->Z4_ITEMCTA) = "PROPOSTA" 
		cConta := "691010001"
	
	//ELSEIF ALLTRIM(SZ4->Z4_ITEMCTA) = "ADMINISTRACAO" 
		//cConta := "691010001"
   
	ELSEIF SUBSTR(SZ4->Z4_ITEMCTA,1,2) $ "AT/EQ/EN/PR/ST/GR/CM" 
		cConta := "113060001"
		
	//ELSE
		//cConta := SPACE(10)		
	
	ENDIF
	


Return cConta

