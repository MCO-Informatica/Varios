//------------------------------------------------------------------
// Rotina | MT410E  | Autor | Robson Luiz - Rleg | Data | 15/05/2013
//------------------------------------------------------------------
// Descr. | Ponto de entrada executado ap�s a exclus�o do item do 
//        | pedido de venda. O cabe�alho est� posicionado.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function MT410E()
	//-----------------------------------------------------------------
	// Verificar se existe cabe�alho e item de AR e eliminar o vinculo.
	//-----------------------------------------------------------------
	U_CSFA170()
Return