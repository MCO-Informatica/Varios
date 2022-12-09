#Include 'Protheus.ch'

User Function vndr030()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	Private cCadastro := 'Acompanhamento de pedidos com diferença de valores entre Total e Itens'
	
	AAdd( aSay, 'Esta rotina tem por objetivo em gerar planilha de dados para acompanhamento de pedidos' )
	AAdd( aSay, 'com diferença de valores entre Total e Itens.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
   
	If nOpcao==1
		r030Param()
	Endif
Return

Static Function r030Param()
	Local aParamBox := {}  
	Local aPergRet := {}
	
	Local lRet := .F.
	Local lExiste := .F.
	
	Local cFile := ''
	
	Local nErro := 0
	
	AAdd(aParamBox,{1,'A partir da Data de Emis.',Ctod(Space(8)),'','','','',50,.F.})
	AAdd(aParamBox,{1,'Até a Data de Emis.',Ctod(Space(8)),'','','','',50,.F.})
	
	If ParamBox(aParamBox,'Parâmetros',aPergRet,,,,,,,,.T.,.T.)
		cFile := CriaTrab(NIL,.F.)+'.xml'
		lExiste := File( cFile )	
		If lExiste
			nErro := FErase( cFile )
		Endif
		If lExiste .And. nErro == -1
			MsgAlert('Problemas ao tentar gerar o arquivo Excel. Verifique se há planilha está aberta e tente novamente.',cCadastro)
		Else
			Processa( {|| A030Process( cFile ) }, cCadastro,'Gerando planilha...', .F. )
		Endif
   Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A570Process| Autor | Robson Gonçalves               | Data | 01.04.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina de processamento principal da extração de dados.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A030Process( cFile )
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	Local cWorkSheet := 'pedidos_com_dif_valor'
	Local cTable := cCadastro
	Local cDir := ''
	Local cDirTmp := ''
	Local oFwMsEx	
	Local oExcelApp
	Local oWsObj
	Local aCBoxPg:= RetSX3Box(Posicione("SX3",2,"C5_TIPMOV","X3CBox()"),,,1)
	
	ProcRegua( 0 )

	cSQL := "SELECT * FROM (" 
	cSQL += "SELECT " 
	cSQL += "  Max(C5_EMISSAO)  DT_EMISSAO, "
	cSQL += "  ' ' DT_AJUSTE, "
	cSQL += "  C5_XNPSITE PEDSITE, " 
	cSQL += "  C5_CHVBPAG PEDGAR, "
	cSQL += "  C5_TOTPED TOTAL_PED, "
	cSQL += "  SUM(C6_VALOR + C6_VALDESC) TOTAL_APURADO, "
	cSQL += "  'NECESSITA DE AJUSTE' OBS, "
	cSQL += "  MAX ((SELECT C5_XCOPIA FROM "+RetSqlName("SC5")+" SC51 WHERE ROWNUM = 1 AND  SC5.C5_FILIAL = SC51.C5_FILIAL AND SC5.C5_XNPSITE = SC51.C5_XNPSITE AND SC51.C5_NOTA <> 'XXXXXX'  AND SC51.C5_SERIE <> 'XXX'  AND  SC51.D_E_L_E_T_ = ' ' AND SC51.C5_XCOPIA =  'S' )) PED_COPIA, "
	cSQL += "  MAX ((SELECT SC61.C6_LOTECTL FROM "+RetSqlName("SC6")+" SC61 WHERE ROWNUM = 1 AND  SC6.C6_FILIAL = SC61.C6_FILIAL AND SC6.C6_NUM = SC61.C6_NUM AND UPPER(SC61.C6_LOTECTL) LIKE '%SYSCORP%'  AND SC61.D_E_L_E_T_<> ' ' )) JOB "
	cSQL += "FROM "
	cSQL += "  "+RetSqlName("SC5")+" SC5 INNER JOIN "+RetSqlName("SC6")+" SC6 ON "
	cSQL += "    C5_FILIAL = '"+xFilial("SC5")+"' AND "
	cSQL += "    C6_FILIAL = '"+xFilial("SC6")+"' AND "
	cSQL += "    C5_NUM = C6_NUM AND "
	cSQL += "    C5_NOTA <> 'XXXXXX' AND "
	cSQL += "    C5_SERIE <> 'XXX' AND "
	cSQL += "    C6_XOPER <> '53' AND "	
	cSQL += "    C5_XNPSITE IN ('30013435','30013436','30013452','30013453','30013454','30013437','30013438','30013456','30013458','30013472','30013476','30013496','30013512') AND "
	//cSQL += "    C6_XOPER IN ('51','52','61','62','  ') AND "
	cSQL += "    SC5.D_E_L_E_T_ = ' ' AND "
	cSQL += "    SC6.D_E_L_E_T_ = ' ' "  
	cSQL += "WHERE "
	cSQL += "  C5_EMISSAO BETWEEN "+ValToSql(MV_PAR01)+"  AND "+ValToSql(MV_PAR02)+"  AND "
	cSQL += "  C5_TIPMOV <> '6' " 
	cSQL += "GROUP BY " 
	//cSQL += "  C5_EMISSAO, "
	cSQL += "  C5_XNPSITE, " 
	cSQL += "  C5_CHVBPAG, "
	cSQL += "  C5_TOTPED "
	cSQL += "HAVING " 
	cSQL += "  (C5_TOTPED) > SUM(C6_VALOR + C6_VALDESC) OR SUM(C6_VALOR + C6_VALDESC) > (C5_TOTPED)  " 
	cSQL += "UNION " 
	cSQL += "SELECT " 
	cSQL += "  C5_EMISSAO, "
	cSQL += "  GT_DATE, "
	cSQL += "  C5_XNPSITE, " 
	cSQL += "  C5_CHVBPAG, "
	cSQL += "  C5_TOTPED, "
	cSQL += "  SUM(C6_VALOR + C6_VALDESC), "
	cSQL += "  'AJUSTE REALIZADO' , "
	cSQL += "  MAX ((SELECT C5_XCOPIA FROM "+RetSqlName("SC5")+" SC51 WHERE ROWNUM = 1 AND SC5.C5_FILIAL = SC51.C5_FILIAL AND SC5.C5_XNPSITE = SC51.C5_XNPSITE AND SC51.C5_NOTA <> 'XXXXXX'  AND SC51.C5_SERIE <> 'XXX'  AND  SC51.D_E_L_E_T_ = ' ' AND SC51.C5_TOTPED =  0 )) PED_COPIA, "
	cSQL += "  MAX ((SELECT SC61.C6_LOTECTL FROM "+RetSqlName("SC6")+" SC61 WHERE ROWNUM = 1 AND  SC6.C6_FILIAL = SC61.C6_FILIAL AND SC6.C6_NUM = SC61.C6_NUM AND UPPER(SC61.C6_LOTECTL) LIKE '%SYSCORP%'  AND SC61.D_E_L_E_T_<> ' ' )) JOB "
	cSQL += "FROM "
	cSQL += "  "+RetSqlName("SC5")+" SC5 INNER JOIN "+RetSqlName("SC6")+" SC6 ON "
	cSQL += "    C5_FILIAL = '"+xFilial("SC5")+"' AND "
	cSQL += "    C6_FILIAL = '"+xFilial("SC6")+"' AND "
	cSQL += "    C5_NUM = C6_NUM AND "
	cSQL += "    C6_XOPER <> '53' AND "
	cSQL += "    C5_XNPSITE IN ('30013435','30013436','30013452','30013453','30013454','30013437','30013438','30013456','30013458','30013472','30013476','30013496','30013512') AND "
	//cSQL += "    C6_XOPER IN ('51','52','61','62','  ') AND "
	cSQL += "    SC5.D_E_L_E_T_ = ' ' AND "
	cSQL += "    SC6.D_E_L_E_T_ = ' '  INNER JOIN PROTHEUS.GTIN  GTIN ON "
	cSQL += "      GT_TYPE = 'A' AND "
	cSQL += "      NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM,2000,1)),'') LIKE '%Pedido Ja existe no Sistema Protheus e será alterado%' AND "
	cSQL += "      C5_XNPSITE = GT_XNPSITE AND "
	cSQL += "      C6_SUGENTR = GT_DATE "
	cSQL += "WHERE "
	cSQL += "  GT_DATE BETWEEN "+ValToSql(MV_PAR01)+"  AND "+ValToSql(MV_PAR02)+"  AND "
	cSQL += "  C5_TIPMOV <> '6' "
	cSQL += "GROUP BY "
	cSQL += "  C5_EMISSAO, "
	cSQL += "  GT_DATE, "
	cSQL += "  C5_XNPSITE, "
	cSQL += "  C5_CHVBPAG, "
	cSQL += "  C5_TOTPED "
	cSQL += "ORDER BY " 
	cSQL += " DT_AJUSTE, "
	cSQL += " DT_EMISSAO )"
	cSQL += " WHERE PEDSITE <> ' '"
	
	
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
		
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DT_EMISSAO	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DT_AJUSTE	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PEDSITE	    '         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PEDGAR   	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'TOTAL_PED	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'TOTAL_APURADO'        , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'OBS     	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PEDIDO COPIADO'       , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'EXCULIDO JOB'         , 1, 1 )
		
		While (cTRB)->( .NOT. EOF() )
			IncProc()
			oFwMsEx:AddRow( cWorkSheet, cTable,  {;
			Dtoc(Stod((cTRB)->DT_EMISSAO))	,;
			Dtoc(Stod((cTRB)->DT_AJUSTE))	,;
			(cTRB)->PEDSITE	,;
			(cTRB)->PEDGAR	,;
			(cTRB)->TOTAL_PED	,;
			(cTRB)->TOTAL_APURADO	,;
			(cTRB)->OBS ,;
			(cTRB)->PED_COPIA,;
			(cTRB)->JOB	})
			
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
