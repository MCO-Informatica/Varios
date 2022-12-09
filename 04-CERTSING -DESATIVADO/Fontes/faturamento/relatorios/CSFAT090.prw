#Include 'Protheus.ch'
Static nREGISTROS := 0
//+-------------------------------------------------------------------+
//| Rotina | CSFAT090 | Autor | Rafael Beghini | Data | 30.01.2019 
//+-------------------------------------------------------------------+
//| Descr. | Relatório de vendas RemoteID
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSFAT090()
    Local aSAY  := {'Rotina para gerar relatório em formato XML com as vendas Remote ID.','','','Clique em OK para prosseguir...'}
    Local aBTN  := {}
    Local aPAR  := {}
    Local nOpc  := 0

    Private aRET := {}
    Private cTRB := ''
    Private cTitulo := '[CSFAT090] - Vendas Remote ID'

    aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch(cTitulo, aSAY, aBTN )

    IF nOpc == 1
        aAdd( aPAR, {9, "Informe o período de emissão (Venda do produto)",200,7,.T.})
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
//| Rotina | A010Proc | Autor | Rafael Beghini | Data | 30.01.2019 
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
//| Rotina | A010Qry | Autor | Rafael Beghini | Data | 30.01.2019 
//+-------------------------------------------------------------------+
//| Descr. | Monta a query conforme parâmetros
//+-------------------------------------------------------------------+
Static Function A010Qry( aRET )
    Local cSQL   := ''
    Local cCount := ''
    Local lRet   := .T.

    cSQL += "SELECT DISTINCT " + CRLF
    cSQL += "       C5_XNPSITE      AS PED_SITE, " + CRLF
    cSQL += "       C5_CHVBPAG      AS PED_GAR, " + CRLF
    cSQL += "       C5_NUM          AS PEDIDO, " + CRLF
    cSQL += "       C5_EMISSAO      AS EMISSAO, " + CRLF
    cSQL += "       TRIM(A1_NOME)   AS CLIENTE, " + CRLF
    cSQL += "       TRIM(A1_EMAIL)  AS EMAIL, " + CRLF
    cSQL += "       C6_PRODUTO      AS PRODUTO, " + CRLF
    cSQL += "       C6_PROGAR       AS PROD_GAR, " + CRLF
    cSQL += "       C6_DESCRI       AS DECRICAO, " + CRLF
    cSQL += "       C6_VALOR        AS VALOR, " + CRLF
    cSQL += "       ( CASE " + CRLF
    cSQL += "           WHEN C5_TIPMOV = '1' THEN 'Boleto' " + CRLF
    cSQL += "           WHEN C5_TIPMOV = '2' THEN 'Cartao Credito' " + CRLF
    cSQL += "           WHEN C5_TIPMOV = '3' THEN 'Cartao Debito' " + CRLF
    cSQL += "           WHEN C5_TIPMOV = '4' THEN 'DA BB' " + CRLF
    cSQL += "           WHEN C5_TIPMOV = '5' THEN 'DDA' " + CRLF
    cSQL += "           WHEN C5_TIPMOV = '6' THEN 'Voucher' " + CRLF
    cSQL += "           WHEN C5_TIPMOV = '7' THEN 'DA ITAU' " + CRLF
    cSQL += "           WHEN C5_TIPMOV = '8' THEN 'Crédito em conta' " + CRLF
    cSQL += "           ELSE 'Outros' " + CRLF
    cSQL += "         END )         FORMA_PAGTO, " + CRLF
    cSQL += "       C6_NOTA         AS NOTA, " + CRLF
    cSQL += "       C6_SERIE        AS SERIE, " + CRLF
    cSQL += "       CASE WHEN C5_XRECPG > ' ' THEN 'Realizado' ELSE 'Não realizado' END PAGAMENTO " + CRLF
    cSQL += "FROM   " + RetSqlName('SC6') + " C6 " + CRLF
    cSQL += "       INNER JOIN " + RetSqlName('SC5') + " C5 " + CRLF
    cSQL += "               ON C5_FILIAL = C6_FILIAL " + CRLF
    cSQL += "                  AND C5_NUM = C6_NUM " + CRLF
    cSQL += "                  AND C5_EMISSAO >= '" + dToS( aRET[ 2 ] ) + "' " + CRLF
    cSQL += "                  AND C5_EMISSAO <= '" + dToS( aRET[ 3 ] ) + "' " + CRLF
    cSQL += "                  AND C5.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "       INNER JOIN " + RetSqlName('SA1') + " SA1 " + CRLF
    cSQL += "               ON A1_FILIAL = '" + xFilial('SA1') + "' " + CRLF
    cSQL += "                  AND A1_COD  = C5_CLIENTE " + CRLF
    cSQL += "                  AND A1_LOJA = C5_LOJACLI " + CRLF
    cSQL += "                  AND SA1.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "WHERE  C6.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "       AND C6_FILIAL = '" + xFilial('SC6') + "' " + CRLF
    cSQL += "       AND C6_PROGAR = ANY ( 'SRFA3PFSCRMIDHV5', 'SRFA3PJSCRMIDHV5', 'SRFA3PFSC5ARMIDHV5', 'SRFA3PJSC5ARMIDHV5', "
    cSQL += "                             'SRFA3PFSC1ARMIDHV5', 'SRFA3PJSC1ARMIDHV5' )" + CRLF

    cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	cCount := ' SELECT COUNT(*) COUNT FROM ( ' + cSQL + ' ) QUERY '
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCount),cTRB,.F.,.T.)
	nREGISTROS := (cTRB)->COUNT
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

    TcSetField( cTRB, "EMISSAO"  , "D", 8 )
    TcSetField( cTRB, "VALOR"    , "N", 15, 2 )

    IF (cTRB)->( EOF() )
        lRet := .F.    
        (cTRB)->( dbCloseArea() )
	    FErase( cTRB + GetDBExtension() )
        MsgInfo('Não há dados para extração conforme parâmetros informados.',cTitulo)
    EndIF
Return( lRet )
//+-------------------------------------------------------------------+
//| Rotina | CSFIN040 | Autor | Rafael Beghini | Data | 30.01.2019 
//+-------------------------------------------------------------------+
//| Descr. | Gera o relatório no formato .XML
//+-------------------------------------------------------------------+
Static Function A010Imp(oDlg, oSay, oMeter)
    Local nSeconds    := 0
    Local nCount      := 0
    Local nLastUpdate := 0
    Local cWorkSheet  := 'Pedidos'
	Local cTable      := 'Vendas Remote ID - período [' + dTOC( aRET[ 2 ] ) + ' - ' + dTOC( aRET[ 3 ] ) + ']'
	Local cPath       := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile   := cPath + 'Vendas_RemoteID' + dTos(Date()) + ".XML"
	Local oExcel      := FWMSEXCEL():New() //Método para geração em XML
    Local cPOSTO      := ''
    Local cEmitido    := ''
    Local cZ5_FIL     := xFilial('SZ5')
    
    oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >           , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido Site"         , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido GAR"          , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido Protheus"     , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Data da emissão"     , 1     , 4      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Cliente"             , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "E-mail"              , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Produto"             , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Produto GAR"         , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Descrição"           , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Valor Pedido"        , 1     , 3      , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Forma pagamento"     , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Pagamento"           , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Nota Fiscal"         , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Série NF"            , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "Posto de atendimento", 1     , 1      , .F. )    
    oExcel:AddColumn( cWorkSheet, cTable, "Certificado emitido" , 1     , 1      , .F. )
    
	//nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada

    oMeter:SetTotal(nREGISTROS)
    nSeconds := Seconds()

    oSay:SetText("Aguarde, montando o relatório. Total de registro(s): " + AllTrim( Str(nREGISTROS) ) )

    SZ5->( dbSetOrder(1) )

    (cTRB)->( dbGotop() )
    While .NOT. (cTRB)->( EOF() )
        nCount++
        IF (Seconds() - nLastUpdate) > 1 // Se passou 1 segundo desde a última atualização da tela
            oMeter:Set(nCount)
            oDlg:CommitControls() // Para atualizar a tela e o usuário receber o feedback

            nLastUpdate := Seconds()
        EndIf

        IF .NOT. Empty( (cTRB)->PED_GAR )
            IF SZ5->( dbSeek( cZ5_FIL + (cTRB)->PED_GAR + 'VERIFI' ) )
                cPOSTO      := Alltrim( SZ5->Z5_DESPOS )
                cEmitido    := iIF( Empty(SZ5->Z5_DATVAL), 'Não', 'Sim' )
            Else
                cPOSTO      := ''
                cEmitido    := 'Não'
            EndIF
        Else
            cPOSTO      := ''
            cEmitido    := 'Não'
        EndIF

        oExcel:AddRow( cWorkSheet, cTable, { (cTRB)->PED_SITE,;
                                                (cTRB)->PED_GAR,;
                                                (cTRB)->PEDIDO,;
                                                (cTRB)->EMISSAO,;
                                                (cTRB)->CLIENTE,;
                                                (cTRB)->EMAIL,;
                                                (cTRB)->PRODUTO,;
                                                (cTRB)->PROD_GAR,;
                                                (cTRB)->DECRICAO,;
                                                (cTRB)->VALOR,;
                                                (cTRB)->FORMA_PAGTO,;
                                                (cTRB)->PAGAMENTO,;
                                                (cTRB)->NOTA,;
                                                (cTRB)->SERIE,;
                                                cPOSTO,;
                                                cEmitido} )
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