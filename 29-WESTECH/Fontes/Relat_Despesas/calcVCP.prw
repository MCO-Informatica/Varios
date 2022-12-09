#Include 'Protheus.ch'

User Function calcVCP()
	Local _cRetorno 
	Local cTPDesp := M->Z3_TPDESP
	
	if cTPDesp = "VCP"
		_cRetorno := Z3_KM * 0.88
	else
		msginfo ( "Este campo é somente preenchido quando Tipo de Despesa for VCP - Veículo Próprio." )
		M->Z3_VALOR := 0
		_cRetorno	:= 0
	end if
	                  
Return _cRetorno  

