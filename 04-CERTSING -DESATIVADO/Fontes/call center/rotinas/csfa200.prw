//-----------------------------------------------------------------------
// Rotina | CSFA200    | Autor | Robson Gonçalves     | Data | 10.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para usuário selecionar como quer consultar.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'

User Function CSFA200()
	Local oWnd 	
	Local nOpc := 0
	Local cRet := ''
	Local cNomeCpo := ReadVar()
	
	Private cX6_VAR := 'MV_CATPROD'
	
	oWnd := GetWndDefault()
	
	A200CanUse()
	
	nOpc := Aviso('Localizar Produto',;
	              'Você pode buscar o código do produto pela tabela de produtos ou por categoria de produtos.',;
	              {'Produto','Categoria','Sair'},1,;
	              'Por código de produto ou por categoria de produto.')
	
	If nOpc == 1
		If ConPad1(,,,PadR('PRT',Len(SX3->X3_F3)),'SB1->B1_COD')
			cRet  := SB1->B1_COD
		Endif
	Elseif nOpc == 2
	  	cRet := A200Estrut()		
	Else
		cRet := &( ReadVar() )
	Endif

	If !Empty( cRet )
		&( cNomeCpo ) := cRet
		If oWnd <> NIL
			GetdRefresh()
		Endif
	Endif
Return(!Empty( cRet ))
	
//-----------------------------------------------------------------------
// Rotina | A200CanUse| Autor | Robson Gonçalves     | Data |  10.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para compatibilizar dicionário.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A200CanUSe()
	Local cXB_ALIAS := 'PRT200'

	SX3->( dbSetOrder( 2 ) )
	If SX3->( dbSeek( 'UD_PRODUTO' ) )
		If RTrim(SX3->X3_F3) == 'PRT'
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_F3 := cXB_ALIAS
			SX3->( MsUnLock() )
		Endif
	Endif
	
	If !ExisteSX6( cX6_VAR )
		CriarSX6( cX6_VAR, 'C', 'Número da categoria de produto pai do Televendas - CSFA200.prw', '500000' )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A200Estrut  | Autor | Robson Gonçalves    | Data | 10.07.2013
//-----------------------------------------------------------------------
// Descr. | Montagem da árvore de estrutura de categorias de produtos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A200Estrut()
	Local oDlg
	Local oTree
	
	Local nOpc := 0
	
	Local cB1_COD := ''
	Local cCategoria := ''
	Local cRetorno := ''
	
	Local aButton := {}
	
	cCategoria := GetMv( cX6_VAR )
	
	AAdd( aButton,{ 'PESQUISA'  ,{|| A200Pesq( @oTree ) },"Pesquisar","Pesquisa"} )
		
	DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 500,600 of oMainWnd PIXEL
		oDlg:lEscClose := .F.
		
		oTree := DbTree():New(1,10,100,100,oDlg,,,.T.)
		oTree:Align := CONTROL_ALIGN_ALLCLIENT
		oTree:blDblClick := {|| cRetorno := oTree:GetCargo(), Iif(Left(cRetorno,3)=='FIL',(nOpc:=1,oDlg:End()),NIL) }
		MsgRun("Aguarde, carregando os produtos...",cCadastro,{||  A200MTree( @oTree, cCategoria ) })
		
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| nOpc:=1, cRetorno:=oTree:GetCargo(), oDlg:End() },{||oDlg:End() },,aButton)
	
	If nOpc==1 .And. !Empty( cRetorno  )
		If Left( cRetorno, 3 ) == 'FIL'
			cB1_COD := SubStr( cRetorno, 4 )
			SB1->( dbSetOrder( 1 ) )
			If SB1->( dbSeek( xFilial( 'SB1' ) + cB1_COD ) )
				cB1_COD := SB1->B1_COD
			Else
				cB1_COD := Space( Len( SB1->B1_COD ) ) 
			Endif
		Endif
	Endif
Return(cB1_COD)

//-----------------------------------------------------------------------
// Rotina | A200MTree  | Autor | Robson Gonçalves     | Data | 10.07.2013
//-----------------------------------------------------------------------
// Descr. | Montagem dos nós.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A200MTree( oTree, cCategoria )
	Local nTamanho := 0
	
	Local lACU_MSBLQL := .F.
	Local lACV_MSBLQL := .F.
	Local lB1_MSBLQL := .F.
	
	Local cDescricao := ''
	Local cChave := ''
	Local cAux := ''
	Local cBmp1 := 'BPMSEDT3'
	Local cBmp2 := 'BPMSEDT4'
	
	lACU_MSBLQL := ACU->( FieldPos( 'ACU_MSBLQL' )>0 )
	lACV_MSBLQL := ACV->( FieldPos( 'ACV_MSBLQL' )>0 )
	lB1_MSBLQL	:= SB1->( FieldPos( 'B1_MSBLQL' )>0 )
	
	nTamanho := Len(SB1->B1_COD) + Len(SB1->B1_DESC) + Len('Produto - ') + Len(' - ')
	
	ACU->( dbSetOrder( 1 ) )
	ACU->( dbSeek( xFilial( 'ACU' ) + cCategoria ) )
	
	cDescricao := PadR( ACU->ACU_DESC, nTamanho, ' ' )
	cChave := 'PAI' + ACU->ACU_DESC
	oTree:AddTree( cDescricao, .T., cBmp1, cBmp1, , , cChave )
	
	ACU->( dbSetOrder( 2 ) )
	ACU->( dbSeek( xFilial( 'ACU' ) + cCategoria ) )
	While ! ACU->( EOF() ) .And. ACU->( ACU_FILIAL + ACU_CODPAI ) == xFilial( 'ACU' ) + cCategoria
		If lACU_MSBLQL
			If ACU->ACU_MSBLQL == '1'
				ACU->( dbSkip() )
				Loop
			Endif
		Endif
		
		cDescricao := PadR( ACU->ACU_DESC, nTamanho, ' ' )
		cChave := 'PAI' + ACU->ACU_DESC
		oTree:AddTree( cDescricao, .T., cBmp1, cBmp1, , , cChave )
		
		If Empty( cAux )
			cAux := cChave
		Endif
		
		ACV->( dbSetOrder( 1 ) )
		ACV->( dbSeek( xFilial( 'ACV' ) + ACU->ACU_COD ) )
		While ! ACV->( EOF() ) .And. ACV->( ACV_FILIAL + ACV_CATEGO ) == xFilial( 'ACV' ) + ACU->ACU_COD
			If lACV_MSBLQL
				If ACV->ACV_MSBLQL == '1'
					ACV->( dbSkip() )
					Loop
				Endif
			Endif
			
			SB1->( dbSetOrder( 1 ) )
			SB1->( dbSeek( xFilial( 'SB1' ) + ACV->ACV_CODPRO ) )
			If lB1_MSBLQL
				If SB1->B1_MSBLQL == '1'
					ACV->( dbSkip() )
					Loop
				Endif			
			Endif
			
			cDescricao := 'Produto - ' + SB1->B1_COD + ' - ' + SB1->B1_DESC
			cDescricao := PadR( cDescricao, nTamanho, ' ' )
			cChave := 'FIL' + SB1->B1_COD
			
			oTree:AddTreeItem( cDescricao, cBmp2, , cChave )
			
			ACV->( dbSkip() )
		End
		oTree:EndTree()
		ACU->( dbSkip() )
	End
	
	oTree:TreeSeek( cAux )
Return

//-----------------------------------------------------------------------
// Rotina | A200Pesq   | Autor | Robson Gonçalves     | Data | 12.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para pesquisar produtos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A200Pesq( oTree )
	Local oDlgPesq
	Local oOrdem
	Local oChave 
	Local oBtOk
	Local oBtCan
	
	Local cOrdem := ''
	Local cTitulo := 'Pesquisar'
	Local cChave := Space(50)
	
	Local aOrdens := {}

	Local nP := 0
	Local nOrdem := 1
	Local nOpcao := 0

	aOrdens := {'Código do produto'}
	
	DEFINE MSDIALOG oDlgPesq TITLE cTitulo FROM 00,00 TO 78,500 PIXEL
		@ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
		@ 021, 005 MSGET oChave VAR cChave F3 'PRT' SIZE 210,08 OF oDlgPesq PIXEL
	
		DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
		DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	ACTIVATE MSDIALOG oDlgPesq CENTER
	
	If nOpcao == 1
		cChave := Upper( AllTrim( cChave ) )
		If !oTree:TreeSeek( 'FIL' + cChave )
			MsgAlert( 'Busca não localizada', cTitulo )
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | UPD200     | Autor | Robson Gonçalves     | Data | 10.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de update p/ criar as estruturas no dicionário dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD200()
	Local cModulo := "TMK"
	Local bPrepar := {|| U_U200Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//-----------------------------------------------------------------------
// Rotina | U200Ini    | Autor | Robson Gonçalves     | Data | 10.07.2013
//-----------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U200Ini()
	Local cXB_ALIAS := 'PRT200'

	AAdd( aSXB, { cXB_ALIAS ,"1","01","RE","Cat.Produtos","Cat.Produtos","Cat.Produtos","ACU"})
	AAdd( aSXB, { cXB_ALIAS ,"2","01","01","Cat.Produtos","Cat.Produtos","Cat.Produtos","U_CSFA200()"})
	AAdd( aSXB, { cXB_ALIAS ,"5","01","","","","","SB1->B1_COD"})

Return(.T.)