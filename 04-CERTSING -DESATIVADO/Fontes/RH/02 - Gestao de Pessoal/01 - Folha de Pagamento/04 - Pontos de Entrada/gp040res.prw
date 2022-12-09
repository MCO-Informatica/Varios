//-----------------------------------------------------------------------
// Rotina | GP040RES   | Autor | Robson Gonçalves     | Data | 28.03.2014
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada acionado após o cálculo da rescisão de
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