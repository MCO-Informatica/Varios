//---------------------------------------------------------------------------------
// Rotina | CSFA490    | Autor | Robson Gonçalves               | Data | 13.01.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para extrair os registros de certificados validados, emitidos 
//        | e não faturados.
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
#Include 'Protheus.Ch'

User Function CSFA490()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	Private cCadastro := 'Certificados validados, emitidos e não faturados'
	
	AAdd( aSay, 'Esta rotina tem por objetivo em gerar planilha de dados dos certificados validados,' )
	AAdd( aSay, 'emitidos e não faturados' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
   
	If nOpcao==1
		A490Param()
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A490Param  | Autor | Robson Gonçalves               | Data | 13.01.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para solicitar ao usuário as informações por meio de parâmetros
//        | para o processamento.
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A490Param()
	Local aParamBox := {}
	Local aPergRet := {}
	
	Local lRet := .F.
	Local lExiste := .F.
	
	Local cFile := ''
	
	Local nErro := 0
	
	AAdd(aParamBox,{1,'Data de',Ctod(Space(8)),'','','','',50,.F.})
	AAdd(aParamBox,{1,'Data de',Ctod(Space(8)),'','','','',50,.T.})
	
	If ParamBox(aParamBox,'Parâmetros',aPergRet,,,,,,,,.T.,.T.)
		cFile := CriaTrab(NIL,.F.)+'.xml'
		lExiste := File( cFile )	
		If lExiste
			nErro := FErase( cFile )
		Endif
		If lExiste .And. nErro == -1
			MsgAlert('Problemas ao tentar gerar o arquivo Excel. Verifique se há planilha está aberta e tente novamente.',cCadastro)
		Else
			Processa( {|| A490Process( cFile ) }, cCadastro,'Gerando planilha...', .F. )
		Endif
   Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A490Process| Autor | Robson Gonçalves               | Data | 13.01.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina de processamento principal da extração de dados.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A490Process( cFile )
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	Local cWorkSheet := 'CertificadosValidadosEmitidosNãoFaturados'
	Local cTable := cCadastro
	Local cDir := ''
	Local cDirTmp := ''
	Local oFwMsEx	
	Local oExcelApp
	Local oWsObj
	
	ProcRegua( 0 )

	cSQL := "SELECT * "
	cSQL += "FROM   (SELECT Z5_PEDGAR, "
	cSQL += "               Z5_PEDSITE, "
	cSQL += "               Z5_PRODGAR, "
	cSQL += "               Z5_EMISSAO, "
	cSQL += "               Z5_DATVAL, "
	cSQL += "               Z5_DATVER, "
	cSQL += "               Z5_DATEMIS, "
	cSQL += "               Z5_VALOR, "
	cSQL += "               Z5_TIPVOU, "
	cSQL += "               Z5_CODVOU, "
	cSQL += "               C5_NUM, "
	cSQL += "               C5_NOTA, "
	cSQL += "               C6_NOTA, "
	cSQL += "               C6_PRODUTO, "
	cSQL += "               C6_VALOR, "
	cSQL += "               C6_ITEM, "
	cSQL += "               C6_XOPER "
	cSQL += "        FROM   "+RetSqlName("SZ5")+" SZ5 "
	cSQL += "               LEFT JOIN "+RetSqlName("SC5")+" SC5 "
	cSQL += "                      ON C5_FILIAL = "+ValToSql(xFilial("SC5"))+" "
	cSQL += "                         AND C5_CHVBPAG = Z5_PEDGAR "
	cSQL += "                         AND C5_CHVBPAG >' ' "
	cSQL += "                         AND SC5.D_E_L_E_T_ = ' ' "
	cSQL += "               INNER JOIN "+RetSqlName("SC6")+" SC6 "
	cSQL += "                       ON C6_FILIAL = "+ValToSql(xFilial("SC6"))+" "
	cSQL += "                          AND C6_NUM = C5_NUM "
	cSQL += "                          AND C6_XOPER IN ( '61', '62' ) "
	cSQL += "                          AND C6_BLQ = ' ' "
	cSQL += "                          AND SC6.D_E_L_E_T_ = ' ' "
	cSQL += "        WHERE  Z5_FILIAL = '  ' "
	cSQL += "               AND ( ( Z5_DATEMIS BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" AND C6_XOPER = '61' ) "
	cSQL += "                      OR ( Z5_DATVER BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" AND C6_XOPER = '62' ) ) "
	cSQL += "               AND SZ5.D_E_L_E_T_ = ' ') QRY_INI "
	cSQL += "WHERE  C6_NOTA = ' '  "
	cSQL += "       AND Z5_TIPVOU IN ( ' ', 'F' ) "
	cSQL += "       AND Z5_VALOR > 0"
		
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
		
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PEDIDO GAR'           , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PEDIDO SITE'          , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PRODUTO GAR'          , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'EMISSAO'              , 2, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DT VALIDAÇÃO'         , 2, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DT VERIFICAÇÃO'       , 2, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DT EMISSÃO'           , 2, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'VALOR'                , 1, 2 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'TIPO VOUCHER'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'COD VOUCHER'          , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PEDIDO PROTHEUS'      , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'NOTA FISCAL'          , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PRODUTO PROTHEUS'     , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'VALOR DO ITEM'        , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Nº ITEM P.V. PROTHEUS', 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'OPERAÇÃO'             , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'OBSERVAÇÃO'           , 1, 1 )
		
		While (cTRB)->( .NOT. EOF() )
			IncProc()
			
			cObs := ""
			
			SC5->(DbSetOrder(1))
			If !SC5->(DbSeek(xFilial("SC5")+(cTRB)->C5_NUM))
				SC5->(DbOrderNickName("NUMPEDGAR"))
				If SC5->(DbSeek(xFilial("SC5")+(cTRB)->Z5_PEDGAR))
					cObs := "DUPLICIDADE PEDIDO PROTHEUS EXISTENTE "+SC5->C5_NUM
				ELSE
					cObs := "PEDIDO GAR NÃO ENCONTRADO NO PROTHEUS"
				EndIf				
			Else
				If (cTRB)->C6_XOPER == "61" .and. EMPTY((cTRB)->Z5_DATEMIS)
					cObs := "FALTA NOTIFICAÇÃO DE EMISSÃO"
				ElseIf (cTRB)->C6_XOPER == "62" .and. EMPTY((cTRB)->Z5_DATVER)
					cObs := "FALTA NOTIFICAÇÃO DE VERIFICAÇÃO"
				ElseIf (cTRB)->C6_XOPER == "53" 
					cObs := "FALTA NOTA DE ENTREGA DE HARDWARE"
				ElseIf (cTRB)->C6_XOPER == "61" 
					cObs := "FALTA NOTA DE SERVIÇO"
				ElseIf (cTRB)->C6_XOPER == "62" 
					cObs := "FALTA NOTA DE HARDWARE"
				ENDIF
			EndIf
			
			oFwMsEx:AddRow( cWorkSheet, cTable, { (cTRB)->Z5_PEDGAR,;
			                                      (cTRB)->Z5_PEDSITE,;
			                                      (cTRB)->Z5_PRODGAR,;
			                                      Dtoc(Stod((cTRB)->Z5_EMISSAO)),;
			                                      Dtoc(Stod((cTRB)->Z5_DATVAL)),;
			                                      Dtoc(Stod((cTRB)->Z5_DATVER)),;
			                                      Dtoc(Stod((cTRB)->Z5_DATEMIS)),;
			                                      (cTRB)->Z5_VALOR,;
			                                      (cTRB)->Z5_TIPVOU,;
			                                      (cTRB)->Z5_CODVOU,;
			                                      (cTRB)->C5_NUM,;
			                                      (cTRB)->C5_NOTA,;
			                                      (cTRB)->C6_PRODUTO,;
			                                      (cTRB)->C6_VALOR,;
			                                      (cTRB)->C6_ITEM,;
			                                      (cTRB)->C6_XOPER,;
												  cObs} )
			
			(cTRB)->( dbSkip() )
		EndDo
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