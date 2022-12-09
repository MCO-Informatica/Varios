//-----------------------------------------------------------------------
// Rotina | FT310LOK   | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada acionado na confirmação da tela de 
//        | apontamento de visitas de oportunidades.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function FT310LOK()
	Local lRet := .T.
	
	If FindFunction('U_A250ExpV')
		lRet := U_A250ExpV()
	Endif
	
	If FindFunction('U_A250Validade')
		If lRet 
			lRet := U_A250Validade()
		Endif
	Endif
	
	If FindFunction('U_A250VlEst')
		If lRet 
			lRet := U_A250VlEst()
		Endif
	Endif
	
	If FindFunction('U_A320APF')
		If lRet 
			lRet := U_A320APF()
		Endif
	Endif
	
	If FindFunction('U_A250FCSI')
		If lRet 
			lRet := U_A250FCSI()
		Endif
	Endif
	
	If FindFunction('U_A250Obrig')
		If lRet 
			lRet := U_A250Obrig()
		Endif
	Endif
Return( lRet )