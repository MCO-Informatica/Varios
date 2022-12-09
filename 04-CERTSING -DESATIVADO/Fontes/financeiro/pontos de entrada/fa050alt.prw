//---------------------------------------------------------------------
// Rotina | FA050Alt    | Autor | Robson Gonçalves | Data | 13.10.2014 
//---------------------------------------------------------------------
// Descr. | Ponto de entrada acionado no momento da alteração de título
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