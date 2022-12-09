//---------------------------------------------------------------------------------
// Rotina | CSFA840    | Autor | Robson Gonçalves               | Data | 05.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina para extrair os registros dos documentos de saída. 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
#Include 'Protheus.Ch'
User Function CSFA840
	Local aButton := {}
	Local aSay := {}

	Local nOpcao := 0
	
	Private cCadastro := 'Extrair dados do documento de saída'
	Private lQuery := .F.
	
	AAdd( aSay, 'Esta rotina tem por objetivo extrair os dados dos documentos de saída conforme os' )
	AAdd( aSay, 'parâmetros informados.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	SetKey( VK_F12 , {|| lQuery := MsgYesNo('Exportar a string da query?',cCadastro ) } )
	
	FormBatch( cCadastro, aSay, aButton )
   
   SetKey( VK_F12 , NIL )
   
	If nOpcao==1
		A840Param()
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A840Param  | Autor | Robson Gonçalves               | Data | 05.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina para solicitar ao usuário as informações por meio de parâmetros
//        | para o processamento.
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A840Param()
	Local aParamBox := {}
	Local aPergRet := {}
	Local cFile := ''
	
	CriarSXB()
		
	AAdd(aParamBox,{1,'Filial de' ,Space(Len(SD2->D2_FILIAL)),'','','SM0_01','',40,.F.})
	AAdd(aParamBox,{1,'Filial até',Space(Len(SD2->D2_FILIAL)),'','','SM0_01','',40,.T.})

	AAdd(aParamBox,{1,'Emissão de',Ctod(Space(8)),'','','','',50,.F.})
	AAdd(aParamBox,{1,'Emissão de',Ctod(Space(8)),'','','','',50,.T.})
	
	AAdd(aParamBox,{1,'Produtos'      ,Space(255),'','','XB840P','',118,.F.})
	AAdd(aParamBox,{1,'CFOPs'         ,Space(255),'','','XB840C','',118,.F.})
	AAdd(aParamBox,{1,'Tipos de saída',Space(255),'','','XB840T','',118,.F.})
	
	If ParamBox(aParamBox,'Parâmetros',aPergRet,,,,,,,,.T.,.T.)
		cFile := CriaTrab( NIL, .F. ) + '.xml'
		While File( cFile )
			cFile := CriaTrab( NIL, .F. ) + '.xml'
		End
		Processa( {|lEnd| A840Process( cFile, @lEnd ) }, cCadastro,'Aguarde, processando...', .T. )
   Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A840Process| Autor | Robson Gonçalves               | Data | 05.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina de processamento principal da extração de dados.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A840Process( cFile, lEnd )
	Local cParam := ''
	Local cDir := ''
	Local cDirTmp := ''
	Local cSQL := ''
	Local cTable := cCadastro
	Local cTRB := GetNextAlias()
	Local cWorkSheet := 'Documento Fiscal de Saída'

	Local oFwMsEx	
	Local oExcelApp	
	
	ProcRegua( 0 )
	
	cSQL := "SELECT D2_FILIAL, "
	cSQL += "       D2_ITEM, "
	cSQL += "       D2_COD, "
	cSQL += "       D2_UM, "
	cSQL += "       D2_QUANT, "
	cSQL += "       D2_PRCVEN, "
	cSQL += "       D2_TOTAL, "
	cSQL += "       D2_VALICM, "
	cSQL += "       D2_TES, "
	cSQL += "       D2_CF, "
	cSQL += "       D2_PICM, "
	cSQL += "       D2_DOC, "
	cSQL += "       D2_SERIE, "
	cSQL += "       D2_EMISSAO, "
	cSQL += "       D2_EST, "
	cSQL += "       D2_BASEICM, "
	cSQL += "       A1_INSCR "
	cSQL += "FROM   "+RetSqlName("SD2")+" SD2 "
	
	cSQL += "	   INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cSQL += "	           ON A1_FILIAL = "+ValToSql(xFilial("SA1"))+" "
	cSQL += "	              AND A1_COD = D2_CLIENTE "
	cSQL += "	              AND A1_LOJA = D2_LOJA "
	cSQL += "	              AND SA1.D_E_L_E_T_ = ' ' "
	
	cSQL += "WHERE  D2_FILIAL >= "+ValToSql(MV_PAR01)+" "
	cSQL += "       AND D2_FILIAL <= "+ValToSql(MV_PAR02)+" "
	cSQL += "       AND D2_EMISSAO >= "+ValToSql(MV_PAR03)+" "
	cSQL += "       AND D2_EMISSAO <= "+ValToSql(MV_PAR04)+" "
	
	If .NOT. Empty(MV_PAR05)
		If AllTrim(MV_PAR05)<>"*"
			cParam := FormatIn( AllTrim( MV_PAR05 ), ';' )
			cSQL += "       AND D2_COD IN " + cParam + " "
		Endif
	Endif
	
	If .NOT. Empty(MV_PAR06)
		If AllTrim(MV_PAR06)<>"*"
			cParam := FormatIn( AllTrim( MV_PAR06 ), ';' )
			cSQL += "       AND D2_CF IN " + cParam + " "
		Endif
	Endif
	
	If .NOT. Empty(MV_PAR07)
		If AllTrim(MV_PAR07)<>"*"
			cParam := FormatIn( AllTrim( MV_PAR07 ), ';' )
			cSQL += "       AND D2_TES IN " + cParam + " "
		Endif
	Endif
	
	cSQL += "       AND SD2.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY D2_FILIAL, "
	cSQL += "         D2_DOC, "
	cSQL += "         D2_SERIE, "
	cSQL += "         D2_ITEM "
	
	cSQL := ChangeQuery( cSQL )
	
	If lQuery 
		CopyToClipBoard( cSQL )
		MsgInfo( cSQL, 'CTRL+C para copiar a query' )
		If .NOT. MsgYesNo( 'Continuar com o processamento?', cCadastro )
			Return
		Endif
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.T.,.T.)

	If (cTRB)->( BOF() .And. EOF() )
		MsgInfo('Não foi possível localizar dados com os parâmetros informados.',cCadastro)
		(cTRB)->( dbCloseArea() )
	Else
		oFwMsEx := FWMsExcel():New()
		
	   oFwMsEx:AddWorkSheet( cWorkSheet )
	   oFwMsEx:AddTable( cWorkSheet, cTable )	
	
		// cWorkSheet -> Nome da planilha
		// cTable -----> Título da tabela
		// cColumn ----> Titulo da tabela que será adicionada
		// nAlign -----> Alinhamento da coluna ( 1-Left,2-Center,3-Right )
		// nFormat ----> Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
		// lTotal -----> Indica se a coluna deve ser totalizada
		
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'FILIAL'   , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'ITEM NF'  , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PRODUTO'  , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'UN MED'   , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'QTDE'     , 3, 2 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'UNITÁRIO' , 3, 2 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'TOTAL'    , 3, 2 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'VL ICMS'  , 3, 2 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'TES'      , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'CFOP'     , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, '% ICMS'   , 3, 2 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DOCUMENTO', 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'SERIE'    , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'EMISSÃO'  , 2, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'UF'       , 2, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'BASE ICMS', 3, 2 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'CONTRIB.' , 1, 1 )
		
		While (cTRB)->( .NOT. EOF() ) .AND. .NOT. lEnd
			IncProc()
			
			oFwMsEx:AddRow( cWorkSheet, cTable, { (cTRB)->D2_FILIAL,;
			                                      (cTRB)->D2_ITEM,;
			                                      (cTRB)->D2_COD,;
			                                      (cTRB)->D2_UM,;
			                                      (cTRB)->D2_QUANT,;
			                                      (cTRB)->D2_PRCVEN,;
			                                      (cTRB)->D2_TOTAL,;
			                                      (cTRB)->D2_VALICM,;
			                                      (cTRB)->D2_TES,;
			                                      (cTRB)->D2_CF,;
			                                      (cTRB)->D2_PICM,;
			                                      (cTRB)->D2_DOC,;
			                                      (cTRB)->D2_SERIE,;
			                                      Dtoc(Stod((cTRB)->D2_EMISSAO)),;
			                                      (cTRB)->D2_EST,;
			                                      (cTRB)->D2_BASEICM,;
			                                      (cTRB)->A1_INSCR } )
			
			(cTRB)->( dbSkip() )
		End
		(cTRB)->( dbCloseArea() )
		
		oFwMsEx:Activate()
		cDirTmp := GetTempPath()
		cDir := GetSrvProfString('Startpath','')
	
		LjMsgRun( 'Gerando o arquivo, aguarde...', cCadastro, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
	
		If __CopyFile( cFile, cDirTmp + cFile )
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cFile )
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			Sleep(500)
		Else
			MsgInfo( 'Não foi possível copiar o arquivo para o diretório temporário do usuário.' )
		Endif
   Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A840Prod | Autor | Robson Gonçalves                 | Data | 07.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina de configuração para consultar produtos.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A840Prod()
	Local aHead := {'X','Produto','Descrição'}
	Local aOrdem := {'Produto','Descrição do produto'}
	
	Local cConteudo := ''
	Local cTitle := 'Pesquisar produto'

	cConteudo := BrowsePesq( 'SB1', cTitle, aOrdem, aHead )
Return( cConteudo )

//---------------------------------------------------------------------------------
// Rotina | A840CFOP | Autor | Robson Gonçalves                 | Data | 07.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina de configuração para consultar CFOP.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A840CFOP()
	Local aHead := {'X','Código','Descrição'}
	Local aOrdem := {'Código','Descrição'}
		
	Local cConteudo := ''
	Local cTitle := 'Pesquisar CFOP'

	cConteudo := BrowsePesq( 'SX513', cTitle, aOrdem, aHead )
Return( cConteudo )

//---------------------------------------------------------------------------------
// Rotina | A840TS | Autor | Robson Gonçalves                   | Data | 07.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina de configuração para consultar tipos de saída.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A840TS()
	Local aHead := {'X','Código','Texto padrão'}
	Local aOrdem := {'Código','Texto padrão'}
	
	Local cConteudo := ''
	Local cTitle := 'Pesquisar tipo de saída'

	cConteudo := BrowsePesq( 'SF4', cTitle, aOrdem, aHead )
Return( cConteudo )

//---------------------------------------------------------------------------------
// Rotina | BrowsePesq | Autor | Robson Gonçalves               | Data | 07.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina de consultar e marcar registros.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function BrowsePesq( cTabela, cTitle, aOrdem, aHead )
	Local oDlg
	Local oLbx
	Local oWnd 
	Local oMrk 
	Local oNoMrk
	
	Local oPanelAll
	Local oPanelBot
	Local oPanelTop
	
	Local oOrdem
	Local oSeek
	Local oPesq 
	
	Local nI := 0
	Local nOpc := 0
	Local nOrd := 1
	Local lMark := .F.
	
	Local cNomeCpo := ''
	Local cConteudo := ''
	Local cOrd := ''
	Local cSeek := Space(100)
	
	Local aDados := {}
	Local aButton := {}
	
	Private cTitulo := cTitle
	
	cNomeCpo := ReadVar()
	cConteudo := RTrim( &( ReadVar() ) )
	
	FwMsgRun(,{|| xGetDados(cTabela,lMark,cConteudo,@aDados)},,'Buscando os dados...')
	
	If Len( aDados ) > 0
		lMark := .T.
		oWnd := GetWndDefault()
		oMrk := LoadBitmap( GetResources(), 'LBOK' )
		oNoMrk := LoadBitmap( GetResources(), 'LBNO' )
		
		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 400,800 PIXEL
			oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelTop:Align := CONTROL_ALIGN_TOP
			
			@ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
			@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
			@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (Pesq2(nOrd,cSeek,@oLbx))
			
			oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT
			
			oLbx := TwBrowse():New(0,0,0,0,,aHead,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oLbx:Align := CONTROL_ALIGN_ALLCLIENT
			oLbx:SetArray( aDados )
			oLbx:bLine := bLine := {|| {Iif(aDados[oLbx:nAt,1],oMrk,oNoMrk),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3]}}
			oLbx:bLDblClick := {||  aDados[ oLbx:nAt, 1 ] := ! aDados[ oLbx:nAt, 1 ] }
			oLbx:bHeaderClick := {|| AEval( aDados, {|p| p[1] := lMark } ), lMark := !lMark, oLbx:Refresh() }

			oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelBot:Align := CONTROL_ALIGN_BOTTOM
			
			@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION (nOpc := 1, oDlg:End())
			@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
		ACTIVATE MSDIALOG oDlg CENTER
		If nOpc == 1
			cConteudo := ''
			For nI := 1 To Len( aDados )
				If aDados[ nI, 1 ]
					cConteudo += RTrim( aDados[ nI, 2 ] ) + ';'
				Endif
			Next nI
			cConteudo := Substr( cConteudo, 1, Len( cConteudo ) -1 )
			&( cNomeCpo ) := cConteudo
			If oWnd <> NIL
				GetdRefresh()
			Endif
		Endif
	Else
		MsgAlert( 'Dados não localizados', cTitulo )
	Endif
Return(cConteudo)

//---------------------------------------------------------------------------------
// Rotina | xGetDados | Autor | Robson Gonçalves                | Data | 07.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina para coletar os dados para serem consultados.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function xGetDados(cTabela,lMark,cConteudo,aDados)
	If cTabela == 'SB1'
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial('SB1')))
		While ! SB1->(EOF()) .And. SB1->B1_FILIAL==xFilial('SB1')
			lMark := SB1->B1_COD $ cConteudo
			SB1->(AAdd( aDados, { lMark, B1_COD, B1_DESC } ) )
			SB1->(dbSkip())
		End
	Elseif cTabela == 'SF4'
		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial('SF4')+'5'))
		While ! SF4->(EOF()) .And. SF4->F4_FILIAL==xFilial('SF4')
			lMark := SF4->F4_CODIGO $ cConteudo
			SF4->(AAdd( aDados, { lMark, F4_CODIGO, F4_TEXTO } ) )
			SF4->(dbSkip())
		End
	Else
		SX5->(dbSetOrder(1))
		SX5->(dbSeek(xFilial('SX5')+'13'+'5'))
		While ! SX5->(EOF()) .And. SX5->X5_FILIAL==xFilial('SX5') .AND. SX5->X5_TABELA == '13'
			lMark := SX5->X5_CHAVE $ cConteudo
			SX5->(AAdd( aDados, { lMark, X5_CHAVE, X5_DESCRI } ) )
			SX5->(dbSkip())
		End
	Endif	
Return

//---------------------------------------------------------------------------------
// Rotina | Pesq2 | Autor | Robson Gonçalves                    | Data | 07.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina para pesquisar os registros no Browse.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function Pesq2(nOrd,cSeek,oLbx)
	Local nP := 0
	Local nColPesq := 0
		
	If nOrd==1       ; nColPesq := 2
	Elseif nOrd == 2 ; nColPesq := 3
	Elseif nOrd == 3 ; nColPesq := 4
	Elseif nOrd == 4 ; nColPesq := 5
	Else
		MsgAlert('ATENÇÃO<br><br>Opção não disponível para pesquisa.','Pesquisar')
	Endif
	
	If nColPesq > 0
		nP := AScan( oLbx:aArray, {|p| Upper( AllTrim( cSeek ) ) $ Upper( AllTrim( p[ nColPesq ] ) ) } )	
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('ATENÇÃO<br><br>Informação não localizada.','Pesquisar')
		Endif
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | CriarSXB | Autor | Robson Gonçalves                 | Data | 07.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina para configurar a consulta SXB.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function CriarSXB()
	Local aSXB := {}
	
	AAdd(aSXB,{"XB840P","1","01","RE","Produto","Produto","Produto","SB1",""})
	AAdd(aSXB,{"XB840P","2","01","01","Produto","Produto","Produto","U_A840Prod()",""})
	AAdd(aSXB,{"XB840P","5","01","","","","","SB1->B1_COD",""})
	
	GoCreateXB( aSXB )
	
	aSXB := {}
	
	AAdd(aSXB,{"XB840C","1","01","RE","CFOP","CFOP","CFOP","SX5",""})
	AAdd(aSXB,{"XB840C","2","01","01","CFOP","CFOP","CFOP","U_A840CFOP()",""})
	AAdd(aSXB,{"XB840C","5","01","","","","","SX5->X5_CHAVE",""})
	
	GoCreateXB( aSXB )

	aSXB := {}
	
	AAdd(aSXB,{"XB840T","1","01","RE","Tipo de saída","Tipo de saída","Tipo de saída","SF4",""})
	AAdd(aSXB,{"XB840T","2","01","01","Tipo de saída","Tipo de saída","Tipo de saída","U_A840TS()",""})
	AAdd(aSXB,{"XB840T","5","01","","","","","SF4->F4_CODIGO",""})
	
	GoCreateXB( aSXB )
Return

//---------------------------------------------------------------------------------
// Rotina | GoCreateXB | Autor | Robson Gonçalves               | Data | 07.07.2017
//---------------------------------------------------------------------------------
// Descr. | Rotina para criar a consulta SXB.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function GoCreateXB( aSXB )
	Local aCpoSXB := {}
	
	Local cXB_ALIAS := aSXB[ 1, 1 ]
	
	Local nI := 0
	Local nJ := 0
	
	Local nTamSXB := 0
	
	SXB->( dbSetOrder( 1 ) )
	If .NOT. SXB->( dbSeek( cXB_ALIAS ) )
		nTamSXB := Len( SXB->XB_ALIAS )
		aCpoSXB := { "XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM","XB_WCONTEM" }
		
		SXB->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aSXB )
			If ! SXB->( dbSeek( PadR( aSXB[ nI, 1 ], nTamSXB ) + aSXB[ nI,2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
				SXB->( RecLock( 'SXB', .T. )) 
				For nJ := 1 To Len( aCpoSXB )
					SXB->( FieldPut( FieldPos( aCpoSXB[ nJ ] ), aSXB[ nI, nJ ] ) )
				Next nJ
				SXB->( MsUnLock() )
			Endif
		Next nI
	Endif
Return