#Include 'Protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | CSFAT070 | Autor | Rafael Beghini | Data | 16.08.2016 
//+-------------------------------------------------------------------+
//| Descr. | Relatório de Pedidos cancelados e resíduo
//|        | utilizando a função FWMsExcel
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSFAT070()
	Local nOpc   := 0
	Local aRet   := {}
	Local aParamBox := {}
	
	Private cCadastro := "Relatório de Pedidos cancelados e/ou resíduo"
	Private cShowQry := ''
	Private cAliasA  := GetNextAlias()
	Private aSay     := {}
	Private aButton  := {}
	Private oExcel   := Nil
	Private lShowQry := .F.
	
	AAdd( aSay, "Esta rotina irá imprimir o relatorio Relatório de Pedidos cancelados e/ou resíduo", )
	AAdd( aSay, "conforme parâmetros informados pelo usuário."                                    )
	aAdd( aSay, ""                                                                                )
	aAdd( aSay, "Ao final do processamento, é gerado uma planilha com as informações."            )
	
	aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() } } )
	aAdd( aButton, { 2, .T., {|| FechaBatch()            } } )
	
	SetKey( VK_F12 , {|| lShowQry := MsgYesNo('Exportar a consulta SQL?',cCadastro ) } )
	
	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		aAdd(aParamBox,{ 1, "Filial de"  , Space(02)     , "", "", "SM0", "",  0, .F. }) // 01
		aAdd(aParamBox,{ 1, "Filial Ate" , xFilial('SC5'), "", "", "SM0", "",  0, .T. }) // 02
		aAdd(aParamBox,{ 1, "Periodo de" , Ctod(Space(8)), "", "", ""   , "", 20, .T. }) // 03
		aAdd(aParamBox,{ 1, "Periodo Ate", dDatabase     , "", "", ""   , "", 20, .T. }) // 04
		
		If ParamBox(aParamBox,"",@aRet)
			FWMsgRun(, {|| A070Query( aRet ) },cCadastro,'Gerando relatório, aguarde...')
			If lShowQry
				A070ShowQry( cShowQry )
			EndIF
		EndIF
	EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | A070Query | Autor | Rafael Beghini | Data | 16.08.2016
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A070Query( aRet )
	Local cSQL := ''
	Private cMV_par01 := cMV_par02 := cMV_par03 := cMV_par04 := ''
	
	//Atribui conforme o Parambox enviou
	cMV_par01 := aRet[1]  ; cMV_par02 := aRet[2]  ; cMV_par03 := dToS(aRet[3])  ; cMV_par04 := dToS(aRet[4])	
	
	cSQL += "SELECT DISTINCT c5_filial                       AS Filial, " + CRLF
	cSQL += "                c5_num                          AS Pedido, " + CRLF
	cSQL += "                c5_cliente                      AS Cliente, " + CRLF
	cSQL += "                a1_nome                         AS Nome, " + CRLF
	cSQL += "                c5_condpag                      AS Cond_pagto, " + CRLF
	cSQL += "                c5_xnature                      AS Natureza, " + CRLF
	cSQL += "                To_date(c5_emissao, 'yyyymmdd') AS Emissao, " + CRLF
	cSQL += "                c5_vend1                        AS Vendedor, " + CRLF
	cSQL += "                c5_xorigpv                      AS Origem_Pv, " + CRLF
	cSQL += "                sc5.d_e_l_e_t_                  AS Deletado, " + CRLF
	cSQL += "                d2_doc                          AS Nota_Fiscal, " + CRLF
	cSQL += "                d2_serie                        AS Serie, " + CRLF
	cSQL += "                Trim(c5_xmotblq)                AS Motivo_bloqueio, " + CRLF
	cSQL += "                c6_blq                          AS Residuo " + CRLF
	cSQL += "FROM   " + RetSqlName("SC6") + " SC6 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("sc5") + " sc5 " + CRLF
	cSQL += "               ON sc5.d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "                  AND c5_filial = c6_filial " + CRLF
	cSQL += "                  AND c5_num = c6_num " + CRLF
	cSQL += "                  AND ( c5_xorigpv = '1' " + CRLF
	cSQL += "                         OR c5_xorigpv = '4' " + CRLF
	cSQL += "                         OR c5_xorigpv = '6' ) " + CRLF
	cSQL += "                  AND c5_emissao >= '" + cMV_par03 + "'" + CRLF
	cSQL += "                  AND c5_emissao <= '" + cMV_par04 + "'" + CRLF
	cSQL += "       LEFT JOIN " + RetSqlName("sd2") + " sd2 " + CRLF
	cSQL += "               ON d2_filial = '"+xFilial("SD2")+"' " + CRLF
	cSQL += "                  AND d2_pedido = c6_num " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("sa1") + " sa1 " + CRLF
	cSQL += "               ON a1_filial = ' ' " + CRLF
	cSQL += "                  AND a1_cod = c5_cliente " + CRLF
	cSQL += "                  AND a1_loja = c5_lojacli " + CRLF
	cSQL += "WHERE  sc6.d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "       AND c6_filial >= '" + cMV_par01 + "'" + CRLF
	cSQL += "       AND c6_filial <= '" + cMV_par02 + "'" + CRLF
	cSQL += "       AND c6_blq <> ' ' " + CRLF
	cSQL += "UNION " + CRLF
	cSQL += "SELECT DISTINCT c5_filial                       AS Filial, " + CRLF
	cSQL += "                c5_num                          AS Pedido, " + CRLF
	cSQL += "                c5_cliente                      AS Cliente, " + CRLF
	cSQL += "                a1_nome                         AS Nome, " + CRLF
	cSQL += "                c5_condpag                      AS Cond_pagto, " + CRLF
	cSQL += "                c5_xnature                      AS Natureza, " + CRLF
	cSQL += "                To_date(c5_emissao, 'yyyymmdd') AS Emissao, " + CRLF
	cSQL += "                c5_vend1                        AS Vendedor, " + CRLF
	cSQL += "                c5_xorigpv                      AS Origem_Pv, " + CRLF
	cSQL += "                sc5.d_e_l_e_t_                  AS Deletado, " + CRLF
	cSQL += "                ''                              AS Nota_Fiscal, " + CRLF
	cSQL += "                ''                              AS Serie, " + CRLF
	cSQL += "                Trim(c5_xmotblq)                AS Motivo_bloqueio, " + CRLF
	cSQL += "                c6_blq                          AS Residuo " + CRLF
	cSQL += "FROM   " + RetSqlName("sc6") + " sc6 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("sc5") + " sc5 " + CRLF
	cSQL += "               ON sc5.d_e_l_e_t_ = '*' " + CRLF
	cSQL += "                  AND c5_filial = c6_filial " + CRLF
	cSQL += "                  AND c5_num = c6_num " + CRLF
	cSQL += "                  AND ( c5_xorigpv = '1' " + CRLF
	cSQL += "                         OR c5_xorigpv = '4' " + CRLF
	cSQL += "                         OR c5_xorigpv = '6' ) " + CRLF
	cSQL += "                  AND c5_emissao >= '" + cMV_par03 + "'" + CRLF
	cSQL += "                  AND c5_emissao <= '" + cMV_par04 + "'" + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("sa1") + " sa1 " + CRLF
	cSQL += "               ON a1_filial = ' ' " + CRLF
	cSQL += "                  AND a1_cod = c5_cliente " + CRLF
	cSQL += "                  AND a1_loja = c5_lojacli " + CRLF
	cSQL += "WHERE  sc6.d_e_l_e_t_ = '*' " + CRLF
	cSQL += "       AND c6_filial >= '" + cMV_par01 + "'" + CRLF
	cSQL += "       AND c6_filial <= '" + cMV_par02 + "'" + CRLF
	cSQL += "ORDER  BY pedido " + CRLF
	
	cShowQry += cSQL
	
	cSQL := ChangeQuery(cSQL)
	
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), cAliasA, .F., .T.)
		
	IF .NOT. Eof( cAliasA )
		A070Excel( cAliasA )
	Else
		MsgAlert('A query não retornou registros, por favor verifique os parâmetros informados.', cCadastro)
	EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | A070Excel | Autor | Rafael Beghini | Data | 16.08.2016 
//+-------------------------------------------------------------------+
//| Descr. | Gera o arquivo XML conforme query realizada. 
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A070Excel( cAliasA )
	Local cWorkSheet := 'Pedidos'
	Local cTable     := cCadastro
	Local cPath      := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile  := cPath + 'Pedidos_' + dTos(Date()) + ".XML"
	Local aArea      := GetArea()
	Local aDADOS     := {}
	Local nPos       := 0
	Local cSTATUS    := ''
	
	oExcel := FWMSEXCEL():New() //Método para geração em XML
	
	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >  , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Filial"         , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido"         , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Cliente"        , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nome"           , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Cond_pagto"     , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Natureza"       , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Emissao"        , 1     , 4	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vendedor"       , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Origem_Pv"      , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Deletado"       , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nota_Fiscal"    , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Serie"          , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Motivo_bloqueio", 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Residuo"        , 1     , 1	   , .F. )
	
	//Para mostrar os itens preenchidos olhar a tabela RDY
	While .NOT. Eof( cAliasA )
		aDADOS := { (cAliasA)->Filial, (cAliasA)->Pedido, (cAliasA)->Cliente, (cAliasA)->Nome, (cAliasA)->Cond_pagto, (cAliasA)->Natureza,;
					  (cAliasA)->Emissao, (cAliasA)->Vendedor, (cAliasA)->Origem_Pv, (cAliasA)->Deletado, (cAliasA)->Nota_Fiscal, (cAliasA)->Serie,;
					  (cAliasA)->Motivo_bloqueio, (cAliasA)->Residuo }
					  
		oExcel:AddRow( cWorkSheet, cTable, aDADOS )
		(cAliasA)->( dbSkip() )
	End
	
	(cAliasA)->( dbCloseArea() )
	
	IF File( cNameFile )
		Ferase( cNameFile )
	EndIF		
	
	Sleep(500)
		
	oExcel:Activate()              //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
	
	IF ! ApOleClient("MsExcel") 
		MsgAlert("MsExcel não instalado. Para abrir o arquivo, localize-o na pasta %temp% .",cCadastro)
	Else
		ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela após salvar
	EndIF
	RestArea(aArea)
Return

//-----------------------------------------------------------------------
// Rotina | A070ShowQry | Autor | Rafael Beghini    | Data | 16.08.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar o script de instrução SQL na tela.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A070ShowQry( cSQL )
	Local cNomeArq := ''
	Local nHandle := 0
	Local lEmpty := .F.
	AutoGrLog('ativar para apagar')
	cNomeArq := NomeAutoLog()
	lEmpty := Empty( cNomeArq )
	If !lEmpty
		nHandle := FOpen( cNomeArq, 2 )
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
	AutoGrLog( cSQL )
	MostraErro()
	If !lEmpty
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
Return
