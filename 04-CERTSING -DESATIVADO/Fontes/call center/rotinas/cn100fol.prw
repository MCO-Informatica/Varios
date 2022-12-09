//-----------------------------------------------------------------------
// Rotina | CN100Fol   | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada acionado antes de apresentar a interface 
//        | do contrato.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CN100Fol()
	If FindFunction('U_A290FolCNPJ')
		U_A290FolCNPJ()
	Endif
Return