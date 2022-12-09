//-----------------------------------------------------------------------
// Rotina | CSGCT060    | Autor | Rafael Beghini     | Data | 29.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para Importação notificação e-Mails
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
User Function CSGCT060()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	Private cCadastro := 'Importação notificação e-Mails'
	
	AAdd( aSay, 'Esta rotina tem por objetivo em importar os usuários que irão receber' )
	AAdd( aSay, 'as notificações por e-mail para situação do contrato.' )
	AAdd( aSay, 'O arquivo deve ser salvo no formato CSV (texto). As colunas devem ter o nome na ' )
	AAdd( aSay, 'primeira linha em maiúsculo e sem espaços, acentos e cedilha.')
	AAdd( aSay, ' ')
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
   
	If nOpcao==1
		A600Param()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A600Param  | Autor | Rafael Beghini     | Data | 29.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para solicitar parâmetro de busca para o usuário.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A600Param()
	Local nB := 0
	Local aPar := {}
	Local aRet := {}
	Local bOk 
	Local cArq := ""
	Local cArqDados := ""
	Local cSystem := GetSrvProfString( "Startpath", "" )
	Local cBarra := Iif( IsSrvUnix(), "/", "\" )
	
	bOk := {|| 	Iif( File( mv_par01 ), ;
					MsgYesNo( "Confirma o início do processamento?", cCadastro ),;
					( MsgAlert("Arquivo não localizado, verifique.", cCadastro ), .F. ) ) }	

	AAdd( aPar, { 6, "Capturar o arquivo de dados", Space(99), "", "", "", 80, .T., "CSV (separado por vírgulas) (*.csv) |*.csv", "" } )
	If ParamBox(aPar,"Parâmetros",@aRet,bOk,,,,,,,.F.,.F.)
		cArq := RTrim( aRet[ 1 ] )
		nB := Rat( cBarra, cArq )
		cArqDados := SubStr( cArq, nB + 1 )
		If __CopyFile( cArq, cSystem + cArqDados )	
	   	Processa( {|| A600Proc( cArqDados ) }, cCadastro , "Aguarde...", .F. )
		Else
			MsgAlert( 'Não foi possível copiar o arquivo do local origem para o destino.', cCadastro)
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A600Proc   | Autor | Rafael Beghini     | Data | 29.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento do arquivo de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A600Proc( cArqDados )
	Local cDados := ''
	Local aDados := {}
	
	Private nLinha := 1
	Private nP_FIL := 0
	Private nP_CTR := 0
	Private nP_CAU := 0
	Private nP_MED := 0
	Private nP_PLA := 0
	Private nP_REA := 0
	Private nP_REV := 0
	Private nP_SIT := 0
	Private nP_VEN := 0
	Private nP_EXC := 0
	Private a600Log := {}
	
	FT_FUSE( cArqDados )	
	FT_FGOTOP()
	ProcRegua( FT_FLASTREC() )
	
	cDados := FT_FREADLN() + ';'
	nLinha++	
	FT_FSKIP()
	
	A600LeLin( cDados, @aDados )
	
	nP_FIL := AScan( aDados, {|p| p == "FILIAL"      } )
	nP_CTR := AScan( aDados, {|p| p == "1=CONTRATO"  } )
	nP_CAU := AScan( aDados, {|p| p == "2=CAUCAO"    } )
	nP_MED := AScan( aDados, {|p| p == "3=MEDICAO"   } )
	nP_PLA := AScan( aDados, {|p| p == "4=PLANILHA"  } )
	nP_REA := AScan( aDados, {|p| p == "5=REAJUSTE"  } )
	nP_REV := AScan( aDados, {|p| p == "6=REVISAO"   } )
	nP_SIT := AScan( aDados, {|p| p == "7=SITUACAO"  } )
	nP_VEN := AScan( aDados, {|p| p == "8=VENCIMENTO"} )
	nP_EXC := AScan( aDados, {|p| p == "9=EXCECAO"   } )
	
	While .NOT. FT_FEOF()
		IncProc()
		cDados := FT_FREADLN() + ';'
		A600LeLin( cDados, @aDados )
		A600Gravar( aDados )
		nLinha++
		FT_FSKIP()
	End
	FT_FUSE()
	
	AAdd( a600Log, { 'DT.PROCESS.:'+Dtoc( dDataBase ), 'HR.PROCESS.:'+Time(), '', '', '', '', '', '', '', '' } )
	FwMsgRun(,{|| DlgToExcel( { { "ARRAY", "", {'STATUS','NUM_LINHA','FILIAL','CONTRATO','2=CAUCAO','3=MEDICAO','4=PLANILHA','5=REAJUSTE',;
														'6=REVISAO','7=SITUACAO','8=VENCIMENTO','9=EXCECAO'}, a600Log } } ) };
	,,'Aguarde, gerando log de processamento...')
Return

//-----------------------------------------------------------------------
// Rotina | A600LeLin  | Autor | Rafael Beghini     | Data | 29.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina de leitura e decomposicao da linha.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A600LeLin( cReg, aArray )
	Local nP := 0
	
	aArray := {}

	While ( At( ';' + ';', cReg ) > 0 )
		cReg := StrTran( cReg, ( ';' + ';' ), ( ';' + ' ' + ';' ) )
	End

	While .NOT. Empty( cReg )
		nP := At( ';', cReg )
		AAdd( aArray, AllTrim( SubStr( cReg, 1, nP-1 ) ) )
		cReg := SubStr( cReg, nP+1 )
	End
	For nL := 1 To Len( aArray )
		IF Empty( aArray[nL] )
			aArray[nL] := .F.
		EndIF
	Next nL
Return

//-----------------------------------------------------------------------
// Rotina | A600Gravar | Autor | Rafael Beghini     | Data | 29.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina de gravacao dos dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A600Gravar( aDados )
	Local cCN9_CTR := aDados[ nP_FIL ] + aDados[ nP_CTR ] 
	Local aCAU := IIF( Valtype( aDados[nP_CAU] ) == 'C', StrToArray( Alltrim( aDados[nP_CAU] ),"#" ), Nil )
	Local aMED := IIF( Valtype( aDados[nP_MED] ) == 'C', StrToArray( Alltrim( aDados[nP_MED] ),"#" ), Nil )
	Local aPLA := IIF( Valtype( aDados[nP_PLA] ) == 'C', StrToArray( Alltrim( aDados[nP_PLA] ),"#" ), Nil )
	Local aREA := IIF( Valtype( aDados[nP_REA] ) == 'C', StrToArray( Alltrim( aDados[nP_REA] ),"#" ), Nil )
	Local aREV := IIF( Valtype( aDados[nP_REV] ) == 'C', StrToArray( Alltrim( aDados[nP_REV] ),"#" ), Nil )
	Local aSIT := IIF( Valtype( aDados[nP_SIT] ) == 'C', StrToArray( Alltrim( aDados[nP_SIT] ),"#" ), Nil )
	Local aVEN := IIF( Valtype( aDados[nP_VEN] ) == 'C', StrToArray( Alltrim( aDados[nP_VEN] ),"#" ), Nil )
	Local aEXC := IIF( Valtype( aDados[nP_EXC] ) == 'C', StrToArray( Alltrim( aDados[nP_EXC] ),"/" ), Nil )
	Local cDado1 := ''
	Local cDado2 := ''
	Local cDado3 := ''
	Local cDado4 := ''
	Local cDado5 := ''
	Local cDado6 := ''
	Local cDado7 := ''
	Local cDado8 := ''
	Local cDADOS := ''
	
	IIF ( .NOT. Empty( aCAU ), AEval( aCAU, {|X| cDado1 += '1=' + X + ';;' } ), Nil )
	IIF ( .NOT. Empty( aMED ), AEval( aMED, {|X| cDado2 += '2=' + X + ';;' } ), Nil )
	IIF ( .NOT. Empty( aPLA ), AEval( aPLA, {|X| cDado3 += '3=' + X + ';;' } ), Nil )
	IIF ( .NOT. Empty( aREA ), AEval( aREA, {|X| cDado4 += '4=' + X + ';;' } ), Nil )
	IIF ( .NOT. Empty( aREV ), AEval( aREV, {|X| cDado5 += '5=' + X + ';;' } ), Nil )
	IIF ( .NOT. Empty( aSIT ), AEval( aSIT, {|X| cDado6 += '6=' + X + ';;' } ), Nil )
	IIF ( .NOT. Empty( aVEN ), AEval( aVEN, {|X| cDado7 += '7=' + X + ';;' } ), Nil )
	IIF ( .NOT. Empty( aEXC ), AEval( aEXC, {|X| cDado8 += 'X=' + replace( replace( X, '=', '' ), '#', ',' ) + ';;' } ), Nil )
		
	CN9->( dbSetOrder( 7 ) )
	If CN9->( dbSeek( cCN9_CTR + '05' ) )
		cDADOS := cDado1 + cDado2 + cDado3 + cDado4 + cDado5 + cDado6 + cDado7 + cDado8
		
		IF .NOT. Empty( cDADOS )
			CN9->( RecLock('CN9',.F.) )
			CN9->CN9_NOTVEN := cDADOS
			CN9->( MsUnLock() )
		EndIF
		AAdd( a600Log, { 'OK', LTrim( Str( nLinha, 6, 0 ) ), CHR(160) + aDados[ nP_FIL ], CHR(160) + aDados[ nP_CTR ], ;
		                 cDado1, cDado2, cDado3, cDado4, cDado5, cDado6, cDado7, cDado8 } )
	Else
		AAdd( a600Log, { 'NÃO LOCALIZADO', LTrim( Str( nLinha, 6, 0 ) ), CHR(160) + aDados[ nP_FIL ], CHR(160) + aDados[ nP_CTR ], ;
		                 cDado1, cDado2, cDado3, cDado4, cDado5, cDado6, cDado7, cDado8 } )
	Endif
Return