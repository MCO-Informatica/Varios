//--------------------------------------------------------------------------
// Rotina | MTA110MNU  | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada acionado no menu do MBrowse da solicitação de 
//        | compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MTA110MNU()
	AAdd( aRotina, { 'Workflow', 'U_A710MnuSC', 0, 7, 7, NIL } )
Return