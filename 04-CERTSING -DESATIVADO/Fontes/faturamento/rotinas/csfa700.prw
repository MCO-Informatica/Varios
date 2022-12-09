//-----------------------------------------------------------------------
// Rotina | CSFA700    | Autor | Robson Gonçalves     | Data | 11/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de cadastro de regra de categoria de produto.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'

User Function CSFA700()
	Private cCadastro := 'Regra Categoria de Produto'
	Private aRotina := {}

	Private oSize 
	
	Private lEnchBar := .T.
	Private nHoriz := 100
	Private nVertCabec := 20
	Private nVertGride := 80

	Private nC_LinIni := 0
	Private nC_ColIni := 0
	Private nC_LinEnd := 0
	Private nC_ColEnd := 0

	Private nG_LinIni := 0
	Private nG_ColIni := 0
	Private nG_LinEnd := 0
	Private nG_ColEnd := 0
	
	A700AtuSX()
	
	oSize := FWDefSize():New( lEnchBar )
	 
	oSize:AddObject( "CABEC", nHoriz, nVertCabec, .T., .T. )
	oSize:AddObject( "GRIDE", nHoriz, nVertGride, .T., .T. )
	 
	oSize:lProp := .T.
	oSize:aMargins := { 3, 3, 3, 3 }
	oSize:Process()
	
	nC_LinIni := oSize:GetDimension("CABEC","LININI")
	nC_ColIni := oSize:GetDimension("CABEC","COLINI")
	nC_LinEnd := oSize:GetDimension("CABEC","LINEND")
	nC_ColEnd := oSize:GetDimension("CABEC","COLEND")

	nG_LinIni := oSize:GetDimension("GRIDE","LININI")
	nG_ColIni := oSize:GetDimension("GRIDE","COLINI")
	nG_LinEnd := oSize:GetDimension("GRIDE","LINEND")
	nG_ColEnd := oSize:GetDimension("GRIDE","COLEND")

	AAdd( aRotina, {'Pesquisar' ,'AxPesqui'  ,0, 1 } )
	AAdd( aRotina, {'Visualizar','U_A700Vis' ,0, 2 } )
	AAdd( aRotina, {'Incluir'   ,'U_A700Inc' ,0, 3 } )
	AAdd( aRotina, {'Alterar'   ,'U_A700Alt' ,0, 4 } )
	AAdd( aRotina, {'Excluir'   ,'U_A700Exc' ,0, 5 } )
	
	dbSelectArea('PB0')
	dbSetOrder(1)
	
	MBrowse(,,,,'PB0')
Return

//-----------------------------------------------------------------------
// Rotina | CSFA700    | Autor | Robson Gonçalves     | Data | 11/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de visualização do cadastro.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A700Vis( cAlias, nRecNo, nOpcX )
	Local oDlg
	Local oMsMGet
	Local oGride
		
	Local nX := 0
	Local nOpcA := 0
	
	Local bCampo   := {|nField| FieldName(nField) }
	
	Private aHeader := {}
	Private aCOLS := {}
	
	RegToMemory( 'PB0', .F., .F. )
	
 	cSeek  := xFilial( 'PB1' ) + PB0->PB0_REGRA
 	cWhile := 'PB1->PB1_FILIAL + PB1->PB1_REGRA'

	MsAguarde( {|| ;
	FillGetDados(	nOpcX , 'PB1', 1, cSeek,; 
					{||&(cWhile)}, /*{|| bCond,bAct1,bAct2}*/, /*aNoFields*/,; 
			   		/*aYesFields*/, /*lOnlyYes*/,/* cQuery*/, /*bMontAcols*/, IIf(nOpcX<>3,.F.,.T.),; 
					/*aHeaderAux*/, /*aColsAux*/,/*bAfterCols*/ , /*bBeforeCols*/,;
					/*bAfterHeader*/, /*cAliasQry*/) }, cCadastro, 'Carregando os dados, aguarde...', .F. )
					
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oMsMGet := MsMGet():New('PB0',PB0->(RecNo()),nOpcX,,,,,{nC_LinIni,nC_ColIni,nC_LinEnd,nC_ColEnd},,,,,,oDlg,,,,,,,,,,,)
		
		oGride := MsNewGetDados():New(nG_LinIni,nG_ColIni,nG_LinEnd,nG_ColEnd,0,,,,,,Len(aCOLS),,,,oDlg,aHeader,aCOLS)
		
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() })
Return
	
//-----------------------------------------------------------------------
// Rotina | CSFA700    | Autor | Robson Gonçalves     | Data | 11/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de inclusão do cadastro.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A700Inc( cAlias, nRecNo, nOpcX )
	Local oDlg 
	Local oMsMGet
		
	Local nX := 0
	Local nOpcA := 0
	
	Local bCampo   := {|nField| FieldName(nField) }
	
	Private oGride
	Private aHeader := {}
	Private aCOLS := {}

	RegToMemory( 'PB0', .T., .F. )

 	cSeek  := xFilial( 'PB1' ) + PB0->PB0_REGRA
 	cWhile := 'PB1->PB1_FILIAL + PB1->PB1_REGRA'
	
	MsAguarde( {|| ;	
	FillGetDados(	nOpcX , 'PB1', 1, cSeek,; 
					{||&(cWhile)}, /*{|| bCond,bAct1,bAct2}*/, /*aNoFields*/,; 
			   		/*aYesFields*/, /*lOnlyYes*/,/* cQuery*/, /*bMontAcols*/, IIf(nOpcX<>3,.F.,.T.),; 
					/*aHeaderAux*/, /*aColsAux*/,/*bAfterCols*/ , /*bBeforeCols*/,;
					/*bAfterHeader*/, /*cAliasQry*/) }, cCadastro, 'Carregando os dados, aguarde...', .F. )
					
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oMsMGet := MsMGet():New('PB0',PB0->(RecNo()),nOpcX,,,,,{nC_LinIni,nC_ColIni,nC_LinEnd,nC_ColEnd},,,,,,oDlg,,,,,,,,,,,)
		
		oGride := MsNewGetDados():New(nG_LinIni,nG_ColIni,nG_LinEnd,nG_ColEnd,GD_INSERT+GD_UPDATE+GD_DELETE,,,,,,1000,,,,oDlg,aHeader,aCOLS)
		
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| Iif(oGride:TudoOK(),Iif(MsgYesNo('Confirma a operação?',cCadastro),(nOpcA:=1,oDlg:End()),NIL),NIL) },;
	{|| oDlg:End() })
	
	If nOpcA == 1
		Begin Transaction
			FwMsgRun(,{|| A700Grava( nOpcX )},,'Aguarde, gravando os dados...')
			EvalTrigger()
			If __lSX8
				ConfirmSX8()
			Endif
		End Transaction
	Else
		If __lSX8
			RollBackSX8()
		Endif	
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | CSFA700    | Autor | Robson Gonçalves     | Data | 11/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de alteração do cadastro.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A700Alt( cAlias, nRecNo, nOpcX )
	Local oDlg 
	Local oMsMGet
		
	Local nX := 0
	Local nOpcA := 0
	
	Local bCampo   := {|nField| FieldName(nField) }
	
	Private oGride
	Private aHeader := {}
	Private aCOLS := {}

	RegToMemory( 'PB0', .F., .F. )

 	cSeek  := xFilial( 'PB1' ) + PB0->PB0_REGRA
 	cWhile := 'PB1->PB1_FILIAL + PB1->PB1_REGRA'

	MsAguarde( {|| ;
	FillGetDados(	nOpcX , 'PB1', 1, cSeek,; 
					{||&(cWhile)}, /*{|| bCond,bAct1,bAct2}*/, /*aNoFields*/,; 
			   		/*aYesFields*/, /*lOnlyYes*/,/* cQuery*/, /*bMontAcols*/, IIf(nOpcX<>3,.F.,.T.),; 
					/*aHeaderAux*/, /*aColsAux*/,/*bAfterCols*/ , /*bBeforeCols*/,;
					/*bAfterHeader*/, /*cAliasQry*/)  }, cCadastro, 'Carregando os dados, aguarde...', .F. )
					
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oMsMGet := MsMGet():New('PB0',PB0->(RecNo()),nOpcX,,,,,{nC_LinIni,nC_ColIni,nC_LinEnd,nC_ColEnd},,,,,,oDlg,,,,,,,,,,,)
		
		oGride := MsNewGetDados():New(nG_LinIni,nG_ColIni,nG_LinEnd,nG_ColEnd,GD_INSERT+GD_UPDATE+GD_DELETE,,,,,,1000,,,,oDlg,aHeader,aCOLS)
		
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| Iif(oGride:TudoOK(),Iif(MsgYesNo('Confirma a operação?',cCadastro),(nOpcA:=1,oDlg:End()),NIL),NIL) },;
	{|| oDlg:End() })
	
	If nOpcA == 1
		Begin Transaction
			FwMsgRun(,{|| A700Grava( nOpcX )},,'Aguarde, gravando os dados...')
			EvalTrigger()
		End Transaction
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | CSFA700    | Autor | Robson Gonçalves     | Data | 11/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de exclusão do cadastro.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A700Exc( cAlias, nRecNo, nOpcX )
	Local oDlg 
	Local oMsMGet
	Local oGride
		
	Local nX := 0
	Local nOpcA := 0
	
	Local bCampo   := {|nField| FieldName(nField) }
	
	Private aHeader := {}
	Private aCOLS := {}

	RegToMemory( 'PB0', .F., .F. )
	
 	cSeek  := xFilial( 'PB1' ) + PB0->PB0_REGRA
 	cWhile := 'PB1->PB1_FILIAL + PB1->PB1_REGRA'

	MsAguarde( {|| ;
	FillGetDados(	nOpcX , 'PB1', 1, cSeek,; 
					{||&(cWhile)}, /*{|| bCond,bAct1,bAct2}*/, /*aNoFields*/,; 
			   		/*aYesFields*/, /*lOnlyYes*/,/* cQuery*/, /*bMontAcols*/, IIf(nOpcX<>3,.F.,.T.),; 
					/*aHeaderAux*/, /*aColsAux*/,/*bAfterCols*/ , /*bBeforeCols*/,;
					/*bAfterHeader*/, /*cAliasQry*/) }, cCadastro, 'Carregando os dados, aguarde...', .F. )
					
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oMsMGet := MsMGet():New('PB0',PB0->(RecNo()),nOpcX,,,,,{nC_LinIni,nC_ColIni,nC_LinEnd,nC_ColEnd},,,,,,oDlg,,,,,,,,,,,)
		
		oGride := MsNewGetDados():New(nG_LinIni,nG_ColIni,nG_LinEnd,nG_ColEnd,0,,,,,,Len(aCOLS),,,,oDlg,aHeader,aCOLS)
		
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| Iif(oGride:TudoOK(),Iif(MsgYesNo('Confirma a operação?',cCadastro),(nOpcA:=1,oDlg:End()),NIL),NIL) },;
	{|| oDlg:End() })
	
	If nOpcA == 1
		Begin Transaction
			FwMsgRun(,{|| A700Grava( nOpcX )},,'Aguarde, gravando os dados...')
		End Transaction
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | CSFA700    | Autor | Robson Gonçalves     | Data | 11/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de gravação dos dados das operações do cadastro.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A700Grava( nOpcX )
	Local lGravou := .F.
	Local nUsado := 0
	Local nX := 0
	Local nI  := 0
	
	Private bCampo := { |nField| FieldName(nField) }
	
	nUsado := Len( aHeader ) + 1
	
	//+----------------
	//| Se for inclusao
	//+----------------
	If nOpcX == 3
	   //+---------------
	   //| Grava os itens
	   //+---------------
		PB1->( dbSetOrder( 1 ) )
		For nX := 1 To Len( oGride:aCOLS )
	      If .NOT. oGride:aCOLS[ nX, nUsado ]
	         PB1->( RecLock( 'PB1', .T. ) )
	         For nI := 1 To Len( oGride:aHeader )
	            PB1->( FieldPut( FieldPos( Trim( oGride:aHeader[ nI, 2 ] ) ), oGride:aCOLS[ nX, nI ] ) )
	         Next nI
	         PB1->PB1_FILIAL := xFilial( 'PB1' )
	         PB1->PB1_REGRA  := M->PB0_REGRA
	         PB1->( MsUnLock() )
	         lGravou := .T.
			Endif
		Next nX
	   //+------------------
	   //| Grava o Cabecalho
	   //+------------------
	   If lGravou
	      PB0->( RecLock( 'PB0', .T. ) )
	      For nX := 1 To PB0->( FCount() )
	         If "FILIAL" $ PB0->( FieldName( nX ) )
	            PB0->( FieldPut( nX, xFilial( 'PB0' ) ) )
	         Else
	            PB0->( FieldPut( nX, M->&( Eval( bCampo, nX ) ) ) )
	         Endif
	      Next nX
	      PB0->( MsUnLock() )
	   Endif
	Endif
	
	//+-----------------
	//| Se for alteração
	//+-----------------
	If nOpcX == 4
		PB1->( dbSetOrder( 1 ) )
		For nX := 1 To Len( oGride:aCOLS )
			PB1->( dbSeek( xFilial( 'PB1' ) + PB0->PB0_REGRA + oGride:aCOLS[ nX, GdFieldPos('PB1_CATEG') ] + oGride:aCOLS[ nX, GdFieldPos('PB1_CCUSTO') ] ) )
			If PB1->( Found() )
				If oGride:aCOLS[ nX, nUsado ]
					PB1->( RecLock( 'PB1', .F. ) )
					PB1->( dbDelete() )
					PB1->( MsUnLock() )
				Else
		         PB1->( RecLock( 'PB1', .F. ) )
		         For nI := 1 To Len( oGride:aHeader )
		            PB1->( FieldPut( FieldPos( Trim( oGride:aHeader[ nI, 2 ] ) ), oGride:aCOLS[ nX, nI ] ) )
		         Next nI
					PB1->( MsUnLock() )
				Endif
			Else
				If .NOT. oGride:aCOLS[ nX, nUsado ]
		         PB1->( RecLock( 'PB1', .T. ) )
		         PB1->PB1_FILIAL := xFilial( 'PB1' )
		         PB1->PB1_REGRA  := M->PB0_REGRA
		         For nI := 1 To Len( oGride:aHeader )
		            PB1->( FieldPut( FieldPos( Trim( oGride:aHeader[ nI, 2 ] ) ), oGride:aCOLS[ nX, nI ] ) )
		         Next nI
					PB1->( MsUnLock() )
				Endif
			Endif
		Next nX

	   //+------------------
	   //| Grava o Cabecalho
	   //+------------------
   	PB0->( dbSetOrder( 1 ) )
   	PB0->( dbSeek( xFilial( 'PB0' ) + M->PB0_REGRA ) )
      PB0->( RecLock( 'PB0', .F. ) )
      For nX := 1 To PB0->( FCount() )
         If .NOT. ("PB0_FILIAL|PB0_REGRA" $ PB0->( FieldName( nX ) ) )
            PB0->( FieldPut( nX, M->&( Eval( bCampo, nX ) ) ) )
         Endif
      Next nX
      PB0->( MsUnLock() )
	Endif
	
	//+----------------
	//| Se for exclusão
	//+----------------
	If nOpcX == 5
	   //+----------------
	   //| Deleta os Itens
	   //+----------------
	   PB1->( dbSetOrder( 1 ) )
	   PB1->( dbSeek( xFilial( 'PB1' ) + M->PB0_REGRA, .T. ) )
	   While PB1->( .NOT. EOF() ) .AND. xFilial( 'PB1' ) == PB1->PB1_FILIAL .AND. PB1->PB1_REGRA == M->PB0_REGRA
	      PB1->( RecLock( 'PB1', .F. ) )
	      PB1->( dbDelete() )
	      PB1->( MsUnLock() )
	      PB1->( dbSkip() )
	   End
	   
	   //+-------------------
	   //| Deleta o Cabecalho
	   //+-------------------
	   PB0->( RecLock( 'PB0' ) )
	   PB0->( dbDelete() )
	   PB0->( MsUnLock() )
	Endif	
Return

//-----------------------------------------------------------------------
// Rotina | A700VlIt   | Autor | Robson Gonçalves     | Data | 13/07/2016
//-----------------------------------------------------------------------
// Descr. | Criticar a linha digitada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A700VlIt()
	Local lRet := .T.
	Local nLoop := 0
	Local nP_CATEG := GdFieldPos( 'PB1_CATEG' )
	Local nP_CCUSTO := GdFieldPos( 'PB1_CCUSTO' )
	Local cReadVar := ReadVar()
	
	If     cReadVar == 'M->PB1_CATEG'  ; cConteudo := ( M->PB1_CATEG + oGride:aCOLS[ oGride:nAt, nP_CCUSTO ] )
	Elseif cReadVar == 'M->PB1_CCUSTO' ; cConteudo := ( oGride:aCOLS[ oGride:nAt, nP_CATEG ] + M->PB1_CCUSTO )
	Endif
	
	For nLoop := 1 To Len( oGride:aCOLS )
		If nLoop <> oGride:nAt
			If oGride:aCOLS[ nLoop, nP_CATEG ] + oGride:aCOLS[ nLoop, nP_CCUSTO ] == cConteudo
				MsgAlert('Na linha [' + LTrim( StrZero( nLoop, 4, 0 ) ) +'] já existe categoria e centro de custo para esta regra.','Atenção')
				lRet := .F.
				Exit
			Endif  
		Endif
	Next nLoop
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A700AtuSX3 | Autor | Robson Gonçalves     | Data | 13/07/2016
//-----------------------------------------------------------------------
// Descr. | Inserir validação em campos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A700AtuSX()
	Local cVar := ''
	
	SX3->( dbSetOrder( 2 ) )
	SX3->( dbSeek( 'PB1_CATEG' ) )
	
	If .NOT. ( 'U_A700VLIT' $ Upper( SX3->X3_VLDUSER ) )
		If .NOT. Empty( SX3->X3_VLDUSER )
			cVar := '(' + AllTrim( SX3->X3_VLDUSER ) + ')'
		Endif
		
		SX3->( RecLock( 'SX3', .F. ) )
		SX3->X3_VLDUSER := 'U_A700VLIT() .AND. ' + cVar 
		SX3->( MsUnLock() )
	Endif
	
	SX3->( dbSeek( 'PB1_CCUSTO' ) )
	
	If .NOT. ( 'U_A700VLIT' $ Upper( SX3->X3_VLDUSER ) )
		If .NOT. Empty( SX3->X3_VLDUSER )
			cVar := '(' + AllTrim( SX3->X3_VLDUSER ) + ')'
		Endif
		
		SX3->( RecLock( 'SX3', .F. ) )
		SX3->X3_VLDUSER := 'U_A700VLIT() .AND. ' + cVar 
		SX3->( MsUnLock() )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | UPD700     | Autor | Robson Gonçalves     | Data | 11/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD700()
	Local cModulo := 'TMK'
	Local bPrepar := {|| U_U611Ini() }
	Local nVersao := 1
	
	NGCriaUpd( cModulo, bPrepar, nVersao )
Return

//-----------------------------------------------------------------------
// Rotina | U700Ini    | Autor | Robson Gonçalves     | Data | 11/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U700Ini()
	aSIX := {}
	aSX2 := {}
	aSX3 := {}
	aSX7 := {}
	
	AAdd( aSX2, { "PB0","","REGRA CATEGORIA DE PRODUTO","REGRA CATEGORIA DE PRODUTO","REGRA CATEGORIA DE PRODUTO","E","","E","E" } )
	
	AAdd( aSX3, { "PB0","01","PB0_FILIAL","C",2,0,"Filial","Filial","Filial","Filial do Sistema","Filial do Sistema","Filial do Sistema","@!","","€€€€€€€€€€€€€€€","","",0,"þA","","","U","N","","","","","","","","","","","033","","","","","N","N","N","","" } )
	AAdd( aSX3, { "PB0","02","PB0_REGRA","C",6,0,"Cod.da Regra","Cod.da Regra","Cod.da Regra","Codigo da regra","Codigo da regra","Codigo da regra","@!","","€€€€€€€€€€€€€€ ","GetSXENum('PB0','PB0_REGRA')","",0,"þA","","","U","S","V","R","€","","","","","","","","","","","","","N","N","N","","" } )
	AAdd( aSX3, { "PB0","03","PB0_VIGDE","D",8,0,"Vigencia de","Vigencia de","Vigencia de","Vigencia de","Vigencia de","Vigencia de","","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","" } )
	AAdd( aSX3, { "PB0","04","PB0_VIGATE","D",8,0,"Vigencia ate","Vigencia ate","Vigencia ate","Vigencia ate","Vigencia ate","Vigencia ate","","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","A","R","€","(M->PB0_VIGATE>=M->PB0_VIGDE)","","","","","","","","","","","","N","N","N","","" } )
	
	AAdd( aSIX, { "PB0","1","PB0_FILIAL+PB0_REGRA","Regra","Regra","Regra","U","S" } )
	
	AAdd( aSX2, { "PB1","","ITEM DA REGRA CATEG. DE PROD.","ITEM DA REGRA CATEG. DE PROD.","ITEM DA REGRA CATEG. DE PROD.","E","","E","E" } )
	
	AAdd( aSX3, { "PB1","01","PB1_FILIAL","C",2,0,"Filial","Filial","Filial","Filial do Sistema","Filial do Sistema","Filial do Sistema","@!","","€€€€€€€€€€€€€€€","","",0,"þA","","","U","N","","","","","","","","","","","033","","","","","N","N","N","","" } )
	AAdd( aSX3, { "PB1","02","PB1_REGRA","C",6,0,"Cod.da Regra","Cod.da Regra","Cod.da Regra","Codigo da regra","Codigo da regra","Codigo da regra","@!","","€€€€€€€€€€€€€€€","","",0,"þA","","","U","N","V","R","","","","","","","","","","","","","","N","N","N","","" } )
	AAdd( aSX3, { "PB1","03","PB1_CATEG","C",6,0,"Categoria","Categoria","Categoria","Categoria do produto","Categoria do produto","Categoria do produto","@!","","€€€€€€€€€€€€€€ ","","ACU",0,"þA","","S","U","S","A","R","€","Vazio().Or. ExistCpo('ACU')","","","","","","","","","","","","N","N","N","","" } )
	AAdd( aSX3, { "PB1","04","PB1_DESCAT","C",30,0,"Descr.Categ.","Descr.Categ.","Descr.Categ.","Descr. da categoria","Descr. da categoria","Descr. da categoria","@!","","€€€€€€€€€€€€€€ ","Iif(INCLUI,'',Posicione('ACU',1,xFilial('ACU')+PB1->PB1_CATEG,'ACU_DESC'))","",0,"þA","","","U","S","V","V","","","","","","","","","","","","","","N","N","N","","" } )
	AAdd( aSX3, { "PB1","05","PB1_CCUSTO","C",9,0,"C.Custo","C.Custo","C.Custo","Centro de custo","Centro de custo","Centro de custo","@!","","€€€€€€€€€€€€€€ ","","CTT",0,"þA","","S","U","S","A","R","€","Vazio().Or.CTB105CC()","","","","","","","","","","","","N","N","N","","" } ) 
	AAdd( aSX3, { "PB1","06","PB1_DESCCC","C",40,0,"Descr.CCusto","Descr.CCusto","Descr.CCusto","Descr. do centro de custo","Descr. do centro de custo","Descr. do centro de custo","@!","","€€€€€€€€€€€€€€ ","Iif(INCLUI,'',Posicione('CTT',1,xFilial('CTT')+PB1->PB1_CCUSTO,'CTT_DESC01'))","",0,"þA","","","U","S","V","V","","","","","","","","","","","","","","N","N","N","","" } )
	AAdd( aSX3, { "PB1","07","PB1_PERC","N",6,2,"Percentual","Percentual","Percentual","Percentual","Percentual","Percentual","@R 999.99","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","A","R","€","Positivo() .And. (M->PB1_PERC <= 100)","","","","","","","","","","","","N","N","N","","" } )
	AAdd( aSX3, { "PB1","08","PB1_VIGDE","D",8,0,"Vigencia de","Vigencia de","Vigencia de","Vigencia de","Vigencia de","Vigencia de","","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","" } )
	AAdd( aSX3, { "PB1","09","PB1_VIGATE","D",8,0,"Vigencia ate","Vigencia ate","Vigencia ate","Vigencia ate","Vigencia ate","Vigencia ate","","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","A","R","€","M->PB1_VIGATE >= aCOLS[n,GdFieldPos('PB1_VIGDE')]","","","","","","","","","","","","N","N","N","","" } )
	
	AAdd( aSIX, { "PB1","1","PB1_FILIAL+PB1_REGRA+PB1_CATEG+PB1_CCUSTO","Regra + Categoria + C.Custo","Regra + Categoria + C.Custo","Regra + Categoria + C.Custo","U","S" } )
	
	AAdd( aSX7, { "PB1_CATEG","001","ACU->ACU_DESC","PB1_DESCAT","P","S","ACU",1,"xFilial('ACU') + M->PB1_CATEG","","U" } )
	AAdd( aSX7, { "PB1_CCUSTO","001","CTT->CTT_DESC01","PB1_DESCCC","P","S","CTT",1,"xFilial('CTT') + M->PB1_CCUSTO","","U" } )
Return