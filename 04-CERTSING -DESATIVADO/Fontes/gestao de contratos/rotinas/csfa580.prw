//---------------------------------------------------------------------------------
// Rotina | CSFA580    | Autor | Robson Gonçalves               | Data | 13.04.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para efetuar a troca do Alias da consulta padrão quando houver
//        | registro na tabela de Produto X Fornecedor.
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSFA580()
	Local nP := 0
	Local aArea := {}
	If .NOT. Empty( M->CND_FORNEC )
		aArea := { GetArea(), CNE->( GetArea() ), CND->( GetArea() ), SA5->( GetArea() ), SXB->( GetArea() ) }
		A580SXB()
		SA5->( dbSetOrder( 1 ) )
		If SA5->( dbSeek( xFilial( 'SA5' ) + M->CND_FORNEC ) )
			If Type( 'aHeader' ) == 'A'
				aHeader[ 2, 9 ] := '580SA5'
			Endif
			If Type( 'oGetDados:aHeader' ) == 'A'
				oGetDados:aHeader[ 2, 9 ] := '580SA5'
			Endif
		Endif
		AEval( aArea, {|xArea| RestArea( xArea ) } )
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A580SXB    | Autor | Robson Gonçalves               | Data | 13.04.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para verificar se a configuração para consulta padrão existe.
//        | 
//---------------------------------------------------------------------------------
//        | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A580SXB()
	Local cXB_ALIAS := '580SA5'
	Local aSXB := {}
	Local aCpoXB := {}
	Local nI := 0
	Local nJ := 0
	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}
	AAdd( aSXB, { cXB_ALIAS, '1', '01', 'DB', 'Produto X Fornecedor', 'Produto X Fornecedor', 'Produto X Fornecedor', 'SA5'                           , '' } )
	AAdd( aSXB, { cXB_ALIAS, '2', '01', '01', 'Codigo Produto'      , 'Codigo Produto'      , 'Codigo Produto'      , ''                              , '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '01', '01', 'Produto'             , 'Produto'             , 'Produto'             , 'A5_PRODUTO'                    , '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '01', '02', 'Descricao'           , 'Descricao'           , 'Descricao'           , 'A5_NOMPROD'                    , '' } )
	AAdd( aSXB, { cXB_ALIAS, '5', '01', ''  , ''                    , ''                    , ''                    , 'SA5->A5_PRODUTO'               , '' } )
	AAdd( aSXB, { cXB_ALIAS, '6', '01', ''  , ''                    , ''                    , ''                    , 'SA5->A5_FORNECE==M->CND_FORNEC', '' } )
	SXB->( dbSetOrder( 1 ) )
	For nI := 1 To Len( aSXB )
		If .NOT. SXB->( dbSeek( aSXB[ nI, 1 ] + aSXB[ nI, 2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) ) 
			SXB->( RecLock( 'SXB', .T. ) )
			For nJ := 1 To Len( aSXB[ nI ] )
				SXB->( FieldPut( FieldPos( aCpoXB[ nJ ] ), aSXB[ nI, nJ ] ) )
			Next nJ
			SXB->( MsUnLock() )
		Endif
	Next nI
Return