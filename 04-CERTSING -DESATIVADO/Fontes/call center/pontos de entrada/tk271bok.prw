//------------------------------------------------------------------------
// Rotina | TK271BOK        | Autor | Robson Luiz - Rleg | Data | 19/11/12
//------------------------------------------------------------------------
// Descr. | Ponto de entrada TK271BOK acionado no botão OK da tela de
//        | atendimento.
//------------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------------
User Function TK271BOK( n271Opc )
	Local lRet := .T.
	//--------------------------------------------------------------
	// Rotina acionada pelo ponto de entrada TK271BOK, o objetivo é
	// verificar se determinados campos estão preenchidos conforme
	// a necessidade do contexto do atendimento.
	//--------------------------------------------------------------
	If FunName() == "TMKA380"
		lRet := U_FA040TudOK( n271Opc )	
	Endif
Return( lRet )