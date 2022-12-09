#Include 'Protheus.ch'
//---------------------------------------------------------------------
// Rotina | CSFA410      | Autor | Robson Gonçalves | Data | 23.05.2014               
//---------------------------------------------------------------------                                     
// Descr. | Rotina para exportar os registros de lançamentos contábeis
//        | quando solicitado pela auditoria.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
STATIC c410RetPath := ''
User Function CSFA410()
	Local nOpc := 0
	Local nRecNo := 0

	Local cAnoIni := ''
	Local cAnoFim := ''
	Local cPerg := 'CSF410'
	Local cMV_410_01 := 'MV_410_01'
	
	Local aSay := {}
	Local aButton := {}

	Local aPar := {}
	Local aRet := {}
	Local aMes := {'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'}

	Local bOK := {|| MsgYesNo('Confirma o início do processamento?', cCadastro ) }

	Private cCadastro := 'Exportar Lançamentos Contábeis'

	AAdd( aSay, 'Rotina para exportar os dados dos lançamentos contábeis conforme os parâmetros')
	AAdd( aSay, 'informados a seguir. O arquivo será gerado com a nomenclatura CTBAAAAMMS.csv, onde ' )
	AAdd( aSay, 'CTB=Contabilidade, AAAA=Ano, MM=Mês e S=Sequencia do mês. Por compatibilidade ' )
	AAdd( aSay, 'será gerado um arquivo para cada mês, porém se houver mais de um milhão de registros ' )
	AAdd( aSay, 'no mês, a rotina irá gerar mais de uma arquivo por mês.' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir.')

	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )

	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		A410CriaSXB( cPerg )

		CT2->( dbSetOrder( 1 ) )
		nRecNo := CT2->( RecNo() )
		CT2->( dbGoTop() )
		cAnoIni := StrZero( Year( CT2->CT2_DATA ), 4, 0 )
		CT2->( dbGoBottom() )
		cAnoFim := StrZero( Year( CT2->CT2_DATA ), 4, 0 )
		CT2->( dbGoTo( nRecNo ) )

		AAdd( aPar, { 2, 'A partir do mês'      , 1, aMes, 50, '', .T.} )
		AAdd( aPar, { 2, 'Até o mês'            , 1, aMes, 50, '', .T.} )
		AAdd( aPar, { 1, 'A partir do ano'      , Space(4),'','(mv_par03>="'+cAnoIni+'")', '', '', 50, .T. } )
		AAdd( aPar, { 1, 'Até o ano'            , Space(4),'','(mv_par04<="'+cAnoFim+'".And.mv_par04>=mv_par03)', '', '', 50, .T. } )
		AAdd( aPar, { 1, 'Da conta contábil'    , Space(20),'','', 'CT1', '',60, .F. } )
		AAdd( aPar, { 1, 'Até a conta contábil' , Space(20),'','', 'CT1', '',60, .T. } )
		AAdd( aPar, { 1, 'Tipo de Saldo'        , Space(01),'','', 'SLD', '',60, .T. } )
		AAdd( aPar, { 1, 'Onde salvar o arquivo', Space(90),'','', cPerg, '',110, .T. } )

		If ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.T.,.T.)
		
			If .NOT. GetMv( cMV_410_01, .T. )
				CriarSX6( cMV_410_01, 'N', 'USO DFA VERSÃO DO SISTEMA. 0=SEEK+WHILE E 1=QUERY', '1' )
			Endif
			
			If GetMv( cMV_410_01, .F. ) == 0
				MsAguarde({|| A410Proc1( aRet, aMes )},cCadastro,'Aguarde, lendo registro para exportar',.F.)
			Else
				MsAguarde({|| A410Proc2( aRet, aMes )},cCadastro,'Aguarde, lendo registro para exportar',.F.)
			Endif
			
		Endif
	Endif
Return

//---------------------------------------------------------------------
// Rotina | A410Proc1    | Autor | Robson Gonçalves | Data | 23.05.2014
//---------------------------------------------------------------------
// Descr. | Rotina de processamento para gerar o arquivo xml.
//        |
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A410Proc1( aRet, aMes )
	Local lIgual := .F.
	Local lVazio := .F.

	Local cSQL := ''
	Local cTRB := ''
	Local cCT2FILIAL := ''
	Local cIncProc := ''
	Local cUserI := ''
	Local cUserA := ''
	Local cDateI := ''
	Local cDateA := ''
	Local cUserCodeI := ''
	Local cUserNameI := ''
	Local cUserCodeA := ''
	Local cUserNameA := ''
	Local cTipoLanc := ''
	Local cCT2_MANUAL := ''
	
	Local cDirDestino := RTrim( aRet[ 8 ] )

	Local nI := 0
	Local nP := 0
	Local nMes := 0
	Local nAno := 0
	Local nCount := 0
	Local nMinus := 0
	Local nMesIni := 0
	Local nMesFim := 0

	Local dDataIni := Ctod( Space( 8 ) )
	Local dDataFim := Ctod( Space( 8 ) )

	Local aArea := {}
	Local aUser := {}

	Local cLOG := ''
	Local cArqLog := CriaTrab( NIL, .F. ) + '.txt'
	Local cNomArq := ''
	Local nSeqArq := 1
	Local nRegistros := 1
	Local cMes := ''
	Local cAno := ''
	Local nHdl := 0
	Local cHeader := ''
	Local aFiles := {}
	Local cSystem := GetSrvProfString("Startpath","")
	Local cPicture := PesqPict('CT2','CT2_VALOR')
	Local cTotalReg := ''

	cHeader := 'Log de inclusão;'+;
				  'Código e nome do usuário;'+;
				  'Log de alteração;'+;
				  'Código e nome do usuário;'+;
				  'Lote;'+;
				  'Documento;'+;
				  'Linha;'+;
				  'Tipo de inserção;'+;
				  'Histórico;'+;
				  'Tipo do lançamento;'+;
				  'Conta débito;'+;
				  'Conta crédito;'+;
				  'Valor;'+;
				  'Data lançamento'+;
				  'Tipo Saldo'

	cCT2FILIAL := xFilial( 'CT2' )

	nMesIni := Iif( ValType( aRet[ 1 ] ) == 'N',aRet[ 1 ], AScan( aMes, {|e| e==aRet[ 1 ] } ) )
	nMesFim := Iif( ValType( aRet[ 2 ] ) == 'N',aRet[ 2 ], AScan( aMes, {|e| e==aRet[ 2 ] } ) )

	dDataIni := Ctod( '01/'+Str( nMesIni )+ '/' + aRet[ 3 ] )
	dDataFim := LastDay( Ctod( '01/'+Str( nMesFim )+ '/' + aRet[ 4 ] ) )

	cSQL := "SELECT COUNT(*) CT2_COUNT "
	cSQL += "FROM  " + RetSQLName( "CT2" ) + " CT2 "
	cSQL += "WHERE  CT2_FILIAL = " + ValToSql( xFilial( "CT2" ) )
	CSQL += "       AND CT2_DATA BETWEEN " + ValToSql( dDataIni ) + " AND " + ValToSql( dDataFim ) + " "
	cSQL += "	       AND CT2_MOEDLC = '01' "
	cSQL += "	       AND CT2_DC <> '4' "
	cSQL += "       AND D_E_L_E_T_ = ' ' "

	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, preparando o início da exportação...')
 	nCount := (cTRB)->(CT2_COUNT)
 	(cTRB)->( dbCloseArea() )
 	nMinus := nCount

	cTotalReg := LTrim( Str( nCount ) )

	aArea := CT2->( GetArea() )
	CT2->( dbSetOrder( 1 ) )
	CT2->( dbSeek( cCT2FILIAL + Dtos( dDataIni ) ) )

	While CT2->( .NOT. EOF() ) .And. CT2->CT2_FILIAL == cCT2FILIAL .And. CT2->CT2_DATA <= dDataFim
		nRegistros := 1
		
		nMes := Month( CT2->CT2_DATA )
		nAno := Year( CT2->CT2_DATA )

		cMes := StrZero( nMes, 2 )
		cAno := StrZero( nAno, 4, 0 )

		cIncProc := cMes + '/' + cAno

		cNomArq := 'CTB' + cAno + cMes + RTrim( Str( nSeqArq, 1, 0 ) ) + '.csv'

		If File( cNomArq )
			FRename( cNomArq, 'bkp_'+cNomArq )
			Sleep( 500 )
		Endif

		nHdl := FCreate( cNomArq )

		AAdd( aFiles, cNomArq )

		If nSeqArq > 1
			FWrite( nHdl, 'Continuação do arquivo anterior:' + Left( cNomArq, 9 ) + '...' + CRLF )
		Endif

		FWrite( nHdl, cHeader + CRLF )

		While .NOT. CT2->( EOF() ) .And. CT2->CT2_FILIAL == cCT2FILIAL .And. nMes == Month( CT2->CT2_DATA ) .And. nAno == Year( CT2->CT2_DATA ) .And. nRegistros <= 1000000
			MsProcTxt( 'Per:' + cIncProc + '. Total:' + cTotalReg + ' ,Faltam:' + LTrim( Str( nMinus ) ) )
   			ProcessMessage()
			nMinus--

			If ( ( CT2->CT2_DEBITO < aRet[ 5 ]  .Or. CT2->CT2_DEBITO > aRet[ 6 ] ) .And. ( CT2->CT2_CREDIT < aRet[ 5 ] .Or. CT2->CT2_CREDIT > aRet[ 6 ] ) );
				.OR. .NOT. ( CT2->CT2_MOEDLC == '01' )
			   CT2->( dbSkip() )
			   Loop
			Endif


			If ( CT2->CT2_TPSALD <> aRet[ 7 ] )
			   CT2->( dbSkip() )
			   Loop
			Endif


			//+-------------------------------------------------------------------------------+
			//| A variável lIgual é para diminuir a chamada da função FwLeUserLg.             |
			//| Caso o LOG de inclusão e alteração sejam iguais executar uma vez para o user. |
			//+-------------------------------------------------------------------------------+
			lIgual := ( CT2->CT2_USERGI == CT2->CT2_USERGA )

			If .NOT. lIgual
				lVazio := Empty( CT2->CT2_USERGA )
			Endif

			cUserI := RTrim( FwLeUserLg( 'CT2_USERGI' ) )
			cDateI := FwLeUserLg( 'CT2_USERGI', 2 )

			If lIgual
				cUserA := cUserI
				cDateA := FwLeUserLg( 'CT2_USERGA', 2 )
			Else
				If .NOT. lVazio
					cUserA := RTrim( FwLeUserLg( 'CT2_USERGA' ) )
					cDateA := FwLeUserLg( 'CT2_USERGA', 2 )
				Else
					cUserA := ''
					cDateA := ''
				Endif
			Endif

			nP := AScan( aUser, {|p| p[ 1 ] == cUserI } )
			If nP == 0
				A410UserCode( cUserI, @cUserCodeI, @cUserNameI )
				AAdd( aUser, { cUserI, cUserCodeI, cUserNameI } )
			Else
				cUserCodeI := aUser[ nP, 2 ]
				cUserNameI := aUser[ nP, 3 ]
			Endif

			If lIgual
				cUserCodeA := cUserCodeI
				cUserNameA := cUserNameI
			Else
				If .NOT. lVazio
					nP := AScan( aUser, {|p| p[ 1 ] == cUserA } )
					If nP == 0
						A410UserCode( cUserA, @cUserCodeA, @cUserNameA )
						AAdd( aUser, { cUserA, cUserCodeA, cUserNameA } )
					Else
						cUserCodeA := aUser[ nP, 2 ]
						cUserNameA := aUser[ nP, 3 ]
					Endif
				Else
					cUserCodeA := ''
					cUserNameA := ''
				Endif
			Endif

			cCT2_MANUAL := Iif( CT2->CT2_MANUAL == '1', 'MANUAL', 'AUTOMÁTICO' )

			cTipoLanc :=   Iif( CT2->CT2_DC == '1', 'DÉBITO',;
								Iif( CT2->CT2_DC == '2', 'CRÉDITO',;
								Iif( CT2->CT2_DC == '3', 'PARTIDA DOBRADA',;
								Iif( CT2->CT2_DC == '4', 'CONTINUAÇÃO DE HISTÓRICO',;
								Iif( CT2->CT2_DC == '5', 'RATEIO','LAÇAMENTO PADRÃO')))))

			cDados := 	cUserI     + ' ' + cDateI     + ';' + ;
							cUserCodeI + ' ' + cUserNameI + ';' + ;
							cUserA     + ' ' + cDateA     + ';' + ;
							cUserCodeA + ' ' + cUserNameA + ';' + ;
							CT2->CT2_LOTE       + ';' + ;
							CT2->CT2_DOC        + ';' + ;
							CT2->CT2_LINHA      + ';' + ;
							cCT2_MANUAL         + ';' + ;
							StrTran(CT2->CT2_HIST,';','') + ';' + ;
							cTipoLanc           + ';' + ;
							CT2->CT2_DEBITO     + ';' + ;
							CT2->CT2_CREDITO    + ';' + ;
							TransForm( CT2->CT2_VALOR, cPicture ) + ';' + ;
							Dtoc( CT2->CT2_DATA ) + ';' + ;
							CT2->CT2_TPSALD

			FWrite( nHdl, cDados + CRLF )

			CT2->( dbSkip() )

			nRegistros++			
		End
		
		If nRegistros > 1000000
			nSeqArq++
			FClose( nHdl )
			Sleep( 500 )
		Else
			nSeqArq := 1	
		Endif		
	End
	
	FClose( nHdl )
	Sleep( 500 )
	CT2->( RestArea( aArea ) )

	nHdl := FCreate( cArqLog )

	For nI := 1 To Len( aFiles )
		If File( aFiles[ nI ] )
			If __CopyFile( aFiles[ nI ], cDirDestino + aFiles[ nI ] )
				If File( cDirDestino + aFiles[ nI ] )
					cLOG := 'Arquivo ' + aFiles[ nI ] + ' gerado e copiado com sucesso no destino ' + cDirDestino
					FErase( aFiles[ nI ] )
				Else
					cLOG := 'Não localizei o arquivo no destino ' + cDirDestino
				Endif
			Else
				cLOG := 'Não consegui copiar o arquivo de ' + cSystem + ' para ' + cDirDestino
			Endif
		Else
			cLOG := 'Não localizei o arquivo em ' + cSystem + aFiles[ nI ]
		Endif

		FWrite( nHdl, cLOG + CRLF )
	Next nI

	FClose( nHdl )

	__CopyFile( cArqLog, cDirDestino + cArqLog )

	FErase( cArqLog )

	//ShellExecute("open", cDirDestino + cArqLog,"",cDirDestino, 1 )

	MsgInfo('Processamento finalizado...')
Return

//---------------------------------------------------------------------
// Rotina | A410Proc2    | Autor | Robson Gonçalves | Data | 23.05.2014
//---------------------------------------------------------------------
// Descr. | Rotina de processamento para gerar o arquivo xml.
//        |
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A410Proc2( aRet, aMes )
	Local lIgual := .F.
	Local lVazio := .F.

	Local cSQL := ''
	Local cTRB := ''
	Local cIncProc := ''
	Local cUserI := ''
	Local cUserA := ''
	Local cDateI := ''
	Local cDateA := ''
	Local cUserCodeI := ''
	Local cUserNameI := ''
	Local cUserCodeA := ''
	Local cUserNameA := ''
	Local cTipoLanc := ''

	Local cDirDestino := RTrim( aRet[ 8 ] )

	Local nI := 0
	Local nP := 0
	Local nMes := 0
	Local nAno := 0
	Local nCount := 0
	Local nMinus := 0
	Local nMesIni := 0
	Local nMesFim := 0

	Local dDataIni := Ctod( Space( 8 ) )
	Local dDataFim := Ctod( Space( 8 ) )

	Local aArea := {}
	Local aUser := {}

	Local cLOG := ''
	Local cArqLog := CriaTrab( NIL, .F. ) + '.txt'
	Local cNomArq := ''
	Local nSeqArq := 1
	Local nRegistros := 1
	Local cMes := ''
	Local cAno := ''
	Local nHdl := 0
	Local cHeader := ''
	Local aFiles := {}
	Local cSystem := GetSrvProfString("Startpath","")
	Local cPicture := PesqPict('CT2','CT2_VALOR')
	Local cTotalReg := ''

	cHeader := 'Log de inclusão;'+;
				  'Código e nome do usuário;'+;
				  'Log de alteração;'+;
				  'Código e nome do usuário;'+;
				  'Lote;'+;
				  'Documento;'+;
				  'Linha;'+;
				  'Tipo de inserção;'+;
				  'Histórico;'+;
				  'Tipo do lançamento;'+;
				  'Conta débito;'+;
				  'Conta crédito;'+;
				  'Valor;'+;
				  'Data lançamento;'+;
				  'Tipo Saldo'

	cCT2FILIAL := xFilial( 'CT2' )

	nMesIni := Iif( ValType( aRet[ 1 ] ) == 'N',aRet[ 1 ], AScan( aMes, {|e| e==aRet[ 1 ] } ) )
	nMesFim := Iif( ValType( aRet[ 2 ] ) == 'N',aRet[ 2 ], AScan( aMes, {|e| e==aRet[ 2 ] } ) )

	dDataIni := Ctod( '01/'+Str( nMesIni )+ '/' + aRet[ 3 ] )
	dDataFim := LastDay( Ctod( '01/'+Str( nMesFim )+ '/' + aRet[ 4 ] ) )

	cSQL := "SELECT CT2_USERGI, "
	cSQL += "       CT2_USERGA, "
	cSQL += "       CT2_LOTE, "
	cSQL += "       CT2_DOC, "
	cSQL += "       CT2_LINHA, "
	
	cSQL += "       CASE "
	cSQL += "       WHEN CT2_MANUAL = '1' THEN 'MANUAL' "
	cSQL += "       WHEN CT2_MANUAL = '2' THEN 'AUTOMATICO' "
	cSQL += "       END AS CT2_MANUAL, "
	
	cSQL += "       CT2_HIST, "

	cSQL += "       	CASE " 
	cSQL += "       		WHEN CT2_DC = '1' THEN 'DEBITO' "
	cSQL += "       		WHEN CT2_DC = '2' THEN 'CREDITO' "
	cSQL += "       		WHEN CT2_DC = '3' THEN 'PARTIDA DOBRADA' "
	cSQL += "       		WHEN CT2_DC = '4' THEN 'CONTINUCAO DE HISTORICO' "
	cSQL += "       		WHEN CT2_DC = '5' THEN 'RATEIO' "
	cSQL += "       		ELSE 'LACAMENTO PADRAO' "
	cSQL += "       	END AS CT2_DC, "

	cSQL += "       CT2_DEBITO, "
	cSQL += "       CT2_CREDIT, "
	cSQL += "       CT2_VALOR, "
	cSQL += "       CT2_DATA, "
	cSQL += "       CT2_TPSALD, "
	cSQL += "       CT2_MOEDLC "
	cSQL += "FROM   "+RetSqlName("CT2")+" "
	cSQL += "WHERE  CT2_FILIAL = "+ValToSql(xFilial("CT2"))+" "
	cSQL += "       AND CT2_DATA >= "+ValToSql(dDataIni)+" "
	cSQL += "       AND CT2_DATA <= "+ValToSql(dDataFim)+" "
	cSQL += "       AND ((CT2_DEBITO >= "+ValToSql(aRet[ 5 ])+" AND CT2_DEBITO <= "+ValToSql(aRet[ 6 ])+") "
	cSQL += "           OR (CT2_CREDIT >= "+ValToSql(aRet[ 5 ])+" AND CT2_CREDIT <= "+ValToSql(aRet[ 6 ])+")) "
	cSQL += "       AND CT2_MOEDLC = '01' "
	cSQL += "       AND CT2_TPSALD = "+ValToSql(aRet[ 7 ])+" "
	cSQL += "       AND CT2_DC <> '4' "
	cSQL += "       AND D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY CT2_DATA "
		
	cCount := " SELECT COUNT(*) COUNT FROM ( " + cSQL + " ) QUERY "
	
	If At( "ORDER  BY", Upper( cCount ) ) > 0
		cCount := SubStr( cCount, 1, At( "ORDER  BY", cCount ) -1 ) + SubStr( cCount, RAt( ")", cCount ) )
	Endif
	
	DbUseArea( .T., "TOPCONN", TCGENQRY( , , cCount ), "SQLCOUNT", .F., .T. )
	nCount := SQLCOUNT->COUNT
	SQLCOUNT->(DbCloseArea())

	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, preparando o início da exportação...')
 	nMinus := nCount

	cTotalReg := LTrim( Str( nCount ) )

	While (cTRB)->( .NOT. EOF() )
		nRegistros := 1
				
		nMes := Month( (cTRB)->CT2_DATA )
		nAno := Year( (cTRB)->CT2_DATA )
		
		cMes := StrZero( nMes, 2 )
		cAno := StrZero( nAno, 4, 0 )
		
		cIncProc := cMes + '/' + cAno
		
		cNomArq := 'CTB' + cAno + cMes + RTrim( Str( nSeqArq, 1, 0 ) ) + '.csv'
		
		If File( cNomArq )
			FRename( cNomArq, 'bkp_'+cNomArq )
			Sleep( 500 )
		Endif
		
		nHdl := FCreate( cNomArq )

		AAdd( aFiles, cNomArq )

		If nSeqArq > 1
			FWrite( nHdl, 'Continuação do arquivo anterior:' + Left( cNomArq, 9 ) + '...' + CRLF )
		Endif

		FWrite( nHdl, cHeader + CRLF )

		While (cTRB)->( .NOT. EOF() ) .And. nMes == Month( (cTRB)->CT2_DATA ) .And. nAno == Year( (cTRB)->CT2_DATA ) .And. nRegistros <= 1000000
			MsProcTxt( 'Per:' + cIncProc + '. Total:' + cTotalReg + ' ,Faltam:' + LTrim( Str( nMinus ) ) )
  			ProcessMessage()
			nMinus--

			//+-------------------------------------------------------------------------------+
			//| A variável lIgual é para diminuir a chamada da função FwLeUserLg.             |
			//| Caso o LOG de inclusão e alteração sejam iguais executar uma vez para o user. |
			//+-------------------------------------------------------------------------------+
			lIgual := ( (cTRB)->CT2_USERGI == (cTRB)->CT2_USERGA )

			If .NOT. lIgual
				lVazio := Empty( (cTRB)->CT2_USERGA )
			Endif

			cUserI := RTrim( MyLeUserLg( (cTRB)->CT2_USERGI, 1, @cUserCodeI, @cUserNameI ) )
			cDateI := MyLeUserLg( (cTRB)->CT2_USERGI, 2 )

			If lIgual
				cUserA := cUserI
				cUserCodeA := cUserCodeI
				cUserNameA := cUserNameI
				cDateA := MyLeUserLg( (cTRB)->CT2_USERGA, 2 )
			Else
				If .NOT. lVazio
					cUserA := RTrim( MyLeUserLg( (cTRB)->CT2_USERGA, 1, @cUserCodeA, @cUserNameA ) )
					cDateA := MyLeUserLg( (cTRB)->CT2_USERGA, 2 )
				Else
					cUserA := ''
					cDateA := ''
				Endif
			Endif

			/*
			nP := AScan( aUser, {|p| p[ 1 ] == cUserI } )
			If nP == 0
				A410UserCode( cUserI, @cUserCodeI, @cUserNameI )
				AAdd( aUser, { cUserI, cUserCodeI, cUserNameI } )
			Else
				cUserCodeI := aUser[ nP, 2 ]
				cUserNameI := aUser[ nP, 3 ]
			Endif

			If lIgual
				cUserCodeA := cUserCodeI
				cUserNameA := cUserNameI
			Else
				If .NOT. lVazio
					nP := AScan( aUser, {|p| p[ 1 ] == cUserA } )
					If nP == 0
						A410UserCode( cUserA, @cUserCodeA, @cUserNameA )
						AAdd( aUser, { cUserA, cUserCodeA, cUserNameA } )
					Else
						cUserCodeA := aUser[ nP, 2 ]
						cUserNameA := aUser[ nP, 3 ]
					Endif
				Else
					cUserCodeA := ''
					cUserNameA := ''
				Endif
			Endif
			*/
			cDados := 	cUserI     + ' ' + cDateI     + ';' + ;
							cUserCodeI + ' ' + cUserNameI + ';' + ;
							cUserA     + ' ' + cDateA     + ';' + ;
							cUserCodeA + ' ' + cUserNameA + ';' + ;
							(cTRB)->CT2_LOTE       + ';' + ;
							(cTRB)->CT2_DOC        + ';' + ;
							(cTRB)->CT2_LINHA      + ';' + ;
							(cTRB)->CT2_MANUAL     + ';' + ;
							StrTran((cTRB)->CT2_HIST,';','') + ';' + ;
							(cTRB)->CT2_DC         + ';' + ;
							(cTRB)->CT2_DEBITO     + ';' + ;
							(cTRB)->CT2_CREDITO    + ';' + ;
							TransForm( (cTRB)->CT2_VALOR, cPicture ) + ';' + ;
							Dtoc( (cTRB)->CT2_DATA ) + ';' + ;
							(cTRB)->CT2_TPSALD

			FWrite( nHdl, cDados + CRLF )

			(cTRB)->( dbSkip() )

			nRegistros++			
		End
		
		If nRegistros > 1000000
			nSeqArq++
			FClose( nHdl )
			Sleep( 500 )
		Else
			nSeqArq := 1	
		Endif		
	End
	
	(cTRB)->(dbCloseArea())
	FClose( nHdl )
	Sleep( 500 )

	nHdl := FCreate( cArqLog )

	For nI := 1 To Len( aFiles )
		If File( aFiles[ nI ] )
			If __CopyFile( aFiles[ nI ], cDirDestino + aFiles[ nI ] )
				If File( cDirDestino + aFiles[ nI ] )
					cLOG := 'Arquivo ' + aFiles[ nI ] + ' gerado e copiado com sucesso no destino ' + cDirDestino
					FErase( aFiles[ nI ] )
				Else
					cLOG := 'Não localizei o arquivo no destino ' + cDirDestino
				Endif
			Else
				cLOG := 'Não consegui copiar o arquivo de ' + cSystem + ' para ' + cDirDestino
			Endif
		Else
			cLOG := 'Não localizei o arquivo em ' + cSystem + aFiles[ nI ]
		Endif

		FWrite( nHdl, cLOG + CRLF )
	Next nI

	FClose( nHdl )

	__CopyFile( cArqLog, cDirDestino + cArqLog )

	FErase( cArqLog )

	MsgInfo('Processamento finalizado...')
Return
//---------------------------------------------------------------------
// Rotina | A410Pasta    | Autor | Robson Gonçalves | Data | 23.05.2014
//---------------------------------------------------------------------
// Descr. | Rotina auxiliar para selecionar a pasta onde será gerado
//        | o arquivo.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A410Pasta()
	c410RetPath := cGetFile(,'Informe a pasta onde salvar',,,.F.,16+128)
Return( .T. )
//---------------------------------------------------------------------
// Rotina | A410RetPath  | Autor | Robson Gonçalves | Data | 23.05.2014
//---------------------------------------------------------------------
// Descr. | Rotina auxiliar 2 para selecionar a pasta onde será gerado
//        | o arquivo.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A410RetPath()
Return( c410RetPath )
//---------------------------------------------------------------------
// Rotina | A410CriaSXB  | Autor | Robson Gonçalves | Data | 23.05.2014
//---------------------------------------------------------------------
// Descr. | Rotina para criar o grupo de consulta padrão SXB.
//        |
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A410CriaSXB( cPerg )
	Local aDados := {}
	Local aCpoXB := {}
	Local nI := 0
	Local nJ := 0

	AAdd( aDados, { cPerg, '1', '01', 'RE', 'Pasta para salvar arquivos', 'Pasta para salvar arquivos', 'Pasta para salvar arquivos', 'CT2'            ,''})
	AAdd( aDados, { cPerg, '2', '01', '01', 'Codigo'                    , 'Codigo'                    , 'Codigo'                    , 'U_A410Pasta()'  ,''})
	AAdd( aDados, { cPerg, '5', '01', ''  , ''                          , ''                          , ''                          , 'U_A410RetPath()',''})

	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}

	SXB->(dbSetOrder(1))
	For nI := 1 To Len( aDados )
		If !SXB->(dbSeek(aDados[nI,1]+aDados[nI,2]+aDados[nI,3]+aDados[nI,4]))
			SXB->(RecLock('SXB',.T.))
			For nJ := 1 To Len( aDados[nI] )
				SXB->(FieldPut(FieldPos(aCpoXB[nJ]),aDados[nI,nJ]))
			Next nJ
			SXB->(MsUnLock())
		Endif
	Next nI
Return
//---------------------------------------------------------------------
// Rotina | A410UserCode | Autor | Robson Gonçalves | Data | 23.05.2014
//---------------------------------------------------------------------
// Descr. | Rotina para pesquisar código e nome do usuário.
//        |
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A410UserCode( cUser, cCodeUser, cFullName )
	Local cCodeUser := ''
	Local cFullName := ''
	Local aDados := {}
	PswOrder(2)
	If PswSeek( cUser )
		aDados := PswRet( 1 )
		cCodeUser := aDados[1,1]
		cFullName := aDados[1,4]
	Endif
Return

Static __aUserLg := {}

Static Function MyLeUserLg( cCampo, nTipo, cUserCod, cUserName )
	Local cAux := ''
	Local cID := ''
	Local cRet := ''
	Local nPos := 0
	Local cUsrName := ''
	
	Local aPswRet := {}
	
	Default nTipo := 1 
	
	cAux := Embaralha( cCampo, 1 )
	
	If ! Empty( cAux )
		If Subs( cAux, 1, 2) == "#@"
			cID := Subs( cAux, 3, 6 )
			If Empty( __aUserLg ) .Or. Ascan( __aUserLg, {|x| x[ 1 ] == cID } ) == 0                            
				PSWORDER( 1 )
				If ( PSWSEEK(cID) )
					aPswRet := PSWRET()
					cUsrName  := aPswRet[ 1, 2 ]
					cUserCod  := aPswRet[ 1, 1 ]
					cUserName := aPswRet[ 1, 4 ]
				EndIf		
				Aadd(__aUserLg, { cID, cUsrName, cUserCod, cUserName } )	
			EndIf
			
			If nTipo == 1 // retorna o usuário
				nPos := Ascan( __aUserLg, {|x| x[ 1 ] == cID } )
				cRet      := __aUserLg[ nPos, 2]
				cUserCod  := __aUserLg[ nPos, 3]
				cUserName := __aUserLg[ nPos, 4]
			Else
				cRet := Dtoc(CTOD("01/01/96","DDMMYY") + Load2In4(Substr(cAux,16)))
			Endif                         
		Else
			If nTipo == 1 // retorna o usuário
				cRet := Subs(cAux,1,15)
			Else   
				cRet := Dtoc(CTOD("01/01/96","DDMMYY") + Load2In4(Substr(cAux,16)))
			Endif                         
		EndIf
	EndIf   
	              
Return cRet
