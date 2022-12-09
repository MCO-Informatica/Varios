#Include 'Protheus.ch'

User Function zRVUser()
Local _cRetornoU 
 
PswOrder(1)
If PswSeek(RetCodUsr(), .T. )
	_cRetornoU := AllTrim(RetCodUsr())
endif
  	
Return ( _cRetornoU )
