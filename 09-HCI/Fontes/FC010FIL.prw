User Function FC010FIL(cFilter)     

	Local _cFilter := U_HCIDM010("CLIENTE")
	
	If !Empty(_cFilter)
		_cFilter	:= "A1_COD||A1_LOJA IN (" + _cFilter + ") "
	EndIf

Return _cFilter