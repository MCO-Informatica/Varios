#Include 'totvs.ch'
//----------------------------------------------------------------------
// Rotina | CSCOM010  | Autor | Rafael Beghini      | Data | 19/02/2016
//----------------------------------------------------------------------
// Descr. | Relatório de Status do Pedido de Compra
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//----------------------------------------------------------------------
User Function CSCOM010()
	Local aRet   := {}
	Local aParam := {}
	Local nOpc   := 0
	
	Private aSay     := {}
	Private aButton  := {}
	Private aOpca    := {'Pedidos bloqueados (aguardando outros niveis)','Pedidos aguardando aprovação','Pedidos aprovados',;
		                 'Pedidos bloqueados','Pedidos liberados por outro usuario','Todos','Pedidos rejeitados (Plan. Financeiro)'}
	Private cTitulo  := "Status do Pedido de Compra"
	Private cAliasA  := GetNextAlias()
	Private cShowQry := ''
	Private lShowQry := .F.
	
	AAdd( aSay , "O objetivo desta rotina é gerar o relatório para verificar o Status"        )
	AAdd( aSay , "do pedido de compra: Pedidos Liberados / Bloqueados / Aguardando aprovação.")
	AAdd( aSay , ""                                                                           )
	AAdd( aSay , "Clique para continuar..."                                                   )
	
	aAdd( aButton, { 1, .T., {|| nOpc := 1,FechaBatch() } } )
	aAdd( aButton, { 2, .T., {|| FechaBatch() } } )
	
	SetKey( VK_F12 , {|| lShowQry := MsgYesNo('Exportar a consulta SQL?',cTitulo ) } )
	
	FormBatch( cTitulo, aSay, aButton )

	If nOpc == 1
		aAdd(aParam,{1 ,"Filial de"   ,Space(02)     ,""   ,""  ,"SM0","",0 ,.F.}) // Tipo caractere
		aAdd(aParam,{1 ,"Filial Ate"  ,xFilial('SC7'),""   ,""  ,"SM0","",0 ,.T.}) // Tipo caractere
		aAdd(aParam,{1 ,"Emissão de"  ,Ctod(Space(8)),""   ,""  ,""   ,"",20,.F.}) // Tipo data
		aAdd(aParam,{1 ,"Emissão Ate" ,dDataBase     ,""   ,""  ,""   ,"",20,.T.}) // Tipo data
		aAdd(aParam,{3 ,"Situação"    ,1             ,aOpca,150 ,""   ,.F.})
				
		If ParamBox(aParam,cTitulo,@aRet)
			IF aRet[5] == 7
				FWMsgRun(, {|| A010QryRej( aRet ) },cTitulo,'Gerando excel, aguarde...')
			Else
				FWMsgRun(, {|| A010Query( aRet ) },cTitulo,'Gerando excel, aguarde...')
			EndIF
			If lShowQry
				A010ShowQry( cShowQry )
			EndIF
		EndIF
	EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Query | Autor | Rafael Beghini | Data | 19/02/2016 
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A010Query( aRet )
	Local cQuery    := ''
	Local cMV_par01 := ''
	Local cMV_par02 := ''
	Local cMV_par03 := ''
	Local cMV_par04 := ''
	Local cMV_par05 := ''
		
	//Atribui conforme o Parambox enviou
	cMV_par01 := aRet[1]
	cMV_par02 := aRet[2]
	cMV_par03 := aRet[3]
	cMV_par04 := aRet[4]
	cMV_par05 := lTrim( StrZero( aRet[5], 2 ) )
	
	cQuery += "SELECT DISTINCT CR_FILIAL,  "  + CRLF
	cQuery += "                C7_NUM,     "  + CRLF
	cQuery += "                C7_EMISSAO, "  + CRLF
	cQuery += "                C7_XVENCTO, "  + CRLF
	cQuery += "                A2_NOME,    "  + CRLF
	cQuery += "                CR_DATALIB, "  + CRLF
	cQuery += "                C7_APROV,   "  + CRLF
	cQuery += "                CR_TOTAL,   "  + CRLF
	cQuery += "                CR_STATUS,  "  + CRLF
	cQuery += "                C7_CONTRA,  "  + CRLF
	cQuery += "                C7_MEDICAO, "  + CRLF
	cQuery += "                CR_TIPO,    "  + CRLF
	cQuery += "                C7_DOCFIS,  "  + CRLF
	cQuery += "                C7_CCAPROV, "  + CRLF
	cQuery += "                C7_USER,    "  + CRLF
	cQuery += "                CASE        "  + CRLF
	cQuery += "                  WHEN CR_TIPO = '#2' THEN 1 " + CRLF
	cQuery += "                  WHEN CR_TIPO = 'PC' THEN 2 " + CRLF
	cQuery += "                END ORDEM"     + CRLF
	cQuery += "FROM   " + RetSqlName("SCR") + " SCR " + CRLF
	cQuery += "       INNER JOIN " + RetSqlName("SC7") + " SC7 " + CRLF
	cQuery += "         ON C7_FILIAL = CR_FILIAL "  + CRLF
	cQuery += "         AND C7_NUM = CR_NUM      "  + CRLF
	cQuery += "         AND C7_EMISSAO >= '" + dToS(cMV_par03) + "' " + CRLF
	cQuery += "         AND C7_EMISSAO <= '" + dToS(cMV_par04) + "' " + CRLF
	IF .NOT. cMV_par05 == '06'
		IF cMV_par05 == '03' .Or. cMV_par05 == '05' //Aprovado
			cQuery += "         AND C7_CONAPRO = 'L'     "  + CRLF
		Else
			cQuery += "         AND C7_CONAPRO <> 'L'    "  + CRLF
		EndIF
	EndIF
	cQuery += "         AND SC7.D_E_L_E_T_ = ' ' "  + CRLF
	cQuery += "       INNER JOIN " + RetSqlName("SA2") + " SA2 " + CRLF
	cQuery += "         ON A2_FILIAL = '" + xFilial('SA2') + "' " + CRLF
	cQuery += "         AND A2_COD = C7_FORNECE " + CRLF
	cQuery += "         AND A2_LOJA = C7_LOJA   " + CRLF
	cQuery += "         AND SA2.D_E_L_E_T_= ' ' " + CRLF
	cQuery += "WHERE  SCR.D_E_L_E_T_  = ' '  "  + CRLF
	cQuery += "       AND CR_TIPO    IN ('PC','#2') "  + CRLF
	cQuery += "       AND CR_FILIAL  >= '" + cMV_par01 + "' " + CRLF
	cQuery += "       AND CR_FILIAL  <= '" + cMV_par02 + "' " + CRLF
	IF .NOT. cMV_par05 == '06'
		cQuery += "       AND CR_STATUS  = '" + cMV_par05 + "' "  + CRLF
	EndIF
	cQuery += "ORDER  BY CR_FILIAL, C7_NUM, ORDEM ASC "  + CRLF
	
	cShowQry := cQuery
	cQuery   := ChangeQuery(cQuery)
	
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasA, .F., .T.)
	
	IF .NOT. Eof( cAliasA )
		A010Excel( cAliasA, cMV_par05 )
	Else
		MsgAlert('A query não retornou registros, por favor verifique os parâmetros informados.', cTitulo)
	EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Excel | Autor | Rafael Beghini | Data | 19/02/2016 
//+-------------------------------------------------------------------+
//| Descr. | Gera o arquivo XML conforme query realizada. 
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A010Excel( cAliasA, cMV_par05 )
	Local cWorkSheet := "Pedidos"
	Local cTable     := aOpca[ MV_par05 ] 
	Local cFornece   := ''
	Local cAprov     := ''
	Local cStatus    := ''
	Local cTIPO      := ''
	Local cCusto     := ''
	Local cUSER      := ''
	Local cPath      := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile  := cPath + 'Pedidos_' + dToS(Date()) + ".XML"
	Local oExcel     := Nil
	
	oExcel := FWMSEXCEL():New() //Método para geração em XML
	
	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//AddColumn( cWorkSheet, cTable, < cColumn >     , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Filial"           , 1     , 1       , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nº Pedido"        , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Tipo"             , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nº Contrato"      , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nº Medição"       , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Emissão"          , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vencimento"       , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Fornecedor"       , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data Aprovação"   , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Aprovador"        , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor"            , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr.Docto.Fiscal"  , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "C.Custo Aprovação", 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "C.Custo Aprovação", 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Elaborador"       , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Situação"         , 1     , 3	   , .F. )
	
	//nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada
	
	While .NOT. Eof( cAliasA )
		
		IF     (cAliasA)->CR_STATUS == '01'; cStatus := 'Pedido bloqueado (aguardando outros niveis)'
		ElseIF (cAliasA)->CR_STATUS == '02'; cStatus := 'Pedido aguardando aprovação'
		ElseIF (cAliasA)->CR_STATUS == '03'; cStatus := 'Pedido aprovado'
		ElseIF (cAliasA)->CR_STATUS == '04'; cStatus := 'Pedido bloqueado'
		ElseIF (cAliasA)->CR_STATUS == '05'; cStatus := 'Pedido liberado por outro usuario'
		EndIF
		
		IF     (cAliasA)->CR_TIPO == 'PC' ; cTIPO := 'PC'; cAprov := A010Aprov( (cAliasA)->CR_FILIAL, (cAliasA)->C7_NUM, (cAliasA)->CR_STATUS )
		ElseIF (cAliasA)->CR_TIPO == '#2' ; cTIPO := 'CD'; cAprov := A020APROV( (cAliasA)->CR_FILIAL, (cAliasA)->C7_NUM )
		EndIF
		
		cCusto := POSICIONE("CTT",1,XFILIAL("CTT")+(cAliasA)->C7_CCAPROV,"CTT_DESC01")
		cUSER  := RTrim( UsrFullName( (cAliasA)->C7_USER ) )
		
		oExcel:AddRow( cWorkSheet, cTable, { (cAliasA)->CR_FILIAL,  (cAliasA)->C7_NUM, cTIPO, (cAliasA)->C7_CONTRA, (cAliasA)->C7_MEDICAO,;
			                                sToD((cAliasA)->C7_EMISSAO),;
			                                IIF( .NOT. Empty( (cAliasA)->C7_XVENCTO ), sToD( (cAliasA)->C7_XVENCTO ), (cAliasA)->C7_XVENCTO ),; 
			                                (cAliasA)->A2_NOME,; 
			                                IIF( .NOT. Empty( (cAliasA)->CR_DATALIB ), sToD( (cAliasA)->CR_DATALIB ), (cAliasA)->CR_DATALIB ),; 
			                                cAprov, (cAliasA)->CR_TOTAL, (cAliasA)->C7_DOCFIS, (cAliasA)->C7_CCAPROV, cCusto, cUSER, cStatus } )
	cCusto := ''
	cUSER  := ''
	(cAliasA)->( dbSkip() )
	End
	
	(cAliasA)->( dbCloseArea() )
		
	oExcel:Activate()              //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
	
	ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela após salvar	
Return
//-----------------------------------------------------------------------
// Rotina | A020ShowQry | Autor | Rafael Beghini    | Data | 19/02/2016
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar o script de instrução SQL na tela.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A010ShowQry( cSQL )
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
//+-------------------------------------------------------------------+
//| Rotina | A010Query | Autor | Rafael Beghini | Data | 19/02/2016 
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A010QryRej( aRet )
	Local cQuery    := ''
	Local cMV_par01 := ''
	Local cMV_par02 := ''
	Local cMV_par03 := ''
	Local cMV_par04 := ''
	Local cMV_par05 := ''
	
	
	//Atribui conforme o Parambox enviou
	cMV_par01 := aRet[1]
	cMV_par02 := aRet[2]
	cMV_par03 := aRet[3]
	cMV_par04 := aRet[4]
	cMV_par05 := aRet[5]
	
	
	cQuery += "SELECT PB6_FILIAL,   "  + CRLF
	cQuery += "       PB6_NUM_PC,   "  + CRLF
	cQuery += "       C7_CONTRA,    "  + CRLF
	cQuery += "       PB6_NUMMED,   "  + CRLF
	cQuery += "       C7_EMISSAO,   "  + CRLF
	cQuery += "       A2_NOME,      "  + CRLF
	cQuery += "       UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PB6_MOTIVO, 4000, 1))PB6_MOTIVO,  "  + CRLF
	cQuery += "       PB6_DTGRAV    "  + CRLF
	cQuery += "FROM   " + RetSqlName("PB6") + " PB6 "                   + CRLF
	cQuery += "       INNER JOIN " + RetSqlName("SC7") + " SC7 "        + CRLF
	cQuery += "               ON C7_FILIAL = PB6_FILIAL   "             + CRLF
	cQuery += "                  AND C7_NUM = PB6_NUM_PC  "             + CRLF
	cQuery += "                  AND C7_EMISSAO >= '" + dToS(cMV_par03) + "' " + CRLF
	cQuery += "                  AND C7_EMISSAO <= '" + dToS(cMV_par04) + "' " + CRLF
	cQuery += "                  AND SC7.D_E_L_E_T_ = '*' "             + CRLF
	cQuery += "       INNER JOIN " + RetSqlName("SA2") + " SA2 "        + CRLF
	cQuery += "               ON A2_FILIAL = '" + xFilial('SA2') + "' " + CRLF
	cQuery += "                  AND A2_COD = C7_FORNECE  "  + CRLF 
	cQuery += "                  AND A2_LOJA = C7_LOJA    "  + CRLF
	cQuery += "                  AND SA2.D_E_L_E_T_ = ' ' "  + CRLF
	cQuery += "WHERE  PB6.D_E_L_E_T_ = ' ' "          + CRLF
	cQuery += "       AND PB6_FILIAL >= '" + cMV_par01 + "' " + CRLF
	cQuery += "       AND PB6_FILIAL <= '" + cMV_par02 + "' " + CRLF
	cQuery += "ORDER  BY PB6_NUM_PC "  + CRLF
	
	cShowQry := cQuery
	cQuery   := ChangeQuery(cQuery)
	
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasA, .F., .T.)
	
	IF .NOT. Eof( cAliasA )
		A010Rej( cAliasA,cMV_par05 )
	Else
		MsgAlert('A query não retornou registros, por favor verifique os parâmetros informados.', cTitulo)
	EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Excel | Autor | Rafael Beghini | Data | 19/02/2016 
//+-------------------------------------------------------------------+
//| Descr. | Gera o arquivo XML conforme query realizada. 
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A010Rej( cAliasA,cMV_par05 )
	Local cWorkSheet := "Capa_rejeitada"
	Local cTable     := aOpca[ MV_par05 ] 
	Local cFornece   := ''
	Local cAprov     := ''
	Local cStatus    := ''
	Local cPath      := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile  := cPath + 'Capa_rejeitada_' + dToS(Date()) + ".XML"
	Local oExcel     := Nil
	
	oExcel := FWMSEXCEL():New() //Método para geração em XML
	
	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//AddColumn( cWorkSheet, cTable, < cColumn >     , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Filial"         , 1     , 1       , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nº Pedido"      , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nº Contrato"    , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nº Medição"     , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Emissão"        , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Fornecedor"     , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Motivo Rejeição", 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data"           , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Situação"      , 1     , 3	   , .F. )
	
	//nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada
	
	While .NOT. Eof( cAliasA )
		
		oExcel:AddRow( cWorkSheet, cTable, { (cAliasA)->PB6_FILIAL,  (cAliasA)->PB6_NUM_PC, (cAliasA)->C7_CONTRA, (cAliasA)->PB6_NUMMED, sToD((cAliasA)->C7_EMISSAO),;
			                                (cAliasA)->A2_NOME, (cAliasA)->PB6_MOTIVO, sToD( (cAliasA)->PB6_DTGRAV ), cTable } )
	(cAliasA)->( dbSkip() )
	End
	
	(cAliasA)->( dbCloseArea() )
		
	oExcel:Activate()              //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
	
	ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela após salvar	
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Aprov | Autor | Rafael Beghini | Data | 19/02/2016 
//+-------------------------------------------------------------------+
//| Descr. | Retorna o nome do Aprovador 
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A010Aprov( cFilCR, cNUMPED, cStatus )
	Local cSQL    := ''
	Local cRet    := ''
	Local aArea   := GetArea() 	
	Local cAliasB := GetNextAlias()
	
	cSQL += "SELECT Trim(ak_nome) NOME " + CRLF
	cSQL += "FROM   " + RetSqlName('SCR') + " CR " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName('SAK') + " AK " + CRLF
	cSQL += "               ON ak_filial = ' ' " + CRLF
	cSQL += "                  AND ak_cod = cr_aprov " + CRLF
	cSQL += "                  AND ak.d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "WHERE  cr.d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "       AND cr_filial = '" + cFilCR + "' " + CRLF
	cSQL += "       AND cr_num = '" + cNUMPED + "'" + CRLF
	cSQL += "       AND cr_tipo = 'PC' " + CRLF
	cSQL += "       AND cr_status = '" + cStatus + "'" + CRLF
	cSQL += "ORDER  BY cr_aprov " + CRLF

	cSQL := ChangeQuery(cSQL)
	
	IF Select( cAliasB ) > 0
		dbSelectArea( cAliasB )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), cAliasB, .F., .T.)
	
	IF .NOT. Eof( cAliasB )
		While .NOT. Eof( cAliasB )
			cRet += Upper( rTrim( (cAliasB)->NOME ) ) + ', '
		(cAliasB)->( dbSkip() )
		End
	Else
		cRet := 'Não encontrado grupo de aprovação'
	EndIF
	(cAliasB)->( dbCloseArea() )
	RestArea(aArea)		
Return( cRet )

Static Function A020APROV( cFilCR, cNUMPED )
	Local cSQL    := ''
	Local cRet    := ''
	Local aArea   := GetArea() 	
	Local cAliasC := GetNextAlias()
	
	cSQL += "SELECT DISTINCT utl_raw.Cast_to_varchar2(dbms_lob.Substr(cr_log, 4000, 1)) CR_LOG " + CRLF
	cSQL += "FROM   scr010 " + CRLF
	cSQL += "WHERE  d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "       AND cr_filial = '" + cFilCR + "' " + CRLF
	cSQL += "       AND cr_num = '" + cNUMPED + "'" + CRLF
	cSQL += "       AND cr_tipo = '#2' " + CRLF
	cSQL += "       AND cr_status = '03' " + CRLF
	
	cSQL := ChangeQuery(cSQL)
	
	IF Select( cAliasC ) > 0
		dbSelectArea( cAliasC )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), cAliasC, .F., .T.)
	
	IF .NOT. Eof( cAliasC )
		While .NOT. Eof( cAliasC )
			cRet := rTrim( (cAliasC)->CR_LOG )
		(cAliasC)->( dbSkip() )
		End
	EndIF
	(cAliasC)->( dbCloseArea() )
	RestArea(aArea)		
Return( cRet )