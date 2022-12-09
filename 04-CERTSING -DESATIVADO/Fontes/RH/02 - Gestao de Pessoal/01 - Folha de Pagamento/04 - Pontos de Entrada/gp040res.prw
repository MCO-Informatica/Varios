//-----------------------------------------------------------------------
// Rotina | GP040RES   | Autor | Robson Gon�alves     | Data | 28.03.2014
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada acionado ap�s o c�lculo da rescis�o de
//        | trabalho - SIGAGPE.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function GP040RES()
	If FindFunction("U_A380Resicao")
		U_A380Resicao()
	Endif
Return