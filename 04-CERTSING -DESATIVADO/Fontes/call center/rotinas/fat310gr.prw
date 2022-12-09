//---------------------------------------------------------------------
// Rotina | FAT310Gr   | Autor | Robson Luiz - Rleg | Data | 09/12/2013
//---------------------------------------------------------------------
// Descr. | Ponto de entrada acionado no final da gravação do 
//        | apontamento da oportunidade.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------
User Function FAT310Gr()
	Local nOpc := 0
	nOpc := ParamIXB[ 1 ]
	If FindFunction('U_CSFA310')
		U_CSFA310( nOpc )
	Endif
Return