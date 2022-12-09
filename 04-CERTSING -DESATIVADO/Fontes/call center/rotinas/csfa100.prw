//-----------------------------------------------------------------------
// Rotina | CSFA100      | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina de transferência de lista de contatos em lote.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
#Include 'Protheus.ch'

Static __nExec := 0

User Function CSFA100()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private cCadastro := 'Transferência de Agenda em Lote'
	
	AAdd( aSay, 'Este programa permite que seja transferida as agendas entre OS operadores. Somente o' )
	AAdd( aSay, 'supervisor poderá executar esta rotina.' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1 
		If A100Super()
			A100Proc()
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A100Super    | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para criticar caso o usuário não seja supervisor.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100Super()
	Local lRet := .F.
	SU7->( dbSetOrder( 4 ) )
	If SU7->( dbSeek( xFilial( 'SU7' ) + __cUserID ) )
		If SU7->U7_TIPO == '2'
			lRet := .T.
		Else
			MsgInfo( 'Usuário não é supervisor, por favor, verifique.', cCadastro )
		Endif
	Else
		MsgInfo( 'Usuário não está cadastro como operador, por favor, verifique.', cCadastro )
	Endif	
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A100Proc     | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para dar início no processamento dos dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100Proc()
	Local aPar := {}
	Local aRet := {}

	Local bValid := {|| NIL }
	Local cMV_ENTIVLD := 'MV_ENTIVLD'
	
	Private aHeader := {}
	Private aCOLS := {}

	If ! ExisteSX6( cMV_ENTIVLD )
		CriarSX6( cMV_ENTIVLD, 'C', 'Entidades possíveis para transferência de lista de contato na rotina CSFA100.', 'SZT|SZX|PAB' )
	Endif
	
	cMV_ENTIVLD := GetMv( cMV_ENTIVLD )
	
	bValid := {|| Iif(mv_par02$cMV_ENTIVLD,.T.,;
	(MsgInfo('Somente as entidades de Renovação SSL(SZT), ICP-Brasil(SZX) e Lista de Contatos(PAB) estão válidas para uso nesta rotina.',cCadastro ), .F. ) ) }
	
	AAdd( aPar,{ 1, 'Informe o operador', Space(6), '@!', ''                    , 'SU7', '', 50, .T. } )
	AAdd( aPar,{ 1, 'Qual entidade'     , Space(3), '@!', ''                    ,  'T5', '', 40, .T. } )
	
	If ParamBox( aPar, 'Parâmetros', @aRet, bValid,,,,,,, .F., .F. )
		Processa( {|lEnd| Iif( A100Load( aRet ), A100Show( aRet ), NIL ) }, cCadastro, 'Processando, aguarde...', .F. )
	Endif	
Return

//-----------------------------------------------------------------------
// Rotina | A100Load     | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para carregar os dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100Load( aRet )
	Local lRet := .T.
	Local cSQL := ''
	Local cTRB := ''
	
	Local cEntidade := aRet[2]
	
	Local nCount := 0
	Local cCount := ''
	
	Local nI := 0
	Local nElem := 0
	Local nPos := 0
	
	Local aCPO := {}
	Local aEntidade := {}
	
	Local cFil := ''
	Local cChave := ''
	Local cCpo := ''
	
	/* 
	--------------------------------------------------------------
	POSSÍVEIS ENTIDADES, OU SEJA, O QUE ESTÁ CADASTRADO NO SX5-T5.
	--------------------------------------------------------------
	PREFIXO - DESCRIÇÃO            - CAMPO DE RETORNO
	--------------------------------------------------------------
	ACH     - Suspect              - ACH_RAZAO
	SA1     - Cliente              - A1_NOME
	SU5     - Contato              - U5_CONTAT
	SUS     - Prospect             - US_NOME
	SZ3     - Posto de atendimento - Z3_DESENT
	SZT     - Common Name          - ZT_EMPRESA
	SZX     - ICP-Brasil	          - ZX_DSRAZAO
	PAB     - Listas de contatos   - PAB_NOME
	--------------------------------------------------------------
   */
	AAdd( aEntidade, { 'ACH', 'ACH_FILIAL', 'ACH_CODIGO ||ACH_LOJA' ,'ACH_RAZAO' })
	AAdd( aEntidade, { 'SA1', 'A1_FILIAL' , 'A1_COD || A1_LOJA',     'A1_NOME'   })
	AAdd( aEntidade, { 'SU5', 'U5_FILIAL' , 'U5_CODCONT',            'U5_CONTAT' })
	AAdd( aEntidade, { 'SUS', 'US_FILIAL' , 'US_COD || US_LOJA',     'US_NOME'   })
	AAdd( aEntidade, { 'SZ3', 'Z3_FILIAL' , 'Z3_CODENT',             'Z3_DESENT' })
	AAdd( aEntidade, { 'SZT', 'ZT_FILIAL' , 'ZT_CODIGO',             'ZT_EMPRESA'})
	AAdd( aEntidade, { 'SZX', 'ZX_FILIAL' , 'ZX_CODIGO',             'ZX_DSRAZAO'})
	AAdd( aEntidade, { 'PAB', 'PAB_FILIAL', 'PAB_CODIGO',            'PAB_NOME'  })
	
	nPos := AScan( aEntidade, {|p| p[ 1 ] == cEntidade } )
	
	If nPos > 0
		cFil   := aEntidade[ nPos, 2 ]
		cChave := aEntidade[ nPos, 3 ]
		cCpo   := aEntidade[ nPos, 4 ]
	
		AAdd( aCPO, { 'MARK',       '   x'               } )
		AAdd( aCPO, { 'ATEND',      'Atend.'             } )
		AAdd( aCPO, { 'AGENDA',     'Agenda'             } )
		AAdd( aCPO, { 'U6_CODENT',  'Cód.Cliente'        } )
		AAdd( aCPO, { cCpo       ,  'Nome do cliente'    } )
		AAdd( aCPO, { 'U5_CODCONT', 'Cód.Contato'        } )
		AAdd( aCPO, { 'U5_CONTAT',  'Nome do contato'    } )
		AAdd( aCPO, { 'U4_LISTA',   'Código da lista'    } )
		AAdd( aCPO, { 'U6_CODIGO',  'Sequencia da lista' } )
		AAdd( aCPO, { 'U4_DESC',    'Descrição da lista' } )
		AAdd( aCPO, { 'U4_DATA',    'DT.agenda lista'    } )
		AAdd( aCPO, { 'U6_DATA',    'DT.agenda atend.'   } )
		AAdd( aCPO, { 'U6_ENTIDA',  'Sigla da entidade'  } )
		AAdd( aCPO, { 'X5_DESCRI',  'Nome da entidade'   } )
		AAdd( aCPO, { 'U5_FILHOS',  'Qtde. de lista.'    } )
	
		cSQL := "SELECT U4_LISTA, "
		cSQL += "       (SELECT COUNT(*) "
		cSQL += "        FROM   "+RetSqlName("SU6")+" SU6 "
		cSQL += "        WHERE  U6_FILIAL = "+ValToSql( xFilial( "SU6" ) ) +" "
		cSQL += "           AND SU6.D_E_L_E_T_ = ' ' "
		cSQL += "           AND U6_LISTA = U4_LISTA "
		cSQL += "         GROUP BY U6_LISTA ) AS U5_FILHOS, "
		cSQL += "       U4_DESC, "
		cSQL += "       U4_DATA, "
		cSQL += "       U4_OPERAD, "
		cSQL += "       U4_STATUS, "
		cSQL += "       U6_CODIGO, "
		cSQL += "       U6_CONTATO, "
		cSQL += "       U6_ENTIDA, "
		cSQL += "       U6_CODENT, "
		cSQL += "       U6_STATUS, "
		cSQL += "       U6_DATA, "
		cSQL += "      " + cCpo + ", " // Depende da entidade selecionada.
		cSQL += "       U5_CODCONT, "
		
		If cCpo <> "U5_CONTAT"
			cSQL += "       U5_CONTAT, "
		Endif
		
		cSQL += "       X5_DESCRI "
		cSQL += "FROM   "+RetSqlName("SU4")+" SU4 "
		cSQL += "       INNER JOIN "+RetSqlName("SU6")+" SU6 "
		cSQL += "               ON U6_FILIAL = " + ValToSql( xFilial( "SU6" ) ) + " "
		cSQL += "                  AND U6_LISTA = U4_LISTA "
		cSQL += "                  AND U6_ENTIDA = "+ValToSql( cEntidade )+" " // Depende da entidade selecionada.
		cSQL += "                  AND U6_ORIGEM = '1' "
		cSQL += "                  AND U6_STATUS = '1' "
		cSQL += "                  AND SU6.D_E_L_E_T_ = ' ' "
		
		If cCpo <> "U5_CONTAT"
			cSQL += "       INNER JOIN "+RetSqlName( cEntidade )+" "+cEntidade+" "               // Depende da entidade selecionada.
			cSQL += "               ON " + cFil + " = " + ValToSql( xFilial( cEntidade ) ) + " " // Depende da entidade selecionada.
			cSQL += "                  AND RTRIM(U6_CODENT) = " + cChave + " "                   // Depende da entidade selecionada.
			cSQL += "                  AND "+cEntidade+".D_E_L_E_T_ = ' ' "                      // Depende da entidade selecionada.
		Endif
		
		cSQL += "       INNER JOIN "+RetSqlName("SX5")+" SX5 "
		cSQL += "               ON X5_FILIAL = " + ValToSql( xFilial( "SX5" ) ) +" "
		cSQL += "              AND X5_TABELA = 'T5' "
		cSQL += "              AND X5_CHAVE = " + ValToSql( cEntidade ) + " "
		cSQL += "              AND SX5.D_E_L_E_T_ = ' ' "
		cSQL += "       INNER JOIN "+RetSqlName("AC8")+" AC8 "
		cSQL += "               ON AC8_FILIAL = " + ValToSql( xFilial( "AC8" ) ) + " "
		cSQL += "                  AND AC8_ENTIDA = "+ValToSql( cEntidade )+" "
		cSQL += "                  AND AC8_CODENT = U6_CODENT "
		cSQL += "                  AND AC8.D_E_L_E_T_ = ' ' "
		cSQL += "       INNER JOIN "+RetSqlName("SU5")+" SU5 "
		cSQL += "               ON U5_FILIAL = " + ValToSql( xFilial( "SU5" ) ) + " "
		cSQL += "                  AND U5_CODCONT = AC8.AC8_CODCON "
		cSQL += "                  AND SU5.D_E_L_E_T_ = ' ' "
		cSQL += "WHERE  U4_FILIAL = " + ValToSql( xFilial( "SU4" ) ) + " "
		cSQL += "       AND U4_OPERAD  = " + ValToSql( aRet[1] ) + " "
		cSQL += "       AND U4_STATUS = '1' "
		cSQL += "       AND U4_TIPO = '1' " // Somente Markting.
		cSQL += "       AND U4_TELE = '1' " // Somente Telemarketing.
		cSQL += "       AND SU4.D_E_L_E_T_ = ' ' 	"
		cSQL += "ORDER  BY U4_LISTA, "
		cSQL += "          U6_CODIGO "
	
		cCount := ' SELECT COUNT(*) COUNT FROM ( ' + cSQL + ' ) QUERY '
		If At('ORDER  BY', Upper(cCount)) > 0
			cCount := SubStr(cCount,1,At('ORDER  BY',cCount)-1) + SubStr(cCount,RAt(')',cCount))
		Endif	
		DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cCount),'SQLCOUNT',.F.,.T.)
		nCount := SQLCOUNT->COUNT
		SQLCOUNT->(DbCloseArea())
	
		If nCount > 0
			SX3->( dbSetOrder( 2 ) )
			For nI := 1 To Len( aCPO )
				SX3->( dbSeek( aCPO[ nI, 1 ] ) )
				If aCPO[ nI, 1 ] $ 'MARK|ATEND|AGENDA'
					AAdd( aHeader, { aCPO[ nI, 2 ], aCPO[ nI, 1] , '@BMP', 10, 0, '', '', '', '', '' } ) //'CHECKBOL'
				Else
					SX3->( AAdd( aHeader,{ aCPO[ nI, 2 ], RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL,'AllWaysTrue', X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } ) )
				Endif
			Next nI
			
			cTRB := GetNextAlias()
			
			//-----------------------------------
			// Executar a query no banco de dados
			//-----------------------------------
			MsgRun('Filtrando dados...', cCadastro, {|| PLSQuery( cSQL, cTRB ) } )
			
			ProcRegua(nCount)
			
			While ! (cTRB)->( EOF() )
			   AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
			   nElem := Len( aCOLS )
			   
				For nI := 1 To Len( aHeader )
					If aHeader[ nI, 2 ] == 'MARK'
						aCOLS[ nElem, nI ] := 'LBNO'
					Elseif aHeader[ nI, 2 ] == 'ATEND'
						aCOLS[ nElem, nI ] := Iif((cTRB)->U4_STATUS=='1','BR_VERMELHO','BR_AZUL')
					Elseif aHeader[ nI, 2 ] == 'AGENDA'
						aCOLS[ nElem, nI ] := Iif((cTRB)->U6_STATUS=='1','BR_VERMELHO',Iif((cTRB)->U6_STATUS=='2','BR_VERDE','BR_AZUL'))
					Else
						If ValType( (cTRB)->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) ) ) == 'C'
							aCOLS[ nElem, nI ] := RTrim( (cTRB)->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) ) )
						Else
							aCOLS[ nElem, nI ] := (cTRB)->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) )
						Endif
					Endif
				Next nI
				aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.
				
				IncProc()
				(cTRB)->( dbSkip() )
			End
			
			(cTRB)->( dbCloseArea() )
		Else
			lRet := .F.
			MsgInfo('Não há dados para ser processado, verifique os parâmetros.',cCadastro)
		Endif	
	Else
		lRet := .F.
		MsgInfo( 'A entidade ' + ValToSql( aRet[2] ) + ' informada não está programada para esta rotina.', cCadastro )
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A100Show     | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar os dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100Show( aRet )
	Local oDlg 
	Local oPanel
	
	Local nCol := 0
	Local nRow := 0
	Local nL := 2
	Local nI := 0
	
	Local cOK := 'AllWaysTrue'
	Local cU7_COD_NOME := ''
	
	Local aButton := {}
	Local aSay := { 'Clique no título da coluna X para marcar ou desmarcar todos os registros.', ;
		             'Clique no título das colunas Nome do cliente ou Nome do contato para filtrar e ordenar.' }
	
	Local oFont := TFont():New('Courier new',,-16,,.T.)
	Local oFont12 := TFont():New('Courier new',,-12,,.F.)
	
	Private lA100Mrk := .F.
		
	Private oGride
	Private oFiltro 
	
	Private aCOLS_ORIG := {}
	
	Private cFilter := Space(100)	
	
	aCOLS_ORIG := AClone( aCOLS )
	
	// [1] - Título do botão.
	// [2] - Chamada da funcionalidade.
	// [3] - Nº da tecla de atalho.
	AAdd( aButton, { '&Pesquisar F4'        , '{|| GdSeek(oGride,,aHeader,aCOLS,.F.) }' , 115 } )
	AAdd( aButton, { '&Legenda F5'          , '{|| A100Legenda( Len( oGride:aCOLS ) ) }' , 116 } )
	AAdd( aButton, { '&Marcar todos F6'     , '{|| A100MrkAll() }' , 117 } )
	AAdd( aButton, { '&Desmarcar todos F7'  , '{|| A100DesMrk() }' , 118 } )
	AAdd( aButton, { '&Inverter seleção F8' , '{|| A100Invert() }' , 119 } )
	AAdd( aButton, { '&Resumo F9'           , '{|| Iif(A100Vld(1),A100Resumo(),NIL)}' , 120 } )	
	AAdd( aButton, { '&Transferir F10'      , '{|| Iif(A100Vld(2),Iif(A100ParTra(aRet),(oDlg:End()),NIL),NIL)}' , 121 } )	
	AAdd( aButton, { '&Sair F11'            , '{|| Iif( MsgYesNo("Deseja realmente sair da rotina?", cCadastro ), oDlg:End(), NIL ) }' , 122 } )
	
	cU7_COD_NOME := 'Selecione as agendas abaixo do operador [' + aRet[1] + ' - ' + ;
	RTrim( Posicione( 'SU7', 1, xFilial( 'SU7' ) + aRet[1], 'U7_NOME' ) ) + '] para transferir.'

	oMainWnd:ReadClientCoors()
	nCol := oMainWnd:nClientWidth
	nRow := oMainWnd:nClientHeight
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 00,00 TO nRow-34,nCol-8 PIXEL
		oDlg:lMaximized := .T.
		
		oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,26,.F.,.T.)
		oPanel:Align := CONTROL_ALIGN_TOP
		
		@ 3,2 SAY cU7_COD_NOME OF oPanel FONT oFont PIXEL COLOR CLR_BLUE SIZE 500,10
		
		For nI := 1 To Len( aButton )			
			SetKey( aButton[ nI, 3 ], &(aButton[nI,2]) )
			TButton():New(14,nL,aButton[nI,1],oPanel,&(aButton[nI,2]),56,9,,,.F.,.T.,.F.,,.F.,,,.F.)
			nL += 60
		Next nI
		
		oGride := MsNewGetDados():New( 012, 002, 120, 265, 0, cOK, cOK, '', {}, 0, Len(aCOLS), '', '', '', oDlg, aHeader, aCOLS )
		oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		oGride:oBrowse:bLDblClick := {||  A100MrkOne(), oGride:Refresh() }		
		oGride:oBrowse:bHeaderClick := {| oBrw, nColHead, aDim| A100Head( nColHead, @oDlg, oPnlFoot ) }

		oPnlFoot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,16,.F.,.T.)
		oPnlFoot:Align := CONTROL_ALIGN_BOTTOM
		
		@ 1,2 SAY aSay[ 1 ] OF oPnlFoot FONT oFont12 PIXEL COLOR CLR_BLUE SIZE 500,7
		@ 7,2 SAY aSay[ 2 ] OF oPnlFoot FONT oFont12 PIXEL COLOR CLR_BLUE SIZE 500,7
		
		@  1, (oPnlFoot:nClientWidth/2)-85 SAY oFiltro VAR '             Sem filtro' OF oPnlFoot FONT oFont12 PIXEL COLOR CLR_HRED SIZE 100,7
	ACTIVATE MSDIALOG oDlg
	
	AEval( aButton, {|p| SetKey( p[ 3 ], NIL ) } )
Return

//-----------------------------------------------------------------------
// Rotina | A100Head     | Autor | Robson Luiz - Rleg | Data | 09/09/2014
//-----------------------------------------------------------------------
// Descr. | Rotina para filtrar os registros.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100Head( nColHead, oDlg, oPnlFoot, oFont12 )
	Local oDlgFilter
	Local oFilter 
	Local aCOLS_AUX := {}
	Local lFilter := .F.
	Local nI := 0
	Local nP := 0
	Local nU4_LISTA  := 0
	Local nU6_CODIGO := 0
	// Controle de chamada da função, uma chamada por vez.
	__nExec++
	If (__nExec%2) <> 0
		// Se for clicado na primaira coluna.
		If nColHead == 1
			// Está marcado?
			If lA100Mrk
				// Desmarcar.
				A100DesMrk()
			Else
				// Marcar.
				A100MrkAll()
		   Endif
	   Else
	   	// Se for clicado na coluna 5 => Nome do cliente ou na coluna 7 => Nome do contato.
	   	If nColHead == 5 .OR. nColHead == 7
	   		cFilter := PadR( cFilter, 100, ' ' )
	   		// Montar a janela para usuário informar o filtro.
				DEFINE MSDIALOG oDlgFilter FROM 0,0 TO 105,370 TITLE 'Filtrar' PIXEL STYLE DS_MODALFRAME STATUS
					@  7,9 SAY 'Informe a palavra chave para filtrar pela coluna "' + Lower( RTrim( aHeader[ nColHead, 1 ] ) ) +'"' OF oDlgFilter PIXEL
					@ 17,9 GET oFilter VAR cFilter PICTURE '@!' OF oDlgFilter PIXEL SIZE 172,9
					@ 33, 39 BUTTON 'Filtrar' PIXEL OF oDlgFilter SIZE 44,11 ACTION (lFilter := .T., oDlgFilter:End()) 
					@ 33, 88 BUTTON 'Limpar'  PIXEL OF oDlgFilter SIZE 44,11 ACTION (cFilter := Space(100), oFilter:SetFocus())
					@ 33,137 BUTTON 'Sair'    PIXEL OF oDlgFilter SIZE 44,11 ACTION oDlgFilter:End()
				ACTIVATE MSDIALOG oDlgFilter CENTERED
				// Se clicado no botão filtrar.
				If lFilter
					// Buscar a posição dos campos chaves.
					nU4_LISTA  := GdFieldPos('U4_LISTA')
					nU6_CODIGO := GdFieldPos('U6_CODIGO')
					// Atualizar o vetor origem com as marcações/desmarcações efetuadas.
					For nI := 1 To Len( oGride:aCOLS )
						nP := AScan( aCOLS_ORIG, {|a| a[ nU4_LISTA ] + a[ nU6_CODIGO ] == oGride:aCOLS[ nI, nU4_LISTA ] + oGride:aCOLS[ nI, nU6_CODIGO ] } )
						If nP > 0
							aCOLS_ORIG[ nP, 1 ] := oGride:aCOLS[ nI, 1 ]
						Endif
					Next nI
					// Se não houver palavra chave para pesquisar.
					If Empty( cFilter )
						// Ordenar o vetor.
						ASort( aCOLS,,,{|a,b| a[ nColHead ] < b[ nColHead ] } )
						// Atualizar o vetor da GetDados com o vetor principal.
						oGride:SetArray( aCOLS, .T. )
						// Informar no título da janela principal que está sem filtro.
						oDlg:cTitle := cCadastro
						oFiltro:SetText( '             Sem filtro' )
					Else
						// Se houver palavra chave para pesquisar.
						cFilter := AllTrim( cFilter )
						// Pesquisar no vetor principal os registros que atende a pesquisa.
						For nI := 1 To Len( aCOLS )
							If cFilter $ aCOLS[ nI, nColHead ] 
								// Armazenar no vetor auxiliar.
								AAdd( aCOLS_AUX, AClone( aCOLS[ nI ] ) )
							Endif
						Next nI
						// Ordenar o vetor.
						ASort( aCOLS_AUX,,,{|a,b| a[ nColHead ] < b[ nColHead ] } )
						// Se não houver dados no vetor auxiliar, fazer um elemento vazio para não dar erro.
						If Len( aCOLS_AUX ) == 0
							AAdd( aCOLS_AUX, Array( Len( aHeader )+1 ) )
							AFill( aCOLS_AUX[ 1 ], '' )
							aCOLS_AUX[ 1, Len( aHeader )+1 ] := .F.
						Endif
						// Atualizar o vetor da GetDados.
						oGride:SetArray( aCOLS_AUX, .T. )
						// Indicar no título da janela que está com filtro.
						oDlg:cTitle := cCadastro + ' [ Filtro ativado pela coluna: ' + Lower( RTrim( aHeader[ nColHead, 1 ] ) ) + ' ] '
						oFiltro:SetText( 'Filtro: ' + RTrim( aHeader[ nColHead, 1 ] ) )
					Endif
					// Se houver dados, seguir...
					If .NOT. Empty( oGride:aCOLS[ 1, 1 ] )
						// Atualizar a coluna marcado/desmarcado conforme o vetor origem.
						For nI := 1 To Len( aCOLS_ORIG )
							// Localizar pela chave.
							nP := AScan( oGride:aCOLS, {|a| a[ nU4_LISTA ] + a[ nU6_CODIGO ] == aCOLS_ORIG[ nI, nU4_LISTA ] + aCOLS_ORIG[ nI, nU6_CODIGO ] } )
							// Se encontrar.
							If nP > 0
								// Atualizar.
								oGride:aCOLS[ nP, 1 ] := aCOLS_ORIG[ nI, 1 ] 
							Endif
						Next nI
					Endif
				Endif
			Endif
		Endif
		// Atualizar o objeto.
		oGride:Refresh()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A100Legenda  | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar as legendas dos registros.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100Legenda( nRegistros )
	Local aCor := {}
	
	AAdd( aCor, { 'LBNO'        , 'Registro não selecionado' } )
	AAdd( aCor, { 'LBOK'        , 'Registro selecionado' } )

	AAdd( aCor, { 'BR_VERMELHO' , 'Atendimento pendente' } )
	AAdd( aCor, { 'BR_AZUL'     , 'Atendimento encerrado' } )

	AAdd( aCor, { 'BR_VERMELHO' , 'Agenda pendente' } )
	AAdd( aCor, { 'BR_VERDE'    , 'Agenda planejada' } )
	AAdd( aCor, { 'BR_AZUL'     , 'Agenda encerrada' } )

	AAdd( aCor, { ''            , LTrim(Str(nRegistros))+' registro(s) localizado(s).' } )
	
	BrwLegenda( cCadastro, 'Legenda dos registros', aCor )	
Return

//-----------------------------------------------------------------------
// Rotina | A100MrkOne   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina p/ marcar somente um registro ou todos da mesma lista.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100MrkOne()
	Local nI := 0
	Local cLista := ''
	Local nU4_LISTA := 0
	Local nLista := 0
	Local cMark := ''
	
	nU4_LISTA := AScan( aHeader,{|p| p[2] == 'U4_LISTA' } )
	cLista := oGride:aCOLS[ oGride:nAt, nU4_LISTA ] 
	
	For nI := 1 To Len( oGride:aCOLS )
		If oGride:aCOLS[ nI, nU4_LISTA ] == cLista
			nLista++
		Endif
	Next nI

	If nLista == 1
		If oGride:aCOLS[ oGride:nAt, 1 ] == 'LBOK'
			oGride:aCOLS[ oGride:nAt, 1 ] := 'LBNO'
		Else
			oGride:aCOLS[ oGride:nAt, 1 ] := 'LBOK'
		Endif
	Else
		nOpc := Aviso('Seleção de registro',;
		'Neste item que você clicou há mais registro desta mesma lista, devo agir em todos ou somente o item que você selecionou?',;
		{'Somente','Todos'},2,'O que devo fazer?')
		
		If nOpc == 1
			If oGride:aCOLS[ oGride:nAt, 1 ] == 'LBOK'
				oGride:aCOLS[ oGride:nAt, 1 ] := 'LBNO'
			Else
				oGride:aCOLS[ oGride:nAt, 1 ] := 'LBOK'
			Endif
		Elseif nOpc == 2
			cMark := Iif(oGride:aCOLS[ oGride:nAt, 1 ]=='LBOK','LBNO','LBOK')
			For nI := 1 To Len( oGride:aCOLS )
				If oGride:aCOLS[ nI, nU4_LISTA ] == cLista
					oGride:aCOLS[ nI, 1 ] := cMark
				Endif
			Next nI
		Else
			MsgInfo('Nenhum item será marcado',cCadastro)
		Endif
	Endif	
Return

//-----------------------------------------------------------------------
// Rotina | A100MrkAll   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para marcar todos os registro.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100MrkAll()
	Local nI := 0
	lA100Mrk:=!lA100Mrk
	For nI := 1 To Len( oGride:aCOLS )
		oGride:aCOLS[ nI, 1 ] := 'LBOK'
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | A100DesMrk   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para desmarcar todos os registros.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100DesMrk()
	Local nI := 0
	lA100Mrk:=!lA100Mrk
	For nI := 1 To Len( oGride:aCOLS )
		oGride:aCOLS[ nI, 1 ] := 'LBNO'
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | A100Invert   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para inverter a marca dos registros.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100Invert()
	Local nI := 0
	For nI := 1 To Len( oGride:aCOLS )
		If oGride:aCOLS[ nI, 1 ] == 'LBOK'
			oGride:aCOLS[ nI, 1 ] := 'LBNO'
		Else
			oGride:aCOLS[ nI, 1 ] := 'LBOK'
		Endif
	Next nI	
Return

//-----------------------------------------------------------------------
// Rotina | A100Vld      | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para validar se pode inciar transferência.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100Vld( nOpc )
	Local nI := 0
	Local nPos := 0
	Local nMARK := 0
	
	Local cMsg := ''
	
	Local lRet := .F.
	
	nMARK := AScan( aHeader, {|p| p[2]=='MARK' } )
	
	If nMARK > 0
		nPos := AScan( oGride:aCOLS, {|p| p[nMARK]=='LBOK' } )
		If nPos == 0
		   If nOpc == 1
		   	cMsg := 'Nenhum item foi selecionado para resumo, por favor, selecione no mínino um registro para apresentar o resumo.'
		   Elseif nOpc == 2
		   	cMsg := 'Nenhum item foi selecionado para transferência, por favor, selecione no mínino um registro para transferir.'
		   Else
		   	cMsg := 'Mensagem não programada.'
		   Endif
			MsgInfo( cMsg, cCadastro )
		Else
			lRet := .T.
		Endif
	Else
		MsgAlert('Problemas com a coluna "MARK", verifique.',cCadastro)
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A100ParTra   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina que solicita o operador para quem será transferido.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100ParTra( aParam )
	Local lRet := .F.
	Local aPar := {}
	Local aRet := {}
	Local bOK := {|| MsgYesNo('Confirma realmente o processamento?', cCadastro ) }
	Local cValid := '(mv_par03 <> "'+aParam[1]+'") .And. ExistCpo("SU7")'
	Local cU7_NOME := RTrim(SubStr(Posicione('SU7',1,xFilial('SU7')+aParam[1],'U7_NOME'),1,30))
	
	AAdd( aPar,{ 9, 'Tranferência de agenda(s) do operador:',150,7,.T.})
	AAdd( aPar,{ 9, aParam[1]+' - '+cU7_NOME,150,7,.T.})
	AAdd( aPar,{ 1, 'Para o operador', Space(6), '@!', cValid, 'SU7', '', 50, .T. } )
	
	If ParamBox( aPar, 'Parâmetros', @aRet,bOK,,,,,,,.F.,.F.)
		Begin Transaction
			Processa( {|| A100ProTra( aRet, aParam[ 1 ] ) }, cCadastro, 'Aguarde enquanto efetua a transferência...', .F. )
		End Transaction
		lRet := .T.
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A100ProTra   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para processar as transferências.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100ProTra( aRet, cOperAnt )
	Local cOper := ''
	
	Local nI := 0
	Local nLoop := 0
	Local nPos := 0
	
	Local cLista := ''
	Local cU4_LISTA := ''
		
	Local nMARK := 0
	Local nU4_LISTA := 0
	Local nU4_DATA := 0
	Local nU5_FILHOS := 0
	Local nU5_CODCONT := 0
	Local nU6_CODIGO := 0
	Local nU6_ENTIDA := 0
	Local nU6_CODENT := 0
	
	Local nMarcados := 0
	
	Private a100Log := {}
	
	cOper       := aRet[ 3 ]
	nMARK       := AScan( oGride:aHeader, {|p| p[2]=='MARK'       } )
	nU4_LISTA   := AScan( oGride:aHeader, {|p| p[2]=='U4_LISTA'   } )
	nU4_DATA    := AScan( oGride:aHeader, {|p| p[2]=='U4_DATA'    } )
	nU5_FILHOS  := AScan( oGride:aHeader, {|p| p[2]=='U5_FILHOS'  } )
	nU5_CODCONT := AScan( oGride:aHeader, {|p| p[2]=='U5_CODCONT' } )
	nU6_CODIGO  := AScan( oGride:aHeader, {|p| p[2]=='U6_CODIGO'  } )
	nU6_ENTIDA  := AScan( oGride:aHeader, {|p| p[2]=='U6_ENTIDA'  } )
	nU6_CODENT  := AScan( oGride:aHeader, {|p| p[2]=='U6_CODENT'  } )
	
	nLoop := Len( oGride:aCOLS )
	ProcRegua( nLoop )
	
	For nI := 1 To nLoop
		IncProc('Processando registro '+LTrim(Str(nI))+' de '+LTrim(Str(nLoop)))
		// Está marcado?
		If oGride:aCOLS[ nI, nMARK ] == 'LBOK'
			// Somente há um contato na lista?
			If oGride:aCOLS[ nI, nU5_FILHOS ] == 1
				// Alterar somente o item desta lista.
				A100AltOper( oGride:aCOLS[ nI, nU4_LISTA ], oGride:aCOLS[ nI, nU4_DATA ], cOper )
				// Alterar o operador e vendedor na entidade.
				A100Entidade( RTrim(oGride:aCOLS[ nI, nU6_CODENT ]), oGride:aCOLS[ nI, nU6_ENTIDA ], cOper )
				// Gera Log de transferência.
				AAdd( a100Log, oGride:aCOLS[ nI, nU4_LISTA ]   + ';' + ;
									oGride:aCOLS[ nI, nU6_CODIGO ]  + ';' + ;
									oGride:aCOLS[ nI, nU5_CODCONT ] + ';' + ;
									oGride:aCOLS[ nI, nU6_CODENT ]  + ';' + ;
									oGride:aCOLS[ nI, nU6_ENTIDA ]  + ';' + ;
									Dtoc( oGride:aCOLS[ nI, nU4_DATA ] )    + ';' + ;
									cOperAnt  + ';' + ;
									aRet[ 3 ] + '; ;' )
			Else
				// Pegar nº da lista.
				cLista := oGride:aCOLS[ nI, nU4_LISTA ]
				// Pegar a posição do primeiro da lista em questão.
				nPos := AScan( oGride:aCOLS, {|p| p[nU4_LISTA]==cLista } )
				// Verificar se todos os itens da mesma lista estão marcados.
				For nJ := nPos To nLoop
					If oGride:aCOLS[ nJ, nU4_LISTA ] == cLista
						If oGride:aCOLS[ nJ, nMARK ] == 'LBOK'
							nMarcados++
						Endif
					Else
						Exit
					Endif
				Next nJ
			
				// Todos estão marcados.
				If oGride:aCOLS[ nI, nU5_FILHOS ] == nMarcados
					// Alterar a lista inteira.
					A100AltLista( cLista, cOper, cOperAnt )
				// Não, todos não estão marcados.
				Else
					// Copiar o registro em questão e apagar o SU6 marcadado.
					cU4_LISTA := A100NewLista( oGride:aCOLS[ nI, nU4_LISTA ], oGride:aCOLS[ nI, nU4_DATA ], oGride:aCOLS[ nI, nU6_CODIGO ], cOper )
					// Alterar o operador e vendedor na entidade.
					A100Entidade( RTrim(oGride:aCOLS[ nI, nU6_CODENT ]), oGride:aCOLS[ nI, nU6_ENTIDA ], cOper )
					// Gera Log de transferência.
					AAdd( a100Log, oGride:aCOLS[ nI, nU4_LISTA ]   + ';' + ;
										oGride:aCOLS[ nI, nU6_CODIGO ]  + ';' + ;
										oGride:aCOLS[ nI, nU5_CODCONT ] + ';' + ;
										oGride:aCOLS[ nI, nU6_CODENT ]  + ';' + ;
										oGride:aCOLS[ nI, nU6_ENTIDA ]  + ';' + ;
										Dtoc( oGride:aCOLS[ nI, nU4_DATA ] )   + ';' + ;
										cOperAnt  + ';' + ;
										aRet[ 3 ] + ';' + ;
										'EXCLUÍDO ' +  oGride:aCOLS[ nI, nU4_LISTA ] + ' INCLUÍDO ' + cU4_LISTA + ';' )
				Endif
				cLista := ''
				nMarcados := 0
				nPos := 0
				nJ := 0				
			Endif
		Endif
	Next nI
	If Len( a100Log ) > 0
		FA100Log()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A100AltOper  | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para alterar o código do operador na lista.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100AltOper( cLista, dData, cOper )
	SU4->( dbSetOrder( 1 ) )
	If SU4->( dbSeek( xFilial( 'SU4' ) + cLista + Dtos( dData ) ) )
		SU4->( RecLock( 'SU4', .F. ) )
		SU4->U4_OPERAD := cOper 
		SU4->( MsUnLock( 'SU4' ) )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A100AltLista | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina p/alterar o cód.do operad.em todos os itens da lista.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100AltLista( cLista, cOper, cOperAnt )
	Local nI := 0
	Local nPos := 0
	Local nLoop := Len( oGride:aCOLS )
	
	Local nU4_LISTA := 0
	Local nU4_DATA  := 0
	Local nU6_ENTIDA := 0
	Local nU6_CODENT := 0
	Local nU6_CODIGO := 0
	Local nU5_CODCONT := 0
	
	nU4_LISTA   := AScan( oGride:aHeader, {|p| p[2]=='U4_LISTA' })
	nU4_DATA    := AScan( oGride:aHeader, {|p| p[2]=='U4_DATA' })
	nU6_ENTIDA  := AScan( oGride:aHeader, {|p| p[2]=='U6_ENTIDA' } )
	nU6_CODENT  := AScan( oGride:aHeader, {|p| p[2]=='U6_CODENT' } )
	nU6_CODIGO  := AScan( oGride:aHeader, {|p| p[2]=='U6_CODIGO' } )
	nU5_CODCONT := AScan( oGride:aHeader, {|p| p[2]=='U5_CODCONT' } )

	If nU4_LISTA > 0 .And. nU4_DATA > 0 .And. nU6_ENTIDA > 0 .And. nU6_CODENT > 0
		nPos := AScan( oGride:aCOLS, {|p| p[nU4_LISTA]==cLista } )
		If nPos > 0
			For nI := nPos To nLoop
				If oGride:aCOLS[ nI, nU4_LISTA ] == cLista
					// Alterar o código do operador na lista.
					A100AltOper( cLista, oGride:aCOLS[ nI, nU4_DATA ], cOper )
					// Alterar o código do operador na entidade.
					A100Entidade( RTrim(oGride:aCOLS[ nI, nU6_CODENT ]), oGride:aCOLS[ nI, nU6_ENTIDA ], cOper )
					// Gera Log de transferência.
					AAdd( a100Log, oGride:aCOLS[ nI, nU4_LISTA ]   + ';' + ;
										oGride:aCOLS[ nI, nU6_CODIGO ]  + ';' + ;
										oGride:aCOLS[ nI, nU5_CODCONT ] + ';' + ;
										oGride:aCOLS[ nI, nU6_CODENT ]  + ';' + ;
										oGride:aCOLS[ nI, nU6_ENTIDA ]  + ';' + ;
										Dtoc( oGride:aCOLS[ nI, nU4_DATA ] )  + ';' + ;
										cOperAnt  + ';' + ;
										cOper + '; ;' )
				Else
					Exit
				Endif
			Next nI
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A100NewLista | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para criar nova lista e apagar a existente.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100NewLista( cLista, dData, cCodigo, cOper )
	Local nI := 0
	Local aSU4 := {}
	Local aSU6 := {}
	Local nU4_RECNO := 0
	Local nU6_RECNO := 0
	Local cU4_LISTA := ''
	Local cU6_CODIGO := ''

	SU4->( dbSetOrder( 1 ) )
	If SU4->( dbSeek( xFilial( 'SU4' ) + cLista + Dtos( dData ) ) )
		nU4_RECNO := SU4->( RecNo() )
		AAdd( aSU4, { 'U4_TIPO'   , SU4->U4_TIPO } )
		AAdd( aSU4, { 'U4_STATUS' , SU4->U4_STATUS } )
		AAdd( aSU4, { 'U4_DESC'   , SU4->U4_DESC } )
		AAdd( aSU4, { 'U4_DATA'   , SU4->U4_DATA } )
		AAdd( aSU4, { 'U4_HORA1'  , SU4->U4_HORA1 } )
		AAdd( aSU4, { 'U4_FORMA'  , SU4->U4_FORMA } )
		AAdd( aSU4, { 'U4_TELE'   , SU4->U4_TELE } )
		AAdd( aSU4, { 'U4_TIPOTEL', SU4->U4_TIPOTEL } )
		AAdd( aSU4, { 'U4_NIVEL'  , SU4->U4_NIVEL } )
		AAdd( aSU4, { 'U4_XDTVENC', SU4->U4_XDTVENC } )
		AAdd( aSU4, { 'U4_XGRUPO' , SU4->U4_XGRUPO } )
	Endif
	
	SU6->( dbSetOrder( 1 ) )
	If SU6->( dbSeek( xFilial( 'SU6' ) + cLista + cCodigo ) )
		nU6_RECNO := SU6->( RecNo() )
		AAdd( aSU6, { 'U6_CONTATO', SU6->U6_CONTATO } )
		AAdd( aSU6, { 'U6_ENTIDA' , SU6->U6_ENTIDA } )
		AAdd( aSU6, { 'U6_CODENT' , SU6->U6_CODENT } )
		AAdd( aSU6, { 'U6_ORIGEM' , SU6->U6_ORIGEM } )
		AAdd( aSU6, { 'U6_DATA'   , SU6->U6_DATA } )
		AAdd( aSU6, { 'U6_HRINI'  , SU6->U6_HRINI } )
		AAdd( aSU6, { 'U6_HRFIM'  , SU6->U6_HRFIM } )
		AAdd( aSU6, { 'U6_STATUS' , SU6->U6_STATUS } )
		AAdd( aSU6, { 'U6_DTBASE' , SU6->U6_DTBASE } )		
	Endif
	
	If Len( aSU4 ) > 0 .And. Len( aSU6 ) > 0 .And. nU4_RECNO > 0 .And. nU6_RECNO > 0	
		If nU6_RECNO <> SU6->( RecNo() )
			SU6->( dbGoTo( nU6_RECNO ) )
		Endif

		SU6->( RecLock( 'SU6', .F. ) )
		SU6->( dbDelete() )
		SU6->( MsUnLock() )
		
		cU4_LISTA  := GetSXENum('SU4','U4_LISTA')
		ConfirmSX8()
		
		cU6_CODIGO := GetSXENum('SU6','U6_CODIGO')
		ConfirmSX8()
		
		SU4->( RecLock( 'SU4', .T. ) )
		SU4->U4_FILIAL := xFilial( 'SU4' )
		SU4->U4_LISTA  := cU4_LISTA
		SU4->U4_OPERAD  := cOper
		For nI := 1 To Len( aSU4 )
			SU4->( FieldPut( FieldPos( aSU4[ nI, 1 ] ), aSU4[ nI, 2 ] ) )
		Next nI
		SU4->( MsUnLock() )
		
		SU6->( RecLock( 'SU6', .T. ) )
		SU6->U6_FILIAL := xFilial( 'SU6' )
		SU6->U6_LISTA  := cU4_LISTA
		SU6->U6_CODIGO := cU6_CODIGO
		For nI := 1 To Len( aSU6 )
			SU6->( FieldPut( FieldPos( aSU6[ nI, 1 ] ), aSU6[ nI, 2 ] ) )
		Next nI
		SU6->( MsUnLock() )
		
		// Verificar se não existe registro no SU6 com o número de lista em questão.
		// Se realmente não existe, apagar o registro do SU4 relacionado ao filho desta mesma lista.
		SU6->( dbSetOrder( 1 ) )
		If !SU6->( dbSeek( xFilial( 'SU6' ) + cLista ) )
			If nU4_RECNO <> SU4->( RecNo() )
				SU4->( dbGoTo( nU4_RECNO ) )
			Endif			
			SU4->( RecLock( 'SU4', .F. ) )
			SU4->( dbDelete() )
			SU4->( MsUnLock() )
		Endif
	Endif
Return( cU4_LISTA )

//-----------------------------------------------------------------------
// Rotina | A100Entidade | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para alterar o operador/vendedor na entidade.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100Entidade( cCodEnt, cEntidade, cOper )
	Local cA3_COD := ''
	Local cConsult := ''
	Local cOperador := ''
	
	//---------------------------------------------------------------------------------
	// Somente estas entidades estão previstas trocar o consultor/operador no cadastro.
	//---------------------------------------------------------------------------------
	If cEntidade $ 'PAB|SZT|SZX'
		If cEntidade == 'PAB'
			cConsult  := cEntidade + '->' + cEntidade + '_CONSUL'
			cOperador := cEntidade + '->' + cEntidade + '_OPERAD'
		Else
			cConsult  := cEntidade + '->' + Right( cEntidade, 2 ) + '_CONSULT'
			cOperador := cEntidade + '->' + Right( cEntidade, 2 ) + '_OPERAD'
		Endif
		
		cA3_COD   := Posicione( 'SU7', 1, xFilial( 'SU7' ) + cOper, 'U7_CODVEN' )
		
		&(cEntidade)->( dbSetOrder( 1 ) )
		If &(cEntidade)->( dbSeek( xFilial( cEntidade ) + RTrim( cCodEnt ) ) )
			&(cEntidade)->( RecLock( cEntidade, .F. ) )		
			&(cOperador) := cOper
			&(cConsult)  := cA3_COD
			&(cEntidade)->( MsUnLock() )
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A100Resumo   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar somente os registros marcados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A100Resumo()
	Local nI := 0
	Local nJ := 0
	Local nElem := 1
	
	Local nMarcados := 0
	
	Local aCpo := {}
	Local aDados := {}
	
	Local oDlg 
	Local oLbx
	Local oPanel
	
	Local cRegMrk := ''
	
	Local nMARK := AScan( aHeader, {|p| p[2]=='MARK' } )
	
	For nI := 4 To Len( aHeader ) -1
		AAdd( aCpo, aHeader[ nI, 1 ] )
	Next nI 
	
	For nI := 1 To Len( oGride:aCOLS )
		If oGride:aCOLS[ nI, nMARK ] == 'LBOK'
			nMarcados++
			AAdd( aDados, Array( Len( aHeader ) - 4 ) )
			For nJ := 4 To Len( aHeader ) -1
				aDados[ Len( aDados ), nElem ] := oGride:aCOLS[ nI, nJ ]
				nElem++
			Next nJ
			nElem := 1
		Endif
	Next nI
	
	If Len( aDados ) > 0
		DEFINE MSDIALOG oDlg TITLE 'Resumo das agendas que serão transferidas' FROM 0,0 TO 300,800 PIXEL
			oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,12,.F.,.F.)
			oPanel:Align := CONTROL_ALIGN_BOTTOM	
			TButton():New(2,2,'&Sair',oPanel,{|| oDlg:End()},56,9,,,.F.,.T.,.F.,,.F.,,,.F.)
			
			cRegMrk := 'Quantidade de registros selecionados ' + LTrim( Str( nMarcados ) )
			@ 3,80 SAY cRegMrk OF oPanel PIXEL COLOR CLR_BLUE SIZE 500,10
			
		   oLbx := TwBrowse():New(0,0,0,0,,aCpo,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:SetArray( aDados )
		   oLbx:bLine := {|| aEval( aDados[oLbx:nAt],{|z,w| aDados[oLbx:nAt,w]})}
		ACTIVATE MSDIALOG oDlg CENTER
	Else
		MsgAlert('Não há resumo para ser apresentado.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | FA100Log     | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina gravar o log de uso da rotina.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function FA100Log()
	Local nI := 0
	Local nHdl := 0
	Local nLimite := 174
	Local cFile := 'ldtdado.log'
	
	If Len( A100Log ) > 0
		If ! File( cFile )
			nHdl := fCreate( cFile )
		Else
			nHdl := fOpen( cFile )
		Endif
		
		If nHdl > 0
			fSeek( nHdl, 0, 2 )
			
			fWrite( nHdl, Replicate( '-', nLimite ) + ';' + CRLF )
			fWrite( nHdl, 'ROTINA CSFA100 TRANSFERENCIA DE AGENDA DE OPERADOR' + ';' + CRLF)
			fWrite( nHdl, 'EXECUTADA EM ' + Dtos( dDataBase ) + ';' + CRLF )
			fWrite( nHdl, 'HORA DA EXECUCAO ' + Time() + ';' + CRLF )
			fWrite( nHdl, 'USUARIO EXECUTOR ' + __cUserID + ' ' + RTrim( cUserName ) + ';' + CRLF )
			fWrite( nHdl, Replicate( '-', nLimite ) + ';' + CRLF )
			fWrite( nHdl, 'Nº DA LISTA DE CONTATO;ITEM DA LISTA DE CONTATO;CODIGO DO CONTATO;CODIGO DA ENTIDADE;SIGLA DA ENTIDADE;DATA DA AGENDA;'+;
			              'DO OPERADOR;PARA OPERADOR;TROCA DA LISTA DE CONTATO     ;' + CRLF )
			
			For nI := 1 To Len( A100Log )
				fWrite( nHdl, A100Log[ nI ] + ';' + CRLF )
			Next nI
			
			fClose( nHdl )
			__copyfile( cFile, 'c:\'+cFile )
		Else
			MsgAlert('Não foi possível criar/abrir arquivo de log de processamento.')
		Endif
	Endif
Return
/*
123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;
ROTINA CSFA100 TRANSFERENCIA DE AGENDA DE OPERADOR                                                                                                                            ;
EXECUTADA EM XX/XX/XXX                                                                                                                                                        ;
HORA DA EXECUCAO XX:XX:XX                                                                                                                                                     ;
USUARIO EXECUTOR 999999 XXXXXXXXXXXXXXXXXXXX                                                                                                                                  ;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Nº DA LISTA DE CONTATO;ITEM DA LISTA DE CONTATO;CODIGO DO CONTATO;CODIGO DA ENTIDADE;SIGLA DA ENTIDADE;DATA DA AGENDA;DO OPERADOR;PARA OPERADOR;TROCA DA LISTA DE CONTATO     ;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Nº DA LISTA DE CONTATO;ITEM DA LISTA DE CONTATO;CODIGO DO CONTATO;CODIGO DA ENTIDADE;SIGLA DA ENTIDADE;DATA DA AGENDA;DO OPERADOR;PARA OPERADOR;TROCA DA LISTA DE CONTATO     ;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
999999                ;999999                  ;999999           ;99999999          ;XXX              ;XX/XX/XXXX    ;999999     ;999999       ;EXLUÍDO 999999 INCLUIDO 999999;
*/