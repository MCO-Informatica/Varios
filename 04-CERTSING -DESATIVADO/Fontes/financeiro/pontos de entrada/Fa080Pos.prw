//---------------------------------------------------------------------
// Rotina | Fa080Pos     | Autor | Robson Gonçalves | Data | 13.10.2014 
//---------------------------------------------------------------------
// Descr. | Ponto de entrada acionado no momento da carga de dados da 
//        | baixa a pagar e antes de apresentar os dados em tela.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function Fa080Pos()
	If FindFunction('U_A450BAPA')
		U_A450BAPA()
	Endif
Return