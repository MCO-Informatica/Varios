//--------------------------------------------------------------------
// Rotina | CSFA060   | Autor | Robson Luiz - Rleg | Data | 06.11.2012 
//--------------------------------------------------------------------
// Descr. | Rotina de controle de variáveis encapsuladas.
//        | O objetivo é armazenar dados na execução do ponto de
//        | entrada TMK380HR, e depois restaurar os valores no ponto 
//        | de entrada Tk271FimGr.
//--------------------------------------------------------------------
// Uso    | Cetisign
//--------------------------------------------------------------------

STATIC c060Chave := ""
STATIC c060TipoAte := ""

User Function CSFA060( nLiga, cTpBkp, cChave )
	Local nI := 0
	//--------------------------
	// Desliga o encapsulamento.
	//--------------------------
	If nLiga == 0
		//--------------------------------------------------------------------------
		// Verificar se a chave é diferente e se o tipo de atendimento é verdadeiro.
		//--------------------------------------------------------------------------
		If c060TipoAte <> cTpBkp .And. c060Chave == cChave
			//-------------------------------------------------------
			// Restaurar o tipo de atendimento e limpas as variáveis.
			//-------------------------------------------------------
			//TkGetTipoAte( c060TipoAte ) //Não foi preciso, pois está dando pau na função TkLimpa().
			c060Chave := ""
			c060TipoAte := ""
		Endif
	//-----------------------
	// Liga o encapsulamento.
	//-----------------------
   Elseif nLiga == 1
		//----------------------------------------------
		// Atribuir os valores as variáveis encapsulada.
		//----------------------------------------------
		c060TipoAte := cTpBkp
		c060Chave := cChave
   Endif
Return