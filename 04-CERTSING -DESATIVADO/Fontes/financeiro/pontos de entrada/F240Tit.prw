//---------------------------------------------------------------------
// Rotina | F240Tit      | Autor | Robson Gon�alves | Data | 13.10.2014 
//---------------------------------------------------------------------
// Descr. | Ponto de entrada acionado para permitir ou n�o a marca do
//        | t�tulo no momento da montagem da tela, no mark e no invert.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function F240Tit()
	If FindFunction('U_A450BOPA')
		U_A450BOPA()
	Endif
Return( .T. )