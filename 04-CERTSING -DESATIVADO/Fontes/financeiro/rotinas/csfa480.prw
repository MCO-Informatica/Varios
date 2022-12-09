//---------------------------------------------------------------------------------
// Rotina | CSFA480    | Autor | Robson Gonçalves               | Data | 13.01.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para extrair os registros de faturamento e certificados não 
//        | emitidos.
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
#Include 'Protheus.Ch'

User Function CSFA480()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	Private cCadastro := 'Pedidos faturados e não emitidos'
	
	AAdd( aSay, 'Esta rotina tem por objetivo em gerar planilha de dados dos pedidos faturados e com' )
	AAdd( aSay, 'certificados não emitidos' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Caso seja confirmado nos parâmetros para consultar o GAR on-line, a rotina irá' )
	AAdd( aSay, 'processar por um tempo maior. ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
   
	If nOpcao==1
		A480Param()
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A480Param  | Autor | Robson Gonçalves               | Data | 13.01.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para solicitar ao usuário as informações por meio de parâmetros
//        | para o processamento.
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A480Param()
	Local aParamBox := {}
	Local aPergRet := {}
	Local aConsult := {'1=Não','2=Sim'}
	
	Local lRet := .F.
	Local lExiste := .F.
	
	Local cFile := ''
	
	Local nErro := 0
	
	AAdd(aParamBox,{1,'Data de emissão de '    ,Ctod(Space(8)),'','','','',50,.F.})
	AAdd(aParamBox,{1,'Data de emissão até '   ,Ctod(Space(8)),'','','','',50,.F.})
	AAdd(aParamBox,{2,'Consultar o GAR on-line',1,aConsult,70,'',.F.})
	
	If ParamBox(aParamBox,'Parâmetros',aPergRet,,,,,,,,.T.,.T.)
		MV_PAR03 := Iif(ValType(MV_PAR03)=="C",Val(SubStr(MV_PAR03,1,1)),MV_PAR03)
		cFile := CriaTrab(NIL,.F.)+'.xml'
		lExiste := File( cFile )	
		If lExiste
			nErro := FErase( cFile )
		Endif
		If lExiste .And. nErro == -1
			MsgAlert('Problemas ao tentar gerar o arquivo Excel. Verifique se há planilha está aberta e tente novamente.',cCadastro)
		Else
			Processa( {|| A480Process( cFile ) }, cCadastro,'Gerando planilha...', .F. )
		Endif
   Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A480Process| Autor | Robson Gonçalves               | Data | 13.01.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina de processamento principal da extração de dados.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A480Process( cFile )
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	Local cWorkSheet := 'PedidosFaturadosENãoEmitidos'
	Local cTable := cCadastro
	Local cDir := ''
	Local cDirTmp := ''
	Local oFwMsEx	
	Local oExcelApp
	Local oWsObj
	Local lDtVal := .F.
	Local lDtEmis := .F.
	
	cSQL := "SELECT * "
	cSQL += "FROM   (SELECT D2_COD     PRODUTO, "
	cSQL += "					D2_CODISS  CODISS, "
	cSQL += "					D2_SERIE   SERIE, "
	cSQL += "					D2_DOC     DOC, "
	cSQL += "					D2_EMISSAO EMISSAO, "
	cSQL += "					C5_CHVBPAG PEDGAR, "
	cSQL += "					Z5_DATVAL  DATVAL, "
	cSQL += "					Z5_DATVER  DATVER, "
	cSQL += "					Z5_DATEMIS DATEMIS, "
	cSQL += "					D2_TOTAL   TOTAL, "
	cSQL += "					D2_VALDEV, "
	cSQL += "					CASE "
	cSQL += "					  WHEN D2_BASEISS > 0 THEN 0 "
	cSQL += "					  ELSE D2_BASEICM "
	cSQL += "					END        BASEICMS, "
	cSQL += "					CASE "
	cSQL += "					  WHEN D2_BASEISS > 0 THEN 0 "
	cSQL += "					  ELSE D2_VALICM "
	cSQL += "					END        VALICMS, "
	cSQL += "					D2_BASIMP5 BASECOFINS, "
	cSQL += "					D2_VALIMP5 COFINS, "
	cSQL += "					D2_BASIMP6 BASEPIS, "
	cSQL += "					D2_VALIMP6 PIS, "
	cSQL += "					D2_BASEISS BASEISS, "
	cSQL += "					D2_VALISS  ISS "	
	cSQL += "		  FROM   "+RetSqlName("SD2")+" SD2, "
	cSQL += "					"+RetSqlName("SC6")+" SC6, "
	cSQL += "					"+RetSqlName("SC5")+" SC5 "
	cSQL += "					LEFT JOIN "+RetSqlName("SZ5")+" SZ5 "
	cSQL += "							 ON Z5_FILIAL = ' ' "
	cSQL += "								 AND Z5_PEDGAR = C5_CHVBPAG "
	cSQL += "								 AND SZ5.D_E_L_E_T_ = ' ' "
	cSQL += "								 AND Z5_PEDGAR > ' ' "
	cSQL += "		  WHERE  D2_FILIAL = "+ValToSql(xFilial("SD2"))+" "
	cSQL += "					AND D2_EMISSAO >= "+ValToSql(MV_PAR01)+" "
	cSQL += "					AND D2_EMISSAO <= "+ValToSql(MV_PAR02)+" "
	cSQL += "					AND SD2.D_E_L_E_T_ = ' ' "
	cSQL += "					AND C6_FILIAL = D2_FILIAL "
	cSQL += "					AND C6_NUM = D2_PEDIDO "
	cSQL += "					AND C6_ITEM = D2_ITEMPV "
	cSQL += "					AND SC6.D_E_L_E_T_ = ' ' "
	cSQL += "					AND C5_FILIAL = C6_FILIAL "
	cSQL += "					AND C5_NUM = C6_NUM "
	cSQL += "					AND SC5.D_E_L_E_T_ = ' ' "
	cSQL += "					AND C5_CHVBPAG > ' ' "
	cSQL += "					AND ( Z5_DATEMIS = ' ' "
	cSQL += "							 OR Z5_DATEMIS IS NULL )) "
	cSQL += "WHERE  ( SERIE = '2' "
	cSQL += "			AND ( DATVAL = ' ' "
	cSQL += "					 OR DATVAL IS NULL ) ) "
	cSQL += "		  OR ( SERIE = 'RP2' "
	cSQL += "				 AND ( DATEMIS = ' ' "
	cSQL += "						  OR DATEMIS IS NULL ) ) "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando os dados...')

	If (cTRB)->( BOF() .And. EOF() )
		MsgInfo('Não foi possível localizar dados com os parâmetros informados.',cCadastro)
		(cTRB)->( dbCloseArea() )
	Else   
		ProcRegua( 0 )
		
		oFwMsEx := FWMsExcel():New()
		
	   oFwMsEx:AddWorkSheet( cWorkSheet )
	   oFwMsEx:AddTable( cWorkSheet, cTable )	
	
		// cWorkSheet -> Nome da planilha
		// cTable -----> Título da tabela
		// cColumn ----> Titulo da tabela que será adicionada
		// nAlign -----> Alinhamento da coluna ( 1-Left,2-Center,3-Right )
		// nFormat ----> Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
		// lTotal -----> Indica se a coluna deve ser totalizada
		
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Poduto'        , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Cod.ISS'       , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Série'         , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Documento'     , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Emissão'       , 2,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Pedido GAR'    , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Dt.Validação'  , 2,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Dt.Verificação', 2,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Dt.Emissão'    , 2,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Vlr.Total'     , 3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Vlr.Devolvido' , 3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Base ICMS'     , 3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Vlr.ICMS'      , 3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Base COFINS'   , 3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Vlr.COFINS'    , 3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Base PIS'      , 3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Vlr.PIS'       , 3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Base ISS'      , 3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , 'Vlr.ISS'       , 3,2)
		
		If MV_PAR03==2
			oWsObj := WSIntegracaoGARERPImplService():New()
		Endif
		
		While (cTRB)->( .NOT. EOF() )
			IncProc()
			
			// É para consultar o GAR
			If MV_PAR03==2
				A480ConsGAR( cTRB, oWsObj, @lDtVal, @lDtEmis )
				// Se tem data de validação, ir para o próximo registro.
				If RTrim( (cTRB)->SERIE ) == '2' .AND. lDtVal
					(cTRB)->( dbSkip() )
					Loop
				Endif
				// Se tem data de emissao, ir para o próximo registro.
				If (cTRB)->SERIE == 'RP2' .AND. lDtEmis
					(cTRB)->( dbSkip() )
					Loop
				Endif
			Else
				// Não é para consultar o GAR, mesmo assim efetuar as criticas.
				// Se tem data de validação, ir para o próximo registro.
				If RTrim( (cTRB)->SERIE ) == '2' .AND. .NOT. Empty( (cTRB)->DATVAL )
					(cTRB)->( dbSkip() )
					Loop
				Endif				
				// Não é para consultar o GAR, mesmo assim efetuar as criticas.
				// Se tem data de emissao, ir para o próximo registro.
				If (cTRB)->SERIE == 'RP2' .AND. .NOT. Empty( (cTRB)->DATEMIS )
					(cTRB)->( dbSkip() )
					Loop
				Endif
			Endif
			

			oFwMsEx:AddRow( cWorkSheet, cTable, { (cTRB)->PRODUTO,;
			                                      (cTRB)->CODISS,;
			                                      (cTRB)->SERIE,;
			                                      (cTRB)->DOC,;
			                                      Dtoc(Stod((cTRB)->EMISSAO)),;
						                             (cTRB)->PEDGAR,;
			                                      Dtoc(Stod((cTRB)->DATVAL)),;
			                                      Dtoc(Stod((cTRB)->DATVER)),;
			                                      Dtoc(Stod((cTRB)->DATEMIS)),;
			                                      (cTRB)->TOTAL,;
			                                      (cTRB)->D2_VALDEV,;
			                                      (cTRB)->BASEICMS,;
			                                      (cTRB)->VALICMS,;
			                                      (cTRB)->BASECOFINS,;
			                                      (cTRB)->COFINS,;
			                                      (cTRB)->BASEPIS,;
			                                      (cTRB)->PIS,;
			                                      (cTRB)->BASEISS,;
			                                      (cTRB)->ISS } )
		
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
// Rotina | A480ConsGAR| Autor | Robson Gonçalves               | Data | 13.01.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para consultar on-line o GAR e atualizar a tabela de 
//        | sincronismo.
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A480ConsGAR( cTRB, oWsObj, lDtVal, lDtEmis )	
	Local oObj
	lDtVal  := .F.
	lDtEmis := .F. 
	SZ5->( dbSetOrder( 1 ) )
	If SZ5->( dbSeek( xFilial( 'SZ5' ) + (cTRB)->PEDGAR) )
		If oWsObj:findDadosPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
								   eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
								   Val( (cTRB)->PEDGAR ) )
			SZ5->( RecLock( 'SZ5', .F. ) )
			// Pedido GAR Anterior
			If Empty(SZ5->Z5_PEDGANT)
				If ValType(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO) <> "U"				
					SZ5->Z5_PEDGANT := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO))
				Endif
			EndIf
			
			//Certificado
			If Empty(SZ5->Z5_PRODGAR)
				If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTO) <> "U"
					SZ5->Z5_PRODGAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTO)
				Endif
			Endif
			
			If Empty(SZ5->Z5_PRODUTO)
				If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTO) <> "U"
					SZ5->Z5_PRODUTO := GetAdvFval('PA8','PA8_CODMP8',XFILIAL('PA8')+ALLTRIM(SZ5->Z5_PRODGAR), 1,'')
				Endif
			Endif
			
			//DECRICAO do Certificado
			If Empty(SZ5->Z5_DESPRO)
				If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC) <> "U"
					SZ5->Z5_DESPRO := AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC)
				Endif
			Endif
			
			//CNPJ do Certificado
			If Empty(SZ5->Z5_CNPJ)
				If ValType(oWSObj:OWSDADOSPEDIDO:NCNPJCERT) <> "U"
					SZ5->Z5_CNPJ := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCNPJCERT))
				Endif
			Endif
			
			If Empty(SZ5->Z5_CNPJCER)
				If ValType(oWSObj:OWSDADOSPEDIDO:NCNPJCERT) <> "U"
					SZ5->Z5_CNPJCER := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCNPJCERT))
				Endif
			Endif
			
			//Status do Pedido
			If ValType(oWSObj:OWSDADOSPEDIDO:cStatus) <> "U"
				SZ5->Z5_STATUS := AllTrim(oWSObj:OWSDADOSPEDIDO:cStatus)
			EndIf
			
			//Codigo do Parceiro
			If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO) <> "U"
				If Empty(SZ5->Z5_CODPAR)
					SZ5->Z5_CODPAR := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO))
				Endif
			EndIf
			
			//Codigo do Parceiro
			If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO) <> "U"
				If Empty(SZ5->Z5_NOMPAR)
					SZ5->Z5_NOMPAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO)
				Endif
			Endif
			
			//Codigo do Parceiro
			If ValType(oWSObj:OWSDADOSPEDIDO:CREDEPARCEIRO) <> "U"
				If Empty(SZ5->Z5_DESREDE)
					SZ5->Z5_DESREDE := AllTrim(oWSObj:OWSDADOSPEDIDO:CREDEPARCEIRO)
				Endif
			EndIf
			
			//Descricao AC do Pedido
			If ValType(oWSObj:OWSDADOSPEDIDO:CACDESC) <> "U"
				If Empty(SZ5->Z5_DESCAC)
					SZ5->Z5_DESCAC := AllTrim(oWSObj:OWSDADOSPEDIDO:CACDESC)
				Endif
			EndIf
			
			//Descricao AR de Pedido
			If ValType(oWSObj:OWSDADOSPEDIDO:CARDESC) <> "U"
				If Empty(SZ5->Z5_DESCARP)
					SZ5->Z5_DESCARP := AllTrim(oWSObj:OWSDADOSPEDIDO:CARDESC)
				Endif
			EndIf
			
			//Codigo AR de Pedido
			If ValType(oWSObj:OWSDADOSPEDIDO:CARID) <> "U"
				If Empty(SZ5->Z5_CODARP)
					SZ5->Z5_CODARP := AllTrim(oWSObj:OWSDADOSPEDIDO:CARID)
				Endif
			EndIf
			
			//Deve ser a AR de VERIFICACAO
			//Descricao AR de Validacao
			If ValType(oWSObj:OWSDADOSPEDIDO:CARVALIDACAODESC) <> "U"
				If Empty(SZ5->Z5_DESCAR)
					SZ5->Z5_DESCAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CARVALIDACAODESC)
				Endif
			EndIf
			
			//Deve ser a AR de VERIFICACAO
			//Codigo AR de Validacao
			If ValType(oWSObj:OWSDADOSPEDIDO:CARVALIDACAO) <> "U"
				If Empty(SZ5->Z5_CODAR)
					SZ5->Z5_CODAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CARVALIDACAO)
				Endif
			EndIf
			
			//Data de Emissao do Pedido GAR
			If ValType(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO) <> "U"
				If Empty(SZ5->Z5_DATEMIS)
					SZ5->Z5_DATEMIS := CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO),1,10))+1
				Endif
			EndIf
			
			//Data da Validacao
			If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO) <> "U"
				If Empty(SZ5->Z5_DATVAL)
					SZ5->Z5_DATVAL := CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO),1,10))
				Endif
			EndIf
			
			If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO) <> "U"
				If Empty(SZ5->Z5_DATVER)
					SZ5->Z5_DATVER := CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO),1,10))
				Endif
			EndIf
			
			//Grupo
			If ValType(oWSObj:OWSDADOSPEDIDO:CGRUPO) <> "U"
				If Empty(SZ5->Z5_GRUPO)
					SZ5->Z5_GRUPO := AllTrim(oWSObj:OWSDADOSPEDIDO:CGRUPO)
				Endif
			EndIf
			
			//Descricao do Grupo
			If ValType(oWSObj:OWSDADOSPEDIDO:CGRUPODESCRICAO) <> "U"
				If Empty(SZ5->Z5_DESGRU)
					SZ5->Z5_DESGRU := AllTrim(oWSObj:OWSDADOSPEDIDO:CGRUPODESCRICAO)
				Endif
			EndIf
			
			//Deve ser o Posto de VERIFICACAO
			//Descricao do Posto de Validação
			If ValType(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC) <> "U"
				If Empty(SZ5->Z5_DESPOS)
					SZ5->Z5_DESPOS := AllTrim(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC)
				Endif
			EndIf
			
			//Deve ser o Posto de VERIFICACAO
			//Codigo do posto de validacao
			If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID) <> "U"
				If Empty(SZ5->Z5_CODPOS)
					SZ5->Z5_CODPOS := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID))
				Endif
			EndIf
			
			If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID) <> "U"
				If Empty(SZ5->Z5_POSVER)
					SZ5->Z5_POSVER := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID))
				Endif
			EndIf
			
			//Rede
			If ValType(oWSObj:OWSDADOSPEDIDO:CREDE) <> "U"
				If Empty(SZ5->Z5_REDE)
					SZ5->Z5_REDE := AllTrim(oWSObj:OWSDADOSPEDIDO:CREDE)
				Endif
			EndIf
			
			//Codigo do Revendedor
			If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR) <> "U"
				If Empty(SZ5->Z5_CODVEND)
					SZ5->Z5_CODVEND := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR))
				Endif
			EndIf
			
			//Nome do revendedor
			If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR) <> "U"
				If Empty(SZ5->Z5_NOMVEND)
					SZ5->Z5_NOMVEND := AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR)
				Endif
			EndIf
			
			//Comissão hardware do parceiro
			If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROHW) <> "U"
				SZ5->Z5_COMHW := oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROHW
			EndIf
			
			//Comissão software do parceiro
			If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW) <> "U"
				SZ5->Z5_COMSW := oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW
			EndIf
			
			//CPF do Agente de Validacao
			If ValType(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVALIDACAO) <> "U"
				If Empty(SZ5->Z5_CPFAGE)
					SZ5->Z5_CPFAGE := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVALIDACAO))
				Endif
			EndIf
			
			If ValType(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVERIFICACAO) <> "U"
				If Empty(SZ5->Z5_AGVER)
					SZ5->Z5_AGVER := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVERIFICACAO))
				Endif
			EndIf
			
			//CPF do Titular do Certificado
			If ValType(oWSObj:OWSDADOSPEDIDO:NCPFTITULAR) <> "U"
				If Empty(SZ5->Z5_CPFT)
					SZ5->Z5_CPFT := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFTITULAR))
				Endif
			EndIf
			
			//Email do titular
			If ValType(oWSObj:OWSDADOSPEDIDO:CEMAILTITULAR) <> "U"
				If Empty(SZ5->Z5_EMAIL)
					SZ5->Z5_EMAIL := AllTrim(oWSObj:OWSDADOSPEDIDO:CEMAILTITULAR)
				Endif
			EndIf
			
			//Nome do Agente de Validaï¿½ï¿½o
			If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO) <> "U"
				If Empty(SZ5->Z5_NOMAGE)
					SZ5->Z5_NOMAGE := AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO)
				Endif
			EndIf
			
			If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO) <> "U"
				If Empty(SZ5->Z5_NOAGVER)
					SZ5->Z5_NOAGVER := AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO)
				Endif
			EndIf
			
			//Nome do Titular do Certificado
			If ValType(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR) <> "U"
				If Empty(SZ5->Z5_NTITULA)
					SZ5->Z5_NTITULA := AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR)
				Endif
			EndIf
			
			If ValType(oWSObj:OWSDADOSPEDIDO:CRAZAOSOCIALCERT) <> "U"
				If Empty(SZ5->Z5_RSVALID)
					SZ5->Z5_RSVALID := AllTrim(oWSObj:OWSDADOSPEDIDO:CRAZAOSOCIALCERT)
				Endif
			EndIf
			SZ5->( MsUnLock() )
			
			If RTrim( (cTRB)->SERIE ) == '2'
				If .NOT. Empty( SZ5->Z5_DATVAL )
					lDtVal := .T.
				Endif
			Endif
			
			If (cTRB)->SERIE == 'RP2'
				If .NOT. Empty( SZ5->Z5_DATEMIS )
					lDtEmis := .T.
				Endif
			Endif
		Endif
	Endif
Return