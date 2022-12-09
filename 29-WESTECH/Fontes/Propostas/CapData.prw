#Include 'Protheus.ch'

User Function CapData()
	Local _cRetorno 
	 
	Local DTSistema := DTOC(YEARY(date()))

	_cRetorno  := SUBSTR(DTSistema,3,2)
      
Return _cRetorno

