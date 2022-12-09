#INCLUDE "PROTHEUS.CH"
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
User Function MIMPOP 

	Local nOpcA       := 0
	Local aSays       := {}
	Local aButtons    := {}
	Local cCadastro   := "Ordem De Operação"
	Local cPerg       := "MIMPOPA"
	Local aPergs := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MIMPOP" , __cUserID )

	aAdd( aPergs, { "Tipo de Ordem de Operac.?","                         ","                         ","mv_ch1","N",01,0,0,"C","","mv_par01","Carga","Carga","Carga","","","Descarga","Descarga","Descarga","","","","","","","","","","","","","","","","","",""})
	
	Pergunte( cPerg, .F.)

	aAdd( aSays, "Essa rotina gera a Ordem de Operação para Carga e Descarga" )
	aAdd( aSays, "Especifico - "+SM0->M0_NOMECOM )

	aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
	aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
	aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1
		Processa( { || MIMPOPProc( mv_par01 ) }, "Gerando Relatório..." )
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
Static Function MIMPOPProc( nOperacao )

	Local cPerg	 := ""
	Local aPergs := {}

	If nOperacao == 1
		cPerg := "MIMPOPB"
		aAdd( aPergs, { "Carga De                ?","                         ","                         ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd( aPergs, { "Carga Até               ?","                         ","                         ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd( aPergs, { "Data De                 ?","                         ","                         ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd( aPergs, { "Data Até                ?","                         ","                         ","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Else
		cPerg := "MIMPOPC"
		aAdd( aPergs, { "Serie da NF             ?","                         ","                         ","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd( aPergs, { "Nota Inicial            ?","                         ","                         ","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd( aPergs, { "Nota Final              ?","                         ","                         ","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd( aPergs, { "Produto De              ?","                         ","                         ","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
		aAdd( aPergs, { "Produto Ate             ?","                         ","                         ","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
	Endif

	If Pergunte( cPerg, .T.)
		MIMPOPExec( nOperacao )
	Else
		MsgStop( "Operação Cancelada" )
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
Static Function MIMPOPExec( nOperacao )

	Local aAreaAtu 	:= GetArea() 
	Local cQuery 	:= ""
	Local nCount	:= 0
	Local nRegAtu	:= 0
	Local nLoop		:= 0

	Local oWord    	:= Nil
	Local cPathCli 	:= GetTempPath(.T.)
	Local lImprime	:= Aviso( "Impressão Ordem Operação", "Deseja visualizar ou imprimir?", { "Visualizar", "Imprimir" }, 1 ) == 2
	Local nCopias	:= 1

	Local aDados	:= Array( 5, 5 )

	If nOperacao == 1

		cQuery := "SELECT DISTINCT DAK_COD "
		cQuery += "  FROM " + RetSQLName( "DAK" )
		cQuery += " WHERE DAK_FILIAL = '" + xFilial( "DAK" ) + "' "
		cQuery += "   AND DAK_COD    BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
		cQuery += "   AND DAK_DATA   BETWEEN '" + DtoS( MV_PAR03 ) + "' AND '" + DtoS( MV_PAR04 ) + "' "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		If Select( "TMP_DAK_A" ) > 0
			TMP_DAK_A->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_DAK_A", .T., .F. )
		TMP_DAK_A->( dbGoTop() )
		TMP_DAK_A->( dbEval( { || nCount++ } ) )
		TMP_DAK_A->( dbGoTop() )

		If Empty( nCount )
			MsgStop( "Não existem dados para processamento. Verifique os paramentros" )
			TMP_DAK_A->( dbCloseArea() )
			RestArea( aAreaAtu )
			Return
		Endif

		While TMP_DAK_A->( !Eof() )

			nRegAtu++
			IncProc( "Processando Registro " + AlLTrim( Str( nRegAtu ) ) + " de " + AllTrim( Str( nCount ) ) )

			cQuery := "SELECT DISTINCT DAK_COD, DAK_SEQCAR, DAI_SEQUEN, DAK_DATA, A1_NOME, A2_NOME, DA3_PLACA, C9_PEDIDO, C9_PRODUTO, B1_DESC, C9_QTDLIB, C9_QTDLIB2 "
			cQuery += "  FROM " + RetSQLName( "DAK" ) + " DAK "
			cQuery += "  JOIN " + RetSQLName( "DAI" ) + " DAI ON DAI_FILIAL = '" + xFilial( "DAI" ) + "' AND DAI_COD   = DAK_COD    AND DAI_SEQCAR = DAK_SEQCAR AND DAI.D_E_L_E_T_ = ' ' "
			cQuery += "  JOIN " + RetSQLName( "DA3" ) + " DA3 ON DA3_FILIAL = '" + xFilial( "DA3" ) + "' AND DA3_COD   = DAK_CAMINH AND DA3.D_E_L_E_T_ = ' ' "
			cQuery += "  JOIN " + RetSQLName( "SA1" ) + " SA1 ON A1_FILIAL  = '" + xFilial( "SA1" ) + "' AND A1_COD    = DAI_CLIENT AND A1_LOJA = DAI_LOJA AND SA1.D_E_L_E_T_ = ' ' "
			cQuery += "  JOIN " + RetSQLName( "SA2" ) + " SA2 ON A1_FILIAL  = '" + xFilial( "SA2" ) + "' AND A2_COD    = DA3_CODFOR AND A2_LOJA = DA3_LOJFOR AND SA2.D_E_L_E_T_ = ' ' "
			cQuery += "  JOIN " + RetSQLName( "SC9" ) + " SC9 ON C9_FILIAL  = '" + xFilial( "SC9" ) + "' AND C9_PEDIDO = DAI_PEDIDO AND SC9.D_E_L_E_T_ = ' ' "
			cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL  = '" + xFilial( "SB1" ) + "' AND B1_COD    = C9_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
			cQuery += " WHERE DAK_FILIAL = '" + xFilial( "DAK" ) + "' "
			cQuery += "   AND DAK_COD    = '" + TMP_DAK_A->DAK_COD + "' "
			cQuery += "   AND DAK.D_E_L_E_T_ = ' ' "
			cQuery += " ORDER BY DAK_COD, DAK_SEQCAR, DAI_SEQUEN "
			If Select( "TMP_DAK_B" ) > 0
				TMP_DAK_B->( dbCloseArea() )
			Endif
			dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_DAK_B", .T., .F. )

			If TMP_DAK_B->( !Eof() )

				If File( cPathCli + StrZero( nRegAtu, 3 ) + "ORDOPERC.dot" )
					fErase( cPathCli + StrZero( nRegAtu, 3 ) + "ORDOPERC.dot" )
				Endif

				Copy File ORDOPERC.dot to ( cPathCli + StrZero( nRegAtu, 3 ) + "ORDOPERC.dot" )

				oWord := OLE_CreateLink( 'TMsOleWord97' )
				OLE_SetProperty( oWord, 206, .F. )
				OLE_OpenFile( oWord, cPathCli + StrZero( nRegAtu, 3 ) + "ORDOPERC.dot" )

				dDataEmis 	:= StoD( TMP_DAK_B->DAK_DATA )
				cTransp	  	:= AllTrim( TMP_DAK_B->A2_NOME )
				cPlaca		:= AllTrim( TMP_DAK_B->DA3_PLACA )

				nLoop := 1
				While TMP_DAK_B->( !Eof() ) .and. nLoop <= 5

					aDados[nLoop][1] := AllTrim( TMP_DAK_B->A1_NOME )
					aDados[nLoop][2] := AllTrim( TMP_DAK_B->B1_DESC )
					aDados[nLoop][3] := AllTrim( Transform( TMP_DAK_B->C9_QTDLIB, "@E 999,999,999,999.99" ) )
					aDados[nLoop][4] := AllTrim( Transform( TMP_DAK_B->C9_QTDLIB2, "@E 999,999,999,999.99" ) )
					aDados[nLoop][5] := TMP_DAK_B->C9_PRODUTO
					nLoop++

					TMP_DAK_B->( dbSkip() )
				End

				TMP_DAK_B->( dbCloseArea() )

				OLE_SetDocumentVar( oWord, "dDataEmis"	, dDataEmis )
				OLE_SetDocumentVar( oWord, "cTransp"	, cTransp )
				OLE_SetDocumentVar( oWord, "cPlaca"		, cPlaca )

				For nLoop := 1 To 5
					OLE_SetDocumentVar( oWord, "cCliente" + AllTrim( Str( nLoop ) ), aDados[nLoop][1] )
					OLE_SetDocumentVar( oWord, "cProduto" + AllTrim( Str( nLoop ) ), aDados[nLoop][2] )

					If AllTrim( Posicione( "SB1", 1, xFilial( "SB1" ) + aDados[nLoop][5], "B1_UM" ) ) == "L
						OLE_SetDocumentVar( oWord, "cQuantL" + AllTrim( Str( nLoop ) ), aDados[nLoop][3] )
						OLE_SetDocumentVar( oWord, "cQuantK" + AllTrim( Str( nLoop ) ), aDados[nLoop][4] )
					Else
						OLE_SetDocumentVar( oWord, "cQuantL" + AllTrim( Str( nLoop ) ), aDados[nLoop][4] )
						OLE_SetDocumentVar( oWord, "cQuantK" + AllTrim( Str( nLoop ) ), aDados[nLoop][3] )
					Endif
				Next nLoop

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
					ShellExecute("Open", StrZero( nRegAtu, 3 ) + "ORDOPERC.dot","", cPathCli, 3 )
				EndIf

			Endif        

			TMP_DAK_A->( dbSkip() )
		End

		TMP_DAK_A->( dbCloseArea() )

	Else
		cQuery := "SELECT D1_DTDIGIT, D1_DOC, A2_NOME, D1_LOTECTL, D1_DFABRIC, D1_DTVALID, D1_COD, B1_DESC, D1_QUANT, D1_QTSEGUM "
		cQuery += "  FROM " + RetSQLName( "SD1" ) + " SD1 "
		cQuery += "  JOIN " + RetSQLName( "SA2" ) + " SA2 ON A2_FILIAL = '" + xFilial( "SA2" ) + "' AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND SA2.D_E_L_E_T_ = ' ' "
		cQuery += "  JOIN " + RetSQLname( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = D1_COD AND SB1.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE D1_FILIAL  = '" + xFilial( "SD1" ) + "' "
		cQuery += "   AND D1_SERIE   = '" + MV_PAR01 + "' "
		cQuery += "   AND D1_DOC     BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
		cQuery += "   AND D1_COD     BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
		cQuery += "   AND SD1.D_E_L_E_T_ = ' ' "
		If Select( "TMP_OOP" ) > 0
			TMP_OOP->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_OOP", .T., .F. )
		TMP_OOP->( dbGoTop() )
		TMP_OOP->( dbEval( { || nCount++ } ) )
		TMP_OOP->( dbGoTop() )

		If Empty( nCount )
			MsgStop( "Não existem dados para processamento. Verifique os paramentros" )
			TMP_OOP->( dbCloseArea() )
			RestArea( aAreaAtu )
			Return
		Endif

		While TMP_OOP->( !Eof() )

			nRegAtu++
			IncProc( "Processando Registro " + AlLTrim( Str( nRegAtu ) ) + " de " + AllTrim( Str( nCount ) ) )

			If File( cPathCli + StrZero( nRegAtu, 3 ) + "ORDOPERD.dot" )
				fErase( cPathCli + StrZero( nRegAtu, 3 ) + "ORDOPERD.dot" )
			Endif

			Copy File ORDOPERD.dot to ( cPathCli + StrZero( nRegAtu, 3 ) + "ORDOPERD.dot" )

			oWord := OLE_CreateLink( 'TMsOleWord97' )
			OLE_SetProperty( oWord, 206, .F. )
			OLE_OpenFile( oWord, cPathCli + StrZero( nRegAtu, 3 ) + "ORDOPERD.dot" )

			OLE_SetDocumentVar( oWord, "D1_DTDIGIT"	, StoD( TMP_OOP->D1_DTDIGIT ) )
			OLE_SetDocumentVar( oWord, "D1_DOC"		, AllTrim( TMP_OOP->D1_DOC ) )
			OLE_SetDocumentVar( oWord, "A2_NOME"	, AllTrim( TMP_OOP->A2_NOME ) )
			OLE_SetDocumentVar( oWord, "D1_LOTECTL"	, AllTrim( TMP_OOP->D1_LOTECTL ) )
			OLE_SetDocumentVar( oWord, "D1_DTFABRI"	, StoD( TMP_OOP->D1_DFABRIC ) )
			OLE_SetDocumentVar( oWord, "D1_DTVALID"	, StoD( TMP_OOP->D1_DTVALID ) )
			OLE_SetDocumentVar( oWord, "D1_COD"		, AllTrim( TMP_OOP->D1_COD ) )
			OLE_SetDocumentVar( oWord, "B1_DESC"	, AllTrim( TMP_OOP->B1_DESC ) )
			OLE_SetDocumentVar( oWord, "D1_QUANT"	, Transform( TMP_OOP->D1_QUANT, "@E 999,999,999,999.99" ) )
			OLE_SetDocumentVar( oWord, "D1_QTSEGUM"	, Transform( TMP_OOP->D1_QTSEGUM, "@E 999,999,999,999.99" ) )

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
				ShellExecute("Open", StrZero( nRegAtu, 3 ) + "ORDOPERD.dot","", cPathCli, 3 )
			EndIf

			TMP_OOP->( dbSkip () )
		End

		TMP_OOP->( dbCloseArea() )
	Endif

	RestArea( aAreaAtu )

Return
