//------------------------------------------------------------------
// Rotina | MT410E  | Autor | Robson Luiz - Rleg | Data | 15/05/2013
//------------------------------------------------------------------
// Descr. | Ponto de entrada executado após a exclusão do item do 
//        | pedido de venda. O cabeçalho está posicionado.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function MT410E()
	//-----------------------------------------------------------------
	// Verificar se existe cabeçalho e item de AR e eliminar o vinculo.
	//-----------------------------------------------------------------
	U_CSFA170()
Return