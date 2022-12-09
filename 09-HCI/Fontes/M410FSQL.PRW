
User Function M410FSQL()

	Local _cRetFil	:= U_HCIDM010("PEDIDO")
	
	If !Empty(_cRetFil) .and. Len(AllTrim(_cRetFil)) > 9
		_cRetFil	:= " C5_VEND1 IN (" + _cRetFil + ")"
	Elseif Len(AllTrim(_cRetFil)) < 9 .and. Len(AllTrim(_cRetFil)) > 1
		_cRetFil	:= " C5_VEND1 = " + _cRetFil 
	Else 
		_cRetFil    := ""
	EndIf

Return(_cRetFil)
