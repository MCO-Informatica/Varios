#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MIMPOF    ºAutor  ³Microsiga           º Data ³  XX/XX/XX   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MIMPOF 

	Local nOpcA     := 0
	Local aSays     := {}
	Local aButtons  := {}
	Local cCadastro	:= "Ordem De Fracionamento"
	Local cPerg     := "MIMPOF"
	Local aPergs 	:= {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MIMPOF" , __cUserID )

	aAdd( aPergs, { "Ordem de Produção De    ?","                         ","                         ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2",""})
	aAdd( aPergs, { "Ordem de Produção Até   ?","                         ","                         ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC2",""})
	aAdd( aPergs, { "Data De                 ?","                         ","                         ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd( aPergs, { "Data Até                ?","                         ","                         ","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	Pergunte( cPerg, .F.)

	aAdd( aSays, "Essa rotina gera a Ordem de Fracionamento" )
	aAdd( aSays, "Especifico - "+SM0->M0_NOMECOM )

	aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
	aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
	aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1
		Processa( { || MIMPOPProc() }, "Gerando Relatório..." )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MIMPOP    ºAutor  ³Microsiga           º Data ³  XX/XX/XX   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MIMPOPProc()

	Local aAreaAtu 	:= GetArea() 
	Local cQuery 	:= ""
	Local nCount	:= 0
	Local nRegAtu	:= 0
	Local nLoop		:= 0

	Local oWord    	:= Nil
	Local cPathCli 	:= GetTempPath(.T.)
	Local lImprime	:= Aviso( "Impressão Ordem Fracionamento", "Deseja visualizar ou imprimir?", { "Visualizar", "Imprimir" }, 1 ) == 2
	Local nCopias	:= 1

	cQuery := "SELECT DISTINCT C2_NUM "
	cQuery += "  FROM " + RetSQLName( "SC2" )
	cQuery += " WHERE C2_FILIAL  = '" + xFilial( "SC2" ) + "' "
	cQuery += "   AND C2_NUM     BETWEEN '" + mv_par01 + "' and '" + mv_par02 + "' "
	cQuery += "   AND C2_EMISSAO BETWEEN '" + DtoS( mv_par03 ) + "' AND '" + DtoS( mv_par04 ) + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	If Select( "TMP_SC2" ) > 0
		TMP_SC2->( dbCloseArea() )
	Endif

	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SC2", .T., .F. )
	TMP_SC2->( dbGoTop() )
	TMP_SC2->( dbEval( { || nCount++ } ) )
	TMP_SC2->( dbGoTop() )

	If Empty( nCount )
		MsgStop( "Não existem dados para processamento. Verifique os paramentros" )
		TMP_SC2->( dbCloseArea() )
		RestArea( aAreaAtu )
		Return
	Endif

	While TMP_SC2->( !Eof() )

		cQuery := "SELECT DISTINCT D4_OP, D4_DATA, C2_PRODUTO, SB1A.B1_DESC DESC1, SZ2A.Z2_DESC EMB1, D4_COD, SB1B.B1_DESC DESC2, SZ2B.Z2_DESC EMB2, D3_LOTECTL, D3_DTFABRI, D3_DTVALID, D4_QTDEORI "
		cQuery += "  FROM " + RetSQLName( "SC2" ) + " SC2 "
		cQuery += " INNER JOIN " + RetSQLName( "SD4" ) + " SD4  ON D4_FILIAL = '" + xFilial( "SD4" ) + "' AND D4_OP = C2_NUM || C2_ITEM || C2_SEQUEN AND SD4.D_E_L_E_T_ = ' ' "
		cQuery += " INNER JOIN " + RetSQLName( "SB1" ) + " SB1A ON SB1A.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1A.B1_COD = C2_PRODUTO AND SB1A.D_E_L_E_T_ = ' ' "
		cQuery += " INNER JOIN " + RetSQLName( "SB1" ) + " SB1B ON SB1B.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1B.B1_COD = D4_COD AND SB1B.D_E_L_E_T_ = ' ' "
		cQuery += " INNER JOIN " + RetSQLName( "SZ2" ) + " SZ2A ON SZ2A.Z2_FILIAL = '" + xFilial( "SZ2" ) + "' AND SZ2A.Z2_COD = SB1A.B1_EMB AND SZ2A.D_E_L_E_T_ = ' ' "
		cQuery += " INNER JOIN " + RetSQLName( "SZ2" ) + " SZ2B ON SZ2B.Z2_FILIAL = '" + xFilial( "SZ2" ) + "' AND SZ2B.Z2_COD = SB1B.B1_EMB AND SZ2B.D_E_L_E_T_ = ' ' "
		cQuery += "  LEFT JOIN " + RetSQLName( "SD3" ) + " SD3  ON D3_FILIAL = '" + xFilial( "SD3" ) + "' AND SUBSTR( D3_COD,1, 9 ) = SUBSTR( D4_COD,1, 9 ) AND D3_OP = D4_OP AND D3_LOTECTL != ' ' AND D3_DTFABRI != ' ' AND D3_DTVALID != ' '  AND SD3.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE C2_FILIAL  = '" + xFilial( "SC2" ) + "' "
		cQuery += "   AND C2_NUM     = '" + TMP_SC2->C2_NUM + "' "
		cQuery += "   AND SC2.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY D3_LOTECTL"
		If Select( "TMP_OF" ) > 0
			TMP_OF->( dbCloseArea() )
		Endif

		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_OF", .T., .F. )

		If TMP_OF->( !Eof() )

			nRegAtu++
			IncProc( "Processando Registro " + AlLTrim( Str( nRegAtu ) ) + " de " + AllTrim( Str( nCount ) ) )

			If File( cPathCli + StrZero( nRegAtu, 3 ) + "ORDFRAC.dot" )
				fErase( cPathCli + StrZero( nRegAtu, 3 ) + "ORDFRAC.dot" )
			Endif

			Copy File ORDFRAC.dot to ( cPathCli + StrZero( nRegAtu, 3 ) + "ORDFRAC.dot" )

			oWord := OLE_CreateLink( 'TMsOleWord97' )
			OLE_SetProperty( oWord, 206, .F. )
			OLE_OpenFile( oWord, cPathCli + StrZero( nRegAtu, 3 ) + "ORDFRAC.dot" )

			cNumOP 	:= AllTrim( TMP_OF->D4_OP )
			dDataOP	:= StoD( TMP_OF->D4_DATA )
			cProd	:= AllTrim( TMP_OF->DESC1 )
			cEmbOri	:= AllTrim( TMP_OF->EMB2 )
			dFabric	:= StoD( TMP_OF->D3_DTFABRI )
			cLote	:= AllTrim( TMP_OF->D3_LOTECTL )
			dValid	:= StoD( TMP_OF->D3_DTVALID )

			TMP_OF->( dbSkip () )

			cDesEmb	:= AllTrim( TMP_OF->EMB1 )
			nPesLiq	:= TMP_OF->D4_QTDEORI
			nQuant	:= TMP_OF->D4_QTDEORI

			OLE_SetDocumentVar( oWord, "cNumOP"	, cNumOP )
			OLE_SetDocumentVar( oWord, "dDataOP", dDataOP )
			OLE_SetDocumentVar( oWord, "cProd"	, cProd )
			OLE_SetDocumentVar( oWord, "cEmbOri", cEmbOri )
			OLE_SetDocumentVar( oWord, "dFabric", dFabric )
			OLE_SetDocumentVar( oWord, "cLote"	, cLote )
			OLE_SetDocumentVar( oWord, "dValid"	, dValid )
			OLE_SetDocumentVar( oWord, "cDesEmb", cDesEmb )
			OLE_SetDocumentVar( oWord, "nPesLiq", Transform( nPesLiq, "@E 999,999,999,999.99" ) )
			OLE_SetDocumentVar( oWord, "nQuant"	, Transform( nQuant, "@E 999,999,999,999.99" ) )

			OLE_UpDateFields( oWord )

			If lImprime
				OLE_PrintFile( oWord, "ALL", , ,nCopias )
				Sleep( 1000 )
				OLE_CloseFile( oWord )
				OLE_CloseLink( oWord )
			Else
				OLE_SaveFile( oWord )
				OLE_CloseFile( oWord )
				OLE_CloseLink( oWord )
				ShellExecute("Open", StrZero( nRegAtu, 3 ) + "ORDFRAC.dot","", cPathCli, 3 )
			EndIf

		Endif

		TMP_OF->( dbCloseArea() )

		TMP_SC2->( dbSkip() )
	End

	TMP_SC2->( dbCloseArea() )

	RestArea( aAreaAtu )

Return