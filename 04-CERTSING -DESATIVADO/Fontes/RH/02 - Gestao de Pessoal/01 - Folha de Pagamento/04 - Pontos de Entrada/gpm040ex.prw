//-----------------------------------------------------------------------
// Rotina | GPM040EX   | Autor | Robson Gonçalves     | Data | 28.03.2014
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada acionado após o cancelamento da rescisão de
//        | trabalho - SIGAGPE.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function GPM040EX()
	If FindFunction("U_A380ExcRes")
		U_A380ExcRes()
	Endif
Return