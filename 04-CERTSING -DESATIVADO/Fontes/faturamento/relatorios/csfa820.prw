//--------------------------------------------------------------------------
// Rotina | CSFA820    | Autor | Robson Gonçalves        | Data | 27/03/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que extrai os dados de faturamento e cruza com os dados
//        | onde foi validado o certificado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------

#Include 'Protheus.ch'

STATIC aAvaliacao := {'Analítico','Sintético','Ambos'}
STATIC aPoint     := {'|','/','-','\'}
STATIC aReturn    := {} 
STATIC cFile      := ''
STATIC cTRB       := ''
STATIC lQuery     := .F.
STATIC nPoint     := 0 

User Function CSFA820()
	Local aButton := {}
	Local aSay := {}
	
	Local nOpc := 0
	
	Private cCadastro  := 'Relatório de consumo lógico x físico'
	
	AAdd( aSay, 'Esta rotina tem o objetivo de apresentar dentro de um período informado a unidade' )
	AAdd( aSay, 'federativa (UF) de faturamento do cliente, a unidade federativa (UF) onde foi' )
	AAdd( aSay, 'validado o certificado e por fim a filial onde foi emitida a NF, ou seja, o consumo' )
	AAdd( aSay, 'lógico x físico da mídia (hardware).' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aSay, 'Tecla <F12> exporta a query para análise técnica.' )
	
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	SetKey( VK_F12 , {|| lQuery := MsgYesNo('Exportar a string da query?',cCadastro ) } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	SetKey( VK_F12 , NIL )
	
	If nOpc == 1
		A820Param()
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A820Param  | Autor | Robson Gonçalves        | Data | 27/03/2017
//--------------------------------------------------------------------------
// Descr. | Rotina de parâmetros.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A820Param()
	Local aParam := {}
	
	AAdd(aParam,{1,'Filial de'     ,Space(Len(SD2->D2_FILIAL)),'','','SM0_01','',50,.F.})
	AAdd(aParam,{1,'Filial até'    ,Space(Len(SD2->D2_FILIAL)),'','','SM0_01','',50,.T.})
	AAdd(aParam,{1,'Emissão de'    ,Ctod(Space(8)),'','','','',50,.F.})
	AAdd(aParam,{1,'Emissão até'   ,Ctod(Space(8)),'','','','',50,.T.})
	AAdd(aParam,{2,'Avaliação', 1, aAvaliacao, 90, '', .T. } )//1=Analítico; 2=Sintético; 3=Ambos.
	
	If ParamBox(aParam,'Parâmetros',@aReturn,,,,,,,,.F.,.F.)
		MsAguarde( {|| A820Query() }, cCadastro, 'Início do processo, aguarde...', .F. )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A820Query  | Autor | Robson Gonçalves        | Data | 27/03/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que elabora a query e executa a leitura dos dados. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A820Query()
	Local cSQL := ''
	
   MsProcTxt( 'Aguarde, buscando os dados' )
   ProcessMessage()
	
	cSQL := "SELECT D2_FILIAL, " + CRLF
	cSQL += "       D2_DOC, " + CRLF
	cSQL += "       D2_SERIE, " + CRLF
	cSQL += "       D2_EMISSAO, " + CRLF
	cSQL += "       D2_EST, " + CRLF
	cSQL += "       D2_COD, " + CRLF
	cSQL += "       D2_QUANT, " + CRLF
	cSQL += "       D2_TES, " + CRLF
	cSQL += "       D2_CF, " + CRLF
	cSQL += "       D2_PEDIDO, " + CRLF
	cSQL += "       D2_ITEMPV, " + CRLF
	cSQL += "       C5_CHVBPAG, " + CRLF
	cSQL += "       C5_XNPSITE, " + CRLF
	cSQL += "       Z3_CODENT, " + CRLF
	cSQL += "       Z3_DESENT, " + CRLF
	cSQL += "       Z8_COD, " + CRLF
	cSQL += "       Z8_DESC, " + CRLF
	cSQL += "       A2_COD, " + CRLF
	cSQL += "       A2_LOJA, " + CRLF
	cSQL += "       A2_NOME, " + CRLF
	cSQL += "       A2_EST " + CRLF
	cSQL += "FROM   "+RetSqlName("SD2")+" D2 " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SF2")+" F2 " + CRLF
	cSQL += "               ON F2_FILIAL = D2_FILIAL " + CRLF
	cSQL += "                  AND F2_DOC = D2_DOC " + CRLF
	cSQL += "                  AND F2_SERIE = D2_SERIE " + CRLF
	cSQL += "                  AND F2_CLIENTE = D2_CLIENTE " + CRLF
	cSQL += "                  AND F2_LOJA = D2_LOJA " + CRLF
	cSQL += "                  AND F2_EMISSAO = D2_EMISSAO " + CRLF
	cSQL += "                  AND F2_TIPO = 'N' " + CRLF
	cSQL += "                  AND F2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" B1 " + CRLF
	cSQL += "               ON B1_FILIAL = D2_FILIAL " + CRLF
	cSQL += "                  AND B1_COD = D2_COD " + CRLF
	cSQL += "                  AND B1_CATEGO = '1' " + CRLF
	cSQL += "                  AND B1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SC5")+" C5 " + CRLF
	cSQL += "               ON C5_FILIAL = "+ValToSql(xFilial("SC5"))+" " + CRLF
	cSQL += "                  AND C5_NUM = D2_PEDIDO " + CRLF
	cSQL += "                  AND C5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SZ5")+" Z5 " + CRLF
	cSQL += "               ON Z5_FILIAL = "+ValToSql(xFilial("SZ5"))+" " + CRLF
	cSQL += "                  AND Z5_PEDIDO = D2_PEDIDO " + CRLF
	cSQL += "                  AND Z5_ITEMPV = D2_ITEMPV " + CRLF
	cSQL += "                  AND Z5_PEDGAR = ' ' " + CRLF
	cSQL += "                  AND Z5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       LEFT  JOIN "+RetSqlName("SZ3")+" Z3 " + CRLF
	cSQL += "               ON Z3_FILIAL = "+ValToSql(xFilial("SZ3"))+" " + CRLF
	cSQL += "                  AND Z3_CODGAR = Z5_CODPOS " + CRLF
	cSQL += "                  AND Z3_CODGAR > ' ' " + CRLF
	cSQL += "                  AND Z3_TIPENT = '4' " + CRLF
	cSQL += "                  AND Z3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       LEFT  JOIN "+RetSqlName("SZ8")+" Z8 " + CRLF
	cSQL += "               ON Z8_FILIAL = "+ValToSql(xFilial("SZ8"))+" " + CRLF
	cSQL += "                  AND Z8_COD = Z3_PONDIS " + CRLF
	cSQL += "                  AND Z8.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       LEFT  JOIN "+RetSqlName("SA2")+" A2 " + CRLF
	cSQL += "               ON A2_FILIAL = "+ValToSql(xFilial("SA2"))+" " + CRLF
	cSQL += "                  AND A2_COD = Z8_FORNEC " + CRLF
	cSQL += "                  AND A2_LOJA = Z8_LOJA " + CRLF
	cSQL += "                  AND A2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  D2_FILIAL >= "+ValToSql(aReturn[1])+" " + CRLF
	cSQL += "       AND D2_FILIAL <= "+ValToSql(aReturn[2])+" " + CRLF
	cSQL += "       AND D2_EMISSAO >= "+ValToSql(aReturn[3])+" " + CRLF
	cSQL += "       AND D2_EMISSAO <= "+ValToSql(aReturn[4])+" " + CRLF
	cSQL += "       AND D2.D_E_L_E_T_ = ' ' " + CRLF
	
	cSQL += "UNION ALL " + CRLF

	cSQL += "SELECT D2_FILIAL, " + CRLF
	cSQL += "       D2_DOC, " + CRLF
	cSQL += "       D2_SERIE, " + CRLF
	cSQL += "       D2_EMISSAO, " + CRLF
	cSQL += "       D2_EST, " + CRLF
	cSQL += "       D2_COD, " + CRLF
	cSQL += "       D2_QUANT, " + CRLF
	cSQL += "       D2_TES, " + CRLF
	cSQL += "       D2_CF, " + CRLF
	cSQL += "       D2_PEDIDO, " + CRLF
	cSQL += "       D2_ITEMPV, " + CRLF
	cSQL += "       C5_CHVBPAG, " + CRLF
	cSQL += "       C5_XNPSITE, " + CRLF
	cSQL += "       Z3_CODENT, " + CRLF
	cSQL += "       Z3_DESENT, " + CRLF
	cSQL += "       Z8_COD, " + CRLF
	cSQL += "       Z8_DESC, " + CRLF
	cSQL += "       A2_COD, " + CRLF
	cSQL += "       A2_LOJA, " + CRLF
	cSQL += "       A2_NOME, " + CRLF
	cSQL += "       A2_EST " + CRLF
	cSQL += "FROM   "+RetSqlName("SD2")+" D2 " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SF2")+" F2 " + CRLF
	cSQL += "               ON F2_FILIAL = D2_FILIAL " + CRLF
	cSQL += "                  AND F2_DOC = D2_DOC " + CRLF
	cSQL += "                  AND F2_SERIE = D2_SERIE " + CRLF
	cSQL += "                  AND F2_CLIENTE = D2_CLIENTE " + CRLF
	cSQL += "                  AND F2_LOJA = D2_LOJA " + CRLF
	cSQL += "                  AND F2_EMISSAO = D2_EMISSAO " + CRLF
	cSQL += "                  AND F2_TIPO = 'N' " + CRLF
	cSQL += "                  AND F2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" B1 " + CRLF
	cSQL += "               ON B1_FILIAL = D2_FILIAL " + CRLF
	cSQL += "                  AND B1_COD = D2_COD " + CRLF
	cSQL += "                  AND B1_CATEGO = '1' " + CRLF
	cSQL += "                  AND B1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SC5")+" C5 " + CRLF
	cSQL += "               ON C5_FILIAL = "+ValToSql(xFilial("SC5"))+" " + CRLF
	cSQL += "                  AND C5_NUM = D2_PEDIDO " + CRLF
	cSQL += "                  AND C5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SZ5")+" Z5 " + CRLF
	cSQL += "               ON Z5_FILIAL = "+ValToSql(xFilial("SZ5"))+" " + CRLF
	cSQL += "                  AND Z5_PEDGAR = C5_CHVBPAG " + CRLF
	cSQL += "                  AND Z5_PEDGAR > ' ' " + CRLF
	cSQL += "                  AND Z5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SZ3")+" Z3 " + CRLF
	cSQL += "               ON Z3_FILIAL = "+ValToSql(xFilial("SZ3"))+" " + CRLF
	cSQL += "                  AND Z3_CODGAR = Z5_CODPOS " + CRLF
	cSQL += "                  AND Z3_CODGAR > ' ' " + CRLF
	cSQL += "                  AND Z3_TIPENT = '4' " + CRLF
	cSQL += "                  AND Z3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SZ8")+" Z8 " + CRLF
	cSQL += "               ON Z8_FILIAL = "+ValToSql(xFilial("SZ8"))+" " + CRLF
	cSQL += "                  AND Z8_COD = Z3_PONDIS " + CRLF
	cSQL += "                  AND Z8.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SA2")+" A2 " + CRLF
	cSQL += "               ON A2_FILIAL = "+ValToSql(xFilial("SA2"))+" " + CRLF
	cSQL += "                  AND A2_COD = Z8_FORNEC " + CRLF
	cSQL += "                  AND A2_LOJA = Z8_LOJA " + CRLF
	cSQL += "                  AND A2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  D2_FILIAL >= "+ValToSql(aReturn[1])+" " + CRLF
	cSQL += "       AND D2_FILIAL <= "+ValToSql(aReturn[2])+" " + CRLF
	cSQL += "       AND D2_EMISSAO >= "+ValToSql(aReturn[3])+" " + CRLF
	cSQL += "       AND D2_EMISSAO <= "+ValToSql(aReturn[4])+" " + CRLF
	cSQL += "       AND D2.D_E_L_E_T_ = ' ' " + CRLF

	cSQL += "ORDER  BY  D2_FILIAL, " + CRLF
	cSQL += "           D2_DOC, " + CRLF
	cSQL += "           D2_SERIE, " + CRLF
	cSQL += "           D2_EMISSAO " + CRLF
	
	If lQuery 
		CopyToClipBoard( cSQL )
		MsgInfo( cSQL, 'CTRL+C para copiar a query' )
		If .NOT. MsgYesNo( 'Continuar com o processamento?', cCadastro )
			Return
		Endif
	Endif
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	dbUseArea( .T., 'TOPCONN', TcGenQry(,, cSQL ), cTRB, .T., .T. )
	dbSelectArea( cTRB )
	
	If (cTRB)->( .NOT. BOF() ) .AND. (cTRB)->( .NOT. EOF() )
		cFile := CriaTrab( NIL, .F. ) + '.xml'
		While File( cFile )
			cFile := CriaTrab( NIL, .F. ) + '.xml'
		End
		A820Read()
	Else
		MsgInfo( 'Não foi possível localizar dados com os parâmetros informados.' )
	Endif
	(cTRB)->( dbCloseArea() )
Return

//--------------------------------------------------------------------------
// Rotina | A820Read   | Autor | Robson Gonçalves        | Data | 27/03/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que lê os dados do resultado da query e dispara a saída 
//        | dos dados. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A820Read()
	Local aFullData := {}
	Local aSummary1 := {}
	Local aSummary2 := {}
	
	Local cDir := ''
	Local cDirTmp := ''
	Local cMV_XFILFAT := 'MV_XFILFAT'
	
	Local lSemAcao := .T.
	
	Local oExcelApp
	Local oFwMsEx
	
	Local nP := 0
	
	//------------------------------------------------------------------------------------------------------ 
	// Parâmetro que contém a UF de cliente e a FILIAL do sistema que terá faturamento de hardware apartado.
	//------------------------------------------------------------------------------------------------------ 
	cMV_XFILFAT := GetMv( cMV_XFILFAT, .F. )
	
	nAval := Iif( ValType( aReturn[ 5 ] ) == 'N', aReturn[ 5 ], AScan( aAvaliacao, {|e| e==aReturn[ 5 ] } ) )
	
	While (cTRB)->( .NOT. EOF() )
		nPoint++
		
		If nPoint == 5
			nPoint := 1
		Endif
		
	   MsProcTxt( 'Aguarde, lendo registros ' + aPoint[ nPoint ] )
	   ProcessMessage()
		
		//------------------------------------------------
		// Avaliação -> 1=Analítico ou 3=Ambos.
		//------------------------------------------------
		If nAval == 1 .OR. nAval == 3
			//--------------------------------------------------------------------------------------------------
			// Se a UF do PD está contido no parâmetro AND a filial de faturamento está contido no parâmetro OR
			// Se a filial de faturamento não está contida no parâmetro e a UF do PD não está contida no parâmetro.
			// Ambas condições verdadeiras não há ação.
			//--------------------------------------------------------------------------------------------------
			lSemAcao := ( ( At( A2_EST, cMV_XFILFAT )>0 .AND. At( D2_FILIAL, cMV_XFILFAT)>0 ) ;
			            .OR. ;
			            ( At( D2_FILIAL, cMV_XFILFAT)==0 .AND. At( A2_EST, cMV_XFILFAT )==0 ) )
			
			AAdd( aFullData, { D2_FILIAL, D2_EST,	D2_DOC, D2_SERIE,	Dtoc(Stod(D2_EMISSAO)), D2_COD,;
			D2_QUANT, D2_TES, D2_CF, D2_PEDIDO, D2_ITEMPV, C5_CHVBPAG, C5_XNPSITE, Z3_CODENT, Z3_DESENT, Z8_COD,;
			Z8_DESC, A2_COD +'-'+ A2_LOJA, A2_NOME, A2_EST, Iif( lSemAcao, 'não há ação (' + A2_EST +'/'+ D2_FILIAL + ')', A2_EST +' para '+ D2_FILIAL ), D2_QUANT } )
		Endif
		//--------------------
		// Sintético ou Ambos.
		//--------------------
		If nAval == 2 .OR. nAval == 3
			//----------------------------------------------------------
			// Se a UF do cliente estiver contido no parâmetro.
			// Se a Filial de faturamento estiver contido no parâmetro.
			// Se a UF do PD não está contido no parâmetro.
			// Exemplo: Cliente/RJ e Filial/RJ e o PD é fora do RJ.
			//----------------------------------------------------------
			If At( (cTRB)->D2_EST, cMV_XFILFAT ) > 0 .AND. At( (cTRB)->D2_FILIAL, cMV_XFILFAT ) > 0 .AND. At( (cTRB)->A2_EST, cMV_XFILFAT ) == 0
			   
			   nP := AScan( aSummary1,;
           {|e| e[ 1 ]==(cTRB)->D2_FILIAL .AND. e[ 2 ]==(cTRB)->D2_EST .AND. e[ 3 ]==(cTRB)->A2_EST .AND. e[ 4 ]==(cTRB)->D2_COD } )
			   
			   If nP == 0
			   	AAdd( aSummary1, { (cTRB)->D2_FILIAL, (cTRB)->D2_EST, (cTRB)->A2_EST, (cTRB)->D2_COD, (cTRB)->D2_QUANT } )
			   Else
			   	aSummary1[ nP, 5 ] += (cTRB)->D2_QUANT
			   Endif    
			Else
				//---------------------------------
				// Exemplo: Filial/SP e PD é do RJ.
				//---------------------------------
				If (cTRB)->D2_FILIAL == '02' .AND. (cTRB)->A2_EST == 'RJ'
				   nP := AScan( aSummary2,;
				   {|e| e[ 1 ]==(cTRB)->D2_FILIAL .AND. e[ 2 ]==(cTRB)->D2_EST .AND. e[ 3 ]==(cTRB)->A2_EST .AND. e[ 4 ]==(cTRB)->D2_COD } )
				   
				   If nP == 0
				   	AAdd( aSummary2, { (cTRB)->D2_FILIAL, (cTRB)->D2_EST, (cTRB)->A2_EST, (cTRB)->D2_COD, (cTRB)->D2_QUANT } )
				   Else
				   	aSummary2[ nP, 5 ] += (cTRB)->D2_QUANT
				   Endif
			   Endif
			Endif 
		Endif
		 
		(cTRB)->( dbSkip() )
	End
	
	If Len( aFullData ) > 0 .OR. Len( aSummary1 ) > 0 .OR. Len( aSummary2 ) > 0
		oFwMsEx := FWMsExcel():New()
		
		If nAval == 1 .OR. nAval == 3
			A820Analytical( @oFwMsEx, aFullData ) 
		Endif
		
		If nAval == 2 .OR. nAval == 3
			A820Synthetic( @oFwMsEx, aSummary1, aSummary2 )
		Endif

		oFwMsEx:Activate()
		cDirTmp := GetTempPath()
		cDir := GetSrvProfString('Startpath','')
	
		LjMsgRun( 'Gerando o arquivo, aguarde...', cCadastro, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
	
		If __CopyFile( cFile, cDirTmp + cFile )
			If ApOleClient( 'MsExcel' ) 
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cDirTmp + cFile )
				oExcelApp:SetVisible(.T.)
				oExcelApp:Destroy()
				Sleep(500)
			Else
				MsgInfo( 'Não localizei o aplicativo MsExcel. O arquivo ' + cFile + ' foi gerado na pasta temporária do seu usuário.', cCadastro )
				WinExec( 'Explorer ' + cDirTmp )
			Endif
		Else
			MsgInfo( 'Não foi possível copiar o arquivo Excel para o diretório temporário do usuário.' )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A820Analytical | Autor | Robson Gonçalves    | Data | 27/03/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que constrói a saída dos dados analíticos. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A820Analytical( oFwMsEx, aFullData )
	Local aHead := {}
	
	Local cWorkSheet := ''
	Local cTable := ''
	
	aHead := { 'Filial NF', 'UF cliente', 'Documento', 'Série', 'Emissão', 'Produto', 'Quantidade', 'TES', 'CFOP', 'Pedido', 'Item pedido',;
	'Pedido GAR', 'Pedido Site', 'Código PA', 'Nome PA', 'Código PD', 'Nome PD', 'Código Forn', 'Nome Fornec', 'UF posto', 'DE/PARA', 'QUANT' }
	
	cWorkSheet := 'Avaliação ' + aAvaliacao[ 1 ]
	cTable := cWorkSheet
	
	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )	

	AEval( aHead, {|value,index|  oFwMsEx:AddColumn( cWorkSheet, cTable, value, 1, iif(index==7 .or. index==22,2,1), (index==7 .or. index==22) ) } )
	
	For nJ := 1 To Len( aFullData )
		nPoint++
		
		If nPoint == 5
			nPoint := 1
		Endif

   	MsProcTxt( 'Aguarde, processando resumo ' + aPoint[ nPoint ] )
   	ProcessMessage()

		oFwMsEx:AddRow( cWorkSheet, cTable, aFullData[ nJ ] )
	Next nJ
Return

//--------------------------------------------------------------------------
// Rotina | A820Synthetic | Autor | Robson Gonçalves    | Data | 27/03/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que constrói a saída dos dados sintéticos. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A820Synthetic( oFwMsEx, aSummary1, aSummary2 )
	Local aHead := {}
	
	Local cBreak := ''
	Local cTable := ''
	Local cWorkSheet := ''
	
	Local nSubTotal := 0
	
	aHead := { 'FILIAL FAT', 'UF/CLIENTE', 'UF/PD', 'PRODUTO','QUANTIDADE' }
	
	cWorkSheet := 'Transf Estoque Central SP-RJ'
	cTable := 'Transferência Estoque Central SP-RJ - ordenado por: PRODUTO + UF CLIENTE'
	
	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )	
	
	AEval( aHead, {|value,index|  oFwMsEx:AddColumn( cWorkSheet, cTable, value, 1, iif(index==5,2,1), .F. ) } )
	
	ASort( aSummary1,,, {|a,b| a[ 4 ] + a[ 2 ] < b[ 4 ] + b[ 2 ] } ) 
	
	cBreak := Iif( Len( aSummary1 )>0, aSummary1[ 1, 4 ], '' )
	
	For nJ := 1 To Len( aSummary1 )
		nPoint++
		
		If nPoint == 5
			nPoint := 1
		Endif

   	MsProcTxt( 'Aguarde, processando resumo ' + aPoint[ nPoint ] )
   	ProcessMessage()
   	   	
   	If	cBreak <> aSummary1[ nJ, 4 ]
			oFwMsEx:AddRow( cWorkSheet, cTable, { '', '', '', 'Subtotal', nSubTotal } )
   		nSubTotal := 0
   		cBreak := aSummary1[ nJ, 4 ]
   		nSubTotal += aSummary1[ nJ, 5 ]
   	Else
   		nSubTotal += aSummary1[ nJ, 5 ]
   	Endif 
   	
		oFwMsEx:AddRow( cWorkSheet, cTable,;
		{ aSummary1[ nJ, 1 ], aSummary1[ nJ, 2 ], aSummary1[ nJ, 3 ], aSummary1[ nJ, 4 ], aSummary1[ nJ, 5 ] } )
	Next nJ
	
	If Len( aSummary1 )>0 .AND. nSubTotal>0
		oFwMsEx:AddRow( cWorkSheet, cTable, { '', '', '', 'Subtotal', nSubTotal } )
	Endif
	
	cWorkSheet := 'Transf Estoque Central RJ-SP'
	cTable := 'Transferência Estoque Central RJ-SP  - ordenado por: PRODUTO + UF CLIENTE'
	
	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )	
	
	AEval( aHead, {|value,index|  oFwMsEx:AddColumn( cWorkSheet, cTable, value, 1, iif(index==5,2,1), .F. ) } )
	
	ASort( aSummary2,,, {|a,b| a[ 4 ] + a[ 2 ] < b[ 4 ] + b[ 2 ] } )
	
	nSubTotal := 0
	cBreak := Iif( Len( aSummary2 )>0, aSummary2[ 1, 4 ], '' )
	
	For nJ := 1 To Len( aSummary2 )
		nPoint++
		
		If nPoint == 5
			nPoint := 1
		Endif

   	MsProcTxt( 'Aguarde, processando resumo ' + aPoint[ nPoint ] )
   	ProcessMessage()

   	If	cBreak <> aSummary2[ nJ, 4 ]
			oFwMsEx:AddRow( cWorkSheet, cTable, { '', '', '', 'Subtotal', nSubTotal } )
   		nSubTotal := 0
   		cBreak := aSummary2[ nJ, 4 ]
   		nSubTotal += aSummary2[ nJ, 5 ]
   	Else
   		nSubTotal += aSummary2[ nJ, 5 ]
   	Endif 

		oFwMsEx:AddRow( cWorkSheet, cTable,;
		{ aSummary2[ nJ, 1 ], aSummary2[ nJ, 2 ], aSummary2[ nJ, 3 ], aSummary2[ nJ, 4 ], aSummary2[ nJ, 5 ] } )
	Next nJ

	If Len( aSummary2 )>0 .AND. nSubTotal>0
		oFwMsEx:AddRow( cWorkSheet, cTable, { '', '', '', 'Subtotal', nSubTotal } )
	Endif
Return