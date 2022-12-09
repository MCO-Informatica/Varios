#Include 'Protheus.ch'
#Include 'Fwmvcdef.ch'

User Function VNDA670()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('PAQ')
	oBrowse:SetDescription('Cadastro de AC x AR')
	oBrowse:SetMenuDef("VNDA670")
	oBrowse:DisableDetails()
	oBrowse:Activate()

Return(nil)

Static Function MenuDef()

Return FWMVCMenu( "VNDA670" )

Static Function ModelDef()
	Local oStruPAQ := FWFormStruct( 1, 'PAQ' )
	Local oStruPAR := FWFormStruct( 1, 'PAR' )
	Local oModel

	oModel := MPFormModel():New( 'VNDA670M' )
	oModel:AddFields( 'PAQMASTER', /*cOwner*/, oStruPAQ )
	oModel:AddGrid( 'PARDETAIL', 'PAQMASTER', oStruPAR )
	oModel:SetRelation( 'PARDETAIL', { { 'PAR_FILIAL', 'xFilial( "PAR" )' }, {'PAR_CODAC', 'PAQ_CODAC' } }, PAR->( IndexKey( 1 ) ) )
	oModel:SetDescription( 'Cadastro de AC x AR' )
	oModel:GetModel( 'PAQMASTER' ):SetDescription( 'AC' )
	oModel:GetModel( 'PARDETAIL' ):SetDescription( 'AR' )
	oModel:GetModel( 'PARDETAIL' ):SetUniqueLine( { 'PAR_CODAR' } )
	oModel:SetPrimaryKey( { "PAQ_FILIAL", "PAQ_CODAC" } )


Return oModel

Static Function ViewDef()
	Local oModel 	:= FWLoadModel( 'VNDA670' )
	Local oView 	:= FWFormView():New()
	Local oStruPAQ 	:= FWFormStruct( 2, 'PAQ' )
	Local oStruPAR 	:= FWFormStruct( 2, 'PAR' )

	oStruPAR:RemoveField('PAR_CODAC')

	oView:SetModel( oModel )
	oView:AddField( 'VIEW_PAQ', oStruPAQ, 'PAQMASTER' )
	oView:AddGrid( 'VIEW_PAR', oStruPAR, 'PARDETAIL' )
	oView:CreateHorizontalBox( 'SUPERIOR', 15 )
	oView:CreateHorizontalBox( 'INFERIOR', 85 )
	oView:SetOwnerView( 'VIEW_PAQ', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_PAR', 'INFERIOR' )
	oView:AddIncrementField( 'VIEW_PAR', 'PAR_CODAR' )
	oView:EnableTitleView('VIEW_PAR')

Return oView