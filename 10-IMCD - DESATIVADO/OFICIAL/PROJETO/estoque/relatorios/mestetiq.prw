#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  03/30/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MESTETIQ

	Local nOpcA       := 0
	Local aSays       := {}
	Local aButtons    := {}
	Local cCadastro   := "Geracao de Etiquera - "+SM0->M0_NOMECOM
	Local cPerg       := "MESTETIQ" 

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MESTETIQ" , __cUserID )
	Pergunte( cPerg, .F.)

	aAdd( aSays, "Essa rotina efetua a impressão da etiqueta" )
	aAdd( aSays, "especifica - "+SM0->M0_NOMECOM )

	aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
	aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
	aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1
		Processa( { || MESTETProc() }, "Imprimindo Etiqueta..." )
	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MESTETIQ  ºAutor  ³Microsiga           º Data ³  03/30/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MESTETProc

	Local cQuery  := ""
	Local nRegs   := 0

	Local oWord			:= NIL
	Local aCampos		:= {}
	Local nCopias		:= If( Empty( mv_par04 ), 1, mv_par04 )
	Local cArqWord		:= ""
	Local cPath 		:= GETTEMPPATH()
	Local lImpress      := ( mv_par05 == 1 )
	Local cArqSaida     := ""
	Local nX			:= 0
	Local lComple	    := .F.

	cQuery := "SELECT * "
	cQuery += "  FROM " + RetSQLName( "SD1" )
	cQuery += " WHERE D1_FILIAL  = '" + xFilial( "SD1" ) + "' "
	cQuery += "   AND D1_SERIE   = '" + MV_PAR01 + "' "
	cQuery += "   AND D1_DOC     BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	If Select( "TMP_SD1" ) > 0
		TMP_SD1->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SD1", .T., .F. )
	TMP_SD1->( dbGoTop() )
	TMP_SD1->( dbEval( { || nRegs++ } ) )
	TMP_SD1->( dbGoTop() )

	If nRegs == 0
		MsgStop( "Não existem registros para processamento. Verifique!" )
		Return
	Endif


	While TMP_SD1->( !Eof() )

		IncProc()

		cArqWord := ""
		lComple  := .F.

		SB1->( dbSetOrder( 1 ) )
		SB1->( dbSeek( xFilial( "SB1" ) + TMP_SD1->D1_COD ) )

		If Empty( SB1->B1_DOTETI )
			TMP_SD1->( dbSkip() )
			Loop
		Else
			cArqWord := AllTrim( SB1->B1_DOTETI )
		Endif

		If Empty( cArqWord )

			SBM->( dbSetOrder( 1 ) )
			SBM->( dbSeek( xFilial( "SBM" ) + SB1->B1_GRUPO ) )

			If Empty( SBM->BM_DOTETI )
				TMP_SD1->( dbSkip() )
				Loop
			Else
				cArqWord := AllTrim( SBM->BM_DOTETI )
			Endif

		Endif

		If Empty( cArqWord )
			TMP_SD1->( dbSkip() )
			Loop
		Endif

		SB5->( dbSetOrder( 1 ) )
		lComple := SB5->( dbSeek( xFilial( "SB5" ) + TMP_SD1->D1_COD ) )

		If substr(cArqWord,2,1) <> ":"
			cAux 	:= cArqWord
			nAT		:= 1
			for nx := 1 to len(cArqWord)
				cAux := substr(cAux,If(nx==1,nAt,nAt+1),len(cAux))
				nAt := at("\",cAux)
				If nAt == 0
					Exit
				Endif
			next nx
			CpyS2T(cArqWord,cPath, .T.)
			cArqWord	:= cPath+cAux
		Endif

		cArqSaida := AllTrim( mv_par08 ) + AllTrim( TMP_SD1->D1_SERIE ) + "_" + AllTrim( TMP_SD1->D1_DOC ) + "_" + AllTrim( TMP_SD1->D1_COD ) + ".doc"

		oWord	:= OLE_CreateLink()

		OLE_NewFile( oWord , cArqWord )

		aCampos := fCpos_Word( lComple )

		aEval(	aCampos																								,; 
		{ |x| OLE_SetDocumentVar( oWord, x[1]  																,; 
		IF( Subst( AllTrim( x[3] ) , 4 , 2 )  == "->"          					,; 
		Transform( x[2] , PesqPict( Subst( AllTrim( x[3] ) , 1 , 3 )		,; 
		Subst( AllTrim( x[3] )  				,; 
		- ( Len( AllTrim( x[3] ) ) - 5 )	 ; 
		)	  	 							 ; 
		)                                          ; 
		)															,; 
		Transform( x[2] , x[3] )                                     		 ; 
		) 														 	 		 ; 
		)																			 ; 
		}     																 							 	 ; 
		)

		OLE_UpDateFields( oWord )

		IF lImpress
			For nX := 1 To nCopias
				OLE_SetProperty( oWord, '208', .F. )
				OLE_PrintFile( oWord )
			Next nX
		Else
			OLE_SaveAsFile( oWord, cArqSaida )
		EndIF

		OLE_CloseLink( oWord )

		TMP_SD1->( dbSkip() )
	End

	TMP_SD1->( dbCloseArea() )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MESTETIQ  ºAutor  ³Microsiga           º Data ³  04/16/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCpos_Word( lComple )

	Local aAreaAtu := GetArea()
	Local aAreaSX3 := GetArea()
	Local aAreaSB1 := SB1->( GetArea() )

	Local aRetFun := {}
	Local nLoop   := 0
	Local cCampo  := ""

	For nLoop :=  1 To TMP_SD1->( fCount() )

		cCampo := PadR( AllTrim( TMP_SD1->( FieldName( nLoop ) ) ), 10 )

		aAdd( aRetFun, { AllTrim( cCampo ), &( cCampo ), GETSX3CACHE(cCampo,"X3_PICTURE"),( X3Titulo() ) } ) 
		
	Next nLoop

	For nLoop :=  1 To SB1->( fCount() )

		cCampo := PadR( AllTrim( SB1->( FieldName( nLoop ) ) ), 10 )

		aAdd( aRetFun, { AllTrim( cCampo ), SB1->( &( cCampo ) ), GETSX3CACHE(cCampo,"X3_PICTURE"), X3Titulo() } ) 
		
	Next Loop

	If lComple
		For nLoop :=  1 To SB5->( fCount() )

			cCampo := PadR( AllTrim( SB5->( FieldName( nLoop ) ) ), 10 )

	
			aAdd( aRetFun, { AllTrim( cCampo ), SB5->( &( cCampo ) ), GETSX3CACHE(cCampo,"X3_PICTURE"), X3Titulo() } ) 
	
		Next Loop
	Endif

	RestArea( aAreaSX3 )
	RestArea( aAreaSB1 )
	RestArea( aAreaAtu )

Return aRetFun