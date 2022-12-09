#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"

User function TK260FIL()

	Local _cFiltro	:= U_HCIDM010("Prosp")
	
	If !Empty(_cFiltro)
		_cFiltro := "SUS->US_CGC $ '" + _cFiltro + "' "
	EndIf

Return(_cFiltro)