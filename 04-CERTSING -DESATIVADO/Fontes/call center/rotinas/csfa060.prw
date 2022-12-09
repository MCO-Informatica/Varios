//--------------------------------------------------------------------
// Rotina | CSFA060   | Autor | Robson Luiz - Rleg | Data | 06.11.2012 
//--------------------------------------------------------------------
// Descr. | Rotina de controle de vari�veis encapsuladas.
//        | O objetivo � armazenar dados na execu��o do ponto de
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
		// Verificar se a chave � diferente e se o tipo de atendimento � verdadeiro.
		//--------------------------------------------------------------------------
		If c060TipoAte <> cTpBkp .And. c060Chave == cChave
			//-------------------------------------------------------
			// Restaurar o tipo de atendimento e limpas as vari�veis.
			//-------------------------------------------------------
			//TkGetTipoAte( c060TipoAte ) //N�o foi preciso, pois est� dando pau na fun��o TkLimpa().
			c060Chave := ""
			c060TipoAte := ""
		Endif
	//-----------------------
	// Liga o encapsulamento.
	//-----------------------
   Elseif nLiga == 1
		//----------------------------------------------
		// Atribuir os valores as vari�veis encapsulada.
		//----------------------------------------------
		c060TipoAte := cTpBkp
		c060Chave := cChave
   Endif
Return