#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

//----------------------------------------------------------------//
/*/{Protheus.doc} DHESTA01
//TODO Função para controlar os números de séries dos produtos.
@author Claudio Macedo
@since 21/12/2021
@version 1.0
/*/
//----------------------------------------------------------------//
User Function DHESTA01()

Local oBrowse := FwMBrowse():New()

oBrowse:SetAlias('SZ4')
oBrowse:SetDescription('Número de Série')

oBrowse:Activate()

Return Nil

//----------------------------------------------------------------//
/*/{Protheus.doc} MenuDef
//TODO MenuDef.
@author Claudio Macedo
@since 21/12/2021
@version 1.0
/*/
//----------------------------------------------------------------//
Static Function MenuDef()

Local aRotina := FWMVCMenu("DHESTA01")

ADD OPTION aRotina TITLE "Importar Planilha" ACTION "U_DHESTA02"  OPERATION 3  ACCESS 0

Return (aRotina)

//----------------------------------------------------------------//
/*/{Protheus.doc} ModelDef
//TODO ModelDef.
@author Claudio Macedo
@since 21/12/2021
@version 1.0
/*/
//----------------------------------------------------------------//
Static Function ModelDef()

Local oModel   := MPFormModel():New('ESTA01M')
Local oStruSZ4 := FwFormStruct(1, 'SZ4')

oStruSZ4:AddTrigger( "Z4_CODIGO" , ;                                                  // [01] Id do campo de origem
	                 "Z4_DESCRI" , ;                                                  // [02] Id do campo de destino
	                 {||.T.} , ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
	                 {||Posicione('SB1',1,xFilial('SB1') + M->Z4_CODIGO,'B1_DESC')})  // [04] Bloco de codigo de execução do gatilho

oModel:AddFields("SZ4MASTER", NIL, oStruSZ4)

oModel:SetPrimaryKey({'Z4_FILIAL', 'Z4_NUMSERI', 'Z4_CODIGO'}) 

oModel:SetDescription("Número de Série")

oModel:GetModel("SZ4MASTER"):SetDescription("Número de Série")

Return (oModel)

//----------------------------------------------------------------//
/*/{Protheus.doc} ViewDef
//TODO ViewDef.
@author Claudio Macedo
@since 21/12/2021
@version 1.0
/*/
//----------------------------------------------------------------//
Static Function ViewDef()

Local oView    := FwFormView():New()
Local oStruSZ4 := FwFormStruct(2, "SZ4")
Local oModel   := FwLoadModel("DHESTA01")

oView:SetModel(oModel)

oView:AddField("VIEW_SZ4", oStruSZ4, "SZ4MASTER")

oView:CreateHorizontalBox('TELA', 100)

oView:SetOwnerView("VIEW_SZ4", "TELA")

oView:EnableTitleView("VIEW_SZ4")

Return (oView)

