#include 'protheus.ch'
#include 'parmtype.ch'

user function zGatProd()
	
	Local cUsuario  := AllTrim(RetCodUsr())
	Local _Retorno
	
	if cUsuario == "000004" .OR.cUsuario == "000046"
	  	_Retorno := M->B1_XXND
	endif
	
return _Retorno