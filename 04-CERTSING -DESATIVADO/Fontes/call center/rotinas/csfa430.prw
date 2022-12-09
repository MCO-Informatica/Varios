//-----------------------------------------------------------------------
// Rotina | A430IPad   | Autor | Robson Gonçalves     | Data | 26.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina que aciona a funcção para fazer o aTrocaF3 caso seja
//        | necessário
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A430IPad()
	Local cRet := ''
	// Somente se for inclusão.
	If INCLUI
		// Somente para os seguintes perfis: Televendas, Todos, TMK x TLV
		If ( TkGetTipoAte() $ '245' )
			// Verificar se o campo existe.
			If SUA->( FieldPos( 'UA_XVCOMP' ) ) > 0
				// 0=Não; 1=Sim.
				cRet := '0' 
				// Verificar se a memvar existe.
				If ValType( M->UA_TABELA ) == 'C'
					U_A430TrF3()
				Endif
         Endif
		Endif
	Endif
Return( cRet )

//-----------------------------------------------------------------------
// Rotina | A430TrF3   | Autor | Robson Gonçalves     | Data | 26.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para verificar e fazer a atribuição do aTrocaF3.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A430TrF3()
	Local cXB_ALIAS := '430DA1'
	Local cMV_430TABP := 'MV_430TABP'
	//Verificar se precisa criar os dicionários auxiliares.
	A430PodeUsar( cXB_ALIAS, cMV_430TABP )
	// Se o que acionou a função for o campo UA_TABELA
	If ( ReadVar()=='M->UA_TABELA' .AND. Empty( M->UA_TABELA ) )
		M->UA_TABELA := Space( Len( SUA->UA_TABELA ) )
	Else
		cMV_430TABP := GetMv( cMV_430TABP, .F. )
		// Se o parâmetro estiver vario atribuir espaço em brando na memvar, 
		// do contrário atribui o código da tabela de preço.
		If Empty( cMV_430TABP )
			M->UA_TABELA := Space( Len( SUA->UA_TABELA ) )
		Else
			// O que foi digitado não está contido no parâmetro?
			If .NOT. M->UA_TABELA $ cMV_430TABP
				MsgAlert('O código da tabela de preço informado não está vigente para este uso.',cCadastro)
				M->UA_TABELA := Space( Len( SUA->UA_TABELA ) )
			Endif
		Endif
	Endif
	// Se vazio atribuir o padrão na variável aTrocaF3.
	// do contrário atribuir a consulta SXB específica para conulstar a tabela de preço.
	If Empty( M->UA_TABELA )
		A430ChF3( 'UB_PRODUTO', Posicione( 'SX3', 2, 'UB_PRODUTO', 'X3_F3' ) )
	Else
		A430ChF3( 'UB_PRODUTO', cXB_ALIAS )
	Endif
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A430ChF3   | Autor | Robson Gonçalves     | Data | 26.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar que contempla a funcionalidade da rotina 
//        | A430TrF3, seu objetivo é atribuir a variável aTrocaF3 o alias 
//        | da tabela conforme tabela de preço informada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A430ChF3( cFieldF3, cAliasF3 )
	Local nP := 0
	//-------------------------------------------------------
	// Declara variável caso a aTrocaF3 não esteja declarada.
	//-------------------------------------------------------
	If Type( 'aTrocaF3' ) <> 'A'
		_SetNamedPrvt( 'aTrocaF3', {}, '__EXECUTE' )
	Endif
	//-------------------------------------------------
	// Localiza na aTrocaF3 se o campo já possui troca.
	//-------------------------------------------------
	nP := AScan( aTrocaF3, {|p| p[ 1 ] == cFieldF3 } )
	//----------------------------------------
	// Caso não esteja da array, cria posição.
	//----------------------------------------
	If nP == 0
		AAdd( aTrocaF3, { , } )
		nP := Len( aTrocaF3 )
		aTrocaF3[ nP, 1 ] := cFieldF3
	Endif
	//------------------------
	// Modifica o F3 do campo.
	//------------------------
	aTrocaF3[ nP, 2 ] := cAliasF3
Return

//-----------------------------------------------------------------------
// Rotina | A430UpdA   | Autor | Robson Gonçalves     | Data | 26.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina de update de dicionário de dados auxiliares.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A430UpdA()
	Local cXB_ALIAS := '430DA1'
	Local cMV_430TABP := 'MV_430TABP'
	//Verificar se precisa criar os dicionários auxiliares.
	A430PodeUsar( cXB_ALIAS, cMV_430TABP )
Return

//-----------------------------------------------------------------------
// Rotina | A430PodeUsar | Autor | Robson Gonçalves   | Data | 26.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para criar os dicionários de dados auxiliares.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A430PodeUsar( cXB_ALIAS, cMV_430TABP )
	Local aSXB := {}
	Local aCpoXB := {}
	Local nI := 0
	Local nJ := 0
	Local cX3_RELACAO := ''
	Local cX3_VLDUSER := ''
	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}
	AAdd( aSXB, { cXB_ALIAS, '1', '01', 'DB', 'Tabela de preco'     , 'Tabla del precio'   , 'Table price'       , 'DA1'       , '' } )
	AAdd( aSXB, { cXB_ALIAS, '2', '01', '01', 'Tabela + Produto'    , 'Tabela + Produto'   , 'Tabela + Produto'  , ''          , '' } )
	AAdd( aSXB, { cXB_ALIAS, '2', '02', '07', 'Tabela + Descricao'  , 'Tabela + Descricao' , 'Tabela + Descricao', ''          , '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '01', '01', 'Tabela'              , 'Tabela'             , 'Tabela'            , 'DA1_CODTAB', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '01', '02', 'Produto'             , 'Produto'            , 'Produto'           , 'DA1_CODPRO', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '01', '03', 'Descricao'           , 'Descricao'          , 'Descricao '        , 'DA1_DESCRI', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '01', '04', 'Preco Venda'         , 'Preco Venta'        , 'Preco Venda'       , 'TransForm(DA1->DA1_PRCVEN,"@E 99,999,999.99")', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '02', '01', 'Tabela'              , 'Tabela'             , 'Tabela'            , 'DA1_CODTAB', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '02', '02', 'Descricao'           , 'Descricao'          , 'Descricao'         , 'DA1_DESCRI', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '02', '03', 'Produto'             , 'Produto'            , 'Produto'           , 'DA1_CODPRO', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '02', '04', 'Preco Venda'         , 'Preco Venda'        , 'Preco Venda'       , 'TransForm(DA1->DA1_PRCVEN,"@E 99,999,999.99")', '' } )
	AAdd( aSXB, { cXB_ALIAS, '5', '01', ''  , ''                    , ''                    , ''                 , 'DA1->DA1_CODPRO'          , '' } )
	AAdd( aSXB, { cXB_ALIAS, '6', '01', ''  , ''                    , ''                    , ''                 , 'DA1->DA1_CODTAB==M->UA_TABELA.AND.DA1->DA1_ATIVO=="1"', '' } )
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
	If .NOT. GetMv( cMV_430TABP, .T. )
		CriarSX6( cMV_430TABP, 'C', 'PARAMETRO COM O CODIGO DA TABELA DE PRECO UTILIZADO NO TELEVENDAS - CSFA430.prw','038')
	Endif
	SX3->( dbSetOrder( 2 ) )
	If SX3->( dbSeek( 'UA_XVCOMP' ) )
		If .NOT. ( 'A430IPAD' $ Upper( RTrim( SX3->X3_RELACAO ) ) )
			cX3_RELACAO := RTrim( SX3->X3_RELACAO )
			If .NOT. Empty( cX3_RELACAO )
				cX3_RELACAO := cX3_RELACAO + '.And.'
			Endif
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_RELACAO := cX3_RELACAO + 'U_A430IPad()'
			SX3->( MsUnLock() )
		Endif
	Endif
	If SX3->( dbSeek( 'UA_TABELA' ) )
		If .NOT. ( 'A430TRF3' $ Upper( RTrim( SX3->X3_VLDUSER ) ) )
			cX3_VLDUSER := RTrim( SX3->X3_VLDUSER )
			If .NOT. Empty( cX3_VLDUSER )
				cX3_VLDUSER := cX3_VLDUSER + '.And.'
			Endif
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_VLDUSER := cX3_VLDUSER + 'U_A430TrF3()'
			SX3->( MsUnLock() )
		Endif
	Endif	
Return