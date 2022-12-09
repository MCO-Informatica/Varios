#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

User Function CSAG0017(oBrowse,oCalend)

Local oBrowsePAY := NIL
	
Private aRotina := MenuDef()
	
oBrowsePAY:= FWmBrowse():New()
oBrowsePAY:SetDescription( 'Exeções de Atendimento' )
oBrowsePAY:SetAlias( 'PAY' )
oBrowsePAY:SetMenuDef( 'CSAG0017' )
oBrowsePAY:SetProfileID( '1' )
oBrowsePAY:Activate()

oBrowse:Refresh()
oCalend:Refresh()                                 
	
Return

Static Function MenuDef() // Criação do Menu Funcional

Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar" 		ACTION 'PESQBRW'					OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar"   	ACTION "VIEWDEF.CSAG0017"			OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"   		ACTION "VIEWDEF.CSAG0017"			OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"			ACTION "VIEWDEF.CSAG0017"			OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Cancelar"			ACTION "VIEWDEF.CSAG0017"			OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()

Local oStruPAY := FWFormStruct(1,'PAY')
Local oModel

oModel := MPFormModel():New('CSAGPAY',,,)

oModel:AddFields('PAYMASTER',/*cOwner*/,oStruPAY)

oModel:SetPrimaryKey({'PAY_FILIAL','PAY_COD'})

oModel:SetDescription('Exeções de Atendimento')

oModel:GetModel('PAYMASTER'):SetDescription('Exeções de Atendimento')

Return oModel

Static Function ViewDef()

Local oModel := FWLoadModel('CSAG0017')
Local oStruPAY:= FWFormStruct(2,'PAY')
Local oViewDef:= FWFormView():New()

oViewDef:SetModel(oModel)

oViewDef:AddField('VIEW_PAY',oStruPAY,'PAYMASTER')

oViewDef:CreateHorixontalBox('UP',100)

oViewDef:SetOwnerView('VIEW_PAY','UP')


Return oViewDef
