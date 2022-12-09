//-----------------------------------------------------------------------
// Rotina | CSFA600    | Autor | Robson Gonçalves     | Data | 30.04.2015
//-----------------------------------------------------------------------
// Descr. | Rotina para importar valores de voucher.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
User Function CSFA600()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	Private cCadastro := 'Importação valores voucher'
	
	AAdd( aSay, 'Esta rotina tem por objetivo em importar os valores de software, hardware e total do' )
	AAdd( aSay, 'registro de voucher mais fluxo.' )
	AAdd( aSay, 'O arquivo deve ser salvo no formato CSV (texto). As colunas devem ter o nome na ' )
	AAdd( aSay, 'primeira linha em maiúsculo e sem espaços, acentos e cedilha. É interessante gerar ' )
	AAdd( aSay, 'o arquivo somente com as informações (colunas) que serão tratadas na importação, ' )
	AAdd( aSay, 'por exemplo: FLUXO, VOUCHER, VL_SOFT, VL_HARD, VL_TOTAL.' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
   
	If nOpcao==1
		A600Param()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A600Param  | Autor | Robson Gonçalves     | Data | 30.04.2015
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
// Rotina | A600Proc   | Autor | Robson Gonçalves     | Data | 30.04.2015
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento do arquivo de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A600Proc( cArqDados )
	Local cDados := ''
	Local aDados := {}
	
	Private nLinha := 1
	Private nP_FLUXO := 0
	Private nP_VOUCHER := 0
	Private nP_VL_SOFT := 0
	Private nP_VL_HARD := 0
	Private nP_VL_TOTAL := 0
	Private a600Log := {}
	
	FT_FUSE( cArqDados )	
	FT_FGOTOP()
	ProcRegua( FT_FLASTREC() )
	
	cDados := FT_FREADLN() + ';'
	nLinha++	
	FT_FSKIP()
	
	A600LeLin( cDados, @aDados )
	
	nP_FLUXO    := AScan( aDados, {|p| p == "FLUXO"    } )
	nP_VOUCHER  := AScan( aDados, {|p| p == "VOUCHER"  } )
	nP_VL_SOFT  := AScan( aDados, {|p| p == "VL_SOFT"  } )
	nP_VL_HARD  := AScan( aDados, {|p| p == "VL_HARD"  } )
	nP_VL_TOTAL := AScan( aDados, {|p| p == "VALOR_TOTAL" } )
	
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
	FwMsgRun(,{|| DlgToExcel( { { "ARRAY", "", {'STATUS','NUM_LINHA','FLUXO','VOUCHER','VL_SOFT','ZF_VALORSW','VL_HARD','ZF_VALORHW','VL_TOTAL','ZF_TOTAL'}, a600Log } } ) };
	,,'Aguarde, gerando log de processamento...')
Return

//-----------------------------------------------------------------------
// Rotina | A600LeLin  | Autor | Robson Gonçalves     | Data | 30.04.2015
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
Return

//-----------------------------------------------------------------------
// Rotina | A600Gravar | Autor | Robson Gonçalves     | Data | 30.04.2015
//-----------------------------------------------------------------------
// Descr. | Rotina de gravacao dos dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A600Gravar( aDados )
	Local cZF_COD := aDados[ nP_VOUCHER ]
	Local cZF_CODFLU := StrZero( Val( aDados[ nP_FLUXO ] ), Len( SZF->ZF_CODFLU ), 0 )
	Local nZFVALORSW := Val( StrTran( StrTran( aDados[ nP_VL_SOFT ] , '.','' ), ',', '.' ) )
	Local nZFVALORHW := Val( StrTran( StrTran( aDados[ nP_VL_HARD ] , '.','' ), ',', '.' ) )
	Local nZFVALOR   := Val( StrTran( StrTran( aDados[ nP_VL_TOTAL ], '.','' ), ',', '.' ) )
	
	SZF->( dbSetOrder( 1 ) )
	If SZF->( dbSeek( xFilial( 'SZF' ) + cZF_CODFLU + cZF_COD ) )
		AAdd( a600Log, { 'OK', ;
		                 LTrim( Str( nLinha, 6, 0 ) ), ;
		                 aDados[ nP_FLUXO ], ;
		                 aDados[ nP_VOUCHER ], ;
		                 aDados[ nP_VL_SOFT ], ;
		                 Str(SZF->ZF_VALORSW, 12, 2), ;
		                 aDados[ nP_VL_HARD ], ;
		                 Str(SZF->ZF_VALORHW, 12, 2), ;
		                 aDados[ nP_VL_TOTAL ],;
		                 Str(SZF->ZF_VALOR, 12, 2) } )
		SZF->( RecLock( 'SZF', .F. ) )
		SZF->ZF_VALORSW := nZFVALORSW
		SZF->ZF_VALORHW := nZFVALORHW
		SZF->ZF_VALOR   := nZFVALOR
		SZF->( MsUnLock() )
	Else
		AAdd( a600Log, { 'NÃO LOCALIZADO', ;
		                 LTrim( Str( nLinha, 6, 0 ) ), ;
		                 aDados[ nP_FLUXO ], ;
		                 aDados[ nP_VOUCHER ], ;
		                 aDados[ nP_VL_SOFT ], ;
		                 '0,00', ;
		                 aDados[ nP_VL_HARD ], ;
		                 '0,00', ;
		                 aDados[ nP_VL_TOTAL ],;
		                 '0,00' } )
	Endif
Return