#INCLUDE 'Protheus.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'FWMVCDEF.CH' // Obrigatorio esse include para MVC

#DEFINE TYPE_MODEL	1
#DEFINE TYPE_VIEW  	2

Static aDocsNPrev	:= {}
Static aTitMark		:= {}
Static cAliasT		:= ''
Static cMV_440ASSU  := ''
Static c440Operador := ''
Static nREGISTROS := 0
//---------------------------------------------------------------------------------
// Rotina | CSFA441     | Autor | Rafael Beghini              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina de Telecobrança em MVC - Oriunda CSFA440
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSFA441()
    Local oBrowse
	Private cCadastro	:= 'Telecobrança Certisign'
	If A440PodeUsar()	
		oBrowse := FwmBrowse():NEW() 
		oBrowse:SetAlias("SA1")
		oBrowse:SetDescription(cCadastro)
		IF GetMv( 'MV_441LEG', .F. ) == '1'
			oBrowse:AddLegend( " U_A441Leg() == '0' ", "NGBIOALERTA_02.PNG", "CLIENTE SEM PENDÊNCIA"		)
			oBrowse:AddLegend( " U_A441Leg() == '1' ", "NGBIOALERTA_01.PNG", "NECESSÁRIO EFETUAR COBRANÇA"	)
		EndIF
		oBrowse:Activate() // Ativando a classe obrigatorio
	EndIF
Return( NIL )
//---------------------------------------------------------------------------------------------

Static Function MenuDef()
	Local aBotao := {}
	aAdd(aBotao,{ "Análise"			, "VIEWDEF.CSFA441"	, 0, 4, 0, NIL } )
	aAdd(aBotao,{ "Rel. Histórico"	, "U_A441Imp()"		, 0, 9, 0, NIL } )	
Return aBotao
//-------------------------------------------------------------------

Static Function ModelDef()
    Local oModel    := NIL
    Local oStruCab  := NIL
    Local oStruGrd  := NIL
	Local bPost		:= {|| PosVldMdl( oModel ) }
	Local bCommit	:= {|| fGrava(oModel) }
	Local bLoad		:= {|oMdl| cAliasT := GetNextAlias(), A441Titulos() , A441LdGrd(oMdl) }
	
    //-- Cria a primeira estrutura - Dados do cliente
    oStruCab    := FWFormStruct(1,'SA1')

    //-- Cria a segunda estrutura (Grid) Títulos
    oStruGrd    := A441StrGd(TYPE_MODEL)

	oModel		:= MPFormModel():New( "TMPSA1CRD", /*bPre*/ , bPost, bCommit, /*bCancel*/ )

    //-- Adiciona Objetos Criados à Model
	oModel:AddFields('MdFieldCab',,oStruCab)
	
	//-- Sintaxe:
	//--  :AddGrid(< cId >    , < cOwner > , < oModelStruct >, < bLinePre >, < bLinePost >, < bPre >, < bLinePost >, < bLoad >)
	oModel:AddGrid('MdGridTRB','MdFieldCab', oStruGrd        ,             ,              ,         ,              , bLoad )

    //-- Seta Descrição Para Cada Divisão Da Model
	oModel:GetModel('MdFieldCab' ):SetDescription('STR0004')
	oModel:GetModel('MdGridTRB'):SetDescription('STR0005')
	oModel:SetDescription('Telecobrança - Certisign')
	
	//-- Adiciona Restrições Aos Objetos Da Model
	oModel:GetModel( 'MdGridTRB' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'MdGridTRB' ):SetNoDeleteLine( .T. )
	oModel:GetModel( 'MdGridTRB' ):SetOptional( .T. )
	
	//-- Seta Chave Primária Da Model
	oModel:SetPrimaryKey({"MRK_ALL"})  
	
	//-- Ativação Da Model
	oModel:SetActivate( )	

Return(oModel)

//-------------------------------------------------------------------

Static Function ViewDef()
    Local oView   	:= NIL		// Recebe o objeto da View
	Local oModel  	:= NIL		// Objeto do Model
	Local oStruCab 	:= NIL   	// Recebe a Estrutura cabecalho
	Local oStruGrd 	:= NIL  	// Recebe a Estrutura
	
    oModel  := ModelDef()

    //-- Cria Primeira Estrutura (Field) Na Parte Superior Da Tela
    oStruCab := FWFormStruct(2, 'SA1')

    //-- Cria Segunda Estrutura (Grid) Na Parte Central Da Tela
	oStruGrd := A441StrGd(TYPE_VIEW)

	//-- Cria o objeto de View
	oView := FwFormView():New()

    //-- Define qual o Modelo de dados será utilizado na View
	oView:SetModel(oModel)

    //-- Alteração de propriedades do campo
	oStruGrd:SetProperty( '*' 			, MVC_VIEW_CANCHANGE,.F.) //-- Bloqueia Todos Os Campos Da Grid
	oStruGrd:SetProperty( 'TRB_MARK' 	, MVC_VIEW_CANCHANGE,.T.) //-- Habilita Somente o Campo Mark Da Grid
	oStruGrd:SetProperty( 'E1_VENCTO' 	, MVC_VIEW_CANCHANGE,.T.) //-- Habilita Somente o Campo Vencimento Da Grid
	oStruGrd:SetProperty( 'E1_HIST' 	, MVC_VIEW_CANCHANGE,.T.) //-- Habilita Somente o Campo Vencimento Da Grid

	
    //-- Adiciona botões
    oView:AddUserButton( 'Marcar todos (F6)'			, 'CLIPS', { |oView| A441Mrk( oView ) 	}, , 117 ) //-- VK_F6
    oView:AddUserButton( 'Registrar Cobrança (F7)'		, 'CLIPS', { |oView| A441Tela()			}, , 118 ) //-- VK_F7
    oView:AddUserButton( 'Posição Cliente (F8)'			, 'CLIPS', { |oView| Finc010( 2 )		}, , 119 ) //-- VK_F8
    oView:AddUserButton( 'Rel. Histórico Cobrança (F9)'	, 'CLIPS', { |oView| A440Relat('1')		}, , 120 ) //-- VK_F9
    oView:AddUserButton( 'Inadimplentes (F10)'			, 'CLIPS', { |oView| A440Inadim()		}, , 121 ) //-- VK_F10
    
    //-- Adiciona Os Objetos Criados à View
	oView:AddField('VwFieldCab', oStruCab , 'MdFieldCab') 
	oView:AddGrid('VwGridTRB'  , oStruGrd , 'MdGridTRB' )
		
	//-- Dimensiona a Tela Da View
	oView:CreateHorizontalBox('CABECALHO' ,50)
	oView:CreateHorizontalBox('GRID'	  ,50)
	
    oView:EnableTitleView( 'VwFieldCab',"Dados do cliente" )
	
    //-- Seta Os Objetos para Cada Dimensão Criada
    oView:SetOwnerView('VwFieldCab','CABECALHO')
    oView:SetOwnerView('VwGridTRB' ,'GRID'     )
    
    oView:EnableTitleView( 'VwGridTRB', 'Títulos para cobrança' )
    
	//-- Não Permite Abertura Da Tela De "Salvar Dados Do Formulário"
	oView:SetViewAction("ASKONCANCELSHOW",{||.F.})

Return(oView)

//-------------------------------------------------------------------
/*/{Protheus.doc} PosVldMdl
PosValid para montar array com retorno dos documentos marcados
/*/
//-------------------------------------------------------------------
Static Function PosVldMdl(oModel)

    Local oModelGrid    := Nil
    Local nCount        := 0
    Local nTamGrid      := 0    

    Default oModel:= FwLoadModel( "TMPSA1CRD" )

    oModelGrid	:= oModel:GetModel( 'MdGridTRB' )
    nTamGrid    := oModelGrid:Length()
    
    //--Monta array com o RECNO dos Documentos que foram marcados.
    
    For nCount:= 1 To nTamGrid
    
        oModelGrid:GoLine(nCount)

        If oModel:GetValue( 'MdGridTRB' , 'TRB_MARK' ) 
            AADD(aDocsNPrev , oModel:GetValue( 'MdGridTRB' , 'RECNO' ) )            
        EndIf                

    Next nCount

Return .T.

//--------------------------------------------------------------------------------------------------------
Static Function A441StrGd(nType)

	Local oStruct   := Nil
	Local nX        := 0
	Local aDadosCpo := {}
	Local aCampos   := {}

	Default nType   := TYPE_MODEL  // 1=Tipo Model / 2= Tipo View
	
	//-- Carrega Vetor De Campos Da Grid
	aAdd( aCampos, 'E1_PREFIXO' )
    aAdd( aCampos, 'E1_NUM' 	)
    aAdd( aCampos, 'E1_PARCELA' )
	aAdd( aCampos, 'E1_TIPO' 	)
	aAdd( aCampos, 'E1_NATUREZ' )
    aAdd( aCampos, 'E1_EMISSAO' )
    aAdd( aCampos, 'E1_VENCTO'  )
    aAdd( aCampos, 'E1_VENCREA' )
    aAdd( aCampos, 'E1_VALOR'   )
    aAdd( aCampos, 'E1_SALDO'   )
    aAdd( aCampos, 'E1_ORIGPV'  )
    aAdd( aCampos, 'E1_HIST'    )
    
	IF nType == TYPE_MODEL

		//-- Executa o Método Construtor Da Classe.
		oStruct := FWFormModelStruct():New()

		//-- Check Box De Marcação Da Linha Da Grid
		oStruct:AddField(	'' ,;													//-- [01] C Titulo do campo
							'' ,; 													//-- [02] C ToolTip do campo
							'TRB_MARK' ,;											//-- [03] C identificador (ID) do Field
							'L' ,; 												    //-- [04] C Tipo do campo
							1 ,; 													//-- [05] N Tamanho do campo
							0 ,;													//-- [06] N Decimal do campo
							Nil ,;					 								//-- [07] B Code-block de validação do campo      //-- {|| T146MrkDoc() }
							Nil ,;													//-- [08] B Code-block de validação When do campo //-- {|| TMA146VDoc(FwFldGet('T01_SERTMS'),'D') }
							NIL ,; 												    //-- [09] A Lista de valores permitido do campo
							NIL ,; 												    //-- [10] L Indica se o campo tem preenchimento obrigatório
							NIL ,; 												    //-- [11] B Code-block de inicializacao do campo
							NIL ,; 											    	//-- [12] L Indica se trata de um campo chave
							NIL ,; 										    		//-- [13] L Indica se o campo pode receber valor em uma operação de update.
							.T.  ) 									    			//-- [14] L Indica se o campo é virtual

        //-- Check Box De Marcação Da Linha Da Grid
        oStruct:AddField(	'' ,;													//-- [01] C Titulo do campo
							'' ,; 													//-- [02] C ToolTip do campo
							'RECNO' ,;  											//-- [03] C identificador (ID) do Field
							'N' ,; 		    										//-- [04] C Tipo do campo
							1 ,; 													//-- [05] N Tamanho do campo
							0 ,;													//-- [06] N Decimal do campo
							Nil ,;					 								//-- [07] B Code-block de validação do campo      //-- {|| T146MrkDoc() }
							Nil ,;													//-- [08] B Code-block de validação When do campo //-- {|| TMA146VDoc(FwFldGet('T01_SERTMS'),'D') }
							NIL ,; 			    									//-- [09] A Lista de valores permitido do campo
							NIL ,; 				    								//-- [10] L Indica se o campo tem preenchimento obrigatório
							NIL ,; 					    							//-- [11] B Code-block de inicializacao do campo
							NIL ,; 						    						//-- [12] L Indica se trata de um campo chave
							NIL ,; 							    					//-- [13] L Indica se o campo pode receber valor em uma operação de update.
							.T.  ) 								    				//-- [14] L Indica se o campo é virtual

		//-- Inclui Campos Constantes Na Query Principal ( Somente Campos Existentes No Dicionário ).
		For nX := 1 To Len(aCampos)

			If SubStr(aCampos[nX],1,3) <> 'RECNO'

				aDadosCpo:= TMSX3Cpo( aCampos[nX] )
				If Empty(aDadosCpo) .Or. Len(aDadosCpo) < 6
					ConOut( FunName() + "Erro No Campo: " + aCampos[nX] )
				Else
					oStruct:AddField(aDadosCpo[1],aDadosCpo[2],aCampos[nX],aDadosCpo[6],aDadosCpo[3],aDadosCpo[4])
				EndIf	

			EndIf

		Next nX
		//-- Gatilho
		oStruct:AddTrigger( 'E1_VENCTO', 'E1_VENCREA', {|| .T. }, {|| A441Trigger() } )

	Else

		oStruct := FWFormViewStruct():New()

		oStruct:AddField( 'TRB_MARK',;		// [01] C Nome do Campo
							'01',;				// [02] C Ordem
							'' ,;				// [03] C Titulo do campo
							'' ,;				// [04] C Descrição do campo
							{} ,;				// [05] A Array com Help
							'L',;				// [06] C Tipo do campo
							'@BMP',;			// [07] C Picture
							NIL,;				// [08] B Bloco de Picture Var
							NIL,;				// [09] C Consulta F3
							.T.,;				// [10] L Indica se o campo é editável
							NIL,;				// [11] C Pasta do campo
							NIL,;				// [12] C Agrupamento do campo
							NIL,;				// [13] A Lista de valores permitido do campo (Combo)
							NIL,;				// [14] N Tamanho Maximo da maior opção do combo
							NIL,;				// [15] C Inicializador de Browse
							.T.,;				// [16] L Indica se o campo é virtual
							Nil )				// [17] C Picture Variável

		For nX := 1 To Len(aCampos)
			If SubStr(aCampos[nX],1,3) <> 'REC'
				
				aDadosCpo:= TMSX3Cpo( aCampos[nX] )
				If Empty(aDadosCpo) .Or. Len(aDadosCpo) < 4
					ConOut( FunName() + " Erro No Campo: " + aCampos[nX] )
				Else
					oStruct:AddField(aCampos[nX],StrZero((nX + 2 ),2),aDadosCpo[1],aDadosCpo[2],{""},aDadosCpo[6],aDadosCpo[5],Nil,Nil,.F.,Nil)					
				EndIf						
			EndIf		
		Next nX
	EndIF

Return(oStruct)

//-------------------------------------------------------------------
/*/{Protheus.doc} A441Mrk
Atualiza os marks das linhas.
@author Rafael Beghini
@since  Setembro/2019
@version P12
/*/
//-------------------------------------------------------------------
Static Function A441Mrk( oView )

	Local aArea		    := GetArea()
	Local oModel	 	:= FWModelActive()	//-- Captura Model Ativa
	Local aSaveLines	:= FWSaveRows()		//-- Captura Posicionamento Da Grid
	Local lMarked		:= .F.	
	Local oModelGrid	:= oModel:GetModel( 'MdGridTRB' )
	Local nI 			:= 0
	
	//-- Define Se a Linha Posicionada Está Marcada Ou Desmarcada
	oModelGrid:GoLine( 1 )
	lMarked := oModelGrid:GetValue( 'TRB_MARK' )

    //-- Executa Loop Em Toda a Grid
    For nI := 1 To oModelGrid:Length()
    
        //-- Posiciona Na Linha Da Grid Conforme o Cursor
        oModelGrid:GoLine( nI )
        
        //-- Marca Ou Desmarca
        oModel:SetValue( 'MdGridTRB' , 'TRB_MARK' , Iif(lMarked,.T.,.F.) )
        
    Next		
    
    //-- Dá Refresh na View De Grid Para Atualizar Dados Na Tela
    oView:Refresh('VwGridTRB')
    	
	//-- Força Posicionamento De Linha Pois o RECNO da Grid Está Zerado
	oModelGrid:GoLine( 1 )

	//-- Atualiza Grid Para o Posicionamento Correto
	oView:Refresh('VwGridTRB')

	//-- Reposiciona na Linha Original Da Grid
	FWRestRows( aSaveLines )

	RestArea(aArea)

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} A441Titulos
Função Para Execução da Query Que Será Enviada Para o Grid Da Tela Por
Meio da Função FWLoadByAlias
@author Rafael Beghini
@since  Setembro/2019
@version P12
/*/
//-------------------------------------------------------------------
Static Function A441Titulos()
	Local aArea      := GetArea()
	Local bQuery     := {||}
	Local aStruQry   := {}
	Local nLinha     := 0
    Local cSQL := ''
	Local cTRB := ''
		
	bQuery := {|| Iif( Select(cAliasT) > 0, (cAliasT)->( dbCloseArea() ), Nil ) ,;
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cAliasT,.F.,.T.) ,;
					dbSelectArea(cAliasT) ,;
					(cAliasT)->( dbGoTop() ) }

	cSQL := "SELECT   "
	cSQL += "         SE1.R_E_C_N_O_ AS RECNO, "
	cSQL += "         E1_PREFIXO, "
	cSQL += "         E1_NUM, "
	cSQL += "         E1_PARCELA, "
	cSQL += "         E1_TIPO, "
	cSQL += "         E1_NATUREZ, "
	cSQL += "         E1_EMISSAO, "
	cSQL += "         E1_VENCTO, "
	cSQL += "         E1_VENCREA, "
	cSQL += "         E1_VALOR, "
	cSQL += "         E1_SALDO, "
	cSQL += "         TRIM(X5_DESCRI) AS E1_ORIGPV, "
	cSQL += "         E1_HIST "
	cSQL += "FROM   " + RetSqlName( 'SE1' ) + " SE1 "
	cSQL += "         LEFT JOIN " + RetSqlName( 'SA1' ) + " SA1 "
	cSQL += "               ON A1_FILIAL = '" + FwxFilial("SA1") + "' " 
	cSQL += "               AND A1_COD = E1_CLIENTE "
	cSQL += "               AND A1_LOJA = E1_LOJA "
	cSQL += "               AND SA1.D_E_L_E_T_ = ' ' "
	cSQL += "         LEFT JOIN " + RetSqlName( 'SX5' ) + " SX5 "
	cSQL += "               ON X5_FILIAL = ' '" 
	cSQL += "               AND X5_TABELA = 'Z4' "
	cSQL += "               AND X5_CHAVE = E1_ORIGPV "
	cSQL += "               AND SX5.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE    SE1.E1_FILIAL = '" + FwxFilial("SE1") + "' " 
	cSQL += " AND SE1.E1_CLIENTE = '" + SA1->A1_COD  + "' " 
	cSQL += " AND SE1.E1_LOJA    = '" + SA1->A1_LOJA + "' " 
	
	cSQL += "         AND SE1.E1_SALDO > 0 "
	cSQL += "         AND ( SE1.E1_TIPO = 'CH ' OR SE1.E1_TIPO = 'DP ' OR SE1.E1_TIPO = 'FT ' OR SE1.E1_TIPO = 'NF ' OR SE1.E1_TIPO = 'NDC' ) "
	cSQL += "         AND SE1.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO "
	
	cSQL := ChangeQuery( cSQL )
	
	FwMsgRun(, {|| Eval(bQuery) }, , 'Aguarde, consultando os dados do cliente...')
	
	//-- Formata Campos Da Query
	aStruQry := (cAliasT)->(DbStruct())
	
	For nLinha := 1 To Len(aStruQry)
		DbSelectArea('SX3')
		DbSetOrder(2)
		If MsSeek(aStruQry[nLinha][1],.f.)
		If SX3->X3_TIPO == "D" .Or. SX3->X3_TIPO == "N"
			TCSetField( cAliasT , aStruQry[nLinha][1], SX3->X3_TIPO , SX3->X3_TAMANHO , SX3->X3_DECIMAL )
		Endif
		EndIf
	Next nLinha	

	RestArea(aArea)

Return cAliasT

//-------------------------------------------------------------------
/*/{Protheus.doc} A441Titulos
Função Para Execução da Query Que Será Enviada Para o Grid Da Tela Por
Meio da Função FWLoadByAlias
@author Rafael Beghini
@since  Setembro/2019
@version P12
/*/
//-------------------------------------------------------------------
Static Function A441LdGrd( oMdl )
	Local aRet := {}

	Default oMdl := FwLoadModel('TMPSA1CRD')	
		
	// Como tem o campo R_E_C_N_O_, nao é preciso informar qual o campo contem o Recno() real
	FwMsgRun(, {|| aRet := FWLoadByAlias( oMdl , cAliasT , 'SE1' , Nil , Nil , .t. )  }, , 'Aguarde, consultando os dados do cliente...')

	//-- Fecha Arquivo Temporário
	If Select(cAliasT) > 0
		(cAliasT)->(DbCloseArea())
	EndIf	

Return( aRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} fGrava
Função para o Commit
@author Rafael Beghini
@since  Setembro/2019
@version P12
/*/
//-------------------------------------------------------------------
Static Function fGrava(oModel)
	Local lRet	 := .T.
	Local nI	 := 0
	Local nRECNO := 0
	Local oModelGrid	:= oModel:GetModel( 'MdGridTRB' )

	Begin Transaction
		If FwFormCommit(oModel)
			If oModel:GetOperation() == MODEL_OPERATION_UPDATE //MODEL_OPERATION_INSERT // MODEL_OPERATION_UPDATE | MODEL_OPERATION_DELETE
				ConfirmSX8()
			EndIf
		Else
			If oModel:GetOperation() == MODEL_OPERATION_UPDATE //MODEL_OPERATION_INSERT // MODEL_OPERATION_UPDATE | MODEL_OPERATION_DELETE
				RollBackSX8()
			EndIf
			Help(,,"Atenção !!!",,"Problema na gravação dos dados",1,0)
			lRet := .F.
			DisarmTransaction()
		EndIf

		For nI := 1 To oModelGrid:Length()
			//-- Posiciona Na Linha Da Grid Conforme o Cursor
			oModelGrid:GoLine( nI )
			nRECNO := oModel:GetValue( 'MdGridTRB' , 'RECNO' )
			SE1->( dbGoto(nRECNO) )

			//-- Verifico se foi marcado o título
			IF oModel:GetValue( 'MdGridTRB' , 'TRB_MARK' ) .AND. ( oModel:GetValue( 'MdGridTRB' , 'E1_VENCTO' ) <> SE1->E1_VENCTO .OR.;
				oModel:GetValue( 'MdGridTRB' , 'E1_HIST' ) <> SE1->E1_HIST )
				SE1->( RecLock('SE1',.F.) )
				SE1->E1_VENCTO  := oModel:GetValue( 'MdGridTRB' , 'E1_VENCTO'  )
				SE1->E1_VENCREA := oModel:GetValue( 'MdGridTRB' , 'E1_VENCREA' )
				SE1->E1_HIST    := oModel:GetValue( 'MdGridTRB' , 'E1_HIST'    )
				SE1->( MsUnLock() )
			EndIF
    	Next

	End Transaction 
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} A441Tela
Função apresentar a tela de registrar a cobrança.
@author Rafael Beghini
@since  Setembro/2019
@version P12
/*/
//-------------------------------------------------------------------
Static Function A441Tela()
	Local oModel	 	:= FWModelActive()	//-- Captura Model Ativa
	Local oModelGrid	:= oModel:GetModel( 'MdGridTRB' )
	Local nTotal		:= 0
	Local oDlg
	Local oPnlAll
	Local oPnlBot
	Local oScroll
	Local oCliente
	Local oGravar
	Local oSair
	Local oGride
	Local oPnlGrd
	Local oTMultiGet
	Local oInadimp
	Local oPosFin
	Local lTudOk	:= .F.
	Local lGrv		:= .F.

	Private a440SU5 := {}
	
	Private cACF_PREVIS := ''
	Private dACF_PREVIS := Ctod( Space( 8 ) )
	Private cACF_MOTIVO := Space( Len( ACF->ACF_MOTIVO ) )
	Private cACF_DESCMO := Space( Posicione( 'SX3', 2, 'ACF_DESCMO', 'X3_TAMANHO' ) ) 
	Private cACF_OBS := CriaVar( 'ACF_OBS', .F. )
	Private cU5_CODCONT := Space( Len( SU5->U5_CODCONT ) )
	Private cU5_CONTAT := Space( Len( SU5->U5_CONTAT ) )
	
	aTitMark := {}
	
	For nI := 1 To oModelGrid:Length()
        //-- Posiciona Na Linha Da Grid Conforme o Cursor
        oModelGrid:GoLine( nI )
        //-- Verifico se foi marcado o título
        IF oModel:GetValue( 'MdGridTRB' , 'TRB_MARK' )
			aADD( aTitMark, { oModel:GetValue( 'MdGridTRB' , 'RECNO' ), SA1->A1_COD } )
			nTotal += oModel:GetValue( 'MdGridTRB' , 'E1_VALOR' )
		EndIF
    Next		
	IF Empty( aTitMark )
		MsgAlert('Selecione no mínimo um título',cCadastro)
		Return
	EndIF

	// Rotina para verificar se há contato no cadastro de clientes.
	A440HaCont()

	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd FROM 0,0 TO 260,630 PIXEL STYLE DS_MODALFRAME STATUS
		
		@  2, 3 SAY 'Contato' COLOR CLR_HBLUE SIZE 50,8 PIXEL OF oDlg
		@ 10, 3 MSGET cU5_CODCONT F3 '440SU5' PICTURE '@!'  SIZE 30,8 PIXEL OF oDlg

		@  2, 38 SAY 'Nome e telefone do contato' SIZE 90,8 PIXEL OF oDlg
		@ 10, 38 MSGET cU5_CONTAT /*PICTURE '@!'*/ WHEN .F. SIZE 272,8 PIXEL OF oDlg

		@ 22, 3 SAY 'Motivo' COLOR CLR_HBLUE SIZE 50,8 PIXEL OF oDlg
		@ 30, 3 MSGET cACF_MOTIVO PICTURE '@!' F3 '440SU9' VALID A440Motivo(0,cACF_MOTIVO,@cACF_DESCMO) SIZE 30,8 PIXEL OF oDlg
		
		@ 50, 260 SAY 'Previsão pagto.' COLOR CLR_HBLUE SIZE 50,8 PIXEL OF oDlg
		@ 60, 260 MSGET dACF_PREVIS PICTURE '99/99/9999' SIZE 50,8 PIXEL OF oDlg

		@ 42, 3 SAY 'Observação' COLOR CLR_HBLUE SIZE 50,8 PIXEL OF oDlg
		oTMultiGet := TMultiGet():New( 50, 3, {| u | Iif( PCount() > 0, cACF_OBS := u, cACF_OBS ) }, oDlg, 250, 50,,,,,,.T.)
		
		@ 22, 38 SAY 'Descrição do motivo' SIZE 50,8 PIXEL OF oDlg
		@ 30, 38 MSGET cACF_DESCMO PICTURE '@!' WHEN .F. SIZE 272,8 PIXEL OF oDlg

		@ 75, 260 SAY 'Total selecionado' SIZE 50,8 PIXEL OF oDlg
		@ 85, 260 MSGET oTotal VAR nTotal PICTURE '@E 999,999,999.99' WHEN .F. SIZE 50,8 PIXEL OF oDlg
		
		@ 110, 2 BUTTON oGravar  PROMPT 'Gravar'  SIZE 40,11 PIXEL OF oDlg ACTION ;
		( lTudOK := A440Contato( cU5_CODCONT ) .AND. A440Motivo( 1, cACF_MOTIVO, @cACF_DESCMO, nTotal ) .AND. A440Previsao( dACF_PREVIS ) .AND. A440Obs( cACF_OBS, cACF_MOTIVO ), ;
		Iif( lTudOK, Iif( MsgYesNo('Confirma a gravação dos dados',cCadastro), ( ( lGrv:=.T. ) ,oDlg:End() ), NIL), NIL ) )

		@ 110, 44 BUTTON oSair    PROMPT 'Sair'          SIZE 40,11 PIXEL OF oDlg ACTION (oDlg:End())

		@ 115, 270 SAY '#developedbyTSM' SIZE 60,7 PIXEL OF oDlg
		
	ACTIVATE MSDIALOG oDlg CENTERED
	If lTudOk .AND. lGrv
		Begin Transaction
			Processa( {|| A440Gravar() }, cCadastro,, .F. )
		End Transaction
		MsgInfo('Operação concluída.', cCadastro )
	Endif
	oModelGrid:GoLine( 1 )
Return

//---------------------------------------------------------------------------------
// Rotina | A440HaCont  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para verificar se o contato do cadastro de cliente já possui o
//        | relacionamento do cadastro de contato com o cadastro de clientes.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440HaCont()
	Local lContinua := .T.
	Local lA1_CONTFIN := .F.
	Local lA1_CONTATO := .F.
	Local aRet := {}
	Local aPar := {}
	Local nTentativa := 0
	
	// Posicionar no cliente.
	SA1->( dbSetOrder( 1 ) )
	SA1->( dbSeek( xFilial( 'SA1' ) + aTitMark[ 1, 2 ] ) )
	
	// Possui integração SA1 com SU5? Então capturar os dados.
	If .NOT. Empty( SA1->A1_CONTFIN )
		cU5_CODCONT := RTrim( Left( SA1->A1_CONTFIN, 6 ) )	
		SU5->( dbSetOrder( 1 ) ) 
		If SU5->( dbSeek( xFilial( 'SU5' ) + cU5_CODCONT ) )
			lA1_CONTFIN := .T.
			// Atribuir os dados do contato a variável.
			A440Atrib(0)
		Endif
	Endif
	
	// Se não possuir integração SA1 com SU5, tentar fazer a integração.
	If .NOT. lA1_CONTFIN	
		If .NOT. Empty( SA1->A1_CONTATO ) .AND. .NOT. Empty( SA1->A1_TEL ) .AND. .NOT. Empty( SA1->A1_EMAIL )
			lA1_CONTATO := .T.
			// Gerar o contato e sua relação com o SA1.
			A440GeraCont()
			// Atribuir os dados do contato a variável.
			A440Atrib(0)
		Endif
	Endif
	
	// Se não possuir integração SA1 com SU5 e não conseguir fazer a integração, então solicitar para o usuário os dados.
	If .NOT. lA1_CONTFIN .AND. .NOT. lA1_CONTATO
		SX3->( dbSetOrder( 2 ) )
		SX3->( dbSeek( 'A1_CONTATO' ) ) ; AAdd( aPar, { 1, RTrim(SX3->X3_TITULO), SA1->A1_CONTATO, '@!', '', '', '', 120, .T. } )
		SX3->( dbSeek( 'A1_DDD' ) )     ; AAdd( aPar, { 1, RTrim(SX3->X3_TITULO), SA1->A1_DDD    , '@!', '', '', '', 030, .T. } )
		SX3->( dbSeek( 'A1_TEL' ) )     ; AAdd( aPar, { 1, RTrim(SX3->X3_TITULO), SA1->A1_TEL    , '@!', '', '', '', 060, .T. } )
		SX3->( dbSeek( 'A1_EMAIL' ) )   ; AAdd( aPar, { 1, RTrim(SX3->X3_TITULO), SA1->A1_EMAIL  , ''  , '', '', '', 120, .T. } )
		
		While lContinua .AND. nTentativa < 3
			nTentativa++
			If ParamBox( aPar, 'Informe/complete os dados para prosseguir', @aRet )
				lContinua := .F.
				// Gerar o contato e sua relação com o SA1.
				A440GeraCont( aRet )
				// Atribuir os dados do contato a variável.
				A440Atrib(0)
			Else
				MsgInfo('Para prosseguir com o Telecobrança é obrigatório possuir contato.',cCadastro)
			Endif
		End
		If lContinua
			MsgAlert('Para registrar o atendimento do Telecobrança será preciso informar um contato existente.',cCadastro)
		Endif
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440Atrib   | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para atribuir dados a variável da interface.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Atrib( nPos )
   Local cDDD := ''
   Local cFone := ''
   Local cFCom1 := ''
   Local cCelular := ''
   Local cOutros := ''
	Local cEmail := ''
	
	DEFAULT nPos := 0
	
	If nPos==0
		cDDD     := Iif( Empty( SU5->U5_DDD )    , '', '- DDD '       + RTrim( SU5->U5_DDD ) )
		cFone    := Iif( Empty( SU5->U5_FONE )   , '', '- Tel.Res. '  + RTrim( SU5->U5_FONE ) )
		cFCom1   := Iif( Empty( SU5->U5_FCOM1 )  , '', '- Tel.Com.1 ' + RTrim( SU5->U5_FCOM1 ) )
		cCelular := Iif( Empty( SU5->U5_CELULAR ), '', '- Celular '   + RTrim( SU5->U5_CELULAR ) )
		cEmail   := Iif( Empty( SU5->U5_EMAIL )  , '', '- EMail '     + Lower( RTrim( SU5->U5_EMAIL ) ) )
	Else
		cFone    := Iif( Empty( a440SU5[ nPos, 2 ] ), '', '- Tel.Res. '  + RTrim( a440SU5[ nPos, 2 ] ) )
		cFCom1   := Iif( Empty( a440SU5[ nPos, 3 ] ), '', '- Tel.Com.1 ' + RTrim( a440SU5[ nPos, 3 ] ) )
		cCelular := Iif( Empty( a440SU5[ nPos, 4 ] ), '', '- Celular '   + RTrim( a440SU5[ nPos, 4 ] ) )
		cOutros  := Iif( Empty( a440SU5[ nPos, 5 ] ), '', '- Outros '    + RTrim( a440SU5[ nPos, 5 ] ) )
		cEmail   := Iif( Empty( a440SU5[ nPos, 6 ] ), '', '- EMail '     + Lower( RTrim( a440SU5[ nPos, 6 ] ) ) )
	Endif
	cU5_CONTAT := RTrim( SU5->U5_CONTAT ) + cDDD + cFone + cFCom1 + cCelular + cEmail
Return

//---------------------------------------------------------------------------------
// Rotina | A440GeraCont| Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para gravar a integração do SA1 com SU5 e AC8.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440GeraCont( aRet )
	Local cA1_CONTATO := Iif(aRet==NIL,SA1->A1_CONTATO,aRet[1])
	Local cA1_DDD     := Iif(aRet==NIL,SA1->A1_DDD    ,aRet[2])
	Local cA1_TEL     := Iif(aRet==NIL,SA1->A1_TEL    ,aRet[3])
	Local cA1_EMAIL   := Iif(aRet==NIL,SA1->A1_EMAIL  ,aRet[4])
	
	cU5_CODCONT := GetSXENum( "SU5", "U5_CODCONT" )
	ConfirmSX8()
	
	Begin Transaction
		SU5->( RecLock( 'SU5', .T. ) )
		SU5->U5_FILIAL  := xFilial('SU5')
		SU5->U5_CODCONT := cU5_CODCONT
		SU5->U5_CONTAT  := cA1_CONTATO
		SU5->U5_DDD     := cA1_DDD
		SU5->U5_FONE    := cA1_TEL
		SU5->U5_EMAIL   := cA1_EMAIL
		SU5->( MsUnLock() )
		
		AC8->( RecLock( 'AC8', .T. ) )
		AC8->AC8_FILIAL := xFilial( 'AC8' )
		AC8->AC8_FILENT := xFilial( 'SA1' )
		AC8->AC8_ENTIDA := 'SA1'
		AC8->AC8_CODENT := SA1->A1_COD + SA1->A1_LOJA
		AC8->AC8_CODCON := cU5_CODCONT
		AC8->( MsUnLock() )
		
		SA1->( RecLock( 'SA1', .F. ) )
		SA1->A1_CONTFIN := cU5_CODCONT
		SA1->( MsUnLock() )
	End Transaction
Return

//---------------------------------------------------------------------------------
// Rotina | A440Contato | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para criticar o código do contato.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Contato( cU5_CODCONT )
	Local lRet := ExistCpo( 'SU5', cU5_CODCONT )
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A440Motivo  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para criticar o código do motivo.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Motivo( nLigado, cCodMot, cDescMot, nTotal )
	Local lRet := .T.
	If Empty( cCodMot ) .And. nLigado==0
		lRet := .T.
	Else
		lRet := ExistCpo( 'SU9', cMV_440ASSU + cCodMot )
		If lRet
			cDescMot := Posicione( 'SU9', 1, xFilial( 'SU9' ) + cMV_440ASSU + cCodMot, 'U9_DESC' )
			If nTotal == 0
				MsgAlert('É obrigatório selecionar pelo menos um título.',cCadastro)
				lRet := .F.
			Endif
		Endif
	Endif	
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A440Previsao| Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para criticar a data de previsão de pagamento.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Previsao( dPrevisao )
	Local dMsDate := MsDate()
	Local lRet := .T.
	If Empty( dPrevisao )
		If MsgYesNo( 'A data de previsão para pagamento não foi informada. Quer informar agora?', cCadastro )
			lRet := .F.
		Else
			cACF_PREVIS := 'Não foi informado a data de previsão de pagamento.'
		Endif
	Else
		lRet := dPrevisao >= dMsDate
		If .NOT. lRet
			MsgAlert( 'A data de previsão para pagamento precisa ser maior ou igual a data de hoje: ' + Dtoc( dMsDate ), cCadastro )
		Endif
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A440Obs     | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para criticar se o campo observação foi preenchido.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Obs( cObs, cCodMot )
	Local lRet := .T.
	If Empty( cObs )
		lRet := .F.
		MsgAlert( 'O campo observação é de preenchimento obrigatório.', cCadastro)
	Endif	
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A440Gravar  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para gravar os dados da interação.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Gravar()
	Local nI := 0
	Local cTime       := Time()
	Local cU6_CODIGO  := ''
	Local cU4_LISTA   := ''
	Local nStack      := GetSX8Len()
	Local aSE1        := {}
	Local cACF_CODIGO := ''
	
	ProcRegua( 6 )
	IncProc('Gerando referências do contas a receber.')
	
	// Ler todos os títulos.
	For nI := 1 To Len( aTitMark )
		// Posicionar no registro do títulos.
		SE1->( dbGoto( aTitMark[ nI, 1 ] ) )
		
		// Pesquisar para saber se o título já foi para o telecobrança.
		SK1->( dbSetOrder( 1 ) )
		If SK1->( dbSeek( xFilial( 'SK1' ) + SE1->( E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_FILIAL ) ) )
			SK1->( RecLock( 'SK1', .F. ) )
			SK1->K1_VENCTO  := SE1->E1_VENCTO
			SK1->K1_VENCREA := SE1->E1_VENCREA
			SK1->K1_NATUREZ := SE1->E1_NATUREZ
			SK1->K1_PORTADO := SE1->E1_PORTADO
			SK1->K1_SITUACA := SE1->E1_SITUACA 
			SK1->K1_SALDO   := SE1->E1_SALDO
			SK1->K1_SALDEC  := 100000 - SE1->E1_SALDO
			SK1->( MsUnLock() )
		Else
			SK1->( RecLock( 'SK1', .T. ) )
			SK1->K1_FILIAL  := xFilial('SK1')
			SK1->K1_PREFIXO := SE1->E1_PREFIXO
			SK1->K1_NUM     := SE1->E1_NUM
			SK1->K1_PARCELA := SE1->E1_PARCELA
			SK1->K1_TIPO    := SE1->E1_TIPO
			SK1->K1_OPERAD  := c440Operador
			SK1->K1_VENCTO  := SE1->E1_VENCTO
			SK1->K1_VENCREA := SE1->E1_VENCREA
			SK1->K1_CLIENTE := SE1->E1_CLIENTE
			SK1->K1_LOJA    := SE1->E1_LOJA
			SK1->K1_NATUREZ := SE1->E1_NATUREZ
			SK1->K1_PORTADO := SE1->E1_PORTADO
			SK1->K1_SITUACA := SE1->E1_SITUACA 
			SK1->K1_SALDEC  := 100000 - SE1->E1_SALDO
			SK1->K1_FILORIG := SE1->E1_FILIAL
			SK1->K1_SALDO   := SE1->E1_SALDO
			SK1->( MsUnLock() )				
		Endif
		SE1->( AAdd( aSE1, { E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCTO, E1_VENCREAL, E1_VALOR } ) )
		
	Next nI
	
	IncProc('Gerando agenda do operador.')

	If Len( aSE1 ) > 0
		cU4_LISTA := GetSXENum('SU4','U4_LISTA')	
		While GetSX8Len() > nStack
			ConfirmSX8()
		End
	 	
	 	SU4->( dbSetOrder( 1 ) )
	 	SU4->( RecLock( 'SU4', .T. ) )
		SU4->U4_FILIAL  := xFilial( 'SU4' )
		SU4->U4_TIPO    := '2' //1=Marketing;2=Cobrança;3=Vendas;4=Teleatendimento.
		SU4->U4_STATUS  := '2' //1=Ativa;2=Encerrada;3=Em Andamento
		SU4->U4_LISTA   := cU4_LISTA
		SU4->U4_DESC    := 'LISTA DE COBRANCA GERADA AUTOMATICAMENTE PELA ROTINA CSFA441'
		SU4->U4_DATA    := dDataBase
		SU4->U4_DTEXPIR := dDataBase
		SU4->U4_HORA1   := cTime
		SU4->U4_FORMA   := '1' //1=Voz;2=Fax;3=CrossPosting;4=Mala Direta;5=Pendencia;6=WebSite.
		SU4->U4_TELE    := '3' //1=Telemarkeing;2=Televendas;3=Telecobrança;4=Todos;5=Teleatendimento.
		SU4->U4_OPERAD  := c440Operador
		SU4->U4_TIPOTEL := '4' //1=Residencial;2=Celular;3=Fax;4=Comercial 1;5=Comercial 2.
		SU4->U4_NIVEL   := '1' //1=Sim;2=Nao.
		SU4->U4_CODLIG  := ''
		SU4->U4_XDTVENC := dDataBase
		SU4->U4_XGRUPO  := SU7->( Posicione( 'SU7', 1, xFilial( 'SU7' ) + c440Operador, 'U7_POSTO' ) )
		SU4->( MsUnLock() )
		
		cU6_CODIGO := GetSXENum('SU6','U6_CODIGO')
		While GetSX8Len() > nStack 
			ConfirmSX8()
		End
		
	 	SU6->( dbSetOrder( 1 ) )
		SU6->( RecLock( 'SU6', .T. ) )
		SU6->U6_FILIAL  := xFilial('SU6')
		SU6->U6_LISTA   := cU4_LISTA
		SU6->U6_CODIGO  := cU6_CODIGO
		SU6->U6_CONTATO := cU5_CODCONT
		SU6->U6_ENTIDA  := 'SA1'
		SU6->U6_CODENT  := SA1->( A1_COD + A1_LOJA ) //oGride:aCOLS[ 1, nE1_CLIENTE ] + oGride:aCOLS[ 1, nE1_LOJA ]
		SU6->U6_ORIGEM  := '2' //1=Lista;2=Manual;3=Atendimento.
		SU6->U6_DATA    := dDataBase
		SU6->U6_HRINI   := cTime
		SU6->U6_HRFIM   := cTime
		SU6->U6_STATUS  := '3' //1=Nao Enviado;2=Em uso;3=Enviado.
		SU6->U6_CODLIG  := ''
		SU6->U6_DTBASE  := dDataBase
		SU6->U6_CODOPER := c440Operador
		SU6->( MsUnLock() )
	
		cACF_CODIGO := GetSXENum('ACF','ACF_CODIGO')
		While GetSX8Len() > nStack
			ConfirmSX8()
		End

		IncProc('Gerando registros do Telecobrança.')
		
		ACF->( dbSetOrder( 1 ) )
		ACF->( RecLock( 'ACF', .T. ) )
		ACF->ACF_FILIAL := xFilial( 'ACF' )
		ACF->ACF_CODIGO := cACF_CODIGO
		ACF->ACF_CLIENT := SA1->A1_COD //oGride:aCOLS[ 1, nE1_CLIENTE ]
		ACF->ACF_LOJA   := SA1->A1_LOJA //oGride:aCOLS[ 1, nE1_LOJA ]
		ACF->ACF_CODCON := cU5_CODCONT
		ACF->ACF_OPERAD := c440Operador
		ACF->ACF_OPERA  := '2' //1=Receptivo;2=Ativo
		ACF->ACF_STATUS := '2' //1=Atendimento;2=Cobranca;3=Encerrado
		ACF->ACF_MOTIVO := cACF_MOTIVO
		ACF->ACF_DATA   := dDataBase
		ACF->ACF_PENDEN := dDataBase
		ACF->ACF_HRPEND := cTime
		ACF->ACF_INICIO := cTime
		ACF->ACF_FIM    := cTime
		ACF->ACF_DIASDA := CtoD('01/01/2045') - dDataBase
		ACF->ACF_HORADA := 86400 - ( ( Val( Substr( cTime, 1, 2 ) ) * 3600 ) + ( Val( Substr( cTime, 4, 2 ) ) * 60 ) + Val( Substr( cTime, 7, 2 ) ) )
		ACF->ACF_ULTATE := dDataBase
		ACF->ACF_LISTA  := cU4_LISTA
		ACF->ACF_PREVIS := dACF_PREVIS
		cACF_OBS := cACF_OBS + CRLF + cACF_PREVIS
		MSMM(,TamSx3("ACF_OBS")[1],,cACF_OBS,1,,,"ACF","ACF_CODOBS")
		ACF->( MsUnLock() )
	
		For nI := 1 To Len( aSE1 )
			ACG->( RecLock( 'ACG', .T. ) )
			ACG->ACG_FILIAL := xFilial( 'ACG' )
			ACG->ACG_CODIGO := cACF_CODIGO
			ACG->ACG_PREFIX := aSE1[ nI, 1 ]
			ACG->ACG_TITULO := aSE1[ nI, 2 ]
			ACG->ACG_TIPO   := aSE1[ nI, 4 ]
			ACG->ACG_STATUS := '2' //1=Pago;2=Negociado;3=Cartorio;4=Baixa;5=Abatimento
			ACG->ACG_DTVENC := aSE1[ nI, 5 ]
			ACG->ACG_DTREAL := aSE1[ nI, 6 ]
			ACG->ACG_VALOR  := aSE1[ nI, 7 ]
			ACG->ACG_RECEBE := aSE1[ nI, 7 ]
			ACG->ACG_VALREF := aSE1[ nI, 7 ]
			ACG->ACG_FILORI := xFilial( 'SE1' )
			ACG->ACG_PARCEL := aSE1[ nI, 3 ]
			ACG->ACG_DIASAT := dDataBase - aSE1[ nI, 5 ]
			ACG->( MsUnLock() )
		Next nI
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440PodeUsar| Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para avaliar se pode ser executada a rotina na íntegra.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440PodeUsar()
	Local lRet := .T.
	Local cMV_440TPOC := ''
	Local cUX_CODTPO := ''
	Local nI := 0
	Local nJ := 0
	
	// Mudar o nível do campo para não haver manipulação do dado.
	SX3->( dbSetOrder( 2 ) )
	If SX3->( dbSeek( 'A1_CONTFIN' ) )
		If SX3->X3_NIVEL <> 9
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_NIVEL := 9
			SX3->( MsUnLock() )
		Endif
	Endif
	
	// Verificar se o parâmetro existe, do contrário cria-lo.
	cMV_440ASSU := 'MV_440ASSU'
	
	If .NOT. GetMv( cMV_440ASSU, .T. )
		CriarSX6( cMV_440ASSU, 'C', 'CODIGO DE ASSUNTO TELECOBRANCA', 'COB001' )
	Endif
	
	cMV_440ASSU := GetMv( 'MV_440ASSU', .F. )
	
	// Criar o código de assunto.
	SX5->( dbSetOrder( 1 ) )
	If .NOT. SX5->( dbSeek( xFilial( 'SX5' ) + 'T1' + cMV_440ASSU ) )
		SX5->( RecLock( 'SX5', .T. ) )
		SX5->X5_FILIAL  := xFilial( 'SX5' )
		SX5->X5_TABELA  := 'T1'
		SX5->X5_CHAVE   := cMV_440ASSU
		SX5->X5_DESCRI  := 'ASSUNTO PARA TELECOBRANCA'
		SX5->X5_DESCSPA := 'ASSUNTO PARA TELECOBRANCA'
		SX5->X5_DESCENG := 'ASSUNTO PARA TELECOBRANCA'
		SX5->( MsUnLock() )
	Endif
	
	// Verificar se o parâmetro existe, do contrário cria-lo.
	cMV_440TPOC := 'MV_440TPOC'
	
	If .NOT. GetMv( cMV_440TPOC, .T. )
		CriarSX6( cMV_440TPOC, 'C', 'CODIGO DO TIPO DE OCORRENCIA TELECOBRANCA', '' )
	Endif
	
	// Criar o tipo de ocorrência.
	If Empty( GetMv( 'MV_440TPOC', .F. ) ) 
		cUX_CODTPO := GetSXENum( 'SUX', 'UX_CODTPO' )
		ConfirmSX8()
		SUX->( dbSetOrder( 1 ) )
		SUX->( RecLock( 'SUX', .T. ) )
		SUX->UX_FILIAL := xFilial( 'SUX' )
		SUX->UX_CODTPO := cUX_CODTPO
		SUX->UX_DESTOC := 'TIPO DE OCORRENCIA TELECOBRANCA'
		SUX->UX_HABTXT := '1'
		SUX->( MsUnLock() )
		PutMv( cMV_440TPOC, cUX_CODTPO )
	Else
		cMV_440TPOC := GetMv( 'MV_440TPOC', .F. )
	Endif
	
   // Criticar se o operador existe.
	SU7->( dbSetOrder( 4 ) )
	If SU7->( dbSeek( xFilial( 'SU7' ) + __cUserId ) )
		If SU7->U7_TIPOATE $ '3|4' // 3=Telecobrança ou 4=todos.
			c440Operador := SU7->U7_COD
		Else
			lRet := .F.
			MsgAlert('Operador ' + RTrim( SU7->U7_NOME ) + ' sem perfil para acesso ao Telecobrança.', cCadastro )
		Endif
	Else
		lRet := .F.
		MsgAlert('Usuário ' + Upper( RTrim( UsrRetName( __cUserId ) ) ) + ' não está cadastrado como operador do Telecobrança.', cCadastro )
	Endif
	
	// Criticar caso não haja as ocorrências cadastradas.
	SU9->( dbSetOrder( 1 ) )
	If .NOT. SU9->( dbSeek( xFilial( 'SU9' ) + cMV_440ASSU ) )
		lRet := .F.
		MsgAlert( 'Não foi localizado código do motivo de ocorrências para o Telecobrança conforme assunto de cobrança '+cMV_440ASSU+;
		          ' e tipo de assunto '+cMV_440TPOC+', por favor fazer o cadastro.', cCadastro )
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A441Trigger | Autor | Rafael Beghini               | Data | 17.09.2018
//---------------------------------------------------------------------------------
// Descr. | Gatilho no preenchimento do campo E1_VENCTO
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A441Trigger()
	Local oModel	 	:= FWModelActive()	//-- Captura Model Ativa
	Local oModelGrid	:= oModel:GetModel( 'MdGridTRB' )
	Local dData 		:= oModelGrid:GetValue( 'E1_VENCTO' )
	Local dNewDt		:= DataValida( dData, .T. )

	oModelGrid:SetValue('E1_VENCREA',dNewDt)
Return( dNewDt )

//---------------------------------------------------------------------------------
// Rotina | A440Relat   | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para gerar o relatório de atendimento por período.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Relat( cOpcao )
	Local aSAY	:= {}
    Local aBTN  := {}
    Local aPAR  := {}
    Local nOpc  := 0

    Private aRET := {}
    Private cTRB := ''
    Private cTitulo := '[CSFA441] - Registro(s) Telecobrança'

	aADD( aSAY, 'Rotina para gerar relatório em formato XML com dados registrados do Telecobrança.' )
	aADD( aSAY, IIF( cOpcao == '1', 'Nesta opção será filtrado o cliente ' + SA1->A1_NREDUZ, '' ) )
	aADD( aSAY, '' )
	aADD( aSAY, 'Clique em OK para prosseguir...' )
	
	aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch(cTitulo, aSAY, aBTN )

    IF nOpc == 1
        aAdd( aPAR, {9, "Informe o período de busca",200,7,.T.})
	    aAdd( aPAR, {1, "Data de"	 , Ctod(Space(8)), "","",""   ,"",0,.F.})
	    aAdd( aPAR, {1, "Data ate"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})
	    aAdd( aPAR, {1, "Ocorrência" , Space(6), "","","440SU9"   ,"",0,.F.})
		
        IF ParamBox(aPAR,cTitulo,@aRET)
            A010Proc( aRET, @cOpcao )
        Else
            MsgInfo('Processo cancelado',cTitulo)
        EndIF
    EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | A010Proc | Autor | Rafael Beghini | Data | 21.09.2018 
//+-------------------------------------------------------------------+
//| Descr. | Apresenta a tela de processamento
//+-------------------------------------------------------------------+
Static Function A010Proc( aRET, cOpcao )
    Local oDlg   := Nil
    Local oSay   := Nil
    Local oMeter := Nil
    Local nMeter := 0

    Define Dialog oDlg Title cTitulo From 0,0 To 70,380 Pixel
        @05,05  Say oSay Prompt "Aguarde, montando a query conforme parâmetros informados." Of oDlg Pixel Colors CLR_RED,CLR_WHITE Size 185,20
        @15,05  Meter oMeter Var nMeter Pixel Size 160,10 Of oDlg
        @13,170 BITMAP Resource "PCOIMG32.PNG" SIZE 015,015 OF oDlg NOBORDER PIXEL
    Activate Dialog oDlg Centered On Init ( IIF( A010Qry( aRET, @cOpcao ), A010Imp(oDlg, oSay, oMeter), NIL ), oDlg:End() )
    
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Qry | Autor | Rafael Beghini | Data | 21.09.2018 
//+-------------------------------------------------------------------+
//| Descr. | Monta a query conforme parâmetros
//+-------------------------------------------------------------------+
Static Function A010Qry( aRET, cOpcao )
    Local cSQL   := ''
    Local cCount := ''
    Local lRet   := .T.

    cSQL += "SELECT ACF_DATA, " + CRLF
	cSQL += "       ACF_HRPEND, " + CRLF
	cSQL += "       ACF_CODIGO, " + CRLF
	cSQL += "       ACG_PREFIX, " + CRLF
	cSQL += "       ACG_TITULO, " + CRLF
	cSQL += "       ACG_PARCEL, " + CRLF
	cSQL += "       ACG_TIPO, " + CRLF
	cSQL += "       ACF_CLIENT, " + CRLF
	cSQL += "       A1_NOME, " + CRLF
	cSQL += "       E1_EMISSAO, " + CRLF
	cSQL += "       ACG_DTVENC, " + CRLF
	cSQL += "       ACG_VALOR, " + CRLF
	cSQL += "       ACF_PREVIS, " + CRLF
	cSQL += "       ACG_DIASAT, " + CRLF
	cSQL += "       ACF_MOTIVO, " + CRLF
	cSQL += "       U9_DESC, " + CRLF
	cSQL += "       ACF_CODOBS " + CRLF
	cSQL += "FROM   " + RetSqlName("ACF") + " ACF " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SA1") + " SA1 " + CRLF
	cSQL += "               ON A1_FILIAL = '" + xFilial("SA1") + "' " + CRLF
	cSQL += "                  AND A1_COD  = ACF_CLIENT " + CRLF
	cSQL += "                  AND A1_LOJA = ACF_LOJA " + CRLF
	cSQL += "                  AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("ACG") + " ACG " + CRLF
	cSQL += "               ON ACG_FILIAL = '" + xFilial("ACG") + "' " + CRLF
	cSQL += "                  AND ACG_CODIGO = ACF_CODIGO " + CRLF
	cSQL += "                  AND ACG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SU9") + " SU9 " + CRLF
	cSQL += "               ON U9_FILIAL = '" + xFilial("SU9") + "' " + CRLF
	cSQL += "                  AND U9_ASSUNTO = '" + cMV_440ASSU + "' " + CRLF
	cSQL += "                  AND U9_CODIGO = ACF_MOTIVO " + CRLF
	cSQL += "                  AND SU9.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SE1") + " SE1 " + CRLF
	cSQL += "               ON E1_FILIAL = '" + xFilial("SE1") + "' " + CRLF
	cSQL += "                  AND E1_PREFIXO = ACG_PREFIX " + CRLF
	cSQL += "                  AND E1_NUM = ACG_TITULO " + CRLF
	cSQL += "                  AND E1_PARCELA = ACG_PARCEL " + CRLF
	cSQL += "                  AND E1_TIPO = ACG_TIPO " + CRLF
	cSQL += "                  AND E1_CLIENTE = ACF_CLIENT " + CRLF
	cSQL += "                  AND E1_LOJA = ACF_LOJA " + CRLF
	cSQL += "                  AND SE1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  ACF_FILIAL = '" + xFilial("ACF") + "' " + CRLF
	cSQL += "		AND ACF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND ACF_DATA >= '" +  DtoS( aRet[ 2 ] ) + "' " + CRLF
	cSQL += "       AND ACF_DATA <= '" +  DtoS( aRet[ 3 ] ) + "' " + CRLF
	IF cOpcao == '1'
		cSQL += "AND ACF_CLIENT = '" + SA1->A1_COD  + "' " + CRLF
		cSQL += "AND ACF_LOJA   = '" + SA1->A1_LOJA + "' " + CRLF
	EndIF
	IF .NOT. Empty( aRet[ 4 ] )
		cSQL += "AND ACF_MOTIVO = '" + aRet[ 4 ]  + "' " + CRLF
	EndIF

	cSQL += " AND ACF_CODOBS NOT IN ('9ZNOA1''9ZTDPL','9ZTDSH','9ZTE5I','9ZTE8H','9ZTEBM') "

    cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	cCount := ' SELECT COUNT(*) COUNT FROM ( ' + cSQL + ' ) QUERY '
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCount),cTRB,.F.,.T.)
	nREGISTROS := (cTRB)->COUNT
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

    TcSetField( cTRB, "ACF_DATA"   	, "D", 8 )
    TcSetField( cTRB, "E1_EMISSAO"  , "D", 8 )
    TcSetField( cTRB, "ACG_DTVENC"	, "D", 8 )

    IF (cTRB)->( EOF() )
        lRet := .F.    
        (cTRB)->( dbCloseArea() )
	    FErase( cTRB + GetDBExtension() )
        MsgInfo('Não há dados para extração conforme parâmetros informados.',cTitulo)
    EndIF
Return( lRet )
//+-------------------------------------------------------------------+
//| Rotina | CSFIN040 | Autor | Rafael Beghini | Data | 12.07.2018 
//+-------------------------------------------------------------------+
//| Descr. | Gera o relatório no formato .XML
//+-------------------------------------------------------------------+
Static Function A010Imp(oDlg, oSay, oMeter)
    Local nSeconds    := 0
    Local nCount      := 0
    Local nLastUpdate := 0
    Local cWorkSheet  := 'Telecobrança'
	Local cTable      := 'Registro(s) telecobrança - período [' + dTOC( aRET[ 2 ] ) + ' - ' + dTOC( aRET[ 3 ] ) + ']'
	Local cPath       := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile   := cPath + 'telecobrança' + dTos(Date()) + ".XML"
	Local oExcel      := FWMSEXCEL():New() //Método para geração em XML
	Local cTexto	  := ''
    
    oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >           , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "DtAtend"					, 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "HrAtend"                 , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Prefixo"                 , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Título"                  , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Parcela"                 , 1     , 1      , .F. )  
	oExcel:AddColumn( cWorkSheet, cTable, "Tp"                      , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Código"                  , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nome cliente"            , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Emissão"                 , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vencimento"              , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor"                   , 1     , 3      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Prev Pagamento"          , 1     , 4      , .F. )   
	oExcel:AddColumn( cWorkSheet, cTable, "Atraso"                  , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Motivo"                  , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"               , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Texto do atendendimento" , 1     , 1      , .F. )
	
    //nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada

    oMeter:SetTotal(nREGISTROS)
    nSeconds := Seconds()

    oSay:SetText("Aguarde, montando o relatório. Total de registro(s): " + AllTrim( Str(nREGISTROS) ) )

    (cTRB)->( dbGotop() )
    While .NOT. (cTRB)->( EOF() )
        nCount++
        IF (Seconds() - nLastUpdate) > 1 // Se passou 1 segundo desde a última atualização da tela
            oMeter:Set(nCount)
            oDlg:CommitControls() // Para atualizar a tela e o usuário receber o feedback

            nLastUpdate := Seconds()
        EndIf

		cTexto := A440TextObs( cTRB )

        oExcel:AddRow( cWorkSheet, cTable, { (cTRB)->ACF_DATA,;
                                                (cTRB)->ACF_HRPEND,;
                                                (cTRB)->ACG_PREFIX,;
                                                (cTRB)->ACG_TITULO,;
                                                (cTRB)->ACG_PARCEL,;
                                                (cTRB)->ACG_TIPO,;
                                                (cTRB)->ACF_CLIENT,;
                                                (cTRB)->A1_NOME,;
                                                (cTRB)->E1_EMISSAO,;
                                                (cTRB)->ACG_DTVENC,;
                                                (cTRB)->ACG_VALOR,;
                                                (cTRB)->ACF_PREVIS,;
                                                (cTRB)->ACG_DIASAT,;
                                                (cTRB)->ACF_MOTIVO,;
                                                (cTRB)->U9_DESC,;
                                                cValToChar(cTexto) } )
        (cTRB)->( dbSkip() )
    End

    (cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )

    oMeter:Set(nCount) // Efetua uma atualização final para garantir que o usuário veja o resultado do processamento
    oDlg:CommitControls() // Para atualizar a tela e o usuário receber o feedback
    
    oExcel:Activate() //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
	
	ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela após salvar
Return

//---------------------------------------------------------------------------------
// Rotina | A440TextObs | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para buscar o texto do atendimento.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440TextObs( cTRB )
	Local cTexto := ''
	Local nP := 0
	SYP->( dbSetOrder( 1 ) )
	SYP->( dbSeek( xFilial( 'SYP' ) + (cTRB)->ACF_CODOBS ) )
	While (.NOT. SYP->( EOF() ) ) .AND. SYP->YP_FILIAL == xFilial( 'SYP' ) .AND. SYP->YP_CHAVE == (cTRB)->ACF_CODOBS
		nP := At( '\13\10', SYP->YP_TEXTO )
		If nP > 0
			cTexto += RTrim( SubStr( SYP->YP_TEXTO, 1, nP-1 ) )
		Else
			nP := At( '\14\10', SYP->YP_TEXTO )
			If nP > 0
				cTexto += StrTran( SYP->YP_TEXTO, '\14\10', Space( 6 ) )
			Else
				cTexto += RTrim( SYP->YP_TEXTO )
			Endif
		Endif
		Exit
		//SYP->( dbSkip() )
	End
Return( cTexto )


//---------------------------------------------------------------------------------
// Rotina | A440Inadim  | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para buscar registro da tabela de inadimplentes.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440Inadim()
	Local oDlg
	Local oLbx 
	Local oPnl
	Local oCons
	Local oSair 
	Local cKey := ''
	Local aRecNo := {}
	Local aArea			:= GetArea()
	Local oModel		:= FWModelActive()	//-- Captura Model Ativa
	Local oModelGrid	:= oModel:GetModel( 'MdGridTRB' )
	Local cCliente 		:= SA1->A1_COD
	Local cLoja    		:= SA1->A1_LOJA
	Local cPrefixo 		:= oModelGrid:GetValue( 'E1_PREFIXO' )
	Local cNum     		:= oModelGrid:GetValue( 'E1_NUM' 	 )
	Local cParcela 		:= oModelGrid:GetValue( 'E1_PARCELA' )
	Local cTipo    		:= oModelGrid:GetValue( 'E1_TIPO' 	 )
	
	cKey := xFilial( 'PAM' ) + cCLiente + cLoja + cPrefixo + cNum + cParcela + cTipo 
	
	PAM->( dbSetOrder( 3 ) ) 
	PAM->( dbSeek( cKey ) )
	While ( .NOT. PAM->( EOF() ) ) .AND. PAM->PAM_FILIAL == xFilial( 'PAM' ) .AND. ;
		PAM->PAM_CLIENT == cCliente .AND. PAM->PAM_LOJA == cLoja .AND. PAM->PAM_PREFIX == cPrefixo .AND. ;
		PAM->PAM_NUM == cNum .AND. PAM->PAM_PARCEL == cParcela .AND. PAM->PAM_TIPO == cTipo
		PAM->( AAdd( aRecNo, { PAM_DTENV, PAM_HRENV, PAM_ENVMAI, RecNo() } ) )	
      PAM->( dbSkip() )
 	End
 	
 	If Len( aRecNo ) == 0
 		MsgAlert( 'O título em questão não está registrado nos controles do envio de email para inadimplentes.', cCadastro )
 	Else
 		If Len( aRecNo ) == 1
 			A440VisInad( aRecNo[ 1, 4 ] )
 		Else
 			ASort( aRecNo, , ,{ |a,b| DtoS( a[ 1 ] ) + a[ 2 ] < DtoS( b[ 1 ] ) + b[ 2 ] } )
			DEFINE MSDIALOG oDlg TITLE 'QUAL REGISTRO DE INADIMPLENTES QUER CONSULTAR?' FROM 0,0 TO 200,400 PIXEL
			   oLbx := TwBrowse():New(0,0,0,0,,{'DT. do Envio','HR. do Envio','Qt Email Env'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
			   oLbx:SetArray( aRecNo )
				oLbx:bLine := {|| { aRecNo[ oLbx:nAt, 1 ], aRecNo[ oLbx:nAt, 2 ], aRecNo[ oLbx:nAt, 3 ] } }
				oLbx:bLDblClick := {||  A440VisInad( aRecNo[ oLbx:nAt, 4 ] ) }
				oPnl := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
				oPnl:Align := CONTROL_ALIGN_BOTTOM
				@ 1, 1 BUTTON oCons PROMPT 'Consultar' SIZE 40,11 PIXEL OF oPnl ACTION A440VisInad( aRecNo[ oLbx:nAt, 4 ] )
				@ 1,44 BUTTON oSair PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPnl ACTION oDlg:End()
			ACTIVATE MSDIALOG oDlg CENTER
 		Endif
 	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A440VisInad | Autor | Robson Gonçalves              | Data | 29/10/2014
//---------------------------------------------------------------------------------
// Descr. | Rotina para consultar na íntegra os dados do registro de inadimplentes.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A440VisInad( nRecNo )
	PAM->( dbGoTo( nRecNo ) )
	INCLUI := .F.
	ALTERA := .F.
	AxVisual( 'PAM', nRecNo, 2 )
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} A441Leg
Função para apresentar a legenda no Browse
@author Rafael Beghini
@since  Setembro/2019
@version P12
/*/
//-------------------------------------------------------------------
User Function A441Leg()
	Local cSQL	:= ''
	Local cTRB	:= ''
	Local cRet	:= ''

	cSQL := "SELECT * "
	cSQL += "FROM   " + RetSqlName( 'SE1' ) + " SE1 "
	cSQL += "WHERE    SE1.E1_FILIAL = '" + FwxFilial("SE1") + "' " 
	cSQL += " AND SE1.E1_CLIENTE = '" + SA1->A1_COD  + "' " 
	cSQL += " AND SE1.E1_LOJA    = '" + SA1->A1_LOJA + "' " 
	cSQL += "         AND SE1.E1_SALDO > 0 "
	cSQL += "         AND ( SE1.E1_TIPO = 'CH ' OR SE1.E1_TIPO = 'DP ' OR SE1.E1_TIPO = 'FT ' OR SE1.E1_TIPO = 'NF ' OR SE1.E1_TIPO = 'NDC' ) "
	cSQL += "         AND SE1.D_E_L_E_T_ = ' ' "	
	cSQL += "         AND ROWNUM = 1 "	

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
	IF (cTRB)->( Eof() )
		cRet := '0'
	Else
		cRet := '1'
	EndIF
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )	
Return( cRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} A441Imp
Função imprimir os dados sem o filtro do cliente (Browse)
@author Rafael Beghini
@since  Setembro/2019
@version P12
/*/
//-------------------------------------------------------------------
User Function A441Imp()
	A440Relat('0')
Return