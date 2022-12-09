//--------------------------------------------------------------------------
// Rotina | MT120CPE    | Autor | Robson Goncalves       | Data | 10.02.2016
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada que permite customizar dados das váriáveis do 
//        | pedido de compras. Nenhum retorno esperado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MT120CPE()
	Local nOpcX  := ParamIXB[ 1 ]
	Local lCopia := ParamIXB[ 2 ]
	//----------------------------------------------------------------------------------------
	// Rotina responsável por inserir no X3_RELACAO dos campos dos rateios do PC e da medição.
	U_A610IPCH('SCH')
	U_A610IPCH('CNZ')
Return