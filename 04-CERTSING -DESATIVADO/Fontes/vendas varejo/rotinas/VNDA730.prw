#Include 'Protheus.ch'
//----------------------------------------------------------------------
// Rotina | VNDA730  | Autor | Rafael Beghini     | Data | 25/05/2016
//----------------------------------------------------------------------
// Descr. | Cria o corpo da mensagem para enviar aos clientes
//----------------------------------------------------------------------
// Uso    | Varejo - Certisign Certificadora Digital
//----------------------------------------------------------------------
User Function VNDA730( cDados, cFileHTM  )
	Local cPath  := ''
	Local cBody  := ''
	Local cFile  := ''
	Local aField := {}
	Local cBarra := Iif( IsSrvUnix(), '/', '\' )
	Local cDir   := cBarra + 'emailvarejo' + cBarra
	Local oHTML
	
	MakeDir( cDir )
	
	aField := StrToKarr( cDados, ';' )
	cFile  := CriaTrab( NIL , .F. ) + '.htm'
	oHTML  := TWFHTML():New( cFileHTM )
	
	If oHTML:ExistField( 1, 'NomeCli')  ; oHTML:ValByName( 'NomeCli', CapitalAce(aField[1]) ) ; Endif
	If oHTML:ExistField( 1, 'cNome'  )  ; oHTML:ValByName( 'cNome'  , aField[1] ) ; Endif
	If oHTML:ExistField( 1, 'cCPF'   )  ; oHTML:ValByName( 'cCPF'   , aField[2] ) ; Endif
	If oHTML:ExistField( 1, 'cSenha' )  ; oHTML:ValByName( 'cSenha' , aField[2] ) ; Endif
	If oHTML:ExistField( 1, 'cTEL'   )  ; oHTML:ValByName( 'cTEL'   , aField[3] ) ; Endif
	If oHTML:ExistField( 1, 'cMAIL'  )  ; oHTML:ValByName( 'cMAIL'  , aField[4] ) ; Endif
	
	cPath := cDir + cFile
	oHTML:SaveFile( cPath )
	
	Sleep(1500)
	// ler o arquivo HTML para formar o corpo do e-mail.
	If File( cPath )
		FT_FUSE( cPath )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
	Endif
	
	Ferase( cPath )
	cBody:= u_CSMODHTM(cbody,cdir) // inclui o email no modelo padrão (cabecalho e rodapé)
Return( cBody )