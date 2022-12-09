#Include 'Protheus.ch'

User Function gatMATSZ8()
	Local _cRetorno 
	Local cTPMT := M->Z8_TPMT
	
	if cTPMT = "AER"
		_cRetorno := "AERACAO"
	ELSEif cTPMT = "AGI"
		_cRetorno := "AGITACAO"
	ELSEif cTPMT = "BOM"
		_cRetorno := "BOMBEAMENTO"
	ELSEif cTPMT = "CEN"
		_cRetorno := "CENTRIFUGACAO"
	ELSEif cTPMT = "CLR"
		_cRetorno := "CLARIFICACAO"
	ELSEif cTPMT = "CLA"
		_cRetorno := "CLASSIFICAO"
	ELSEif cTPMT = "DIG"
		_cRetorno := "DIGESTAO"
	ELSEif cTPMT = "DRA"
		_cRetorno := "DRAGAGEM"
	ELSEif cTPMT = "FPR"
		_cRetorno := "FILTRACAO A PRESSAO"
	ELSEif cTPMT = "FLO"
		_cRetorno := "FLOTACAO"
	ELSEif cTPMT = "OSM"
		_cRetorno := "OSMOSE REVERSA"
	ELSEif cTPMT = "SED"
		_cRetorno := "SEDIMENTACAO"
	ELSEif cTPMT = "SIS"
		_cRetorno := "SISTEMA"
	ELSEif cTPMT = "TNQ"
		_cRetorno := "TANQUE"
	ELSEif cTPMT = "TBI"
		_cRetorno := "TRATAMENTO BIOLOGICO"
	ELSEif cTPMT = "TRO"
		_cRetorno := "TROCA IONICA"
	ELSEif cTPMT = "UFT"
		_cRetorno := "ULTRAFILTRACAO"	
	end if
	                  
Return _cRetorno 
