#Include 'Protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | CSGCT070 | Autor | Rafael Beghini | Data | 22.08.2016 
//+-------------------------------------------------------------------+
//| Descr. | Relatório de Contratos a vencer
//|        | utilizando a função FWMsExcel
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSGCT070()
	Local nOpc   := 0
	Local aRet   := {}
	Local aParamBox := {}
	
	Private cCadastro := "Contratos a vencer/reajuste - CertiSign"
	Private cShowQry := ''
	Private aSay     := {}
	Private aButton  := {}
	Private oExcel   := Nil
	Private lShowQry := .F.
	
	AAdd( aSay, "Esta rotina irá imprimir o relatorio dos contratos de compra/vendas", )
	AAdd( aSay, "com a data de vencimento e/ou data de reajuste,")
	AAdd( aSay, "conforme parâmetros informados pelo usuário."                )
	aAdd( aSay, ""                                                            )
	aAdd( aSay, "Ao final do processamento, é gerado uma planilha com as informações." )
	
	aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() } } )
	aAdd( aButton, { 2, .T., {|| FechaBatch()            } } )
	
	SetKey( VK_F12 , {|| lShowQry := MsgYesNo('Exportar a consulta SQL?',cCadastro ) } )
	
	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		aAdd(aParamBox,{ 1, "Período de" , Ctod(Space(8)), "", "", "", "", 20, .T. }) // 01
		aAdd(aParamBox,{ 1, "Período Ate", dDatabase     , "", "", "", "", 20, .T. }) // 02
		
		If ParamBox(aParamBox,"",@aRet)
			FWMsgRun(, {|| A070Query( aRet ) },cCadastro,'Gerando relatório, aguarde...')
			If lShowQry
				A070ShowQry( cShowQry )
			EndIF
		EndIF
	EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | A070Query | Autor | Rafael Beghini | Data | 09.08.2016
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A070Query( aRet )
	Local cSQL  := ''
	Local cTRB  := ''
	Local dDate := MsDate()
	Private cMV_par01 := cMV_par02 := ''
	
	//Atribui conforme o Parambox enviou
	cMV_par01 := dToS(aRet[1])
	cMV_par02 := dToS(aRet[2])
	
	cSQL += "SELECT cn9_filial, " + CRLF
	cSQL += "       cn9_numero, " + CRLF
	cSQL += "       cn9_revisa, " + CRLF
	cSQL += "       Trim(cn9_descri)cn9_descri, " + CRLF
	cSQL += "       CN9_CLIENT, " + CRLF
	cSQL += "       CN9_LOJACL, " + CRLF
	cSQL += "       cn9_dtinic, " + CRLF
	cSQL += "       cn9_dtfim, " + CRLF
	cSQL += "       cn9_dtaniv " + CRLF
	cSQL += "FROM   "+ RetSqlName("CN9") + " CN9 " + CRLF
	cSQL += "WHERE  " + CRLF
	cSQL += "       cn9_situac = '05' " + CRLF
	cSQL += "       AND CN9_FLGREJ = '1' " + CRLF
	cSQL += "       AND cn9_revatu = '   ' " + CRLF
	cSQL += "       AND CN9.d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "       AND TO_DATE(cn9_dtfim,'YYYYMMDD') >= TO_DATE(" + ValToSql(Dtos(dDate)) +",'YYYYMMDD' )" + CRLF 
	cSQL += "       AND cn9_dtfim >= '" + cMV_par01 + "'" + CRLF 
	cSQL += "       AND cn9_dtfim <= '" + cMV_par02 + "'" + CRLF 
	cSQL += "ORDER BY CN9_FILIAL, CN9_NUMERO " + CRLF
	
	cShowQry += cSQL
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSQL ), cTRB, .F., .T. )
		
	TcSetField( cTRB, "CN9_DTINIC", "D", 8 )
	TcSetField( cTRB, "CN9_DTFIM" , "D", 8 )
	TcSetField( cTRB, "CN9_DTANIV", "D", 8 )
		
	IF .NOT. Eof( cTRB )
		A070Excel( cTRB )
	Else
		MsgAlert('A query não retornou registros, por favor verifique os parâmetros informados.', cCadastro)
	EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | A070Excel | Autor | Rafael Beghini | Data | 09.08.2016 
//+-------------------------------------------------------------------+
//| Descr. | Gera o arquivo XML conforme query realizada. 
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A070Excel( cTRB )
	Local aArea      := GetArea()
	Local aDADOS     := {}
	Local aEntidade  := {}
	Local cEspContr  := ''
	Local cNOME      := ''
	Local cESPECIE   := ''
	Local cWorkSheet := 'Contratos'
	Local cTable     := cCadastro
	Local cPath      := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile  := cPath + 'contratos_' + dTos(Date()) + ".XML"
	Local dDate      := MsDate()
	Local dNew       := Ctod(Space(8))
	Local dDtFim     := Ctod(Space(8))
	Local nDias      := 0
		
	oExcel := FWMSEXCEL():New() //Método para geração em XML
	
	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >  , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Filial"            , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Contrato"		   , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Revisão"           , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"		   , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Espécie" 		   , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Razão Social"      , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data de Inicio"    , 1     , 4	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data de Vencimento", 1     , 4	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Dias a vencer"     , 1     , 1	   , .F. )
	
	
	//Para mostrar os itens preenchidos olhar a tabela RDY
	While .NOT. Eof( cTRB )
		cEspContr := IIF( Empty( (cTRB)->CN9_CLIENT ), '1', '2' )
		IF cEspContr == '1'
			CNC->( dbSetOrder( 1 ) )
			CNC->( dbSeek( (cTRB)->CN9_FILIAL + (cTRB)->( CN9_NUMERO + CN9_REVISA ) ) )
			aEntidade := SA2->( GetAdvFVal( 'SA2', { 'A2_NOME', 'A2_CGC', 'A2_NREDUZ' }, xFilial('SA2') + CNC->( CNC_CODIGO + CNC_LOJA ), 1 ) )
			cNOME := RTrim( aEntidade[ 1 ] )
			cESPECIE := 'Fornecedor'
		Else
			aEntidade := SA1->( GetAdvFVal( 'SA1', { 'A1_NOME', 'A1_CGC', 'A1_NREDUZ' }, xFilial('SA1') + (cTRB)->( CN9_CLIENT + CN9_LOJACL ), 1 ) )
			cNOME     := RTrim( aEntidade[ 1 ] )
			cESPECIE  := 'Cliente'
		EndIF
			
		dDtFim := IIF( Empty( (cTRB)->CN9_DTANIV ), (cTRB)->CN9_DTFIM, (cTRB)->CN9_DTANIV )
		nDias  := dDtFim - dDate
		
		IF nDias > 365
			IF MesDia( dDtFim ) > MesDia( dDate )
				dNew  := sTod( StrZero( Year( dDate ), 4 ) + MesDia( dDtFim ) )
				nDias := dNew - dDate
				cDias := Strzero(nDias,3)
			Else
				//pega mes/dia + 1 ano da data atual e faz a conta.
				dNew  := sTod( StrZero( Year( dDate ) + 1, 4 ) + MesDia( dDtFim ) )
				nDias := dNew - dDate
				cDias := Strzero(nDias,3)
			EndIF
		Else
			cDias := Strzero(nDias,3) 
		EndiF
		
		aDADOS := { (cTRB)->CN9_FILIAL, (cTRB)->CN9_NUMERO, (cTRB)->CN9_REVISA, (cTRB)->CN9_DESCRI, cESPECIE, cNOME, (cTRB)->CN9_DTINIC, (cTRB)->CN9_DTFIM, cDias }
		oExcel:AddRow( cWorkSheet, cTable, aDADOS )
		
		(cTRB)->( dbSkip() )
	End
	
	(cTRB)->( dbCloseArea() )
	
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
// Rotina | A070ShowQry | Autor | Rafael Beghini    | Data | 09.08.2016
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