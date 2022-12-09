#Include 'Protheus.ch'

User Function IMP650C()

	local cConta

			
	IF SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" .AND. ALLTRIM(SB1->B1_TIPO) == "MP"
		cConta := "113020002"
	
	ELSEIF ! SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" .AND. ALLTRIM(SB1->B1_TIPO) == "MP" // *************
		cConta := SD1->D1_CONTA
		
	ELSEIF SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" .AND. ALLTRIM(SB1->B1_TIPO) == "PI"
		cConta := "113030017"                            
		
		
	ELSEIF ! SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" .AND. ALLTRIM(SB1->B1_TIPO) == "PI"
		cConta := SD1->D1_CONTA
		
	ELSEIF  SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" .AND. ALLTRIM(SB1->B1_TIPO) == "MC" // ************
		cConta := "113070002"
		                                                                                                         
	ELSEIF ! SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" .AND. ALLTRIM(SB1->B1_TIPO) == "MC" // ************
		cConta := SD1->D1_CONTA
	
	ELSEIF SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" .AND. ALLTRIM(SB1->B1_TIPO) == "PA"
		cConta := "113040016"
		
	ELSEIF ! SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" .AND. ALLTRIM(SB1->B1_TIPO) == "PA" // ************
		cConta := SD1->D1_CONTA

	ELSEIF SUBSTR(SD1->D1_ITEMCTA,1,2) $ "ES"
		cConta := "113010002"
	ELSE
		cConta:=""			
	ENDIF
                                                                                     
Return cConta