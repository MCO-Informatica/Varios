#include 'protheus.ch'
#include 'parmtype.ch'

user function PrrDesc03()
		
	Local _cRetorno 

	if M->CTD_XTIPO == "AT"
		if EMPTY(M->CTD_XNREDU)
			_cRetorno := ALLTRIM(M->CTD_XEQUIP) + "/" + ALLTRIM(M->CTD_XCOMAT)
		else
			_cRetorno := ALLTRIM(M->CTD_XNREDU) + "-" + ALLTRIM(M->CTD_XEQUIP) + "/" + ALLTRIM(M->CTD_XCOMAT)
		endif
	else
		if EMPTY(M->CTD_XNREDU)
			_cRetorno := ALLTRIM(M->CTD_XEQUIP) 
		else
			_cRetorno := ALLTRIM(M->CTD_XNREDU) + "-" + ALLTRIM(M->CTD_XEQUIP)
		endif
	endif
	
Return _cRetorno 
