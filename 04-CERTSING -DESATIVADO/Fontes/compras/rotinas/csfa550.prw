//---------------------------------------------------------------------------------
// Rotina    | CSFA550 | Autor | Robson Gon�alves               | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Rotina para replicar produtos entre filiais.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSFA550()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private cCadastro := 'Replicar produtos entre filiais'
	
	AAdd(aSay,'Este programa possibilita ao usu�rio duplicar o produto nas filiais da empresas atual.')
	AAdd(aSay,' ')
	AAdd(aSay,' ')
	AAdd(aSay,' ')
	AAdd(aSay,'Clique em OK para continuar...')
	
	aAdd(aButton, { 1,.T.,{|| nOpcao := 1, FechaBatch() }})
	aAdd(aButton, { 2,.T.,{|| FechaBatch()              }})
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
	   A550Browse()
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina    | A550Browse | Autor | Robson Gon�alves            | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Disponibiliza o browse para o usu�rio selecionar os produtos.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A550Browse()
	Local nI := 0
	Local aCpos := {}
	Local aCampos := {}
	Local aIndex := {}
	Local a550Filial := {}
	Local lInvert := .F.
	
	Private aRotina := {}
	Private bFiltraBrw := {|| }
	Private cMark := ''
	Private lUndo := .F.
	
	A550GetFil( @a550Filial )
	
	If Len( a550Filial ) > 0
		AAdd( aRotina ,{"Pesquisar" ,"U_A550Pesq()",0,1})
		AAdd( aRotina ,{"Processar" ,"U_A550Proc()",0,4})

		//+----------------------------------------------------
		//| Somente dever�o aparecer estes campos na MarkBrowse
		//+----------------------------------------------------
		aCpos := {"B1_OK","B1_COD","B1_DESC"}

		SX3->(dbSetOrder(2))
		For nI := 1 To Len(aCpos)
			SX3->(dbSeek(aCpos[nI]))
			aAdd(aCampos,{	RTrim(SX3->X3_CAMPO),"",Iif(nI==1," ",X3Titulo()),RTrim(SX3->X3_PICTURE)})
		Next

		cFiltro := "B1_FILIAL >= '"+xFilial("SB1")+"' .And. "
		cFiltro += "B1_FILIAL <= '"+xFilial("SB1")+"' "

		cQuery := "B1_FILIAL >= '"+xFilial("SB1")+"' AND "
		cQuery += "B1_FILIAL <= '"+xFilial("SB1")+"' "

		bFiltraBrw := {|x| Iif(x==NIL,FilBrowse("SB1",@aIndex,@cFiltro),{cFiltro,cQuery,"","",aIndex}) }
		Eval(bFiltraBrw)
		SB1->(MsSeek(xFilial()))

		cMark := GetMark(,"SB1","B1_OK")
		MarkBrow("SB1","B1_OK",,aCampos,lInvert,cMark,'U_A550AllMrk()',,,,'U_A550Mark()')

		dbSelectArea("SB1")
		RetIndex("SB1")
		dbClearFilter()
		AEval(aIndex,{|x| FErase(x[1]+OrdBagExt())})
	Else
		MsgInfo('N�o h� filiais para replicar registros do cadastro de produtos.',cCadastro)
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina    | A550Mrk    | Autor | Robson Gon�alves            | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Rotina para marcar/desmarcar registro.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A550Mark()
	Local lMark := .F.
	If SimpleLock('SB1',.F.)
		lMark := SB1->B1_OK == cMark			
		SB1->( RecLock( 'SB1', .F. ) )
		SB1->B1_OK := Iif( lMark, ' ', cMark )
		SB1->( MsUnLock() )
	Else
		If .NOT. Empty( SB1->B1_OK )
			Alert('Registro j� foi marcado.')
		Else
			Alert('Registro est� sendo usado por outro usu�rio.')
		Endif
	Endif
	SB1->( dbCommit() )
Return .T.

//---------------------------------------------------------------------------------
// Rotina    | A550AllMrk | Autor | Robson Gon�alves            | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Rotina para marcar/desmarcar todos os registros.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A550AllMrk()
	lUndo := .NOT. lUndo
	Processa( {|| AllMrkProc()},cCadastro,'Aguarde, '+Iif(lUndo,'marcando','desmarcando')+' registros...', .F. )
Return

//---------------------------------------------------------------------------------
// Rotina    | AllMrkProc | Autor | Robson Gon�alves            | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Rotina auxiliar para marcar/desmarcar todos os registros.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function AllMrkProc()
	Local lMark := .F.
	Local aArea := GetArea()
	SB1->( dbSetOrder( 1 ) )
	SB1->( dbSeek( xFilial( 'SB1' ) ) )
	ProcRegua(0)
	While SB1->( .NOT. EOF() ) .AND. SB1->B1_FILIAL == xFilial( 'SB1' )
		IncProc()
		lMark := SB1->B1_OK == cMark
		SB1->( RecLock( 'SB1', .F. ) )
		SB1->B1_OK := Iif( lMark, ' ', cMark )
		SB1->( MsUnLock() )
		SB1->( dbSkip() )
	End
	SB1->( dbCommit() )
	RestArea( aArea )
Return

//---------------------------------------------------------------------------------
// Rotina    | A550Pesq| Autor | Robson Gon�alves               | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Rotina de pesquisa para ajustar o filtro.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A550Pesq()
	AxPesqui()
   Eval(bFiltraBrw)
Return

//---------------------------------------------------------------------------------
// Rotina    | A550Proc| Autor | Robson Gon�alves               | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Rotina de prepara��o para o processamento.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A550Proc()
	Local aArea := {}
	Local aSelFil := {}
	aArea := SB1->( GetArea() )
	// AdmGetFil() - Fun��o que permite usu�rio selecionar quais filiais quer processar para r�plica.
	//[1] - Todas as filiais.
	//[2] - Somente filiais da empresa corrente.
	//[3] - Caso o Alias n�o seja passado, traz as filiais que o usuario tem acesso (modo padrao)
	//[4] - N�o informar o Alias traz as filiais que o usu�rio tem acesso.
	//[5] - Somente filiais da unidade de negocio corrente.
	aSelFil := AdmGetFil(.F.,.T.,.F.,'SB1',.T.)
	If Len( aSelFil ) > 0
		Begin Transaction 
		Processa( {|lEnd| A550RunProc( aSelFil ) },,'Processando a r�plica...', .F. )
		End Transaction
	Else
		MsgInfo('Opera��o de replicar o produto para outras filiais foi cancelado pelo usu�rio.','Replicar produtos entre filiais')
	Endif
	SB1->( RestArea( aArea ) )
Return

//---------------------------------------------------------------------------------
// Rotina    | A550RunProc | Autor | Robson Gon�alves           | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Rotina de processamento da r�plica e grava��o dos dados.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A550RunProc( aSelFil )
	Local nB1_COD := 0
	Local nB1_FILIAL := 0
	Local nElem := 0
	Local nFCount := 0
	Local nI := 0
	Local nJ := 0
	Local nK := 0
	Local nP := 0
	Local nSeek := 0
	
	Local cNameTable := RetSqlName('SB1')
	Local cSQL := ''
	Local cTRB := GetNextAlias()

	Local aCPOS := {}
	Local aDADOS := {}
	Local aLog := {}
	
	// Montar a query para pegar todos os registros selecionados.
	cSQL := "SELECT * "
	cSQL += "FROM   "+cNameTable+" "
	cSQL += "WHERE  B1_FILIAL = "+ValToSql(xFilial("SB1"))+" "
	cSQL += "       AND B1_OK = "+ValToSql(cMark)+" "
	cSQL += "       AND D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY B1_FILIAL, B1_COD "
	
	// Processar a query.
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde...')
	ProcRegua(0)
	
	nFCount := (cTRB)->( FCount() )

	// Ler todos os registros e armazenar em um vetor.
	While (.NOT. (cTRB)->( EOF() ) )
		IncProc()
		AAdd( aDADOS, Array( nFCount ) )
		nElem := Len( aDADOS )
		For nI := 1 To nFCount
			IncProc()
			aDADOS[ nElem, nI ] := (cTRB)->( FieldGet( nI ) )
		Next nI
		(cTRB)->( dbSkip() )
	End
	
	// Criar um vetor com os nomes de todos os campos da tabela de produtos.
	For nI := 1 To nFCount
		IncProc()
		AAdd( aCPOS, (cTRB)->( FieldName( nI ) ) )
	Next nI
	
	// Fechar a query.
	(cTRB)->( dbCloseArea() )
	
	// Excluir a filial corrente.
	nP := AScan( aSelFil, xFilial('SB1') )
	If nP > 0
		ADel( aSelFil, nP )
		ASize( aSelFil, Len( aSelFil )-1 )
	Endif
	
	// Pegar a posi��o dos campos chaves da tabela.
	nB1_FILIAL := SB1->( FieldPos( 'B1_FILIAL' ) )
	nB1_COD    := SB1->( FieldPos( 'B1_COD' ) )
	
	// Para as filiais selecionadas processar.
	For nI := 1 To Len( aSelFil )
		IncProc()
		
		// Processar todos os produtos selecionados.
		For nJ := 1 To Len( aDADOS )
			IncProc()
			
			// Montar a query para saber se o produto existe.
			cSQL := "SELECT COUNT(*) nCOUNT "
			cSQL += "FROM "+cNameTable+" "
			cSQL += "WHERE D_E_L_E_T_ = ' ' "
			cSQL += "AND B1_FILIAL = "+ValToSql( aSelFil[ nI ] )+" "
			cSQL += "AND B1_COD = "+ValToSql( aDADOS[ nJ, nB1_COD ] )+" "
			
			// Processar a query, capturar o retorno e fechar.
			dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cSQL),"TEM_B1",.F.,.T.)
			nSeek := TEM_B1->( nCOUNT )
			TEM_B1->( dbCloseArea() )
			
			// Se n�o existir a chave processada na query, gravar os dados.
			If nSeek == 0
				SB1->( RecLock( 'SB1', .T. ) )
					For nK := 1 To Len( aCPOS )
						IncProc()
						If .NOT. ( aCPOS[ nK ] $ 'R_E_C_N_O_|R_E_C_D_E_L_' )
							If aCPOS[ nK ] == 'B1_FILIAL'
								SB1->B1_FILIAL := aSelFil[ nI ]
							Else
								SB1->&( aCPOS[ nK ] ) := aDADOS[ nJ, nK ] 
							Endif
						Endif
					Next nK
				SB1->( MsUnLock() )
			Else
				AAdd( aLog, { aDADOS[ nJ, nB1_COD ], aSelFil[ nI ] } )
			Endif
		Next nJ
	Next nI
	If Len( aLog ) > 0
		A550ToExcel( aLog )
	Endif
	CloseBrowse()
	Sleep(3000)
	MsgInfo('Opera��o de r�plica de produtos finalizada.',cCadastro)
Return

//---------------------------------------------------------------------------------
// Rotina    | A550Filiais | Autor | Robson Gon�alves           | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Rotina para verificar se h� mais de uma filial e perguntar qual  
//           | filial deve-se replicado.
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A550Filiais()
	Local aFilial := {}
	A550GetFil( @aFilial )
	If Len( aFilial ) > 0
		A550Perg()
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina    | A550GetFil | Autor | Robson Gon�alves            | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Rotina para verificar se h� mais de uma filial para validar o
//           | andamento da opera��o.
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A550GetFil( aFilial )
	Local aArea := {}
	aFilial := {}
	aArea := SM0->( GetArea() )
	SM0->( dbSeek( cEmpAnt ) )
	While (.NOT. EOF() ) .AND. SM0->M0_CODIGO == cEmpAnt
		SM0->( AAdd( aFilial, M0_CODFIL ) )
		SM0->( dbSkip() )
	End	
	SM0->( RestArea( aArea ) )
Return

//---------------------------------------------------------------------------------
// Rotina    | A550Perg | Autor | Robson Gon�alves              | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Perguntar para o usu�rio com um tempo determinado de espera.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A550Perg()
	If MsgYesNoTimer('Existe a possibilidade de gravar o produto nas demais filiais, quer fazer isto agora?','Replicar produtos entre filiais',15000,2)
		A550ShowFil()
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina    | A550ShowFil | Autor | Robson Gon�alves           | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Apresenta as filiais para o usu�rio selecionar para onde replicar.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A550ShowFil()
	Local aSelFil := {}
	// AdmGetFil() - Fun��o que permite usu�rio selecionar quais filiais quer processar para r�plica.
	//[1] - Todas as filiais.
	//[2] - Somente filiais da empresa corrente.
	//[3] - Caso o Alias n�o seja passado, traz as filiais que o usuario tem acesso (modo padrao)
	//[4] - N�o informar o Alias traz as filiais que o usu�rio tem acesso.
	//[5] - Somente filiais da unidade de negocio corrente.
	aSelFil := AdmGetFil(.F.,.T.,.F.,'SB1',.T.)
	If Len( aSelFil ) > 0
		A550Grv( aSelFil )
	Else
		MsgInfo('Opera��o de replicar o produto para outras filiais foi cancelado pelo usu�rio.','Replicar produtos entre filiais')
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina    | A550Grv | Autor | Robson Gon�alves               | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Grava��o da r�plica.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A550Grv( aSelFil )
	Local nI := 0
	Local nJ := 0
	Local nC := 0
	Local aSB1 := {}
	Local cB1_COD := SB1->B1_COD
	Local aLog := {}
	
	For nI := 1 To SB1->( FCount() )
		SB1->( AAdd( aSB1, { FieldName( nI ), FieldGet( nI ) } ) )
	Next nI
	
	Begin Transaction
		For nI := 1 To Len( aSelFil )
			If aSelFil[ nI ] <> cFilAnt
				If .NOT. SB1->( dbSeek( aSelFil[ nI ] + cB1_COD ) )
					SB1->( RecLock( 'SB1', .T. ) )
					For nJ := 1 To Len( aSB1 )
						If aSB1[ nJ, 1 ] == 'B1_FILIAL'
							SB1->B1_FILIAL := aSelFil[ nI ]
						Else
							nC := SB1->( FieldPos( aSB1[ nJ, 1 ] ) )
							SB1->( FieldPut( nC, aSB1[ nJ, 2 ] ) )					
						Endif
					Next nJ
					SB1->( MsUnLock() )
				Else
					AAdd( aLog, { cB1_COD, aSelFil[ nI ] } )
				Endif
			Endif
		Next nI
	End Transaction
	If Len( aLog ) > 0
		A550ToExcel( aLog )
	Endif	
Return

//---------------------------------------------------------------------------------
// Rotina    | A550ToExcel | Autor | Robson Gon�alves           | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Gerar planilha excel com os dados de LOG.
//           | 
//           | 
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A550ToExcel( aLog )
	FWMsgRun( , {|| DlgToExcel({{'ARRAY','LOG DE INCONSIST�NCIA',{'C�digo do produto','Filial onde j� existe o produto'},aLog}}) }, ,'Exportando Log de ocorr�ncia...' )
Return