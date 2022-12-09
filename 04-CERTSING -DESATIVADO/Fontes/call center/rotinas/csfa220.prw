#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

//-----------------------------------------------------------------------
// Rotina | CSFA220    | Autor | Robson Gonçalves     | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Gerar oportunidade por meio de atendimentos [TLV|TMK|AGENDA].
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------

/*****
 *
 * ------------------------------
 * Premissa para o processamento.
 * ------------------------------
 * Se for cliente é só gerar a oportunidade.
 * Se for prospects é só gerar a oportunidade.
 * Se for suspects (ACH), SSL (SZT), ICP (SZX) ou Lista (PAB) gerar prospects, criar nova relação AC8 e gerar oportunidade
 * ----------------------------------------
 * Passo lógicos para gerar a oportunidade.
 * ----------------------------------------
 *	Rodar update.
 *	Pode usar a rotina?
 *	É televendas?
 *		Gerar oportunidade.
 *	Não.
 *		É cliente?
 *			Gerar oportunidade.
 *		Não.
 *			Transformar em prospects.
 *			Gerar oportunidade.
 * -------------------------------------------
 *	Rotinas externas envolvidas neste processo.
 * -------------------------------------------
 *	TMKA271 - Televendas.
 *	CSFA030 - Telemarketing.
 *	CSFA110 - Agenda Certisign.
 *
 ***/
User Function CSFA220( cOrigem, cTreatment, cLista )
	Local nOpc := 0
	
	Local aSay := {}
	Local aButton := {}
	
	Private cCadastro := 'Gerar Oportunidade'
	
	AAdd( aSay, 'Esta rotina tem por objetivo gerar oportunidade por meio de um atendimento.' )
	AAdd( aSay, 'A seguir parâmetros serão solicitados. ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		MsAguarde( {|| A220Proc( cOrigem, cTreatment, cLista ) }, cCadastro, 'Operação em andamento...', .F. )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A220Proc   | Autor | Robson Gonçalves     | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Rotina pode ser usada? Processar a origem da chamada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A220Proc( cOrigem, cTreatment, cLista )
	Private c220FunName := cOrigem
	
	Private n220RecNo := 0
	
	Private cAD1_VEND := ''
	Private cAD1_DESCRI := ''
	Private cAD1_MEMO := ''
	Private cAD1_PRIOR := ''
	Private cAD1_FEELING := ''
	Private cAD1_PREVFE := ''
	Private cAD1_CODPRO := ''
	Private dAD1_DTPFIM := Ctod('')
	
	//-----------------------------------------------------------------------------
	// Verificar se a rotina pode ser utilizada, pois há dependência de estruturas.
	//-----------------------------------------------------------------------------
	If A220CanUse()
		//Begin Transaction
			//------------------------
			// Se for teleatendimento.
			//------------------------
			If c220FunName == 'TMKA271'
				If TkGetTipoAte() == '2' .And. .NOT. lTk271Auto
					If SUA->UA_OPER $ '2|3'
						//--------------------------------------------------
						// Verificar se o atendimento já gerou oportunidade.
						//--------------------------------------------------
						If A220VldOport( 'SUA', SUA->UA_NUM )
							//--------------------------------
							// Solicitar dados para o usuário.
							//--------------------------------
							If A220Param()
								n220RecNo := SUA->( RecNo() )
								//--------------------
								// Gerar oportunidade.
								//--------------------
								A220oport( 'SA1', { SUA->UA_CLIENTE, SUA->UA_LOJA }, SUA->UA_NUM, 'SUA', cLista )
							Endif
						Endif
					Else
						MsgAlert( 'Este atendimento está com sua operação em Faturamento, portanto não será possível gerar Oportunidade.', cCadastro )
					Endif
				Endif
			Else
				//------------------------------------------
				// Se for Telemarketing ou Agenda Centisign.
				//------------------------------------------
				If cOrigem $ 'CSFA030|CSFA110'
					A220Aval(Iif(cOrigem=='CSFA030',SUC->UC_CODIGO,cTreatment),cLista)
				Else
					MsgAlert( 'Rotina não preparada para gerar Oportunidade.', cCadastro )
				Endif
			Endif
		//End Transaction
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A220CanUse | Autor | Robson Gonçalves     | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Verificar se a rotina pode ser usada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A220CanUse()
	Local lRet := .T.
	
	If .NOT. SX6->( ExisteSX6( 'MV_PROVEN' ) )
		SX6->( CriarSX6( 'MV_PROVEN', 'C', 'CODIGO DO PROCESSO DE VENDA. ROTINA: CSFA220.prw' ,'000001' ) )
	Endif
		
	If .NOT. SX6->( ExisteSX6( 'MV_STAGE' ) )
		SX6->( CriarSX6( 'MV_STAGE', 'C', 'CODIGO DO ESTAGIO DA VENDA. ROTINA: CSFA220.prw' ,'000PRO' ) )
	Endif

	If SZT->( FieldPos( 'ZT_PROSPEC' )) == 0 .Or.;
	   SZT->( FieldPos( 'ZT_DTCONV'  )) == 0 .Or. ;
	   SZX->( FieldPos( 'ZX_PROSPEC' )) == 0 .Or. ;
		SZX->( FieldPos( 'ZX_DTCONV'  )) == 0 .Or. ;
		PAB->( FieldPos( 'PAB_PROSPE' )) == 0 .Or. ;
		PAB->( FieldPos( 'PAB_DTCONV' )) == 0 .Or. ;
		SUA->( FieldPos( 'UA_OPORTUN' )) == 0 .Or. ;
		SUC->( FieldPos( 'UC_OPORTUN' )) == 0 .Or. ;
		AD1->( FieldPos( 'AD1_ATEND'  )) == 0
		
		MsgAlert( 'Para utilizar esta rotina é preciso executar o Update U_UPD220.', cCadastro )
		lRet := .F.
	Endif	
	
	If .NOT. (c220FunName $ 'CSFA030|CSFA110|TMKA271')
		MsgAlert( 'Esta rotina não está preparada para esta funcionalidade.', cCadastro )
		lRet := .F.
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A220VldOport| Autor | Robson Gonçalves    | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Validar se o chamado gerou oportunidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A220VldOport( cTabela, cAtendimento )
	Local lRet := .F.
	Local cVldCpo := ''
	
	cVldCpo := Iif(cTabela=='SUA','SUA->UA_OPORTUN','SUC->UC_OPORTUN')
	
	If cTabela $ 'SUA|SUC'
		(cTabela)->( dbSetOrder( 1 ) )
		If (cTabela)->( dbSeek( xFilial( cTabela ) + cAtendimento ) )
			If .NOT. Empty( &(cVldCpo) )
				MsgAlert( 'O atendimento ' + cAtendimento + ' já foi transformado na oportunidade ' + &(cVldCpo) + ' ', cCadastro )
			Else
				lRet := .T.
			Endif
		Else
			MsgAlert( 'Atendimento não localizado.', cCadastro)
		Endif
	Else
		MsgAlert( 'Tabela não aderente ao processo de transformar atendimento em oportunidade.', cCadastro )
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A220Param  | Autor | Robson Gonçalves     | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Parâmetros da rotina para geração da oportunidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A220Param()
	Local lRet := .F.
	
	Local aPar := {}
	Local aRet := {}
	
	Local aAD1_PRIOR := {}
	Local aAD1_FEELING := {}
	Local aAD1_PREVFE := {}
	
	Local cTitulo := ''
	Local cSpace := ''
	Local cValid := ''
		
	cTitulo := RTrim( SX3->( RetTitle( 'AD1_DESCRI' ) ) )
	cSpace  := Space( Len( AD1->AD1_DESCRI ) )
	cValid  := 'NaoVazio()'
	AAdd( aPar, {  1, cTitulo, cSpace, '@!', cValid,'','',90, .T. } )
	
	cTitulo := RTrim( SX3->( RetTitle( 'AD1_MEMO' ) ) )
	AAdd( aPar, { 11, cTitulo, '', '.T.', '.T.', .T. } )
	
	cTitulo := RTrim( SX3->( RetTitle( 'AD1_PRIOR' ) ) )
	aAD1_PRIOR := StrToKarr( Posicione( 'SX3', 2, 'AD1_PRIOR', 'X3CBox()' ), ';' )
	AAdd( aPar, { 2, cTitulo, 1, aAD1_PRIOR, 60, '', .T. } )
	
	cTitulo := RTrim( SX3->( RetTitle( 'AD1_FEELING' ) ) )
	aAD1_FEELING := StrToKarr( Posicione( 'SX3', 2, 'AD1_FEELING', 'X3CBox()' ), ';' )	
	AAdd( aPar, { 2, cTitulo, 1, aAD1_FEELING, 60, '', .T. } )
	
	cTitulo := RTrim( SX3->( RetTitle( 'AD1_PREVFE' ) ) )
	aAD1_PREVFE := StrToKarr( Posicione( 'SX3', 2, 'AD1_PREVFE', 'X3CBox()' ), ';' )	
	AAdd( aPar, { 2, cTitulo, 1, aAD1_PREVFE, 60, '', .T. } )
	
	cTitulo := RTrim( SX3->( RetTitle( 'AD1_CODPRO' ) ) )
	cSpace  := Space( Len( AD1->AD1_CODPRO ) )
	cValid  := 'ExistCpo("SX5","Z3"+MV_PAR06)'
	AAdd( aPar, {  1, cTitulo, cSpace, '@!', cValid, 'Z3', '', 90, .T. } )
	

	cTitulo := RTrim( SX3->( RetTitle( 'AD1_DTPFIM' ) ) )
	AAdd( aPar, {  1, cTitulo, Ctod(''), '99/99/99', '', '', '', 50, .T. } )

	lRet := ParamBox( aPar, 'Parâmetros', @aRet, , , , , , , , .F., .F. )
	If lRet
		cAD1_DESCRI  := aRet[ 1 ] 
		cAD1_MEMO    := aRet[ 2 ] 
		cAD1_PRIOR   := Iif( ValType( aRet[ 3 ] ) == 'C', aRet[ 3 ], LTrim( Str( aRet[ 3 ], 1, 0 ) ) )
		cAD1_FEELING := Iif( ValType( aRet[ 4 ] ) == 'C', aRet[ 4 ], LTrim( Str( aRet[ 4 ], 1, 0 ) ) )
		cAD1_PREVFE  := Iif( ValType( aRet[ 5 ] ) == 'C', aRet[ 5 ], LTrim( Str( aRet[ 5 ], 1, 0 ) ) )
		cAD1_CODPRO  := aRet[ 6 ] 
		dAD1_DTPFIM  := aRet[ 7 ] 
	Else
		MsgAlert( 'Operação abandonada.', cCadastro )
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A220oport  | Autor | Robson Gonçalves     | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar a oportunidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A220oport( cEntidade, aChave, cAtendimento, cTabela, cLista )
	Local nI := 0
	Local nJ := 0
	Local nHandle := 0

	Local cArqLog := ''
	Local cSQL := ''
	Local cAD1_NROPOR := ''
	Local cMV_PROVEN := ''
	Local cMV_STAGE := ''
	Local nLenSX8 := GetSX8Len()
	Local cCGC := ''
	Local cGridVar := ''
	Local nGrid := 0
	Local oGridAtu
	
	Local aCab := {}
	Local aItem:= {}
	
	Private aDadosADJ := {}
	Private aDadosAD2 := {}
	Private lMsErroAuto := .F.
	Private cCGCInput := ""
	
	A220Msg( 'Gerando oportunidade...' )
	
	//-------------------------------------------
	// Buscar o produto informado no atendimento.
	//-------------------------------------------
	A220Prod( cTabela, cAtendimento )
	
	If Empty( cAD1_VEND )
		cAD1_VEND := Posicione( 'SU7', 4, xFilial( 'SU7' ) + __cUserID, 'U7_CODVEN' )
		//utilizo o cliente padrão para nao gerar erro na rotina automatica.
		If Empty(cAD1_VEND)
			cAD1_VEND := 'CC0001'
		EndIf
		
		//AAdd( aItem, { 'AD2_VEND' , cAD1_VEND, NIL })
		//AAdd( aDadosAD2, aItem )
	Endif

	cMV_PROVEN := GetMv( 'MV_PROVEN' )
	cMV_STAGE  := GetMv( 'MV_STAGE' )

	AAdd( aCab, { 'AD1_FILIAL' , xFilial('AD1'), NIL })
	AAdd( aCab, { 'AD1_REVISA' , '01'        , NIL })
	AAdd( aCab, { 'AD1_VEND'   , cAD1_VEND   , NIL })
	AAdd( aCab, { 'AD1_DTINI'  , MsDate()    , NIL })
	
	cCGC := GetAdvFVal(cEntidade,Substr(cEntidade,2,2)+"_CGC",xFilial(cEntidade) + aChave[1] + aChave[2], 1, "Erro", .F.)
	
	If !Empty(cCGC)
		aAdd( aCab, { 'AD1_CNPJ' , cCGC , Nil })
	Else
		MsgInfo("Para prosseguir é necessário que um CNPJ/CPF seja informado. Por favor, complete os dados do prospect.","Dados faltantes")
		If !CSFA220CAD(cEntidade,aChave)
			MsgStop("Não é possível prosseguir sem os dados de cliente/prospect. Refaça o procedimento.")
			Return .F.
		Else
			If MsgYesNo("Deseja realizar o cadastro do cliente com os dados do prospect?")
				nGrid := oFld:nOption
				cGridVar := "oGride" + cValToChar(nGrid)		
				oGridAtu := &(cGridVar)
				oGridAtu:aCols[oGridAtu:nAt, aScan(oGridAtu:aHeader,{|p| p[2]=='U6_ENTIDA'})] := "SUS"
				oGridAtu:aCols[oGridAtu:nAt, aScan(oGridAtu:aHeader,{|p| p[2]=='U6_CODENT'})] := SUS->US_COD
				If U_CSFA112(oGridAtu)
					cEntidade := "SA1"
				EndIf
			EndIf
		EndIf
	EndIf
		
	If cEntidade == 'SA1'
		AAdd( aCab, { 'AD1_CODCLI' , aChave[ 1 ] , NIL })
		AAdd( aCab, { 'AD1_LOJCLI' , aChave[ 2 ] , NIL })
		aAdd( aCab, { 'AD1_CNPJ'   , AllTrim(SA1->A1_CGC)   , Nil })
	Elseif cEntidade == 'SUS'
		AAdd( aCab, { 'AD1_PROSPE' , aChave[ 1 ] , NIL })
		AAdd( aCab, { 'AD1_LOJPRO' , aChave[ 2 ] , NIL })
		aAdd( aCab, { 'AD1_CNPJ'   , AllTrim(SUS->US_CGC)   , Nil })
	Endif		 

	
	//AAdd( aCab, { 'AD1_XORIG'  , cLista		, NIL })
	AAdd( aCab, { 'AD1_PROVEN' , cMV_PROVEN , NIL })
	AAdd( aCab, { 'AD1_STAGE'  , cMV_STAGE  , NIL })
	AAdd( aCab, { 'AD1_MOEDA'  , 1          , NIL })
	
	AAdd( aCab, { 'AD1_DESCRI'  , cAD1_DESCRI  , NIL })
	AAdd( aCab, { 'AD1_MEMO'    , cAD1_MEMO    , NIL })	
	AAdd( aCab, { 'AD1_PRIOR'   , cAD1_PRIOR   , NIL })
	AAdd( aCab, { 'AD1_FEELIN'  , cAD1_FEELING , NIL })	
	AAdd( aCab, { 'AD1_PREVFE'  , cAD1_PREVFE  , NIL })	
	
	/******
	 *
	 * HOUVE MUDANÇA DE CONCEITO, POIS O CAMPO AD1_CODPRO É PARA INDICAR O SEGMENTO QUE 
	 * A OPORTUNIDADE VAI ATENDER, OU SEJA, NÃO É MAIS UTILIZADO O CÓDIGO DO PRODUTO.
	 *
	If ( ( Len( aDadosADJ ) == 1 ) .And. ( c220FunName <> 'TMKA271' ) )
		AAdd( aCab, { 'AD1_CODPRO' , aDadosADJ[ 1, 2, 2 ] , NIL })			
		aDadosADJ := {}
	Endif
	*
	***/	
	
	AAdd( aCab, { 'AD1_CODPRO'  , cAD1_CODPRO, NIL })
	AAdd( aCab, { 'AD1_DTPFIM'  , dAD1_DTPFIM, NIL })
	AAdd( aCab, { 'AD1_ATEND'   , SubStr(cAtendimento,1,6) , NIL })
	AAdd( aCab, { 'AD1_TPRECE'  , '1', NIL } ) // 1=Novo Cliente; 2=Cliente de base.

	//----------------------
	// Gerar a oportunidade.
	//----------------------
	//FATA300( 3, aCab, , aDadosAD2, , , aDadosADJ)
	FATA300( 3, aCab, ,			   , , , )
	
	//------------------------------------------------
	// Se houver problema na gravação da oportunidade.
	//------------------------------------------------
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
	Else
		//----------------------------------------
		// Buscar o número da oportunidade gerada.
		//----------------------------------------
		cSQL := "SELECT AD1_NROPOR "
		cSQL += "FROM   "+RetSqlName('AD1')+" AD1 "
		cSQL += "WHERE  AD1_FILIAL = "+ValToSql( xFilial('AD1') )+" "
		cSQL += "       AND AD1_ATEND = "+ValToSql(SubStr(cAtendimento,1,6))+" "
		cSQL += "       AND AD1.D_E_L_E_T_ = ' ' "
		cSQL := ChangeQuery( cSQL )
		DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),'SQLATEND',.F.,.T.)
		cAD1_NROPOR := SQLATEND->AD1_NROPOR
		SQLATEND->( DbCloseArea() )
		
		//-----------------------------------------------
		// Gravar os produtos da oportunidade, caso haja.
		//-----------------------------------------------
		//Renato Ruy - 15/07/2016
		//Utilizo parametro da rotina padrao
		
		If Len(aDadosADJ)>0
			For nI := 1 To Len( aDadosADJ )
				ADJ->( RecLock( 'ADJ', .T. ) )
				ADJ->ADJ_FILIAL := xFilial('ADJ')
				ADJ->ADJ_NROPOR := cAD1_NROPOR
				For nJ := 1 To Len( aDadosADJ[ nI ] )
					ADJ->( FieldPut( FieldPos( aDadosADJ[ nI, nJ, 1 ] ), aDadosADJ[ nI, nJ, 2 ] ) )
				Next Nj
				ADJ->( MsUnLock() )
			Next nI
		Endif
		
		//-------------------------------------------------------------------------------
		// Gravar o número da oportunidade no SUA->Teleatendimento ou SUC->Telemarketing.
		//-------------------------------------------------------------------------------
		If cTabela == 'SUA'
			If SUA->( RecNo() ) <> n220RecNo
				SUA->( dbGoTo( n220RecNo ) )
			Endif
			SUA->( RecLock( 'SUA', .F. ) )
			SUA->UA_OPORTUN := cAD1_NROPOR
			SUA->( MsUnLock() )
		Elseif cTabela == 'SUC'
			If SUC->( RecNo() ) <> n220RecNo
				SUC->( dbGoTo( n220RecNo ) )
			Endif
			SUC->( RecLock( 'SUC', .F. ) )
			SUC->UC_OPORTUN := cAD1_NROPOR
			SUC->( MsUnLock() )
		Endif
		If Empty(cAD1_NROPOR)
			Alert("A oportunidade não foi gerada!")
		Else
			MsgInfo( 'A operação de gerar Oportunidade foi realizada com sucesso, nº ' + cAD1_NROPOR, cCadastro )
		EndIf
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A220Prod   | Autor | Robson Gonçalves     | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para capturar os produtos do atendimento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A220Prod( cTabela, cAtendimento )
	Local nAD1_ITEM := Len(ADJ->ADJ_ITEM)
	Local cItem := Replicate('0',nAD1_ITEM)
	Local aProd := {}
	
	If cTabela == 'SUA' 
		SUB->( dbSetOrder( 1 ) )
		SUB->( dbSeek( xFilial( 'SUB' ) + cAtendimento ) )
		While .NOT. SUB->( EOF() ) .And. SUB->( UB_FILIAL + UB_NUM ) == xFilial( 'SUB' ) + cAtendimento
			cItem := Soma1( cItem, nAD1_ITEM )
			
			AAdd( aProd, { 'ADJ_ITEM'  , cItem          , NIL } )
			AAdd( aProd, { 'ADJ_PROD'  , SUB->UB_PRODUTO, NIL } )
			AAdd( aProd, { 'ADJ_QUANT' , SUB->UB_QUANT  , NIL } )
			AAdd( aProd, { 'ADJ_PRUNIT', SUB->UB_VRUNIT , NIL } )
			AAdd( aProd, { 'ADJ_VALOR' , SUB->UB_VLRITEM, NIL } )
			AAdd( aProd, { 'ADJ_REVISA', '01'           , NIL } )
			AAdd( aProd, { 'ADJ_HISTOR', '2'            , NIL } )
		
			AAdd( aDadosADJ, aProd )
			aProd := {}
			SUB->( dbSkip() )
		End
	Elseif cTabela == 'SUC'
		SUD->( dbSetOrder( 1 ) )
		SUD->( dbSeek( xFilial( 'SUD' ) + SubStr(cAtendimento,1,6) ) )
		While .NOT. SUD->( EOF() ) .And. SUD->( UD_FILIAL + UD_CODIGO ) == xFilial( 'SUD' ) + SubStr(cAtendimento,1,6)
			If .NOT. Empty( SUD->UD_PRODUTO )
				cItem := Soma1( cItem, nAD1_ITEM )
			
				AAdd( aProd, { 'ADJ_ITEM'  , cItem          , NIL } )
				AAdd( aProd, { 'ADJ_PROD'  , SUD->UD_PRODUTO, NIL } )
				AAdd( aProd, { 'ADJ_QUANT' , SUD->UD_QUANT  , NIL } )
				AAdd( aProd, { 'ADJ_PRUNIT', SUD->UD_VUNIT  , NIL } )
				AAdd( aProd, { 'ADJ_VALOR' , SUD->UD_TOTAL  , NIL } )
				AAdd( aProd, { 'ADJ_REVISA', '01'           , NIL } )
				AAdd( aProd, { 'ADJ_HISTOR', '2'            , NIL } )
			
				AAdd( aDadosADJ, aProd )
				aProd := {}
			Endif
			SUD->( dbSkip() )
		End
	Else
		MsgAlert( 'Rotina não preparada para este processo.', cCadastro )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A220Aval   | Autor | Robson Gonçalves     | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para avaliar o atendimento TMK ou TLV e a entidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A220Aval( cTreatment, cLista )
	Local cAtendimento := cTreatment
	Local cChave := ''
	Local cCodigo := ''
	Local cEntidade := ''
	Local _cFilial := ''
	Local cLoja := ''
	Local cLojProsp := ''
	Local cProsp := ''
	
	Local aChave := {}
		
	//--------------------------------------------
	// Posicionar no atendimento do telemarketing.
	//--------------------------------------------
	SUC->( dbSetOrder( 1 ) )
	If SUC->( dbSeek( xFilial( 'SUC' ) + cAtendimento ) ) 
		//--------------------------------------
		// Validar se já não gerou oportunidade.
		//--------------------------------------
		If A220VldOport( 'SUC', cAtendimento )
			n220RecNo := SUC->( RecNo() )
			cEntidade := SUC->UC_ENTIDAD
			cChave := RTrim( SUC->( UC_CHAVE ) )
		   
		   	//Renato Ruy - 13/07/2016
			//Verificar se ja existe cliente vinculado a entidade.
			If !(VLSUS220( cEntidade, cChave ))
				cEntidade := 'SA1'
				cChave := SA1->A1_COD
			EndIf
			
		   //---------------------------
		   // Verificar qual entidade é.
		   //---------------------------
		   If cEntidade $ 'ACH|SZT|SZX|PAB'
				(cEntidade)->( dbSetOrder( 1 ) )
				If (cEntidade)->( dbSeek( xFilial( cEntidade ) + cChave ) )
					cProsp := Iif(cEntidade=='ACH','ACH_CODPRO',;
					          Iif(cEntidade=='PAB','PAB_PROSPE',;
					          Iif(cEntidade=='SZT','ZT_PROSPEC',;
					          Iif(cEntidade=='SZX','ZX_PROSPEC',''))))
					          
					cLojProsp := Iif(cEntidade=='ACH','ACH_LOJPRO',;
					             Iif(cEntidade=='PAB','PAB_LOJPRO',;
					             Iif(cEntidade=='SZT','ZT_LOJPROS',;
					             Iif(cEntidade=='SZX','ZX_LOJPROS',''))))
				
					If Empty( &(cEntidade+'->'+cProsp) ) .And. Empty( &(cEntidade+'->'+cLojProsp) )
						//---------------------------------------
						// Gerar prospect e recuperar seu código.
						// [1] US_COD
						// [2] US_LOJA
						//--------------------------------------- 
						aChave := A220GerarSUS( cEntidade, cChave )
					Else
						aChave := { &(cEntidade+'->'+cProsp), &(cEntidade+'->'+cLojProsp) }
					Endif
					//--------------------------------
					// Solicitar dados para o usuário.
					//--------------------------------
					If A220Param()
						//--------------------
						// Gerar oportunidade.
						//--------------------
						A220oport( 'SUS', aChave, cAtendimento, 'SUC', cLista )
					Endif
				Else
					MsgAlert( 'Entidade não preparada.', cCadastro )
				Endif
			Elseif cEntidade $ 'SA1|SUS'
				If cEntidade == 'SA1'
					_cFilial := xFilial( 'SA1' )
					cCodigo := 'A1_COD'
					cLoja := 'A1_LOJA'
				Else
					_cFilial := xFilial( 'SUS' )
					cCodigo := 'US_COD'
					cLoja := 'US_LOJA'
				Endif
				// [1] US_COD ou A1_COD
				// [2] US_LOJA ou A1_LOJA
				aChave := GetAdvFVal( cEntidade, { cCodigo, cLoja }, _cFilial + cChave, 1, {'',''} )
				//--------------------------------
				// Solicitar dados para o usuário.
				//--------------------------------
				If A220Param()
					//--------------------
					// Gerar oportunidade.
					//--------------------
					A220oport( cEntidade, aChave, cAtendimento, 'SUC' , cLista )
				Endif
			Else
				MsgAlert( 'Entidade não prevista.', cCadastro )
			Endif
		Endif
	Else
		MsgAlert( 'Atendimento não localizado', cCadastro )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A220GerarSUS| Autor | Robson Gonçalves    | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que transforma entidade [SZT|SZX|PAB|ACH] em prospect.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A220GerarSUS( cEntidade, cChave )
	Local nI := 0
	Local nAlias := 0
	Local nSaveSX8 := 0
	
	Local aContato := {}
	Local aCpoDados := {}
	Local aArea	:= GetArea()
	
	Local cUS_COD := ''
	Local cUS_LOJA := ''
	
	A220Msg( 'Gravando prospects...' )

	nSaveSX8 := GetSX8Len()
	cUS_COD := TkNumero('SUS','US_COD')	
	
	//------------------------------------------------------------------
	// Compatibilizar campos do prospects (SUS) com as outras entidades.
	//------------------------------------------------------------------
	AAdd( aCpoDados, { 'US_NOME'  , 'ACH_RAZAO' , 'ZT_EMPRESA', 'ZX_DSRAZAO', 'PAB_EMPRES' } )
	AAdd( aCpoDados, { 'US_NREDUZ', 'ACH_NFANT' , 'ZT_EMPRESA', 'ZX_DSRAZAO', 'PAB_EMPRES' } )
	AAdd( aCpoDados, { 'US_END'   , 'ACH_END'   , ''          , ''          , ''           } )
	AAdd( aCpoDados, { 'US_MUN'   , 'ACH_CIDADE', ''          , 'ZX_DSMUNIC', 'PAB_CIDADE' } )
	AAdd( aCpoDados, { 'US_BAIRRO', 'ACH_BAIRRO', ''          , ''          , 'PAB_BAIRRO' } )
	AAdd( aCpoDados, { 'US_CEP'   , 'ACH_CEP'   , ''          , ''          , 'PAB_CEP'    } )
	AAdd( aCpoDados, { 'US_EST'   , 'ACH_EST'   , 'ZT_UF'     , 'ZX_DSUF'   , 'PAB_EST'    } )
	AAdd( aCpoDados, { 'US_DDD'   , 'ACH_DDD'   , ''          , ''          , 'PAB_DDD'    } )
	AAdd( aCpoDados, { 'US_DDI'   , 'ACH_DDI'   , ''          , ''          , ''           } )
	AAdd( aCpoDados, { 'US_TEL'   , 'ACH_TEL'   , 'ZT_FONE'   , 'ZX_NRTELEF', 'PAB_TELEFO' } )
	AAdd( aCpoDados, { 'US_FAX'   , 'ACH_FAX'   , ''          , ''          , ''           } )
	AAdd( aCpoDados, { 'US_EMAIL' , 'ACH_EMAIL' , 'ZT_CONTTEC', 'ZX_DSEMAIL', 'PAB_EMAIL'  } )
	AAdd( aCpoDados, { 'US_URL'   , 'ACH_URL'   , ''          , ''          , ''           } )
	AAdd( aCpoDados, { 'US_CGC'   , 'ACH_CGC'   , 'ZT_CNPJ'   , 'ZX_NRCNPJ' , 'PAB_CNPJ'   } )
	AAdd( aCpoDados, { 'US_VEND'  , 'ACH_VEND'  , 'ZT_CONSULT', 'ZX_CONSULT', 'PAB_CONSUL' } )
	
	nAlias := Iif(cEntidade=='ACH',2,Iif(cEntidade=='SZT',3,Iif(cEntidade=='SZX',4,Iif(cEntidade=='PAB',5,0))))
	cAD1_VEND := &(cEntidade +'->'+aCpoDados[ AScan( aCpoDados, {|p| p[1]=='US_VEND' } ), nAlias ])
	cUS_LOJA := Iif( cEntidade == 'ACH', ACH->ACH_LOJA, '01' )
	
	Begin Transaction
	
		//--------------------------------
		// Gravar o registro de prospects.
		//--------------------------------
		SUS->( RecLock("SUS",.T.) )
		SUS->US_FILIAL := xFilial( "SUS" )
		SUS->US_COD    := cUS_COD
		SUS->US_LOJA   := cUS_LOJA
		SUS->US_TIPO   := 'F'
		
		For nI := 1 To Len( aCpoDados )
			If .NOT. Empty( aCpoDados[ nI, nAlias ] )
				SUS->( FieldPut( FieldPos( aCpoDados[ nI, 1 ] ), (cEntidade)->&( aCpoDados[ nI, nAlias ] ) ) )
			Endif
		Next nI
		
		SUS->US_STATUS := '1'
		SUS->US_ORIGEM := '1'
		SUS->( MsUnlock() )
		FkCommit()
	
		While (GetSX8Len() > nSaveSX8)
			ConfirmSX8()
		End
		
	End Transaction

	//------------------------------------------------------------------
	// Buscar os contatos da entidade para gravar para o novo prospects.
	//------------------------------------------------------------------
	AC8->( dbSetOrder( 2 ) )
	If AC8->( dbSeek( xFilial( 'AC8' ) + cEntidade + xFilial( cEntidade ) + cChave ) )
		While .NOT. (cEntidade)->( EOF() ) ;
				.And. AC8->( AC8_FILIAL == xFilial( 'AC8' ) ;
				.And. AC8_ENTIDA == cEntidade ;
				.And. AC8_FILENT == xFilial( cEntidade ) ;
				.And. RTrim( AC8_CODENT ) == cChave )
				
			AAdd( aContato, { xFilial( 'AC8' ), 'SUS', xFilial( 'SUS' ), cUS_COD + cUS_LOJA, AC8->AC8_CODCON })
			
	      AC8->( dbSkip() )
		End
	Endif
	
	For nI := 1 To Len( aContato )
		AC8->( RecLock( 'AC8', .T. ) )
		AC8->AC8_FILIAL := aContato[ nI, 1 ]
		AC8->AC8_ENTIDA := aContato[ nI, 2 ]
		AC8->AC8_FILENT := aContato[ nI, 3 ]
		AC8->AC8_CODENT := aContato[ nI, 4 ]
		AC8->AC8_CODCON := aContato[ nI, 5 ]
		AC8->( MsUnLock() )
	Next nI

	//-------------------------------------------
	// Atualizar o suspects com o novo prospects.
	//-------------------------------------------
	If cEntidade == 'ACH'
		ACH->( Reclock( 'ACH' , .F. ) )
		ACH->ACH_CODPRO := cUS_COD
		ACH->ACH_LOJPRO := Right( cChave, 2 )
		ACH->ACH_STATUS := '6'
		ACH->ACH_DTCONV := MsDate()    
		ACH->( MsUnlock() )
	Endif
	
	//------------------------------------------------
	// Atualizar o SSL Renovação com o novo prospects.
	//------------------------------------------------
	If cEntidade == 'SZT'
		SZT->( RecLock( 'SZT', .F. ) )
		SZT->ZT_PROSPEC := cUS_COD
		SZT->ZT_LOJPROS := cUS_LOJA
		SZT->ZT_DTCONV  := MsDate()
		SZT->( MsUnLock() )
	Endif
	
	//---------------------------------------------
	// Atualizar o ICP-Brasil com o novo prospects.
	//---------------------------------------------
	If cEntidade == 'SZX'
		SZX->( RecLock( 'SZX', .F. ) )
		SZX->ZX_PROSPEC := cUS_COD
		SZX->ZX_LOJPROS := cUS_LOJA
		SZX->ZX_DTCONV  := MsDate()
		SZX->( MsUnLock() )
	Endif
	
	//------------------------------------------------------
	// Atualizar a Lista de Importação com o novo prospects.
	//------------------------------------------------------
	If cEntidade == 'PAB'
		PAB->( RecLock( 'PAB', .F. ) )
		PAB->PAB_PROSPE := cUS_COD
		PAB->PAB_LOJPRO := cUS_LOJA
		PAB->PAB_DTCONV := MsDate()
		PAB->( MsUnLock() )
	Endif
	
	RestArea(aArea)
	
Return( { cUS_COD, cUS_LOJA } )

//-----------------------------------------------------------------------
// Rotina | A220Msg    | Autor | Robson Gonçalves     | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que atualiza mensagem de execução.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A220Msg( cMsg )
   MsProcTxt( cMsg )
   ProcessMessage()
Return

//-----------------------------------------------------------------------
// Rotina | UPD220     | Autor | Robson Gonçalves     | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD220()
	Local cModulo := 'TMK'
	Local bPrepar := {|| U_U220Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//-----------------------------------------------------------------------
// Rotina | U220Ini    | Autor | Robson Gonçalves     | Data | 13.08.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U220Ini()
	aSX3 := {}
	aHelp := {}

	AAdd( aSX3    ,{	'AD1',NIL,'AD1_ATEND','C',9,0,;                      //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Orig + Atend','Orig + Atend','Orig + Atend',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Orig + Atend','Orig + Atend','Orig + Atend',;       //Desc. Port.,Desc.Esp.,Desc.Ing.
							'@!',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd( aSX3    ,{	'SZT',NIL,'ZT_PROSPEC','C',6,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Cod.Prospect','Cod.Prospect','Cod.Prospect',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Codigo prospect','Codigo prospect','Codigo prospect',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							'@!',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL
	
	AAdd( aSX3    ,{	'SZT',NIL,'ZT_LOJPROS','C',2,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Loja Prosp.','Loja Prosp.','Loja Prosp.',;          //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Loja Prospects','Loja Prospects','Loja Prospects',; //Desc. Port.,Desc.Esp.,Desc.Ing.
							'@!',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd( aSX3    ,{	'SZT',NIL,'ZT_DTCONV','D',8,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'DT.Conversao','DT.Conversao','DT.Conversao',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Data conversao','Data conversao','Data conversao',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							'  ',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd( aSX3    ,{	'SZX',NIL,'ZX_PROSPEC','C',6,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Cod.Prospect','Cod.Prospect','Cod.Prospect',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Codigo prospect','Codigo prospect','Codigo prospect',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							'@!',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL
	
	AAdd( aSX3    ,{	'SZX',NIL,'ZX_LOJPROS','C',2,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Loja Prosp.','Loja Prosp.','Loja Prosp.',;          //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Loja Prospects','Loja Prospects','Loja Prospects',; //Desc. Port.,Desc.Esp.,Desc.Ing.
							'@!',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd( aSX3    ,{	'SZX',NIL,'ZX_DTCONV','D',8,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'DT.Conversao','DT.Conversao','DT.Conversao',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Data conversao','Data conversao','Data conversao',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							'  ',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd( aSX3    ,{	'PAB',NIL,'PAB_PROSPE','C',6,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Cod.Prospect','Cod.Prospect','Cod.Prospect',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Codigo prospect','Codigo prospect','Codigo prospect',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							'@!',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd( aSX3    ,{	'PAB',NIL,'PAB_LOJPRO','C',2,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Loja Prosp.','Loja Prosp.','Loja Prosp.',;          //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Loja Prospects','Loja Prospects','Loja Prospects',; //Desc. Port.,Desc.Esp.,Desc.Ing.
							'@!',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd( aSX3    ,{	'PAB',NIL,'PAB_DTCONV','D',8,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'DT.Conversao','DT.Conversao','DT.Conversao',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Data conversao','Data conversao','Data conversao',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							'  ',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd( aSX3    ,{	'SUA',NIL,'UA_OPORTUN','C',6,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'No.Oport.','No.Oport.','No.Oport.',;                //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Num. da oportunidade','Num. da oportunidade','Num. da oportunidade',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							'  ',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd( aSX3    ,{	'SUC',NIL,'UC_OPORTUN','C',6,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'No.Oport.','No.Oport.','No.Oport.',;                //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Num. da oportunidade','Num. da oportunidade','Num. da oportunidade',;//Desc. Port.,Desc.Esp.,Desc.Ing.
							'  ',;                                               //Picture
							'',;                                                 //Valid
							X3_EMUSO_USADO,;                                     //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AD1_ATEND', 'Nome da origem (TMK=Telemarketing TLV=Televendas) e número do atendimento.'})

	AAdd(aHelp,{'ZT_PROSPEC', 'Codigo do prospect quando convertido.'})
	AAdd(aHelp,{'ZT_LOJPROS', 'Loja do prospect quando convertido.'})
	AAdd(aHelp,{'ZT_DTCONV' , 'Data da conversao do cadastro para prospects.'})

	AAdd(aHelp,{'ZX_PROSPEC', 'Codigo do prospect quando convertido.'})
	AAdd(aHelp,{'ZX_LOJPROS', 'Loja do prospect quando convertido.'})
	AAdd(aHelp,{'ZX_DTCONV' , 'Data da conversao do cadastro para prospects.'})

	AAdd(aHelp,{'PAB_PROSPE', 'Codigo do prospect quando convertido.'})
	AAdd(aHelp,{'PAB_LOJPRO', 'Loja do prospect quando convertido.'})
	AAdd(aHelp,{'PAB_DTCONV', 'Data da conversao do cadastro para prospects.'})
	
	AAdd(aHelp,{'UA_OPORTUN', 'Numero da oportunidade.'})
	AAdd(aHelp,{'UC_OPORTUN', 'Numero da oportunidade.'})
Return(.T.)
                          
//-----------------------------------------------------------------------
// Rotina | VLSUS220   | Autor | Renato Ruy		     | Data | 13.07.2016
//-----------------------------------------------------------------------
// Descr. | e posiciona na entidade e retorna o codigo do cliente caso 
//        | para não criar um suspect e utilizar o cliente existente.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function VLSUS220(cEntidade, cChave)
Local lReturn := .T.
Local cCnpj	  := ''

//Renato Ruy - 13/07/2016
//Se posiciona na entidade e retorna o codigo do cliente caso exista.
If cEntidade == 'ACH'
	ACH->(DbSetOrder(1))
	If ACH->(DbSeek(xFilial('ACH')+cChave))
		cCnpj := ACH->ACH_CGC
	EndIf
ElseIf cEntidade == 'SZT'
	SZT->(DbSetOrder(1))
	If SZT->(DbSeek(xFilial('SZT')+cChave))
		cCnpj := SZT->ZT_CNPJ
	EndIf
ElseIf cEntidade == 'SZX'
	SZX->(DbSetOrder(1))
	If SZX->(DbSeek(xFilial('SZX')+cChave))
		cCnpj := SZX->ZX_NRCNPJ
	EndIf
ElseIf cEntidade == 'PAB'
	PAB->(DbSetOrder(1))
	If PAB->(DbSeek(xFilial('PAB')+cChave))
		cCnpj := PAB->PAB_CNPJ
	EndIf
ElseIf cEntidade == 'SUS'
	PAB->(DbSetOrder(1))
	If SUS->(DbSeek(xFilial('SUS')+cChave))
		cCnpj := SUS->US_CGC
	EndIf
EndIf 

If !Empty(cCnpj)
	SA1->(DbSetOrder(3))
	If SA1->(DbSeek(xFilial("SA1")+U_CSFMTSA1(cCnpj)))
		lReturn := .F.
	EndIf
EndIf

Return lReturn


//+-------------+----------+-------+-----------------------+------+------------+
//|Programa:    |FTM010CAD |Autor: |David Alves dos Santos |Data: |20/12/2016  |
//|-------------+----------+-------+-----------------------+------+------------|
//|Descricao:   |Montagem da tela de cadastro caso o registro nao exista nas   |
//|             |tabelas SA1 ou SUS.                                           |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function CSFA220CAD(cEntidade,aChave)

	Local oGroupPros
	Local oSayCod
	Local oGetCod
	Local cGetCod    := aChave[1]
	Local oSayLoj
	Local oGetLoj
	Local cGetLoj    := aChave[2]
	Local oSayCnpj
	Local oGetCnpj
	Local cGetCnpj   := GetAdvFVal(cEntidade,Substr(cEntidade,2,2)+"_CGC",xFilial(cEntidade) + aChave[1] + aChave[2], 1, "Erro", .F.)
	Local oSayFJ
	Local oComboFJ
	Local nComboFJ   := Iif(Len(cGetCnpj) == 14, 2, 1)
	Local oSayNom
	Local oGetNom
	Local cGetNom    := Space(TamSX3("US_NOME")[1])
	Local oSayEnd
	Local oGetEnd
	Local cGetEnd    := Space(TamSX3("US_END")[1])
	Local oSayEst
	Local oGetEst
	Local cGetEst    := Space(TamSX3("US_EST")[1])
	Local oSayMun
	Local oGetMun
	Local cGetMun    := Space(TamSX3("US_MUN")[1])
	Local oSayTip
	Local oComboTip
	Local nComboTip  := 1
	Local oSayDDD
	Local oGetDDD
	Local cGetDDD    := Space(TamSX3("US_DDD")[1])
	Local oGetTel
	Local cGetTel    := Space(TamSX3("US_TEL")[1])
	Local oSayGrpV
	Local oGetGrpV
	Local cGetGrpV   := Space(TamSX3("US_GRPVEN")[1])
	Local oSayTel
	Local oSBtnCanc
	Local oSBtnOK
	
	//-- Lista de opcoes.
	Local aItensTip  := {" ", "F=Cons.Final", "L=Produtor Rural", "R=Revendedor", "S=Solidario", "X=Exportacao"}
	Local aItensFJ   := {"F=Fisica", "J=Juridica"}
	Local aDados     := {}
	Local lRet       := .T.
	
	Local oDlgCad
	
	dbSelectArea(cEntidade)
	(cEntidade)->(dbSetOrder(1))
	If (cEntidade)->(dbSeek(xFilial(cEntidade)+aChave[1]+aChave[2]))
		cGetCod 	:= aChave[1]
		cGetLoj 	:= aChave[2]
		cGetCnpj 	:= (cEntidade)->&(Substr(cEntidade,2,2)+"_CGC")
    	cGetNom  	:= (cEntidade)->&(Substr(cEntidade,2,2)+"_NOME")
    	cGetEnd  	:= (cEntidade)->&(Substr(cEntidade,2,2)+"_END")
    	cGetEst  	:= (cEntidade)->&(Substr(cEntidade,2,2)+"_EST")
    	cGetMun  	:= (cEntidade)->&(Substr(cEntidade,2,2)+"_MUN")
    	cGetDDD  	:= (cEntidade)->&(Substr(cEntidade,2,2)+"_DDD")
    	cGetTel  	:= (cEntidade)->&(Substr(cEntidade,2,2)+"_TEL")
    	cGetGrpV 	:= (cEntidade)->&(Substr(cEntidade,2,2)+"_GRPVEN")		
	EndIf
	
	//-- Montagem da tela de cadastro.
  	DEFINE MSDIALOG oDlgCad TITLE "Inclusao de Prospect" FROM 000, 000  TO 370, 500 PIXEL
		
		//-- Grupo de componentes.
    	@ 004, 004 GROUP oGroupPros TO 165, 244 LABEL " Inclusão de Prospect: " OF oDlgCad PIXEL
    	
    	//-- Campos.
    	@ 022, 038 MSGET oGetCod  VAR cGetCod  SIZE 060, 010 OF oDlgCad PICTURE PesqPict( "SUS" ,"US_COD"  	) WHEN .F.	PIXEL
    	@ 022, 155 MSGET oGetLoj  VAR cGetLoj  SIZE 072, 010 OF oDlgCad PICTURE PesqPict( "SUS" ,"US_LOJA" 	) 	       	PIXEL
    	@ 042, 038 MSGET oGetCnpj VAR cGetCnpj SIZE 060, 010 OF oDlgCad PICTURE PesqPict( "SUS" ,"US_CGC"  	)  		   	PIXEL
    	@ 062, 038 MSGET oGetNom  VAR cGetNom  SIZE 196, 010 OF oDlgCad PICTURE PesqPict( "SUS" ,"US_NOME" 	)           PIXEL
    	@ 082, 038 MSGET oGetEnd  VAR cGetEnd  SIZE 143, 010 OF oDlgCad PICTURE PesqPict( "SUS" ,"US_END"  	)           PIXEL
    	@ 082, 211 MSGET oGetEst  VAR cGetEst  SIZE 022, 010 OF oDlgCad PICTURE PesqPict( "SUS" ,"US_EST"  	) F3 "12"  	PIXEL
    	@ 102, 038 MSGET oGetMun  VAR cGetMun  SIZE 060, 010 OF oDlgCad PICTURE PesqPict( "SUS" ,"US_MUN"  	)           PIXEL
    	@ 122, 038 MSGET oGetDDD  VAR cGetDDD  SIZE 060, 010 OF oDlgCad PICTURE PesqPict( "SUS" ,"US_DDD"  	)           PIXEL
    	@ 122, 155 MSGET oGetTel  VAR cGetTel  SIZE 072, 010 OF oDlgCad PICTURE PesqPict( "SUS" ,"US_TEL"  	)           PIXEL
    	@ 142, 038 MSGET oGetGrpV VAR cGetGrpV SIZE 060, 010 OF oDlgCad PICTURE PesqPict( "SUS" ,"US_GRPVEN") F3 "ACY" 	PIXEL
    	
    	//-- Rotulos.
    	@ 022, 010 SAY oSayCod  PROMPT "*Código:"        SIZE 019, 007 OF oDlgCad COLOR CLR_HBLUE PIXEL
    	@ 022, 117 SAY oSayLoj  PROMPT "*Loja:"          SIZE 013, 007 OF oDlgCad COLOR CLR_HBLUE PIXEL
    	@ 042, 010 SAY oSayCnpj PROMPT "*CNPJ:"          SIZE 016, 007 OF oDlgCad COLOR CLR_HBLUE PIXEL
    	@ 082, 010 SAY oSayEnd  PROMPT "Endereço:"       SIZE 026, 007 OF oDlgCad                 PIXEL
    	@ 062, 010 SAY oSayNom  PROMPT "*Nome:"          SIZE 025, 007 OF oDlgCad COLOR CLR_HBLUE PIXEL
    	@ 082, 188 SAY oSayEst  PROMPT "*Estado:"        SIZE 021, 007 OF oDlgCad COLOR CLR_HBLUE PIXEL
    	@ 102, 010 SAY oSayMun  PROMPT "Municipio:"      SIZE 026, 007 OF oDlgCad                 PIXEL
    	@ 102, 117 SAY oSayTip  PROMPT "Tipo:"           SIZE 017, 007 OF oDlgCad                 PIXEL
    	@ 122, 010 SAY oSayDDD  PROMPT "*DDD:"           SIZE 025, 007 OF oDlgCad COLOR CLR_HBLUE PIXEL
    	@ 122, 117 SAY oSayTel  PROMPT "*Telefone:"      SIZE 028, 007 OF oDlgCad COLOR CLR_HBLUE PIXEL
    	@ 042, 117 SAY oSayFJ   PROMPT "*Fisica/Jurid.:" SIZE 029, 007 OF oDlgCad COLOR CLR_HBLUE PIXEL
    	@ 142, 010 SAY oSayGrpV PROMPT "*Grp.Ven.:"      SIZE 029, 007 OF oDlgCad COLOR CLR_HBLUE PIXEL
    	
    	//-- Combos.
    	@ 102, 155 MSCOMBOBOX oComboTip VAR nComboTip ITEMS aItensTip SIZE 072, 010 OF oDlgCad PIXEL
    	@ 042, 155 MSCOMBOBOX oComboFJ  VAR nComboFJ  ITEMS aItensFJ  SIZE 072, 010 OF oDlgCad PIXEL
    	
    	//-- Dados para ser enviados para o Execauto.
    	//aDados := {cGetCod, cGetLoj, cGetCnpj, cGetNom, cGetEnd, cGetEst, cGetMun, cGetDDD, cGetTel, nComboTip, nComboFJ}
		    	
    	//-- Botoes.
		DEFINE SBUTTON oSBtnOK   FROM 170, 165 TYPE 01 OF oDlgCad ENABLE ACTION {|| lRet := FTM010Prc( {	cGetCod   ,;
																													cGetLoj   ,;
																													cGetNom   ,;
																													nComboTip ,;
																													cGetEnd   ,;
																													cGetMun   ,;
																													cGetEst   ,;
																													cGetDDD   ,;
																													cGetTel   ,;
																													nComboFJ  ,;
																													cGetCnpj  ,;
																													cGetGrpV  }), Iif(lRet,oDlgCad:End(),"")}
    	DEFINE SBUTTON oSBtnCanc FROM 170, 218 TYPE 02 OF oDlgCad ENABLE ACTION {|| lRet := .F., oDlgCad:End()}
    	
	ACTIVATE MSDIALOG oDlgCad CENTERED
	
Return lRet


//+-------------+----------+-------+-----------------------+------+------------+
//|Programa:    |FTM010Prc |Autor: |David Alves dos Santos |Data: |22/12/2016  |
//|-------------+----------+-------+-----------------------+------+------------|
//|Descricao:   |Processa a inclusao do Prospect na tabela SUS.                |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function FTM010Prc(aDados)

	Local aVetor        := {}
	Local lRet          := .T.
	
	PRIVATE lMsErroAuto := .F.
			
	//-- Tratamento de erro de campos obrigatorios no cadatro de prospect.
	Do Case
  		Case Empty(aDados[1])	//-- Codigo
  			lRet := .F.
     		MsgStop("Campo CODIGO vazio, Favor informar um conteúdo válido!","ERRO-002 | CSFTV010")
     	Case Empty(aDados[2])	//-- Loja
     		lRet := .F.
     		MsgStop("Campo LOJA vazio, Favor informar um conteúdo válido!","ERRO-003 | CSFTV010")
     	Case Empty(aDados[3])	//-- Nome
     		lRet := .F.
     		MsgStop("Campo NOME vazio, Favor informar um conteúdo válido!","ERRO-004 | CSFTV010")
     	Case Empty(aDados[7])	//-- Estado
     		lRet := .F.
     		MsgStop("Campo ESTADO vazio, Favor informar um conteúdo válido!","ERRO-005 | CSFTV010")
     	Case Empty(aDados[8])	//-- DDD
     		lRet := .F.
     		MsgStop("Campo DDD vazio, Favor informar um conteúdo válido!","ERRO-006 | CSFTV010")
     	Case Empty(aDados[9])	//-- Telefone
     		lRet := .F.
     		MsgStop("Campo TELEFONE vazio, Favor informar um conteúdo válido!","ERRO-007 | CSFTV010")
     	Case Empty(aDados[10])	//-- Fisica/Juridica
     		lRet := .F.
     		MsgStop("Campo FISICA/JURID vazio, Favor informar um conteúdo válido!","ERRO-008 | CSFTV010")
     	Case Empty(aDados[11])	//-- CNPJ
     		lRet := .F.
     		MsgStop("Campo CNPJ vazio, Favor informar um conteúdo válido!","ERRO-009 | CSFTV010")
     	Case Empty(aDados[12])	//-- Grupo de Venda
     		lRet := .F.
     		MsgStop("Campo Grp.Ven. vazio, Favor informar um conteúdo válido!","ERRO-010 | CSFTV010")
	EndCase	
 	
	//-- Se nao houver erro segue o processo.
	If lRet		
		//+----------------------------------------------+
		//| Realiza o tratamento da variaveis numericas. |
		//+----------------------------------------------+
		aDados[10] := Iif(ValType(aDados[10]) == "N",Iif(aDados[10] == 1, "F", "J"),aDados[10])
		Do Case
	  		Case aDados[4] == Iif(ValType(aDados[4])=="N",1,"1")
     			aDados[4] := "F"
     		Case aDados[4] == Iif(ValType(aDados[4])=="N",2,"2")
	     		aDados[4] := "L"
     		Case aDados[4] == Iif(ValType(aDados[4])=="N",3,"3")
	     		aDados[4] := "R"
     		Case aDados[4] == Iif(ValType(aDados[4])=="N",4,"4")
	     		aDados[4] := "S"
     		Case aDados[4] == Iif(ValType(aDados[4])=="N",5,"5")
	     		aDados[4] := "X"
		EndCase
		
		BEGIN TRANSACTION
			//-- Grava o Prospect na tabela SUS.
			RecLock("SUS", SUS->(!Found()))
				SUS->US_COD    := aDados[1]
				SUS->US_LOJA   := aDados[2]
				SUS->US_NOME   := aDados[3]
				SUS->US_NREDUZ := aDados[3]
				SUS->US_TIPO   := aDados[4]
				SUS->US_END    := aDados[5]
				SUS->US_MUN    := aDados[6]
				SUS->US_EST    := aDados[7]
				SUS->US_DDD    := aDados[8]
				SUS->US_TEL    := aDados[9]
				SUS->US_PESSOA := aDados[10]
				SUS->US_CGC    := aDados[11]
				SUS->US_GRPVEN := aDados[12]
				SUS->US_MSBLQL := "2"
			SUS->(MsUnLock())
		END TRANSACTION

		//-- Confirma numeracao automatica e apresenta mensagem de sucesso.
		MsgInfo("Registro incluido com sucesso!")
		
	EndIf
			
Return( lRet )