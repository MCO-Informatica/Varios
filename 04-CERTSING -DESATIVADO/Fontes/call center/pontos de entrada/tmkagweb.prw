//--------------------------------------------------------------------
// Rotina | TMKAGWEB | Autor | Robson Luiz - Rleg | Data | 04.10.2012 
//--------------------------------------------------------------------
// Descr. | Ponto de entrada executado na rotina da Agenda do Operador
//        | TMKA380B, o objetivo � executar uma funcionalidade
//        | espec�fica que o operador com o tipo de atendimento igual
//        | a TeleVendas consiga atuar tamb�m na opera��o de 
//        | TeleMarketing da Agenda do Operador.
//--------------------------------------------------------------------
// Uso    | Cetisign
//--------------------------------------------------------------------
User Function TMKAGWEB( aItemSel, aCOLS, aHeader, oGetDados, nLiaCOLS )

	//-------------------------------------------------------------------
	// A intelig�ncia da rotina est� na rotina abaixo, o ponto de entrada
	// uso apenas para chamada do que for espec�fico, assim fica mais 
	// f�cil de efetuar manuten��o no ponto de entrada.
	//-------------------------------------------------------------------
	U_CSFA040( aItemSel, aCOLS, aHeader, oGetDados, nLiaCOLS )
Return