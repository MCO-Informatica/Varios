//-----------------------------------------------------------------------
// Rotina | GPM040EX   | Autor | Robson Gon�alves     | Data | 28.03.2014
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada acionado ap�s o cancelamento da rescis�o de
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