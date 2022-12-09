//-----------------------------------------------------------------------
// Rotina | CSFA320    | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Cadastro de propostas - Gestão de Oportunidades.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
#Include 'Report.ch'
#Include 'AP5MAIL.ch'

Static cZZB_ARQUIV := ''
Static aObjeto     := {}

#DEFINE c320ArqIni 'propostas.ini'

User Function CSFA320()
	Local cDirDoc := GetMv('MV_DIRDOC')
	Local aSubMenu := {}
	Local cVar := ''
	Local nI := 0
	Local nP := 1
	Local aDir := {}
	Local cDir := ''
	Local cVar := ''
	Local cMV_320TEMP := 'MV_320TEMP'
	Private cCadastro := 'Cadastro de Propostas'
	Private aRotina := {}

	If .NOT. GetMv( cMV_320TEMP, .T. )
		CriarSX6( cMV_320TEMP, 'C', 'ENDERECO FISICO ONDE ESTAO ARMAZENADOS OS TEMPLATES DE PROPOSTAS. CSFA320.prw', 'servidor\dirdoc\templat\proposta\' )
	Endif
	
	cVar := GetMv( 'MV_320TEMP' )
	
	While .NOT. Empty( cVar ) .And. nP > 0
		nP := At('\', cVar )
		If nP == 0
			Exit
		Endif
		AAdd( aDir, SubStr( cVar, 1, nP-1 ) )
		cVar := SubStr( cVar, nP+1 )
	End
	
	For nI := 1 To Len( aDir )
		If Lower( aDir[ nI ] ) <> 'servidor'
			cDir += '\' + aDir[ nI ]
			MakeDir( cDir )
		Endif
	Next nI
	cDir := 'servidor' + cDir + '\'

	AAdd( aRotina, {'Pesquisar'  ,'AxPesqui' ,0, 1 } )
	AAdd( aRotina, {'Visualizar' ,'AxVisual' ,0, 2 } )
	AAdd( aRotina, {'Incluir'    ,'AxInclui' ,0, 3 } )
	AAdd( aRotina, {'Alterar'    ,'AxAltera' ,0, 4 } )

	If A320Admin()
		SetKey( VK_F11 , {|| A320ChgSX6() } )
		AAdd( aRotina, {'Excluir'    ,'AxDeleta' ,0, 5 } )		
	Endif

	AAdd( aSubMenu,{'Gerar'    ,'U_A320GVar()' ,0, 6 } )
	AAdd( aSubMenu,{'Imprimir' ,'U_A320IVar()' ,0, 6 } )
	AAdd( aRotina, {'Variáveis',aSubMenu       ,0 ,6 } )
	
	dbSelectArea('ZZB')
	dbSetOrder(1)
	
	MBrowse(,,,,'ZZB')
	SetKey( VK_F11 , {|| .T. })
Return

//-----------------------------------------------------------------------
// Rotina | A320File   | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina acionada pelo F3 do campo ZZB_ARQUIV, o objetivo é
//        | buscar o endereço físico do arquivo template Ms-Word.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A320File()
	Local aParam := {}	
	Local aRet := {}	
	Local cGet := M->ZZB_ARQUIV
	Local cEnd := ''
	Local cTypeFiles := ''
	Local bOk := {|| .T. }

	cEnd := GetMv( 'MV_320TEMP' )

	cTypeFiles := 'Templates MS-Word (*.dot)|*.dot'

	MsgInfo('ATENÇÃO! A rotina irá criticar se caso o nome físico do arquivo possuir acentos.',cCadastro)

	bOk := {|| NgTemAcento( mv_par01 ) }

	AAdd( aParam, { 6, 'Escolha Proposta Modelo...', cGet, '', 'NgTemAcento( mv_par01 )', '', 90, .T., cTypeFiles, cEnd } )

	If .NOT. ParamBox( aParam, 'Parâmetros...', @aRET,bOk )
		Return(.F.)
	Endif

	cZZB_ARQUIV := aRet[ 1 ]
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A320RetFile| Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar para alimentar o endereço do arquivo.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A320RetFile()
Return(cZZB_ARQUIV)

//-----------------------------------------------------------------------
// Rotina | A320Admin  | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para criticar se o usuário faz parte do grupo de Adm.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Admin()
	Local lRet := .T.
	Local cUser := ''	
	Local aGrupos := {}
	cUser := RetCodUsr()
	If cUser <> '000000'
		PswOrder( 1 )
		If PswSeek( cUser )
			aGrupos := PswRet( 1 )
			If AScan( aGrupos[1,10], '000000' ) == 0
				lRet := .F.
			Endif
		Endif
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A320GVar  | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ gerar as variáveis da integração Protheus com Word.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A320GVar()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private aCPO := {}
	Private aPicture := {}
	Private cTitulo := 'Integração Protheus x Ms-Word - Oportunidades e Televendas'
	Private cDescriRel := 'Gerar arquivo '+Upper(c320ArqIni)+' com as variáveis da integração Protheus x Ms-Word.'

	AAdd( aSay, cDescriRel )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpcao==1
		A320GerVar()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A320GerVar | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar as variáveis no arquivo ini.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320GerVar()
	Local nI := 0
	Local nJ := 0
	Local nHdl := 0
	Local nCount := 1
	Local cDado := ''
	Local cArqIni := ''
	Local cArqBkp := ''
	
	Local aCpos := {}
		
	cArqIni := c320ArqIni
	
	//----------------------------------------------------------------
	// Preparar um nome para back-up e renomear o arquivo caso exista.
	//----------------------------------------------------------------
	nI := At( '.', cArqIni )
	cArqBkp := SubStr( cArqIni, 1, nI-1 ) + '_bkp' + cValToChar( nCount ) + '.ini'
	While File( cArqBkp )
		nCount++
		cArqBkp := SubStr( cArqIni, 1, nI-1 ) + '_bkp' + cValToChar( nCount ) + '.ini'
	End
	
	//----------------------------------------------------------------------------------
	// Caso exista o arquivo, solicitar autorização para o usuário e renomear o arquivo.
	//----------------------------------------------------------------------------------
	If File( cArqIni )
		If .NOT. MsgYesNo('Já existe o arquivo de configuração: '+Upper(cArqIni)+;
		', para prosseguir o Protheus irá fazer um back-up e gerará um novo arquivo. Você quer prosseguir?',cTitulo)
			MsgInfo('Operação cancelada com sucesso.',cTitulo)
			Return
		Else
			If FRename( cArqIni, cArqBkp ) < 0			
				MsgAlert('Não foi possível renomear o arquivo, logo não será possível prosseguir.',cTitulo)
				Return
			Endif
		Endif
	Endif
	
	//----------------------------
	// Gerar o vetor com os dados.
	//----------------------------
	FWMsgRun(,{|| aCpos := A320Campos( cArqIni )},,'Aguarde, lendo dicionário de dados...')

	//---------------------
	// Gerar o arquivo INI.
	//---------------------
	nHdl := FCreate( cArqIni )
	
	For nI := 1 To Len( aCpos )
		For nJ := 1 To Len( aCpos[ nI ] )
			cDado += aCpos[ nI, nJ ] + '#'
		Next nJ
		cDado := SubStr( cDado, 1, Len( cDado )-1 )
		FWrite( nHdl, cDado + CRLF )
		cDado := ''
	Next nI
	
	FClose( nHdl )
	
	If MsgYesNo('Arquivo '+Upper(c320ArqIni)+' gerado com sucesso. Quer aproveitar e gerar a impressão das variáveis agora?', cTitulo)
		U_A320IVar()
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A320FIni  | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para criar o parâmetro com os prefixos de tabelas que
//        | farão parte do processo de integração com propostas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320FIni()
	Local cMV_320FINI := 'MV_320FINI'
	If .NOT. SX6->( ExisteSX6( cMV_320FINI ) )
		CriarSX6( cMV_320FINI, 'C', 'TABELAS QUE COMPOE A ESTRUTURA DE INTEGRACAO DE PROSPOTAS PROTHEUS x WORD - Oportunidade e Televendas. Rotina acionada por CSFA320.prw',;
		                            'AD1;AD5;ADJ;SA1;SA3;SB1;SU5;SUS;SUA;SUB' )
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A320Campos | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para buscar campos conforme SX3.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Campos()
	Local nI := 0
	Local aTab := {}
	Local aCpos := {}
	
	A320FIni()
	aTab := StrtoKarr( GetMv( 'MV_320FINI' ),';')
	
	SX3->( dbSetOrder( 1 ) )
	For nI := 1 To Len( aTab )
		SX3->( dbSeek( aTab[ nI ] ) )
		While (.NOT. SX3->( EOF() ) ) .And. SX3->X3_ARQUIVO == aTab[ nI ]
			If X3Uso(SX3->X3_USADO) .And. SX3->X3_CONTEXT <> 'V'
				// [1] Nome do campo no Word -> DocVariable
				// [2] Nome do campo no Protheus,
				// [3] Título do campo.
				// [4] Descrição do campo.
				// [6] Dado do campo que ainda será inserido.
				AAdd( aCpos, { 'PRO_'+RTrim(SX3->X3_CAMPO), ;
				               SX3->X3_ARQUIVO+'->'+RTrim(SX3->X3_CAMPO), ;
				               RTrim(SX3->X3_TITULO), ;
				               RTrim(SX3->X3_DESCRIC),;
				               '' })
			Endif
			SX3->( dbSkip() )
		End
	Next nI 
Return( aCpos )

//-----------------------------------------------------------------------
// Rotina | A320IVar  | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de impressão das variáveis da integração Protheus com
//        | Ms-Word.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A320IVar()
	Local oReport 
	
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private aCPO := {}
	Private aPicture := {}
	Private cTitulo := 'Integração Protheus x Ms-Word - Oportunidades e Televendas'
	Private cDescriRel := 'Impressão das variáveis da integração Protheus x Word - Oportunidades e Televendas'

	AAdd( aSay, cDescriRel )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpcao==1
		If File(c320ArqIni)
			oReport := A320Impr()
			oReport:PrintDialog()
		Else
			MsgAlert('Não foi possível localizar o arquivo '+c320ArqIni+', logo não será possível prosseguir.',cTitulo)
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A320Impr   | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento para impressão das variáveis.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Impr()
	Local aDados := {}
	
	Local nX := 0
	
	Local aCpos := {} 
	Local aAlign := {}
	Local aHeader := {}
	
	Local cPerg := ''
	Local cArqIni := ''
	Local cReport := FunName()
	Local cDescri := 'Impresão das variáveis disponíveis para a ' + cTitulo
	
	Private oCell
	Private oReport 
	Private oSection 	
	
	cArqIni := c320ArqIni
	
	FWMsgRun(,{|| aCpos := A320LerIni( cArqIni )},,'Aguarde, lendo arquivo INI...')
	
	aHeader := {'Seq'                             +CRLF+'.',;
	            'Campos Ms-Word'                  +CRLF+'.',;
	            'Campos do Protheus'              +CRLF+'.',;
	            'Títulos dos Campos'              +CRLF+'.',;
	            'Descrição dos Campos do Protheus'+CRLF+'.',;
	            ' '                               +CRLF+'.' }
	
	//--------------------
	// Tamanho das colunas
	//--------------------
	aAlign := {3,15,15,30,25,1}
	//         | |  |  |  |  |
	//         | |  |  |  |  +-> Dados do campos da tabela.
	//         | |  |  |  +----> Descrição dos Campos do Protheus
	//         | |  |  +-------> Títulos dos Campos
	//         | |  +----------> Campos do Protheus
	//         | +-------------> Campos Ms-Word
	//         +---------------> Sequencia

	oReport  := TReport():New( cReport, cTitulo, cPerg , { |oObj| A320RptPrt( oObj, aHeader, aCpos ) }, cDescri )
	oReport:DisableOrientation()
	oReport:SetEnvironment(2)       // Ambiente selecionado. Opções: 1-Server e 2-Cliente.
	oReport:cFontBody := 'Consolas' // Fonte definida para impressão do relatório (Consolas/Courier New)
	oReport:nFontBody	:= 9          // Tamanho da fonte definida para impressão do relatório.
	oReport:nLineHeight := 25       // Altura da linha.
	oReport:SetPortrait() 

	DEFINE SECTION oSection OF oReport TITLE cTitulo TOTAL IN COLUMN
	
	For nX := 1 To Len( aHeader ) 
		DEFINE CELL oCell NAME 'CEL'+Alltrim(Str(nX-1)) OF oSection SIZE aAlign[ nX ] TITLE aHeader[ nX ]
	Next nX
	
	oSection:SetColSpace( 1 )       // Define o espaçamento entre as colunas.
	oSection:nLinesBefore := 2      // Quantidade de linhas a serem saltadas antes da impressão da seção.
	oSection:SetLineBreak(.T.)      // Define que a impressão poderá ocorrer em uma ou mais linhas no caso das colunas exederem o tamanho da página.
Return( oReport )

//-----------------------------------------------------------------------
// Rotina | A320RptPrt | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para imprimir as linhas do relatório.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320RptPrt( oReport, aHeader, aDados )
	Local nI := 0
	Local nJ := 0
	Local nCPO := 1
	Local nSeq := 0
	Local nCinza  := RGB( 217, 217, 217 )
	
	Local cDado := ''
	
	Local aRect := {}
	Local oSection := oReport:Section( 1 )
	Local oPintaCinza := TBrush():New(,nCinza)
	
	Local aMV_320FINI := {}
	
	oReport:SetMsgPrint('Aguarde, imprimindo as variáveis...')
	oReport:SetMeter( Len( aDados ) )	
	oSection:Init()
	
	nCPO := Len( aHeader )
	
	aRect := {0,0,0,0}
	aRect[ 4 ] := oReport:PageWidth()
	
	//--------------------------------
	// Variáveis internas do Protheus.
	AAdd( aDados, NIL )
	AIns( aDados, 1 )
	aDados[ 1 ] := Array( 5 )
	aDados[ 1, 1 ] := 'PRO_DATABASE'
	aDados[ 1, 2 ] := 'dDataBase'
	aDados[ 1, 3 ] := 'Data base do sistema'
	aDados[ 1, 4 ] := 'Variável interna Protheus'
	aDados[ 1, 5 ] := ''

	AAdd( aDados, NIL )
	AIns( aDados, 2 )
	aDados[ 2 ] := Array( 5 )
	aDados[ 2, 1 ] := 'PRO_320VERSAO'
	aDados[ 2, 2 ] := 'n320Versao'
	aDados[ 2, 3 ] := 'Versão da proposta'
	aDados[ 2, 4 ] := 'Variável interna Protheus'
	aDados[ 2, 5 ] := ''
	
	AAdd( aDados, NIL )
	AIns( aDados, 3 )
	aDados[ 3 ] := Array( 5 )
	aDados[ 3, 1 ] := 'PRO_320QTITENS'
	aDados[ 3, 2 ] := 'n320QtItens'
	aDados[ 3, 3 ] := 'Quantidade de itens'
	aDados[ 3, 4 ] := 'Variável interna Protheus'
	aDados[ 3, 5 ] := ''	
	
	AAdd( aDados, NIL )
	AIns( aDados, 4 )
	aDados[ 4 ] := Array( 5 )
	aDados[ 4, 1 ] := 'PRO_320VLTOTAL'
	aDados[ 4, 2 ] := 'n320VlTotal'
	aDados[ 4, 3 ] := 'Valor total da oportunidade'
	aDados[ 4, 4 ] := 'Variável interna Protheus'
	aDados[ 4, 5 ] := ''	

	AAdd( aDados, NIL )
	AIns( aDados, 5 )
	aDados[ 5 ] := Array( 5 )
	aDados[ 5, 1 ] := 'PRO_320VLEXTEN'
	aDados[ 5, 2 ] := 'c320VlExten'
	aDados[ 5, 3 ] := 'Extenso do valor total'
	aDados[ 5, 4 ] := 'Variável interna Protheus'
	aDados[ 5, 5 ] := ''	
		
	//-------------------------------------------------------------------------------------
	// Função para verificar se o parâmetro MV_320FINI existe, caso não exista será criado.
	A320FIni()
	//--------------------------------------------
	// Nome das tabelas utilizadas neste processo.
	aMV_320FINI := StrToKarr( GetMv('MV_320FINI'), ';' )	

	nJ := 5
	For nI := 1 To Len( aMV_320FINI )
		nJ++
		AAdd( aDados, NIL )
		AIns( aDados, nJ )
		aDados[ nJ ] := Array( 5 )
		aDados[ nJ, 1 ] := aMV_320FINI[ nI ]
		aDados[ nJ, 2 ] := Replicate('.',15)
		aDados[ nJ, 3 ] := Replicate('.',15)
		aDados[ nJ, 4 ] := Capital( NgSx2Nome( aMV_320FINI[ nI ] ) )
		aDados[ nJ, 5 ] := Replicate('.',25)
	Next nI

	For nI := 1 To Len( aDados ) 
		If oReport:Cancel()
			Exit
		Endif
		//------------------------------------------------
		// Pintar de cinza a linha de impressão dos dados.
		If Mod(nI,2) == 0
			aRect[ 1 ] := oReport:Row()
			aRect[ 3 ] := oReport:Row() + oReport:LineHeight() * 2
			oReport:FillRect( aRect, oPintaCinza )
		Endif
		//--------------------
		// Imprimir os campos.
		nSeq++
		For nJ := 1 To nCPO
			If nJ == 1
				oSection:Cell( 'CEL' + LTrim( Str( nJ-1 ) ) ):SetBlock( &( "{ || '" + StrZero(nSeq,3,0) + "'}" ) )
			Else
				cDado := aDados[ nI, nJ-1 ]
				cDado := StrTran( cDado, "'", "" )
				oSection:Cell( 'CEL' + LTrim( Str( nJ-1 ) ) ):SetBlock( &( "{ || '" + cDado + "'}" ) )
			Endif
		Next nJ
		oSection:PrintLine()
		oReport:IncMeter()		
	Next nI
	oReport:PrintText('TOTAL DE CAMPOS: ' + LTrim( Str( Len( aDados ) ) ) )
	oSection:Finish()
Return

//-----------------------------------------------------------------------
// Rotina | A320LerIni | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para ler os dados do arquivo INI.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320LerIni( cArqIni )
	Local cLine := ''
	Local aCpos := {}
	Local nSeq := 0
	FT_FUSE( cArqIni )
	FT_FGOTOP()
	While .NOT. FT_FEOF()
		nSeq++
		cLine := FT_FREADLN()
		AAdd( aCpos, A320Array( cLine ) )
		FT_FSKIP()
	End
	FT_FUSE()
Return( aCpos )

//-----------------------------------------------------------------------
// Rotina | A320Array  | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para transformar a linha de dados em vetor.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Array( cLinha, nSeq )
	Local nP := 0
	Local aArray := {}
	Local cDelim := '#'
	If Right( cLinha, 1 ) <> cDelim
		cLinha := cLinha + cDelim
	Endif
	While .NOT. Empty( cLinha )
		nP := At( cDelim, cLinha )
		If nP > 0
			AAdd( aArray, SubStr( cLinha, 1, nP-1 ) )
			cLinha := SubStr( cLinha, nP+1 )
		Endif
	End
	AAdd( aArray, ' ' ) // Este elemento está sendo adicionado para colocar o dado quando for buscar da tabela de dados.
Return( aArray )

//-----------------------------------------------------------------------
// Rotina | A320IPro | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para garantir o momento do processo de impressão e 
//        | posicionar o último apontamento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A320IPro()
	Local cSQL := ''
	Local cTRB := ''
	Local nOpcao := 0
	Local nAD5_MAXRECNO := 0
	
	Local cTitulo    := 'Gestão de Oportunidades - Gerar Propostas'
	Local cMV_320COD := 'MV_320COD'
	Local cCodDe     := ''
	Local cCodAte    := ''
	Local cCod       := ''
	Local cAviso     := 'Prezado, a geração da proposta comercial só poderá ser realizada para oportunidades que estejam no estágio 004 ou 005. '
	Local cAviso     += 'Por gentileza, movimente a oportunidade para um destes estágios e gere o documento.'
	
	Local aSay := {}
	Local aButton := {}

	AAdd( aSay, 'Rotina para gerar proposta, seu objetivo é gerar um novo documento com base nos' ) 
	AAdd( aSay, 'dados da Oportunidade em questão e por fim anexar o arquivo ao Conhecimento.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Caso queira imprimir um documento, dirija-se a opção Conhecimento e selecione' )
	AAdd( aSay, 'o documento que desejar.' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpcao==1
		If .NOT. SX6->( ExisteSX6( cMV_320COD ) )
			CriarSX6( cMV_320COD, 'C', 'Estagio anterior que encontra-se da oportunidade para gerar a proposta. CSFA320.prw', '004|005' )
		Endif
				
		If AD1->AD1_PROVEN=='000001'
			cCod     := SubStr( GetMv( cMV_320COD   ), 5, 3 )
		Elseif AD1->AD1_PROVEN=='000002'
			cCodDe   := SubStr( GetMv( cMV_320COD   ), 1, 3 )
			cCodAte  := SubStr( GetMv( cMV_320COD   ), 5, 3 )
		Endif 
		
		If ( Left( AD1->AD1_STAGE, 3 ) >= cCodDe .And. Left( AD1->AD1_STAGE, 3 ) <= cCodAte ) .Or. ( Left( AD1->AD1_STAGE, 3 ) == cCod )
			cSQL := "SELECT MAX( AD5.R_E_C_N_O_ ) AD5_MAXRECNO "
			cSQL += "FROM   "+RetSqlName("AD5")+" AD5 "
			cSQL += "WHERE  AD5_FILIAL = "+ValToSql( xFilial( "AD5" ) )+" "
			cSQL += "       AND AD5_NROPOR = "+ValToSql(AD1->AD1_NROPOR)+" "
			cSQL += "       AND AD5.D_E_L_E_T_ = ' ' "
			
			cSQL := ChangeQuery( cSQL )
			cTRB := GetNextAlias()
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)
			nAD5_MAXRECNO := (cTRB)->(AD5_MAXRECNO)
			(cTRB)->(dbCloseArea())
			
			If nAD5_MAXRECNO > 0
				AD5->( dbGoTo( nAD5_MAXRECNO ) )
				U_A320Prop( AD1->AD1_NROPOR )
			Else
				MsgInfo('Apontamentos não localizado para a oportunidade Nº '+AD1->AD1_NROPOR+', por favor, consulte a equipe SAV.',cTitulo)
			Endif
	   Else
	   	MsgInfo(cAviso, cTitulo)
	   Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A320Prop | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para parametrizar o processo de impressão de proposta.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A320Prop( cAD5_NROPOR )
	Private cTitulo := 'Gestão de Oportunidade - Gerar Propostas'
	Processa( {|| A320Make( cAD5_NROPOR )}, cTitulo,'Aguarde processando...', .F. )
Return
Static Function A320Make( cAD5_NROPOR )
	Local cMV_320PROP := 'MV_320PROP'
	Local cMV_320FILT := 'MV_320FILT'
	Local cArqIni := c320ArqIni
	Local cFunName := FunName()
	Local aCpos := {}
	Local aFiles := {}
	Local oProcess  := NIL
	
  	Private aADJ_CPOS := {}
   Private aADJ_ITEM := {}
   Private l320Cliente := .T.
	
	//---------------------------------
	// Processos que serão processados.
	ProcRegua(5)
	
	If .NOT. SX6->( ExisteSX6( cMV_320PROP ) )
		CriarSX6( cMV_320PROP, 'L', 'Habilita a rotina de gerar propostas integrado com Gestao de Oportunidades. CSFA320.prw', '.F.' )
	Endif
	//---------------------------------------
	// Está habilitada a chave de integração?
	If GetMv( cMV_320PROP )
		//----------------------------------------------------------
		// Somente por meio das das funções abaixo é que as será impresso.
		If (cFunName$'FATA300|FATA310|CSFA110')
			//-----------------------------------
			// Verificar se existe o arquivo INI.
			If File( cArqIni )
				//-------------------------------------------------------------
				// Verificar possibilidade de filtro por descrição da proposta.
				If .NOT. SX6->( ExisteSX6( cMV_320FILT ) )
					CriarSX6( cMV_320FILT, 'C', 'Expressao AdvPL para filtrar as propostas por decricao em oportunidades. CSFA320.prw', '.NOT.("VDS" $ ZZB->ZZB_NOMEPR)' )
				Endif
				cMV_320FILT := GetMv( cMV_320FILT )
				//----------------------------------------------------
				// Selecionar os arquivos templates a serem impressos.
				If A320Select(@aFiles,cMV_320FILT)
					//----------------------------------------
					// Carregar os dados conforme arquivo INI.
					IncProc('Lendo arquivo INI.')
					aCpos := A320LerIni( c320ArqIni )
					//---------------------------------------------------------
					// Posicionar os registros das tabelas para carregar dados.
					IncProc('Posicionando os registros.')
					If A320Seek( cAD5_NROPOR, @aCpos )
						//--------------------------------------------------------------------------
						// Gerar os documentos conforme selecionados para a oportunidade em questão.
						IncProc('Integrando os dados com Ms-Word.')
						A320Word( cAD5_NROPOR, aFiles, aCpos )
						MsgInfo('Processo finalizado, verifique no Conhecimento o(s) documento(s) gerado(s).',cTitulo)
						If MsgYesNo('Deseja enviar a proposta por e-mail?', cTitulo)
							U_A320Email(cAD5_NROPOR, aObjeto)
						Endif
					Else
						MsgAlert('Oportunidade sem código de contato, por favor, informe o código do contato.',cTitulo)
					Endif
				Endif
			Else
				MsgAlert('Não foi localizado o arquivo '+Upper(c320ArqIni)+', por favor, buscar apoio junto a Sistemas Corporativos',cTitulo)
			Endif
		Endif
	Else
		MsgInfo('Opção de gerar proposta desabilitada, verifique o parâmetro MV_320PROP',cTitulo)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A320Select | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para selecionar os arquivos a serem gerados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Select( aFiles, cFilter )
	Local aOrdem := {}
	Local aProposta:= {}

	Local lOk := .F.
	Local lMark := .F.
	
	Local cOrd := ''
	Local cSeek := Space(100)
	
	Local nI := 0
	Local nOrd := 1
	
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

	AAdd(aOrdem,'Nome do documento') 
	AAdd(aOrdem,'Código')
	
	ZZB->(DbSetOrder(1))
	If ZZB->(DbSeek(xFilial('ZZB')))
		While .NOT. ZZB->( EOF() ) .And. ZZB->ZZB_FILIAL == xFilial('ZZB')
			If ZZB->ZZB_MSBLQL <> '1'
				If .NOT. Empty( cFilter )
					If .NOT. &(cFilter)
						ZZB->(DbSkip())
						Loop
					Endif
				Endif
				ZZB->( AAdd( aProposta, { lMark, ZZB_CODIGO, RTrim(ZZB_NOMEPR), RTrim(ZZB_ARQUIV), ZZB_MACRO } ) )
			Endif
	    	ZZB->(DbSkip())
	    End
	EndIf
	
	If Len( aProposta ) > 0
		DEFINE MSDIALOG oDlg FROM  31,58 TO 350,777 TITLE 'Selecione os documentos modelos' PIXEL
			oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelTop:Align := CONTROL_ALIGN_TOP
			
		   @ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
			@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
			@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (A320Pesq(nOrd,cSeek,@oLbx))
			
			oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

			@ 40,05 LISTBOX oLbx FIELDS HEADER 'x','Código','Nome da proposta comercial' SIZE 350, 90 OF oPanelAll PIXEL ON ;
			dblClick(aProposta[oLbx:nAt,1]:=!aProposta[oLbx:nAt,1])
			oLbx:Align := CONTROL_ALIGN_ALLCLIENT
			oLbx:SetArray(aProposta)
			oLbx:bLine := { || {Iif(aProposta[oLbx:nAt,1],oOk,oNo),aProposta[oLbx:nAt,2],aProposta[oLbx:nAt,3]}}
			oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
			FWMsgRun(,{|| AEval(aProposta, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os documentos...') }
			
			oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelBot:Align := CONTROL_ALIGN_BOTTOM
	
			@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(A320Valid(aProposta,@lOk),oDlg:End(),NIL)
			@ 1,44 BUTTON oCancel  PROMPT 'Sair'  SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
		ACTIVATE MSDIALOG oDlg CENTER
	Else
		MsgInfo('Propostas comerciais não encontradas.',cTitulo)
	Endif
	
	If lOk
		For nI := 1 To Len( aProposta )
			If aProposta[ nI, 1 ]
				AAdd( aFiles, { aProposta[ nI, 3 ], aProposta[ nI, 4 ], aProposta[ nI, 5 ] } )
			Endif
		Next nI
	Else
		MsgAlert('Não será gerado nenhum documento.',cTitulo)
	Endif
Return(lOk)

//-----------------------------------------------------------------------
// Rotina | A320Pesq   | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de pesquisa na interface de seleção de arquivos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Pesq( nOrd, cSeek, oLbx )
	Local bAScan := {|| .T. }

	Local nBegin := 0
	Local nColPesq := 0
	Local nEnd := 0
	Local nP := 0
	
	nColPesq := Iif( nOrd == 1, 3, Iif( nOrd == 2, 2, ( MsgAlert('Opção não disponível para pesquisar.','Pesquisar'), 0 ) ) )
		
	If nColPesq > 0
		nBegin := Min( oLbx:nAt + 1, Len( oLbx:aArray ) )
		nEnd   := Len( oLbx:aArray )
		
		If oLbx:nAt == Len( oLbx:aArray )
			nBegin := 1
		Endif
		
		bAScan := {|p| Upper(AllTrim( cSeek ) ) $ AllTrim( p[nColPesq] ) } 
		
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )

		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('Informação não localizada.','Pesquisar')
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A320Valid  | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar se foi selecionado no mínimo um arquivo.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Valid( aProposta, lOk )
	Local nP := 0
	Local lRet := .T.
	nP := AScan( aProposta, {|p| p[1]==.T. } )
	If nP==0
		lRet := .F.
		MsgAlert('Não foi selecionado nenhuma proposta comercial para ser gerada.',cTitulo)
	Else
		lOk := lRet
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A320Seek   | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para posicionar e macro executar os campos p/ obter 
//        | seu conteúdo.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Seek( cAD5_NROPOR, aCpos )
	Local lRet := .T.
	Local lADJ := .F.
	
	Local nA := 0
	Local nI := 0
	Local nJ := 0
	Local nP := ''
	Local nQ := 0
	Local nElem := 0

	Local cTab := ''
	Local cCpo := ''
	Local cDado := ''
	Local cType := ''
	Local cPicture := '@E 999,999,999.99'
	Local cX3_CBOX := ''
	
	Local aSUS_SA1 := {}
	Local aX3_CBOX := {}
	
	Local lAD9 := .F.
	Local lSU5 := .F.
	Local lTabPreco := .F.
	Local cDesAmig  := ''
		
	// Posicionar os regristros.
	AD5->( dbSetOrder( 2 ) )
	AD5->( dbSeek( xFilial( 'AD5' ) + cAD5_NROPOR ) )
	
	AD1->( dbSetOrder( 1 ) )
	AD1->( dbSeek( xFilial( 'AD1' ) + cAD5_NROPOR ) )
	
	ADJ->( dbSetOrder( 1 ) )
	lADJ := ADJ->( dbSeek( xFilial( 'ADJ' ) + cAD5_NROPOR ) )
	
	// Contatos da propostas
	AD9->( dbSetOrder( 1 ) )
	lAD9 := AD9->( dbSeek( xFilial( 'AD9' ) + cAD5_NROPOR ) )
	If lAD9		
		// Dados do Contato
		SU5->( dbSetOrder( 1 ) )
		lSU5 := SU5->( dbSeek( xFilial( 'ADI' ) + AD9->AD9_CODCON ) )
	Endif	
	
	SA3->( dbSetOrder( 1 ) )
	SA3->( dbSeek( xFilial( 'SA3' ) + AD1->AD1_VEND ) )
	
	// Se não for prospect, posicionar o registro de cliente.
	If Empty( AD1->AD1_PROSPE ) 
		SA1->( dbSetOrder( 1 ) )
		SA1->( dbSeek( xFilial( 'SA1' ) + AD1->( AD1_CODCLI + AD1_LOJCLI ) ) )
	Else
		l320Cliente := .F.
		SUS->( dbSetOrder( 1 ) )
		SUS->( dbSeek( xFilial( 'SUS' ) + AD1->( AD1_PROSPE + AD1_LOJPRO ) ) )
	Endif
	
	// Ler todos os elementos (campos).
	For nI := 1 To Len( aCpos )
		// Caso não haja dados para o Contato da Oportunidade, não fazer nada, ou seja, deixar o dado em branco.
		If .NOT. lAD9 .And. .NOT. lSU5
			lRet := .F.
			Loop
		Endif
		
		// Se não for tabela + campo, apenas atribuir.
		If SubStr( aCpos[ nI, 2 ], 4, 2 ) <> '->'
			cType := ValType( &( aCpos[ nI, 2 ] ) )
			If     cType == 'D' ; cDado := Dtoc( &( aCpos[ nI, 2 ] ) )
			Elseif cType == 'N' ; cDado := LTrim( TransForm( &( aCpos[ nI, 2 ] ), cPicture ) )
			Elseif cType == 'C' ; cDado := &( aCpos[ nI, 2 ] ) ; cDado := StrTran( cDado, "'", '' )
			Endif

			aCpos[ nI, 5 ] := cDado

		// Se for tabela e campo macro executar o campo.
		Else
			// Capturar o alias.
 			cTab := Left( aCpos[ nI, 2 ], 3 )

			// Capturar o campo.
			cCpo := SubStr( aCpos[ nI, 2 ], 6 )

			// Capturar o tipo do dado.
			cType := ValType( (cTab)->( FieldGet( FieldPos( cCpo ) ) ) )

			// Avaliar o tipo do dado e transforma-lo em string.
			If     cType == 'D' ; cDado := Dtoc( (cTab)->( FieldGet( FieldPos( cCpo ) ) ) )
			Elseif cType == 'N' ; cDado := LTrim( TransForm( (cTab)->( FieldGet( FieldPos( cCpo ) ) ), cPicture ) ) 
			Elseif cType == 'C' ; cDado := (cTab)->( FieldGet( FieldPos( cCpo ) ) ) ; cDado := StrTran( cDado, "'", '' )
			Endif

			// Se for o campo cargo do vendedor, buscar a descrição do cargo na tabela SUM.
			If 'A3_CARGO' $ aCpos[ nI, 2 ] .And. .NOT. Empty( &( aCpos[ nI, 2 ] ) )
				cDado := RTrim( Posicione( 'SUM', 1, xFilial( 'SUM' ) + SA3->A3_CARGO, 'UM_DESC' ) )
			Endif

			// Verificar se o campo possui X3_CBOX.
			cX3_CBOX := RTrim( Posicione( 'SX3', 2, cCpo, 'X3CBox()' ) )
			If .NOT. Empty( cX3_CBOX )
				aX3_CBOX := StrToKarr( cX3_CBOX, ';' )
				nA := At( '=', aX3_CBOX[ 1 ] )
				If nA > 0
					nP := AScan( aX3_CBOX, {|e| SubStr( e, 1, nA-1 )==cDado } )
					If nP > 0
						cDado := SubStr( aX3_CBOX[ nP ], nA+1 )
					Endif
				Endif
			Endif

			// Atribuir o dado ao vetor no elemento em questão.
			aCpos[ nI, 5 ] := cDado
			
			// Se for campos da tabela ADJ e não há dados nos array ITEM e CPOS.
			If lADJ .And. Left( aCpos[ nI, 2 ] , 3 ) == 'ADJ' .And. Len( aADJ_ITEM )==0 .And. Len( aADJ_CPOS )==0

				// Quantos e quais campos possuem o alias ADJ?
				For nQ := nI To Len( aCpos )
					If Left( aCpos[ nQ, 2 ], 3 ) == 'ADJ'
						AAdd( aADJ_CPOS, SubStr( aCpos[ nQ, 2 ], 6 ) )
						// Capturar dados adicionais de produtos.
						If 'ADJ_PROD' $ aCpos[ nQ, 2 ]
							AAdd( aADJ_CPOS, 'B1_DESC' )
							AAdd( aADJ_CPOS, 'B1_UM' )
						Endif
					Else
						Exit
					Endif
				Next nQ

				// Com base na informação acima insira os dados no vetor aADJ_ITEM enquanto a chaver for verdadeira.
				While ADJ->(.NOT. EOF()) .And. ADJ->ADJ_FILIAL==xFilial('ADJ') .And. ADJ->ADJ_NROPOR==cAD5_NROPOR

					// Adicionar o elemento no vetor.
					AAdd( aADJ_ITEM, Array( Len( aADJ_CPOS ) ) )

					// Capturar o número do elemento do vetor.
					nElem := Len( aADJ_ITEM )

					// Ler todos os campos do ADJ.
					For nJ := 1 To Len( aADJ_CPOS )
						// Campos do ADJ.
						If Left( aADJ_CPOS[ nJ ], 3 ) == 'ADJ'
							// Posicionar o produto.
							If aADJ_CPOS[ nJ ] == 'ADJ_PROD'
								
								DA1->( dbSetOrder( 1 ) )
								IF DA1->( dbSeek( xFilial( 'DA1' ) + AD1->AD1_TABELA + ADJ->( FieldGet( FieldPos( aADJ_CPOS[ nJ ] ) ) ) ) )
									lTabPreco := .T.
									cDesAmig := rTrim( DA1->DA1_DESAMI )
								EndIF
								
								SB1->( dbSetOrder( 1 ) )
								SB1->( dbSeek( xFilial( 'SB1' ) + ADJ->( FieldGet( FieldPos( aADJ_CPOS[ nJ ] ) ) ) ) )
							Endif

							// Capturar o tipo de dado do campo.
							cType := ValType( ADJ->( FieldGet( FieldPos( aADJ_CPOS[ nJ ] ) ) ) )
	
							// Avaliar o tipo de dado e transforma-lo em string.
							If     cType == 'D' ; cDado := Dtoc( ADJ->( FieldGet( FieldPos( aADJ_CPOS[ nJ ] ) ) ) )
							Elseif cType == 'N' ; cDado := LTrim( TransForm( ADJ->( FieldGet( FieldPos( aADJ_CPOS[ nJ ] ) ) ), cPicture ) )
							Elseif cType == 'C' ; cDado := ADJ->( FieldGet( FieldPos( aADJ_CPOS[ nJ ] ) ) ) ; cDado := StrTran( cDado, "'", '' )
							Endif
	
							// Atribuir o dado ao elemento do vetor relacionado ao campo em questão.
							aADJ_ITEM[ nElem, nJ ] := cDado 
						// Campos do SB1.
						Elseif Left( aADJ_CPOS[ nJ ], 3 ) == 'B1_'
							// Capturar o tipo de dado do campo.
							If lTabPreco
								cDado := cDesAmig
								lTabPreco := .F.
							Else
								cType := ValType( SB1->( FieldGet( FieldPos( aADJ_CPOS[ nJ ] ) ) ) )
								
								// Avaliar o tipo de dado e transforma-lo em string.
								If     cType == 'D' ; cDado := Dtoc( SB1->( FieldGet( FieldPos( aADJ_CPOS[ nJ ] ) ) ) )
								Elseif cType == 'N' ; cDado := LTrim( TransForm( SB1->( FieldGet( FieldPos( aADJ_CPOS[ nJ ] ) ) ), cPicture ) )
								Elseif cType == 'C' ; cDado := SB1->( FieldGet( FieldPos( aADJ_CPOS[ nJ ] ) ) ) ; cDado := StrTran( cDado, "'", '' )
								Endif
							EndIF
								
							// Atribuir o dado ao elemento do vetor relacionado ao campo em questão.
							aADJ_ITEM[ nElem, nJ ] := cDado
						Endif
					Next nJ
					ADJ->( dbSkip() )
				End

				// Se houver dados do array, ordenar pela coluna item de produto.
				If Len( aADJ_ITEM ) > 0
					nJ := AScan( aADJ_CPOS, {|p| p=='ADJ_ITEM' } )
					If nJ > 0
						ASort( aADJ_ITEM,,,{|a,b| a[ nJ ] < b[ nJ ] } )
					Endif
				Endif
			Endif
		Endif
	Next nI 
	
	//+----------------------------------------------------------------------+
	//| Compatibilizar os dados quando for Prospect, ou seja, a oportunidade |
	//| sendo prospect é preciso atualizar os campos de clientes, assim      |
	//| não será preciso fazer dinâmica  no templado do MS-Word.             |
	//+----------------------------------------------------------------------+
	If .NOT. l320Cliente .And. lRet
		A320_US_A1( @aSUS_SA1 )
		For nI := 1 To Len( aSUS_SA1 )
			nJ := AScan( aCpos, {|p| p[2]==aSUS_SA1[ nI, 1 ] } )
			nQ := AScan( aCpos, {|p| p[2]==aSUS_SA1[ nI, 2 ] } )

			// Se encontrar os dois campos no mesmo array, atribuir o dado.
			If nJ > 0 .And. nQ > 0
				aCpos[ nQ, 5 ] := aCpos[ nJ, 5 ]
			Endif
		Next nI
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A320_US_A1 | Autor | Robson Gonçalves     | Data | 04.02.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para montar array de compatibilização de campos.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320_US_A1( aSUS_SA1 )
	AAdd( aSUS_SA1, { 'SUS->US_COD'     , 'SA1->A1_COD'     } )
	AAdd( aSUS_SA1, { 'SUS->US_LOJA'    , 'SA1->A1_LOJA'    } )
	AAdd( aSUS_SA1, { 'SUS->US_NOME'    , 'SA1->A1_NOME'    } )
	AAdd( aSUS_SA1, { 'SUS->US_NREDUZ'  , 'SA1->A1_NREDUZ'  } )
	AAdd( aSUS_SA1, { 'SUS->US_TIPO'    , 'SA1->A1_TIPO'    } )
	AAdd( aSUS_SA1, { 'SUS->US_END'     , 'SA1->A1_END'     } )
	AAdd( aSUS_SA1, { 'SUS->US_MUN'     , 'SA1->A1_MUN'     } )
	AAdd( aSUS_SA1, { 'SUS->US_BAIRRO'  , 'SA1->A1_BAIRRO'  } )
	AAdd( aSUS_SA1, { 'SUS->US_CEP'     , 'SA1->A1_CEP'     } )
	AAdd( aSUS_SA1, { 'SUS->US_EST'     , 'SA1->A1_EST'     } )
	AAdd( aSUS_SA1, { 'SUS->US_DDI'     , 'SA1->A1_DDI'     } )
	AAdd( aSUS_SA1, { 'SUS->US_DDD'     , 'SA1->A1_DDD'     } )
	AAdd( aSUS_SA1, { 'SUS->US_TEL'     , 'SA1->A1_TEL'     } )
	AAdd( aSUS_SA1, { 'SUS->US_FAX'     , 'SA1->A1_FAX'     } )
	AAdd( aSUS_SA1, { 'SUS->US_EMAIL'   , 'SA1->A1_EMAIL'   } )
	AAdd( aSUS_SA1, { 'SUS->US_URL'     , 'SA1->A1_HPAGE'   } )
	AAdd( aSUS_SA1, { 'SUS->US_ULTVIS'  , 'SA1->A1_ULTVIS'  } )
	AAdd( aSUS_SA1, { 'SUS->US_CODHIST' , 'SA1->A1_CODHIST' } )
	AAdd( aSUS_SA1, { 'SUS->US_VEND'    , 'SA1->A1_VEND'    } )
	AAdd( aSUS_SA1, { 'SUS->US_CGC'     , 'SA1->A1_CGC'     } )
	AAdd( aSUS_SA1, { 'SUS->US_INSCR'   , 'SA1->A1_INSCR'   } )
	AAdd( aSUS_SA1, { 'SUS->US_SATIV'   , 'SA1->A1_SATIV1'  } )
	AAdd( aSUS_SA1, { 'SUS->US_SATIV2'  , 'SA1->A1_SATIV2'  } )
	AAdd( aSUS_SA1, { 'SUS->US_SATIV3'  , 'SA1->A1_SATIV3'  } )
	AAdd( aSUS_SA1, { 'SUS->US_SATIV4'  , 'SA1->A1_SATIV4'  } )
	AAdd( aSUS_SA1, { 'SUS->US_SATIV5'  , 'SA1->A1_SATIV5'  } )
	AAdd( aSUS_SA1, { 'SUS->US_SATIV6'  , 'SA1->A1_SATIV6'  } )
	AAdd( aSUS_SA1, { 'SUS->US_SATIV7'  , 'SA1->A1_SATIV7'  } )
	AAdd( aSUS_SA1, { 'SUS->US_SATIV8'  , 'SA1->A1_SATIV8'  } )
	AAdd( aSUS_SA1, { 'SUS->US_ALIQIR'  , 'SA1->A1_ALIQIR'  } )
	AAdd( aSUS_SA1, { 'SUS->US_GRPTRIB' , 'SA1->A1_GRPTRIB' } )
	AAdd( aSUS_SA1, { 'SUS->US_NATUREZ' , 'SA1->A1_NATUREZ' } )
	AAdd( aSUS_SA1, { 'SUS->US_RECCOFI' , 'SA1->A1_RECCOFI' } )
	AAdd( aSUS_SA1, { 'SUS->US_RECCSLL' , 'SA1->A1_RECCSLL' } )
	AAdd( aSUS_SA1, { 'SUS->US_RECISS'  , 'SA1->A1_RECISS'  } )
	AAdd( aSUS_SA1, { 'SUS->US_RECINSS' , 'SA1->A1_RECINSS' } )
	AAdd( aSUS_SA1, { 'SUS->US_RECPIS'  , 'SA1->A1_RECPIS'  } )
	AAdd( aSUS_SA1, { 'SUS->US_SUFRAMA' , 'SA1->A1_SUFRAMA' } )
Return

//-----------------------------------------------------------------------
// Rotina | A320Word   | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para descarregar a informação do Protheus no arquivo
//        | Word transformá-lo em PDF e anexar no banco de conhecimento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Word( cAD5_NROPOR, aFiles, aCpos )
	Local oWord

	Local nI := 0
	Local nJ := 0
	Local nK := 0
	Local nL := 0
	Local nC := 1
	Local nCheck := 0
	
	Local cArqSaida := ''
	
	Local lCopy := .F.
	Local lMsWord := .F.
	Local lMacro := .F.
	Local lUnLoad := .F.
	Local lReadOnly := .F.
	Local lTemADJ := ( Len( aADJ_ITEM ) > 0 )

	Local cFormat := '17'
	Local cTempPath := GetTempPath()
	Local cTitulo := 'CSFA320 | Integração Protheus x Word - Gestão de Oportunidades'
	Local cOrigem := ''
	Local cTemplate := ''
	Local cSaidaDOC := ''
	Local cSaidaPDF := ''
	Local cVerDOC := ''
	Local cVerPDF := ''
	Local cNomeArq := ''
	Local cExtArq := ''
	Local cMV_320WORD := 'MV_320WORD'
	Local c320VlExten := ''
	Local cAux := ''
	
	Private nVersaoDocto := 0
	Private n320QtItens := 0
	Private n320VlTotal := 0
	
	// Se não existir o parâmetro, criar.
	If .NOT. SX6->( ExisteSX6( cMV_320WORD ) )
		CriarSX6( cMV_320WORD, 'C', 'USERID DOS USUARIOS AUTORIZADOS GERAR PROPOSTA NO FORMATO MS-WORD.', '000000|000445' )
	Endif
	
	// Capturar o conteúdo do parâmetro.
	cMV_320WORD := GetMv( cMV_320WORD )
	
	// Avaliar se o usuário em questão pode gerar documento em Ms-Word.
	lMsWord := ( RetCodUsr() $ cMV_320WORD )
	
	// Quantos arquivos vamos processar.
	aCopy := Array( Len( aFiles ) )
	
	For nI := 1 To Len( aFiles )
		// Local onde está o arquivo template no servidor.
		cOrigem := aFiles[ nI, 2 ]
		
		// Verificar se o arquivo existe na origem.
		If .NOT. File( cOrigem )
			MsgInfo('CSFA320 | Não encontrado o arquivo de proposta na origem conforme seu cadastro, verifique se o endereço no cadastro está correto.',cTitulo)
			Loop
		Endif
		
		// Copiar o arquivo do servidor para o temporário do usuário do windows.
		CpyS2T( cOrigem, cTempPath, .T.)
		Sleep(500)
		
		// Formar o endereço para onde foi copiado template word no temporário do usuário.
		cTemplate := cTempPath + SubStr( cOrigem, RAt( '\',cOrigem )+1 )
		
		// Verifcar até cinco vezes se o template foi copiado.
		While ((.NOT. lCopy) .And. (nCheck <= 5))
			If File( cTemplate )
				lCopy := .T.
			Else
				nCheck++
				CpyS2T( cOrigem, cTempPath, .T. )
				Sleep(500)
			Endif
		End
		
		// Se conseguiu copiar o arquivo, segue com o processamento.
		If lCopy
			// Dividir o nome do arquivo e a extensão do arquivo.
			SplitPath( cTemplate, , , @cNomeArq, @cExtArq )
			
			// Pesquisar no banco de conhecimento a próxima versão DOC.
			cVerDOC := A320Knowledge( cNomeArq + '_' + cAD5_NROPOR, '.DOC' )
			
			// Pesquisar no banco de conhecimento a próxima versão PDF.
			cVerPDF := A320Knowledge( cNomeArq + '_' + cAD5_NROPOR, '.PDF' )
			
			// Elaborar o nome completo do arquivo compatível com o registro no banco de conhecimento.
			cSaidaDOC := SubStr( cTemplate, 1, RAt( '.', cTemplate )-1 ) + '_' + cAD5_NROPOR + '_v' + cVerDOC + '.doc'
			cSaidaPDF := SubStr( cTemplate, 1, RAt( '.', cTemplate )-1 ) + '_' + cAD5_NROPOR + '_v' + cVerPDF + '.pdf'
			
			// Este arquivo template em questão, tem macro VBA?
			lMacro := .NOT. Empty( aFiles[ nI, 3 ] )
			
			// Criar o link com o apliativo.
			oWord	:= OLE_CreateLink()
			
	      // Inibir o aplicativo em execução.
			OLE_SetProperty( oWord, '206', .F. )

			// Abrir um novo arquivo.
			OLE_NewFile( oWord , cTemplate )
			
			OLE_SetDocumentVar( oWord, 'PRO_DATABASE', Dtoc( dDataBase ) )

			// Atualizar a variáve de número de versão.
			OLE_SetDocumentVar( oWord, 'PRO_320VERSAO', cValToChar( nVersaoDocto ) )				

			// Atualiza a variável com a quantidade de itens de produto da proposta.
			If lMacro .And. Len( aADJ_ITEM ) > 0
				n320QtItens := Len( aADJ_ITEM )
				OLE_SetDocumentVar( oWord, 'PRO_320QTITENS', cValToChar( n320QtItens ) )
			Endif

			// Descarregar os dados dos campos do Protheus no Word.
			For nJ := 1 To Len( aCpos )
				// Se os campos fizerem parte do alias ADJ.
				If Left( aCpos[ nJ, 2 ], 3 ) == 'ADJ'
					// Se não foi descarregado ainda os dados ADJ e possuir macro.
					If .NOT. lUnLoad .And. lMacro
						lUnLoad := .T.
						// Ler todos os itens.
						For nK := 1 To Len( aADJ_ITEM )
							// Ler todos os campos.
							For nL := 1 To Len( aADJ_CPOS )
								OLE_SetDocumentVar( oWord, 'PRO_' + aADJ_CPOS[ nL ] + LTrim( Str( nK ) ), aADJ_ITEM[ nK, nL ] )
								// Acumular o valor total dos itens.
								If RTrim( aADJ_CPOS[ nL ] ) == 'ADJ_VALOR'
									// Enquanto existir ponto, tirar e enquanto existir a vírgula mudar por ponto.
									cAux := StrTran( StrTran( aADJ_ITEM[ nK, nL ], '.', '' ), ',', '.' )
									// Converter o valor caractere para o valor numérico.
									n320VlTotal += Val( cAux )
								Endif
							Next nL
						Next nK
					Endif
				Else
					// Somente para campos que não fazem parte do alias ADJ.
					OLE_SetDocumentVar( oWord, aCpos[ nJ, 1 ], aCpos[ nJ, 5 ] )
				Endif
			Next nJ
			
			// Caso haja outro documento para mesma oportunidade que precise 
			// descarregar os produtos, é preciso reiniciar a variável.
			lUnLoad := .F.
			
			// Havendo ou não produtos na proposta, é preciso descarregar a variável para não dar erro no documento.
			OLE_SetDocumentVar( oWord, 'PRO_320VLTOTAL', LTrim( TransForm( n320VlTotal, '@E 999,999,999.99' ) ) )
			If n320VlTotal > 0
				c320VlExten := Extenso( n320VlTotal )
			Endif
			
			// Havendo ou não produtos na proposta, é preciso descarregar a variável de valor por extenso.
			OLE_SetDocumentVar( oWord, 'PRO_320VLEXTEN', c320VlExten )

			n320VlTotal := 0
			c320VlExten := ''

			// Se possuir macro e realmente houver dados de produtos, executar a macro.
	   	If lMacro .And. ( Len( aADJ_ITEM ) > 0 )
	   		OLE_ExecuteMacro( oWord, aFiles[ nI, 3 ] )
	   	Endif
	   	
	   	// Atualizar campos.
	      OLE_UpDateFields( oWord )
	      
	      // Inibir o aplicativo Ms-Word em execução.
			OLE_SetProperty( oWord, '206', .F. )
			
			// Salvar o arquivo no formato DOC.
			OLE_SaveAsFile( oWord, cSaidaDOC )
			Sleep(500)

			// Abrir o arquivo no formato DOC.
			OLE_OpenFile( oWord, cSaidaDOC )
			Sleep(500)
			
			// Salvar o arquivo no formato PDF.
			OLE_SaveAsFile( oWord, cSaidaPDF, /*cPassword*/, /*cWritePassword*/, lReadOnly, cFormat)
			Sleep(500)
			
			// Fechar o arquivo.
			OLE_CloseFile( oWord )
			
			// Desfazer o link.
			OLE_CloseLink( oWord )

			// Apagar o arquivo template.
			FErase( cTemplate )

			// Anexar o arquivo no banco de conhecimento.
			A320Anexar( cSaidaPDF, cAD5_NROPOR, aFiles[ nI, 1 ], 'AD1', .T. )

			// É preciso sempre gerar e anexar o arquivo PDF e por fim abri-lo, ou seja, nunca apagar do temporário.
			// Quando o usuário tem permissão de gerar word, deve-se também gerar e anexar o pdf, porém abrir o word.
			If lMsWord
				ShellExecute( 'Open', cSaidaDOC, '', cTempPath, 1 )
			Else
				FErase( cSaidaDOC )
				Sleep(500)
				ShellExecute( 'Open', cSaidaPDF, '', cTempPath, 1 )
			Endif

			//+-------------------------------------------------------------------------+
			//| Totaliza o total de propostas geradas por oportunidade.                 |
			//| Alimenta o campo log com data, hora, nome do usuario e proposta gerada. |
			//+-------------------------------------------------------------------------+
			RecLock("AD1")
				AD1->AD1_XQTDPR += 1
				AD1->AD1_XLOGQP := AD1->AD1_XLOGQP + "[" + dToC(Date()) + "-" + Time() + "] " + "Usuário: " + cUserName + " | Proposta: " + cNomeArq + " | Versão: " + cVerPDF + ";" + CRLF
			AD1->(MsUnLock())

		Else
			MsgAlert('Não foi possível copiar o arquivo template do servidor para a estação, por isso não será possível gerar o documento proposta (doc/pdf).',cTitulo)
			Exit
		Endif
		lCopy := .F.
		nCheck := 0
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | A320Knowledge | Autor | Robson Gonçalves  | Data | 13.01.2014
//-----------------------------------------------------------------------
// Descr. | Rotina p/disponibilizar próximo nome como controle de versão.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Knowledge( cArq, cExt )
	Local cSeek := ''
	Local nCount := 1
	ACB->( dbSetOrder( 2 ) )
	While .T.
		cSeek := Upper( cArq ) + '_V' + cValToChar( nCount ) + Upper( cExt )
		If ACB->( dbSeek( xFilial( 'ACB' ) + cSeek ) )
			nCount++
		Else
			Exit
		Endif
	End
	nVersaoDocto := nCount
Return( cValToChar( nCount ) )

//-----------------------------------------------------------------------
// Rotina | A320Anexar | Autor | Robson Gonçalves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para anexar o documento ao registro de Oportunidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
// Tabelas| AC9 - Relacao de Objetos x Entidades
//          ACB - Bancos de Conhecimentos
//          ACC - Palavras-Chave
//-----------------------------------------------------------------------
Static Function A320Anexar( cArquivo, cNUM_DOC, cDocumento, cEntidade, lFirst )
	Local lRet := .T.
	Local cFile := ''
	Local cExten := ''
	Local cObjeto := ''
	Local cACB_CODOBJ := ''
	
	// Função do padrão que copia o objeto para o diretório do banco de conhecimentos.
	If lFirst
		lRet := FT340CpyObj( cArquivo )
	Endif
	
	If lRet 
		SplitPath( cArquivo,,,@cFile, @cExten )
		cObjeto := Left( Upper( cFile + cExten ),Len( cArquivo ) )
		aAdd( aObjeto, cObjeto )
		
		cACB_CODOBJ := GetSXENum('ACB','ACB_CODOBJ')
	
		ACB->( RecLock( 'ACB', .T. ) )
		ACB->ACB_FILIAL	:= xFilial( 'ACB' )
		ACB->ACB_CODOBJ	:= cACB_CODOBJ
		ACB->ACB_OBJETO	:= cObjeto
		ACB->ACB_DESCRI	:= cDocumento
		If FindFunction( 'MsMultDir' ) .And. MsMultDir()
			ACB->ACB_PATH	:= MsDocPath( .T. )
		Endif
		ACB->( MsUnLock() )	
		ACB->( ConfirmSX8() )
		
		AC9->( RecLock( 'AC9', .T. ) )
		AC9->AC9_FILIAL	:= xFilial( 'AC9' )
		AC9->AC9_FILENT	:= xFilial( cEntidade )
		AC9->AC9_ENTIDA	:= cEntidade
		AC9->AC9_CODENT	:= Iif(cEntidade=='SUA',xFilial( cEntidade ),'') + cNUM_DOC
		AC9->AC9_CODOBJ	:= cACB_CODOBJ
		AC9->AC9_DTGER    := dDataBase
		AC9->( MsUnLock() )
		
		ACC->( RecLock( 'ACC', .T. ) )
		ACC->ACC_FILIAL := xFilial( 'ACC' ) 
		ACC->ACC_CODOBJ := cACB_CODOBJ
		ACC->ACC_KEYWRD := cNUM_DOC + ' ' + cDocumento
		ACC->( MsUnLock() )
	Else
		MsgAlert('Não foi possível anexar o documento no banco de conhecimento, problemas com o FT340CPYOBJ.',cTitulo)
	Endif
Return(cObjeto)

//------------------------------------------------------------------
// Rotina | A320ChgSX6 | Autor | Robson Luiz -Rleg | Data | 11.02.14
//------------------------------------------------------------------
// Descr. | Rotina para permitir alterar os parâmetros SX6 somente
//        | desta rotina de gerar propostas.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function A320ChgSX6()
	Local oDlg
	Local oLbx
	Local oPanel 
	Local nI := 0
	Local aSX6 := {}
	Private aDadosSX6 := {}
	aSX6 := {'MV_320FILT','MV_320FINI','MV_320PARA','MV_320TEMP','MV_320WORD','MV_321CAUT','MV_321DESC','MV_321FILT','MV_321PROP','MV_321PTAB','MV_321RAUT','MV_321WORD'}
	SX6->( dbSetOrder( 1 ) )
	For nI := 1 To Len( aSX6 )
		If SX6->( dbSeek( xFilial( 'SX6' ) + aSX6[ nI ] ) )
			SX6->( AAdd( aDadosSX6, { X6_VAR, X6_TIPO, X6_CONTEUD, RTrim(X6_DESCRIC)+RTrim(X6_DESC1)+RTrim(X6_DESC2) } ) )
		Endif
	Next nI
	If Len( aDadosSX6 ) > 0
		DEFINE MSDIALOG oDlg TITLE 'Parâmetros da Rotina' FROM 0,0 TO 200,800 PIXEL
		   oLbx := TwBrowse():New(0,0,0,0,,{'Parâmetro','Tipo','Conteúdo','Descrição'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:SetArray( aDadosSX6 )
		   oLbx:bLine := {|| aEval( aDadosSX6[oLbx:nAt],{|z,w| aDadosSX6[oLbx:nAt,w]})}
		   oLbx:BlDblClick := {|| A320EdtSX6( @oLbx ) }

			oPanel := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
			oPanel:Align := CONTROL_ALIGN_BOTTOM
		
			@ 04,04 BUTTON "&Editar" SIZE 36,10 OF oPanel PIXEL ACTION A320EdtSX6( @oLbx )
			@ 04,44 BUTTON "&Sair"   SIZE 36,10 OF oPanel PIXEL ACTION oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTER
	Else
		MsgAlert( 'Parâmetro não localizado.',cCadastro )
	Endif
Return

//------------------------------------------------------------------
// Rotina | A320EdtSX6 | Autor | Robson Luiz -Rleg | Data | 11.02.14
//------------------------------------------------------------------
// Descr. | Rotina para editar e gravar o conteúdo do parâmetro SX6.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function A320EdtSX6( oLbx )
	Local aPar := {}
	Local aRet := {}
	Local cX6_VAR := aDadosSX6[ oLbx:nAt, 1 ]
	Local cX6_CONTEUD := RTrim( aDadosSX6[ oLbx:nAt, 3 ] )
	AAdd( aPar,{ 1, 'Conteúdo do parâmetro',(cX6_CONTEUD + Space( 250 - Len( cX6_CONTEUD ) )),'','','','',120,.F.})
	If ParamBox( aPar,'Editar parâmetro', @aRet )
		If Upper( cX6_CONTEUD ) <> Upper( RTrim( aRet[ 1 ] ) )
			PutMv( cX6_VAR, aRet[ 1 ] )
			aDadosSX6[ oLbx:nAt, 3 ] := aRet[ 1 ]
			oLbx:Refresh()
			MsgInfo('Parâmetro modificado com sucesso, ao reiniciar a rotina os parâmetros terão efeito.', cCadastro )
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | UPD320     | Autor | Robson Gonçalves     | Data | 29.01.2014
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD320()
	Local cModulo := 'FAT'
	Local bPrepar := {|| U_U320Ini() }
	Local nVersao := 1
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//-----------------------------------------------------------------------
// Rotina | U320Ini    | Autor | Robson Gonçalves     | Data | 29.01.2014
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U320Ini()

	aSX2 := {}
	aSX3 := {}
	aSIX := {}
	aSX7 := {}
	aSXB := {}
	aHelp := {}

	// SX3
	AAdd(aSX3,{"AC9",NIL,"AC9_DTGER","D",8,0,;
	"Data Geracao","Data Geracao","Data Geracao",;
	"Data Geracao","Data Geracao","Data Geracao",;
	"","","€€€€€€€€€€€€€€€","DDATABASE","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})

	//Help
	AAdd(aHelp,{"AC9_DTGER","Data da geração do documento."})

	// SX3
	AAdd(aSX3,{"SUA",NIL,"UA_QTDPROP","N",2,0,;
	"Vezes G.Prop","Vezes G.Prop","Vezes G.Prop",;
	"Vezes que gerou proposta","Vezes que gerou proposta","Vezes que gerou proposta",;
	"","","€€€€€€€€€€€€€€€","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})

	AAdd(aSX3,{"SUA",NIL,"UA_RESTAUT","C",20,0,;
	"Restr.Autor.","Restr.Autor.","Restr.Autor.",;
	"Restrição autorizada","Restrição autorizada","Restrição autorizada",;
	"","","€€€€€€€€€€€€€€€","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})

	AAdd(aSX3,{"SUC",NIL,"UC_TELEVEN","C",26,0,;
	"NºTelevendas","NºTelevendas","NºTelevendas",;
	"Tlv+User+Data+Hora","Tlv+User+Data+Hora","Tlv+User+Data+Hora",;
	"","","€€€€€€€€€€€€€€€","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})

	AAdd(aHelp,{"UA_QTDPROP","Quantidade de vezes que gerou proposta, por meio da integração Televendas x Word"})
	AAdd(aHelp,{"UA_RESTAUT","Código do usuário, data e hora que autorizou a geração da proposta por meio da integração Televendas x Word."})
	AAdd(aHelp,{"UC_TELEVEN","Telemarketing gerou Televendas, neste campo haverá as seguintes informações Nº Televendas, usuário, data e hora."})

	//SX2
	AAdd(aSX2,{"ZZB","","Cadastro de Propostas","Cadastro de Propostas","Cadastro de Propostas","E","",""})
	
	//SX3
	AAdd(aSX3,{"ZZB",NIL,"ZZB_FILIAL","C",2,0,;
	"Filial","Sucursal","Branch",;
	"Filial do Sistema","Sucursal","Branch of the System",;
	"@!","","€€€€€€€€€€€€€€€","","",1,"þÀ","","","U","N","A","R","","","","","","","","","033","","","","","","N","N","",""})

	AAdd(aSX3,{"ZZB",NIL,"ZZB_CODIGO","C",6,0,;
	"Codigo","Codigo","Codigo",;
	"Codigo da Proposta","Codigo da Proposta","Codigo da Proposta",;
	"@!","","€€€€€€€€€€€€€€ ","GETSXENUM('ZZB','ZZB_CODIGO')","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})

	AAdd(aSX3,{"ZZB",NIL,"ZZB_NOMEPR","C",100,0,;
	"Proposta","Proposta","Proposta",;
	"Nome proposta","Nome proposta","Nome proposta",;
	"@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","",""})

	AAdd(aSX3,{"ZZB",NIL,"ZZB_ARQUIV","C",80,0,;
	"End. Arquivo","End. Arquivo","End. Arquivo",;
	"Endereco arquivo fisico","Endereco arquivo fisico","Endereco arquivo fisico",;
	"","","€€€€€€€€€€€€€€ ","","ZZBPRO",0,"þA","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","",""})

	AAdd(aSX3,{"ZZB",NIL,"ZZB_MACRO","C",15,0,;
	"Nome Macro","Nome Macro","Nome Macro",;
	"Nome da macro","Nome da macro","Nome da macro",;
	"@!","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","",""})

	AAdd(aSX3,{"ZZB",NIL,"ZZB_MSBLQL","C",1,0,;
	"Bloqueado?","Bloqueado?","Bloqueado?",;
	"Registro bloqueado","Registro bloqueado","Registro bloqueado",;
	"","","€€€€€€€€€€€€€€ ","'2'","",0,"‚€","","","L","N","A","R","","","1=Sim;2=Não","1=Si;2=No","1=Yes;2=No","","","","","","","","","","N","N","",""})
	
	//Help
	AAdd(aHelp,{"ZZB_FILIAL","Código da filial no sistema."})
	AAdd(aHelp,{"ZZB_CODIGO","Código da proposta cadastrada."})
	AAdd(aHelp,{"ZZB_NOMEPR","Nome da proposta, ou seja, nome para identificação."})
	AAdd(aHelp,{"ZZB_ARQUIV","Endereço físico onde está o arquivo da proposta modelo (template Ms-Word - .DOT)."})
	AAdd(aHelp,{"ZZB_MACRO" ,"Nome da macro em VBA, caso a proposta contenha macro."})
	AAdd(aHelp,{"ZZB_MSBLQL","Registro bloquado para uso?"})
	
	//SIX
	AAdd(aSIX,{"ZZB","1","ZZB_FILIAL+ZZB_CODIGO","Codigo","Codigo","Codigo","U","S"})
	AAdd(aSIX,{"ZZB","2","ZZB_FILIAL+ZZB_NOMEPR","Nome"  ,"Nome"  ,"Nome"  ,"U","S"})
	
	//SXB
	AAdd(aSXB,{"ZZBPRO","1","01","RE","Arq. Fisico Proposta","Arq. Fisico Proposta","Arq. Fisico Proposta","ZZB",""})
	AAdd(aSXB,{"ZZBPRO","2","01","01","","","","U_A320FILE()",""})
	AAdd(aSXB,{"ZZBPRO","5","01","","","","","U_A320RETFILE()",""})
Return

/*
____________________________________________________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------------------------------------------------------------+¦¦
¦¦¦                                                                                                                               ¦¦¦
¦¦¦ AS ROTINAS ABAIXO FORAM CRIADAS PARA ATENDER A GERAÇÃO DE PROPOSTAS PROVENIENTE DOS DADOS DO ATENDIMENTO DO TELEVENDAS.       ¦¦¦
¦¦¦ A CRIAÇÃO FOI DECIDIDA EM FAZER AQUI PORQUE É CONVENINENTE APROVEITAR O FUNCIONAMENTO DAS DEMAIS ROTINAS QUE JÁ FORAM         ¦¦¦
¦¦¦ CONSTRUÍDAS E VALIDADAS.                                                                                                      ¦¦¦
¦¦¦                                                                                                                               ¦¦¦
¦¦+-------------------------------------------------------------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

//---------------------------------------------------------------------
// Rotina | A321IProp    | Autor | Robson Gonçalves | Data | 17.05.2014 
//---------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TK271ROTM para gerar
//        | a propostas para o Televendas.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A321IPro()
	Local nOpcao := 0
	
	Local cTitulo := 'Televendas - Gerar Propostas'
	
	Local aSay := {}
	Local aButton := {}

	AAdd( aSay, 'Rotina para gerar proposta, seu objetivo é gerar um novo documento com base nos' ) 
	AAdd( aSay, 'dados do Televendas em questão e por fim anexar o arquivo ao Conhecimento.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Caso queira imprimir um documento, dirija-se a opção Conhecimento e selecione' )
	AAdd( aSay, 'o documento que desejar.' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpcao==1
		U_A321Prop( SUA->UA_NUM )
	Endif
Return
//---------------------------------------------------------------------
// Rotina | A321Prop     | Autor | Robson Gonçalves | Data | 17.05.2014 
//---------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada XYZ para fazer a 
//        | impressão das propostas para o Televendas.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A321Prop( cUA_NUM )
	Private cTitulo := 'Televendas - Gerar Propostas'
	Processa( {|| A321Make( cUA_NUM )}, cTitulo,'Aguarde processando...', .F. )
Return
//---------------------------------------------------------------------
// Rotina | A321Make     | Autor | Robson Gonçalves | Data | 17.05.2014 
//---------------------------------------------------------------------
// Descr. | Rotina para preparar a impressão das propostas.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A321Make( cUA_NUM )
	Local cMV_321PROP := 'MV_321PROP'
	Local cMV_321FILT := 'MV_321FILT'
	Local cArqIni := c320ArqIni
	Local cFunName := FunName()
	Local aCpos := {}
	Local aFiles := {}
	
  	Private aSUB_CPOS := {}
     Private aSUB_ITEM := {}
     Private aFileA321 := {}
	
	// Processos que serão processados.
	ProcRegua(5)
	
	If .NOT. SX6->( ExisteSX6( cMV_321PROP ) )
		CriarSX6( cMV_321PROP, 'L', 'Habilita a rotina de gerar propostas integrado com Televendas. CSFA320.prw', '.F.' )
	Endif
	//---------------------------------------
	// Está habilitada a chave de integração?
	//---------------------------------------
	If GetMv( cMV_321PROP )
		//----------------------------------------------------------
		// Somente por meio das duas funções é que as será impresso.
		//----------------------------------------------------------
		If (cFunName$'TMKA271|CSTMK010')
			If U_A321Check( cUA_NUM )
				//-----------------------------------
				// Verificar se existe o arquivo INI.
				//-----------------------------------
				If File( cArqIni )
					//-------------------------------------------------------------
					// Verificar possibilidade de filtro por descrição da proposta.
					If .NOT. SX6->( ExisteSX6( cMV_321FILT ) )
						CriarSX6( cMV_321FILT, 'C', 'Expressao AdvPL para filtrar as propostas por decricao no Televendas. CSFA320.prw', '"VDS"$ZZB->ZZB_NOMEPR' )
					Endif
					cMV_321FILT := GetMv( cMV_321FILT )
					//----------------------------------------------------
					// Selecionar os arquivos templates a serem impressos.
					//----------------------------------------------------
					If A320Select(@aFiles,cMV_321FILT)
						//----------------------------------------
						// Carregar os dados conforme arquivo INI.
						//----------------------------------------
						IncProc('Lendo arquivo INI.')
						aCpos := A320LerIni( c320ArqIni )
						//---------------------------------------------------------
						// Posicionar os registros das tabelas para carregar dados.
						//---------------------------------------------------------
						IncProc('Posicionando os registros.')
						If A321Seek( cUA_NUM, @aCpos )
							//--------------------------------------------------------------------------
							// Gerar os documentos conforme selecionados para a oportunidade em questão.
							//--------------------------------------------------------------------------
							IncProc('Intengrando os dados com Ms-Word.')
							A321Word( cUA_NUM, aFiles, aCpos )
							MsgInfo('Processo finalizado, verifique no Conhecimento o(s) documento(s) gerado(s).',cTitulo)
							If MsgYesNo('Deseja enviar a proposta por e-mail?', cTitulo)
								U_A321Email(cUA_NUM, aFileA321)
							Endif
						Else
							//verificar de como colocar os dados do vendedor
							MsgAlert('Televendas sem código de contato, por favor, informe o código do contato.',cTitulo)
						Endif
					Endif
				Else
					MsgAlert('Não foi localizado o arquivo '+Upper(c320ArqIni)+', por favor, buscar apoio junto a Sistemas Corporativos',cTitulo)
				Endif
			Endif
		Endif
	Else
		MsgInfo('Opção de gerar proposta desabilitada, verifique o parâmetro MV_321PROP',cTitulo)
	Endif
Return

//---------------------------------------------------------------------
// Rotina | A321ChkMv    | Autor | Robson Gonçalves | Data | 25.08.2014 
//---------------------------------------------------------------------
// Descr. | Verifica se os parâmetros existem.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A321ChkMv( cMV_321CAUT, cMV_321RAUT )
	If .NOT. GetMV( cMV_321RAUT, .T. )
		CriarSX6( cMV_321RAUT, 'C', 'PRODUTOS COM RESTRICAO PARA GERAR PROPOSTA. CSFA320.prw', 'VS010074|VS010075|VS010076|VS010077' )
	Endif
	If .NOT. GetMV( cMV_321CAUT, .T. )
		CriarSX6( cMV_321CAUT, 'C', 'CODIGO DOS USUARIOS COM ALCADA PARA AUTORIZAR GERAR PROPOSTA. CSFA320.prw', '000445|001018|000600' )
	Endif
Return
//---------------------------------------------------------------------
// Rotina | A321Check    | Autor | Robson Gonçalves | Data | 25.08.2014 
//---------------------------------------------------------------------
// Descr. | Rotina para criticar se pode gerar a proposta ou para 
//        | autorizar a geração.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A321Check( cUA_NUM )
	Local lRet := .T.
	Local lAutoriza := .F.
	Local aArea := {}
	Local aUSER := {}
	Local cLogin := ''
	Local cUser := ''
	Local cMV_321CAUT := 'MV_321CAUT'
	Local cMV_321RAUT := 'MV_321RAUT'
	Local cTitulo := 'Restrição para gerar propostas'
	If cUA_NUM == NIL
		lAutoriza := .T.
		cUA_NUM := SUA->UA_NUM
	Endif
	A321ChkMv( cMV_321CAUT, cMV_321RAUT )
	cMV_321RAUT := GetMv( cMV_321RAUT, .F. )
	If .NOT. Empty( cMV_321RAUT )
		aArea := { SUA->( GetArea() ), SUB->( GetArea() ) }
		If SUA->UA_NUM <> cUA_NUM
			SUA->( dbSetOrder( 1 ) )
			SUA->( dbSeek( xFilial( 'SUA' ) + cUA_NUM ) )
		Endif
		If Empty( SUA->UA_RESTAUT )	
			SUB->( dbSetOrder( 1 ) )
			SUB->( dbSeek( xFilial( 'SUB' ) + cUA_NUM ) )
			While .NOT. SUB->( EOF() ) .AND. SUB->UB_FILIAL == xFilial( 'SUB' ) .AND. SUB->UB_NUM == cUA_NUM
				If RTrim( SUB->UB_PRODUTO ) $ cMV_321RAUT
					lRet := .F.
					Exit
				Endif
				SUB->( dbSkip() )
			End
			cLogin := RetCodUsr()
			cMV_321CAUT := GetMv( cMV_321CAUT, .F. )
			If lAutoriza
				If cLogin $ cMV_321CAUT
					SUA->( RecLock( 'SUA', .F. ) )
					SUA->UA_RESTAUT := cLogin + Dtos( dDataBase ) + StrTran( Time(), ':', '' )
					SUA->( MsUnLock() )
					MsgInfo( 'Autorização efetuada com sucesso.', cTitulo )
				Else
					MsgAlert( 'Usuário sem alçada para autoriza a gerar proposta', cTitulo )
				Endif
			Else
				If .NOT. lRet
					aUSER := StrToKarr( cMV_321CAUT, '|' )
					AEval( aUSER, {|e,n| cUser += LTrim( Str( n, 1, 0 ) ) + '-' + UsrFullName( e ) + CRLF } )
					MsgAlert( 'Este atendimento possui restrição para gerar a proposta, por favor, solicite autorização para um dos usuários: ' + CRLF + cUser, cTitulo )
				Endif
			Endif
		Else
			MsgInfo( 'Atendimento autorizado pelo usuário ' + RTrim( UsrFullName( Left( SUA->UA_RESTAUT, 6 ) ) ) + ;
			' em ' + Dtoc( Stod( SubStr( SUA->UA_RESTAUT, 7, 8 ) ) ) + ;
			' as ' + SubStr( SUA->UA_RESTAUT, 15, 2 ) + ':' + SubStr( SUA->UA_RESTAUT, 17, 2 ) + ':' + Right( SUA->UA_RESTAUT, 2 ), cTitulo )
		Endif
		AEval( aArea, {|xArea| RestArea( xArea ) } )
	Endif
Return( lRet )
//---------------------------------------------------------------------
// Rotina | A321Seek     | Autor | Robson Gonçalves | Data | 17.05.2014 
//---------------------------------------------------------------------
// Descr. | Rotina para posicionar os registros conforme o Televendas.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A321Seek( cUA_NUM, aCpos )
	Local nI := 0
	Local nJ := 0
	Local nQ := 0
	Local nElem := 0
	
	Local cTab := ''
	Local cCpo := ''
	Local cDado := ''
	Local cType := ''
	Local cPicture := '@E 999,999,999.99'
	
	SUA->( dbSetOrder( 1 ) )
	SUA->( MsSeek( xFilial( 'SUA' ) + cUA_NUM ) )
	
	SUB->( dbSetOrder( 1 ) )
	SUB->( MsSeek( xFilial( 'SUB' ) + cUA_NUM ) )
		
	SU5->( dbSetOrder( 1 ) )
	SU5->( dbSeek( xFilial( 'SU5' ) + SUA->UA_CODCONT ) )

	SU7->( dbSetOrder( 1 ) )
	SU7->( dbSeek( xFilial( 'SU7' ) + SUA->UA_OPERADO ) )

	SA3->( dbSetOrder( 1 ) )
	SA3->( dbSeek( xFilial( 'SA3' ) + SUA->UA_VEND ) )
	
	SE4->( dbSetOrder( 1 ) )
	SE4->( dbSeek( xFilial( 'SE4' ) + SUA->UA_CONDPG ) )

	For nI := 1 To Len( aCpos )
		// Se não for tabela + campo, apenas atribuir.
		If SubStr( aCpos[ nI, 2 ], 4, 2 ) <> '->'
			cType := ValType( &( aCpos[ nI, 2 ] ) )
			If     cType == 'D' ; cDado := Dtoc( &( aCpos[ nI, 2 ] ) )
			Elseif cType == 'N' ; cDado := LTrim( TransForm( &( aCpos[ nI, 2 ] ), cPicture ) )
			Elseif cType == 'C' ; cDado := &( aCpos[ nI, 2 ] ) ; cDado := StrTran( cDado, "'", '' )
			Endif

			aCpos[ nI, 5 ] := cDado

		// Se for tabela e campo macro executar o campo.
		Else
			// Capturar o alias.
			cTab := Left( aCpos[ nI, 2 ], 3 )

			// Capturar o campo.
			cCpo := SubStr( aCpos[ nI, 2 ], 6 )

			// Capturar o tipo do dado.
			cType := ValType( (cTab)->( FieldGet( FieldPos( cCpo ) ) ) )

			// Avaliar o tipo do dado e transforma-lo em string.
			If     cType == 'D' ; cDado := Dtoc( (cTab)->( FieldGet( FieldPos( cCpo ) ) ) )
			Elseif cType == 'N' ; cDado := LTrim( TransForm( (cTab)->( FieldGet( FieldPos( cCpo ) ) ), cPicture ) ) 
			Elseif cType == 'C' ; cDado := (cTab)->( FieldGet( FieldPos( cCpo ) ) ) ; cDado := StrTran( cDado, "'", '' )
			Endif

			// Se for o campo cargo do vendedor, buscar a descrição do cargo na tabela SUM.
			If 'A3_CARGO' $ aCpos[ nI, 2 ] .And. .NOT. Empty( &( aCpos[ nI, 2 ] ) )
				cDado := RTrim( Posicione( 'SUM', 1, xFilial( 'SUM' ) + SA3->A3_CARGO, 'UM_DESC' ) )
			Endif

			// Atribuir o dado ao vetor no elemento em questão.
			aCpos[ nI, 5 ] := cDado	

			// Se for campos da tabela SUB e não há dados nos array ITEM e CPOS.
			If Left( aCpos[ nI, 2 ] , 3 ) == 'SUB' .And. Len( aSUB_ITEM )==0 .And. Len( aSUB_CPOS )==0

				// Quantos e quais campos possuem o alias SUB?
				For nQ := nI To Len( aCpos )
					If Left( aCpos[ nQ, 2 ], 3 ) == 'SUB'
						AAdd( aSUB_CPOS, SubStr( aCpos[ nQ, 2 ], 6 ) )
						// Capturar dados adicionais de produtos.
						If 'UB_PRODUTO' $ aCpos[ nQ, 2 ]
							AAdd( aSUB_CPOS, 'B1_DESC' )
							AAdd( aSUB_CPOS, 'B1_UM' )
						Endif
					Else
						Exit
					Endif
				Next nQ

				// Com base na informação acima insira os dados no vetor aSUB_ITEM enquanto a chaver for verdadeira.
				While SUB->(.NOT. EOF()) .And. SUB->UB_FILIAL==xFilial('SUB') .And. SUB->UB_NUM==cUA_NUM

					// Adicionar o elemento no vetor.
					AAdd( aSUB_ITEM, Array( Len( aSUB_CPOS ) ) )

					// Capturar o número do elemento do vetor.
					nElem := Len( aSUB_ITEM )

					// Ler todos os campos do SUB.
					For nJ := 1 To Len( aSUB_CPOS )
						// Campos do SUB.
						If Left( aSUB_CPOS[ nJ ], 2 ) == 'UB'
							// Posicionar o produto.
							If aSUB_CPOS[ nJ ] == 'UB_PRODUTO'
								SB1->( dbSetOrder( 1 ) )
								SB1->( dbSeek( xFilial( 'SB1' ) + SUB->( FieldGet( FieldPos( aSUB_CPOS[ nJ ] ) ) ) ) )
							Endif
							
							// Capturar o tipo de dado do campo.
							cType := ValType( SUB->( FieldGet( FieldPos( aSUB_CPOS[ nJ ] ) ) ) )
	
							// Avaliar o tipo de dado e transforma-lo em string.
							If cType == 'D'
								cDado := Dtoc( SUB->( FieldGet( FieldPos( aSUB_CPOS[ nJ ] ) ) ) )
							Elseif cType == 'N'
								// Se for o campo UB_PRCTAB multiplicar o campo preço de tabela pela quantidade.
								If aSUB_CPOS[ nJ ] == 'UB_PRCTAB'
									cDado := LTrim( TransForm( Round( SUB->( UB_PRCTAB * UB_QUANT ), 2 ), cPicture ) )
								// Se for o campo UB_VALDESC multiplicar o campo desconto pela quantidade.
								Elseif aSUB_CPOS[ nJ ] == 'UB_VALDESC'
									cDado := LTrim( TransForm( Round( SUB->( UB_VALDESC * UB_QUANT ), 2 ), cPicture ) )
								// Demais campos numéricos.
								Else
									// Demais dados caracteres.
									cDado := LTrim( TransForm( SUB->( FieldGet( FieldPos( aSUB_CPOS[ nJ ] ) ) ), cPicture ) )
								Endif
							Elseif cType == 'C'
								cDado := SUB->( FieldGet( FieldPos( aSUB_CPOS[ nJ ] ) ) )
								cDado := StrTran( cDado, "'", '' )
							Endif
	
							// Atribuir o dado ao elemento do vetor relacionado ao campo em questão.
							aSUB_ITEM[ nElem, nJ ] := cDado 
						// Campos do SB1.
						Elseif Left( aSUB_CPOS[ nJ ], 2 ) == 'B1'
							// Capturar o tipo de dado do campo.
							cType := ValType( SB1->( FieldGet( FieldPos( aSUB_CPOS[ nJ ] ) ) ) )
	
							// Avaliar o tipo de dado e transforma-lo em string.
							If     cType == 'D' ; cDado := Dtoc( SB1->( FieldGet( FieldPos( aSUB_CPOS[ nJ ] ) ) ) )
							Elseif cType == 'N' ; cDado := LTrim( TransForm( SB1->( FieldGet( FieldPos( aSUB_CPOS[ nJ ] ) ) ), cPicture ) )
							Elseif cType == 'C' ; cDado := SB1->( FieldGet( FieldPos( aSUB_CPOS[ nJ ] ) ) ) ; cDado := StrTran( cDado, "'", '' )
							Endif
	
							// Atribuir o dado ao elemento do vetor relacionado ao campo em questão.
							aSUB_ITEM[ nElem, nJ ] := cDado
						Endif
					Next nJ
					SUB->( dbSkip() )
				End
			Endif
		Endif			
	Next nI
Return( .T. )
//---------------------------------------------------------------------
// Rotina | A321Word     | Autor | Robson Gonçalves | Data | 17.05.2014 
//---------------------------------------------------------------------
// Descr. | Rotina para descarregar as informações no template 
//        | selecionado.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A321Word( cUA_NUM, aFiles, aCpos )
	Local oWord

	Local nI := 0
	Local nJ := 0
	Local nK := 0
	Local nL := 0
	Local nC := 1
	Local nCheck := 0
	
	Local cArqSaida := ''
	
	Local lCopy := .F.
	Local lMsWord := .F.
	Local lMacro := .F.
	Local lUnLoad := .F.
	Local lReadOnly := .F.
	Local lTemSUB := ( Len( aSUB_ITEM ) > 0 )

	Local cFormat := '17'
	Local cTempPath := GetTempPath()
	Local cTitulo := 'CSFA321 | Integração Protheus x Word - Televendas'
	Local cOrigem := ''
	Local cTemplate := ''
	Local cSaidaDOC := ''
	Local cSaidaPDF := ''
	Local cVerDOC := ''
	Local cVerPDF := ''
	Local cNomeArq := ''
	Local cExtArq := ''
	Local cMV_321WORD := 'MV_321WORD'
	Local cMV_321DESC := 'MV_321DESC'
	Local cMV_321PTAB := 'MV_321PTAB'
	Local c321VlExten := ''
	Local cAux := ''
	Local nUB_VALDESC := 0
	Local cUB_VALDESC := ''
	Local nUB_PRCTAB := 0
	Local cUB_PRCTAB := ''
	Local cUA_NUMSC5 := SUA->( Posicione( 'SUA', 1, xFilial( 'SUA' ) + cUA_NUM, 'UA_NUMSC5' ) )
	
	Private nVersaoDocto := 0
	Private n321QtItens  := 0
	Private n321VlTotal  := 0
		
	// Parâmetro com o texto a ser impresso caso haja desconto na proposta do Televendas.
	If .NOT. GetMV( cMV_321PTAB, .T. )
		CriarSX6( cMV_321PTAB, 'C', 'TEXTO PARA SER IMPRESSO NA PROPOSTA TELEVENDAS INFORMANDO PRECO DE TABELA. CSFA320.prw', 'Valor total de tabela R$' )
	Endif
	cMV_321PTAB := GetMv( cMV_321PTAB, .F. )

	// Parâmetro com o texto a ser impresso caso haja desconto na proposta do Televendas.
	If .NOT. GetMV( cMV_321DESC, .T. )
		CriarSX6( cMV_321DESC, 'C', 'TEXTO PARA SER IMPRESSO NA PROPOSTA TELEVENDAS INFORMADO O TOTAL DE DESCONTO. CSFA320.prw', 'Valor total de desconto R$' )
	Endif
	cMV_321DESC := GetMv( cMV_321DESC, .F. )
	
	// Se não existir o parâmetro, criar.
	If .NOT. SX6->( ExisteSX6( cMV_321WORD ) )
		CriarSX6( cMV_321WORD, 'C', 'USERID DOS USUARIOS DO TELEVENDAS AUTORIZADOS GERAR PROPOSTA NO FORMATO MS-WORD.', '000000|000445' )
	Endif
	
	// Capturar o conteúdo do parâmetro.
	cMV_321WORD := GetMv( cMV_321WORD )
	
	// Avaliar se o usuário em questão pode gerar documento em Ms-Word.
	lMsWord := ( RetCodUsr() $ cMV_321WORD )
	
	// Quantos arquivos vamos processar.
	aCopy := Array( Len( aFiles ) )
	
	For nI := 1 To Len( aFiles )
		// Local onde está o arquivo template no servidor.
		cOrigem := aFiles[ nI, 2 ]
		
		// Verificar se o arquivo existe na origem.
		If .NOT. File( cOrigem )
			MsgInfo('CSFA321 | Não encontrado o arquivo de proposta na origem conforme seu cadastro, verifique se o endereço no cadastro está correto.',cTitulo)
			Loop
		Endif
		
		// Copiar o arquivo do servidor para o temporário do usuário do windows.
		CpyS2T( cOrigem, cTempPath, .T.)
		Sleep(500)
		
		// Formar o endereço para onde foi copiado template word no temporário do usuário.
		cTemplate := cTempPath + SubStr( cOrigem, RAt( '\',cOrigem )+1 )
		
		// Verifcar até cinco vezes se o template foi copiado.
		While ((.NOT. lCopy) .And. (nCheck <= 5))
			If File( cTemplate )
				lCopy := .T.
			Else
				nCheck++
				CpyS2T( cOrigem, cTempPath, .T. )
				Sleep(500)
			Endif
		End
		
		// Se conseguiu copiar o arquivo, segue com o processamento.
		If lCopy
			// Dividir o nome do arquivo e a extensão do arquivo.
			SplitPath( cTemplate, , , @cNomeArq, @cExtArq )
			
			// Pesquisar no banco de conhecimento a próxima versão DOC.
			cVerDOC := A320Knowledge( cNomeArq + '_' + cUA_NUM, '.DOC' )
			
			// Pesquisar no banco de conhecimento a próxima versão PDF.
			cVerPDF := A320Knowledge( cNomeArq + '_' + cUA_NUM, '.PDF' )
			
			// Elaborar o nome completo do arquivo compatível com o registro no banco de conhecimento.
			cSaidaDOC := SubStr( cTemplate, 1, RAt( '.', cTemplate )-1 ) + '_' + cUA_NUM + '_v' + cVerDOC + '.doc'
			cSaidaPDF := SubStr( cTemplate, 1, RAt( '.', cTemplate )-1 ) + '_' + cUA_NUM + '_v' + cVerPDF + '.pdf'
			
			// Este arquivo template em questão, tem macro VBA?
			lMacro := .NOT. Empty( aFiles[ nI, 3 ] )
			
			// Criar o link com o apliativo.
			oWord	:= OLE_CreateLink()
			
	      // Inibir o aplicativo em execução.
			OLE_SetProperty( oWord, '206', .F. )

			// Abrir um novo arquivo.
			OLE_NewFile( oWord , cTemplate )
			
			OLE_SetDocumentVar( oWord, 'PRO_DATABASE', Dtoc( dDataBase ) )

			// Atualizar a variáve de número de versão.
			OLE_SetDocumentVar( oWord, 'PRO_320VERSAO', cValToChar( nVersaoDocto ) )

			// Atualiza a variável com a quantidade de itens de produto da proposta.
			If lMacro .And. Len( aSUB_ITEM ) > 0
				n321QtItens := Len( aSUB_ITEM )
				OLE_SetDocumentVar( oWord, 'PRO_320QTITENS', cValToChar( n321QtItens ) )
			Endif

			// Descarregar os dados dos campos do Protheus no Word.
			For nJ := 1 To Len( aCpos )
				// Se os campos fizerem parte do alias SUB.
				If Left( aCpos[ nJ, 2 ], 3 ) == 'SUB'
					// Se não foi descarregado ainda os dados SUB e possuir macro.
					If .NOT. lUnLoad .And. lMacro
						lUnLoad := .T.
						// Ler todos os itens.
						For nK := 1 To Len( aSUB_ITEM )
							// Ler todos os campos.
							For nL := 1 To Len( aSUB_CPOS )
								OLE_SetDocumentVar( oWord, 'PRO_' + aSUB_CPOS[ nL ] + LTrim( Str( nK ) ), aSUB_ITEM[ nK, nL ] )
								// Acumular o valor total dos itens.
								If RTrim( aSUB_CPOS[ nL ] ) == 'UB_VLRITEM'
									// Enquanto existir ponto, tirar e enquanto existir a vírgula mudar por ponto.
									cAux := StrTran( StrTran( aSUB_ITEM[ nK, nL ], '.', '' ), ',', '.' )
									// Converter o valor caractere para o valor numérico.
									n321VlTotal += Val( cAux )
								// Acumular o valor total do desconto.
								Elseif RTrim( aSUB_CPOS[ nL ] ) == 'UB_VALDESC'
									// Enquanto existir ponto, tirar e enquanto existir a vírgula mudar por ponto.
									cAux := StrTran( StrTran( aSUB_ITEM[ nK, nL ], '.', '' ), ',', '.' )
									// Converter o valor caractere para o valor numérico.
									nUB_VALDESC += Val( cAux )
								// Acumular o valor da tabela de preço dos itens.
								Elseif RTrim( aSUB_CPOS[ nL ] ) == 'UB_PRCTAB'
									// Enquanto existir ponto, tirar e enquanto existir a vírgula mudar por ponto.
									cAux := StrTran( StrTran( aSUB_ITEM[ nK, nL ], '.', '' ), ',', '.' )
									// Converter o valor caractere para o valor numérico.
									nUB_PRCTAB += Val( cAux )
								Endif
							Next nL
						Next nK
					Endif
				Else
					// Somente para campos que não fazem parte do alias SUB.
					OLE_SetDocumentVar( oWord, aCpos[ nJ, 1 ], aCpos[ nJ, 5 ] )
				Endif
			Next nJ
			
			// Caso haja outro documento para mesma oportunidade que precise 
			// descarregar os produtos, é preciso reiniciar a variável.
			lUnLoad := .F.
						
			// Tem desconto? Então preparar as variáveis.
			If nUB_VALDESC > 0
				cUB_VALDESC := cMV_321DESC + ' ' + LTrim( TransForm( nUB_VALDESC, '@E 999,999,999.99' ) )
				cUB_PRCTAB  := cMV_321PTAB + ' ' + LTrim( TransForm( nUB_PRCTAB , '@E 999,999,999.99' ) )
			Else
				cUB_VALDESC := Chr( 29 )
				cUB_PRCTAB  := Chr( 29 )
			Endif
			
			// Imprimir o valor total dos produtos.
			OLE_SetDocumentVar( oWord, 'PRO_UB_PRCTAB', cUB_PRCTAB )
			
			// Imprimir o valor total dos descontos.
			OLE_SetDocumentVar( oWord, 'PRO_UB_VALDESC', cUB_VALDESC )
			
			// Imprimir o valor total da proposta.
			OLE_SetDocumentVar( oWord, 'PRO_320VLTOTAL', LTrim( TransForm( n321VlTotal, '@E 999,999,999.99' ) ) )
			
			// Imprimir o valor total da proposta por extenso.
			c321VlExten := Extenso( n321VlTotal )
			OLE_SetDocumentVar( oWord, 'PRO_320VLEXTEN', c321VlExten )
			
			c321VlExten := ''
			n321VlTotal := 0
			nUB_VALDESC := 0
			nUB_PRCTAB  := 0

			// Se possuir macro e realmente houver dados de produtos, executar a macro.
	   	If lMacro .And. ( Len( aSUB_ITEM ) > 0 )
	   		OLE_ExecuteMacro( oWord, aFiles[ nI, 3 ] )
	   	Endif
	   	
	   	// Atualizar campos.
	      OLE_UpDateFields( oWord )
	      
	      // Inibir o aplicativo Ms-Word em execução.
			OLE_SetProperty( oWord, '206', .F. )
			
			// Salvar o arquivo no formato DOC.
			OLE_SaveAsFile( oWord, cSaidaDOC )
			Sleep(500)

			// Abrir o arquivo no formato DOC.
			OLE_OpenFile( oWord, cSaidaDOC )
			Sleep(500)
			
			// Salvar o arquivo no formato PDF.
			OLE_SaveAsFile( oWord, cSaidaPDF, /*cPassword*/, /*cWritePassword*/, lReadOnly, cFormat)
			Sleep(500)
			
			// Fechar o arquivo.
			OLE_CloseFile( oWord )
			
			// Desfazer o link.
			OLE_CloseLink( oWord )

			// Apagar o arquivo template.
			FErase( cTemplate )

			// Anexar o arquivo no banco de conhecimento do Televendas.
			A320Anexar( cSaidaPDF, cUA_NUM, aFiles[ nI, 1 ], 'SUA', .T. )
			
			// Anexar o arquivo no banco de conhecimento do Pedido de vendas.
			A320Anexar( cSaidaPDF, cUA_NUMSC5, aFiles[ nI, 1 ], 'SC5', .F. )
			
			aAdd( aFileA321 , cSaidaPDF )
			
			// Incrementar no contador quantas vezes gerou a proposta
			If SUA->UA_NUM <> cUA_NUM
				SUA->( dbSetOrder( 1 ) )
				SUA->( MsSeek( xFilial( 'SUA' ) + cUA_NUM ) )
			Endif
			SUA->( RecLock( 'SUA', .F. ) )
			SUA->UA_QTDPROP := Val( Soma1( Str( SUA->UA_QTDPROP, 2, 0 ) ) )
			SUA->( MsUnLock() )
			
			// É preciso sempre gerar e anexar o arquivo PDF e por fim abri-lo, ou seja, nunca apagar do temporário.
			// Quando o usuário tem permissão de gerar word, deve-se também gerar e anexar o pdf, porém abrir o word.
			If lMsWord
				ShellExecute( 'Open', cSaidaDOC, '', cTempPath, 1 )
			Else
				FErase( cSaidaDOC )
				Sleep(500)
				ShellExecute( 'Open', cSaidaPDF, '', cTempPath, 1 )
			Endif
		Else
			MsgAlert('Não foi possível copiar o arquivo template do servidor para a estação, por isso não será possível gerar o documento proposta (doc/pdf).',cTitulo)
			Exit
		Endif
		lCopy := .F.
		nCheck := 0
	Next nI
Return
//---------------------------------------------------------------------
// Rotina | CSFA322      | Autor | Robson Gonçalves | Data | 20.05.2014 
//---------------------------------------------------------------------
// Descr. | Relatório indicador de propostas Televendas.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function CSFA322()
	Local oReport
	oReport := A322Proc()
	oReport:PrintDialog()
Return
//---------------------------------------------------------------------
// Rotina | A322Proc     | Autor | Robson Gonçalves | Data | 20.05.2014 
//---------------------------------------------------------------------
// Descr. | Processamento e definição de células de impressão.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A322Proc()
	Local oReport
	Local oSection
	Local cTitulo := "Indicador de propostas - Televendas"
	Local cDescr := "Relatório indicador de propostas geradas pelo Televendas."
	Local cPerg := 'CSFA322'
	
	CriaSX1( cPerg )
	
	Pergunte(cPerg,.F.)
	
	oReport := TReport():New("CSFA322", cTitulo, cPerg, {|oReport| A322Print( oReport, cPerg )}, cDescr)
	oReport:DisableOrientation()
	oReport:cFontBody := 'Consolas'
	oReport:nFontBody	:= 8
	oReport:nLineHeight := 42
	oReport:SetPortrait() 
	oReport:SetTotalInLine( .F. )
	
	DEFINE SECTION oSection OF oReport TABLES "SUA" TITLE cTitulo
	oSection:SetTotalInLine(.F.)
	
	DEFINE CELL NAME "UA_OPERADO" OF oSection TITLE "Consultor"         ALIAS 'SUA'
	DEFINE CELL NAME "U7_NOME"    OF oSection TITLE "Nome do consultor" ALIAS 'SUA'
Return( oReport )
//---------------------------------------------------------------------
// Rotina | A322Print    | Autor | Robson Gonçalves | Data | 20.05.2014 
//---------------------------------------------------------------------
// Descr. | Processamento e impressão dos dados.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A322Print( oReport, cPerg )	
	Local cMv_Par03 := ''
	Local cMv_Par05 := ''
	Local cTRB := GetNextAlias()
	
	Local oSection1 := oReport:Section(1)
   Local oSection2
   
   Local cPict := "@E 999,999,999.99"
   
	Local lEndSection := .T.
	Local lEndReport  := .T.
	Local lEndPage    := .T.
   
	//-------------------------------------------
	// Saltar página por consultor? 1=Não; 2=Sim.
	//-------------------------------------------
	oSection1:SetPageBreak(MV_PAR04==2)
	
	DEFINE SECTION oSection2 OF oSection1 TABLES cTRB TITLE 'Clientes por consultor' TOTAL TEXT 'TOTAL CONSULTOR' TOTAL IN COLUMN

	DEFINE CELL NAME "UA_NUM"	   OF oSection2 ALIAS cTRB TITLE 'Televendas' SIZE 10 
	DEFINE CELL NAME "UA_OPER"    OF oSection2 ALIAS cTRB TITLE 'Operação'   SIZE 11 BLOCK {|| Iif((cTRB)->UA_OPER=='1','Faturamento',Iif((cTRB)->UA_OPER=='2','Orçamento','Atendimento'))} 
	DEFINE CELL NAME "UA_CLIENTE"	OF oSection2 ALIAS cTRB TITLE 'Cliente'    SIZE 7
	DEFINE CELL NAME "A1_NOME"	   OF oSection2 ALIAS cTRB TITLE 'Empresa'    SIZE 40
	DEFINE CELL NAME "UA_VLRLIQ"  OF oSection2 ALIAS cTRB TITLE '  Valor Pedido' PICTURE cPict   SIZE 14 ALIGN RIGHT
	DEFINE CELL NAME "VLR_FAT"    OF oSection2 ALIAS cTRB TITLE 'Valor Faturado' PICTURE cPict   SIZE 14 ALIGN RIGHT
	DEFINE CELL NAME "DIF_VLR"    OF oSection2 ALIAS cTRB TITLE '     Diferença' PICTURE cPict   SIZE 14 ALIGN RIGHT
	DEFINE CELL NAME "UA_QTDPROP" OF oSection2 ALIAS cTRB TITLE 'Vezes'          PICTURE '@R 99' SIZE  5 ALIGN RIGHT
	DEFINE CELL NAME "UASTATUS"   OF oSection2 ALIAS cTRB TITLE 'Status'     SIZE 11 BLOCK {|| (cTRB)->UASTATUS } 
	
	oSection2:SetColSpace(1)
	
	If Empty( MV_PAR03 )
		MV_PAR03 := '      -zzzzzz'
	Endif
	MakeSqlExpr( oReport:GetParam() )
	cMv_Par03 := '%'+mv_par03+'%'
		
	// Atend. canceladaos, considerar?
	// 1=Não
	// 2=Sim
	If MV_PAR05 == 1
		cMv_Par05 := "UA_STATUS <> 'CAN'"
	Else
		cMv_Par05 := "UA_STATUS BETWEEN '   ' AND 'zzz'"
	Endif
	cMv_Par05 := '%'+cMv_Par05+'%'
	
	oSection1:BeginQuery()
		BeginSql Alias cTRB
			SELECT UA_OPERADO,
			       U7_NOME, 
			       UA_NUM,
			       UA_OPER,
			       UA_CLIENTE, 
			       A1_NOME,
			       UA_VLRLIQ, 
			       NVL(VLR_FAT,0) AS VLR_FAT,
			       UA_VLRLIQ - NVL(VLR_FAT,0) AS DIF_VLR, 
			       UA_QTDPROP,
			       UASTATUS
			FROM (SELECT UA_OPERADO,
					       U7_NOME, 
					       UA_NUM,
					       UA_OPER,
					       UA_CLIENTE, 
					       A1_NOME, 
					       UA_VLRLIQ, 
					       CASE 
					         WHEN FAT.C5_NOTA = ' ' THEN 0 
					         WHEN FAT.C5_NOTA <> ' ' THEN FAT.C6_VALOR 
					       END VLR_FAT,
					       UA_QTDPROP,
					       CASE
					       	WHEN UA_STATUS = 'CAN' THEN 'CANCELADO'
					       	WHEN UA_STATUS = 'NF.' THEN 'NF EMITIDA'
					       	WHEN UA_STATUS = 'SUP' THEN 'PV BLOQUEADO'
					       	WHEN UA_STATUS = 'RM.' THEN 'MERC ENVIADA'
					       	WHEN UA_STATUS = 'LIB' THEN 'LIBERADO'
					       	ELSE '*'
					       END UASTATUS
					FROM   %table:SUA% SUA 
					       INNER JOIN %table:SA1% SA1 
					               ON A1_FILIAL = %xFilial:SA1%
					                  AND A1_COD = UA_CLIENTE 
					                  AND A1_LOJA = UA_LOJA 
					                  AND SA1.%notDel% 
					       INNER JOIN %table:SU7% SU7 
					               ON U7_FILIAL = %xFilial:SU7%
					                  AND U7_COD = UA_OPERADO 
					                  AND SU7.%notDel% 
					       LEFT JOIN (SELECT C5_NOTA, 
					                         C5_ATDTLV, 
					                         SUM(C6_VALOR) AS C6_VALOR 
					                  FROM   %table:SC6% SC6 
					                         INNER JOIN %table:SC5% SC5 
					                                 ON C5_FILIAL = %xFilial:SC5%
					                                    AND SC5.%notDel% 
					                                    AND C5_NUM = C6_NUM 
					                  WHERE  C6_FILIAL = %xFilial:SC6%
					                         AND SC6.%notDel% 
					                  GROUP  BY C5_NOTA, C5_ATDTLV) FAT 
					              ON UA_NUM = FAT.C5_ATDTLV 
					WHERE  UA_FILIAL = %xFilial:SUA%
					       AND UA_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
					       AND %Exp:cMv_Par03%
				       	 AND %Exp:cMv_Par05%
					       AND SUA.%notDel% 
					ORDER  BY U7_NOME, A1_NOME)
		EndSql
	oSection1:EndQuery()

	oSection2:SetParentQuery()
	oSection2:SetParentFilter({|cParam| (cTRB)->( U7_NOME ) == cParam },{|| (cTRB)->( U7_NOME ) })
	
	TRFunction():New(oSection2:Cell("UA_NUM")    ,"","COUNT",,"","@E 999")
	TRFunction():New(oSection2:Cell("UA_VLRLIQ") ,"","SUM"  ,,"",cPict   )
	TRFunction():New(oSection2:Cell("VLR_FAT")   ,"","SUM"  ,,"",cPict   )
	TRFunction():New(oSection2:Cell("DIF_VLR")   ,"","SUM"  ,,"",cPict   )
	TRFunction():New(oSection2:Cell("UA_QTDPROP"),"","SUM"  ,,"","@E 99" )
	
	DEFINE COLLECTION OF oSection2 FUNCTION SUM FORMULA oSection2:Cell('UA_OPER') CONTENT oSection2:Cell("UA_VLRLIQ") TITLE 'Total por tipo de operação'
	
	oSection1:Print()
Return
//---------------------------------------------------------------------
// Rotina | CriaSX1      | Autor | Robson Gonçalves | Data | 20.05.2014 
//---------------------------------------------------------------------
// Descr. | Rotina para criar o grupo de perguntas.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function CriaSX1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}

	aAdd(aP,{"Atendimento de?"                ,"D",08,0,"G",""                    ,"","","","","","",""})
	aAdd(aP,{"Atendimento ate?"               ,"D",08,0,"G","(mv_par02>=mv_par01)","","","","","","",""})
	aAdd(aP,{"Consultor(es)?"                 ,"C",99,0,"R",""                    ,"SU7","","","","","","UA_OPERADO"})
	aAdd(aP,{"Saltar página por consultor?"   ,"N", 1,0,"C",""                    ,"","Nao","Sim","","","",""})
	aAdd(aP,{"Atend. cancelados, considerar?" ,"N", 1,0,"C",""                    ,"","Nao","Sim","","","",""})
	
	aAdd(aHelp,{"Informe a partir de qual data de emissão","quer processar."})
	aAdd(aHelp,{"Informe até qual data de emissão quer"  ,"processar."})
	aAdd(aHelp,{"Informe o código dos consultores.",""})
	aAdd(aHelp,{"Selecione a opção SIM para o relatório ","saltar de página quando mudar de consultor"})
	aAdd(aHelp,{"Selecione a opção SIM p/ o relatório co","nsiderar também os atendimentos cancelados"})
	
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

//-----------------------------------------------------------------------
// Rotina | A320Email | Autor | Rafael Beghini     | Data | 04/05/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para enviar a Proposta por e-mail. 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A320Email(cAD5_NROPOR, aObjeto)
	Local cTRB     := GetNextAlias()
	Local cContato := ''
	Local cConta   := ''
	Local cDescricao := ''
	Local cCabec   := 'Proposta Comercial: ' + cAD5_NROPOR + ' - '
	Local cInfo    := 'Informe o e-mail do contato para o envio da proposta. Caso possua mais de 01 contato, separar por ;'
	Local xTitulo  := 'Gestão de Oportunidade - Envio de proposta por E-mail'
	Local oDlg     := Nil
	Local oMsg     := NIL
	Local nLin     := 0
	Local cMV_320MAIL := 'MV_320MAIL'
	
	
	Private cDe      := GetMV("MV_EMCONTA") //certisign_protheus@certisign.com.br
	Private cPara    := Space(200)
	Private cCc      := Space(200)
	Private cAssunto := Space(200)
	Private cAnexo   := Space(200)
	Private cMsg     := SPace(200)
	
	Private cServer  := GetMV("MV_RELSERV") // smtp.ig.com.br ou 200.181.100.51
	Private cEmail   := GetMV("MV_EMCONTA") //GetMV("MV_RELACNT") //certisign_protheus@certisign.com.br
	Private cPass    := GetMV("MV_RELPSW")  // 123abc
	Private lAuth    := GetMv("MV_RELAUTH") // .T. ou .F.
	
	If .NOT. SX6->( ExisteSX6( cMV_320MAIL ) )
		CriarSX6( cMV_320MAIL, 'L', 'Envia proposta por email para todos os contatos ou somente o primeiro. CSFA320.prw', '.F.' )
	Endif
	
	If ! Empty(aObjeto)
		For nLin := 1 To Len(aObjeto)
			cAnexo += MsDocPath() + '\' + aObjeto[nLin] + ';'		
		Next nLin
	EndIf
	
	//Transforma parâmetros do tipo Range em expressão SQL para ser utilizadana query.
	MakeSqlExpr(cAD5_NROPOR)
	
	BeginSql Alias "cTRB"
		SELECT 
			AD9_FILIAL, AD9_NROPOR, AD9_REVISA, AD9_CODCON, U5_CODCONT, U5_CONTAT, U5_EMAIL, AD9.R_E_C_N_O_
		FROM %Table:AD9% AD9
			INNER JOIN %Table:SU5% SU5
			ON AD9_CODCON = U5_CODCONT AND SU5.%NOTDEL%
		WHERE
			AD9_NROPOR = %Exp:cAD5_NROPOR% AND
			AD9.%NOTDEL%
		ORDER BY AD9.R_E_C_N_O_	
	EndSql
		
	DbSelectArea("cTRB")
	DbGoTop()
	
	If GetMv( cMV_320MAIL ) //Pega somente o primeiro contato para enviar a proposta por e-mail.
		cContato := Alltrim(cTRB->U5_CONTAT) + ' - ' + Alltrim(cTRB->U5_EMAIL) + CRLF	
		cConta   := Alltrim(cTRB->U5_EMAIL) + ';'
	Else
		While !cTRB->(Eof())
			cContato += Alltrim(cTRB->U5_CONTAT) + ' - ' + Alltrim(cTRB->U5_EMAIL) + CRLF
			cConta   += Alltrim(cTRB->U5_EMAIL)+';' 
			cTRB->( dbSkip() )
		EndDo
	EndIf
	
	cTRB->( dbCloseArea() )
	
	If ! Empty(cContato)
		cDescricao := Posicione( "AD1" , 1 , xFilial( "AD1" ) + cAD5_NROPOR , "AD1_DESCRI" )
		cCabec += Alltrim(cDescricao)
		
		If MsgYesNo('A proposta comercial será enviada para o(s) seguinte(s) contato(s): ' + CRLF + cContato + CRLF + 'Confirma?', cTitulo)
			cPara := cConta
						
			DEFINE MSDIALOG oDlg TITLE xTitulo FROM 0,0 TO 450,600 OF oDlg PIXEL
	
			@  5,3 SAY cCabec      SIZE 250,7 PIXEL OF oDlg
			@ 20,3 SAY "Assunto:"  SIZE 30,7  PIXEL OF oDlg
			@ 35,3 SAY "Mensagem:" SIZE 30,7  PIXEL OF oDlg
			
			@ 20,35 MSGET cAssunto PICTURE "@" SIZE 248, 8 PIXEL OF oDlg
			@ 35,35 GET oMsg VAR cMsg MEMO SIZE 248,93 PIXEL OF oDlg
			
			@ 200,210 BUTTON "&Enviar"    SIZE 36,13 PIXEL ACTION (lOpc:=Validar(),Iif(lOpc,Eval({||A320EnvMail(),oDlg:End()}),NIL))
			@ 200,248 BUTTON "&Abandonar" SIZE 36,13 PIXEL ACTION oDlg:End()
	
			ACTIVATE MSDIALOG oDlg CENTERED
		Else
			DEFINE MSDIALOG oDlg TITLE xTitulo FROM 0,0 TO 450,600 OF oDlg PIXEL
	
			@  5,3 SAY cCabec      SIZE 250,7 PIXEL OF oDlg
			@ 20,3 SAY cInfo       SIZE 250,7 PIXEL OF oDlg
			@ 35,3 SAY "Para:"     SIZE 30,7  PIXEL OF oDlg
			@ 50,3 SAY "Assunto:"  SIZE 30,7  PIXEL OF oDlg
			@ 65,3 SAY "Mensagem:" SIZE 30,7  PIXEL OF oDlg
			
			@ 35,35 MSGET cPara    PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
			@ 50,35 MSGET cAssunto PICTURE "@" SIZE 248, 8 PIXEL OF oDlg
			@ 65,35 GET oMsg VAR cMsg MEMO SIZE 248,93 PIXEL OF oDlg
			
			@ 200,210 BUTTON "&Enviar"    SIZE 36,13 PIXEL ACTION (lOpc:=Validar(),Iif(lOpc,Eval({||A320EnvMail(),oDlg:End()}),NIL))
			@ 200,248 BUTTON "&Abandonar" SIZE 36,13 PIXEL ACTION oDlg:End()
	
			ACTIVATE MSDIALOG oDlg CENTERED
		EndIf
	Else
		MsgAlert('Oportunidade sem código de contato, por favor, informe o código do contato.',cTitulo)
	EndIf
Return

//-----------------------------------------------------------------------
// Rotina | Validar  | Autor | Rafael Beghini         | Data | 04/05/2015
//-----------------------------------------------------------------------
// Descr. | Verifica se o campo 'Para' foi preenchido para envio da 
//        | proposta por e-mail. 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function Validar()
	Local lRet := .T.
	
	If Empty(cPara)
	   MsgInfo("Campo 'Para' preenchimento obrigatório",cTitulo)
	   lRet:=.F.
	Endif
	
	If lRet
		cPara := AllTrim(cPara)
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A320EnvMail | Autor | Rafael Beghini     | Data | 04/05/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para enviar a Proposta por e-mail. 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320EnvMail()
	Local lResulConn := .T.
	Local lResulSend := .T.
	Local cError := ""
	
	CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn
	
	If !lResulConn
	   GET MAIL ERROR cError
	   MsgAlert("Falha na conexão "+cError)
	   Return
	Endif
	
	If lAuth
	   lAuth := MailAuth(cEmail,cPass)
	   If !lAuth
		   ApMsgInfo("Autenticação FALHOU","Protheus")
		   Return
	   Endif
	Endif
	
	// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
	// Todos os e-mail terão: De, Para, Assunto e Mensagem, porém precisa analisar se tem: Com Cópia e/ou Anexo
	If Empty(cAnexo)
	   SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend
	Else
	   SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend   
	Endif
	   
	If !lResulSend
	   GET MAIL ERROR cError
	   MsgAlert("Falha no Envio do e-mail " + cError)
	Else
	   MsgInfo("E-mail enviado com sucesso.", cTitulo)
	Endif
	
	DISCONNECT SMTP SERVER
Return

//-----------------------------------------------------------------------
// Rotina | A320APF | Autor | Rafael Beghini     | Data | 19/05/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para geração do WorkFlow - Aceite da Proposta Final 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A320APF()
	
	Local lRet := .T.

	dbSelectArea('AD1')
	AD1->( dbSetOrder( 1 ) )
	If AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
		If M->AD5_EVENTO == '004APF' .And. AD1->AD1_PROVEN $ '000001|000002' //.And. AD1->AD1_STAGE == '004GER'
			lRet := U_CSFAT030( M->AD5_NROPOR, M->AD5_VEND )
		Endif
	Endif

Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A321Email | Autor | Rafael Beghini     | Data | 15/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para enviar a Proposta por e-mail.  - Televendas
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A321Email(cUA_NUM, aFileA321)
	Local cTRB     := GetNextAlias()
	Local cContato := ''
	Local cConta   := ''
	Local cDescricao := ''
	Local cFile    := ''
	Local cCabec   := 'Proposta Comercial: ' + cUA_NUM + ' - '
	Local cInfo    := 'Informe o e-mail do contato para o envio da proposta. Caso possua mais de 01 contato, separar por ;'
	Local xTitulo  := 'Televendas - Envio de proposta por E-mail'
	Local oDlg     := Nil
	Local oMsg     := NIL
	Local nLin     := 0
	Local nPosFile := 0
	
	Private cDe      := GetMV("MV_EMCONTA") //certisign_protheus@certisign.com.br
	Private cPara    := Space(200)
	Private cCc      := UsrRetMail( RetCodUsr() )
	Private cAssunto := Space(200)
	Private cAnexo   := ''
	Private cMsg     := SPace(200)
	
	Private cServer  := GetMV("MV_RELSERV") // smtp.ig.com.br ou 200.181.100.51
	Private cEmail   := GetMV("MV_EMCONTA") //GetMV("MV_RELACNT") //certisign_protheus@certisign.com.br
	Private cPass    := GetMV("MV_RELPSW")  // 123abc
	Private lAuth    := GetMv("MV_RELAUTH") // .T. ou .F.
		
	If ! Empty(aFileA321)
		For nLin := 1 To Len(aFileA321)
			nPosFile := Rat( "\", aFileA321[nLin] )
			cFile    := aFileA321[nLin]
			cFile    := Substring( cFile, nPosFile + 1, Len( cFile ) )
			IF __CopyFile( aFileA321[nLin], MsDocPath() + '\' + cFile )
				cAnexo += MsDocPath() + '\' + cFile + ';'	
			EndIF	
		Next nLin
	EndIf
	
	//Transforma parâmetros do tipo Range em expressão SQL para ser utilizadana query.
	MakeSqlExpr(cUA_NUM)
	
	BeginSql Alias "cTRB"
		SELECT 
			UA_NUM, UA_CLIENTE, UA_LOJA, UA_CODCONT, UA_DESCNT, U5_EMAIL
		FROM %Table:SUA% SUA
			INNER JOIN %Table:SU5% SU5
			ON U5_CODCONT = UA_CODCONT AND SU5.%NOTDEL%
		WHERE
			UA_NUM = %Exp:cUA_NUM% AND
			SUA.%NOTDEL%	
	EndSql
		
	DbSelectArea("cTRB")
	DbGoTop()
	
	IF .NOT. cTRB->(Eof())
		cContato += Alltrim(cTRB->UA_DESCNT) + ' - ' + Alltrim(cTRB->U5_EMAIL) + CRLF
		cConta   += Alltrim(cTRB->U5_EMAIL)+';' 
		cCabec   += RTrim( TkDCliente(cTRB->UA_CLIENTE,cTRB->UA_LOJA) )
	EndIf
	
	cTRB->( dbCloseArea() )
	
	If ! Empty(cContato)
		
		If MsgYesNo('A proposta comercial será enviada para o seguinte contato: ' + CRLF + cContato + CRLF + 'Confirma o e-mail?', xTitulo)
			cPara := cConta
						
			DEFINE MSDIALOG oDlg TITLE xTitulo FROM 0,0 TO 450,600 OF oDlg PIXEL
	
			@  5,3 SAY cCabec      SIZE 250,7 PIXEL OF oDlg
			@ 35,3 SAY "Para:"     SIZE 30,7  PIXEL OF oDlg
			@ 50,3 SAY "Assunto:"  SIZE 30,7  PIXEL OF oDlg
			@ 65,3 SAY "Mensagem:" SIZE 30,7  PIXEL OF oDlg
			
			@ 35,35 MSGET cPara    When .F. PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
			@ 50,35 MSGET cAssunto          PICTURE "@" SIZE 248, 8 PIXEL OF oDlg
			@ 65,35 GET oMsg VAR cMsg MEMO SIZE 248,93 PIXEL OF oDlg
			
			@ 200,210 BUTTON "&Enviar"    SIZE 36,13 PIXEL ACTION (lOpc:=Validar1(),Iif(lOpc,Eval({||A321EnvMail(),oDlg:End()}),NIL))
			@ 200,248 BUTTON "&Abandonar" SIZE 36,13 PIXEL ACTION oDlg:End()
	
			ACTIVATE MSDIALOG oDlg CENTERED
		Else
			DEFINE MSDIALOG oDlg TITLE xTitulo FROM 0,0 TO 450,600 OF oDlg PIXEL
	
			@  5,3 SAY cCabec      SIZE 250,7 PIXEL OF oDlg
			@ 20,3 SAY cInfo       SIZE 250,7 PIXEL OF oDlg
			@ 35,3 SAY "Para:"     SIZE 30,7  PIXEL OF oDlg
			@ 50,3 SAY "Assunto:"  SIZE 30,7  PIXEL OF oDlg
			@ 65,3 SAY "Mensagem:" SIZE 30,7  PIXEL OF oDlg
			
			@ 35,35 MSGET cPara    PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
			@ 50,35 MSGET cAssunto PICTURE "@" SIZE 248, 8 PIXEL OF oDlg
			@ 65,35 GET oMsg VAR cMsg MEMO SIZE 248,93 PIXEL OF oDlg
			
			@ 200,210 BUTTON "&Enviar"    SIZE 36,13 PIXEL ACTION (lOpc:=Validar1(),Iif(lOpc,Eval({||A321EnvMail(),oDlg:End()}),NIL))
			@ 200,248 BUTTON "&Abandonar" SIZE 36,13 PIXEL ACTION oDlg:End()
	
			ACTIVATE MSDIALOG oDlg CENTERED
		EndIf
	Else
		DEFINE MSDIALOG oDlg TITLE xTitulo FROM 0,0 TO 450,600 OF oDlg PIXEL
	
			@  5,3 SAY cCabec      SIZE 250,7 PIXEL OF oDlg
			@ 20,3 SAY cInfo       SIZE 250,7 PIXEL OF oDlg
			@ 35,3 SAY "Para:"     SIZE 30,7  PIXEL OF oDlg
			@ 50,3 SAY "Assunto:"  SIZE 30,7  PIXEL OF oDlg
			@ 65,3 SAY "Mensagem:" SIZE 30,7  PIXEL OF oDlg
			
			@ 35,35 MSGET cPara    PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
			@ 50,35 MSGET cAssunto PICTURE "@" SIZE 248, 8 PIXEL OF oDlg
			@ 65,35 GET oMsg VAR cMsg MEMO SIZE 248,93 PIXEL OF oDlg
			
			@ 200,210 BUTTON "&Enviar"    SIZE 36,13 PIXEL ACTION (lOpc:=Validar1(),Iif(lOpc,Eval({||A321EnvMail(),oDlg:End()}),NIL))
			@ 200,248 BUTTON "&Abandonar" SIZE 36,13 PIXEL ACTION oDlg:End()
	EndIf
Return

//-----------------------------------------------------------------------
// Rotina | Validar  | Autor | Rafael Beghini         | Data | 15/12/2015
//-----------------------------------------------------------------------
// Descr. | Verifica se o campo 'Para' foi preenchido para envio da 
//        | proposta por e-mail. - Televendas
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function Validar1()
	Local lRet := .T.
	Local xTitulo  := 'Televendas - Envio de proposta por E-mail'
	
	If Empty(cPara)
	   MsgInfo("Campo 'Para' preenchimento obrigatório",xTitulo)
	   lRet:=.F.
	Endif
	If Empty(cAssunto)
	   MsgInfo("Campo 'Assunto' preenchimento obrigatório",xTitulo)
	   lRet:=.F.
	Endif
	If Empty(cMsg)
	   MsgInfo("Campo 'Mensagem' preenchimento obrigatório",xTitulo)
	   lRet:=.F.
	Endif
	
	If lRet
		cPara := AllTrim(cPara)
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A320EnvMail | Autor | Rafael Beghini     | Data | 15/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para enviar a Proposta por e-mail - Televendas
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A321EnvMail()
	Local lResulConn := .T.
	Local lResulSend := .T.
	Local cError := ""
	
	CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn
	
	If !lResulConn
	   GET MAIL ERROR cError
	   MsgAlert("Falha na conexão "+cError)
	   Return
	Endif
	
	If lAuth
	   lAuth := MailAuth(cEmail,cPass)
	   If !lAuth
		   ApMsgInfo("Autenticação FALHOU","Protheus")
		   Return
	   Endif
	Endif
	
	// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
	// Todos os e-mail terão: De, Para, Assunto e Mensagem, porém precisa analisar se tem: Com Cópia e/ou Anexo
	If Empty(cAnexo)
	   SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg RESULT lResulSend
	Else
	   SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend   
	Endif
	   
	If !lResulSend
	   GET MAIL ERROR cError
	   MsgAlert("Falha no Envio do e-mail " + cError)
	Else
	   MsgInfo("E-mail enviado com sucesso.", cTitulo)
	Endif
	
	DISCONNECT SMTP SERVER
Return

//---------------------------------------------------------------------
// Rotina | A321IProp    | Autor | Robson Gonçalves | Data | 17.05.2014 
//---------------------------------------------------------------------
// Rotina | A322IProp    | Alterada | Renato Ruy    | Data | 19.07.2016 
//---------------------------------------------------------------------
// Descr. |Gerar proposta no atendimento.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A322IPro(oGride)
	Local nOpcao := 0
	
	Local cTitulo    := 'Agenda Certisign - Gerar Propostas'
	Local cChave	 := ""
	Local cU4_CODLIG := ""
	Local cU6_ATENDIM:= ""
	
	cU4_CODLIG  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U4_CODLIG'	  } ) ]
	cU6_ATENDIM := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U6_ATENDIM'	  } ) ]
	cChave := SubStr(Iif(Empty(cU4_CODLIG),cU6_ATENDIM,cU4_CODLIG),1,6)

	U_A322Prop( cChave, oGride )

Return

//---------------------------------------------------------------------
// Rotina | A322Prop    | Autor | Robson Gonçalves | Data | 17.05.2014 
//---------------------------------------------------------------------
// Rotina | A322Prop    | Alterada | Renato Ruy    | Data | 17.05.2014 
//---------------------------------------------------------------------
// Descr. |Gerar proposta no atendimento.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A322Prop( cChave, oGride )
	Private cTitulo := 'Agenda Certisign - Gerar Propostas'
	Processa( {|| A322Make( cChave, oGride )}, cTitulo,'Aguarde processando...', .F. )
Return

//---------------------------------------------------------------------
// Rotina | A322Make     | Autor | Renato Ruy | Data | 17.05.2014 
//---------------------------------------------------------------------
// Descr. | Alteração na rotina A321Make para gerar proposta.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A322Make( cChave, oGride )
	Local cMV_321PROP := 'MV_321PROP'
	Local cMV_321FILT := 'MV_321FILT'
	Local cArqIni := c320ArqIni
	Local cFunName := FunName()
	Local aCpos := {}
	Local aFiles := {}
	
  	Private aSUD_CPOS := {}
     Private aSUD_ITEM := {}
     Private aFileA321 := {}
	
	// Processos que serão processados.
	ProcRegua(5)
	
	//-----------------------------------
	// Verificar se existe o arquivo INI.
	//-----------------------------------
	If File( cArqIni )
		//-------------------------------------------------------------
		// Verificar possibilidade de filtro por descrição da proposta.
		If .NOT. SX6->( ExisteSX6( cMV_321FILT ) )
			CriarSX6( cMV_321FILT, 'C', 'Expressao AdvPL para filtrar as propostas por decricao no Televendas. CSFA320.prw', '"VDS"$ZZB->ZZB_NOMEPR' )
		Endif
		cMV_321FILT := GetMv( cMV_321FILT )
		//----------------------------------------------------
		// Selecionar os arquivos templates a serem impressos.
		//----------------------------------------------------
		If A320Select(@aFiles,cMV_321FILT)
			//----------------------------------------
			// Carregar os dados conforme arquivo INI.
			//----------------------------------------
			IncProc('Lendo arquivo INI.')
			aCpos := A320LerIni( c320ArqIni )
			//---------------------------------------------------------
			// Posicionar os registros das tabelas para carregar dados.
			//---------------------------------------------------------
			IncProc('Posicionando os registros.')
			If A322Seek( cChave, @aCpos )
				//--------------------------------------------------------------------------
				// Gerar os documentos conforme selecionados para a oportunidade em questão.
				//--------------------------------------------------------------------------
				IncProc('Intengrando os dados com Ms-Word.')
				If A322Word( cChave, aFiles, aCpos, oGride )
					MsgInfo('Processo finalizado, verifique no Conhecimento o(s) documento(s) gerado(s).',cTitulo)
					If MsgYesNo('Deseja enviar a proposta por e-mail?', cTitulo)
						U_A321Email(cChave, aFileA321)
					Endif
				Endif
			Endif
		Endif
	Else
		MsgAlert('Não foi localizado o arquivo '+Upper(c320ArqIni)+', por favor, buscar apoio junto a Sistemas Corporativos',cTitulo)
	Endif
	
Return

//---------------------------------------------------------------------
// Rotina | A322Seek     | Autor | Renato Ruy | Data | 17.05.2014 
//---------------------------------------------------------------------
// Descr. | Alteração na rotina A322Seek para gerar proposta.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A322Seek( cChave, aCpos )
	Local nI := 0
	Local nJ := 0
	Local nQ := 0
	Local nElem := 0
	
	Local cTab := ''
	Local cCpo := ''
	Local cDado := ''
	Local cType := ''
	Local cPicture := '@E 999,999,999.99'
	
	SUC->( dbSetOrder( 1 ) )
	If !SUC->( MsSeek( xFilial( 'SUC' ) + cChave ) )
		MsgInfo("Não é possível gerar proposta para agenda sem atendimento!","Agenda Certisign")
		Return
	EndIf
	
	SUD->( dbSetOrder( 1 ) )
	SUD->( MsSeek( xFilial( 'SUD' ) + cChave ) )
		
	SU5->( dbSetOrder( 1 ) )
	SU5->( dbSeek( xFilial( 'SU5' ) + SUC->UC_CODCONT ) )

	SU7->( dbSetOrder( 4 ) )
	SU7->( dbSeek( xFilial( 'SU7' ) + __cUserID ) )

	SA3->( dbSetOrder( 1 ) )
	SA3->( dbSeek( xFilial( 'SA3' ) + SU7->U7_CODVEN ) )
	
	SE4->( dbSetOrder( 1 ) )
	SE4->( dbSeek( xFilial( 'SE4' ) + "000" ) )

	For nI := 1 To Len( aCpos )
		// Se não for tabela + campo, apenas atribuir.
		If SubStr( aCpos[ nI, 2 ], 4, 2 ) <> '->'
			cType := ValType( &( aCpos[ nI, 2 ] ) )
			If     cType == 'D' ; cDado := Dtoc( &( aCpos[ nI, 2 ] ) )
			Elseif cType == 'N' ; cDado := LTrim( TransForm( &( aCpos[ nI, 2 ] ), cPicture ) )
			Elseif cType == 'C' ; cDado := &( aCpos[ nI, 2 ] ) ; cDado := StrTran( cDado, "'", '' )
			Endif

			aCpos[ nI, 5 ] := cDado

		// Se for tabela e campo macro executar o campo.
		Else
			// Capturar o alias.
			cTab := Left( aCpos[ nI, 2 ], 3 )

			// Capturar o campo.
			cCpo := SubStr( aCpos[ nI, 2 ], 6 )

			// Capturar o tipo do dado.
			cType := ValType( (cTab)->( FieldGet( FieldPos( cCpo ) ) ) )

			// Avaliar o tipo do dado e transforma-lo em string.
			If     cType == 'D' ; cDado := Dtoc( (cTab)->( FieldGet( FieldPos( cCpo ) ) ) )
			Elseif cType == 'N' ; cDado := LTrim( TransForm( (cTab)->( FieldGet( FieldPos( cCpo ) ) ), cPicture ) ) 
			Elseif cType == 'C' ; cDado := (cTab)->( FieldGet( FieldPos( cCpo ) ) ) ; cDado := StrTran( cDado, "'", '' )
			Endif

			// Se for o campo cargo do vendedor, buscar a descrição do cargo na tabela SUM.
			If 'A3_CARGO' $ aCpos[ nI, 2 ] .And. .NOT. Empty( &( aCpos[ nI, 2 ] ) )
				cDado := RTrim( Posicione( 'SUM', 1, xFilial( 'SUM' ) + SA3->A3_CARGO, 'UM_DESC' ) )
			Endif

			// Atribuir o dado ao vetor no elemento em questão.
			aCpos[ nI, 5 ] := cDado	

			// Se for campos da tabela SUD e não há dados nos array ITEM e CPOS.
			If Left( aCpos[ nI, 2 ] , 3 ) == 'SUD' .And. Len( aSUD_ITEM )==0 .And. Len( aSUD_CPOS )==0

				// Quantos e quais campos possuem o alias SUD?
				For nQ := nI To Len( aCpos )
					If Left( aCpos[ nQ, 2 ], 3 ) == 'SUD'
						AAdd( aSUD_CPOS, SubStr( aCpos[ nQ, 2 ], 6 ) )
						// Capturar dados adicionais de produtos.
						If 'UD_PRODUTO' $ aCpos[ nQ, 2 ]
							AAdd( aSUD_CPOS, 'B1_DESC' )
							AAdd( aSUD_CPOS, 'B1_UM' )
						Endif
					Else
						Exit
					Endif
				Next nQ

				// Com base na informação acima insira os dados no vetor aSUD_ITEM enquanto a chaver for verdadeira.
				While SUD->(.NOT. EOF()) .And. SUD->UD_FILIAL==xFilial('SUD') .And. SUD->UD_CODIGO==cChave

					// Adicionar o elemento no vetor.
					AAdd( aSUD_ITEM, Array( Len( aSUD_CPOS ) ) )

					// Capturar o número do elemento do vetor.
					nElem := Len( aSUD_ITEM )

					// Ler todos os campos do SUD.
					For nJ := 1 To Len( aSUD_CPOS )
						// Campos do SUD.
						If Left( aSUD_CPOS[ nJ ], 2 ) == 'UD'
							// Posicionar o produto.
							If aSUD_CPOS[ nJ ] == 'UD_PRODUTO'
								SB1->( dbSetOrder( 1 ) )
								SB1->( dbSeek( xFilial( 'SB1' ) + SUD->( FieldGet( FieldPos( aSUD_CPOS[ nJ ] ) ) ) ) )
							Endif
							
							// Capturar o tipo de dado do campo.
							cType := ValType( SUD->( FieldGet( FieldPos( aSUD_CPOS[ nJ ] ) ) ) )
	
							// Avaliar o tipo de dado e transforma-lo em string.
							If cType == 'D'
								cDado := Dtoc( SUD->( FieldGet( FieldPos( aSUD_CPOS[ nJ ] ) ) ) )
							Elseif cType == 'N'
								// Se for o campo UB_PRCTAB multiplicar o campo preço de tabela pela quantidade.
								If aSUD_CPOS[ nJ ] == 'UD_VUNIT'
									cDado := LTrim( TransForm( Round( SUD->( UD_VUNIT ), 2 ), cPicture ) )
								Else
									// Demais dados caracteres.
									cDado := LTrim( TransForm( SUD->( FieldGet( FieldPos( aSUD_CPOS[ nJ ] ) ) ), cPicture ) )
								Endif
							Elseif cType == 'C'
								cDado := SUD->( FieldGet( FieldPos( aSUD_CPOS[ nJ ] ) ) )
								cDado := StrTran( cDado, "'", '' )
							Endif
	
							// Atribuir o dado ao elemento do vetor relacionado ao campo em questão.
							aSUD_ITEM[ nElem, nJ ] := cDado 
						// Campos do SB1.
						Elseif Left( aSUD_CPOS[ nJ ], 2 ) == 'B1'
							// Capturar o tipo de dado do campo.
							cType := ValType( SB1->( FieldGet( FieldPos( aSUD_CPOS[ nJ ] ) ) ) )
	
							// Avaliar o tipo de dado e transforma-lo em string.
							If     cType == 'D' ; cDado := Dtoc( SB1->( FieldGet( FieldPos( aSUD_CPOS[ nJ ] ) ) ) )
							Elseif cType == 'N' ; cDado := LTrim( TransForm( SB1->( FieldGet( FieldPos( aSUD_CPOS[ nJ ] ) ) ), cPicture ) )
							Elseif cType == 'C' ; cDado := SB1->( FieldGet( FieldPos( aSUD_CPOS[ nJ ] ) ) ) ; cDado := StrTran( cDado, "'", '' )
							Endif
	
							// Atribuir o dado ao elemento do vetor relacionado ao campo em questão.
							aSUD_ITEM[ nElem, nJ ] := cDado
						Endif
					Next nJ
					SUD->( dbSkip() )
				End
			Endif
		Endif			
	Next nI
	
Return( .T. )
//---------------------------------------------------------------------
// Rotina | A322Word     | Autor | Robson Gonçalves | Data | 17.05.2014 
//---------------------------------------------------------------------
// Descr. | Rotina para descarregar as informações no template 
//        | selecionado.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A322Word( cChave, aFiles, aCpos, oGride )
	Local oWord
	Local cCampo := ""

	Local nI := 0
	Local nJ := 0
	Local nK := 0
	Local nL := 0
	Local nC := 1
	Local nP := 0
	Local nCheck := 0
	
	Local cArqSaida := ''
	
	Local lCopy := .F.
	Local lMsWord := .F.
	Local lMacro := .F.
	Local lUnLoad := .F.
	Local lReadOnly := .F.
	Local lTemSUD := ( Len( aSUD_ITEM ) > 0 )

	Local cFormat := '17'
	Local cTempPath := GetTempPath()
	Local cTitulo := 'CSFA322 | Integração Protheus x Word - Agenda Certisign'
	Local cOrigem := ''
	Local cTemplate := ''
	Local cSaidaDOC := ''
	Local cSaidaPDF := ''
	Local cVerDOC := ''
	Local cVerPDF := ''
	Local cNomeArq := ''
	Local cExtArq := ''
	Local cMV_321WORD := 'MV_321WORD'
	Local cMV_321DESC := 'MV_321DESC'
	Local cMV_321PTAB := 'MV_321PTAB'
	Local c321VlExten := ''
	Local cAux 	:= ''
	Local cCnpj	:= ''
	Local ret := .T.
	
	Private nVersaoDocto := 0
	Private n321QtItens  := 0
	Private n321VlTotal  := 0
		
	// Parâmetro com o texto a ser impresso caso haja desconto na proposta do Televendas.
	If .NOT. GetMV( cMV_321PTAB, .T. )
		CriarSX6( cMV_321PTAB, 'C', 'TEXTO PARA SER IMPRESSO NA PROPOSTA TELEVENDAS INFORMANDO PRECO DE TABELA. CSFA320.prw', 'Valor total de tabela R$' )
	Endif
	cMV_321PTAB := GetMv( cMV_321PTAB, .F. )

	// Parâmetro com o texto a ser impresso caso haja desconto na proposta do Televendas.
	If .NOT. GetMV( cMV_321DESC, .T. )
		CriarSX6( cMV_321DESC, 'C', 'TEXTO PARA SER IMPRESSO NA PROPOSTA TELEVENDAS INFORMADO O TOTAL DE DESCONTO. CSFA320.prw', 'Valor total de desconto R$' )
	Endif
	cMV_321DESC := GetMv( cMV_321DESC, .F. )
	
	// Se não existir o parâmetro, criar.
	If .NOT. SX6->( ExisteSX6( cMV_321WORD ) )
		CriarSX6( cMV_321WORD, 'C', 'USERID DOS USUARIOS DO TELEVENDAS AUTORIZADOS GERAR PROPOSTA NO FORMATO MS-WORD.', '000000|000445' )
	Endif
	
	// Capturar o conteúdo do parâmetro.
	cMV_321WORD := GetMv( cMV_321WORD )
	
	// Avaliar se o usuário em questão pode gerar documento em Ms-Word.
	lMsWord := ( RetCodUsr() $ cMV_321WORD )
	
	// Quantos arquivos vamos processar.
	aCopy := Array( Len( aFiles ) )
	
	//Renato Ruy - 21/07/2016
	//Função para selecionar os produto
	CSFA320P(aSUD_ITEM)
	
	For nI := 1 To Len( aFiles )
		// Local onde está o arquivo template no servidor.
		cOrigem := aFiles[ nI, 2 ]
		
		// Verificar se o arquivo existe na origem.
		If .NOT. File( cOrigem )
			MsgInfo('CSFA321 | Não encontrado o arquivo de proposta na origem conforme seu cadastro, verifique se o endereço no cadastro está correto.',cTitulo)
			Loop
		Endif

		TTRB->(DbGoTop())
		While !TTRB->(EOF())
			If !Empty(TTRB->OK)
				nK++
			EndIf
				TTRB->(DbSkip())
        EndDo
        if nK = 0 
        	if  ret
        		msginfo("Nenhum produto foi selecionado, operação abortada")
        		ret := .F.
        		loop           	
        	else
        		loop           	
        	endif
        endif
        		
		// Copiar o arquivo do servidor para o temporário do usuário do windows.
		CpyS2T( cOrigem, cTempPath, .T.)
		Sleep(500)
		
		// Formar o endereço para onde foi copiado template word no temporário do usuário.
		cTemplate := cTempPath + SubStr( cOrigem, RAt( '\',cOrigem )+1 )
		
		// Verifcar até cinco vezes se o template foi copiado.
		While ((.NOT. lCopy) .And. (nCheck <= 5))
			If File( cTemplate )
				lCopy := .T.
			Else
				nCheck++
				CpyS2T( cOrigem, cTempPath, .T. )
				Sleep(500)
			Endif
		End
		
		// Se conseguiu copiar o arquivo, segue com o processamento.
		If lCopy
			// Dividir o nome do arquivo e a extensão do arquivo.
			SplitPath( cTemplate, , , @cNomeArq, @cExtArq )
			
			// Pesquisar no banco de conhecimento a próxima versão DOC.
			cVerDOC := A320Knowledge( cNomeArq + '_' + cChave, '.DOC' )
			
			// Pesquisar no banco de conhecimento a próxima versão PDF.
			cVerPDF := A320Knowledge( cNomeArq + '_' + cChave, '.PDF' )
			
			// Elaborar o nome completo do arquivo compatível com o registro no banco de conhecimento.
			cSaidaDOC := SubStr( cTemplate, 1, RAt( '.', cTemplate )-1 ) + '_' + cChave + '_v' + cVerDOC + '.doc'
			cSaidaPDF := SubStr( cTemplate, 1, RAt( '.', cTemplate )-1 ) + '_' + cChave + '_v' + cVerPDF + '.pdf'
			
			// Este arquivo template em questão, tem macro VBA?
			lMacro := .NOT. Empty( aFiles[ nI, 3 ] )
			
			// Criar o link com o apliativo.
			oWord	:= OLE_CreateLink()
			
	      // Inibir o aplicativo em execução.
			OLE_SetProperty( oWord, '206', .F. )

			// Abrir um novo arquivo.
			OLE_NewFile( oWord , cTemplate )
			
			OLE_SetDocumentVar( oWord, 'PRO_DATABASE', Dtoc( dDataBase ) )

			// Atualizar a variáve de número de versão.
			OLE_SetDocumentVar( oWord, 'PRO_320VERSAO', cValToChar( nVersaoDocto ) )

			nK := 0
			
			TTRB->(DbGoTop())
			While !TTRB->(EOF())
			    
				If !Empty(TTRB->OK)
					//Incrementa contador
					nK++
					
					OLE_SetDocumentVar( oWord, 'PRO_UB_ITEM' 		+ LTrim( Str( nK ) ), PadL(lTrim(Str(nK)),2,"0"))
					OLE_SetDocumentVar( oWord, 'PRO_UB_PRODUTO' 	+ LTrim( Str( nK ) ), TTRB->PRODUTO 	)
					OLE_SetDocumentVar( oWord, 'PRO_B1_DESC' 		+ LTrim( Str( nK ) ), TTRB->DESCRICAO	)
					OLE_SetDocumentVar( oWord, 'PRO_B1_UM' 			+ LTrim( Str( nK ) ), TTRB->UM			)
					OLE_SetDocumentVar( oWord, 'PRO_UB_QUANT' 		+ LTrim( Str( nK ) ), StrTran(StrTran(lTrim(Transform(TTRB->QUANTIDADE	,"@E 999,999,999")), '.', '' ), ',', '.' ) )
					OLE_SetDocumentVar( oWord, 'PRO_UB_VRUNIT' 		+ LTrim( Str( nK ) ), StrTran(StrTran(lTrim(Transform(TTRB->UNITARIO	,"@E 999,999,999.99")), '.', '' ), ',', '.' ) )
					OLE_SetDocumentVar( oWord, 'PRO_UB_VLRITEM' 	+ LTrim( Str( nK ) ), StrTran(StrTran(lTrim(Transform(TTRB->TOTAL		,"@E 999,999,999.99")), '.', '' ), ',', '.' ) )
				
					//Armazena o valor total
					n321VlTotal += TTRB->TOTAL
				EndIf
				
				TTRB->(DbSkip())
            EndDo
         // Atualiza a variável com a quantidade de itens de produto da proposta.
			If lMacro .And. Len( aSUD_ITEM ) > 0
				n321QtItens := nK
				OLE_SetDocumentVar( oWord, 'PRO_320QTITENS', cValToChar( n321QtItens ) )
			Endif
            
            // Descarregar os dados dos campos do Protheus no Word.
			For nJ := 1 To Len( aCpos )
				If !('B1_' $ aCpos[ nJ, 1 ]) .And. !('UB_' $ aCpos[ nJ, 1 ]) .And. !('UA_' $ aCpos[ nJ, 1 ])
					// Somente para campos que não fazem parte do alias SUD.
					OLE_SetDocumentVar( oWord, aCpos[ nJ, 1 ], aCpos[ nJ, 5 ] )
				Elseif "PRO_UA_NOME" == aCpos[ nJ, 1 ]
					//Passo a informacao do cliente conforme origem
					(SUC->UC_ENTIDAD)->(DbSetOrder(1))
					If (SUC->UC_ENTIDAD)->(DbSeek(xFilial(SUC->UC_ENTIDAD)+Substr(SUC->UC_CHAVE,1,6)))
						//Renato Ruy - 08/08/2016
						//Caso a origem seja diferente de SA1, obriga o usuario a gerar o cliente
						/*
						//Seta Descrição através da origem
						If SUC->UC_ENTIDAD == "PAB"
							OLE_SetDocumentVar( oWord, aCpos[ nJ, 1 ], PAB->PAB_EMPRESA)
						ElseIf SUC->UC_ENTIDAD == "SZT"
							OLE_SetDocumentVar( oWord, aCpos[ nJ, 1 ], SZT->ZT_EMPRESA )
						ElseIf SUC->UC_ENTIDAD == "SZX"
							OLE_SetDocumentVar( oWord, aCpos[ nJ, 1 ], SZX->ZX_DSRAZAO )
						ElseIf SUC->UC_ENTIDAD == "SA1"
							OLE_SetDocumentVar( oWord, aCpos[ nJ, 1 ], SA1->A1_NOME	)
						ElseIf SUC->UC_ENTIDAD == "SUS"
							OLE_SetDocumentVar( oWord, aCpos[ nJ, 1 ], SUS->US_NOME	)
						ElseIf SUC->UC_ENTIDAD == "ACH"
							OLE_SetDocumentVar( oWord, aCpos[ nJ, 1 ], ACH->ACH_RAZAO	)
						EndIf
						*/
						
						If SUC->UC_ENTIDAD == "SA1"
							OLE_SetDocumentVar( oWord, aCpos[ nJ, 1 ], SA1->A1_NOME	)
							OLE_SetDocumentVar( oWord, "PRO_UA_CLIENTE", SUC->UC_CHAVE	)
							OLE_SetDocumentVar( oWord, "PRO_UA_NUM"	   , SUC->UC_CODIGO	)
						Else
							//Armazena cnpj da entidade atual.
							cCnpj := CSFA320V(SUC->UC_ENTIDAD,SUC->UC_CHAVE)
							
							If Empty(cCnpj)
								//Abre a rotina para criação do cliente
								U_CSFA112(oGride)
								
								//Armazena cnpj da entidade atual.
								cCnpj := CSFA320V(SUC->UC_ENTIDAD,SUC->UC_CHAVE) 
							EndIf
							
							SA1->(DbSetOrder(3))
							If SA1->(DbSeek(xFilial("SA1")+cCnpj)) .And. (!Empty(cCnpj) .Or. SUC->UC_ENTIDAD == "SA1")
								If Empty(SUC->UC_XDFPROP) .And. Empty(SUC->UC_XHFPROP) .And. !Empty(SUC->UC_XDIPROP) .And. !Empty(SUC->UC_XHIPROP)  
									RecLock("SUC",.F.)
										SUC->UC_XDFPROP := Date()
										SUC->UC_XHFPROP := Time()
									SUC->(MsUnLock())
								EndIf
								
								OLE_SetDocumentVar( oWord ,aCpos[ nJ, 1 ]   ,SA1->A1_NOME	)
								OLE_SetDocumentVar( oWord ,"PRO_UA_CLIENTE" ,SA1->A1_COD	)
								OLE_SetDocumentVar( oWord ,"PRO_UA_NUM"	  ,SUC->UC_CODIGO	)
							Else
								MsgInfo("O cliente não foi criado e o processo será cancelado!")
								Return .F.
							EndIf
							
						Endif
						
					EndIf
				EndIf
			Next nJ
		
			// Caso haja outro documento para mesma oportunidade que precise 
			// descarregar os produtos, é preciso reiniciar a variável.
			lUnLoad := .F.
						
			// Imprimir o valor total dos produtos.
			OLE_SetDocumentVar( oWord, 'PRO_UB_PRCTAB', Str(n321VlTotal) )
			
			// Imprimir o valor total dos descontos.
			OLE_SetDocumentVar( oWord, 'PRO_UB_VALDESC', "0" )
			
			// Imprimir o valor total da proposta.
			OLE_SetDocumentVar( oWord, 'PRO_320VLTOTAL', LTrim( TransForm( n321VlTotal, '@E 999,999,999.99' ) ) )
			
			// Imprimir o valor total da proposta por extenso.
			c321VlExten := Extenso( n321VlTotal )
			OLE_SetDocumentVar( oWord, 'PRO_320VLEXTEN', c321VlExten )
			
			c321VlExten := ''
			n321VlTotal := 0

			// Se possuir macro e realmente houver dados de produtos, executar a macro.
	   	If lMacro .And. ( nK > 0 )
	   		OLE_ExecuteMacro( oWord, aFiles[ nI, 3 ] )
	   	Endif
	   	
	   	// Atualizar campos.
	      OLE_UpDateFields( oWord )
	      
	      // Inibir o aplicativo Ms-Word em execução.
			OLE_SetProperty( oWord, '206', .F. )
			
			// Salvar o arquivo no formato DOC.
			OLE_SaveAsFile( oWord, cSaidaDOC )
			Sleep(500)

			// Abrir o arquivo no formato DOC.
			OLE_OpenFile( oWord, cSaidaDOC )
			Sleep(500)
			
			// Salvar o arquivo no formato PDF.
			OLE_SaveAsFile( oWord, cSaidaPDF, /*cPassword*/, /*cWritePassword*/, lReadOnly, cFormat)
			Sleep(500)
			
			// Fechar o arquivo.
			OLE_CloseFile( oWord )
			
			// Desfazer o link.
			OLE_CloseLink( oWord )

			// Apagar o arquivo template.
			FErase( cTemplate )

			// Anexar o arquivo no banco de conhecimento do Televendas.
			A320Anexar( cSaidaPDF, xFilial("SUC")+cChave, aFiles[ nI, 1 ], 'SUC', .T. )
			
			aAdd( aFileA321 , cSaidaPDF )
			
			// Incrementar no contador quantas vezes gerou a proposta
			//If SUC->UC_CODIGO <> cChave
			//	SUA->( dbSetOrder( 1 ) )
			//	SUA->( MsSeek( xFilial( 'SUC' ) + cChave ) )
			//Endif
			//SUA->( RecLock( 'SUA', .F. ) )
			//SUA->UA_QTDPROP := Val( Soma1( Str( SUA->UA_QTDPROP, 2, 0 ) ) )
			//SUA->( MsUnLock() )
			
			// É preciso sempre gerar e anexar o arquivo PDF e por fim abri-lo, ou seja, nunca apagar do temporário.
			// Quando o usuário tem permissão de gerar word, deve-se também gerar e anexar o pdf, porém abrir o word.
			If lMsWord
				ShellExecute( 'Open', cSaidaDOC, '', cTempPath, 1 )
			Else
				FErase( cSaidaDOC )
				Sleep(500)
				ShellExecute( 'Open', cSaidaPDF, '', cTempPath, 1 )
			Endif
		Else
			MsgAlert('Não foi possível copiar o arquivo template do servidor para a estação, por isso não será possível gerar o documento proposta (doc/pdf).',cTitulo)
			Exit
		Endif
		lCopy := .F.
		nCheck := 0
	Next nI
Return ret

Static Function CSFA320P(aSUD_ITEM)
    
	Local _stru   := {}
	Local aCores  := {}
	Local aCpoBro := {}
	Local lInverte:= .F.
	Local nP := 0
	Private cMark := GetMark()
	Private oTela := MSDialog():New(1,1,290,800,'Produtos da Proposta',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	Private oMark

	//Renato Ruy - 21/07/2016
	//Possibilitar ao usuario selecionar, incluir e excluir produtos
	
	//Cria um arquivo de Apoio
	AADD(_stru,{"OK"     	,"C"	,2		,0		})
	AADD(_stru,{"ORIGEM" 	,"C"	,6		,0		})
	AADD(_stru,{"ITEM" 	 	,"C"	,2		,0		})
	AADD(_stru,{"PRODUTO"	,"C"	,50		,0		})
	AADD(_stru,{"DESCRICAO"	,"C"	,100	,0		})
	AADD(_stru,{"UM" 		,"C"	,9		,0		})
	AADD(_stru,{"QUANTIDADE","N"	,15		,2		})
	AADD(_stru,{"UNITARIO"	,"N"	,15		,2		})
	AADD(_stru,{"TOTAL"	 	,"N"	,15		,2		})
	
	If Select("TTRB") > 0
		DbSelectArea("TTRB")
		TTRB->(DbCloseArea())
	EndIf 
	
	cArq:=Criatrab(_stru,.T.)
	
	DBUSEAREA(.t.,,carq,"TTRB")
	
	For nP:= 1 to Len(aSUD_ITEM)
		RecLock("TTRB",.T.)
			TTRB->OK 		:= ""
			TTRB->ORIGEM	:= "AUTOMA"
			TTRB->ITEM		:= Padl(AllTrim(Str(nP)),2,"0")
			TTRB->PRODUTO 	:= aSUD_ITEM[nP,2]
			TTRB->DESCRICAO	:= aSUD_ITEM[nP,3]
			TTRB->UM		:= aSUD_ITEM[nP,4]
			TTRB->QUANTIDADE:= Val(StrTran(Strtran(aSUD_ITEM[nP,5],".",""),",","."))
			TTRB->UNITARIO	:= Val(StrTran(Strtran(aSUD_ITEM[nP,6],".",""),",","."))
			TTRB->TOTAL		:= TTRB->QUANTIDADE*TTRB->UNITARIO
		TTRB->(MsUnlock())
	Next
	
	//Legenda
	aCores := {}
	aAdd(aCores,{"TTRB->ORIGEM == 'MANUAL'","BR_VERMELHO"})
	aAdd(aCores,{"TTRB->ORIGEM == 'ALTERA'","BR_AMARELO"})
	aAdd(aCores,{"TTRB->ORIGEM == 'AUTOMA'","BR_VERDE"	 })
	
	//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
	aCpoBro	:= {{ "OK"			,, ""	            ,"@!"				},;
				{ "ITEM"		,, "Item"	        ,"@!"				},;
				{ "PRODUTO"		,, "Produto"        ,"@!"				},;
				{ "DESCRICAO"	,, "Descrição"      ,"@!"				},;
				{ "UM"			,, "UM"     	    ,"@!"				},;
				{ "QUANTIDADE"	,, "Quantidade"     ,"@E 999,999,999.99"},;
				{ "UNITARIO"	,, "Vlr.Unitário"   ,"@E 999,999,999.99"},;
				{ "TOTAL"		,, "Vlr.Total"		,"@E 999,999,999.99"}}

	DbSelectArea("TTRB")
	DbGotop()
	
	//Cria a MsSelect
	oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{1,1,120,400},,,,,aCores)
	oMark:bMark := {| | Marca()}
	
	//Cria botoes
	@ 122,001 BUTTON "Incluir"  SIZE 40,20 PIXEL OF oTela ACTION (A320INC())
	@ 122,051 BUTTON "Alterar"  SIZE 40,20 PIXEL OF oTela ACTION (A320ALT())
	@ 122,359 BUTTON "Confirmar" SIZE 40,20 PIXEL OF oTela ACTION (oTela:End())
	
	//Exibe a Dialog
	oTela:Activate(,,,.T.)
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Marca  	º Autor ³ Renato Ruy         º Data ³  21/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao executada ao Marcar/Desmarcar um registro.		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Função de usuário.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Marca()

RecLock("TTRB",.F.)

If Marked("OK")
	TTRB->OK := cMark
Else
	TTRB->OK := ""
Endif

MSUNLOCK()
oMark:oBrowse:Refresh()

Return()   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A320INC  	º Autor ³ Renato Ruy         º Data ³  21/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para incluir produto para proposta.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Função de usuário.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A320INC()
	Local aPar 	:= {}
	Local aRet 	:= {}
	Local cItem := ""
	
	TTRB->(DbGoTop())
	While !TTRB->(EOF())
		cItem := TTRB->ITEM
		TTRB->(DbSkip())	
	Enddo

	AAdd( aPar,{ 1, 'Produto'		,Space(40)	,''					    ,'!Empty(mv_par01) .And. ExistCpo("SB1",mv_par01)','SB1','',120,.F.})
	AAdd( aPar,{ 1, 'Quantidade'	,0			,'@E 999,999,999.99'	,'mv_par02>0'									  ,'','',120,.F.})
	AAdd( aPar,{ 1, 'Valor Unitário',0			,'@E 999,999,999.99'	,'mv_par03>0'									  ,'','',120,.F.})
	If ParamBox( aPar,'Editar parâmetro', @aRet )
		Reclock("TTRB",.T.)
			TTRB->ITEM		:= Soma1(cItem)
			TTRB->ORIGEM	:= "MANUAL"
			TTRB->PRODUTO	:= aRet[1]
			TTRB->DESCRICAO	:= Posicione("SB1",1,xFilial("SB1")+aRet[1],"B1_DESC")
			TTRB->UM		:= Posicione("SB1",1,xFilial("SB1")+aRet[1],"B1_UM")
			TTRB->QUANTIDADE:= aRet[2]
			TTRB->UNITARIO	:= aRet[3]
			TTRB->TOTAL 	:= aRet[2]*aRet[3]
		TTRB->(MsUnlock())
		
		TTRB->(DbGoTop())
		oMark:oBrowse:Refresh()
	EndIf


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A320ALT  	º Autor ³ Renato Ruy         º Data ³  21/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para alterar valor dos produtos para proposta.	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Função de usuário.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A320ALT()
	Local aPar 	:= {}
	Local aRet 	:= {}
	Local cItem := ""
	
	TTRB->(DbGoTop())
	While !TTRB->(EOF())
		cItem := TTRB->ITEM
		TTRB->(DbSkip())	
	Enddo

	AAdd( aPar,{ 1, 'Quantidade'	,0			,'@E 999,999,999.99'	,'','','',120,.F.})
	AAdd( aPar,{ 1, 'Valor Unitário',0			,'@E 999,999,999.99'	,'','','',120,.F.})
	If ParamBox( aPar,'Editar parâmetro', @aRet )
		TTRB->(DbGoTop())
		While !TTRB->(Eof())  
			If !Empty(TTRB->OK)
				Reclock("TTRB",.F.)
					TTRB->ORIGEM	:= "ALTERA"
					TTRB->QUANTIDADE:= aRet[1]
					TTRB->UNITARIO	:= aRet[2]
					TTRB->TOTAL 	:= aRet[1]*aRet[2]
				TTRB->(MsUnlock())
			EndIf
			TTRB->(DbSkip())
		Enddo
		
		TTRB->(DbGoTop())
		oMark:oBrowse:Refresh()
	EndIf


Return

//Renato Ruy - 08/08/16
//Armazena dados referente aos cnpj's da empresa
Static Function CSFA320V(cTabela,cSUChave)
Local cCnpj := ""

//Se posiciona na tabela.
(cTabela)->(DbSetOrder(1))
(cTabela)->(DbSeek(xFilial(cTabela)+cSUChave))


//Armazena o Cnpj atual.
If cTabela == "PAB"
	cCnpj := PAB->PAB_CNPJ
ElseIf cTabela == "SZT"
	cCnpj := SZT->ZT_CNPJ
ElseIf cTabela == "SZX"
	cCnpj := SZX->ZX_NRCNPJ
ElseIf cTabela == "SUS"
	cCnpj := SUS->US_CGC
ElseIf cTabela == "ACH"
	cCnpj := ACH->ACH_CGC
EndIf

Return cCnpj