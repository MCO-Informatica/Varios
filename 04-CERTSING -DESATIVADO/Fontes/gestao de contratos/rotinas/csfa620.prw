//--------------------------------------------------------------------------
// Rotina | CSFA620    | Autor | Robson Goncalves        | Data | 18.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada CNZAUTRAT. O objetivo é
//        | capturar o código da conta contábil do produto informado na 
//        | medição.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA620( aCab, aDados )
	Local oOwner
	Local nI := 0
	Local nLin := 0
	Local nOpc := 0
	
	Local nCNE_CONTA := 0
	Local cCNE_CONTA := ''

	Local nCNE_CC := 0
	Local cCNE_CC := ''

	Local nCNE_CLVL := 0
	Local cCNE_CLVL := ''

	Local nCNE_ITEMCT := 0
	Local cCNE_ITEMCT := ''

	//--------------------------------------------------------------------------------
	// Capturar o objeto da interface.
	oOwner := GetWndDefault()
	//--------------------------------------------------------------------------------
	// Varrer todos os controles de objeto da interface de medição.
	For nI := 1 To Len( oOwner:aControls )
		//--------------------------------------------------------------------------------
		// Se for do tipo objeto.
		If ValType( oOwner:aControls[ nI ] ) == 'O'
			//--------------------------------------------------------------------------------
			// Se for o objeto Pai e existem as variáveis vetor e numérico.
			If oOwner:aControls[ nI ]:ClassName() == 'MSBRGETDBASE'     .AND. ;
			   ValType( oOwner:aControls[ nI ]:oMother:aHeader ) == 'A' .AND. ;
			   ValType( oOwner:aControls[ nI ]:oMother:aCOLS ) == 'A'   .AND. ;
			   ValType( oOwner:aControls[ nI ]:nAt ) == 'N'
				//--------------------------------------------------------------------------------
				// Capturar a posição do campo no aHeader.
				nCNE_CONTA  := AScan( oOwner:aControls[ nI ]:oMother:aHeader, {|p| RTrim( p[ 2 ] ) == 'CNE_CONTA' } )
				nCNE_CC     := AScan( oOwner:aControls[ nI ]:oMother:aHeader, {|p| RTrim( p[ 2 ] ) == 'CNE_CC' } )
				nCNE_CLVL   := AScan( oOwner:aControls[ nI ]:oMother:aHeader, {|p| RTrim( p[ 2 ] ) == 'CNE_CLVL' } )
				nCNE_ITEMCT := AScan( oOwner:aControls[ nI ]:oMother:aHeader, {|p| RTrim( p[ 2 ] ) == 'CNE_ITEMCT' } )
				//--------------------------------------------------------------------------------
				// Se encontrou...
				If nCNE_CONTA > 0
					//--------------------------------------------------------------------------------
					// Capturar o número da linha em questão na GetDados.
					nLin := oOwner:aControls[ nI ]:oMother:nAt
					//--------------------------------------------------------------------------------
					// Capturar o conteúdo.
					cCNE_CONTA  := oOwner:aControls[ nI ]:oMother:aCOLS[ nLin, nCNE_CONTA ]
					cCNE_CC     := oOwner:aControls[ nI ]:oMother:aCOLS[ nLin, nCNE_CC ]
					cCNE_CLVL   := oOwner:aControls[ nI ]:oMother:aCOLS[ nLin, nCNE_CLVL ]
					cCNE_ITEMCT := oOwner:aControls[ nI ]:oMother:aCOLS[ nLin, nCNE_ITEMCT ]
					//------------------------------------------------------------------------------------------------
					// Alimentar o vetor pra retornar ao ponto de entrada. Código e Descrição das entidades contábeis.
					If Empty( aDados[ 1, GdFieldPos( 'CNZ_CONTA' , aCab ) ] )
						aDados[ 1, GdFieldPos( 'CNZ_CONTA', aCab ) ] := cCNE_CONTA
						aDados[ 1, GdFieldPos( 'CNZ_DESCT1', aCab ) ] := CT1->( Posicione( 'CT1', 1, xFilial( 'CT1' ) + cCNE_CONTA , 'CT1_DESC01' ) )
					Endif
					If Empty( aDados[ 1, GdFieldPos( 'CNZ_CC', aCab ) ] )
						aDados[ 1, GdFieldPos( 'CNZ_CC', aCab ) ] := cCNE_CC
						aDados[ 1, GdFieldPos( 'CNZ_DESCTT', aCab ) ] := CTT->( Posicione( 'CTT', 1, xFilial( 'CTT' ) + cCNE_CC    , 'CTT_DESC01' ) )
					Endif
					If Empty( aDados[ 1, GdFieldPos( 'CNZ_CLVL'  , aCab ) ] )
						aDados[ 1, GdFieldPos( 'CNZ_CLVL', aCab ) ] := cCNE_CLVL
						aDados[ 1, GdFieldPos( 'CNZ_DESCTD', aCab ) ] := CTD->( Posicione( 'CTD', 1, xFilial( 'CTD' ) + cCNE_ITEMCT, 'CTD_DESC01' ) )
					Endif
					If Empty( aDados[ 1, GdFieldPos( 'CNZ_ITEMCT', aCab ) ] )
						aDados[ 1, GdFieldPos( 'CNZ_ITEMCT', aCab ) ] := cCNE_ITEMCT
						aDados[ 1, GdFieldPos( 'CNZ_DESCTH', aCab ) ] := CTH->( Posicione( 'CTH', 1, xFilial( 'CTH' ) + cCNE_CLVL  , 'CTH_DESC01' ) )
					Endif
					//--------------------------------------------------------------------------------
					// Sair do laço.
					Exit
				Endif
			Endif
		Endif
	Next nI
Return

//--------------------------------------------------------------------------
// Rotina | A620RepCta | Autor | Robson Goncalves        | Data | 18.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina acionada pelo gatilho do campo CNZ_PERC com contra
//        | domínio no campo CNZ_PERC. O objetivo é replicar o código da 
//        | conta contábil capturado pelo ponto de entrada CNZAUTRAT.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A620RepCta()
	Local nI := 0
	Local nCNZ_CONTA := 0
	Local cCNZ_CONTA := ''
	Local cRet := &( ReadVar() )
	Local oOwner := GetWndDefault()
	//--------------------------------------------------------------------------------
	// Varrer todos os controles de objeto da interface de medição.
	For nI := 1 To Len( oOwner:aControls )
		//--------------------------------------------------------------------------------
		// Se for do tipo objeto.
		If ValType( oOwner:aControls[ nI ] ) == 'O'
			//--------------------------------------------------------------------------------
			// Se for o objeto Pai e existem as variáveis vetor e numérico.
			If oOwner:aControls[ nI ]:ClassName() == 'MSBRGETDBASE'     .AND. ;
			   ValType( oOwner:aControls[ nI ]:oMother:aHeader ) == 'A' .AND. ;
			   ValType( oOwner:aControls[ nI ]:oMother:aCOLS ) == 'A'   .AND. ;
			   ValType( oOwner:aControls[ nI ]:nAt ) == 'N'
				//--------------------------------------------------------------------------------
			   // Se estiver na segunda linha endiante.
			   If oOwner:aControls[ nI ]:nAt > 1
					//--------------------------------------------------------------------------------
					// Capturar a posição do campo no aHeader.
					nCNZ_CONTA := AScan( oOwner:aControls[ nI ]:oMother:aHeader, {|p| RTrim( p[ 2 ] ) == 'CNZ_CONTA' } )
					//--------------------------------------------------------------------------------
					// Capturar o conteúdo.
					cCNZ_CONTA := oOwner:aControls[ nI ]:oMother:aCOLS[ 1, nCNZ_CONTA ]
					//--------------------------------------------------------------------------------
					// Alimentar o vetor do objeto com o conteúdo capturado.
					oOwner:aControls[ nI ]:oMother:aCOLS[ oOwner:aControls[ nI ]:nAt, nCNZ_CONTA ] := cCNZ_CONTA
					Exit
				Endif
			Endif
		Endif
   Next nI
Return( cRet )

//--------------------------------------------------------------------------
// Rotina | A620Trig   | Autor | Robson Goncalves        | Data | 18.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina para criar o gatilho para o referido campo.
//        | 
//        | 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A620Trig()
	Local lSX7 := .F.
	Local cSeq := '000'
	If MsgYesNo('Rotina reponsável por criar o gatilho para o campo CNZ_PERC','A620Trig | Criar gatilho')
		SX3->( dbSetOrder( 2 ) )
		If SX3->( dbSeek( 'CNZ_PERC' ) )
			If SX3->X3_TRIGGER <> 'S'
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_TRIGGER := 'S'
				SX3->( MsUnLock() )
			Endif
		Endif
		SX7->( dbSetOrder( 1 ) )
		If SX7->( dbSeek( 'CNZ_PERC' ) )
			While SX7->( .NOT. EOF() ) .AND. RTrim( SX7->X7_CAMPO ) == 'CNZ_PERC'
				cSeq := Soma1( cSeq )
				If RTrim( SX7->X7_CAMPO ) == 'CNZ_PERC'  .AND. ;
				   RTrim( SX7->X7_CDOMIN ) == 'CNZ_PERC' .AND. ;
				   Upper( RTrim( SX7->X7_REGRA ) )== 'U_A620REPCTA()'
					lSX7 := .T.
				Endif
				SX7->( dbSkip() )
			End
			If .NOT. lSX7
				SX7->( RecLock( 'SX7', .T. ) )
				SX7->X7_CAMPO   := 'CNZ_PERC'
				SX7->X7_SEQUENC := '001'
				SX7->X7_REGRA   := 'U_A620RepCta()'
				SX7->X7_CDOMIN  := 'CNZ_PERC  '
				SX7->X7_TIPO    := 'P'
				SX7->X7_SEEK    := 'N'
				SX7->X7_PROPRI  := 'U'
				SX7->( MsUnLock() )
			Endif
		Endif
		MsgInfo('Criado ponto de entrada CNZ_PERC-001 com sucesso.','A620Trig | Criar gatilho')
	Endif
Return