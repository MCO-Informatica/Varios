//-----------------------------------------------------------------------
// Rotina | CN120PDM   | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada é executado após gerar a rotina automática do 
//        | Pedido de Vendas ou Pedido de Compras.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CN120PDM()
	Local aArea  := GetArea()
	Local aAreas := {}
	Local lRet   := ParamIXB[ 1 ]
	
	// Gerou pedido de compras/vendas
	If lRet
		aAreas := { CN1->( GetArea() ), CN9->( GetArea() ), CNA->( GetArea() ), CND->( GetArea() ), CNL->( GetArea() ) }
		
		// Contrato.
		CN9->( dbSetOrder( 1 ) )
		CN9->( MsSeek( xFilial( 'CN9' ) + CND->CND_CONTRA + CND->CND_REVISA ) )
		
		// Cabeçalho da planilha.
		CNA->( dbSetOrder( 1 ) )
		CNA->( MsSeek( xFilial( 'CNA' ) + CND->CND_CONTRA + CND->CND_REVISA + CND->CND_NUMERO ) )
		
		// Tipo de planilha.
		CNL->( dbSetOrder( 1 ) )
		CNL->( MsSeek( xFilial( 'CNL' ) + CNA->CNA_TIPPLA ) )

		// Tipos de contratos.
		CN1->( dbSetOrder( 1 ) )
		CN1->( MsSeek( xFilial( 'CN1' ) + CN9->CN9_TPCTO ) )
		
		// Compras.
		If CN1->CN1_ESPCTR == '1'
			U_A610Grav( 'COM' )
		// Vendas.
		Elseif CN1->CN1_ESPCTR == '2'
			// Diferente de 2=Não, ou seja, 1 e vazio = sim.
			If CNL->CNL_XGRPD <> '2' 
				U_A610Grav( 'VEN' )
			Endif
		Endif
		
		AEval( aAreas, {|xArea| RestArea( xArea ) } )
	Endif
	RestArea( aArea )
Return( lRet )