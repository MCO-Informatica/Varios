User Function Lp640()
	local cConta

	
	IF SUBSTR(SD1->D1_ITEMCTA,1,2) == "EQ" .OR. SUBSTR(SD1->D1_ITEMCTA,1,2) == "ST" .AND. SA1->A1_EST <> "EX" //.AND. SA1->A1_XXGR == "2"
		cConta := "418010001"
		
	ELSEIF SUBSTR(SD1->D1_ITEMCTA,1,2) == "EQ" .OR. SUBSTR(SD1->D1_ITEMCTA,1,2) == "ST" .AND. SA1->A1_EST == "EX" .AND. SA1->A1_XXGR == "1"
		cConta := "418010003"
	
	ELSEIF SUBSTR(SD1->D1_ITEMCTA,1,2) == "EQ" .OR. SUBSTR(SD1->D1_ITEMCTA,1,2) == "ST" .AND. SA1->A1_EST == "EX" .AND. SA1->A1_XXGR == "2"
		cConta := "418010002"
	
	ELSEIF SUBSTR(SD1->D1_ITEMCTA,1,2) == "PR" .AND. SA1->A1_EST <> "EX" //.AND. SA1->A1_XXGR == "1"
		cConta := "418020001"                             
		
	ELSEIF SUBSTR(SD1->D1_ITEMCTA,1,2) == "PR" .AND. SA1->A1_EST == "EX" .AND. SA1->A1_XXGR == "1"
		cConta := "418010003"
	
	ELSEIF SUBSTR(SD1->D1_ITEMCTA,1,2) == "PR" .AND. SA1->A1_EST == "EX" .AND. SA1->A1_XXGR == "2"
		cConta := "418020002"	
			
	ELSE
		cConta:=""		
	
	ENDIF           

Return cConta