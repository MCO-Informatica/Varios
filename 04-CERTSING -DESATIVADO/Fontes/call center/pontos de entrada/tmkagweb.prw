//--------------------------------------------------------------------
// Rotina | TMKAGWEB | Autor | Robson Luiz - Rleg | Data | 04.10.2012 
//--------------------------------------------------------------------
// Descr. | Ponto de entrada executado na rotina da Agenda do Operador
//        | TMKA380B, o objetivo é executar uma funcionalidade
//        | específica que o operador com o tipo de atendimento igual
//        | a TeleVendas consiga atuar também na operação de 
//        | TeleMarketing da Agenda do Operador.
//--------------------------------------------------------------------
// Uso    | Cetisign
//--------------------------------------------------------------------
User Function TMKAGWEB( aItemSel, aCOLS, aHeader, oGetDados, nLiaCOLS )

	//-------------------------------------------------------------------
	// A inteligência da rotina está na rotina abaixo, o ponto de entrada
	// uso apenas para chamada do que for específico, assim fica mais 
	// fácil de efetuar manutenção no ponto de entrada.
	//-------------------------------------------------------------------
	U_CSFA040( aItemSel, aCOLS, aHeader, oGetDados, nLiaCOLS )
Return