#Include 'Protheus.ch'
#Include 'Report.ch'

User Function vndr020()
	Local oReport 
	
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Local aPar	:= {}
	Local bOk	:= nil
	Local aRet	:= {}
		
	Private cCargDe		:= ""
	Private cCargAt		:= ""
	
	Private aCPO := {}
	Private aPicture := {}
	Private cCadastro := 'Relatório de PLP'
	Private cDescriRel := 'Este Relatório obtem as informações PLP´s'

	AAdd( aSay, cDescriRel )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao==1
		AAdd( aPar, { 1, 'Carga De'		,Space(Len(DAI->DAI_COD))    		,'',''                    ,'DAK'      		, '', 50, .F. } )
		AAdd( aPar, { 1, 'Carga Até'	,Space(Len(DAI->DAI_COD))    		,'','(mv_par01<=mv_par02)','DAK'      		, '', 50, .T. } )

		bOK := {|| .T. }
	
		If !ParamBox( aPar, 'Parâmetros de processamento', @aRet, bOk,,,,,,,.T.,.T.)
			Return
		Endif
	
		cCargDe		:= aRet[1]
		cCargAt		:= aRet[2]
		
		oReport := V002Impr()
		oReport:PrintDialog()
	Endif
Return


Static Function V002Impr() 
	Local cReport := 'VNDR002'
	Local cDescri := cDescriRel
	Local cPerg := ''
	
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

	//----------------------------
	// Estanciar o objeto TReport.
	//----------------------------
	oReport  := TReport():New( cReport, cTitulo, cPerg , { |oObj| ReportPrint( oObj ) }, cDescri )
	oReport:DisableOrientation()
	oReport:nLineHeight := 35  // Altura da linha.
	oReport:nFontBody	:= 9
	oReport:SetLandscape()
	
	//-----------------------------------------
	// Campos que serão tratados no relatórios.
	//-----------------------------------------
	aCPO := {	'PAG_CODPLP'	,;
		  		'A4_XCODCOR'	,;
		  		'A4_NOME'		,;
		  		'PAG_CODRAS'	}
	
	//---------------------------------------------------
	// substituição de títulos das colunas do relatórios.
	//---------------------------------------------------
	AAdd( aTrocaTitulo,{"","" } )
	
	//------------------------------------------------------
	// Quantos caracteres deverão ser diminuidos as colunas.
	//------------------------------------------------------
	AAdd( aTrocaTamanho,{"A4_NOME",10 } )

	//-------------------------------------------
	// Definir a seção e as células do relatório.
	//-------------------------------------------
	DEFINE SECTION oSection OF oReport TITLE cTitulo TOTAL IN COLUMN
		
	//----------------------------------------------------------------------------------------
	// Definir título, alinhamento do dado, picture e tamanho, podendo ser o título ou o dado.
	//----------------------------------------------------------------------------------------
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
				AAdd( aSizeCol, Max( aTrocaTamanho[ nP, 2 ], Len( aHeader[ Len( aHeader ) ] ) ) )
			Else
				AAdd( aSizeCol, Max( SX3->( X3_TAMANHO + X3_DECIMAL ), Len( aHeader[ Len( aHeader ) ] ) ) )
			Endif
		Endif		
	Next nI
	
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
// Rotina | ReportPrint | Autor | Totvs - David       | Data | 17.10.2013
//-----------------------------------------------------------------------
// Descr. | Impressão dos dados.
//-----------------------------------------------------------------------
Static Function ReportPrint( oReport )
	Local nI,nX := 0
	Local nCPO := 0
	
	Local cTRB := ''
	Local cDado := ''
	
	Local oSection := oReport:Section( 1 )

	Local aCOLS := {}
	
	Local nTotTras	:= 0
	Local nTot		:= 0
	Local nTot01	:= 0
	Local nTot02	:= 0                            	
	Local nTot03	:= 0

	Local aTot		:= {}                     		
	Local aTotGer	:= {}                     		
	Local nPosT		:= 0
	Local nPos		:= 0
	Local nTotTrasX	:= 0
	Local nTotX		:= 0
	Local nTot01X	:= 0
	Local nTot02X	:= 0                            	
	Local nTot03X	:= 0
	Local cTotAnt	:= ""
	
	nCPO := Len( aCPO )
		
	cTRB := GetNextAlias()
	
	BeginSql Alias cTRB
		SELECT
		  PAG.PAG_CODPLP,
		  SA4.A4_XCODCOR,
		  SA4.A4_NOME,
		  PAG.PAG_CODRAS  
		FROM
		  PAG010 PAG INNER JOIN SA4010 SA4 ON
		    SA4.A4_FILIAL = %xFilial:SA4% AND
		    SA4.A4_COD = PAG_CODTRA AND
		    SA4.%NotDel% INNER JOIN DAI010 DAI ON
		      DAI.DAI_FILIAL = %xFilial:DAI% AND
		      DAI.DAI_PEDIDO = PAG.PAG_CODPED AND
		      DAI.%NotDel%
		WHERE
		  PAG.PAG_FILIAL = %xFilial:PAG% AND
		  PAG.PAG_CODPLP <>  ' ' AND
		  PAG.%NotDel% AND
		  DAI.DAI_COD BETWEEN %Exp:cCargDe% AND %Exp:cCargAt%
		ORDER BY
		  PAG.PAG_CODPLP,
		  PAG.PAG_CODRAS 
	EndSql
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo( 'Não há dados para ser extraído.', 'Resultado' )
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	oReport:SetMsgPrint('Aguarde, imprimindo...')
	oReport:SetMeter( Len( aCOLS )+1 )	
	oSection:Init()
	
	oBreak1 :=  tRBreak():New(oReport,{|| oSection:Cell('CEL0'):uPrint},'',.T.,nil,.T.)
	oFunc1	:= tRFunction():New(oSection:Cell('CEL3'),,'COUNT',oBreak1,,,,.F.,.F.,.F.,oSection)
	
	While .NOT. (cTRB)->( EOF() )
		If oReport:Cancel()
			Exit
		Endif
		
		For nI := 1 To nCPO
			If     (cTRB)->( ValType( FieldGet( nI ) ) ) == 'D' ; cDado := Dtoc( (cTRB)->( FieldGet( nI ) ) )
			Elseif (cTRB)->( ValType( FieldGet( nI ) ) ) == 'N' 
				cDado	:= LTrim( TransForm( (cTRB)->( FieldGet( nI ) ), aPicture[ nI ] ) )
			Elseif (cTRB)->( ValType( FieldGet( nI ) ) ) == 'C' 	
				cDado := (cTRB)->( FieldGet( nI ) )
				cDado := StrTran( cDado, "'", "" )
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