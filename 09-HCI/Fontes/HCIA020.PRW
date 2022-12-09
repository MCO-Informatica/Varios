#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} HCIA020
Rotina para validação da condição do gatilho para preenchimento do 
campo C6_NUMPCOM

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		21/07/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
USER FUNCTION HCIA020()

	Local _cCliPetrob	:= SuperGetMV("ES_NFECPET",," ")
	Local _lOk			:= .F.
	
	If M->C5_CLIENTE $ _cCliPetrob
		_lOk	:= .T.
	EndIf

RETURN(_lOk)