#Include 'Protheus.ch'
#Include 'TbiConn.ch'

#DEFINE MRK   'NGCHECKOK.PNG'
#DEFINE NOMRK 'NGCHECKNO.PNG'

//-------------------------------------------------------------------------
// Rotina | CSFA460      | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina lembrete de pagamento.
//-------------------------------------------------------------------------
// Update | Rafael Beghini | Data: 18/06/2015
//        | Acrescentado Vencimento De/Ate; Retirado ramal do Html;
//        | Rotina para enviar o LOG de processamento ao Financeiro
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function CSFA460( aParam )
	Private l460Auto := (Select('SX6')==0)
	Private aCOLS  	 := {}
	Private aHeader  := {}
	Private aMsgOk   := {}
	Private aItens   := {}
	
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
	Private 	nE1_RECNO   := 0
	Private 	nE1_NFELETR := 0
	
	If l460Auto
		// Executar no modo automático.
		CSFA461( aParam )
	Else
		// Executar no modo usuário.
		CSFA462()
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
Static Function CSFA461( aParam )
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
	cSQL += "       A1_CONTATO, "
	cSQL += "       SE1.R_E_C_N_O_ AS E1_RECNO, "
	cSQL += "       E1_NFELETR "
	cSQL += "FROM   "+RetSqlName("SE1")+" SE1 "
	cSQL += "       INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cSQL += "               ON A1_FILIAL = "+ValToSql(xFilial("SA1"))+" "
	cSQL += "              AND SA1.A1_COD = SE1.E1_CLIENTE "
	cSQL += "              AND SA1.A1_LOJA = SE1.E1_LOJA "
	cSQL += "              AND SA1.D_E_L_E_T_ = ' ' "
   cSQL += "       INNER JOIN "+RetSqlName("SC5")+" SC5 "
   cSQL += "               ON C5_FILIAL = "+ValToSql(xFilial("SC5"))+" "
   cSQL += "              AND C5_NUM = E1_PEDIDO "
   cSQL += "              AND C5_XORIGPV IN ('1','4','6') "
   cSQL += "              AND SC5.D_E_L_E_T_ = ' '	"
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
	cSQL += "       E1_PEDIDO, "
	cSQL += "       A1_EMAIL, "
	cSQL += "       A1_CONTATO, "
	cSQL += "       SE1.R_E_C_N_O_ AS E1_RECNO, "
	cSQL += "       E1_NFELETR "
	cSQL += "FROM   "+RetSqlName("SE1")+" SE1 "
	cSQL += "       INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cSQL += "               ON A1_FILIAL = "+ValToSql(xFilial("SA1"))+" "
	cSQL += "              AND SA1.A1_COD = SE1.E1_CLIENTE "
	cSQL += "              AND SA1.A1_LOJA = SE1.E1_LOJA "
	cSQL += "              AND SA1.D_E_L_E_T_ = ' ' "
   cSQL += "       left JOIN "+RetSqlName("SC5")+" SC5 "
   cSQL += "               ON C5_FILIAL = "+ValToSql(xFilial("SC5"))+" "
   cSQL += "              AND C5_NUM = E1_PEDIDO "
   cSQL += "              AND C5_XORIGPV IN ('1','4','6') "
   cSQL += "              AND SC5.D_E_L_E_T_ = ' '	"
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
	
	//MEMOWRITE("C:\Protheus\TESTE.sql",cSQL)
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
	Local aCPO := {'A1_NOME','E1_PREFIXO','E1_NUM','E1_PARCELA','E1_TIPO','E1_CLIENTE','E1_LOJA','E1_EMISSAO','E1_VENCTO','E1_VENCREA','E1_VALOR','A1_EMAIL','A1_CONTATO','E1_NFELETR'}
	
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
	nE1_NFELETR := GdFieldPos( 'E1_NFELETR' )
	nE1_RECNO   := 16//GdFieldPos( 'E1_RECNO' )
	//nE1_NFELETR := 17
	
	aCOLS := {}
	While .NOT. (cTRB)->( EOF() )
		(cTRB)->( AAdd( aCOLS, {cImgMrk,A1_NOME,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR,A1_EMAIL,A1_CONTATO,E1_NFELETR,E1_RECNO,.F.} ) )
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
	Local cSaveFile := ''
	Local cSaveFile2 := ''
	Local nP := 0
	Local nL := 0
	Local aDADOS := {}
	Local aTitMark := {}
	
	Local lMV_WFIMAGE := GetMv( 'MV_WFIMAGE', , .F. ) // Parâmetro do padrão que controla imagens em e-mails.
	Local cBarra := Iif( IsSrvUnix(), '/', '\' )
	Local cDir := cBarra + 'lembretcobr' + cBarra
	Local cPath := ''
	Local cPath2 := ''
	Local cBody := ''
	Local cBody2 := ''
	Local cWF7_PASTA  := 'COBRANCAAUTOMATICA'
	Local cXCLI := ''
	Local cNota	:= ''
		
	Private cWF7_ENDERE := ''
	Private cWF7_REMETE := ''
	Private cMailServer := GetMv('MV_RELSERV')
	Private cLogin      := GetMv('MV_CACNT')
	Private cMailSenha  := GetMv('MV_CAPSW')
	Private lSMTPAuth   := GetMv('MV_RELAUTH')
	Private nTimeOut    := GetMv('MV_RELTIME',,120)
		
	AEval( aArray, {|e| Iif( e[ 1 ] == MRK, AAdd( aDADOS, AClone( e ) ), NIL ) } )

	AEval( aArray, {|e| Iif( e[ 1 ] == MRK, AAdd( aTitMark, { e[ nE1_CLIENTE ], e[ nE1_RECNO ] } ), NIL ) } )

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
			
			oHTML := TWFHTML():New( IIF(l460Auto, GetMV( cMV_460HTML ), cMV_460HTML) )
			
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
		
		cNota := IiF( Empty( aDADOS[nLoop,nE1_NFELETR] ), aDADOS[nLoop, nE1_NUM], aDADOS[nLoop, nE1_NFELETR] ) 
		//AAdd( oHTML:ValByName( 'a.Titulo' ) , aDADOS[ nLoop, nE1_NUM ] )
		AAdd( oHTML:ValByName( 'a.Titulo' ) , cNota )
		AAdd( oHTML:ValByName( 'a.Emissao' ), aDADOS[ nLoop, nE1_EMISSAO ] )
		AAdd( oHTML:ValByName( 'a.Vencto' ) , aDADOS[ nLoop, nE1_VENCTO ] )
		AAdd( oHTML:ValByName( 'a.Valor' )  , LTrim( TransForm( aDADOS[ nLoop, nE1_VALOR ], '@E 999,999,999.99' ) ) )

		cNota := ''
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
			
			cBody2:= u_CSMODHTM(cbody,cdir) // inclui o email no modelo padrão (cabecalho e rodapé)
			
			// enviar o e-mail
			If A460EnvMail( cBody2, aDADOS[ nLoop ] )
				aAdd( aMsgOk, 'E-mail enviado com sucesso para o cliente: ' + cXCLI  )
				If Len(aItens) > 0
					For nL := 1 To Len( aItens )
						aAdd( aMsgOk, aItens[nL])
					Next nL
				EndIF
				aAdd( aMsgOk, '' )
				A460TeleCob(aTitMark)
				aTitMark := {}
			EndIf
			
			lFirst := .T.
			cBody  := ''
			cBody2  := ''
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
	Local lServerTst := GetServerIP() $ GetMv( 'MV_610_IP', .F. )
	Local cSubject := IIF( lServerTst, "[TESTE] ", "" ) + 'CERTISIGN - Lembrete de Pagamento.'
	Local cWF7_COPIA := GetMv('MV_BCCLEB')
	
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
			//SEND MAIL FROM cWF7_REMETE TO cMailCliente SUBJECT cSubject BODY cBody RESULT lSendOk

			  SEND MAIL FROM cWF7_REMETE TO cMailCliente BCC cWF7_COPIA SUBJECT cSubject BODY cBody RESULT lSendOk	

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

//-------------------------------------------------------------------------
// Rotina | A460UpdA     | Autor | Robson Gonçalves     | Data | 12.11.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para criar os recursos no dicionário de dados.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A460UpdA(aParam)
	Local cMV_460ANTE := 'MV_460ANTE'
	Local cMV_460HTML := 'MV_460HTML'
	Local cMV_WSMOD2  := 'MV_WSMOD2'	
	Local cMV_FKMAIL  := 'MV_FKMAIL'
	Local cMV_460LOG  := 'MV_460LOG'
	Local cEmp := Iif( aParam == NIL, '01', aParam[ 1 ] ) 
	Local cFil := Iif( aParam == NIL, '02', aParam[ 2 ] ) 
	
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'TMK' TABLES 'SA1','SE1','SU5'

	If MsgYesNo( 'Confirma a manutenção no dicionário de dados?','CSFA460 | A460UpdA' )
		If .NOT. GetMv( cMV_460ANTE, .T. )
			CriarSX6( cMV_460ANTE, 'N', 'DIAS DE ANTECEDENCIA AO VENCIMENTO DOS TÍTULOS PARA O LEMBRETE DE PAGAMENTO. Rotina CSFA460.prw', '10' )
		Endif
		
		If .NOT. GetMv( cMV_460HTML, .T. )
			CriarSX6( cMV_460HTML, 'C', 'NOME DO ARQUIVO HTML PARA GERAR CORPO DE E-MAIL A SER ENVIADO AOS CLIENTES. Rotina CSFA460.prw', 'csfa460.htm' )
		Endif

		If .NOT. GetMv( cMV_FKMAIL, .T. )
			CriarSX6( cMV_FKMAIL, 'C', 'EMAIL PARA SUBSTITUIR ENDERECO DO CLIENTE E DO VENDEDOR. UTILIZADO PARA SIMULACAO/TESTE.', '' )
		Endif
		
		If .NOT. GetMv( cMV_460LOG, .T. )
			CriarSX6( cMV_460LOG, 'C', 'EMAIL PARA INFORMAR O LOG DE RESULTADO DO PROCESSAMENTO. Rotina CSFA460.prw', 'sistemascorporativos@certisign.com.br' )
		Endif
		If .NOT. GetMv( cMV_WSMOD2, .T. )
			CriarSX6( cMV_WSMOD2, 'C', 'NOME DO ARQUIVO MODELO HTML PARA GERAR CABECALHO E RODAPÉ DE E-MAIL A SER ENVIADO AOS CLIENTES', 'Modelo_2016.html' )
		Endif
		MsgYesNo( 'finalizado com sucesso !! ','CSFA460 | A460UpdA' )
		 
	Endif
		
Return

//---------------------------------------------------------------------------------
// Rotina | A210TeleCob | Autor | Rafael Beghini               | Data | 18.09.2018
//---------------------------------------------------------------------------------
// Descr. | Rotina para gravar o registro na rotina do TeleCobrança
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A460TeleCob( aTitMark )
	Local nI 			:= 0
	Local cTime       	:= Time()
	Local cU6_CODIGO  	:= ''
	Local cU4_LISTA   	:= ''
	Local cU5_CODCONT	:= ''
	Local cACF_MOTIVO	:= ''
	Local cACF_OBS		:= 'Processado através da rotina CSFA460'
	Local nStack      	:= GetSX8Len()
	Local aSE1        	:= {}
	Local cACF_CODIGO 	:= ''
	Local cOperador		:= ''
	Local lRet			:= .T.

	// Verificar se o parâmetro existe, do contrário cria-lo.
	cACF_MOTIVO := 'MV_460MOTI'
	
	If .NOT. GetMv( cACF_MOTIVO, .T. )
		CriarSX6( cACF_MOTIVO, 'C', 'CODIGO DO MOTIVO TELECOBRANCA PELO LEMBRETE PAGTO CSFA460.prw', '021760' )
	Endif
	
	cACF_MOTIVO := GetMv( 'MV_460MOTI', .F. )

	SU7->( dbSetOrder( 4 ) )
	If SU7->( dbSeek( xFilial( 'SU7' ) + __cUserId ) )
		If SU7->U7_TIPOATE $ '3|4' // 3=Telecobrança ou 4=todos.
			cOperador := SU7->U7_COD
		Else
			lRet := .F.
			MsgAlert('Operador ' + RTrim( SU7->U7_NOME ) + ' sem perfil para acesso ao Telecobrança.', cCadastro )
		Endif
	Else
		lRet := .F.
		MsgAlert('Usuário ' + Upper( RTrim( UsrRetName( __cUserId ) ) ) + ' não está cadastrado como operador do Telecobrança.', cCadastro )
	Endif

	// Posicionar no cliente.
	SA1->( dbSetOrder( 1 ) )
	SA1->( dbSeek( xFilial( 'SA1' ) + aTitMark[ 1,1 ] ) )
	cU5_CODCONT := RTrim( Left( SA1->A1_CONTFIN, 6 ) )	

	IF lRet
		// Ler todos os títulos.
		For nI := 1 To Len( aTitMark )
			// Posicionar no registro do títulos.
			SE1->( dbGoto( aTitMark[ nI, 2 ] ) )
			
			// Pesquisar para saber se o título já foi para o telecobrança.
			SK1->( dbSetOrder( 1 ) )
			If SK1->( dbSeek( xFilial( 'SK1' ) + SE1->( E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_FILIAL ) ) )
				SK1->( RecLock( 'SK1', .F. ) )
				SK1->K1_VENCTO  := SE1->E1_VENCTO
				SK1->K1_VENCREA := SE1->E1_VENCREA
				SK1->K1_NATUREZ := SE1->E1_NATUREZ
				SK1->K1_PORTADO := SE1->E1_PORTADO
				SK1->K1_SITUACA := SE1->E1_SITUACA 
				SK1->K1_SALDO   := SE1->E1_SALDO
				SK1->K1_SALDEC  := 100000 - SE1->E1_SALDO
				SK1->( MsUnLock() )
			Else
				SK1->( RecLock( 'SK1', .T. ) )
				SK1->K1_FILIAL  := xFilial('SK1')
				SK1->K1_PREFIXO := SE1->E1_PREFIXO
				SK1->K1_NUM     := SE1->E1_NUM
				SK1->K1_PARCELA := SE1->E1_PARCELA
				SK1->K1_TIPO    := SE1->E1_TIPO
				SK1->K1_OPERAD  := cOperador
				SK1->K1_VENCTO  := SE1->E1_VENCTO
				SK1->K1_VENCREA := SE1->E1_VENCREA
				SK1->K1_CLIENTE := SE1->E1_CLIENTE
				SK1->K1_LOJA    := SE1->E1_LOJA
				SK1->K1_NATUREZ := SE1->E1_NATUREZ
				SK1->K1_PORTADO := SE1->E1_PORTADO
				SK1->K1_SITUACA := SE1->E1_SITUACA 
				SK1->K1_SALDEC  := 100000 - SE1->E1_SALDO
				SK1->K1_FILORIG := SE1->E1_FILIAL
				SK1->K1_SALDO   := SE1->E1_SALDO
				SK1->( MsUnLock() )				
			Endif
			SE1->( AAdd( aSE1, { E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCTO, E1_VENCREAL, E1_VALOR } ) )
			
		Next nI
		
		If Len( aSE1 ) > 0
			cU4_LISTA := GetSXENum('SU4','U4_LISTA')	
			While GetSX8Len() > nStack
				ConfirmSX8()
			End
			
			SU4->( dbSetOrder( 1 ) )
			SU4->( RecLock( 'SU4', .T. ) )
			SU4->U4_FILIAL  := xFilial( 'SU4' )
			SU4->U4_TIPO    := '2' //1=Marketing;2=Cobrança;3=Vendas;4=Teleatendimento.
			SU4->U4_STATUS  := '2' //1=Ativa;2=Encerrada;3=Em Andamento
			SU4->U4_LISTA   := cU4_LISTA
			SU4->U4_DESC    := 'LISTA DE COBRANCA GERADA AUTOMATICAMENTE PELA ROTINA CSFA460'
			SU4->U4_DATA    := dDataBase
			SU4->U4_DTEXPIR := dDataBase
			SU4->U4_HORA1   := cTime
			SU4->U4_FORMA   := '1' //1=Voz;2=Fax;3=CrossPosting;4=Mala Direta;5=Pendencia;6=WebSite.
			SU4->U4_TELE    := '3' //1=Telemarkeing;2=Televendas;3=Telecobrança;4=Todos;5=Teleatendimento.
			SU4->U4_OPERAD  := cOperador
			SU4->U4_TIPOTEL := '4' //1=Residencial;2=Celular;3=Fax;4=Comercial 1;5=Comercial 2.
			SU4->U4_NIVEL   := '1' //1=Sim;2=Nao.
			SU4->U4_CODLIG  := ''
			SU4->U4_XDTVENC := dDataBase
			SU4->U4_XGRUPO  := SU7->( Posicione( 'SU7', 1, xFilial( 'SU7' ) + cOperador, 'U7_POSTO' ) )
			SU4->( MsUnLock() )
			
			cU6_CODIGO := GetSXENum('SU6','U6_CODIGO')
			While GetSX8Len() > nStack 
				ConfirmSX8()
			End
			
			SU6->( dbSetOrder( 1 ) )
			SU6->( RecLock( 'SU6', .T. ) )
			SU6->U6_FILIAL  := xFilial('SU6')
			SU6->U6_LISTA   := cU4_LISTA
			SU6->U6_CODIGO  := cU6_CODIGO
			SU6->U6_CONTATO := cU5_CODCONT
			SU6->U6_ENTIDA  := 'SA1'
			SU6->U6_CODENT  := SA1->( A1_COD + A1_LOJA ) //oGride:aCOLS[ 1, nE1_CLIENTE ] + oGride:aCOLS[ 1, nE1_LOJA ]
			SU6->U6_ORIGEM  := '2' //1=Lista;2=Manual;3=Atendimento.
			SU6->U6_DATA    := dDataBase
			SU6->U6_HRINI   := cTime
			SU6->U6_HRFIM   := cTime
			SU6->U6_STATUS  := '3' //1=Nao Enviado;2=Em uso;3=Enviado.
			SU6->U6_CODLIG  := ''
			SU6->U6_DTBASE  := dDataBase
			SU6->U6_CODOPER := cOperador
			SU6->( MsUnLock() )
		
			cACF_CODIGO := GetSXENum('ACF','ACF_CODIGO')
			While GetSX8Len() > nStack
				ConfirmSX8()
			End

			ACF->( dbSetOrder( 1 ) )
			ACF->( RecLock( 'ACF', .T. ) )
			ACF->ACF_FILIAL := xFilial( 'ACF' )
			ACF->ACF_CODIGO := cACF_CODIGO
			ACF->ACF_CLIENT := SA1->A1_COD //oGride:aCOLS[ 1, nE1_CLIENTE ]
			ACF->ACF_LOJA   := SA1->A1_LOJA //oGride:aCOLS[ 1, nE1_LOJA ]
			ACF->ACF_CODCON := cU5_CODCONT
			ACF->ACF_OPERAD := cOperador
			ACF->ACF_OPERA  := '2' //1=Receptivo;2=Ativo
			ACF->ACF_STATUS := '2' //1=Atendimento;2=Cobranca;3=Encerrado
			ACF->ACF_MOTIVO := cACF_MOTIVO
			ACF->ACF_DATA   := dDataBase
			ACF->ACF_PENDEN := dDataBase
			ACF->ACF_HRPEND := cTime
			ACF->ACF_INICIO := cTime
			ACF->ACF_FIM    := cTime
			ACF->ACF_DIASDA := CtoD('01/01/2045') - dDataBase
			ACF->ACF_HORADA := 86400 - ( ( Val( Substr( cTime, 1, 2 ) ) * 3600 ) + ( Val( Substr( cTime, 4, 2 ) ) * 60 ) + Val( Substr( cTime, 7, 2 ) ) )
			ACF->ACF_ULTATE := dDataBase
			ACF->ACF_LISTA  := cU4_LISTA
			ACF->ACF_PREVIS := dDataBase
			MSMM(,TamSx3("ACF_OBS")[1],,cACF_OBS,1,,,"ACF","ACF_CODOBS")
			ACF->( MsUnLock() )
		
			For nI := 1 To Len( aSE1 )
				ACG->( RecLock( 'ACG', .T. ) )
				ACG->ACG_FILIAL := xFilial( 'ACG' )
				ACG->ACG_CODIGO := cACF_CODIGO
				ACG->ACG_PREFIX := aSE1[ nI, 1 ]
				ACG->ACG_TITULO := aSE1[ nI, 2 ]
				ACG->ACG_TIPO   := aSE1[ nI, 4 ]
				ACG->ACG_STATUS := '2' //1=Pago;2=Negociado;3=Cartorio;4=Baixa;5=Abatimento
				ACG->ACG_DTVENC := aSE1[ nI, 5 ]
				ACG->ACG_DTREAL := aSE1[ nI, 6 ]
				ACG->ACG_VALOR  := aSE1[ nI, 7 ]
				ACG->ACG_RECEBE := aSE1[ nI, 7 ]
				ACG->ACG_VALREF := aSE1[ nI, 7 ]
				ACG->ACG_FILORI := xFilial( 'SE1' )
				ACG->ACG_PARCEL := aSE1[ nI, 3 ]
				ACG->ACG_DIASAT := dDataBase - aSE1[ nI, 5 ]
				ACG->( MsUnLock() )
			Next nI
		Endif
	EndIF
Return
