//--------------------------------------------------------------------------
// Rotina | CSFA830    | Autor | Robson Gonçalves        | Data | 14/07/2017
//--------------------------------------------------------------------------
// Descr. | Relatório de consumo de mídias. 
//        | 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------

#Include 'Protheus.ch'
#Include 'TbiConn.ch'

User Function CSFA830()
	Local aButton := {}
	Local aPar := {}
	Local aRet := {}
	Local aSay := {}
	
	Local lJob := ( Select( 'SX6' ) == 0 ) 
	
	Local nOpc := 0
	
	Private cCadastro  := 'Relatório de consumo de mídias'
	Private lQuery := .F.
		
	If lJob
		CONOUT('CSFA830-INÍCIO DO PROCESSAMENTO DO RELATÓRIO DE CONSUMO DE MÍDIAS.')
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02' MODULO 'FAT'
			CONOUT('CSFA830-ROTINA ESTÁ SENDO EXECUTADA EM MODO JOB.')
			MV_PAR01 := ( MsDate()-3 )
			MV_PAR02 := ( MsDate()-3 )
			MV_PAR03 := Space( 99 )
			MV_PAR04 := Space( 99 )
			A830Proc( .F., lJob )
		RESET ENVIRONMENT
		CONOUT('CSFA830-FIM DO PROCESSAMENTO DO RELATÓRIO DE CONSUMO DE MÍDIAS.')
	Else
		AAdd( aSay, 'Relatório de consumo de mídias.' )
		
		AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
		AAdd( aButton, { 22, .T., { || FechaBatch() } } )
		
		SetKey( VK_F12 , {|| lQuery := MsgYesNo('Exportar a string da query?',cCadastro ) } )
		
		FormBatch( cCadastro, aSay, aButton )
		
		SetKey( VK_F12 , NIL )
		
		If nOpc == 1
			XBPosto()
			
			AAdd(aPar,{1,'Período de'            ,Ctod(Space(8)),'','','','',50,.F.})
			AAdd(aPar,{1,'Período até'           ,Ctod(Space(8)),'','','','',50,.T.})
			AAdd(aPar,{1,'Desconsiderar posto(s)',Space(99),'','','XBPOST','',118,.F.})
			AAdd(aPar,{1,'Considerar posto(s)'   ,Space(99),'','','XBPOST','',118,.F.})
			If ParamBox(aPar,'Parâmetros',@aRet,,,,,,,,.F.,.F.)
				MsAguarde( {|lEnd| A830Proc( @lEnd, lJob ) }, cCadastro, 'Iniciando, aguarde...', .T. )
			Endif
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A830Proc   | Autor | Robson Gonçalves        | Data | 14/07/2017
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento.
//        | 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A830Proc( lEnd, lJob )
	Local aC5_TIPMOV := {}
	Local aDados := {}
	Local aHead := {}
	Local aPoint := {}
	Local aProdutos := {}
	Local aSummary1 := {}
	Local aSummary2 := {}
	Local aZ5_TIPMOV := {}
	
	Local cB1_COD := ''
	Local cB1_DESC := ''
	Local cBreak := ''
	Local cC5_NUM := ''
	Local cC5_TIPMOV := ''
	Local cC5_XNPSITE := ''
	Local cC6_ITEM := ''
	Local cC6_LOJDED := '' // Esta variável irá presentar o campo de mesmo nome, seu conteúdo possui a filial onde foi faturado o PV.
	Local cC6_SERIE := ''
	Local cC6_NOTA := ''
	Local cContido := ''
	Local cD2_EST := ''
	Local cDir := ''
	Local cDirTmp := ''
	Local cFile := ''
	Local cMailTo := ''
	Local cMV_830_01 := 'MV_830_01'	
	Local cMV_XFILFAT := 'MV_XFILFAT'
	Local cNaoContido := ''
	Local cOBSERV := ''
	Local cSQL := ''
	Local cTable := ''
	Local cTRB := ''
	Local cWorkSheet := ''
	Local cZ5_TIPMOV := ''
	
	Local lAcheiNF := .F.
	Local lSemAcao := .T.
	
	Local nC6_QTDVEN := 0
	Local nJ := 0
	Local nMaxPoint := 0
	Local nPoint := 0
	Local nSubTotal := 0
	
	Local oExcelApp
	Local oFwMsEx
	
	aPoint := {;
	'.          ',;
	'..         ',;
	'...        ',;
	'....       ',;
	'.....      ',;
	'......     ',;
	'.......    ',;
	'........   ',;
	'.........  ',;
	'.......... ',;
	'...........',;
	' ..........',;
	'  .........',;
	'   ........',;
	'    .......',;
	'     ......',;
	'      .....',;
	'       ....',;
	'        ...',;
	'         ..',;
	'          .',;
	'         ..',;
	'        ...',;
	'       ....',;
	'      .....',;
	'     ......',;
	'    .......',;
	'   ........',;
	'  .........',;
	' ..........',;
	'...........',;
	'.......... ',;
	'.........  ',;
	'........   ',;
	'.......    ',;
	'......     ',;
	'.....      ',;
	'....       ',;
	'...        ',;
	'..         ',;
	'.          ';
	}
	
	nMaxPoint := Len( aPoint )
	
	If .NOT. GetMv( cMV_830_01, .T. )
		CriarSX6( cMV_830_01, 'C', 'E-MAILS PARA ONDE SERÁ ENVIADO O ARQUIVO COM O RESULTADO DO PROCESSAMENTO.', 'vcoliveira@certisign.com.br' )
	Endif
	
	cSQL := "SELECT Z5_PEDGAR, "

	cSQL += "       Z5_TIPMOV, "
	cSQL += "       Z5_CODVOU, "
	cSQL += "       Z5_TIPVOU, "
	cSQL += "       Z5_DATVAL, "
	cSQL += "       Z5_DATVER, "
	cSQL += "       Z5_DATEMIS, "
	cSQL += "       Z5_EMISSAO, "
	cSQL += "       Z5_DATPED, "
	cSQL += "       Z5_VALORHW, "
	cSQL += "       Z5_GRUPO, "
	cSQL += "       Z5_TIPO, "
	
	cSQL += "       Z3_CODGAR, "
	cSQL += "       Z3_CODENT, "
	cSQL += "       Z3_DESENT, "
	cSQL += "       Z3_ESTADO, "
	
	cSQL += "       Z8_COD, "
	cSQL += "       Z8_DESC, "
	
	cSQL += "       A2_COD, "
	cSQL += "       A2_LOJA, "
	cSQL += "       A2_NOME, "
	cSQL += "       A2_EST, "
	
	cSQL += "       B1_COD, "
	cSQL += "       B1_DESC, "

	cSQL += "       Z5_PEDSITE, "
	cSQL += "       Z5_PEDIDO, "
	cSQL += "       Z5_ITEMPV, "
	cSQL += "       Z5_GRUPO, "
	cSQL += "       Z5_DESGRU, " 
	cSQL += "       Z5_TIPODES, "
	cSQL += "       Z5_NFDEV, "
	cSQL += "       Z5_PRODGAR, "
	cSQL += "       PA8_DESBPG "
	
	cSQL += "FROM   "+RetSqlName("SZ5")+" SZ5 "
	cSQL += "       LEFT JOIN "+RetSqlName("SZ3")+" SZ3 "
	cSQL += "               ON Z3_FILIAL = ' ' "
	cSQL += "                  AND Z3_CODGAR = Z5_CODPOS "
	cSQL += "                  AND Z3_CODGAR > ' ' "
	cSQL += "                  AND Z3_TIPENT = '4' "
	cSQL += "                  AND SZ3.D_E_L_E_T_ = ' ' "
	cSQL += "       LEFT JOIN "+RetSqlName("SZ8")+" SZ8 "
	cSQL += "               ON Z8_FILIAL = ' ' "
	cSQL += "                  AND Z8_COD = Z3_PONDIS "
	cSQL += "                  AND SZ8.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SA2")+" SA2 "
	cSQL += "               ON A2_FILIAL = ' ' "
	cSQL += "                  AND A2_COD = Z5_FORNECE "
	cSQL += "                  AND A2_LOJA = Z5_LOJA "
	cSQL += "                  AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SG1")+" SG1 "
	cSQL += "               ON G1_FILIAL = '02' "
	cSQL += "                  AND G1_COD = Z5_PRODUTO "
	cSQL += "                  AND SG1.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" SB1 "
	cSQL += "               ON B1_FILIAL = '02' "
	cSQL += "                  AND B1_COD = G1_COMP "
	cSQL += "                  AND B1_CATEGO = '1' "
	cSQL += "                  AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RETSQLNAME("PA8")+" PA8 "
	cSQL += "               ON PA8.PA8_FILIAL = "+VALTOSQL(XFILIAL("PA8"))+" "
	cSQL += "                  AND PA8.PA8_CODBPG = SZ5.Z5_PRODGAR "
	cSQL += "                  AND PA8.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  Z5_FILIAL = ' ' "
	cSQL += "       AND Z5_DATVER >= " + ValToSql(MV_PAR01) + " "
	cSQL += "       AND Z5_DATVER <= " + ValToSql(MV_PAR02) + " "
	cSQL += "       AND SZ5.Z5_PRODGAR > ' ' "
	cSQL += "       AND SZ5.Z5_PEDGANT = ' ' "
	cSQL += "       AND SZ5.Z5_CODPOS > ' ' "
	cSQL += "       AND SZ5.Z5_PEDGAR > ' ' "
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' "
	
	If .NOT. Empty( MV_PAR03 )
		cNaoContido := FormatIn( MV_PAR03, ';' )
		cSQL += "       AND Z8_COD NOT IN " + cNaoContido + " "
	Endif
	
	If .NOT. Empty( MV_PAR04 )
		cContido := FormatIn( MV_PAR04, ';' )
		cSQL += "       AND Z8_COD IN " + cContido + " "
	Endif
	
	cSQL += "UNION ALL "
	
	cSQL += "SELECT Z5_PEDGAR, "

	cSQL += "       Z5_TIPMOV, "
	cSQL += "       Z5_CODVOU, "
	cSQL += "       Z5_TIPVOU, "
	cSQL += "       Z5_DATVAL, "
	cSQL += "       Z5_DATVER, "
	cSQL += "       Z5_DATEMIS, "
	cSQL += "       Z5_EMISSAO, "
	cSQL += "       Z5_DATPED, "
	cSQL += "       Z5_VALORHW, "
	cSQL += "       Z5_GRUPO, "
	cSQL += "       Z5_TIPO, "
	
	cSQL += "       Z3_CODGAR, "
	cSQL += "       Z3_CODENT, "
	cSQL += "       Z3_DESENT, "
	cSQL += "       Z3_ESTADO, "
	
	cSQL += "       Z8_COD, "
	cSQL += "       Z8_DESC, "
	
	cSQL += "       A2_COD, "
	cSQL += "       A2_LOJA, "
	cSQL += "       A2_NOME, "
	cSQL += "       A2_EST, "
	
	cSQL += "       B1_COD, "
	cSQL += "       B1_DESC, "

	cSQL += "       Z5_PEDSITE, "
	cSQL += "       Z5_PEDIDO, "
	cSQL += "       Z5_ITEMPV, "
	cSQL += "       Z5_GRUPO, "
	cSQL += "       Z5_DESGRU, " 
	cSQL += "       Z5_TIPODES, "
	cSQL += "       Z5_NFDEV, "
	cSQL += "       Z5_PRODGAR, "
	cSQL += "       '        ' AS PA8_DESBPG "
	
	cSQL += "FROM   "+RetSqlName("SZ5")+" SZ5 "
	cSQL += "       LEFT JOIN "+RetSqlName("SZ3")+" SZ3 "
	cSQL += "              ON Z3_FILIAL = ' ' "
	cSQL += "                 AND Z3_CODGAR = Z5_CODPOS "
	cSQL += "                 AND Z3_CODGAR > ' ' "
	cSQL += "                 AND Z3_TIPENT = '4' "
	cSQL += "                 AND SZ3.D_E_L_E_T_ = ' ' "
	cSQL += "       LEFT JOIN "+RetSqlName("SZ8")+" SZ8 "
	cSQL += "              ON Z8_FILIAL = ' ' "
	cSQL += "                 AND Z8_COD = Z3_PONDIS "
	cSQL += "                 AND SZ8.D_E_L_E_T_ = ' ' "
	cSQL += "       LEFT JOIN "+RetSqlName("SA2")+" SA2 "
	cSQL += "              ON A2_FILIAL = ' ' "
	cSQL += "                 AND A2_COD = Z5_FORNECE "
	cSQL += "                 AND A2_LOJA = Z5_LOJA "
	cSQL += "                 AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "       LEFT JOIN "+RetSqlName("SG1")+" SG1 "
	cSQL += "              ON G1_FILIAL = '02' "
	cSQL += "                 AND G1_COD = Z5_PRODUTO "
	cSQL += "                 AND SG1.D_E_L_E_T_ = ' ' "
	cSQL += "       LEFT JOIN "+RetSqlName("SB1")+" SB1 "
	cSQL += "              ON B1_FILIAL = '02' "
	cSQL += "                 AND B1_COD = G1_COMP "
	cSQL += "                 AND B1_CATEGO = '1' "
	cSQL += "                 AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  Z5_FILIAL = ' ' "
	cSQL += "       AND Z5_EMISSAO >= " + ValToSql(MV_PAR01) + " "
	cSQL += "       AND Z5_EMISSAO <= " + ValToSql(MV_PAR02) + " "
	cSQL += "       AND SZ5.Z5_PEDGAR = ' ' "
	cSQL += "       AND SZ5.Z5_CODPOS > ' ' "
	cSQL += "       AND SZ5.Z5_TIPO = 'ENTHAR' "
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' "

	If .NOT. Empty( MV_PAR03 )
		cNaoContido := FormatIn( MV_PAR03, ';' )
		cSQL += "       AND Z8_COD NOT IN " + cNaoContido + " "
	Endif
	
	If .NOT. Empty( MV_PAR04 )
		cContido := FormatIn( MV_PAR04, ';' )
		cSQL += "       AND Z8_COD IN " + cContido + " "
	Endif

	cSQL += "ORDER  BY  Z5_PEDGAR "

	cSQL := ChangeQuery( cSQL )

	If lQuery 
		CopyToClipBoard( cSQL )
		MsgInfo( cSQL, 'CTRL+C para copiar a query' )
		If .NOT. MsgYesNo( 'Continuar com o processamento?', cCadastro )
			Return
		Endif
	Endif
	
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TcGenQry(,, cSQL ), cTRB, .T., .T. )
	dbSelectArea( cTRB )
	
	cMV_XFILFAT := GetMv( cMV_XFILFAT, .F. )
	aC5_TIPMOV  := StrTokArr( SX3->( Posicione( 'SX3', 2, 'C5_TIPMOV', 'X3CBox()' ) ), ';' )
	aZ5_TIPMOV  := StrTokArr( SX3->( Posicione( 'SX3', 2, 'Z5_TIPMOV', 'X3CBox()' ) ), ';' )
	
	While (cTRB)->( .NOT. EOF() ) .AND. .NOT. lEnd
		If .NOT. lJob
			MsProcTxt( 'Aguarde, processando os dados ' + aPoint[ ++nPoint ] )
			ProcessMessage()
			If nPoint == nMaxPoint
				nPoint := 0
			Endif
		Endif
		
		If Empty( (cTRB)->Z5_PEDGAR ) .AND. (.NOT. Empty( (cTRB)->Z5_PEDIDO )) .AND. (.NOT. Empty( (cTRB)->Z5_ITEMPV ))
			SC6->( dbSetOrder( 1 ) )
			If SC6->( dbSeek( xFilial( 'SC6' ) + (cTRB)->(Z5_PEDIDO + Z5_ITEMPV ) ) )
				cB1_COD    := SC6->C6_PRODUTO
				cB1_DESC   := SC6->C6_DESCRI
				cC6_LOJDED := SC6->C6_LOJDED
				cC6_ITEM   := SC6->C6_ITEM
				cC6_SERIE  := SC6->C6_SERIE
				cC6_NOTA   := SC6->C6_NOTA
				nC6_QTDVEN := SC6->C6_QTDVEN
			Endif
		Else
			// Com o Z5_PEDGAR tentar localizar o pedido de venda.
			If .NOT. TemPV( (cTRB)->Z5_PEDGAR, (cTRB)->B1_COD )
				// Não localizado o pedido de venda, tente localizar o voucher.
				If TemVoucher( (cTRB)->Z5_PEDGAR, (cTRB)->B1_COD )
					cC5_NUM     := SC5->C5_NUM
					cC5_XNPSITE := SC5->C5_XNPSITE
					cC5_TIPMOV  := SC5->C5_TIPMOV
					cC6_LOJDED  := SC6->C6_LOJDED
					cC6_ITEM    := SC6->C6_ITEM
					cC6_SERIE   := SC6->C6_SERIE
					cC6_NOTA    := SC6->C6_NOTA
					nC6_QTDVEN  := SC6->C6_QTDVEN
				Else
					cOBSERV   := 'NÃO LOCALIZEI PV'
				Endif
			Else
				cC5_NUM     := SC5->C5_NUM
				cC5_XNPSITE := SC5->C5_XNPSITE
				cC5_TIPMOV  := SC5->C5_TIPMOV
				cC6_LOJDED  := SC6->C6_LOJDED
				cC6_ITEM    := SC6->C6_ITEM
				cC6_SERIE   := SC6->C6_SERIE
				cC6_NOTA    := SC6->C6_NOTA
				nC6_QTDVEN  := SC6->C6_QTDVEN
			Endif
			cB1_COD  := (cTRB)->B1_COD
			cB1_DESC := (cTRB)->B1_DESC
		Endif
		
		// Se não achou o pedido de venda e tem Z5_PEDGAR tem Z5_CODVOU e o Z5_TIPVOU é 2/4/A/B/D
		// com o Z5_PEDGAR, buscar o registro na ZF_COD, ao encontrar pegar o ZF_PEDIDO e localizar o C5_XNPSITE
		If	cC5_NUM == '' .AND.;
			.NOT. Empty( (cTRB)->Z5_PEDGAR ) .AND.;
			.NOT. Empty( (cTRB)->Z5_CODVOU ) .AND.;
			RTrim( (cTRB)->Z5_TIPVOU ) $ '2|4|A|B|D'
			If TemVoucher( (cTRB)->Z5_CODVOU, (cTRB)->B1_COD, RTrim( (cTRB)->Z5_TIPVOU ), @cOBSERV, @nC6_QTDVEN, cTRB ) 
				cC5_NUM     := SC5->C5_NUM
				cC5_XNPSITE := SC5->C5_XNPSITE
				cC5_TIPMOV  := SC5->C5_TIPMOV
				cC6_LOJDED  := SC6->C6_LOJDED
				cC6_ITEM    := SC6->C6_ITEM
				cC6_SERIE   := SC6->C6_SERIE
				cC6_NOTA    := SC6->C6_NOTA
				If nC6_QTDVEN == 0
					nC6_QTDVEN  := SC6->C6_QTDVEN
				Endif
			Endif
		Endif
		
		If .NOT. Empty( cC5_TIPMOV )
			cC5_TIPMOV := aC5_TIPMOV[ Val( SubStr( cC5_TIPMOV, 1, 1 ) ) ]
		Endif

		If .NOT. Empty( (cTRB)->Z5_TIPMOV )
			cZ5_TIPMOV := aZ5_TIPMOV[ Val( SubStr( (cTRB)->Z5_TIPMOV, 1, 1 ) ) ]
		Endif
		
		//------------------------------------------------------------
		// Caso não seja localizado o faturamento,
		// atribuir a variável o estado do PD (ponto de distribuição).
		//------------------------------------------------------------
		If Empty( cC6_LOJDED )
			cC6_LOJDED := (cTRB)->A2_EST
		Endif
		
		If .NOT. Empty(cC6_LOJDED) .AND. .NOT. Empty(cC6_NOTA) .AND. .NOT. Empty(cC6_SERIE)
			SD2->( dbSetOrder( 3 ) )
			lAcheiNF := SD2->( dbSeek( cC6_LOJDED + cC6_NOTA + cC6_SERIE ) )
			If lAcheiNF
				cD2_EST := SD2->D2_EST
			Endif
		Endif

		//--------------------------------------------------------------------------------------------------
		// Se a UF do PD está contido no parâmetro AND a filial de faturamento está contido no parâmetro OR
		// Se a filial de faturamento não está contida no parâmetro e a UF do PD não está contida no parâmetro.
		// Ambas condições verdadeiras não há ação.
		//--------------------------------------------------------------------------------------------------
		lSemAcao := ( ( At( (cTRB)->A2_EST, cMV_XFILFAT )>0 .AND. At( cC6_LOJDED, cMV_XFILFAT)>0 ) ;
		            .OR. ;
		            ( At( cC6_LOJDED, cMV_XFILFAT)==0 .AND. At( (cTRB)->A2_EST, cMV_XFILFAT )==0 ) )
		
		// Coletar os dados sintéticos.
		(cTRB)->( AAdd( aDados, { Z5_PEDGAR,;
		cC5_NUM,;
		cC6_LOJDED,cC6_ITEM,cC6_SERIE,cC6_NOTA,Iif(nC6_QTDVEN==0,1,nC6_QTDVEN),'',;
		cC5_XNPSITE,cC5_TIPMOV,;
		cZ5_TIPMOV,Z5_CODVOU,Z5_TIPVOU,Dtoc(Stod(Z5_DATVAL)),Dtoc(Stod(Z5_DATVER)),Dtoc(Stod(Z5_DATEMIS)),Dtoc(Stod(Z5_EMISSAO)),Dtoc(Stod(Z5_DATPED)),Z5_VALORHW,Z5_GRUPO,;
		Z3_CODGAR,Z3_CODENT,Z3_DESENT,Z3_ESTADO,;
		Z8_COD,Z8_DESC,;
		A2_COD,A2_LOJA,A2_NOME,A2_EST,;
		cB1_COD,cB1_DESC,;
		Z5_PEDSITE,Z5_PEDIDO,Z5_ITEMPV,Z5_GRUPO,Z5_DESGRU,Z5_TIPODES,Z5_NFDEV,;
		Z5_PRODGAR, PA8_DESBPG,;
		Iif( lSemAcao, 'não há ação (' + (cTRB)->A2_EST +'/'+ cC6_LOJDED + ')', (cTRB)->A2_EST +' para '+ cC6_LOJDED ),;
		cOBSERV } ) )
		
		If lAcheiNF
			aDados[ Len( aDados ), 8 ] :=  SD2->D2_EST
			If At( SD2->D2_EST, cMV_XFILFAT ) > 0 .AND. At( SD2->D2_FILIAL, cMV_XFILFAT ) > 0 .AND. At( (cTRB)->A2_EST, cMV_XFILFAT ) == 0
				nP := AScan( aSummary1,;
	         	{|e| e[ 1 ]==SD2->D2_FILIAL .AND. e[ 2 ]==SD2->D2_EST .AND. e[ 3 ]==(cTRB)->A2_EST .AND. e[ 4 ]==cB1_COD } )
				
		   		If nP == 0
				  	AAdd( aSummary1, { SD2->D2_FILIAL, SD2->D2_EST, (cTRB)->A2_EST, cB1_COD, nC6_QTDVEN } )
				Else
				  	aSummary1[ nP, 5 ] += nC6_QTDVEN
				Endif    
			Else
				//---------------------------------
				// Exemplo: Filial/SP e PD é do RJ.
				//---------------------------------
				If SD2->D2_FILIAL == '02' .AND. (cTRB)->A2_EST == 'RJ'
				   nP := AScan( aSummary2,;
				   {|e| e[ 1 ]==SD2->D2_FILIAL .AND. e[ 2 ]==SD2->D2_EST .AND. e[ 3 ]==(cTRB)->A2_EST .AND. e[ 4 ]==cB1_COD } )
					   
				   If nP == 0
				   	AAdd( aSummary2, { SD2->D2_FILIAL, SD2->D2_EST, (cTRB)->A2_EST, cB1_COD, nC6_QTDVEN } )
				   Else
				   	aSummary2[ nP, 5 ] += nC6_QTDVEN
				   Endif
				Endif
			Endif
		Endif 
		
		// Coletar os dados analíticos por produto.
		nJ := AScan( aProdutos, {|e| e[ 1 ] == cB1_COD } )
		If nJ == 0 
			AAdd( aProdutos, { cB1_COD, cB1_DESC, nC6_QTDVEN } )
		Else
			aProdutos[ nJ, 3 ] += nC6_QTDVEN
		Endif
		
		cB1_COD     := ''
		cB1_DESC    := ''
		cC5_TIPMOV  := ''
		cC5_NUM     := ''
		cC5_XNPSITE := ''
		cC6_LOJDED  := ''
		cC6_ITEM    := ''
		cC6_SERIE   := ''
		cC6_NOTA    := ''
		nC6_QTDVEN  := 0
		cD2_EST     := ''
		cZ5_TIPMOV  := ''
		cOBSERV     := ''
		
		(cTRB)->( dbSkip() ) 
	End
	(cTRB)->( dbCloseArea() )
	
	If Len( aDados ) > 0
		oFwMsEx := FWMsExcel():New()
		/*****
		 * 
		 * Descarregar os dados analíticos.
		 *
		 */
		aHead:={'Z5_PEDGAR',;
		'C5_NUM',;
		'FILIAL_FAT','C6_ITEM','C6_SERIE','C6_NOTA','C6_QTDVEN','Estado Cliente',;
		'C5_XNPSITE','C5_TIPMOV',;
		'Z5_TIPMOV','Z5_CODVOU','Z5_TIPVOU','Z5_DATVAL','Z5_DATVER','Z5_DATEMIS','Z5_EMISSAO','Z5_DATPED','Z5_VALORHW','Z5_GRUPO',;
		'Z3_CODGAR','Z3_CODENT','Z3_DESENT','Z3_ESTADO',;
		'Z8_COD','Z8_DESC',;
		'A2_COD','A2_LOJA','A2_NOME','Estado PD',;
		'B1_COD','B1_DESC',;
		'Z5_PEDSITE','Z5_PEDIDO','Z5_ITEMPV','Z5_GRUPO','Z5_DESGRU','Z5_TIPODES','Z5_NFDEV',; 
		'Z5_PRODGAR','PA8_DESBPG',;
		'DE/PARA',;
		'OBSERVAÇÃO' }
		
		cWorkSheet := 'Informação analítica'
		cTable := cWorkSheet
		
		oFwMsEx:AddWorkSheet( cWorkSheet )
		oFwMsEx:AddTable( cWorkSheet, cTable )	
	
		AEval( aHead, {|value,index|  oFwMsEx:AddColumn( cWorkSheet, cTable, value, 1, iif(index==7,2,1), (index==7) ) } )
		
		For nJ := 1 To Len( aDados )
			If .NOT. lJob
				If lEnd
					Exit
				Endif
				MsProcTxt( 'Aguarde, decarregando os dados ' + aPoint[ ++nPoint ] )
				ProcessMessage()
				If nPoint == nMaxPoint
					nPoint := 0
				Endif
			Endif
			oFwMsEx:AddRow( cWorkSheet, cTable, aDados[ nJ ] )
		Next nJ
		
		/*****
		 * 
		 * Descarregar os dados sintéticos de produtos.
		 *
		 */
		aHead:={'B1_COD','B1_DESC','C6_QTDVEN'}

		cWorkSheet := 'Sintética produto'
		cTable := cWorkSheet
		
		oFwMsEx:AddWorkSheet( cWorkSheet )
		oFwMsEx:AddTable( cWorkSheet, cTable )	
	
		AEval( aHead, {|value,index|  oFwMsEx:AddColumn( cWorkSheet, cTable, value, 1, iif(index==3,2,1), (index==3) ) } )
		
		For nJ := 1 To Len( aProdutos )
			If .NOT. lJob
				If lEnd
					Exit
				Endif
				MsProcTxt( 'Aguarde, descarregando os dados ' + aPoint[ ++nPoint ] )
				ProcessMessage()
				If nPoint == nMaxPoint
					nPoint := 0
				Endif
			Endif
			oFwMsEx:AddRow( cWorkSheet, cTable, aProdutos[ nJ ] )
		Next nJ
		
		aHead := { 'FILIAL FAT', 'UF/CLIENTE', 'UF/PD', 'PRODUTO','QUANTIDADE' }
		
		cWorkSheet := 'Transf Estoq Central SP-RJ'
		cTable := 'Transferência Estoque Central SP-RJ - ordenado por: PRODUTO + UF CLIENTE'
		
		oFwMsEx:AddWorkSheet( cWorkSheet )
		oFwMsEx:AddTable( cWorkSheet, cTable )	
		
		AEval( aHead, {|value,index|  oFwMsEx:AddColumn( cWorkSheet, cTable, value, 1, iif(index==5,2,1), .F. ) } )
		
		ASort( aSummary1,,, {|a,b| a[ 4 ] + a[ 2 ] < b[ 4 ] + b[ 2 ] } ) 
		
		cBreak := Iif( Len( aSummary1 )>0, aSummary1[ 1, 4 ], '' )
		
		For nJ := 1 To Len( aSummary1 )
			If .NOT. lJob
				If lEnd
					Exit
				Endif
				MsProcTxt( 'Aguarde, descarregando os dados ' + aPoint[ ++nPoint ] )
				ProcessMessage()
				If nPoint == nMaxPoint
					nPoint := 0
				Endif
			Endif
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
		
		cWorkSheet := 'Transf Estoq Central RJ-SP'
		cTable := 'Transferência Estoque Central RJ-SP  - ordenado por: PRODUTO + UF CLIENTE'
		
		oFwMsEx:AddWorkSheet( cWorkSheet )
		oFwMsEx:AddTable( cWorkSheet, cTable )	
		
		AEval( aHead, {|value,index|  oFwMsEx:AddColumn( cWorkSheet, cTable, value, 1, iif(index==5,2,1), .F. ) } )
		
		ASort( aSummary2,,, {|a,b| a[ 4 ] + a[ 2 ] < b[ 4 ] + b[ 2 ] } )
		
		nSubTotal := 0
		cBreak := Iif( Len( aSummary2 )>0, aSummary2[ 1, 4 ], '' )
		
		For nJ := 1 To Len( aSummary2 )
			If .NOT. lJob
				If lEnd
					Exit
				Endif
				MsProcTxt( 'Aguarde, descarregando os dados ' + aPoint[ ++nPoint ] )
				ProcessMessage()
				If nPoint == nMaxPoint
					nPoint := 0
				Endif
			Endif
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
		
		aHead:={'Parâmetro','Conteúdo'}

		cWorkSheet := 'Parâmetros digitados'
		cTable := cWorkSheet
		
		oFwMsEx:AddWorkSheet( cWorkSheet )
		oFwMsEx:AddTable( cWorkSheet, cTable )	
	
		AEval( aHead, {|value,index|  oFwMsEx:AddColumn( cWorkSheet, cTable, value, 1, iif(index==3,2,1), (index==3) ) } )

		oFwMsEx:AddRow( cWorkSheet, cTable, { 'Período de'				, MV_PAR01 } )
		oFwMsEx:AddRow( cWorkSheet, cTable, { 'Período até'				, MV_PAR02 } )
		oFwMsEx:AddRow( cWorkSheet, cTable, { 'Desconsiderar posto(s)'	, MV_PAR03 } )
		oFwMsEx:AddRow( cWorkSheet, cTable, { 'Considerar posto(s)'		, MV_PAR04 } )

		cFile := CriaTrab( NIL, .F. ) + '.xml'
		While File( cFile )
			cFile := CriaTrab( NIL, .F. ) + '.xml'
		End

		oFwMsEx:Activate()
		cDir := GetSrvProfString('Startpath','')
		
		If .NOT. lJob
			LjMsgRun( 'Gerando o arquivo, aguarde...', cCadastro, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
		Else
			oFwMsEx:GetXMLFile( cFile )
			Sleep( 500 )
		Endif
		
		If .NOT. lJob
			cDirTmp := GetTempPath()
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
				MsgAlert( 'Não consegui copiar o arquivo da WorkSpace Protheus p/ o \temp\ do usuário.', cCadastro )
			Endif
		Else
			cMailTo := GetMv( cMV_830_01, .F. )			
			MailFormatText( .T. )
			If FSSendMail( cMailTo,;
			               'RELATÓRIO DE CONSUMO DE MÍDIAS',;
			               'Prezado, '+CRLF+'Anexo o arquivo com o resultado do processamento do relatório de consumo de mídias.'+CRLF+;
			               'Por favor, não responda este e-mail.'+CRLF+;
			               'Atenciosamente,'+CRLF+CRLF+;
			               'Sistemas Corporativos', ( cDir + cFile ) )
				CONOUT('ENVIADO COM SUCESSO E-MAIL DO RELATÓRIO DE CONSUMO DE MÍDIAS CONFORME MV_830MAIL: ' + cMailTo )
			Else
				CONOUT('NÃO ENVIADO E-MAIL DO RELATÓRIO DE CONSUMO DE MÍDIAS CONFORME MV_830MAIL: ' + cMailTo )
			Endif
			MailFormatText( .F. )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | TemPV      | Autor | Robson Gonçalves        | Data | 14/07/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para tentar localizar o pedido de vendas.
//        | 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function TemPV( cChave, cProduto, cTipoVoucher, cOBSERV )
	Local lRet := .F.
	If cTipoVoucher == 'D'
		SC5->( dbSetOrder( 1 ) ) // c5_filial + c5_num 
		lRet := SC5->( dbSeek( xFilial( 'SC5' ) + cChave ) )
	Else
		SC5->( dbOrderNickName( 'NUMPEDGAR' ) ) // c5_filial + c5_chvbpag
		lRet := SC5->( dbSeek( xFilial( 'SC5' ) + cChave ) )
	Endif
	If	lRet
		lRet := .F. 
		SC6->( dbSetOrder( 1 ) )
		If SC6->( dbSeek( SC5->( C5_FILIAL + C5_NUM ) ) )
			While SC6->( .NOT. EOF() ) .AND. SC6->C6_FILIAL == SC5->C5_FILIAL .AND. SC6->C6_NUM == SC5->C5_NUM
				If SC6->C6_PRODUTO == cProduto
					lRet := .T.
					Exit
				Endif
				SC6->( dbSkip() )
			End
			If .NOT. lRet
				cOBSERV := 'PV '+ SC5->C5_NUM + ' produtos divergentes, o código deveria ser: ' + cProduto + '.'
			Endif 
		Endif
	Endif	
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | TemVoucher | Autor | Robson Gonçalves        | Data | 14/07/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para tentar localizar o voucher.
//        | 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function TemVoucher( cChave, cProduto, cTipoVoucher, cOBSERV, nC6_QTDVEN, cTRB )
	Local cSQL := ''
	Local cTMP := ''
	Local lRet := .F.
	SZF->( dbSetOrder( 2 ) ) // zf_filial + zf_cod (voucher)
	If SZF->( dbSeek( xFilial( 'SZF' ) + cChave ) )
		If cTipoVoucher == 'D'
			cTMP := 'QtdVoucher'
			cSQL := "SELECT ZG_QTDSAI " 
			cSQL += "FROM   "+RETSQLNAME("SZG")+" SZG " 
			cSQL += "WHERE  ZG_FILIAL = "+VALTOSQL(XFILIAL("SZG"))+" " 
			cSQL += "       AND ZG_NUMPED = "+VALTOSQL( (cTRB)->Z5_PEDGAR )+" "
			cSQL += "       AND ZG_NUMVOUC = "+VALTOSQL(cChave)+" "
			cSQL += "       AND SZG.D_E_L_E_T_ = ' ' " 
			cSQL := ChangeQuery( cSQL )
			dbUseArea( .T., 'TOPCONN', TcGenQry(,, cSQL ), cTMP, .T., .T. )
			nC6_QTDVEN := (cTMP)->ZG_QTDSAI
			(cTMP)->( dbCloseArea() )
			lRet := TemPV( SZF->ZF_PEDIDOV, cProduto, cTipoVoucher, @cOBSERV )
		Else
			lRet := TemPV( SZF->ZF_PEDIDO, cProduto, cTipoVoucher, @cOBSERV )
		Endif
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | PostDist   | Autor | Robson Gonçalves        | Data | 14/07/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para visualizar e selecionar o posto de distribuição.
//        | 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function PostDist()
	Local oDlg
	Local oLbx
	Local oWnd 
	Local oMrk 
	Local oNoMrk
	
	Local oPanelAll
	Local oPanelBot
	Local oPanelTop
	
	Local oOrdem
	Local oSeek
	Local oPesq 
	
	Local nI := 0
	Local nOpc := 0
	Local nOrd := 1
	Local lMark := .F.
	
	Local cTitulo := 'Posto de distribição'
	Local cNomeCpo := ''
	Local cConteudo := ''
	Local cOrd := ''
	Local cSeek := Space(100)
	
	Local aDados := {}
	Local aButton := {}
	
	Private cTitulo := 'Posto de distribuição'
	
	cNomeCpo := ReadVar()
	cConteudo := RTrim( &( ReadVar() ) )
	
	FwMsgRun(,{|| xGetDados(lMark,cConteudo,aDados)},,'Buscando os dados...')
	
	If Len( aDados ) > 0
		lMark := .T.
		oWnd := GetWndDefault()
		oMrk := LoadBitmap( GetResources(), 'LBOK' )
		oNoMrk := LoadBitmap( GetResources(), 'LBNO' )
		aOrdem := {'Posto','Fornecedor','Descrição do posto','Nome do fornecedor'}
		
		AAdd( aButton,{ 'PESQUISA', {|| Pesq(@oLbx,aDados) }, 'Pesquisar', 'Pesquisa' } )
		
		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 400,800 PIXEL
			oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelTop:Align := CONTROL_ALIGN_TOP
			
			@ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
			@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
			@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (Pesq2(nOrd,cSeek,@oLbx))
			
			oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT
			
			oLbx := TwBrowse():New(0,0,0,0,,{'X','Cód.Posto','Cód.Fornec.','Nome do Posto','Nome do Fornecedor'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oLbx:Align := CONTROL_ALIGN_ALLCLIENT
			oLbx:SetArray( aDados )
			oLbx:bLine := {|| {Iif(aDados[oLbx:nAt,1],oMrk,oNoMrk),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3],aDados[oLbx:nAt,4],aDados[oLbx:nAt,5]}}
			oLbx:bLDblClick := {||  aDados[ oLbx:nAt, 1 ] := ! aDados[ oLbx:nAt, 1 ] }
			oLbx:bHeaderClick := {|| AEval( aDados, {|p| p[1] := lMark } ), lMark := !lMark, oLbx:Refresh() }

			oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelBot:Align := CONTROL_ALIGN_BOTTOM
			
			@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION (nOpc := 1, oDlg:End())
			@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
		ACTIVATE MSDIALOG oDlg CENTER
		If nOpc == 1
			cConteudo := ''
			For nI := 1 To Len( aDados )
				If aDados[ nI, 1 ]
					cConteudo += aDados[ nI, 2 ] + ';'
				Endif
			Next nI
			cConteudo := Substr( cConteudo, 1, Len( cConteudo ) -1 )
			&( cNomeCpo ) := cConteudo
			If oWnd <> NIL
				GetdRefresh()
			Endif
		Endif
	Else
		MsgAlert( 'Dados não localizados', cTitulo )
	Endif
Return(cConteudo)

//--------------------------------------------------------------------------
// Rotina | Pesq2      | Autor | Robson Gonçalves        | Data | 14/07/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para pesquisar o posto de distribuição.
//        | 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function Pesq2(nOrd,cSeek,oLbx)
	Local nP := 0
	Local nColPesq := 0
		
	If nOrd==1       ; nColPesq := 2
	Elseif nOrd == 2 ; nColPesq := 3
	Elseif nOrd == 3 ; nColPesq := 4
	Elseif nOrd == 4 ; nColPesq := 5
	Else
		MsgAlert('ATENÇÃO<br><br>Opção não disponível para pesquisa.','Pesquisar')
	Endif
	
	If nColPesq > 0
		nP := AScan( oLbx:aArray, {|p| Upper( AllTrim( cSeek ) ) $ Upper( AllTrim( p[ nColPesq ] ) ) } )	
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('ATENÇÃO<br><br>Informação não localizada.','Pesquisar')
		Endif
	Endif
Return(.T.)

Static Function xGetDados(lMark,cConteudo,aDados)
	SZ8->(dbSetOrder(1))
	SZ8->(dbSeek(xFilial('SZ8')))
	While ! SZ8->(EOF()) .And. SZ8->Z8_FILIAL==xFilial('SZ8')
		lMark := SZ8->Z8_COD $ cConteudo
		SZ8->(AAdd( aDados, { lMark, Z8_COD, Z8_FORNEC, Z8_DESC, Z8_NOMFOR } ) )
		SZ8->(dbSkip())
	End
Return

//--------------------------------------------------------------------------
// Rotina | Pesq       | Autor | Robson Gonçalves        | Data | 14/07/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para pesquisar o posto de distribuição.
//        | 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function Pesq(oLbx,aDados)
	Local oDlgPesq
	Local oOrdem
	Local oChave 
	Local oBtOk
	Local oBtCan
	
	Local cOrdem := ''
	Local cTitulo := 'Pesquisa'
	Local cChave := Space(50)
	
	Local aOrdens := {}

	Local nP := 0
	Local nOrdem := 1
	Local nOpcao := 0

	aOrdens := {'Posto','Fornecedor','Descrição do posto','Nome do fornecedor'}
	
	DEFINE MSDIALOG oDlgPesq TITLE cTitulo FROM 00,00 TO 78,500 PIXEL
		@ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
		@ 021, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
	
		DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
		DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	ACTIVATE MSDIALOG oDlgPesq CENTER
	
	If nOpcao == 1
		cChave := Upper( AllTrim( cChave ) )
		nP := AScan( aDados,{|p| cChave $ Upper( p[ nOrdem+1 ] ) } )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgAlert( 'Busca não localizada', cTitulo )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | XBPosto    | Autor | Robson Gonçalves        | Data | 14/07/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para criar a estrutura da consulta SXB.
//        | 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function XBPosto()
	Local nI := 0
	Local nJ := 0
	Local aCpoSXB := {}
	Local aSXB := {}
	Local cTamSXB := 0
	Local cXB_ALIAS := 'XBPOST'
	
	SXB->( dbSetOrder( 1 ) )
	If ! SXB->( dbSeek( cXB_ALIAS ) )
		nTamSXB := Len( SXB->XB_ALIAS )
		aCpoSXB := { 'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM' }
		
		AAdd(aSXB,{cXB_ALIAS,'1','01','RE','Posto distribuicao','Posto distribuicao','Posto distribuicao','SZ8',''})
		AAdd(aSXB,{cXB_ALIAS,'2','01','01','Posto distribuicao','Posto distribuicao','Posto distribuicao','U_PostDist()',''})
		AAdd(aSXB,{cXB_ALIAS,'5','01','','','','','SZ8->Z8_COD',''})
		
		SXB->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aSXB )
			If ! SXB->( dbSeek( PadR( aSXB[ nI, 1 ], nTamSXB ) + aSXB[ nI,2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
				SXB->( RecLock( 'SXB', .T. )) 
				For nJ := 1 To Len( aCpoSXB )
					SXB->( FieldPut( FieldPos( aCpoSXB[ nJ ] ), aSXB[ nI, nJ ] ) )
				Next nJ
				SXB->( MsUnLock() )
			Endif
		Next nI
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | CSFA831    | Autor | Robson Gonçalves        | Data | 14/07/2017
//--------------------------------------------------------------------------
// Descr. | Rotina pora buscar os PA sem PD.
//        | 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA831()
	Local aDados := {}
	Local aHead := {}
	Local cDir := ''
	Local cDirTmp := ''
	Local cFile := ''
	Local cSQL := ''
	Local cTable := ''
	Local cTRB := ''
	Local cWorkSheet := ''
	Local nFCount := 0
	Local nI := 0
	Local oExcelApp
	Local oFwMsEx

	If .NOT. MsgYesNo('Continuar com a rotina de analistas os postos de atendimento orfão?')
		Return
	Endif
	
	cSQL := "SELECT Z3_CODENT, "
	cSQL += "       Z3_DESENT, "
	cSQL += "       Z3_CODGAR, "
	cSQL += "       Z3_CODAC, "
	cSQL += "       Z3_DESAC, "
	cSQL += "       Z3_CGC, "
	cSQL += "       Z3_CODAR, "
	cSQL += "       Z3_DESAR "
	cSQL += "FROM   "+RetSqlName("SZ3")+" SZ3 "
	cSQL += "WHERE  Z3_FILIAL = "+ValToSql(xFilial("SZ3"))+" "
	cSQL += "       AND Z3_TIPENT = '4' "
	cSQL += "       AND Z3_PONDIS = ' ' "
	cSQL += "       AND D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TcGenQry(,, cSQL ), cTRB, .T., .T. )
	dbSelectArea( cTRB )
	
	nFCount := (cTRB)->( FCount() )
	
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To nFCount
		If SX3->( dbSeek( (cTRB)->( FieldName( nI ) ) ) )
			AAdd( aHead, X3Titulo() )
		Endif 
	Next nI
	
	oFwMsEx := FWMsExcel():New()
	
	cWorkSheet := 'PA órfão'
	cTable := cWorkSheet
	
	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )	
	
	AEval( aHead, {|value,index|  oFwMsEx:AddColumn( cWorkSheet, cTable, value, 1, 1, .F. ) } )
	
	While (cTRB)->( .NOT. EOF() )
		For nI := 1 To nFCount
			AAdd( aDados, (cTRB)->( FieldGet( nI ) ) )
		Next nI
		oFwMsEx:AddRow( cWorkSheet, cTable, aDados )
		aDados := {}
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	
	cFile := CriaTrab( NIL, .F. ) + '.xml'
	While File( cFile )
		cFile := CriaTrab( NIL, .F. ) + '.xml'
	End
	
	oFwMsEx:Activate()
	cDirTmp := GetTempPath()
	cDir := GetSrvProfString('Startpath','')
	
	LjMsgRun( 'Gerando o arquivo, aguarde...', '', {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
	
	If __CopyFile( cFile, cDirTmp + cFile )
		If ApOleClient( 'MsExcel' ) 
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cFile )
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			Sleep(500)
		Else
			MsgInfo( 'Não localizei o aplicativo MsExcel. O arquivo ' + cFile + ' foi gerado na pasta temporária do seu usuário.' )
			WinExec( 'Explorer ' + cDirTmp )
		Endif
	Endif
Return

/*
SELECT Z5_PEDGAR,
       Z5_TIPMOV,
       Z5_CODVOU,
       Z5_TIPVOU,
       Z5_DATVAL,
       Z5_DATVER,
       Z5_DATEMIS,
       Z5_EMISSAO,
       Z5_DATPED,
       Z5_VALORHW,
       Z5_GRUPO,
       Z5_TIPO,
       Z3_CODGAR,
       Z3_CODENT,
       Z3_DESENT,
       Z3_ESTADO,
       Z8_COD,
       Z8_DESC,
       A2_COD,
       A2_LOJA,
       A2_NOME,
       A2_EST,
       B1_COD,
       B1_DESC,
       Z5_PEDSITE,
       Z5_PEDIDO,
       Z5_ITEMPV,
       Z5_GRUPO,
       Z5_DESGRU, 
       Z5_TIPODES,
       Z5_NFDEV,
       Z5_PRODGAR,
       PA8_DESBPG
FROM   SZ5010 SZ5
       LEFT JOIN SZ3010 SZ3
               ON Z3_FILIAL = ' '
                  AND Z3_CODGAR = Z5_CODPOS
                  AND Z3_CODGAR > ' '
                  AND Z3_TIPENT = '4'
                  AND SZ3.D_E_L_E_T_ = ' '
       LEFT JOIN "+RetSqlName("SZ8")+" SZ8
               ON Z8_FILIAL = ' '
                  AND Z8_COD = Z3_PONDIS
                  AND SZ8.D_E_L_E_T_ = ' '
       INNER JOIN SA2010 SA2
               ON A2_FILIAL = ' '
                  AND A2_COD = Z8_FORNEC
                  AND SA2.D_E_L_E_T_ = ' '
       INNER JOIN SG1010 SG1
               ON G1_FILIAL = '02'
                  AND G1_COD = Z5_PRODUTO
                  AND SG1.D_E_L_E_T_ = ' '
       INNER JOIN SB1010 SB1
               ON B1_FILIAL = '02'
                  AND B1_COD = G1_COMP
                  AND B1_CATEGO = '1'
                  AND SB1.D_E_L_E_T_ = ' '
       INNER JOIN PA8010 PA8
               ON PA8.PA8_FILIAL = '  '
                  AND PA8.PA8_CODBPG = SZ5.Z5_PRODGAR
                  AND PA8.D_E_L_E_T_ = ' ' "
WHERE  Z5_FILIAL = ' '
       AND Z5_DATVER >= '2017...'
       AND Z5_DATVER <= '2017...'
       AND SZ5.Z5_PRODGAR > ' '
       AND SZ5.Z5_PEDGANT = ' '
       AND SZ5.Z5_CODPOS > ' '
       AND SZ5.Z5_PEDGAR > ' '
       AND SZ5.D_E_L_E_T_ = ' '
	
	If .NOT. Empty( MV_PAR03 )
		cNaoContido := FormatIn( MV_PAR03, ';' )
		cSQL += "       AND Z8_COD NOT IN " + cNaoContido + " "
	Endif
	
	If .NOT. Empty( MV_PAR04 )
		cContido := FormatIn( MV_PAR04, ';' )
		cSQL += "       AND Z8_COD IN " + cContido + " "
	Endif
	
UNION ALL

SELECT Z5_PEDGAR,
       Z5_TIPMOV,
       Z5_CODVOU,
       Z5_TIPVOU,
       Z5_DATVAL,
       Z5_DATVER,
       Z5_DATEMIS,
       Z5_EMISSAO,
       Z5_DATPED,
       Z5_VALORHW,
       Z5_GRUPO,
       Z5_TIPO,
       Z3_CODGAR,
       Z3_CODENT,
       Z3_DESENT,
       Z3_ESTADO,
       Z8_COD,
       Z8_DESC,
       A2_COD,
       A2_LOJA,
       A2_NOME,
       A2_EST,
       B1_COD,
       B1_DESC,
       Z5_PEDSITE,
       Z5_PEDIDO,
       Z5_ITEMPV,
       Z5_GRUPO,
       Z5_DESGRU, 
       Z5_TIPODES,
       Z5_NFDEV,
       Z5_PRODGAR,
       '        ' AS PA8_DESBPG
FROM   SZ5010 SZ5
       LEFT JOIN SZ3010 SZ3
              ON Z3_FILIAL = ' '
                 AND Z3_CODGAR = Z5_CODPOS
                 AND Z3_CODGAR > ' '
                 AND Z3_TIPENT = '4'
                 AND SZ3.D_E_L_E_T_ = ' '
       LEFT JOIN SZ8010 SZ8
              ON Z8_FILIAL = ' '
                 AND Z8_COD = Z3_PONDIS
                 AND SZ8.D_E_L_E_T_ = ' '
       LEFT JOIN SA2010 SA2
              ON A2_FILIAL = ' '
                 AND A2_COD = Z8_FORNEC
                 AND SA2.D_E_L_E_T_ = ' '
       LEFT JOIN SG1010 SG1
              ON G1_FILIAL = '02'
                 AND G1_COD = Z5_PRODUTO
                 AND SG1.D_E_L_E_T_ = ' '
       LEFT JOIN SB1010 SB1
              ON B1_FILIAL = '02'
                 AND B1_COD = G1_COMP
                 AND B1_CATEGO = '1'
                 AND SB1.D_E_L_E_T_ = ' '
WHERE  Z5_FILIAL = ' '
       AND Z5_EMISSAO >= '2017...'
       AND Z5_EMISSAO <= '2017...'
       AND SZ5.Z5_PEDGAR = ' '
       AND SZ5.Z5_CODPOS > ' '
       AND SZ5.Z5_TIPO = 'ENTHAR'
       AND SZ5.D_E_L_E_T_ = ' '

	If .NOT. Empty( MV_PAR03 )
		cNaoContido := FormatIn( MV_PAR03, ';' )
		cSQL += "       AND Z8_COD NOT IN " + cNaoContido + " "
	Endif
	
	If .NOT. Empty( MV_PAR04 )
		cContido := FormatIn( MV_PAR04, ';' )
		cSQL += "       AND Z8_COD IN " + cContido + " "
	Endif

ORDER  BY  Z5_PEDGAR

*/