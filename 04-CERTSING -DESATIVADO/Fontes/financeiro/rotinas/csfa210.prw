//---------------------------------------------------------------------------------
// Rotina | CSFA210    | Autor | Robson Luiz - Rleg             | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para análise dos inadimplentes.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
#INCLUDE 'Protheus.ch'
#INCLUDE 'TbiConn.ch'

#DEFINE NOME_CLIENTE 2
#DEFINE EMAIL_CLIENT 5
#DEFINE DEBITO       6
#DEFINE CREDITO      7
#DEFINE SALDO        8
#DEFINE COD_LOJ_CLI  9
#DEFINE TOT_SELECT   10
#DEFINE EMAIL_VEND   11

#DEFINE PREFIXO      3
#DEFINE NUM          4
#DEFINE PARCELA      5
#DEFINE TIPO         6
#DEFINE EMISSAO      8
#DEFINE VENCTO       9
#DEFINE VALOR        10
#DEFINE ATRASO       11
#DEFINE COD_LOJ_TIT  12
#DEFINE SERIE_TIT    13
#DEFINE ENV_MAIL     14
#DEFINE E1_REC_NO    15
#DEFINE DT_MAIL      16
#DEFINE DT_2MAIL     17
#DEFINE NFELETR      18

#DEFINE DOC_NF       1
#DEFINE SERIE_NF     2
#DEFINE COD_LOJ_NF   9

User Function CSFA210()
	Local oBmp
	Local oDlg
	Local oCobrar
	Local oImprimir
	Local oConsultar
	Local oFont 
	Local nOpc := 0
	Local cMensagem := ''
	Private cMV_FKMAIL := 'MV_FKMAIL'
	Private l210Query := .F. 
	Private cCadastro := 'Análise dos inadimplentes'
	If A210CanUse()
		SetKey( VK_F12 , {|| l210Query := MsgYesNo('Exportar a string da query principal?',cCadastro ) } )
		cMensagem := 'Esta rotina apresenta os títulos vencidos e possibilita o envio de e-mail para cobrança.' + CRLF + CRLF
		cMensagem += 'Também é possível gerar o relatório dos e-mails enviados durante um determinado período' 
		cMensagem += 'e consultar o corpo do e-mail enviado para o cliente e vendedor.'                         + CRLF + CRLF
		cMensagem += 'Por favor, para prosseguir, clique no botão da opção desejada.'
		DEFINE FONT oFont NAME 'MS Sans Serif' SIZE 0, -9
		DEFINE MSDIALOG oDlg FROM  0,0 TO 220,500 TITLE cCadastro PIXEL
			@ -15,-3 BITMAP oBmp RESNAME 'IMPORT.PNG' oF oDlg SIZE 75,130 NOBORDER WHEN .F. PIXEL
			@ 11,70 TO 12,250 LABEL '' OF oDlg PIXEL
			@ 16,70 SAY cMensagem OF oDlg PIXEL SIZE 180,180 FONT oFont
			@ 92,70 TO 93,250 LABEL '' OF oDlg PIXEL
			@ 96,081 BUTTON oCobrar    PROMPT 'Cobrar'    SIZE 40,11 PIXEL OF oDlg ACTION A210Param()
			@ 96,124 BUTTON oConsultar PROMPT 'Consultar' SIZE 40,11 PIXEL OF oDlg ACTION A210Consult()
			@ 96,167 BUTTON oImprimir  PROMPT 'Imprimir'  SIZE 40,11 PIXEL OF oDlg ACTION A210Imp()
			@ 96,210 BUTTON oSair      PROMPT 'Sair'      SIZE 40,11 PIXEL OF oDlg ACTION oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTER
		SetKey( VK_F12 , {|| .T. } )
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A210Consult | Autor | Robson Luiz - Rleg            | Data | 15/08/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para consultar os títulos que foram cobrados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Consult()
	Private cCadastro := 'Títulos a Receber Notificados de Cobrança'
	Private aRotina := {}	
	AAdd( aRotina, { 'Pesquisar' , 'AxPesqui' , 0, 1 } )
	AAdd( aRotina, { 'Visualizar', 'AxVisual' , 0, 2 } )
	dbSelectArea( 'SZT' )
	dbSetOrder( 1 )
	MBrowse( , , , , 'PAM' )
Return

//---------------------------------------------------------------------------------
// Rotina | A210CanUse | Autor | Robson Luiz - Rleg             | Data | 25/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para verificar se há a infra-estrutura necessário para rodar.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210CanUse()
	Local lRet := .T.
	
	Local nI := 0
	Local nJ := 0
	
	Local aSX2 := {}
	Local aSX3 := {}
	Local aSIX := {}
	
	If SE1->( FieldPos( 'E1_QTDMAIL' )==0 .Or. FieldPos( 'E1_DTMAIL' )==0 .Or. FieldPos( 'E1_DT2MAIL' )==0)
		lRet := .F.
		MsgAlert( 'É preciso executar o update U_UPD210 para utilizar esta rotina.', cCadastro )
	Endif
	
	If lRet
		If .NOT. ExisteSX6( cMV_FKMAIL )
			CriarSX6( cMV_FKMAIL, 'C', 'EMAIL PARA SUBSTITUIR ENDERECO DO CLIENTE E DO VENDEDOR. UTILIZADO PARA SIMULACAO/TESTE.', '' )
		Endif
		cMV_FKMAIL := GetMv( cMV_FKMAIL )
		
		A210SXB()
		
		A210Dic( @aSX2, @aSX3, @aSIX )
		
		SX2->( dbSetOrder( 1 ) )
		If .NOT. SX2->( dbSeek( aSX2[ 1, 1 ] ) )
			SX2->( RecLock( 'SX2', .T. ) )
			For nI := 1 To Len( aSX2[ 1 ] )
				SX2->( FieldPut( nI, aSX2[ 1, nI ] ) )
			Next nI
			SX2->( MsUnLock() )
		Endif
		
		SX3->( dbSetOrder( 2 ) )
		For nI := 1 To Len( aSX3 )
			If .NOT. SX3->( dbSeek( aSX3[ nI, 3 ] ) )
				SX3->( RecLock( 'SX3', .T. ) )
				For nJ := 1 To Len( aSX3[ nI ] )
					SX3->( FieldPut( nJ, aSX3[ nI, nJ ] ) )
				Next nJ
				SX3->( MsUnLock() )
			Endif
		Next nI
		
		SIX->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aSIX )
			If .NOT. SIX->( dbSeek( aSIX[ nI, 1 ] + aSIX[ nI, 2 ] ) )
				SIX->( RecLock( 'SIX', .T. ) )
				For nJ := 1 To Len( aSIX[ nI ] )
					SIX->( FieldPut( nJ, aSIX[ nI, nJ ] ) )
				Next nJ
				SIX->( MsUnLock() )
			Endif
		Next nI
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A210Param  | Autor | Robson Luiz - Rleg             | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina de parâmetros de processamento.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Param()
	Local aPar := {}
	Local aRet := {}
	Local aNotif := {'Não','Sim'}
	
	Private c210Canal := ''
	Private c210CliDe := ''
	Private c210LojDe := ''
	Private c210CliAte := ''
	Private c210Lojate := ''
	Private d210VencDe := Ctod( Space( 8 ) )
	Private d210VencAte := Ctod( Space( 8 ) )
	Private n210VlrDe := 0
	Private n210VlrAte := 0
	Private n210Notif := 0
	
	AAdd( aPar, { 1, 'Canal de venda (*=todos)', '*'+Space(Len(SA3->A3_XCANAL)-1),'','','SZ2'        , '', 50, .T. } )
	
	AAdd( aPar, { 1, 'Cliente de'        ,Space(Len(SA1->A1_COD))   ,'',''                    , 'CLI', '', 50, .F. } )
	AAdd( aPar, { 1, 'Cliente até'       ,Space(Len(SA1->A1_COD))   ,'','(mv_par03>=mv_par02)', 'CLI', '', 50, .T. } )

	AAdd( aPar, { 1, 'Loja de'           ,Space(Len(SA1->A1_LOJA))   ,'',''                   , ''   , '', 20, .F. } )
	AAdd( aPar, { 1, 'Loja até'          ,Space(Len(SA1->A1_LOJA))  ,'','(mv_par05>=mv_par04)', ''   , '', 20, .T. } )
	
	AAdd( aPar, { 1, 'Vencidos de'       ,Ctod(Space(8))            ,'',''                    , ''   , '', 50, .F. } )
	AAdd( aPar, { 1, 'Vencidos até'      ,Ctod(Space(8))            ,'','(mv_par07>=mv_par06)', ''   , '', 50, .T. } )
	
	AAdd( aPar, { 1, 'Valor do título de' ,0.00                     ,'@E 999,999,999.99','Positivo()','' , '', 60, .F. } )
	AAdd( aPar, { 1, 'Valor do título até',0.00                     ,'@E 999,999,999.99','Positivo().And.(mv_par09>=mv_par08)','' , '', 60, .T. } )
	
	AAdd( aPar, { 2, 'Filtrar notificados', 1, aNotif, 48, '', .F. } )
	
	If .NOT. ParamBox( aPar, 'Parâmetros de processamento',@aRet,,,,,,,,.T.,.T.)
		Return
	Endif
	
	If .NOT. Empty( cMV_FKMAIL )
		MsgAlert('PARÂMETRO PARA SUBSTITUIR E-MAIL DO CLIENTE E DO VENDEDOR HABILITADO. UTILIZADO PARA SIMULACAO/TESTE. '+cMV_FKMAIL,cCadastro+' - MV_FKMAIL' )
	Endif
	
	c210Canal   := aRet[ 1 ] 

	c210CliDe   := aRet[ 2 ]
	c210CliAte  := aRet[ 3 ]

	c210LojDe   := aRet[ 4 ]
	c210LojAte  := aRet[ 5 ]

	d210VencDe  := aRet[ 6 ]
	d210VencAte := aRet[ 7 ]

	n210VlrDe   := aRet[ 8 ]
	n210VlrAte  := aRet[ 9 ]
	
	n210Notif   := Iif( ValType( aRet[ 10 ] ) == 'N',aRet[ 10 ], AScan( aNotif, {|e| e==aRet[ 10 ] } ) )
	
	Processa( {|| A210Proc() }, cCadastro,'Aguarde, processando os dados...', .F. ) 	
Return

//---------------------------------------------------------------------------------
// Rotina | A210Proc   | Autor | Robson Luiz - Rleg             | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para buscar dados e montar os arrays.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Proc()
	Local cSQL := ''
	Local cTRB := ''
	Local cKeyCliente := ''
	
	Local nP := 0
	Local nElem := 0
	Local nReceber := 0
	Local nAbat := 0
	
	Private cPICT := '@E 999,999,999.99'
	Private aCliente := {}
	Private aTitulo  := {}
	
	Private cRET_ABAT := MVABATIM + '|' + MVPROVIS + '|' + MV_CRNEG + '|' + MVRECANT + '|PIS|COF|CSL|RA '
   
	cSQL := "SELECT A1_COD, " + CRLF
	cSQL += "       A1_LOJA, " + CRLF
	cSQL += "       A1_NOME, " + CRLF
	cSQL += "       A1_EST, " + CRLF
	cSQL += "       A1_DDD, " + CRLF
	cSQL += "       A1_TEL, " + CRLF
	cSQL += "       A1_EMAIL, " + CRLF
	cSQL += "       E1_PREFIXO, " + CRLF
	cSQL += "       E1_NUM, " + CRLF
	cSQL += "       E1_PARCELA, " + CRLF
	cSQL += "       E1_TIPO, " + CRLF
	cSQL += "       E1_NATUREZ, " + CRLF
	cSQL += "       E1_EMISSAO, " + CRLF
	cSQL += "       E1_VENCTO, " + CRLF
	cSQL += "       E1_VENCREA, " + CRLF
	cSQL += "       E1_VALOR, " + CRLF
	cSQL += "       E1_VEND1, " + CRLF
	cSQL += "       E1_SERIE, " + CRLF
	cSQL += "       E1_QTDMAIL, " + CRLF
	cSQL += "       E1_DTMAIL, " + CRLF
	cSQL += "       E1_DT2MAIL, " + CRLF
	cSQL += "       SE1.R_E_C_N_O_ AS E1_RECNO, " + CRLF
	cSQL += "       A3_EMAIL, " + CRLF
	cSQL += "       E1_NFELETR " + CRLF
	cSQL += "FROM   "+RetSqlName( "SE1" )+" SE1 " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName( "SA1" )+" SA1 " + CRLF
	cSQL += "               ON A1_FILIAL = "+ValToSql( xFilial( "SA1" ) )+" " + CRLF
	cSQL += "                  AND A1_COD = E1_CLIENTE " + CRLF
	cSQL += "                  AND A1_LOJA = E1_LOJA " + CRLF
	cSQL += "                  AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       LEFT JOIN "+RetSqlName( "SA3" )+" SA3 " + CRLF
	cSQL += "               ON A3_FILIAL = "+ValToSql( xFilial( "SA3" ) )+" " + CRLF
	cSQL += "               	AND A3_COD = E1_VEND1 " + CRLF
	If AllTrim( c210Canal ) == '*'
		cSQL += "               	AND A3_XCANAL BETWEEN '      ' AND 'zzzzzz' " + CRLF
	Else
		cSQL += "               	AND A3_XCANAL = "+ValToSql( c210Canal )+" " + CRLF
	Endif	
	cSQL += "                  AND SA3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  E1_FILIAL = "+ValToSql( xFilial("SE1") )+" " + CRLF
	cSQL += "       AND E1_CLIENTE BETWEEN "+ValToSql( c210CliDe )+" AND "+ValToSql( c210CliAte )+" " + CRLF
	cSQL += "       AND E1_LOJA BETWEEN "+ValToSql( c210LojDe )+" AND "+ValToSql( c210LojAte )+" " + CRLF
	cSQL += "       AND E1_VENCTO BETWEEN "+ValToSql( d210VencDe )+" AND "+ValToSql( d210VencAte )+" " + CRLF
	cSQL += "       AND E1_VALOR BETWEEN "+ValToSql( n210VlrDe )+" AND "+ValToSql( n210vlrAte )+" " + CRLF
	cSQL += "       AND E1_SALDO <> 0 " + CRLF
	cSQL += "       AND E1_PEDGAR = ' ' " + CRLF
	cSQL += "       AND E1_XNPSITE = ' ' " + CRLF
	cSQL += "       AND SE1.D_E_L_E_T_ = ' '  " + CRLF
	If n210Notif == 1 // Não
		cSQL += "       AND E1_QTDMAIL = 0 " + CRLF
		cSQL += "       AND E1_DTMAIL = "+ValToSql(Ctod(Space(8)))+" " + CRLF
	Elseif n210Notif == 2 // Sim
		cSQL += "       AND E1_QTDMAIL > 0 " + CRLF
		cSQL += "       AND E1_DTMAIL <> "+ValToSql(Ctod(Space(8)))+" " + CRLF
	Endif
	cSQL += "ORDER BY A1_COD, A1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO " + CRLF
	
   If l210Query
		A210Script( cSQL )   
   Endif

	cTRB := GetNextAlias()
	FWMsgRun(,{|| cSQL := ChangeQuery( cSQL ), PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	ProcRegua(0)
	While (cTRB)->( .NOT. EOF() )
		IncProc()
		
		cKeyCliente := (cTRB)->(A1_COD + A1_LOJA )
		nP := AScan( aCliente, {|p| p[ 9 ] == cKeyCliente } )
		
		If nP == 0
			(cTRB)->(AAdd( aCliente, {.F.,;
			RTrim(A1_NOME),;
			A1_EST,;
			Iif(Empty(A1_TEL),'',Iif(Empty(A1_DDD),'',RTrim(A1_DDD)+'-')+A1_TEL),;
			Lower(RTrim(A1_EMAIL)),;
			0,;
			0,;
			0,;
			A1_COD+A1_LOJA,;
			0,;
			Lower(RTrim(A3_EMAIL))}))
			
			nElem := Len( aCliente )
		Else
			nElem := nP
		Endif
				
		While (cTRB)->( .NOT. EOF() ) .And. (cTRB)->( A1_COD + A1_LOJA ) == cKeyCliente	
			(cTRB)->(AAdd( aTitulo, {.F.,;
			E1_QTDMAIL,;
			E1_PREFIXO,;
			E1_NUM,;
			E1_PARCELA,;
			E1_TIPO,;
			E1_NATUREZ,;
			E1_EMISSAO,;
			E1_VENCTO,;
			MsPadL( TransForm(E1_VALOR,cPICT), 100 ),;
			dDataBase-E1_VENCTO,;
			A1_COD+A1_LOJA,;
			E1_SERIE,;
			E1_QTDMAIL,;
			E1_RECNO,;
			E1_DTMAIL,;
			E1_DT2MAIL,;
			E1_NFELETR}))
			
			If (cTRB)->E1_TIPO $ cRET_ABAT
				nAbat += (cTRB)->(E1_VALOR)
			Else
				nReceber += (cTRB)->(E1_VALOR)
			Endif
			
			(cTRB)->( dbSkip() )
		End
		
		aCliente[ nElem, DEBITO  ] := MsPadL( TransForm(nReceber,cPICT), 100 )
		aCliente[ nElem, CREDITO ] := MsPadL( TransForm(nAbat,cPICT), 100 )
		aCliente[ nElem, SALDO   ] := MsPadL( TransForm(nReceber - nAbat,cPICT), 100 )
		
		nReceber := 0
		nAbat := 0
	End	
	(cTRB)->(dbCloseArea())
	
	A210Show()
Return

//---------------------------------------------------------------------------------
// Rotina | A210Show   | Autor | Robson Luiz - Rleg             | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para apresentar os dados e efetuar os controles visuais.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Show()
	Local nI := 0
	
	Local oDlg
	Local oWin1
	Local oWin2
	Local oFWLayer
	Local oSplitter
	Local oPnl1
	Local oPnl2
	Local oPnl3
	
	Local cMsg := 'Operação finalizada com sucesso.'
	Local cTitulo := ' - Abaixo a relação de clientes, seus títulos e o documento fiscal relativo ao título.'
	
	Local aC := {}
	Local aBtn := {}
	Local aAcoes := {}
	
	Local aHead_Cli := {}
	Local aHead_Tit := {}
	Local aHead_NF := {}
	
	Local aTam_Cli := {}
	Local aTam_Tit := {}
	Local aTam_NF := {}

	Local bClear := {|| A210Clear() }
	
	Private oLbx1
	Private oLbx2
	Private oLbx3 

	Private nCall := 0
	
	Private aDadosTit := {}
	Private aDadosNF := {}
	
	Private oMrk   := LoadBitmap(,'NGCHECKOK.PNG')
	Private oNoMrk := LoadBitmap(,'NGCHECKNO.PNG')
	
	Private oNoEnviado := LoadBitmap(,'IC_EMAIL.GIF')
	Private oEnviado   := LoadBitmap(,'IC_EMAILENVIADO.GIF')
	Private oAbatim    := LoadBitmap(,'IC_EXCLAMACAO.GIF')

	aCpoCli := {'','A1_NOME','A1_EST','A1_TEL','A1_EMAIL','E1_VALOR','E1_VALOR','E1_VALOR','D2_DOC','','',''}
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCpoCli )
		SX3->( dbSeek( aCpoCli[ nI ] ) )
		SX3->( AAdd( aTam_Cli, CalcFieldSize( X3_TIPO, X3_TAMANHO, X3_DECIMAL, X3_PICTURE, X3_TITULO ) ) )
	Next nI
	aTam_Cli[ 2 ] := aTam_Cli[ 2 ]/2
	aTam_Cli[ 5 ] := aTam_Cli[ 5 ]/3.5
	
	aCpoTit := {'','','E1_PREFIXO','E1_NUM','E1_PARCELA','E1_TIPO','E1_NATUREZ','E1_EMISSAO','E1_VENCTO','E1_VALOR','B5_EAN141','','E1_SERIE','E1_QTDMAIL','RECNO','E1_DTMAIL','E1_DT2MAIL',''}
	For nI := 1 To Len( aCpoTit )
		SX3->( dbSeek( aCpoTit[ nI ] ) )
		SX3->( AAdd( aTam_Tit, CalcFieldSize( X3_TIPO, X3_TAMANHO, X3_DECIMAL, X3_PICTURE, X3_TITULO ) ) )
	Next nI
	
	aCpoNF  := {'D2_DOC','D2_SERIE','D2_ITEM','D2_COD','B1_DESC','D2_QUANT','D2_PRCVEN','D2_TOTAL','',''}
	For nI := 1 To Len( aCpoNF )
		SX3->( dbSeek( aCpoNF[ nI ] ) )
		SX3->( AAdd( aTam_NF, CalcFieldSize( X3_TIPO, X3_TAMANHO, X3_DECIMAL, X3_PICTURE, X3_TITULO ) ) )
	Next nI
	
	aHead_Cli := {'x','Nome do cliente','Estado','Telefone','E-Mail','Acum.Débito','Acum.Crédito','Total (Deb - Cred)','Código+Loja','Selecionados',''}
	aHead_Tit := {'x','','Prefixo','Título','Parcela','Tipo','Natureza','Emissão','Vencimento','Valor','Dias de atraso  ','Código+Loja','Série','Enviado','RecNo','DT. 1º Envio','DT. Ult. Envio',''}
	aHead_NF  := {'Documento','Série','Item','Produto','Descrição','Quantidade','Unitário','Total','Código+Loja',''}
	
	AAdd(aAcoes,{'Pesquisar'     ,'{|| A210Pesq() }' })
	AAdd(aAcoes,{'Visual. N.F.'  ,'{|| A210VisNF() }' })
	AAdd(aAcoes,{'Enviar e-mail' ,'{|| Iif(A210Email(),(MsgInfo( cMsg, cCadastro ),oDlg:End()),NIL) }'})
	AAdd(aAcoes,{'Limpar seleção','{|| Iif(MsgYesNo("Desmarcar todos os títulos marcados?",cCadastro),Processa(bClear,"","",.F.),NIL) }'}) 
	AAdd(aAcoes,{'Resumo'        ,'{|| A210Resumo(.T.) }'}) 
	AAdd(aAcoes,{'Legenda'       ,'{|| A210Legenda() }'}) 
	AAdd(aAcoes,{'&Sair'         ,'{|| Iif(MsgYesNo("Deseja realmente sair da rotina?",cCadastro),oDlg:End(),NIL) }'})
	
	SetKey(VK_F5,&(aAcoes[1,2]))
	SetKey(VK_F6,&(aAcoes[2,2]))
	SetKey(VK_F7,&(aAcoes[3,2]))
	SetKey(VK_F8,&(aAcoes[4,2]))
	SetKey(VK_F9,&(aAcoes[5,2]))
	SetKey(VK_F10,&(aAcoes[6,2]))
	SetKey(VK_F12,&(aAcoes[7,2]))
	
	// [1] - propriedade do objeto
	// [2] - título do botão
	// [3] - função a ser executada quando acionado o botão
	// [4] - texto explicativo da funcionalidade da rotina
	AAdd(aBtn,{NIL,aAcoes[1,1],aAcoes[1,2],'<F5> Pesquisar cliente e títulos.'})
	AAdd(aBtn,{NIL,aAcoes[2,1],aAcoes[2,2],'<F6> Visualizar o documento fiscal de saída.'})
	AAdd(aBtn,{NIL,aAcoes[3,1],aAcoes[3,2],'<F7> Processar somente os itens selecionados para enviar e-mail.'})
	AAdd(aBtn,{NIL,aAcoes[4,1],aAcoes[4,2],'<F8> Limpar todos os itens selecionados.'})
	AAdd(aBtn,{NIL,aAcoes[5,1],aAcoes[5,2],'<F9> Resumo dos títulos selecionados.'})
	AAdd(aBtn,{NIL,aAcoes[6,1],aAcoes[6,2],'<F10> Legenda de título.'})
	AAdd(aBtn,{NIL,aAcoes[7,1],aAcoes[7,2],'<F12> Sair da rotina.'})

	aC := FWGetDialogSize( oMainWnd )

	DEFINE DIALOG oDlg TITLE '' OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)
		oDlg:lEscClose := .F.
		oFWLayer := FWLayer():New()
		
		oFWLayer:Init( oDlg, .F. )
		
		oFWLayer:AddCollumn( 'Col01', 10, .T. )
		oFWLayer:AddCollumn( 'Col02', 90, .F. )
		
		oFWLayer:SetColSplit( 'Col01', CONTROL_ALIGN_RIGHT,, {|| .T. } )
		
		oFWLayer:AddWindow('Col01','Win01','Ações'             ,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
		oFWLayer:AddWindow('Col02','Win02',cCadastro + cTitulo, 100,.F.,.T.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
		
		oWin1 := oFWLayer:GetWinPanel('Col01','Win01')
		oWin2 := oFWLayer:GetWinPanel('Col02','Win02')
		
		oSplitter := TSplitter():New( 1, 1, oWin2, 1000, 1000, 1 ) 
		oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnl1:= TPanel():New(1,1,' Painel 01',oSplitter,,,,,/*CLR_YELLOW*/,60,60)
		oPnl2:= TPanel():New(1,1,' Painel 02',oSplitter,,,,,/*CLR_HRED*/  ,60,60)
		oPnl3:= TPanel():New(1,1,' Painel 03',oSplitter,,,,,/*CLR_HRED*/  ,60,30)
		
		oPnl1:Align := CONTROL_ALIGN_ALLCLIENT
		oPnl2:Align := CONTROL_ALIGN_ALLCLIENT
		oPnl3:Align := CONTROL_ALIGN_ALLCLIENT

		For nI := 1 To Len(aBtn)
			aBtn[nI,1] := TButton():New(1,1,aBtn[nI,2],oWin1,&(aBtn[nI,3]),50,11,,,.F.,.T.,.F.,aBtn[nI,4],.F.,,,.F.)
			aBtn[nI,1]:Align := CONTROL_ALIGN_TOP
		Next nI
		
	   // Controle visual do cliente.
	   oLbx1 := TwBrowse():New(1,1,1000,1000,,aHead_Cli,,oPnl1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	   oLbx1:aColSizes := aTam_Cli
	   oLbx1:bChange := {|| A210SetTit() }
	   oLbx1:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx1:bLDblClick := {|| A210MrkCli() }
		
		// Controle visual do título.
	   oLbx2 := TwBrowse():New(1,1,1000,1000,,aHead_Tit,,oPnl2,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	   oLbx2:aColSizes := aTam_Tit
	   oLbx2:bChange := {|| A210SetNF() }
	   oLbx2:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx2:bLDblClick := {|| A210MrkTit() }
	   
	   // Apresentação dos dados do documento fiscal.
	   oLbx3 := TwBrowse():New(1,1,1000,1000,,aHead_NF,,oPnl3,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	   oLbx3:aColSizes := aTam_NF
	   oLbx3:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx3:bLDblClick := {|| A210VisNF() }
	   
	   A210Array()
	   oLbx1:Refresh()
	   oLbx1:SetFocus()
	ACTIVATE DIALOG oDlg CENTERED
Return

//---------------------------------------------------------------------------------
// Rotina | A210Legenda | Autor | Robson Luiz - Rleg            | Data | 25/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para mostrar a legenda de cores do títulos enviado cobrnaça.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Legenda()
	Local aCor := {}

	aAdd( aCor, { 'IC_EMAIL.GIF'        , 'Nenhum e-mail enviado.' } )
	aAdd( aCor, { 'IC_EMAILENVIADO.GIF' , 'Já houve envio de e-mail.' } )
	aAdd( aCor, { 'IC_EXCLAMACAO.GIF'   , 'Retenção/Abatimento/Antecipação/Provisório' } )

	BrwLegenda( cCadastro, 'Legenda do registro', aCor )
Return

//---------------------------------------------------------------------------------
// Rotina | A210MrkCli | Autor | Robson Luiz - Rleg             | Data | 24/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para marcar o cliente e seus títulos.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210MrkCli()
	Local cStatus := ''
	Local nI := 0
	Local nValor := 0
	If A210TemMail( aCliente[ oLbx1:nAt, EMAIL_CLIENT ] ) .And. A210VldMail( aCliente[ oLbx1:nAt, EMAIL_CLIENT ] )	
		For nI := 1 To Len( aDadosTit )
			If .NOT. (aDadosTit[ nI, TIPO ] $ cRET_ABAT)
				If .NOT. aDadosTit[ nI, 1 ]
					cStatus := 'MARK'
					aDadosTit[ nI, 1 ] := .T.
				Else
					cStatus := 'NOMARK'
					aDadosTit[ nI, 1 ] := .F.
				Endif
				nValor += A210StrTran( aDadosTit[ nI, VALOR ] )
			Endif
		Next nI
		
		If cStatus <> ''
			If cStatus == 'MARK'
				aCliente[ oLbx1:nAt, 1 ] := .T.
				aCliente[ oLbx1:nAt, TOT_SELECT ] := nValor
			Elseif cStatus == 'NOMARK'
				aCliente[ oLbx1:nAt, 1 ] := .F.
				aCliente[ oLbx1:nAt, TOT_SELECT ] := 0
			Endif
			oLbx1:Refresh()
			oLbx2:Refresh()
			A210UpDate()
		Endif
	Endif	
Return		

//---------------------------------------------------------------------------------
// Rotina | A210MrkTit  | Autor | Robson Luiz - Rleg            | Data | 24/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para marcar o título e o cliente caso ele não esteja marcado.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210MrkTit()
	If A210TemMail( aCliente[ oLbx1:nAt, EMAIL_CLIENT ] ) .And. A210VldMail( aCliente[ oLbx1:nAt, EMAIL_CLIENT ] )
		If .NOT. (RTrim(aDadosTit[ oLbx2:nAt, TIPO ] ) $ cRET_ABAT)
			aDadosTit[ oLbx2:nAt, 1 ] := .NOT. aDadosTit[ oLbx2:nAt, 1 ]
			If aDadosTit[ oLbx2:nAt, 1 ]
				aCliente[ oLbx1:nAt, TOT_SELECT ] += A210StrTran( aDadosTit[ oLbx2:nAt, VALOR ] )
			Else
				aCliente[ oLbx1:nAt, TOT_SELECT ] -= A210StrTran( aDadosTit[ oLbx2:nAt, VALOR ] )
			Endif
			If AScan( aDadosTit,{|p| p[ 1 ] == .T. } ) == 0
				aCliente[ oLbx1:nAt, 1 ] := .F.
			Else
				If aCliente[ oLbx1:nAt, 1 ] == .F.
					aCliente[ oLbx1:nAt, 1 ] := .T.
				Endif
			Endif
			A210UpDate()
		Else
			MsgAlert('Este título é de abatimento ou de retenção, por isso não será possível selecioná-lo..',cCadastro)
		Endif
	Endif
	oLbx1:refresh()
	oLbx2:refresh()
Return

//---------------------------------------------------------------------------------
// Rotina | A210TemMail | Autor | Robson Luiz - Rleg            | Data | 25/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para verificar se o cliente possui e-mail cadastrado.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210TemMail(cMail)
	Local lRet := !Empty(cMail)
	If !lRet
		MsgAlert('Cliente sem endereço eletrônico. Não será possível enviar e-mail.',cCadastro)
	Endif
Return(lRet)

//---------------------------------------------------------------------------------
// Rotina | A210VldMail | Autor | Robson Luiz - Rleg            | Data | 25/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para verificar se o e-mail é correspondente.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210VldMail( cMail )
	Local lRet := At('@',cMail)>0
	If !lRet
		MsgAlert('A informação do campo e-mail não corresponde a endereço eletrônico. Não será possível enviar e-mail.',cCadastro)
	Endif
Return(lRet)

//---------------------------------------------------------------------------------
// Rotina | A210Array  | Autor | Robson Luiz - Rleg             | Data | 24/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para montar o array dos objetos TwBrowse.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Array()
	Local nI := 0
	Local nP := 0
	Local nElem := 0
	
	Local cChaveCli := ''
	
	nCall++
	
	cChaveCli := aCliente[ 1, 9 ]

   oLbx1:SetArray( aCliente )
	oLbx1:bLine := {|| { Iif( aCliente[ oLbx1:nAt, 1 ], oMrk, oNoMrk ),;
						aCliente[ oLbx1:nAt, 2 ],;
						aCliente[ oLbx1:nAt, 3 ],;
						aCliente[ oLbx1:nAt, 4 ],;
						aCliente[ oLbx1:nAt, 5 ],;
						aCliente[ oLbx1:nAt, 6 ],;
						aCliente[ oLbx1:nAt, 7 ],;
						aCliente[ oLbx1:nAt, 8 ],;
						aCliente[ oLbx1:nAt, 9 ],;
						aCliente[ oLbx1:nAt, 10],;
						''}}

	nP := AScan( aTitulo, {|p| p[ 12 ] == cChaveCli } )
	For nI := nP To Len( aTitulo )
		If aTitulo[ nI, 12 ] == cChaveCli
			AAdd( aDadosTit, Array( Len( aTitulo[ nI ] ) ) )
			nElem := Len( aDadosTit )
			aDadosTit[ nElem ] := AClone( aTitulo[ nI ] )
		Else
			Exit
		Endif
	Next nI 
		
   oLbx2:SetArray( aDadosTit )
	oLbx2:bLine := {|| { Iif( aDadosTit[ oLbx2:nAt, 1 ], oMrk, oNoMrk ),;
						Iif( aDadosTit[ oLbx2:nAt, TIPO ] $ cRET_ABAT, oAbatim, Iif( aDadosTit[ oLbx2:nAt, 2 ]==0, oNoEnviado, oEnviado ) ),;
						aDadosTit[ oLbx2:nAt, 3 ],;
						aDadosTit[ oLbx2:nAt, 4 ],;
						aDadosTit[ oLbx2:nAt, 5 ],;
						aDadosTit[ oLbx2:nAt, 6 ],;
						aDadosTit[ oLbx2:nAt, 7 ],;
						aDadosTit[ oLbx2:nAt, 8 ],;
						aDadosTit[ oLbx2:nAt, 9 ],;
						aDadosTit[ oLbx2:nAt,10 ],;
						aDadosTit[ oLbx2:nAt,11 ],;
						aDadosTit[ oLbx2:nAt,12 ],;
						aDadosTit[ oLbx2:nAt,13 ],;
						aDadosTit[ oLbx2:nAt,14 ],;
						aDadosTit[ oLbx2:nAt,15 ],;
						aDadosTit[ oLbx2:nAt,16 ],;
						aDadosTit[ oLbx2:nAt,17 ],;
						''}}
	
	A210NFiscal( cChaveCli, aDadosTit[ 1, NUM ], aDadosTit[ 1, SERIE_TIT ] )
	
   oLbx3:SetArray( aDadosNF )
	oLbx3:bLine := {|| { aDadosNF[ oLbx3:nAt, 1 ],;
						aDadosNF[ oLbx3:nAt, 2 ],;
						aDadosNF[ oLbx3:nAt, 3 ],;
						aDadosNF[ oLbx3:nAt, 4 ],;
						aDadosNF[ oLbx3:nAt, 5 ],;
						aDadosNF[ oLbx3:nAt, 6 ],;
						aDadosNF[ oLbx3:nAt, 7 ],;
						aDadosNF[ oLbx3:nAt, 8 ],;
						aDadosNF[ oLbx3:nAt, 9 ],;
						''}}
	
	oLbx2:Refresh()
	oLbx3:Refresh()
Return

//---------------------------------------------------------------------------------
// Rotina | A210UpDate | Autor | Robson Luiz - Rleg             | Data | 24/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para controle de marcar os títulos.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210UpDate()
	Local nI := 0
	Local nP := 0
	Local cKey := ''
	
	For nI := 1 To Len( aDadosTit )
		cKey := aDadosTit[ nI, PREFIXO ] + aDadosTit[ nI, NUM ] + aDadosTit[ nI, PARCELA ] + aDadosTit[ nI, TIPO ] + aDadosTit[ nI, COD_LOJ_TIT ]
		nP := AScan( aTitulo, {|p| p[ PREFIXO ] + p[ NUM ] + p[ PARCELA ] + p[ TIPO ] + p[ COD_LOJ_TIT ] == cKey } )
		If nP > 0
			aTitulo[ nP, 1 ] := aDadosTit[ nI, 1 ]
		Endif
	Next nI
Return

//---------------------------------------------------------------------------------
// Rotina | A210SetTit | Autor | Robson Luiz - Rleg             | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para controle dos dados do array quando mudar de registro.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210SetTit()
	Local nI := 0
	Local nP := 0
	Local nElem := 0
	
	Local cChaveCli := ''
	
	nCall++
	If nCall < 4
		Return
	Endif

	aDadosTit := {}
	
	cChaveCli := aCliente[ oLbx1:nAt, COD_LOJ_CLI ]
	nP := AScan( aTitulo, {|p| p[ COD_LOJ_TIT ] == cChaveCli } )
	For nI := nP To Len( aTitulo )
		If aTitulo[ nI, COD_LOJ_TIT ] == cChaveCli
			AAdd( aDadosTit, Array( Len( aTitulo[ nI ] ) ) )
			nElem := Len( aDadosTit )
			aDadosTit[ nElem ] := AClone( aTitulo[ nI ] )
		Else
			Exit
		Endif
	Next nI 
	
   oLbx2:SetArray( aDadosTit )
	oLbx2:bLine := {|| { Iif( aDadosTit[ oLbx2:nAt, 1 ], oMrk, oNoMrk ),;
						Iif( aDadosTit[ oLbx2:nAt, TIPO ] $ cRET_ABAT, oAbatim, Iif( aDadosTit[ oLbx2:nAt, 2 ]==0, oNoEnviado, oEnviado ) ),;
						aDadosTit[ oLbx2:nAt, 3 ],;
						aDadosTit[ oLbx2:nAt, 4 ],;
						aDadosTit[ oLbx2:nAt, 5 ],;
						aDadosTit[ oLbx2:nAt, 6 ],;
						aDadosTit[ oLbx2:nAt, 7 ],;
						aDadosTit[ oLbx2:nAt, 8 ],;
						aDadosTit[ oLbx2:nAt, 9 ],;
						aDadosTit[ oLbx2:nAt,10 ],;
						aDadosTit[ oLbx2:nAt,11 ],;
						aDadosTit[ oLbx2:nAt,12 ],;
						aDadosTit[ oLbx2:nAt,13 ],;
						aDadosTit[ oLbx2:nAt,14 ],;
						aDadosTit[ oLbx2:nAt,15 ],;
						aDadosTit[ oLbx2:nAt,16 ],;
						aDadosTit[ oLbx2:nAt,17 ],;
						''}}
	oLbx2:nAt := 1
	oLbx2:Refresh()

	A210NFiscal( cChaveCli, aDadosTit[ 1, NUM ], aDadosTit[ 1, SERIE_TIT ] )
	
   oLbx3:SetArray( aDadosNF )
	oLbx3:bLine := {|| { aDadosNF[ oLbx3:nAt, 1 ],;
						aDadosNF[ oLbx3:nAt, 2 ],;
						aDadosNF[ oLbx3:nAt, 3 ],;
						aDadosNF[ oLbx3:nAt, 4 ],;
						aDadosNF[ oLbx3:nAt, 5 ],;
						aDadosNF[ oLbx3:nAt, 6 ],;
						aDadosNF[ oLbx3:nAt, 7 ],;
						aDadosNF[ oLbx3:nAt, 8 ],;
						aDadosNF[ oLbx3:nAt, 9 ],;
						''}}
		
	oLbx3:nAt := 1
	oLbx3:Refresh()	
Return

//---------------------------------------------------------------------------------
// Rotina | A210SetNF  | Autor | Robson Luiz - Rleg             | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para apresentar a lista de NF conforme o título posicionado.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210SetNF()
	Local nP := 0
	Local nI := 0
	Local nElem := 0
	
	nCall++
	If nCall < 4
		Return
	Endif
	
	A210NFiscal( aDadosTit[ oLbx2:nAt, COD_LOJ_TIT ], aDadosTit[ oLbx2:nAt, NUM ], aDadosTit[ oLbx2:nAt, SERIE_TIT ] )
	
   oLbx3:SetArray( aDadosNF )
	oLbx3:bLine := {|| { aDadosNF[ oLbx3:nAt, 1 ],;
						aDadosNF[ oLbx3:nAt, 2 ],;
						aDadosNF[ oLbx3:nAt, 3 ],;
						aDadosNF[ oLbx3:nAt, 4 ],;
						aDadosNF[ oLbx3:nAt, 5 ],;
						aDadosNF[ oLbx3:nAt, 6 ],;
						aDadosNF[ oLbx3:nAt, 7 ],;
						aDadosNF[ oLbx3:nAt, 8 ],;
						aDadosNF[ oLbx3:nAt, 9 ],;
						''}}
			
	oLbx3:nAt := 1
	oLbx3:Refresh()
Return

//---------------------------------------------------------------------------------
// Rotina | A210NFiscal | Autor | Robson Luiz - Rleg            | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para buscar os dados da nota fiscal.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210NFiscal( cChaveCli, cE1_NUM, cE1_SERIE )
	Local lRet := .T.
	Local cB1_DESC := ''
	Local cA1_COD := Left( cChaveCli, 6 )
	Local cA1_LOJA := Right( cChaveCli, 2 )
	
	aDadosNF := {}
	
	SD2->( dbSetOrder( 3 ) )
	If SD2->( dbSeek( xFilial( 'SD2' ) + cE1_NUM + cE1_SERIE + cA1_COD + cA1_LOJA ) )
		While SD2->( .NOT. EOF() ) .And. SD2->( D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA ) == xFilial( 'SD2' ) + cE1_NUM + cE1_SERIE + cA1_COD + cA1_LOJA
			cB1_DESC := Posicione( 'SB1', 1, xFilial('SB1')+SD2->D2_COD, 'B1_DESC' )
			
			SD2->( AAdd( aDadosNF, { D2_DOC, ;
			D2_SERIE, ;
			D2_ITEM, ;
			D2_COD, ;
			cB1_DESC, ;
			MsPadL( TransForm(D2_QUANT,cPICT), 100 ), ;
			MsPadL( TransForm(D2_PRCVEN,cPICT), 100 ), ;
			MsPadL( TransForm(D2_TOTAL,cPICT), 100 ), ;
			cChaveCli } ) )
			
			SD2->( dbSkip() )
		End
	Else
		lRet := .F.
		AAdd( aDadosNF, { '', '', '', '', '', 0.00, 0.00, 0.00, '' } )
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A210Clear  | Autor | Robson Luiz - Rleg             | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para limpar os registros marcados nos objetos TwBrowse.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Clear()
	Local nI := 0
	Local nSum := 0
	
	nSum := Len( aCliente ) + Len( aTitulo ) + Len( aDadosTit )
	ProcRegua( nSum )
	
	For nI := 1 To Len( aCliente )
		IncProc()
		aCliente[ nI, 1 ] := .F.
		aCliente[ nI, TOT_SELECT ] := 0
	Next nI 
	
	For nI := 1 To Len( aTitulo )
		IncProc()
		aTitulo[ nI, 1 ] := .F.
	Next nI 
	
	For nI := 1 To Len( aDadosTit )
		IncProc()
		aDadosTit[ nI, 1 ] := .F.
	Next nI
	
	oLbx1:Refresh()
	oLbx2:Refresh()
	oLbx3:Refresh()
Return

//---------------------------------------------------------------------------------
// Rotina | A210Pesq   | Autor | Robson Luiz - Rleg             | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para efetuar a busca de dados conforme necessidade do usuário.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Pesq()
	Local oDlg, oOrdem, oChave, oBtOk, oBtCan, oTpBusca
	Local lTpBusca := .T.
	Local nBegin := 0
	Local nEnd := 0 
	Local bAScan := {|| .T. }
	Local cOrdem
	Local cChave := Space(255)
	Local aOrdens := {}
	Local aOrdPesq := {}
	Local nOrdem := 1
	Local nOpcao := 0
	Local nP := 0
	
	AAdd( aOrdens, 'Nome do cliente' )
	AAdd( aOrdens, 'Nº do título' )
	AAdd( aOrdens, 'Prefixo + Nº do título' )
	AAdd( aOrdens, 'Valor' )
	AAdd( aOrdens, 'Código + Loja do cliente' )
	
	DEFINE MSDIALOG oDlg TITLE 'Pesquisar' FROM 00,00 TO 100,500 PIXEL
		@ 05, 5 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlg ON CHANGE nOrdem := oOrdem:nAt
		@ 20, 5 MSGET oChave VAR cChave SIZE 210,08 OF oDlg PIXEL
		@ 39, 5 CHECKBOX oTpBusca VAR lTpBusca PROMPT 'Buscar a partir do item posicionado' SIZE 150,10 OF oDlg PIXEL
		DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlg:End()) ENABLE OF oDlg PIXEL
		DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (oDlg:End())              ENABLE OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpcao == 1
		cChave := Upper( RTrim( cChave ) )
		
		If nOrdem == 1 .Or. nOrdem == 5
			nBegin := Iif( lTpBusca, oLbx1:nAt, 1 )
			nEnd := Len( aCliente )
			If nOrdem == 1
				nP := AScan( aCliente, {|p| cChave $ Upper( RTrim( p[ NOME_CLIENTE ] ) ) }, nBegin, nEnd )
			Else
				nP := AScan( aCliente, {|p| p[ COD_LOJ_CLI ]==cChave }, nBegin, nEnd )
			Endif
		Else
			nBegin := Iif( lTpBusca, oLbx2:nAt, 1 )
			nEnd := Len( aDadosTit )
			
			If nOrdem == 2     ; bAScan := {|p| cChave == p[ NUM ] }
			Elseif nOrdem == 3 ; bAScan := {|p| cChave == p[ PREFIXO ] + p[ NUM ] }
			Elseif nOrdem == 4 ; bAScan := {|p| cChave == AllTrim( p[ VALOR ] ) }
			Endif
			
			nP := AScan( aDadosTit, bAScan, nBegin, nEnd )
		Endif
		
		If nP > 0
			If nOrdem == 1 .Or. nOrdem == 5
				oLbx1:nAt := nP
				oLbx1:Refresh()
				oLbx1:SetFocus()
			Else
				oLbx2:nAt := nP
				oLbx2:Refresh()
				oLbx2:SetFocus()
			Endif
		Else
			Help(' ',1,'REGNOIS')
		Endif
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A210VisNF  | Autor | Robson Luiz - Rleg             | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para consultar o documento fiscal de saída.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210VisNF()
	Local cNFiscal := ''
	Local cSerie := ''
	Local cCliente := ''
	
	cNFiscal := aDadosNF[ oLbx3:nAt, DOC_NF ]
	cSerie   := aDadosNF[ oLbx3:nAt, SERIE_NF ]
	cCliente := aCliente[ oLbx1:nAt, COD_LOJ_NF ]
	
	SF2->( dbSetOrder( 1 ) )
	If SF2->( dbSeek( xFilial( 'SF2' ) + cNFiscal + cSerie + cCliente ) )
		MC090Visual()
	Else
		MsgAlert( 'Documento fiscal de saída não localizado.', cCadastro )
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A210Script | Autor | Robson Luiz - Rleg             | Data | 16/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para apresentar o script de instrução SQL na tela.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Script( cSQL )
	Local cNomeArq := ''
	Local nHandle := 0
	Local lEmpty := .F.
	AutoGrLog('ativar para apagar')
	cNomeArq := NomeAutoLog()
	lEmpty := Empty( cNomeArq )
	If .NOT. lEmpty
		nHandle := FOpen( cNomeArq, 2 )
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
	AutoGrLog( cSQL )
	MostraErro()
	If .NOT. lEmpty
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A210Resumo | Autor | Robson Luiz - Rleg             | Data | 23/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para imprimir resumo da seleção de títulos.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Resumo()
	Local nI := 0
	Local nJ := 0
	Local nP := 0
	
	Local nValor := 0
	
	Local nTotal := 0
	Local nSubTotal := 0
	
	Local nSeekCli := 0
	Local nSeekTit := 0
	
	Local aCOL := {}
	
	Local cDesc1  := 'Impressão dos clientes e títulos selecionados da rotina de análise dos inadimplentes.'
	Local cDesc2  := ''
	Local cDesc3  := ''
	
	Private cString  := 'SE1'
	Private Tamanho  := 'M'
	Private aReturn  := aReturn  := { 'Zebrado',1,'Administracao',2,2,1,'',1 }
	Private wnrel    := 'CSFA210'
	Private NomeProg := wnrel
	Private nLastKey := 0
	Private Limite   := 132
	Private Titulo   := 'RESUMO DA SELEÇÃO DA ANÁLISE DOS INADIMPLENTES'
	Private cPerg    := ''
	Private nTipo    := 0
	Private cbCont   := 0
	Private cbTxt    := 'registro(s) lido(s)
	Private Li       := 80
	Private m_pag    := 1
	Private aOrd     := {}
	Private Cabec1   := '____________________________________________________________________________________________________________________________________'
	Private Cabec2   := 'CODIGO LOJA NOME DO CLIENTE                           PREFIXO NÚMERO    PARCELA TIPO EMISSÃO     VENCIMENTO  ATRASO            VALOR'
	
	// Há clientes selecionados?
	nP := AScan( aCliente, {|p| p[1]==.T. })
	If nP == 0
		MsgAlert('Nenhum cliente foi selecionado para envio de e-mail.',cCadastro)
		Return
	Else
		nSeekCli := nP
	Endif
	
	// Há títulos selecionados?
	nP := AScan( aTitulo, {|p| p[1]==.T. })
	If nP == 0
		MsgAlert('Nenhum título de cliente foi selecionado para envio de e-mail.',cCadastro)
		Return
	Endif
	
	/*
	-------------------------------------------------------------------------------------------------------------------------------------------------
	Lay-Out
	-------------------------------------------------------------------------------------------------------------------------------------------------
	CODIGO LOJA NOME DO CLIENTE                           PREFIXO NÚMERO    PARCELA TIPO EMISSÃO     VENCIMENTO  ATRASO            VALOR
	-------------------------------------------------------------------------------------------------------------------------------------------------
	999999 01   123456789x123456789x123456789x123456789x  XXX     123456789 12      123  12/12/1212  12/12/1212  123      999.999.999,99
	                                                      XXX     123456789 12      123  12/12/1212  12/12/1212  123      999.999.999,99
	                                                      XXX     123456789 12      123  12/12/1212  12/12/1212  123      999.999.999,99
	-------------------------------------------------------------------------------------------------------------------------------------------------
	SUBTOTAL                                                                                                              999.999.999,99
	-------------------------------------------------------------------------------------------------------------------------------------------------
	TOTAL                                                                                                                 999.999.999,99
	-------------------------------------------------------------------------------------------------------------------------------------------------
	0123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x12
	0         1         2         3         4         5         6         7         8         9         100       110       120       130
   */
   
	AAdd( aCOL, 000 ) //Código
	AAdd( aCOL, 007 ) //Loja
	AAdd( aCOL, 012 ) //Nome
	AAdd( aCOL, 054 ) //Prefixo
	AAdd( aCOL, 062 ) //Número
	AAdd( aCOL, 072 ) //Parcela
	AAdd( aCOL, 080 ) //Tipo
	AAdd( aCOL, 085 ) //Emissão
	AAdd( aCOL, 097 ) //Vencimento
	AAdd( aCOL, 109 ) //Atraso
	AAdd( aCOL, 118 ) //Valor
	
	// Estabelecer que a impressão seja em disco 1=Disco e 2=Impressora.
	__aImpress[ 1 ] := 1
	
	// 16º parâmetro não apresentar a interface da SetPrint().
	wnrel := SetPrint( cString, wnrel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F., aOrd, .F., Tamanho, .F., .F.,,,.T.)
	
	// Quando .F. não perguntar sobre a regravação de um relatório existente com mesmo nome de arquivo.
	__SetAskSubs( .F. )
	
	SetDefault( aReturn, cString )
	
	nTipo := Iif( aReturn[ 4 ] == 1, 15, 18 )
	
	For nI := nSeekCli To Len( aCliente )		
		If Li > 57
			Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
		Endif
		
		If aCliente[ nI, 1 ]
			@ Li, aCOL[ 1 ] PSay Left( aCliente[ nI, COD_LOJ_CLI ], 6 )
			@ Li, aCOL[ 2 ] PSay Right( aCliente[ nI, COD_LOJ_CLI ], 2 )
			@ Li, aCOL[ 3 ] PSay Left( aCliente[ nI, NOME_CLIENTE ], 40 )
			
			nSeekTit := AScan( aTitulo, {|p| ( p[ COD_LOJ_TIT ]==aCliente[ nI, COD_LOJ_CLI ] .And. p[ 1 ]==.T. ) } )
			
			If nSeekTit > 0
				
				For nJ := nSeekTit To Len( aTitulo )
					
					If Li > 57
						Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
					Endif
					
					If aTitulo[ nJ, COD_LOJ_TIT ] == aCliente[ nI, COD_LOJ_CLI ]
						
						If aTitulo[ nJ, 1 ]
							nValor  := A210StrTran( aTitulo[ nJ, VALOR ] ) 
							
							@ Li, aCOL[ 4 ]  PSay aTitulo[ nJ, PREFIXO ]
							@ Li, aCOL[ 5 ]  PSay aTitulo[ nJ, NUM ]
							@ Li, aCOL[ 6 ]  Psay aTitulo[ nJ, PARCELA ] 
							@ Li, aCOL[ 7 ]  PSay aTitulo[ nJ, TIPO ]
							@ Li, aCOL[ 8 ]  PSay aTitulo[ nJ, EMISSAO ]
							@ Li, aCOL[ 9 ]  PSay aTitulo[ nJ, VENCTO ]
							@ Li, aCOL[ 10 ] PSay aTitulo[ nJ, ATRASO ]
							@ Li, aCOL[ 11 ] PSay nValor  Picture cPICT 
							
							Li++
													
							nSubTotal += nValor
							nTotal    += nValor
					   Endif
					 Else
					 	Exit
					Endif 
				Next nJ
			
				@ Li, aCOL[ 1 ] PSay __PrtThinLine()
				Li++
				
				@ Li, aCOL[  1 ] PSay 'SUBTOTAL'
				@ Li, aCOL[ 11 ] PSay nSubTotal PICTURE cPICT
				Li++
				
				@ Li, aCOL[ 1 ] PSay __PrtThinLine()
				Li++
				
				nSubTotal := 0
			Endif
		Endif
	Next nI
	
	@ Li, aCOL[  1 ] PSay 'TOTAL'
	@ Li, aCOL[ 11 ] PSay nTotal PICTURE cPICT
	Li++
	
	@ Li, aCOL[ 1 ] PSay __PrtThinLine()
	Li++
	
	If Li <> 80
		Roda( cbCont, cbTxt, Tamanho )
	Endif

	If aReturn[ 5 ] == 1
		Set Printer To
		dbCommitAll()
		OurSpool( wnrel )
	Endif

	Ms_Flush()
Return

//---------------------------------------------------------------------------------
// Rotina | A210StrTran| Autor | Robson Luiz - Rleg             | Data | 25/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para converter valor caractere em numérico.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210StrTran( cValor )
Return( Val( StrTran( StrTran( cValor , '.', ''  ), ',', '.' ) ) )

//---------------------------------------------------------------------------------
// Rotina | A210Email  | Autor | Robson Luiz - Rleg             | Data | 26/07/1213
//---------------------------------------------------------------------------------
// Descr. | Rotina de preparação do envio dos e-mails.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Email()
	Local nP := 0
	Local nSeekCli := 0
	
	Private aEMAIL := {}
	
	Private cWF7_PASTA  := 'COBRANCAAUTOMATICA'
	Private cWF7_ENDERE := ''
	Private cWF7_REMETE := ''
	
	Private cFileHTML := ''
	Private cDir := '\htmlinad\'
	
	nP := AScan( aCliente, {|p| p[1]==.T. })
	If nP == 0
		MsgAlert('Nenhum cliente foi selecionado para envio de e-mail.',cCadastro)
		Return(.F.)
	Else
		nSeekCli := nP
	Endif
	
	// Há títulos selecionados?
	nP := AScan( aTitulo, {|p| p[1]==.T. })
	If nP == 0
		MsgAlert('Nenhum título de cliente foi selecionado para envio de e-mail.',cCadastro)
		Return(.F.)
	Endif

	MakeDir( cDir )
	cFileHTML  := Iif( n210Notif==1, 'csfa210.htm', 'csfa210ii.htm' )
	
	If .NOT. File( cFileHTML )
	   MsgAlert( 'Arquivo ' + Iif( n210Notif==1, 'HTML', 'HTMLii' ) + ' não localizado, impossível continuar.' , cCadastro )
	   Return(.F.)
	Endif
	
	// Contas de E-Mails do Workflow 
	If WF7->( dbSeek( xFilial( 'WF7' ) + cWF7_PASTA ) )
		cWF7_REMETE := RTrim( WF7->WF7_ENDERE )
		cWF7_ENDERE := Capital( Lower( RTrim( WF7->WF7_REMETE ) ) )
	Else
		cWF7_REMETE := 'cobrancaautomatica@certisign.com.br'
		cWF7_ENDERE := cWF7_REMETE
	Endif

	If MsgYesNo( 'Confirma o envio de e-mail para os clientes dos títulos selecionados?', cCadastro )
		MsAguarde( {|| A210Process( nSeekCli, nP ) }, cCadastro, '', .F. )
		A210Comprov()
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A210Process| Autor | Robson Luiz - Rleg             | Data | 26/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para filtrar somente os registros que serão processados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Process( nPCliente, nPTitulo )
	Local nI := 0
	Local nJ := 0
	
	A210Msg( 'Carregando os registros selecionados...' )
	
	For nI := nPCliente TO Len( aCliente )
		If aCliente[ nI, 1 ]
			nPTitulo := AScan( aTitulo, {|p| ( p[ COD_LOJ_TIT ]==aCliente[ nI, COD_LOJ_CLI ] .And. p[ 1 ]==.T. ) } )
			For nJ := nPTitulo TO Len( aTitulo )
				If aTitulo[ nJ, COD_LOJ_TIT ]==aCliente[ nI, COD_LOJ_CLI ]
					If aTitulo[ nJ, 1 ]
						AAdd( aEMAIL, { aCliente[ nI, COD_LOJ_CLI ]  ,;
						                aCliente[ nI, NOME_CLIENTE ] ,;
						                aCliente[ nI, EMAIL_CLIENT ] ,;
						                aTitulo[ nJ, PREFIXO ]       ,;
						                aTitulo[ nJ, NUM ]           ,;
						                aTitulo[ nJ, PARCELA ]       ,;
						                aTitulo[ nJ, TIPO ]          ,;
						                aTitulo[ nJ, EMISSAO ]       ,;
						                aTitulo[ nJ, VENCTO ]        ,;
						                aTitulo[ nJ, VALOR ]         ,;
						                aTitulo[ nJ, ATRASO ]        ,;
						                ''                           ,; // Nome do arquivo HTML.
						                ''                           ,; // Mensagem de Ok.
						                ''                           ,; // Mensagem de ERROR.
						                aTitulo[ nJ, E1_REC_NO ]     ,;
						                aTitulo[ nJ, SERIE_TIT ]     ,;
						                aCliente[ nI, EMAIL_VEND ]   ,;
						                aTitulo[ nJ, ENV_MAIL ]      ,;
						                aTitulo[ nJ, DT_MAIL ]       ,;
						                aTitulo[ nJ, DT_2MAIL ]      ,; 
						                aTitulo[ nJ, NFELETR ]    }) 
					Endif
				Else
					Exit
				Endif
			Next nJ
		Endif
	Next nI
	If Len( aEMAIL ) > 0
		A210SetHTML()
	Else
		MsgAlert( 'Nenhum e-mail foi enviado, pois não foi processado nenhum título de nenhum cliente.' ,cCadastro )
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A210SetHTML| Autor | Robson Luiz - Rleg             | Data | 26/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para elaborar o HTML.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210SetHTML()
	Local oHTML := NIL
	
	Local nElem := 0
	Local nLoop := 0
	
	Local lFirst := .T. 
	Local lContinua := .T.
	
	Local cKey := ''
	Local cSaveFiel := ''
	Local cA1_CONTATO := ''
	Local cNota	:= ''
	
	Local lMV_WFIMAGE := GetMv( 'MV_WFIMAGE', , .F. ) // Parâmetro do padrão que controla imagens em e-mails.
	
	//--------------------------------------
	// Se estiver True. Atribuir para False.
	//--------------------------------------
	If lMV_WFIMAGE
		PutMv( 'MV_WFIMAGE', .F. )
	Endif
	
	cKey := aEMAIL[ 1, 1 ]
	nElem := 1
	
	A210Msg( 'Elaborando e-mail...' )
	
	nLoop := 1
	cKey := aEMAIL[ nLoop, 1 ]
	While nLoop <= Len( aEMAIL ) .And. lContinua
		If lFirst
			lFirst := .F.
			cSaveFile := CriaTrab( NIL , .F. ) + '.htm'
			
			oHTML := TWFHTML():New( cFileHTML )
			
			oHTML:ValByName( 'cCliente', aEMAIL[ nLoop, 2 ] )
			cA1_CONTATO := Posicione( 'SA1', 1, xFilial( 'SA1' ) + aEMAIL[ nLoop, 1 ], 'A1_CONTATO' )
			If .NOT. Empty( cA1_CONTATO )
				oHTML:ValByName( 'cContato', 'A/C ' + cA1_CONTATO )
			Else
				oHTML:ValByName( 'cContato', 'A/C Contas a pagar.' )
			Endif
			
			If n210Notif == 2
				If oHTML:ExistField( 1, 'dDTEmail' )
					oHTML:ValByName( 'dDTEmail', Iif(Empty(aEMAIL[ nLoop, 20 ]),aEMAIL[ nLoop, 19 ],aEMAIL[ nLoop, 20 ]) )
				Endif
			Endif
			
			oHTML:ValByName( 'cProtocolo', Left(cSaveFile,At('.',cSaveFile )-1) )
			If oHTML:ExistField( 1, 'WFMailTo' )
				oHTML:ValByName( 'WFMailTo',  cWF7_ENDERE )
			Endif
		Endif

		cNota := IiF( Empty( aEMAIL[ nLoop, 21 ] ), aEMAIL[ nLoop, 05 ], aEMAIL[ nLoop, 21 ] ) 

		AAdd( oHTML:ValByName( 'a.Titulo' ) , cNota )
		AAdd( oHTML:ValByName( 'a.Emissao' ), aEMAIL[ nLoop, 8  ] )
		AAdd( oHTML:ValByName( 'a.Vencto' ) , aEMAIL[ nLoop, 9  ] )
		AAdd( oHTML:ValByName( 'a.Valor' )  , aEMAIL[ nLoop, 10 ] )
		
		cNota := ''
		If nLoop < Len( aEMAIL )
			nLoop++ 
		Else
			lContinua := .F.
		Endif
		
		//---------------------------------------------------------------------
		// Se mudou a chave ou não continuar com o laço, salvar o arquivo HTML.
		//---------------------------------------------------------------------
		If cKey <> aEMAIL[ nLoop, 1 ] .Or. .NOT. lContinua
			oHTML:SaveFile( cDir + cSaveFile )
			Sleep(1500) // Aguardar um segundo e meio para o sistema operacional concluir a gravação do arquivo.

			aNF := {}
			lFirst := .T.
			cKey := aEMAIL[ nLoop, 1 ]
			AEval( aEMAIL, {|p| p[12] := cDir + cSaveFile } , nElem, Iif( lContinua, nLoop-1, nLoop ) )
			nElem := nLoop
		Endif
	End
	
	//---------------------------------------------------------------
	// Voltar o conteúdo do parâmetro que foi mudado por esta rotina.
	//---------------------------------------------------------------
	If lMV_WFIMAGE
		PutMv( 'MV_WFIMAGE', .T. )
	Endif
	
	Begin Transaction
		A210LerArq()
	End Transaction
Return

//---------------------------------------------------------------------------------
// Rotina | A210LerArq | Autor | Robson Luiz - Rleg             | Data | 26/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para processar a leitura do arquivo HTML e envio do e-mail.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210LerArq()
	Local nI := 0
	Local cFile := ''
	Local cBody := ''
	Local aReturn := {}
	Private c210Time    := Time()
	Private cMailServer := GetMv('MV_RELSERV')
	Private cLogin      := GetMv('MV_CACNT')
	Private cMailSenha  := GetMv('MV_CAPSW')
	Private lSMTPAuth   := GetMv('MV_RELAUTH')
	Private nTimeOut    := GetMv('MV_RELTIME',,120)
	A210Msg( 'Enviando e-mail e gerando protocolo...' )
	For nI := 1 To Len( aEMAIL )
		If cFile <> aEMAIL[ nI, 12 ]
			cFile := aEMAIL[ nI, 12 ]		   
		   cBody := A210LeHTML( aEMAIL[ nI, 12 ] )
			aReturn := A210Send( aEMAIL[ nI, 3 ], cBody, aEMAIL[ nI, 17 ] ) //Email do cliente, corpo do e-mail, email do vendedor.			
		Endif
		aEMAIL[ nI, 13 ] := aReturn[ 1 ]
		aEMAIL[ nI, 14 ] := aReturn[ 2 ]		
		If .NOT. Empty( aReturn[ 1 ]  )
			A210FlagSE1( aEMAIL[ nI, E1_REC_NO ], nI )
		Endif
	Next nI
Return

//---------------------------------------------------------------------------------
// Rotina | A210FlagSE1| Autor | Robson Luiz - Rleg             | Data | 26/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para marcar o título como enviado e-mail.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210FlagSE1( nRecNo, nI )
	Local aDados := {}

	SE1->( dbSetOrder( 1 ) )
	SE1->( dbGoTo( nRecNo ) )
	If SE1->( RecNo() ) == nRecNo
		SE1->( RecLock( 'SE1', .F. ) )
		SE1->E1_QTDMAIL := SE1->E1_QTDMAIL + 1
		If Empty(SE1->E1_DTMAIL)
			SE1->E1_DTMAIL  := MsDate()
		Else
			SE1->E1_DT2MAIL  := MsDate()
		Endif
		SE1->( MsUnLock() )
		
		PAM->( dbSetOrder( 1 ) )
		PAM->( RecLock( 'PAM', .T. ) )
		PAM->PAM_FILIAL := xFilial( 'PAM' )
		PAM->PAM_DTENV  := dDataBase
		PAM->PAM_HRENV  := c210Time
		PAM->PAM_USER   := RetCodUsr()
		PAM->PAM_PATH   := aEMAIL[ nI, 12 ]
		PAM->PAM_PREFIX := SE1->E1_PREFIXO
		PAM->PAM_NUM    := SE1->E1_NUM
		PAM->PAM_PARCEL := SE1->E1_PARCELA
		PAM->PAM_TIPO   := SE1->E1_TIPO
		PAM->PAM_CLIENT := SE1->E1_CLIENTE
		PAM->PAM_LOJA   := SE1->E1_LOJA
		PAM->PAM_EMISST := SE1->E1_EMISSAO
		PAM->PAM_VENCTO := SE1->E1_VENCTO
		PAM->PAM_VENCRE := SE1->E1_VENCREA
		PAM->PAM_ATRASO := aEMAIL[ nI, 11 ]
		PAM->PAM_ENVMAI := SE1->E1_QTDMAIL
		PAM->PAM_OK     := aEMAIL[ nI, 13 ]
		PAM->PAM_ERRO   := aEMAIL[ nI, 14 ]
		PAM->( MsUnLock() )

		aADD( aDados, { SE1->E1_CLIENTE, nRecNo } )
		A210TeleCob( aDados )
	Endif
Return
//---------------------------------------------------------------------------------
// Rotina | A210Send   | Autor | Robson Luiz - Rleg             | Data | 26/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para enviar o e-mail.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Send( cMailCliente, cBody, cMailVend )
	Local lOk := .T.
	Local lSendOk := .T.
		
	Local cOk := ''
	Local cError := ''
	Local lServerTst := GetServerIP() $ GetMv( 'MV_610_IP', .F. )
	Local cSubject := IIF( lServerTst, "[TESTE] ", "" ) + 'CERTISIGN - Confirmação de Pagamento.'
	
	//-----------------------------------------------------------------------------
	// Caso não haja vendedor incluir somente o endereço da própria saída do email.
	//-----------------------------------------------------------------------------
	If Empty( cMailVend )
		cMailVend := cWF7_REMETE
	Else
		cMailVend += '; ' + cWF7_REMETE
	Endif
	
	//-----------------------------------------------------------
	// Caso o parâmetro esteja habilitado modificar os endereços.
	//-----------------------------------------------------------
	If .NOT. Empty( cMV_FKMAIL )
		cMailCliente := cMV_FKMAIL
		cMailVend    := cMailCliente
		MsgAlert('PARÂMETRO PARA SUBSTITUIR ENDERECO DO CLIENTE E DO VENDEDOR HABILITADO. UTILIZADO PARA SIMULACAO/TESTE. '+cMV_FKMAIL,cCadastro+' - MV_FKMAIL' )
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
			SEND MAIL FROM cWF7_REMETE TO cMailCliente BCC cMailVend SUBJECT cSubject BODY cBody RESULT lSendOk
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
Return({cOk,cError})

//---------------------------------------------------------------------------------
// Rotina | A210LeHTML | Autor | Robson Luiz - Rleg             | Data | 26/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina de leitura do arquivo HTML.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210LeHTML( cPath )
	Local cMsg := ''
	If File( cPath )
		FT_FUSE( cPath )
		FT_FGOTOP()
		While !FT_FEOF()
			cMsg += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
	Endif
Return( cMsg )

//---------------------------------------------------------------------------------
// Rotina | A210Msg    | Autor | Robson Luiz - Rleg             | Data | 26/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina para atualizar a mensagem do andamento do processamento.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Msg( cMsg )
   MsProcTxt( cMsg )
   ProcessMessage()
Return

//---------------------------------------------------------------------------------
// Rotina | A210Comprov| Autor | Robson Luiz - Rleg             | Data | 26/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina p/ impressão do comprovante/protocolo ou status de problema no 
//        | envio do e-mail.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Comprov()
	Local lImpFile := .F.
	
	Local aCOL := {}
	
	Local nI := 0
	Local nValue := 0
	Local nTotal := 0
	Local nSubTotal := 0
	Local cCodLoja := ''
	
	Local cDesc1  := 'COMPROVANTE DO ENVIO DE E-MAIL OU STATUS DE PROBLEMA NO ENVIO DO E-MAIL'
	Local cDesc2  := ''
	Local cDesc3  := ''
	
	Private cString  := 'SE1'
	Private Tamanho  := 'M'
	Private aReturn  := aReturn  := { 'Zebrado',1,'Administracao',2,2,1,'',1 }
	Private wnrel    := 'CSFA210CE'
	Private NomeProg := wnrel
	Private nLastKey := 0
	Private Limite   := 132
	Private Titulo   := 'COMPROVANTE C/ PROTOCOLO DE ENVIO DE E-MAIL OU STATUS DE PROBLEMA'
	Private cPerg    := ''
	Private nTipo    := 0
	Private cbCont   := 0
	Private cbTxt    := 'registro(s) lido(s)'
	Private Li       := 80
	Private m_pag    := 1
	Private aOrd     := {}
	Private Cabec1   := '____________________________________________________________________________________________________________________________________'
	Private Cabec2   := 'CODIGO LOJA NOME DO CLIENTE                           PREFIXO NÚMERO    PARCELA TIPO EMISSÃO     VENCIMENTO  ATRASO            VALOR'

	/*
	-------------------------------------------------------------------------------------------------------------------------------------------------
	COMPROVANTE DO ENVIO DE E-MAIL OU STATUS DE PROBLEMAS NO ENVIO DE EMAIL.
	-------------------------------------------------------------------------------------------------------------------------------------------------
	CODIGO LOJA NOME DO CLIENTE                           PREFIXO NÚMERO    PARCELA TIPO EMISSÃO     VENCIMENTO  ATRASO            VALOR
	-------------------------------------------------------------------------------------------------------------------------------------------------
	999999 01   123456789x123456789x123456789x123456789x123456789x123456789x             STATUS: STATUS SE FOI POSSÍVEL ENVIAR O E-MAIL
	PROTOCOLO: \DIR\ARQUIVO                               XXX     123456789 12      123  12/12/1212  12/12/1212  123      999.999.999,99
	                                                      XXX     123456789 12      123  12/12/1212  12/12/1212  123      999.999.999,99
	                                                      XXX     123456789 12      123  12/12/1212  12/12/1212  123      999.999.999,99
	-------------------------------------------------------------------------------------------------------------------------------------------------
	SUBTOTAL                                                                                                              999.999.999,99
	-------------------------------------------------------------------------------------------------------------------------------------------------
	TOTAL                                                                                                                 999.999.999,99
	-------------------------------------------------------------------------------------------------------------------------------------------------
	0123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x12
	0         1         2         3         4         5         6         7         8         9         100       110       120       130
   */

	AAdd( aCOL, 000 ) //Código
	AAdd( aCOL, 007 ) //Loja
	AAdd( aCOL, 012 ) //Nome
	AAdd( aCOL, 054 ) //Prefixo
	AAdd( aCOL, 062 ) //Número
	AAdd( aCOL, 072 ) //Parcela
	AAdd( aCOL, 080 ) //Tipo
	AAdd( aCOL, 085 ) //Emissão
	AAdd( aCOL, 097 ) //Vencimento
	AAdd( aCOL, 109 ) //Atraso
	AAdd( aCOL, 118 ) //Valor
	
	// Estabelecer que a impressão seja em disco 1=Disco e 2=Impressora.
	__aImpress[ 1 ] := 1
	
	// 16º parâmetro não apresentar a interface da SetPrint().
	wnrel := SetPrint( cString, wnrel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F., aOrd, .F., Tamanho, .F., .F.,,,.T.)
	
	// Quando .F. não perguntar sobre a regravação de um relatório existente com mesmo nome de arquivo.
	__SetAskSubs( .F. )
	
	SetDefault( aReturn, cString )
	
	nTipo := Iif( aReturn[ 4 ] == 1, 15, 18 )
	
	For nI := 1 To Len( aEMAIL )
		If Li > 57
			Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
		Endif
		
		If cCodLoja <> aEMAIL[ nI, 1 ]
			If .NOT. Empty( cCodLoja  )
				@ Li, aCOL[ 1 ] PSay __PrtThinLine()
				Li++
				
				@ Li, aCOL[ 1 ]  PSay 'SUBTOTAL'
				@ Li, aCOL[ 11 ] PSay nSubTotal Picture cPICT
				Li++
				
				@ Li, aCOL[ 1 ] PSay __PrtThinLine()
				Li++
				
				nSubTotal := 0
				lImpFile := .F.
			Endif
			
			cCodLoja := aEMAIL[ nI, 1 ]
			
			@ Li, aCOL[ 1 ]  PSay Left( aEMAIL[ nI, 1 ], 6 ) // CODIGO
			@ Li, aCOL[ 2 ]  PSay Right( aEMAIL[ nI, 1 ], 2 ) // LOJA
			@ Li, aCOL[ 3 ]  PSay aEMAIL[ nI, 2 ] // NOME
			
			If .NOT. Empty( aEMAIL[ nI, 13] )
				@ Li, aCOL[ 8 ] PSay aEMAIL[ nI, 13] // OK
			Else
				@ Li, aCOL[ 8 ] PSay aEMAIL[ nI, 14] // ERRO
			Endif
			
			Li++
		Endif
				
		If !lImpFile
			lImpFile := .T.
			@ Li, aCOL[ 1 ] PSay 'PROTOCOLO: ' + Upper( Left( aEMAIL[ nI, 12 ], At( '.', aEMAIL[ nI, 12 ] ) -1 ) ) // NOME DO ARQUIVO HTML
		Endif
		
		nValue := A210StrTran( aEMAIL[ nI, 10] )
		
		@ Li, aCOL[ 4 ]  PSay aEMAIL[ nI, 4 ] // PREFIXO
		@ Li, aCOL[ 5 ]  PSay aEMAIL[ nI, 5 ] // NUMERO
		@ Li, aCOL[ 6 ]  PSay aEMAIL[ nI, 6 ] // PARCELA
		@ Li, aCOL[ 7 ]  PSay aEMAIL[ nI, 7 ] // TIPO
		@ Li, aCOL[ 8 ]  PSay aEMAIL[ nI, 8 ] // EMISSAO
		@ Li, aCOL[ 9 ]  PSay aEMAIL[ nI, 9 ] // VENCIMENTO
		@ Li, aCOL[ 10 ] PSay aEMAIL[ nI, 11] // ATRASO
		@ Li, aCOL[ 11 ] PSay nValue Picture cPICT // VALOR
		
		nSubTotal += nValue 
		nTotal    += nValue 
		Li++
		
	Next nI
	
	@ Li, aCOL[ 1 ] PSay __PrtThinLine()
	Li++
	
	@ Li, aCOL[ 1 ]  PSay 'SUBTOTAL'
	@ Li, aCOL[ 11 ] PSay nSubTotal Picture cPICT
	Li++
	
	@ Li, aCOL[ 1 ] PSay __PrtThinLine()
	Li++
	
	@ Li, aCOL[ 1 ]  PSay 'TOTAL'
	@ Li, aCOL[ 11 ] PSay nTotal Picture cPICT
	Li++
	
	If Li <> 80
		Roda( cbCont, cbTxt, Tamanho )
	Endif

	If aReturn[ 5 ] == 1
		Set Printer To
		dbCommitAll()
		OurSpool( wnrel )
	Endif

	Ms_Flush()
Return

//---------------------------------------------------------------------------------
// Rotina | A210Imp     | Autor | Robson Luiz - Rleg            | Data | 15/08/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina de impressão para relacionar os títulos enviados para cobrança.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Imp()
	Local oReport
	Local cPerg := 'CSFA210'
	
	PutSX1(cPerg,"01","Periodo de?" ,"Periodo de?" ,"Periodo de?" ,"mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{""},{""},{""},"")
	PutSX1(cPerg,"02","Periodo até?","Periodo até?","Periodo até?","mv_ch1","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{""},{""},{""},"")

	PutSX1Help("P."+cPerg+"01.",{"Define o período inicial para impressão","do relatório de clientes notificados."},{""},{""},.T.)
	PutSX1Help("P."+cPerg+"02.",{"Define o período final para impressão  ","do relatório de clientes notificados."},{""},{""},.T.)
	
	Pergunte( cPerg, .F. )

	oReport := A210ProcImp( cPerg )
	oReport:PrintDialog()
Return

//---------------------------------------------------------------------------------
// Rotina | A210ProcImp | Autor | Robson Luiz - Rleg            | Data | 15/08/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina de processamento da impressão.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210ProcImp( cPerg )
	Local oReport
	Local oSection
	Local cDescricao := ''
	Local cTRB := ''
	Local lQuebra := .T.
	Local nTam := 30
	Local aOrdem := {}
	
	AAdd( aOrdem, 'Data+Hora do envio da notificação' )
	AAdd( aOrdem, 'Nome do cliente' )
	AAdd( aOrdem, 'Código do cliente' )
	AAdd( aOrdem, 'Prefixo+Número+Parcela do título' )
	AAdd( aOrdem, 'Atraso (Crescente)' )
	AAdd( aOrdem, 'Atraso (Decrescente)' )
	
	cDescricao := "Relatório que gera as informações dos clientes que foram notificados por e-mail relativo a inadimplência. "
	cDescricao += "Por favor, informe os parâmetros para processeguir.."
	
	oReport	:=	TReport():New( "A210IMP", "Relação dos clientes notificados", cPerg, {|oReport| A210Print( @oReport, @cTRB, cPerg, aOrdem ) }, cDescricao, .T. )
	oReport:cFontBody := 'Consolas'
	oReport:nFontBody	:= 9
	oReport:nLineHeight := 26
	oReport:SetLandscape()
	
	oSection	:= TRSection():New( oReport, 'Clientes Notificados', { cTRB }, aOrdem )
	oSection:OnPrintLine( {|| Iif( oReport:Row() > 1, ( oReport:SkipLine(), oReport:ThinLine() ), NIL ) } )
			
	TRCell():New( oSection, 'PAM_DTENV' , cTRB, 'DT.Envio'+CRLF+'.'            , , , , {|| (cTRB)->PAM_DTENV  } )
	TRCell():New( oSection, 'PAM_HRENV' , cTRB, 'HR.Envio'                     , , , , {|| (cTRB)->PAM_HRENV  } )
	TRCell():New( oSection, 'PAM_PREFIX', cTRB, 'Pref.'                        , , , , {|| (cTRB)->PAM_PREFIX } )
	TRCell():New( oSection, 'PAM_NUM'   , cTRB, 'Nº Título'                    , , , , {|| (cTRB)->PAM_NUM    } )
	TRCell():New( oSection, 'PAM_PARCEL', cTRB, 'Parc.'                        , , , , {|| (cTRB)->PAM_PARCEL } )
	TRCell():New( oSection, 'PAM_TIPO'  , cTRB, 'Tipo'                         , , , , {|| (cTRB)->PAM_TIPO   } )
	TRCell():New( oSection, 'PAM_CLIENT', cTRB, 'Cliente'                      , , , , {|| (cTRB)->PAM_CLIENT } )
	TRCell():New( oSection, 'A1_NOME'   , cTRB, 'Nome Cliente'                 , , nTam, , {|| (cTRB)->A1_NOME    }, , lQuebra )
	TRCell():New( oSection, 'PAM_EMISST', cTRB, 'Emissão'                      , , , , {|| (cTRB)->PAM_EMISST } )
	TRCell():New( oSection, 'PAM_VENCTO', cTRB, 'Vencto.'                      , , , , {|| (cTRB)->PAM_VENCTO } )
	TRCell():New( oSection, 'E1_VALOR'  , cTRB, 'Valor Título'                 , , , , {|| (cTRB)->E1_VALOR   } )
	TRCell():New( oSection, 'PAM_ATRASO', cTRB, 'Atraso'                       , , , , {|| (cTRB)->PAM_ATRASO } )
	TRCell():New( oSection, 'PAM_ENVMAI', cTRB, 'Env.EMail'                    , , , , {|| (cTRB)->PAM_ENVMAI } )
	TRCell():New( oSection, 'PAM_PATH'  , cTRB, 'Endereço e Protocolo'+CRLF+'.', , , , {|| (cTRB)->PAM_PATH   } )
Return( oReport )

//---------------------------------------------------------------------------------
// Rotina | A210Print   | Autor | Robson Luiz - Rleg            | Data | 15/08/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina de impressão.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Print( oReport, cTRB, cPerg, aOrdem )
	Local cOrdem := ''
	Local oSection := oReport:Section(1)
	Local nOrdem := oSection:GetOrder()

	If nOrdem == 1     ; cOrdem := "%PAM_DTENV, PAM_HRENV%"
	Elseif nOrdem == 2 ; cOrdem := "%A1_NOME%"       
	Elseif nOrdem == 3 ; cOrdem := "%PAM_CLIENT, PAM_LOJA%"
	Elseif nOrdem == 4 ; cOrdem := "%PAM_PREFIX, PAM_NUM, PAM_PARCEL%"
	Elseif nOrdem == 5 ; cOrdem := "%PAM_ATRASO%"
	Elseif nOrdem == 6 ; cOrdem := "%PAM_ATRASO DESC%"
	Endif

	oReport:SetTitle( oReport:Title() + ' - Ordem: ' + aOrdem[ nOrdem ] )

	cTRB := GetNextAlias()
	
	MakeSqlExpr( cPerg )

	oSection:BeginQuery()
	BeginSql Alias cTRB
		Column PAM_DTENV  As Date
		Column PAM_EMISST As Date
		Column PAM_VENCTO As Date
		Column PAM_VENCRE As Date
	
		%NoParser%
		
		SELECT PAM_DTENV,
		       PAM_HRENV,
		       PAM_PREFIX,
		       PAM_NUM,
		       PAM_PARCEL,
		       PAM_TIPO,
		       PAM_CLIENT,
		       PAM_LOJA,
		       A1_NOME,
		       PAM_EMISST,
		       PAM_VENCTO,
		       PAM_VENCRE,
		       E1_VALOR,
		       PAM_ATRASO,
		       PAM_ENVMAI,
		       PAM_PATH
		FROM   %Table:PAM% PAM
		       LEFT JOIN %Table:SA1% SA1
		              ON A1_FILIAL = %xFilial:SA1%
		             AND A1_COD = PAM_CLIENT
		             AND A1_LOJA = PAM_LOJA
		             AND SA1.%NOTDEL% 
		       LEFT JOIN %Table:SE1% SE1
		              ON E1_FILIAL = %xFilial:SE1%
		             AND E1_PREFIXO = PAM_PREFIX
		             AND E1_NUM = PAM_NUM
		             AND E1_PARCELA = PAM_PARCEL
		             AND E1_TIPO = PAM_TIPO
		             AND E1_CLIENTE = PAM_CLIENT
		             AND E1_LOJA = PAM_LOJA
		             AND SE1.%NOTDEL% 
		WHERE  PAM_FILIAL = %xFilial:PAM%
		       AND PAM_DTENV BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% 
		       AND PAM.%NOTDEL% 
		ORDER  BY %EXP:cOrdem%
	EndSql
	oSection:EndQuery()                                        
	
	oSection:Print()
	oReport:SkipLine()
	oReport:FatLine()	
Return

//---------------------------------------------------------------------------------
// Rotina | A210SXB     | Autor | Robson Luiz - Rleg            | Data | 15/08/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para verificar se há consulta SXB, criando-a se necessário.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210SXB()
	Local nI := 0
	Local nJ := 0
	Local aCpoSXB := {}
	Local aSXB := {}
	Local cTamSXB := 0
	Local cXB_ALIAS := 'CSF210'
	SXB->( dbSetOrder( 1 ) )
	If .NOT. SXB->( dbSeek( cXB_ALIAS ) )
		nTamSXB := Len( SXB->XB_ALIAS )
		aCpoSXB := { "XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM","XB_WCONTEM" }
		AAdd(aSXB,{cXB_ALIAS,"1","01","RE","Protocolo de Envio","Protocolo de Envio","Protocolo de Envio","PAM",""})
		AAdd(aSXB,{cXB_ALIAS,"2","01","01","Arquivo","Arquivo","Arquivo","FwMsgRun(,{|| U_A210Open() },,'Aguarde, abrindo protocolo...')",""})
		AAdd(aSXB,{cXB_ALIAS,"5","01","","","","","PAM->PAM_PATH",""})
		SXB->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aSXB )
			If .NOT. SXB->( dbSeek( PadR( aSXB[ nI, 1 ], nTamSXB ) + aSXB[ nI,2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
				SXB->( RecLock( 'SXB', .T. )) 
				For nJ := 1 To Len( aCpoSXB )
					SXB->( FieldPut( FieldPos( aCpoSXB[ nJ ] ), aSXB[ nI, nJ ] ) )
				Next nJ
				SXB->( MsUnLock() )
			Endif
		Next nI
		SX3->( dbSetOrder( 2 ) )
		If SX3->( dbSeek( 'PAM_PATH' ) )
			If SX3->X3_F3 <> cXB_ALIAS
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_F3 := cXB_ALIAS
				SX3->( MsUnLock() )
			Endif
		Endif
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A210Open    | Autor | Robson Luiz - Rleg            | Data | 15/08/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para abrir o arquivo HTML.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A210Open()
	Local cDirTemp := GetTempPath()
	Local cPAM_PATH := RTrim(PAM->PAM_PATH)
	Local cArq := SubStr( cPAM_PATH, RAt( '\', cPAM_PATH )+1 )
	CpyS2T( cPAM_PATH, cDirTemp, .T.)
	// Aguardar 1/4 de um segundo para dar tempo de cópia da rede para a estação.
	Sleep(250)
	ShellExecute( 'Open', cArq, '', cDirTemp, 1 )
	// Aguardar cinco segundos para abrir o arquivo.
	Sleep(5000)
	MsgInfo( 'Clique em OK para retornar a interface.', 'Visualizar corpo e-mail' )
	FErase( cDirTemp + cArq )
Return( .T. )

//---------------------------------------------------------------------------------
// Rotina | UPD210     | Autor | Robson Luiz - Rleg             | Data | 25/07/2013
//---------------------------------------------------------------------------------
// Descr. | Rotina de update p/ criar as estruturas no dicionário dados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function UPD210()
	Local cModulo := 'TMK'
	Local bPrepar := {|| U_U210Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//---------------------------------------------------------------------------------
// Rotina | UPD210     | Autor | Robson Luiz - Rleg             | Data | 25/07/2013
//---------------------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function U210Ini()
	aSX3 := {}
	aHelp := {}

	AAdd( aSX3    ,{	'SE1',NIL,'E1_QTDMAIL','N',2,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'email enviad','email enviad','email enviad',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Qtde.vezes envio de email','Qtde.vezes envio de email','Qtde.vezes envio de email',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							'99',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL
	
	AAdd( aSX3    ,{	'SE1',NIL,'E1_DTMAIL','D',8,0,;                      //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'DT. 1º Envio','DT. 1º Envio','DT. 1º Envio',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Data do 1º email enviado','Data do 1º email enviado','Data do 1º email enviado',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							' ',;                                                //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd( aSX3    ,{	'SE1',NIL,'E1_DT2MAIL','D',8,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'DT.Ult.Envio','DT.Ult.Envio','DT.Ult.Envio',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Data do ult.email enviado','Data do ult.email enviado','Data do ult.email enviado',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							' ',;                                                //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'E1_QTDMAIL', 'Quantidade de vezes que a rotina de Análise de Inadimplentes (CSFA210) enviou e-mail para o cliente cobrando-o.'})
	AAdd(aHelp,{'E1_DTMAIL' , 'Data do primeiro e-mail enviado com a rotina de Análise dos Inadimplentes (CSFA210).'})
	AAdd(aHelp,{'E1_DT2MAIL' ,'Data do último e-mail enviado com a rotina de Análise dos Inadimplentes (CSFA210).'})
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A210Dic     | Autor | Robson Luiz - Rleg            | Data | 15/08/2014
//---------------------------------------------------------------------------------
// Descr. | Matriz com os dados dos dicionário de dados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210Dic( aSX2, aSX3, aSIX )
	//[ SX2 - DICIONÁRIO DE TABELA ]
	AAdd(aSX2,{"PAM","","PAM010","TIT.RECEB.PROCESS.INADIMPLENT.","TIT.RECEB.PROCESS.INADIMPLENT.","TIT.RECEB.PROCESS.INADIMPLENT.","","C","E","E",0,"","","",0,"","",""})
	//[ SX3 - DICIONÁRIO DE CAMPOS ]
	AAdd(aSX3,{"PAM","01","PAM_FILIAL","C",2,0 ,"Filial"      ,"Sucursal"    ,"Branch"      ,"Filial do Sistema"        ,"Sucursal"                 ,"Branch of the System"     ,"@!","","€€€€€€€€€€€€€€€","","",1,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","",""})
	AAdd(aSX3,{"PAM","02","PAM_DTENV" ,"D",8,0 ,"DT. do Envio","DT. do Envio","DT. do Envio","Data do envio da cobranca","Data do envio da cobranca","Data do envio da cobranca",""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","03","PAM_HRENV" ,"C",8,0 ,"HR. do Envio","HR. do Envio","HR. do Envio","Hora do envio da cobranca","Hora do envio da cobranca","Hora do envio da cobranca",""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","04","PAM_USER"  ,"C",6,0 ,"ID Usuario"  ,"ID Usuario"  ,"ID Usuario"  ,"Codigo do usuario"        ,"Codigo do usuario"        ,"Codigo do usuario"        ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","05","PAM_USUARI","C",30,0,"Nome Usuario","Nome Usuario","Nome Usuario","Nome do usuario"          ,"Nome do usuario"          ,"Nome do usuario"          ,""  ,"","€€€€€€€€€€€€€€ ","IIF(INCLUI,UsrFullName(RetCodUsr()),UsrFullName(PAM->PAM_USER))","",0,"þÀ","","","U","S","V","V","","","","","","","","UsrFullName(PAM->PAM_USER)","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","06","PAM_PATH"  ,"C",30,0,"Path HTML"   ,"Path HTML"   ,"Path HTML"   ,"Endereco do procolo HTML" ,"Endereco do procolo HTML" ,"Endereco do procolo HTML" ,""  ,"","€€€€€€€€€€€€€€ ","","CSF210",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","07","PAM_PREFIX","C",3,0 ,"Prefixo"     ,"Prefixo"     ,"Prefixo"     ,"Prefixo do titulo"        ,"Prefixo do titulo"        ,"Prefixo do titulo"        ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","08","PAM_NUM"   ,"C",9,0 ,"Num. Titulo" ,"Num. Titulo" ,"Num. Titulo" ,"Numero do titulo"         ,"Numero do titulo"         ,"Numero do titulo"         ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","09","PAM_PARCEL","C",2,0 ,"Parcela"     ,"Parcela"     ,"Parcela"     ,"Parcela do titulo"        ,"Parcela do titulo"        ,"Parcela do titulo"        ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","10","PAM_TIPO"  ,"C",3,0 ,"Tipo"        ,"Tipo"        ,"Tipo"        ,"Tipo de titulo"           ,"Tipo de titulo"           ,"Tipo de titulo"           ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","11","PAM_CLIENT","C",6,0 ,"Cliente"     ,"Cliente"     ,"Cliente"     ,"Codigo do cliente"        ,"Codigo do cliente"        ,"Codigo do cliente"        ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","12","PAM_LOJA"  ,"C",2,0 ,"Loja"        ,"Loja"        ,"Loja"        ,"Loja do cliente"          ,"Loja do cliente"          ,"Loja do cliente"          ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","13","PAM_NOMCLI","C",20,0,"Nome Cliente","Nome Cliente","Nome Cliente","Nome do cliente"          ,"Nome do cliente"          ,"Nome do cliente"          ,""  ,"","€€€€€€€€€€€€€€ ","IIF(INCLUI,Space(Len(SA1->A1_NOME)),Posicione('SA1',1,xFilial('SA1')+PAM->PAM_CLIENT+PAM->PAM_LOJA,'A1_NOME'))","",0,"þÀ","","","U","S","V","V","","","","","","","","Posicione('SA1',1,xFilial('SA1')+PAM->PAM_CLIENT+PAM->PAM_LOJA,'A1_NOME')","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","14","PAM_EMISST","D",8,0 ,"Dt.Emiss.Tit","Dt.Emiss.Tit","Dt.Emiss.Tit","Data de emissao do titulo","Data de emissao do titulo","Data de emissao do titulo",""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","15","PAM_VENCTO","D",8,0 ,"Venc. Titulo","Venc. Titulo","Venc. Titulo","Data de vencto. do titulo","Data de vencto. do titulo","Data de vencto. do titulo",""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","16","PAM_VENCRE","D",8,0 ,"Dt.Venc.Real","Dt.Venc.Real","Dt.Venc.Real","Data de vencto. real"     ,"Data de vencto. real"     ,"Data de vencto. real"     ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","17","PAM_ATRASO","N",3,0 ,"Dias atraso" ,"Dias atraso" ,"Dias atraso" ,"Dias atraso"              ,"Dias atraso"              ,"Dias atraso"              ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","18","PAM_ENVMAI","N",2,0 ,"Qt Email Env","Qt Email Env","Qt Email Env","Quant.de email enviado"   ,"Quant.de email enviado"   ,"Quant.de email enviado"   ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","19","PAM_OK"    ,"C",50,0,"Mensagem OK" ,"Mensagem OK" ,"Mensagem OK" ,"Mensagem OK"              ,"Mensagem OK"              ,"Mensagem OK"              ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAM","20","PAM_ERRO"  ,"C",50,0,"Mensag. Erro","Mensag. Erro","Mensag. Erro","Mensagem Erro"            ,"Mensagem Erro"            ,"Mensagem Erro"            ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	//[ SIX - ÍNDICE ]
	AAdd(aSIX,{"PAM","1","PAM_FILIAL+DTOS(PAM_DTENV)+PAM_HRENV"                                 ,"Emissao+Hora"                                 ,"Emissao+Hora"                                 ,"Emissao+Hora"                                 ,"U","","","S"})
	AAdd(aSIX,{"PAM","2","PAM_FILIAL+PAM_PREFIX+PAM_NUM+PAM_PARCEL+PAM_TIPO"                    ,"Prefixo+Num. Titulo+Parcela+Tipo"             ,"Prefixo+Num. Titulo+Parcela+Tipo"             ,"Prefixo+Num. Titulo+Parcela+Tipo"             ,"U","","","S"})
	AAdd(aSIX,{"PAM","3","PAM_FILIAL+PAM_CLIENT+PAM_LOJA+PAM_PREFIX+PAM_NUM+PAM_PARCEL+PAM_TIPO","Cliente+Loja+Prefixo+Num. Titulo+Parcela+Tipo","Cliente+Loja+Prefixo+Num. Titulo+Parcela+Tipo","Cliente+Loja+Prefixo+Num. Titulo+Parcela+Tipo","U","","","S"})
Return

//---------------------------------------------------------------------------------
// Rotina | A210TeleCob | Autor | Rafael Beghini               | Data | 18.09.2018
//---------------------------------------------------------------------------------
// Descr. | Rotina para gravar o registro na rotina do TeleCobrança
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A210TeleCob( aTitMark )
	Local nI 			:= 0
	Local cTime       	:= Time()
	Local cU6_CODIGO  	:= ''
	Local cU4_LISTA   	:= ''
	Local cU5_CODCONT	:= ''
	Local cACF_MOTIVO	:= ''
	Local cACF_OBS		:= 'Processado através da rotina CSFA210'
	Local nStack      	:= GetSX8Len()
	Local aSE1        	:= {}
	Local cACF_CODIGO 	:= ''
	Local cOperador		:= ''
	Local lRet			:= .T.

	// Verificar se o parâmetro existe, do contrário cria-lo.
	cACF_MOTIVO := 'MV_210MOTI'
	
	If .NOT. GetMv( cACF_MOTIVO, .T. )
		CriarSX6( cACF_MOTIVO, 'C', 'CODIGO DO MOTIVO TELECOBRANCA PELO INADIMPLENTES CSFA210.prw', '021759' )
	Endif
	
	cACF_MOTIVO := GetMv( 'MV_210MOTI', .F. )

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
			SU4->U4_DESC    := 'LISTA DE COBRANCA GERADA AUTOMATICAMENTE PELA ROTINA CSFA210'
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
