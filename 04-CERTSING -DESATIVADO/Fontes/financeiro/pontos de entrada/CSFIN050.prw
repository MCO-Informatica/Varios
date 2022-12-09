#Include 'Protheus.ch'
Static nREGISTROS := 0
//+-------------------------------------------------------------------+
//| Rotina | CSFIN050 | Autor | Rafael Beghini | Data | 21.09.2018 
//+-------------------------------------------------------------------+
//| Descr. | Relatório de baixas por ChargeBak
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSFIN050()
    Local aSAY  := {'Rotina para gerar relatório em formato XML com os pedidos validados e não emitidos.','','','Clique em OK para prosseguir...'}
    Local aBTN  := {}
    Local aPAR  := {}
    Local nOpc  := 0

    Private aRET := {}
    Private cTRB := ''
    Private cTitulo := '[CSFIN050] - Ped. Validados e não Emitidos'

    aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch(cTitulo, aSAY, aBTN )

    IF nOpc == 1
        aAdd( aPAR, {9, "Informe o período da validação",200,7,.T.})
	    aAdd( aPAR, {1, "Data de"	 , Ctod(Space(8)), "","",""   ,"",0,.F.})
	    aAdd( aPAR, {1, "Data ate"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})

        IF ParamBox(aPAR,cTitulo,@aRET)
            A010Proc( aRET )
        Else
            MsgInfo('Processo cancelado',cTitulo)
        EndIF
    EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Proc | Autor | Rafael Beghini | Data | 21.09.2018 
//+-------------------------------------------------------------------+
//| Descr. | Apresenta a tela de processamento
//+-------------------------------------------------------------------+
Static Function A010Proc( aRET )
    Local oDlg   := Nil
    Local oSay   := Nil
    Local oMeter := Nil
    Local nMeter := 0

    Define Dialog oDlg Title cTitulo From 0,0 To 70,380 Pixel
        @05,05  Say oSay Prompt "Aguarde, montando a query conforme parâmetros informados." Of oDlg Pixel Colors CLR_RED,CLR_WHITE Size 185,20
        @15,05  Meter oMeter Var nMeter Pixel Size 160,10 Of oDlg
        @13,170 BITMAP Resource "PCOIMG32.PNG" SIZE 015,015 OF oDlg NOBORDER PIXEL
    Activate Dialog oDlg Centered On Init ( IIF( A010Qry( aRET ), A010Imp(oDlg, oSay, oMeter), NIL ), oDlg:End() )
    
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Qry | Autor | Rafael Beghini | Data | 21.09.2018 
//+-------------------------------------------------------------------+
//| Descr. | Monta a query conforme parâmetros
//+-------------------------------------------------------------------+
Static Function A010Qry( aRET )
    Local cSQL   := ''
    Local cCount := ''
    Local lRet   := .T.

    cSQL += "SELECT C5_NUM, " + CRLF
    cSQL += "       C5_XNPSITE, " + CRLF
    cSQL += "       C5_CHVBPAG, " + CRLF
    cSQL += "       C5_CLIENTE, " + CRLF
    cSQL += "       TRIM(A1_NOME) AS RAZAO, " + CRLF
    cSQL += "       Z5_DATPED, " + CRLF
    cSQL += "       Z5_EMISSAO, " + CRLF
    cSQL += "       Z5_DATVAL, " + CRLF
    cSQL += "       Z5_VALOR, " + CRLF
    cSQL += "       Z5_STATUS " + CRLF
    cSQL += "FROM   " + RetSqlName('SZ5') + " Z5 " + CRLF
    cSQL += "       LEFT JOIN " + RetSqlName('SC5') + " C5 " + CRLF
    cSQL += "              ON C5_FILIAL = Z5_FILIAL " + CRLF
    cSQL += "                 AND C5_CHVBPAG = Z5_PEDGAR " + CRLF
    cSQL += "                 AND C5.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "       LEFT JOIN " + RetSqlName('SA1') + " A1 " + CRLF
    cSQL += "              ON A1_FILIAL = '" + xFilial('SA1') + "' " + CRLF
    cSQL += "                 AND A1_COD = C5_CLIENTE " + CRLF
    cSQL += "                 AND A1_LOJA = C5_LOJACLI " + CRLF
    cSQL += "                 AND A1.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "WHERE  Z5.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "       AND Z5_FILIAL = '" + xFilial('SZ5') + "' " + CRLF
    cSQL += "       AND Z5_DATVAL >= '" + dToS( aRET[ 2 ] ) + "' " + CRLF
    cSQL += "       AND Z5_DATVAL <= '" + dToS( aRET[ 3 ] ) + "' " + CRLF
    cSQL += "       AND Z5_DATEMIS = ' ' " + CRLF
    cSQL += "       AND Z5_PEDGANT = ' ' " + CRLF
    cSQL += "       AND Z5_VALOR > 0 " + CRLF

    cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	cCount := ' SELECT COUNT(*) COUNT FROM ( ' + cSQL + ' ) QUERY '
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCount),cTRB,.F.,.T.)
	nREGISTROS := (cTRB)->COUNT
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

    TcSetField( cTRB, "Z5_DATPED"   , "D", 8 )
    TcSetField( cTRB, "Z5_EMISSAO"  , "D", 8 )
    TcSetField( cTRB, "Z5_DATVAL"   , "D", 8 )
    TcSetField( cTRB, "Z5_VALOR"    , "N", 15, 2 )

    IF (cTRB)->( EOF() )
        lRet := .F.    
        (cTRB)->( dbCloseArea() )
	    FErase( cTRB + GetDBExtension() )
        MsgInfo('Não há dados para extração conforme parâmetros informados.',cTitulo)
    EndIF
Return( lRet )
//+-------------------------------------------------------------------+
//| Rotina | CSFIN040 | Autor | Rafael Beghini | Data | 12.07.2018 
//+-------------------------------------------------------------------+
//| Descr. | Gera o relatório no formato .XML
//+-------------------------------------------------------------------+
Static Function A010Imp(oDlg, oSay, oMeter)
    Local nSeconds    := 0
    Local nCount      := 0
    Local nLastUpdate := 0
    Local cWorkSheet  := 'Pedidos'
	Local cTable      := 'Pedidos validados e não emitidos - período [' + dTOC( aRET[ 2 ] ) + ' - ' + dTOC( aRET[ 3 ] ) + ']'
	Local cPath       := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile   := cPath + 'Validados_nao_emitidos' + dTos(Date()) + ".XML"
	Local oExcel      := FWMSEXCEL():New() //Método para geração em XML
    Local aStatus     := Array( 4 )
    Local cStatus     := ''
    Local cPolitica   := ''

    aStatus[ 1 ] := '1Aguardando validação'
    aStatus[ 2 ] := '2Aguardando aprovação'
    aStatus[ 3 ] := '3Pronto para emitir'
    aStatus[ 4 ] := '4Rejeitado'

    oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >           , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido Protheus"     , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido Site"         , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido GAR"          , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Cliente"             , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Razão Social"        , 1     , 1      , .F. )
    //oExcel:AddColumn( cWorkSheet, cTable, "Data do pedido"      , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data da emissão"     , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data da validação"   , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor Pedido"        , 1     , 3      , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data do crédito"     , 1     , 4      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Status do pedido"    , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Política Garantia"   , 1     , 1      , .F. )
	
    //nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada

    oMeter:SetTotal(nREGISTROS)
    nSeconds := Seconds()

    oSay:SetText("Aguarde, montando o relatório. Total de registro(s): " + AllTrim( Str(nREGISTROS) ) )

    A010UseGTL()
    SE1->( dbSetOrder(30) )

    (cTRB)->( dbGotop() )
    While .NOT. (cTRB)->( EOF() )
        nCount++
        IF (Seconds() - nLastUpdate) > 1 // Se passou 1 segundo desde a última atualização da tela
            oMeter:Set(nCount)
            oDlg:CommitControls() // Para atualizar a tela e o usuário receber o feedback

            nLastUpdate := Seconds()
        EndIf

        IF Empty( (cTRB)->C5_NUM )
            (cTRB)->( dbSkip() )
            Loop
        EndIF
        
        IF SE1->( dbSeek( xFilial('SE1') + (cTRB)->C5_NUM ) )
            dDtCredito := SE1->E1_EMISSAO
        Else
            dDtCredito := CtoD('//')
        EndIF

        nPos := aScan( aStatus, {|X| Left(X,1) == (cTRB)->Z5_STATUS } )
        IF nPos > 0
            cStatus := Substr(aStatus[ nPos ],2)
        Else
            cStatus := ''
        EndIF

        IF GTLEGADO->( dbSeek( 'S' + (cTRB)->C5_CHVBPAG ) )
            cPolitica := 'Software'
        Else
            cPolitica := ' '
        EndIF

        oExcel:AddRow( cWorkSheet, cTable, { (cTRB)->C5_NUM,;
                                                (cTRB)->C5_XNPSITE,;
                                                (cTRB)->C5_CHVBPAG,;
                                                (cTRB)->C5_CLIENTE,;
                                                (cTRB)->RAZAO,;
                                                (cTRB)->Z5_EMISSAO,;
                                                (cTRB)->Z5_DATVAL,;
                                                (cTRB)->Z5_VALOR,;
                                                dDtCredito,;
                                                cStatus,;
                                                cPolitica } )
        (cTRB)->( dbSkip() )
    End

    (cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )

    oMeter:Set(nCount) // Efetua uma atualização final para garantir que o usuário veja o resultado do processamento
    oDlg:CommitControls() // Para atualizar a tela e o usuário receber o feedback
    
    oExcel:Activate() //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
	
	ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela após salvar
Return

//--------------------------------------------------------------------------
// Rotina | A030UseGTL  | Autor | Rafael Beghini       | Data | 15.05.2018
//--------------------------------------------------------------------------
// Descr. | Rotina para abrir a tabela GTLOG e seus índices.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A010UseGTL()
	USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException( "Falha ao abrir tabela GTLEGADO - SHARED" )
	Endif
	dbSetIndex("GTLEGADO01")
	dbSelectArea("GTLEGADO")
	dbSetOrder(1)
Return