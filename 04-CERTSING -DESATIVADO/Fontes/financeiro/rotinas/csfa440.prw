//---------------------------------------------------------------------------------
// Rotina | CSFA440     | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina de Telecobrança.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
#Include 'Protheus.ch'

#DEFINE RADIOOK 'NGRADIOOK.PNG'
#DEFINE RADIONO 'NGRADIONO.PNG'

STATIC a440Titulos := {}

User Function CSFA440()
	Local aSay := {}
	Local aButton := {}
	Local nOpc := 0
	Local cPerg := 'CSFA440'

	Private cMV_440ASSU := ''
	Private c440Operador := ''
	Private cCadastro := 'Telecobrança Certisign'

	AAdd( aSay, 'Esta rotina permite que o usuário faça o Telecobrança e gere o relatótio de atendimento no' )
	AAdd( aSay, 'período informado.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch()   } } )
	AAdd( aButton, { 06, .T., { || FechaBatch(), A440Relat() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch()              } } )

	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		If A440PodeUsar()
			A440CriaX1( cPerg )
			If Pergunte( cPerg, .T. )
				A440SelTit()
				a440Titulos := {}
			Endif
		Endif
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440PodeUsar| Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para avaliar se pode ser executada a rotina na íntegra.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440PodeUsar()
	Local lRet := .T.
	Local cMV_440TPOC := ''
	Local cUX_CODTPO := ''
	Local nI := 0
	Local nJ := 0
	
	// Mudar o nível do campo para não haver manipulação do dado.
	SX3->( dbSetOrder( 2 ) )
	If SX3->( dbSeek( 'A1_CONTFIN' ) )
		If SX3->X3_NIVEL <> 9
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_NIVEL := 9
			SX3->( MsUnLock() )
		Endif
	Endif
	
	// Verificar se o parâmetro existe, do contrário cria-lo.
	cMV_440ASSU := 'MV_440ASSU'
	
	If .NOT. GetMv( cMV_440ASSU, .T. )
		CriarSX6( cMV_440ASSU, 'C', 'CODIGO DE ASSUNTO TELECOBRANCA', 'COB001' )
	Endif
	
	cMV_440ASSU := GetMv( 'MV_440ASSU', .F. )
	
	// Criar o código de assunto.
	SX5->( dbSetOrder( 1 ) )
	If .NOT. SX5->( dbSeek( xFilial( 'SX5' ) + 'T1' + cMV_440ASSU ) )
		SX5->( RecLock( 'SX5', .T. ) )
		SX5->X5_FILIAL  := xFilial( 'SX5' )
		SX5->X5_TABELA  := 'T1'
		SX5->X5_CHAVE   := cMV_440ASSU
		SX5->X5_DESCRI  := 'ASSUNTO PARA TELECOBRANCA'
		SX5->X5_DESCSPA := 'ASSUNTO PARA TELECOBRANCA'
		SX5->X5_DESCENG := 'ASSUNTO PARA TELECOBRANCA'
		SX5->( MsUnLock() )
	Endif
	
	// Verificar se o parâmetro existe, do contrário cria-lo.
	cMV_440TPOC := 'MV_440TPOC'
	
	If .NOT. GetMv( cMV_440TPOC, .T. )
		CriarSX6( cMV_440TPOC, 'C', 'CODIGO DO TIPO DE OCORRENCIA TELECOBRANCA', '' )
	Endif
	
	// Criar o tipo de ocorrência.
	If Empty( GetMv( 'MV_440TPOC', .F. ) ) 
		cUX_CODTPO := GetSXENum( 'SUX', 'UX_CODTPO' )
		ConfirmSX8()
		SUX->( dbSetOrder( 1 ) )
		SUX->( RecLock( 'SUX', .T. ) )
		SUX->UX_FILIAL := xFilial( 'SUX' )
		SUX->UX_CODTPO := cUX_CODTPO
		SUX->UX_DESTOC := 'TIPO DE OCORRENCIA TELECOBRANCA'
		SUX->UX_HABTXT := '1'
		SUX->( MsUnLock() )
		PutMv( cMV_440TPOC, cUX_CODTPO )
	Else
		cMV_440TPOC := GetMv( 'MV_440TPOC', .F. )
	Endif
	
   // Criticar se o operador existe.
	SU7->( dbSetOrder( 4 ) )
	If SU7->( dbSeek( xFilial( 'SU7' ) + __cUserId ) )
		If SU7->U7_TIPOATE $ '3|4' // 3=Telecobrança ou 4=todos.
			c440Operador := SU7->U7_COD
		Else
			lRet := .F.
			MsgAlert('Operador ' + RTrim( SU7->U7_NOME ) + ' sem perfil para acesso ao Telecobrança.', cCadastro )
		Endif
	Else
		lRet := .F.
		MsgAlert('Usuário ' + Upper( RTrim( UsrRetName( __cUserId ) ) ) + ' não está cadastrado como operador do Telecobrança.', cCadastro )
	Endif
	
	// Criticar caso não haja as ocorrências cadastradas.
	SU9->( dbSetOrder( 1 ) )
	If .NOT. SU9->( dbSeek( xFilial( 'SU9' ) + cMV_440ASSU ) )
		lRet := .F.
		MsgAlert( 'Não foi localizado código do motivo de ocorrências para o Telecobrança conforme assunto de cobrança '+cMV_440ASSU+;
		          ' e tipo de assunto '+cMV_440TPOC+', por favor fazer o cadastro.', cCadastro )
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A440CriaX1  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para avaliar se existe o grupo de perguntas, do contrário cria.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440CriaX1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}
	
	AAdd( aP, { 'Cliente de?'    ,'C', 6,0,'G','','SA1','','','','','',''})
	AAdd( aP, { 'Cliente ate?'   ,'C', 6,0,'G','(mv_par02>=mv_par01)','SA1','','','','','',''})
	AAdd( aP, { 'Prefixo de?'    ,'C', 3,0,'G','','','','','','','',''})
	AAdd( aP, { 'Prefixo ate?'   ,'C', 3,0,'G','(mv_par04>=mv_par03)','','','','','','',''})
	AAdd( aP, { 'Titulo de?'     ,'C', 9,0,'G','','','','','','','',''})
	AAdd( aP, { 'Titulo ate?'    ,'C', 9,0,'G','(mv_par06>=mv_par05)','','','','','','',''})
	AAdd( aP, { 'Parcela de?'    ,'C', 2,0,'G','','','','','','','',''})
	AAdd( aP, { 'Parcela ate?'   ,'C', 2,0,'G','(mv_par08>=mv_par07)','','','','','','',''})
	AAdd( aP, { 'Emissao de?'    ,'D', 8,0,'G','','','','','','','',''})
	AAdd( aP, { 'Emissao ate?'   ,'D', 8,0,'G','(mv_par10>=mv_par09)','','','','','','',''})
	AAdd( aP, { 'Vencimento de?' ,'D', 8,0,'G','','','','','','','',''})
	AAdd( aP, { 'Vencimento ate?','D', 8,0,'G','(mv_par12>=mv_par11)','','','','','','',''})
	AAdd( aP, { 'Valor de?'      ,'N',12,2,'G','','','','','','','',''})
	AAdd( aP, { 'Valor ate?'     ,'N',12,2,'G','(mv_par14>=mv_par13)','','','','','','',''})
	AAdd( aP, { 'Ordem de?'      ,'N', 1,0,'C','','','Nome + Vencto','Codigo + Vencto','Titulo + Vencto','','',''})
	AAdd( aP, { 'Forma de Pagto?','C',10,0,'G','','','','','','','',''})

	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { '','' } )
	AAdd( aHelp, { 'Quais formas de pagamento?',;
	               'Os tipos podem ser:',;
	               'Branco = título manual',;
	               '1=Boleto, 2=Cartão Crédito',;
	               '3=Cartao Débito, 4=DA, 5=DDA, 6=Voucher',;
	               'Exemplo: [ 134     ]',;
	               'Para as formas branco, 1, 3 e 4.' } )

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

//---------------------------------------------------------------------------------
// Rotina | A440SelTit  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para selecionar cliente/títulos.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440SelTit()
	Local aHeader := {}
	Local aOrdem := {}
	Local aTam := {}
	
	Local cOrd := ''
	Local cSeek := Space(100)
	Local cSQL := ''
	Local cTRB := ''
	Local cAux := ''
	Local cContido := ''
	
	Local lOk := .F.
	Local lTemTipMov := .NOT. Empty( MV_PAR16 )
	
	Local nP := 0
	Local nOrd := 1
	
	Local oConfirm
	Local oDlg 
	Local oLbx 
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oOrdem
	Local oPanelBot
	Local oPanelTop
	Local oPesq 
	Local oSeek 
	Local oVisual
	Local oPosFin
	
	Private aDados := {}
	
	If lTemTipMov
		cContido := FormatIn( RTrim( MV_PAR16 ), ';', 1 )
	Endif

	cSQL := "SELECT   A1_NOME, "
	cSQL += "         E1_CLIENTE, "
	cSQL += "         E1_LOJA, "
	cSQL += "         E1_PREFIXO, "
	cSQL += "         E1_NUM, "
	cSQL += "         E1_PARCELA, "
	cSQL += "         E1_TIPO, "
	cSQL += "         E1_EMISSAO, "
	cSQL += "         E1_VENCTO, "
	cSQL += "         E1_VALOR, "
	cSQL += "         SE1.R_E_C_N_O_ AS E1_RECNO "
	cSQL += "FROM   " + RetSqlName( 'SE1' ) + " SE1 "
	cSQL += "         LEFT JOIN " + RetSqlName( 'SA1' ) + " SA1 "
	cSQL += "                ON A1_FILIAL = " + ValToSql( xFilial( 'SA1' ) ) + " "
	cSQL += "               AND A1_COD = E1_CLIENTE "
	cSQL += "               AND A1_LOJA = E1_LOJA "
	cSQL += "               AND SA1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE    SE1.E1_FILIAL = " + ValToSql( xFilial( "SE1" ) ) + " "
	cSQL += "         AND SE1.E1_CLIENTE BETWEEN " + ValToSql( MV_PAR01 ) + " AND " + ValToSql( MV_PAR02 ) + " "
	cSQL += "         AND SE1.E1_PREFIXO BETWEEN " + ValToSql( MV_PAR03 ) + " AND " + ValToSql( MV_PAR04 ) + " "
	cSQL += "         AND SE1.E1_NUM BETWEEN " + ValToSql( MV_PAR05 ) + " AND " + ValToSql( MV_PAR06 ) + " "
	cSQL += "         AND SE1.E1_PARCELA BETWEEN " + ValToSql( MV_PAR07 ) + " AND " + ValToSql( MV_PAR08 ) + " "
	If lTemTipMov
		cSQL += "         AND SE1.E1_TIPMOV IN " + cContido + " "
	Endif
	cSQL += "         AND SE1.E1_VALOR = SE1.E1_SALDO "
	cSQL += "         AND SE1.E1_EMISSAO BETWEEN " + ValToSql( MV_PAR09 ) + " AND " + ValToSql( MV_PAR10 ) + " "
	cSQL += "         AND SE1.E1_VENCTO BETWEEN " + ValToSql( MV_PAR11 ) + " AND " + ValToSql( MV_PAR12 ) + " "
	cSQL += "         AND SE1.E1_VALOR BETWEEN " + ValToSql( MV_PAR13 ) + " AND " + ValToSql( MV_PAR14 ) + " "
	cSQL += "         AND ( SE1.E1_TIPO = 'CH ' OR SE1.E1_TIPO = 'DP ' OR SE1.E1_TIPO = 'FT ' OR SE1.E1_TIPO = 'NF ' ) "
	cSQL += "         AND SE1.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER BY " + Iif( MV_PAR15==1, "A1_NOME, E1_VENCTO", Iif( MV_PAR15==2, "E1_CLIENTE, E1_VENCTO", "E1_NUM, E1_VENCTO" ) ) + " "
	
	cTRB := GetNextAlias()
	FwMsgRun(,{|| cSQL := ChangeQuery( cSQL ), PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
		(cTRB)->(dbCloseArea())
		Return
	Endif
	
	AAdd( aOrdem, 'Nome cliente' )
	AAdd( aOrdem, 'Código cliente' )
	AAdd( aOrdem, 'Título' )
	AAdd( aOrdem, 'Emissão' )
	AAdd( aOrdem, 'Vencimento' )
	AAdd( aOrdem, 'Valor' )
	
	FwMsgRun(,{|| A440LerDados( cTRB ) },,'Aguarde, lendo dados...')
	(cTRB)->(dbCloseArea())

	aHeader := {'','Nome cliente','Código', 'Loja','Prefixo','Título','Parcela','Tipo','Emissão','Vencto','Valor' }
	aTam := { GetTextWidth(0,'B'),;
	          GetTextWidth(0,'BBBBBBBBBB'),;
	          GetTextWidth(0,'BBBB'),;
	          GetTextWidth(0,'BB'),;
	          GetTextWidth(0,'BBB'),;
	          GetTextWidth(0,'BBBBB'),;
	          GetTextWidth(0,'BBB'),;
	          GetTextWidth(0,'BBB'),;
	          GetTextWidth(0,'BBBB'),;
	          GetTextWidth(0,'BBBB'),;
	          GetTextWidth(0,'BBBBBB') }
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 350,900 PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.

		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP

	   @ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION ( A440Pesq( nOrd, cSeek, @oLbx ) )

	   oLbx := TwBrowse():New(1,1,1000,1000,,aHeader,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	   oLbx:SetArray(aDados)
	   oLbx:aColSizes := aTam
	   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx:bLDblClick := {|| A440MrkCli( @oLbx ) }
	   oLbx:bLine := { || {Iif(aDados[oLbx:nAt,1],oOk,oNo),;
	                           aDados[oLbx:nAt,2],aDados[oLbx:nAt,3],aDados[oLbx:nAt,4],aDados[oLbx:nAt,5],aDados[oLbx:nAt,6],;
	                           aDados[oLbx:nAt,7],aDados[oLbx:nAt,8],aDados[oLbx:nAt,9],aDados[oLbx:nAt,10],aDados[oLbx:nAt,11]}}

		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,1   BUTTON oVisual  PROMPT 'Visualizar'  SIZE 40,11 PIXEL OF oPanelBot ACTION (A440VisTit( oLbx ))
		@ 1,44  BUTTON oPosFin  PROMPT 'Posição Fin' SIZE 40,11 PIXEL OF oPanelBot ACTION (A440PosFin( aDados[ oLbx:nAt, 3 ] + aDados[ oLbx:nAt, 4 ] ))
		@ 1,87  BUTTON oConfirm PROMPT 'Confirmar'   SIZE 40,11 PIXEL OF oPanelBot ACTION (lOk:=Iif(Len(a440Titulos)==0,(MsgAlert('Selecione no mínimo um título',cCadastro),.F.),(oDlg:End(),.T.)))
		@ 1,130 BUTTON oCancel  PROMPT 'Sair'        SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
		
		oLbx:SetFocus()
	ACTIVATE DIALOG oDlg CENTERED
	If lOk
		A440Process(oLbx)
	Endif
Return

Static Function A440PosFin( cCliente )
	SA1->( dbSetOrder( 1 ) )
	SA1->( dbSeek( xFilial( 'SA1' ) + cCliente ) )
	Finc010( 3 )
Return

//---------------------------------------------------------------------------------
// Rotina | A440LerDados | Autor | Robson Gonçalves             | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para ler os dados do retorno da query.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440LerDados( cTRB )
	While .NOT. (cTRB)->( EOF() )
		AAdd( aDados, { .F., ;
							(cTRB)->A1_NOME,;
							(cTRB)->E1_CLIENTE,;
							(cTRB)->E1_LOJA,;
							(cTRB)->E1_PREFIXO,;
							(cTRB)->E1_NUM,;
							(cTRB)->E1_PARCELA,;
							(cTRB)->E1_TIPO,;
							(cTRB)->E1_EMISSAO,;
							(cTRB)->E1_VENCTO,;
							MsPadL( TransForm((cTRB)->E1_VALOR,'@E 999,999,999.99'), 100 ),;
							(cTRB)->E1_RECNO } )
		(cTRB)->( dbSkip() )
	End
Return

//---------------------------------------------------------------------------------
// Rotina | A440Pesq    | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para pesquisar cliente/título.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Pesq( nOrd, cSeek, oLbx )
	Local bAScan := {|| .T. }
	Local nBegin := 0
	Local nColPesq := 0
	Local nEnd := 0
	Local nP := 0
	// nOrd      - é a variável da seleção do ComboBox
	// nColPesq - é a variável que determina a coluna do array a ser pesquisada.
	If     nOrd == 1 ; nColPesq := 2  // Nome cliente
	Elseif nOrd == 2 ; nColPesq := 3  // Código cliente
	Elseif nOrd == 3 ; nColPesq := 6  // Título
	Elseif nOrd == 4 ; nColPesq := 9  // Emissão
	Elseif nOrd == 5 ; nColPesq := 10 // Vencimento
	Elseif nOrd == 6 ; nColPesq := 11 // Valor
	Endif
	If nColPesq > 0
		nBegin := Min( oLbx:nAt + 1, Len( oLbx:aArray ) )
		nEnd   := Len( oLbx:aArray )
		If oLbx:nAt == Len( oLbx:aArray )
			nBegin := 1
		Endif
		// Nome cliente
		If nColPesq==2 
			bAScan := {|p| Upper(AllTrim( cSeek ) ) $ AllTrim( p[nColPesq] ) } 
		Else
			// Emissão ou Vencimento
			If nColPesq==9 .Or. nColPesq==10 
				bAScan := {|p| Ctod( AllTrim( cSeek ) ) == p[nColPesq] } 
			Else 
				// Código, Título, Valor
				bAScan := {|p| Upper(AllTrim( cSeek ) ) == AllTrim( p[nColPesq] ) } 
			Endif
		Endif
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('Informação não localizada.','Pesquisar')
		Endif
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440VisTit  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para visualizar na íntegra os dados do título.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440VisTit( oLbx )
	SE1->( dbGoTo( aDados[ oLbx:nAt, 12 ] ) )
	If SE1->( RecNo() ) == aDados[ oLbx:nAt, 12 ]
		AxVisual( 'SE1', SE1->( Recno() ), 2 )
	Else
		MsgAlert('Não localiei o registro', cCadastro )
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440MrkCli  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para selecionar cliente/título.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440MrkCli( oLbx )
	Local nP := 0
	// Está marcado?
	If aDados[ oLbx:nAt, 1 ]
		// Achar o RecNo
		nP := AScan( a440Titulos, {|p| p[1]==aDados[ oLbx:nAt, 12 ] } )
		If nP > 0
			aDados[ oLbx:nAt, 1 ] := .NOT. aDados[ oLbx:nAt, 1 ]
			// Apagar o elemento do array.
			ADel( a440Titulos, nP )
			// Refazer o array.
			ASize( a440Titulos, Len( a440Titulos )-1 )
		Endif
	Else
		// Existe dados no array?
		If Len( a440Titulos ) > 0
			// É o mesmo cliente+loja
			nP := AScan( a440Titulos, {|p| p[2]==aDados[ oLbx:nAt, 3 ]+aDados[ oLbx:nAt, 4 ] } )
			// Se não for mesmo cliente+loja não fazer nada e alertar a crtica para o usuário.
			If nP == 0
				MsgAlert('Somente código e loja do mesmo cliente podem ser selecionado.', cCadastro )
			Else
				// Acrescentar os dados no array.
				AAdd( a440Titulos, { aDados[ oLbx:nAt, 12 ], aDados[ oLbx:nAt, 3 ] + aDados[ oLbx:nAt, 4 ] } )
				aDados[ oLbx:nAt, 1 ] := .NOT. aDados[ oLbx:nAt, 1 ]
			Endif
		Else
			// Se não houver dados do array, apenas acrescente.
			AAdd( a440Titulos, { aDados[ oLbx:nAt, 12 ], aDados[ oLbx:nAt, 3 ] + aDados[ oLbx:nAt, 4 ] } )
			aDados[ oLbx:nAt, 1 ] := .NOT. aDados[ oLbx:nAt, 1 ]
		Endif
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440Process | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para processar os dados que foram selecionados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Process( oLbx )
	Local oDlg
	Local oPnlAll
	Local oPnlBot
	Local oScroll
	Local oCliente
	Local oGravar
	Local oSair
	Local oGride
	Local oPnlGrd
	Local oTMultiGet
	Local oInadimp
	Local oPosFin

	Local lTudOK := .F.
	Local lGrv := .F. 
	Local nI := 0
	Local nX := 0
	Local nP := 0
	Local nElem := 0
	Local nTotal := 0
	Local aCpoSE1 := {'E1_PREFIXO','E1_NUM','E1_PARCELA','E1_TIPO','E1_EMISSAO','E1_VENCTO','E1_VALOR','ACF_DATA','ACF_DATA','E1_CLIENTE','E1_LOJA'}
	Local aMinMax := {}
	
	Private a440SU5 := {}
	
	Private cACF_PREVIS := ''
	Private dACF_PREVIS := Ctod( Space( 8 ) )
	Private cACF_MOTIVO := Space( Len( ACF->ACF_MOTIVO ) )
	Private cACF_DESCMO := Space( Posicione( 'SX3', 2, 'ACF_DESCMO', 'X3_TAMANHO' ) ) 
	Private cACF_OBS := CriaVar( 'ACF_OBS', .F. )
	Private cU5_CODCONT := Space( Len( SU5->U5_CODCONT ) )
	Private cU5_CONTAT := Space( Len( SU5->U5_CONTAT ) )

	Private aHeader := {}
	Private aCOLS := {}

	Private __nExec := 0

	INCLUI := .T.
	ALTERA := .F.
	
	AAdd( aHeader, { '   x','GD_MARK', '@BMP', 1, 0, '', '', '', '', ''} )

	SX3->( dbSetOrder( 2 ) )
	For nX := 1 To Len(aCpoSE1)
		If SX3->( DbSeek(aCpoSE1[nX]) )
			AAdd(aHeader,{Trim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT})			
		Endif
	Next nX
	
	nP := AScan( aHeader, {|p| RTrim( p[ 2 ] ) == 'ACF_DATA' } )
	If nP > 0
		aHeader[ nP,   1 ] := '1ª Interação'
		aHeader[ nP+1, 1 ] := 'Úl.Interação'
	Endif

	SE1->( dbSetOrder( 1 ) )
	For nX := 1 To Len( a440Titulos )
		SE1->( dbGoTo( a440Titulos[ nX, 1 ] ) )
	   AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
	   nElem := Len( aCOLS )
		For nI := 2 To Len( aHeader )
			If RTrim( aHeader[ nI, 1 ] ) <> 'ACF_DATA'
				aCOLS[ nElem, nI ] := SE1->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) )
			Endif
		Next nI
		aCOLS[ nElem, 1 ] := RADIOOK
		aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.
		nTotal += SE1->E1_VALOR
		
		// Buscar a primeira e a última interação.
		aMinMax := A440Interacao( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_CLIENTE, SE1->E1_LOJA  )
		
		aCOLS[ nElem, nP   ] := StoD( aMinMax[ 1 ] )
		aCOLS[ nElem, nP+1 ] := StoD( aMinMax[ 2 ] )
	Next nX
	
	// Rotina para verificar se há contato no cadastro de clientes.
	A440HaCont()
	
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd FROM 0,0 TO 360,630 PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oPnlAll := TPanel():New(0,0,,oDlg,,,,,,13,0,.F.,.F.)
		oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT

		oPnlGrd := TPanel():New(0,0,,oPnlAll,,,,,,0,63,.F.,.F.)
		oPnlGrd:Align := CONTROL_ALIGN_TOP

		oPnlBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlBot:Align := CONTROL_ALIGN_BOTTOM

	   oScroll := TScrollBox():New(oPnlAll,1,1,100,100,.T.,.F.,.T.)
	   oScroll:Align := CONTROL_ALIGN_ALLCLIENT
	   
		@  2, 3 SAY 'Contato' COLOR CLR_HBLUE SIZE 50,8 PIXEL OF oScroll
		@ 10, 3 MSGET cU5_CODCONT F3 '440SU5' PICTURE '@!'  SIZE 30,8 PIXEL OF oScroll

		@  2, 38 SAY 'Nome e telefone do contato' SIZE 90,8 PIXEL OF oScroll
		@ 10, 38 MSGET cU5_CONTAT /*PICTURE '@!'*/ WHEN .F. SIZE 272,8 PIXEL OF oScroll

		@ 22, 3 SAY 'Motivo' COLOR CLR_HBLUE SIZE 50,8 PIXEL OF oScroll
		@ 30, 3 MSGET cACF_MOTIVO PICTURE '@!' F3 '440SU9' VALID A440Motivo(0,cACF_MOTIVO,@cACF_DESCMO) SIZE 30,8 PIXEL OF oScroll
		
		@ 22, 260 SAY 'Previsão pagto.' COLOR CLR_HBLUE SIZE 50,8 PIXEL OF oScroll
		@ 30, 260 MSGET dACF_PREVIS PICTURE '99/99/9999' SIZE 50,8 PIXEL OF oScroll

		@ 42, 3 SAY 'Observação' COLOR CLR_HBLUE SIZE 50,8 PIXEL OF oScroll
		oTMultiGet := TMultiGet():New( 50, 3, {| u | Iif( PCount() > 0, cACF_OBS := u, cACF_OBS ) }, oScroll, 250, 50,,,,,,.T.)
		
		@ 22, 38 SAY 'Descrição do motivo' SIZE 50,8 PIXEL OF oScroll
		@ 30, 38 MSGET cACF_DESCMO PICTURE '@!' WHEN .F. SIZE 216,8 PIXEL OF oScroll

		@ 42, 260 SAY 'Total selecionado' SIZE 50,8 PIXEL OF oScroll
		@ 50, 260 MSGET oTotal VAR nTotal PICTURE '@E 999,999,999.99' WHEN .F. SIZE 50,8 PIXEL OF oScroll
		
		@ 1, 44 BUTTON oGravar  PROMPT 'Gravar'  SIZE 40,11 PIXEL OF oPnlBot ACTION ;
		( lTudOK := A440Contato( cU5_CODCONT ) .AND. A440Motivo( 1, cACF_MOTIVO, @cACF_DESCMO, nTotal ) .AND. A440Previsao( dACF_PREVIS ) .AND. A440Obs( cACF_OBS ), ;
		Iif( lTudOK, Iif( MsgYesNo('Confirma a gravação dos dados',cCadastro), ( ( lGrv:=.T. ) ,oDlg:End() ), NIL), NIL ) )
		
		@ 1,  1 BUTTON oCliente PROMPT 'Cliente'       SIZE 40,11 PIXEL OF oPnlBot ACTION A440VisCli()
		@ 1, 87 BUTTON oInadimp PROMPT 'Inadimplentes' SIZE 40,11 PIXEL OF oPnlBot ACTION A440Inadim( oGride )
		@ 1,130 BUTTON oPosFin  PROMPT 'Posição Fin.'  SIZE 40,11 PIXEL OF oPnlBot ACTION A440PosFin( oGride:aCOLS[ 1, GdFieldPos( 'E1_CLIENTE', oGride:aHeader ) ]+;
		                                                                                              oGride:aCOLS[ 1, GdFieldPos( 'E1_LOJA',    oGride:aHeader ) ] )
		@ 1,173 BUTTON oSair    PROMPT 'Sair'          SIZE 40,11 PIXEL OF oPnlBot ACTION (oDlg:End())
		
		oGride := MsNewGetDados():New(0,0,1000,1000,0,,,,,,Len(aCOLS),,,,oPnlGrd,aHeader,aCOLS)
		oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		oGride:oBrowse:bLDblClick := {||  A440MrkTit( @oGride, @oTotal, @nTotal ), oGride:Refresh() }
		oGride:oBrowse:bHeaderClick := {|oObj,nColumn| A440Head( nColumn, @oGride ) }
	ACTIVATE MSDIALOG oDlg CENTERED
	If lTudOk .AND. lGrv
		Begin Transaction
			Processa( {|| A440Gravar( oGride ) }, cCadastro,, .F. )
		End Transaction
		MsgInfo('Operação concluída.', cCadastro )
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440Head    | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para marcar/desmacar todos os registros de títulos.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Head( nColumn, oGride )
	Local lMrk
	__nExec++
	If (__nExec%2) == 0
		Return
	Endif
	If nColumn == 1
		lMrk := AScan( oGride:aCOLS, {|e| e[ 1 ] == RADIOOK } ) > 0
		AEval( oGride:aCOLS, {|e| e[ 1 ] := Iif(lMrk,RADIONO,RADIOOK) } )
		oGride:Refresh()
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440HaCont  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para verificar se o contato do cadastro de cliente já possui o
//        | relacionamento do cadastro de contato com o cadastro de clientes.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440HaCont()
	Local lContinua := .T.
	Local lA1_CONTFIN := .F.
	Local lA1_CONTATO := .F.
	Local aRet := {}
	Local aPar := {}
	Local nTentativa := 0
	
	// Posicionar no cliente.
	SA1->( dbSetOrder( 1 ) )
	SA1->( dbSeek( xFilial( 'SA1' ) + a440Titulos[ 1, 2 ] ) )
	
	// Possui integração SA1 com SU5? Então capturar os dados.
	If .NOT. Empty( SA1->A1_CONTFIN )
		cU5_CODCONT := RTrim( Left( SA1->A1_CONTFIN, 6 ) )	
		SU5->( dbSetOrder( 1 ) ) 
		If SU5->( dbSeek( xFilial( 'SU5' ) + cU5_CODCONT ) )
			lA1_CONTFIN := .T.
			// Atribuir os dados do contato a variável.
			A440Atrib(0)
		Endif
	Endif
	
	// Se não possuir integração SA1 com SU5, tentar fazer a integração.
	If .NOT. lA1_CONTFIN	
		If .NOT. Empty( SA1->A1_CONTATO ) .AND. .NOT. Empty( SA1->A1_TEL ) .AND. .NOT. Empty( SA1->A1_EMAIL )
			lA1_CONTATO := .T.
			// Gerar o contato e sua relação com o SA1.
			A440GeraCont()
			// Atribuir os dados do contato a variável.
			A440Atrib(0)
		Endif
	Endif
	
	// Se não possuir integração SA1 com SU5 e não conseguir fazer a integração, então solicitar para o usuário os dados.
	If .NOT. lA1_CONTFIN .AND. .NOT. lA1_CONTATO
		SX3->( dbSetOrder( 2 ) )
		SX3->( dbSeek( 'A1_CONTATO' ) ) ; AAdd( aPar, { 1, RTrim(SX3->X3_TITULO), SA1->A1_CONTATO, '@!', '', '', '', 120, .T. } )
		SX3->( dbSeek( 'A1_DDD' ) )     ; AAdd( aPar, { 1, RTrim(SX3->X3_TITULO), SA1->A1_DDD    , '@!', '', '', '', 030, .T. } )
		SX3->( dbSeek( 'A1_TEL' ) )     ; AAdd( aPar, { 1, RTrim(SX3->X3_TITULO), SA1->A1_TEL    , '@!', '', '', '', 060, .T. } )
		SX3->( dbSeek( 'A1_EMAIL' ) )   ; AAdd( aPar, { 1, RTrim(SX3->X3_TITULO), SA1->A1_EMAIL  , ''  , '', '', '', 120, .T. } )
		
		While lContinua .AND. nTentativa < 3
			nTentativa++
			If ParamBox( aPar, 'Informe/complentre os dados para prosseguir', @aRet )
				lContinua := .F.
				// Gerar o contato e sua relação com o SA1.
				A440GeraCont( aRet )
				// Atribuir os dados do contato a variável.
				A440Atrib(0)
			Else
				MsgInfo('Para prosseguir com o Telecobrança é obrigatório possuir contato.',cCadastro)
			Endif
		End
		If lContinua
			MsgAlert('Para registrar o atendimento do Telecobrança será preciso informar um contato existente.',cCadastro)
		Endif
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440Atrib   | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para atribuir dados a variável da interface.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Atrib( nPos )
   Local cDDD := ''
   Local cFone := ''
   Local cFCom1 := ''
   Local cCelular := ''
   Local cOutros := ''
	Local cEmail := ''
	
	DEFAULT nPos := 0
	
	/*
	cU5_CONTAT := SU5->( RTrim( U5_CONTAT ) + ' ' + ;
	Iif( Empty( U5_FONE )   , '', '- Tel.Res. '  + RTrim( RTrim( U5_DDD ) + Iif( Empty( U5_DDD ), '', '-' ) + U5_FONE ) ) + ;
	Iif( Empty( U5_FCOM1 )  , '', '- Tel.Com.1 ' + RTrim( U5_FCOM1 ) ) + ;
	Iif( Empty( U5_CELULAR ), '', '- Celular '   + RTrim( U5_CELULAR ) ) + ;
	Iif( Empty( U5_EMAIL )  , '', '- EMail '     + RTrim( Lower( RTrim( U5_EMAIL ) ) ) ) )
	*/

	If nPos==0
		cDDD     := Iif( Empty( SU5->U5_DDD )    , '', '- DDD '       + RTrim( SU5->U5_DDD ) )
		cFone    := Iif( Empty( SU5->U5_FONE )   , '', '- Tel.Res. '  + RTrim( SU5->U5_FONE ) )
		cFCom1   := Iif( Empty( SU5->U5_FCOM1 )  , '', '- Tel.Com.1 ' + RTrim( SU5->U5_FCOM1 ) )
		cCelular := Iif( Empty( SU5->U5_CELULAR ), '', '- Celular '   + RTrim( SU5->U5_CELULAR ) )
		cEmail   := Iif( Empty( SU5->U5_EMAIL )  , '', '- EMail '     + Lower( RTrim( SU5->U5_EMAIL ) ) )
	Else
		cFone    := Iif( Empty( a440SU5[ nPos, 2 ] ), '', '- Tel.Res. '  + RTrim( a440SU5[ nPos, 2 ] ) )
		cFCom1   := Iif( Empty( a440SU5[ nPos, 3 ] ), '', '- Tel.Com.1 ' + RTrim( a440SU5[ nPos, 3 ] ) )
		cCelular := Iif( Empty( a440SU5[ nPos, 4 ] ), '', '- Celular '   + RTrim( a440SU5[ nPos, 4 ] ) )
		cOutros  := Iif( Empty( a440SU5[ nPos, 5 ] ), '', '- Outros '    + RTrim( a440SU5[ nPos, 5 ] ) )
		cEmail   := Iif( Empty( a440SU5[ nPos, 6 ] ), '', '- EMail '     + Lower( RTrim( a440SU5[ nPos, 6 ] ) ) )
	Endif
	cU5_CONTAT := RTrim( SU5->U5_CONTAT ) + cDDD + cFone + cFCom1 + cCelular + cEmail
Return

//---------------------------------------------------------------------------------
// Rotina | A440GeraCont| Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para gravar a integração do SA1 com SU5 e AC8.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440GeraCont( aRet )
	Local cA1_CONTATO := Iif(aRet==NIL,SA1->A1_CONTATO,aRet[1])
	Local cA1_DDD     := Iif(aRet==NIL,SA1->A1_DDD    ,aRet[2])
	Local cA1_TEL     := Iif(aRet==NIL,SA1->A1_TEL    ,aRet[3])
	Local cA1_EMAIL   := Iif(aRet==NIL,SA1->A1_EMAIL  ,aRet[4])
	
	cU5_CODCONT := GetSXENum( "SU5", "U5_CODCONT" )
	ConfirmSX8()
	
	Begin Transaction
		SU5->( RecLock( 'SU5', .T. ) )
		SU5->U5_FILIAL  := xFilial('SU5')
		SU5->U5_CODCONT := cU5_CODCONT
		SU5->U5_CONTAT  := cA1_CONTATO
		SU5->U5_DDD     := cA1_DDD
		SU5->U5_FONE    := cA1_TEL
		SU5->U5_EMAIL   := cA1_EMAIL
		SU5->( MsUnLock() )
		
		AC8->( RecLock( 'AC8', .T. ) )
		AC8->AC8_FILIAL := xFilial( 'AC8' )
		AC8->AC8_FILENT := xFilial( 'SA1' )
		AC8->AC8_ENTIDA := 'SA1'
		AC8->AC8_CODENT := SA1->A1_COD + SA1->A1_LOJA
		AC8->AC8_CODCON := cU5_CODCONT
		AC8->( MsUnLock() )
		
		SA1->( RecLock( 'SA1', .F. ) )
		SA1->A1_CONTFIN := cU5_CODCONT
		SA1->( MsUnLock() )
	End Transaction
Return

//---------------------------------------------------------------------------------
// Rotina | A440LoadU5  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para carregar os contatos do cliente.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440LoadU5()
	Local cAGB_TELEFO := ''
	
	AC8->( dbSetOrder( 2 ) )
	AC8->( dbSeek( xFilial( 'AC8' ) + 'SA1' + xFilial( 'SA1' ) + a440Titulos[ 1, 2 ] ) )
	While .NOT. AC8->(EOF()) .AND. AC8->AC8_FILIAL==xFilial('AC8') .AND. AC8->AC8_ENTIDA=='SA1' .AND. AC8->AC8_FILENT==xFilial('SA1') .AND. RTrim(AC8->AC8_CODENT)==a440Titulos[ 1, 2 ]
		SU5->( dbSetOrder( 1 ) )
		SU5->( dbSeek( xFilial( 'SU5' ) + RTrim(AC8->AC8_CODCON) ) )
		
		AGB->( dbSetOrder( 2 ) )
		AGB->( dbSeek( xFilial( 'AGB' ) + RTrim( AC8->AC8_CODCON ) ) )
		
		While .NOT. AGB->( EOF() ) .AND. AGB->AGB_FILIAL == xFilial( 'AGB' ) .AND. AGB->AGB_CODIGO == RTrim( AC8->AC8_CODCON )
			cAGB_TELEFO += Iif( Empty( AGB->AGB_DDD ), '', RTrim( AGB->AGB_DDD ) + '-' ) + AGB->AGB_TELEFO + '/'
			AGB->( dbSkip() )
		End
		
		If .NOT. Empty( cAGB_TELEFO )
			cAGB_TELEFO := SubStr( cAGB_TELEFO, 1, Len( cAGB_TELEFO )-1 )
		Endif
		
		SU5->( AAdd( a440SU5, { Upper(RTrim(U5_CONTAT)), ;
		                        RTrim( U5_DDD ) + Iif( Empty( U5_DDD ), '', '-' ) + U5_FONE, ;
		                        U5_FCOM1, ;
		                        U5_CELULAR, ;
		                        cAGB_TELEFO, ;
		                        Lower( RTrim( U5_EMAIL ) ), ;
		                        'SU5' + U5_CODCONT } ) )
		cAGB_TELEFO := ''
		
		AC8->( dbSkip() )
	End
Return

//---------------------------------------------------------------------------------
// Rotina | A440Inadim  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para buscar registro da tabela de inadimplentes.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Inadim( oGride )
	Local oDlg
	Local oLbx 
	Local oPnl
	Local oCons
	Local oSair 
	Local cKey := ''
	Local aRecNo := {}
	Local cCliente := oGride:aCOLS[ oGride:nAt, GdFieldPos( 'E1_CLIENTE', oGride:aHeader ) ]
	Local cLoja    := oGride:aCOLS[ oGride:nAt, GdFieldPos( 'E1_LOJA'   , oGride:aHeader ) ]
	Local cPrefixo := oGride:aCOLS[ oGride:nAt, GdFieldPos( 'E1_PREFIXO', oGride:aHeader ) ]
	Local cNum     := oGride:aCOLS[ oGride:nAt, GdFieldPos( 'E1_NUM'    , oGride:aHeader ) ]
	Local cParcela := oGride:aCOLS[ oGride:nAt, GdFieldPos( 'E1_PARCELA', oGride:aHeader ) ]
	Local cTipo    := oGride:aCOLS[ oGride:nAt, GdFieldPos( 'E1_TIPO'   , oGride:aHeader ) ]
	
	cKey := xFilial( 'PAM' ) + cCLiente + cLoja + cPrefixo + cNum + cParcela + cTipo 
	
	PAM->( dbSetOrder( 3 ) ) 
	PAM->( dbSeek( cKey ) )
	While ( .NOT. PAM->( EOF() ) ) .AND. PAM->PAM_FILIAL == xFilial( 'PAM' ) .AND. ;
		PAM->PAM_CLIENT == cCliente .AND. PAM->PAM_LOJA == cLoja .AND. PAM->PAM_PREFIX == cPrefixo .AND. ;
		PAM->PAM_NUM == cNum .AND. PAM->PAM_PARCEL == cParcela .AND. PAM->PAM_TIPO == cTipo
		PAM->( AAdd( aRecNo, { PAM_DTENV, PAM_HRENV, PAM_ENVMAI, RecNo() } ) )	
      PAM->( dbSkip() )
 	End
 	
 	If Len( aRecNo ) == 0
 		MsgAlert( 'O título em questão não está registrado nos controles do envio de email para inadimplentes.', cCadastro )
 	Else
 		If Len( aRecNo ) == 1
 			A440VisInad( aRecNo[ 1, 4 ] )
 		Else
 			ASort( aRecNo, , ,{ |a,b| DtoS( a[ 1 ] ) + a[ 2 ] < DtoS( b[ 1 ] ) + b[ 2 ] } )
			DEFINE MSDIALOG oDlg TITLE 'QUAL REGISTRO DE INADIMPLENTES QUER CONSULTAR?' FROM 0,0 TO 200,400 PIXEL
			   oLbx := TwBrowse():New(0,0,0,0,,{'DT. do Envio','HR. do Envio','Qt Email Env'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
			   oLbx:SetArray( aRecNo )
				oLbx:bLine := {|| { aRecNo[ oLbx:nAt, 1 ], aRecNo[ oLbx:nAt, 2 ], aRecNo[ oLbx:nAt, 3 ] } }
				oLbx:bLDblClick := {||  A440VisInad( aRecNo[ oLbx:nAt, 4 ] ) }
				oPnl := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
				oPnl:Align := CONTROL_ALIGN_BOTTOM
				@ 1, 1 BUTTON oCons PROMPT 'Consultar' SIZE 40,11 PIXEL OF oPnl ACTION A440VisInad( aRecNo[ oLbx:nAt, 4 ] )
				@ 1,44 BUTTON oSair PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPnl ACTION oDlg:End()
			ACTIVATE MSDIALOG oDlg CENTER
 		Endif
 	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440VisInad | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para consultar na íntegra os dados do registro de inadimplentes.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440VisInad( nRecNo )
	PAM->( dbGoTo( nRecNo ) )
	INCLUI := .F.
	ALTERA := .F.
	AxVisual( 'PAM', nRecNo, 2 )
Return

//---------------------------------------------------------------------------------
// Rotina | A440Gravar  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para gravar os dados da interação.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Gravar( oGride )
	Local nI := 0
	Local nE1_CLIENTE := GdFieldPos( 'E1_CLIENTE', oGride:aHeader )
	Local nE1_LOJA    := GdFieldPos( 'E1_LOJA', oGride:aHeader )
	Local nE1_PREFIXO := GdFieldPos( 'E1_PREFIXO', oGride:aHeader )
	Local nE1_NUM     := GdFieldPos( 'E1_NUM', oGride:aHeader )
	Local nE1_PARCELA := GdFieldPos( 'E1_PARCELA', oGride:aHeader )
	Local nE1_TIPO    := GdFieldPos( 'E1_TIPO', oGride:aHeader )
	Local cU4_LISTA   := ''
	Local cU4_DESC    := ''
	Local cTime       := Time()
	Local cU6_CODIGO  := ''
	Local cU4_LISTA   := ''
	Local nStack      := GetSX8Len()
	Local aSE1        := {}
	Local cACF_CODIGO := ''
	
	ProcRegua( 6 )
	IncProc('Gerando referências do contas a receber.')
	
	// Ler todos os títulos.
	For nI := 1 To Len( oGride:aCOLS )
		// O título está marcado?
		If oGride:aCOLS[ nI, 1 ] == RADIOOK
			// Posicionar no registro do títulos.
			SE1->( dbSetOrder( 2 ) )
			SE1->( dbSeek( xFilial( 'SE1' ) + oGride:aCOLS[nI,nE1_CLIENTE] + oGride:aCOLS[nI,nE1_LOJA] + oGride:aCOLS[nI,nE1_PREFIXO] + oGride:aCOLS[nI,nE1_NUM] + oGride:aCOLS[nI,nE1_PARCELA] + oGride:aCOLS[nI,nE1_TIPO] ) )
			// Pesquisar para saber se o título já foi para o telecobrança.
 			SK1->( dbSetOrder( 1 ) )
 			If SK1->( dbSeek( xFilial( 'SK1' ) + oGride:aCOLS[nI,nE1_PREFIXO] + oGride:aCOLS[nI,nE1_NUM] + oGride:aCOLS[nI,nE1_PARCELA] + oGride:aCOLS[nI,nE1_TIPO] + xFilial( 'SE1' ) ) )
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
				SK1->K1_OPERAD  := c440Operador
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
		Endif
	Next nI
	
	IncProc('Gerando agenda do operador.')

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
		SU4->U4_DESC    := 'LISTA DE COBRANCA GERADA AUTOMATICAMENTE PELA ROTINA CSFA440'
		SU4->U4_DATA    := dDataBase
		SU4->U4_DTEXPIR := dDataBase
		SU4->U4_HORA1   := cTime
		SU4->U4_FORMA   := '1' //1=Voz;2=Fax;3=CrossPosting;4=Mala Direta;5=Pendencia;6=WebSite.
		SU4->U4_TELE    := '3' //1=Telemarkeing;2=Televendas;3=Telecobrança;4=Todos;5=Teleatendimento.
		SU4->U4_OPERAD  := c440Operador
		SU4->U4_TIPOTEL := '4' //1=Residencial;2=Celular;3=Fax;4=Comercial 1;5=Comercial 2.
		SU4->U4_NIVEL   := '1' //1=Sim;2=Nao.
		SU4->U4_CODLIG  := ''
		SU4->U4_XDTVENC := dDataBase
		SU4->U4_XGRUPO  := SU7->( Posicione( 'SU7', 1, xFilial( 'SU7' ) + c440Operador, 'U7_POSTO' ) )
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
		SU6->U6_CODENT  := oGride:aCOLS[ 1, nE1_CLIENTE ] + oGride:aCOLS[ 1, nE1_LOJA ]
		SU6->U6_ORIGEM  := '2' //1=Lista;2=Manual;3=Atendimento.
		SU6->U6_DATA    := dDataBase
		SU6->U6_HRINI   := cTime
		SU6->U6_HRFIM   := cTime
		SU6->U6_STATUS  := '3' //1=Nao Enviado;2=Em uso;3=Enviado.
		SU6->U6_CODLIG  := ''
		SU6->U6_DTBASE  := dDataBase
		SU6->U6_CODOPER := c440Operador
		SU6->( MsUnLock() )
	
		cACF_CODIGO := GetSXENum('ACF','ACF_CODIGO')
		While GetSX8Len() > nStack
			ConfirmSX8()
		End

		IncProc('Gerando registros do Telecobrança.')
		
		ACF->( dbSetOrder( 1 ) )
		ACF->( RecLock( 'ACF', .T. ) )
		ACF->ACF_FILIAL := xFilial( 'ACF' )
		ACF->ACF_CODIGO := cACF_CODIGO
		ACF->ACF_CLIENT := oGride:aCOLS[ 1, nE1_CLIENTE ]
		ACF->ACF_LOJA   := oGride:aCOLS[ 1, nE1_LOJA ]
		ACF->ACF_CODCON := cU5_CODCONT
		ACF->ACF_OPERAD := c440Operador
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
		ACF->ACF_PREVIS := dACF_PREVIS
		cACF_OBS := cACF_OBS + CRLF + cACF_PREVIS
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
Return

//---------------------------------------------------------------------------------
// Rotina | A440MrkTit  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina p/ marcar/desmarcar o título a para o registro de telecobrança.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440MrkTit( oGride, oTotal, nTotal )
	If oGride:aCOLS[ oGride:nAt, 1 ] == RADIOOK
		nTotal -= aCOLS[ oGride:nAt, GdFieldPos('E1_VALOR') ]
		oGride:aCOLS[ oGride:nAt, 1 ] := RADIONO
	Else
		nTotal += aCOLS[ oGride:nAt, GdFieldPos('E1_VALOR') ] 
		oGride:aCOLS[ oGride:nAt, 1 ] := RADIOOK
	Endif
	oTotal:Refresh()
Return

//---------------------------------------------------------------------------------
// Rotina | A440Contato | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para criticar o código do contato.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Contato( cU5_CODCONT )
	Local lRet := ExistCpo( 'SU5', cU5_CODCONT )
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A440Motivo  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para criticar o código do motivo.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Motivo( nLigado, cCodMot, cDescMot, nTotal )
	Local lRet := .T.
	If Empty( cCodMot ) .And. nLigado==0
		lRet := .T.
	Else
		lRet := ExistCpo( 'SU9', cMV_440ASSU + cCodMot )
		If lRet
			cDescMot := Posicione( 'SU9', 1, xFilial( 'SU9' ) + cMV_440ASSU + cCodMot, 'U9_DESC' )
			If nTotal == 0
				MsgAlert('É obrigatório selecionar pelo menos um título.',cCadastro)
				lRet := .F.
			Endif
		Endif
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A440Previsao| Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para criticar a data de previsão de pagamento.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Previsao( dPrevisao )
	Local dMsDate := MsDate()
	Local lRet := .T.
	If Empty( dPrevisao )
		If MsgYesNo( 'A data de previsão para pagamento não foi informada. Quer informar agora?', cCadastro )
			lRet := .F.
		Else
			cACF_PREVIS := 'Não foi informado a data de previsão de pagamento.'
		Endif
	Else
		lRet := dPrevisao >= dMsDate
		If .NOT. lRet
			MsgAlert( 'A data de previsão para pagamento precisa ser maior ou igual a data de hoje: ' + Dtoc( dMsDate ), cCadastro )
		Endif
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A440Obs     | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para criticar se o campo observação foi preenchido.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Obs( cObs )
	Local lRet := .T.
	If Empty( cObs )
		lRet := .F.
		MsgAlert( 'O campo observação é de preenchimento obrigatório.', cCadastro)
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A440VisCli  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para visualizar na íntegra os dados do contato.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440VisCli()
	SA1->( dbSetOrder( 1 ) )
	SA1->( dbSeek( xFilial( 'SA1' ) + a440Titulos[ 1, 2 ] ) )
	AxVisual( 'SA1', SA1->( RecNo() ), 2 )
Return

//---------------------------------------------------------------------------------
// Rotina | A440XBU5    | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para consultar os diversos contato do cliente.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A440XBU5()
	Local nChoice := 1
	Local nOpc := 0
	Local oConfirm
	Local oDlgC
	Local oLbxC
	Local oVisual
	Local oIncCont
		
	// Buscar todos os registro do relacionamento do cadastro de contato com o cliente.
	If Len( a440SU5 ) == 0
		FwMsgRun(,{|| A440LoadU5()},,'Aguarde, buscando contatos...')
	Endif
	
	If Len( a440SU5 ) == 0
		cU5_CODCONT := Space( Len( SU5->U5_CODCONT ) )
		cU5_CONTAT  := Space( Len( SU5->U5_CONTAT ) )
		
		If MsgYesNo('Não foi localizado contato para este cliente, quer cadastrar agora?', cCadastro )
			SU5->( dbSetOrder( 1 ) )
			nOpc := A70Inclui( 'SU5', 0, 3 )
			SU5->( dbCommit() )
			AGB->( dbCommit() )
			
			If nOpc == 1
				AC8->( dbSetOrder( 1 ) )
				AC8->( RecLock( 'AC8', .T. ) )
				AC8->AC8_FILIAL := xFilial( 'AC8')
				AC8->AC8_FILENT := xFilial( 'SA1' )
				AC8->AC8_ENTIDA := 'SA1'
				AC8->AC8_CODENT := aCOLS[ 1, GdFieldPos('E1_CLIENTE') ] + aCOLS[ 1, GdFieldPos('E1_LOJA') ]
				AC8->AC8_CODCON := SU5->U5_CODCONT
				AC8->( MsUnLock() )
				AC8->( dbCommit() )
				
				A440LoadU5(2)

				cU5_CODCONT := SU5->U5_CODCONT
				
				/*
				cU5_CONTAT := RTrim( SU5->U5_CONTAT ) + ' ' + ;
				Iif( Empty( a440SU5[ nChoice, 2 ] ), '', '- Tel.Res. '  + RTrim( a440SU5[ nChoice, 2 ] ) ) + ;
				Iif( Empty( a440SU5[ nChoice, 3 ] ), '', '- Tel.Com.1 ' + RTrim( a440SU5[ nChoice, 3 ] ) ) + ;
				Iif( Empty( a440SU5[ nChoice, 4 ] ), '', '- Celular '   + RTrim( a440SU5[ nChoice, 4 ] ) ) + ;
				Iif( Empty( a440SU5[ nChoice, 5 ] ), '', '- Outros '    + RTrim( a440SU5[ nChoice, 5 ] ) ) + ;
				Iif( Empty( a440SU5[ nChoice, 6 ] ), '', '- EMail '     + RTrim( a440SU5[ nChoice, 6 ] ) ) 
				*/
				A440Atrib(1)
				
			Endif
		Endif
	Else
		DEFINE MSDIALOG oDlgC FROM 300,20 TO 560,680 TITLE 'Relacionamento Cliente X Contato' PIXEL STYLE DS_MODALFRAME STATUS
			@ 01,03 TO 111,330 LABEL 'Selecione um dos contatos abaixo para prosseguir' OF oDlgC PIXEL
			
			@ 09,08 SAY 'Para o cliente: [' + ;
			Left( a440Titulos[ 1, 2 ], 6 ) + '-' + ;
			SubStr( a440Titulos[ 1, 2 ], 7, 2 ) + '] ' + ;
			RTrim( Left( Posicione( 'SA1', 1, xFilial( 'SA1' ) + a440Titulos[ 1, 2 ], 'A1_NOME' ), 35 ) ) + ;
			', foi(ram) localizado(s) o(s) contato(s) a seguir.' ;
			SIZE 300,8 PIXEL OF oDlgC
			
			@ 19,06 LISTBOX oLbxC FIELDS HEADER 'Nome contato', 'Tel.Res.','Tel.Com.1', 'Celular', 'Outros', 'Código do contato' ;
	      SIZE 321,89 NOSCROLL OF oDlgC PIXEL ON DBLCLICK( A440Contact( a440SU5[ oLbxC:nAt, 7 ] ) )
			oLbxC:SetArray( a440SU5 )
			oLbxC:bLine := {|| AEval(a440SU5[oLbxC:nAt],{|z,w| a440SU5[oLbxC:nAt,w] } ) }
			oLbxC:BlDblClick := {|| nChoice := oLbxC:nAt, oDlgC:End() }
			
			@ 115,155 BUTTON oPesq    PROMPT 'Pesquisar'  SIZE 40,11 PIXEL OF oDlgC ACTION A440PCont( oLbxC )
			@ 115,200 BUTTON oVisual  PROMPT 'Visualizar' SIZE 40,11 PIXEL OF oDlgC ACTION A440Contact( a440SU5[ oLbxC:nAt, 7 ] )
			@ 115,245 BUTTON oIncCont PROMPT 'Inserir contato'  SIZE 40,11 PIXEL OF oDlgC ACTION A440IncCont( @oLbxC )
			@ 115,290 BUTTON oConfirm PROMPT 'Confirmar'  SIZE 40,11 PIXEL OF oDlgC ACTION ( nChoice := oLbxC:nAt, oDlgC:End() )
		ACTIVATE MSDIALOG oDlgC CENTER
		
		SU5->( dbSetOrder( 1 ) )
		SU5->( dbSeek( xFilial( 'SU5' ) + SubStr( a440SU5[ nChoice, 7 ], 4 ) ) )
		
		cU5_CODCONT := SU5->U5_CODCONT
		
		/*
		cU5_CONTAT := RTrim( SU5->U5_CONTAT ) + ' ' + ;
		Iif( Empty( a440SU5[ nChoice, 2 ] ), '', '- Tel.Res. '  + RTrim( a440SU5[ nChoice, 2 ] ) ) + ;
		Iif( Empty( a440SU5[ nChoice, 3 ] ), '', '- Tel.Com.1 ' + RTrim( a440SU5[ nChoice, 3 ] ) ) + ;
		Iif( Empty( a440SU5[ nChoice, 4 ] ), '', '- Celular '   + RTrim( a440SU5[ nChoice, 4 ] ) ) + ;
		Iif( Empty( a440SU5[ nChoice, 5 ] ), '', '- Outros '    + RTrim( a440SU5[ nChoice, 5 ] ) ) + ;
		Iif( Empty( a440SU5[ nChoice, 6 ] ), '', '- EMail '     + RTrim( a440SU5[ nChoice, 6 ] ) ) 
		*/
		A440Atrib(nChoice)
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A440IncCont | Autor | Robson Gonçalves              | Data | 16/12/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para inserir um contato e relacionar com o cliente em questão.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440IncCont( oLbx )
	Local nOpc := 0
	
	SU5->( dbSetOrder( 1 ) )
	nOpc := A70Inclui( 'SU5', 0, 3 )
	SU5->( dbCommit() )
	AGB->( dbCommit() )
			
	If nOpc == 1
		AC8->( dbSetOrder( 1 ) )
		AC8->( RecLock( 'AC8', .T. ) )
		AC8->AC8_FILIAL := xFilial( 'AC8')
		AC8->AC8_FILENT := xFilial( 'SA1' )
		AC8->AC8_ENTIDA := 'SA1'
		AC8->AC8_CODENT := a440Titulos[ 1, 2 ]
		AC8->AC8_CODCON := SU5->U5_CODCONT
		AC8->( MsUnLock() )
		AC8->( dbCommit() )
		
		SU5->( AAdd( a440SU5, { Upper(RTrim(U5_CONTAT)), ;
		                        RTrim( U5_DDD ) + Iif( Empty( U5_DDD ), '', '-' ) + U5_FONE, ;
		                        U5_FCOM1, ;
		                        U5_CELULAR, ;
		                        ''/*AGB_TELEFO*/, ;
		                        Lower( RTrim( U5_EMAIL ) ), ;
		                        'SU5' + U5_CODCONT } ) )
		oLbx:SetArray( a440SU5 )
		oLbx:bLine := {|| AEval(a440SU5[oLbx:nAt],{|z,w| a440SU5[oLbx:nAt,w] } ) }
		oLbx:Refresh()
		
		MsgInfo('Operação de inserir e relacionar dados do contato com o cliente realizado com sucesso.',cCadastro)
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440PCont   | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para pesquisar o contato na relação encontrada entre SU5 e SA1.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440PCont( oLbx )
	Local oDlgPesq
	Local oOrdem
	Local oChave 
	Local oBtOk
	Local oBtCan
	
	Local cOrdem := ''
	Local cTitulo := 'Pesquisar contato'
	Local cChave := Space(50)
	
	Local aOrdens := {}

	Local nP := 0
	Local nOrdem := 1
	Local nOpcao := 0

	aOrdens := {'Nome do contato'}
	
	DEFINE MSDIALOG oDlgPesq TITLE cTitulo FROM 00,00 TO 78,500 PIXEL
		@ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
		@ 021, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
	
		DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
		DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	ACTIVATE MSDIALOG oDlgPesq CENTER
	
	If nOpcao == 1
		cChave := Upper( AllTrim( cChave ) )
		nP := AScan( a440SU5,{|p| cChave $ Upper( p[ nOrdem ] ) } )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgAlert( 'Busca não localizada', cTitulo )
		Endif
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440Interacao | Autor | Robson Gonçalves            | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina p/ buscar a primeira e última data de interação do telecobrança.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Interacao( cPREFIXO, cNUM, cPARCELA, cTIPO, cCLIENTE, cLOJA )
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	Local aRet := Array( 2 )
	cSQL := "SELECT NVL( MIN( ACF_DATA ), ' ' ) AS MIN_DATA, "
	cSQL += "       NVL( MAX( ACF_DATA ), ' ' ) AS MAX_DATA "
	cSQL += "FROM   "+RetSqlName("ACF")+" ACF "
	cSQL += "       INNER JOIN "+RetSqlName("ACG")+" AGC "
	cSQL += "             ON ACG_FILIAL = "+ValToSql(xFilial("ACG"))+" "
	cSQL += "            AND ACG_CODIGO = ACF_CODIGO "
	cSQL += "            AND ACG_PREFIX = "+ValToSql( cPREFIXO )+" "
	cSQL += "            AND ACG_TITULO = "+ValToSql( cNUM )+" "
	cSQL += "            AND ACG_PARCEL = "+ValToSql( cPARCELA )+" "
	cSQL += "            AND ACG_TIPO = "+ValToSql( cTIPO )+" "
	cSQL += "WHERE  ACF_FILIAL = "+ValToSql(xFilial("ACF"))+" "
	cSQL += "       AND ACF_CLIENT = "+ValToSql( cCLIENTE )+" "
	cSQL += "       AND ACF_LOJA = "+ValToSql( cLOJA )+" "
	cSQL += "       AND ACF.D_E_L_E_T_ = ' '"
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )	
	aRet[ 1 ] := (cTRB)->MIN_DATA
	aRet[ 2 ] := (cTRB)->MAX_DATA
	(cTRB)->( dbCloseArea() )
Return( aRet )

//---------------------------------------------------------------------------------
// Rotina | A440Contact | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para consultar na íntegra os dados do contato.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Contact( cU5_CODCONT )
	INCLUI := .F.
	ALTERA := .F.
	If Left( cU5_CODCONT, 3 ) == 'SU5'
		SU5->( dbSetOrder( 1 ) )
		SU5->( dbSeek( xFilial( 'SU5' ) + SubStr( cU5_CODCONT, 4 ) ) )
		A70Visual( 'SU5', SU5->( RecNo() ), 2 )
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440Relat   | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para gerar o relatório de atendimento por período.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Relat()
	Local oReport
	Local cPerg := 'CSFA440REL'
	
	PutSX1(cPerg,"01","Periodo de?" ,"Periodo de?" ,"Periodo de?" ,"mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{""},{""},{""},"")
	PutSX1(cPerg,"02","Periodo até?","Periodo até?","Periodo até?","mv_ch1","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{""},{""},{""},"")

	PutSX1Help("P."+cPerg+"01.",{"Define o período inicial para impressão","do relatório de clientes notificados."},{""},{""},.T.)
	PutSX1Help("P."+cPerg+"02.",{"Define o período final para impressão  ","do relatório de clientes notificados."},{""},{""},.T.)
	
	Pergunte( cPerg, .F. )

	oReport := A440ProcImp( cPerg )
	oReport:PrintDialog()
Return

//---------------------------------------------------------------------------------
// Rotina | A440ProcImp | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina de processamento da section.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440ProcImp( cPerg )
	Local oReport
	Local oSection
	Local cDescricao := ''
	Local cTRB := ''
	Local lQuebra := .T.
	Local aOrdem := {}
	
	AAdd( aOrdem, 'Data+Hora de atendimento' )
	AAdd( aOrdem, 'Nome do cliente' )
	AAdd( aOrdem, 'Código do cliente' )
	AAdd( aOrdem, 'Prefixo+Número+Parcela do título' )
	AAdd( aOrdem, 'Atraso (Crescente)' )
	AAdd( aOrdem, 'Atraso (Decrescente)' )
	
	cDescricao := "Relatório que apresenta as informações dos clientes que foram atendidos pelo Telecobrança. "
	cDescricao += "Por favor, informe os parâmetros para processeguir."
	
	oReport	:=	TReport():New( "A440IMP", "Relação de atendimento do Telecobrança", cPerg, {|oReport| A440Print( @oReport, @cTRB, cPerg, aOrdem ) }, cDescricao, .T. )
	oReport:cFontBody := 'Consolas'
	oReport:nFontBody	:= 9
	oReport:nLineHeight := 26
	oReport:SetLandscape()
	
	oSection	:= TRSection():New( oReport, 'Atendimento Telecobrança', { cTRB }, aOrdem )
	oSection:OnPrintLine( {|| Iif( oReport:Row() > 1, ( oReport:SkipLine(), oReport:ThinLine() ), NIL ) } )
			
	// Seção
	// Nome da celula
	// Prefixo da tabela
	// Descrição da celula
	// Picture
	// Tamanho
	// Não sei
	// CodeBlock
	TRCell():New( oSection, 'ACF_DATA'  , cTRB, 'Dt.Atend.'+CRLF+'.'     , ,  9, , {|| (cTRB)->ACF_DATA    } )
	TRCell():New( oSection, 'ACF_HRPEND', cTRB, 'Hr.Atend.'              , ,  9, , {|| (cTRB)->ACF_HRPEND  } )
	TRCell():New( oSection, 'ACG_PREFIX', cTRB, 'Prefixo'                , ,  7, , {|| (cTRB)->ACG_PREFIX  } )
	TRCell():New( oSection, 'ACG_TITULO', cTRB, 'Título'                 , ,  9, , {|| (cTRB)->ACG_TITULO  } )
	TRCell():New( oSection, 'ACG_PARCEL', cTRB, 'Par'                    , ,  3, , {|| (cTRB)->ACG_PARCEL  } )
	TRCell():New( oSection, 'ACG_TIPO'  , cTRB, 'Tp.'                    , ,  3, , {|| (cTRB)->ACG_TIPO    } )
	TRCell():New( oSection, 'ACF_CLIENT', cTRB, 'Código'                 , ,  6, , {|| (cTRB)->ACF_CLIENT  } )
	TRCell():New( oSection, 'A1_NOME'   , cTRB, 'Nome cliente'           , , 30, , {|| (cTRB)->A1_NOME     } )
	TRCell():New( oSection, 'E1_EMISSAO', cTRB, 'Emissão tít.'           , , 12, , {|| (cTRB)->E1_EMISSAO  } )
	TRCell():New( oSection, 'ACG_DTVENC', cTRB, 'Venc.título'            , , 12, , {|| (cTRB)->ACG_DTVENC  } )
	TRCell():New( oSection, 'ACG_VALOR' , cTRB, 'Valor título'           , , 14, , {|| (cTRB)->ACG_VALOR   } )
	TRCell():New( oSection, 'ACF_PREVIS', cTRB, 'Prev.Pag.'              , ,  9, , {|| (cTRB)->ACF_PREVIS  } )
	TRCell():New( oSection, 'ACG_DIASAT', cTRB, 'Atraso'                 , ,  6, , {|| (cTRB)->ACG_DIASAT  } )
	TRCell():New( oSection, 'ACF_MOTIVO', cTRB, 'Motivo'                 , ,  6, , {|| (cTRB)->ACF_MOTIVO  } )
	TRCell():New( oSection, 'U9_DESC'   , cTRB, 'Descr.Motivo'           , , 30, , {|| (cTRB)->U9_DESC  } )
	TRCell():New( oSection, 'ACF_CODOBS', cTRB, 'Cód.Texto Atend.'       , ,  6, , {|| (cTRB)->ACF_CODOBS  } )
	TRCell():New( oSection, 'YP_TEXTO'  , 'SYP','Texto do atendendimento', , 30, , {|| A440TextObs( cTRB ) }, , lQuebra )
Return( oReport )

//---------------------------------------------------------------------------------
// Rotina | A440Print   | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina de impressão da section 
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Print( oReport, cTRB, cPerg, aOrdem )
	Local cOrdem := ''
	Local oSection := oReport:Section(1)
	Local nOrdem := oSection:GetOrder()
	Local cMV_440ASSU := GetMv( 'MV_440ASSU', .F. )
	
	If nOrdem == 1     ; cOrdem := "%ACF_DATA, ACF_HRPEND%"
	Elseif nOrdem == 2 ; cOrdem := "%A1_NOME%"
	Elseif nOrdem == 3 ; cOrdem := "%ACF_CLIENT%"
	Elseif nOrdem == 4 ; cOrdem := "%ACG_PREFIX, ACG_TITULO, ACG_PARCEL%"
	Elseif nOrdem == 5 ; cOrdem := "%ACG_DIASAT%"
	Elseif nOrdem == 6 ; cOrdem := "%ACG_DIASAT DESC%"
	Endif

	oReport:SetTitle( oReport:Title() + ' - Ordem: ' + aOrdem[ nOrdem ] )

	cTRB := GetNextAlias()
	
	MakeSqlExpr( cPerg )

	oSection:BeginQuery()
	BeginSql Alias cTRB
		Column ACF_DATA As Date
		Column E1_EMISSAO As Date
		Column ACG_DTVENC As Date
	
		%NoParser%
		
		SELECT ACF_DATA, 
		       ACF_HRPEND,
		       ACF_CODIGO,
		       ACG_PREFIX,
		       ACG_TITULO,
		       ACG_PARCEL,
		       ACG_TIPO,
		       ACF_CLIENT,
		       A1_NOME,
		       E1_EMISSAO,
		       ACG_DTVENC,
		       ACG_VALOR,
		       ACF_PREVIS,
		       ACG_DIASAT,
	          ACF_MOTIVO,
	          U9_DESC,
	   		 ACF_CODOBS
		FROM   %Table:ACF% ACF
		       LEFT JOIN %Table:SA1% SA1
		              ON A1_FILIAL = %xFilial:SA1%
		             AND A1_COD = ACF_CLIENT
		             AND SA1.%NOTDEL% 
		       LEFT JOIN %Table:ACG% ACG
		              ON ACG_FILIAL = %xFilial:ACG%
		             AND ACG_CODIGO = ACF_CODIGO
		             AND ACG.%NOTDEL% 
             LEFT JOIN %Table:SU9% SU9
	                 ON U9_FILIAL = %xFilial:SU9%
			          AND U9_ASSUNTO = %EXP:cMV_440ASSU%
			          AND U9_CODIGO = ACF_MOTIVO
			          AND SU9.%NOTDEL% 
		       LEFT JOIN %Table:SE1% SE1
		              ON E1_FILIAL = %xFilial:SE1%
		             AND E1_PREFIXO = ACG_PREFIX
		             AND E1_NUM = ACG_TITULO
		             AND E1_PARCELA = ACG_PARCEL
		             AND E1_TIPO = ACG_TIPO
		             AND E1_CLIENTE = ACF_CLIENT
		             AND SE1.%NOTDEL% 
		WHERE  ACF_FILIAL = %xFilial:ACF%
		       AND ACF_DATA BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% 
		       AND ACF.%NOTDEL% 
		ORDER  BY %EXP:cOrdem%
	EndSql
	oSection:EndQuery()                                        
	
	oSection:Print()
	oReport:SkipLine()
	oReport:FatLine()	
Return

//---------------------------------------------------------------------------------
// Rotina | A440TextObs | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para buscar o texto do atendimento.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440TextObs( cTRB )
	Local cTexto := ''
	Local nP := 0
	SYP->( dbSetOrder( 1 ) )
	SYP->( dbSeek( xFilial( 'SYP' ) + (cTRB)->ACF_CODOBS ) )
	While (.NOT. SYP->( EOF() ) ) .AND. SYP->YP_FILIAL == xFilial( 'SYP' ) .AND. SYP->YP_CHAVE == (cTRB)->ACF_CODOBS
		nP := At( '\13\10', SYP->YP_TEXTO )
		If nP > 0
			cTexto += RTrim( SubStr( SYP->YP_TEXTO, 1, nP-1 ) )
		Else
			nP := At( '\14\10', SYP->YP_TEXTO )
			If nP > 0
				cTexto += StrTran( SYP->YP_TEXTO, '\14\10', Space( 6 ) )
			Else
				cTexto += RTrim( SYP->YP_TEXTO )
			Endif
		Endif
		SYP->( dbSkip() )
	End
Return( cTexto )

//---------------------------------------------------------------------------------
// Rotina | A440UpdA    | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para criar a estrutura de dicionários.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A440UpdA()
	Local cXB_ALIAS := ''
	Local nTamSXB := 0
	Local aCpoSXB := {}
	Local aSXB := {}
	Local nI := 0
	Local nJ := 0
	Local cMsg := ''
	If MsgYesNo( 'Confirma a manutenção no dicionário de dados?','CSFA440 | A440UpdA' )
		// Criticar caso não haja os campos.
		If ACF->( FieldPos( 'ACF_LISTA'  ) ) == 0 .OR. ;
		   ACF->( FieldPos( 'ACF_PREVIS' ) ) == 0 .OR. ;
		   ACG->( FieldPos( 'ACG_DIASAT' ) ) == 0
			cMsg += 'Impossível prosseguir com esta rotina, é necessário executar o Update U_UPD440.' + CRLF
		Else
			cMsg += 'Campos ACF_LISTA, ACF_PREVIS, ACG_DIASAT criados.' + CRLF
		Endif
		
		// Tirar o campo de uso.
		SX3->( dbSetOrder( 2 ) )
		If SX3->( dbSeek( 'ACF_OBSMOT' ) )
			If SX3->X3_USADO == '€‚€€€€€€€€€€€€€'
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_USADO := '€€€€€€€€€€€€€€€'
				SX3->( MsUnLock() )
				cMsg += 'Modificado o X3_USADO do campo ACF_OBSMOT para não usado.' + CRLF
			Else
				cMsg += 'Campo ACF_OBSMOT já modificado X3_USADO para não usado.' + CRLF
			Endif
			If SX3->X3_RESERV == '†€'
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_RESERV := '„€'
				SX3->( MsUnLock() )
				cMsg += 'Modificado o X3_RESERV do campo ACF_OBSMOT para não usado.' + CRLF
			Else
				cMsg += 'Campo ACF_OBSMOT já modificado X3_RESERV para não usado.' + CRLF
			Endif
		Endif
		
		// Criar a consulta padrão.
		SXB->( dbSetOrder( 1 ) )
		nTamSXB := Len( SXB->XB_ALIAS )
		aCpoSXB := { 'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM' }
	
		If .NOT. SXB->( dbSeek( '440SU9' ) )
			cXB_ALIAS := '440SU9'
			AAdd( aSXB,{ cXB_ALIAS, '1', '01', 'DB', 'Motivo de ocorrencia', 'Motivo de ocorrencia', 'Motivo de ocorrencia', 'SU9'           , '' } )
			AAdd( aSXB,{ cXB_ALIAS, '2', '01', '01', 'Codigo do Assunto'   , 'Codigo do Assunto'   , 'Codigo do Assunto'   , ''              , '' } )
			AAdd( aSXB,{ cXB_ALIAS, '4', '01', '01', 'Codigo do Assunto'   , 'Codigo do Assunto'   , 'Codigo do Assunto'   , 'U9_ASSUNTO'    , '' } )
			AAdd( aSXB,{ cXB_ALIAS, '4', '01', '02', 'Codigo do Motivo'    , 'Codigo do Motivo'    , 'Codigo do Motivo'    , 'U9_CODIGO'     , '' } )
			AAdd( aSXB,{ cXB_ALIAS, '4', '01', '03', 'Descricao do Motivo' , 'Descricao do Motivo' , 'Descricao do Motivo' , 'U9_DESC'       , '' } )
			AAdd( aSXB,{ cXB_ALIAS, '5', '01', ''  , ''                    , ''                    , ''                    , 'SU9->U9_CODIGO', '' } )
			AAdd( aSXB,{ cXB_ALIAS, '6', '01', '01', '', '', '', "SU9->U9_FILIAL==xFilial('SU9').AND.SU9->U9_ASSUNTO==GetMv('MV_440ASSU').AND.SU9->U9_VALIDO=='1'.AND.SU9->U9_TIPOATE=='3'", '' } )
			cMsg += 'Criado a consulta padrão (SXB) 440SU9.' + CRLF
		Else
			cMsg += 'A consulta padrão (SXB) 440SU9 já está criada.' + CRLF
		Endif
		
		If .NOT. SXB->( dbSeek( '440SU5' ) )
			cXB_ALIAS := '440SU5'
			AAdd( aSXB,{ cXB_ALIAS,'1','01','RE','Cliente X Contatos','Cliente X Contatos','Cliente X Contatos','SU5','' } )
			AAdd( aSXB,{ cXB_ALIAS,'2','01','01','Codigo'  ,'Codigo'  ,'Codigo' ,'U_A440XBU5()'   ,''})
			AAdd( aSXB,{ cXB_ALIAS,'5','01',''  ,''        ,''        ,''       ,'SU5->U5_CODCONT',''})
			cMsg += 'Criado a consulta padrão (SXB) 440SU5.' + CRLF
		Else
			cMsg += 'A consulta padrão (SXB) 440SU5 já está criada.' + CRLF
		Endif
		
		If Len( aSXB ) > 0
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
		Endif
		MsgInfo( '*** RESULTADO DO PROCESSAMENTO *** ' + CRLF + CRLF + cMsg, 'CSFA440 | Update de dicionários' )
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | UPD440      | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina de update para o telecobrança.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function UPD440()
	Local cModulo := 'TMK'
	Local bPrepar := {|| U_U440Ini() }
	Local nVersao := 01

	NGCriaUpd( cModulo, bPrepar, nVersao )
Return

//---------------------------------------------------------------------------------
// Rotina | U440Ini     | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina complemento do update.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function U440Ini()
	aSX3 := {}
	aHelp := {}
	AAdd(aSX3,{	'ACF',NIL,'ACF_LISTA','C',6,0,;	                                             	         //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Lista Contat','Lista Contat','Lista Contat',;                                            //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Codigo da lista de contat','Codigo da lista de contat','Codigo da lista de contat',;     //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                                                                    //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€€',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                    //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld
	AAdd(aSX3,{	'ACF',NIL,'ACF_PREVIS','D',8,0,;	                                             	         //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Prev.Pagto.','Prev.Pagto.','Prev.Pagto.',;                                               //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Previsão pagamento','Previsão pagamento','Previsão pagamento',;                          //Desc. Port.,Desc.Esp.,Desc.Ing.
					'99/99/99',;                                                                              //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€ ',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'–A','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                    //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld
	AAdd(aSX3,{	'ACG',NIL,'ACG_DIASAT','N',5,0,;	                                             	         //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Atraso','Atraso','Atraso',;                                                              //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Dias de atraso','Dias de atraso','Dias de atraso',;                                      //Desc. Port.,Desc.Esp.,Desc.Ing.
					'99999',;                                                                                 //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€ ',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'–A','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                    //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld
	aAdd(aHelp,{'ACF_LISTA' , 'Codigo da lista de contato, ou seja, dados para a agenda do operador.'})	
	aAdd(aHelp,{'ACF_PREVIS', 'Data de previsão de pagamento.'})	
	aAdd(aHelp,{'ACG_DIASAT', 'Dias de atraso calculado no momento atendimento'})	
Return( .T. )

//---------------------------------------------------------------------------------
// Rotina | DELSX1      | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para apagar registros do SX1 inclusive o help se houver.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Function U_DELSX1( cPerg )
	Local nRet := 0
	Local nSeek := 0
	Local cFileHlp := ''
	
	If MsgYesNo('Desejar realmente excluir o grupo de perguntas ' + cPerg +'?')
		cFileHlp := RetHlpFile()
		cPerg := PadR( cPerg, Len( SX1->X1_GRUPO ) )
		SX1->( dbSetOrder( 1 ) )
		If SX1->( dbSeek( cPerg ) )
			While SX1->( .NOT. EOF() ) .AND. SX1->X1_GRUPO == cPerg
				nSeek := SPF_SEEK( cFileHlp, 'P.' + RTrim( cPerg ) + SX1->X1_ORDEM + '.', 1 )
				If nSeek > 0
					SPF_DELETE( cFileHlp, nRet )
				Endif
				SX1->( RecLock( 'SX1', .F. ) )
				SX1->( dbDelete() )
				SX1->( MsUnLock() )
				SX1->( dbSkip() )
			End
			MsgAlert('Fim do processo')
		Else
			MsgAlert('Grupo de perguntas ' + RTRim( cPerg ) + ' não lozalizado.')
		Endif
	Endif
Return