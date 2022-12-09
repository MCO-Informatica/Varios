//---------------------------------------------------------------------
// Rotina | F240Tit      | Autor | Robson Gonçalves | Data | 13.10.2014 
//---------------------------------------------------------------------
// Descr. | Ponto de entrada acionado para permitir ou não a marca do
//        | título no momento da montagem da tela, no mark e no invert.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function F240Tit()
	If FindFunction('U_A450BOPA')
		U_A450BOPA()
	Endif
Return( .T. )