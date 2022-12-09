#Include 'Protheus.ch'
#Include 'TbiConn.ch'

STATIC a870Dados := {}

/*/{Protheus.doc} CSFA870
Rotina de exportação de dados para o sistema Performa. 
@author robson.goncalves
@since 13/10/2017
/*/
User Function CSFA870()
	
	Local aButton  := {}
	Local aSay     := {}
	Local nOpcao   := 0
	Local lJobPerf := .T.
	
	Private cCadastro := 'Integração Sistema Performa'
	
	//-- Verifica se a chamada é JOB.
	If FunName() == "CSFA870"
		lJobPerf := .F.
	EndIf
	
	//-- Se não form JOB apresenta inteface.
	If !lJobPerf
		AAdd( aSay, 'Esta rotina tem por objetivo gerar arquivos de dados para a área de FTP do sistema' )
		AAdd( aSay, 'Performa.' )
		AAdd( aSay, '' )
		AAdd( aSay, '' )
		AAdd( aSay, '' )
		AAdd( aSay, '' )
		AAdd( aSay, 'Clique em OK para prosseguir...' )
		
		AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
		AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
		SetKey( VK_F11 , {|| A870ArmPsw() } )
	
		FormBatch( cCadastro, aSay, aButton )
	
		If nOpcao==1
			A870Param()
		Endif
		SetKey( VK_F11, NIL )
	Else
		//-- Informa o servidor que nao ira consumir licensas.
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "06" MODULO 'APD' TABLES 'SRA', 'ZZL', 'ZZM', 'ZZN'
			A870Param(lJobPerf)
		RESET ENVIRONMENT
	EndIf
	
Return

/*/{Protheus.doc} A870Param
Rotina de parâmetros de processamento.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870Param(lJobPerf)
	
	Local aPar := {}
	Local aRet := {}
	
	Private oObj
	
	If !lJobPerf
		A870SXB()
	
		AAdd( aPar, { 1 ,'Filial de'     ,Space(Len(SRA->RA_FILIAL)) ,'' ,''                     ,'SM0_01' ,'' ,40 ,.F. } ) //-> 1
		AAdd( aPar, { 1 ,'Filial até'    ,Space(Len(SRA->RA_FILIAL)) ,'' ,'(MV_PAR02>=MV_PAR01)' ,'SM0_01' ,'' ,40 ,.T. } ) //-> 2
		AAdd( aPar, { 1 ,'Matrícula de'  ,Space(Len(SRA->RA_MAT))    ,'' ,''                     ,'870SRA' ,'' ,60 ,.F. } ) //-> 3
		AAdd( aPar, { 1 ,'Matrícula até' ,Space(Len(SRA->RA_MAT))    ,'' ,'(MV_PAR04>=MV_PAR03)' ,'870SRA' ,'' ,60 ,.T. } ) //-> 4
	
		AAdd( aPar, { 4 ,'Exportar?' ,.F. ,'Atributos'            ,90 ,'' ,.F. } ) //-> 5
		AAdd( aPar, { 4 ,''          ,.F. ,'Cargos'               ,90 ,'' ,.F. } ) //-> 6
		AAdd( aPar, { 4 ,''          ,.F. ,'Departamentos'        ,90 ,'' ,.F. } ) //-> 7
		AAdd( aPar, { 4 ,''          ,.F. ,'Usuários'             ,90 ,'' ,.F. } ) //-> 8
		AAdd( aPar, { 4 ,''          ,.F. ,'Usuários x Atributos' ,90 ,'' ,.F. } ) //-> 9
		AAdd( aPar, { 4 ,''          ,.F. ,'Usuários x Domínio'   ,90 ,'' ,.F. } ) //-> 10
	
		If ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.F.,.F.)
			oObj := MsNewProcess():New({|lEnd| A870Proc( @lEnd, aRet ) }, cCadastro, 'Processando...', .T. )
			oObj:Activate()
		Endif
	Else
		
		//-- Parametros.
		AAdd( aRet ,"  "     )	//-- Filial de
		AAdd( aRet ,"ZZ"     )	//-- Filial até
		AAdd( aRet ,"      " )	//-- Matricula de
		AAdd( aRet ,"ZZZZZZ" )	//-- Matricula até
		AAdd( aRet ,.T.      )	//-- Gera Atributos?
		AAdd( aRet ,.T.      )	//-- Gera Cargos?
		AAdd( aRet ,.T.      )	//-- Gera Departamentos?
		AAdd( aRet ,.T.      )	//-- Gera Usuários?
		AAdd( aRet ,.T.      )	//-- Gera Usuários x Atributos?
		AAdd( aRet ,.T.      )	//-- Gera Usuários x Domínio?
				
		Eval( {|lEnd| A870Proc( @lEnd, aRet, lJobPerf ) } )
		
	EndIf
	
Return

/*/{Protheus.doc} A870Proc
Rotina de processamento.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870Proc( lEnd, aRet, lJobPerf )
	
	Local aCpos := {}
	Local aLog  := {}
	
	Local cBarra := Iif( IsSrvUnix(), '/', '\' )
	
	Local cMV_870_01 := 'MV_870_01'
	Local cMV_870_02 := 'MV_870_02'
	Local cMV_870_03 := 'MV_870_03'
	Local cMV_870_04 := 'MV_870_04'
	Local cMV_870_05 := 'MV_870_05'
	Local cMV_870_06 := 'MV_870_06'
	Local cMV_870_07 := 'MV_870_07'
	Local cMV_870_08 := 'MV_870_08'
	Local cCorpo     := ""
	Local cHtml      := ""
	Local cPara      := SuperGetMV("MV_EPERFOR",.F.," ")
	Local cAssunto   := "LOG - Integração Protheus x Performa"
	
	Local nCount := 0
	Local nI     := 0
	
	Private cDirProc   := ''
	Private cDirError  := ''
	Private cDirLog    := ''
	Private cDirUpLoad := ''
	
	// \protheus_data\performa			<-- gerar os arquivos neste diretório.
	// \protheus_data\performa\upload\	<-- arquivos com upload ok são armazenados nesta pasta dentro de pasta data+hora [aaaammdd-999999].
	// \protheus_data\performa\error\	<-- arquivos que não foi possível fazer upload são armazenados dentro desta pasta [aaaammdd-999999].
	cDirProc   := cBarra + 'performa' + cBarra
	cDirUpLoad := cBarra + 'performa' + cBarra + 'upload' + cBarra
	cDirError  := cBarra + 'performa' + cBarra + 'error'  + cBarra
	cDirLog    := cBarra + 'performa' + cBarra + 'log'    + cBarra
	
	MakeDir( cDirProc   )
	MakeDir( cDirUpload )
	MakeDir( cDirError  )
	MakeDir( cDirLog    )
	
	If .NOT. GetMv( cMV_870_01, .T. )
		CriarSX6( cMV_870_01, 'C', 'ARQUIVO DE CONFIGURACAO (INI) P/ EXPORTAR DADOS PERFORMA - ROTINA CSFA870.prw', 'csfa870.ini' )
	Endif
	
	cMV_870_01 := GetMv( cMV_870_01, .F. )
	
	If .NOT. File( cMV_870_01 )
		
		If lJobPerf
			Conout('[CSFA870_' + DTOS(Date()) + '_' + Time() + '] - ' + 'Impossível continuar, não localizei o arquivo de configuração.')
		Else
			MsgAlert('Impossível continuar, não localizei o arquivo de configuração.',cCadastro)
		EndIf
		Return
		
	Endif
	
	If .NOT. GetMv( cMV_870_02, .T. )
		CriarSX6( cMV_870_02, 'C', 'NOME OU IP DO SERVIDOR DE FTP - ROTINA CSFA870.prw', '' )
	Endif
	
	If .NOT. GetMv( cMV_870_03, .T. )
		CriarSX6( cMV_870_03, 'N', 'PORTA DO SERVIDOR DE FTP - ROTINA CSFA870.prw', '' )
	Endif

	If .NOT. GetMv( cMV_870_04, .T. )
		CriarSX6( cMV_870_04, 'C', 'LOGIN PARA CONEXAO FTP - ROTINA CSFA870.prw', '' )
	Endif

	If .NOT. GetMv( cMV_870_05, .T. )
		CriarSX6( cMV_870_05, 'C', 'PASSWORD PARA CONEXAO FTP - ROTINA CSFA870.prw', '' )
	Endif

	If .NOT. GetMv( cMV_870_06, .T. )
		CriarSX6( cMV_870_06, 'C', 'DEFINE SE CONEXAO FTP SERA POR IP S=SIM OU N=NAO - ROTINA CSFA870.prw', '' )
	Endif

	If .NOT. GetMv( cMV_870_07, .T. )
		CriarSX6( cMV_870_07, 'C', 'EMAIL PARA ALERTAR OS INTERESSADOS - ROTINA CSFA870.prw', 'sistemascorporativos@certisign.com.br; rh@certisign.com.br' )
	Endif

	If .NOT. GetMv( cMV_870_08, .T. )
		CriarSX6( cMV_870_08, 'N', 'CONFIGURA O ENVIO DOS ARQUIVO POR FTP. 0=NAO; 1=SIM', '0' )
	Endif
	
	cMV_870_02 := GetMv( cMV_870_02, .F. )
	cMV_870_03 := GetMv( cMV_870_03, .F. )
	cMV_870_04 := GetMv( cMV_870_04, .F. )
	cMV_870_06 := GetMv( cMV_870_06, .F. )
	cMV_870_07 := GetMv( cMV_870_07, .F. )
	cMV_870_08 := GetMv( cMV_870_08, .F. )
	
	// Verificar se é para fazer upload no final do processamento.
	If cMV_870_08 == 1
		// Testar se o FTP está disponível para fazer upload.
		If .NOT. FTPConnect( cMV_870_02 , cMV_870_03, cMV_870_04, A870Decode(), ( cMV_870_06 == 'S' ) )		
			If lJobPerf
				Conout('[CSFA870_' + DTOS(Date()) + '_' + Time() + '] - ' + 'Nao foi possivel se conectar no servidor FTP.')
			Else
				MsgAlert( 'Nao foi possivel se conectar no servidor FTP.', cCadastro )
			EndIf		
			Return
		Else
			FTPDisConnect()
		Endif
	Endif
	
	A870LoadCpos( cMV_870_01, @aCpos )
	
	For nI := 5 To 10
		If aRet[ nI ]
			nCount++
		Endif
	Next nI 
	
	If !lJobPerf
		oObj:SetRegua2( nCount )
	EndIf
	
	If aRet[ 5 ] .AND. .NOT. lEnd
		If !lJobPerf
			oObj:IncRegua2( aCpos[ 1, 1 ] )
		EndIf 
		A870Atributo( @lEnd, oObj, aCpos, lJobPerf )
	Endif
	
	If aRet[ 6 ] .AND. .NOT. lEnd 
		If !lJobPerf
			oObj:IncRegua2( aCpos[ 2, 1 ] )
		EndIf
		A870Cargo( @lEnd, oObj, aCpos, lJobPerf )
	Endif
	
	If aRet[ 7 ] .AND. .NOT. lEnd
		If !lJobPerf
			oObj:IncRegua2( aCpos[ 3, 1 ] )
		EndIf
		A870Depto( @lEnd, oObj, aCpos, lJobPerf )
	Endif
	
	If aRet[ 8 ] .AND. .NOT. lEnd
		If !lJobPerf
			oObj:IncRegua2( aCpos[ 4, 1 ] )
		EndIf
		A870Usuario( @lEnd, aRet, oObj, aCpos, lJobPerf )
	Endif
	
	If aRet[ 9 ] .AND. .NOT. lEnd
		If !lJobPerf
			oObj:IncRegua2( aCpos[ 5, 1 ] )
		EndIf
		A870UsAtrib( @lEnd, oObj, aCpos, lJobPerf )
	Endif
	
	If aRet[ 10 ] .AND. .NOT. lEnd
		If !lJobPerf
			oObj:IncRegua2( aCpos[ 6, 1 ] )
		EndIf
		A870UsDomin( @lEnd, oObj, aCpos, lJobPerf )
	Endif
	
	// Verificar se é para fazer upload no final do processamento.
	If cMV_870_08 == 1
		Conout('[CSFA870_' + DTOS(Date()) + '_' + Time() + '] - ' + "Iniciando processo de upload via FTP.")
		A870UpLoad( { cMV_870_02, cMV_870_03, cMV_870_04, cMV_870_06 }, @aLog, , lJobPerf )
	Endif
	
	If Len( aLog ) > 0
		If !lJobPerf
			If MsgYesNo( 'Processo de upload concluído com sucesso. Deseja visualizar o log de upload ?', cCadastro )
				A870ShowLog( aLog )
			EndIf
		Else
			
			//-- Montagem do corpo do e-mail.
			cCorpo := "<br><p>"
			cCorpo += "	Segue informações detalhadas sobre a integração: Protheus x Performa<br><br>"
			cCorpo += "	<strong>Log de Envio via FTP:</strong> <br>"
			
			For nX := 1 To Len(aLog)
				Conout(aLog[nX])
				cCorpo += aLog[nX] + " <br>"
			Next nX
			cCorpo += "<br><br></p>"
			
			Conout('[CSFA870_' + DTOS(Date()) + '_' + Time() + '] - ' + "Processo de upload realizado com sucesso.")
					
			//-- Retorna o HTML completo concatenando o corpo do e-mail.
			cHtml := u_CSModHtm(cCorpo)
			
			If !Empty(cPara)
				//-- Realiza o envio do e-mail.
				FSSendMail( cPara, cAssunto, cHtml )
			EndIf
			
		EndIf
	Endif
	
Return


/*/{Protheus.doc} A870LoadCpos
Rotina para carregar os campos que farão parte do processo.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870LoadCpos( cMV_870_01, aCpos )
	
	Local cCampos := ''
	Local cId     := ''
	Local cLine   := ''
	
	FT_FUSE( cMV_870_01 )
	FT_FGOTOP()
	
	While ! FT_FEOF()
		cLine := FT_FREADLN()
		cId := SubStr( cLine, 1, 1 )
		If ( .NOT. Empty( cLine ) .OR. cLine <> '*' ) 
			cCampos := RTrim( SubStr( cLine, 2 ) )
			If cId == '1'
				AAdd( aCpos, { cCampos, '', '', '' } )
			Endif
			If cId == '2'
				aCpos[ Len( aCpos ), 2 ] := cCampos
			Endif
			If cId == '3'
				aCpos[ Len( aCpos ), 3 ] := cCampos
			Endif
			If cId == '4'
				aCpos[ Len( aCpos ), 4 ] := cCampos
			Endif
		End
		FT_FSKIP()
	End
	FT_FUSE()
	
Return

/*/{Protheus.doc} A870Atributo
Rotina para descarregar os dados do Atributo.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870Atributo( lEnd, oObj, aCpos, lJobPerf )
	
	Local aField   := {}
	
	Local cDados   := ''
	Local cHeader  := aCpos[ 1, 2 ]
	Local cNomeArq := aCpos[ 1, 4 ]  + '.txt'  
	
	Local nCnt     := 0
	Local nHdl     := 0
	Local nI       := 0 
	
	Local uConteudo 
	
	If !lJobPerf
		If File( cDirProc + cNomeArq )
			If .NOT. MsgYesNo( 'O arquivo ' + cNomeArq + ' já existe.' + CRLF + 'Deseja substituí-lo?', cCadastro )
				Return
			Endif
		Endif
	EndIf
	
	aField := StrTokArr( aCpos[ 1, 3 ], ';' )
	
	nHdl := FCreate( cDirProc + cNomeArq )
	
	FWrite( nHdl, cHeader + CRLF )
	
	dbSelectArea( 'ZZN' )
	dbSetOrder( 1 )
	If !lJobPerf
		oObj:SetRegua1( LastRec() )
	EndIf
	
	While ZZN->( .NOT. EOF() )
		If !lJobPerf
			oObj:IncRegua1('Processando ' + Ltrim( Str( ++nCnt ) ) )
		EndIf
		
		For nI := 1 To Len( aField )
			//uConteudo := &( aField[ nI ] )
			uConteudo := FieldGet( FieldPos( aField[ nI ] ) )
			
			If ValType( uConteudo ) == 'N'
				uConteudo := LTrim( Str( uConteudo ) )
				
			Elseif ValType( uConteudo ) == 'D'
				uConteudo := Dtoc( uConteudo )
				
			Endif
			
			cDados += alltrim(uConteudo) + ';' 
		Next nI 
		
		cDados := SubStr( cDados, 1, Len( cDados )-1 )
		
		FWrite( nHdl, cDados + CRLF )
		 
		cDados := ''
		ZZN->( dbSkip() )
	End
	FClose( nHdl )
	Sleep( 500 )
	
Return

/*/{Protheus.doc} A870Atributo
Rotina para descarregar os dados do Cargo.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870Cargo( lEnd, oObj, aCpos, lJobPerf )
	Local aField   := {}
	
	Local cDados   := ''
	Local cHeader  := aCpos[ 2, 2 ]
	Local cNomeArq := aCpos[ 2, 4 ]  + '.txt'  
	
	Local lMSBLQL  := .F.
	
	Local nCnt     := 0
	Local nHdl     := 0
	Local nI       := 0
	
	Local uConteudo 
	
	If !lJobPerf
		If File( cDirProc + cNomeArq )
			If .NOT. MsgYesNo( 'O arquivo ' + cNomeArq + ' já existe.' + CRLF + 'Deseja substituí-lo?', cCadastro )
				Return
			Endif
		Endif
	EndIf

	aField := StrTokArr( aCpos[ 2, 3 ], ';' )
	
	nHdl := FCreate( cDirProc + cNomeArq )
	
	FWrite( nHdl, cHeader + CRLF )
	
	dbSelectArea( 'SQ3' )
	dbSetOrder( 1 )
	
	lMsBlQl := SQ3->( FieldPos( 'Q3_MSBLQL' ) > 0 )
	
	If !lJobPerf
		oObj:SetRegua1( LastRec() )
	EndIf
	
	While SQ3->( .NOT. EOF() )
		If !lJobPerf
			oObj:IncRegua1('Processando ' + Ltrim( Str( ++nCnt ) ) )
		EndIf
		
		If lMsBlQl .AND. SQ3->Q3_MSBLQL == '1'
			SQ3->( dbSkip() )
			Loop
		Endif
		
		For nI := 1 To Len( aField )
			uConteudo := &( aField[ nI ] )
			
			If ValType( uConteudo ) == 'N'
				uConteudo := LTrim( Str( uConteudo ) )
				
			Elseif ValType( uConteudo ) == 'D'
				uConteudo := Dtoc( uConteudo )
				
			Endif
			
			cDados += alltrim(uConteudo) + ';' 
		Next nI 
		
		cDados := SubStr( cDados, 1, Len( cDados )-1 )
		
		FWrite( nHdl, cDados + CRLF )
		
		cDados := '' 
		SQ3->( dbSkip() )
	End
	
	FClose( nHdl )
	Sleep( 500 )
Return

/*/{Protheus.doc} A870Depto
Rotina para descarregar os dados do Departamento.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870Depto( lEnd, oObj, aCpos, lJobPerf )
	Local aField   := {}
	
	Local cDados   := ''
	Local cHeader  := aCpos[ 3, 2 ]
	Local cNomeArq := aCpos[ 3, 4 ]  + '.txt'//+ '_' + StrZero( Year( Date() ), 4, 0 ) + StrZero( Month( Date() ), 2, 0 ) + StrZero( Day( Date() ), 2, 0 ) + '.txt'
	
	Local lMSBLQL  := .F.
	
	Local nCnt     := 0  
	Local nHdl     := 0
	Local nI       := 0
	
	Local uConteudo 
	
	If !lJobPerf
		If File( cDirProc + cNomeArq )
			If .NOT. MsgYesNo( 'O arquivo ' + cNomeArq + ' já existe.' + CRLF + 'Deseja substituí-lo?', cCadastro )
				Return
			Endif
		Endif
	EndIf

	aField := StrTokArr( aCpos[ 3, 3 ], ';' )
	
	nHdl := FCreate( cDirProc + cNomeArq )
	
	FWrite( nHdl, cHeader + CRLF )
	
	dbSelectArea( 'CTT' )
	dbSetOrder( 1 )
	
	lMsBlQl := CTT->( FieldPos( 'CTT_MSBLQL' ) > 0 )
	
	If !lJobPerf
		oObj:SetRegua1( LastRec() )
	EndIf
	
	While CTT->( .NOT. EOF() )
		If !lJobPerf
			oObj:IncRegua1('Processando ' + Ltrim( Str( ++nCnt ) ) )
		EndIf	
		
		If lMsBlQl
			If CTT->CTT_MSBLQL == '1'
				CTT->( dbSkip() )
				Loop
			Endif
		Endif
		If CTT->CTT_CLASSE = '1' 
			CTT->( dbSkip() )
			Loop
		Endif
		IF ALLTRIM(GetAdvFVal('SRA','RA_NOME',"06"+CTT->CTT_CUSTO,2, "")) = ""   
			IF ALLTRIM(GetAdvFVal('SRA','RA_NOME',"07"+CTT->CTT_CUSTO,2, "")) = ""
				CTT->( dbSkip() )
				Loop
			ENDIF
		ENDIF
		
		For nI := 1 To Len( aField )
			uConteudo := &( aField[ nI ] )
			
			If ValType( uConteudo ) == 'N'
				uConteudo := LTrim( Str( uConteudo ) )
				
			Elseif ValType( uConteudo ) == 'D'
				uConteudo := Dtoc( uConteudo )
				
			Endif
			
			cDados += ALLTRIM(uConteudo) + ';' 
		Next nI 
		
		cDados := SubStr( cDados, 1, Len( cDados )-1 )
		
		FWrite( nHdl, cDados + CRLF )
		 
		cDados := ''
		CTT->( dbSkip() )
	End
	
	FClose( nHdl )
	Sleep( 500 )
Return

/*/{Protheus.doc} A870Usuario
Rotina para descarregar os dados do Usuário.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870Usuario( lEnd, aRet, oObj, aCpos, lJobPerf )
	
	Local aField   := {}
	
	Local cCount   := ''
	Local cDados   := ''
	Local cHeader  := aCpos[ 4, 2 ]
	Local cNomeArq := aCpos[ 4, 4 ] + '.txt'// + '_' + StrZero( Year( Date() ), 4, 0 ) + StrZero( Month( Date() ), 2, 0 ) + StrZero( Day( Date() ), 2, 0 ) + '.txt'
	Local cSQL     := ''
	Local cTRB     := ''
	Local cType    := ''
	
	Local nCnt     := 0
	Local nHdl     := 0
	Local nI       := 0
	
	If !lJobPerf
		If File( cDirProc + cNomeArq )
			If .NOT. MsgYesNo( 'O arquivo ' + cNomeArq + ' já existe.' + CRLF + 'Deseja substituí-lo?', cCadastro )
				Return
			Endif
		Endif
	EndIf

	nHdl := FCreate( cDirProc + cNomeArq )
	
	FWrite( nHdl, cHeader + CRLF )
	
	aField := StrTokArr( aCpos[ 4, 3 ], ';' )
	
	For nI := 1 To Len( aField )
		If nI == 1
			cSQL := "SELECT DISTINCT "
		Endif
		cSQL += aField[ nI ] + ', '
	Next nI 
	cSQL := SubStr( cSQL, 1, Len( cSQL )-2 )
	
	cSQL += "       FROM " + RetSqlName( "SRA" ) + " SRA, "
	cSQL += "       	 "+	 RetSqlName( "ZZL" ) + " ZZL "
	cSQL += "       WHERE RA_FILIAL BETWEEN " + ValToSql( aRet[ 1 ] ) + " AND " + ValToSql( aRet[ 2 ] ) + " " 
	cSQL += "       AND RA_MAT BETWEEN " + ValToSql( aRet[ 3 ] ) + " AND " + ValToSql( aRet[ 4 ] ) + " "
	cSQL += "       AND RA_DEMISSA = ' ' "
	cSQL += "       AND (ZZL_CPF = RA_CIC or RA_CC = '030101A') "
    cSQL += "       AND RA_FILIAL = ZZL_FILIAL "
	cSQL += "       AND SRA.D_E_L_E_T_ = ' ' " 
	cSQL += "       AND ZZL.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	
	cCount := " SELECT COUNT(*) TB_COUNT FROM ( " + cSQL + " ) QUERY "
	
	If At( 'ORDER BY', Upper( cCount ) ) > 0
		cCount := SubStr( cCount, 1, At( 'ORDER BY', cCount )-1 ) + SubStr( cCount, RAt( ')', cCount ) )
	Endif	
	
	cTRB := GetNextAlias()
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cCount ), cTRB, .F., .T. )
	nCount	:= (cTRB)->TB_COUNT
	(cTRB)->(dbCloseArea())
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	dbSelectArea( cTRB )
	
	If !lJobPerf
		oObj:SetRegua1( nCount )
	EndIf
	
	While (cTRB)->( .NOT. EOF() )
		If !lJobPerf
			oObj:IncRegua1('Processando ' + Ltrim( Str( ++nCnt ) ) )
		EndIf
		
		For nI := 1 To Len( aField )
			If SubStr( aField[ nI ], 1, 6 ) == "' ' AS"
				cType := ''
				uConteudo := ' '
			Else
				cType := Posicione( 'SX3', 2, aField[ nI ], 'X3_TIPO' )				
				uConteudo := &( aField[ nI ] )	
								
				Do Case
					Case aField[ nI ] = "RA_XCGEST"  
						uConteudo := Posicione("SRA",13,uConteudo,"RA_CIC") 
					Case aField[ nI ] = "RA_FILIAL" 
						uConteudo := " "
				EndCase      
				If ValType( uConteudo ) == 'N'
					uConteudo := LTrim( Str( uConteudo ) )					
				Elseif ValType( uConteudo ) == 'D'
					uConteudo := Dtoc( uConteudo )				
				Elseif cType == 'D'
					uConteudo :=  formatadata( Stod( uConteudo ),4 )					
				Endif
				
			Endif
				IF  aField[ nI ] = "RA_FILIAL" 
					uConteudo := " "
				Else		
					cDados += alltrim(uConteudo) + ';'
				EndIf 
		Next nI		
		cDados := SubStr( cDados, 1, Len( cDados )-1 )
		
		FWrite( nHdl, cDados + CRLF )
		
		cDados := ''
		(cTRB)->( dbSkip() )
	End
	
	(cTRB)->( dbCloseArea() )
	
	FClose( nHdl )
	Sleep( 500 )
	
Return

/*/{Protheus.doc} A870UsAtrib
Rotina para descarregar os dados do Usuário x Atributos.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870UsAtrib( lEnd, oObj, aCpos, lJobPerf )
	Local aField   := {}
	
	Local cDados   := ''
	Local cHeader  := aCpos[ 5, 2 ]
	Local cNomeArq := aCpos[ 5, 4 ]  + '.txt'//+ '_' + StrZero( Year( Date() ), 4, 0 ) + StrZero( Month( Date() ), 2, 0 ) + StrZero( Day( Date() ), 2, 0 ) + '.txt'  
	Local cSitFolh := ''
	
	Local lFil06SF := .F.
	Local lFil07SF := .F.
	
	Local nCnt     := 0
	Local nHdl     := 0
	Local nI       := 0
	
	Local uConteudo 

	If !lJobPerf
		If File( cDirProc + cNomeArq )
			If .NOT. MsgYesNo( 'O arquivo ' + cNomeArq + ' já existe.' + CRLF + 'Deseja substituí-lo?', cCadastro )
				Return
			Endif
		Endif
	EndIf

	aField := StrTokArr( aCpos[ 5, 3 ], ';' )
	
	nHdl := FCreate( cDirProc + cNomeArq )
	
	FWrite( nHdl, cHeader + CRLF )
	
	dbSelectArea( 'ZZM' )
	dbSetOrder( 1 )
	
	If !lJobPerf
		oObj:SetRegua1( LastRec() )
	EndIf
	
	dbSelectArea('SRA')
	SRA->(dbSetOrder(5))
	
	While ZZM->( .NOT. EOF() )
		If !lJobPerf
			oObj:IncRegua1('Processando ' + Ltrim( Str( ++nCnt ) ) )
		EndIf
		
		cSitFolh := ''
		lFil06SF := .F.
		lFil07SF := .F.
		IF ALLTRIM(GetAdvFVal('SRA','RA_SITFOLH',"06"+ZZM->ZZM_CPF,5, "")) == "D"
			If SRA->( dbSeek( '06' + ZZM->ZZM_CPF ) )
			
				While SRA->( !Eof() ) .And. AllTrim(ZZM->ZZM_CPF) == SRA->RA_CIC
					cSitFolh := SRA->RA_SITFOLH
					If Empty(cSitFolh)
						Exit
					EndIf
					SRA->(dbSkip())
				EndDo
			
				If cSitFolh == "D"
					lFil06SF := .T.  
				EndIf
			
			EndIf
		EndIf
		
		IF ALLTRIM(GetAdvFVal('SRA','RA_SITFOLH',"07"+ZZM->ZZM_CPF,5, "")) == "D"
			If SRA->( dbSeek( '07' + ZZM->ZZM_CPF ) )
			
				While SRA->( !Eof() ) .And. AllTrim(ZZM->ZZM_CPF) == SRA->RA_CIC
					cSitFolh := SRA->RA_SITFOLH
					If Empty(cSitFolh)
						Exit
					EndIf
					SRA->(dbSkip())
				EndDo
			
				If cSitFolh == "D"
					lFil07SF := .T.
				EndIf
			
			EndIf
		EndIf
		
		If lFil06SF .And. lFil07SF
			ZZM->( dbSkip() )
			Loop
		EndIf
		
		/*
		IF ALLTRIM(GetAdvFVal('SRA','RA_SITFOLH',"06"+ZZM->ZZM_CPF,5, "")) == "D"   
			ZZM->( dbSkip() )
			Loop
		ENDIF
		IF ALLTRIM(GetAdvFVal('SRA','RA_SITFOLH',"07"+ZZM->ZZM_CPF,5, "")) == "D"
			ZZM->( dbSkip() )
			Loop
		ENDIF
		*/
		
		For nI := 1 To Len( aField )
			uConteudo := &( "ZZM->" + aField[ nI ] )
			
			If ValType( uConteudo ) == 'N'
				uConteudo := LTrim( Str( uConteudo ) )
				
			Elseif ValType( uConteudo ) == 'D'
				uConteudo := Dtoc( uConteudo )
				
			Endif
			
			cDados += Alltrim(uConteudo) + ';' 
		Next nI 
		
		cDados := SubStr( cDados, 1, Len( cDados )-1 )
		
		FWrite( nHdl, cDados + CRLF ) 
		
		cDados := ''
		ZZM->( dbSkip() )
	End
	
	FClose( nHdl )
	Sleep( 500 )
Return

/*/{Protheus.doc} A870UsDomin
Rotina para descarregar os dados do Usuário x Domínio.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870UsDomin( lEnd, oObj, aCpos, lJobPerf )
	Local aField    := {}
	
	Local cDados    := ''
	Local cHeader   := aCpos[ 6, 2 ]
	Local cNomeArq  := aCpos[ 6, 4 ] + '.txt'  
	
	Local nCnt      := 0
	Local nHdl      := 0
	Local nI        := 0
	
	Local cSitFol06 := ""
	Local cSitFol07 := ""
	
	Local uConteudo 
	
	If !lJobPerf
		If File( cDirProc + cNomeArq )
			If .NOT. MsgYesNo( 'O arquivo ' + cNomeArq + ' já existe.' + CRLF + 'Deseja substituí-lo?', cCadastro )
				Return
			Endif
		Endif
	EndIf

	aField := StrTokArr( aCpos[ 6, 3 ], ';' )
	
	nHdl := FCreate( cDirProc + cNomeArq )
	
	FWrite( nHdl, cHeader + CRLF )
	
	dbSelectArea( 'ZZL' )
	dbSetOrder( 1 )
	
	If !lJobPerf
		oObj:SetRegua1( LastRec() )
	EndIf
	
	While ZZL->( .NOT. EOF() )
		If !lJobPerf
			oObj:IncRegua1('Processando ' + Ltrim( Str( ++nCnt ) ) )
		EndIf
		
		cSitFol06 := ALLTRIM(GetAdvFVal('SRA','RA_SITFOLH',"06"+ZZL->ZZL_CPF,5, "")) = "D"
		cSitFol07 := ALLTRIM(GetAdvFVal('SRA','RA_SITFOLH',"07"+ZZL->ZZL_CPF,5, "")) = "D" 
		
		If cSitFol06 .And. cSitFol07
			ZZL->( dbSkip() )
			Loop
		EndIf
		
		/*IF ALLTRIM(GetAdvFVal('SRA','RA_SITFOLH',"06"+ZZL->ZZL_CPF,5, "")) = "D"   
			ZZL->( dbSkip() )
			Loop
		ENDIF
		IF ALLTRIM(GetAdvFVal('SRA','RA_SITFOLH',"07"+ZZL->ZZL_CPF,5, "")) = "D"
			ZZL->( dbSkip() )
			Loop
		ENDIF*/
		For nI := 1 To Len( aField )
			uConteudo := &( aField[ nI ] )
			
			If ValType( uConteudo ) == 'N'
				uConteudo := LTrim( Str( uConteudo ) )
				
			Elseif ValType( uConteudo ) == 'D'
				uConteudo := Dtoc( uConteudo )
				
			Endif
			
			cDados += ALLTRIM(uConteudo) + ';' 
		Next nI 
		
		cDados := SubStr( cDados, 1, Len( cDados )-1 )
		
		FWrite( nHdl, cDados + CRLF )
		
		cDados := ''
		ZZL->( dbSkip() )
	End
	
	FClose( nHdl )
	Sleep( 500 )
Return

/*/{Protheus.doc} A870UpLoad
Rotina para fazer upload dos arquivos.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870UpLoad( aParam, aLog, lJobPerf )
	Local aArq := {}
	Local ni	:= 1

	aArq := Directory( cDirProc + '*.txt' )
	
	If Len( aArq ) == 0
		If lJobPerf
			Conout('[CSFA870_' + DTOS(Date()) + '_' + Time() + '] - ' + 'Não há arquivos para fazer upload, por favor certifique-se.')
		Else
			MsgAlert( 'Não há arquivos para fazer upload, por favor certifique-se.', cCadastro )
		EndIf
		Return
	Endif
	
	If FTPConnect( aParam[1] , aParam[2], aParam[3], A870Decode(), ( aParam[4] == 'S' ) )		
		For nI := 1 To Len( aArq )
			If FTPUpLoad( cDirProc + aArq[ nI, 1 ], aArq[ nI, 1 ] )
				AAdd( aLog, '[SUCESSO] - UPLOAD DO ARQUIVO: ' + cDirProc + aArq[ nI, 1 ] )
				If __CopyFile( cDirProc + aArq[ nI, 1 ], cDirUpLoad + aArq[ nI, 1 ] )
					AAdd( aLog, '[SUCESSO] - MOVER O AQUIVO ' + aArq[ nI, 1 ] + ' PARA A PASTA: ' + cDirUpLoad )
					FErase( cDirProc + aArq[ nI, 1 ] )
				Else
					AAdd( aLog, '[FALHA] - MOVER O AQUIVO ' + aArq[ nI, 1 ] + ' PARA A PASTA: ' + cDirUpLoad )
				Endif
			Else
				AAdd( aLog, '[FALHA] - UPLOAD DO ARQUIVO: ' + cDirProc + aArq[ nI, 1 ] )
			Endif
		Next nI
		FTPDisConnect()
	Else
		If lJobPerf
			Conout('[CSFA870_' + DTOS(Date()) + '_' + Time() + '] - ' + 'Nao foi possivel se conectar no servidor FTP.')
		Else
			MsgAlert( 'Nao foi possivel se conectar no servidor FTP.', cCadastro )
		EndIf
	Endif
Return

/*/{Protheus.doc} A870ShowLog
Rotina para apresentar o log de processamento.
@author robson.goncalves
@since 13/10/2017
/*/Static Function A870ShowLog( aLog )
	Local bSair := {|| oDlg:End() }
	
	Local cArqLog := ''
	Local cPar1 := 0
	Local cPar2 := 0
	
	Local nHdl := 0
	Local nList := 0
	
	Local oBar
	Local oDlg

	Local oFnt := TFont():New('Arial',,,,.F.,,,8,.T.,,,,,,,)
	Local oFntBox := TFont():New( "Courier New",,-11)

	Local oPnlMaior
	Local oPnlButton

	Local oThb
	Local oTLbx
	
	DEFINE MSDIALOG oDlg TITLE 'Log de processamento' FROM 0,0 TO 360,800 PIXEL
		oPnlMaior := TPanel():New(0,0,,oDlg,,,,,,13,0,.F.,.F.)
		oPnlMaior:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlButton := TPanel():New(0,0,,oDlg,,,,,,13,13,.F.,.F.)
		oPnlButton:Align := CONTROL_ALIGN_BOTTOM
		
		oBar := TBar():New( oPnlButton, 10, 9, .T.,'BOTTOM')
		
		oThb := THButton():New( 1, 1, '&Sair', oBar, bSair , 20, 12, oFnt )
		oThb:Align := CONTROL_ALIGN_RIGHT
		
		oTLbx := TListBox():New(0,0,{|u| Iif(PCount()>0,nList:=u,nList)},{},100,46,,oPnlMaior,,,,.T.,,,oFntBox)
		oTLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oTLbx:SetArray( aLog )
	ACTIVATE MSDIALOG oDlg CENTERED
	
	cPar1 := Str( Year( Date() ), 4, 0 ) + StrZero( Month( Date() ), 2 ) + StrZero( Day( Date() ), 2 )
	cPar2 := StrTran( Time(), ':', '' )
	
	cArqLog := 'Performa_' + cPar1 + '_' + cPar2 + '.log'
	
	While .T.
		If File( cArqLog )
			Sleep(1000)
			cPar2 := StrTran( Time(), ':', '' )
			cArqLog := 'Performa_' + cPar1 + '_' + cPar2 + '.log'
		Else
			nHdl := FCreate( cArqLog )
			Exit
		Endif
	End
	
	AEval( aLog, {|e| FWrite( nHdl, e + CRLF ) } )
	
	Sleep(1000)
	
	FClose( nHdl )
	
	__CopyFile( cDirProc + cArqLog, cDirLog + cArqLog )
	
	FErase( cDirProc + cArqLog )
Return

/*/{Protheus.doc} CSFA871
Cadastro de usuário X domínio.
@author robson.goncalves
@since 13/10/2017
@version 1.0
/*/
User Function CSFA871()
	AxCadastro( 'ZZL', 'Usuário x Domínio' )
Return

/*/{Protheus.doc} CSFA872
Cadastro de usuário X atributos do dominio.
@author robson.goncalves
@since 13/10/2017
@version 1.0
/*/
/*User Function CSFA872()
	AxCadastro( 'ZZM', 'Usuário x Atributo do domínio' )
Return*/

/*/{Protheus.doc} CSFA873
Cadastro de atributos comportamentais.
@author robson.goncalves
@since 13/10/2017
@version 1.0
/*/
User Function CSFA873()
	AxCadastro( 'ZZN', 'Atributos comportamentais' )
Return

/*/{Protheus.doc} VldCPFSRA
Validação do domínio principal.
@author robson.goncalves
@since 13/10/2017
@version 1.0
/*/
User Function VldCPFSRA( cCpo )
	Local cCPF := GetAdvFVal( 'SRA', 'RA_CIC', xFilial( 'SRA' ) + Alltrim( cCpo ), 5 )
	If Empty( cCPF )
		MsgAlert('CPF não encontrado.','CPF inválido')
		Return( .F. )
	Endif
Return( .T. )

/*/{Protheus.doc} UsrXDom
Rotina de validação de usuário X domínio principal.
@author robson.goncalves
@since 13/10/2017
@version 1.0
/*/
User Function UsrXDom( cCampo )
	Local aArea := GetArea() 
	Local lContinua := .T.
	
	M->ZZL_PRINCI := '1'
	
	dbSelectArea( 'ZZL' )
	dbSetOrder( 1 )
	dbSeek( xFilial( 'ZZL' ) + M->ZZL_CPF + M->ZZL_DOMINI )
	
	While .NOT. EOF() .AND. lContinua .AND. ZZL->ZZL_CPF == M->ZZL_CPF .AND. ZZL->ZZL_DOMINI == M->ZZL_DOMINI
		If ZZL->ZZL_PERFIL == M->ZZL_PERFIL
			MsgAlert('Perfil já cadastrado para este domínio e CPF.','CPF já cadastrado')
			lContinua := .F.
		Else
			M->ZZL_PRINCI := '2'
		Endif
		ZZL->( dbSkip() )
	End 
	RestArea( aArea )
Return( lContinua )

/*/{Protheus.doc} A870SXB
Rotina para criar a chamada F3 da consulta SXB.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870SXB()
	Local aCpoXB := {}
	Local aSXB := {}
	Local cXB_ALIAS := '870SRA'
	Local nI := 0
	Local nJ := 0
	
	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}
	
	AAdd( aSXB, { cXB_ALIAS, '1', '01', 'RE', 'Funcionarios', 'Funcionarios', 'Funcionarios', 'SRA'        , '' } )
	AAdd( aSXB, { cXB_ALIAS, '2', '01', '01', ''            , ''            , ''            , 'U_A870SRA()', '' } )
	AAdd( aSXB, { cXB_ALIAS, '5', '01', ''  , ''            , ''            , ''            , 'SRA->RA_MAT', '' } )
	
	SXB-> (dbSetOrder( 1 ) )
	
	For nI := 1 To Len( aSXB )
		If .NOT. SXB->( dbSeek( aSXB[ nI, 1 ] + aSXB[ nI, 2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
			SXB->( RecLock( 'SXB', .T. ) )
			For nJ := 1 To Len( aSXB[ nI ] )
				SXB->( FieldPut( FieldPos( aCpoXB[ nJ ] ), aSXB[ nI, nJ ] ) )
			Next nJ
			SXB->( MsUnLock() )
		Endif
	Next nI
Return

/*/{Protheus.doc} A870SRA
Rotina de apresentação dos dados na consulta F3 do campo de parâmnetros.
@author robson.goncalves
@since 13/10/2017
/*/
User Function A870SRA()
	Local bOk
	Local bPesq 
	
	Local cPESQ := Space(100)
	Local cPlaceHold
	Local cSQL
	Local cTRB
	
	Local nOpc := 1
	
	Local oCancel
	Local oConfirm
	Local oDlg
	Local oGet
	Local oGroup
	Local oLbx
	Local oOpc
	Local oPanelAll
	Local oPanelBot
	Local oPanelTop
	Local oPesq
	
	If Len( a870Dados ) == 0
		cSQL := "SELECT RA_FILIAL, "
		cSQL += "       RA_MAT, "
		cSQL += "       RA_NOME, "
		cSQL += "       R_E_C_N_O_ AS RA_RECNO "
		cSQL += "FROM   "+RETSQLNAME("SRA")+" SRA "
		cSQL += "WHERE  RA_FILIAL BETWEEN '06' AND '07' "
		cSQL += "       AND RA_DEMISSA = ' ' " 
		cSQL += "       AND SRA.D_E_L_E_T_ = ' ' "
		cSQL += "ORDER  BY RA_FILIAL, RA_MAT "
		
		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		
		dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
		
		While (cTRB)->( .NOT. EOF() )
			(cTRB)->( AAdd( a870Dados, { RA_FILIAL, RA_MAT, RA_NOME, RA_RECNO } ) )
			(cTRB)->( dbSkip() )
		End
		
		(cTRB)->( dbCloseArea() )
	Endif
	
	bPesq := {|| A870Seek( nOpc, cPESQ, oLbx ) }
	bOk := {|| A870Ok( oLbx ) }
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 400,500 TITLE cCadastro PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,42,.F.,.F.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
		oGroup:= TGroup():New(2,2,39,251,'',oPanelTop,,,.T.)
		
		@ 5,6 SAY 'Pesquisar por' SIZE 200,7 PIXEL OF oPanelTop
		
		oOpc := TRadMenu():New (5,46,{'Matrícula','Nome'},,oPanelTop,,,,,,,,70,10,,,,.T.,.T.)
		oOpc:bSetGet := {|u|Iif (PCount()==0,nOpc,nOpc:=u)}
		
		cPlaceHold := 'Pesquisar...'
		oGet := TGet():New(17,6,{|u| If(PCount() > 0, cPESQ := u, cPESQ ) },oPanelTop,195,10,/*cPict ]*/,/*bValid*/,,,,,,.T.,,,/*bWhen*/,,,/*bExecute*/,/*lReadOnly*/,,,cPESQ,,,,,,,,,,,cPlaceHold)
		
		@ 17,204 BUTTON oPesq ; 
		         PROMPT 'Pesquisar' ; 
		         SIZE 43,11 PIXEL OF oPanelBot ;
		         ACTION Eval( bPesq )
		
		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.F.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oLbx := TwBrowse():New(1,1,1000,1000,,{'Filial','Matrícula','Nome'},,oPanelAll,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( a870Dados )
		oLbx:bLine := {|| AEval( a870Dados[ oLbx:nAt ], { | value, index | a870Dados[ oLbx:nAt, index ] } ) }
		oLbx:bLDblClick := {|| Eval( bOk ), oDlg:End()	}
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.F.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM
		
		@ 1,1  BUTTON oConfirm ;
		       PROMPT '&Confirmar' ;
		       SIZE 40,11 PIXEL OF oPanelBot ;
		       ACTION ( Eval( bOk ), oDlg:End() )
		
		@ 1,44 BUTTON oCancel ;
		       PROMPT '&Sair' ;
		       SIZE 40,11 PIXEL OF oPanelBot ;
		       ACTION ( oDlg:End() )
	
	ACTIVATE MSDIALOG oDlg CENTERED
Return( .T. )

/*/{Protheus.doc} A870Seek
Pesquisar no vetor a matrícula ou nome do funcionário
@author robson.goncalves
@since 13/10/2017
@version 1.0
/*/Static Function A870Seek( nOpc, cPESQ, oLbx )
	Local bAScan := {|| .T. }
	
	Local cSeek := Upper( AllTrim( cPESQ ) )
	
	Local nBegin := 0
	Local nColPesq := 0
	Local nEnd := 0
	Local nP := 0
	
	If nOpc == 1		//Opção por matrícula.
		nColPesq := 2	//Coluna de pesquina matrícula.
	Elseif nOpc == 2	//Opção por nome.
		nColPesq := 3	//Coluna de pesquina nome.
	Else
		MsgAlert('Opção não disponível para pesquisar.','Pesquisar')
	Endif
		
	If nColPesq > 0
		nBegin := Min( oLbx:nAt + 1, Len( oLbx:aArray ) )
		nEnd   := Len( oLbx:aArray )
		
		If oLbx:nAt == Len( oLbx:aArray )
			nBegin := 1
		Endif
		
		bAScan := {|p| Upper(AllTrim( cSeek ) ) $ AllTrim( p[nColPesq] ) } 
		
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )

		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('Informação não localizada.','Pesquisar')
		Endif
	Endif
Return( .T. )

/*/{Protheus.doc} A870Ok
Posicionar registro da tabela conforme o elemento do vetor.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870Ok( oLbx )
	dbSelectArea( 'SRA' )
	dbSetOrder( 1 )
	dbGoTo( oLbx:aArray[ oLbx:nAt, 4 ] )
Return( .T. )

/*/{Protheus.doc} A870ArmPsw
Rotina para criar senha em parâmetros existentes na tabela SX6.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870ArmPsw()
	Local aButton := {}
	Local aSay := {}

	Local nOpcao := 0
	
	Private cCadastro := 'Administração de senha'

	AAdd( aSay, 'Esta rotina tem por objetivo armazenar senhas na tabela de parâmetros SX6.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao==1
		A870PswGrv()
	Endif
Return


/*/{Protheus.doc} A870PswGrv
Rotina para gravar a senha no parâmetro SX6.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870PswGrv()
	Local aPar := {}
	Local aRet := {}
	Local cKey := "ƒØ£gar"
	
	AAdd( aPar, { 3, "O que deseja fazer",1,{"a) Gravar senha.","b) Testar a senha gravada."},99,"",.F.})
	AAdd( aPar, { 1, "Parâmetro", Space(Len(SX6->X6_VAR)), "", "", "", "", 0, .T. } )
	AAdd( aPar, { 8, "Senha"    , Space(Len(SX6->X6_CONTEUD)), "@S90", "", "", "", 99, .T. } )
	
	If ParamBox( aPar, 'Password', @aRet,,,,,,,, .F., .F. )
		If aRet[ 1 ] == 1
			If GetMv( RTrim( aRet[ 2 ] ), .T. )
				cPsw := AllTrim( aRet[ 3 ] )
				cPsw := Encode64( SubStr( cPsw, 1, 3 ) + cKey + SubStr( cPsw, 4 ) + "#" )
				PutMv( aRet[ 2 ], cPsw )
				MessageBox('Operação realizada com sucesso.','Password',0)
			Else
				MsgAlert('Não encontrado o parâmetro ' + RTrim( aRet[ 2 ] ) + ', por favor, faça o cadastro do parâmetro primeiro.', cCadastro ) 
			Endif
		Else
			If GetMv( RTrim( aRet[ 2 ] ), .T. )
				cPsw := AllTrim( aRet[ 3 ] )
				If A870PswVld( aRet[ 2 ], cPsw )
					MessageBox('Operação de confirmar a senha realizado com sucesso.','Password',0)
				Endif
			Else
				MsgAlert('Não encontrado o parâmetro ' + RTrim( aRet[ 2 ] ) + ', por favor, faça o cadastro do parâmetro primeiro.', cCadastro ) 
			Endif
		Endif
	Endif
Return

/*/{Protheus.doc} A870PswVld
Rotina para validar se a senha informada confere com a senha armazenada.
@author robson.goncalves
@since 13/10/2017
/*/
Static Function A870PswVld( cPar, cPsw )
	Local cKey := "ƒØ£gar"
	
	DEFAULT cPar := 'nada'
	DEFAULT cPSW := 'nada'
	
	If GetMv( RTrim( cPar ), .T. )
		cPsw := AllTrim( cPsw ) 
		cPsw := Encode64( SubStr( cPsw, 1, 3 ) + cKey + SubStr( cPsw, 4 ) + "#" )
		If GetMv( RTrim( cPar ), .F. ) == cPsw
			Return( .T. )
		Else
			MsgAlert('Senha incorreta.','Password')
		Endif
	Else
		MsgAlert('Não encontrei o parâmetro ' + cPar + ', por favor, verifique.', 'Password' )
	Endif
Return( .F. )

Static Function A870Decode()
Return( Decode64( GetMv( 'MV_870_05', .F. ) ) )

/*/{Protheus.doc} UpdPerforma
Rotina para fazer update de dicionário de dados e tabela.
@author robson.goncalves
@since 13/10/2017
@version 1.0
/*/
User Function UpdPerforma()
	Local cModulo := 'GPE'
	Local bPrepZZN := {|| U_TabPerforma() }
	Local nVersao := 1
	
	Private aSX2 := {}
	Private aSX3 := {}
	Private aSIX := {}
	
	NGCriaUpd(cModulo,bPrepZZN,nVersao)	
Return

/*/{Protheus.doc} TabPerforma
Rotina para alimentar os dados a fazer update de dicionário de dados e tabela.
@author robson.goncalves
@since 13/10/2017
@version 1.0
/*/
User Function TabPerforma()	  
	aSX2 := {}
	aSX3 := {}
	aSIX := {}
	ASXA := {}
	ASXB := {}
	ASX7 := {}
	
	//	TABELA ZZL == CADASTRO DE USUARIO X DOMINIO           
	AAdd(	aSX2,{	'ZZL',;					//Alias
	           		'',;					//Path
	           		'Usuario x Dominio ',;	//Nome
	           		'Usuario x Dominio ',;	//Nome esp.
	           		'Usuario x Dominio ',;	//Nome inglês
	           		'C',;					//Modo
	           		'',;					//Único
	           		'C',;					//Modo unidade.
	           		'C'})					//Modo empresa.	
	           
	AAdd(aSX3,{"ZZL","01","ZZL_FILIAL","C", 2 ,0,"Filial"   ,"Sucursal" ,"Branch"   ,"Filial do Sistema","Sucursal"         ,"Branch of the System" ,"@!","","€€€€€€€€€€€€€€€",""                             ,"",1,"þÀ","","","U","N","A","R","" ,"",""				,"","","","","","033","","","","","","N","N","",""})
	AAdd(aSX3,{"ZZL","02","ZZL_CPF"	  ,"C", 50,0,"CPF"	  	,"CPF"		,"CPF"		,"CPF"				,"CPF"				,"CPF"					,"@!","","€€€€€€€€€€€€€€ ",""							  ,"CPFSRA",0,"þÀ","","","U","S","R","R","" ,"U_VLDCPFSRA(M->ZZL_CPF)"	,"","","","","","",""	 ,"","","","","","N","N","",""})
	AAdd(aSX3,{"ZZL","03","ZZL_PERFIL","C", 20,0,"PERFIL"	,"PERFIL"	,"PERFIL"	,"PERFIL"			,"PERFIL"			,"PERFIL"				,"@!","","€€€€€€€€€€€€€€ ",""	 				          ,""	   ,0,"þÀ","","","U","S","R","R","" ,"u_USRXDOM()"				,"","","","","","",""   ,"","","","","","N","N","",""})
	AAdd(aSX3,{"ZZL","04","ZZL_DOMINI","C", 20,0,"DOMINIO"  ,"DOMINIO"	,"DOMINIO"	,"ID DOMINIO"		,"ID DOMINIO"		,"ID DOMINIO"			,"@!","","€€€€€€€€€€€€€€ ",""				         	  ,""	   ,0,"þÀ","","","U","S","R","R","" ,"u_USRXDOM()",""			,"","","","","",""	 ,"","","","","","N","N","",""})
	AAdd(aSX3,{"ZZL","05","ZZL_PRINCI","C", 2 ,0,"PRINCIPAL","PRINCIPAL","PRINCIPAL","DOMINIO PRINCIPAL","DOMINIO PRINCIPAL","DOMINIO PRINCIPAL"	,"@!","","€€€€€€€€€€€€€€ ","IF(ExistChav('ZZL', ZZL_FILIAL+ZZL_CPF+ZZL_PERFIL+ZZL_DOMINI,1),'1','2')" ,"",0,"þÀ","","","U","S","R","R","" ,"","1=Sim;2=Não"	,"","","","","",""	 ,"","","","","","N","N","",""}) 
	
	AAdd(aSIX,{"ZZL","1","ZZL_FILIAL+ZZL_CPF+ZZL_PERFIL+ZZL_DOMINI","CPF+PERFIL+DOMINIO","CPF+PERFIL+DOMINIO","CPF+PERFIL+DOMINIO","U","S"})
	AAdd(aSIX,{"ZZL","2","ZZL_FILIAL+ZZL_CPF+ZZL_DOMINI","CPF+DOMINIO","CPF+DOMINIO","CPF+DOMINIO","U","S"})
	
	AAdd(aSXB,{"ZZL","1","01","DB","usuario x Dominio "	,"usuario x Dominio "	,"usuario x Dominio "	,"ZZL"							,""})
	AAdd(aSXB,{"ZZL","2","01","02","Cpf+dominio"		,"Cpf+dominio       "	,"Cpf+dominio "			,""								,""})
	AAdd(aSXB,{"ZZL","4","01","01","CPF"				,"CPF"					,"CPF"					,"ZZL_CPF"						,""})
	AAdd(aSXB,{"ZZL","4","01","02","DOMINIO"			,"DOMINIO"				,"DOMINIO"				,"ZZL_DOMINI"					,""})
	AAdd(aSXB,{"ZZL","5","01",""  ,""					,""						,""						,"ZZL->ZZL_DOMINI"				,""})
	AAdd(aSXB,{"ZZL","6","01",""  ,""					,""						,""						,"ZZL->ZZL_CPF = M->ZZM_CPF"	,""})
	
	AAdd(aSXB,{"CPFSRA","1","01","DB","CPF FUNCIONARIO"	,"CPF FUNCIONARIO"	,"CPF FUNCIONARIO"	,"SRA"				,""})
	AAdd(aSXB,{"CPFSRA","2","01","03","Nome + Matricula","Nome + Matricula"	,"Nome + Matricula"	,""					,""})
	AAdd(aSXB,{"CPFSRA","2","02","01","Matricula"		,"Matricula"		,"Matricula"		,"ZZN_CODIGO"		,""})
	AAdd(aSXB,{"CPFSRA","2","03","05","Cpf"				,"Cpf"				,"Cpf"				,"Cpf"				,""})
	AAdd(aSXB,{"CPFSRA","4","01","01","Matricula"		,"Matricula"		,"Matricula"		,"RA_MAT"			,""})
	AAdd(aSXB,{"CPFSRA","4","01","02","Nome"			,"Nome"				,"Nome"				,"RA_NOME"			,""})
	AAdd(aSXB,{"CPFSRA","4","01","03","C.P.F."			,"C.P.F."			,"C.P.F."			,"RA_CIC"			,""})
	AAdd(aSXB,{"CPFSRA","5","01","",""					,""					,""					,"SRA->RA_CIC  "	,""})
	
	//	TABELA ZZM == usuario x atributo no dominio
	AAdd(aSX2,{'ZZM',;								//Alias
	           '',;									//Path
	           'Usuario x Atributo no dominio',;	//Nome
	           'Usuario x Atributo no dominio',;	//Nome esp.
	           'Usuario x Atributo no dominio',;	//Nome inglês
	           'C',;								//Modo
	           '',;									//Único
	           'C',;								//Modo unidade.
	           'C'})								//Modo empresa.	                      
	   
	AAdd(aSX3,{"ZZM","01","ZZM_FILIAL","C", 2 ,0,"Filial"     ,"Sucursal"   ,"Branch"   ,"Filial do Sistema"    ,"Sucursal"             ,"Branch of the System" ,"@!","","€€€€€€€€€€€€€€€","",""   		,1,"þÀ","","","U","N","R","R","" ,"","","","","","","","033","","","","","","N","N","",""})
	AAdd(aSX3,{"ZZM","02","ZZM_ATRIB ","C", 20,0,"ATRIBUTO"	  ,"ATRIBUTO"	,"ATRIBUTO"	,"CODIGO DO ATRIBUTO"	,"CODIGO DO ATRIBUTO"	,"CODIGO DO ATRIBUTO"	,"@!","","€€€€€€€€€€€€€€ ","","ZZN"		,0,"þÀ","","","U","S","R","R","" ,"","","","","","","",""   ,"","","","","","N","N","",""})
	AAdd(aSX3,{"ZZM","03","ZZM_CPF"	  ,"C", 50,0,"CPF"	  	  ,"CPF"		,"CPF"		,"CPF DO USUARIO"		,"CPF DO USUARIO"		,"CPF DO USUARIO"		,"@!","","€€€€€€€€€€€€€€ ","","CPFSRA"	,0,"þÀ","","","U","S","R","R","" ,"U_VLDCPFSRA(M->ZZM_CPF)","","","","","","",""   ,"","","","","","N","N","",""})
	AAdd(aSX3,{"ZZM","04","ZZM_DOMINI","C", 20,0,"DOMINIO"    ,"DOMINIO"	,"DOMINIO"	,"ID DOMINIO"			,"ID DOMINIO"			,"ID DOMINIO"			,"@!","","€€€€€€€€€€€€€€ ","","ZZL"		,0,"þÀ","","","U","S","R","R","" ,"","","","","","","",""  ,"","","","","","N","N","",""})
	           
	AAdd(aSIX,{"ZZM","1","ZZM_FILIAL+ZZM_ATRIB+ZZM_CPF+ZZM_DOMINI","ATRIBUTO+CPF+DOMINIO","ATRIBUTO+CPF+DOMINIO","ATRIBUTO+CPF+DOMINIO","U","S"})
	
	//	TABELA ZZN == Atributos Comportamentais
	AAdd(aSX2,{'ZZN',;                        	//Alias
	           '',;                           	//Path
	           'Atributos Comportamentais ',; 	//Nome
	           'Atributos Comportamentais ',; 	//Nome esp.
	           'Atributos Comportamentais ',; 	//Nome inglês
	           'C',;                          	//Modo
	           '',;                           	//Único
	           'C',;                          	//Modo unidade.
	           'C'})	                      	//Modo empresa.	
	
	AAdd(aSX3,{"ZZN","01","ZZN_FILIAL","C", 2 ,0,"Filial"     ,"Sucursal"    ,"Branch"      ,"Filial do Sistema"        ,"Sucursal"                 ,"Branch of the System" ,"@!","","€€€€€€€€€€€€€€€",""                             ,"",1,"þÀ","","","U","N","R","R","" ,"",""		,"","","","","","033","","","","","","N","N","",""})
	AAdd(aSX3,{"ZZN","02","ZZN_CODIGO","C", 20,0,"CODIGO"	  ,"CODIGO"		 ,"CODIGO"		,"CODIGO DO ATRIBUTO"		,"CODIGO DO ATRIBUTO"		,"CODIGO DO ATRIBUTO"	,"@!","","€€€€€€€€€€€€€€ ","GETSXENUM('ZZN','ZZN_CODIGO')","",0,"þÀ","","","U","S","R","R","" ,"",""		,"","","","","",""   ,"","","","","","N","N","",""})
	AAdd(aSX3,{"ZZN","03","ZZN_DESCRI","C", 40,0,"DESCRICAO"  ,"DESCRICAO"	 ,"DESCRICAO"	,"DESCRICAO DO ATRIBUTO"	,"DESCRICAO DO ATRIBUTO"	,"DESCRICAO DO ATRIBUTO","@!","","€€€€€€€€€€€€€€ ",""	 				          ,"",0,"þÀ","","","U","S","R","R","" ,"",""		,"","","","","",""   ,"","","","","","N","N","",""})
	AAdd(aSX3,{"ZZN","04","ZZN_DOMINI","C", 20,0,"DOMINIO"    ,"DOMINIO"	 ,"DOMINIO"		,"ID DOMINIO"				,"ID DOMINIO"				,"ID DOMINIO"			,"@!","","€€€€€€€€€€€€€€ ","'RH'"			         	  ,"",0,"þÀ","","","U","S","R","R","" ,"","RH;OPER"	,"","","","","",""   ,"","","","","","N","N","",""})
	
	AAdd(aSIX,{"ZZN","1","ZZN_FILIAL+ZZN_CODIGO","CODIGO","CODIGO","CODIGO","U","S"})
	
	AAdd(aSXB,{"ZZN","1","01","DB","Atributos Comportame"	,"Atributos Comportame"	,"Atributos Comportame"	,"ZZN"				,""})
	AAdd(aSXB,{"ZZN","2","01","01","Codigo"				 	,"Codigo"				,"Codigo"			   	,""					,""})
	AAdd(aSXB,{"ZZN","4","01","01","CODIGO"					,"CODIGO"				,"CODIGO"				,"ZZN_CODIGO"		,""})
	AAdd(aSXB,{"ZZN","4","01","02","DESCRICAO"				,"DESCRICAO"			,"DESCRICAO"			,"ZZN_DESCRI"		,""})
	AAdd(aSXB,{"ZZN","5","01","",""							,""						,""						,"ZZN->ZZN_CODIGO"	,""})
	AAdd(aSXB,{"ZZN","5","02","",""							,""						,""						,"ZZN->ZZN_DESCRI"	,""})
	
	// CAMPOS SRA
	AAdd(aSX3,{"SRA",nil,"RA_XCCORP" ,"N", 20 ,0,"Cod. Corp"   ,"Cod. Corp"   ,"Cod. Corp"   ,"Codigo da Corporacao"     ,"Codigo da Corporacao"      ,"Codigo da Corporacao"     ,"@99999999999999999999","","€€€€€€€€€€€€€€ ",""							 ,"",0,"þÀ","","","U","N","R","R","" ,"","","","","","","","","F","","","","" ,"N","N","",""})
	AAdd(aSX3,{"SRA",nil,"RA_XCGEST" ,"C", 6  ,0,"Cod. Gestor" ,"Cod. Gestor" ,"Cod. Gestor" ,"Codigo do Gestor"		  ,"Codigo do Gestor"          ,"Codigo do Gestor"         ,"@!","","€€€€€€€€€€€€€€ ",""  							 ,"SRA",0,"þÀ","","","U","N","R","R","" ,"","","","","","","","","F","","","" ,"" ,"N","N","",""})
	AAdd(aSX3,{"SRA",nil,"RA_XDGEST" ,"C", 200,0,"Desc. Gestor","Desc. Gestor","Desc. Gestor","Nome do Gestor"			  ,"Nome do Gestor"            ,"Nome do Gestor"         ,"@!","","€€€€€€€€€€€€€€ ","IF(!INCLUI,GetAdvFVal('SRA','RA_NOME', XFILIAL('SRA')+SRA->RA_XCGEST,1, ''),'')",""   ,0,"þÀ","","","U","N","V","V","" ,"","","","","","","GetAdvFVal('SRA','RA_NOME', XFILIAL('SRA')+SRA->RA_XCGEST,1, '')","","F","","","" ,"" ,"N","N","",""})
	AAdd(aSX3,{"SRA",nil,"RA_XCPORT" ,"C", 20 ,0,"Cod Portal " ,"Cod Portal " ,"Cod Portal " ,"Portal pref. colaborador" ,"Portal pref. colaborador"  ,"Portal pref. colaborador" ,"@!","","€€€€€€€€€€€€€€ ",""  							 ,"",0,"þÀ","","","U","N","R","R","" ,"","","","","","","","","F","","","" ,"" ,"N","N","",""})
	
	AAdd(aSXA,{ "SRA", "F", "Performa ASP", "Performa ASP", "Performa ASP", "U" } )
	
	AAdd(aSX7,{"RA_XCGEST","001","GetAdvFVal('SRA','RA_NOME', XFILIAL('SRA')+SRA->RA_XCGEST,1, '')"  ,"RA_XDGEST","P","N","",0,"","","U" } )
	
	// CAMPOS SRJ FUNÇÕES
	AAdd(aSX3,{"SRJ","20","RJ_CODCORP" ,"N", 20 ,0,"Corporacao" ,"Corporacao" ,"Corporacao" ,"codigo Corporacao" ,"codigo Corporacao"  ,"codigo Corporacao" ,"@!","","€€€€€€€€€€€€€€ ","1","",0,"þÀ","","","U","N","A","R","" ,"","","","","","","","","F","","","" ,"" ,"N","N","",""})
	
	// CAMPOS SQ3 CARGOS
	AAdd(aSX3,{"SQ3","26","Q3_CODCORP" ,"N", 20 ,0,"Corporacao" ,"Corporacao" ,"Corporacao" ,"codigo Corporacao" ,"codigo Corporacao"  ,"codigo Corporacao" ,"@!","","€€€€€€€€€€€€€€ ","1","",0,"þÀ","","","U","N","A","R","" ,"","","","","","","","","F","","","" ,"" ,"N","N","",""})
	
	// CAMPOS SQB DEPARTAMENTOS
	AAdd(aSX3,{"SQB","15","QB_CODCORP" ,"N", 20 ,0,"Corporacao" ,"Corporacao" ,"Corporacao" ,"codigo Corporacao" ,"codigo Corporacao"  ,"codigo Corporacao" ,"@!","","€€€€€€€€€€€€€€ ","1","",0,"þÀ","","","U","N","A","R","" ,"","","","","","","","","F","","","" ,"" ,"N","N","",""})
Return