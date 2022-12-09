
User Function M415FSQL()

	Local _cRetFil	:= U_HCIDM010("PEDIDO")
	
	If !Empty(_cRetFil)
		_cRetFil	:= " CJ_VEND IN (" + _cRetFil + ")"
	EndIf

Return(_cRetFil)