//-----------------------------------------------------------------------
// Rotina | CSFA340    | Autor | Robson Gonçalves     | Data | 23.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar a relação das entidades parceiras no 
//        | formato de árvore estruturada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'

User Function CSFA340()
	Local aSay := {}
	Local aButton := {}
	
	Local nI := 0
	Local nOpcao := 0
	
	Local aPar := {}
	Local aRet := {}
	
	Local cZ3_TIPENT := ''
	Local aZ3_TIPENT := {}
	
	Private cCadastro := 'Relação das entidades'

	AAdd( aSay, 'Esta rotina tem por objetivo em filtrar a entidade para analisar seu relacionamento.' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		aZ3_TIPENT := StrToKarr( Posicione( 'SX3', 2, 'Z3_TIPENT', 'X3CBox()' ), ';' )	
		AAdd( aPar, { 2, 'Tipo da entidade', 1, aZ3_TIPENT, 60, '', .T. } )
		If ParamBox( aPar, 'Parâmetro de filtro', @aRet, , , , , , , , .F., .F. )
			If ValType( aRet[ 1 ] ) <> 'N'
				For nI := 1 To Len( aZ3_TIPENT )
					If Left( aZ3_TIPENT[ nI ], 1 ) == aRet[ 1 ] 
						cZ3_TIPENT := aRet[ 1 ]
						Exit
					Endif
				Next nI			
			Else
				cZ3_TIPENT := Left( aZ3_TIPENT[ aRet[ 1 ] ], 1 )
			Endif
			A340MBrowse( cZ3_TIPENT )
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A340MBrowse| Autor | Robson Gonçalves     | Data | 23.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina da MBrowse principal.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A340MBrowse( cZ3_TIPENT )
	Local cSQL := ''
	Private aRotina := {}
	
	AAdd( aRotina, { 'Pesquisar' , 'AxPesqui' , 0, 1 } )
	AAdd( aRotina, { 'Visualizar', 'AxVisual' , 0, 2 } )
	AAdd( aRotina, { 'Estrutura' , 'U_A340Struct' , 0, 6 } )
	
	cSQL := "Z3_TIPENT = "+ValToSql( cZ3_TIPENT )+" "
	
	MBrowse(,,,,'SZ3',,,,,,,,,,,,,,cSQL)
Return

//-----------------------------------------------------------------------
// Rotina | A340Struct | Autor | Robson Gonçalves     | Data | 23.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar a interface com a estrutura.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A340Struct( cAlias, nRecNo, nOpcX )
	Local oDlg
	Local oFWLayer
	Local oPanel1, oPanel2
	Local oTree
	Local oPesq
	Local oSair
	Local oBar
	Local oTh1, oTh2
	Local oSplitter 
	Local oPnlTop, oPnlBot
	
	Local aCoors := {}
	Local bSair := {|| .T. }
	
	Private oMsMGet
	Private oGetDados
	
	Private a340Header := {}
	Private a340COLS := {}
	
	If SZ3->Z3_TIPENT $ '1|2|8|9' // Canal, Rede Grupo, Federação e CCR Comissão
		aCoors := FWGetDialogSize( oMainWnd )
		bSair := {|| Iif(MsgYesNo('Deseja realmente sair?',cCadastro),oDlg:End(),NIL)}
	
		SetKey( VK_F12,bSair )
	
		DEFINE MSDIALOG oDlg TITLE '' FROM aCoors[1],aCoors[2] TO aCoors[3],aCoors[4] PIXEL STYLE nOR(WS_VISIBLE, WS_POPUP)		
			oFWLayer := FWLayer():New()
			oFWLayer:Init( oDlg, .F. )
	
			oFWLayer:AddCollumn( 'Col01', 40, .F. )
			oFWLayer:AddWindow( 'Col01', 'Win01', cCadastro, 100, .F., .F., {|| .T. } )
			oPanel1	:= oFWLayer:GetWinPanel( 'Col01', 'Win01' )
	
			oFWLayer:AddCollumn( 'Col02', 60, .F. )
			oFWLayer:AddWindow( 'Col02', 'Win01', 'Entidade Parceiro - Dados do cadastro', 100, .F., .F., {|| .T. } )
			oPanel2	:= oFWLayer:GetWinPanel( 'Col02', 'Win01' )
			
			oSplitter := TSplitter():New( 1, 1, oPanel2, 1000, 1000, 1 )
			oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
			
			oPnlTop:= TPanel():New(1,1," Painel 01",oSplitter,,,,,RGB(255,255,255),1000,1000)  
			oPnlBot:= TPanel():New(1,1," Painel 02",oSplitter,,,,,RGB(255,255,255),1000,1000)
			
			oPnlTop:Align := CONTROL_ALIGN_ALLCLIENT
			oPnlBot:Align := CONTROL_ALIGN_ALLCLIENT
	
			oFWLayer:SetColSplit( 'Col01', CONTROL_ALIGN_RIGHT,, {|| .T. } )
			oFWLayer:SetColSplit( 'Col02', CONTROL_ALIGN_LEFT,,  {|| .T. } )
						
			oBar := TBar():New( oPanel1, 10, 9, .T.,'BOTTOM')
			oThb1 := THButton():New(1,1, 'Pesquisar', oBar,  {|| A340Pesq( @oTree, @oPnlTop, @oPnlBot ) },25,9)
			oThb2 := THButton():New(1,1, 'Sair'     , oBar,  bSair, 25, 9 )

			FWMsgRun(, {|| A340Load( @oPanel1, @oTree, SZ3->Z3_CODENT, SZ3->Z3_DESENT, SZ3->Z3_TIPENT, @oPnlTop, @oPnlBot ) },,'Aguarde, montando as estruturas...')
			
			A340Visual( SZ3->Z3_CODENT, oPnlTop, oPnlBot )
		ACTIVATE MSDIALOG oDlg
		SetKey( VK_F12, NIL )
	Else
		MsgAlert('Rotina não preparada para atender a relação deste tipo de entidade selecionado.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A340Load   | Autor | Robson Gonçalves     | Data | 23.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para montar a estrutura das entidades conforme o seu
//        | relacionamento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A340Load( oPanel1, oTree, cZ3_CODENT, cZE_DESENT, cZ3_TIPENT, oPnlTop, oPnlBot )	
	Local cTRBb := ''
	
	a340Header := APBuildHeader( 'SZ4' )
	
	oTree := XTree():New( 0, 0, 0, 0, oPanel1, {|| A340Visual( oTree:GetCargo(), @oPnlTop, @oPnlBot ) } )
	oTree:Align := CONTROL_ALIGN_ALLCLIENT
	
	// Entidade Canal.
	If cZ3_TIPENT == '1'
		A340AddTree( @oTree, cZ3_CODENT, cZE_DESENT )
		A340GrpRede( @oTree, cZ3_CODENT )
	
	// Entidades Rede Grupo, Federação e CCR Comissão.
	Elseif cZ3_TIPENT $ '2|8|9'
		A340AddTree( @oTree, cZ3_CODENT, cZE_DESENT )
   	cTRBb := GetNextAlias()
		A340Posto( @oTree, SZ3->Z3_CODENT, cTRBb )
	Endif
	oTree:EndTree()
Return

//-----------------------------------------------------------------------
// Rotina | A340AddTree| Autor | Robson Gonçalves     | Data | 23.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para adicionar a estrutura pai.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A340AddTree( oTree, cZ3_CODENT, cZ3_DESENT )
	oTree:AddTree( cZ3_CODENT + ' - ' + RTrim(cZ3_DESENT), 'FOLDER5.PNG', 'FOLDER6.PNG', cZ3_CODENT, {|| .T.}, {|| .T.}, {|| .T.} )
Return

//-----------------------------------------------------------------------
// Rotina | A340ATItem | Autor | Robson Gonçalves     | Data | 23.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para adicionar a estrutura filho.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A340ATItem( oTree, cZ3_CODENT, cZ3_DESENT )
	oTree:AddTreeItem( cZ3_CODENT+' - '+RTrim(cZ3_DESENT), 'NEXT_PQ.PNG', cZ3_CODENT, {|| .T.}, {|| .T.}, {|| .T.} )
Return

//-----------------------------------------------------------------------
// Rotina | A340Pesq   | Autor | Robson Gonçalves     | Data | 23.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para pesquisar na estrutura. Somente o código.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A340Pesq( oTree, oPnlTop, oPnlBot )
	Local aPar := {}
	Local aRet := {}
	
	AAdd( aPar,{ 1, 'Código da entidade',Space(6),'@!','','','',0,.T.})
	
	While .T.
		If ParamBox( aPar, 'Pesquisar', @aRet,,,,,,,,.F.)
			If .NOT. oTree:TreeSeek( aRet[ 1 ] )
				MsgAlert( 'Informação não localizada', cCadastro )
			Else
				A340Visual( oTree:GetCargo(), @oPnlTop, @oPnlBot )
			Endif
	   Else
	   	Exit
	   Endif
   End
Return

//-----------------------------------------------------------------------
// Rotina | A340Visual | Autor | Robson Gonçalves     | Data | 23.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar a relação da SZ3 e SZ4 conforme o que
//        | for selecionado na estrutura.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A340Visual( cCargo, oPnlTop, oPnlBot )	
	Local nJ := 0
	Local nElem := 0
	
	Local lMV_ENCHOLD := .F.
	
	INCLUI := .F.
	ALTERA := .F.
	
	lMV_ENCHOLD := GetMv('MV_ENCHOLD') == '2'
	
	SZ3->( dbSetOrder( 1 ) )
	SZ3->( dbSeek( xFilial( 'SZ3' ) + cCargo ) )
	RegToMemory( 'SZ3', .F. )
	
	a340COLS := {}
	
	// Buscar os dados na tabela de regras.
	SZ4->( dbSetOrder( 1 ) )
	If SZ4->( dbSeek( xFilial( 'SZ4' ) + cCargo ) )
	   While .NOT. SZ4->( EOF() ) .And. SZ4->Z4_FILIAL == xFilial( 'SZ4' ) .And. SZ4->Z4_CODENT == cCargo
	  		AAdd( a340COLS, Array( Len( a340Header ) + 1 ) )
	  		nElem := Len( a340COLS )
	  		For nJ := 1 To Len( a340Header )
	  			If a340Header[ nJ, 10 ] <> 'V'
	  				a340COLS[ nElem, nJ ] := SZ4->( FieldGet( FieldPos( a340Header[ nJ, 2 ] ) ) )
	  			Else
	  				a340COLS[ nElem, nJ ] := CriaVar( a340Header[ nJ, 2 ] )
	  			Endif
	   	Next nJ
	   	a340COLS[ nElem, Len( a340COLS[ nElem ] ) ] := .F. 
	   	SZ4->( dbSkip() )
	   End
   Else
   	// Caso não haja apenas montar o vetor vazio.
  		AAdd( a340COLS, Array( Len( a340Header ) + 1 ) )
  		nElem := Len( a340COLS )
  		For nJ := 1 To Len( a340Header )
			a340COLS[ nElem, nJ ] := CriaVar( a340Header[ nJ, 2 ] )
   	Next nJ
	   	a340COLS[ nElem, Len( a340COLS[ nElem ] ) ] := .F. 
   Endif
   	
	// Parâmetro de controle de apresentação dos campos na MsMGet 1=P10, 2=P11
	If lMV_ENCHOLD
		PutMv('MV_ENCHOLD','1')
	Endif
	
	// Havendo o objeto apenas refresque-o.
	If ValType( oMsMGet ) == 'O'
		oMsMGet:Refresh()
	Else
	// Estanciar o objeto.
		oMsMGet := MsMGet():New( 'SZ3', SZ3->(RecNo()), 2,,,,, { 1, 1, 1000, 1000} ,, 3,,,, oPnlTop )
		oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
	Endif
	
	// Havendo o objeto apenas refresque-o.
	If ValType( oGetDados ) == 'O'
		oGetDados:SetArray( a340COLS )
		oGetDados:oBrowse:Refresh()
	Else
	// Estanciar o objeto.
		oGetDados := MsNewGetDados():New( 0, 0, 1000, 1000,,,,,,, Len( a340COLS ),,,, oPnlBot, a340Header, a340COLS )
		oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	Endif

	// Parâmetro de controle de apresentação dos campos na MsMGet 1=P10, 2=P11
	If lMV_ENCHOLD
		PutMv('MV_ENCHOLD','2')
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A340GrpRede| Autor | Robson Gonçalves     | Data | 23.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para buscar os registros da entidade Grupo Rede.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A340GrpRede( oTree, cZ3_CODENT )
	Local cSQL := ''
	Local cTRBa := ''
	Local cTRBb := ''
	
   cTRBa := GetNextAlias()
   cTRBb := 'B'+cTRBa

	cSQL := "SELECT   Z3_CODENT, "
	cSQL += "         Z3_DESENT, "
	cSQL += "         Z3_CODAC "
	cSQL += "FROM     "+RetSqlName("SZ3")+" SZ3 "
	cSQL += "WHERE    SZ3.D_E_L_E_T_ = ' ' "
	cSQL += "         AND Z3_FILIAL = "+ValToSql( xFilial( "SZ3" ) )+ " "
	cSQL += "         AND Z3_TIPENT = '2' "
	cSQL += "         AND Z3_CODCAN = "+ValToSql( cZ3_CODENT )+" "
	cSQL += "ORDER BY Z3_CODENT "

	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRBa )

	If .NOT. (cTRBa)->( BOF() ) .And. .NOT. (cTRBa)->( EOF() )
		While .NOT. (cTRBa)->( EOF() )
			A340AddTree( @oTree, (cTRBa)->Z3_CODENT, (cTRBa)->Z3_DESENT )
			A340Posto( @oTree, (cTRBa)->(Z3_CODENT), cTRBb )
			oTree:EndTree()
			(cTRBa)->(dbSkip())
		End
	Else
		MsgInfo( 'Não há dados para apresentar.', cCadastro )
		(cTRBa)->( dbCloseArea() )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A340Posto  | Autor | Robson Gonçalves     | Data | 23.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para buscar os registros de postos.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A340Posto( oTree, cZ3_CODENT, cTRBb )
	Local cSQL := ''
	
	cSQL := "SELECT   Z3_CODENT, "
	cSQL += "         Z3_DESENT "
	cSQL += "FROM     "+RetSqlName("SZ3")+" SZ3 "
	cSQL += "WHERE    SZ3.D_E_L_E_T_ = ' ' "
	cSQL += "         AND Z3_FILIAL = "+ValToSql( xFilial( "SZ3" ) )+" "
	cSQL += "         AND Z3_TIPENT = '4' "
	cSQL += "         AND Z3_CODAC = "+ValToSql(cZ3_CODENT)+" "
	cSQL += "ORDER BY Z3_CODENT "
	
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRBb )

	If .NOT. (cTRBb)->( BOF() ) .And. .NOT. (cTRBb)->( EOF() )
		While .NOT. (cTRBb)->( EOF() ) 
			A340ATItem( @oTree, (cTRBb)->Z3_CODENT, (cTRBb)->Z3_DESENT )
			(cTRBb)->( dbSkip() )
		End
	Endif
	(cTRBb)->( dbCloseArea() )
Return