#Include 'Protheus.ch'
Static nREGISTROS := 0
//+-------------------------------------------------------------------+
//| Rotina | CSFIN040 | Autor | Rafael Beghini | Data | 12.07.2018 
//+-------------------------------------------------------------------+
//| Descr. | Relatório de baixas por ChargeBak
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSFIN040()
    Local aSAY  := {'Rotina para gerar relatório em formato XML com as baixas por Chargeback','','','Clique em OK para prosseguir...'}
    Local aBTN  := {}
    Local aPAR  := {}
    Local nOpc  := 0

    Private aRET := {}
    Private cTRB := ''
    Private cTitulo := '[CSFIN040] - Relatório ChargeBack'

    aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch('Rel. ChargeBack', aSAY, aBTN )

    IF nOpc == 1
        aAdd( aPAR, {9, "Informe os parâmetros",200,7,.T.})
	    aAdd( aPAR, {1, "Data de"	 , Ctod(Space(8)), "","",""   ,"",0,.F.})
	    aAdd( aPAR, {1, "Data ate"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})
	    aAdd( aPAR, {1, "Cliente de" , Space(06)     , "","","SA1","",0,.F.})
	    aAdd( aPAR, {1, "Cliente ate", 'ZZZZZZ'	     , "","","SA1","",0,.T.})

        IF ParamBox(aPAR,"Relatório ChargeBack",@aRET)
            A010Proc( aRET )
        Else
            MsgInfo('Processo cancelado',cTitulo)
        EndIF
    EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Proc | Autor | Rafael Beghini | Data | 12.07.2018 
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
//| Rotina | A010Qry | Autor | Rafael Beghini | Data | 12.07.2018 
//+-------------------------------------------------------------------+
//| Descr. | Monta a query conforme parâmetros
//+-------------------------------------------------------------------+
Static Function A010Qry( aRET )
    Local cSQL   := ''
    Local cCount := ''
    Local lRet   := .T.

    cSQL += "SELECT C5_EMISSAO, " + CRLF
    cSQL += "       E5_DATA, " + CRLF
    cSQL += "       C5_XCARTAO, " + CRLF
    cSQL += "       C5_XDOCUME, " + CRLF
    cSQL += "       C5_XCODAUT, " + CRLF
    cSQL += "       C5_TOTPED, " + CRLF
    cSQL += "       E5_VALOR, " + CRLF
    cSQL += "       C5_NUM, " + CRLF
    cSQL += "       C5_XNPSITE, " + CRLF
    cSQL += "       C5_CHVBPAG, " + CRLF
    cSQL += "       C5_CLIENTE, " + CRLF
    cSQL += "       E5_PARCELA, " + CRLF
    cSQL += "       C5_XNPARCE, " + CRLF
    cSQL += "       TRIM(A1_NOME) AS RAZAO " + CRLF
    cSQL += "FROM " + RetSqlName('SE5') + " E5 " + CRLF
    cSQL += "       INNER JOIN " + RetSqlName('SC5') + " C5 " + CRLF
    cSQL += "               ON C5_FILIAL = '" + xFilial('SC5') + "' " + CRLF
    cSQL += "                  AND C5_NUM = E5_NUMERO " + CRLF
    cSQL += "                  AND C5_CLIENTE = E5_CLIFOR " + CRLF
    cSQL += "                  AND C5_LOJACLI = E5_LOJA " + CRLF
    cSQL += "                  AND C5.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "       INNER JOIN " + RetSqlName('SA1') + " A1 " + CRLF
    cSQL += "               ON A1_FILIAL = '" + xFilial('SA1') + "' " + CRLF
    cSQL += "                  AND A1_COD = E5_CLIFOR " + CRLF
    cSQL += "                  AND A1_LOJA = E5_LOJA " + CRLF
    cSQL += "                  AND A1.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "WHERE  E5.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "       AND E5_FILIAL = '" + xFilial('SE5') + "' " + CRLF
    cSQL += "       AND E5_DATA >= '" + dToS( aRET[ 2 ] ) + "' " + CRLF
    cSQL += "       AND E5_DATA <= '" + dToS( aRET[ 3 ] ) + "' " + CRLF
    cSQL += "       AND E5_TIPO = 'NCC' " + CRLF
    cSQL += "       AND E5_MOTBX = 'CHA' " + CRLF
    cSQL += "       AND E5_TIPODOC = 'BA' " + CRLF
    cSQL += "       AND E5_PREFIXO = 'RCP' " + CRLF
    cSQL += "       AND E5_CLIFOR >= '" + aRET[ 4 ] + "' " + CRLF
    cSQL += "       AND E5_CLIFOR <= '" + aRET[ 5 ] + "' " + CRLF

    cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	cCount := ' SELECT COUNT(*) COUNT FROM ( ' + cSQL + ' ) QUERY '
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCount),cTRB,.F.,.T.)
	nREGISTROS := (cTRB)->COUNT
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

    TcSetField( cTRB, "C5_EMISSAO", "D", 8 )
    TcSetField( cTRB, "E5_DATA"   , "D", 8 )
    TcSetField( cTRB, "C5_TOTPED" , "N", 15, 2 )
    TcSetField( cTRB, "E5_VALOR"  , "N", 15, 2 )

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
    Local cWorkSheet  := 'Títulos'
	Local cTable      := 'Baixas por ChargeBack - período [' + dTOC( aRET[ 2 ] ) + ' - ' + dTOC( aRET[ 3 ] ) + ']'
	Local cPath       := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile   := cPath + 'Chargeback_' + dTos(Date()) + ".XML"
	Local oExcel      := FWMSEXCEL():New() //Método para geração em XML

    oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >     , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Data da Venda"  , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data do débito" , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nº do cartão"   , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "NSU / DOC"      , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Autorização"    , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor Pedido"   , 1     , 3      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor Baixa"    , 1     , 3      , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido Protheus", 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido Site"    , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido GAR"     , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Cliente"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Razão Social"   , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nº parcela"     , 2     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Total parcelas" , 2     , 1      , .F. )

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

        oExcel:AddRow( cWorkSheet, cTable, { (cTRB)->C5_EMISSAO,;
                                                (cTRB)->E5_DATA,;
                                                (cTRB)->C5_XCARTAO,;
                                                (cTRB)->C5_XDOCUME,;
                                                (cTRB)->C5_XCODAUT,;
                                                (cTRB)->C5_TOTPED,;
                                                (cTRB)->E5_VALOR,;
                                                (cTRB)->C5_NUM,;
                                                (cTRB)->C5_XNPSITE,;
                                                (cTRB)->C5_CHVBPAG,;
                                                (cTRB)->C5_CLIENTE,;
                                                (cTRB)->RAZAO,;
                                                (cTRB)->E5_PARCELA,;
                                                (cTRB)->C5_XNPARCE } )
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