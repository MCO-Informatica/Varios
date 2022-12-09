#Include 'Protheus.ch'
#Include 'TbiConn.ch'

#DEFINE MRK   'NGCHECKOK.PNG'
#DEFINE NOMRK 'NGCHECKNO.PNG'

//-------------------------------------------------------------------------
// Rotina | CSFA461      | Autor | Robson Gonçalves     | Data | 12/08/2015
//-------------------------------------------------------------------------
// Descr. | Rotina de retratação da carta de lembrete de cobrança.
//-------------------------------------------------------------------------
// Update | Rafael Beghini | Data: 18/06/2015
//        | Acrescentado Vencimento De/Ate; Retirado ramal do Html;
//        | Rotina para enviar o LOG de processamento ao Financeiro
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function CSFA461( aParam )
	Private l460Auto := (Select('SX6')==0)
	Private aCOLS := {}
	Private aHeader := {}
	Private aMsgOk  := {}
	Private aItens  := {}
	
	Private cCadastro := 'Lembrete de Pagamento'
	
	Private cPerg := 'CSFA460'
	Private cTRB := ''
	
	Private cMV_460ANTE := 'MV_460ANTE'
	Private cMV_460HTML := 'MV_460HTML'
	Private cMV_FKMAIL  := 'MV_FKMAIL'
	Private cMV_460LOG  := 'MV_460LOG'
	
	Private 	nA1_NOME    := 0
	Private 	nA1_CONTATO := 0
	Private 	nA1_EMAIL   := 0
	Private 	nE1_CLIENTE := 0
	Private 	nE1_LOJA    := 0
	Private 	nE1_NUM     := 0
	Private 	nE1_EMISSAO := 0
	Private 	nE1_VENCTO  := 0
	Private 	nE1_VALOR   := 0
	
	If l460Auto
		// Executar no modo automático.
		CSFA461x( aParam )
	Else
		// Executar no modo usuário.
		alert('rotina obsoleto.')
	Endif
Return

//-------------------------------------------------------------------------
// Rotina | CSFA461      | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina de controle em JOB.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function CSFA461x( aParam )
	Local cEmp := ''
	Local cFil := ''
	Private aMsgLog := {}
		
	cEmp := Iif( aParam == NIL, '01', aParam[ 1 ] )
	cFil := Iif( aParam == NIL, '02', aParam[ 2 ] )
	
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'TMK' TABLES 'SA1','SE1','SU5'
		A460Find1()
		A460MailLog()
	RESET ENVIRONMENT
Return

//-------------------------------------------------------------------------
// Rotina | CSFA462      | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina de controle por interface com o usuário.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function CSFA462()
	Local aSay := {}
	Local aButton := {}
	Local nOpc := 0
   
	AAdd( aSay, 'Esta rotina tem por objetivo em permitir que o usuário processe a geração do' )
	AAdd( aSay, 'lembrete de pagamento para o cliente que desejar' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch()   } } )
	AAdd( aButton, { 22, .T., { || FechaBatch()              } } )

	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		If A460PodeUsar()
			A460CriaX1( cPerg )
			If .NOT. Empty( cMV_FKMAIL )
				MsgAlert('PARÂMETRO PARA SUBSTITUIR ENDERECO DO CLIENTE HABILITADO. UTILIZADO PARA SIMULACAO/TESTE. '+cMV_FKMAIL,cCadastro+' - MV_FKMAIL' )
			Endif
			While Pergunte( cPerg, .T., 'Parâmetro - ' + cCadastro )
				A460Find2()
			End
		Endif
	Endif
Return

//-------------------------------------------------------------------------
// Rotina | A460Find1    | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para executar query na busca de dados via JOB.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460Find1()
	Local cSQL := ''
	Local cMv_Par03 := 0
	
	cMV_460ANTE := GetMv( cMV_460ANTE, .F. )
	cMv_Par03 := dDataBase + cMV_460ANTE
	
	cTRB := GetNextAlias()
	
	cSQL := "SELECT A1_NOME, "
	cSQL += "       E1_PREFIXO, "
	cSQL += "       E1_NUM, "
	cSQL += "       E1_PARCELA, "
	cSQL += "       E1_TIPO, "
	cSQL += "       E1_CLIENTE, "
	cSQL += "       E1_LOJA, "
	cSQL += "       E1_EMISSAO, "
	cSQL += "       E1_VENCTO, "
	cSQL += "       E1_VENCREA, "
	cSQL += "       E1_VALOR, "
	cSQL += "       E1_PEDIDO, "
	cSQL += "       A1_EMAIL, "
	cSQL += "       A1_CONTATO "
	cSQL += "FROM   "+RetSqlName("SE1")+" SE1 "
	cSQL += "       INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cSQL += "               ON A1_FILIAL = "+ValToSql(xFilial("SA1"))+" "
	cSQL += "              AND SA1.A1_COD = SE1.E1_CLIENTE "
	cSQL += "              AND SA1.A1_LOJA = SE1.E1_LOJA "
	cSQL += "              AND SA1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  E1_FILIAL = "+ValToSql(xFilial("SE1"))+" "
	cSQL += "       AND E1_VENCTO = "+ValToSql(cMv_Par03)+" "
	cSQL += "       AND E1_VALOR = E1_SALDO "
	cSQL += "       AND SE1.E1_TIPO = 'NF ' "
	cSQL += "       AND SE1.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY E1_CLIENTE, "
	cSQL += "          E1_LOJA, "
	cSQL += "          E1_NUM, "
	cSQL += "          E1_PREFIXO, "
	cSQL += "          E1_PARCELA, "
	cSQL += "          E1_VENCTO "
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL ), cTRB, .F., .T. )

	If .NOT. (cTRB)->(BOF()) .AND. .NOT. (cTRB)->(EOF())
		TCSETField( cTRB, 'E1_EMISSAO', 'D', 8, 0 )
		TCSETField( cTRB, 'E1_VENCTO' , 'D', 8, 0 )
		TCSETField( cTRB, 'E1_VENCREA', 'D', 8, 0 )
		TCSETField( cTRB, 'E1_VALOR'  , 'N',12, 0)
		A460Load()
		A460Gerar( aCOLS )
	Else
		AAdd( aMsgLog, 'Não foi possível encontrar registros com os parâmetros informados.')
	Endif
	(cTRB)->(dbCloseArea())
Return

//-------------------------------------------------------------------------
// Rotina | A460Find2    | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para executar query na busca de dados via interface de 
//        | usuários.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460Find2()
	Local cSQL := ''
	Local cMv_Par03 := dDataBase + MV_PAR03
	
	cTRB := GetNextAlias()
	
	cSQL := "SELECT A1_NOME, "
	cSQL += "       E1_PREFIXO, "
	cSQL += "       E1_NUM, "
	cSQL += "       E1_PARCELA, "
	cSQL += "       E1_TIPO, "
	cSQL += "       E1_CLIENTE, "
	cSQL += "       E1_LOJA, "
	cSQL += "       E1_EMISSAO, "
	cSQL += "       E1_VENCTO, "
	cSQL += "       E1_VENCREA, "
	cSQL += "       E1_VALOR, "
	cSQL += "       A1_EMAIL, "
	cSQL += "       A1_CONTATO "
	cSQL += "FROM   "+RetSqlName("SE1")+" SE1 "
	cSQL += "       INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cSQL += "               ON A1_FILIAL = "+ValToSql(xFilial("SA1"))+" "
	cSQL += "              AND SA1.A1_COD = SE1.E1_CLIENTE "
	cSQL += "              AND SA1.A1_LOJA = SE1.E1_LOJA "
	cSQL += "              AND SA1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  E1_FILIAL = "+ValToSql(xFilial("SE1"))+" "
	cSQL += "       AND E1_CLIENTE = "+ValToSql(MV_PAR01)+" "
	cSQL += "       AND E1_LOJA = "+ValToSql(MV_PAR02)+" "
	cSQL += "       AND E1_VENCTO >= "+ValToSql(MV_PAR03)+" "
	cSQL += "       AND E1_VENCTO <= "+ValToSql(MV_PAR04)+" "
	cSQL += "       AND E1_VALOR = E1_SALDO "
	cSQL += "       AND SE1.E1_TIPO = 'NF ' "
	cSQL += "       AND SE1.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY E1_CLIENTE, "
	cSQL += "          E1_LOJA, "
	cSQL += "          E1_VENCTO,"
	cSQL += "          E1_NUM, "
	cSQL += "          E1_PREFIXO, "
	cSQL += "          E1_PARCELA "
	
	FwMsgRun(,{|| cSQL := ChangeQuery( cSQL ), PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')

	If .NOT. (cTRB)->(BOF()) .AND. .NOT. (cTRB)->(EOF())
		FwMsgRun(,{|| A460Load()},,'Aguarde, carregando dados...')
		A460Show()
	Else
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
	Endif
	(cTRB)->(dbCloseArea())
	
	cTRB := ''
	aCOLS := {}
	aHeader := {}
Return

//-------------------------------------------------------------------------
// Rotina | A460Load     | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para carregar os dados no vetor aCOLS.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460Load()
	Local nI := 0
	Local cImgMrk := Iif( l460Auto, MRK, NOMRK )
	Local aCPO := {'A1_NOME','E1_PREFIXO','E1_NUM','E1_PARCELA','E1_TIPO','E1_CLIENTE','E1_LOJA','E1_EMISSAO','E1_VENCTO','E1_VENCREA','E1_VALOR','A1_EMAIL','A1_CONTATO'}
	
	aHeader := {}
	AAdd( aHeader, { '   x','GD_MARK', '@BMP', 1, 0, '', '', '', '', ''} )
	
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCPO )
		SX3->( dbSeek( aCPO[ nI ] ) )
		SX3->( AAdd( aHeader,{ X3_TITULO, X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT } ) )
	Next nI
	
	nA1_NOME    := GdFieldPos( 'A1_NOME' )
	nA1_CONTATO := GdFieldPos( 'A1_CONTATO' )
	nA1_EMAIL   := GdFieldPos( 'A1_EMAIL' )
	nE1_CLIENTE := GdFieldPos( 'E1_CLIENTE' )
	nE1_LOJA    := GdFieldPos( 'E1_LOJA' )
	nE1_NUM     := GdFieldPos( 'E1_NUM' )
	nE1_EMISSAO := GdFieldPos( 'E1_EMISSAO' )
	nE1_VENCTO  := GdFieldPos( 'E1_VENCTO' )
	nE1_VALOR   := GdFieldPos( 'E1_VALOR' )
	
	aCOLS := {}
	While .NOT. (cTRB)->( EOF() )
		
		//----------------------------------
		// Ajuste para carta de retratação.
		//----------------------------------
		SC5->( dbSetOrder( 1 ) )
		If SC5->( dbSeek( xFilial( 'SC5' ) + (cTRB)->E1_PEDIDO ) )
			If SC5->C5_XORIGPV $ '1|4|6'
				(cTRB)->( dbSkip() )
				Loop
			Endif
		Endif
		
		(cTRB)->( AAdd( aCOLS, {cImgMrk,A1_NOME,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR,A1_EMAIL,A1_CONTATO,.F.} ) )
		(cTRB)->( dbSkip() )
	End
	
	// No modo automático verificar se todos os registros possuem endereço de email.
	// Caso não houver, montar mensagem de log e eliminar o registro do vetor.
	If l460Auto
		// Ler todos os registros.
		For nI := 1 To Len( aCOLS )
			// Se não possuir email excluir do array.
			If Empty( aCOLS[ nI, nA1_EMAIL ] )
				AAdd( aMsgLog, 'Cliente ' + aCOLS[ nI, nE1_CLIENTE ] + '-' + aCOLS[ nI, nE1_LOJA ] + ' ' + aCOLS[ nI, nA1_NOME ]  + ' sem e-mail. Dados do título: ' + ;
				'Prefixo ' + aCOLS[ nI, nE1_PREFIXO ] + ' Título ' + aCOLS[ nI, nE1_NUM ] +;
				Iif( Empty( aCOLS[ nI, nE1_PARCELA ] ), '', ' Parcela ' + aCOLS[ nI, nE1_PARCELA ] ) + ' Tipo ' + aCOLS[ nI, nE1_TIPO ] )
				ADel( aCOLS, nI )
				ASize( aCOLS, Len( aCOLS )-1 )
			Endif
		Next nI
	Endif
Return

//-------------------------------------------------------------------------
// Rotina | A460Show     | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para apresentar os dados na tela para o usuário.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460Show()
	Local oDlg 
	Local oGride 
	Local oPanel
	Local nCol := 0
	Local nRow := 0
	Local oPesq
	Local oGera
	Local oSair
	Local oBar 
	Local oThb1, Thb2, Thb3
	Local bPesq, bGera, bSair 

	Private __nExec := 0	
	
	oMainWnd:ReadClientCoors()
	nCol := oMainWnd:nClientWidth
	nRow := oMainWnd:nClientHeight

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 00,00 TO nRow-34,nCol-8 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
		oDlg:lMaximized := .T.
		
		oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,13,.F.,.T.)
		oPanel:Align := CONTROL_ALIGN_BOTTOM
		
		oGride := MsNewGetDados():New( 012, 002, 120, 265, 0, '', '', '', {}, 0, Len(aCOLS), '', '', '', oDlg, aHeader, aCOLS )
		oGride:oBrowse:bLDblClick := {||  A460Mark( @oGride ), oGride:Refresh() }
		oGride:oBrowse:bHeaderClick := {|oObj,nColumn| A460Head( nColumn, @oGride ) }
		oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
		oBar := TBar():New( oPanel, 10, 9, .T.,'BOTTOM')
		
		bPesq := {|| GdSeek( oGride, 'Pesquisar títulos', aHeader, aCOLS ) }
		bGera := {|| Iif( AScan( oGride:aCOLS, {|p| p[ 1 ]==MRK} )>0, (Processa({|| A460Gerar(oGride:aCOLS)},cCadastro,'Enviando eMail, aguarde...',.F.), oDlg:End() ),;
		             MsgAlert( 'Não há título selecionado para gerar lembrete.' , cCadastro ) ) }
		bSair := {|| Iif(MsgYesNo('Deseja realmente sair da rotina?',cCadastro),oDlg:End(),NIL)}
		
		oThb1 := THButton():New( 1, 1, '&Pesquisar'     , oBar, bPesq, 30, 9 )
		oThb2 := THButton():New( 1, 1, '&Gerar Lembrete', oBar, bGera, 50, 9 )		
		oThb3 := THButton():New( 1, 1, '&Sair'          , oBar, bSair, 25, 9 )		
	ACTIVATE MSDIALOG oDlg
Return

//-------------------------------------------------------------------------
// Rotina | A460Head     | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para marcar/desmacar todos os registros.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460Head( nColumn, oGride )
	Local lMrk := .T.
	// Controle para processar somente uma vez.
	// Não sei porque, mas o protheus chama a função sempre duas vezes.
	__nExec++
	If (__nExec%2) == 0
		Return
	Endif
	// Foi clicado na coluna 1.
	If nColumn == 1
		// Há registro marcado?
		lMrk := AScan( oGride:aCOLS, {|e| e[ 1 ] == MRK } ) > 0
		// Se sim, desmarcar todos, se não marcar todos.
		AEval( oGride:aCOLS, {|e| e[ 1 ] := Iif(lMrk,NOMRK,MRK) } )
		// Atualizar o objeto.
		oGride:Refresh()
	Endif
Return

//-------------------------------------------------------------------------
// Rotina | A460Mark     | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para criticar a seleção pelo usuário.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460Mark( oGride )
	If oGride:aCOLS[ oGride:nAt, 1 ] == MRK
		oGride:aCOLS[ oGride:nAt, 1 ] := NOMRK
	Else
		// Verificar se o cliente possui endereço de email, do contrário avisar.
		If Empty( oGride:aCOLS[ oGride:nAt, nA1_EMAIL ] )
			MsgAlert( 'Cliente sem endereço eletrônico. Não será possível enviar e-mail.', cCadastro )
		Else
			oGride:aCOLS[ oGride:nAt, 1 ] := MRK
		Endif
	Endif
Return

//-------------------------------------------------------------------------
// Rotina | A460Gerar    | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para gerar o envio do email.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460Gerar( aArray )
	Local cKey := ''
	Local nLoop := 1
	Local lContinua := .T.
	Local lFirst := .T.
	Local cDir := ''
	Local cSaveFile := ''
	Local nP := 0
	Local nL := 0
	Local aDADOS := {}
	
	Local lMV_WFIMAGE := GetMv( 'MV_WFIMAGE', , .F. ) // Parâmetro do padrão que controla imagens em e-mails.
	Local cBarra := Iif( IsSrvUnix(), '/', '\' )
	Local cDir := cBarra + 'lembretcobr' + cBarra
	Local cPath := ''
	Local cBody := ''
	Local cWF7_PASTA  := 'COBRANCAAUTOMATICA'
	Local cXCLI := ''
	Local cMV_461HTML := 'CSFA461.HTM' 
		
	Private cWF7_ENDERE := ''
	Private cWF7_REMETE := ''
	Private cMailServer := GetMv('MV_RELSERV')
	Private cLogin      := GetMv('MV_RELACNT')
	Private cMailSenha  := GetMv('MV_RELPSW')
	Private lSMTPAuth   := GetMv('MV_RELAUTH')
	Private nTimeOut    := GetMv('MV_RELTIME',,120)
	
	AEval( aArray, {|e| Iif( e[ 1 ] == MRK, AAdd( aDADOS, AClone( e ) ), NIL ) } )
	
	MakeDir( cDir )
	
	// Se estiver True. Atribuir para False.
	If lMV_WFIMAGE
		PutMv( 'MV_WFIMAGE', .F. )
	Endif

	// Contas de E-Mails do Workflow 
	If WF7->( dbSeek( xFilial( 'WF7' ) + cWF7_PASTA ) )
		cWF7_REMETE := Capital( Lower( RTrim( WF7->WF7_REMETE ) ) )
		cWF7_ENDERE := RTrim( WF7->WF7_ENDERE )
	Else
		cWF7_REMETE := 'cobrancaautomatica@certisign.com.br'
		cWF7_ENDERE := cWF7_REMETE
	Endif

	// Capturar o primeiro registro selecionado.
	nP := AScan( aDADOS, {|p| p[ 1 ] == MRK } )
	
	// Capturar a chave completa deste elemento.
	cKey := aDADOS[ nP, nE1_CLIENTE ] + aDADOS[ nP, nE1_LOJA ]
	
	ProcRegua(Len(aDADOS))
	
	// ler todos os elementos do vetor.
	While nLoop <= Len( aDADOS ) .AND. lContinua
		IncProc()
		If lFirst
			lFirst := .F.
			cSaveFile := CriaTrab( NIL , .F. ) + '.htm'
			
			//---------------------------------
			// Ajuste para carta de retratação.
			//---------------------------------
			oHTML := TWFHTML():New( cMV_461HTML )
			
			oHTML:ValByName( 'cCliente', aDADOS[ nLoop, nA1_NOME ] )
			
			If .NOT. Empty( aDADOS[ nLoop, nA1_CONTATO ] )
				oHTML:ValByName( 'cContato', 'A/C ' + aDADOS[ nLoop, nA1_CONTATO ] )
			Else
				oHTML:ValByName( 'cContato', 'A/C Contas a pagar.' )
			Endif
			
			oHTML:ValByName( 'cProtocolo', Left( cSaveFile, At( '.', cSaveFile )-1 ) )
			
			If oHTML:ExistField( 1, 'WFMailTo' )
				oHTML:ValByName( 'WFMailTo',  cWF7_ENDERE )
			Endif
			
			cXCLI := aDADOS[ nLoop, nA1_NOME ]
			
		Endif
		
		AAdd( oHTML:ValByName( 'a.Titulo' ) , aDADOS[ nLoop, nE1_NUM ] )
		AAdd( oHTML:ValByName( 'a.Emissao' ), aDADOS[ nLoop, nE1_EMISSAO ] )
		AAdd( oHTML:ValByName( 'a.Vencto' ) , aDADOS[ nLoop, nE1_VENCTO ] )
		AAdd( oHTML:ValByName( 'a.Valor' )  , LTrim( TransForm( aDADOS[ nLoop, nE1_VALOR ], '@E 999,999,999.99' ) ) )

		If nLoop < Len( aDADOS )
			nLoop++ 
		Else
			lContinua := .F.
		Endif
		
		aAdd( aItens, 'Título: ' + aDADOS[ nLoop, nE1_NUM ] + ', vencimento: ' + dToC(aDADOS[ nLoop, nE1_VENCTO ]))
		// Se mudou a chave ou não continuar com o laço, salvar o arquivo HTML.
		If cKey <> aDADOS[ nLoop, nE1_CLIENTE ] + aDADOS[ nLoop, nE1_LOJA ] .OR. .NOT. lContinua
			cPath := cDir + cSaveFile
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
			
			// enviar o e-mail.
			If A460EnvMail( cBody, aDADOS[ nLoop ] )
				aAdd( aMsgOk, 'E-mail enviado com sucesso para o cliente: ' + cXCLI  )
				If Len(aItens) > 0
					For nL := 1 To Len( aItens )
						aAdd( aMsgOk, aItens[nL])
					Next nL
				EndIF
				aAdd( aMsgOk, '' )
			EndIf
			
			lFirst := .T.
			cBody  := ''
			aItens := {}
			cKey   := aDADOS[ nP, nE1_CLIENTE ] + aDADOS[ nP, nE1_LOJA ]
		Endif
	End

	If lMV_WFIMAGE
		PutMv( 'MV_WFIMAGE', .T. )
	Endif
Return

//-------------------------------------------------------------------------
// Rotina | A460EnvMail  | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para enviar o e-mail aos clientes.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460EnvMail( cBody, aEMAIL )
	Local lOk := .T.
	Local lSendOk := .T.
		
	Local cOk := ''
	Local cError := ''
	Local cSubject := 'CERTISIGN - Lembrete de Pagamento.'
	
	Local cMailCliente := RTrim( aEMAIL[ nA1_EMAIL ] )
	
	// Caso o parâmetro FAKE esteja habilitado com um endereço qualquer para testes e simiulações, modificar o endereço de e-mail do cliente.
	If l460Auto
		If cMV_FKMAIL == 'MV_FKMAIL'
			cMV_FKMAIL := GetMV( cMV_FKMAIL )
		Endif
	Endif
	
	If .NOT. Empty( cMV_FKMAIL )
		cMailCliente := cMV_FKMAIL
	Endif
	
	CONNECT SMTP SERVER cMailServer ACCOUNT cLogin PASSWORD cMailSenha TIMEOUT nTimeOut RESULT lOk
	If lOk
		If lSMTPAuth
			lOk := MailAuth( cLogin, cMailSenha )
			If .NOT. lOk
				GET MAIL ERROR cError
				cError := 'STATUS: ' + cError
			Endif
		Endif
		If lOk
			SEND MAIL FROM cWF7_REMETE TO cMailCliente SUBJECT cSubject BODY cBody RESULT lSendOk
		  	MailFormatText( .F. )
			If .NOT. lSendOk
				GET MAIL ERROR cError
				cError += 'STATUS: NÃO FOI POSSÍVEL ENVIAR E-MAIL, VERIFIQUE: ' + cError
			Else
				cOk := 'STATUS: EMAIL ENVIADO COM SUCESSO.'
			Endif
		Else
			cError := 'NÃO FOI POSSÍVEL AUTENTICAR COM O LOGIN E SENHA NO SERVIDOR: ' + cError
		Endif
	Else
		cError := 'NÃO FOI POSSÍVEL CONECTAR NO SERVIDOR DE ENVIO DE E-MAIL.'
	Endif 
	DISCONNECT SMTP SERVER
	
	// Montar a mensagem de log.
	If .NOT. Empty( cError )
		If l460Auto
			AAdd( aMsgLog, cError )
		Else
			MsgAlert( cError )
		Endif
		lOk := .F.
	Endif
	
	If .NOT. Empty( cOk ) .And. .NOT. l460Auto
		MsgInfo( cOk, cSubject )
	EndIf
Return ( lOk )

//-------------------------------------------------------------------------
// Rotina | A460MailLog  | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para o envio de email com o log gerado no processo JOB.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460MailLog()
	Local cArqLog := ''
	Local cBarra := Iif( IsSrvUnix(), '/', '\' )
	Local cDir := cBarra + 'lembretcobr' + cBarra
	Local nHdl := 0
	Local nI := 0
	Local cMensagem := ''
	Local cMailTo := ''
	Local cEmail := GetMv( cMV_460LOG )
	Local cMV_460MAIL := 'MV_460MAIL'
	Local cMsgInfo := 'Prezados, ' + CRLF + CRLF +'Em anexo o arquivo de LOG com o(s) cliente(s) que receberam o lembrete de pagamento na data presente.'
	
	If .NOT. GetMv( cMV_460MAIL, .T. )
		CriarSX6( cMV_460MAIL, 'C', 'EMAIL PARA INFORMAR O LOG DE RESULTADO DO PROCESSAMENTO PARA O FINANCEIRO. Rotina CSFA460.prw',;
		                            'aparaujo@certisign.com.br;regiane.melo@certisign.com.br;jeneffer.robis@certisign.com.br' )
	Endif
		
	If Len( aMsgLog ) == 0
		ConOut('NÃO HÁ MENSAGENS DE LOG NA ROTINA CSFA460 [DATA: '+Dtoc(MsDate())+' HORA: '+Time()+']')
	Else
		// Montar o arquvo texto com os log para enviar por email.
		cArqLog := CriaTrab( NIL , .F. ) + '.txt'
		nHdl := FCreate( cDir + cArqLog )
		For nI := 1 To Len( aMsgLog )
			FWrite( nHdl, aMsgLog[ nI ] + CRLF )
		Next nI
		FClose( nHdl )
		MailFormatText( .T. )
		If .NOT. FSSendMail( cEmail, 'LOG - LEMBRETE DE PAGAMENTO - CSFA460', cMensagem, ( cDir + cArqLog ) )
			ConOut('E-MAIL DE LOG NÃO ENVIADO COM SUCESSO CONFORME ENDEREÇO REGISTRADO NO PARÂMETRO MV_460LOG: ' + cEmail )
		Else
			ConOut('E-MAIL DE LOG ENVIADO COM SUCESSO CONFORME ENDEREÇO REGISTRADO NO PARÂMETRO MV_460LOG: ' + cEmail )
		Endif
		MailFormatText( .F. )
	Endif
	
	If .NOT. Empty( aMsgOk )
		cMailTo := GetMV( cMV_460MAIL )
		// Montar o arquvo texto com os log para enviar por email.
		cArqLog := CriaTrab( NIL , .F. ) + '.txt'
		nHdl := FCreate( cDir + cArqLog )
		For nI := 1 To Len( aMsgOk )
			FWrite( nHdl, aMsgOk[ nI ] + CRLF )
		Next nI
		FClose( nHdl )
		MailFormatText( .T. )
		If .NOT. FSSendMail( cMailTo, 'LOG - LEMBRETE DE PAGAMENTO - CSFA460', cMsgInfo, ( cDir + cArqLog ) )
			ConOut('E-MAIL DE LOG NÃO ENVIADO COM SUCESSO CONFORME ENDEREÇO REGISTRADO NO PARÂMETRO MV_460MAIL: ' + cMailTo )
		Else
			ConOut('E-MAIL DE LOG ENVIADO COM SUCESSO CONFORME ENDEREÇO REGISTRADO NO PARÂMETRO MV_460MAIL: ' + cMailTo )
		Endif
		MailFormatText( .F. )
	EndIf
Return

//-------------------------------------------------------------------------
// Rotina | A460PodeUsar | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para criticar se a rotina poderá ser utilizada.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460PodeUsar()
	Local lRet := .T. 
	
	If .NOT. GetMv( cMV_460ANTE, .T. )
		lRet := .F.
		MsgAlert('Por favor, executar a rotina de update de dicionário de dados U_A460UpdA()', cCadastro )
	Else
		cMV_460ANTE := GetMv( cMV_460ANTE, .F. )
		If Empty( cMV_460ANTE )
			lRet := .F.
			MsgAlert('Parâmetro MV_460ANTE sem dias de antecdência para processamento.',cCadastro)
		Endif
	Endif
	
	If lRet
		If .NOT. GetMv( cMV_460HTML, .T. )
			lRet := .F.
			MsgAlert('Por favor, executar a rotina de update de dicionário de dados U_A460UpdA()', cCadastro )
		Else
			cMV_460HTML := GetMv( cMV_460HTML, .F. )
			If .NOT. File( cMV_460HTML )
				lRet := .F.
				MsgAlert('Não localizado o arquivo modelo HTML do parâmetro MV_460HTML.',cCadastro)
			Endif	
		Endif
	Endif
	
	If lRet 
		cMV_FKMAIL := GetMv( cMV_FKMAIL )
	Endif
	
	If lRet
		cMV_460LOG := GetMv( cMV_460LOG, .F. )
		If Empty( cMV_460LOG )
			lRet := .F.
			MsgAlert('Parâmetro MV_460LOG sem endereço de e-mail.',cCadastro)
		Endif
	Endif
Return( lRet )

//-------------------------------------------------------------------------
// Rotina | A460CriaSX1 | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para criar o grupo de perguntas (SX1).
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A460CriaX1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}
	
	aAdd( aP, { 'Código do cliente?' ,'C', 6,0,'G','','SA1','','','','','',''})
	aAdd( aP, { 'Loja do cliente?'   ,'C', 2,0,'G','','','','','','','',''})
	aAdd( aP, { 'Vencimento de?'     ,'D', 8,0,'G','','','','','','','',''})
	aAdd( aP, { 'Vencimento Ate?'    ,'D', 8,0,'G','(mv_par04>=mv_par03)','','','','','','',''})
	
	aAdd( aHelp, { '','' } )
	aAdd( aHelp, { '','' } )
	aAdd( aHelp, { '','' } )
	aAdd( aHelp, { '','' } )

	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := 'mv_par'+cSeq
		cMvCh  := 'mv_ch'+IIF(i<=9,Chr(i+48),Chr(i+87))
		PutSx1(cPerg,;
		cSeq,;
		aP[i,1],aP[i,1],aP[i,1],;
		cMvCh,;
		aP[i,2],;
		aP[i,3],;
		aP[i,4],;
		0,;
		aP[i,5],;
		aP[i,6],;
		aP[i,7],;
		'',;
		'',;
		cMvPar,;
		aP[i,8],aP[i,8],aP[i,8],;
		aP[i,13],;
		aP[i,9],aP[i,9],aP[i,9],;
		aP[i,10],aP[i,10],aP[i,10],;
		aP[i,11],aP[i,11],aP[i,11],;
		aP[i,12],aP[i,12],aP[i,12],;
		aHelp[i],;
		{},;
		{},;
		'')
	Next i
Return