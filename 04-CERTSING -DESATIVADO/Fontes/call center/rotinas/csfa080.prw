//------------------------------------------------------------------
// Rotina | CSFA080 | Autor | Robson Luiz - Rleg | Data | 06/11/2012
//------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TK271FIMGR.
//        | O objetivo é comparar os conteúdos das variáveis encapsuladas,
//        | e logo desligar o seu uso.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function CSFA080()
	Local cOper := ""
	Local cTpBkp := ""
	
	//------------------------
	// Posicionar no Operador.
	//------------------------
	cOper := TkOperador()
	
	//----------------------------------------
	// Consistir os dados de sua configuração.
	//----------------------------------------
	If SU7->U7_VEND    == "1"  .And. ;//1=Sim;2=Não
		SU7->U7_POSTO   == "02" .And. ;//02=Grupo Padrão
		SU7->U7_TIPOATE == "2"  .And. ;//1=Telemarketing;2=Televendas;3=Telecobranca;4=Todos;5=TmkTlv;6=Teleatendimento
		SU7->U7_TIPO    == "1"         //1=Operador;2=Supervisor
		
		//-------------------------------------------------------------------------
		// Captura o valor da variável _cTipoAte do tipo de atendimento em memória.
		//-------------------------------------------------------------------------
		cTpBkp := TkGetTipoAte()
		
		//----------------------------------------------
		// Restaurar os dados em variáveis encapsuladas.
		//----------------------------------------------
		U_CSFA060( 0, cTpBkp, SU7->( U7_VEND + U7_POSTO + U7_TIPOATE + U7_TIPO ) )
   Endif
Return