//----------------------------------------------------------------------
// Rotina | CN120VENC  | Autor | Robson Goncalves    | Data | 05.05.2015
//----------------------------------------------------------------------
// Descr. | Ponto de entrada para validar o encerramento da medicao. 
//        | O retorno esperado é lógico.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function CN120VENC()
	Local aArea := {}
	Local lRetorno := .T.
	
	aArea := { GetArea(), CN1->( GetArea() ), CN9->( GetArea() ), CNA->( GetArea() ), CND->( GetArea() ), AD1->( GetArea() ) }
	
	CN9->( dbSetOrder( 1 ) )
	CN9->( MsSeek( xFilial( 'CN9' ) + CND->CND_CONTRA + CND->CND_REVISA ) )
	
	CNA->( dbSetOrder( 1 ) )
	CNA->( MsSeek( xFilial( 'CNA' ) + CND->CND_CONTRA + CND->CND_REVISA + CND->CND_NUMERO ) )

	CN1->( dbSetOrder( 1 ) )
	CN1->( MsSeek( xFilial( 'CN1' ) + CN9->CN9_TPCTO ) )
	
	// Compras.
	If CN1->CN1_ESPCTR == '1'
		If FunName() <> 'CRPA031' .And. FunName() <> "CRPA079"
			lRetorno := U_CSFA610( 'COM', 'CNTA120', '' )
		Endif
	// Vendas.
	Elseif CN1->CN1_ESPCTR == '2' 
		lRetorno := U_CSFA610( 'VEN', '', '' )
	Endif
	
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return( lRetorno )
