//--------------------------------------------------------------------------
// Rotina | MT160WF    | Autor | Robson Goncalves        | Data | 09/12/2015
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada com os dados da cotação após gerar o pedido de
//        | compras. 
//--------------------------------------------------------------------------
// Objetiv| O objetivo aqui é acionar a geração da capa de despesa no 
//        | formato PDF e enviar o WF de aprovação.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#Include 'Protheus.ch'

STATIC lNewCP610 := IIf( FindFunction( 'U_NewCP610' ) , U_NewCP610() , .F. )

User Function MT160WF()
	Local cNUM_COT := ''
	Local aPedido := {}
	Local aSC8 := {}
	Local cMV_610COT := 'MV_610COT'
	Local nI := 0
	Local cPedidos := ''
	
	If .NOT. GetMv( cMV_610COT, .T. )
		CriarSX6( cMV_610COT, 'N', 'HABILITAR O PROCESSO DA CAPA DE DESPESA NO PROCESSO DE COTACAO GERA PEDIDO DE COMPRAS. 0=DESABILITADO E 1=HABILITADO - ROTINA MT160WF.prw', '0' )
	Endif
	
	If lNewCP610
		If GetMv( cMV_610COT, .F. ) == 1 // Se o processo estiver habilitado.
			aSC8 := SC8->( GetArea() )
			cNUM_COT := ParamIXB[ 1 ] 
			
			SC8->( dbSetOrder( 1 ) )
			SC8->( dbSeek( xFilial( 'SC8' ) + cNUM_COT ) )
			While SC8->( .NOT. EOF() ) .AND. SC8->C8_FILIAL == xFilial( 'SC7' ) .AND. SC8->C8_NUM == cNUM_COT
				If SC8->C8_NUMPED <> 'XXXXXX'
					If AScan( aPedido, {|e| e == SC8->C8_NUMPED } ) == 0 
						AAdd( aPedido, SC8->C8_NUMPED )
					Endif
				Endif
				SC8->( dbSkip() )
			End
			SC8->( RestArea( aSC8 ) )
			
			If Len( aPedido ) > 0
			
				MsAguarde( {||	AEval( aPedido, {|pc| U_A610PDF( pc ), cPedidos += xFilial('SC7') + '-' + pc + CRLF } ) },;
				'Capa de despesa', 'Criar PDF e enviar workfow, aguarde...', .F. )
				
				/*
				Esta rotina atualiza o valor do rateio, porém não há ponto de entrada para usar, porque os registros estão lock no banco.
				AddToTheSCH( aPedido )
				*/
				
				MsgInfo('Operação efetuada com sucesso.'+CRLF+'Gerado pedido de compras (Filial+Pedido) Nº '+cPedidos,'Cotação de compras')
			Endif
		Endif
	Else
		U_CPACER02( SC7->C7_NUM, .F., .T. )
		MsgInfo("Pedido de Compra Nº: " + SC7->C7_NUM)
	Endif
Return( ParamIXB )

//--------------------------------------------------------------------------
// Rotina | AddToTheSCH | Autor | Robson Gonçalves       | Data | 23/05/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para gravar o valor do rateio quando cotação gerar PC e 
//        | este possuir rateio SCX gera SCH.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function AddToTheSCH( aParam )
	Local aArea := { SCH->( GetArea() ), SC7->( GetArea() ) }
	Local aArray := {}
	
	Local nDecimal := 0
	Local nDif := 0 
	Local nI := 0
	Local nJ := 0
	Local nMaior := 0
	Local nValRat := 0
	Local nRecno := 0
	Local nVlrItem := 0
	Local nT_Rateio := 0
	
	nDecimal := GetSx3Cache( 'CH_VLRAT', 'X3_DECIMAL' )
	
	If nDecimal == NIL
		nDecimal := SX3->( Posicione( 'SX3', 2, 'CH_VLRAT', 'X3_DECIMAL' ) )
	Endif
	
	SCH->( dbSetOrder( 1 ) )
	
	SC7->( dbSetOrder( 1 ) )
	
	For nI := 1 To Len( aParam )
		SC7->( dbSeek( xFilial( 'SC7' ) + aParam[ nI ] ) )
		
		nVlrItem := SC7->( C7_TOTAL + C7_VALFRE + C7_SEGURO + C7_VALIPI + C7_DESPESA - C7_VLDESC )
		
		SCH->( dbSeek( SC7->( C7_FILIAL + C7_NUM + C7_FORNECE + C7_LOJA + C7_ITEM ) ) )
		
		SCH->CH_PERC := nMaior
		
		While SCH->( .NOT. EOF() ) .AND. SCH->CH_FILIAL == SC7->C7_FILIAL .AND. SCH->CH_PEDIDO	== SC7->C7_NUM .AND. ;
			SCH->CH_FORNECE == SC7->C7_FORNECE .AND. SCH->CH_LOJA 	== SC7->C7_LOJA .AND. SCH->CH_ITEMPD  	== SC7->C7_ITEM
			
			nValRat := Round( ( nVlrItem * SCH->CH_PERC ) / 100, nDecimal )
			
			nT_Rateio += nValRat
			
			AAdd( aArray, { SCH->( RecNo() ), nVlrItem, SCH->CH_PERC, nValRat } )
			
			If SCH->CH_PERC > nMaior
				nMaior := SCH->CH_PERC
				nRecno := Len( aArray )
			Endif
			
			SCH->( dbSkip() ) 
		End
		
		If nT_Rateio > 0 .AND. nVlrItem <> nT_Rateio
			If nVlrItem > nT_Rateio
				nDif := nVlrItem - nT_Rateio
				aArray[ nRecno, 4 ] += nDif
			Else
				nDif := nT_Rateio - nVlrItem
				aArray[ nRecno, 4 ] -= nDif
			Endif
		Endif
		
		For nJ := 1 To Len( aArray )
			SCH->( dbGoTo( aArray[ nJ, 1 ] ) )
			SCH->( RecLock( 'SCH', .F. ) )
			SCH->CH_VLRAT := aArray[ nJ, 4 ]
			SCH->( MsUnLock() ) 
		Next nJ
		
		nT_Rateio := 0
	Next nI
	
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return