//----------------------------------------------------------------------------
// Rotina | CSFA380    | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina para registrar o movimento do participante entre postos.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
#Include 'Protheus.ch'
#Include 'Report.ch'
User Function CSFA380( nFunc )
	Local nOpc := 0	
	Local aSay := {}
	Local aButton := {}
	Private cCadastro := 'Manutenção na alocação do participante
	AAdd( aSay, 'Rotina para efetuar manutenção na alocação do participante. Nesta rotina será ' )
	AAdd( aSay, 'possível alocar, desalocar, consultar as alocações do participante entre os postos' )
	AAdd( aSay, 'das entidades parceiras da Certisign e emitir o relatório de Head Count.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	FormBatch( cCadastro, aSay, aButton )
	If nOpc == 1
		If nFunc == 1
			A380Alocar()
		Elseif nFunc == 2
			A380Desalocar()
		Elseif nFunc == 3
			A380Consultar()
		Else
			A380HCnt()
		Endif
	Endif
Return
//----------------------------------------------------------------------------
// Rotina | A380Alocar | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina para alocar o participante no posto.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
Static Function A380Alocar()
	Local aPar := {}
	Local aRet := {}
	Local bOk := {|| A380Periodo( aRet ) }
	If RD0->RD0_MSBLQL <> '1'
		If Empty( RD0->RD0_DEMISS )
			AAdd( aPar, { 1, 'Alocar para o posto', Space(Len(SZ3->Z3_CODENT)),'','U_A380Posto()'       , 'SZ3', ''   ,60 , .T. } )
			AAdd( aPar, { 1, 'Nome do posto'      , Space(Len(SZ3->Z3_DESENT)),'',''                    , ''   , '.F.',119, .T. } )
			AAdd( aPar, { 1, 'Período de'         ,Ctod(Space(8))             ,'',''                    ,''    , ''   , 50, .T. } )
			AAdd( aPar, { 1, 'Período até'        ,Ctod(Space(8))             ,'','(mv_par04>=mv_par03)',''    , ''   , 50, .T. } )
			If ParamBox( aPar, 'Parâmetros',@aRet,bOk,,,,,,,.F.,.F.)
				A380Grava( aRet )
			Endif
		Else
			MsgAlert( 'O participante em questão está desligado da empresa desde ' + Dtoc( RD0->RD0_DEMISS ), cCadastro )
		Endif
	Else
		MsgAlert( 'O participante em qeustão não está ativo.', cCadastro )
	Endif
Return
//----------------------------------------------------------------------------
// Rotina | A380Posto  | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina para validar o posto informado.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
User Function A380Posto()
	Local lRet := .T.
	Local cMsg := ''
	Local cReadVar := ReadVar()
	Local cMV_380CMAX := 'MV_380CMAX'
	Local cX6_CONTEUD := ''
	Local aPar := {}
	Local aRet := {}
	Local nMv := 0
	Local aSave := {}
	
	cX6_CONTEUD := '000491|000445|000777|000262'
	//              |      |      |      +----> Bianca Cunha
	//              |      |      +-----------> Giovanni Rodrigues
	//              |      +------------------> Consultoria Externa
	//              +-------------------------> Patricia Abrahao
	
	SZ3->( dbSetOrder( 1 ) )
	If SZ3->( dbSeek( xFilial( 'SZ3' ) + &(cReadVar) ) )
		If SZ3->Z3_CAPMAX == 0
			If .NOT. GetMV( cMV_380CMAX, .T. )
				CriarSX6( cMV_380CMAX, 'C', 'CODIGO DE USUÁRIO QUE PODE FAZER A CARGA INICIAL DA CAPACIDADE MAXIMA PARA O POSTO PARCEIRO.', cX6_CONTEUD )
			Endif
			cMV_380CMAX := GetMv( cMV_380CMAX, .F. )
			If RetCodUsr() $ cMV_380CMAX
				cMsg := 'O posto '+RTrim(SZ3->Z3_CODENT)+' não possui capacidade máxima de alocação.' + CRLF
				cMsg += 'Seu usuário tem privilégio para cadastrar a quantidade máxima agora. ' + CRLF
				cMSg += 'Por favor, clique em OK para informar este dado e seguir com a alocação.'
				If Aviso('Validar Posto',cMsg,{'OK','Sair'},2,'Posto sem capacidade máxima')==1
					AAdd( aPar, { 1, 'Informe a quantidade máxima',0,'@E 999','Positivo()', '', '', 20 , .T. } )
					For nMv := 1 To 40
						AAdd( aSave, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
					Next nMv
					If ParamBox( aPar, 'Capacidade Máxima',@aRet,,,,,,,,.F.,.F.)
						SZ3->( RecLock( 'SZ3', .F. ) )
						SZ3->Z3_CAPMAX := aRet[ 1 ] 
						SZ3->( MsUnLock() )
					Endif
					For nMv := 1 To Len( aSave )
						&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aSave[ nMv ]
					Next nMv
				Else 
					lRet := .F.
					MsgAlert( 'Não foi definido capacidade máxima para o posto em questão.', cCadastro )				
				Endif
			Else
				lRet := .F.
				MsgAlert( 'Não foi definido capacidade máxima para o posto em questão.', cCadastro )				
			Endif
		Else
			If (SZ3->Z3_QTDALOC + 1) > SZ3->Z3_CAPMAX
				lRet := .F.
				MsgAlert( 'Não será possível alocar este particiapante, pois atingiu a capacidade máxima.', cCadastro )
			Endif
		Endif
	Else
		lRet := .F.
		MsgAlert( 'Código de posto não localizado.', cCadastro )
	Endif
	If lRet 
		If cReadVar == 'MV_PAR01'
			mv_par02 := Posicione( 'SZ3', 1, xFilial( 'SZ3' ) + &(cReadVar), 'Z3_DESENT' )
		Endif
	Endif	
Return( lRet )

//----------------------------------------------------------------------------
// Rotina | A380Period | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina para validar o período informado.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
Static Function A380Periodo( aRet )
	Local lRet := .T.
	Local cPeriodo := ''
	Local cTRB := GetNextAlias()
	BEGINSQL ALIAS cTRB
		COLUMN PAH_PERINI AS DATE
		COLUMN PAH_PERFIM AS DATE
		SELECT PAH_SEQ,
		       PAH_PERINI, 
		       PAH_PERFIM
		FROM   %table:PAH% PAH 
		WHERE  PAH_FILIAL = %xFilial:PAH%
		       AND PAH_CODIGO = %exp:RD0->RD0_CODIGO%
		       AND PAH_STATUS = '1'
		       AND PAH_DTDESA = ' '
		       AND %notDel%
		       AND ( PAH_PERINI BETWEEN %exp:aRet[ 3 ]% AND %exp:aRet[ 4 ]% OR PAH_PERFIM BETWEEN %exp:aRet[ 3 ]% AND  %exp:aRet[ 4 ]% )
		        OR ( %exp:aRet[ 3 ]% > PAH_PERINI AND %exp:aRet[ 4 ]% < PAH_PERFIM )
	ENDSQL
	While .NOT. (cTRB)->( EOF() )
		cPeriodo += 'Sequência ' + (cTRB)->PAH_SEQ + ' período de ' + Dtoc( (cTRB)->PAH_PERINI ) + ' até ' + Dtoc( (cTRB)->PAH_PERFIM ) + ' ' + CRLF
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	If cPeriodo <> ''
		lRet := .F.
		MsgAlert( 'Este participante possui alocação no período informado. ' + CRLF + cPeriodo, cCadastro )
	Endif
Return( lRet )
//----------------------------------------------------------------------------
// Rotina | A380Desalo | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina para desalocar o participante no posto.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
Static Function A380Desalocar()
	Local oPnl
	Local oBrw
	Local nLin2 := 0
	Local nCol2 := 0
	Local cFiltro := ""
	Private oWind 
	Private aRotina := {}
	If RD0->RD0_ALOCAD <> '1'
		MsgAlert( 'O participante em questão não está alocado.', cCadastro )
	Else
		nLin2 := oMainWnd:nClientHeight - 34
		nCol2 := oMainWnd:nClientWidth - 14
		cFiltro := "xFilial('PAH')+RD0->RD0_CODIGO"
		AAdd( aRotina, {'Pesquisar', 'AxPesqui'  , 0, 1 } )
		AAdd( aRotina, {'Desalocar', 'U_A380Desa', 0, 4 } )
		AAdd( aRotina, {'Legenda'  , 'U_A380Leg' , 0, 6 } )
		DEFINE MSDIALOG oWind TITLE '' FROM 190,250 TO nLin2,nCol2 OF oMainWnd PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
			oWind:lEscClose := .F.
			oPnl := TPanel():New(0,0,,oWind,,,,,RGB(116,116,116),1,1000,.F.,.F.)
			oPnl:Align := CONTROL_ALIGN_ALLCLIENT
			oBrw := FwMbrowse():New()
			oBrw:SetAlias( 'PAH' )
			oBrw:SetOwner( oPnl )
			oBrw:SetDescription( 'Desalocar participante' )
			oBrw:DisableDetails()
			oBrw:DisableConfig()
			oBrw:DisableLocate()
			oBrw:DisableSaveConfig()
			oBrw:SetWalkThru( .F. )
			oBrw:SetAmbiente( .F. )
			oBrw:ForceQuitButton()
			oBrw:SetBotFun(cFiltro)
			oBrw:SetTopFun(cFiltro)
			oBrw:AddLegend( "PAH_STATUS == '1'", "RED"  , "Alocado" )
			oBrw:AddLegend( "PAH_STATUS <> '1'", "GREEN", "Desalocado" )
			oBrw:Activate()
		ACTIVATE MSDIALOG oWind CENTERED ON INIT (oBrw:Refresh())
	Endif
Return
//----------------------------------------------------------------------------
// Rotina | A380Desa   | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina auxiliar para desalocar o participante no posto.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
User Function A380Desa( cAlias, nRecNo, nOpcX )
	Local cTRB := ''	
	If PAH->PAH_STATUS == '1'
		If MsgYesNo('A desalocação deste recurso será dada a partir da data de hoje ' + Dtoc( dDataBase ) + ' em diante. Confirma?', cCadastro)
			Begin Transaction
				// Mudar o status do registro que determina a alocação.
				PAH->( RecLock( 'PAH', .F. ) )
				PAH->PAH_DTDESA := dDataBase
				PAH->PAH_OBSERV := 'DESALOCADO POR ' + RetCodUsr() + ' DT ' + Dtoc( dDatabase ) + '.'
				PAH->PAH_STATUS := '2'
				PAH->( MSUnLock() )
				// Verificar se há mais alguma alocação para o participante.
				cTRB := GetNextAlias()
				BEGINSQL ALIAS cTRB
					SELECT COUNT(*) AS nCOUNT
					FROM   %table:PAH% PAH 
					WHERE  PAH_FILIAL = %xFilial:PAH%
					       AND PAH_CODIGO = %exp:RD0->RD0_CODIGO%
					       AND PAH_STATUS = '1' 
					       AND PAH_DTDESA = ' '
					       AND %notDel%
				ENDSQL
				// Se não houver mais nenhuma alocação para o participante, então mudar o status dele.
				If (cTRB)->nCOUNT == 0
					RD0->( RecLock( 'RD0', .F. ) )
					RD0->RD0_POSTO  := ''
					RD0->RD0_ALOCAD := '2'
					RD0->( MsUnLock() )
		      Endif
		      (cTRB)->( dbCloseArea() )
		      // Substrair a capacidade do posto.
				SZ3->( dbSetOrder( 1 ) )
				SZ3->( dbSeek( xFilial( 'SZ3' ) + PAH->PAH_POSTO ) )
				SZ3->( RecLock( 'SZ3', .F. ) )
				SZ3->Z3_QTDALOC := SZ3->Z3_QTDALOC - 1
				SZ3->( MsUnLock() )
			End Transaction
			MsgInfo( 'Desalocação efetauda com sucesso.', cCadastro )
			oWind:End()
		Endif
	Else
		MsgAlert( 'Registro com status desalocado, selecione outro registro.', cCadastro )
	Endif
Return
//----------------------------------------------------------------------------
// Rotina | A380Consul | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina para consultar as alocações do participante.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
Static Function A380Consultar()
	Local oPnl
	Local oWind
	Local oBrw
	Local nLin2 := oMainWnd:nClientHeight - 34
	Local nCol2 := oMainWnd:nClientWidth - 14
	Local cFiltro := ''
	Private aRotina := {}
	If MsgYesNo( 'Consultar somente o participante: ' + RTrim( RD0->RD0_NOME ) + '.', cCadastro )
		cFiltro := "xFilial('PAH')+RD0->RD0_CODIGO"
	Else
		cFiltro := "xFilial('PAH')"
	Endif
	AAdd( aRotina, {'Pesquisar' , 'AxPesqui' , 0, 1 } )
	AAdd( aRotina, {'Visualizar', 'AxVisual' , 0, 2 } )
	AAdd( aRotina, {'Legenda'   , 'U_A380Leg', 0, 6 } )
	DEFINE MSDIALOG oWind TITLE '' FROM 190,250 TO nLin2,nCol2 OF oMainWnd PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
		oWind:lEscClose := .F.
		oPnl := TPanel():New(0,0,,oWind,,,,,RGB(116,116,116),1,1000,.F.,.F.)
		oPnl:Align := CONTROL_ALIGN_ALLCLIENT
		oBrw := FwMbrowse():New()
		oBrw:SetAlias( 'PAH' )
		oBrw:SetOwner( oPnl )
		oBrw:SetDescription( 'Desalocar participante' )
		oBrw:DisableDetails()
		oBrw:DisableConfig()
		oBrw:DisableLocate()
		oBrw:DisableSaveConfig()
		oBrw:SetWalkThru( .F. )
		oBrw:SetAmbiente( .F. )
		oBrw:ForceQuitButton()
		oBrw:SetBotFun(cFiltro)
		oBrw:SetTopFun(cFiltro)
		oBrw:AddLegend( "PAH_STATUS == '1'", "RED"  , "Alocado" )
		oBrw:AddLegend( "PAH_STATUS <> '1'", "GREEN", "Desalocado" )
		oBrw:Activate()
	ACTIVATE MSDIALOG oWind CENTERED ON INIT (oBrw:Refresh())
Return
//----------------------------------------------------------------------------
// Rotina | A380Grava  | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina para gravar a alocação do participante no posto.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
Static Function A380Grava( aRet )
	Local nPAH_SEQ := 0
	Local cPAH_SEQ := ''
	PAH->( dbSetOrder( 1 ) )
	PAH->( dbSeek( xFilial( 'PAH' ) + RD0->RD0_CODIGO ) )
	While .NOT. PAH->( EOF() ) .And. PAH->PAH_FILIAL == xFilial( 'PAH' ) .And. PAH->PAH_CODIGO == RD0->RD0_CODIGO
		nPAH_SEQ++
		PAH->( dbSkip() )
	End
	If nPAH_SEQ == 0
		cPAH_SEQ := '001'
	Else
		cPAH_SEQ := Soma1( StrZero( nPAH_SEQ, Len( PAH->PAH_SEQ ), 0 ) )
	Endif
	Begin Transaction
		SZ3->( RecLock( 'SZ3', .F. ) )
		SZ3->Z3_QTDALOC := SZ3->Z3_QTDALOC + 1
		SZ3->( MsUnLock() )
	
		RD0->( RecLock( 'RD0', .F. ) )
		RD0->RD0_POSTO := aRet[ 1 ]
		RD0->RD0_ALOCAD := '1'
		RD0->( MsUnLock() )
		
		PAH->( RecLock( 'PAH', .T. ) )
		PAH->PAH_FILIAL := xFilial( 'PAH' )
		PAH->PAH_CODIGO := RD0->RD0_CODIGO
		PAH->PAH_SEQ    := cPAH_SEQ
		PAH->PAH_POSTO  := aRet[ 1 ]
		PAH->PAH_PERINI := aRet[ 3 ]
		PAH->PAH_PERFIM := aRet[ 4 ]
		PAH->PAH_USER   := RetCodUsr()
		PAH->PAH_DATA   := MsDate()
		PAH->PAH_HORA   := Time()
		PAH->PAH_STATUS := '1'
		PAH->( MsUnLock() )
	End Transaction
	MsgInfo( 'Alocação efetuada com sucesso.', cCadastro )
Return
//----------------------------------------------------------------------------
// Rotina | A380Leg    | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina de legenda dos registros do movimento.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
User Function A380Leg()
	Local oLegenda := FWLegend():New()
	oLegenda:Add('a',"RED"  ,'Alocado')
	oLegenda:Add('b',"GREEN",'Desalocado')
	oLegenda:Activate()
	oLegenda:View()
	oLegenda:DeActivate()
Return
//----------------------------------------------------------------------------
// Rotina | A380Resicao | Autor | Robson Gonçalves - Rleg  | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina auxiliar do ponto de entrada GP040Res. O objetivo é 
//        | registrar a data de demissão e bloquear o registro na tabela RD0.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
User Function A380Resicao()
	RD0->( dbOrderNickName( 'RD0_09' ) )
	If RD0->( dbSeek( xFilial( 'RD0' ) + SRA->RA_MAT ) )
		RD0->( RecLock( 'RD0', .F. ) )
		RD0->RD0_DEMISS := SRG->RG_DATADEM
		RD0->RD0_MSBLQL := '1'
		RD0->RD0_SITUAC := '4'
		RD0->( MsUnLock() )
	Endif
Return
//----------------------------------------------------------------------------
// Rotina | A380ExcRes | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina auxiliar do ponto de entrada GPM040Ex. O objetivo é 
//        | tirar a data de demissão e desbloquear o registro na tabela RDA0.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
User Function A380ExcRes()
	RD0->( dbOrderNickName( 'RD0_09' ) )
	If RD0->( dbSeek( xFilial( 'RD0' ) + SRA->RA_MAT ) )
		RD0->( RecLock( 'RD0', .F. ) )
		RD0->RD0_DEMISS := Ctod('  /  /  ')
		RD0->RD0_MSBLQL := '2'
		RD0->RD0_SITUAC := '1'
		RD0->( MsUnLock() )
	Endif
Return
//----------------------------------------------------------------------------
// Rotina | A380HCnt   | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina de imprssão dos dados da movimentação de agentes entre os
//        | postos parceiros da Certisign.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
Static Function __A380HCnt()
	Local cPerg := 'A380HCNT'
	Local cReport := cPerg
	
	Local oCell
	Local oReport
	Local oSection
	
	Local aCPO := {}
	Local aHeader := {}
	Local aAlign := {}
	Local aPicture := {}
	Local aSizeCol := {}
	Local aTrocaTitulo := {}
	
	Local nI := 0
	Local nX := 0
	Local nP := 0
	Local nMax := 0
	Local nLen := 0
	Local nSizeCol := 0
	Local nLargura := 0
	Local nColSpace := 1
	
	Private aOrd := { 'Centro de custo', 'Posto', 'Centro de Custo + Posto' }
	Private cTitle := 'Head Count'
		
	A380SX1( cPerg )
	
	Pergunte( cPerg, .F. )

	oReport := TReport():New( cReport, cTitle, cPerg , { |oObj| A380PrtRpt( oObj, Len( aCPO ) ) }, 'Relatório de Head Count cuteio das AR.' )
	oReport:DisableOrientation()
	oReport:SetEnvironment(2)
	oReport:cFontBody := 'Consolas'
	oReport:nFontBody	:= 8
	oReport:nLineHeight := 25
	oReport:SetLandscape()
	
	// Colunas dos dados do relatório.
	aCPO := { 'CTT_CUSTO' , 'CTT_DESC01',;
	          'Z3_CODENT' , 'Z3_DESENT' ,;
	          'RD0_CODIGO', 'RD0_NOME'  , 'RD0_ALOCAD',;
	          'PAH_SEQ'   , 'PAH_DATA'  , 'PAH_PERINI', 'PAH_PERFIM', 'PAH_STATUS', 'PAH_DTDESA' }
	
	// Título da coluna que deve ser mudado.
	AAdd( aTrocaTitulo, { 'CTT_CUSTO' ,'C.Custo'      } )
	AAdd( aTrocaTitulo, { 'CTT_DESC01','Descrição C.Custo' } )
	AAdd( aTrocaTitulo, { 'Z3_CODENT' ,'Posto'        } )
	AAdd( aTrocaTitulo, { 'Z3_DESENT' ,'Descr. Posto' } )
	AAdd( aTrocaTitulo, { 'RD0_ALOCAD','Aloc'         } )
	AAdd( aTrocaTitulo, { 'PAH_SEQ'   ,'Seq'          } )
	AAdd( aTrocaTitulo, { 'PAH_DATA'  ,'Dt.Movto.'    } )
	
	// Buscar dados do dicionário de dados.
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCPO )
		If SX3->( dbSeek( aCPO[ nI ] ) )
			// Se encontrar o campo, trocar o título.
			nP := AScan( aTrocaTitulo, {|p| p[ 1 ] == aCPO[ nI ] } )
			If nP == 0
				AAdd( aHeader, RTrim( SX3->X3_TITULO ) )
			Else
				AAdd( aHeader, aTrocaTitulo[ nP, 2 ] )
			Endif
			// Analisar a dependência para alinhamento do dado.
			If SX3->X3_TIPO == 'N'
				AAdd( aAlign, 'RIGHT' )
			Else
				AAdd( aAlign, 'LEFT' )
			Endif
			// Buscar a picture do campo.
			AAdd( aPicture, RTrim( SX3->X3_PICTURE ) )
			// Analisar quem é maior, o título ou o dado, mesmo assim não deixar ser maior que 30 caracteres.
			nMax := Max( SX3->( X3_TAMANHO + X3_DECIMAL ), Len( aHeader[ Len( aHeader ) ] ) )
			If nMax > 30
				nMax := 30
			Endif
			AAdd( aSizeCol, nMax )
		Endif
	Next nI

	DEFINE SECTION oSection OF oReport TITLE 'Head Count Custeio da AR' ORDERS aOrd TOTAL IN COLUMN
	
	nLen := Len( aHeader )
	nSizeCol := Len( aSizeCol )
	
	// Definir as células da seção.
	For nX := 1 To nLen
		If nSizeCol > 0
			If nX <= nSizeCol
				nLargura := aSizeCol[ nX ]
			Else
				nLargura := 20
			Endif
		Else
			nLargura := 20
		Endif
		
		DEFINE CELL oCell NAME "CEL"+Alltrim(Str(nX-1)) OF oSection SIZE nLargura TITLE aHeader[ nX ]
		If Len( aAlign ) > 0
			If nX <= Len( aAlign )
				oCell:SetAlign( aAlign[ nX ] )
			Endif
		Endif
	Next nX
	
	oSection:SetColSpace(nColSpace) // Define o espaçamento entre as colunas.
	oSection:SetLineBreak(.T.)      // Define que a impressão poderá ocorrer emu ma ou mais linhas no caso das colunas exederem o tamanho da página.
	oReport:PrintDialog()
Return
//----------------------------------------------------------------------------
// Rotina | A380PrtRpt | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina de imprssão conforme configuração do usuário.
//        | 
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
Static Function __A380PrtRpt( oReport, nCPO )
	Local nI := 0
	Local nP := 0
	Local nReg := 0
	Local nCount := 0
	Local nOrder := 0
	
	Local cDado := ''
	Local cOrder := ''
	Local cKey := ''
	Local cKey2 := ''
	Local cCond := ''
	Local cMV_PAR01 := ''
	Local cMV_PAR02 := ''
	Local cTRB := GetNextAlias()
	
	Local aRD0_ALOCAD := {}
	Local aPAH_STATUS := {}
	
	Local oSection
	
	oSection := oReport:Section( 1 )
	nOrder := oSection:GetOrder()
	
	oReport:SetTitle( cTitle + ' - ' + aOrd[ nOrder ] )
	
	aRD0_ALOCAD := StrToKarr( Posicione( 'SX3', 2, 'RD0_ALOCAD', 'X3CBox()' ), ';' )
	aPAH_STATUS := StrToKarr( Posicione( 'SX3', 2, 'PAH_STATUS', 'X3CBox()' ), ';' )
	
	If Empty( mv_par01 )
		mv_par01 := Space( Len( RD0->RD0_CC ) ) + '-' + Replicate( 'z', Len( RD0->RD0_CC ) )
	Endif
	
	If Empty( mv_par02 )
		mv_par02 := Space( Len( PAH->PAH_POSTO ) ) + '-' + Replicate( 'z', Len( PAH->PAH_POSTO ) )
	Endif
											
	MakeSqlExpr( oReport:GetParam() )
	
	cMV_PAR01 := '%'+mv_par01+'%'
	cMV_PAR02 := '%'+mv_par02+'%'
	
	cOrder := Iif( nOrder == 1, '%CTT_CUSTO, PAH_SEQ%', Iif( nOrder == 2, '%Z3_CODENT, PAH_SEQ%', '%CTT_CUSTO, Z3_CODENT, PAH_SEQ%' ) )	

	BEGINSQL ALIAS cTRB
	   COLUMN PAH_DATA   AS DATE
	   COLUMN PAH_PERINI AS DATE
	   COLUMN PAH_PERFIM AS DATE 
		
		SELECT CTT_CUSTO,
		       CTT_DESC01,
		       Z3_CODENT,
		       Z3_DESENT,
		       RD0_CODIGO,
		       RD0_NOME,
		       RD0_ALOCAD,
		       PAH_SEQ,
		       PAH_DATA,
		       PAH_PERINI,
		       PAH_PERFIM,
		       PAH_STATUS,
		       PAH_DTDESA
		FROM   PAH010 PAH
		       INNER JOIN %table:RD0% RD0
		               ON RD0_FILIAL = %xFilial:RD0%
		              AND %exp:cMV_PAR01%
		              AND RD0.%notDel%
		       INNER JOIN %table:CTT% CTT
		               ON CTT_FILIAL = %xFilial:CTT%
		              AND CTT_CUSTO = RD0_CC
		              AND CTT.%notDel%
		       INNER JOIN %table:SZ3% SZ3
		              ON Z3_FILIAL = %xFilial:SZ3%
		             AND Z3_CODENT = PAH_POSTO
		             AND SZ3.%notDel%
		WHERE  PAH_FILIAL = ' ' 
		       AND PAH_CODIGO = RD0_CODIGO
		       AND %exp:cMV_PAR02%
		       AND PAH.%notDel%
		ORDER  BY %exp:cOrder%
	ENDSQL 

	oReport:SetMsgPrint('Aguarde, imprimindo...')
	oReport:SetMeter(0)
	oSection:Init()
		
	While .NOT. (cTRB)->( EOF() )
		If oReport:Cancel()
			Exit
		Endif
		
		// Conforme a seleção da ordem montar a condição de leitura/quebra.
		If nOrder == 1
			cKey  := (cTRB)->CTT_CUSTO
			cCond := cTRB+'->CTT_CUSTO == "'+cKey+'"'
		Elseif nOrder == 2
			cKey  := (cTRB)->Z3_CODENT
			cCond := cTRB+'->Z3_CODENT == "'+cKey+'"'
		Else
			cKey  := (cTRB)->CTT_CUSTO
			cKey2 := (cTRB)->Z3_CODENT
			cCond := cTRB+'->CTT_CUSTO == "'+cKey+'" .And. '+cTRB+'->Z3_CODENT == "'+cKey2+'"'
		Endif
		
		While .NOT. (cTRB)->( EOF() ) .And. &cCond
			
			For nI := 1 To nCPO
				If     (cTRB)->( ValType( FieldGet( nI ) ) ) == 'D' ; cDado := Dtoc( (cTRB)->( FieldGet( nI ) ) )
				Elseif (cTRB)->( ValType( FieldGet( nI ) ) ) == 'N' ; cDado := LTrim( TransForm( (cTRB)->( FieldGet( nI ) ), aPicture[ nI ] ) )
				Elseif (cTRB)->( ValType( FieldGet( nI ) ) ) == 'C' ; cDado := (cTRB)->( FieldGet( nI ) ) ; cDado := StrTran( cDado, "'", "" )
				Endif
				
				If FieldName( nI ) == 'RD0_ALOCAD'
					nP := AScan( aRD0_ALOCAD, cDado )
					If nP > 0
						cDado := SubStr( aRD0_ALOCAD[ nP ], 3 )
					Endif
				Endif
				
				If FieldName( nI ) == 'PAH_STATUS'
					nP := AScan( aPAH_STATUS, cDado )
					If nP > 0
						cDado := SubStr( aPAH_STATUS[ nP ], 3 )
					Endif
				Endif
	
				oSection:Cell( 'CEL' + Alltrim( Str( nI-1 ) ) ):SetBlock( &( "{ || '" + cDado + "'}" ) )
			Next nI
			
			nReg++
			nCount++
			oSection:PrintLine()
			oReport:IncMeter()
		
			(cTRB)->( dbSkip() )
		End
		
		oReport:ThinLine()
		oReport:SkipLine()
		oReport:PrintText('>>> TOTAL: ' + LTrim( Str( nReg ) ) )
		oReport:SkipLine()
		oReport:ThinLine()
		oReport:SkipLine()
		nReg := 0
	End
	
	oReport:PrintText('>>> TOTAL DE REGISTROS: ' + LTrim( Str( nCount ) ) )
	oReport:SkipLine()
	oReport:FatLine(5)
	
	oSection:Finish()
	(cTRB)->( dbCloseArea() )
Return
//----------------------------------------------------------------------------
// Rotina | A380SX1    | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina para verificar se o grupo de perguntas existe, não 
//        | existindo será criado.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
Static Function A380SX1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}
	
	aAdd( aP, { "Informe o Centro de Custo","C",99,0,"R","","CTT","","","","","",'RD0_CC'})
	aAdd( aP, { "Informe o Posto Parceiro" ,"C",99,0,"R","","SZ3","","","","","",'PAH_POSTO'})
	
	aAdd( aHelp, { "Informe o código do centro de custo.", "" } )
	aAdd( aHelp, { "Informe o código do posto parceiro." , "" } )
	
	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
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
		"",;
		"",;
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
		"")
	Next i
Return
//----------------------------------------------------------------------------
// Rotina | A380UpdTab | Autor | Robson Gonçalves - Rleg   | Data | 28.03.2014
//----------------------------------------------------------------------------
// Descr. | Rotina de update na tabela RD0 p/ completar os nomes e descrições.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//----------------------------------------------------------------------------
User Function A380UpdTab()
	Local cTRB := ''
	Local cSQL := ''
	Local cMsg := ''
	Local cName := ''
	Local nI := 0
	Local aLog := {}
	If .NOT. MsgYesNo('Esta rotina irá fazer update nos campos RD0_DESCCC, RD0_USRNAM, RD0_NOMMEN, RD0_IDESCR, RD0_NOMLID, RD0_DESFUN, RD0_DESCAR, '+;
	                  'RD0_DESTUR, RD0_SITUAC, RD0_ALOCAD conforme seus códigos e inicializador padrão. Continuar?')
		Return
	Endif
	//------------------------------------------------------------------------------------------------
	// Atualizar a descrição do centro de custo.
	//------------------------------------------------------------------------------------------------
	If RD0->( FieldPos( 'RD0_DESCCC' ) ) > 0
		cSQL := "UPDATE "+RetSqlName("RD0")+" RD0 "
		cSQL += "SET RD0_DESCCC = ( SELECT CTT_DESC01 "
		cSQL += "                   FROM   "+RetSqlName("CTT")+" CTT "
		cSQL += "                   WHERE  CTT_FILIAL = "+ValToSql(xFilial("CTT"))+" "
		cSQL += "                          AND CTT_CUSTO = RD0_CC "
		cSQL += "                          AND CTT.D_E_L_E_T_ = ' ' ) "
		cSQL += "WHERE  RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "       AND RD0_DESCCC = ' ' "
		cSQL += "       AND RD0.D_E_L_E_T_ = ' ' "
		TcSqlExec( cSQL )
		AAdd( aLog, "Update para o campo RD0_DESCCC executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_DESCCC não executado, pois o campos não existe na tabela.")
	Endif
	//------------------------------------------------------------------------------------------------
	// Atualizar o nome do usuário.
	//------------------------------------------------------------------------------------------------
	If RD0->( FieldPos( 'RD0_USRNAM' ) ) > 0
		cSQL := "SELECT R_E_C_N_O_ AS RD0_RECNO, RD0_USER "
		cSQL += "FROM  "+RetSqlName("RD0")+" "
		cSQL += "WHERE  RD0_FILIAL = ' ' "
		cSQL += "       AND RD0_USER <> ' ' "
	   cSQL += "       AND RD0_USRNAM = ' ' "
		cSQL += "       AND D_E_L_E_T_ = ' ' "
		cTRB := GetNextAlias()
		cSQL := ChangeQuery( cSQL )
		PLSQuery( cSQL, cTRB )
		While .NOT. (cTRB)->( EOF() )
			cName := Upper( RTrim( UsrRetName( (cTRB)->RD0_USER ) ) )
			If .NOT. Empty( cName )
				RD0->( dbGoTo( (cTRB)->RD0_RECNO ) )
				RD0->( RecLock( 'RD0', .F. ) ) 
				RD0->RD0_USRNAM := cName
				RD0->( MsUnLock() )
			Endif
			(cTRB)->( dbSkip() )
		End
		(cTRB)->(dbCloseArea())
		AAdd( aLog, "Update para o campo RD0_USRNAME executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_USRNAME não executado, pois o campos não existe na tabela.")
	Endif	
	//------------------------------------------------------------------------------------------------
	// Atualizar o nome do mentor.
	//------------------------------------------------------------------------------------------------
	If RD0->( FieldPos( 'RD0_NOMMEN' ) ) > 0
		cSQL := "UPDATE "+RetSqlName("RD0")+" RD01"
		cSQL += "SET    RD01.RD0_NOMMEN = NVL((SELECT RD02.RD0_NOME "
		cSQL += "                              FROM   "+RetSqlName("RD0")+" RD02 "
		cSQL += "                              WHERE  RD02.RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "                                     AND RD02.D_E_L_E_T_ = ' ' "
		cSQL += "                                     AND RD02.RD0_CODIGO = RD01.RD0_CODMEN), ' ' ) "
		cSQL += "WHERE  RD01.RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "       AND RD01.RD0_CODMEN <> ' ' "
		cSQL += "       AND RD01.D_E_L_E_T_ = ' ' "
		TcSqlExec( cSQL )
		AAdd( aLog, "Update para o campo RD0_NOMMEN executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_NOMMEN não executado, pois o campos não existe na tabela.")
	Endif	
	//------------------------------------------------------------------------------------------------
	// Atualizar o nome da identificação.
	//------------------------------------------------------------------------------------------------
	If RD0->( FieldPos( 'RD0_IDESCR' ) ) > 0
		cSQL := "UPDATE "+RetSqlName("RD0")+" RD0 "
		cSQL += "SET    RD0_IDESCR = ( SELECT RE8_IDESCR "
		cSQL += "                      FROM   "+RetSqlName("RE8")+" RE8 "
		cSQL += "                      WHERE  RE8_FILIAL = "+ValToSql(xFilial("RE8"))+" "
		cSQL += "                             AND RE8_IDENT = RD0_IDENT "
		cSQL += "                             AND RE8.D_E_L_E_T_ = ' ' ) "
		cSQL += "WHERE  RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "       AND RD0_IDESCR = ' ' "
		cSQL += "       AND RD0_IDENT <> ' ' "
		cSQL += "       AND RD0.D_E_L_E_T_ = ' ' "
		TcSqlExec( cSQL )
		AAdd( aLog, "Update para o campo RD0_IDESCR executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_IDESCR não executado, pois o campos não existe na tabela.")
	Endif	
	//------------------------------------------------------------------------------------------------
	// Atualizar o nome do líder.
	//------------------------------------------------------------------------------------------------
	If RD0->( FieldPos( 'RD0_NOMLID' ) ) > 0
		cSQL := "UPDATE "+RetSqlName("RD0")+" RD01"
		cSQL += "SET    RD01.RD0_NOMLID = NVL((SELECT RD02.RD0_NOME "
		cSQL += "                              FROM   "+RetSqlName("RD0")+" RD02 "
		cSQL += "                              WHERE  RD02.RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "                                     AND RD02.D_E_L_E_T_ = ' ' "
		cSQL += "                                     AND RD02.RD0_CODIGO = RD01.RD0_CODLID), ' ' ) "
		cSQL += "WHERE  RD01.RD0_FILIAL = "+ValToSql("RD0")+" "
		cSQL += "       AND RD01.RD0_CODLID <> ' ' "
		cSQL += "       AND RD01.D_E_L_E_T_ = ' ' "
		TcSqlExec( cSQL )
		AAdd( aLog, "Update para o campo RD0_NOMLID executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_NOMLID não executado, pois o campos não existe na tabela.")
	Endif	
	//------------------------------------------------------------------------------------------------
	// Atualizar o nome da função.
	//------------------------------------------------------------------------------------------------
	If RD0->( FieldPos( 'RD0_DESFUN' ) ) > 0
		cSQL := "UPDATE "+RetSqlName("RD0")+" RD0 "
		cSQL += "SET    RD0_DESFUN = ( SELECT RJ_DESC "
		cSQL += "                      FROM   "+RetSqlName("SRJ")+" SRJ "
		cSQL += "                      WHERE  RJ_FILIAL = "+ValToSql(xFilial("SRJ"))+" "
		cSQL += "                             AND RJ_FUNCAO = RD0_FUNCAO "
		cSQL += "                             AND SRJ.D_E_L_E_T_ = ' ' ) "
		cSQL += "WHERE  RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "       AND RD0_DESFUN = ' ' "
		cSQL += "       AND RD0_FUNCAO <> ' ' "
		cSQL += "       AND RD0.D_E_L_E_T_ = ' ' "
		TcSqlExec( cSQL )
		AAdd( aLog, "Update para o campo RD0_DESFUN executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_DESFUN não executado, pois o campos não existe na tabela.")
	Endif	
	//------------------------------------------------------------------------------------------------
	// Atualizar o nome do cargo.
	//------------------------------------------------------------------------------------------------
	If RD0->( FieldPos( 'RD0_DESCAR' ) ) > 0
		cSQL := "UPDATE "+RetSqlName("RD0")+" RD0 "
		cSQL += "SET    RD0_DESCAR = ( SELECT Q3_DESCSUM "
		cSQL += "                      FROM   "+RetSqlName("SQ3")+" SQ3 "
		cSQL += "                      WHERE  Q3_FILIAL = "+ValToSql(xFilial("SQ3"))+" "
		cSQL += "                             AND Q3_CARGO = RD0_CARGO "
		cSQL += "                             AND SQ3.D_E_L_E_T_ = ' ' ) "
		cSQL += "WHERE  RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "       AND RD0_DESCAR = ' ' "
		cSQL += "       AND RD0_CARGO <> ' ' "
		cSQL += "       AND RD0.D_E_L_E_T_ = ' ' "
		TcSqlExec( cSQL )
		AAdd( aLog, "Update para o campo RD0_DESCAR executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_DESCAR não executado, pois o campos não existe na tabela.")
	Endif	
	//------------------------------------------------------------------------------------------------
	// Atualizar o nome do turno
	//------------------------------------------------------------------------------------------------	
	If RD0->( FieldPos( 'RD0_DESTUR' ) ) > 0
		cSQL := "UPDATE "+RetSqlName("RD0")+" RD0 "
		cSQL += "SET    RD0_DESTUR = ( SELECT R6_DESC "
		cSQL += "                      FROM   "+RetSqlName("SR6")+" SR6 "
		cSQL += "                      WHERE  R6_FILIAL = "+ValToSql(xFilial("SR6"))+" "
		cSQL += "                             AND R6_TURNO = RD0_TURNO "
		cSQL += "                             AND SR6.D_E_L_E_T_ = ' ' ) "
		cSQL += "WHERE  RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "       AND RD0_DESTUR = ' ' "
		cSQL += "       AND RD0_TURNO <> ' ' "
		cSQL += "       AND RD0.D_E_L_E_T_ = ' ' "
		TcSqlExec( cSQL )
		AAdd( aLog, "Update para o campo RD0_DESTUR executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_DESTUR não executado, pois o campos não existe na tabela.")
	Endif	
	//------------------------------------------------------------------------------------------------
	// Atualizar a situação do participante 1=Normal.
	//------------------------------------------------------------------------------------------------	
	If RD0->( FieldPos( 'RD0_SITUAC' ) ) > 0
		cSQL := "UPDATE "+RetSqlName("RD0")+" RD0 "
		cSQL += "SET    RD0_SITUAC = '1' "
		cSQL += "WHERE  RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "       AND RD0_SITUAC = ' ' "
		cSQL += "       AND RD0.D_E_L_E_T_ = ' ' "
		TcSqlExec( cSQL )
		AAdd( aLog, "Update para o campo RD0_SITUAC executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_SITUAC não executado, pois o campos não existe na tabela.")
	Endif	
	//------------------------------------------------------------------------------------------------
	// Atualizar o campo alocação do participante.
	//------------------------------------------------------------------------------------------------	
	If RD0->( FieldPos( 'RD0_ALOCAD' ) ) > 0
		cSQL := "UPDATE "+RetSqlName("RD0")+" RD0 "
		cSQL += "SET    RD0_ALOCAD = '2' "
		cSQL += "WHERE  RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "       AND RD0_ALOCAD = ' ' "
		cSQL += "       AND RD0.D_E_L_E_T_ = ' ' "
		TcSqlExec( cSQL )
		AAdd( aLog, "Update para o campo RD0_ALOCAD executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_ALOCAD não executado, pois o campos não existe na tabela.")
	Endif	
	//------------------------------------------------------------------------------------------------
	// Atualizar o campo nome do posto de alocação.
	//------------------------------------------------------------------------------------------------	
	If RD0->( FieldPos( 'RD0_DESPOS' ) ) > 0
		cSQL := "UPDATE "+RetSqlName("RD0")+" RD0 "
		cSQL += "SET    RD0_DESPOS = ( SELECT Z3_DESENT "
		cSQL += "                      FROM   "+RetSqlName("SZ3")+" SZ3 "
		cSQL += "                      WHERE  Z3_FILIAL = "+ValToSql(xFilial("SZ3"))+" "
		cSQL += "                             AND Z3_CODENT = RD0_POSTO "
		cSQL += "                             AND SZ3.D_E_L_E_T_ = ' ' ) "
		cSQL += "WHERE  RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
		cSQL += "       AND RD0_DESPOS = ' ' "
		cSQL += "       AND RD0.D_E_L_E_T_ = ' ' "
	TcSqlExec( cSQL )
		AAdd( aLog, "Update para o campo RD0_DESPOS executado com sucesso.")
	Else
		AAdd( aLog, "Update para o campo RD0_DESPOS não executado, pois o campos não existe na tabela.")
	Endif	
	cMsg := 'Final do processo, leia o log.' + CRLF 
	For nI := 1 To Len( aLog )
		cMsg += aLog[ nI ] + CRLF
	Next nI
	MsgAlert( cMsg )
Return
//-----------------------------------------------------------------------
// Rotina | UPD380     | Autor | Robson Gonçalves     | Data | 28.03.2014
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD380()
	Local cModulo := 'APD'
	Local bPrepar := {|| U_U380Ini() }
	Local nVersao := 1
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return
//-----------------------------------------------------------------------
// Rotina | U380Ini    | Autor | Robson Gonçalves     | Data | 28.03.2014
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U380Ini()
	Local nP := 0
	Local aX3_FOLDER := {}
	
	aSIX := {}
	aSX2 := {}
	aSX3 := {}
	aSX7 := {}
	aSXA := {}
	aSXB := {}
	aHelp := {}
	
	// Consulta SXB somente para líder.
	AAdd( aSXB, { 'RD0LID', '1', '01', 'DB', 'Lideres'      , 'Lideres'      , 'Lideres'      , 'RD0'            , '' } )
	AAdd( aSXB, { 'RD0LID', '2', '01', '01', 'Codigo'       , 'Codigo'       , 'Codigo'       , ''               , '' } )
	AAdd( aSXB, { 'RD0LID', '2', '02', '02', 'Nome do lider', 'Nome do lider', 'Nome do lider', ''               , '' } )
	AAdd( aSXB, { 'RD0LID', '4', '01', '01', 'Codigo'       , 'Codigo'       , 'Codigo'       , 'RD0_CODIGO'     , '' } ) 
	AAdd( aSXB, { 'RD0LID', '4', '01', '02', 'Nome do lider', 'Nome do lider', 'Nome do lider', 'RD0_NOME'       , '' } )
	AAdd( aSXB, { 'RD0LID', '4', '02', '01', 'Nome do lider', 'Nome do lider', 'Nome do lider', 'RD0_NOME'       , '' } )
	AAdd( aSXB, { 'RD0LID', '4', '02', '02', 'Codigo'       , 'Codigo'       , 'Codigo'       , 'RD0_CODIGO'     , '' } )
	AAdd( aSXB, { 'RD0LID', '5', '01', ''  , ''             , ''             , ''             , 'RD0->RD0_CODIGO', '' } )
	AAdd( aSXB, { 'RD0LID', '6', '01', ''  , ''             , ''             , ''             , 'RD0->RD0_LIDER=="1"' , '' } )
	
	// Filtro para consulta SXB somente para mentor.
	AAdd( aSXB, { 'RD0MEN', '6', '01', ''  , ''             , ''             , ''             , 'RD0_MENTOR=="1"', '' } )

	// Campos da pasta operacional.
	aX3_FOLDER := { "RD0_CODMEN","RD0_NOMMEN","RD0_DTADEM","RD0_BANCO" ,"RD0_AGENCI","RD0_DVAGEN","RD0_NUMCTA",;
	                "RD0_DVCTA" ,"RD0_OBSERV","RD0_CODLID","RD0_NOMLID","RD0_FUNCAO","RD0_DESFUN","RD0_CARGO" ,;
	                "RD0_DESCAR","RD0_TURNO" ,"RD0_DESTUR","RD0_DEMISS","RD0_POSTO" ,"RD0_DESPOS","RD0_LIDER" ,;
	                "RD0_MENTOR","RD0_SITUAC","RD0_ALOCAD"}

	// Configurar os campos para pasta Cadastrais ou Operacional.
	SX3->( dbSetOrder( 1 ) )
	SX3->( dbSeek( "RD0" ) )
	While .NOT. SX3->( EOF() ) .And. SX3->X3_ARQUIVO == "RD0"
		nP := AScan( aX3_FOLDER, RTrim( SX3->X3_CAMPO ) )
		SX3->( RecLock( "SX3", .F. ) )
		SX3->X3_FOLDER := Iif(nP==0,"1","2")
		SX3->( MsUnLock() )
		SX3->( dbSkip() )
	End
	
   AAdd( aSXA, { "RD0", "1", "Cadastrais", "Cadastrais", "Cadastrais", "U" } )
   AAdd( aSXA, { "RD0", "2", "Operacional", "Operacional", "Operacional", "U" } )
   
	AAdd( aSX3, { "SRJ",NIL,"RJ_MENTOR","C",1,0,"Mentor?","Mentor?","Mentor?","Mentor?","Mentor?","Mentor?","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R",;
	"","Pertence('12')","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","","","","","N","N","","" } )

	AAdd( aHelp, { "RJ_MENTOR", "Informe SIM se este cargo é de mentor." } )

	AAdd( aSX7, { 'RD0_CODLID','001','RD0->RD0_NOME'  ,'RD0_NOMLID','P','S','RD0',1,'xFilial("RD0")+M->RD0_CODLID','','U' } )
	AAdd( aSX7, { 'RD0_FUNCAO','001','SRJ->RJ_DESC'	  ,'RD0_DESFUN','P','S','SRJ',1,'xFilial("SRJ")+M->RD0_FUNCAO','','U' } )
	AAdd( aSX7, { 'RD0_CARGO' ,'001','SQ3->Q3_DESCSUM','RD0_DESCAR','P','S','SQ3',1,'xFilial("SQ3")+M->RD0_CARGO' ,'','U' } )
	AAdd( aSX7, { 'RD0_TURNO' ,'001','SR6->R6_DESC'   ,'RD0_DESTUR','P','S','SR6',1,'xFilial("SR6")+M->RD0_TURNO' ,'','U' } )

	AAdd( aSX3, { "SZ3",NIL,"Z3_REGION" ,"C", 3,0,"Regiao posto" ,"Regiao posto" ,"Regiao posto" ,"Regiao do posto"          ,"Regiao do posto"          ,"Regiao do posto"          ,"@!",""               ,"€€€€€€€€€€€€€€ ","","PA4"   ,0,"þÀ","","S","U","N","A","R","","ExistCpo('PA4')","","","","","","","","1","","","","","N","N","","" } )
	AAdd( aSX3, { "SZ3",NIL,"Z3_DESREGI","C",30,0,"Nome regiao"  ,"Nome regiao"  ,"Nome regiao"  ,"Nome da regiao"           ,"Nome da regiao"           ,"Nome da regiao"           ,"@!",""               ,"€€€€€€€€€€€€€€ ","",""      ,0,"þA","","" ,"U","N","V","V","","","","","","","","","","1","","","","","N","N","","" } )
	AAdd( aSX3, { "SZ3",NIL,"Z3_CAPMAX" ,"N", 3,0,"Capacidade"   ,"Capacidade"   ,"Capacidade"   ,"Capacidade maxima"        ,"Capacidade maxima"        ,"Capacidade maxima"        ,"@E 999",""           ,"€€€€€€€€€€€€€€ ","",""      ,0,"þA","","" ,"U","N","A","R","","Positivo()","","","","","","","","1","","","","","N","N","","" } )
	AAdd( aSX3, { "SZ3",NIL,"Z3_QTDALOC","N", 3,0,"Qt.Alocado"   ,"Qt.Alocado"   ,"Qt.Alocado"   ,"Quantidade alocado"       ,"Quantidade alocado"       ,"Quantidade alocado"       ,"@E 999",""           ,"€€€€€€€€€€€€€€ ","",""      ,0,"þA","","" ,"U","N","V","R","","","","","","","","","","1","","","","","N","N","","" } )

	AAdd( aHelp, { "Z3_REGION"  , "Codigo da região do posto." } )
	AAdd( aHelp, { "Z3_DESREGI" , "Nome da região do posto." } )
	AAdd( aHelp, { "Z3_QTDALOC" , "Quantidade de participantes alocados." } )
	AAdd( aHelp, { "Z3_CAPMAX"  , "Capacidade maxima de agentes que pode ser alocado no posto." } )

	AAdd( aSX7, { 'Z3_REGION' ,'001','PA4->PA4_DESCRI','Z3_DESREGI','P','S','PA4',1,'xFilial("PA4")+M->Z3_REGION' ,'','U' } )

	AAdd( aSX2, { "PAH",NIL,"MOVIMENTOS PARTIC.ENTRE POSTOS","MOVIMENTOS PARTIC.ENTRE POSTOS","MOVIMENTOS PARTIC.ENTRE POSTOS","C","" } )

	
	AAdd( aSX3, { "PAH",NIL,"PAH_FILIAL","C",2,0,"Filial"        ,"Sucursal"     ,"Branch"       ,"Filial do Sistema"        ,"Sucursal"                 ,"Branch of the System"     ,"@!"         ,""      ,"€€€€€€€€€€€€€€€","",""      ,1,"þÀ","","","U","N","" ,"","","","","","","","","","033","","","","","","","","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_CODIGO","C",6,0,"Participante"  ,"Participante" ,"Participante" ,"Codigo do participante"   ,"Codigo do participante"   ,"Codigo do participante"   ,"@!"         ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )	
	AAdd( aSX3, { "PAH",NIL,"PAH_NOMPAR","C",30,0,"Nome Partic." ,"Nome Partic." ,"Nome Partic." ,"Nome do participante"     ,"Nome do participante"     ,"Nome do participante"     ,"@!"         ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_SEQ"   ,"C",3,0,"Sequencia"     ,"Sequencia"    ,"Sequencia"    ,"Sequencia de alocacao"    ,"Sequencia de alocacao"    ,"Sequencia de alocacao"    ,"@!"         ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_POSTO" ,"C",6,0,"Posto Alocad"  ,"Posto Alocad" ,"Posto Alocad" ,"Posto alocado"            ,"Posto alocado"            ,"Posto alocado"            ,"@!"         ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_NOMPOS","C",100,0,"Nome Posto"  ,"Nome Posto"   ,"Nome Posto"   ,"Nome do posto"            ,"Nome do posto"            ,"Nome do posto"            ,"@!"         ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )	
	AAdd( aSX3, { "PAH",NIL,"PAH_PERINI","D",8,0,"Periodo Ini."  ,"Periodo Ini." ,"Periodo Ini." ,"Periodo inicial da aloc." ,"Periodo inicial da aloc." ,"Periodo inicial da aloc." ,""           ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_PERFIM","D",8,0,"Periodo Fim"   ,"Periodo Fim"  ,"Periodo Fim"  ,"Periodo final de aloc."   ,"Periodo final de aloc."   ,"Periodo final de aloc."   ,""           ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_USER"  ,"C",6,0,"Usuario"       ,"Usuario"      ,"Usuario"      ,"Codigo do usuario"        ,"Codigo do usuario"        ,"Codigo do usuario"        ,"@!"         ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þA","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_DATA"  ,"D",8,0,"Dt Movimento"  ,"Dt Movimento" ,"Dt Movimento" ,"Data do movimento"        ,"Data do movimento"        ,"Data do movimento"        ,"99/99/99"   ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þA","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_HORA"  ,"C",8,0,"Hr Movimento"  ,"Hr Movimento" ,"Hr Movimento" ,"Hora do movimento"        ,"Hora do movimento"        ,"Hora do movimento"        ,"@R 99:99:99",""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þA","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_OBSERV","C",100,0,"Observacao"  ,"Observacao"   ,"Observacao"   ,"Observacao"               ,"Observacao"               ,"Observacao"               ,"@!"         ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þA","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_STATUS","C",1,0,"Status"        ,"Status"       ,"Status"       ,"Status"                   ,"Status"                   ,"Status"                   ,"@!"         ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þA","","","U","S","V","R","","","1=Alocado;2=Desalocado","1=Alocado;2=Desalocado","1=Alocado;2=Desalocado","","","","","","","","","","N","N","","" } )
	AAdd( aSX3, { "PAH",NIL,"PAH_DTDESA","D",8,0,"Dt.Desalocac"  ,"Dt.Desalocac" ,"Dt.Desalocac" ,"Data da desalocacao"      ,"Data da desalocacao"      ,"Data da desalocacao"      ,"99/99/99"   ,""      ,"€€€€€€€€€€€€€€ ","",""      ,0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","" } )
	
	AAdd( aHelp, { "PAH_FILIAL" , "Filial do sistema." } )
	AAdd( aHelp, { "PAH_CODIGO" , "Codigo do participante." } )
	AAdd( aHelp, { "PAH_NOMPAR" , "Nome do participante." } )
	AAdd( aHelp, { "PAH_SEQ"    , "Sequencia de alocacao." } )
	AAdd( aHelp, { "PAH_POSTO"  , "Codigo do posto alocado." } )
	AAdd( aHelp, { "PAH_NOMPOS" , "Nome do posto da entidade parceira." } )
	AAdd( aHelp, { "PAH_PERINI" , "Data inicial do período." } )
	AAdd( aHelp, { "PAH_PERFIM" , "Data final do período." } )
	AAdd( aHelp, { "PAH_USER"   , "Código do usuário que operou o movimento." } )
	AAdd( aHelp, { "PAH_DATA"   , "Data em que o usuário operou o movimento." } )
	AAdd( aHelp, { "PAH_HORA"   , "Hora em que o usuário operou o movimento." } )
	AAdd( aHelp, { "PAH_OBSERV" , "Observação registrada automaticamente pelo movimento." } )
	AAdd( aHelp, { "PAH_DTDESA" , "Data em foi desalocado o participante." } )
	
	AAdd( aSIX, { 'PAH', '1', 'PAH_FILIAL+PAH_CODIGO+PAH_SEQ+DTOS(PAH_PERINI)+DTOS(PAH_PERFIM)', 'Participante+Seq.Alocacao+Periodo Ini.+Periodo Fim', 'Participante+Seq.Alocacao+Periodo Ini.+Periodo Fim', 'Participante+Seq.Alocacao+Periodo Ini.+Periodo Fim', 'U','S' } )
Return

Static Function A380HCnt()
	Local oReport
	Local oSection1
	Local oSection11
	
	Local cPerg := 'A380HCNT'
	Local cName := cPerg
	
	Local cTRB := GetNextAlias()
	
	Local cTitulo := 'Relatório Head Count Custeio das AR'
	Local aAlocado := StrToKarr( Posicione( 'SX3', 2, 'RD0_ALOCAD', 'X3CBox()' ), ';' )
	Local aStatus  := StrToKarr( Posicione( 'SX3', 2, 'PAH_STATUS', 'X3CBox()' ), ';' )
	
	Private aOrd := { 'Centro de custo', 'Posto', 'Centro de Custo + Posto' }

	A380SX1( cPerg )
	Pergunte( cPerg, .F. )
	
	DEFINE REPORT oReport NAME cName TITLE cTitulo PARAMETER cPerg ACTION {|oReport| A380PrtRpt( oReport, cTRB, aOrd, cTitulo ) }
		DEFINE SECTION oSection1 OF oReport TITLE 'Centro de Custo' TABLES cTRB ORDERS aOrd
			DEFINE CELL NAME 'CTT_CUSTO'  OF oSection1 ALIAS cTRB BLOCK {|| (cTRB)->CTT_CUSTO } 
			DEFINE CELL NAME 'CTT_DESC01' OF oSection1 ALIAS cTRB BLOCK {|| (cTRB)->CTT_DESC01 } 
		
		DEFINE SECTION oSection11 OF oSection1 TITLE 'Movimento de Participante' TABLE cTRB TOTAL TEXT "Total de participantes" TOTAL IN COLUMN
			DEFINE CELL NAME 'Z3_CODENT'  OF oSection11 ALIAS cTRB BLOCK {|| (cTRB)->Z3_CODENT } 
			DEFINE CELL NAME 'Z3_DESENT'  OF oSection11 ALIAS cTRB BLOCK {|| (cTRB)->Z3_DESENT } 
			DEFINE CELL NAME 'RD0_CODIGO' OF oSection11 ALIAS cTRB BLOCK {|| (cTRB)->RD0_CODIGO } 
			DEFINE CELL NAME 'RD0_NOME'   OF oSection11 ALIAS cTRB BLOCK {|| (cTRB)->RD0_NOME } 
			DEFINE CELL NAME 'RD0_ALOCAD' OF oSection11 ALIAS cTRB BLOCK {|| aAlocado[ Val( (cTRB)->RD0_ALOCAD ) ] } 
			DEFINE CELL NAME 'PAH_SEQ'    OF oSection11 ALIAS cTRB BLOCK {|| (cTRB)->PAH_SEQ } 
			DEFINE CELL NAME 'PAH_DATA'   OF oSection11 ALIAS cTRB BLOCK {|| (cTRB)->PAH_DATA } 
			DEFINE CELL NAME 'PAH_PERINI' OF oSection11 ALIAS cTRB BLOCK {|| (cTRB)->PAH_PERINI } 
			DEFINE CELL NAME 'PAH_PERFIM' OF oSection11 ALIAS cTRB BLOCK {|| (cTRB)->PAH_PERFIM } 
			DEFINE CELL NAME 'PAH_STATUS' OF oSection11 ALIAS cTRB BLOCK {|| aStatus[ Val( (cTRB)->PAH_STATUS ) ] } 
						
			DEFINE FUNCTION FROM oSection11:Cell( 'Z3_CODENT' ) OF oSection11 FUNCTION COUNT TITLE 'Total de Participantes'

	oReport:SetLandScape()
	oReport:DisableOrientation()	
	oReport:PrintDialog()
Return

Static Function A380PrtRpt( oReport, cTRB, aOrd, cTitulo )
	Local oSection1 := oReport:Section(1)
	Local oSection11 := oReport:Section(1):Section(1)
	Local nOrder := oSection1:GetOrder()
	Local cMV_PAR01 := ''
	Local cMV_PAR02 := ''
	Local cOrder := ''
	
	If Empty( mv_par01 )
		mv_par01 := Space( Len( RD0->RD0_CC ) ) + '-' + Replicate( 'z', Len( RD0->RD0_CC ) )
	Endif
	
	If Empty( mv_par02 )
		mv_par02 := Space( Len( PAH->PAH_POSTO ) ) + '-' + Replicate( 'z', Len( PAH->PAH_POSTO ) )
	Endif
											
	cOrder := Iif( nOrder == 1, '%CTT_CUSTO, PAH_SEQ%', Iif( nOrder == 2, '%Z3_CODENT, PAH_SEQ%', '%CTT_CUSTO, Z3_CODENT, PAH_SEQ%' ) )	
	
	oReport:SetTitle( cTitulo+ " - Por ordem de: " + aOrd[ nOrder ] )
	
	MakeSqlExpr( oReport:GetParam() )
	
	cMV_PAR01 := '%'+mv_par01+'%'
	cMV_PAR02 := '%'+mv_par02+'%'

	oSection1:BeginQuery()
	
	BEGINSQL ALIAS cTRB
		SELECT CTT_CUSTO,
		       CTT_DESC01,
		       Z3_CODENT,
		       Z3_DESENT,
		       RD0_CODIGO,
		       RD0_NOME,
		       RD0_ALOCAD,
		       RD0_CC,
		       RD0_POSTO,
		       PAH_SEQ,
		       PAH_DATA,
		       PAH_PERINI,
		       PAH_PERFIM,
		       PAH_STATUS
		FROM   %table:PAH% PAH
		       INNER JOIN %table:RD0% RD0
		               ON RD0_FILIAL = %xFilial:RD0%
		              AND %exp:cMV_PAR01%
		              AND RD0.%notDel%
		       INNER JOIN %table:CTT% CTT
		               ON CTT_FILIAL = %xFilial:CTT%
		              AND CTT_CUSTO = RD0_CC
		              AND CTT.%notDel%
		       INNER JOIN %table:SZ3% SZ3
		              ON Z3_FILIAL = %xFilial:SZ3%
		             AND Z3_CODENT = PAH_POSTO
		             AND SZ3.%notDel%
		WHERE  PAH_FILIAL = %xFilial:PAH%
		       AND PAH_CODIGO = RD0_CODIGO
		       AND %exp:cMV_PAR02%
		       AND PAH.%notDel%
		ORDER  BY %exp:cOrder%
	ENDSQL 
	oSection1:EndQuery()
	
	oSection1:SetParentQuery()
	oSection11:SetParentFilter({|cParam| (cTRB)->RD0_CC == cParam }, {|| (cTRB)->CTT_CUSTO } )
	
	oSection1:Print()	
Return