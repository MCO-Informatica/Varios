#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

Static cTitulo := "Cadastro de Área para Gestão de Contratos"

/*/{Protheus.doc} CSCNT002
Rotina Cadastro de Área para Gestão de Contratos -
@author Luciano A Oliveira
@since 09/09/2020
@version 1.0
	@return Nil, Função não tem retorno
	u_CSCNT002()
	@obs Não se pode executar função MVC dentro do fórmulas
/*/
User Function CSCNT002()
	Local oBrowse
	
	oBrowse := FWMBrowse():New()
	
	oBrowse:SetAlias("SX5")
	oBrowse:SetDescription(cTitulo)
	
	oBrowse:SetFilterDefault( "X5_TABELA == 'Z5'" )
	oBrowse:Activate()
	
Return Nil

Static Function MenuDef()
	Local aRot := {}
	
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CSCNT002' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.CSCNT002' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.CSCNT002' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
Return aRot

Static Function ModelDef()
    Local oModel := Nil
    Local oStPai 	:= FWFormStruct(1,'SX5')
	
	oStPai:SetProperty('X5_TABELA', MODEL_FIELD_INIT,{||'Z5'})
	oStPai:SetProperty('X5_TABELA', MODEL_FIELD_VALID,{||IIF(INCLUI, PERTENCE("Z5"),.T.)})
	oStPai:SetProperty('X5_CHAVE', MODEL_FIELD_INIT,{||IIF(INCLUI,u_CSCNT003(),.T.)})
	
	
	oModel := MPFormModel():New('zMVCSX5')
	oModel:AddFields('SX5MASTER',/*cOwner*/,oStPai)
		
	oModel:SetDescription("Cadastro de Área Responsável")
	oModel:GetModel('SX5MASTER'):SetDescription("Cadastro")
	

   oModel:SetPrimaryKey({'X5_FILIAL','X5_TABELA','X5_CHAVE'})
    	
Return oModel

Static Function ViewDef()
	Local oModel	:= FWLoadModel("CSCNT002")
    Local oView
	Local oStPai	:= FWFormStruct(2,'SX5')

    oStPai:SetProperty( 'X5_TABELA' , MVC_VIEW_CANCHANGE,.F.)
	oStPai:SetProperty( 'X5_CHAVE' , MVC_VIEW_CANCHANGE,.F.)
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField('VIEW_SX5',oStPai,'SX5MASTER')
	oView:CreateHorizontalBox('CABEC',100)
		
	oView:SetOwnerView('VIEW_SX5','CABEC')
	oView:SetCloseOnOk({||.T.})
	oView:EnableTitleView('VIEW_SX5','Dados da Área Responsável')
	
Return oView


