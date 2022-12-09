//--------------------------------------------------------------------------------
// Rotina | CSFA602      | Autor | Robson Gonçalves              | Data | 29.05.15
//--------------------------------------------------------------------------------
// Descr. | Rotina que higieniza os registros da tabela.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
#Include 'Protheus.ch'
User Function CSFA602()
	Local nOpc := 0
	Local aSay := {}
	Local aButton := {}
	Local aSX2 := {}
	Private oMrk   := LoadBitmap(,'NGCHECKOK.PNG')
	Private oNoMrk := LoadBitmap(,'NGCHECKNO.PNG')
	Private cCadastro := 'Higienização de dados'
	AAdd( aSay, 'O objetivo desta rotina é retirar caracteres dos registros da tabela de dados selecionada.' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch() }} )
	AAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
	FormBatch( cCadastro, aSay, aButton )
	If nOpc == 1
		Processa( {|| A602Sx2( @aSX2 ) }, cCadastro, 'Buscando as tabelas (SX2)...' )
		A602ShowTab( aSX2 )
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A602Sx2      | Autor | Robson Gonçalves              | Data | 29.05.15
//--------------------------------------------------------------------------------
// Descr. | Rotina que busca os prefixos e nomes das tabelas.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A602Sx2( aSX2 )
	SX2->( dbSetOrder( 1 ) )
	SX2->( dbGoTop() )
	ProcRegua(0)
	While SX2->( .NOT. EOF() )
		IncProc()
		AAdd( aSX2, { .F., SX2->X2_CHAVE, SX2->X2_NOME } )
		SX2->( dbSkip() )
	End
Return

//--------------------------------------------------------------------------------
// Rotina | A602ShowTab  | Autor | Robson Gonçalves              | Data | 29.05.15
//--------------------------------------------------------------------------------
// Descr. | Rotina que apresenta as tabelas para usuário selecionar.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A602ShowTab( aSX2 )
	Local oLbx 
	Local oDlg 
	Local oPanel
	Local oOrdem
	Local oSeek
	Local oPesq
	Local nOpc := 0
	Local nPos := 0
	Local cOrd := ''
	Local nOrd := 1
	Local cSeek := Space( 3 )
	Local aOrdem := {'Prefixo'}
	DEFINE MSDIALOG oDlg TITLE 'Selecione a tabela de dados' FROM 0,0 TO 250,600 PIXEL
		oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanel:Align := CONTROL_ALIGN_TOP
	   @ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanel
		@ 1,082 MSGET    oSeek  VAR cSeek PICTURE '@!' SIZE 160,9 PIXEL OF oPanel
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanel ACTION (A602Pesq(nOrd,cSeek,@oLbx))
	   oLbx := TwBrowse():New(0,0,0,0,,{'   X','Prefixo','Nome da tabela'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx:SetArray( aSX2 )
		oLbx:bLine := {|| { Iif( aSX2[ oLbx:nAt, 1 ], oMrk, oNoMrk ), aSX2[ oLbx:nAt, 2 ], aSX2[ oLbx:nAt, 3 ] } }
		oLbx:bLDblClick := {|| A602Mark( @oLbx ) }
		oSeek:SetFocus()
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {|| A602Tabela( @oLbx ),cSeek:='   ',oSeek:Refresh() }, {|| Iif(MsgYesNo('Deseja realmente sair da rotina?'),(oDlg:End()),NIL) } )
Return

//--------------------------------------------------------------------------------
// Rotina | A602Mark     | Autor | Robson Gonçalves              | Data | 29.05.15
//--------------------------------------------------------------------------------
// Descr. | Rotina que controle o mark para tabela selecionada.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A602Mark( oLbx )
	Local nPos := 0
	nPos := AScan( oLbx:aArray, {|p| p[ 1 ] == .T. } )
	If nPos > 0
		oLbx:aArray[ nPos, 1 ] := .F.
	Endif
	oLbx:aArray[ oLbx:nAt, 1 ] := .T.
	oLbx:Refresh()
Return

//--------------------------------------------------------------------------------
// Rotina | A602Pesq     | Autor | Robson Gonçalves              | Data | 29.05.15
//--------------------------------------------------------------------------------
// Descr. | Rotina de pesquisa.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A602Pesq( nOrd, cSeek, oLbx )
	Local bAScan := {|| .T. }
	Local nBegin := 0
	Local nColPesq := 0
	Local nEnd := 0
	Local nP := 0
	nColPesq := Iif( nOrd == 1, 2, Iif( nOrd == 2, 3, Iif( nOrd == 3, 4 , MsgAlert('Opção não disponível para pesquisar.','Pesquisar') ) ) )
	If nColPesq > 0
		nBegin := Min( oLbx:nAt + 1, Len( oLbx:aArray ) )
		nEnd   := Len( oLbx:aArray )
		If oLbx:nAt == Len( oLbx:aArray )
			nBegin := 1
		Endif
		bAScan := {|p| AllTrim( cSeek ) $ AllTrim( p[ nColPesq ] ) } 
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
			oLbx:SetFocus()
		Else
			nBegin := 1
			bAScan := {|p| AllTrim( cSeek ) $ AllTrim( p[ nColPesq ] ) } 
			nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
			If nP > 0
				oLbx:nAt := nP
				oLbx:Refresh()
				oLbx:SetFocus()
			Else
				MsgInfo('Informação não localizada.','Pesquisar')
			Endif
		Endif
	Endif	
Return

//--------------------------------------------------------------------------------
// Rotina | A602Tabela   | Autor | Robson Gonçalves              | Data | 29.05.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para preparar busca dos campos conforme a tabela.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A602Tabela( oLbx )
	Local nPos := 0
	Local aSX3 := {}
	nPos := AScan( oLbx:aArray,{|p| p[ 1 ] == .T. } )
	If nPos > 0
		Processa( {|| A602Campos( oLbx:aArray[ nPos, 2 ], @aSX3 ) }, cCadastro, 'Buscando os campos da tabela '+oLbx:aArray[ nPos, 3] )
		A602ShowCpo( oLbx:aArray[ nPos, 2 ], aSX3 )
		oLbx:aArray[ nPos, 1 ] := .F.
		oLbx:Refresh()
	Else
		MsgAlert('Necessário informar qual tabela de dados quer processar.')
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A602Campos   | Autor | Robson Gonçalves              | Data | 29.05.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para buscar os campos.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A602Campos( cTabela, aSX3 )
	SX3->( dbSetOrder( 1 ) )
	SX3->( dbSeek( cTabela ) )
	ProcRegua(0)
	While SX3->( .NOT. EOF() ) .AND. SX3->X3_ARQUIVO == cTabela
		IncProc()
		If X3Uso(SX3->X3_USADO) .AND. SX3->X3_TIPO == 'C' .AND. SX3->X3_VISUAL <> 'V'
			SX3->( AAdd( aSX3, { .F., X3_TITULO, X3_DESCRIC, X3_CAMPO, X3_TIPO, X3_CONTEXT, ' ' } ) )
		Endif
		SX3->( dbSkip() )
	End
	ASort( aSX3,,,{|a,b| a[2] < b[2] } )
Return

//--------------------------------------------------------------------------------
// Rotina | A602ShowCpo  | Autor | Robson Gonçalves              | Data | 29.05.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para apresentar os campos a ser selecionado pelo usuário.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A602ShowCpo( cTabela, aSX3 )
	Local oLbx 
	Local oDlg 
	Local oPanel
	Local oOrdem
	Local oSeek
	Local oPesq
	Local cOrd := ''
	Local cSeek := Space(30)
	Local nOrd := 1
	Local nOpc := 0
	Local lMark := .T.
	Local aOrdem := {'Título','Descrição','Campo'}

	Private aCampo := {}

	DEFINE MSDIALOG oDlg TITLE 'Selecione os campos' FROM 0,0 TO 400,700 PIXEL
		oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanel:Align := CONTROL_ALIGN_TOP
	   @ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE ;
	   ( nOrd := oOrdem:nAt, ASort( oLbx:aArray,,,{|a,b| a[ nOrd+1 ] < b[ nOrd+1 ] } ), oLbx:nAt := 1, oLbx:Refresh() ) PIXEL OF oPanel
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanel
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanel ACTION (A602Pesq(nOrd,cSeek,@oLbx))
	   oLbx := TwBrowse():New(0,0,0,0,,{'X','Título','Descrição', 'Campo', 'Tipo', 'Contexto', ' '},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx:SetArray( aSX3 )
		oLbx:bLine := {|| {Iif(aSX3[oLbx:nAt,1],oMrk,oNoMrk),aSX3[oLbx:nAt,2],aSX3[oLbx:nAt,3],aSX3[oLbx:nAt,4],aSX3[oLbx:nAt,5],aSX3[oLbx:nAt,6],aSX3[oLbx:nAt,7]}}
		//oLbx:bLDblClick := {||  aSX3[ oLbx:nAt, 1 ] := .NOT. aSX3[ oLbx:nAt, 1 ] }
		oLbx:bLDblClick := {||  MyMark( @oLbx, aCampo ) }
		oLbx:bHeaderClick := {|| AEval( aSX3, {|p| p[1] := lMark } ), lMark := .NOT. lMark, oLbx:Refresh() }
		oSeek:SetFocus()
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {|| A602Proc( cTabela, oLbx ), oDlg:End() }, {|| oDlg:End() } )
Return

//--------------------------------------------------------------------------------
// Rotina | A602Proc     | Autor | Robson Gonçalves              | Data | 29.05.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para solicitar o caractere a ser buscado nos registros.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A602Proc( cTabela, oLbx )
	Local aPar := {}
	Local aRet := {}
	AAdd( aPar,{ 1, 'Localizar caractere', Space(1), '', '', '', '', 0, .T. } )
	//AAdd( aPar,{ 2, 'Retirar espaço'	 , 2, {'Sim','Não'},50,"",.F.})
	If ParamBox( aPar, 'Substituir', @aRet, , , , , , , ,.F. ,.F. )
		Processa( {|| A602Subs( cTabela, oLbx, aRet[ 1 ] ) }, cCadastro, 'Substituíndo caractere, aguarde...' )
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A602Subs     | Autor | Robson Gonçalves              | Data | 29.05.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para processar os registro substituindo por nada quando 
//        | encontrar o caractere.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A602Subs( cTabela, oLbx, cChar, xlTrim )
	Local nI 		:= 0
	Local cField	:= ''
	Local cCpo 		:= ''
	Local cSQL 		:= ''
	//Local lDoTrim := ValType( xlTrim ) == 'C' //Escolheu SIM
	
	cSQL := "SELECT R_E_C_N_O_ FROM " + RETSQLNAME(cTabela) + " WHERE D_E_L_E_T_ = ' '"
	
	ProcRegua(0)
	/*For nI := 1 To Len( oLbx:aArray )
		IncProc()
		If oLbx:aArray[ nI, 1 ]
			cCpo += " ("+RTrim( oLbx:aArray[ nI, 4 ] )+" LIKE '%"+cChar+"%' "

			IF oLbx:aArray[ nI, 5 ] == 'C' .And. lDoTrim
				cCpo += " OR Substr("+RTrim( oLbx:aArray[ nI, 4 ] )+",1,1) = ' ' ) AND "
			Else
				cCpo += " ) AND "
			EndIF

		Endif
	Next nI
	cCpo := SubStr( cCpo, 1, Len( cCpo )-4 )
	cSQL := cSQL + cCpo 
	*/
	cSQL := ChangeQuery( cSQL )
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cSQL),"HIGIENE",.F.,.T.)
	
	While HIGIENE->( .NOT. EOF() )
		IncProc()
		(cTabela)->( dbGoTo( HIGIENE->R_E_C_N_O_ ) )
		(cTabela)->( RecLock( cTabela, .F. ) )
		/*For nI := 1 To Len( oLbx:aArray )
			IF oLbx:aArray[ nI, 1 ]
				cField := cTabela + '->' + oLbx:aArray[ nI, 4 ]
				&(cField) := AllTrim( StrTran( &(cField), cChar, ' ' ) )
			EndIF
		Next nI
		*/
		For nI := 1 To Len( aCampo )
			cField := cTabela + '->' + aCampo[ nI ]
			&(cField) := StrTran( &(cField), cChar, ' ' ) 
			&(cField) := AllTrim( &(cField) )
		Next nI
		(cTabela)->( MsUnLock() )
		HIGIENE->( dbSkip() )
	End
	HIGIENE->( dbCloseArea() )
	
	MsgAlert('Rotina realizada com sucesso.')	
	/*
	(cTabela)->( dbSetOrder( 1 ) )
	(cTabela)->( dbGoTop() )
	While (cTabela)->( .NOT. EOF() )
		IncProc()
		For nI := 1 To Len( aCpos )
			If (cTabela)->( FieldPos( aCpos[ nI ] ) ) > 0
				cField := cTabela + '->' + aCpos[ nI ]
				While ( At( cChar, &(cField) ) > 0 )
					(cTabela)->( RecLock( cTabela, .F. ) )
					&(cField) := StrTran( &(cField), cChar, ' ' )
					(cTabela)->( MsUnLock() )
				End
			Endif
		Next nI
		(cTabela)->( dbSkip() )
	End
	MsgAlert('Rotina realizada com sucesso.')
	*/
Return

Static Function MyMark( oLbx, aCampo )
	Local nP := 0
	
	If .NOT. oLbx:aArray[ oLbx:nAt, 1 ]
		oLbx:aArray[ oLbx:nAt, 1 ] := .NOT. oLbx:aArray[ oLbx:nAt, 1 ]
		AAdd( aCampo, rTrim( oLbx:aArray[ oLbx:nAt, 4 ] ) )
	Else
		oLbx:aArray[ oLbx:nAt, 1 ] := .NOT. oLbx:aArray[ oLbx:nAt, 1 ]
		nP := AScan( aCampo, {|e| e == oLbx:aArray[ oLbx:nAt, 4 ] } )
		If nP > 0
			ADel( aCampo, nP )
			ASize( aCampo, Len( aCampo )-1 )
		Endif
	Endif
Return