//--------------------------------------------------------------------------
// Rotina | MT160GRPC  | Autor | Robson Goncalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada para gravação de valores e campos no pedido de 
//        | compras por meio da gravação da cotação.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MT160GRPC()
	U_A610Grav( 'COT' )
Return