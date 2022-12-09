//---------------------------------------------------------------------------------
// Rotina | CSFA570    | Autor | Robson Gonçalves               | Data | 01.04.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para extrair os registros de de acompanhamento de pedidos de 
//        | voucher não faturados.
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
#Include 'Protheus.Ch'

User Function CSFA570()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	Private cCadastro := 'Acompanhamento de pedidos de voucher não faturados'
	
	AAdd( aSay, 'Esta rotina tem por objetivo em gerar planilha de dados para acompanhamento de pedidos' )
	AAdd( aSay, 'de voucher não faturados.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
   
	If nOpcao==1
		A570Param()
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A570Param  | Autor | Robson Gonçalves               | Data | 01.04.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para solicitar ao usuário as informações por meio de parâmetros
//        | para o processamento.
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A570Param()
	Local aParamBox := {}
	Local aPergRet := {}
	
	Local lRet := .F.
	Local lExiste := .F.
	
	Local cFile := ''
	
	Local nErro := 0
	
	AAdd(aParamBox,{1,'A partir da data',Ctod(Space(8)),'','','','',50,.F.})
	AAdd(aParamBox,{3,'Somente pendência',1,{'Sim','Não'},50,"",.F.})
	AAdd(aParamBox,{1,'A partir da Data de Fat.',Ctod(Space(8)),'','','','MV_PAR02 == 2',50,.F.})
	AAdd(aParamBox,{1,'Até a Data de Fat.',Ctod(Space(8)),'','','','MV_PAR02 == 2',50,.F.})
	
	If ParamBox(aParamBox,'Parâmetros',aPergRet,,,,,,,,.T.,.T.)
		cFile := CriaTrab(NIL,.F.)+'.xml'
		lExiste := File( cFile )	
		If lExiste
			nErro := FErase( cFile )
		Endif
		If lExiste .And. nErro == -1
			MsgAlert('Problemas ao tentar gerar o arquivo Excel. Verifique se há planilha está aberta e tente novamente.',cCadastro)
		Else
			Processa( {|| A570Process( cFile ) }, cCadastro,'Gerando planilha...', .F. )
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
Static Function A570Process( cFile )
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	Local cWorkSheet := 'Acomp_Pedidos_Voucher_Nao_Faturados'
	Local cTable := cCadastro
	Local cDir := ''
	Local cDirTmp := ''
	Local oFwMsEx	
	Local oExcelApp
	Local oWsObj
	Local aCBoxPg:= RetSX3Box(Posicione("SX3",2,"C5_TIPMOV","X3CBox()"),,,1)
	
	ProcRegua( 0 )

	cSQL += "SELECT SZ5.Z5_PEDGANT PED_GAR_ANT,	"
	cSQL += "       SZ5.Z5_PEDGAR   PED_GAR_V, "
	cSQL += "       SZ5.Z5_DATVAL   DT_VAL_V,	"
	cSQL += "       SZ5.Z5_DATVER   DT_VER_V,	"
	cSQL += "       SZ5.Z5_DATEMIS  DT_EMIS_V, "
	cSQL += "       SZF.ZF_COD      COD_V,	"
	cSQL += "       SZF.ZF_TIPOVOU  TP_V,"
	cSQL += "       SZF.ZF_PEDIDO   PED_GAR_ORIG, "
	cSQL += "       SC5.C5_NUM      PRD_PROTHEUS_ORIG,	"
	cSQL += "       SC5.C5_TIPMOV	FOR_PAG_PED_ORIG, 
	cSQL += "       SC5.C5_EMISSAO  DT_PED_PROTHEUS_ORIG,	"
	cSQL += "       SC6.C6_XOPER    OPER_CERT, "
	cSQL += "       SC6.C6_SERIE    SERIE_FAT, "
	cSQL += "       SC6.C6_NOTA     NOTA_FAT, "
	cSQL += "       SC6.C6_VALOR    VLR_FAT_ORIG,"
	cSQL += "       SC6.C6_DATFAT   DAT_FAT, "
	cSQL += "       SC5.C5_XCODAUT  AUT_CART, "
	cSQL += "       SC5.C5_XRECPG   RECIBO "
	cSQL += "FROM   "+RetSqlName("SZ5")+" SZ5 "
	cSQL += "       INNER JOIN "+RetSqlName("SZG")+" SZG "
	cSQL += "               ON SZG.ZG_FILIAL = "+ValToSql(xFilial("SZG"))+" "
    cSQL += "                  AND SZ5.Z5_PEDGAR = SZG.ZG_NUMPED "
    cSQL += "                  AND SZG.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SZF")+" SZF "
	cSQL += "               ON SZF.ZF_FILIAL = "+ValToSql(xFilial("SZF"))+" "
	cSQL += "                  AND SZG.ZG_NUMVOUC = SZF.ZF_COD "
	cSQL += "                  AND SZF.ZF_PEDIDO > ' ' "
	cSQL += "                  AND SZF.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SC5")+" SC5 "
	cSQL += "               ON SC5.C5_FILIAL = "+ValToSql(xFilial("SC5"))+" "
	cSQL += "                  AND SZF.ZF_PEDIDO = SC5.C5_CHVBPAG "
	cSQL += "                  AND SC5.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SC6")+" SC6 "
	cSQL += "               ON SC6.C6_FILIAL = "+ValToSql(xFilial("SC6"))+" "
	cSQL += "                  AND SC5.C5_NUM = SC6.C6_NUM "
	cSQL += "                  AND SC6.C6_BLQ = ' ' "
	cSQL += "                  AND SC6.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  SZ5.Z5_FILIAL = "+ValToSql(xFilial("SZ5"))+" "
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' "
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' "
	cSQL += "       AND ( SZ5.Z5_DATVER >= "+ValToSql(MV_PAR01)+" " 
	cSQL += "              OR SZ5.Z5_DATEMIS >= "+ValToSql(MV_PAR01)+" ) "
	If MV_PAR02 == 1 // Somente pendência? 1=Sim.
		cSQL += "       AND ( ( SZ5.Z5_DATVER >= "+ValToSql(MV_PAR01)+" "
		cSQL += "               AND SC6.C6_XOPER IN( '62', '53' ) "
		cSQL += "               AND SC6.C6_DATFAT = ' ' ) "
		cSQL += "              OR ( SZ5.Z5_DATEMIS >= "+ValToSql(MV_PAR01)+" "
		cSQL += "                   AND SC6.C6_XOPER = '61' "
		cSQL += "                   AND SC6.C6_DATFAT = ' ' ) ) "
	ElseIf !Empty(MV_PAR03) .and. !Empty(MV_PAR04)
		cSQL += "       AND ( ( SZ5.Z5_DATVER >= "+ValToSql(MV_PAR01)+" "
		cSQL += "               AND SC6.C6_XOPER IN( '62', '53' ) "
		cSQL += "               AND SC6.C6_DATFAT >= "+ValToSql(MV_PAR03)+" AND SC6.C6_DATFAT <= "+ValToSql(MV_PAR04)+" ) "
		cSQL += "              OR ( SZ5.Z5_DATEMIS >= "+ValToSql(MV_PAR01)+" "
		cSQL += "                   AND SC6.C6_XOPER = '61' "
		cSQL += "                   AND SC6.C6_DATFAT >= "+ValToSql(MV_PAR03)+" AND SC6.C6_DATFAT <= "+ValToSql(MV_PAR04)+" ) ) "
		
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
		
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PED_GAR_ANT	'      , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PED_GAR_V	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DT_VAL_V	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DT_VER_V	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DT_EMIS_V	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'COD_V	'            , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'TP_V	'               , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PED_GAR_ORIG	'      , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'PRD_PROTHEUS_ORIG	', 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'FOR_PAG_PED_ORIG', 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DT_PED_PROTHEUS_ORIG', 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'OPER_CERT	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'SERIE_FAT	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'NOTA_FAT	'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'VLR_FAT_ORIG	'      , 3, 2 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'DAT_FAT	'            , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'AUT_CART'            , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'RECIBO'            , 1, 1 )
		
		While (cTRB)->( .NOT. EOF() )
			IncProc()
			oFwMsEx:AddRow( cWorkSheet, cTable,  {;
			(cTRB)->PED_GAR_ANT	,;
			(cTRB)->PED_GAR_V	,;
			Dtoc(Stod((cTRB)->DT_VAL_V))	,;
			Dtoc(Stod((cTRB)->DT_VER_V))	,;
			Dtoc(Stod((cTRB)->DT_EMIS_V))	,;
			(cTRB)->COD_V	,;
			(cTRB)->TP_V	,;
			(cTRB)->PED_GAR_ORIG	,;
			(cTRB)->PRD_PROTHEUS_ORIG	,;
			aCBoxPg[Ascan(aCBoxPg,{|x| x[2] == (cTRB)->FOR_PAG_PED_ORIG }),1],;
			Dtoc(Stod((cTRB)->DT_PED_PROTHEUS_ORIG)),;
			(cTRB)->OPER_CERT	,;
			(cTRB)->SERIE_FAT	,;
			(cTRB)->NOTA_FAT	,;
			(cTRB)->VLR_FAT_ORIG	,;
			Dtoc(Stod((cTRB)->DAT_FAT)),;
			(cTRB)->AUT_CART,;
			(cTRB)->RECIBO	})
			
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