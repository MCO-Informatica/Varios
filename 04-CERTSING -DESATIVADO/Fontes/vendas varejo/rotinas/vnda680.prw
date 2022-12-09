#Include 'Protheus.ch'
#Include 'Fwmvcdef.ch'

User Function VNDA680()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('PAS')
	oBrowse:SetDescription('Cadastro de Postos Físicos')
	oBrowse:SetMenuDef("VNDA680")
	oBrowse:DisableDetails()
	oBrowse:Activate()

Return(nil)

Static Function MenuDef()

Return FWMVCMenu( "VNDA680" )

Static Function ModelDef()
	Local oStruPAS := FWFormStruct( 1, 'PAS' )
	Local oStruPAT := FWFormStruct( 1, 'PAT' )
	Local oModel

	oStruPAT:AddField( ;
                        AllTrim('') , ; 			// [01] C Titulo do campo
                        AllTrim('') , ; 			// [02] C ToolTip do campo
                        'PAT_LEGEND' , ;            // [03] C identificador (ID) do Field
                        'C' , ;                     // [04] C Tipo do campo
                        50 , ;                      // [05] N Tamanho do campo
                        0 , ;                       // [06] N Decimal do campo
                        NIL , ;                     // [07] B Code-block de validação do campo
                        NIL , ;                     // [08] B Code-block de validação When do campo
                        NIL , ;                     // [09] A Lista de valores permitido do campo
                        NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatório
                        { || v680Leg('PAT_CODSZ3') } , ;  		// [11] B Code-block de inicializacao do campo
                        NIL , ;                     // [12] L Indica se trata de um campo chave
                        NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
                        .T. )                       // [14] L Indica se o campo é virtual


	oModel := MPFormModel():New( 'VNDA680M' )
	oModel:AddFields( 'PASMASTER', /*cOwner*/, oStruPAS )
	oModel:AddGrid( 'PATDETAIL', 'PASMASTER', oStruPAT  )
	oModel:SetRelation( 'PATDETAIL', { { 'PAT_FILIAL', 'xFilial( "PAT" )' }, {'PAT_CODAC', 'PAS_CODAC' }, {'PAT_CODAR', 'PAS_CODAR' }, {'PAT_CODPOS', 'PAS_CODPOS' } }, PAT->( IndexKey( 1 ) ) )
	oModel:SetDescription( 'Cadastro de AC x AR' )
	oModel:GetModel( 'PASMASTER' ):SetDescription( 'Posto Fisico' )
	oModel:GetModel( 'PATDETAIL' ):SetDescription( 'Posto Virtual' )
	oModel:GetModel( 'PATDETAIL' ):SetUniqueLine( { 'PAT_CODSZ3' } )
	oModel:SetPrimaryKey( { "PAS_FILIAL", "PAS_CODAC", "PAS_CODAR", "PAS_CODPOS"  } )

Return oModel

Static Function ViewDef()
	Local oModel 	:= FWLoadModel( 'VNDA680' )
	Local oView 	:= FWFormView():New()
	Local oStruPAS 	:= FWFormStruct( 2, 'PAS' )
	Local oStruPAT 	:= FWFormStruct( 2, 'PAT' )

	oStruPAT:AddField( ;                                                            // Ord. Tipo Desc.
                       'PAT_LEGEND' , ;                    // [01] C Nome do Campo
                       '00' , ;                         // [02] C Ordem
                       AllTrim('') , ;				   	// [03] C Titulo do campo
                       AllTrim( 'Teste Bitmap' ) , ;   	// [04] C Descrição do campo
                       { 'teste bitmap' } , ;           // [05] A Array com Help
                       'C' , ;                          // [06] C Tipo do campo
                       '@BMP' , ;                       // [07] C Picture
                       NIL , ;                          // [08] B Bloco de Picture Var
                       '' , ;                           // [09] C Consulta F3
                       .F. , ;                          // [10] L Indica se o campo é evitável
                       NIL , ;                          // [11] C Pasta do campo
                       NIL , ;                          // [12] C Agrupamento do campo
                       NIL , ;                          // [13] A Lista de valores permitido do campo (Combo)
                       NIL , ;                          // [14] N Tamanho Maximo da maior opção do combo
                       NIL , ;                          // [15] C Inicializador de Browse
                       .T. , ;                          // [16] L Indica se o campo é virtual
                       NIL )                            // [17] C Picture Variável


	oStruPAT:RemoveField('PAT_CODAC')
	oStruPAT:RemoveField('PAT_CODAR')
	oStruPAT:RemoveField('PAT_CODPOS')

	oView:SetModel( oModel )
	oView:AddField( 'VIEW_PAS', oStruPAS, 'PASMASTER' )
	oView:AddGrid( 'VIEW_PAT', oStruPAT, 'PATDETAIL' )
	oView:CreateHorizontalBox( 'SUPERIOR', 30 )
	oView:CreateHorizontalBox( 'INFERIOR', 70 )
	oView:SetOwnerView( 'VIEW_PAS', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_PAT', 'INFERIOR' )
	oView:AddIncrementField( 'VIEW_PAT', 'PAT_SEQPTV' )
	oView:EnableTitleView('VIEW_PAT')

Return oView

Static Function v680leg(cCampo)

Local oModel		:= FWModelActive()
Local cValor 		:= ""
Local cRet			:= "BR_VERDE"

IF INCLUI
	cValor:= " "
Else
	If cCampo == "PAT_CODSZ3"
		cValor := Posicione("SZ3",4,xFilial("SZ3")+PAT->PAT_CODSZ3,"Z3_ATIVO")
	EndIf
Endif

If oModel:GetOperation() <> MODEL_OPERATION_DELETE
	If  cCampo == "PAT_CODSZ3"
		If cValor == 'S'
			cRet := "BR_VERDE"
		ElseIf cValor == 'N'
			cRet := "BR_VERMELHO"
		Else
			cRet := "BR_GREY"
		Endif
	EndIf
EndIf

Return cRet