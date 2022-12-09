#Include 'Protheus.ch'
#Include 'Report.ch'

User Function vndr010()
	Local oReport 
	
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Local aPar	:= {}
	Local bOk	:= nil
	Local aRet	:= {}
		
	Private cPedDe		:= ""
	Private cPedAt		:= ""
	Private dEmisDe		:= "" 
	Private dEmisAt		:= ""
	Private cTranDe		:= ""
	Private cTranAt		:= ""
	
	Private aCPO := {}
	Private aPicture := {}
	Private cCadastro := 'Relatório de Rastreamento de Cargas'
	Private cDescriRel := 'Este Relatório obtem as informações de rastreamento das cargas'

	AAdd( aSay, cDescriRel )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao==1
		AAdd( aPar, { 1, 'Pedido De'		,Space(Len(SC5->C5_NUM))    		,'',''                    ,''      		, '', 50, .F. } )
		AAdd( aPar, { 1, 'Pedido At'		,Space(Len(SC5->C5_NUM))    		,'','(mv_par01<=mv_par02)',''      		, '', 50, .T. } )
		AAdd( aPar, { 1, 'Dt. Emi. de'		,Ctod(Space(8))            		,'',''                    ,''      		, '', 50, .F. } )
		AAdd( aPar, { 1, 'Dt. Emi Até'		,Ctod(Space(8))            		,'','(mv_par03<=mv_par04)',''      		, '', 50, .T. } )
		AAdd( aPar, { 1, 'Transp. De'		,Space(Len(SA4->A4_COD))		,'',''                    ,'SA4'   		, '', 50, .F. } )
		AAdd( aPar, { 1, 'Transp. Até'		,Space(Len(SA4->A4_COD))		,'',''                    ,'SA4'   		, '', 50, .F. } )

		bOK := {|| .T. }
	
		If !ParamBox( aPar, 'Parâmetros de processamento', @aRet, bOk,,,,,,,.T.,.T.)
			Return
		Endif
	
		cPedDe		:= aRet[1]
		cPedAt		:= aRet[2]
		dEmisDe		:= aRet[3] 
		dEmisAt		:= aRet[4]
		cTranDe		:= aRet[5]
		cTranAt		:= aRet[6]
		
		oReport := V001Impr()
		oReport:PrintDialog()
	Endif
Return


Static Function V001Impr() 
	Local cReport := 'VNDR001'
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
	oReport:SetEnvironment(2)  // Ambiente selecionado. Opções: 1-Server e 2-Cliente.
	oReport:nLineHeight := 35  // Altura da linha.
	oReport:SetLandscape()
	
	//-----------------------------------------
	// Campos que serão tratados no relatórios.
	//-----------------------------------------
	aCPO := {	'C5_NUM' 		,;                              
				'C5_XNPSITE'   	,;
				'C5_TIPO'   	,;                                                
				'C5_TIPMOV' 	,;
				'C5_EMISSAO' 	,;
				'C9_DATALIB'  	,;
				'C5_CLIENTE' 	,;
				'C5_LOJACLI' 	,;
				'C9_SERIENF'	,;
				'C9_NFISCAL'	,;
				'C5_TRANSP'		,;
				'A4_XCODCOR'	,;
				'A4_NOME'		,;
				'DAI_COD'		,;
				'C6_PRODUTO'	,;
				'C6_DESCRI'	,;
				'PAG_CODRAS'	,;
				'PAG_ENTREG'	,;
				'PAG_CODPLP'	,;
				'C5_FRETE'		,;
				'C6_QTDVEN'		,;
				'C6_VALOR'		}
	
	//---------------------------------------------------
	// substituição de títulos das colunas do relatórios.
	//---------------------------------------------------
	AAdd( aTrocaTitulo,{"","" } )
	
	//------------------------------------------------------
	// Quantos caracteres deverão ser diminuidos as colunas.
	//------------------------------------------------------
	AAdd( aTrocaTamanho,{"A4_NOME",10 } )
	
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

	//-------------------------------------------
	// Definir a seção e as células do relatório.
	//-------------------------------------------
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
		column C5_EMISSAO as Date 
		column C9_DATALIB as Date
		SELECT 
		  SC5.C5_NUM,
		  SC5.C5_XNPSITE,
		  SC5.C5_TIPO,
		  SC5.C5_TIPMOV,
		  SC5.C5_EMISSAO,
		  NVL(SC9.C9_DATALIB,' ') C9_DATALIB,
		  SC5.C5_CLIENTE,
  		  SC5.C5_LOJACLI,
		  NVL(SC9.C9_SERIENF,' ') C9_SERIENF,
		  NVL(SC9.C9_NFISCAL,' ') C9_NFISCAL,
		  SC5.C5_TRANSP,
		  SA4.A4_XCODCOR,
		  SA4.A4_NOME,
		  DAI.DAI_COD,
		  SC6.C6_PRODUTO,
		  SC6.C6_DESCRI,
		  NVL(PAG.PAG_CODRAS, ' ') PAG_CODRAS,
		  NVL(PAG.PAG_ENTREG,' ') PAG_ENTREG,
		  NVL(PAG.PAG_CODPLP,' ') PAG_CODPLP,
		  MAX(SC5.C5_FRETE) C5_FRETE,
		  SUM(SC6.C6_QTDVEN) C6_QTDVEN,
		  SUM(SC6.C6_VALOR) C6_VALOR
		FROM
		  DAI010 DAI INNER JOIN SC5010 SC5 ON
		    DAI.DAI_FILIAL = %xFilial:DAI% AND
		    SC5.C5_FILIAL =  %xFilial:SC5% AND
		    DAI.DAI_PEDIDO = SC5.C5_NUM AND
		    DAI.%NotDel% AND
		    SC5.%NotDel% INNER JOIN SC6010 SC6 ON
		      SC6.C6_FILIAL =  %xFilial:SC6% AND
		      SC6.C6_NUM = SC5.C5_NUM AND
		      SC6.%NotDel% INNER JOIN SA4010 SA4 ON 
		        SA4.A4_FILIAL =  %xFilial:SA4% AND
		        SA4.A4_COD = SC5.C5_TRANSP AND
		        SA4.%NotDel% LEFT OUTER JOIN SC9010 SC9 ON
		          SC9.C9_FILIAL =  %xFilial:SC9% AND
		          SC9.C9_PEDIDO = SC6.C6_NUM AND
		          SC9.C9_ITEM = SC6.C6_ITEM AND
		          SC9.%NotDel% LEFT OUTER JOIN PAG010 PAG ON
		            PAG.PAG_FILIAL =  %xFilial:PAG% AND
		            PAG.PAG_CODPED = SC5.C5_NUM AND
		            PAG.PAG_CODTRA = SC5.C5_TRANSP  AND
		            PAG.%NotDel%
		WHERE
		  SC5.C5_NUM BETWEEN %Exp:cPedDe% AND %Exp:cPedAt% AND
		  SC5.C5_EMISSAO BETWEEN %Exp:DtoS(dEmisDe)% AND %Exp:DtoS(dEmisAt)% AND
		  SA4.A4_COD BETWEEN %Exp:cTranDe% AND %Exp:cTranAt%
		GROUP BY
		  SC5.C5_NUM,
		  SC5.C5_XNPSITE,
		  SC5.C5_TIPO,
		  SC5.C5_TIPMOV,
		  SC5.C5_EMISSAO,
		  SC9.C9_DATALIB,
		  SC5.C5_CLIENTE,
  		  SC5.C5_LOJACLI,
		  SC9.C9_SERIENF,
		  SC9.C9_NFISCAL,
		  SC5.C5_TRANSP,
		  SA4.A4_XCODCOR,
		  SA4.A4_NOME,
		  DAI.DAI_COD,
		  PAG.PAG_CODRAS,
		  PAG.PAG_ENTREG,
		  PAG.PAG_CODPLP,
		  SC6.C6_PRODUTO,
		  SC6.C6_DESCRI
		 
	EndSql
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo( 'Não há dados para ser extraído.', 'Resultado' )
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	oReport:SetMsgPrint('Aguarde, imprimindo...')
	oReport:SetMeter( Len( aCOLS )+1 )	
	oSection:Init()
	
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
				
				If aCpo[nI] $ "C5_TIPO,C5_TIPMOV"
					cDado := RetCombo(aCpo[nI], cDado) 
				Endif
				
				If aCpo[nI] $ "PAG_ENTREG"
					cDado := Posicione("SX5",1,xFilial("SX5")+"PG"+cDado,"X5_DESCRI") 
				Endif
				
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

Static Function RetCombo(cCampo, cChave)

Local aSx3Box	:= RetSx3Box( Posicione("SX3", 2, cCampo, "X3CBox()" ),,, 1 )
Local cRet		:= AllTrim( aSx3Box[aScan( aSx3Box, { |aBox| aBox[2] = cChave } )][3] )
Return(cRet) 