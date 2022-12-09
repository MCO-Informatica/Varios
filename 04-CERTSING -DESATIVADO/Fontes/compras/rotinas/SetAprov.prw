User Function SetAprov()
	Local aButton := {}
	Local aSay := {}

	Local nOpcao := 0
	
	Private cCadastro := 'Criar Perfil de Aprovadores PC'

	AAdd( aSay, 'Esta rotina tem por objetivo criar os registros na tabela de perfil' )
	AAdd( aSay, 'de aprovadores DHL com base na tabela de aprovadores SAK.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao==1
		Processa( {|| SetAprProc()}, cCadastro,'Operação em processamento...', .F. )
	Endif
Return

Static Function SetAprProc()
	Local cCount := 0
	Local cDHL_FILIAL := xFilial( "DHL" )
	Local cDHL_COD := ''
	Local cDHL_DESCRI := ''
	Local cSQL := ''
	Local cTRA := 'WRK1'
	Local cTRB := 'WRK2'
	Local cTRC := 'WRK3'
	Local nCount := 0
	Local nPerfil := 0
	
	cSQL := "SELECT AK_FILIAL, "
    cSQL += "       AK_LIMITE, "
    cSQL += "       AK_LIMMIN, "
    cSQL += "       AK_LIMMAX, "
    cSQL += "       AK_MOEDA, "
    cSQL += "       AK_TIPO, "
    cSQL += "       COUNT(*) AS QTDE "
	cSQL += "FROM   "+RetSqlName("SAK")+" SAK "
	cSQL += "WHERE  SAK.D_E_L_E_T_ = ' ' "
	cSQL += "GROUP  BY AK_FILIAL, "
    cSQL += "       AK_LIMITE, "
    cSQL += "       AK_LIMMIN, "
    cSQL += "       AK_LIMMAX, "
    cSQL += "       AK_MOEDA, "
    cSQL += "       AK_TIPO "
	cSQL += "ORDER  BY QTDE "
	
	cCount := " SELECT COUNT(*) COUNT FROM ( " + cSQL + " ) QUERY "
	
	If At('ORDER  BY', Upper(cCount)) > 0
		cCount := SubStr( cCount, 1, At( 'ORDER  BY', cCount )-1 ) + SubStr( cCount, RAt( ')', cCount ) )
	Endif
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cCount),'SQLCOUNT',.F.,.T.)
	nCount := SQLCOUNT->COUNT
	SQLCOUNT->(DbCloseArea())
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRA, .F., .T. )
	
	ProcRegua( nCount )
	
	While (cTRA)->( .NOT. EOF() )
		IncProc()
		
		cDHL_COD := GetSXENum('DHL','DHL_COD')
		ConfirmSX8()
		
		cDHL_DESCRI := 'PERFIL ' + StrZero( ++nPerfil, 3, 0 )
		
		DHL->( dbSetOrder( 1 ) )
		DHL->( RecLock( 'DHL', .T. ) )
		DHL->DHL_FILIAL := cDHL_FILIAL
		DHL->DHL_COD    := cDHL_COD
		DHL->DHL_DESCRI := cDHL_DESCRI
		DHL->DHL_LIMMIN := (cTRA)->AK_LIMMIN
		DHL->DHL_LIMMAX := (cTRA)->AK_LIMMAX
		DHL->DHL_LIMITE := (cTRA)->AK_LIMITE
		DHL->DHL_TIPO   := (cTRA)->AK_TIPO
		DHL->DHL_MOEDA  := (cTRA)->AK_MOEDA
		DHL->( MsUnLock() )
		
		cSQL := "SELECT AK_COD "
		cSQL += "FROM   "+RetSqlName("SAK")+" AK "
		cSQL += "WHERE  AK_FILIAL = " + ValToSql( (cTRA)->AK_FILIAL ) + " "
		cSQL += "       AND AK_LIMITE = " + LTrim( Str( (cTRA)->AK_LIMITE ) ) + " "
		cSQL += "       AND AK_LIMMIN = " + LTrim( Str( (cTRA)->AK_LIMMIN ) ) + " "
		cSQL += "       AND AK_LIMMAX = " + LTrim( Str( (cTRA)->AK_LIMMAX ) ) + " "
		cSQL += "       AND AK_MOEDA = " + ValToSql( (cTRA)->AK_MOEDA ) + " "
		cSQL += "       AND AK_TIPO = " + ValToSql( (cTRA)->AK_TIPO ) + " "
		cSQL += "       AND D_E_L_E_T_ = ' ' "
		
		cSQL := ChangeQuery( cSQL )
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
		While (cTRB)->( .NOT. EOF() )
			
			cTRC := "UPDATE "+RetSqlName( "SAL" ) + " "
			cTRC += "       SET AL_PERFIL = " + ValToSql( cDHL_COD ) + " "
			cTRC += "WHERE AL_FILIAL = " + ValToSql( xFilial( "SAL" ) ) + " "
			cTRC += "      AND AL_APROV = " + ValToSql( (cTRB)->AK_COD ) + " "
			cTRC += "	   AND D_E_L_E_T_ = ' ' "
			
			TCSqlExec( cTRC )
			
			(cTRB)->( dbSkip() )
		End
		(cTRB)->( dbCloseArea() )
	
		(cTRA)->( dbSkip() )
	End
	(cTRA)->( dbCloseArea() )
	
	dbSelectArea( "SAL" )
	dbSetOrder( 1 )
	While SAL->( .NOT. EOF() )
		SAL->( RecLock( "SAL", .F. ) )
		SAL->AL_DOCPC := .T.
		SAL->( MsUnLock() )
		SAL->( dbSkip() )
	End
Return
