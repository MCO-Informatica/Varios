//---------------------------------------------------------------------
// Rotina | FA050Alt    | Autor | Robson Gon�alves | Data | 13.10.2014 
//---------------------------------------------------------------------
// Descr. | Ponto de entrada acionado no momento da altera��o de t�tulo
//        | a pagar.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function FA050Alt()
	Local lRet := .T.
	If FindFunction('U_A450ALPA')
		lRet := U_A450ALPA()
	Endif
Return( lRet )