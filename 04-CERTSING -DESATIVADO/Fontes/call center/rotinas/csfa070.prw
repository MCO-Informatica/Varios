//------------------------------------------------------------------
// Rotina | CSFA070 | Autor | Robson Luiz - Rleg | Data | 26/10/2012
//------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TMK380HR.
//        | O objetivo é armazenar conteúdo nas variáveis 
//        | encapsuladas.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function CSFA070()
	Local cTpBkp := ""
	Local cOper := ""
	
	//-------------------------------------------------------------------------------------
	// Se o operador não estiver configurador para atender 1=Telemarketing;4=Todos;5=TmkTlv
	//-------------------------------------------------------------------------------------
	If !(TkGetTipoAte() $ "145")
	
		//-------------------------------------------------
		// Posicionar no cabeçalho da lista de atendimento.
		//-------------------------------------------------
		SU4->( dbSetOrder( 1 ) )
		If SU4->( dbSeek( xFilial( "SU4" ) + SU6->U6_LISTA ) )
			
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

				//---------------------------------------------------
				// Armazenar o tipo de atendimento atual do operador.
				//---------------------------------------------------
				cTpBkp := TkGetTipoAte()
		
				//-------------------------------------
				// Abre somente a tela de Telemarketing
				//-------------------------------------
				TkGetTipoAte("1")
				
				//----------------------------------------------
				// Armazenar os dados em variáveis encapsuladas.
				//----------------------------------------------
				U_CSFA060( 1, cTpBkp, SU7->( U7_VEND + U7_POSTO + U7_TIPOATE + U7_TIPO ) )
			Endif
		Endif
	Endif
Return(.T.)