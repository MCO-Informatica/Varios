//-----------------------------------------------------------------------
// Rotina | CSFA230    | Autor | Robson Gonçalves     | Data | 16.09.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ exportar dados da tabela de e-mail x estágio do 
//        | processo de vendas (ZCE) e importar e-mails.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSFA230()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private cCadastro 	:= "E-Mail x Estágios do Processo de Vendas" 

	AAdd( aSay, 'Rotina para exportar/importar dados do cadastro de EMail X Estágios CRM Vendas.' )
	AAdd( aSay, 'É possível criar novos registros ou alterar os emails dos registros existentes.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao==1
		nOpcao := 0
		nOpcao := Aviso(cCadastro,'O que desejar processar?',{'Exportar','Importar'},2,'')
		If nOpcao == 1
			If MsgYesNo('Confirma o início do processamento de exportação?',cCadastro)
				FwMsgRun(, {|| A230Export() }, , 'Aguarde, exportando dados...')
			Endif
		Elseif nOpcao == 2
			A230Import()
		Endif
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A230Export | Autor | Robson Gonçalves     | Data | 16.09.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento e exportação dos dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A230Export()
	Local aCab := {}
	Local aTit := {}
	Local aDados := {}
	
	Local nElem := 0
	
	Local cTab := Chr( 160 )
	
	aCab := {'ZCE_PROCES','ZCE_ESTATU','ZCE_ESTNOV','ZCE_EMAIL'}
	
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCab )
		SX3->( dbSeek( aCab[ nI ] ) )
		AAdd( aTit, SX3->X3_TITULO )
	Next nI
	
	ZCE->( dbSetOrder( 1 )  )
	ZCE->( dbSeek( xFilial( 'ZCE' ) ) )
	While .NOT. ZCE->( EOF() ) .And. ZCE->ZCE_FILIAL == xFilial( 'ZCE' )
		If nElem == 0
			AAdd( aDados, Array( Len( aTit ) ) )
			nElem := Len( aDados )
			For nI := 1 To Len( aTit )
				aDados[ nElem, nI ] := aTit[ nI ]
			Next nI
		Endif
		AAdd( aDados, Array( Len( aCab ) ) )
		nElem := Len( aDados )
		For nI := 1 To Len( aCab )
			aDados[ nElem, nI ] := Iif(nI<=3,(cTab+AllTrim( ZCE->( FieldGet( FieldPos( aCab[ nI ]  ) ) ) ) ),AllTrim( ZCE->( FieldGet( FieldPos( aCab[ nI ] ) ) ) ))
		Next nI
		ZCE->( dbSkip() )
	End
	
	If Len( aDados ) > 0
		DlgToExcel( {{'ARRAY',cCadastro,{},aDados}})
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A230Export | Autor | Robson Gonçalves     | Data | 18.09.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de importação dos dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A230Import()
	Local aPar := {}
	Local aRet := {}
	
	AAdd( aPar, { 6, 'Arquivo',Space(50),'','','',95,.T.,'CSV (separados por vírgulas) (*.csv) |*.csv'})
	aAdd( aPar, { 3, 'Modo de processamento',1,{'Gravar','Simular'},50,"",.T.})
	aAdd( aPar, { 3, 'Funcionalidade',1,{'Alterar','Incluir'},50,"",.T.})

	If ParamBox( aPar, 'Selecione o arquivo', @aRet )
		If File( aRet[ 1 ] )
			FwMsgRun(, {|| A230PrcExp( aRet[ 1 ], ( aRet[ 2 ] == 1 ), aRet[ 3 ] == 2 ) }, , 'Aguarde, importando dados...')
		Else
			MsgAlert('Arquivo informado não localizado.', cCadastro )
		Endif
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A230PrcExp | Autor | Robson Gonçalves     | Data | 18.09.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento da importação dos dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A230PrcExp( cArq, lGravar, lIncluir )
	Local nB := 0
	Local nP := 0
	Local nLinha := 0
	
	Local aLog := {}
	Local aDados := {}
	
	Local lCopiou := .F.
	
	Local cDado := ''
	Local cChave := ''
	Local cDelim := ';'
	Local cLinha := ''
	Local cArqDados := ''
	Local cZCE_EMAIL := ''
	Local cBarra := Iif( IsSrvUnix(), "/", "\" )
	Local cStartPath := GetSrvProfString( 'Startpath', '' )

	nB := Rat( cBarra, cArq )
	cArqDados := SubStr( cArq, nB + 1 )
	
	If cStartPath $ cArq
		lCopiou := .T.
	Else
		lCopiou := __CopyFile( cArq, cStartPath + cArqDados )
	Endif
	
	If lCopiou
		FT_FUSE( cArqDados )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			nLinha ++
			cLinha := FT_FREADLN()
			
			While ( At( cDelim + cDelim, cLinha ) > 0 )
				cLinha := StrTran( cLinha, ( cDelim + cDelim ), ( cDelim + ' ' + cDelim ) )
			End
			
			If Empty( cLinha )
				FT_FSKIP()
				Loop
			Endif

			If 'ZCE_' $ cLinha
				FT_FSKIP()
				Loop
			Endif
			
			// 1º campo.
			nP := At( cDelim, cLinha )
			If nP > 0
				cDado := SubStr( cLinha, 1, nP-1 )
				If Empty( cDado )
					cDado := Space( Len( ZCE->ZCE_PROCES ) )
				Endif
				AAdd( aDados, cDado )
				cLinha := SubStr( cLinha, nP+1 )
				// 2º campo.
				nP := At( cDelim, cLinha )
				If nP > 0
					cDado := SubStr( cLinha, 1, nP-1 )
					If Empty( cDado )
						cDado := Space( Len( ZCE->ZCE_ESTATU ) )
					Endif
					AAdd( aDados, cDado )
					cLinha := SubStr( cLinha, nP+1 )
					// 3º campo.
					nP := At( cDelim, cLinha )
					If nP > 0
						cDado := SubStr( cLinha, 1, nP-1 )
						If Empty( cDado )
							cDado := Space( Len( ZCE->ZCE_ESTNOV ) )
						Endif
						AAdd( aDados, cDado )
						cLinha := SubStr( cLinha, nP+1 )
						// 4º e último campo, pega todo o resto.
						AAdd( aDados, AllTrim( cLinha ) )
				   Endif
				Endif
			Endif
			cChave := xFilial( 'ZCE' ) + aDados[ 1 ] + aDados[ 2 ] + aDados[ 3 ]
			ZCE->( dbSetOrder( 1 ) )
			lAchou := ZCE->( dbSeek( cChave ) )
			If lAchou
				If lIncluir
					AAdd( aLog,{ 'PROBLEMA', 'A chave da linha '+LTrim(Str(nLinha))+' foi localizado na tabela ZCE, portanto não será possível incluir.'} )
				Else
					If lGravar
						ZCE->( RecLock( 'ZCE', .F. ) )
						ZCE->ZCE_EMAIL := aDados[ 4 ]
						ZCE->( MsUnLock() )
					Endif
					AAdd(aLog,{'SUCESSO' ,;
				   'Alterado registro com a chave:'+cChave,;
				   'Linha: '+LTrim(Str(nLinha)),;
				   'Antes: '+cZCE_EMAIL,;
				   'Depois: '+aDados[ 4 ],;
				   'Modo de '+Iif(lGravar,'gravação','simulação') })
				Endif
			Else
				If lIncluir
					If lGravar
						ZCE->( RecLock( 'ZCE', .T. ) )
						ZCE->ZCE_FILIAL := xFilial( 'ZCE' )
						ZCE->ZCE_PROCES := aDados[ 1 ]
						ZCE->ZCE_ESTATU := aDados[ 2 ]
						ZCE->ZCE_ESTNOV := aDados[ 3 ]
						ZCE->ZCE_EMAIL  := aDados[ 4 ]
						ZCE->ZCE_RESAPT := 'S'
						ZCE->ZCE_RESOPT := 'S'
						ZCE->( MsUnLock() )
					Endif
					AAdd(aLog,{'SUCESSO' ,;
				   'Incluído registro com a chave:'+cChave,;
				   'Linha: '+LTrim(Str(nLinha)),;
				   'Modo de '+Iif(lGravar,'gravação','simulação') })
				Else
					AAdd( aLog,{ 'PROBLEMA', 'A chave da linha '+LTrim(Str(nLinha))+' não foi localizado na tabela ZCE, portanto não será possível alterar.'} )
				Endif
			Endif
			aDados := {}
			FT_FSKIP()
		End
		FT_FUSE()
		If Len( aLog ) > 0
			DlgToExcel( {{'ARRAY',cCadastro,{},aLog}})
		Endif
	Else
		MsgInfo( 'Falha na cópia do arquivo de dados, não foi possível copiar o arquivo da origem para o destino "' + cStartPath + '"', cCadastro )
	Endif
Return