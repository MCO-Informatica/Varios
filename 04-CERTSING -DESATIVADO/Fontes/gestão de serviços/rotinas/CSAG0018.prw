#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

User Function CSAG0018()

Local oBrowsePA4 := NIL
	
Private aRotina := MenuDef()
	
oBrowsePA4:= FWmBrowse():New()
oBrowsePA4:SetDescription( 'Regiões' )
oBrowsePA4:SetAlias( 'PA4' )
oBrowsePA4:SetMenuDef( 'CSAG0018' )		
oBrowsePA4:SetProfileID( '1' )
oBrowsePA4:Activate()                                 
	
Return

Static Function MenuDef() // Criação do Menu Funcional

Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar" 		ACTION 'PESQBRW'					OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar"   	ACTION "VIEWDEF.CSAG0018"			OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"   		ACTION "VIEWDEF.CSAG0018"			OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"			ACTION "VIEWDEF.CSAG0018"			OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Excluir"			ACTION "VIEWDEF.CSAG0018"			OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()

Local oStruPA4 := FWFormStruct(1,'PA4')
Local oModel

oModel := MPFormModel():New('CSAGPA4',,,)

oModel:AddFields('PA4MASTER',/*cOwner*/,oStruPA4)

oModel:SetPrimaryKey({'PA4_FILIAL','PA4_REGIAO'})

oModel:SetDescription('Regiões de Atendimento')

oModel:GetModel('PA4MASTER'):SetDescription('Regiões de Atendimento')

Return oModel

Static Function ViewDef()

Local oModel := FWLoadModel('CSAG0018')
Local oStruPA4:= FWFormStruct(2,'PA4')
Local oViewDef:= FWFormView():New()

oViewDef:SetModel(oModel)

oViewDef:AddField('VIEW_PA4',oStruPA4,'PA4MASTER')

oViewDef:CreateHorixontalBox('UP',100)

oViewDef:SetOwnerView('VIEW_PA4','UP')

Return oViewDef