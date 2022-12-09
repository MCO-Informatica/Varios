
User Function MA030BRW()

	Local _cRetFil	:= U_HCIDM010("Cliente")
	
	If !Empty(_cRetFil)
		_cRetFil	:= "SA1->A1_COD+SA1->A1_LOJA $ '" + _cRetFil + "'"
	EndIf

Return(_cRetFil)