#Include 'Protheus.ch'
Static nREGISTROS := 0
//+-------------------------------------------------------------------+
//| Rotina | CSCTB020 | Autor | Rafael Beghini | Data | 15.08.2018 
//+-------------------------------------------------------------------+
//| Descr. | Relatório de vendas por contrato
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSCTB020()
    Local aSAY  := {'Rotina para gerar relatório em formato XML com as vendas por contrato','','','Clique em OK para prosseguir...'}
    Local aBTN  := {}
    Local aPAR  := {}
    Local nOpc  := 0

    Private aRET := {}
    Private cTRB := ''
    Private cTitulo := '[CSCTB020] - Relatório Vendas por Contrato'

    aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch('Rel. Vendas por Contrato', aSAY, aBTN )

    IF nOpc == 1
        aAdd( aPAR, {9, "Informe os parâmetros",200,7,.T.})
	    aAdd( aPAR, {1, "Data de"	 , Ctod(Space(8)), "","",""   ,"",0,.F.})
	    aAdd( aPAR, {1, "Data ate"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})
	    
        IF ParamBox(aPAR,"Relatório Vendas por Contrato",@aRET)
            A010Proc( aRET )
        Else
            MsgInfo('Processo cancelado',cTitulo)
        EndIF
    EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Proc | Autor | Rafael Beghini | Data | 15.08.2018 
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
//| Rotina | A010Qry | Autor | Rafael Beghini | Data | 15.08.2018 
//+-------------------------------------------------------------------+
//| Descr. | Monta a query conforme parâmetros
//+-------------------------------------------------------------------+
Static Function A010Qry( aRET )
    Local cSQL   := ''
    Local cCount := ''
    Local lRet   := .T.

    cSQL += "SELECT C5_XORIGPV, " + CRLF
    cSQL += "       C5_VEND1, " + CRLF
    cSQL += "       C5_XNATURE, " + CRLF
    cSQL += "       C5_CONDPAG, " + CRLF
    cSQL += "       C5_TIPMOV, " + CRLF
    cSQL += "       C6_XOPER, " + CRLF
    cSQL += "       D2_PEDIDO, " + CRLF
    cSQL += "       D2_EMISSAO, " + CRLF
    cSQL += "       D2_DOC, " + CRLF
    cSQL += "       D2_SERIE, " + CRLF
    cSQL += "       D2_CLIENTE, " + CRLF
    cSQL += "       D2_LOJA, " + CRLF
    cSQL += "       Sum(D2_TOTAL + D2_VALFRE) TOTAL, " + CRLF
    cSQL += "       D2_FILIAL || D2_DOC || D2_SERIE || D2_CLIENTE || D2_LOJA AS CHAVE, " + CRLF
    cSQL += "       CT2_LP, " + CRLF
    cSQL += "       TRIM(CT2_ORIGEM) AS CT2_ORIGEM, " + CRLF
    cSQL += "       CT2_DATA, " + CRLF
    cSQL += "       CT2_LOTE, " + CRLF
    cSQL += "       CT2_DOC, " + CRLF
    cSQL += "       TRIM(CT2_KEY) AS CT2_KEY, " + CRLF
    cSQL += "       CT2_DEBITO, " + CRLF
    cSQL += "       CT2_CREDIT, " + CRLF
    cSQL += "       CT2_VALOR, " + CRLF
    cSQL += "       TRIM(CT2_HIST) AS CT2_HIST " + CRLF
    cSQL += "FROM   " + RetSqlName('SD2') + " SD2 " + CRLF
    cSQL += "       INNER JOIN " + RetSqlName('SF2') + " SF2 " + CRLF
    cSQL += "               ON SF2.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "                  AND F2_FILIAL = D2_FILIAL " + CRLF
    cSQL += "                  AND F2_DOC = D2_DOC " + CRLF
    cSQL += "                  AND F2_SERIE = D2_SERIE " + CRLF
    cSQL += "       INNER JOIN " + RetSqlName('SC6') + " SC6 " + CRLF
    cSQL += "               ON SC6.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "                  AND C6_NUM = D2_PEDIDO " + CRLF
    cSQL += "                  AND C6_ITEM = D2_ITEMPV " + CRLF
    cSQL += "       INNER JOIN " + RetSqlName('SC5') + " SC5 " + CRLF
    cSQL += "               ON SC5.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "                  AND C5_FILIAL = C6_FILIAL " + CRLF
    cSQL += "                  AND C5_NUM = C6_NUM " + CRLF
    cSQL += "                  AND C5_TIPO = 'N' " + CRLF
    cSQL += "       INNER JOIN " + RetSqlName('SF4') + " SF4 " + CRLF
    cSQL += "               ON SF4.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "                  AND F4_FILIAL = '" + xFilial('SF4') + "' " + CRLF
    cSQL += "                  AND F4_CODIGO = D2_TES " + CRLF
    cSQL += "                  AND F4_XGRPCTB IN( '70', '60' ) " + CRLF
    cSQL += "       LEFT JOIN " + RetSqlName('CT2') + " CT2 " + CRLF
    cSQL += "              ON CT2_FILIAL = '" + xFilial('CT2') + "' " + CRLF
    cSQL += "                 AND CT2_DATA >= '" + dToS( aRET[ 2 ] ) + "' " + CRLF
    cSQL += "                 AND CT2_DATA <= '" + dToS( aRET[ 3 ] ) + "' " + CRLF
    cSQL += "                 AND CT2.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "                 AND CT2_DC <> '4' " + CRLF
    cSQL += "                 AND CT2_MOEDLC = '01' " + CRLF
    cSQL += "                 AND TRIM(D2_FILIAL " + CRLF
    cSQL += "                          || D2_DOC " + CRLF
    cSQL += "                          || D2_SERIE " + CRLF
    cSQL += "                          || D2_CLIENTE " + CRLF
    cSQL += "                          || D2_LOJA) = TRIM(CT2.CT2_KEY) " + CRLF
    cSQL += "WHERE  SD2.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "       AND D2_FILIAL >= '01' " + CRLF
    cSQL += "       AND D2_EMISSAO >= '" + dToS( aRET[ 2 ] ) + "' " + CRLF
    cSQL += "       AND D2_EMISSAO <= '" + dToS( aRET[ 3 ] ) + "' " + CRLF
    cSQL += "GROUP  BY C5_XORIGPV, " + CRLF
    cSQL += "          C5_VEND1, " + CRLF
    cSQL += "          C5_XNATURE, " + CRLF
    cSQL += "          C5_CONDPAG, " + CRLF
    cSQL += "          C5_TIPMOV, " + CRLF
    cSQL += "          C6_XOPER, " + CRLF
    cSQL += "          D2_PEDIDO, " + CRLF
    cSQL += "          D2_EMISSAO, " + CRLF
    cSQL += "          D2_DOC, " + CRLF
    cSQL += "          D2_SERIE, " + CRLF
    cSQL += "          D2_CLIENTE, " + CRLF
    cSQL += "          D2_LOJA, " + CRLF
    cSQL += "          D2_FILIAL " + CRLF
    cSQL += "          || D2_DOC " + CRLF
    cSQL += "          || D2_SERIE " + CRLF
    cSQL += "          || D2_CLIENTE " + CRLF
    cSQL += "          || D2_LOJA, " + CRLF
    cSQL += "          CT2_LP, " + CRLF
    cSQL += "          CT2_ORIGEM, " + CRLF
    cSQL += "          CT2_DATA, " + CRLF
    cSQL += "          CT2_LOTE, " + CRLF
    cSQL += "          CT2_DOC, " + CRLF
    cSQL += "          CT2_KEY, " + CRLF
    cSQL += "          CT2_DEBITO, " + CRLF
    cSQL += "          CT2_CREDIT, " + CRLF
    cSQL += "          CT2_VALOR, " + CRLF
    cSQL += "          CT2_HIST " + CRLF

    cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	cCount := ' SELECT COUNT(*) COUNT FROM ( ' + cSQL + ' ) QUERY '
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCount),cTRB,.F.,.T.)
	nREGISTROS := (cTRB)->COUNT
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

    TcSetField( cTRB, "D2_EMISSAO", "D", 8 )
    TcSetField( cTRB, "CT2_DATA"  , "D", 8 )
    TcSetField( cTRB, "TOTAL"     , "N", 15, 2 )
    TcSetField( cTRB, "CT2_VALOR" , "N", 15, 2 )

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
    Local nPos        := 0
    Local cOrigPv     := ''
    Local aOrigPv     := StrToKarr( U_CSC5XBOX(), ';' )
    Local cWorkSheet  := 'Títulos'
	Local cTable      := 'Vendas por contrato - período [' + dTOC( aRET[ 2 ] ) + ' - ' + dTOC( aRET[ 3 ] ) + ']'
	Local cPath       := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile   := cPath + 'vendasContratos_' + dTos(Date()) + ".XML"
	Local oExcel      := FWMSEXCEL():New() //Método para geração em XML

    oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >     , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Origem P Venda"  , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vendedor"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Natureza"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Cond. Pagamento" , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Tipo Mov"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Operação"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido Protheus" , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Emissão"         , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nota Fiscal"     , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Série"           , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Cliente"         , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Loja"            , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Total"           , 1     , 3      , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Key"             , 1     , 1      , .F. )
    oExcel:AddColumn( cWorkSheet, cTable, "LP"              , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Origem LP"       , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data lanç"       , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Lote"            , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Documento"       , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Key lanç"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Conta débito"    , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Conta crédito"   , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor lanç"      , 1     , 3      , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Histórico"       , 1     , 1      , .F. )

    //nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada

    oMeter:SetTotal(nREGISTROS)
    nSeconds := Seconds()

    oSay:SetText("Aguarde, montando o relatório. Total de registro(s): " + AllTrim( Str(nREGISTROS) ) )

    (cTRB)->( dbGotop() )
    While .NOT. (cTRB)->( EOF() )
        nCount++
        IF (Seconds() - nLastUpdate) > 1 // Se passou 1 segundo desde a última atualização da tela
            oMeter:Set(nCount)
            oDlg:CommitControls() // Para atualizar a tela e o usuário receber o feedback

            nLastUpdate := Seconds()
        EndIf

        nPos := AScan( aOrigPv, {|x| Left(x,1) == (cTRB)->C5_XORIGPV  } )
		cOrigPv := IIF( nPos > 0,aOrigPv[nPos], '')

        oExcel:AddRow( cWorkSheet, cTable, { cOrigPv,;
                                            (cTRB)->C5_VEND1,;
                                            (cTRB)->C5_XNATURE,;
                                            (cTRB)->C5_CONDPAG,;
                                            (cTRB)->C5_TIPMOV,;
                                            (cTRB)->C6_XOPER,;
                                            (cTRB)->D2_PEDIDO,;
                                            (cTRB)->D2_EMISSAO,;
                                            (cTRB)->D2_DOC,;
                                            (cTRB)->D2_SERIE,;
                                            (cTRB)->D2_CLIENTE,;
                                            (cTRB)->D2_LOJA,;
                                            (cTRB)->TOTAL,;
                                            (cTRB)->CHAVE,;
                                            (cTRB)->CT2_LP,;
                                            (cTRB)->CT2_ORIGEM,;
                                            (cTRB)->CT2_DATA,;
                                            (cTRB)->CT2_LOTE,;
                                            (cTRB)->CT2_DOC,;
                                            (cTRB)->CT2_KEY,;
                                            (cTRB)->CT2_DEBITO,;
                                            (cTRB)->CT2_CREDIT,;
                                            (cTRB)->CT2_VALOR,;
                                            (cTRB)->CT2_HIST } )
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