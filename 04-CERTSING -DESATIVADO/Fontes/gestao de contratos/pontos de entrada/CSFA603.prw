//--------------------------------------------------------------------------------
// Rotina | CSFA603      | Autor | Robson Gonçalves              | Data | 04.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para enviar WF de aprovação de contrato.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
#INCLUDE 'Protheus.ch'

#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="green">'
#DEFINE cNOFONT '</b></font></u></b> '
#DEFINE SEMREVISAO 'Não há revisão.'

STATIC ID_PROCESS := ''
STATIC ORI_PROCES := ''

User Function CSFA603( n603Opc, o603Proc, aCTR )
	Local nOpc := 0
	Local aSay := {}
	Local aButton := {}
	
	Private cCadastro := 'Envio de WF de contratos'
	Private cMV_603WF1 := GetNewPar('MV_603WF1', '\WORKFLOW\EVENTO\CSFA603a.HTM')
	Private cMV_603WF2 := GetNewPar('MV_603WF2', '\WORKFLOW\EVENTO\CSFA603b.HTM')
	Private cMV_603WF3 := GetNewPar('MV_603WF3', '\WORKFLOW\EVENTO\CSFA603c.HTM')
	Private aUsr := {}
			
	If ValType( n603Opc ) <> 'N'
		A603SXB()
		
		AAdd( aSay, 'O objetivo desta rotina é enviar workflow de todos os contratos legados.' )
		AAdd( aSay, '' )
		AAdd( aSay, '' )
		AAdd( aSay, 'Clique em OK para prosseguir...' )
		
		AAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch() }} )
		AAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
		
		FormBatch( cCadastro, aSay, aButton )
		
		If nOpc == 1
			A603Param()
		Endif
	Else
		If n603Opc == 1
			A603RetWF( o603Proc )
		Elseif n603Opc == 2 .AND. Len( aCTR ) > 0
			A603Proc( { aCTR[ 1 ], aCTR[ 1 ], aCTR[ 2 ], aCTR[ 2 ], aCTR[ 3 ], aCTR[ 4 ] } )
		Endif
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A603Param      | Autor | Robson Gonçalves            | Data | 04.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para solicitar parâmetros para o usuário.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A603Param()
	Local aPar := {}
	Local aRet := {}
	Local bOk := {|| .T. }
	Local aAprov := {'0=Legado','1=Em aprovacao','2=Aprovado','3=Rejeitado'}
	
	If File( cMV_603WF1 ) .AND. File( cMV_603WF2 ) .AND. File( cMV_603WF3 )
		AAdd( aPar, { 1, 'Filial de'   , Space( Len( CN9->CN9_FILIAL ) ), '', '', 'SM0_01', '', 40, .F. } )
		AAdd( aPar, { 1, 'Filial até'  , Space( Len( CN9->CN9_FILIAL ) ), '', '', 'SM0_01', '', 40, .T. } )
		AAdd( aPar, { 1, 'Contrato de' , Space( Len( CN9->CN9_NUMERO ) ), '', '', 'CN9', '', 99, .F. } )
		AAdd( aPar, { 1, 'Contrato até', Space( Len( CN9->CN9_NUMERO ) ), '', '', 'CN9', '', 99, .T. } )
		AAdd( aPar, { 1, 'Qual usuário', Space(200), '@S90', '', 'U_A603User()', '', 99, .T. } )
		AAdd( aPar, { 2, 'Aprovar'     , 1, aAprov, 90, '', .T., .F. } )
		If ParamBox( aPar, 'Parâmetros',@aRet,bOk,,,,,,,.T.,.T.)
			Processa( {|| A603Proc( aRet, 'MANUAL' )}, cCadastro,'Processando...', .F. )
		Endif
	Else
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<BR><BR>Não foi possível localizar os arquivos modelo de workflow. '+;
			'<BR>Verifique os parâmetros MV_603WF1, MV_603WF2 e MV_603WF3.',cCadastro)
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A603Proc  | Autor | Robson Gonçalves                 | Data | 04.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina de processamento para ler os registros dos contratos.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A603Proc( aRet, cModo )
	Local cSQL := ''
	Local cTRB := ''
	
	Local aCN0_TIPO := {}
	Local cCN0_TIPO := ''
	Local nCN0_TIPO := 0

	Local aCN0_ESPEC := {}
	Local cCN0_ESPEC := ''
	Local nCN0_ESPEC := 0
	
	Local aCN9_SITUAC := {}
	Local nCN9_SITUAC := 0
	
	Local nI := 0
	Local aUsuarios := {}
	
	Local lManual := .F.
	
	Private cEMail := ''
	Private cAprov := ''
	Private cNameUsr := ''
	Private cCN9_FILIAL := ''
	Private cCN9_NUMERO := ''
	Private cCN9_DESCRI := ''
	Private cCN9_FORNEC := ''
	Private cCN9_OBJETO := ''
	Private cCN9_VIGENC := ''
	Private cCN9_VLATU  := ''
	Private cCN9_REVISA := ''
	Private cCN9_SITUAC := ''
	Private aCN9_ANEXOS := {}
	Private cUserAprov := ''
	
	DEFAULT cModo := ''
	
	If cModo == 'MANUAL'
		lManual := .T.
	Endif
	
	aAux := StrToKarr( aRet[ 5 ], '|' )
	For nI := 1 To Len( aAux )
		AAdd( aUsuarios, { RTrim( UsrFullName( aAux[ nI ] ) ), RTrim( UsrRetMail( aAux[ nI ] ) ), aAux[ nI ] } )
	Next nI
	
	AAdd( aCN0_TIPO, '1=Aditivo' )
	AAdd( aCN0_TIPO, '2=Reajuste' )
	AAdd( aCN0_TIPO, '3=Realinhamento' )
	AAdd( aCN0_TIPO, '4=Readequação' )
	AAdd( aCN0_TIPO, '5=Paralisação' )
	AAdd( aCN0_TIPO, '6=Reinício' )
	AAdd( aCN0_TIPO, '7=Cláusula' )
	AAdd( aCN0_TIPO, '8=Contábil' )
	AAdd( aCN0_TIPO, '9=Índice' )
	AAdd( aCN0_TIPO, 'A=Fornecedor' )

	AAdd( aCN0_ESPEC, '1=Quantidade' )
	AAdd( aCN0_ESPEC, '2=Preço' )
	AAdd( aCN0_ESPEC, '3=Prazo' )
	AAdd( aCN0_ESPEC, '4=Quant/Prazo' )
	
	AAdd( aCN9_SITUAC, '01-Cancelado' )
	AAdd( aCN9_SITUAC, '02-Em Elaboração' )
	AAdd( aCN9_SITUAC, '03-Emitido' )
	AAdd( aCN9_SITUAC, '04-Em Aprovação' )
	AAdd( aCN9_SITUAC, '05-Vigente' )
	AAdd( aCN9_SITUAC, '06-Paralisado' )
	AAdd( aCN9_SITUAC, '07-Solicita Finalização.' )
	AAdd( aCN9_SITUAC, '08-Finalizado' )
	AAdd( aCN9_SITUAC, '09-Revisão' )
	AAdd( aCN9_SITUAC, '10-Revisado' )
	
	cSQL := "SELECT CN9_FILIAL, "
	cSQL += "       CN9_NUMERO, "
	cSQL += "       CN9_REVISA, "
	cSQL += "       CASE WHEN CN9_UNVIGE = '1' THEN 'Dia(s)' "
	cSQL += "            WHEN CN9_UNVIGE = '2' THEN 'Mês(es)' "
	cSQL += "            WHEN CN9_UNVIGE = '3' THEN 'Ano(s)' "
	cSQL += "            WHEN CN9_UNVIGE = '4' THEN 'Indeterminado' "
	cSQL += "       END AS UNI_VIG "
	cSQL += "FROM   "+RetSqlName("CN9")+" CN9 "
	cSQL += "       LEFT JOIN "+RetSqlName("CN1")+" CN1 "
	cSQL += "              ON CN1_FILIAL = CN9.CN9_FILIAL "
	cSQL += "                 AND CN1_CODIGO = CN9.CN9_TPCTO "
	
	If lManual
		cSQL += "                 AND CN1_ESPCTR = '1' "
	Endif
	
	cSQL += "                 AND CN1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  CN9.CN9_FILIAL BETWEEN "+ValToSql(aRet[1])+" AND "+ValToSql(aRet[2])+" "
	cSQL += "       AND CN9.CN9_NUMERO BETWEEN "+ValToSql(aRet[3])+" AND "+ValToSql(aRet[4])+" "
	
	If lManual
		cSQL += "       AND CN9_OKAY = '0' "
	Endif
	
	cSQL += "       AND CN9.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY CN9.CN9_FILIAL, CN9.CN9_NUMERO, CN9.CN9_REVISA "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando os contratos...')
	
	ProcRegua(0)
		
	While .NOT. (cTRB)->( EOF() )
		IncProc('Filial '+(cTRB)->CN9_FILIAL+' Contrato '+(cTRB)->CN9_NUMERO )
		
		CN9->( dbSetOrder( 1 ) )
		CN9->( dbSeek( (cTRB)->(CN9_FILIAL + CN9_NUMERO + CN9_REVISA) ) )
		While CN9->( .NOT. EOF() ) .AND. CN9->CN9_FILIAL == (cTRB)->CN9_FILIAL .AND. CN9->CN9_NUMERO == (cTRB)->CN9_NUMERO
			cCN9_FILIAL := CN9->CN9_FILIAL
			cCN9_NUMERO := CN9->CN9_NUMERO
			cCN9_REVISA := CN9->CN9_REVISA
			cCN9_DESCRI := RTrim( CN9->CN9_DESCRI )
			cCN9_VIGENC := Iif( CN9->CN9_VIGE == 0, '', LTrim( Str( CN9->CN9_VIGE,3,0 ) ) ) + ' ' + RTrim( (cTRB)->UNI_VIG )
			cCN9_VLATU  := LTrim(TransForm(CN9->CN9_VLATU,'@E 999,999,999,999.99'))
			cCN9_OBJETO := MSMM( CN9->CN9_CODOBJ )
			cCN9_SITUAC := CN9->CN9_SITUAC
			
			// Capturar as informações para o tipo de revisão.
			If .NOT. Empty( CN9->CN9_TIPREV )
				CN0->( dbSetOrder( 1 ) )
				If CN0->( dbSeek( xFilial( 'CN0' ) + CN9->CN9_TIPREV ) )
					
					nCN0_TIPO := AScan( aCN0_TIPO, CN0->CNO_TIPO )
					If nCN0_TIPO > 0
						cCN0_TIPO := SubStr( aCN0_TIPO[ nCN0_TIPO ], 3 )
					Endif
				
					nCN0_ESPEC := AScan( aCN0_ESPEC, CN0->CNO_ESPEC )
					If nCN0_ESPEC > 0
						cCN0_ESPEC := SubStr( aCN0_ESPEC[ nCN0_ESPEC ], 3 )
					Endif
				
					cCN9_REVISA += CN0->CN0_CODIGO + ' ' + RTrim( CN0->CN0_DESCRI ) + ' de ' + cCN0_TIPO + ' espécie ' + cCN0_ESPEC + CRLF
				Endif
			Endif
			
			CN9->( dbSkip() )
		End
		
		If Len( aRet ) > 5
			nCN9_SITUAC := AScan( aCN9_SITUAC, aRet[ 6 ] )
		Else
			nCN9_SITUAC := AScan( aCN9_SITUAC, CN9->CN9_SITUAC )
		Endif
		
		If nCN9_SITUAC > 0
			cCN9_SITUAC := SubStr( aCN9_SITUAC[ nCN9_SITUAC ], 4 )
			If Empty( CN9->CN9_CLIENT )
				If Upper( cCN9_SITUAC ) == 'VIGENTE'
					cCN9_SITUAC := 'Em aprovação para vigência.'
				Endif
			Endif
		Endif
		
		// Dados do fornecedores.
		CNC->( dbSetOrder( 1 ) )
		If CNC->( dbSeek( xFilial( 'CNC' ) + cCN9_NUMERO + cCN9_REVISA ) )
			While CNC->( .NOT. EOF() ) .AND. CNC->CNC_FILIAL == xFilial('CNC') .AND. CNC->CNC_NUMERO == cCN9_NUMERO .AND. CNC->CNC_REVISA == cCN9_REVISA
				cCN9_FORNEC += CNC->CNC_CODIGO + '-' + ;
					CNC->CNC_LOJA + ' ' + ;
					SubStr( SA2->( Posicione( 'SA2', 1, xFilial( 'SA2' ) + CNC->( CNC_CODIGO + CNC_LOJA ), 'A2_NOME'  ) ), 1, 30 ) + CRLF
				CNC->( dbSkip() )
			End
		Else
			cCN9_FORNEC := 'Não há fornecedor.'
		Endif
		
		// Número e nome da filial.
		cCN9_FILIAL := cCN9_FILIAL + '-' + RTrim( ( SM0->( GetAdvFVal( 'SM0', 'M0_FILIAL', cEmpAnt + cCN9_FILIAL , 1 ,'' ) ) ) )
		
		If Empty( cCN9_OBJETO )
			cCN9_OBJETO := 'Objetivo não informado.'
		Endif

		If Empty( cCN9_REVISA )
			cCN9_REVISA := SEMREVISAO
		Endif
		
		// Enviar para os usuários.
		For nI := 1 To Len( aUsuarios )
			cAprov     := aUsuarios[ nI, 1 ]
			cEMail     := aUsuarios[ nI, 2 ]
			cNameUsr   := aUsuarios[ nI, 3 ]
			cUserAprov := cNameUsr
			
			A603WrkFlw()
			
			Sleep( 1000 )
		Next nI
		
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	If cCN9_FILIAL <> ''
		MsgInfo(cFONTOK+'Processamento de workflow finalizado com sucesso!'+cNOFONT+'',cCadastro)
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A603WrkFlw | Autor | Robson Gonçalves                | Data | 04.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para iniciar o processo de workflow e gerar o HTML de aprov.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A603WrkFlw()
	Local oWFEnv
	Local oHTML
	Local nDiasTW := GetNewPar('MV_XTIWWFD', 5)
	Local nHoraTW := GetNewPar('MV_XTIWWFH', 0)
	Local nMinuTW := GetNewPar('MV_XTIWWFM', 0)
	Local cIdMail := ''
	
	oWFEnv := TWFProcess():New( 'GCTWF', 'Aprovar contrato')
	oWFEnv:NewTask( 'GCTWF', cMV_603WF1 )
	oWFEnv:cSubject := 'Aprovação de Contrato'
	oWFEnv:bReturn := 'U_CSFA603(1)'
	
	// Carrega modelo HTML
	oHTML := oWFEnv:oHTML
	
	// Preenche os dados do cabecalho	
	oHtml:ValByName( 'cAprovador'      , cAprov      )
	oHtml:ValByName( 'cCN9_FILIAL'     , cCN9_FILIAL )
	oHtml:ValByName( 'cCN9_NUMERO'     , cCN9_NUMERO )
	oHtml:ValByName( 'cCN9_DESCRICAO'  , cCN9_DESCRI )
	oHtml:ValByName( 'cCN9_FORNECEDOR' , cCN9_FORNEC )
	oHtml:ValByName( 'cCN9_OBJETIVO'   , cCN9_OBJETO )
	oHtml:ValByName( 'cCN9_VIGENCIA'   , cCN9_VIGENC )
	oHtml:ValByName( 'cCN9_VALOR'      , cCN9_VLATU  )
	oHtml:ValByName( 'cCN9_REVISAO'    , cCN9_REVISA )
	oHtml:ValByName( 'cCN9_SITUACAO'   , cCN9_SITUAC )
	oHtml:ValByName( 'cUserAprov'      , cUserAprov  )
	
	oWFEnv:cTo := cNameUsr
		
	oWFEnv:FDesc := 'Aprovar Filial/Contrato nº'+ cCN9_FILIAL + ' ' + cCN9_NUMERO
	
	oWFEnv:ClientName( cNameUsr )
	
	cIdMail := oWFEnv:Start()
	
	A603WFLink( @oWFEnv, cIdMail )
	
	oWFEnv:Free()
Return

//--------------------------------------------------------------------------------
// Rotina | A603WFLink | Autor | Robson Gonçalves                | Data | 04.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para gerar o e-mail do WF e link para aprovação.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A603WFLink( oWFLink, cIdMail )
	Local nI := 0
	Local oHTML
	Local cLink	:= GetNewPar('MV_XLINKWF', 'http://192.168.16.10:1804/wf/')

	cLink += 'emp' + cEmpAnt + '/'

	oWFLink:NewTask( 'GCTWF', cMV_603WF2 )
	oWFLink:cSubject := 'Solicitação de aprovação do contrato ' + cCN9_NUMERO
	oWFLink:cTo := cEMail
	
	oHTML := oWFLink:oHTML
	
	aCN9_ANEXOS := {}
	A603Anexar()
	
	For nI := 1 To Len( aCN9_ANEXOS )
		If .NOT. Empty( aCN9_ANEXOS )
			oWFLink:AttachFile( aCN9_ANEXOS[ nI ] )
		Endif
	Next nI

	oHtml:ValByName( 'cAprovador'      , cAprov      )
	oHtml:ValByName( 'cCN9_FILIAL'     , cCN9_FILIAL )
	oHtml:ValByName( 'cCN9_NUMERO'     , cCN9_NUMERO )
	oHtml:ValByName( 'cCN9_DESCRICAO'  , cCN9_DESCRI )
	oHtml:ValByName( 'cCN9_FORNECEDOR' , cCN9_FORNEC )
	oHtml:ValByName( 'cCN9_OBJETIVO'   , cCN9_OBJETO )
	oHtml:ValByName( 'cCN9_VIGENCIA'   , cCN9_VIGENC )
	oHtml:ValByName( 'cCN9_VALOR'      , cCN9_VLATU  )
	oHtml:ValByName( 'cCN9_REVISAO'    , cCN9_REVISA )
	oHtml:ValByName( 'cCN9_SITUACAO'   , cCN9_SITUAC )

	oHtml:ValByName( 'proc_link', cLink + cNameUsr + '/' + cIdMail + '.htm' )
	oHtml:ValByName( 'titulo', cIdMail )
	
	oWFLink:Start()
	oWFLink:Free()
Return

//--------------------------------------------------------------------------------
// Rotina | A603RetWF  | Autor | Robson Gonçalves                | Data | 04.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para processa o retorno do WF.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A603RetWF( o603Proc )
	Local cCN9_FILIAL := ''
	Local cCN9_NUMERO := ''
	Local cCN9_REVISA := ''
	Local cUserAprov  := ''
	Local cAprovador  := ''
	Local cAprovacao  := ''
	Local cMotivo     := ''
	Local cWFMailID   := ''
	Local cDocto      := ''
	
	cCN9_FILIAL := SubStr( o603Proc:oHtml:RetByName('cCN9_FILIAL'), 1, 2 )
	cCN9_NUMERO := RTrim( o603Proc:oHtml:RetByName('cCN9_NUMERO') )
	cCN9_REVISA := RTrim( o603Proc:oHtml:RetByName('cCN9_REVISAO') )
	cUserAprov  := RTrim( o603Proc:oHtml:RetByName('cUserAprov') )
	cAprovador  := RTrim( o603Proc:oHtml:RetByName('cAprovador') )
	cAprovacao  := RTrim( o603Proc:oHtml:RetByName('cAprovacao') )
	cMotivo     := RTrim( o603Proc:oHtml:RetByName('cMotivo') )
	cWFMailID   := SubStr( RTrim( o603Proc:oHtml:RetByName('WFMailID') ), 3 )
	
	If cCN9_REVISA == SEMREVISAO
		cCN9_REVISA := Space( Len( CN9->CN9_REVISA ) )
	Endif
	
	cDocto := cCN9_NUMERO + cCN9_REVISA
	cDocto := cDocto + Space( Len( SCR->CR_NUM )-Len( cDocto ) )
	
	U_A603Save( cWFMailID, 'CSFA603' )
	
	U_A603LibRej( cDocto, cCN9_FILIAL, cCN9_NUMERO, cCN9_REVISA, cAprovacao, cAprovador, cMotivo, cUserAprov )
Return

//--------------------------------------------------------------------------------
// Rotina | A603LibRej | Autor | Robson Gonçalves                | Data | 17.07.15
//--------------------------------------------------------------------------------
// Descr. | Rotina responsável em avaliar se o usuário aprovou ou rejeitou.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
User Function A603LibRej( cDocto, cCN9_FILIAL, cCN9_NUMERO, cCN9_REVISA, cAprovacao, cAprovador, cMotivo, cUserAprov )
	Local cTexto := ''
	Local cSituacao := ''
	Local nReg := 0
	Local nLib := 0
	Local nRej := 0
	Local cCN9_SITUAC := ''
	
	CN9->( dbSetOrder( 1 ) )
	If CN9->( dbSeek( cCN9_FILIAL + cCN9_NUMERO + cCN9_REVISA ) )
		
		If cAprovacao == 'S'
			cTexto := 'Contrato aprovador por ' + cAprovador + ' em ' + Dtoc( MsDate() ) + ' as ' + Time() + '.'
		Elseif cAprovacao == 'N'
			cTexto := 'Contrato rejeitado por ' + cAprovador + ' em ' + Dtoc( MsDate() ) + ' as ' + Time() + ' com o seguinte motivo: '+RTrim( cMotivo )
		Endif
		
		If .NOT. Empty( CN9->CN9_HISAPR )
			cTexto := cTexto + CRLF + AllTrim( CN9->CN9_HISAPR )
		Endif
		
		CN9->( RecLock( 'CN9', .F. ) )
		CN9->CN9_HISAPR := cTexto
		CN9->( MsUnLock() )
		
		SCR->( dbSetOrder( 2 ) )
		If SCR->( dbSeek( cCN9_FILIAL + '#1' + cDocto + cUserAprov ) )
			If cAprovacao == 'S'
				cAprovacao := '03'
				cSituacao := 'aprovou'
			Else
				cAprovacao := '04'
				cSituacao := 'rejeitou'
			Endif
			
			SCR->( RecLock( 'SCR', .F. ) )
			SCR->CR_STATUS  := cAprovacao // 03-Liberado pelo usuario ou 04-Bloqueado pelo usuario.
			SCR->CR_DATALIB := dDataBase
			SCR->( MsUnLock() )
			
			A603MsgSit( cCN9_NUMERO, cSituacao, cAprovador, .T. )
			
			SCR->( dbSeek( cCN9_FILIAL + '#1' + cDocto ) )
			While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == cCN9_FILIAL .AND. SCR->CR_TIPO == '#1' .AND. SCR->CR_NUM == cDocto
				nReg++
				If SCR->CR_STATUS == '03'
					nLib++
				Elseif SCR->CR_STATUS == '04'
					nRej++
				Endif
				SCR->( dbSkip() )
			End
			
			If nReg > 0
				If (nLib == nReg) .OR. (nRej == nReg)
					// Contrato aprovado.
					If (nLib == nReg)
						cSituacao := 'aprovado'
						cCN9_SITUAC := CN9->CN9_SITUAC
						
						CN9->( RecLock( 'CN9', .F. ) )
						CN9->CN9_SITUAC := '05'
						CN9->CN9_OKAY   := '2'
						CN9->( MsUnLock() )
						
						U_CN100SIT( cCN9_SITUAC, CN9->CN9_SITUAC )
					// Contrato rejeitado.
					Elseif (nRej == nReg)
						cSituacao := 'rejeitado'
						CN9->( RecLock( 'CN9', .F. ) )
						CN9->CN9_OKAY := '3'
						CN9->( MsUnLock() )
					Endif
					A603MsgSit( cCN9_NUMERO, cSituacao, '', .F. )
				Endif
			Endif
		Endif
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A603MsgSit | Autor | Robson Gonçalves                | Data | 17.07.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para enviar o aviso por e-mail de aprovação ou rejeição para 
//        | equipe de contratos.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A603MsgSit( cCN9_NUMERO, cSituacao, cAprovador, lPorEvento )
	Local cEmail := ''
	Local cAssunto := ''
	Local cHTML := ''
	Local cBody := ''
	Local nPos := 0
	Local cMV_603USER  := 'MV_603USER'
	
	If .NOT. GetMv( cMV_603USER, .T. )
		CriarSX6( cMV_603USER, 'C', 'EMAIL DE USUARIOS PARA O AVISO DE APROVACAO/REJEICAO DE CONTRATOS. CSFA603.prw', 'contratos@certisign.com.br' )
	Endif		
	
	nPos := At(' ',cAprovador)
	If nPos > 0
		cAprovador := SubStr(cAprovador,1,nPos-1)
	Else
		cAprovador := SubStr(cAprovador,1,15)
	Endif
	
	cHTML := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
	cHTML += '<html>'
	cHTML += '<head>'
	cHTML += '<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
	cHTML += '<title>Aprova&ccedil;&atilde;o de contratos</title>'
	cHTML += '</head>'
	cHTML += '<body>'
	cHTML += '<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
	cHTML += '<tbody>'
	cHTML += '<tr>'
	cHTML += '<td style="padding:5px; vertical-align:middle;" valign="middle">'
	cHTML += '<p>'
	cHTML += '<font color="#F4811D" face="Arial, Helvetica, sans-serif" size="5"><strong>Aprova&ccedil;&atilde;o de Contratos</strong></font><br />'
	cHTML += '<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></p>'
	cHTML += '<p style="text-align: center;">'
	cHTML += '<span style="font-size:12px;"><em><font color="#02519B" face="Arial, Helvetica, sans-serif">'
	If lPorEvento
		cHTML += 'O aprovador '+cAprovador+' '+cSituacao+' o contrato '+cCN9_NUMERO+'.'
	Else
		cHTML += 'O contrato '+cCN9_NUMERO+' foi '+cSituacao+'.'
	Endif
	cHTML += '</font></em></span></p>''
	cHTML += '</td>'
	cHTML += '<td align="right" width="210">'
	cHTML += '<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
	cHTML += '&nbsp;</td>'
	cHTML += '</tr>'
	cHTML += '<tr>'
	cHTML += '<td colspan="2" style="height: 2px; background-color: rgb(244, 129, 29);">'
	cHTML += '<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '</tr>'
	cHTML += '</tbody>'
	cHTML += '</table>'
	cHTML += '<p>'
	cHTML += '&nbsp;</p>'
	cHTML += '</body>'
	cHTML += '</html>'

	cEmail := GetMv( cMV_603USER, .F. )
	cAssunto := 'Workflow de aprovação de contrato'
	cBody := cHTML
	
	IF .NOT. Empty( cEmail )
		FSSendMail( cEmail, cAssunto, cBody, /*cAnexo*/ )
	EndIF
Return

//---------------------------------------------------------------------------------
// Rotina | A603Anexar | Autor | Robson Gonçalves               | Data | 10/06/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para buscar os anexos do contrato.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A603Anexar()
	Local cSQL := ''
	Local cTRB := ''
	Local cRoot := MsDocPath()+'\'
	
	cSQL := "SELECT ACB_OBJETO "
	cSQL += "FROM   "+RetSqlName("AC9")+" AC9 "
	cSQL += "       INNER JOIN "+RetSqlName("ACB")+" ACB "
	cSQL += "               ON ACB_FILIAL = "+ValToSql(xFilial("ACB"))+" "
	cSQL += "                  AND ACB_CODOBJ = AC9_CODOBJ "
	cSQL += "                  AND ACB.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  AC9_FILIAL = "+ValToSql(xFilial("AC9"))+" "
	cSQL += "       AND AC9_CODENT = "+ValToSql(cCN9_NUMERO)+" "
	cSQL += "       AND AC9.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	
	While (cTRB)->( .NOT. EOF() )
		AAdd( aCN9_ANEXOS, cRoot + RTrim( (cTRB)->ACB_OBJETO ) )
		(cTRB)->( dbSkip() )
	End
	
	(cTRB)->( dbCloseArea() )
Return

//---------------------------------------------------------------------------------
// Rotina | A603User   | Autor | Robson Gonçalves               | Data | 03.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina responsável por apresentar os usuários do sistema conforme 
//        | acionado por tecla de consulta padrão.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A603User()
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oPanelTop
	Local oPanelBot
	Local oPanelAll
	Local oCancel
	Local oConfirm
	
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Local aOrdem := {}
	Local cOrd := ''
	Local cRet := ''
	Local cSeek := Space(100)
	Local cMV_PAR := ReadVar()
	Local cReadVar := RTrim(&(ReadVar()))

	Local aUser := {}
	
	Local nI := 0
	Local nOrd := 1

	Local lOk := .F.
	Local lMark := .F.
	
	AAdd(aOrdem,'Código do usuário')
	AAdd(aOrdem,'Login do usuário')
	AAdd(aOrdem,'Nome completo do usuário')
	
	If Len( aUsr ) == 0
		FWMsgRun(,{|| aUsr := FWSFAllUsers()},,'Aguarde, buscando usuários...')
	Endif
	
	For nI := 1 To Len( aUsr )
		lMark := ( aUsr[ nI, 2 ] $ cReadVar )
		AAdd( aUser, { lMark, aUsr[ nI, 2], aUsr[ nI, 3], aUsr[ nI, 4] } )
	Next nI
	
	lMark := .F.
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,777 TITLE 'Escolha o(s) usuário(s)' PIXEL
	oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
	oPanelTop:Align := CONTROL_ALIGN_TOP
		
	@ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
	@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
	@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (A603PsqMod(nOrd,cSeek,@oLbx))
		
	oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
	oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

	@ 40,05 LISTBOX oLbx FIELDS HEADER 'x','Código','Login','Nome completo' SIZE 350, 90 OF oPanelAll PIXEL ON ;
		dblClick(aUser[oLbx:nAt,1]:=!aUser[oLbx:nAt,1])
	oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	oLbx:SetArray(aUser)
	oLbx:bLine := { || {Iif(aUser[oLbx:nAt,1],oOk,oNo),aUser[oLbx:nAt,2],aUser[oLbx:nAt,3],aUser[oLbx:nAt,4]}}
	oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aUser, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os usuários...') }
		
	oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
	oPanelBot:Align := CONTROL_ALIGN_BOTTOM

	@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(A603VldMod(aUser,@lOk),oDlg:End(),NIL)
	@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	
	If lOk
		For nI := 1 To Len( aUser )
			If aUser[ nI, 1 ]
				cRet += aUser[ nI, 2 ] + '|'
			Endif
		Next nI
		cRet := SubStr( cRet, 1, Len( cRet )-1 )
		&(cMV_PAR) := cRet
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A603PsqMod | Autor | Robson Gonçalves               | Data | 03.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para efetuar pesquisa no vetor.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A603PsqMod( nOrd, cSeek, oLbx )
	Local nP := 0
	Local nColPesq := 0
		
	If nOrd==1
		nColPesq := 2
	Elseif nOrd == 2
		nColPesq := 3
	Elseif nOrd == 3
		nColPesq := 3
	Else
		MsgAlert('Opção não disponível para pesquisa.','Pesquisar')
	Endif
	
	If nColPesq > 0
		nP := AScan( oLbx:aArray, {|p| Upper( AllTrim( cSeek ) ) $ Upper( AllTrim( p[ nColPesq ] ) ) } )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('Informação não localizada.','Pesquisar')
		Endif
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A603VldMod | Autor | Robson Gonçalves               | Data | 03.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para validar se escolheu algum usuário.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A603VldMod( aUser, lOk )
	Local nP := 0
	Local lRet := .T.
	nP := AScan( aUser, {|p| p[ 1 ] } )
	lOk := ( nP > 0 )
	If .NOT. lOk
		lRet := .F.
		MsgAlert( 'Não foi selecionado nenhum usuário para enviar e-mail.', 'Validação da seleção de usuário' )
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A603SXB    | Autor | Robson Gonçalves               | Data | 03.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina responsável para criar a configuração da consulta padrão.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A603SXB()
	Local aSXB := {}
	Local aCpoXB := {}
	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}
	AAdd( aSXB, { 'A603US', '1', '01', 'RE', 'Usuario Protheus', 'Usuario Protheus', 'Usuario Protheus', 'SX5'        , '' } )
	AAdd( aSXB, { 'A603US', '2', '01', '01', ''                , ''                , ''                , '.T.'        , '' } )
	AAdd( aSXB, { 'A603US', '5', '01', ''  , ''                , ''                , ''                , 'U_603User()', '' } )
	SXB->(dbSetOrder(1))
	For nI := 1 To Len( aSXB )
		If !SXB->(dbSeek(aSXB[nI,1]+aSXB[nI,2]+aSXB[nI,3]+aSXB[nI,4]))
			SXB->(RecLock('SXB',.T.))
			For nJ := 1 To Len( aSXB[nI] )
				SXB->(FieldPut(FieldPos(aCpoXB[nJ]),aSXB[nI,nJ]))
			Next nJ
			SXB->(MsUnLock())
		Endif
	Next nI
Return

/*****
 *
 * Rotina para encapsular/armazenar a variável com o ID do WF de envio.
 * Autor: Robson Gonçalves
 * 
 */
User Function A603Save( cID, cORIGEM )
	ID_PROCESS := cID
	ORI_PROCES := cORIGEM
Return

/*****
 *
 * Rotina para recuperar a variável encapsulada do ID do WF de retorno.
 * Autor: Robson Gonçalves
 *
 */
User Function A603Restore()
Return( { ID_PROCESS, ORI_PROCES } )

/*****
 *
 * Rotina para limpar a variável encapsulada do ID do WF de envio/retorno.
 * Autor: Robson Gonçalves
 *
 */
User Function A603Clear()
	ID_PROCESS := ''
	ORI_PROCES := ''
Return

//---------------------------------------------------------------------------------
// Rotina | UPD603     | Autor | Robson Gonçalves               | Data | 10/06/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina de update p/ criar as estruturas no dicionário dados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function UPD603()
	Local cModulo := 'GCT'
	Local bPrepar := {|| U_U603Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//---------------------------------------------------------------------------------
// Rotina | U603Ini    | Autor | Robson Luiz - Rleg             | Data | 10/06/2015
//---------------------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function U603Ini()
	aSX3 := {}
	aHelp := {}
	AAdd(aSX3,  {'CN9',NIL,'CN9_HISAPR','M',10,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
	'Hist. Aprov.','Hist. Aprov.','Hist. Aprov.',;    													//Tit. Port.,Tit.Esp.,Tit.Ing.
	'Historico de aprovacao','Historico de aprovacao','Historico de aprovacao',;				//Desc. Port.,Desc.Esp.,Desc.Ing.
	'@!',;                                               												//Picture
	'',;                                                 												//Valid
	X3_EMUSO_USADO,;                                     												//Usado
	'',;                                                 												//Relacao
	'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
	'U','N','V','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
	'',;	                                               												//VldUser
	'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
	'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
	'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CN9_HISAPR', 'Histórico de aprovação via workflow.'})

	AAdd(aSX3,  {'CN9',NIL,'CN9_MOTCAN','M',10,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
	'Mot.Fin/Can','Mot.Fin/Can','Mot.Fin/Can',;    												 		//Tit. Port.,Tit.Esp.,Tit.Ing.
	'Motivo finaliz/cancelado','Motivo finaliz/cancelado','Motivo finaliz/cancelado',;		//Desc. Port.,Desc.Esp.,Desc.Ing.
	'@!',;                                               												//Picture
	'',;                                                 												//Valid
	X3_EMUSO_USADO,;                                     												//Usado
	'',;                                                 												//Relacao
	'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
	'U','N','V','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
	'',;	                                               												//VldUser
	'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
	'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
	'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CN9_MOTCAN', 'Motivo da finalização ou cancelamento do contrato.'})

	AAdd(aSX3,  {'CN9',NIL,'CN9_AVITER','N',3,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
	'Avis.Termino','Avis.Termino','Avis.Termino',;    													//Tit. Port.,Tit.Esp.,Tit.Ing.
	'Aviso de termino','Aviso de termino','Aviso termino',;											//Desc. Port.,Desc.Esp.,Desc.Ing.
	'999',;                                              												//Picture
	'',;                                                 												//Valid
	X3_EMUSO_USADO,;                                     												//Usado
	'',;                                                 												//Relacao
	'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
	'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
	'Iif(M->CN9_UNVIGE<="3".AND.M->CN9_AVITER=0,(MsgAlert("Vigencia em Dias, Mes, Ano, preencha dias p/aviso de termino."),.F.),.T.)',;	                                               												//VldUser
	'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
	'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
	'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CN9_AVITER', 'Informe o período em dias para o envio de alerta via e-mail relatando o término do contrato'})

	AAdd(aSX3,  {'CN9',NIL,'CN9_AVIPER','N',3,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
	'Avis.Period.','Avis.Period.','Avis.Period.',;    													//Tit. Port.,Tit.Esp.,Tit.Ing.
	'Aviso periodico','Aviso periodico','Aviso periodico',;											//Desc. Port.,Desc.Esp.,Desc.Ing.
	'999',;                                              												//Picture
	'',;                                                 												//Valid
	X3_EMUSO_USADO,;                                     												//Usado
	'',;                                                 												//Relacao
	'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
	'U','N','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
	'Iif(M->CN9_UNVIGE<="3".AND.M->CN9_AVIPER=0,(MsgAlert("Vigencia em Dias, Mes, Ano, preencha dias p/aviso periodico."),.F.),.T.)',;	                                               												//VldUser
	'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
	'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
	'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CN9_AVIPER', 'Informe o período em dias para o envio períodico de alerta via e-mail relatando o término do contrato'})
Return