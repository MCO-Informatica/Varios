//--------------------------------------------------------------------------
// Rotina | MT120GOK | Autor | Robson Goncalves          | Data | 14/03/2016
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada acionado após a gravação dos dados do pedido de
//        | compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#Include 'Protheus.ch'
User Function MT120GOK()
	Local aParam := {}
	Local cMV_MT120A := 'MV_MT120A'
	Local nNUM_PC := 1
	Local nINCLUI := 2
	Local nALTERA := 3
	
	//----------------------------------------------------------------------------------
	// Parâmetro para habilitar/desabilitar a regra de réplica da conta contábil orçada.
	If .NOT. GetMv( cMV_MT120A, .T. )
		CriarSX6( cMV_MT120A, 'N', 'HABILITAR A REPLICA DA CTA ORCADA NA CTA CONTABIL DO PRODUTO OU DO RATEIO PC E/OU NA MEDICAO. 0=DESABILITADO E 1=HABILITADO - ROTINA MT120GOK.prw', '0' )
	Endif

	If GetMv( cMV_MT120A, .F. ) == 1 // Se o processo estiver habilitado.
		//------------------------------------
		// Capturar os dados da rotina padrão.
		// [1]-cA120Num
		// [2]-l120Inclui
		// [3]-l120Altera
		// [4]-l120Deleta
		aParam := AClone( ParamIXB )
		//------------------------------
		// Se for inclusão ou alteração.
		If ( aParam[ nINCLUI ] .OR. aParam[ nALTERA ] )
			MT120AvRat( aParam[ nNUM_PC ] )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | MT120AvRat | Autor | Robson Goncalves        | Data | 14/03/2016
//--------------------------------------------------------------------------
// Descr. | O objetivo é efetuar ajuste na conta contábil do produto
//        | ou do rateio conforme conta contábil orçado definido na capa de 
//        | despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function MT120AvRat( cNUM_PC )
	Local cSQL := ''
	Local cFunName := FunName()
	
	Local aMyParam := {}
	
	Local nDISTINTO := 1
	Local nBUDGET   := 2
	Local nITPROD   := 3
	Local nITEMRAT  := 4
	Local nCTA_ORC  := 5
	//------------------------------------------------
	// Capturar os dados definidos na capa de despesa.
	// [1]-nDISTINTO
	// [2]-cBUDGET
	// [3]-lItProd
	// [4]-lItemRat
	// [5]-cCTA_ORCADA
	aMyParam := U_A610Restore()
	If Len( aMyParam ) > 0
		//-----------------------------------
		// Limpar os dados do vetor ESTÁTICO.
		U_A610Clear()
		//------------------------------------------------------------------------------------------
		// Não há distinção entre as contas contábeis?
		// A despesa foi aprovada em Budget?
		// Há conta contábil orçada?
		// Realmente as contas contábeis são iguai?
		If aMyParam[ nDISTINTO ] == 0 .AND. aMyParam[ nBUDGET ] == '1' .AND. .NOT. Empty( aMyParam[ nCTA_ORC ] ) .AND. .NOT. aMyParam[ nITPROD ]
			If cFunName == 'CNTA120'
				If aMyParam[ nITEMRAT ]
					MT120CNZ( aMyParam[ nCTA_ORC ], cNUM_PC )
				Else
					MT120CNE( aMyParam[ nCTA_ORC ], cNUM_PC )
				Endif
			Elseif cFunName $ 'MATA120|MATA121'
				If aMyParam[ nITEMRAT ]
					MT120SCH( aMyParam[ nCTA_ORC ], cNUM_PC )
				Else
					MT120SC7( aMyParam[ nCTA_ORC ], cNUM_PC )
				Endif
			Endif
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | MT120CNZ | Autor | Robson Goncalves          | Data | 05/04/2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para executar update na tabela.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function MT120CNZ( cCTA_ORC, cNUM_PC )
	Local cSQL := ''
	If IsBlind() .AND. Type( 'cXFil' ) == 'C'
		cSQL := "UPDATE "                  +RetSQLName("CNZ")                +" CNZ "
		cSQL += "SET CNZ_CONTA = "         +ValToSql( cCTA_ORC ) +" "
		cSQL += "WHERE CNZ_FILIAL = "      +ValToSql( xFilial( "CNZ" ) )     +" "
		cSQL += "AND CNZ_CONTRA = "        +ValToSql( CND->CND_CONTRA )      +" "
		cSQL += "AND CNZ_REVISA = "        +ValToSql( CND->CND_REVISA )      +" "
		cSQL += "AND CNZ_NUMMED = "        +ValToSql( CND->CND_NUMMED )      +" "
		cSQL += "AND CNZ.D_E_L_E_T_ = ' ' "
		If TCSQLEXEC( cSQL ) < 0
			Conout('[MT120GOK] - PROBLEMA AO EXECUTAR O UPDATE (CNE): ' + CRLF + TCSQLERROR() )
		Else
			MT120SCH( cCTA_ORC, cNUM_PC )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | MT120CNE | Autor | Robson Goncalves          | Data | 05/04/2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para executar update na tabela.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function MT120CNE( cCTA_ORC, cNUM_PC )
	Local cSQL := ''
	If IsBlind() .AND. Type( 'cXFil' ) == 'C'
		cSQL := "UPDATE "                   +RetSQLName("CNE")            +" CNE "
		cSQL += "SET CNE_CONTA = "          +ValToSql( cCTA_ORC )         +" "
		cSQL += "WHERE CNE_FILIAL = "       +ValToSql( xFilial( "CNE" ) ) +" "
		cSQL += "AND CNE_CONTRA = "         +ValToSql( CND->CND_CONTRA )  +" "
		cSQL += "AND CNE_REVISA = "         +ValToSql( CND->CND_REVISA )  +" "
		cSQL += "AND CNE_NUMMED = "         +ValToSql( CND->CND_NUMMED )  +" "
		cSQL += "AND CNE.D_E_L_E_T_ = ' ' "
		If TCSQLEXEC( cSQL ) < 0
			Conout('[MT120GOK] - PROBLEMA AO EXECUTAR O UPDATE (CNE): ' + CRLF + TCSQLERROR() )
		Else
			MT120SC7( cCTA_ORC, cNUM_PC )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | MT120SCH | Autor | Robson Goncalves          | Data | 05/04/2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para executar update na tabela.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function MT120SCH( cCTA_ORC, cNUM_PC )
	Local cSQL := ''
	cSQL := "UPDATE "                   +RetSQLName("SCH")            +" SCH "
	cSQL += "SET CH_CONTA = "           +ValToSql( cCTA_ORC )         +" "
	cSQL += "WHERE CH_FILIAL = "        +ValToSql( xFilial( "SCH" ) ) +" "
	cSQL += "AND CH_PEDIDO = "          +ValToSql( cNUM_PC )          +" "
	cSQL += "AND SCH.D_E_L_E_T_ = ' ' "
	If TCSQLEXEC( cSQL ) < 0
		Conout('[MT120GOK] - PROBLEMA AO EXECUTAR O UPDATE (SCH): ' + CRLF + TCSQLERROR() )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | MT120SC7 | Autor | Robson Goncalves          | Data | 05/04/2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para executar update na tabela.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function MT120SC7( cCTA_ORC, cNUM_PC )
	Local cSQL := ''
	cSQL := "UPDATE "                   +RetSQLName("SC7")            +" SC7 "
	cSQL += "SET C7_CONTA = "           +ValToSql( cCTA_ORC )         +" "
	cSQL += "WHERE C7_FILIAL = "        +ValToSql( xFilial( "SC7" ) ) +" "
	cSQL += "AND C7_NUM = "             +ValToSql( cNUM_PC )          +" "
	cSQL += "AND SC7.D_E_L_E_T_ = ' ' "
	If TCSQLEXEC( cSQL ) < 0
		Conout('[MT120GOK] - PROBLEMA AO EXECUTAR O UPDATE (SC7): ' + CRLF + TCSQLERROR() )
	Endif
Return