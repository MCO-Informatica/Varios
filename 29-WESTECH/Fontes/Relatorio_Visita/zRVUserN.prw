#Include 'Protheus.ch'

User Function zRVUserN()
Local _cRetornoN 
Private cIdUser  := AllTrim(RetCodUsr())
Private cUsuarioN := AllTrim(UsrFullName(RetCodUsr()))

PswOrder(1)
If PswSeek(RetCodUsr(), .T. )
	_cRetornoN := AllTrim(UsrFullName(RetCodUsr()))
endif
 
Return ( _cRetornoN )
