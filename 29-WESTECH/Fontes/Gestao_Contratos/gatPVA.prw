#Include 'Protheus.ch'

User Function gatPVA()

	Local _cRetorno 
	
	Local nQuant	:= SZG->ZG_QUANT
	Local nUnit		:= SZG->ZG_UNITVCI
	Local nTotal	:= SZG->ZG_TOTVCI/SZG->ZG_QUANT
	
	if nUnit = nTotal
		_cRetorno := "1"
	else
		_cRetorno := "2"
	endif
	
	
Return ( _cRetorno )

