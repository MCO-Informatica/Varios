//-----------------------------------------------------------------------
// Rotina | CSFA240    | Autor | Robson Gonçalves     | Data | 29.09.2013
//-----------------------------------------------------------------------
// Descr. | Relação de bens com valor acumulado e depreciado.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
#Include 'Report.ch'

User Function CSFA240()
	Local oReport 
	
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private aCPO := {}
	Private aPicture := {}
	Private cCadastro := 'Relação de Bens - Valor Acumulado e Depreciado'
	Private cDescriRel := 'Esta rotina gera a relação de bens do ativo fixo, valor acumulado e depreciado.'

	AAdd( aSay, cDescriRel )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao==1
		oReport := A240Impr()
		oReport:PrintDialog()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A240Impr   | Autor | Robson Gonçalves     | Data | 29.09.2013
//-----------------------------------------------------------------------
// Descr. | Preparação do relatório.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A240Impr() 
	Local cReport := 'CSFA240'
	Local cDescri := cDescriRel
	Local cPerg := 'CSF240'
	
	Local nP := 0
	Local nI := 0
	Local nX := 0
	Local nLen := 0
	Local nLargura := 0
	Local nSizeCol := 0
	Local nColSpace := 1
	
	Local aAlign := {}
	Local aHeader := {}
	Local aSizeCol := {}
	Local aTrocaTitulo := {}
 	Local aTrocaTamanho := {}
	
	Private oCell
	Private oReport 
	Private oSection 	
	Private cTitulo := cCadastro
	
	CriaSX1( cPerg )
	Pergunte( cPerg, .F. )

	oReport  := TReport():New( cReport, cTitulo, cPerg , { |oObj| ReportPrint( oObj ) }, cDescri )
	oReport:DisableOrientation()
	oReport:SetEnvironment(2)  // Ambiente selecionado. Opções: 1-Server e 2-Cliente.
	oReport:nLineHeight := 35  // Altura da linha.
	oReport:SetLandscape()
	
	aCPO := {'N3_FILIAL','N3_CBASE','N1_CHAPA','N3_ITEM','N3_TIPO','N1_DESCRIC','N3_HISTOR','N3_TXDEPR1','N3_AQUISIC','N3_DINDEPR',;
	         'N3_DTBAIXA','N3_CCONTAB','N3_CDEPREC','N3_CCDEPR','N3_BAIXA','N3_VORIG1','N3_VRDACM1','N3_LIQUIDO','N3_VRDMES1','N3_CCUSTO'}
	
	AAdd( aTrocaTitulo,{ 'Filial'      , 'Fil' } )
	AAdd( aTrocaTitulo,{ 'Codigo Item' , 'Item' } )
	AAdd( aTrocaTitulo,{ 'Dt.Aquis Ori', 'Dt.Aq.Or' } )
	AAdd( aTrocaTitulo,{ 'Ocor Baixa'  , 'Bx' } )
	AAdd( aTrocaTitulo,{ 'Dt In Deprec', 'Dt.In.De' } )
	
	AAdd( aTrocaTamanho,{ 'N3_VORIG1' , 6 } )
	AAdd( aTrocaTamanho,{ 'N3_VRDACM1', 6 } )
	AAdd( aTrocaTamanho,{ 'N3_VRDMES1', 6 } )
	
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCPO )
		If SX3->( dbSeek( aCPO[ nI ] ) )
			AAdd( aHeader, RTrim( SX3->X3_TITULO ) )
			
			nP := AScan( aTrocaTitulo, {|e| e[ 1 ] == aHeader[ Len( aHeader ) ] } )
			If nP > 0
				aHeader[ Len( aHeader ) ] := aTrocaTitulo[ nP, 2 ]
			Endif
			
			If SX3->X3_TIPO == 'N'
				AAdd( aAlign, 'RIGHT' )
			Else
				AAdd( aAlign, 'LEFT' )
			Endif
			
			AAdd( aPicture, RTrim( SX3->X3_PICTURE ) )
			
			nP := AScan( aTrocaTamanho, {|e| e[ 1 ] == aCPO[ nI ] } )
			If nP > 0
				AAdd( aSizeCol, Max( SX3->( X3_TAMANHO + X3_DECIMAL )-aTrocaTamanho[ nP, 2 ], Len( aHeader[ Len( aHeader ) ] ) ) )
			Else
				AAdd( aSizeCol, Max( SX3->( X3_TAMANHO + X3_DECIMAL ), Len( aHeader[ Len( aHeader ) ] ) ) )
			Endif
		Else 
			AAdd( aHeader, 'Vlr.Liquido' )
			AAdd( aAlign, 'RIGHT' )
			AAdd( aPicture, RTrim( Posicione('SX3',2,'N3_VRDACM1','X3_PICTURE') ) )
			AAdd( aSizeCol, 12 )
		Endif
	Next nI

	DEFINE SECTION oSection OF oReport TITLE cTitulo TOTAL IN COLUMN
	
	nLen := Len( aHeader )
	nSizeCol := Len( aSizeCol )
	
	For nX := 1 To nLen
		If nSizeCol > 0
			If nX <= nSizeCol
				nLargura := aSizeCol[ nX ]
			Else
				nLargura := 20
			Endif
		Else
			nLargura := 20
		Endif
		
		DEFINE CELL oCell NAME "CEL"+Alltrim(Str(nX-1)) OF oSection SIZE nLargura TITLE aHeader[ nX ]
		// Tem alinhamento?
		If Len( aAlign ) > 0
			// O elemento do vetor do alinhamento é suficiente em relação ao vetor principal?
			If nX <= Len( aAlign )
				oCell:SetAlign( aAlign[ nX ] )
			Endif
		Endif
	Next nX
	
	oSection:SetColSpace(nColSpace) // Define o espaçamento entre as colunas.
	oSection:nLinesBefore := 2      // Quantidade de linhas a serem saltadas antes da impressão da seção.
	oSection:SetLineBreak(.T.)      // Define que a impressão poderá ocorrer emu ma ou mais linhas no caso das colunas exederem o tamanho da página.
Return( oReport )

//-----------------------------------------------------------------------
// Rotina | ReportPrint | Autor | Robson Gonçalves    | Data | 29.09.2013
//-----------------------------------------------------------------------
// Descr. | Impressão dos dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function ReportPrint( oReport )
	Local nI := 0
	Local nCPO := 0
	
	Local cTRB := ''
	Local cSQL := ''
	Local cDado := ''
	Local cType := ''
	
	Local oSection := oReport:Section( 1 )

	Local aCOLS := {}
	
	nCPO := Len( aCPO )

	cSQL := "SELECT N3_FILIAL, "  + CRLF
	cSQL += "       N3_CBASE, "   + CRLF
	cSQL += "       N1_CHAPA, "   + CRLF
	cSQL += "       N3_TIPO, "   + CRLF
	cSQL += "       N3_ITEM, "    + CRLF
	cSQL += "       N3_HISTOR, "  + CRLF
	cSQL += "       N1_DESCRIC, "  + CRLF
	cSQL += "       N3_TXDEPR1, " + CRLF
	cSQL += "       N3_AQUISIC, " + CRLF
	cSQL += "       N3_DINDEPR, " + CRLF
	cSQL += "       N3_DTBAIXA, " + CRLF
	cSQL += "       N3_CCONTAB, " + CRLF
	cSQL += "       N3_CDEPREC, " + CRLF
	cSQL += "       N3_CCDEPR, "  + CRLF
	cSQL += "       N3_BAIXA, "   + CRLF
	cSQL += "       N3_CCUSTO, "   + CRLF
	cSQL += "       SUM(N3_VORIG1) AS N3_VORIG1, "  + CRLF
	cSQL += "       SUM(N3_VRDACM1) AS N3_VRDACM1, " + CRLF
	cSQL += "       CASE WHEN N3_BAIXA = '0' THEN SUM(N3_VORIG1)-SUM(N3_VRDACM1) ELSE 0 END N3_LIQUIDO, "  + CRLF
	cSQL += "       SUM(N3_VRDMES1) AS N3_VRDMES1"  + CRLF
	cSQL += "FROM   "+RetSqlName("SN3")+" SN3,  "+RetSqlName("SN1")+" SN1 "   + CRLF
	cSQL += "WHERE  SN3.D_E_L_E_T_ = ' ' "    + CRLF
	cSQL += "       AND SN1.D_E_L_E_T_ = ' ' "    + CRLF
	If mv_par01==2
		cSQL += "       AND N3_BAIXA = '0' "          + CRLF
	Endif
	cSQL += "       AND N1_FILIAL = N3_FILIAL "   + CRLF
	cSQL += "       AND N1_CBASE = N3_CBASE  "    + CRLF
	cSQL += "       AND N1_ITEM = N3_ITEM "       + CRLF	
	cSQL += "GROUP  BY N3_CCONTAB, " + CRLF
	cSQL += "          N3_CDEPREC, " + CRLF
	cSQL += "          N3_CCDEPR, "  + CRLF
	cSQL += "          N3_BAIXA, "   + CRLF
	cSQL += "          N3_FILIAL, "  + CRLF
	cSQL += "          N3_CBASE, "   + CRLF
	cSQL += "          N3_ITEM, "    + CRLF
	cSQL += "          N1_CHAPA, "   + CRLF
	cSQL += "          N3_TIPO, "    + CRLF
	cSQL += "          N3_HISTOR, "  + CRLF
	cSQL += "          N1_DESCRIC, " + CRLF
	cSQL += "          N3_TXDEPR1, " + CRLF
	cSQL += "          N3_AQUISIC, " + CRLF
	cSQL += "          N3_DINDEPR, " + CRLF
	cSQL += "          N3_DTBAIXA, " + CRLF
	cSQL += "          N3_CCUSTO "   + CRLF
	cSQL += " ORDER BY N3_CCONTAB,"  + CRLF
	cSQL += "          N3_CDEPREC, " + CRLF
	cSQL += "          N3_CCDEPR, "  + CRLF
	cSQL += "          N3_BAIXA "    + CRLF
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	PLSQuery( cSQL, cTRB )
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo( 'Não há dados para ser extraído.', cTitulo )
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	oReport:SetMsgPrint('Aguarde, imprimindo...')
	oReport:SetMeter( Len( aCOLS ) )	
	oSection:Init()
	
	While .NOT. (cTRB)->( EOF() )
		If oReport:Cancel()
			Exit
		Endif
		For nI := 1 To nCPO
			cType := (cTRB)->( ValType( FieldGet( FieldPos( aCPO[ nI ] ) ) ) )
			If cType     == 'D' ; cDado := Dtoc( (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ) )
			Elseif cType == 'N' ; cDado := LTrim( TransForm( (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ), aPicture[ nI ] ) )
			Elseif cType == 'C' ; cDado := (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ) ; cDado := cDado := StrTran( cDado, "'", "" )
			Endif
			oSection:Cell( 'CEL' + Alltrim( Str( nI-1 ) ) ):SetBlock( &( "{ || '" + cDado + "'}" ) )
		Next nI
		oSection:PrintLine()
		oReport:IncMeter()
		
		(cTRB)->( dbSkip() )
	End
	oSection:Finish()
	(cTRB)->(dbCloseArea())
Return

//-----------------------------------------------------------------------
// Rotina | CriaSX1     | Autor | Robson Gonçalves    | Data | 22.08.2014
//-----------------------------------------------------------------------
// Descr. | Criar o grupo de perguntas/parâmetros./
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function CriaSX1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}

	aAdd(aP,{"Considera baixados?","N", 1,0,"C","","","Sim","Nao","","","",""})
	
	aAdd(aHelp,{"Selecione a opção SIM para considera os","baixados."})
	
	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
		PutSx1(cPerg,;
		cSeq,;
		aP[i,1],aP[i,1],aP[i,1],;
		cMvCh,;
		aP[i,2],;
		aP[i,3],;
		aP[i,4],;
		0,;
		aP[i,5],;
		aP[i,6],;
		aP[i,7],;
		"",;
		"",;
		cMvPar,;
		aP[i,8],aP[i,8],aP[i,8],;
		aP[i,13],;
		aP[i,9],aP[i,9],aP[i,9],;
		aP[i,10],aP[i,10],aP[i,10],;
		aP[i,11],aP[i,11],aP[i,11],;
		aP[i,12],aP[i,12],aP[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
	Next i
Return
